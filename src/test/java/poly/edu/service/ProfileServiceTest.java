package poly.edu.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;

import poly.edu.dao.OrderDAO;
import poly.edu.dao.ReviewDAO;
import poly.edu.dao.UserRoleDAO;
import poly.edu.dao.UserSessionDAO;
import poly.edu.dao.UserVoucherDAO;
import poly.edu.dto.ProfileUpdateRequest;
import poly.edu.entity.ShippingAddress;
import poly.edu.entity.User;
import poly.edu.repository.ShippingAddressRepository;
import poly.edu.repository.UserRepository;
import poly.edu.repository.WishlistItemRepository;

@ExtendWith(MockitoExtension.class)
public class ProfileServiceTest {

    @Mock
    private UserRepository userRepository;
    @Mock
    private ShippingAddressRepository shippingAddressRepository;
    @Mock
    private UserRoleDAO userRoleDAO;
    @Mock
    private UserSessionDAO userSessionDAO;
    @Mock
    private UserVoucherDAO userVoucherDAO;
    @Mock
    private WishlistItemRepository wishlistItemRepository;
    @Mock
    private ReviewDAO reviewDAO;
    @Mock
    private OrderDAO orderDAO;
    @Mock
    private poly.edu.dao.CartDAO cartDAO;
    @Mock
    private poly.edu.dao.CartItemDAO cartItemDAO;
    @Mock
    private poly.edu.repository.PasswordResetRepository passwordResetRepo;

    @InjectMocks
    private ProfileService profileService;

    private Authentication authentication;
    private User mockUser;

    @BeforeEach
    void setUp() {
        authentication = mock(Authentication.class);
        mockUser = new User();
        mockUser.setId(1);
        mockUser.setEmail("test@luxurypc.com");
        mockUser.setUsername("testuser");
    }

    // --- getCurrentUser ---

    @Test
    void getCurrentUser_authenticationNull_throwException() {
        // When & Then
        assertThatThrownBy(() -> profileService.getCurrentUser(null))
                .isInstanceOf(IllegalStateException.class)
                .hasMessage("User is not authenticated");
    }

    @Test
    void getCurrentUser_identifierNull_throwException() {
        // Given
        when(authentication.getPrincipal()).thenReturn(new Object());
        when(authentication.getName()).thenReturn(null);

        // When & Then
        assertThatThrownBy(() -> profileService.getCurrentUser(authentication))
                .isInstanceOf(IllegalStateException.class)
                .hasMessage("Cannot resolve current user");
    }

