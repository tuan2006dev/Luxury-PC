package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import poly.edu.service.ProductService;
import poly.edu.service.WishlistService;

@Controller
public class HomeController {

    @Autowired
    ProductService productService;

    @Autowired
    poly.edu.service.ReviewService reviewService;

    @Autowired
    WishlistService wishlistService;

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("featuredProducts", productService.getFeaturedProducts());
        model.addAttribute("flashSaleProducts", productService.getFlashSaleProducts());
        model.addAttribute("allProducts", productService.getAllProducts());
        model.addAttribute("reviews", reviewService.getLatestReviews());

        Authentication auth =
                SecurityContextHolder
                        .getContext()
                        .getAuthentication();

        System.out.println("USERNAME: "
                + auth.getName());

        System.out.println("ROLES: "
                + auth.getAuthorities());

        model.addAttribute("wishlistProductIds", wishlistService.getWishlistProductIds(auth));
        return "index";
    }
}


