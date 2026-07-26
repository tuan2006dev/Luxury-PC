package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class FlashSaleItemTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        FlashSaleItem entity = new FlashSaleItem();
        entity.setId(1);
        entity.setFlashSale(new FlashSale());
        entity.setProduct(new Product());
        entity.setSalePrice(1.0);
        entity.setSaleQuantity(1);

        // Act & Assert
        assertEquals(1, entity.getId());
        assertNotNull(entity.getFlashSale());
        assertNotNull(entity.getProduct());
        assertEquals(1.0, entity.getSalePrice());
        assertEquals(1, entity.getSaleQuantity());
    }
}
