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

    @Query(value = "SELECT CONVERT(VARCHAR(10), created_at, 120) as date, COUNT(*) as count FROM users WHERE created_at >= :startDate GROUP BY CONVERT(VARCHAR(10), created_at, 120) ORDER BY date ASC", nativeQuery = true)
    List<java.util.Map<String, Object>> getNewUsersByDate(@org.springframework.data.repository.query.Param("startDate") java.util.Date startDate);

    @Query("SELECT COUNT(u) FROM User u WHERE u.createdAt >= :start AND u.createdAt <= :end")
    Long countCustomersBetween(@org.springframework.data.repository.query.Param("start") java.util.Date start, @org.springframework.data.repository.query.Param("end") java.util.Date end);

    @Query(value = "SELECT CONVERT(VARCHAR(10), created_at, 120) as date, COUNT(*) as count FROM users WHERE created_at >= :start AND created_at <= :end GROUP BY CONVERT(VARCHAR(10), created_at, 120) ORDER BY date ASC", nativeQuery = true)
    List<java.util.Map<String, Object>> getNewUsersBetween(@org.springframework.data.repository.query.Param("start") java.util.Date start, @org.springframework.data.repository.query.Param("end") java.util.Date end);

    @Query("""
        SELECT DISTINCT u 
        FROM User u
        LEFT JOIN FETCH u.userRoles ur
        LEFT JOIN FETCH ur.role r
        WHERE r.name = 'STAFF'
        ORDER BY u.id DESC
        """)
    List<User> findAllEmployees();

    @Query("""
        SELECT DISTINCT u 
        FROM User u
        LEFT JOIN FETCH u.userRoles ur
        LEFT JOIN FETCH ur.role r
        WHERE r.name = 'USER'
        ORDER BY u.id DESC
        """)
    List<User> findAllCustomers();

}