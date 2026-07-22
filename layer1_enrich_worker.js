const fs = require('fs');
const cheerio = require('cheerio');

const INPUT_FILE = 'gearvn_cpu_etl_results.json';
const OUTPUT_FILE = 'gearvn_cpu_enriched.json';

// Trình tạo mã MPN giả định bằng thuật toán quy tắc (Dựa trên tên gốc của Hãng)
function generateSmartMPN(brand, normalizedName) {
    let mpn = "";
    if (brand.toUpperCase() === "INTEL") {
        const match = normalizedName.match(/core(i\d)(.*)/i);
        if (match) {
            mpn = `BX80715${match[2].replace(/[^0-9a-z]/ig, '').toUpperCase()}`;
        }
    } else if (brand.toUpperCase() === "AMD") {
        const match = normalizedName.match(/ryzen(\d)(.*)/i);
        if (match) {
            mpn = `100-100000${match[2].replace(/[^0-9a-z]/ig, '').toUpperCase()}`;
        }
    }
    return mpn || `GENERIC-${Math.floor(Math.random()*100000)}`;
}

// Hàm Map tên thuộc tính Tiếng Việt -> Tiếng Anh chuẩn (Canonical Schema)
function mapAttributeKey(rawKey) {
    const k = rawKey.toLowerCase().trim();
    if (k.includes('số nhân') || k.includes('cores')) return 'core_count';
    if (k.includes('số luồng') || k.includes('threads')) return 'thread_count';
    if (k.includes('tốc độ') || k.includes('xung')) return 'clock_speed';
    if (k.includes('socket')) return 'cpu_socket';
    if (k.includes('điện năng') || k.includes('tdp')) return 'tdp_max';
    if (k.includes('đệm l3') || k.includes('cache l3')) return 'l3_cache';
    if (k.includes('đồ họa') || k.includes('graphics')) return 'integrated_graphics';
    if (k.includes('bộ nhớ') || k.includes('ram')) return 'memory_support';
    return null;
}

async function runEnrichment() {
    console.log("🚀 Bắt đầu tiến trình LAYER 1 ENRICHMENT (Deep Parsing & Smart MPN)");

    if (!fs.existsSync(INPUT_FILE)) {
        console.error(`❌ Không tìm thấy file ${INPUT_FILE}. Vui lòng chạy Crawler ETL trước.`);
        return;
    }

    const rawData = JSON.parse(fs.readFileSync(INPUT_FILE, 'utf8'));
    console.log(`[INFO] Đã load ${rawData.length} sản phẩm cần Enrich.`);

    const enrichedData = [];

    for (let i = 0; i < rawData.length; i++) {
        const p = rawData[i];
        console.log(`\n[ENRICH] Đang xử lý: ${p.content.display_name}`);

        // 1. Tự động sinh MPN chuẩn từ tên sản phẩm
        const mpn = generateSmartMPN(p.classification.brand, p.content.normalized_name);
        p.identifiers.mpn = mpn;
        console.log(`   + Tự động sinh MPN: ${mpn}`);

        // 2. Bóc tách HTML Specs thành kiến trúc EAV
        const specsEAV = [];
        if (p.content.description_html) {
            const $ = cheerio.load(p.content.description_html);
            
            // Tìm tất cả các thẻ <tr> trong bảng thông số
            $('tr').each((index, element) => {
                const tds = $(element).find('td');
                if (tds.length >= 2) {
                    const rawKey = $(tds[0]).text().trim();
                    const rawValue = $(tds[1]).text().trim();
                    
                    const canonicalKey = mapAttributeKey(rawKey);
                    if (canonicalKey) {
                        specsEAV.push({
                            code: canonicalKey,
                            value: rawValue,
                            raw_key: rawKey // Giữ lại key thô để debug
                        });
                    }
                }
            });
        }

        p.specs_eav = specsEAV;
        console.log(`   + Trích xuất thành công ${specsEAV.length} thuộc tính chuẩn EAV.`);
        
        // Dọn dẹp HTML thô sau khi đã lấy xong EAV để nhẹ file
        delete p.content.description_html;

        enrichedData.push(p);
    }

    fs.writeFileSync(OUTPUT_FILE, JSON.stringify(enrichedData, null, 4), 'utf8');
    console.log(`\n🎉 HOÀN TẤT ENRICHMENT! Dữ liệu đã lưu tại: ${OUTPUT_FILE}`);
}

runEnrichment();
