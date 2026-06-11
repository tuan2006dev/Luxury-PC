package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.entity.Ticket;
import poly.edu.repository.TicketMessageRepository;
import poly.edu.repository.TicketRepository;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/admin/tickets")
public class AdminTicketController {

    @Autowired
    private TicketRepository ticketRepository;

    @Autowired
    private TicketMessageRepository ticketMessageRepository;

    @GetMapping("")
    public String listTickets(@RequestParam(value = "status", required = false) String status, Model model) {
        List<Ticket> tickets;
        if (status != null && !status.isEmpty()) {
            tickets = ticketRepository.findByStatusOrderByCreatedAtDesc(status);
        } else {
            tickets = ticketRepository.findAllByOrderByCreatedAtDesc();
        }

        model.addAttribute("tickets", tickets);
        model.addAttribute("openCount", ticketRepository.countByStatus("OPEN"));
        model.addAttribute("inProgressCount", ticketRepository.countByStatus("IN_PROGRESS"));
        model.addAttribute("totalCount", ticketRepository.count());
        model.addAttribute("filterStatus", status);

        return "admin/tickets";
    }

    @PostMapping("/status")
    @ResponseBody
    public Map<String, Object> updateTicketStatus(@RequestBody Map<String, Object> payload) {
        Integer id = Integer.parseInt(payload.get("id").toString());
        String status = payload.get("status").toString();

        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found"));
        ticket.setStatus(status);
        ticketRepository.save(ticket);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        return response;
    }

    @PostMapping("/assign")
    @ResponseBody
    public Map<String, Object> assignTicket(@RequestBody Map<String, Object> payload, java.security.Principal principal) {
        Integer id = Integer.parseInt(payload.get("id").toString());
        Ticket ticket = ticketRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found"));

        String adminName = principal != null ? principal.getName() : "Admin";
        ticket.setAssignedAdmin(adminName);
        if ("OPEN".equals(ticket.getStatus())) {
            ticket.setStatus("IN_PROGRESS");
        }
        ticketRepository.save(ticket);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("assignedAdmin", adminName);
        response.put("status", ticket.getStatus());
        return response;
    }

    @PostMapping("/delete")
    @ResponseBody
    @Transactional
    public Map<String, Object> deleteTicket(@RequestBody Map<String, Object> payload) {
        Integer id = Integer.parseInt(payload.get("id").toString());

        ticketMessageRepository.deleteByTicketId(id);
        ticketRepository.deleteById(id);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        return response;
    }
}
