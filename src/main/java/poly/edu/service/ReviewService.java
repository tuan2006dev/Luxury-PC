package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.ReviewDAO;
import poly.edu.dao.ProductDAO;
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
        User user = profileService.getCurrentUser(authentication);
        Product product = productDAO.findById(request.getProductId())
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy sản phẩm"));

        Review review = new Review();
        review.setUser(user);
        review.setProduct(product);
        review.setStars(request.getRating());
        review.setContent(request.getComment() == null ? "" : request.getComment().trim());
        return reviewDAO.save(review);
    }

    @org.springframework.cache.annotation.CacheEvict(value = "latestReviews", allEntries = true)
    @Transactional
    public void deleteReview(Authentication authentication, Integer id) {
        User user = profileService.getCurrentUser(authentication);
        Review review = reviewDAO.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy đánh giá"));
        if (review.getUser() == null || !review.getUser().getId().equals(user.getId())) {
            throw new IllegalStateException("Không được phép xóa đánh giá này");
        }
        reviewDAO.delete(review);
    }
}
