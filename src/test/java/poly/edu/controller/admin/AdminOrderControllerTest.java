package poly.edu.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import poly.edu.dao.InventoryDAO;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.ProductDAO;
import poly.edu.dto.ApiResponse;
import poly.edu.dto.admin.AdminOrderDetailDTO;
import poly.edu.entity.Order;
import poly.edu.entity.User;
import poly.edu.repository.AdminLogRepository;
import poly.edu.repository.SupportTicketRepository;
import poly.edu.repository.UserRepository;
import poly.edu.service.AdminService;
import poly.edu.service.OrderService;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class AdminOrderControllerTest {

    @Mock
    private AdminService adminService;
    @Mock
    private SupportTicketRepository ticketRepo;
    @Mock
    private UserRepository userRepository;
    @Mock
    private AdminLogRepository adminLogRepository;
    @Mock
    private OrderService orderService;
    @Mock
    private OrderDAO orderDAO;
    @Mock
    private ProductDAO productDAO;
    @Mock
    private InventoryDAO inventoryDAO;
    @Mock
    private Model model;
    @Mock
    private HttpServletRequest request;
    @Mock
    private Principal principal;

    @InjectMocks
    private AdminController adminController;

    private AdminOrderDetailDTO sampleDTO;
    private Order sampleOrder;

    @BeforeEach
    void setUp() {
        sampleDTO = AdminOrderDetailDTO.builder()
                .id(101)
                .orderCode("DH101")
                .fullName("Nguyen Van A")
                .totalPrice(1500000.0)
                .status("PENDING")
                .statusDisplay("Chờ xử lý")
                .build();

        sampleOrder = new Order();
        sampleOrder.setId(101);
        sampleOrder.setOrderCode("DH101");
        sampleOrder.setFullName("Nguyen Van A");
        sampleOrder.setPhone("0901234567");
        sampleOrder.setEmail("a@example.com");
        sampleOrder.setStatus("PENDING");
        sampleOrder.setPaymentMethod("VIETQR");
        sampleOrder.setTotalPrice(1500000.0);
    }

    @Test
    void getOrderDetail_ReturnsSuccess_WhenOrderExists() {
        when(adminService.getOrderDetailDTO(101)).thenReturn(sampleDTO);

        ResponseEntity<ApiResponse<AdminOrderDetailDTO>> response = adminController.getOrderDetail(101);

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

    @Test
    void manageOrders_ReturnsOrdersView_WithFilteredListByCodeOrId() {
        List<Order> orders = new ArrayList<>();
        orders.add(sampleOrder);

        Order order2 = new Order();
        order2.setId(102);
        order2.setOrderCode("DH102");
        order2.setFullName("Tran Van B");
        order2.setPhone("0987654321");
        order2.setStatus("DA_THANH_TOAN");
        orders.add(order2);

        when(adminService.getAllOrders()).thenReturn(orders);

        // Tìm kiếm theo "DH101"
        String view = adminController.manageOrders("DH101", 1, model);
        assertThat(view).isEqualTo("admin/orders");
        verify(model).addAttribute(eq("keyword"), eq("DH101"));

        // Tìm kiếm theo số "102"
        view = adminController.manageOrders("102", 1, model);
        assertThat(view).isEqualTo("admin/orders");

        // Tìm kiếm theo tên "Tran Van B"
        view = adminController.manageOrders("Tran Van B", 1, model);
        assertThat(view).isEqualTo("admin/orders");
    }

    @Test
    void updateOrderStatus_RedirectsToOrders_AndCallsService() {
        when(orderDAO.findById(101)).thenReturn(Optional.of(sampleOrder));
        when(principal.getName()).thenReturn("admin");

        String view = adminController.updateOrderStatus(101, "DA_THANH_TOAN", principal, request);

        assertThat(view).isEqualTo("redirect:/admin/orders");
        verify(adminService).updateOrderStatus(101, "DA_THANH_TOAN");
    }

    @Test
    void confirmShipping_RedirectsToOrders_AndCallsOrderService() {
        when(orderService.confirmOrderAndCreateShipping(101)).thenReturn(sampleOrder);
        when(principal.getName()).thenReturn("admin");

        String view = adminController.confirmShipping(101, principal, request);

        assertThat(view).isEqualTo("redirect:/admin/orders");
        verify(orderService).confirmOrderAndCreateShipping(101);
    }

    @Test
    void refundActions_RedirectToOrders_AndCallAdminService() {
        when(orderDAO.findById(101)).thenReturn(Optional.of(sampleOrder));
        when(principal.getName()).thenReturn("admin");

        // Yêu cầu hoàn tiền
        String view = adminController.requestRefund(101, "Lý do", principal, request);
        assertThat(view).isEqualTo("redirect:/admin/orders");
        verify(adminService).requestRefund(eq(101), any());

        // Duyệt hoàn tiền
        view = adminController.approveRefund(101, "Duyệt", principal, request);
        assertThat(view).isEqualTo("redirect:/admin/orders");
        verify(adminService).approveCustomerRefund(eq(101), any());

        // Từ chối hoàn tiền
        view = adminController.rejectRefund(101, "Từ chối", principal, request);
        assertThat(view).isEqualTo("redirect:/admin/orders");
        verify(adminService).rejectCustomerRefund(eq(101), any());

        // Xác nhận hoàn tiền
        view = adminController.confirmRefund(101, "Đã chuyển khoản", principal, request);
        assertThat(view).isEqualTo("redirect:/admin/orders");
        verify(adminService).confirmRefund(eq(101), any());

        // Thu hồi đơn hàng
        view = adminController.recallOrder(101, "Thu hồi", principal, request);
        assertThat(view).isEqualTo("redirect:/admin/orders");
        verify(adminService).recallOrder(eq(101), any());
    }
}
