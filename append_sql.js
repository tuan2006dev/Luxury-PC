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
    "VGA": 9,
    "RAM": 3,
    "Mainboard": 4,
    "SSD": 5,
    "PSU": 11,
    "Case": 12
};

function escapeSql(str) {
    if (str === null || str === undefined) return 'NULL';
    if (typeof str === 'number') return str;
    return "N'" + String(str).replace(/'/g, "''") + "'";
}

async function getTableColumns(pool, tableName) {
    const result = await pool.request()
        .input('tableName', sql.NVarChar, tableName)
        .query(`SELECT column_name FROM information_schema.columns WHERE table_name = @tableName`);
    return result.recordset.map(r => r.column_name);
}

async function run() {
    let pool = await sql.connect(config);
    const rawData = fs.readFileSync('gearvn_full_data_cleaned.json', 'utf8');
    const products = JSON.parse(rawData);

    const tables = ['cpu_specs', 'gpu_specs', 'mainboard_specs', 'ram_specs', 'psu_specs', 'case_specs', 'storage_specs'];
    const schemas = {};
    for (let table of tables) {
        schemas[table] = await getTableColumns(pool, table);
    }
    
    let sqlOut = `\n-- ======================================================\n`;
    sqlOut += `-- BATCH IMPORT FOR GEARVN DATA (Generated)\n`;
    sqlOut += `-- ======================================================\n`;
    sqlOut += `DECLARE @current_pid INT;\n`;

    let count = 0;
    for (let i = 0; i < products.length; i++) {
        const item = products[i];
        const p = item.product;
        
        if (!p || !p.name || !p.price || !p.category_id) continue;
        let dbCategoryId = p.category_id;
        if(!dbCategoryId) continue;

        sqlOut += `\n-- Product: ${p.name}\n`;
        sqlOut += `INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)\n`;
        sqlOut += `VALUES (${escapeSql(p.name)}, ${p.price || 0}, ${escapeSql((p.description || '').substring(0, 4000))}, ${escapeSql((p.image || '').substring(0, 255))}, ${dbCategoryId}, ${p.stock || 100}, ${escapeSql((p.brand || '').substring(0, 255))}, GETDATE());\n`;
        sqlOut += `SET @current_pid = SCOPE_IDENTITY();\n`;

        sqlOut += `INSERT INTO inventory (product_id, quantity, last_update)\n`;
        sqlOut += `VALUES (@current_pid, ${p.stock || 100}, GETDATE());\n`;

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
            let insertValues = ['@current_pid'];
            
            for (const [key, value] of Object.entries(item.specs)) {
                if (value === null || value === 'null' || value === '') continue;

                const cleanKey = key.toLowerCase();
                if (specCols.includes(cleanKey) && cleanKey !== 'id' && cleanKey !== 'product_id') {
                    insertFields.push(cleanKey);
                    if(typeof value === 'number') {
                        insertValues.push(value);
                    } else {
                        insertValues.push(escapeSql(String(value).substring(0, 255)));
                    }
                }
            }
            if (insertFields.length > 1) {
                sqlOut += `INSERT INTO ${specTable} (${insertFields.join(', ')}) VALUES (${insertValues.join(', ')});\n`;
            }
        }
        count++;
    }

    sqlOut += `\nGO\n`;
    fs.appendFileSync('fixed.sql', sqlOut);
    console.log(`Successfully appended ${count} products to fixed.sql`);

    await pool.close();
}

run().catch(console.error);
