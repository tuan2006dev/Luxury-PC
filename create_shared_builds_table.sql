-- SQL script to create shared_builds table
-- Run this in your Supabase SQL editor if Hibernate's ddl-auto=update is not used.

CREATE TABLE IF NOT EXISTS shared_builds (
    share_code VARCHAR(15) PRIMARY KEY,
    name VARCHAR(100) DEFAULT 'Cấu hình chia sẻ từ LuxuryPC',
    case_id VARCHAR(50),
    mainboard_id VARCHAR(50),
    cpu_id VARCHAR(50),
    cooler_id VARCHAR(50),
    ram_id VARCHAR(50),
    gpu_id VARCHAR(50),
    psu_id VARCHAR(50),
    total_price DECIMAL(15,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
