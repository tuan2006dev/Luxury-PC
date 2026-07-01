package poly.edu.controller.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api/steam")
public class SteamApiController {

    private final RestTemplate restTemplate = new RestTemplate();

    @GetMapping("/search")
    public ResponseEntity<String> searchGames(@RequestParam String q) {
        try {
            String url = "https://store.steampowered.com/api/storesearch/?term=" + q + "&l=english&cc=US";
            String response = restTemplate.getForObject(url, String.class);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("{\"error\": \"Failed to fetch from Steam API\"}");
        }
    }

    @GetMapping("/appdetails")
    public ResponseEntity<String> getAppDetails(@RequestParam String appid) {
        try {
            String url = "https://store.steampowered.com/api/appdetails?appids=" + appid + "&l=english";
            String response = restTemplate.getForObject(url, String.class);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("{\"error\": \"Failed to fetch from Steam API\"}");
        }
    }
}
