package poly.edu.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.VoucherDAO;
import poly.edu.entity.Voucher;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.Product;
import poly.edu.entity.CartItem;

import java.util.*;

@Service
@RequiredArgsConstructor
public class VoucherService {

    @Value("${voucher.reservation-timeout:15}")
    private int reservationTimeoutMinutes;

    private final VoucherDAO voucherDAO;

    private final poly.edu.dao.UserVoucherDAO userVoucherDAO;
    
    private final ProductDAO productDAO;

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
    public Map<String, Object> validateVoucher(String code, double cartTotal, double shippingFee, Collection<poly.edu.entity.CartItem> cartItems, poly.edu.entity.User user) {
        Map<String, Object> result = new HashMap<>();

        if (user == null) {
            result.put("success", false);
            result.put("valid", false);
            result.put("message", "Vui lòng đăng nhập để sử dụng mã!");
            return result;
        }

        Optional<Voucher> opt = voucherDAO.findByCode(code.trim().toUpperCase());
        if (opt.isEmpty()) {
            result.put("success", false);
            result.put("valid", false);
            result.put("message", "Mã voucher không tồn tại");
            return result;
        }

        Voucher voucher = opt.get();

        // Check if user has this voucher in their wallet and unused (AVAILABLE)
        Optional<poly.edu.entity.UserVoucher> userVoucherOpt = userVoucherDAO.findByUserAndVoucherCodeAndStatus(user,
                code.trim().toUpperCase(), "AVAILABLE");
        if (userVoucherOpt.isEmpty()) {
            result.put("success", false);
            result.put("valid", false);
            result.put("message", "Bạn chưa lưu mã này hoặc mã đã được sử dụng!");
            return result;
        }

        if (!Boolean.TRUE.equals(voucher.getActive())) {
            result.put("success", false);
            result.put("valid", false);
            result.put("message", "Mã voucher đã bị vô hiệu hóa");
            return result;
        }

        Date now = new Date();
        if (voucher.getStartDate() != null && now.before(voucher.getStartDate())) {
            result.put("success", false);
            result.put("valid", false);
            result.put("message", "Mã voucher chưa đến thời hạn sử dụng");
            return result;
        }

        if (voucher.getEndDate() != null && now.after(voucher.getEndDate())) {
            result.put("success", false);
            result.put("valid", false);
            result.put("message", "Mã voucher đã hết hạn");
            return result;
        }

        if (voucher.getUsageLimit() != null && voucher.getUsedCount() >= voucher.getUsageLimit()) {
            result.put("success", false);
            result.put("valid", false);
            result.put("message", "Mã voucher đã hết lượt sử dụng");
            return result;
        }

        // Xử lý logic VoucherScope
        double baseAmount = cartTotal; // Mặc định giảm trên tổng đơn
        if (voucher.getVoucherScope() == Voucher.VoucherScope.FREESHIP) {
            baseAmount = shippingFee;
        } else if (voucher.getVoucherScope() == Voucher.VoucherScope.CATEGORY) {
            if (voucher.getCategory() == null) {
                result.put("success", false);
                result.put("valid", false);
                result.put("message", "Voucher danh mục bị lỗi cấu hình.");
                return result;
            }
            double categoryTotal = 0;
            if (cartItems != null) {
                for (CartItem item : cartItems) {
                    Product p = null;
                    if (item.getId() != null) {
                        p = productDAO.findById(item.getId()).orElse(null);
                    }
                    if (p != null && p.getCategory() != null && p.getCategory().getId().equals(voucher.getCategory().getId())) {
                        categoryTotal += (item.getPrice() * item.getQuantity());
                    }
                }
            }
            if (categoryTotal == 0) {
                result.put("success", false);
                result.put("valid", false);
                result.put("message", "Giỏ hàng không có sản phẩm thuộc danh mục " + voucher.getCategory().getName() + " để áp dụng mã này.");
                return result;
            }
            baseAmount = categoryTotal;
        }

        if (voucher.getMinOrderAmount() != null && cartTotal < voucher.getMinOrderAmount()) {
            result.put("success", false);
            result.put("valid", false);
            result.put("message", "Đơn hàng tối thiểu " +
                    String.format("%,.0f", voucher.getMinOrderAmount()) + "₫ để sử dụng mã này");
            return result;
        }

        double discount = voucher.calculateDiscount(baseAmount);
        if (discount > baseAmount) {
            discount = baseAmount; // Security: Prevent negative total
        }
        result.put("success", true);
        result.put("valid", true);
        result.put("discount", discount);
        result.put("newTotal", cartTotal - discount);
        
        String msg = "Áp dụng thành công! Giảm " + String.format("%,.0f", discount) + "₫";
        if (voucher.getVoucherScope() == Voucher.VoucherScope.CATEGORY && voucher.getCategory() != null) {
            msg += " (Cho danh mục " + voucher.getCategory().getName() + ")";
        } else if (voucher.getVoucherScope() == Voucher.VoucherScope.FREESHIP) {
            msg += " (Phí vận chuyển)";
        }
        
        result.put("message", msg);
        result.put("discountType", voucher.getDiscountType().name());
        result.put("discountValue", voucher.getDiscountValue());
        return result;
    }

