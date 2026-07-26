package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class PcComboTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        PcCombo entity = new PcCombo();
        entity.setId(1L);
        entity.setName("name_test");
        entity.setDescription("description_test");
        entity.setImage("image_test");
        entity.setBadge("badge_test");
        entity.setBadgeColor("badgeColor_test");
        entity.setPrice(1.0);
        entity.setDetails(new java.util.ArrayList<>());

        // Act & Assert
        assertEquals(1L, entity.getId());
        assertEquals("name_test", entity.getName());
        assertEquals("description_test", entity.getDescription());
        assertEquals("image_test", entity.getImage());
        assertEquals("badge_test", entity.getBadge());
        assertEquals("badgeColor_test", entity.getBadgeColor());
        assertEquals(1.0, entity.getPrice());
        assertEquals(new java.util.ArrayList<>(), entity.getDetails());
    }
}
