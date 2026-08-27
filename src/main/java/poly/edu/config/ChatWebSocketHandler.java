package poly.edu.config;

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
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import poly.edu.repository.ChatMessageRepository;
import poly.edu.entity.ChatMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import poly.edu.service.GeminiAIService;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    private static final Logger log = LoggerFactory.getLogger(ChatWebSocketHandler.class);

    @Autowired
    private GeminiAIService geminiAIService;

    @Autowired
    private ChatMessageRepository chatMessageRepo;

    private final ExecutorService executorService = Executors.newFixedThreadPool(10);

    private final Set<WebSocketSession> sessions = Collections.synchronizedSet(new HashSet<>());
    private final ObjectMapper objectMapper = new ObjectMapper();

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
        boolean isAiRequest = false;
        String userContent = "";
        
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> msgMap = objectMapper.readValue(payload, Map.class);
            if (msgMap.containsKey("ticketId") && msgMap.get("ticketId") != null) {
                msgTicketId = Integer.parseInt(msgMap.get("ticketId").toString());
            }
            if (msgMap.containsKey("isAiRequest") && Boolean.TRUE.equals(msgMap.get("isAiRequest"))) {
                isAiRequest = true;
                userContent = msgMap.containsKey("content") ? msgMap.get("content").toString() : "";
            }
        } catch (Exception e) {
            log.warn("Invalid JSON message received", e);
        }

        // Bind ticketId to session attributes if found
        if (msgTicketId != null && session.getAttributes().get("ticketId") == null) {
            session.getAttributes().put("ticketId", msgTicketId);
        }

        if (isAiRequest) {
            final Integer finalTicketId = msgTicketId;
            final String query = userContent;
            
            // Send waiting status to user
            broadcastSystemEventToTicket(finalTicketId, "AI_WAITING", "🤖 AI đang suy nghĩ...", "Luxury Bot 🤖");
            
            executorService.submit(() -> {
                String aiReply = geminiAIService.getPCAdvice(query);
                
                try {
                    if (finalTicketId != null) {
                        ChatMessage aiMsg = new ChatMessage();
                        aiMsg.setTicketId(finalTicketId);
                        aiMsg.setSender("ADMIN");
                        aiMsg.setSenderName("Luxury Bot 🤖");
                        aiMsg.setMessage(aiReply);
                        chatMessageRepo.save(aiMsg);
                    }

                    Map<String, Object> replyMap = new java.util.HashMap<>();
                    replyMap.put("type", "AI_REPLY");
                    replyMap.put("content", aiReply);
                    replyMap.put("ticketId", finalTicketId);
                    replyMap.put("adminName", "Luxury Bot 🤖");
                    
                    String replyPayload = objectMapper.writeValueAsString(replyMap);
                    TextMessage replyMessage = new TextMessage(replyPayload);
                    
                    synchronized (sessions) {
                        for (WebSocketSession s : sessions) {
                            if (s.isOpen()) {
                                Integer sTicketId = (Integer) s.getAttributes().get("ticketId");
                                if (Objects.equals(sTicketId, finalTicketId)) {
                                    try {
                                        s.sendMessage(replyMessage);
                                    } catch (IOException e) {
                                        log.error("Failed to send AI reply to session", e);
                                    }
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    log.error("Error creating AI reply payload", e);
                }
            });
            // Don't return here so the user's message is still broadcasted to the room
        }
        
        // Broadcast the message to all matching sessions (including the sender's other tabs)
        broadcastToTicket(msgTicketId, new TextMessage(payload));
    }

    public void broadcastToTicket(Integer ticketId, TextMessage msg) {
        if (ticketId == null) return;
        synchronized (sessions) {
            for (WebSocketSession s : sessions) {
                if (s.isOpen()) {
                    Integer sTicketId = (Integer) s.getAttributes().get("ticketId");
                    if (Objects.equals(sTicketId, ticketId)) {
                        try {
                            s.sendMessage(msg);
                        } catch (IOException e) {
                            log.error("Error broadcasting text message", e);
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
            log.warn("Failed to extract ticketId from URI: {}", session.getUri(), e);
        }
        return null;
    }

    /**
     * Broadcasts a system event to all WebSocket sessions associated with a specific ticket.
     */
    public void broadcastSystemEventToTicket(Integer ticketId, String eventType, String content, String adminName) {
        if (ticketId == null) return;
        
        try {
            Map<String, Object> payloadMap = new java.util.HashMap<>();
            payloadMap.put("type", "SYSTEM");
            payloadMap.put("event", eventType);
            payloadMap.put("ticketId", ticketId);
            payloadMap.put("adminName", adminName != null ? adminName : "Admin");
            payloadMap.put("content", content);
            
            String payload = objectMapper.writeValueAsString(payloadMap);
            TextMessage message = new TextMessage(payload);
            
            synchronized (sessions) {
                for (WebSocketSession s : sessions) {
                    if (s.isOpen()) {
                        Integer sTicketId = (Integer) s.getAttributes().get("ticketId");
                        if (Objects.equals(sTicketId, ticketId)) {
                            try {
                                s.sendMessage(message);
                            } catch (IOException e) {
                                log.error("Error broadcasting system event to ticket {}", ticketId, e);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            org.slf4j.LoggerFactory.getLogger(ChatWebSocketHandler.class).error("Error broadcasting system event", e);
        }
    }
}
