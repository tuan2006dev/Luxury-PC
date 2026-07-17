package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import poly.edu.entity.FlashSale;
import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface FlashSaleDAO extends JpaRepository<FlashSale, Integer> {

    @Query("SELECT fs FROM FlashSale fs WHERE fs.active = true")
    List<FlashSale> findCurrentActiveSale();

    @Query("SELECT fs FROM FlashSale fs WHERE fs.startTime <= :now AND fs.endTime >= :now ORDER BY fs.startTime ASC")
    List<FlashSale> findValidSalesForTime(@Param("now") Date now);

    @Query("SELECT fs FROM FlashSale fs WHERE fs.startTime > :now ORDER BY fs.startTime ASC")
    List<FlashSale> findUpcomingSales(@Param("now") Date now);

    List<FlashSale> findAllByOrderByCreatedAtDesc();

    @org.springframework.data.jpa.repository.Modifying
    @Query("UPDATE FlashSale fs SET fs.active = false")
    void deactivateAllSales();

    @org.springframework.data.jpa.repository.Modifying
    @Query("UPDATE FlashSale fs SET fs.active = true WHERE fs.id = :id")
    void activateSale(@Param("id") Integer id);
}
