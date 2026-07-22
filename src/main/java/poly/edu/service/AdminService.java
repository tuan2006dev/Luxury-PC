package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.*;
import poly.edu.entity.*;
import poly.edu.repository.UserRepository;
import poly.edu.dto.dashboard.*;
import java.util.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final OrderDAO orderDAO;

    private final OrderItemDAO orderItemDAO;

    private final InventoryDAO inventoryDAO;

    private final StockMovementDAO stockMovementDAO;
    private final VoucherService voucherService;

    public List<Order> getAllOrders() {
        return orderDAO.findAllOrderedByDate();
    }

    public Order getOrderById(Integer id) {
        return orderDAO.findById(id).orElse(null);
    }

    @Transactional
    public void updateOrderStatus(Integer orderId, String status) {
        Order order = getOrderById(orderId);
        if (order != null && Arrays.asList(
                "PENDING", "PAID", "SHIPPING", "COMPLETED", "DA_HUY", "CANCELLED").contains(status)) {
            
            String oldStatus = order.getStatus();
            order.setStatus(status);
            orderDAO.save(order);
            
            // Voucher lifecycle management
            if (order.getVoucherCode() != null && order.getUser() != null) {
                if ("CANCELLED".equals(status) || "DA_HUY".equals(status)) {
                    voucherService.restoreVoucher(order.getVoucherCode(), order.getUser().getId());
                } else if ("PAID".equals(status) || "COMPLETED".equals(status) || "SHIPPING".equals(status)) {
                    if ("PENDING".equals(oldStatus) || "CHO_XAC_NHAN_THANH_TOAN".equals(oldStatus)) {
                        voucherService.consumeVoucher(order.getVoucherCode(), order.getUser().getId());
                    }
                }
            }
        }
    }

    @Transactional
    public void confirmVietQrPayment(Integer orderId) {
        Order order = getOrderById(orderId);
        if (order != null
                && "VIETQR".equals(order.getPaymentMethod())
                && "CHO_XAC_NHAN_THANH_TOAN".equals(order.getStatus())) {
            order.setStatus("DA_THANH_TOAN");
            orderDAO.save(order);
            
            if (order.getVoucherCode() != null && order.getUser() != null) {
                voucherService.consumeVoucher(order.getVoucherCode(), order.getUser().getId());
            }
        }
    }

    @Transactional
    public void requestRefund(Integer orderId, String note) {
        Order order = getOrderById(orderId);
        if (order != null
                && "VIETQR".equals(order.getPaymentMethod())
                && isStatus(order, "DA_THANH_TOAN", "PAID")) {
            order.setStatus("CHO_HOAN_TIEN");
            order.setAdminNote(normalizeNote(note));
            orderDAO.save(order);
        }
    }

    @Transactional
    public void approveCustomerRefund(Integer orderId, String note) {
        Order order = getOrderById(orderId);
        if (order != null && isStatus(order, "YEU_CAU_HOAN_TIEN")) {
            order.setStatus("CHO_HOAN_TIEN");
            order.setAdminNote(mergeNote(order.getAdminNote(), note));
            orderDAO.save(order);
        }
    }

    @Transactional
    public void rejectCustomerRefund(Integer orderId, String note) {
        Order order = getOrderById(orderId);
        if (order != null && isStatus(order, "YEU_CAU_HOAN_TIEN")) {
            String previousStatus = order.getRefundPreviousStatus();
            order.setStatus(isStatusValue(previousStatus, "DA_THANH_TOAN", "PAID", "COMPLETED", "HOAN_THANH")
                    ? previousStatus
                    : "DA_THANH_TOAN");
            order.setAdminNote(mergeNote(order.getAdminNote(), note));
            order.setRefundPreviousStatus(null);
            orderDAO.save(order);
        }
    }

    @Transactional
    public void confirmRefund(Integer orderId, String note) {
        Order order = getOrderById(orderId);
        if (order != null && isStatus(order, "CHO_HOAN_TIEN")) {
            order.setStatus("DA_HOAN_TIEN");
            order.setAdminNote(mergeNote(order.getAdminNote(), note));
            orderDAO.save(order);
        }
    }

    @Transactional
    public void recallOrder(Integer orderId, String note) {
        Order order = getOrderById(orderId);
        if (order != null && isStatus(order, "DA_THANH_TOAN", "PAID", "SHIPPING", "COMPLETED",
                "HOAN_THANH", "YEU_CAU_HOAN_TIEN", "CHO_HOAN_TIEN")) {
            order.setStatus("THU_HOI");
            order.setAdminNote(mergeNote(order.getAdminNote(), note));
            orderDAO.save(order);
        }
    }

    private boolean isStatus(Order order, String... statuses) {
        return Arrays.asList(statuses).contains(order.getStatus());
    }

    private boolean isStatusValue(String status, String... statuses) {
        return Arrays.asList(statuses).contains(status);
    }

    private String normalizeNote(String note) {
        return note == null || note.isBlank() ? null : note.trim();
    }

    private String mergeNote(String currentNote, String newNote) {
        String normalizedNewNote = normalizeNote(newNote);
        if (normalizedNewNote == null) return currentNote;
        if (currentNote == null || currentNote.isBlank()) return normalizedNewNote;
        return currentNote + " | " + normalizedNewNote;
    }

    public List<Map<String, Object>> getMonthlyRevenue() {
        return orderDAO.getMonthlyRevenue();
    }

    public DashboardDTO getDashboardStats(LocalDate start, LocalDate end) {
        ZoneId defaultZone = ZoneId.systemDefault();
        Date startDate = Date.from(start.atStartOfDay(defaultZone).toInstant());
        Date endDate = Date.from(end.atTime(LocalTime.MAX).atZone(defaultZone).toInstant());

        Double revenue = orderDAO.getRevenueBetween(startDate, endDate);
        if (revenue == null) revenue = 0.0;
        Long ordersCount = orderDAO.countOrdersBetween(startDate, endDate);
        if (ordersCount == null) ordersCount = 0L;
        Long customersCount = userRepository.countCustomersBetween(startDate, endDate);
        if (customersCount == null) customersCount = 0L;

        SummaryDTO summary = SummaryDTO.builder()
                .revenue(revenue)
                .orders(ordersCount)
                .customers(customersCount)
                .build();

        List<Map<String, Object>> rawDailyRevenue = orderDAO.getDailyRevenueBetween(startDate, endDate);
        List<RevenueDTO> dailyRevenue = new ArrayList<>();
        if (rawDailyRevenue != null) {
            for (Map<String, Object> map : rawDailyRevenue) {
                Object d = map.get("date");
                Object r = map.get("revenue");
                if (d != null) {
                    dailyRevenue.add(new RevenueDTO(d.toString(), r != null ? Double.valueOf(r.toString()) : 0.0));
                }
            }
        }

        List<Map<String, Object>> rawOrderStatus = orderDAO.getOrderStatusBetween(startDate, endDate);
        List<OrderStatusDTO> orderStatus = new ArrayList<>();
        if (rawOrderStatus != null) {
            for (Map<String, Object> map : rawOrderStatus) {
                Object s = map.get("status");
                Object c = map.get("count");
                if (s != null) {
                    orderStatus.add(new OrderStatusDTO(s.toString(), c != null ? Long.valueOf(c.toString()) : 0L));
                }
            }
        }

        List<Map<String, Object>> rawNewUsers = userRepository.getNewUsersBetween(startDate, endDate);
        List<UserGrowthDTO> newUsers = new ArrayList<>();
        if (rawNewUsers != null) {
            for (Map<String, Object> map : rawNewUsers) {
                Object d = map.get("date");
                Object c = map.get("count");
                if (d != null) {
                    newUsers.add(new UserGrowthDTO(d.toString(), c != null ? Long.valueOf(c.toString()) : 0L));
                }
            }
        }

        return DashboardDTO.builder()
                .summary(summary)
                .dailyRevenue(dailyRevenue)
                .orderStatus(orderStatus)
                .newUsers(newUsers)
                .build();
    }

    public List<Map<String, Object>> getDailyRevenue(int days) {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, -days);
        return orderDAO.getDailyRevenue(cal.getTime());
    }

    public List<Map<String, Object>> getOrderStatusStats(int days) {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, -days);
        return orderDAO.getOrderStatusStats(cal.getTime());
    }

    private final UserRepository userRepository;

    public List<Map<String, Object>> getNewUsersByDate(int days) {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, -days);
        return userRepository.getNewUsersByDate(cal.getTime());
    }

    public List<Map<String, Object>> getTopSellingProducts() {
        // Limit to 5
        List<Map<String, Object>> all = orderItemDAO.findTopSellingProducts();
        return all.size() > 5 ? all.subList(0, 5) : all;
    }

    public long getPendingOrdersCount() {
        return orderDAO.countPendingOrders();
    }

    public List<Inventory> getLowStockItems() {
        return inventoryDAO.findLowStockItems();
    }

    private final ProductDAO productDAO;

    public List<Inventory> getFullInventory() {
        return inventoryDAO.findAllWithProductAndCategory();
    }

    @Transactional
    public void adjustStock(Integer productId, Integer quantity, String type, String note) {
        Product product = productDAO.findById(productId).orElse(null);
        if (product == null) return;

        Inventory inventory = inventoryDAO.findByProductId(productId)
                .orElse(new Inventory());
        
        if (inventory.getProduct() == null) {
            inventory.setProduct(product);
            inventory.setQuantity(0);
        }

        if ("IMPORT".equals(type)) {
            inventory.setQuantity(inventory.getQuantity() + quantity);
        } else {
            inventory.setQuantity(Math.max(0, inventory.getQuantity() - quantity));
        }
        
        inventoryDAO.save(inventory);

        // Update product stock field as well for synchronization
        product.setStock(inventory.getQuantity());
        productDAO.save(product);

        StockMovement movement = new StockMovement();
        movement.setProduct(product);
        movement.setChangeQuantity(quantity);
        movement.setMovementType(type);
        movement.setNote(note);
        stockMovementDAO.save(movement);
    }
}
