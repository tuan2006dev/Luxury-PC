-- Manual PostgreSQL migration for production. This project does not run a migration engine automatically.
-- Run this script once through the production database migration process before enabling the SePay webhook.

CREATE TABLE IF NOT EXISTS sepay_transactions (
    id BIGSERIAL PRIMARY KEY,
    sepay_transaction_id BIGINT NOT NULL,
    order_code VARCHAR(100),
    transfer_amount BIGINT NOT NULL,
    transfer_type VARCHAR(16) NOT NULL,
    account_number VARCHAR(100),
    payment_code VARCHAR(100),
    processing_status VARCHAR(64) NOT NULL,
    raw_payload TEXT NOT NULL,
    received_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT uk_sepay_transactions_transaction_id UNIQUE (sepay_transaction_id)
);

CREATE INDEX IF NOT EXISTS idx_sepay_transactions_order_code
    ON sepay_transactions (order_code);
