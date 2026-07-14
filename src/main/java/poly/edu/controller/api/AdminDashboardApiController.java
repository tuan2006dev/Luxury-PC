package poly.edu.controller.api;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import poly.edu.service.AdminService;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/dashboard")
@RequiredArgsConstructor
public class AdminDashboardApiController {

    private final AdminService adminService;

    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getDashboardStats(
            @RequestParam(defaultValue = "30") int days) {
        
        Map<String, Object> response = new HashMap<>();
        response.put("dailyRevenue", adminService.getDailyRevenue(days));
        response.put("orderStatusStats", adminService.getOrderStatusStats(days));
        response.put("newUsersByDate", adminService.getNewUsersByDate(days));

        return ResponseEntity.ok(response);
    }
}
