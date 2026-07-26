package poly.edu.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.config.SePayProperties;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.SePayTransactionRepository;
import poly.edu.dto.SePayWebhookPayload;
import poly.edu.entity.Order;
import poly.edu.entity.SePayTransaction;
import poly.edu.entity.VietQrPaymentSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.time.Clock;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoField;
import java.util.ArrayDeque;
import java.util.Collections;
import java.util.Deque;
import java.util.IdentityHashMap;
import java.util.LinkedHashSet;
import java.util.Locale;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class SePayWebhookService {

    private static final Logger logger = LoggerFactory.getLogger(SePayWebhookService.class);
    private static final ZoneId SEPAY_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");
    private static final DateTimeFormatter SEPAY_LOCAL_DATE_TIME =
            new DateTimeFormatterBuilder()
                    .appendPattern("uuuu-MM-dd HH:mm:ss")
                    .optionalStart()
                    .appendFraction(ChronoField.NANO_OF_SECOND, 0, 9, true)
                    .optionalEnd()
                    .toFormatter(Locale.ROOT);

    private final ObjectMapper objectMapper;
    private final SePaySignatureVerifier signatureVerifier;
    private final SePayProperties sePayProperties;
    private final SePayTransactionRepository transactionRepository;
    private final OrderDAO orderDAO;
    private final SePayPaymentSession sePayPaymentSession;
    private final Clock clock;

    @Autowired
    public SePayWebhookService(
            ObjectMapper objectMapper,
            SePaySignatureVerifier signatureVerifier,
            SePayProperties sePayProperties,
            SePayTransactionRepository transactionRepository,
            OrderDAO orderDAO,
            SePayPaymentSession sePayPaymentSession) {
        this(
                objectMapper,
                signatureVerifier,
                sePayProperties,
                transactionRepository,
                orderDAO,
                sePayPaymentSession,
                Clock.systemUTC());
    }

    public SePayWebhookService(
            ObjectMapper objectMapper,
            SePaySignatureVerifier signatureVerifier,
            SePayProperties sePayProperties,
            SePayTransactionRepository transactionRepository,
            OrderDAO orderDAO,
            SePayPaymentSession sePayPaymentSession,
            Clock clock) {
        this.objectMapper = objectMapper;
        this.signatureVerifier = signatureVerifier;
        this.sePayProperties = sePayProperties;
        this.transactionRepository = transactionRepository;
        this.orderDAO = orderDAO;
        this.sePayPaymentSession = sePayPaymentSession;
        this.clock = clock;
    }

    @Transactional
    public SePayWebhookResult process(String signature, String timestamp, byte[] rawBody) {
        Instant webhookReceivedAt = clock.instant();
        signatureVerifier.verify(signature, timestamp, rawBody);
        SePayWebhookPayload payload = parsePayload(rawBody);
        validateRequiredFields(payload);

        if (transactionRepository.existsBySepayTransactionId(payload.id())) {
            return SePayWebhookResult.DUPLICATE;
        }

        Optional<Instant> transactionDate = parseTransactionDate(payload.transactionDate());
        String fallbackReason = fallbackReason(payload.transactionDate(), transactionDate);
        String paymentCode = resolvePaymentCode(payload);
        SePayTransaction transaction =
                newTransaction(payload, paymentCode, rawBody, webhookReceivedAt, transactionDate.orElse(null));
        try {
            transactionRepository.saveAndFlush(transaction);
        } catch (DataIntegrityViolationException exception) {
            if (isDuplicateTransactionIdViolation(exception)) {
                throw new SePayDuplicateTransactionException();
            }
            throw exception;
        }

        if (fallbackReason != null) {
            logger.warn(
                    "SePay transaction {} uses webhookReceivedAt because transactionDate is {}",
                    payload.id(),
                    fallbackReason);
        }

        if (!"in".equalsIgnoreCase(payload.transferType())) {
            markProcessed(transaction, "REJECTED_TRANSFER_TYPE");
            return SePayWebhookResult.BAD_REQUEST;
        }

        if (!sePayProperties.hasBankConfiguration()) {
            throw new IllegalStateException("SePay bank configuration is missing");
        }

        if (!Objects.equals(sePayProperties.getBank().getAccountNumber(), payload.accountNumber())) {
            markProcessed(transaction, "REJECTED_ACCOUNT_MISMATCH");
            return SePayWebhookResult.BAD_REQUEST;
        }

        Integer orderId = parseOrderId(paymentCode);
        if (orderId == null) {
            markProcessed(transaction, "REJECTED_PAYMENT_CODE");
            return SePayWebhookResult.BAD_REQUEST;
        }

        Optional<Order> orderOptional = orderDAO.findByIdForUpdate(orderId);
        if (orderOptional.isEmpty()) {
            markProcessed(transaction, "REJECTED_ORDER_NOT_FOUND");
            return SePayWebhookResult.ORDER_NOT_FOUND;
        }

        Order order = orderOptional.get();
        transaction.setOrderCode(order.getOrderCode());
        if (!"VIETQR".equals(order.getPaymentMethod())) {
            markProcessed(transaction, "REJECTED_PAYMENT_METHOD");
            return SePayWebhookResult.BAD_REQUEST;
        }

        long expectedAmount = exactOrderAmount(order);
        if (!Objects.equals(payload.transferAmount(), expectedAmount)) {
            markProcessed(transaction, "REJECTED_AMOUNT_MISMATCH");
            return SePayWebhookResult.BAD_REQUEST;
        }

        if ("DA_THANH_TOAN".equals(order.getStatus()) || "PAID".equals(order.getStatus())) {
            markProcessed(transaction, "IGNORED_ORDER_ALREADY_PAID");
            return SePayWebhookResult.ORDER_CONFLICT;
        }

        if (!"CHO_XAC_NHAN_THANH_TOAN".equals(order.getStatus())) {
            markProcessed(transaction, "REJECTED_ORDER_STATUS");
            return SePayWebhookResult.ORDER_CONFLICT;
        }

        Instant effectivePaymentTime = transactionDate.orElse(webhookReceivedAt);
        Optional<VietQrPaymentSession> validSession =
                sePayPaymentSession.findSessionValidAt(order.getId(), effectivePaymentTime);
        if (validSession.isEmpty()) {
            Optional<VietQrPaymentSession> latestSession = sePayPaymentSession.latest(order.getId());
            if (latestSession.isEmpty()) {
                markProcessed(transaction, "REJECTED_QR_SESSION_MISSING");
                return SePayWebhookResult.ORDER_CONFLICT;
            }

            // Equality belongs to the expired side: valid sessions require paymentTime < qrExpiresAt.
            if (!webhookReceivedAt.isBefore(latestSession.get().getQrExpiresAt())) {
                sePayPaymentSession.markExpired(latestSession.get(), webhookReceivedAt);
            }
            markProcessed(transaction, expiredProcessingStatus(fallbackReason));
            return SePayWebhookResult.EXPIRED;
        }

        order.setStatus("DA_THANH_TOAN");
        orderDAO.save(order);
        sePayPaymentSession.markPaid(validSession.get(), webhookReceivedAt);
        markProcessed(transaction, paidProcessingStatus(fallbackReason));
        return SePayWebhookResult.PROCESSED;
    }

    public static Optional<Instant> parseTransactionDate(String value) {
        if (value == null || value.isBlank()) {
            return Optional.empty();
        }

        String normalized = value.trim();
        try {
            return Optional.of(Instant.parse(normalized));
        } catch (DateTimeParseException ignored) {
            // SePay normally sends local wall-clock time, but accept explicit offsets when supplied.
        }
        try {
            return Optional.of(OffsetDateTime.parse(normalized).toInstant());
        } catch (DateTimeParseException ignored) {
            // Continue with SePay's documented Asia/Ho_Chi_Minh local timestamp shape.
        }
        try {
            return Optional.of(LocalDateTime.parse(normalized, SEPAY_LOCAL_DATE_TIME)
                    .atZone(SEPAY_ZONE)
                    .toInstant());
        } catch (DateTimeParseException ignored) {
            return Optional.empty();
        }
    }

    private SePayWebhookPayload parsePayload(byte[] rawBody) {
        try {
            return objectMapper.readValue(rawBody, SePayWebhookPayload.class);
        } catch (IOException exception) {
            throw new IllegalArgumentException("Invalid SePay webhook JSON");
        }
    }

    private void validateRequiredFields(SePayWebhookPayload payload) {
        if (payload == null || payload.id() == null || payload.id() <= 0
                || payload.transferAmount() == null || payload.transferAmount() <= 0
                || !hasText(payload.accountNumber()) || !hasText(payload.transferType())) {
            throw new IllegalArgumentException("Invalid SePay webhook payload");
        }
    }

    private SePayTransaction newTransaction(
            SePayWebhookPayload payload,
            String paymentCode,
            byte[] rawBody,
            Instant webhookReceivedAt,
            Instant transactionDate) {
        SePayTransaction transaction = new SePayTransaction();
        transaction.setSepayTransactionId(payload.id());
        transaction.setTransferAmount(payload.transferAmount());
        transaction.setTransferType(payload.transferType());
        transaction.setAccountNumber(payload.accountNumber());
        transaction.setPaymentCode(paymentCode);
        transaction.setProcessingStatus("RECEIVED");
        transaction.setRawPayload(new String(rawBody, StandardCharsets.UTF_8));
        transaction.setTransactionDate(transactionDate);
        transaction.setWebhookReceivedAt(webhookReceivedAt);
        return transaction;
    }

    private void markProcessed(SePayTransaction transaction, String status) {
        transaction.setProcessingStatus(status);
        transaction.setProcessedAt(clock.instant());
        transactionRepository.save(transaction);
    }

    private String fallbackReason(String rawTransactionDate, Optional<Instant> transactionDate) {
        if (transactionDate.isPresent()) {
            return null;
        }
        return rawTransactionDate == null || rawTransactionDate.isBlank() ? "missing" : "invalid";
    }

    private String paidProcessingStatus(String fallbackReason) {
        if ("missing".equals(fallbackReason)) {
            return "PAID_FALLBACK_MISSING_TRANSACTION_DATE";
        }
        if ("invalid".equals(fallbackReason)) {
            return "PAID_FALLBACK_INVALID_TRANSACTION_DATE";
        }
        return "PAID";
    }

    private String expiredProcessingStatus(String fallbackReason) {
        if ("missing".equals(fallbackReason)) {
            return "REJECTED_QR_EXPIRED_FALLBACK_MISSING_DATE";
        }
        if ("invalid".equals(fallbackReason)) {
            return "REJECTED_QR_EXPIRED_FALLBACK_INVALID_DATE";
        }
        return "REJECTED_QR_EXPIRED";
    }

    private String resolvePaymentCode(SePayWebhookPayload payload) {
        Set<String> candidates = new LinkedHashSet<>();
        candidates.addAll(extractPaymentCodes(payload.code()));
        candidates.addAll(extractPaymentCodes(payload.content()));
        return candidates.size() == 1 ? candidates.iterator().next() : null;
    }

    private long exactOrderAmount(Order order) {
        Double totalPrice = order.getTotalPrice();
        if (totalPrice == null || !Double.isFinite(totalPrice) || totalPrice <= 0) {
            throw new IllegalStateException("Order total is invalid");
        }
        try {
            return BigDecimal.valueOf(totalPrice).longValueExact();
        } catch (ArithmeticException exception) {
            throw new IllegalStateException("Order total is not an exact VND amount", exception);
        }
    }

    private Integer parseOrderId(String paymentCode) {
        if (paymentCode == null || !isValidPrefix()) {
            return null;
        }
        String prefix = normalize(sePayProperties.getPaymentCode().getPrefix());
        if (!paymentCode.startsWith(prefix) || paymentCode.length() == prefix.length()) {
            return null;
        }
        try {
            int orderId = Integer.parseInt(paymentCode.substring(prefix.length()));
            return orderId > 0 ? orderId : null;
        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private Set<String> extractPaymentCodes(String value) {
        Set<String> matches = new LinkedHashSet<>();
        if (!hasText(value) || !isValidPrefix()) {
            return matches;
        }

        String prefix = normalize(sePayProperties.getPaymentCode().getPrefix());
        Pattern pattern = Pattern.compile("(?<![A-Z0-9])(" + Pattern.quote(prefix) + "[0-9]+)(?![A-Z0-9])");
        Matcher matcher = pattern.matcher(normalize(value));
        while (matcher.find()) {
            matches.add(matcher.group(1));
        }
        return matches;
    }

    private boolean isValidPrefix() {
        String prefix = sePayProperties.getPaymentCode().getPrefix();
        return prefix != null && prefix.matches("[A-Za-z0-9]{1,20}");
    }

    private String normalize(String value) {
        return value.trim().toUpperCase(Locale.ROOT);
    }

    private boolean hasText(String value) {
        return value != null && !value.isBlank();
    }

    private boolean isDuplicateTransactionIdViolation(DataIntegrityViolationException exception) {
        Deque<Throwable> pending = new ArrayDeque<>();
        Set<Throwable> visited = Collections.newSetFromMap(new IdentityHashMap<>());
        boolean duplicateKeyViolation = false;
        boolean transactionIdConstraint = false;
        pending.add(exception);

        while (!pending.isEmpty()) {
            Throwable current = pending.removeFirst();
            if (!visited.add(current)) {
                continue;
            }

            if (current instanceof org.hibernate.exception.ConstraintViolationException constraintViolation
                    && isTransactionIdConstraint(constraintViolation.getConstraintName())) {
                transactionIdConstraint = true;
            }
            if (current instanceof SQLException sqlException) {
                duplicateKeyViolation |= isSupportedDuplicateKeyViolation(sqlException);
                transactionIdConstraint |= isTransactionIdConstraint(sqlException.getMessage());
                if (sqlException.getNextException() != null) {
                    pending.addLast(sqlException.getNextException());
                }
            }
            if (current.getCause() != null) {
                pending.addLast(current.getCause());
            }
        }

        return duplicateKeyViolation && transactionIdConstraint;
    }

    private boolean isSupportedDuplicateKeyViolation(SQLException exception) {
        if ("23505".equals(exception.getSQLState())) {
            return true;
        }
        int errorCode = exception.getErrorCode();
        return "23000".equals(exception.getSQLState())
                && (errorCode == 2601 || errorCode == 2627);
    }

    private boolean isTransactionIdConstraint(String value) {
        if (value == null) {
            return false;
        }
        String normalized = value.toLowerCase(Locale.ROOT);
        return normalized.contains("uk_sepay_transactions_transaction_id")
                || normalized.contains("sepay_transaction_id");
    }
}
