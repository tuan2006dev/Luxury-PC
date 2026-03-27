package poly.edu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CheckoutController {

    @GetMapping("/checkout")
    public String checkoutPage() {
        // Trả về file HTML nằm tại
        // src/main/resources/templates/actions/check-out/checkout.html
        return "actions/check-out/checkout";
    }
}
