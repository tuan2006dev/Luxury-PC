package poly.edu.service;

import java.util.Collections;
import java.util.List;
import java.util.Set;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import poly.edu.dao.ProductDAO;
import poly.edu.entity.Product;
import poly.edu.entity.User;
import poly.edu.entity.WishlistItem;
import poly.edu.repository.WishlistItemRepository;

@Service
public class WishlistService {

    private final ProfileService profileService;
    private final WishlistItemRepository wishlistItemRepository;
    private final ProductDAO productDAO;

    public WishlistService(ProfileService profileService, WishlistItemRepository wishlistItemRepository,
            ProductDAO productDAO) {
        this.profileService = profileService;
        this.wishlistItemRepository = wishlistItemRepository;
        this.productDAO = productDAO;
    }

    @Transactional(readOnly = true)
    public List<WishlistItem> getWishlistItems(Authentication authentication) {
        if (!isLoggedIn(authentication)) {
            return Collections.emptyList();
        }
        try {
            User user = profileService.getCurrentUser(authentication);
            return wishlistItemRepository.findByUser_IdOrderByCreatedAtDesc(user.getId());
        } catch (Exception ex) {
            return Collections.emptyList();
        }
    }

    @Transactional(readOnly = true)
    public long getWishlistCount(Authentication authentication) {
        if (!isLoggedIn(authentication)) {
            return 0L;
        }
        try {
            User user = profileService.getCurrentUser(authentication);
            return wishlistItemRepository.countByUser_Id(user.getId());
        } catch (Exception ex) {
            return 0L;
        }
    }

    @Transactional(readOnly = true)
    public Set<Integer> getWishlistProductIds(Authentication authentication) {
        if (!isLoggedIn(authentication)) {
            return Collections.emptySet();
        }
        try {
            User user = profileService.getCurrentUser(authentication);
            Set<Integer> ids = wishlistItemRepository.findProductIdsByUserId(user.getId());
            return ids != null ? ids : Collections.emptySet();
        } catch (Exception ex) {
            return Collections.emptySet();
        }
    }

    @Transactional
    public void addProduct(Authentication authentication, Integer productId) {
        User user = profileService.getCurrentUser(authentication);
        Product product = productDAO.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy sản phẩm"));
        if (wishlistItemRepository.existsByUser_IdAndProduct_Id(user.getId(), productId)) {
            return;
        }
        WishlistItem item = new WishlistItem();
        item.setUser(user);
        item.setProduct(product);
        wishlistItemRepository.save(item);
    }

    @Transactional
    public void removeProduct(Authentication authentication, Integer productId) {
        User user = profileService.getCurrentUser(authentication);
        wishlistItemRepository.deleteByUserIdAndProductId(user.getId(), productId);
    }

    @Transactional
    public void clear(Authentication authentication) {
        User user = profileService.getCurrentUser(authentication);
        wishlistItemRepository.deleteByUserId(user.getId());
    }

    private static boolean isLoggedIn(Authentication authentication) {
        return authentication != null && authentication.isAuthenticated();
    }
}
