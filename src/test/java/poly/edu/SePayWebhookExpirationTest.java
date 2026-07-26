package poly.edu;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import poly.edu.config.SePayProperties;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.SePayTransactionRepository;
import poly.edu.entity.Order;
import poly.edu.entity.SePayTransaction;
import poly.edu.entity.VietQrPaymentSession;
import poly.edu.service.SePayPaymentSession;
import poly.edu.service.SePaySignatureVerifier;
import poly.edu.service.SePayWebhookResult;
import poly.edu.service.SePayWebhookService;

import java.nio.charset.StandardCharsets;
import java.time.Clock;
import java.time.Instant;
import java.time.ZoneOffset;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class SePayWebhookExpirationTest {

    private static final Instant QR_CREATED_AT = Instant.parse("2026-07-26T12:00:00Z");
    private static final Instant QR_EXPIRES_AT = Instant.parse("2026-07-26T12:10:00Z");
    private static final Instant WEBHOOK_RECEIVED_AT = Instant.parse("2026-07-26T12:20:00Z");

    @Mock
    private SePaySignatureVerifier signatureVerifier;

    @Mock
    private SePayTransactionRepository transactionRepository;

    @Mock
    private OrderDAO orderDAO;

    @Mock
    private SePayPaymentSession paymentSessionService;

    private SePayWebhookService service;
    private Order order;
    private VietQrPaymentSession paymentSession;

    @BeforeEach
    void setUp() {
        SePayProperties properties = new SePayProperties();
        properties.getBank().setId("ICB");
        properties.getBank().setDisplayName("VietinBank");
        properties.getBank().setAccountNumber("123456789");
        properties.getBank().setAccountName("TEST ACCOUNT");
        properties.getPaymentCode().setPrefix("DH");
        service = new SePayWebhookService(
                new ObjectMapper(),
                signatureVerifier,
                properties,
                transactionRepository,
                orderDAO,
                paymentSessionService,
                Clock.fixed(WEBHOOK_RECEIVED_AT, ZoneOffset.UTC));

        order = new Order();
        order.setId(39);
        order.setOrderCode("Luxury-39");
        order.setPaymentMethod("VIETQR");
        order.setStatus("CHO_XAC_NHAN_THANH_TOAN");
        order.setTotalPrice(500_000D);

        paymentSession = new VietQrPaymentSession();
        paymentSession.setOrder(order);
        paymentSession.setQrCreatedAt(QR_CREATED_AT);
        paymentSession.setQrExpiresAt(QR_EXPIRES_AT);

        when(transactionRepository.existsBySepayTransactionId(any())).thenReturn(false);
        when(transactionRepository.saveAndFlush(any(SePayTransaction.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));
        when(orderDAO.findByIdForUpdate(39)).thenReturn(Optional.of(order));
    }

    @Test
    void oneSecondBeforeExpirationIsAcceptedEvenWhenWebhookArrivesLate() {
        Instant transactionDate = QR_EXPIRES_AT.minusSeconds(1);
        when(paymentSessionService.findSessionValidAt(39, transactionDate))
                .thenReturn(Optional.of(paymentSession));

        SePayWebhookResult result = service.process(
                "signature", "timestamp", payload(4001L, "2026-07-26 19:09:59"));

        assertEquals(SePayWebhookResult.PROCESSED, result);
        assertEquals("DA_THANH_TOAN", order.getStatus());
        verify(paymentSessionService).markPaid(paymentSession, WEBHOOK_RECEIVED_AT);
        assertStoredTransaction("PAID", transactionDate);
    }

    @Test
    void transactionExactlyAtExpirationIsRejectedAndStoredForReconciliation() {
        when(paymentSessionService.findSessionValidAt(39, QR_EXPIRES_AT))
                .thenReturn(Optional.empty());
        when(paymentSessionService.latest(39)).thenReturn(Optional.of(paymentSession));

        SePayWebhookResult result = service.process(
                "signature", "timestamp", payload(4002L, "2026-07-26 19:10:00"));

        assertEquals(SePayWebhookResult.EXPIRED, result);
        assertEquals("CHO_XAC_NHAN_THANH_TOAN", order.getStatus());
        verify(orderDAO, never()).save(order);
        verify(paymentSessionService).markExpired(paymentSession, WEBHOOK_RECEIVED_AT);
        assertStoredTransaction("REJECTED_QR_EXPIRED", QR_EXPIRES_AT);
    }

    @Test
    void transactionAndWebhookAfterExpirationDoNotConfirmOrder() {
        Instant transactionDate = QR_EXPIRES_AT.plusSeconds(1);
        when(paymentSessionService.findSessionValidAt(39, transactionDate))
                .thenReturn(Optional.empty());
        when(paymentSessionService.latest(39)).thenReturn(Optional.of(paymentSession));

        SePayWebhookResult result = service.process(
                "signature", "timestamp", payload(4003L, "2026-07-26 19:10:01"));

        assertEquals(SePayWebhookResult.EXPIRED, result);
        assertEquals("CHO_XAC_NHAN_THANH_TOAN", order.getStatus());
        assertStoredTransaction("REJECTED_QR_EXPIRED", transactionDate);
    }

    @Test
    void missingTransactionDateFallsBackToWebhookReceivedAtWithReason() {
        when(paymentSessionService.findSessionValidAt(39, WEBHOOK_RECEIVED_AT))
                .thenReturn(Optional.empty());
        when(paymentSessionService.latest(39)).thenReturn(Optional.of(paymentSession));

        SePayWebhookResult result = service.process(
                "signature", "timestamp", payload(4004L, null));

        assertEquals(SePayWebhookResult.EXPIRED, result);
        assertStoredTransaction("REJECTED_QR_EXPIRED_FALLBACK_MISSING_DATE", null);
    }

    @Test
    void invalidTransactionDateFallsBackWithADistinctReconciliationReason() {
        when(paymentSessionService.findSessionValidAt(39, WEBHOOK_RECEIVED_AT))
                .thenReturn(Optional.empty());
        when(paymentSessionService.latest(39)).thenReturn(Optional.of(paymentSession));

        SePayWebhookResult result = service.process(
                "signature", "timestamp", payload(4005L, "not-a-date"));

        assertEquals(SePayWebhookResult.EXPIRED, result);
        assertStoredTransaction("REJECTED_QR_EXPIRED_FALLBACK_INVALID_DATE", null);
    }

    @Test
    void transactionDateIsParsedInHoChiMinhTime() {
        assertEquals(
                Instant.parse("2026-07-26T12:09:59Z"),
                SePayWebhookService.parseTransactionDate("2026-07-26 19:09:59").orElseThrow());
    }

    private void assertStoredTransaction(String processingStatus, Instant transactionDate) {
        ArgumentCaptor<SePayTransaction> captor = ArgumentCaptor.forClass(SePayTransaction.class);
        verify(transactionRepository).saveAndFlush(captor.capture());
        SePayTransaction stored = captor.getValue();
        assertEquals(processingStatus, stored.getProcessingStatus());
        assertEquals(WEBHOOK_RECEIVED_AT, stored.getWebhookReceivedAt());
        if (transactionDate == null) {
            assertNull(stored.getTransactionDate());
        } else {
            assertEquals(transactionDate, stored.getTransactionDate());
        }
    }

    private byte[] payload(long id, String transactionDate) {
        String transactionDateJson =
                transactionDate == null ? "" : "\"transactionDate\":\"" + transactionDate + "\",";
        return ("{"
                + "\"id\":" + id + ","
                + transactionDateJson
                + "\"accountNumber\":\"123456789\","
                + "\"transferType\":\"in\","
                + "\"transferAmount\":500000,"
                + "\"code\":\"DH39\","
                + "\"content\":\"SEVQR DH39\""
                + "}").getBytes(StandardCharsets.UTF_8);
    }
}
