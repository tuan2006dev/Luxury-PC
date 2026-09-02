-- ============================================================================
-- LUXURY PC - DATABASE INITIALIZATION SCHEMA & SEED DATA
-- Database: SQL Server (LUXURYPC)
-- Standardized & Cleaned for Spring Boot 3 + Hibernate 6 Architecture
-- ============================================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'LUXURYPC')
BEGIN
    CREATE DATABASE LUXURYPC;
END
GO

USE LUXURYPC;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

-- --------------------------------------------------
-- 1. DROP ALL EXISTING FOREIGN KEYS DYNAMICALLY
-- --------------------------------------------------
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_NAME(parent_object_id)) + N' DROP CONSTRAINT ' + QUOTENAME(name) + N';' + CHAR(13) + CHAR(10)
FROM sys.foreign_keys;
IF @sql <> N''
    EXEC sp_executesql @sql;
GO

-- --------------------------------------------------
-- 2. CREATE CORE BUSINESS TABLES
-- --------------------------------------------------

-- Bảng Quyền hạn
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'roles') AND type IN ('U')) DROP TABLE roles;
GO
CREATE TABLE roles (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(255) NOT NULL UNIQUE
);
GO

-- Bảng Người dùng
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'users') AND type IN ('U')) DROP TABLE users;
GO
CREATE TABLE users (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    username NVARCHAR(255),
    email NVARCHAR(255) NOT NULL UNIQUE,
    password NVARCHAR(255) NULL,
    full_name NVARCHAR(255),
    phone NVARCHAR(255),
    address NVARCHAR(MAX),
    enabled BIT DEFAULT 1,
    auth_provider NVARCHAR(255) DEFAULT 'LOCAL',
    google_id NVARCHAR(255),
    facebook_id NVARCHAR(255),
    avatar NVARCHAR(255),
    birthday DATETIME2,
    gender BIT,
    status BIT DEFAULT 1,
    notify_flash_sale BIT DEFAULT 1,
    notify_new_products BIT DEFAULT 1,
    notify_order_updates BIT DEFAULT 1,
    notify_weekly_newsletter BIT DEFAULT 1,
    two_factor_enabled BIT DEFAULT 0,
    force_change_password BIT DEFAULT 0,
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME2
);
GO

-- Bảng Phân quyền Người dùng
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'user_roles') AND type IN ('U')) DROP TABLE user_roles;
GO
CREATE TABLE user_roles (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    CONSTRAINT UQ_user_roles UNIQUE (user_id, role_id)
);
GO

-- Bảng Quản lý Phiên đăng nhập (Session Management)
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'user_sessions') AND type IN ('U')) DROP TABLE user_sessions;
GO
CREATE TABLE user_sessions (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    session_id NVARCHAR(255) NOT NULL,
    user_agent NVARCHAR(500),
    device_info NVARCHAR(255),
    ip_address NVARCHAR(50),
    location NVARCHAR(100),
    login_time DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    last_activity DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    is_expired BIT DEFAULT 0
);
GO

-- Bảng Danh mục Sản phẩm
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'categories') AND type IN ('U')) DROP TABLE categories;
GO
CREATE TABLE categories (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    image NVARCHAR(500),
    display NVARCHAR(MAX),
    slug NVARCHAR(255)
);
GO

-- Bảng Thương hiệu
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'brands') AND type IN ('U')) DROP TABLE brands;
GO
CREATE TABLE brands (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    logo NVARCHAR(500) NOT NULL,
    link NVARCHAR(500),
    display_order INT DEFAULT 0
);
GO

-- Bảng Sản phẩm
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'products') AND type IN ('U')) DROP TABLE products;
GO
CREATE TABLE products (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(200) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    description NVARCHAR(MAX),
    image NVARCHAR(MAX),
    category_id INT,
    stock INT DEFAULT 0,
    brand NVARCHAR(100),
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Ảnh phụ Sản phẩm
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'product_images') AND type IN ('U')) DROP TABLE product_images;
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'product_image') AND type IN ('U')) DROP TABLE product_image;
GO
CREATE TABLE product_images (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    product_id INT NOT NULL,
    image_url NVARCHAR(MAX) NOT NULL,
    display_order INT DEFAULT 0
);
GO


-- Bảng Flash Sale
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'flash_sales') AND type IN ('U')) DROP TABLE flash_sales;
GO
CREATE TABLE flash_sales (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(255),
    start_time DATETIME2,
    end_time DATETIME2,
    active BIT DEFAULT 0,
    description NVARCHAR(500),
    max_per_user INT,
    banner_image NVARCHAR(500),
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Chi tiết Flash Sale
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'flash_sale_items') AND type IN ('U')) DROP TABLE flash_sale_items;
GO
CREATE TABLE flash_sale_items (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    flash_sale_id INT NOT NULL,
    product_id INT NOT NULL,
    sale_price DECIMAL(18,2) NOT NULL,
    sale_quantity INT NOT NULL,
    sold_count INT DEFAULT 0
);
GO

-- Bảng PC Combo lắp sẵn
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'pc_combos') AND type IN ('U')) DROP TABLE pc_combos;
GO
CREATE TABLE pc_combos (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(255),
    image NVARCHAR(255),
    price DECIMAL(18,2) NOT NULL,
    badge NVARCHAR(255),
    badge_color NVARCHAR(255)
);
GO

-- Bảng Chi tiết linh kiện PC Combo
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'pc_combo_details') AND type IN ('U')) DROP TABLE pc_combo_details;
GO
CREATE TABLE pc_combo_details (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    combo_id BIGINT NOT NULL,
    product_id INT NOT NULL,
    slot_type NVARCHAR(255)
);
GO

-- Bảng Build PC đã lưu
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'pc_builds') AND type IN ('U')) DROP TABLE pc_builds;
GO
CREATE TABLE pc_builds (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    total_price DECIMAL(18,2) DEFAULT 0,
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Chi tiết linh kiện Build PC
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'pc_build_items') AND type IN ('U')) DROP TABLE pc_build_items;
GO
CREATE TABLE pc_build_items (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    build_id INT NOT NULL,
    product_id INT NOT NULL
);
GO

-- Bảng Chia sẻ Cấu hình Build PC (Shared Builds)
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'shared_builds') AND type IN ('U')) DROP TABLE shared_builds;
GO
CREATE TABLE shared_builds (
    share_code NVARCHAR(15) NOT NULL PRIMARY KEY,
    name NVARCHAR(100) DEFAULT N'Cấu hình chia sẻ từ LuxuryPC',
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    cpu_id NVARCHAR(50),
    mainboard_id NVARCHAR(50),
    ram_id NVARCHAR(50),
    gpu_id NVARCHAR(50),
    storage_id NVARCHAR(50),
    psu_id NVARCHAR(50),
    case_id NVARCHAR(50),
    cooler_id NVARCHAR(50),
    total_price DECIMAL(18,2)
);
GO

-- Bảng Mã giảm giá Voucher
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'vouchers') AND type IN ('U')) DROP TABLE vouchers;
GO
CREATE TABLE vouchers (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code NVARCHAR(255) NOT NULL UNIQUE,
    description NVARCHAR(255),
    discount_type NVARCHAR(255),
    discount_value DECIMAL(18,2) NOT NULL,
    min_order_amount DECIMAL(18,2) DEFAULT 0,
    max_discount_amount DECIMAL(18,2),
    usage_limit INT,
    used_count INT DEFAULT 0,
    start_date DATETIME2,
    end_date DATETIME2,
    active BIT DEFAULT 1,
    category_id INT,
    voucher_scope NVARCHAR(255),
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Voucher của Người dùng
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'user_vouchers') AND type IN ('U')) DROP TABLE user_vouchers;
GO
CREATE TABLE user_vouchers (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    voucher_id INT NOT NULL,
    status NVARCHAR(255) DEFAULT 'AVAILABLE' NOT NULL,
    saved_at DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    used_at DATETIME2,
    reservation_expires_at DATETIME2
);
GO

-- Bảng Địa chỉ giao hàng
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'shipping_addresses') AND type IN ('U')) DROP TABLE shipping_addresses;
GO
CREATE TABLE shipping_addresses (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    recipient_name NVARCHAR(255) NOT NULL,
    phone NVARCHAR(255) NOT NULL,
    address NVARCHAR(500) NOT NULL,
    city NVARCHAR(120),
    district NVARCHAR(120),
    is_default BIT DEFAULT 0 NOT NULL
);
GO

-- Bảng Đơn hàng
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'orders') AND type IN ('U')) DROP TABLE orders;
GO
CREATE TABLE orders (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    user_id INT,
    order_code NVARCHAR(255),
    full_name NVARCHAR(255),
    email NVARCHAR(255),
    phone NVARCHAR(255),
    address NVARCHAR(MAX),
    city NVARCHAR(255),
    total_price DECIMAL(18,2) NOT NULL,
    discount_amount DECIMAL(18,2) DEFAULT 0,
    voucher_code NVARCHAR(255),
    vip_discount DECIMAL(18,2) DEFAULT 0,
    freeship_voucher_code NVARCHAR(255),
    freeship_discount DECIMAL(18,2) DEFAULT 0,
    shipping_fee DECIMAL(18,2) DEFAULT 0,
    shipping_method_name NVARCHAR(255),
    tracking_code NVARCHAR(255),
    status NVARCHAR(50),
    payment_method NVARCHAR(255),
    admin_note NVARCHAR(MAX),
    installment_bank NVARCHAR(255),
    installment_fee DECIMAL(18,2) DEFAULT 0,
    installment_term INT,
    refund_previous_status NVARCHAR(255),
    refund_reason NVARCHAR(MAX),
    stock_deducted BIT DEFAULT 0,
    stock_restored BIT DEFAULT 0,
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Chi tiết Đơn hàng
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'order_items') AND type IN ('U')) DROP TABLE order_items;
GO
CREATE TABLE order_items (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(18,2) NOT NULL
);
GO

-- Bảng Giỏ hàng
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'carts') AND type IN ('U')) DROP TABLE carts;
GO
CREATE TABLE carts (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Chi tiết Giỏ hàng
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'cart_items') AND type IN ('U')) DROP TABLE cart_items;
GO
CREATE TABLE cart_items (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1 NOT NULL
);
GO

-- Bảng Bình luận Sản phẩm (Comments)
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'comments') AND type IN ('U')) DROP TABLE comments;
GO
CREATE TABLE comments (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    parent_id INT,
    status NVARCHAR(20) DEFAULT 'APPROVED',
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Phản hồi Bình luận
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'comment_replies') AND type IN ('U')) DROP TABLE comment_replies;
GO
CREATE TABLE comment_replies (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    comment_id INT NOT NULL,
    user_id INT NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    status NVARCHAR(20) DEFAULT 'APPROVED',
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Đánh giá Sản phẩm (Reviews)
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'reviews') AND type IN ('U')) DROP TABLE reviews;
GO
CREATE TABLE reviews (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    user_id INT,
    product_id INT,
    order_id INT,
    order_item_id INT,
    stars INT,
    title NVARCHAR(255),
    content NVARCHAR(MAX),
    image NVARCHAR(MAX),
    video NVARCHAR(MAX),
    reply_content NVARCHAR(2000),
    replied_at DATETIME2,
    replied_by NVARCHAR(255),
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Danh sách Yêu thích (Wishlist)
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'wishlist_items') AND type IN ('U')) DROP TABLE wishlist_items;
GO
CREATE TABLE wishlist_items (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP NOT NULL
);
GO

-- Bảng Kho hàng (Inventory)
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'inventory') AND type IN ('U')) DROP TABLE inventory;
GO
CREATE TABLE inventory (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    product_id INT NOT NULL UNIQUE,
    quantity INT DEFAULT 0 NOT NULL,
    last_update DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Biến động kho hàng
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'stock_movements') AND type IN ('U')) DROP TABLE stock_movements;
GO
CREATE TABLE stock_movements (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    product_id INT NOT NULL,
    change_quantity INT NOT NULL,
    movement_type NVARCHAR(255),
    note NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Danh mục Tin tức
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'news_categories') AND type IN ('U')) DROP TABLE news_categories;
GO
CREATE TABLE news_categories (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    slug NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    status NVARCHAR(20) DEFAULT 'ACTIVE' NOT NULL,
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Bài viết Tin tức
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'news') AND type IN ('U')) DROP TABLE news;
GO
CREATE TABLE news (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    slug NVARCHAR(255) NOT NULL,
    summary NVARCHAR(MAX),
    content NVARCHAR(MAX),
    thumbnail NVARCHAR(255),
    author_id INT NOT NULL,
    category_id INT,
    status NVARCHAR(20) DEFAULT 'ACTIVE',
    meta_title NVARCHAR(255),
    meta_description NVARCHAR(MAX),
    meta_keywords NVARCHAR(255),
    view_count BIGINT DEFAULT 0,
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Hỗ trợ Khách hàng (Support Tickets)
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'support_tickets') AND type IN ('U')) DROP TABLE support_tickets;
GO
CREATE TABLE support_tickets (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    user_id INT,
    customer_name NVARCHAR(255),
    customer_email NVARCHAR(255),
    customer_phone NVARCHAR(255),
    subject NVARCHAR(1000),
    category NVARCHAR(255),
    message NVARCHAR(MAX),
    admin_reply NVARCHAR(MAX),
    assigned_admin NVARCHAR(255),
    build_config NVARCHAR(MAX),
    status NVARCHAR(255) DEFAULT 'OPEN',
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Tickets (Phục vụ realtime & cleanup)
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'tickets') AND type IN ('U')) DROP TABLE tickets;
GO
CREATE TABLE tickets (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    customer_name NVARCHAR(255) NOT NULL,
    customer_email NVARCHAR(255),
    customer_phone NVARCHAR(255),
    subject NVARCHAR(255) NOT NULL,
    category NVARCHAR(255),
    message NVARCHAR(MAX),
    assigned_admin NVARCHAR(255),
    build_config NVARCHAR(MAX),
    status NVARCHAR(255) DEFAULT 'OPEN',
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Tin nhắn trong Ticket
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'ticket_messages') AND type IN ('U')) DROP TABLE ticket_messages;
GO
CREATE TABLE ticket_messages (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ticket_id INT NOT NULL,
    sender NVARCHAR(255) NOT NULL,
    sender_name NVARCHAR(255),
    message NVARCHAR(MAX) NOT NULL,
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Tin nhắn Live Chat
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'chat_messages') AND type IN ('U')) DROP TABLE chat_messages;
GO
CREATE TABLE chat_messages (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ticket_id INT,
    sender NVARCHAR(255),
    sender_name NVARCHAR(255),
    message NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- Bảng Đặt lại Mật khẩu
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'password_resets') AND type IN ('U')) DROP TABLE password_resets;
GO
CREATE TABLE password_resets (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    email NVARCHAR(100) NOT NULL,
    token NVARCHAR(255) NOT NULL,
    expiry DATETIME2 NOT NULL
);
GO