    @Test
    void getCurrentUser_userNotFound_throwException() {
        // Given
        when(authentication.getPrincipal()).thenReturn(new Object());
        when(authentication.getName()).thenReturn("unknown@domain.com");
        when(userRepository.findByEmail("unknown@domain.com")).thenReturn(Optional.empty());
        when(userRepository.findByUsername("unknown@domain.com")).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> profileService.getCurrentUser(authentication))
                .isInstanceOf(IllegalStateException.class)
                .hasMessage("Current user not found");
    }

    @Test
    void getCurrentUser_validEmail_returnUser() {
        // Given
        when(authentication.getPrincipal()).thenReturn(new Object());
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));

        // When
        User result = profileService.getCurrentUser(authentication);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1);
    }

    @Test
    void getCurrentUser_validUsername_returnUser() {
        // Given
        org.springframework.security.core.userdetails.User userDetails = new org.springframework.security.core.userdetails.User("testuser", "password", java.util.Collections.emptyList());
        when(authentication.getPrincipal()).thenReturn(userDetails);
        when(userRepository.findByEmail("testuser")).thenReturn(Optional.empty());
        when(userRepository.findByUsername("testuser")).thenReturn(Optional.of(mockUser));

        // When
        User result = profileService.getCurrentUser(authentication);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getUsername()).isEqualTo("testuser");
    }

    @Test
    void getCurrentUser_oauth2User_returnUser() {
        // Given
        OAuth2User oAuth2User = mock(OAuth2User.class);
        when(authentication.getPrincipal()).thenReturn(oAuth2User);
        when(oAuth2User.getAttribute("email")).thenReturn("oauth@domain.com");
        when(userRepository.findByEmail("oauth@domain.com")).thenReturn(Optional.of(mockUser));

        // When
        User result = profileService.getCurrentUser(authentication);

        // Then
        assertThat(result).isNotNull();
    }

    // --- getCurrentProfile ---

    @Test
    void getCurrentProfile_validAuth_returnUser() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));

        // When
        User result = profileService.getCurrentProfile(authentication);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1);
    }

    // --- getCurrentUserAddresses ---

    @Test
    void getCurrentUserAddresses_validAuth_returnAddressList() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));
        
        ShippingAddress addr = new ShippingAddress();
        addr.setId(10);
        when(shippingAddressRepository.findByUser_IdOrderByDefaultShippingDescIdAsc(1))
                .thenReturn(Collections.singletonList(addr));

        // When
        List<ShippingAddress> result = profileService.getCurrentUserAddresses(authentication);

        // Then
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(10);
    }

    // --- getCurrentUserNotificationSettings ---

    @Test
    void getCurrentUserNotificationSettings_defaultUser_returnTrueSettings() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));
        mockUser.setNotifyNewProducts(true); // newProducts defaults to false in map unless set to true

        // When
        Map<String, Boolean> settings = profileService.getCurrentUserNotificationSettings(authentication);

        // Then
        assertThat(settings.get("orderUpdates")).isTrue();
        assertThat(settings.get("flashSale")).isTrue();
        assertThat(settings.get("newProducts")).isTrue();
        assertThat(settings.get("weeklyNewsletter")).isTrue();
    }

    // --- addUserAddress ---

    @Test
    void addUserAddress_validInputFirstAddress_saveDefaultTrue() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));
        when(shippingAddressRepository.findByUser_IdOrderByDefaultShippingDescIdAsc(1)).thenReturn(Collections.emptyList());

        // When
        profileService.addUserAddress(authentication, "John", "0123456789", "123 Street", "District 1", "City");

        // Then
        ArgumentCaptor<ShippingAddress> captor = ArgumentCaptor.forClass(ShippingAddress.class);
        verify(shippingAddressRepository).save(captor.capture());
        
        ShippingAddress saved = captor.getValue();
        assertThat(saved.getRecipientName()).isEqualTo("John");
        assertThat(saved.isDefault()).isTrue();
    }

    @Test
    void addUserAddress_validInputNotFirst_saveDefaultFalse() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));
        when(shippingAddressRepository.countByUser_Id(1)).thenReturn(5L);

        // When
        profileService.addUserAddress(authentication, "John", "0123456789", "123 Street", "District 1", "City");

        // Then
        ArgumentCaptor<ShippingAddress> captor = ArgumentCaptor.forClass(ShippingAddress.class);
        verify(shippingAddressRepository).save(captor.capture());
        assertThat(captor.getValue().isDefault()).isFalse();
    }

    @Test
    void addUserAddress_blankRecipientName_throwException() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));

        // When & Then
        assertThatThrownBy(() -> profileService.addUserAddress(authentication, "", "0123", "Street", "D1", "C1"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("recipientName is required");
    }

    // --- setDefaultAddress ---

    @Test
    void setDefaultAddress_addressExists_updateDefault() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));
        
        ShippingAddress addr1 = new ShippingAddress(); addr1.setId(10); addr1.setDefault(false);
        ShippingAddress addr2 = new ShippingAddress(); addr2.setId(20); addr2.setDefault(true);
        when(shippingAddressRepository.findByUser_IdOrderByDefaultShippingDescIdAsc(1))
                .thenReturn(Arrays.asList(addr1, addr2));

        // When
        profileService.setDefaultAddress(authentication, 10);

        // Then
        ArgumentCaptor<List<ShippingAddress>> captor = ArgumentCaptor.forClass((Class)List.class);
        verify(shippingAddressRepository).saveAll(captor.capture());
        
        List<ShippingAddress> savedList = captor.getValue();
        assertThat(savedList.get(0).isDefault()).isTrue();
        assertThat(savedList.get(1).isDefault()).isFalse();
    }

    @Test
    void setDefaultAddress_addressNotFound_throwException() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));
        when(shippingAddressRepository.findByUser_IdOrderByDefaultShippingDescIdAsc(1)).thenReturn(Collections.emptyList());

        // When & Then
        assertThatThrownBy(() -> profileService.setDefaultAddress(authentication, 99))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("Địa chỉ không tồn tại");
    }

    // --- deleteAddress ---

    @Test
    void deleteAddress_notOwner_throwException() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));
        
        ShippingAddress addr = new ShippingAddress();
        User otherUser = new User();
        otherUser.setId(2);
        addr.setUser(otherUser);
        
        when(shippingAddressRepository.findById(10)).thenReturn(Optional.of(addr));

        // When & Then
        assertThatThrownBy(() -> profileService.deleteAddress(authentication, 10))
                .isInstanceOf(IllegalStateException.class)
                .hasMessage("Không được phép xóa địa chỉ này");
    }

    @Test
    void deleteAddress_wasDefault_setAnotherDefault() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));
        
        ShippingAddress addr1 = new ShippingAddress();
        addr1.setId(10);
        addr1.setUser(mockUser);
        addr1.setDefault(true);
        
        ShippingAddress addr2 = new ShippingAddress();
        addr2.setId(20);
        
        when(shippingAddressRepository.findById(10)).thenReturn(Optional.of(addr1));
        when(shippingAddressRepository.findByUser_IdOrderByDefaultShippingDescIdAsc(1))
                .thenReturn(Collections.singletonList(addr2));

        // When
        profileService.deleteAddress(authentication, 10);

        // Then
        verify(shippingAddressRepository).delete(addr1);
        verify(shippingAddressRepository).save(addr2);
        assertThat(addr2.isDefault()).isTrue();
    }

    @Test
    void deleteAddress_notDefault_justDelete() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));
        
        ShippingAddress addr1 = new ShippingAddress();
        addr1.setId(10);
        addr1.setUser(mockUser);
        addr1.setDefault(false);
        
        when(shippingAddressRepository.findById(10)).thenReturn(Optional.of(addr1));

        // When
        profileService.deleteAddress(authentication, 10);

        // Then
        verify(shippingAddressRepository).delete(addr1);
        verify(shippingAddressRepository, never()).save(any());
    }

    // --- updateAddress ---

    @Test
    void updateAddress_validInput_saveAddress() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));
        
        ShippingAddress addr = new ShippingAddress();
        addr.setId(10);
        addr.setUser(mockUser);
        
        when(shippingAddressRepository.findById(10)).thenReturn(Optional.of(addr));

        // When
        profileService.updateAddress(authentication, 10, "Anna", "099", "New Street", "D2", "C2");

        // Then
        verify(shippingAddressRepository).save(addr);
        assertThat(addr.getRecipientName()).isEqualTo("Anna");
        assertThat(addr.getDistrict()).isEqualTo("D2");
    }

    // --- isEmailUsedByAnotherUser ---

    @Test
    void isEmailUsedByAnotherUser_blankEmail_returnFalse() {
        // When
        boolean result = profileService.isEmailUsedByAnotherUser(authentication, "  ");
        // Then
        assertThat(result).isFalse();
    }

    @Test
    void isEmailUsedByAnotherUser_emailUsedBySelf_returnFalse() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));

        // When
        boolean result = profileService.isEmailUsedByAnotherUser(authentication, "test@luxurypc.com");

        // Then
        assertThat(result).isFalse();
    }

    @Test
    void isEmailUsedByAnotherUser_emailUsedByOther_returnTrue() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));
        
        User otherUser = new User();
        otherUser.setId(2);
        when(userRepository.findByEmail("other@luxurypc.com")).thenReturn(Optional.of(otherUser));

        // When
        boolean result = profileService.isEmailUsedByAnotherUser(authentication, "other@luxurypc.com");

        // Then
        assertThat(result).isTrue();
    }

    // --- updateCurrentProfile ---

    @Test
    void updateCurrentProfile_validData_saveUser() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));
        
        ProfileUpdateRequest request = new ProfileUpdateRequest();
        request.setFirstName("John");
        request.setLastName("Doe");
        request.setEmail("john.doe@luxurypc.com");
        request.setPhone("0123");
        request.setGender("true");

        // When
        profileService.updateCurrentProfile(authentication, request);

        // Then
        verify(userRepository).save(mockUser);
        assertThat(mockUser.getFullName()).isEqualTo("John Doe");
        assertThat(mockUser.getEmail()).isEqualTo("john.doe@luxurypc.com");
        assertThat(mockUser.getPhone()).isEqualTo("0123");
        assertThat(mockUser.getGender()).isTrue();
    }

    @Test
    void updateCurrentProfile_birthdayInFuture_throwException() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));
        
        ProfileUpdateRequest request = new ProfileUpdateRequest();
        request.setBirthday(LocalDate.now().plusDays(1));

        // When & Then
        assertThatThrownBy(() -> profileService.updateCurrentProfile(authentication, request))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("Ngày sinh không được lớn hơn ngày hiện tại");
    }

    // --- updateNotificationSettings ---

    @Test
    void updateNotificationSettings_validData_saveUser() {
        // Given
        when(authentication.getName()).thenReturn("test@luxurypc.com");
        when(userRepository.findByEmail("test@luxurypc.com")).thenReturn(Optional.of(mockUser));

        // When
        profileService.updateNotificationSettings(authentication, false, true, false, true);

        // Then
        verify(userRepository).save(mockUser);
        assertThat(mockUser.getNotifyOrderUpdates()).isFalse();
        assertThat(mockUser.getNotifyFlashSale()).isTrue();
        assertThat(mockUser.getNotifyNewProducts()).isFalse();
        assertThat(mockUser.getNotifyWeeklyNewsletter()).isTrue();
    }

    // --- saveUser ---

    @Test
    void saveUser_validUser_saveToRepo() {
        // Given
        User u = new User();

        // When
        profileService.saveUser(u);

        // Then
        verify(userRepository).save(u);
    }

    @Test
    void saveUser_nullUser_throwException() {
        // When & Then
        assertThatThrownBy(() -> profileService.saveUser(null))
                .isInstanceOf(NullPointerException.class)
                .hasMessage("user must not be null");
    }

    // --- deleteUserFully ---

    @Test
    void deleteUserFully_validUser_invokeAllDaos() {
        // Given
        mockUser.setId(5);

        // When
        profileService.deleteUserFully(mockUser);

        // Then
        verify(userRoleDAO, times(1)).deleteByUserId(5);
        verify(userSessionDAO, times(1)).deleteByUserId(5);
        verify(userVoucherDAO, times(1)).deleteByUserId(5);
        verify(wishlistItemRepository, times(1)).deleteByUserId(5);
        verify(shippingAddressRepository, times(1)).deleteByUserId(5);
        
        verify(reviewDAO, times(1)).nullifyUserReferences(5);
        verify(orderDAO, times(1)).nullifyUserReferences(5);
        
        verify(userRepository, times(1)).delete(mockUser);
    }
}
