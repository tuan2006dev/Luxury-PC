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
