package poly.edu.controller.web;

import lombok.RequiredArgsConstructor;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import poly.edu.dao.OrderDAO;
import poly.edu.entity.Order;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Optional;

@Controller
@RequiredArgsConstructor
public class PaymentController {

    private static final String BANK_ID = "MB";
    private static final String BANK_DISPLAY_NAME = "MB Bank";
    private static final String ACCOUNT_NO = "9999999999";
    private static final String ACCOUNT_NAME = "LUXURYPC";
    private static final long FALLBACK_AMOUNT = 150_000L;

    private final OrderDAO orderDAO;

    @GetMapping("/payment/vietqr")
    public String vietQrPayment(
            @RequestParam(value = "amount", required = false) Long requestedAmount,
            @RequestParam(value = "orderCode", required = false) String requestedOrderCode,
            Model model,
            HttpSession session) {
        Object sessionAmount = session.getAttribute("vietQrAmount");
        Object sessionOrderCode = session.getAttribute("vietQrOrderCode");

        long amount = requestedAmount != null && requestedAmount > 0
                ? requestedAmount
                : sessionAmount instanceof Number
                ? ((Number) sessionAmount).longValue()
                : FALLBACK_AMOUNT;
        String orderCode = requestedOrderCode != null && !requestedOrderCode.isBlank()
                ? requestedOrderCode
                : sessionOrderCode instanceof String
                ? (String) sessionOrderCode
                : "DH" + System.currentTimeMillis();
        String paymentStatus = "Chờ xác nhận thanh toán";

        Optional<Order> order = orderDAO.findByOrderCode(orderCode);
        if (order.isPresent()) {
            amount = Math.round(order.get().getTotalPrice());
            paymentStatus = order.get().getStatusDisplay();
        }
        String transferContent = "THANH TOAN " + orderCode;

        String encodedInfo = URLEncoder.encode(transferContent, StandardCharsets.UTF_8);
        String encodedName = URLEncoder.encode(ACCOUNT_NAME, StandardCharsets.UTF_8);

        String qrUrl = "https://img.vietqr.io/image/"
                + BANK_ID + "-"
                + ACCOUNT_NO + "-"
                + "compact.png"
                + "?amount=" + amount
                + "&addInfo=" + encodedInfo
                + "&accountName=" + encodedName;

        model.addAttribute("amount", amount);
        model.addAttribute("orderCode", orderCode);
        model.addAttribute("transferContent", transferContent);
        model.addAttribute("bankId", BANK_ID);
        model.addAttribute("bankDisplayName", BANK_DISPLAY_NAME);
        model.addAttribute("accountNo", ACCOUNT_NO);
        model.addAttribute("accountName", ACCOUNT_NAME);
        model.addAttribute("qrUrl", qrUrl);
        model.addAttribute("paymentStatus", paymentStatus);

        return "payment-vietqr";
    }
}
