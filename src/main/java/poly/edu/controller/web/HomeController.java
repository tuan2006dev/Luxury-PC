package poly.edu.controller.web;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import poly.edu.service.WishlistService;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class HomeController {

    private static final Logger log = LoggerFactory.getLogger(HomeController.class);

    final ProductService productService;

    final poly.edu.service.ReviewService reviewService;

    final VoucherService voucherService;

    final FlashSaleService flashSaleService;

    final WishlistService wishlistService;

    // hasValidImage removed for performance

    @GetMapping("/")
    public String index(Model model) {
        long totalStart = System.nanoTime();

        long t0 = System.nanoTime();
        model.addAttribute("featuredProducts", productService.getFeaturedProducts());
        long t1 = System.nanoTime();
        model.addAttribute("flashSaleProducts", productService.getFlashSaleProducts());
        long t2 = System.nanoTime();
        model.addAttribute("allProducts", productService.getTopProducts(20));
        long t3 = System.nanoTime();
        model.addAttribute("reviews", reviewService.getLatestReviews());
        long t4 = System.nanoTime();

        // Flash Sale từ database
        Optional<FlashSale> currentSale = flashSaleService.getCurrentFlashSale();
        long t5 = System.nanoTime();
        if (currentSale.isPresent()) {
            FlashSale sale = currentSale.get();
            List<FlashSaleItem> saleItems = flashSaleService.getItemsBySaleId(sale.getId()).stream()
                .filter(item -> item.getSoldCount() < item.getSaleQuantity())
                .collect(Collectors.toList());
            model.addAttribute("flashSale", sale);
            model.addAttribute("flashSaleItems", saleItems);
            model.addAttribute("flashSaleEndTime", sale.getEndTime().getTime());
        } else {
            // Fallback: vẫn hiển thị sản phẩm "sắp hết" nếu không có flash sale
            model.addAttribute("flashSaleProducts", productService.getFlashSaleProducts());
            model.addAttribute("flashSaleEndTime", 0);
        }
        long t6 = System.nanoTime();

        // Voucher từ database
        model.addAttribute("activeVouchers", voucherService.getActiveVouchers());
        long t7 = System.nanoTime();

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            model.addAttribute("wishlistProductIds", wishlistService.getWishlistProductIds(auth));
        }
        long t8 = System.nanoTime();

        long totalElapsed = (t8 - totalStart) / 1_000_000;
        log.debug("[HomeController] index() perf: total={}ms | featured={}ms | flashSale={}ms | top={}ms | reviews={}ms | vouchers={}ms | wishlist={}ms",
                totalElapsed, (t1-t0)/1_000_000, (t2-t1)/1_000_000, (t3-t2)/1_000_000,
                (t4-t3)/1_000_000, (t7-t6)/1_000_000, (t8-t7)/1_000_000);

        return "index";
    }

    @GetMapping("/promotions")
    public String promotions(Model model) {
        // Flash Sale từ database
        Optional<FlashSale> currentSale = flashSaleService.getCurrentFlashSale();
        if (currentSale.isPresent()) {
            FlashSale sale = currentSale.get();
            List<FlashSaleItem> saleItems = flashSaleService.getItemsBySaleId(sale.getId()).stream()
                .filter(item -> item.getSoldCount() < item.getSaleQuantity())
                .collect(Collectors.toList());
            model.addAttribute("flashSale", sale);
            model.addAttribute("flashSaleItems", saleItems);
            model.addAttribute("flashSaleEndTime", sale.getEndTime().getTime());
        } else {
            model.addAttribute("flashSaleProducts", productService.getFlashSaleProducts());
            model.addAttribute("flashSaleEndTime", 0);
        }

        // Voucher từ database
        model.addAttribute("activeVouchers", voucherService.getActiveVouchers());
        return "promotions";
    }
}
