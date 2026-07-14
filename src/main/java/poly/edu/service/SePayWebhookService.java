package poly.edu.service;

import java.io.IOException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import poly.edu.config.SePayProperties;
import poly.edu.dao.OrderDAO;
import poly.edu.dao.SePayTransactionRepository;
import poly.edu.dto.SePayWebhookPayload;
import poly.edu.entity.Order;
import poly.edu.entity.SePayTransaction;

import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.Locale;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class SePayWebhookService {

    private final ObjectMapper objectMapper;
    private final SePaySignatureVerifier signatureVerifier;
    private final SePayProperties sePayProperties;
    private final SePayTransactionRepository transactionRepository;
    private final OrderDAO orderDAO;

    public SePayWebhookService(
            ObjectMapper objectMapper,
            SePaySignatureVerifier signatureVerifier,
            SePayProperties sePayProperties,
            SePayTransactionRepository transactionRepository,
            OrderDAO orderDAO) {
        this.objectMapper = objectMapper;
        this.signatureVerifier = signatureVerifier;
        this.sePayProperties = sePayProperties;
        this.transactionRepository = transactionRepository;
        this.orderDAO = orderDAO;
    }

    @Transactional
    public void process(String signature, String timestamp, byte[] rawBody) {
        signatureVerifier.verify(signature, timestamp, rawBody);
        SePayWebhookPayload payload = parsePayload(rawBody);
        validateRequiredFields(payload);

        if (transactionRepository.existsBySepayTransactionId(payload.id())) {
            return;
        }

        String resolvedOrderCode = resolveOrderCode(payload);
        SePayTransaction transaction = newTransaction(payload, resolvedOrderCode, rawBody);
        try {
            transactionRepository.saveAndFlush(transaction);
        } catch (DataIntegrityViolationException exception) {
            if (isDuplicateTransactionIdViolation(exception)) {
                throw new SePayDuplicateTransactionException();
            }
            throw exception;
        }

        if (!"in".equalsIgnoreCase(payload.transferType())) {
            markProcessed(transaction, "REJECTED_TRANSFER_TYPE");
            return;
        }

        if (!sePayProperties.hasBankConfiguration()) {
            markProcessed(transaction, "REJECTED_CONFIGURATION");
            return;
        }

        if (!Objects.equals(sePayProperties.getBank().getAccountNumber(), payload.accountNumber())) {
            markProcessed(transaction, "REJECTED_ACCOUNT_MISMATCH");
            return;
        }

        if (resolvedOrderCode == null) {
            markProcessed(transaction, "REJECTED_PAYMENT_CODE");
            return;
        }

        Optional<Order> orderOptional = orderDAO.findByOrderCodeForUpdate(resolvedOrderCode);
        if (orderOptional.isEmpty()) {
            markProcessed(transaction, "REJECTED_ORDER_NOT_FOUND");
            return;
        }

        Order order = orderOptional.get();
        if (!"VIETQR".equals(order.getPaymentMethod())) {
            markProcessed(transaction, "REJECTED_PAYMENT_METHOD");
            return;
        }

        long expectedAmount = Math.round(order.getTotalPrice());
        if (!Objects.equals(payload.transferAmount(), expectedAmount)) {
            markProcessed(transaction, "REJECTED_AMOUNT_MISMATCH");
            return;
        }

        if ("DA_THANH_TOAN".equals(order.getStatus()) || "PAID".equals(order.getStatus())) {
            markProcessed(transaction, "IGNORED_ORDER_ALREADY_PAID");
            return;
        }

        if (!"CHO_XAC_NHAN_THANH_TOAN".equals(order.getStatus())) {
            markProcessed(transaction, "REJECTED_ORDER_STATUS");
            return;
        }

        order.setStatus("DA_THANH_TOAN");
        orderDAO.save(order);
        markProcessed(transaction, "PAID");
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

    private SePayTransaction newTransaction(SePayWebhookPayload payload, String orderCode, byte[] rawBody) {
        SePayTransaction transaction = new SePayTransaction();
        transaction.setSepayTransactionId(payload.id());
        transaction.setOrderCode(orderCode);
        transaction.setTransferAmount(payload.transferAmount());
        transaction.setTransferType(payload.transferType());
        transaction.setAccountNumber(payload.accountNumber());
        transaction.setPaymentCode(payload.code());
        transaction.setProcessingStatus("RECEIVED");
        transaction.setRawPayload(new String(rawBody, StandardCharsets.UTF_8));
        transaction.setReceivedAt(Instant.now());
        return transaction;
    }

    private void markProcessed(SePayTransaction transaction, String status) {
        transaction.setProcessingStatus(status);
        transaction.setProcessedAt(Instant.now());
        transactionRepository.save(transaction);
    }

    private String resolveOrderCode(SePayWebhookPayload payload) {
        if (hasText(payload.code())) {

            return isStrictPaymentCode(payload.code()) ? normalize(payload.code()) : null;
        }

        Set<String> candidates = new LinkedHashSet<>();
        candidates.addAll(extractPaymentCodes(payload.content()));
        candidates.addAll(extractPaymentCodes(payload.description()));
        return candidates.size() == 1 ? candidates.iterator().next() : null;
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

    private boolean isStrictPaymentCode(String value) {
        if (!isValidPrefix()) {
            return false;
        }
        String prefix = normalize(sePayProperties.getPaymentCode().getPrefix());
        return Pattern.compile("^" + Pattern.quote(prefix) + "[0-9]+$").matcher(normalize(value)).matches();
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
        Throwable current = exception;
        while (current != null) {
            if (current instanceof org.hibernate.exception.ConstraintViolationException constraintViolation
                    && isTransactionIdConstraint(constraintViolation.getConstraintName())) {
                return true;
            }
            if (current instanceof SQLException sqlException
                    && "23505".equals(sqlException.getSQLState())
                    && isTransactionIdConstraint(sqlException.getMessage())) {
                return true;
            }
            current = current.getCause();
        }
        return false;
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
