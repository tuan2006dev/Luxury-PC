package poly.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import poly.edu.entity.AdminLog;
import java.util.List;

public interface AdminLogRepository extends JpaRepository<AdminLog, Integer> {

    List<AdminLog> findTop50ByOrderByCreatedAtDesc();

    @Query("""
                SELECT DISTINCT al
                FROM AdminLog al
                WHERE UPPER(al.adminUsername) IN (
                    SELECT UPPER(u.username)
                    FROM User u
                    JOIN u.userRoles ur
                    JOIN ur.role r
                    WHERE UPPER(r.name) = 'STAFF'
                )
                OR UPPER(al.targetUser) IN (
                    SELECT UPPER(u.username)
                    FROM User u
                    JOIN u.userRoles ur
                    JOIN ur.role r
                    WHERE UPPER(r.name) = 'STAFF'
                )
                OR UPPER(al.adminUsername) NOT IN ('ADMIN')
                ORDER BY al.createdAt DESC
            """)
    List<AdminLog> findStaffLogsTop50(org.springframework.data.domain.Pageable pageable);

    default List<AdminLog> findStaffLogsTop50() {
        return findStaffLogsTop50(org.springframework.data.domain.PageRequest.of(0, 1000));
    }
}
