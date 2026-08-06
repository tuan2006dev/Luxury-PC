package poly.edu.controller.api;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import poly.edu.dto.LalamoveWebhookDTO;
import poly.edu.entity.Order;
import poly.edu.service.OrderService;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/webhook")
@RequiredArgsConstructor
public class LalamoveWebhookController {

    private final OrderService orderService;

    @PostMapping("/lalamove")
    public ResponseEntity<Map<String, Object>> lalamoveWebhook(@RequestBody LalamoveWebhookDTO payload) {
        Map<String, Object> response = new HashMap<>();
        try {
            Order updatedOrder = orderService.processLalamoveWebhook(payload);
            response.put("success", true);
            response.put("message", "Cập nhật trạng thái giao hàng thành công.");
            response.put("orderId", updatedOrder.getId());
            response.put("trackingCode", updatedOrder.getTrackingCode());
            response.put("status", updatedOrder.getStatus());
            response.put("statusDisplay", updatedOrder.getStatusDisplay());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}
