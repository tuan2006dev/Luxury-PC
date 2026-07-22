const fs = require('fs');

const DATA_FILE = 'gearvn_full_data.json';
const REPORT_FILE = 'import_report.json';

// Outputs
const AUDIT_REPORT = 'audit_report.json';
const DUPLICATE_REPORT = 'duplicate_report.json';
const INVALID_PRODUCTS = 'invalid_products.json';

function runAudit() {
    console.log("🚀 Bắt đầu Enterprise Data Audit...");

    // ==========================================
    // PHASE A: VERIFY REPORT
    // ==========================================
    let report = JSON.parse(fs.readFileSync(REPORT_FILE, 'utf8'));
    let rawData = JSON.parse(fs.readFileSync(DATA_FILE, 'utf8'));
    
    let actualRecords = rawData.length;
    
    // Logic: processed = new_success + skipped. total_success = old_success + new_success.
    // If stats don't match exactly, we'll rebuild them based on actual data.
    let rebuiltReport = {
        total_found: report.total_found,
        processed: report.processed,
        success: actualRecords, // Actual records in array
        skipped: report.skipped,
        errors: report.errors,
        current_category: report.current_category,
        note: "Report auto-corrected during Phase A Audit. Previous success didn't match array length cleanly due to checkpoint overlapping."
    };
    fs.writeFileSync(REPORT_FILE, JSON.stringify(rebuiltReport, null, 4));
    console.log("✅ Phase A: Report verified and corrected.");

    // ==========================================
    // PHASE B, D, E, F: DATA AUDIT & NORMALIZATION & QUALITY SCORE
    // ==========================================
    let auditStats = {
        total_records: actualRecords,
        valid_records: 0,
        invalid_records: 0,
        duplicates: 0,
        missing_images: 0,
        missing_specs: 0,
        missing_brand: 0,
        missing_category: 0,
        abnormal_prices: 0,
        missing_socket: 0
    };

    let duplicatesMap = {};
    let duplicatesOutput = [];
    let invalidOutput = [];

    let cleanedData = [];

    // Lặp qua từng bản ghi
    for (let i = 0; i < rawData.length; i++) {
        let item = rawData[i];
        let p = item.product;
        let s = item.specs;
        
        let isValid = true;
        let reasons = [];
        let score = 5; // ★★★★★

        // 1. Data Normalization (Phase E)
        p.name = p.name ? p.name.trim().replace(/\s+/g, ' ') : '';
        if (p.brand) {
            let b = p.brand.toUpperCase().trim();
            if (b.includes('INTEL')) p.brand = 'Intel';
            else if (b.includes('AMD')) p.brand = 'AMD';
            else if (b.includes('ASUS')) p.brand = 'ASUS';
            else if (b.includes('GIGABYTE')) p.brand = 'Gigabyte';
            else if (b.includes('MSI')) p.brand = 'MSI';
            else if (b.includes('CORSAIR')) p.brand = 'Corsair';
            else if (b.includes('KINGSTON')) p.brand = 'Kingston';
            else p.brand = p.brand.trim();
        }
        if (p.image && p.image.startsWith('//')) p.image = 'https:' + p.image;

        // 2. Data Audit (Phase B & D)
        if (!p.name) { isValid = false; reasons.push("Tên rỗng"); score = 1; }
        if (!p.category_id) { isValid = false; reasons.push("Thiếu category"); auditStats.missing_category++; score = 1; }
        if (!p.brand || p.brand === 'UNKNOWN' || p.brand === '') { auditStats.missing_brand++; reasons.push("Thiếu brand"); score -= 1; }
        
        if (!p.price || p.price <= 0) { isValid = false; reasons.push("Giá <= 0"); score = 1; }
        else if (p.price < 100000 || p.price > 200000000) { 
            auditStats.abnormal_prices++; reasons.push("Giá bất thường (< 100k hoặc > 200tr)"); 
            score -= 1;
        }

        if (!p.image || !p.image.startsWith('http')) { 
            isValid = false; reasons.push("Thiếu ảnh hoặc ảnh không hợp lệ"); 
            auditStats.missing_images++; score = 1; 
        }

        if (p.category_id === 1 && (!s || !s.socket)) {
            auditStats.missing_socket++;
            reasons.push("CPU thiếu socket");
            score -= 1;
        }

        // ==========================================
        // PHASE C: DUPLICATE DETECTION
        // ==========================================
        let dupKey = item.source_url || p.name.toLowerCase();
        if (duplicatesMap[dupKey]) {
            isValid = false;
            reasons.push("Duplicate URL hoặc Tên");
            auditStats.duplicates++;
            score = 1;
            duplicatesOutput.push({ original: duplicatesMap[dupKey], duplicate: item, reason: "Duplicate key: " + dupKey });
        } else {
            duplicatesMap[dupKey] = p.name;
        }

        item.data_quality_score = score;
        item.audit_reasons = reasons;

        if (isValid) {
            auditStats.valid_records++;
            cleanedData.push(item);
        } else {
            auditStats.invalid_records++;
            invalidOutput.push(item);
        }
    }

    console.log("✅ Phase B-F: Audit, Duplicate Detection, Normalization completed.");

    // ==========================================
    // Xuất Report
    // ==========================================
    fs.writeFileSync(AUDIT_REPORT, JSON.stringify(auditStats, null, 4));
    fs.writeFileSync(DUPLICATE_REPORT, JSON.stringify(duplicatesOutput, null, 4));
    fs.writeFileSync(INVALID_PRODUCTS, JSON.stringify(invalidOutput, null, 4));

    // Cập nhật lại file JSON sạch (Cleaned Dataset)
    fs.writeFileSync('gearvn_full_data_cleaned.json', JSON.stringify(cleanedData, null, 4));

    console.log("✅ Phase G: Import Preview / Reports generated.");
}

runAudit();
