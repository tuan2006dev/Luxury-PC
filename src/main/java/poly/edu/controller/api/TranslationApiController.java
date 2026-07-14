package poly.edu.controller.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.ResponseEntity;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import poly.edu.entity.Translation;
import poly.edu.repository.TranslationRepository;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/translations")
public class TranslationApiController {

    private static final Logger log = LoggerFactory.getLogger(TranslationApiController.class);

    private final TranslationRepository translationRepository;

    public TranslationApiController(TranslationRepository translationRepository) {
        this.translationRepository = translationRepository;
    }

    @GetMapping
    public Map<String, Map<String, String>> getAllTranslations() {
        List<Translation> allTranslations = translationRepository.findAll();
        Map<String, Map<String, String>> response = new HashMap<>();

        for (Translation t : allTranslations) {
            String lang = t.getLang();
            String key = t.getKey();
            String value = t.getValue();

            response.computeIfAbsent(lang, k -> new HashMap<>()).put(key, value);
        }

        return response;
    }

    @PostMapping("/missing")
    public ResponseEntity<?> addMissingTranslation(@RequestBody MissingTranslationRequest request) {
        if (request.getKey() == null || request.getKey().trim().isEmpty() ||
            request.getDefaultValue() == null || request.getDefaultValue().trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Key and defaultValue must not be empty");
        }

        String key = request.getKey().trim();
        String defaultValue = request.getDefaultValue().trim();

        // Check if key already exists
        if (!translationRepository.existsByKey(key)) {
            // Auto translate from Vietnamese (vi) to English (en)
            String translatedValue = translateText(defaultValue, "vi", "en");

            // Save Vietnamese translation
            Translation translationVi = new Translation(key, "vi", defaultValue);
            translationRepository.save(translationVi);

            // Save English translation
            Translation translationEn = new Translation(key, "en", translatedValue);
            translationRepository.save(translationEn);
            
            log.info("[Translation] Auto-translated key={} -> [vi:{}, en:{}]", key, defaultValue, translatedValue);
        }

        return ResponseEntity.ok().build();
    }

    private String translateText(String text, String from, String to) {
        try {
            String urlStr = "https://api.mymemory.translated.net/get?q=" 
                    + URLEncoder.encode(text, StandardCharsets.UTF_8.toString()) 
                    + "&langpair=" + from + "|" + to;
            
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(4000); // 4 seconds timeout
            conn.setReadTimeout(4000);
            
            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
                String inputLine;
                StringBuilder response = new StringBuilder();
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();
                
                ObjectMapper mapper = new ObjectMapper();
                JsonNode root = mapper.readTree(response.toString());
                JsonNode matches = root.path("matches");
                if (matches.isArray() && matches.size() > 0) {
                    for (JsonNode match : matches) {
                        String trans = match.path("translation").asText();
                        if (trans != null && !trans.trim().isEmpty()) {
                            return trans.trim();
                        }
                    }
                }
                String translatedText = root.path("responseData").path("translatedText").asText();
                if (translatedText != null && !translatedText.trim().isEmpty()) {
                    return translatedText.trim();
                }
            }
        } catch (Exception e) {
            log.warn("[Translation] Error calling MyMemory API: {}", e.getMessage());
        }
        return text + " (EN)"; // Fallback: default value with tag if translation service is down
    }

    public static class MissingTranslationRequest {
        private String key;
        private String defaultValue;

        public String getKey() {
            return key;
        }

        public void setKey(String key) {
            this.key = key;
        }

        public String getDefaultValue() {
            return defaultValue;
        }

        public void setDefaultValue(String defaultValue) {
            this.defaultValue = defaultValue;
        }
    }
}
