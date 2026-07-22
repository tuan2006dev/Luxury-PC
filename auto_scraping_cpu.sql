-- ==========================================
-- SCRIPT AUTO SCRAPING (GEARVN -> LUXURY-PC)
-- ==========================================

INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at) 
VALUES (N'Unknown', 469000049900006, N'', '3-7ghz-boost-4-6ghz-6-nhan-12-luong-1_064ea02033974b0fae49158951cc74dd_b68071833a2a4ca797c7c330d6cf8412_master.png', 1, 10, 'Unknown', CURRENT_TIMESTAMP);
DECLARE @ProductId_0 INT = SCOPE_IDENTITY();
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, ram_type_supported, socket, tdp_max) 
VALUES (@ProductId_0, 1, 0, NULL, 'AM4', 65);

INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at) 
VALUES (N'Unknown', 269000028900007, N'', '20619238-a_ryzen5_sr1_3dpib_right_row_a5c9aa7c8c6642208ef8225f07fc38e0_fb65fa52e903447a9edf1a41eff5de10_master.png', 1, 10, 'Unknown', CURRENT_TIMESTAMP);
DECLARE @ProductId_1 INT = SCOPE_IDENTITY();
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, ram_type_supported, socket, tdp_max) 
VALUES (@ProductId_1, 1, 0, NULL, 'AM4', 65);

INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at) 
VALUES (N'Unknown', 15690000159900002, N'', '242872903-d_ryzen_7_9800x3d_3dpib_fl_2b5b9679b1b14fd2a89511a1dfd4511b_master.png', 1, 10, 'Unknown', CURRENT_TIMESTAMP);
DECLARE @ProductId_2 INT = SCOPE_IDENTITY();
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, ram_type_supported, socket, tdp_max) 
VALUES (@ProductId_2, 1, 0, NULL, 'AM5', 120);

INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at) 
VALUES (N'Unknown', 17990000184900003, N'', 'n36733-001-arl-i9k-univ_b4cd53ec34294ed9bea8be6f28991d91_master.png', 1, 10, 'Unknown', CURRENT_TIMESTAMP);
DECLARE @ProductId_3 INT = SCOPE_IDENTITY();
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, ram_type_supported, socket, tdp_max) 
VALUES (@ProductId_3, 1, 0, NULL, 'LGA 1851', 250);

INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at) 
VALUES (N'Unknown', 104900001249000016, N'', 'n43449-001-arl-7k-univ_4a4d7889cc5546f1912e6ab4ba40265e_master.png', 1, 10, 'Unknown', CURRENT_TIMESTAMP);
DECLARE @ProductId_4 INT = SCOPE_IDENTITY();
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, ram_type_supported, socket, tdp_max) 
VALUES (@ProductId_4, 1, 0, NULL, 'LGA 1851', 250);

