package poly.edu.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "sepay")
public class SePayProperties {

    private final Webhook webhook = new Webhook();
    private final Bank bank = new Bank();
    private final PaymentCode paymentCode = new PaymentCode();

    public Webhook getWebhook() {
        return webhook;
    }

    public Bank getBank() {
        return bank;
    }

    public PaymentCode getPaymentCode() {
        return paymentCode;
    }

    public boolean hasBankConfiguration() {
        return hasText(bank.id) && hasText(bank.displayName) && hasText(bank.accountNumber) && hasText(bank.accountName);
    }

    public boolean hasWebhookSecret() {
        return hasText(webhook.secret);
    }

    private boolean hasText(String value) {
        return value != null && !value.isBlank();
    }

    public static class Webhook {
        private String secret;
        private long maxBodyBytes = 65_536L;
        private long allowedClockSkewSeconds = 300L;

        public String getSecret() {
            return secret;
        }

        public void setSecret(String secret) {
            this.secret = secret;
        }

        public long getMaxBodyBytes() {
            return maxBodyBytes;
        }

        public void setMaxBodyBytes(long maxBodyBytes) {
            this.maxBodyBytes = maxBodyBytes;
        }

        public long getAllowedClockSkewSeconds() {
            return allowedClockSkewSeconds;
        }

        public void setAllowedClockSkewSeconds(long allowedClockSkewSeconds) {
            this.allowedClockSkewSeconds = allowedClockSkewSeconds;
        }
    }

    public static class Bank {
        private String id;
        private String displayName;
        private String accountNumber;
        private String accountName;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getDisplayName() {
            return displayName;
        }

        public void setDisplayName(String displayName) {
            this.displayName = displayName;
        }

        public String getAccountNumber() {
            return accountNumber;
        }

        public void setAccountNumber(String accountNumber) {
            this.accountNumber = accountNumber;
        }

        public String getAccountName() {
            return accountName;
        }

        public void setAccountName(String accountName) {
            this.accountName = accountName;
        }
    }

    public static class PaymentCode {
        private String prefix = "DH";

        public String getPrefix() {
            return prefix;
        }

        public void setPrefix(String prefix) {
            this.prefix = prefix;
        }
    }
}
