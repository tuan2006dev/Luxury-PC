package poly.edu.controller.api;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyDouble;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import java.util.HashMap;
import java.util.Map;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.core.Authentication;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import poly.edu.entity.CartItem;
import poly.edu.entity.User;
import poly.edu.service.ProfileService;
import poly.edu.service.VoucherService;

@ExtendWith(MockitoExtension.class)
public class VoucherApiControllerTest {

    private MockMvc mockMvc;

    @Mock private VoucherService voucherService;
    @Mock private ProfileService profileService;

    @InjectMocks
    private VoucherApiController voucherApiController;

    private MockHttpSession session;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(voucherApiController).build();
        session = new MockHttpSession();
    }

    // --- validateVoucher Tests ---

    @Test
    void testValidateVoucher_WithoutCart_UsesZeroTotal() throws Exception {
        Map<String, Object> validationResponse = new HashMap<>();
        validationResponse.put("valid", false);
        validationResponse.put("message", "Vui lòng đăng nhập để sử dụng mã!");

        when(voucherService.validateVoucher(eq("TEST10"), eq(0.0), anyDouble(), any(), isNull())).thenReturn(validationResponse);

        mockMvc.perform(post("/api/voucher/validate")
                .param("code", "TEST10")
                .session(session))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.valid").value(false))
                .andExpect(jsonPath("$.message").value("Vui lòng đăng nhập để sử dụng mã!"));
    }

    @Test
    void testValidateVoucher_WithCart_UsesCartTotal() throws Exception {
        Map<Integer, CartItem> cart = new HashMap<>();
        cart.put(1, new CartItem(1, "Product", 1000.0, 2)); // Total: 2000.0
        session.setAttribute("cart", cart);

        Map<String, Object> validationResponse = new HashMap<>();
        validationResponse.put("valid", true);
        validationResponse.put("discount", 200.0);

        Authentication auth = mock(Authentication.class);
        when(auth.isAuthenticated()).thenReturn(true);
        when(auth.getPrincipal()).thenReturn("testUser");
        
        User mockUser = new User();
        mockUser.setId(1);
        when(profileService.getCurrentUser(auth)).thenReturn(mockUser);

        when(voucherService.validateVoucher(eq("TEST10"), eq(2000.0), anyDouble(), any(), eq(mockUser))).thenReturn(validationResponse);

        mockMvc.perform(post("/api/voucher/validate")
                .param("code", "TEST10")
                .session(session)
                .principal(auth))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.valid").value(true))
                .andExpect(jsonPath("$.discount").value(200.0));
    }

    // --- deleteVoucherApi Tests ---

    @Test
    void testDeleteVoucherApi_DeleteMethod_Success() throws Exception {
        doNothing().when(voucherService).deleteVoucher(1);

        mockMvc.perform(delete("/api/voucher/delete/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.message").value("Đã xóa voucher thành công!"));
        
        verify(voucherService, times(1)).deleteVoucher(1);
    }

    @Test
    void testDeleteVoucherApi_PostMethod_Success() throws Exception {
        doNothing().when(voucherService).deleteVoucher(2);

        mockMvc.perform(post("/api/voucher/delete/2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.message").value("Đã xóa voucher thành công!"));
        
        verify(voucherService, times(1)).deleteVoucher(2);
    }
}
