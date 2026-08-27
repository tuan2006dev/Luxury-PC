package poly.edu.controller.api;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import poly.edu.dao.UserDAO;
import poly.edu.entity.User;
import poly.edu.security.CustomOAuth2User;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthStatusApiController {

    private final UserDAO userDAO;

    @GetMapping("/check-status")
    public ResponseEntity<Map<String, Object>> checkUserStatus(Authentication authentication) {
        Map<String, Object> response = new HashMap<>();

        if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getPrincipal())) {
            response.put("authenticated", false);
            response.put("locked", false);
            return ResponseEntity.ok(response);
        }

        String emailOrUsername = authentication.getName();
        Object principalObj = authentication.getPrincipal();
        if (principalObj instanceof CustomOAuth2User customOAuth2User) {
            if (customOAuth2User.getEmail() != null) {
                emailOrUsername = customOAuth2User.getEmail();
            }
        } else if (principalObj instanceof org.springframework.security.oauth2.core.user.OAuth2User oauth2User) {
            Object emailAttr = oauth2User.getAttribute("email");
            if (emailAttr != null) {
                emailOrUsername = emailAttr.toString();
            }
        }

        if (emailOrUsername != null && !emailOrUsername.isBlank()) {
            String cleanName = emailOrUsername.trim().toLowerCase();
            User user = userDAO.findByEmailWithRoles(cleanName);
            if (user == null) {
                user = userDAO.findByUsernameWithRoles(cleanName);
            }
            if (user == null) {
                user = userDAO.findByEmailWithRoles(emailOrUsername);
            }
            if (user == null) {
                user = userDAO.findByUsernameWithRoles(emailOrUsername);
            }

            if (user != null) {
                if (Boolean.FALSE.equals(user.getStatus())) {
                    response.put("authenticated", false);
                    response.put("locked", true);
                    response.put("message", "Tài khoản của bạn đã bị khóa bởi Quản trị viên.");
                    return ResponseEntity.status(401).body(response);
                }
                response.put("fullName", user.getFullName() != null && !user.getFullName().isBlank() ? user.getFullName() : user.getUsername());
                response.put("username", user.getUsername());
                response.put("email", user.getEmail() != null ? user.getEmail() : "");
            }
        }

        response.put("authenticated", true);
        response.put("locked", false);
        return ResponseEntity.ok(response);
    }
}
