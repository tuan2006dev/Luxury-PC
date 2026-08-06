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
        return createReviewWithMedia(authentication, request.getOrderItemId(), request.getProductId(), request.getRating(), request.getComment(), null);
    }

    @org.springframework.cache.annotation.CacheEvict(value = "latestReviews", allEntries = true)
    @Transactional
    public Review createReviewWithMedia(Authentication authentication, Integer productId, Integer rating, String comment, MultipartFile file) {
        return createReviewWithMedia(authentication, null, productId, rating, comment, file);
    }

    @org.springframework.cache.annotation.CacheEvict(value = "latestReviews", allEntries = true)
    @Transactional
    public Review createReviewWithMedia(Authentication authentication, Integer orderItemId, Integer productId, Integer rating, String comment, MultipartFile file) {
        User user = profileService.getCurrentUser(authentication);
        poly.edu.entity.OrderItem targetOrderItem = null;
        Product product = null;

        if (orderItemId != null) {
            targetOrderItem = orderItemDAO.findById(orderItemId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy chi tiết đơn hàng #" + orderItemId));
            
            if (targetOrderItem.getOrder() == null || targetOrderItem.getOrder().getUser() == null ||
                !targetOrderItem.getOrder().getUser().getId().equals(user.getId())) {
                throw new IllegalStateException("Lượt mua này không thuộc về tài khoản của bạn.");
            }

            String orderStatus = targetOrderItem.getOrder().getStatus();
            if (!"COMPLETED".equalsIgnoreCase(orderStatus) && !"HOAN_THANH".equalsIgnoreCase(orderStatus)) {
                throw new IllegalStateException("Bạn chỉ có thể đánh giá lượt mua thuộc đơn hàng đã hoàn thành.");
            }

            if (reviewDAO.existsByOrderItem_Id(orderItemId)) {
                throw new IllegalStateException("Lần mua hàng này đã được đánh giá rồi.");
            }

            product = targetOrderItem.getProduct();
        } else {
            if (productId == null) {
                throw new IllegalArgumentException("Vui lòng cung cấp sản phẩm cần đánh giá.");
            }

            product = productDAO.findById(productId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy sản phẩm"));

            List<poly.edu.entity.OrderItem> userItems = orderItemDAO.findCompletedOrderItemsByUserAndProduct(user.getId(), productId);
            if (userItems == null || userItems.isEmpty()) {
                throw new IllegalStateException("Bạn chỉ có thể đánh giá sản phẩm đã mua thành công.");
            }

            for (poly.edu.entity.OrderItem oi : userItems) {
                if (!reviewDAO.existsByOrderItem_Id(oi.getId())) {
                    targetOrderItem = oi;
                    break;
                }
            }

            if (targetOrderItem == null) {
                throw new IllegalStateException("Tất cả các lượt mua sản phẩm này của bạn đều đã được đánh giá rồi.");
            }
        }

        Review review = new Review();
        review.setUser(user);
        review.setProduct(product);
        review.setOrderItem(targetOrderItem);
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

    @Transactional
    public Review replyToReview(Authentication authentication, Integer reviewId, String replyContent) {
        if (authentication == null || !authentication.isAuthenticated()) {
            throw new IllegalStateException("Vui lòng đăng nhập để thực hiện phản hồi.");
        }

        User staffUser = profileService.getCurrentUser(authentication);

        boolean isStaffOrAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().contains("ADMIN") || a.getAuthority().contains("STAFF"));

        if (!isStaffOrAdmin && staffUser.getUserRoles() != null) {
            isStaffOrAdmin = staffUser.getUserRoles().stream()
                    .anyMatch(ur -> ur.getRole() != null && ("ADMIN".equalsIgnoreCase(ur.getRole().getName()) || "STAFF".equalsIgnoreCase(ur.getRole().getName())));
        }

        if (!isStaffOrAdmin) {
            throw new IllegalStateException("Chỉ Admin và Nhân viên (Staff) mới có quyền trả lời bài đánh giá.");
        }

        Review review = reviewDAO.findById(reviewId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bài đánh giá."));

        String roleLabel = "Quản Trị Viên";
        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().contains("ADMIN"));
        if (!isAdmin && staffUser.getUserRoles() != null) {
            isAdmin = staffUser.getUserRoles().stream()
                    .anyMatch(ur -> ur.getRole() != null && "ADMIN".equalsIgnoreCase(ur.getRole().getName()));
        }

        if (!isAdmin) {
            roleLabel = "Nhân Viên";
        }

        String displayName = staffUser.getFullName() != null && !staffUser.getFullName().isBlank()
                ? staffUser.getFullName()
                : staffUser.getUsername();

        review.setReplyContent(replyContent != null ? replyContent.trim() : "");
        review.setRepliedAt(java.time.LocalDateTime.now());
        review.setRepliedBy(displayName + " - " + roleLabel);

        return reviewDAO.save(review);
    }
}
