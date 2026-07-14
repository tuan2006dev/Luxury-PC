package poly.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import poly.edu.entity.NewsCategory;

@Repository
public interface NewsCategoryRepository extends JpaRepository<NewsCategory, Integer> {
    NewsCategory findBySlug(String slug);
    java.util.List<NewsCategory> findByStatus(String status);
}
