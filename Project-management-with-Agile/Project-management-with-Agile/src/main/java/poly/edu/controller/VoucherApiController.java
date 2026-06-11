package poly.edu.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import poly.edu.entity.CartItem;
import poly.edu.service.VoucherService;

import java.util.Collection;
import java.util.Map;

@RestController
@RequestMapping("/api/voucher")
public class VoucherApiController {

    @Autowired
    private VoucherService voucherService;

    /**
     * AJAX endpoint: validate mã voucher
     * POST /api/voucher/validate?code=XXX
     */
    @PostMapping("/validate")
    public Map<String, Object> validateVoucher(
            @RequestParam String code,
            HttpSession session) {

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

        double cartTotal = 0;
        if (cart != null) {
            cartTotal = cart.values().stream()
                    .mapToDouble(item -> item.getPrice() * item.getQuantity())
                    .sum();
        }

        poly.edu.entity.User user = (poly.edu.entity.User) session.getAttribute("user");
        return voucherService.validateVoucher(code, cartTotal, user);
    }
}
