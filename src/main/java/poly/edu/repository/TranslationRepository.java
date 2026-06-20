package poly.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import poly.edu.entity.Translation;

@Repository
public interface TranslationRepository extends JpaRepository<Translation, Integer> {
    boolean existsByKey(String key);
}
