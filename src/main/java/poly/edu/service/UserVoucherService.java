package poly.edu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import poly.edu.dao.UserVoucherDAO;
import poly.edu.dao.VoucherDAO;
import poly.edu.entity.User;
import poly.edu.entity.UserVoucher;
import poly.edu.entity.Voucher;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class UserVoucherService {

    @Autowired
    private UserVoucherDAO userVoucherDAO;

    @Autowired
    private VoucherDAO voucherDAO;

    public Map<String, Object> saveVoucherForUser(User user, String voucherCode) {
        Map<String, Object> response = new HashMap<>();

        String codeUpper = (voucherCode != null) ? voucherCode.trim().toUpperCase() : "";
        Optional<Voucher> voucherOpt = voucherDAO.findByCode(codeUpper);
        if (voucherOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "Mã voucher không tồn tại.");
            return response;
        }

        Voucher voucher = voucherOpt.get();

        if (!voucher.isValid()) {
            response.put("success", false);
            response.put("message", "Mã voucher đã hết hạn hoặc không hoạt động.");
            return response;
        }

        // Check if user already saved this voucher
        Optional<UserVoucher> existing = userVoucherDAO.findByUserAndVoucher(user, voucher);
        if (existing.isPresent()) {
            response.put("success", false);
            response.put("message", "Bạn đã lưu mã voucher này rồi.");
            return response;
        }

        // Check usage limit
        if (voucher.getUsageLimit() != null) {
            int savedCount = userVoucherDAO.countByVoucher(voucher); // Assuming usageLimit applies to saves
            // Wait, does user limit apply to saves or ultimate uses? Given user said "có chứ giơi hạn số lượng voucher thôi họ phải lưu mã về mới dùng dc",
            // It means they want limit on saving. 
            if (savedCount >= voucher.getUsageLimit()) {
                response.put("success", false);
                response.put("message", "Mã voucher đã hết lượt lưu.");
                return response;
            }
        }

        UserVoucher userVoucher = new UserVoucher();
        userVoucher.setUser(user);
        userVoucher.setVoucher(voucher);
        userVoucherDAO.save(userVoucher);

        response.put("success", true);
        response.put("message", "Lưu mã voucher thành công!");
        return response;
    }

    public List<UserVoucher> getMyVouchers(User user) {
        return userVoucherDAO.findByUserOrderBySavedAtDesc(user);
    }
    
    public List<UserVoucher> getMyUnusedVouchers(User user) {
        return userVoucherDAO.findByUserAndIsUsedFalseOrderBySavedAtDesc(user);
    }

    public void markVoucherAsUsed(User user, String voucherCode) {
        String codeUpper = (voucherCode != null) ? voucherCode.trim().toUpperCase() : "";
        Optional<UserVoucher> uvOpt = userVoucherDAO.findByUserAndVoucherCodeAndIsUsedFalse(user, codeUpper);
        if (uvOpt.isPresent()) {
            UserVoucher uv = uvOpt.get();
            uv.setIsUsed(true);
            uv.setUsedAt(new Date());
            userVoucherDAO.save(uv);

            // Also increment voucher usage
            Voucher voucher = uv.getVoucher();
            if (voucher.getUsedCount() == null) voucher.setUsedCount(0);
            voucher.setUsedCount(voucher.getUsedCount() + 1);
            voucherDAO.save(voucher);
        }
    }
}
