package poly.edu;

import org.junit.jupiter.api.Test;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.mock.web.MockHttpServletRequest;
import poly.edu.config.SePayProperties;
import poly.edu.controller.api.SePayWebhookController;
import poly.edu.dto.SePayWebhookResponse;
import poly.edu.service.SePayWebhookService;

import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;

class SePayWebhookControllerTest {

    @Test
    void nonDuplicateIntegrityViolationDoesNotReturnSuccess() {
        SePayWebhookService webhookService = mock(SePayWebhookService.class);
        doThrow(new DataIntegrityViolationException("schema violation"))
                .when(webhookService).process(anyString(), anyString(), any(byte[].class));

        SePayProperties properties = new SePayProperties();
        properties.getWebhook().setMaxBodyBytes(1024);
        SePayWebhookController controller = new SePayWebhookController(webhookService, properties);

        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setContent("{}".getBytes(StandardCharsets.UTF_8));

        var response = controller.receive("signature", "timestamp", request);

        assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        SePayWebhookResponse body = response.getBody();
        assertEquals(false, body.success());
    }
}
