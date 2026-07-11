package poly.edu.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import poly.edu.entity.News;
import poly.edu.repository.NewsRepository;
import poly.edu.service.NewsService;

import java.util.List;
import java.util.Optional;

@Service
public class NewsServiceImpl implements NewsService {

    @Autowired
    private NewsRepository newsRepository;

    @Override
    public List<News> getAllNews() {
        return newsRepository.findAll(Sort.by(Sort.Direction.DESC, "createdAt"));
    }

    @Override
    public List<News> getPublishedNews() {
        return newsRepository.findByPublishedTrueOrderByCreatedAtDesc();
    }

    @Override
    public Optional<News> getNewsById(Integer id) {
        return newsRepository.findById(id);
    }

    @Override
    public Optional<News> getNewsBySlug(String slug) {
        return newsRepository.findBySlug(slug);
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
