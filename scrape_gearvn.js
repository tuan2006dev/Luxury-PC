const puppeteer = require('puppeteer');
const fs = require('fs');

(async () => {
    console.log("🚀 Đang khởi động trình duyệt AI (Puppeteer)...");
    const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox'] });
    const page = await browser.newPage();
    
    // Giả lập User-Agent để tránh bị block
    await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');

    const targetUrl = 'https://gearvn.com/collections/cpu';
    console.log(`🔎 Đang truy cập danh mục: ${targetUrl}`);
    await page.goto(targetUrl, { waitUntil: 'networkidle2', timeout: 60000 });

    // Cuộn trang xuống để load Lazy Images / Lazy Products nếu có
    await page.evaluate(async () => {
        await new Promise((resolve) => {
            let totalHeight = 0;
            let distance = 100;
            let timer = setInterval(() => {
                let scrollHeight = document.body.scrollHeight;
                window.scrollBy(0, distance);
                totalHeight += distance;
                if (totalHeight >= scrollHeight) {
                    clearInterval(timer);
                    resolve();
                }
            }, 100);
        });
    });

    console.log("🔗 Đang bóc tách link sản phẩm...");
    // Tìm toàn bộ link dẫn tới chi tiết sản phẩm
    let productLinks = await page.evaluate(() => {
        let links = [];
        // GearVN thường dùng các tag a có href chứa '/products/'
        document.querySelectorAll('a').forEach(a => {
            if (a.href && a.href.includes('/products/')) {
                links.push(a.href);
            }
        });
        return [...new Set(links)]; // Lọc trùng lặp URL
    });

    console.log(`✅ Tìm thấy ${productLinks.length} sản phẩm. Tiến hành cào dữ liệu...`);

    // Giới hạn cào 5 sản phẩm đầu tiên để Demo (Có thể bỏ slice để cào hết)
    let sqlOutput = `-- ==========================================\n`;
    sqlOutput += `-- SCRIPT AUTO SCRAPING (GEARVN -> LUXURY-PC)\n`;
    sqlOutput += `-- ==========================================\n\n`;

    for (let i = 0; i < Math.min(productLinks.length, 5); i++) {
        const link = productLinks[i];
        console.log(`⏳ Đang cào [${i+1}/5]: ${link}`);
        try {
            await page.goto(link, { waitUntil: 'networkidle2', timeout: 30000 });
            
            // Xử lý Scraping ngay trên trình duyệt
            const productData = await page.evaluate(() => {
                // 1. Tên sản phẩm
                let name = document.querySelector('h1.product-title, h1.title') ? document.querySelector('h1.product-title, h1.title').innerText.trim() : 'Unknown';
                name = name.replace(/'/g, "''"); // Thoát ký tự nháy đơn cho SQL

                // 2. Giá sản phẩm
                let priceText = document.querySelector('.product-price, .price') ? document.querySelector('.product-price, .price').innerText : '0';
                let price = priceText.replace(/[^\d]/g, ''); // Xóa chữ, chỉ giữ số

                // 3. Ảnh
                let imageElem = document.querySelector('.product-gallery img, .product-image img');
                let image = imageElem ? imageElem.src.split('/').pop().split('?')[0] : 'default.jpg';

                // 4. Mô tả
                let descElem = document.querySelector('.product-description, .pd-content');
                let description = descElem ? descElem.innerHTML.replace(/'/g, "''") : '';

                // 5. Thương hiệu (Brand) - Chuẩn hóa
                let brand = 'Unknown';
                if (name.toUpperCase().includes('INTEL')) brand = 'Intel';
                else if (name.toUpperCase().includes('AMD')) brand = 'AMD';
                else if (name.toUpperCase().includes('ASUS')) brand = 'ASUS';
                else if (name.toUpperCase().includes('MSI')) brand = 'MSI';
                else if (name.toUpperCase().includes('GIGABYTE')) brand = 'Gigabyte';
                
                // 6. Thông số kỹ thuật (Ví dụ lấy Socket và TDP từ bảng cấu hình)
                let socket = 'NULL';
                let tdp = 'NULL';
                let igpu = 0;
                
                let trs = document.querySelectorAll('tr, li');
                trs.forEach(tr => {
                    let text = tr.innerText.toUpperCase();
                    if (text.includes('SOCKET')) {
                        socket = "'" + text.split(':').pop().replace('SOCKET', '').trim() + "'";
                    }
                    if (text.includes('TDP') || text.includes('CÔNG SUẤT')) {
                        let tdpText = text.replace(/[^\d]/g, ''); // Cắt chữ W
                        if (tdpText) tdp = tdpText;
                    }
                    if (text.includes('ĐỒ HỌA TÍCH HỢP') || text.includes('IGPU')) {
                        igpu = 1; // Có iGPU
                    }
                });

                return { name, price, description, image, brand, socket, tdp, igpu };
            });

            // Nếu giá = 0, báo lỗi và bỏ qua
            if (!productData.price || productData.price === '0') {
                console.log(`❌ Bỏ qua sản phẩm lỗi giá (Price = 0)`);
                continue;
            }

            // Sinh lệnh SQL cho bảng products
            sqlOutput += `INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at) \n`;
            sqlOutput += `VALUES (N'${productData.name}', ${productData.price}, N'${productData.description}', '${productData.image}', 1, 10, '${productData.brand}', CURRENT_TIMESTAMP);\n`;
            sqlOutput += `DECLARE @ProductId_${i} INT = SCOPE_IDENTITY();\n`;

            // Sinh lệnh SQL cho bảng cpu_specs
            sqlOutput += `INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, ram_type_supported, socket, tdp_max) \n`;
            sqlOutput += `VALUES (@ProductId_${i}, ${productData.igpu}, 0, NULL, ${productData.socket}, ${productData.tdp});\n\n`;

        } catch (error) {
            console.log(`❌ Lỗi khi cào ${link}: ${error.message}`);
        }
    }

    // Xuất file
    fs.writeFileSync('auto_scraping_cpu.sql', sqlOutput);
    console.log("🎉 HOÀN TẤT! Toàn bộ dữ liệu đã được xuất ra file 'auto_scraping_cpu.sql'");

    await browser.close();
})();
