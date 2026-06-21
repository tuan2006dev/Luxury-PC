package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import poly.edu.entity.Order;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface OrderDAO extends JpaRepository<Order, Integer> {
    
    @Query("SELECT o FROM Order o ORDER BY o.createdAt DESC")
    List<Order> findAllOrderedByDate();

    @Query(value = "SELECT TO_CHAR(created_at, 'YYYY-MM') as month, SUM(total_price) as revenue " +
                   "FROM orders WHERE status = 'COMPLETED' " +
                   "GROUP BY month ORDER BY month DESC", nativeQuery = true)
    List<Map<String, Object>> getMonthlyRevenue();

    @Query("SELECT COUNT(o) FROM Order o WHERE o.status IN ('PENDING', 'CHO_XAC_NHAN_THANH_TOAN')")
    long countPendingOrders();

    @Query("SELECT SUM(o.totalPrice) FROM Order o WHERE o.user.id = :userId AND o.status IN ('PAID', 'DA_THANH_TOAN', 'SHIPPING', 'COMPLETED')")
    Double getTotalSpentByUser(Integer userId);

    @Query("SELECT COUNT(o) FROM Order o WHERE o.user.id = :userId")
    Long countOrdersByUser(Integer userId);

    @Query("SELECT o FROM Order o WHERE o.user.id = :userId ORDER BY o.createdAt DESC")
    List<Order> findByUserIdOrderByCreatedAtDesc(Integer userId);

    // Alias methods used by ProfileController (D project merge)
    Long countByUser_Id(Integer userId);
    List<Order> findByUser_IdOrderByCreatedAtDesc(Integer userId);

    Optional<Order> findByOrderCode(String orderCode);

    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query("UPDATE Order o SET o.user = null WHERE o.user.id = :userId")
    void nullifyUserReferences(@org.springframework.data.repository.query.Param("userId") Integer userId);
}
