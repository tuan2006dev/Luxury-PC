package poly.edu.config;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import poly.edu.dao.*;
import poly.edu.entity.*;
import java.util.*;

@Component
@RequiredArgsConstructor
public class AdminDataLoader implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(AdminDataLoader.class);

    private static final String TEST_ADMIN_EMAIL = "nguyentruongq169@gmail.com";
    private static final String TEST_ADMIN_PASSWORD = "123456";

    private final OrderDAO orderDAO;

    private final OrderItemDAO orderItemDAO;

    private final UserDAO userDAO;

    private final RoleDAO roleDAO;

    private final UserRoleDAO userRoleDAO;

    private final ProductDAO productDAO;

    private final InventoryDAO inventoryDAO;

    private final PasswordEncoder passwordEncoder;

    @Override
    @org.springframework.transaction.annotation.Transactional
    public void run(String... args) throws Exception {
        // 0. Clean up DEMO test orders
        try {
            orderItemDAO.deleteDemoOrderItems();
            orderDAO.deleteDemoOrders();
            log.info("[DataLoader] Successfully cleaned up all DEMO test orders.");
        } catch (Exception e) {
            log.warn("[DataLoader] Failed to clean up DEMO orders: {}", e.getMessage());
        }

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
                    log.warn("[DataLoader] Failed to seed inventory for product id={}: {}", p.getId(), e.getMessage());
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
            log.info("[DataLoader] Created test admin account: {}", TEST_ADMIN_EMAIL);
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
            log.info("[DataLoader] Created STAFF role");
        }

        Role adminRole = roleDAO.findByName("ADMIN");
        if (adminRole == null) {
            adminRole = new Role();
            adminRole.setName("ADMIN");
            roleDAO.save(adminRole);
            log.info("[DataLoader] Created ADMIN role");
        }

        boolean hasAdminRole = userRoleDAO.findByUserId(admin.getId()).stream()
                .anyMatch(ur -> "ADMIN".equals(ur.getRole().getName()));
        if (!hasAdminRole) {
                UserRole userRole = new UserRole();
                userRole.setUser(admin);
                userRole.setRole(adminRole);
                userRoleDAO.save(userRole);
                log.info("[DataLoader] Assigned ADMIN role to: {}", TEST_ADMIN_EMAIL);
            }
    }
}
