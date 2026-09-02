import subprocess
import os

# 25 Realistic Tech Articles across 5 Categories
# Author ID: 1 (Admin)
articles = [
    # =========================================================================
    # CATEGORY 1: TIN TỨC (id = 1)
    # =========================================================================
    {
        "id": 1,
        "title": "NVIDIA chính thức ra mắt Card đồ họa GeForce RTX 50 Series kiến trúc Blackwell",
        "slug": "nvidia-chinh-thuc-ra-mat-rtx-50-series-blackwell",
        "category_id": 1,
        "summary": "NVIDIA công bố thế hệ card đồ họa RTX 5090 và RTX 5080 với bộ nhớ GDDR7 siêu tốc, kiến trúc Blackwell đột phá mang lại hiệu năng Ray Tracing và DLSS 4 vượt trội gấp 2 lần.",
        "content": """<p>Tại sự kiện công nghệ toàn cầu, CEO NVIDIA Jensen Huang đã chính thức vén màn thế hệ card đồ họa tiêu dùng cao cấp nhất: <strong>GeForce RTX 50 Series</strong> mang mã kiến trúc <em>Blackwell</em>.</p>
<h3>1. Thông số kỹ thuật vượt trội của RTX 5090</h3>
<p>Flagship <strong>RTX 5090</strong> được trang bị tới 21.760 nhân CUDA, 32GB VRAM chuẩn <strong>GDDR7</strong> chạy trên băng thông bus 512-bit, đạt tốc độ truyền tải kỷ lục gần 1.8 TB/s. Mức TDP tiêu thụ điện ở mức 500W, sử dụng cổng cấp nguồn chuẩn 12V-2x6 thế hệ mới an toàn tuyệt đối.</p>
<ul>
<li><strong>GPU:</strong> GB202 Blackwell Architecture</li>
<li><strong>CUDA Cores:</strong> 21,760 Cores</li>
<li><strong>VRAM:</strong> 32GB GDDR7 512-bit</li>
<li><strong>Băng thông bộ nhớ:</strong> 1,792 GB/s</li>
<li><strong>Công nghệ:</strong> DLSS 4 with Multi-Frame Generation</li>
</ul>
<h3>2. Công nghệ DLSS 4 và bước nhảy vọt Ray Tracing</h3>
<p>Blackwell sở hữu nhân Tensor Cores thế hệ thứ 5 và RT Cores thế hệ thứ 4. Điểm nhấn lớn nhất là công nghệ <strong>DLSS 4</strong> với khả năng tạo đa khung hình (Multi-Frame Generation) bằng mạng nơ-ron AI, giúp các tựa game đồ họa 4K Full Path Tracing như Cyberpunk 2077 hay Black Myth: Wukong đạt trên 144 FPS dễ dàng.</p>
<blockquote>"Blackwell là bước chuyển dịch lớn nhất trong lịch sử đồ họa máy tính, mở ra kỷ nguyên dựng hình hoàn toàn bằng AI." - Đại diện NVIDIA chia sẻ.</blockquote>
<p>Sản phẩm sẽ chính thức mở bán tại hệ thống <strong>Luxury PC</strong> với đầy đủ các phiên bản Custom cao cấp từ ASUS ROG Strix, MSI Suprim X và GIGABYTE AORUS Master.</p>""",
        "thumbnail": "https://cdn-ru.bitrix24.ru/b11322588/landing/90e/90ed69e925e0a6d59b2fe8e9075775f0/RTX5090_1x.png",
        "view_count": 28450,
        "meta_title": "NVIDIA ra mắt GeForce RTX 50 Series Blackwell - LuxuryPC",
        "meta_description": "NVIDIA công bố dòng card đồ họa RTX 5090, RTX 5080 kiến trúc Blackwell với bộ nhớ GDDR7 và DLSS 4 đỉnh cao.",
        "meta_keywords": "RTX 5090, RTX 5080, NVIDIA Blackwell, GDDR7, DLSS 4, card đồ họa mới",
        "created_at": "2026-01-10 09:30:00"
    },
    {
        "id": 2,
        "title": "Intel công bố vi xử lý Core Ultra 200S Series Arrow Lake tiết kiệm 40% điện năng",
        "slug": "intel-cong-bo-core-ultra-200s-series-arrow-lake",
        "category_id": 1,
        "summary": "Kiến trúc Arrow Lake trên socket LGA 1851 giúp giảm tới 40% điện năng tiêu thụ và nhiệt độ mát hơn 15 độ C trong khi vẫn giữ nguyên hiệu năng xử lý đa nhiệm đỉnh cao.",
        "content": """<p>Intel vừa chính thức trình làng dòng vi xử lý máy tính để bàn thế hệ mới mang tên <strong>Intel Core Ultra 200S Series</strong> (tên mã Arrow Lake-S), đánh dấu sự từ bỏ thương hiệu Core i truyền thống để bước sang kỷ nguyên Core Ultra trên Socket LGA 1851.</p>
<h3>1. Thiết kế Tile Chiplet hiện đại trên tiến trình TSMC 3nm</h3>
<p>Khác biệt hoàn toàn với các thế hệ trước, Core Ultra 200S áp dụng kiến trúc đóng gói 3D Foveros kết hợp nhiều Tile: Compute Tile (sản xuất trên tiến trình TSMC N3B), Graphics Tile, SoC Tile và I/O Tile. Nhờ đó, hiệu suất năng lượng (Performance/Watt) đạt mức cải thiện ngoạn mục.</p>
<h3>2. Thông số các vi xử lý chủ lực</h3>
<ul>
<li><strong>Intel Core Ultra 9 285K:</strong> 24 nhân (8 P-Core Lion Cove + 16 E-Core Skymont), xung nhịp tối đa 5.7GHz, 36MB Intel Smart Cache, TDP 125W (Turbo 250W).</li>
<li><strong>Intel Core Ultra 7 265K:</strong> 20 nhân (8 P-Core + 12 E-Core), xung nhịp 5.5GHz.</li>
<li><strong>Intel Core Ultra 5 245K:</strong> 14 nhân (6 P-Core + 8 E-Core), xung nhịp 5.2GHz.</li>
</ul>
<p>Đặc biệt, dòng chip mới tích hợp sẵn NPU chuyên dụng xử lý các tác vụ AI cục bộ đạt 13 TOPS, mang lại trải nghiệm Copilot+ PC mượt mà ngay trên máy tính để bàn.</p>""",
        "thumbnail": "https://www.techpowerup.com/review/intel-core-ultra-9-285k/images/small.png",
        "view_count": 19800,
        "meta_title": "Intel Core Ultra 200S Arrow Lake ra mắt - LuxuryPC",
        "meta_description": "Intel ra mắt CPU Core Ultra 9 285K, Ultra 7 265K socket LGA 1851 tiết kiệm điện và tích hợp NPU AI.",
        "meta_keywords": "Core Ultra 9 285K, Arrow Lake, Intel LGA 1851, Core Ultra 200S",
        "created_at": "2026-01-22 14:15:00"
    },
    {
        "id": 3,
        "title": "Thị trường RAM DDR5 bình ổn giá, chuẩn bị phổ cập chuẩn CUDIMM tốc độ 9000MT/s",
        "slug": "thi-truong-ram-ddr5-pho-cap-chuan-cudimm-9000mts",
        "category_id": 1,
        "summary": "Giá RAM DDR5 tiếp tục xu hướng bình ổn, mở đường cho thế hệ bộ nhớ CUDIMM tích hợp chip Client Clock Driver đạt mức xung nhịp kỷ lục lên tới 9200MT/s trở thành tiêu chuẩn mới.",
        "content": """<p>Sau giai đoạn biến động, giá bộ nhớ RAM DDR5 trên thị trường toàn cầu đã bước vào chu kỳ ổn định, tạo điều kiện thuận lợi cho game thủ và chuyên gia đồ họa nâng cấp cấu hình máy tính.</p>
<h3>CUDIMM là gì và tại sao lại tạo nên cuộc cách mạng tốc độ?</h3>
<p><strong>CUDIMM (Clocked Unbuffered DIMM)</strong> là chuẩn bộ nhớ DDR5 cải tiến được JEDEC chuẩn hóa. Điểm đột phá nằm ở con chip <em>CKD (Client Clock Driver)</em> được tích hợp trực tiếp trên thanh RAM, giúp tái tạo và khuếch đại xung nhịp tín hiệu bộ nhớ, loại bỏ tình trạng suy hao tín hiệu khi chạy ở bus cực cao.</p>
<p>Các hãng sản xuất hàng đầu như G.Skill (Trident Z5 CK), Corsair (Dominator Titanium CUDIMM) và Kingmax đã công bố các kit RAM có tốc độ sẵn sàng từ <strong>8400MT/s đến 9200MT/s</strong> chỉ bằng một cú nhấp chuột bật profile XMP trong BIOS.</p>""",
        "thumbnail": "https://c1.neweggimages.com/ProductImageCompressAll1280/20-374-453-01.jpg",
        "view_count": 14300,
        "meta_title": "RAM DDR5 CUDIMM 9000MT/s chuẩn bị phổ cập - LuxuryPC",
        "meta_description": "Tìm hiểu chuẩn RAM CUDIMM DDR5 thế hệ mới tích hợp chip Clock Driver đạt tốc độ trên 9000MT/s.",
        "meta_keywords": "RAM DDR5, CUDIMM, G.Skill Trident Z5, Corsair Dominator, bus 9000MHz",
        "created_at": "2026-02-15 10:00:00"
    },
    {
        "id": 4,
        "title": "ASUS ROG ra mắt loạt bo mạch chủ Z890 và X870E hỗ trợ Wi-Fi 7 và PCIe 5.0 toàn diện",
        "slug": "asus-rog-ra-mat-bo-mach-chu-z890-x870e-wifi-7",
        "category_id": 1,
        "summary": "Các dòng bo mạch chủ ROG Maximus Z890 và Crosshair X870E tích hợp khe M.2 PCIe 5.0 không cần ốc vít, tính năng ép xung bằng AI và kết nối Wi-Fi 7 siêu tốc băng thông 320MHz.",
        "content": """<p>ASUS Republic of Gamers (ROG) vừa chính thức giới thiệu dải sản phẩm bo mạch chủ cao cấp thế hệ mới dành cho cả hai nền tảng Intel Core Ultra (Z890) và AMD Ryzen 9000 Series (X870E).</p>
<h3>1. Thiết kế EZ-PC: Tối giản thao tác lắp đặt</h3>
<p>ASUS tiếp tục dẫn đầu xu hướng thân thiện với người dùng thông qua hệ sinh thái <strong>ROG EZ-PC</strong>:</p>
<ul>
<li><strong>PCIe Slot Q-Release Slim:</strong> Tháo card đồ họa nặng chỉ bằng cách nghiêng nhẹ card về phía chốt, không cần dùng tay nhấn nút mở chốt.</li>
<li><strong>M.2 Q-Latch & Q-Release:</strong> Lắp đặt ổ cứng SSD NVMe và tản nhiệt giáp nhôm hoàn toàn không cần tua-vít.</li>
<li><strong>Wi-Fi Q-Antenna:</strong> Ăng-ten thu sóng Wi-Fi 7 dạng cắm trực tiếp (Plug-and-Play) tiện lợi.</li>
</ul>
<h3>2. Dàn cấp nguồn VRM khủng và AI Overclocking</h3>
<p>Flagship <strong>ROG Maximus Z890 Extreme</strong> và <strong>Hero</strong> sở hữu dàn phase nguồn 24+1+2 phase 110A, trang bị màn hình OLED Anime Matrix hiển thị thông số thời gian thực cùng hệ thống tản nhiệt I/O nhôm nguyên khối mạ niken sang trọng.</p>""",
        "thumbnail": "https://dlcdnwebimgs.asus.com/gain/A3777166-EF70-4D33-915B-EC7B6814F00E/w800",
        "view_count": 16750,
        "meta_title": "Bo mạch chủ ASUS ROG Z890 và X870E Wi-Fi 7 - LuxuryPC",
        "meta_description": "Khám phá loạt mainboard cao cấp ASUS ROG Z890 Hero, Extreme hỗ trợ PCIe 5.0 và tháo lắp không cần ốc vít.",
        "meta_keywords": "ASUS ROG Z890, X870E, ROG Maximus, Wi-Fi 7, mainboard gaming",
        "created_at": "2026-03-01 16:20:00"
    },
    {
        "id": 5,
        "title": "Khai trương Showroom Luxury PC Flagship Store tại Hà Nội với loạt ưu đãi tới 50%",
        "slug": "khai-truong-showroom-luxurypc-flagship-ha-noi",
        "category_id": 1,
        "summary": "Luxury PC chính thức khai trương trung tâm trải nghiệm PC Gaming & Workstation cao cấp lớn nhất miền Bắc với chương trình giảm giá lên đến 50% cùng hàng trăm quà tặng độc quyền.",
        "content": """<p>Hôm nay, <strong>Luxury PC</strong> đã chính thức cắt băng khánh thành trung tâm trải nghiệm công nghệ cao cấp <em>Flagship Store</em> tọa lạc tại trung tâm thành phố Hà Nội.</p>
<p>Với diện tích hơn 500m2 sàn, showroom mang tới không gian trải nghiệm đẳng cấp quốc tế bao gồm:</p>
<ul>
<li>Khu vực trải nghiệm <strong>PC Gaming Siêu Cấp</strong> trang bị RTX 5090, màn hình cong OLED 49 inch 240Hz.</li>
<li>Khu vực <strong>Custom Water Cooling Studio</strong> trưng bày các tác phẩm PC tản nhiệt nước ống đồng, ống acrylic uốn nghệ thuật.</li>
<li>Khu vực <strong>Góc Làm Việc Công Thái Học (Setup Ergonomic)</strong> dành cho Designer, Coder và Streamer.</li>
</ul>
<p>Trong tuần lễ khai trương từ 15/03 đến 22/03, Luxury PC triển khai chương trình bốc thăm may mắn trúng Card đồ họa trị giá 40 triệu đồng, tặng Voucher giảm giá 2.000.000đ cho mọi đơn build PC từ 25 triệu đồng.</p>""",
        "thumbnail": "https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=1000&q=80",
        "view_count": 35200,
        "meta_title": "Khai trương Showroom Luxury PC Flagship Store Hà Nội",
        "meta_description": "Luxury PC khai trương không gian trải nghiệm PC Gaming & Custom nước hoành tráng kèm ưu đãi giảm tới 50%.",
        "meta_keywords": "khai trương Luxury PC, showroom máy tính Hà Nội, ưu đãi build PC, quà tặng khai trương",
        "created_at": "2026-03-15 08:00:00"
    },

    # =========================================================================
    # CATEGORY 2: HƯỚNG DẪN BUILD PC (id = 2)
    # =========================================================================
    {
        "id": 6,
        "title": "Hướng dẫn tự lắp ráp PC Gaming từ A-Z cho người mới bắt đầu cực kỳ chi tiết",
        "slug": "huong-dan-tu-lap-rap-pc-gaming-tu-a-z-cho-nguoi-moi",
        "category_id": 2,
        "summary": "Từng bước hướng dẫn lắp CPU, tra keo tản nhiệt, gắn RAM, lắp tản nhiệt nước AIO, cắm nguồn và đi dây cáp gọn gàng, an toàn, chuẩn kỹ thuật 100%.",
        "content": """<p>Tự tay lắp ráp một cỗ máy PC Gaming theo sở thích là trải nghiệm vô cùng thú vị. Dưới đây là quy trình 7 bước chuẩn kỹ thuật từ đội ngũ chuyên gia của <strong>Luxury PC</strong>:</p>
<h3>Bước 1: Chuẩn bị không gian và công cụ</h3>
<p>Chuẩn bị một chiếc tua-vít 4 cạnh có từ tính, dây rút nhựa, kéo và làm việc trên mặt bàn gỗ phẳng, khô ráo, tránh tĩnh điện.</p>
<h3>Bước 2: Lắp CPU, RAM và SSD lên Mainboard trước khi đưa vào Case</h3>
<p>Mở ngàm socket trên bo mạch chủ, căn chuẩn hình tam giác vàng trên góc CPU khớp với ký hiệu trên socket rồi hạ nhẹ nhàng. Lắp RAM vào các khe cắm ưu tiên (khe 2 và khe 4) để kích hoạt kênh đôi Dual Channel.</p>
<h3>Bước 3: Lắp đặt Mainboard và Tản nhiệt</h3>
<p>Bắt ốc đệm (standoff) vào thùng case, gắn chặn main (I/O Shield) rồi siết cố định bo mạch chủ. Bôi lượng keo tản nhiệt bằng hạt đậu nhỏ ở giữa bề mặt CPU trước khi siết tản nhiệt theo đường chéo cân bằng.</p>
<h3>Bước 4: Lắp Nguồn (PSU) và Cắm dây nguồn</h3>
<p>Cắm các đầu dây cấp nguồn quan trọng: 24-pin Mainboard, 8-pin CPU, dây Audio/Front Panel và dây nguồn PCIe cấp cho card đồ họa.</p>""",
        "thumbnail": "https://images.unsplash.com/photo-1587202372775-e229f172b9d7?auto=format&fit=crop&w=1000&q=80",
        "view_count": 48200,
        "meta_title": "Hướng dẫn tự lắp ráp PC Gaming từ A-Z chi tiết nhất - LuxuryPC",
        "meta_description": "Cẩm nang hướng dẫn tự lắp ráp PC Gaming cho người mới bắt đầu với hình ảnh và các lưu ý an toàn.",
        "meta_keywords": "hướng dẫn build pc, tự lắp máy tính, cách gắn cpu, cắm dây nguồn pc",
        "created_at": "2026-01-05 11:20:00"
    },
    {
        "id": 7,
        "title": "Cách đi dây nguồn (Cable Management) chuyên nghiệp giúp thùng máy đẹp và thông thoáng",
        "slug": "cach-di-day-nguon-cable-management-chuyen-nghiep-thong-thoang",
        "category_id": 2,
        "summary": "Chia sẻ bí quyết giấu dây, sử dụng dây nối bọc lưới custom, bố trí quạt hút/thổi tạo áp suất dương tối ưu cho luồng khí tản nhiệt bên trong case.",
        "content": """<p>Một thùng máy có hệ thống dây cáp gọn gàng không chỉ nâng tầm tính thẩm mỹ mà còn giúp luồng không khí lưu thông tối ưu, giảm từ 3 đến 5 độ C cho các linh kiện quan trọng.</p>
<h3>Nguyên tắc vàng khi giấu dây nguồn:</h3>
<ol>
<li><strong>Phân luồng dây trước khi buộc:</strong> Tách riêng nhóm dây nguồn 24-pin, dây CPU 8-pin và dây SATA/Fan ARGB.</li>
<li><strong>Sử dụng dây nguồn bọc lưới (Sleeved Cable Extensions):</strong> Giúp tạo các đường cong mềm mại ở mặt trước kính cường lực.</li>
<li><strong>Tận dụng khoang giấu dây sau nắp lưng:</strong> Cố định dây bằng dây dán Velcro hoặc dây rút nhựa theo các đường rãnh có sẵn của vỏ case.</li>
</ol>""",
        "thumbnail": "https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?auto=format&fit=crop&w=1000&q=80",
        "view_count": 21500,
        "meta_title": "Cách đi dây nguồn PC Cable Management đẹp mắt - LuxuryPC",
        "meta_description": "Mẹo giấu dây nguồn máy tính chuyên nghiệp, thẩm mỹ và tăng lưu thông gió tản nhiệt.",
        "meta_keywords": "cable management, đi dây pc, giấu dây nguồn case, mod dây pc đẹp",
        "created_at": "2026-02-18 15:40:00"
    },
    {
        "id": 8,
        "title": "Hướng dẫn lắp đặt tản nhiệt nước AIO chuẩn kỹ thuật: Đặt Radiator ở đâu tốt nhất?",
        "slug": "huong-dan-lap-dat-tan-nhiet-nuoc-aio-radiator-chuan-ky-thuat",
        "category_id": 2,
        "summary": "Phân tích ưu nhược điểm khi gắn Radiator ở nóc (Top) hay mặt trước (Front), tránh hiện tượng bọt khí lọt vào bơm gây tiếng ồn và giảm tuổi thọ tản nhiệt.",
        "content": """<p>Tản nhiệt nước All-in-One (AIO) ngày càng phổ biến nhờ hiệu năng giải nhiệt vượt trội và hiệu ứng đèn LED RGB bắt mắt. Tuy nhiên, vị trí đặt két nước (Radiator) ảnh hưởng trực tiếp đến tuổi thọ của bơm nước.</p>
<h3>1. Vị trí tối ưu nhất: Gắn Radiator ở Nóc Case (Top Exhaust)</h3>
<p>Khi gắn trên nóc, két nước nằm ở vị trí cao nhất của toàn bộ vòng tuần hoàn. Bọt khí trong dung dịch làm mát tự nhiên sẽ tích tụ tại đỉnh két nước, hoàn toàn không thể lọt vào cụm bơm (Pump) gắn trên mặt CPU. Bơm sẽ luôn được ngập hoàn toàn trong chất lỏng, vận hành êm ái và đạt tuổi thọ tối đa.</p>
<h3>2. Vị trí thứ hai: Gắn ở Mặt Trước (Front Mount)</h3>
<p>Nếu gắn mặt trước, hãy đảm bảo <strong>đầu ống dẫn nước của Radiator quay xuống phía dưới</strong> hoặc phần đỉnh của két nước phải cao hơn vị trí của Block CPU.</p>""",
        "thumbnail": "https://res.cloudinary.com/corsair-pwa/image/upload/v1665096094/akamai/landing/virtuoso/assets/images/VIRTUOSO-White.png",
        "view_count": 28900,
        "meta_title": "Vị trí lắp Radiator tản nhiệt nước AIO tốt nhất - LuxuryPC",
        "meta_description": "Hướng dẫn lắp tản nhiệt nước AIO đúng cách, tránh bọt khí vào bơm và tăng độ bền tản nhiệt.",
        "meta_keywords": "lắp tản nhiệt nước AIO, vị trí radiator, pump cpu, tản nước corsair kraken",
        "created_at": "2026-03-05 09:10:00"
    },
    {
        "id": 9,
        "title": "Cách cài đặt Windows 11 chuẩn UEFI và tối ưu hóa hệ thống sau khi lắp ráp PC",
        "slug": "cai-dat-windows-11-uefi-va-toi-uu-he-thong-sau-build-pc",
        "category_id": 2,
        "summary": "Hướng dẫn tạo USB cài Windows 11, kích hoạt XMP/EXPO trong BIOS, cài đặt driver chipset, card đồ họa và thiết lập power plan tối ưu cho gaming.",
        "content": """<p>Sau khi hoàn thành phần cứng, việc cấu hình phần mềm chuẩn xác sẽ quyết định 100% độ mượt mà và ổn định của chiếc PC Gaming.</p>
<h3>1. Cấu hình BIOS chuẩn xác ngay lần đầu khởi động</h3>
<ul>
<li>Bật tính năng <strong>XMP (với Intel)</strong> hoặc <strong>EXPO (với AMD)</strong> để RAM chạy đúng tốc độ bus danh định (ví dụ 6000MHz thay vì mặc định 4800MHz).</li>
<li>Kích hoạt <strong>Resize BAR / Smart Access Memory (SAM)</strong> để CPU truy cập trực tiếp vào toàn bộ VRAM của card đồ họa.</li>
<li>Bật TPM 2.0 và Secure Boot để đáp ứng yêu cầu cài đặt Windows 11.</li>
</ul>
<h3>2. Cài đặt Driver đầy đủ theo thứ tự chuẩn</h3>
<p>Luôn cài đặt Driver Chipset bo mạch chủ trước tiên, sau đó đến Driver Card đồ họa (NVIDIA Game Ready hoặc AMD Adrenalin), Driver mạng LAN/Wi-Fi và Driver Audio.</p>""",
        "thumbnail": "https://images.unsplash.com/photo-1629654297299-c8506221ca97?auto=format&fit=crop&w=1000&q=80",
        "view_count": 33400,
        "meta_title": "Cài đặt Windows 11 UEFI và tối ưu BIOS sau build PC - LuxuryPC",
        "meta_description": "Hướng dẫn các bước cài đặt hệ điều hành và tối ưu hóa phần mềm sau khi tự lắp ráp máy tính.",
        "meta_keywords": "cài windows 11 uefi, bật xmp bios, cài driver card màn hình, tối ưu máy tính mới",
        "created_at": "2026-04-02 13:25:00"
    },
    {
        "id": 10,
        "title": "Hướng dẫn nâng cấp linh kiện máy tính cũ: Thứ tự ưu tiên để đạt hiệu năng cao nhất",
        "slug": "huong-dan-nang-cap-linh-kien-may-tinh-cu-toi-uu-hieu-nang",
        "category_id": 2,
        "summary": "Nên nâng cấp SSD NVMe, RAM, Card đồ họa hay CPU trước? Đánh giá tình trạng nghẽn cổ chai (Bottleneck) để đầu tư ngân sách đúng chỗ.",
        "content": """<p>Nâng cấp máy tính cũ là phương án kinh tế giúp kéo dài tuổi thọ bộ máy mà không cần tốn quá nhiều chi phí để build mới hoàn toàn.</p>
<h3>Thứ tự ưu tiên nâng cấp mang lại hiệu quả tức thì:</h3>
<ol>
<li><strong>Ổ cứng SSD NVMe PCIe:</strong> Nếu bạn vẫn đang dùng ổ HDD hoặc SSD SATA 2.5 inch cũ, việc chuyển hệ điều hành sang ổ SSD NVMe tốc độ 3500MB/s - 7000MB/s sẽ giúp máy khởi động trong 5 giây và mở ứng dụng tức thì.</li>
<li><strong>Dung lượng RAM (Tối thiểu 16GB - 32GB):</strong> Tránh tình trạng tràn RAM gây giật lag khi vừa chơi game vừa mở hàng chục tab trình duyệt.</li>
<li><strong>Card màn hình (GPU):</strong> Yếu tố quyết định số khung hình (FPS) trong game. Hãy đảm bảo bộ nguồn (PSU) đủ công suất gánh card mới.</li>
</ol>""",
        "thumbnail": "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=1000&q=80",
        "view_count": 18200,
        "meta_title": "Thứ tự ưu tiên nâng cấp linh kiện PC cũ - LuxuryPC",
        "meta_description": "Nên nâng cấp linh kiện máy tính nào trước để đạt hiệu năng tối ưu nhất với chi phí tiết kiệm.",
        "meta_keywords": "nâng cấp pc cũ, nâng ram, thay ssd nvme, nâng cấp card đồ họa, tránh nghẽn cổ chai",
        "created_at": "2026-05-12 10:45:00"
    },

    # =========================================================================
    # CATEGORY 3: TƯ VẤN CHỌN MUA (id = 3)
    # =========================================================================
    {
        "id": 11,
        "title": "Top cấu hình PC Gaming đáng mua nhất 2026 theo từng phân khúc từ 15 triệu đến 100 triệu",
        "slug": "top-cau-hinh-pc-gaming-dang-mua-nhat-2026-cac-phan-khuc",
        "category_id": 3,
        "summary": "Tổng hợp danh sách cấu hình PC Gaming từ phân khúc quốc dân giá rẻ (Core i5/RTX 4060) đến cỗ máy quái vật 4K Ultra Settings (Ultra 9/RTX 5090).",
        "content": """<p>Năm 2026 chứng kiến sự bùng nổ của nhiều nền tảng phần cứng mới. Luxury PC tổng hợp 3 cấu hình tiêu biểu đại diện cho các mức ngân sách:</p>
<h3>1. Phân khúc Quốc Dân (15 - 20 Triệu đồng): Chiến mượt 1080p</h3>
<ul>
<li><strong>CPU:</strong> Intel Core i5-12400F hoặc AMD Ryzen 5 5600</li>
<li><strong>Mainboard:</strong> GIGABYTE B760M Gaming Plus WiFi</li>
<li><strong>RAM:</strong> 16GB DDR4/DDR5 Bus 3200-5600MHz</li>
<li><strong>VGA:</strong> GeForce RTX 4060 8GB GDDR6</li>
<li><strong>Nguồn:</strong> FSP HV PRO 650W 80 Plus Bronze</li>
</ul>
<h3>2. Phân khúc Tầm Trung - Cận Cao Cấp (35 - 50 Triệu đồng): Chiến 2K Max Setting</h3>
<ul>
<li><strong>CPU:</strong> Intel Core i7-14700F hoặc Ryzen 7 7800X3D</li>
<li><strong>VGA:</strong> GeForce RTX 4070 Ti Super hoặc RTX 5070 Ti 16GB</li>
<li><strong>RAM:</strong> 32GB DDR5 Corsair Vengeance RGB</li>
<li><strong>Tản nhiệt:</strong> AIO Corsair Nautilus 360 ARGB</li>
</ul>
<h3>3. Phân khúc High-End Flagship (Trên 80 Triệu đồng): Chiến 4K Ray Tracing</h3>
<p>Sự kết hợp giữa <strong>Intel Core Ultra 9 285K</strong> cùng <strong>GeForce RTX 5090 32GB</strong> trên bo mạch chủ ASUS ROG Maximus Z890 Hero.</p>""",
        "thumbnail": "https://images.unsplash.com/photo-1593640408182-31c70c8268f5?auto=format&fit=crop&w=1000&q=80",
        "view_count": 52100,
        "meta_title": "Top cấu hình PC Gaming đáng mua nhất 2026 - LuxuryPC",
        "meta_description": "Gợi ý các cấu hình PC chơi game tối ưu nhất theo ngân sách từ 15 triệu đến 100 triệu đồng năm 2026.",
        "meta_keywords": "cấu hình pc gaming 2026, build máy tính chơi game, pc 15 triệu, pc 30 triệu, pc rtx 5090",
        "created_at": "2026-01-18 14:00:00"
    },
    {
        "id": 12,
        "title": "Tư vấn chọn nguồn máy tính (PSU): Công suất bao nhiêu Watt là đủ và cách đọc chuẩn 80 Plus",
        "slug": "tu-van-chon-nguon-may-tinh-psu-chuan-80-plus-atx-31",
        "category_id": 3,
        "summary": "Hướng dẫn tính toán công suất nguồn (TDP) cho toàn bộ linh kiện, giải thích các chuẩn Bronze, Gold, Platinum và cổng cấp nguồn chuẩn ATX 3.1 12V-2x6 mới nhất.",
        "content": """<p>Bộ nguồn (PSU) được ví như trái tim của dàn máy. Lựa chọn nguồn chất lượng tốt đảm bảo cấp dòng điện sạch, bảo vệ các linh kiện đắt tiền khỏi sự cố sụt áp hay chập cháy.</p>
<h3>Cách tính công suất nguồn cần thiết:</h3>
<p>Công thức cơ bản: <strong>Công suất PSU khuyên dùng = (TDP CPU + TDP GPU + 150W cho linh kiện phụ) x 1.3 (Hệ số an toàn)</strong></p>
<ul>
<li>Dàn máy i5 + RTX 4060: Khuyên dùng nguồn <strong>550W - 650W</strong> (Chuẩn Bronze).</li>
<li>Dàn máy i7/R7 + RTX 4070 Ti / 5070: Khuyên dùng nguồn <strong>750W - 850W</strong> (Chuẩn Gold).</li>
<li>Dàn máy Ultra 9/R9 + RTX 4090 / 5090: Khuyên dùng nguồn <strong>1000W - 1200W</strong> (Chuẩn ATX 3.1 Gold/Platinum).</li>
</ul>""",
        "thumbnail": "https://images.unsplash.com/photo-1555680202-c86f0e12f086?auto=format&fit=crop&w=1000&q=80",
        "view_count": 26700,
        "meta_title": "Tư vấn chọn nguồn máy tính PSU chuẩn 80 Plus - LuxuryPC",
        "meta_description": "Hướng dẫn tính toán công suất nguồn và chọn mua PSU máy tính an toàn, bền bỉ chuẩn ATX 3.1.",
        "meta_keywords": "chọn nguồn máy tính, psu 650w, psu 850w gold, nguồn corsair rm850e, nguồn atx 3.1",
        "created_at": "2026-02-28 09:30:00"
    },
    {
        "id": 13,
        "title": "Nên chọn Intel Core Ultra hay AMD Ryzen 9000 cho nhu cầu đồ họa, dựng phim 4K/8K?",
        "slug": "so-sanh-intel-core-ultra-vs-amd-ryzen-9000-cho-do-hoa-render",
        "category_id": 3,
        "summary": "Đánh giá chi tiết hiệu năng Premiere Pro, After Effects, DaVinci Resolve, Blender và V-Ray giữa hai dòng vi xử lý đầu bảng từ Intel và AMD.",
        "content": """<p>Cuộc chiến giữa Intel Core Ultra 200S và AMD Ryzen 9000 Series (Granite Ridge) đang mang lại nhiều lựa chọn chất lượng cho các nhà sáng tạo nội dung chuyên nghiệp.</p>
<h3>1. Dựng phim Premiere Pro & After Effects: Lợi thế Intel QuickSync</h3>
<p>Nếu quy trình làm việc sử dụng nhiều định dạng video nén H.264/H.265 (HEVC 4:2:2 10-bit), nhân đồ họa tích hợp Intel Graphics với công nghệ <strong>QuickSync Video</strong> giúp giải mã timeline mượt mà mà không cần render proxy.</p>
<h3>2. Render 3D Blender, V-Ray & Unreal Engine: Sức mạnh đa nhân AMD</h3>
<p>Với các tác vụ render thuần CPU đa luồng, kiến trúc Zen 5 của Ryzen 9 9950X cho tốc độ xử lý nhanh hơn 8-12% và nhiệt độ vận hành ổn định trong các phiên render kéo dài liên tục hàng chục tiếng.</p>""",
        "thumbnail": "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=1000&q=80",
        "view_count": 24100,
        "meta_title": "So sánh Intel Core Ultra vs AMD Ryzen 9000 dựng phim đồ họa",
        "meta_description": "Phân tích lựa chọn CPU Intel hay AMD tối ưu nhất cho Premiere Pro, After Effects, Blender và 3D rendering.",
        "meta_keywords": "so sánh intel amd, cpu làm đồ họa, render video 4k, intel quicksync, ryzen 9 9950x",
        "created_at": "2026-03-20 11:15:00"
    },
    {
        "id": 14,
        "title": "Bí quyết chọn màn hình Gaming: Tần số quét cao, tấm nền IPS hay OLED mới là chân ái?",
        "slug": "bi-quyet-chon-man-hinh-gaming-ips-vs-oled-tan-so-quet",
        "category_id": 3,
        "summary": "Phân tích sự khác biệt giữa độ phân giải 2K/4K, tần số quét 144Hz - 360Hz, thời gian phản hồi GtG và độ tương phản tuyệt đối của màn hình OLED thế hệ mới.",
        "content": """<p>Màn hình là cửa sổ giao tiếp giữa game thủ và thế giới ảo. Đầu tư một chiếc màn hình đúng chuẩn sẽ thay đổi hoàn toàn cảm nhận thị giác của bạn.</p>
<h3>So sánh tấm nền IPS và QD-OLED:</h3>
<ul>
<li><strong>Tấm nền Fast-IPS:</strong> Màu sắc chuẩn xác, góc nhìn rộng, độ sáng cao, không lo hiện tượng lưu ảnh (burn-in), giá thành rất dễ tiếp cận trong tầm giá từ 4 đến 10 triệu đồng.</li>
<li><strong>Tấm nền QD-OLED / WOLED:</strong> Độ tương phản vô cực, màu đen sâu tuyệt đối, thời gian phản hồi siêu tốc 0.03ms (GtG) loại bỏ bóng mờ hoàn toàn, tần số quét lên tới 360Hz - 480Hz. Lựa chọn số 1 cho game thủ hardcore và thi đấu Esports.</li>
</ul>""",
        "thumbnail": "https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=1000&q=80",
        "view_count": 19500,
        "meta_title": "Bí quyết chọn màn hình Gaming IPS vs OLED - LuxuryPC",
        "meta_description": "Hướng dẫn chọn mua màn hình chơi game 2K 4K tần số quét cao phù hợp cho Esports và game AAA.",
        "meta_keywords": "màn hình gaming, màn hình oled, màn hình 240hz, màn hình ips 2k, asus rog oled",
        "created_at": "2026-04-10 16:50:00"
    },
    {
        "id": 15,
        "title": "Tư vấn cấu hình PC làm việc tại nhà (Workstation) cho lập trình viên, Data Science và AI",
        "slug": "tu-van-cau-hinh-pc-workstation-lap-trinh-data-science-ai",
        "category_id": 3,
        "summary": "Gợi ý phần cứng chuyên biệt chạy mô hình LLM cục bộ, train Deep Learning với dung lượng VRAM lớn và bộ nhớ RAM đa kênh dung lượng 64GB - 128GB.",
        "content": """<p>Nhu cầu chạy các mô hình ngôn ngữ lớn (LLM như Llama 3, DeepSeek, Mistral) và huấn luyện mô hình Machine Learning trực tiếp trên máy trạm cá nhân đang phát triển bùng nổ.</p>
<h3>Các tiêu chí cốt lõi khi build PC cho AI Engineer:</h3>
<ol>
<li><strong>Dung lượng VRAM Card đồ họa là số 1:</strong> Khác với gaming cần xung nhịp cao, mô hình AI yêu cầu nạp toàn bộ tham số vào bộ nhớ VRAM. Cấu hình tối thiểu khuyến nghị từ 16GB VRAM (RTX 4060 Ti 16GB, RTX 4070 Ti Super 16GB) đến 24GB - 32GB VRAM (RTX 4090, RTX 5090).</li>
<li><strong>RAM hệ thống từ 64GB trở lên:</strong> Đảm bảo dung lượng để xử lý tập dữ liệu lớn (Big Data) và chạy máy ảo Docker/Kubernetes song song.</li>
<li><strong>Ổ cứng SSD NVMe chuẩn PCIe 4.0/5.0 dung lượng 2TB - 4TB:</strong> Tốc độ đọc ghi ngẫu nhiên 4K cao giúp nạp hàng triệu tệp dữ liệu huấn luyện siêu nhanh.</li>
</ol>""",
        "thumbnail": "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=1000&q=80",
        "view_count": 27300,
        "meta_title": "Tư vấn cấu hình PC Workstation cho AI và Data Science",
        "meta_description": "Gợi ý cấu hình máy tính trạm chạy mô hình AI LLM, Deep Learning và lập trình chuyên nghiệp.",
        "meta_keywords": "pc workstation ai, máy tính chạy llm, train deep learning, pc 64gb ram, rtx 4090 ai",
        "created_at": "2026-05-02 08:40:00"
    },

    # =========================================================================
    # CATEGORY 4: MẸO & THỦ THUẬT (id = 4)
    # =========================================================================
    {
        "id": 16,
        "title": "Cách bật XMP/EXPO để RAM chạy đúng tốc độ Bus cao nhất trong BIOS cực đơn giản",
        "slug": "cach-bat-xmp-expo-cho-ram-chay-dung-bus-trong-bios",
        "category_id": 4,
        "summary": "Hướng dẫn chi tiết cách vào BIOS bo mạch chủ ASUS, MSI, GIGABYTE, ASRock để bật profile ép xung bộ nhớ, giúp máy tính gia tăng 15-25% hiệu năng tức thì.",
        "content": """<p>Rất nhiều người dùng mua thanh RAM có thông số 6000MHz hoặc 6400MHz nhưng khi về cắm vào máy chỉ chạy ở tốc độ mặc định 4800MHz do chưa bật tính năng ép xung trong BIOS.</p>
<h3>Cách bật chỉ với 3 bước:</h3>
<ol>
<li>Khởi động máy tính và liên tục nhấn phím <strong>Del</strong> hoặc <strong>F2</strong> để vào giao diện BIOS.</li>
<li>Tìm mục <strong>Extreme Tweaker / Ai Tweaker (ASUS)</strong>, <strong>OC (MSI)</strong> hoặc <strong>Tweaker (GIGABYTE)</strong>.</li>
<li>Tìm dòng <strong>Memory Profile / X.M.P / EXPO</strong> và chuyển từ <em>Disabled</em> sang <strong>Profile 1</strong>.</li>
<li>Nhấn <strong>F10</strong> để lưu lại thiết lập và khởi động lại máy.</li>
</ol>
<p>Kiểm tra lại trong Task Manager mục <em>Performance -> Memory</em>, bạn sẽ thấy tốc độ bus RAM đã đạt mức tối đa!</p>""",
        "thumbnail": "https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1000&q=80",
        "view_count": 38900,
        "meta_title": "Cách bật XMP EXPO RAM trong BIOS dễ hiểu nhất - LuxuryPC",
        "meta_description": "Hướng dẫn cách bật XMP và AMD EXPO để mở khóa tốc độ bus RAM tối đa trong BIOS các hãng mainboard.",
        "meta_keywords": "bật xmp bios, bật expo amd, ram không nhận đủ bus, ép xung ram xmp",
        "created_at": "2026-01-28 10:15:00"
    },
    {
        "id": 17,
        "title": "10 Cách hạ nhiệt độ CPU và Card đồ họa hiệu quả trong mùa hè không tốn kém",
        "slug": "10-cach-ha-nhiet-do-cpu-va-gpu-mua-he-hieu-qua",
        "category_id": 4,
        "summary": "Thủ thuật Undervolt an toàn, cân chỉnh đường cong quạt (Fan Curve) tối ưu, vệ sinh bụi định kỳ và lựa chọn keo tản nhiệt gốm kim loại chất lượng cao.",
        "content": """<p>Mùa hè nắng nóng tại Việt Nam là thử thách lớn đối với các dàn PC hiệu năng cao. Áp dụng ngay các mẹo sau để giữ linh kiện luôn mát mẻ:</p>
<ul>
<li><strong>1. Tinh chỉnh Undervolt nhẹ:</strong> Giảm điện áp cấp cho CPU/GPU từ 0.05V - 0.1V giúp giảm ngay 7-10 độ C mà hiệu năng chơi game không suy giảm.</li>
<li><strong>2. Tối ưu Fan Curve trong phần mềm:</strong> Sử dụng phần mềm Fan Control hoặc BIOS để thiết lập quạt tăng tốc sớm hơn khi nhiệt độ chạm mốc 65 độ C.</li>
<li><strong>3. Tra lại keo tản nhiệt định kỳ:</strong> Thay keo tản nhiệt sau mỗi 12-18 tháng bằng các dòng keo cao cấp như Thermal Grizzly Kryonaut, Noctua NT-H2 hoặc Arctic MX-6.</li>
<li><strong>4. Đặt thùng máy ở nơi thông thoáng:</strong> Cách tường tối thiểu 15cm, tránh để case dưới gầm bàn bí bách.</li>
</ul>""",
        "thumbnail": "https://images.unsplash.com/photo-1591488320449-011701bb6704?auto=format&fit=crop&w=1000&q=80",
        "view_count": 29400,
        "meta_title": "10 Cách hạ nhiệt độ CPU và Card đồ họa mùa hè - LuxuryPC",
        "meta_description": "Chia sẻ kinh nghiệm làm mát thùng máy tính, undervolt và tối ưu quạt tản nhiệt trong mùa hè.",
        "meta_keywords": "hạ nhiệt cpu, làm mát máy tính, undervolt gpu, keo tản nhiệt tốt, fan curve pc",
        "created_at": "2026-02-25 14:30:00"
    },
    {
        "id": 18,
        "title": "Thủ thuật tối ưu hóa Windows 11 tăng FPS khi chơi game Esports cực mượt mà",
        "slug": "thu-thuat-toi-uu-hoa-windows-11-tang-fps-choi-game",
        "category_id": 4,
        "summary": "Tắt Game Bar không cần thiết, bật Hardware-Accelerated GPU Scheduling (HAGS), tắt hiệu ứng chuyển động và tối ưu hóa dịch vụ chạy ngầm.",
        "content": """<p>Windows 11 có nhiều tính năng nền hữu ích cho công việc nhưng đôi khi gây trễ độ phản hồi (Input Lag) trong các tựa game bắn súng đòi hỏi phản xạ nhanh như Valorant, CS2 hay Apex Legends.</p>
<h3>Các bước tối ưu hệ điều hành cho game thủ:</h3>
<ol>
<li><strong>Bật Hardware-Accelerated GPU Scheduling (HAGS):</strong> Vào <em>Settings -> System -> Display -> Graphics -> Change default graphics settings</em> và bật tính năng này lên.</li>
<li><strong>Kích hoạt Game Mode:</strong> Đảm bảo <em>Game Mode</em> đang ở trạng thái ON để Windows ưu tiên phân bổ tài nguyên CPU/RAM cho trò chơi.</li>
<li><strong>Tắt Memory Integrity (Tính toàn vẹn bộ nhớ):</strong> Nếu máy tính chỉ dùng chơi game cá nhân, việc tắt Core Isolation có thể giúp gia tăng 5-10% khung hình trong game CPU-bound.</li>
</ol>""",
        "thumbnail": "https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=1000&q=80",
        "view_count": 45600,
        "meta_title": "Tối ưu hóa Windows 11 tăng FPS chơi game mượt - LuxuryPC",
        "meta_description": "Các thủ thuật tinh chỉnh Windows 11 giúp tăng FPS, giảm giật lag và giảm input lag khi chơi game.",
        "meta_keywords": "tối ưu windows 11, tăng fps valorant, giảm lag cs2, hags windows 11, game mode",
        "created_at": "2026-03-12 18:20:00"
    },
    {
        "id": 19,
        "title": "Cách khắc phục lỗi màn hình xanh (BSOD) thường gặp trên máy tính chạy Windows",
        "slug": "cach-khac-phuc-loi-man-hinh-xanh-bsod-tren-may-tinh",
        "category_id": 4,
        "summary": "Phân tích các mã lỗi phổ biến như MEMORY_MANAGEMENT, CRITICAL_PROCESS_DIED, WHEA_UNCORRECTABLE_ERROR và hướng dẫn cách test RAM, kiểm tra ổ cứng SSD.",
        "content": """<p>Lỗi màn hình xanh chết chóc (Blue Screen of Death - BSOD) là nỗi ám ảnh của người dùng máy tính. Tuy nhiên, mã lỗi hiển thị dưới đáy màn hình sẽ chỉ ra chính xác nguyên nhân gốc rễ.</p>
<h3>Các mã lỗi BSOD thông dụng và cách xử lý:</h3>
<ul>
<li><strong>MEMORY_MANAGEMENT:</strong> Lỗi liên quan đến bộ nhớ RAM. Tháo từng thanh RAM ra vệ sinh chân tiếp xúc bằng cồn 90 độ, thử đổi khe cắm hoặc chạy công cụ <em>Windows Memory Diagnostic</em>.</li>
<li><strong>WHEA_UNCORRECTABLE_ERROR:</strong> Lỗi phần cứng nghiêm trọng do CPU bị ép xung quá mức hoặc thiếu điện áp (Vcore). Hãy Reset BIOS về thiết lập mặc định (Load Optimized Defaults).</li>
<li><strong>INACCESSIBLE_BOOT_DEVICE:</strong> Ổ cứng SSD bị lỏng cáp hoặc driver AHCI/NVMe bị lỗi.</li>
</ul>""",
        "thumbnail": "https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=1000&q=80",
        "view_count": 23800,
        "meta_title": "Cách sửa lỗi màn hình xanh BSOD Windows - LuxuryPC",
        "meta_description": "Hướng dẫn chẩn đoán và khắc phục triệt để các mã lỗi màn hình xanh máy tính phổ biến.",
        "meta_keywords": "sửa lỗi bsod, lỗi màn hình xanh, memory management, whea uncorrectable error, test ram",
        "created_at": "2026-04-15 11:30:00"
    },
    {
        "id": 20,
        "title": "Hướng dẫn sử dụng DDU để gỡ sạch Driver Card màn hình cũ tránh xung đột phần mềm",
        "slug": "huong-dan-su-dung-ddu-go-sach-driver-card-man-hinh",
        "category_id": 4,
        "summary": "Cách sử dụng phần mềm Display Driver Uninstaller trong Safe Mode để cài mới driver NVIDIA hoặc AMD, giải quyết triệt để lỗi giật lag, drop FPS hoặc crash game.",
        "content": """<p>Khi đổi từ card đồ họa NVIDIA sang AMD (hoặc ngược lại), hoặc khi driver đồ họa bị lỗi gây crash game, công cụ <strong>DDU (Display Driver Uninstaller)</strong> là cứu cánh số một.</p>
<h3>Quy trình gỡ sạch Driver chuẩn kỹ thuật viên:</h3>
<ol>
<li>Tải trước bộ cài Driver mới nhất từ trang chủ NVIDIA/AMD về máy tính.</li>
<li>Tải phần mềm <strong>DDU</strong> từ Wagnardsoft và giải nén.</li>
<li>Khởi động Windows vào chế độ <strong>Safe Mode</strong> (Giữ phím Shift trong khi bấm Restart trong Start Menu).</li>
<li>Mở DDU, chọn loại thiết bị <em>GPU</em> và hãng tương ứng (NVIDIA/AMD).</li>
<li>Bấm nút <strong>Clean and restart</strong>. Sau khi máy khởi động lại vào Windows bình thường, tiến hành cài đặt bộ driver mới đã tải sẵn.</li>
</ol>""",
        "thumbnail": "https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=1000&q=80",
        "view_count": 17900,
        "meta_title": "Hướng dẫn sử dụng DDU gỡ sạch driver card màn hình - LuxuryPC",
        "meta_description": "Cách dùng Display Driver Uninstaller trong Safe Mode để dọn sạch driver GPU cũ không để lại file rác.",
        "meta_keywords": "ddu gỡ driver, display driver uninstaller, cài lại driver nvidia, lỗi crash game gpu",
        "created_at": "2026-05-18 16:00:00"
    },

    # =========================================================================
    # CATEGORY 5: REVIEW SẢN PHẨM (id = 5)
    # =========================================================================
    {
        "id": 21,
        "title": "Đánh giá chi tiết Card đồ họa ASUS ROG Strix GeForce RTX 5090 24GB: Quái vật hiệu năng 4K",
        "slug": "danh-gia-asus-rog-strix-geforce-rtx-5090-24gb",
        "category_id": 5,
        "summary": "Trải nghiệm thực tế sức mạnh của GPU mạnh nhất thế giới với nhiệt độ cực mát nhờ hệ thống tản nhiệt buồng hơi Vapor Chamber và thiết kế kim loại hầm hố.",
        "content": """<p><strong>ASUS ROG Strix GeForce RTX 5090</strong> là biểu tượng đỉnh cao của làng phần cứng PC năm 2026, hội tụ sức mạnh đồ họa không đối thủ và thiết kế đậm chất tương lai.</p>
<h3>1. Thiết kế và Khả năng tản nhiệt</h3>
<p>Chiếm tới 3.5 slot PCI trên thùng máy với bộ khung hợp kim đúc nguyên khối, ROG Strix RTX 5090 sở hữu cụm 3 quạt Axial-tech thế hệ mới với vòng bi kép. Buồng hơi <em>Milled Vapor Chamber</em> tiếp xúc trực tiếp với die GPU giúp nhiệt độ khi chơi game nặng 4K chỉ dao động ở mức <strong>62 - 65 độ C</strong> với độ ồn cực kỳ êm ái.</p>
<h3>2. Hiệu năng Benchmark thực tế</h3>
<ul>
<li><strong>Cyberpunk 2077 (4K, Ray Tracing Overdrive, DLSS 4 Quality):</strong> Đạt trung bình 152 FPS.</li>
<li><strong>Black Myth: Wukong (4K, Cinematic Setting, Full Ray Tracing):</strong> Đạt trung bình 138 FPS.</li>
<li><strong>3DMark Time Spy Extreme:</strong> Đạt 26.400 điểm Graphics Score.</li>
</ul>
<p>Đây chắc chắn là linh kiện mơ ước cho mọi cỗ máy Gaming và AI Workstation tối thượng.</p>""",
        "thumbnail": "https://cdn-ru.bitrix24.ru/b11322588/landing/90e/90ed69e925e0a6d59b2fe8e9075775f0/RTX5090_1x.png",
        "view_count": 58900,
        "meta_title": "Đánh giá ASUS ROG Strix RTX 5090 24GB - LuxuryPC",
        "meta_description": "Review chi tiết hiệu năng và nhiệt độ card màn hình khủng nhất thế giới ASUS ROG Strix RTX 5090.",
        "meta_keywords": "review rtx 5090, đánh giá asus rog strix 5090, benchmark rtx 5090, gpu mạnh nhất",
        "created_at": "2026-01-15 08:30:00"
    },
    {
        "id": 22,
        "title": "Review Vi xử lý Intel Core Ultra 9 285K: Bước chuyển mình kiến trúc với hiệu suất ấn tượng",
        "slug": "review-vi-xu-ly-intel-core-ultra-9-285k",
        "category_id": 5,
        "summary": "Benchmark chi tiết khả năng render Cinebench R23, Geekbench 6 và trải nghiệm chơi game thực tế so sánh với flagship thế hệ trước 14900K và Ryzen 9 7950X3D.",
        "content": """<p><strong>Intel Core Ultra 9 285K</strong> đại diện cho bước ngoặt lớn nhất của Intel trong thập kỷ qua khi chuyển hẳn sang thiết kế kiến trúc chiplet rời.</p>
<h3>1. Kết quả kiểm tra hiệu năng (Benchmark)</h3>
<p>Trong bài test dựng hình <strong>Cinebench R23 Đa nhân</strong>, Core Ultra 9 285K đạt hơn <strong>43.200 điểm</strong>, vượt trội so với i9-14900K trong khi công suất tiêu thụ điện giảm từ 330W xuống chỉ còn 250W ở mức tải tối đa.</p>
<h3>2. Nhiệt độ mát mẻ đáng kinh ngạc</h3>
<p>Nhờ tiến trình N3B tiên tiến và việc tối ưu vị trí hotspot nhiệt, khi kết hợp với tản nhiệt nước AIO 360mm, nhiệt độ tối đa khi Stress Test chỉ chạm ngưỡng <strong>78 - 82 độ C</strong>, loại bỏ hoàn toàn hiện tượng quá nhiệt thường thấy ở thế hệ 14th Gen.</p>""",
        "thumbnail": "https://www.techpowerup.com/review/intel-core-ultra-9-285k/images/small.png",
        "view_count": 36700,
        "meta_title": "Review Intel Core Ultra 9 285K Benchmark chi tiết - LuxuryPC",
        "meta_description": "Đánh giá hiệu năng và nhiệt độ CPU Intel Core Ultra 9 285K thế hệ Arrow Lake mới nhất.",
        "meta_keywords": "review ultra 9 285k, benchmark core ultra 9, cpu arrow lake, intel core ultra 285k",
        "created_at": "2026-02-05 13:45:00"
    },
    {
        "id": 23,
        "title": "Đánh giá Bo mạch chủ GIGABYTE Z890 EAGLE WIFI7: Lựa chọn p/p tuyệt vời cho nền tảng LGA 1851",
        "slug": "danh-gia-bo-mach-chu-gigabyte-z890-eagle-wifi7",
        "category_id": 5,
        "summary": "Bo mạch chủ tầm trung nhưng trang bị đầy đủ dàn phase điện VRM 14+1+2 mạnh mẽ, kết nối Wi-Fi 7 thế hệ mới và tính năng EZ-Latch tháo lắp nhanh cực kỳ tiện lợi.",
        "content": """<p><strong>GIGABYTE Z890 EAGLE WIFI7</strong> là sự kết hợp hoàn hảo giữa mức giá dễ tiếp cận và những trang bị công nghệ cao cấp nhất của chipset Intel Z890.</p>
<h3>Những điểm sáng nổi bật trên sản phẩm:</h3>
<ul>
<li><strong>Dàn nguồn VRM 14+1+2 Phase:</strong> Đảm bảo cấp nguồn ổn định và khai thác tối đa sức mạnh của Core Ultra 7 265K và Ultra 9 285K.</li>
<li><strong>Wi-Fi 7 và LAN 2.5GbE:</strong> Tốc độ kết nối mạng không dây cực nhanh với độ trễ siêu thấp cho trải nghiệm gaming hoàn hảo.</li>
<li><strong>Hệ thống EZ-Latch:</strong> Tháo card đồ họa và gắn SSD NVMe hoàn toàn bằng ngàm bấm thông minh không cần ốc vít.</li>
</ul>""",
        "thumbnail": "https://media.ldlc.com/r1600/ld/products/00/06/12/72/LD0006127272_1.jpg",
        "view_count": 21800,
        "meta_title": "Đánh giá GIGABYTE Z890 EAGLE WIFI7 - LuxuryPC",
        "meta_description": "Review bo mạch chủ GIGABYTE Z890 Eagle WiFi7 hiệu năng cao, giá tốt cho chip Core Ultra.",
        "meta_keywords": "gigabyte z890 eagle, mainboard z890, lga 1851, wifi 7 gigabyte, review mainboard",
        "created_at": "2026-03-08 10:20:00"
    },
    {
        "id": 24,
        "title": "Review Ổ cứng SSD Samsung 990 PRO 2TB: Chuẩn mực tốc độ NVMe PCIe 4.0 đỉnh cao",
        "slug": "review-o-cung-ssd-samsung-990-pro-2tb-pcie-40",
        "category_id": 5,
        "summary": "Tốc độ đọc ghi thực tế lên tới 7450 MB/s và 6900 MB/s, độ bền TBW cao cùng công nghệ quản lý nhiệt thông minh giúp vận hành ổn định trong thời gian dài.",
        "content": """<p><strong>Samsung 990 PRO</strong> vẫn khẳng định vị thế ông vua tốc độ trong phân khúc ổ cứng SSD NVMe chuẩn PCIe 4.0 x4.</p>
<h3>1. Hiệu năng đọc ghi ngẫu nhiên (Random Read/Write) vượt trội</h3>
<p>Nhờ vi điều khiển Samsung Pascal Controller độc quyền sản xuất trên tiến trình 8nm và chip nhớ V-NAND V7 TLC, ổ đĩa đạt thông số đọc ghi tuần tự <strong>7.450 MB/s và 6.900 MB/s</strong>, tốc độ đọc ngẫu nhiên lên tới 1.400.000 IOPS giúp load game 4K và khởi động dự án dựng phim nặng gần như lập tức.</p>
<h3>2. Phần mềm quản lý Samsung Magician</h3>
<p>Công cụ Magician cho phép người dùng dễ dàng theo dõi sức khỏe ổ đĩa, cập nhật firmware mới, kiểm tra nhiệt độ và kích hoạt chế độ Full Performance Mode để tối đa hóa hiệu năng.</p>""",
        "thumbnail": "https://images.unsplash.com/photo-1597872200969-2b65d56bd16b?auto=format&fit=crop&w=1000&q=80",
        "view_count": 31400,
        "meta_title": "Review SSD Samsung 990 PRO 2TB - LuxuryPC",
        "meta_description": "Đánh giá chi tiết tốc độ và độ bền của ổ cứng SSD NVMe tốt nhất hiện nay Samsung 990 PRO 2TB.",
        "meta_keywords": "samsung 990 pro 2tb, review ssd samsung, ssd pcie 4.0, ổ cứng load game nhanh",
        "created_at": "2026-04-18 15:10:00"
    },
    {
        "id": 25,
        "title": "Đánh giá Vỏ case Corsair 3500X TG Black: Thiết kế Panoramic hồ cá view trọn vẹn góc máy",
        "slug": "danh-gia-vo-case-corsair-3500x-tg-black-ho-ca",
        "category_id": 5,
        "summary": "Mẫu case bể cá không viền cột chữ A hiện đại, hỗ trợ bo mạch chủ giấu dây BTF/Project Stealth, không gian lắp đặt tản nhiệt nước 360mm rộng rãi và thông thoáng.",
        "content": """<p><strong>Corsair 3500X TG</strong> là đại diện tiêu biểu cho xu hướng vỏ case bể cá Panoramic kính cường lực uốn cong liền mạch đang rất được ưa chuộng năm 2026.</p>
<h3>1. Tầm nhìn 270 độ không vật cản</h3>
<p>Bằng cách loại bỏ cột trụ góc chữ A phía trước, toàn bộ linh kiện bên trong dàn PC được phô diễn trọn vẹn như một tác phẩm nghệ thuật. Tấm kính cường lực dày dặn có cơ chế tháo lắp không cần ốc vít (Tool-free) tiện lợi.</p>
<h3>2. Tương thích hoàn hảo với Mainboard Giấu Dây (Reverse Connector)</h3>
<p>Khay lắp mainboard được thiết kế sẵn các lỗ khoét chuẩn xác hỗ trợ các dòng bo mạch chủ giấu dây ASUS BTF, MSI Project Zero và GIGABYTE Stealth, mang lại một khoang máy sạch bóng không một sợi dây thừa.</p>""",
        "thumbnail": "https://images.unsplash.com/photo-1587202372634-32705e3bf49c?auto=format&fit=crop&w=1000&q=80",
        "view_count": 27900,
        "meta_title": "Đánh giá Case Corsair 3500X TG Panoramic - LuxuryPC",
        "meta_description": "Review vỏ case bể cá Corsair 3500X TG hỗ trợ mainboard giấu dây BTF và tản nhiệt nước 360mm.",
        "meta_keywords": "corsair 3500x, case bể cá, case panoramic, mainboard giấu dây btf, review case pc",
        "created_at": "2026-05-25 11:00:00"
    }
]

