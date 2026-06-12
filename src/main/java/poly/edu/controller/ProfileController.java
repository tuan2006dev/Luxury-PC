package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.core.session.SessionInformation;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.Optional;
import poly.edu.repository.UserRepository;

import poly.edu.dao.OrderDAO;
import poly.edu.dto.ProfileUpdateRequest;
import poly.edu.entity.User;
import poly.edu.service.EmailService;
import poly.edu.service.ProfileService;
import poly.edu.service.WishlistService;

@Controller
public class ProfileController {

    private final OrderDAO orderDAO;
    private final ProfileService profileService;
    private final WishlistService wishlistService;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;
    private final SessionRegistry sessionRegistry;

    public ProfileController(OrderDAO orderDAO, ProfileService profileService, WishlistService wishlistService, EmailService emailService, PasswordEncoder passwordEncoder, SessionRegistry sessionRegistry) {
        this.orderDAO = orderDAO;
        this.profileService = profileService;
        this.wishlistService = wishlistService;
        this.emailService = emailService;
        this.passwordEncoder = passwordEncoder;
        this.sessionRegistry = sessionRegistry;
    }

    @Autowired
    private poly.edu.service.UserVoucherService userVoucherService;

    @Autowired
    private poly.edu.service.CustomerOrderService customerOrderService;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/profile")
    public String profile(Authentication authentication, Model model, HttpServletRequest request, HttpSession session) {
        try {
            User user = profileService.getCurrentUser(authentication);
            model.addAttribute("user", user);
            model.addAttribute("profile", profileService.getCurrentProfile(authentication));
            model.addAttribute("name",
                    user.getFullName() != null && !user.getFullName().isEmpty() ? user.getFullName() : user.getUsername());
            model.addAttribute("email", user.getEmail());
            model.addAttribute("avatarInitial", getAvatarInitial(user));

            Double totalSpent = orderDAO.getTotalSpentByUser(user.getId());
            if (totalSpent == null) {
                totalSpent = 0.0;
            }

            Long totalOrders = orderDAO.countOrdersByUser(user.getId());
            if (totalOrders == null) {
                totalOrders = 0L;
            }

            model.addAttribute("totalSpent", totalSpent);
            model.addAttribute("totalOrders", totalOrders);
            model.addAttribute("userRank", getRank(totalSpent));
            model.addAttribute("rankClass", getRankClass(totalSpent));
            model.addAttribute("orders", orderDAO.findByUserIdOrderByCreatedAtDesc(user.getId()));
            model.addAttribute("wishlistItems", wishlistService.getWishlistItems(authentication));
            model.addAttribute("wishlistCount", wishlistService.getWishlistCount(authentication));
            model.addAttribute("addresses", profileService.getCurrentUserAddresses(authentication));
            model.addAttribute("notificationSettings", profileService.getCurrentUserNotificationSettings(authentication));
            model.addAttribute("currentSessionInfo", buildCurrentSessionInfo(request, session));

            // Ví Voucher
            java.util.List<poly.edu.entity.UserVoucher> userVouchers = userVoucherService.getMyVouchers(user);
            model.addAttribute("vouchers", userVouchers);
        } catch (Exception ex) {
            String fallbackName = authentication != null ? authentication.getName() : "";
            model.addAttribute("name", fallbackName);
            model.addAttribute("email", fallbackName);
            model.addAttribute("avatarInitial", "U");
            model.addAttribute("profile", null);
            model.addAttribute("totalSpent", 0.0);
            model.addAttribute("totalOrders", 0L);
            model.addAttribute("userRank", "None");
            model.addAttribute("rankClass", "rank-none");
            model.addAttribute("orders", new java.util.ArrayList<>());
            model.addAttribute("wishlistItems", new java.util.ArrayList<>());
            model.addAttribute("wishlistCount", 0L);
            model.addAttribute("addresses", new java.util.ArrayList<>());
            model.addAttribute("notificationSettings", null);
            model.addAttribute("currentSessionInfo", "Không xác định");
            model.addAttribute("vouchers", new java.util.ArrayList<>());
        }

        return "account/profile";
    }

