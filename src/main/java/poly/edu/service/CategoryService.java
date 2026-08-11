package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.CategoryDAO;
import poly.edu.entity.Category;
import poly.edu.dao.ProductDAO;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryService {
    final CategoryDAO categoryDAO;
    final ProductDAO productDAO;

    @Cacheable("allCategories")
    public List<Category> getAllCategories() {
        return categoryDAO.findAll();
    }

    public Category getCategoryById(Integer id) {
        return categoryDAO.findById(id).orElse(null);
    }

    @Transactional
    @CacheEvict(value = "allCategories", allEntries = true)
    public Category saveCategory(Category category) {
        return categoryDAO.save(category);
    }

    @Transactional
    @CacheEvict(value = "allCategories", allEntries = true)
    public void deleteCategory(Integer id) {
        productDAO.nullifyCategoryReferences(id);
        categoryDAO.deleteById(id);
    }
}
