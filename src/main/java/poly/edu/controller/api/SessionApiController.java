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
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getActiveSessions(
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

        // 1. Fetch active sessions from the DB
        List<UserSession> dbSessions = userSessionDAO.findByUserAndIsExpiredFalseOrderByLoginTimeDesc(user);
        
        // 2. Cross-reference with Spring Security SessionRegistry to see if they are still active
        List<Map<String, Object>> activeList = new ArrayList<>();
        
        // We can get all active sessions of this user from SessionRegistry to verify
        Set<String> activeSessionIds = new HashSet<>();
        for (Object principal : sessionRegistry.getAllPrincipals()) {
            String principalName = extractPrincipalName(principal);
            if (principalName != null && principalName.equals(authentication.getName())) {
                List<SessionInformation> sessions = sessionRegistry.getAllSessions(principal, false);
                for (SessionInformation info : sessions) {
                    if (info != null && !info.isExpired()) {
                        activeSessionIds.add(info.getSessionId());
                    }
                }
            }
        }

        for (UserSession us : dbSessions) {
            // If it's not active in SessionRegistry (except for current session or if registry didn't register it yet), skip or expire it
            boolean isActiveInRegistry = activeSessionIds.contains(us.getSessionId());
            boolean isCurrent = us.getSessionId().equals(currentSessionId);
            
            if (!isActiveInRegistry && !isCurrent) {
                // Mark as expired in DB
                us.setIsExpired(true);
                userSessionDAO.save(us);
                continue;
            }

            Map<String, Object> m = new HashMap<>();
            m.put("sessionId", us.getSessionId());
            m.put("deviceInfo", us.getDeviceInfo());
            m.put("ipAddress", us.getIpAddress());
            m.put("location", us.getLocation());
            m.put("loginTime", us.getLoginTime().getTime());
            m.put("isCurrent", isCurrent);
            activeList.add(m);
        }

        // If activeList is empty but we have a current session, we should make sure the current session is at least displayed
        if (activeList.isEmpty()) {
            Map<String, Object> m = new HashMap<>();
            m.put("sessionId", currentSessionId);
            m.put("deviceInfo", "Thiết bị hiện tại");
            m.put("ipAddress", getIpAddress(request));
            m.put("location", "Localhost");
            m.put("loginTime", System.currentTimeMillis());
            m.put("isCurrent", true);
            activeList.add(m);
        }

        return ResponseEntity.ok(ApiResponse.success("Success", activeList));
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
        for (Object principal : sessionRegistry.getAllPrincipals()) {
            String principalName = extractPrincipalName(principal);
            if (principalName != null && principalName.equals(authentication.getName())) {
                List<SessionInformation> sessions = sessionRegistry.getAllSessions(principal, false);
                for (SessionInformation info : sessions) {
                    if (info != null && info.getSessionId().equals(sessionId)) {
                        info.expireNow();
                        break;
                    }
                }
            }
        }

        Map<String, Object> res = new HashMap<>();
        res.put("message", "Đã đăng xuất thiết bị thành công.");
        return ResponseEntity.ok(ApiResponse.success("Success", res));
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
}