    @PostMapping("/profile/address")
    public String addShippingAddress(
            Authentication authentication,
            @RequestParam("recipientName") String recipientName,
            @RequestParam("phone") String phone,
            @RequestParam("addressLine") String addressLine,
            @RequestParam(value = "district", required = false) String district,
            @RequestParam(value = "city", required = false) String city,
            RedirectAttributes redirectAttributes) {
        try {
            profileService.addUserAddress(authentication, recipientName, phone, addressLine, district, city);
            redirectAttributes.addFlashAttribute("addressMessage", "Đã lưu địa chỉ giao hàng.");
            redirectAttributes.addFlashAttribute("addressMessageType", "success");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("addressMessage", "Không thể lưu địa chỉ. Vui lòng kiểm tra lại thông tin.");
            redirectAttributes.addFlashAttribute("addressMessageType", "error");
            return "redirect:/profile?tab=address&openForm=1";
        }
        return "redirect:/profile?tab=address";
    }

    @PostMapping("/profile/address/{id}/default")
    public String setDefaultAddress(
            Authentication authentication,
            @PathVariable("id") Integer id,
            RedirectAttributes redirectAttributes) {
        try {
            profileService.setDefaultAddress(authentication, id);
            redirectAttributes.addFlashAttribute("addressMessage", "Đã cập nhật địa chỉ mặc định.");
            redirectAttributes.addFlashAttribute("addressMessageType", "success");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("addressMessage", "Không thể cập nhật địa chỉ mặc định.");
            redirectAttributes.addFlashAttribute("addressMessageType", "error");
        }
        return "redirect:/profile?tab=address";
    }

    @PostMapping("/profile/address/{id}/delete")
    public String deleteAddress(
            Authentication authentication,
            @PathVariable("id") Integer id,
            RedirectAttributes redirectAttributes) {
        try {
            profileService.deleteAddress(authentication, id);
            redirectAttributes.addFlashAttribute("addressMessage", "Đã xóa địa chỉ.");
            redirectAttributes.addFlashAttribute("addressMessageType", "success");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("addressMessage", "Không thể xóa địa chỉ.");
            redirectAttributes.addFlashAttribute("addressMessageType", "error");
        }
        return "redirect:/profile?tab=address";
    }

    @PostMapping("/profile/address/{id}/update")
    public String updateAddress(
            Authentication authentication,
            @PathVariable("id") Integer id,
            @RequestParam("recipientName") String recipientName,
            @RequestParam("phone") String phone,
            @RequestParam("addressLine") String addressLine,
            @RequestParam(value = "district", required = false) String district,
            @RequestParam(value = "city", required = false) String city,
            RedirectAttributes redirectAttributes) {
        try {
            profileService.updateAddress(authentication, id, recipientName, phone, addressLine, district, city);
            redirectAttributes.addFlashAttribute("addressMessage", "Đã cập nhật địa chỉ.");
            redirectAttributes.addFlashAttribute("addressMessageType", "success");
            return "redirect:/profile?tab=address";
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("addressMessage", "Không thể cập nhật địa chỉ. Vui lòng kiểm tra lại thông tin.");
            redirectAttributes.addFlashAttribute("addressMessageType", "error");
            return "redirect:/profile?tab=address&openEdit=" + id;
        }
    }

