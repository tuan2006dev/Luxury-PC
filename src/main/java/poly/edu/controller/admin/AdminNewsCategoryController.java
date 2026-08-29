package poly.edu.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.entity.AdminLog;
import poly.edu.entity.NewsCategory;
import poly.edu.repository.AdminLogRepository;
import poly.edu.service.NewsCategoryService;

import java.security.Principal;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/news-categories")
@RequiredArgsConstructor
public class AdminNewsCategoryController {

    private final NewsCategoryService newsCategoryService;
    private final AdminLogRepository adminLogRepository;

    @GetMapping("")
    public String index(
            Model model,
            @RequestParam(name = "keyword", defaultValue = "") String keyword,
            @RequestParam(name = "page", required = false, defaultValue = "1") Integer page) {
        List<NewsCategory> categories = newsCategoryService.getAllCategories();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            categories = categories.stream()
                    .filter(c -> (c.getName() != null && c.getName().toLowerCase().contains(kw)) ||
                            (c.getSlug() != null && c.getSlug().toLowerCase().contains(kw)) ||
                            (c.getId() != null && String.valueOf(c.getId()).contains(kw)))
                    .collect(java.util.stream.Collectors.toList());
        }
        List<NewsCategory> paginatedCategories = poly.edu.util.PaginationUtils.paginate(categories, page, model);
        model.addAttribute("categories", paginatedCategories);
        model.addAttribute("keyword", keyword);
        return "admin/newscategory/index";
    }

    @GetMapping("/create")
    public String create(Model model) {
        model.addAttribute("category", new NewsCategory());
        return "admin/newscategory/form";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Integer id, Model model, RedirectAttributes redirectAttributes) {
        Optional<NewsCategory> category = newsCategoryService.getCategoryById(id);
        if (category.isPresent()) {
            model.addAttribute("category", category.get());
            return "admin/newscategory/form";
        }
        redirectAttributes.addFlashAttribute("error", "Không tìm thấy danh mục!");
        return "redirect:/admin/news-categories";
    }

    @PostMapping("/save")
    public String save(
            @ModelAttribute("category") NewsCategory category,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {

        try {
            boolean isNew = (category.getId() == null);
            if (!isNew) {
                Optional<NewsCategory> existing = newsCategoryService.getCategoryById(category.getId());
                if (existing.isPresent()) {
                    category.setCreatedAt(existing.get().getCreatedAt());
                }
            }
            newsCategoryService.saveCategory(category);
            logAction(principal, request, isNew ? "Tạo danh mục tin tức" : "Cập nhật danh mục tin tức",
                    category.getName());

            redirectAttributes.addFlashAttribute("success", "Lưu danh mục thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        return "redirect:/admin/news-categories";
    }

    @PostMapping("/delete/{id}")
    public String delete(
            @PathVariable("id") Integer id,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {

        try {
            Optional<NewsCategory> cat = newsCategoryService.getCategoryById(id);
            if (cat.isPresent()) {
                if (cat.get().getNewsList() != null && !cat.get().getNewsList().isEmpty()) {
                    redirectAttributes.addFlashAttribute("error", "Không thể xóa danh mục đang có bài viết!");
                    return "redirect:/admin/news-categories";
                }
                String name = cat.get().getName();
                newsCategoryService.deleteCategory(id);
                logAction(principal, request, "Xóa danh mục tin tức", name);

                redirectAttributes.addFlashAttribute("success", "Xóa danh mục thành công!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa danh mục này!");
        }
        return "redirect:/admin/news-categories";
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
