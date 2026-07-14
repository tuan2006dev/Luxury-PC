package poly.edu.service;

import lombok.RequiredArgsConstructor;
import jakarta.servlet.ServletContext;
import org.springframework.beans.factory.annotation.Autowired;
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

        // Tạo tên tệp độc duy nhất
        String name = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        
        try {
            // Đường dẫn lưu trữ: src/main/resources/static/images/ + folder
            // Lưu ý: Trong môi trường dev, chúng ta thường lưu vào thư mục thật để nó được nhận diện ngay
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
