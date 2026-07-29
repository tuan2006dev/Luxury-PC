package poly.edu.controller.admin;

import org.junit.jupiter.api.Test;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.assertFalse;

class AdminControllerVietQrTest {

    @Test
    void adminControllerDoesNotExposeManualPaymentConfirmationEndpoint() {
        boolean manualConfirmationEndpointExists = Arrays.stream(AdminController.class.getDeclaredMethods())
                .map(method -> method.getAnnotation(PostMapping.class))
                .filter(annotation -> annotation != null)
                .anyMatch(annotation -> Arrays.asList(annotation.value()).contains("/orders/confirm-payment")
                        || Arrays.asList(annotation.path()).contains("/orders/confirm-payment"));

        assertFalse(manualConfirmationEndpointExists);
    }
}
