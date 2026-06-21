package poly.edu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.VoucherDAO;
import poly.edu.entity.Voucher;

import java.util.*;

@Service
public class VoucherService {

    @Autowired
    private VoucherDAO voucherDAO;

    @Autowired
    private poly.edu.dao.UserVoucherDAO userVoucherDAO;

    public List<Voucher> getAllVouchers() {
        return voucherDAO.findAllByOrderByCreatedAtDesc();
    }

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

        // Check if user has this voucher in their wallet and unused
        Optional<poly.edu.entity.UserVoucher> userVoucherOpt = userVoucherDAO.findByUserAndVoucherCodeAndIsUsedFalse(user, code.trim().toUpperCase());
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
        result.put("valid", true);
        result.put("discount", discount);
        result.put("message", "Áp dụng thành công! Giảm " + String.format("%,.0f", discount) + "₫");
        result.put("discountType", voucher.getDiscountType().name());
        result.put("discountValue", voucher.getDiscountValue());
        return result;
    }

    /**
     * Tăng số lần sử dụng voucher sau khi đặt hàng
     */
    @Transactional
    public void incrementUsage(String code) {
        Optional<Voucher> opt = voucherDAO.findByCode(code.trim().toUpperCase());
        if (opt.isPresent()) {
            Voucher v = opt.get();
            v.setUsedCount(v.getUsedCount() + 1);
            voucherDAO.save(v);
        }
    }

    public Voucher saveVoucher(Voucher voucher) {
        if (voucher.getCode() != null) {
            voucher.setCode(voucher.getCode().trim().toUpperCase());
        }
        return voucherDAO.save(voucher);
    }

    @Transactional
    public void deleteVoucher(Integer id) {
        userVoucherDAO.deleteByVoucherId(id);
        voucherDAO.deleteById(id);
    }

    @Transactional
    public void toggleVoucher(Integer id) {
        Voucher v = voucherDAO.findById(id).orElse(null);
        if (v != null) {
            v.setActive(!Boolean.TRUE.equals(v.getActive()));
            voucherDAO.save(v);
        }
    }
}
