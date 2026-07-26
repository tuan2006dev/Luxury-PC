package poly.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import poly.edu.entity.AdminLog;
import java.util.List;

public interface AdminLogRepository extends JpaRepository<AdminLog, Integer> {

    List<AdminLog> findTop50ByOrderByCreatedAtDesc();

    @Query("""
        SELECT al 
        FROM AdminLog al 
        WHERE al.adminUsername IN (
            SELECT u.username 
            FROM User u 
            JOIN u.userRoles ur 
            JOIN ur.role r 
            WHERE r.name IN ('STAFF', 'ADMIN')
        )
        ORDER BY al.createdAt DESC
    """)
    List<AdminLog> findStaffLogsTop50();
}
