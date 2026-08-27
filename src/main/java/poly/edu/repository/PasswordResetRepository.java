package poly.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.PasswordReset;

import java.util.Optional;

public interface PasswordResetRepository extends JpaRepository<PasswordReset, Long> {
    Optional<PasswordReset> findByEmail(String email);
}
