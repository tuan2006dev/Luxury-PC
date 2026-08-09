package poly.edu.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LalamoveWebhookDTO {
    private String orderId;       // Or trackingCode / orderCode
    private String trackingCode;  // Optional tracking code
    private String event;         // ASSIGN_DRIVER, PICKED_UP, ON_DELIVERY, DELIVERED, CANCELLED
    private String driverName;    // Optional mock info
    private String driverPhone;   // Optional mock info
}
