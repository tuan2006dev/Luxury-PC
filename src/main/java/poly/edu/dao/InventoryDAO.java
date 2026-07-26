package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import poly.edu.entity.Inventory;
import java.util.List;
import java.util.Optional;

public interface InventoryDAO extends JpaRepository<Inventory, Integer> {
    Optional<Inventory> findByProductId(Integer productId);

    @Query("SELECT i FROM Inventory i JOIN FETCH i.product p LEFT JOIN FETCH p.category WHERE i.quantity < 10")
    List<Inventory> findLowStockItems();

    @Query("SELECT i FROM Inventory i JOIN FETCH i.product p LEFT JOIN FETCH p.category ORDER BY p.name")
    List<Inventory> findAllWithProductAndCategory();

    @Query(value = "SELECT i FROM Inventory i JOIN FETCH i.product p LEFT JOIN FETCH p.category ORDER BY p.name", countQuery = "SELECT COUNT(i) FROM Inventory i")
    org.springframework.data.domain.Page<Inventory> findAllWithProductAndCategory(org.springframework.data.domain.Pageable pageable);

    @Query(value = "SELECT i FROM Inventory i JOIN FETCH i.product p LEFT JOIN FETCH p.category WHERE LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%')) ORDER BY p.name", countQuery = "SELECT COUNT(i) FROM Inventory i JOIN i.product p WHERE LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    org.springframework.data.domain.Page<Inventory> searchWithProductAndCategory(@org.springframework.data.repository.query.Param("keyword") String keyword, org.springframework.data.domain.Pageable pageable);
}
