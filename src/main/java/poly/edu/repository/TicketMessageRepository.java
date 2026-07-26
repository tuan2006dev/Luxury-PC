package poly.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.TicketMessage;
import java.util.List;

public interface TicketMessageRepository extends JpaRepository<TicketMessage, Integer> {

    List<TicketMessage> findByTicketIdOrderByCreatedAtAsc(Integer ticketId);

    void deleteByTicketId(Integer ticketId);
}
