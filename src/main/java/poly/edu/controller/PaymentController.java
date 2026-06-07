package poly.edu.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
public class PaymentController {

    private static final String BANK_ID = "MB";
    private static final String ACCOUNT_NO = "66112126666999";
    private static final String ACCOUNT_NAME = "NGUYEN TRUONG QUAN";
    private static final long FALLBACK_AMOUNT = 150_000L;

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
        model.addAttribute("accountNo", ACCOUNT_NO);
        model.addAttribute("accountName", ACCOUNT_NAME);
        model.addAttribute("qrUrl", qrUrl);

        return "payment-vietqr";
    }
}
