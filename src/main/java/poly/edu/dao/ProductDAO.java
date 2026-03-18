package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import poly.edu.entity.Product;
import java.util.List;

public interface ProductDAO extends JpaRepository<Product, Integer> {
    
    @Query("SELECT p FROM Product p WHERE p.category.name = 'CPU' OR p.category.name = 'GPU'")
    List<Product> findFeaturedProducts();

    @Query("SELECT p FROM Product p WHERE p.stock < 10")
    List<Product> findFlashSaleProducts();

    List<Product> findByCategoryId(Integer categoryId);
}
