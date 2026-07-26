package poly.edu.service;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@Component
public class SePayPaymentSession {

    private static final String SESSION_ATTRIBUTE = "sepayPaymentTokens";
    private final SecureRandom secureRandom = new SecureRandom();

    public String issueToken(HttpSession session, String orderCode) {
        Map<String, String> tokens = tokens(session);
        return tokens.computeIfAbsent(orderCode, ignored -> createToken());
    }

    public boolean matches(HttpSession session, String orderCode, String token) {
        if (token == null || token.isBlank()) {
            return false;
        }
        String expected = tokens(session).get(orderCode);
        return expected != null && MessageDigest.isEqual(
                expected.getBytes(StandardCharsets.US_ASCII),
                token.getBytes(StandardCharsets.US_ASCII));
    }

    @SuppressWarnings("unchecked")
    private Map<String, String> tokens(HttpSession session) {
        Object existing = session.getAttribute(SESSION_ATTRIBUTE);
        if (existing instanceof Map<?, ?>) {
            return (Map<String, String>) existing;
        }
        Map<String, String> tokens = new HashMap<>();
        session.setAttribute(SESSION_ATTRIBUTE, tokens);
        return tokens;
    }

    private String createToken() {
        byte[] bytes = new byte[32];
        secureRandom.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
