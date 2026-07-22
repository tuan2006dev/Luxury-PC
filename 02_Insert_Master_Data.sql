-- MASTER DB LOADER SCRIPT
BEGIN TRANSACTION;
BEGIN TRY

-- [Mainboard] Product: Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)' as name, N'may-bo-acer-atlos-p130f7-i5-ram-8gb-ssd-512gb' as slug, N'PC-ACER-ATLOS-I5' as sku, N'GENERIC-38376' as mpn, 11990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Mainboard] Product: PC GVN Homework Athlon
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'PC GVN Homework Athlon' as name, N'pc-gvn-homework-amd-athlon' as slug, N'PC-GVN-ARES' as sku, N'GENERIC-80485' as mpn, 7190000 as price, N'[{"key":"Mainboard:","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU:","value":"Athlon 3000G / 5MB / 3.5GHz / 2 nhân 4 luồng / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD:","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD:","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU:","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case:","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Mainboard] Product: PC GVN Homework R3
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'PC GVN Homework R3' as name, N'pc-gvn-homework-amd-r3' as slug, N'PC-GVN-HOMEWORK-R3' as sku, N'GENERIC-78222' as mpn, 7630000 as price, N'[{"key":"Mainboard","value":"Bo Mạch Chủ Gigabyte A520M-K V2"},{"key":"CPU","value":"Bộ vi xử lý AMD Ryzen 3 3200G / 3.6GHz Boost 4.0GHz / 4 nhân 4 luồng (TRAY)"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Jetek 350W Elite V2"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Mainboard] Product: PC GVN Homework R5
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'PC GVN Homework R5' as name, N'pc-gvn-homework-amd-r5' as slug, N'PC-GVN-HOMEWORK-R5' as sku, N'GENERIC-11330' as mpn, 10390000 as price, N'[{"key":"","value":"Tên Sản phẩm"},{"key":"Mainboard","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU","value":"AMD Ryzen 5 5600GT / 3.6GHz Boost 4.6GHz / 6 nhân 12 luồng / 19MB / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"VGA","value":"Có thể tùy chọn Nâng cấp"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Mainboard] Product: PC GVN Homework i5
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'PC GVN Homework i5' as name, N'pc-gvn-homework-intel-i5' as slug, N'PC-GVN-HOMEWORK-I5' as sku, N'GENERIC-93190' as mpn, 12990000 as price, N'[{"key":"Mainboard","value":"Mainboard Gigabyte H610M-H V3 DDR4"},{"key":"CPU","value":"Intel Core i5 14400 / Turbo up to 4.7GHz / 10 Nhân 16 Luồng / LGA 1700"},{"key":"RAM","value":"Ram SSTC 8GB DDR4 3200MHz (U3200A-C22-8GB)"},{"key":"SSD","value":"Ổ Cứng SSD SSTC M2 NVME Gen3x4 Max III 256GB"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Mainboard] Product: Phần mềm Windows 11 Home Online DwnLd NR KW9-00664
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Home Online DwnLd NR KW9-00664' as name, N'phan-mem-windows-11-home-online-dwnld-nr-kw9-00664' as slug, N'PM-MS-WIN11-HOME-FPP-OL-WK9-00664' as sku, N'GENERIC-99778' as mpn, 3490000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"KW9-00664"},{"key":"Hình thức","value":"FPP(ESD) (Full Packaged Product)"},{"key":"Số máy cài đặt","value":"1"},{"key":"Thời hạn","value":"Thời gian sử dụng phần cứng"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Mainboard] Product: Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572' as name, N'phan-mem-windows-11-pro-online-dwnld-nr-fqc-10572' as slug, N'PM-MS-WIN11-PRO-FPP-OL-FQC-10572' as sku, N'GENERIC-41270' as mpn, 5150000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"FQC-10572"},{"key":"Tên sản phẩm","value":"Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572"},{"key":"Tính năng","value":"- Thích hợp cho kinh doanh- Đa nhiệm- Microsoft Edge - Cortana- Chế độ Máy tính bảng- Máy tính từ xa"},{"key":"Thiết bị","value":"1"},{"key":"Thời hạn","value":"Vĩnh viễn"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Mainboard] Product: Máy chơi game MSI Claw A1M
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Máy chơi game MSI Claw A1M' as name, N'may-choi-game-msi-claw-a1m' as slug, N'MCG-MSI-CLAW-A1M' as sku, N'GENERIC-94699' as mpn, 14990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Mainboard] Product: Máy chơi Game cầm tay Lenovo Legion GO
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Máy chơi Game cầm tay Lenovo Legion GO' as name, N'may-choi-game-cam-tay-lenovo-legion-go' as slug, N'MCG-LENOVO-LEGION-GO' as sku, N'GENERIC-11568' as mpn, 22990000 as price, N'[{"key":"CPU","value":"AMD Ryzen™ Z1 Extreme Processor (Zen4 architecture with 4nm process, 8-core /16-threads, 24MB total cache, up to 5.10 GHz boost)"},{"key":"RAM","value":"16GB (8x2) LPDDR5x 7500 Onboard"},{"key":"Ổ cứng","value":"512GB PCIe® 4.0 NVMe™ M.2 SSD (2242)"},{"key":"VGA","value":"AMD Radeon™ Graphics (AMD RDNA™ 3, 12 CUs, up to 2.7GHz, up to 8.6 Teraflops), TDP: 9-30W"},{"key":"Màn hình","value":"8.8\" WQXGA (2560x1600), Multi-touch, IPS, 500nits, Glossy, anti-fingerprint, 16:10, 1500:1, 97% DCI-P3, 144Hz, 89°/89°/80°/80°, Corning® Gorilla® Glass 5"},{"key":"Cổng giao tiếp","value":"2x USB4® 40Gbps (support data transfer, Power Delivery 3.0 and DisplayPort™ 1.4)1x Headphone / microphone combo jack (3.5mm)1x Card reader2x Pogo pin connector (5-point)"},{"key":"Hệ thống điều khiển","value":"A B X Y buttonsD-padTouchpadFPS mode switchMouse wheelLeft & right JoysticksLeft & right release buttonsLB buttonM1 / RB buttonM2 buttonY1 & Y2 buttonsM3 & Y3 buttons4x function buttons"},{"key":"Audio","value":"Stereo speakers, 2W x2, High Definition (HD) Audio"},{"key":"Chuẩn WIFI","value":"AMD Wi-Fi® 6E RZ616, 802.11ax (2x2)"},{"key":"Bluetooth","value":"v5.3"},{"key":"Hệ điều hành","value":"Windows 11 Home"},{"key":"Pin","value":"Integrated Li-Polymer 49.2Wh"},{"key":"Sạc","value":"65W USB-C® (3-pin) AC adapter, supports PD 3.0, 100-240V, 50-60Hz"},{"key":"Trọng lượng","value":"Gamepad: 640 gGamepad with controllers: 854g"},{"key":"Màu sắc","value":"Shadow black"},{"key":"Kích thước","value":"Gamepad: 210 x 131 x 20.1 (mm)Gamepad with controllers: 298.83 x 131 x 40.7 (mm)"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');

-- [HDD] Product: Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)
MERGE INTO products AS target
USING (SELECT 6 as category_id, 1 as brand_id, N'Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)' as name, N'may-bo-acer-atlos-p130f7-i5-ram-8gb-ssd-512gb' as slug, N'PC-ACER-ATLOS-I5' as sku, N'GENERIC-85349' as mpn, 11990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [HDD] Product: PC GVN Homework Athlon
MERGE INTO products AS target
USING (SELECT 6 as category_id, 1 as brand_id, N'PC GVN Homework Athlon' as name, N'pc-gvn-homework-amd-athlon' as slug, N'PC-GVN-ARES' as sku, N'GENERIC-43764' as mpn, 7190000 as price, N'[{"key":"Mainboard:","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU:","value":"Athlon 3000G / 5MB / 3.5GHz / 2 nhân 4 luồng / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD:","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD:","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU:","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case:","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [HDD] Product: PC GVN Homework R3
MERGE INTO products AS target
USING (SELECT 6 as category_id, 1 as brand_id, N'PC GVN Homework R3' as name, N'pc-gvn-homework-amd-r3' as slug, N'PC-GVN-HOMEWORK-R3' as sku, N'GENERIC-734' as mpn, 7630000 as price, N'[{"key":"Mainboard","value":"Bo Mạch Chủ Gigabyte A520M-K V2"},{"key":"CPU","value":"Bộ vi xử lý AMD Ryzen 3 3200G / 3.6GHz Boost 4.0GHz / 4 nhân 4 luồng (TRAY)"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Jetek 350W Elite V2"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [HDD] Product: PC GVN Homework R5
MERGE INTO products AS target
USING (SELECT 6 as category_id, 1 as brand_id, N'PC GVN Homework R5' as name, N'pc-gvn-homework-amd-r5' as slug, N'PC-GVN-HOMEWORK-R5' as sku, N'GENERIC-88661' as mpn, 10390000 as price, N'[{"key":"","value":"Tên Sản phẩm"},{"key":"Mainboard","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU","value":"AMD Ryzen 5 5600GT / 3.6GHz Boost 4.6GHz / 6 nhân 12 luồng / 19MB / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"VGA","value":"Có thể tùy chọn Nâng cấp"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [HDD] Product: PC GVN Homework i5
MERGE INTO products AS target
USING (SELECT 6 as category_id, 1 as brand_id, N'PC GVN Homework i5' as name, N'pc-gvn-homework-intel-i5' as slug, N'PC-GVN-HOMEWORK-I5' as sku, N'GENERIC-72908' as mpn, 12990000 as price, N'[{"key":"Mainboard","value":"Mainboard Gigabyte H610M-H V3 DDR4"},{"key":"CPU","value":"Intel Core i5 14400 / Turbo up to 4.7GHz / 10 Nhân 16 Luồng / LGA 1700"},{"key":"RAM","value":"Ram SSTC 8GB DDR4 3200MHz (U3200A-C22-8GB)"},{"key":"SSD","value":"Ổ Cứng SSD SSTC M2 NVME Gen3x4 Max III 256GB"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [HDD] Product: Phần mềm Windows 11 Home Online DwnLd NR KW9-00664
MERGE INTO products AS target
USING (SELECT 6 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Home Online DwnLd NR KW9-00664' as name, N'phan-mem-windows-11-home-online-dwnld-nr-kw9-00664' as slug, N'PM-MS-WIN11-HOME-FPP-OL-WK9-00664' as sku, N'GENERIC-83880' as mpn, 3490000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"KW9-00664"},{"key":"Hình thức","value":"FPP(ESD) (Full Packaged Product)"},{"key":"Số máy cài đặt","value":"1"},{"key":"Thời hạn","value":"Thời gian sử dụng phần cứng"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [HDD] Product: Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572
MERGE INTO products AS target
USING (SELECT 6 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572' as name, N'phan-mem-windows-11-pro-online-dwnld-nr-fqc-10572' as slug, N'PM-MS-WIN11-PRO-FPP-OL-FQC-10572' as sku, N'GENERIC-72275' as mpn, 5150000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"FQC-10572"},{"key":"Tên sản phẩm","value":"Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572"},{"key":"Tính năng","value":"- Thích hợp cho kinh doanh- Đa nhiệm- Microsoft Edge - Cortana- Chế độ Máy tính bảng- Máy tính từ xa"},{"key":"Thiết bị","value":"1"},{"key":"Thời hạn","value":"Vĩnh viễn"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [HDD] Product: Máy chơi game MSI Claw A1M
MERGE INTO products AS target
USING (SELECT 6 as category_id, 1 as brand_id, N'Máy chơi game MSI Claw A1M' as name, N'may-choi-game-msi-claw-a1m' as slug, N'MCG-MSI-CLAW-A1M' as sku, N'GENERIC-10939' as mpn, 14990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [HDD] Product: Máy chơi Game cầm tay Lenovo Legion GO
MERGE INTO products AS target
USING (SELECT 6 as category_id, 1 as brand_id, N'Máy chơi Game cầm tay Lenovo Legion GO' as name, N'may-choi-game-cam-tay-lenovo-legion-go' as slug, N'MCG-LENOVO-LEGION-GO' as sku, N'GENERIC-97567' as mpn, 22990000 as price, N'[{"key":"CPU","value":"AMD Ryzen™ Z1 Extreme Processor (Zen4 architecture with 4nm process, 8-core /16-threads, 24MB total cache, up to 5.10 GHz boost)"},{"key":"RAM","value":"16GB (8x2) LPDDR5x 7500 Onboard"},{"key":"Ổ cứng","value":"512GB PCIe® 4.0 NVMe™ M.2 SSD (2242)"},{"key":"VGA","value":"AMD Radeon™ Graphics (AMD RDNA™ 3, 12 CUs, up to 2.7GHz, up to 8.6 Teraflops), TDP: 9-30W"},{"key":"Màn hình","value":"8.8\" WQXGA (2560x1600), Multi-touch, IPS, 500nits, Glossy, anti-fingerprint, 16:10, 1500:1, 97% DCI-P3, 144Hz, 89°/89°/80°/80°, Corning® Gorilla® Glass 5"},{"key":"Cổng giao tiếp","value":"2x USB4® 40Gbps (support data transfer, Power Delivery 3.0 and DisplayPort™ 1.4)1x Headphone / microphone combo jack (3.5mm)1x Card reader2x Pogo pin connector (5-point)"},{"key":"Hệ thống điều khiển","value":"A B X Y buttonsD-padTouchpadFPS mode switchMouse wheelLeft & right JoysticksLeft & right release buttonsLB buttonM1 / RB buttonM2 buttonY1 & Y2 buttonsM3 & Y3 buttons4x function buttons"},{"key":"Audio","value":"Stereo speakers, 2W x2, High Definition (HD) Audio"},{"key":"Chuẩn WIFI","value":"AMD Wi-Fi® 6E RZ616, 802.11ax (2x2)"},{"key":"Bluetooth","value":"v5.3"},{"key":"Hệ điều hành","value":"Windows 11 Home"},{"key":"Pin","value":"Integrated Li-Polymer 49.2Wh"},{"key":"Sạc","value":"65W USB-C® (3-pin) AC adapter, supports PD 3.0, 100-240V, 50-60Hz"},{"key":"Trọng lượng","value":"Gamepad: 640 gGamepad with controllers: 854g"},{"key":"Màu sắc","value":"Shadow black"},{"key":"Kích thước","value":"Gamepad: 210 x 131 x 20.1 (mm)Gamepad with controllers: 298.83 x 131 x 40.7 (mm)"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');

-- [Case] Product: Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)
MERGE INTO products AS target
USING (SELECT 12 as category_id, 1 as brand_id, N'Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)' as name, N'may-bo-acer-atlos-p130f7-i5-ram-8gb-ssd-512gb' as slug, N'PC-ACER-ATLOS-I5' as sku, N'GENERIC-36726' as mpn, 11990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Case] Product: PC GVN Homework Athlon
MERGE INTO products AS target
USING (SELECT 12 as category_id, 1 as brand_id, N'PC GVN Homework Athlon' as name, N'pc-gvn-homework-amd-athlon' as slug, N'PC-GVN-ARES' as sku, N'GENERIC-41964' as mpn, 7190000 as price, N'[{"key":"Mainboard:","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU:","value":"Athlon 3000G / 5MB / 3.5GHz / 2 nhân 4 luồng / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD:","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD:","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU:","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case:","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Case] Product: PC GVN Homework R3
MERGE INTO products AS target
USING (SELECT 12 as category_id, 1 as brand_id, N'PC GVN Homework R3' as name, N'pc-gvn-homework-amd-r3' as slug, N'PC-GVN-HOMEWORK-R3' as sku, N'GENERIC-71873' as mpn, 7630000 as price, N'[{"key":"Mainboard","value":"Bo Mạch Chủ Gigabyte A520M-K V2"},{"key":"CPU","value":"Bộ vi xử lý AMD Ryzen 3 3200G / 3.6GHz Boost 4.0GHz / 4 nhân 4 luồng (TRAY)"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Jetek 350W Elite V2"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Case] Product: PC GVN Homework R5
MERGE INTO products AS target
USING (SELECT 12 as category_id, 1 as brand_id, N'PC GVN Homework R5' as name, N'pc-gvn-homework-amd-r5' as slug, N'PC-GVN-HOMEWORK-R5' as sku, N'GENERIC-3024' as mpn, 10390000 as price, N'[{"key":"","value":"Tên Sản phẩm"},{"key":"Mainboard","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU","value":"AMD Ryzen 5 5600GT / 3.6GHz Boost 4.6GHz / 6 nhân 12 luồng / 19MB / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"VGA","value":"Có thể tùy chọn Nâng cấp"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Case] Product: PC GVN Homework i5
MERGE INTO products AS target
USING (SELECT 12 as category_id, 1 as brand_id, N'PC GVN Homework i5' as name, N'pc-gvn-homework-intel-i5' as slug, N'PC-GVN-HOMEWORK-I5' as sku, N'GENERIC-73331' as mpn, 12990000 as price, N'[{"key":"Mainboard","value":"Mainboard Gigabyte H610M-H V3 DDR4"},{"key":"CPU","value":"Intel Core i5 14400 / Turbo up to 4.7GHz / 10 Nhân 16 Luồng / LGA 1700"},{"key":"RAM","value":"Ram SSTC 8GB DDR4 3200MHz (U3200A-C22-8GB)"},{"key":"SSD","value":"Ổ Cứng SSD SSTC M2 NVME Gen3x4 Max III 256GB"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Case] Product: Phần mềm Windows 11 Home Online DwnLd NR KW9-00664
MERGE INTO products AS target
USING (SELECT 12 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Home Online DwnLd NR KW9-00664' as name, N'phan-mem-windows-11-home-online-dwnld-nr-kw9-00664' as slug, N'PM-MS-WIN11-HOME-FPP-OL-WK9-00664' as sku, N'GENERIC-31972' as mpn, 3490000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"KW9-00664"},{"key":"Hình thức","value":"FPP(ESD) (Full Packaged Product)"},{"key":"Số máy cài đặt","value":"1"},{"key":"Thời hạn","value":"Thời gian sử dụng phần cứng"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Case] Product: Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572
MERGE INTO products AS target
USING (SELECT 12 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572' as name, N'phan-mem-windows-11-pro-online-dwnld-nr-fqc-10572' as slug, N'PM-MS-WIN11-PRO-FPP-OL-FQC-10572' as sku, N'GENERIC-20339' as mpn, 5150000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"FQC-10572"},{"key":"Tên sản phẩm","value":"Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572"},{"key":"Tính năng","value":"- Thích hợp cho kinh doanh- Đa nhiệm- Microsoft Edge - Cortana- Chế độ Máy tính bảng- Máy tính từ xa"},{"key":"Thiết bị","value":"1"},{"key":"Thời hạn","value":"Vĩnh viễn"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Case] Product: Máy chơi game MSI Claw A1M
MERGE INTO products AS target
USING (SELECT 12 as category_id, 1 as brand_id, N'Máy chơi game MSI Claw A1M' as name, N'may-choi-game-msi-claw-a1m' as slug, N'MCG-MSI-CLAW-A1M' as sku, N'GENERIC-37243' as mpn, 14990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Case] Product: Máy chơi Game cầm tay Lenovo Legion GO
MERGE INTO products AS target
USING (SELECT 12 as category_id, 1 as brand_id, N'Máy chơi Game cầm tay Lenovo Legion GO' as name, N'may-choi-game-cam-tay-lenovo-legion-go' as slug, N'MCG-LENOVO-LEGION-GO' as sku, N'GENERIC-55362' as mpn, 22990000 as price, N'[{"key":"CPU","value":"AMD Ryzen™ Z1 Extreme Processor (Zen4 architecture with 4nm process, 8-core /16-threads, 24MB total cache, up to 5.10 GHz boost)"},{"key":"RAM","value":"16GB (8x2) LPDDR5x 7500 Onboard"},{"key":"Ổ cứng","value":"512GB PCIe® 4.0 NVMe™ M.2 SSD (2242)"},{"key":"VGA","value":"AMD Radeon™ Graphics (AMD RDNA™ 3, 12 CUs, up to 2.7GHz, up to 8.6 Teraflops), TDP: 9-30W"},{"key":"Màn hình","value":"8.8\" WQXGA (2560x1600), Multi-touch, IPS, 500nits, Glossy, anti-fingerprint, 16:10, 1500:1, 97% DCI-P3, 144Hz, 89°/89°/80°/80°, Corning® Gorilla® Glass 5"},{"key":"Cổng giao tiếp","value":"2x USB4® 40Gbps (support data transfer, Power Delivery 3.0 and DisplayPort™ 1.4)1x Headphone / microphone combo jack (3.5mm)1x Card reader2x Pogo pin connector (5-point)"},{"key":"Hệ thống điều khiển","value":"A B X Y buttonsD-padTouchpadFPS mode switchMouse wheelLeft & right JoysticksLeft & right release buttonsLB buttonM1 / RB buttonM2 buttonY1 & Y2 buttonsM3 & Y3 buttons4x function buttons"},{"key":"Audio","value":"Stereo speakers, 2W x2, High Definition (HD) Audio"},{"key":"Chuẩn WIFI","value":"AMD Wi-Fi® 6E RZ616, 802.11ax (2x2)"},{"key":"Bluetooth","value":"v5.3"},{"key":"Hệ điều hành","value":"Windows 11 Home"},{"key":"Pin","value":"Integrated Li-Polymer 49.2Wh"},{"key":"Sạc","value":"65W USB-C® (3-pin) AC adapter, supports PD 3.0, 100-240V, 50-60Hz"},{"key":"Trọng lượng","value":"Gamepad: 640 gGamepad with controllers: 854g"},{"key":"Màu sắc","value":"Shadow black"},{"key":"Kích thước","value":"Gamepad: 210 x 131 x 20.1 (mm)Gamepad with controllers: 298.83 x 131 x 40.7 (mm)"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');

-- [Cooler] Product: Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)
MERGE INTO products AS target
USING (SELECT 13 as category_id, 1 as brand_id, N'Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)' as name, N'may-bo-acer-atlos-p130f7-i5-ram-8gb-ssd-512gb' as slug, N'PC-ACER-ATLOS-I5' as sku, N'GENERIC-60716' as mpn, 11990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cooler] Product: PC GVN Homework Athlon
MERGE INTO products AS target
USING (SELECT 13 as category_id, 1 as brand_id, N'PC GVN Homework Athlon' as name, N'pc-gvn-homework-amd-athlon' as slug, N'PC-GVN-ARES' as sku, N'GENERIC-65872' as mpn, 7190000 as price, N'[{"key":"Mainboard:","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU:","value":"Athlon 3000G / 5MB / 3.5GHz / 2 nhân 4 luồng / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD:","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD:","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU:","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case:","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cooler] Product: PC GVN Homework R3
MERGE INTO products AS target
USING (SELECT 13 as category_id, 1 as brand_id, N'PC GVN Homework R3' as name, N'pc-gvn-homework-amd-r3' as slug, N'PC-GVN-HOMEWORK-R3' as sku, N'GENERIC-33505' as mpn, 7630000 as price, N'[{"key":"Mainboard","value":"Bo Mạch Chủ Gigabyte A520M-K V2"},{"key":"CPU","value":"Bộ vi xử lý AMD Ryzen 3 3200G / 3.6GHz Boost 4.0GHz / 4 nhân 4 luồng (TRAY)"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Jetek 350W Elite V2"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cooler] Product: PC GVN Homework R5
MERGE INTO products AS target
USING (SELECT 13 as category_id, 1 as brand_id, N'PC GVN Homework R5' as name, N'pc-gvn-homework-amd-r5' as slug, N'PC-GVN-HOMEWORK-R5' as sku, N'GENERIC-31132' as mpn, 10390000 as price, N'[{"key":"","value":"Tên Sản phẩm"},{"key":"Mainboard","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU","value":"AMD Ryzen 5 5600GT / 3.6GHz Boost 4.6GHz / 6 nhân 12 luồng / 19MB / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"VGA","value":"Có thể tùy chọn Nâng cấp"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cooler] Product: PC GVN Homework i5
MERGE INTO products AS target
USING (SELECT 13 as category_id, 1 as brand_id, N'PC GVN Homework i5' as name, N'pc-gvn-homework-intel-i5' as slug, N'PC-GVN-HOMEWORK-I5' as sku, N'GENERIC-77105' as mpn, 12990000 as price, N'[{"key":"Mainboard","value":"Mainboard Gigabyte H610M-H V3 DDR4"},{"key":"CPU","value":"Intel Core i5 14400 / Turbo up to 4.7GHz / 10 Nhân 16 Luồng / LGA 1700"},{"key":"RAM","value":"Ram SSTC 8GB DDR4 3200MHz (U3200A-C22-8GB)"},{"key":"SSD","value":"Ổ Cứng SSD SSTC M2 NVME Gen3x4 Max III 256GB"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cooler] Product: Phần mềm Windows 11 Home Online DwnLd NR KW9-00664
MERGE INTO products AS target
USING (SELECT 13 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Home Online DwnLd NR KW9-00664' as name, N'phan-mem-windows-11-home-online-dwnld-nr-kw9-00664' as slug, N'PM-MS-WIN11-HOME-FPP-OL-WK9-00664' as sku, N'GENERIC-35947' as mpn, 3490000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"KW9-00664"},{"key":"Hình thức","value":"FPP(ESD) (Full Packaged Product)"},{"key":"Số máy cài đặt","value":"1"},{"key":"Thời hạn","value":"Thời gian sử dụng phần cứng"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cooler] Product: Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572
MERGE INTO products AS target
USING (SELECT 13 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572' as name, N'phan-mem-windows-11-pro-online-dwnld-nr-fqc-10572' as slug, N'PM-MS-WIN11-PRO-FPP-OL-FQC-10572' as sku, N'GENERIC-34263' as mpn, 5150000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"FQC-10572"},{"key":"Tên sản phẩm","value":"Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572"},{"key":"Tính năng","value":"- Thích hợp cho kinh doanh- Đa nhiệm- Microsoft Edge - Cortana- Chế độ Máy tính bảng- Máy tính từ xa"},{"key":"Thiết bị","value":"1"},{"key":"Thời hạn","value":"Vĩnh viễn"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cooler] Product: Máy chơi game MSI Claw A1M
MERGE INTO products AS target
USING (SELECT 13 as category_id, 1 as brand_id, N'Máy chơi game MSI Claw A1M' as name, N'may-choi-game-msi-claw-a1m' as slug, N'MCG-MSI-CLAW-A1M' as sku, N'GENERIC-17760' as mpn, 14990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cooler] Product: Máy chơi Game cầm tay Lenovo Legion GO
MERGE INTO products AS target
USING (SELECT 13 as category_id, 1 as brand_id, N'Máy chơi Game cầm tay Lenovo Legion GO' as name, N'may-choi-game-cam-tay-lenovo-legion-go' as slug, N'MCG-LENOVO-LEGION-GO' as sku, N'GENERIC-29633' as mpn, 22990000 as price, N'[{"key":"CPU","value":"AMD Ryzen™ Z1 Extreme Processor (Zen4 architecture with 4nm process, 8-core /16-threads, 24MB total cache, up to 5.10 GHz boost)"},{"key":"RAM","value":"16GB (8x2) LPDDR5x 7500 Onboard"},{"key":"Ổ cứng","value":"512GB PCIe® 4.0 NVMe™ M.2 SSD (2242)"},{"key":"VGA","value":"AMD Radeon™ Graphics (AMD RDNA™ 3, 12 CUs, up to 2.7GHz, up to 8.6 Teraflops), TDP: 9-30W"},{"key":"Màn hình","value":"8.8\" WQXGA (2560x1600), Multi-touch, IPS, 500nits, Glossy, anti-fingerprint, 16:10, 1500:1, 97% DCI-P3, 144Hz, 89°/89°/80°/80°, Corning® Gorilla® Glass 5"},{"key":"Cổng giao tiếp","value":"2x USB4® 40Gbps (support data transfer, Power Delivery 3.0 and DisplayPort™ 1.4)1x Headphone / microphone combo jack (3.5mm)1x Card reader2x Pogo pin connector (5-point)"},{"key":"Hệ thống điều khiển","value":"A B X Y buttonsD-padTouchpadFPS mode switchMouse wheelLeft & right JoysticksLeft & right release buttonsLB buttonM1 / RB buttonM2 buttonY1 & Y2 buttonsM3 & Y3 buttons4x function buttons"},{"key":"Audio","value":"Stereo speakers, 2W x2, High Definition (HD) Audio"},{"key":"Chuẩn WIFI","value":"AMD Wi-Fi® 6E RZ616, 802.11ax (2x2)"},{"key":"Bluetooth","value":"v5.3"},{"key":"Hệ điều hành","value":"Windows 11 Home"},{"key":"Pin","value":"Integrated Li-Polymer 49.2Wh"},{"key":"Sạc","value":"65W USB-C® (3-pin) AC adapter, supports PD 3.0, 100-240V, 50-60Hz"},{"key":"Trọng lượng","value":"Gamepad: 640 gGamepad with controllers: 854g"},{"key":"Màu sắc","value":"Shadow black"},{"key":"Kích thước","value":"Gamepad: 210 x 131 x 20.1 (mm)Gamepad with controllers: 298.83 x 131 x 40.7 (mm)"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');

-- [Speaker] Product: Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)
MERGE INTO products AS target
USING (SELECT 18 as category_id, 1 as brand_id, N'Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)' as name, N'may-bo-acer-atlos-p130f7-i5-ram-8gb-ssd-512gb' as slug, N'PC-ACER-ATLOS-I5' as sku, N'GENERIC-73006' as mpn, 11990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Speaker] Product: PC GVN Homework Athlon
MERGE INTO products AS target
USING (SELECT 18 as category_id, 1 as brand_id, N'PC GVN Homework Athlon' as name, N'pc-gvn-homework-amd-athlon' as slug, N'PC-GVN-ARES' as sku, N'GENERIC-55984' as mpn, 7190000 as price, N'[{"key":"Mainboard:","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU:","value":"Athlon 3000G / 5MB / 3.5GHz / 2 nhân 4 luồng / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD:","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD:","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU:","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case:","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Speaker] Product: PC GVN Homework R3
MERGE INTO products AS target
USING (SELECT 18 as category_id, 1 as brand_id, N'PC GVN Homework R3' as name, N'pc-gvn-homework-amd-r3' as slug, N'PC-GVN-HOMEWORK-R3' as sku, N'GENERIC-29419' as mpn, 7630000 as price, N'[{"key":"Mainboard","value":"Bo Mạch Chủ Gigabyte A520M-K V2"},{"key":"CPU","value":"Bộ vi xử lý AMD Ryzen 3 3200G / 3.6GHz Boost 4.0GHz / 4 nhân 4 luồng (TRAY)"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Jetek 350W Elite V2"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Speaker] Product: PC GVN Homework R5
MERGE INTO products AS target
USING (SELECT 18 as category_id, 1 as brand_id, N'PC GVN Homework R5' as name, N'pc-gvn-homework-amd-r5' as slug, N'PC-GVN-HOMEWORK-R5' as sku, N'GENERIC-6514' as mpn, 10390000 as price, N'[{"key":"","value":"Tên Sản phẩm"},{"key":"Mainboard","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU","value":"AMD Ryzen 5 5600GT / 3.6GHz Boost 4.6GHz / 6 nhân 12 luồng / 19MB / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"VGA","value":"Có thể tùy chọn Nâng cấp"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Speaker] Product: PC GVN Homework i5
MERGE INTO products AS target
USING (SELECT 18 as category_id, 1 as brand_id, N'PC GVN Homework i5' as name, N'pc-gvn-homework-intel-i5' as slug, N'PC-GVN-HOMEWORK-I5' as sku, N'GENERIC-79490' as mpn, 12990000 as price, N'[{"key":"Mainboard","value":"Mainboard Gigabyte H610M-H V3 DDR4"},{"key":"CPU","value":"Intel Core i5 14400 / Turbo up to 4.7GHz / 10 Nhân 16 Luồng / LGA 1700"},{"key":"RAM","value":"Ram SSTC 8GB DDR4 3200MHz (U3200A-C22-8GB)"},{"key":"SSD","value":"Ổ Cứng SSD SSTC M2 NVME Gen3x4 Max III 256GB"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Speaker] Product: Phần mềm Windows 11 Home Online DwnLd NR KW9-00664
MERGE INTO products AS target
USING (SELECT 18 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Home Online DwnLd NR KW9-00664' as name, N'phan-mem-windows-11-home-online-dwnld-nr-kw9-00664' as slug, N'PM-MS-WIN11-HOME-FPP-OL-WK9-00664' as sku, N'GENERIC-7539' as mpn, 3490000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"KW9-00664"},{"key":"Hình thức","value":"FPP(ESD) (Full Packaged Product)"},{"key":"Số máy cài đặt","value":"1"},{"key":"Thời hạn","value":"Thời gian sử dụng phần cứng"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Speaker] Product: Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572
MERGE INTO products AS target
USING (SELECT 18 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572' as name, N'phan-mem-windows-11-pro-online-dwnld-nr-fqc-10572' as slug, N'PM-MS-WIN11-PRO-FPP-OL-FQC-10572' as sku, N'GENERIC-20041' as mpn, 5150000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"FQC-10572"},{"key":"Tên sản phẩm","value":"Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572"},{"key":"Tính năng","value":"- Thích hợp cho kinh doanh- Đa nhiệm- Microsoft Edge - Cortana- Chế độ Máy tính bảng- Máy tính từ xa"},{"key":"Thiết bị","value":"1"},{"key":"Thời hạn","value":"Vĩnh viễn"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Speaker] Product: Máy chơi game MSI Claw A1M
MERGE INTO products AS target
USING (SELECT 18 as category_id, 1 as brand_id, N'Máy chơi game MSI Claw A1M' as name, N'may-choi-game-msi-claw-a1m' as slug, N'MCG-MSI-CLAW-A1M' as sku, N'GENERIC-7568' as mpn, 14990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Speaker] Product: Máy chơi Game cầm tay Lenovo Legion GO
MERGE INTO products AS target
USING (SELECT 18 as category_id, 1 as brand_id, N'Máy chơi Game cầm tay Lenovo Legion GO' as name, N'may-choi-game-cam-tay-lenovo-legion-go' as slug, N'MCG-LENOVO-LEGION-GO' as sku, N'GENERIC-26241' as mpn, 22990000 as price, N'[{"key":"CPU","value":"AMD Ryzen™ Z1 Extreme Processor (Zen4 architecture with 4nm process, 8-core /16-threads, 24MB total cache, up to 5.10 GHz boost)"},{"key":"RAM","value":"16GB (8x2) LPDDR5x 7500 Onboard"},{"key":"Ổ cứng","value":"512GB PCIe® 4.0 NVMe™ M.2 SSD (2242)"},{"key":"VGA","value":"AMD Radeon™ Graphics (AMD RDNA™ 3, 12 CUs, up to 2.7GHz, up to 8.6 Teraflops), TDP: 9-30W"},{"key":"Màn hình","value":"8.8\" WQXGA (2560x1600), Multi-touch, IPS, 500nits, Glossy, anti-fingerprint, 16:10, 1500:1, 97% DCI-P3, 144Hz, 89°/89°/80°/80°, Corning® Gorilla® Glass 5"},{"key":"Cổng giao tiếp","value":"2x USB4® 40Gbps (support data transfer, Power Delivery 3.0 and DisplayPort™ 1.4)1x Headphone / microphone combo jack (3.5mm)1x Card reader2x Pogo pin connector (5-point)"},{"key":"Hệ thống điều khiển","value":"A B X Y buttonsD-padTouchpadFPS mode switchMouse wheelLeft & right JoysticksLeft & right release buttonsLB buttonM1 / RB buttonM2 buttonY1 & Y2 buttonsM3 & Y3 buttons4x function buttons"},{"key":"Audio","value":"Stereo speakers, 2W x2, High Definition (HD) Audio"},{"key":"Chuẩn WIFI","value":"AMD Wi-Fi® 6E RZ616, 802.11ax (2x2)"},{"key":"Bluetooth","value":"v5.3"},{"key":"Hệ điều hành","value":"Windows 11 Home"},{"key":"Pin","value":"Integrated Li-Polymer 49.2Wh"},{"key":"Sạc","value":"65W USB-C® (3-pin) AC adapter, supports PD 3.0, 100-240V, 50-60Hz"},{"key":"Trọng lượng","value":"Gamepad: 640 gGamepad with controllers: 854g"},{"key":"Màu sắc","value":"Shadow black"},{"key":"Kích thước","value":"Gamepad: 210 x 131 x 20.1 (mm)Gamepad with controllers: 298.83 x 131 x 40.7 (mm)"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');

-- [Sound Card] Product: Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)
MERGE INTO products AS target
USING (SELECT 22 as category_id, 1 as brand_id, N'Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)' as name, N'may-bo-acer-atlos-p130f7-i5-ram-8gb-ssd-512gb' as slug, N'PC-ACER-ATLOS-I5' as sku, N'GENERIC-38759' as mpn, 11990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Sound Card] Product: PC GVN Homework Athlon
MERGE INTO products AS target
USING (SELECT 22 as category_id, 1 as brand_id, N'PC GVN Homework Athlon' as name, N'pc-gvn-homework-amd-athlon' as slug, N'PC-GVN-ARES' as sku, N'GENERIC-31664' as mpn, 7190000 as price, N'[{"key":"Mainboard:","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU:","value":"Athlon 3000G / 5MB / 3.5GHz / 2 nhân 4 luồng / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD:","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD:","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU:","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case:","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Sound Card] Product: PC GVN Homework R3
MERGE INTO products AS target
USING (SELECT 22 as category_id, 1 as brand_id, N'PC GVN Homework R3' as name, N'pc-gvn-homework-amd-r3' as slug, N'PC-GVN-HOMEWORK-R3' as sku, N'GENERIC-57865' as mpn, 7630000 as price, N'[{"key":"Mainboard","value":"Bo Mạch Chủ Gigabyte A520M-K V2"},{"key":"CPU","value":"Bộ vi xử lý AMD Ryzen 3 3200G / 3.6GHz Boost 4.0GHz / 4 nhân 4 luồng (TRAY)"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Jetek 350W Elite V2"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Sound Card] Product: PC GVN Homework R5
MERGE INTO products AS target
USING (SELECT 22 as category_id, 1 as brand_id, N'PC GVN Homework R5' as name, N'pc-gvn-homework-amd-r5' as slug, N'PC-GVN-HOMEWORK-R5' as sku, N'GENERIC-15152' as mpn, 10390000 as price, N'[{"key":"","value":"Tên Sản phẩm"},{"key":"Mainboard","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU","value":"AMD Ryzen 5 5600GT / 3.6GHz Boost 4.6GHz / 6 nhân 12 luồng / 19MB / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"VGA","value":"Có thể tùy chọn Nâng cấp"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Sound Card] Product: PC GVN Homework i5
MERGE INTO products AS target
USING (SELECT 22 as category_id, 1 as brand_id, N'PC GVN Homework i5' as name, N'pc-gvn-homework-intel-i5' as slug, N'PC-GVN-HOMEWORK-I5' as sku, N'GENERIC-73808' as mpn, 12990000 as price, N'[{"key":"Mainboard","value":"Mainboard Gigabyte H610M-H V3 DDR4"},{"key":"CPU","value":"Intel Core i5 14400 / Turbo up to 4.7GHz / 10 Nhân 16 Luồng / LGA 1700"},{"key":"RAM","value":"Ram SSTC 8GB DDR4 3200MHz (U3200A-C22-8GB)"},{"key":"SSD","value":"Ổ Cứng SSD SSTC M2 NVME Gen3x4 Max III 256GB"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Sound Card] Product: Phần mềm Windows 11 Home Online DwnLd NR KW9-00664
MERGE INTO products AS target
USING (SELECT 22 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Home Online DwnLd NR KW9-00664' as name, N'phan-mem-windows-11-home-online-dwnld-nr-kw9-00664' as slug, N'PM-MS-WIN11-HOME-FPP-OL-WK9-00664' as sku, N'GENERIC-12011' as mpn, 3490000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"KW9-00664"},{"key":"Hình thức","value":"FPP(ESD) (Full Packaged Product)"},{"key":"Số máy cài đặt","value":"1"},{"key":"Thời hạn","value":"Thời gian sử dụng phần cứng"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Sound Card] Product: Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572
MERGE INTO products AS target
USING (SELECT 22 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572' as name, N'phan-mem-windows-11-pro-online-dwnld-nr-fqc-10572' as slug, N'PM-MS-WIN11-PRO-FPP-OL-FQC-10572' as sku, N'GENERIC-41369' as mpn, 5150000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"FQC-10572"},{"key":"Tên sản phẩm","value":"Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572"},{"key":"Tính năng","value":"- Thích hợp cho kinh doanh- Đa nhiệm- Microsoft Edge - Cortana- Chế độ Máy tính bảng- Máy tính từ xa"},{"key":"Thiết bị","value":"1"},{"key":"Thời hạn","value":"Vĩnh viễn"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Sound Card] Product: Máy chơi game MSI Claw A1M
MERGE INTO products AS target
USING (SELECT 22 as category_id, 1 as brand_id, N'Máy chơi game MSI Claw A1M' as name, N'may-choi-game-msi-claw-a1m' as slug, N'MCG-MSI-CLAW-A1M' as sku, N'GENERIC-36684' as mpn, 14990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Sound Card] Product: Máy chơi Game cầm tay Lenovo Legion GO
MERGE INTO products AS target
USING (SELECT 22 as category_id, 1 as brand_id, N'Máy chơi Game cầm tay Lenovo Legion GO' as name, N'may-choi-game-cam-tay-lenovo-legion-go' as slug, N'MCG-LENOVO-LEGION-GO' as sku, N'GENERIC-53591' as mpn, 22990000 as price, N'[{"key":"CPU","value":"AMD Ryzen™ Z1 Extreme Processor (Zen4 architecture with 4nm process, 8-core /16-threads, 24MB total cache, up to 5.10 GHz boost)"},{"key":"RAM","value":"16GB (8x2) LPDDR5x 7500 Onboard"},{"key":"Ổ cứng","value":"512GB PCIe® 4.0 NVMe™ M.2 SSD (2242)"},{"key":"VGA","value":"AMD Radeon™ Graphics (AMD RDNA™ 3, 12 CUs, up to 2.7GHz, up to 8.6 Teraflops), TDP: 9-30W"},{"key":"Màn hình","value":"8.8\" WQXGA (2560x1600), Multi-touch, IPS, 500nits, Glossy, anti-fingerprint, 16:10, 1500:1, 97% DCI-P3, 144Hz, 89°/89°/80°/80°, Corning® Gorilla® Glass 5"},{"key":"Cổng giao tiếp","value":"2x USB4® 40Gbps (support data transfer, Power Delivery 3.0 and DisplayPort™ 1.4)1x Headphone / microphone combo jack (3.5mm)1x Card reader2x Pogo pin connector (5-point)"},{"key":"Hệ thống điều khiển","value":"A B X Y buttonsD-padTouchpadFPS mode switchMouse wheelLeft & right JoysticksLeft & right release buttonsLB buttonM1 / RB buttonM2 buttonY1 & Y2 buttonsM3 & Y3 buttons4x function buttons"},{"key":"Audio","value":"Stereo speakers, 2W x2, High Definition (HD) Audio"},{"key":"Chuẩn WIFI","value":"AMD Wi-Fi® 6E RZ616, 802.11ax (2x2)"},{"key":"Bluetooth","value":"v5.3"},{"key":"Hệ điều hành","value":"Windows 11 Home"},{"key":"Pin","value":"Integrated Li-Polymer 49.2Wh"},{"key":"Sạc","value":"65W USB-C® (3-pin) AC adapter, supports PD 3.0, 100-240V, 50-60Hz"},{"key":"Trọng lượng","value":"Gamepad: 640 gGamepad with controllers: 854g"},{"key":"Màu sắc","value":"Shadow black"},{"key":"Kích thước","value":"Gamepad: 210 x 131 x 20.1 (mm)Gamepad with controllers: 298.83 x 131 x 40.7 (mm)"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');

-- [Capture Card] Product: Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)
MERGE INTO products AS target
USING (SELECT 23 as category_id, 1 as brand_id, N'Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)' as name, N'may-bo-acer-atlos-p130f7-i5-ram-8gb-ssd-512gb' as slug, N'PC-ACER-ATLOS-I5' as sku, N'GENERIC-98833' as mpn, 11990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Capture Card] Product: PC GVN Homework Athlon
MERGE INTO products AS target
USING (SELECT 23 as category_id, 1 as brand_id, N'PC GVN Homework Athlon' as name, N'pc-gvn-homework-amd-athlon' as slug, N'PC-GVN-ARES' as sku, N'GENERIC-18693' as mpn, 7190000 as price, N'[{"key":"Mainboard:","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU:","value":"Athlon 3000G / 5MB / 3.5GHz / 2 nhân 4 luồng / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD:","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD:","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU:","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case:","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Capture Card] Product: PC GVN Homework R3
MERGE INTO products AS target
USING (SELECT 23 as category_id, 1 as brand_id, N'PC GVN Homework R3' as name, N'pc-gvn-homework-amd-r3' as slug, N'PC-GVN-HOMEWORK-R3' as sku, N'GENERIC-25427' as mpn, 7630000 as price, N'[{"key":"Mainboard","value":"Bo Mạch Chủ Gigabyte A520M-K V2"},{"key":"CPU","value":"Bộ vi xử lý AMD Ryzen 3 3200G / 3.6GHz Boost 4.0GHz / 4 nhân 4 luồng (TRAY)"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Jetek 350W Elite V2"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Capture Card] Product: PC GVN Homework R5
MERGE INTO products AS target
USING (SELECT 23 as category_id, 1 as brand_id, N'PC GVN Homework R5' as name, N'pc-gvn-homework-amd-r5' as slug, N'PC-GVN-HOMEWORK-R5' as sku, N'GENERIC-44961' as mpn, 10390000 as price, N'[{"key":"","value":"Tên Sản phẩm"},{"key":"Mainboard","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU","value":"AMD Ryzen 5 5600GT / 3.6GHz Boost 4.6GHz / 6 nhân 12 luồng / 19MB / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"VGA","value":"Có thể tùy chọn Nâng cấp"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Capture Card] Product: PC GVN Homework i5
MERGE INTO products AS target
USING (SELECT 23 as category_id, 1 as brand_id, N'PC GVN Homework i5' as name, N'pc-gvn-homework-intel-i5' as slug, N'PC-GVN-HOMEWORK-I5' as sku, N'GENERIC-80987' as mpn, 12990000 as price, N'[{"key":"Mainboard","value":"Mainboard Gigabyte H610M-H V3 DDR4"},{"key":"CPU","value":"Intel Core i5 14400 / Turbo up to 4.7GHz / 10 Nhân 16 Luồng / LGA 1700"},{"key":"RAM","value":"Ram SSTC 8GB DDR4 3200MHz (U3200A-C22-8GB)"},{"key":"SSD","value":"Ổ Cứng SSD SSTC M2 NVME Gen3x4 Max III 256GB"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Capture Card] Product: Phần mềm Windows 11 Home Online DwnLd NR KW9-00664
MERGE INTO products AS target
USING (SELECT 23 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Home Online DwnLd NR KW9-00664' as name, N'phan-mem-windows-11-home-online-dwnld-nr-kw9-00664' as slug, N'PM-MS-WIN11-HOME-FPP-OL-WK9-00664' as sku, N'GENERIC-52119' as mpn, 3490000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"KW9-00664"},{"key":"Hình thức","value":"FPP(ESD) (Full Packaged Product)"},{"key":"Số máy cài đặt","value":"1"},{"key":"Thời hạn","value":"Thời gian sử dụng phần cứng"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Capture Card] Product: Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572
MERGE INTO products AS target
USING (SELECT 23 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572' as name, N'phan-mem-windows-11-pro-online-dwnld-nr-fqc-10572' as slug, N'PM-MS-WIN11-PRO-FPP-OL-FQC-10572' as sku, N'GENERIC-99672' as mpn, 5150000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"FQC-10572"},{"key":"Tên sản phẩm","value":"Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572"},{"key":"Tính năng","value":"- Thích hợp cho kinh doanh- Đa nhiệm- Microsoft Edge - Cortana- Chế độ Máy tính bảng- Máy tính từ xa"},{"key":"Thiết bị","value":"1"},{"key":"Thời hạn","value":"Vĩnh viễn"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Capture Card] Product: Máy chơi game MSI Claw A1M
MERGE INTO products AS target
USING (SELECT 23 as category_id, 1 as brand_id, N'Máy chơi game MSI Claw A1M' as name, N'may-choi-game-msi-claw-a1m' as slug, N'MCG-MSI-CLAW-A1M' as sku, N'GENERIC-86763' as mpn, 14990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Capture Card] Product: Máy chơi Game cầm tay Lenovo Legion GO
MERGE INTO products AS target
USING (SELECT 23 as category_id, 1 as brand_id, N'Máy chơi Game cầm tay Lenovo Legion GO' as name, N'may-choi-game-cam-tay-lenovo-legion-go' as slug, N'MCG-LENOVO-LEGION-GO' as sku, N'GENERIC-60923' as mpn, 22990000 as price, N'[{"key":"CPU","value":"AMD Ryzen™ Z1 Extreme Processor (Zen4 architecture with 4nm process, 8-core /16-threads, 24MB total cache, up to 5.10 GHz boost)"},{"key":"RAM","value":"16GB (8x2) LPDDR5x 7500 Onboard"},{"key":"Ổ cứng","value":"512GB PCIe® 4.0 NVMe™ M.2 SSD (2242)"},{"key":"VGA","value":"AMD Radeon™ Graphics (AMD RDNA™ 3, 12 CUs, up to 2.7GHz, up to 8.6 Teraflops), TDP: 9-30W"},{"key":"Màn hình","value":"8.8\" WQXGA (2560x1600), Multi-touch, IPS, 500nits, Glossy, anti-fingerprint, 16:10, 1500:1, 97% DCI-P3, 144Hz, 89°/89°/80°/80°, Corning® Gorilla® Glass 5"},{"key":"Cổng giao tiếp","value":"2x USB4® 40Gbps (support data transfer, Power Delivery 3.0 and DisplayPort™ 1.4)1x Headphone / microphone combo jack (3.5mm)1x Card reader2x Pogo pin connector (5-point)"},{"key":"Hệ thống điều khiển","value":"A B X Y buttonsD-padTouchpadFPS mode switchMouse wheelLeft & right JoysticksLeft & right release buttonsLB buttonM1 / RB buttonM2 buttonY1 & Y2 buttonsM3 & Y3 buttons4x function buttons"},{"key":"Audio","value":"Stereo speakers, 2W x2, High Definition (HD) Audio"},{"key":"Chuẩn WIFI","value":"AMD Wi-Fi® 6E RZ616, 802.11ax (2x2)"},{"key":"Bluetooth","value":"v5.3"},{"key":"Hệ điều hành","value":"Windows 11 Home"},{"key":"Pin","value":"Integrated Li-Polymer 49.2Wh"},{"key":"Sạc","value":"65W USB-C® (3-pin) AC adapter, supports PD 3.0, 100-240V, 50-60Hz"},{"key":"Trọng lượng","value":"Gamepad: 640 gGamepad with controllers: 854g"},{"key":"Màu sắc","value":"Shadow black"},{"key":"Kích thước","value":"Gamepad: 210 x 131 x 20.1 (mm)Gamepad with controllers: 298.83 x 131 x 40.7 (mm)"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');

-- [Controller] Product: Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)' as name, N'may-bo-acer-atlos-p130f7-i5-ram-8gb-ssd-512gb' as slug, N'PC-ACER-ATLOS-I5' as sku, N'GENERIC-10119' as mpn, 11990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: PC GVN Homework Athlon
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'PC GVN Homework Athlon' as name, N'pc-gvn-homework-amd-athlon' as slug, N'PC-GVN-ARES' as sku, N'GENERIC-25238' as mpn, 7190000 as price, N'[{"key":"Mainboard:","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU:","value":"Athlon 3000G / 5MB / 3.5GHz / 2 nhân 4 luồng / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD:","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD:","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU:","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case:","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: PC GVN Homework R3
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'PC GVN Homework R3' as name, N'pc-gvn-homework-amd-r3' as slug, N'PC-GVN-HOMEWORK-R3' as sku, N'GENERIC-86386' as mpn, 7630000 as price, N'[{"key":"Mainboard","value":"Bo Mạch Chủ Gigabyte A520M-K V2"},{"key":"CPU","value":"Bộ vi xử lý AMD Ryzen 3 3200G / 3.6GHz Boost 4.0GHz / 4 nhân 4 luồng (TRAY)"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Jetek 350W Elite V2"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: PC GVN Homework R5
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'PC GVN Homework R5' as name, N'pc-gvn-homework-amd-r5' as slug, N'PC-GVN-HOMEWORK-R5' as sku, N'GENERIC-60023' as mpn, 10390000 as price, N'[{"key":"","value":"Tên Sản phẩm"},{"key":"Mainboard","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU","value":"AMD Ryzen 5 5600GT / 3.6GHz Boost 4.6GHz / 6 nhân 12 luồng / 19MB / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"VGA","value":"Có thể tùy chọn Nâng cấp"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: PC GVN Homework i5
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'PC GVN Homework i5' as name, N'pc-gvn-homework-intel-i5' as slug, N'PC-GVN-HOMEWORK-I5' as sku, N'GENERIC-67658' as mpn, 12990000 as price, N'[{"key":"Mainboard","value":"Mainboard Gigabyte H610M-H V3 DDR4"},{"key":"CPU","value":"Intel Core i5 14400 / Turbo up to 4.7GHz / 10 Nhân 16 Luồng / LGA 1700"},{"key":"RAM","value":"Ram SSTC 8GB DDR4 3200MHz (U3200A-C22-8GB)"},{"key":"SSD","value":"Ổ Cứng SSD SSTC M2 NVME Gen3x4 Max III 256GB"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phần mềm Windows 11 Home Online DwnLd NR KW9-00664
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Home Online DwnLd NR KW9-00664' as name, N'phan-mem-windows-11-home-online-dwnld-nr-kw9-00664' as slug, N'PM-MS-WIN11-HOME-FPP-OL-WK9-00664' as sku, N'GENERIC-30311' as mpn, 3490000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"KW9-00664"},{"key":"Hình thức","value":"FPP(ESD) (Full Packaged Product)"},{"key":"Số máy cài đặt","value":"1"},{"key":"Thời hạn","value":"Thời gian sử dụng phần cứng"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572' as name, N'phan-mem-windows-11-pro-online-dwnld-nr-fqc-10572' as slug, N'PM-MS-WIN11-PRO-FPP-OL-FQC-10572' as sku, N'GENERIC-73115' as mpn, 5150000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"FQC-10572"},{"key":"Tên sản phẩm","value":"Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572"},{"key":"Tính năng","value":"- Thích hợp cho kinh doanh- Đa nhiệm- Microsoft Edge - Cortana- Chế độ Máy tính bảng- Máy tính từ xa"},{"key":"Thiết bị","value":"1"},{"key":"Thời hạn","value":"Vĩnh viễn"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Máy chơi game MSI Claw A1M
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Máy chơi game MSI Claw A1M' as name, N'may-choi-game-msi-claw-a1m' as slug, N'MCG-MSI-CLAW-A1M' as sku, N'GENERIC-83313' as mpn, 14990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Máy chơi Game cầm tay Lenovo Legion GO
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Máy chơi Game cầm tay Lenovo Legion GO' as name, N'may-choi-game-cam-tay-lenovo-legion-go' as slug, N'MCG-LENOVO-LEGION-GO' as sku, N'GENERIC-99388' as mpn, 22990000 as price, N'[{"key":"CPU","value":"AMD Ryzen™ Z1 Extreme Processor (Zen4 architecture with 4nm process, 8-core /16-threads, 24MB total cache, up to 5.10 GHz boost)"},{"key":"RAM","value":"16GB (8x2) LPDDR5x 7500 Onboard"},{"key":"Ổ cứng","value":"512GB PCIe® 4.0 NVMe™ M.2 SSD (2242)"},{"key":"VGA","value":"AMD Radeon™ Graphics (AMD RDNA™ 3, 12 CUs, up to 2.7GHz, up to 8.6 Teraflops), TDP: 9-30W"},{"key":"Màn hình","value":"8.8\" WQXGA (2560x1600), Multi-touch, IPS, 500nits, Glossy, anti-fingerprint, 16:10, 1500:1, 97% DCI-P3, 144Hz, 89°/89°/80°/80°, Corning® Gorilla® Glass 5"},{"key":"Cổng giao tiếp","value":"2x USB4® 40Gbps (support data transfer, Power Delivery 3.0 and DisplayPort™ 1.4)1x Headphone / microphone combo jack (3.5mm)1x Card reader2x Pogo pin connector (5-point)"},{"key":"Hệ thống điều khiển","value":"A B X Y buttonsD-padTouchpadFPS mode switchMouse wheelLeft & right JoysticksLeft & right release buttonsLB buttonM1 / RB buttonM2 buttonY1 & Y2 buttonsM3 & Y3 buttons4x function buttons"},{"key":"Audio","value":"Stereo speakers, 2W x2, High Definition (HD) Audio"},{"key":"Chuẩn WIFI","value":"AMD Wi-Fi® 6E RZ616, 802.11ax (2x2)"},{"key":"Bluetooth","value":"v5.3"},{"key":"Hệ điều hành","value":"Windows 11 Home"},{"key":"Pin","value":"Integrated Li-Polymer 49.2Wh"},{"key":"Sạc","value":"65W USB-C® (3-pin) AC adapter, supports PD 3.0, 100-240V, 50-60Hz"},{"key":"Trọng lượng","value":"Gamepad: 640 gGamepad with controllers: 854g"},{"key":"Màu sắc","value":"Shadow black"},{"key":"Kích thước","value":"Gamepad: 210 x 131 x 20.1 (mm)Gamepad with controllers: 298.83 x 131 x 40.7 (mm)"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Giá đỡ VGA ASUS ROG XH01 HERCULX GRAPHICS CARD HOLDER
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Giá đỡ VGA ASUS ROG XH01 HERCULX GRAPHICS CARD HOLDER' as name, N'gia-do-vga-asus-rog-xh01-herculx-graphics-card-holder' as slug, N'PK-ASUS-GIA-DO-VGA-XH01' as sku, N'GENERIC-46361' as mpn, 1990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Dây cáp nguồn Cooler Master Extension Cable WTBK GL (PVC)
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Dây cáp nguồn Cooler Master Extension Cable WTBK GL (PVC)' as name, N'day-cap-nguon-cooler-master-extension-cable-wtbk-gl' as slug, N'PK-CM-DAY-CAP-NGUON-WTBK-GL' as sku, N'GENERIC-32958' as mpn, 99000 as price, N'[{"key":"Mã sản phẩm","value":"CMA-SEST16WTBK1-GL"},{"key":"Chiều dài","value":"30cm"},{"key":"Thước đo dây","value":"16 AWG"},{"key":"Loại cáp","value":"Single Sleeve"},{"key":"Màu sắc","value":"Trắng Đen"},{"key":"Kết nối","value":"1x 24Pin, 1x 8(4+4)Pin, 2x PCI-e 6Pin, 2x PCI-e 8Pin"},{"key":"Số clip cáp","value":"4x 24Pin, 12x 8Pin, 8x 6Pin"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện Thermaltake Chassis Stand Kit for The Tower 300
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện Thermaltake Chassis Stand Kit for The Tower 300' as name, N'phu-kien-thermaltake-chassis-stand-kit-for-the-tower-300' as slug, N'PK-THER-STA-KIT-TOW-300' as sku, N'GENERIC-69376' as mpn, 690000 as price, N'[{"key":"P/N","value":"AC-074-ON1NAN-A1"},{"key":"Kích thước","value":"145 x 266 x 459 mm ( 5.7 x 10.47 x 18.07 inch)"},{"key":"Màu sắc","value":"Đen"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện Thermaltake Chassis Stand Kit for The Tower 300 Matcha Green
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện Thermaltake Chassis Stand Kit for The Tower 300 Matcha Green' as name, N'phu-kien-thermaltake-chassis-stand-kit-for-the-tower-300-matcha-green' as slug, N'PK-THER-STA-KIT-TOW-300-MAT-GRE' as sku, N'GENERIC-58640' as mpn, 690000 as price, N'[{"key":"P/N","value":"AC-074-ONENAN-A1"},{"key":"Kích thước","value":"145 x 266 x 459 mm ( 5.7 x 10.47 x 18.07 inch)"},{"key":"Màu sắc","value":"Xanh Matcha"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Dây nguồn nối dài Lian Li Strimer Plus 24 Pin ARGB V2
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Dây nguồn nối dài Lian Li Strimer Plus 24 Pin ARGB V2' as name, N'day-nguon-noi-dai-lian-li-strimer-plus-24-pin-argb-v2' as slug, N'PK-LIANLI-STRIMER-PLUS-ARGB-24PIN-V2' as sku, N'GENERIC-32450' as mpn, 1790000 as price, N'[{"key":"Model","value":"LIAN LI ADDRESSABLE RGB STRIMER PLUS 24-PIN"},{"key":"Kích thước chuẩn","value":"247mm (L) X 56,6mm (D) X 8mm (H)"},{"key":"Chất liệu","value":"Silicone/PVC"},{"key":"Độ dài cáp","value":"200mm"},{"key":"Số lượng bóng led","value":"120"},{"key":"Phụ kiện đi kèm","value":"Bộ điều khiển sử dụng phần mềm L-Connect 3"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện keo tản nhiệt ARCTIC MX-4 20 gram (ACTCP00001B)
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện keo tản nhiệt ARCTIC MX-4 20 gram (ACTCP00001B)' as name, N'phu-kien-keo-tan-nhiet-arctic-mx-4-20-gram-actcp00001b' as slug, N'PK-ARC-MX4-20G' as sku, N'GENERIC-13916' as mpn, 450000 as price, N'[{"key":"Thương hiệu","value":"ARCTIC"},{"key":"Model","value":"MX-4"},{"key":"Màu sắc","value":"Xám"},{"key":"Tỉ trọng","value":"2.50 g/cm³"},{"key":"Điện trở","value":"3.8 X 1013 Ω-cm"},{"key":"Nhiệt độ bảo quản khuyến nghị","value":"Nhiệt độ phòng"},{"key":"Nhiệt độ hoạt động","value":"-50~150°C"},{"key":"Trọng lượng","value":"20 gram"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Giá đỡ VGA ASUS ROG Herculx EVA-02 Edition GRAPHICS CARD HOLDER
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Giá đỡ VGA ASUS ROG Herculx EVA-02 Edition GRAPHICS CARD HOLDER' as name, N'gia-do-vga-asus-rog-herculx-eva-02-edition-graphics-card-holder' as slug, N'PK-ASUS-GIA-DO-VGA-EVA' as sku, N'GENERIC-85825' as mpn, 1990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện HYTE Y60 LCD DIY Kit
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện HYTE Y60 LCD DIY Kit' as name, N'phu-kien-hyte-y60-lcd-diy-kit' as slug, N'PK-HYTE-Y60-LCD-DIY' as sku, N'GENERIC-6896' as mpn, 4275000 as price, N'[{"key":"Model","value":"NV126B5M N42 V3.2"},{"key":"Gam màu","value":"45% NTSC"},{"key":"Sử dụng năng lượng","value":"2.9W"},{"key":"Thông số hiển thị","value":"1920 x 515"},{"key":"Phiên bản eDP","value":"1.2"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện keo tản nhiệt ARCTIC MX-6 4 gram + 6 miếng MX Cleaner (ACTCP00084A)
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện keo tản nhiệt ARCTIC MX-6 4 gram + 6 miếng MX Cleaner (ACTCP00084A)' as name, N'keo-tan-nhiet-arctic-mx6-4g-6-mieng-mx-cleaner' as slug, N'PK-ARC-MX6-4G-MIT' as sku, N'GENERIC-89984' as mpn, 370000 as price, N'[{"key":"Thương hiệu","value":"ARCTIC"},{"key":"Model","value":"MX-6"},{"key":"Màu sắc","value":"Xám"},{"key":"Tỉ trọng","value":"2.6 g/cm³"},{"key":"Điện trở","value":"1.8 X 1012 Ω-cm"},{"key":"Nhiệt độ bảo quản khuyến nghị","value":"Nhiệt độ phòng"},{"key":"Nhiệt độ hoạt động","value":"-50~150°C"},{"key":"Trọng lượng","value":"4 gram"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện keo tản nhiệt ARCTIC MX-6 4 gram (ACTCP00080A)
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện keo tản nhiệt ARCTIC MX-6 4 gram (ACTCP00080A)' as name, N'keo-tan-nhiet-arctic-mx6-4g' as slug, N'PK-ARC-MX6-4G' as sku, N'GENERIC-21726' as mpn, 320000 as price, N'[{"key":"Thương hiệu","value":"ARCTIC"},{"key":"Model","value":"MX-6"},{"key":"Màu sắc","value":"Xám"},{"key":"Tỉ trọng","value":"2.6 g/cm³"},{"key":"Điện trở","value":"1.8 X 1012 Ω-cm"},{"key":"Nhiệt độ bảo quản khuyến nghị","value":"Nhiệt độ phòng"},{"key":"Nhiệt độ hoạt động","value":"-50~150°C"},{"key":"Trọng lượng","value":"4 gram"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện keo tản nhiệt ARCTIC MX-4 8 gram (ACTCP00008B)
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện keo tản nhiệt ARCTIC MX-4 8 gram (ACTCP00008B)' as name, N'keo-tan-nhiet-arctic-mx4-8g' as slug, N'PK-ARC-MX4-8G' as sku, N'GENERIC-13415' as mpn, 220000 as price, N'[{"key":"Thương hiệu","value":"ARCTIC"},{"key":"Model","value":"MX-4"},{"key":"Màu sắc","value":"Xám"},{"key":"Tỉ trọng","value":"2.50 g/cm³"},{"key":"Điện trở","value":"3.8 X 1013 Ω-cm"},{"key":"Nhiệt độ bảo quản khuyến nghị","value":"Nhiệt độ phòng"},{"key":"Nhiệt độ hoạt động","value":"-50~150°C"},{"key":"Trọng lượng","value":"8 gram"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện keo tản nhiệt ARCTIC MX-4 4 gram (ACTCP00002B)
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện keo tản nhiệt ARCTIC MX-4 4 gram (ACTCP00002B)' as name, N'keo-tan-nhiet-arctic-mx4-4g' as slug, N'PK-ARC-MX4-4G' as sku, N'GENERIC-73403' as mpn, 150000 as price, N'[{"key":"Thương hiệu","value":"ARCTIC"},{"key":"Model","value":"MX-4"},{"key":"Màu sắc","value":"Xám"},{"key":"Tỉ trọng","value":"2.50 g/cm³"},{"key":"Điện trở","value":"3.8 X 1013 Ω-cm"},{"key":"Nhiệt độ bảo quản khuyến nghị","value":"Nhiệt độ phòng"},{"key":"Nhiệt độ hoạt động","value":"-50~150°C"},{"key":"Trọng lượng","value":"4 gram"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ Kiện NZXT Vertical GPU Mounting KIT White (PCIE 4.0)
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ Kiện NZXT Vertical GPU Mounting KIT White (PCIE 4.0)' as name, N'phu-kien-nzxt-vertical-gpu-mounting-kit-white-pcie-4-0' as slug, N'PK-NZXT-VERTICAL-GPU-MOU-KIT-WHITE-PCIE4.0' as sku, N'GENERIC-86473' as mpn, 1930000 as price, N'[{"key":"Thương hiệu","value":"NZXT"},{"key":"Model","value":"NZXT Vertical GPU Mounting KIT (PCIe 4.0)"},{"key":"Kích thước","value":"H 186.8mm x W 144.7mm x D 150.4mm"},{"key":"Model number","value":"AB-RH175-W1 (White)"},{"key":"Màu sắc","value":"Đen"},{"key":"Tương thích","value":"PCIe Gen 4 x16"},{"key":"Hỗ trợ card đồ hoạ","value":"Chiều dài bất kỳ, tới 3 Slot"},{"key":"Vị trí","value":"7 available PCIe slots for mounting"},{"key":"Bảo hành","value":"24 tháng"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ Kiện NZXT Vertical GPU Mounting KIT Black (PCIE 4.0)
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ Kiện NZXT Vertical GPU Mounting KIT Black (PCIE 4.0)' as name, N'nzxt-vertical-gpu-mounting-kit-pcie-4-0' as slug, N'PK-NZXT-VERTICAL-GPU-MOU-KIT-BLACK-PCIE4.0' as sku, N'GENERIC-54125' as mpn, 1930000 as price, N'[{"key":"Thương hiệu","value":"NZXT"},{"key":"Model","value":"NZXT Vertical GPU Mounting KIT (PCIe 4.0)"},{"key":"Kích thước","value":"H 186.8mm x W 144.7mm x D 150.4mm"},{"key":"Model number","value":"AB-RH175-B1 (Black)"},{"key":"Màu sắc","value":"Đen"},{"key":"Tương thích","value":"PCIe Gen 4 x16"},{"key":"Hỗ trợ card đồ hoạ","value":"Chiều dài bất kỳ, tới 3 Slot"},{"key":"Vị trí","value":"7 available PCIe slots for mounting"},{"key":"Bảo hành","value":"24 tháng"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện ốp tản nhiệt Noctua NA - HC8 Chromax White
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện ốp tản nhiệt Noctua NA - HC8 Chromax White' as name, N'phu-kien-noctua-na-hc8-chromax-white' as slug, N'PK-NOC-NA-HC8-CH-WHITE' as sku, N'GENERIC-73234' as mpn, 640000 as price, N'[{"key":"Thương hiệu","value":"Noctua"},{"key":"Sản phẩm gồm","value":"1 nắp tản nhiệt Noctua NA - HC8 chromax. white"},{"key":"Màu sắc","value":"Trắng"},{"key":"Tương thích với các tản nhiệt","value":"NH - U12ANH - U12A Chromax Black"},{"key":"Lưu ý và cảnh báo","value":"Nắp tăng chiều cao của tản nhiệt thêm 3mm (từ 158 lên 161mm) và tổng chiều rộng thêm 3mm (từ 125 lên 128mm).Hãy đảm bảo rằng vỏ của bạn có đủ độ hở và vỏ không tiếp xúc với bất kỳ thành phần nào khác như thẻ PCIe!"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện ốp tản nhiệt Noctua NA - HC6 Chromax White
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện ốp tản nhiệt Noctua NA - HC6 Chromax White' as name, N'phu-kien-noctua-na-hc6-chromax-white' as slug, N'PK-NOC-NA-HC6-CH-WHITE' as sku, N'GENERIC-61254' as mpn, 640000 as price, N'[{"key":"Thương hiệu","value":"Noctua"},{"key":"Sản phẩm gồm","value":"1 nắp tản nhiệt Noctua NA - HC6 chromax. white"},{"key":"Màu sắc","value":"Trắng"},{"key":"Tương thích với các tản nhiệt","value":"NH - U14SNH - U14S - TR4 - SP3"},{"key":"Lưu ý và cảnh báo","value":"Nắp tăng chiều cao của tản nhiệt thêm 7mm (từ 165 lên 172mm) và tổng chiều rộng thêm 3mm (từ 150mm lên 153mm).Hãy đảm bảo rằng vỏ của bạn có đủ độ hở và vỏ không tiếp xúc với bất kỳ thành phần nào khác như thẻ PCIe!"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện ốp tản nhiệt Noctua NA - HC4 Chromax White
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện ốp tản nhiệt Noctua NA - HC4 Chromax White' as name, N'phu-kien-noctua-na-hc4-chromax-white' as slug, N'PK-NOC-NA-HC4-CH-WHITE' as sku, N'GENERIC-77811' as mpn, 1090000 as price, N'[{"key":"Thương hiệu","value":"Noctua"},{"key":"Sản phẩm gồm","value":"2 nắp tản nhiệt Noctua NA - HC4 chromax. white"},{"key":"Màu sắc","value":"Trắng"},{"key":"Tương thích với các tản nhiệt","value":"NH - D15SNH - D15NH - D15 Chromax Black"},{"key":"Lưu ý và cảnh báo","value":"Các nắp làm tăng chiều cao của tản nhiệt thêm 5mm (từ 160 lên 165mm) và chiều rộng thêm 3mm (từ 150mm lên 153mm).Hãy đảm bảo rằng vỏ của bạn có đủ độ hở và các nắp không tiếp xúc với bất kỳ thành phần nào khác như thẻ PCIe!"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện ốp tản nhiệt Noctua NA - HC2 Chromax White
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện ốp tản nhiệt Noctua NA - HC2 Chromax White' as name, N'phu-kien-noctua-na-hc2-chromax-white' as slug, N'PK-NOC-NA-HC2-CH-WHITE' as sku, N'GENERIC-63307' as mpn, 640000 as price, N'[{"key":"Thương hiệu","value":"Noctua"},{"key":"Sản phẩm gồm","value":"1 nắp tản nhiệt Noctua NA - HC2 chromax. white"},{"key":"Màu sắc","value":"Trắng"},{"key":"Tương thích với các tản nhiệt","value":"NH-U12S, NH-U12S Chromax BlackNH-U12S SE-AM4NH-U12S TR4-SP3NH-U12S DX-3647"},{"key":"Lưu ý và cảnh báo","value":"Nắp làm tăng chiều cao của tản nhiệt thêm 6mm (từ 158 lên 164mm) và tổng chiều rộng thêm 3mm (từ 125mm lên 128mm). Hãy đảm bảo rằng vỏ của bạn có đủ độ hở và vỏ không tiếp xúc với bất kỳ thành phần nào khác như thẻ PCIe!"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện màn hình LCD dùng cho tản nhiệt nước Corsair ELITE - Black (CW-9060056-WW)
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện màn hình LCD dùng cho tản nhiệt nước Corsair ELITE - Black (CW-9060056-WW)' as name, N'phu-kien-man-hinh-lcd-dung-cho-tan-nhiet-nuoc-corsair-elite-black' as slug, N'PK-COR-MAN-LCD-TN-ELITE-BLACK' as sku, N'GENERIC-17381' as mpn, 3000000 as price, N'[{"key":"Tương thích Corsair Icue","value":"Có"},{"key":"Size màn hình","value":"2.1\""},{"key":"Độ phân giải gốc","value":"480x480"},{"key":"Refesh Rate","value":"30Hz"},{"key":"Tương thích sản phẩm","value":"H100i ELITE Capellix, H115i ELITE Capellix, H150i ELITE Capellix, H170i ELITE Capellix, H100i ELITE Capellix White, H150i ELITE Capellix White"},{"key":"Peak brightness","value":"600 Nit"},{"key":"Display Colors","value":"16.7M (8bit - RGB)"},{"key":"Display Technology","value":"IPS"},{"key":"Display Surface","value":"Gương"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Dây nguồn nối dài Lian Li Strimer Plus ARGB 8 Pin x3
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Dây nguồn nối dài Lian Li Strimer Plus ARGB 8 Pin x3' as name, N'day-nguon-noi-dai-lian-li-strimer-plus-argb-8-pin-x-3' as slug, N'PK-LIANLI-STRIMER-PLUS-ARGB-8PINX3-VGA' as sku, N'GENERIC-84699' as mpn, 1490000 as price, N'[{"key":"Model","value":"LIAN LI STRIMER PLUS TRIPLE 8-PIN"},{"key":"Kích thước chuẩn","value":"345mm (L) X 56,3mm (D) X 8mm (H)"},{"key":"Chất liệu","value":"Silicone/TPE"},{"key":"Độ dài cáp","value":"300mm"},{"key":"Số Lượng bóng led","value":"162"},{"key":"Phụ kiện đi kèm","value":"cáp kết nối ARGB 5V 3-PIN"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện sticker GearVN GBot PC
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện sticker GearVN GBot PC' as name, N'phu-kien-sticker-da-n-gearvn-gbot-pc' as slug, N'PK-GEARVN-STICKER-GBOT-PC' as sku, N'GENERIC-66978' as mpn, 100000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện dây led Cooler Master Addressable RGB LED STRIP
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện dây led Cooler Master Addressable RGB LED STRIP' as name, N'phu-kien-cooler-master-addressable-rgb-led-strip' as slug, N'PK-CM-DAY-LED-ARGB' as sku, N'GENERIC-94146' as mpn, 390000 as price, N'[{"key":"Mã sản phẩm","value":"MFX-GSHN-40NNN-R1"},{"key":"Màu sắc","value":"Trắng"},{"key":"Vật liệu","value":"Cao su"},{"key":"Kích thước","value":"400mm/15.7inch"},{"key":"Số lượng bóng led","value":"30 pcs"},{"key":"Cổng kết nối","value":"3-Pin ARGB"},{"key":"Điện áp định mức","value":"5 VDC"},{"key":"Năng lượng tiêu thụ","value":"2.25W"},{"key":"Bảo hành","value":"24 tháng"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: COOLER MASTER UNIVERSAL VERTICAL GPU HOLDER KIT (PCIE 4.0)
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'COOLER MASTER UNIVERSAL VERTICAL GPU HOLDER KIT (PCIE 4.0)' as name, N'cooler-master-universal-vertical-gpu-holder-kit-ver-2-pcie-4-0' as slug, N'PK-CM-UNI-VERTICAL-VGA-KIT-PCIE4.0' as sku, N'GENERIC-80923' as mpn, 1590000 as price, N'[{"key":"Thương hiệu","value":"Cooler Master"},{"key":"Model","value":"Universal Vertical GPU Holder Kit (PCIe 4.0)"},{"key":"Màu sắc","value":"Đen"},{"key":"Kích thước","value":"GFX Holder kit: 184 x 142 x 121mm / 7.25 x 5.59 x 4.77 inch (closed), Riser cable: 165mm (6.49in)"},{"key":"Hỗ trợ card đồ họa","value":"Chiều dài bất kỳ, tới 2.5 Slot"},{"key":"Loại Cable Riser","value":"Riser Cable PCie 4.0 và cũ hơn"},{"key":"Chất liệu thành phần dẫn điện","value":"PCBA, Tinned Copper Wire 30 AWG"},{"key":"Vỏ case tương thích","value":"Vỏ case 7 slot PCI-e"},{"key":"Kết nối","value":"PCI-E x16 Male to PCI x 16 90 độ Female"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ kiện NZXT RGB and Fan Controller (AC-2RGBC-B1)
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ kiện NZXT RGB and Fan Controller (AC-2RGBC-B1)' as name, N'phu-kien-nzxt-rgb-and-fan-controller-ac-2rgbc-b1' as slug, N'PK-NZXT-RGB-FAN-CONTROLLER' as sku, N'GENERIC-57973' as mpn, 790000 as price, N'[{"key":"Kích thước","value":"74 x 15 x 64mm"},{"key":"Cân nặng","value":"69.2 g"},{"key":"Gắn","value":"Magnet, Velcro"},{"key":"Phương pháp điều khiển","value":"Phần mềm NZXT CAM"},{"key":"Đầu vào kết nối","value":"12V DC / 2.6A"},{"key":"Điện áp kênh đầu ra","value":"5V DC"},{"key":"Các kênh đầu ra","value":"2 x kênh chiếu sáng RGB3 x kênh quạt"},{"key":"Màu LED","value":"RGB"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Dây nguồn nối dài Lian Li Strimer Plus ARGB 8 Pin x2
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Dây nguồn nối dài Lian Li Strimer Plus ARGB 8 Pin x2' as name, N'day-nguon-noi-dai-lian-li-strimer-plus-argb-8-pin-x2' as slug, N'PK-LIANLI-STRIMER-PLUS-ARGB-8PIN-VGA' as sku, N'GENERIC-85203' as mpn, 1300000 as price, N'[{"key":"Model","value":"LIAN LI STRIMER PLUS 2 x 8-PIN"},{"key":"Kích thước chuẩn","value":"345mm (L) X 43,5mm (D) X 8mm (H)"},{"key":"Chất liệu","value":"Silicone/TPE"},{"key":"Độ dài cáp","value":"300mm"},{"key":"Số Lượng bóng led","value":"108"},{"key":"Phụ kiện đi kèm","value":"cáp kết nối ARGB 5V 3-PIN"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Dây nguồn nối dài Lian Li Strimer Plus 24 Pin ARGB
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Dây nguồn nối dài Lian Li Strimer Plus 24 Pin ARGB' as name, N'combo-day-nguon-boc-luoi-lian-li-strimer-plus' as slug, N'PK-LIANLI-STRIMER-PLUS-ARGB-24PIN' as sku, N'GENERIC-80077' as mpn, 1790000 as price, N'[{"key":"Model","value":"LIAN LI ADDRESSABLE RGB STRIMER PLUS 24-PIN"},{"key":"Kích thước chuẩn","value":"247mm (L) X 56,6mm (D) X 8mm (H)"},{"key":"Chất liệu","value":"Silicone/PVC"},{"key":"Độ dài cáp","value":"200mm"},{"key":"Số lượng bóng led","value":"120"},{"key":"Phụ kiện đi kèm","value":"Bộ điều khiển sử dụng phần mềm L-Connect 3"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: NZXT Internal USB Hub - Gen 3 (AC-IUSBH-M3)
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'NZXT Internal USB Hub - Gen 3 (AC-IUSBH-M3)' as name, N'nzxt-internal-usb-hub-gen-3' as slug, N'PK-NZX-USB-HUB-INT-GEN3' as sku, N'GENERIC-7727' as mpn, 590000 as price, N'[{"key":"Nhà sản xuất","value":"NZXT"},{"key":"Bảo hành","value":"12 tháng"},{"key":"Chất liệu","value":"Nhựa, PCB, nam châm"},{"key":"Yêu cầu hệ thống","value":"USB 2.0 internal connector"},{"key":"Nguồn vào","value":"5V DC"},{"key":"Kết nối","value":"1 x USB 2.0 Header, 1 x Molex"},{"key":"Chân đế","value":"Nam châm"},{"key":"Kích thước","value":"105 x 36 x 24.5mm"},{"key":"Tính năng nổi bật","value":"Mở rộng với 3 đầu nối bên trong và 2 đầu nối bên ngoài, để kết nối bộ tản nhiệt AIO, bộ điều khiển quạt và phụ kiện chiếu sáng"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Phụ Kiện Keo tản nhiệt NOCTUA NT-H1 10gram
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Phụ Kiện Keo tản nhiệt NOCTUA NT-H1 10gram' as name, N'keo-tan-nhiet-noctua-nt-h1-10gram' as slug, N'PK-NOC-NT-H1' as sku, N'GENERIC-57293' as mpn, 310000 as price, N'[{"key":"Thương hiệu","value":"Noctua"},{"key":"Thời gian bảo quản khuyến nghị (trước khi sử dụng)","value":"Lên đến 3 năm"},{"key":"Thời gian sử dụng đề xuất (trên CPU)","value":"Lên đến 5 năm"},{"key":"Màu sắc","value":"Xám"},{"key":"Nhiệt độ bảo quản khuyến nghị","value":"Nhiệt độ phòng"},{"key":"Nhiệt độ hoạt động","value":"-50 to 110°C"},{"key":"Tỉ trọng","value":"2,49 g/cm³"},{"key":"Trọng lượng","value":"10g"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Keo tản nhiệt NOCTUA NT - H2 3.5gram
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Keo tản nhiệt NOCTUA NT - H2 3.5gram' as name, N'keo-tan-nhiet-noctua-nt-h2-3-5gram' as slug, N'PK-NOC-NT-H2' as sku, N'GENERIC-68950' as mpn, 290000 as price, N'[{"key":"Thương hiệu","value":"Noctua"},{"key":"Model","value":"NOCTUA NT - H2 3.5gram"},{"key":"Màu sắc","value":"Xám"},{"key":"Tỉ trọng","value":"2.81 g/cm³"},{"key":"Thời gian bảo quản khuyến nghị (trước khi sử dụng)","value":"Lên đến 3 năm"},{"key":"Thời gian sử dụng đề xuất (trên CPU)","value":"Lên đến 5 năm"},{"key":"Nhiệt độ bảo quản khuyến nghị","value":"Nhiệt độ phòng"},{"key":"Nhiệt độ hoạt động","value":"-50 to 200°C"},{"key":"Trọng lượng","value":"3.5 g"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: CORSAIR RGB LED Lighting PRO Expansion Kit
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'CORSAIR RGB LED Lighting PRO Expansion Kit' as name, N'corsair-rgb-led-lighting-pro-expansion-kit' as slug, N'PK-COR-LED-LIGHTING-LED-PRO-EXPANSION-KIT' as sku, N'GENERIC-35004' as mpn, 1190000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Controller] Product: Bộ dây đèn chiếu sáng kèm điều khiển Corsair Lighting Node PRO (CL-9011109-WW)
MERGE INTO products AS target
USING (SELECT 24 as category_id, 1 as brand_id, N'Bộ dây đèn chiếu sáng kèm điều khiển 
Corsair Lighting Node PRO (CL-9011109-WW)' as name, N'corsair-lighting-node-pro' as slug, N'PK-COR-LIGHTNING-NODEPRO' as sku, N'GENERIC-14229' as mpn, 1690000 as price, N'[{"key":"Sản phẩm","value":"Bộ điều khiển Controller"},{"key":"Hãng sản xuất","value":"Corsair"},{"key":"Model","value":"Lighting Node PRO"},{"key":"Màu Sắc","value":"Đen"},{"key":"Kích thước","value":"55mm x 31mm x 12mm"},{"key":"Cable","value":"RGB LED channels: 2 Max.RGB LED strip per channel: 4Mini USB cable: 375mmSATA Power cable: 440mmHD RGB LED hub cable 485mm IndividuallyAddressable RGB LED strip Length: 410mmRGB LED chip count: 10Protective cover: IP65-rated transparent siliconeAdhesion type: 4 magnets per strip and full-strip tapeRGB extension cable: 345mm"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');

-- [Cable] Product: Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)
MERGE INTO products AS target
USING (SELECT 25 as category_id, 1 as brand_id, N'Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)' as name, N'may-bo-acer-atlos-p130f7-i5-ram-8gb-ssd-512gb' as slug, N'PC-ACER-ATLOS-I5' as sku, N'GENERIC-24908' as mpn, 11990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cable] Product: PC GVN Homework Athlon
MERGE INTO products AS target
USING (SELECT 25 as category_id, 1 as brand_id, N'PC GVN Homework Athlon' as name, N'pc-gvn-homework-amd-athlon' as slug, N'PC-GVN-ARES' as sku, N'GENERIC-4715' as mpn, 7190000 as price, N'[{"key":"Mainboard:","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU:","value":"Athlon 3000G / 5MB / 3.5GHz / 2 nhân 4 luồng / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD:","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD:","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU:","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case:","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cable] Product: PC GVN Homework R3
MERGE INTO products AS target
USING (SELECT 25 as category_id, 1 as brand_id, N'PC GVN Homework R3' as name, N'pc-gvn-homework-amd-r3' as slug, N'PC-GVN-HOMEWORK-R3' as sku, N'GENERIC-65800' as mpn, 7630000 as price, N'[{"key":"Mainboard","value":"Bo Mạch Chủ Gigabyte A520M-K V2"},{"key":"CPU","value":"Bộ vi xử lý AMD Ryzen 3 3200G / 3.6GHz Boost 4.0GHz / 4 nhân 4 luồng (TRAY)"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Jetek 350W Elite V2"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cable] Product: PC GVN Homework R5
MERGE INTO products AS target
USING (SELECT 25 as category_id, 1 as brand_id, N'PC GVN Homework R5' as name, N'pc-gvn-homework-amd-r5' as slug, N'PC-GVN-HOMEWORK-R5' as sku, N'GENERIC-96670' as mpn, 10390000 as price, N'[{"key":"","value":"Tên Sản phẩm"},{"key":"Mainboard","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU","value":"AMD Ryzen 5 5600GT / 3.6GHz Boost 4.6GHz / 6 nhân 12 luồng / 19MB / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"VGA","value":"Có thể tùy chọn Nâng cấp"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cable] Product: PC GVN Homework i5
MERGE INTO products AS target
USING (SELECT 25 as category_id, 1 as brand_id, N'PC GVN Homework i5' as name, N'pc-gvn-homework-intel-i5' as slug, N'PC-GVN-HOMEWORK-I5' as sku, N'GENERIC-94582' as mpn, 12990000 as price, N'[{"key":"Mainboard","value":"Mainboard Gigabyte H610M-H V3 DDR4"},{"key":"CPU","value":"Intel Core i5 14400 / Turbo up to 4.7GHz / 10 Nhân 16 Luồng / LGA 1700"},{"key":"RAM","value":"Ram SSTC 8GB DDR4 3200MHz (U3200A-C22-8GB)"},{"key":"SSD","value":"Ổ Cứng SSD SSTC M2 NVME Gen3x4 Max III 256GB"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cable] Product: Phần mềm Windows 11 Home Online DwnLd NR KW9-00664
MERGE INTO products AS target
USING (SELECT 25 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Home Online DwnLd NR KW9-00664' as name, N'phan-mem-windows-11-home-online-dwnld-nr-kw9-00664' as slug, N'PM-MS-WIN11-HOME-FPP-OL-WK9-00664' as sku, N'GENERIC-66115' as mpn, 3490000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"KW9-00664"},{"key":"Hình thức","value":"FPP(ESD) (Full Packaged Product)"},{"key":"Số máy cài đặt","value":"1"},{"key":"Thời hạn","value":"Thời gian sử dụng phần cứng"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cable] Product: Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572
MERGE INTO products AS target
USING (SELECT 25 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572' as name, N'phan-mem-windows-11-pro-online-dwnld-nr-fqc-10572' as slug, N'PM-MS-WIN11-PRO-FPP-OL-FQC-10572' as sku, N'GENERIC-78155' as mpn, 5150000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"FQC-10572"},{"key":"Tên sản phẩm","value":"Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572"},{"key":"Tính năng","value":"- Thích hợp cho kinh doanh- Đa nhiệm- Microsoft Edge - Cortana- Chế độ Máy tính bảng- Máy tính từ xa"},{"key":"Thiết bị","value":"1"},{"key":"Thời hạn","value":"Vĩnh viễn"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cable] Product: Máy chơi game MSI Claw A1M
MERGE INTO products AS target
USING (SELECT 25 as category_id, 1 as brand_id, N'Máy chơi game MSI Claw A1M' as name, N'may-choi-game-msi-claw-a1m' as slug, N'MCG-MSI-CLAW-A1M' as sku, N'GENERIC-5696' as mpn, 14990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Cable] Product: Máy chơi Game cầm tay Lenovo Legion GO
MERGE INTO products AS target
USING (SELECT 25 as category_id, 1 as brand_id, N'Máy chơi Game cầm tay Lenovo Legion GO' as name, N'may-choi-game-cam-tay-lenovo-legion-go' as slug, N'MCG-LENOVO-LEGION-GO' as sku, N'GENERIC-84577' as mpn, 22990000 as price, N'[{"key":"CPU","value":"AMD Ryzen™ Z1 Extreme Processor (Zen4 architecture with 4nm process, 8-core /16-threads, 24MB total cache, up to 5.10 GHz boost)"},{"key":"RAM","value":"16GB (8x2) LPDDR5x 7500 Onboard"},{"key":"Ổ cứng","value":"512GB PCIe® 4.0 NVMe™ M.2 SSD (2242)"},{"key":"VGA","value":"AMD Radeon™ Graphics (AMD RDNA™ 3, 12 CUs, up to 2.7GHz, up to 8.6 Teraflops), TDP: 9-30W"},{"key":"Màn hình","value":"8.8\" WQXGA (2560x1600), Multi-touch, IPS, 500nits, Glossy, anti-fingerprint, 16:10, 1500:1, 97% DCI-P3, 144Hz, 89°/89°/80°/80°, Corning® Gorilla® Glass 5"},{"key":"Cổng giao tiếp","value":"2x USB4® 40Gbps (support data transfer, Power Delivery 3.0 and DisplayPort™ 1.4)1x Headphone / microphone combo jack (3.5mm)1x Card reader2x Pogo pin connector (5-point)"},{"key":"Hệ thống điều khiển","value":"A B X Y buttonsD-padTouchpadFPS mode switchMouse wheelLeft & right JoysticksLeft & right release buttonsLB buttonM1 / RB buttonM2 buttonY1 & Y2 buttonsM3 & Y3 buttons4x function buttons"},{"key":"Audio","value":"Stereo speakers, 2W x2, High Definition (HD) Audio"},{"key":"Chuẩn WIFI","value":"AMD Wi-Fi® 6E RZ616, 802.11ax (2x2)"},{"key":"Bluetooth","value":"v5.3"},{"key":"Hệ điều hành","value":"Windows 11 Home"},{"key":"Pin","value":"Integrated Li-Polymer 49.2Wh"},{"key":"Sạc","value":"65W USB-C® (3-pin) AC adapter, supports PD 3.0, 100-240V, 50-60Hz"},{"key":"Trọng lượng","value":"Gamepad: 640 gGamepad with controllers: 854g"},{"key":"Màu sắc","value":"Shadow black"},{"key":"Kích thước","value":"Gamepad: 210 x 131 x 20.1 (mm)Gamepad with controllers: 298.83 x 131 x 40.7 (mm)"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');

-- [Thermal Paste] Product: Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)
MERGE INTO products AS target
USING (SELECT 27 as category_id, 1 as brand_id, N'Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)' as name, N'may-bo-acer-atlos-p130f7-i5-ram-8gb-ssd-512gb' as slug, N'PC-ACER-ATLOS-I5' as sku, N'GENERIC-29898' as mpn, 11990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Thermal Paste] Product: PC GVN Homework Athlon
MERGE INTO products AS target
USING (SELECT 27 as category_id, 1 as brand_id, N'PC GVN Homework Athlon' as name, N'pc-gvn-homework-amd-athlon' as slug, N'PC-GVN-ARES' as sku, N'GENERIC-48791' as mpn, 7190000 as price, N'[{"key":"Mainboard:","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU:","value":"Athlon 3000G / 5MB / 3.5GHz / 2 nhân 4 luồng / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD:","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD:","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU:","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case:","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Thermal Paste] Product: PC GVN Homework R3
MERGE INTO products AS target
USING (SELECT 27 as category_id, 1 as brand_id, N'PC GVN Homework R3' as name, N'pc-gvn-homework-amd-r3' as slug, N'PC-GVN-HOMEWORK-R3' as sku, N'GENERIC-29423' as mpn, 7630000 as price, N'[{"key":"Mainboard","value":"Bo Mạch Chủ Gigabyte A520M-K V2"},{"key":"CPU","value":"Bộ vi xử lý AMD Ryzen 3 3200G / 3.6GHz Boost 4.0GHz / 4 nhân 4 luồng (TRAY)"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Jetek 350W Elite V2"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Thermal Paste] Product: PC GVN Homework R5
MERGE INTO products AS target
USING (SELECT 27 as category_id, 1 as brand_id, N'PC GVN Homework R5' as name, N'pc-gvn-homework-amd-r5' as slug, N'PC-GVN-HOMEWORK-R5' as sku, N'GENERIC-15688' as mpn, 10390000 as price, N'[{"key":"","value":"Tên Sản phẩm"},{"key":"Mainboard","value":"Mainboard Gigabyte A520M-K V2"},{"key":"CPU","value":"AMD Ryzen 5 5600GT / 3.6GHz Boost 4.6GHz / 6 nhân 12 luồng / 19MB / AM4"},{"key":"RAM","value":"RAM TeamGroup Elite Plus (1x8GB) DDR4 3200MHz"},{"key":"VGA","value":"Có thể tùy chọn Nâng cấp"},{"key":"HDD","value":"Có thể tùy chọn Nâng cấp"},{"key":"SSD","value":"Ổ cứng SSD GIGABYTE NVMe V2 256GB (G3NVMEV2256G)"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Thermal Paste] Product: PC GVN Homework i5
MERGE INTO products AS target
USING (SELECT 27 as category_id, 1 as brand_id, N'PC GVN Homework i5' as name, N'pc-gvn-homework-intel-i5' as slug, N'PC-GVN-HOMEWORK-I5' as sku, N'GENERIC-80526' as mpn, 12990000 as price, N'[{"key":"Mainboard","value":"Mainboard Gigabyte H610M-H V3 DDR4"},{"key":"CPU","value":"Intel Core i5 14400 / Turbo up to 4.7GHz / 10 Nhân 16 Luồng / LGA 1700"},{"key":"RAM","value":"Ram SSTC 8GB DDR4 3200MHz (U3200A-C22-8GB)"},{"key":"SSD","value":"Ổ Cứng SSD SSTC M2 NVME Gen3x4 Max III 256GB"},{"key":"PSU","value":"Nguồn máy tính Jetek Elite V6 350W E350"},{"key":"Case","value":"Vỏ máy tính EDRA ECS1105 Micro-ATX"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Thermal Paste] Product: Phần mềm Windows 11 Home Online DwnLd NR KW9-00664
MERGE INTO products AS target
USING (SELECT 27 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Home Online DwnLd NR KW9-00664' as name, N'phan-mem-windows-11-home-online-dwnld-nr-kw9-00664' as slug, N'PM-MS-WIN11-HOME-FPP-OL-WK9-00664' as sku, N'GENERIC-1731' as mpn, 3490000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"KW9-00664"},{"key":"Hình thức","value":"FPP(ESD) (Full Packaged Product)"},{"key":"Số máy cài đặt","value":"1"},{"key":"Thời hạn","value":"Thời gian sử dụng phần cứng"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Thermal Paste] Product: Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572
MERGE INTO products AS target
USING (SELECT 27 as category_id, 1 as brand_id, N'Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572' as name, N'phan-mem-windows-11-pro-online-dwnld-nr-fqc-10572' as slug, N'PM-MS-WIN11-PRO-FPP-OL-FQC-10572' as sku, N'GENERIC-30252' as mpn, 5150000 as price, N'[{"key":"Nhà sản xuất","value":"Mircosoft"},{"key":"Model","value":"FQC-10572"},{"key":"Tên sản phẩm","value":"Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572"},{"key":"Tính năng","value":"- Thích hợp cho kinh doanh- Đa nhiệm- Microsoft Edge - Cortana- Chế độ Máy tính bảng- Máy tính từ xa"},{"key":"Thiết bị","value":"1"},{"key":"Thời hạn","value":"Vĩnh viễn"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Thermal Paste] Product: Máy chơi game MSI Claw A1M
MERGE INTO products AS target
USING (SELECT 27 as category_id, 1 as brand_id, N'Máy chơi game MSI Claw A1M' as name, N'may-choi-game-msi-claw-a1m' as slug, N'MCG-MSI-CLAW-A1M' as sku, N'GENERIC-36993' as mpn, 14990000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [Thermal Paste] Product: Máy chơi Game cầm tay Lenovo Legion GO
MERGE INTO products AS target
USING (SELECT 27 as category_id, 1 as brand_id, N'Máy chơi Game cầm tay Lenovo Legion GO' as name, N'may-choi-game-cam-tay-lenovo-legion-go' as slug, N'MCG-LENOVO-LEGION-GO' as sku, N'GENERIC-62813' as mpn, 22990000 as price, N'[{"key":"CPU","value":"AMD Ryzen™ Z1 Extreme Processor (Zen4 architecture with 4nm process, 8-core /16-threads, 24MB total cache, up to 5.10 GHz boost)"},{"key":"RAM","value":"16GB (8x2) LPDDR5x 7500 Onboard"},{"key":"Ổ cứng","value":"512GB PCIe® 4.0 NVMe™ M.2 SSD (2242)"},{"key":"VGA","value":"AMD Radeon™ Graphics (AMD RDNA™ 3, 12 CUs, up to 2.7GHz, up to 8.6 Teraflops), TDP: 9-30W"},{"key":"Màn hình","value":"8.8\" WQXGA (2560x1600), Multi-touch, IPS, 500nits, Glossy, anti-fingerprint, 16:10, 1500:1, 97% DCI-P3, 144Hz, 89°/89°/80°/80°, Corning® Gorilla® Glass 5"},{"key":"Cổng giao tiếp","value":"2x USB4® 40Gbps (support data transfer, Power Delivery 3.0 and DisplayPort™ 1.4)1x Headphone / microphone combo jack (3.5mm)1x Card reader2x Pogo pin connector (5-point)"},{"key":"Hệ thống điều khiển","value":"A B X Y buttonsD-padTouchpadFPS mode switchMouse wheelLeft & right JoysticksLeft & right release buttonsLB buttonM1 / RB buttonM2 buttonY1 & Y2 buttonsM3 & Y3 buttons4x function buttons"},{"key":"Audio","value":"Stereo speakers, 2W x2, High Definition (HD) Audio"},{"key":"Chuẩn WIFI","value":"AMD Wi-Fi® 6E RZ616, 802.11ax (2x2)"},{"key":"Bluetooth","value":"v5.3"},{"key":"Hệ điều hành","value":"Windows 11 Home"},{"key":"Pin","value":"Integrated Li-Polymer 49.2Wh"},{"key":"Sạc","value":"65W USB-C® (3-pin) AC adapter, supports PD 3.0, 100-240V, 50-60Hz"},{"key":"Trọng lượng","value":"Gamepad: 640 gGamepad with controllers: 854g"},{"key":"Màu sắc","value":"Shadow black"},{"key":"Kích thước","value":"Gamepad: 210 x 131 x 20.1 (mm)Gamepad with controllers: 298.83 x 131 x 40.7 (mm)"}]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');

COMMIT TRANSACTION;
PRINT '✅ Master Import Thành Công!';
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
PRINT ERROR_MESSAGE();
END CATCH;