-- Bảng Giao dịch Thanh toán SePay
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'sepay_transactions') AND type IN ('U')) DROP TABLE sepay_transactions;
GO
CREATE TABLE sepay_transactions (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    sepay_transaction_id BIGINT,
    order_code NVARCHAR(100),
    payment_code NVARCHAR(100),
    account_number NVARCHAR(100),
    transfer_amount DECIMAL(18,2),
    transfer_type NVARCHAR(100),
    processing_status NVARCHAR(100),
    raw_payload NVARCHAR(MAX),
    received_at DATETIME2,
    processed_at DATETIME2
);
GO

-- Bảng Thông số Kỹ thuật Linh kiện (Chuẩn hóa duy nhất 8 bảng *_specs)
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'case_specs') AND type IN ('U')) DROP TABLE case_specs;
CREATE TABLE case_specs (product_id INT NOT NULL PRIMARY KEY, max_cpu_cooler_height_mm INT, max_gpu_length_mm INT, motherboard_support NVARCHAR(255));

IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'cpu_specs') AND type IN ('U')) DROP TABLE cpu_specs;
CREATE TABLE cpu_specs (product_id INT NOT NULL PRIMARY KEY, socket NVARCHAR(255), tdp_max INT, ram_type_supported NVARCHAR(255), has_igpu BIT, includes_stock_cooler BIT);

IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'cooler_specs') AND type IN ('U')) DROP TABLE cooler_specs;
CREATE TABLE cooler_specs (product_id INT NOT NULL PRIMARY KEY, cooler_type NVARCHAR(255), height_mm INT, tdp_rating_watt INT);

IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'gpu_specs') AND type IN ('U')) DROP TABLE gpu_specs;
CREATE TABLE gpu_specs (product_id INT NOT NULL PRIMARY KEY, length_mm INT, thickness_mm INT, power_consumption_tdp INT, pcie8pin_required INT, pcie12vhpwr_required INT);

IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'mainboard_specs') AND type IN ('U')) DROP TABLE mainboard_specs;
CREATE TABLE mainboard_specs (product_id INT NOT NULL PRIMARY KEY, socket NVARCHAR(255), form_factor NVARCHAR(255), ram_type NVARCHAR(255), ram_slots INT, cpu_power_connectors INT);

IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'psu_specs') AND type IN ('U')) DROP TABLE psu_specs;
CREATE TABLE psu_specs (product_id INT NOT NULL PRIMARY KEY, wattage INT, length_mm INT, pcie8pin_connectors INT, cpu8pin_connectors INT);

IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'ram_specs') AND type IN ('U')) DROP TABLE ram_specs;
CREATE TABLE ram_specs (product_id INT NOT NULL PRIMARY KEY, ddr_type NVARCHAR(255), capacity_total INT, module_count INT);

IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'storage_specs') AND type IN ('U')) DROP TABLE storage_specs;
CREATE TABLE storage_specs (product_id INT NOT NULL PRIMARY KEY, form_factor NVARCHAR(255), interface_type NVARCHAR(255));
GO

-- --------------------------------------------------
-- 3. RELATIONSHIPS & FOREIGN KEYS
-- --------------------------------------------------

ALTER TABLE user_roles ADD CONSTRAINT FK_user_roles_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;
ALTER TABLE user_roles ADD CONSTRAINT FK_user_roles_roles FOREIGN KEY (role_id) REFERENCES roles (id);

ALTER TABLE user_sessions ADD CONSTRAINT FK_user_sessions_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

ALTER TABLE products ADD CONSTRAINT FK_products_categories FOREIGN KEY (category_id) REFERENCES categories (id);
ALTER TABLE product_images ADD CONSTRAINT FK_product_images_products FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE;

ALTER TABLE flash_sale_items ADD CONSTRAINT FK_flash_sale_items_flash_sales FOREIGN KEY (flash_sale_id) REFERENCES flash_sales (id) ON DELETE CASCADE;
ALTER TABLE flash_sale_items ADD CONSTRAINT FK_flash_sale_items_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE pc_combo_details ADD CONSTRAINT FK_pc_combo_details_pc_combos FOREIGN KEY (combo_id) REFERENCES pc_combos (id) ON DELETE CASCADE;
ALTER TABLE pc_combo_details ADD CONSTRAINT FK_pc_combo_details_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE pc_build_items ADD CONSTRAINT FK_pc_build_items_pc_builds FOREIGN KEY (build_id) REFERENCES pc_builds (id) ON DELETE CASCADE;
ALTER TABLE pc_build_items ADD CONSTRAINT FK_pc_build_items_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE vouchers ADD CONSTRAINT FK_vouchers_categories FOREIGN KEY (category_id) REFERENCES categories (id);

ALTER TABLE user_vouchers ADD CONSTRAINT FK_user_vouchers_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;
ALTER TABLE user_vouchers ADD CONSTRAINT FK_user_vouchers_vouchers FOREIGN KEY (voucher_id) REFERENCES vouchers (id);

ALTER TABLE shipping_addresses ADD CONSTRAINT FK_shipping_addresses_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

ALTER TABLE orders ADD CONSTRAINT FK_orders_users FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE order_items ADD CONSTRAINT FK_order_items_orders FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE;
ALTER TABLE order_items ADD CONSTRAINT FK_order_items_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE cart_items ADD CONSTRAINT FK_cart_items_carts FOREIGN KEY (cart_id) REFERENCES carts (id) ON DELETE CASCADE;
ALTER TABLE cart_items ADD CONSTRAINT FK_cart_items_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE reviews ADD CONSTRAINT FK_reviews_users FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE reviews ADD CONSTRAINT FK_reviews_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE wishlist_items ADD CONSTRAINT FK_wishlist_items_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;
ALTER TABLE wishlist_items ADD CONSTRAINT FK_wishlist_items_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE inventory ADD CONSTRAINT FK_inventory_products FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE;

ALTER TABLE stock_movements ADD CONSTRAINT FK_stock_movements_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE news ADD CONSTRAINT FK_news_users FOREIGN KEY (author_id) REFERENCES users (id);
ALTER TABLE news ADD CONSTRAINT FK_news_news_categories FOREIGN KEY (category_id) REFERENCES news_categories (id);

ALTER TABLE support_tickets ADD CONSTRAINT FK_support_tickets_users FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE ticket_messages ADD CONSTRAINT FK_ticket_messages_tickets FOREIGN KEY (ticket_id) REFERENCES tickets (id) ON DELETE CASCADE;

ALTER TABLE case_specs ADD CONSTRAINT FK_case_specs_products FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE;
ALTER TABLE cpu_specs ADD CONSTRAINT FK_cpu_specs_products FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE;
ALTER TABLE cooler_specs ADD CONSTRAINT FK_cooler_specs_products FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE;
ALTER TABLE gpu_specs ADD CONSTRAINT FK_gpu_specs_products FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE;
ALTER TABLE mainboard_specs ADD CONSTRAINT FK_mainboard_specs_products FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE;
ALTER TABLE psu_specs ADD CONSTRAINT FK_psu_specs_products FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE;
ALTER TABLE ram_specs ADD CONSTRAINT FK_ram_specs_products FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE;
ALTER TABLE storage_specs ADD CONSTRAINT FK_storage_specs_products FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE;
GO

-- --------------------------------------------------
-- 4. BASE ROLES SEED DATA
-- --------------------------------------------------
SET IDENTITY_INSERT roles ON;
INSERT INTO roles (id, name) VALUES
(1, 'ADMIN'),
(2, 'USER'),
(3, 'STAFF');
SET IDENTITY_INSERT roles OFF;
DBCC CHECKIDENT ('roles', RESEED, 3);
GO

-- --------------------------------------------------
-- 5. BASE CATEGORIES SEED DATA
-- --------------------------------------------------
SET IDENTITY_INSERT categories ON;
INSERT INTO categories (id, name, image, display, slug) VALUES
(1, 'CPU', '/images/ui-new/CPU.png', NULL, 'cpu'),
(2, 'GPU', '/images/ui-new/GPU.png', NULL, 'gpu'),
(3, 'RAM', '/images/ui-new/RAM.png', NULL, 'ram'),
(4, 'ROM', '/images/ui-new/ROM.png', NULL, 'rom'),
(5, 'Mainboard', '/images/ui-new/Mainboard.png', NULL, 'mainboard'),
(6, 'SSD', '/images/ui-new/SSD.png', NULL, 'ssd'),
(7, N'Màn hình', N'/images/ui-new/Màn hình.png', NULL, 'man-hinh'),
(8, 'Storage', '/images/ui-new/Storage.png', NULL, 'storage'),
(9, 'Cooling', '/images/ui-new/Cooling.png', NULL, 'cooling'),
(10, 'VGA', '/images/ui-new/GPU.png', NULL, 'vga'),
(11, 'HDD', '/images/ui-new/HDD.png', NULL, 'hdd'),
(12, 'PSU', '/images/ui-new/PSU.png', NULL, 'psu'),
(13, 'Case', '/images/ui-new/Case.png', NULL, 'case'),
(14, 'CPU Cooler', '/images/ui-new/CPU Cooler.png', NULL, 'cpu-cooler'),
(15, 'Case Fan', '/images/ui-new/Case Fan.png', NULL, 'case-fan'),
(16, 'Keyboard', '/images/ui-new/Keyboard.png', NULL, 'keyboard'),
(17, 'Mouse', '/images/ui-new/Mouse.png', NULL, 'mouse'),
(18, 'Headset', '/images/ui-new/Headset.png', NULL, 'headset');
SET IDENTITY_INSERT categories OFF;
DBCC CHECKIDENT ('categories', RESEED, 18);
GO

-- --------------------------------------------------
-- 6. BASE NEWS CATEGORIES SEED DATA
-- --------------------------------------------------
SET IDENTITY_INSERT news_categories ON;
INSERT INTO news_categories (id, name, slug, description, status) VALUES 
(1, N'Tin Tức', 'tin-tuc', N'Tin tức công nghệ và sự kiện nổi bật', 'ACTIVE'),
(2, N'Hướng dẫn Build PC', 'huong-dan-build-pc', N'Các bài viết hướng dẫn chọn linh kiện và lắp ráp PC', 'ACTIVE'),
(3, N'Tư vấn chọn mua', 'tu-van-chon-mua', N'Gợi ý cấu hình tối ưu theo ngân sách', 'ACTIVE'),
(4, N'Mẹo & Thủ thuật', 'meo-thu-thuat', N'Tối ưu hiệu năng, overclock và chăm sóc PC', 'ACTIVE'),
(5, N'Review Sản phẩm', 'review-san-pham', N'Đánh giá chi tiết linh kiện phần cứng', 'ACTIVE');
SET IDENTITY_INSERT news_categories OFF;
DBCC CHECKIDENT ('news_categories', RESEED, 5);
GO

-- ----------------------------------------------------------------------------
-- 6.1 BASE BRANDS SEED DATA
-- ----------------------------------------------------------------------------
SET IDENTITY_INSERT brands ON;
INSERT INTO brands (id, name, logo, link, display_order)
VALUES
(1, N'Intel', N'/images/ui-new/intel.svg', N'/products?brand=Intel', 1),
(2, N'AMD', N'/images/ui-new/amd.svg', N'/products?brand=AMD', 2),
(3, N'ASUS', N'/images/ui-new/asus.svg', N'/products?brand=ASUS', 3),
(4, N'MSI', N'/images/ui-new/msi.svg', N'/products?brand=MSI', 4),
(5, N'GIGABYTE', N'/images/ui-new/gigabyte.svg', N'/products?brand=GIGABYTE', 5),
(6, N'Corsair', N'/images/ui-new/corsair.svg', N'/products?brand=Corsair', 6),
(7, N'Kingston', N'/images/ui-new/kingston.svg', N'/products?brand=Kingston', 7),
(8, N'Cooler Master', N'/images/ui-new/coolermaster.svg', N'/products?brand=Cooler Master', 8);
SET IDENTITY_INSERT brands OFF;
DBCC CHECKIDENT ('brands', RESEED, 20);
GO


