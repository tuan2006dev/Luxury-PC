package poly.edu.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import poly.edu.dao.OrderDAO;
import poly.edu.dto.admin.AdminOrderDetailDTO;
import poly.edu.entity.Category;
import poly.edu.entity.Order;
import poly.edu.entity.OrderItem;
import poly.edu.entity.Product;
import poly.edu.entity.User;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class AdminOrderDetailTest {

    @Mock
    private OrderDAO orderDAO;

    @InjectMocks
    private AdminService adminService;

    private Order sampleOrder;

    @BeforeEach
    void setUp() {
        User user = new User();
        user.setId(10);
        user.setUsername("customer1");
        user.setFullName("Nguyen Van A");
        user.setEmail("a@gmail.com");

        Category cat = new Category();
        cat.setId(1);
        cat.setName("VGA");

        Product p1 = new Product();
        p1.setId(101);
        p1.setName("RTX 4090 Rog Strix");
        p1.setImage("rtx4090.jpg");
        p1.setBrand("ASUS");
        p1.setCategory(cat);

        Product p2 = new Product();
        p2.setId(102);
        p2.setName("Intel Core i9-14900K");
        p2.setImage("i9.jpg");
        p2.setBrand("Intel");

        sampleOrder = new Order();
        sampleOrder.setId(1);
        sampleOrder.setOrderCode("DH1001");
        sampleOrder.setUser(user);
        sampleOrder.setFullName("Nguyen Van A");
        sampleOrder.setEmail("a@gmail.com");
        sampleOrder.setPhone("0912345678");
        sampleOrder.setAddress("123 Nguyen Trai");
        sampleOrder.setCity("Ha Noi");
        sampleOrder.setPaymentMethod("VIETQR");
        sampleOrder.setStatus("SHIPPING");
        sampleOrder.setVoucherCode("SALE50K");
        sampleOrder.setDiscountAmount(50000.0);
        sampleOrder.setVipDiscount(20000.0);
        sampleOrder.setShippingFee(30000.0);
        sampleOrder.setShippingMethodName("Hoa Toc");
        sampleOrder.setTrackingCode("LLM_TRACK_999");
        sampleOrder.setTotalPrice(40000000.0);
        sampleOrder.setCreatedAt(new Date());
        sampleOrder.setAdminNote("[Admin] Giao nhanh");

        List<OrderItem> items = new ArrayList<>();
        OrderItem item1 = new OrderItem(1, sampleOrder, p1, 30000000.0, 1);
        OrderItem item2 = new OrderItem(2, sampleOrder, p2, 10000000.0, 1);
        items.add(item1);
        items.add(item2);

        sampleOrder.setOrderItems(items);
    }

    @Test
    void getOrderDetailDTO_ReturnsCorrectData_WhenOrderExists() {
        when(orderDAO.findById(1)).thenReturn(Optional.of(sampleOrder));

        AdminOrderDetailDTO dto = adminService.getOrderDetailDTO(1);

        assertThat(dto).isNotNull();
        assertThat(dto.getId()).isEqualTo(1);
        assertThat(dto.getOrderCode()).isEqualTo("DH1001");
        assertThat(dto.getFullName()).isEqualTo("Nguyen Van A");
        assertThat(dto.getPhone()).isEqualTo("0912345678");
        assertThat(dto.getAddress()).isEqualTo("123 Nguyen Trai");
        assertThat(dto.getCity()).isEqualTo("Ha Noi");
        assertThat(dto.getPaymentMethod()).isEqualTo("VIETQR");
        assertThat(dto.getPaymentMethodDisplay()).isEqualTo("VietQR");
        assertThat(dto.getStatus()).isEqualTo("SHIPPING");
        assertThat(dto.getStatusDisplay()).isEqualTo("Đang giao hàng");
        assertThat(dto.getVoucherCode()).isEqualTo("SALE50K");
        assertThat(dto.getDiscountAmount()).isEqualTo(50000.0);
        assertThat(dto.getVipDiscount()).isEqualTo(20000.0);
        assertThat(dto.getShippingFee()).isEqualTo(30000.0);
        assertThat(dto.getTrackingCode()).isEqualTo("LLM_TRACK_999");
        assertThat(dto.getTotalPrice()).isEqualTo(40000000.0);
        assertThat(dto.getSubtotal()).isEqualTo(40000000.0); // 30M + 10M
        assertThat(dto.getItems()).hasSize(2);
        assertThat(dto.getItems().get(0).getProductName()).isEqualTo("RTX 4090 Rog Strix");
        assertThat(dto.getItems().get(0).getBrand()).isEqualTo("ASUS");
        assertThat(dto.getItems().get(0).getCategoryName()).isEqualTo("VGA");
        assertThat(dto.getItems().get(0).getItemTotal()).isEqualTo(30000000.0);
    }

    @Test
    void getOrderDetailDTO_ReturnsNull_WhenOrderNotFound() {
        when(orderDAO.findById(999)).thenReturn(Optional.empty());

        AdminOrderDetailDTO dto = adminService.getOrderDetailDTO(999);

        assertThat(dto).isNull();
    }
}
