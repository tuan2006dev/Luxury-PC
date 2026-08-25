package poly.edu.dto.admin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminOrderItemDTO {
    private Integer id;
    private Integer productId;
    private String productName;
    private String productImage;
    private String brand;
    private String categoryName;
    private Double price;
    private Integer quantity;
    private Double itemTotal;
}
