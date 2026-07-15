package poly.edu.controller.web;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import poly.edu.config.SecurityConfig;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.CartItem;
import poly.edu.entity.Product;
import poly.edu.security.CustomAuthenticationSuccessHandler;
import poly.edu.security.CustomOAuth2UserService;
import poly.edu.service.CartService;
import poly.edu.service.FlashSaleService;
import poly.edu.service.VoucherService;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.when;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(CartController.class)
@Import(SecurityConfig.class)
public class CartControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ProductDAO productDAO;

    @MockBean
    private VoucherService voucherService;

    @MockBean
    private CartService cartService;

    @MockBean
    private FlashSaleService flashSaleService;

    @MockBean
    private CustomOAuth2UserService customOAuth2UserService;

    @MockBean
    private CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler;

    @MockBean
    private poly.edu.service.ProfileService profileService;

    private MockHttpSession session;

    @BeforeEach
    void setUp() {
        session = new MockHttpSession();
        Product p = new Product();
        p.setId(1);
        p.setName("Product 1");
        p.setPrice(100.0);
        p.setStock(10);
        when(productDAO.findById(1)).thenReturn(Optional.of(p));
        when(flashSaleService.getActiveFlashSaleItem(anyInt())).thenReturn(Optional.empty());
    }

    @Test
    void testAddToCart_Success() throws Exception {
        mockMvc.perform(post("/cart/add")
                .param("id", "1")
                .param("quantity", "2")
                .session(session)
                .with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/cart"));

        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        assert cart != null && cart.containsKey(1) && cart.get(1).getQuantity() == 2;
    }

    @Test
    void testViewCart_EmptyCart_ReturnsCartView() throws Exception {
        mockMvc.perform(get("/cart").session(session))
                .andExpect(status().isOk())
                .andExpect(view().name("cart"))
                .andExpect(model().attributeExists("cartItems", "totalPrice", "discountAmt", "finalPrice"));
    }

    @Test
    void testRemoveFromCart_Success() throws Exception {
        Map<Integer, CartItem> cart = new HashMap<>();
        cart.put(1, new CartItem(1, "Product 1", 100.0, 2));
        session.setAttribute("cart", cart);

        mockMvc.perform(post("/cart/remove")
                .param("id", "1")
                .session(session)
                .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(content().string("success"));

        Map<Integer, CartItem> updatedCart = (Map<Integer, CartItem>) session.getAttribute("cart");
        assert updatedCart != null && updatedCart.isEmpty();
    }
}
