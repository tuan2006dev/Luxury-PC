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

    private AdminService adminService;

    @BeforeEach
    void setUp() {
        adminService = new AdminService(
                orderDAO,
                orderItemDAO,
                inventoryDAO,
                stockMovementDAO,
                voucherService,
                userRepository,
                productDAO);
    }

    @Test
    void oldManualConfirmationServiceCannotMarkVietQrPaid() {
        Order order = waitingVietQrOrder();
        when(orderDAO.findById(39)).thenReturn(Optional.of(order));

        assertThrows(VietQrManualConfirmationException.class,
                () -> adminService.confirmVietQrPayment(39));

        assertEquals("CHO_XAC_NHAN_THANH_TOAN", order.getStatus());
        verify(orderDAO, never()).save(order);
    }

    @Test
    void genericStatusUpdateCannotBypassWebhook() {
        Order order = waitingVietQrOrder();
        when(orderDAO.findById(39)).thenReturn(Optional.of(order));

        assertThrows(VietQrManualConfirmationException.class,
                () -> adminService.updateOrderStatus(39, "PAID"));

        assertEquals("CHO_XAC_NHAN_THANH_TOAN", order.getStatus());
        verify(orderDAO, never()).save(order);
    }

    @Test
    void adminCanCancelWaitingVietQrAndUpdateDeliveryAfterPayment() {
        Order waiting = waitingVietQrOrder();
        when(orderDAO.findById(39)).thenReturn(Optional.of(waiting));
        adminService.updateOrderStatus(39, "DA_HUY");
        assertEquals("DA_HUY", waiting.getStatus());
        verify(orderDAO).save(waiting);

        Order paid = waitingVietQrOrder();
        paid.setStatus("DA_THANH_TOAN");
        when(orderDAO.findById(40)).thenReturn(Optional.of(paid));
        adminService.updateOrderStatus(40, "SHIPPING");
        assertEquals("SHIPPING", paid.getStatus());
        verify(orderDAO).save(paid);
    }

    private Order waitingVietQrOrder() {
        Order order = new Order();
        order.setId(39);
        order.setPaymentMethod("VIETQR");
        order.setStatus("CHO_XAC_NHAN_THANH_TOAN");
        return order;
    }
}
