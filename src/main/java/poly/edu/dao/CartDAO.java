package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.Cart;
import poly.edu.entity.User;
import java.util.Optional;

public interface CartDAO extends JpaRepository<Cart, Integer> {
    Optional<Cart> findByUser(User user);
    Optional<Cart> findByUserId(Integer userId);
}
