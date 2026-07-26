package poly.edu.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import poly.edu.repository.AdminLogRepository;
import poly.edu.repository.SupportTicketRepository;
import poly.edu.repository.UserRepository;
import poly.edu.service.AdminService;
import poly.edu.service.VietQrManualConfirmationException;

import java.security.Principal;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;

class AdminControllerVietQrTest {

    @Test
    void manualVietQrConfirmationEndpointReturnsConflictWithBusinessMessage() {
        AdminService adminService = mock(AdminService.class);
        AdminLogRepository adminLogRepository = mock(AdminLogRepository.class);
        Principal principal = mock(Principal.class);
        HttpServletRequest request = mock(HttpServletRequest.class);
        doThrow(new VietQrManualConfirmationException()).when(adminService).confirmVietQrPayment(39);
        AdminController controller = new AdminController(
                adminService,
                mock(SupportTicketRepository.class),
                mock(UserRepository.class),
                adminLogRepository);

        var exception = assertThrows(
                VietQrManualConfirmationException.class,
                () -> controller.confirmVietQrPayment(39, principal, request));
        var response = controller.manualConfirmationConflict(exception);

        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
        assertTrue(response.getBody().contains("SePay webhook"));
    }
}
