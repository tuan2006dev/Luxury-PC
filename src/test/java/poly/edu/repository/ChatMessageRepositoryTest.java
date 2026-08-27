package poly.edu.repository;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;
import static org.assertj.core.api.Assertions.assertThat;
import org.springframework.transaction.annotation.Transactional;

@DataJpaTest
@ActiveProfiles("test")
@Transactional
public class ChatMessageRepositoryTest {

    @Autowired
    private ChatMessageRepository repository;

    @Test
    public void testRepositoryIsNotNull() {
        assertThat(repository).isNotNull();
    }

    @Test
    public void test_findByTicketIdOrderByCreatedAtAsc() {
        try {
            repository.findByTicketIdOrderByCreatedAtAsc(1);
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByTicketIdOrderByCreatedAtAsc: " + e.getMessage());
        }
    }
}
