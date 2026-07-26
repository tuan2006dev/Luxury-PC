package poly.edu.controller.api;

import jakarta.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import poly.edu.dao.OrderDAO;
import poly.edu.dto.VietQrPaymentStatusResponse;
import poly.edu.entity.Order;
import poly.edu.entity.User;
import poly.edu.entity.VietQrPaymentSession;
import poly.edu.service.ProfileService;
import poly.edu.service.SePayPaymentSession;

import java.time.Instant;

@RestController
@RequestMapping("/api/payments/vietqr")
public class VietQrPaymentStatusController {

    private final OrderDAO orderDAO;
    private final SePayPaymentSession sePayPaymentSession;
    private final ProfileService profileService;

    public VietQrPaymentStatusController(
            OrderDAO orderDAO,
            SePayPaymentSession sePayPaymentSession,
            ProfileService profileService) {
        this.orderDAO = orderDAO;
        this.sePayPaymentSession = sePayPaymentSession;
        this.profileService = profileService;
    }

    @GetMapping("/status")
    public VietQrPaymentStatusResponse status(
            @RequestParam String orderCode,
            @RequestHeader(value = "X-Payment-Token", required = false) String paymentToken,
            HttpSession session,
            Authentication authentication) {
        if (!sePayPaymentSession.matches(session, orderCode, paymentToken)) {
            throw new PaymentStatusForbiddenException();
        }

        Order order = orderDAO.findByOrderCode(orderCode).orElseThrow(PaymentStatusForbiddenException::new);
        User currentUser = currentUser(authentication);
        if (!"VIETQR".equals(order.getPaymentMethod())
                || order.getUser() == null
                || currentUser == null
                || !currentUser.getId().equals(order.getUser().getId())) {
            throw new PaymentStatusForbiddenException();
        }

        Instant serverTime = Instant.now();
        VietQrPaymentSession paymentSession = sePayPaymentSession.current(order.getId(), serverTime)
                .orElseThrow(PaymentStatusForbiddenException::new);
        boolean paid = "DA_THANH_TOAN".equals(order.getStatus()) || "PAID".equals(order.getStatus());
        boolean expired = !paid && SePayPaymentSession.isExpired(paymentSession, serverTime);
        return new VietQrPaymentStatusResponse(
                order.getOrderCode(),
                order.getStatus(),
                order.getStatusDisplay(),
                paid,
                serverTime,
                paymentSession.getQrCreatedAt(),
                paymentSession.getQrExpiresAt(),
                expired ? 0 : SePayPaymentSession.remainingSeconds(paymentSession, serverTime),
                expired);
    }

    private User currentUser(Authentication authentication) {
        try {
            return profileService.getCurrentUser(authentication);
        } catch (IllegalStateException exception) {
            return null;
        }
    }

    @ResponseStatus(HttpStatus.FORBIDDEN)
    static class PaymentStatusForbiddenException extends RuntimeException {
    }
}
