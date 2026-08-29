package poly.edu.controller.web;

import lombok.RequiredArgsConstructor;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.entity.*;
import poly.edu.dao.*;
import poly.edu.service.VoucherService;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@SuppressWarnings({"null", "unchecked"})
@RequiredArgsConstructor
public class CartController {

    private final ProductDAO productDAO;

    private final VoucherService voucherService;

    private final poly.edu.service.CartService cartService;

    private final poly.edu.service.FlashSaleService flashSaleService;

    private final UserVoucherDAO userVoucherDAO;

    private final UserDAO userDAO;

    /**
     * 1. THÊM SẢN PHẨM: Xử lý khi nhấn "THÊM VÀO GIỎ HÀNG"
     */
    @PostMapping("/cart/add")
    public String addToCart(@RequestParam("id") Integer id,
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "price", required = false) Double price,
            @RequestParam(value = "quantity", defaultValue = "1") Integer quantity,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            @AuthenticationPrincipal Object principal) {

        Map<Integer, CartItem> cart = getCartFromSession(session);
        int currentInCart = cart.containsKey(id) ? cart.get(id).getQuantity() : 0;

        int productStock = 5;
        Optional<Product> pOpt = productDAO.findById(id);
        if (pOpt.isPresent()) {
            productStock = pOpt.get().getStock();
            if (name == null || "1".equals(name) || name.isEmpty() || name.equals("undefined")) {
                name = pOpt.get().getName();
            }
            if (price == null || price.isNaN()) {
                price = pOpt.get().getPrice();
            }
        }

        if (productStock <= 0) {
            redirectAttributes.addAttribute("error", "Sản phẩm \"" + name + "\" đã hết hàng!");
            return "redirect:/cart";
        }

        // Giới hạn thêm theo số lượng Flash Sale còn lại nếu sản phẩm đang chạy Flash
        // Sale
        int maxAllowed = productStock;
        Optional<poly.edu.entity.FlashSaleItem> fsiOpt = flashSaleService.getActiveFlashSaleItem(id);
        if (fsiOpt.isPresent()) {
            poly.edu.entity.FlashSaleItem fsi = fsiOpt.get();
            int remainingSale = fsi.getSaleQuantity() - fsi.getSoldCount();
            maxAllowed = Math.min(productStock, remainingSale);
        }

        if (maxAllowed <= 0) {
            redirectAttributes.addAttribute("error",
                    "Sản phẩm \"" + name + "\" đã hết hàng hoặc đã hết lượt giảm giá Flash Sale!");
            return "redirect:/cart";
        }

        if (currentInCart + quantity > maxAllowed) {
            int allowedQuantity = Math.max(0, maxAllowed - currentInCart);
            if (allowedQuantity <= 0) {
                redirectAttributes.addAttribute("error",
                        "Sản phẩm \"" + name + "\" đã đạt giới hạn tối đa có thể mua (" + maxAllowed + " sản phẩm)!");
                return "redirect:/cart";
            }
            quantity = allowedQuantity;
        }

        if (cart.containsKey(id)) {
            CartItem item = cart.get(id);
            item.setQuantity(item.getQuantity() + quantity);
        } else {
            cart.put(id, new CartItem(id, name, price, quantity));
        }

        session.setAttribute("cart", cart);
        syncDbCartIfLoggedIn(principal, cart);
        return "redirect:/cart";
    }

    /**
     * 1b. AJAX: Thêm sản phẩm vào giỏ, trả về JSON (dùng cho nút thêm nhanh trên
     * các trang)
     */
    @PostMapping("/api/cart/add")
    @ResponseBody
    public Map<String, Object> addToCartAjax(@RequestParam("id") Integer id,
            @RequestParam(value = "quantity", defaultValue = "1") Integer quantity,
            HttpSession session,
            @AuthenticationPrincipal Object principal) {
        Map<String, Object> result = new HashMap<>();

        Optional<Product> pOpt = productDAO.findById(id);
        if (pOpt.isEmpty()) {
            result.put("success", false);
            result.put("message", "Sản phẩm không tồn tại!");
            return result;
        }

        Product product = pOpt.get();
        String name = product.getName();
        double price = product.getPrice();
        int productStock = product.getStock();

        if (productStock <= 0) {
            result.put("success", false);
            result.put("message", "Sản phẩm \"" + name + "\" đã hết hàng!");
            return result;
        }

        // Kiểm tra Flash Sale
        Optional<poly.edu.entity.FlashSaleItem> fsiOpt = flashSaleService.getActiveFlashSaleItem(id);
        int maxAllowed = productStock;
        if (fsiOpt.isPresent()) {
            poly.edu.entity.FlashSaleItem fsi = fsiOpt.get();
            price = fsi.getSalePrice();
            maxAllowed = Math.min(productStock, fsi.getSaleQuantity() - fsi.getSoldCount());
        }

        if (maxAllowed <= 0) {
            result.put("success", false);
            result.put("message", "Sản phẩm đã hết lượt Flash Sale!");
            return result;
        }

        Map<Integer, CartItem> cart = getCartFromSession(session);
        int currentInCart = cart.containsKey(id) ? cart.get(id).getQuantity() : 0;

        if (currentInCart + quantity > maxAllowed) {
            int allowedQty = Math.max(0, maxAllowed - currentInCart);
            if (allowedQty <= 0) {
                result.put("success", false);
                result.put("message",
                        "Sản phẩm \"" + name + "\" đã đạt giới hạn tối đa (" + maxAllowed + " sản phẩm)!");
                return result;
            }
            quantity = allowedQty;
        }

        if (cart.containsKey(id)) {
            cart.get(id).setQuantity(cart.get(id).getQuantity() + quantity);
        } else {
            cart.put(id, new CartItem(id, name, price, quantity));
        }

        session.setAttribute("cart", cart);
        syncDbCartIfLoggedIn(principal, cart);
        result.put("success", true);
        result.put("message", "Đã thêm \"" + name + "\" vào giỏ hàng!");
        result.put("cartCount", cart.size());
        return result;
    }

    @PostMapping("/cart/buy-now")
    public String buyNow(@RequestParam("id") Integer id,
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "price", required = false) Double price,
            @RequestParam(value = "quantity", defaultValue = "1") Integer quantity,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            @AuthenticationPrincipal Object principal) {

        Map<Integer, CartItem> cart = getCartFromSession(session);
        int currentInCart = cart.containsKey(id) ? cart.get(id).getQuantity() : 0;

        int productStock = 5;
        Optional<Product> pOpt = productDAO.findById(id);
        if (pOpt.isPresent()) {
            productStock = pOpt.get().getStock();
            if (name == null || "1".equals(name) || name.isEmpty() || name.equals("undefined")) {
                name = pOpt.get().getName();
            }
            if (price == null || price.isNaN()) {
                price = pOpt.get().getPrice();
            }
        }

        if (productStock <= 0) {
            redirectAttributes.addAttribute("error", "Sản phẩm \"" + name + "\" đã hết hàng!");
            return "redirect:/cart";
        }

        // Giới hạn thêm theo số lượng Flash Sale còn lại nếu sản phẩm đang chạy Flash
        // Sale
        int maxAllowed = productStock;
        Optional<poly.edu.entity.FlashSaleItem> fsiOpt = flashSaleService.getActiveFlashSaleItem(id);
        if (fsiOpt.isPresent()) {
            poly.edu.entity.FlashSaleItem fsi = fsiOpt.get();
            int remainingSale = fsi.getSaleQuantity() - fsi.getSoldCount();
            maxAllowed = Math.min(productStock, remainingSale);
        }

        if (maxAllowed <= 0) {
            redirectAttributes.addAttribute("error",
                    "Sản phẩm \"" + name + "\" đã hết hàng hoặc đã hết lượt giảm giá Flash Sale!");
            return "redirect:/cart";
        }

        if (currentInCart + quantity > maxAllowed) {
            int allowedQuantity = Math.max(0, maxAllowed - currentInCart);
            if (allowedQuantity <= 0) {
                redirectAttributes.addAttribute("error",
                        "Sản phẩm \"" + name + "\" đã đạt giới hạn tối đa có thể mua (" + maxAllowed + " sản phẩm)!");
                return "redirect:/cart";
            }
            quantity = allowedQuantity;
        }

        Map<Integer, CartItem> buyNowCart = new java.util.HashMap<>();
        buyNowCart.put(id, new CartItem(id, name, price, quantity));

        session.setAttribute("buyNowCart", buyNowCart);
        return "redirect:/checkout?type=buynow";
    }

    @PostMapping("/api/cart/add-build")
    @ResponseBody
    public java.util.Map<String, Object> addBuildToCart(@RequestBody java.util.List<Integer> productIds,
            HttpSession session, @AuthenticationPrincipal Object principal) {
        Map<Integer, CartItem> cart = getCartFromSession(session);
        java.util.Map<String, Object> response = new HashMap<>();

        try {
            for (Integer id : productIds) {
                if (id == null)
                    continue;
                Optional<Product> pOpt = productDAO.findById(id);
                if (pOpt.isPresent()) {
                    Product p = pOpt.get();
                    if (cart.containsKey(id)) {
                        CartItem item = cart.get(id);
                        item.setQuantity(item.getQuantity() + 1);
                    } else {
                        cart.put(id, new CartItem(id, p.getName(), p.getPrice(), 1));
                    }
                }
            }
            session.setAttribute("cart", cart);
            syncDbCartIfLoggedIn(principal, cart);
            response.put("success", true);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    /**
     * 2. CẬP NHẬT SỐ LƯỢNG (Dùng AJAX từ cart.html)
     */
    @PostMapping("/cart/update")
    @ResponseBody
    public Map<String, Object> updateCart(@RequestParam("id") Integer id,
            @RequestParam("quantity") Integer quantity,
            HttpSession session,
            @AuthenticationPrincipal Object principal) {
        Map<String, Object> response = new HashMap<>();
        Map<Integer, CartItem> cart = getCartFromSession(session);
        if (cart.containsKey(id)) {
            int productStock = 5;
            String prodName = cart.get(id).getName();
            Optional<Product> pOpt = productDAO.findById(id);
            if (pOpt.isPresent()) {
                productStock = pOpt.get().getStock();
                prodName = pOpt.get().getName();
            }

            // Giới hạn thêm theo số lượng Flash Sale còn lại nếu sản phẩm đang chạy Flash
            // Sale
            int maxAllowed = productStock;
            Optional<poly.edu.entity.FlashSaleItem> fsiOpt = flashSaleService.getActiveFlashSaleItem(id);
            if (fsiOpt.isPresent()) {
                poly.edu.entity.FlashSaleItem fsi = fsiOpt.get();
                int remainingSale = fsi.getSaleQuantity() - fsi.getSoldCount();
                maxAllowed = Math.min(productStock, remainingSale);
            }

            if (quantity > maxAllowed) {
                response.put("success", false);
                response.put("message", "Số lượng yêu cầu vượt quá giới hạn tối đa có thể mua của \"" + prodName
                        + "\" (chỉ còn " + maxAllowed + " sản phẩm)!");
                response.put("maxStock", maxAllowed);
                return response;
            }
            if (quantity > 0) {
                cart.get(id).setQuantity(quantity);
            } else {
                cart.remove(id);
            }
            session.setAttribute("cart", cart);
            syncDbCartIfLoggedIn(principal, cart);
        }
        response.put("success", true);
        return response;
    }

    /**
     * 3. XÓA SẢN PHẨM
     */
    @PostMapping("/cart/remove")
    @ResponseBody
    public String removeFromCart(@RequestParam("id") Integer id, HttpSession session,
            @AuthenticationPrincipal Object principal) {
        Map<Integer, CartItem> cart = getCartFromSession(session);
        if (cart.containsKey(id)) {
            cart.remove(id);
            session.setAttribute("cart", cart);
            syncDbCartIfLoggedIn(principal, cart);
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

        User currentUser = getUserFromPrincipal(principal);
        if (currentUser != null) {
            if (cart.isEmpty()) {
                Map<Integer, CartItem> dbCart = cartService.loadCartFromDb(currentUser);
                if (!dbCart.isEmpty()) {
                    cart.putAll(dbCart);
                    session.setAttribute("cart", cart);
                }
            } else {
                cartService.saveCartToDb(currentUser, cart);
            }
        }

        java.util.Iterator<CartItem> iterator = cart.values().iterator();
        boolean cartChanged = false;
        while (iterator.hasNext()) {
            CartItem item = iterator.next();
            if (item == null || item.getId() == null) {
                iterator.remove();
                cartChanged = true;
                continue;
            }

            Optional<Product> pOpt = productDAO.findById(item.getId());
            if (pOpt.isPresent()) {
                Product product = pOpt.get();
                item.setImage(product.getImage());
                item.setStock(product.getStock() != null ? product.getStock() : 5);
                
                Double price = null;
                if (flashSaleService != null) {
                    try {
                        price = flashSaleService.getEffectivePrice(product.getId());
                    } catch (Exception ignored) {}
                }
                if (price == null) {
                    price = product.getPrice() != null ? product.getPrice() : 0.0;
                }
                item.setPrice(price);
            } else {
                item.setStock(5);
                if (item.getPrice() == null) {
                    item.setPrice(0.0);
                }
            }

            if (item.getStock() == null || item.getStock() <= 0) {
                iterator.remove();
                cartChanged = true;
            } else if (item.getQuantity() != null && item.getQuantity() > item.getStock()) {
                item.setQuantity(item.getStock());
                cartChanged = true;
            }
        }
        if (cartChanged) {
            session.setAttribute("cart", cart);
        }

        double baseTotal = cartService.calculateTotal(cart.values());
        double discountRate = cartService.getDiscountRate(principal);

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
    public String viewCheckout(Model model, HttpSession session, @AuthenticationPrincipal Object principal,
            @RequestParam(value = "type", required = false) String type,
            @RequestParam(value = "success", required = false) String success) {
        if (principal == null && success == null) {
            return "redirect:/auth/login";
        }

        if (success != null) {
            model.addAttribute("checkoutType", "cart");
            model.addAttribute("cartItems", new java.util.ArrayList<>());
            model.addAttribute("totalPrice", 0.0);
            model.addAttribute("discountAmt", 0.0);
            model.addAttribute("finalPrice", 0.0);
            model.addAttribute("activeVouchers", new java.util.ArrayList<>());
            model.addAttribute("userVouchers", new java.util.ArrayList<>());
            model.addAttribute("hasFlashSaleItem", false);
            return "checkout";
        }

        Map<Integer, CartItem> targetCart;
        if ("buynow".equals(type)) {
            targetCart = (Map<Integer, CartItem>) session.getAttribute("buyNowCart");
            model.addAttribute("checkoutType", "buynow");
        } else {
            targetCart = getCartFromSession(session);
            model.addAttribute("checkoutType", "cart");
        }

        if (targetCart == null || targetCart.isEmpty()) {
            return "redirect:/cart";
        }

        java.util.Iterator<CartItem> iterator = targetCart.values().iterator();
        boolean cartChanged = false;
        while (iterator.hasNext()) {
            CartItem item = iterator.next();
            Optional<Product> pOpt = productDAO.findById(item.getId());
            if (pOpt.isPresent()) {
                Product product = pOpt.get();
                item.setImage(product.getImage());
                item.setStock(product.getStock() != null ? product.getStock() : 0);
                item.setPrice(flashSaleService.getEffectivePrice(product.getId()));
            } else {
                item.setStock(5);
            }

            if (item.getStock() == null || item.getStock() <= 0) {
                iterator.remove();
                cartChanged = true;
            } else if (item.getQuantity() != null && item.getStock() != null && item.getQuantity() > item.getStock()) {
                item.setQuantity(item.getStock());
                cartChanged = true;
            }
        }
        if (cartChanged) {
            if ("buynow".equals(type)) {
                session.setAttribute("buyNowCart", targetCart);
            } else {
                session.setAttribute("cart", targetCart);
            }
        }

        if (targetCart.isEmpty()) {
            return "redirect:/cart";
        }

        double baseTotal = cartService.calculateTotal(targetCart.values());
        double discountRate = cartService.getDiscountRate(principal);

        boolean hasFlashSaleItem = false;
        for (CartItem item : targetCart.values()) {
            if (flashSaleService.getActiveFlashSaleItem(item.getId()).isPresent()) {
                hasFlashSaleItem = true;
                break;
            }
        }

        model.addAttribute("cartItems", targetCart.values());
        model.addAttribute("totalPrice", baseTotal);
        model.addAttribute("discountRate", discountRate);
        model.addAttribute("discountAmt", baseTotal * discountRate);
        model.addAttribute("finalPrice", baseTotal - (baseTotal * discountRate));
        List<Voucher> activeVouchers = new java.util.ArrayList<>(voucherService.getActiveVouchers());
        model.addAttribute("hasFlashSaleItem", hasFlashSaleItem);

        if (principal != null) {
            String emailOrUsername = "";
            if (principal instanceof org.springframework.security.oauth2.core.user.OAuth2User oauthUser) {
                emailOrUsername = (String) oauthUser.getAttributes().get("email");
            } else if (principal instanceof org.springframework.security.core.userdetails.User u) {
                emailOrUsername = u.getUsername();
            }
            User currentUser = userDAO.findByEmail(emailOrUsername);
            if (currentUser == null)
                currentUser = userDAO.findByUsername(emailOrUsername);
            if (currentUser != null) {
                List<UserVoucher> userVouchers = userVoucherDAO.findByUserAndStatusOrderBySavedAtDesc(currentUser,
                        "AVAILABLE");
                model.addAttribute("userVouchers", userVouchers);

                List<UserVoucher> consumed = userVoucherDAO.findByUserAndStatusOrderBySavedAtDesc(currentUser,
                        "CONSUMED");
                List<String> consumedCodes = consumed.stream().map(uv -> uv.getVoucher().getCode()).toList();
                activeVouchers.removeIf(v -> consumedCodes.contains(v.getCode()));
            }
        }

        model.addAttribute("activeVouchers", activeVouchers);

        return "checkout";
    }

    @org.springframework.beans.factory.annotation.Value("${shipping.national.fee:32000}")
    private int nationalShippingFee;

    @PostMapping("/checkout/submit")
    public String submitCheckout(
            @RequestParam("fullName") String fullName,
            @RequestParam("phone") String phone,
            @RequestParam("address") String address,
            @RequestParam(value = "paymentMethod", defaultValue = "COD") String paymentMethod,
            @RequestParam(value = "voucherCode", required = false) String voucherCode,
            @RequestParam(value = "freeshipCode", required = false) String freeshipCode,
            @RequestParam(value = "shippingFee", defaultValue = "0") Double shippingFee,
            @RequestParam(value = "shippingMethodName", defaultValue = "") String shippingMethodName,
            @RequestParam(value = "checkoutType", defaultValue = "cart") String checkoutType,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            @AuthenticationPrincipal Object principal) {

        if (principal == null) {
            redirectAttributes.addAttribute("error", "Vui lòng đăng nhập để tiến hành đặt hàng!");
            return "redirect:/auth/login";
        }

        // Backend Validation: Chặn bypass phí vận chuyển
        boolean isExpressOrStore = shippingMethodName.toLowerCase().contains("hỏa tốc")
                || shippingMethodName.toLowerCase().contains("cửa hàng");
        String addrLower = address.toLowerCase();
        boolean isAddressHCM = addrLower.contains("hồ chí minh") || addrLower.contains("hcm")
                || addrLower.contains("ho chi minh");

        if (isExpressOrStore && !isAddressHCM) {
            // Chặn đơn hàng: Nếu chọn Hỏa Tốc hoặc Cửa Hàng mà địa chỉ không ở TP.HCM
            redirectAttributes.addAttribute("error",
                    "Địa chỉ giao hàng không hợp lệ cho phương thức vận chuyển đã chọn. Vui lòng không giả mạo vị trí.");
            return "redirect:/cart";
        }

        if (!isExpressOrStore && shippingFee < nationalShippingFee && shippingFee > 0) {
            redirectAttributes.addAttribute("error", "Phí giao hàng không hợp lệ. Vui lòng tải lại trang.");
            return "redirect:/cart";
        }

        Map<Integer, CartItem> targetCart;
        if ("buynow".equals(checkoutType)) {
            targetCart = (Map<Integer, CartItem>) session.getAttribute("buyNowCart");
        } else {
            targetCart = getCartFromSession(session);
        }

        if (targetCart == null || targetCart.isEmpty())
            return "redirect:/cart";

        try {
            Order order = cartService.processCheckout(targetCart, fullName, phone, address, paymentMethod, voucherCode,
                    freeshipCode, shippingFee, shippingMethodName, principal);

            if ("buynow".equals(checkoutType)) {
                session.removeAttribute("buyNowCart");
            } else {
                session.removeAttribute("cart");
            }

            if ("VIETQR".equalsIgnoreCase(paymentMethod)) {
                redirectAttributes.addAttribute("amount", Math.round(order.getTotalPrice()));
                redirectAttributes.addAttribute("orderCode", order.getOrderCode());
                return "redirect:/payment/vietqr";
            }

            return "redirect:/checkout?success";
        } catch (Exception e) {
            redirectAttributes.addAttribute("error", e.getMessage());
            return "redirect:/cart";
        }
    }

    /**
     * Lấy giỏ hàng từ Session
     */
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
    public Map<Integer, CartItem> getCartApi(HttpSession session, @AuthenticationPrincipal Object principal) {
        Map<Integer, CartItem> cart = getCartFromSession(session);

        User currentUser = getUserFromPrincipal(principal);
        if (currentUser != null && cart.isEmpty()) {
            Map<Integer, CartItem> dbCart = cartService.loadCartFromDb(currentUser);
            if (!dbCart.isEmpty()) {
                cart.putAll(dbCart);
                session.setAttribute("cart", cart);
            }
        }

        boolean cartChanged = false;

        if (!cart.isEmpty()) {
            java.util.List<Integer> productIds = new java.util.ArrayList<>(cart.keySet());
            java.util.List<Product> products = productDAO.findAllById(productIds);
            java.util.Map<Integer, Product> productMap = products.stream()
                    .collect(java.util.stream.Collectors.toMap(Product::getId, p -> p));

            java.util.Iterator<CartItem> iterator = cart.values().iterator();
            while (iterator.hasNext()) {
                CartItem item = iterator.next();
                Product p = productMap.get(item.getId());

                if (p != null) {
                    item.setStock(p.getStock() != null ? p.getStock() : 0);
                    item.setImage(p.getImage());
                } else {
                    item.setStock(5);
                }

                if (item.getStock() == null || item.getStock() <= 0) {
                    iterator.remove();
                    cartChanged = true;
                } else if (item.getQuantity() != null && item.getStock() != null && item.getQuantity() > item.getStock()) {
                    item.setQuantity(item.getStock());
                    cartChanged = true;
                }
            }
        }
        if (cartChanged) {
            session.setAttribute("cart", cart);
            syncDbCartIfLoggedIn(principal, cart);
        }
        return cart;
    }

    private User getUserFromPrincipal(Object principal) {
        if (principal == null)
            return null;
        if (principal instanceof User u)
            return u;

        String emailOrUsername = null;
        if (principal instanceof org.springframework.security.oauth2.core.user.OAuth2User oauthUser) {
            Object emailObj = oauthUser.getAttribute("email");
            if (emailObj != null) {
                emailOrUsername = emailObj.toString();
            } else {
                emailOrUsername = oauthUser.getName();
            }
        } else if (principal instanceof org.springframework.security.core.userdetails.User u) {
            emailOrUsername = u.getUsername();
        } else if (principal instanceof org.springframework.security.core.Authentication auth) {
            return getUserFromPrincipal(auth.getPrincipal());
        } else {
            emailOrUsername = principal.toString();
        }

        if (emailOrUsername == null || emailOrUsername.isBlank())
            return null;
        emailOrUsername = emailOrUsername.trim().toLowerCase();

        User user = userDAO.findByEmail(emailOrUsername);
        if (user == null) {
            user = userDAO.findByUsername(emailOrUsername);
        }
        return user;
    }

    private void syncDbCartIfLoggedIn(Object principal, Map<Integer, CartItem> cart) {
        User currentUser = getUserFromPrincipal(principal);
        if (currentUser != null) {
            cartService.saveCartToDb(currentUser, cart);
        }
    }
}
