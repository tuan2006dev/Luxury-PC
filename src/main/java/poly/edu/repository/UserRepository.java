package poly.edu.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.User;

public interface UserRepository extends JpaRepository<User, Integer> {

    Optional<User> findByEmail(String email);
    Optional<User> findByPhone(String phone);
    Optional<User> findByProviderId(String providerId);

}