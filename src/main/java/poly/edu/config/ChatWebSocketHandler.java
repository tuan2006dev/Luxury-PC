package poly.edu.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    private final Set<WebSocketSession> sessions = Collections.synchronizedSet(new HashSet<>());
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    private ApplicationContext applicationContext;

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session);
        
        // Extract ticketId from query parameters (e.g. ws://.../chat-socket?ticketId=12)
        Integer ticketId = getTicketIdFromSession(session);
        if (ticketId != null) {
            session.getAttributes().put("ticketId", ticketId);
        }
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        
        Integer msgTicketId = null;
        String sender = "CUSTOMER";
        String senderName = "Khách hàng";
        String content = "";
        
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> msgMap = objectMapper.readValue(payload, Map.class);
            if (msgMap.containsKey("ticketId") && msgMap.get("ticketId") != null) {
                msgTicketId = Integer.parseInt(msgMap.get("ticketId").toString());
            }
            if (msgMap.containsKey("sender") && msgMap.get("sender") != null) {
                sender = msgMap.get("sender").toString();
            }
            if (msgMap.containsKey("senderName") && msgMap.get("senderName") != null) {
                senderName = msgMap.get("senderName").toString();
            }
            if (msgMap.containsKey("content") && msgMap.get("content") != null) {
                content = msgMap.get("content").toString();
            }
        } catch (Exception e) {
            // Not a JSON message, treat raw payload as content
            content = payload;
        }

        // Bind ticketId to session attributes if found
        if (msgTicketId != null && session.getAttributes().get("ticketId") == null) {
            session.getAttributes().put("ticketId", msgTicketId);
        }
        
        // Broadcast the message to all matching sessions (including the sender's other tabs)
        synchronized (sessions) {
            for (WebSocketSession s : sessions) {
                if (s.isOpen()) {
                    Integer sTicketId = (Integer) s.getAttributes().get("ticketId");
                    
                    // If ticketId is present, send only to matching ticketId sessions.
                    // If ticketId is null, send only to other general chat sessions.
                    if (Objects.equals(sTicketId, msgTicketId)) {
                        try {
                            s.sendMessage(new TextMessage(payload));
                        } catch (IOException e) {
                            // ignore send errors
                        }
                    }
                }
            }
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        sessions.remove(session);
    }

    /**
     * Extracts ticketId from connection URL query parameter
     */
    private Integer getTicketIdFromSession(WebSocketSession session) {
        try {
            String query = session.getUri().getQuery();
            if (query != null && query.contains("ticketId=")) {
                String[] params = query.split("&");
                for (String param : params) {
                    if (param.startsWith("ticketId=")) {
                        return Integer.parseInt(param.split("=")[1]);
                    }
                }
            }
        } catch (Exception e) {
            // ignore
        }
        return null;
    }
}
