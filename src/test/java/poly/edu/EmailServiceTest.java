package poly.edu;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import poly.edu.repository.PasswordResetRepository;
import poly.edu.service.EmailService;

import java.lang.reflect.Field;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doNothing;

class EmailServiceTest {

    @Mock
    private JavaMailSender mailSender;

    @Mock
    private PasswordResetRepository passwordResetRepo;

    @InjectMocks
    private EmailService emailService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        doNothing().when(mailSender).send(any(SimpleMailMessage.class));
    }

    @SuppressWarnings("unchecked")
    private Map<String, EmailService.OtpData> getOtpStorage() throws Exception {
        Field field = EmailService.class.getDeclaredField("otpStorage");
        field.setAccessible(true);
        return (Map<String, EmailService.OtpData>) field.get(emailService);
    }

    @Test
    void testSendAndVerifyOtp_Success() throws Exception {
        String email = "user@example.com";
        
        // 1. Gửi OTP
        emailService.sendOtpEmail(email, email);
        
        // Lấy OTP đã lưu qua Reflection để test
        Map<String, EmailService.OtpData> storage = getOtpStorage();
        EmailService.OtpData otpData = storage.get(email);
        
        assertNotNull(otpData, "OTP Data should be stored");
        assertFalse(otpData.isExpired(), "OTP should not be expired initially");
        
        String generatedCode = otpData.getCode();
        assertEquals(6, generatedCode.length(), "OTP code must be 6 digits");
        
        // 2. Xác thực thành công
        boolean verifyResult = emailService.verifyOtp(email, generatedCode);
        assertTrue(verifyResult, "Verification should succeed with correct OTP");
        
        // 3. OTP phải được xóa sau khi dùng
        assertNull(storage.get(email), "OTP should be cleared after successful verification");
    }

    @Test
    void testVerifyOtp_WrongCode_Fail() throws Exception {
        String email = "user@example.com";
        emailService.sendOtpEmail(email, email);
        
        Map<String, EmailService.OtpData> storage = getOtpStorage();
        EmailService.OtpData otpData = storage.get(email);
        
        String generatedCode = otpData.getCode();
        String wrongCode = generatedCode.equals("000000") ? "111111" : "000000";
        
        boolean verifyResult = emailService.verifyOtp(email, wrongCode);
        assertFalse(verifyResult, "Verification should fail with wrong OTP");
        assertNotNull(storage.get(email), "OTP should not be cleared if verification fails");
    }

    @Test
    void testVerifyOtp_WrongEmail_Fail() throws Exception {
        String email = "user@example.com";
        emailService.sendOtpEmail(email, email);
        
        Map<String, EmailService.OtpData> storage = getOtpStorage();
        EmailService.OtpData otpData = storage.get(email);
        String generatedCode = otpData.getCode();
        
        boolean verifyResult = emailService.verifyOtp("different@example.com", generatedCode);
        assertFalse(verifyResult, "Verification should fail with different email");
    }

    @Test
    void testVerifyOtp_Expired_Fail() throws Exception {
        String email = "user@example.com";
        emailService.sendOtpEmail(email, email);
        
        Map<String, EmailService.OtpData> storage = getOtpStorage();
        
        // Đặt thời gian hết hạn lùi về quá khứ (đã hết hạn)
        EmailService.OtpData originalData = storage.get(email);
        EmailService.OtpData expiredData = new EmailService.OtpData(originalData.getCode(), System.currentTimeMillis() - 1000);
        storage.put(email, expiredData);
        
        boolean verifyResult = emailService.verifyOtp(email, originalData.getCode());
        assertFalse(verifyResult, "Verification should fail if OTP is expired");
        assertNull(storage.get(email), "Expired OTP should be cleared from storage");
    }
}
