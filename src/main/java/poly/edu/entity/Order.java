package poly.edu.entity;

import jakarta.persistence.*;
import java.util.Date;
import java.util.List;

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

    @Column(name = "order_code", unique = true)
    private String orderCode;

    @Column(name = "payment_method")
    private String paymentMethod;

    private String status;

    @Column(name = "voucher_code")
    private String voucherCode;

    @Column(name = "discount_amount")
    private Double discountAmount;

    @Column(name = "vip_discount")
    private Double vipDiscount;

    @Column(name = "freeship_voucher_code")
    private String freeshipVoucherCode;

    @Column(name = "freeship_discount")
    private Double freeshipDiscount;

    @Column(name = "shipping_fee")
    private Double shippingFee;

    @Column(name = "shipping_method_name")
    private String shippingMethodName;

    @Column(name = "tracking_code")
    private String trackingCode;

    @Column(name = "admin_note", length = 1000)
    private String adminNote;

    @Column(name = "refund_reason", length = 1000)
    private String refundReason;

    @Column(name = "refund_previous_status")
    private String refundPreviousStatus;

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderItem> orderItems;

    public Order() {
    }

    public Order(Integer id, User user, String fullName, String email, String phone, String address, String city, Double totalPrice, String status, String voucherCode, Double discountAmount, Date createdAt, List<OrderItem> orderItems) {
        this.id = id;
        this.user = user;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.city = city;
        this.totalPrice = totalPrice;
        this.status = status;
        this.voucherCode = voucherCode;
        this.discountAmount = discountAmount;
        this.createdAt = createdAt;
        this.orderItems = orderItems;
    }

    @PrePersist
    protected void onCreate() {
        if (this.createdAt == null) {
            this.createdAt = new Date();
        }
        if (this.status == null) {
            this.status = "PENDING";
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

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public Double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(Double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public Double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(Double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public Double getVipDiscount() {
        return vipDiscount;
    }

    public void setVipDiscount(Double vipDiscount) {
        this.vipDiscount = vipDiscount;
    }

    public String getFreeshipVoucherCode() {
        return freeshipVoucherCode;
    }

    public void setFreeshipVoucherCode(String freeshipVoucherCode) {
        this.freeshipVoucherCode = freeshipVoucherCode;
    }

    public Double getFreeshipDiscount() {
        return freeshipDiscount;
    }

    public void setFreeshipDiscount(Double freeshipDiscount) {
        this.freeshipDiscount = freeshipDiscount;
    }

    public Double getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(Double shippingFee) {
        this.shippingFee = shippingFee;
    }

    public String getShippingMethodName() {
        return shippingMethodName;
    }

    public void setShippingMethodName(String shippingMethodName) {
        this.shippingMethodName = shippingMethodName;
    }

    public String getAdminNote() {
        return adminNote;
    }

    public void setAdminNote(String adminNote) {
        this.adminNote = adminNote;
    }

    public String getRefundReason() {
        return refundReason;
    }

    public void setRefundReason(String refundReason) {
        this.refundReason = refundReason;
    }

    public String getRefundPreviousStatus() {
        return refundPreviousStatus;
    }

    public void setRefundPreviousStatus(String refundPreviousStatus) {
        this.refundPreviousStatus = refundPreviousStatus;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public List<OrderItem> getOrderItems() {
        return orderItems;
    }

    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }

    public String getTrackingCode() {
        return trackingCode;
    }

    public void setTrackingCode(String trackingCode) {
        this.trackingCode = trackingCode;
    }

    @Transient
    public String getStatusDisplay() {
        if (status == null) return "Chưa xác định";
        return switch (status) {
            case "CHO_XAC_NHAN_THANH_TOAN" -> "Chờ xác nhận thanh toán";
            case "DA_THANH_TOAN", "PAID" -> "Đã thanh toán";
            case "YEU_CAU_HOAN_TIEN" -> "Đã yêu cầu hoàn trả";
            case "CHO_HOAN_TIEN" -> "Chờ hoàn tiền";
            case "DA_HOAN_TIEN" -> "Đã hoàn tiền";
            case "THU_HOI" -> "Đã thu hồi";
            case "PENDING" -> "Chờ xử lý";
            case "DA_HUY", "CANCELLED", "CANCELED" -> "Đã hủy";
            case "WAITING_DRIVER" -> "Chờ tài xế Lalamove";
            case "PICKED_UP" -> "Tài xế đã lấy hàng";
            case "SHIPPING" -> "Đang giao hàng";
            case "COMPLETED", "HOAN_THANH" -> "Hoàn thành";
            default -> status;
        };
    }

    @Transient
    public String getPaymentMethodDisplay() {
        if (paymentMethod == null) return "Chưa xác định";
        return switch (paymentMethod) {
            case "VIETQR" -> "VietQR";
            case "COD" -> "COD";
            case "INSTALLMENT" -> "Trả góp";
            default -> paymentMethod;
        };
    }

    @Transient
    public String getTransferContent() {
        return "VIETQR".equals(paymentMethod) && orderCode != null
                ? "THANH TOAN " + orderCode
                : null;
    }

    @Transient
    public boolean isCustomerRefundEligible() {
        return "DA_THANH_TOAN".equals(status)
                || "PAID".equals(status)
                || "COMPLETED".equals(status)
                || "HOAN_THANH".equals(status);
    }
}
