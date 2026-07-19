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
        java.util.Date now = new java.util.Date();
        entity.setCreatedAt(now);

        // Act & Assert
        assertEquals(1, entity.getId());
        assertNotNull(entity.getProduct());
        assertEquals(1, entity.getChangeQuantity());
        assertEquals("movementType_test", entity.getMovementType());
        assertEquals("note_test", entity.getNote());
        assertEquals(now, entity.getCreatedAt());
    }
}
