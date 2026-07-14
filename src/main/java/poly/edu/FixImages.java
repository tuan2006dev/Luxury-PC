package poly.edu;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class FixImages {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://db.fxwmcnagogiwczmyfmnu.supabase.co:5432/postgres?sslmode=require";
        String user = "postgres";
        String password = "trangwebpcuytin";

        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT id, name FROM products")) {
            
            String updateSql = "UPDATE products SET image = ? WHERE id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                int count = 0;
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String rawName = rs.getString("name");
                    String name = rawName != null ? rawName.toLowerCase() : "";
                    String image = "corsair_3500x_black.png";
                    
                    if (name.contains("rtx") || name.contains("rx") || name.contains("radeon") || name.contains("vga") || name.contains("card") || name.contains("gtx")) {
                        image = "asus_rog_rtx_4090.jpg";
                    } else if (name.contains("core") || name.contains("ryzen") || name.contains("cpu") || name.contains("intel") || name.contains("amd") || name.contains("threadripper")) {
                        image = "i9_14900k.jpg";
                    } else if (name.contains("z790") || name.contains("b760") || name.contains("x670") || name.contains("mainboard") || name.contains("motherboard") || name.contains("z890") || name.contains("h610") || name.contains("b650")) {
                        image = "z790_dark_kingpin.jpg";
                    } else if (name.contains("ram") || name.contains("ddr4") || name.contains("ddr5") || name.contains("g.skill") || name.contains("trident") || name.contains("hof") || name.contains("vengeance")) {
                        image = "galax_hof_32gb.jpg";
                    } else if (name.contains("ssd") || name.contains("nvme") || name.contains("samsung") || name.contains("crucial") || name.contains("sabrent") || name.contains("kingston") || name.contains("hdd")) {
                        image = "sabrent_rocket_4tb.jpg";
                    } else if (name.contains("nguồn") || name.contains("psu") || name.contains("corsair") || name.contains("fsp") || name.contains("cooler master")) {
                        image = "corsair_rm850e.jpg";
                    } else if (name.contains("tản nhiệt") || name.contains("cooler") || name.contains("aio") || name.contains("ryujin") || name.contains("nautilus") || name.contains("fan") || name.contains("quạt")) {
                        image = "rog_ryujin_360.jpg";
                    } else if (name.contains("màn hình") || name.contains("monitor") || name.contains("aw34") || name.contains("pg42") || name.contains("xeneon") || name.contains("odyssey") || name.contains("swift") || name.contains("display")) {
                        image = "samsung_990pro.jpg";
                    }
                    
                    pstmt.setString(1, image);
                    pstmt.setInt(2, id);
                    pstmt.addBatch();
                    count++;
                }
                pstmt.executeBatch();
                System.out.println("SUCCESSFULLY UPDATED " + count + " PRODUCTS IN POSTGRESQL.");
            }
        } catch (Exception e) {
            // SECURITY WARNING: Hardcoded credentials above must be moved to environment variables
            System.err.println("[FixImages] Error updating product images: " + e.getMessage());
        }
    }
}