    /**
     * Validate Combo 2 Mã Voucher: 1 Mã Đơn Hàng / Danh Mục + 1 Mã Freeship
     */
    public Map<String, Object> validateVoucherCombo(String voucherCode, String freeshipCode, double cartTotal, double shippingFee, Collection<poly.edu.entity.CartItem> cartItems, poly.edu.entity.User user) {
        Map<String, Object> result = new HashMap<>();
        double orderDiscount = 0;
        double freeshipDiscount = 0;
        String appliedVoucherCode = null;
        String appliedFreeshipCode = null;
        StringBuilder messageBuilder = new StringBuilder();

        // 1. Validate Order / Category Discount Voucher
        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            Map<String, Object> val1 = validateVoucher(voucherCode, cartTotal, shippingFee, cartItems, user);
            if (!Boolean.TRUE.equals(val1.get("valid"))) {
                result.put("success", false);
                result.put("valid", false);
                result.put("message", val1.get("message"));
                return result;
            }
            orderDiscount = (double) val1.get("discount");
            appliedVoucherCode = voucherCode.trim().toUpperCase();
            messageBuilder.append("Áp dụng mã giảm giá ").append(appliedVoucherCode).append(" (Giảm ").append(String.format("%,.0f", orderDiscount)).append("₫). ");
        }

        // 2. Validate Freeship Voucher
        if (freeshipCode != null && !freeshipCode.trim().isEmpty()) {
            Map<String, Object> val2 = validateVoucher(freeshipCode, cartTotal, shippingFee, cartItems, user);
            if (!Boolean.TRUE.equals(val2.get("valid"))) {
                result.put("success", false);
                result.put("valid", false);
                result.put("message", val2.get("message"));
                return result;
            }
            freeshipDiscount = (double) val2.get("discount");
            appliedFreeshipCode = freeshipCode.trim().toUpperCase();
            messageBuilder.append("Áp dụng mã Freeship ").append(appliedFreeshipCode).append(" (Giảm ").append(String.format("%,.0f", freeshipDiscount)).append("₫ phí ship).");
        }

        double finalPrice = Math.max(0, (cartTotal - orderDiscount) + Math.max(0, shippingFee - freeshipDiscount));

        result.put("success", true);
        result.put("valid", true);
        result.put("orderDiscount", orderDiscount);
        result.put("freeshipDiscount", freeshipDiscount);
        result.put("totalDiscount", orderDiscount + freeshipDiscount);
        result.put("voucherCode", appliedVoucherCode);
        result.put("freeshipCode", appliedFreeshipCode);
        result.put("newTotal", finalPrice);
        result.put("message", messageBuilder.length() > 0 ? messageBuilder.toString() : "Chưa chọn mã voucher.");
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
    @org.springframework.cache.annotation.CacheEvict(value = "activeVouchers", allEntries = true)
    public void restoreVoucher(String code, Integer userId) {
        if (code == null || code.trim().isEmpty())
            return;
        String upperCode = code.trim().toUpperCase();
        if (userId != null) {
            int restored = userVoucherDAO.restoreVoucherAtomically(userId, upperCode);
            if (restored > 0) {
                voucherDAO.decrementUsageAtomically(upperCode);
                return;
            }
        }
        voucherDAO.decrementUsageAtomically(upperCode);
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
