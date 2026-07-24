package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.SePayTransaction;

import java.util.Optional;

public interface SePayTransactionRepository extends JpaRepository<SePayTransaction, Long> {

    boolean existsBySepayTransactionId(Long sepayTransactionId);

    Optional<SePayTransaction> findBySepayTransactionId(Long sepayTransactionId);
}
