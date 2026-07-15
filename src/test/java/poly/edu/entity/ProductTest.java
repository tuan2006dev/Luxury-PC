package poly.edu.entity;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;

class ProductTest {

    private Product product;

    @BeforeEach
    void setUp() {
        product = new Product();
    }

    @Test
    void testSettersAndGetters() {
        // Arrange
        Integer id = 1;
        String name = "Test Product";
        Double price = 1000.0;
        String description = "Test Description";
        String image = "test.png";
        Integer stock = 50;
        String brand = "TestBrand";
        Category category = new Category(1, "Test Category");
        Date createdAt = new Date();

        // Act
        product.setId(id);
        product.setName(name);
        product.setPrice(price);
        product.setDescription(description);
        product.setImage(image);
        product.setStock(stock);
        product.setBrand(brand);
        product.setCategory(category);
        product.setCreatedAt(createdAt);

        // Assert
        assertEquals(id, product.getId());
        assertEquals(name, product.getName());
        assertEquals(price, product.getPrice());
        assertEquals(description, product.getDescription());
        assertEquals(image, product.getImage());
        assertEquals(stock, product.getStock());
        assertEquals(brand, product.getBrand());
        assertEquals(category, product.getCategory());
        assertEquals(createdAt, product.getCreatedAt());
    }

    @Test
    void testConstructorWithAllArgs() {
        // Arrange
        Integer id = 2;
        String name = "Another Product";
        Double price = 2000.0;
        String description = "Another Description";
        String image = "another.png";
        Integer stock = 100;
        String brand = "AnotherBrand";
        Category category = new Category(2, "Another Category");
        Date createdAt = new Date();

        // Act
        Product p = new Product(id, name, price, description, image, stock, brand, category, createdAt);

        // Assert
        assertEquals(id, p.getId());
        assertEquals(name, p.getName());
        assertEquals(price, p.getPrice());
        assertEquals(description, p.getDescription());
        assertEquals(image, p.getImage());
        assertEquals(stock, p.getStock());
        assertEquals(brand, p.getBrand());
        assertEquals(category, p.getCategory());
        assertEquals(createdAt, p.getCreatedAt());
    }
}
