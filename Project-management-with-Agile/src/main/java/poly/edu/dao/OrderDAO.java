package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import poly.edu.entity.Order;
import java.util.List;
import java.util.Map;

public interface OrderDAO extends JpaRepository<Order, Integer> {

    @Query("SELECT o FROM Order o ORDER BY o.createdAt DESC")
    List<Order> findAllOrderedByDate();

    @Query(value = "SELECT TO_CHAR(created_at, 'YYYY-MM') as month, SUM(total_price) as revenue " +
                   "FROM orders WHERE status = 'COMPLETED' " +
                   "GROUP BY month ORDER BY month DESC", nativeQuery = true)
    List<Map<String, Object>> getMonthlyRevenue();

    @Query("SELECT COUNT(o) FROM Order o WHERE o.status = 'PENDING'")
    long countPendingOrders();

    @Query("SELECT COALESCE(SUM(o.totalPrice), 0.0) FROM Order o WHERE o.user.id = :userId AND o.status = 'COMPLETED'")
    Double getTotalSpentByUser(@Param("userId") Integer userId);

    Long countByUser_Id(Integer userId);

    List<Order> findByUser_IdOrderByCreatedAtDesc(Integer userId);
}
