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

    @Query("SELECT p FROM Product p JOIN FETCH p.category ORDER BY p.createdAt DESC, p.id DESC")
    List<Product> findTopProducts(org.springframework.data.domain.Pageable pageable);

    @Query("SELECT p FROM Product p JOIN FETCH p.category ORDER BY (SELECT COALESCE(AVG(r.stars), 0.0) FROM Review r WHERE r.product = p) DESC, p.id DESC")
    List<Product> findFeaturedProducts(org.springframework.data.domain.Pageable pageable);

    @Query("SELECT p FROM Product p JOIN FETCH p.category WHERE p.stock < 10")
    List<Product> findFlashSaleProducts();

    List<Product> findByCategoryId(Integer categoryId);

    // Bạn đã xóa dấu } ở đây để gộp các hàm dưới vào trong Interface
    List<Product> findByCategoryIdAndImageIsNotNull(Integer categoryId);

    @Query(value = "SELECT p FROM Product p WHERE " +
            "(:cid IS NULL OR p.category.id = :cid) AND " +
            "(:min IS NULL OR p.price >= :min) AND " +
            "(:max IS NULL OR p.price <= :max) AND " +
            "(:kw IS NULL OR p.name LIKE %:kw% OR p.description LIKE %:kw%) AND " +
            "(:brand IS NULL OR p.brand = :brand OR LOWER(p.name) LIKE LOWER(CONCAT('%', :brand, '%'))) AND " +
            "p.image IS NOT NULL",
            countQuery = "SELECT COUNT(p) FROM Product p WHERE " +
            "(:cid IS NULL OR p.category.id = :cid) AND " +
            "(:min IS NULL OR p.price >= :min) AND " +
            "(:max IS NULL OR p.price <= :max) AND " +
            "(:kw IS NULL OR p.name LIKE %:kw% OR p.description LIKE %:kw%) AND " +
            "(:brand IS NULL OR p.brand = :brand OR LOWER(p.name) LIKE LOWER(CONCAT('%', :brand, '%'))) AND " +
            "p.image IS NOT NULL")
    org.springframework.data.domain.Page<Product> searchProducts(
            @Param("cid") Integer cid,
            @Param("min") Double min,
            @Param("max") Double max,
            @Param("kw") String kw,
            @Param("brand") String brand,
            org.springframework.data.domain.Pageable pageable);

    @Query(value = "SELECT p FROM Product p WHERE p.id IN :flashSaleIds AND " +
            "(:cid IS NULL OR p.category.id = :cid) AND " +
            "(:min IS NULL OR p.price >= :min) AND " +
            "(:max IS NULL OR p.price <= :max) AND " +
            "(:kw IS NULL OR p.name LIKE %:kw% OR p.description LIKE %:kw%) AND " +
            "(:brand IS NULL OR p.brand = :brand OR LOWER(p.name) LIKE LOWER(CONCAT('%', :brand, '%'))) AND " +
            "p.image IS NOT NULL",
            countQuery = "SELECT COUNT(p) FROM Product p WHERE p.id IN :flashSaleIds AND " +
            "(:cid IS NULL OR p.category.id = :cid) AND " +
            "(:min IS NULL OR p.price >= :min) AND " +
            "(:max IS NULL OR p.price <= :max) AND " +
            "(:kw IS NULL OR p.name LIKE %:kw% OR p.description LIKE %:kw%) AND " +
            "(:brand IS NULL OR p.brand = :brand OR LOWER(p.name) LIKE LOWER(CONCAT('%', :brand, '%'))) AND " +
            "p.image IS NOT NULL")
    org.springframework.data.domain.Page<Product> searchProductsInFlashSale(
            @Param("flashSaleIds") List<Integer> flashSaleIds,
            @Param("cid") Integer cid,
            @Param("min") Double min,
            @Param("max") Double max,
            @Param("kw") String kw,
            @Param("brand") String brand,
            org.springframework.data.domain.Pageable pageable);

    @Query("SELECT DISTINCT p.brand FROM Product p WHERE p.brand IS NOT NULL AND p.brand != '' ORDER BY p.brand ASC")
    List<String> findDistinctBrands();
} // Chỉ có duy nhất một dấu đóng ngoặc ở cuối cùng này
