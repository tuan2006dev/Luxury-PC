package poly.edu.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import poly.edu.dao.*;
import poly.edu.entity.*;
import java.util.*;

@Component
public class AdminDataLoader implements CommandLineRunner {

    private static final String TEST_ADMIN_EMAIL = "nguyentruongq169@gmail.com";
    private static final String TEST_ADMIN_PASSWORD = "123456";

    @Autowired
    private OrderDAO orderDAO;

    @Autowired
    private OrderItemDAO orderItemDAO;

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private RoleDAO roleDAO;

    @Autowired
    private UserRoleDAO userRoleDAO;

    @Autowired
    private ProductDAO productDAO;

    @Autowired
    private InventoryDAO inventoryDAO;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // 1. Initialize Inventory for all products
        List<Product> products = productDAO.findAll();
        for (Product p : products) {
            if (inventoryDAO.findByProductId(p.getId()).isEmpty()) {
                Inventory inv = new Inventory();
                inv.setProduct(p);
                inv.setQuantity(p.getStock() != null ? p.getStock() : 10);
                try {
                    inventoryDAO.save(inv);
                } catch (Exception e) {
                    System.out.println(">>> Failed to seed inventory for product " + p.getId() + ": " + e.getMessage());
                }
            }
        }

        // 2. Seed Sample Orders if empty
        // BỎ TÍNH NĂNG NÀY ĐỂ TRÁNH RÁC DATABASE CHO TÀI KHOẢN MỚI
        /*
        if (orderDAO.count() == 0) {
            User user = userDAO.findAll().stream().findFirst().orElse(null);
            if (user != null && !products.isEmpty()) {
                createSampleOrder(user, products.get(0), "COMPLETED", 1);
                if (products.size() > 1) {
                    createSampleOrder(user, products.get(1), "PENDING", 2);
                }
                if (products.size() > 2) {
                    createSampleOrder(user, products.get(2), "SHIPPING", 1);
                }
            }
        }
        */

        // 3. Ensure the requested test admin account exists and can authenticate.
        User admin = userDAO.findByEmail(TEST_ADMIN_EMAIL);
        if (admin == null) {
            admin = new User();
            admin.setUsername(TEST_ADMIN_EMAIL);
            admin.setEmail(TEST_ADMIN_EMAIL);
            admin.setFullName("LuxuryPC Admin");
            admin.setPassword(passwordEncoder.encode(TEST_ADMIN_PASSWORD));
            admin = userDAO.save(admin);
            System.out.println(">>> Created test admin: " + TEST_ADMIN_EMAIL);
        }

        boolean adminUpdated = false;
        if (!Boolean.TRUE.equals(admin.getStatus())) {
            admin.setStatus(true);
            adminUpdated = true;
        }
        if (admin.getPassword() == null || !passwordEncoder.matches(TEST_ADMIN_PASSWORD, admin.getPassword())) {
            admin.setPassword(passwordEncoder.encode(TEST_ADMIN_PASSWORD));
            adminUpdated = true;
        }
        if (adminUpdated) {
            admin = userDAO.save(admin);
        }

        Role staffRole = roleDAO.findByName("STAFF");
        if (staffRole == null) {
            staffRole = new Role();
            staffRole.setName("STAFF");
            roleDAO.save(staffRole);
            System.out.println(">>> Created STAFF role");
        }

        Role adminRole = roleDAO.findByName("ADMIN");
        if (adminRole != null) {
            boolean hasAdminRole = userRoleDAO.findByUserId(admin.getId()).stream()
                    .anyMatch(ur -> "ADMIN".equals(ur.getRole().getName()));
            if (!hasAdminRole) {
                UserRole userRole = new UserRole();
                userRole.setUser(admin);
                userRole.setRole(adminRole);
                userRoleDAO.save(userRole);
                System.out.println(">>> Assigned ADMIN role: " + TEST_ADMIN_EMAIL);
            }
        }

