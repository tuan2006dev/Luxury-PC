package poly.edu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private poly.edu.repository.PasswordResetRepository passwordResetRepo;

    // Bộ nhớ tạm để lưu OTP (thực tế nên dùng DB hoặc Redis có expire time)
    private Map<String, String> otpStorage = new ConcurrentHashMap<>();

    public void sendOtpEmail(String storedEmail, String toEmail) {
        String otp = String.format("%06d", new Random().nextInt(999999));
        otpStorage.put(storedEmail, otp);

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
        String storedOtp = otpStorage.get(email);
        if (storedOtp != null && storedOtp.equals(otp)) {
            otpStorage.remove(email); // Xoá sau khi dùng
            return true;
        }
        return false;
    }

    public void sendContactEmail(String name, String email, String content) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("luxury.pc.noreply@gmail.com");
        message.setTo("admin@luxurypc.vn");
        message.setSubject("Yêu cầu hỗ trợ mới từ khách hàng: " + name);
        message.setText("Họ tên: " + name + "\n" +
                        "Email liên hệ: " + email + "\n\n" +
                        "Nội dung yêu cầu hỗ trợ:\n" + content);
        mailSender.send(message);
    }
}
