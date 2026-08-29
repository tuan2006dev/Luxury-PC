package poly.edu.controller.api;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Random;
import jakarta.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import poly.edu.dto.ApiResponse;
import poly.edu.entity.User;
import poly.edu.repository.UserRepository;
import poly.edu.service.EmailService;
import org.springframework.security.oauth2.core.user.OAuth2User;

@RestController
@RequestMapping("/api/profile")
public class ProfileApiController {

    private static final Logger log = LoggerFactory.getLogger(ProfileApiController.class);

    private final UserRepository userRepository;
    private final EmailService emailService;
    private final poly.edu.service.ProfileService profileService;
    private final poly.edu.service.OrderService orderService;
    private final poly.edu.service.CustomerOrderService customerOrderService;

    public ProfileApiController(UserRepository userRepository, EmailService emailService, poly.edu.service.ProfileService profileService, poly.edu.service.OrderService orderService, poly.edu.service.CustomerOrderService customerOrderService) {
        this.userRepository = userRepository;
        this.emailService = emailService;
        this.profileService = profileService;
        this.orderService = orderService;
        this.customerOrderService = customerOrderService;
    }

    private User resolveUser(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }
        Object principal = authentication.getPrincipal();
        String emailOrUsername = null;
        if (principal instanceof org.springframework.security.core.userdetails.User userDetails) {
            emailOrUsername = userDetails.getUsername();
        } else if (principal instanceof OAuth2User oauth2User) {
            Object email = oauth2User.getAttribute("email");
            if (email != null) {
                emailOrUsername = email.toString();
            }
        }
        if (emailOrUsername == null || emailOrUsername.isBlank()) {
            emailOrUsername = authentication.getName();
        }
        
