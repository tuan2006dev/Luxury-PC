package poly.edu.controller.web;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import poly.edu.entity.Product;
import poly.edu.entity.Review;
import poly.edu.entity.User;
import poly.edu.entity.FlashSale;
import poly.edu.entity.FlashSaleItem;
import poly.edu.service.BrandService;
import poly.edu.service.CategoryService;
import poly.edu.service.ProductService;
import poly.edu.service.WishlistService;
import poly.edu.service.FlashSaleService;
import poly.edu.dao.ReviewDAO;
import poly.edu.dao.FlashSaleItemDAO;
import poly.edu.repository.UserRepository;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Controller
@RequiredArgsConstructor
public class ProductPageController {

    private static final Logger log = LoggerFactory.getLogger(ProductPageController.class);

    final ProductService productService;

    final CategoryService categoryService;

    final BrandService brandService;

    final ReviewDAO reviewDAO;

    final UserRepository userRepository;

    final poly.edu.dao.OrderItemDAO orderItemDAO;

    final WishlistService wishlistService;

    final FlashSaleService flashSaleService;

    final FlashSaleItemDAO flashSaleItemDAO;

    // hasValidImage removed for performance

    @GetMapping("/products")
    public String showProductsPage(
            Model model,
            @RequestParam(name = "cid", required = false) Integer cid,
            @RequestParam(name = "min", required = false) Double min,
            @RequestParam(name = "max", required = false) Double max,
            @RequestParam(name = "kw", required = false) String kw,
            @RequestParam(name = "brand", required = false) String brand,
            @RequestParam(name = "sort", required = false, defaultValue = "newest") String sort,
            @RequestParam(name = "page", required = false, defaultValue = "1") Integer page,
            @RequestParam(name = "flashSale", required = false) Boolean flashSale) {
        if (kw != null && kw.trim().isEmpty())
            kw = null;
        if (brand != null && brand.trim().isEmpty())
            brand = null;

        if (min != null) {
            if (min < 0.0)
                min = 0.0;
            if (min > 100000000.0)
                min = 100000000.0;
        }
        if (max != null) {
            if (max < 0.0)
                max = 0.0;
            if (max > 100000000.0)
                max = 100000000.0;
        }
        if (min != null && max != null && min > max) {
            Double temp = min;
            min = max;
            max = temp;
        }

        // Lấy danh sách tất cả sản phẩm Flash Sale đang diễn ra
        java.util.Map<Integer, FlashSaleItem> flashSaleMap = new java.util.HashMap<>();
        List<FlashSale> activeSales = flashSaleService.getCurrentActiveSales();
        if (activeSales != null) {
            for (FlashSale sale : activeSales) {
                List<FlashSaleItem> items = flashSaleService.getItemsBySaleId(sale.getId());
                if (items != null) {
                    for (FlashSaleItem item : items) {
                        if (item.getProduct() != null && item.getSoldCount() < item.getSaleQuantity()) {
                            flashSaleMap.put(item.getProduct().getId(), item);
                        }
                    }
                }
            }
        }
        model.addAttribute("flashSaleMap", flashSaleMap);

        // Sorting
        org.springframework.data.domain.Sort sortObj = org.springframework.data.domain.Sort
                .by(org.springframework.data.domain.Sort.Direction.DESC, "id");
        if ("price_asc".equalsIgnoreCase(sort)) {
            sortObj = org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.ASC,
                    "price");
        } else if ("price_desc".equalsIgnoreCase(sort)) {
            sortObj = org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC,
                    "price");
        } else if ("name_asc".equalsIgnoreCase(sort)) {
            sortObj = org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.ASC,
                    "name");
        } else if ("name_desc".equalsIgnoreCase(sort)) {
            sortObj = org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC,
                    "name");
        }

        int pageSize = 100;
        int currentPage = (page != null && page > 0) ? page : 1;
        int pageIndex = currentPage - 1;

        List<Product> products;
        int totalPages;
        long totalProducts;

        if (Boolean.TRUE.equals(flashSale)) {
            org.springframework.data.domain.Pageable unpaged = org.springframework.data.domain.PageRequest.of(0, 10000,
                    sortObj);
            List<Product> allMatches = productService.searchProductsPage(cid, min, max, kw, brand, unpaged)
                    .getContent();
            List<Product> filtered = allMatches.stream()
                    .filter(p -> p != null && flashSaleMap.containsKey(p.getId()))
                    .collect(java.util.stream.Collectors.toList());

            totalProducts = filtered.size();
            totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            if (totalPages < 1)
                totalPages = 1;

            int fromIndex = pageIndex * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, (int) totalProducts);
            if (fromIndex <= totalProducts && fromIndex < toIndex) {
                products = filtered.subList(fromIndex, toIndex);
            } else {
                products = java.util.Collections.emptyList();
            }
        } else {
            org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest
                    .of(pageIndex, pageSize, sortObj);
            org.springframework.data.domain.Page<Product> productPage = productService.searchProductsPage(cid, min, max,
                    kw, brand, pageable);
            products = productPage.getContent();
            totalPages = productPage.getTotalPages();
            totalProducts = productPage.getTotalElements();
            if (totalPages < 1)
                totalPages = 1;
        }

        model.addAttribute("allProducts", products);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalProducts", totalProducts);
        model.addAttribute("selectedSort", sort);

        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("brands", brandService.getAllBrands());

        // Gửi lại các tham số lọc để giữ trạng thái trên UI
        model.addAttribute("selectedCid", cid);
        model.addAttribute("minPrice", min);
        model.addAttribute("maxPrice", max);
        model.addAttribute("keywords", kw);
        model.addAttribute("selectedBrand", brand);
        model.addAttribute("isFlashSale", flashSale);
        addWishlistAttributes(model);

        return "all-products";
    }

    @GetMapping("/product/{id}")
    public String showProductDetail(@PathVariable("id") Integer id, Model model, Authentication authentication) {
        Product p = productService.getProductById(id);
        if (p == null) {
            return "redirect:/products";
        }

        boolean isAdminOrStaff = false;
        if (authentication != null && authentication.isAuthenticated()) {
            isAdminOrStaff = authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().contains("ADMIN") || a.getAuthority().contains("STAFF"));
        }

        List<Review> reviews = reviewDAO.findByProductIdOrderByCreatedAtDesc(id);
        double avgRating = reviews.stream()
                .map(Review::getStars)
                .filter(java.util.Objects::nonNull)
                .mapToInt(Integer::intValue)
                .average()
                .orElse(0.0);

        long count5 = reviews.stream().filter(r -> r.getStars() != null && r.getStars() == 5).count();
        long count4 = reviews.stream().filter(r -> r.getStars() != null && r.getStars() == 4).count();
        long count3 = reviews.stream().filter(r -> r.getStars() != null && r.getStars() == 3).count();
        long count2 = reviews.stream().filter(r -> r.getStars() != null && r.getStars() == 2).count();
        long count1 = reviews.stream().filter(r -> r.getStars() != null && r.getStars() == 1).count();

        model.addAttribute("product", p);
        model.addAttribute("reviews", reviews);
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("reviewCount", reviews.size());
        model.addAttribute("count5", count5);
        model.addAttribute("count4", count4);
        model.addAttribute("count3", count3);
        model.addAttribute("count2", count2);
        model.addAttribute("count1", count1);
        model.addAttribute("isAdminOrStaff", isAdminOrStaff);

        java.util.Map<String, String> parsedSpecs = new java.util.LinkedHashMap<>();
        java.util.List<String> otherDescLines = new java.util.ArrayList<>();
        if (p.getDescription() != null && !p.getDescription().isEmpty()) {
            String[] lines = p.getDescription().replaceAll("<[^>]*>", "").split("\\r?\\n");
            for (String line : lines) {
                line = line.trim();
                if (line.isEmpty())
                    continue;
                if (line.contains(":")) {
                    String[] parts = line.split(":", 2);
                    parsedSpecs.put(parts[0].trim(), parts[1].trim());
                } else if (line.contains(" - ")) {
                    String[] parts = line.split(" - ", 2);
                    parsedSpecs.put(parts[0].trim(), parts[1].trim());
                } else {
                    otherDescLines.add(line);
                }
            }
        }
        if (parsedSpecs.isEmpty() && !otherDescLines.isEmpty()) {
            parsedSpecs.put("Đặc điểm", String.join(", ", otherDescLines));
            otherDescLines.clear();
        }
        model.addAttribute("parsedSpecs", parsedSpecs);
        model.addAttribute("otherDescLines", otherDescLines);

        // Flash Sale item
        java.util.Optional<poly.edu.entity.FlashSaleItem> fsiOpt = flashSaleService.getActiveFlashSaleItem(id);
        fsiOpt.ifPresent(fsi -> model.addAttribute("flashSaleItem", fsi));

        // Related Products
        if (p.getCategory() != null) {
            List<Product> related = productService.getProductsByCategory(p.getCategory().getId());
            related.removeIf(prod -> prod.getId().equals(id));
            model.addAttribute("relatedProducts", related);
        }

        addWishlistAttributes(model);
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        model.addAttribute("productInWishlist", wishlistService.isProductInWishlist(auth, id));

        User currentUser = null;
        boolean isAdmin = false;
        if (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) {
            Object principal = auth.getPrincipal();
            String emailOrUsername = "";
            if (principal instanceof org.springframework.security.oauth2.core.user.OAuth2User oauthUser) {
                emailOrUsername = (String) oauthUser.getAttributes().get("email");
            } else if (principal instanceof org.springframework.security.core.userdetails.User u) {
                emailOrUsername = u.getUsername();
            } else {
                emailOrUsername = auth.getName();
            }
            Optional<User> uOpt = userRepository.findByEmail(emailOrUsername);
            if (uOpt.isEmpty())
                uOpt = userRepository.findByUsername(emailOrUsername);
            if (uOpt.isPresent()) {
                currentUser = uOpt.get();
                if (currentUser.getUserRoles() != null) {
                    isAdmin = currentUser.getUserRoles().stream()
                            .anyMatch(ur -> ur.getRole() != null && "ADMIN".equalsIgnoreCase(ur.getRole().getName()));
                }
            }
            if (!isAdmin) {
                isAdmin = auth.getAuthorities().stream()
                        .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ADMIN"));
            }
        }
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("isAdmin", isAdmin);

        boolean canReview = false;
        if (currentUser != null) {
            long count = orderItemDAO.countCompletedPurchasesByUserAndProduct(currentUser.getId(), id);
            if (count > 0) {
                canReview = true;
            }
        }
        model.addAttribute("canReview", canReview);

        return "product-detail";
    }

    private void addWishlistAttributes(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Set<Integer> wishlistProductIds = auth != null
                ? wishlistService.getWishlistProductIds(auth)
                : Collections.emptySet();
        model.addAttribute("wishlistProductIds", wishlistProductIds);
    }

    @PostMapping("/product/{id}/review")
    @org.springframework.web.bind.annotation.ResponseBody
    public org.springframework.http.ResponseEntity<java.util.Map<String, Object>> addReview(
            @PathVariable("id") Integer id,
            @RequestParam(value = "orderItemId", required = false) Integer orderItemId,
            @RequestParam("stars") Integer stars,
            @RequestParam("content") String content,
            @RequestParam(value = "imageFile", required = false) org.springframework.web.multipart.MultipartFile imageFile,
            @RequestParam(value = "videoFile", required = false) org.springframework.web.multipart.MultipartFile videoFile,
            @org.springframework.security.core.annotation.AuthenticationPrincipal Object principal) {

        java.util.Map<String, Object> response = new java.util.HashMap<>();

        if (principal == null) {
            response.put("success", false);
            response.put("message", "Vui lòng đăng nhập để gửi đánh giá.");
            return org.springframework.http.ResponseEntity.status(401).body(response);
        }

        // 1. Kiểm tra giới hạn 1000 từ
        String cleanContent = content != null ? content.trim() : "";
        String[] words = cleanContent.split("\\s+");
        int wordCount = (cleanContent.isEmpty()) ? 0 : words.length;
        if (wordCount > 1000) {
            response.put("success", false);
            response.put("message", "Nội dung đánh giá vượt quá giới hạn 1000 từ (Hiện tại: " + wordCount + " từ).");
            return org.springframework.http.ResponseEntity.status(400).body(response);
        }

        String emailOrUsername = "";
        if (principal instanceof org.springframework.security.oauth2.core.user.OAuth2User oauthUser) {
            emailOrUsername = (String) oauthUser.getAttributes().get("email");
        } else if (principal instanceof org.springframework.security.core.userdetails.User u) {
            emailOrUsername = u.getUsername();
        }

        Optional<User> uOpt = userRepository.findByEmail(emailOrUsername);
        if (uOpt.isEmpty())
            uOpt = userRepository.findByUsername(emailOrUsername);

        if (uOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "Không tìm thấy người dùng.");
            return org.springframework.http.ResponseEntity.status(404).body(response);
        }

        Product p = productService.getProductById(id);
        if (p == null) {
            response.put("success", false);
            response.put("message", "Sản phẩm không tồn tại.");
            return org.springframework.http.ResponseEntity.status(404).body(response);
        }

        // Kiem tra quyen danh gia
        poly.edu.entity.OrderItem targetOrderItem = null;
        if (orderItemId != null) {
            Optional<poly.edu.entity.OrderItem> oiOpt = orderItemDAO.findById(orderItemId);
            if (oiOpt.isEmpty()) {
                response.put("success", false);
                response.put("message", "Không tìm thấy chi tiết đơn hàng.");
                return org.springframework.http.ResponseEntity.status(404).body(response);
            }
            targetOrderItem = oiOpt.get();
            if (targetOrderItem.getOrder() == null || targetOrderItem.getOrder().getUser() == null ||
                    !targetOrderItem.getOrder().getUser().getId().equals(uOpt.get().getId())) {
                response.put("success", false);
                response.put("message", "Lượt mua này không thuộc về tài khoản của bạn.");
                return org.springframework.http.ResponseEntity.status(403).body(response);
            }
            String st = targetOrderItem.getOrder().getStatus();
            if (!"COMPLETED".equalsIgnoreCase(st) && !"HOAN_THANH".equalsIgnoreCase(st)) {
                response.put("success", false);
                response.put("message", "Đơn hàng phải ở trạng thái hoàn thành để đánh giá.");
                return org.springframework.http.ResponseEntity.status(403).body(response);
            }
            if (reviewDAO.existsByOrderItem_Id(orderItemId)) {
                response.put("success", false);
                response.put("message", "Lần mua hàng này đã được đánh giá rồi.");
                return org.springframework.http.ResponseEntity.status(400).body(response);
            }
        } else {
            java.util.List<poly.edu.entity.OrderItem> userItems = orderItemDAO
                    .findCompletedOrderItemsByUserAndProduct(uOpt.get().getId(), id);
            if (userItems == null || userItems.isEmpty()) {
                response.put("success", false);
                response.put("message",
                        "Bạn cần mua sản phẩm này và đơn hàng phải được giao thành công để có thể đánh giá.");
                return org.springframework.http.ResponseEntity.status(403).body(response);
            }

            for (poly.edu.entity.OrderItem oi : userItems) {
                if (!reviewDAO.existsByOrderItem_Id(oi.getId())) {
                    targetOrderItem = oi;
                    break;
                }
            }

            if (targetOrderItem == null) {
                response.put("success", false);
                response.put("message", "Tất cả các lượt mua sản phẩm này của bạn đều đã được đánh giá rồi.");
                return org.springframework.http.ResponseEntity.status(400).body(response);
            }
        }

        Review r = new Review();
        r.setUser(uOpt.get());
        r.setProduct(p);
        r.setOrderItem(targetOrderItem);
        r.setStars(stars);
        r.setContent(cleanContent);

        // 2. Xử lý upload hình ảnh
        if (imageFile != null && !imageFile.isEmpty()) {
            String contentType = imageFile.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                response.put("success", false);
                response.put("message", "Chỉ chấp nhận file ảnh.");
                return org.springframework.http.ResponseEntity.status(400).body(response);
            }
            try {
                String originalFilename = imageFile.getOriginalFilename();
                String extension = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String filename = "review_" + p.getId() + "_" + uOpt.get().getId() + "_" + System.currentTimeMillis()
                        + extension;

                // Lưu vào src/main/resources
                String srcUploadDir = "src/main/resources/static/uploads/reviews/";
                java.io.File srcFolder = new java.io.File(srcUploadDir);
                if (!srcFolder.exists()) {
                    srcFolder.mkdirs();
                }
                java.nio.file.Path srcPath = java.nio.file.Paths.get(srcUploadDir + filename);
                java.nio.file.Files.copy(imageFile.getInputStream(), srcPath,
                        java.nio.file.StandardCopyOption.REPLACE_EXISTING);

                // Copy sang target cho phép hiển thị ngay lập tức
                String targetUploadDir = "target/classes/static/uploads/reviews/";
                java.io.File targetFolder = new java.io.File(targetUploadDir);
                if (targetFolder.exists() || targetFolder.mkdirs()) {
                    java.nio.file.Path targetPath = java.nio.file.Paths.get(targetUploadDir + filename);
                    try {
                        java.nio.file.Files.copy(srcPath, targetPath,
                                java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    } catch (Exception e) {
                        // Bỏ qua lỗi copy sang target
                    }
                }

                r.setImage("/uploads/reviews/" + filename);
            } catch (Exception e) {
                log.error("[ProductPage] Unexpected error", e);
                response.put("success", false);
                response.put("message", "Lỗi khi lưu trữ hình ảnh: " + e.getMessage());
                return org.springframework.http.ResponseEntity.status(500).body(response);
            }
        }

        // Xy ly upload video
        if (videoFile != null && !videoFile.isEmpty()) {
            String contentType = videoFile.getContentType();
            if (contentType == null || !contentType.startsWith("video/")) {
                response.put("success", false);
                response.put("message", "Chỉ chấp nhận file video.");
                return org.springframework.http.ResponseEntity.status(400).body(response);
            }
            try {
                String originalFilename = videoFile.getOriginalFilename();
                String extension = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String filename = "review_vid_" + p.getId() + "_" + uOpt.get().getId() + "_"
                        + System.currentTimeMillis() + extension;

                // Lưu vào src/main/resources
                String srcUploadDir = "src/main/resources/static/uploads/reviews/";
                java.io.File srcFolder = new java.io.File(srcUploadDir);
                if (!srcFolder.exists()) {
                    srcFolder.mkdirs();
                }
                java.nio.file.Path srcPath = java.nio.file.Paths.get(srcUploadDir + filename);
                java.nio.file.Files.copy(videoFile.getInputStream(), srcPath,
                        java.nio.file.StandardCopyOption.REPLACE_EXISTING);

                // Copy sang target cho phép hiển thị ngay lập tức
                String targetUploadDir = "target/classes/static/uploads/reviews/";
                java.io.File targetFolder = new java.io.File(targetUploadDir);
                if (targetFolder.exists() || targetFolder.mkdirs()) {
                    java.nio.file.Path targetPath = java.nio.file.Paths.get(targetUploadDir + filename);
                    try {
                        java.nio.file.Files.copy(srcPath, targetPath,
                                java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    } catch (Exception e) {
                        // Bỏ qua lỗi copy sang target
                    }
                }

                r.setVideo("/uploads/reviews/" + filename);
            } catch (Exception e) {
                log.error("[ProductPage] Unexpected error", e);
                response.put("success", false);
                response.put("message", "Lỗi khi lưu trữ video: " + e.getMessage());
                return org.springframework.http.ResponseEntity.status(500).body(response);
            }
        }

        reviewDAO.save(r);

        // 3. Tính toán lại rating trung bình và số lượng đánh giá mới để cập nhật UI
        List<Review> reviews = reviewDAO.findByProductIdOrderByCreatedAtDesc(id);
        double avgRating = reviews.stream()
                .map(Review::getStars)
                .filter(java.util.Objects::nonNull)
                .mapToInt(Integer::intValue)
                .average()
                .orElse(0.0);

        // Chuẩn bị dữ liệu phản hồi
        java.util.Map<String, Object> reviewData = new java.util.HashMap<>();
        reviewData.put("id", r.getId());
        reviewData.put("content", r.getContent());
        reviewData.put("stars", r.getStars());
        reviewData.put("image", r.getImage());
        reviewData.put("userName", uOpt.get().getFullName() != null && !uOpt.get().getFullName().isEmpty()
                ? uOpt.get().getFullName()
                : uOpt.get().getUsername());
        reviewData.put("createdAt",
                r.getCreatedAt().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));

        long c5 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 5).count();
        long c4 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 4).count();
        long c3 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 3).count();
        long c2 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 2).count();
        long c1 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 1).count();

        response.put("success", true);
        response.put("message", "Đăng đánh giá thành công.");
        response.put("review", reviewData);
        response.put("avgRating", avgRating);
        response.put("reviewCount", reviews.size());
        response.put("count5", c5);
        response.put("count4", c4);
        response.put("count3", c3);
        response.put("count2", c2);
        response.put("count1", c1);

        return org.springframework.http.ResponseEntity.ok(response);
    }

    @PostMapping("/product/review/{id}/delete")
    @org.springframework.web.bind.annotation.ResponseBody
    public org.springframework.http.ResponseEntity<java.util.Map<String, Object>> deleteReview(
            @PathVariable("id") Integer id,
            @org.springframework.security.core.annotation.AuthenticationPrincipal Object principal) {

        java.util.Map<String, Object> response = new java.util.HashMap<>();

        if (principal == null) {
            response.put("success", false);
            response.put("message", "Vui lòng đăng nhập để thực hiện.");
            return org.springframework.http.ResponseEntity.status(401).body(response);
        }

        String emailOrUsername = "";
        if (principal instanceof org.springframework.security.oauth2.core.user.OAuth2User oauthUser) {
            emailOrUsername = (String) oauthUser.getAttributes().get("email");
        } else if (principal instanceof org.springframework.security.core.userdetails.User u) {
            emailOrUsername = u.getUsername();
        }

        Optional<User> uOpt = userRepository.findByEmail(emailOrUsername);
        if (uOpt.isEmpty())
            uOpt = userRepository.findByUsername(emailOrUsername);

        if (uOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "Không tìm thấy người dùng.");
            return org.springframework.http.ResponseEntity.status(404).body(response);
        }

        Optional<Review> rOpt = reviewDAO.findById(id);
        if (rOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "Đánh giá không tồn tại.");
            return org.springframework.http.ResponseEntity.status(404).body(response);
        }

        Review r = rOpt.get();
        User currentUser = uOpt.get();

        // Kiểm tra quyền Admin
        boolean isAdmin = false;
        Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext()
                .getAuthentication();
        if (auth != null) {
            isAdmin = auth.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ADMIN"));
        }
        if (!isAdmin && currentUser.getUserRoles() != null) {
            isAdmin = currentUser.getUserRoles().stream()
                    .anyMatch(ur -> ur.getRole() != null && "ADMIN".equalsIgnoreCase(ur.getRole().getName()));
        }

        if (!isAdmin) {
            response.put("success", false);
            response.put("message", "Chỉ quản trị viên mới có quyền xóa đánh giá.");
            return org.springframework.http.ResponseEntity.status(403).body(response);
        }

        Integer productId = r.getProduct().getId();

        // Xóa hình ảnh thực tế nếu có
        if (r.getImage() != null && !r.getImage().isEmpty()) {
            try {
                String imagePath = r.getImage();
                java.io.File fileInSrc = new java.io.File("src/main/resources/static" + imagePath);
                if (fileInSrc.exists()) {
                    fileInSrc.delete();
                }
                java.io.File fileInTarget = new java.io.File("target/classes/static" + imagePath);
                if (fileInTarget.exists()) {
                    fileInTarget.delete();
                }
            } catch (Exception e) {
                log.error("[ProductPage] Unexpected error", e);
            }
        }

        // Xóa video thực tế nếu có
        if (r.getVideo() != null && !r.getVideo().isEmpty()) {
            try {
                String videoPath = r.getVideo();
                java.io.File fileInSrc = new java.io.File("src/main/resources/static" + videoPath);
                if (fileInSrc.exists()) {
                    fileInSrc.delete();
                }
                java.io.File fileInTarget = new java.io.File("target/classes/static" + videoPath);
                if (fileInTarget.exists()) {
                    fileInTarget.delete();
                }
            } catch (Exception e) {
                log.error("[ProductPage] Unexpected error", e);
            }
        }

        reviewDAO.delete(r);

        // Tính toán lại rating trung bình và số lượng đánh giá mới
        List<Review> reviews = reviewDAO.findByProductIdOrderByCreatedAtDesc(productId);
        double avgRating = reviews.stream()
                .map(Review::getStars)
                .filter(java.util.Objects::nonNull)
                .mapToInt(Integer::intValue)
                .average()
                .orElse(0.0);

        long c5 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 5).count();
        long c4 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 4).count();
        long c3 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 3).count();
        long c2 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 2).count();
        long c1 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 1).count();

        response.put("success", true);
        response.put("message", "Xóa đánh giá thành công.");
        response.put("avgRating", avgRating);
        response.put("reviewCount", reviews.size());
        response.put("count5", c5);
        response.put("count4", c4);
        response.put("count3", c3);
        response.put("count2", c2);
        response.put("count1", c1);

        return org.springframework.http.ResponseEntity.ok(response);
    }

    @PostMapping("/product/review/{id}/edit")
    @org.springframework.web.bind.annotation.ResponseBody
    public org.springframework.http.ResponseEntity<java.util.Map<String, Object>> editReview(
            @PathVariable("id") Integer id,
            @RequestParam("stars") Integer stars,
            @RequestParam("content") String content,
            @RequestParam(value = "imageFile", required = false) org.springframework.web.multipart.MultipartFile imageFile,
            @RequestParam(value = "removeImage", required = false) Boolean removeImage,
            @RequestParam(value = "videoFile", required = false) org.springframework.web.multipart.MultipartFile videoFile,
            @RequestParam(value = "removeVideo", required = false) Boolean removeVideo,
            @org.springframework.security.core.annotation.AuthenticationPrincipal Object principal) {

        java.util.Map<String, Object> response = new java.util.HashMap<>();

        if (principal == null) {
            response.put("success", false);
            response.put("message", "Vui lòng đăng nhập để thực hiện.");
            return org.springframework.http.ResponseEntity.status(401).body(response);
        }

        String emailOrUsername = "";
        if (principal instanceof org.springframework.security.oauth2.core.user.OAuth2User oauthUser) {
            emailOrUsername = (String) oauthUser.getAttributes().get("email");
        } else if (principal instanceof org.springframework.security.core.userdetails.User u) {
            emailOrUsername = u.getUsername();
        }

        Optional<User> uOpt = userRepository.findByEmail(emailOrUsername);
        if (uOpt.isEmpty())
            uOpt = userRepository.findByUsername(emailOrUsername);

        if (uOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "Không tìm thấy người dùng.");
            return org.springframework.http.ResponseEntity.status(404).body(response);
        }

        Optional<Review> rOpt = reviewDAO.findById(id);
        if (rOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "Đánh giá không tồn tại.");
            return org.springframework.http.ResponseEntity.status(404).body(response);
        }

        Review r = rOpt.get();
        User currentUser = uOpt.get();

        // Chỉ chủ sở hữu mới có quyền sửa
        if (!r.getUser().getId().equals(currentUser.getId())) {
            response.put("success", false);
            response.put("message", "Bạn không có quyền sửa đánh giá này.");
            return org.springframework.http.ResponseEntity.status(403).body(response);
        }

        // Kiểm tra giới hạn 1000 từ
        String cleanContent = content != null ? content.trim() : "";
        String[] words = cleanContent.split("\\s+");
        int wordCount = (cleanContent.isEmpty()) ? 0 : words.length;
        if (wordCount > 1000) {
            response.put("success", false);
            response.put("message", "Nội dung đánh giá vượt quá giới hạn 1000 từ (Hiện tại: " + wordCount + " từ).");
            return org.springframework.http.ResponseEntity.status(400).body(response);
        }

        r.setStars(stars);
        r.setContent(cleanContent);

        // Xử lý xóa ảnh nếu được yêu cầu
        if (removeImage != null && removeImage) {
            if (r.getImage() != null && !r.getImage().isEmpty()) {
                try {
                    String imagePath = r.getImage();
                    java.io.File fileInSrc = new java.io.File("src/main/resources/static" + imagePath);
                    if (fileInSrc.exists())
                        fileInSrc.delete();
                    java.io.File fileInTarget = new java.io.File("target/classes/static" + imagePath);
                    if (fileInTarget.exists())
                        fileInTarget.delete();
                } catch (Exception e) {
                    log.error("[ProductPage] Unexpected error", e);
                }
                r.setImage(null);
            }
        }

        // Xử lý upload ảnh mới
        if (imageFile != null && !imageFile.isEmpty()) {
            String contentType = imageFile.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                response.put("success", false);
                response.put("message", "Chỉ chấp nhận file ảnh.");
                return org.springframework.http.ResponseEntity.status(400).body(response);
            }
            try {
                // Xóa ảnh cũ trước
                if (r.getImage() != null && !r.getImage().isEmpty()) {
                    try {
                        String oldPath = r.getImage();
                        java.io.File fileInSrc = new java.io.File("src/main/resources/static" + oldPath);
                        if (fileInSrc.exists())
                            fileInSrc.delete();
                        java.io.File fileInTarget = new java.io.File("target/classes/static" + oldPath);
                        if (fileInTarget.exists())
                            fileInTarget.delete();
                    } catch (Exception e) {
                        log.error("[ProductPage] Unexpected error", e);
                    }
                }

                String originalFilename = imageFile.getOriginalFilename();
                String extension = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String filename = "review_" + r.getProduct().getId() + "_" + currentUser.getId() + "_"
                        + System.currentTimeMillis() + extension;

                // Lưu vào src/main/resources
                String srcUploadDir = "src/main/resources/static/uploads/reviews/";
                java.io.File srcFolder = new java.io.File(srcUploadDir);
                if (!srcFolder.exists()) {
                    srcFolder.mkdirs();
                }
                java.nio.file.Path srcPath = java.nio.file.Paths.get(srcUploadDir + filename);
                java.nio.file.Files.copy(imageFile.getInputStream(), srcPath,
                        java.nio.file.StandardCopyOption.REPLACE_EXISTING);

                // Copy sang target cho phép hiển thị ngay lập tức
                String targetUploadDir = "target/classes/static/uploads/reviews/";
                java.io.File targetFolder = new java.io.File(targetUploadDir);
                if (targetFolder.exists() || targetFolder.mkdirs()) {
                    java.nio.file.Path targetPath = java.nio.file.Paths.get(targetUploadDir + filename);
                    try {
                        java.nio.file.Files.copy(srcPath, targetPath,
                                java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    } catch (Exception e) {
                        // Bỏ qua
                    }
                }

                r.setImage("/uploads/reviews/" + filename);
            } catch (Exception e) {
                log.error("[ProductPage] Unexpected error", e);
                response.put("success", false);
                response.put("message", "Lỗi khi lưu trữ hình ảnh: " + e.getMessage());
                return org.springframework.http.ResponseEntity.status(500).body(response);
            }
        }

        // Xử lý xóa video nếu được yêu cầu
        if (removeVideo != null && removeVideo) {
            if (r.getVideo() != null && !r.getVideo().isEmpty()) {
                try {
                    String videoPath = r.getVideo();
                    java.io.File fileInSrc = new java.io.File("src/main/resources/static" + videoPath);
                    if (fileInSrc.exists())
                        fileInSrc.delete();
                    java.io.File fileInTarget = new java.io.File("target/classes/static" + videoPath);
                    if (fileInTarget.exists())
                        fileInTarget.delete();
                } catch (Exception e) {
                    log.error("[ProductPage] Unexpected error", e);
                }
                r.setVideo(null);
            }
        }

        // Xử lý upload video mới
        if (videoFile != null && !videoFile.isEmpty()) {
            String contentType = videoFile.getContentType();
            if (contentType == null || !contentType.startsWith("video/")) {
                response.put("success", false);
                response.put("message", "Chỉ chấp nhận file video.");
                return org.springframework.http.ResponseEntity.status(400).body(response);
            }
            try {
                // Xóa video cũ trước
                if (r.getVideo() != null && !r.getVideo().isEmpty()) {
                    try {
                        String oldPath = r.getVideo();
                        java.io.File fileInSrc = new java.io.File("src/main/resources/static" + oldPath);
                        if (fileInSrc.exists())
                            fileInSrc.delete();
                        java.io.File fileInTarget = new java.io.File("target/classes/static" + oldPath);
                        if (fileInTarget.exists())
                            fileInTarget.delete();
                    } catch (Exception e) {
                        log.error("[ProductPage] Unexpected error", e);
                    }
                }

                String originalFilename = videoFile.getOriginalFilename();
                String extension = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String filename = "review_vid_" + r.getProduct().getId() + "_" + currentUser.getId() + "_"
                        + System.currentTimeMillis() + extension;

                // Lưu vào src/main/resources
                String srcUploadDir = "src/main/resources/static/uploads/reviews/";
                java.io.File srcFolder = new java.io.File(srcUploadDir);
                if (!srcFolder.exists()) {
                    srcFolder.mkdirs();
                }
                java.nio.file.Path srcPath = java.nio.file.Paths.get(srcUploadDir + filename);
                java.nio.file.Files.copy(videoFile.getInputStream(), srcPath,
                        java.nio.file.StandardCopyOption.REPLACE_EXISTING);

                // Copy sang target cho phép hiển thị ngay lập tức
                String targetUploadDir = "target/classes/static/uploads/reviews/";
                java.io.File targetFolder = new java.io.File(targetUploadDir);
                if (targetFolder.exists() || targetFolder.mkdirs()) {
                    java.nio.file.Path targetPath = java.nio.file.Paths.get(targetUploadDir + filename);
                    try {
                        java.nio.file.Files.copy(srcPath, targetPath,
                                java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    } catch (Exception e) {
                        // Bỏ qua
                    }
                }

                r.setVideo("/uploads/reviews/" + filename);
            } catch (Exception e) {
                log.error("[ProductPage] Unexpected error", e);
                response.put("success", false);
                response.put("message", "Lỗi khi lưu trữ video: " + e.getMessage());
                return org.springframework.http.ResponseEntity.status(500).body(response);
            }
        }

        reviewDAO.save(r);

        // Tính toán lại các chỉ số thống kê
        List<Review> reviews = reviewDAO.findByProductIdOrderByCreatedAtDesc(r.getProduct().getId());
        double avgRating = reviews.stream()
                .map(Review::getStars)
                .filter(java.util.Objects::nonNull)
                .mapToInt(Integer::intValue)
                .average()
                .orElse(0.0);

        long c5 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 5).count();
        long c4 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 4).count();
        long c3 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 3).count();
        long c2 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 2).count();
        long c1 = reviews.stream().filter(rev -> rev.getStars() != null && rev.getStars() == 1).count();

        // Trả về thông tin review đã cập nhật
        java.util.Map<String, Object> reviewData = new java.util.HashMap<>();
        reviewData.put("id", r.getId());
        reviewData.put("content", r.getContent());
        reviewData.put("stars", r.getStars());
        reviewData.put("image", r.getImage());
        reviewData.put("video", r.getVideo());
        reviewData.put("userName", currentUser.getFullName() != null && !currentUser.getFullName().isEmpty()
                ? currentUser.getFullName()
                : currentUser.getUsername());
        reviewData.put("createdAt",
                r.getCreatedAt().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));

        response.put("success", true);
        response.put("message", "Cập nhật đánh giá thành công.");
        response.put("review", reviewData);
        response.put("avgRating", avgRating);
        response.put("reviewCount", reviews.size());
        response.put("count5", c5);
        response.put("count4", c4);
        response.put("count3", c3);
        response.put("count2", c2);
        response.put("count1", c1);

        return org.springframework.http.ResponseEntity.ok(response);
    }
}
