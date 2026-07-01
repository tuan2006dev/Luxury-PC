package poly.edu.controller.web;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import poly.edu.service.WishlistService;

@Controller
public class WishlistController {

    private final WishlistService wishlistService;

    public WishlistController(WishlistService wishlistService) {
        this.wishlistService = wishlistService;
    }

    @PostMapping("/wishlist/{productId}")
    public String addToWishlist(
            @PathVariable Integer productId,
            @RequestParam(value = "redirect", required = false) String redirect,
            Authentication authentication) {
        try {
            wishlistService.addProduct(authentication, productId);
        } catch (Exception ignored) {
            // redirect anyway; user may need to log in (handled by security)
        }
        return "redirect:" + sanitizeRedirect(redirect);
    }

    @PostMapping("/wishlist/{productId}/remove")
    public String removeFromWishlist(
            @PathVariable Integer productId,
            @RequestParam(value = "redirect", required = false) String redirect,
            Authentication authentication) {
        try {
            wishlistService.removeProduct(authentication, productId);
        } catch (Exception ignored) {
        }
        return "redirect:" + sanitizeRedirect(redirect);
    }

    @PostMapping("/wishlist/clear")
    public String clearWishlist(
            @RequestParam(value = "redirect", required = false) String redirect,
            Authentication authentication) {
        try {
            wishlistService.clear(authentication);
        } catch (Exception ignored) {
        }
        return "redirect:" + sanitizeRedirect(redirect);
    }

    private static String sanitizeRedirect(String redirect) {
        if (redirect == null || redirect.isBlank()) {
            return "/";
        }
        String r = redirect.trim();
        if (r.startsWith("http://") || r.startsWith("https://") || r.startsWith("//")) {
            return "/";
        }
        if (!r.startsWith("/")) {
            return "/" + r;
        }
        return r;
    }
}
