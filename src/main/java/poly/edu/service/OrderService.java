package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
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
}
