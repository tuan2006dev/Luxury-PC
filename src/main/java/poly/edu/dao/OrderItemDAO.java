package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import poly.edu.entity.OrderItem;

import java.util.List;
import java.util.Map;

public interface OrderItemDAO extends JpaRepository<OrderItem, Integer> {
       @Query("SELECT oi.product.name as name, oi.product.image as image, SUM(oi.quantity) as totalQty " +
                     "FROM OrderItem oi GROUP BY oi.product.id, oi.product.name, oi.product.image " +
                     "ORDER BY SUM(oi.quantity) DESC")
       List<Map<String, Object>> findTopSellingProducts();

       @Query("SELECT COUNT(oi) FROM OrderItem oi WHERE oi.order.user.id = :userId AND oi.product.id = :productId AND oi.order.status IN ('COMPLETED', 'HOAN_THANH')")
       long countCompletedPurchasesByUserAndProduct(
                     @Param("userId") Integer userId,
                     @Param("productId") Integer productId);

       /**
        * Đếm tổng số sản phẩm flash-sale mà user đã mua trong một đợt flash sale (mọi
        * trạng thái đơn trừ CANCELLED)
        */
       @Query("SELECT COALESCE(SUM(oi.quantity), 0) FROM OrderItem oi " +
                     "JOIN FlashSaleItem fsi ON fsi.product.id = oi.product.id " +
                     "WHERE oi.order.user.id = :userId " +
                     "AND fsi.flashSale.id = :flashSaleId " +
                     "AND oi.order.status NOT IN ('CANCELLED', 'HUY')")
       long countFlashSalePurchasesByUser(@Param("userId") Integer userId,
                     @Param("flashSaleId") Integer flashSaleId);

       @Modifying
       @Query("DELETE FROM OrderItem oi WHERE oi.order.orderCode LIKE 'DEMO-%'")
       void deleteDemoOrderItems();
}