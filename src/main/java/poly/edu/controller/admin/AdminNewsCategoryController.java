package poly.edu.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.entity.NewsCategory;
import poly.edu.service.NewsCategoryService;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/news-categories")
@RequiredArgsConstructor
public class AdminNewsCategoryController {

    private final NewsCategoryService newsCategoryService;

    @GetMapping("")
    public String index(Model model) {
        List<NewsCategory> categories = newsCategoryService.getAllCategories();
        model.addAttribute("categories", categories);
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
    public String save(@ModelAttribute("category") NewsCategory category, RedirectAttributes redirectAttributes) {
        try {
            if (category.getId() != null) {
                Optional<NewsCategory> existing = newsCategoryService.getCategoryById(category.getId());
                if (existing.isPresent()) {
                    category.setCreatedAt(existing.get().getCreatedAt());
                }
            }
            newsCategoryService.saveCategory(category);
            redirectAttributes.addFlashAttribute("success", "Lưu danh mục thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        return "redirect:/admin/news-categories";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        try {
            Optional<NewsCategory> cat = newsCategoryService.getCategoryById(id);
            if(cat.isPresent()) {
                if(cat.get().getNewsList() != null && !cat.get().getNewsList().isEmpty()) {
                    redirectAttributes.addFlashAttribute("error", "Không thể xóa danh mục đang có bài viết!");
                    return "redirect:/admin/news-categories";
                }
                newsCategoryService.deleteCategory(id);
                redirectAttributes.addFlashAttribute("success", "Xóa danh mục thành công!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa danh mục này!");
        }
        return "redirect:/admin/news-categories";
    }
}
