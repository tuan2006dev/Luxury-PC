package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class InventoryTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        Inventory entity = new Inventory();
        entity.setId(1);
        entity.setProduct(new Product());
        entity.setQuantity(1);
        entity.setLastUpdate(new java.util.Date());

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals(new Product(), entity.getProduct());
        assertEquals(1, entity.getQuantity());
        assertEquals(new java.util.Date(), entity.getLastUpdate());
    }
}
