package poly.edu.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import poly.edu.entity.CartItem;

import java.util.Map;

@ControllerAdvice
public class GlobalControllerAdvice {

    @ModelAttribute
    public void addGlobalAttributes(HttpSession session, Model model) {
        // Lấy giỏ hàng từ session
        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        
        int cartCount = 0;
        if (cart != null) {
            cartCount = cart.values().stream().mapToInt(CartItem::getQuantity).sum();
        }
        
        model.addAttribute("cartCount", cartCount);
    }
}
