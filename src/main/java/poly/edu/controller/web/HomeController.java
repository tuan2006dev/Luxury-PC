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
import poly.edu.service.NewsService;
import poly.edu.dao.CategoryDAO;

import poly.edu.service.NewsCategoryService;
import poly.edu.entity.NewsCategory;
import org.springframework.data.domain.Page;

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

    final NewsService newsService;

    final NewsCategoryService newsCategoryService;

    final CategoryDAO categoryDAO;
    
    final poly.edu.dao.ReviewDAO reviewDAO;

    // hasValidImage removed for performance

    @GetMapping("/")
    public String index(Model model) {
        // Query Category IDs for Build PC banners and components
        List<poly.edu.entity.Category> categories = categoryDAO.findAll();
        Integer gamingCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("PC Gaming") || c.getName().toLowerCase().contains("gaming")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        Integer workstationCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("PC Workstation") || c.getName().toLowerCase().contains("đồ hoạ") || c.getName().toLowerCase().contains("đồ họa") || c.getName().toLowerCase().contains("workstation")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        Integer vanPhongCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("PC Văn phòng") || c.getName().toLowerCase().contains("văn phòng") || c.getName().toLowerCase().contains("office")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        Integer streamerCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("PC Streamer") || c.getName().toLowerCase().contains("streamer")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        
        Integer ramCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("RAM")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        Integer vgaCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("VGA")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        Integer caseCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("Case")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        Integer mainboardCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("Mainboard")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        Integer pcCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("PC") || c.getName().toLowerCase().contains("máy bộ")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);

        model.addAttribute("gamingCid", gamingCid);
        model.addAttribute("workstationCid", workstationCid);
        model.addAttribute("vanPhongCid", vanPhongCid);
        model.addAttribute("streamerCid", streamerCid);
        model.addAttribute("ramCid", ramCid);
        model.addAttribute("vgaCid", vgaCid);
        model.addAttribute("caseCid", caseCid);
        model.addAttribute("mainboardCid", mainboardCid);
        model.addAttribute("pcCid", pcCid);
        long totalStart = System.nanoTime();

        long t0 = System.nanoTime();
        model.addAttribute("featuredProducts", productService.getFeaturedProducts());
        long t1 = System.nanoTime();
        model.addAttribute("flashSaleProducts", productService.getFlashSaleProducts());
        long t2 = System.nanoTime();
        model.addAttribute("allProducts", productService.getTopProducts(40));
        long t3 = System.nanoTime();
        model.addAttribute("reviews", reviewService.getLatestReviews());
        long t4 = System.nanoTime();

        List<NewsCategory> activeCategories = newsCategoryService.getActiveCategories();
        record CategoryNewsGroup(NewsCategory category, List<poly.edu.dto.NewsSummaryDto> newsList, java.util.Date latestDate) {}
        List<CategoryNewsGroup> groups = new java.util.ArrayList<>();
        
        for (NewsCategory cat : activeCategories) {
            Page<poly.edu.dto.NewsSummaryDto> newsPage = newsService.getPublishedNews(0, 3, null, cat.getId());
            List<poly.edu.dto.NewsSummaryDto> content = newsPage.getContent();
            if (!content.isEmpty()) {
                java.util.Date latestDate = content.get(0).getCreatedAt();
                groups.add(new CategoryNewsGroup(cat, content, latestDate));
            }
        }
        
        // Sort groups by latestDate desc
        groups.sort((g1, g2) -> g2.latestDate().compareTo(g1.latestDate()));
        
        if (groups.size() >= 1) {
            model.addAttribute("leftCategory", groups.get(0).category());
            model.addAttribute("leftNews", groups.get(0).newsList());
        } else {
            model.addAttribute("leftCategory", null);
            model.addAttribute("leftNews", java.util.Collections.emptyList());
        }
        
        if (groups.size() >= 2) {
            model.addAttribute("rightCategory", groups.get(1).category());
            model.addAttribute("rightNews", groups.get(1).newsList());
        } else {
            model.addAttribute("rightCategory", null);
            model.addAttribute("rightNews", java.util.Collections.emptyList());
        }

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
                .sorted((item1, item2) -> {
                    List<poly.edu.entity.Review> rev1 = reviewDAO.findByProductIdOrderByCreatedAtDesc(item1.getProduct().getId());
                    double r1 = rev1.stream().mapToInt(poly.edu.entity.Review::getStars).average().orElse(0.0);
                    
                    List<poly.edu.entity.Review> rev2 = reviewDAO.findByProductIdOrderByCreatedAtDesc(item2.getProduct().getId());
                    double r2 = rev2.stream().mapToInt(poly.edu.entity.Review::getStars).average().orElse(0.0);
                    
                    if (Double.compare(r2, r1) != 0) {
                        return Double.compare(r2, r1);
                    }
                    
                    int sold1 = item1.getSoldCount() != null ? item1.getSoldCount() : 0;
                    int sold2 = item2.getSoldCount() != null ? item2.getSoldCount() : 0;
                    return Integer.compare(sold2, sold1);
                })
                .collect(Collectors.toList());

            // Build rating and review counts maps
            java.util.Map<Integer, Double> productRatings = new java.util.HashMap<>();
            java.util.Map<Integer, Integer> productReviewCounts = new java.util.HashMap<>();
            for (FlashSaleItem item : saleItems) {
                List<poly.edu.entity.Review> revs = reviewDAO.findByProductIdOrderByCreatedAtDesc(item.getProduct().getId());
                double avg = revs.stream().mapToInt(poly.edu.entity.Review::getStars).average().orElse(0.0);
                productRatings.put(item.getProduct().getId(), avg);
                productReviewCounts.put(item.getProduct().getId(), revs.size());
            }

            model.addAttribute("flashSale", sale);
            model.addAttribute("flashSaleItems", saleItems);
            model.addAttribute("productRatings", productRatings);
            model.addAttribute("productReviewCounts", productReviewCounts);
            model.addAttribute("flashSaleEndTime", sale.getEndTime().getTime());
        } else {
            model.addAttribute("flashSaleProducts", productService.getFlashSaleProducts().stream().limit(5).collect(Collectors.toList()));
            model.addAttribute("flashSaleEndTime", 0);
        }

        // Lấy Flash Sale sắp diễn ra tiếp theo
        List<FlashSale> upcomingSales = flashSaleService.getUpcomingFlashSales();
        if (upcomingSales != null && !upcomingSales.isEmpty()) {
            FlashSale nextSale = upcomingSales.get(0);
            List<FlashSaleItem> upcomingItems = flashSaleService.getItemsBySaleId(nextSale.getId());
            model.addAttribute("upcomingSale", nextSale);
            model.addAttribute("upcomingItems", upcomingItems);
            model.addAttribute("upcomingStartTime", nextSale.getStartTime().getTime());
        }

        // Category từ database
        model.addAttribute("categories", categoryDAO.findAll());

        // Voucher từ database
        model.addAttribute("activeVouchers", voucherService.getActiveVouchers());
        return "promotions";
    }
}
