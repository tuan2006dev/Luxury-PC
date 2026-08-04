package poly.edu.controller.api;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;
import poly.edu.dto.ApiResponse;
import poly.edu.dto.ReviewRequest;
import poly.edu.entity.Review;
import poly.edu.service.ReviewService;

@RestController
@RequestMapping("/api/reviews")
public class ReviewApiController {

    private final ReviewService reviewService;

    public ReviewApiController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getMyReviews(Authentication authentication) {
        List<Map<String, Object>> data = reviewService.getCurrentUserReviews(authentication)
                .stream()
                .map(this::reviewData)
                .toList();
        return ResponseEntity.ok(ApiResponse.success("Success", data));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Map<String, Object>>> createReview(
            Authentication authentication,
            @org.springframework.web.bind.annotation.RequestParam("productId") Integer productId,
            @org.springframework.web.bind.annotation.RequestParam("rating") Integer rating,
            @org.springframework.web.bind.annotation.RequestParam(value = "comment", required = false) String comment,
            @org.springframework.web.bind.annotation.RequestParam(value = "file", required = false) org.springframework.web.multipart.MultipartFile file) {
        try {
            Review review = reviewService.createReviewWithMedia(authentication, productId, rating, comment, file);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ApiResponse.success("Đã lưu đánh giá sản phẩm.", reviewData(review)));
        } catch (IllegalStateException | IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage(), null));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Lỗi gửi đánh giá: " + e.getMessage(), null));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Object>> deleteReview(Authentication authentication, @PathVariable Integer id) {
        return ResponseEntity.badRequest().body(ApiResponse.error("Đánh giá sau khi gửi không thể chỉnh sửa hoặc xóa.", null));
    }

    private Map<String, Object> reviewData(Review review) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", review.getId());
        m.put("stars", review.getStars());
        m.put("content", review.getContent());
        m.put("image", review.getImage());
        m.put("video", review.getVideo());
        m.put("createdAt", review.getCreatedAt());
        if (review.getProduct() != null) {
            m.put("productId", review.getProduct().getId());
            m.put("productName", review.getProduct().getName());
        }
        return m;
    }

    private ResponseEntity<ApiResponse<Map<String, Object>>> validationError(BindingResult bindingResult) {
        Map<String, Object> errors = new LinkedHashMap<>();
        for (FieldError error : bindingResult.getFieldErrors()) {
            errors.put(error.getField(), error.getDefaultMessage());
        }
        return ResponseEntity.badRequest().body(ApiResponse.error("Dữ liệu không hợp lệ.", errors));
    }
}
