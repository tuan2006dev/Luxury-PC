package poly.edu.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
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

@Controller
@RequestMapping("/admin/employees")
@RequiredArgsConstructor
public class AdminEmployeeController {

    private final UserRepository userRepository;
    private final RoleDAO roleDAO;
    private final UserRoleDAO userRoleDAO;
    private final PasswordEncoder passwordEncoder;
    private final AdminLogRepository adminLogRepository;

    @GetMapping
    public String index(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String roleFilter,
            @RequestParam(required = false) Boolean statusFilter,
            Model model) {

        List<User> employees = userRepository.findAllEmployees();

        // Search filter
        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.toLowerCase().trim();
            employees = employees.stream().filter(u ->
                    (u.getUsername() != null && u.getUsername().toLowerCase().contains(kw)) ||
                    (u.getFullName() != null && u.getFullName().toLowerCase().contains(kw)) ||
                    (u.getEmail() != null && u.getEmail().toLowerCase().contains(kw)) ||
                    (u.getPhone() != null && u.getPhone().contains(kw))
            ).collect(Collectors.toList());
        }

        // Role filter
        if (roleFilter != null && !roleFilter.isBlank() && !"ALL".equalsIgnoreCase(roleFilter)) {
            employees = employees.stream().filter(u -> {
                if (u.getUserRoles() == null) return false;
                return u.getUserRoles().stream()
                        .anyMatch(ur -> ur.getRole() != null && roleFilter.equalsIgnoreCase(ur.getRole().getName()));
            }).collect(Collectors.toList());
        }

        // Status filter
        if (statusFilter != null) {
            employees = employees.stream().filter(u ->
                    statusFilter.equals(u.getStatus())
            ).collect(Collectors.toList());
        }

        long totalEmployees = userRepository.findAllEmployees().size();
        long activeEmployees = userRepository.findAllEmployees().stream().filter(u -> Boolean.TRUE.equals(u.getStatus())).count();
        long adminCount = userRepository.findAllEmployees().stream().filter(u ->
                u.getUserRoles() != null && u.getUserRoles().stream().anyMatch(ur -> ur.getRole() != null && "ADMIN".equalsIgnoreCase(ur.getRole().getName()))
        ).count();
        long staffCount = userRepository.findAllEmployees().stream().filter(u ->
                u.getUserRoles() != null && u.getUserRoles().stream().anyMatch(ur -> ur.getRole() != null && "STAFF".equalsIgnoreCase(ur.getRole().getName()))
        ).count();

        model.addAttribute("employees", employees);
        model.addAttribute("employeeCount", totalEmployees);
        model.addAttribute("activeCount", activeEmployees);
        model.addAttribute("adminCount", adminCount);
        model.addAttribute("staffCount", staffCount);
        model.addAttribute("keyword", keyword);
        model.addAttribute("roleFilter", roleFilter);
        model.addAttribute("statusFilter", statusFilter);
        model.addAttribute("user", new User());

        // Audit Logs (recent 10 logs)
        model.addAttribute("recentLogs", adminLogRepository.findTop50ByOrderByCreatedAtDesc());

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
            // Check username duplicate
            if (userRepository.findByUsername(user.getUsername()).isPresent()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Tên đăng nhập '" + user.getUsername() + "' đã tồn tại!");
                return "redirect:/admin/employees";
            }
            // Check email duplicate
            if (userRepository.findByEmail(user.getEmail()).isPresent()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Email '" + user.getEmail() + "' đã được sử dụng!");
                return "redirect:/admin/employees";
            }

            // Encode password or generate random password if empty
            String rawPassword = user.getPassword();
            if (rawPassword == null || rawPassword.isBlank()) {
                rawPassword = generateRandomPassword();
                redirectAttributes.addFlashAttribute("successMessage", "Đã tạo nhân viên mới! Mật khẩu khởi tạo: " + rawPassword);
            } else {
                redirectAttributes.addFlashAttribute("successMessage", "Đã tạo thành công nhân viên mới!");
            }
            user.setPassword(passwordEncoder.encode(rawPassword));
            if (user.getStatus() == null) user.setStatus(true);
            user.setForceChangePassword(false);

            User savedUser = userRepository.save(user);

            // Assign role
            Role role = roleDAO.findByName(roleName);
            if (role != null) {
                UserRole ur = new UserRole();
                ur.setUser(savedUser);
                ur.setRole(role);
                userRoleDAO.save(ur);
            }

            // Log action
            adminLogRepository.save(new AdminLog(currentAdmin, "Tạo nhân viên (Role: " + roleName + ")", clientIp, savedUser.getUsername()));

        } else {
            // Updating existing employee
            Optional<User> existingOpt = userRepository.findById(user.getId());
            if (existingOpt.isPresent()) {
                User existing = existingOpt.get();

                // Preserve existing password if new one not provided
                if (user.getPassword() == null || user.getPassword().isBlank()) {
                    user.setPassword(existing.getPassword());
                } else {
                    user.setPassword(passwordEncoder.encode(user.getPassword()));
                }

                // Preserve email & username if not changeable
                user.setUsername(existing.getUsername());
                user.setEmail(existing.getEmail());
                user.setCreatedAt(existing.getCreatedAt());
                user.setLastLogin(existing.getLastLogin());
                if (user.getStatus() == null) user.setStatus(existing.getStatus());

                User savedUser = userRepository.save(user);

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
                adminLogRepository.save(new AdminLog(currentAdmin, "Sửa thông tin / Đổi quyền (Role: " + roleName + ")", clientIp, savedUser.getUsername()));
                redirectAttributes.addFlashAttribute("successMessage", "Cập nhật nhân viên " + savedUser.getUsername() + " thành công!");
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
