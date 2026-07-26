package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class UserSessionTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        UserSession entity = new UserSession();
        entity.setId(1);
        entity.setUser(new User());
        entity.setSessionId("sessionId_test");
        entity.setUserAgent("userAgent_test");
        entity.setDeviceInfo("deviceInfo_test");
        entity.setIpAddress("ipAddress_test");
        entity.setLocation("location_test");
        entity.setLoginTime(new java.util.Date());
        entity.setLastActivity(new java.util.Date());

        // Act & Assert
        assertEquals(1, entity.getId());
        assertNotNull(entity.getUser());
        assertEquals("sessionId_test", entity.getSessionId());
        assertEquals("userAgent_test", entity.getUserAgent());
        assertEquals("deviceInfo_test", entity.getDeviceInfo());
        assertEquals("ipAddress_test", entity.getIpAddress());
        assertEquals("location_test", entity.getLocation());
        assertEquals(new java.util.Date(), entity.getLoginTime());
        assertEquals(new java.util.Date(), entity.getLastActivity());
    }
}
