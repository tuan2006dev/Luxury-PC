package poly.edu.controller;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import poly.edu.dto.ApiResponse;
import poly.edu.entity.User;
import poly.edu.repository.UserRepository;

@RestController
@RequestMapping("/api/profile")
public class ProfileApiController {

    private final UserRepository userRepository;

    public ProfileApiController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<Map<String, Object>>> getProfile(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body(ApiResponse.error("Chưa đăng nhập.", null));
        }

        User user = userRepository.findByEmail(authentication.getName()).orElse(null);
        if (user == null) {
            return ResponseEntity.status(404).body(ApiResponse.error("Không tìm thấy người dùng.", null));
        }

        Map<String, Object> profileData = new LinkedHashMap<>();
        profileData.put("id", user.getId());
        profileData.put("email", user.getEmail());
        profileData.put("fullName", user.getFullName());
        profileData.put("phone", user.getPhone());
        profileData.put("birthday", user.getBirthday());
        profileData.put("gender", user.getGender());
        profileData.put("createdAt", user.getCreatedAt());

        return ResponseEntity.ok(ApiResponse.success("Success", profileData));
    }
}
