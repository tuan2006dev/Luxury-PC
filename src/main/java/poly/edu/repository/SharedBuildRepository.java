package poly.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import poly.edu.entity.SharedBuild;

@Repository
public interface SharedBuildRepository extends JpaRepository<SharedBuild, String> {
}
