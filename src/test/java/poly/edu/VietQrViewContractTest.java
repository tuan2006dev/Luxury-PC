package poly.edu;

import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class VietQrViewContractTest {

    @Test
    void profileRetryButtonOnlyTargetsWaitingVietQrOrders() throws Exception {
        String profile = Files.readString(Path.of("src/main/resources/templates/account/profile.html"));

        assertTrue(profile.contains(
                "order.paymentMethod == 'VIETQR' and order.status == 'CHO_XAC_NHAN_THANH_TOAN'"));
        assertTrue(profile.contains("@{/payment/vietqr(orderCode=${order.orderCode})}"));
    }

    @Test
    void pollingHasFiniteTimeoutAndDoesNotAutoRedirect() throws Exception {
        String pollingScript = Files.readString(Path.of("src/main/resources/static/js/payment-vietqr.js"));

        assertTrue(pollingScript.contains("15 * 60 * 1000"));
        assertTrue(pollingScript.contains("window.setTimeout"));
        assertFalse(pollingScript.contains("window.location"));
    }

    @Test
    void onlySepayWebhookIsPublicWithinThePaymentFlow() throws Exception {
        String securityConfig = Files.readString(Path.of("src/main/java/poly/edu/config/SecurityConfig.java"));

        assertTrue(securityConfig.contains("\"/api/sepay/webhook\""));
        assertFalse(securityConfig.contains("\"/api/payments/vietqr"));
        assertFalse(securityConfig.contains("\"/payment/vietqr\""));
    }
}
