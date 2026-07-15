package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class ShippingAddressTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        ShippingAddress entity = new ShippingAddress();
        entity.setId(1);
        entity.setUser(new User());
        entity.setRecipientName("recipientName_test");
        entity.setPhone("phone_test");
        entity.setAddress("address_test");
        entity.setDistrict("district_test");
        entity.setCity("city_test");
        entity.setDefault(true);

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals(new User(), entity.getUser());
        assertEquals("recipientName_test", entity.getRecipientName());
        assertEquals("phone_test", entity.getPhone());
        assertEquals("address_test", entity.getAddress());
        assertEquals("district_test", entity.getDistrict());
        assertEquals("city_test", entity.getCity());
        assertEquals(true, entity.isDefault());
    }
}
