package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import poly.edu.entity.Cart;
import poly.edu.entity.User;
import java.util.Optional;

public interface CartDAO extends JpaRepository<Cart, Integer> {
    Optional<Cart> findByUser(User user);
    Optional<Cart> findByUserId(Integer userId);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("DELETE FROM Cart c WHERE c.user.id = :userId")
    void deleteByUserId(@Param("userId") Integer userId);
}
