package poly.edu.service;

import poly.edu.entity.NewsCategory;
import java.util.List;
import java.util.Optional;

public interface NewsCategoryService {
    List<NewsCategory> getAllCategories();
    List<NewsCategory> getActiveCategories();
    Optional<NewsCategory> getCategoryById(Integer id);
    NewsCategory saveCategory(NewsCategory category);
    void deleteCategory(Integer id);
}
