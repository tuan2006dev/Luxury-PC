package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import poly.edu.entity.Product;
import poly.edu.entity.Review;
import poly.edu.entity.User;
import poly.edu.service.CategoryService;
import poly.edu.service.ProductService;
import poly.edu.dao.ReviewDAO;
import poly.edu.repository.UserRepository;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.util.List;
import java.util.Optional;

@Controller
public class ProductPageController {

    @Autowired
    ProductService productService;

    @Autowired
    CategoryService categoryService;

    @Autowired
    ReviewDAO reviewDAO;

    @Autowired
    UserRepository userRepository;

    @GetMapping("/products")
    public String showProductsPage(
            Model model,
            @RequestParam(name = "cid", required = false) Integer cid,
            @RequestParam(name = "min", required = false) Double min,
            @RequestParam(name = "max", required = false) Double max,
            @RequestParam(name = "kw", required = false) String kw) {
        
        model.addAttribute("allProducts", productService.searchProducts(cid, min, max, kw));
        model.addAttribute("categories", categoryService.getAllCategories());
        
        // Gửi lại các tham số lọc để giữ trạng thái trên UI
        model.addAttribute("selectedCid", cid);
        model.addAttribute("minPrice", min);
        model.addAttribute("maxPrice", max);
        model.addAttribute("keywords", kw);
        
        return "all-products"; 
    }

    @GetMapping("/product/{id}")
    public String showProductDetail(@PathVariable("id") Integer id, Model model) {
        Product p = productService.getProductById(id);
        if (p == null) {
            return "redirect:/products";
        }
        
        List<Review> reviews = reviewDAO.findByProductIdOrderByCreatedAtDesc(id);
        double avgRating = reviews.stream()
            .mapToInt(Review::getStars)
            .average()
            .orElse(0.0);

        model.addAttribute("product", p);
        model.addAttribute("reviews", reviews);
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("reviewCount", reviews.size());
        
        return "product-detail";
    }

    @PostMapping("/product/{id}/review")
    public String addReview(
            @PathVariable("id") Integer id,
            @RequestParam("stars") Integer stars,
            @RequestParam("content") String content,
            @AuthenticationPrincipal Object principal) {
        
        if (principal == null) {
            return "redirect:/auth/login";
        }

        String emailOrUsername = "";
        if (principal instanceof OAuth2User oauthUser) {
            emailOrUsername = (String) oauthUser.getAttributes().get("email");
        } else if (principal instanceof org.springframework.security.core.userdetails.User u) {
            emailOrUsername = u.getUsername();
        }

        Optional<User> uOpt = userRepository.findByEmail(emailOrUsername);
        if (uOpt.isEmpty()) uOpt = userRepository.findByUsername(emailOrUsername);

        if (uOpt.isPresent()) {
            Product p = productService.getProductById(id);
            if (p != null) {
                Review r = new Review();
                r.setUser(uOpt.get());
                r.setProduct(p);
                r.setStars(stars);
                r.setContent(content);
                reviewDAO.save(r);
            }
        }
        
        return "redirect:/product/" + id;
    }
}
