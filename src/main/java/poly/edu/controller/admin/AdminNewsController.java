package poly.edu.controller.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import poly.edu.entity.News;
import poly.edu.entity.User;
import poly.edu.service.NewsService;
import poly.edu.service.UploadService;
import poly.edu.service.ProfileService;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/news")
public class AdminNewsController {

    @Autowired
    private NewsService newsService;

    @Autowired
    private UploadService uploadService;

    @Autowired
    private ProfileService profileService;

    @GetMapping("")
    public String index(Model model) {
        List<News> newsList = newsService.getAllNews();
        model.addAttribute("newsList", newsList);
        return "admin/news/index";
    }

    @GetMapping("/create")
    public String create(Model model) {
        model.addAttribute("news", new News());
        return "admin/news/form";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Integer id, Model model) {
        Optional<News> news = newsService.getNewsById(id);
        if (news.isPresent()) {
            model.addAttribute("news", news.get());
            return "admin/news/form";
        }
        return "redirect:/admin/news";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute("news") News news,
                       @RequestParam("thumbnailFile") MultipartFile thumbnailFile,
                       Authentication authentication) {
        
        try {
            if (news.getId() == null) {
                User currentUser = profileService.getCurrentUser(authentication);
                news.setAuthor(currentUser);
                news.setCreatedAt(new Date());
            } else {
                Optional<News> existingOpt = newsService.getNewsById(news.getId());
                if (existingOpt.isPresent()) {
                    News existing = existingOpt.get();
                    news.setAuthor(existing.getAuthor());
                    news.setCreatedAt(existing.getCreatedAt());
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
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/admin/news";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable("id") Integer id) {
        newsService.deleteNews(id);
        return "redirect:/admin/news";
    }
}
