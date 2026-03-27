package poly.edu.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Date;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "orders")
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "full_name")
    private String fullName;

    private String email;
    private String phone;
    private String address;
    private String city;

    @Column(name = "total_price")
    private Double totalPrice;

    private String status; // PENDING, PAID, SHIPPING, COMPLETED, CANCELLED

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderItem> orderItems;

    @PrePersist
    protected void onCreate() {
        this.createdAt = new Date();
        if (this.status == null) {
            this.status = "PENDING";
        }
    }
}
