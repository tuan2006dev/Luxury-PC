package poly.edu.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.User;
import poly.edu.entity.UserSession;
import java.util.List;
import java.util.Optional;

public interface UserSessionDAO extends JpaRepository<UserSession, Integer> {
    Optional<UserSession> findBySessionId(String sessionId);
    List<UserSession> findByUserAndIsExpiredFalseOrderByLoginTimeDesc(User user);

    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query("DELETE FROM UserSession us WHERE us.user.id = :userId")
    void deleteByUserId(@org.springframework.data.repository.query.Param("userId") Integer userId);
}
