package poly.edu.controller.web;

import lombok.RequiredArgsConstructor;
import jakarta.servlet.http.HttpSession;

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
import poly.edu.service.SePayPaymentSession;
import poly.edu.service.ProfileService;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;


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
        if (!sePayProperties.hasBankConfiguration()) {
            throw new IllegalStateException("SePay bank configuration is missing");
        }

        long amount = Math.round(order.getTotalPrice());
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

        return "payment-vietqr";
    }

    private User currentUser() {
        try {
            return profileService.getCurrentUser(SecurityContextHolder.getContext().getAuthentication());
        } catch (IllegalStateException exception) {
            return null;
        }
    }
}