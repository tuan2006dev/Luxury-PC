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

<<<<<<< Updated upstream
    List<Product> findByCategoryId(Integer categoryId);
}
=======
    // Đổi tên hàm theo quy tắc của Spring Data JPA để tự động lọc bỏ các sản phẩm không có ảnh
    List<Product> findByCategoryIdAndImageIsNotNull(Integer categoryId);

    @Query("SELECT p FROM Product p WHERE " +
           "(:cid IS NULL OR p.category.id = :cid) AND " +
           "(:min IS NULL OR p.price >= :min) AND " +
           "(:max IS NULL OR p.price <= :max) AND " +
           "(:kw IS NULL OR p.name LIKE %:kw% OR p.description LIKE %:kw%) AND " +
           "p.image IS NOT NULL")
    List<Product> searchProducts(Integer cid, Double min, Double max, String kw);
}
>>>>>>> Stashed changes
