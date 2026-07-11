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

    @GetMapping("/calculate")
    public ResponseEntity<List<Map<String, Object>>> calculateShipping(@RequestParam(required = false) String provinceCode) {
        List<Map<String, Object>> methods = new ArrayList<>();
        
        // Base case: store pickup is always available
        methods.add(createMethod("STORE", "Nhận tại cửa hàng", "Khách hàng tới nhận hàng trực tiếp", 0, "fa-solid fa-store"));

        // If no province is selected, we only show default standard
        if (provinceCode == null || provinceCode.trim().isEmpty()) {
            methods.add(createMethod("STANDARD", "Giao hàng tiêu chuẩn", "Giao hàng trong 2-3 ngày", 30000, "fa-solid fa-truck"));
            return ResponseEntity.ok(methods);
        }

        // Logic based on provinceCode (provinces.open-api.vn uses string codes like "79" for HCM, "01" for HN)
        if ("79".equals(provinceCode)) { 
            // Ho Chi Minh City (Zone 1)
            methods.add(createMethod("EXPRESS", "Giao hỏa tốc 2H", "Nhận hàng ngay trong 2 tiếng", 50000, "fa-solid fa-bolt"));
            methods.add(createMethod("STANDARD", "Giao hàng tiêu chuẩn", "Nhận hàng trong vòng 24h", 20000, "fa-solid fa-truck"));
        } else if ("74".equals(provinceCode) || "75".equals(provinceCode) || "77".equals(provinceCode) || "80".equals(provinceCode)) {
            // Nearby South provinces (Binh Duong, Dong Nai, BR-VT, Long An)
            methods.add(createMethod("STANDARD", "Giao hàng tiêu chuẩn", "Giao hàng trong 1-2 ngày", 30000, "fa-solid fa-truck"));
            methods.add(createMethod("EXPRESS", "Giao nhanh", "Giao trong ngày hôm sau", 40000, "fa-solid fa-bolt"));
        } else {
            // Other provinces (North, Central)
            methods.add(createMethod("STANDARD", "Giao hàng toàn quốc", "Thời gian giao hàng 3-5 ngày", 50000, "fa-solid fa-truck-fast"));
        }

        // Move Store Pickup to the bottom
        Map<String, Object> storePickup = methods.remove(0);
        methods.add(storePickup);

        return ResponseEntity.ok(methods);
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
