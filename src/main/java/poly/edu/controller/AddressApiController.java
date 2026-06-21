package poly.edu.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import poly.edu.dto.AddressRequest;
import poly.edu.dto.ApiResponse;
import poly.edu.entity.ShippingAddress;
import poly.edu.entity.User;
import poly.edu.repository.ShippingAddressRepository;
import poly.edu.repository.UserRepository;
import org.springframework.security.oauth2.core.user.OAuth2User;

@RestController
@RequestMapping("/api/address")
public class AddressApiController {

    private final UserRepository userRepository;
    private final ShippingAddressRepository shippingAddressRepository;

    public AddressApiController(UserRepository userRepository, ShippingAddressRepository shippingAddressRepository) {
        this.userRepository = userRepository;
        this.shippingAddressRepository = shippingAddressRepository;
    }

    private User resolveUser(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }
        Object principal = authentication.getPrincipal();
        String emailOrUsername = null;
        if (principal instanceof org.springframework.security.core.userdetails.User userDetails) {
            emailOrUsername = userDetails.getUsername();
        } else if (principal instanceof OAuth2User oauth2User) {
            Object email = oauth2User.getAttribute("email");
            if (email != null) {
                emailOrUsername = email.toString();
            }
        }
        if (emailOrUsername == null || emailOrUsername.isBlank()) {
            emailOrUsername = authentication.getName();
        }
        
        final String identifier = emailOrUsername;
        return userRepository.findByEmail(identifier)
                .or(() -> userRepository.findByUsername(identifier))
                .orElse(null);
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> listAddresses(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }
        User user = resolveUser(authentication);
        if (user == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }

        List<ShippingAddress> list = shippingAddressRepository.findByUser_IdOrderByDefaultShippingDescIdAsc(user.getId());
        List<Map<String, Object>> data = list.stream().map(addr -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", addr.getId());
            m.put("recipientName", addr.getRecipientName());
            m.put("phone", addr.getPhone());
            m.put("detailedAddress", addr.getAddress());
            m.put("district", addr.getDistrict());
            m.put("city", addr.getCity());
            m.put("postalCode", addr.isDefault() ? "Default" : "");
            m.put("isDefault", addr.isDefault());
            return m;
        }).toList();

        return ResponseEntity.ok(ApiResponse.success("Success", data));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getAddress(
            Authentication authentication,
            @PathVariable Integer id) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }
        User user = resolveUser(authentication);
        if (user == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }

        ShippingAddress addr = shippingAddressRepository.findById(id).orElse(null);
        if (addr == null || !addr.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(404).body(ApiResponse.error("Không tìm thấy địa chỉ hoặc không có quyền truy cập.", null));
        }

        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", addr.getId());
        m.put("recipientName", addr.getRecipientName());
        m.put("phone", addr.getPhone());
        m.put("detailedAddress", addr.getAddress());
        m.put("district", addr.getDistrict());
        m.put("city", addr.getCity());
        m.put("postalCode", "");
        m.put("isDefault", addr.isDefault());

        return ResponseEntity.ok(ApiResponse.success("Success", m));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Map<String, Object>>> createAddress(
            Authentication authentication,
            @RequestBody AddressRequest request) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }
        User user = resolveUser(authentication);
        if (user == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }

        if (request.getRecipientName() == null || request.getRecipientName().isBlank()) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Vui lòng nhập tên người nhận.", null));
        }
        if (request.getPhone() == null || request.getPhone().isBlank()) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Vui lòng nhập số điện thoại.", null));
        }
        String phone = request.getPhone().trim();
        if (!phone.matches("^0(3|5|7|8|9)[0-9]{8}$")) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Số điện thoại không hợp lệ. Vui lòng nhập đúng 10 chữ số (đầu số 03, 05, 07, 08, 09).", null));
        }
        if (request.getDetailedAddress() == null || request.getDetailedAddress().isBlank()) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Vui lòng nhập địa chỉ chi tiết.", null));
        }
        if (request.getCity() == null || request.getCity().isBlank()) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Vui lòng nhập tỉnh/thành phố.", null));
        }

        ShippingAddress addr = new ShippingAddress();
        addr.setUser(user);
        addr.setRecipientName(request.getRecipientName().trim());
        addr.setPhone(request.getPhone().trim());
        addr.setAddress(request.getDetailedAddress().trim());
        addr.setDistrict(request.getDistrict() != null ? request.getDistrict().trim() : "");
        addr.setCity(request.getCity().trim());
        
        long count = shippingAddressRepository.countByUser_Id(user.getId());
        addr.setDefault(count == 0);

        shippingAddressRepository.save(addr);

        Map<String, Object> m = new LinkedHashMap<>();
        m.put("message", "Địa chỉ đã được thêm thành công.");
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("Created", m));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> updateAddress(
            Authentication authentication,
            @PathVariable Integer id,
            @RequestBody AddressRequest request) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }
        User user = resolveUser(authentication);
        if (user == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }

        ShippingAddress addr = shippingAddressRepository.findById(id).orElse(null);
        if (addr == null || !addr.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(404).body(ApiResponse.error("Không tìm thấy địa chỉ hoặc không có quyền sửa.", null));
        }

        if (request.getRecipientName() == null || request.getRecipientName().isBlank()) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Vui lòng nhập tên người nhận.", null));
        }
        if (request.getPhone() == null || request.getPhone().isBlank()) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Vui lòng nhập số điện thoại.", null));
        }
        String phone = request.getPhone().trim();
        if (!phone.matches("^0(3|5|7|8|9)[0-9]{8}$")) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Số điện thoại không hợp lệ. Vui lòng nhập đúng 10 chữ số (đầu số 03, 05, 07, 08, 09).", null));
        }
        if (request.getDetailedAddress() == null || request.getDetailedAddress().isBlank()) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Vui lòng nhập địa chỉ chi tiết.", null));
        }
        if (request.getCity() == null || request.getCity().isBlank()) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Vui lòng nhập tỉnh/thành phố.", null));
        }

        addr.setRecipientName(request.getRecipientName().trim());
        addr.setPhone(request.getPhone().trim());
        addr.setAddress(request.getDetailedAddress().trim());
        addr.setDistrict(request.getDistrict() != null ? request.getDistrict().trim() : "");
        addr.setCity(request.getCity().trim());

        shippingAddressRepository.save(addr);

        Map<String, Object> m = new LinkedHashMap<>();
        m.put("message", "Địa chỉ đã được cập nhật thành công.");
        return ResponseEntity.ok(ApiResponse.success("Updated", m));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Object>> deleteAddress(
            Authentication authentication,
            @PathVariable Integer id) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }
        User user = resolveUser(authentication);
        if (user == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }

        ShippingAddress addr = shippingAddressRepository.findById(id).orElse(null);
        if (addr == null || !addr.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(404).body(ApiResponse.error("Không tìm thấy địa chỉ hoặc không có quyền xóa.", null));
        }

        boolean wasDefault = addr.isDefault();
        shippingAddressRepository.delete(addr);

        if (wasDefault) {
            List<ShippingAddress> rest = shippingAddressRepository.findByUser_IdOrderByDefaultShippingDescIdAsc(user.getId());
            if (!rest.isEmpty()) {
                ShippingAddress first = rest.get(0);
                first.setDefault(true);
                shippingAddressRepository.save(first);
            }
        }

        return ResponseEntity.ok(ApiResponse.success("Đã xóa địa chỉ thành công.", null));
    }

    @PutMapping("/{id}/default")
    public ResponseEntity<ApiResponse<Map<String, Object>>> setDefaultAddress(
            Authentication authentication,
            @PathVariable Integer id) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }
        User user = resolveUser(authentication);
        if (user == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }

        List<ShippingAddress> list = shippingAddressRepository.findByUser_IdOrderByDefaultShippingDescIdAsc(user.getId());
        boolean found = false;
        for (ShippingAddress addr : list) {
            boolean isTarget = addr.getId().equals(id);
            if (isTarget) {
                found = true;
            }
            addr.setDefault(isTarget);
        }

        if (!found) {
            return ResponseEntity.status(404).body(ApiResponse.error("Địa chỉ không tồn tại hoặc không thuộc về bạn.", null));
        }

        shippingAddressRepository.saveAll(list);
        Map<String, Object> m = new java.util.HashMap<>();
        m.put("message", "Đã đặt địa chỉ mặc định thành công.");
        return ResponseEntity.ok(ApiResponse.success("Success", m));
    }
}
