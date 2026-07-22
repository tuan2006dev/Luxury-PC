package poly.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.AdminLog;
import java.util.List;

public interface AdminLogRepository extends JpaRepository<AdminLog, Integer> {
    List<AdminLog> findTop50ByOrderByCreatedAtDesc();
}
