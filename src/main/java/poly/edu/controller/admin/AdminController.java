package poly.edu.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import poly.edu.entity.AdminLog;
import poly.edu.repository.AdminLogRepository;
import poly.edu.repository.SupportTicketRepository;
import poly.edu.repository.UserRepository;
import poly.edu.service.AdminService;
import poly.edu.service.VietQrManualConfirmationException;
import poly.edu.entity.Inventory;

import java.security.Principal;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;
    private final SupportTicketRepository ticketRepo;
    private final UserRepository userRepository;
    private final AdminLogRepository adminLogRepository;

    @GetMapping({"", "/dashboard"})
    public String dashboard(Model model) {
        try {
            List<Map<String, Object>> rawRevenue = adminService.getMonthlyRevenue();
            model.addAttribute("revenue", rawRevenue);
            
            Double currentMonthRevenue = 0.0;
            if (rawRevenue != null && !rawRevenue.isEmpty()) {
                Object revObj = rawRevenue.get(0).get("revenue");
                if (revObj != null) {
                    currentMonthRevenue = Double.valueOf(revObj.toString());
                }
            }
            model.addAttribute("currentMonthRevenue", currentMonthRevenue);
            
            model.addAttribute("topProducts", adminService.getTopSellingProducts());
            model.addAttribute("pendingCount", adminService.getPendingOrdersCount());
            model.addAttribute("lowStock", adminService.getLowStockItems());
            model.addAttribute("openTickets", ticketRepo.countOpenTickets());
            model.addAttribute("totalCustomers", userRepository.count());
        } catch (Exception e) {
            org.slf4j.LoggerFactory.getLogger(AdminController.class).error("[AdminController] Error populating dashboard data: {}", e.getMessage(), e);
        }
        return "admin/dashboard";
    }

    @GetMapping("/orders")
    public String manageOrders(@RequestParam(name = "keyword", required = false) String keyword, Model model) {
        java.util.List<poly.edu.entity.Order> orders = adminService.getAllOrders();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            orders = orders.stream()
                    .filter(o -> (o.getId() != null && String.valueOf(o.getId()).contains(kw)) ||
                                 (o.getUser() != null && o.getUser().getUsername() != null && o.getUser().getUsername().toLowerCase().contains(kw)) ||
                                 (o.getUser() != null && o.getUser().getFullName() != null && o.getUser().getFullName().toLowerCase().contains(kw)) ||
                                 (o.getStatus() != null && o.getStatus().toLowerCase().contains(kw)) ||
                                 (o.getPhone() != null && o.getPhone().contains(kw)))
                    .collect(java.util.stream.Collectors.toList());
        }
        model.addAttribute("orders", orders);
        model.addAttribute("keyword", keyword);
        return "admin/orders";
    }

    @PostMapping("/orders/update-status")
    public String updateOrderStatus(
            @RequestParam Integer orderId,
            @RequestParam String status,
            Principal principal,
            HttpServletRequest request) {

        adminService.updateOrderStatus(orderId, status);
        logAction(principal, request, "Cập nhật trạng thái đơn hàng: " + status, "Đơn hàng #" + orderId);

        return "redirect:/admin/orders";
    }

    @PostMapping("/orders/confirm-payment")
    public String confirmVietQrPayment(
            @RequestParam Integer orderId,
            Principal principal,
            HttpServletRequest request) {

        adminService.confirmVietQrPayment(orderId);
        logAction(principal, request, "Xác nhận thanh toán VietQR", "Đơn hàng #" + orderId);

        return "redirect:/admin/orders";
    }

    @ExceptionHandler(VietQrManualConfirmationException.class)
    @ResponseBody
    public ResponseEntity<String> manualConfirmationConflict(VietQrManualConfirmationException exception) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(exception.getMessage());
    }

    @PostMapping("/orders/request-refund")
    public String requestRefund(
            @RequestParam Integer orderId,
            @RequestParam(required = false) String note,
            Principal principal,
            HttpServletRequest request) {

        adminService.requestRefund(orderId, note);
        logAction(principal, request, "Yêu cầu hoàn tiền", "Đơn hàng #" + orderId);

        return "redirect:/admin/orders";
    }

    @PostMapping("/orders/approve-refund")
    public String approveRefund(
            @RequestParam Integer orderId,
            @RequestParam(required = false) String note,
            Principal principal,
            HttpServletRequest request) {

        adminService.approveCustomerRefund(orderId, note);
        logAction(principal, request, "Duyệt yêu cầu hoàn tiền", "Đơn hàng #" + orderId);

        return "redirect:/admin/orders";
    }

    @PostMapping("/orders/reject-refund")
    public String rejectRefund(
            @RequestParam Integer orderId,
            @RequestParam(required = false) String note,
            Principal principal,
            HttpServletRequest request) {

        adminService.rejectCustomerRefund(orderId, note);
        logAction(principal, request, "Từ chối hoàn tiền", "Đơn hàng #" + orderId);

        return "redirect:/admin/orders";
    }

    @PostMapping("/orders/confirm-refund")
    public String confirmRefund(
            @RequestParam Integer orderId,
            @RequestParam(required = false) String note,
            Principal principal,
            HttpServletRequest request) {

        adminService.confirmRefund(orderId, note);
        logAction(principal, request, "Xác nhận đã hoàn tiền", "Đơn hàng #" + orderId);

        return "redirect:/admin/orders";
    }

    @PostMapping("/orders/recall")
    public String recallOrder(
            @RequestParam Integer orderId,
            @RequestParam(required = false) String note,
            Principal principal,
            HttpServletRequest request) {

        adminService.recallOrder(orderId, note);
        logAction(principal, request, "Thu hồi đơn hàng", "Đơn hàng #" + orderId);

        return "redirect:/admin/orders";
    }

    @GetMapping("/inventory")
    public String manageInventory(@RequestParam(name = "keyword", required = false) String keyword, Model model) {
        java.util.List<poly.edu.entity.Inventory> inventory = adminService.getFullInventory();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            inventory = inventory.stream()
                    .filter(inv -> (inv.getProduct() != null && inv.getProduct().getName() != null && inv.getProduct().getName().toLowerCase().contains(kw)) ||
                                   (inv.getProduct() != null && inv.getProduct().getId() != null && String.valueOf(inv.getProduct().getId()).contains(kw)) ||
                                   (inv.getProduct() != null && inv.getProduct().getCategory() != null && inv.getProduct().getCategory().getName() != null && inv.getProduct().getCategory().getName().toLowerCase().contains(kw)))
                    .collect(java.util.stream.Collectors.toList());
        }
        model.addAttribute("inventory", inventory);
        model.addAttribute("keyword", keyword);
        return "admin/inventory";
    }

    @PostMapping("/inventory/adjust")
    public String adjustStock(
            @RequestParam Integer productId, 
            @RequestParam(required = false) Integer quantity, 
            @RequestParam String type,
            @RequestParam(required = false) String note,
            Principal principal,
            HttpServletRequest request) {

        if (quantity != null && quantity > 0) {
            adminService.adjustStock(productId, quantity, type, note);
            logAction(principal, request, "Điều chỉnh kho (" + type + " " + quantity + ")", "ProductID #" + productId);
        }
        return "redirect:/admin/inventory";
    }

    private void logAction(Principal principal, HttpServletRequest request, String action, String targetUser) {
        try {
            String username = principal != null ? principal.getName() : "STAFF";
            String ip = request.getHeader("X-Forwarded-For");
            if (ip == null || ip.isBlank() || "unknown".equalsIgnoreCase(ip)) {
                ip = request.getRemoteAddr();
            }
            adminLogRepository.save(new AdminLog(username, action, ip, targetUser));
        } catch (Exception e) {
            // Ignore logging errors
        }
    }
}
