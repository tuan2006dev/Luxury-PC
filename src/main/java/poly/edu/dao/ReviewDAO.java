package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.Review;
import java.util.List;

public interface ReviewDAO extends JpaRepository<Review, Integer> {
    List<Review> findTop10ByOrderByCreatedAtDesc();
    List<Review> findByProductIdOrderByCreatedAtDesc(Integer productId);
}
