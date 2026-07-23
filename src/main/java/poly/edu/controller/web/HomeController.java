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
import poly.edu.service.ProfileService;
import poly.edu.service.BrandService;
import poly.edu.service.CategoryService;
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

    final CategoryService categoryService;
    
    final poly.edu.dao.ReviewDAO reviewDAO;

    final ProfileService profileService;

    final poly.edu.dao.UserVoucherDAO userVoucherDAO;

    final BrandService brandService;

    // hasValidImage removed for performance

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("brands", brandService.getAllBrands());

        // Query Category IDs for Build PC banners and components
        List<poly.edu.entity.Category> categories = categoryService.getAllCategories();
        Integer gamingCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("PC Gaming") || c.getName().toLowerCase().contains("gaming")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        Integer workstationCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("PC Workstation") || c.getName().toLowerCase().contains("đồ hoạ") || c.getName().toLowerCase().contains("đồ họa") || c.getName().toLowerCase().contains("workstation")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        Integer vanPhongCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("PC Văn phòng") || c.getName().toLowerCase().contains("văn phòng") || c.getName().toLowerCase().contains("office")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        Integer streamerCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("PC Streamer") || c.getName().toLowerCase().contains("streamer")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        
        Integer ramCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("RAM")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        Integer vgaCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("VGA")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        Integer caseCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("Case")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        Integer mainboardCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("Mainboard")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);
        Integer pcCid = categories.stream().filter(c -> c.getName().equalsIgnoreCase("PC") || c.getName().toLowerCase().contains("máy bộ")).map(poly.edu.entity.Category::getId).findFirst().orElse(null);

        model.addAttribute("categories", categories);
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

        // Tin tức ở trang chủ: 2 mục "Tin tức mới nhất" và "Tin tức nổi bật"
        List<poly.edu.dto.NewsSummaryDto> newestNews = newsService.getTop5LatestNews();
        List<poly.edu.dto.NewsSummaryDto> featuredNews = newsService.getTop5MostViewedNews();

        model.addAttribute("newestNews", newestNews);
        model.addAttribute("featuredNews", featuredNews);

        // Flash Sale từ database
        Optional<FlashSale> currentSale = flashSaleService.getCurrentFlashSale();
        if (currentSale.isPresent()) {
            FlashSale sale = currentSale.get();
            List<FlashSaleItem> saleItems = flashSaleService.getItemsBySaleId(sale.getId()).stream()
                .filter(item -> item.getSoldCount() < item.getSaleQuantity())
                .collect(Collectors.toList());
            if (!saleItems.isEmpty()) {
                model.addAttribute("flashSale", sale);
                model.addAttribute("flashSaleItems", saleItems);
                model.addAttribute("flashSaleEndTime", sale.getEndTime().getTime());
            } else {
                model.addAttribute("fallbackFlashSaleProducts", productService.getFlashSaleProducts());
                model.addAttribute("flashSaleEndTime", 0);
            }
        } else {
            // Fallback: vẫn hiển thị sản phẩm "sắp hết" nếu không có flash sale
            model.addAttribute("fallbackFlashSaleProducts", productService.getFlashSaleProducts());
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
    public String promotions(Model model, Authentication authentication) {
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

        // Lấy danh sách các Flash Sale sắp diễn ra
        List<FlashSale> upcomingSales = flashSaleService.getUpcomingFlashSales();
        if (upcomingSales != null && !upcomingSales.isEmpty()) {
            // Lấy 4 đợt gần nhất cho sidebar
            List<FlashSale> top4UpcomingSales = upcomingSales.stream().limit(4).collect(Collectors.toList());
            model.addAttribute("top4UpcomingSales", top4UpcomingSales);
            model.addAttribute("allUpcomingSales", upcomingSales);
            
            // Map items cho mỗi đợt
            java.util.Map<Integer, List<FlashSaleItem>> upcomingItemsMap = new java.util.HashMap<>();
            for (FlashSale sale : upcomingSales) {
                upcomingItemsMap.put(sale.getId(), flashSaleService.getItemsBySaleId(sale.getId()));
            }
            model.addAttribute("upcomingItemsMap", upcomingItemsMap);
        }

        // Tạo danh sách Flash Sales cho Hero Banner Slider & Main Section
        List<FlashSale> sliderSales = new java.util.ArrayList<>();
        List<FlashSale> currentActiveSales = flashSaleService.getCurrentActiveSales();
        if (currentActiveSales != null) {
            sliderSales.addAll(currentActiveSales);
        }
        if (upcomingSales != null) {
            sliderSales.addAll(upcomingSales);
        }
        // Giới hạn chỉ hiển thị tối đa 5 banner gần nhất
        if (sliderSales.size() > 5) {
            sliderSales = sliderSales.subList(0, 5);
        }
        model.addAttribute("sliderSales", sliderSales);

        // Map items cho tất cả sliderSales
        java.util.Map<Integer, List<FlashSaleItem>> sliderItemsMap = new java.util.HashMap<>();
        for (FlashSale s : sliderSales) {
            List<FlashSaleItem> items = flashSaleService.getItemsBySaleId(s.getId()).stream()
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
            sliderItemsMap.put(s.getId(), items);
            
            // Build ratings & review counts if not already present
            if (!model.containsAttribute("productRatings")) {
                model.addAttribute("productRatings", new java.util.HashMap<Integer, Double>());
                model.addAttribute("productReviewCounts", new java.util.HashMap<Integer, Integer>());
            }
            java.util.Map<Integer, Double> pRatings = (java.util.Map<Integer, Double>) model.getAttribute("productRatings");
            java.util.Map<Integer, Integer> pReviewCounts = (java.util.Map<Integer, Integer>) model.getAttribute("productReviewCounts");
            for (FlashSaleItem item : items) {
                if (!pRatings.containsKey(item.getProduct().getId())) {
                    List<poly.edu.entity.Review> revs = reviewDAO.findByProductIdOrderByCreatedAtDesc(item.getProduct().getId());
                    double avg = revs.stream().mapToInt(poly.edu.entity.Review::getStars).average().orElse(0.0);
                    pRatings.put(item.getProduct().getId(), avg);
                    pReviewCounts.put(item.getProduct().getId(), revs.size());
                }
            }
        }
        model.addAttribute("sliderItemsMap", sliderItemsMap);

        // Category từ database
        model.addAttribute("categories", categoryService.getAllCategories());

        // Voucher từ database
        List<poly.edu.entity.Voucher> allVouchers = voucherService.getActiveVouchers();
        
        if (authentication != null && authentication.isAuthenticated()) {
            poly.edu.entity.User user = profileService.getCurrentUser(authentication);
            if (user != null) {
                List<poly.edu.entity.UserVoucher> savedVouchers = userVoucherDAO.findByUserOrderBySavedAtDesc(user);
                List<String> savedCodes = savedVouchers.stream()
                        .map(uv -> uv.getVoucher().getCode())
                        .collect(Collectors.toList());
                
                allVouchers = allVouchers.stream()
                        .filter(v -> !savedCodes.contains(v.getCode()))
                        .collect(Collectors.toList());
            }
        }
        
        model.addAttribute("activeVouchers", allVouchers);
        return "promotions";
    }
}
