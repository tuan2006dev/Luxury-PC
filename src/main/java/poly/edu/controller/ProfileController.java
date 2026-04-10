package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import poly.edu.entity.User;
import poly.edu.repository.UserRepository;
import poly.edu.dao.OrderDAO;

import java.util.Map;
import java.util.Optional;

@Controller
public class ProfileController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private OrderDAO orderDAO;

    @GetMapping("/profile")
    public String profile(
            @AuthenticationPrincipal Object principal,
            Model model
    ) {

        String usernameOrEmail = "";

        // login google
        if (principal instanceof OAuth2User oauthUser) {
            Map<String, Object> attr = oauthUser.getAttributes();
            usernameOrEmail = (String) attr.get("email");
        }
        // login thường
        else if (principal instanceof org.springframework.security.core.userdetails.User user) {
            usernameOrEmail = user.getUsername();
        }

        // Fetch User from DB so we have phone, address, etc.
        Optional<User> userOptional = userRepository.findByEmail(usernameOrEmail);
        if (userOptional.isEmpty()) {
            userOptional = userRepository.findByUsername(usernameOrEmail);
        }

        if (userOptional.isPresent()) {
            User u = userOptional.get();
            model.addAttribute("user", u);
            // also set basic things for fallback
            model.addAttribute("name", u.getFullName() != null && !u.getFullName().isEmpty() ? u.getFullName() : u.getUsername());
            model.addAttribute("email", u.getEmail());
            
            // extract initial for avatar
            String initial = "U";
            if (u.getFullName() != null && !u.getFullName().isEmpty()) {
                String[] parts = u.getFullName().split(" ");
                if (parts.length > 0) {
                    initial = parts[parts.length - 1].substring(0, 1).toUpperCase();
                }
            } else if (u.getUsername() != null && !u.getUsername().isEmpty()) {
                initial = u.getUsername().substring(0, 1).toUpperCase();
            }
            model.addAttribute("avatarInitial", initial);

            // CALCULATE TOTALS AND RANK
            Double totalSpent = orderDAO.getTotalSpentByUser(u.getId());
            if (totalSpent == null) totalSpent = 0.0;
            
            Long totalOrders = orderDAO.countOrdersByUser(u.getId());
            if (totalOrders == null) totalOrders = 0L;

            String rank = "None";
            String rankClass = "rank-none";
            if (totalSpent >= 200_000_000) {
                rank = "Diamond";
                rankClass = "rank-diamond";
            } else if (totalSpent >= 50_000_000) {
                rank = "Platinum";
                rankClass = "rank-platinum";
            } else if (totalSpent >= 10_000_000) {
                rank = "Silver";
                rankClass = "rank-silver";
            }

            model.addAttribute("totalSpent", totalSpent);
            model.addAttribute("totalOrders", totalOrders);
            model.addAttribute("userRank", rank);
            model.addAttribute("rankClass", rankClass);
            
            // Lịch sử đơn hàng
            java.util.List<poly.edu.entity.Order> userOrders = orderDAO.findByUserIdOrderByCreatedAtDesc(u.getId());
            model.addAttribute("orders", userOrders);

        } else {
            // fallback
            model.addAttribute("name", usernameOrEmail);
            model.addAttribute("email", usernameOrEmail);
            model.addAttribute("avatarInitial", "U");
            model.addAttribute("totalSpent", 0.0);
            model.addAttribute("totalOrders", 0L);
            model.addAttribute("userRank", "None");
            model.addAttribute("rankClass", "rank-none");
            model.addAttribute("orders", new java.util.ArrayList<>());
        }

        return "account/profile";  // Use the new Khang template path which is under account/profile.html inside templates
    }
}


