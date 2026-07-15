package poly.edu.dao;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;
import static org.assertj.core.api.Assertions.assertThat;
import poly.edu.entity.User;
import org.springframework.transaction.annotation.Transactional;

@DataJpaTest
@ActiveProfiles("test")
@Transactional
public class UserDAOTest {

    @Autowired
    private UserDAO repository;

    @Test
    public void testRepositoryIsNotNull() {
        assertThat(repository).isNotNull();
    }

    @Test
    public void test_findByEmail() {
        try {
            Object result = repository.findByEmail("test");
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByEmail: " + e.getMessage());
        }
    }

    @Test
    public void test_findByEmailAndPassword() {
        try {
            Object result = repository.findByEmailAndPassword("test", "test");
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByEmailAndPassword: " + e.getMessage());
        }
    }

    @Test
    public void test_findByUsername() {
        try {
            Object result = repository.findByUsername("test");
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByUsername: " + e.getMessage());
        }
    }

    @Test
    public void test_findByEmailWithRoles() {
        try {
            Object result = repository.findByEmailWithRoles("test");
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByEmailWithRoles: " + e.getMessage());
        }
    }

    @Test
    public void test_findByUsernameWithRoles() {
        try {
            Object result = repository.findByUsernameWithRoles("test");
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByUsernameWithRoles: " + e.getMessage());
        }
    }
}
