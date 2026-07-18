package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import poly.edu.entity.Voucher;
import java.util.List;
import java.util.Optional;

public interface VoucherDAO extends JpaRepository<Voucher, Integer> {

    Optional<Voucher> findByCode(String code);

    @Query("SELECT v FROM Voucher v WHERE v.active = true AND (v.endDate IS NULL OR v.endDate > CURRENT_TIMESTAMP) ORDER BY v.createdAt DESC")
    List<Voucher> findActiveVouchers();

    List<Voucher> findAllByOrderByCreatedAtDesc();

    @org.springframework.data.jpa.repository.Modifying
    @Query("UPDATE Voucher v SET v.usedCount = v.usedCount + 1 WHERE v.code = :code AND (v.usageLimit IS NULL OR v.usedCount < v.usageLimit)")
    int incrementUsageAtomically(@Param("code") String code);

    @org.springframework.data.jpa.repository.Modifying
    @Query("UPDATE Voucher v SET v.usedCount = v.usedCount - 1 WHERE v.code = :code AND v.usedCount > 0")
    int decrementUsageAtomically(@Param("code") String code);
}
