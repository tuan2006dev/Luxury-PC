package poly.edu.controller.api;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.core.Authentication;
import poly.edu.dao.OrderDAO;
import poly.edu.entity.Order;
import poly.edu.entity.User;
import poly.edu.entity.VietQrPaymentSession;
import poly.edu.service.ProfileService;
import poly.edu.service.SePayPaymentSession;

import java.time.Instant;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class VietQrPaymentStatusControllerTest {

    @Mock
    private OrderDAO orderDAO;

    @Mock
    private SePayPaymentSession paymentSession;

    @Mock
    private ProfileService profileService;

    @Mock
    private Authentication authentication;

    private VietQrPaymentStatusController controller;
    private MockHttpSession session;

    @BeforeEach
    void setUp() {
        controller = new VietQrPaymentStatusController(orderDAO, paymentSession, profileService);
        session = new MockHttpSession();
    }

    @Test
    void pollingReturnsPaidOnlyForOrderOwnerWithValidToken() {
        User owner = user(1);
        Order order = order(owner, "DA_THANH_TOAN");
        VietQrPaymentSession qrSession = qrSession(order, Instant.now().minusSeconds(60), Instant.now().plusSeconds(540));
        qrSession.setPaidAt(Instant.now());
        when(paymentSession.matches(session, "DH39", "valid-token")).thenReturn(true);
        when(orderDAO.findByOrderCode("DH39")).thenReturn(Optional.of(order));
        when(profileService.getCurrentUser(authentication)).thenReturn(owner);
        when(paymentSession.current(eq(39), any(Instant.class))).thenReturn(Optional.of(qrSession));

        var response = controller.status("DH39", "valid-token", session, authentication);

        assertEquals("DH39", response.orderCode());
        assertEquals("DA_THANH_TOAN", response.status());
        assertTrue(response.paid());
        assertFalse(response.expired());
    }

    @Test
    void pollingReturnsExpiredAtTheServerBoundary() {
        User owner = user(1);
        Order order = order(owner, "CHO_XAC_NHAN_THANH_TOAN");
        Instant expiresAt = Instant.now().minusMillis(1);
        VietQrPaymentSession qrSession = qrSession(order, expiresAt.minusSeconds(600), expiresAt);
        when(paymentSession.matches(session, "DH39", "valid-token")).thenReturn(true);
        when(orderDAO.findByOrderCode("DH39")).thenReturn(Optional.of(order));
        when(profileService.getCurrentUser(authentication)).thenReturn(owner);
        when(paymentSession.current(eq(39), any(Instant.class))).thenReturn(Optional.of(qrSession));

        var response = controller.status("DH39", "valid-token", session, authentication);

        assertTrue(response.expired());
        assertEquals(0, response.remainingSeconds());
        assertEquals(expiresAt, response.expiresAt());
    }

    @Test
    void invalidPollingTokenIsRejectedBeforeOrderLookup() {
        when(paymentSession.matches(session, "DH39", "invalid-token")).thenReturn(false);

        assertThrows(VietQrPaymentStatusController.PaymentStatusForbiddenException.class,
                () -> controller.status("DH39", "invalid-token", session, authentication));

        verify(orderDAO, never()).findByOrderCode("DH39");
    }

    @Test
    void validTokenCannotPollAnotherUsersOrder() {
        User owner = user(1);
        User otherUser = user(2);
        Order order = order(owner, "CHO_XAC_NHAN_THANH_TOAN");
        when(paymentSession.matches(session, "DH39", "valid-token")).thenReturn(true);
        when(orderDAO.findByOrderCode("DH39")).thenReturn(Optional.of(order));
        when(profileService.getCurrentUser(authentication)).thenReturn(otherUser);

        assertThrows(VietQrPaymentStatusController.PaymentStatusForbiddenException.class,
                () -> controller.status("DH39", "valid-token", session, authentication));
    }

    private User user(int id) {
        User user = new User();
        user.setId(id);
        return user;
    }

    private Order order(User owner, String status) {
        Order order = new Order();
        order.setId(39);
        order.setUser(owner);
        order.setOrderCode("DH39");
        order.setPaymentMethod("VIETQR");
        order.setStatus(status);
        return order;
    }

    private VietQrPaymentSession qrSession(Order order, Instant createdAt, Instant expiresAt) {
        VietQrPaymentSession session = new VietQrPaymentSession();
        session.setOrder(order);
        session.setQrCreatedAt(createdAt);
        session.setQrExpiresAt(expiresAt);
        return session;
    }
}
