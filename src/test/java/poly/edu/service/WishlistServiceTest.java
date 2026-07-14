package poly.edu.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.core.Authentication;

import poly.edu.dao.ProductDAO;
import poly.edu.entity.Product;
import poly.edu.entity.User;
import poly.edu.entity.WishlistItem;
import poly.edu.repository.WishlistItemRepository;

@ExtendWith(MockitoExtension.class)
public class WishlistServiceTest {

    @Mock
    private ProfileService profileService;

    @Mock
    private WishlistItemRepository wishlistItemRepository;

    @Mock
    private ProductDAO productDAO;

    @Mock
    private Authentication authentication;

    @InjectMocks
    private WishlistService wishlistService;

    private User mockUser;
    private Product mockProduct;

    @BeforeEach
    void setUp() {
        mockUser = new User();
        mockUser.setId(1);

        mockProduct = new Product();
        mockProduct.setId(100);
    }

    // --- getWishlistItems Tests ---

    @Test
    void testGetWishlistItems_AuthenticationNull_ReturnsEmptyList() {
        List<WishlistItem> items = wishlistService.getWishlistItems(null);
        assertTrue(items.isEmpty());
        verifyNoInteractions(profileService, wishlistItemRepository);
    }

    @Test
    void testGetWishlistItems_NotAuthenticated_ReturnsEmptyList() {
        when(authentication.isAuthenticated()).thenReturn(false);

        List<WishlistItem> items = wishlistService.getWishlistItems(authentication);

        assertTrue(items.isEmpty());
        verifyNoInteractions(profileService, wishlistItemRepository);
    }

    @Test
    void testGetWishlistItems_Authenticated_ReturnsList() {
        when(authentication.isAuthenticated()).thenReturn(true);
        when(authentication.getPrincipal()).thenReturn("testUser");
        when(profileService.getCurrentUser(authentication)).thenReturn(mockUser);
        
        WishlistItem item = new WishlistItem();
        item.setId(10);
        when(wishlistItemRepository.findByUser_IdOrderByCreatedAtDesc(1)).thenReturn(List.of(item));

        List<WishlistItem> items = wishlistService.getWishlistItems(authentication);

        assertEquals(1, items.size());
        assertEquals(10, items.get(0).getId());
    }

    @Test
    void testGetWishlistItems_ExceptionThrown_ReturnsEmptyList() {
        when(authentication.isAuthenticated()).thenReturn(true);
        when(authentication.getPrincipal()).thenReturn("testUser");
        when(profileService.getCurrentUser(authentication)).thenThrow(new RuntimeException("DB Error"));

        List<WishlistItem> items = wishlistService.getWishlistItems(authentication);

        assertTrue(items.isEmpty());
    }

    // --- getWishlistCount Tests ---

    @Test
    void testGetWishlistCount_Authenticated_ReturnsCount() {
        when(authentication.isAuthenticated()).thenReturn(true);
        when(authentication.getPrincipal()).thenReturn("testUser");
        when(profileService.getCurrentUser(authentication)).thenReturn(mockUser);
        when(wishlistItemRepository.countByUser_Id(1)).thenReturn(5L);

        long count = wishlistService.getWishlistCount(authentication);

        assertEquals(5L, count);
    }

    @Test
    void testGetWishlistCount_ExceptionThrown_ReturnsZero() {
        when(authentication.isAuthenticated()).thenReturn(true);
        when(authentication.getPrincipal()).thenReturn("testUser");
        when(profileService.getCurrentUser(authentication)).thenThrow(new RuntimeException("DB Error"));

        long count = wishlistService.getWishlistCount(authentication);

        assertEquals(0L, count);
    }

    // --- getWishlistProductIds Tests ---

    @Test
    void testGetWishlistProductIds_Authenticated_ReturnsIds() {
        when(authentication.isAuthenticated()).thenReturn(true);
        when(authentication.getPrincipal()).thenReturn("testUser");
        when(profileService.getCurrentUser(authentication)).thenReturn(mockUser);
        when(wishlistItemRepository.findProductIdsByUserId(1)).thenReturn(Set.of(100, 101));

        Set<Integer> ids = wishlistService.getWishlistProductIds(authentication);

        assertEquals(2, ids.size());
        assertTrue(ids.contains(100));
    }

    // --- addProduct Tests ---

