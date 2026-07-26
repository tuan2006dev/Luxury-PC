package poly.edu.controller.auth;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import com.fasterxml.jackson.databind.ObjectMapper;

import poly.edu.dao.RoleDAO;
import poly.edu.dao.UserRoleDAO;
import poly.edu.entity.Role;
import poly.edu.entity.User;
import poly.edu.repository.UserRepository;
import poly.edu.service.AuthService;
import poly.edu.service.EmailService;

@ExtendWith(MockitoExtension.class)
public class AuthControllerTest {

    private MockMvc mockMvc;

    @Mock private AuthService authService;
    @Mock private UserRepository userRepo;
    @Mock private PasswordEncoder encoder;
    @Mock private SecurityContextRepository securityContextRepository;
    @Mock private RoleDAO roleDAO;
    @Mock private UserRoleDAO userRoleDAO;
    @Mock private EmailService emailService;

    @InjectMocks
    private AuthController authController;

    private ObjectMapper objectMapper = new ObjectMapper();

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(authController).build();
    }

    // --- loginApi Tests ---

    @Test
    void testLoginApi_Success() throws Exception {
        User user = new User();
        user.setEmail("test@gmail.com");
        user.setPassword("password");
        
        User dbUser = new User();
        dbUser.setId(1);
        dbUser.setEmail("test@gmail.com");

        when(authService.login("test@gmail.com", "password")).thenReturn(dbUser);

        mockMvc.perform(post("/api/login-api")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(user)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.email").value("test@gmail.com"));
    }

    // --- sendOtp Tests ---

    @Test
    void testSendOtp_EmailExists_ReturnsErrorExist() throws Exception {
        when(userRepo.findByEmail("test@gmail.com")).thenReturn(Optional.of(new User()));

        mockMvc.perform(post("/api/send-otp")
                .param("email", "test@gmail.com"))
                .andExpect(status().isOk())
                .andExpect(content().string("error_exist"));
    }

    @Test
    void testSendOtp_Success() throws Exception {
        when(userRepo.findByEmail("test@gmail.com")).thenReturn(Optional.empty());

        mockMvc.perform(post("/api/send-otp")
                .param("email", "test@gmail.com"))
                .andExpect(status().isOk())
                .andExpect(content().string("success"));
        
        verify(emailService, times(1)).sendOtpEmail("test@gmail.com", "test@gmail.com");
    }

    // --- register Tests ---

    @Test
    void testRegister_InvalidEmail_Redirects() throws Exception {
        mockMvc.perform(post("/api/register")
                .param("firstName", "John")
                .param("lastName", "Doe")
                .param("email", "invalid-email") // Missing @
                .param("otp", "123456")
                .param("password", "pass123")
                .param("confirmPassword", "pass123"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/register?invalidEmail=true"));
    }

    @Test
    void testRegister_PasswordMismatch_Redirects() throws Exception {
        mockMvc.perform(post("/api/register")
                .param("firstName", "John")
                .param("lastName", "Doe")
                .param("email", "test@gmail.com")
                .param("otp", "123456")
                .param("password", "pass123")
                .param("confirmPassword", "wrongpass"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/register?mismatch=true"));
    }

    @Test
    void testRegister_InvalidOtp_Redirects() throws Exception {
        when(userRepo.findByEmail("test@gmail.com")).thenReturn(Optional.empty());
        when(emailService.verifyOtp("test@gmail.com", "000000")).thenReturn(false);

        mockMvc.perform(post("/api/register")
                .param("firstName", "John")
                .param("lastName", "Doe")
                .param("email", "test@gmail.com")
                .param("otp", "000000")
                .param("password", "pass123")
                .param("confirmPassword", "pass123"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/register?invalidOtp=true"));
    }

    @Test
    void testRegister_Success_RedirectsToHomeAndLogsIn() throws Exception {
        when(userRepo.findByEmail("test@gmail.com")).thenReturn(Optional.empty());
        when(emailService.verifyOtp("test@gmail.com", "123456")).thenReturn(true);
        when(encoder.encode("pass123")).thenReturn("hashedPass");
        
        User savedUser = new User();
        savedUser.setId(1);
        savedUser.setEmail("test@gmail.com");
        savedUser.setPassword("hashedPass");
        when(userRepo.save(any(User.class))).thenReturn(savedUser);

        Role role = new Role();
        role.setName("USER");
        when(roleDAO.findByName("USER")).thenReturn(role);

        mockMvc.perform(post("/api/register")
                .param("firstName", "John")
                .param("lastName", "Doe")
                .param("email", "test@gmail.com")
                .param("otp", "123456")
                .param("password", "pass123")
                .param("confirmPassword", "pass123"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/")); // Success redirect to home
                
        verify(userRoleDAO, times(1)).save(any());
        verify(securityContextRepository, times(1)).saveContext(any(), any(), any());
    }

    // --- forgot password Tests ---

    @Test
    void testForgotPasswordReset_InvalidOtp_ReturnsErrorOtp() throws Exception {
        when(emailService.verifyForgotPasswordOtp("test@gmail.com", "000000")).thenReturn(false);

        mockMvc.perform(post("/api/forgot-password/reset")
                .param("email", "test@gmail.com")
                .param("otp", "000000")
                .param("newPassword", "newpass"))
                .andExpect(status().isOk())
                .andExpect(content().string("error_otp"));
    }
}
