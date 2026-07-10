package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import poly.edu.entity.FlashSaleItem;
import java.util.List;
import java.util.Optional;

public interface FlashSaleItemDAO extends JpaRepository<FlashSaleItem, Integer> {

    @org.springframework.data.jpa.repository.EntityGraph(attributePaths = {"product"})
    List<FlashSaleItem> findByFlashSaleId(Integer flashSaleId);

    @Query("SELECT fsi FROM FlashSaleItem fsi WHERE fsi.flashSale.id = :saleId AND fsi.soldCount < fsi.saleQuantity")
    List<FlashSaleItem> findAvailableItemsBySaleId(@Param("saleId") Integer saleId);

    Optional<FlashSaleItem> findByFlashSaleIdAndProductId(Integer flashSaleId, Integer productId);

    @Query("SELECT fsi FROM FlashSaleItem fsi JOIN FETCH fsi.product WHERE fsi.flashSale.id = :saleId")
    List<FlashSaleItem> findByFlashSaleIdWithProduct(@Param("saleId") Integer saleId);
}
