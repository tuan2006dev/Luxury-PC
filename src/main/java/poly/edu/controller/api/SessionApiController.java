package poly.edu.controller.api;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.session.SessionInformation;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpServletRequest;
import poly.edu.dao.UserSessionDAO;
import poly.edu.dto.ApiResponse;
import poly.edu.entity.User;
import poly.edu.entity.UserSession;
import poly.edu.repository.UserRepository;

import java.util.*;

@RestController
@RequestMapping("/api/sessions")
public class SessionApiController {

    private final UserRepository userRepository;
    private final UserSessionDAO userSessionDAO;
    private final SessionRegistry sessionRegistry;

    public SessionApiController(UserRepository userRepository, UserSessionDAO userSessionDAO, SessionRegistry sessionRegistry) {
        this.userRepository = userRepository;
        this.userSessionDAO = userSessionDAO;
        this.sessionRegistry = sessionRegistry;
    }

    private User resolveUser(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }
        String name = authentication.getName();
        return userRepository.findByEmail(name)
                .or(() -> userRepository.findByUsername(name))
                .orElse(null);
    }

    @GetMapping("/active")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getActiveSessions(
            Authentication authentication,
            HttpServletRequest request) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập", null));
        }

        User user = resolveUser(authentication);
        if (user == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Người dùng không tồn tại", null));
        }

        String currentSessionId = request.getSession().getId();

        // 1. Collect all active session IDs in SessionRegistry for this user
        Set<String> activeRegistrySessionIds = new HashSet<>();
        for (Object principal : sessionRegistry.getAllPrincipals()) {
            String principalName = extractPrincipalName(principal);
            if (principalName != null && isUserMatch(principalName, user, authentication)) {
                List<SessionInformation> sessions = sessionRegistry.getAllSessions(principal, false);
                for (SessionInformation info : sessions) {
                    if (info != null && !info.isExpired()) {
                        activeRegistrySessionIds.add(info.getSessionId());
                    }
                }
            }
        }

        // 2. Fetch active sessions from the DB
        List<UserSession> dbSessions = userSessionDAO.findByUserAndIsExpiredFalseOrderByLoginTimeDesc(user);

        // 3. Identify or create the current session representation
        UserSession currentDbSession = null;
        for (UserSession us : dbSessions) {
            if (us.getSessionId().equals(currentSessionId)) {
                currentDbSession = us;
                break;
            }
        }

        String currentIp = getIpAddress(request);
        String currentUserAgent = request.getHeader("User-Agent");
        String currentDeviceInfo = currentDbSession != null ? currentDbSession.getDeviceInfo() : buildDeviceInfo(currentUserAgent);
        String currentLocation = currentDbSession != null ? currentDbSession.getLocation() : getLocation(currentIp);
        long currentLoginTime = currentDbSession != null && currentDbSession.getLoginTime() != null
                ? currentDbSession.getLoginTime().getTime()
                : System.currentTimeMillis();

        Map<String, Object> currentSessionMap = new HashMap<>();
        currentSessionMap.put("sessionId", currentSessionId);
        currentSessionMap.put("deviceInfo", currentDeviceInfo);
        currentSessionMap.put("ipAddress", currentIp);
        currentSessionMap.put("location", currentLocation);
        currentSessionMap.put("loginTime", currentLoginTime);
        currentSessionMap.put("isCurrent", true);

        // Register current device & IP key so any other session with the same device+IP is treated as a duplicate ghost session
        Set<String> seenDeviceIpKeys = new HashSet<>();
        String currentKey = (currentDeviceInfo + "@" + currentIp).toLowerCase();
        seenDeviceIpKeys.add(currentKey);

        List<Map<String, Object>> otherSessions = new ArrayList<>();

        for (UserSession us : dbSessions) {
            boolean isCurrent = us.getSessionId().equals(currentSessionId);
            if (isCurrent) {
                continue; // Current session already handled
            }

            // Check if active in SessionRegistry (if registry is populated)
            boolean isActiveInRegistry = activeRegistrySessionIds.contains(us.getSessionId());
            if (!isActiveInRegistry) {
                us.setIsExpired(true);
                userSessionDAO.save(us);
                continue;
            }

            // Check for duplicate device and IP (e.g. same computer/browser logged in multiple times)
            String key = (us.getDeviceInfo() + "@" + us.getIpAddress()).toLowerCase();
            if (seenDeviceIpKeys.contains(key)) {
                // Obsolete or duplicate session on the same device!
                us.setIsExpired(true);
                userSessionDAO.save(us);
                expireSessionInRegistry(us.getSessionId(), user, authentication);
                continue;
            }

            seenDeviceIpKeys.add(key);

            Map<String, Object> m = new HashMap<>();
            m.put("sessionId", us.getSessionId());
            m.put("deviceInfo", us.getDeviceInfo());
            m.put("ipAddress", us.getIpAddress());
            m.put("location", us.getLocation());
            m.put("loginTime", us.getLoginTime() != null ? us.getLoginTime().getTime() : System.currentTimeMillis());
            m.put("isCurrent", false);
            otherSessions.add(m);
        }

        List<Map<String, Object>> allSessions = new ArrayList<>();
        allSessions.add(currentSessionMap);
        allSessions.addAll(otherSessions);

        Map<String, Object> result = new HashMap<>();
        result.put("currentSession", currentSessionMap);
        result.put("otherSessions", otherSessions);
        result.put("allSessions", allSessions);

        return ResponseEntity.ok(ApiResponse.success("Success", result));
    }

    @PostMapping("/revoke")
    public ResponseEntity<ApiResponse<Map<String, Object>>> revokeSession(
            Authentication authentication,
            @RequestParam("sessionId") String sessionId) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập", null));
        }

        User user = resolveUser(authentication);
        if (user == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Người dùng không tồn tại", null));
        }

        // 1. Mark as expired in DB
        Optional<UserSession> usOpt = userSessionDAO.findBySessionId(sessionId);
        if (usOpt.isPresent()) {
            UserSession us = usOpt.get();
            if (us.getUser().getId().equals(user.getId())) {
                us.setIsExpired(true);
                userSessionDAO.save(us);
            } else {
                return ResponseEntity.status(403).body(ApiResponse.error("Không có quyền", null));
            }
        }

        // 2. Expire in SessionRegistry
        expireSessionInRegistry(sessionId, user, authentication);

        Map<String, Object> res = new HashMap<>();
        res.put("message", "Đã đăng xuất thiết bị thành công.");
        return ResponseEntity.ok(ApiResponse.success("Success", res));
    }

    @PostMapping("/revoke-all")
    public ResponseEntity<ApiResponse<Map<String, Object>>> revokeAllOtherSessions(
            Authentication authentication,
            HttpServletRequest request) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập", null));
        }

        User user = resolveUser(authentication);
        if (user == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Người dùng không tồn tại", null));
        }

        String currentSessionId = request.getSession().getId();
        List<UserSession> dbSessions = userSessionDAO.findByUserAndIsExpiredFalseOrderByLoginTimeDesc(user);
        int revokedCount = 0;

        for (UserSession us : dbSessions) {
            if (!us.getSessionId().equals(currentSessionId)) {
                us.setIsExpired(true);
                userSessionDAO.save(us);
                expireSessionInRegistry(us.getSessionId(), user, authentication);
                revokedCount++;
            }
        }

        Map<String, Object> res = new HashMap<>();
        res.put("revokedCount", revokedCount);
        res.put("message", "Đã đăng xuất khỏi " + revokedCount + " thiết bị khác thành công.");
        return ResponseEntity.ok(ApiResponse.success("Success", res));
    }

    private void expireSessionInRegistry(String sessionId, User user, Authentication authentication) {
        try {
            SessionInformation info = sessionRegistry.getSessionInformation(sessionId);
            if (info != null) {
                info.expireNow();
            }
        } catch (Exception ignored) {}

        for (Object principal : sessionRegistry.getAllPrincipals()) {
            String principalName = extractPrincipalName(principal);
            if (principalName != null && isUserMatch(principalName, user, authentication)) {
                List<SessionInformation> sessions = sessionRegistry.getAllSessions(principal, false);
                for (SessionInformation info : sessions) {
                    if (info != null && info.getSessionId().equals(sessionId)) {
                        info.expireNow();
                        break;
                    }
                }
            }
        }
    }

    private boolean isUserMatch(String principalName, User user, Authentication authentication) {
        if (principalName.equalsIgnoreCase(authentication.getName())) {
            return true;
        }
        if (user.getEmail() != null && principalName.equalsIgnoreCase(user.getEmail())) {
            return true;
        }
        if (user.getUsername() != null && principalName.equalsIgnoreCase(user.getUsername())) {
            return true;
        }
        return false;
    }

    private String extractPrincipalName(Object principal) {
        if (principal instanceof org.springframework.security.core.userdetails.UserDetails userDetails) {
            return userDetails.getUsername();
        }
        if (principal instanceof org.springframework.security.oauth2.core.user.OAuth2User oauth2User) {
            return oauth2User.getName();
        }
        if (principal instanceof String principalName) {
            return principalName;
        }
        return null;
    }

    private String getIpAddress(HttpServletRequest request) {
        String forwardedFor = request.getHeader("X-Forwarded-For");
        return (forwardedFor != null && !forwardedFor.isBlank()) ? forwardedFor.split(",")[0].trim() : request.getRemoteAddr();
    }

    private String getLocation(String ip) {
        if ("127.0.0.1".equals(ip) || "::1".equals(ip) || "0:0:0:0:0:0:0:1".equals(ip)) {
            return "Localhost";
        }
        return "Vietnam";
    }

    private String buildDeviceInfo(String userAgent) {
        if (userAgent == null) return "Thiết bị không xác định";
        String ua = userAgent.toLowerCase();
        String browser = "Trình duyệt khác";
        if (ua.contains("edg/")) browser = "Edge";
        else if (ua.contains("chrome/")) browser = "Chrome";
        else if (ua.contains("firefox/")) browser = "Firefox";
        else if (ua.contains("safari/") && !ua.contains("chrome/")) browser = "Safari";

        String os = "Hệ điều hành khác";
        if (ua.contains("windows")) os = "Windows";
        else if (ua.contains("mac os")) os = "macOS";
        else if (ua.contains("android")) os = "Android";
        else if (ua.contains("iphone") || ua.contains("ipad") || ua.contains("ios")) os = "iOS";
        else if (ua.contains("linux")) os = "Linux";

        return browser + " (" + os + ")";
    }
}
