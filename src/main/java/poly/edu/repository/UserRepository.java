package poly.edu.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import poly.edu.entity.User;

public interface UserRepository extends JpaRepository<User, Integer> {

    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    Optional<User> findByPhone(String phone);
    Optional<User> findByProviderId(String providerId);

    @Query("""
		SELECT u 
		FROM User u
		JOIN u.userRoles ur
		JOIN ur.role r
		WHERE r.name <> 'ADMIN'
		""")
    List<User> findAllUserNotAdmin();

    @Query(value = "SELECT TO_CHAR(created_at, 'YYYY-MM-DD') as date, COUNT(*) as count FROM users WHERE created_at >= :startDate GROUP BY date ORDER BY date ASC", nativeQuery = true)
    List<java.util.Map<String, Object>> getNewUsersByDate(@org.springframework.data.repository.query.Param("startDate") java.util.Date startDate);

}