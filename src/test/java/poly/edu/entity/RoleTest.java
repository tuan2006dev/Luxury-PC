package poly.edu.entity;

import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class RoleTest {

    @Test
    void testRoleConstructorAndGetters() {
        // Arrange
        Integer id = 1;
        String name = "ADMIN";
        List<UserRole> userRoles = new ArrayList<>();

        // Act
        Role role = new Role(id, name, userRoles);

        // Assert
        assertEquals(id, role.getId());
        assertEquals(name, role.getName());
        assertSame(userRoles, role.getUserRoles());
    }

    @Test
    void testRoleSetters() {
        // Arrange
        Role role = new Role();
        Integer id = 2;
        String name = "USER";
        List<UserRole> userRoles = new ArrayList<>();

        // Act
        role.setId(id);
        role.setName(name);
        role.setUserRoles(userRoles);

        // Assert
        assertEquals(id, role.getId());
        assertEquals(name, role.getName());
        assertSame(userRoles, role.getUserRoles());
    }
}
