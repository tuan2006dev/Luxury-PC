package poly.edu.controller.web;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import poly.edu.entity.SupportTicket;
import poly.edu.entity.ChatMessage;
import poly.edu.entity.AdminLog;
import poly.edu.repository.SupportTicketRepository;
import poly.edu.repository.UserRepository;
import poly.edu.repository.ChatMessageRepository;
import poly.edu.repository.AdminLogRepository;
import poly.edu.config.ChatWebSocketHandler;

import java.util.*;

@Controller
@SuppressWarnings("null")
@RequiredArgsConstructor
public class SupportTicketController {

    private final SupportTicketRepository ticketRepo;

    private final UserRepository userRepo;

    private final ChatMessageRepository chatMessageRepo;

    private final AdminLogRepository adminLogRepository;
    
    private final ChatWebSocketHandler chatWebSocketHandler;

    // ========================
    // CUSTOMER: Submit ticket via API (from 3D builder modal)
    // ========================
    @PostMapping("/api/tickets/submit")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> submitTicket(
            @RequestBody Map<String, String> body,
            Authentication auth) {

        SupportTicket ticket = new SupportTicket();
        ticket.setCustomerName(body.getOrDefault("name", "Khách hàng"));
        ticket.setCustomerEmail(body.getOrDefault("email", ""));
        ticket.setCustomerPhone(body.getOrDefault("phone", ""));
        ticket.setSubject(body.getOrDefault("subject", "Tư vấn linh kiện PC"));
        ticket.setMessage(body.getOrDefault("message", ""));
        ticket.setCategory(body.getOrDefault("category", "GENERAL"));
        ticket.setBuildConfig(body.getOrDefault("buildConfig", null));
        ticket.setStatus("OPEN");

        // Link to logged-in user if authenticated
        if (auth != null && auth.isAuthenticated()) {
            userRepo.findByUsername(auth.getName()).ifPresent(ticket::setUser);
        }

        ticketRepo.save(ticket);

        // Save initial message in ChatMessage
        if (ticket.getMessage() != null && !ticket.getMessage().trim().isEmpty()) {
            ChatMessage firstMsg = new ChatMessage();
            firstMsg.setTicketId(ticket.getId());
            firstMsg.setSender("CUSTOMER");
            firstMsg.setSenderName(ticket.getCustomerName());
            firstMsg.setMessage(ticket.getMessage());
            chatMessageRepo.save(firstMsg);
        }

        Map<String, Object> res = new HashMap<>();
        res.put("success", true);
        res.put("ticketId", ticket.getId());
        res.put("message", "Ticket #" + ticket.getId() + " đã được ghi nhận! Nhân viên sẽ liên hệ với bạn trong 30 phút.");
        return ResponseEntity.ok(res);
    }

