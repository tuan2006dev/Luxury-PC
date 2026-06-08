package poly.edu.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.entity.*;
import poly.edu.dao.*;
import poly.edu.repository.UserRepository;
import poly.edu.service.VoucherService;
import poly.edu.service.FlashSaleService;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Controller
public class CartController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private OrderDAO orderDAO;

    @Autowired
    private OrderItemDAO orderItemDAO;

    @Autowired
    private ProductDAO productDAO;

    @Autowired
    private VoucherService voucherService;

    @Autowired
    private FlashSaleService flashSaleService;

    @Autowired
    private poly.edu.service.UserVoucherService userVoucherService;

    /**
     * 1. THÊM SẢN PHẨM: Xử lý khi nhấn "THÊM VÀO GIỎ HÀNG"
     */
    @PostMapping("/cart/add")
    public String addToCart(@RequestParam("id") Integer id,
                            @RequestParam("name") String name,
                            @RequestParam("price") Double price,
                            @RequestParam(value = "quantity", defaultValue = "1") Integer quantity,
                            HttpSession session) {

        Map<Integer, CartItem> cart = getCartFromSession(session);

        if (cart.containsKey(id)) {
            CartItem item = cart.get(id);
            item.setQuantity(item.getQuantity() + quantity);
        } else {
            cart.put(id, new CartItem(id, name, price, quantity));
        }

        session.setAttribute("cart", cart);
        return "redirect:/cart";
    }

    /**
     * 2. CẬP NHẬT SỐ LƯỢNG (Dùng AJAX từ cart.html)
     */
    @PostMapping("/cart/update")
    @ResponseBody
    public void updateCart(@RequestParam("id") Integer id,
                           @RequestParam("quantity") Integer quantity,
                           HttpSession session) {
        Map<Integer, CartItem> cart = getCartFromSession(session);
        if (cart.containsKey(id)) {
            if (quantity > 0) {
                cart.get(id).setQuantity(quantity);
            } else {
                cart.remove(id);
            }
            session.setAttribute("cart", cart);
        }
    }

    /**
     * 3. XÓA SẢN PHẨM
     */
    @PostMapping("/cart/remove")
    @ResponseBody
    public String removeFromCart(@RequestParam("id") Integer id, HttpSession session) {
        Map<Integer, CartItem> cart = getCartFromSession(session);
        if (cart.containsKey(id)) {
            cart.remove(id);
            session.setAttribute("cart", cart);
            return "success";
        }
        return "error";
    }

    /**
     * 4. HIỂN THỊ GIỎ HÀNG (cart.html)
     */
    @GetMapping("/cart")
    public String viewCart(Model model, HttpSession session, @AuthenticationPrincipal Object principal) {
        Map<Integer, CartItem> cart = getCartFromSession(session);

        double baseTotal = calculateTotal(cart.values());
        double discountRate = getDiscountRate(principal);

        for (CartItem item : cart.values()) {
            Optional<Product> pOpt = productDAO.findById(item.getId());
            if (pOpt.isPresent()) {
                item.setImage(pOpt.get().getImage());
            }
        }

        model.addAttribute("cartItems", cart.values());
        model.addAttribute("totalPrice", baseTotal);
        model.addAttribute("discountAmt", baseTotal * discountRate);
        model.addAttribute("finalPrice", baseTotal - (baseTotal * discountRate));

        return "cart";
    }

    /**
     * 5. HIỂN THỊ TRANG CHECKOUT (checkout.html)
     * Đây là phần còn thiếu khiến trang checkout của bạn bị null sản phẩm
     */
    @GetMapping("/checkout")
    public String viewCheckout(Model model, HttpSession session, @AuthenticationPrincipal Object principal) {
        Map<Integer, CartItem> cart = getCartFromSession(session);

        if (cart.isEmpty()) {
            return "redirect:/cart";
        }

        double baseTotal = calculateTotal(cart.values());
        double discountRate = getDiscountRate(principal);

        for (CartItem item : cart.values()) {
            Optional<Product> pOpt = productDAO.findById(item.getId());
            if (pOpt.isPresent()) {
                item.setImage(pOpt.get().getImage());
            }
        }

        model.addAttribute("cartItems", cart.values());
        model.addAttribute("totalPrice", baseTotal);
        model.addAttribute("discountAmt", baseTotal * discountRate);
        model.addAttribute("finalPrice", baseTotal - (baseTotal * discountRate));
        model.addAttribute("activeVouchers", voucherService.getActiveVouchers());

        return "checkout";
    }

    @PostMapping("/checkout/submit")
    public String submitCheckout(
            @RequestParam("fullName") String fullName,
            @RequestParam("phone") String phone,
            @RequestParam("address") String address,
            @RequestParam(value = "paymentMethod", defaultValue = "COD") String paymentMethod,
            @RequestParam(value = "voucherCode", required = false) String voucherCode,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            @AuthenticationPrincipal Object principal) {

        Map<Integer, CartItem> cart = getCartFromSession(session);
        if (cart.isEmpty()) return "redirect:/cart";

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

        double baseTotal = calculateTotal(cart.values());
        double discountRate = getDiscountRate(principal);
        double priceAfterVip = baseTotal - (baseTotal * discountRate);

        // Áp dụng voucher (chỉ 1 voucher duy nhất)
        double voucherDiscount = 0;
        String appliedVoucherCode = null;
        if (voucherCode != null && !voucherCode.trim().isEmpty() && currentUser != null) {
            Map<String, Object> validation = voucherService.validateVoucher(voucherCode, priceAfterVip, currentUser);
            if (Boolean.TRUE.equals(validation.get("valid"))) {
                voucherDiscount = (double) validation.get("discount");
                appliedVoucherCode = voucherCode.trim().toUpperCase();
                // Mark voucher as used in user's wallet
                userVoucherService.markVoucherAsUsed(currentUser, appliedVoucherCode);
            }
        }

        double finalPrice = priceAfterVip - voucherDiscount;

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

        for (CartItem item : cart.values()) {
            OrderItem oi = new OrderItem();
            oi.setOrder(order);
            Optional<Product> pOpt = productDAO.findById(item.getId());
            if (pOpt.isPresent()) {
                oi.setProduct(pOpt.get());
                oi.setPrice(item.getPrice());
                oi.setQuantity(item.getQuantity());
                orderItemDAO.save(oi);
                // Cập nhật sold count cho flash sale
                flashSaleService.incrementSoldCount(item.getId());
            }
        }

        session.removeAttribute("cart");
        if ("VIETQR".equalsIgnoreCase(paymentMethod)) {
            redirectAttributes.addAttribute("amount", Math.round(finalPrice));
            redirectAttributes.addAttribute("orderCode", order.getOrderCode());
            return "redirect:/payment/vietqr";
        }

        return "redirect:/checkout?success";
    }

    /**
     * Hàm tính tổng tiền dùng chung
     */
    private double calculateTotal(Collection<CartItem> items) {
        return items.stream()
                .mapToDouble(item -> item.getPrice() * item.getQuantity())
                .sum();
    }

    private double getDiscountRate(Object principal) {
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

    /**
     * Lấy giỏ hàng từ Session
     */
    @SuppressWarnings("unchecked")
    private Map<Integer, CartItem> getCartFromSession(HttpSession session) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    /**
     * API: Lấy giỏ hàng hiện tại (Cho script.js đồng bộ)
     */
    @GetMapping("/api/cart")
    @ResponseBody
    public Map<Integer, CartItem> getCartApi(HttpSession session) {
        return getCartFromSession(session);
    }
}
