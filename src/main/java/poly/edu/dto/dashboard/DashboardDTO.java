package poly.edu.dto.dashboard;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
public class DashboardDTO {
    private SummaryDTO summary;
    private List<RevenueDTO> dailyRevenue;
    private List<OrderStatusDTO> orderStatus;
    private List<UserGrowthDTO> newUsers;

    public DashboardDTO(SummaryDTO summary, List<RevenueDTO> dailyRevenue, List<OrderStatusDTO> orderStatus, List<UserGrowthDTO> newUsers) {
        this.summary = summary;
        this.dailyRevenue = dailyRevenue;
        this.orderStatus = orderStatus;
        this.newUsers = newUsers;
    }

    public static DashboardDTOBuilder builder() {
        return new DashboardDTOBuilder();
    }

    public static class DashboardDTOBuilder {
        private SummaryDTO summary;
        private List<RevenueDTO> dailyRevenue;
        private List<OrderStatusDTO> orderStatus;
        private List<UserGrowthDTO> newUsers;

        public DashboardDTOBuilder summary(SummaryDTO summary) {
            this.summary = summary;
            return this;
        }

        public DashboardDTOBuilder dailyRevenue(List<RevenueDTO> dailyRevenue) {
            this.dailyRevenue = dailyRevenue;
            return this;
        }

        public DashboardDTOBuilder orderStatus(List<OrderStatusDTO> orderStatus) {
            this.orderStatus = orderStatus;
            return this;
        }

        public DashboardDTOBuilder newUsers(List<UserGrowthDTO> newUsers) {
            this.newUsers = newUsers;
            return this;
        }

        public DashboardDTO build() {
            return new DashboardDTO(summary, dailyRevenue, orderStatus, newUsers);
        }
    }
}
