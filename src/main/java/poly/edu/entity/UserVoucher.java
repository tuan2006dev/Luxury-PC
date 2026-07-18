package poly.edu.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "user_vouchers", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"user_id", "voucher_id"})
})
public class UserVoucher {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "voucher_id", nullable = false)
    private Voucher voucher;

    /**
     * Trạng thái voucher của user: AVAILABLE, RESERVED, CONSUMED, EXPIRED, CANCELLED, REFUNDED
     */
    @Column(name = "status", nullable = false)
    private String status = "AVAILABLE";

    @Column(name = "reservation_expires_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date reservationExpiresAt;

    @Column(name = "saved_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date savedAt;

    @Column(name = "used_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date usedAt;

    public UserVoucher() {
    }

    public UserVoucher(Integer id, User user, Voucher voucher, String status, Date savedAt, Date usedAt, Date reservationExpiresAt) {
        this.id = id;
        this.user = user;
        this.voucher = voucher;
        this.status = status;
        this.savedAt = savedAt;
        this.usedAt = usedAt;
        this.reservationExpiresAt = reservationExpiresAt;
    }

    @PrePersist
    protected void onCreate() {
        this.savedAt = new Date();
        if (this.status == null) {
            this.status = "AVAILABLE";
        }
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Voucher getVoucher() {
        return voucher;
    }

    public void setVoucher(Voucher voucher) {
        this.voucher = voucher;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getReservationExpiresAt() {
        return reservationExpiresAt;
    }

    public void setReservationExpiresAt(Date reservationExpiresAt) {
        this.reservationExpiresAt = reservationExpiresAt;
    }

    public Date getSavedAt() {
        return savedAt;
    }

    public void setSavedAt(Date savedAt) {
        this.savedAt = savedAt;
    }

    public Date getUsedAt() {
        return usedAt;
    }

    public void setUsedAt(Date usedAt) {
        this.usedAt = usedAt;
    }
}
