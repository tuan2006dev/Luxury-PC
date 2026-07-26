package poly.edu.service;

import org.springframework.data.domain.Page;
import poly.edu.entity.News;
import java.util.List;
import java.util.Optional;

public interface NewsService {
    List<News> getAllNews();
    Page<poly.edu.dto.NewsSummaryDto> getPublishedNews(int page, int size, String keyword, Integer categoryId);
    List<poly.edu.dto.NewsSummaryDto> getTop5LatestNews();
    List<poly.edu.dto.NewsSummaryDto> getTop5MostViewedNews();
    List<poly.edu.dto.NewsSummaryDto> getRelatedNews(Integer categoryId, Integer excludeNewsId);
    
    Optional<News> getNewsById(Integer id);
    Optional<News> getNewsBySlug(String slug);
    News saveNews(News news);
    void deleteNews(Integer id);
}
