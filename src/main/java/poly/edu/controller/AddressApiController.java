package poly.edu.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.data.jpa.repository.JpaRepository;
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
import poly.edu.repository.UserRepository;

@RestController
@RequestMapping("/api/address")
public class AddressApiController {

    private final UserRepository userRepository;

    public AddressApiController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> listAddresses(Authentication authentication) {
        User user = userRepository.findByEmail(authentication.getName()).orElse(null);
        if (user == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }

        List<Map<String, Object>> addresses = List.of();
        return ResponseEntity.ok(ApiResponse.success("Success", addresses));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getAddress(
            Authentication authentication,
            @PathVariable Integer id) {
        User user = userRepository.findByEmail(authentication.getName()).orElse(null);
        if (user == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }

        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", id);
        m.put("recipientName", "");
        m.put("phone", "");
        m.put("detailedAddress", "");
        m.put("district", "");
        m.put("city", "");
        m.put("postalCode", "");
        m.put("isDefault", false);

        return ResponseEntity.ok(ApiResponse.success("Success", m));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Map<String, Object>>> createAddress(
            Authentication authentication,
            @RequestBody AddressRequest request) {
        User user = userRepository.findByEmail(authentication.getName()).orElse(null);
        if (user == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }

        if (request.getRecipientName() == null || request.getRecipientName().isEmpty()) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Vui lòng nhập tên người nhận.", null));
        }

        Map<String, Object> m = new LinkedHashMap<>();
        m.put("message", "Địa chỉ đã được thêm.");
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("Created", m));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> updateAddress(
            Authentication authentication,
            @PathVariable Integer id,
            @RequestBody AddressRequest request) {
        User user = userRepository.findByEmail(authentication.getName()).orElse(null);
        if (user == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }

        Map<String, Object> m = new LinkedHashMap<>();
        m.put("message", "Địa chỉ đã được cập nhật.");
        return ResponseEntity.ok(ApiResponse.success("Updated", m));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Object>> deleteAddress(
            Authentication authentication,
            @PathVariable Integer id) {
        User user = userRepository.findByEmail(authentication.getName()).orElse(null);
        if (user == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }

        return ResponseEntity.ok(ApiResponse.success("Đã xóa địa chỉ.", null));
    }
}

