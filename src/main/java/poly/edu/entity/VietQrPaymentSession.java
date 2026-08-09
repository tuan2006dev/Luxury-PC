package poly.edu.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.time.Instant;

@Entity
@Table(name = "sepay_payment_sessions")
public class VietQrPaymentSession {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;

    @Column(name = "qr_created_at", nullable = false, columnDefinition = "datetime")
    private Instant qrCreatedAt;

    @Column(name = "qr_expires_at", nullable = false, columnDefinition = "datetime")
    private Instant qrExpiresAt;

    @Column(name = "paid_at", columnDefinition = "datetime")
    private Instant paidAt;

    @Column(name = "expired_at", columnDefinition = "datetime")
    private Instant expiredAt;

    public Long getId() {
        return id;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public Instant getQrCreatedAt() {
        return qrCreatedAt;
    }

    public void setQrCreatedAt(Instant qrCreatedAt) {
        this.qrCreatedAt = qrCreatedAt;
    }

    public Instant getQrExpiresAt() {
        return qrExpiresAt;
    }

    public void setQrExpiresAt(Instant qrExpiresAt) {
        this.qrExpiresAt = qrExpiresAt;
    }

    public Instant getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Instant paidAt) {
        this.paidAt = paidAt;
    }

    public Instant getExpiredAt() {
        return expiredAt;
    }

    public void setExpiredAt(Instant expiredAt) {
        this.expiredAt = expiredAt;
    }
}
