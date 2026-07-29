package poly.edu;

import org.junit.jupiter.api.Test;

import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class VietQrViewContractTest {

    @Test
    void profileRetryButtonOnlyTargetsWaitingVietQrOrders() throws Exception {
        String profile = Files.readString(Path.of("src/main/resources/templates/account/profile/orders.html"));

        assertTrue(profile.contains(
                "order.paymentMethod == 'VIETQR' and order.status == 'CHO_XAC_NHAN_THANH_TOAN'"));
        assertTrue(profile.contains("@{/payment/vietqr(orderCode=${order.orderCode})}"));
    }

    @Test
    void adminHasNoSeparatePaymentConfirmationAction() throws Exception {
        String adminOrders = Files.readString(Path.of("src/main/resources/templates/admin/orders.html"));
        String adminController = Files.readString(Path.of(
                "src/main/java/poly/edu/controller/admin/AdminController.java"));

        assertFalse(adminOrders.contains("/admin/orders/confirm-payment"));
        assertFalse(adminOrders.contains("X\u00e1c Nh\u1eadn Thanh To\u00e1n"));
        assertFalse(adminController.contains("/orders/confirm-payment"));
        assertFalse(adminController.contains("confirmVietQrPayment"));
    }

    @Test
    void adminOrderStatusDropdownIncludesCompletedWithoutMixingPaymentStatus() throws Exception {
        String adminOrders = Files.readString(Path.of("src/main/resources/templates/admin/orders.html"));

        assertTrue(adminOrders.contains("<option value=\"PROCESSING\""));
        assertTrue(adminOrders.contains("<option value=\"SHIPPING\""));
        assertTrue(adminOrders.contains("<option value=\"PAID\""));
        assertTrue(adminOrders.contains("<option value=\"COMPLETED\""));
        assertTrue(adminOrders.contains("<option value=\"DA_HUY\""));
        assertTrue(adminOrders.contains(
                "o.paymentMethod == 'COD' and (o.status == 'SHIPPING' or o.status == 'DANG_GIAO')"));
        assertTrue(adminOrders.contains(
                "(o.paymentMethod == 'VIETQR' or o.paymentMethod == 'SEPAY') and (o.status == 'SHIPPING' or o.status == 'DANG_GIAO')"));
        assertTrue(adminOrders.contains("o.paymentMethod == 'COD' and o.status == 'PENDING'"));
        assertFalse(adminOrders.contains("th:disabled="));
        assertFalse(adminOrders.contains("<option value=\"PENDING\""));
        assertFalse(adminOrders.contains("<option value=\"DA_THANH_TOAN\""));
        assertFalse(adminOrders.contains("value=\"PAID\"\n                                                    th:if=\"${(o.paymentMethod == 'VIETQR'"));
    }

    @Test
    void customerOrderStatusUsesVietnameseDisplayMapper() throws Exception {
        String profileOrders = Files.readString(Path.of(
                "src/main/resources/templates/account/profile/orders.html"));

        assertTrue(profileOrders.contains("th:text=\"${order.statusDisplay}\""));
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
