package poly.edu;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import poly.edu.config.SePayProperties;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.SePayTransactionRepository;
import poly.edu.entity.Order;
import poly.edu.entity.SePayTransaction;
import poly.edu.service.SePayPaymentSession;
import poly.edu.service.SePaySignatureVerifier;
import poly.edu.service.SePayWebhookResult;
import poly.edu.service.SePayWebhookService;

import java.nio.charset.StandardCharsets;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class SePayWebhookAmountValidationTest {

    @ParameterizedTest
    @ValueSource(longs = {499_999L, 500_001L})
    void bothUnderpaymentAndOverpaymentAreRejected(long transferAmount) {
        SePayProperties properties = new SePayProperties();
        properties.getBank().setId("ICB");
        properties.getBank().setDisplayName("VietinBank");
        properties.getBank().setAccountNumber("123456789");
        properties.getBank().setAccountName("TEST ACCOUNT");
        properties.getPaymentCode().setPrefix("DH");
        SePayTransactionRepository transactions = mock(SePayTransactionRepository.class);
        OrderDAO orders = mock(OrderDAO.class);
        when(transactions.existsBySepayTransactionId(3001L)).thenReturn(false);
        when(transactions.saveAndFlush(any(SePayTransaction.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));
        Order order = new Order();
        order.setId(39);
        order.setOrderCode("DH39");
        order.setPaymentMethod("VIETQR");
        order.setStatus("CHO_XAC_NHAN_THANH_TOAN");
        order.setTotalPrice(500_000D);
        when(orders.findByIdForUpdate(39)).thenReturn(Optional.of(order));
        SePayWebhookService service = new SePayWebhookService(
                new ObjectMapper(),
                mock(SePaySignatureVerifier.class),
                properties,
                transactions,
                orders,
                mock(SePayPaymentSession.class));
        String payload = "{"
                + "\"id\":3001,"
                + "\"accountNumber\":\"123456789\","
                + "\"transferType\":\"in\","
                + "\"transferAmount\":" + transferAmount + ","
                + "\"code\":\"DH39\","
                + "\"content\":\"SEVQR DH39\""
                + "}";

        SePayWebhookResult result = service.process(
                "signature", "timestamp", payload.getBytes(StandardCharsets.UTF_8));

        assertEquals(SePayWebhookResult.BAD_REQUEST, result);
        assertEquals("CHO_XAC_NHAN_THANH_TOAN", order.getStatus());
        verify(orders, never()).save(order);
    }
}
