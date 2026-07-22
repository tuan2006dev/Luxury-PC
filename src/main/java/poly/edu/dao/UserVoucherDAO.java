package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import poly.edu.entity.User;
import poly.edu.entity.UserVoucher;
import poly.edu.entity.Voucher;

import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface UserVoucherDAO extends JpaRepository<UserVoucher, Integer> {
    
    // Find all vouchers saved by a user
    List<UserVoucher> findByUserOrderBySavedAtDesc(User user);
    
    // Find unused vouchers saved by a user
    List<UserVoucher> findByUserAndStatusOrderBySavedAtDesc(User user, String status);

    @Query("SELECT uv FROM UserVoucher uv WHERE uv.user = :user AND uv.status IN :statuses ORDER BY uv.savedAt DESC")
    List<UserVoucher> findByUserAndStatusesOrderBySavedAtDesc(@Param("user") User user, @Param("statuses") List<String> statuses);
    
    // Find a specific saved voucher
    Optional<UserVoucher> findByUserAndVoucher(User user, Voucher voucher);
 
    // Find a specific valid user voucher by code and status
    @Query("SELECT uv FROM UserVoucher uv WHERE uv.user = :user AND uv.voucher.code = :code AND uv.status = :status")
    Optional<UserVoucher> findByUserAndVoucherCodeAndStatus(@Param("user") User user, @Param("code") String code, @Param("status") String status);
 
    // Count how many times a voucher was saved globally (optional logic)
    int countByVoucher(Voucher voucher);

    @org.springframework.transaction.annotation.Transactional
    void deleteByVoucherId(Integer voucherId);

    @org.springframework.transaction.annotation.Transactional
    void deleteByUserId(Integer userId);

    @Modifying
    @Query("UPDATE UserVoucher uv SET uv.status = 'RESERVED', uv.reservationExpiresAt = :expiresAt WHERE uv.user.id = :userId AND uv.voucher.code = :code AND uv.status = 'AVAILABLE'")
    int reserveVoucherAtomically(@Param("userId") Integer userId, @Param("code") String code, @Param("expiresAt") Date expiresAt);

    @Modifying
    @Query("UPDATE UserVoucher uv SET uv.status = 'CONSUMED', uv.usedAt = CURRENT_TIMESTAMP WHERE uv.user.id = :userId AND uv.voucher.code = :code AND uv.status = 'RESERVED'")
    int consumeReservedVoucherAtomically(@Param("userId") Integer userId, @Param("code") String code);

    @Modifying
    @Query("UPDATE UserVoucher uv SET uv.status = 'AVAILABLE', uv.reservationExpiresAt = NULL WHERE uv.user.id = :userId AND uv.voucher.code = :code AND (uv.status = 'RESERVED' OR uv.status = 'CONSUMED')")
    int restoreVoucherAtomically(@Param("userId") Integer userId, @Param("code") String code);

    @Query("SELECT uv FROM UserVoucher uv WHERE uv.status = 'RESERVED' AND uv.reservationExpiresAt <= CURRENT_TIMESTAMP")
    List<UserVoucher> findExpiredReservations();
}
