package poly.edu.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.entity.News;
import poly.edu.entity.NewsStatus;

import java.util.List;
import java.util.Optional;
import poly.edu.dto.NewsSummaryDto;

public interface NewsRepository extends JpaRepository<News, Integer> {
    
    Optional<News> findBySlug(String slug);
    
    // Custom query to safely increment view count to avoid lost updates
    @Modifying
    @Transactional
    @Query("UPDATE News n SET n.viewCount = n.viewCount + 1 WHERE n.id = :id")
    void incrementViewCount(@Param("id") Integer id);

    // Front-end fetch queries (Only PUBLISHED)
    @Query("SELECT new poly.edu.dto.NewsSummaryDto(n.id, n.title, n.slug, n.summary, n.thumbnail, n.createdAt, n.viewCount, n.status, c.name, u.fullName) FROM News n LEFT JOIN n.category c LEFT JOIN n.author u WHERE n.status = :status")
    Page<NewsSummaryDto> findByStatusOrderByCreatedAtDesc(@Param("status") NewsStatus status, Pageable pageable);
    
    @Query("SELECT new poly.edu.dto.NewsSummaryDto(n.id, n.title, n.slug, n.summary, n.thumbnail, n.createdAt, n.viewCount, n.status, c.name, u.fullName) FROM News n LEFT JOIN n.category c LEFT JOIN n.author u WHERE n.category.id = :categoryId AND n.status = :status")
    Page<NewsSummaryDto> findByCategoryIdAndStatusOrderByCreatedAtDesc(@Param("categoryId") Integer categoryId, @Param("status") NewsStatus status, Pageable pageable);
    
    @Query("SELECT new poly.edu.dto.NewsSummaryDto(n.id, n.title, n.slug, n.summary, n.thumbnail, n.createdAt, n.viewCount, n.status, c.name, u.fullName) FROM News n LEFT JOIN n.category c LEFT JOIN n.author u WHERE n.status = 'PUBLISHED' AND (LOWER(n.title) LIKE LOWER(CONCAT('%',:keyword,'%')) OR LOWER(n.summary) LIKE LOWER(CONCAT('%',:keyword,'%')))")
    Page<NewsSummaryDto> searchPublishedNews(@Param("keyword") String keyword, Pageable pageable);
    
    // Top 5 Latest News
    @Query("SELECT new poly.edu.dto.NewsSummaryDto(n.id, n.title, n.slug, n.summary, n.thumbnail, n.createdAt, n.viewCount, n.status, c.name, u.fullName) FROM News n LEFT JOIN n.category c LEFT JOIN n.author u WHERE n.status = :status ORDER BY n.createdAt DESC FETCH FIRST 5 ROWS ONLY")
    List<NewsSummaryDto> findTop5ByStatusOrderByCreatedAtDesc(@Param("status") NewsStatus status);
    
    // Top 5 Most Viewed News
    @Query("SELECT new poly.edu.dto.NewsSummaryDto(n.id, n.title, n.slug, n.summary, n.thumbnail, n.createdAt, n.viewCount, n.status, c.name, u.fullName) FROM News n LEFT JOIN n.category c LEFT JOIN n.author u WHERE n.status = :status ORDER BY n.viewCount DESC FETCH FIRST 5 ROWS ONLY")
    List<NewsSummaryDto> findTop5ByStatusOrderByViewCountDesc(@Param("status") NewsStatus status);
    
    // Related news (Same category, excluding current)
    @Query("SELECT new poly.edu.dto.NewsSummaryDto(n.id, n.title, n.slug, n.summary, n.thumbnail, n.createdAt, n.viewCount, n.status, c.name, u.fullName) FROM News n LEFT JOIN n.category c LEFT JOIN n.author u WHERE n.category.id = :categoryId AND n.id != :excludeId AND n.status = 'PUBLISHED' ORDER BY n.createdAt DESC")
    List<NewsSummaryDto> findRelatedNews(@Param("categoryId") Integer categoryId, @Param("excludeId") Integer excludeId, Pageable pageable);
    
    // Admin fetch queries (All statuses)
    @Query("SELECT new poly.edu.dto.NewsSummaryDto(n.id, n.title, n.slug, n.summary, n.thumbnail, n.createdAt, n.viewCount, n.status, c.name, u.fullName) FROM News n LEFT JOIN n.category c LEFT JOIN n.author u")
    Page<NewsSummaryDto> findAllSummary(Pageable pageable);
    
    @Query("SELECT new poly.edu.dto.NewsSummaryDto(n.id, n.title, n.slug, n.summary, n.thumbnail, n.createdAt, n.viewCount, n.status, c.name, u.fullName) FROM News n LEFT JOIN n.category c LEFT JOIN n.author u WHERE LOWER(n.title) LIKE LOWER(CONCAT('%',:keyword,'%'))")
    Page<NewsSummaryDto> searchAllNewsSummary(@Param("keyword") String keyword, Pageable pageable);
}
