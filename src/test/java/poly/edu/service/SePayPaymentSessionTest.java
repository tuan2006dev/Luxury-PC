package poly.edu.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.VietQrPaymentSessionRepository;
import poly.edu.entity.Order;
import poly.edu.entity.VietQrPaymentSession;

import java.time.Instant;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class SePayPaymentSessionTest {

    @Mock
    private VietQrPaymentSessionRepository repository;

    @Mock
    private OrderDAO orderDAO;

    private SePayPaymentSession service;
    private Order order;

    @BeforeEach
    void setUp() {
        service = new SePayPaymentSession(repository, orderDAO);
        order = new Order();
        order.setId(39);
        order.setPaymentMethod("VIETQR");
        order.setStatus("CHO_XAC_NHAN_THANH_TOAN");
        when(orderDAO.findByIdForUpdate(39)).thenReturn(Optional.of(order));
    }

    @Test
    void newlyCreatedQrHasExactlySixHundredSeconds() {
        Instant now = Instant.parse("2026-07-26T12:00:00Z");
        when(repository.findFirstByOrder_IdOrderByQrCreatedAtDescIdDesc(39)).thenReturn(Optional.empty());
        when(repository.save(any(VietQrPaymentSession.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        SePayPaymentSession.PaymentWindow window = service.currentOrCreate(39, now);

        assertTrue(window.created());
        assertEquals(now, window.session().getQrCreatedAt());
        assertEquals(now.plusSeconds(600), window.session().getQrExpiresAt());
        assertEquals(600, SePayPaymentSession.remainingSeconds(window.session(), now));
    }

    @Test
    void reloadKeepsTheExistingExpiration() {
        Instant createdAt = Instant.parse("2026-07-26T12:00:00Z");
        VietQrPaymentSession existing = session(createdAt, createdAt.plusSeconds(600));
        when(repository.findFirstByOrder_IdOrderByQrCreatedAtDescIdDesc(39))
                .thenReturn(Optional.of(existing));

        SePayPaymentSession.PaymentWindow window =
                service.currentOrCreate(39, createdAt.plusSeconds(120));

        assertFalse(window.created());
        assertSame(existing, window.session());
        assertEquals(createdAt.plusSeconds(600), window.session().getQrExpiresAt());
        assertEquals(480, SePayPaymentSession.remainingSeconds(window.session(), createdAt.plusSeconds(120)));
        verify(repository, never()).save(any());
    }

    @Test
    void explicitRenewalCreatesANewSessionWithFreshTimestamps() {
        Instant expiresAt = Instant.parse("2026-07-26T12:10:00Z");
        VietQrPaymentSession expired = session(expiresAt.minusSeconds(600), expiresAt);
        when(repository.findFirstByOrder_IdOrderByQrCreatedAtDescIdDesc(39))
                .thenReturn(Optional.of(expired));
        when(repository.save(any(VietQrPaymentSession.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        SePayPaymentSession.PaymentWindow window = service.renew(39, expiresAt);

        assertTrue(window.created());
        assertEquals(expiresAt, expired.getExpiredAt());
        assertEquals(expiresAt, window.session().getQrCreatedAt());
        assertEquals(expiresAt.plusSeconds(600), window.session().getQrExpiresAt());
        verify(repository).save(expired);
    }

    @Test
    void validityUsesAnExclusiveExpirationBoundary() {
        Instant expiresAt = Instant.parse("2026-07-26T12:10:00Z");
        VietQrPaymentSession session = session(expiresAt.minusSeconds(600), expiresAt);

        assertFalse(SePayPaymentSession.isExpired(session, expiresAt.minusSeconds(1)));
        assertEquals(1, SePayPaymentSession.remainingSeconds(session, expiresAt.minusSeconds(1)));
        assertTrue(SePayPaymentSession.isExpired(session, expiresAt));
        assertEquals(0, SePayPaymentSession.remainingSeconds(session, expiresAt));
    }

    private VietQrPaymentSession session(Instant createdAt, Instant expiresAt) {
        VietQrPaymentSession session = new VietQrPaymentSession();
        session.setOrder(order);
        session.setQrCreatedAt(createdAt);
        session.setQrExpiresAt(expiresAt);
        return session;
    }
}
