const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

const CONFIG = {
    OUTPUT_JSON: 'gearvn_full_data.json',
    ERROR_LOG: 'scraper_error_full.log',
    REPORT_JSON: 'import_report.json',
    REPORT_MD: 'progress_report.md',
    MAX_RETRIES: 3,
    CHECKPOINT_INTERVAL: 50,
    REPORT_INTERVAL: 100,
    CATEGORIES: [
        { url: 'https://gearvn.com/collections/cpu', id: 1, name: 'CPU' },
        { url: 'https://gearvn.com/collections/vga', id: 2, name: 'VGA' },
        { url: 'https://gearvn.com/collections/mainboard', id: 4, name: 'Mainboard' },
        { url: 'https://gearvn.com/collections/ram', id: 3, name: 'RAM' },
        { url: 'https://gearvn.com/collections/ssd', id: 5, name: 'SSD' },
        { url: 'https://gearvn.com/collections/psu-nguon-may-tinh', id: 11, name: 'PSU' },
        { url: 'https://gearvn.com/collections/case-vo-may-tinh', id: 12, name: 'Case' }
    ]
};

let stats = {
    total_found: 0,
    processed: 0,
    success: 0,
    skipped: 0,
    errors: 0,
    current_category: ''
};

// 1. Load Resume Checkpoint
let allResults = [];
let processedUrls = new Set();
if (fs.existsSync(CONFIG.OUTPUT_JSON)) {
    try {
        const raw = fs.readFileSync(CONFIG.OUTPUT_JSON, 'utf8');
        allResults = JSON.parse(raw);
        allResults.forEach(item => processedUrls.add(item.source_url));
        console.log(`[INFO] Đã load checkpoint: ${allResults.length} sản phẩm.`);
        stats.success = allResults.length;
    } catch (e) {
        console.log(`[WARN] Không thể đọc checkpoint: ${e.message}`);
    }
}

function logMsg(level, msg) {
    const ts = new Date().toISOString();
    const line = `[${ts}] [${level}] ${msg}`;
    console.log(line);
    if (level === 'ERROR') {
        fs.appendFileSync(CONFIG.ERROR_LOG, line + '\n', 'utf8');
    }
}

function saveState() {
    fs.writeFileSync(CONFIG.OUTPUT_JSON, JSON.stringify(allResults, null, 4), 'utf8');
    fs.writeFileSync(CONFIG.REPORT_JSON, JSON.stringify(stats, null, 4), 'utf8');
    const md = `# Tiến độ cào dữ liệu GearVN
- **Cập nhật**: ${new Date().toLocaleString()}
- **Danh mục đang xử lý**: ${stats.current_category}
- **Tổng link tìm thấy**: ${stats.total_found}
- **Đã xử lý**: ${stats.processed}
- **Thành công**: ${stats.success}
- **Bỏ qua (Duplicate/Lỗi data)**: ${stats.skipped}
- **Lỗi kỹ thuật (Max retries)**: ${stats.errors}
`;
    fs.writeFileSync(CONFIG.REPORT_MD, md, 'utf8');
}

async function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

