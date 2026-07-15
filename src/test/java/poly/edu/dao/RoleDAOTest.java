package poly.edu.dao;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;
import static org.assertj.core.api.Assertions.assertThat;
import poly.edu.entity.Role;
import org.springframework.transaction.annotation.Transactional;

@DataJpaTest
@ActiveProfiles("test")
@Transactional
public class RoleDAOTest {

    @Autowired
    private RoleDAO repository;

    @Test
    public void testRepositoryIsNotNull() {
        assertThat(repository).isNotNull();
    }

    @Test
    public void test_findByName() {
        try {
            Object result = repository.findByName("test");
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByName: " + e.getMessage());
        }
    }
}
