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
                jdbcTemplate.execute("IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'auth_provider' AND Object_ID = Object_ID(N'users')) BEGIN ALTER TABLE users ADD auth_provider VARCHAR(255) END");
                jdbcTemplate.execute("IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'provider_id' AND Object_ID = Object_ID(N'users')) BEGIN ALTER TABLE users ADD provider_id VARCHAR(255) END");
                log.info("[DB] auth_provider and provider_id columns verified/added successfully.");
            } catch (Exception e) {
                log.warn("[DB] Schema update skipped (columns may already exist): {}", e.getMessage());
            }
        };
    }
}
