package poly.edu.controller.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/shipping")
public class ShippingApiController {

    // Địa điểm kho cửa hàng: 1011 Tân Kỳ Tân Quý, TP. Hồ Chí Minh
    private static final double STORE_LAT = 10.80352;
    private static final double STORE_LNG = 106.60225;
    private static final int RATE_PER_KM = 5000; // 5.000đ / km

    @GetMapping("/calculate")
    public ResponseEntity<List<Map<String, Object>>> calculateShipping(
            @RequestParam(required = false) String provinceCode,
            @RequestParam(required = false) String districtName,
            @RequestParam(required = false) Double lat,
            @RequestParam(required = false) Double lng) {

        List<Map<String, Object>> methods = new ArrayList<>();

        // 1. Giao hàng hỏa tốc 2H (Dựa trên khoảng cách từ 1011 Tân Kỳ Tân Quý x 5.000đ/km)
        if (lat != null && lng != null) {
            double distanceKm = calculateHaversineDistance(STORE_LAT, STORE_LNG, lat, lng) * 1.3; // Hệ số đường bộ
            distanceKm = Math.round(distanceKm * 10.0) / 10.0;
            if (distanceKm < 1.0) distanceKm = 1.0;

            int fee = (int) Math.round(distanceKm * RATE_PER_KM / 1000.0) * 1000;
            if (fee < 15000) fee = 15000; // Tối thiểu 15.000đ

            String desc = String.format("Khoảng cách ~ %.1f km (Từ kho 1011 Tân Kỳ Tân Quý) • 5.000đ/km", distanceKm);
            methods.add(createMethod("EXPRESS", "Giao hỏa tốc 2H", desc, fee, "fa-solid fa-bolt"));
        } else if ("79".equals(provinceCode)) { // TP.HCM
            double estimatedKm = estimateDistrictDistance(districtName);
            int fee = (int) Math.round(estimatedKm * RATE_PER_KM / 1000.0) * 1000;
            if (fee < 15000) fee = 15000;

            String desc = String.format("Giao hỏa tốc 2H từ 1011 Tân Kỳ Tân Quý (~ %.1f km • 5.000đ/km)", estimatedKm);
            methods.add(createMethod("EXPRESS", "Giao hỏa tốc 2H", desc, fee, "fa-solid fa-bolt"));
        }

        // 2. Giao hàng tiêu chuẩn
        if ("79".equals(provinceCode)) {
            methods.add(createMethod("STANDARD", "Giao hàng tiêu chuẩn", "Nhận hàng trong vòng 24h", 20000, "fa-solid fa-truck"));
        } else if ("74".equals(provinceCode) || "75".equals(provinceCode) || "77".equals(provinceCode) || "80".equals(provinceCode)) {
            methods.add(createMethod("STANDARD", "Giao hàng tiêu chuẩn", "Giao hàng trong 1-2 ngày", 30000, "fa-solid fa-truck"));
        } else if (provinceCode != null && !provinceCode.isEmpty()) {
            methods.add(createMethod("STANDARD", "Giao hàng toàn quốc", "Thời gian giao hàng 3-5 ngày", 45000, "fa-solid fa-truck-fast"));
        } else {
            methods.add(createMethod("STANDARD", "Giao hàng tiêu chuẩn", "Giao hàng trong 2-3 ngày", 30000, "fa-solid fa-truck"));
        }

        // 3. Nhận tại cửa hàng (Miễn phí)
        methods.add(createMethod("STORE", "Nhận tại cửa hàng", "Đến nhận trực tiếp tại 1011 Tân Kỳ Tân Quý, TP.HCM", 0, "fa-solid fa-store"));

        return ResponseEntity.ok(methods);
    }

    private double calculateHaversineDistance(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371; // Bán kính Trái Đất theo km
        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    private double estimateDistrictDistance(String districtName) {
        if (districtName == null) return 6.0;
        String d = districtName.toLowerCase();

        if (d.contains("bình tân")) return 3.5;
        if (d.contains("tân phú")) return 4.0;
        if (d.contains("tân bình")) return 5.5;
        if (d.contains("quận 12") || d.contains("12")) return 7.0;
        if (d.contains("quận 11") || d.contains("quận 6") || d.contains("11") || d.contains("6")) return 7.5;
        if (d.contains("quận 10") || d.contains("quận 5") || d.contains("10") || d.contains("5")) return 9.0;
        if (d.contains("phú nhuận") || d.contains("gò vấp")) return 10.0;
        if (d.contains("quận 1") || d.contains("quận 3") || d.contains("1") || d.contains("3")) return 11.5;
        if (d.contains("quận 8") || d.contains("quận 4") || d.contains("8") || d.contains("4")) return 13.0;
        if (d.contains("quận 7") || d.contains("7")) return 16.0;
        if (d.contains("thủ đức") || d.contains("quận 2") || d.contains("quận 9")) return 18.5;
        if (d.contains("bình chánh") || d.contains("hóc môn")) return 12.0;
        if (d.contains("củ chi") || d.contains("nhà bè") || d.contains("cần giờ")) return 28.0;

        return 7.0;
    }

    private Map<String, Object> createMethod(String id, String name, String description, int fee, String icon) {
        Map<String, Object> method = new HashMap<>();
        method.put("id", id);
        method.put("name", name);
        method.put("description", description);
        method.put("fee", fee);
        method.put("icon", icon);
        return method;
    }
}
