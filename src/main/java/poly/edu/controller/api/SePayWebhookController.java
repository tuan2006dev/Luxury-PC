package poly.edu.controller.api;

import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import poly.edu.config.SePayProperties;
import poly.edu.dto.SePayWebhookResponse;
import poly.edu.service.SePayDuplicateTransactionException;
import poly.edu.service.SePayWebhookAuthenticationException;
import poly.edu.service.SePayWebhookPayloadTooLargeException;
import poly.edu.service.SePayWebhookResult;
import poly.edu.service.SePayWebhookService;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

@RestController
@RequestMapping("/api/sepay")
public class SePayWebhookController {

    private static final Logger logger = LoggerFactory.getLogger(SePayWebhookController.class);

    private final SePayWebhookService sePayWebhookService;
    private final SePayProperties sePayProperties;

    public SePayWebhookController(SePayWebhookService sePayWebhookService, SePayProperties sePayProperties) {
        this.sePayWebhookService = sePayWebhookService;
        this.sePayProperties = sePayProperties;
    }

    @PostMapping("/webhook")
    public ResponseEntity<SePayWebhookResponse> receive(
            @RequestHeader(value = "X-SePay-Signature", required = false) String signature,
            @RequestHeader(value = "X-SePay-Timestamp", required = false) String timestamp,
            HttpServletRequest request) {
        try {
            byte[] rawBody = readRawBody(request);
            SePayWebhookResult result = sePayWebhookService.process(signature, timestamp, rawBody);
            return responseFor(result);
        } catch (SePayDuplicateTransactionException exception) {
            return ResponseEntity.ok(new SePayWebhookResponse(true));
        } catch (SePayWebhookAuthenticationException exception) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new SePayWebhookResponse(false));
        } catch (SePayWebhookPayloadTooLargeException exception) {
            return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE).body(new SePayWebhookResponse(false));
        } catch (IllegalArgumentException exception) {
            return ResponseEntity.badRequest().body(new SePayWebhookResponse(false));
        } catch (IllegalStateException exception) {
            logger.error("SePay webhook configuration or cryptographic processing failed: {}",
                    exception.getClass().getSimpleName());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new SePayWebhookResponse(false));
        } catch (Exception exception) {
            logger.error("SePay webhook processing failed: {}", exception.getClass().getSimpleName());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new SePayWebhookResponse(false));
        }
    }

    private ResponseEntity<SePayWebhookResponse> responseFor(SePayWebhookResult result) {
        return switch (result) {
            case PROCESSED, DUPLICATE -> ResponseEntity.ok(new SePayWebhookResponse(true));
            case BAD_REQUEST -> ResponseEntity.badRequest().body(new SePayWebhookResponse(false));
            case ORDER_NOT_FOUND -> ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new SePayWebhookResponse(false));
            case ORDER_CONFLICT -> ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(new SePayWebhookResponse(false));
        };
    }

    private byte[] readRawBody(HttpServletRequest request) throws IOException {
        long maxBodyBytes = sePayProperties.getWebhook().getMaxBodyBytes();
        long contentLength = request.getContentLengthLong();
        if (maxBodyBytes <= 0 || contentLength > maxBodyBytes) {
            throw new SePayWebhookPayloadTooLargeException();
        }

        try (InputStream input = request.getInputStream();
             ByteArrayOutputStream output = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            long total = 0;
            while ((bytesRead = input.read(buffer)) != -1) {
                total += bytesRead;
                if (total > maxBodyBytes) {
                    throw new SePayWebhookPayloadTooLargeException();
                }
                output.write(buffer, 0, bytesRead);
            }
            return output.toByteArray();
        }
    }
}
