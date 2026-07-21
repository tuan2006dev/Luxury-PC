package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import poly.edu.entity.CartItemEntity;
import java.util.List;
import java.util.Optional;

public interface CartItemDAO extends JpaRepository<CartItemEntity, Integer> {
    List<CartItemEntity> findByCartId(Integer cartId);
    Optional<CartItemEntity> findByCartIdAndProductId(Integer cartId, Integer productId);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("DELETE FROM CartItemEntity ci WHERE ci.cart.id = :cartId")
    void deleteByCartId(@Param("cartId") Integer cartId);
}
