package poly.edu.service;

public class SePayWebhookPayloadTooLargeException extends RuntimeException {

    public SePayWebhookPayloadTooLargeException() {
        super("Webhook payload is too large");
    }
}
