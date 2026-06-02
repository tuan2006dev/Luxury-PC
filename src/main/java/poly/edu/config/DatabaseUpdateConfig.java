package poly.edu.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;

@Configuration
public class DatabaseUpdateConfig {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Bean
    public CommandLineRunner updateDatabaseSchema() {
        return args -> {
            try {
                // Ensure the columns exist
                jdbcTemplate.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS auth_provider VARCHAR(255);");
                jdbcTemplate.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS provider_id VARCHAR(255);");
                System.out.println("=================================================");
                System.out.println("DATABASE SCHEMA UDPATED SUCCESSFULLY!");
                System.out.println("auth_provider and provider_id columns are ready.");
                System.out.println("=================================================");
            } catch (Exception e) {
                System.err.println("Database Update Failed (Columns might already exist or permission denied): " + e.getMessage());
            }
        };
    }
}
