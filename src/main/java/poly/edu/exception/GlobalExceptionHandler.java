package poly.edu.exception;

import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.util.HashMap;
import java.util.Map;
import java.util.NoSuchElementException;

/**
 * Global exception handler — replaces Spring's White Label Error Page.
 *
 * Strategy:
 * - REST API requests (/api/**): return structured JSON with error detail
 * - MVC page requests: redirect to a safe page with flash error message
 *
 * Only CONFIRMED production bugs are handled here:
 * - NoSuchElementException: from Optional.get() on empty Optional
 * - IllegalArgumentException: from bad user input
 * - Generic Exception: fallback for all unhandled runtime errors
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * CONFIRMED BUG: Optional.get() on empty Optional throws NoSuchElementException.
     * Previously caused HTTP 500 White Label Error. Now returns structured 404.
     */
    @ExceptionHandler(NoSuchElementException.class)
    public Object handleNoSuchElement(NoSuchElementException ex, HttpServletRequest request, Model model) {
        log.warn("[GlobalHandler] Resource not found: {} — URI: {}", ex.getMessage(), request.getRequestURI());
        if (isApiRequest(request)) {
            return buildJsonError(HttpStatus.NOT_FOUND, "Không tìm thấy tài nguyên yêu cầu.", ex.getMessage());
        }
        model.addAttribute("errorCode", 404);
        model.addAttribute("errorMessage", "Tài nguyên không tồn tại hoặc đã bị xóa.");
        return "error/404";
    }

    /**
     * Handles bad input data — IllegalArgumentException.
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public Object handleIllegalArgument(IllegalArgumentException ex, HttpServletRequest request, Model model) {
        log.warn("[GlobalHandler] Invalid argument: {} — URI: {}", ex.getMessage(), request.getRequestURI());
        if (isApiRequest(request)) {
            return buildJsonError(HttpStatus.BAD_REQUEST, "Dữ liệu đầu vào không hợp lệ.", ex.getMessage());
        }
        model.addAttribute("errorCode", 400);
        model.addAttribute("errorMessage", "Dữ liệu không hợp lệ: " + ex.getMessage());
        return "error/400";
    }

    /**
     * Handles 404 for missing static resources and pages.
     */
    @ExceptionHandler(NoResourceFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public Object handleNoResource(NoResourceFoundException ex, HttpServletRequest request, Model model) {
        log.debug("[GlobalHandler] No resource: {}", request.getRequestURI());
        if (isApiRequest(request)) {
            return buildJsonError(HttpStatus.NOT_FOUND, "Không tìm thấy endpoint yêu cầu.", null);
        }
        model.addAttribute("errorCode", 404);
        model.addAttribute("errorMessage", "Trang bạn tìm không tồn tại.");
        return "error/404";
    }

    /**
     * Fallback handler for all other unhandled runtime exceptions.
     * Logs the full stack trace for production debugging, but shows a safe error to user.
     */
    @ExceptionHandler(Exception.class)
    public Object handleGenericException(Exception ex, HttpServletRequest request, Model model) {
        log.error("[GlobalHandler] Unhandled exception at URI: {}", request.getRequestURI(), ex);
        if (isApiRequest(request)) {
            return buildJsonError(HttpStatus.INTERNAL_SERVER_ERROR,
                    "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau.", null);
        }
        model.addAttribute("errorCode", 500);
        model.addAttribute("errorMessage", "Hệ thống gặp sự cố. Vui lòng thử lại sau.");
        model.addAttribute("exception", ex.getClass().getName() + ": " + ex.getMessage());
        return "error/500";
    }

    // ---- Helpers ----

    private boolean isApiRequest(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String accept = request.getHeader("Accept");
        return uri.startsWith("/api/") ||
               (accept != null && accept.contains("application/json"));
    }

    private ResponseEntity<Map<String, Object>> buildJsonError(HttpStatus status, String message, String detail) {
        Map<String, Object> body = new HashMap<>();
        body.put("success", false);
        body.put("status", status.value());
        body.put("message", message);
        if (detail != null) {
            body.put("detail", detail);
        }
        return ResponseEntity.status(status).body(body);
    }
}
