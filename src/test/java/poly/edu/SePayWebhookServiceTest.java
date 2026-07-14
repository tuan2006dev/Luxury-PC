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
import poly.edu.service.SePayWebhookService;

import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
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
        when(transactionRepository.existsBySepayTransactionId(anyLong())).thenReturn(false);
    }

    @Test
    void onlyTransactionIdUniqueViolationBecomesDuplicateException() {
        SQLException sqlException = new SQLException(
                "duplicate key value violates unique constraint \"uk_sepay_transactions_transaction_id\"",
                "23505");
        when(transactionRepository.saveAndFlush(any(SePayTransaction.class)))
                .thenThrow(new DataIntegrityViolationException("duplicate transaction", sqlException));

        assertThrows(SePayDuplicateTransactionException.class, () -> service.process(
                "signature", "timestamp", validPayload()));
    }

    @Test
    void nonDuplicateIntegrityViolationIsPropagated() {
        DataIntegrityViolationException expected = new DataIntegrityViolationException("not-null schema violation");
        when(transactionRepository.saveAndFlush(any(SePayTransaction.class))).thenThrow(expected);

        DataIntegrityViolationException actual = assertThrows(DataIntegrityViolationException.class,
                () -> service.process("signature", "timestamp", validPayload()));

        assertSame(expected, actual);
    }

    @Test
    void paymentCodeResolvesAndLocksOrderById() {
        Order order = new Order();
        order.setId(39);
        order.setOrderCode("Luxury-39");
        order.setPaymentMethod("VIETQR");
        order.setStatus("CHO_XAC_NHAN_THANH_TOAN");
        order.setTotalPrice(500_000D);
        when(orderDAO.findByIdForUpdate(39)).thenReturn(Optional.of(order));
        when(transactionRepository.saveAndFlush(any(SePayTransaction.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        service.process("signature", "timestamp", validPayload("DH39"));

        ArgumentCaptor<SePayTransaction> transactionCaptor = ArgumentCaptor.forClass(SePayTransaction.class);
        verify(orderDAO).findByIdForUpdate(39);
        verify(orderDAO).save(order);
        verify(transactionRepository).saveAndFlush(transactionCaptor.capture());
        assertEquals("DH39", transactionCaptor.getValue().getPaymentCode());
        assertEquals("Luxury-39", transactionCaptor.getValue().getOrderCode());
        assertEquals("PAID", transactionCaptor.getValue().getProcessingStatus());
    }

    @Test
    void unknownPaymentCodeIsRejectedAsOrderNotFound() {
        when(orderDAO.findByIdForUpdate(999_999)).thenReturn(Optional.empty());
        when(transactionRepository.saveAndFlush(any(SePayTransaction.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        service.process("signature", "timestamp", validPayload("DH999999"));

        ArgumentCaptor<SePayTransaction> transactionCaptor = ArgumentCaptor.forClass(SePayTransaction.class);
        verify(orderDAO).findByIdForUpdate(999_999);
        verify(transactionRepository).saveAndFlush(transactionCaptor.capture());
        assertEquals("DH999999", transactionCaptor.getValue().getPaymentCode());
        assertEquals("REJECTED_ORDER_NOT_FOUND", transactionCaptor.getValue().getProcessingStatus());
    }

    private byte[] validPayload() {
        return validPayload("DH1");
    }

    private byte[] validPayload(String paymentCode) {
        return ("{\"id\":1001,\"accountNumber\":\"" + properties.getBank().getAccountNumber() + "\",\"transferType\":\"in\","
                + "\"transferAmount\":500000,\"code\":\"" + paymentCode + "\",\"content\":\"" + paymentCode + "\",\"description\":\"\"}")
                .getBytes(StandardCharsets.UTF_8);
    }
}
