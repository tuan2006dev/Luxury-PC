package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class VoucherTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        Voucher entity = new Voucher();
        entity.setId(1);
        entity.setCode("code_test");
        entity.setDescription("description_test");
        entity.setDiscountType(Voucher.DiscountType.PERCENTAGE);
        entity.setDiscountValue(1.0);
        entity.setMinOrderAmount(1.0);
        entity.setMaxDiscountAmount(1.0);
        entity.setUsageLimit(1);
        java.util.Date now = new java.util.Date();
        entity.setStartDate(now);
        entity.setEndDate(now);
        entity.setCategory(new Category());
        entity.setCreatedAt(now);

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals("code_test", entity.getCode());
        assertEquals("description_test", entity.getDescription());
        assertEquals(Voucher.DiscountType.PERCENTAGE, entity.getDiscountType());
        assertEquals(1.0, entity.getDiscountValue());
        assertEquals(1.0, entity.getMinOrderAmount());
        assertEquals(1.0, entity.getMaxDiscountAmount());
        assertEquals(1, entity.getUsageLimit());
        assertEquals(now, entity.getStartDate());
        assertEquals(now, entity.getEndDate());
        assertNotNull(entity.getCategory());
        assertEquals(now, entity.getCreatedAt());
    }
}
