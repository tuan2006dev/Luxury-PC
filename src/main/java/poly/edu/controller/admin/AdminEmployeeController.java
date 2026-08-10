package poly.edu.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.dao.RoleDAO;
import poly.edu.dao.UserRoleDAO;
import poly.edu.entity.AdminLog;
import poly.edu.entity.Role;
import poly.edu.entity.User;
import poly.edu.entity.UserRole;
import poly.edu.repository.AdminLogRepository;
import poly.edu.repository.UserRepository;

import java.security.Principal;
import java.security.SecureRandom;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Controller
@RequestMapping("/admin/employees")
@RequiredArgsConstructor
@Transactional
public class AdminEmployeeController {

    private final UserRepository userRepository;
    private final RoleDAO roleDAO;
    private final UserRoleDAO userRoleDAO;
    private final PasswordEncoder passwordEncoder;
    private final AdminLogRepository adminLogRepository;
    private final poly.edu.service.EmailService emailService;
    private final poly.edu.service.ProfileService profileService;
    private final org.springframework.security.core.session.SessionRegistry sessionRegistry;

    private void invalidateUserSessions(User user) {
        if (user == null || sessionRegistry == null) return;
        try {
            String targetEmail = user.getEmail() != null ? user.getEmail().trim().toLowerCase() : "";
            String targetUsername = user.getUsername() != null ? user.getUsername().trim().toLowerCase() : "";

            for (Object principal : sessionRegistry.getAllPrincipals()) {
                String pName = "";
                if (principal instanceof org.springframework.security.core.userdetails.UserDetails ud) {
                    pName = ud.getUsername();
                } else if (principal instanceof poly.edu.security.CustomOAuth2User oauthUser) {
                    pName = oauthUser.getEmail();
                } else {
                    pName = String.valueOf(principal);
                }

                if (pName != null && !pName.isBlank()) {
                    String cleanPName = pName.trim().toLowerCase();
                    if (cleanPName.equals(targetEmail) || cleanPName.equals(targetUsername)) {
                        for (org.springframework.security.core.session.SessionInformation sess : sessionRegistry.getAllSessions(principal, false)) {
                            sess.expireNow();
                        }
                    }
                }
            }
        } catch (Exception ignored) {}
    }

    @GetMapping
    public String index(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Boolean statusFilter,
            Model model) {

        List<User> employees = userRepository.findAllEmployees();

        // Search filter
        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.toLowerCase().trim();
            employees = employees.stream()
                    .filter(u -> (u.getUsername() != null && u.getUsername().toLowerCase().contains(kw)) ||
                            (u.getFullName() != null && u.getFullName().toLowerCase().contains(kw)) ||
                            (u.getEmail() != null && u.getEmail().toLowerCase().contains(kw)) ||
                            (u.getPhone() != null && u.getPhone().contains(kw)))
                    .collect(Collectors.toList());
        }

        // Status filter
        if (statusFilter != null) {
            employees = employees.stream().filter(u -> statusFilter.equals(u.getStatus())).collect(Collectors.toList());
        }

        List<User> allStaff = userRepository.findAllEmployees();
        long totalStaff = allStaff.size();
        long activeStaff = allStaff.stream().filter(u -> Boolean.TRUE.equals(u.getStatus())).count();
        long lockedStaff = allStaff.stream().filter(u -> Boolean.FALSE.equals(u.getStatus())).count();

        model.addAttribute("employees", employees);
        model.addAttribute("employeeCount", totalStaff);
        model.addAttribute("activeCount", activeStaff);
        model.addAttribute("lockedCount", lockedStaff);
        model.addAttribute("keyword", keyword);
        model.addAttribute("statusFilter", statusFilter);
        model.addAttribute("user", new User());

        // Audit Logs (recent 50 logs for STAFF only)
        model.addAttribute("recentLogs", adminLogRepository.findStaffLogsTop50());

