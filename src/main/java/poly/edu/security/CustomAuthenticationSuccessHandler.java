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

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        String emailOrUsername = authentication.getName();
        User user = userDAO.findByEmail(emailOrUsername);
        if (user == null) {
            user = userDAO.findByUsername(emailOrUsername);
        }

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

            // Generate and send OTP via email asynchronously in background thread to
            // prevent redirect delay!
            java.util.concurrent.CompletableFuture.runAsync(() -> {
                try {
                    emailService.sendOtpEmail(userEmail, userEmail);
                } catch (Exception e) {
                    System.err.println("Error sending 2FA login OTP: " + e.getMessage());
                }
            });

            // Log out user for now (clear security context) so they aren't fully
            // authenticated
            SecurityContextHolder.clearContext();

            // Redirect to 2FA verification page
            response.sendRedirect("/auth/login-2fa");
        } else {
            // 2FA not enabled, proceed to homepage
            response.sendRedirect("/");
        }
    }
}
