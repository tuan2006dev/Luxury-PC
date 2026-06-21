package poly.edu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import poly.edu.entity.User;
import poly.edu.service.AuthService;

@Controller
@RequestMapping("/api")
public class AuthController {

    @Autowired
    AuthService authService;

    @Autowired
    private poly.edu.repository.UserRepository userRepo;

    @Autowired
    private PasswordEncoder encoder;

    @Autowired
    private org.springframework.security.web.context.SecurityContextRepository securityContextRepository;


    @PostMapping("/login-api")
    @ResponseBody
    public User loginApi(@RequestBody User user){
        return authService.login(user.getEmail(), user.getPassword());
    }

    @Autowired
    poly.edu.dao.RoleDAO roleDAO;

    @Autowired
    poly.edu.dao.UserRoleDAO userRoleDAO;

    @Autowired
    poly.edu.service.EmailService emailService;

    @PostMapping("/send-otp")
    @ResponseBody
    public String sendOtp(@RequestParam String email) {
        email = email.trim().toLowerCase();
        if(userRepo.findByEmail(email).isPresent()) return "error_exist";
        
        try {
            emailService.sendOtpEmail(email, email);
            return "success";
        } catch(Exception e) {
            e.printStackTrace();
            return "error_server";
        }
    }

    @PostMapping("/register")
    public String register(@RequestParam String firstName,
                           @RequestParam String lastName,
                           @RequestParam String email,
                           @RequestParam String otp,
                           @RequestParam(required = false) String phone,
                           @RequestParam(required = false) String inviteCode,
                           @RequestParam String password,
                           @RequestParam(required = false) String confirmPassword,
                           jakarta.servlet.http.HttpServletRequest request,
                           jakarta.servlet.http.HttpServletResponse response) {

        email = email.trim().toLowerCase();

        // Simple email regex for KH_DK_04
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            return "redirect:/auth/login?invalidEmail=true";
        }

        if(userRepo.findByEmail(email).isPresent()) {
            return "redirect:/auth/login?exist=true";
        }
        
        if(confirmPassword != null && !password.equals(confirmPassword)) {
            return "redirect:/auth/login?mismatch=true";
        }
        
        if(!emailService.verifyOtp(email, otp)) {
            return "redirect:/auth/login?invalidOtp=true";
        }
        
        if(phone != null && !phone.trim().isEmpty() && userRepo.findByPhone(phone.trim()).isPresent()) {
            return "redirect:/auth/login?phoneExist=true";
        }

        User user = new User();
        user.setFullName(firstName + " " + lastName);
        user.setEmail(email);
        user.setUsername(email); 
        user.setPassword(encoder.encode(password)); // Only hash once here
        user.setPhone(phone);

        User savedUser = userRepo.save(user);

        // --- ROLE ASSIGNMENT ---
        String roleName = "USER";

        poly.edu.entity.Role role = roleDAO.findByName(roleName);
        if (role != null) {
            poly.edu.entity.UserRole ur = new poly.edu.entity.UserRole();
            ur.setUser(savedUser);
            ur.setRole(role);
            userRoleDAO.save(ur);
        }

        // --- TASK 2: Tự động Đăng nhập sau khi Đăng ký ---
        try {
            // Tự tạo UserDetails để tránh lỗi LazyLoad
            java.util.List<org.springframework.security.core.authority.SimpleGrantedAuthority> authorities = 
                java.util.Collections.singletonList(new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_" + roleName));
            
            org.springframework.security.core.userdetails.User userDetails = 
                new org.springframework.security.core.userdetails.User(savedUser.getEmail(), savedUser.getPassword(), authorities);
                
            org.springframework.security.authentication.UsernamePasswordAuthenticationToken authToken = 
                new org.springframework.security.authentication.UsernamePasswordAuthenticationToken(userDetails, null, authorities);
            org.springframework.security.core.context.SecurityContextHolder.getContext().setAuthentication(authToken);
            
            // Lưu Context vào Session để Spring Security nhận diện sau khi redirect
            securityContextRepository.saveContext(org.springframework.security.core.context.SecurityContextHolder.getContext(), request, response);
            return "redirect:/";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/auth/login?success=true";
        }
    }

    @PostMapping("/forgot-password/send-otp")
    @ResponseBody
    public String sendForgotPasswordOtp(@RequestParam String email) {
        email = email.trim().toLowerCase();
        if(userRepo.findByEmail(email).isEmpty()) return "error_not_found";
        
        try {
            emailService.sendForgotPasswordOtpEmail(email, email);
            return "success";
        } catch(Exception e) {
            e.printStackTrace();
            return "error_server";
        }
    }

    @PostMapping("/forgot-password/reset")
    @ResponseBody
    public String resetPassword(@RequestParam String email,
                                @RequestParam String otp,
                                @RequestParam String newPassword) {
        email = email.trim().toLowerCase();
        
        if(!emailService.verifyForgotPasswordOtp(email, otp)) {
            return "error_otp";
        }
        
        User user = userRepo.findByEmail(email).orElse(null);
        if (user == null) {
            return "error_not_found";
        }
        
        user.setPassword(encoder.encode(newPassword));
        userRepo.save(user);
        
        return "success";
    }
}