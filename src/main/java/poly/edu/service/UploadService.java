package poly.edu.service;

import lombok.RequiredArgsConstructor;
import jakarta.servlet.ServletContext;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UploadService {

    final ServletContext app;

    public String save(MultipartFile file, String folder) {
        if (file == null || file.isEmpty()) {
            return null;
        }

        // Lấy đúng tên file gốc (tránh lỗi Windows trả về full path)
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || originalFilename.isBlank()) {
            originalFilename = "upload";
        }
        // Chỉ lấy tên file, bỏ path (Windows có thể trả về full path)
        originalFilename = Paths.get(originalFilename).getFileName().toString();
        // Sanitize: thay khoảng trắng và ký tự đặc biệt bằng dấu gạch dưới
        originalFilename = originalFilename.replaceAll("[^a-zA-Z0-9._-]", "_");

        // Tạo tên tệp duy nhất: UUID + productId (từ originalFilename)
        String name = UUID.randomUUID().toString() + "_" + originalFilename;

        try {
            // Đường dẫn lưu trữ: src/main/resources/static/images/ + folder
            String rootPath = System.getProperty("user.dir") + "/src/main/resources/static/images/" + folder;
            File dir = new File(rootPath);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            Path path = Paths.get(rootPath, name);
            Files.write(path, file.getBytes());

            return name;
        } catch (IOException e) {
            throw new RuntimeException("Lỗi lưu tệp: " + e.getMessage());
        }
    }
}
