package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import poly.edu.entity.Ticket;
import poly.edu.entity.TicketMessage;
import poly.edu.repository.TicketMessageRepository;
import poly.edu.repository.TicketRepository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/tickets")
public class TicketApiController {

    @Autowired
    private TicketRepository ticketRepository;

    @Autowired
    private TicketMessageRepository ticketMessageRepository;

    @PostMapping("/submit")
    public Map<String, Object> submitTicket(@RequestBody Map<String, String> payload) {
        Ticket ticket = new Ticket();
        ticket.setCustomerName(payload.get("name"));
        ticket.setCustomerEmail(payload.get("email"));
        ticket.setSubject(payload.get("subject"));
        ticket.setMessage(payload.get("message"));
        
        String category = payload.get("category");
        if (category != null && !category.isEmpty()) {
            ticket.setCategory(category);
        }
        
        String buildConfig = payload.get("buildConfig");
        if (buildConfig != null && !buildConfig.isEmpty()) {
            ticket.setBuildConfig(buildConfig);
        }
        
        ticket.setStatus("OPEN");
        ticketRepository.save(ticket);

        // Add the initial message to the chat history
        TicketMessage initialMessage = new TicketMessage();
        initialMessage.setTicket(ticket);
        initialMessage.setSender("CUSTOMER");
        initialMessage.setSenderName(payload.get("name"));
        initialMessage.setMessage(payload.get("message"));
        ticketMessageRepository.save(initialMessage);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("ticketId", ticket.getId());
        return response;
    }

    @GetMapping("/{id}/messages")
    public List<Map<String, Object>> getMessages(@PathVariable("id") Integer id) {
        List<TicketMessage> messages = ticketMessageRepository.findByTicketIdOrderByCreatedAtAsc(id);
        return messages.stream().map(msg -> {
            Map<String, Object> m = new HashMap<>();
            m.put("sender", msg.getSender());
            m.put("senderName", msg.getSenderName());
            m.put("message", msg.getMessage());
            m.put("createdAt", msg.getCreatedAt());
            return m;
        }).toList();
    }

    @PostMapping("/{id}/messages")
    public Map<String, Object> addMessage(@PathVariable("id") Integer id, @RequestBody Map<String, String> payload) {
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found"));

        TicketMessage msg = new TicketMessage();
        msg.setTicket(ticket);
        msg.setSender(payload.get("sender"));
        msg.setSenderName(payload.get("senderName"));
        msg.setMessage(payload.get("message"));
        ticketMessageRepository.save(msg);

        // Auto transition OPEN to IN_PROGRESS if Admin replies
        if ("ADMIN".equals(msg.getSender()) && "OPEN".equals(ticket.getStatus())) {
            ticket.setStatus("IN_PROGRESS");
            ticketRepository.save(ticket);
        }

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        return response;
    }

    @PostMapping("/{id}/close")
    public Map<String, Object> closeTicket(@PathVariable("id") Integer id) {
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found"));

        ticket.setStatus("CLOSED");
        ticketRepository.save(ticket);

        // Log close action as a system message
        TicketMessage msg = new TicketMessage();
        msg.setTicket(ticket);
        msg.setSender("SYSTEM");
        msg.setSenderName("Hệ thống");
        msg.setMessage("Khách hàng đã kết thúc cuộc trò chuyện.");
        ticketMessageRepository.save(msg);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        return response;
    }
}