        final String identifier = emailOrUsername;
        return userRepository.findByEmail(identifier)
                .or(() -> userRepository.findByUsername(identifier))
                .orElse(null);
    }

    @GetMapping
    public ResponseEntity<ApiResponse<Map<String, Object>>> getProfile(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }

        User user = resolveUser(authentication);
        if (user == null) {
            return ResponseEntity.status(404).body(ApiResponse.error("Không tìm thấy người dùng.", null));
        }

        Map<String, Object> profileData = new LinkedHashMap<>();
        profileData.put("id", user.getId());
        profileData.put("email", user.getEmail());
        profileData.put("fullName", user.getFullName());
        profileData.put("phone", user.getPhone());
        profileData.put("birthday", user.getBirthday());
        profileData.put("gender", user.getGender());
        profileData.put("createdAt", user.getCreatedAt());

        return ResponseEntity.ok(ApiResponse.success("Success", profileData));
    }

    @org.springframework.web.bind.annotation.PostMapping("/avatar")
    public ResponseEntity<Map<String, Object>> uploadAvatar(
            Authentication authentication,
            @org.springframework.web.bind.annotation.RequestParam("file") org.springframework.web.multipart.MultipartFile file) {
        Map<String, Object> response = new java.util.HashMap<>();
        if (authentication == null || !authentication.isAuthenticated()) {
            response.put("success", false);
            response.put("message", "Chưa đăng nhập.");
            return ResponseEntity.status(401).body(response);
        }

        User user = resolveUser(authentication);
        if (user == null) {
            response.put("success", false);
            response.put("message", "Không tìm thấy người dùng.");
            return ResponseEntity.status(404).body(response);
        }

        if (file.isEmpty()) {
            response.put("success", false);
            response.put("message", "File trống.");
            return ResponseEntity.badRequest().body(response);
        }

        try {
            profileService.uploadAvatar(file, user);
            response.put("success", true);
            response.put("avatarPath", user.getAvatar());
            return ResponseEntity.ok(response);
        } catch (Exception ex) {
            log.error("[ProfileApi] Error uploading avatar", ex);
            response.put("success", false);
            response.put("message", "Không thể lưu file lúc này: " + ex.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    @org.springframework.web.bind.annotation.PostMapping("/orders/{id}/cancel")
    public ResponseEntity<Map<String, Object>> cancelOrder(
            Authentication authentication,
            @org.springframework.web.bind.annotation.PathVariable("id") Integer id) {
        Map<String, Object> response = new java.util.HashMap<>();
        if (authentication == null || !authentication.isAuthenticated()) {
            response.put("success", false);
            response.put("message", "Chưa đăng nhập.");
            return ResponseEntity.status(401).body(response);
        }

        User user = resolveUser(authentication);
        if (user == null) {
            response.put("success", false);
            response.put("message", "Không tìm thấy người dùng.");
            return ResponseEntity.status(404).body(response);
        }

        try {
            orderService.cancelOrderByUser(id, user.getId());
            response.put("success", true);
            response.put("message", "Hủy đơn hàng thành công.");
            return ResponseEntity.ok(response);
        } catch (IllegalStateException | IllegalArgumentException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @org.springframework.web.bind.annotation.PostMapping({"/orders/{id}/request-refund", "/orders/{id}/refund"})
    public ResponseEntity<Map<String, Object>> requestRefund(
            Authentication authentication,
            @org.springframework.web.bind.annotation.PathVariable("id") Integer id,
            @org.springframework.web.bind.annotation.RequestBody(required = false) Map<String, String> body) {
        Map<String, Object> response = new java.util.HashMap<>();
        if (authentication == null || !authentication.isAuthenticated()) {
            response.put("success", false);
            response.put("message", "Vui lòng đăng nhập để thực hiện.");
            return ResponseEntity.status(401).body(response);
        }

        User user = resolveUser(authentication);
        if (user == null) {
            response.put("success", false);
            response.put("message", "Không tìm thấy thông tin người dùng.");
            return ResponseEntity.status(404).body(response);
        }

        String reason = body != null ? body.get("reason") : null;
        if (reason == null || reason.trim().isBlank()) {
            response.put("success", false);
            response.put("message", "Vui lòng nhập lý do yêu cầu thu hồi / hoàn trả.");
            return ResponseEntity.badRequest().body(response);
        }

        boolean success = customerOrderService.requestRefund(id, user, reason.trim());
        if (success) {
            response.put("success", true);
            response.put("message", "Đã gửi yêu cầu thu hồi đơn hàng tới Admin thành công. Vui lòng chờ xét duyệt.");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "Đơn hàng không đủ điều kiện thu hồi hoặc không thuộc về bạn.");
            return ResponseEntity.badRequest().body(response);
        }
    }

    @org.springframework.web.bind.annotation.PostMapping("/2fa/send-otp")
    public ResponseEntity<Map<String, Object>> send2faOtp(Authentication authentication) {
        Map<String, Object> response = new java.util.HashMap<>();
        if (authentication == null || !authentication.isAuthenticated()) {
            response.put("success", false);
            response.put("message", "Chưa đăng nhập.");
            return ResponseEntity.status(401).body(response);
        }

        User user = resolveUser(authentication);
        if (user == null) {
            response.put("success", false);
            response.put("message", "Không tìm thấy người dùng.");
            return ResponseEntity.status(404).body(response);
        }

        try {
            final String targetEmail = user.getEmail();
            java.util.concurrent.CompletableFuture.runAsync(() -> {
                try {
                    emailService.sendOtpEmail(targetEmail, targetEmail);
                } catch (Exception e) {
                    log.error("[ProfileApi] Error saving profile", e);
                }
            });
            response.put("success", true);
            response.put("message", "Đã gửi mã OTP đến email của bạn.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Không thể gửi OTP lúc này: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    @org.springframework.web.bind.annotation.PostMapping("/2fa/enable")
    public ResponseEntity<Map<String, Object>> enable2fa(
            Authentication authentication,
            @org.springframework.web.bind.annotation.RequestParam("otp") String otp) {
        Map<String, Object> response = new java.util.HashMap<>();
        if (authentication == null || !authentication.isAuthenticated()) {
            response.put("success", false);
            response.put("message", "Chưa đăng nhập.");
            return ResponseEntity.status(401).body(response);
        }

        User user = resolveUser(authentication);
        if (user == null) {
            response.put("success", false);
            response.put("message", "Không tìm thấy người dùng.");
            return ResponseEntity.status(404).body(response);
        }

        boolean isValid = emailService.verifyOtp(user.getEmail(), otp.trim());
        if (!isValid) {
            response.put("success", false);
            response.put("message", "Mã OTP không chính xác hoặc đã hết hiệu lực.");
            return ResponseEntity.badRequest().body(response);
        }

        user.setTwoFactorEnabled(true);
        userRepository.save(user);

        response.put("success", true);
        response.put("message", "Kích hoạt xác thực 2 lớp (2FA) thành công.");
        return ResponseEntity.ok(response);
    }

    @org.springframework.web.bind.annotation.PostMapping("/2fa/disable")
    public ResponseEntity<Map<String, Object>> disable2fa(Authentication authentication) {
        Map<String, Object> response = new java.util.HashMap<>();
        if (authentication == null || !authentication.isAuthenticated()) {
            response.put("success", false);
            response.put("message", "Chưa đăng nhập.");
            return ResponseEntity.status(401).body(response);
        }

        User user = resolveUser(authentication);
        if (user == null) {
            response.put("success", false);
            response.put("message", "Không tìm thấy người dùng.");
            return ResponseEntity.status(404).body(response);
        }

        user.setTwoFactorEnabled(false);
        userRepository.save(user);

        response.put("success", true);
        response.put("message", "Đã hủy kích hoạt xác thực 2 lớp (2FA).");
        return ResponseEntity.ok(response);
    }

    @org.springframework.web.bind.annotation.PostMapping("/delete-account")
    public ResponseEntity<Map<String, Object>> deleteAccount(
            Authentication authentication,
            jakarta.servlet.http.HttpServletRequest request) {
        Map<String, Object> response = new java.util.HashMap<>();
        if (authentication == null || !authentication.isAuthenticated()) {
            response.put("success", false);
            response.put("message", "Chưa đăng nhập.");
            return ResponseEntity.status(401).body(response);
        }

        User user = resolveUser(authentication);
        if (user == null) {
            response.put("success", false);
            response.put("message", "Không tìm thấy người dùng.");
            return ResponseEntity.status(404).body(response);
        }

        // Hard delete user fully
        profileService.deleteUserFully(user);

        // Invalidate session and clear security context
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        org.springframework.security.core.context.SecurityContextHolder.clearContext();

        response.put("success", true);
        response.put("message", "Tài khoản của bạn đã được xóa thành công.");
        return ResponseEntity.ok(response);
    }

    @org.springframework.web.bind.annotation.PostMapping("/check-current-password")
    public ResponseEntity<Map<String, Object>> checkCurrentPassword(
            Authentication authentication,
            @org.springframework.web.bind.annotation.RequestParam("currentPassword") String currentPassword,
            org.springframework.security.crypto.password.PasswordEncoder passwordEncoder) {
        Map<String, Object> response = new java.util.HashMap<>();
        if (authentication == null || !authentication.isAuthenticated()) {
            response.put("valid", false);
            response.put("message", "Chưa đăng nhập.");
            return ResponseEntity.status(401).body(response);
        }

        User user = resolveUser(authentication);
        if (user == null || user.getPassword() == null) {
            response.put("valid", false);
            response.put("message", "Tài khoản chưa khởi tạo mật khẩu.");
            return ResponseEntity.ok(response);
        }

        boolean matches = passwordEncoder.matches(currentPassword.trim(), user.getPassword());
        response.put("valid", matches);
        response.put("message", matches ? "Mật khẩu chính xác." : "Mật khẩu hiện tại không chính xác.");
        return ResponseEntity.ok(response);
    }

    // ----------------------------------------------------------------
    // Gửi OTP xác thực SĐT (không dùng Firebase)
    // ----------------------------------------------------------------
    @org.springframework.web.bind.annotation.PostMapping("/send-phone-otp")
    public ResponseEntity<Map<String, Object>> sendPhoneOtp(
            Authentication authentication,
            HttpSession session,
            @org.springframework.web.bind.annotation.RequestParam("phone") String phone) {

        Map<String, Object> response = new java.util.HashMap<>();
        if (authentication == null || !authentication.isAuthenticated()) {
            response.put("success", false);
            response.put("message", "Chưa đăng nhập.");
            return ResponseEntity.status(401).body(response);
        }

        User user = resolveUser(authentication);
        if (user == null) {
            response.put("success", false);
            response.put("message", "Không tìm thấy người dùng.");
            return ResponseEntity.status(404).body(response);
        }

        String cleanPhone = phone != null ? phone.trim().replaceAll("\\s+", "") : "";
        if (!cleanPhone.matches("^0(3|5|7|8|9)[0-9]{8}$")) {
            response.put("success", false);
            response.put("message", "Số điện thoại không đúng định dạng Việt Nam (VD: 0912345678)!");
            return ResponseEntity.badRequest().body(response);
        }

        // Kiểm tra SĐT đã được dùng bởi tài khoản khác chưa
        java.util.Optional<User> existingUser = userRepository.findByPhone(cleanPhone);
        if (existingUser.isPresent() && !existingUser.get().getId().equals(user.getId())) {
            response.put("success", false);
            response.put("message", "Số điện thoại này đã được liên kết với một tài khoản khác!");
            return ResponseEntity.badRequest().body(response);
        }

        // Sinh OTP 6 chữ số
        String otp = String.format("%06d", new Random().nextInt(1_000_000));
        long expiry = System.currentTimeMillis() + 5 * 60 * 1000L; // 5 phút

        session.setAttribute("phone_otp_code", otp);
        session.setAttribute("phone_otp_phone", cleanPhone);
        session.setAttribute("phone_otp_expiry", expiry);

        // Gửi OTP qua email của user
        String userEmail = user.getEmail();
        try {
            String subject = "[Luxury PC] Mã OTP xác thực số điện thoại";
            String body = "<div style='font-family:Arial,sans-serif;max-width:480px;margin:auto;padding:24px;border:1px solid #e2e8f0;border-radius:8px;'>"
                    + "<h2 style='color:#0066CC;margin-top:0;'>Xác thực Số Điện Thoại</h2>"
                    + "<p>Bạn đang yêu cầu xác thực số điện thoại <strong>" + cleanPhone + "</strong> cho tài khoản Luxury PC.</p>"
                    + "<div style='background:#f0f9ff;border-left:4px solid #0066CC;padding:16px;margin:20px 0;border-radius:4px;'>"
                    + "<p style='margin:0;font-size:14px;color:#64748b;'>Mã OTP của bạn:</p>"
                    + "<p style='font-size:36px;font-weight:bold;letter-spacing:8px;color:#0066CC;margin:8px 0 0;'>" + otp + "</p>"
                    + "</div>"
                    + "<p style='color:#64748b;font-size:13px;'>Mã có hiệu lực trong <strong>5 phút</strong>. Không chia sẻ mã này với ai.</p>"
                    + "<hr style='border:none;border-top:1px solid #e2e8f0;'/>"
                    + "<p style='color:#94a3b8;font-size:12px;margin-bottom:0;'>© Luxury PC - Hệ thống xác thực tự động</p>"
                    + "</div>";
            emailService.sendHtmlEmail(userEmail, subject, body);
        } catch (Exception e) {
            log.error("Gửi email OTP xác thực SĐT thất bại: {}", e.getMessage());
            response.put("success", false);
            response.put("message", "Không thể gửi email OTP. Vui lòng thử lại!");
            return ResponseEntity.internalServerError().body(response);
        }

        response.put("success", true);
        response.put("message", "Đã gửi mã OTP đến email: " + maskEmail(userEmail));
        response.put("maskedEmail", maskEmail(userEmail));
        return ResponseEntity.ok(response);
    }

    private String maskEmail(String email) {
        if (email == null || !email.contains("@")) return email;
        String[] parts = email.split("@");
        String local = parts[0];
        String masked = local.length() <= 3
                ? local.charAt(0) + "***"
                : local.substring(0, 2) + "***" + local.charAt(local.length() - 1);
        return masked + "@" + parts[1];
    }

    // ----------------------------------------------------------------
    // Xác thực OTP và lưu SĐT
    // ----------------------------------------------------------------
    @org.springframework.web.bind.annotation.PostMapping("/verify-phone")
    public ResponseEntity<Map<String, Object>> verifyAndSavePhone(
            Authentication authentication,
            HttpSession session,
            @org.springframework.web.bind.annotation.RequestParam("phone") String phone,
            @org.springframework.web.bind.annotation.RequestParam("otp") String otp) {

        Map<String, Object> response = new java.util.HashMap<>();
        if (authentication == null || !authentication.isAuthenticated()) {
            response.put("success", false);
            response.put("message", "Chưa đăng nhập.");
            return ResponseEntity.status(401).body(response);
        }

        User user = resolveUser(authentication);
        if (user == null) {
            response.put("success", false);
            response.put("message", "Không tìm thấy người dùng.");
            return ResponseEntity.status(404).body(response);
        }

        // Kiểm tra OTP trong session
        String sessionOtp = (String) session.getAttribute("phone_otp_code");
        String sessionPhone = (String) session.getAttribute("phone_otp_phone");
        Long sessionExpiry = (Long) session.getAttribute("phone_otp_expiry");

        if (sessionOtp == null || sessionPhone == null || sessionExpiry == null) {
            response.put("success", false);
            response.put("message", "Phiên OTP không hợp lệ. Vui lòng yêu cầu gửi lại mã!");
            return ResponseEntity.badRequest().body(response);
        }

        if (System.currentTimeMillis() > sessionExpiry) {
            session.removeAttribute("phone_otp_code");
            session.removeAttribute("phone_otp_phone");
            session.removeAttribute("phone_otp_expiry");
            response.put("success", false);
            response.put("message", "Mã OTP đã hết hạn (5 phút). Vui lòng gửi lại mã mới!");
            return ResponseEntity.badRequest().body(response);
        }

        String cleanPhone = phone != null ? phone.trim().replaceAll("\\s+", "") : "";
        String cleanOtp = otp != null ? otp.trim() : "";

        if (!sessionOtp.equals(cleanOtp) || !sessionPhone.equals(cleanPhone)) {
            response.put("success", false);
            response.put("message", "Mã OTP không chính xác!");
            return ResponseEntity.badRequest().body(response);
        }

        if (!cleanPhone.matches("^0(3|5|7|8|9)[0-9]{8}$")) {
            response.put("success", false);
            response.put("message", "Số điện thoại không đúng định dạng Việt Nam!");
            return ResponseEntity.badRequest().body(response);
        }

        java.util.Optional<User> existingUser = userRepository.findByPhone(cleanPhone);
        if (existingUser.isPresent() && !existingUser.get().getId().equals(user.getId())) {
            response.put("success", false);
            response.put("message", "Số điện thoại này đã được liên kết với một tài khoản khác!");
            return ResponseEntity.badRequest().body(response);
        }

        // Lưu SĐT
        user.setPhone(cleanPhone);
        userRepository.save(user);

        // Xóa OTP khỏi session
        session.removeAttribute("phone_otp_code");
        session.removeAttribute("phone_otp_phone");
        session.removeAttribute("phone_otp_expiry");

        response.put("success", true);
        response.put("message", "Xác thực OTP thành công! Số điện thoại đã được cập nhật.");
        response.put("phone", cleanPhone);
        return ResponseEntity.ok(response);
    }
}
