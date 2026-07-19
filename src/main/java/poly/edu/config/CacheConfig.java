package poly.edu.config;

import com.github.benmanes.caffeine.cache.Caffeine;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.caffeine.CaffeineCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

@Configuration
@EnableCaching
public class CacheConfig {

    @Bean
    public CacheManager cacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager(
            "featuredProducts",
            "flashSaleProducts",
            "topProducts",
            "latestReviews",
            "activeVouchers",
            "currentFlashSale",
            "currentActiveSales",
            "flashSaleItems",
            "allCategories"
        );
        cacheManager.setCaffeine(Caffeine.newBuilder()
            .expireAfterWrite(60, TimeUnit.SECONDS) // Cache 60 giây
            .maximumSize(100)
        );
        return cacheManager;
    }
}
