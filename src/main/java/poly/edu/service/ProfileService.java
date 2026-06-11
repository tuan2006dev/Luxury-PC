package poly.edu.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import poly.edu.dto.ProfileUpdateRequest;
import poly.edu.entity.ShippingAddress;
import poly.edu.entity.User;
import poly.edu.repository.ShippingAddressRepository;
import poly.edu.repository.UserRepository;

@Service
public class ProfileService {
    private final UserRepository userRepository;
    private final ShippingAddressRepository shippingAddressRepository;

    public ProfileService(UserRepository userRepository, ShippingAddressRepository shippingAddressRepository) {
        this.userRepository = userRepository;
        this.shippingAddressRepository = shippingAddressRepository;
    }

    public User getCurrentUser(Authentication authentication) {
        if (authentication == null) {
            throw new IllegalStateException("User is not authenticated");
        }

        String identifier = resolveIdentifier(authentication);
        if (identifier == null || identifier.isBlank()) {
            throw new IllegalStateException("Cannot resolve current user");
        }

        return userRepository.findByEmail(identifier)
                .or(() -> userRepository.findByUsername(identifier))
                .orElseThrow(() -> new IllegalStateException("Current user not found"));
    }

    public User getCurrentProfile(Authentication authentication) {
        return getCurrentUser(authentication);
    }

    @Transactional(readOnly = true)
    public List<ShippingAddress> getCurrentUserAddresses(Authentication authentication) {
        User user = getCurrentUser(authentication);
        return shippingAddressRepository.findByUser_IdOrderByDefaultShippingDescIdAsc(user.getId());
    }

    @Transactional(readOnly = true)
    public Map<String, Boolean> getCurrentUserNotificationSettings(Authentication authentication) {
        User user = getCurrentUser(authentication);
        Map<String, Boolean> m = new HashMap<>();
        m.put("orderUpdates", user.getNotifyOrderUpdates() == null || Boolean.TRUE.equals(user.getNotifyOrderUpdates()));
        m.put("flashSale", user.getNotifyFlashSale() == null || Boolean.TRUE.equals(user.getNotifyFlashSale()));
        m.put("newProducts", Boolean.TRUE.equals(user.getNotifyNewProducts()));
        m.put("weeklyNewsletter",
                user.getNotifyWeeklyNewsletter() == null || Boolean.TRUE.equals(user.getNotifyWeeklyNewsletter()));
        return m;
    }

    @Transactional
    public void addUserAddress(Authentication authentication, String recipientName, String phone,
            String addressLine, String district, String city) {
        User user = getCurrentUser(authentication);
        ShippingAddress a = new ShippingAddress();
        a.setUser(user);
        a.setRecipientName(requireNonBlank(recipientName, "recipientName"));
        a.setPhone(requireNonBlank(phone, "phone"));
        a.setAddress(requireNonBlank(addressLine, "address"));
        a.setDistrict(normalize(district));
        a.setCity(normalize(city));
        long n = shippingAddressRepository.countByUser_Id(user.getId());
        a.setDefault(n == 0);
        shippingAddressRepository.save(a);
    }

    @Transactional
    public void setDefaultAddress(Authentication authentication, Integer id) {
        User user = getCurrentUser(authentication);
        List<ShippingAddress> all = shippingAddressRepository.findByUser_IdOrderByDefaultShippingDescIdAsc(user.getId());
        boolean found = false;
        for (ShippingAddress a : all) {
            boolean isTarget = a.getId().equals(id);
            if (isTarget) {
                found = true;
            }
            a.setDefault(isTarget);
        }
        if (!found) {
            throw new IllegalArgumentException("Địa chỉ không tồn tại");
        }
        shippingAddressRepository.saveAll(all);
    }

    @Transactional
    public void deleteAddress(Authentication authentication, Integer id) {
        User user = getCurrentUser(authentication);
        ShippingAddress a = shippingAddressRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Địa chỉ không tồn tại"));
        if (!a.getUser().getId().equals(user.getId())) {
            throw new IllegalStateException("Không được phép xóa địa chỉ này");
        }
        boolean wasDefault = a.isDefault();
        shippingAddressRepository.delete(a);
        if (wasDefault) {
            List<ShippingAddress> rest = shippingAddressRepository.findByUser_IdOrderByDefaultShippingDescIdAsc(user.getId());
            if (!rest.isEmpty()) {
                ShippingAddress first = rest.get(0);
                first.setDefault(true);
                shippingAddressRepository.save(first);
            }
        }
    }

    @Transactional
    public void updateAddress(Authentication authentication, Integer id, String recipientName, String phone,
            String addressLine, String district, String city) {
        User user = getCurrentUser(authentication);
        ShippingAddress a = shippingAddressRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Địa chỉ không tồn tại"));
        if (!a.getUser().getId().equals(user.getId())) {
            throw new IllegalStateException("Không được phép sửa địa chỉ này");
        }
        a.setRecipientName(requireNonBlank(recipientName, "recipientName"));
        a.setPhone(requireNonBlank(phone, "phone"));
        a.setAddress(requireNonBlank(addressLine, "address"));
        a.setDistrict(normalize(district));
        a.setCity(normalize(city));
        shippingAddressRepository.save(a);
    }

    public boolean isEmailUsedByAnotherUser(Authentication authentication, String email) {
        if (email == null || email.isBlank()) {
            return false;
        }
        User currentUser = getCurrentUser(authentication);
        return userRepository.findByEmail(email)
                .filter(existing -> !existing.getId().equals(currentUser.getId()))
                .isPresent();
    }

    @Transactional
    public void updateCurrentProfile(Authentication authentication, ProfileUpdateRequest request) {
        User user = getCurrentUser(authentication);

        String first = normalize(request.getFirstName());
        String last = normalize(request.getLastName());
        if (first != null || last != null) {
            String fullName = ((first == null ? "" : first) + " " + (last == null ? "" : last)).trim();
            if (!fullName.isEmpty()) {
                user.setFullName(fullName);
            }
        }

        String email = normalize(request.getEmail());
        if (email != null) {
            user.setEmail(email);
            if (user.getUsername() == null || user.getUsername().isBlank()) {
                user.setUsername(email);
            }
        }

        String phone = normalize(request.getPhone());
        if (phone != null) {
            user.setPhone(phone);
        }

        userRepository.save(java.util.Objects.requireNonNull(user, "user must not be null"));
    }

    @Transactional
    public void updateNotificationSettings(Authentication authentication, boolean orderUpdates,
            boolean flashSale, boolean newProducts, boolean weeklyNewsletter) {
        User user = getCurrentUser(authentication);
        user.setNotifyOrderUpdates(orderUpdates);
        user.setNotifyFlashSale(flashSale);
        user.setNotifyNewProducts(newProducts);
        user.setNotifyWeeklyNewsletter(weeklyNewsletter);
        userRepository.save(user);
    }

    public void saveUser(User user) {
        userRepository.save(java.util.Objects.requireNonNull(user, "user must not be null"));
    }

    private String resolveIdentifier(Authentication authentication) {
        Object principal = authentication.getPrincipal();
        if (principal instanceof org.springframework.security.core.userdetails.User userDetails) {
            return userDetails.getUsername();
        }
        if (principal instanceof OAuth2User oauth2User) {
            Object email = oauth2User.getAttribute("email");
            if (email != null) {
                return email.toString();
            }
        }
        return authentication.getName();
    }

    private String normalize(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private static String requireNonBlank(String value, String field) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(field + " is required");
        }
        return value.trim();
    }
}
