package poly.edu.controller.web;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import poly.edu.config.SecurityConfig;
import poly.edu.entity.FlashSale;
import poly.edu.security.CustomAuthenticationSuccessHandler;
import poly.edu.security.CustomOAuth2UserService;
import poly.edu.service.*;

import java.util.Collections;
import java.util.Date;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(HomeController.class)
@Import(SecurityConfig.class) // Nạp Security Config để đảm bảo Security không block HomeController
public class HomeControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ProductService productService;

    @MockBean
    private ReviewService reviewService;

    @MockBean
    private VoucherService voucherService;

    @MockBean
    private FlashSaleService flashSaleService;

    @MockBean
    private WishlistService wishlistService;

    // Các MockBean cần thiết cho SecurityConfig
    @MockBean
    private CustomOAuth2UserService customOAuth2UserService;

    @MockBean
    private CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler;

    @MockBean
    private ProfileService profileService;

    @BeforeEach
    void setUp() {
        // Giả lập dữ liệu trả về từ các Service để trang Home không bị lỗi NullPointer
        when(productService.getFeaturedProducts()).thenReturn(Collections.emptyList());
        when(productService.getFlashSaleProducts()).thenReturn(Collections.emptyList());
        when(productService.getTopProducts(20)).thenReturn(Collections.emptyList());
        when(reviewService.getLatestReviews()).thenReturn(Collections.emptyList());
        
        FlashSale flashSale = new FlashSale();
        flashSale.setId(1);
        flashSale.setEndTime(new Date(System.currentTimeMillis() + 100000));
        when(flashSaleService.getCurrentFlashSale()).thenReturn(Optional.of(flashSale));
        when(flashSaleService.getItemsBySaleId(1)).thenReturn(Collections.emptyList());
        
        when(voucherService.getActiveVouchers()).thenReturn(Collections.emptyList());
    }

    @Test
    void testIndexPage_ReturnsIndexViewAndStatus200() throws Exception {
        mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(view().name("index"))
                .andExpect(model().attributeExists("featuredProducts", "flashSaleProducts", "allProducts", "reviews", "flashSale", "flashSaleItems", "flashSaleEndTime", "activeVouchers"));
    }

    @Test
    @WithMockUser
    void testIndexPage_WithLoggedInUser_ReturnsWishlist() throws Exception {
        when(wishlistService.getWishlistProductIds(any())).thenReturn(Collections.singleton(1));

        mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(view().name("index"))
                .andExpect(model().attributeExists("wishlistProductIds"));
    }

    @Test
    void testPromotionsPage_ReturnsPromotionsViewAndStatus200() throws Exception {
        mockMvc.perform(get("/promotions"))
                .andExpect(status().isOk())
                .andExpect(view().name("promotions"))
                .andExpect(model().attributeExists("flashSale", "flashSaleItems", "flashSaleEndTime", "activeVouchers"));
    }
}
