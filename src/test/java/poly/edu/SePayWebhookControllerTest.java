package poly.edu;

import org.junit.jupiter.api.Test;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.mock.web.MockHttpServletRequest;
import poly.edu.config.SePayProperties;
import poly.edu.controller.api.SePayWebhookController;
import poly.edu.service.SePayWebhookAuthenticationException;
import poly.edu.service.SePayWebhookResult;
import poly.edu.service.SePayWebhookService;

import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

class SePayWebhookControllerTest {

    @Test
    void mapsProcessingResultsToDocumentedHttpStatuses() {
        assertResultStatus(SePayWebhookResult.PROCESSED, HttpStatus.OK, true);
        assertResultStatus(SePayWebhookResult.DUPLICATE, HttpStatus.OK, true);
        assertResultStatus(SePayWebhookResult.BAD_REQUEST, HttpStatus.BAD_REQUEST, false);
        assertResultStatus(SePayWebhookResult.ORDER_NOT_FOUND, HttpStatus.NOT_FOUND, false);
        assertResultStatus(SePayWebhookResult.ORDER_CONFLICT, HttpStatus.CONFLICT, false);
    }

    @Test
    void invalidSignatureReturnsUnauthorized() {
        SePayWebhookService webhookService = mock(SePayWebhookService.class);
        doThrow(new SePayWebhookAuthenticationException("invalid"))
                .when(webhookService).process(anyString(), anyString(), any(byte[].class));

        var response = controller(webhookService, 1024)
                .receive("signature", "timestamp", request("{}"));

        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
        assertFalse(response.getBody().success());
    }

    @Test
    void oversizedBodyIsRejectedBeforeServiceCall() {
        SePayWebhookService webhookService = mock(SePayWebhookService.class);

        var response = controller(webhookService, 4)
                .receive("signature", "timestamp", request("12345"));

        assertEquals(HttpStatus.PAYLOAD_TOO_LARGE, response.getStatusCode());
        assertFalse(response.getBody().success());
        verifyNoInteractions(webhookService);
    }

    @Test
    void malformedPayloadReturnsBadRequest() {
        SePayWebhookService webhookService = mock(SePayWebhookService.class);
        doThrow(new IllegalArgumentException("invalid JSON"))
                .when(webhookService).process(anyString(), anyString(), any(byte[].class));

        var response = controller(webhookService, 1024)
                .receive("signature", "timestamp", request("{"));

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertFalse(response.getBody().success());
    }

    @Test
    void databaseIntegrityFailureReturns500InsteadOfSuccess() {
        SePayWebhookService webhookService = mock(SePayWebhookService.class);
        doThrow(new DataIntegrityViolationException("schema violation"))
                .when(webhookService).process(anyString(), anyString(), any(byte[].class));

        var response = controller(webhookService, 1024)
                .receive("signature", "timestamp", request("{}"));

        assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        assertFalse(response.getBody().success());
    }

    private void assertResultStatus(SePayWebhookResult result, HttpStatus status, boolean success) {
        SePayWebhookService webhookService = mock(SePayWebhookService.class);
        when(webhookService.process(anyString(), anyString(), any(byte[].class))).thenReturn(result);

        var response = controller(webhookService, 1024)
                .receive("signature", "timestamp", request("{}"));

        assertEquals(status, response.getStatusCode());
        assertEquals(success, response.getBody().success());
    }

    private SePayWebhookController controller(SePayWebhookService service, long maxBodyBytes) {
        SePayProperties properties = new SePayProperties();
        properties.getWebhook().setMaxBodyBytes(maxBodyBytes);
        return new SePayWebhookController(service, properties);
    }

    private MockHttpServletRequest request(String body) {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setContent(body.getBytes(StandardCharsets.UTF_8));
        return request;
    }
}
