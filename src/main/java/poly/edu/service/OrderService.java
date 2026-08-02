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
        order.setTotalPrice(finalPrice);
        order.setVoucherCode(appliedVoucherCode);
        order.setDiscountAmount(voucherDiscount);
        order.setStatus("PENDING");
        Order savedOrder = orderDAO.save(order);

        // 3. Deduct stock, save order items, sync inventory, and log stock movements
        for (CartItem item : cart.values()) {
            // Retrieve again under lock to be safe
            Product product = productDAO.findByIdForUpdate(item.getId()).get();
            
            // Deduct stock in Product entity
            product.setStock(product.getStock() - item.getQuantity());
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
}