// 2. Hàm cào dữ liệu 1 trang
async function scrapeProductPage(page, url, categoryId) {
    await page.goto(url, { waitUntil: 'networkidle2', timeout: 60000 });
    
    // Đợi một chút để JS render thêm nếu cần
    await sleep(1500);

    const data = await page.evaluate((categoryId) => {
        let name = null, price = null, brand = null, image = null, description = null;

        if (window.Haravan && window.Haravan.product) {
            const p = window.Haravan.product;
            name = p.title;
            price = p.price; 
            brand = p.vendor;
            image = p.featured_image;
        } else {
            const ldJsonScripts = document.querySelectorAll('script[type="application/ld+json"]');
            for (let script of ldJsonScripts) {
                try {
                    const json = JSON.parse(script.innerText);
                    if (json['@type'] === 'Product') {
                        name = name || json.name;
                        brand = brand || (json.brand && json.brand.name);
                        image = image || json.image;
                        if (json.offers && json.offers.price) {
                            price = price || parseInt(json.offers.price);
                        }
                    }
                } catch (e) { }
            }
        }

        if (!name) {
            const titleEl = document.querySelector('h1');
            if (titleEl) name = titleEl.innerText.trim();
        }
        if (!price) {
            const priceEl = document.querySelector('.product-price');
            if (priceEl) price = parseInt(priceEl.innerText.replace(/[^0-9]/g, ''));
        }
        if (!brand) brand = "Unknown";

        if (Array.isArray(image)) image = image[0];
        if (image && image.startsWith('//')) image = 'https:' + image;

        if (price) {
            let pStr = price.toString();
            if (pStr.length > 9 && pStr.endsWith('00')) price = parseInt(pStr) / 100;
            pStr = price.toString();
            if (pStr.length > 10) price = parseInt(pStr.substring(0, pStr.length / 2));
        }

        // Bóc tách thông số chung dựa theo Text Content
        let specs = {};
        const allText = document.body.innerText.toLowerCase();
        
        if (categoryId === 1) { // CPU
            specs = { has_igpu: 0, includes_stock_cooler: 0, ram_type_supported: null, socket: null, tdp_max: null };
            if (allText.includes('1700')) specs.socket = 'LGA 1700';
            else if (allText.includes('1851')) specs.socket = 'LGA 1851';
            else if (allText.includes('am4')) specs.socket = 'AM4';
            else if (allText.includes('am5')) specs.socket = 'AM5';
            const tdpMatch = allText.match(/(\d+)\s*w/i);
            if (tdpMatch) specs.tdp_max = parseInt(tdpMatch[1]);
            if (allText.includes('igpu') || allText.includes('đồ họa tích hợp')) specs.has_igpu = 1;
        } else if (categoryId === 2) { // VGA
            specs = { length_mm: null, pcie12vhpwr_required: 0, pcie8pin_required: 0, power_consumption_tdp: null, thickness_mm: null };
            const lenMatch = allText.match(/(\d+)\s*mm/);
            if (lenMatch) specs.length_mm = parseInt(lenMatch[1]);
            if (allText.includes('16-pin') || allText.includes('12vhpwr')) specs.pcie12vhpwr_required = 1;
            if (allText.includes('8-pin')) specs.pcie8pin_required = 1;
        } else if (categoryId === 4) { // Mainboard
            specs = { cpu_power_connectors: null, form_factor: null, ram_slots: null, ram_type: null, socket: null };
            if (allText.includes('ddr5')) specs.ram_type = 'DDR5';
            else if (allText.includes('ddr4')) specs.ram_type = 'DDR4';
            if (allText.includes('atx')) specs.form_factor = 'ATX';
            if (allText.includes('micro-atx') || allText.includes('m-atx')) specs.form_factor = 'Micro-ATX';
        }

        return { name, price, brand, image, specs };
    }, categoryId);

    return data;
}

// 3. Hàm cào có retry (Exponential Backoff)
async function scrapeWithRetry(page, url, categoryId) {
    let attempt = 0;
    while (attempt < CONFIG.MAX_RETRIES) {
        try {
            return await scrapeProductPage(page, url, categoryId);
        } catch (error) {
            attempt++;
            logMsg('WARN', `Lỗi cào ${url} (Lần ${attempt}/${CONFIG.MAX_RETRIES}): ${error.message}`);
            if (attempt >= CONFIG.MAX_RETRIES) {
                logMsg('ERROR', `Đã đạt giới hạn retry cho ${url}. Lỗi: ${error.message}`);
                throw error;
            }
            const delay = Math.pow(2, attempt) * 2000; // 4s, 8s...
            logMsg('INFO', `Chờ ${delay}ms để retry...`);
            await sleep(delay);
        }
    }
}

