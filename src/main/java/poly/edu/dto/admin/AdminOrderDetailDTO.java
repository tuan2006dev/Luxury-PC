package poly.edu.dto.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminOrderDetailDTO {
    private Integer id;
    private String orderCode;
    private Date createdAt;
    private String createdAtFormatted;

    // Status & Payment
    private String status;
    private String statusDisplay;
    private String statusBadgeClass;
    private String paymentMethod;
    private String paymentMethodDisplay;

    // Customer & Shipping
    private Integer userId;
    private String username;
    private String fullName;
    private String email;
    private String phone;
    private String address;
    private String city;
    private String shippingMethodName;
    private Double shippingFee;
    private String trackingCode;

    // Pricing & Discounts
    private Double subtotal;
    private String voucherCode;
    private Double discountAmount;
    private String freeshipVoucherCode;
    private Double freeshipDiscount;
    private Double vipDiscount;
    private Double totalPrice;

    // Notes
    private String adminNote;
    private String refundReason;
    private String refundPreviousStatus;

    // Items
    private List<AdminOrderItemDTO> items;
}
