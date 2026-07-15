package poly.edu.entity;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;

class WishlistItemTest {

    private WishlistItem wishlistItem;

    @BeforeEach
    void setUp() {
        wishlistItem = new WishlistItem();
    }

    @Test
    void testPrePersist() {
        // Arrange is setUp
        // Act
        wishlistItem.onCreate();

        // Assert
        assertNotNull(wishlistItem.getCreatedAt());
        long diff = Math.abs(new Date().getTime() - wishlistItem.getCreatedAt().getTime());
        assertTrue(diff < 1000);
    }

    @Test
    void testSettersAndGetters() {
        // Arrange
        Integer id = 1;
        User user = new User();
        Product product = new Product();
        Date createdAt = new Date();

        // Act
        wishlistItem.setId(id);
        wishlistItem.setUser(user);
        wishlistItem.setProduct(product);
        wishlistItem.setCreatedAt(createdAt);

        // Assert
        assertEquals(id, wishlistItem.getId());
        assertEquals(user, wishlistItem.getUser());
        assertEquals(product, wishlistItem.getProduct());
        assertEquals(createdAt, wishlistItem.getCreatedAt());
    }
}
