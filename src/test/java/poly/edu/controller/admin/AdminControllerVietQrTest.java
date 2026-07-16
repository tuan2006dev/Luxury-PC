package poly.edu.controller.admin;

import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import poly.edu.repository.SupportTicketRepository;
import poly.edu.repository.UserRepository;
import poly.edu.service.AdminService;
import poly.edu.service.VietQrManualConfirmationException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;

class AdminControllerVietQrTest {

    @Test
    void manualVietQrConfirmationEndpointReturnsConflictWithBusinessMessage() {
        AdminService adminService = mock(AdminService.class);
        doThrow(new VietQrManualConfirmationException()).when(adminService).confirmVietQrPayment(39);
        AdminController controller = new AdminController(
                adminService,
                mock(SupportTicketRepository.class),
                mock(UserRepository.class));

        var response = controller.confirmVietQrPayment(39);

        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
        assertTrue(response.getBody().contains("SePay webhook"));
    }
}
