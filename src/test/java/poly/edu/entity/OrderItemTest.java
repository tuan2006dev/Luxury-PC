package poly.edu.entity;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class OrderItemTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        OrderItem orderItem = new OrderItem();
        Integer id = 1;
        Order order = new Order();
        Product product = new Product();
        Double price = 1500.0;
        Integer quantity = 2;

        // Act
        orderItem.setId(id);
        orderItem.setOrder(order);
        orderItem.setProduct(product);
        orderItem.setPrice(price);
        orderItem.setQuantity(quantity);

        // Assert
        assertEquals(id, orderItem.getId());
        assertEquals(order, orderItem.getOrder());
        assertEquals(product, orderItem.getProduct());
        assertEquals(price, orderItem.getPrice());
        assertEquals(quantity, orderItem.getQuantity());
    }

    @Test
    void testConstructorWithAllArgs() {
        // Arrange
        Integer id = 2;
        Order order = new Order();
        Product product = new Product();
        Double price = 2500.0;
        Integer quantity = 3;

        // Act
        OrderItem orderItem = new OrderItem(id, order, product, price, quantity);

        // Assert
        assertEquals(id, orderItem.getId());
        assertEquals(order, orderItem.getOrder());
        assertEquals(product, orderItem.getProduct());
        assertEquals(price, orderItem.getPrice());
        assertEquals(quantity, orderItem.getQuantity());
    }
}
