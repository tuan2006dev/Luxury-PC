package poly.edu.controller.api;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import poly.edu.dto.dashboard.DashboardDTO;
import poly.edu.service.AdminService;

import java.time.LocalDate;
import java.time.YearMonth;

@RestController
@RequestMapping("/api/admin/dashboard")
@RequiredArgsConstructor
public class AdminDashboardApiController {

    private final AdminService adminService;

    @GetMapping("/stats")
    public ResponseEntity<DashboardDTO> getDashboardStats(
            @RequestParam(required = false) String range,
            @RequestParam(required = false) String start,
            @RequestParam(required = false) String end) {

        try {
            LocalDate startDate = null;
            LocalDate endDate = null;

            if (start != null && !start.isBlank() && end != null && !end.isBlank()) {
                try {
                    startDate = LocalDate.parse(start.trim());
                    endDate = LocalDate.parse(end.trim());
                } catch (Exception ex) {
                    // Fallback to default if date string format is invalid
                }
            }

            if (startDate == null || endDate == null) {
                LocalDate now = LocalDate.now();
                String rangeVal = (range != null && !range.isBlank()) ? range : "30d";

                switch (rangeVal) {
                    case "today":
                        startDate = now;
                        endDate = now;
                        break;
                    case "yesterday":
                        startDate = now.minusDays(1);
                        endDate = now.minusDays(1);
                        break;
                    case "7d":
                        startDate = now.minusDays(6);
                        endDate = now;
                        break;
                    case "thisMonth":
                        startDate = now.withDayOfMonth(1);
                        endDate = now;
                        break;
                    case "lastMonth":
                        YearMonth lastM = YearMonth.now().minusMonths(1);
                        startDate = lastM.atDay(1);
                        endDate = lastM.atEndOfMonth();
                        break;
                    case "30d":
                    default:
                        startDate = now.minusDays(29);
                        endDate = now;
                        break;
                }
            }

            DashboardDTO dto = adminService.getDashboardStats(startDate, endDate);
            return ResponseEntity.ok(dto);
        } catch (Exception e) {
            org.slf4j.LoggerFactory.getLogger(AdminDashboardApiController.class).error("[DashboardAPI] Error fetching dashboard stats", e);
            return ResponseEntity.ok(DashboardDTO.builder()
                    .summary(new poly.edu.dto.dashboard.SummaryDTO(0.0, 0L, 0L))
                    .dailyRevenue(java.util.Collections.emptyList())
                    .orderStatus(java.util.Collections.emptyList())
                    .newUsers(java.util.Collections.emptyList())
                    .build());
        }
    }
}
