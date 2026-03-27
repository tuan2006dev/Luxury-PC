package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import poly.edu.entity.Product;
import poly.edu.service.CategoryService;
import poly.edu.service.ProductService;

@Controller
public class ProductPageController {

    @Autowired
    ProductService productService;

    @Autowired
    CategoryService categoryService;

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
        model.addAttribute("product", p);
        return "product-detail";
    }
}
