package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.UserRole;
import java.util.List;

public interface UserRoleDAO extends JpaRepository<UserRole, Integer> {
    List<UserRole> findByUserId(Integer userId);

    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query("DELETE FROM UserRole ur WHERE ur.user.id = :userId")
    void deleteByUserId(@org.springframework.data.repository.query.Param("userId") Integer userId);
}
