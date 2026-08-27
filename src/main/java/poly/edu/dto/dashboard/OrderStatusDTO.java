package poly.edu.dto.dashboard;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
public class OrderStatusDTO {
    private String status;
    private Long count;

    public OrderStatusDTO(String status, Long count) {
        this.status = status;
        this.count = count;
    }
}
