package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class TicketTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        Ticket entity = new Ticket();
        entity.setId(1);
        entity.setCustomerName("customerName_test");
        entity.setCustomerEmail("customerEmail_test");
        entity.setCustomerPhone("customerPhone_test");
        entity.setSubject("subject_test");
        entity.setMessage("message_test");
        entity.setAssignedAdmin("assignedAdmin_test");
        entity.setBuildConfig("buildConfig_test");
        entity.setCreatedAt(new java.util.Date());

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals("customerName_test", entity.getCustomerName());
        assertEquals("customerEmail_test", entity.getCustomerEmail());
        assertEquals("customerPhone_test", entity.getCustomerPhone());
        assertEquals("subject_test", entity.getSubject());
        assertEquals("message_test", entity.getMessage());
        assertEquals("assignedAdmin_test", entity.getAssignedAdmin());
        assertEquals("buildConfig_test", entity.getBuildConfig());
        assertEquals(new java.util.Date(), entity.getCreatedAt());
    }
}
