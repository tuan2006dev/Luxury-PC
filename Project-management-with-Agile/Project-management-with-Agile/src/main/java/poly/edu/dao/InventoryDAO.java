package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import poly.edu.entity.Inventory;
import java.util.List;
import java.util.Optional;

public interface InventoryDAO extends JpaRepository<Inventory, Integer> {
    Optional<Inventory> findByProductId(Integer productId);

    @Query("SELECT i FROM Inventory i WHERE i.quantity < 10")
    List<Inventory> findLowStockItems();
}
