package poly.edu.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDate;

import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import poly.edu.dto.ProfileUpdateRequest;
import poly.edu.entity.ShippingAddress;
import poly.edu.entity.User;
import poly.edu.repository.ShippingAddressRepository;
import poly.edu.repository.UserRepository;
import poly.edu.repository.WishlistItemRepository;
import poly.edu.dao.UserRoleDAO;
import poly.edu.dao.UserSessionDAO;
import poly.edu.dao.UserVoucherDAO;
import poly.edu.dao.ReviewDAO;
import poly.edu.dao.OrderDAO;

@Service
public class ProfileService {
    private final UserRepository userRepository;
    private final ShippingAddressRepository shippingAddressRepository;
    private final UserRoleDAO userRoleDAO;
    private final UserSessionDAO userSessionDAO;
    private final UserVoucherDAO userVoucherDAO;
    private final WishlistItemRepository wishlistItemRepository;
    private final ReviewDAO reviewDAO;
    private final OrderDAO orderDAO;

    public ProfileService(UserRepository userRepository,
            ShippingAddressRepository shippingAddressRepository,
            UserRoleDAO userRoleDAO,
            UserSessionDAO userSessionDAO,
            UserVoucherDAO userVoucherDAO,
            WishlistItemRepository wishlistItemRepository,
            ReviewDAO reviewDAO,
            OrderDAO orderDAO) {
        this.userRepository = userRepository;
        this.shippingAddressRepository = shippingAddressRepository;
        this.userRoleDAO = userRoleDAO;
        this.userSessionDAO = userSessionDAO;
        this.userVoucherDAO = userVoucherDAO;
        this.wishlistItemRepository = wishlistItemRepository;
        this.reviewDAO = reviewDAO;
        this.orderDAO = orderDAO;
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
        m.put("orderUpdates",
                user.getNotifyOrderUpdates() == null || Boolean.TRUE.equals(user.getNotifyOrderUpdates()));
        m.put("flashSale", user.getNotifyFlashSale() == null || Boolean.TRUE.equals(user.getNotifyFlashSale()));
        m.put("newProducts",
                user.getNotifyNewProducts() == null || Boolean.TRUE.equals(user.getNotifyNewProducts()));
        m.put("weeklyNewsletter",
                user.getNotifyWeeklyNewsletter() == null || Boolean.TRUE.equals(user.getNotifyWeeklyNewsletter()));
        return m;
    }

    @Transactional
    public void addUserAddress(Authentication authentication, String recipientName, String phone,
            String addressLine, String district, String city) {
        User user = getCurrentUser(authentication);
        List<ShippingAddress> existingList = shippingAddressRepository.findByUser_IdOrderByDefaultShippingDescIdAsc(user.getId());

        String phoneInput = phone != null ? phone.trim() : "";
        String detailInput = addressLine != null ? addressLine.trim() : "";
        String cityInput = city != null ? city.trim() : "";
        String districtInput = district != null ? district.trim() : "";

        for (ShippingAddress a : existingList) {
            boolean samePhone = a.getPhone() != null && a.getPhone().trim().equalsIgnoreCase(phoneInput);
            boolean sameDetail = a.getAddress() != null && a.getAddress().trim().equalsIgnoreCase(detailInput);
            boolean sameCity = a.getCity() != null && a.getCity().trim().equalsIgnoreCase(cityInput);
            String existingDistrict = a.getDistrict() != null ? a.getDistrict().trim() : "";
            boolean sameDistrict = existingDistrict.equalsIgnoreCase(districtInput);

            if (samePhone && sameDetail && sameCity && sameDistrict) {
                a.setRecipientName(requireNonBlank(recipientName, "recipientName"));
                a.setPhone(requireNonBlank(phone, "phone"));
                a.setAddress(requireNonBlank(addressLine, "address"));
                a.setDistrict(normalize(district));
                a.setCity(normalize(city));
                shippingAddressRepository.save(a);
                return;
            }
        }

        ShippingAddress a = new ShippingAddress();
        a.setUser(user);
        a.setRecipientName(requireNonBlank(recipientName, "recipientName"));
        a.setPhone(requireNonBlank(phone, "phone"));
        a.setAddress(requireNonBlank(addressLine, "address"));
        a.setDistrict(normalize(district));
        a.setCity(normalize(city));
        a.setDefault(existingList.isEmpty());
        shippingAddressRepository.save(a);
    }

