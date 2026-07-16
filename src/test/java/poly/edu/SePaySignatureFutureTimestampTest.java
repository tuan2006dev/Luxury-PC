package poly.edu;

import org.junit.jupiter.api.Test;
import poly.edu.config.SePayProperties;
import poly.edu.service.SePaySignatureVerifier;
import poly.edu.service.SePayWebhookAuthenticationException;

import java.nio.charset.StandardCharsets;
import java.time.Instant;

import static org.junit.jupiter.api.Assertions.assertThrows;

class SePaySignatureFutureTimestampTest {

    @Test
    void timestampMoreThanFiveMinutesInFutureIsRejectedBeforeSignatureComparison() {
        SePayProperties properties = new SePayProperties();
        properties.getWebhook().setSecret("test-secret");
        properties.getWebhook().setAllowedClockSkewSeconds(300);
        SePaySignatureVerifier verifier = new SePaySignatureVerifier(properties);
        String futureTimestamp = String.valueOf(Instant.now().plusSeconds(301).getEpochSecond());

        assertThrows(SePayWebhookAuthenticationException.class,
                () -> verifier.verify(
                        "sha256=not-evaluated",
                        futureTimestamp,
                        "{}".getBytes(StandardCharsets.UTF_8)));
    }
}
