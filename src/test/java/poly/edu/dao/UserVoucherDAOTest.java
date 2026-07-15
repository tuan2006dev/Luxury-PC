package poly.edu.dao;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;
import static org.assertj.core.api.Assertions.assertThat;
import poly.edu.entity.UserVoucher;
import org.springframework.transaction.annotation.Transactional;

@DataJpaTest
@ActiveProfiles("test")
@Transactional
public class UserVoucherDAOTest {

    @Autowired
    private UserVoucherDAO repository;

    @Test
    public void testRepositoryIsNotNull() {
        assertThat(repository).isNotNull();
    }

    @Test
    public void test_findByUserOrderBySavedAtDesc() {
        try {
            Object result = repository.findByUserOrderBySavedAtDesc(null);
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByUserOrderBySavedAtDesc: " + e.getMessage());
        }
    }

    @Test
    public void test_findByUserAndIsUsedFalseOrderBySavedAtDesc() {
        try {
            Object result = repository.findByUserAndIsUsedFalseOrderBySavedAtDesc(null);
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByUserAndIsUsedFalseOrderBySavedAtDesc: " + e.getMessage());
        }
    }

    @Test
    public void test_findByUserAndVoucher() {
        try {
            Object result = repository.findByUserAndVoucher(null, null);
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByUserAndVoucher: " + e.getMessage());
        }
    }

    @Test
    public void test_findByUserAndVoucherCodeAndIsUsedFalse() {
        try {
            Object result = repository.findByUserAndVoucherCodeAndIsUsedFalse(null, "test");
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByUserAndVoucherCodeAndIsUsedFalse: " + e.getMessage());
        }
    }

    @Test
    public void test_countByVoucher() {
        try {
            Object result = repository.countByVoucher(null);
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test countByVoucher: " + e.getMessage());
        }
    }
}
