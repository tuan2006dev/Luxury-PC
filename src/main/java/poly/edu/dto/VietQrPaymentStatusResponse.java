package poly.edu.dto;

import java.time.Instant;

public record VietQrPaymentStatusResponse(
        String orderCode,
        String status,
        String paymentStatus,
        boolean paid,
        Instant serverTime,
        Instant qrCreatedAt,
        Instant expiresAt,
        long remainingSeconds,
        boolean expired) {
}
