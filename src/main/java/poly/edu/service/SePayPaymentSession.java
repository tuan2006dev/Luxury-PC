package poly.edu.service;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.VietQrPaymentSessionRepository;
import poly.edu.entity.Order;
import poly.edu.entity.VietQrPaymentSession;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.time.Duration;
import java.time.Instant;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Component
public class SePayPaymentSession {

    private static final String SESSION_ATTRIBUTE = "sepayPaymentTokens";
    public static final Duration QR_VALIDITY = Duration.ofMinutes(10);

    private final SecureRandom secureRandom = new SecureRandom();
    private final VietQrPaymentSessionRepository paymentSessionRepository;
    private final OrderDAO orderDAO;

    public SePayPaymentSession(
            VietQrPaymentSessionRepository paymentSessionRepository,
            OrderDAO orderDAO) {
        this.paymentSessionRepository = paymentSessionRepository;
        this.orderDAO = orderDAO;
    }

    public String issueToken(HttpSession session, String orderCode) {
        Map<String, String> tokens = tokens(session);
        return tokens.computeIfAbsent(orderCode, ignored -> createToken());
    }

    public String replaceToken(HttpSession session, String orderCode) {
        String token = createToken();
        tokens(session).put(orderCode, token);
        return token;
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

    @Transactional
    public PaymentWindow currentOrCreate(Integer orderId, Instant serverTime) {
        Order order = lockOrder(orderId);
        Optional<VietQrPaymentSession> current =
                paymentSessionRepository.findFirstByOrder_IdOrderByQrCreatedAtDescIdDesc(orderId);
        if (current.isPresent()) {
            markExpiredIfNeeded(current.get(), serverTime);
            return new PaymentWindow(current.get(), false);
        }
        return new PaymentWindow(createSession(order, serverTime), true);
    }

    @Transactional
    public PaymentWindow renew(Integer orderId, Instant serverTime) {
        Order order = lockOrder(orderId);
        Optional<VietQrPaymentSession> current =
                paymentSessionRepository.findFirstByOrder_IdOrderByQrCreatedAtDescIdDesc(orderId);
        current.ifPresent(paymentSession -> markExpiredIfNeeded(paymentSession, serverTime));
        return new PaymentWindow(createSession(order, serverTime), true);
    }

    @Transactional
    public Optional<VietQrPaymentSession> current(Integer orderId, Instant serverTime) {
        lockOrder(orderId);
        Optional<VietQrPaymentSession> current =
                paymentSessionRepository.findFirstByOrder_IdOrderByQrCreatedAtDescIdDesc(orderId);
        current.ifPresent(paymentSession -> markExpiredIfNeeded(paymentSession, serverTime));
        return current;
    }

    public Optional<VietQrPaymentSession> findSessionValidAt(Integer orderId, Instant paymentTime) {
        return paymentSessionRepository
                .findFirstByOrder_IdAndQrCreatedAtLessThanEqualAndQrExpiresAtGreaterThanOrderByQrCreatedAtDescIdDesc(
                        orderId,
                        paymentTime,
                        paymentTime);
    }

    public Optional<VietQrPaymentSession> latest(Integer orderId) {
        return paymentSessionRepository.findFirstByOrder_IdOrderByQrCreatedAtDescIdDesc(orderId);
    }

    public void markPaid(VietQrPaymentSession paymentSession, Instant paidAt) {
        paymentSession.setPaidAt(paidAt);
        paymentSessionRepository.save(paymentSession);
    }

    public void markExpired(VietQrPaymentSession paymentSession, Instant expiredAt) {
        if (paymentSession.getExpiredAt() == null) {
            paymentSession.setExpiredAt(expiredAt);
            paymentSessionRepository.save(paymentSession);
        }
    }

    public static boolean isExpired(VietQrPaymentSession paymentSession, Instant serverTime) {
        return paymentSession.getPaidAt() == null
                && !serverTime.isBefore(paymentSession.getQrExpiresAt());
    }

    public static long remainingSeconds(VietQrPaymentSession paymentSession, Instant serverTime) {
        long remainingMillis = Duration.between(serverTime, paymentSession.getQrExpiresAt()).toMillis();
        return remainingMillis <= 0 ? 0 : (remainingMillis + 999) / 1000;
    }

    private VietQrPaymentSession createSession(Order order, Instant serverTime) {
        VietQrPaymentSession paymentSession = new VietQrPaymentSession();
        paymentSession.setOrder(order);
        paymentSession.setQrCreatedAt(serverTime);
        paymentSession.setQrExpiresAt(serverTime.plus(QR_VALIDITY));
        return paymentSessionRepository.save(paymentSession);
    }

    private void markExpiredIfNeeded(VietQrPaymentSession paymentSession, Instant serverTime) {
        if (isExpired(paymentSession, serverTime) && paymentSession.getExpiredAt() == null) {
            paymentSession.setExpiredAt(serverTime);
            paymentSessionRepository.save(paymentSession);
        }
    }

    private Order lockOrder(Integer orderId) {
        return orderDAO.findByIdForUpdate(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Unknown VietQR order"));
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

    public record PaymentWindow(VietQrPaymentSession session, boolean created) {
    }
}
