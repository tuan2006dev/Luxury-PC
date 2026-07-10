package poly.edu.controller.web;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.entity.*;
import poly.edu.dao.*;
import poly.edu.service.VoucherService;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Controller
public class CartController {

    @Autowired
    private ProductDAO productDAO;

    @Autowired
    private VoucherService voucherService;

    @Autowired
    private poly.edu.service.CartService cartService;

    @Autowired
    private poly.edu.service.FlashSaleService flashSaleService;

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
        
        // Giới hạn thêm theo số lượng Flash Sale còn lại nếu sản phẩm đang chạy Flash Sale
        int maxAllowed = productStock;
        Optional<poly.edu.entity.FlashSaleItem> fsiOpt = flashSaleService.getActiveFlashSaleItem(id);
        if (fsiOpt.isPresent()) {
            if (principal == null) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng đăng nhập để mua sản phẩm Flash Sale!");
                return "redirect:/auth/login";
            }
            poly.edu.entity.FlashSaleItem fsi = fsiOpt.get();
            int remainingSale = fsi.getSaleQuantity() - fsi.getSoldCount();
            maxAllowed = Math.min(productStock, remainingSale);
        }

        if (maxAllowed <= 0) {
            redirectAttributes.addAttribute("error", "Sản phẩm \"" + name + "\" đã hết hàng hoặc đã hết lượt giảm giá Flash Sale!");
            return "redirect:/cart";
        }

        if (currentInCart + quantity > maxAllowed) {
            int allowedQuantity = Math.max(0, maxAllowed - currentInCart);
            if (allowedQuantity <= 0) {
                redirectAttributes.addAttribute("error", "Sản phẩm \"" + name + "\" đã đạt giới hạn tối đa có thể mua (" + maxAllowed + " sản phẩm)!");
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
        return "redirect:/cart";
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
        
        // Giới hạn thêm theo số lượng Flash Sale còn lại nếu sản phẩm đang chạy Flash Sale
        int maxAllowed = productStock;
        Optional<poly.edu.entity.FlashSaleItem> fsiOpt = flashSaleService.getActiveFlashSaleItem(id);
        if (fsiOpt.isPresent()) {
            if (principal == null) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng đăng nhập để mua sản phẩm Flash Sale!");
                return "redirect:/auth/login";
            }
            poly.edu.entity.FlashSaleItem fsi = fsiOpt.get();
            int remainingSale = fsi.getSaleQuantity() - fsi.getSoldCount();
            maxAllowed = Math.min(productStock, remainingSale);
        }

        if (maxAllowed <= 0) {
            redirectAttributes.addAttribute("error", "Sản phẩm \"" + name + "\" đã hết hàng hoặc đã hết lượt giảm giá Flash Sale!");
            return "redirect:/cart";
        }

        if (currentInCart + quantity > maxAllowed) {
            int allowedQuantity = Math.max(0, maxAllowed - currentInCart);
            if (allowedQuantity <= 0) {
                redirectAttributes.addAttribute("error", "Sản phẩm \"" + name + "\" đã đạt giới hạn tối đa có thể mua (" + maxAllowed + " sản phẩm)!");
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
    public java.util.Map<String, Object> addBuildToCart(@RequestBody java.util.List<Integer> productIds, HttpSession session) {
        Map<Integer, CartItem> cart = getCartFromSession(session);
        java.util.Map<String, Object> response = new HashMap<>();

        try {
            for (Integer id : productIds) {
                if (id == null) continue;
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
            
            // Giới hạn thêm theo số lượng Flash Sale còn lại nếu sản phẩm đang chạy Flash Sale
            int maxAllowed = productStock;
            Optional<poly.edu.entity.FlashSaleItem> fsiOpt = flashSaleService.getActiveFlashSaleItem(id);
            if (fsiOpt.isPresent()) {
                if (principal == null) {
                    response.put("success", false);
                    response.put("message", "Vui lòng đăng nhập để mua sản phẩm Flash Sale!");
                    return response;
                }
                poly.edu.entity.FlashSaleItem fsi = fsiOpt.get();
                int remainingSale = fsi.getSaleQuantity() - fsi.getSoldCount();
                maxAllowed = Math.min(productStock, remainingSale);
            }

            if (quantity > maxAllowed) {
                response.put("success", false);
                response.put("message", "Số lượng yêu cầu vượt quá giới hạn tối đa có thể mua của \"" + prodName + "\" (chỉ còn " + maxAllowed + " sản phẩm)!");
                response.put("maxStock", maxAllowed);
                return response;
            }
            if (quantity > 0) {
                cart.get(id).setQuantity(quantity);
            } else {
                cart.remove(id);
            }
            session.setAttribute("cart", cart);
        }
        response.put("success", true);
        return response;
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

        java.util.Iterator<CartItem> iterator = cart.values().iterator();
        boolean cartChanged = false;
        while (iterator.hasNext()) {
            CartItem item = iterator.next();
            Optional<Product> pOpt = productDAO.findById(item.getId());
            if (pOpt.isPresent()) {
                Product product = pOpt.get();
                item.setImage(product.getImage());
                item.setStock(product.getStock());
            } else {
                item.setStock(5);
            }
            
            if (item.getStock() <= 0) {
                iterator.remove();
                cartChanged = true;
            } else if (item.getQuantity() > item.getStock()) {
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
        if (success != null) {
            model.addAttribute("checkoutType", "cart");
            model.addAttribute("cartItems", new java.util.ArrayList<>());
            model.addAttribute("totalPrice", 0.0);
            model.addAttribute("discountAmt", 0.0);
            model.addAttribute("finalPrice", 0.0);
            model.addAttribute("activeVouchers", new java.util.ArrayList<>());
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
                item.setStock(product.getStock());
            } else {
                item.setStock(5);
            }
            
            if (item.getStock() <= 0) {
                iterator.remove();
                cartChanged = true;
            } else if (item.getQuantity() > item.getStock()) {
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

        model.addAttribute("cartItems", targetCart.values());
        model.addAttribute("totalPrice", baseTotal);
        model.addAttribute("discountAmt", baseTotal * discountRate);
        model.addAttribute("finalPrice", baseTotal - (baseTotal * discountRate));
        model.addAttribute("activeVouchers", voucherService.getActiveVouchers());

        return "checkout";
    }

    @PostMapping("/checkout/submit")
    @Transactional
    public String submitCheckout(
            @RequestParam("fullName") String fullName,
            @RequestParam("phone") String phone,
            @RequestParam("address") String address,
            @RequestParam(value = "paymentMethod", defaultValue = "COD") String paymentMethod,
            @RequestParam(value = "voucherCode", required = false) String voucherCode,
            @RequestParam(value = "checkoutType", defaultValue = "cart") String checkoutType,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            @AuthenticationPrincipal Object principal) {

        Map<Integer, CartItem> targetCart;
        if ("buynow".equals(checkoutType)) {
            targetCart = (Map<Integer, CartItem>) session.getAttribute("buyNowCart");
        } else {
            targetCart = getCartFromSession(session);
        }

        if (targetCart == null || targetCart.isEmpty()) return "redirect:/cart";

        try {
            Order order = cartService.processCheckout(targetCart, fullName, phone, address, paymentMethod, voucherCode, principal);
            
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
        Map<Integer, CartItem> cart = getCartFromSession(session);
        boolean cartChanged = false;
        java.util.Iterator<CartItem> iterator = cart.values().iterator();
        while (iterator.hasNext()) {
            CartItem item = iterator.next();
            Optional<Product> pOpt = productDAO.findById(item.getId());
            if (pOpt.isPresent()) {
                item.setStock(pOpt.get().getStock());
                item.setImage(pOpt.get().getImage());
            } else {
                item.setStock(5);
            }
            
            if (item.getStock() <= 0) {
                iterator.remove();
                cartChanged = true;
            } else if (item.getQuantity() > item.getStock()) {
                item.setQuantity(item.getStock());
                cartChanged = true;
            }
        }
        if (cartChanged) {
            session.setAttribute("cart", cart);
        }
        return cart;
    }
}
