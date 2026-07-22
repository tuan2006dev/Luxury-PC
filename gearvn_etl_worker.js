const puppeteer = require('puppeteer');
const fs = require('fs');

const CONFIG = {
    CATEGORY_URL: 'https://gearvn.com/collections/cpu',
    OUTPUT_FILE: 'gearvn_cpu_etl_results.json',
    MAX_PRODUCTS: 50 // Limit for testing Phase 1
};

// Hàm Normalize Tên Sản Phẩm để chống trùng
function normalizeName(name) {
    if (!name) return "";
    return name.toLowerCase()
        .replace(/chính hãng/g, '')
        .replace(/box/g, '')
        .replace(/tray/g, '')
        .replace(/[^a-z0-9]/g, '') // Bỏ mọi ký tự đặc biệt và khoảng trắng
        .trim();
}

async function runETL() {
    console.log("🚀 Bắt đầu tiến trình ETL (Extract - Transform - Load) - Layer 3: GearVN");
    
    const browser = await puppeteer.launch({ 
        headless: "new",
        args: ['--no-sandbox', '--disable-setuid-sandbox'] 
    });
    
    const page = await browser.newPage();
    await page.setViewport({ width: 1366, height: 768 });

    // Tắt tải resource không cần thiết để vượt WAF và tăng tốc
    await page.setRequestInterception(true);
    page.on('request', (req) => {
        if(['image', 'stylesheet', 'font', 'media'].includes(req.resourceType())){
            req.abort();
        } else {
            req.continue();
        }
    });

    console.log(`\n[DISCOVERY] Đang quét danh mục: ${CONFIG.CATEGORY_URL}`);
    await page.goto(CONFIG.CATEGORY_URL, { waitUntil: 'domcontentloaded' });

    // Cuộn trang để Load More (Discovery) - Mô phỏng user cuộn sâu xuống đáy
    for (let i = 0; i < 8; i++) {
        await page.evaluate(() => window.scrollBy(0, document.body.scrollHeight));
        await new Promise(r => setTimeout(r, 1500));
    }

    const productUrls = await page.evaluate(() => {
        const links = [];
        document.querySelectorAll('a').forEach(a => {
            if (a.href && a.href.includes('/products/') && !links.includes(a.href)) {
                links.push(a.href);
            }
        });
        return links;
    });

    console.log(`[DISCOVERY] Tìm thấy ${productUrls.length} sản phẩm. (Lấy tối đa ${CONFIG.MAX_PRODUCTS} test)`);
    
    const urlsToProcess = productUrls.slice(0, CONFIG.MAX_PRODUCTS);
    const etlResults = [];

    for (let i = 0; i < urlsToProcess.length; i++) {
        const url = urlsToProcess[i];
        console.log(`[EXTRACT] Đang bóc tách (${i+1}/${urlsToProcess.length}): ${url}`);
        
        try {
            // Thay vì dùng Puppeteer để mở trang (chậm), ta gọi thẳng API ẩn của Haravan bằng fetch
            const apiUrl = url.endsWith('.js') ? url : url + '.js';
            const response = await fetch(apiUrl);
            
            if (!response.ok) {
                console.log(`[WARN] Lỗi HTTP ${response.status} khi gọi API tại ${url}`);
                continue;
            }

            const rawData = await response.json();

            if (!rawData || !rawData.handle) {
                console.log(`[WARN] Không lấy được JSON hợp lệ tại ${url}`);
                continue;
            }

            // Bộ lọc: Chỉ lấy đúng sản phẩm thuộc Category CPU (để tránh rác từ Mega Menu)
            const productType = rawData.type ? rawData.type.toLowerCase() : "";
            if (!productType.includes("cpu") && !productType.includes("vi xử lý") && !productType.includes("processor")) {
                 console.log(`[SKIP] Bỏ qua vì không phải CPU (Loại thực tế: ${rawData.type})`);
                 continue;
            }

            // ==========================================
            // TRANSFORM STEP (Chuẩn hóa về Enterprise DTO)
            // ==========================================
            let sku = rawData.variants && rawData.variants.length > 0 ? rawData.variants[0].sku : null;
            if (!sku || sku.trim() === '') sku = rawData.handle; // Fallback to slug if no SKU

            const price = rawData.price ? parseInt(rawData.price) / 100 : 0; 
            
            // Xử lý ảnh: Lọc CDN URL
            let image = rawData.featured_image;
            if (image && image.startsWith('//')) {
                image = 'https:' + image;
            }

            // Enterprise DTO Format
            const productDTO = {
                identifiers: {
                    sku: sku,
                    mpn: null, // MPN thường không có sẵn ở Layer 3, sẽ Enrich ở Layer 1 sau
                    model: rawData.handle // Slug
                },
                classification: {
                    brand: rawData.vendor,
                    category: rawData.type
                },
                content: {
                    display_name: rawData.title,
                    normalized_name: normalizeName(rawData.title),
                    description_html: rawData.description // Cache toàn bộ HTML vào specs_json sau
                },
                retail: {
                    source_url: url,
                    source_domain: "gearvn.com",
                    price: price,
                    stock_status: rawData.available ? "IN_STOCK" : "OUT_OF_STOCK"
                }
            };

            etlResults.push(productDTO);

        } catch (error) {
            console.log(`[ERROR] Bỏ qua ${url} do lỗi: ${error.message}`);
        }
    }

    await browser.close();

    // ==========================================
    // LOAD STEP (Lưu ra File / Hoặc DB)
    // ==========================================
    console.log(`\n[LOAD] Đã Transform xong ${etlResults.length} sản phẩm. Đang lưu ra file JSON...`);
    fs.writeFileSync(CONFIG.OUTPUT_FILE, JSON.stringify(etlResults, null, 4), 'utf8');
    
    console.log(`🎉 HOÀN TẤT! Dữ liệu đã lưu tại: ${CONFIG.OUTPUT_FILE}`);
    console.log(`💡 Mở file ${CONFIG.OUTPUT_FILE} để xem DTO chuẩn Enterprise!`);
}

runETL();
