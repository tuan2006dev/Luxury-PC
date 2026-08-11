package poly.edu.controller.web;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.dao.RoleDAO;
import poly.edu.dao.UserRoleDAO;
import poly.edu.entity.Role;
import poly.edu.entity.User;
import poly.edu.entity.UserRole;
import poly.edu.repository.UserRepository;
import poly.edu.service.ProfileService;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/account")
@RequiredArgsConstructor
public class AccountController {

    private final UserRepository userRepository;
    private final RoleDAO roleDAO;
    private final UserRoleDAO userRoleDAO;
    private final ProfileService profileService;
    private final SessionRegistry sessionRegistry;

    // ===============================
    // hiển thị form + danh sách user
    // ===============================
    @GetMapping
    public String users(@RequestParam(name = "keyword", required = false) String keyword, Model model) {

        model.addAttribute("user", new User());

        List<User> users = userRepository.findAllCustomers();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            users = users.stream()
                    .filter(u -> (u.getId() != null && String.valueOf(u.getId()).contains(kw)) ||
                            (u.getUsername() != null && u.getUsername().toLowerCase().contains(kw)) ||
                            (u.getEmail() != null && u.getEmail().toLowerCase().contains(kw)) ||
                            (u.getFullName() != null && u.getFullName().toLowerCase().contains(kw)) ||
                            (u.getPhone() != null && u.getPhone().contains(kw)))
                    .collect(Collectors.toList());
        }

        model.addAttribute("users", users);
        model.addAttribute("keyword", keyword);

        return "admin/account";
    }

    // ===============================
    // lưu user (thêm hoặc update)
    // ===============================
    @PostMapping("/save")
    @Transactional
    public String saveUser(
            @ModelAttribute User user,
            @RequestParam(value = "roleName", defaultValue = "USER") String roleName,
            RedirectAttributes redirectAttributes) {
        // 1. Kiểm tra validation phía Backend (Server-side)
        if (user.getUsername() == null || user.getUsername().isBlank() ||
                user.getEmail() == null || user.getEmail().isBlank() ||
                user.getFullName() == null || user.getFullName().isBlank() ||
                user.getPhone() == null || user.getPhone().isBlank()) {
            redirectAttributes.addFlashAttribute("error",
                    "Vui lòng nhập đầy đủ các thông tin bắt buộc (Username, Email, Họ tên, SĐT)!");
            return "redirect:/admin/account";
        }

        String username = user.getUsername().trim();
        String email = user.getEmail().trim();

        if (user.getId() == null) {
            // Kiểm tra trùng Username khi tạo mới
            if (userRepository.findByUsername(username).isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Tên đăng nhập '" + username + "' đã tồn tại!");
                return "redirect:/admin/account";
            }

            // Kiểm tra trùng Email khi tạo mới
            if (userRepository.findByEmail(email).isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Email '" + email + "' đã được sử dụng!");
                return "redirect:/admin/account";
            }
            redirectAttributes.addFlashAttribute("message", "Thêm khách hàng thành công!");
        } else {
            // Kiểm tra trùng Email với người dùng khác khi cập nhật
            Optional<User> existingEmailUser = userRepository.findByEmail(email);
            if (existingEmailUser.isPresent() && !existingEmailUser.get().getId().equals(user.getId())) {
                redirectAttributes.addFlashAttribute("error",
                        "Email '" + email + "' đã được sử dụng bởi tài khoản khác!");
                return "redirect:/admin/account";
            }
            redirectAttributes.addFlashAttribute("message", "Cập nhật thông tin khách hàng thành công!");
        }

        // nếu không nhập password thì giữ nguyên password cũ
        if (user.getId() != null) {
            Optional<User> oldUser = userRepository.findById(user.getId());
            if (oldUser.isPresent()) {
                if (user.getPassword() == null || user.getPassword().isEmpty()) {
                    user.setPassword(oldUser.get().getPassword());
                }
            }
        }

        user = userRepository.save(user);

        Role role = roleDAO.findByName(roleName);
        if (role != null) {
            userRoleDAO.deleteByUserId(user.getId());
            UserRole userRole = new UserRole();
            userRole.setUser(user);
            userRole.setRole(role);
            userRoleDAO.save(userRole);
        }

        return "redirect:/admin/account";
    }

    // ===============================
    // load user lên form để sửa
    // ===============================
    @GetMapping("/edit/{id}")
    public String editUser(
            @PathVariable Integer id,
            @RequestParam(name = "keyword", required = false) String keyword,
            Model model
    ){

        Optional<User> userOptional =
                userRepository.findById(id);

        if(userOptional.isPresent()){
            User u = userOptional.get();
            model.addAttribute("user", u);
            String currentRole = "USER";
            if(u.getUserRoles() != null && !u.getUserRoles().isEmpty()) {
                currentRole = u.getUserRoles().get(0).getRole().getName();
            }
            model.addAttribute("currentRole", currentRole);
        }else{
            model.addAttribute("currentRole", "USER");

            model.addAttribute(
                    "user",
                    new User()
            );
        }

        List<User> users = userRepository.findAllCustomers();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            users = users.stream()
                    .filter(u -> (u.getId() != null && String.valueOf(u.getId()).contains(kw)) ||
                            (u.getUsername() != null && u.getUsername().toLowerCase().contains(kw)) ||
                            (u.getEmail() != null && u.getEmail().toLowerCase().contains(kw)) ||
                            (u.getFullName() != null && u.getFullName().toLowerCase().contains(kw)) ||
                            (u.getPhone() != null && u.getPhone().contains(kw)))
                    .collect(Collectors.toList());
        }

        model.addAttribute("users", users);
        model.addAttribute("keyword", keyword);

        return "admin/account";
    }



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

    // ===============================
    // khóa user
    // ===============================
    @RequestMapping(value = "/lock/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    @Transactional
    public String lockUser(@PathVariable Integer id, RedirectAttributes ra) {
        Optional<User> userOptional = userRepository.findById(id);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.setStatus(false);
            userRepository.save(user);
            invalidateUserSessions(user);
            ra.addFlashAttribute("message", "Đã khóa tài khoản " + user.getUsername());
        } else {
            ra.addFlashAttribute("error", "Không tìm thấy tài khoản.");
        }
        return "redirect:/admin/account";
    }

    // ===============================
    // mở khóa user
    // ===============================
    @RequestMapping(value = "/unlock/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    @Transactional
    public String unlockUser(@PathVariable Integer id, RedirectAttributes ra) {
        Optional<User> userOptional = userRepository.findById(id);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.setStatus(true);
            userRepository.save(user);
            ra.addFlashAttribute("message", "Đã mở khóa tài khoản " + user.getUsername());
        } else {
            ra.addFlashAttribute("error", "Không tìm thấy tài khoản.");
        }
        return "redirect:/admin/account";
    }

    // ===============================
    // xóa user
    // ===============================
    @RequestMapping(value = "/delete/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    @Transactional
    public String deleteUser(@PathVariable Integer id, RedirectAttributes ra) {
        Optional<User> userOptional = userRepository.findById(id);
        if (userOptional.isPresent()) {
            try {
                profileService.deleteUserFully(userOptional.get());
                ra.addFlashAttribute("message", "Đã xóa người dùng thành công.");
            } catch (Exception e) {
                ra.addFlashAttribute("error", "Không thể xóa người dùng: " + e.getMessage());
            }
        }
        return "redirect:/admin/account";
    }
}