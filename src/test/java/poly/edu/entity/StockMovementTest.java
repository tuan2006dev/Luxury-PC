package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class StockMovementTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        StockMovement entity = new StockMovement();
        entity.setId(1);
        entity.setProduct(new Product());
        entity.setChangeQuantity(1);
        entity.setMovementType("movementType_test");
        entity.setNote("note_test");
        entity.setCreatedAt(new java.util.Date());

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals(new Product(), entity.getProduct());
        assertEquals(1, entity.getChangeQuantity());
        assertEquals("movementType_test", entity.getMovementType());
        assertEquals("note_test", entity.getNote());
        assertEquals(new java.util.Date(), entity.getCreatedAt());
    }
}
