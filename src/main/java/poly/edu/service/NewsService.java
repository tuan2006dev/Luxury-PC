package poly.edu.service;

import poly.edu.entity.News;
import java.util.List;
import java.util.Optional;

public interface NewsService {
    List<News> getAllNews();
    List<News> getPublishedNews();
    Optional<News> getNewsById(Integer id);
    Optional<News> getNewsBySlug(String slug);
    News saveNews(News news);
    void deleteNews(Integer id);
}
