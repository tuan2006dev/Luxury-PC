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
import poly.edu.entity.VietQrPaymentSession;
import poly.edu.service.ProfileService;
import poly.edu.service.SePayPaymentSession;

import java.time.Instant;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
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
        controller = new PaymentController(orderDAO, profileService, properties, paymentSession);

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
        Instant createdAt = Instant.now();
        VietQrPaymentSession qrSession = qrSession(order, createdAt);
        when(orderDAO.findByOrderCode("DH39")).thenReturn(Optional.of(order));
        when(paymentSession.currentOrCreate(eq(39), any(Instant.class)))
                .thenReturn(new SePayPaymentSession.PaymentWindow(qrSession, false));
        when(paymentSession.issueToken(any(), eq("DH39"))).thenReturn("token");
        ExtendedModelMap model = new ExtendedModelMap();

        String view = controller.vietQrPayment(1L, "DH39", false, model, new MockHttpSession());

        assertEquals("payment-vietqr", view);
        assertEquals(500_000L, model.get("amount"));
        assertEquals("SEVQR DH39", model.get("transferContent"));
        assertEquals(createdAt, model.get("qrCreatedAt"));
        assertEquals(createdAt.plusSeconds(600), model.get("expiresAt"));
        assertEquals(
                "https://img.vietqr.io/image/ICB-123456789-compact.png"
                        + "?amount=500000&addInfo=SEVQR+DH39&accountName=TEST+ACCOUNT",
                model.get("qrUrl"));
    }

    @Test
    void reloadUsesTheSamePersistentPaymentSession() {
        Order order = order(owner, "CHO_XAC_NHAN_THANH_TOAN");
        VietQrPaymentSession qrSession = qrSession(order, Instant.now());
        when(orderDAO.findByOrderCode("DH39")).thenReturn(Optional.of(order));
        when(paymentSession.currentOrCreate(eq(39), any(Instant.class)))
                .thenReturn(new SePayPaymentSession.PaymentWindow(qrSession, false));

        controller.vietQrPayment(null, "DH39", false, new ExtendedModelMap(), new MockHttpSession());
        controller.vietQrPayment(null, "DH39", false, new ExtendedModelMap(), new MockHttpSession());

        verify(paymentSession, times(2)).currentOrCreate(eq(39), any(Instant.class));
        verify(paymentSession, never()).renew(eq(39), any(Instant.class));
    }

    @Test
    void explicitRenewalRedirectsToCleanUrlAndRotatesToken() {
        Order order = order(owner, "CHO_XAC_NHAN_THANH_TOAN");
        VietQrPaymentSession qrSession = qrSession(order, Instant.now());
        MockHttpSession session = new MockHttpSession();
        when(orderDAO.findByOrderCode("DH39")).thenReturn(Optional.of(order));
        when(paymentSession.renew(eq(39), any(Instant.class)))
                .thenReturn(new SePayPaymentSession.PaymentWindow(qrSession, true));

        String view = controller.vietQrPayment(null, "DH39", true, new ExtendedModelMap(), session);

        assertEquals("redirect:/payment/vietqr?orderCode=DH39", view);
        verify(paymentSession).replaceToken(session, "DH39");
    }

    @Test
    void paidOrCanceledOrderCannotOpenAReusableQrPage() {
        Order paid = order(owner, "DA_THANH_TOAN");
        when(orderDAO.findByOrderCode("DH39")).thenReturn(Optional.of(paid));
        assertThrows(AccessDeniedException.class,
                () -> controller.vietQrPayment(
                        null, "DH39", false, new ExtendedModelMap(), new MockHttpSession()));

        Order canceled = order(owner, "DA_HUY");
        when(orderDAO.findByOrderCode("DH40")).thenReturn(Optional.of(canceled));
        canceled.setOrderCode("DH40");
        assertThrows(AccessDeniedException.class,
                () -> controller.vietQrPayment(
                        null, "DH40", false, new ExtendedModelMap(), new MockHttpSession()));
    }

    @Test
    void anotherUsersOrderDoesNotLeakQrDetails() {
        User anotherOwner = new User();
        anotherOwner.setId(2);
        when(orderDAO.findByOrderCode("DH39"))
                .thenReturn(Optional.of(order(anotherOwner, "CHO_XAC_NHAN_THANH_TOAN")));

        assertThrows(AccessDeniedException.class,
                () -> controller.vietQrPayment(
                        null, "DH39", false, new ExtendedModelMap(), new MockHttpSession()));
    }

    private VietQrPaymentSession qrSession(Order order, Instant createdAt) {
        VietQrPaymentSession qrSession = new VietQrPaymentSession();
        qrSession.setOrder(order);
        qrSession.setQrCreatedAt(createdAt);
        qrSession.setQrExpiresAt(createdAt.plusSeconds(600));
        return qrSession;
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
