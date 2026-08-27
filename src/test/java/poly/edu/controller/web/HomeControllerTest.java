package poly.edu.controller.web;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import poly.edu.service.NewsCategoryService;
import poly.edu.dao.CategoryDAO;
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
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(controllers = HomeController.class)
@org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc(addFilters = false)
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

    @MockBean
    private NewsService newsService;

    @MockBean
    private NewsCategoryService newsCategoryService;

    @MockBean
    private CategoryService categoryService;

    @MockBean
    private BrandService brandService;

    @MockBean
    private poly.edu.dao.ReviewDAO reviewDAO;

    // Các MockBean cần thiết cho SecurityConfig
    @MockBean
    private CustomOAuth2UserService customOAuth2UserService;

    @MockBean
    private CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler;

    @MockBean
    private ProfileService profileService;

    @MockBean
    private poly.edu.dao.UserVoucherDAO userVoucherDAO;

    @MockBean
    private poly.edu.service.AuthService authService;

    @MockBean
    private poly.edu.repository.AdminLogRepository adminLogRepository;

    @MockBean
    private poly.edu.security.UserStatusCheckFilter userStatusCheckFilter;

    @BeforeEach
    void setUp() {
        when(categoryService.getAllCategories()).thenReturn(Collections.emptyList());
        when(brandService.getAllBrands()).thenReturn(Collections.emptyList());
        when(newsService.getTop5LatestNews()).thenReturn(Collections.emptyList());
        when(newsService.getTop5MostViewedNews()).thenReturn(Collections.emptyList());
        when(productService.getFeaturedProducts()).thenReturn(Collections.emptyList());
        when(productService.getFlashSaleProducts()).thenReturn(Collections.emptyList());
        when(productService.getTopProducts(20)).thenReturn(Collections.emptyList());
        when(productService.getTopProducts(40)).thenReturn(Collections.emptyList());
        when(reviewService.getLatestReviews()).thenReturn(Collections.emptyList());
        
        FlashSale flashSale = new FlashSale();
        flashSale.setId(1);
        flashSale.setEndTime(new Date(System.currentTimeMillis() + 100000));
        when(flashSaleService.getCurrentFlashSale()).thenReturn(Optional.of(flashSale));
        
        poly.edu.entity.Product product = new poly.edu.entity.Product();
        product.setId(1);
        product.setName("Test Product");
        product.setPrice(1000.0);
        product.setImage("test.jpg");

        poly.edu.entity.FlashSaleItem item = new poly.edu.entity.FlashSaleItem();
        item.setId(1);
        item.setProduct(product);
        item.setSalePrice(800.0);
        item.setSoldCount(0);
        item.setSaleQuantity(10);
        when(flashSaleService.getItemsBySaleId(1)).thenReturn(List.of(item));
        when(flashSaleService.getCurrentActiveSales()).thenReturn(Collections.emptyList());
        when(flashSaleService.getUpcomingFlashSales()).thenReturn(Collections.emptyList());
        
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