    @PostMapping("/profile/update")
    public String updateProfile(
            Authentication authentication,
            @RequestParam(value = "firstName", required = false) String firstName,
            @RequestParam(value = "lastName", required = false) String lastName,
            @RequestParam(value = "email", required = false) String email,
            @RequestParam(value = "emailOtp", required = false) String emailOtp,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "birthday", required = false) String birthday,
            @RequestParam(value = "gender", required = false) String gender,
            RedirectAttributes redirectAttributes) {
        try {
            User currentUser = profileService.getCurrentUser(authentication);
            String normalizedNewEmail = normalize(email);
            String currentEmail = normalize(currentUser.getEmail());
            boolean emailChanged = normalizedNewEmail != null && !normalizedNewEmail.equalsIgnoreCase(currentEmail);

            if (emailChanged) {
                if (profileService.isEmailUsedByAnotherUser(authentication, normalizedNewEmail)) {
                    redirectAttributes.addFlashAttribute("profileMessage", "Email đã được sử dụng bởi tài khoản khác.");
                    redirectAttributes.addFlashAttribute("profileMessageType", "error");
                    return "redirect:/profile?tab=info&openEdit=1";
                }

                if (emailOtp == null || emailOtp.trim().isEmpty()) {
                    redirectAttributes.addFlashAttribute("profileMessage", "Vui lòng nhập mã OTP để xác minh email mới.");
                    redirectAttributes.addFlashAttribute("profileMessageType", "error");
                    return "redirect:/profile?tab=info&openEdit=1";
                }

                boolean validOtp = emailService.verifyOtp(normalizedNewEmail, emailOtp.trim());
                if (!validOtp) {
                    redirectAttributes.addFlashAttribute("profileMessage", "Mã OTP không đúng hoặc đã hết hiệu lực.");
                    redirectAttributes.addFlashAttribute("profileMessageType", "error");
                    return "redirect:/profile?tab=info&openEdit=1";
                }
            }

            ProfileUpdateRequest request = new ProfileUpdateRequest();
            request.setFirstName(firstName);
            request.setLastName(lastName);
            request.setEmail(normalizedNewEmail);
            request.setPhone(phone);
            request.setBirthday(birthday);
            request.setGender(gender);

            profileService.updateCurrentProfile(authentication, request);
            redirectAttributes.addFlashAttribute("profileMessage", "Đã cập nhật thông tin cá nhân.");
            redirectAttributes.addFlashAttribute("profileMessageType", "success");
            return "redirect:/profile?tab=info";
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("profileMessage", "Không thể cập nhật thông tin. Vui lòng kiểm tra lại dữ liệu.");
            redirectAttributes.addFlashAttribute("profileMessageType", "error");
            return "redirect:/profile?tab=info&openEdit=1";
        }
    }

    @PostMapping("/profile/notifications")
    public String updateNotifications(
            Authentication authentication,
            @RequestParam(value = "orderUpdates", defaultValue = "false") boolean orderUpdates,
            @RequestParam(value = "flashSale", defaultValue = "false") boolean flashSale,
            @RequestParam(value = "newProducts", defaultValue = "false") boolean newProducts,
            @RequestParam(value = "weeklyNewsletter", defaultValue = "false") boolean weeklyNewsletter,
            RedirectAttributes redirectAttributes) {
        try {
            profileService.updateNotificationSettings(
                    authentication,
                    orderUpdates,
                    flashSale,
                    newProducts,
                    weeklyNewsletter
            );
            redirectAttributes.addFlashAttribute("notificationMessage", "Đã lưu cài đặt thông báo.");
            redirectAttributes.addFlashAttribute("notificationMessageType", "success");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("notificationMessage", "Không thể lưu cài đặt thông báo.");
            redirectAttributes.addFlashAttribute("notificationMessageType", "error");
        }
        return "redirect:/profile?tab=notifications";
    }

    @PostMapping("/profile/password")
    public String changePassword(
            Authentication authentication,
            @RequestParam(value = "currentPassword", required = false) String currentPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            RedirectAttributes redirectAttributes) {
        try {
            User user = profileService.getCurrentUser(authentication);
            String currentPasswordHash = user.getPassword();

            if (newPassword == null || newPassword.trim().length() < 8) {
                redirectAttributes.addFlashAttribute("securityMessage", "Mật khẩu mới phải có ít nhất 8 ký tự.");
                redirectAttributes.addFlashAttribute("securityMessageType", "error");
                return "redirect:/profile?tab=security&openPasswordForm=1";
            }

            if (!newPassword.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("securityMessage", "Xác nhận mật khẩu mới không khớp.");
                redirectAttributes.addFlashAttribute("securityMessageType", "error");
                return "redirect:/profile?tab=security&openPasswordForm=1";
            }

            boolean hasExistingPassword = currentPasswordHash != null && !currentPasswordHash.isBlank();
            if (hasExistingPassword) {
                if (currentPassword == null || currentPassword.isBlank() || !passwordEncoder.matches(currentPassword, currentPasswordHash)) {
                    redirectAttributes.addFlashAttribute("securityMessage", "Mật khẩu hiện tại không đúng.");
                    redirectAttributes.addFlashAttribute("securityMessageType", "error");
                    return "redirect:/profile?tab=security&openPasswordForm=1";
                }
            }

            user.setPassword(passwordEncoder.encode(newPassword));
            profileService.saveUser(user);
            redirectAttributes.addFlashAttribute("securityMessage", "Đổi mật khẩu thành công.");
            redirectAttributes.addFlashAttribute("securityMessageType", "success");
            return "redirect:/profile?tab=security";
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("securityMessage", "Không thể đổi mật khẩu lúc này.");
            redirectAttributes.addFlashAttribute("securityMessageType", "error");
            return "redirect:/profile?tab=security&openPasswordForm=1";
        }
    }

    @PostMapping("/profile/logout-others")
    public String logoutOtherSessions(
            Authentication authentication,
            HttpSession currentSession,
            RedirectAttributes redirectAttributes) {
        try {
            if (authentication == null || currentSession == null) {
                redirectAttributes.addFlashAttribute("securityMessage", "Không thể xử lý phiên đăng nhập.");
                redirectAttributes.addFlashAttribute("securityMessageType", "error");
                return "redirect:/profile?tab=security";
            }

            String currentSessionId = currentSession.getId();
            String currentPrincipalName = authentication.getName();
            int expiredCount = 0;

            for (Object principal : sessionRegistry.getAllPrincipals()) {
                String principalName = extractPrincipalName(principal);
                if (principalName == null || !principalName.equals(currentPrincipalName)) {
                    continue;
                }

                java.util.List<SessionInformation> sessions = sessionRegistry.getAllSessions(principal, false);
                for (SessionInformation sessionInfo : sessions) {
                    if (sessionInfo == null || sessionInfo.isExpired()) {
                        continue;
                    }
                    if (currentSessionId.equals(sessionInfo.getSessionId())) {
                        continue;
                    }
                    sessionInfo.expireNow();
                    expiredCount++;
                }
            }

            if (expiredCount > 0) {
                redirectAttributes.addFlashAttribute("securityMessage", "Đã đăng xuất " + expiredCount + " phiên đăng nhập khác.");
            } else {
                redirectAttributes.addFlashAttribute("securityMessage", "Không có phiên đăng nhập khác để đăng xuất.");
            }
            redirectAttributes.addFlashAttribute("securityMessageType", "success");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("securityMessage", "Không thể đăng xuất các phiên khác lúc này.");
            redirectAttributes.addFlashAttribute("securityMessageType", "error");
        }
        return "redirect:/profile?tab=security";
    }

    @PostMapping("/profile/email-otp/send")
    @ResponseBody
    public java.util.Map<String, String> sendEmailOtp(
            Authentication authentication,
            @RequestParam("email") String email) {
        java.util.Map<String, String> response = new java.util.HashMap<>();
        try {
            User currentUser = profileService.getCurrentUser(authentication);
            String normalizedNewEmail = normalize(email);
            String currentEmail = normalize(currentUser.getEmail());

            if (normalizedNewEmail == null || normalizedNewEmail.isEmpty()) {
                response.put("status", "error");
                response.put("message", "Email không được để trống.");
                return response;
            }
            if (normalizedNewEmail.equalsIgnoreCase(currentEmail)) {
                response.put("status", "error");
                response.put("message", "Email mới phải khác email hiện tại.");
                return response;
            }
            if (profileService.isEmailUsedByAnotherUser(authentication, normalizedNewEmail)) {
                response.put("status", "error");
                response.put("message", "Email đã được sử dụng bởi tài khoản khác.");
                return response;
            }

            emailService.sendOtpEmail(normalizedNewEmail, normalizedNewEmail);
            response.put("status", "success");
            response.put("message", "Đã gửi OTP tới email mới.");
            return response;
        } catch (Exception ex) {
            response.put("status", "error");
            response.put("message", "Không thể gửi OTP lúc này. Vui lòng thử lại.");
            return response;
        }
    }

    private String normalize(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String getAvatarInitial(User user) {
        if (user.getFullName() != null && !user.getFullName().isEmpty()) {
            String[] parts = user.getFullName().split(" ");
            if (parts.length > 0 && !parts[parts.length - 1].isEmpty()) {
                return parts[parts.length - 1].substring(0, 1).toUpperCase();
            }
        }

        if (user.getUsername() != null && !user.getUsername().isEmpty()) {
            return user.getUsername().substring(0, 1).toUpperCase();
        }

        return "U";
    }

    private String extractPrincipalName(Object principal) {
        if (principal instanceof UserDetails userDetails) {
            return userDetails.getUsername();
        }
        if (principal instanceof OAuth2User oauth2User) {
            return oauth2User.getName();
        }
        if (principal instanceof String principalName) {
            return principalName;
        }
        return null;
    }

    private String buildCurrentSessionInfo(HttpServletRequest request, HttpSession session) {
        String userAgent = request != null ? request.getHeader("User-Agent") : "";
        String browser = detectBrowser(userAgent);
        String os = detectOS(userAgent);
        String location = detectLocation(request);
        String loginAt = formatSessionStart(session);
        return browser + " · " + os + " · " + location + " — Đăng nhập " + loginAt;
    }

    private String detectBrowser(String userAgent) {
        if (userAgent == null) return "Trình duyệt khác";
        String ua = userAgent.toLowerCase();
        if (ua.contains("edg/")) return "Edge";
        if (ua.contains("chrome/")) return "Chrome";
        if (ua.contains("firefox/")) return "Firefox";
        if (ua.contains("safari/") && !ua.contains("chrome/")) return "Safari";
        return "Trình duyệt khác";
    }

    private String detectOS(String userAgent) {
        if (userAgent == null) return "Hệ điều hành khác";
        String ua = userAgent.toLowerCase();
        if (ua.contains("windows")) return "Windows";
        if (ua.contains("mac os")) return "macOS";
        if (ua.contains("android")) return "Android";
        if (ua.contains("iphone") || ua.contains("ipad") || ua.contains("ios")) return "iOS";
        if (ua.contains("linux")) return "Linux";
        return "Hệ điều hành khác";
    }

    private String detectLocation(HttpServletRequest request) {
        if (request == null) return "Không xác định";
        String forwardedFor = request.getHeader("X-Forwarded-For");
        String ip = (forwardedFor != null && !forwardedFor.isBlank()) ? forwardedFor.split(",")[0].trim() : request.getRemoteAddr();
        if (ip == null || ip.isBlank()) return "Không xác định";
        if ("127.0.0.1".equals(ip) || "::1".equals(ip) || "0:0:0:0:0:0:0:1".equals(ip)) {
            return "Localhost";
        }
        return ip;
    }

    private String formatSessionStart(HttpSession session) {
        if (session == null) return "không rõ";
        java.time.Instant instant = java.time.Instant.ofEpochMilli(session.getCreationTime());
        java.time.ZonedDateTime zonedDateTime = instant.atZone(java.time.ZoneId.systemDefault());
        return java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm").format(zonedDateTime);
    }

    private String getRank(Double totalSpent) {
        if (totalSpent >= 200_000_000) {
            return "Diamond";
        }
        if (totalSpent >= 50_000_000) {
            return "Platinum";
        }
        if (totalSpent >= 10_000_000) {
            return "Silver";
        }
        return "None";
    }

    private String getRankClass(Double totalSpent) {
        if (totalSpent >= 200_000_000) {
            return "rank-diamond";
        }
        if (totalSpent >= 50_000_000) {
            return "rank-platinum";
        }
        if (totalSpent >= 10_000_000) {
            return "rank-silver";
        }
        return "rank-none";
    }

    @PostMapping("/profile/orders/request-refund")
    public String requestRefund(@AuthenticationPrincipal Object principal,
                                @RequestParam Integer orderId,
                                @RequestParam String reason) {
        findCurrentUser(principal).ifPresent(user -> customerOrderService.requestRefund(orderId, user, reason));
        return "redirect:/profile";
    }

    private Optional<User> findCurrentUser(Object principal) {
        String usernameOrEmail = "";
        if (principal instanceof OAuth2User oauthUser) {
            usernameOrEmail = (String) oauthUser.getAttributes().get("email");
        } else if (principal instanceof org.springframework.security.core.userdetails.User user) {
            usernameOrEmail = user.getUsername();
        }

        Optional<User> user = userRepository.findByEmail(usernameOrEmail);
        return user.isPresent() ? user : userRepository.findByUsername(usernameOrEmail);
    }
}
