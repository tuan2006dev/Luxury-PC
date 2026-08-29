package poly.edu.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.dao.CategoryDAO;
import poly.edu.entity.AdminLog;
import poly.edu.entity.Voucher;
import poly.edu.repository.AdminLogRepository;
import poly.edu.service.VoucherService;

import java.security.Principal;
import java.util.Date;

@Controller
@RequestMapping("/admin/vouchers")
@RequiredArgsConstructor
public class AdminVoucherController {

    private final VoucherService voucherService;
    private final CategoryDAO categoryDAO;
    private final AdminLogRepository adminLogRepository;

    @GetMapping("")
    public String listVouchers(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "page", required = false, defaultValue = "1") Integer page,
            Model model) {
        java.util.List<Voucher> vouchers = voucherService.getAllVouchers();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            vouchers = vouchers.stream()
                    .filter(v -> (v.getCode() != null && v.getCode().toLowerCase().contains(kw)) ||
                                 (v.getDescription() != null && v.getDescription().toLowerCase().contains(kw)) ||
                                 (v.getId() != null && String.valueOf(v.getId()).contains(kw)))
                    .collect(java.util.stream.Collectors.toList());
        }
        java.util.List<Voucher> paginatedVouchers = poly.edu.util.PaginationUtils.paginate(vouchers, page, model);
        model.addAttribute("vouchers", paginatedVouchers);
        model.addAttribute("categories", categoryDAO.findAll());
        model.addAttribute("voucher", new Voucher());
        model.addAttribute("keyword", keyword);
        return "admin/vouchers";
    }

    @PostMapping("/save")
    public String saveVoucher(
            @RequestParam(required = false) Integer id,
            @RequestParam String code,
            @RequestParam(required = false) String description,
            @RequestParam String discountType,
            @RequestParam Double discountValue,
            @RequestParam(required = false) Double minOrderAmount,
            @RequestParam(required = false) Double maxDiscountAmount,
            @RequestParam(required = false) Integer usageLimit,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm") Date endDate,
            @RequestParam(required = false, defaultValue = "GLOBAL") String voucherScope,
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(required = false, defaultValue = "true") Boolean active,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes ra) {

        Voucher voucher;
        if (id != null) {
            voucher = voucherService.getById(id);
            if (voucher == null) {
                ra.addFlashAttribute("error", "Voucher không tồn tại");
                return "redirect:/admin/vouchers";
            }
        } else {
            voucher = new Voucher();
        }

        voucher.setCode(code);
        voucher.setDescription(description);
        voucher.setDiscountType(Voucher.DiscountType.valueOf(discountType));
        voucher.setDiscountValue(discountValue);
        voucher.setMinOrderAmount(minOrderAmount);
        voucher.setMaxDiscountAmount(maxDiscountAmount);
        voucher.setUsageLimit(usageLimit);
        voucher.setStartDate(startDate);
        voucher.setEndDate(endDate);
        voucher.setVoucherScope(Voucher.VoucherScope.valueOf(voucherScope));
        voucher.setActive(active);

        if (categoryId != null) {
            categoryDAO.findById(categoryId).ifPresent(voucher::setCategory);
        } else {
            voucher.setCategory(null);
        }

        voucherService.saveVoucher(voucher);

        logAction(principal, request, (id != null ? "Cập nhật Voucher" : "Tạo Voucher mới"), code);

        ra.addFlashAttribute("success", id != null ? "Cập nhật voucher thành công!" : "Tạo voucher thành công!");
        return "redirect:/admin/vouchers";
    }

    @PostMapping("/delete/{id}")
    public String deleteVoucher(
            @PathVariable Integer id,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes ra) {

        Voucher v = voucherService.getById(id);
        String code = v != null ? v.getCode() : "Voucher #" + id;

        voucherService.deleteVoucher(id);
        logAction(principal, request, "Xóa Voucher", code);

        ra.addFlashAttribute("success", "Đã xóa voucher!");
        return "redirect:/admin/vouchers";
    }

    @PostMapping("/toggle/{id}")
    public String toggleVoucher(
            @PathVariable Integer id,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes ra) {

        Voucher v = voucherService.getById(id);
        String code = v != null ? v.getCode() : "Voucher #" + id;

        voucherService.toggleVoucher(id);
        logAction(principal, request, "Bật/Tắt Voucher", code);

        ra.addFlashAttribute("success", "Đã cập nhật trạng thái voucher!");
        return "redirect:/admin/vouchers";
    }

    private void logAction(Principal principal, HttpServletRequest request, String action, String targetUser) {
        try {
            String username = principal != null ? principal.getName() : "STAFF";
            String ip = request.getHeader("X-Forwarded-For");
            if (ip == null || ip.isBlank() || "unknown".equalsIgnoreCase(ip)) {
                ip = request.getRemoteAddr();
            }
            adminLogRepository.save(new AdminLog(username, action, ip, targetUser));
        } catch (Exception e) {
            // Ignore logging errors
        }
    }
}
