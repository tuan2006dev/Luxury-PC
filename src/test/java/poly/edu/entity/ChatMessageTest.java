package poly.edu.entity;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class ChatMessageTest {

    @Test
    void testSettersAndGetters() {
        // Arrange
        ChatMessage entity = new ChatMessage();
        entity.setId(1);
        entity.setTicketId(1);
        entity.setSender("sender_test");
        entity.setSenderName("senderName_test");
        entity.setMessage("message_test");
        entity.setCreatedAt(new java.util.Date());

        // Act & Assert
        assertEquals(1, entity.getId());
        assertEquals(1, entity.getTicketId());
        assertEquals("sender_test", entity.getSender());
        assertEquals("senderName_test", entity.getSenderName());
        assertEquals("message_test", entity.getMessage());
        assertEquals(new java.util.Date(), entity.getCreatedAt());
    }
}
