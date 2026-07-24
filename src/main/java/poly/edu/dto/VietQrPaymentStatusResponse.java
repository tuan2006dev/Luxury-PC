package poly.edu.dto;

public record VietQrPaymentStatusResponse(
        String orderCode,
        String paymentStatus,
        boolean paid) {
}
