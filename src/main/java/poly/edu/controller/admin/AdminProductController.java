package poly.edu.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.entity.AdminLog;
import poly.edu.entity.Product;
import poly.edu.entity.ProductImage;
import poly.edu.repository.AdminLogRepository;
import poly.edu.service.CategoryService;
import poly.edu.service.ProductService;
import poly.edu.service.UploadService;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/admin/products")
@RequiredArgsConstructor
public class AdminProductController {

    private static final Logger log = LoggerFactory.getLogger(AdminProductController.class);

    private final ProductService productService;
    private final CategoryService categoryService;
    private final UploadService uploadService;
    private final AdminLogRepository adminLogRepository;

    @GetMapping("")
    public String list(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "page", required = false, defaultValue = "1") Integer page,
            Model model) {
        java.util.List<Product> prods = productService.getAllProducts();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            prods = prods.stream()
                    .filter(p -> (p.getName() != null && p.getName().toLowerCase().contains(kw)) ||
                                 (p.getId() != null && String.valueOf(p.getId()).contains(kw)) ||
                                 (p.getCategory() != null && p.getCategory().getName() != null && p.getCategory().getName().toLowerCase().contains(kw)))
                    .collect(java.util.stream.Collectors.toList());
        }
        java.util.List<Product> paginatedProds = poly.edu.util.PaginationUtils.paginate(prods, page, model);
        model.addAttribute("products", paginatedProds);
        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("product", new Product());
        model.addAttribute("keyword", keyword);
        return "admin/products";
    }

    @PostMapping("/save")
    public String save(@jakarta.validation.Valid @ModelAttribute("product") Product product,
            org.springframework.validation.BindingResult result,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            @RequestParam(value = "uploadFiles", required = false) List<MultipartFile> uploadFiles,
            @RequestParam(value = "extraFile1", required = false) MultipartFile extraFile1,
            @RequestParam(value = "extraFile2", required = false) MultipartFile extraFile2,
            @RequestParam(value = "extraFile3", required = false) MultipartFile extraFile3,
            @RequestParam(value = "extraUrl1", required = false) String extraUrl1,
            @RequestParam(value = "extraUrl2", required = false) String extraUrl2,
            @RequestParam(value = "extraUrl3", required = false) String extraUrl3,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes,
            Model model) {

        if (result.hasErrors()) {
            java.util.List<Product> prods = productService.getAllProducts();
            model.addAttribute("products", poly.edu.util.PaginationUtils.paginate(prods, 1, model));
            model.addAttribute("categories", categoryService.getAllCategories());
            model.addAttribute("error", "Vui lòng kiểm tra lại các trường bắt buộc.");
            return "admin/products";
        }

        try {
            Product existing = null;
            if (product.getId() != null) {
                existing = productService.getProductById(product.getId());
            }

            boolean isAdmin = request.isUserInRole("ROLE_ADMIN");

            // 1. Thu thập tất cả các file tải lên
            List<MultipartFile> allFiles = new ArrayList<>();
            if (uploadFiles != null) {
                for (MultipartFile f : uploadFiles) {
                    if (f != null && !f.isEmpty()) {
                        allFiles.add(f);
                    }
                }
            }
            if (allFiles.isEmpty()) {
                if (imageFile != null && !imageFile.isEmpty()) allFiles.add(imageFile);
                if (extraFile1 != null && !extraFile1.isEmpty()) allFiles.add(extraFile1);
                if (extraFile2 != null && !extraFile2.isEmpty()) allFiles.add(extraFile2);
                if (extraFile3 != null && !extraFile3.isEmpty()) allFiles.add(extraFile3);
            }

            // 2. Xử lý ảnh chính (Main Image)
            if (!allFiles.isEmpty()) {
                String fileName = uploadService.save(allFiles.get(0), "products");
                product.setImage(fileName);
            } else if (product.getImage() != null && !product.getImage().trim().isEmpty()) {
                product.setImage(product.getImage().trim());
            } else if (existing != null) {
                product.setImage(existing.getImage());
            }

            if (existing != null) {
                product.setCreatedAt(existing.getCreatedAt());
                // An toàn tài chính: Nếu không phải ADMIN, không cho phép đổi Giá niêm yết sản phẩm
                if (!isAdmin) {
                    product.setPrice(existing.getPrice());
                }
            }

            boolean isNew = (product.getId() == null);
            if (isNew) {
                product.setCreatedAt(new Date());
                if (product.getStock() == null)
                    product.setStock(0);
            }

            // 3. Xử lý 3 ảnh phụ (Sub-images)
            List<ProductImage> newImages = new ArrayList<>();
            int order = 1;

            // Nếu có các file phụ từ file thứ 2 trở đi
            if (allFiles.size() > 1) {
                for (int i = 1; i < allFiles.size() && order <= 3; i++) {
                    String subFileName = uploadService.save(allFiles.get(i), "products");
                    ProductImage pImg = new ProductImage();
                    pImg.setProduct(product);
                    pImg.setImageUrl(subFileName);
                    pImg.setDisplayOrder(order++);
                    newImages.add(pImg);
                }
            }

            // Kiểm tra các URL ảnh phụ được nhập vào
            String[] extraUrls = { extraUrl1, extraUrl2, extraUrl3 };
            for (String url : extraUrls) {
                if (url != null && !url.trim().isEmpty() && order <= 3) {
                    ProductImage pImg = new ProductImage();
                    pImg.setProduct(product);
                    pImg.setImageUrl(url.trim());
                    pImg.setDisplayOrder(order++);
                    newImages.add(pImg);
                }
            }

            if (product.getProductImages() == null) {
                product.setProductImages(new ArrayList<>());
            } else {
                product.getProductImages().clear();
            }
            product.getProductImages().addAll(newImages);

            productService.saveProduct(product);
            logAction(principal, request, isNew ? "Thêm sản phẩm mới" : "Cập nhật sản phẩm", product.getName());

            String successMsg = isNew ? "Thêm sản phẩm mới '" + product.getName() + "' thành công!" : "Cập nhật sản phẩm '" + product.getName() + "' thành công!";
            redirectAttributes.addFlashAttribute("message", successMsg);
            redirectAttributes.addFlashAttribute("success", successMsg);
        } catch (Exception e) {
            log.error("[AdminProduct] Error saving product", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi khi lưu sản phẩm: " + e.getMessage());
        }

        return "redirect:/admin/products";
    }

    @GetMapping("/edit/{id}")
    public String edit(
            @PathVariable("id") Integer id,
            @RequestParam(name = "page", required = false, defaultValue = "1") Integer page,
            Model model) {
        Product p = productService.getProductById(id);
        model.addAttribute("product", p);
        java.util.List<Product> prods = productService.getAllProducts();
        model.addAttribute("products", poly.edu.util.PaginationUtils.paginate(prods, page, model));
        model.addAttribute("categories", categoryService.getAllCategories());
        return "admin/products";
    }

    @RequestMapping(value = "/delete/{id}", method = { RequestMethod.GET, RequestMethod.POST })
    public String delete(
            @PathVariable("id") Integer id,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {

        try {
            Product p = productService.getProductById(id);
            String pName = p != null ? p.getName() : "ProductID #" + id;

            productService.deleteProduct(id);
            logAction(principal, request, "Xóa sản phẩm", pName);

            redirectAttributes.addFlashAttribute("message", "Xóa sản phẩm thành công!");
        } catch (Exception e) {
            log.error("[AdminProduct] Error deleting product id={}", id, e);
            redirectAttributes.addFlashAttribute("error", "Lỗi khi xóa sản phẩm: " + e.getMessage());
        }
        return "redirect:/admin/products";
    }

    private void logAction(Principal principal, HttpServletRequest request, String action, String targetUser) {
        try {
            String username = principal != null ? principal.getName() : "STAFF";
            String ip = request.getHeader("X-Forwarded-For");
            if (ip == null || ip.isBlank() || "unknown".equalsIgnoreCase(ip)) {
                ip = request.getRemoteAddr();
            }
            adminLogRepository.save(new AdminLog(username, action, ip, targetUser));
        } catch (Exception e) {
            // Ignore logging errors
        }
    }
}
