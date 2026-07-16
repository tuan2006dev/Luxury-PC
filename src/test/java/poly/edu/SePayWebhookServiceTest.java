package poly.edu;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.dao.DataIntegrityViolationException;
import poly.edu.config.SePayProperties;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.SePayTransactionRepository;
import poly.edu.entity.Order;
import poly.edu.entity.SePayTransaction;
import poly.edu.service.SePayDuplicateTransactionException;
import poly.edu.service.SePaySignatureVerifier;
import poly.edu.service.SePayWebhookResult;
import poly.edu.service.SePayWebhookService;

import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SePayWebhookServiceTest {

    @Mock
    private SePaySignatureVerifier signatureVerifier;

    @Mock
    private SePayTransactionRepository transactionRepository;

    @Mock
    private OrderDAO orderDAO;

    private SePayProperties properties;
    private SePayWebhookService service;

    @BeforeEach
    void setUp() {
        properties = new SePayProperties();
        properties.getWebhook().setSecret("test-secret");
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
                orderDAO);
    }

    @Test
    void onlyTransactionIdUniqueViolationBecomesDuplicateException() {
        allowNewTransaction();
        SQLException sqlException = new SQLException(
                "duplicate key value violates unique constraint \"uk_sepay_transactions_transaction_id\"",
                "23505");
        when(transactionRepository.saveAndFlush(any(SePayTransaction.class)))
                .thenThrow(new DataIntegrityViolationException("duplicate transaction", sqlException));

        assertThrows(SePayDuplicateTransactionException.class, () -> service.process(
                "signature", "timestamp", validPayload(1001L, "DH1", "DH1", "123456789", "in", 500_000L)));
    }

    @Test
    void nonDuplicateIntegrityViolationIsPropagated() {
        allowNewTransaction();
        DataIntegrityViolationException expected = new DataIntegrityViolationException("not-null schema violation");
        when(transactionRepository.saveAndFlush(any(SePayTransaction.class))).thenThrow(expected);

        DataIntegrityViolationException actual = assertThrows(DataIntegrityViolationException.class,
                () -> service.process("signature", "timestamp",
                        validPayload(1001L, "DH1", "DH1", "123456789", "in", 500_000L)));

        assertSame(expected, actual);
    }

    @Test
    void existingTransactionIdIsIdempotent() {
        when(transactionRepository.existsBySepayTransactionId(1001L)).thenReturn(true);

        SePayWebhookResult result = service.process(
                "signature", "timestamp",
                validPayload(1001L, "DH39", "SEVQR DH39", "123456789", "in", 500_000L));

        assertEquals(SePayWebhookResult.DUPLICATE, result);
        verify(transactionRepository, never()).saveAndFlush(any());
        verify(orderDAO, never()).findByIdForUpdate(any());
    }

    @Test
    void paymentCodeDh39LocksOrder39AndMarksItPaid() {
        Order order = waitingOrder(39, "VIETQR", 500_000D);
        prepareStoredTransaction();
        when(orderDAO.findByIdForUpdate(39)).thenReturn(Optional.of(order));

        SePayWebhookResult result = service.process(
                "signature", "timestamp",
                validPayload(1001L, "DH39", "SEVQR DH39", "123456789", "in", 500_000L));

        ArgumentCaptor<SePayTransaction> transactionCaptor = ArgumentCaptor.forClass(SePayTransaction.class);
        assertEquals(SePayWebhookResult.PROCESSED, result);
        assertEquals("DA_THANH_TOAN", order.getStatus());
        verify(orderDAO).findByIdForUpdate(39);
        verify(orderDAO).save(order);
        verify(transactionRepository).saveAndFlush(transactionCaptor.capture());
        assertEquals("DH39", transactionCaptor.getValue().getPaymentCode());
        assertEquals("Luxury-39", transactionCaptor.getValue().getOrderCode());
        assertEquals("PAID", transactionCaptor.getValue().getProcessingStatus());
    }

    @Test
    void unknownDh999999ReturnsNotFoundWithoutUpdatingOrder() {
        prepareStoredTransaction();
        when(orderDAO.findByIdForUpdate(999_999)).thenReturn(Optional.empty());

        SePayWebhookResult result = service.process(
                "signature", "timestamp",
                validPayload(1002L, "DH999999", "SEVQR DH999999", "123456789", "in", 500_000L));

        assertEquals(SePayWebhookResult.ORDER_NOT_FOUND, result);
        assertStoredStatus("REJECTED_ORDER_NOT_FOUND");
        verify(orderDAO, never()).save(any());
    }

    @Test
    void correctCodeInContentIsAcceptedWhenCodeFieldIsNotUsable() {
        Order order = waitingOrder(39, "VIETQR", 500_000D);
        prepareStoredTransaction();
        when(orderDAO.findByIdForUpdate(39)).thenReturn(Optional.of(order));

        SePayWebhookResult result = service.process(
                "signature", "timestamp",
                validPayload(1003L, "SEPAY", "SEVQR DH39", "123456789", "in", 500_000L));

        assertEquals(SePayWebhookResult.PROCESSED, result);
        assertEquals("DA_THANH_TOAN", order.getStatus());
    }

    @Test
    void conflictingCodesAreRejected() {
        prepareStoredTransaction();

        SePayWebhookResult result = service.process(
                "signature", "timestamp",
                validPayload(1004L, "DH39", "SEVQR DH40", "123456789", "in", 500_000L));

        assertEquals(SePayWebhookResult.BAD_REQUEST, result);
        assertStoredStatus("REJECTED_PAYMENT_CODE");
        verify(orderDAO, never()).findByIdForUpdate(any());
    }

    @Test
    void wrongAmountDoesNotUpdateOrder() {
        Order order = waitingOrder(39, "VIETQR", 500_000D);
        prepareStoredTransaction();
        when(orderDAO.findByIdForUpdate(39)).thenReturn(Optional.of(order));

        SePayWebhookResult result = service.process(
                "signature", "timestamp",
                validPayload(1005L, "DH39", "SEVQR DH39", "123456789", "in", 500_001L));

        assertEquals(SePayWebhookResult.BAD_REQUEST, result);
        assertEquals("CHO_XAC_NHAN_THANH_TOAN", order.getStatus());
        assertStoredStatus("REJECTED_AMOUNT_MISMATCH");
        verify(orderDAO, never()).save(order);
    }

    @Test
    void wrongAccountDoesNotLookUpOrder() {
        prepareStoredTransaction();

        SePayWebhookResult result = service.process(
                "signature", "timestamp",
                validPayload(1006L, "DH39", "SEVQR DH39", "000000000", "in", 500_000L));

        assertEquals(SePayWebhookResult.BAD_REQUEST, result);
        assertStoredStatus("REJECTED_ACCOUNT_MISMATCH");
        verify(orderDAO, never()).findByIdForUpdate(any());
    }

    @Test
    void outgoingTransferIsRejected() {
        prepareStoredTransaction();

        SePayWebhookResult result = service.process(
                "signature", "timestamp",
                validPayload(1007L, "DH39", "SEVQR DH39", "123456789", "out", 500_000L));

        assertEquals(SePayWebhookResult.BAD_REQUEST, result);
        assertStoredStatus("REJECTED_TRANSFER_TYPE");
    }

    @Test
    void codOrderCannotBeConfirmed() {
        Order order = waitingOrder(39, "COD", 500_000D);
        prepareStoredTransaction();
        when(orderDAO.findByIdForUpdate(39)).thenReturn(Optional.of(order));

        SePayWebhookResult result = service.process(
                "signature", "timestamp",
                validPayload(1008L, "DH39", "SEVQR DH39", "123456789", "in", 500_000L));

        assertEquals(SePayWebhookResult.BAD_REQUEST, result);
        assertStoredStatus("REJECTED_PAYMENT_METHOD");
        verify(orderDAO, never()).save(order);
    }

    @Test
    void canceledOrPaidOrderReturnsConflictWithoutSecondPaymentUpdate() {
        Order canceled = waitingOrder(39, "VIETQR", 500_000D);
        canceled.setStatus("DA_HUY");
        prepareStoredTransaction();
        when(orderDAO.findByIdForUpdate(39)).thenReturn(Optional.of(canceled));

        assertEquals(SePayWebhookResult.ORDER_CONFLICT, service.process(
                "signature", "timestamp",
                validPayload(1009L, "DH39", "SEVQR DH39", "123456789", "in", 500_000L)));
        assertStoredStatus("REJECTED_ORDER_STATUS");
        verify(orderDAO, never()).save(canceled);
    }

    @Test
    void malformedJsonAndMissingFieldsAreRejectedBeforeStorage() {
        assertThrows(IllegalArgumentException.class,
                () -> service.process("signature", "timestamp", "{".getBytes(StandardCharsets.UTF_8)));
        assertThrows(IllegalArgumentException.class,
                () -> service.process("signature", "timestamp", "{}".getBytes(StandardCharsets.UTF_8)));

        verify(transactionRepository, never()).saveAndFlush(any());
    }

    private void allowNewTransaction() {
        when(transactionRepository.existsBySepayTransactionId(anyLong())).thenReturn(false);
    }

    private void prepareStoredTransaction() {
        allowNewTransaction();
        when(transactionRepository.saveAndFlush(any(SePayTransaction.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));
    }

    private void assertStoredStatus(String status) {
        ArgumentCaptor<SePayTransaction> captor = ArgumentCaptor.forClass(SePayTransaction.class);
        verify(transactionRepository).saveAndFlush(captor.capture());
        assertEquals(status, captor.getValue().getProcessingStatus());
    }

    private Order waitingOrder(int id, String paymentMethod, double amount) {
        Order order = new Order();
        order.setId(id);
        order.setOrderCode("Luxury-" + id);
        order.setPaymentMethod(paymentMethod);
        order.setStatus("CHO_XAC_NHAN_THANH_TOAN");
        order.setTotalPrice(amount);
        return order;
    }

    private byte[] validPayload(
            long id,
            String code,
            String content,
            String accountNumber,
            String transferType,
            long amount) {
        return ("{"
                + "\"id\":" + id + ","
                + "\"accountNumber\":\"" + accountNumber + "\","
                + "\"transferType\":\"" + transferType + "\","
                + "\"transferAmount\":" + amount + ","
                + "\"code\":\"" + code + "\","
                + "\"content\":\"" + content + "\","
                + "\"description\":\"\""
                + "}").getBytes(StandardCharsets.UTF_8);
    }
}
