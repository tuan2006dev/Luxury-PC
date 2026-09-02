package poly.edu.controller.web;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import poly.edu.entity.SupportTicket;
import poly.edu.entity.ChatMessage;
import poly.edu.entity.AdminLog;
import poly.edu.entity.User;
import poly.edu.repository.SupportTicketRepository;
import poly.edu.repository.UserRepository;
import poly.edu.repository.ChatMessageRepository;
import poly.edu.repository.AdminLogRepository;
import poly.edu.config.ChatWebSocketHandler;

import java.util.*;

@Controller
@RequiredArgsConstructor
public class SupportTicketController {

    private final SupportTicketRepository ticketRepo;

    private final UserRepository userRepo;

    private final ChatMessageRepository chatMessageRepo;

    private final AdminLogRepository adminLogRepository;
    
    private final ChatWebSocketHandler chatWebSocketHandler;

    // ========================
    // CUSTOMER: Get available staffs for chat
    // ========================
    @GetMapping("/api/tickets/staffs")
    @ResponseBody
    public ResponseEntity<List<Map<String, String>>> getStaffs() {
        List<User> staffs = userRepo.findAllEmployees();
        List<Map<String, String>> result = new ArrayList<>();
        for (User u : staffs) {
            Map<String, String> map = new HashMap<>();
            map.put("username", u.getUsername());
            map.put("fullName", u.getFullName() != null ? u.getFullName() : u.getUsername());
            result.add(map);
        }
        return ResponseEntity.ok(result);
    }

    // ========================
    // CUSTOMER: Get active open ticket for user/email/phone
    // ========================
    @GetMapping("/api/tickets/active")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getActiveTicket(
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String phone,
            Authentication auth) {
        SupportTicket activeTicket = null;
        Integer userId = null;
        if (auth != null && auth.isAuthenticated()) {
            User user = userRepo.findByUsername(auth.getName()).orElse(null);
            if (user != null) {
                userId = user.getId();
            }
        }
        
        List<SupportTicket> activeList = ticketRepo.findActiveTickets(
                userId,
                (email != null && !email.isBlank()) ? email.trim() : null,
                (phone != null && !phone.isBlank()) ? phone.trim() : null
        );
        if (!activeList.isEmpty()) {
            activeTicket = activeList.get(0);
        }

        Map<String, Object> res = new HashMap<>();
        if (activeTicket != null) {
            res.put("hasActive", true);
            res.put("ticketId", activeTicket.getId());
            res.put("status", activeTicket.getStatus());
            res.put("subject", activeTicket.getSubject());
            res.put("customerName", activeTicket.getCustomerName());
            res.put("assignedAdmin", activeTicket.getAssignedAdmin());
            res.put("createdAt", activeTicket.getCreatedAt());
            res.put("message", "Bạn đang có cuộc trò chuyện chưa đóng (Ticket #" + activeTicket.getId() + ").");
        } else {
            res.put("hasActive", false);
        }
        return ResponseEntity.ok(res);
    }

