package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;

    private final poly.edu.repository.PasswordResetRepository passwordResetRepo;

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

        poly.edu.entity.PasswordReset pr = passwordResetRepo.findByEmail(storedEmail)
                .orElse(new poly.edu.entity.PasswordReset());
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

    public void sendOrderCancellationEmailToAdmin(poly.edu.entity.Order order) {
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
}
