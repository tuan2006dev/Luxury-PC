package poly.edu.dao;

import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import poly.edu.entity.VietQrPaymentSession;

import java.time.Instant;
import java.util.Optional;

public interface VietQrPaymentSessionRepository extends JpaRepository<VietQrPaymentSession, Long> {

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    Optional<VietQrPaymentSession> findFirstByOrder_IdOrderByQrCreatedAtDescIdDesc(Integer orderId);

    Optional<VietQrPaymentSession>
            findFirstByOrder_IdAndQrCreatedAtLessThanEqualAndQrExpiresAtGreaterThanOrderByQrCreatedAtDescIdDesc(
                    Integer orderId,
                    Instant paymentTime,
                    Instant samePaymentTime);
}
