package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import poly.edu.entity.User;
import poly.edu.service.AuthService;

@RestController
@RequestMapping("/api")
public class AuthController {

    @Autowired
    AuthService authService;

<<<<<<< Updated upstream
    @PostMapping("/login")
    public User login(@RequestBody User user){
        return authService.login(user.getEmail(), user.getPassword());
    }

    @PostMapping("/register")
    public User register(@RequestBody User user){
        return authService.register(user);
    }

=======
    @Autowired
    BCryptPasswordEncoder encoder;
    
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
        email = email.trim().toLowerCase();
        if(userRepo.findByEmail(email).isPresent()) return "error_exist";
        
        try {
            String toEmail = email.contains("|") ? email.substring(0, email.indexOf("|")) : email;
            emailService.sendOtpEmail(email, toEmail);
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
                           @RequestParam String password) {

        email = email.trim().toLowerCase();

        String hashedPassword = encoder.encode(password);
        
        if(!email.endsWith("@gmail.com")) {
            return "redirect:/auth/login?invalidEmail=true";
        }
        
        if(userRepo.findByEmail(email).isPresent()) {
            return "redirect:/auth/login?exist=true";
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

        // --- ROLE DETECTION & ASSIGNMENT ---
        String roleName = "USER";
        if (email.contains("|staff")) {
            roleName = "STAFF";
        } else if (email.contains("|admin")) {
            roleName = "ADMIN";
        }

        poly.edu.entity.Role role = roleDAO.findByName(roleName);
        if (role != null) {
            poly.edu.entity.UserRole ur = new poly.edu.entity.UserRole();
            ur.setUser(savedUser);
            ur.setRole(role);
            userRoleDAO.save(ur);
        }

        return "redirect:/auth/login?success=true";
    }

    @PostMapping("/forgot-password/send-otp")
    @ResponseBody
    public String sendForgotPasswordOtp(@RequestParam String email) {
        email = email.trim().toLowerCase();
        if(userRepo.findByEmail(email).isEmpty()) return "error_not_found";
        
        try {
            String toEmail = email.contains("|") ? email.substring(0, email.indexOf("|")) : email;
            emailService.sendForgotPasswordOtpEmail(email, toEmail);
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
>>>>>>> Stashed changes
}