    @Transactional
    public void setDefaultAddress(Authentication authentication, Integer id) {
        User user = getCurrentUser(authentication);
        List<ShippingAddress> all = shippingAddressRepository
                .findByUser_IdOrderByDefaultShippingDescIdAsc(user.getId());
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
            List<ShippingAddress> rest = shippingAddressRepository
                    .findByUser_IdOrderByDefaultShippingDescIdAsc(user.getId());
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

        LocalDate birthday = request.getBirthday();
        if (birthday != null) {
            if (birthday.isAfter(LocalDate.now())) {
                throw new IllegalArgumentException("Ngày sinh không được lớn hơn ngày hiện tại");
            }
            user.setBirthday(java.sql.Date.valueOf(birthday));
        }

        String gender = normalize(request.getGender());
        if (gender != null) {
            user.setGender(Boolean.parseBoolean(gender));
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

    @Transactional
    public void deleteUserFully(User user) {
        Integer userId = user.getId();

        // 1. Delete dependent records
        userRoleDAO.deleteByUserId(userId);
        userSessionDAO.deleteByUserId(userId);
        userVoucherDAO.deleteByUserId(userId);
        wishlistItemRepository.deleteByUserId(userId);
        shippingAddressRepository.deleteByUserId(userId);

        // 2. Nullify references (keep reviews and orders)
        reviewDAO.nullifyUserReferences(userId);
        orderDAO.nullifyUserReferences(userId);

        // 3. Delete the user
        userRepository.delete(user);
    }

    @Transactional(readOnly = true)
    public Map<String, Object> getFullProfileData(Authentication authentication) {
        Map<String, Object> data = new HashMap<>();
        User user = getCurrentUser(authentication);
        
        Double totalSpent = orderDAO.getTotalSpentByUser(user.getId());
        totalSpent = (totalSpent == null) ? 0.0 : totalSpent;
        
        String userRank = getRank(totalSpent);
        int discountPercent = getDiscountPercent(totalSpent);
        String nextRank = getNextRank(totalSpent);
        int nextRankDiscount = getDiscountPercent(getNextRankThreshold(totalSpent));
        double nextThreshold = getNextRankThreshold(totalSpent);
        double neededSpent = Math.max(0.0, nextThreshold - totalSpent);
        double rankProgress = getRankProgress(totalSpent);
        
        data.put("user", user);
        data.put("totalSpent", totalSpent);
        Long completedOrders = orderDAO.countCompletedOrdersByUser(user.getId());
        data.put("totalOrders", completedOrders != null ? completedOrders : 0);
        data.put("userRank", userRank);
        data.put("rankClass", getRankClass(totalSpent));
        data.put("discountPercent", discountPercent);
        data.put("nextRank", nextRank);
        data.put("nextRankDiscount", nextRankDiscount);
        data.put("nextThreshold", nextThreshold);
        data.put("neededSpent", neededSpent);
        data.put("rankProgress", Math.min(100.0, Math.max(0.0, rankProgress)));
        
        data.put("orders", orderDAO.findByUser_IdOrderByCreatedAtDesc(user.getId()));
        data.put("wishlistItems", wishlistItemRepository.findByUser_IdOrderByCreatedAtDesc(user.getId()));
        data.put("addresses", getCurrentUserAddresses(authentication));
        data.put("notificationSettings", getCurrentUserNotificationSettings(authentication));
        java.util.List<poly.edu.entity.UserVoucher> allVouchers = userVoucherDAO.findByUserOrderBySavedAtDesc(user);
        java.util.List<poly.edu.entity.UserVoucher> validVouchers = allVouchers.stream()
            .filter(uv -> uv.getVoucher() != null && uv.getVoucher().isValid() && !"CONSUMED".equalsIgnoreCase(uv.getStatus()))
            .collect(java.util.stream.Collectors.toList());
        data.put("vouchers", validVouchers);
        
        return data;
    }

    public int getDiscountPercent(Double totalSpent) {
        if (totalSpent == null) return 0;
        if (totalSpent >= 200_000_000) return 10;
        if (totalSpent >= 100_000_000) return 8;
        if (totalSpent >= 50_000_000) return 5;
        if (totalSpent >= 10_000_000) return 2;
        return 0;
    }

    private String getNextRank(Double totalSpent) {
        if (totalSpent == null || totalSpent < 10_000_000) return "Silver";
        if (totalSpent < 50_000_000) return "Gold";
        if (totalSpent < 100_000_000) return "Platinum";
        if (totalSpent < 200_000_000) return "Diamond";
        return "MAX";
    }

    private double getNextRankThreshold(Double totalSpent) {
        if (totalSpent == null || totalSpent < 10_000_000) return 10_000_000.0;
        if (totalSpent < 50_000_000) return 50_000_000.0;
        if (totalSpent < 100_000_000) return 100_000_000.0;
        if (totalSpent < 200_000_000) return 200_000_000.0;
        return 200_000_000.0;
    }

    private double getRankProgress(Double totalSpent) {
        if (totalSpent == null || totalSpent <= 0) return 0.0;
        if (totalSpent >= 200_000_000) return 100.0;
        
        double currentMin = 0.0;
        double nextMax = 10_000_000.0;
        
        if (totalSpent >= 100_000_000) {
            currentMin = 100_000_000.0;
            nextMax = 200_000_000.0;
        } else if (totalSpent >= 50_000_000) {
            currentMin = 50_000_000.0;
            nextMax = 100_000_000.0;
        } else if (totalSpent >= 10_000_000) {
            currentMin = 10_000_000.0;
            nextMax = 50_000_000.0;
        }
        
        return ((totalSpent - currentMin) / (nextMax - currentMin)) * 100.0;
    }

    private String getRank(Double totalSpent) {
        if (totalSpent == null) return "Bronze";
        if (totalSpent >= 200_000_000) return "Diamond";
        if (totalSpent >= 100_000_000) return "Platinum";
        if (totalSpent >= 50_000_000) return "Gold";
        if (totalSpent >= 10_000_000) return "Silver";
        return "Bronze";
    }

    private String getRankClass(Double totalSpent) {
        if (totalSpent == null) return "rank-bronze";
        if (totalSpent >= 200_000_000) return "rank-diamond";
        if (totalSpent >= 100_000_000) return "rank-platinum";
        if (totalSpent >= 50_000_000) return "rank-gold";
        if (totalSpent >= 10_000_000) return "rank-silver";
        return "rank-bronze";
    }

    @Transactional
    public void uploadAvatar(org.springframework.web.multipart.MultipartFile file, User user) throws java.io.IOException {
        String srcUploadDir = "src/main/resources/static/uploads/avatars/";
        String targetUploadDir = "target/classes/static/uploads/avatars/";

        java.io.File srcDir = new java.io.File(srcUploadDir);
        if (!srcDir.exists()) srcDir.mkdirs();

        java.io.File targetDir = new java.io.File(targetUploadDir);
        if (!targetDir.exists()) targetDir.mkdirs();

        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.lastIndexOf(".") > 0) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        String newFilename = "user_" + user.getId() + "_" + System.currentTimeMillis() + extension;

        java.nio.file.Path srcPath = java.nio.file.Paths.get(srcUploadDir + newFilename).toAbsolutePath();
        file.transferTo(srcPath.toFile());

        java.nio.file.Path targetPath = java.nio.file.Paths.get(targetUploadDir + newFilename);
        java.nio.file.Files.copy(srcPath, targetPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);

        user.setAvatar("/uploads/avatars/" + newFilename);
        userRepository.save(user);
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