    // ========================
    // CUSTOMER: Submit ticket via API (from 3D builder modal / live chat)
    // ========================
    @PostMapping("/api/tickets/submit")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> submitTicket(
            @RequestBody Map<String, String> body,
            Authentication auth) {

        String email = body.getOrDefault("email", "").trim();
        String phone = body.getOrDefault("phone", "").trim();
        String customerName = body.getOrDefault("name", "Khách hàng").trim();
        String messageContent = body.getOrDefault("message", "").trim();
        boolean forceNew = "true".equalsIgnoreCase(body.get("forceNew"));

        // 1. Kiểm tra nếu người dùng đã có Ticket đang mở (OPEN hoặc IN_PROGRESS)
        SupportTicket existingTicket = null;
        User currentUser = null;
        Integer currentUserId = null;
        if (auth != null && auth.isAuthenticated()) {
            currentUser = userRepo.findByUsername(auth.getName()).orElse(null);
            if (currentUser != null) {
                currentUserId = currentUser.getId();
            }
        }

        List<SupportTicket> activeList = ticketRepo.findActiveTickets(
                currentUserId,
                !email.isBlank() ? email : null,
                !phone.isBlank() ? phone : null
        );
        if (!activeList.isEmpty()) {
            existingTicket = activeList.get(0);
        }

        // Nếu đã có ticket đang mở -> Chặn hoàn toàn không cho tạo mới!
        if (existingTicket != null) {
            Map<String, Object> res = new HashMap<>();
            res.put("success", false);
            res.put("code", "ACTIVE_TICKET_EXISTS");
            res.put("hasActive", true);
            res.put("ticketId", existingTicket.getId());
            res.put("status", existingTicket.getStatus());
            res.put("assignedAdmin", existingTicket.getAssignedAdmin());
            res.put("message", "Bạn đang có cuộc trò chuyện chưa đóng (Ticket #" + existingTicket.getId() + "). Không thể tạo ticket mới! Vui lòng đóng ticket hiện tại trước.");
            return ResponseEntity.status(409).body(res);
        }

        // 2. Tạo Ticket mới khi không có ticket nào đang mở
        SupportTicket ticket = new SupportTicket();
        ticket.setCustomerName(customerName);
        ticket.setCustomerEmail(email);
        ticket.setCustomerPhone(phone);
        ticket.setSubject(body.getOrDefault("subject", "Tư vấn linh kiện PC"));
        ticket.setMessage(messageContent);
        ticket.setCategory(body.getOrDefault("category", "GENERAL"));
        ticket.setBuildConfig(body.getOrDefault("buildConfig", null));
        ticket.setStatus("OPEN");

        if (body.containsKey("assignedAdmin") && !body.get("assignedAdmin").trim().isEmpty()) {
            ticket.setAssignedAdmin(body.get("assignedAdmin").trim());
        }

        if (currentUser != null) {
            ticket.setUser(currentUser);
        }

        ticketRepo.save(ticket);

        // Lưu tin nhắn khởi tạo
        if (!messageContent.isEmpty()) {
            ChatMessage firstMsg = new ChatMessage();
            firstMsg.setTicketId(ticket.getId());
            firstMsg.setSender("CUSTOMER");
            firstMsg.setSenderName(ticket.getCustomerName());
            firstMsg.setMessage(messageContent);
            chatMessageRepo.save(firstMsg);
        }

        Map<String, Object> res = new HashMap<>();
        res.put("success", true);
        res.put("hasActive", false);
        res.put("isExisting", false);
        res.put("ticketId", ticket.getId());
        res.put("message", "Ticket #" + ticket.getId() + " đã được ghi nhận! Nhân viên sẽ liên hệ với bạn trong 30 phút.");
        return ResponseEntity.ok(res);
    }

    // ========================
    // CUSTOMER: Assign staff to ticket
    // ========================
    @PostMapping("/api/tickets/{ticketId}/assign")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> assignTicket(
            @PathVariable Integer ticketId,
            @RequestBody Map<String, String> body) {
        
        Map<String, Object> res = new HashMap<>();
        SupportTicket ticket = ticketRepo.findById(ticketId).orElse(null);
        if (ticket == null) {
            res.put("success", false);
            res.put("message", "Ticket not found");
            return ResponseEntity.badRequest().body(res);
        }

        if (body.containsKey("assignedAdmin") && !body.get("assignedAdmin").trim().isEmpty()) {
            ticket.setAssignedAdmin(body.get("assignedAdmin").trim());
            ticketRepo.save(ticket);
            res.put("success", true);
            res.put("message", "Ticket assigned");
        } else {
            res.put("success", false);
            res.put("message", "Missing assignedAdmin");
        }
        return ResponseEntity.ok(res);
    }

