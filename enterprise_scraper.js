const puppeteer = require('puppeteer');
const fs = require('fs');

const CONFIG = {
    CATEGORY_URL: 'https://gearvn.com/collections/cpu',
    CATEGORY_ID: 1, // 1: CPU, 2: GPU, 3: RAM...
    MAX_PRODUCTS: 10, // Giới hạn test 10 sản phẩm đầu
    OUTPUT_JSON: 'gearvn_cpu_data.json',
    ERROR_LOG: 'scraper_error.log'
};

// Hàm ghi log lỗi
function logError(url, reason) {
    const logEntry = `ERROR\nURL: ${url}\nReason: ${reason}\nStatus: SKIPPED\n--------------------------------\n`;
    fs.appendFileSync(CONFIG.ERROR_LOG, logEntry, 'utf8');
    console.log(`❌ SKIPPED: ${url} - ${reason}`);
}

// Hàm trích xuất dữ liệu từ một trang sản phẩm
async function scrapeProductPage(page, url) {
    await page.goto(url, { waitUntil: 'networkidle2', timeout: 60000 });

    // 1. Dùng hàm eval để lấy dữ liệu từ browser context
    const data = await page.evaluate(() => {
        let name = null, price = null, brand = null, image = null, description = null;

        // ƯU TIÊN 1: Lấy từ window.Haravan (GearVN dùng Haravan)
        if (window.Haravan && window.Haravan.product) {
            const p = window.Haravan.product;
            name = p.title;
            price = p.price; 
            brand = p.vendor;
            image = p.featured_image;
            description = p.description;
        } 
        // ƯU TIÊN 2: Lấy từ JSON-LD
        else {
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

        // ƯU TIÊN 3: Fallback DOM
        if (!name) {
            const titleEl = document.querySelector('h1');
            if (titleEl) name = titleEl.innerText.trim();
        }
        if (!price) {
            const priceEl = document.querySelector('.product-price');
            if (priceEl) price = parseInt(priceEl.innerText.replace(/[^0-9]/g, ''));
        }
        if (!brand) {
            brand = "Unknown";
        }
        if (!image) {
            const imgEl = document.querySelector('.product-image-feature');
            if (imgEl) image = imgEl.src;
        }

        // BÓC TÁCH THÔNG SỐ (CPU)
        let specs = {
            has_igpu: 0,
            includes_stock_cooler: 0,
            ram_type_supported: null,
            socket: null,
            tdp_max: null
        };

        const rows = document.querySelectorAll('tr, .spec-row, p, li');
        rows.forEach(row => {
            const text = row.innerText.toLowerCase();
            if (text.includes('socket')) {
                if (text.includes('1700')) specs.socket = 'LGA 1700';
                else if (text.includes('1200')) specs.socket = 'LGA 1200';
                else if (text.includes('am4')) specs.socket = 'AM4';
                else if (text.includes('am5')) specs.socket = 'AM5';
            }
            if (text.includes('tdp') || text.includes('công suất')) {
                const match = text.match(/(\d+)\s*w/i);
                if (match) specs.tdp_max = parseInt(match[1]);
            }
            if (text.includes('đồ họa') || text.includes('igpu') || text.includes('graphics')) {
                specs.has_igpu = text.includes('không') ? 0 : 1;
            }
        });

        // Chuẩn hóa giá trị
        if (price) {
            // Haravan prices are sometimes in cents, e.g. 469000000 for 4,690,000
            let pStr = price.toString();
            if (pStr.length > 9 && pStr.endsWith('00')) {
                 price = parseInt(pStr) / 100;
            }
            // If it's still concatenated like 46900004990000, split it
            pStr = price.toString();
            if (pStr.length > 10) {
                 price = parseInt(pStr.substring(0, pStr.length / 2));
            }
        }

        return { name, price, brand, image, description, specs };
    });

    return data;
}

// Hàm khởi chạy Crawler
async function run() {
    console.log("🚀 Bắt đầu Enterprise Crawler...");
    // Reset file log
    fs.writeFileSync(CONFIG.ERROR_LOG, '', 'utf8');

    const browser = await puppeteer.launch({ headless: "new", args: ['--no-sandbox'] });
    const page = await browser.newPage();
    
    // Fake User Agent
    await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');

    console.log(`🔎 Quét danh mục: ${CONFIG.CATEGORY_URL}`);
    await page.goto(CONFIG.CATEGORY_URL, { waitUntil: 'networkidle2' });

    // Cuộn trang để tải thêm sản phẩm
    for (let i = 0; i < 3; i++) {
        await page.evaluate(() => window.scrollBy(0, window.innerHeight));
        await new Promise(r => setTimeout(r, 1000));
    }

    // Lấy danh sách link sản phẩm
    const productLinks = await page.evaluate(() => {
        const links = [];
        const anchors = document.querySelectorAll('a');
        anchors.forEach(a => {
            if (a.href && a.href.includes('/products/') && !links.includes(a.href)) {
                links.push(a.href);
            }
        });
        return links;
    });

    console.log(`✅ Tìm thấy ${productLinks.length} sản phẩm. Tiến hành cào dữ liệu (giới hạn ${CONFIG.MAX_PRODUCTS})...`);

    const results = [];
    const targetLinks = productLinks.slice(0, CONFIG.MAX_PRODUCTS);

    for (let i = 0; i < targetLinks.length; i++) {
        const url = targetLinks[i];
        console.log(`⏳ Đang cào [${i + 1}/${targetLinks.length}]: ${url}`);
        
        try {
            const data = await scrapeProductPage(page, url);
            
            // ============================================
            // DATA QUALITY GATE (VALIDATION TRƯỚC KHI LƯU)
            // ============================================
            if (!data.name || data.name.trim() === '' || data.name === 'Unknown') {
                logError(url, "Tên sản phẩm rỗng hoặc Unknown");
                continue;
            }
            if (!data.price || isNaN(data.price) || data.price < 500000 || data.price > 100000000) {
                logError(url, `Giá không hợp lệ (Price: ${data.price}) - Không nằm trong ngưỡng an toàn 500k-100M`);
                continue;
            }
            if (!data.brand || data.brand.trim() === '' || data.brand === 'Unknown') {
                logError(url, "Brand rỗng hoặc Unknown");
                continue;
            }
            if (Array.isArray(data.image)) {
                data.image = data.image[0];
            }
            if (!data.image || (!data.image.includes('http') && !data.image.startsWith('//'))) {
                logError(url, "Ảnh không hợp lệ");
                continue;
            }
            // Normalize image URL
            if (data.image.startsWith('//')) {
                data.image = 'https:' + data.image;
            }

            // Chuẩn hóa Tên Brand (Normalize)
            data.brand = data.brand.toUpperCase().replace('INTEL', 'Intel').replace('AMD', 'AMD');

            // Định dạng output JSON
            results.push({
                product: {
                    name: data.name,
                    price: data.price,
                    description: data.description ? `<p>${data.name}</p>` : '', // Rút gọn mô tả demo
                    image: data.image,
                    category_id: CONFIG.CATEGORY_ID,
                    stock: 10, // Mặc định
                    brand: data.brand
                },
                specs: data.specs,
                source_url: url
            });

        } catch (err) {
            logError(url, `Lỗi kịch bản: ${err.message}`);
        }
    }

    await browser.close();

    // Xuất dữ liệu ra file JSON
    fs.writeFileSync(CONFIG.OUTPUT_JSON, JSON.stringify(results, null, 4), 'utf8');
    console.log(`🎉 HOÀN TẤT! Đã cào thành công ${results.length}/${targetLinks.length} sản phẩm.`);
    console.log(`📂 Dữ liệu hợp lệ: ${CONFIG.OUTPUT_JSON}`);
    console.log(`⚠️ Log lỗi (bị skip): ${CONFIG.ERROR_LOG}`);
}

run();
