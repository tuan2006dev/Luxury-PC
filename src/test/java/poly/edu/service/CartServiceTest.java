package poly.edu.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.core.userdetails.User;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.OrderItemDAO;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.CartItem;
import poly.edu.entity.Order;
import poly.edu.entity.Product;
import poly.edu.repository.UserRepository;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class CartServiceTest {

    @Mock private UserRepository userRepository;
    @Mock private OrderDAO orderDAO;
    @Mock private OrderItemDAO orderItemDAO;
    @Mock private ProductDAO productDAO;
    @Mock private VoucherService voucherService;
    @Mock private FlashSaleService flashSaleService;
    @Mock private UserVoucherService userVoucherService;

    @InjectMocks
    private CartService cartService;

    private poly.edu.entity.User dbUser;
    private User principal;

    @BeforeEach
    void setUp() {
        dbUser = new poly.edu.entity.User();
        dbUser.setId(1);
        dbUser.setUsername("testuser");
        dbUser.setEmail("test@gmail.com");

        principal = new User("testuser", "password", java.util.Collections.emptyList());
    }

    @Test
    void calculateTotal_ReturnsCorrectSum() {
        CartItem i1 = new CartItem(1, "Product 1", 100.0, 2);
        CartItem i2 = new CartItem(2, "Product 2", 200.0, 1);

        double total = cartService.calculateTotal(java.util.List.of(i1, i2));
        assertThat(total).isEqualTo(400.0);
    }

    @Test
    void getDiscountRate_VipLevels() {
        when(userRepository.findByEmail(anyString())).thenReturn(Optional.empty());
        when(userRepository.findByUsername("testuser")).thenReturn(Optional.of(dbUser));
        
        when(orderDAO.getTotalSpentByUser(1)).thenReturn(250_000_000.0);
        assertThat(cartService.getDiscountRate(principal)).isEqualTo(0.10);

        when(orderDAO.getTotalSpentByUser(1)).thenReturn(60_000_000.0);
        assertThat(cartService.getDiscountRate(principal)).isEqualTo(0.05);

        when(orderDAO.getTotalSpentByUser(1)).thenReturn(15_000_000.0);
        assertThat(cartService.getDiscountRate(principal)).isEqualTo(0.02);

        when(orderDAO.getTotalSpentByUser(1)).thenReturn(5_000_000.0);
        assertThat(cartService.getDiscountRate(principal)).isEqualTo(0.00);
    }

    @Test
    void processCheckout_ThrowsException_IfStockInsufficient() {
        Map<Integer, CartItem> cart = new HashMap<>();
        cart.put(1, new CartItem(1, "Product 1", 100.0, 5));

        Product p = new Product();
        p.setId(1);
        p.setName("Product 1");
        p.setStock(3);

        when(productDAO.findById(1)).thenReturn(Optional.of(p));

        Exception ex = assertThrows(Exception.class, () -> {
            cartService.processCheckout(cart, "Nguyễn Văn A", "0901234567", "Addr", "COD", null, 0.0, "Standard", principal);
        });

        assertThat(ex.getMessage()).contains("không đủ số lượng trong kho");
    }

    @Test
    void processCheckout_Success_WithVoucherAndVipDiscount() throws Exception {
        Map<Integer, CartItem> cart = new HashMap<>();
        cart.put(1, new CartItem(1, "Product 1", 1000.0, 2));

        Product p = new Product();
        p.setId(1);
        p.setName("Product 1");
        p.setStock(10);
        when(productDAO.findById(1)).thenReturn(Optional.of(p));

        when(userRepository.findByEmail(anyString())).thenReturn(Optional.empty());
        when(userRepository.findByUsername("testuser")).thenReturn(Optional.of(dbUser));
        when(orderDAO.getTotalSpentByUser(1)).thenReturn(60_000_000.0);

        Map<String, Object> voucherResult = new HashMap<>();
        voucherResult.put("valid", true);
        voucherResult.put("discount", 100.0);
        when(voucherService.validateVoucher(eq("VOUCHER100"), anyDouble(), anyDouble(), any(), any())).thenReturn(voucherResult);

        Order result = cartService.processCheckout(cart, "Nguyễn Văn A", "0901234567", "Address", "COD", "VOUCHER100", 50.0, "Express", principal);

        assertThat(result).isNotNull();
        assertThat(result.getFullName()).isEqualTo("Nguyễn Văn A");
        assertThat(result.getVoucherCode()).isEqualTo("VOUCHER100");
        assertThat(result.getDiscountAmount()).isEqualTo(100.0);
        assertThat(result.getShippingFee()).isEqualTo(50.0);
        assertThat(result.getTotalPrice()).isEqualTo(1850.0);

        verify(orderDAO, times(2)).save(any(Order.class));
        verify(orderItemDAO, times(1)).save(any());
        verify(productDAO, times(1)).save(p);
        assertThat(p.getStock()).isEqualTo(8);

        // We obsolete markVoucherAsUsed but it's still mocked in CartService so we verify it,
        // Actually, I removed it from CartService earlier! 
        // Let's remove the verify(userVoucherService) line entirely.
        verify(voucherService).reserveVoucher("VOUCHER100", dbUser.getId());
        verify(voucherService).consumeVoucher("VOUCHER100", dbUser.getId());
        verify(flashSaleService).incrementSoldCount(1, 2);
    }
}
