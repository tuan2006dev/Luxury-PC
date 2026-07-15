package poly.edu.entity;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class UserTest {

    private User user;

    @BeforeEach
    void setUp() {
        user = new User();
    }

    @Test
    void testDefaultValues() {
        // Assert defaults
        assertTrue(user.getStatus());
        assertEquals(User.AuthProvider.LOCAL, user.getAuthProvider());
        assertTrue(user.getNotifyOrderUpdates());
        assertTrue(user.getNotifyFlashSale());
        assertFalse(user.getNotifyNewProducts());
        assertTrue(user.getNotifyWeeklyNewsletter());
        assertFalse(user.getTwoFactorEnabled());
    }

    @Test
    void testPrePersist() {
        // Arrange is setUp
        // Act
        user.onCreate();

        // Assert
        assertNotNull(user.getCreatedAt());
        // Verify time is close to now
        long diff = Math.abs(new Date().getTime() - user.getCreatedAt().getTime());
        assertTrue(diff < 1000);
    }

    @Test
    void testSettersAndGetters() {
        // Arrange
        Integer id = 1;
        String username = "testuser";
        String email = "test@example.com";
        String password = "password";
        String fullName = "Test User";
        String phone = "0123456789";
        String address = "123 Street";
        String avatar = "avatar.jpg";
        Boolean gender = true;
        Date birthday = new Date();
        Boolean status = false;
        List<UserRole> userRoles = new ArrayList<>();
        User.AuthProvider authProvider = User.AuthProvider.GOOGLE;
        String providerId = "google123";
        Boolean notifyOrderUpdates = false;
        Boolean notifyFlashSale = false;
        Boolean notifyNewProducts = true;
        Boolean notifyWeeklyNewsletter = false;
        Boolean twoFactorEnabled = true;

        // Act
        user.setId(id);
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);
        user.setFullName(fullName);
        user.setPhone(phone);
        user.setAddress(address);
        user.setAvatar(avatar);
        user.setGender(gender);
        user.setBirthday(birthday);
        user.setStatus(status);
        user.setUserRoles(userRoles);
        user.setAuthProvider(authProvider);
        user.setProviderId(providerId);
        user.setNotifyOrderUpdates(notifyOrderUpdates);
        user.setNotifyFlashSale(notifyFlashSale);
        user.setNotifyNewProducts(notifyNewProducts);
        user.setNotifyWeeklyNewsletter(notifyWeeklyNewsletter);
        user.setTwoFactorEnabled(twoFactorEnabled);

        // Assert
        assertEquals(id, user.getId());
        assertEquals(username, user.getUsername());
        assertEquals(email, user.getEmail());
        assertEquals(password, user.getPassword());
        assertEquals(fullName, user.getFullName());
        assertEquals(phone, user.getPhone());
        assertEquals(address, user.getAddress());
        assertEquals(avatar, user.getAvatar());
        assertEquals(gender, user.getGender());
        assertEquals(birthday, user.getBirthday());
        assertEquals(status, user.getStatus());
        assertSame(userRoles, user.getUserRoles());
        assertEquals(authProvider, user.getAuthProvider());
        assertEquals(providerId, user.getProviderId());
        assertEquals(notifyOrderUpdates, user.getNotifyOrderUpdates());
        assertEquals(notifyFlashSale, user.getNotifyFlashSale());
        assertEquals(notifyNewProducts, user.getNotifyNewProducts());
        assertEquals(notifyWeeklyNewsletter, user.getNotifyWeeklyNewsletter());
        assertTrue(user.getTwoFactorEnabled());
    }

    @Test
    void testTwoFactorEnabledNullReturnsFalse() {
        // Arrange
        user.setTwoFactorEnabled(null);
        // Act & Assert
        assertFalse(user.getTwoFactorEnabled());
    }
}