    // ========================
    // ADMIN: Check for new OPEN tickets
    // ========================
    @GetMapping("/api/tickets/count/open")
    @ResponseBody
    public ResponseEntity<Map<String, Long>> getOpenTicketCount() {
        long count = ticketRepo.countOpenTickets();
        Map<String, Long> res = new HashMap<>();
        res.put("count", count);
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

    private String getStaffDisplayName(Authentication auth) {
        if (auth == null || !auth.isAuthenticated()) return "Admin";
        String username = auth.getName();
        return userRepo.findByUsername(username)
                .map(u -> (u.getFullName() != null && !u.getFullName().isBlank()) ? u.getFullName() : username)
                .orElse(username);
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
            senderName = getStaffDisplayName(auth);
        }
        msg.setSenderName(senderName);
        msg.setMessage(body.getOrDefault("message", ""));
        chatMessageRepo.save(msg);

        // Update ticket status or assignedAdmin
        ticketRepo.findById(ticketId).ifPresent(ticket -> {
            boolean updated = false;
            
            // Always update the 'updatedAt' field to reflect the latest activity timestamp
            ticket.setUpdatedAt(new java.util.Date());
            updated = true;

            if ("ADMIN".equalsIgnoreCase(sender)) {
                if ("OPEN".equals(ticket.getStatus())) {
                    ticket.setStatus("IN_PROGRESS");
                }
                if (auth != null && ticket.getAssignedAdmin() == null) {
                    ticket.setAssignedAdmin(getStaffDisplayName(auth));
                }
            } else {
                if ("RESOLVED".equals(ticket.getStatus()) || "CLOSED".equals(ticket.getStatus())) {
                    ticket.setStatus("IN_PROGRESS");
                }
            }
            if (updated) {
                ticketRepo.save(ticket);
            }
        });

        // Broadcast via WebSocket ONLY if the message was sent by an Admin.
        // Customer messages are already broadcasted client-side via ws.send() in socket-chat-v2.js.
        if ("ADMIN".equalsIgnoreCase(sender)) {
            try {
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                Map<String, Object> payload = new HashMap<>();
                payload.put("sender", msg.getSender());
                payload.put("senderName", msg.getSenderName());
                payload.put("message", msg.getMessage());
                payload.put("ticketId", msg.getTicketId());
                if (msg.getCreatedAt() != null) {
                    payload.put("createdAt", msg.getCreatedAt().toString());
                }
                org.springframework.web.socket.TextMessage textMsg = new org.springframework.web.socket.TextMessage(mapper.writeValueAsString(payload));
                chatWebSocketHandler.broadcastToTicket(ticketId, textMsg);
            } catch (Exception e) {
                // ignore
            }
        }

        return ResponseEntity.ok(msg);
    }

