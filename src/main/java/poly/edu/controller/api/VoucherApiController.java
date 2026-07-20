package poly.edu.controller.api;

import lombok.RequiredArgsConstructor;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import poly.edu.entity.CartItem;
import poly.edu.entity.User;
import poly.edu.service.FlashSaleService;
import poly.edu.service.ProfileService;
import poly.edu.service.VoucherService;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/voucher")
@RequiredArgsConstructor
public class VoucherApiController {

    private final VoucherService voucherService;

    private final ProfileService profileService;

    private final FlashSaleService flashSaleService;

    /**
     * AJAX endpoint: validate mã voucher
     * POST /api/voucher/validate?code={code}
     * Lấy user từ Spring Security Authentication thay vì session attribute
     */
    @PostMapping("/validate")
    public Map<String, Object> validateVoucher(
            @RequestParam String code,
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

        return voucherService.validateVoucher(code, cartTotal, user);
    }

    /**
     * API endpoint to delete voucher
     * DELETE /api/voucher/delete/{id}
     * POST /api/voucher/delete/{id}
     */
    @DeleteMapping("/delete/{id}")
    public Map<String, Object> deleteVoucherApi(@PathVariable("id") Integer id) {
        voucherService.deleteVoucher(id);
        Map<String, Object> resp = new java.util.HashMap<>();
        resp.put("success", true);
        resp.put("message", "Đã xóa voucher thành công!");
        return resp;
    }

    @PostMapping("/delete/{id}")
    public Map<String, Object> deleteVoucherApiPost(@PathVariable("id") Integer id) {
        return deleteVoucherApi(id);
    }
}
