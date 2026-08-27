package poly.edu.config;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;

@Configuration
@RequiredArgsConstructor
public class DatabaseUpdateConfig {

    private static final Logger log = LoggerFactory.getLogger(DatabaseUpdateConfig.class);

    private final JdbcTemplate jdbcTemplate;

    @Bean
    public CommandLineRunner updateDatabaseSchema() {
        return args -> {
            try {
                // Ensure the columns exist for PostgreSQL / Render Cloud DB
                jdbcTemplate.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS auth_provider VARCHAR(255)");
                jdbcTemplate.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS google_id VARCHAR(255)");
                jdbcTemplate.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS facebook_id VARCHAR(255)");
                
                // Ensure columns exist for user_vouchers
                jdbcTemplate.execute("ALTER TABLE user_vouchers ADD COLUMN IF NOT EXISTS status VARCHAR(255) DEFAULT 'AVAILABLE'");
                jdbcTemplate.execute("ALTER TABLE user_vouchers ADD COLUMN IF NOT EXISTS reservation_expires_at TIMESTAMP");
                jdbcTemplate.execute("ALTER TABLE user_vouchers ADD COLUMN IF NOT EXISTS saved_at TIMESTAMP");
                jdbcTemplate.execute("ALTER TABLE user_vouchers ADD COLUMN IF NOT EXISTS used_at TIMESTAMP");

                // Ensure columns exist for flash_sales
                jdbcTemplate.execute("ALTER TABLE flash_sales ADD COLUMN IF NOT EXISTS banner_image VARCHAR(500)");
                
                // Remove translation table if any
                try {
                    jdbcTemplate.execute("DROP TABLE IF EXISTS translations");
                    log.info("[DB] Dropped translations table successfully.");
                } catch (Exception e) {
                    log.warn("[DB] Could not drop translations table: {}", e.getMessage());
                }

                log.info("[DB] PostgreSQL schema verified/added successfully for users and user_vouchers.");
            } catch (Exception e) {
                log.warn("[DB] Schema update skipped (columns may already exist): {}", e.getMessage());
            }
        };
    }
}
