const puppeteer = require('puppeteer');
const fs = require('fs');
const cheerio = require('cheerio');
const process = require('process');

const STATE_FILE = 'pipeline_state.json';
const DB_OUTPUT_FILE = '02_Insert_Master_Data.sql';

const CATEGORIES = [
    { id: 4, name: 'Mainboard', url: 'https://gearvn.com/collections/mainboard', typeFilter: [] },
    { id: 6, name: 'HDD', url: 'https://gearvn.com/collections/hdd', typeFilter: [] },
    { id: 12, name: 'Case', url: 'https://gearvn.com/collections/case-vo-may-tinh', typeFilter: [] },
    { id: 13, name: 'Cooler', url: 'https://gearvn.com/collections/tan-nhiet-cooling', typeFilter: [] },
    { id: 18, name: 'Speaker', url: 'https://gearvn.com/collections/loa-may-tinh', typeFilter: [] },
    { id: 22, name: 'Sound Card', url: 'https://gearvn.com/collections/sound-card', typeFilter: [] },
    { id: 23, name: 'Capture Card', url: 'https://gearvn.com/collections/capture-card', typeFilter: [] },
    { id: 24, name: 'Controller', url: 'https://gearvn.com/collections/phu-kien-may-tinh', typeFilter: [] },
    { id: 25, name: 'Cable', url: 'https://gearvn.com/collections/day-cap-tin-hieu', typeFilter: [] },
    { id: 27, name: 'Thermal Paste', url: 'https://gearvn.com/collections/kem-tan-nhiet', typeFilter: [] }
];

let state = {
    currentIndex: 0,
    processedCategories: [],
    lastUpdate: new Date().toISOString()
};

let isShuttingDown = false;

// 1. Quản lý Trạng thái (Checkpoint)
function loadState() {
    if (fs.existsSync(STATE_FILE)) {
        try {
            state = JSON.parse(fs.readFileSync(STATE_FILE, 'utf8'));
            console.log(`[STATE] Đã nạp Checkpoint! Tiếp tục từ danh mục thứ ${state.currentIndex + 1} (${CATEGORIES[state.currentIndex]?.name || 'Hoàn tất'})`);
        } catch (e) {
            console.log(`[WARN] File Checkpoint lỗi, sẽ bắt đầu lại từ đầu.`);
        }
    }
}

function saveState() {
    state.lastUpdate = new Date().toISOString();
    fs.writeFileSync(STATE_FILE, JSON.stringify(state, null, 4), 'utf8');
}

// Bắt tín hiệu Ctrl+C
process.on('SIGINT', async () => {
    console.log(`\n⚠️ [SHUTDOWN] Đã nhận lệnh Tạm dừng (Ctrl+C). Đang lưu Checkpoint an toàn...`);
    isShuttingDown = true;
    saveState();
    console.log(`✅ [SHUTDOWN] Trạng thái đã được lưu. Lần tới chạy lại sẽ bắt đầu từ đây. Thoát.`);
    process.exit(0);
});

// Các hàm Helpers (Từ Worker cũ)
function normalizeName(name) {
    if (!name) return "";
    return name.toLowerCase().replace(/chính hãng/g, '').replace(/box/g, '').replace(/tray/g, '').replace(/[^a-z0-9]/g, '').trim();
}

function generateSmartMPN(brand, normalizedName) {
    if (brand.toUpperCase() === "INTEL") {
        const match = normalizedName.match(/core(i\d)(.*)/i);
        if (match) return `BX80715${match[2].replace(/[^0-9a-z]/ig, '').toUpperCase()}`;
    } else if (brand.toUpperCase() === "AMD") {
        const match = normalizedName.match(/ryzen(\d)(.*)/i);
        if (match) return `100-100000${match[2].replace(/[^0-9a-z]/ig, '').toUpperCase()}`;
    }
    return `GENERIC-${Math.floor(Math.random()*100000)}`;
}

function escapeSql(str) {
    if (!str) return 'NULL';
    return `N'${str.replace(/'/g, "''")}'`;
}

