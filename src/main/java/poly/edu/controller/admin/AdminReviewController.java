package poly.edu.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import poly.edu.dao.ReviewDAO;
import poly.edu.entity.AdminLog;
import poly.edu.entity.Review;
import poly.edu.repository.AdminLogRepository;
import poly.edu.service.ReviewService;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/reviews")
@RequiredArgsConstructor
public class AdminReviewController {

    private static final Logger log = LoggerFactory.getLogger(AdminReviewController.class);

    private final ReviewDAO reviewDAO;
    private final ReviewService reviewService;
    private final AdminLogRepository adminLogRepository;

    @GetMapping("")
    public String listReviews(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "star", required = false) Integer star,
            @RequestParam(name = "status", required = false) String status,
            Model model) {

        List<Review> allReviews = reviewDAO.findAllByOrderByCreatedAtDesc();

        // Calculate statistics before filtering
        int totalReviews = allReviews.size();
        long pendingCount = allReviews.stream()
                .filter(r -> r.getReplyContent() == null || r.getReplyContent().isBlank())
                .count();
        long repliedCount = totalReviews - pendingCount;

        double avgRating = 0.0;
        if (totalReviews > 0) {
            double sum = allReviews.stream()
                    .mapToInt(r -> r.getStars() != null ? r.getStars() : 5)
                    .sum();
            avgRating = Math.round((sum / totalReviews) * 10.0) / 10.0;
        }

        long star5Count = allReviews.stream().filter(r -> r.getStars() != null && r.getStars() == 5).count();
        long star4Count = allReviews.stream().filter(r -> r.getStars() != null && r.getStars() == 4).count();
        long star3Count = allReviews.stream().filter(r -> r.getStars() != null && r.getStars() == 3).count();
        long star2Count = allReviews.stream().filter(r -> r.getStars() != null && r.getStars() == 2).count();
        long star1Count = allReviews.stream().filter(r -> r.getStars() != null && r.getStars() == 1).count();

        // Apply filters
        List<Review> filteredReviews = allReviews;

        if (star != null && star >= 1 && star <= 5) {
            filteredReviews = filteredReviews.stream()
                    .filter(r -> r.getStars() != null && r.getStars().equals(star))
                    .collect(Collectors.toList());
        }

        if (status != null && !status.isBlank() && !"ALL".equalsIgnoreCase(status)) {
            if ("PENDING".equalsIgnoreCase(status)) {
                filteredReviews = filteredReviews.stream()
                        .filter(r -> r.getReplyContent() == null || r.getReplyContent().isBlank())
                        .collect(Collectors.toList());
            } else if ("REPLIED".equalsIgnoreCase(status)) {
                filteredReviews = filteredReviews.stream()
                        .filter(r -> r.getReplyContent() != null && !r.getReplyContent().isBlank())
                        .collect(Collectors.toList());
            }
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            filteredReviews = filteredReviews.stream()
                    .filter(r -> (r.getId() != null && String.valueOf(r.getId()).contains(kw)) ||
                            (r.getContent() != null && r.getContent().toLowerCase().contains(kw)) ||
                            (r.getReplyContent() != null && r.getReplyContent().toLowerCase().contains(kw)) ||
                            (r.getUser() != null && r.getUser().getFullName() != null && r.getUser().getFullName().toLowerCase().contains(kw)) ||
                            (r.getUser() != null && r.getUser().getUsername() != null && r.getUser().getUsername().toLowerCase().contains(kw)) ||
                            (r.getUser() != null && r.getUser().getEmail() != null && r.getUser().getEmail().toLowerCase().contains(kw)) ||
                            (r.getProduct() != null && r.getProduct().getName() != null && r.getProduct().getName().toLowerCase().contains(kw)))
                    .collect(Collectors.toList());
        }

        model.addAttribute("reviews", filteredReviews);
        model.addAttribute("totalReviews", totalReviews);
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("repliedCount", repliedCount);
        model.addAttribute("star5Count", star5Count);
        model.addAttribute("star4Count", star4Count);
        model.addAttribute("star3Count", star3Count);
        model.addAttribute("star2Count", star2Count);
        model.addAttribute("star1Count", star1Count);

        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedStar", star);
        model.addAttribute("selectedStatus", status != null ? status : "ALL");

        return "admin/reviews";
    }

    @PostMapping("/reply")
    public String replyReview(
            @RequestParam Integer reviewId,
            @RequestParam String replyContent,
            Authentication authentication,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {

        try {
            Review review = reviewService.replyToReview(authentication, reviewId, replyContent);
            logAction(authentication, request, "Phản hồi đánh giá #" + reviewId,
                    review.getProduct() != null ? review.getProduct().getName() : "Review #" + reviewId);
            redirectAttributes.addFlashAttribute("message", "Đã gửi phản hồi bài đánh giá #" + reviewId + " thành công!");
        } catch (Exception e) {
            log.error("[AdminReview] Error replying to review id={}: {}", reviewId, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "Lỗi phản hồi: " + e.getMessage());
        }
        return "redirect:/admin/reviews";
    }

    @PostMapping("/delete/{id}")
    public String deleteReview(
            @PathVariable Integer id,
            Authentication authentication,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {

        try {
            Review r = reviewDAO.findById(id).orElse(null);
            String target = r != null && r.getProduct() != null ? r.getProduct().getName() : "Review #" + id;
            reviewDAO.deleteById(id);
            logAction(authentication, request, "Xóa đánh giá #" + id, target);
            redirectAttributes.addFlashAttribute("message", "Đã xóa bài đánh giá #" + id + " thành công!");
        } catch (Exception e) {
            log.error("[AdminReview] Error deleting review id={}: {}", id, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "Không thể xóa bài đánh giá: " + e.getMessage());
        }
        return "redirect:/admin/reviews";
    }

    private void logAction(Authentication authentication, HttpServletRequest request, String action, String targetUser) {
        try {
            String username = authentication != null ? authentication.getName() : "STAFF";
            String ip = request.getHeader("X-Forwarded-For");
            if (ip == null || ip.isBlank() || "unknown".equalsIgnoreCase(ip)) {
                ip = request.getRemoteAddr();
            }
            adminLogRepository.save(new AdminLog(username, action, ip, targetUser));
        } catch (Exception e) {
            // Ignore logging errors
        }
    }
}
