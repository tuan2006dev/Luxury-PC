package poly.edu.controller.web;

import jakarta.servlet.http.HttpSession;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import poly.edu.entity.CartItem;

import java.util.Map;

@ControllerAdvice
public class GlobalControllerAdvice {

    private final poly.edu.service.ProfileService profileService;

    public GlobalControllerAdvice(poly.edu.service.ProfileService profileService) {
        this.profileService = profileService;
    }

    @ModelAttribute
    public void addGlobalAttributes(jakarta.servlet.http.HttpServletRequest request, HttpSession session, Model model) {
        model.addAttribute("requestURI", request.getRequestURI());
        // Lấy giỏ hàng từ session
        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        
        int cartCount = 0;
        if (cart != null) {
            cartCount = cart.size();
        }
        
        model.addAttribute("cartCount", cartCount);

        org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getName())) {
            try {
                poly.edu.entity.User user = profileService.getCurrentUser(auth);
                model.addAttribute("currentUser", user);
            } catch (Exception e) {
                // Ignore
            }
        }
    }
}
