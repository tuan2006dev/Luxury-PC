package poly.edu;

import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class VietQrViewContractTest {

    @Test
    void profileReusesItsExistingRetryButtonForWaitingVietQrOrders() throws Exception {
        String ordersFragment =
                Files.readString(Path.of("src/main/resources/templates/account/profile/orders.html"));

        assertTrue(ordersFragment.contains(
                "order.paymentMethod == 'VIETQR' and order.status == 'CHO_XAC_NHAN_THANH_TOAN'"));
        assertTrue(ordersFragment.contains(
                "@{/payment/vietqr(orderCode=${order.orderCode},renew=true)}"));
        assertFalse(Files.exists(Path.of("src/main/resources/templates/fragments/profile/_orders.html")));
    }

    @Test
    void paymentViewContainsServerBackedCountdownAndRenewalControls() throws Exception {
        String paymentView =
                Files.readString(Path.of("src/main/resources/templates/payment-vietqr.html"));

        assertTrue(paymentView.contains("data-server-time=${serverTime}"));
        assertTrue(paymentView.contains("data-expires-at=${expiresAt}"));
        assertTrue(paymentView.contains("id=\"payment-countdown\""));
        assertTrue(paymentView.contains("Mã QR đã hết hạn"));
        assertTrue(paymentView.contains("id=\"payment-renew-link\""));
    }

    @Test
    void countdownDispatchesExpirationEventAndStopsBothIntervals() throws Exception {
        String pollingScript = Files.readString(Path.of("src/main/resources/static/js/payment-vietqr.js"));

        assertTrue(pollingScript.contains("new CustomEvent('vietqr:expired'"));
        assertTrue(pollingScript.contains("window.clearInterval(pollingIntervalId)"));
        assertTrue(pollingScript.contains("window.clearInterval(countdownIntervalId)"));
        assertTrue(pollingScript.contains("visibilitychange"));
        assertTrue(pollingScript.contains("serverOffsetMs"));
        assertTrue(pollingScript.contains("vietqrInitialized"));
        assertFalse(pollingScript.contains("15 * 60 * 1000"));
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
