package poly.edu.controller.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import poly.edu.entity.SharedBuild;
import poly.edu.repository.SharedBuildRepository;

import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/build/share")
@CrossOrigin(origins = "*")
@SuppressWarnings("null")
public class PCBuildShareController {

    @Autowired
    private SharedBuildRepository sharedBuildRepository;

    private static final String CHARACTERS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    private static final int CODE_LENGTH = 9;
    private final SecureRandom random = new SecureRandom();

    private String generateShareCode() {
        StringBuilder sb = new StringBuilder(CODE_LENGTH);
        for (int i = 0; i < CODE_LENGTH; i++) {
            sb.append(CHARACTERS.charAt(random.nextInt(CHARACTERS.length())));
        }
        return sb.toString();
    }

    @PostMapping
    public ResponseEntity<?> shareBuild(@RequestBody SharedBuild build) {
        String code;
        do {
            code = generateShareCode();
        } while (sharedBuildRepository.existsById(code));

        build.setShareCode(code);
        SharedBuild saved = sharedBuildRepository.save(build);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("shareCode", saved.getShareCode());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{shareCode}")
    public ResponseEntity<?> getSharedBuild(@PathVariable String shareCode) {
        Optional<SharedBuild> opt = sharedBuildRepository.findById(shareCode);
        if (opt.isPresent()) {
            return ResponseEntity.ok(opt.get());
        } else {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "Không tìm thấy cấu hình này");
            return ResponseEntity.status(404).body(err);
        }
    }
}
