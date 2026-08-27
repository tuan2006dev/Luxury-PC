package poly.edu.dto.dashboard;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
public class UserGrowthDTO {
    private String date;
    private Long count;

    public UserGrowthDTO(String date, Long count) {
        this.date = date;
        this.count = count;
    }
}
