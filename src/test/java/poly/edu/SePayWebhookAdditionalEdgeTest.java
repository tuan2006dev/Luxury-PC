package poly.edu;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.mock.web.MockHttpServletRequest;
import poly.edu.config.SePayProperties;
import poly.edu.controller.api.SePayWebhookController;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.SePayTransactionRepository;
import poly.edu.entity.Order;
import poly.edu.entity.SePayTransaction;
import poly.edu.service.SePayDuplicateTransactionException;
import poly.edu.service.SePaySignatureVerifier;
import poly.edu.service.SePayWebhookResult;
import poly.edu.service.SePayWebhookService;

import java.nio.charset.StandardCharsets;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class SePayWebhookAdditionalEdgeTest {

    @Test
    void newTransactionForAlreadyPaidOrderReturnsConflictWithoutSecondUpdate() {
        SePayProperties properties = properties();
        SePayTransactionRepository transactions = mock(SePayTransactionRepository.class);
        OrderDAO orders = mock(OrderDAO.class);
        when(transactions.existsBySepayTransactionId(2001L)).thenReturn(false);
        when(transactions.saveAndFlush(any(SePayTransaction.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));
        Order order = new Order();
        order.setId(39);
        order.setOrderCode("DH39");
        order.setPaymentMethod("VIETQR");
        order.setStatus("DA_THANH_TOAN");
        order.setTotalPrice(500_000D);
        when(orders.findByIdForUpdate(39)).thenReturn(Optional.of(order));
        SePayWebhookService service = new SePayWebhookService(
                new ObjectMapper(),
                mock(SePaySignatureVerifier.class),
                properties,
                transactions,
                orders);

        SePayWebhookResult result = service.process(
                "signature",
                "timestamp",
                payload(2001L).getBytes(StandardCharsets.UTF_8));

        assertEquals(SePayWebhookResult.ORDER_CONFLICT, result);
        verify(orders, never()).save(order);
    }

    @Test
    void duplicateConstraintRaceStillReturnsHttp200() {
        SePayWebhookService service = mock(SePayWebhookService.class);
        doThrow(new SePayDuplicateTransactionException())
                .when(service).process(any(), any(), any(byte[].class));
        SePayWebhookController controller = new SePayWebhookController(service, properties());
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setContent("{}".getBytes(StandardCharsets.UTF_8));

        var response = controller.receive("signature", "timestamp", request);

        assertEquals(200, response.getStatusCode().value());
        assertEquals(true, response.getBody().success());
    }

    private SePayProperties properties() {
        SePayProperties properties = new SePayProperties();
        properties.getWebhook().setSecret("test-secret");
        properties.getWebhook().setMaxBodyBytes(1024);
        properties.getBank().setId("ICB");
        properties.getBank().setDisplayName("VietinBank");
        properties.getBank().setAccountNumber("123456789");
        properties.getBank().setAccountName("TEST ACCOUNT");
        properties.getPaymentCode().setPrefix("DH");
        return properties;
    }

    private String payload(long id) {
        return "{"
                + "\"id\":" + id + ","
                + "\"accountNumber\":\"123456789\","
                + "\"transferType\":\"in\","
                + "\"transferAmount\":500000,"
                + "\"code\":\"DH39\","
                + "\"content\":\"SEVQR DH39\""
                + "}";
    }
}
