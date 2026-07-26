package poly.edu.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import poly.edu.dao.*;
import poly.edu.entity.*;
import poly.edu.exception.OutOfStockException;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class OrderServiceTest {

    @Mock private ProductDAO productDAO;
    @Mock private InventoryDAO inventoryDAO;
    @Mock private OrderDAO orderDAO;
    @Mock private OrderItemDAO orderItemDAO;
    @Mock private StockMovementDAO stockMovementDAO;
    @Mock private FlashSaleService flashSaleService;
    @Mock private UserVoucherService userVoucherService;

    @InjectMocks
    private OrderService orderService;

    private User currentUser;
    private Product product;
    private CartItem cartItem;
    private Map<Integer, CartItem> cart;

    @BeforeEach
    void setUp() {
        currentUser = new User();
        currentUser.setId(1);
        currentUser.setEmail("test@gmail.com");

        product = new Product();
        product.setId(10);
        product.setName("RTX 4090");
        product.setStock(5);

        cartItem = new CartItem(10, "RTX 4090", 1000.0, 2);
        cart = new HashMap<>();
        cart.put(10, cartItem);
    }

    @Test
    void placeOrder_ThrowsException_IfProductNotFound() {
        when(productDAO.findByIdForUpdate(10)).thenReturn(Optional.empty());

        OutOfStockException ex = assertThrows(OutOfStockException.class, () -> {
            orderService.placeOrder(cart, "Name", "Phone", "Addr", currentUser, 2000.0, 0, null);
        });

        assertThat(ex.getMessage()).contains("không tồn tại");
    }

    @Test
    void placeOrder_ThrowsException_IfStockNotEnough() {
        product.setStock(1); 
        when(productDAO.findByIdForUpdate(10)).thenReturn(Optional.of(product));

        OutOfStockException ex = assertThrows(OutOfStockException.class, () -> {
            orderService.placeOrder(cart, "Name", "Phone", "Addr", currentUser, 2000.0, 0, null);
        });

        assertThat(ex.getMessage()).contains("chỉ còn 1 chiếc trong kho");
    }

    @Test
    void placeOrder_Success_WithInventorySyncAndStockMovement() {
        when(productDAO.findByIdForUpdate(10)).thenReturn(Optional.of(product));
        
        Order savedOrder = new Order();
        savedOrder.setId(99);
        when(orderDAO.save(any(Order.class))).thenReturn(savedOrder);

        Inventory inv = new Inventory();
        inv.setQuantity(5);
        when(inventoryDAO.findByProductId(10)).thenReturn(Optional.of(inv));

        Order result = orderService.placeOrder(cart, "Test Name", "012345", "Addr", currentUser, 2000.0, 100.0, "VCODE");

        assertThat(result).isNotNull();
        assertThat(product.getStock()).isEqualTo(3); 
        verify(productDAO, times(1)).save(product);

        assertThat(inv.getQuantity()).isEqualTo(3);
        verify(inventoryDAO, times(1)).save(inv);

        verify(stockMovementDAO, times(1)).save(argThat(m -> 
            m.getMovementType().equals("EXPORT") && 
            m.getChangeQuantity() == 2 &&
            m.getProduct().getId() == 10
        ));

        verify(orderItemDAO, times(1)).save(any(OrderItem.class));
        verify(flashSaleService, times(1)).incrementSoldCount(10, 2);
        verify(userVoucherService, times(1)).markVoucherAsUsed(currentUser, "VCODE");
    }
}