    // ========================
    // ADMIN: List all tickets page
    // ========================
    @GetMapping("/admin/tickets")
    public String adminTickets(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String priority,
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "page", required = false, defaultValue = "1") Integer page,
            Model model) {

        if (status == null || status.isEmpty()) {
            status = "ALL";
        }

        List<SupportTicket> tickets;
        if ("ACTIVE".equals(status)) {
            tickets = ticketRepo.findTop100ByStatusInOrderByCreatedAtDesc(java.util.Arrays.asList("OPEN", "IN_PROGRESS"));
        } else if ("ALL".equals(status)) {
            tickets = ticketRepo.findTop100ByOrderByCreatedAtDesc();
        } else {
            tickets = ticketRepo.findTop100ByStatusOrderByCreatedAtDesc(status);
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            tickets = tickets.stream()
                    .filter(t -> (t.getId() != null && String.valueOf(t.getId()).contains(kw)) ||
                            (t.getSubject() != null && t.getSubject().toLowerCase().contains(kw)) ||
                            (t.getCustomerName() != null && t.getCustomerName().toLowerCase().contains(kw)) ||
                            (t.getCustomerEmail() != null && t.getCustomerEmail().toLowerCase().contains(kw)) ||
                            (t.getCustomerPhone() != null && t.getCustomerPhone().contains(kw)) ||
                            (t.getMessage() != null && t.getMessage().toLowerCase().contains(kw)))
                    .collect(java.util.stream.Collectors.toList());
        }

        List<SupportTicket> paginatedTickets = poly.edu.util.PaginationUtils.paginate(tickets, page, model);
        model.addAttribute("tickets", paginatedTickets);
        model.addAttribute("filterStatus", status);
        model.addAttribute("keyword", keyword);
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
            String displayName = getStaffDisplayName(auth);
            ticket.setAdminReply(reply);
            ticket.setStatus(status);
            if (auth != null) ticket.setAssignedAdmin(displayName);
            ticketRepo.save(ticket);

            // Also save to chat messages logs
            ChatMessage adminMsg = new ChatMessage();
            adminMsg.setTicketId(ticketId);
            adminMsg.setSender("ADMIN");
            adminMsg.setSenderName(displayName);
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
        String displayName = getStaffDisplayName(auth);
        
        // Prevent race condition: if already assigned to someone else
        if (ticket.getAssignedAdmin() != null && !ticket.getAssignedAdmin().equals(displayName) && !ticket.getAssignedAdmin().equals(auth.getName())) {
            res.put("success", false);
            res.put("message", "Ticket đã được nhân viên khác nhận.");
            return ResponseEntity.status(409).body(res);
        }
        
        // Update ticket
        ticket.setAssignedAdmin(displayName);
        ticket.setStatus("IN_PROGRESS");
        ticketRepo.save(ticket);
        
        // Broadcast WebSocket event
        chatWebSocketHandler.broadcastSystemEventToTicket(
            ticketId, 
            "ADMIN_JOINED", 
            "Nhân viên " + displayName + " đã tham gia cuộc trò chuyện.", 
            displayName
        );

        res.put("success", true);
        res.put("assignedAdmin", displayName);
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
            
            if ("CLOSED".equals(newStatus)) {
                chatWebSocketHandler.broadcastSystemEventToTicket(id, "TICKET_CLOSED", "Cuộc trò chuyện đã được đóng hoàn toàn.", "Hệ thống");
            }
        });
        res.put("success", true);
        return ResponseEntity.ok(res);
    }

    // ========================
    // CUSTOMER: Request / confirm to close ticket
    // ========================
    @PostMapping({"/api/tickets/{ticketId}/close", "/api/tickets/{ticketId}/request-close"})
    @ResponseBody
    public ResponseEntity<Map<String, Object>> requestCloseTicket(@PathVariable Integer ticketId) {
        Map<String, Object> res = new HashMap<>();
        
        ticketRepo.findById(ticketId).ifPresent(ticket -> {
            ticket.setStatus("CLOSED");
            ticket.setUpdatedAt(new java.util.Date());
            ticketRepo.save(ticket);
            
            chatWebSocketHandler.broadcastSystemEventToTicket(
                ticketId,
                "TICKET_CLOSED",
                "Khách hàng đã kết thúc và đóng cuộc trò chuyện.",
                "Hệ thống"
            );
        });
        
        res.put("success", true);
        res.put("ticketId", ticketId);
        res.put("status", "CLOSED");
        res.put("message", "Đã đóng cuộc trò chuyện hỗ trợ thành công.");
        return ResponseEntity.ok(res);
    }

    // ========================
    // ADMIN: Delete ticket (Form Submission)
    // ========================
    @org.springframework.transaction.annotation.Transactional
    @PostMapping("/admin/tickets/delete/{id}")
    public String deleteTicketByPath(
            @PathVariable("id") Integer id,
            Authentication auth,
            HttpServletRequest request) {
            
        chatMessageRepo.deleteAll(chatMessageRepo.findByTicketIdOrderByCreatedAtAsc(id));
        ticketRepo.deleteById(id);
        logAction(auth, request, "Xóa Ticket hỗ trợ", "Ticket #" + id);
        
        // Broadcast to customer so they don't get stuck in a ghost chat
        chatWebSocketHandler.broadcastSystemEventToTicket(id, "TICKET_CLOSED", "Cuộc trò chuyện đã bị xóa bởi quản trị viên.", "Hệ thống");

        return "redirect:/admin/tickets";
    }

    // ========================
    // ADMIN: Delete ticket (API AJAX)
    // ========================
    @org.springframework.transaction.annotation.Transactional
    @PostMapping("/admin/tickets/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteTicket(
            @RequestBody Map<String, Integer> body,
            Authentication auth,
            HttpServletRequest request) {

        Integer id = body.get("id");
        if (id != null) {
            chatMessageRepo.deleteAll(chatMessageRepo.findByTicketIdOrderByCreatedAtAsc(id));
            ticketRepo.deleteById(id);
            logAction(auth, request, "Xóa Ticket hỗ trợ", "Ticket #" + id);
            
            // Broadcast to customer so they don't get stuck in a ghost chat
            chatWebSocketHandler.broadcastSystemEventToTicket(id, "TICKET_CLOSED", "Cuộc trò chuyện đã bị xóa bởi quản trị viên.", "Hệ thống");
        }

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
