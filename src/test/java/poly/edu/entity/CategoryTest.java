package poly.edu.entity;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class CategoryTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        Category category = new Category();
        Integer id = 1;
        String name = "Electronics";

        // Act
        category.setId(id);
        category.setName(name);

        // Assert
        assertEquals(id, category.getId());
        assertEquals(name, category.getName());
    }

    @Test
    void testConstructorWithAllArgs() {
        // Arrange
        Integer id = 2;
        String name = "Gaming";

        // Act
        Category category = new Category(id, name);

        // Assert
        assertEquals(id, category.getId());
        assertEquals(name, category.getName());
    }
}
