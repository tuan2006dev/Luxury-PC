package poly.edu.dto.dashboard;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
public class SummaryDTO {
    private Double revenue;
    private Long orders;
    private Long customers;

    public SummaryDTO(Double revenue, Long orders, Long customers) {
        this.revenue = revenue;
        this.orders = orders;
        this.customers = customers;
    }

    public static SummaryDTOBuilder builder() {
        return new SummaryDTOBuilder();
    }

    public static class SummaryDTOBuilder {
        private Double revenue;
        private Long orders;
        private Long customers;

        public SummaryDTOBuilder revenue(Double revenue) {
            this.revenue = revenue;
            return this;
        }

        public SummaryDTOBuilder orders(Long orders) {
            this.orders = orders;
            return this;
        }

        public SummaryDTOBuilder customers(Long customers) {
            this.customers = customers;
            return this;
        }

        public SummaryDTO build() {
            return new SummaryDTO(revenue, orders, customers);
        }
    }
}
