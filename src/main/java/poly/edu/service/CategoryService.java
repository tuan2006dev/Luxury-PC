package poly.edu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.CategoryDAO;
import poly.edu.entity.Category;
import java.util.List;

@Service
public class CategoryService {
    @Autowired
    CategoryDAO categoryDAO;

    public List<Category> getAllCategories() {
        return categoryDAO.findAll();
    }

    public Category getCategoryById(Integer id) {
        return categoryDAO.findById(id).orElse(null);
    }

    @Transactional
    public Category saveCategory(Category category) {
        return categoryDAO.save(category);
    }

    @Transactional
    public void deleteCategory(Integer id) {
        categoryDAO.deleteById(id);
    }
}
