const fs = require('fs');

const INPUT_FILE = 'gearvn_cpu_enriched.json';
const OUTPUT_FILE = '01_Insert_Data.sql';

function escapeSql(str) {
    if (!str) return 'NULL';
    return `N'${str.replace(/'/g, "''")}'`;
}

async function runDatabaseLoader() {
    console.log("🚀 Bắt đầu tiến trình DATABASE LOADER (Tạo Script SQL chuẩn Enterprise)");

    if (!fs.existsSync(INPUT_FILE)) {
        console.error(`❌ Không tìm thấy file ${INPUT_FILE}. Vui lòng chạy luồng Enrichment trước.`);
        return;
    }

    const data = JSON.parse(fs.readFileSync(INPUT_FILE, 'utf8'));
    console.log(`[INFO] Đã load ${data.length} sản phẩm từ file Enriched.`);

    let sqlLines = [
        `-- ==============================================================================`,
        `-- ENTERPRISE DATA PLATFORM - AUTOMATED IMPORT SCRIPT`,
        `-- GENERATED AT: ${new Date().toISOString()}`,
        `-- ==============================================================================`,
        ``,
        `BEGIN TRANSACTION;`,
        `BEGIN TRY`,
        ``
    ];

    for (let i = 0; i < data.length; i++) {
        const p = data[i];
        const categoryId = 1; // 1 = CPU (Dựa trên bảng Categories Seed)
        let brandId = 1; // 1 = Intel, 2 = AMD
        if (p.classification.brand.toUpperCase() === 'AMD') brandId = 2;

        console.log(`[PROCESS] Đang build SQL cho sản phẩm: ${p.identifiers.sku}`);

        // JSON Cache stringify
        const specsJsonStr = escapeSql(JSON.stringify(p.specs_eav || []));

        sqlLines.push(`-- Product: ${p.content.display_name}`);
        
        // Cú pháp MERGE cực mạnh của SQL Server (Chống trùng tự động theo SKU/MPN)
        sqlLines.push(`
MERGE INTO products AS target
USING (SELECT 
    ${categoryId} as category_id, 
    ${brandId} as brand_id, 
    ${escapeSql(p.content.display_name)} as name, 
    ${escapeSql(p.identifiers.model)} as slug, 
    ${escapeSql(p.identifiers.sku)} as sku, 
    ${escapeSql(p.identifiers.mpn)} as mpn, 
    ${p.retail.price} as price,
    ${specsJsonStr} as specs_json
) AS source
ON (target.sku = source.sku OR (target.mpn = source.mpn AND target.mpn IS NOT NULL))
WHEN MATCHED THEN 
    UPDATE SET 
        price = source.price,
        specs_json = source.specs_json,
        updated_at = GETDATE()
WHEN NOT MATCHED THEN 
    INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status, created_at, updated_at)
    VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE', GETDATE(), GETDATE());
`);

        // Ghi nhận lịch sử giá vào product_versions (Để vẽ biểu đồ)
        sqlLines.push(`
DECLARE @productId BIGINT;
SELECT @productId = id FROM products WHERE sku = ${escapeSql(p.identifiers.sku)};

INSERT INTO product_versions (product_id, field_changed, new_value, source_domain, changed_at)
VALUES (@productId, 'price', ${p.retail.price}, ${escapeSql(p.retail.source_domain)}, GETDATE());
`);

        // Update Inventory bằng Stored Procedure đã tạo ở Step trước
        sqlLines.push(`
EXEC sp_merge_product_inventory 
    @ProductId = @productId, 
    @SourceDomain = ${escapeSql(p.retail.source_domain)}, 
    @Quantity = 10, 
    @Price = ${p.retail.price};
`);
    }

    sqlLines.push(`
    COMMIT TRANSACTION;
    PRINT '✅ Import dữ liệu thành công hoàn toàn!';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT '❌ Lỗi xảy ra trong quá trình Import:';
    PRINT ERROR_MESSAGE();
END CATCH;
`);

    fs.writeFileSync(OUTPUT_FILE, sqlLines.join('\n'), 'utf8');
    console.log(`\n🎉 HOÀN TẤT DATABASE LOADER! Kịch bản SQL đã lưu tại: ${OUTPUT_FILE}`);
}

runDatabaseLoader();
