package poly.edu.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import poly.edu.dao.UserVoucherDAO;
import poly.edu.dao.VoucherDAO;
import poly.edu.entity.User;
import poly.edu.entity.UserVoucher;
import poly.edu.entity.Voucher;

import java.util.Date;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class VoucherServiceTest {

    @Mock private VoucherDAO voucherDAO;
    @Mock private UserVoucherDAO userVoucherDAO;

    @InjectMocks
    private VoucherService voucherService;

    private User user;
    private Voucher voucher;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setId(1);

        voucher = new Voucher();
        voucher.setId(1);
        voucher.setCode("DISCOUNT50");
        voucher.setActive(true);
        voucher.setMinOrderAmount(100.0);
        voucher.setUsedCount(0);
        voucher.setUsageLimit(10);
        voucher.setDiscountType(Voucher.DiscountType.FIXED_AMOUNT);
        voucher.setDiscountValue(50.0);
    }

    @Test
    void validateVoucher_FailsIfUserNull() {
        Map<String, Object> res = voucherService.validateVoucher("CODE", 100.0, null);
        assertThat(res.get("valid")).isEqualTo(false);
        assertThat(res.get("message")).isEqualTo("Vui lòng đăng nhập để sử dụng mã!");
    }

    @Test
    void validateVoucher_FailsIfNotFound() {
        when(voucherDAO.findByCode(anyString())).thenReturn(Optional.empty());
        Map<String, Object> res = voucherService.validateVoucher("CODE", 100.0, user);
        assertThat(res.get("valid")).isEqualTo(false);
        assertThat(res.get("message")).isEqualTo("Mã voucher không tồn tại");
    }

    @Test
    void validateVoucher_FailsIfUserDoesNotHaveIt() {
        when(voucherDAO.findByCode("DISCOUNT50")).thenReturn(Optional.of(voucher));
        when(userVoucherDAO.findByUserAndVoucherCodeAndStatus(eq(user), eq("DISCOUNT50"), eq("AVAILABLE"))).thenReturn(Optional.empty());

        Map<String, Object> res = voucherService.validateVoucher("DISCOUNT50", 150.0, user);
        assertThat(res.get("valid")).isEqualTo(false);
        assertThat(res.get("message").toString()).contains("chưa lưu mã này");
    }

    @Test
    void validateVoucher_FailsIfNotActive() {
        voucher.setActive(false);
        when(voucherDAO.findByCode("DISCOUNT50")).thenReturn(Optional.of(voucher));
        when(userVoucherDAO.findByUserAndVoucherCodeAndStatus(any(), any(), eq("AVAILABLE"))).thenReturn(Optional.of(new UserVoucher()));

        Map<String, Object> res = voucherService.validateVoucher("DISCOUNT50", 150.0, user);
        assertThat(res.get("valid")).isEqualTo(false);
        assertThat(res.get("message").toString()).contains("bị vô hiệu hóa");
    }

    @Test
    void validateVoucher_FailsIfExpired() {
        voucher.setEndDate(new Date(System.currentTimeMillis() - 1000000));
        when(voucherDAO.findByCode("DISCOUNT50")).thenReturn(Optional.of(voucher));
        when(userVoucherDAO.findByUserAndVoucherCodeAndStatus(any(), any(), eq("AVAILABLE"))).thenReturn(Optional.of(new UserVoucher()));

        Map<String, Object> res = voucherService.validateVoucher("DISCOUNT50", 150.0, user);
        assertThat(res.get("valid")).isEqualTo(false);
        assertThat(res.get("message").toString()).contains("đã hết hạn");
    }

    @Test
    void validateVoucher_FailsIfMinOrderNotMet() {
        when(voucherDAO.findByCode("DISCOUNT50")).thenReturn(Optional.of(voucher));
        when(userVoucherDAO.findByUserAndVoucherCodeAndStatus(any(), any(), eq("AVAILABLE"))).thenReturn(Optional.of(new UserVoucher()));

        Map<String, Object> res = voucherService.validateVoucher("DISCOUNT50", 50.0, user);
        assertThat(res.get("valid")).isEqualTo(false);
        assertThat(res.get("message").toString()).contains("Đơn hàng tối thiểu");
    }

    @Test
    void validateVoucher_Success() {
        when(voucherDAO.findByCode("DISCOUNT50")).thenReturn(Optional.of(voucher));
        when(userVoucherDAO.findByUserAndVoucherCodeAndStatus(any(), any(), eq("AVAILABLE"))).thenReturn(Optional.of(new UserVoucher()));

        Map<String, Object> res = voucherService.validateVoucher("DISCOUNT50", 150.0, user);
        assertThat(res.get("valid")).isEqualTo(true);
        assertThat(res.get("discount")).isEqualTo(50.0);
    }
}
