-- ===============================================================================
-- SCRIPT CẬP NHẬT DỮ LIỆU SẢN PHẨM CPU (UPDATE & UPSERT SCRIPT)
-- Database: LUXURYPC
-- Bảng: products (Cập nhật thông tin Giá, Mô tả, Tồn kho, Ảnh, Hãng cho các CPU)
-- ===============================================================================

----------------------------------------------------------------------------------
-- 1. DÒNG SẢN PHẨM INTEL CORE & ULTRA & PENTIUM
----------------------------------------------------------------------------------

-- Intel Core i9-14900K (ID: 1)
UPDATE products 
SET name = 'Intel Core i9-14900K', price = 15500000, description = '24 Cores, up to 6.0GHz, LGA 1700', image = 'i9_14900k.jpg', category_id = 1, stock = 46, brand = 'Intel'
WHERE id = 1 OR name LIKE '%i9-14900K%' AND name NOT LIKE '%Tray%';

-- Intel Core i7-14700K (ID: 3)
UPDATE products 
SET name = 'Intel Core i7-14700K', price = 10800000, description = '20 Cores, Hybrid Architecture', image = 'i9_14900k.jpg', category_id = 1, stock = 40, brand = 'Intel'
WHERE id = 3 OR name LIKE '%i7-14700K%';

-- Intel Core i5-13600K (ID: 5)
UPDATE products 
SET name = 'Intel Core i5-13600K', price = 8200000, description = '14 Cores, Mid-range gaming', image = 'i9_14900k.jpg', category_id = 1, stock = 54, brand = 'Intel'
WHERE id = 5 OR name LIKE '%i5-13600K%';

-- Intel Core i9-13900KS (ID: 7)
UPDATE products 
SET name = 'Intel Core i9-13900KS', price = 18500000, description = 'Special Edition, 6.0GHz', image = 'i9_14900k.jpg', category_id = 1, stock = 10, brand = 'Intel'
WHERE id = 7 OR name LIKE '%i9-13900KS%';

-- Intel Core i7-13700F (ID: 9)
UPDATE products 
SET name = 'Intel Core i7-13700F', price = 8900000, description = '16 Cores, No Integrated Graphics', image = 'i9_14900k.jpg', category_id = 1, stock = 45, brand = 'Intel'
WHERE id = 9 OR name LIKE '%i7-13700F%';

-- Intel Core i5-12400F (ID: 11)
UPDATE products 
SET name = 'Intel Core i5-12400F', price = 3500000, description = 'Budget King, 6 Cores', image = 'i9_14900k.jpg', category_id = 1, stock = 96, brand = 'Intel'
WHERE id = 11 OR (name LIKE '%i5-12400F%' AND name NOT LIKE '%TRAY%');

-- Intel Core i3-14100 (ID: 13)
UPDATE products 
SET name = 'Intel Core i3-14100', price = 3800000, description = 'Entry level 14th Gen', image = 'i9_14900k.jpg', category_id = 1, stock = 70, brand = 'Intel'
WHERE id = 13 OR name LIKE '%i3-14100%';

-- Intel Core i9-12900K (ID: 15)
UPDATE products 
SET name = 'Intel Core i9-12900K', price = 9500000, description = '16 Cores, Previous Flagship', image = 'i9_14900k.jpg', category_id = 1, stock = 13, brand = 'Intel'
WHERE id = 15 OR name LIKE '%i9-12900K%';

-- Intel Core i5-14400F (ID: 17)
UPDATE products 
SET name = 'Intel Core i5-14400F', price = 5600000, description = '10 Cores, Efficient Gaming', image = 'i9_14900k.jpg', category_id = 1, stock = 65, brand = 'Intel'
WHERE id = 17 OR name LIKE '%i5-14400F%';

-- Intel Core i7-12700K (ID: 19)
UPDATE products 
SET name = 'Intel Core i7-12700K', price = 7200000, description = '12 Cores, LGA 1700', image = 'i9_14900k.jpg', category_id = 1, stock = 34, brand = 'Intel'
WHERE id = 19 OR name LIKE '%i7-12700K%';

-- Intel Core i5-11400F (ID: 21)
UPDATE products 
SET name = 'Intel Core i5-11400F', price = 2800000, description = 'Old Gen Budget King', image = 'i9_14900k.jpg', category_id = 1, stock = 50, brand = 'Intel'
WHERE id = 21 OR name LIKE '%i5-11400F%';

