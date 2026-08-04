package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
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

    org.springframework.data.domain.Page<Product> findByNameContainingIgnoreCase(String name, org.springframework.data.domain.Pageable pageable);

    @Query(value = "SELECT p FROM Product p JOIN FETCH p.category", countQuery = "SELECT COUNT(p) FROM Product p")
    org.springframework.data.domain.Page<Product> findAllWithCategory(org.springframework.data.domain.Pageable pageable);

    @Query(value = "SELECT p FROM Product p WHERE " +
            "(:cid IS NULL OR p.category.id = :cid) AND " +
            "(:min IS NULL OR p.price >= :min) AND " +
            "(:max IS NULL OR p.price <= :max) AND " +
            "(:kw IS NULL OR p.name LIKE %:kw% OR p.description LIKE %:kw%) AND " +
            "(:brand IS NULL OR p.brand = :brand OR LOWER(p.name) LIKE LOWER(CONCAT('%', :brand, '%')))",
            countQuery = "SELECT COUNT(p) FROM Product p WHERE " +
            "(:cid IS NULL OR p.category.id = :cid) AND " +
            "(:min IS NULL OR p.price >= :min) AND " +
            "(:max IS NULL OR p.price <= :max) AND " +
            "(:kw IS NULL OR p.name LIKE %:kw% OR p.description LIKE %:kw%) AND " +
            "(:brand IS NULL OR p.brand = :brand OR LOWER(p.name) LIKE LOWER(CONCAT('%', :brand, '%')))")
    org.springframework.data.domain.Page<Product> searchProducts(
            @Param("cid") Integer cid,
            @Param("min") Double min,
            @Param("max") Double max,
            @Param("kw") String kw,
            @Param("brand") String brand,
            org.springframework.data.domain.Pageable pageable);

    @Modifying
    @Query(value = "DELETE FROM cart_items WHERE product_id = :pid", nativeQuery = true)
    void deleteCartItemsByProductId(@Param("pid") Integer pid);

    @Modifying
    @Query(value = "DELETE FROM wishlist_items WHERE product_id = :pid", nativeQuery = true)
    void deleteWishlistItemsByProductId(@Param("pid") Integer pid);

    @Modifying
    @Query(value = "DELETE FROM flash_sale_items WHERE product_id = :pid", nativeQuery = true)
    void deleteFlashSaleItemsByProductId(@Param("pid") Integer pid);

    @Modifying
    @Query(value = "DELETE FROM reviews WHERE product_id = :pid", nativeQuery = true)
    void deleteReviewsByProductId(@Param("pid") Integer pid);

    @Modifying
    @Query(value = "DELETE FROM inventory WHERE product_id = :pid", nativeQuery = true)
    void deleteInventoryByProductId(@Param("pid") Integer pid);

    @Modifying
    @Query(value = "DELETE FROM stock_movements WHERE product_id = :pid", nativeQuery = true)
    void deleteStockMovementsByProductId(@Param("pid") Integer pid);

    @Modifying
    @Query(value = "DELETE FROM pc_combo_details WHERE product_id = :pid", nativeQuery = true)
    void deleteComboDetailsByProductId(@Param("pid") Integer pid);

    @Modifying
    @Query(value = "UPDATE order_items SET product_id = NULL WHERE product_id = :pid", nativeQuery = true)
    void nullifyOrderItemProductReferences(@Param("pid") Integer pid);

    @Modifying
    @Query(value = "UPDATE products SET category_id = NULL WHERE category_id = :cid", nativeQuery = true)
    void nullifyCategoryReferences(@Param("cid") Integer cid);
} // Chỉ có duy nhất một dấu đóng ngoặc ở cuối cùng này
