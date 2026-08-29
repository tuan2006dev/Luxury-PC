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

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;


@Controller
@RequiredArgsConstructor
public class PaymentController {

    private final OrderDAO orderDAO;
    private final ProfileService profileService;
    private final SePayProperties sePayProperties;
    private final SePayPaymentSession sePayPaymentSession;
    private final poly.edu.service.OrderService orderService;

    @GetMapping("/payment/vietqr")
    public String vietQrPayment(
            @RequestParam(value = "amount", required = false) Long requestedAmount,
            @RequestParam(value = "orderCode", required = false) String requestedOrderCode,
            Model model,
            HttpSession session) {
        if (requestedOrderCode == null || requestedOrderCode.isBlank()) {
            throw new AccessDeniedException("Missing VietQR order");
        }

        Order order = orderDAO.findByOrderCode(requestedOrderCode.trim())
                .orElseThrow(() -> new AccessDeniedException("Order not found"));

        User user = currentUser();
        if (order.getUser() != null) {
            if (user == null || !order.getUser().getId().equals(user.getId())) {
                throw new AccessDeniedException("Access denied to order " + requestedOrderCode);
            }
        }

        if (!"VIETQR".equalsIgnoreCase(order.getPaymentMethod()) && !"SEPAY".equalsIgnoreCase(order.getPaymentMethod())) {
            throw new AccessDeniedException("Order is not a VietQR payment");
        }
        if (!"CHO_XAC_NHAN_THANH_TOAN".equals(order.getStatus()) && !"PENDING".equals(order.getStatus())) {
            throw new AccessDeniedException("VietQR order is not awaiting payment");
        }

        long amount = exactOrderAmount(order);
        if (requestedAmount != null && requestedAmount != amount) {
            throw new AccessDeniedException("VietQR payment amount mismatch");
        }

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
        model.addAttribute("orderId", order.getId());
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

    @org.springframework.web.bind.annotation.PostMapping("/api/payments/vietqr/cancel")
    @org.springframework.web.bind.annotation.ResponseBody
    public org.springframework.http.ResponseEntity<java.util.Map<String, Object>> cancelVietQrPayment(
            HttpSession session,
            @RequestParam("orderCode") String orderCode,
            @org.springframework.web.bind.annotation.RequestHeader(value = "X-Payment-Token", required = false) String token) {

        java.util.Map<String, Object> res = new java.util.HashMap<>();
        if (!sePayPaymentSession.matches(session, orderCode, token)) {
            res.put("success", false);
            res.put("message", "Token không hợp lệ");
            return org.springframework.http.ResponseEntity.status(org.springframework.http.HttpStatus.UNAUTHORIZED).body(res);
        }

        java.util.Optional<Order> oOpt = orderDAO.findByOrderCode(orderCode);
        if (oOpt.isPresent()) {
            Order order = oOpt.get();
            String st = order.getStatus();
            if ("PENDING".equals(st) || "CHO_XAC_NHAN_THANH_TOAN".equals(st) || "UNPAID".equals(st)) {
                try {
                    orderService.cancelOrderByUser(order.getId(), order.getUser() != null ? order.getUser().getId() : null);
                } catch (Exception e) {
                    order.setStatus("DA_HUY");
                    orderDAO.save(order);
                }
                res.put("success", true);
                res.put("message", "Đã hủy thanh toán đơn hàng do hết thời gian 5 phút.");
                return org.springframework.http.ResponseEntity.ok(res);
            }
        }
        res.put("success", false);
        res.put("message", "Đơn hàng không ở trạng thái chờ thanh toán");
        return org.springframework.http.ResponseEntity.badRequest().body(res);
    }

    private long exactOrderAmount(Order order) {
        return toExactVndAmount(order.getTotalPrice());
    }

    private long toExactVndAmount(Double totalPrice) {
        if (totalPrice == null || !Double.isFinite(totalPrice) || totalPrice <= 0) {
            throw new IllegalStateException("Order total is invalid");
        }
        return Math.round(totalPrice);
    }

    private User currentUser() {
        try {
            return profileService.getCurrentUser(SecurityContextHolder.getContext().getAuthentication());
        } catch (IllegalStateException exception) {
            return null;
        }
    }
}
