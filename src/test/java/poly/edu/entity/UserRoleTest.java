package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class UserRoleTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        UserRole entity = new UserRole();
        entity.setId(1);
        entity.setUser(new User());
        entity.setRole(new Role());

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals(new User(), entity.getUser());
        assertEquals(new Role(), entity.getRole());
    }
}