-- Intel Core i9-11900K (ID: 23)
UPDATE products 
SET name = 'Intel Core i9-11900K', price = 6500000, description = 'Legacy Flagship LGA 1200', image = 'i9_14900k.jpg', category_id = 1, stock = 10, brand = 'Intel'
WHERE id = 23 OR name LIKE '%i9-11900K%';

-- Intel Core i5-10400F (ID: 25)
UPDATE products 
SET name = 'Intel Core i5-10400F', price = 2200000, description = 'Stable and Cheap', image = 'i9_14900k.jpg', category_id = 1, stock = 110, brand = 'Intel'
WHERE id = 25 OR name LIKE '%i5-10400F%';

-- Intel Pentium G7400 (ID: 27)
UPDATE products 
SET name = 'Intel Pentium G7400', price = 1900000, description = 'Office work, 2 Cores', image = 'i9_14900k.jpg', category_id = 1, stock = 200, brand = 'Intel'
WHERE id = 27 OR name LIKE '%Pentium G7400%';

-- Intel Core i7-10700K (ID: 29)
UPDATE products 
SET name = 'Intel Core i7-10700K', price = 4800000, description = 'High Clock Legacy', image = 'i9_14900k.jpg', category_id = 1, stock = 20, brand = 'Intel'
WHERE id = 29 OR name LIKE '%i7-10700K%';

-- Intel Core i5 12400F Tray (ID: 255)
UPDATE products 
SET name = 'Intel Core i5 12400F / 2.5GHz Turbo 4.4GHz (TRAY) - CHÍNH HÃNG', price = 2500000, description = 'TDP: 65W', image = '/images/products/i5_12400f.png', category_id = 1, stock = 90, brand = 'Intel'
WHERE id = 255 OR name LIKE '%i5 12400F%TRAY%';

-- Intel Core i7 14700F Tray (ID: 258)
UPDATE products 
SET name = 'Intel Core i7 14700F (Tray)', price = 9500000, description = 'TDP: 65W', image = '/images/products/i7_14700f.jpg', category_id = 1, stock = 100, brand = 'Intel'
WHERE id = 258 OR name LIKE '%i7 14700F%Tray%';

-- Intel Core i9 14900K Tray (ID: 278)
UPDATE products 
SET name = 'Intel Core i9 14900K (Tray)', price = 14000000, description = 'TDP: 125W', image = '/images/products/i9_14900k.jpg', category_id = 1, stock = 100, brand = 'Intel'
WHERE id = 278 OR name LIKE '%i9 14900K%Tray%';

-- Intel Core Ultra 7 265F Tray (ID: 279)
UPDATE products 
SET name = 'Intel Core Ultra 7 265F (Tray)', price = 12000000, description = 'TDP: 125W', image = '/images/products/ultra7_265f.jpg', category_id = 1, stock = 80, brand = 'Intel'
WHERE id = 279 OR name LIKE '%Ultra 7 265F%';

-- Intel Core Ultra 9 285K (ID: 286)
UPDATE products 
SET name = 'Intel Core Ultra 9 285K', price = 16500000, description = 'TDP: 125W', image = '/images/products/ultra9_285k.jpg', category_id = 1, stock = 60, brand = 'Intel'
WHERE id = 286 OR name LIKE '%Ultra 9 285K%';

----------------------------------------------------------------------------------
-- 2. DÒNG SẢN PHẨM AMD RYZEN & ATHLON
----------------------------------------------------------------------------------

-- AMD Ryzen 9 7950X3D (ID: 2)
UPDATE products 
SET name = 'AMD Ryzen 9 7950X3D', price = 17200000, description = '16 Cores, 128MB L3 Cache, AM5', image = 'i9_14900k.jpg', category_id = 1, stock = 15, brand = 'AMD'
WHERE id = 2 OR name LIKE '%7950X3D%';

-- AMD Ryzen 7 7800X3D (ID: 4)
UPDATE products 
SET name = 'AMD Ryzen 7 7800X3D', price = 11500000, description = 'Best gaming CPU, 8 Cores, 3D V-Cache', image = 'i9_14900k.jpg', category_id = 1, stock = 27, brand = 'AMD'
WHERE id = 4 OR name LIKE '%7800X3D%';

-- AMD Ryzen 5 7600X (ID: 6)
UPDATE products 
SET name = 'AMD Ryzen 5 7600X', price = 5800000, description = '6 Cores, Zen 4 Architecture, AM5', image = 'i9_14900k.jpg', category_id = 1, stock = 59, brand = 'AMD'
WHERE id = 6 OR name LIKE '%7600X%';

