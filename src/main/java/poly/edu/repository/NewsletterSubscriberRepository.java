package poly.edu.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import poly.edu.entity.NewsletterSubscriber;

public interface NewsletterSubscriberRepository extends JpaRepository<NewsletterSubscriber, Long> {
    Optional<NewsletterSubscriber> findByEmail(String email);
    boolean existsByEmail(String email);
}
