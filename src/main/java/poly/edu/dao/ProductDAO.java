package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.Lock;
import jakarta.persistence.LockModeType;
import poly.edu.entity.Product;
import java.util.List;
import java.util.Optional;

public interface ProductDAO extends JpaRepository<Product, Integer> {
    
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT p FROM Product p WHERE p.id = :id")
    Optional<Product> findByIdForUpdate(@Param("id") Integer id);
    
    @Query("SELECT p FROM Product p JOIN FETCH p.category")
    @org.springframework.lang.NonNull
    List<Product> findAll();

    @Query("SELECT p FROM Product p JOIN FETCH p.category ORDER BY p.id DESC")
    List<Product> findTopProducts(org.springframework.data.domain.Pageable pageable);

    @Query("SELECT p FROM Product p JOIN FETCH p.category WHERE p.category.name = 'CPU' OR p.category.name = 'GPU'")
    List<Product> findFeaturedProducts();

    @Query("SELECT p FROM Product p JOIN FETCH p.category WHERE p.stock < 10")
    List<Product> findFlashSaleProducts();

    List<Product> findByCategoryId(Integer categoryId);

    // Bạn đã xóa dấu } ở đây để gộp các hàm dưới vào trong Interface
    List<Product> findByCategoryIdAndImageIsNotNull(Integer categoryId);

    @Query("SELECT p FROM Product p WHERE " +
           "(:cid IS NULL OR p.category.id = :cid) AND " +
           "(:min IS NULL OR p.price >= :min) AND " +
           "(:max IS NULL OR p.price <= :max) AND " +
           "(:kw IS NULL OR p.name LIKE %:kw% OR p.description LIKE %:kw%) AND " +
           "(:brand IS NULL OR p.brand = :brand OR LOWER(p.name) LIKE LOWER(CONCAT('%', :brand, '%'))) AND " +
           "p.image IS NOT NULL")
    List<Product> searchProducts(
        @Param("cid") Integer cid, 
        @Param("min") Double min, 
        @Param("max") Double max, 
        @Param("kw") String kw,
        @Param("brand") String brand,
        org.springframework.data.domain.Pageable pageable
    );
} // Chỉ có duy nhất một dấu đóng ngoặc ở cuối cùng này
