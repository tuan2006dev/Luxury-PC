package poly.edu.controller.api;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@RestController
@RequestMapping("/api/build")
@RequiredArgsConstructor
public class AiAdvisorRestController {

    private static final Logger log = LoggerFactory.getLogger(AiAdvisorRestController.class);

    @Value("${gemini.api.key}")
    private String apiKey;

    @Value("${gemini.api.url}")
    private String apiUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    private final poly.edu.service.ProductService productService;

    @PostMapping("/ai-advisor")
    public ResponseEntity<Map<String, Object>> askAiAdvisor(@RequestBody Map<String, String> request) {
        String userMessage = request.get("message");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "Nội dung câu hỏi không được trống.");
            return ResponseEntity.badRequest().body(errorResponse);
        }

        try {
            // Lấy danh sách ID sản phẩm thực tế từ Database
            List<poly.edu.entity.Product> allProducts = productService.getAllProducts();
            Map<String, List<String>> catToIds = new HashMap<>();
            String[] cats = {"CASE", "MAINBOARD", "CPU", "COOLER", "RAM", "GPU", "PSU"};
            for (String cat : cats) catToIds.put(cat, new ArrayList<>());
            
            for (poly.edu.entity.Product p : allProducts) {
                if (p.getCategory() == null || p.getCategory().getName() == null) continue;
                String c = p.getCategory().getName().toUpperCase();
                String idStr = String.valueOf(p.getId());
                
                if (c.contains("CASE") || c.contains("VỎ")) catToIds.get("CASE").add(idStr);
                else if (c.contains("MAIN") || c.contains("BO MẠCH")) catToIds.get("MAINBOARD").add(idStr);
                else if (c.contains("CPU") || c.contains("VI XỬ LÝ")) catToIds.get("CPU").add(idStr);
                else if (c.contains("TẢN") || c.contains("COOLER")) catToIds.get("COOLER").add(idStr);
                else if (c.contains("RAM")) catToIds.get("RAM").add(idStr);
                else if (c.contains("VGA") || c.contains("CARD")) catToIds.get("GPU").add(idStr);
                else if (c.contains("NGUỒN") || c.contains("PSU")) catToIds.get("PSU").add(idStr);
            }
            
            // Hàm tiện ích lấy tối đa 5 ID cho mỗi loại
            java.util.function.Function<String, String> getTopIds = (category) -> {
                List<String> list = catToIds.get(category);
                if (list.isEmpty()) return "không có dữ liệu";
                return String.join(", ", list.subList(0, Math.min(5, list.size())));
            };

            // 1. Chuẩn bị URL chứa API Key
            String urlWithKey = apiUrl + "?key=" + apiKey;

            // 2. Thiết lập Header
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // 3. Xây dựng Request Body cho Gemini API
            Map<String, Object> requestBody = new HashMap<>();

            // Phần nội dung chat của user
            Map<String, Object> textPart = new HashMap<>();
            textPart.put("text", userMessage);

            Map<String, Object> contentObj = new HashMap<>();
            contentObj.put("parts", Collections.singletonList(textPart));
            requestBody.put("contents", Collections.singletonList(contentObj));

            // Cấu hình System Instruction để định hình tính cách cho AI
            Map<String, Object> systemPart = new HashMap<>();
            systemPart.put("text", 
                "Bạn là chuyên gia tư vấn lắp ráp máy tính (PC Build Advisor) chuyên nghiệp của cửa hàng LuxuryPC. " +
                "Nhiệm vụ của bạn là tư vấn các linh kiện như CPU, GPU, RAM, Mainboard, Tản nhiệt phù hợp với nhu cầu và ngân sách của khách hàng. " +
                "Hãy trả lời bằng tiếng Việt lịch sự, súc tích và dùng Markdown trực quan. " +
                "ĐẶC BIỆT: Nếu khách hàng yêu cầu 'Build PC', 'Tạo cấu hình', hãy chèn vào cuối câu trả lời một khối mã JSON ẩn chứa cấu trúc cấu hình như sau:\n" +
                "```json\n" +
                "{\n" +
                "  \"ai_build\": {\n" +
                "    \"CASE\": \"[id_case]\",\n" +
                "    \"MAINBOARD\": \"[id_main]\",\n" +
                "    \"CPU\": \"[id_cpu]\",\n" +
                "    \"COOLER\": \"[id_cooler]\",\n" +
                "    \"RAM\": \"[id_ram]\",\n" +
                "    \"GPU\": \"[id_gpu]\",\n" +
                "    \"PSU\": \"[id_psu]\"\n" +
                "  }\n" +
                "}\n" +
                "```\n" +
                "Chỉ sử dụng các ID hợp lệ sau (đây là các ID thực tế từ database): \n" +
                "CASE: " + getTopIds.apply("CASE") + "\n" +
                "MAINBOARD: " + getTopIds.apply("MAINBOARD") + "\n" +
                "CPU: " + getTopIds.apply("CPU") + "\n" +
                "COOLER: " + getTopIds.apply("COOLER") + "\n" +
                "RAM: " + getTopIds.apply("RAM") + "\n" +
                "GPU: " + getTopIds.apply("GPU") + "\n" +
                "PSU: " + getTopIds.apply("PSU")
            );

            Map<String, Object> systemInstruction = new HashMap<>();
            systemInstruction.put("parts", Collections.singletonList(systemPart));
            requestBody.put("systemInstruction", systemInstruction);

            // 4. Gửi Request POST lên Gemini API
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            ResponseEntity<poly.edu.dto.GeminiResponseDto> responseEntity = restTemplate.postForEntity(urlWithKey, entity, poly.edu.dto.GeminiResponseDto.class);

            // 5. Trích xuất câu trả lời từ Response của Gemini
            poly.edu.dto.GeminiResponseDto responseBody = responseEntity.getBody();
            String aiResponseText = "Xin lỗi, tôi không thể xử lý yêu cầu lúc này.";

            if (responseBody != null && responseBody.getCandidates() != null && !responseBody.getCandidates().isEmpty()) {
                poly.edu.dto.GeminiResponseDto.CandidateDto firstCandidate = responseBody.getCandidates().get(0);
                if (firstCandidate.getContent() != null && firstCandidate.getContent().getParts() != null && !firstCandidate.getContent().getParts().isEmpty()) {
                    aiResponseText = firstCandidate.getContent().getParts().get(0).getText();
                }
            }

            // 6. Trả kết quả về cho Frontend
            Map<String, Object> result = new HashMap<>();
            result.put("response", aiResponseText);
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("[AiAdvisor] Error calling Gemini API", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "Lỗi kết nối AI: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }
}
