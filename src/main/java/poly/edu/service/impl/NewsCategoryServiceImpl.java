package poly.edu.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import poly.edu.entity.NewsCategory;
import poly.edu.repository.NewsCategoryRepository;
import poly.edu.service.NewsCategoryService;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class NewsCategoryServiceImpl implements NewsCategoryService {

    private final NewsCategoryRepository categoryRepository;

    @Override
    public List<NewsCategory> getAllCategories() {
        return categoryRepository.findAll();
    }

    @Override
    public List<NewsCategory> getActiveCategories() {
        return categoryRepository.findByStatus("ACTIVE");
    }

    @Override
    public Optional<NewsCategory> getCategoryById(Integer id) {
        return categoryRepository.findById(id);
    }

    @Override
    public NewsCategory saveCategory(NewsCategory category) {
        if (category.getSlug() == null || category.getSlug().isEmpty()) {
            category.setSlug(generateSlug(category.getName()));
        }
        NewsCategory existing = categoryRepository.findBySlug(category.getSlug());
        if (existing != null && !existing.getId().equals(category.getId())) {
            category.setSlug(category.getSlug() + "-" + System.currentTimeMillis());
        }
        return categoryRepository.save(category);
    }

    @Override
    public void deleteCategory(Integer id) {
        categoryRepository.deleteById(id);
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
