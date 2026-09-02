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
    List<SupportTicket> findActiveTicketsByUserId(Integer userId);

    @Query("SELECT t FROM SupportTicket t WHERE t.customerEmail = :email AND t.status IN ('OPEN', 'IN_PROGRESS') ORDER BY t.createdAt DESC")
    List<SupportTicket> findActiveTicketsByEmail(String email);
}
