package poly.edu.config;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;
import poly.edu.dao.ProductDAO;
import poly.edu.dao.ReviewDAO;
import poly.edu.repository.UserRepository;
import poly.edu.entity.Product;
import poly.edu.entity.Review;
import poly.edu.entity.User;
import java.util.Arrays;

@Configuration
@RequiredArgsConstructor
public class ReviewDataLoader implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(ReviewDataLoader.class);

    final ReviewDAO reviewDAO;
    final UserRepository userRepo;
    final ProductDAO productDAO;

    @Override
    public void run(String... args) throws Exception {
        if (reviewDAO.count() == 0) {
            // Find or create a demo user
            User user = userRepo.findAll().stream().findFirst().orElseGet(() -> {
                User u = new User();
                u.setFullName("Lê Thanh Tuấn");
                u.setEmail("demo@luxurypc.vn");
                u.setUsername("demo_user");
                u.setPassword("encoded_password"); // Not used for display
                return userRepo.save(u);
            });

            Product product = productDAO.findAll().stream().findFirst().orElse(null);

            Review r1 = new Review();
            r1.setContent("Máy build từ Luxury PC chạy mượt như mơ. RTX 4090 kết hợp với i9-14900K — không có game nào kháng cự được. Đáng từng đồng bỏ ra.");
            r1.setStars(5);
            r1.setUser(user);
            r1.setProduct(product);

            Review r2 = new Review();
            r2.setContent("Dịch vụ tư vấn chuyên nghiệp, lắp ráp cực kỳ thẩm mỹ. Tôi rất hài lòng với chiếc Workstation mới này.");
            r2.setStars(5);
            r2.setUser(user);
            r2.setProduct(product);

            Review r3 = new Review();
            r3.setContent("Bảo hành nhanh chóng, nhân viên nhiệt tình hỗ trợ. Xứng đáng với danh hiệu Luxury PC.");
            r3.setStars(4);
            r3.setUser(user);
            r3.setProduct(product);

            if (product != null) {
                reviewDAO.saveAll(Arrays.asList(r1, r2, r3));
                log.info("[ReviewDataLoader] Initial reviews seeded into database.");
            }
        }
    }
}
