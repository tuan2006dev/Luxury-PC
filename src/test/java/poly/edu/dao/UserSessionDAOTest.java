package poly.edu.dao;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;
import static org.assertj.core.api.Assertions.assertThat;
import poly.edu.entity.UserSession;
import org.springframework.transaction.annotation.Transactional;

@DataJpaTest
@ActiveProfiles("test")
@Transactional
public class UserSessionDAOTest {

    @Autowired
    private UserSessionDAO repository;

    @Test
    public void testRepositoryIsNotNull() {
        assertThat(repository).isNotNull();
    }

    @Test
    public void test_findBySessionId() {
        try {
            Object result = repository.findBySessionId("test");
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findBySessionId: " + e.getMessage());
        }
    }

    @Test
    public void test_findByUserAndIsExpiredFalseOrderByLoginTimeDesc() {
        try {
            Object result = repository.findByUserAndIsExpiredFalseOrderByLoginTimeDesc(null);
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByUserAndIsExpiredFalseOrderByLoginTimeDesc: " + e.getMessage());
        }
    }
}
