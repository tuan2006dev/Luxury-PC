package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class TicketMessageTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        TicketMessage entity = new TicketMessage();
        entity.setId(1);
        entity.setTicket(new Ticket());
        entity.setSender("sender_test");
        entity.setSenderName("senderName_test");
        entity.setMessage("message_test");
        entity.setCreatedAt(new java.util.Date());

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals(new Ticket(), entity.getTicket());
        assertEquals("sender_test", entity.getSender());
        assertEquals("senderName_test", entity.getSenderName());
        assertEquals("message_test", entity.getMessage());
        assertEquals(new java.util.Date(), entity.getCreatedAt());
    }
}
