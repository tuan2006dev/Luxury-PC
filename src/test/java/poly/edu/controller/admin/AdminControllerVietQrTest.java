package poly.edu.controller.admin;

import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import poly.edu.repository.AdminLogRepository;
import poly.edu.repository.SupportTicketRepository;
import poly.edu.repository.UserRepository;
import poly.edu.service.AdminService;
import poly.edu.service.VietQrManualConfirmationException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.mock;

class AdminControllerVietQrTest {

    @Test
    void manualVietQrStatusConflictReturnsBusinessMessage() {
        AdminController controller = new AdminController(
                mock(AdminService.class),
                mock(SupportTicketRepository.class),
                mock(UserRepository.class),
                mock(AdminLogRepository.class));

        var response = controller.manualConfirmationConflict(
                new VietQrManualConfirmationException());

        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
        assertTrue(response.getBody().contains("SePay"));
        assertTrue(response.getBody().contains("không thể xác nhận thủ công"));
    }
}
