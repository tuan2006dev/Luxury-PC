package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import poly.edu.entity.Order;
import poly.edu.entity.PasswordReset;
import poly.edu.entity.User;
import poly.edu.repository.PasswordResetRepository;

import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;
    private final PasswordResetRepository passwordResetRepo;

    public static class OtpData {
        private final String code;
        private final long expiryTime;

        public OtpData(String code, long expiryTime) {
            this.code = code;
            this.expiryTime = expiryTime;
        }

        public String getCode() {
            return code;
        }

        public boolean isExpired() {
            return System.currentTimeMillis() > expiryTime;
        }
    }

    // Bộ nhớ tạm để lưu OTP dạng Map<Email, OtpData>
    private Map<String, OtpData> otpStorage = new ConcurrentHashMap<>();

    public void sendOtpEmail(String storedEmail, String toEmail) {
        String otp = String.format("%06d", new Random().nextInt(999999));

        // Lưu OTP với thời hạn 5 phút (300.000 ms)
        long expiryTime = System.currentTimeMillis() + 5 * 60 * 1000;
        otpStorage.put(storedEmail, new OtpData(otp, expiryTime));

        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("luxury.pc.noreply@gmail.com");
        message.setTo(toEmail);
        message.setSubject("Mã xác thực Đăng ký tài khoản Luxury PC");
        message.setText("Chào bạn,\n\nMã OTP xác nhận đăng ký tài khoản Luxury PC của bạn là: " + otp
                + "\n\nVui lòng không chia sẻ mã này cho bất kỳ ai.\n\nTrân trọng,\nLuxury PC");

        mailSender.send(message);
    }

    public void sendForgotPasswordOtpEmail(String storedEmail, String toEmail) {
        String otp = String.format("%06d", new Random().nextInt(999999));

        PasswordReset pr = passwordResetRepo.findByEmail(storedEmail)
                .orElse(new PasswordReset());
        pr.setEmail(storedEmail);
        pr.setToken(otp);
        pr.setExpiry(java.time.LocalDateTime.now().plusMinutes(5));
        passwordResetRepo.save(pr);

        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("luxury.pc.noreply@gmail.com");
        message.setTo(toEmail);
        message.setSubject("Mã xác minh Quên mật khẩu Luxury PC");
        message.setText("Chào bạn,\n\nMã OTP xác nhận quên mật khẩu Luxury PC của bạn là: " + otp
                + "\n\nVui lòng không chia sẻ mã này cho bất kỳ ai.\n\nTrân trọng,\nLuxury PC");

        mailSender.send(message);
    }

    public boolean verifyForgotPasswordOtp(String email, String otp) {
        return passwordResetRepo.findByEmail(email).map(pr -> {
            if (pr.getToken().equals(otp) && pr.getExpiry().isAfter(java.time.LocalDateTime.now())) {
                passwordResetRepo.delete(pr);
                return true;
            }
            return false;
        }).orElse(false);
    }

    public boolean verifyOtp(String email, String otp) {
        OtpData otpData = otpStorage.get(email);
        if (otpData == null) {
            return false;
        }

        // 1. Kiểm tra hết hạn
        if (otpData.isExpired()) {
            otpStorage.remove(email); // Xóa mã đã hết hạn
            return false;
        }

        // 2. Kiểm tra trùng khớp mã
        if (otpData.getCode().equals(otp)) {
            otpStorage.remove(email); // Xoá sau khi xác thực thành công
            return true;
        }
        return false;
    }

    public void sendContactEmail(String name, String email, String message) {
        SimpleMailMessage mail = new SimpleMailMessage();
        mail.setFrom("luxury.pc.noreply@gmail.com");
        mail.setTo("luxury.pc.noreply@gmail.com");
        mail.setReplyTo(email);
        mail.setSubject("[Luxury PC Support] Liên hệ từ " + name);
        mail.setText("Tên: " + name + "\nEmail: " + email + "\n\nNội dung:\n" + message);
        mailSender.send(mail);
    }

    public void sendOrderCancellationEmailToAdmin(Order order) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("luxury.pc.noreply@gmail.com");
            message.setTo("leecookcu@gmail.com"); // Email nhận của Admin
            message.setSubject("[Luxury PC] Thông báo hủy đơn hàng #" + order.getId());
            message.setText("Chào Admin,\n\n"
                    + "Đơn hàng #Luxury-" + order.getId() + " đã bị hủy bởi khách hàng.\n\n"
                    + "Thông tin chi tiết:\n"
                    + "- Tên khách hàng: " + order.getFullName() + "\n"
                    + "- Số điện thoại: " + order.getPhone() + "\n"
                    + "- Tổng giá trị: " + String.format("%,.0f", order.getTotalPrice()) + " ₫\n"
                    + "- Trạng thái: Đã Hủy (CANCELED)\n\n"
                    + "Trân trọng,\nHệ thống Luxury PC");
            mailSender.send(message);
        } catch (Exception e) {
            System.err.println("Gửi email thông báo hủy đơn cho admin thất bại: " + e.getMessage());
        }
    }

    public void sendOrderStatusUpdateEmail(User user, Order order, String newStatus) {
        if (user == null || user.getEmail() == null || user.getEmail().trim().isEmpty())
            return;
        if (Boolean.FALSE.equals(user.getNotifyOrderUpdates()))
            return;

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("luxury.pc.noreply@gmail.com");
            message.setTo(user.getEmail());
            message.setSubject("[Luxury PC] Cập nhật trạng thái đơn hàng #Luxury-" + order.getId());
            message.setText("Chào " + (user.getFullName() != null ? user.getFullName() : "bạn") + ",\n\n"
                    + "Trạng thái đơn hàng #Luxury-" + order.getId() + " của bạn đã được thay đổi:\n"
                    + "👉 Trạng thái mới: " + newStatus + "\n\n"
                    + "Tổng giá trị: " + String.format("%,.0f", order.getTotalPrice()) + " ₫\n\n"
                    + "Cảm ơn bạn đã tin tưởng mua sắm tại Luxury PC!\n"
                    + "Trân trọng,\nHệ thống Luxury PC");
            mailSender.send(message);
        } catch (Exception e) {
            System.err.println("Gửi email cập nhật đơn hàng thất bại: " + e.getMessage());
        }
    }

    public void sendFlashSaleNotificationEmail(User user, String title, String content) {
        if (user == null || user.getEmail() == null || user.getEmail().trim().isEmpty())
            return;
        if (Boolean.FALSE.equals(user.getNotifyFlashSale()))
            return;

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("luxury.pc.noreply@gmail.com");
            message.setTo(user.getEmail());
            message.setSubject("[Luxury PC Flash Sale] " + title);
            message.setText("Chào " + (user.getFullName() != null ? user.getFullName() : "bạn") + ",\n\n"
                    + "⚡ SỰ KIỆN FLASH SALE & KHUYẾN MÃI ĐẶC BIỆT!\n\n"
                    + content + "\n\n"
                    + "Truy cập ngay Luxury PC để chọn mua những linh kiện giá tốt nhất!\n\n"
                    + "Trân trọng,\nLuxury PC Team");
            mailSender.send(message);
        } catch (Exception e) {
            System.err.println("Gửi email Flash Sale thất bại: " + e.getMessage());
        }
    }

    public void sendNewProductNotificationEmail(User user, String productName, Double price) {
        if (user == null || user.getEmail() == null || user.getEmail().trim().isEmpty())
            return;
        if (!Boolean.TRUE.equals(user.getNotifyNewProducts()))
            return;

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("luxury.pc.noreply@gmail.com");
            message.setTo(user.getEmail());
            message.setSubject("[Luxury PC] Linh kiện mới về kho: " + productName);
            message.setText("Chào " + (user.getFullName() != null ? user.getFullName() : "bạn") + ",\n\n"
                    + "🔥 LINH KIỆN MỚI CỰC HOT VỪA VỀ KHO LUXURY PC!\n\n"
                    + "- Tên linh kiện: " + productName + "\n"
                    + "- Giá niêm yết: " + String.format("%,.0f", price != null ? price : 0.0) + " ₫\n\n"
                    + "Đặt hàng ngay hôm nay để nhận ưu đãi vận chuyển tốt nhất!\n\n"
                    + "Trân trọng,\nLuxury PC Team");
            mailSender.send(message);
        } catch (Exception e) {
            System.err.println("Gửi email Sản phẩm mới thất bại: " + e.getMessage());
        }
    }

    public void sendWeeklyNewsletterEmail(User user) {
        if (user == null || user.getEmail() == null || user.getEmail().trim().isEmpty())
            return;
        if (Boolean.FALSE.equals(user.getNotifyWeeklyNewsletter()))
            return;

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("luxury.pc.noreply@gmail.com");
            message.setTo(user.getEmail());
            message.setSubject("[Luxury PC] Bản tin xu hướng công nghệ & Review hàng tuần");
            message.setText("Chào " + (user.getFullName() != null ? user.getFullName() : "bạn") + ",\n\n"
                    + "📰 BẢN TIN CÔNG NGHỆ THỨ HAI HÀNG TUẦN TỪ LUXURY PC!\n\n"
                    + "Tổng hợp xu hướng PC, linh kiện mới nhất và đánh giá chuyên sâu trong tuần qua:\n"
                    + "1. Xu hướng cấu hình PC Gaming 2026 vượt trội.\n"
                    + "2. Đánh giá thế hệ Card đồ họa & CPU mới nhất.\n"
                    + "3. Mẹo tối ưu hiệu năng máy tính cho Game thủ & Coder.\n\n"
                    + "Chúc bạn một tuần mới làm việc và giải trí hiệu quả!\n\n"
                    + "Trân trọng,\nLuxury PC Team");
            mailSender.send(message);
        } catch (Exception e) {
            System.err.println("Gửi email Bản tin hàng tuần thất bại: " + e.getMessage());
        }
    }
}