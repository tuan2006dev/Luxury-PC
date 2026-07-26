package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class PasswordResetTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        PasswordReset entity = new PasswordReset();
        entity.setId(1L);
        entity.setEmail("email_test");
        entity.setToken("token_test");
        entity.setExpiry(java.time.LocalDateTime.now());

        // Act & Assert
        assertEquals(1L, entity.getId());
        assertEquals("email_test", entity.getEmail());
        assertEquals("token_test", entity.getToken());
        assertNotNull(entity.getExpiry());
    }
}
