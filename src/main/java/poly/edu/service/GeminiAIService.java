package poly.edu.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class GeminiAIService {

    @Value("${gemini.api.key}")
    private String geminiApiKey;

    @Value("${gemini.api.url}")
    private String geminiApiUrl;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper;

    private static final String SYSTEM_PROMPT = 
        "Bạn là một chuyên gia tư vấn build PC (máy tính để bàn) chuyên nghiệp tại cửa hàng Luxury PC. " +
        "Nhiệm vụ của bạn là tư vấn cấu hình PC cho khách hàng dựa trên nhu cầu (chơi game, làm việc, đồ họa) và ngân sách của họ. " +
        "Hãy trả lời ngắn gọn, thân thiện, và đưa ra các đề xuất linh kiện cụ thể (CPU, Mainboard, RAM, VGA, Ổ cứng, Nguồn, Vỏ case). " +
        "Nếu khách hàng hỏi những vấn đề không liên quan đến máy tính hoặc IT, hãy lịch sự từ chối và hướng họ quay lại chủ đề build PC. " +
        "QUAN TRỌNG: Ở cuối mỗi câu trả lời, bạn LUÔN LUÔN phải đặt một câu hỏi tương tác để tiếp tục cuộc trò chuyện với khách hàng. Ví dụ: 'Bạn có muốn tham khảo thêm màn hình hoặc chuột phím không?', 'Bạn thấy cấu hình này đã hợp lý với ngân sách của mình chưa?', hoặc 'Bạn có câu hỏi nào khác cần mình hỗ trợ không?'.";

    public String getPCAdvice(String userMessage) {
        try {
            Thread.sleep((long) (Math.random() * 500 + 1000));
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String msg = userMessage.toLowerCase();
        
        // 1. Phân tích các câu hỏi chào hỏi cơ bản
        if (msg.matches(".*(xin chào|hi |alo|chào|bắt đầu).*")) {
            return "Dạ Luxury PC xin chào bạn! Mình là chuyên gia tư vấn Build PC ảo.\nBạn chỉ cần nhắn số tiền (ngân sách) hoặc nhu cầu (chơi game, văn phòng, đồ họa), mình sẽ gửi bạn một cấu hình ngon nhất ngay lập tức nhé!";
        }
        if (msg.matches(".*(cảm ơn|thank|tuyệt|ok|được đấy|ngon).*")) {
            return "Không có gì ạ! Rất vui được hỗ trợ bạn. Bạn có thể nhấn 'Gặp nhân viên hỗ trợ' nếu cần tư vấn sâu hơn hoặc để chốt đơn nhé. Chúc bạn một ngày tốt lành!";
        }

        // 2. Trích xuất ngân sách bằng Regex (tìm các con số)
        int budget = 0;
        java.util.regex.Matcher m = java.util.regex.Pattern.compile("(\\d+)\\s*(triệu|tr|củ|c)").matcher(msg);
        if (m.find()) {
            budget = Integer.parseInt(m.group(1));
        } else if (msg.matches(".*\\d{7,}.*")) {
            // VD: 10000000 -> 10 triệu
            java.util.regex.Matcher m2 = java.util.regex.Pattern.compile("(\\d{2})\\d{6}").matcher(msg);
            if (m2.find()) budget = Integer.parseInt(m2.group(1));
        }
        
        // Phân tích nhu cầu
        boolean isGaming = msg.matches(".*(game|gaming|chơi|lol|fo4|fifa|gta|valorant|csgo|pubg).*");
        boolean isGraphics = msg.matches(".*(đồ họa|render|edit|video|photoshop|premiere|autocad|3d).*");
        boolean isOffice = msg.matches(".*(văn phòng|học tập|word|excel|code|làm việc|lướt web).*");
        
        // 3. Tư vấn dựa trên ngân sách hoặc nhu cầu
        if (budget > 0) {
            if (budget < 8) {
                return "Với ngân sách siêu tiết kiệm khoảng " + budget + " triệu, bộ máy phù hợp nhất sẽ là cấu hình văn phòng chạy mượt các phần mềm nhẹ:\n- CPU: Intel Core i3 12100\n- RAM: 8GB\n- SSD: 256GB\n- Nguồn: 400W\nNếu bạn muốn chơi game nhẹ như LOL, có thể tìm mua thêm card cũ như GTX 750 Ti nhé!";
            } else if (budget >= 8 && budget <= 14) {
                return "Ngân sách " + budget + " triệu là mức rất phổ thông, cực kỳ ngon để chơi game eSport (LOL, FO4, Valorant) và học tập:\n- CPU: Core i3 12100F hoặc Ryzen 5 4500\n- RAM: 16GB (2x8GB)\n- VGA: GTX 1650 4GB hoặc RX 6500 XT\n- SSD: 500GB\nCấu hình này đáp ứng cực tốt 90% nhu cầu phổ thông hiện nay!";
            } else if (budget > 14 && budget <= 22) {
                return "Wow! Khoảng " + budget + " triệu thì cấu hình này sẽ chiến mượt mọi tựa game AAA và edit video vô tư:\n- CPU: Intel Core i5 12400F hoặc Ryzen 5 7600\n- Mainboard: B660M / B650M\n- RAM: 16GB hoặc 32GB\n- VGA: RTX 4060 8GB (Hỗ trợ DLSS cực mượt)\n- SSD: 500GB NVMe\nBạn có muốn đổi sang tông màu trắng hoặc thêm tản nhiệt nước không?";
            } else if (budget > 22 && budget <= 40) {
                return "Tầm " + budget + " triệu là dòng máy cao cấp (High-end) rồi! Đề xuất cấu hình siêu mạnh:\n- CPU: Intel Core i7 13700K\n- Main: Z790\n- RAM: 32GB DDR5 6000MHz\n- VGA: RTX 4070 SUPER 12GB\n- Tản nhiệt nước 360mm\nBộ máy này cân hoàn hảo độ phân giải 2K, render video 4K phà phà. Bạn dự định mua bao giờ ạ?";
            } else {
                return "Tầm " + budget + " triệu thì đúng là cỗ máy 'quái vật'. Mình đề xuất dùng Core i9 14900K đi kèm card màn hình quái thú RTX 4090 24GB, RAM 64GB DDR5. Bạn vui lòng kết nối trực tiếp với nhân viên để nhận báo giá chi tiết và linh kiện tản nhiệt xịn nhất nhé!";
            }
        }
        
        // 4. Nếu không có số tiền, dựa vào nhu cầu
        if (isGraphics) {
            return "Để làm đồ họa và render video mượt mà, bộ PC cần chú trọng nhiều vào CPU và dung lượng RAM lớn (tối thiểu 32GB). Bạn dự định đầu tư khoảng bao nhiêu tiền cho bộ máy này để mình tư vấn cấu hình chính xác nhất?";
        }
        if (isGaming) {
            return "Build PC để chơi game thì quan trọng nhất là Card màn hình (VGA) để khung hình mượt nhất. Bạn đang chơi tựa game nào và ngân sách tối đa bạn có thể chi là bao nhiêu triệu ạ?";
        }
        if (isOffice) {
            return "PC học tập, văn phòng không cần card màn hình rời để tiết kiệm chi phí. Một bộ máy chạy i3 đời mới kèm 16GB RAM giá chỉ từ 6-8 triệu là đã dùng rất mượt rồi. Bạn muốn build luôn tầm giá này chứ?";
        }
        
        // 5. Fallback thông minh
        return "À, mình hiểu rồi. Bạn có thể cho mình biết cụ thể hơn về **ngân sách dự kiến** (ví dụ: 15 triệu, 20 triệu...) hoặc **nhu cầu chính** (chơi game gì, làm đồ họa hay văn phòng) để mình lên cấu hình chuẩn nhất cho bạn nhé!";
    }
}
