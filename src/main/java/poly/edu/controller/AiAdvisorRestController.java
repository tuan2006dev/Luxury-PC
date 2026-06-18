package poly.edu.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@RestController
@RequestMapping("/api/build")
public class AiAdvisorRestController {

    @Value("${gemini.api.key}")
    private String apiKey;

    @Value("${gemini.api.url}")
    private String apiUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    @PostMapping("/ai-advisor")
    public ResponseEntity<Map<String, Object>> askAiAdvisor(@RequestBody Map<String, String> request) {
        String userMessage = request.get("message");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "Nội dung câu hỏi không được trống.");
            return ResponseEntity.badRequest().body(errorResponse);
        }

        try {
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
                "Chỉ sử dụng các ID hợp lệ sau: \n" +
                "CASE: case_lianli, case_corsair_white, case_hyte_red, case_fractal_black, case_nzxt_blue\n" +
                "MAIN: main_asus_z790, main_msi_z790, main_gigabyte_x670, main_msi_b650, main_asrock_b760\n" +
                "CPU: cpu_i9_14900k, cpu_r9_7950x3d, cpu_i7_14700k, cpu_r7_7800x3d, cpu_i5_14600k\n" +
                "COOLER: cooler_nzxt_360, cooler_corsair_h150i, cooler_arctic_360, cooler_noctua_nh\n" +
                "RAM: ram_gskill_32gb, ram_corsair_64gb, ram_kingston_32gb, ram_teamgroup_32gb\n" +
                "GPU: gpu_4090, gpu_4080s, gpu_7900xtx, gpu_4070ti, gpu_7800xt, gpu_4060ti\n" +
                "PSU: psu_seasonic_1300, psu_rog_1200, psu_corsair_1000, psu_evga_850, psu_msi_750"
            );

            Map<String, Object> systemInstruction = new HashMap<>();
            systemInstruction.put("parts", Collections.singletonList(systemPart));
            requestBody.put("systemInstruction", systemInstruction);

            // 4. Gửi Request POST lên Gemini API
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            ResponseEntity<Map> responseEntity = restTemplate.postForEntity(urlWithKey, entity, Map.class);

            // 5. Trích xuất câu trả lời từ Response của Gemini
            Map<String, Object> responseBody = responseEntity.getBody();
            String aiResponseText = "Xin lỗi, tôi không thể xử lý yêu cầu lúc này.";

            if (responseBody != null && responseBody.containsKey("candidates")) {
                List<Map<String, Object>> candidates = (List<Map<String, Object>>) responseBody.get("candidates");
                if (!candidates.isEmpty()) {
                    Map<String, Object> firstCandidate = candidates.get(0);
                    Map<String, Object> contentMap = (Map<String, Object>) firstCandidate.get("content");
                    if (contentMap != null && contentMap.containsKey("parts")) {
                        List<Map<String, Object>> parts = (List<Map<String, Object>>) contentMap.get("parts");
                        if (!parts.isEmpty()) {
                            aiResponseText = (String) parts.get(0).get("text");
                        }
                    }
                }
            }

            // 6. Trả kết quả về cho Frontend
            Map<String, Object> result = new HashMap<>();
            result.put("response", aiResponseText);
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "Lỗi kết nối AI: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }
}
