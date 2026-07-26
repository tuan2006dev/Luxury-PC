package poly.edu.service;

public enum SePayWebhookResult {
    PROCESSED,
    DUPLICATE,
    EXPIRED,
    BAD_REQUEST,
    ORDER_NOT_FOUND,
    ORDER_CONFLICT
}
