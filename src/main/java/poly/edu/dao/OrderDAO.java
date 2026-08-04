package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.Lock;
import jakarta.persistence.LockModeType;
import poly.edu.entity.Order;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface OrderDAO extends JpaRepository<Order, Integer> {
    
    @Query("SELECT o FROM Order o ORDER BY o.createdAt DESC")
    List<Order> findAllOrderedByDate();

    @Query(value = "SELECT CONVERT(VARCHAR(7), created_at, 120) as month, SUM(total_price) as revenue " +
                   "FROM orders WHERE status NOT IN ('CANCELLED', 'DA_HUY', 'HUY', 'DA_HOAN_TIEN', 'THU_HOI') " +
                   "GROUP BY CONVERT(VARCHAR(7), created_at, 120) ORDER BY month DESC", nativeQuery = true)
    List<Map<String, Object>> getMonthlyRevenue();

    @Query(value = "SELECT CONVERT(VARCHAR(10), created_at, 120) as date, SUM(total_price) as revenue " +
                   "FROM orders WHERE status NOT IN ('CANCELLED', 'DA_HUY', 'HUY', 'DA_HOAN_TIEN', 'THU_HOI') AND created_at >= :startDate " +
                   "GROUP BY CONVERT(VARCHAR(10), created_at, 120) ORDER BY date ASC", nativeQuery = true)
    List<Map<String, Object>> getDailyRevenue(@org.springframework.data.repository.query.Param("startDate") java.util.Date startDate);

    @Query(value = "SELECT status, COUNT(*) as count FROM orders WHERE created_at >= :startDate GROUP BY status", nativeQuery = true)
    List<Map<String, Object>> getOrderStatusStats(@org.springframework.data.repository.query.Param("startDate") java.util.Date startDate);

    @Query(value = "SELECT CONVERT(VARCHAR(10), created_at, 120) as date, SUM(total_price) as revenue " +
                   "FROM orders WHERE status NOT IN ('CANCELLED', 'DA_HUY', 'HUY', 'DA_HOAN_TIEN', 'THU_HOI') AND created_at >= :start AND created_at <= :end " +
                   "GROUP BY CONVERT(VARCHAR(10), created_at, 120) ORDER BY date ASC", nativeQuery = true)
    List<Map<String, Object>> getDailyRevenueBetween(@org.springframework.data.repository.query.Param("start") java.util.Date start, @org.springframework.data.repository.query.Param("end") java.util.Date end);

    @Query(value = "SELECT status, COUNT(*) as count FROM orders WHERE created_at >= :start AND created_at <= :end GROUP BY status", nativeQuery = true)
    List<Map<String, Object>> getOrderStatusBetween(@org.springframework.data.repository.query.Param("start") java.util.Date start, @org.springframework.data.repository.query.Param("end") java.util.Date end);

    @Query("SELECT COUNT(o) FROM Order o WHERE o.createdAt >= :start AND o.createdAt <= :end")
    Long countOrdersBetween(@org.springframework.data.repository.query.Param("start") java.util.Date start, @org.springframework.data.repository.query.Param("end") java.util.Date end);

    @Query("SELECT COALESCE(SUM(o.totalPrice), 0.0) FROM Order o WHERE o.status NOT IN ('CANCELLED', 'DA_HUY', 'HUY', 'DA_HOAN_TIEN', 'THU_HOI') AND o.createdAt >= :start AND o.createdAt <= :end")
    Double getRevenueBetween(@org.springframework.data.repository.query.Param("start") java.util.Date start, @org.springframework.data.repository.query.Param("end") java.util.Date end);

    @Query("SELECT COUNT(o) FROM Order o WHERE o.status IN ('PENDING', 'CHO_XAC_NHAN_THANH_TOAN')")
    long countPendingOrders();

    @Query("SELECT SUM(o.totalPrice) FROM Order o WHERE o.user.id = :userId AND o.status IN ('PAID', 'DA_THANH_TOAN', 'SHIPPING', 'COMPLETED')")
    Double getTotalSpentByUser(Integer userId);

    @Query("SELECT COUNT(o) FROM Order o WHERE o.user.id = :userId AND o.status IN ('PAID', 'DA_THANH_TOAN', 'COMPLETED', 'HOAN_THANH')")
    Long countCompletedOrdersByUser(Integer userId);

    @Query("SELECT COUNT(o) FROM Order o WHERE o.user.id = :userId")
    Long countOrdersByUser(Integer userId);

    @Query("SELECT o FROM Order o WHERE o.user.id = :userId ORDER BY o.createdAt DESC")
    List<Order> findByUserIdOrderByCreatedAtDesc(Integer userId);

    // Alias methods used by ProfileController (D project merge)
    Long countByUser_Id(Integer userId);
    List<Order> findByUser_IdOrderByCreatedAtDesc(Integer userId);

    Optional<Order> findByOrderCode(String orderCode);


    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT o FROM Order o WHERE o.orderCode = :orderCode")
    Optional<Order> findByOrderCodeForUpdate(@org.springframework.data.repository.query.Param("orderCode") String orderCode);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT o FROM Order o WHERE o.id = :id")
    Optional<Order> findByIdForUpdate(@org.springframework.data.repository.query.Param("id") Integer id);
    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query("UPDATE Order o SET o.user = null WHERE o.user.id = :userId")
    void nullifyUserReferences(@org.springframework.data.repository.query.Param("userId") Integer userId);

    @Query("SELECT o FROM Order o WHERE o.status = 'PENDING' AND o.createdAt < :threshold")
    List<Order> findExpiredPendingOrders(@org.springframework.data.repository.query.Param("threshold") java.util.Date threshold);

    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query("DELETE FROM Order o WHERE o.orderCode LIKE 'DEMO-%'")
    void deleteDemoOrders();
}
