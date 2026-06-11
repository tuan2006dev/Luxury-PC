package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import poly.edu.entity.Product;
import poly.edu.service.CategoryService;
import poly.edu.service.ProductService;
import poly.edu.service.UploadService;

import java.util.Date;

@Controller
@RequestMapping("/admin/products")
public class AdminProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private UploadService uploadService;

    @GetMapping("")
    public String list(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("product", new Product());
        return "admin/products";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute("product") Product product,
                       @RequestParam("imageFile") MultipartFile imageFile) {
        
        if (!imageFile.isEmpty()) {
            String fileName = uploadService.save(imageFile, "products");
            product.setImage(fileName);
        } else if (product.getId() != null) {
            // Nếu không chọn ảnh mới khi sửa, giữ nguyên ảnh cũ
            Product existing = productService.getProductById(product.getId());
            if (existing != null) {
                product.setImage(existing.getImage());
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

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Integer id) {
        productService.deleteProduct(id);
        return "redirect:/admin/products";
    }
}
