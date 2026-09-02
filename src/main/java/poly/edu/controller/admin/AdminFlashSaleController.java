package poly.edu.controller.admin;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.AdminLog;
import poly.edu.entity.FlashSale;
import poly.edu.entity.FlashSaleItem;
import poly.edu.repository.AdminLogRepository;
import poly.edu.service.FlashSaleService;
import poly.edu.service.UploadService;

import java.security.Principal;
import java.util.Date;

@Controller
@RequestMapping("/admin/flash-sales")
@RequiredArgsConstructor
public class AdminFlashSaleController {

    private final FlashSaleService flashSaleService;
    private final ProductDAO productDAO;
    private final UploadService uploadService;
    private final AdminLogRepository adminLogRepository;

    @GetMapping("")
    public String listFlashSales(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "page", required = false, defaultValue = "1") Integer page,
            Model model) {
        java.util.List<FlashSale> flashSales = flashSaleService.getAllFlashSales();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim().toLowerCase();
            flashSales = flashSales.stream()
                    .filter(f -> (f.getName() != null && f.getName().toLowerCase().contains(kw)) ||
                            (f.getId() != null && String.valueOf(f.getId()).contains(kw)))
                    .collect(java.util.stream.Collectors.toList());
        }
        java.util.List<FlashSale> paginatedSales = poly.edu.util.PaginationUtils.paginate(flashSales, page, model);
        model.addAttribute("flashSales", paginatedSales);
        model.addAttribute("keyword", keyword);
        return "admin/flash-sales";
    }

    @PostMapping("/save")
    public String saveFlashSale(
            @RequestParam(value = "id", required = false) Integer id,
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "startTime", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm") Date startTime,
            @RequestParam(value = "endTime", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm") Date endTime,
            @RequestParam(value = "active", required = false, defaultValue = "true") Boolean active,
            @RequestParam(value = "bannerImageFile", required = false) org.springframework.web.multipart.MultipartFile bannerImageFile,
            @RequestParam(value = "bannerImage", required = false) String bannerImageUrl,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "maxPerUser", required = false) Integer maxPerUser,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes ra) {

        if (name == null || name.trim().isEmpty()) {
            ra.addFlashAttribute("error", "Vui lòng nhập tên chương trình Flash Sale!");
            return "redirect:/admin/flash-sales";
        }

        if (startTime == null || endTime == null) {
            ra.addFlashAttribute("error", "Vui lòng chọn đầy đủ thời gian bắt đầu và thời gian kết thúc!");
            return "redirect:/admin/flash-sales";
        }

        if (!endTime.after(startTime)) {
            ra.addFlashAttribute("error", "Thời gian kết thúc phải sau thời gian bắt đầu!");
            return "redirect:/admin/flash-sales";
        }

        FlashSale sale;
        if (id != null) {
            sale = flashSaleService.getById(id);
            if (sale == null) {
                ra.addFlashAttribute("error", "Flash Sale không tồn tại");
                return "redirect:/admin/flash-sales";
            }
        } else {
            sale = new FlashSale();
        }

        sale.setName(name);
        sale.setStartTime(startTime);
        sale.setEndTime(endTime);
        sale.setActive(active);
        sale.setDescription(description);
        sale.setMaxPerUser(maxPerUser);

        // Handle Banner Image
        if (bannerImageFile != null && !bannerImageFile.isEmpty()) {
            String fileName = uploadService.save(bannerImageFile, "flashsale");
            sale.setBannerImage(fileName);
        } else if (bannerImageUrl != null && !bannerImageUrl.trim().isEmpty()) {
            sale.setBannerImage(bannerImageUrl);
        }

        flashSaleService.saveFlashSale(sale);

        String actionStr = (id != null) ? "Cập nhật Flash Sale" : "Tạo Flash Sale Mới";
        logAction(principal, request, actionStr, name);

        ra.addFlashAttribute("success", id != null ? "Cập nhật Flash Sale thành công!" : "Tạo Flash Sale thành công!");
        return "redirect:/admin/flash-sales";
    }

    @PostMapping("/delete/{id}")
    public String deleteFlashSale(
            @PathVariable("id") Integer id,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes ra) {

        FlashSale sale = flashSaleService.getById(id);
        String targetName = sale != null ? sale.getName() : "FlashSale #" + id;

        flashSaleService.deleteFlashSale(id);
        logAction(principal, request, "Xóa Flash Sale", targetName);

        ra.addFlashAttribute("success", "Đã xóa Flash Sale!");
        return "redirect:/admin/flash-sales";
    }

    @GetMapping("/{id}/items")
    public String manageItems(
            @PathVariable("id") Integer id,
            @RequestParam(name = "page", required = false, defaultValue = "1") Integer page,
            Model model) {
        FlashSale sale = flashSaleService.getById(id);
        if (sale == null)
            return "redirect:/admin/flash-sales";

        java.util.List<FlashSaleItem> items = flashSaleService.getItemsBySaleId(id);
        java.util.List<FlashSaleItem> paginatedItems = poly.edu.util.PaginationUtils.paginate(items, page, model);

        model.addAttribute("flashSale", sale);
        model.addAttribute("items", paginatedItems);
        model.addAttribute("products", productDAO.findAll());
        return "admin/flash-sale-items";
    }

    @PostMapping("/{id}/items/add")
    public String addItem(
            @PathVariable("id") Integer id,
            @RequestParam(value = "productId", required = false) Integer productId,
            @RequestParam(value = "salePrice", required = false) Double salePrice,
            @RequestParam(value = "saleDiscountPercent", required = false) Double saleDiscountPercent,
            @RequestParam(value = "saleQuantity", required = false) Integer saleQuantity,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes ra) {

        if (productId == null || saleQuantity == null) {
            ra.addFlashAttribute("error", "Vui lòng nhập đầy đủ thông tin sản phẩm và số lượng!");
            return "redirect:/admin/flash-sales/" + id + "/items";
        }

        poly.edu.entity.Product p = productDAO.findById(productId).orElse(null);
        if (p == null) {
            ra.addFlashAttribute("error", "Sản phẩm không tồn tại!");
            return "redirect:/admin/flash-sales/" + id + "/items";
        }

        // Tự động tính giá sale nếu người dùng chỉ nhập % giảm giá
        if (salePrice == null && saleDiscountPercent != null && saleDiscountPercent >= 0) {
            salePrice = Math.round(p.getPrice() * (1.0 - (saleDiscountPercent / 100.0)) / 1000.0) * 1000.0;
        }

        if (salePrice == null) {
            ra.addFlashAttribute("error", "Vui lòng nhập đầy đủ giá sale hoặc % giảm giá!");
            return "redirect:/admin/flash-sales/" + id + "/items";
        }

        if (salePrice > p.getPrice()) {
            ra.addFlashAttribute("error", "Giá SALE không được cao hơn giá gốc của sản phẩm!");
            return "redirect:/admin/flash-sales/" + id + "/items";
        }

        FlashSaleItem item = flashSaleService.addItemToSale(id, productId, salePrice, saleQuantity);
        if (item != null) {
            String pName = p.getName();
            logAction(principal, request, "Thêm SP vào Flash Sale", pName);
            ra.addFlashAttribute("success", "Đã thêm sản phẩm vào Flash Sale!");
        } else {
            ra.addFlashAttribute("error", "Không thể thêm sản phẩm!");
        }
        return "redirect:/admin/flash-sales/" + id + "/items";
    }

    @PostMapping("/{saleId}/items/remove/{itemId}")
    public String removeItem(
            @PathVariable("saleId") Integer saleId,
            @PathVariable("itemId") Integer itemId,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes ra) {

        flashSaleService.removeItemFromSale(itemId);
        logAction(principal, request, "Xóa SP khỏi Flash Sale", "ItemID #" + itemId);

        ra.addFlashAttribute("success", "Đã xóa sản phẩm khỏi Flash Sale!");
        return "redirect:/admin/flash-sales/" + saleId + "/items";
    }

    @PostMapping("/activate/{id}")
    public String activateFlashSale(
            @PathVariable("id") Integer id,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes ra) {

        flashSaleService.toggleFlashSale(id);
        logAction(principal, request, "Bật/Tắt Flash Sale", "FlashSale #" + id);

        ra.addFlashAttribute("success", "Đã cập nhật trạng thái chương trình Flash Sale thành công!");
        return "redirect:/admin/flash-sales";
    }

    @PostMapping("/toggle/{id}")
    public String toggleFlashSale(
            @PathVariable("id") Integer id,
            Principal principal,
            HttpServletRequest request,
            RedirectAttributes ra) {
        return activateFlashSale(id, principal, request, ra);
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
            // Ignore logging error to prevent blocking main flow
        }
    }
}
