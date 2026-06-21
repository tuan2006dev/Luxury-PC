package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.Review;
import java.util.List;

public interface ReviewDAO extends JpaRepository<Review, Integer> {
    List<Review> findTop10ByOrderByCreatedAtDesc();
    List<Review> findByProductIdOrderByCreatedAtDesc(Integer productId);
    List<Review> findByUser_IdOrderByCreatedAtDesc(Integer userId);

    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query("UPDATE Review r SET r.user = null WHERE r.user.id = :userId")
    void nullifyUserReferences(@org.springframework.data.repository.query.Param("userId") Integer userId);
}
