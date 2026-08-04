package poly.edu.controller.api;

import java.util.Map;
import java.util.Optional;
import java.util.regex.Pattern;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import poly.edu.entity.NewsletterSubscriber;
import poly.edu.entity.User;
import poly.edu.repository.NewsletterSubscriberRepository;
import poly.edu.repository.UserRepository;
import poly.edu.service.EmailService;

@RestController
@RequestMapping("/api/newsletter")
@RequiredArgsConstructor
public class NewsletterApiController {

    private final UserRepository userRepository;
    private final NewsletterSubscriberRepository subscriberRepository;
    private final EmailService emailService;

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$");

    @PostMapping("/subscribe")
    public ResponseEntity<?> subscribe(@RequestParam(value = "email", required = false) String email) {
        if (email == null || email.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Vui lòng nhập địa chỉ Email!"
            ));
        }

        String cleanEmail = email.trim().toLowerCase();
        if (!EMAIL_PATTERN.matcher(cleanEmail).matches()) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Định dạng Email không hợp lệ. Vui lòng kiểm tra lại!"
            ));
        }

        Optional<User> userOpt = userRepository.findByEmail(cleanEmail);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            boolean allEnabled = Boolean.TRUE.equals(user.getNotifyFlashSale())
                    && Boolean.TRUE.equals(user.getNotifyNewProducts())
                    && Boolean.TRUE.equals(user.getNotifyWeeklyNewsletter());

            if (allEnabled) {
                return ResponseEntity.ok(Map.of(
                    "success", true,
                    "alreadySubscribed", true,
                    "message", "Tài khoản (" + cleanEmail + ") của bạn đã bật đăng ký nhận thông tin khuyến mãi & sản phẩm mới từ trước!"
                ));
            }

            user.setNotifyFlashSale(true);
            user.setNotifyNewProducts(true);
            user.setNotifyWeeklyNewsletter(true);
            userRepository.save(user);

            // Gửi email chào mừng asynchronously
            new Thread(() -> emailService.sendNewsletterWelcomeEmail(cleanEmail, true)).start();

            return ResponseEntity.ok(Map.of(
                "success", true,
                "isUser", true,
                "message", "Đã bật nhận thông tin Flash Sale, Sản phẩm mới & Bảng tin tuần cho tài khoản của bạn thành công!"
            ));
        }

        // Trường hợp Khách vãng lai (Guest)
        Optional<NewsletterSubscriber> subOpt = subscriberRepository.findByEmail(cleanEmail);
        if (subOpt.isPresent()) {
            NewsletterSubscriber sub = subOpt.get();
            if (Boolean.TRUE.equals(sub.getActive())
                    && Boolean.TRUE.equals(sub.getNotifyFlashSale())
                    && Boolean.TRUE.equals(sub.getNotifyNewProducts())
                    && Boolean.TRUE.equals(sub.getNotifyWeeklyNewsletter())) {
                return ResponseEntity.ok(Map.of(
                    "success", true,
                    "alreadySubscribed", true,
                    "message", "Email (" + cleanEmail + ") đã được đăng ký nhận thông tin khuyến mãi từ trước!"
                ));
            }
            sub.setActive(true);
            sub.setNotifyFlashSale(true);
            sub.setNotifyNewProducts(true);
            sub.setNotifyWeeklyNewsletter(true);
            subscriberRepository.save(sub);
        } else {
            NewsletterSubscriber newSub = new NewsletterSubscriber();
            newSub.setEmail(cleanEmail);
            newSub.setActive(true);
            newSub.setNotifyFlashSale(true);
            newSub.setNotifyNewProducts(true);
            newSub.setNotifyWeeklyNewsletter(true);
            subscriberRepository.save(newSub);
        }

        // Gửi email chào mừng khách vãng lai asynchronously
        new Thread(() -> emailService.sendNewsletterWelcomeEmail(cleanEmail, false)).start();

        return ResponseEntity.ok(Map.of(
            "success", true,
            "isGuest", true,
            "message", "Đăng ký nhận tin thành công! Vui lòng kiểm tra Gmail để nhận ưu đãi từ Luxury PC."
        ));
    }
}
