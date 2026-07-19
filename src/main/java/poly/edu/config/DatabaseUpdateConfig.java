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
                // Ensure the columns exist for SQL Server
                jdbcTemplate.execute(
                        "IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'auth_provider' AND Object_ID = Object_ID(N'users')) BEGIN ALTER TABLE users ADD auth_provider VARCHAR(255) END");
                jdbcTemplate.execute(
                        "IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'provider_id' AND Object_ID = Object_ID(N'users')) BEGIN ALTER TABLE users ADD provider_id VARCHAR(255) END");
                
                // Ensure columns exist for user_vouchers
                jdbcTemplate.execute(
                        "IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'status' AND Object_ID = Object_ID(N'user_vouchers')) BEGIN ALTER TABLE user_vouchers ADD status VARCHAR(255) DEFAULT 'AVAILABLE' NOT NULL END");
                jdbcTemplate.execute(
                        "IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'reservation_expires_at' AND Object_ID = Object_ID(N'user_vouchers')) BEGIN ALTER TABLE user_vouchers ADD reservation_expires_at DATETIME2 END");
                jdbcTemplate.execute(
                        "IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'saved_at' AND Object_ID = Object_ID(N'user_vouchers')) BEGIN ALTER TABLE user_vouchers ADD saved_at DATETIME2 END");
                jdbcTemplate.execute(
                        "IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'used_at' AND Object_ID = Object_ID(N'user_vouchers')) BEGIN ALTER TABLE user_vouchers ADD used_at DATETIME2 END");

                // Ensure columns exist for flash_sales
                jdbcTemplate.execute(
                        "IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'banner_image' AND Object_ID = Object_ID(N'flash_sales')) BEGIN ALTER TABLE flash_sales ADD banner_image VARCHAR(500) END");
                
                // Remove translation table
                try {
                    jdbcTemplate.execute("DROP TABLE IF EXISTS translations");
                    log.info("[DB] Dropped translations table successfully.");
                } catch (Exception e) {
                    log.warn("[DB] Could not drop translations table: {}", e.getMessage());
                }

                log.info("[DB] Schema verified/added successfully for users and user_vouchers.");
            } catch (Exception e) {
                log.warn("[DB] Schema update skipped (columns may already exist): {}", e.getMessage());
            }
        };
    }
}
