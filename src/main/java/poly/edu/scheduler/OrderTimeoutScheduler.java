package poly.edu.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.Order;
import poly.edu.entity.OrderItem;
import poly.edu.entity.Product;
import poly.edu.service.FlashSaleService;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Component
public class OrderTimeoutScheduler {

    private final OrderDAO orderDAO;
    private final ProductDAO productDAO;
    private final FlashSaleService flashSaleService;

    public OrderTimeoutScheduler(OrderDAO orderDAO, ProductDAO productDAO, FlashSaleService flashSaleService) {
        this.orderDAO = orderDAO;
        this.productDAO = productDAO;
        this.flashSaleService = flashSaleService;
    }

    @Scheduled(fixedRate = 60000) // Run every 1 minute
    @Transactional
    public void cancelExpiredPendingOrders() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MINUTE, -15);
        Date threshold = cal.getTime();

        List<Order> expiredOrders = orderDAO.findExpiredPendingOrders(threshold);
        for (Order order : expiredOrders) {
            order.setStatus("CANCELLED");
            order.setRefundReason("Hệ thống tự động hủy do quá hạn thanh toán");
            orderDAO.save(order);

            // Restore inventory and flash sale counts
            if (order.getOrderItems() != null) {
                for (OrderItem item : order.getOrderItems()) {
                    Optional<Product> pOpt = productDAO.findById(item.getProduct().getId());
                    if (pOpt.isPresent()) {
                        Product p = pOpt.get();
                        p.setStock(p.getStock() + item.getQuantity());
                        productDAO.save(p);
                    }
                    
                    flashSaleService.decrementSoldCount(item.getProduct().getId(), item.getQuantity());
                }
            }
        }
    }
}
