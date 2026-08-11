package poly.edu.security;

import lombok.RequiredArgsConstructor;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
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

    private final RequestCache requestCache = new HttpSessionRequestCache();

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        
        User user = null;
        Object principalObj = authentication.getPrincipal();
        if (principalObj instanceof CustomOAuth2User customOAuth2User) {
            user = customOAuth2User.getDbUser();
        }

        if (user == null) {
            String emailOrUsername = authentication.getName();
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
                try {
                    String cleanEmailOrUsername = emailOrUsername.trim().toLowerCase();
                    user = userDAO.findByEmailWithRoles(cleanEmailOrUsername);
                    if (user == null) {
                        user = userDAO.findByUsernameWithRoles(cleanEmailOrUsername);
                    }
                } catch (Exception e) {
                    System.err.println("Error loading user in success handler: " + e.getMessage());
                }
            }
        }

        boolean isStaffOrAdmin = user != null && user.getUserRoles() != null && user.getUserRoles().stream()
                .anyMatch(ur -> ur.getRole() != null &&
                        ("STAFF".equalsIgnoreCase(ur.getRole().getName()) || "ADMIN".equalsIgnoreCase(ur.getRole().getName())));

        // 1. Audit Log (wrapped safely)
        if (isStaffOrAdmin) {
            try {
                String clientIp = request.getHeader("X-Forwarded-For");
                if (clientIp == null || clientIp.isBlank() || "unknown".equalsIgnoreCase(clientIp)) {
                    clientIp = request.getRemoteAddr();
                }
                String roleStr = user.getUserRoles().stream()
                        .map(ur -> ur.getRole() != null ? ur.getRole().getName() : "")
                        .filter(r -> !r.isBlank())
                        .collect(java.util.stream.Collectors.joining(", "));
                String usernameToLog = user.getUsername() != null && !user.getUsername().isBlank() ? user.getUsername() : user.getEmail();
                adminLogRepository.save(new poly.edu.entity.AdminLog(
                        usernameToLog != null ? usernameToLog : "unknown",
                        "Đăng nhập hệ thống (Role: " + (roleStr.isBlank() ? "STAFF" : roleStr) + ")",
                        clientIp,
                        usernameToLog
                ));
            } catch (Exception e) {
                System.err.println("Error saving admin audit log: " + e.getMessage());
            }
        }

        // 2. Check disabled account
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

        // 3. Force password change check (only for regular customer accounts)
        if (!isStaffOrAdmin && user != null && Boolean.TRUE.equals(user.getForceChangePassword()) && !(principalObj instanceof CustomOAuth2User)) {
            HttpSession session = request.getSession();
            session.setAttribute("pendingSetPasswordEmail", user.getEmail());

            SecurityContextHolder.clearContext();
            session.removeAttribute("SPRING_SECURITY_CONTEXT");
            session.removeAttribute("SPRING_SECURITY_CONTEXT_SAVED");

            response.sendRedirect("/auth/set-password");
            return;
        }

        // 4. Cart merging (wrapped safely)
        if (user != null) {
            try {
                HttpSession session = request.getSession();
                @SuppressWarnings("unchecked")
                java.util.Map<Integer, poly.edu.entity.CartItem> sessionCart = (java.util.Map<Integer, poly.edu.entity.CartItem>) session
                        .getAttribute("cart");
                if (sessionCart != null && !sessionCart.isEmpty()) {
                    java.util.Map<Integer, poly.edu.entity.CartItem> mergedCart = cartService.mergeCartOnLogin(user, sessionCart);
                    session.setAttribute("cart", mergedCart);
                }
            } catch (Exception e) {
                System.err.println("Error merging cart on login: " + e.getMessage());
            }
        }

        // 5. 2FA Check
        if (user != null && Boolean.TRUE.equals(user.getTwoFactorEnabled())) {
            HttpSession session = request.getSession();
            final String userEmail = user.getEmail();
            session.setAttribute("twoFactorUserEmail", userEmail);

            java.util.concurrent.CompletableFuture.runAsync(() -> {
                try {
                    emailService.sendOtpEmail(userEmail, userEmail);
                } catch (Exception e) {
                    System.err.println("Error sending 2FA login OTP: " + e.getMessage());
                }
            });

            SecurityContextHolder.clearContext();
            session.removeAttribute("SPRING_SECURITY_CONTEXT");
            response.sendRedirect("/auth/login-2fa");
            return;
        }

        // 6. Check SavedRequest (if user tried to access /admin or /checkout before logging in)
        SavedRequest savedRequest = requestCache.getRequest(request, response);
        if (savedRequest != null) {
            String targetUrl = savedRequest.getRedirectUrl();
            requestCache.removeRequest(request, response);
            if (targetUrl != null && !targetUrl.contains(".well-known") && !targetUrl.contains("favicon") && !targetUrl.contains(".json") && !targetUrl.contains("/api/")) {
                response.sendRedirect(targetUrl);
                return;
            }
        }

        // 7. Default Redirect: Everyone -> / (Trang chủ)
        response.sendRedirect("/");
    }
}



