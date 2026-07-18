import java.net.*;
import java.io.*;
import java.util.*;

public class TestLoginException {
    public static void main(String[] args) throws Exception {
        URL url = new URL("http://localhost:8080/login");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setInstanceFollowRedirects(false);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        
        String data = "username=demo@luxurypc.vn&password=123456";
        try(OutputStream os = conn.getOutputStream()) {
            os.write(data.getBytes("UTF-8"));
        }
        
        System.out.println("Status: " + conn.getResponseCode());
        String cookie = conn.getHeaderField("Set-Cookie");
        System.out.println("Cookie: " + cookie);
        
        if (cookie != null) {
            cookie = cookie.split(";")[0];
            URL url2 = new URL("http://localhost:8080/auth/login?error=true");
            HttpURLConnection conn2 = (HttpURLConnection) url2.openConnection();
            conn2.setRequestProperty("Cookie", cookie);
            conn2.getResponseCode();
            
            // To get the session attribute, we need to do it inside Spring. 
            // The best way is to just hit the error page and look for the exception message in HTML.
            InputStream in = conn2.getInputStream();
            BufferedReader reader = new BufferedReader(new InputStreamReader(in));
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.contains("error")) {
                    System.out.println(line);
                }
            }
        }
    }
}
