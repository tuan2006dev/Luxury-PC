package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.OrderItem;

import org.springframework.data.jpa.repository.Query;
import java.util.List;
import java.util.Map;

public interface OrderItemDAO extends JpaRepository<OrderItem, Integer> {
    @Query("SELECT oi.product.name as name, SUM(oi.quantity) as totalQty " +
           "FROM OrderItem oi GROUP BY oi.product.id, oi.product.name " +
           "ORDER BY SUM(oi.quantity) DESC")
    List<Map<String, Object>> findTopSellingProducts();

    @Query("SELECT COUNT(oi) FROM OrderItem oi WHERE oi.order.user.id = :userId AND oi.product.id = :productId AND oi.order.status IN ('COMPLETED', 'HOAN_THANH')")
    long countCompletedPurchasesByUserAndProduct(@org.springframework.data.repository.query.Param("userId") Integer userId, @org.springframework.data.repository.query.Param("productId") Integer productId);
}