-- AMD Ryzen 9 7900X (ID: 8)
UPDATE products 
SET name = 'AMD Ryzen 9 7900X', price = 10500000, description = '12 Cores, 5.6GHz Boost', image = 'i9_14900k.jpg', category_id = 1, stock = 18, brand = 'AMD'
WHERE id = 8 OR name LIKE '%7900X%';

-- AMD Ryzen 7 5800X3D (ID: 10)
UPDATE products 
SET name = 'AMD Ryzen 7 5800X3D', price = 8500000, description = 'Legendary AM4 gaming CPU', image = 'i9_14900k.jpg', category_id = 1, stock = 25, brand = 'AMD'
WHERE id = 10 OR name LIKE '%5800X3D%';

-- AMD Ryzen 5 5600G (ID: 12)
UPDATE products 
SET name = 'AMD Ryzen 5 5600G', price = 3200000, description = 'Integrated Vega Graphics', image = 'i9_14900k.jpg', category_id = 1, stock = 71, brand = 'AMD'
WHERE id = 12 OR name LIKE '%5600G%';

-- AMD Ryzen 5 5600X Desktop Processor
UPDATE products 
SET name = 'AMD Ryzen 5 5600X Desktop Processor', price = 3600000, description = '6 Cores, 12 Threads, 35MB Cache, Up to 4.6GHz, Socket AM4', image = 'i9_14900k.jpg', category_id = 1, stock = 85, brand = 'AMD'
WHERE name LIKE '%5600X%';

-- AMD Ryzen 3 4100 (ID: 14)
UPDATE products 
SET name = 'AMD Ryzen 3 4100', price = 1800000, description = 'Budget 4 Cores, AM4', image = 'i9_14900k.jpg', category_id = 1, stock = 118, brand = 'AMD'
WHERE id = 14 OR name LIKE '%Ryzen 3 4100%';

-- AMD Ryzen 5 8600G (ID: 18)
UPDATE products 
SET name = 'AMD Ryzen 5 8600G', price = 6200000, description = 'AI Engine, Radeon 760M', image = 'i9_14900k.jpg', category_id = 1, stock = 35, brand = 'AMD'
WHERE id = 18 OR name LIKE '%8600G%';

-- AMD Ryzen 7 7700 (ID: 20)
UPDATE products 
SET name = 'AMD Ryzen 7 7700', price = 7800000, description = '8 Cores, Low Power 65W', image = 'i9_14900k.jpg', category_id = 1, stock = 28, brand = 'AMD'
WHERE id = 20 OR name LIKE '%Ryzen 7 7700%';

-- AMD Ryzen 5 4500 (ID: 22)
UPDATE products 
SET name = 'AMD Ryzen 5 4500', price = 1950000, description = 'Super Budget 6 Cores', image = 'i9_14900k.jpg', category_id = 1, stock = 94, brand = 'AMD'
WHERE id = 22 OR name LIKE '%Ryzen 5 4500%';

-- AMD Ryzen 5 3600 (ID: 24)
UPDATE products 
SET name = 'AMD Ryzen 5 3600', price = 2100000, description = 'Popular AM4 CPU', image = 'i9_14900k.jpg', category_id = 1, stock = 150, brand = 'AMD'
WHERE id = 24 OR name LIKE '%Ryzen 5 3600%';

-- AMD Ryzen 9 3900X (ID: 26)
UPDATE products 
SET name = 'AMD Ryzen 9 3900X', price = 7500000, description = '12 Cores, Workstation', image = 'i9_14900k.jpg', category_id = 1, stock = 8, brand = 'AMD'
WHERE id = 26 OR name LIKE '%3900X%';

-- AMD Athlon 3000G (ID: 28)
UPDATE products 
SET name = 'AMD Athlon 3000G', price = 1200000, description = 'Ultra Budget Graphics', image = 'i9_14900k.jpg', category_id = 1, stock = 180, brand = 'AMD'
WHERE id = 28 OR name LIKE '%Athlon 3000G%';

-- AMD Ryzen 7 8700G (ID: 30)
UPDATE products 
SET name = 'AMD Ryzen 7 8700G', price = 9200000, description = 'Powerful APU, Radeon 780M', image = 'i9_14900k.jpg', category_id = 1, stock = 33, brand = 'AMD'
WHERE id = 30 OR name LIKE '%8700G%';

PRINT '=====================================================';
PRINT 'ĐÃ HOÀN TẤT CẬP NHẬT (UPDATE) DỮ LIỆU CÁC SẢN PHẨM CPU!';
PRINT '=====================================================';
