package poly.edu.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.entity.AdminLog;
import poly.edu.entity.Category;
import poly.edu.repository.AdminLogRepository;
import poly.edu.service.CategoryService;

import java.security.Principal;

@Controller
@RequestMapping("/admin/categories")
@RequiredArgsConstructor
public class AdminCategoryController {

    private final CategoryService categoryService;
    private final AdminLogRepository adminLogRepository;

    @GetMapping("")
    public String list(@RequestParam(name = "keyword", required = false) String keyword, Model model) {
        java.util.List<Category> categories = categoryService.getAllCategories();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            categories = categories.stream()
                    .filter(c -> (c.getName() != null && c.getName().toLowerCase().contains(kw)) ||
                                 (c.getId() != null && String.valueOf(c.getId()).contains(kw)))
                    .collect(java.util.stream.Collectors.toList());
        }
        model.addAttribute("categories", categories);
        model.addAttribute("category", new Category());
        model.addAttribute("keyword", keyword);
        return "admin/categories";
    }

    @PostMapping("/save")
    public String save(
            @ModelAttribute("category") Category category,
            Principal principal,
            HttpServletRequest request) {

        boolean isNew = (category.getId() == null);
        categoryService.saveCategory(category);
        logAction(principal, request, isNew ? "Thêm danh mục mới" : "Cập nhật danh mục", category.getName());

        return "redirect:/admin/categories";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Integer id, Model model) {
        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("category", categoryService.getCategoryById(id));
        return "admin/categories";
    }

    @RequestMapping(value = "/delete/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    public String delete(
            @PathVariable("id") Integer id,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {

        try {
            Category cat = categoryService.getCategoryById(id);
            String catName = cat != null ? cat.getName() : "CategoryID #" + id;

            categoryService.deleteCategory(id);
            logAction(principal, request, "Xóa danh mục", catName);

            redirectAttributes.addFlashAttribute("message", "Xóa danh mục thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi khi xóa danh mục: " + e.getMessage());
        }
        return "redirect:/admin/categories";
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
