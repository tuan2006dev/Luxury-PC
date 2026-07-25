package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import poly.edu.dao.CartDAO;
import poly.edu.dao.CartItemDAO;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.OrderItemDAO;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.Cart;
import poly.edu.entity.CartItem;
import poly.edu.entity.CartItemEntity;
import poly.edu.entity.Order;
import poly.edu.entity.OrderItem;
import poly.edu.entity.Product;
import poly.edu.entity.User;
import poly.edu.repository.UserRepository;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
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
    private final CartDAO cartDAO;
    private final CartItemDAO cartItemDAO;

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
                                 Double shippingFee, String shippingMethodName,
                                 Object principal) throws Exception {
        return processCheckout(targetCart, fullName, phone, address, paymentMethod, voucherCode, null, shippingFee, shippingMethodName, principal);
    }

    @Transactional(rollbackFor = Exception.class)
    public Order processCheckout(Map<Integer, CartItem> targetCart,
                                 String fullName, String phone, String address,
                                 String paymentMethod, String voucherCode, String freeshipCode,
                                 Double shippingFee, String shippingMethodName,
                                 Object principal) throws Exception {

        // Validate fullName & phone
        if (fullName == null || fullName.trim().split("\\s+").length < 2) {
            throw new Exception("Họ và tên không hợp lệ. Vui lòng nhập đầy đủ cả Họ và Tên (ít nhất 2 từ, ví dụ: Nguyễn Văn A).");
        }
        String cleanPhone = phone != null ? phone.replaceAll("\\s+", "") : "";
        if (!cleanPhone.matches("^(0[3578912])[0-9]{8}$")) {
            throw new Exception("Số điện thoại không hợp lệ. Vui lòng nhập đúng 10 chữ số (ví dụ: 0901234567).");
        }

        // 1. Validate stock for all items
        java.util.List<Integer> checkoutProductIds = new java.util.ArrayList<>(targetCart.keySet());
        java.util.List<Product> checkoutProducts = productDAO.findAllById(checkoutProductIds);
        java.util.Map<Integer, Product> checkoutProductMap = checkoutProducts.stream()
            .collect(java.util.stream.Collectors.toMap(Product::getId, p -> p));

        for (CartItem item : targetCart.values()) {
            Product p = checkoutProductMap.get(item.getId());
            if (p != null) {
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

        // 4. Apply voucher combo (Order/Category discount + Freeship)
        double voucherDiscount = 0;
        double freeshipDiscount = 0;
        String appliedVoucherCode = null;
        String appliedFreeshipCode = null;

        if (currentUser != null) {
            Map<String, Object> validation = voucherService.validateVoucherCombo(voucherCode, freeshipCode, priceAfterVip, shippingFee, targetCart.values(), currentUser);
            if (Boolean.TRUE.equals(validation.get("valid"))) {
                voucherDiscount = (double) validation.getOrDefault("orderDiscount", 0.0);
                freeshipDiscount = (double) validation.getOrDefault("freeshipDiscount", 0.0);
                appliedVoucherCode = (String) validation.get("voucherCode");
                appliedFreeshipCode = (String) validation.get("freeshipCode");

                if (appliedVoucherCode != null) {
                    voucherService.reserveVoucher(appliedVoucherCode, currentUser.getId());
                }
                if (appliedFreeshipCode != null) {
                    voucherService.reserveVoucher(appliedFreeshipCode, currentUser.getId());
                }
            } else if ((voucherCode != null && !voucherCode.trim().isEmpty()) || (freeshipCode != null && !freeshipCode.trim().isEmpty())) {
                throw new Exception("Lỗi voucher: " + validation.get("message"));
            }
        }

        double finalShippingFee = Math.max(0, shippingFee - freeshipDiscount);
        double finalPrice = Math.max(0, (priceAfterVip - voucherDiscount) + finalShippingFee);

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
        order.setFreeshipVoucherCode(appliedFreeshipCode);
        order.setFreeshipDiscount(freeshipDiscount);
        order.setPaymentMethod(paymentMethod.toUpperCase());
        order.setShippingFee(shippingFee);
        order.setShippingMethodName(shippingMethodName);
        order.setStatus("VIETQR".equalsIgnoreCase(paymentMethod)
                ? "CHO_XAC_NHAN_THANH_TOAN"
                : "PENDING");
        orderDAO.save(order);
        
        order.setOrderCode("DH" + order.getId());
        orderDAO.save(order);

        // 6. Create Order Items & Update Stock
        if (appliedVoucherCode != null && currentUser != null && !"VIETQR".equalsIgnoreCase(paymentMethod)) {
            voucherService.consumeVoucher(appliedVoucherCode, currentUser.getId());
        }
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

                // Cập nhật sold count cho flash sale (nếu là sản phẩm Flash Sale)
                flashSaleService.incrementSoldCount(item.getId(), item.getQuantity());
            }
        }

        if (currentUser != null) {
            clearDbCart(currentUser);
        }

        return order;
    }

    /**
     * Tải giỏ hàng từ Database cho User
     */
    @Transactional(readOnly = true)
    public Map<Integer, CartItem> loadCartFromDb(User user) {
        Map<Integer, CartItem> cartMap = new HashMap<>();
        if (user == null || user.getId() == null) return cartMap;

        Optional<Cart> cartOpt = cartDAO.findByUserId(user.getId());
        if (cartOpt.isPresent()) {
            List<CartItemEntity> items = cartItemDAO.findByCartId(cartOpt.get().getId());
            for (CartItemEntity entityItem : items) {
                Product p = entityItem.getProduct();
                if (p != null && (p.getStock() == null || p.getStock() > 0)) {
                    double price = flashSaleService.getEffectivePrice(p.getId());
                    CartItem item = new CartItem(p.getId(), p.getName(), price, entityItem.getQuantity());
                    item.setImage(p.getImage());
                    item.setStock(p.getStock());
                    cartMap.put(p.getId(), item);
                }
            }
        }
        return cartMap;
    }

    /**
     * Đồng bộ giỏ hàng Session xuống Database cho User
     */
    @Transactional
    public void saveCartToDb(User user, Map<Integer, CartItem> sessionCart) {
        if (user == null || user.getId() == null) return;

        Cart cart = cartDAO.findByUserId(user.getId()).orElseGet(() -> {
            Cart newCart = new Cart(user);
            return cartDAO.save(newCart);
        });

        // Xóa các sản phẩm cũ trong DB cart rồi thêm lại
        cartItemDAO.deleteByCartId(cart.getId());

        if (sessionCart != null && !sessionCart.isEmpty()) {
            java.util.List<Integer> productIds = new java.util.ArrayList<>(sessionCart.keySet());
            java.util.List<Product> products = productDAO.findAllById(productIds);
            java.util.Map<Integer, Product> productMap = products.stream()
                .collect(java.util.stream.Collectors.toMap(Product::getId, p -> p));

            java.util.List<CartItemEntity> entitiesToSave = new java.util.ArrayList<>();
            for (CartItem item : sessionCart.values()) {
                Product p = productMap.get(item.getId());
                if (p != null) {
                    CartItemEntity entityItem = new CartItemEntity(cart, p, item.getQuantity());
                    entitiesToSave.add(entityItem);
                }
            }
            if (!entitiesToSave.isEmpty()) {
                cartItemDAO.saveAll(entitiesToSave);
            }
        }
    }

    /**
     * Gộp giỏ hàng khách vãng lai trong Session vào Giỏ hàng CSDL của User khi Đăng nhập
     */
    @Transactional
    public Map<Integer, CartItem> mergeCartOnLogin(User user, Map<Integer, CartItem> sessionCart) {
        Map<Integer, CartItem> dbCart = loadCartFromDb(user);

        if (sessionCart != null && !sessionCart.isEmpty()) {
            for (CartItem item : sessionCart.values()) {
                if (dbCart.containsKey(item.getId())) {
                    CartItem existing = dbCart.get(item.getId());
                    int newQty = existing.getQuantity() + item.getQuantity();
                    if (existing.getStock() != null && newQty > existing.getStock()) {
                        newQty = existing.getStock();
                    }
                    existing.setQuantity(newQty);
                } else {
                    dbCart.put(item.getId(), item);
                }
            }
        }

        saveCartToDb(user, dbCart);
        return dbCart;
    }

    /**
     * Xóa sạch Giỏ hàng trong CSDL sau khi đặt hàng thành công
     */
    @Transactional
    public void clearDbCart(User user) {
        if (user == null || user.getId() == null) return;
        Optional<Cart> cartOpt = cartDAO.findByUserId(user.getId());
        if (cartOpt.isPresent()) {
            cartItemDAO.deleteByCartId(cartOpt.get().getId());
        }
    }
}
