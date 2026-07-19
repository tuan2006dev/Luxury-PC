package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.OrderItemDAO;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.CartItem;
import poly.edu.entity.Order;
import poly.edu.entity.OrderItem;
import poly.edu.entity.Product;
import poly.edu.entity.User;
import poly.edu.repository.UserRepository;

import java.util.Collection;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CartService {

    private final UserRepository userRepository;

    private final OrderDAO orderDAO;

    private final OrderItemDAO orderItemDAO;

    private final ProductDAO productDAO;

    private final VoucherService voucherService;

    private final FlashSaleService flashSaleService;

    private final UserVoucherService userVoucherService;

    public double calculateTotal(Collection<CartItem> items) {
        if (items == null || items.isEmpty()) return 0.0;
        return items.stream()
                .mapToDouble(item -> item.getPrice() * item.getQuantity())
                .sum();
    }

    public double getDiscountRate(Object principal) {
        if (principal == null) return 0.0;

        String emailOrUsername = "";
        if (principal instanceof OAuth2User oauthUser) {
            emailOrUsername = (String) oauthUser.getAttributes().get("email");
        } else if (principal instanceof org.springframework.security.core.userdetails.User user) {
            emailOrUsername = user.getUsername();
        }

        Optional<User> uOpt = userRepository.findByEmail(emailOrUsername);
        if (uOpt.isEmpty()) uOpt = userRepository.findByUsername(emailOrUsername);

        if (uOpt.isPresent()) {
            Double spent = orderDAO.getTotalSpentByUser(uOpt.get().getId());
            if (spent == null) spent = 0.0;
            if (spent >= 200_000_000) return 0.10; // 10%
            if (spent >= 50_000_000) return 0.05;  // 5%
            if (spent >= 10_000_000) return 0.02;  // 2%
        }
        return 0.0;
    }

    @Transactional(rollbackFor = Exception.class)
    public Order processCheckout(Map<Integer, CartItem> targetCart,
                                 String fullName, String phone, String address,
                                 String paymentMethod, String voucherCode,
                                 Object principal) throws Exception {

        // 1. Validate stock for all items
        for (CartItem item : targetCart.values()) {
            Optional<Product> pOpt = productDAO.findById(item.getId());
            if (pOpt.isPresent()) {
                Product p = pOpt.get();
                if (p.getStock() == null || p.getStock() < item.getQuantity()) {
                    throw new Exception("Sản phẩm " + p.getName() + " không đủ số lượng trong kho.");
                }
            } else {
                throw new Exception("Sản phẩm " + item.getName() + " không còn tồn tại.");
            }
        }

        // 2. Identify User
        User currentUser = null;
        if (principal != null) {
            String emailOrUsername = "";
            if (principal instanceof OAuth2User oauthUser) {
                emailOrUsername = (String) oauthUser.getAttributes().get("email");
            } else if (principal instanceof org.springframework.security.core.userdetails.User u) {
                emailOrUsername = u.getUsername();
            }
            Optional<User> uOpt = userRepository.findByEmail(emailOrUsername);
            if (uOpt.isEmpty()) uOpt = userRepository.findByUsername(emailOrUsername);
            if (uOpt.isPresent()) currentUser = uOpt.get();
        }

        // 3. Calculate Prices
        double baseTotal = calculateTotal(targetCart.values());
        double discountRate = getDiscountRate(principal);
        double priceAfterVip = baseTotal - (baseTotal * discountRate);

        // 4. Apply voucher
        double voucherDiscount = 0;
        String appliedVoucherCode = null;
        if (voucherCode != null && !voucherCode.trim().isEmpty() && currentUser != null) {
            
            // Kiểm tra giỏ hàng có chứa sản phẩm Flash Sale hay không
            boolean hasFlashSaleItem = false;
            for (CartItem item : targetCart.values()) {
                if (flashSaleService.getActiveFlashSaleItem(item.getId()).isPresent()) {
                    hasFlashSaleItem = true;
                    break;
                }
            }
            if (hasFlashSaleItem) {
                throw new Exception("Không thể áp dụng Voucher khi giỏ hàng có sản phẩm Flash Sale.");
            }

            Map<String, Object> validation = voucherService.validateVoucher(voucherCode, priceAfterVip, currentUser);
            if (Boolean.TRUE.equals(validation.get("valid"))) {
                voucherDiscount = (double) validation.get("discount");
                appliedVoucherCode = voucherCode.trim().toUpperCase();
                
                // Reserve the voucher atomically
                voucherService.reserveVoucher(appliedVoucherCode, currentUser.getId());
            } else {
                throw new Exception("Lỗi voucher: " + validation.get("message"));
            }
        }

        double finalPrice = priceAfterVip - voucherDiscount;

        // 5. Create Order
        Order order = new Order();
        if (currentUser != null) {
            order.setUser(currentUser);
            if (order.getEmail() == null) order.setEmail(currentUser.getEmail());
        }
        order.setFullName(fullName);
        order.setPhone(phone);
        order.setAddress(address);
        order.setTotalPrice(finalPrice);
        order.setVoucherCode(appliedVoucherCode);
        order.setDiscountAmount(voucherDiscount);
        order.setPaymentMethod(paymentMethod.toUpperCase());
        order.setStatus("VIETQR".equalsIgnoreCase(paymentMethod)
                ? "CHO_XAC_NHAN_THANH_TOAN"
                : "PENDING");
        orderDAO.save(order);
        
        order.setOrderCode("DH" + order.getId());
        orderDAO.save(order);

        // 6. Create Order Items & Update Stock
        for (CartItem item : targetCart.values()) {
            OrderItem oi = new OrderItem();
            oi.setOrder(order);
            Optional<Product> pOpt = productDAO.findById(item.getId());
            if (pOpt.isPresent()) {
                Product p = pOpt.get();
                oi.setProduct(p);
                oi.setPrice(item.getPrice());
                oi.setQuantity(item.getQuantity());
                orderItemDAO.save(oi);

                // Trừ số lượng tồn kho
                p.setStock(p.getStock() - item.getQuantity());
                productDAO.save(p);

                // Cập nhật sold count cho flash sale
                flashSaleService.incrementSoldCount(item.getId());
            }
        }

        return order;
    }
}
