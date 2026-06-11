package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.StockMovement;
import java.util.List;

public interface StockMovementDAO extends JpaRepository<StockMovement, Integer> {
    List<StockMovement> findByProductIdOrderByCreatedAtDesc(Integer productId);
}