    // ========================
    // CUSTOMER: Track ticket status
    // ========================
    @GetMapping("/api/tickets/track")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> trackTicket(@RequestParam String email) {
        List<SupportTicket> tickets = ticketRepo.findByCustomerEmailOrderByCreatedAtDesc(email);
        Map<String, Object> res = new HashMap<>();
        if (tickets.isEmpty()) {
            res.put("found", false);
        } else {
            res.put("found", true);
            List<Map<String, Object>> list = new ArrayList<>();
            for (SupportTicket t : tickets) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", t.getId());
                m.put("subject", t.getSubject());
                m.put("status", t.getStatus());
                m.put("category", t.getCategory());
                m.put("createdAt", t.getCreatedAt());
                m.put("adminReply", t.getAdminReply());
                m.put("assignedAdmin", t.getAssignedAdmin());
                list.add(m);
            }
            res.put("tickets", list);
        }
        return ResponseEntity.ok(res);
    }

    // ========================
    // CHAT: Get messages for a ticket
    // ========================
    @GetMapping("/api/tickets/{ticketId}/messages")
    @ResponseBody
    public ResponseEntity<List<ChatMessage>> getTicketMessages(@PathVariable Integer ticketId) {
        List<ChatMessage> messages = chatMessageRepo.findByTicketIdOrderByCreatedAtAsc(ticketId);
        return ResponseEntity.ok(messages);
    }

    // ========================
    // CHAT: Send message for a ticket
    // ========================
    @PostMapping("/api/tickets/{ticketId}/messages")
    @ResponseBody
    public ResponseEntity<ChatMessage> sendTicketMessage(
            @PathVariable Integer ticketId,
            @RequestBody Map<String, String> body,
            Authentication auth) {

        ChatMessage msg = new ChatMessage();
        msg.setTicketId(ticketId);
        String sender = body.getOrDefault("sender", "CUSTOMER");
        msg.setSender(sender);
        
        String senderName = body.getOrDefault("senderName", "Khách hàng");
        if (auth != null && auth.isAuthenticated() && "ADMIN".equalsIgnoreCase(sender)) {
            senderName = auth.getName();
        }
        msg.setSenderName(senderName);
        msg.setMessage(body.getOrDefault("message", ""));
        chatMessageRepo.save(msg);

        // Update ticket status or assignedAdmin
        ticketRepo.findById(ticketId).ifPresent(ticket -> {
            boolean updated = false;
            if ("ADMIN".equalsIgnoreCase(sender)) {
                if ("OPEN".equals(ticket.getStatus())) {
                    ticket.setStatus("IN_PROGRESS");
                    updated = true;
                }
                if (auth != null && ticket.getAssignedAdmin() == null) {
                    ticket.setAssignedAdmin(auth.getName());
                    updated = true;
                }
            } else {
                if ("RESOLVED".equals(ticket.getStatus()) || "CLOSED".equals(ticket.getStatus())) {
                    ticket.setStatus("IN_PROGRESS");
                    updated = true;
                }
            }
            if (updated) {
                ticketRepo.save(ticket);
            }
        });

        return ResponseEntity.ok(msg);
    }

    // ========================
    // ADMIN: List all tickets page
    // ========================
    @GetMapping("/admin/tickets")
    public String adminTickets(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String category,
            Model model) {

        List<SupportTicket> tickets;
        if (status != null && !status.isEmpty()) {
            tickets = ticketRepo.findByStatusOrderByCreatedAtDesc(status);
        } else {
            tickets = ticketRepo.findAllByOrderByCreatedAtDesc();
        }

        model.addAttribute("tickets", tickets);
        model.addAttribute("filterStatus", status);
        model.addAttribute("openCount", ticketRepo.countOpenTickets());
        model.addAttribute("inProgressCount", ticketRepo.countInProgressTickets());
        model.addAttribute("totalCount", ticketRepo.count());
        return "admin/tickets";
    }

    // ========================
    // ADMIN: Reply to ticket
    // ========================
    @PostMapping("/admin/tickets/reply")
    public String replyToTicket(
            @RequestParam Integer ticketId,
            @RequestParam String reply,
            @RequestParam String status,
            Authentication auth,
            HttpServletRequest request) {

        ticketRepo.findById(ticketId).ifPresent(ticket -> {
            ticket.setAdminReply(reply);
            ticket.setStatus(status);
            if (auth != null) ticket.setAssignedAdmin(auth.getName());
            ticketRepo.save(ticket);

            // Also save to chat messages logs
            ChatMessage adminMsg = new ChatMessage();
            adminMsg.setTicketId(ticketId);
            adminMsg.setSender("ADMIN");
            adminMsg.setSenderName(auth != null ? auth.getName() : "Admin");
            adminMsg.setMessage(reply);
            chatMessageRepo.save(adminMsg);

            logAction(auth, request, "Phản hồi Ticket (Trạng thái: " + status + ")", "Ticket #" + ticketId);
        });
        return "redirect:/admin/tickets";
    }

    // ========================
    // ADMIN: Assign Ticket to Current Logged-in Admin
    // ========================
    @PostMapping("/admin/tickets/assign")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> assignTicket(
            @RequestBody Map<String, Integer> body,
            Authentication auth) {
        Map<String, Object> res = new HashMap<>();
        if (auth == null) {
            res.put("success", false);
            res.put("message", "Vui lòng đăng nhập.");
            return ResponseEntity.status(401).body(res);
        }

        Integer ticketId = body.get("id");
        if (ticketId == null) {
            res.put("success", false);
            res.put("message", "Ticket ID không hợp lệ.");
            return ResponseEntity.badRequest().body(res);
        }

        Optional<SupportTicket> opt = ticketRepo.findById(ticketId);
        if (opt.isEmpty()) {
            res.put("success", false);
            res.put("message", "Ticket không tồn tại.");
            return ResponseEntity.badRequest().body(res);
        }

        SupportTicket ticket = opt.get();
        
        // Prevent race condition: if already assigned to someone else
        if (ticket.getAssignedAdmin() != null) {
            res.put("success", false);
            res.put("message", "Ticket đã được nhân viên khác nhận.");
            return ResponseEntity.status(409).body(res);
        }
        
        // Update ticket
        ticket.setAssignedAdmin(auth.getName());
        ticket.setStatus("IN_PROGRESS");
        ticketRepo.save(ticket);
        
        // Broadcast WebSocket event
        chatWebSocketHandler.broadcastSystemEventToTicket(
            ticketId, 
            "ADMIN_JOINED", 
            "Nhân viên " + auth.getName() + " đã tham gia cuộc trò chuyện.", 
            auth.getName()
        );

        res.put("success", true);
        res.put("assignedAdmin", auth.getName());
        return ResponseEntity.ok(res);
    }

    // ========================
    // ADMIN: Update status only (AJAX)
    // ========================
    @PostMapping("/admin/tickets/status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateStatus(
            @RequestBody Map<String, String> body,
            Authentication auth,
            HttpServletRequest request) {

        Integer id = Integer.parseInt(body.get("id"));
        String newStatus = body.get("status");

        Map<String, Object> res = new HashMap<>();
        ticketRepo.findById(id).ifPresent(ticket -> {
            ticket.setStatus(newStatus);
            ticketRepo.save(ticket);
            logAction(auth, request, "Cập nhật trạng thái Ticket: " + newStatus, "Ticket #" + id);
        });
        res.put("success", true);
        return ResponseEntity.ok(res);
    }

    // ========================
    // ADMIN: Delete ticket
    // ========================
    @PostMapping("/admin/tickets/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteTicket(
            @RequestBody Map<String, Integer> body,
            Authentication auth,
            HttpServletRequest request) {

        Integer id = body.get("id");
        ticketRepo.deleteById(id);
        logAction(auth, request, "Xóa Ticket hỗ trợ", "Ticket #" + id);

        Map<String, Object> res = new HashMap<>();
        res.put("success", true);
        return ResponseEntity.ok(res);
    }

    private void logAction(Authentication auth, HttpServletRequest request, String action, String targetUser) {
        try {
            String username = auth != null ? auth.getName() : "STAFF";
            String ip = request.getHeader("X-Forwarded-For");
            if (ip == null || ip.isBlank() || "unknown".equalsIgnoreCase(ip)) {
                ip = request.getRemoteAddr();
            }
            adminLogRepository.save(new AdminLog(username, action, ip, targetUser));
        } catch (Exception e) {
            // Ignore logging errors
        }
    }
}
