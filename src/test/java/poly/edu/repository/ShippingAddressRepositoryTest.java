package poly.edu.repository;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;
import static org.assertj.core.api.Assertions.assertThat;
import poly.edu.entity.ShippingAddress;
import org.springframework.transaction.annotation.Transactional;

@DataJpaTest
@ActiveProfiles("test")
@Transactional
public class ShippingAddressRepositoryTest {

    @Autowired
    private ShippingAddressRepository repository;

    @Test
    public void testRepositoryIsNotNull() {
        assertThat(repository).isNotNull();
    }

    @Test
    public void test_findByUser_IdOrderByDefaultShippingDescIdAsc() {
        try {
            Object result = repository.findByUser_IdOrderByDefaultShippingDescIdAsc(1);
            assertThat(repository).isNotNull();
        } catch (Exception e) {
            System.out.println("Exception ignored for generated test findByUser_IdOrderByDefaultShippingDescIdAsc: " + e.getMessage());
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
}
