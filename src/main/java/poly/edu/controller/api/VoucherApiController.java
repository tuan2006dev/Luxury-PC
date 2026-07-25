package poly.edu.controller.api;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import poly.edu.entity.AdminLog;
import poly.edu.entity.CartItem;
import poly.edu.entity.User;
import poly.edu.entity.Voucher;
import poly.edu.repository.AdminLogRepository;
import poly.edu.service.FlashSaleService;
import poly.edu.service.ProfileService;
import poly.edu.service.VoucherService;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/voucher")
@RequiredArgsConstructor
public class VoucherApiController {

    private final VoucherService voucherService;

    private final ProfileService profileService;

    private final FlashSaleService flashSaleService;

    private final AdminLogRepository adminLogRepository;

    /**
     * AJAX endpoint: validate mã voucher
     * POST /api/voucher/validate?code={code}
     * Lấy user từ Spring Security Authentication thay vì session attribute
     */
    @PostMapping("/validate")
    public Map<String, Object> validateVoucher(
            @RequestParam String code,
            @RequestParam(required = false, defaultValue = "0") Double shippingFee,
            HttpSession session,
            Authentication authentication) {

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> buyNowCart = (Map<Integer, CartItem>) session.getAttribute("buyNowCart");
        Map<Integer, CartItem> targetCart = (buyNowCart != null && !buyNowCart.isEmpty()) ? buyNowCart : cart;

        double cartTotal = 0;
        if (targetCart != null) {
            cartTotal = targetCart.values().stream()
                    .mapToDouble(item -> item.getPrice() * item.getQuantity())
                    .sum();
        }

        // Ưu tiên lấy user từ Spring Security session
        User user = null;
        if (authentication != null && authentication.isAuthenticated()
                && !"anonymousUser".equals(String.valueOf(authentication.getPrincipal()))) {
            user = profileService.getCurrentUser(authentication);
        }

        return voucherService.validateVoucher(code, cartTotal, shippingFee, targetCart != null ? targetCart.values() : null, user);
    }

    /**
     * AJAX endpoint: validate combo 2 mã voucher (Mã giảm giá + Mã Freeship)
     * POST /api/voucher/validate-combo
     */
    @PostMapping("/validate-combo")
    public Map<String, Object> validateVoucherCombo(
            @RequestParam(required = false) String code,
            @RequestParam(required = false) String freeshipCode,
            @RequestParam(required = false, defaultValue = "0") Double shippingFee,
            HttpSession session,
            Authentication authentication) {

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> buyNowCart = (Map<Integer, CartItem>) session.getAttribute("buyNowCart");
        Map<Integer, CartItem> targetCart = (buyNowCart != null && !buyNowCart.isEmpty()) ? buyNowCart : cart;

        double cartTotal = 0;
        if (targetCart != null) {
            cartTotal = targetCart.values().stream()
                    .mapToDouble(item -> item.getPrice() * item.getQuantity())
                    .sum();
        }

        User user = null;
        if (authentication != null && authentication.isAuthenticated()
                && !"anonymousUser".equals(String.valueOf(authentication.getPrincipal()))) {
            user = profileService.getCurrentUser(authentication);
        }

        return voucherService.validateVoucherCombo(code, freeshipCode, cartTotal, shippingFee, targetCart != null ? targetCart.values() : null, user);
    }

    /**
     * API endpoint to delete voucher
     * DELETE /api/voucher/delete/{id}
     * POST /api/voucher/delete/{id}
     */
    @DeleteMapping("/delete/{id}")
    public Map<String, Object> deleteVoucherApi(
            @PathVariable("id") Integer id,
            Principal principal,
            HttpServletRequest request) {

        Voucher v = voucherService.getById(id);
        String code = v != null ? v.getCode() : "Voucher #" + id;

        voucherService.deleteVoucher(id);
        logAction(principal, request, "Xóa Voucher", code);

        Map<String, Object> resp = new HashMap<>();
        resp.put("success", true);
        resp.put("message", "Đã xóa voucher thành công!");
        return resp;
    }

    @PostMapping("/delete/{id}")
    public Map<String, Object> deleteVoucherApiPost(
            @PathVariable("id") Integer id,
            Principal principal,
            HttpServletRequest request) {
        return deleteVoucherApi(id, principal, request);
    }

    private void logAction(Principal principal, HttpServletRequest request, String action, String targetUser) {
        try {
            String username = principal != null ? principal.getName() : "STAFF";
            String ip = request.getHeader("X-Forwarded-For");
            if (ip == null || ip.isBlank() || "unknown".equalsIgnoreCase(ip)) {
                ip = request.getRemoteAddr();
            }
            adminLogRepository.save(new AdminLog(username, action, ip, targetUser));
        } catch (Exception e) {
            // Ignore logging errors
        }
    }
}
