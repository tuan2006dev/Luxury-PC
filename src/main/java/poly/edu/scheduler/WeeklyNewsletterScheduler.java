package poly.edu.scheduler;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import poly.edu.entity.User;
import poly.edu.repository.UserRepository;
import poly.edu.service.EmailService;

import java.util.List;

@Component
@RequiredArgsConstructor
public class WeeklyNewsletterScheduler {

    private static final Logger log = LoggerFactory.getLogger(WeeklyNewsletterScheduler.class);

    private final UserRepository userRepository;
    private final EmailService emailService;

    /**
     * Tự động chạy vào 08:00 sáng Thứ Hai hàng tuần để gửi Bản tin công nghệ
     * Cron expression: Second Minute Hour DayOfMonth Month DayOfWeek
     */
    @Scheduled(cron = "0 0 8 * * MON")
    public void sendWeeklyNewsletterToSubscribers() {
        log.info("📧 [Weekly Newsletter] Bắt đầu tiến trình gửi bản tin hàng tuần cho người dùng đăng ký...");
        try {
            List<User> subscribers = userRepository.findWeeklyNewsletterSubscribers();
            if (subscribers == null || subscribers.isEmpty()) {
                log.info("📧 [Weekly Newsletter] Không có người dùng nào đăng ký nhận bản tin.");
                return;
            }

            int count = 0;
            for (User user : subscribers) {
                emailService.sendWeeklyNewsletterEmail(user);
                count++;
            }
            log.info("📧 [Weekly Newsletter] Đã gửi bản tin thành công cho {} người dùng.", count);
        } catch (Exception e) {
            log.error("❌ [Weekly Newsletter] Lỗi khi thực thi tiến trình gửi bản tin: {}", e.getMessage(), e);
        }
    }
}
