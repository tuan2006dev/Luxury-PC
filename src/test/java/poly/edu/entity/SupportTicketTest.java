package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class SupportTicketTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        SupportTicket entity = new SupportTicket();
        entity.setId(1);
        entity.setCustomerName("customerName_test");
        entity.setCustomerEmail("customerEmail_test");
        entity.setCustomerPhone("customerPhone_test");
        entity.setSubject("subject_test");
        entity.setMessage("message_test");
        entity.setAdminReply("adminReply_test");
        entity.setAssignedAdmin("assignedAdmin_test");
        entity.setCreatedAt(new java.util.Date());
        entity.setUpdatedAt(new java.util.Date());
        entity.setUser(new User());
        entity.setBuildConfig("buildConfig_test");

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals("customerName_test", entity.getCustomerName());
        assertEquals("customerEmail_test", entity.getCustomerEmail());
        assertEquals("customerPhone_test", entity.getCustomerPhone());
        assertEquals("subject_test", entity.getSubject());
        assertEquals("message_test", entity.getMessage());
        assertEquals("adminReply_test", entity.getAdminReply());
        assertEquals("assignedAdmin_test", entity.getAssignedAdmin());
        assertEquals(new java.util.Date(), entity.getCreatedAt());
        assertEquals(new java.util.Date(), entity.getUpdatedAt());
        assertNotNull(entity.getUser());
        assertEquals("buildConfig_test", entity.getBuildConfig());
    }
}