    @Test
    void testAddProduct_ProductNotFound_ThrowsException() {
        when(profileService.getCurrentUser(authentication)).thenReturn(mockUser);
        when(productDAO.findById(999)).thenReturn(Optional.empty());

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
            wishlistService.addProduct(authentication, 999);
        });
        assertEquals("Không tìm thấy sản phẩm", ex.getMessage());
    }

    @Test
    void testAddProduct_AlreadyExists_DoesNothing() {
        when(profileService.getCurrentUser(authentication)).thenReturn(mockUser);
        when(productDAO.findById(100)).thenReturn(Optional.of(mockProduct));
        when(wishlistItemRepository.existsByUser_IdAndProduct_Id(1, 100)).thenReturn(true);

        wishlistService.addProduct(authentication, 100);

        verify(wishlistItemRepository, never()).save(any(WishlistItem.class));
    }

    @Test
    void testAddProduct_Success() {
        when(profileService.getCurrentUser(authentication)).thenReturn(mockUser);
        when(productDAO.findById(100)).thenReturn(Optional.of(mockProduct));
        when(wishlistItemRepository.existsByUser_IdAndProduct_Id(1, 100)).thenReturn(false);

        wishlistService.addProduct(authentication, 100);

        verify(wishlistItemRepository).save(any(WishlistItem.class));
    }

    // --- removeProduct Tests ---

    @Test
    void testRemoveProduct_Success() {
        when(profileService.getCurrentUser(authentication)).thenReturn(mockUser);

        wishlistService.removeProduct(authentication, 100);

        verify(wishlistItemRepository).deleteByUserIdAndProductId(1, 100);
    }

    // --- toggleProduct Tests ---

    @Test
    void testToggleProduct_Exists_DeletesAndReturnsFalse() {
        when(profileService.getCurrentUser(authentication)).thenReturn(mockUser);
        when(wishlistItemRepository.existsByUser_IdAndProduct_Id(1, 100)).thenReturn(true);

        boolean result = wishlistService.toggleProduct(authentication, 100);

        assertFalse(result);
        verify(wishlistItemRepository).deleteByUserIdAndProductId(1, 100);
        verify(productDAO, never()).findById(anyInt());
    }

    @Test
    void testToggleProduct_NotExists_AddsAndReturnsTrue() {
        when(profileService.getCurrentUser(authentication)).thenReturn(mockUser);
        when(wishlistItemRepository.existsByUser_IdAndProduct_Id(1, 100)).thenReturn(false);
        when(productDAO.findById(100)).thenReturn(Optional.of(mockProduct));

        boolean result = wishlistService.toggleProduct(authentication, 100);

        assertTrue(result);
        verify(wishlistItemRepository).save(any(WishlistItem.class));
    }

    // --- removeWishlistItem Tests ---

    @Test
    void testRemoveWishlistItem_ItemNotFound_ThrowsException() {
        when(profileService.getCurrentUser(authentication)).thenReturn(mockUser);
        when(wishlistItemRepository.findById(99)).thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class, () -> wishlistService.removeWishlistItem(authentication, 99));
    }

    @Test
    void testRemoveWishlistItem_WrongUser_ThrowsException() {
        when(profileService.getCurrentUser(authentication)).thenReturn(mockUser);
        
        WishlistItem item = new WishlistItem();
        User otherUser = new User();
        otherUser.setId(2); // different from mockUser (id:1)
        item.setUser(otherUser);
        when(wishlistItemRepository.findById(99)).thenReturn(Optional.of(item));

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> wishlistService.removeWishlistItem(authentication, 99));
        assertEquals("Không có quyền xóa mục này", ex.getMessage());
    }

    @Test
    void testRemoveWishlistItem_Success() {
        when(profileService.getCurrentUser(authentication)).thenReturn(mockUser);
        
        WishlistItem item = new WishlistItem();
        item.setUser(mockUser);
        when(wishlistItemRepository.findById(99)).thenReturn(Optional.of(item));

        wishlistService.removeWishlistItem(authentication, 99);

        verify(wishlistItemRepository).delete(item);
    }

    // --- isProductInWishlist Tests ---

    @Test
    void testIsProductInWishlist_NotAuthenticated_ReturnsFalse() {
        when(authentication.isAuthenticated()).thenReturn(false);

        boolean result = wishlistService.isProductInWishlist(authentication, 100);

        assertFalse(result);
    }

    @Test
    void testIsProductInWishlist_AuthenticatedAndExists_ReturnsTrue() {
        when(authentication.isAuthenticated()).thenReturn(true);
        when(authentication.getPrincipal()).thenReturn("testUser");
        when(profileService.getCurrentUser(authentication)).thenReturn(mockUser);
        when(wishlistItemRepository.existsByUser_IdAndProduct_Id(1, 100)).thenReturn(true);

        boolean result = wishlistService.isProductInWishlist(authentication, 100);

        assertTrue(result);
    }

    @Test
    void testIsProductInWishlist_ExceptionThrown_ReturnsFalse() {
        when(authentication.isAuthenticated()).thenReturn(true);
        when(authentication.getPrincipal()).thenReturn("testUser");
        when(profileService.getCurrentUser(authentication)).thenThrow(new RuntimeException("DB Exception"));

        boolean result = wishlistService.isProductInWishlist(authentication, 100);

        assertFalse(result);
    }

    // --- clear Tests ---
    
    @Test
    void testClear_Success() {
        when(profileService.getCurrentUser(authentication)).thenReturn(mockUser);
        
        wishlistService.clear(authentication);
        
        verify(wishlistItemRepository).deleteByUserId(1);
    }
}
