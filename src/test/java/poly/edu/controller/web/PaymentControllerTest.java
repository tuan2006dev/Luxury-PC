package poly.edu.controller.web;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.ui.ExtendedModelMap;
import poly.edu.config.SePayProperties;
import poly.edu.dao.OrderDAO;
import poly.edu.entity.Order;
import poly.edu.entity.User;
import poly.edu.service.ProfileService;
import poly.edu.service.SePayPaymentSession;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class PaymentControllerTest {

    @Mock
    private OrderDAO orderDAO;

    @Mock
    private ProfileService profileService;

    @Mock
    private SePayPaymentSession paymentSession;

    @Mock
    private poly.edu.service.OrderService orderService;

    @Mock
    private Authentication authentication;

    private PaymentController controller;
    private User owner;

    @BeforeEach
    void setUp() {
        SePayProperties properties = new SePayProperties();
        properties.getBank().setId("ICB");
        properties.getBank().setDisplayName("VietinBank");
        properties.getBank().setAccountNumber("123456789");
        properties.getBank().setAccountName("TEST ACCOUNT");
        properties.getPaymentCode().setPrefix("DH");
        controller = new PaymentController(orderDAO, profileService, properties, paymentSession, orderService);

        owner = new User();
        owner.setId(1);
        SecurityContextHolder.getContext().setAuthentication(authentication);
        when(profileService.getCurrentUser(authentication)).thenReturn(owner);
    }

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void qrPageUsesPersistedAmountAndExpectedTransferContent() {
        Order order = order(owner, "CHO_XAC_NHAN_THANH_TOAN");
        when(orderDAO.findByOrderCode("DH39")).thenReturn(Optional.of(order));
        when(paymentSession.issueToken(org.mockito.ArgumentMatchers.any(), org.mockito.ArgumentMatchers.eq("DH39")))
                .thenReturn("token");
        ExtendedModelMap model = new ExtendedModelMap();

        String view = controller.vietQrPayment(500_000L, "DH39", model, new MockHttpSession());

        assertEquals("payment-vietqr", view);
        assertEquals(500_000L, model.get("amount"));
        assertEquals("SEVQR DH39", model.get("transferContent"));
        assertEquals(
                "https://img.vietqr.io/image/ICB-123456789-compact.png"
                        + "?amount=500000&addInfo=SEVQR+DH39&accountName=TEST+ACCOUNT",
                model.get("qrUrl"));
    }

    @Test
    void paidOrCanceledOrderCannotOpenAReusableQrPage() {
        Order paid = order(owner, "DA_THANH_TOAN");
        when(orderDAO.findByOrderCode("DH39")).thenReturn(Optional.of(paid));
        assertThrows(AccessDeniedException.class,
                () -> controller.vietQrPayment(null, "DH39", new ExtendedModelMap(), new MockHttpSession()));

        Order canceled = order(owner, "DA_HUY");
        when(orderDAO.findByOrderCode("DH40")).thenReturn(Optional.of(canceled));
        canceled.setOrderCode("DH40");
        assertThrows(AccessDeniedException.class,
                () -> controller.vietQrPayment(null, "DH40", new ExtendedModelMap(), new MockHttpSession()));
    }

    @Test
    void anotherUsersOrderDoesNotLeakQrDetails() {
        User anotherOwner = new User();
        anotherOwner.setId(2);
        when(orderDAO.findByOrderCode("DH39"))
                .thenReturn(Optional.of(order(anotherOwner, "CHO_XAC_NHAN_THANH_TOAN")));

        assertThrows(AccessDeniedException.class,
                () -> controller.vietQrPayment(null, "DH39", new ExtendedModelMap(), new MockHttpSession()));
    }

    private Order order(User user, String status) {
        Order order = new Order();
        order.setId(39);
        order.setUser(user);
        order.setOrderCode("DH39");
        order.setPaymentMethod("VIETQR");
        order.setStatus(status);
        order.setTotalPrice(500_000D);
        return order;
    }
}
