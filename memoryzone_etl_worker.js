const puppeteer = require('puppeteer');
const fs = require('fs');
const cheerio = require('cheerio');

const DB_OUTPUT_FILE = '03_Insert_MemoryZone_Data.sql';

const MZ_CATEGORIES = [
    { id: 4, name: 'Mainboard', url: 'https://memoryzone.com.vn/mainboard-bo-mach-chu' },
    { id: 5, name: 'SSD', url: 'https://memoryzone.com.vn/o-cung-ssd' }
];

function escapeSql(str) {
    if (!str) return 'NULL';
    return `N'${str.replace(/'/g, "''")}'`;
}

function normalizeName(name) {
    if (!name) return "";
    return name.toLowerCase().replace(/[^a-z0-9]/g, '').trim();
}

async function runMemoryZoneCrawler() {
    console.log("==========================================================================");
    console.log("🌟 KHỞI ĐỘNG CỖ MÁY MULTI-VENDOR - NGUỒN: MEMORYZONE");
    console.log("==========================================================================\n");

    const browser = await puppeteer.launch({ 
        headless: "new",
        args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-gpu']
    });

    fs.writeFileSync(DB_OUTPUT_FILE, `-- MULTI-VENDOR DB LOADER (MEMORYZONE)\nBEGIN TRANSACTION;\nBEGIN TRY\n`, 'utf8');

    for (const cat of MZ_CATEGORIES) {
        console.log(`\n======================================================`);
        console.log(`🔍 [START] Cào MemoryZone: ${cat.name} - ${cat.url}`);
        
        const page = await browser.newPage();
        await page.setViewport({ width: 1366, height: 768 });
        await page.setRequestInterception(true);
        page.on('request', (req) => {
            if(['image', 'stylesheet', 'font', 'media'].includes(req.resourceType())) req.abort();
            else req.continue();
        });

        await page.goto(cat.url, { waitUntil: 'domcontentloaded', timeout: 60000 });
        
        // Cuộn để nạp ảnh/js
        for (let i = 0; i < 5; i++) {
            await page.evaluate(() => window.scrollBy(0, document.body.scrollHeight));
            await new Promise(r => setTimeout(r, 1000));
        }

        const productUrls = await page.evaluate(() => {
            const links = [];
            // MemoryZone dùng class .product-name a hoặc .item_product_main .image_thumb
            document.querySelectorAll('.item_product_main a.image_thumb').forEach(a => {
                if (a.href) links.push(a.href);
            });
            return links;
        });

        console.log(`🎯 Tìm thấy ${productUrls.length} link tiềm năng từ MemoryZone.`);

        let sqlStatements = [];

        for (let i = 0; i < productUrls.length && i < 20; i++) { // Lấy 20 SP demo cho nhanh
            const url = productUrls[i];
            try {
                // Thử dùng API .js của Sapo (Giống Haravan)
                const apiUrl = url.endsWith('.js') ? url : url + '.js';
                const response = await fetch(apiUrl);
                
                let title, sku, price, vendor, slug, mpn;
                let specsEAV = [];

                if (response.ok) {
                    const rawData = await response.json();
                    title = rawData.name || rawData.title;
                    sku = rawData.variants && rawData.variants.length > 0 ? rawData.variants[0].sku : rawData.alias;
                    price = rawData.price ? parseInt(rawData.price) : 0;
                    vendor = rawData.vendor || "Unknown";
                    slug = rawData.alias;
                } else {
                    // Nếu Sapo khóa API, fallback sang DOM bóc tay
                    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });
                    const domData = await page.evaluate(() => {
                        const t = document.querySelector('h1.title-product')?.innerText || '';
                        const p = document.querySelector('.price-box .special-price .price')?.innerText.replace(/[^0-9]/g, '') || '0';
                        const v = document.querySelector('.vendor span')?.innerText || 'Unknown';
                        const s = document.querySelector('.sku-product span')?.innerText || '';
                        return { title: t, price: parseInt(p), vendor: v, sku: s };
                    });
                    title = domData.title;
                    price = domData.price;
                    vendor = domData.vendor;
                    sku = domData.sku || "MZ-" + Math.floor(Math.random()*10000);
                    slug = url.substring(url.lastIndexOf('/') + 1);
                }

                if (!title) continue;

                mpn = `MZ-${normalizeName(title).substring(0, 15)}`; // Demo MPN for MemoryZone

                const specsJsonStr = escapeSql(JSON.stringify(specsEAV));
                
                const sql = `
-- [MemoryZone] [${cat.name}] Product: ${title}
MERGE INTO products AS target
USING (SELECT ${cat.id} as category_id, 1 as brand_id, ${escapeSql(title)} as name, ${escapeSql(slug)} as slug, ${escapeSql(sku)} as sku, ${escapeSql(mpn)} as mpn, ${price} as price, ${specsJsonStr} as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');
`;
                sqlStatements.push(sql);
                if ((i+1) % 5 === 0) console.log(`   ...Đã xử lý ${i+1}/${Math.min(productUrls.length, 20)}`);
            } catch (e) {
                // Bỏ qua lỗi
            }
        }

        fs.appendFileSync(DB_OUTPUT_FILE, sqlStatements.join('\n'), 'utf8');
        await page.close();
    }

    fs.appendFileSync(DB_OUTPUT_FILE, `\nCOMMIT TRANSACTION;\nPRINT '✅ MemoryZone Import Thành Công!';\nEND TRY\nBEGIN CATCH\nROLLBACK TRANSACTION;\nPRINT ERROR_MESSAGE();\nEND CATCH;\n`, 'utf8');
    console.log(`\n🎉🎉🎉 HOÀN TẤT CÀO MEMORYZONE! Dữ liệu SQL lưu tại ${DB_OUTPUT_FILE}`);
    await browser.close();
}

runMemoryZoneCrawler();
