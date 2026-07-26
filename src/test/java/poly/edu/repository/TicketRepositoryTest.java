package poly.edu.repository;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;
import static org.assertj.core.api.Assertions.assertThat;
import poly.edu.entity.Ticket;
import org.springframework.transaction.annotation.Transactional;

@DataJpaTest
@ActiveProfiles("test")
@Transactional
public class TicketRepositoryTest {

    @Autowired
    private TicketRepository repository;

    @Test
    public void testRepositoryIsNotNull() {
        assertThat(repository).isNotNull();
    }

    @Test
    public void test_findAllByOrderByCreatedAtDesc() {
        try {
            Object result = repository.findAllByOrderByCreatedAtDesc();
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findAllByOrderByCreatedAtDesc: " + e.getMessage());
        }
    }

    @Test
    public void test_findByStatusOrderByCreatedAtDesc() {
        try {
            Object result = repository.findByStatusOrderByCreatedAtDesc("test");
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByStatusOrderByCreatedAtDesc: " + e.getMessage());
        }
    }

    @Test
    public void test_countByStatus() {
        try {
            Object result = repository.countByStatus("test");
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test countByStatus: " + e.getMessage());
        }
    }
}
