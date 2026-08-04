package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.Review;
import java.util.List;

public interface ReviewDAO extends JpaRepository<Review, Integer> {
    @org.springframework.data.jpa.repository.EntityGraph(attributePaths = {"user"})
    List<Review> findTop10ByOrderByCreatedAtDesc();
    List<Review> findByProductIdOrderByCreatedAtDesc(Integer productId);
    List<Review> findByUser_IdOrderByCreatedAtDesc(Integer userId);

    boolean existsByUser_IdAndProduct_Id(Integer userId, Integer productId);

    @org.springframework.data.jpa.repository.Query("SELECT r.product.id FROM Review r WHERE r.user.id = :userId AND r.product.id IS NOT NULL")
    List<Integer> findReviewedProductIdsByUserId(@org.springframework.data.repository.query.Param("userId") Integer userId);

    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query("UPDATE Review r SET r.user = null WHERE r.user.id = :userId")
    void nullifyUserReferences(@org.springframework.data.repository.query.Param("userId") Integer userId);
}
