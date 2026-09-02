package poly.edu.config;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

    private static final String TEST_ADMIN_EMAIL = "leecookcu@gmail.com";
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

        // 1. Initialize and synchronize Inventory for all products
        List<Product> products = productDAO.findAll();
        for (Product p : products) {
            try {
                Optional<Inventory> invOpt = inventoryDAO.findByProductId(p.getId());
                if (invOpt.isEmpty()) {
                    int initialStock = (p.getStock() != null && p.getStock() > 0) ? p.getStock() : 10;
                    p.setStock(initialStock);
                    productDAO.save(p);

                    Inventory inv = new Inventory();
                    inv.setProduct(p);
                    inv.setQuantity(initialStock);
                    inventoryDAO.save(inv);
                } else {
                    Inventory inv = invOpt.get();
                    if ((p.getStock() == null || p.getStock() == 0) && inv.getQuantity() != null && inv.getQuantity() > 0) {
                        p.setStock(inv.getQuantity());
                        productDAO.save(p);
                    } else if (p.getStock() != null && (inv.getQuantity() == null || !inv.getQuantity().equals(p.getStock()))) {
                        inv.setQuantity(p.getStock());
                        inventoryDAO.save(inv);
                    }
                }
            } catch (Exception e) {
                log.warn("[DataLoader] Failed to sync inventory for product id={}: {}", p.getId(), e.getMessage());
            }
        }

        // 2. Seed Sample Orders if empty
        // BỎ TÍNH NĂNG NÀY ĐỂ TRÁNH RÁC DATABASE CHO TÀI KHOẢN MỚI

        // 3. Ensure the admin accounts exist and can authenticate.
        List<String> adminUsernames = List.of("admin", "leecookcu@gmail.com");
        
        Role adminRole = roleDAO.findByName("ADMIN");
        if (adminRole == null) {
            adminRole = new Role();
            adminRole.setName("ADMIN");
            adminRole = roleDAO.save(adminRole);
            log.info("[DataLoader] Created ADMIN role");
        }

        Role staffRole = roleDAO.findByName("STAFF");
        if (staffRole == null) {
            staffRole = new Role();
            staffRole.setName("STAFF");
            staffRole = roleDAO.save(staffRole);
            log.info("[DataLoader] Created STAFF role");
        }

        Role userRoleDefault = roleDAO.findByName("USER");
        if (userRoleDefault == null) {
            userRoleDefault = new Role();
            userRoleDefault.setName("USER");
            userRoleDefault = roleDAO.save(userRoleDefault);
            log.info("[DataLoader] Created USER role");
        }

        for (String admIdent : adminUsernames) {
            User adm = userDAO.findByEmail(admIdent);
            if (adm == null) {
                adm = userDAO.findByUsername(admIdent);
            }
            if (adm == null) {
                adm = new User();
                adm.setUsername(admIdent.contains("@") ? admIdent.split("@")[0] : admIdent);
                adm.setEmail(admIdent.contains("@") ? admIdent : admIdent + "@luxurypc.vn");
                adm.setFullName("LuxuryPC Administrator");
                adm.setPassword(passwordEncoder.encode(TEST_ADMIN_PASSWORD));
                adm.setStatus(true);
                adm = userDAO.save(adm);
                log.info("[DataLoader] Created admin account: {}", admIdent);
            } else {
                adm.setStatus(true);
                adm.setPassword(passwordEncoder.encode(TEST_ADMIN_PASSWORD));
                adm = userDAO.save(adm);
            }

            final Integer admId = adm.getId();
            final Role fAdminRole = adminRole;
            final User fAdm = adm;
            boolean hasAdmRole = userRoleDAO.findByUserId(admId).stream()
                    .anyMatch(ur -> "ADMIN".equals(ur.getRole().getName()));
            if (!hasAdmRole) {
                UserRole userRole = new UserRole();
                userRole.setUser(fAdm);
                userRole.setRole(fAdminRole);
                userRoleDAO.save(userRole);
                log.info("[DataLoader] Assigned ADMIN role to: {}", admIdent);
            }
        }
    }
}
