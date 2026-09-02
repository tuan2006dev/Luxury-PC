package poly.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import poly.edu.entity.SupportTicket;
import java.util.List;

public interface SupportTicketRepository extends JpaRepository<SupportTicket, Integer> {

    List<SupportTicket> findAllByOrderByCreatedAtDesc();

    List<SupportTicket> findTop100ByOrderByCreatedAtDesc();

    List<SupportTicket> findTop100ByStatusOrderByCreatedAtDesc(String status);
    
    List<SupportTicket> findTop100ByStatusInOrderByCreatedAtDesc(List<String> statuses);

    List<SupportTicket> findByStatusInAndCreatedAtBefore(List<String> statuses, java.time.LocalDateTime date);

    List<SupportTicket> findByStatusInAndUpdatedAtBefore(List<String> statuses, java.util.Date date);

    List<SupportTicket> findByCustomerEmailOrderByCreatedAtDesc(String email);

    @Query("SELECT COUNT(t) FROM SupportTicket t WHERE t.status = 'OPEN'")
    long countOpenTickets();

    @Query("SELECT COUNT(t) FROM SupportTicket t WHERE t.status = 'IN_PROGRESS'")
    long countInProgressTickets();

    @Query("SELECT t FROM SupportTicket t WHERE t.user.id = :userId AND t.status IN ('OPEN', 'IN_PROGRESS') ORDER BY t.createdAt DESC")
    List<SupportTicket> findActiveTicketsByUserId(@org.springframework.data.repository.query.Param("userId") Integer userId);

    @Query("SELECT t FROM SupportTicket t WHERE t.customerEmail = :email AND t.status IN ('OPEN', 'IN_PROGRESS') ORDER BY t.createdAt DESC")
    List<SupportTicket> findActiveTicketsByEmail(@org.springframework.data.repository.query.Param("email") String email);

    @Query("SELECT t FROM SupportTicket t WHERE t.customerPhone = :phone AND t.status IN ('OPEN', 'IN_PROGRESS') ORDER BY t.createdAt DESC")
    List<SupportTicket> findActiveTicketsByPhone(@org.springframework.data.repository.query.Param("phone") String phone);

    @Query("SELECT t FROM SupportTicket t WHERE ((:userId IS NOT NULL AND t.user.id = :userId) OR (:email IS NOT NULL AND :email <> '' AND t.customerEmail = :email) OR (:phone IS NOT NULL AND :phone <> '' AND t.customerPhone = :phone)) AND t.status IN ('OPEN', 'IN_PROGRESS') ORDER BY t.createdAt DESC")
    List<SupportTicket> findActiveTickets(
            @org.springframework.data.repository.query.Param("userId") Integer userId,
            @org.springframework.data.repository.query.Param("email") String email,
            @org.springframework.data.repository.query.Param("phone") String phone
    );
}
