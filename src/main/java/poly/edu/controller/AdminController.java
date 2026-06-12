package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import poly.edu.service.AdminService;
import poly.edu.repository.SupportTicketRepository;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private SupportTicketRepository ticketRepo;

    @GetMapping({"", "/dashboard"})
    public String dashboard(Model model) {
        model.addAttribute("revenue", adminService.getMonthlyRevenue());
        model.addAttribute("topProducts", adminService.getTopSellingProducts());
        model.addAttribute("pendingCount", adminService.getPendingOrdersCount());
        model.addAttribute("lowStock", adminService.getLowStockItems());
        model.addAttribute("openTickets", ticketRepo.countOpenTickets());
        return "admin/dashboard";
    }

    @GetMapping("/orders")
    public String manageOrders(Model model) {
        model.addAttribute("orders", adminService.getAllOrders());
        return "admin/orders";
    }

    @PostMapping("/orders/update-status")
    public String updateOrderStatus(@RequestParam Integer orderId, @RequestParam String status) {
        adminService.updateOrderStatus(orderId, status);
        return "redirect:/admin/orders";
    }

    @PostMapping("/orders/confirm-payment")
    public String confirmVietQrPayment(@RequestParam Integer orderId) {
        adminService.confirmVietQrPayment(orderId);
        return "redirect:/admin/orders";
    }

    @PostMapping("/orders/request-refund")
    public String requestRefund(@RequestParam Integer orderId,
                                @RequestParam(required = false) String note) {
        adminService.requestRefund(orderId, note);
        return "redirect:/admin/orders";
    }

    @PostMapping("/orders/approve-refund")
    public String approveRefund(@RequestParam Integer orderId,
                                @RequestParam(required = false) String note) {
        adminService.approveCustomerRefund(orderId, note);
        return "redirect:/admin/orders";
    }

    @PostMapping("/orders/reject-refund")
    public String rejectRefund(@RequestParam Integer orderId,
                               @RequestParam(required = false) String note) {
        adminService.rejectCustomerRefund(orderId, note);
        return "redirect:/admin/orders";
    }

    @PostMapping("/orders/confirm-refund")
    public String confirmRefund(@RequestParam Integer orderId,
                                @RequestParam(required = false) String note) {
        adminService.confirmRefund(orderId, note);
        return "redirect:/admin/orders";
    }

    @PostMapping("/orders/recall")
    public String recallOrder(@RequestParam Integer orderId,
                              @RequestParam(required = false) String note) {
        adminService.recallOrder(orderId, note);
        return "redirect:/admin/orders";
    }

    @GetMapping("/inventory")
    public String manageInventory(Model model) {
        model.addAttribute("inventory", adminService.getFullInventory());
        return "admin/inventory";
    }

    @PostMapping("/inventory/adjust")
    public String adjustStock(@RequestParam Integer productId, 
                             @RequestParam Integer quantity, 
                             @RequestParam String type,
                             @RequestParam(required = false) String note) {
        adminService.adjustStock(productId, quantity, type, note);
        return "redirect:/admin/inventory";
    }
}
