package poly.edu.entity;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class OrderTest {

    private Order order;

    @BeforeEach
    void setUp() {
        order = new Order();
    }

    @Test
    void testPrePersist() {
        // Arrange is setUp
        // Act
        order.onCreate();

        // Assert
        assertNotNull(order.getCreatedAt());
        assertEquals("PENDING", order.getStatus());
        
        long diff = Math.abs(new Date().getTime() - order.getCreatedAt().getTime());
        assertTrue(diff < 1000);
    }

    @Test
    void testSettersAndGetters() {
        // Arrange
        Integer id = 1;
        User user = new User();
        String fullName = "Test User";
        String email = "test@example.com";
        String phone = "0123456789";
        String address = "123 Street";
        String city = "Hanoi";
        Double totalPrice = 5000.0;
        String orderCode = "ORD123";
        String paymentMethod = "VIETQR";
        String status = "PAID";
        String voucherCode = "VOUCHER10";
        Double discountAmount = 500.0;
        String adminNote = "Note";
        String refundReason = "Reason";
        String refundPreviousStatus = "PAID";
        Date createdAt = new Date();
        List<OrderItem> orderItems = new ArrayList<>();

        // Act
        order.setId(id);
        order.setUser(user);
        order.setFullName(fullName);
        order.setEmail(email);
        order.setPhone(phone);
        order.setAddress(address);
        order.setCity(city);
        order.setTotalPrice(totalPrice);
        order.setOrderCode(orderCode);
        order.setPaymentMethod(paymentMethod);
        order.setStatus(status);
        order.setVoucherCode(voucherCode);
        order.setDiscountAmount(discountAmount);
        order.setAdminNote(adminNote);
        order.setRefundReason(refundReason);
        order.setRefundPreviousStatus(refundPreviousStatus);
        order.setCreatedAt(createdAt);
        order.setOrderItems(orderItems);

        // Assert
        assertEquals(id, order.getId());
        assertEquals(user, order.getUser());
        assertEquals(fullName, order.getFullName());
        assertEquals(email, order.getEmail());
        assertEquals(phone, order.getPhone());
        assertEquals(address, order.getAddress());
        assertEquals(city, order.getCity());
        assertEquals(totalPrice, order.getTotalPrice());
        assertEquals(orderCode, order.getOrderCode());
        assertEquals(paymentMethod, order.getPaymentMethod());
        assertEquals(status, order.getStatus());
        assertEquals(voucherCode, order.getVoucherCode());
        assertEquals(discountAmount, order.getDiscountAmount());
        assertEquals(adminNote, order.getAdminNote());
        assertEquals(refundReason, order.getRefundReason());
        assertEquals(refundPreviousStatus, order.getRefundPreviousStatus());
        assertEquals(createdAt, order.getCreatedAt());
        assertSame(orderItems, order.getOrderItems());
    }

    @Test
    void testGetStatusDisplay() {
        order.setStatus("CHO_XAC_NHAN_THANH_TOAN");
        assertEquals("Chờ xác nhận thanh toán", order.getStatusDisplay());

        order.setStatus("PAID");
        assertEquals("Đã thanh toán", order.getStatusDisplay());

        order.setStatus("UNKNOWN_STATUS");
        assertEquals("UNKNOWN_STATUS", order.getStatusDisplay());
        
        order.setStatus(null);
        assertEquals("Chưa xác định", order.getStatusDisplay());
    }

    @Test
    void testGetPaymentMethodDisplay() {
        order.setPaymentMethod("VIETQR");
        assertEquals("VietQR", order.getPaymentMethodDisplay());

        order.setPaymentMethod("COD");
        assertEquals("Thanh toán khi nhận hàng (COD)", order.getPaymentMethodDisplay());

        order.setPaymentMethod("UNKNOWN_METHOD");
        assertEquals("UNKNOWN_METHOD", order.getPaymentMethodDisplay());
        
        order.setPaymentMethod(null);
        assertEquals("Chưa xác định", order.getPaymentMethodDisplay());
    }

    @Test
    void testGetTransferContent() {
        order.setPaymentMethod("VIETQR");
        order.setOrderCode("ORD123");
        assertEquals("THANH TOAN ORD123", order.getTransferContent());

        order.setPaymentMethod("COD");
        assertNull(order.getTransferContent());

        order.setPaymentMethod("VIETQR");
        order.setOrderCode(null);
        assertNull(order.getTransferContent());
    }

    @Test
    void testIsCustomerRefundEligible() {
        order.setStatus("PAID");
        assertTrue(order.isCustomerRefundEligible());

        order.setStatus("DA_THANH_TOAN");
        assertTrue(order.isCustomerRefundEligible());

        order.setStatus("COMPLETED");
        assertTrue(order.isCustomerRefundEligible());

        order.setStatus("HOAN_THANH");
        assertTrue(order.isCustomerRefundEligible());

        order.setStatus("PENDING");
        assertFalse(order.isCustomerRefundEligible());
    }
}
