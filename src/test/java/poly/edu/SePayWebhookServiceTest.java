package poly.edu;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.dao.DataIntegrityViolationException;
import poly.edu.config.SePayProperties;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.SePayTransactionRepository;
import poly.edu.entity.SePayTransaction;
import poly.edu.service.SePayDuplicateTransactionException;
import poly.edu.service.SePaySignatureVerifier;
import poly.edu.service.SePayWebhookService;

import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
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

    private byte[] validPayload() {
        return ("{\"id\":1001,\"accountNumber\":\"" + properties.getBank().getAccountNumber() + "\",\"transferType\":\"in\","
                + "\"transferAmount\":500000,\"code\":\"DH1\",\"content\":\"DH1\",\"description\":\"\"}")
                .getBytes(StandardCharsets.UTF_8);
    }
}
