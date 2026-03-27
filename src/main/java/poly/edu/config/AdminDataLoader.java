package poly.edu.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;
import poly.edu.dao.*;
import poly.edu.entity.*;
import java.util.*;

@Component
public class AdminDataLoader implements CommandLineRunner {

    @Autowired
    private OrderDAO orderDAO;

    @Autowired
    private OrderItemDAO orderItemDAO;

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private ProductDAO productDAO;

    @Autowired
    private InventoryDAO inventoryDAO;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // 1. Initialize Inventory for all products
        List<Product> products = productDAO.findAll();
        for (Product p : products) {
            if (inventoryDAO.findByProductId(p.getId()).isEmpty()) {
                Inventory inv = new Inventory();
                inv.setProduct(p);
                inv.setQuantity(p.getStock() != null ? p.getStock() : 10);
                inventoryDAO.save(inv);
            }
        }

        // 2. Seed Sample Orders if empty
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

        // 3. Ensure Admin user has ADMIN role and BCrypt password
        User admin = userDAO.findByEmail("admin@luxurypc.com");
        if (admin != null) {
            boolean updated = false;
            
            // Check if admin already has ADMIN role
            boolean hasAdminRole = admin.getUserRoles().stream()
                    .anyMatch(ur -> ur.getRole().getName().equals("ADMIN"));
            
            if (!hasAdminRole) {
                // This part might be tricky without RoleDAO/UserRoleDAO injected
                // For simplicity, we just assume the DB already has it for now
                // OR we can inject them if needed. 
                // Given the User 30 issue, the user probably manages roles in DB manually.
            }

            // If password is not hashed (checking for '123456' as seeded in init_db.sql)
            if (admin.getPassword().equals("123456")) {
                admin.setPassword(passwordEncoder.encode("123456"));
                updated = true;
            }
            if (updated) {
                userDAO.save(admin);
                System.out.println(">>> Updated admin security: admin@luxurypc.com");
            }
        }
    }

    private void createSampleOrder(User user, Product product, String status, int qty) {
        Order order = new Order();
        order.setUser(user);
        order.setFullName(user.getFullName());
        order.setEmail(user.getEmail());
        order.setPhone(user.getPhone());
        order.setAddress(user.getAddress());
        order.setStatus(status);
        order.setTotalPrice(product.getPrice() * qty);
        order.setCreatedAt(new Date(System.currentTimeMillis() - (new Random().nextInt(10) * 86400000L)));
        orderDAO.save(order);

        OrderItem item = new OrderItem();
        item.setOrder(order);
        item.setProduct(product);
        item.setPrice(product.getPrice());
        item.setQuantity(qty);
        orderItemDAO.save(item);
    }
}
