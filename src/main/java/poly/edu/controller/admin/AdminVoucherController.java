package poly.edu.controller.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.dao.CategoryDAO;
import poly.edu.entity.Voucher;
import poly.edu.service.VoucherService;

import java.util.Date;

@Controller
@RequestMapping("/admin/vouchers")
public class AdminVoucherController {

    @Autowired
    private VoucherService voucherService;

    @Autowired
    private CategoryDAO categoryDAO;

    @GetMapping("")
    public String listVouchers(Model model) {
        model.addAttribute("vouchers", voucherService.getAllVouchers());
        model.addAttribute("categories", categoryDAO.findAll());
        model.addAttribute("voucher", new Voucher());
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
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(required = false, defaultValue = "true") Boolean active,
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
        voucher.setActive(active);

        if (categoryId != null) {
            categoryDAO.findById(categoryId).ifPresent(voucher::setCategory);
        } else {
            voucher.setCategory(null);
        }

        voucherService.saveVoucher(voucher);
        ra.addFlashAttribute("success", id != null ? "Cập nhật voucher thành công!" : "Tạo voucher thành công!");
        return "redirect:/admin/vouchers";
    }

    @PostMapping("/delete/{id}")
    public String deleteVoucher(@PathVariable Integer id, RedirectAttributes ra) {
        voucherService.deleteVoucher(id);
        ra.addFlashAttribute("success", "Đã xóa voucher!");
        return "redirect:/admin/vouchers";
    }

    @PostMapping("/toggle/{id}")
    public String toggleVoucher(@PathVariable Integer id, RedirectAttributes ra) {
        voucherService.toggleVoucher(id);
        ra.addFlashAttribute("success", "Đã cập nhật trạng thái voucher!");
        return "redirect:/admin/vouchers";
    }
}
