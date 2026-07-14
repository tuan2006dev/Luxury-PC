package poly.edu.controller.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Profile;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

// SECURITY: This endpoint is restricted to 'dev' profile only.
// CRITICAL: The hardcoded DB credentials below must be rotated immediately.
// Move to application-dev.properties and use environment variables in production.
@Profile("dev")
@RestController
public class SqlRunner {

    private static final Logger log = LoggerFactory.getLogger(SqlRunner.class);

    @GetMapping("/run-sql")
    public String runSql() {
        String url = "jdbc:postgresql://aws-1-ap-northeast-2.pooler.supabase.com:5432/postgres?user=postgres.fxwmcnagogiwczmyfmnu&password=trangwebpcuytin";
        try {
            String sql = new String(Files.readAllBytes(Paths.get("d:/code/LuxuryPC/init_db.sql")));
            try (Connection conn = DriverManager.getConnection(url);
                 Statement stmt = conn.createStatement()) {
                stmt.execute(sql);
            }
            return "SQL Script executed successfully!";
        } catch (Exception e) {
            log.error("[SqlRunner] Error executing SQL script", e);
            return "Error executing SQL script: " + e.getMessage();
        }
    }
}
