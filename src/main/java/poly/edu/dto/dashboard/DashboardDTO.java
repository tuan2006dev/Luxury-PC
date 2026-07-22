package poly.edu.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DashboardDTO {
    private SummaryDTO summary;
    private List<RevenueDTO> dailyRevenue;
    private List<OrderStatusDTO> orderStatus;
    private List<UserGrowthDTO> newUsers;
}
