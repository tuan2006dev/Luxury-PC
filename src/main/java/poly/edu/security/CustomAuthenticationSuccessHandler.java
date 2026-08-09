package poly.edu.security;

import lombok.RequiredArgsConstructor;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import poly.edu.dao.UserDAO;
import poly.edu.entity.User;
import poly.edu.service.EmailService;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private final UserDAO userDAO;

    private final EmailService emailService;

    private final poly.edu.service.CartService cartService;

    private final poly.edu.repository.AdminLogRepository adminLogRepository;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
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

        User user = null;
        if (emailOrUsername != null && !emailOrUsername.isBlank()) {
            user = userDAO.findByEmailWithRoles(emailOrUsername);
            if (user == null) {
                user = userDAO.findByUsernameWithRoles(emailOrUsername);
            }
        }

        // Ghi nhận Audit Log Đăng nhập cho Nhân viên (STAFF) và Admin
        if (user != null) {
            boolean isStaffOrAdmin = user.getUserRoles() != null && user.getUserRoles().stream()
                    .anyMatch(ur -> ur.getRole() != null &&
                            ("STAFF".equalsIgnoreCase(ur.getRole().getName()) || "ADMIN".equalsIgnoreCase(ur.getRole().getName())));
            if (isStaffOrAdmin) {
                String clientIp = request.getHeader("X-Forwarded-For");
                if (clientIp == null || clientIp.isBlank() || "unknown".equalsIgnoreCase(clientIp)) {
                    clientIp = request.getRemoteAddr();
                }
                String roleStr = user.getUserRoles().stream()
                        .map(ur -> ur.getRole() != null ? ur.getRole().getName() : "")
                        .filter(r -> !r.isBlank())
                        .collect(java.util.stream.Collectors.joining(", "));
                try {
                    String usernameToLog = user.getUsername() != null && !user.getUsername().isBlank() ? user.getUsername() : user.getEmail();
                    adminLogRepository.save(new poly.edu.entity.AdminLog(
                            usernameToLog != null ? usernameToLog : "unknown",
                            "Đăng nhập hệ thống (Role: " + (roleStr.isBlank() ? "STAFF" : roleStr) + ")",
                            clientIp,
                            usernameToLog
                    ));
                } catch (Exception ignored) {}
            }
        }

        // 1. Kiểm tra tài khoản bị khóa/vô hiệu hóa
        if (user != null && Boolean.FALSE.equals(user.getStatus())) {
            SecurityContextHolder.clearContext();
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("SPRING_SECURITY_CONTEXT");
                session.invalidate();
            }
            response.sendRedirect("/auth/login?error=disabled");
            return;
        }

        // 2. Yêu cầu khởi tạo mật khẩu lần đầu qua Google/Facebook
        if (user != null && (Boolean.TRUE.equals(user.getForceChangePassword()) || user.getPassword() == null || user.getPassword().isBlank())) {
            HttpSession session = request.getSession();
            session.setAttribute("pendingSetPasswordEmail", user.getEmail());

            // Xóa triệt để SecurityContext khỏi Thread và Session
            SecurityContextHolder.clearContext();
            session.removeAttribute("SPRING_SECURITY_CONTEXT");
            session.removeAttribute("SPRING_SECURITY_CONTEXT_SAVED");

            // Điều hướng sang trang Khởi tạo mật khẩu (/auth/set-password)
            response.sendRedirect("/auth/set-password");
            return;
        }

        // 3. Đã có mật khẩu - Tiến hành gộp giỏ hàng
        if (user != null) {
            HttpSession session = request.getSession();
            @SuppressWarnings("unchecked")
            java.util.Map<Integer, poly.edu.entity.CartItem> sessionCart = (java.util.Map<Integer, poly.edu.entity.CartItem>) session
                    .getAttribute("cart");
            java.util.Map<Integer, poly.edu.entity.CartItem> mergedCart = cartService.mergeCartOnLogin(user,
                    sessionCart);
            session.setAttribute("cart", mergedCart);
        }

        if (user != null && Boolean.TRUE.equals(user.getTwoFactorEnabled())) {
            // 2FA is enabled!
            HttpSession session = request.getSession();
            final String userEmail = user.getEmail();
            session.setAttribute("twoFactorUserEmail", userEmail);

            // Generate and send OTP via email asynchronously in background thread to prevent redirect delay!
            java.util.concurrent.CompletableFuture.runAsync(() -> {
                try {
                    emailService.sendOtpEmail(userEmail, userEmail);
                } catch (Exception e) {
                    System.err.println("Error sending 2FA login OTP: " + e.getMessage());
                }
            });

            // Log out user for now (clear security context) so they aren't fully authenticated
            SecurityContextHolder.clearContext();
            session.removeAttribute("SPRING_SECURITY_CONTEXT");

            // Redirect to 2FA verification page
            response.sendRedirect("/auth/login-2fa");
        } else {
            // 2FA not enabled, proceed to homepage
            response.sendRedirect("/");
        }
    }
}