        // Stable order codes make this seed idempotent across application restarts.
        seedSampleOrder(admin, products, "DEMO-VIETQR-WAITING", 17_200_000D,
                "VIETQR", "CHO_XAC_NHAN_THANH_TOAN", 1, 0);
        seedSampleOrder(admin, products, "DEMO-COD-PENDING", 8_500_000D,
                "COD", "PENDING", 2, 1);
        seedSampleOrder(admin, products, "DEMO-VIETQR-PAID", 25_900_000D,
                "VIETQR", "DA_THANH_TOAN", 3, 2);
        seedSampleOrder(admin, products, "DEMO-VIETQR-REFUND-REQUESTED", 18_600_000D,
                "VIETQR", "YEU_CAU_HOAN_TIEN", 4, 3, null, null, null,
                "Khách muốn trả hàng vì sản phẩm không phù hợp", "DA_THANH_TOAN");
        seedSampleOrder(admin, products, "DEMO-CANCELLED", 6_900_000D,
                "COD", "CANCELLED", 5, 3);
        seedSampleOrder(admin, products, "DEMO-VOUCHER-COMPLETED", 12_500_000D,
                "COD", "COMPLETED", 6, 4, "QA500K", 500_000D);
        seedSampleOrder(admin, products, "DEMO-VIETQR-REFUND-WAITING", 19_900_000D,
                "VIETQR", "CHO_HOAN_TIEN", 7, 0, null, null, "Admin đã duyệt yêu cầu hoàn tiền",
                "Khách yêu cầu hoàn tiền", "DA_THANH_TOAN");
        seedSampleOrder(admin, products, "DEMO-VIETQR-REFUNDED", 21_500_000D,
                "VIETQR", "DA_HOAN_TIEN", 8, 1, null, null, "Đã hoàn tiền qua MB Bank",
                "Khách yêu cầu hoàn tiền", "DA_THANH_TOAN");
        seedSampleOrder(admin, products, "DEMO-VIETQR-RECALLED", 15_700_000D,
                "VIETQR", "THU_HOI", 9, 2, null, null, "Thu hồi theo yêu cầu kiểm thử",
                "Khách yêu cầu trả hàng", "DA_THANH_TOAN");
    }

    private void seedSampleOrder(User user, List<Product> products, String orderCode, Double totalPrice,
                                 String paymentMethod, String status, int daysAgo, int productIndex) {
        seedSampleOrder(user, products, orderCode, totalPrice, paymentMethod, status, daysAgo,
                productIndex, null, null, null, null, null);
    }

    private void seedSampleOrder(User user, List<Product> products, String orderCode, Double totalPrice,
                                 String paymentMethod, String status, int daysAgo, int productIndex,
                                 String voucherCode, Double discountAmount) {
        seedSampleOrder(user, products, orderCode, totalPrice, paymentMethod, status, daysAgo,
                productIndex, voucherCode, discountAmount, null, null, null);
    }

    private void seedSampleOrder(User user, List<Product> products, String orderCode, Double totalPrice,
                                 String paymentMethod, String status, int daysAgo, int productIndex,
                                 String voucherCode, Double discountAmount, String adminNote) {
        seedSampleOrder(user, products, orderCode, totalPrice, paymentMethod, status, daysAgo,
                productIndex, voucherCode, discountAmount, adminNote, null, null);
    }

    private void seedSampleOrder(User user, List<Product> products, String orderCode, Double totalPrice,
                                 String paymentMethod, String status, int daysAgo, int productIndex,
                                 String voucherCode, Double discountAmount, String adminNote,
                                 String refundReason, String refundPreviousStatus) {
        Optional<Order> existingOrder = orderDAO.findByOrderCode(orderCode);
        if (existingOrder.isPresent()) {
            Order order = existingOrder.get();
            boolean updated = false;
            if (order.getAdminNote() == null && adminNote != null) {
                order.setAdminNote(adminNote);
                updated = true;
            }
            if (order.getRefundReason() == null && refundReason != null) {
                order.setRefundReason(refundReason);
                updated = true;
            }
            if (order.getRefundPreviousStatus() == null && refundPreviousStatus != null) {
                order.setRefundPreviousStatus(refundPreviousStatus);
                updated = true;
            }
            if (updated) {
                orderDAO.save(order);
            }
            return;
        }

        Order order = new Order();
        order.setUser(user);
        order.setOrderCode(orderCode);
        order.setFullName(user.getFullName() != null ? user.getFullName() : "QA Admin");
        order.setEmail(user.getEmail());
        order.setPhone(user.getPhone() != null ? user.getPhone() : "0900000000");
        order.setAddress(user.getAddress() != null ? user.getAddress() : "Địa chỉ kiểm thử");
        order.setPaymentMethod(paymentMethod);
        order.setStatus(status);
        order.setTotalPrice(totalPrice);
        order.setVoucherCode(voucherCode);
        order.setDiscountAmount(discountAmount);
        order.setAdminNote(adminNote);
        order.setRefundReason(refundReason);
        order.setRefundPreviousStatus(refundPreviousStatus);
        order.setCreatedAt(new Date(System.currentTimeMillis() - (daysAgo * 86_400_000L)));
        order = orderDAO.save(order);

        if (!products.isEmpty()) {
            Product product = products.get(Math.min(productIndex, products.size() - 1));
            OrderItem item = new OrderItem();
            item.setOrder(order);
            item.setProduct(product);
            item.setPrice(totalPrice);
            item.setQuantity(1);
            orderItemDAO.save(item);
        }

        System.out.println(">>> Created sample order: " + orderCode);
    }
}
