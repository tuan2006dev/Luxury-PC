package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.VoucherDAO;
import poly.edu.entity.Voucher;

import java.util.*;

@Service
@RequiredArgsConstructor
public class VoucherService {

    @Value("${voucher.reservation-timeout:15}")
    private int reservationTimeoutMinutes;

    private final VoucherDAO voucherDAO;

    private final poly.edu.dao.UserVoucherDAO userVoucherDAO;

    public List<Voucher> getAllVouchers() {
        return voucherDAO.findAllByOrderByCreatedAtDesc();
    }

    @org.springframework.cache.annotation.Cacheable("activeVouchers")
    public List<Voucher> getActiveVouchers() {
        return voucherDAO.findActiveVouchers();
    }

    public Optional<Voucher> findByCode(String code) {
        return voucherDAO.findByCode(code.trim().toUpperCase());
    }

    public Voucher getById(Integer id) {
        return voucherDAO.findById(id).orElse(null);
    }

    /**
     * Validate voucher: trả về Map chứa kết quả
     * {valid: true/false, message: "...", discount: số tiền giảm}
     */
    public Map<String, Object> validateVoucher(String code, double cartTotal, poly.edu.entity.User user) {
        Map<String, Object> result = new HashMap<>();

        if (user == null) {
            result.put("valid", false);
            result.put("message", "Vui lòng đăng nhập để sử dụng mã!");
            return result;
        }

        Optional<Voucher> opt = voucherDAO.findByCode(code.trim().toUpperCase());
        if (opt.isEmpty()) {
            result.put("valid", false);
            result.put("message", "Mã voucher không tồn tại");
            return result;
        }

        Voucher voucher = opt.get();

        // Check if user has this voucher in their wallet and unused (AVAILABLE)
        Optional<poly.edu.entity.UserVoucher> userVoucherOpt = userVoucherDAO.findByUserAndVoucherCodeAndStatus(user, code.trim().toUpperCase(), "AVAILABLE");
        if (userVoucherOpt.isEmpty()) {
            result.put("valid", false);
            result.put("message", "Bạn chưa lưu mã này hoặc mã đã được sử dụng!");
            return result;
        }

        if (!Boolean.TRUE.equals(voucher.getActive())) {
            result.put("valid", false);
            result.put("message", "Mã voucher đã bị vô hiệu hóa");
            return result;
        }

        Date now = new Date();
        if (voucher.getStartDate() != null && now.before(voucher.getStartDate())) {
            result.put("valid", false);
            result.put("message", "Mã voucher chưa đến thời hạn sử dụng");
            return result;
        }

        if (voucher.getEndDate() != null && now.after(voucher.getEndDate())) {
            result.put("valid", false);
            result.put("message", "Mã voucher đã hết hạn");
            return result;
        }

        if (voucher.getUsageLimit() != null && voucher.getUsedCount() >= voucher.getUsageLimit()) {
            result.put("valid", false);
            result.put("message", "Mã voucher đã hết lượt sử dụng");
            return result;
        }

        if (voucher.getMinOrderAmount() != null && cartTotal < voucher.getMinOrderAmount()) {
            result.put("valid", false);
            result.put("message", "Đơn hàng tối thiểu " +
                    String.format("%,.0f", voucher.getMinOrderAmount()) + "₫ để sử dụng mã này");
            return result;
        }

        double discount = voucher.calculateDiscount(cartTotal);
        if (discount > cartTotal) {
            discount = cartTotal; // Security: Prevent negative total
        }
        result.put("valid", true);
        result.put("discount", discount);
        result.put("message", "Áp dụng thành công! Giảm " + String.format("%,.0f", discount) + "₫");
        result.put("discountType", voucher.getDiscountType().name());
        result.put("discountValue", voucher.getDiscountValue());
        return result;
    }

    /**
     * Tạm giữ voucher khi người dùng đặt hàng
     */
    @Transactional
    public void reserveVoucher(String code, Integer userId) {
        String upperCode = code.trim().toUpperCase();
        int updated = voucherDAO.incrementUsageAtomically(upperCode);
        if (updated == 0) {
            throw new RuntimeException("Voucher này đã hết lượt sử dụng (Out of stock).");
        }
        
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MINUTE, reservationTimeoutMinutes);
        Date expiresAt = cal.getTime();
        
        int uvUpdated = userVoucherDAO.reserveVoucherAtomically(userId, upperCode, expiresAt);
        if (uvUpdated == 0) {
            // Rollback global increment if user didn't actually have it available
            voucherDAO.decrementUsageAtomically(upperCode);
            throw new RuntimeException("Bạn không thể sử dụng mã này do lỗi hệ thống hoặc đã dùng rồi.");
        }
    }

    /**
     * Xác nhận sử dụng voucher (khi thanh toán thành công)
     */
    @Transactional
    public void consumeVoucher(String code, Integer userId) {
        String upperCode = code.trim().toUpperCase();
        userVoucherDAO.consumeReservedVoucherAtomically(userId, upperCode);
    }

    /**
     * Hoàn trả voucher (khi hủy đơn hoặc hết hạn thanh toán)
     */
    @Transactional
    public void restoreVoucher(String code, Integer userId) {
        String upperCode = code.trim().toUpperCase();
        int restored = userVoucherDAO.restoreVoucherAtomically(userId, upperCode);
        if (restored > 0) {
            voucherDAO.decrementUsageAtomically(upperCode);
        }
    }

    @org.springframework.cache.annotation.CacheEvict(value = "activeVouchers", allEntries = true)
    public Voucher saveVoucher(Voucher voucher) {
        if (voucher.getCode() != null) {
            voucher.setCode(voucher.getCode().trim().toUpperCase());
        }
        return voucherDAO.save(voucher);
    }

    @Transactional
    @org.springframework.cache.annotation.CacheEvict(value = "activeVouchers", allEntries = true)
    public void deleteVoucher(Integer id) {
        userVoucherDAO.deleteByVoucherId(id);
        voucherDAO.deleteById(id);
    }

    @Transactional
    @org.springframework.cache.annotation.CacheEvict(value = "activeVouchers", allEntries = true)
    public void toggleVoucher(Integer id) {
        Voucher v = voucherDAO.findById(id).orElse(null);
        if (v != null) {
            v.setActive(!Boolean.TRUE.equals(v.getActive()));
            voucherDAO.save(v);
        }
    }
}
