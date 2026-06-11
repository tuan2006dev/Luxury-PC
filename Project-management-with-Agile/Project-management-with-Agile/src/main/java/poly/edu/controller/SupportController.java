package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.service.EmailService;

@Controller
public class SupportController {

    @Autowired
    private EmailService emailService;

    @GetMapping("/support")
    public String showSupportPage() {
        return "support";
    }

    @PostMapping("/support/contact")
    public String handleContactSubmit(
            @RequestParam("name") String name,
            @RequestParam("email") String email,
            @RequestParam("message") String message,
            RedirectAttributes redirectAttributes) {

        try {
            emailService.sendContactEmail(name, email, message);
            redirectAttributes.addFlashAttribute("successMessage", "Yêu cầu của bạn đã được gửi thành công. Chúng tôi sẽ phản hồi lại sớm nhất có thể!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể gửi yêu cầu hỗ trợ. Vui lòng thử lại sau!");
        }

        return "redirect:/support";
    }
}
