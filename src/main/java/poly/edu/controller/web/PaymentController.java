package poly.edu.controller.web;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import poly.edu.config.SePayProperties;
import poly.edu.dao.OrderDAO;
import poly.edu.entity.Order;
import poly.edu.entity.User;
import poly.edu.entity.VietQrPaymentSession;
import poly.edu.service.ProfileService;
import poly.edu.service.SePayPaymentSession;

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.Instant;

@Controller
@RequiredArgsConstructor
public class PaymentController {

    private final OrderDAO orderDAO;
    private final ProfileService profileService;
    private final SePayProperties sePayProperties;
    private final SePayPaymentSession sePayPaymentSession;

    @GetMapping("/payment/vietqr")
    public String vietQrPayment(
            @RequestParam(value = "amount", required = false) Long requestedAmount,
            @RequestParam(value = "orderCode", required = false) String requestedOrderCode,
            @RequestParam(value = "renew", defaultValue = "false") boolean renew,
            Model model,
            HttpSession session) {
        if (requestedOrderCode == null || requestedOrderCode.isBlank()) {
            throw new AccessDeniedException("Missing VietQR order");
        }

        Order order = orderDAO.findByOrderCode(requestedOrderCode)
                .orElseThrow(() -> new AccessDeniedException("Unknown VietQR order"));
        User currentUser = currentUser();
        if (currentUser == null || order.getUser() == null
                || !currentUser.getId().equals(order.getUser().getId())) {
            throw new AccessDeniedException("VietQR order does not belong to the current user");
        }

        if (!"VIETQR".equals(order.getPaymentMethod())) {
            throw new AccessDeniedException("Order is not a VietQR payment");
        }
        if (!"CHO_XAC_NHAN_THANH_TOAN".equals(order.getStatus())) {
            throw new AccessDeniedException("VietQR order is not awaiting payment");
        }
        if (!sePayProperties.hasBankConfiguration()) {
            throw new IllegalStateException("SePay bank configuration is missing");
        }

        Instant serverTime = Instant.now();
        SePayPaymentSession.PaymentWindow paymentWindow = renew
                ? sePayPaymentSession.renew(order.getId(), serverTime)
                : sePayPaymentSession.currentOrCreate(order.getId(), serverTime);
        if (renew) {
            if (paymentWindow.created()) {
                sePayPaymentSession.replaceToken(session, order.getOrderCode());
            }
            // Remove renew=true so a browser reload cannot create another ten-minute session.
            return "redirect:/payment/vietqr?orderCode="
                    + URLEncoder.encode(order.getOrderCode(), StandardCharsets.UTF_8);
        }

        VietQrPaymentSession qrSession = paymentWindow.session();
        boolean expired = SePayPaymentSession.isExpired(qrSession, serverTime);
        long remainingSeconds = SePayPaymentSession.remainingSeconds(qrSession, serverTime);
        long amount = exactOrderAmount(order);
        String orderCode = order.getOrderCode();
        String transferContent = "SEVQR " + sePayProperties.getPaymentCode().getPrefix() + order.getId();
        String encodedInfo = URLEncoder.encode(transferContent, StandardCharsets.UTF_8);
        String encodedName = URLEncoder.encode(sePayProperties.getBank().getAccountName(), StandardCharsets.UTF_8);
        String qrUrl = "https://img.vietqr.io/image/"
                + sePayProperties.getBank().getId() + "-"
                + sePayProperties.getBank().getAccountNumber() + "-"
                + "compact.png"
                + "?amount=" + amount
                + "&addInfo=" + encodedInfo
                + "&accountName=" + encodedName;

        model.addAttribute("amount", amount);
        model.addAttribute("orderCode", orderCode);
        model.addAttribute("transferContent", transferContent);
        model.addAttribute("bankId", sePayProperties.getBank().getId());
        model.addAttribute("bankDisplayName", sePayProperties.getBank().getDisplayName());
        model.addAttribute("accountNo", sePayProperties.getBank().getAccountNumber());
        model.addAttribute("accountName", sePayProperties.getBank().getAccountName());
        model.addAttribute("qrUrl", qrUrl);
        model.addAttribute("paymentStatus", order.getStatusDisplay());
        model.addAttribute("paymentToken", sePayPaymentSession.issueToken(session, orderCode));
        model.addAttribute("serverTime", serverTime);
        model.addAttribute("qrCreatedAt", qrSession.getQrCreatedAt());
        model.addAttribute("expiresAt", qrSession.getQrExpiresAt());
        model.addAttribute("remainingSeconds", remainingSeconds);
        model.addAttribute("countdownText", formatCountdown(remainingSeconds));
        model.addAttribute("qrExpired", expired);

        return "payment-vietqr";
    }

    private long exactOrderAmount(Order order) {
        Double totalPrice = order.getTotalPrice();
        if (totalPrice == null || !Double.isFinite(totalPrice) || totalPrice <= 0) {
            throw new IllegalStateException("Order total is invalid");
        }
        try {
            return BigDecimal.valueOf(totalPrice).longValueExact();
        } catch (ArithmeticException exception) {
            throw new IllegalStateException("Order total is not an exact VND amount", exception);
        }
    }

    private String formatCountdown(long remainingSeconds) {
        return String.format("%02d:%02d", remainingSeconds / 60, remainingSeconds % 60);
    }

    private User currentUser() {
        try {
            return profileService.getCurrentUser(SecurityContextHolder.getContext().getAuthentication());
        } catch (IllegalStateException exception) {
            return null;
        }
    }
}
