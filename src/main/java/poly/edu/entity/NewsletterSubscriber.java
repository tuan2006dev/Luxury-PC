package poly.edu.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "newsletter_subscribers")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class NewsletterSubscriber {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @Column(name = "notify_flash_sale")
    private Boolean notifyFlashSale = true;

    @Column(name = "notify_new_products")
    private Boolean notifyNewProducts = true;

    @Column(name = "notify_weekly_newsletter")
    private Boolean notifyWeeklyNewsletter = true;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "is_active")
    private Boolean active = true;

    @PrePersist
    public void prePersist() {
        if (this.createdAt == null) {
            this.createdAt = LocalDateTime.now();
        }
        if (this.active == null) {
            this.active = true;
        }
        if (this.notifyFlashSale == null) {
            this.notifyFlashSale = true;
        }
        if (this.notifyNewProducts == null) {
            this.notifyNewProducts = true;
        }
        if (this.notifyWeeklyNewsletter == null) {
            this.notifyWeeklyNewsletter = true;
        }
    }
}
