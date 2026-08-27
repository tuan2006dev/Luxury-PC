package poly.edu.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.Profile;

import javax.sql.DataSource;
import java.net.URI;

@Configuration
@Profile("!test")
public class DataSourceConfig {

    private static final Logger log = LoggerFactory.getLogger(DataSourceConfig.class);

    @Value("${SPRING_DATASOURCE_URL:${DATABASE_URL:}}")
    private String rawUrl;

    @Value("${SPRING_DATASOURCE_USERNAME:${DATABASE_USERNAME:}}")
    private String rawUsername;

    @Value("${SPRING_DATASOURCE_PASSWORD:${DATABASE_PASSWORD:}}")
    private String rawPassword;

    @Bean
    @Primary
    public DataSource dataSource() {
        HikariConfig config = new HikariConfig();

        String jdbcUrl = rawUrl;
        String username = rawUsername;
        String password = rawPassword;

        // Check if rawUrl is Render's standard DATABASE_URL (postgres://user:pass@host:port/db)
        if (jdbcUrl != null && (jdbcUrl.startsWith("postgres://") || jdbcUrl.startsWith("postgresql://"))) {
            try {
                URI uri = new URI(jdbcUrl);
                String host = uri.getHost();
                int port = uri.getPort() > 0 ? uri.getPort() : 5432;
                String path = uri.getPath();
                String dbName = (path != null && path.length() > 1) ? path.substring(1) : "luxpc";

                if (uri.getUserInfo() != null) {
                    String[] userInfo = uri.getUserInfo().split(":");
                    username = userInfo[0];
                    if (userInfo.length > 1) {
                        password = userInfo[1];
                    }
                }

                jdbcUrl = "jdbc:postgresql://" + host + ":" + port + "/" + dbName + "?sslmode=require";
                log.info("[DataSourceConfig] Parsed Render URI to JDBC URL: jdbc:postgresql://{}:{}/{}?sslmode=require with user: {}", host, port, dbName, username);
            } catch (Exception e) {
                log.error("[DataSourceConfig] Failed to parse DATABASE_URL URI: {}", e.getMessage());
            }
        } else if (jdbcUrl == null || jdbcUrl.isBlank()) {
            // Fallback default
            jdbcUrl = "jdbc:postgresql://dpg-d9j246cm0tmc73a9v72g-a.singapore-postgres.render.com:5432/luxpc?sslmode=require";
            if (username == null || username.isBlank()) username = "luxpc_user";
            if (password == null || password.isBlank()) password = "Y8NmyEMc3IjoCwYyHYlYpcAyE8Ad3sbf";
        } else if (!jdbcUrl.contains("sslmode") && (jdbcUrl.contains("render.com") || jdbcUrl.contains("dpg-"))) {
            jdbcUrl += (jdbcUrl.contains("?") ? "&" : "?") + "sslmode=require";
        }

        log.info("[DataSourceConfig] Initializing HikariCP with URL: {} and Username: {}", jdbcUrl, username);

        config.setJdbcUrl(jdbcUrl);
        if (username != null && !username.isBlank()) {
            config.setUsername(username);
        }
        if (password != null && !password.isBlank()) {
            config.setPassword(password);
        }
        config.setDriverClassName("org.postgresql.Driver");
        config.setMaximumPoolSize(5);
        config.setMinimumIdle(2);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(300000);
        config.setMaxLifetime(1200000);

        return new HikariDataSource(config);
    }
}
