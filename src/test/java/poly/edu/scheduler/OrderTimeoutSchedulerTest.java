package poly.edu.scheduler;

import org.junit.jupiter.api.Test;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.Order;
import poly.edu.service.FlashSaleService;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class OrderTimeoutSchedulerTest {

    @Test
    void expiredPendingVietQrOrderIsCanceled() {
        OrderDAO orderDAO = mock(OrderDAO.class);
        Order order = order("VIETQR", "PENDING");
        when(orderDAO.findExpiredPendingOrders(any())).thenReturn(List.of(order));

        scheduler(orderDAO).cancelExpiredPendingOrders();

        assertEquals("CANCELLED", order.getStatus());
        assertEquals("Hệ thống tự động hủy do quá hạn thanh toán", order.getRefundReason());
        verify(orderDAO).save(order);
    }

    @Test
    void expiredPendingCodOrderIsNotCanceledByVietQrTimeout() {
        OrderDAO orderDAO = mock(OrderDAO.class);
        Order order = order("COD", "PENDING");
        when(orderDAO.findExpiredPendingOrders(any())).thenReturn(List.of(order));

        scheduler(orderDAO).cancelExpiredPendingOrders();

        assertEquals("PENDING", order.getStatus());
        assertNull(order.getRefundReason());
        verify(orderDAO, never()).save(any(Order.class));
    }

    @Test
    void expiredPaidVietQrOrderIsNotCanceled() {
        OrderDAO orderDAO = mock(OrderDAO.class);
        Order order = order("VIETQR", "PAID");
        when(orderDAO.findExpiredPendingOrders(any())).thenReturn(List.of(order));

        scheduler(orderDAO).cancelExpiredPendingOrders();

        assertEquals("PAID", order.getStatus());
        assertNull(order.getRefundReason());
        verify(orderDAO, never()).save(any(Order.class));
    }

    @Test
    void processingAndShippingVietQrOrdersAreNotCanceled() {
        OrderDAO orderDAO = mock(OrderDAO.class);
        Order processing = order("VIETQR", "PROCESSING");
        Order shipping = order("VIETQR", "SHIPPING");
        when(orderDAO.findExpiredPendingOrders(any())).thenReturn(List.of(processing, shipping));

        scheduler(orderDAO).cancelExpiredPendingOrders();

        assertEquals("PROCESSING", processing.getStatus());
        assertEquals("SHIPPING", shipping.getStatus());
        verify(orderDAO, never()).save(any(Order.class));
    }

    private OrderTimeoutScheduler scheduler(OrderDAO orderDAO) {
        return new OrderTimeoutScheduler(
                orderDAO,
                mock(ProductDAO.class),
                mock(FlashSaleService.class),
                mock(poly.edu.dao.InventoryDAO.class));
    }

    private Order order(String paymentMethod, String status) {
        Order order = new Order();
        order.setPaymentMethod(paymentMethod);
        order.setStatus(status);
        order.setOrderItems(List.of());
        return order;
    }
}
