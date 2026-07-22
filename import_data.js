const sql = require('mssql');
const fs = require('fs');

const config = {
    user: 'sa',
    password: '1701652529',
    server: 'localhost',
    port: 1433,
    database: 'LUXURYPC',
    options: {
        encrypt: false,
        trustServerCertificate: true,
        enableArithAbort: true
    },
    pool: {
        max: 10,
        min: 0,
        idleTimeoutMillis: 30000
    }
};

const CATEGORY_MAP = {
    "CPU": 1,
    "VGA": 2, // Wait, DB had 2 as GPU and 9 as VGA. GearVN data might have category_id from GearVN. Let's rely on JSON's category_id, or map by name. The user's JSON has `category_id`.
    "RAM": 3,
    "Mainboard": 4,
    "SSD": 5, // Storage? DB has 5 as SSD, 7 as Storage, 10 as HDD.
    "PSU": 11,
    "Case": 12
};

async function getTableColumns(pool, tableName) {
    const result = await pool.request()
        .input('tableName', sql.NVarChar, tableName)
        .query(`SELECT column_name FROM information_schema.columns WHERE table_name = @tableName`);
    return result.recordset.map(r => r.column_name);
}

async function run() {
    let pool;
    try {
        pool = await sql.connect(config);
        console.log("Connected to SQL Server.");
    } catch(err) {
        console.error("Connection failed:", err);
        return;
    }

    // Load data
    const rawData = fs.readFileSync('gearvn_full_data_cleaned.json', 'utf8');
    const products = JSON.parse(rawData);

    // Get schemas
    const tables = ['cpu_specs', 'gpu_specs', 'mainboard_specs', 'ram_specs', 'psu_specs', 'case_specs', 'storage_specs', 'products', 'inventory'];
    const schemas = {};
    for (let table of tables) {
        schemas[table] = await getTableColumns(pool, table);
    }

    let report = {
        total_found: products.length,
        success: 0,
        failed: 0,
        duplicate: 0,
        missing_data: 0,
        start_time: new Date(),
        end_time: null,
        duration_sec: 0,
        errors: []
    };

    console.log(`Starting import of ${products.length} products...`);

    for (let i = 0; i < products.length; i++) {
        const item = products[i];
        
        const p = item.product;
        if (!p || !p.name || !p.price || !p.category_id) {
            report.missing_data++;
            report.failed++;
            continue;
        }

        let dbCategoryId = p.category_id;
        
        if(!dbCategoryId) {
            console.log(`Skipping ${p.name}, missing category_id`);
            report.failed++;
            report.errors.push(`Missing category_id for product ${p.name}`);
            continue;
        }

        // Start transaction for this product
        const transaction = new sql.Transaction(pool);
        try {
            await transaction.begin();
            const request = new sql.Request(transaction);

            // 1. Check Duplicate
            request.input('nameCheck', sql.NVarChar, p.name.substring(0, 255));
            const dupCheck = await request.query(`SELECT id FROM products WHERE name = @nameCheck`);
            if (dupCheck.recordset.length > 0) {
                report.duplicate++;
                report.success++;
                await transaction.rollback();
                continue;
            }

            // 2. Insert Product
            let price = p.price || 0;
            let stock = p.stock || 100;
            
            request.input('name', sql.NVarChar, p.name.substring(0, 255));
            request.input('price', sql.Float, price);
            request.input('description', sql.NVarChar, (p.description || '').substring(0, 4000));
            request.input('image', sql.NVarChar, (p.image || '').substring(0, 255));
            request.input('categoryId', sql.Int, dbCategoryId);
            request.input('stock', sql.Int, stock);
            request.input('brand', sql.NVarChar, (p.brand || '').substring(0, 255));
            request.input('createdAt', sql.DateTime2, new Date());

            const pResult = await request.query(`
                INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
                OUTPUT INSERTED.id
                VALUES (@name, @price, @description, @image, @categoryId, @stock, @brand, @createdAt)
            `);
            
            const productId = pResult.recordset[0].id;

            // 3. Insert Inventory
            const invRequest = new sql.Request(transaction);
            invRequest.input('productId', sql.Int, productId);
            invRequest.input('quantity', sql.Int, stock);
            invRequest.input('lastUpdate', sql.DateTime2, new Date());
            await invRequest.query(`
                INSERT INTO inventory (product_id, quantity, last_update)
                VALUES (@productId, @quantity, @lastUpdate)
            `);

            // 4. Insert Specs dynamically
            let specTable = null;
            if (dbCategoryId === 1) specTable = 'cpu_specs';
            else if (dbCategoryId === 2 || dbCategoryId === 9) specTable = 'gpu_specs';
            else if (dbCategoryId === 4) specTable = 'mainboard_specs';
            else if (dbCategoryId === 3) specTable = 'ram_specs';
            else if (dbCategoryId === 5 || dbCategoryId === 7) specTable = 'storage_specs';
            else if (dbCategoryId === 11) specTable = 'psu_specs';
            else if (dbCategoryId === 12) specTable = 'case_specs';

            if (specTable && item.specs && typeof item.specs === 'object') {
                const specCols = schemas[specTable];
                let insertFields = ['product_id'];
                let insertParams = ['@specProductId'];
                
                const specReq = new sql.Request(transaction);
                specReq.input('specProductId', sql.Int, productId);

                for (const [key, value] of Object.entries(item.specs)) {
                    if (value === null || value === 'null' || value === '') continue;

                    const cleanKey = key.toLowerCase();
                    if (specCols.includes(cleanKey) && cleanKey !== 'id' && cleanKey !== 'product_id') {
                        insertFields.push(cleanKey);
                        const paramName = 'param_' + cleanKey;
                        insertParams.push('@' + paramName);
                        
                        if(typeof value === 'number') {
                            specReq.input(paramName, sql.Float, value);
                        } else {
                            specReq.input(paramName, sql.NVarChar, String(value).substring(0, 255));
                        }
                    }
                }

                if (insertFields.length > 1) { // has at least one spec
                    const query = `INSERT INTO ${specTable} (${insertFields.join(', ')}) VALUES (${insertParams.join(', ')})`;
                    await specReq.query(query);
                }
            }

            await transaction.commit();
            report.success++;

        } catch(err) {
            console.error(`Error importing ${p.name}:`, err.message);
            try { await transaction.rollback(); } catch(e) {} // ignore rollback error if already aborted
            report.failed++;
            report.errors.push(`Product ${p.name}: ${err.message}`);
        }
    }

    report.end_time = new Date();
    report.duration_sec = (report.end_time - report.start_time) / 1000;

    console.log("Import completed.");
    console.log(`Success: ${report.success}, Failed: ${report.failed}, Duplicates: ${report.duplicate}`);

    // Create Markdown Report
    let md = `# Data Import Report (Direct SQL Injection)
**Thời gian thực hiện**: ${report.duration_sec} giây
**Thời gian bắt đầu**: ${report.start_time}
**Thời gian kết thúc**: ${report.end_time}

## Tóm tắt kết quả
- **Tổng sản phẩm (JSON)**: ${report.total_found}
- **Import Thành công**: ${report.success} (Bao gồm bỏ qua Duplicate an toàn)
- **Duplicate (Đã xử lý an toàn)**: ${report.duplicate}
- **Thất bại**: ${report.failed}
- **Thiếu dữ liệu**: ${report.missing_data}

## Chi tiết lỗi
`;
    if(report.errors.length > 0) {
        for(let e of report.errors.slice(0, 50)) {
            md += `- ${e}\n`;
        }
        if(report.errors.length > 50) md += `- ... và ${report.errors.length - 50} lỗi khác.\n`;
    } else {
        md += "Không có lỗi nào xảy ra trong quá trình Import.\n";
    }

    fs.writeFileSync('import_phase0_report.md', md);
    console.log("Report saved to import_phase0_report.md");

    await pool.close();
}

run();
