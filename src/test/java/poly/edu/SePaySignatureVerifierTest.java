package poly.edu;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import poly.edu.config.SePayProperties;
import poly.edu.service.SePaySignatureVerifier;
import poly.edu.service.SePayWebhookAuthenticationException;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.HexFormat;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;

class SePaySignatureVerifierTest {

    private static final String SECRET = "test-secret";
    private SePaySignatureVerifier verifier;

    @BeforeEach
    void setUp() {
        SePayProperties properties = new SePayProperties();
        properties.getWebhook().setSecret(SECRET);
        properties.getWebhook().setAllowedClockSkewSeconds(300);
        verifier = new SePaySignatureVerifier(properties);
    }

    @Test
    void validHmacSha256ForTimestampDotRawBodyIsAccepted() throws Exception {
        byte[] body = "{\"id\":39}".getBytes(StandardCharsets.UTF_8);
        String timestamp = String.valueOf(Instant.now().getEpochSecond());

        assertDoesNotThrow(() -> verifier.verify(signature(timestamp, body), timestamp, body));
    }

    @Test
    void invalidHmacIsRejected() {
        byte[] body = "{}".getBytes(StandardCharsets.UTF_8);
        String timestamp = String.valueOf(Instant.now().getEpochSecond());

        assertThrows(SePayWebhookAuthenticationException.class,
                () -> verifier.verify("sha256=invalid", timestamp, body));
    }

    @Test
    void timestampOlderThanFiveMinutesIsRejected() throws Exception {
        byte[] body = "{}".getBytes(StandardCharsets.UTF_8);
        String timestamp = String.valueOf(Instant.now().minusSeconds(301).getEpochSecond());

        assertThrows(SePayWebhookAuthenticationException.class,
                () -> verifier.verify(signature(timestamp, body), timestamp, body));
    }

    private String signature(String timestamp, byte[] body) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(SECRET.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        mac.update((timestamp + ".").getBytes(StandardCharsets.UTF_8));
        return "sha256=" + HexFormat.of().formatHex(mac.doFinal(body));
    }
}
