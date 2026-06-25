package poly.edu.controller.web;

import org.springframework.beans.factory.annotation.Autowired;
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
import poly.edu.service.CategoryService;
import poly.edu.service.ProductService;
import poly.edu.service.WishlistService;
import poly.edu.dao.ReviewDAO;
import poly.edu.repository.UserRepository;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Controller
@SuppressWarnings("null")
public class ProductPageController {

    @Autowired
    ProductService productService;

    @Autowired
    CategoryService categoryService;

    @Autowired
    ReviewDAO reviewDAO;

    @Autowired
    UserRepository userRepository;

    @Autowired
    WishlistService wishlistService;

    @GetMapping("/products")
    public String showProductsPage(
            Model model,
            @RequestParam(name = "cid", required = false) Integer cid,
            @RequestParam(name = "min", required = false) Double min,
            @RequestParam(name = "max", required = false) Double max,
            @RequestParam(name = "kw", required = false) String kw) {
        
        model.addAttribute("allProducts", productService.searchProducts(cid, min, max, kw));
        model.addAttribute("categories", categoryService.getAllCategories());
        
        // Gửi lại các tham số lọc để giữ trạng thái trên UI
        model.addAttribute("selectedCid", cid);
        model.addAttribute("minPrice", min);
        model.addAttribute("maxPrice", max);
        model.addAttribute("keywords", kw);
        addWishlistAttributes(model);

        return "all-products"; 
    }

    @GetMapping("/product/{id}")
    public String showProductDetail(@PathVariable("id") Integer id, Model model) {
        Product p = productService.getProductById(id);
        if (p == null) {
            return "redirect:/products";
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
            if (uOpt.isEmpty()) uOpt = userRepository.findByUsername(emailOrUsername);
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
            @RequestParam("stars") Integer stars,
            @RequestParam("content") String content,
            @RequestParam(value = "imageFile", required = false) org.springframework.web.multipart.MultipartFile imageFile,
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
        if (uOpt.isEmpty()) uOpt = userRepository.findByUsername(emailOrUsername);

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

        Review r = new Review();
        r.setUser(uOpt.get());
        r.setProduct(p);
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
                String filename = "review_" + p.getId() + "_" + uOpt.get().getId() + "_" + System.currentTimeMillis() + extension;

                // Lưu vào src/main/resources
                String srcUploadDir = "src/main/resources/static/uploads/reviews/";
                java.io.File srcFolder = new java.io.File(srcUploadDir);
                if (!srcFolder.exists()) {
                    srcFolder.mkdirs();
                }
                java.nio.file.Path srcPath = java.nio.file.Paths.get(srcUploadDir + filename);
                java.nio.file.Files.copy(imageFile.getInputStream(), srcPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);

                // Copy sang target cho phép hiển thị ngay lập tức
                String targetUploadDir = "target/classes/static/uploads/reviews/";
                java.io.File targetFolder = new java.io.File(targetUploadDir);
                if (targetFolder.exists() || targetFolder.mkdirs()) {
                    java.nio.file.Path targetPath = java.nio.file.Paths.get(targetUploadDir + filename);
                    try {
                        java.nio.file.Files.copy(srcPath, targetPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    } catch (Exception e) {
                        // Bỏ qua lỗi copy sang target
                    }
                }

                r.setImage("/uploads/reviews/" + filename);
            } catch (Exception e) {
                e.printStackTrace();
                response.put("success", false);
                response.put("message", "Lỗi khi lưu trữ hình ảnh: " + e.getMessage());
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
            ? uOpt.get().getFullName() : uOpt.get().getUsername());
        reviewData.put("createdAt", r.getCreatedAt().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));

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
        if (uOpt.isEmpty()) uOpt = userRepository.findByUsername(emailOrUsername);

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
        Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            isAdmin = auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ADMIN"));
        }
        if (!isAdmin && currentUser.getUserRoles() != null) {
            isAdmin = currentUser.getUserRoles().stream()
                .anyMatch(ur -> ur.getRole() != null && "ADMIN".equalsIgnoreCase(ur.getRole().getName()));
        }

        if (!r.getUser().getId().equals(currentUser.getId()) && !isAdmin) {
            response.put("success", false);
            response.put("message", "Bạn không có quyền xóa đánh giá này.");
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
                e.printStackTrace();
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
        if (uOpt.isEmpty()) uOpt = userRepository.findByUsername(emailOrUsername);

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
                    if (fileInSrc.exists()) fileInSrc.delete();
                    java.io.File fileInTarget = new java.io.File("target/classes/static" + imagePath);
                    if (fileInTarget.exists()) fileInTarget.delete();
                } catch (Exception e) {
                    e.printStackTrace();
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
                        if (fileInSrc.exists()) fileInSrc.delete();
                        java.io.File fileInTarget = new java.io.File("target/classes/static" + oldPath);
                        if (fileInTarget.exists()) fileInTarget.delete();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                String originalFilename = imageFile.getOriginalFilename();
                String extension = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String filename = "review_" + r.getProduct().getId() + "_" + currentUser.getId() + "_" + System.currentTimeMillis() + extension;

                // Lưu vào src/main/resources
                String srcUploadDir = "src/main/resources/static/uploads/reviews/";
                java.io.File srcFolder = new java.io.File(srcUploadDir);
                if (!srcFolder.exists()) {
                    srcFolder.mkdirs();
                }
                java.nio.file.Path srcPath = java.nio.file.Paths.get(srcUploadDir + filename);
                java.nio.file.Files.copy(imageFile.getInputStream(), srcPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);

                // Copy sang target cho phép hiển thị ngay lập tức
                String targetUploadDir = "target/classes/static/uploads/reviews/";
                java.io.File targetFolder = new java.io.File(targetUploadDir);
                if (targetFolder.exists() || targetFolder.mkdirs()) {
                    java.nio.file.Path targetPath = java.nio.file.Paths.get(targetUploadDir + filename);
                    try {
                        java.nio.file.Files.copy(srcPath, targetPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    } catch (Exception e) {
                        // Bỏ qua
                    }
                }

                r.setImage("/uploads/reviews/" + filename);
            } catch (Exception e) {
                e.printStackTrace();
                response.put("success", false);
                response.put("message", "Lỗi khi lưu trữ hình ảnh: " + e.getMessage());
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
        reviewData.put("userName", currentUser.getFullName() != null && !currentUser.getFullName().isEmpty() 
            ? currentUser.getFullName() : currentUser.getUsername());
        reviewData.put("createdAt", r.getCreatedAt().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));

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
