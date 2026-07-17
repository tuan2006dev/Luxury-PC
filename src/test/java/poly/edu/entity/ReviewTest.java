package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class ReviewTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        Review entity = new Review();
        entity.setId(1);
        entity.setContent("content_test");
        entity.setStars(1);
        entity.setImage("image_test");
        entity.setVideo("video_test");
        User testUser = new User();
        Product testProduct = new Product();
        entity.setUser(testUser);
        entity.setProduct(testProduct);

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals("content_test", entity.getContent());
        assertEquals(1, entity.getStars());
        assertEquals("image_test", entity.getImage());
        assertEquals("video_test", entity.getVideo());
        assertEquals(testUser, entity.getUser());
        assertEquals(testProduct, entity.getProduct());
    }
}
