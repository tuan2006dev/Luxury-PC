package poly.edu.service;

import org.springframework.stereotype.Component;
import poly.edu.config.SePayProperties;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.Instant;
import java.util.HexFormat;

@Component
public class SePaySignatureVerifier {

    private final SePayProperties sePayProperties;

    public SePaySignatureVerifier(SePayProperties sePayProperties) {
        this.sePayProperties = sePayProperties;
    }

    public void verify(String signature, String timestampHeader, byte[] rawBody) {
        if (!sePayProperties.hasWebhookSecret()) {
            throw new IllegalStateException("SePay webhook secret is not configured");
        }

        long timestamp = parseTimestamp(timestampHeader);
        long now = Instant.now().getEpochSecond();
        long allowedSkew = sePayProperties.getWebhook().getAllowedClockSkewSeconds();
        if (allowedSkew < 0 || timestamp < now - allowedSkew || timestamp > now + allowedSkew) {
            throw new SePayWebhookAuthenticationException("Expired SePay webhook timestamp");
        }

        if (signature == null || signature.isBlank()) {
            throw new SePayWebhookAuthenticationException("Missing SePay webhook signature");
        }

        byte[] headerBytes = (timestampHeader + ".").getBytes(StandardCharsets.UTF_8);
        byte[] signedPayload = new byte[headerBytes.length + rawBody.length];
        System.arraycopy(headerBytes, 0, signedPayload, 0, headerBytes.length);
        System.arraycopy(rawBody, 0, signedPayload, headerBytes.length, rawBody.length);
        String expected = "sha256=" + hmacSha256(signedPayload, sePayProperties.getWebhook().getSecret());
        if (!MessageDigest.isEqual(
                expected.getBytes(StandardCharsets.US_ASCII),
                signature.getBytes(StandardCharsets.US_ASCII))) {
            throw new SePayWebhookAuthenticationException("Invalid SePay webhook signature");
        }
    }

    private long parseTimestamp(String timestampHeader) {
        try {
            if (timestampHeader == null || timestampHeader.isBlank()) {
                throw new NumberFormatException("Missing timestamp");
            }
            return Long.parseLong(timestampHeader);
        } catch (NumberFormatException exception) {
            throw new SePayWebhookAuthenticationException("Invalid SePay webhook timestamp");
        }
    }

    private String hmacSha256(byte[] value, String secret) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
            return HexFormat.of().formatHex(mac.doFinal(value));
        } catch (Exception exception) {
            throw new IllegalStateException("Cannot verify SePay webhook signature", exception);
        }
    }
}
