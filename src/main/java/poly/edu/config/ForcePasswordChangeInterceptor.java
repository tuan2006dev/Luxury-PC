package poly.edu.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import poly.edu.dao.UserDAO;
import poly.edu.entity.User;
import poly.edu.security.CustomOAuth2User;

@Component
@RequiredArgsConstructor
public class ForcePasswordChangeInterceptor implements HandlerInterceptor {

    private final UserDAO userDAO;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getName())) {
            return true;
        }

        String uri = request.getRequestURI();

        // Cho phép truy cập vào trang hồ sơ (để đổi mật khẩu), đăng xuất và tài nguyên tĩnh
        if (uri.startsWith("/profile") || uri.startsWith("/logout") || uri.startsWith("/css/")
                || uri.startsWith("/js/") || uri.startsWith("/images/") || uri.startsWith("/uploads/")
                || uri.equals("/favicon.ico")) {
            return true;
        }

        // Nhận diện user hiện tại
        String emailOrUsername = auth.getName();
        Object principal = auth.getPrincipal();
        if (principal instanceof CustomOAuth2User customOAuth2User) {
            if (customOAuth2User.getEmail() != null) {
                emailOrUsername = customOAuth2User.getEmail();
            }
        } else if (principal instanceof org.springframework.security.oauth2.core.user.OAuth2User oauth2User) {
            Object emailAttr = oauth2User.getAttribute("email");
            if (emailAttr != null) {
                emailOrUsername = emailAttr.toString();
            }
        }

        User user = userDAO.findByEmail(emailOrUsername);
        if (user == null) {
            user = userDAO.findByUsername(emailOrUsername);
        }

        // Ghim 100%: nếu chưa đổi mật khẩu hoặc chưa có mật khẩu local -> Chặn toàn bộ route khác!
        if (user != null && (Boolean.TRUE.equals(user.getForceChangePassword()) || user.getPassword() == null || user.getPassword().isBlank())) {
            if ("XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With")) || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"))) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"error\": \"Bắt buộc đổi mật khẩu khởi tạo ở lần đăng nhập đầu tiên.\"}");
            } else {
                response.sendRedirect("/profile?tab=security&openPasswordForm=1&firstLogin=true");
            }
            return false;
        }

        return true;
    }
}
