package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class NewsCategoryTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        NewsCategory entity = new NewsCategory();
        entity.setId(1);
        entity.setName("name_test");
        entity.setSlug("slug_test");
        entity.setDescription("description_test");
        entity.setNewsList(new java.util.ArrayList<>());
        entity.setCreatedAt(new java.util.Date());
        entity.setUpdatedAt(new java.util.Date());

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals("name_test", entity.getName());
        assertEquals("slug_test", entity.getSlug());
        assertEquals("description_test", entity.getDescription());
        assertEquals(new java.util.ArrayList<>(), entity.getNewsList());
        assertEquals(new java.util.Date(), entity.getCreatedAt());
        assertEquals(new java.util.Date(), entity.getUpdatedAt());
    }
}
