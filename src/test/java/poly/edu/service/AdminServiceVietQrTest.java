package poly.edu.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import poly.edu.dao.InventoryDAO;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.OrderItemDAO;
import poly.edu.dao.ProductDAO;
import poly.edu.dao.StockMovementDAO;
import poly.edu.entity.Order;
import poly.edu.repository.UserRepository;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AdminServiceVietQrTest {

    @Mock
    private OrderDAO orderDAO;
    @Mock
    private OrderItemDAO orderItemDAO;
    @Mock
    private InventoryDAO inventoryDAO;
    @Mock
    private StockMovementDAO stockMovementDAO;
    @Mock
    private UserRepository userRepository;
    @Mock
    private ProductDAO productDAO;
    @Mock
    private VoucherService voucherService;
    @Mock
    private EmailService emailService;

    private AdminService adminService;

    @BeforeEach
    void setUp() {
        adminService = new AdminService(
                orderDAO,
                orderItemDAO,
                inventoryDAO,
                stockMovementDAO,
                voucherService,
                emailService,
                userRepository,
                productDAO);
    }

    @Test
    void genericStatusUpdateCannotBypassWebhook() {
        Order order = order("VIETQR", "PENDING", 39);
        when(orderDAO.findById(39)).thenReturn(Optional.of(order));

        assertThrows(VietQrManualConfirmationException.class,
                () -> adminService.updateOrderStatus(39, "PAID"));

        assertEquals("PENDING", order.getStatus());
        verify(orderDAO, never()).save(order);
    }

    @Test
    void paidVietQrCannotBeSentThroughManualPaymentStatusUpdate() {
        Order order = waitingVietQrOrder();
        order.setStatus("DA_THANH_TOAN");
        when(orderDAO.findById(39)).thenReturn(Optional.of(order));

        assertThrows(VietQrManualConfirmationException.class,
                () -> adminService.updateOrderStatus(39, "PAID"));

        assertEquals("DA_THANH_TOAN", order.getStatus());
        verify(orderDAO, never()).save(order);
    }


    @Test
    void adminCanCancelWaitingVietQrAndStartProcessingAfterPayment() {
        Order waiting = waitingVietQrOrder();
        when(orderDAO.findById(39)).thenReturn(Optional.of(waiting));
        adminService.updateOrderStatus(39, "DA_HUY");
        assertEquals("DA_HUY", waiting.getStatus());
        verify(orderDAO).save(waiting);

        Order paid = waitingVietQrOrder();
        paid.setStatus("DA_THANH_TOAN");
        when(orderDAO.findById(40)).thenReturn(Optional.of(paid));
        adminService.updateOrderStatus(40, "PROCESSING");
        assertEquals("PROCESSING", paid.getStatus());
        verify(orderDAO).save(paid);
    }

    @Test
    void codPendingOrderCanMoveToProcessing() {
        Order order = order("COD", "PENDING", 47);
        when(orderDAO.findById(47)).thenReturn(Optional.of(order));

        adminService.updateOrderStatus(47, "PROCESSING");

        assertEquals("PROCESSING", order.getStatus());
        verify(orderDAO).save(order);
    }

    @Test
    void processingOrderCanMoveToShipping() {
        Order order = order("COD", "PROCESSING", 40);
        when(orderDAO.findById(40)).thenReturn(Optional.of(order));

        adminService.updateOrderStatus(40, "SHIPPING");

        assertEquals("SHIPPING", order.getStatus());
        verify(orderDAO).save(order);
    }

    @Test
    void codShippingOrderCanBeMarkedPaid() {
        Order order = order("COD", "SHIPPING", 41);
        when(orderDAO.findById(41)).thenReturn(Optional.of(order));

        adminService.updateOrderStatus(41, "PAID");

        assertEquals("PAID", order.getStatus());
        verify(orderDAO).save(order);
    }

    @Test
    void codPaidOrderCanBeCompleted() {
        Order order = order("COD", "PAID", 48);
        when(orderDAO.findById(48)).thenReturn(Optional.of(order));

        adminService.updateOrderStatus(48, "COMPLETED");

        assertEquals("COMPLETED", order.getStatus());
        verify(orderDAO).save(order);
    }

    @Test
    void codShippingOrderCannotSkipPayment() {
        Order order = order("COD", "SHIPPING", 49);
        when(orderDAO.findById(49)).thenReturn(Optional.of(order));

        assertThrows(IllegalStateException.class,
                () -> adminService.updateOrderStatus(49, "COMPLETED"));

        assertEquals("SHIPPING", order.getStatus());
        verify(orderDAO, never()).save(order);
    }

    @Test
    void codPendingOrderCannotSkipProcessing() {
        Order order = order("COD", "PENDING", 50);
        when(orderDAO.findById(50)).thenReturn(Optional.of(order));

        assertThrows(IllegalStateException.class,
                () -> adminService.updateOrderStatus(50, "SHIPPING"));

        assertEquals("PENDING", order.getStatus());
        verify(orderDAO, never()).save(order);
    }

    @Test
    void codProcessingOrderCannotSkipShipping() {
        Order order = order("COD", "PROCESSING", 51);
        when(orderDAO.findById(51)).thenReturn(Optional.of(order));

        assertThrows(IllegalStateException.class,
                () -> adminService.updateOrderStatus(51, "PAID"));

        assertEquals("PROCESSING", order.getStatus());
        verify(orderDAO, never()).save(order);
    }

    @Test
    void vietQrShippingOrderCanBeCompleted() {
        Order order = order("VIETQR", "SHIPPING", 42);
        when(orderDAO.findById(42)).thenReturn(Optional.of(order));

        adminService.updateOrderStatus(42, "COMPLETED");

        assertEquals("COMPLETED", order.getStatus());
        verify(orderDAO).save(order);
    }

    @Test
    void vietQrProcessingOrderCanMoveToShipping() {
        Order order = order("VIETQR", "PROCESSING", 52);
        when(orderDAO.findById(52)).thenReturn(Optional.of(order));

        adminService.updateOrderStatus(52, "SHIPPING");

        assertEquals("SHIPPING", order.getStatus());
        verify(orderDAO).save(order);
    }

    @Test
    void canceledOrderCannotBeReopened() {
        Order order = order("COD", "CANCELLED", 43);
        when(orderDAO.findById(43)).thenReturn(Optional.of(order));

        assertThrows(IllegalStateException.class,
                () -> adminService.updateOrderStatus(43, "SHIPPING"));
        assertThrows(IllegalStateException.class,
                () -> adminService.updateOrderStatus(43, "PROCESSING"));
        assertThrows(IllegalStateException.class,
                () -> adminService.updateOrderStatus(43, "COMPLETED"));

        assertEquals("CANCELLED", order.getStatus());
        verify(orderDAO, never()).save(order);
    }

    @Test
    void completedOrderCannotMoveBackward() {
        Order order = order("VIETQR", "COMPLETED", 44);
        when(orderDAO.findById(44)).thenReturn(Optional.of(order));

        assertThrows(IllegalStateException.class,
                () -> adminService.updateOrderStatus(44, "SHIPPING"));
        assertThrows(IllegalStateException.class,
                () -> adminService.updateOrderStatus(44, "PROCESSING"));

        assertEquals("COMPLETED", order.getStatus());
        verify(orderDAO, never()).save(order);
    }

    @Test
    void shippingOrderCannotMoveBackToProcessing() {
        Order order = order("COD", "SHIPPING", 45);
        when(orderDAO.findById(45)).thenReturn(Optional.of(order));

        assertThrows(IllegalStateException.class,
                () -> adminService.updateOrderStatus(45, "PROCESSING"));

        assertEquals("SHIPPING", order.getStatus());
        verify(orderDAO, never()).save(order);
    }

    @Test
    void unpaidVietQrOrderCannotBeMovedToProcessingManually() {
        Order order = order("VIETQR", "PENDING", 46);
        when(orderDAO.findById(46)).thenReturn(Optional.of(order));

        assertThrows(VietQrManualConfirmationException.class,
                () -> adminService.updateOrderStatus(46, "PROCESSING"));

        assertEquals("PENDING", order.getStatus());
        verify(orderDAO, never()).save(order);
    }

    private Order order(String paymentMethod, String status, int id) {
        Order order = new Order();
        order.setId(id);
        order.setPaymentMethod(paymentMethod);
        order.setStatus(status);
        return order;
    }

    private Order waitingVietQrOrder() {
        Order order = new Order();
        order.setId(39);
        order.setPaymentMethod("VIETQR");
        order.setStatus("CHO_XAC_NHAN_THANH_TOAN");
        return order;
    }
}
