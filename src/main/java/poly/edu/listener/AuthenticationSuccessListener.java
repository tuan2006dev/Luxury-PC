package poly.edu.listener;

import org.springframework.context.ApplicationListener;
import org.springframework.security.authentication.event.InteractiveAuthenticationSuccessEvent;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import poly.edu.dao.UserSessionDAO;
import poly.edu.entity.User;
import poly.edu.entity.UserSession;
import org.springframework.security.core.session.SessionInformation;
import org.springframework.security.core.session.SessionRegistry;
import poly.edu.repository.UserRepository;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Component
public class AuthenticationSuccessListener implements ApplicationListener<InteractiveAuthenticationSuccessEvent> {

    private final UserSessionDAO userSessionDAO;
    private final UserRepository userRepository;
    private final SessionRegistry sessionRegistry;

    public AuthenticationSuccessListener(UserSessionDAO userSessionDAO, UserRepository userRepository, SessionRegistry sessionRegistry) {
        this.userSessionDAO = userSessionDAO;
        this.userRepository = userRepository;
        this.sessionRegistry = sessionRegistry;
    }

    @Override
    public void onApplicationEvent(InteractiveAuthenticationSuccessEvent event) {
        Authentication auth = event.getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return;
        }

        // Get current HttpServletRequest and HttpSession
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attr == null) {
            return;
        }
        HttpServletRequest request = attr.getRequest();
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }

        String sessionId = session.getId();
        String usernameOrEmail = auth.getName();

        // Resolve user
        User user = userRepository.findByEmail(usernameOrEmail)
                .or(() -> userRepository.findByUsername(usernameOrEmail))
                .orElse(null);

        if (user == null) {
            return;
        }

        // Check if session is already recorded to avoid duplicate logs
        Optional<UserSession> existing = userSessionDAO.findBySessionId(sessionId);
        if (existing.isPresent()) {
            return;
        }

        // Extract device info, browser, os, ip, location
        String userAgent = request.getHeader("User-Agent");
        String deviceInfo = buildDeviceInfo(userAgent);
        String ipAddress = getIpAddress(request);
        String location = getLocation(request);

        // Expire any existing active sessions on the same device and IP for this user
        try {
            List<UserSession> existingActiveSessions = userSessionDAO.findByUserAndIsExpiredFalseOrderByLoginTimeDesc(user);
            for (UserSession oldSession : existingActiveSessions) {
                if (deviceInfo.equalsIgnoreCase(oldSession.getDeviceInfo()) && ipAddress.equalsIgnoreCase(oldSession.getIpAddress())) {
                    oldSession.setIsExpired(true);
                    userSessionDAO.save(oldSession);

                    try {
                        SessionInformation info = sessionRegistry.getSessionInformation(oldSession.getSessionId());
                        if (info != null) {
                            info.expireNow();
                        }
                    } catch (Exception ignored) {}
                }
            }
        } catch (Exception e) {
            System.err.println("Error cleaning up previous sessions on login: " + e.getMessage());
        }

        // Record the new session
        UserSession userSession = new UserSession();
        userSession.setUser(user);
        userSession.setSessionId(sessionId);
        userSession.setUserAgent(userAgent);
        userSession.setDeviceInfo(deviceInfo);
        userSession.setIpAddress(ipAddress);
        userSession.setLocation(location);
        userSession.setLoginTime(new Date());
        userSession.setLastActivity(new Date());
        userSession.setIsExpired(false);

        userSessionDAO.save(userSession);
    }

    private String buildDeviceInfo(String userAgent) {
        if (userAgent == null) return "Unknown Device";
        String ua = userAgent.toLowerCase();
        String browser = "Other Browser";
        if (ua.contains("edg/")) browser = "Edge";
        else if (ua.contains("chrome/")) browser = "Chrome";
        else if (ua.contains("firefox/")) browser = "Firefox";
        else if (ua.contains("safari/") && !ua.contains("chrome/")) browser = "Safari";

        String os = "Other OS";
        if (ua.contains("windows")) os = "Windows";
        else if (ua.contains("mac os")) os = "macOS";
        else if (ua.contains("android")) os = "Android";
        else if (ua.contains("iphone") || ua.contains("ipad") || ua.contains("ios")) os = "iOS";
        else if (ua.contains("linux")) os = "Linux";

        return browser + " (" + os + ")";
    }

    private String getIpAddress(HttpServletRequest request) {
        String forwardedFor = request.getHeader("X-Forwarded-For");
        String ip = (forwardedFor != null && !forwardedFor.isBlank()) ? forwardedFor.split(",")[0].trim() : request.getRemoteAddr();
        if (ip == null || ip.isBlank()) return "Unknown";
        if ("127.0.0.1".equals(ip) || "::1".equals(ip) || "0:0:0:0:0:0:0:1".equals(ip)) {
            return "127.0.0.1";
        }
        return ip;
    }

    private String getLocation(HttpServletRequest request) {
        String ip = getIpAddress(request);
        if ("127.0.0.1".equals(ip)) {
            return "Localhost";
        }
        return "Vietnam";
    }
}
