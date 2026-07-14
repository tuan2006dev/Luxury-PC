package poly.edu.controller.web;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import poly.edu.entity.News;
import poly.edu.entity.NewsCategory;
import poly.edu.entity.NewsStatus;
import poly.edu.service.NewsCategoryService;
import poly.edu.service.NewsService;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/news")
@RequiredArgsConstructor
public class NewsController {

    private final NewsService newsService;

    private final NewsCategoryService newsCategoryService;

    @GetMapping("")
    public String index(Model model,
                        @RequestParam(name = "page", defaultValue = "0") int page,
                        @RequestParam(name = "keyword", required = false) String keyword,
                        @RequestParam(name = "category", required = false) Integer categoryId) {
        
        int size = 9; // 9 bài một trang
        Page<poly.edu.dto.NewsSummaryDto> newsPage = newsService.getPublishedNews(page, size, keyword, categoryId);
        
        List<NewsCategory> categories = newsCategoryService.getActiveCategories();
        List<poly.edu.dto.NewsSummaryDto> topViewed = newsService.getTop5MostViewedNews();

        model.addAttribute("newsPage", newsPage);
        model.addAttribute("categories", categories);
        model.addAttribute("topViewed", topViewed);
        model.addAttribute("keyword", keyword);
        model.addAttribute("currentCategoryId", categoryId);
        
        return "news/index";
    }

    @GetMapping("/{slug}")
    public String detail(@PathVariable("slug") String slug, Model model) {
        Optional<News> newsOpt = newsService.getNewsBySlug(slug);
        
        if (newsOpt.isPresent() && newsOpt.get().getStatus() == NewsStatus.PUBLISHED) {
            News news = newsOpt.get();
            model.addAttribute("news", news);
            
            // Lấy danh mục đang active để hiển thị sidebar
            List<NewsCategory> categories = newsCategoryService.getActiveCategories();
            model.addAttribute("categories", categories);
            
            // Bài viết xem nhiều
            List<poly.edu.dto.NewsSummaryDto> topViewed = newsService.getTop5MostViewedNews();
            model.addAttribute("topViewed", topViewed);
            
            // Bài viết liên quan
            Integer catId = news.getCategory() != null ? news.getCategory().getId() : null;
            List<poly.edu.dto.NewsSummaryDto> related = newsService.getRelatedNews(catId, news.getId());
            model.addAttribute("relatedNews", related);
            
            return "news/detail";
        }
        return "redirect:/news";
    }
}