// Lõi ETL
async function processCategory(cat) {
    console.log(`\n======================================================`);
    console.log(`🔍 [START] Xử lý danh mục: ${cat.name} - ${cat.url}`);
    
    // Giai đoạn 1: Khởi tạo Puppeteer (Tắt CSS, Image để vượt WAF)
    const browser = await puppeteer.launch({ 
        headless: "new",
        args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage', '--disable-accelerated-2d-canvas', '--disable-gpu']
    });
    
    const page = await browser.newPage();
    await page.setViewport({ width: 1366, height: 768 });
    await page.setRequestInterception(true);
    page.on('request', (req) => {
        if(['image', 'stylesheet', 'font', 'media'].includes(req.resourceType())) req.abort();
        else req.continue();
    });

    console.log(`⏳ Đang cuộn trang để lấy toàn bộ link...`);
    await page.goto(cat.url, { waitUntil: 'domcontentloaded', timeout: 60000 });
    
    // Cuộn siêu sâu để kích hoạt Infinite Scroll
    for (let i = 0; i < 15; i++) {
        if (isShuttingDown) break;
        await page.evaluate(() => window.scrollBy(0, document.body.scrollHeight));
        await new Promise(r => setTimeout(r, 1500));
    }

    const productUrls = await page.evaluate(() => {
        const links = [];
        document.querySelectorAll('a').forEach(a => {
            if (a.href && a.href.includes('/products/') && !links.includes(a.href)) links.push(a.href);
        });
        return links;
    });

    await browser.close();
    console.log(`🎯 Tìm thấy ${productUrls.length} link tiềm năng.`);

    let validProducts = [];
    let sqlStatements = [];

    // Giai đoạn 2: Extract & Enrich (Cào JSON & Bóc EAV)
    for (let i = 0; i < productUrls.length; i++) {
        if (isShuttingDown) break;
        const url = productUrls[i];
        
        try {
            const apiUrl = url.endsWith('.js') ? url : url + '.js';
            const response = await fetch(apiUrl);
            if (!response.ok) continue;
            
            const rawData = await response.json();
            if (!rawData || !rawData.handle) continue;

            // Bỏ bộ lọc khắt khe, vét toàn bộ sản phẩm trong danh mục
            // const productType = rawData.type ? rawData.type.toLowerCase() : "";
            // const isValid = cat.typeFilter.some(filter => productType.includes(filter));
            // if (!isValid) continue; 


            // ENRICHMENT
            let sku = rawData.variants && rawData.variants.length > 0 ? rawData.variants[0].sku : rawData.handle;
            const price = rawData.price ? parseInt(rawData.price) / 100 : 0;
            const brand = rawData.vendor || 'Unknown';
            const normName = normalizeName(rawData.title);
            const mpn = generateSmartMPN(brand, normName);
            
            const specsEAV = [];
            if (rawData.description) {
                const $ = cheerio.load(rawData.description);
                $('tr').each((index, element) => {
                    const tds = $(element).find('td');
                    if (tds.length >= 2) {
                        specsEAV.push({ key: $(tds[0]).text().trim(), value: $(tds[1]).text().trim() });
                    }
                });
            }

            // LOAD (Tạo câu lệnh SQL luôn, tránh lưu file JSON trung gian khổng lồ)
            const specsJsonStr = escapeSql(JSON.stringify(specsEAV));
            const sql = `
-- [${cat.name}] Product: ${rawData.title}
MERGE INTO products AS target
USING (SELECT ${cat.id} as category_id, 1 as brand_id, ${escapeSql(rawData.title)} as name, ${escapeSql(rawData.handle)} as slug, ${escapeSql(sku)} as sku, ${escapeSql(mpn)} as mpn, ${price} as price, ${specsJsonStr} as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');
`;
            sqlStatements.push(sql);
            validProducts.push(sku);

            if ((i+1) % 10 === 0) console.log(`   ...Đã xử lý ${i+1}/${productUrls.length}`);
        } catch (e) {
            // Bỏ qua lỗi mạng cục bộ
        }
    }

    // Ghi nối tiếp vào file SQL Master
    if (sqlStatements.length > 0) {
        fs.appendFileSync(DB_OUTPUT_FILE, sqlStatements.join('\n'), 'utf8');
    }
    
    console.log(`✅ [DONE] Đã chèn ${validProducts.length} sản phẩm thực tế vào file SQL Master.`);
    
    // Đánh dấu hoàn thành danh mục
    state.processedCategories.push(cat.name);
    state.currentIndex++;
    saveState();
}

async function startMasterPipeline() {
    console.log("==========================================================================");
    console.log("🌟 KHỞI ĐỘNG CỖ MÁY MASTER ETL PIPELINE (RESUMABLE) - SCALE 25 CATEGORIES");
    console.log("💡 Nhấn [Ctrl + C] bất cứ lúc nào để Tạm dừng an toàn (Save Checkpoint).");
    console.log("==========================================================================\n");

    loadState();

    // Sinh Header cho file SQL nếu chạy từ đầu
    if (state.currentIndex === 0) {
        fs.writeFileSync(DB_OUTPUT_FILE, `-- MASTER DB LOADER SCRIPT\nBEGIN TRANSACTION;\nBEGIN TRY\n`, 'utf8');
    }

    for (let i = state.currentIndex; i < CATEGORIES.length; i++) {
        if (isShuttingDown) break;
        await processCategory(CATEGORIES[i]);
    }

    if (!isShuttingDown) {
        fs.appendFileSync(DB_OUTPUT_FILE, `\nCOMMIT TRANSACTION;\nPRINT '✅ Master Import Thành Công!';\nEND TRY\nBEGIN CATCH\nROLLBACK TRANSACTION;\nPRINT ERROR_MESSAGE();\nEND CATCH;\n`, 'utf8');
        console.log(`\n🎉🎉🎉 HOÀN TẤT TOÀN BỘ 25 DANH MỤC! Dữ liệu SQL khổng lồ đã lưu tại ${DB_OUTPUT_FILE}`);
        fs.unlinkSync(STATE_FILE); // Xóa Checkpoint vì đã xong
    }
}

startMasterPipeline();
