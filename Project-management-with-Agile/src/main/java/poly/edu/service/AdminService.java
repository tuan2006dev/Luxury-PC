package poly.edu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.*;
import poly.edu.entity.*;
import java.util.*;

@Service
public class AdminService {

    @Autowired
    private OrderDAO orderDAO;

    @Autowired
    private OrderItemDAO orderItemDAO;

    @Autowired
    private InventoryDAO inventoryDAO;

    @Autowired
    private StockMovementDAO stockMovementDAO;

    public List<Order> getAllOrders() {
        return orderDAO.findAllOrderedByDate();
    }

    public Order getOrderById(Integer id) {
        return orderDAO.findById(id).orElse(null);
    }

    @Transactional
    public void updateOrderStatus(Integer orderId, String status) {
        Order order = getOrderById(orderId);
        if (order != null) {
            order.setStatus(status);
            orderDAO.save(order);
        }
    }

    public List<Map<String, Object>> getMonthlyRevenue() {
        return orderDAO.getMonthlyRevenue();
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

    @Autowired
    private ProductDAO productDAO;

    public List<Inventory> getFullInventory() {
        return inventoryDAO.findAll();
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
