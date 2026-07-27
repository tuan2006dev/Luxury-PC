package poly.edu;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.test.web.servlet.MockMvc;
import poly.edu.config.SePayProperties;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.SePayTransactionRepository;
import poly.edu.entity.Order;
import poly.edu.entity.SePayTransaction;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.HexFormat;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
@AutoConfigureMockMvc
class SePayWebhookIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private SePayProperties sePayProperties;

    @Autowired
    private OrderDAO orderDAO;

    @Autowired
    private SePayTransactionRepository transactionRepository;

    @Test
    void validWebhookMarksOrderPaidAndDuplicateDoesNotProcessAgain() throws Exception {
        Order order = saveVietQrOrder(500_000D);
        String body = payload(9_001L, paymentCode(order), "SEVQR " + paymentCode(order), 500_000L);

        sendSignedWebhook(body).andExpect(status().isOk()).andExpect(jsonPath("$.success").value(true));
        sendSignedWebhook(body).andExpect(status().isOk()).andExpect(jsonPath("$.success").value(true));

        assertEquals("DA_THANH_TOAN", orderDAO.findById(order.getId()).orElseThrow().getStatus());
        SePayTransaction transaction = transactionRepository.findBySepayTransactionId(9_001L).orElseThrow();
        assertEquals(paymentCode(order), transaction.getPaymentCode());
        assertEquals(order.getOrderCode(), transaction.getOrderCode());
        assertEquals(1L, transactionRepository.count());
    }

    @Test
    void webhookUsesStrictPaymentCodeFromContentWhenCodeIsMissing() throws Exception {
        Order order = saveVietQrOrder(750_000D);
        String body = payload(9_002L, null, "SEVQR " + paymentCode(order), 750_000L);

        sendSignedWebhook(body).andExpect(status().isOk()).andExpect(jsonPath("$.success").value(true));

        assertEquals("DA_THANH_TOAN", orderDAO.findById(order.getId()).orElseThrow().getStatus());
    }

    @Test
    void webhookWithNonExactAmountIsRecordedButReturnsBadRequest() throws Exception {
        Order order = saveVietQrOrder(500_000D);
        String body = payload(9_003L, paymentCode(order), "SEVQR " + paymentCode(order), 500_001L);

        sendSignedWebhook(body).andExpect(status().isBadRequest()).andExpect(jsonPath("$.success").value(false));

        assertEquals("CHO_XAC_NHAN_THANH_TOAN", orderDAO.findById(order.getId()).orElseThrow().getStatus());
        SePayTransaction transaction = transactionRepository.findBySepayTransactionId(9_003L).orElseThrow();
        assertEquals("REJECTED_AMOUNT_MISMATCH", transaction.getProcessingStatus());
    }

    @Test
    void webhookWithUnknownPaymentCodeReturnsNotFound() throws Exception {
        String paymentCode = "DH999999";
        String body = payload(9_004L, paymentCode, "SEVQR " + paymentCode, 500_000L);

        sendSignedWebhook(body).andExpect(status().isNotFound()).andExpect(jsonPath("$.success").value(false));

        SePayTransaction transaction = transactionRepository.findBySepayTransactionId(9_004L).orElseThrow();
        assertEquals(paymentCode, transaction.getPaymentCode());
        assertEquals("REJECTED_ORDER_NOT_FOUND", transaction.getProcessingStatus());
    }

    @Test
    void invalidSignatureIsRejectedBeforeTransactionIsStored() throws Exception {
        Order order = saveVietQrOrder(500_000D);
        String body = payload(9_005L, paymentCode(order), "SEVQR " + paymentCode(order), 500_000L);
        String timestamp = String.valueOf(Instant.now().getEpochSecond());

        mockMvc.perform(post("/api/sepay/webhook")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("X-SePay-Timestamp", timestamp)
                        .header("X-SePay-Signature", "sha256=invalid")
                        .content(body))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.success").value(false));

        assertEquals(0L, transactionRepository.count());
    }

    private org.springframework.test.web.servlet.ResultActions sendSignedWebhook(String body) throws Exception {
        String timestamp = String.valueOf(Instant.now().getEpochSecond());
        return mockMvc.perform(post("/api/sepay/webhook")
                .contentType(MediaType.APPLICATION_JSON)
                .header("X-SePay-Timestamp", timestamp)
                .header("X-SePay-Signature", signature(timestamp, body))
                .content(body));
    }

    private String signature(String timestamp, String body) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(
                sePayProperties.getWebhook().getSecret().getBytes(StandardCharsets.UTF_8),
                "HmacSHA256"));
        return "sha256=" + HexFormat.of().formatHex(
                mac.doFinal((timestamp + "." + body).getBytes(StandardCharsets.UTF_8)));
    }

    private String payload(Long transactionId, String code, String content, Long amount) {
        String codeValue = code == null ? "null" : "\"" + code + "\"";
        return "{"
                + "\"id\":" + transactionId + ","
                + "\"gateway\":\"" + sePayProperties.getBank().getId() + "\","
                + "\"transactionDate\":\"2026-07-13 10:00:00\","
                + "\"accountNumber\":\"" + sePayProperties.getBank().getAccountNumber() + "\","
                + "\"subAccount\":\"\","
                + "\"code\":" + codeValue + ","
                + "\"content\":\"" + content + "\","
                + "\"transferType\":\"in\","
                + "\"description\":\"\","
                + "\"transferAmount\":" + amount + ","
                + "\"accumulated\":0,"
                + "\"referenceCode\":\"REF-TEST\""
                + "}";
    }

    private String paymentCode(Order order) {
        return "DH" + order.getId();
    }

    private Order saveVietQrOrder(Double amount) {
        Order order = new Order();
        order.setFullName("SePay QA");
        order.setPhone("0900000000");
        order.setAddress("QA address");
        order.setTotalPrice(amount);
        order.setPaymentMethod("VIETQR");
        order.setStatus("CHO_XAC_NHAN_THANH_TOAN");
        order = orderDAO.saveAndFlush(order);
        order.setOrderCode("Luxury-" + order.getId());
        return orderDAO.saveAndFlush(order);
    }
}
