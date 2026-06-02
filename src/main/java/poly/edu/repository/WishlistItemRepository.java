package poly.edu.repository;

import java.util.List;
import java.util.Set;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import poly.edu.entity.WishlistItem;

public interface WishlistItemRepository extends JpaRepository<WishlistItem, Integer> {

    List<WishlistItem> findByUser_IdOrderByCreatedAtDesc(Integer userId);

    long countByUser_Id(Integer userId);

    boolean existsByUser_IdAndProduct_Id(Integer userId, Integer productId);

    @Modifying
    @Query("DELETE FROM WishlistItem w WHERE w.user.id = :uid AND w.product.id = :pid")
    int deleteByUserIdAndProductId(@Param("uid") Integer userId, @Param("pid") Integer productId);

    @Modifying
    @Query("DELETE FROM WishlistItem w WHERE w.user.id = :uid")
    int deleteByUserId(@Param("uid") Integer userId);

    @Query("SELECT w.product.id FROM WishlistItem w WHERE w.user.id = :uid")
    Set<Integer> findProductIdsByUserId(@Param("uid") Integer userId);
}
