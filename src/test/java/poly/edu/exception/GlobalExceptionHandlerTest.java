package poly.edu.exception;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.util.NoSuchElementException;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
public class GlobalExceptionHandlerTest {

    private MockMvc mockMvc;

    @InjectMocks
    private GlobalExceptionHandler globalExceptionHandler;

    @BeforeEach
    public void setup() {
        // Build a MockMvc with a dummy controller and our GlobalExceptionHandler
        this.mockMvc = MockMvcBuilders.standaloneSetup(new DummyController())
                .setControllerAdvice(globalExceptionHandler)
                .build();
    }

    // --- REGRESSION TESTS ---

    @Test
    public void testNoSuchElementException_ApiRequest_ReturnsJson404() throws Exception {
        // Arrange & Act
        mockMvc.perform(get("/api/dummy/nosuch")
                .accept(MediaType.APPLICATION_JSON))
        // Assert
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.message").value("Không tìm thấy tài nguyên yêu cầu."));
    }

    @Test
    public void testNoSuchElementException_MvcRequest_ReturnsErrorPage404() throws Exception {
        // Arrange & Act
        mockMvc.perform(get("/dummy/nosuch")
                .accept(MediaType.TEXT_HTML))
        // Assert
                .andExpect(status().isOk()) // ControllerAdvice returns view name "error/404" with status 200 by default unless @ResponseStatus is used, wait! 
                // Ah, GlobalExceptionHandler method handleNoSuchElement does not have @ResponseStatus, so it returns 200 OK with the error page.
                // This is a known behavior of standard Spring MVC error pages unless annotated.
                .andExpect(view().name("error/404"))
                .andExpect(model().attribute("errorCode", 404));
    }

    @Test
    public void testIllegalArgumentException_ApiRequest_ReturnsJson400() throws Exception {
        mockMvc.perform(get("/api/dummy/illegal")
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.status").value(400))
                .andExpect(jsonPath("$.message").value("Dữ liệu đầu vào không hợp lệ."));
    }

    @Test
    public void testIllegalArgumentException_MvcRequest_ReturnsErrorPage400() throws Exception {
        mockMvc.perform(get("/dummy/illegal")
                .accept(MediaType.TEXT_HTML))
                .andExpect(status().isOk())
                .andExpect(view().name("error/400"))
                .andExpect(model().attribute("errorCode", 400));
    }

    @Test
    public void testGenericException_ApiRequest_ReturnsJson500() throws Exception {
        mockMvc.perform(get("/api/dummy/error")
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isInternalServerError())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.status").value(500))
                .andExpect(jsonPath("$.message").value("Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau."));
    }

    @Test
    public void testGenericException_MvcRequest_ReturnsErrorPage500() throws Exception {
        mockMvc.perform(get("/dummy/error")
                .accept(MediaType.TEXT_HTML))
                .andExpect(status().isOk())
                .andExpect(view().name("error/500"))
                .andExpect(model().attribute("errorCode", 500));
    }

    // --- DUMMY CONTROLLER ---
    @RestController
    static class DummyController {
        @GetMapping("/api/dummy/nosuch")
        public String apiNoSuch() { throw new NoSuchElementException("API Element missing"); }

        @GetMapping("/dummy/nosuch")
        public String mvcNoSuch() { throw new NoSuchElementException("MVC Element missing"); }

        @GetMapping("/api/dummy/illegal")
        public String apiIllegal() { throw new IllegalArgumentException("API Bad Request"); }

        @GetMapping("/dummy/illegal")
        public String mvcIllegal() { throw new IllegalArgumentException("MVC Bad Request"); }

        @GetMapping("/api/dummy/error")
        public String apiError() throws Exception { throw new Exception("API Fatal Error"); }

        @GetMapping("/dummy/error")
        public String mvcError() throws Exception { throw new Exception("MVC Fatal Error"); }
    }
}
