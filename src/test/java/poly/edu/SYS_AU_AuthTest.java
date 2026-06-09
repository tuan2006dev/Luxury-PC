package poly.edu;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import poly.edu.entity.User;
import poly.edu.repository.UserRepository;
import poly.edu.service.EmailService;

import java.util.ArrayList;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
public class SYS_AU_AuthTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @MockBean
    private EmailService emailService;

    private String testEmail = "phamcongthanh.8311@gmail.com";
    private String testPassword = "123456";

    @BeforeEach
    public void setup() {
        // We rely on @Transactional for cleanup, but we can clear specific test users if they exist
        userRepository.findByEmail(testEmail).ifPresent(user -> {
             // If we need to delete a user with roles, we should handle dependent records, 
             // but here we just avoid deleting if it might cause issues, 
             // OR we just use a fresh state if possible.
        });
    }

    // ==========================================
    // ĐĂNG KÝ (KH_DK_XX)
    // ==========================================

    @Test
    public void test_KH_DK_01_RegisterSuccess() throws Exception {
        doReturn(true).when(emailService).verifyOtp(anyString(), anyString());

        mockMvc.perform(post("/api/register")
                .param("firstName", "Thanh")
                .param("lastName", "Pham")
                .param("email", "phamcongthanh@gmail.com")
                .param("otp", "123456")
                .param("password", "123456")
                .param("confirmPassword", "123456"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"));

        assertTrue(userRepository.findByEmail("phamcongthanh@gmail.com").isPresent());
    }

    @Test
    public void test_KH_DK_02_EmailAlreadyExists() throws Exception {
        User user = new User();
        user.setEmail(testEmail);
        user.setUsername(testEmail);
        user.setPassword(passwordEncoder.encode(testPassword));
        userRepository.saveAndFlush(user);

        mockMvc.perform(post("/api/register")
                .param("firstName", "Thanh")
                .param("lastName", "Pham")
                .param("email", testEmail)
                .param("otp", "123456")
                .param("password", "123456")
                .param("confirmPassword", "123456"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login?exist=true"));
    }

    @Test
    public void test_KH_DK_03_MissingInformation() throws Exception {
        // Omitting required 'email' parameter
        mockMvc.perform(post("/api/register")
                .param("firstName", "Thanh")
                .param("lastName", "Pham")
                .param("otp", "123456")
                .param("password", "123456"))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void test_KH_DK_04_InvalidEmailFormat() throws Exception {
        mockMvc.perform(post("/api/register")
                .param("firstName", "Thanh")
                .param("lastName", "Pham")
                .param("email", "@abc.com")
                .param("otp", "123456")
                .param("password", "123456")
                .param("confirmPassword", "123456"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login?invalidEmail=true"));
    }

    @Test
    public void test_KH_DK_05_PasswordMismatch() throws Exception {
        mockMvc.perform(post("/api/register")
                .param("firstName", "Thanh")
                .param("lastName", "Pham")
                .param("email", "newuser@gmail.com")
                .param("otp", "123456")
                .param("password", "123456")
                .param("confirmPassword", "654321"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login?mismatch=true"));
    }

    // ==========================================
    // ĐĂNG NHẬP (KH_DN_XX)
    // ==========================================

    @Test
    public void test_KH_DN_01_LoginValid() throws Exception {
        User user = new User();
        user.setEmail(testEmail);
        user.setUsername(testEmail);
        user.setPassword(passwordEncoder.encode(testPassword));
        user.setUserRoles(new ArrayList<>());
        userRepository.saveAndFlush(user);

        mockMvc.perform(post("/login")
                .param("username", testEmail)
                .param("password", testPassword))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"));
    }

    @Test
    public void test_KH_DN_02_WrongPassword() throws Exception {
        User user = new User();
        user.setEmail(testEmail);
        user.setUsername(testEmail);
        user.setPassword(passwordEncoder.encode(testPassword));
        user.setUserRoles(new ArrayList<>());
        userRepository.saveAndFlush(user);

        mockMvc.perform(post("/login")
                .param("username", testEmail)
                .param("password", "000000"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login?error=true"));
    }

    @Test
    public void test_KH_DN_03_AccountDoesNotExist() throws Exception {
        mockMvc.perform(post("/login")
                .param("username", "abc@gmail.com")
                .param("password", "123456"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login?error=true"));
    }

    @Test
    public void test_KH_DN_04_LoginMissingInformation() throws Exception {
        // Missing password
        mockMvc.perform(post("/login")
                .param("username", testEmail))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login?error=true"));
    }

    @Test
    public void test_KH_DN_05_LoginInvalidEmailFormat() throws Exception {
        mockMvc.perform(post("/login")
                .param("username", "abc@")
                .param("password", "123456"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login?error=true"));
    }
}
