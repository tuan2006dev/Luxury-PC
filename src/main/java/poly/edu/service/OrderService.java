package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.*;
import poly.edu.entity.*;
import poly.edu.exception.OutOfStockException;

import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final ProductDAO productDAO;

    private final InventoryDAO inventoryDAO;

    private final OrderDAO orderDAO;

    private final OrderItemDAO orderItemDAO;

    private final StockMovementDAO stockMovementDAO;

    private final FlashSaleService flashSaleService;

    private final UserVoucherService userVoucherService;

    @Transactional
    public Order placeOrder(Map<Integer, CartItem> cart, String fullName, String phone, String address, 
                            User currentUser, double finalPrice, double voucherDiscount, String appliedVoucherCode) {
        
        // 1. Lock and validate stock for all items first to ensure consistency
        for (CartItem item : cart.values()) {
            Product product = productDAO.findByIdForUpdate(item.getId())
                    .orElseThrow(() -> new OutOfStockException("Sản phẩm có ID " + item.getId() + " không tồn tại."));
            
            if (product.getStock() == null || product.getStock() < item.getQuantity()) {
                int available = product.getStock() != null ? product.getStock() : 0;
                throw new OutOfStockException("Sản phẩm '" + product.getName() + "' chỉ còn " + available + " chiếc trong kho. Vui lòng cập nhật lại giỏ hàng.");
            }
        }

        // 1b. Kiểm tra giới hạn lượt mua Flash Sale mỗi user
        if (currentUser != null) {
            java.util.Optional<poly.edu.entity.FlashSale> activeFlashSale = flashSaleService.getCurrentFlashSale();
            if (activeFlashSale.isPresent()) {
                poly.edu.entity.FlashSale fs = activeFlashSale.get();
                if (fs.getMaxPerUser() != null && fs.getMaxPerUser() > 0) {
                    long alreadyBought = orderItemDAO.countFlashSalePurchasesByUser(currentUser.getId(), fs.getId());
                    // Tính số sản phẩm flash sale trong đơn hiện tại
                    long inThisOrder = cart.values().stream()
                        .filter(ci -> flashSaleService.getEffectivePrice(ci.getId()) < ci.getPrice())
                        .mapToLong(ci -> ci.getQuantity())
                        .sum();
                    if (alreadyBought + inThisOrder > fs.getMaxPerUser()) {
                        throw new OutOfStockException(
                            "Bạn chỉ được mua tối đa " + fs.getMaxPerUser() +
                            " sản phẩm Flash Sale '" + fs.getName() +
                            "'. Bạn đã mua " + alreadyBought + " sản phẩm trước đó."
                        );
                    }
                }
            }
        }

        // 2. Create and save the order
        Order order = new Order();
        if (currentUser != null) {
            order.setUser(currentUser);
            order.setEmail(currentUser.getEmail());
        }
        order.setFullName(fullName);
        order.setPhone(phone);
        order.setAddress(address);
        order.setTotalPrice((double) Math.round(finalPrice));
        order.setVoucherCode(appliedVoucherCode);
        order.setDiscountAmount(voucherDiscount);
        order.setStatus("PENDING");
        Order savedOrder = orderDAO.save(order);

        // 3. Deduct stock, save order items, sync inventory, and log stock movements
        for (CartItem item : cart.values()) {
            // Retrieve again under lock to be safe
            Product product = productDAO.findByIdForUpdate(item.getId()).get();
            
            // Deduct stock in Product entity
            int curStock = product.getStock() != null ? product.getStock() : 0;
            product.setStock(Math.max(0, curStock - item.getQuantity()));
            productDAO.save(product);

            // Sync with Inventory table
            Optional<Inventory> invOpt = inventoryDAO.findByProductId(product.getId());
            if (invOpt.isPresent()) {
                Inventory inv = invOpt.get();
                inv.setQuantity(product.getStock());
                inventoryDAO.save(inv);
            }

            // Record StockMovement as EXPORT
            StockMovement movement = new StockMovement();
            movement.setProduct(product);
            movement.setChangeQuantity(item.getQuantity());
            movement.setMovementType("EXPORT");
            movement.setNote("Khách mua hàng - Đơn hàng #" + savedOrder.getId());
            stockMovementDAO.save(movement);

            // Create OrderItem
            OrderItem oi = new OrderItem();
            oi.setOrder(savedOrder);
            oi.setProduct(product);
            oi.setPrice(item.getPrice());
            oi.setQuantity(item.getQuantity());
            orderItemDAO.save(oi);

            // Increment sold count for Flash Sale (supporting quantity)
            flashSaleService.incrementSoldCount(product.getId(), item.getQuantity());
        }

        // 4. Mark voucher as used in the wallet
        if (appliedVoucherCode != null && currentUser != null) {
            userVoucherService.markVoucherAsUsed(currentUser, appliedVoucherCode);
        }

        return savedOrder;
    }

    private final EmailService emailService;
    private final VoucherService voucherService;
    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(OrderService.class);

    @Transactional
    public void cancelOrderByUser(Integer orderId, Integer userId) {
        Order order = orderDAO.findById(orderId).orElse(null);
        if (order == null || !order.getUser().getId().equals(userId)) {
            throw new IllegalArgumentException("Đơn hàng không tồn tại hoặc không thuộc về bạn.");
        }

        String status = order.getStatus();
        String paymentMethod = order.getPaymentMethod();
        boolean isCancelable = "PENDING".equals(status) || ("PAID".equals(status) && !"COD".equals(paymentMethod));
        if (!isCancelable) {
            throw new IllegalStateException("Đơn hàng hiện tại không thể hủy.");
        }

        // Cập nhật trạng thái
        order.setStatus("CANCELED");
        orderDAO.save(order);

        // Khôi phục số lượng tồn kho
        if (order.getOrderItems() != null) {
            for (OrderItem item : order.getOrderItems()) {
                Product product = item.getProduct();
                if (product != null) {
                    Integer newStock = (product.getStock() != null ? product.getStock() : 0) + item.getQuantity();
                    product.setStock(newStock);
                    productDAO.save(product);

                    // Đồng bộ với bảng Inventory
                    try {
                        Optional<Inventory> invOpt = inventoryDAO.findByProductId(product.getId());
                        if (invOpt.isPresent()) {
                            Inventory inv = invOpt.get();
                            inv.setQuantity(newStock);
                            inventoryDAO.save(inv);
                        }
                    } catch (Exception e) {
                        log.error("Lỗi đồng bộ kho khi hủy đơn", e);
                    }
                    
                    // Khôi phục số lượng flash sale nếu có
                    try {
                        flashSaleService.decrementSoldCount(product.getId(), item.getQuantity());
                    } catch (Exception e) {
                        log.error("Failed to restore flash sale quantity on order cancel", e);
                    }
                }
            }
        }

        // Gửi email thông báo cho Admin
        emailService.sendOrderCancellationEmailToAdmin(order);

        // Hoàn trả voucher nếu có
        if (order.getVoucherCode() != null && !order.getVoucherCode().trim().isEmpty() && order.getUser() != null) {
            try {
                voucherService.restoreVoucher(order.getVoucherCode(), order.getUser().getId());
            } catch (Exception e) {
                log.error("Failed to restore voucher on order cancel", e);
            }
        }
    }

    @Transactional
    public Order confirmOrderAndCreateShipping(Integer orderId) {
        Order order = orderDAO.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đơn hàng #" + orderId));
        
        if (order.getTrackingCode() == null || order.getTrackingCode().trim().isEmpty()) {
            String randomTracking = "LLM" + (10000000 + new java.util.Random().nextInt(90000000));
            order.setTrackingCode(randomTracking);
        }
        order.setStatus("WAITING_DRIVER");
        return orderDAO.save(order);
    }

    @Transactional
    public Order processLalamoveWebhook(poly.edu.dto.LalamoveWebhookDTO payload) {
        if (payload == null) {
            throw new IllegalArgumentException("Webhook payload rỗng.");
        }

        Optional<Order> orderOpt = Optional.empty();
        if (payload.getTrackingCode() != null && !payload.getTrackingCode().trim().isEmpty()) {
            orderOpt = orderDAO.findByTrackingCode(payload.getTrackingCode().trim());
        }
        if (orderOpt.isEmpty() && payload.getOrderId() != null && !payload.getOrderId().trim().isEmpty()) {
            String orderIdStr = payload.getOrderId().trim();
            orderOpt = orderDAO.findByTrackingCode(orderIdStr);
            if (orderOpt.isEmpty()) {
                orderOpt = orderDAO.findByOrderCode(orderIdStr);
            }
            if (orderOpt.isEmpty()) {
                try {
                    Integer id = Integer.parseInt(orderIdStr);
                    orderOpt = orderDAO.findById(id);
                } catch (NumberFormatException ignored) {}
            }
        }

        if (orderOpt.isEmpty()) {
            throw new IllegalArgumentException("Không tìm thấy đơn hàng tương ứng với webhook payload.");
        }

        Order order = orderOpt.get();
        String event = payload.getEvent() != null ? payload.getEvent().toUpperCase().trim() : "";

        switch (event) {
            case "ASSIGN_DRIVER":
            case "ASSIGNING_DRIVER":
                order.setStatus("WAITING_DRIVER");
                break;
            case "PICKED_UP":
                order.setStatus("PICKED_UP");
                break;
            case "ON_DELIVERY":
            case "DELIVERING":
            case "SHIPPING":
                order.setStatus("SHIPPING");
                break;
            case "DELIVERED":
            case "COMPLETED":
                order.setStatus("COMPLETED");
                break;
            case "CANCEL":
            case "CANCELLED":
            case "CANCELED":
                order.setStatus("CANCELLED");
                break;
            default:
                log.warn("Unrecognized Lalamove event: {}", event);
                break;
        }

        return orderDAO.save(order);
    }
}
