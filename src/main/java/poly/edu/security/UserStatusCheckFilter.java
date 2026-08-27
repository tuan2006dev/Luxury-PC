package poly.edu.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import poly.edu.dao.UserDAO;
import poly.edu.entity.User;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class UserStatusCheckFilter extends OncePerRequestFilter {

    private final UserDAO userDAO;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
            String emailOrUsername = auth.getName();
            Object principalObj = auth.getPrincipal();
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

                // If user exists and status is false (account is locked)
                if (user != null && Boolean.FALSE.equals(user.getStatus())) {
                    SecurityContextHolder.clearContext();
                    HttpSession session = request.getSession(false);
                    if (session != null) {
                        session.removeAttribute("SPRING_SECURITY_CONTEXT");
                        session.invalidate();
                    }

                    String acceptHeader = request.getHeader("Accept");
                    String requestedWith = request.getHeader("X-Requested-With");
                    boolean isJson = (acceptHeader != null && acceptHeader.contains("application/json"))
                            || "XMLHttpRequest".equalsIgnoreCase(requestedWith)
                            || request.getRequestURI().startsWith("/api/");

                    if (isJson) {
                        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().write("{\"authenticated\":false,\"locked\":true,\"message\":\"Tài khoản của bạn đã bị khóa bởi Quản trị viên.\"}");
                        return;
                    } else {
                        response.sendRedirect("/auth/login?error=account_locked");
                        return;
                    }
                }
            }
        }

        filterChain.doFilter(request, response);
    }
}
