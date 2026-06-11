package poly.edu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AuthPageController {

    @GetMapping("/auth/login")
    public String showAuthPage() {
        return "account/auth"; // file auth.html
    }

    @GetMapping("/auth/forgot-password")
    public String showForgotPasswordPage() {
        return "account/forgot-password";
    }
}