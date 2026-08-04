package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import poly.edu.dao.OrderItemDAO;
import poly.edu.dao.ProductDAO;
import poly.edu.dao.ReviewDAO;
import poly.edu.dto.ReviewRequest;
import poly.edu.entity.Product;
import poly.edu.entity.Review;
import poly.edu.entity.User;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReviewService {
    final ReviewDAO reviewDAO;
    final ProductDAO productDAO;
    final OrderItemDAO orderItemDAO;
    final ProfileService profileService;

    @org.springframework.cache.annotation.Cacheable("latestReviews")
    public List<Review> getLatestReviews() {
        return reviewDAO.findTop10ByOrderByCreatedAtDesc();
    }

    @Transactional(readOnly = true)
    public List<Review> getCurrentUserReviews(Authentication authentication) {
        User user = profileService.getCurrentUser(authentication);
        return reviewDAO.findByUser_IdOrderByCreatedAtDesc(user.getId());
    }

    @org.springframework.cache.annotation.CacheEvict(value = "latestReviews", allEntries = true)
    @Transactional
    public Review createReview(Authentication authentication, ReviewRequest request) {
        return createReviewWithMedia(authentication, request.getProductId(), request.getRating(), request.getComment(), null);
    }

    @org.springframework.cache.annotation.CacheEvict(value = "latestReviews", allEntries = true)
    @Transactional
    public Review createReviewWithMedia(Authentication authentication, Integer productId, Integer rating, String comment, MultipartFile file) {
        User user = profileService.getCurrentUser(authentication);
        Product product = productDAO.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy sản phẩm"));

        // 1. Kiểm tra đơn hàng thành công chứa sản phẩm này
        long countPurchase = orderItemDAO.countCompletedPurchasesByUserAndProduct(user.getId(), productId);
        if (countPurchase == 0) {
            throw new IllegalStateException("Bạn chỉ có thể đánh giá sản phẩm đã mua thành công.");
        }

        // 2. Kiểm tra xem người dùng đã đánh giá sản phẩm này chưa (chỉ được đánh giá 1 lần)
        if (reviewDAO.existsByUser_IdAndProduct_Id(user.getId(), productId)) {
            throw new IllegalStateException("Bạn đã đánh giá sản phẩm này rồi.");
        }

        Review review = new Review();
        review.setUser(user);
        review.setProduct(product);
        review.setStars(rating != null ? rating : 5);
        review.setContent(comment == null ? "" : comment.trim());

        // 3. Xử lý tải lên Ảnh hoặc Video đính kèm (không bắt buộc)
        if (file != null && !file.isEmpty()) {
            String contentType = file.getContentType();
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String filename = "review_" + product.getId() + "_" + user.getId() + "_" + System.currentTimeMillis() + extension;

            String srcUploadDir = "src/main/resources/static/uploads/reviews/";
            java.io.File srcFolder = new java.io.File(srcUploadDir);
            if (!srcFolder.exists()) {
                srcFolder.mkdirs();
            }
            java.nio.file.Path srcPath = java.nio.file.Paths.get(srcUploadDir + filename);
            try {
                java.nio.file.Files.copy(file.getInputStream(), srcPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);

                String targetUploadDir = "target/classes/static/uploads/reviews/";
                java.io.File targetFolder = new java.io.File(targetUploadDir);
                if (targetFolder.exists() || targetFolder.mkdirs()) {
                    java.nio.file.Path targetPath = java.nio.file.Paths.get(targetUploadDir + filename);
                    try {
                        java.nio.file.Files.copy(srcPath, targetPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    } catch (Exception ignored) {}
                }

                if (contentType != null && contentType.startsWith("video/")) {
                    review.setVideo("/uploads/reviews/" + filename);
                } else {
                    review.setImage("/uploads/reviews/" + filename);
                }
            } catch (Exception e) {
                throw new RuntimeException("Lỗi lưu file đính kèm: " + e.getMessage());
            }
        }

        return reviewDAO.save(review);
    }

    @org.springframework.cache.annotation.CacheEvict(value = "latestReviews", allEntries = true)
    @Transactional
    public void deleteReview(Authentication authentication, Integer id) {
        throw new IllegalStateException("Đánh giá sau khi gửi không thể sửa hoặc xóa.");
    }
}
