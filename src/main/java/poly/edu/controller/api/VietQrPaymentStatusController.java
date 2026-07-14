package poly.edu.controller.api;

import jakarta.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import poly.edu.dao.OrderDAO;
import poly.edu.dto.VietQrPaymentStatusResponse;
import poly.edu.entity.Order;
import poly.edu.service.SePayPaymentSession;

@RestController
@RequestMapping("/api/payments/vietqr")
public class VietQrPaymentStatusController {

    private final OrderDAO orderDAO;
    private final SePayPaymentSession sePayPaymentSession;

    public VietQrPaymentStatusController(OrderDAO orderDAO, SePayPaymentSession sePayPaymentSession) {
        this.orderDAO = orderDAO;
        this.sePayPaymentSession = sePayPaymentSession;
    }

    @GetMapping("/status")
    public VietQrPaymentStatusResponse status(
            @RequestParam String orderCode,
            @RequestHeader(value = "X-Payment-Token", required = false) String paymentToken,
            HttpSession session) {
        if (!sePayPaymentSession.matches(session, orderCode, paymentToken)) {
            throw new PaymentStatusForbiddenException();
        }

        Order order = orderDAO.findByOrderCode(orderCode).orElseThrow(PaymentStatusForbiddenException::new);
        boolean paid = "DA_THANH_TOAN".equals(order.getStatus()) || "PAID".equals(order.getStatus());
        return new VietQrPaymentStatusResponse(order.getOrderCode(), order.getStatusDisplay(), paid);
    }

    @ResponseStatus(HttpStatus.FORBIDDEN)
    private static class PaymentStatusForbiddenException extends RuntimeException {
    }
}