-- ----------------------------------------------------------------------------
-- 6.2 BASE PRODUCTS SEED DATA (542 LINH KIỆN & PHẦN CỨNG CHUẨN)
-- ----------------------------------------------------------------------------
SET IDENTITY_INSERT products ON;
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES
(1, 'Intel Core i9-14900K', 15500000, N'TDP: 125W | 24 Cores, up to 6.0GHz, LGA 1700', 'i9_14900k.jpg', 1, 46, '2026-04-06 13:46:29.076393', N'Intel'),
(2, 'AMD Ryzen 9 7950X3D', 17200000, N'TDP: 170W | 16 Cores, 128MB L3 Cache, AM5', 'i9_14900k.jpg', 1, 15, NULL, N'AMD'),
(3, 'Intel Core i7-14700Kkk', 10800000, N'TDP: 125W | 20 Cores, Hybrid Architecture', N'https://himmcom.com.np/wp-content/uploads/2024/01/1-3.jpg%20?%3E', 1, 0, NULL, N'Intel'),
(4, 'AMD Ryzen 7 7800X3D', 11500000, N'TDP: 120W | Best gaming CPU, 8 Cores, 3D V-Cache', N'https://www.amd.com/content/dam/amd/en/images/products/processors/ryzen/2505503-ryzen-7-7800x3d.jpg', 1, 27, '2026-04-06 13:46:29.076393', N'AMD'),
(5, 'Intel Core i5-13600K', 8200000, N'TDP: 125W | 14 Cores, Mid-range gaming', N'https://www.notebookcheck.net/fileadmin/Notebooks/Sonstiges/Intel/Raptor_Lake_S/Raptor_Lake_7.jpg', 1, 54, '2026-04-06 13:46:29.076393', N'Intel'),
(6, 'AMD Ryzen 5 7600X', 5800000, N'TDP: 65W | 6 Cores, Zen 4 Architecture, AM5', N'https://static01.galaxus.com/productimages/8/6/2/2/3/5/8/5/2/5/8/0/4/8/2/7/4/9/6/a215fe82-81fe-4ec0-a941-8dfab4312068_cropped.png_720.jpeg', 1, 59, '2026-04-06 13:46:29.076393', N'AMD'),
(7, 'Intel Core i9-13900KS', 18500000, N'TDP: 125W | Special Edition, 6.0GHz', N'https://tpucdn.com/cpu-specs/images/chips/2956-front.jpg', 1, 0, '2026-04-06 13:46:29.076393', N'Intel'),
(8, 'AMD Ryzen 9 7900X', 10500000, N'TDP: 170W | 12 Cores, 5.6GHz Boost', N'https://www.notebookcheck.net/uploads/tx_nbc2/R9_7900_9.jpg', 1, 18, '2026-04-06 13:46:29.076393', N'AMD'),
(9, 'Intel Core i7-13700F', 8900000, N'TDP: 65W | 16 Cores, No Integrated Graphics', N'https://microless.com/cdn/products/08f5cf4e0f9b43cecfee68f4a554f23c-hi.jpg', 1, 45, '2026-04-06 13:46:29.076393', N'Intel'),
(10, 'AMD Ryzen 7 5800X3D', 8500000, N'TDP: 120W | Legendary AM4 gaming CPU', N'https://www.techpowerup.com/review/amd-ryzen-7-5800x3d-10th-anniversary/images/title.jpg', 1, 25, '2026-04-06 13:46:29.076393', N'AMD'),
(11, 'Intel Core i5-12400F', 3500000, N'TDP: 65W | Budget King, 6 Cores', N'https://atcsjo.com/public/uploads/all/PZ7Ofk2PcEE8TNoZi0QSSfpF5x5tI84fcjFIBiLt.jpg', 1, 96, '2026-04-06 13:46:29.076393', N'Intel'),
(12, 'AMD Ryzen 5 5600G', 3200000, N'TDP: 65W | Integrated Vega Graphics', N'https://networkitstore.in/wp-content/uploads/2024/01/amd-ryzen-5600g-600x600.webp', 1, 71, '2026-04-06 13:46:29.076393', N'AMD'),
(13, 'Intel Core i3-14100', 3800000, N'TDP: 65W | Entry level 14th Gen', N'https://cputronic.com/storage/images/big/intel-core-i3.webp', 1, 37, '2026-04-06 13:46:29.076393', N'Intel'),
(14, 'AMD Ryzen 3 4100', 1800000, N'TDP: 65W | Budget 4 Cores, AM4', N'https://images.tcdn.com.br/img/img_prod/591628/processador_amd_ryzen_3_4100_3_8ghz_4_0ghz_boost_zen_2_cache_6mb_am4_sem_video_integrado_34011_1_5b401d307e263fa3ee2586f9b4006a80.jpg', 1, 118, '2026-04-06 13:46:29.076393', N'AMD'),
(15, 'Intel Core i9-12900K', 9500000, N'TDP: 125W | 16 Cores, Previous Flagship', N'https://www.pcworld.com/wp-content/uploads/2021/11/12th_Gen_Core_i9_12900K_Hero_Close_Up-4.jpg?resize=1536%2C1024&quality=50&strip=all', 1, 13, '2026-04-06 13:46:29.076393', N'Intel'),
(16, N'Vỏ máy tính Xigmatek QUANTUM 4AF', 800000, N'TDP: 0W', N'http://cdn.hstatic.net/products/200000722513/gearvn-vo-may-tinh-xigmatek-quantum-4af-1_c9db476a42ef48fba6d84a9703a94945_grande.jpg', 12, 100, '2026-06-27 12:22:45.418', N'Xigmatek'),
(17, 'Intel Core i5-14400F', 5600000, N'TDP: 65W | 10 Cores, Efficient Gaming', N'https://microless.com/cdn/products/30c01bcc173314e1a756151858871162-hi.jpg', 1, 64, '2026-04-06 13:46:29.076393', N'Intel'),
(18, 'AMD Ryzen 5 8600G', 6200000, N'TDP: 65W | AI Engine, Radeon 760M', N'https://www.bhphotovideo.com/images/images2500x2500/amd_100_100001237box_ryzen_5_8600g_wraith_1804827.jpg', 1, 34, '2026-04-06 13:46:29.076393', N'AMD'),
(19, 'Intel Core i7-12700K', 7200000, N'TDP: 125W | 12 Cores, LGA 1700', N'https://product.hstatic.net/200000680839/product/hz__25mb__12_cores_20_threads__0703223b7ae44a9ca2dd97b79516fa6f_master_de0749de4f2f4df687f7940d2cd121d9_1024x1024.jpg', 1, 34, '2026-04-06 13:46:29.076393', N'Intel'),
(20, 'AMD Ryzen 7 7700', 7800000, N'TDP: 65W | 8 Cores, Low Power 65W', N'https://www.ryans.com/storage/products/main/amd-ryzen-7-7700-38ghz-53ghz-8-core-40mb-cache-11696328242.webp', 1, 28, '2026-04-06 13:46:29.076393', N'AMD'),
(21, 'Intel Core i5-11400F', 2800000, N'TDP: 65W | Old Gen Budget King', N'https://www.techpowerup.com/cpu-specs/images/chips/2407-front.jpg', 1, 50, '2026-04-06 13:46:29.076393', N'Intel'),
(22, 'AMD Ryzen 5 4500', 1950000, N'TDP: 65W | Super Budget 6 Cores', N'https://lanoc.org/images/reviews/2022/amd_ryzen_5_4500/image_2.jpg', 1, 92, '2026-04-06 13:46:29.076393', N'AMD'),
(23, 'Intel Core i9-11900K', 6500000, N'TDP: 125W | Legacy Flagship LGA 1200', N'https://www.notebookcheck.com/fileadmin/Notebooks/Sonstiges/Intel/Rocket_Lake_S/Rocket_Lake_S_6.jpg', 1, 9, '2026-04-06 13:46:29.076393', N'Intel'),
(24, 'AMD Ryzen 5 3600', 2100000, N'TDP: 65W | Popular AM4 CPU', N'https://www.techspot.com/images/products/2019/processors/amd/org/2019-07-25-product-6.jpg', 1, 150, '2026-04-06 13:46:29.076393', N'AMD'),
(25, 'Intel Core i5-10400F', 2200000, N'TDP: 65W | Stable and Cheap', N'https://tpucdn.com/cpu-specs/images/chips/2270-front.jpg', 1, 110, '2026-04-06 13:46:29.076393', N'Intel'),
(26, 'AMD Ryzen 9 3900X', 7500000, N'TDP: 105W | 12 Cores, Workstation', N'https://res.cloudinary.com/jawa/image/upload/f_auto,ar_1:1,c_fill,w_3840,q_auto/production/listings/gdo47zchozcdcelniqzd', 1, 8, '2026-04-06 13:46:29.076393', N'AMD'),
(27, 'Intel Pentium G7400', 1900000, N'TDP: 65W | Office work, 2 Cores', N'https://image.made-in-china.com/2f0j00HPzqpKeCABkW/for-Original-Best-Price-Intel-Pentium-Gold-G7400-Processor-3-70GHz-CPU-Alder-Lake-SRL66-LGA-1700-Processor-for-Desktop.jpg', 1, 200, '2026-04-06 13:46:29.076393', N'Intel'),
(28, 'AMD Athlon 3000G', 1200000, N'TDP: 65W | Ultra Budget Graphics', N'https://m.media-amazon.com/images/I/51wiBVz7jaL._AC_SL1000_.jpg', 1, 180, '2026-04-06 13:46:29.076393', N'AMD'),
(29, 'Intel Core i7-10700K', 4800000, N'TDP: 65W | High Clock Legacy', N'https://cdn.mos.cms.futurecdn.net/2WTyhwkcYo5b43PuCQYkzU.jpg', 1, 20, '2026-04-06 13:46:29.076393', N'Intel'),
(30, 'AMD Ryzen 7 8700G', 9200000, N'TDP: 65W | Powerful APU, Radeon 780M', N'https://m.media-amazon.com/images/I/61nRX0W6fhL._AC_SL1500_.jpg', 1, 33, '2026-04-06 13:46:29.076393', N'AMD'),
(31, 'NVIDIA RTX 4090 24GB', 55000000, N'TDP: 450W | Ultimate Gaming GPU', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6522/6522679_sd.jpg', 2, 10, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(32, 'RTX 4080 Super', 32000000, N'TDP: 320W | High-end 4K Gaming', N'https://www.picclickimg.com/YyIAAeSwtxVqdEgW/NVIDIA-GeForce-RTX-4080-Super-32GB-2SLOT-Turbo.webp', 2, 15, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(33, 'RTX 4070 Ti Super', 24500000, N'TDP: 285W | Perfect for 2K Gaming', N'https://hardwarerk.com/img/products/gpu-rtx-4070-ti-super.jpg', 2, 25, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(34, 'AMD RX 7900 XTX', 28500000, N'TDP: 320W | AMD Flagship, 24GB', N'https://m.media-amazon.com/images/I/81il2WdPPJL._AC_.jpg', 2, 12, '2026-04-06 13:46:29.076393', N'AMD'),
(35, 'RTX 4060 Ti 8GB', 11500000, N'TDP: 160W | Efficient 1080p/2K', N'https://img.terabyteshop.com.br/produto/g/placa-de-video-msi-nvidia-geforce-rtx-4060-ti-gaming-x-8gb-gddr6-dlss-ray-tracing-912-v515-022_170920.jpg', 2, 43, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(36, 'AMD RX 7800 XT', 15200000, N'TDP: 220W | Best value 2K GPU', N'https://fpsbench.com/static/images/game_images/16_9/fortnite.webp', 2, 30, '2026-04-06 13:46:29.076393', N'AMD'),
(37, 'RTX 3060 12GB', 7800000, N'TDP: 115W | Popular Mid-range', N'https://m.media-amazon.com/images/I/61XAtpgr1lL._AC_.jpg', 2, 80, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(38, 'AMD RX 6600', 5500000, N'TDP: 75W | Best budget 1080p', N'https://m.media-amazon.com/images/I/81Ts3uaZqgL._AC_.jpg', 2, 100, '2026-04-06 13:46:29.076393', N'AMD'),
(39, 'ASUS ROG RTX 4090', 62000000, N'TDP: 450W | Premium build cooling', N'https://media.ldlc.com/r1600/ld/products/00/06/12/43/LD0006124357.jpg', 2, 5, '2026-04-06 13:46:29.076393', N'ASUS'),
(40, 'MSI Gaming X RTX 4070', 18500000, N'TDP: 200W | Quiet and Cool', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6539/6539607cv17d.jpg', 2, 20, '2026-04-06 13:46:29.076393', N'MSI'),
(41, 'Gigabyte Eagle RTX 4060', 8200000, N'TDP: 115W | Triple Fan Budget', N'https://m.media-amazon.com/images/I/71g2Lc8urJL._AC_SL1500_.jpg', 2, 60, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(42, 'RTX 4070 Super', 17800000, N'TDP: 220W | 12GB GDDR6X, Fast', N'https://hardwarerk.com/img/products/gpu-rtx-4070-ti-super.jpg', 2, 35, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(43, 'AMD RX 7600', 7900000, N'TDP: 65W | Budget RDNA 3', N'https://m.media-amazon.com/images/I/81QItJufypL._AC_.jpg', 2, 50, '2026-04-06 13:46:29.076393', N'AMD'),
(44, 'RTX 3050 6GB', 5200000, N'TDP: 75W | Entry level RTX', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/d2e9569c-e820-41de-9d8b-c3d26b98ac87.jpg', 2, 70, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(45, 'Zotac RTX 4060', 7800000, N'TDP: 115W | Compact dual fan', N'https://m.media-amazon.com/images/I/81w-5i9+nbL.jpg', 2, 40, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(46, 'Galax RTX 4070 Pink', 16900000, N'TDP: 200W | Pink Edition RGB', N'https://www.gaming.gen.tr/cdn-cgi/image/quality=90,gravity=auto,sharpen=1,metadata=none,format=auto,onerror=redirect/wp-content/uploads/2023/10/galax-ex-gamer-pink-1-click-oc-geforce-rtx-4070-12gb-gddr6x-192-bit-ekran-karti-47nom7md7lpk-12.jpg', 2, 15, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(47, 'ASUS TUF RTX 3070 Ti', 12000000, N'TDP: 285W | Rugged build quality', N'https://m.media-amazon.com/images/I/81t7Ga7nyxS._AC_.jpg', 2, 10, '2026-04-06 13:46:29.076393', N'ASUS'),
(48, 'EVGA RTX 3080', 15000000, N'TDP: 320W | High performance legacy', N'https://m.media-amazon.com/images/I/81sXFTXt5CS.jpg', 2, 5, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(49, 'Sapphire RX 7900 GRE', 16500000, N'TDP: 220W | Golden Rabbit Edition', N'https://cdn.wccftech.com/wp-content/uploads/2023/07/AMD-Radeon-RX-7900-GRE-16-GB-GPU-Sapphire-Nitro-_5-g-standard-scale-4_00x-g-standard-scale-4_00x-Custom-1456x772.jpeg', 2, 18, '2026-04-06 13:46:29.076393', N'Sapphire'),
(50, 'PowerColor RX 7800 XT', 14800000, N'TDP: 220W | Excellent cooling', N'https://files.pccasegear.com/images/1693535888-RX7800XT-16G-E-OC-thb.jpg', 2, 22, '2026-04-06 13:46:29.076393', N'PowerColor'),
(51, 'GTX 1650', 3800000, N'TDP: 75W | No external power', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6347/6347252_sd.jpg', 2, 150, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(52, 'RX 6700 XT', 9500000, N'TDP: 115W | Great 1440p value', N'https://media.ldlc.com/r1600/ld/products/00/05/80/29/LD0005802927_1.jpg', 2, 40, '2026-04-06 13:46:29.076393', N'AMD'),
(53, 'Colorful RTX 4080', 31000000, N'TDP: 320W | LCD screen on GPU', N'https://static.tweaktown.com/news/8/8/88259_03_colorful-igame-geforce-rtx-4080-ultra-oc-spotted-oh-man-here-we-go_full.png', 2, 8, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(54, 'Quadro RTX A4000', 22000000, N'TDP: 140W | Workstation GPU', N'https://images.wiautomation.com/public/images/landing/anticipa/product/27_06_2024_11_39_54_RTX_A4000_Nvidia.jpg', 2, 0, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(55, 'Radeon Pro W7800', 58000000, N'TDP: 140W | Professional Graphics', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3773/innergigabyte/images/kft.png', 2, 3, '2026-04-06 13:46:29.076393', N'AMD'),
(56, 'Intel Arc A770 16GB', 9200000, N'TDP: 225W | Intel High-end GPU', N'https://pg.asrock.com/Graphics-Card/photo/Intel%20Arc%20A770%20Phantom%20Gaming%2016GB%20OC(L1).png', 2, 25, '2026-04-06 13:46:29.076393', N'Intel'),
(57, 'Intel Arc A750', 6500000, N'TDP: 225W | Budget King Intel', N'https://m.media-amazon.com/images/I/71sO2CZL1UL.jpg', 2, 40, '2026-04-06 13:46:29.076393', N'Intel'),
(58, 'ASUS Dual RTX 4070', 17500000, N'TDP: 200W | Clean white build', N'https://media.ldlc.com/r1600/ld/products/00/06/03/60/LD0006036039.jpg', 2, 15, '2026-04-06 13:46:29.076393', N'ASUS'),
(59, 'Gigabyte RTX 4090', 59000000, N'TDP: 450W | Massive cooler', N'https://www.pricerunner.com/product/3013080735/Gigabyte-GeForce-RTX-4090-WINDFORCE-V2-3xDP-HDMI-24GB.jpg', 2, 4, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(60, 'PNY RTX 4060', 7500000, N'TDP: 115W | Small and efficient', N'https://i5.walmartimages.com/asr/7a16bb22-0ab5-4190-b4b4-419ccbbb8de2.7f8f100c1db40b894fbac7d7c38e995b.jpeg', 2, 55, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(61, 'Corsair Vengeance 32GB', 3500000, N'TDP: 10W | DDR5 6000MHz Black', N'https://os-jo.com/image/cache/catalog/products/memory/CMH32GX5M2B6400C32W/CORSAIR-Vengeance-RGB-D5-White-1200x1200.jpg', 3, 50, '2026-04-06 13:46:29.076393', N'Corsair'),
(62, 'G.Skill Trident Z5 32GB', 4200000, N'TDP: 15W | DDR5 6400MHz RGB', N'https://cdn.mwave.com.au/images/400/gskill_trident_z5_royal_neo_rgb_32gb_2x_16gb_ddr5_6000mhz_cl28_amd_desktop_memory_silver_ac78818_41026.jpg', 3, 40, '2026-04-06 13:46:29.076393', N'G.Skill'),
(63, 'Kingston Fury 16GB', 1250000, N'TDP: 5W | DDR4 3200MHz', N'https://m.media-amazon.com/images/I/71+clMT-q-L._AC_SL1500_.jpg', 3, 120, '2026-04-06 13:46:29.076393', N'Kingston'),
(64, 'T-Force Delta 32GB', 3200000, N'TDP: 5W | DDR5 6000MHz White', N'https://m.media-amazon.com/images/I/71yyY+Y29WL._AC_.jpg', 3, 45, '2026-04-06 13:46:29.076393', N'TeamGroup'),
(65, 'ADATA XPG 16GB', 1800000, N'TDP: 5W | DDR5 5200MHz', N'https://hoanglongcomputer.vn/media/product/5612-adadada.webp', 3, 70, '2026-04-06 13:46:29.076393', N'ADATA'),
(66, 'Crucial 8GB', 650000, N'TDP: 5W | Standard office RAM', N'https://m.media-amazon.com/images/I/819OdHGCicL.jpg', 3, 200, '2026-04-06 13:46:29.076393', N'Crucial'),
(67, 'Dominator Titanium 64GB', 9500000, N'TDP: 15W | DDR5 7200MHz', N'https://m.media-amazon.com/images/I/61oUyUOzhwL._AC_.jpg', 3, 10, '2026-04-06 13:46:29.076393', N'Corsair'),
(68, 'Ripjaws V 16GB', 1100000, N'TDP: 10W | DDR4 3600MHz', N'https://c1.neweggimages.com/ProductImageCompressAll1280/20-232-181-02.jpg', 3, 90, '2026-04-06 13:46:29.076393', N'G.Skill'),
(69, 'Lexar Thor 32GB', 2100000, N'TDP: 0W | DDR4 3200MHz Budget', N'https://down-ph.img.susercontent.com/file/ph-11134207-7ras8-m2lujp7y6sc27f', 3, 55, '2026-04-06 13:46:29.076393', N'Lexar'),
(70, 'Fury Renegade 32GB', 4800000, N'TDP: 15W | DDR5 7200MHz', N'https://m.media-amazon.com/images/I/71GJY5+c14L._AC_SL1500_.jpg', 3, 25, '2026-04-06 13:46:29.076393', N'Kingston'),
(71, 'PNY XLR8 16GB', 1350000, N'TDP: 5W | DDR4 3200MHz RGB', N'https://basitcomputers.com/wp-content/uploads/2024/12/16GB-DDR4-RAM-3200MHz-PNY-XLR8-GAMiNG-RAM-WiTH-HEATSiNK-105.jpg', 3, 60, '2026-04-06 13:46:29.076393', N'PNY'),
(72, 'Silicon Power 16GB', 950000, N'TDP: 5W | Value RAM 3200', N'https://static1.nordic.pictures/890711-thickbox_default/silicon-power-flash-drive-16gb-marvel-m01-usb-30-blue.jpg', 3, 150, '2026-04-06 13:46:29.076393', N'Silicon Power'),
(73, 'Mushkin Redline 32GB', 3400000, N'TDP: 5W | DDR5 5600MHz', N'https://www.singular.com.cy/images/detailed/615/Mushkin_Redline_DDR5_module_32_GB_SODIMM_MRA5S480FFFD32G-895755.jpg', 3, 20, '2026-04-06 13:46:29.076393', N'Mushkin'),
(74, 'Patriot Viper 16GB', 1450000, N'TDP: 5W | DDR4 4000MHz', N'https://m.media-amazon.com/images/S/aplus-media/sc/1cd89a7c-d360-4b74-aeac-a8d357feb38d.__CR0,0,970,600_PT0_SX970_V1___.jpg', 3, 40, '2026-04-06 13:46:29.076393', N'Razer'),
(75, 'Samsung 32GB', 2800000, N'TDP: 5W | DDR5 4800MHz OEM', N'https://shopdigiwireless.com/wp-content/uploads/2023/08/DW-Website-Phones_A04e-1.png', 3, 30, '2026-04-06 13:46:29.076393', N'Samsung'),
(76, 'Thermaltake 16GB', 2200000, N'TDP: 5W | DDR4 3600MHz RGB', N'https://images-na.ssl-images-amazon.com/images/I/811DUVLPAJL.jpg', 3, 25, '2026-04-06 13:46:29.076393', N'Thermaltake'),
(77, 'Zadak Spark 32GB', 3900000, N'TDP: 5W | DDR5 6000MHz', N'https://img.terabyteshop.com.br/produto/g/memoria-ddr4-zadak-spark-rgb-32gb-3600mhz-2x16gb-zd4-spr36c25-32g2b2_132087.jpg', 3, 15, '2026-04-06 13:46:29.076393', N'Zadak'),
(78, 'Apacer Panther 8GB', 750000, N'TDP: 5W | Budget Gaming RAM', N'https://down-th.img.susercontent.com/file/33c93c24fd76aa21db815921559cbf6c', 3, 100, '2026-04-06 13:46:29.076393', N'Acer'),
(79, 'GeIL Super Luce 16GB', 1300000, N'TDP: 5W | DDR4 3200MHz', N'https://www.memoryc.com/images/products/bb/geil-16567-1_61986.jpg', 3, 50, '2026-04-06 13:46:29.076393', N'GeIL'),
(80, 'V-Color Prism 32GB', 3100000, N'TDP: 5W | DDR4 3600MHz RGB', N'https://microless.com/cdn/products/f2f307222b823793c47a0da071ca69c0-hi.jpg', 3, 40, '2026-04-06 13:46:29.076393', N'V-Color'),
(81, 'Kingston Fury 64GB', 6800000, N'TDP: 5W | DDR5 5600MHz Kit', N'https://m.media-amazon.com/images/I/717cPftxQgL._AC_.jpg', 3, 20, '2026-04-06 13:46:29.076393', N'Kingston'),
(82, 'Vengeance LPX 32GB', 2500000, N'TDP: 10W | DDR4 3200 Low Profile', N'https://res.cloudinary.com/jawa/image/upload/f_auto,ar_1:1,c_fill,w_3840,q_auto/production/listings/fxqabbdlbowyj2wl8sks', 3, 80, '2026-04-06 13:46:29.076393', N'Corsair'),
(83, 'Trident Z Neo 32GB', 3400000, N'TDP: 5W | Optimized for Ryzen', N'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/2/0/20-374-105-02.jpg', 3, 35, '2026-04-06 13:46:29.076393', N'G.Skill'),
(84, 'Team Elite 16GB', 1600000, N'TDP: 5W | DDR5 4800 Basic', N'https://down-ph.img.susercontent.com/file/sg-11134201-22100-yx2ubhg0aaivc5', 3, 60, '2026-04-06 13:46:29.076393', N'TeamGroup'),
(85, 'Crucial Pro 32GB', 3300000, N'TDP: 5W | 6000MHz Overclock', N'https://m.media-amazon.com/images/I/61EUuA9HiaL._AC_.jpg', 3, 45, '2026-04-06 13:46:29.076393', N'Crucial'),
(86, 'Aorus RGB 16GB', 2400000, N'TDP: 5W | 3733MHz w/ Demo', N'https://smartland-tech.com/wp-content/uploads/2026/06/2cb5d453-1637-4c8a-9cdf-bca6cdc63898.png', 3, 15, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(87, 'Lexar Ares 32GB', 3600000, N'TDP: 5W | DDR5 6400MHz', N'https://platincdn.com/3393/pictures/JIYFEDVBRW1182024185730_Lexar-Ares-DT-32GB-RGB-DDR5-LD5EU016G-R6400GDLA-Ra.jpg', 3, 30, '2026-04-06 13:46:29.076393', N'Lexar'),
(88, 'Netac Shadow 16GB', 1100000, N'TDP: 5W | Budget RGB RAM', N'https://netacbd.com/wp-content/uploads/2022/07/1080X1080-7-e1677757851813.jpg', 3, 100, NULL, N'Netac'),
(89, 'Galax HOF 32GB', 5500000, N'TDP: 5W | 8000MHz White OC', N'https://file.hstatic.net/200000061442/file/-32gb-hof-oc-lab-xoc-limited-edition1_c0e96b372a054a89be5725eb7d03eb20_1024x1024.jpg', 3, 3, '2026-04-06 13:46:29.076393', N'GALAX'),
(90, 'Oloy Blade 32GB', 3250000, N'TDP: 5W | DDR5 6000MHz Black', N'https://i5.walmartimages.com/seo/OLOy-Blade-RGB-OLOY-32GB-2-x-16GB-288-Pin-PC-RAM-DDR5-6000-PC5-48000-Desktop-Memory-Model-ND5U1660306BRKDA_9442b6df-2d87-4ea0-9f7f-78e5e36edc71.e4905b98195ae58f7ed8a2ec4712e02f.jpeg', 3, 25, '2026-04-06 13:46:29.076393', N'OLOy'),
(91, 'ROG Maximus Z790 Hero', 16500000, N'TDP: 50W | Flagship Intel Board', N'https://dlcdnwebimgs.asus.com/gain/7512B84A-0D14-4798-A585-3439F4B645CB/w1000/h732', 4, 12, '2026-04-06 13:46:29.076393', N'ASUS'),
(92, 'B760M Mortar WiFi', 4500000, N'TDP: 40W | Best Mid-range Intel', N'https://storage-asset.msi.com/global/picture/image/feature/mb/B760M/mag-b760m-mortar-wifi/msi-b760m-mortar-wifi-motherboard.png', 4, 45, '2026-04-06 13:46:29.076393', N'MSI'),
(93, 'Z790 Aorus Elite', 7800000, N'TDP: 50W | High perf Z790', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2181/innergigabyteimages/specsmall01.jpg', 4, 30, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(94, 'TUF B650-Plus', 5800000, N'TDP: 40W | Standard AM5 Board', N'https://dlcdnwebimgs.asus.com/files/media/2b278afc-50b2-452f-9fae-ec2825d27632/V1/img/kv-main.png', 4, 40, '2026-04-06 13:46:29.076393', N'ASUS'),
(95, 'B660M Pro RS', 3200000, N'TDP: 5W | Budget Intel 12/13', N'https://nguyencongpc.vn/media/product/22934-main-b660m-pro-rs-ax-4.jpeg', 4, 60, '2026-04-06 13:46:29.076393', N'ASRock'),
(96, 'X670E Carbon WiFi', 11500000, N'TDP: 50W | High-end AM5', N'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/p/mpg_x670e_carbon_wifi_4_2x.jpg', 4, 15, '2026-04-06 13:46:29.076393', N'MSI'),
(97, 'Prime H610M-K', 2100000, N'TDP: 0W | Office Intel Board', N'https://dlcdnwebimgs.asus.com/gain/eb6af592-21fd-4592-81f3-d342cf769939/', 4, 100, '2026-04-06 13:46:29.076393', N'ASUS'),
(98, 'B450M DS3H', 1850000, N'TDP: 30W | Legendary AM4 Budget', N'https://rbtechngames.com/wp-content/uploads/2021/08/gigabyte_b450m_ds3h.jpg', 4, 80, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(99, 'ROG Strix B760-I', 5900000, N'TDP: 40W | ITX Intel Board', N'https://microless.com/cdn/products/e990c5abc3a758b3a68f88b2e8460039-hi.jpg', 4, 20, '2026-04-06 13:46:29.076393', N'ASUS'),
(100, 'Z790 GODLIKE', 35000000, N'TDP: 50W | Ultimate Overclock', N'https://storage-asset.msi.com/global/picture/image/feature/mb/Z790/MEG-Z790-GODLIKE/m2-01.png', 4, 3, '2026-04-06 13:46:29.076393', N'MSI'),
(101, 'Z790 Taichi', 12500000, N'TDP: 50W | Gear design, E-ATX', N'https://preview.redd.it/weekly-bios-update-post-week-21-2024-v0-lnupskh4732d1.png?width=1000&format=png&auto=webp&s=035625ea434f9e87a2f721df80ae2f6929fe4569', 4, 8, '2026-04-06 13:46:29.076393', N'ASRock'),
(102, 'ProArt Z790-Creator', 13800000, N'TDP: 50W | For Creators', N'https://dlcdnwebimgs.asus.com/gain/fe64f38f-9f58-4722-b2b0-723379b316be/', 4, 10, '2026-04-06 13:46:29.076393', N'ASUS'),
(103, 'B650I Aorus Ultra', 7200000, N'TDP: 40W | ITX AM5 Board', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2226/innergigabyteimages/smartfan601.png', 4, 12, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(104, 'PRO H610M-E', 1950000, N'TDP: 0W | Cheap office build', N'https://m.media-amazon.com/images/I/81MY4UCX8wL._AC_SY450_.jpg', 4, 150, '2026-04-06 13:46:29.076393', N'MSI'),
(105, 'Crosshair X670E', 28000000, N'TDP: 50W | Best of AM5', N'https://files.pccasegear.com/images/ROG-CROSSHAIR-X670E-EXTREME-add5.jpg', 4, 5, '2026-04-06 13:46:29.076393', N'ASUS'),
(106, 'Biostar B760MZ', 3100000, N'TDP: 40W | Budget B760', N'https://microless.com/cdn/products/a0122264cca32a3cf97401f16cb33fc2-hi.jpg', 4, 40, '2026-04-06 13:46:29.076393', N'Biostar'),
(107, 'CVN B760M Frozen', 4200000, N'TDP: 40W | White Motherboard', N'https://down-my.img.susercontent.com/file/my-11134207-7r98p-ltdcg42jx1x342', 4, 25, '2026-04-06 13:46:29.076393', N'COLORFUL'),
(108, 'A520M S2H', 1650000, N'TDP: 30W | Budget AM4', N'https://m.media-amazon.com/images/I/81o0aL-hQuL._AC_.jpg', 4, 90, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(109, 'NZXT N7 Z790', 8500000, N'TDP: 50W | Clean Aesthetic', N'https://m.media-amazon.com/images/I/71u-dioc8vL._AC_SL1500_.jpg', 4, 18, '2026-04-06 13:46:29.076393', N'NZXT'),
(110, 'A620M-HDV', 2800000, N'TDP: 30W | Cheap AM5 entry', N'https://media.ldlc.com/r1600/ld/products/00/06/03/41/LD0006034167.jpg', 4, 55, '2026-04-06 13:46:29.076393', N'ASRock'),
(111, 'Z790 Dark Kingpin', 22000000, N'TDP: 50W | Limitless OC', N'https://static.tweaktown.com/news/8/8/88651_03_evgas-new-z790-dark-kingpin-motherboard-teased-its-unbelievable.jpg', 4, 2, '2026-04-06 13:46:29.076393', N'EVGA'),
(112, 'X570S Tomahawk', 6500000, N'TDP: 40W | Silent AM4', N'https://images.novatech.co.uk/msi-mag_x570_tomahawk_wifi_extra3.jpg', 4, 20, '2026-04-06 13:46:29.076393', N'MSI'),
(113, 'A520M-Plus', 2400000, N'TDP: 30W | Durable AM4', N'https://www.cclonline.com/images/avante/5_TUF-GAMING-A520M-PLUS-WIFI_3D_AURA.jpg?width=1600&height=1600&scale=canvas', 4, 45, '2026-04-06 13:46:29.076393', N'ASUS'),
(114, 'Z790 UD', 5500000, N'TDP: 50W | Basic Z790', N'https://m.media-amazon.com/images/I/71w2Kf+KK+L._AC_.jpg', 4, 35, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(115, 'B550M Steel Legend', 3800000, N'TDP: 40W | Solid B550 AM4', N'https://www.asrock.com/mb/photo/B550M%20Steel%20Legend(L1).png', 4, 40, '2026-04-06 13:46:29.076393', N'ASRock'),
(116, 'MSI B650 Gaming', 4900000, N'TDP: 40W | Budget AM5 WiFi', N'https://media.ldlc.com/r1600/ld/products/00/06/03/76/LD0006037607.jpg', 4, 50, '2026-04-06 13:46:29.076393', N'MSI'),
(117, 'Prime Z790-P', 6200000, N'TDP: 50W | Mainstream Z790', N'https://www.dateks.lv/images/pic/2400/2400/712/1307.jpg', 4, 30, '2026-04-06 13:46:29.076393', N'ASUS'),
(118, 'H610M S2H', 2250000, N'TDP: 0W | LGA 1700 Office', N'https://m.media-amazon.com/images/I/81AdQh4+sHL._AC_SL1500_.jpg', 4, 110, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(119, 'X670E Steel Legend', 8900000, N'TDP: 50W | White AM5 High', N'https://media.ldlc.com/r1600/ld/products/00/05/98/02/LD0005980298.jpg', 4, 15, '2026-04-06 13:46:29.076393', N'ASRock'),
(120, 'Valkyrie Z790', 9500000, N'TDP: 50W | Biostar Flagship', N'https://thetechrevolutionist.com/wp-content/uploads/2022/09/z790-valkyrie-4.png?is-pending-load=1', 4, 7, '2026-04-06 13:46:29.076393', N'Valkyrie'),
(121, 'Samsung 990 Pro 1T', 3200000, N'TDP: 9W | NVMe Gen4 7450MB/s', N'https://s13emagst.akamaized.net/products/50830/50829483/images/res_a126340b9468e6ebe28dfaef136309be.jpg', 5, 60, '2026-04-06 13:46:29.076393', N'Samsung'),
(122, 'Samsung 980 Pro 2T', 4500000, N'TDP: 9W | NVMe Gen4 7000MB/s', N'https://www.ssd1tb.com/wp-content/uploads/Samsung-980-Pro-2tb-ssd.jpg', 5, 40, '2026-04-06 13:46:29.076393', N'Samsung'),
(123, 'WD SN850X 1TB', 2600000, N'TDP: 9W | Top gaming SSD', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6512/6512131cv12d.jpg', 5, 55, '2026-04-06 13:46:29.076393', N'WD'),
(124, 'Crucial P3 Plus 1T', 1850000, N'TDP: 5W | Budget Gen4', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6509/6509715cv12d.jpg', 5, 100, '2026-04-06 13:46:29.076393', N'Crucial'),
(125, 'Kingston NV2 500G', 950000, N'TDP: 5W | Entry NVMe', N'https://images.kabum.com.br/produtos/fotos/sync_mirakl/400945/SSD-Kingston-Nv2-500GB-M-2-2280-NVME-PCIE-4-0-X4-Leitura-3500MB-s-E-Grava-o-2100MB-s-Preto-Snv2s-500g_1732199474_gg.jpg', 5, 150, '2026-04-06 13:46:29.076393', N'Kingston'),
(126, 'Samsung 870 EVO 1T', 2100000, N'TDP: 5W | Best SATA SSD', N'https://www.ssd1tb.com/wp-content/uploads/samsung-870-evo-1tb.jpg', 5, 80, '2026-04-06 13:46:29.076393', N'Samsung'),
(127, 'P41 Platinum 2T', 5200000, N'TDP: 5W | Super Fast Gen4', N'https://cdn.wccftech.com/wp-content/uploads/2024/03/DSC_0547-Custom.jpg', 5, 20, '2026-04-06 13:46:29.076393', N'SK hynix'),
(128, 'Lexar NM790 2T', 3800000, N'TDP: 5W | Value Gen4 7400', N'https://a.allegroimg.com/original/11b9a3/a4d9f6854e66ad6a065f1a9a7151/Dysk-SSD-Lexar-2TB-M-2-PCIe-Gen4-NVMe-NM790', 5, 45, '2026-04-06 13:46:29.076393', N'Lexar'),
(129, 'Crucial T700 1TB', 5800000, N'TDP: 14W | Gen5 11700MB/s', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6544/6544913_sd.jpg', 5, 15, '2026-04-06 13:46:29.076393', N'Crucial'),
(130, 'Aorus Gen5 2TB', 9500000, N'TDP: 14W | Gen5 w/ Heatsink', N'https://cdn.mcc-jo.com/media/G6O8nomwymYdYRvEto1xZM1OlAH5n2PoshguCK3s.webp', 5, 10, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(131, 'TeamGroup MP33 1T', 1400000, N'TDP: 5W | Budget NVMe', N'https://images.teamgroupinc.com/products/ssd/m2/mp33/1tb_01.jpg', 5, 90, '2026-04-06 13:46:29.076393', N'TeamGroup'),
(132, 'XPG S70 Blade 1T', 2200000, N'TDP: 5W | PS5 Gen4', N'https://webapi3.adata.com/storage/product/s70_blade_pk_1tb.png', 5, 65, '2026-04-06 13:46:29.076393', N'ADATA'),
(133, 'SN580 1TB', 1700000, N'TDP: 5W | Reliable Gen4', N'https://i5.walmartimages.com/seo/WD-Blue-1TB-SN580-NVMe-Internal-SSD-WDBWMY0010BBL-WRWM_28933fdc-65d2-4eef-95f4-474478cfd226.51d02b302ea9785e967da33be118bf8b.jpeg', 5, 75, '2026-04-06 13:46:29.076393', N'WD'),
(134, 'FireCuda 530 2TB', 5900000, N'TDP: 5W | High endurance', N'https://lagihitech.vn/wp-content/uploads/2022/02/SSD-Seagate-Firecuda-530-2TB-M.2-PCIe-Gen4x4-NVMe-ZP2000GM30013-hinh-1.jpg', 5, 18, '2026-04-06 13:46:29.076393', N'Seagate'),
(135, 'Sabrent Rocket 4TB', 12500000, N'TDP: 5W | Huge capacity', N'https://m.media-amazon.com/images/I/71g-S-3aAjL._AC_.jpg', 5, 8, '2026-04-06 13:46:29.076393', N'Sabrent'),
(136, '970 EVO Plus 2TB', 3900000, N'TDP: 5W | Gen3 King', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6347/6347286cv11d.jpg', 5, 30, '2026-04-06 13:46:29.076393', N'Samsung'),
(137, 'PNY CS2241 1TB', 1600000, N'TDP: 5W | Budget Gen4', N'https://minipcreviewer.com/wp-content/uploads/2024/03/pny-cs2241-1tb-m2-nvme-gen4-x4-internal-solid-state-drive-ssd-m280cs2241-1tb-rb-1.jpg', 5, 50, '2026-04-06 13:46:29.076393', N'PNY'),
(138, 'Silicon Power UD90 1650000', 1650000, N'TDP: 75W | Gen4 Value', N'https://talospc.com/wp-content/uploads/2023/03/SILICON-POWER-UD90-1TB-700-1.jpg', 5, 60, '2026-04-06 13:46:29.076393', N'Silicon Power'),
(139, 'MP600 Pro 2TB', 4800000, N'TDP: 5W | Optimized for PS5', N'https://microless.com/cdn/products/d78642f6f74ff365958f933b707cc544-hi.jpg', 5, 22, '2026-04-06 13:46:29.076393', N'Corsair'),
(140, 'KC3000 1TB', 2450000, N'TDP: 9W | Fast Gen4 OS', N'https://www.dateks.lv/images/pic/1200/1200/849/1083.jpg', 5, 40, '2026-04-06 13:46:29.076393', N'Kingston'),
(141, 'Crucial MX500 1TB', 1800000, N'TDP: 5W | SATA storage', N'https://c1.neweggimages.com/productimage/nb1280/20-156-174-V05.jpg', 5, 85, '2026-04-06 13:46:29.076393', N'Crucial'),
(142, 'SN350 480GB', 850000, N'TDP: 5W | Cheap upgrade', N'https://static.ctonline.mx/imagenes/DDUWSD1690/DDUWSD1690_full.jpg', 5, 120, '2026-04-06 13:46:29.076393', N'WD'),
(143, 'Spatium M480 2TB', 4600000, N'TDP: 5W | High-end MSI SSD', N'https://m.media-amazon.com/images/I/71KFqIt1KeL._AC_.jpg', 5, 20, '2026-04-06 13:46:29.076393', N'MSI'),
(144, 'Transcend 250S 1T', 2100000, N'TDP: 5W | Gen4 with Cache', N'https://www.ucc.com.bd/image/cache/catalog/ssd/transcend/TS1TMTE250S-550x550.png.webp', 5, 35, '2026-04-06 13:46:29.076393', N'Transcend'),
(145, 'Viper VP4300 2TB', 5400000, N'TDP: 5W | Dual heatsinks', N'https://i5.walmartimages.com/seo/Patriot-Viper-VP4300-2TB-Internal-SSD-W-HS-NVMe-PCIe-Gen-4x4-M-2-2280-Solid-State-Drive-VP4300-2TBM28H_2c78e06e-e406-4ac8-a54f-2c5b7fcdbfb6.d9f034f5a760a6dd0a15752b29a0c1c8.jpeg', 5, 12, '2026-04-06 13:46:29.076393', N'Razer'),
(146, 'Lexar NM620 512G', 900000, N'TDP: 5W | Gen3 Budget', N'https://lap.lk/wp-content/uploads/2023/06/Lexar-NM620-512GB.png', 5, 100, '2026-04-06 13:46:29.076393', N'Lexar'),
(147, 'Netac N7000 2TB', 3600000, N'TDP: 5W | Gen4 7000MB/s', N'https://cdn.neowin.com/news/images/uploaded/2023/10/1698065089_netac-internal-ssd.jpg', 5, 40, '2026-04-06 13:46:29.076393', N'Netac'),
(148, '870 QVO 4TB', 8500000, N'TDP: 5W | Massive SATA', N'https://www.discoazul.pt/uploads/media/images/disco-duro-ssd-samsung-870-qvo-4tb-sata-3-2-5-16.jpg', 5, 31, '2026-04-06 13:46:29.076393', N'Samsung'),
(149, 'Adata SU650 240G', 450000, N'TDP: 12W | Cheapest SSD', N'https://img.pchome.com.tw/cs/items/DRAH0VA900HX1I5/000001_1727978028.jpg', 5, 200, '2026-04-06 13:46:29.076393', N'ADATA'),
(150, 'Crucial T705 2TB', 10500000, N'TDP: 14W | Fastest Gen5', N'https://m.media-amazon.com/images/I/61wfug68D+L.jpg', 5, 5, '2026-04-06 13:46:29.076393', N'Crucial'),
(151, 'LG 27GR95QE', 22500000, N'TDP: 5W | 27 OLED 240Hz', N'https://files.pccasegear.com/images/27GR95QE-B-thumb.jpg', 6, 12, '2026-04-06 13:46:29.076393', N'LG'),
(152, 'Dell U2723QE', 14800000, N'TDP: 5W | 27" 4K IPS Black', N'https://www.ofzenandcomputing.com/wp-content/uploads/2026/01/B09TQZP9CL_customer_1.jpg', 6, 25, '2026-04-06 13:46:29.076393', N'Dell'),
(153, 'VG249Q', 4200000, N'TDP: 5W | 24 144Hz IPS', N'https://dlcdnimgs.asus.com/websites/global/products/mpppu3u01ux28nvt/images/section4-img.png', 6, 60, '2026-04-06 13:46:29.076393', N'ASUS'),
(154, 'Odyssey Neo G8', 28000000, N'TDP: 5W | 32 4K 240Hz', N'https://m.media-amazon.com/images/I/81dDR+bGO3L._AC_.jpg', 6, 8, '2026-04-06 13:46:29.076393', N'Samsung'),
(155, 'Gigabyte M27Q', 7800000, N'TDP: 5W | 27 2K 170Hz', N'https://m.media-amazon.com/images/I/71d-odH5-8L._AC_SL1500_.jpg', 6, 35, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(156, 'AOC 24G2', 3900000, N'TDP: 5W | Popular 144Hz', N'https://m.media-amazon.com/images/I/81NEMtk5qPL._AC_SL1500_.jpg', 6, 80, '2026-04-06 13:46:29.076393', N'AOC'),
(157, 'ViewSonic VX2728', 4500000, N'TDP: 5W | 27 165Hz IPS', N'https://wise-tech.com.pk/wp-content/uploads/2024/04/VX2728-Side-View.png', 6, 50, '2026-04-06 13:46:29.076393', N'ViewSonic'),
(158, 'MAG274QRF-QD', 10500000, N'TDP: 5W | 2K Quantum Dot', N'https://asset.msi.com/resize/image/global/product/product_1698825055a998b04cad4f3a7146e1cbbd35fe08d1.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 6, 20, '2026-04-06 13:46:29.076393', N'MSI'),
(159, 'AW3423DW', 32000000, N'TDP: 5W | 34 QD-OLED', N'https://m.media-amazon.com/images/I/71ufV5NQ44L._AC_SL1500_.jpg', 6, 5, '2026-04-06 13:46:29.076393', N'Dell'),
(160, 'BenQ SW271C', 42000000, N'TDP: 5W | Pro Color Photo', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6486/6486795cv1d.jpg', 6, 3, '2026-04-06 13:46:29.076393', N'BenQ'),
(161, 'Samsung M7', 8200000, N'TDP: 5W | 32 4K Smart', N'https://i5.walmartimages.com/seo/SAMSUNG-32-Smart-Monitor-M7-M70D-4K-UHD-with-Streaming-TV-Speakers-and-USB-C_b8469dad-9f08-4fdf-a685-b499f060f079.a0006f71cc35ee2ea5151413bf93f24b.jpeg?odnHeight=640&odnWidth=640&odnBg=FFFFFF', 6, 30, '2026-04-06 13:46:29.076393', N'Samsung'),
(162, 'LG 24MP60G', 2900000, N'TDP: 5W | Budget 24 IPS', N'https://m.media-amazon.com/images/I/71Ud77qJvSL._SL1500_.jpg', 6, 100, '2026-04-06 13:46:29.076393', N'LG'),
(163, 'Swift PG42UQ', 38000000, N'TDP: 5W | 42 OLED 4K', N'https://www.gaming.gen.tr/wp-content/uploads/2023/05/asus-rog-swift-pg42uq-41-5-inc-138hz-0-1ms-uhd-adaptive-sync-oled-gaming-monitor-y.jpg', 6, 4, '2026-04-06 13:46:29.076393', N'ASUS'),
(164, 'Gigabyte G24F 2', 4100000, N'TDP: 5W | 24 180Hz OC', N'https://m.media-amazon.com/images/I/81xNJON5ysL._AC_SL1500_.jpg', 6, 70, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(165, 'HP Z27k G3', 15500000, N'TDP: 5W | 4K Studio USB-C', N'https://mitosshoppers.com/wp-content/uploads/2026/01/2-19.jpg', 6, 15, '2026-04-06 13:46:29.076393', N'HP'),
(166, 'Nitro VG271U', 6500000, N'TDP: 5W | 27 2K 144Hz', N'https://i5.walmartimages.com/seo/Acer-Nitro-VG271U-M3bmiipx-27-WQHD-2560-x-1440-IPS-Monitor-with-AMD-FreeSync-Premium-Technology_87dece16-0f5e-4d5f-9579-ae97d9169316.ab486d96a9e5254d8824bc11fb4f19a4.png', 6, 45, '2026-04-06 13:46:29.076393', N'Acer'),
(167, 'Dell S2721DGF', 9200000, N'TDP: 5W | Fast IPS 165Hz', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6421/6421624cv17d.jpg', 6, 22, '2026-04-06 13:46:29.076393', N'Dell'),
(168, 'LG DualUp', 16000000, N'TDP: 5W | Square 16:18', N'https://www.lg.com/content/dam/channel/wcms/br/images/M02_mnt-dualup-ergo-28mq780-01-2-lg-dualup-monitor-ergo-mobile.jpg', 6, 10, '2026-04-06 13:46:29.076393', N'LG'),
(169, 'Odyssey G5', 7200000, N'TDP: 5W | 27 2K Curved', N'https://m.media-amazon.com/images/I/81Pm4yGtiYL._AC_SL1500_.jpg', 6, 40, '2026-04-06 13:46:29.076393', N'Samsung'),
(170, 'Legion Y25-30', 6800000, N'TDP: 5W | 24.5 240Hz', N'https://techacute.com/wp-content/uploads/2022/12/Lenovo-Legion-Y25-30-Gaming-Monitor-Tested-Out-Esports-Display-Review.jpg', 6, 25, '2026-04-06 13:46:29.076393', N'Lenovo'),
(171, 'ProArt PA278QV', 8900000, N'TDP: 5W | Color Accurate', N'https://dlcdnimgs.asus.com/websites/global/products/gvxnvsvumc3y1lyy/images/pic_true_beauty.png', 6, 18, '2026-04-06 13:46:29.076393', N'ASUS'),
(172, 'HKC ANT27TQC', 5500000, N'TDP: 5W | Budget 2K Curved', N'https://doc-fd.zol-img.com.cn/t_s640x2000/g6/M00/0A/06/ChMkKmBZkIaIYkKIACPmpm8vrpYAAL71QN3WEcAI-a-654.png', 6, 55, '2026-04-06 13:46:29.076393', N'HKC'),
(173, 'MSI G2412', 3500000, N'TDP: 5W | Budget 170Hz', N'https://asset.msi.com/resize/image/global/product/product_16533746428fdd9ede10dbb55365e4d4267b978414.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 6, 90, '2026-04-06 13:46:29.076393', N'MSI'),
(174, 'Dell E2222H', 2200000, N'TDP: 5W | Office 22"', N'https://www.e-retail.com/wp-content/uploads/2022/02/monitors_e2222h_gallery_2.jpg', 6, 150, '2026-04-06 13:46:29.076393', N'Dell'),
(175, 'LG 29WP500', 5200000, N'TDP: 5W | 29 UltraWide', N'https://c1.neweggimages.com/ProductImageCompressAll1280/24-026-192-V04.jpg', 6, 35, '2026-04-06 13:46:29.076393', N'LG'),
(176, 'Philips 242E1', 3100000, N'TDP: 0W | Budget 144Hz', N'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/107/MTA-129724838/no-brand_no-brand_full01.jpg', 6, 80, '2026-04-06 13:46:29.076393', N'Philips'),
(177, 'AOC CU34G2X', 12500000, N'TDP: 5W | 34 UW 144Hz', N'https://media.techeblog.com/images/aoc-cu34g2x-34-inch-curved-gaming-monitor.jpg', 6, 15, '2026-04-06 13:46:29.076393', N'AOC'),
(178, 'Xeneon Flex', 45000000, N'TDP: 5W | Bendable OLED', N'https://www.kitguru.net/wp-content/uploads/2022/08/Corsair-Xeneon-Flexfront-curved.jpg', 6, 2, '2026-04-06 13:46:29.076393', N'Corsair'),
(179, 'Zowie XL2546K', 13500000, N'TDP: 5W | Pro Esport 240Hz', N'https://brain-images-ssl.cdn.dixons.com/4/9/10218894/u_10218894.jpg', 6, 20, '2026-04-06 13:46:29.076393', N'BenQ'),
(180, 'Xiaomi Mi 34', 9500000, N'TDP: 5W | 34 2K UltraWide', N'https://ph-test-11.slatic.net/p/8642c1abe8e78d3a3f37b584614461b8.jpg', 6, 40, '2026-04-06 13:46:29.076393', N'Xiaomi'),
(181, 'Intel Arc A770 Limited Edition GPU', 8356600, N'TDP: 225W | 16GB GDDR6, 256-bit, 2100 MHz, 225W', N'https://m.media-amazon.com/images/I/71rzJRZ7lIL._AC_.jpg', 2, 50, '2026-06-05 10:05:55.522526', N'Intel'),
(182, 'Intel Arc A750 Graphics Card', 6324600, N'TDP: 225W | 8GB GDDR6, 256-bit, 2050 MHz, 225W', N'https://m.media-amazon.com/images/I/71sO2CZL1UL._AC_.jpg', 2, 49, '2026-06-05 10:05:55.522526', N'Intel'),
(183, 'Intel Arc A580 Graphics Card', 4546600, N'TDP: 185W | 8GB GDDR6, 256-bit, 1700 MHz, 185W', N'https://www.notebookcheck.net/fileadmin/Notebooks/News/_nc3/Intel-Arc-A580-header.jpg', 2, 50, '2026-06-05 10:05:55.522526', N'Intel'),
(184, 'AMD Radeon RX 7900 XT GPU', 22834600, N'TDP: 285W | 20GB GDDR6, 80MB, 315W', N'https://m.media-amazon.com/images/I/81ZBhhO35mL._AC_.jpg', 2, 50, '2026-06-05 10:05:55.522526', N'AMD'),
(185, 'AMD Radeon RX 7800 XT GPU', 12674600, N'TDP: 220W | 16GB GDDR6, 64MB, 263W', N'https://m.media-amazon.com/images/I/81VpOvD9wJL._AC_.jpg', 2, 50, '2026-06-05 10:05:55.522526', N'AMD'),
(186, 'AMD Ryzen 5 5600X Desktop Processor', 3784600, N'TDP: 65W | 6 Cores, 12 Threads, 35MB Cache, Up to 4.6GHz, Socket AM4', N'https://www.amd.com/content/dam/amd/en/images/products/processors/ryzen/2505503-ryzen-5-5600x.jpg', 1, 50, '2026-06-05 10:05:55.522526', N'AMD'),
(187, 'ASUS ROG Maximus Z790 Dark Hero', 17754600, N'TDP: 50W | LGA1700, Intel Z790, 4x DDR5 (Up to 192GB), ATX', N'https://dlcdnwebimgs.asus.com/gain/8E88DC59-A399-4385-8BCB-C3877F4EB746/w1000/h732', 4, 50, '2026-06-05 10:05:55.522526', N'ASUS'),
(188, 'ASUS ROG Strix X670E-E Gaming WiFi', 12674600, N'TDP: 50W | AM5, AMD X670E, PCIe 5.0, ATX', N'https://dlcdnwebimgs.asus.com/gain/BADFA920-702B-451B-9592-8279ACD6857B', 4, 50, '2026-06-05 10:05:55.522526', N'ASUS'),
(189, 'ASUS ROG Strix GeForce RTX 4090 OC Edition', 50774600, N'TDP: 450W | 24GB GDDR6X, 16384, PCIe 4.0', N'https://media.ldlc.com/r1600/ld/products/00/06/00/29/LD0006002969.jpg', 2, 50, '2026-06-05 10:05:55.522526', N'ASUS'),
(190, 'ASUS ROG Swift OLED PG32UCDM', 32994600, N'TDP: 0W | 32-inch, 3840x2160 (4K), 240Hz, QD-OLED', N'https://m.media-amazon.com/images/I/91MMzcvOwLL.jpg', 6, 50, '2026-06-05 10:05:55.522526', N'ASUS'),
(191, 'ASUS ROG Ryujin III 360 ARGB', 8864600, N'TDP: 15W | 360mm, Asetek 8th Gen, 3.5-inch Full Color', N'https://dlcdnwebimgs.asus.com/gain/A1D6D78A-00BE-4F89-A360-2790312CDDAD', 13, 50, '2026-06-05 10:05:55.522526', N'ASUS'),
(192, 'ASUS ROG Thor 1200W Platinum II', 8102600, N'TDP: 0W | 1200W, 80 Plus Platinum, Full Modular, Real-time power draw', N'https://pcboost.co.uk/wp-content/uploads/2022/11/ROG-THOR-1200W-Platinum-II-Fully-Modular-Power-Supply-From-ASUS.jpg', 11, 50, '2026-06-05 10:05:55.522526', N'ASUS'),
(193, 'MSI MEG Z790 GODLIKE MAX', 30454600, N'TDP: 50W | LGA1700, Intel Z790, 7x M.2 slots, M-Vision Dashboard', N'https://storage-asset.msi.com/global/picture/image/feature/mb/Z790/meg-z790-godlike-max/images/mb-godlike-max-02.png', 4, 50, '2026-06-05 10:05:55.522526', N'MSI'),
(194, 'MSI MAG B650 TOMAHAWK WIFI', 5562600, N'TDP: 40W | AM5, AMD B650, DDR5 7600+(OC), Realtek 2.5Gbps LAN', N'https://storage-asset.msi.com/global/picture/image/feature/mb/B650/MAG-B650-TOMAHAWK-WIFI/mag-b650-tomahawk-wifi.png', 4, 50, '2026-06-05 10:05:55.522526', N'MSI'),
(195, 'MSI GeForce RTX 4080 SUPER 16G GAMING X SLIM', 26644600, N'TDP: 320W | 16GB GDDR6X, TRI FROZR 3, 2625 MHz', N'https://m.media-amazon.com/images/I/71262tPfh-L._AC_SL1500_.jpg', 2, 50, '2026-06-05 10:05:55.522526', N'MSI'),
(196, 'MSI MPG 271QRX QD-OLED', 20294600, N'TDP: 0W | 27-inch, 2560x1440 (2K), 360Hz, 0.03ms (GtG)', N'https://images.versus.io/objects/msi-mpg-271qrx-qd-oled-27.front.master2x.1714391809576.webp', 6, 50, '2026-06-05 10:05:55.522526', N'MSI'),
(197, 'MSI MEG MAESTRO 700L PZ', 10642600, N'TDP: 5W | ATX Full Tower, Curved Tempered Glass, Back-connect (Project Zero) support', N'https://storage-asset.msi.com/global/picture/image/feature/PC-Case/MEG-MAESTRO-700L-PZ/meg-maestro-700l-pz-connect-pd.png', 12, 50, '2026-06-05 10:05:55.522526', N'MSI'),
(198, 'MSI MAG CORELIQUID I360', 3530600, N'TDP: 15W | 360mm, ARGB Fans, Infinite Mirror IPS Style Design', N'https://cdn.mwave.com.au/images/400/msi_mag_coreliquid_i360_360mm_argb_aio_liquid_cpu_cooler_black_ac79069_96031.jpg', 13, 50, '2026-06-05 10:05:55.522526', N'MSI'),
(199, 'MSI SPATIUM M570 PCIe 5.0 NVMe M.2 HS', 7594600, N'TDP: 14W | 2TB, Up to 12400 MB/s, Up to 11800 MB/s', N'https://asset.msi.com/resize/image/global/product/product_167573935424940aba56cd1dba801846447d621bb2.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 5, 50, '2026-06-05 10:05:55.522526', N'MSI'),
(200, 'Gigabyte Z790 AORUS XTREME X', 25374600, N'TDP: 50W | LGA1700, 24+1+2 Phases, Wi-Fi 7, PCIe 5.0 x16', N'https://static.gigabyte.com/StaticFile/Image/Global/dee0b0bef844f7dcac99c3569fdf02c8/Product/36669/Png', 4, 50, '2026-06-05 10:05:55.522526', N'GIGABYTE'),
(201, 'Gigabyte X670E AORUS MASTER', 11404600, N'TDP: 50W | AM5, AMD X670E, 4x M.2 PCIe 5.0, Intel 2.5GbE LAN', N'https://c1.neweggimages.com/ProductImageCompressAll1280/13-145-405-01.jpg', 4, 50, '2026-06-05 10:05:55.522526', N'GIGABYTE'),
(202, 'Gigabyte M27Q Gaming Monitor', 7594600, N'TDP: 0W | 27-inch, Super Speed IPS, 2560x1440, 170Hz', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/1554/innergigabyteimages/bg1.png', 6, 50, '2026-06-05 10:05:55.522526', N'GIGABYTE'),
(203, 'Gigabyte AORUS FO32U2P', 30454600, N'TDP: 5W | 32-inch, OLED (QD-OLED), 3840x2160, DP 2.1 UHBR20 supported', N'https://m.media-amazon.com/images/I/71M5qy2eL0L._AC_.jpg', 6, 50, '2026-06-05 10:05:55.522526', N'GIGABYTE'),
(204, 'Gigabyte AORUS Gen5 12000 SSD 2TB', 8102600, N'TDP: 14W | PCIe 5.0 x4, NVMe 2.0, 12,400 MB/s, 11,800 MB/s', N'https://elbadrgroupeg.store/image/cache/catalog/Gigabyte/fRt20PFj2jAFDEFVYh7wtd8LXj-1000x1000.png', 5, 50, '2026-06-05 10:05:55.522526', N'GIGABYTE'),
(205, 'Gigabyte UD1000GM PG5 (Rev 2.0)', 4038600, N'TDP: 0W | 1000W, PCIe Gen 5.0 (12VHPWR), 80 PLUS Gold', N'https://cdn.cclonline.com/cdn-cgi/image/width=2000/images/shopblocks/UD1000GM%20PG5-05.png', 11, 50, '2026-06-05 10:05:55.522526', N'GIGABYTE'),
(206, 'Gigabyte AORUS C500 GLASS', 4546600, N'TDP: 0W | Mid Tower, 4mm Tempered Glass, Up to 420mm front', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2156/innergigabyteimages/utility-img-1.jpg', 12, 50, '2026-06-05 10:05:55.522526', N'GIGABYTE'),
(207, 'Corsair Dominator Titanium RGB DDR5 32GB (2x16GB)6000MHz', 4673600, N'TDP: 15W | 32GB, 6000 MT/s, CL30, Intel XMP 3.0 / AMD EXPO', N'https://m.media-amazon.com/images/I/61HhbZrQ4-L._AC_.jpg', 3, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(208, 'Corsair Vengeance RGB DDR5 64GB (2x32GB)5600MHz', 5562600, N'TDP: 65W | 64GB, 5600 MT/s, CL40', N'https://img.terabyteshop.com.br/produto/g/memoria-ddr5-corsair-vengeance-rgb-64gb-2x32gb-5600mhz-preto-cmh64gx5m2b5600z40k_236431.jpg', 3, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(209, 'Corsair iCUE LINK H150i LCD Liquid CPU Cooler', 7340600, N'TDP: 5W | 360mm, 3x QX120 RGB Fans, 2.1-inch IPS Display, iCUE LINK Ecosystem', N'https://microless.com/cdn/products/f8d91556e68aba4803a42b07377221bc-hi.jpg', 13, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(210, 'Corsair 5000D AIRFLOW Tempered Glass Mid-Tower', 4165600, N'TDP: 0W | Mid-Tower, Black, RapidRoute System, Up to 10x 120mm fans', N'https://cwsmgmt.corsair.com/pdp/5000-series/images/5000d-af-clear-clean-cool.png', 12, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(211, 'Corsair iCUE LINK 6500X RGB Mid-Tower DualChamber', 5054600, N'TDP: 0W | Dual Chamber Layout, Reverse-connector support, Front & Side Tempered Glass', N'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Cases/6500/CC-9011269-WW/Gallery/6500X_RGB_BLACK_RENDER_01.webp', 12, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(212, 'Corsair RM1000x Shift Fully Modular ATX PSU', 5308600, N'TDP: 0W | 1000W, 80 PLUS Gold, Side-mounted modular connections, ATX 3.0 & PCIe 5.0 ready', N'https://m.media-amazon.com/images/I/81dwGXVwpgL.jpg', 11, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(213, 'Corsair AX1600i Digital ATX Power Supply', 15468600, N'TDP: 0W | 1600W, 80 PLUS Titanium, Gallium Nitride (GaN) FETs', N'https://www.e-weekly.co.uk/Images/JohnMac/Corsair/CSR-AX160I/Images/AX1600i_03.jpg', 11, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(214, 'Corsair K100 RGB Mechanical Gaming Keyboard', 6324600, N'TDP: 2W | Corsair OPX Optical-Mechanical, AXON 4000Hz Hyper-polling, iCUE Control Wheel', N'https://eezepc.com/wp-content/uploads/2021/03/Corsair-K100-RGB-Mechanical-Gaming-Keyboard-EEZEPC-1.jpg', 15, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(215, 'Corsair Darkstar Wireless MMO Gaming Mouse', 4292600, N'TDP: 1W | 15 programmable buttons, MARKSMAN 26K DPI Optical, SLIPSTREAM Wireless & Bluetooth', N'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Gaming-Mice/CH-931A011/DARKSTAR_WIRELESS_01.webp', 16, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(216, 'Corsair Virtuoso RGB Wireless XT Headset', 6832600, N'TDP: 1W | High-Density 50mm Neodymium, Spatial Dolby Atmos, Broadcast-grade detachable mic', N'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Gaming-Headsets/CA-9011188-NA/Gallery/VIRTUOSO_XT_01.webp', 17, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(217, 'Logitech G Pro X Superlight 2 Wireless GamingMouse', 4038600, N'TDP: 1W | 60 grams, HERO 2 Sensor (32,000 DPI), LIGHTFORCE Hybrid Switches, 4000Hz max polling', N'https://techubme.com/wp-content/uploads/2024/07/logitech_Pro_X_Super_light_2.png', 16, 50, '2026-06-05 10:05:55.522526', N'Logitech'),
(218, 'Logitech G502 X LIGHTSPEED Wireless GamingMouse', 3530600, N'TDP: 1W | HERO 25K Sensor, 13 programmable controls, Dual-mode infinite scroll', N'https://www.bhphotovideo.com/images/images1500x1500/logitech_g_910_006178_g502_x_lightspeed_wireless_1722687.jpg', 16, 50, '2026-06-05 10:05:55.522526', N'Logitech'),
(219, 'Logitech G915 TKL Wireless Mechanical Keyboard', 5816600, N'TDP: 2W | Tenkeyless (TKL), Low Profile GL Tactile/Linear/Clicky, Up to 40 hours (100% brightness)', N'https://resource.logitechg.com/d_transparent.gif/content/dam/gaming/en/products/g915-tkl/g915-tkl-gallery/deu-g915-tkl-carbon-gallery-topdown.png', 15, 50, '2026-06-05 10:05:55.522526', N'Logitech'),
(220, 'Logitech G Pro X TKL LIGHTSPEED Gaming Keyboard', 5054600, N'TDP: 2W | Dual-shot PBT keycaps, LIGHTSPEED Wireless, Bluetooth, USB, Dedicated volume roller and controls', N'https://www.enation.sg/wp-content/uploads/2025/06/251.png', 15, 50, '2026-06-05 10:05:55.522526', N'Logitech'),
(221, 'Logitech G Pro X 2 LIGHTSPEED Wireless Headset', 6324600, N'TDP: 1W | 50mm Graphene Drivers, LIGHTSPEED, Bluetooth, 3.5mm wired, Up to 50 hours battery life', N'https://www.bhphotovideo.com/images/images1500x1500/logitech_g_981_001262_pro_x_2_wireless_1763226.jpg', 17, 50, '2026-06-05 10:05:55.522526', N'Logitech'),
(222, 'Logitech MX Master 3S Wireless Mouse', 2514600, N'TDP: 1W | 8K DPI tracking on any surface, Quiet clicks technology, MagSpeed Electromagnetic scrolling', N'https://m.media-amazon.com/images/I/61+OT7FPABL._AC_SL1500_.jpg', 16, 50, '2026-06-05 10:05:55.522526', N'Logitech'),
(223, 'Logitech MX Keys S Wireless Keyboard', 2768600, N'TDP: 2W | Spherically-dished Perfect Stroke keys, Smart illumination proximity sensor, Easy-Switch up to 3 devices', N'https://resource.logitech.com/w_1800,h_1800,c_limit,q_auto,f_auto,dpr_1.0/d_transparent.gif/content/dam/logitech/en/products/keyboards/mx-keys-s/product-gallery/graphite/mx-keys-s-keyboard-top-view-graphite-us.png?v=1', 15, 50, '2026-06-05 10:05:55.522526', N'Logitech'),
(224, 'Razer Viper V3 Pro Wireless Gaming Mouse', 4038600, N'TDP: 1W | 54 grams, Focus Pro 35K Optical Sensor Gen-2, True 8000Hz HyperPolling Wireless', N'https://m.media-amazon.com/images/I/619xpFKAXPL.jpg', 16, 50, '2026-06-05 10:05:55.522526', N'Razer'),
(225, 'Razer DeathAdder V3 Pro Wireless Gaming Mouse', 3784600, N'TDP: 1W | 63 grams, Right-handed ergonomic design, Focus Pro 30K Optical Sensor', N'https://wise-tech.com.pk/wp-content/uploads/2023/07/Razer-DeathAdder-V3-Pro-Ergonomic-Gaming-Mouse-White.png', 16, 50, '2026-06-05 10:05:55.522526', N'Razer'),
(226, 'Razer Huntsman V3 Pro TKL Mechanical Keyboard', 5562600, N'TDP: 2W | Razer Analog Optical Switches Gen-2, Rapid Trigger mode with adjustable actuation (0.1- 4.0mm), Dual-purpose digital dial', N'https://m.media-amazon.com/images/I/81qBUNMtcLL._AC_.jpg', 15, 50, '2026-06-05 10:05:55.522526', N'Razer'),
(227, 'Razer BlackWidow V4 Pro Mechanical GamingKeyboard', 5816600, N'TDP: 2W | Razer Green Clicky / Yellow Linear Switches, Per-key & 3-sided underglow RGB, 8 dedicated macro keys', N'https://m.media-amazon.com/images/I/81L4FpeS3VL._AC_SL1500_.jpg', 15, 50, '2026-06-05 10:05:55.522526', N'Razer'),
(228, 'Razer BlackShark V2 Pro (2023 Edition) WirelessHeadset', 5054600, N'TDP: 1W | Razer HyperClear Super Wideband Mic, TriForce Titanium 50mm Drivers, Up to 70 hours', N'https://images-na.ssl-images-amazon.com/images/I/71Z9KK9-zvL.jpg', 17, 50, '2026-06-05 10:05:55.522526', N'Razer'),
(229, 'Samsung 990 PRO PCIe 4.0 NVMe M.2 SSD 2TB', 4546600, N'TDP: 9W | 2TB, Up to 7450 MB/s, Up to 6900 MB/s, Samsung Pascal Controller', N'https://images.samsung.com/is/image/samsung/p6pim/ca_fr/mz-v9p2t0b-am/gallery/ca-fr-990pro-nvme-m2-ssd-mz-v9p2t0b-am-534208574?$650_519_PNG$', 5, 50, '2026-06-05 10:05:55.522526', N'Samsung'),
(230, 'Samsung 990 EVO PCIe 4.0 x4 / 5.0 x2 M.2 SSD 1TB', 2260600, N'TDP: 9W | 1TB, Up to 5000 MB/s, Up to 4200 MB/s', N'https://images.samsung.com/is/image/samsung/p6pim/ca/mz-v9e1t0b-am/gallery/ca-990-evo-nvme-m2-ssd-mz-v9e1t0b-am-539584186?$650_519_PNG$', 5, 50, '2026-06-05 10:05:55.522526', N'Samsung'),
(231, 'Samsung T7 Shield Portable SSD 2TB', 4292600, N'TDP: 9W | 2TB, USB 3.2 Gen 2 (10Gbps), IP65 water & dust resistant, 3-meter drop proof', N'https://down-ph.img.susercontent.com/file/sg-11134275-7rd6w-m7rcerx9s5nrbc', 5, 50, '2026-06-05 10:05:55.522526', N'Samsung'),
(232, 'Samsung Odyssey OLED G9 (G95SC) Gaming Monitor', 40614600, N'TDP: 0W | 49-inch Curved Ultra-wide, 5120x1440 (Dual QHD), 240Hz, 0.03ms (GtG)', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/4bc7c582-c2db-4ce3-ab96-6c47e7521993.jpg', 6, 50, '2026-06-05 10:05:55.522526', N'Samsung'),
(233, 'Samsung Odyssey Ark Gen 2 Mini-LED Monitor', 63474600, N'TDP: 0W | 55-inch 1000R Curved, 3840x2160 (4K), 165Hz, Yes, rotates vertically', N'https://images-na.ssl-images-amazon.com/images/I/81nwxTmzMRL.jpg', 6, 50, '2026-06-05 10:05:55.522526', N'Samsung'),
(234, 'Samsung Galaxy Buds3 Pro', 6324600, N'TDP: 5W | Hi-Fi 24-bit Ultra High Quality Audio, Adaptive Noise Cancelling with Blade Lights, Stem style ergonomic fit', N'https://m.media-amazon.com/images/I/61Mv3cWzZeL._AC_SL1500_.jpg', 17, 50, '2026-06-05 10:05:55.522526', N'Samsung'),
(235, 'Kingston FURY Renegade DDR5 RGB 32GB (2x16GB) 7200MHz', 4292600, N'TDP: 15W | 32GB Kit, 7200 MT/s, CL38-44-44, 1.45V', N'https://img.evetech.co.za/repository/ProductImages/kingston-fury-renegade-rgb-32gb-7200mhz-ddr5-black-memory-1600px-v1-01.webp', 3, 50, '2026-06-05 10:05:55.522526', N'Kingston'),
(236, 'Kingston FURY Beast DDR5 32GB (2x16GB) 6000MHz', 3022600, N'TDP: 15W | 32GB Kit, 6000 MT/s, AMD EXPO / Intel XMP 3.0 certified', N'https://m.media-amazon.com/images/I/717cPftxQgL._AC_.jpg', 3, 50, '2026-06-05 10:05:55.522526', N'Kingston'),
(237, 'Kingston KC3000 PCIe 4.0 NVMe M.2 SSD 2TB', 3911600, N'TDP: 9W | 2TB, Up to 7000 MB/s, Up to 7000 MB/s, Phison E18', N'https://www.onoff.az/storage/uploads/products/onoff-2026-01-15t231256269-32101.jpg', 5, 50, '2026-06-05 10:05:55.522526', N'Kingston'),
(238, 'Kingston NV2 PCIe 4.0 NVMe M.2 SSD 1TB', 1625600, N'TDP: 9W | 1TB, Up to 3500 MB/s, Up to 2100 MB/s, M.2 2280', N'https://images.kabum.com.br/produtos/fotos/sync_mirakl/400812/SSD-1TB-Kingston-Nv2-M-2-2280-PCIe-NVMe-Leitura-3500MB-s-Grava-o-2100MB-s-Snv2s-1000g_1730146919_gg.jpg', 5, 50, '2026-06-05 10:05:55.522526', N'Kingston'),
(239, 'Kingston FURY Impact DDR5 SO-DIMM 32GB (2x16GB) 5600MHz', 3149600, N'TDP: 65W | Laptop Memory (SO-DIMM), 32GB Kit, 5600 MT/s', N'http://extra.md/public/products/thumbs/205027_32gb-ddr55600mhz-sodimm-kingston-fury-impact-9857901454477.jpg', 3, 50, '2026-06-05 10:05:55.522526', N'Kingston'),
(240, 'WD Red Pro NAS Internal Hard Drive 12TB', 7594600, N'TDP: 5W | 12TB, 7200 RPM, 256MB, SATA 6 Gb/s', N'https://m.media-amazon.com/images/I/71X-Co2yQgL._AC_.jpg', 10, 50, '2026-06-05 10:05:55.522526', N'WD'),
(241, 'Seagate IronWolf Pro 16TB NAS HDD', 8356600, N'TDP: 7W | 16TB, 550TB/year, Rotational Vibration (RV) sensors', N'https://i5.walmartimages.com/seo/Seagate-IronWolf-Pro-16TB-NAS-Hard-Drive-7200-RPM-256MB-Cache-CMR-SATA-6-0Gb-s-3-5-Internal-HDD-NE-ST16000NE000_ce14528e-ad18-4af3-aed0-35a74db6ecf3.d2fe1c875b4ae1ab2dfd13fd849edd5a.jpeg', 10, 50, '2026-06-05 10:05:55.522526', N'Seagate'),
(242, 'Noctua NH-D15 chromax.black Dual-Tower Cooler', 3022600, N'TDP: 5W | 2x NF-A15 HS-PWM fans, Full black design, Intel LGA1700/AM5 ready', N'https://os-jo.com/image/cache/catalog/products/ANOCTUA/NH-D15-BLACK/BLACK-1200x1200.JPEG', 13, 50, '2026-06-05 10:05:55.522526', N'Noctua'),
(243, 'NZXT H9 Flow Dual-Chamber Mid-Tower', 4038600, N'TDP: 0W | Wrap-around tempered glass pane, 4x F120Q Airflow fans, Up to 435mm', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6529/6529623cv11d.jpg', 12, 50, '2026-06-05 10:05:55.522526', N'NZXT'),
(244, 'NZXT Kraken Elite 360 RGB Liquid Cooler', 7594600, N'TDP: 15W | 360mm aluminum radiator, 2.36-inch wide-angle TFT-LCD display, 640x640 pixels', N'https://img.terabyteshop.com.br/produto/g/water-cooler-nzxt-kraken-elite-360-rgb-360mm-aio-lcd-display-black-intel-amd-rl-kr36e-b1_191056.jpg', 13, 50, '2026-06-05 10:05:55.522526', N'NZXT'),
(245, 'SteelSeries Arctis Nova Pro Wireless Headset', 8864600, N'TDP: 1W | Nova Pro Acoustic System, Active Noise Cancellation with Transparency Mode, Dual Battery Infinity System', N'https://images.hometheaterreview.com/htr-stateless/2025/07/646a3e4a-st