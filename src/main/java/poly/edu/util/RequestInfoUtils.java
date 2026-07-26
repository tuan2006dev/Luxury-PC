package poly.edu.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class RequestInfoUtils {

    public static String buildSessionInfo(HttpServletRequest request, HttpSession session) {
        String userAgent = request != null ? request.getHeader("User-Agent") : "";
        String browser = detectBrowser(userAgent);
        String os = detectOS(userAgent);
        String location = detectLocation(request);
        String loginAt = formatSessionStart(session);
        return browser + " · " + os + " · " + location + " — Đăng nhập " + loginAt;
    }

    private static String detectBrowser(String userAgent) {
        if (userAgent == null) return "Trình duyệt khác";
        String ua = userAgent.toLowerCase();
        if (ua.contains("edg/")) return "Edge";
        if (ua.contains("chrome/")) return "Chrome";
        if (ua.contains("firefox/")) return "Firefox";
        if (ua.contains("safari/") && !ua.contains("chrome/")) return "Safari";
        return "Trình duyệt khác";
    }

    private static String detectOS(String userAgent) {
        if (userAgent == null) return "Hệ điều hành khác";
        String ua = userAgent.toLowerCase();
        if (ua.contains("windows")) return "Windows";
        if (ua.contains("mac os")) return "macOS";
        if (ua.contains("android")) return "Android";
        if (ua.contains("iphone") || ua.contains("ipad") || ua.contains("ios")) return "iOS";
        if (ua.contains("linux")) return "Linux";
        return "Hệ điều hành khác";
    }

    private static String detectLocation(HttpServletRequest request) {
        if (request == null) return "Không xác định";
        String forwardedFor = request.getHeader("X-Forwarded-For");
        String ip = (forwardedFor != null && !forwardedFor.isBlank()) ? forwardedFor.split(",")[0].trim() : request.getRemoteAddr();
        if (ip == null || ip.isBlank()) return "Không xác định";
        if ("127.0.0.1".equals(ip) || "::1".equals(ip) || "0:0:0:0:0:0:0:1".equals(ip)) {
            return "Localhost";
        }
        return ip;
    }

    private static String formatSessionStart(HttpSession session) {
        if (session == null) return "không rõ";
        java.time.Instant instant = java.time.Instant.ofEpochMilli(session.getCreationTime());
        java.time.ZonedDateTime zonedDateTime = instant.atZone(java.time.ZoneId.systemDefault());
        return java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm").format(zonedDateTime);
    }
}
