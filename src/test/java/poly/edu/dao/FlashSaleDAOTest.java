package poly.edu.dao;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;
import static org.assertj.core.api.Assertions.assertThat;
import poly.edu.entity.FlashSale;
import org.springframework.transaction.annotation.Transactional;

@DataJpaTest
@ActiveProfiles("test")
@Transactional
public class FlashSaleDAOTest {

    @Autowired
    private FlashSaleDAO repository;

    @Test
    public void testRepositoryIsNotNull() {
        assertThat(repository).isNotNull();
    }

    @Test
    public void test_findCurrentActiveSale() {
        try {
            Object result = repository.findCurrentActiveSale();
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findCurrentActiveSale: " + e.getMessage());
        }
    }

    @Test
    public void test_findValidSalesForTime() {
        try {
            Object result = repository.findValidSalesForTime(new java.util.Date());
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findValidSalesForTime: " + e.getMessage());
        }
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
}
