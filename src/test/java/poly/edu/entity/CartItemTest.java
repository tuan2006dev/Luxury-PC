package poly.edu.entity;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class CartItemTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        CartItem cartItem = new CartItem();
        Integer id = 1;
        String name = "Test Item";
        Double price = 100.0;
        Integer quantity = 2;
        String image = "image.png";
        Integer stock = 10;

        // Act
        cartItem.setId(id);
        cartItem.setName(name);
        cartItem.setPrice(price);
        cartItem.setQuantity(quantity);
        cartItem.setImage(image);
        cartItem.setStock(stock);

        // Assert
        assertEquals(id, cartItem.getId());
        assertEquals(name, cartItem.getName());
        assertEquals(price, cartItem.getPrice());
        assertEquals(quantity, cartItem.getQuantity());
        assertEquals(image, cartItem.getImage());
        assertEquals(stock, cartItem.getStock());
    }

    @Test
    void testConstructorWithArgs() {
        // Arrange
        Integer id = 2;
        String name = "Another Item";
        Double price = 200.0;
        Integer quantity = 3;

        // Act
        CartItem cartItem = new CartItem(id, name, price, quantity);

        // Assert
        assertEquals(id, cartItem.getId());
        assertEquals(name, cartItem.getName());
        assertEquals(price, cartItem.getPrice());
        assertEquals(quantity, cartItem.getQuantity());
    }

    @Test
    void testGetAmount() {
        // Arrange
        CartItem cartItem = new CartItem(1, "Test", 150.0, 3);
        // Act & Assert
        assertEquals(450.0, cartItem.getAmount());
    }

    @Test
    void testGetAmountWithNullPrice() {
        // Arrange
        CartItem cartItem = new CartItem();
        cartItem.setQuantity(2);
        // Act & Assert
        assertEquals(0.0, cartItem.getAmount());
    }

    @Test
    void testGetAmountWithNullQuantity() {
        // Arrange
        CartItem cartItem = new CartItem();
        cartItem.setPrice(100.0);
        // Act & Assert
        assertEquals(0.0, cartItem.getAmount());
    }
}
