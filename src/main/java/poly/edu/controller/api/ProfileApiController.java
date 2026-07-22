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
import poly.edu.dao.OrderDAO;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.Order;
import poly.edu.entity.OrderItem;
import poly.edu.entity.Product;
import poly.edu.service.EmailService;
import org.springframework.security.oauth2.core.user.OAuth2User;

@RestController
@RequestMapping("/api/profile")
@SuppressWarnings("null")
public class ProfileApiController {

    private static final Logger log = LoggerFactory.getLogger(ProfileApiController.class);

    private final UserRepository userRepository;
    private final OrderDAO orderDAO;
    private final ProductDAO productDAO;
    private final EmailService emailService;
    private final poly.edu.service.ProfileService profileService;
    private final poly.edu.service.VoucherService voucherService;
    private final poly.edu.service.FlashSaleService flashSaleService;

    public ProfileApiController(UserRepository userRepository, OrderDAO orderDAO, ProductDAO productDAO, EmailService emailService, poly.edu.service.ProfileService profileService, poly.edu.service.VoucherService voucherService, poly.edu.service.FlashSaleService flashSaleService) {
        this.userRepository = userRepository;
        this.orderDAO = orderDAO;
        this.productDAO = productDAO;
        this.emailService = emailService;
        this.profileService = profileService;
        this.voucherService = voucherService;
        this.flashSaleService = flashSaleService;
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
            // Tạo tên file duy nhất
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String filename = "user_" + user.getId() + "_" + System.currentTimeMillis() + extension;

            // Đường dẫn lưu trữ trong thư mục src
            String srcUploadDir = "src/main/resources/static/uploads/avatars/";
            java.io.File srcFolder = new java.io.File(srcUploadDir);
            if (!srcFolder.exists()) {
                srcFolder.mkdirs();
            }
            java.nio.file.Path srcPath = java.nio.file.Paths.get(srcUploadDir + filename);
            java.nio.file.Files.copy(file.getInputStream(), srcPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);

            // Copy vào thư mục target cho phép hiển thị ảnh ngay lập tức mà không cần build lại dự án
            String targetUploadDir = "target/classes/static/uploads/avatars/";
            java.io.File targetFolder = new java.io.File(targetUploadDir);
            if (targetFolder.exists() || targetFolder.mkdirs()) {
                java.nio.file.Path targetPath = java.nio.file.Paths.get(targetUploadDir + filename);
                try {
                    java.nio.file.Files.copy(srcPath, targetPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                } catch (Exception e) {
                    // Bỏ qua lỗi copy sang target nếu có
                }
            }

            // Cập nhật đường dẫn trong Database
            String avatarPath = "/uploads/avatars/" + filename;
            user.setAvatar(avatarPath);
            userRepository.save(user);

            response.put("success", true);
            response.put("avatarPath", avatarPath);
            return ResponseEntity.ok(response);
        } catch (Exception ex) {
            log.error("[ProfileApi] Error verifying email OTP for user", ex);
            response.put("success", false);
            response.put("message", "Không thể lưu file lúc này: " + ex.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    @org.springframework.web.bind.annotation.RequestMapping(value = {"/orders/{id}/cancel", "/api/orders/{id}/cancel"}, method = {org.springframework.web.bind.annotation.RequestMethod.POST, org.springframework.web.bind.annotation.RequestMethod.GET})
    @org.springframework.transaction.annotation.Transactional
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

        Order order = orderDAO.findById(id).orElse(null);
        if (order == null || order.getUser() == null || !order.getUser().getId().equals(user.getId())) {
            response.put("success", false);
            response.put("message", "Đơn hàng không tồn tại hoặc không thuộc về bạn.");
            return ResponseEntity.status(404).body(response);
        }

        String status = order.getStatus();
        boolean isCancelable = !"COMPLETED".equals(status) && !"HOAN_THANH".equals(status)
                && !"CANCELED".equals(status) && !"CANCELLED".equals(status) && !"DA_HUY".equals(status);
        if (!isCancelable) {
            response.put("success", false);
            response.put("message", "Đơn hàng này không thể hủy (đã hoàn thành hoặc đã hủy trước đó).");
            return ResponseEntity.badRequest().body(response);
        }

        // Cập nhật trạng thái
        order.setStatus("CANCELED");
        orderDAO.save(order);

        // Khôi phục số lượng tồn kho
        if (order.getOrderItems() != null) {
            for (OrderItem item : order.getOrderItems()) {
                Product product = item.getProduct();
                if (product != null) {
                    Integer newStock = (product.getStock() != null ? product.getStock() : 0) + item.getQuantity();
                    product.setStock(newStock);
                    productDAO.save(product);
                    
                    // Khôi phục số lượng flash sale nếu có
                    try {
                        flashSaleService.decrementSoldCount(product.getId(), item.getQuantity());
                    } catch (Exception e) {
                        log.error("Failed to restore flash sale quantity on order cancel", e);
                    }
                }
            }
        }

        // Gửi email thông báo cho Admin
        emailService.sendOrderCancellationEmailToAdmin(order);
        
        // Hoàn trả voucher nếu có
        if (order.getVoucherCode() != null && !order.getVoucherCode().trim().isEmpty() && order.getUser() != null) {
            try {
                voucherService.restoreVoucher(order.getVoucherCode(), order.getUser().getId());
            } catch (Exception e) {
                log.error("Failed to restore voucher on order cancel", e);
            }
        }

        response.put("success", true);
        response.put("message", "Hủy đơn hàng thành công.");
        return ResponseEntity.ok(response);
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
}
