package poly.edu.service;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import poly.edu.entity.SupportTicket;
import poly.edu.repository.ChatMessageRepository;
import poly.edu.repository.SupportTicketRepository;

@Service
@RequiredArgsConstructor
@Slf4j
public class TicketCleanupService {

    private final SupportTicketRepository ticketRepo;
    private final ChatMessageRepository chatMessageRepo;
    private final poly.edu.config.ChatWebSocketHandler chatWebSocketHandler;
    
    // Set to 1 minute for testing purposes as requested. Change to 15 later.
    private static final int IDLE_TIMEOUT_MINUTES = 1;

    /**
     * Runs every minute to auto-close open or in-progress tickets that have been idle.
     */
    @Scheduled(fixedRate = 60000)
    @Transactional
    public void cleanupIdleTickets() {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.add(java.util.Calendar.MINUTE, -IDLE_TIMEOUT_MINUTES);
        java.util.Date cutoffDate = cal.getTime();

        List<SupportTicket> idleTickets = ticketRepo.findByStatusInAndUpdatedAtBefore(
                Arrays.asList("OPEN", "IN_PROGRESS"), cutoffDate);

        if (!idleTickets.isEmpty()) {
            log.info("Found {} idle tickets older than {} minutes. Auto-closing...", idleTickets.size(), IDLE_TIMEOUT_MINUTES);
            
            for (SupportTicket ticket : idleTickets) {
                ticket.setStatus("CLOSED");
                ticket.setAdminReply("Hệ thống tự động đóng do ngưng hoạt động.");
                ticketRepo.save(ticket);

                // Broadcast closed event to UI so frontend can update
                chatWebSocketHandler.broadcastSystemEventToTicket(
                        ticket.getId(), 
                        "TICKET_CLOSED", 
                        "Phiên hỗ trợ đã tự động kết thúc do ngưng hoạt động quá " + IDLE_TIMEOUT_MINUTES + " phút.", 
                        "Hệ thống"
                );
                
                log.info("Auto-closed ticket #{}", ticket.getId());
            }
        }
    }

    /**
     * Runs every day at 3:00 AM to clean up closed and resolved tickets
     * that are older than 14 days.
     */
    @Scheduled(cron = "0 0 3 * * ?")
    @Transactional
    public void cleanupOldTickets() {
        LocalDateTime cutoffDate = LocalDateTime.now().minusDays(14);
        List<String> statuses = Arrays.asList("CLOSED", "RESOLVED");

        List<SupportTicket> oldTickets = ticketRepo.findByStatusInAndCreatedAtBefore(statuses, cutoffDate);
        
        if (!oldTickets.isEmpty()) {
            log.info("Starting cleanup of {} old tickets (older than {}).", oldTickets.size(), cutoffDate);
            
            for (SupportTicket ticket : oldTickets) {
                // Delete all associated chat messages first to avoid orphan records
                chatMessageRepo.deleteAll(chatMessageRepo.findByTicketIdOrderByCreatedAtAsc(ticket.getId()));
                
                // Delete the ticket itself
                ticketRepo.delete(ticket);
                log.debug("Deleted ticket #{}", ticket.getId());
            }
            
            log.info("Successfully cleaned up {} old tickets.", oldTickets.size());
        } else {
            log.debug("No old tickets found for cleanup.");
        }
    }
}
