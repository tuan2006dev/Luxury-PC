package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import poly.edu.entity.FlashSale;
import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface FlashSaleDAO extends JpaRepository<FlashSale, Integer> {

    @Query("SELECT fs FROM FlashSale fs WHERE fs.active = true AND fs.startTime <= :now AND fs.endTime > :now")
    Optional<FlashSale> findCurrentActiveSale(@Param("now") Date now);

    List<FlashSale> findAllByOrderByCreatedAtDesc();
}
