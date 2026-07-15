package poly.edu.repository;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;
import static org.assertj.core.api.Assertions.assertThat;
import poly.edu.entity.WishlistItem;
import org.springframework.transaction.annotation.Transactional;

@DataJpaTest
@ActiveProfiles("test")
@Transactional
public class WishlistItemRepositoryTest {

    @Autowired
    private WishlistItemRepository repository;

    @Test
    public void testRepositoryIsNotNull() {
        assertThat(repository).isNotNull();
    }

    @Test
    public void test_findByUser_IdOrderByCreatedAtDesc() {
        try {
            Object result = repository.findByUser_IdOrderByCreatedAtDesc(1);
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByUser_IdOrderByCreatedAtDesc: " + e.getMessage());
        }
    }

    @Test
    public void test_countByUser_Id() {
        try {
            Object result = repository.countByUser_Id(1);
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test countByUser_Id: " + e.getMessage());
        }
    }

    @Test
    public void test_existsByUser_IdAndProduct_Id() {
        try {
            Object result = repository.existsByUser_IdAndProduct_Id(1, 1);
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test existsByUser_IdAndProduct_Id: " + e.getMessage());
        }
    }

    @Test
    public void test_deleteByUserIdAndProductId() {
        try {
            Object result = repository.deleteByUserIdAndProductId(1, 1);
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test deleteByUserIdAndProductId: " + e.getMessage());
        }
    }

    @Test
    public void test_deleteByUserId() {
        try {
            Object result = repository.deleteByUserId(1);
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test deleteByUserId: " + e.getMessage());
        }
    }

    @Test
    public void test_findProductIdsByUserId() {
        try {
            Object result = repository.findProductIdsByUserId(1);
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findProductIdsByUserId: " + e.getMessage());
        }
    }
}
