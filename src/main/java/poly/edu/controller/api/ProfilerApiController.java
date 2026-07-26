package poly.edu.controller.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import poly.edu.config.profiler.SimpleProfiler;

@RestController
@RequestMapping("/api/profiler")
public class ProfilerApiController {

    @GetMapping("/toggle")
    public ResponseEntity<String> toggleProfiler() {
        SimpleProfiler.ENABLED = !SimpleProfiler.ENABLED;
        String status = SimpleProfiler.ENABLED ? "BẬT" : "TẮT";
        return ResponseEntity.ok("Profiler đã " + status);
    }
    
    @GetMapping("/status")
    public ResponseEntity<Boolean> getStatus() {
        return ResponseEntity.ok(SimpleProfiler.ENABLED);
    }
}