        return "admin/employees";
    }

    @PostMapping("/save")
    public String saveEmployee(
            @ModelAttribute User user,
            @RequestParam(value = "roleName", defaultValue = "STAFF") String roleName,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {

        String currentAdmin = principal != null ? principal.getName() : "ADMIN";
        String clientIp = getClientIp(request);

        boolean isNew = (user.getId() == null);

        if (isNew) {
            // Server-side validation: Chặn hoàn toàn dữ liệu rỗng
            if (user.getUsername() == null || user.getUsername().isBlank() ||
                user.getEmail() == null || user.getEmail().isBlank() ||
                user.getFullName() == null || user.getFullName().isBlank() ||
                user.getPhone() == null || user.getPhone().isBlank()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Vui lòng nhập đầy đủ các thông tin bắt buộc (Username, Email, Họ tên, SĐT)!");
                return "redirect:/admin/employees";
            }
            // Check disposable / fake email domain
            if (user.getEmail() != null) {
                String emailLower = user.getEmail().toLowerCase().trim();
                String[] fakeDomains = {"mailinator.com", "yopmail.com", "tempmail.com", "10minutemail.com", "dispostable.com", "guerrillamail.com", "fake.com"};
                for (String domain : fakeDomains) {
                    if (emailLower.endsWith("@" + domain)) {
                        redirectAttributes.addFlashAttribute("errorMessage", "Email không hợp lệ hoặc sử dụng tên miền email rác (" + domain + ")!");
                        return "redirect:/admin/employees";
                    }
                }
            }

            // Check username duplicate
            if (userRepository.findByUsername(user.getUsername()).isPresent()) {
                redirectAttributes.addFlashAttribute("errorMessage",
                        "Tên đăng nhập '" + user.getUsername() + "' đã tồn tại!");
                return "redirect:/admin/employees";
            }
            // Check email duplicate
            if (userRepository.findByEmail(user.getEmail()).isPresent()) {
                redirectAttributes.addFlashAttribute("errorMessage",
                        "Email '" + user.getEmail() + "' đã được sử dụng!");
                return "redirect:/admin/employees";
            }

            // Encode password or generate random password if empty
            String rawPassword = user.getPassword();
            if (rawPassword == null || rawPassword.isBlank()) {
                rawPassword = generateRandomPassword();
                redirectAttributes.addFlashAttribute("successMessage",
                        "Đã tạo nhân viên mới! Thông tin và mật khẩu khởi tạo đã được gửi tới email " + user.getEmail());
            } else {
                redirectAttributes.addFlashAttribute("successMessage", "Đã tạo thành công nhân viên mới và gửi email thông báo!");
            }
            user.setPassword(passwordEncoder.encode(rawPassword));
            if (user.getStatus() == null)
                user.setStatus(true);
            user.setForceChangePassword(true);

            User savedUser = userRepository.save(user);

            // Send email to staff with credentials
            try {
                emailService.sendStaffWelcomeEmail(savedUser, rawPassword);
            } catch (Exception e) {
                log.error("Lỗi gửi email cấp tài khoản nhân viên: {}", e.getMessage());
            }

            // Assign role
            Role role = roleDAO.findByName(roleName);
            if (role != null) {
                UserRole ur = new UserRole();
                ur.setUser(savedUser);
                ur.setRole(role);
                userRoleDAO.save(ur);
            }

            // Log action
            adminLogRepository.save(new AdminLog(currentAdmin, "Tạo nhân viên (Role: " + roleName + ")", clientIp,
                    savedUser.getUsername()));

        } else {
            // Updating existing employee
            Optional<User> existingOpt = userRepository.findById(user.getId());
            if (existingOpt.isPresent()) {
                User existing = existingOpt.get();

                existing.setFullName(user.getFullName());
                existing.setPhone(user.getPhone());
                existing.setAddress(user.getAddress());
                existing.setGender(user.getGender());

                // Preserve existing password if new one not provided
                if (user.getPassword() != null && !user.getPassword().isBlank()) {
                    existing.setPassword(passwordEncoder.encode(user.getPassword()));
                }

                if (user.getStatus() != null) {
                    existing.setStatus(user.getStatus());
                }

                User savedUser = userRepository.save(existing);

                // Update role
                Role role = roleDAO.findByName(roleName);
                if (role != null) {
                    userRoleDAO.deleteByUserId(savedUser.getId());
                    UserRole ur = new UserRole();
                    ur.setUser(savedUser);
                    ur.setRole(role);
                    userRoleDAO.save(ur);
                }

                // Log action
                adminLogRepository.save(new AdminLog(currentAdmin, "Sửa thông tin nhân viên (Role: " + roleName + ")",
                        clientIp, savedUser.getUsername()));
                redirectAttributes.addFlashAttribute("successMessage",
                        "Cập nhật nhân viên " + savedUser.getUsername() + " thành công!");
            }
        }

        return "redirect:/admin/employees";
    }

    @PostMapping("/toggle-status/{id}")
    public String toggleStatus(
            @PathVariable Integer id,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {

        String currentAdmin = principal != null ? principal.getName() : "ADMIN";
        String clientIp = getClientIp(request);

        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isPresent()) {
            User u = userOpt.get();
            boolean newStatus = !Boolean.TRUE.equals(u.getStatus());
            u.setStatus(newStatus);
            userRepository.save(u);
            if (!newStatus) {
                invalidateUserSessions(u);
            }

            String actionStr = newStatus ? "Mở khóa tài khoản" : "Khóa tài khoản";
            adminLogRepository.save(new AdminLog(currentAdmin, actionStr, clientIp, u.getUsername()));

            redirectAttributes.addFlashAttribute("successMessage", actionStr + " " + u.getUsername() + " thành công!");
        }

        return "redirect:/admin/employees";
    }

    @PostMapping("/reset-password/{id}")
    public String resetPassword(
            @PathVariable Integer id,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {

        String currentAdmin = principal != null ? principal.getName() : "ADMIN";
        String clientIp = getClientIp(request);

        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isPresent()) {
            User u = userOpt.get();
            String newPlainPassword = generateRandomPassword();
            u.setPassword(passwordEncoder.encode(newPlainPassword));
            u.setForceChangePassword(true);
            userRepository.save(u);

            adminLogRepository.save(new AdminLog(currentAdmin, "Reset password", clientIp, u.getUsername()));

            redirectAttributes.addFlashAttribute("successMessage",
                    "Đã reset mật khẩu cho nhân viên " + u.getUsername() + "! Mật khẩu mới: " + newPlainPassword);
        }

        return "redirect:/admin/employees";
    }

    @PostMapping("/delete/{id}")
    public String deleteEmployee(
            @PathVariable Integer id,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {

        String currentAdmin = principal != null ? principal.getName() : "ADMIN";
        String clientIp = getClientIp(request);

        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isPresent()) {
            User u = userOpt.get();
            if (u.getUsername().equalsIgnoreCase(currentAdmin)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Không thể xóa chính tài khoản đang đăng nhập!");
                return "redirect:/admin/employees";
            }

            profileService.deleteUserFully(u);

            adminLogRepository.save(new AdminLog(currentAdmin, "Xóa tài khoản nhân viên", clientIp, u.getUsername()));
            redirectAttributes.addFlashAttribute("successMessage", "Đã xóa vĩnh viễn nhân viên " + u.getUsername() + " thành công!");
        }

        return "redirect:/admin/employees";
    }

    private String generateRandomPassword() {
        String upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String lower = "abcdefghijklmnopqrstuvwxyz";
        String digits = "0123456789";
        String special = "@#$!";
        String all = upper + lower + digits + special;

        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder();
        sb.append(upper.charAt(random.nextInt(upper.length())));
        sb.append(lower.charAt(random.nextInt(lower.length())));
        sb.append(digits.charAt(random.nextInt(digits.length())));
        sb.append(special.charAt(random.nextInt(special.length())));

        for (int i = 4; i < 10; i++) {
            sb.append(all.charAt(random.nextInt(all.length())));
        }

        return sb.toString();
    }

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isBlank() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
}
