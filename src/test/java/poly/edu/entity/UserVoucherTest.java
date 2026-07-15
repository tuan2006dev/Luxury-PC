package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class UserVoucherTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        UserVoucher entity = new UserVoucher();
        entity.setId(1);
        entity.setUser(new User());
        entity.setVoucher(new Voucher());
        entity.setSavedAt(new java.util.Date());
        entity.setUsedAt(new java.util.Date());

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals(new User(), entity.getUser());
        assertEquals(new Voucher(), entity.getVoucher());
        assertEquals(new java.util.Date(), entity.getSavedAt());
        assertEquals(new java.util.Date(), entity.getUsedAt());
    }
}
