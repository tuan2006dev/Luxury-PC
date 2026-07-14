package poly.edu.controller.auth;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequiredArgsConstructor
public class AuthPageController {

    private final poly.edu.repository.UserRepository userRepo;

    private final poly.edu.service.EmailService emailService;

    @GetMapping("/login")
    public String redirectToCustomLogin() {
        return "redirect:/auth/login";
    }

    @GetMapping("/auth/login")
    public String showAuthPage() {
        return "account/login"; // file login.html
    }

    @GetMapping("/auth/register")
    public String showRegisterPage() {
        return "account/register"; // file register.html
    }

    @GetMapping("/auth/forgot-password")
    public String showForgotPasswordPage() {
        return "account/forgot-password";
    }

    @GetMapping("/auth/login-2fa")
    public String showLogin2fa(HttpSession session, Model model) {
        String email = (String) session.getAttribute("twoFactorUserEmail");
        if (email == null) {
            return "redirect:/auth/login";
        }
        model.addAttribute("email", email);
        return "account/login-2fa";
    }

    @PostMapping("/auth/login-2fa/verify")
    public String verifyLogin2fa(
            @RequestParam("otp") String otp,
            HttpServletRequest request,
            HttpSession session) {
        String email = (String) session.getAttribute("twoFactorUserEmail");
        if (email == null) {
            return "redirect:/auth/login";
        }

        boolean isValid = emailService.verifyOtp(email, otp.trim());
        if (!isValid) {
            return "redirect:/auth/login-2fa?error=true";
        }

        // Authenticate programmatically
        java.util.Optional<poly.edu.entity.User> uOpt = userRepo.findByEmail(email);
        if (uOpt.isEmpty()) {
            return "redirect:/auth/login";
        }
        poly.edu.entity.User user = uOpt.get();

        java.util.List<String> roles = user.getUserRoles().stream()
                .map(ur -> ur.getRole().getName())
                .toList();
        if (roles.isEmpty()) roles = java.util.List.of("USER");

        java.util.List<org.springframework.security.core.authority.SimpleGrantedAuthority> authorities = 
            roles.stream().map(r -> new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_" + r)).toList();

        org.springframework.security.core.userdetails.User userDetails = 
            new org.springframework.security.core.userdetails.User(user.getEmail(), user.getPassword(), authorities);
            
        org.springframework.security.authentication.UsernamePasswordAuthenticationToken authToken = 
            new org.springframework.security.authentication.UsernamePasswordAuthenticationToken(userDetails, null, authorities);
            
        org.springframework.security.core.context.SecurityContextHolder.getContext().setAuthentication(authToken);
        session.setAttribute("SPRING_SECURITY_CONTEXT", org.springframework.security.core.context.SecurityContextHolder.getContext());

        session.removeAttribute("twoFactorUserEmail");

        return "redirect:/";
    }

    @PostMapping("/auth/login-2fa/resend")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.Map<String, Object> resendLogin2faOtp(HttpSession session) {
        java.util.Map<String, Object> response = new java.util.HashMap<>();
        String email = (String) session.getAttribute("twoFactorUserEmail");
        if (email == null) {
            response.put("success", false);
            response.put("message", "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.");
            return response;
        }

        try {
            // Send asynchronously to keep response fast
            java.util.concurrent.CompletableFuture.runAsync(() -> {
                try {
                    emailService.sendOtpEmail(email, email);
                } catch (Exception e) {
                    System.err.println("Error resending login 2FA OTP: " + e.getMessage());
                }
            });
            response.put("success", true);
            response.put("message", "Mã OTP mới đã được gửi thành công.");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Không thể gửi OTP: " + e.getMessage());
        }
        return response;
    }
}
