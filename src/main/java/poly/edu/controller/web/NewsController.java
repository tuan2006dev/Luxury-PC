package poly.edu.controller.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import poly.edu.entity.News;
import poly.edu.service.NewsService;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/news")
public class NewsController {

    @Autowired
    private NewsService newsService;

    @GetMapping("")
    public String index(Model model) {
        List<News> newsList = newsService.getPublishedNews();
        model.addAttribute("newsList", newsList);
        return "news/index";
    }

    @GetMapping("/{slug}")
    public String detail(@PathVariable("slug") String slug, Model model) {
        Optional<News> news = newsService.getNewsBySlug(slug);
        if (news.isPresent() && news.get().getPublished()) {
            model.addAttribute("news", news.get());
            return "news/detail";
        }
        return "redirect:/news";
    }
}