# Generate SQL Statements
sql_statements = []
sql_statements.append("SET QUOTED_IDENTIFIER ON;")
sql_statements.append("SET ANSI_NULLS ON;")
sql_statements.append("GO")
sql_statements.append("USE LUXURYPC;")
sql_statements.append("GO")

# Ensure table exists
sql_statements.append("""
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'news') AND type IN ('U')) DROP TABLE news;
GO
CREATE TABLE news (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    slug NVARCHAR(255) NOT NULL,
    summary NVARCHAR(MAX),
    content NVARCHAR(MAX),
    thumbnail NVARCHAR(500),
    author_id INT NOT NULL,
    category_id INT,
    status NVARCHAR(20) DEFAULT 'PUBLISHED',
    meta_title NVARCHAR(255),
    meta_description NVARCHAR(MAX),
    meta_keywords NVARCHAR(255),
    view_count BIGINT DEFAULT 0,
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO
""")

sql_statements.append("SET IDENTITY_INSERT news ON;")
sql_statements.append("INSERT INTO news (id, title, slug, summary, content, thumbnail, author_id, category_id, status, meta_title, meta_description, meta_keywords, view_count, created_at, updated_at) VALUES")

row_sqls = []
for a in articles:
    t_escaped = a["title"].replace("'", "''")
    s_escaped = a["summary"].replace("'", "''")
    c_escaped = a["content"].replace("'", "''")
    mt_escaped = a["meta_title"].replace("'", "''")
    md_escaped = a["meta_description"].replace("'", "''")
    mk_escaped = a["meta_keywords"].replace("'", "''")
    thumb = a["thumbnail"].replace("'", "''")
    
    row = f"({a['id']}, N'{t_escaped}', '{a['slug']}', N'{s_escaped}', N'{c_escaped}', '{thumb}', 1, {a['category_id']}, 'PUBLISHED', N'{mt_escaped}', N'{md_escaped}', N'{mk_escaped}', {a['view_count']}, '{a['created_at']}', '{a['created_at']}')"
    row_sqls.append(row)

sql_statements.append(",\n".join(row_sqls) + ";")
sql_statements.append("SET IDENTITY_INSERT news OFF;")
sql_statements.append("DBCC CHECKIDENT ('news', RESEED, 25);")
sql_statements.append("GO")

full_news_sql = "\n".join(sql_statements)

with open('scratch/seed_25_news.sql', 'w', encoding='utf-8') as f:
    f.write(full_news_sql)

print(f"Generated SQL script with {len(articles)} articles!")

# Execute against SQL Server
cmd = ['sqlcmd', '-S', 'localhost', '-U', 'tuan2006', '-P', '24112004', '-C', '-f', '65001', '-i', 'scratch/seed_25_news.sql']
res = subprocess.run(cmd, capture_output=True, text=True)
print("Execution Result:")
print(res.stdout)
if res.stderr:
    print("Stderr:", res.stderr)
