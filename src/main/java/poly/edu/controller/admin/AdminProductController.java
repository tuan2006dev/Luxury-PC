package poly.edu.controller.admin;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.entity.Product;
import poly.edu.service.CategoryService;
import poly.edu.service.ProductService;
import poly.edu.service.UploadService;

import java.util.Date;

@Controller
@RequestMapping("/admin/products")
@RequiredArgsConstructor
public class AdminProductController {

    private static final Logger log = LoggerFactory.getLogger(AdminProductController.class);

    private final ProductService productService;

    private final CategoryService categoryService;

    private final UploadService uploadService;

    @GetMapping("")
    public String list(Model model) {
        java.util.List<Product> prods = productService.getAllProducts();
        for(Product p : prods) {
            log.debug("[AdminProduct] id={}, image={}", p.getId(), p.getImage());
        }
        model.addAttribute("products", prods);
        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("product", new Product());
        return "admin/products";
    }

    @PostMapping("/save")
    public String save(@jakarta.validation.Valid @ModelAttribute("product") Product product,
                       org.springframework.validation.BindingResult result,
                       @RequestParam("imageFile") MultipartFile imageFile,
                       Model model) {
        
        if (result.hasErrors()) {
            model.addAttribute("products", productService.getAllProducts());
            model.addAttribute("categories", categoryService.getAllCategories());
            model.addAttribute("error", "Vui lòng kiểm tra lại các trường bắt buộc.");
            return "admin/products";
        }

        if (!imageFile.isEmpty()) {
            String fileName = uploadService.save(imageFile, "products");
            product.setImage(fileName);
        } else if (product.getId() != null) {
            // Nếu không upload ảnh mới, kiểm tra xem có nhập URL không
            Product existing = productService.getProductById(product.getId());
            if (existing != null) {
                if (product.getImage() == null || product.getImage().trim().isEmpty()) {
                    product.setImage(existing.getImage());
                }
                product.setCreatedAt(existing.getCreatedAt());
            }
        }

        if (product.getId() == null) {
            product.setCreatedAt(new Date());
            if (product.getStock() == null) product.setStock(0);
        }

        productService.saveProduct(product);
        return "redirect:/admin/products";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Integer id, Model model) {
        Product p = productService.getProductById(id);
        model.addAttribute("product", p);
        model.addAttribute("products", productService.getAllProducts());
        model.addAttribute("categories", categoryService.getAllCategories());
        return "admin/products";
    }

    @RequestMapping(value = "/delete/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    public String delete(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        try {
            productService.deleteProduct(id);
            redirectAttributes.addFlashAttribute("message", "Xóa sản phẩm thành công!");
        } catch (Exception e) {
            log.error("[AdminProduct] Error deleting product id={}", id, e);
            redirectAttributes.addFlashAttribute("error", "Lỗi khi xóa sản phẩm: " + e.getMessage());
        }
        return "redirect:/admin/products";
    }
}
