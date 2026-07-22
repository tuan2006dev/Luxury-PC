-- MULTI-VENDOR DB LOADER (MEMORYZONE)
BEGIN TRANSACTION;
BEGIN TRY

-- [MemoryZone] [Mainboard] Product: Laptop Lenovo ThinkPad X1 Carbon Gen 13 Aura Edition 21NS010BVN (Ultra 7 258V, Intel Arc Graphics, RAM 32GB LPDDR5X, SSD 512GB, 14 Inch OLED 2.8K 120Hz 100% DCI-P3, Win 11 Pro)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad X1 Carbon Gen 13 Aura Edition 21NS010BVN (Ultra 7 258V, Intel Arc Graphics, RAM 32GB LPDDR5X, SSD 512GB, 14 Inch OLED 2.8K 120Hz 100% DCI-P3, Win 11 Pro)' as name, N'laptop-lenovo-thinkpad-x1-carbon-gen-13-aura-edition-21ns010bvn' as slug, N'21NS010BVN' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop Lenovo ThinkPad X1 Carbon Gen 13 21NS010CVN (Ultra 7 258V, Intel Arc Graphics, RAM 32GB, SSD 1TB, 14 Inch OLED 2.8K 120Hz, Window 11 Pro)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad X1 Carbon Gen 13 21NS010CVN (Ultra 7 258V, Intel Arc Graphics, RAM 32GB, SSD 1TB, 14 Inch OLED 2.8K 120Hz, Window 11 Pro)' as name, N'laptop-lenovo-thinkpad-x1-carbon-gen-13-21ns010cvn' as slug, N'21NS010CVN' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop Lenovo ThinkPad E14 Gen 7 21U2006FVA (Ultra 7 258V, Intel Arc Graphics, RAM 32GB, SSD 512GB, 14 Inch WUXGA 60Hz, NoOS)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad E14 Gen 7 21U2006FVA (Ultra 7 258V, Intel Arc Graphics, RAM 32GB, SSD 512GB, 14 Inch WUXGA 60Hz, NoOS)' as name, N'laptop-lenovo-thinkpad-e14-gen-7-21u2006fva' as slug, N'21U2006FVA' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop Lenovo ThinkPad E14 Gen 7 21U2003PVA (Ultra 5 228V, Intel Arc Graphic, RAM 32GB, SSD 512GB, 14 Inch IPS WUXGA 60Hz, NoOS)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad E14 Gen 7 21U2003PVA (Ultra 5 228V, Intel Arc Graphic, RAM 32GB, SSD 512GB, 14 Inch IPS WUXGA 60Hz, NoOS)' as name, N'laptop-lenovo-thinkpad-e14-gen-7-21u2003pva' as slug, N'21U2003PVA' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop Lenovo ThinkPad E14 Gen 7 21SYS33P00 (Ultra 7 255H, Intel Arc Graphics, RAM 32GB, SSD 512GB, 14 Inch IPS 2.8K 120Hz, NoOS)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad E14 Gen 7 21SYS33P00 (Ultra 7 255H, Intel Arc Graphics, RAM 32GB, SSD 512GB, 14 Inch IPS 2.8K 120Hz, NoOS)' as name, N'laptop-lenovo-thinkpad-e14-gen-7-21sys33p00' as slug, N'21SYS33P00' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop Lenovo ThinkPad X1 Carbon Gen 13 Aura Edition 21NS010JVN (Ultra 7 258V, Intel Arc Graphics, RAM 32GB LPDDR5X, SSD 1TB, 14 Inch OLED 2.8K 120Hz 100% DCI-P3, Win 11 Pro)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad X1 Carbon Gen 13 Aura Edition 21NS010JVN (Ultra 7 258V, Intel Arc Graphics, RAM 32GB LPDDR5X, SSD 1TB, 14 Inch OLED 2.8K 120Hz 100% DCI-P3, Win 11 Pro)' as name, N'laptop-lenovo-thinkpad-x1-carbon-gen-13-aura-edition-21ns010jvn' as slug, N'21NS010JVN' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop Lenovo V14 G5 IRL 83HD0062VA (i5-13420H, Intel Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS FHD 60Hz, NoOS)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop Lenovo V14 G5 IRL 83HD0062VA (i5-13420H, Intel Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS FHD 60Hz, NoOS)' as name, N'laptop-lenovo-v14-g5-83hd0062va' as slug, N'83HD0062VA' as sku, N'MZ-laptoplenovov14' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop Lenovo ThinkPad E14 Gen 6 21M7004WVA (Ultra 7 155H, Intel Arc Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS WUXGA 60Hz, NoOS)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad E14 Gen 6 21M7004WVA (Ultra 7 155H, Intel Arc Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS WUXGA 60Hz, NoOS)' as name, N'laptop-lenovo-thinkpad-e14-gen-6-21m7004wva' as slug, N'21M7004WVA' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop Lenovo Thinkbook 14 Gen 8 IRL 21SG007MVA (Core 5 210H, Intel Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS WUXGA 60Hz, No OS)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop Lenovo Thinkbook 14 Gen 8 IRL 21SG007MVA (Core 5 210H, Intel Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS WUXGA 60Hz, No OS)' as name, N'laptop-lenovo-thinkbook-14-gen-8-irl-21sg007mva' as slug, N'21SG007MVA' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop MSI Modern 14 F1MG-432VN (Core 5 120U, Intel Graphics, RAM 16GB DDR4, SSD 512GB, 14 Inch IPS FHD 60Hz, Win 11 Home)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop MSI Modern 14 F1MG-432VN (Core 5 120U, Intel Graphics, RAM 16GB DDR4, SSD 512GB, 14 Inch IPS FHD 60Hz, Win 11 Home)' as name, N'laptop-msi-modern-14-f1mg-432vn' as slug, N'F1MG-432VN' as sku, N'MZ-laptopmsimodern' as mpn, 21900000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop ASUS ExpertBook P1 P1403CVA-C5H16-50W (Core 5 210H, Intel Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS FHD 60Hz, Win 11 Home)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop ASUS ExpertBook P1 P1403CVA-C5H16-50W (Core 5 210H, Intel Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS FHD 60Hz, Win 11 Home)' as name, N'laptop-asus-expertbook-p1-p1403cva-c5h16-50w' as slug, N'P1403CVA-C5H16-50W' as sku, N'MZ-laptopasusexper' as mpn, 24900000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop Lenovo ThinkBook 16 G8 IRL 21SH0097VN (Core 5 210H, Intel Graphics, RAM 16GB DDR5, SDD 512GB, 16 Inch IPS WUXGA 60Hz, Window 11 Home)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkBook 16 G8 IRL 21SH0097VN (Core 5 210H, Intel Graphics, RAM 16GB DDR5, SDD 512GB, 16 Inch IPS WUXGA 60Hz, Window 11 Home)' as name, N'laptop-lenovo-thinkbook-16-g8-irl-21sh0097vn' as slug, N'21SH0097VN' as sku, N'MZ-laptoplenovothi' as mpn, 25900000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop MSI Cyborg 15 A13UC-2088VN (i5-13420H, RTX 3050 4GB, RAM 16GB D5, SSD 512GB, 15.6 Inch FHD IPS 144Hz)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop MSI Cyborg 15 A13UC-2088VN (i5-13420H, RTX 3050 4GB, RAM 16GB D5, SSD 512GB, 15.6 Inch FHD IPS 144Hz)' as name, N'laptop-msi-cyborg-15-a13uc-2088vn' as slug, N'A13UC-2088VN' as sku, N'MZ-laptopmsicyborg' as mpn, 26000000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop Lenovo V14 G5 IRL 83HD0035VN (Core 7 240H, Intel Graphics, RAM 16GB DDR5, 512GB SSD, 14 Inch IPS FHD 60Hz, Win11)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop Lenovo V14 G5 IRL 83HD0035VN (Core 7 240H, Intel Graphics, RAM 16GB DDR5, 512GB SSD, 14 Inch IPS FHD 60Hz, Win11)' as name, N'laptop-lenovo-v14-g5-irl-83hd0035vn' as slug, N'83HD0035VN' as sku, N'MZ-laptoplenovov14' as mpn, 28500000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop Lenovo ThinkPad E16 Gen 3 21SR00A6VA (Ultra 5 135H, Intel Arc Graphics, RAM 16GB DDR5, SSD 512GB, 16 Inch IPS WUXGA 60Hz, NoOS)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad E16 Gen 3 21SR00A6VA (Ultra 5 135H, Intel Arc Graphics, RAM 16GB DDR5, SSD 512GB, 16 Inch IPS WUXGA 60Hz, NoOS)' as name, N'laptop-lenovo-thinkpad-e16-gen-3-21sr00a6va' as slug, N'21SR00A6VA' as sku, N'MZ-laptoplenovothi' as mpn, 29900000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Laptop MSI Katana 15 B13VEK-2440VN (i7-13620H, RTX 4050 6GB, RAM 16GB DDR5, SSD 1TB, 15.6 Inch IPS FHD 144Hz, Win 11)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Laptop MSI Katana 15 B13VEK-2440VN (i7-13620H, RTX 4050 6GB, RAM 16GB DDR5, SSD 1TB, 15.6 Inch IPS FHD 144Hz, Win 11)' as name, N'laptop-msi-katana-15-b13vek-2440vn' as slug, N'B13VEK-2440VN' as sku, N'MZ-laptopmsikatana' as mpn, 33900000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Máy tính Mini PC ASUS NUC 15 Pro Plus RNUC15CRSU500000I (Ultra 5 225H, Arc Graphics)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Máy tính Mini PC ASUS NUC 15 Pro Plus RNUC15CRSU500000I (Ultra 5 225H, Arc Graphics)' as name, N'may-tinh-mini-pc-asus-nuc-15-pro-plus-rnuc15crsu500000i-ultra-5-225h-arc-graphics' as slug, N'RNUC15CRSU500000I' as sku, N'MZ-mytnhminipcasus' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Máy tính Mini PC ASUS NUC 15 Pro Tall RNUC15CRHU500000I (Ultra 5 225H, Arc Graphics)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Máy tính Mini PC ASUS NUC 15 Pro Tall RNUC15CRHU500000I (Ultra 5 225H, Arc Graphics)' as name, N'may-tinh-mini-pc-asus-nuc-15-pro-tall-rnuc15crhu500000i-ultra-5-225h-arc-graphics' as slug, N'RNUC15CRHU500000I' as sku, N'MZ-mytnhminipcasus' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: PC M5 i5-5060 (i5-14400F, RTX 5060 8GB, RAM DDR5 32GB, SSD 1TB, 650W, Ubuntu)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'PC M5 i5-5060 (i5-14400F, RTX 5060 8GB, RAM DDR5 32GB, SSD 1TB, 650W, Ubuntu)' as name, N'pc-m5-i5-5060' as slug, N'PC-M5-i5-5060' as sku, N'MZ-pcm5i55060i5144' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [Mainboard] Product: Máy tính Mini PC ASUS NUC 14 Pro Tall RNUC14RVHU500000I (Ultra 5 125H, Arc Graphics)
MERGE INTO products AS target
USING (SELECT 4 as category_id, 1 as brand_id, N'Máy tính Mini PC ASUS NUC 14 Pro Tall RNUC14RVHU500000I (Ultra 5 125H, Arc Graphics)' as name, N'may-tinh-mini-pc-asus-nuc-14-pro-tall-rnuc14rvhu500000i' as slug, N'RNUC14RVHU500000I' as sku, N'MZ-mytnhminipcasus' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');

-- [MemoryZone] [SSD] Product: Laptop Lenovo ThinkPad X1 Carbon Gen 13 Aura Edition 21NS010BVN (Ultra 7 258V, Intel Arc Graphics, RAM 32GB LPDDR5X, SSD 512GB, 14 Inch OLED 2.8K 120Hz 100% DCI-P3, Win 11 Pro)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad X1 Carbon Gen 13 Aura Edition 21NS010BVN (Ultra 7 258V, Intel Arc Graphics, RAM 32GB LPDDR5X, SSD 512GB, 14 Inch OLED 2.8K 120Hz 100% DCI-P3, Win 11 Pro)' as name, N'laptop-lenovo-thinkpad-x1-carbon-gen-13-aura-edition-21ns010bvn' as slug, N'21NS010BVN' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop Lenovo ThinkPad X1 Carbon Gen 13 21NS010CVN (Ultra 7 258V, Intel Arc Graphics, RAM 32GB, SSD 1TB, 14 Inch OLED 2.8K 120Hz, Window 11 Pro)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad X1 Carbon Gen 13 21NS010CVN (Ultra 7 258V, Intel Arc Graphics, RAM 32GB, SSD 1TB, 14 Inch OLED 2.8K 120Hz, Window 11 Pro)' as name, N'laptop-lenovo-thinkpad-x1-carbon-gen-13-21ns010cvn' as slug, N'21NS010CVN' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop Lenovo ThinkPad E14 Gen 7 21U2006FVA (Ultra 7 258V, Intel Arc Graphics, RAM 32GB, SSD 512GB, 14 Inch WUXGA 60Hz, NoOS)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad E14 Gen 7 21U2006FVA (Ultra 7 258V, Intel Arc Graphics, RAM 32GB, SSD 512GB, 14 Inch WUXGA 60Hz, NoOS)' as name, N'laptop-lenovo-thinkpad-e14-gen-7-21u2006fva' as slug, N'21U2006FVA' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop Lenovo ThinkPad E14 Gen 7 21U2003PVA (Ultra 5 228V, Intel Arc Graphic, RAM 32GB, SSD 512GB, 14 Inch IPS WUXGA 60Hz, NoOS)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad E14 Gen 7 21U2003PVA (Ultra 5 228V, Intel Arc Graphic, RAM 32GB, SSD 512GB, 14 Inch IPS WUXGA 60Hz, NoOS)' as name, N'laptop-lenovo-thinkpad-e14-gen-7-21u2003pva' as slug, N'21U2003PVA' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop Lenovo ThinkPad E14 Gen 7 21SYS33P00 (Ultra 7 255H, Intel Arc Graphics, RAM 32GB, SSD 512GB, 14 Inch IPS 2.8K 120Hz, NoOS)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad E14 Gen 7 21SYS33P00 (Ultra 7 255H, Intel Arc Graphics, RAM 32GB, SSD 512GB, 14 Inch IPS 2.8K 120Hz, NoOS)' as name, N'laptop-lenovo-thinkpad-e14-gen-7-21sys33p00' as slug, N'21SYS33P00' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop Lenovo ThinkPad X1 Carbon Gen 13 Aura Edition 21NS010JVN (Ultra 7 258V, Intel Arc Graphics, RAM 32GB LPDDR5X, SSD 1TB, 14 Inch OLED 2.8K 120Hz 100% DCI-P3, Win 11 Pro)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad X1 Carbon Gen 13 Aura Edition 21NS010JVN (Ultra 7 258V, Intel Arc Graphics, RAM 32GB LPDDR5X, SSD 1TB, 14 Inch OLED 2.8K 120Hz 100% DCI-P3, Win 11 Pro)' as name, N'laptop-lenovo-thinkpad-x1-carbon-gen-13-aura-edition-21ns010jvn' as slug, N'21NS010JVN' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop Lenovo V14 G5 IRL 83HD0062VA (i5-13420H, Intel Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS FHD 60Hz, NoOS)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop Lenovo V14 G5 IRL 83HD0062VA (i5-13420H, Intel Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS FHD 60Hz, NoOS)' as name, N'laptop-lenovo-v14-g5-83hd0062va' as slug, N'83HD0062VA' as sku, N'MZ-laptoplenovov14' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop Lenovo ThinkPad E14 Gen 6 21M7004WVA (Ultra 7 155H, Intel Arc Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS WUXGA 60Hz, NoOS)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad E14 Gen 6 21M7004WVA (Ultra 7 155H, Intel Arc Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS WUXGA 60Hz, NoOS)' as name, N'laptop-lenovo-thinkpad-e14-gen-6-21m7004wva' as slug, N'21M7004WVA' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop Lenovo Thinkbook 14 Gen 8 IRL 21SG007MVA (Core 5 210H, Intel Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS WUXGA 60Hz, No OS)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop Lenovo Thinkbook 14 Gen 8 IRL 21SG007MVA (Core 5 210H, Intel Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS WUXGA 60Hz, No OS)' as name, N'laptop-lenovo-thinkbook-14-gen-8-irl-21sg007mva' as slug, N'21SG007MVA' as sku, N'MZ-laptoplenovothi' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop MSI Modern 14 F1MG-432VN (Core 5 120U, Intel Graphics, RAM 16GB DDR4, SSD 512GB, 14 Inch IPS FHD 60Hz, Win 11 Home)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop MSI Modern 14 F1MG-432VN (Core 5 120U, Intel Graphics, RAM 16GB DDR4, SSD 512GB, 14 Inch IPS FHD 60Hz, Win 11 Home)' as name, N'laptop-msi-modern-14-f1mg-432vn' as slug, N'F1MG-432VN' as sku, N'MZ-laptopmsimodern' as mpn, 21900000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop ASUS ExpertBook P1 P1403CVA-C5H16-50W (Core 5 210H, Intel Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS FHD 60Hz, Win 11 Home)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop ASUS ExpertBook P1 P1403CVA-C5H16-50W (Core 5 210H, Intel Graphics, RAM 16GB DDR5, SSD 512GB, 14 Inch IPS FHD 60Hz, Win 11 Home)' as name, N'laptop-asus-expertbook-p1-p1403cva-c5h16-50w' as slug, N'P1403CVA-C5H16-50W' as sku, N'MZ-laptopasusexper' as mpn, 24900000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop Lenovo ThinkBook 16 G8 IRL 21SH0097VN (Core 5 210H, Intel Graphics, RAM 16GB DDR5, SDD 512GB, 16 Inch IPS WUXGA 60Hz, Window 11 Home)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkBook 16 G8 IRL 21SH0097VN (Core 5 210H, Intel Graphics, RAM 16GB DDR5, SDD 512GB, 16 Inch IPS WUXGA 60Hz, Window 11 Home)' as name, N'laptop-lenovo-thinkbook-16-g8-irl-21sh0097vn' as slug, N'21SH0097VN' as sku, N'MZ-laptoplenovothi' as mpn, 25900000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop MSI Cyborg 15 A13UC-2088VN (i5-13420H, RTX 3050 4GB, RAM 16GB D5, SSD 512GB, 15.6 Inch FHD IPS 144Hz)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop MSI Cyborg 15 A13UC-2088VN (i5-13420H, RTX 3050 4GB, RAM 16GB D5, SSD 512GB, 15.6 Inch FHD IPS 144Hz)' as name, N'laptop-msi-cyborg-15-a13uc-2088vn' as slug, N'A13UC-2088VN' as sku, N'MZ-laptopmsicyborg' as mpn, 26000000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop Lenovo V14 G5 IRL 83HD0035VN (Core 7 240H, Intel Graphics, RAM 16GB DDR5, 512GB SSD, 14 Inch IPS FHD 60Hz, Win11)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop Lenovo V14 G5 IRL 83HD0035VN (Core 7 240H, Intel Graphics, RAM 16GB DDR5, 512GB SSD, 14 Inch IPS FHD 60Hz, Win11)' as name, N'laptop-lenovo-v14-g5-irl-83hd0035vn' as slug, N'83HD0035VN' as sku, N'MZ-laptoplenovov14' as mpn, 28500000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop Lenovo ThinkPad E16 Gen 3 21SR00A6VA (Ultra 5 135H, Intel Arc Graphics, RAM 16GB DDR5, SSD 512GB, 16 Inch IPS WUXGA 60Hz, NoOS)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop Lenovo ThinkPad E16 Gen 3 21SR00A6VA (Ultra 5 135H, Intel Arc Graphics, RAM 16GB DDR5, SSD 512GB, 16 Inch IPS WUXGA 60Hz, NoOS)' as name, N'laptop-lenovo-thinkpad-e16-gen-3-21sr00a6va' as slug, N'21SR00A6VA' as sku, N'MZ-laptoplenovothi' as mpn, 29900000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Laptop MSI Katana 15 B13VEK-2440VN (i7-13620H, RTX 4050 6GB, RAM 16GB DDR5, SSD 1TB, 15.6 Inch IPS FHD 144Hz, Win 11)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Laptop MSI Katana 15 B13VEK-2440VN (i7-13620H, RTX 4050 6GB, RAM 16GB DDR5, SSD 1TB, 15.6 Inch IPS FHD 144Hz, Win 11)' as name, N'laptop-msi-katana-15-b13vek-2440vn' as slug, N'B13VEK-2440VN' as sku, N'MZ-laptopmsikatana' as mpn, 33900000 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Máy tính Mini PC ASUS NUC 15 Pro Plus RNUC15CRSU500000I (Ultra 5 225H, Arc Graphics)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Máy tính Mini PC ASUS NUC 15 Pro Plus RNUC15CRSU500000I (Ultra 5 225H, Arc Graphics)' as name, N'may-tinh-mini-pc-asus-nuc-15-pro-plus-rnuc15crsu500000i-ultra-5-225h-arc-graphics' as slug, N'RNUC15CRSU500000I' as sku, N'MZ-mytnhminipcasus' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Máy tính Mini PC ASUS NUC 15 Pro Tall RNUC15CRHU500000I (Ultra 5 225H, Arc Graphics)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Máy tính Mini PC ASUS NUC 15 Pro Tall RNUC15CRHU500000I (Ultra 5 225H, Arc Graphics)' as name, N'may-tinh-mini-pc-asus-nuc-15-pro-tall-rnuc15crhu500000i-ultra-5-225h-arc-graphics' as slug, N'RNUC15CRHU500000I' as sku, N'MZ-mytnhminipcasus' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: PC M5 i5-5060 (i5-14400F, RTX 5060 8GB, RAM DDR5 32GB, SSD 1TB, 650W, Ubuntu)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'PC M5 i5-5060 (i5-14400F, RTX 5060 8GB, RAM DDR5 32GB, SSD 1TB, 650W, Ubuntu)' as name, N'pc-m5-i5-5060' as slug, N'PC-M5-i5-5060' as sku, N'MZ-pcm5i55060i5144' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');


-- [MemoryZone] [SSD] Product: Máy tính Mini PC ASUS NUC 14 Pro Tall RNUC14RVHU500000I (Ultra 5 125H, Arc Graphics)
MERGE INTO products AS target
USING (SELECT 5 as category_id, 1 as brand_id, N'Máy tính Mini PC ASUS NUC 14 Pro Tall RNUC14RVHU500000I (Ultra 5 125H, Arc Graphics)' as name, N'may-tinh-mini-pc-asus-nuc-14-pro-tall-rnuc14rvhu500000i' as slug, N'RNUC14RVHU500000I' as sku, N'MZ-mytnhminipcasus' as mpn, 0 as price, N'[]' as specs_json) AS source
ON (target.sku = source.sku)
WHEN MATCHED THEN UPDATE SET price = source.price, specs_json = source.specs_json, updated_at = GETDATE()
WHEN NOT MATCHED THEN INSERT (category_id, brand_id, name, slug, sku, mpn, price, specs_json, status) VALUES (source.category_id, source.brand_id, source.name, source.slug, source.sku, source.mpn, source.price, source.specs_json, 'ACTIVE');

COMMIT TRANSACTION;
PRINT '✅ MemoryZone Import Thành Công!';
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
PRINT ERROR_MESSAGE();
END CATCH;
