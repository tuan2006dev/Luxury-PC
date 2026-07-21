package poly.edu.controller.admin;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.entity.News;
import poly.edu.entity.NewsCategory;
import poly.edu.entity.User;
import poly.edu.repository.NewsRepository;
import poly.edu.service.NewsCategoryService;
import poly.edu.service.NewsService;
import poly.edu.service.UploadService;
import poly.edu.service.ProfileService;

import jakarta.validation.Valid;
import org.springframework.validation.BindingResult;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/admin/news")
@RequiredArgsConstructor
public class AdminNewsController {

    private static final Logger log = LoggerFactory.getLogger(AdminNewsController.class);

    private final NewsService newsService;
    
    private final NewsRepository newsRepository; // Needed for direct pagination/search for now

    private final NewsCategoryService newsCategoryService;

    private final UploadService uploadService;

    private final ProfileService profileService;

    private final poly.edu.repository.UserRepository userRepository;

    @GetMapping("")
    public String index(Model model, 
                        @RequestParam(name = "keyword", defaultValue = "") String keyword,
                        @RequestParam(name = "page", defaultValue = "0") int page) {
        
        Pageable pageable = PageRequest.of(page, 10, Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<poly.edu.dto.NewsSummaryDto> newsPage;
        if (keyword.isEmpty()) {
            newsPage = newsRepository.findAllSummary(pageable);
        } else {
            newsPage = newsRepository.searchAllNewsSummary(keyword, pageable);
        }
        
        model.addAttribute("newsPage", newsPage);
        model.addAttribute("keyword", keyword);
        return "admin/news/index";
    }

    @GetMapping("/create")
    public String create(Model model) {
        model.addAttribute("news", new News());
        List<NewsCategory> categories = newsCategoryService.getActiveCategories();
        model.addAttribute("categories", categories);
        return "admin/news/form";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Integer id, Model model) {
        Optional<News> news = newsService.getNewsById(id);
        if (news.isPresent()) {
            model.addAttribute("news", news.get());
            List<NewsCategory> categories = newsCategoryService.getActiveCategories();
            model.addAttribute("categories", categories);
            return "admin/news/form";
        }
        return "redirect:/admin/news";
    }

    @PostMapping("/save")
    public String save(@Valid @ModelAttribute("news") News news, BindingResult bindingResult,
                       @RequestParam("thumbnailFile") MultipartFile thumbnailFile,
                       Authentication authentication,
                       RedirectAttributes redirectAttributes,
                       Model model) {
        
        // Auto-generate slug if left blank
        if (news.getSlug() == null || news.getSlug().trim().isEmpty()) {
            news.setSlug(generateSlug(news.getTitle()));
        }

        // Auto-generate summary if left blank
        if (news.getSummary() == null || news.getSummary().trim().isEmpty()) {
            if (news.getContent() != null && !news.getContent().trim().isEmpty()) {
                String plainText = news.getContent().replaceAll("<[^>]*>", "").trim();
                news.setSummary(plainText.length() > 200 ? plainText.substring(0, 200) + "..." : plainText);
            } else {
                news.setSummary(news.getTitle());
            }
        }

        // Handle category null id
        if (news.getCategory() != null && news.getCategory().getId() == null) {
            news.setCategory(null);
        }

        if (bindingResult.hasErrors()) {
            List<NewsCategory> categories = newsCategoryService.getActiveCategories();
            model.addAttribute("categories", categories);
            return "admin/news/form";
        }

        try {
            if (news.getId() == null) {
                User currentUser = null;
                try {
                    currentUser = profileService.getCurrentUser(authentication);
                } catch (Exception ex) {
                    log.warn("[AdminNews] Could not resolve current user from authentication: {}", ex.getMessage());
                }
                if (currentUser == null) {
                    currentUser = userRepository.findAll().stream().findFirst().orElse(null);
                }
                news.setAuthor(currentUser);
                news.setCreatedAt(new Date());
            } else {
                Optional<News> existingOpt = newsService.getNewsById(news.getId());
                if (existingOpt.isPresent()) {
                    News existing = existingOpt.get();
                    news.setAuthor(existing.getAuthor());
                    news.setCreatedAt(existing.getCreatedAt());
                    news.setViewCount(existing.getViewCount()); // preserve view count
                    if (news.getThumbnail() == null || news.getThumbnail().isEmpty()) {
                        news.setThumbnail(existing.getThumbnail());
                    }
                }
            }

            if (thumbnailFile != null && !thumbnailFile.isEmpty()) {
                String fileName = uploadService.save(thumbnailFile, "news");
                news.setThumbnail(fileName);
            }

            news.setUpdatedAt(new Date());
            newsService.saveNews(news);
            redirectAttributes.addFlashAttribute("success", "Lưu bài viết thành công!");
        } catch (Exception e) {
            log.error("[AdminNews] Failed to save news article", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi lưu bài viết: " + e.getMessage());
        }

        return "redirect:/admin/news";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        try {
            newsService.deleteNews(id);
            redirectAttributes.addFlashAttribute("success", "Xóa bài viết thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi xóa bài viết!");
        }
        return "redirect:/admin/news";
    }

    private String generateSlug(String title) {
        if (title == null || title.trim().isEmpty()) return "bai-viet-" + System.currentTimeMillis();
        String slug = title.toLowerCase().trim();
        slug = slug.replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a");
        slug = slug.replaceAll("[èéẹẻẽêềếệểễ]", "e");
        slug = slug.replaceAll("[ìíịỉĩ]", "i");
        slug = slug.replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o");
        slug = slug.replaceAll("[ùúụủũưừứựửữ]", "u");
        slug = slug.replaceAll("[ỳýỵỷỹ]", "y");
        slug = slug.replaceAll("đ", "d");
        slug = slug.replaceAll("[^a-z0-9\\s-]", "");
        slug = slug.replaceAll("[\\s-]+", "-");
        if (slug.isEmpty()) slug = "bai-viet-" + System.currentTimeMillis();
        return slug;
    }
}    
    // Endpoint for TinyMCE Image Upload
    @PostMapping("/upload-image")
    @ResponseBody
    public ResponseEntity<Map<String, String>> uploadImage(@RequestParam("file") MultipartFile file) {
        try {
            String fileName = uploadService.save(file, "news_content");
            Map<String, String> response = new HashMap<>();
            response.put("location", "/images/news_content/" + fileName);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
}
