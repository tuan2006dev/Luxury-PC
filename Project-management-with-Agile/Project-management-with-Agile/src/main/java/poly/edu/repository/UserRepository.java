package poly.edu.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import poly.edu.entity.User;

public interface UserRepository extends JpaRepository<User, Integer> {

    Optional<User> findByEmail(String email);
    Optional<User> findByPhone(String phone);
    Optional<User> findByProviderId(String providerId);
    Optional<User> findByUsername(String username);

    @Query("SELECT u FROM User u WHERE NOT EXISTS (SELECT 1 FROM UserRole ur WHERE ur.user = u AND ur.role.id = 1)")
    List<User> findAllUserNotAdmin();

}