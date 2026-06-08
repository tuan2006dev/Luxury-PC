package poly.edu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.OrderDAO;
import poly.edu.entity.Order;
import poly.edu.entity.User;

@Service
public class CustomerOrderService {

    @Autowired
    private OrderDAO orderDAO;

    @Transactional
    public boolean requestRefund(Integer orderId, User user, String reason) {
        if (user == null || reason == null || reason.isBlank()) {
            return false;
        }

        Order order = orderDAO.findById(orderId).orElse(null);
        if (order == null
                || order.getUser() == null
                || !order.getUser().getId().equals(user.getId())
                || !order.isCustomerRefundEligible()) {
            return false;
        }

        order.setRefundPreviousStatus(order.getStatus());
        order.setRefundReason(reason.trim());
        order.setAdminNote(null);
        order.setStatus("YEU_CAU_HOAN_TIEN");
        orderDAO.save(order);
        return true;
    }
}
