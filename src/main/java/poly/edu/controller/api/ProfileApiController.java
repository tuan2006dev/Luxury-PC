package poly.edu.controller.api;

import java.util.LinkedHashMap;
import java.util.Map;

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

    public ProfileApiController(UserRepository userRepository, EmailService emailService, poly.edu.service.ProfileService profileService, poly.edu.service.OrderService orderService) {
        this.userRepository = userRepository;
        this.emailService = emailService;
        this.profileService = profileService;
        this.orderService = orderService;
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
}
