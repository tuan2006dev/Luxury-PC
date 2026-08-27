package poly.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.SharedBuild;

public interface SharedBuildRepository extends JpaRepository<SharedBuild, String> {
}
