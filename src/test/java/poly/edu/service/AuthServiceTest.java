package poly.edu.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.util.Collections;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import poly.edu.dao.UserDAO;
import poly.edu.entity.Role;
import poly.edu.entity.User;
import poly.edu.entity.UserRole;

@ExtendWith(MockitoExtension.class)
public class AuthServiceTest {

    @Mock
    private UserDAO userDAO;

    @InjectMocks
    private AuthService authService;

    private User mockUser;

    @BeforeEach
    void setUp() {
        mockUser = new User();
        mockUser.setEmail("test@gmail.com");
        mockUser.setUsername("testuser");
        mockUser.setPassword("password123");
    }

    // --- login Tests ---

    @Test
    void testLogin_ValidCredentials_ReturnsUser() {
        when(userDAO.findByEmailAndPassword("test@gmail.com", "password123")).thenReturn(mockUser);

        User result = authService.login("test@gmail.com", "password123");

        assertNotNull(result);
        assertEquals("test@gmail.com", result.getEmail());
    }

    @Test
    void testLogin_InvalidCredentials_ReturnsNull() {
        when(userDAO.findByEmailAndPassword("wrong@gmail.com", "wrongpass")).thenReturn(null);

        User result = authService.login("wrong@gmail.com", "wrongpass");

        assertNull(result);
    }

    // --- register Tests ---

    @Test
    void testRegister_Success() {
        when(userDAO.save(mockUser)).thenReturn(mockUser);

        User result = authService.register(mockUser);

        assertNotNull(result);
        verify(userDAO, times(1)).save(mockUser);
    }

    // --- loadUserByUsername Tests ---

    @Test
    void testLoadUserByUsername_EmailFound_ReturnsUserDetails() {
        Role role = new Role();
        role.setName("ADMIN");
        UserRole userRole = new UserRole();
        userRole.setRole(role);
        mockUser.setUserRoles(List.of(userRole));

        when(userDAO.findByEmailWithRoles("test@gmail.com")).thenReturn(mockUser);

        UserDetails userDetails = authService.loadUserByUsername("test@gmail.com");

        assertNotNull(userDetails);
        assertEquals("test@gmail.com", userDetails.getUsername());
        assertEquals("password123", userDetails.getPassword());
        assertTrue(userDetails.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN")));
    }

    @Test
    void testLoadUserByUsername_UsernameFound_ReturnsUserDetails() {
        when(userDAO.findByEmailWithRoles("testuser")).thenReturn(null);
        when(userDAO.findByUsernameWithRoles("testuser")).thenReturn(mockUser);
        
        // Mocking an empty role list to test the "USER" fallback
        mockUser.setUserRoles(Collections.emptyList());

        UserDetails userDetails = authService.loadUserByUsername("testuser");

        assertNotNull(userDetails);
        assertEquals("test@gmail.com", userDetails.getUsername());
        assertTrue(userDetails.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_USER")), "Should fallback to ROLE_USER when no roles exist");
    }

    @Test
    void testLoadUserByUsername_NotFound_ThrowsUsernameNotFoundException() {
        when(userDAO.findByEmailWithRoles("nobody")).thenReturn(null);
        when(userDAO.findByUsernameWithRoles("nobody")).thenReturn(null);

        UsernameNotFoundException exception = assertThrows(UsernameNotFoundException.class, () -> {
            authService.loadUserByUsername("nobody");
        });

        assertEquals("User not found: nobody", exception.getMessage());
    }
}
