package poly.edu.service;

import lombok.RequiredArgsConstructor;
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
    private final EmailService emailService;
    private final UserRepository userRepository;
    private final ProductDAO productDAO;

    public List<Order> getAllOrders() {
        return orderDAO.findAllOrderedByDate();
    }

    public Order getOrderById(Integer id) {
        return orderDAO.findById(id).orElse(null);
    }

    @Transactional(readOnly = true)
    public poly.edu.dto.admin.AdminOrderDetailDTO getOrderDetailDTO(Integer id) {
        Order order = orderDAO.findByIdWithDetails(id).orElseGet(() -> getOrderById(id));
        if (order == null) {
            return null;
        }

        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
        String formattedDate = order.getCreatedAt() != null ? sdf.format(order.getCreatedAt()) : "-";

        List<poly.edu.dto.admin.AdminOrderItemDTO> itemDTOs = new ArrayList<>();
        double calculatedSubtotal = 0.0;

        List<OrderItem> items = order.getOrderItems();
        if (items == null || items.isEmpty()) {
            items = orderItemDAO.findByOrderIdWithProduct(order.getId());
        }

        if (items != null) {
            for (OrderItem oi : items) {
                if (oi == null) continue;
                Product p = oi.getProduct();
                double itemPrice = oi.getPrice() != null ? oi.getPrice() : (p != null && p.getPrice() != null ? p.getPrice() : 0.0);
                int qty = oi.getQuantity() != null ? oi.getQuantity() : 1;
                double lineTotal = itemPrice * qty;
                calculatedSubtotal += lineTotal;

                String pName = (p != null && p.getName() != null && !p.getName().isBlank())
                        ? p.getName()
                        : "Sản phẩm #" + (p != null && p.getId() != null ? p.getId() : oi.getId());
                String pImg = p != null ? p.getImage() : null;
                String pBrand = p != null ? p.getBrand() : null;
                String pCat = (p != null && p.getCategory() != null) ? p.getCategory().getName() : null;

                itemDTOs.add(poly.edu.dto.admin.AdminOrderItemDTO.builder()
                        .id(oi.getId())
                        .productId(p != null ? p.getId() : null)
                        .productName(pName)
                        .productImage(pImg)
                        .brand(pBrand)
                        .categoryName(pCat)
                        .price(itemPrice)
                        .quantity(qty)
                        .itemTotal(lineTotal)
                        .build());
            }
        }

        String badgeClass = "badge-" + (order.getStatus() != null ? order.getStatus().toLowerCase() : "pending");

        return poly.edu.dto.admin.AdminOrderDetailDTO.builder()
                .id(order.getId())
                .orderCode(order.getOrderCode() != null ? order.getOrderCode() : ("DH" + order.getId()))
                .createdAt(order.getCreatedAt())
                .createdAtFormatted(formattedDate)
                .status(order.getStatus())
                .statusDisplay(order.getStatusDisplay())
                .statusBadgeClass(badgeClass)
                .paymentMethod(order.getPaymentMethod())
                .paymentMethodDisplay(order.getPaymentMethodDisplay())
                .userId(order.getUser() != null ? order.getUser().getId() : null)
                .username(order.getUser() != null ? order.getUser().getUsername() : null)
                .fullName(order.getFullName())
                .email(order.getEmail())
                .phone(order.getPhone())
                .address(order.getAddress())
                .city(order.getCity())
                .shippingMethodName(order.getShippingMethodName())
                .shippingFee(order.getShippingFee() != null ? order.getShippingFee() : 0.0)
                .trackingCode(order.getTrackingCode())
                .subtotal(calculatedSubtotal)
                .voucherCode(order.getVoucherCode())
                .discountAmount(order.getDiscountAmount() != null ? order.getDiscountAmount() : 0.0)
                .freeshipVoucherCode(order.getFreeshipVoucherCode())
                .freeshipDiscount(order.getFreeshipDiscount() != null ? order.getFreeshipDiscount() : 0.0)
                .vipDiscount(order.getVipDiscount() != null ? order.getVipDiscount() : 0.0)
                .totalPrice(order.getTotalPrice() != null ? order.getTotalPrice() : 0.0)
                .adminNote(order.getAdminNote())
                .refundReason(order.getRefundReason())
                .refundPreviousStatus(order.getRefundPreviousStatus())
                .items(itemDTOs)
                .build();
    }

    @Transactional
    public void updateOrderStatus(Integer orderId, String status) {
        Order order = getOrderById(orderId);
        if (order != null && isVietQrPayment(order)
                && isStatusValue(status, "PAID", "DA_THANH_TOAN", "CHO_XAC_NHAN_THANH_TOAN")) {
            throw new VietQrManualConfirmationException();
        }
        if (order != null && isWaitingVietQr(order)
                && !isStatusValue(status, "DA_HUY", "CANCELLED")) {
            throw new VietQrManualConfirmationException();
        }
        if (order != null && Arrays.asList(
                "PENDING", "PROCESSING", "DANG_XU_LY", "SHIPPING", "DANG_GIAO",
                "PAID", "COMPLETED", "HOAN_THANH", "DA_HUY", "CANCELLED").contains(status)) {
            if (Objects.equals(order.getStatus(), status)) {
                return;
            }
            if (!isAllowedOrderStatusTransition(order, status)) {
                throw new IllegalStateException("Chuyển trạng thái đơn hàng không hợp lệ.");
            }

            
            String oldStatus = order.getStatus();
            order.setStatus(status);
            orderDAO.save(order);
            emailService.sendOrderStatusUpdateEmail(order.getUser(), order, status);
            
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

    private boolean isAllowedOrderStatusTransition(Order order, String nextStatus) {
        String currentStatus = order.getStatus();
        if (currentStatus == null) return false;
        if ("COD".equalsIgnoreCase(order.getPaymentMethod())) {
            return isAllowedCodTransition(currentStatus, nextStatus);
        }
        return isAllowedPrepaidTransition(currentStatus, nextStatus);
    }

    private boolean isAllowedCodTransition(String currentStatus, String nextStatus) {
        return switch (currentStatus) {
            case "PENDING" ->
                    isStatusValue(nextStatus, "PROCESSING", "DANG_XU_LY", "DA_HUY", "CANCELLED");
            case "PROCESSING", "DANG_XU_LY" ->
                    isStatusValue(nextStatus, "SHIPPING", "DANG_GIAO", "DA_HUY", "CANCELLED");
            case "SHIPPING", "DANG_GIAO" ->
                    isStatusValue(nextStatus, "PAID", "DA_HUY", "CANCELLED");
            case "PAID", "DA_THANH_TOAN" ->
                    isStatusValue(nextStatus, "COMPLETED", "HOAN_THANH", "DA_HUY", "CANCELLED");
            default -> false;
        };
    }

    private boolean isAllowedPrepaidTransition(String currentStatus, String nextStatus) {
        return switch (currentStatus) {
            case "PENDING", "CHO_THANH_TOAN", "CHO_XAC_NHAN_THANH_TOAN" ->
                    isStatusValue(nextStatus, "DA_HUY", "CANCELLED");
            case "DA_THANH_TOAN", "PAID" ->
                    isStatusValue(nextStatus, "PROCESSING", "DANG_XU_LY", "DA_HUY", "CANCELLED");
            case "PROCESSING", "DANG_XU_LY" ->
                    isStatusValue(nextStatus, "SHIPPING", "DANG_GIAO", "DA_HUY", "CANCELLED");
            case "SHIPPING", "DANG_GIAO" ->
                    isStatusValue(nextStatus, "COMPLETED", "HOAN_THANH", "DA_HUY", "CANCELLED");
            default -> false;
        };
    }
    private boolean isWaitingVietQr(Order order) {
        return isVietQrPayment(order)
                && isStatus(order, "PENDING", "CHO_THANH_TOAN", "CHO_XAC_NHAN_THANH_TOAN");
    }

    private boolean isVietQrPayment(Order order) {
        return isStatusValue(
                order.getPaymentMethod() == null ? null : order.getPaymentMethod().toUpperCase(Locale.ROOT),
                "VIETQR", "SEPAY");
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

    private Object getMapValue(Map<String, Object> map, String... keys) {
        if (map == null) return null;
        for (String key : keys) {
            if (map.containsKey(key) && map.get(key) != null) return map.get(key);
            if (map.containsKey(key.toUpperCase()) && map.get(key.toUpperCase()) != null) return map.get(key.toUpperCase());
            if (map.containsKey(key.toLowerCase()) && map.get(key.toLowerCase()) != null) return map.get(key.toLowerCase());
        }
        return null;
    }

    private String toStr(Object obj) {
        if (obj == null) return null;
        if (obj instanceof byte[] bytes) {
            return new String(bytes, java.nio.charset.StandardCharsets.UTF_8);
        }
        return obj.toString();
    }

    private Double toDouble(Object obj) {
        if (obj == null) return 0.0;
        try {
            if (obj instanceof Number num) return num.doubleValue();
            String str = toStr(obj);
            return str != null ? Double.valueOf(str) : 0.0;
        } catch (Exception e) {
            return 0.0;
        }
    }

    private Long toLong(Object obj) {
        if (obj == null) return 0L;
        try {
            if (obj instanceof Number num) return num.longValue();
            String str = toStr(obj);
            return str != null ? Long.valueOf(str) : 0L;
        } catch (Exception e) {
            return 0L;
        }
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
                Object d = getMapValue(map, "date", "DATE");
                Object r = getMapValue(map, "revenue", "REVENUE");
                String dateStr = toStr(d);
                if (dateStr != null && !dateStr.isBlank()) {
                    dailyRevenue.add(new RevenueDTO(dateStr, toDouble(r)));
                }
            }
        }

        List<Map<String, Object>> rawOrderStatus = orderDAO.getOrderStatusBetween(startDate, endDate);
        List<OrderStatusDTO> orderStatus = new ArrayList<>();
        if (rawOrderStatus != null) {
            for (Map<String, Object> map : rawOrderStatus) {
                Object s = getMapValue(map, "status", "STATUS");
                Object c = getMapValue(map, "count", "COUNT");
                String statusStr = toStr(s);
                if (statusStr != null && !statusStr.isBlank()) {
                    orderStatus.add(new OrderStatusDTO(statusStr, toLong(c)));
                }
            }
        }

        List<Map<String, Object>> rawNewUsers = userRepository.getNewUsersBetween(startDate, endDate);
        List<UserGrowthDTO> newUsers = new ArrayList<>();
        if (rawNewUsers != null) {
            for (Map<String, Object> map : rawNewUsers) {
                Object d = getMapValue(map, "date", "DATE");
                Object c = getMapValue(map, "count", "COUNT");
                String dateStr = toStr(d);
                if (dateStr != null && !dateStr.isBlank()) {
                    newUsers.add(new UserGrowthDTO(dateStr, toLong(c)));
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

    public List<Inventory> getFullInventory() {
        return inventoryDAO.findAllWithProductAndCategory();
    }

    public org.springframework.data.domain.Page<Inventory> getInventoryPage(String keyword, int page, int size) {
        org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(page, size);
        if (keyword != null && !keyword.trim().isEmpty()) {
            return inventoryDAO.searchWithProductAndCategory(keyword.trim(), pageable);
        }
        return inventoryDAO.findAllWithProductAndCategory(pageable);
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
