package poly.edu.controller.admin;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import poly.edu.dto.ApiResponse;
import poly.edu.dto.admin.AdminOrderDetailDTO;
import poly.edu.service.AdminService;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class AdminOrderControllerTest {

    @Mock
    private AdminService adminService;

    @InjectMocks
    private AdminController adminController;

    private AdminOrderDetailDTO sampleDTO;

    @BeforeEach
    void setUp() {
        sampleDTO = AdminOrderDetailDTO.builder()
                .id(1)
                .orderCode("DH101")
                .fullName("Nguyen Van A")
                .totalPrice(1500000.0)
                .status("PENDING")
                .statusDisplay("Chờ xử lý")
                .build();
    }

    @Test
    void getOrderDetail_ReturnsSuccess_WhenOrderExists() {
        when(adminService.getOrderDetailDTO(1)).thenReturn(sampleDTO);

        ResponseEntity<ApiResponse<AdminOrderDetailDTO>> response = adminController.getOrderDetail(1);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isNotNull();
        assertThat(response.getBody().isSuccess()).isTrue();
        assertThat(response.getBody().getData().getOrderCode()).isEqualTo("DH101");
    }

    @Test
    void getOrderDetail_ReturnsNotFound_WhenOrderDoesNotExist() {
        when(adminService.getOrderDetailDTO(99)).thenReturn(null);

        ResponseEntity<ApiResponse<AdminOrderDetailDTO>> response = adminController.getOrderDetail(99);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        assertThat(response.getBody()).isNotNull();
        assertThat(response.getBody().isSuccess()).isFalse();
    }
}
