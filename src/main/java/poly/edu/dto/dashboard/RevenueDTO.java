package poly.edu.dto.dashboard;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
public class RevenueDTO {
    private String date;
    private Double revenue;

    public RevenueDTO(String date, Double revenue) {
        this.date = date;
        this.revenue = revenue;
    }
}
