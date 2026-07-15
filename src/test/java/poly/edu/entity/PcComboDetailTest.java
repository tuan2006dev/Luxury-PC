package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class PcComboDetailTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        PcComboDetail entity = new PcComboDetail();
        entity.setId(1L);
        entity.setCombo(new PcCombo());
        entity.setProduct(new Product());
        entity.setSlotType("slotType_test");

        // Act & Assert
        assertEquals(1L, entity.getId());
        assertEquals(new PcCombo(), entity.getCombo());
        assertEquals(new Product(), entity.getProduct());
        assertEquals("slotType_test", entity.getSlotType());
    }
}
