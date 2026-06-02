package poly.edu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import poly.edu.entity.FlashSale;
import poly.edu.entity.FlashSaleItem;
import poly.edu.service.FlashSaleService;
import poly.edu.service.ProductService;
import poly.edu.service.VoucherService;

import java.util.List;
import java.util.Optional;

@Controller
public class HomeController {

    @Autowired
    ProductService productService;

    @Autowired
    poly.edu.service.ReviewService reviewService;

    @Autowired
    VoucherService voucherService;

    @Autowired
    FlashSaleService flashSaleService;

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("featuredProducts", productService.getFeaturedProducts());
        model.addAttribute("allProducts", productService.getAllProducts());
        model.addAttribute("reviews", reviewService.getLatestReviews());

        // Flash Sale từ database
        Optional<FlashSale> currentSale = flashSaleService.getCurrentFlashSale();
        if (currentSale.isPresent()) {
            FlashSale sale = currentSale.get();
            List<FlashSaleItem> saleItems = flashSaleService.getItemsBySaleId(sale.getId());
            model.addAttribute("flashSale", sale);
            model.addAttribute("flashSaleItems", saleItems);
            model.addAttribute("flashSaleEndTime", sale.getEndTime().getTime());
        } else {
            // Fallback: vẫn hiển thị sản phẩm "sắp hết" nếu không có flash sale
            model.addAttribute("flashSaleProducts", productService.getFlashSaleProducts());
            model.addAttribute("flashSaleEndTime", 0);
        }

        // Voucher từ database
        model.addAttribute("activeVouchers", voucherService.getActiveVouchers());

        return "index";
    }
}

