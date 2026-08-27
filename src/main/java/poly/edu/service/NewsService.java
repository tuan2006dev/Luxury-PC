package poly.edu.service;

import org.springframework.data.domain.Page;
import poly.edu.entity.News;
import java.util.List;
import java.util.Optional;
import poly.edu.dto.NewsSummaryDto;

public interface NewsService {
    List<News> getAllNews();
    Page<NewsSummaryDto> getPublishedNews(int page, int size, String keyword, Integer categoryId);
    List<NewsSummaryDto> getTop5LatestNews();
    List<NewsSummaryDto> getTop5MostViewedNews();
    List<NewsSummaryDto> getRelatedNews(Integer categoryId, Integer excludeNewsId);
    
    Optional<News> getNewsById(Integer id);
    Optional<News> getNewsBySlug(String slug);
    News saveNews(News news);
    void deleteNews(Integer id);
}
