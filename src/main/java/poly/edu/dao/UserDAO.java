package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import poly.edu.entity.User;

public interface UserDAO extends JpaRepository<User, Integer>{

    User findByEmail(String email);
// Updated upstream

    User findByEmailAndPassword(String email,String password);

    User findByUsername(String username);

    /**
     * Loads user AND their roles in a single JOIN FETCH query.
     * Use this in security/auth context to avoid LazyInitializationException
     * after switching userRoles from EAGER to LAZY.
     */
    @Query("SELECT u FROM User u LEFT JOIN FETCH u.userRoles ur LEFT JOIN FETCH ur.role WHERE u.email = :email")
    User findByEmailWithRoles(@Param("email") String email);

    @Query("SELECT u FROM User u LEFT JOIN FETCH u.userRoles ur LEFT JOIN FETCH ur.role WHERE u.username = :username")
    User findByUsernameWithRoles(@Param("username") String username);
//Stashed changes
}