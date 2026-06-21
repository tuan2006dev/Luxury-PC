package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import poly.edu.dao.ProductDAO;
import poly.edu.entity.FlashSale;
import poly.edu.entity.FlashSaleItem;
import poly.edu.service.FlashSaleService;

import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/admin/flash-sales")
public class AdminFlashSaleController {

    @Autowired
    private FlashSaleService flashSaleService;

    @Autowired
    private ProductDAO productDAO;

    @GetMapping("")
    public String listFlashSales(Model model) {
        model.addAttribute("flashSales", flashSaleService.getAllFlashSales());
        return "admin/flash-sales";
    }

    @PostMapping("/save")
    public String saveFlashSale(
            @RequestParam(required = false) Integer id,
            @RequestParam String name,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm") Date startTime,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm") Date endTime,
            @RequestParam(required = false, defaultValue = "true") Boolean active,
            RedirectAttributes ra) {

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

        flashSaleService.saveFlashSale(sale);
        ra.addFlashAttribute("success", id != null ? "Cập nhật Flash Sale thành công!" : "Tạo Flash Sale thành công!");
        return "redirect:/admin/flash-sales";
    }

    @PostMapping("/delete/{id}")
    public String deleteFlashSale(@PathVariable Integer id, RedirectAttributes ra) {
        flashSaleService.deleteFlashSale(id);
        ra.addFlashAttribute("success", "Đã xóa Flash Sale!");
        return "redirect:/admin/flash-sales";
    }

    @GetMapping("/{id}/items")
    public String manageItems(@PathVariable Integer id, Model model) {
        FlashSale sale = flashSaleService.getById(id);
        if (sale == null) return "redirect:/admin/flash-sales";

        model.addAttribute("flashSale", sale);
        model.addAttribute("items", flashSaleService.getItemsBySaleId(id));
        model.addAttribute("products", productDAO.findAll());
        return "admin/flash-sale-items";
    }

    @PostMapping("/{id}/items/add")
    public String addItem(
            @PathVariable Integer id,
            @RequestParam(required = false) Integer productId,
            @RequestParam(required = false) Double salePrice,
            @RequestParam(required = false) Integer saleQuantity,
            RedirectAttributes ra) {

        if (productId == null || salePrice == null || saleQuantity == null) {
            ra.addFlashAttribute("error", "Vui lòng nhập đầy đủ thông tin sản phẩm, giá sale và số lượng!");
            return "redirect:/admin/flash-sales/" + id + "/items";
        }

        FlashSaleItem item = flashSaleService.addItemToSale(id, productId, salePrice, saleQuantity);
        if (item != null) {
            ra.addFlashAttribute("success", "Đã thêm sản phẩm vào Flash Sale!");
        } else {
            ra.addFlashAttribute("error", "Không thể thêm sản phẩm!");
        }
        return "redirect:/admin/flash-sales/" + id + "/items";
    }

    @PostMapping("/{saleId}/items/remove/{itemId}")
    public String removeItem(@PathVariable Integer saleId, @PathVariable Integer itemId, RedirectAttributes ra) {
        flashSaleService.removeItemFromSale(itemId);
        ra.addFlashAttribute("success", "Đã xóa sản phẩm khỏi Flash Sale!");
        return "redirect:/admin/flash-sales/" + saleId + "/items";
    }
}
