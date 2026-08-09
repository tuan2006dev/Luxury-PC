package poly.edu.repository;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;
import poly.edu.entity.SupportTicket;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@ActiveProfiles("test")
@Transactional
public class SupportTicketRepositoryTest {

    @Autowired
    private SupportTicketRepository repository;

    private SupportTicket ticket1;
    private SupportTicket ticket2;

    @BeforeEach
    public void setUp() {
        ticket1 = new SupportTicket();
        ticket1.setCustomerName("Nguyen Van A");
        ticket1.setCustomerEmail("a@example.com");
        ticket1.setSubject("Lỗi Build PC");
        ticket1.setMessage("Không lên màn hình");
        ticket1.setStatus("OPEN");
        ticket1.setCategory("BUILD_PC");

        ticket2 = new SupportTicket();
        ticket2.setCustomerName("Tran Thi B");
        ticket2.setCustomerEmail("b@example.com");
        ticket2.setSubject("Hỏi giá");
        ticket2.setMessage("Báo giá card màn hình");
        ticket2.setStatus("IN_PROGRESS");
        ticket2.setCategory("PRICE");
    }

    @Test
    public void testRepositoryIsNotNull() {
        assertThat(repository).isNotNull();
    }

    @Test
    public void test_findAllByOrderByCreatedAtDesc() {
        repository.save(ticket1);
        repository.save(ticket2);

        List<SupportTicket> result = repository.findAllByOrderByCreatedAtDesc();
        assertThat(result).hasSize(2);
    }

    @Test
    public void test_findTop100ByStatusOrderByCreatedAtDesc() {
        repository.save(ticket1);
        repository.save(ticket2);

        List<SupportTicket> result = repository.findTop100ByStatusOrderByCreatedAtDesc("OPEN");
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getCustomerEmail()).isEqualTo("a@example.com");
    }

    @Test
    public void test_findByCustomerEmailOrderByCreatedAtDesc() {
        repository.save(ticket1);
        repository.save(ticket2);

        List<SupportTicket> result = repository.findByCustomerEmailOrderByCreatedAtDesc("a@example.com");
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getSubject()).isEqualTo("Lỗi Build PC");
    }

    @Test
    public void test_countOpenTickets() {
        repository.save(ticket1);
        repository.save(ticket2);

        long count = repository.countOpenTickets();
        assertThat(count).isEqualTo(1);
    }

    @Test
    public void test_countInProgressTickets() {
        repository.save(ticket1);
        repository.save(ticket2);

        long count = repository.countInProgressTickets();
        assertThat(count).isEqualTo(1);
    }
}

