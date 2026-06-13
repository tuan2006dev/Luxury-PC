package poly.edu.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import poly.edu.dto.ApiResponse;
import poly.edu.entity.WishlistItem;
import poly.edu.service.WishlistService;

@RestController
@RequestMapping("/api/wishlist")
public class WishlistRestController {

    private final WishlistService wishlistService;

    public WishlistRestController(WishlistService wishlistService) {
        this.wishlistService = wishlistService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getWishlist(Authentication authentication) {
        if (!isAuthenticatedUser(authentication)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(ApiResponse.error("Vui lòng đăng nhập.", List.of()));
        }
        List<Map<String, Object>> data = wishlistService.getWishlistItems(authentication)
                .stream()
                .map(this::wishlistData)
                .toList();
        return ResponseEntity.ok(ApiResponse.success("Success", data));
    }

    @PostMapping("/toggle/{productId}")
    public ResponseEntity<Map<String, Object>> toggle(
            @PathVariable Integer productId,
            Authentication authentication) {
        if (!isAuthenticatedUser(authentication)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                    "success", false,
                    "loginRequired", true,
                    "message", "Vui lòng đăng nhập để lưu sản phẩm yêu thích."));
        }
        try {
            boolean wished = wishlistService.toggleProduct(authentication, productId);
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("success", true);
            body.put("wished", wished);
            body.put("wishlistCount", wishlistService.getWishlistCount(authentication));
            body.put("message", wished ? "Đã thêm vào danh sách yêu thích"
                    : "Đã xóa khỏi danh sách yêu thích");
            return ResponseEntity.ok(body);
        } catch (Exception ex) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Không thể cập nhật danh sách yêu thích."));
        }
    }

    @DeleteMapping("/remove/{wishlistItemId}")
    public ResponseEntity<Map<String, Object>> removeItem(
            @PathVariable Integer wishlistItemId,
            Authentication authentication) {
        if (!isAuthenticatedUser(authentication)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(unauthorized());
        }
        try {
            wishlistService.removeWishlistItem(authentication, wishlistItemId);
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("success", true);
            body.put("wishlistCount", wishlistService.getWishlistCount(authentication));
            body.put("message", "Đã xóa khỏi danh sách yêu thích.");
            return ResponseEntity.ok(body);
        } catch (Exception ex) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Không thể xóa sản phẩm yêu thích."));
        }
    }

    @DeleteMapping("/remove-all")
    public ResponseEntity<Map<String, Object>> removeAll(Authentication authentication) {
        if (!isAuthenticatedUser(authentication)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(unauthorized());
        }
        try {
            wishlistService.clear(authentication);
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("success", true);
            body.put("wishlistCount", 0L);
            body.put("message", "Đã xóa tất cả khỏi danh sách yêu thích.");
            return ResponseEntity.ok(body);
        } catch (Exception ex) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "Không thể xóa danh sách yêu thích."));
        }
    }

    private static boolean isAuthenticatedUser(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return false;
        }
        Object principal = authentication.getPrincipal();
        return principal != null && !"anonymousUser".equals(String.valueOf(principal));
    }

    private static Map<String, Object> unauthorized() {
        return Map.of(
                "success", false,
                "loginRequired", true,
                "message", "Vui lòng đăng nhập.");
    }

    private Map<String, Object> wishlistData(WishlistItem item) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", item.getId());
        if (item.getProduct() != null) {
            m.put("productId", item.getProduct().getId());
            m.put("productName", item.getProduct().getName());
            m.put("price", item.getProduct().getPrice());
            m.put("image", item.getProduct().getImage());
            m.put("category", item.getProduct().getCategory() == null ? null : item.getProduct().getCategory().getName());
        }
        return m;
    }
}
