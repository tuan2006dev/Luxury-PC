package poly.edu.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import poly.edu.entity.News;
import poly.edu.repository.NewsRepository;
import poly.edu.service.NewsService;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class NewsServiceImpl implements NewsService {

    private final NewsRepository newsRepository;

    @Override
    public List<News> getAllNews() {
        return newsRepository.findAll(Sort.by(Sort.Direction.DESC, "createdAt"));
    }

    @Override
    public Page<poly.edu.dto.NewsSummaryDto> getPublishedNews(int page, int size, String keyword, Integer categoryId) {
        org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        if (keyword != null && !keyword.isEmpty()) {
            return newsRepository.searchPublishedNews(keyword, pageable);
        }
        if (categoryId != null) {
            return newsRepository.findByCategoryIdAndStatusOrderByCreatedAtDesc(categoryId, poly.edu.entity.NewsStatus.PUBLISHED, pageable);
        }
        return newsRepository.findByStatusOrderByCreatedAtDesc(poly.edu.entity.NewsStatus.PUBLISHED, pageable);
    }
    
    @Override
    public List<poly.edu.dto.NewsSummaryDto> getTop5LatestNews() {
        return newsRepository.findTop5ByStatusOrderByCreatedAtDesc(poly.edu.entity.NewsStatus.PUBLISHED);
    }
    
    @Override
    public List<poly.edu.dto.NewsSummaryDto> getTop5MostViewedNews() {
        return newsRepository.findTop5ByStatusOrderByViewCountDesc(poly.edu.entity.NewsStatus.PUBLISHED);
    }
    
    @Override
    public List<poly.edu.dto.NewsSummaryDto> getRelatedNews(Integer categoryId, Integer excludeNewsId) {
        if (categoryId == null) return java.util.Collections.emptyList();
        org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(0, 5); // Take top 5
        return newsRepository.findRelatedNews(categoryId, excludeNewsId, pageable);
    }

    @Override
    public Optional<News> getNewsById(Integer id) {
        return newsRepository.findById(id);
    }

    @Override
    public Optional<News> getNewsBySlug(String slug) {
        Optional<News> newsOpt = newsRepository.findBySlug(slug);
        if (newsOpt.isPresent()) {
            newsRepository.incrementViewCount(newsOpt.get().getId());
        }
        return newsOpt;
    }

    @Override
    public News saveNews(News news) {
        // Ensure slug is unique
        if (news.getSlug() == null || news.getSlug().isEmpty()) {
            news.setSlug(generateSlug(news.getTitle()));
        }
        
        Optional<News> existing = newsRepository.findBySlug(news.getSlug());
        if (existing.isPresent() && !existing.get().getId().equals(news.getId())) {
            news.setSlug(news.getSlug() + "-" + System.currentTimeMillis());
        }

        return newsRepository.save(news);
    }

    @Override
    public void deleteNews(Integer id) {
        newsRepository.deleteById(id);
    }

    private String generateSlug(String title) {
        if (title == null) return "";
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
        return slug;
    }
}
