const sql = require('mssql');
const fs = require('fs');

const config = {
    user: 'sa',
    password: '1701652529',
    server: 'localhost',
    database: 'LUXURYPC',
    options: {
        encrypt: false,
        trustServerCertificate: true
    }
};

async function getSchemas() {
    try {
        await sql.connect(config);
        const result = await sql.query(`
            SELECT table_name, column_name, data_type 
            FROM information_schema.columns 
            WHERE table_name IN ('cpu_specs', 'gpu_specs', 'mainboard_specs', 'ram_specs', 'psu_specs', 'case_specs', 'storage_specs')
        `);
        
        let schema = {};
        for(let row of result.recordset) {
            if(!schema[row.table_name]) schema[row.table_name] = [];
            schema[row.table_name].push(row.column_name);
        }
        
        fs.writeFileSync('db_schemas.json', JSON.stringify(schema, null, 2));
        console.log("Schemas extracted to db_schemas.json");
    } catch (err) {
        console.error(err);
    } finally {
        await sql.close();
    }
}

getSchemas();
