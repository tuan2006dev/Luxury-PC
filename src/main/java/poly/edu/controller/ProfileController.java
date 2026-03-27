package poly.edu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ProfileController {

    @GetMapping("/profile")
    public String profilePage() {
        // Trả về file HTML nằm tại src/main/resources/templates/account/profile.html
        return "account/profile";
    }
}
