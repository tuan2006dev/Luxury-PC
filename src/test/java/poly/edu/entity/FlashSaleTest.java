package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class FlashSaleTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        FlashSale entity = new FlashSale();
        entity.setId(1);
        entity.setName("name_test");
        entity.setStartTime(new java.util.Date());
        entity.setEndTime(new java.util.Date());
        entity.setCreatedAt(new java.util.Date());
        entity.setItems(new java.util.ArrayList<>());

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals("name_test", entity.getName());
        assertEquals(new java.util.Date(), entity.getStartTime());
        assertEquals(new java.util.Date(), entity.getEndTime());
        assertEquals(new java.util.Date(), entity.getCreatedAt());
        assertEquals(new java.util.ArrayList<>(), entity.getItems());
    }
}