async function run() {
    logMsg('INFO', "🚀 Khởi động Enterprise ETL Pipeline (Puppeteer)...");
    
    const browser = await puppeteer.launch({ 
        headless: "new", 
        args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage', '--disable-accelerated-2d-canvas', '--disable-gpu'] 
    });
    const page = await browser.newPage();
    await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');
    await page.setViewport({ width: 1366, height: 768 });

    // Tắt tải ảnh, css, fonts để tăng tốc độ và độ ổn định
    await page.setRequestInterception(true);
    page.on('request', (req) => {
        if(['image', 'stylesheet', 'font', 'media'].includes(req.resourceType())){
            req.abort();
        }
        else {
            req.continue();
        }
    });

    for (const cat of CONFIG.CATEGORIES) {
        stats.current_category = cat.name;
        logMsg('INFO', `\n==============================================`);
        logMsg('INFO', `🔎 Đang phân tích Danh mục: ${cat.name} (${cat.url})`);
        
        try {
            await page.goto(cat.url, { waitUntil: 'domcontentloaded', timeout: 60000 });

            // Trích xuất link sản phẩm (Cuộn trang vài lần)
            for (let i = 0; i < 8; i++) {
                await page.evaluate(() => window.scrollBy(0, document.body.scrollHeight));
                await sleep(1000);
            }

            const productLinks = await page.evaluate(() => {
                const links = [];
                document.querySelectorAll('a').forEach(a => {
                    if (a.href && a.href.includes('/products/') && !links.includes(a.href)) {
                        links.push(a.href);
                    }
                });
                return links;
            });

            stats.total_found += productLinks.length;
            logMsg('INFO', `✅ Lấy được ${productLinks.length} sản phẩm trong ${cat.name}.`);

            for (let i = 0; i < productLinks.length; i++) {
                const url = productLinks[i];
                stats.processed++;

                if (processedUrls.has(url)) {
                    logMsg('INFO', `⏭️ Đã tồn tại trong checkpoint, bỏ qua: ${url}`);
                    stats.skipped++;
                    continue;
                }

                logMsg('INFO', `[${cat.name}] ⏳ Cào [${i + 1}/${productLinks.length}]: ${url}`);
                
                try {
                    const data = await scrapeWithRetry(page, url, cat.id);

                    // Validation Rules
                    if (!data.name || data.name.trim() === '' || data.name === 'Unknown') {
                        logMsg('WARN', `URL: ${url} - Tên không hợp lệ`);
                        stats.skipped++;
                        continue;
                    }
                    if (!data.price || isNaN(data.price) || data.price <= 0) {
                        logMsg('WARN', `URL: ${url} - Giá không hợp lệ: ${data.price}`);
                        stats.skipped++;
                        continue;
                    }
                    if (!data.image || !data.image.includes('http')) {
                        logMsg('WARN', `URL: ${url} - Ảnh không hợp lệ`);
                        stats.skipped++;
                        continue;
                    }

                    let brand = data.brand ? data.brand.toUpperCase() : "UNKNOWN";
                    if(brand.includes('INTEL')) brand = 'Intel';
                    if(brand.includes('AMD')) brand = 'AMD';

                    allResults.push({
                        product: {
                            name: data.name, 
                            price: data.price, 
                            description: "",
                            image: data.image, 
                            category_id: cat.id, 
                            stock: 10, 
                            brand: brand
                        },
                        specs: data.specs,
                        source_url: url
                    });
                    
                    processedUrls.add(url);
                    stats.success++;

                    // Checkpoint Data
                    if (stats.success > 0 && stats.success % CONFIG.CHECKPOINT_INTERVAL === 0) {
                        logMsg('INFO', `💾 Lưu Checkpoint... (${stats.success} sản phẩm)`);
                        saveState();
                    }

                    // Báo cáo Tiến độ
                    if (stats.processed % CONFIG.REPORT_INTERVAL === 0) {
                        logMsg('INFO', `📊 Báo cáo: Xử lý ${stats.processed}/${stats.total_found} | Thành công: ${stats.success} | Bỏ qua: ${stats.skipped} | Lỗi: ${stats.errors}`);
                    }

                } catch (e) {
                    stats.errors++;
                }
            }
        } catch (e) {
            logMsg('ERROR', `❌ Lỗi danh mục ${cat.name}: ${e.message}`);
        }
    }

    await browser.close();
    saveState();
    logMsg('INFO', `\n🎉 HOÀN TẤT CHIẾN DỊCH GOAL! Tổng thành công: ${stats.success} sản phẩm.`);
}

run();
