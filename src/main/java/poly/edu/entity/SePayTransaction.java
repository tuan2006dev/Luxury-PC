package poly.edu.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

import java.time.Instant;

@Entity
@Table(name = "sepay_transactions", uniqueConstraints = @UniqueConstraint(name = "uk_sepay_transactions_transaction_id", columnNames = "sepay_transaction_id"))
public class SePayTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "sepay_transaction_id", nullable = false, updatable = false)
    private Long sepayTransactionId;

    @Column(name = "order_code", length = 100)
    private String orderCode;

    @Column(name = "transfer_amount", nullable = false)
    private Long transferAmount;

    @Column(name = "transfer_type", nullable = false, length = 16)
    private String transferType;

    @Column(name = "account_number", length = 100)
    private String accountNumber;

    @Column(name = "payment_code", length = 100)
    private String paymentCode;

    @Column(name = "processing_status", nullable = false, length = 64)
    private String processingStatus;

    @Column(name = "raw_payload", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String rawPayload;

    @Column(name = "received_at", nullable = false, columnDefinition = "datetime")
    private Instant receivedAt;

    @Column(name = "processed_at", columnDefinition = "datetime")
    private Instant processedAt;

    public Long getId() {
        return id;
    }

    public Long getSepayTransactionId() {
        return sepayTransactionId;
    }

    public void setSepayTransactionId(Long sepayTransactionId) {
        this.sepayTransactionId = sepayTransactionId;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public Long getTransferAmount() {
        return transferAmount;
    }

    public void setTransferAmount(Long transferAmount) {
        this.transferAmount = transferAmount;
    }

    public String getTransferType() {
        return transferType;
    }

    public void setTransferType(String transferType) {
        this.transferType = transferType;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getPaymentCode() {
        return paymentCode;
    }

    public void setPaymentCode(String paymentCode) {
        this.paymentCode = paymentCode;
    }

    public String getProcessingStatus() {
        return processingStatus;
    }

    public void setProcessingStatus(String processingStatus) {
        this.processingStatus = processingStatus;
    }

    public String getRawPayload() {
        return rawPayload;
    }

    public void setRawPayload(String rawPayload) {
        this.rawPayload = rawPayload;
    }

    public Instant getReceivedAt() {
        return receivedAt;
    }

    public void setReceivedAt(Instant receivedAt) {
        this.receivedAt = receivedAt;
    }

    public Instant getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(Instant processedAt) {
        this.processedAt = processedAt;
    }
}
