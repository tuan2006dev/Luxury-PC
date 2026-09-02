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
(245, 'SteelSeries Arctis Nova Pro Wireless Headset', 8864600, N'TDP: 1W | Nova Pro Acoustic System, Active Noise Cancellation with Transparency Mode, Dual Battery Infinity System', N'https://images.hometheaterreview.com/htr-stateless/2025/07/646a3e4a-steelseries-arctis-nova-pro-wireless-gaming-headset-scaled.jpg', 17, 50, '2026-06-05 10:05:55.522526', N'SteelSeries'),
(246, 'BenQ ZOWIE XL2566K 360Hz Esports Gaming Monitor', 15214600, N'TDP: 15W | 24.5-inch TN Panel, 360Hz, DyAc+ Technology motion blur reduction', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6539/6539682_sd.jpg', 6, 50, '2026-06-05 10:05:55.522526', N'BenQ'),
(247, 'Sony WH-1000XM5 Wireless Noise CancelingHeadphones', 10134600, N'TDP: 1W | Integrated Processor V1 & HD Noise CancelingProcessor QN1, 8 microphones for extreme voice pick up, Up to 30 hours total life', N'https://d1ncau8tqf99kp.cloudfront.net/converted/103364_original_local_1200x1050_v3_converted.webp', 17, 50, '2026-06-05 10:05:55.522526', N'Sony'),
(248, 'Crucial Pro DDR5 48GB (2x24GB) 5600MHz Kit', 3784600, N'TDP: 65W | 48GB Kit, 5600 MT/s, Low-profile aluminum black heatsink', N'https://a.allegroimg.com/original/116f3d/93c9c04d46c29c03260e9a12823a/SUPER-Pamiec-DDR5-Crucial-Pro-48GB-2x24GB-5600MHz-XMP-3-0-AMD-EXPO', 3, 50, '2026-06-05 10:05:55.522526', N'Crucial'),
(249, 'Fractal Design North Charcoal Black WoodMid-Tower', 3530600, N'TDP: 5W | Real walnut wood front panel struts, Mesh or Tempered Glass available, 2x Aspect 14 PWM fans', N'https://m.media-amazon.com/images/I/71MSloBQcCL._AC_.jpg', 12, 50, '2026-06-05 10:05:55.522526', N'Fractal Design'),
(250, 'Lian Li O11 Dynamic EVO RGB Black', 4292600, N'TDP: 0W | Dual-chamber adjustable ATX case, Two L-shaped diffuse LED RGB strips, Reversible design architecture', N'https://gitec.ge/images/thumbs/0073589_g99o11dergbx00.jpeg', 12, 50, '2026-06-05 10:05:55.522526', N'Lian Li'),
(251, 'Lian Li UNI FAN TL LCD 120 Triple Pack Black', 3784600, N'TDP: 4W | 120mm fans, Built-in 1.6-inch LCD screen on center fan, Daisy-chain interlocking mechanism', N'https://microless.com/cdn/products/01a0bf24eea1fcdb39621ce8e43485f5-hi.jpg', 14, 50, '2026-06-05 10:05:55.522526', N'Lian Li'),
(252, 'EVGA SuperNOVA 1000 G7 Gold Modular PSU', 4800600, N'TDP: 0W | 1000W, 80 PLUS Gold Certified, Ultra-compact 130mm chassis size', N'https://www.cyberpuerta.mx/img/product/XL/CP-EVGA-220-G7-1000-X1-87d9b7.jpg', 11, 50, '2026-06-05 10:05:55.522526', N'EVGA'),
(253, 'DeepCool AK620 Digital Dual-Tower Air Cooler', 2006600, N'TDP: 5W | Real-time temperature and usage status top screen, 2x FK120 fluid dynamic bearing fans, 6x 6mm copper heatpipes', N'https://down-my.img.susercontent.com/file/cn-11134207-7qukw-lfqke8nuk8jva1', 13, 50, '2026-06-05 10:05:55.522526', N'DeepCool'),
(254, 'Thermalright Peerless Assassin 120 SE AirCooler', 990600, N'TDP: 5W | Dual tower heatsink design, 2x TL-C12C 120mm PWM fans, 155mm standard height', N'https://m.media-amazon.com/images/I/71YEiWsyLlS._AC_.jpg', 13, 50, '2026-06-05 10:05:55.522526', N'Thermalright'),
(255, 'Be Quiet! Dark Power 13 1000W Titanium ATX 3.0PSU', 7340600, N'TDP: 65W', N'https://hwbusters.com/wp-content/uploads/2023/05/be-quiet-Dark-Power-13-1000W.jpg', 11, 50, '2026-06-05 10:05:55.522526', N'Intel'),
(256, 'Intel Core Ultra 7 265F (Tray)', 12000000, N'TDP: 125W', N'https://med.greatecno.com/1526371-large_default/intel-s1851-core-ultra-7-265f-tray.jpg', 1, 97, '2026-06-27 12:52:49.647', N'Intel'),
(257, N'Intel Core i5 12400F / 2.5GHz Turbo 4.4GHz (TRAY) - CHÍNH HÃNG', 2500000, N'TDP: 65W', N'https://cdn.hstatic.net/products/200000837185/12400f_tray_e59465bf117e4e778e5f568c39bc32b9_grande.png', 1, 99, '2026-06-27 12:52:50.064', N'Intel'),
(258, 'Intel Core i7 14700F (Tray)', 9500000, N'TDP: 65W', N'https://nguyencongpc.vn/media/product/250-26474-intel-core-i7-14700f-tray-new-010.jpg', 1, 100, '2026-06-27 12:52:50.462', N'Intel'),
(259, 'GIGABYTE Z890 EAGLE WIFI7 (DDR5)', 7500000, N'TDP: 40W', N'https://m.media-amazon.com/images/I/81G2my+RKeL._AC_.jpg', 4, 97, '2026-06-27 12:52:50.891', N'GIGABYTE'),
(260, 'GIGABYTE H610M-H V3 (DDR4)', 1800000, N'TDP: 30W', N'https://media.ldlc.com/r1600/ld/products/00/06/12/72/LD0006127276.jpg', 4, 99, '2026-06-27 12:52:51.326', N'GIGABYTE'),
(261, 'GIGABYTE B760M GAMING PLUS WIFI DDR4', 3500000, N'TDP: 40W', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3701/innergigabyteimages/kf-img.png', 4, 100, '2026-06-27 12:52:51.741', N'GIGABYTE'),
(262, 'RAM Kingmax Horizon 16GB DDR5 Bus 5600Mhz', 1200000, N'TDP: 10W', N'https://cdn.hstatic.net/products/1000361104/1_9aef94b8600b4a80a74401e379b2dd4c.jpg', 3, 97, '2026-06-27 12:52:52.239', N'Kingmax'),
(263, 'Ram KingSpec Heatsink Red 1x16GB DDR4 Bus 3200Mhz', 750000, N'TDP: 10W', N'https://cdn.hstatic.net/products/200000722513/ram-kingspec-heatsink-red-1x16gb-ddr4-bus-3200mhz-1_23edecb668f84ae783d00d77d8a23b83.jpg', 3, 100, '2026-06-27 12:52:52.718', N'KingSpec'),
(264, 'MSI GeForce RTX 5070 Ti 16GB Shadow 3X OC', 25000000, N'TDP: 250W', N'https://asset.msi.com/resize/image/global/product/product_1738649851f99734cac740c6f5eba83717cf3dfcc1.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 9, 99, '2026-06-27 12:52:53.246', N'MSI'),
(265, 'GIGABYTE GeForce RTX 5080 WINDFORCE OC SFF 16G', 35000000, N'TDP: 300W', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3886/innergigabyte/images/features-img.png', 9, 98, '2026-06-27 12:52:53.742', N'GIGABYTE'),
(266, 'MSI GeForce RTX 5060 Ventus 2X OC 8GB', 8500000, N'TDP: 150W', N'https://asset.msi.com/resize/image/global/product/product_17452877802adc1ee82075afaeea7d2a2dcf366cb9.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 9, 100, '2026-06-27 12:52:54.227', N'MSI'),
(267, 'ZOTAC GeForce RTX 5060 Ti 8GB TWIN EDGE GDDR7', 11000000, N'TDP: 160W', N'https://www.kccshop.vn/media/product/250-13410-vga-zotac-gaming-geforce-rtx-5060-ti-8gb-twin-edge-oc-white-edition--zt-b50610q-10m-_4_main.jpeg', 9, 100, '2026-06-27 12:52:54.716', N'NVIDIA'),
(268, N'Ổ cứng SSD Kingston NV3 1TB M.2 PCIe NVMe Gen4', 1800000, N'TDP: 10W', N'https://down-ph.img.susercontent.com/file/sg-11134201-7rdw7-lzr1u0ea362c97', 7, 97, '2026-06-27 12:52:55.209', N'Kingston'),
(269, N'Ổ Cứng SSD KingSpec NVMe 512GB (NE-512)', 800000, N'TDP: 10W', N'https://hmpcstore.com/admin/uploads/O-cung-SSD-KingSpec-NE-512GB-PCIe-Gen3-x4-NVMe-M2-2280-NE-512/20260225_101548_0_699e696480d03_710__ne-5122-1__1__8d84d40669de4ec497acc541f607579f_grande.jpg', 7, 100, '2026-06-27 12:52:55.693', N'KingSpec'),
(270, 'Corsair RM850e ATX 3.1 - 80 Plus Gold - Full Modular (850W)', 3500000, N'TDP: 0W', N'https://product.hstatic.net/200000722513/product/89689_nguon_may_tinh_corsair_rm850e_atx_006_e59a3ebce3034f23aa2bde43f1d242e5_1024x1024.jpg', 11, 97, '2026-06-27 12:52:56.192', N'Corsair'),
(271, 'Cooler Master MWE 650 - 80 Plus Bronze - V3 230V (650W)', 1500000, N'TDP: 0W', N'https://os-jo.com/image/cache/catalog/products/power-supply/MPE-6501-ACAAW-3BUK/81TVrRqQJeL._SL1500_-1200x1200.jpg', 11, 100, '2026-06-27 12:52:56.68', N'Cooler Master'),
(272, N'Nguồn FSP HV PRO 650W - 80 Plus Bronze', 1400000, N'TDP: 0W', N'https://down-vn.img.susercontent.com/file/vn-11134211-820l4-mjf8qo64x91ha6', 11, 100, '2026-06-27 12:52:57.17', N'FSP'),
(273, 'Corsair CX650 - 80 Plus Bronze (650W)', 1600000, N'TDP: 0W', N'https://www.bhphotovideo.com/images/fb/corsair_cp_9020278_na_cx_series_cx650_650w_1808744.jpg', 11, 100, '2026-06-27 12:52:57.668', N'Corsair'),
(274, 'Corsair 3500X TG Mid Tower Black', 2000000, N'TDP: 0W', N'https://philong.com.vn/media/product/33615-vo-case-corsair-3500x-argb-mid-tower-tg-black-cc-9011278-ww-philong--5-.png', 12, 99, '2026-06-27 12:52:58.157', N'Corsair'),
(275, 'Corsair FRAME 4500X RS-R ARGB Panoramic Black', 3500000, N'TDP: 0W', N'https://www.pcstudio.in/wp-content/uploads/2025/09/Corsair-Frame-4500X-RS-R-ARGB-Panoramic-Glass-Mid-Tower-E-ATX-Cabinet-Black-2-600x600.webp', 12, 98, '2026-06-27 12:52:58.657', N'Corsair'),
(276, N'Tản nhiệt AIO Corsair NAUTILUS 360 ARGB Black', 2800000, N'TDP: 15W', N'https://phucanhcdn.com/media/product/58804_tan_nhiet_nuoc_aio_corsair_nautilus_360_argb_black_cw_9060093_ww_2.jpg', 8, 97, '2026-06-27 12:52:59.35', N'Corsair'),
(277, 'Cooler Master Hyper 212 Spectrum V3 ARGB', 600000, N'TDP: 5W', N'https://c1.neweggimages.com/BizIntell/item/ACCS%20-%20PC/CPU%20Cooling/35-103-357/hyper-212-spectrum-v3_01.jpg', 8, 99, '2026-06-27 12:52:59.845', N'Cooler Master'),
(278, 'Intel Core i9 14900K (Tray)', 14000000, N'TDP: 125W', N'https://pcngon.vn/wp-content/uploads/2024/11/CPU-Intel-Core-i9-14900K-Tray-2.4GHz-Turbo-5.8GHz-24-nhan-32-luong-1.jpg', 1, 100, '2026-06-27 13:16:14.081', N'Intel'),
(279, 'Intel Core Ultra 9 285K', 16500000, N'TDP: 125W', N'https://images.versus.io/objects/intel-core-ultra-9-285k.front.variety.1729100341269.jpg', 1, 49, '2026-06-27 13:16:14.752', N'Intel'),
(280, 'ASUS ROG MAXIMUS Z790 HERO', 15000000, N'TDP: 60W', N'https://dlcdnwebimgs.asus.com/gain/A3777166-EF70-4D33-915B-EC65CF77CAE5', 4, 100, '2026-06-27 13:16:16.445', N'ASUS'),
(281, 'ProArt Z790-CREATOR WIFI', 12000000, N'TDP: 55W', N'https://dlcdnwebimgs.asus.com/gain/fe64f38f-9f58-4722-b2b0-723379b316be/', 4, 100, '2026-06-27 13:16:16.974', N'ASUS'),
(282, 'Corsair Dominator Titanium 64GB', 6500000, N'TDP: 15W', N'https://m.media-amazon.com/images/I/611o1NX2HvL._AC_SL1500_.jpg', 3, 100, '2026-06-27 13:16:18.101', N'Corsair'),
(283, 'G.Skill Trident Z5 64GB DDR5', 5500000, N'TDP: 15W', N'https://c1.neweggimages.com/ProductImageCompressAll1280/20-374-432-07.png', 3, 100, '2026-06-27 13:16:18.602', N'G.Skill'),
(284, 'ASUS ROG Strix RTX 5090 24GB', 65000000, N'TDP: 450W', N'https://cdn-ru.bitrix24.ru/b11322588/landing/90e/90ed69e925e824a07ca15eb1b5d9bc42/asus_rog_astral_geforce_rtx_5090_32gb_gddr7_oc_edition_16_1x.png', 9, 100, '2026-06-27 13:16:33.267', N'ASUS'),
(285, 'Samsung 990 PRO 2TB', 4500000, N'TDP: 15W', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6523/6523595cv11d.jpg', 7, 100, '2026-06-27 13:16:34.196', N'Samsung'),
(286, 'ROG Ryujin III 360 ARGB', 8500000, N'TDP: 125W', N'https://dlcdnwebimgs.asus.com/gain/A1D6D78A-00BE-4F89-A360-2790312CDDAD', 8, 108, '2026-06-27 13:16:36.609', N'Intel'),
(287, N'Thẻ nhớ SanDisk Extreme Pro 128GB MicroSDXC UHS-I 200MB/s', 650000, N'TDP: 2W', N'https://bizweb.dktcdn.net/100/533/247/products/1658759624-img-1802164.jpg?v=1754561963193', 4, 100, '2026-07-23 10:00:00.000', N'SanDisk'),
(288, N'Thẻ nhớ Samsung PRO Plus 256GB MicroSDXC kèm Đầu đọc USB', 950000, N'TDP: 2W', N'https://bizweb.dktcdn.net/thumb/grande/100/490/762/products/the-nho-microsdxc-samsung-pro-plus-u3-256gb-05-jpg-v-1715014985150-jpg-v-1715201603263.jpg?v=1716191494470', 4, 80, '2026-07-23 10:00:00.000', N'Samsung'),
(289, N'Thẻ nhớ Lexar Professional 1066x 512GB MicroSDXC UHS-I', 1450000, N'TDP: 3W', N'http://compro.com.vn/uploads/product/23_08_2023/2.png', 4, 50, '2026-07-23 10:00:00.000', N'Lexar'),
(290, N'Thẻ nhớ Kingston Canvas Go! Plus 128GB SDXC UHS-I', 580000, N'TDP: 2W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m1bljvpi8efwca', 4, 120, '2026-07-23 10:00:00.000', N'Kingston'),
(291, N'Thẻ nhớ SanDisk Ultra SDXC 64GB 140MB/s Class 10', 280000, N'TDP: 1W', N'https://bizweb.dktcdn.net/100/513/826/products/web-bia-the-sd-trang-xam-64gb.png?v=1767153744330', 4, 150, '2026-07-23 10:00:00.000', N'SanDisk'),
(292, N'Thẻ nhớ Transcend SDXC 330S 128GB High Speed 100MB/s', 520000, N'TDP: 2W', N'https://bestcomputers.mn/storage/products/abb127a0b29bc93.png', 4, 90, '2026-07-23 10:00:00.000', N'Transcend'),
(293, N'Thẻ nhớ ProGrade Digital SDXC UHS-II V60 256GB', 2800000, N'TDP: 3W', N'https://haliti.com.vn/wp-content/uploads/2023/05/the-nho-prograde-digital-SDXC-UHS-II-V60-250R-256gb-haliti-01.jpg', 4, 30, '2026-07-23 10:00:00.000', N'ASUS'),
(294, N'Thẻ nhớ Sony TOUGH SF-G Series 128GB SDXC UHS-II 300MB/s', 4200000, N'TDP: 3W', N'https://cdn.vjshop.vn/phu-kien-nhiep-anh/the-nho/the-sd/the-nho-sony-sdxc-128gb-sf-g-series-tough-uhs-ii/sony-sdxc-128gb-sf-g-series-tough-uhs-ii-1.jpg', 4, 25, '2026-07-23 10:00:00.000', N'Sony'),
(295, N'Thẻ nhớ Kioxia Exceria High Endurance 128GB MicroSD', 480000, N'TDP: 2W', N'https://tuanphong.vn/pictures/full/2020/08/1598000458-172-the-nho-128gb-microsd-kioxia-exceria-high-endurance-2.jpg', 4, 110, '2026-07-23 10:00:00.000', N'Kioxia'),
(296, N'Thẻ nhớ TeamGroup GO Card MicroSDXC 256GB 100MB/s', 720000, N'TDP: 2W', N'https://images.teamgroupinc.com/products/card/microsd/go-card/msdxc/256gb_adpt_01.jpg', 4, 75, '2026-07-23 10:00:00.000', N'TeamGroup'),
(297, N'Ổ cứng di động SSD SanDisk Extreme Portable 1TB USB 3.2 Gen 2', 2650000, N'TDP: 5W', N'https://hanoicomputercdn.com/media/product/70740_o_cung_di_dong_sandisk_extreme_pro_portable_ssd_1tb_usb_3__7_.jpg', 8, 60, '2026-07-23 10:00:00.000', N'SanDisk'),
(298, N'Ổ cứng di động Samsung T7 Shield 2TB Type-C Chống sốc IP65', 4850000, N'TDP: 5W', N'https://media.karousell.com/media/photos/products/2023/10/20/samsung_t7_shield_2tb_beige_co_1697782299_2da3fdf9.jpg', 8, 45, '2026-07-23 10:00:00.000', N'Samsung'),
(299, N'Ổ cứng di động HDD WD My Passport 2TB USB 3.0 Black', 1950000, N'TDP: 5W', N'https://atechworld.vn/wp-content/uploads/2024/01/wd-my-passport-2tb-1-1.jpg', 8, 80, '2026-07-23 10:00:00.000', N'WD'),
(300, N'Ổ cứng di động SSD Crucial X9 Pro 1TB 1050MB/s Vỏ nhôm', 2450000, N'TDP: 4W', N'https://tuanphong.vn/pictures/full/2024/06/1717476599-965-crucial-x9pro-d.jpg', 8, 50, '2026-07-23 10:00:00.000', N'Crucial'),
(301, N'Ổ cứng gắn ngoài HDD Seagate Expansion Desktop 8TB 3.5 inch', 4900000, N'TDP: 10W', N'https://down-id.img.susercontent.com/file/id-11134207-7r992-lz4iwty51s8092', 8, 30, '2026-07-23 10:00:00.000', N'Seagate'),
(302, N'Ổ cứng di động HDD Lacie Rugged Mini 2TB USB 3.0 Chống dằn xóc', 2800000, N'TDP: 5W', N'https://www.bhphotovideo.com/images/fb/lacie_9000298_rugged_mini_disk_2tb_1039044.jpg', 8, 40, '2026-07-23 10:00:00.000', N'LaCie'),
(303, N'Ổ cứng di động SSD Kingston XS2000 1TB Type-C 2000MB/s Siêu nhỏ', 2950000, N'TDP: 5W', N'https://lagihitech.vn/wp-content/uploads/2024/04/o-cung-di-dong-SSD-Kingston-XS2000-1TB-SXS20001000G-hinh-1.jpg', 8, 35, '2026-07-23 10:00:00.000', N'Kingston'),
(304, N'Ổ cứng di động HDD Transcend StoreJet 25M3 1TB Chống sốc 3 lớp', 1650000, N'TDP: 5W', N'https://enhakkore.net/wp-content/uploads/2018/07/TRANSCEND-1TB.jpg', 8, 70, '2026-07-23 10:00:00.000', N'Transcend'),
(305, N'Ổ cứng di động SSD Corsair EX100U 2TB Type-C USB 3.2 Gen2x2', 4200000, N'TDP: 5W', N'https://hoangkhue.vn/wp-content/uploads/2024/08/250-10284-o-cung-ssd-corsair-ex100u-1tb-1-.jpg', 8, 25, '2026-07-23 10:00:00.000', N'Corsair'),
(306, N'Ổ cứng di động SSD ADATA SE880 1TB Type-C 2000MB/s', 2550000, N'TDP: 4W', N'https://down-sg.img.susercontent.com/file/sg-11134207-7rdx0-lxxvt9dyai734a', 8, 55, '2026-07-23 10:00:00.000', N'ADATA'),
(307, N'Tản nhiệt nước AIO NZXT Kraken Elite 360 RGB White LCD', 7250000, N'TDP: 15W', N'https://azaudio.vn/wp-content/uploads/2024/12/nzxt-kraken-elite-360-rgb-white-1.jpg', 9, 30, '2026-07-23 10:00:00.000', N'NZXT'),
(308, N'Tản nhiệt nước AIO Corsair iCUE LINK H150i LCD White 360mm', 6800000, N'TDP: 15W', N'https://philong.com.vn/media/product/31944-tan-nhiet-nuoc-cpu-aio-corsair-icue-link-h150i-rgb-360mm-white-cw-9061006-ww-philong--10-.jpg', 9, 25, '2026-07-23 10:00:00.000', N'Corsair'),
(309, N'Tản nhiệt nước AIO ASUS ROG Ryujin III 360 ARGB White Edition', 8900000, N'TDP: 20W', N'https://cdn.hstatic.net/products/200000522285/71tqdctsyil._sl1500_3d133254025a4566b8a6b75de0177edc.jpg', 9, 20, '2026-07-23 10:00:00.000', N'ASUS'),
(310, N'Tản nhiệt nước AIO MSI MAG CORELIQUID E360 Black', 3450000, N'TDP: 12W', N'https://philong.com.vn/media/product/32659-tan-nhiet-nuoc-aio-cpu-msi-mag-coreliquid-e360-black-philong--3-.png', 9, 50, '2026-07-23 10:00:00.000', N'MSI'),
(311, N'Tản nhiệt nước AIO DeepCool LT720 360mm High-Performance', 3650000, N'TDP: 15W', N'https://product.hstatic.net/1000333506/product/n-nuoc-aio-deepcool-lt720-7_33b321d32ef447a4b060ea862d2c3c3a_1024x1024_3d97403a18dd4741a07d41ea8b3e458c.jpg', 9, 40, '2026-07-23 10:00:00.000', N'DeepCool'),
(312, N'Tản nhiệt nước AIO Lian Li Galahad II Trinity SL-INF 360 White', 4950000, N'TDP: 15W', N'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mgvopvat08i6a8', 9, 35, '2026-07-23 10:00:00.000', N'Lian Li'),
(313, N'Tản nhiệt nước AIO Cooler Master MasterLiquid 360 Atmos ARGB', 3850000, N'TDP: 12W', N'https://cdn.hstatic.net/products/200000921511/tan_nhiet_nuoc_aio_cooler_master_masterliquid_360_atmos_ii_lcd_argb__1b2b1d1b61bb4c83bef81b7188d48fa8_1024x1024.jpg', 9, 45, '2026-07-23 10:00:00.000', N'Cooler Master'),
(314, N'Tản nhiệt nước AIO Thermalright Frozen Prism 360 ARGB Black', 1850000, N'TDP: 10W', N'https://product.hstatic.net/200000420363/product/4_fc0894cf23c34545b98c502be9363f3e_master.jpg', 9, 70, '2026-07-23 10:00:00.000', N'Thermalright'),
(315, N'Tản nhiệt nước AIO Valkyrie GL360 ARGB Màn hình LCD Black', 4200000, N'TDP: 15W', N'https://gland.vn/media/product/15140_81374_t___n_nhi___t_n_____c_valkyrie_gl360___en__2_.jpg', 9, 30, '2026-07-23 10:00:00.000', N'Valkyrie'),
(316, N'Tản nhiệt nước AIO ID-COOLING DASHFLOW 360 Basic Black', 1650000, N'TDP: 10W', N'https://tanphat.com.vn/media/product/5969_51818_tan_nhiet_nuoc_aio_id_cooling_dashflow_360_basic_black_3.jpg', 9, 80, '2026-07-23 10:00:00.000', N'ID-COOLING'),
(317, N'Card màn hình GIGABYTE GeForce RTX 4070 Ti SUPER WINDFORCE OC 16G', 23900000, N'TDP: 285W', N'https://product.hstatic.net/200000722513/product/geforce_rtx__4070_ti_super_gaming_oc_16g-01_948cbd78b02643aeb972232ee5e9cc05.png', 10, 25, '2026-07-23 10:00:00.000', N'GIGABYTE'),
(318, N'Card màn hình ASUS TUF Gaming GeForce RTX 4080 SUPER 16GB GDDR6X', 31500000, N'TDP: 320W', N'https://www.tnc.com.vn/uploads/product/sp2024/card-man-hinh-asus-tuf-rtx4080s-o16g-gaming.jpg', 10, 20, '2026-07-23 10:00:00.000', N'ASUS'),
(319, N'Card màn hình MSI GeForce RTX 4060 Ti GAMING X SLIM 16G', 12800000, N'TDP: 165W', N'https://product.hstatic.net/200000722513/product/rtx_4060_ti_gaming_x_slim_16g_a214d2ab8d5b4c72885ff81cf695918d.png', 10, 40, '2026-07-23 10:00:00.000', N'MSI'),
(320, N'Card màn hình ZOTAC GAMING GeForce RTX 4070 SUPER Twin Edge OC 12GB', 16900000, N'TDP: 220W', N'https://halinhcomputer.vn/uploads/images/web-halinh-new/linh-kien-le/vga/zotac/rtx-4070-twin-edge-oc-12gb-gddr6x.png', 10, 35, '2026-07-23 10:00:00.000', N'NVIDIA'),
(321, N'Card màn hình GALAX GeForce RTX 4070 Ti SUPER EX Gamer White 16GB', 24500000, N'TDP: 285W', N'https://khanhlinhpc.vn/hinh-anh/san-pham/4070ti-super-exg-w-02.png', 10, 18, '2026-07-23 10:00:00.000', N'NVIDIA'),
(322, N'Card màn hình PowerColor Hellhound AMD Radeon RX 7900 XT 20GB', 21500000, N'TDP: 315W', N'https://m.media-amazon.com/images/I/814keJHzlgL._AC_.jpg', 10, 15, '2026-07-23 10:00:00.000', N'AMD'),
(323, N'Card màn hình Sapphire NITRO+ AMD Radeon RX 7800 XT 16GB', 15800000, N'TDP: 263W', N'https://cdn.sicomp.vn/cache/large/product/5552/5552_card-man-hinh-sapphire-nitro-amd-radeon-rx-7800-xt_1.webp', 10, 30, '2026-07-23 10:00:00.000', N'AMD'),
(324, N'Card màn hình XFX Speedster MERC 310 AMD Radeon RX 7900 GRE 16GB', 16950000, N'TDP: 260W', N'https://cdn.prod.website-files.com/5d1911406ad3cbdb9924a753/639736d43e89781c8b59f26d_03.jpg', 10, 22, '2026-07-23 10:00:00.000', N'AMD'),
(325, N'Card màn hình COLORFUL iGame GeForce RTX 4070 SUPER Ultra W OC 12GB', 17900000, N'TDP: 220W', N'https://nguyencongpc.vn/media/product/26203-z5083848788059_6fd23c6d5c495549bd8c0c3277d7842e_18_11zon.jpg', 10, 28, '2026-07-23 10:00:00.000', N'NVIDIA'),
(326, N'Card màn hình ASRock Phantom Gaming Radeon RX 7700 XT 12GB OC', 12500000, N'TDP: 245W', N'https://media.ldlc.com/r1600/ld/products/00/06/06/20/LD0006062055.jpg', 10, 30, '2026-07-23 10:00:00.000', N'AMD'),
(327, N'Ổ cứng HDD PC Seagate Barracuda 2TB 3.5 inch SATA3 7200rpm', 1550000, N'TDP: 6W', N'https://down-vn.img.susercontent.com/file/77d9291cc7bf7b9a179cfa099e3e10d8', 11, 100, '2026-07-23 10:00:00.000', N'Seagate'),
(328, N'Ổ cứng HDD PC Western Digital Blue 2TB 3.5 inch 7200rpm', 1480000, N'TDP: 6W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m8x69xif6p36b1', 11, 110, '2026-07-23 10:00:00.000', N'WD'),
(329, N'Ổ cứng HDD PC Toshiba P300 2TB 3.5 inch SATA3 7200rpm', 1390000, N'TDP: 6W', N'https://hoanghapccdn.com/media/product/5135_hdd_toshiba_p300_2tb_ha2.jpg', 11, 90, '2026-07-23 10:00:00.000', N'Toshiba'),
(330, N'Ổ cứng HDD Server Seagate IronWolf 4TB 3.5 inch NAS SATA3', 2950000, N'TDP: 7W', N'https://www.kccshop.vn/media/product/250-10927-----c---ng-hdd-seagate-ironwolf-4tb--3-5-inch--5400rpm--sata3--256mb-cache--st4000vn006-_2.jpeg', 11, 60, '2026-07-23 10:00:00.000', N'Seagate'),
(331, N'Ổ cứng HDD Server Western Digital Red Plus 4TB 3.5 inch NAS', 3100000, N'TDP: 7W', N'https://www.tnc.com.vn/uploads/product/sp2026/o-cung-hdd-gan-trong-western-digital-red-plus-4tb-wd40efzz.webp', 11, 55, '2026-07-23 10:00:00.000', N'WD'),
(332, N'Ổ cứng HDD Enterprise Seagate Exos X18 16TB 3.5 inch SATA3', 8500000, N'TDP: 9W', N'https://qnapvn.com/o-cung-hdd-seagate-enterprise-exos-35-sata-7e8-16tb-st16000nm000j-2.png', 11, 20, '2026-07-23 10:00:00.000', N'Seagate'),
(333, N'Ổ cứng HDD Enterprise Western Digital Gold 8TB 3.5 inch 7200rpm', 5900000, N'TDP: 8W', N'https://mygear.io.vn/media/product/6102-wd-gold-3-5.jpg', 11, 30, '2026-07-23 10:00:00.000', N'WD'),
(334, N'Ổ cứng HDD PC Toshiba X300 4TB 7200rpm Gaming Internal', 3250000, N'TDP: 8W', N'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/93/MTA-9352335/toshiba_toshiba_x300_4tb_sata_3_cache_128mb_7200rpm_-_hdd_internal_pc_full03_mcg4oh8k.jpg', 11, 40, '2026-07-23 10:00:00.000', N'Toshiba'),
(335, N'Ổ cứng HDD PC Western Digital Black 1TB 3.5 inch Performance', 1850000, N'TDP: 7W', N'https://www.westerndigital.com/content/dam/store/en-us/assets/products/internal-storage/wd-black-desktop-sata-hdd/gallery/wd-black-desktop-1tb.png', 11, 75, '2026-07-23 10:00:00.000', N'WD'),
(336, N'Ổ cứng HDD Camera Seagate SkyHawk 4TB 3.5 inch Surveillance', 2650000, N'TDP: 6W', N'https://lapvip.com.vn/upload/anh-san-pham/70221-o-cung-hdd-seagate-skyhawk-4tb-3-2-1920x.jpg', 11, 80, '2026-07-23 10:00:00.000', N'Seagate'),
(337, N'Nguồn Corsair RM750e ATX 3.0 80 Plus Gold Full Modular (750W)', 2850000, N'TDP: 0W', N'https://cdn.mwave.com.au/images/400/rm750e_ac62522_75331.jpg', 12, 60, '2026-07-23 10:00:00.000', N'Corsair'),
(338, N'Nguồn MSI MAG A750GL PCIE5 750W 80 Plus Gold Full Modular', 2650000, N'TDP: 0W', N'https://m.media-amazon.com/images/I/716c-SjLwPL.jpg', 12, 70, '2026-07-23 10:00:00.000', N'MSI'),
(339, N'Nguồn GIGABYTE UD850GM PG5 850W 80 Plus Gold PCIe 5.0', 3100000, N'TDP: 0W', N'https://techarc.pk/wp-content/uploads/2026/01/gigabyte-gp-ud850gm-pg5-850w-80-plus-gold-power-supply-1-techarc.pk_.webp', 12, 50, '2026-07-23 10:00:00.000', N'GIGABYTE'),
(340, N'Nguồn ASUS TUF Gaming 750W 80 Plus Bronze', 2150000, N'TDP: 0W', N'https://songphuong.vn/Content/uploads/2025/06/TUF-Gaming-750W-Bronze-1.webp', 12, 80, '2026-07-23 10:00:00.000', N'ASUS'),
(341, N'Nguồn Cooler Master MWE Gold 850 V2 Full Modular (850W)', 2950000, N'TDP: 0W', N'https://songphuong.vn/Content/uploads/2021/08/Nguon-Cooler-Master-MWE-GOLD-850-V2-Full-Modular-850W-songphuong.vn_.jpg', 12, 65, '2026-07-23 10:00:00.000', N'Cooler Master'),
(342, N'Nguồn DeepCool PL750D 750W 80 Plus Bronze ATX 3.0 Native', 1750000, N'TDP: 0W', N'https://phucanhcdn.com/media/product/61221_nguon_may_tinh_deepcool_pl750d_750w_80_plus_bronze_atx_3_0_pcie_5_5.jpg', 12, 90, '2026-07-23 10:00:00.000', N'DeepCool'),
(343, N'Nguồn Super Flower Leadex III Gold 850W ARGB Full Modular', 3450000, N'TDP: 0W', N'https://down-my.img.susercontent.com/file/27e5251ee99cf1d947ce9d44aacbb258', 12, 40, '2026-07-23 10:00:00.000', N'Super Flower'),
(344, N'Nguồn Seasonic Focus GX-850 850W 80 Plus Gold Full Modular', 3650000, N'TDP: 0W', N'https://bgamer.pro/wp-content/uploads/2024/02/850w-seasonic-4.jpg', 12, 45, '2026-07-23 10:00:00.000', N'Seasonic'),
(345, N'Nguồn FSP Hydro G PRO 850W PCIe5.0 80 Plus Gold', 3350000, N'TDP: 0W', N'https://smart1ech.com/wp-content/uploads/2023/10/www.fspgroupusa.com-HG2-850W-5G-36.png', 12, 50, '2026-07-23 10:00:00.000', N'Logitech'),
(346, N'Nguồn Thermaltake Toughpower GF A3 850W Gold ATX 3.0', 2950000, N'TDP: 0W', N'https://cdn.mwave.com.au/images/400/thermaltake_toughpower_gf_a3_1050w_80_gold_pcie_gen5_atx_30_fully_modular_psu_ac62361_24452.jpg', 12, 55, '2026-07-23 10:00:00.000', N'Thermaltake'),
(347, N'Vỏ case NZXT H6 Flow RGB Dual-Chamber Mid-Tower Black', 3450000, N'TDP: 0W', N'https://c1.neweggimages.com/productimage/nb1280/11-146-359-05.jpg', 13, 40, '2026-07-23 10:00:00.000', N'NZXT'),
(348, N'Vỏ case Lian Li O11 Vision Tempered Glass Mid-Tower White', 3950000, N'TDP: 0W', N'https://i5.walmartimages.com/seo/LIAN-LI-O11-Vision-White-Aluminum-Steel-Tempered-Glass-ATX-Mid-Tower-Computer-Case-O11VW_8a75551b-e1fb-4b80-8cd4-a1db5126b46a.8bf544a2a9b5dedc9213b95788327938.jpeg', 13, 35, '2026-07-23 10:00:00.000', N'Lian Li'),
(349, N'Vỏ case Corsair 4000D AIRFLOW Tempered Glass Mid-Tower Black', 2150000, N'TDP: 0W', N'https://m.media-amazon.com/images/I/81hL4tPkXZL._AC_SL1500_.jpg', 13, 80, '2026-07-23 10:00:00.000', N'Corsair'),
(350, N'Vỏ case Montech KING 95 PRO Panoramic Curved Glass ARGB Black', 3650000, N'TDP: 0W', N'https://ascenti.co.th/main/wp-content/uploads/2024/08/MONTECH-KING-95-PRO-Black.jpg', 13, 30, '2026-07-23 10:00:00.000', N'Montech'),
(351, N'Vỏ case HYTE Y60 Panoramic Dual Chamber Glass Black/Red', 5450000, N'TDP: 0W', N'https://m.media-amazon.com/images/I/71TuyBKv0UL.jpg', 13, 20, '2026-07-23 10:00:00.000', N'HYTE'),
(352, N'Vỏ case Antec C8 Dual-Chamber Full Tower Black', 2850000, N'TDP: 0W', N'http://dynaquestpc.com/cdn/shop/files/146_95625c7a-de2e-4025-8358-3a91733300f2.png?crop=center&height=1200&v=1714810776&width=1200', 13, 45, '2026-07-23 10:00:00.000', N'Antec'),
(353, N'Vỏ case Fractal Design Pop Air RGB TG Black', 2450000, N'TDP: 0W', N'https://mygear.io.vn/media/product/9794-vo-case-fractal-design-pop-air-rgb-black-tg-clear-4.png', 13, 50, '2026-07-23 10:00:00.000', N'Fractal Design'),
(354, N'Vỏ case DeepCool CH560 DIGITAL ARGB Màn hình nhiệt độ Black', 2650000, N'TDP: 0W', N'https://www.tncstore.vn/media/product/9099-vo-case-deepcool-ch560-digital-2.jpg', 13, 60, '2026-07-23 10:00:00.000', N'DeepCool'),
(355, N'Vỏ case Xigmatek ENDORPHIN ULTRA ARTIC White Panoramic', 1450000, N'TDP: 0W', N'https://nvs.tn-cdn.net/2023/08/vo-case-xigmatek-endorphin-ultra-arctic_01.jpg', 13, 90, '2026-07-23 10:00:00.000', N'Xigmatek'),
(356, N'Vỏ case Phanteks NV5 Mid-Tower ARGB Black Glass', 2750000, N'TDP: 0W', N'https://images.tokopedia.net/img/cache/900/VqbcmM/2023/11/30/459f4cd1-d894-4066-a304-09372696e580.jpg', 13, 40, '2026-07-23 10:00:00.000', N'Phanteks'),
(357, N'Tản nhiệt khí Thermalright Peerless Assassin 120 SE ARGB', 980000, N'TDP: 5W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mde35e6fewkcc0', 14, 100, '2026-07-23 10:00:00.000', N'Thermalright'),
(358, N'Tản nhiệt khí DeepCool AK400 Digital ARGB Màn hình LED Black', 1150000, N'TDP: 4W', N'https://www.deepcool.com/public/ProductFile/DEEPCOOL/Cooling/CPUAirCoolers/AK400_DIGITAL/Gallery/4000X4000/03.png', 14, 80, '2026-07-23 10:00:00.000', N'DeepCool'),
(359, N'Tản nhiệt khí Noctua NH-D15 chromax.black Dual-Tower Premium', 2950000, N'TDP: 5W', N'https://os-jo.com/image/cache/catalog/products/ANOCTUA/NH-D15-BLACK/BLACK-1200x1200.JPEG', 14, 35, '2026-07-23 10:00:00.000', N'Noctua'),
(360, N'Tản nhiệt khí ID-COOLING SE-224-XT ARGB V2 Black', 520000, N'TDP: 3W', N'https://product.hstatic.net/1000262653/product/z4299420230640_8445263c7cf679422f5efeef9d30572d_e3ca58a2214f4bcfaf2231ff9a9bf482_master.jpg', 14, 120, '2026-07-23 10:00:00.000', N'ID-COOLING'),
(361, N'Tản nhiệt khí Cooler Master Hyper 622 Halo Black ARGB Dual-Tower', 1350000, N'TDP: 5W', N'http://kccshop.vn/media/product/250-5123-1.jpg', 14, 60, '2026-07-23 10:00:00.000', N'Cooler Master'),
(362, N'Tản nhiệt khí Jonsbo CR-1000 EVO ARGB Black', 380000, N'TDP: 3W', N'https://nvs.tn-cdn.net/2023/07/tan-nhiet-khi-jonsbo-cr-1000-evo-argb-6.jpg', 14, 150, '2026-07-23 10:00:00.000', N'Jonsbo'),
(363, N'Tản nhiệt khí Thermalright Phantom Spirit 120 EVO 7 Heatpipes', 1280000, N'TDP: 5W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m0wqvyxlqdkd17', 14, 75, '2026-07-23 10:00:00.000', N'Thermalright'),
(364, N'Tản nhiệt khí Be Quiet! Dark Rock Pro 5 Dual Tower', 2450000, N'TDP: 5W', N'https://pcper.com/wp-content/uploads/2023/10/dark-rock-elite-and-pro-5.jpg', 14, 40, '2026-07-23 10:00:00.000', N'Be Quiet!'),
(365, N'Tản nhiệt khí PCCOOLER K6 Digital Display ARGB Dual Tower', 1050000, N'TDP: 4W', N'https://lookaside.fbsbx.com/lookaside/crawler/media/?media_id=2404382830021734', 14, 65, '2026-07-23 10:00:00.000', N'PCCOOLER'),
(366, N'Tản nhiệt khí Valkyrie SL125 ARGB Màn hiển thị nhiệt độ', 950000, N'TDP: 4W', N'https://down-vn.img.susercontent.com/file/vn-11134201-23030-bngm8wm2wjov2c', 14, 70, '2026-07-23 10:00:00.000', N'Valkyrie'),
(367, N'Bộ 3 Fan tản nhiệt Lian Li UNI FAN SL-Infinity 120 ARGB Triple Black', 2450000, N'TDP: 3W', N'https://product.hstatic.net/200000522285/product/_fan_ghep_noi_khong_day__toc_2100rpm__pwm__fan_case_sl120_tpassionvn_1_76a2eab92dd74027a0eed0c5552a6b4d.jpg', 15, 50, '2026-07-23 10:00:00.000', N'Lian Li'),
(368, N'Bộ 3 Fan tản nhiệt Corsair iCUE LINK QX120 RGB Starter Kit White', 3650000, N'TDP: 4W', N'https://www.scan.co.uk/images/infopages/corsair_fans/QX120/starterkit/topimgw.png', 15, 40, '2026-07-23 10:00:00.000', N'Corsair'),
(369, N'Bộ 3 Fan tản nhiệt NZXT Duo F120 RGB Triple Pack Black', 2150000, N'TDP: 3W', N'https://azaudio.vn/wp-content/uploads/2024/01/NZXT-F120-RGB-TRIPLE-black.jpg', 15, 60, '2026-07-23 10:00:00.000', N'NZXT'),
(370, N'Bộ 3 Fan tản nhiệt Thermalright TL-C12C-S ARGB Triple Pack Black', 480000, N'TDP: 2W', N'https://product.hstatic.net/200000420363/product/5_653cd2cd23164950a50b4c518c8f3a2c_master.jpg', 15, 120, '2026-07-23 10:00:00.000', N'Thermalright'),
(371, N'Bộ 3 Fan tản nhiệt DeepCool FC120 3-in-1 ARGB Black', 850000, N'TDP: 3W', N'https://cf.shopee.ph/file/4cc04f06991eb09257723ef1526e9fcf', 15, 80, '2026-07-23 10:00:00.000', N'DeepCool'),
(372, N'Bộ 3 Fan tản nhiệt Phanteks D30-120 Reverse Airflow Triple Black', 2250000, N'TDP: 3W', N'https://www.tncstore.vn/media/product/250-13877-quat-tan-nhiet-phanteks-d30-120mm-reversed-drgb-black-triple-pack-1.jpg', 15, 45, '2026-07-23 10:00:00.000', N'Phanteks'),
(373, N'Bộ 3 Fan tản nhiệt ID-COOLING XF-12025 ARGB Trio Pack', 550000, N'TDP: 2W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltjplsx9zeh679', 15, 100, '2026-07-23 10:00:00.000', N'ID-COOLING'),
(374, N'Bộ 3 Fan tản nhiệt Cooler Master MasterFan MF120 Halo2 ARGB White', 1350000, N'TDP: 3W', N'https://product.hstatic.net/200000722513/product/63609_halo3in1_white_2fe56efd09ad4358bc9bffe694dc34c0_ae18db62db9a4b17b2544370f1bf7da0_1024x1024.jpg', 15, 70, '2026-07-23 10:00:00.000', N'Cooler Master'),
(375, N'Bộ 3 Fan tản nhiệt Antec Fusion 120 ARGB Triple Pack', 780000, N'TDP: 2W', N'https://media.ldlc.com/r1600/ld/products/00/05/97/64/LD0005976472.jpg', 15, 90, '2026-07-23 10:00:00.000', N'Antec'),
(376, N'Bộ 3 Fan tản nhiệt Montech AX120 PWM ARGB Pack White', 650000, N'TDP: 2W', N'https://www.mixmarket.lv/images/stories/virtuemart/product/01K7PJZV1QFS1FR3VF1FX8P0ZK.jpg', 15, 95, '2026-07-23 10:00:00.000', N'Montech'),
(377, N'Bàn phím cơ AKKO 3087 v2 Silent Bluetooth 5.0 / Wireless 2.4G', 1450000, N'TDP: 1W', N'https://akko.vn/wp-content/uploads/2021/10/ban-phim-co-akko-3087-v2-steam-engine-03.jpg', 16, 60, '2026-07-23 10:00:00.000', N'AKKO'),
(378, N'Bàn phím cơ Keychron V1 Max Wireless Custom Mechanical Keyboard Hotswap', 2250000, N'TDP: 2W', N'https://cdn.shopify.com/s/files/1/0059/0630/1017/files/V1-Max-1.jpg?v=1699065014', 16, 50, '2026-07-23 10:00:00.000', N'Keychron'),
(379, N'Bàn phím cơ Royal Kludge RK84 RGB Wireless 80% Layout Hotswap', 980000, N'TDP: 1W', N'https://cf.shopee.vn/file/6e1e4cbe7912a8b7473e94334e280d6d', 16, 90, '2026-07-23 10:00:00.000', N'Royal Kludge'),
(380, N'Bàn phím cơ FL-Esports FL980 SAM Tropical Secret Wireless', 2450000, N'TDP: 2W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltsd0cu67e2y55', 16, 40, '2026-07-23 10:00:00.000', N'FL-Esports'),
(381, N'Bàn phím cơ MonsGeek M1W V3 Fully Assembled Aluminum Wireless', 2150000, N'TDP: 2W', N'https://down-my.img.susercontent.com/file/sg-11134201-7rd51-lvbxo0vd8e038e', 16, 45, '2026-07-23 10:00:00.000', N'MonsGeek'),
(382, N'Bàn phím cơ EPOMAKER RT100 Retro Mechanical Keyboard Màn hình Smart', 2650000, N'TDP: 2W', N'https://manuals.plus/wp-content/uploads/2023/03/Epomaker-RT100-Mechanical-Gaming-Keyboard-Product-image.jpg', 16, 35, '2026-07-23 10:00:00.000', N'EPOMAKER'),
(383, N'Bàn phím cơ Ducky One 3 Daybreak Hotswap RGB Mech Keyboard', 2850000, N'TDP: 2W', N'https://img.lazcdn.com/g/p/55ae1abfed8b5f9068f263c2fdad5fee.png_720x720q80.png', 16, 30, '2026-07-23 10:00:00.000', N'Ducky'),
(384, N'Bàn phím cơ Varmilo VEA87 Vintage Mechanical Keyboard Cherry MX', 3150000, N'TDP: 1W', N'https://down-sg.img.susercontent.com/file/sg-11134201-23010-9jf38tbmpxlv7d', 16, 25, '2026-07-23 10:00:00.000', N'Varmilo'),
(385, N'Bàn phím cơ NuPhy Air75 V2 Low-Profile Wireless Keyboard', 2950000, N'TDP: 2W', N'https://down-id.img.susercontent.com/file/id-11134201-7r98w-lt0o38jrvqx9ae', 16, 40, '2026-07-23 10:00:00.000', N'NuPhy'),
(386, N'Bàn phím cơ Custom Womier K66 Gateron Switch RGB Acrylic Glass', 1250000, N'TDP: 1W', N'https://ae01.alicdn.com/kf/S81196b6be21d49b9b30c4343a17e3808S/Womier-K66-Mechanical-Gaming-Keyboard-RGB-led-Backlit-Hot-Swappable-Gateron-Switch-Tyce-C-Light-transmission.jpg', 16, 70, '2026-07-23 10:00:00.000', N'Womier'),
(387, N'Chuột máy tính Razer Basilisk V3 Ergonomic Gaming Mouse 26k DPI', 1450000, N'TDP: 1W', N'https://m.media-amazon.com/images/I/61JKqNxaZkL._AC_SL1500_.jpg', 17, 80, '2026-07-23 10:00:00.000', N'Razer'),
(388, N'Chuột máy tính Logitech G304 LIGHTSPEED Wireless Black 12k DPI', 820000, N'TDP: 1W', N'https://laptec.co.mz/wp-content/uploads/2024/11/51VpABY-b6L._SL1500_.jpg', 17, 150, '2026-07-23 10:00:00.000', N'Logitech'),
(389, N'Chuột máy tính Pulsar X2 V2 Wireless Gaming Mouse Superlight 53g', 2150000, N'TDP: 1W', N'https://down-id.img.susercontent.com/file/id-11134207-7r992-lmzwg5uzu56pc0', 17, 45, '2026-07-23 10:00:00.000', N'Pulsar'),
(390, N'Chuột máy tính Ninjutso Sora V2 Ultra Lightweight Wireless 39g', 2450000, N'TDP: 1W', N'https://down-sg.img.susercontent.com/file/sg-11134201-7rd69-m6ywp16bi7h0a2', 17, 40, '2026-07-23 10:00:00.000', N'Ninjutso'),
(391, N'Chuột máy tính LAMZU Atlantis OG V2 Wireless Gaming Mouse 55g', 2250000, N'TDP: 1W', N'https://cdn.store-assets.com/s/824673/i/62363351.jpeg?width=1024', 17, 50, '2026-07-23 10:00:00.000', N'LAMZU'),
(392, N'Chuột máy tính Endgame Gear OP1WE Wireless Gaming Mouse 58g', 1950000, N'TDP: 1W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m5d24fcjbuieb0', 17, 60, '2026-07-23 10:00:00.000', N'Endgame Gear'),
(393, N'Chuột máy tính VGN Dragonfly F1 PRO MAX Wireless Nordic MCU', 1150000, N'TDP: 1W', N'https://bizweb.dktcdn.net/100/506/630/products/5.png?v=1710093977290', 17, 90, '2026-07-23 10:00:00.000', N'VGN'),
(394, N'Chuột máy tính VXE R1 PRO MAX Ultra Light Wireless PAW3395', 980000, N'TDP: 1W', N'https://down-br.img.susercontent.com/file/br-11134207-7r98o-m5etuyqhic3628', 17, 110, '2026-07-23 10:00:00.000', N'VXE'),
(395, N'Chuột máy tính SteelSeries Rival 3 Wireless Gaming Mouse 18k DPI', 950000, N'TDP: 1W', N'https://os-jo.com/image/cache/catalog/products/Accessories/Mouse/RIVAL-3-Wireless/a89f866daa5b7f847d234e3beb4d6582-1200x1200.jpg', 17, 100, '2026-07-23 10:00:00.000', N'SteelSeries'),
(396, N'Chuột máy tính ASUS ROG Harpe Ace Aim Lab Edition 54g Wireless', 2850000, N'TDP: 1W', N'https://product.hstatic.net/1000262653/product/sp1080884_f0bb5b45cbbc4da1881a87dc14861641_master.png', 17, 35, '2026-07-23 10:00:00.000', N'ASUS'),
(397, N'Tai nghe gaming HyperX Cloud II Wireless Red/Black Spatial Audio', 2950000, N'TDP: 1W', N'http://hyperx.com/cdn/shop/files/hyperx_cloud_ii_red_2_main_mixer.jpg?v=1721075774', 18, 60, '2026-07-23 10:00:00.000', N'HyperX'),
(398, N'Tai nghe gaming Razer BlackShark V2 X 7.1 Surround Sound Black', 1250000, N'TDP: 1W', N'https://cdn.hstatic.net/products/1000231532/mua_razer_blackshark_v2_x_b_o_h_nh_24_th_ng_uy_t_n_t_i_nshop_4e5bb68935394ba79b01c641540fa09e_master.jpg', 18, 100, '2026-07-23 10:00:00.000', N'Razer'),
(399, N'Tai nghe gaming Corsair HS80 RGB Wireless Spatial Audio White', 3450000, N'TDP: 2W', N'https://assets.corsair.com/image/upload/c_pad,q_auto,h_1024,w_1024,f_auto/products/Gaming-Headsets/CA-9011236-EU/Gallery/HS80_RGB_WIRELESS_WHITE_01.webp', 18, 45, '2026-07-23 10:00:00.000', N'Corsair'),
(400, N'Tai nghe gaming Logitech G435 LIGHTSPEED Ultra-Light Wireless Blue', 1450000, N'TDP: 1W', N'https://resource.logitechg.com/w_1206,c_limit,q_auto,f_auto,dpr_1.0/d_transparent.gif/content/dam/gaming/en/products/g435/g435-gaming-headset-feature-2-blue.png?v=1', 18, 90, '2026-07-23 10:00:00.000', N'Logitech'),
(401, N'Tai nghe gaming SteelSeries Arctis Nova 7 Wireless Multi-Platform', 4250000, N'TDP: 2W', N'https://m.media-amazon.com/images/I/719xhYDZj9L._AC_.jpg', 18, 35, '2026-07-23 10:00:00.000', N'SteelSeries'),
(402, N'Tai nghe gaming EPOS Sennheiser GSP 300 Closed Acoustic Black/Blue', 1850000, N'TDP: 1W', N'https://m.media-amazon.com/images/I/71gcu2BXwCL._AC_SL1500_.jpg', 18, 50, '2026-07-23 10:00:00.000', N'EPOS'),
(403, N'Tai nghe gaming Audio-Technica ATH-GDL3 Open-Back Gaming Headset', 3250000, N'TDP: 1W', N'https://down-id.img.susercontent.com/file/3333631a77a536b448894e7821767789', 18, 30, '2026-07-23 10:00:00.000', N'Audio-Technica'),
(404, N'Tai nghe gaming JBL Quantum 400 USB Wired Gaming Headset QuantumSURROUND', 1950000, N'TDP: 1W', N'https://m.media-amazon.com/images/I/71plrtRXJNL._AC_.jpg', 18, 70, '2026-07-23 10:00:00.000', N'JBL'),
(405, N'Tai nghe gaming ASUS ROG Delta S Wireless Gaming Headset Type-C', 4650000, N'TDP: 2W', N'https://mygear.io.vn/media/product/9420-tai-nghe-gaming-overear-asus-rog-delta-s-wireless-4.jpg', 18, 25, '2026-07-23 10:00:00.000', N'ASUS'),
(406, N'Tai nghe gaming EKSA E900 Pro 7.1 Surround Sound Wired Dual Audio', 750000, N'TDP: 1W', N'https://electronix.ie/wp-content/uploads/2025/04/EKSA-E900PRO_1-500x500-1.jpg', 18, 120, '2026-07-23 10:00:00.000', N'EKSA'),
(407, N'Thẻ nhớ MicroSD Sandisk Ultra 32GB Class 10 120MB/s', 120000, N'TDP: 1W', N'https://maytinhtrangia.com/wp-content/uploads/SD-32G-1.jpg', 4, 150, '2026-07-23 11:35:00.000', N'SanDisk'),
(408, N'Thẻ nhớ MicroSD Sandisk High Endurance 64GB Chuyên ghi Dashcam', 290000, N'TDP: 1W', N'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/h/the-nho-microsd-sandisk-high-endurance-chuyen-camera-64gb_1_.png', 4, 100, '2026-07-23 11:35:00.000', N'SanDisk'),
(409, N'Thẻ nhớ SDXC SanDisk Extreme PRO 64GB UHS-I 200MB/s', 450000, N'TDP: 2W', N'https://media.foto-erhardt.de/images/product_images/popup_images/893/sandisk-64-gb-sdxc-extremepro-200mbs-v30-uhs-i-u3-class-10-speicherkarte-166124206789380304.jpg', 4, 120, '2026-07-23 11:35:00.000', N'SanDisk'),
(410, N'Thẻ nhớ MicroSD Samsung EVO Plus 64GB kèm Adapter', 210000, N'TDP: 1W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lfc894uls77909', 4, 180, '2026-07-23 11:35:00.000', N'Samsung'),
(411, N'Thẻ nhớ MicroSD Samsung EVO Plus 128GB UHS-I U3', 350000, N'TDP: 2W', N'https://www.nhatthuc.com.vn/resize-image/470x/2025/08/the-nho-micro-sd-samsung-evo-plus-128gb-1.jpg', 4, 140, '2026-07-23 11:35:00.000', N'Samsung'),
(412, N'Thẻ nhớ MicroSD Kingston Canvas Select Plus 64GB', 150000, N'TDP: 1W', N'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/h/the-nho-microsd-kingston-canvas-select-plus-64gb-sdcs3_2_.png', 4, 200, '2026-07-23 11:35:00.000', N'Kingston'),
(413, N'Thẻ nhớ MicroSD Kingston Canvas Select Plus 256GB', 520000, N'TDP: 2W', N'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/h/the-nho-microsd-kingston-canvas-select-plus-256gb-sdcs3_4_.png', 4, 90, '2026-07-23 11:35:00.000', N'Kingston'),
(414, N'Thẻ nhớ SDXC Lexar Professional 1667x 128GB SDXC UHS-II 250MB/s', 1150000, N'TDP: 3W', N'https://product.hstatic.net/200000863343/product/the-nho-sdxc-lexar-128gb-uhs-ii-1667x-250mb-s-17ba7_a2173df497b14812967527ce0cbb21d5.jpg', 4, 60, '2026-07-23 11:35:00.000', N'Lexar'),
(415, N'Thẻ nhớ MicroSD Lexar Play 256GB UHS-I cho Nintendo Switch', 680000, N'TDP: 2W', N'https://cdn.hstatic.net/products/1000231532/ss_256gb_lexar_cho_nintendo_switch_2_chinh_hang_gia_tot_chat_luong_cao_d1dc82953bc747cbac60d5e312b47e76.jpg', 4, 80, '2026-07-23 11:35:00.000', N'Lexar'),
(416, N'Thẻ nhớ SDXC Sony SF-E Series 64GB UHS-II 270MB/s', 850000, N'TDP: 2W', N'https://photoking.vn/upload/images/Ph%E1%BB%A5%20Ki%E1%BB%87n/Th%E1%BA%BB%20Nh%E1%BB%9B/the-nho-sony-sdxc-64gb-270mbs-70-mbs-sf-m64-photoking-vn-02.jpg', 4, 50, '2026-07-23 11:35:00.000', N'Sony'),
(417, N'Thẻ nhớ SDXC Sony TOUGH M Series 128GB UHS-II 270MB/s', 2100000, N'TDP: 3W', N'https://cf.shopee.co.id/file/50fab139ce6eeb1d06a77f9ef2d9577f', 4, 35, '2026-07-23 11:35:00.000', N'Sony'),
(418, N'Thẻ nhớ MicroSD Kioxia Exceria G2 256GB NVMe Class', 620000, N'TDP: 2W', N'https://vinacenter.com.vn/wp-content/uploads/2026/04/the7.webp', 4, 75, '2026-07-23 11:35:00.000', N'Kioxia'),
(419, N'Thẻ nhớ SDXC Transcend 700S 64GB SDXC UHS-II V90 285MB/s', 1850000, N'TDP: 3W', N'https://www.picclickimg.com/hWEAAOSwtj5lw31H/Scheda-di-memoria-SD-Transcend-700S-SDXC-UHS-II.webp', 4, 40, '2026-07-23 11:35:00.000', N'Transcend'),
(420, N'Thẻ nhớ MicroSD TeamGroup PRO Endurance 128GB', 390000, N'TDP: 2W', N'https://cdn.hstatic.net/products/200001078011/the-nho-team-group-elite-128g-uhs-i-u3-v30-a1_72e4b2b6836c44dcb2acea7c924762a2_master.jpg', 4, 85, '2026-07-23 11:35:00.000', N'TeamGroup'),
(421, N'Thẻ nhớ SDXC ProGrade Digital SDXC UHS-II V90 Cobalt 128GB', 3950000, N'TDP: 3W', N'https://www.lens-camera.com/wp-content/uploads/2025/03/02/prograde_digital_555654_1_1.jpg', 4, 20, '2026-07-23 11:35:00.000', N'ASUS'),
(422, N'Ổ cứng di động SSD WD My Passport SSD 1TB USB 3.2 Red', 2450000, N'TDP: 4W', N'https://minhancomputercdn.com/media/product/11301_wd_my_passport_ssd_1tb_wdbagf0010brd_wesn_2.jpg', 8, 60, '2026-07-23 11:35:00.000', N'WD'),
(423, N'Ổ cứng di động SSD WD Black P50 Game Drive 1TB NVMe 2000MB/s', 3850000, N'TDP: 5W', N'https://www.legitreviews.com/wp-content/uploads/2020/08/wd-p50-game-drive-1tb-portable-ssd.jpg', 8, 40, '2026-07-23 11:35:00.000', N'WD'),
(424, N'Ổ cứng di động HDD WD Elements Portable 1TB 2.5 inch USB 3.0', 1390000, N'TDP: 5W', N'https://minhancomputercdn.com/media/product/986_o_cung_di_dong_western_elements_1tb_2_5inch_usb_3_0_1.jpg', 8, 100, '2026-07-23 11:35:00.000', N'WD'),
(425, N'Ổ cứng di động HDD WD Elements Portable 4TB 2.5 inch USB 3.0', 3150000, N'TDP: 6W', N'https://www.sieuthimaychu.vn/datafiles/setone/16141343642993.jpg', 8, 50, '2026-07-23 11:35:00.000', N'WD'),
(426, N'Ổ cứng di động SSD Samsung T7 Portable 1TB USB 3.2 Titan Gray', 2550000, N'TDP: 4W', N'https://cdn2.cellphones.com.vn/x/media/catalog/product/o/-/o-cung-di-dong-ssd-samsung-t7-portable_10_.png', 8, 70, '2026-07-23 11:35:00.000', N'Samsung'),
(427, N'Ổ cứng di động SSD Samsung T9 Portable 2TB USB 3.2 Gen 2x2 2000MB/s', 5450000, N'TDP: 5W', N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/o-cung-di-dong-ssd-1tb-samsung-t9-2000mb-5-c3a14677-d68f-44aa-957d-83483159d4f5.jpg?v=1718353885613', 8, 30, '2026-07-23 11:35:00.000', N'Samsung'),
(428, N'Ổ cứng di động SSD SanDisk Extreme PRO Portable 2TB USB 3.2 Gen 2x2', 5150000, N'TDP: 5W', N'https://down-vn.img.susercontent.com/file/sg-11134201-22120-69sq1wzfywkv7d', 8, 35, '2026-07-23 11:35:00.000', N'SanDisk'),
(429, N'Ổ cứng di động HDD Seagate One Touch 2TB 2.5 inch USB 3.0 Black', 2050000, N'TDP: 5W', N'https://huyhoang.vn/uploads/o-cung-di-dong-hdd-seagate-one-touch-2tb-25-usb-30-den-stky2000400-3.jpg', 8, 80, '2026-07-23 11:35:00.000', N'Seagate'),
(430, N'Ổ cứng di động HDD Seagate Basic 1TB 2.5 inch USB 3.0', 1290000, N'TDP: 5W', N'https://hoanghapccdn.com/media/product/3630_1tb_touch_1_hdd_1.jpg', 8, 110, '2026-07-23 11:35:00.000', N'Seagate'),
(431, N'Ổ cứng di động SSD Crucial X6 Portable SSD 2TB 800MB/s', 3450000, N'TDP: 4W', N'https://5sc.vn/wp-content/uploads/2022/05/Crucial-X6-Portable-SSD-2TB-Box-Front-Image.png', 8, 45, '2026-07-23 11:35:00.000', N'Crucial'),
(432, N'Ổ cứng di động SSD Crucial X10 Pro 2TB USB 3.2 Gen 2x2 2100MB/s', 5850000, N'TDP: 5W', N'https://down-th.img.susercontent.com/file/th-11134201-7r98y-lljgx9wk1kn2d8', 8, 25, '2026-07-23 11:35:00.000', N'Crucial'),
(433, N'Ổ cứng di động SSD Kingston XS1000 2TB External SSD Type-C Red', 3650000, N'TDP: 4W', N'https://goldentechstore.com.ar/wp-content/uploads/DIS207.jpg', 8, 55, '2026-07-23 11:35:00.000', N'Kingston'),
(434, N'Tản nhiệt nước AIO Corsair H100i RGB ELITE 240mm', 3250000, N'TDP: 12W', N'https://philong.com.vn/media/product/31924-tan-nhiet-nuoc-cpu-aio-corsair-icue-h100i-rgb-elite-240mm-white-cw-9060078-ww-philong--2-.jpg', 9, 50, '2026-07-23 11:35:00.000', N'Corsair'),
(435, N'Tản nhiệt nước AIO Corsair iCUE LINK H100i RGB White 240mm', 4850000, N'TDP: 12W', N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/tan-nhiet-nuoc-aio-corsair-icue-link-h100i-rgb-white-cw-9061005-ww-1.jpg?v=1743638717187', 9, 35, '2026-07-23 11:35:00.000', N'Corsair'),
(436, N'Tản nhiệt nước AIO NZXT Kraken 240 RGB Black LCD', 4250000, N'TDP: 12W', N'https://www.pcstudio.in/wp-content/uploads/2023/05/Nzxt-Kraken-240-Rgb-240mm-Aio-Liquid-Cooler-Matte-Black-1.jpg', 9, 40, '2026-07-23 11:35:00.000', N'NZXT'),
(437, N'Tản nhiệt nước AIO NZXT Kraken 360 RGB Black LCD', 5350000, N'TDP: 15W', N'https://hoanghapc.vn/media/product/4402_rl_kr360_b1_ha1.jpg', 9, 30, '2026-07-23 11:35:00.000', N'NZXT'),
(438, N'Tản nhiệt nước AIO ASUS ROG Strix LC III 360 ARGB', 4950000, N'TDP: 15W', N'https://mygear.io.vn/media/product/6094-rog-strix-lc-iii-360-argb-03.png', 9, 25, '2026-07-23 11:35:00.000', N'ASUS'),
(439, N'Tản nhiệt nước AIO ASUS TUF Gaming LC II 360 ARGB', 2950000, N'TDP: 15W', N'https://hoanghapccdn.com/media/product/5001_tuf_gaming_lc_ii_360_argb_ha1.jpg', 9, 45, '2026-07-23 11:35:00.000', N'ASUS'),
(440, N'Tản nhiệt nước AIO DeepCool LS720 SE 360mm ARGB Black', 2650000, N'TDP: 15W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m2whteh6qzuu1d', 9, 60, '2026-07-23 11:35:00.000', N'DeepCool'),
(441, N'Tản nhiệt nước AIO DeepCool MYSTIQUE 360 Màn hình LCD 3.4 inch', 4150000, N'TDP: 15W', N'http://cms2.deepcool.com:8080/public/ProductFile/DEEPCOOL/Cooling/CPULiquidCoolers/MYSTIQUE_360_ARGB/Gallery/4000X4000/01.png', 9, 30, '2026-07-23 11:35:00.000', N'DeepCool'),
(442, N'Tản nhiệt nước AIO Thermalright Frozen Warframe 360 ARGB Màn LCD', 2750000, N'TDP: 15W', N'https://product.hstatic.net/200000475459/product/thermalright_frozen_warframe_360_b3_b5044d16fccc47adb7a6ce676ae3e2ad_289933337cb24cb5b65dcaded772689b_master.jpg', 9, 40, '2026-07-23 11:35:00.000', N'Thermalright'),
(443, N'Tản nhiệt nước AIO Lian Li Galahad II LCD 360 SL-INF Black', 6450000, N'TDP: 15W', N'https://ttgshop.vn/media/product/1054421234_82296_tan_nhiet_nuoc_lian_li_galahad_ii_lcd_sl_inf_360_black__3__f16e36ee72964ce8a37a7384400e9d15.jpg', 9, 20, '2026-07-23 11:35:00.000', N'Lian Li'),
(444, N'Tản nhiệt nước AIO MSI MAG CORELIQUID 240R V2', 2250000, N'TDP: 12W', N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/tan-nhiet-nuoc-aio-mag-coreliquid-240r-4.jpg?v=1697040027870', 9, 55, '2026-07-23 11:35:00.000', N'MSI'),
(445, N'Tản nhiệt nước AIO ID-COOLING FROSTFLOW X 240 Snow Edition White', 1150000, N'TDP: 10W', N'https://down-vn.img.susercontent.com/file/vn-11134201-23020-tn10ee3ldunv20', 9, 80, '2026-07-23 11:35:00.000', N'ID-COOLING'),
(446, N'Card màn hình ASUS ROG Strix GeForce RTX 4090 OC Edition 24GB GDDR6X', 54900000, N'TDP: 450W', N'https://dlcdnwebimgs.asus.com/gain/2486AE38-B7C7-443A-9615-FD08D5430992/w1000/h732', 10, 10, '2026-07-23 11:35:00.000', N'ASUS'),
(447, N'Card màn hình MSI GeForce RTX 4080 SUPER 16G GAMING X TRIO', 33500000, N'TDP: 320W', N'https://hanoicomputercdn.com/media/product/79168_card_man_hinh_msi_rtx_4080_super_16g_gaming_x_trio__2_.jpg', 10, 15, '2026-07-23 11:35:00.000', N'MSI'),
(448, N'Card màn hình GIGABYTE GeForce RTX 4060 EAGLE OC 8G', 8450000, N'TDP: 115W', N'https://product.hstatic.net/200000722513/product/z4467044485040_9a09deef236a05de8179abdccd40f035_fd7e141a0a0a4464b78e0adf591b21c2.jpg', 10, 60, '2026-07-23 11:35:00.000', N'GIGABYTE'),
(449, N'Card màn hình GIGABYTE GeForce RTX 3050 WINDFORCE OC 6G', 4650000, N'TDP: 70W', N'https://product.hstatic.net/200000722513/product/geforce_rtx__3050_windforce_oc_6g-02_8e038f8bf31d4b008bc170b13dd3cff4.png', 10, 80, '2026-07-23 11:35:00.000', N'GIGABYTE'),
(450, N'Card màn hình ASUS Dual GeForce RTX 4060 Ti EVO OC Edition 8GB', 11250000, N'TDP: 160W', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6545/6545279cv12d.jpg', 10, 45, '2026-07-23 11:35:00.000', N'ASUS'),
(451, N'Card màn hình ZOTAC GAMING GeForce RTX 3060 Twin Edge OC 12GB', 7250000, N'TDP: 170W', N'https://res.cloudinary.com/jawa/image/upload/f_auto,c_limit,w_1280,q_auto/production/listings/pcubpf4kb1xn6xd6iklw', 10, 50, '2026-07-23 11:35:00.000', N'NVIDIA'),
(452, N'Card màn hình Sapphire PULSE AMD Radeon RX 7600 8GB GDDR6', 7150000, N'TDP: 165W', N'https://vitinhtrangia.com/wp-content/uploads/2024/08/card-man-hinh-vga-sapphire-pulse-amd-radeon-rx-7600-8gb-gaming-oc-8gb-4.jpg', 10, 40, '2026-07-23 11:35:00.000', N'AMD'),
(453, N'Card màn hình PowerColor Fighter AMD Radeon RX 6600 8GB GDDR6', 5250000, N'TDP: 132W', N'https://m.media-amazon.com/images/I/81Vtsr0wIVL._AC_.jpg', 10, 55, '2026-07-23 11:35:00.000', N'AMD'),
(454, N'Card màn hình ASRock Challenger Radeon RX 7800 XT 16GB OC', 14150000, N'TDP: 263W', N'https://media.ldlc.com/r1600/ld/products/00/06/06/19/LD0006061987.jpg', 10, 30, '2026-07-23 11:35:00.000', N'AMD'),
(455, N'Card màn hình COLORFUL GeForce GTX 1650 NB 4GD6-V', 3650000, N'TDP: 75W', N'https://tinhungtech.com/watermark/product/1400x1500x2/upload/product/51dmzhei2olsr600315piwhitestripbottomleft035sclzzzzzzzfmpngbg255255255-4585.png', 10, 70, '2026-07-23 11:35:00.000', N'NVIDIA'),
(456, N'Ổ cứng HDD PC Western Digital Purple 2TB 3.5 inch Surveillance', 1650000, N'TDP: 6W', N'https://www.flashtrend.com.au/assets/alt_2/WD20PURZ.jpg?20200714030752', 11, 90, '2026-07-23 11:35:00.000', N'WD'),
(457, N'Ổ cứng HDD PC Western Digital Purple 4TB 3.5 inch Surveillance', 2750000, N'TDP: 7W', N'https://m.media-amazon.com/images/I/61Np0SuI9rL.jpg', 11, 70, '2026-07-23 11:35:00.000', N'WD'),
(458, N'Ổ cứng HDD PC Western Digital Purple 6TB 3.5 inch Surveillance', 4350000, N'TDP: 8W', N'https://m.media-amazon.com/images/I/61oyy18RjsL._AC_SL1500_.jpg', 11, 45, '2026-07-23 11:35:00.000', N'WD'),
(459, N'Ổ cứng HDD PC Seagate SkyHawk 2TB 3.5 inch Surveillance', 1550000, N'TDP: 6W', N'https://hanoicomputercdn.com/media/product/35130_hdd_seagate_skyhawk_surveillance_2tb5900_sata_3_64mb_cache_st2000vx008_011.jpg', 11, 85, '2026-07-23 11:35:00.000', N'Seagate'),
(460, N'Ổ cứng HDD PC Seagate SkyHawk 6TB 3.5 inch Surveillance', 4150000, N'TDP: 8W', N'https://maytinhtrungbac.com/wp-content/uploads/2023/12/HDD9.jpg', 11, 50, '2026-07-23 11:35:00.000', N'Seagate'),
(461, N'Ổ cứng HDD Server Seagate IronWolf Pro 8TB 3.5 inch NAS', 6150000, N'TDP: 9W', N'https://philong.com.vn/media/product/29504-phi-long-o-cung-hdd-seagate-ironwolf-pro-8tb-st8000ne001.jpg', 11, 30, '2026-07-23 11:35:00.000', N'Seagate'),
(462, N'Ổ cứng HDD Server Seagate IronWolf Pro 12TB 3.5 inch NAS', 8950000, N'TDP: 10W', N'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mmqy7t6kpb0l57', 11, 20, '2026-07-23 11:35:00.000', N'Seagate'),
(463, N'Ổ cứng HDD Server Western Digital Red Pro 8TB 3.5 inch NAS', 6450000, N'TDP: 9W', N'https://www.tnc.com.vn/uploads/product/sp2025/o-cung-hdd-western-digital-red-pro-nas-8tb-wd8005ffbx.jpg', 11, 25, '2026-07-23 11:35:00.000', N'WD'),
(464, N'Ổ cứng HDD Enterprise Seagate Exos X16 14TB 3.5 inch SATA3', 7250000, N'TDP: 10W', N'https://media.loveitopcdn.com/30716/o-cung-hdd-seagate-enterprise-exos-35-sata-x16-14tb-st14000nm001g-13.png', 11, 25, '2026-07-23 11:35:00.000', N'Seagate'),
(465, N'Ổ cứng HDD Enterprise Western Digital Ultrastar DC HC550 18TB', 9450000, N'TDP: 10W', N'https://m.media-amazon.com/images/I/710JaskXbqL._AC_.jpg', 11, 15, '2026-07-23 11:35:00.000', N'WD'),
(466, N'Ổ cứng HDD PC Toshiba Canvio Basics 1TB 2.5 inch', 1250000, N'TDP: 4W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mb3gsn7g9uwx71', 11, 110, '2026-07-23 11:35:00.000', N'Toshiba'),
(467, N'Ổ cứng HDD PC Toshiba Surveillance S300 4TB 3.5 inch', 2550000, N'TDP: 7W', N'https://alfathtechnology.com/wp-content/uploads/2025/07/https___static.arvutitark.ee_public_media-hub-olev_2021_10_123986_media-nkeail.jpg', 11, 60, '2026-07-23 11:35:00.000', N'Toshiba'),
(468, N'Ổ cứng HDD Laptop Western Digital Blue 1TB 2.5 inch SATA3', 1150000, N'TDP: 4W', N'https://product.hstatic.net/200000837185/product/ptop-western-digital-blue-1tb-2-5_-5400-rpm-128mb-cache-wd10spzx-f0x6i_e28dfeaf8b5844fbaa0a6c4b9ebda4e8_master.jpg', 11, 95, '2026-07-23 11:35:00.000', N'WD'),
(469, N'Nguồn Corsair RM850e ATX 3.0 80 Plus Gold Full Modular (850W)', 3450000, N'TDP: 0W', N'https://product.hstatic.net/200000722513/product/89689_nguon_may_tinh_corsair_rm850e_atx_006_e59a3ebce3034f23aa2bde43f1d242e5_1024x1024.jpg', 12, 50, '2026-07-23 11:35:00.000', N'Corsair'),
(470, N'Nguồn Corsair RM1000x Shift 80 Plus Gold Full Modular (1000W)', 4950000, N'TDP: 0W', N'https://product.hstatic.net/1000037809/product/thegioigear_corsair_rm1000x_1_1c478e5ea1ae485b91e607ee2b71eca7_master.jpg', 12, 30, '2026-07-23 11:35:00.000', N'Corsair'),
(471, N'Nguồn Corsair CV650 650W 80 Plus Bronze', 1450000, N'TDP: 0W', N'https://maytinhdalat.vn/Images/Product/maytinhdalat_nguon-may-tinh-corsair-cv650-650w-80-plus-bronzenguon-may-tinh-corsair-cv650-650w-80-plus-bronze-avt2725337_full_26002022_030016.jpg', 12, 90, '2026-07-23 11:35:00.000', N'Corsair'),
(472, N'Nguồn MSI MAG A650BN 650W 80 Plus Bronze', 1250000, N'TDP: 0W', N'https://halinhcomputer.vn/uploads/images/web-halinh-new/linh-kien-le/psu/mag-a650bn.png', 12, 110, '2026-07-23 11:35:00.000', N'MSI'),
(473, N'Nguồn MSI MEG Ai1300P PCIE5 1300W 80 Plus Platinum', 8950000, N'TDP: 0W', N'https://down-sg.img.susercontent.com/file/sg-11134201-22100-ms6oh974ckivaa', 12, 15, '2026-07-23 11:35:00.000', N'MSI'),
(474, N'Nguồn ASUS ROG Thor 1000W Platinum II OLED', 8450000, N'TDP: 0W', N'https://image.citycenter.jo/cache/catalog/22022/1000P-1200x1200.jpg', 12, 20, '2026-07-23 11:35:00.000', N'ASUS'),
(475, N'Nguồn ASUS TUF Gaming 650B 650W 80 Plus Bronze', 1650000, N'TDP: 0W', N'https://ddtech.mx/assets/uploads/6f275abb29f47415663708443680a8c5.jpg', 12, 80, '2026-07-23 11:35:00.000', N'ASUS'),
(476, N'Nguồn Cooler Master Elite V3 600W 230V', 1050000, N'TDP: 0W', N'https://huyhoang.vn/uploads/pc600-box.jpg', 12, 100, '2026-07-23 11:35:00.000', N'Cooler Master'),
(477, N'Nguồn DeepCool PK650D 650W 80 Plus Bronze', 1350000, N'TDP: 0W', N'https://hoanghapccdn.com/media/product/3687_deepcool_pk650_3.jpg', 12, 85, '2026-07-23 11:35:00.000', N'DeepCool'),
(478, N'Nguồn ASRock Phantom Gaming PG-850G 850W 80 Plus Gold', 2950000, N'TDP: 0W', N'https://cdn.cclonline.com/cdn-cgi/image/width=2000/images/avante/02-PG-850G_3A.jpg', 12, 40, '2026-07-23 11:35:00.000', N'ASRock'),
(479, N'Vỏ case NZXT H9 Flow Dual-Chamber ATX Mid-Tower Black', 4450000, N'TDP: 0W', N'https://microless.com/cdn/products/d554d168dd1e4febb71cd2cbf0698726-hi.jpg', 13, 30, '2026-07-23 11:35:00.000', N'NZXT'),
(480, N'Vỏ case NZXT H5 Flow RGB Compact Mid-Tower White', 2650000, N'TDP: 0W', N'https://www.topmarket.co.il/images/detailed/257/OtYnNeyks2.jpg', 13, 50, '2026-07-23 11:35:00.000', N'NZXT'),
(481, N'Vỏ case Lian Li O11 Dynamic EVO XL Full Tower Black', 5850000, N'TDP: 0W', N'https://media.ldlc.com/r1600/ld/products/00/06/06/93/LD0006069352.jpg', 13, 20, '2026-07-23 11:35:00.000', N'Lian Li'),
(482, N'Vỏ case Lian Li Lancool 216 ARGB Mid-Tower Black', 2350000, N'TDP: 0W', N'https://os-jo.com/image/cache/catalog/products/cases/LANCOOL-216/My-project-1200x1200.jpg', 13, 60, '2026-07-23 11:35:00.000', N'Lian Li'),
(483, N'Vỏ case Corsair 3500X ARGB Mid-Tower Glass Black', 2450000, N'TDP: 0W', N'https://kccshop.vn/media/product/250-9689-v----case-corsair-3500x-rgb-tempered-glass-mid-tower-black--cc-9011278-ww--01.jpg', 13, 70, '2026-07-23 11:35:00.000', N'Corsair'),
(484, N'Vỏ case Corsair 5000D AIRFLOW Tempered Glass Mid-Tower White', 3850000, N'TDP: 0W', N'https://cwsmgmt.corsair.com/pdp/5000-series/images/5000d-af-clear-clean-cool.png', 13, 35, '2026-07-23 11:35:00.000', N'Corsair'),
(485, N'Vỏ case MSI MAG FORGE 100M Mid-Tower Black', 1150000, N'TDP: 0W', N'https://gitec.ge/images/thumbs/0063677_msi-mag-forge-100m.jpeg', 13, 90, '2026-07-23 11:35:00.000', N'MSI'),
(486, N'Vỏ case Xigmatek Gaming X 3FX 3 Fan ARGB Black', 850000, N'TDP: 0W', N'https://phucngoc.vn/Data/images/vo-case-xigmatek-master-x-3fx.jpg', 13, 120, '2026-07-23 11:35:00.000', N'Xigmatek'),
(487, N'Vỏ case Mik Aios Black Kèm 3 Fan ARGB', 950000, N'TDP: 0W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lu9j1tie6gwh88', 13, 100, '2026-07-23 11:35:00.000', N'Mik'),
(488, N'Vỏ case SAMA 3509 Black Kèm 3 Fan RGB', 750000, N'TDP: 0W', N'https://m.media-amazon.com/images/I/81EZRt3KIOL._AC_SL1500_.jpg', 13, 110, '2026-07-23 11:35:00.000', N'SAMA'),
(489, N'Tản nhiệt khí Thermalright Peerless Assassin 120 White ARGB', 1050000, N'TDP: 5W', N'https://hanoicomputercdn.com/media/product/72071_peerless_assasin_120_se_white_argb__4_.jpg', 14, 80, '2026-07-23 11:35:00.000', N'Thermalright'),
(490, N'Tản nhiệt khí Thermalright Frost Tower 120 Dual Tower Black', 950000, N'TDP: 5W', N'https://hoanghapccdn.com/media/product/4157_thermalright_frost_tower_120_ha8.jpg', 14, 70, '2026-07-23 11:35:00.000', N'Thermalright'),
(491, N'Tản nhiệt khí DeepCool AK620 Digital ARGB Black Dual Tower', 1850000, N'TDP: 5W', N'https://hoanghapccdn.com/media/product/4420_ak620_digital_ha9.jpg', 14, 50, '2026-07-23 11:35:00.000', N'DeepCool'),
(492, N'Tản nhiệt khí DeepCool AG400 ARGB Single Tower', 450000, N'TDP: 3W', N'https://ecommerce.datablitz.com.ph/cdn/shop/files/zdfhbsrtg_800x.jpg?v=1739759913', 14, 130, '2026-07-23 11:35:00.000', N'DeepCool'),
(493, N'Tản nhiệt khí Noctua NH-U12S chromax.black Single Tower', 2150000, N'TDP: 4W', N'https://m.media-amazon.com/images/I/81Qu6DEtTlL._SL1500_.jpg', 14, 40, '2026-07-23 11:35:00.000', N'Noctua'),
(494, N'Tản nhiệt khí Noctua NH-L9i-17xx Low-Profile CPU Cooler', 1350000, N'TDP: 3W', N'https://m.media-amazon.com/images/I/81XLADINZiL.jpg', 14, 60, '2026-07-23 11:35:00.000', N'Noctua'),
(495, N'Tản nhiệt khí ID-COOLING SE-207-XT Black Dual Tower', 950000, N'TDP: 5W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lxdjem7mcdspfe', 14, 75, '2026-07-23 11:35:00.000', N'ID-COOLING'),
(496, N'Tản nhiệt khí ID-COOLING FROZN A620 Black Dual Tower', 1150000, N'TDP: 5W', N'https://kccshop.vn/media/product/250-10672-t---n-nhi---t-kh---id-cooling-frozn-a620-black_3_main.jpeg', 14, 65, '2026-07-23 11:35:00.000', N'ID-COOLING'),
(497, N'Tản nhiệt khí Cooler Master MasterAir MA612 Stealth Black', 1750000, N'TDP: 5W', N'https://hoanghapccdn.com/media/product/2166_masterair_ma612_stealth_4_optimized.jpg', 14, 45, '2026-07-23 11:35:00.000', N'Cooler Master'),
(498, N'Tản nhiệt khí Jonsbo CR-1400 ARGB Black', 280000, N'TDP: 2W', N'https://cdn.ben.com.vn/Content/Images/Products/3ce81aed-a15e-4202-a095-273b931c928a.jpg', 14, 160, '2026-07-23 11:35:00.000', N'Jonsbo'),
(499, N'Bộ 3 Fan tản nhiệt Lian Li UNI FAN TL LCD 120 Reverse Black', 3450000, N'TDP: 4W', N'https://product.hstatic.net/200000522285/product/f96af51f816fcd8a4bc30e591f13ed61_f2475336158448a796dbe2760f5675b4.jpg', 15, 30, '2026-07-23 11:35:00.000', N'Lian Li'),
(500, N'Bộ 3 Fan tản nhiệt Lian Li UNI FAN AL120 V2 ARGB Black', 2150000, N'TDP: 3W', N'https://images.tcdn.com.br/img/img_prod/1362985/kit_cooler_fan_lian_li_uni_fan_al120_v2_120mm_3_un_preto_argb_2000_rpm_modular_uf_al120v2_3b_1747_2_cd18221530e72d4d8e615bcff1e491dc.jpg', 15, 50, '2026-07-23 11:35:00.000', N'Lian Li'),
(501, N'Bộ 3 Fan tản nhiệt Corsair LL120 RGB 120mm Dual Light Loop White', 2650000, N'TDP: 3W', N'https://minhancomputercdn.com/media/product/8348_qu___t_t___n_nhi___t_case_corsair_ll120_rgb_white.jpg', 15, 45, '2026-07-23 11:35:00.000', N'Corsair'),
(502, N'Bộ 3 Fan tản nhiệt Corsair SP120 RGB ELITE 120mm PWM Triple Pack', 1650000, N'TDP: 3W', N'https://cellphones.com.vn/media/catalog/product/t/e/text_ng_n_16__1_10.png', 15, 60, '2026-07-23 11:35:00.000', N'Corsair'),
(503, N'Bộ 3 Fan tản nhiệt NZXT F120 RGB Core Triple Pack White', 1850000, N'TDP: 3W', N'https://product.hstatic.net/200000420363/product/20-rgb-core-triple-pack-with-rgb-controller-left-side-angle-view-white_fadd4054388446b9b8fe182a6ea3fa5d_master.png', 15, 55, '2026-07-23 11:35:00.000', N'NZXT'),
(504, N'Bộ 3 Fan tản nhiệt DeepCool FC120 White 3-in-1 ARGB', 890000, N'TDP: 3W', N'https://nguyenvu-store-medias.tn-cdn.net/2023/07/quat-tan-nhiet-deepcool-fc120-3-in-1-trang-8.jpg', 15, 80, '2026-07-23 11:35:00.000', N'DeepCool'),
(505, N'Bộ 3 Fan tản nhiệt Thermalright TL-C12C-S X3 White ARGB', 490000, N'TDP: 2W', N'https://product.hstatic.net/200000680123/product/thermalright-tl-c12cw-s-x3-fan-h4-600x600.jpg_14298f234eb24344bc5e46938f38fdb6_1024x1024.png', 15, 110, '2026-07-23 11:35:00.000', N'Thermalright'),
(506, N'Bộ 3 Fan tản nhiệt Thermalright TL-K12 ARGB High-Performance', 650000, N'TDP: 2W', N'https://www.thermalright.com/wp-content/uploads/2023/08/1-10.jpg', 15, 90, '2026-07-23 11:35:00.000', N'Thermalright'),
(507, N'Bộ 3 Fan tản nhiệt Montech RX120 PWM Reverse ARGB Pack', 690000, N'TDP: 2W', N'https://cdn0.centrecom.com.au/images/upload/0196456_0.jpeg', 15, 85, '2026-07-23 11:35:00.000', N'Montech'),
(508, N'Bộ 3 Fan tản nhiệt Xigmatek Galaxy II Pro ARGB 3 Fan Pack', 450000, N'TDP: 2W', N'https://alfrensia.com/wp-content/uploads/2022/02/EN42128.jpg', 15, 120, '2026-07-23 11:35:00.000', N'Xigmatek'),
(509, N'Bộ 3 Fan tản nhiệt Mik Halo ARGB 3 Fan Pack Black', 380000, N'TDP: 2W', N'https://down-vn.img.susercontent.com/file/e9fdd00372700ad2f4ba6850323cb2cd', 15, 130, '2026-07-23 11:35:00.000', N'Mik'),
(510, N'Bộ 3 Fan tản nhiệt SAMA Halo ARGB Kit 3 Fan kèm Hub Remote', 350000, N'TDP: 2W', N'https://down-br.img.susercontent.com/file/br-11134207-7r98o-lq1zxlij2scj37', 15, 140, '2026-07-23 11:35:00.000', N'SAMA'),
(511, N'Fan tản nhiệt lẻ Noctua NF-A12x25 PWM chromax.black', 850000, N'TDP: 1W', N'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mf6vvwttiww967', 15, 90, '2026-07-23 11:35:00.000', N'Noctua'),
(512, N'Fan tản nhiệt lẻ Arctic P12 PWM PST Black 120mm', 220000, N'TDP: 1W', N'https://pcngon.vn/wp-content/uploads/2024/09/Quat-tan-nhiet-Arctic-P12-PWM-PST-Black-4.png', 15, 200, '2026-07-23 11:35:00.000', N'Arctic'),
(513, N'Bàn phím cơ AKKO 5075B Plus Dragon Ball Z Wireless RGB', 2350000, N'TDP: 2W', N'https://salt.tikicdn.com/ts/product/ab/f7/88/56e8132ad98041714b1041cb6feaee08.jpg', 16, 40, '2026-07-23 11:35:00.000', N'AKKO'),
(514, N'Bàn phím cơ AKKO MonsGeek M1 V2 Kit Nhôm CNC Hotswap', 1850000, N'TDP: 1W', N'https://cf.shopee.vn/file/sg-11134201-22110-noy506z680jvf2', 16, 50, '2026-07-23 11:35:00.000', N'AKKO'),
(515, N'Bàn phím cơ Keychron K2 Pro Wireless Bluetooth QMK/VIA Gateron', 2150000, N'TDP: 2W', N'https://product.hstatic.net/1000187560/product/ban-phim-co-keychron-k2-pro-qmkvia-album-svf-thinkpro.vn_a9824fcb4b79456fa624cc6cf1c834cc_large.jpg', 16, 60, '2026-07-23 11:35:00.000', N'Keychron'),
(516, N'Bàn phím cơ Keychron Q1 Max Full Aluminum Wireless Custom', 4650000, N'TDP: 2W', N'https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Q1-Max-2.jpg?v=1701051646', 16, 25, '2026-07-23 11:35:00.000', N'Keychron'),
(517, N'Bàn phím cơ Logitech G Pro X TKL LIGHTSPEED Wireless Black', 4150000, N'TDP: 2W', N'https://www.tncstore.vn/media/product/13847-ban-phim-co-logitech-g-pro-x-tkl-lightspeed-tactile-switch-black.jpg', 16, 35, '2026-07-23 11:35:00.000', N'Logitech'),
(518, N'Bàn phím cơ Razer BlackWidow V4 Pro Mechanical Gaming Keyboard', 5450000, N'TDP: 3W', N'https://media.currys.biz/i/currysprod/10251854', 16, 20, '2026-07-23 11:35:00.000', N'Razer'),
(519, N'Bàn phím cơ Corsair K70 RGB PRO Mechanical Gaming Keyboard', 3650000, N'TDP: 2W', N'https://assets.corsair.com/image/upload/c_pad,q_auto,h_1024,w_1024,f_auto/products/Gaming-Keyboards/CH-910941A-NA/Gallery/K70_PRO_OPX_PBT_01.webp', 16, 45, '2026-07-23 11:35:00.000', N'Corsair'),
(520, N'Bàn phím cơ SteelSeries Apex Pro TKL Wireless', 5950000, N'TDP: 2W', N'https://owlgaming.vn/wp-content/uploads/2024/10/ban-phim-steelseries-apex-pro-tkl-wireless-gen-3.jpg', 16, 20, '2026-07-23 11:35:00.000', N'SteelSeries'),
(521, N'Bàn phím cơ ASUS ROG Azoth Wireless Custom Gaming Keyboard', 6850000, N'TDP: 3W', N'https://pcmarket.vn/media/product/10986_ban_phim_co_gaming_asus_rog_azoth_white_pcm_6.jpg', 16, 15, '2026-07-23 11:35:00.000', N'ASUS'),
(522, N'Bàn phím cơ Dareu EK87 V2 Multi-LED Tenkeyless Black', 450000, N'TDP: 1W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lnf8bm6zuy258f', 16, 120, '2026-07-23 11:35:00.000', N'Dareu'),
(523, N'Chuột máy tính Logitech G Pro X Superlight 2 Wireless Black', 3450000, N'TDP: 1W', N'https://www.tncstore.vn/media/product/250-9061-chuot-logitech-g-pro-x-superlight-2-wireless-12.jpg', 17, 50, '2026-07-23 11:35:00.000', N'Logitech'),
(524, N'Chuột máy tính Logitech G502 X PLUS LIGHTSPEED Wireless RGB', 3650000, N'TDP: 1W', N'https://www.bhphotovideo.com/images/images1500x1500/logitech_g_910_006160_g502_x_plus_wireless_1722686.jpg', 17, 40, '2026-07-23 11:35:00.000', N'Logitech'),
(525, N'Chuột máy tính Razer DeathAdder V3 Pro Wireless Ultra-Lightweight', 3250000, N'TDP: 1W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m0nqss9a7bf390', 17, 45, '2026-07-23 11:35:00.000', N'Razer'),
(526, N'Chuột máy tính Razer Viper V3 Pro Ultra-Lightweight Wireless', 3850000, N'TDP: 1W', N'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mjnkr1p25hxcb7', 17, 35, '2026-07-23 11:35:00.000', N'Razer'),
(527, N'Chuột máy tính SteelSeries Aerox 3 Wireless Onyx Superlight', 1850000, N'TDP: 1W', N'https://minhancomputercdn.com/media/product/10229_steelseries_aerox_3_wireless_black_4.jpg', 17, 60, '2026-07-23 11:35:00.000', N'SteelSeries'),
(528, N'Chuột máy tính Corsair M65 RGB ULTRA Wireless Gaming Mouse', 2450000, N'TDP: 1W', N'https://media.ldlc.com/r1600/ld/products/00/05/98/52/LD0005985249.jpg', 17, 50, '2026-07-23 11:35:00.000', N'Corsair'),
(529, N'Chuột máy tính ASUS ROG Keris II Ace Ultra-Lightweight Wireless', 3150000, N'TDP: 1W', N'https://dlcdnwebimgs.asus.com/gain/E9A5CF8D-2795-45DB-ABA7-D515962D8826/w1000/h732', 17, 40, '2026-07-23 11:35:00.000', N'ASUS'),
(530, N'Chuột máy tính Dareu EM901X RGB Wireless kèm Đế sạc', 590000, N'TDP: 1W', N'https://hugotech.vn/wp-content/uploads/EM901X-a.jpg', 17, 100, '2026-07-23 11:35:00.000', N'Dareu'),
(531, N'Chuột máy tính Rapoo VT9 PRO Dual-Mode Wireless Gaming Mouse', 790000, N'TDP: 1W', N'https://rapoostore.vn/wp-content/uploads/2024/05/Chuot-gaming-rapoo-vt9prodm.jpg', 17, 90, '2026-07-23 11:35:00.000', N'Samsung'),
(532, N'Chuột máy tính Fantech Helios II Pro XD3 V3 Wireless', 1250000, N'TDP: 1W', N'https://down-id.img.susercontent.com/file/id-11134208-7r98x-lxuwkmyu8eq237', 17, 70, '2026-07-23 11:35:00.000', N'Antec'),
(533, N'Tai nghe gaming HyperX Cloud III Wireless Black/Red 120-Hour Battery', 3850000, N'TDP: 1W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mdodsk4dl57wd1', 18, 40, '2026-07-23 11:35:00.000', N'HyperX'),
(534, N'Tai nghe gaming HyperX Cloud Stinger 2 Core Gaming Headset', 850000, N'TDP: 1W', N'https://product.hstatic.net/200000722513/product/thumbtainghe_499f42bf16fe47d28ab00bffb7bd5748_47730811ddaf40a0a969f4e4d49c7b27_1024x1024.png', 18, 90, '2026-07-23 11:35:00.000', N'HyperX'),
(535, N'Tai nghe gaming Razer BlackShark V2 Pro Wireless 2023 Edition', 4450000, N'TDP: 1W', N'https://m.media-amazon.com/images/I/71ZTXGr2g0L._AC_SL1500_.jpg', 18, 35, '2026-07-23 11:35:00.000', N'Razer'),
(536, N'Tai nghe gaming Razer Kraken Kitty V2 Pro RGB Quartz Pink', 4250000, N'TDP: 2W', N'https://laptopworld.vn/media/product/16639_76012_tai_nghe_gaming_co_day_razer_kraken_kitty_v2_pro_2023_edition_rgb_pink___rz04_04510200_r3m1_1.jpg', 18, 30, '2026-07-23 11:35:00.000', N'NZXT'),
(537, N'Tai nghe gaming Logitech G PRO X 2 LIGHTSPEED Wireless Graphene', 5650000, N'TDP: 1W', N'https://resource.logitechg.com/w_544,h_466,ar_7:6,c_pad,q_auto,f_auto,dpr_1.0/d_transparent.gif/content/dam/gaming/en/products/pro-x-2-lightspeed/gallery/gallery-3-pro-x-2-lightspeed-gaming-headset-black.png', 18, 25, '2026-07-23 11:35:00.000', N'Logitech'),
(538, N'Tai nghe gaming Logitech G733 LIGHTSPEED Wireless RGB White', 2950000, N'TDP: 1W', N'https://gangaelectronica.es/694377-large_default/logitech-g733-lightspeed-wireless-rgb-gaming-headset-white.jpg', 18, 50, '2026-07-23 11:35:00.000', N'Logitech'),
(539, N'Tai nghe gaming SteelSeries Arctis Nova Pro Wireless PC/PlayStation', 8950000, N'TDP: 2W', N'https://media.steelseriescdn.com/thumbs/filer_public/d7/b7/d7b782e8-2b82-4abd-8be1-790619ba6543/arctis_nova_pro_wl_black_img_buy_1.png__1920x1080_crop-fit_optimize_subsampling-2.png', 18, 15, '2026-07-23 11:35:00.000', N'SteelSeries'),
(540, N'Tai nghe gaming Corsair VIRTUOSO RGB WIRELESS High-Fidelity', 4850000, N'TDP: 2W', N'https://res.cloudinary.com/corsair-pwa/image/upload/v1665096094/akamai/landing/virtuoso/assets/images/VIRTUOSO-White.png', 18, 30, '2026-07-23 11:35:00.000', N'Corsair'),
(541, N'Tai nghe gaming ASUS ROG Pugi III Delta S Animate Display', 5250000, N'TDP: 2W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbacj96f7nivf2', 18, 20, '2026-07-23 11:35:00.000', N'ASUS'),
(542, N'Tai nghe gaming Dareu EH722X 7.1 Surround Sound Pink', 490000, N'TDP: 1W', N'https://songphuong.vn/Content/uploads/2021/08/Tai-nghe-DareU-EH722X-7.1-PINK-3.jpg', 18, 110, '2026-07-23 11:35:00.000', N'Dareu');
SET IDENTITY_INSERT products OFF;
DBCC CHECKIDENT ('products', RESEED, 542);
GO

-- ----------------------------------------------------------------------------
-- 6.2.1 BASE PRODUCT IMAGES SEED DATA (ẢNH PHỤ SẢN PHẨM)
-- ----------------------------------------------------------------------------
SET IDENTITY_INSERT product_images ON;
INSERT INTO product_images (id, product_id, image_url, display_order) VALUES
(1, 3, N'https://90a1c75758623581b3f8-5c119c3de181c9857fcb2784776b17ef.ssl.cf2.rackcdn.com/670842_614859_02_front_zoom.jpg', 1),
(2, 3, N'https://cdn.wccftech.com/wp-content/uploads/2023/08/Intel-Core-i7-14700K-Desktop-CPU-1272x1456.png', 2),
(3, 3, N'https://www.techpowerup.com/cpu-specs/images/chips/3268-front.jpg', 3),
(4, 4, N'https://www.notebookcheck.net/fileadmin/Notebooks/AMD/Ryzen_7_7800X3D/7800X3D_13.jpg', 1),
(5, 4, N'https://img.terabyteshop.com.br/produto/g/processador-amd-ryzen-7-7800x3d-42ghz-50ghz-turbo-8-cores-16-threads-am5-sem-cooler-100-100000910wof_168345.png', 2),
(6, 4, N'https://c1.neweggimages.com/ProductImageCompressAll1280/19-113-793-03.png', 3),
(7, 5, N'https://cdn.mos.cms.futurecdn.net/xVkRatttZGa9fdQryqDdRe.jpg', 1),
(8, 5, N'https://ru.gecid.com/data/cpu/202301270900-67021/img/01.jpg', 2),
(9, 5, N'https://gamers.ge/wp-content/uploads/2023/03/Intel-Core-i5-13600k.jpg', 3),
(10, 6, N'https://images.versus.io/objects/amd-ryzen-5-7600x.front.master2x.1664204182205.webp', 1),
(11, 6, N'https://media.karousell.com/media/photos/products/2026/8/23/ryzen_9_3900x__ryzen_5_7600x_a_1787472202_671ad70b_thumbnail.jpg', 2),
(12, 6, N'https://i.pcmag.com/imagery/reviews/05OVLEBZzMSOM3x2RbKV5Sv-1.fit_lim.size_1200x630.v1689803914.jpg', 3),
(13, 7, N'https://www.gizmochina.com/wp-content/uploads/2023/01/Intel-Core-i9-13900KS-1024x577.jpeg', 1),
(14, 7, N'https://static.techspot.com/articles-info/2607/images/2023-01-12-image-11.jpg', 2),
(15, 7, N'https://www.techspot.com/articles-info/2607/images/2023-01-12-image-3.jpg', 3),
(16, 8, N'https://ardes.bg/uploads/original/amd-ryzen-9-7900x-4-7ghz-tray-592981.jpg', 1),
(17, 8, N'https://static.tweaktown.com/content/1/0/10193_01_amd-ryzen-9-7900x-zen-4-cpu-review_full.jpg', 2),
(18, 8, N'https://staticg.sportskeeda.com/editor/2023/06/da0ca-16857745711084-1920.jpg', 3),
(19, 9, N'https://product.hstatic.net/200000350425/product/0f_tray_5.20_ghz__16c24t__30mb_07fdbbbcc8614976bb33b80f7f3c2bba_master_1ea1efb7e1a047a4ae87040d03c65a5b_1024x1024.jpg', 1),
(20, 9, N'https://product.hstatic.net/1000262653/product/0066898_i7-13700f_625_2037abc1b1774178bb1b6d39959bae5a_master.png', 2),
(21, 9, N'https://c.dns-shop.kz/thumb/st1/fit/500/500/2e1f110dba66ff0abbe0c26c25847a87/508258ad035677de5c75121013eeb77e38cb8402dfd8c51db169534cc58dc7bc.jpg', 3),
(22, 10, N'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AA24JQm6.img?w=1200&h=675&m=4&q=100', 1),
(23, 10, N'https://media.overclock3d.net/2026/07/AMD-Ryzen-7-5800X3D-Returns.jpg', 2),
(24, 10, N'https://cdn.videocardz.com/1/2026/06/AMD-RYZEN-5800X3D-ANNIVERSARY-3.jpg', 3),
(25, 11, N'https://bgamer.pro/wp-content/uploads/2022/12/12400f-oem-intel.jpg', 1),
(26, 11, N'https://tpucdn.com/cpu-specs/images/chips/2550-front.jpg', 2),
(27, 11, N'https://pccircle.com/wp-content/uploads/2022/06/12400f-1600x1600-1.jpg', 3),
(28, 12, N'https://ph-test-11.slatic.net/p/d0eb2d8cc8410f160f180e1e92c0b5ff.jpg', 1),
(29, 12, N'https://m.media-amazon.com/images/I/51f2hkWjTlL.jpg', 2),
(30, 12, N'https://i.pcmag.com/imagery/reviews/01ARy3N5KBJxT6QEKFoU6pr-11.jpg', 3),
(31, 13, N'https://cdn.wccftech.com/wp-content/uploads/2023/10/Intel-14th-Gen-Non-K-CPUs.png', 1),
(32, 13, N'https://i5.walmartimages.com/seo/HP-OmniDesk-Slim-Desktop-Intel-Core-i3-14100-up-to-4-7-GHz-nbsp-16-GB-DDR5-RAM-512-GB-SSD-Windows-11-Pro_72b7febc-f1df-4045-8595-2446b89b6fbe.a82689d40786976e68e982c11f07bb05.jpeg', 2),
(33, 13, N'https://www.vedantcomputers.com/image/catalog/assets/product/intel/processor/bx8071514100/bx8071514100-1.JPG', 3),
(34, 14, N'https://www.falconcomputers.co.uk/media/products/94109/0/0/amd-ryzen-3-4100-38ghz-4-core-am4-socket-overclockable-processor-with-wraith-steath-cooler-retail-boxed.jpg.jpg', 1),
(35, 14, N'https://albadrlaptop.com/wp-content/uploads/2022/07/AMD-Ryzen-3-4100-R3-4100-3-8-GHz-4-Core-8-Thread-CPU-Processor-7NM.jpg', 2),
(36, 14, N'https://down-ph.img.susercontent.com/file/ph-11134207-7r98w-lmzbklyaudfz25', 3),
(37, 15, N'https://www.notebookcheck.net/fileadmin/Notebooks/Sonstiges/Intel/Alder_Lake_S/Alder_Lake_S_7.jpg', 1),
(38, 15, N'https://media.ldlc.com/r1600/ld/products/00/05/90/02/LD0005900230_1.jpg', 2),
(39, 15, N'https://www.notebookcheck.net/fileadmin/Notebooks/News/_nc3/Alder_Lake_Intel_Core_i9_12900K_Benchmark.jpg', 3),
(40, 16, N'https://cdn.hstatic.net/products/200000722513/quantum_4af_arctic_02_ed802171675a4d3e8ad29e7cd9188824_master.png', 1),
(41, 16, N'https://cdn.hstatic.net/products/200000722513/quantum_4af_arctic_01_b7377c4c61ec4bf781e06666dce2d2f5_master.png', 2),
(42, 16, N'https://cdn.hstatic.net/files/200000722513/file/vo-may-tinh-xigmatek-quantum-4af-white-edition-9.jpg', 3),
(43, 17, N'https://www.custompc.com/wp-content/sites/custompc/2023/11/intel-core-i5-14400f-mockup.jpg', 1),
(44, 17, N'https://hoanglongcomputer.vn/media/lib/21-03-2024/intel-core-i5-3.jpg', 2),
(45, 17, N'https://m.media-amazon.com/images/I/61IgclF1FEL.jpg', 3),
(46, 18, N'https://cdn.mos.cms.futurecdn.net/gLeDESQXrcjjeDpo9H9eGi.jpg', 1),
(47, 18, N'https://m.media-amazon.com/images/I/615TPN-DayL.jpg', 2),
(48, 18, N'https://static1.xdaimages.com/wordpress/wp-content/uploads/wm/2024/01/amd-ryzen-5-8600g-box-hero-1.jpg', 3),
(49, 19, N'https://c1.neweggimages.com/ProductImageCompressAll1280/19-118-343-05.jpg', 1),
(50, 19, N'https://tpucdn.com/cpu-specs/images/chips/2507-front.jpg', 2),
(51, 19, N'https://i.pcmag.com/imagery/reviews/07rfvBq3YYV4bfaooOD3INP-4.jpg', 3),
(52, 20, N'https://www.techpowerup.com/review/amd-ryzen-7-7700-non-x/images/cpu-front.jpg', 1),
(53, 20, N'https://www.custompc.com/wp-content/sites/custompc/2023/02/amd-ryzen-7-7700-01.jpg', 2),
(54, 20, N'https://www.amd.com/content/dam/amd/en/images/products/processors/ryzen/2505503-ryzen-7-7700.jpg', 3),
(55, 21, N'https://a-static.mlcdn.com.br/1500x1500/processador-intel-core-i5-11400f-2-60ghz-4-40ghz-turbo-12mb/magazineluiza/228768800/befeb27fcffcc6bceebb2511e555f904.jpg', 1),
(56, 21, N'https://acf.geeknetic.es/Imagenes/Tutoriales/2021/2030-intel-core-i5-11400f/2030-intel-core-i5-11400f-cabecera.jpg', 2),
(57, 21, N'https://www.ryans.com/storage/products/main/intel-11th-gen-rocket-lake-core-i5-11400f-21693815949.webp', 3),
(58, 22, N'https://m.media-amazon.com/images/I/91OZjLdueYL._AC_SL1500_.jpg', 1),
(59, 22, N'https://techarc.pk/wp-content/uploads/2022/05/AMD-Ryzen-5-4500-6-Cores-12-Threads-3.6-GHZ-8MB-Cache-Processor-Tray.jpg', 2),
(60, 22, N'https://www.adrenaline.com.br/wp-content/uploads/2022/06/amd_ryzen_5_4500_adrenaline_review.jpg', 3),
(61, 23, N'https://tpucdn.com/cpu-specs/images/chips/2366-front.jpg', 1),
(62, 23, N'https://multimedia.bbycastatic.ca/multimedia/products/1500x1500/154/15483/15483087_8.jpg', 2),
(63, 23, N'https://assetsio.reedpopcdn.com/intel-core-i9-11900k-review.jpg?width=1920&height=1920&fit=bounds&quality=80&format=jpg&auto=webp', 3),
(64, 24, N'https://cdn.mos.cms.futurecdn.net/vGsWXZMtfiTh98C9byptok.jpg', 1),
(65, 24, N'https://www.techspot.com/articles-info/1871/images/ryzen-3600-1.jpg', 2),
(66, 24, N'https://www.hwcooling.net/wp-content/uploads/2021/09/amd-ryzen-5-3600_01.jpg', 3),
(67, 25, N'https://media.ldlc.com/r1600/ld/products/00/05/66/90/LD0005669091_1.jpg', 1),
(68, 25, N'https://cdn.citilink.ru/t44av4khI-_sr3uehnc70efboD0SxVEhqHETvkiI8gQ/resizing_type:fit/gravity:sm/width:400/height:400/plain/product-images/491e6e34-3000-4733-8095-3e118a2a09d1.jpg', 2),
(69, 25, N'https://ir.ozone.ru/s3/multimedia-g/c1000/6904392316.jpg', 3),
(70, 26, N'https://elchapuzasinformatico.com/wp-content/uploads/2019/07/AMD-Ryzen-9-3900X-01.jpg', 1),
(71, 26, N'https://m.media-amazon.com/images/I/71ZANS0SSDL._AC_.jpg', 2),
(72, 26, N'https://www.techpowerup.com/cpu-specs/images/chips/2128-front.jpg', 3),
(73, 27, N'https://tmdpc.vn/media/news/3005_TngtclmvicmnhmtrnmitcvviCPUIntelPentiumGoldG7400Dual-Corethhth12.jpg', 1),
(74, 27, N'https://gw.alicdn.com/imgextra/O1CN01lyuetT28JkPIiSipG_!!6000000007912-0-yinhe.jpg_q90.jpg', 2),
(75, 27, N'https://m.media-amazon.com/images/I/51SaOy27+bL._SL1000_.jpg', 3),
(76, 28, N'https://www.overclockers.ua/cpu/amd-athlon-3000g/01-big-amd-athlon-3000g.jpg', 1),
(77, 28, N'https://www.nexus.com.bd/images/detailed/8/AMD_Athlon_3000G_Radeon_Graphics_Processor.jpg', 2),
(78, 28, N'https://androidpctv.com/wp-content/uploads/2020/01/amd-athlon-3000g-review-f01-min.jpg', 3),
(79, 29, N'https://elchapuzasinformatico.com/wp-content/uploads/2020/07/Intel-Core-i7-10700K-04.jpg', 1),
(80, 29, N'https://tpucdn.com/cpu-specs/images/chips/2215-front.jpg', 2),
(81, 29, N'https://www.techpowerup.com/review/intel-core-i7-10700k/images/package1.jpg', 3),
(82, 30, N'https://cdn.mos.cms.futurecdn.net/aw7i8ZbLc8C3eR5ydxMer5.jpg', 1),
(83, 30, N'https://cafedigital.cl/wp-content/uploads/2024/07/AMD-Ryzen-7-8700G.jpg', 2),
(84, 30, N'https://cdn.mos.cms.futurecdn.net/CP9xBK59FzAWKn59RgrxUJ.jpg', 3),
(85, 31, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6536/6536574_sd.jpg', 1),
(86, 31, N'https://m.media-amazon.com/images/I/711vU2IrEuL._AC_SL1500_.jpg', 2),
(87, 31, N'https://m.media-amazon.com/images/I/71bYAEtC-CL._AC_SL1500_.jpg', 3),
(88, 32, N'https://dlcdnwebimgs.asus.com/files/media/F8F6C69D-D9CA-4643-90D7-A0F46B1484E1/v1/img/explosion/pd.png', 1),
(89, 32, N'https://www.picclickimg.com/9PAAAeSw5oRqdEgU/NVIDIA-GeForce-RTX-4080-Super-32GB-2SLOT-Turbo.webp', 2),
(90, 32, N'https://www.pcgamesn.com/wp-content/sites/pcgamesn/2023/10/nvidia-geforce-rtx-4080-super.jpg', 3),
(91, 33, N'https://pangoly.com/images/trends/vga/rtx-4070-ti-super-us.jpg', 1),
(92, 33, N'https://www.techpowerup.com/review/asus-geforce-rtx-4070-ti-super-tuf/images/title.jpg', 2),
(93, 33, N'https://getpc.co.in/images/parts/rtx-4070-ti-super-16gb.png?v=2', 3),
(94, 34, N'https://sm.ign.com/ign_ap/photo/default/pxl-20221205-200737220-portrait-1670634086080_cwha.jpg', 1),
(95, 34, N'https://static.gigabyte.com/StaticFile/Image/Global/868436ba12e23fc0d98e26322a618a2c/Product/32810/Png', 2),
(96, 34, N'https://staticg.sportskeeda.com/editor/2022/11/10914-16675652399097-1920.jpg', 3),
(97, 35, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6545/6545279cv12d.jpg', 1),
(98, 35, N'https://www.notebookcheck.net/uploads/tx_nbc2/RTX_4060_Ti_Gaming_X_Trio_7.jpg', 2),
(99, 35, N'https://m.media-amazon.com/images/I/71U826jfF1L._AC_.jpg', 3),
(100, 36, N'https://cdn.cloudflare.steamstatic.com/steam/apps/12150/library_hero.jpg', 1),
(101, 36, N'https://fpsbench.com/static/images/game_images/16_9/palworld.webp', 2),
(102, 36, N'https://www.pcgamesn.com/wp-content/sites/pcgamesn/2023/08/amd-radeon-rx-7800-xt-price.jpg', 3),
(103, 37, N'https://m.media-amazon.com/images/I/81si2RRaWUS.jpg', 1),
(104, 37, N'https://m.media-amazon.com/images/I/71tduSp8ooL._AC_.jpg', 2),
(105, 37, N'https://m.media-amazon.com/images/I/811sBakp3+L.jpg', 3),
(106, 38, N'https://m.media-amazon.com/images/I/811J2PwncGL._AC_SL1500_.jpg', 1),
(107, 38, N'https://m.media-amazon.com/images/I/813YnK6DdrL._AC_.jpg', 2),
(108, 38, N'https://m.media-amazon.com/images/I/71L0p7ALaQL._AC_.jpg', 3),
(109, 39, N'https://dlcdnwebimgs.asus.com/files/media/015AF38A-127E-4FA8-9700-6D92BB2760C1/v2/img/kv/pd.png', 1),
(110, 39, N'https://dlcdnwebimgs.asus.com/gain/41CD18DA-4E72-4A31-9C61-01B2B6D13A1A/w1000/h732', 2),
(111, 39, N'https://static0.gamerantimages.com/wordpress/wp-content/uploads/2023/02/asus-rog-strix-4090.jpg', 3),
(112, 40, N'https://www.alktech.co/hubfs/MSI%20GeForce%20RTX%204070%20GAMING%20X%20TRIO%2012G/Featured%20Image.jpg', 1),
(113, 40, N'https://www.igorslab.de/wp-content/uploads/2023/04/Intro-2.jpg', 2),
(114, 40, N'https://asset.msi.com/resize/image/global/product/product_1704703822984da48f4e57873dd8ba9f899f1df6ac.png62405b38c58fe0f07fcef2367d8a9ba1/400.png', 3),
(115, 41, N'https://static.gigabyte.com/StaticFile/Image/Global/ca46ef321ac872a92db97cd434c951b6/Product/39542/Png', 1),
(116, 41, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6548/6548585_sd.jpg', 2),
(117, 41, N'https://media.ldlc.com/bo/images/fiches/Carte_graphique/Gigabyte/gigabyte_rtx_eagle_001.jpg', 3),
(118, 42, N'https://thecomparator.tech/images/og-image.jpg', 1),
(119, 42, N'https://img.pccomponentes.com/articles/1081/10819242/129-asus-dual-geforce-rtx-4070-super-evo-oc-edition-12gb-gddr6x-dlss3.jpg', 2),
(120, 42, N'https://getpc.co.in/images/parts/rtx-4070-super-12gb.jpg?v=2', 3),
(121, 43, N'https://m.media-amazon.com/images/I/813l7nGCBxL._AC_.jpg', 1),
(122, 43, N'https://m.media-amazon.com/images/I/71+Lh5QLfyL._AC_.jpg', 2),
(123, 43, N'https://www.techpowerup.com/img/ebYxSkxPIeH7mUCh.jpg', 3),
(124, 44, N'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/s/msi-rtx-3050-ventus-2x-6g-oc-0.jpg', 1),
(125, 44, N'https://static.gigabyte.com/StaticFile/Image/Global/b0c2426a654a052664f7f046fc601b38/Product/39599/Png', 2),
(126, 44, N'https://m.media-amazon.com/images/I/81mwcITtHBL._AC_SL1500_.jpg', 3),
(127, 45, N'https://m.media-amazon.com/images/I/81LUlHjB9YL._AC_SL1500_.jpg', 1),
(128, 45, N'https://m.media-amazon.com/images/I/81w-5i9+nbL._AC_.jpg', 2),
(129, 45, N'https://www.zotac.com/system/files/news/desc/images/nvidia_rtx_4060_8gb_launch_-_feature_focus_banners2_1200x675.png', 3),
(130, 46, N'https://microless.com/cdn/products/9d092288494f0af86f8a7ddf7d3954e9-hi.jpg', 1),
(131, 46, N'https://microless.com/cdn/products/cdddf0af7f8c6c272bfef16cb345856c-hi.jpg', 2),
(132, 46, N'https://tpucdn.com/gpu-specs/images-new/b/11589-rear-large.jpg', 3),
(133, 47, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6467/6467840_sd.jpg', 1),
(134, 47, N'https://www.windowscentral.com/sites/wpcentral.com/files/styles/large_wm_brb/public/field/image/2021/07/asus-tuf-gaming-nvidia-geforce-rtx-3070-ti-hero.jpg', 2),
(135, 47, N'https://tpucdn.com/gpu-specs/images/b/8970-bottom.jpg', 3),
(136, 48, N'https://c1.neweggimages.com/ProductImageCompressAll1280/14-487-518-01.jpg', 1),
(137, 48, N'https://m.media-amazon.com/images/I/716D2J5JcvL._AC_.jpg', 2),
(138, 48, N'https://static.tandoanh.vn/wp-content/uploads/2020/09/EVGA-GeForce-RTX-3080-FTW3-ULTRA-GAMING-10GB-GDDR6X-01.jpeg', 3),
(139, 49, N'https://www.techpowerup.com/review/sapphire-radeon-rx-7900-gre-pulse/images/title.jpg', 1),
(140, 49, N'https://m.media-amazon.com/images/I/81jooy0ipEL._AC_.jpg', 2),
(141, 49, N'https://www.techpowerup.com/review/sapphire-radeon-rx-7900-gre-pure/images/title.jpg', 3),
(142, 50, N'https://m.media-amazon.com/images/I/81kt9CenGUL.jpg', 1),
(143, 50, N'https://m.media-amazon.com/images/I/71xBR512Z-L._AC_SL1500_.jpg', 2),
(144, 50, N'https://media.ldlc.com/r1600/ld/products/00/06/17/51/LD0006175116.jpg', 3),
(145, 51, N'https://m.media-amazon.com/images/I/81Ibi02jRrL._AC_.jpg', 1),
(146, 51, N'https://images.nvidia.com/aem-dam/Solutions/geforce/graphic-cards/gtx-1650/pop-up/geeforce-gtx-1650-dt-gallery-i.jpg', 2),
(147, 51, N'https://www.notebookcheck.net/fileadmin/_processed_/d/8/csm_GTX_1650_Super_1_f072a54841.jpg', 3),
(148, 52, N'https://m.media-amazon.com/images/I/81omrjP1GBL._AC_SL1500_.jpg', 1),
(149, 52, N'https://www.notebookcheck.net/fileadmin/Notebooks/AMD/RX_6700_XT/AMD_Radeon_RX_6700_XT_Graphics_Card_1.jpg', 2),
(150, 52, N'https://www.pcguide.com/wp-content/uploads/2023/12/Sapphire-Pulse-AMD-Radeon-RX-6700-XT.jpg', 3),
(151, 53, N'https://kccshop.vn/media/product/250-3561-vga-colorful-geforce-rtx-4080-16gb-nb-ex-v_3_main.jpeg', 1),
(152, 53, N'https://songphuong.vn/Content/uploads/2022/11/VGA-Colorful-iGame-GeForce-RTX-4080-16GB-Vulcan-OC-V-songphuong.vn-03.jpg', 2),
(153, 53, N'https://www.techpowerup.com/review/colorful-geforce-rtx-4080-ultra-w-oc/images/title.jpg', 3),
(154, 54, N'https://m.media-amazon.com/images/I/71l7sbREViL._AC_.jpg', 1),
(155, 54, N'https://assets.vinhpici.vn/card-man-hinh-leadtek-quadro-rtx-a4000-16gb.webp', 2),
(156, 54, N'https://5.imimg.com/data5/SELLER/Default/2026/3/588660641/PP/KQ/SO/244556722/nvidia-rtx-a4000-16gb-gddr6-workstation-graphics-card-quadro-oem-3-years-warranty-1000x1000.png', 3),
(157, 55, N'https://www.amd.com/content/dam/amd/en/images/products/graphics/2922553-radeon-pro-w7800-front-product.jpg', 1),
(158, 55, N'https://cdn.thefpsreview.com/wp-content/uploads/2024/11/gigabyte-launches-amd-radeon-pro-w7800-ai-top-48g-graphics-card-feature-1024x576.jpg', 2),
(159, 55, N'https://m.media-amazon.com/images/I/61dDG+1KuiL._AC_SL1500_.jpg', 3),
(160, 56, N'https://m.media-amazon.com/images/I/71rzJRZ7lIL.jpg', 1),
(161, 56, N'https://files.pccasegear.com/images/1665549101-21P01J00BA-thb.jpg', 2),
(162, 56, N'https://www.asrock.com/Graphics-Card/photo/Intel%20Arc%20A770%20Challenger%2016GB%20OC(L1).png', 3),
(163, 57, N'https://cdn.mos.cms.futurecdn.net/gyxybrmhdro4aDVz6rE2TK.jpg', 1),
(164, 57, N'https://www.geeks3d.com/public/jegx/2022q4/intel/arc-a750-limited-edition-graphics-card-06.jpg', 2),
(165, 57, N'https://cdn.mos.cms.futurecdn.net/dCaCdnc88HHcD3yGaKQRBK-1200-80.jpg', 3),
(166, 58, N'https://i7solutions.in/wp-content/uploads/2024/01/ASUS-Dual-RTX-4070-SUPER-OC-Edition-12GB-GDDR6X-Graphic-Card.webp', 1),
(167, 58, N'https://static0.gamerantimages.com/wordpress/wp-content/uploads/2023/05/asus-dual-geforce-rtx-4070-oc-edition.jpg', 2),
(168, 58, N'https://media.ldlc.com/r1600/ld/products/00/06/10/37/LD0006103744_0006109340.jpg', 3),
(169, 59, N'https://m.media-amazon.com/images/I/711vU2IrEuL.jpg', 1),
(170, 59, N'https://www.gigabyte.com/FileUpload/global/news/2067/o202302181021372549.png', 2),
(171, 59, N'https://www.hardwareluxx.de/images/cdn02/uploads/2022/Oct/peppy_energy_8p/gigabyte-geforce-rtx4090-windforce-00001_3840px.jpg', 3),
(172, 60, N'https://www.pny.com/productimages/6EB0942C-A195-420F-A3A2-B00600FB8234/images/PNY-RTX-4060-8GB-VERTO-Dual-Fan-top-2.png', 1),
(173, 60, N'https://img.terabyteshop.com.br/produto/g/placa-de-video-pny-nvidia-geforce-rtx-4060-verto-dual-fan-8gb-gddr6-dlss-ray-tracing-vcg40608dfxpb1_173616.jpg', 2),
(174, 60, N'https://m.media-amazon.com/images/I/617QVnCqXYL._AC_SL1000_.jpg', 3),
(175, 61, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6562/6562314_sd.jpg', 1),
(176, 61, N'https://m.media-amazon.com/images/I/61-Ag2lc5BL._AC_.jpg', 2),
(177, 61, N'https://m.media-amazon.com/images/I/71AV5PQu1yL._AC_.jpg', 3),
(178, 62, N'https://m.media-amazon.com/images/I/71DiVTefKBL._AC_.jpg', 1),
(179, 62, N'https://www.gskill.com/img/overview/tz5-rgb/04-trident-z5-rgb-extreme-memory-performance.jpg', 2),
(180, 62, N'https://m.media-amazon.com/images/I/61bc6zvEIIL._SL1280_.jpg', 3),
(181, 63, N'https://m.media-amazon.com/images/I/71yCX7riNfS._AC_.jpg', 1),
(182, 63, N'https://m.media-amazon.com/images/I/71nQp70NhYL._AC_SL1500_.jpg', 2),
(183, 63, N'https://nomadaware.com.ec/wp-content/uploads/NomadaWare_RAM_16gb_kingston_fury_beast-3.webp', 3),
(184, 64, N'https://m.media-amazon.com/images/I/81ov4cFmdaL._AC_.jpg', 1),
(185, 64, N'https://c1.neweggimages.com/productimage/nb1280/20-331-923-07.jpg', 2),
(186, 64, N'https://os-jo.com/image/cache/catalog/products/memory/FF3D532G6000HC30DC01/81XZeKnL6LL._AC_UF894,1000_QL80_-1200x1200.jpg', 3),
(187, 65, N'https://www.esocket.us/wp-content/uploads/2021/01/20210128_211718-scaled.jpg', 1),
(188, 65, N'https://khabirtech.com/wp-content/uploads/2024/12/ADATA-XPG-LANCER-RGB-DDR5-16GB-6400MHZ-WHITE-0.webp', 2),
(189, 65, N'https://khabirtech.com/wp-content/uploads/2024/12/ADATA-XPG-LANCER-RGB-DDR5-16GB-6000MHZ-BLACK-0.webp', 3),
(190, 66, N'https://m.media-amazon.com/images/I/61FsaYbk3UL._SL1080_.jpg', 1),
(191, 66, N'https://tv-it.com/storage/shada/corsair-ram/crucial-8gb-ram-3200.webp', 2),
(192, 66, N'https://tienda.tecno-site.com/wp-content/uploads/2022/08/CB8GS2666-1.jpg', 3),
(193, 67, N'https://exo.ir/image/cache/catalog/Products/Corsair/RAM/Dominator-Titanium-Series/Black/Corsair-Dominator-Titanium-Single-Black-2-1500x1500.jpg', 1),
(194, 67, N'https://media.ldlc.com/r1600/ld/products/00/06/06/83/LD0006068354.jpg', 2),
(195, 67, N'https://m.media-amazon.com/images/I/71Tyd3prKVL._AC_.jpg', 3),
(196, 68, N'https://ryans.com/storage/products/main/gskill-ripjaws-v-16gb-ddr4-3200mhz-black-11723012156.webp', 1),
(197, 68, N'https://kccshop.vn/media/product/250-292-59265_ram_desktop_gskill_ripjaws_v_f4_3000c16d_16gvrb_16gb_2x8gb_ddr4_3000mhz.jpg', 2),
(198, 68, N'https://www.techtradecenter.si/modules/uploader/uploads/s_product/pictures/g.skill-ripjaws-v-16gb-2x8gb-3200-0-2.jpg', 3),
(199, 69, N'https://i.ytimg.com/vi/TqvG24RTtGw/maxresdefault.jpg', 1),
(200, 69, N'https://pcinq.com/wp-content/uploads/2023/10/Lexar_Thor-OC-DDR5-6000_Cover.webp', 2),
(201, 69, N'https://thinkcomputers.org/wp-content/uploads/2023/12/lexar-thor-ddr5-1.jpg', 3),
(202, 70, N'https://www.cclonline.com/images/avante/ktc-renegade-ddr5-dimm-1_pb_hr.jpg?width=1600&height=1600&scale=canvas', 1),
(203, 70, N'https://m.media-amazon.com/images/I/71gjg2cODZL._AC_SL1500_.jpg', 2),
(204, 70, N'https://img.evetech.co.za/repository/ProductImages/kingston-fury-renegade-rgb-32gb-7200mhz-ddr5-black-memory-1600px-v1-01.webp', 3),
(205, 71, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/5878/5878702cv1d.jpg', 1),
(206, 71, N'https://www.cqnetcr.com/112706-thickbox_default/memoria-ram-pny-xlr8-gaming-epicx-rgb-16gb-3200mhz.jpg', 2),
(207, 71, N'https://flt.com.np/wp-content/uploads/2025/01/61VWL7Bw-7L._AC_SL1500.jpg', 3),
(208, 72, N'https://www.jspwholesale.co.uk/images/spusb16gb.jpg', 1),
(209, 72, N'https://c1.neweggimages.com/productimage/nb640/0BD-0095-000H2-03.jpg', 2),
(210, 72, N'https://assets.umart.com.au/newsite/images/201805/source_img/40058_P_1526614652255.jpg', 3),
(211, 73, N'https://cdn.idealo.com/folder/Product/202588/0/202588055/s1_produktbild_max/mushkin-redline-32gb-kit-ddr4-4000-cl18-mrd4u400jnnm16gx2.jpg', 1),
(212, 73, N'https://images.kaina24.lt/10043/100/mushkin-redline-mra5s560lkkd32g-cl46-32gb-ddr5-5600-mhz-sodimm-raudona.jpg', 2),
(213, 73, N'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/r/mra5s560lkkd16gx2-0.jpg', 3),
(214, 74, N'https://tanphatad.com/wp-content/uploads/tanphatad/Patriot-Memory-Viper-Venom-RGB-DDR5-600-RAM-16GB-3.jpg', 1),
(215, 74, N'https://i5.walmartimages.com/seo/Patriot-Viper-Elite-5-RGB-DDR5-RAM-16GB-1X16GB-6000MT-s-CL42-1-35v-UDIMM-Desktop-Gaming-Memory-Compatible-with-Intel-XMP-AMD-EXPO-PVER516G60C42W_6dba079f-98c1-4be9-9f4c-6ec007d986af.d185365116b0a413c74cc954c9008a40.jpeg', 2),
(216, 74, N'https://images.tcdn.com.br/img/img_prod/1237151/memria_ram_ddr4_16gb_1x16gb_3200mhz_cl18_patriot_v_1_20260425170315_8fd9cd19c9e8.png', 3),
(217, 75, N'https://jumbocolombiaio.vtexassets.com/arquivos/ids/476318/8806094731989_1.jpg?v=638163096318000000', 1),
(218, 75, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6501/6501378_sd.jpg', 2),
(219, 75, N'https://gadgetcentral.co.ke/wp-content/uploads/2022/11/Samsung-Galaxy-A04-c.jpg', 3),
(220, 76, N'https://assets.umart.com.au/newsite/images/202001/source_img/53720_P_1578271331027.jpg', 1),
(221, 76, N'https://assets.umart.com.au/newsite/images/202004/source_img/54426_P_1588206992013.jpg', 2),
(222, 76, N'https://img.watercoolinguk.co.uk/2025/09/thermaltake-waterram-rgb-ddr4-3200-cl16-16gb-dual-kit-mett-001-69265-1.jpg', 3),
(223, 77, N'https://exo.ir/image/cache/catalog/Products/Zadak/RAM/zadak-spark-rgb-ddr4/zadak-spark-rgb-dual-3-1500x1500.jpg', 1),
(224, 77, N'https://down-id.img.susercontent.com/file/id-11134201-7rask-m4l86b1wfkhka1', 2),
(225, 77, N'https://static.tweaktown.com/news/8/5/85664_03_zadak-unveils-spark-rgb-ddr5-memory-up-to-32gb-kits-of-6400_full.jpg', 3),
(226, 78, N'https://www.tncstore.vn/media/product/6898-63927_ram_desktop_apacer_oc_panther_golden_ah4u08g32c28y7gaa_1_8gb_1x8gb_ddr4_3200mhz.jpg', 1),
(227, 78, N'https://smartbd.com/wp-content/uploads/2024/10/Panther_RGB_DDR5_01.png', 2),
(228, 78, N'https://songphuong.vn/Content/uploads/2021/11/Ram-Apacer-OC-Panther-Golden-8GB-DDR4-3200MHz-1-songphuong.vn_.jpg', 3),
(229, 79, N'https://www.memoryc.com/images/products/bb/geil-16570-2_63013.jpg', 1),
(230, 79, N'https://down-my.img.susercontent.com/file/vn-11134207-7ras8-m1ffx3pz96tbd8', 2),
(231, 79, N'https://c1.neweggimages.com/productimage/nb640/20-144-937-03.jpg', 3),
(232, 80, N'https://nexushub.co.za/images/products/00267/awxpch234622-5-9f5.jpg', 1),
(233, 80, N'https://phantom-ps.com/cdn/shop/files/R15.webp?v=1774039579&width=1600', 2),
(234, 80, N'https://c1.neweggimages.com/productimage/nb640/AMCMS2202160GTRRZBE.jpg', 3),
(235, 81, N'https://m.media-amazon.com/images/I/71CpgA2mMCL._AC_SL1500_.jpg', 1),
(236, 81, N'https://m.media-amazon.com/images/I/715QXNdKxiL._AC_.jpg', 2),
(237, 81, N'https://img.evetech.co.za/repository/ProductImages/kingston-fury-beast-rgb-64gb-6400mhz-ddr5-cl32-1500px-v1.webp', 3),
(238, 82, N'https://trivico.la/images/products/detail/RAM%20PC%20DDR4%2032Gb%20Kit%2016x2%20Bus%203200%20Corsair%20VENGEANCE%20LPX%20DTC463.jpg', 1),
(239, 82, N'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Memory/CMK32GX4M1D3000C16/Gallery/VENG_LPX_BLK_01.webp', 2),
(240, 82, N'https://c1.neweggimages.com/ProductImage/20-236-758-01.jpg', 3),
(241, 83, N'https://files.pccasegear.com/UserFiles/F4-4000C18Q-128GTZR-gskill-trident-z-rgb-128gb-4x32gb-4000mhz-cl18-ddr4-product1.jpg', 1),
(242, 83, N'https://img.lazcdn.com/g/p/a79f5dede9a24f0984e7d7a4c83e528f.png_720x720q80.png', 2),
(243, 83, N'https://www.pcstudio.in/wp-content/uploads/2020/07/G.SKILL-Trident-Z-Neo-Series-32GB-feature1.jpg', 3),
(244, 84, N'https://technokomputerbali.com/img/item/231115090841.jpg', 1),
(245, 84, N'https://down-id.img.susercontent.com/file/sg-11134201-82289-mhrp4a702nlt2e', 2),
(246, 84, N'https://down-id.img.susercontent.com/file/id-11134207-7rbk1-m85s5rwe83lkb7', 3),
(247, 85, N'https://5sc.vn/wp-content/uploads/2023/07/Crucial-DDR5-Pro-UDIMM-Packaging-Image-Left.png', 1),
(248, 85, N'https://www.myorderstore.com/image/cache/catalog/Products/Products/crucial32gbpro1-550x550h.png.webp', 2),
(249, 85, N'https://cdn.vatanbilgisayar.com/Upload/PRODUCT/crucial/thumb/basliksiz-1_large.jpg', 3),
(250, 86, N'https://static.gigabyte.com/StaticFile/Image/Global/4324ea44795c4e200f1894e92fa3af05/Product/24456', 1),
(251, 86, N'https://static.gigabyte.com/StaticFile/Image/Global/ad60477ff44e587c09b67ee56b883341/Product/19876', 2),
(252, 86, N'https://arabcomputer.net/wp-content/uploads/2021/04/RAM-AORUS-RGB-DDR4-16GB.jpg', 3),
(253, 87, N'https://product.hstatic.net/1000340975/product/61gzda7yzsl._ac_sl1000__33a2b4182da34e81a2a9f02a7dc347f1_master.jpg', 1),
(254, 87, N'https://taipeicomputer.jo/image/cache/catalog/Products/Ram/LEXAR-6000-B-1200x1200.jpg', 2),
(255, 87, N'https://www.gaming.gen.tr/wp-content/uploads/2024/08/lexar-ares-rgb-32gb-2x16gb-6400mhz-cl32-intel-xmp-3-0-amd-expo-ddr5-heatsink-siyah-ram-ld5eu016g-r6400gdla-1.jpg', 3),
(256, 88, N'https://www.techtradecenter.si/modules/uploader/uploads/s_product/pictures/netac-shadow-grey-16gb-3200mhz-dd-0.jpg', 1),
(257, 88, N'https://images.tcdn.com.br/img/img_prod/1165337/memoria_ram_gamer_desktop_16gb_ddr4_3200mhz_netac_shadow_cinza_21225_1_fd205243bcd5d36c8a36e7d8ee39a6a0.jpg', 2),
(258, 88, N'https://compday.ru/files/reg/920767.jpeg', 3),
(259, 89, N'https://pegasus.hk/cdn-cgi/imagedelivery/gTpMHUmncPYPe7GoYL67Ag/35f56699-99be-412f-5ea0-7b28a5dbd200/public', 1),
(260, 89, N'https://static.chiphell.com/portal/202303/16/091543zp4440yh6ur4r4us.jpeg', 2),
(261, 89, N'https://image-cdn.ubuy.com/galax-geforce-rtx-5090-d-hof-oc-lab/400_400_100/68e18ec7eedc747f1a0a029c.jpg', 3),
(262, 90, N'https://c1.neweggimages.com/productimage/nb1280/20-821-543-03.jpg', 1),
(263, 90, N'https://c1.neweggimages.com/productimage/nb1280/20-821-371-V02.jpg', 2),
(264, 90, N'https://i5.walmartimages.com/seo/OLOy-Blade-RGB-32GB-2-x-16GB-288-Pin-PC-RAM-DDR4-3600-PC4-28800-Desktop-Memory-Model-ND4U1636181DRKDE_e65c195a-eba5-42b3-9551-e8dfdd9cf1ce.1b1974844fb12e93389871c8ea8b08fc.jpeg', 3),
(265, 91, N'https://dlcdnwebimgs.asus.com/files/media/29C004F7-7B1F-4EBF-9099-7168B520A0EE/v1/img/kv/pd.png', 1),
(266, 91, N'https://dlcdnwebimgs.asus.com/gain/A3777166-EF70-4D33-915B-EC65CF77CAE5', 2),
(267, 91, N'https://m.media-amazon.com/images/I/81CpgF-+P4L._AC_SL1500_.jpg', 3),
(268, 92, N'https://storage-asset.msi.com/global/picture/image/feature/mb/B760M/mag-b760m-mortar-wifi/msi-b760m-mortar-wifi-hero-01.png', 1),
(269, 92, N'https://storage-asset.msi.com/global/picture/image/feature/mb/B760M/B760M_mortar_max_wifi_ddr4/msi-b760m-mortar-max-wifi-ddr4-cooling-overview-mobile.png', 2),
(270, 92, N'https://microless.com/cdn/products/6bda68422d2b337921b1ef9d9d8881ca-hi.jpg', 3),
(271, 93, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2204/innergigabyteimages/specsmall02.jpg', 1),
(272, 93, N'https://m.media-amazon.com/images/I/81a48Z1GciL._AC_.jpg', 2),
(273, 93, N'https://media.ldlc.com/r1600/ld/products/00/05/98/63/LD0005986363.jpg', 3),
(274, 94, N'https://dlcdnwebimgs.asus.com/files/media/2b278afc-50b2-452f-9fae-ec2825d27632/V1/img/performance/fan.jpg', 1),
(275, 94, N'https://b2c-contenthub.com/wp-content/uploads/2023/02/Screenshot-2022-12-29-at-2.13.36-PM.png?w=1200', 2),
(276, 94, N'https://media.ldlc.com/r1600/ld/products/00/05/98/60/LD0005986041.jpg', 3),
(277, 95, N'https://www.asrock.com/mb/photo/B660M%20Pro%20RS(L3).png', 1),
(278, 95, N'https://m.media-amazon.com/images/I/8107uOIZKJL._AC_SL1500_.jpg', 2),
(279, 95, N'https://www.asrock.com/mb/photo/B660M%20Pro%20RS(L2).png', 3),
(280, 96, N'https://www.pcstudio.in/wp-content/uploads/2022/09/Msi-Mpg-X670E-Carbon-Wifi-Motherboard-2.jpg', 1),
(281, 96, N'https://storage-asset.msi.com/global/picture/image/feature/mb/X670/mpg/X670E-CARBON-WIFI/mpg_x670e_carbon_wifi-block03.png', 2),
(282, 96, N'https://cf.shopee.com.my/file/67bf200082cfdea4ca7c008803e5692f', 3),
(283, 97, N'https://dlcdnwebimgs.asus.com/gain/2fd65e16-7cf6-4cf7-aa38-aae547279334/', 1),
(284, 97, N'https://media.ldlc.com/r1600/ld/products/00/06/06/10/LD0006061052.jpg', 2),
(285, 97, N'https://ravensound.mx/wp-content/uploads/2023/12/PRIMEH610MK.jpg', 3),
(286, 98, N'https://static.gigabyte.com/StaticFile/Image/Global/3432e2f607b5fd3419d9f3484f5c01c3/Product/25763', 1),
(287, 98, N'https://static.gigabyte.com/StaticFile/Image/Global/8063a308075cb09979de256215c87fed/Product/41466/Png', 2),
(288, 98, N'https://m.media-amazon.com/images/I/71j7EWG-wZL._AC_SL1500_.jpg', 3),
(289, 99, N'https://www.hwcooling.net/wp-content/uploads/2024/06/asus-rog-strix-b760-i-gaming-wifi_02.jpg', 1),
(290, 99, N'https://dlcdnwebimgs.asus.com/files/media/620E2CDE-9776-43C3-A42A-7C71FA472699/v1/img/kv/ROG-Strix-B760-I-Gaming.png', 2),
(291, 99, N'https://dlcdnwebimgs.asus.com/files/media/620E2CDE-9776-43C3-A42A-7C71FA472699/v1/img/style/id-design.png', 3),
(292, 100, N'https://asset.msi.com/resize/image/global/product/product_16661726339f12033bbba864d39aed90475d2d5481.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 1),
(293, 100, N'https://storage-asset.msi.com/global/picture/image/feature/mb/Z790/meg-z790-godlike-max/images/mb-godlike-max-02.png', 2),
(294, 100, N'https://storage-asset.msi.com/global/picture/image/feature/mb/Z790/MEG-Z790-GODLIKE/mb-godlike-01.png', 3),
(295, 101, N'https://www.asrock.com/mb/features/Z790%20Taichi%20Carrara_mobile.jpg', 1),
(296, 101, N'https://www.ocinside.de/media/uploads/asrock_z790_taichi_8.jpg', 2),
(297, 101, N'https://www.ocinside.de/media/uploads/asrock_z790_taichi_35.jpg', 3),
(298, 102, N'https://dlcdnwebimgs.asus.com/files/media/a5eca346-6ff6-404b-beea-e24b00fafcb1/v1/img/stability/pd.png', 1),
(299, 102, N'https://dlcdnwebimgs.asus.com/files/media/a5eca346-6ff6-404b-beea-e24b00fafcb1/v1/img/spec/connectivity_m.png', 2),
(300, 102, N'https://c1.neweggimages.com/productimage/nb1280/13-119-613-04.png', 3),
(301, 103, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3953/innergigabyteimages/specsmall02.jpg', 1),
(302, 103, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2226/innergigabyteimages/specsmall01.jpg', 2),
(303, 103, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3953/innergigabyteimages/box.png', 3),
(304, 104, N'https://asset.msi.com/resize/image/global/product/product_16563092383f77a0baf39ed1c0c60db412df1dfb71.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 1),
(305, 104, N'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/s/msi-pro_h610m-e_ddr4_1_2x.jpg', 2),
(306, 104, N'https://asset.msi.com/resize/image/global/product/product_1684309980c7ce93ff67875d32d290bbfb04abbd71.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 3),
(307, 105, N'https://files.pccasegear.com/UserFiles/ROG-CROSSHAIR-X670E-GENE-asus-rog-crosshair-x670e-gene-ddr5-motherboard-product3.jpg', 1),
(308, 105, N'https://dlcdnwebimgs.asus.com/files/media/9ACDB5EF-642B-4F33-B590-3C4EFC8E2CB2/v1/img/kv/pd.png', 2),
(309, 105, N'https://dlcdnwebimgs.asus.com/files/media/C9A82328-9130-467A-AEAC-A57B1FC2A6C4/v2/img/spec/performance.jpg', 3),
(310, 106, N'https://powerlandbd.com/wp-content/uploads/2024/07/biostar-b760mz-e-pro-ddr5-intel-11706612289-600x600.webp', 1),
(311, 106, N'https://microless.com/cdn/products/44a9d311ea2edda62bd8bbe0dad661ba-hi.jpg', 2),
(312, 106, N'https://static.chipdip.ru/lib/105/DOC059105944.jpg', 3),
(313, 107, N'https://techarc.pk/wp-content/uploads/2025/05/Colorful-CVN-B760M-Frozen-WiFi-D5-V20-DDR5-LGA1700-microATX-Motherboard-1-techarc.pk_.webp', 1),
(314, 107, N'https://pcngon.vn/wp-content/uploads/2025/09/Mainboard-Colorful-CVN-B760M-FROZEN-WIFI-D5-V20-1.jpg', 2),
(315, 107, N'https://product.hstatic.net/200000420363/product/mainboard-colorful-cvn-b760m-plus-frozen-wifi-d5-v20_ebaf35779b3d445ba23be5e1ce43cd5c_master.png', 3),
(316, 108, N'https://static.gigabyte.com/StaticFile/Image/Global/21b60ff73f01118423f20c8dd3dd3766/Product/25826/Png', 1),
(317, 108, N'https://static.gigabyte.com/StaticFile/Image/Global/42618312dd6c6ab0a2bf651f5c4f7305/Product/25835', 2),
(318, 108, N'https://static.gigabyte.com/StaticFile/Image/Global/30bc74fa5726d555066d932b45802db9/Product/25836', 3),
(319, 109, N'https://www.techpowerup.com/img/21HsrS5gwyRCYFvP.jpg', 1),
(320, 109, N'https://c1.neweggimages.com/productimage/nb1280/13-206-006-02.png', 2),
(321, 109, N'https://product.hstatic.net/1000333506/product/large_30c5e500415e1e83_9153bb80469646e990d35321931aee95.png', 3),
(322, 110, N'https://media.ldlc.com/r1600/ld/products/00/06/03/41/LD0006034175.jpg', 1),
(323, 110, N'https://media.ldlc.com/r1600/ld/products/00/06/03/41/LD0006034168.jpg', 2),
(324, 110, N'https://media.ldlc.com/r1600/ld/products/00/06/03/41/LD0006034166.jpg', 3),
(325, 111, N'https://www.thefpsreview.com/wp-content/uploads/2022/09/evga-z790-dark-kingpin-motherboard-face-transparent.png', 1),
(326, 111, N'https://cdn.mos.cms.futurecdn.net/SRokjYSV72y3qXgfjPpEPc.jpg', 2),
(327, 111, N'https://static0.gamerantimages.com/wordpress/wp-content/uploads/2023/05/evgaz90darkkingpin.jpg', 3),
(328, 112, N'https://storage-asset.msi.com/global/picture/image/feature/mb/X570/X570S-Tomahawk/x570s-tomahawk-hero-03-new.png', 1),
(329, 112, N'https://www.ask-corp.jp/products/images/msi/mag-x570s-tomahawk-max-wifi_02.jpg', 2),
(330, 112, N'https://down-my.img.susercontent.com/file/aa1e8a09affafeeba06655aa381a4c32', 3),
(331, 113, N'https://www.asus.com/media/global/gallery/ryj8wwu60iotu8qj_setting_fff_1_90_end_800.png', 1),
(332, 113, N'https://www.pcupgrade.co.uk/images/uploads/90MB14Y0-M0EAY0_3.jpg', 2),
(333, 113, N'https://www.bhphotovideo.com/images/images2500x2500/asus_tufgaminga520m_pluswif_tuf_gaming_a520m_plus_wifi_1737195.jpg', 3),
(334, 114, N'https://www.pcupgrade.co.uk/images/uploads/Z790%20UD%20AX_2.jpg', 1),
(335, 114, N'https://m.media-amazon.com/images/I/811C3BblrML._AC_.jpg', 2),
(336, 114, N'https://www.precio-calidad.com.ar/wp-content/uploads/2026/02/Z790-UD-AC-2.jpg', 3),
(337, 115, N'https://www.asrock.com/mb/photo/B550M%20Steel%20Legend(L2).png', 1),
(338, 115, N'https://www.asrock.com/mb/photo/B550M%20Steel%20Legend(L3).png', 2),
(339, 115, N'https://www.asrock.com/mb/photo/B550%20Steel%20Legend(L2).png', 3),
(340, 116, N'https://storage-asset.msi.com/global/picture/image/feature/mb/B650/B650-GAMING-PLUS-WIFI/b650-gaming-plus-wifi-hero-block02.png', 1),
(341, 116, N'https://asset.msi.com/resize/image/global/product/product_168145684740cc777942ab6a870e97f6aedbc1e1bd.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 2),
(342, 116, N'https://media.ldlc.com/r1600/ld/products/00/06/03/76/LD0006037609.jpg', 3),
(343, 117, N'https://dlcdnwebimgs.asus.com/files/media/45089cfb-95c6-4cde-b5c7-1814b583ccad/img/new_product_imgs/02_Cooling/Cooler_by_design/fan_4.png', 1),
(344, 117, N'https://m.media-amazon.com/images/I/81QVTuKByvL._AC_SL1500_.jpg', 2),
(345, 117, N'https://www.syntech.co.za/wp-content/uploads/2025/04/ASUS_PRIMEZ790-PWIFI_wr_01a.jpg', 3),
(346, 118, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2363/innergigabyteimages/specsmall.jpg', 1),
(347, 118, N'https://static.gigabyte.com/StaticFile/Image/Global/763a6eb5abb7c2e551be1c6fe9daa421/Product/34304', 2),
(348, 118, N'https://media.ldlc.com/r1600/ld/products/00/06/12/13/LD0006121340.jpg', 3),
(349, 119, N'https://files.pccasegear.com/images/X670E-STEEL-LEGEND-thumb.jpg', 1),
(350, 119, N'https://static.nb.com.ar/i/nb_MOTHER-ASROCK-(AM5)-X670E-STEEL-LEGEND_ver_b4b1dc91486591f75ac993d35f84e00c.png', 2),
(351, 119, N'https://www.scan.co.uk/images/infopages/X670E_Motherboard/ASRock/Steel_Legend/topimg.png', 3),
(352, 120, N'https://cdn.mos.cms.futurecdn.net/qAs5WBF8JXptoXfeK5A9ZV.jpg', 1),
(353, 120, N'https://www.aiuto-jp.co.jp/upload/images/BIOSTAR/%E3%83%9E%E3%82%B6%E3%83%BC%E3%83%9C%E3%83%BC%E3%83%89/Z790/Z790%20VALKYRIE/Z790_top.jpg', 2),
(354, 120, N'https://www.pcmasters.de/system/photos/18015/full/Z790_VALKYRIE_Preis-verfuegbarkeit.jpg', 3),
(355, 121, N'https://images.samsung.com/is/image/samsung/p6pim/nl/mz-v9p1t0bw/gallery/nl-990pro-nvme-m2-ssd-mz-v9p1t0bw-533690953?$650_519_PNG$', 1),
(356, 121, N'https://m.media-amazon.com/images/I/61ZL9Qpo1-L._AC_SL1320_.jpg', 2),
(357, 121, N'https://computerarenakh.com/image/catalog/2.Theanfy/SSD/za-990pro-nvme-m2-ssd-mz-v9p1t0bw-534448272.png', 3),
(358, 122, N'https://image.citycenter.jo/cache/catalog/802021/PRO2TB1-1200x1200.jpg', 1),
(359, 122, N'https://tech.co.za/wp-content/uploads/2021/03/SAMSUNG-980-PRO.jpg', 2),
(360, 122, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6447/6447126cv12d.jpg', 3),
(361, 123, N'https://i5.walmartimages.com/seo/WD-BLACK-SN850X-NVMe-Internal-SSD-1TB-WDBB9G0010BNC-WRSN_6d5f0ab9-719a-42e8-b247-8a4d3e4d509f.226a6322abeb936ec9e5dd42458a085d.png', 1),
(362, 123, N'https://nimavi.com/wp-content/uploads/2025/01/WD-Black-SN850X-1Tb-03.jpg', 2),
(363, 123, N'https://compumarket.pe/fotos/producto_11902_lg.jpg?225253413', 3),
(364, 124, N'https://www.tpstech.in/cdn/shop/products/Crucial_P3_Plus_M.2_Solid_State_Drive_From_tpstech.in_main1_44fb55ec-5613-4583-a446-a06c2aec7eb4.jpg?v=1669119805', 1),
(365, 124, N'https://down-my.img.susercontent.com/file/sg-11134201-22090-eet4aut362hv40', 2),
(366, 124, N'https://paksell.pk/cdn/shop/products/crucial-p3-plus-ssd-1tb-500gb-pcie-gen4-3d-nand-nvme-upto-5000mbs-620480_700x700.jpg?v=1691492292', 3),
(367, 125, N'https://songphuong.vn/Content/uploads/2023/04/SSD-Kingston-NV2-500GB-M2-songphuong.vn-01.jpg', 1),
(368, 125, N'https://topneteletronicos.com.br/image/cache/catalog/produtos/HDs/4636-m2-nvme-500gb-1600x1600.png', 2),
(369, 125, N'https://nomadaware.com.ec/wp-content/uploads/2022/10/NomadaWare_kingstong_nv2_500gb_ssd_m2_nvme.png', 3),
(370, 126, N'https://www.itmegabyte.com/wp-content/uploads/2021/05/Samsung-870-EVO-SSD-1TB-2.5-inch-SATA-III-Solid-State-Drive-06-800x800.jpg', 1),
(371, 126, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6447/6447127cv16d.jpg', 2),
(372, 126, N'https://nguyencongpc.vn/photos/32/Samsung-870-Evo-1TB-2.jpg', 3),
(373, 127, N'http://k.sinaimg.cn/n/sinakd20220827s/776/w600h176/20220827/ba6b-5c5647b67c64d39727da4f11a07b269f.jpg/w700d1q75cms.jpg', 1),
(374, 127, N'https://cdn.wccftech.com/wp-content/uploads/2024/03/DSC_0548-Custom-1456x971.jpg', 2),
(375, 127, N'https://pcper.com/wp-content/uploads/2023/03/top-scaled.jpg', 3),
(376, 128, N'https://cdn.mwave.com.au/images/400/lexar_nm790_2tb_pcie_40_nvme_m2_ssd_lnm790x002trnnng_ac67987_77928.jpg', 1),
(377, 128, N'https://www.pcthemes.com.sg/image/cache/catalog/Product%20Picture/SSD/LEXAR/NM790/2TB/2TB%201-1518x1364.png', 2),
(378, 128, N'https://www.techpowerup.com/review/lexar-nm790-2-tb/images/title.jpg', 3),
(379, 129, N'https://down-my.img.susercontent.com/file/my-11134201-7qul8-lk6oy1uvqb86ed', 1),
(380, 129, N'https://i5.walmartimages.com/seo/Crucial-T700-GEN5-NMVE-M-2-SSD-1TB-PCI-Express-5-0-x4-TLC-NAND-Internal-Solid-State-Drive-SSD-CT1000T700SSD3_770cc41c-5650-4fc3-97a1-e966574dcc04.0df4db5fc325eee5744b35c4ec410a5f.jpeg', 2),
(381, 129, N'https://serverorbit.com/images/detailed/191/Crucial-CT1000T700SSD3-T700-1TB-Gen-Internal-NVMe-SSD.jpg', 3),
(382, 130, N'https://www.jib.co.th/img_master/product/original/2023040316033258812_1.jpg', 1),
(383, 130, N'https://c1.neweggimages.com/ProductImage/20-009-049-01.jpg', 2),
(384, 130, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3690/innergigabyteimages/box.png', 3),
(385, 131, N'https://images.teamgroupinc.com/products/ssd/m2/mp33-pro/1tb_04.jpg', 1),
(386, 131, N'https://www.ryans.com/storage/products/main/team-mp33-pro-1tb-m2-2280-nvme-pcie-gen3-x4-ssd-11720695129.webp', 2),
(387, 131, N'https://images.harlander.com/artikel/1000x1000/teamgroup-mp33-1tb-ssd-pcie-nvme-m2-2280-1.jpg', 3),
(388, 132, N'https://www.pcstudio.in/wp-content/uploads/2021/12/XPG-1TB-GAMMIX-S70-Blade-PCIe-Gen4-M.2-2280-SSD-1.jpg', 1),
(389, 132, N'https://www.pcstudio.in/wp-content/uploads/2021/12/XPG-1TB-GAMMIX-S70-Blade-PCIe-Gen4-M.2-2280-SSD-2.jpg', 2),
(390, 132, N'https://down-id.img.susercontent.com/file/id-11134207-7rask-m1z3j8b6mebh26', 3),
(391, 133, N'https://cdn.mwave.com.au/images/400/wd_blue_sn580_1tb_pcie_40_nvme_m2_2280_ssd_wds100t3b0e_ac69352_33452.jpg', 1),
(392, 133, N'https://www.titan-ice.co.za/images/detailed/50/wd-blue-sn580-nvme-ssd-1tb-flat.png.wdthumb.1280.1280.jpg', 2),
(393, 133, N'https://img.overclockers.co.uk/images/STO-WDC-00540/46ccdc3315a80bcce7424ea25b70faf4.jpg', 3),
(394, 134, N'https://static.tweaktown.com/content/9/8/9886_03_seagate-firecuda-530-2tb-ssd-review-the-throughput-leader.jpg', 1),
(395, 134, N'https://enfield-bd.com/wp-content/uploads/2024/01/Enfield-bd.com-Computer-Accessories-amp-Peripherals-Original-Seagate-SSD-2TB-FireCuda-530-Gen4-M.2-2280-PCIe-NVMe-Gaming.jpg', 2),
(396, 134, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6474/6474699cv13d.jpg', 3),
(397, 135, N'https://www.scan.co.uk/images/products/xlarge/3602714-xl-a.jpg', 1),
(398, 135, N'https://static.tweaktown.com/content/1/0/10275_03_sabrent-rocket-4-plus-4tb-ssd-review-high-capacity-futureproofing.jpg', 2),
(399, 135, N'https://m.media-amazon.com/images/I/61Ucf1k7VuL._AC_.jpg', 3),
(400, 136, N'https://images.samsung.com/is/image/samsung/uk-970-evoplus-nvme-m2-ssd-mz-v7s2t0bw-frontblack-319090477?$650_519_PNG$', 1),
(401, 136, N'https://cf.shopee.co.th/file/6b23114a4bc077ac98bf532af207a380', 2),
(402, 136, N'https://static.tweaktown.com/content/9/0/9044_500_samsung-970-evo-plus-2tb-high-performance-nvme-ssd-review_full.png', 3),
(403, 137, N'https://www.quadra.id/wp-content/uploads/2024/05/PNY-CS2241-1TB-SSD-PCIE-4.0-GEN4-M.2-NVME-M280CS2241-1TB-CL.png', 1),
(404, 137, N'https://www.impulsegamer.com/articles/wp-content/uploads/2023/01/pny01-1024x768.jpg', 2),
(405, 137, N'https://i5.walmartimages.com/asr/7da3f73a-bad6-4fec-a18c-0ea61a4899b0.e7b3ea5e5300964bc280cbf588e04e0b.jpeg', 3),
(406, 138, N'https://dh9cuahs6ezpz.cloudfront.net/images/products/bb/siliconpower-17538-3_198171.jpg', 1),
(407, 138, N'https://tpucdn.com/review/silicon-power-ud90-1-tb/images/title.jpg', 2),
(408, 138, N'https://pchall.ge/wp-content/uploads/2025/12/Screenshot-2025-12-22-132344.jpg', 3),
(409, 139, N'https://os-jo.com/image/cache/catalog/products/Storage/Internal/CSSD-F2000GBMP600PRO/CSSD-F2000GBMP600PRO-1200x1200.jpg', 1),
(410, 139, N'https://nvs.tn-cdn.net/2025/01/o-cung-ssd-corsair-mp600-pro-lpx-2tb-pcie-gen-4x4-nvme-m-2-ps5-compatible-4.jpg', 2),
(411, 139, N'https://lagihitech.vn/wp-content/uploads/2023/06/SSD-Corsair-MP600-Pro-2TB-M2-PCIe-Gen-4.0-CSSD-F2000GBMP600PRO-hinh-10.jpg', 3),
(412, 140, N'https://songphuong.vn/Content/uploads/2023/04/SSD-Kingston-KC3000-1TB-M2-songphuong.vn-04.jpg', 1),
(413, 140, N'https://diit.cz/sites/default/files/kc3000kingston1t-1.jpg', 2),
(414, 140, N'https://unitech-dz.com/wp-content/uploads/2023/12/Capture-decran-47.png', 3),
(415, 141, N'https://down-mx.img.susercontent.com/file/sg-11134201-23020-nx5fq0gyrlnvc4', 1),
(416, 141, N'https://www.itmegabyte.com/wp-content/uploads/2020/09/Crucial-MX500-1TB-SSD-02.jpg', 2),
(417, 141, N'https://taipeicomputer.jo/image/cache/catalog/Products/Storage/SSD/MX500_M.2-800x800.jpg', 3),
(418, 142, N'https://cdn.atacadoconnect.com/produtos/771245/ssd-m-2-western-digital-sn350-green-480gb-nvme-pcie-gen3-wds480g2g0c-771245-83016.webp', 1),
(419, 142, N'https://gorilagames.com/img/Public/1019-producto-480gb-green-502.jpg', 2),
(420, 142, N'https://rimage.ripley.com.pe/home.ripley/Attachment/MKP/1798/PMP00002860410/full_image-1.jpg', 3),
(421, 143, N'https://down-id.img.susercontent.com/file/id-11134207-7quky-li9vwkg1chaxec', 1),
(422, 143, N'https://www.maxframe.dz/gla-adminer/uploads/article/full/764075767_31-07-2023_842297.jpg', 2),
(423, 143, N'https://static.tweaktown.com/content/1/0/10072_03_msi-spatium-m480-play-2tb-ssd-review-ps5-perfection.jpg', 3),
(424, 144, N'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/t/r/transcend_ssd_250s_2_.jpg', 1),
(425, 144, N'https://down-my.img.susercontent.com/file/sg-11134201-23020-csysk3mx33nv67', 2),
(426, 144, N'http://www.pcdiy.com.tw/assets/images/768/fd7ac148c3afbf7ca3111b8882e1a109.jpeg', 3),
(427, 145, N'https://gamex24.com/cdn/shop/files/51pzJFrhVWL.jpg?v=1765733753&width=1946', 1),
(428, 145, N'https://gamex24.com/cdn/shop/files/718RcXesBSL.jpg?v=1765733754&width=1946', 2),
(429, 145, N'https://compuden.co.za/cdn/shop/files/VP4300L2TBM28H_Patriot-Viper-VP4300-Lite-2TB-Gen-4-M.2-PCIe-NVMe-SSD_wr_03.jpg?v=1754471137&width=1096', 3),
(430, 146, N'https://basitcomputers.com/wp-content/uploads/2023/01/LEXAR-NM620-512GB-2280-NVMe-M.2-SSD.jpg', 1),
(431, 146, N'https://tetop.co.ke/wp-content/uploads/2022/10/Lexar-NM620-M.2-2280-512GB-PCIe-Gen3x4-NVMe-3D-SSD.jpg', 2),
(432, 146, N'https://www.gaming.gen.tr/wp-content/uploads/2024/08/lexar-nm620-512gb-nvme-pcie-gen3-x4-okuma-3500mb-yazma-2400-mb-m-2-ssd-lnm620x512g-rnnng-1.jpg', 3),
(433, 147, N'https://m.media-amazon.com/images/I/71e5H77FI4L._AC_SL1500_.jpg', 1),
(434, 147, N'https://m.media-amazon.com/images/I/61lhQxV95NL._AC_SL1500_.jpg', 2),
(435, 147, N'https://m.media-amazon.com/images/I/71ElAaqkADL._AC_SL1500_.jpg', 3),
(436, 148, N'https://www.ephotozine.com/articles/samsung-870-qvo-4tb-ssd-review-34889/images/highres-Samsung-SSD-870-QVO-3_1596191517.jpg', 1),
(437, 148, N'https://tienda.starware.com.ar/wp-content/uploads/2021/10/disco-solido-ssd-samsung-870-qvo-4tb-sata-iii-25p-6g-560x-2469-4929-scaled.jpg', 2),
(438, 148, N'https://www.discoazul.com/uploads/media/images/disco-duro-ssd-samsung-870-qvo-4tb-sata-3-2-5-17.jpg', 3),
(439, 149, N'https://product.hstatic.net/200000397235/product/ssd_240g_adata_su650_sata_iii_tlc_2_bb6340c0ab3e4002af8ba097f8b9bec8_1024x1024.jpg', 1),
(440, 149, N'https://webapi3.adata.com/storage/product/su650_02_1200x695_0628.jpg', 2),
(441, 149, N'https://tecnoplaza.com.co/cdn/shop/files/disco-solido-ssd-sata-240gb-650-adata-1-87939291-3479-4b3c-85eb-f74faf7ec62d.jpg?v=1743708631', 3),
(442, 150, N'https://www.ocinside.de/media/uploads/crucial_t705_2tb_m2_ssd_1.jpg', 1),
(443, 150, N'https://m.media-amazon.com/images/I/61kpTnvVd-L._AC_SL1500_.jpg', 2),
(444, 150, N'https://down-my.img.susercontent.com/file/sg-11134201-7rd5i-lvupwu28nmmg93', 3),
(445, 151, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6530/6530357_rd.jpg', 1),
(446, 151, N'https://www.lg.com/content/dam/channel/wcms/de/images/monitore/27gr95qe-b_aeu_eedg_de_c/gallery/DZ-02.jpg', 2),
(447, 151, N'https://product.hstatic.net/200000722513/product/27gr95qe-b_1_e3d8986ff7594ce68e0986210b024396_master.jpg', 3),
(448, 152, N'https://images.versus.io/objects/dell-ultrasharp-u2723qe-27.front.master2x.1650886253638.webp', 1),
(449, 152, N'https://images.versus.io/objects/lg-27up850n-w-27.front.master2x.1722418537621.webp', 2),
(450, 152, N'https://images.versus.io/objects/dell-ultrasharp-u2724de-27.front.thumb.1734625337571.webp', 3),
(451, 153, N'https://dlcdnwebimgs.asus.com/gain/1f0d4b71-950d-49eb-844b-be154fc55926/w692', 1),
(452, 153, N'https://gadgethousenepal.com/wp-content/uploads/2022/10/81tX7xncLtL.jpg', 2),
(453, 153, N'https://down-my.img.susercontent.com/file/af1693bc5842da174206fc129287532b', 3),
(454, 154, N'https://img.global.news.samsung.com/uk/wp-content/uploads/2022/06/Odyssey-Neo-G8_1-e1654601517325.jpg', 1),
(455, 154, N'https://www.notebookcheck.net/fileadmin/Notebooks/News/_nc3/Samsung_Odyssey_Neo_G8_7.jpg', 2),
(456, 154, N'https://images.samsung.com/is/image/samsung/p6pim/de/feature/others/de-feature-odyssey-neo-g8-g85nb-533951087?$FB_TYPE_K_JPG$', 3),
(457, 155, N'https://i5.walmartimages.com/seo/GIGABYTE-M27Q-X-27-IPS-Gaming-Monitor-QHD-2560x1440-240Hz-1ms-GTG-AMD-FreeSync-Premium-Type-C-KVM-HDMI-DP-Type-C-Height-Adjustable-Black_f3eb5f61-69ba-4e34-b036-cec12104f4ce.7073182e88b5c23aed1a2c2a254b8c81.jpeg', 1),
(458, 155, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/1554/innergigabyteimages/bg1.png', 2),
(459, 155, N'https://www.cclonline.com/images/avante/GIGABYTE-M27Q02.jpg?width=1176&height=884&scale=canvas&trim.threshold=80', 3),
(460, 156, N'https://taipeicomputer.jo/image/cache/catalog/Products/Monitors/24G2-1200x1200.jpg', 1),
(461, 156, N'https://down-my.img.susercontent.com/file/b73ddae01ae3328d3d7028278f53e7f8', 2),
(462, 156, N'https://pchi.com.au/wp-content/uploads/2021/02/24G2_Front.jpg', 3),
(463, 157, N'https://manuals.viewsonic.com/images/a/a4/VX2728-2K.png', 1),
(464, 157, N'https://files.pccasegear.com/UserFiles/VX2728-viewsonic-vx2728-fhd-180hz-freesync-ips-27in-monitor-product2.jpg', 2),
(465, 157, N'https://saboocomputers.com/wp-content/uploads/2024/02/VX2728-3.jpg', 3),
(466, 158, N'https://asset.msi.com/resize/image/global/product/product_16421394998e3c22d5813d74e8ff6a05b8ef5e5c22.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 1),
(467, 158, N'https://cdn.wccftech.com/wp-content/uploads/2020/10/AbNcq7UOoqpnLVU3.jpg', 2),
(468, 158, N'https://ph-test-11.slatic.net/p/122ed180d6792cd7a5dbfaeb9997a67a.jpg', 3),
(469, 159, N'http://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/peripherals/monitors/alienware/aw3423dw/monitor-alienware-aw3423dw-pdp-hero.psd?qlt=95&fit=constrain,1&hei=3470&wid=5000&fmt=jpg', 1),
(470, 159, N'https://m.media-amazon.com/images/I/61v8hP+TT5L.jpg', 2),
(471, 159, N'https://res.cloudinary.com/dev-and-gear/image/upload/w_1080,q_auto,f_auto/v1641829476/Alienware_34_Curved_QD-OLED_Monitor-AW3423DW_low-rf-front_dspkft', 3),
(472, 160, N'https://www.devicedeal.com.au/assets/full/SW271C.jpg?20230307094747', 1),
(473, 160, N'https://www.ephotozine.com/articles/benq-sw271c-4k-monitor-announced-for-photographers-35337/images/1000-sw271c-front-1jpg_1616747779.jpg', 2),
(474, 160, N'https://resources.claroshop.com/medios-plazavip/mkt/630fb6dc699e4_sw271c_1jpg.jpg', 3),
(475, 161, N'https://images.samsung.com/is/image/samsung/p6pim/us/ls32fm702unxza/gallery/us-smart-m7-32m70f-black-ls32fm702unxza-547843577?$product-details-jpg$', 1),
(476, 161, N'https://cdn.shopify.com/s/files/1/0024/9803/5810/products/585978-Product-0-I-637850235777859246.jpg?v=1649390848', 2),
(477, 161, N'https://cdn.shopify.com/s/files/1/0003/7489/8743/products/475763-Product-0-I-637469188336243792_800x800_1e5000c4-7ea5-417f-b421-049ebc3f7781.jpg?v=1628488171', 3),
(478, 162, N'https://www.lg.com/us/images/monitors/md08000281/gallery/medium06.jpg', 1),
(479, 162, N'https://hca.pe/storage/media/PfdYM0XdEjQiL303iq6cfYrfZQ9DrBI6exA8rooB.png', 2),
(480, 162, N'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/104/MTA-129724961/no-brand_no-brand_full01.jpg', 3),
(481, 163, N'https://www.incehesap.com/resim/urun/202306/6479d16186b3a4.04672006_onpkhfgiljqme.webp', 1),
(482, 163, N'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/106/MTA-85177806/asus_monitor_asus_rog_swift_pg42uq_gaming_monitor_-41-5_inch_oled_4k_-_138hz-_full01_xzh0lpd.jpg', 2),
(483, 163, N'https://cdn.mos.cms.futurecdn.net/otnrdaPghSHPy4bjjwNNT.jpg', 3),
(484, 164, N'https://cdn.shopify.com/s/files/1/0355/8296/7943/products/1000_40_1600x.jpg?v=1665361714', 1),
(485, 164, N'https://monitornerds.com/wp-content/uploads/2023/07/Gigabyte-G24F-2-Review.jpg', 2),
(486, 164, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2145/innergigabyteimages/bg2.png', 3),
(487, 165, N'https://www.cgshop.at/wp-content/uploads/2021/03/c06967002_1750x1285.jpg', 1),
(488, 165, N'https://sys.md/image/cache/catalog/sysmd/Produse/Monitoare/HP/27/Z27-G3/Hp-z-27-monitor-sys.md-940x600.jpg', 2),
(489, 165, N'https://down-my.img.susercontent.com/file/my-11134207-7rasg-m6m2ods0pp4p38', 3),
(490, 166, N'https://m.media-amazon.com/images/I/81DJ-HL3HzL.jpg', 1),
(491, 166, N'https://cdn.shopify.com/s/files/1/0355/8296/7943/files/Acer-Nitro-VG271U-M3BMIIPX-27-desc_4aad38cd-87f7-4f1e-96bf-3cf4538ca635.jpg?v=1690801260', 2),
(492, 166, N'https://tehno-mag.hr/upload/catalog/product/26339/4711121527333-acer-monitor-27-nitro-vg271u-m3-1-2-_681de0f09e380.jpg', 3),
(493, 167, N'https://cdn.mos.cms.futurecdn.net/Ns4ENNsYKr7QAJ5sQpwFpV.jpg', 1),
(494, 167, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6421/6421624_sd.jpg', 2),
(495, 167, N'https://i.rtings.com/images/reviews/monitor/dell/s2721dgf/s2721dgf-back-large.jpg', 3),
(496, 168, N'https://media.karousell.com/media/photos/products/2023/9/30/lg_28_28mq750__28mq780_positio_1696067489_c9d1b4f8_progressive', 1),
(497, 168, N'https://m.media-amazon.com/images/I/71BEavF6gsL._AC_.jpg', 2),
(498, 168, N'https://i.ytimg.com/vi/WYG5iPLNDyw/maxresdefault.jpg', 3),
(499, 169, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/2c90f165-3c02-4c8b-ba2a-0c589075d9d9.jpg', 1),
(500, 169, N'https://m.media-amazon.com/images/I/81GjQCXtXhL._AC_SL1500_.jpg', 2);
INSERT INTO product_images (id, product_id, image_url, display_order) VALUES
(501, 169, N'https://images-na.ssl-images-amazon.com/images/I/81Pm4yGtiYL.jpg', 3),
(502, 170, N'https://cdn.mos.cms.futurecdn.net/8rPUFXnt6qy8sBCfFBAKk6.png', 1),
(503, 170, N'https://img.lazcdn.com/g/p/d0ae9e48cf63d5fc5936ea351c4f0198.png_720x720q80.png', 2),
(504, 170, N'https://lookaside.fbsbx.com/lookaside/crawler/media/?media_id=1506452209776678', 3),
(505, 171, N'https://www.bhphotovideo.com/images/images2500x2500/asus_pa278qv_27_wqhd_ips_1562006.jpg', 1),
(506, 171, N'https://m.media-amazon.com/images/I/81CFn-NfutL.jpg', 2),
(507, 171, N'https://www.asusbymacman.es/3784-thickbox_default/asus-proart-pa278qv-27-ips-wqhd-monitor.jpg', 3),
(508, 172, N'https://qna.smzdm.com/202203/30/62447a7f0e7df7236.jpg_e1080.jpg', 1),
(509, 172, N'https://qna.smzdm.com/202103/08/604622fb86014528.jpg_e1080.jpg', 2),
(510, 172, N'https://img.lazcdn.com/g/p/57023861ddb5a89be3e6f8c1a356e672.jpg_720x720q80.jpg', 3),
(511, 173, N'https://microless.com/cdn/products/d7bc04cf94595d6dc9ec8146fe27b458-hi.jpg', 1),
(512, 173, N'https://c1.neweggimages.com/BizIntell/item/monitors/gaming%20monitors/24-475-355/2.png', 2),
(513, 173, N'https://ir.ozone.ru/s3/multimedia-h/c1000/6820307441.jpg', 3),
(514, 174, N'https://nerdstore.com.ar/wp-content/uploads/2022/09/51702.jpg', 1),
(515, 174, N'https://tech.co.za/wp-content/uploads/2023/03/E2222Hd.png', 2),
(516, 174, N'https://ennap.com/cdn/shop/files/monitors_e2222h_gallery_5.png?v=1698167171', 3),
(517, 175, N'https://c1.neweggimages.com/ProductImageCompressAll1280/24-026-192-V07.jpg', 1),
(518, 175, N'https://images-na.ssl-images-amazon.com/images/I/71y8Payv2XL.jpg', 2),
(519, 175, N'https://product.hstatic.net/200000722513/product/lg_29wp500-b_gearvn_775407ff513945e087357f733a93f268_32f1488fa9c24920804c6ecfac4b87e9_master.jpg', 3),
(520, 176, N'https://down-id.img.susercontent.com/file/362aeb868a0525aec9613feef4edd4bb', 1),
(521, 176, N'https://www.mediaexpert.pl/media/cache/resolve/filemanager_original/images/descriptions/images/26/2654977/storage_app_opisy2_philips_373973/2_monitor_philips_242e1gaez00_tyl1.jpg', 2),
(522, 176, N'https://bimg.akulaku.net/goods/spu/84507aca09414720bd15e1268a91f7b71099.jpg?w=726&q=80&fit=1', 3),
(523, 177, N'https://absolutegadget.com/wp-content/uploads/2023/09/AOC_CU34G2XBK_01.png', 1),
(524, 177, N'https://m.media-amazon.com/images/I/81GnQlNcf3L.jpg', 2),
(525, 177, N'https://i.rtings.com/assets/products/tgi1g3Rw/aoc-cu34g2x/design-medium.jpg', 3),
(526, 178, N'https://cdn.videocardz.com/1/2022/08/XENEON-MONITOR.jpg', 1),
(527, 178, N'https://www.hardware-journal.de/images/Bilder/2022/news/Corsair/Xeneon-OLED/Corsair-Xeneon-Flex-45WQHD240-OLED-03.jpg', 2),
(528, 178, N'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Monitors/CM-9030001-NA/Gallery/XENEON_FLEX_01.webp', 3),
(529, 179, N'https://www.benq.com/content/dam/zowie/en/product/monitor/xl/image_no_hdmi/xl2546k-2.png', 1),
(530, 179, N'https://product.hstatic.net/1000333506/product/z3866732217223_9621b599736552d44915697326a08d9c_54f433b46a93447d8c54b9e1eb06c704.jpg', 2),
(531, 179, N'https://cf.shopee.co.th/file/0d0995409f8cd870202fc4724303e51a', 3),
(532, 180, N'https://media.karousell.com/media/photos/products/2023/3/27/xiaomi_mi_34_144hz_wqhd_3440x1_1679902915_b1e9d7b4.jpg', 1),
(533, 180, N'https://down-id.img.susercontent.com/file/id-11134207-7r98v-lwi2dkudqu6z47', 2),
(534, 180, N'https://down-id.img.susercontent.com/file/id-11134207-7rbk0-m6oxou6z61op36', 3),
(535, 181, N'https://assets2.rockpapershotgun.com/Intel-Arc-A770-Limited-Edition-GPU.png/BROK/resize/1920x1920%3E/format/jpg/quality/80/Intel-Arc-A770-Limited-Edition-GPU.png', 1),
(536, 181, N'https://media.ark-pc.co.jp/image/item/top/20106889.jpg', 2),
(537, 181, N'https://www.thefpsreview.com/wp-content/uploads/2023/06/intel-arc-a770-limited-edition-feature.jpg', 3),
(538, 182, N'https://cdn.mos.cms.futurecdn.net/gyxybrmhdro4aDVz6rE2TK.jpg', 1),
(539, 182, N'https://cdn.wccftech.com/wp-content/uploads/2022/09/Intel-Arc-A770-Arc-A750-12th-October-Launch-Confirmd-329-289-US-Price-_3.png', 2),
(540, 182, N'https://assetsio.reedpopcdn.com/Edit.00_01_51_53.Still010.png?width=1200&height=630&fit=crop&enable=upscale&auto=webp', 3),
(541, 183, N'https://www.techpowerup.com/img/rVeqolUlUQ7NiTNS.jpg', 1),
(542, 183, N'https://www.asrock.com/Graphics-Card/features/IntelArc-Levelupyourgame-Intel%20Arc%20A580%20Challenger%208GB%20OC_mobile.jpg', 2),
(543, 183, N'https://www.startech.com.bd/image/cache/catalog/graphics-card/asrock/intel-arc-a580-challenger-8gb-oc/intel-arc-a580-challenger-8gb-oc-01-500x500.webp', 3),
(544, 184, N'https://static.tweaktown.com/news/8/9/89309_233_amd-radeon-rx-7900-xt-announced-navi-31-gpu-20gb-gddr6-costs-899_full.png', 1),
(545, 184, N'https://m.media-amazon.com/images/I/81n9vllhNeL._AC_.jpg', 2),
(546, 184, N'https://www.asrock.com/Graphics-Card/photo/Radeon%20RX%207900%20XT%2020GB(M1).png', 3),
(547, 185, N'https://m.media-amazon.com/images/I/81diCFiMtDL._AC_.jpg', 1),
(548, 185, N'https://www.asrock.com/Graphics-Card/photo/Radeon%20RX%207800%20XT%20Challenger%2016GB%20OC(L1).png', 2),
(549, 185, N'https://m.media-amazon.com/images/I/71GKfo5qtaL._AC_.jpg', 3),
(550, 186, N'https://assets.rockpapershotgun.com/images/2020/11/AMD-Ryzen-5-5600X-with-cooler.jpg', 1),
(551, 186, N'https://tpucdn.com/cpu-specs/images/chips/2365-front.jpg', 2),
(552, 186, N'https://tech-u.pk/cdn/shop/files/R5_5600x_2.png?v=1727342876', 3),
(553, 187, N'https://dlcdnwebimgs.asus.com/files/media/6E2741FD-9665-46E9-9D2B-1DAA67590550/v1/img/kv/pd.png', 1),
(554, 187, N'https://dlcdnwebimgs.asus.com/files/media/6E2741FD-9665-46E9-9D2B-1DAA67590550/v1/img/spec/immersion.jpg', 2),
(555, 187, N'https://dlcdnwebimgs.asus.com/files/media/6E2741FD-9665-46E9-9D2B-1DAA67590550/v1/img/spec/cooling-m.jpg', 3),
(556, 188, N'https://dlcdnwebimgs.asus.com/files/media/B51D103D-2941-412E-8479-AF994957093B/v1/img/kv/ROG-Strix-X670E-E-Gaming.png', 1),
(557, 188, N'https://dlcdnwebimgs.asus.com/files/media/B51D103D-2941-412E-8479-AF994957093B/v1/img/spec/cooling.png', 2),
(558, 188, N'https://dlcdnwebimgs.asus.com/files/media/B51D103D-2941-412E-8479-AF994957093B/v1/img/spec/connectivity.png', 3),
(559, 189, N'https://dlcdnwebimgs.asus.com/gain/2486AE38-B7C7-443A-9615-FD08D5430992/w1000/h732', 1),
(560, 189, N'https://media.ldlc.com/r1600/ld/products/00/06/12/43/LD0006124357.jpg', 2),
(561, 189, N'https://dlcdnwebimgs.asus.com/files/media/015AF38A-127E-4FA8-9700-6D92BB2760C1/v2/img/kv/pd.png', 3),
(562, 190, N'https://images-na.ssl-images-amazon.com/images/I/81gpksblvhL.jpg', 1),
(563, 190, N'https://dlcdnwebimgs.asus.com/files/media/E185B23B-4B03-43EE-BFF1-2881D2338BB1/v1/img/kv/kv_cover.png', 2),
(564, 190, N'https://rog.asus.com/media/1692603178869.jpg', 3),
(565, 191, N'https://www.overclockers.ua/news/cooler/135902-asus-rog-ryujin-360-extreme-2.jpg', 1),
(566, 191, N'https://cdn2.37left.lk/images/asus-rog-ryujin-iii-360-argb-extreme-SX-D2YUwwzct.webp', 2),
(567, 191, N'https://dlcdnwebimgs.asus.com/gain/E1784088-9171-46A6-BD0E-BCDF0C8CCC87', 3),
(568, 192, N'https://files.pccasegear.com/images/ROG-THOR-1200P2-GAMING-thumb.jpg', 1),
(569, 192, N'https://m.media-amazon.com/images/I/81IqY-18ftL.jpg', 2),
(570, 192, N'https://i0.wp.com/www.f1techcomputers.com.au/wp-content/uploads/2019/07/ASUS-ROG-Thor1200W-Platinum-PS-p01.jpeg?w=1000&ssl=1', 3),
(571, 193, N'https://cdn.mos.cms.futurecdn.net/3F8AMJJGKcyAst6cGyKcrP.jpg', 1),
(572, 193, N'https://m.media-amazon.com/images/I/81TStEP0htL._AC_.jpg', 2),
(573, 193, N'https://files.pccasegear.com/images/MEG-Z790-GODLIKE-M-add1.jpg', 3),
(574, 194, N'https://storage-asset.msi.com/global/picture/image/feature/mb/B650/MAG-B650-TOMAHAWK-WIFI/mag-b650-tomahawk-wifi-block01.png', 1),
(575, 194, N'https://m.media-amazon.com/images/I/81mtudlL3ZL._AC_.jpg', 2),
(576, 194, N'https://b2c-contenthub.com/wp-content/uploads/2023/02/Screenshot-2022-11-28-at-1.18.39-PM.png?w=1200', 3),
(577, 195, N'https://m.media-amazon.com/images/I/71LoU1sRHaL._AC_.jpg', 1),
(578, 195, N'https://storage-asset.msi.com/global/picture/image/feature/vga/NVIDIA/4080-Gaming/RTX-4080-Gaming-X-Slim-16G/images/msi-4080-gaming-x-slim-vga.png', 2),
(579, 195, N'https://media.pangoly.com/img/e/6/a/0/e6a07409-baed-470a-9eec-c031b4971dde.jpg', 3),
(580, 196, N'https://m.media-amazon.com/images/I/81h0w75BgqL.jpg', 1),
(581, 196, N'https://images.versus.io/objects/asus-rog-strix-oled-xg27acdms-27.front.master2x.1769596563723.webp', 2),
(582, 196, N'https://tftcentral.co.uk/wp-content/uploads/2025/05/mpg_271qr_x50.jpg', 3),
(583, 197, N'https://storage-asset.msi.com/global/picture/image/feature/PC-Case/MEG-MAESTRO-700L-PZ/meg-maestro-700l-pz-airflow.png', 1),
(584, 197, N'https://storage-asset.msi.com/global/picture/image/feature/PC-Case/MEG-MAESTRO-700L-PZ/meg-maestro-700l-pz-pcc-pd.png', 2),
(585, 197, N'https://storage-asset.msi.com/global/picture/image/feature/PC-Case/MEG-MAESTRO-700L-PZ/msi-maestro-700l-pz-kv-bg-m.jpg', 3),
(586, 198, N'https://media.ldlc.com/r1600/ld/products/00/06/15/37/LD0006153712.jpg', 1),
(587, 198, N'https://storage-asset.msi.com/global/picture/image/feature/CoreLiquid/i360/msi-cooling-i360-rgb.jpg', 2),
(588, 198, N'https://admin-info.dz/wp-content/uploads/2026/01/imgi_136_msi_mag_coreliquid_i360_white_mag_coreliquid_i360_liquid_1864285.jpg', 3),
(589, 199, N'https://storage-asset.msi.com/global/picture/product/product_167573935424940aba56cd1dba801846447d621bb2.webp', 1),
(590, 199, N'https://img.unikoshardware.com/wp-content/uploads/2023/03/SPATIUM-M570-PCIe-5.0-NVMe-M.2-HS.jpg', 2),
(591, 199, N'https://www.ucc.com.bd/image/cache/catalog/ssd/msi/SPATIUM%20M570%202TB/M570%20-%201TB-550x550h.png.webp', 3),
(592, 200, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2500/innergigabyte/images/product/diagram.png', 1),
(593, 200, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2230/innergigabyteimages/specsmall01.jpg', 2),
(594, 200, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2230/innergigabyteimages/specsmall02.jpg', 3),
(595, 201, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2170/innergigabyteimages/specsmall01.jpg', 1),
(596, 201, N'https://tpucdn.com/review/gigabyte-x670e-aorus-master/images/title.jpg', 2),
(597, 201, N'https://cdn.mos.cms.futurecdn.net/dqGgvvXStd7cuDwPJocey.jpg', 3),
(598, 202, N'https://i5.walmartimages.com/seo/GIGABYTE-M27Q-X-27-IPS-Gaming-Monitor-QHD-2560x1440-240Hz-1ms-GTG-AMD-FreeSync-Premium-Type-C-KVM-HDMI-DP-Type-C-Height-Adjustable-Black_f3eb5f61-69ba-4e34-b036-cec12104f4ce.7073182e88b5c23aed1a2c2a254b8c81.jpeg', 1),
(599, 202, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6438/6438287_sd.jpg', 2),
(600, 202, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/1554/innergigabyteimages/dc1.png', 3),
(601, 203, N'https://cdn.mos.cms.futurecdn.net/2KNc6FixBFckzHxLCMfVtW-1200-80.jpg', 1),
(602, 203, N'https://www.techpowerup.com/img/krajQ4mTAt08PdZN.jpg', 2),
(603, 203, N'https://cdn.3dnews.ru/assets/external/illustrations/2024/11/21/1114395/photo03.jpg', 3),
(604, 204, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2452/innergigabyteimages/box.png', 1),
(605, 204, N'https://s13emagst.akamaized.net/products/67015/67014835/images/res_5f90f767a6bb23d28d2986e2a300f513.jpg', 2),
(606, 204, N'https://gzhls.at/pix/0c/eb/0ceb8457e76f2dda-n.webp', 3),
(607, 205, N'https://static.cclonline.com/images/shopblocks/UD1000GM%20PG5-08.png?width=2000', 1),
(608, 205, N'https://cdn.cclonline.com/cdn-cgi/image/width=2000/images/shopblocks/UD1000GM%20PG5-04.png', 2),
(609, 205, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2320/innergigabyteimages/kf-img.png', 3),
(610, 206, N'https://www.titan-ice.co.za/images/detailed/64/1000_aaa1-8y.webp', 1),
(611, 206, N'https://us.aorus.com/upload/Product/F_20220921110077kWiqY6.JPG', 2),
(612, 206, N'https://product.hstatic.net/200000722513/product/aorus_c500_glass-10_7ea0a2a57b234bd9bdf5f1e5624c3484_35b35baf2e074c718dc2b77f5b1ec41a_master.png', 3),
(613, 207, N'https://m.media-amazon.com/images/I/611o1NX2HvL._AC_.jpg', 1),
(614, 207, N'https://media.ldlc.com/r1600/ld/products/00/06/06/83/LD0006068334_0006068468_0006068473.jpg', 2),
(615, 207, N'https://www.gaming.gen.tr/wp-content/uploads/2023/10/corsair-dominator-titanium-rgb-32gb-2x16gb-6000mhz-cl30-ddr5-ram-cmp32gx5m2b6000z30-1-600x600.jpg', 3),
(616, 208, N'https://5.imimg.com/data5/SELLER/Default/2026/2/587113641/UN/GK/JZ/122095513/71-9dgyyfal-1000x1000.jpg', 1),
(617, 208, N'https://cdn.mwave.com.au/images/400/corsair_vengeance_rgb_64gb_2x32gb_ddr5_5600mhz_amd_ready_memory_cool_grey_ac56697_1.jpg', 2),
(618, 208, N'https://philong.com.vn/media/product/31238-ram-ddr5-64gb-5600mhz-corsair-vengeance-rgb-white-cmh64gx5m2b5600c40-philong--3-.jpg', 3),
(619, 209, N'https://microless.com/cdn/products/3d58e0748e4996993aac8d973d98505c-hi.jpg', 1),
(620, 209, N'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Liquid-Cooling/icue-link-lcd-aio/CW-9061008/iCUE_LINK_H150i_LCD_BLK_01.webp', 2),
(621, 209, N'https://assets.corsair.com/image/upload/c_pad,q_auto,h_1024,w_1024,f_auto/products/Liquid-Cooling/icue-link-lcd-aio/CW-9061010/iCUE_LINK_H150i_LCD_WHT_01.webp', 3),
(622, 210, N'https://assets.corsair.com/image/upload/c_scale%2Cq_auto/products/Cases/base-5000d-airflow/Gallery/5000D_AF_WHITE_001.webp', 1),
(623, 210, N'https://m.media-amazon.com/images/I/81ySHlz01sL._AC_SL1500_.jpg', 2),
(624, 210, N'https://www.autonetpc.com/wp-content/uploads/2021/01/base_5000d_airflow_Gallery_5000D_AF_WHITE_30.png_1200Wx1200H-1024x1024.jpg', 3),
(625, 211, N'https://assets.corsair.com/image/upload/c_pad,q_auto,h_1024,w_1024,f_auto/products/Cases/6500/CC-9011270-WW/Gallery/6500X_RGB_WHITE_RENDER_01.webp', 1),
(626, 211, N'https://progenix.co.za/image/cache/catalog/cases/corsair/icue-series/icue-link-6500x-rgb/corsair-icue-link-6500x-rgb-black-10-800x800-0.jpg', 2),
(627, 211, N'https://www.pcstudio.in/wp-content/uploads/2024/05/Corsair-iCUE-Link-6500X-Rgb-Mid-Tower-Atx-Dual-Chamber-Pc-Cabinet-White-2.jpg', 3),
(628, 212, N'https://m.media-amazon.com/images/I/81ITzwvvZYL._AC_SL1500_.jpg', 1),
(629, 212, N'https://adsstore.in/wp-content/uploads/2025/07/Corsair-RM1000x-Shift-Fully-Modular-ATX-Power-Supply-6.jpg', 2),
(630, 212, N'https://assets.corsair.com/image/upload/akamai/pdp/rmx2021/images/rm1000x_hero.png', 3),
(631, 213, N'https://m.media-amazon.com/images/I/81WEsdsz5jL._AC_SL1500_.jpg', 1),
(632, 213, N'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Power-Supply-Units/CP-9020087-EU/Gallery/AX1600i_01.webp', 2),
(633, 213, N'https://www.startech.com.bd/image/cache/catalog/power-supply/corsair/ax1600i-digital-atx/ax1600i-digital-atx-04-500x500.jpg', 3),
(634, 214, N'https://assets.corsair.com/image/upload/f_auto,q_auto/v1682360586/akamai/pdp/k100/v2/dist/app-static/assets/images/smal-pp-keyboard.jpg', 1),
(635, 214, N'https://m.media-amazon.com/images/I/71Qy2Y+ol6L._AC_SL1500_.jpg', 2),
(636, 214, N'https://assets.corsair.com/image/upload/f_auto,q_auto/v1682360532/akamai/pdp/smal-pp-gallery_top.jpg', 3),
(637, 215, N'https://c1.neweggimages.com/productimage/nb640/26-816-206-02.png', 1),
(638, 215, N'https://gamingweapons.com/wp-content/uploads/2023/07/Corsair-Darkstar-Wireless-MMO-Gaming-Mouse-02-1.webp', 2),
(639, 215, N'https://m.media-amazon.com/images/I/61EeYbO1V2L._AC_.jpg', 3),
(640, 216, N'https://gamersrd.com/wp-content/uploads/2021/11/Corsair-Virtuoso-RGB-Wireless-XT-Gaming-Headset-Review.jpeg', 1),
(641, 216, N'https://www.bhphotovideo.com/images/fb/corsair_ca_9011188_na_virtuoso_rgb_wireless_xt_1812134.jpg', 2),
(642, 216, N'https://static-data2.manualslib.com/product-images/0de/2894319/corsair-virtuoso-rgb-wireless-xt-headsets.jpg', 3),
(643, 217, N'https://resource.logitechg.com/d_transparent.gif/content/dam/gaming/en/products/pro-x-superlight-2/gallery-1-pro-x-superlight-2-gaming-mouse-white.png', 1),
(644, 217, N'https://resource.logitechg.com/d_transparent.gif/content/dam/gaming/en/products/pro-x-superlight-2/gallery-5-pro-x-superlight-2-gaming-mouse-magenta.png', 2),
(645, 217, N'https://resource.logitechg.com/w_692,c_lpad,ar_4:3,q_auto,f_auto,dpr_1.0/d_transparent.gif/content/dam/gaming/en/products/pro-x-superlight-2/gallery-5-pro-x-superlight-2-gaming-mouse-black.png?v=1', 3),
(646, 218, N'https://m.media-amazon.com/images/I/61Wp2tBQLyL._AC_SL1500_.jpg', 1),
(647, 218, N'https://down-id.img.susercontent.com/file/28de11fc8307bdd2d393b75678cf10ac', 2),
(648, 218, N'https://down-ph.img.susercontent.com/file/ph-11134207-7rasd-m1nxhg5v03b27a', 3),
(649, 219, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6414/6414194_rd.jpg', 1),
(650, 219, N'https://resource.logitechg.com/w_1800,c_limit,f_auto,q_auto,f_auto,dpr_auto/d_transparent.gif/content/dam/gaming/en/products/g915-tkl/g915-tkl-feature-compact-design-desktop-new.png?v=1', 2),
(651, 219, N'https://assets.msy.com.au/newsite/images/202501/source_img/Keyboards-Logitech-G915-TKL-Lightspeed-Wireless-RGB-Mechanical-Keyboard-Tactile-White-920-009660-13.jpg', 3),
(652, 220, N'https://down-my.img.susercontent.com/file/my-11134207-7r98o-lx84gmbqfs6i26', 1),
(653, 220, N'https://www.m4g.com.my/image/m4g/image/cache/data/all_product_images/product-4819/cGubhECB1695016694-1384x1038.png', 2),
(654, 220, N'https://centrecomstatic.s3.amazonaws.com/images/editor/image/20230905/20230905094317_7338.png', 3),
(655, 221, N'https://www.bhphotovideo.com/images/images1500x1500/logitech_g_981_001268_pro_x_2_wireless_1763227.jpg', 1),
(656, 221, N'http://www.superoffice.com.au/cdn/shop/files/logitech-g-pro-x-2-lightspeed-wireless-gaming-headset-magenta-981-001276-superoffice-1.jpg?v=1710991461', 2),
(657, 221, N'https://media.pichau.com.br/media/catalog/product/cache/2f958555330323e505eba7ce930bdf27/9/8/981-0012624.jpg', 3),
(658, 222, N'https://prophonechile.cl/wp-content/uploads/2022/07/MASTER3S.png', 1),
(659, 222, N'https://m.media-amazon.com/images/I/61v1eEAWXYL._AC_.jpg', 2),
(660, 222, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6502/6502577_sd.jpg', 3),
(661, 223, N'https://www.bhphotovideo.com/images/images2000x2000/logitech_920_011406_mx_keys_s_wireless_1760696.jpg', 1),
(662, 223, N'https://ecommerce.datablitz.com.ph/cdn/shop/files/mx-keys-s-keyboard-3qtr-graphite-us_1600x.jpg?v=1686373163', 2),
(663, 223, N'https://m.media-amazon.com/images/I/71skZeAyPuL._AC_SL1500_.jpg', 3),
(664, 224, N'https://m.media-amazon.com/images/I/61BJ2MpgTTL.jpg', 1),
(665, 224, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/9c785da1-0f0c-4b71-a762-d70b206539a5.jpg', 2),
(666, 224, N'https://m.media-amazon.com/images/I/71tuAoPh-LL._AC_.jpg', 3),
(667, 225, N'https://i5.walmartimages.com/seo/Razer-DeathAdder-V3-Pro-Wireless-Esports-Gaming-Mouse-64g-5-Buttons-2-4GHz-Bluetooth-Black_69ac5e43-341c-499f-8742-66965667c504.8ce437491cef8bbe6558b25505fe6ac3.png', 1),
(668, 225, N'https://m.media-amazon.com/images/I/71SfcN143LL._AC_.jpg', 2),
(669, 225, N'https://www.invidcomputers.com/images/0000000000415572000188065415572--2-.png', 3),
(670, 226, N'https://m.media-amazon.com/images/I/81gJ6jkk3jL._AC_.jpg', 1),
(671, 226, N'https://cdn.mwave.com.au/images/400/razer_huntsman_v3_pro_tkl_analog_optical_mechanical_gaming_keyboard_ac70704_29092.jpg', 2),
(672, 226, N'https://m.media-amazon.com/images/I/71OAwYenQUL._AC_.jpg', 3),
(673, 227, N'https://www.mechanical-keyboard.org/wp-content/uploads/2024/11/BlackWidow-V4-Pro-75-2320x1667.jpg', 1),
(674, 227, N'https://www.scan.co.uk/images/products/xlarge/3646473-xl-b.jpg', 2),
(675, 227, N'https://cdn.mwave.com.au/images/400/razer_blackwidow_v4_pro_mechanical_gaming_keyboard_green_switches_ac60741_37129.jpg', 3),
(676, 228, N'https://m.media-amazon.com/images/I/71zu1br+iKL._AC_.jpg', 1),
(677, 228, N'https://www.singular.com.cy/images/detailed/610/Razer_BlackShark_V2_PRO_2023_Edition_headset_RZ0404530200R3M1-928864.jpg', 2),
(678, 228, N'https://www.custompc.com/wp-content/sites/custompc/2023/04/Razer-Blackshark-V2-Pro-2023-01.jpg', 3),
(679, 229, N'https://www.abcshop-eg.com/web/image/126254-765cc79f/2.jpg?access_token=e164eda9-db66-4365-8c4c-d1edeea2aade', 1),
(680, 229, N'https://www.ezpzsolutions.in/wp-content/uploads/2023/03/SAMSUNG-990-PRO-2TB-3.jpg', 2),
(681, 229, N'https://down-my.img.susercontent.com/file/sg-11134201-22120-ve1pq8ohvmkv6c', 3),
(682, 230, N'https://m.media-amazon.com/images/I/61tGYJigjWL.jpg', 1),
(683, 230, N'https://img.lazcdn.com/g/p/deff99708f490e129a5ec39cf04cdc68.jpg_720x720q80.jpg', 2),
(684, 230, N'https://media.ldlc.com/r1600/ld/products/00/06/10/22/LD0006102201.jpg', 3),
(685, 231, N'https://down-th.img.susercontent.com/file/th-11134207-23020-8xt6o7afx3nvc9', 1),
(686, 231, N'https://tt-tab.net/cdn/shop/files/Samsung_T7_Shield_Portable_SSD_2TB_Black_Package.webp?v=1755168066&width=1453', 2),
(687, 231, N'https://s3-ap-southeast-2.amazonaws.com/wc-prod-pim/JPEG_1000x1000/SASSDT72TB_F_samsung_t7_shield_2tb_portable_ssd_black.jpg', 3),
(688, 232, N'https://www.notebookcheck.net/fileadmin/Notebooks/News/_nc3/Samsung_Odyssey_OLED_G969.jpg', 1),
(689, 232, N'https://img.global.news.samsung.com/mx/wp-content/uploads/2023/08/2023-Odyssey-OLED-G9-Key-Visual_Horizontal_A38584.jpg', 2),
(690, 232, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/865cf1ba-8917-48bf-b4e7-31c5e5f8427c.jpg', 3),
(691, 233, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6559/6559078cv14d.jpg', 1),
(692, 233, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6559/6559078cv11d.jpg', 2),
(693, 233, N'https://www.gizmochina.com/wp-content/uploads/2023/10/G97NC_001_R-Perspective-Vertical_Black_SCOM.webp', 3),
(694, 234, N'https://cdn.neowin.com/news/images/uploaded/2024/07/1720628215_samsung_galaxy_buds3_pro.jpg', 1),
(695, 234, N'https://pakistanstore.pk/wp-content/uploads/2024/12/Samsung-Galaxy-Buds3-Pro.jpg', 2),
(696, 234, N'https://images.samsung.com/uk/galaxy-buds3-pro/feature/galaxy-buds3-pro-highlight-slide01-endframe-mo.jpg', 3),
(697, 235, N'https://cdn.inet.se/product/688x386/5306094_0.jpg', 1),
(698, 235, N'https://img.terabyteshop.com.br/produto/g/memoria-ddr5-kingston-fury-renegade-rgb-32gb-2x16gb-7200mhz-white-kf572c38rwak2-32_168452.jpg', 2),
(699, 235, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/2911357a-ed44-4a5a-904d-a7e0dc3f8667.jpg;maxHeight=1920;maxWidth=900?format=webp', 3),
(700, 236, N'https://cdn.mwave.com.au/images/400/kingston_fury_beast_rgb_32gb_2x_16gb_ddr5_6000mhz_desktop_memory_black_ac80050_82771.jpg', 1),
(701, 236, N'https://ddtech.mx/assets/uploads/bedeb2d25f69b8ddff3ee6a2798fe4ed.png', 2),
(702, 236, N'https://files.pccasegear.com/images/KF560C36BWEAK2-64-add1x1.jpg', 3),
(703, 237, N'https://product.hstatic.net/200000722513/product/kc3000-1_f1a79688f39d450faafc844a40c72749_585f3d7bd11e43b5b3634cf0a4914665.jpg', 1),
(704, 237, N'https://laptop.bg/system/images/338288/original/2tb_kingston_kc3000_m2_pcie_40_nvme.jpg', 2),
(705, 237, N'https://deltastore.az/_next/image?url=https:%2F%2Fdeltastoreimages.s3.eu-central-1.amazonaws.com%2F1-yeniiiiiiiiiniDjM.webp&w=3840&q=100', 3),
(706, 238, N'https://www.vsgamers.es/thumbnails/product_gallery_large/uploads/products/kingston/discos-duros/disco-ssd-kingston-nv2-1tb-pcie-40-nvme-m2/galeria/disco-ssd-kingston-nv2-1tb-pcie-40-nvme-m2-2.jpeg', 1),
(707, 238, N'https://media.ldlc.com/r1600/ld/products/00/05/97/36/LD0005973647.jpg', 2),
(708, 238, N'https://images.kabum.com.br/produtos/fotos/sync_mirakl/471237/SSD-Kingston-2TB-NV1-M-2-2280-NVME-PCIE-3-0-Gen4x4-Snv2s-2000g_1687390093_gg.jpg', 3),
(709, 239, N'https://i.pepita.hu/images/product/20008727/kingston-32gb-ddr5-5600mhz-kit2x16gb-sodimm-fury-impact-black_123436861_500x500.jpg', 1),
(710, 239, N'https://s13emagst.akamaized.net/products/67154/67153664/images/res_a35de71ab6e0c59e8824a1c3405fbbbc.jpg', 2),
(711, 239, N'https://progenix.co.za/image/cache/catalog/ram/kingston/ddr5/fury-impact-so-dimm/kingston-fury-impact-sodimm-2-800x800-0.jpg', 3),
(712, 240, N'https://www.adorama.com/images/Large/WD121KFBXA2.jpg', 1),
(713, 240, N'https://m.media-amazon.com/images/I/71TBEmVMfjL.__AC_SX300_SY300_QL70_ML2_.jpg', 2),
(714, 240, N'https://m.media-amazon.com/images/S/aplus-media-library-service-media/d39d4c72-3979-4065-82ec-2a850f04a193.__CR0,0,800,600_PT0_SX800_V1___.jpg', 3),
(715, 241, N'https://www.bigw.com.au/medias/sys_master/images/images/h54/h13/99681968783390.jpg', 1),
(716, 241, N'https://select.com.ng/media/catalog/product/cache/a38b917da5ab184066ddc7d1bf214715/s/e/seagate_ironwolf_pro_nas_hdd_16tb_1.png', 2),
(717, 241, N'https://www.bhphotovideo.com/images/fb/seagate_st16000nt001_16tb_ironwolf_pro_7200_1760984.jpg', 3),
(718, 242, N'https://cdn.noctua.at/media/nh_d15_g2_chromax_black_1.jpg', 1),
(719, 242, N'https://os-jo.com/image/cache/catalog/products/ANOCTUA/NH-D15-BLACK/Noctua_D15_pht23-1200x1200.JPEG', 2),
(720, 242, N'https://computerlounge.co.nz/cdn/shop/files/18bcd1a5986dbef09107708783527771bc2ef8f2_95708_5.jpg?v=1763687190&width=1214', 3),
(721, 243, N'https://m.media-amazon.com/images/I/61reVzOIDjL.jpg', 1),
(722, 243, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6529/6529623_sd.jpg', 2),
(723, 243, N'https://m.media-amazon.com/images/I/713NuIfbhZL._AC_SL1500_.jpg', 3),
(724, 244, N'https://cdn.mwave.com.au/images/400/nzxt_kraken_elite_rgb_360mm_aio_liquid_cpu_cooler_white_ac62027_82708.jpg', 1),
(725, 244, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6541/6541451_sd.jpg', 2),
(726, 244, N'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/89/MTA-164018122/nzxt_nzxt_kraken_elite_360_rgb_black_-_white_360mm_aio_liquid_cooler_with_lcd_display_and_argb_fans_full01_fnhqivzk.jpg', 3),
(727, 245, N'https://media.steelseriescdn.com/thumbs/filer_public/a9/ec/a9ec78a6-61db-4d30-913b-6d649d2a7be2/arctis_nova_pro_wl_black_ps_img_buy_1.png__1920x1080_crop-fit_optimize_subsampling-2.png', 1),
(728, 245, N'https://media.ldlc.com/r1600/ld/products/00/06/13/42/LD0006134237.jpg', 2),
(729, 245, N'https://m.media-amazon.com/images/I/61DznWnHItL._AC_SL1500_.jpg', 3),
(730, 246, N'https://i5.walmartimages.com/seo/BenQ-Zowie-XL2566K-24-5-Full-HD-LED-Gaming-LCD-Monitor-16-9-Dark-Gray-25-Class-Twisted-nematic-TN-1920-x-1080-360-Hz-Refresh-Rate-HDMI-VGA_32328961-779f-43fb-a23d-fb7b19ecd928.af62677c5cd0ab4869b62b7f1893f8ea.jpeg', 1),
(731, 246, N'https://media.karousell.com/media/photos/products/2022/12/8/benq_zowie_xl2566k_360hz_espor_1670494340_538dfa3b.jpg', 2),
(732, 246, N'https://image.benq.com/is/image/benqco/07-xl2566k-leftside?$ResponsivePreset$', 3),
(733, 247, N'https://www.bhphotovideo.com/images/images2000x2000/sony_wh1000xm5_s_wh_1000xm5_noise_canceling_wireless_over_ear_1706394.jpg', 1),
(734, 247, N'https://d1ncau8tqf99kp.cloudfront.net/converted/111295_original_local_1200x1050_v3_converted.webp', 2),
(735, 247, N'https://i5.walmartimages.com/seo/Sony-WH-1000XM5-The-Best-Wireless-Noise-Canceling-Headphones-Black_7384c879-1d54-47e8-9876-1d7adadcf0a5.542c245c25d295b30fa5820eacea4450.jpeg', 3),
(736, 248, N'https://www.spletninakupi.si/products/24-cp2k24g56c46u5-ddr5-48gb-5600mhz-cl46-kit-2x24gb-crucial-pro-11v-crna-cp2k24g56c46u5.jpg', 1),
(737, 248, N'https://pcspecchart.com/media/gallery/rammemory/Crucial%20Pro%20RAM%2048GB%20Kit%20(2x24GB)%20DDR5%205600MHz%20Gallery/817de6fb8e794b2_ui2TBnr.jpg', 2),
(738, 248, N'https://netcodex.ph/wp-content/uploads/2025/03/Crucial-Pro-48GB-Kit-2x24GB-DDR5-6000-UDIMM-Desktop-Memory.png', 3),
(739, 249, N'https://m.media-amazon.com/images/I/71IyDaBF8RL.jpg', 1),
(740, 249, N'https://m.media-amazon.com/images/I/81MOGI316gL.jpg', 2),
(741, 249, N'https://m.media-amazon.com/images/I/81MOGI316gL._AC_.jpg', 3),
(742, 250, N'https://jo.performapc.com/wp-content/uploads/2024/08/O11DERGB-007.jpg', 1),
(743, 250, N'https://lian-li.com/wp-content/uploads/2023/12/O11D-EVO-RBG_09.webp', 2),
(744, 250, N'https://files.pccasegear.com/images/1703135847-G99-O11DERGBX-00-thb.jpg', 3),
(745, 251, N'https://www.autonetpc.com/wp-content/uploads/2024/01/lcd_10_c.jpg', 1),
(746, 251, N'https://c1.neweggimages.com/productimage/nb1280/AFSTS241216iOS8Q.jpg', 2),
(747, 251, N'https://media.ldlc.com/r1600/ld/products/00/06/09/86/LD0006098667.jpg', 3),
(748, 252, N'https://avaxos.com/wp-content/uploads/2022/12/EVGA-SuperNOVA-1000-G7-220-G7-1000-X1-1000-W-ATX12V-EPS12V-SLI-CrossFire-80-PLUS-GOLD-Certified-Full-Modular-Active-PFC-Power-Supply-g1.jpg', 1),
(749, 252, N'https://compuartstore.com/wp-content/uploads/opencart-import/catalog/products_2023/71KoTLcfyHL._AC_SL1500_.jpg', 2),
(750, 252, N'https://avaxos.com/wp-content/uploads/2022/12/EVGA-SuperNOVA-1000-G7-220-G7-1000-X1-1000-W-ATX12V-EPS12V-SLI-CrossFire-80-PLUS-GOLD-Certified-Full-Modular-Active-PFC-Power-Supply-g3.jpg', 3),
(751, 253, N'https://bigbyte.com.np/wp-content/uploads/2023/09/Deepcool-AK620-Digital-Black-air-cooler-scaled.jpg', 1),
(752, 253, N'https://m.media-amazon.com/images/I/71jl2CxNoxL._SL1500_.jpg', 2),
(753, 253, N'https://microless.com/cdn/products/f890413f70c55cbdef09c06af25a449d-hi.jpg', 3),
(754, 254, N'https://m.media-amazon.com/images/I/71XP3HKyHDL.jpg', 1),
(755, 254, N'https://sweetloot.my/wp-content/uploads/2023/05/thermalright-peerless-assassin-120-se-hero-800x800.jpg', 2),
(756, 254, N'https://cdn11.bigcommerce.com/s-sp9oc95xrw/images/stencil/1280x1280/products/65170/153217/7890-PRODUCT_IMAGE_14__57233.1775193958.png?c=2?imbypass=on', 3),
(757, 255, N'https://m.media-amazon.com/images/I/81HxCfuGyeL._AC_SL1500_.jpg', 1),
(758, 255, N'https://www.cclonline.com/images/avante/02_Dark_Power_13.jpg?width=1600&height=1600&scale=canvas&trim.threshold=80', 2),
(759, 255, N'https://cdn.mwave.com.au/images/400/bn702_ac59761_72557.jpg', 3),
(760, 256, N'https://www.jumbo-computer.com/cdn/shop/files/Intel265FTray_1600x.png?v=1758006131', 1),
(761, 256, N'https://cdn.hstatic.net/products/200000921511/bpstore-cpu-intel-core-ultra-7-265f-tray_43d2001c981e40b8a26bd37eebeff9cc_grande.jpg', 2),
(762, 256, N'https://cdn.hstatic.net/products/200000921511/bpstore-cpu-intel-core-ultra-7-265_d35cc92fd68f42399206996df923fad4_grande.png', 3),
(763, 257, N'https://product.hstatic.net/1000262653/product/intel-core-i5-12400f-i5-12400f-2_3f94ad4a61ff4747866da2a7425e4e3e_master.png', 1),
(764, 257, N'https://down-vn.img.susercontent.com/file/vn-11134201-7ra0g-m6ur80v3sg8o9f', 2),
(765, 257, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-luinzx5yvrc5eb', 3),
(766, 258, N'https://zicomputer.com/wp-content/uploads/2026/01/14700f-Tray-768x768.png', 1),
(767, 258, N'https://www.hankerz.com.eg/wp-content/uploads/2026/04/CPU-Intel-Core-I7-14700F-tray-LGA1700.png', 2),
(768, 258, N'https://down-vn.img.susercontent.com/file/sg-11134201-8261l-mmha1o5qng9b92', 3),
(769, 259, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3783/innergigabyte/images/product/rgb/cover.png', 1),
(770, 259, N'https://cdnx.jumpseller.com/skyhightechnology/image/62755436/resize/893/893?1745371842', 2),
(771, 259, N'https://duyhungcomputer.vn/media/product/3825-mainboard-gigabyte-z890-eagle-wifi7-ddr5-01.jpg', 3),
(772, 260, N'https://media.ldlc.com/r1600/ld/products/00/06/12/72/LD0006127278.jpg', 1),
(773, 260, N'https://static.gigabyte.com/StaticFile/Image/Global/d2ebd0dba533583448392eaba7601b99/Product/38749', 2),
(774, 260, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3561/innergigabyteimages/specsmall.jpg', 3),
(775, 261, N'https://m.media-amazon.com/images/I/81pSTc-GhVL._AC_SL1500_.jpg', 1),
(776, 261, N'https://cdn.mwave.com.au/images/400/gigabyte_b760m_gaming_plus_wifi_ddr4_lga_1700_microatx_motherboard_ac82308_91498.jpg', 2),
(777, 261, N'https://maxxicomp.com/6696-large_default/mainboard-gigabyte-b760m-gaming-plus-wifi-ddr4-lga1700.jpg', 3),
(778, 262, N'https://cdn.hstatic.net/products/200000420363/screenshot_78_978c405e8c91410e80706fcb52fc9733_master.jpg', 1),
(779, 262, N'https://tinhochungphat.com/wp-content/uploads/2026/02/ram-pc-kingmax-horizon-16gb-ddr5-1x16gb-5600mhz-intel-amd-km-ld54-5600-16gshn38_2-510x509.jpg', 2),
(780, 262, N'https://songphuong.vn/Content/uploads/2025/07/RAM-Kingmax-2x8GB-DDR5-5600-HEATSINK-HORIZON.webp', 3),
(781, 263, N'https://cdn.hstatic.net/files/200000722513/file/ram-kingspec-heatsink-red-1x16gb-ddr4-bus-3200mhz-7.jpg', 1),
(782, 263, N'https://tinhocanhphat.vn/media/product/21767_ram_kingspec_16gb__1x16gb_ddr4_3200mhz_red_1.webp', 2),
(783, 263, N'https://cdn.hstatic.net/files/200000722513/file/ram-kingspec-heatsink-red-1x16gb-ddr4-bus-3200mhz-6.jpg', 3),
(784, 264, N'https://m.media-amazon.com/images/I/71bmZxrahrL._AC_SL1500_.jpg', 1),
(785, 264, N'https://c1.neweggimages.com/BizIntell/item/VGA/Video%20Card%20-%20Nvidia/14-137-935/3.png', 2),
(786, 264, N'https://c1.neweggimages.com/productimage/nb1280/14-137-935-19.jpg', 3),
(787, 265, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3886/innergigabyte/images/cooling-passive-screen.png', 1),
(788, 265, N'https://www.ultratech.com.bd/image/cache/catalog/Gigabyte/gigabyte-geforce-rtx-5080-windforce-oc-sff-16g-graphics-card-500x500.jpg', 2),
(789, 265, N'https://media.ldlc.com/r1600/ld/products/00/06/20/53/LD0006205313.jpg', 3),
(790, 266, N'https://m.media-amazon.com/images/I/71LEd3BxrJL._AC_SL1500_.jpg', 1),
(791, 266, N'https://a.allegroimg.com/s720/296880/7fb3f2a147c19a1c4c6477347b19/Karta-graficzna-MSI-GeForce-RTX-5060-Ventus-2X-OC-8GB-GDDR7-DLSS4', 2),
(792, 266, N'https://storage-asset.msi.com/global/picture/image/feature/vga/NVIDIA/new-gen/GB206-250-8G-VENTUS-2X-OC-WHITE/kv/ventus-2x-8g-white-kv-v1.png', 3),
(793, 267, N'https://www.zotac.com/download/files/styles/w1024/public/product_gallery/graphics_cards/zt-b50610h-10m-image08.jpg?itok=kmrq_GzM', 1),
(794, 267, N'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/z/t/zt-b50610e-10m-5.jpg', 2),
(795, 267, N'https://www.zotac.com/download/files/styles/w1024/public/product_gallery/graphics_cards/zt-b50610e-10m-image05.jpg?itok=0K3T0q-Z', 3),
(796, 268, N'https://m.media-amazon.com/images/I/71ZnK38jZzL.jpg', 1),
(797, 268, N'https://memoryzone.aecomapp.com/storage/files/1723544150ssd-kingston-nv3-1tb-m-2-pcie-gen4-x4-nvme-snv3s-1000g-04.jpg.webp', 2),
(798, 268, N'https://memoryzone.aecomapp.com/storage/files/1723544150ssd-kingston-nv3-1tb-m-2-pcie-gen4-x4-nvme-snv3s-1000g-03.jpg.webp', 3),
(799, 269, N'https://cdn.hstatic.net/products/200000420363/710__ne-512-2_064a72b7ebde4bdd814925329a5cce8a_master.jpeg', 1),
(800, 269, N'https://cdn.hstatic.net/products/200000079075/kingspec-512gb-nvme_ne-512_b994303b03e545688846b2694459ceca_master.png', 2),
(801, 269, N'https://laptopworld.vn/media/product/24296_thi___t_k____ch__a_c___t__n__4_.jpg', 3),
(802, 270, N'https://cdn.hstatic.net/products/200000680839/sair-rm850e-atx-3-1-cybenetics-gold-850w-80-plus-gold-cp-9020296-na-11_fef0574d387442e2960fbcaeb3d5f81f_1024x1024.jpg', 1),
(803, 270, N'https://image.ceneostatic.pl/data/products/180558401/1629a9d7-6e60-4d1d-bf0e-170d5ac752f1_i-corsair-rm850e-850w-80-plus-gold-atx-3-1-cp9020296eu.jpg', 2),
(804, 270, N'https://songphuong.vn/Content/uploads/2025/06/Nguon-Corsair-RM850e-850W-80-Plus-Gold-6.webp', 3),
(805, 271, N'https://philong.com.vn/media/product/34900-nguon-may-tinh-coolermaster-mwe-bronze-650-v3-230v-mpe-6501-acabw-3beu-philong--1-.png', 1),
(806, 271, N'https://product.hstatic.net/200000722513/product/smart_14ca4a1af49c40789c3caeb7939fe21c.png', 2),
(807, 271, N'https://product.hstatic.net/200000722513/product/smart__2__f35dacdc25aa48ea81a6a643482a59fa_master.png', 3),
(808, 272, N'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mmgyeqxs311da2', 1),
(809, 272, N'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mfyr21fh5urw11', 2),
(810, 272, N'http://www.kccshop.vn/media/product/250-11943-ngu---n-m--y-t--nh-fsp-hv-pro-650w---80-plus-bronze--650w-_1_main.jpeg', 3),
(811, 273, N'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Power-Supply-Units/base-cx-series-2023-config/CX650/CX650_01.webp', 1),
(812, 273, N'https://desktop.lk/wp-content/uploads/2024/04/CORSAIR-CX650-80-PLUS-BRONZE-POWER-SUPPLY-CP-9020278-UK-02.jpg', 2),
(813, 273, N'https://down-br.img.susercontent.com/file/sg-11134201-824iy-mdxb9u0l6k1v2d', 3),
(814, 274, N'https://ale.pl/494974-thickbox_default/corsair-obudowa-3500x-lxr-link-tg-mid-tower-black.jpg', 1),
(815, 274, N'https://www.invidcomputers.com/images/000000000041645449949416454--1-.jpg', 2),
(816, 274, N'https://product.hstatic.net/200000722513/product/3500x_blk_02_8c5ec3403ce8488991921006a975582d_1024x1024.png', 3),
(817, 275, N'https://australianwarehouses.com.au/wp-content/uploads/2026/01/Corsair-FRAME-4500X-RS-R-ARGB-Panoramic-Glass-Mid-Tower-PC-Case-Black-478x499x246mm-E-ATX-460mm-GPU-185mm-CPU-USB-C-ARGB-360mm-rad-11.58kg.jpg', 1),
(818, 275, N'https://assets.corsair.com/image/upload/f_auto,q_auto/v1757524913/products/Cases/base-frame-4500x-config/content/rs-r/Panel08_Image_Left_RS-R_BLACK_2x.png', 2),
(819, 275, N'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Cases/base-frame-4500x-config/gallery/rs-r/black/frame-4500x-rsr-blk_01.webp', 3),
(820, 276, N'https://philong.com.vn/media/product/35763-tan-nhiet-nuoc-aio-corsair-nautilus-360-rs-argb-black-cw-9060093-ww-philong--1-.png', 1),
(821, 276, N'https://product.hstatic.net/1000238589/product/804_tan_nhiet_nuoc_aio_corsair_nautilus_360_argb_black_cw_9060093_ww_4_111a670d09dc4239804ba353c464f052_master.jpg', 2),
(822, 276, N'https://phucanhcdn.com/media/lib/29-10-2025/tnnhitncaiocorsairnautilus360argbblackcw-9060093-ww2.jpg', 3),
(823, 277, N'https://rinconcitogamer.com/wp-content/uploads/2025/07/cooler-master-hyper-212-spectrum-v3-1.png', 1),
(824, 277, N'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/h/y/hyper_212_spectrum_3_.jpg', 2),
(825, 277, N'https://www.geekawhat.com/wp-content/uploads/2023/02/Hyper-212-Spectrum-V3_361.jpg', 3),
(826, 278, N'https://images.khmer24.co/25-08-14/intel-core-i9-14900k-tray-621775175514217727764988-b.jpg', 1),
(827, 278, N'https://dgkaj.com/wp-content/uploads/2025/04/INTEL-Core-i9-14900K-Tray-1.webp', 2),
(828, 278, N'https://static.tandoanh.vn/wp-content/uploads/2025/02/Intel-i9-14900K-tray.jpg', 3),
(829, 279, N'https://www.techpowerup.com/review/intel-core-ultra-9-285k/images/title.jpg', 1),
(830, 279, N'https://www.dsogaming.com/wp-content/uploads/2024/10/Intel-Core-Ultra-200.jpg', 2),
(831, 279, N'https://cdn.wccftech.com/wp-content/uploads/2025/12/Intel-Core-Ultra-9-290K-Plus-1920x1077.jpg', 3),
(832, 280, N'https://dlcdnwebimgs.asus.com/gain/7512B84A-0D14-4798-A585-3439F4B645CB/w1000/h732', 1),
(833, 280, N'https://www.quietpc.com/images/products/asus-z790-maximus-hero-box-large.jpg', 2),
(834, 280, N'https://dlcdnwebimgs.asus.com/files/media/29C004F7-7B1F-4EBF-9099-7168B520A0EE/v1/img/kv/pd.png', 3),
(835, 281, N'https://dlcdnwebimgs.asus.com/files/media/a5eca346-6ff6-404b-beea-e24b00fafcb1/v1/img/spec/connectivity_m.png', 1),
(836, 281, N'https://dlcdnwebimgs.asus.com/files/media/a5eca346-6ff6-404b-beea-e24b00fafcb1/v1/img/stability/pd.png', 2),
(837, 281, N'https://media.ldlc.com/r1600/ld/products/00/05/99/93/LD0005999366.jpg', 3),
(838, 282, N'https://m.media-amazon.com/images/I/61FvCy+l77L._AC_SL1500_.jpg', 1),
(839, 282, N'https://cdn.aqua.hu/1841/WV-1676231.jpg', 2),
(840, 282, N'https://microless.com/cdn/products/c6cef1922e6e135b3ce508bea77d85e6-hi.jpg', 3),
(841, 283, N'https://c1.neweggimages.com/ProductImageCompressAll1280/20-374-431-10.png', 1),
(842, 283, N'https://m.media-amazon.com/images/I/71DiVTefKBL._AC_.jpg', 2),
(843, 283, N'https://www.gskill.com/img/overview/tz5-rgb/04-trident-z5-rgb-extreme-memory-performance.jpg', 3),
(844, 284, N'https://press.asus.com/assets/w_1779,h_793/58d6e031-a1ab-4dfb-b85c-99b9d97364c2/ROG%20Matrix%20GeForce%20RTX%205090%20-%20ASUS%20Graphics%20Card%2030th%20Anniversary%20Edition_Front.png', 1),
(845, 284, N'https://speedlogic.com.co/wp-content/uploads/2026/01/52361_1.jpg', 2),
(846, 284, N'https://multitech-lb.com/wp-content/uploads/multitech-lebanon-ASUS-ROG-STRIX-G635LX-S5156-Core-ULTRA-9-RTX-5090-24GB.jpg', 3),
(847, 285, N'https://images.samsung.com/is/image/samsung/p6pim/ca_fr/mz-v9p2t0b-am/gallery/ca-fr-990pro-nvme-m2-ssd-mz-v9p2t0b-am-534208574?$650_519_PNG$', 1),
(848, 285, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6523/6523595_sd.jpg', 2),
(849, 285, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6523/6523595cv12d.jpg', 3),
(850, 286, N'https://cdn2.37left.lk/images/asus-rog-ryujin-iii-360-argb-extreme-7MZSY9qdzknG.webp', 1),
(851, 286, N'https://dlcdnwebimgs.asus.com/files/media/3B1155AB-73FC-4B0D-922D-9C70148F449B/v1/img/fan.jpg', 2),
(852, 286, N'https://dlcdnwebimgs.asus.com/gain/E1784088-9171-46A6-BD0E-BCDF0C8CCC87', 3),
(853, 287, N'https://bizweb.dktcdn.net/100/533/247/products/1658758849-1692696.jpg?v=1754561963193', 1),
(854, 287, N'https://bizweb.dktcdn.net/100/533/247/products/1658759624-img-1802162.jpg?v=1754561963193', 2),
(855, 287, N'https://lagihitech.vn/wp-content/uploads/2023/03/the-nho-SDXC-SanDisk-Extreme-PRO-128GB-200MBs-SDSDXXD-128G-GN4IN-hinh-5.jpg', 3),
(856, 288, N'https://bizweb.dktcdn.net/100/329/122/products/the-nho-microsdxc-samsung-pro-plus-u3-256gb-04-92d9cc99-c5b8-43bc-8ce1-73dc9d2c7524.jpg?v=1739504667270', 1),
(857, 288, N'https://lagihitech.vn/wp-content/uploads/2022/03/the-nho-samsung-pro-plus-sd-256gb-6.jpg', 2),
(858, 288, N'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mlygwlj0ak1t1c', 3),
(859, 289, N'https://philong.com.vn/media/product/31791-the-nho-microsdxc-512gb-lexar-1066x-silver-series-uhs-i-160mbs-lms1066512g-bnang-philong--2-.jpg', 1),
(860, 289, N'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/88/MTA-94052020/_lexar_lexar_512gb_professional_1066x_sdxc_uhs-i_memory_card_full03_gj81wyt1.jpg', 2),
(861, 289, N'https://bizgramasia.com/wp-content/uploads/2025/02/1066sd_slider_512GB_1.png', 3),
(862, 290, N'https://www.bhphotovideo.com/images/fb/kingston_sdg4_128gb_128gb_canvas_go_plus_1891011.jpg', 1),
(863, 290, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/598/846/products/668252457-kingston-sdxc-canvas-go-plus-170r-128gb-u3-v30-sdg3-128gb.jpg?v=1758288845803', 2),
(864, 290, N'https://usbbaomat.vn/wp-content/uploads/2023/03/the-nho-kingston-sd-flash-sdcards-sdg3-128gb-kingstonvietnam.vn-3-1024x1024.jpeg', 3),
(865, 291, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/the-nho-sdxc-sandisk-ultra-64gb-140mb-s-sdsdunb-064g-gn6in-3.jpg?v=1670225291247', 1),
(866, 291, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lnnty60hbuyi30', 2),
(867, 291, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/the-nho-sdxc-sandisk-ultra-64gb-140mb-s-sdsdunb-064g-gn6in-1.jpg?v=1670225291247', 3),
(868, 292, N'https://www.ryans.com/storage/products/main/transcend-330s-sdxc-128gb-uhs-i-u3v30-sd-card-11598097033.webp', 1),
(869, 292, N'https://www.techlandbd.com/cache/images/uploads/products/P0512506271/transcend-memory-card-330s-uhs-i-cover.webp', 2),
(870, 292, N'https://pacific.pk/wp-content/uploads/2021/08/Transcend-SDXC-SDHC-500S-Memory-Card-32GB.jpg', 3),
(871, 293, N'https://haliti.com.vn/wp-content/uploads/2023/05/the-nho-prograde-digital-microSDXC-UHS-II-V60-250R-256gb-haliti-01-300x300.jpg', 1),
(872, 293, N'https://www.bhphotovideo.com/images/images1000x1000/prograde_digital_pgmsd256gbpbh_256gb_microsdxc_uhs_ii_memory_1560275.jpg', 2),
(873, 293, N'https://www.bhphotovideo.com/images/fb/prograde_digital_pgsd256gbk2bh_256gb_uhs_ii_v60_sdxc_1499811.jpg', 3),
(874, 294, N'https://down-id.img.susercontent.com/file/sg-11134201-824it-mebpwlhi3h8nad', 1),
(875, 294, N'https://product.hstatic.net/200000863343/product/the-nho-sony-sdxc-128gb-sf-g-series-tough-uhs-ii-v90-u3-300mb-s-s6jch_11da881e672f48d38ba0b2e05eb5396a.jpg', 2),
(876, 294, N'https://cdn.vjshop.vn/phu-kien-nhiep-anh/the-nho/the-sd/the-nho-sony-sdxc-128gb-sf-g-series-tough-uhs-ii/sony-sdxc-128gb-sf-g-series-tough-uhs-ii-3.jpg', 3),
(877, 295, N'https://lh3.googleusercontent.com/mgOAHNBGiNn2uSwL0ZncJ9B-WeMKV_L4-Tcc6H-Nt0zF7I7oS90jX4LPcJ0VhoZ99C_WK9K-KWOWOdWwsg0pNtfJb3HDd58=rw', 1),
(878, 295, N'https://s13emagst.akamaized.net/products/111756/111755814/images/res_e2fcdc1dae971233536123938b1fdb82.jpg', 2),
(879, 295, N'https://viethansecurity.com/media/lib/27-05-2025/kioxia-lmhe1g128gg2-the-nho-kioxia-exceria-high-endurance-128gb-microsd.jpeg', 3),
(880, 296, N'https://i5.walmartimages.com/seo/TEAMGROUP-256GB-Micro-SDXC-Flash-Memory-Card-with-Adapter_ffb08bb2-2cc6-4759-abaa-8c3bae25ecf1.1d29359e766c819f5027b64d93fdf03c.jpeg', 1),
(881, 296, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/b9a4a39d-1bc3-4ab3-84b3-032dba872da5.jpg;maxHeight=1920;maxWidth=900?format=webp', 2),
(882, 296, N'https://c.cdnmp.net/351344654/p/l/3/teamgroup-micro-sdxc-256gb-uhs-i-elite-sd-adapter-teausdx256giv30a103~12763.jpg', 3),
(883, 297, N'https://cdn.tgdd.vn/Products/Images/1902/328432/o-cung-ssd-1tb-sandisk-extreme-portable-sdssde61-thumb-1-1-600x600.jpg', 1),
(884, 297, N'https://anphat.com.vn/media/product/35596_8ecaba8b7a60af2e8284c3b80e3d7256.jpg', 2),
(885, 297, N'https://static.tweaktown.com/content/9/6/9617_02_sandisk-extreme-1tb-portable-ssd-review_full.jpg', 3),
(886, 298, N'https://ssdmemory.vn/Uploads/20240216-141542.jpg', 1),
(887, 298, N'https://www.nnkk.vn/media/product/3786_ssd_samsung_t7_shield__2tb_xanh6.jpg', 2),
(888, 298, N'https://cdn2.cellphones.com.vn/x/media/catalog/product/o/-/o-cung-di-dong-ssd-samsung-t7-shield-portable-2tb_8_.png', 3),
(889, 299, N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m1ffwst3f5q741', 1),
(890, 299, N'https://songphuong.vn/Content/uploads/2022/09/O-cung-di-dong-WD-My-Passport-2TB-WDBYVG0020BBK-songphuong.vn-01.jpg', 2),
(891, 299, N'https://tuanphong.vn/pictures/full/2019/08/1566120981-617-hdd-portable-2tb-wd-my-passport-4.jpg', 3),
(892, 300, N'https://zshop.vn/images/detailed/177/Crucial_X9_Pro__1_.jpg', 1),
(893, 300, N'https://5sc.vn/wp-content/uploads/2021/06/crucial-pro-portables-left.jpg', 2),
(894, 300, N'https://tuanphong.vn/pictures/full/2024/06/1717475336-841-crucial-x9pro-b.jpg', 3),
(895, 301, N'https://duylinhlaptop.vn/Images/image/Linh%20kien%20Pc/O%20cung%20cam%20ngoai/%E1%BB%94%20c%E1%BB%A9ng%20g%E1%BA%AFn%20ngo%C3%A0i%20Seagate%20Expansion%208TB/seagate-expansion-8tb-(98).jpg', 1),
(896, 301, N'https://www.picclickimg.com/DYgAAOSwFJlnoy~M/Seagate-Expansion-8TBExternal-35-inch-STKP8000400-Hard-Disk.webp', 2),
(897, 301, N'https://khanhchaudigital.vn/uploads/medium/seagate-one-touch-8tb-(2).jpg', 3),
(898, 302, N'https://techland.com.vn/public_folder/folder_image/uploads/2020/05/lacie-rugged-mini-usb-3.0-2.jpg', 1),
(899, 302, N'https://thekyjsc.com.vn/datafiles/setone/16170095287450_250_3166_stjj5000400.jpg', 2),
(900, 302, N'https://down-id.img.susercontent.com/file/bac5a5a3e5679418bee8b4a655cd2921', 3),
(901, 303, N'https://tuanphong.vn/upload_images/images/2023/09/SSD-Portable-Kingston-XS2000-3-.jpg', 1),
(902, 303, N'https://tuanphong.vn/upload_images/images/2023/09/SSD-Portable-Kingston-XS2000-4-.jpg', 2),
(903, 303, N'https://itsystems.vn/store/wp-content/uploads/2026/04/o-cung-di-dong-500gb-external-ssd-kingston-xs2000-usb-3-2-gen-2x2-sxs2000-500g-1.png', 3),
(904, 304, N'https://down-vn.img.susercontent.com/file/vn-11134208-7ras8-mcjoc7muj3xp41', 1),
(905, 304, N'https://www.officewarehouse.com.ph/__resources/_web_data_/products/products/image_gallery/7790_4338.jpg', 2),
(906, 304, N'https://cdn2.cellphones.com.vn/x/media/catalog/product/o/-/o-cung-di-dong-hdd-transcend-1tb-storejet-slim-25m3s-ts1tsj25m3s_1_.png', 3),
(907, 305, N'https://badudeal.lk/wp-content/uploads/2024/08/Corsair-EX100U-2TB-Type-C-Portable-SSD-srilanka-badudeal.lk-1.jpg', 1),
(908, 305, N'https://lzd-img-global.slatic.net/g/p/264cfc3aeb97ac429bb9d5ee5608222c.jpg_720x720q80.jpg', 2),
(909, 305, N'https://static.tweaktown.com/content/1/0/10295_03_corsair-ex100u-2tb-portable-ssd-review-universally-compatible-speedster.jpg', 3),
(910, 306, N'https://dh9cuahs6ezpz.cloudfront.net/images/products/bb/adata-17312-3_144364.jpg', 1),
(911, 306, N'https://m.media-amazon.com/images/I/6199XaLQabL.jpg', 2),
(912, 306, N'https://ae01.alicdn.com/kf/S3ca7f016e8874586ae604880e6944caeE.jpg', 3),
(913, 307, N'https://bizweb.dktcdn.net/100/329/122/products/tan-nhiet-nuoc-aio-nzxt-kraken-360-rgb-white-rl-kr360-w1.jpg?v=1683534200547', 1),
(914, 307, N'https://www.hardwareluxx.de/images/cdn02/uploads/2024/Oct/slick_host_nx/nzxt_kraken_elite_360_rgb_v2_01_3840px.jpg', 2),
(915, 307, N'https://hoanghapccdn.com/media/product/4685_nzxt_kraken_elite_360_rgb_white_ha4.jpg', 3),
(916, 308, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/tan-nhiet-nuoc-aio-corsair-icue-link-h150i-rgb-white-cw-9061006-ww-1.jpg?v=1743638708323', 1),
(917, 308, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/tan-nhiet-nuoc-aio-corsair-icue-link-h150i-rgb-white-cw-9061006-ww-4.jpg?v=1688527370387', 2),
(918, 308, N'https://gland.vn/media/product/14812_c85e04e701f3abadf2e21.jpg', 3),
(919, 309, N'https://vienlaptop.vn/thumbs/700x700x1/upload/product/tan-nhiet-nuoc-asus-rog-ryujin-iii-360-argb-extreme-white-edition-2-4243.png', 1),
(920, 309, N'https://sp-one.vn/Content/uploads/2025/01/ROG-RYUJIN-III-360-ARGB-EXTREME-WHITE-EDITION-02.jpg', 2),
(921, 309, N'https://dlcdnwebimgs.asus.com/gain/C5025E53-3EC0-47A8-9C38-B4CE61519C17', 3),
(922, 310, N'https://philong.com.vn/media/product/32659-tan-nhiet-nuoc-aio-cpu-msi-mag-coreliquid-e360-black-philong--2-.png', 1),
(923, 310, N'https://philong.com.vn/media/product/32659-tan-nhiet-nuoc-aio-cpu-msi-mag-coreliquid-e360-black-philong--1-.png', 2),
(924, 310, N'https://product.hstatic.net/200000722513/product/1024__3__fe5c03931d9843d59a946dbb5fbbc688_master.png', 3),
(925, 311, N'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mhma217ha8sl77', 1),
(926, 311, N'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-ljwuju1tssz89d', 2),
(927, 311, N'https://product.hstatic.net/1000238589/product/57004_tan_nhiet_nuoc_aio_deepcool_lt720_black_high_perfotmance_1_2d706e810f104fffa9fd0a1ab46812e6_large.jpg', 3),
(928, 312, N'https://technicstore.net/wp-content/uploads/2023/08/Galahad-II-Trinity-SL-AIO-360-white-2-350x350.jpg', 1),
(929, 312, N'https://product.hstatic.net/200000722513/product/360_t_w_b049481a55954ca9ad0600943ff4d50d_master.jpg', 2),
(930, 312, N'https://m.media-amazon.com/images/I/61GMvzXd7sL.jpg', 3),
(931, 313, N'https://hoanghapccdn.com/media/product/4737_masterliquid_360_atmos_ha4.jpg', 1),
(932, 313, N'https://cdn.hstatic.net/products/200000921511/tan_nhiet_nuoc_aio_cooler_master_masterliquid_360_atmos_ii_lcd_argb__e239ea71b7374b07b5c1be4178802997.jpg', 2),
(933, 313, N'https://product.hstatic.net/200000420363/product/ml-360l-core-argb-gallery-3-image_3310b31de2f34179a0eb40b3d0ea2c38_master.jpg', 3),
(934, 314, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lqkayrc8pfef70', 1),
(935, 314, N'https://kccshop.vn/media/product/250-4902-1.jpg', 2),
(936, 314, N'https://kccshop.vn/media/product/250-4902-4.jpg', 3),
(937, 315, N'https://gland.vn/media/product/15140_81374_t___n_nhi___t_n_____c_valkyrie_gl360___en__3_.jpg', 1),
(938, 315, N'https://gland.vn/media/product/15140_81374_t___n_nhi___t_n_____c_valkyrie_gl360___en__5_.jpg', 2),
(939, 315, N'https://hanoinew.vn/media/product/10568-valkyrie-gl360-1.jpg', 3),
(940, 316, N'https://bizweb.dktcdn.net/100/329/122/products/tan-nhiet-nuoc-aio-id-cooling-dashflow-360-basic-black-id-cpu-dashflow-360-basic-black-1.jpg?v=1681876305273', 1),
(941, 316, N'https://product.hstatic.net/1000262653/product/dashflow-basic-black_55927ec92053444db39f8061cfeb9c01_master.png', 2),
(942, 316, N'https://nguyencongpc.vn/media/product/250-24554-b----t---n-nhi---t-n-----c-id-cooling-dashflow-360-basic-black-12.jpg', 3),
(943, 317, N'https://pcmarket.vn/media/product/10793_geforce_rtx____4070_ti_super_windforce_oc_16g_02.png', 1),
(944, 317, N'https://pcmarket.vn/media/product/10793_geforce_rtx____4070_ti_super_windforce_oc_16g_06.png', 2),
(945, 317, N'https://tpucdn.com/gpu-specs/images/b/11492-front.jpg', 3),
(946, 318, N'https://sp-one.vn/Content/uploads/2024/09/tuf-rtx4080s-o16g-gaming-02_b718b2242f374ff7b33e2da72f364811_1024x1024-1.webp', 1),
(947, 318, N'https://www.tncstore.vn/media/lib/31-01-2024/tnc-store-card-man-hinh-asus-tuf-geforce-rtx-4080-super-16gb5.jpg', 2),
(948, 318, N'https://www.tncstore.vn/media/product/9797-rtx-asus-3.png', 3),
(949, 319, N'https://maytinhlmc.vn/wp-content/uploads/82277_card_man_hinh_msi_rtx_4060_ti_gaming_x_slim_white_16g__4_.jpg', 1),
(950, 319, N'https://khanhlinhpc.vn/hinh-anh/san-pham/121654864355.png', 2),
(951, 319, N'https://product.hstatic.net/1000333506/product/9119-card-man-hinh-msi-geforce-rtx-4060ti-gaming-x-16g-1_9736451ca3da4db39df495246edd1a53_grande.jpg', 3),
(952, 320, N'https://down-my.img.susercontent.com/file/sg-11134201-7rbmz-lqmbecjqh6qoa2', 1),
(953, 320, N'https://m.media-amazon.com/images/I/81lFiSf7S2L._AC_.jpg', 2),
(954, 320, N'https://img.pccomponentes.com/articles/1081/10810538/2322-zotac-gaming-geforce-rtx-4070-super-twin-edge-oc-12gb-gddr6x-comprar.jpg', 3),
(955, 321, N'https://www.techpowerup.com/review/galax-geforce-rtx-4070-ti-super-ex-white/images/title.jpg', 1),
(956, 321, N'https://khanhlinhpc.vn/hinh-anh/san-pham/4070ti-super-exg-w-01.png', 2),
(957, 321, N'https://kccshop.vn/media/product/250-7485-vga-galax-geforce-rtx-4070-ti-super-ex-gamer-white-1-click-oc-07.png', 3),
(958, 322, N'https://assets.vinhpici.vn/card-man-hinh-powercolor-hellhound-amd-radeon-rx-7900-xtx-24gb-gddr6-7/1080.webp', 1),
(959, 322, N'https://songphuong.vn/Content/uploads/2022/12/VGA-PowerColor-Hellhound-Radeon-RX-7900-XT-20GB-GDDR6-songphuong.vn-04.jpg', 2),
(960, 322, N'https://m.media-amazon.com/images/I/71tv3YrVPKL._AC_.jpg', 3),
(961, 323, N'https://assets.vinhpici.vn/card-man-hinh-sapphire-nitro-amd-radeon-rx-7800-xt-16gb/1080.webp', 1),
(962, 323, N'https://mygear.io.vn/media/product/4504-sapphire-nitro--amd-radeon-rx-7800-xt-gaming-oc-16gb-5.jpg', 2),
(963, 323, N'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-meuw650t6zuse1', 3),
(964, 324, N'https://cdn.prod.website-files.com/5d1911406ad3cbdb9924a753/639736d157cbd6c4d7548bdf_Box_Mockup_RX_7900_XTX_100a.jpg', 1),
(965, 324, N'https://m.media-amazon.com/images/I/61o+vHSp9ML._AC_.jpg', 2),
(966, 324, N'https://assets-global.website-files.com/5d1911406ad3cbdb9924a753/639736d87941b951a71777a8_04.jpg', 3),
(967, 325, N'https://nguyencongpc.vn/media/product/26203-z5083848747010_6a54313b46a91263744bc169459935bf_14_11zon.jpg', 1),
(968, 325, N'https://www.colorful.com.cn/content/upload/form/102/202404/93c5fbee-b40d-43b0-8054-7f6b3b61fc74.jpg', 2),
(969, 325, N'https://songphuong.vn/Content/uploads/2024/01/VGA-Colorful-RTX-4070-SUPER-Ultra-W-OC-V-5.jpg', 3),
(970, 326, N'https://pg.asrock.com/Graphics-Card/photo/Radeon%20RX%207700%20XT%20Phantom%20Gaming%2012GB%20OC(L2).png', 1),
(971, 326, N'https://media.ldlc.com/r1600/ld/products/00/06/06/20/LD0006062057.jpg', 2),
(972, 326, N'https://shop.by/images/asrock_radeon_rx_7700_xt_phantom_gaming_12gb_oc_rx7700xt_pg_12go_3.webp', 3),
(973, 327, N'https://hanoicomputercdn.com/media/product/44444_hdd_seagate_barracuda_2tb.jpg', 1),
(974, 327, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lx9gjkbdulln44', 2),
(975, 327, N'https://pcmarket.vn/media/product/7994_st2000dm005__1_.jpg', 3),
(976, 328, N'https://product.hstatic.net/200000837185/product/hddpcwesterndigitalblue2tb3.5-7200rpm256mbcache-wd20ezbx-_bb80957427454f0c8218a4cdf49e4e9b_master.png', 1),
(977, 328, N'https://phucanhcdn.com/media/product/21047_wd20ezaz_ha1.jpg', 2),
(978, 328, N'https://product.hstatic.net/200000722513/product/gearvn-hdd-wd-blue-2tb-7200rpm-1_fa7b6220ded04738a7fca1ff18185232_25ae485065a74e5f9b86cdf04470409a.png', 3),
(979, 329, N'https://www.saigongear.vn/upload/product/hdd-toshiba-3-6999.jpg', 1),
(980, 329, N'https://mega.com.vn/upload/files/Linhkiennew/HDD/HDTO0046/hdd-pc-2tb-toshiba-p300-35-inch-2.webp', 2),
(981, 329, N'https://phuongtin.vn/wp-content/uploads/2025/12/HDD-Toshiba-P300-2TB-3.5-inch-SATA-III-256MB.jpg', 3),
(982, 330, N'http://anphuhungnghean.vn/resources/upload/images/NEWS/Product/2023/6/1_6719f.jpg', 1),
(983, 330, N'https://longhungpc.vn/media/product/503-thi---t-k----ch--a-c---t--n.webp', 2),
(984, 330, N'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mmqy5y2180zm66', 3),
(985, 331, N'https://xuepc.vn/media/product/10294-o-cung-western-digital-red-plus-4tb-3-5-inch-128mb-cache-5400rpm-wd40efzz.jpg', 1),
(986, 331, N'https://western.com.vn/media/product/585_o_cung_wd_red_plus_4tb_wd40efzz_dung_cho_nas.jpg', 2),
(987, 331, N'https://bizweb.dktcdn.net/100/494/584/products/o-cung-western-digital-red-plus-4tb-3-5-inch-256mb-cache-5400rpm-wd40efpx.jpg?v=1776244726953', 3),
(988, 332, N'https://tetop.co.ke/wp-content/uploads/2023/07/Seagate-16TB-Exos-X18-7200-rpm-SATA-III-3.5-Internal-HDD.jpg', 1),
(989, 332, N'https://ryans.com/storage/products/main/seagate-exos-x18-16tb-35-inch-sata-7200rpm-21707561004.webp', 2),
(990, 332, N'https://cdn.bodanius.com/media/1/c2c208635_seagate-exos-x18-enterprise-hdd-3.5-inch-18tb_x.jpg', 3),
(991, 333, N'https://phucanhcdn.com/media/product/27893_western_gold_wd8004fryz_ha1.jpg', 1),
(992, 333, N'https://content2.rozetka.com.ua/goods/images/big/454393851.jpg', 2),
(993, 333, N'https://www.maychuvina.com/wp-content/uploads/2023/05/WD_-GOLD_8TB-768x768.jpg', 3),
(994, 334, N'https://networkingbd.com/wp-content/uploads/2019/06/Toshiba-4TB-Hard-Disk.jpg', 1),
(995, 334, N'https://c1.neweggimages.com/ProductImage/22-149-627-V01.jpg', 2),
(996, 334, N'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/95/MTA-142614644/br-m036969-03305_toshiba-x300-4tb-hd-hdd-hardisk-internal-3-5-7200rpm_full04-253337c5.jpg', 3),
(997, 335, N'https://kccshop.vn/media/product/250-948-9192_hdd_western_caviar_black_1tb_7200rpm_sata3_6gbs_64mb_cache_01.jpg', 1),
(998, 335, N'https://hanoicomputercdn.com/media/product/9192_hdd_western_caviar_black_1tb_7200rpm_sata3_6gbs_64mb_cache_001.jpg', 2),
(999, 335, N'https://hugotech.vn/wp-content/uploads/wd_1tb_wd1003fzex-3_copy_master.jpg', 3),
(1000, 336, N'http://www.technokomputerbali.com/img/item/231021154105.jpg', 1);
INSERT INTO product_images (id, product_id, image_url, display_order) VALUES
(1001, 336, N'https://enssecurity.com/wp-content/uploads/2023/07/C-HDD4000-VX-v2.jpg', 2),
(1002, 336, N'https://down-vn.img.susercontent.com/file/0168b356a2ef605797a8b55ecc110ce5', 3),
(1003, 337, N'https://bizweb.dktcdn.net/thumb/grande/100/503/272/products/nguon-may-tinh-corsair-rm750e-750w-1-768x768.jpg?v=1713514022117', 1),
(1004, 337, N'https://product.hstatic.net/200000722513/product/earvn-nguon-may-tinh-corsair-rm750e-atx-3.0-80-plus-gold-full-modula-1_5cd29a9f71ef4d18b2dcc67481d01eb0_master.png', 2),
(1005, 337, N'https://www.precio-calidad.com.ar/wp-content/uploads/2023/09/CP-9020262-AR-2.jpg', 3),
(1006, 338, N'https://product.hstatic.net/1000361104/product/1_355e29b2bbb04ada99214755c5781e54_master.jpg', 1),
(1007, 338, N'https://storage-asset.msi.com/global/picture/apluscontent/feature/1685343055.jpeg', 2),
(1008, 338, N'https://progenix.co.za/image/cache/catalog/psu/msi/mag-a750gl-pcie/msi-mag-a750gl-0-800x800-0.jpg', 3),
(1009, 339, N'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/g/i/gigabyte-gp-ud850gm-pg5-1.jpg', 1),
(1010, 339, N'https://phucanhcdn.com/media/product/51983_pow_gig_ud850gmpg5_4.jpg', 2),
(1011, 339, N'https://nvs.tn-cdn.net/2023/09/nguon-may-tinh-gigabyte-850w-ud850gm-pg5-8.jpg', 3),
(1012, 340, N'https://xuepc.vn/media/product/10324-nguon-asus-tuf-gaming-750b-evo-750w-80-plus-bronze-full-modular.jpg', 1),
(1013, 340, N'https://nvs.tn-cdn.net/2026/03/asus-tuf-gaming-750w-bronze-evo-3.jpg', 2),
(1014, 340, N'https://mygear.io.vn/media/product/9907-nguon-may-tinh-asus-tuf-gaming-bronze-evo-750w-80-plus-bronze-3.png', 3),
(1015, 341, N'https://hanoicomputercdn.com/media/lib/12-04-2021/ngunmytnhcoolermastermwegold850-v2850w03.jpg', 1),
(1016, 341, N'https://m.media-amazon.com/images/I/61jUyI3aDrL._AC_SL1280_.jpg', 2),
(1017, 341, N'https://product.hstatic.net/200000420363/product/nguon-may-tinh-cooler-master-mwe-gold-850---v2_828ff345380c4c5c93c4f2b4edc8f5f8_master.jpg', 3),
(1018, 342, N'https://assets.vinhpici.vn/nguon-deepcool-pl750d-750w-atx-3-0-80-plus-bronze/1080.webp', 1),
(1019, 342, N'https://phucanhcdn.com/media/product/61221_nguon_may_tinh_deepcool_pl750d_750w_80_plus_bronze_atx_3_0_pcie_5_3.jpg', 2),
(1020, 342, N'https://phucanhcdn.com/media/product/61221_nguon_may_tinh_deepcool_pl750d_750w_80_plus_bronze_atx_3_0_pcie_5_2.jpg', 3),
(1021, 343, N'http://www.technokomputerbali.com/img/item/201201111337.jpg', 1),
(1022, 343, N'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mjaumw8wd1c59d', 2),
(1023, 343, N'https://minhancomputercdn.com/media/product/5846_ngu___n_m__y_t__nh_super_flower_leadex_iii_gold_argb_850w_80_plus_gold__white__0.jpg', 3),
(1024, 344, N'https://img.lazcdn.com/g/p/a55f2beca5e25fccaa8c429a122cbe72.jpg_720x720q80.jpg', 1),
(1025, 344, N'https://img.pccomponentes.com/articles/1080/10805138/1791-seasonic-focus-gx-850-atx30-850w-80-plus-gold-modular.jpg', 2),
(1026, 344, N'https://img.pccomponentes.com/articles/1080/10805138/4342-seasonic-focus-gx-850-atx30-850w-80-plus-gold-modular-especificaciones.jpg', 3),
(1027, 345, N'https://media.karousell.com/media/photos/products/2023/4/7/fsp_hydro_g_pro_850w_full_modu_1680880099_0e6bafa1_progressive', 1),
(1028, 345, N'https://c1.neweggimages.com/MPS/SellerPortal/AplusContent/7a0af92c975120990d5d27c1bcb6d260e8bdc0d348f0e39c1c1d207669049e9f.jpg', 2),
(1029, 345, N'https://down-id.img.susercontent.com/file/id-11134207-7qul7-lg4w05l6lqid79', 3),
(1030, 346, N'https://hoanghapccdn.com/media/product/6327_toughpower_gf_a3_850w_ha3.jpg', 1),
(1031, 346, N'https://hanoicomputercdn.com/media/product/81083_ngu___n_thermaltake_toughpower_gf_a3_850w__5_.jpg', 2),
(1032, 346, N'https://tcgonline.com.au/wp-content/uploads/2023/06/Thermaltake-Toughpower-GF-A3-80-Gold-ATX-3.0-Modular-Power-Supply.jpg', 3),
(1033, 347, N'https://i5.walmartimages.com/seo/NZXT-H6-FLOW-RGB-Compact-Dual-Chamber-Mid-Tower-Airflow-Case-Black-CC-H61FB-R1_78041cc9-edc7-47ae-b5cf-10e817a05f42.2653da27220992969b1da2966863037d.jpeg', 1),
(1034, 347, N'https://tandoanh.vn/wp-content/uploads/2023/11/NZXT-H6-Flow-RGB-Matte-Black-H3.jpg', 2),
(1035, 347, N'https://mt-tecno.com/wp-content/uploads/2024/03/CAS-NZXT-CC-H61FB-R1-RGB.jpg', 3),
(1036, 348, N'https://eezepc.com/wp-content/uploads/2024/07/lianli-1.webp', 1),
(1037, 348, N'https://os-jo.com/image/cache/catalog/products/cases/O11VW-White/lian-li-o11-vision-build-white-ezgif.com-webp-to-jpg-converter-1200x1200.jpg', 2),
(1038, 348, N'https://ax.com.kw/app/uploads/2024/03/O11_Vision_06.webp', 3),
(1039, 349, N'https://assets.corsair.com/image/upload/c_pad,q_auto,h_1024,w_1024,f_auto/products/Cases/base-4000d-config/Gallery/4000D_BLACK_01.webp', 1),
(1040, 349, N'https://m.media-amazon.com/images/I/71lKUIIkZWL._AC_.jpg', 2),
(1041, 349, N'https://m.media-amazon.com/images/I/81NyR5EERBL.jpg', 3),
(1042, 350, N'https://c1.neweggimages.com/productimage/nb640/11-970-005-14.png', 1),
(1043, 350, N'https://www.scan.co.uk/images/infopages/montech/case/KING_95/PRO/Black/zenith.png', 2),
(1044, 350, N'https://i5.walmartimages.com/seo/MONTECH-KING-95-PRO-Dual-Chamber-ATX-Mid-Tower-PC-Gaming-Case-High-Airflow-Toolless-Panels-Sturdy-Curved-Tempered-Glass-Front-Six-ARGB-PWM-Fan-Pre-in_114042a6-0dab-4e6b-b06a-c76edd8b51d3.dfc399c4337bb7d22b5b751c35cad8cf.jpeg', 3),
(1045, 351, N'https://advanti.com/images/product/71GUurU8sPL._AC_SL1500_.jpg', 1),
(1046, 351, N'https://advanti.com/images/product/71ked3m3yQL._AC_SL1500_.jpg', 2),
(1047, 351, N'https://m.media-amazon.com/images/I/71GUurU8sPL._SL1500_.jpg', 3),
(1048, 352, N'https://www.techstoreltd.com/images/thumbs/0013467_antec-c8-270-view-dual-chamber-full-tower-gaming-pc-case-black_800.jpeg', 1),
(1049, 352, N'https://xpert.mt/images/thumbs/0013468_antec-c8-270-view-dual-chamber-full-tower-gaming-pc-case-black_500.jpeg', 2),
(1050, 352, N'https://minhancomputercdn.com/media/product/14362_83475_vo_case_antec_c8_black_e_atx_mau_den_015.jpg', 3),
(1051, 353, N'https://mygear.io.vn/media/product/9798-vo-case-fractal-design-pop-xl-air-rgb-black-tg-clear-1.png', 1),
(1052, 353, N'https://mygear.io.vn/media/product/9794-vo-case-fractal-design-pop-air-rgb-black-tg-clear-1.png', 2),
(1053, 353, N'https://mygear.io.vn/media/product/9794-vo-case-fractal-design-pop-air-rgb-black-tg-clear-2.png', 3),
(1054, 354, N'https://www.tncstore.vn/media/product/9099-vo-case-deepcool-ch560-digital-3.jpg', 1),
(1055, 354, N'https://pcx.vn/uploads/auto/2026/04/1776672416806-6a71e019-fb8c-4871-b6be-887832440afe.jpg', 2),
(1056, 354, N'https://hoanghapccdn.com/media/product/4641_ch560_digital_black_ha1.jpg', 3),
(1057, 355, N'http://kccshop.vn/media/product/250-5865-1.jpg', 1),
(1058, 355, N'https://nvs.tn-cdn.net/2023/08/vo-case-xigmatek-endorphin-ultra-arctic-6.jpg', 2),
(1059, 355, N'https://xuepc.vn/media/product/3055-endorphin-ultra-arctic-------------02.jpg', 3),
(1060, 356, N'https://phanteks.com/wp-content/uploads/2024/03/NV5-B1.webp', 1),
(1061, 356, N'https://img.overclockers.co.uk/images/CA-0CB-PT/c07c3012996ed0f5581ef2ce2d08b8f1.jpg?auto=compress%2Cformat&fit=fill&fill-color=fff&q=70&fill=solid&w=840&h=840', 2),
(1062, 356, N'https://img.overclockers.co.uk/images/CA-0CB-PT/2fc735841336acf8d4198edbe04a0929.jpg?auto=compress%2Cformat&fit=fill&fill-color=fff&q=70&fill=solid&w=840&h=840', 3),
(1063, 357, N'https://giahung.vn/uploads/files/Anh-san-Pham/T%E1%BA%A3n%20nhi%E1%BB%87t%20cpu/T%E1%BA%A3n%20nhi%E1%BB%87t%20kh%C3%AD%20Themalright%20Peerless%20Assassin%20120%20SE%20LED%20ARGB-01.jpg', 1),
(1064, 357, N'https://product.hstatic.net/1000361104/product/1_29bb5a16a5bc42e3a5fb68081e7e6531_master.jpg', 2),
(1065, 357, N'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mmh5we45lp8o66', 3),
(1066, 358, N'https://truonggiang.vn/wp-content/uploads/2024/02/tan-nhiet-deepcool-ak400-digital-argb.png', 1),
(1067, 358, N'https://product.hstatic.net/200000420363/product/deepcool-ak400-digital-digital_1a29672f9455490686f5c03cc43dba45_master.png', 2),
(1068, 358, N'https://philong.com.vn/media/lib/22-06-2023/tan-nhiet-khi-cpu-deepcool-ak400-digital-black-r-ak400-bkadmn-g-phi-long1.jpg', 3),
(1069, 359, N'https://halinhcomputer.vn/uploads/images/web-halinh-new/linh-kien-le/tan/nhd15b.png', 1),
(1070, 359, N'https://m.media-amazon.com/images/I/91t48GBv8TL._SL1500_.jpg', 2),
(1071, 359, N'https://sp-one.vn/Content/uploads/2021/05/Noctua-NH-D15-Chromax-Black-songphuong.vn_-scaled-e1606969667947.jpg', 3),
(1072, 360, N'https://product.hstatic.net/1000262653/product/z4299420219273_a5ec416ea439efe53bef585d84e05940_ce27aafbb5b0445eae92c673541f9fa7_master.jpg', 1),
(1073, 360, N'http://kenhtinhoc.vn/wp-content/uploads/2024/01/tan-nhiet-khi-id-cooling-se-224-xt-argb-v2-1.jpg', 2),
(1074, 360, N'http://kenhtinhoc.vn/wp-content/uploads/2024/01/tan-nhiet-khi-id-cooling-se-224-xt-argb-v2-4.jpg', 3),
(1075, 361, N'https://a.storyblok.com/f/281110/1500x1500/048c77f49a/hyper-622-halo-black-01-gallery-05.png/m/960x0/smart', 1),
(1076, 361, N'https://files.coolermaster.com/og-image/hyper-622-halo-black-1200x630.jpg', 2),
(1077, 361, N'https://a.storyblok.com/f/281110/1500x1500/bcadf881cb/hyper-622-halo-black-01-gallery-01.png/m/960x0/smart', 3),
(1078, 362, N'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mhblj3oup2q347', 1),
(1079, 362, N'https://hanoicomputercdn.com/media/lib/31-08-2023/cr-1000evoargb9.png', 2),
(1080, 362, N'https://jonsbo.vn/wp-content/uploads/2025/06/a12-768x768.jpg', 3),
(1081, 363, N'https://hocostore.vn/storage/uploads/tenants/21/products/20260613_043441_da1f86bb.png.webp', 1),
(1082, 363, N'http://hmpcstore.com/admin/uploads/Tan-nhiet-khi-Thermalright-Phantom-Spirit-120-EVO-Den-2-Thap/7-2_6bd8c70da83d4ce8acabc644362199f2_master.webp', 2),
(1083, 363, N'https://mygear.io.vn/media/lib/10-12-2025/tan-nhiet-khi-thermalright-phantom-spirit-120-evo7.png', 3),
(1084, 364, N'https://m.media-amazon.com/images/I/71Zvkf1gx9L._AC_.jpg', 1),
(1085, 364, N'https://hoanghapccdn.com/media/product/1527_be_quiet_dark_rock_pro_tr4_02_min.jpg', 2),
(1086, 364, N'https://images.novatech.co.uk/bequiet-bk036_extra4.jpg', 3),
(1087, 365, N'https://computerorbit.com/cdn/shop/files/PEERLESSASSASSIN120DIGITALARGBBLACK_700x700.jpg?v=1734787148', 1),
(1088, 365, N'https://maytinhdalat.vn/Images/Product/maytinhdalat_tan-nhiet-khi-deepcool-ag620-argb-dual-tower1-full.jpeg', 2),
(1089, 365, N'https://m.media-amazon.com/images/I/71mARDGfJDL._SL1500_.jpg', 3),
(1090, 366, N'https://www.tncstore.vn/media/product/250-11142-tnc-store-tan-nhiet-nuoc-valkyrie-vk-b360-argb-w--6-.jpg', 1),
(1091, 366, N'http://product.hstatic.net/200000475459/product/screenshot_2023-03-04_141535_aaf5b44034b84a1cade4da9360c7ba3e_grande.png', 2),
(1092, 366, N'https://kccshop.vn/media/product/250-9174-screenshot-2024-09-12-134303.png', 3),
(1093, 367, N'https://content.ibuypower.com/cdn-cgi/image/width=3840,format=auto,quality=75/https://content.ibuypower.com/Images/Components/28452/LIANLI-120MM-SL-INFINITY-MIRROR-2400.png?v=b2a1b401da61a19546be3df626a3af0838887eb1', 1),
(1094, 367, N'https://cdn.awsli.com.br/2500x2500/2557/2557636/produto/20241949295e5b8caec.jpg', 2),
(1095, 367, N'https://product.hstatic.net/200000522285/product/_fan_ghep_noi_khong_day__toc_2100rpm__pwm__fan_case_sl120_tpassionvn_2_e39b663fd8c8437dab2a555fb8aa6a67.jpg', 3),
(1096, 368, N'https://media.ldlc.com/r1600/ld/products/00/06/04/88/LD0006048835.jpg', 1),
(1097, 368, N'https://kccshop.vn/media/product/250-6393-9.png', 2),
(1098, 368, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/fan-case-corsair-icue-link-qx120-rgb-120mm-white-co-9051005-ww-4-3cefc139-9197-4246-ba12-6e062c4b2fa8.jpg?v=1754585319693', 3),
(1099, 369, N'https://media.ldlc.com/r1600/ld/products/00/06/01/35/LD0006013533.jpg', 1),
(1100, 369, N'https://assets.vinhpici.vn/quat-tan-nhiet-nzxt-f120-rgb-duo-triple-pack-black/1080.webp', 2),
(1101, 369, N'https://files.ekmcdn.com/292980/images/nzxt-f120-rgb-duo-120mm-triple-pack-black-(4)-2512-p.png?v=EAB9F13B-4AB4-495C-BBB2-62BA27961A50', 3),
(1102, 370, N'https://m.media-amazon.com/images/I/61uQOtS-heL.jpg', 1),
(1103, 370, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltf6s8b4fdai9f', 2),
(1104, 370, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltf6s8b3vpca81', 3),
(1105, 371, N'https://cdn2.electronicscrazy.sg/Productimage/2023-07-0911-18-3955.webp', 1),
(1106, 371, N'https://down-id.img.susercontent.com/file/68a51ed58b342baf64efe4868f0f1d81', 2),
(1107, 371, N'https://media.karousell.com/media/photos/products/2023/3/26/in_stock_deepcool_fc120_black__1679837289_fc1824fe', 3),
(1108, 372, N'https://technicstore.net/wp-content/uploads/2023/04/D30-120-BLACK-REVERSE-TRIPLE-2.jpg', 1),
(1109, 372, N'https://technicstore.net/wp-content/uploads/2023/04/D30-120-BLACK-REGULAR-TRIPLE-2.jpg', 2),
(1110, 372, N'https://media.ldlc.com/r1600/ld/products/00/06/05/27/LD0006052717.jpg', 3),
(1111, 373, N'https://cf.shopee.vn/file/4d6cc707db0b59188777d35cc20ebab1', 1),
(1112, 373, N'https://www.tncstore.vn/media/product/3681-tan-nhiet-khi-id-cooling-12025-rgb.jpg', 2),
(1113, 373, N'https://cf.shopee.vn/file/092eede6486c1dd9e9b7acb78ec48c59', 3),
(1114, 374, N'https://truonggiang.vn/wp-content/uploads/2022/12/Fan-Cooler-Master-MasterFan-MF120-Halo-White-Kit-3-Fan.jpg', 1),
(1115, 374, N'https://nguyencongpc.vn/photos/17/masterfan-mf120-halo-3in1-main.png', 2),
(1116, 374, N'https://us.maxgaming.com/bilder/artiklar/zoom/31355_1.jpg?m=1719836206', 3),
(1117, 375, N'https://cdn.mwave.com.au/images/400/antec_fusion_120mm_argb_pwm_black_case_fan_3_pack_with_argb_controller_ac57639.jpg', 1),
(1118, 375, N'https://www.thegadgetclinic.co.uk/wp-content/uploads/2024/07/FAANT-FUSI1203PK-lg.jpg', 2),
(1119, 375, N'https://www.intelec.co.cr/wp-content/uploads/2023/11/0-761345-57010-7.jpg', 3),
(1120, 376, N'https://images-na.ssl-images-amazon.com/images/I/71GYXxnfw6L.jpg', 1),
(1121, 376, N'https://img.watercoolinguk.co.uk/2026/02/LUMT-025.jpg', 2),
(1122, 376, N'https://plecom.imgix.net/iil-401565-668705.jpg?fit=fillmax&fill=solid&fill-color=ffffff&auto=format&w=1000&h=1000', 3),
(1123, 377, N'https://khothietbi.vn/image/product/large/ban-phim-co-akko-3087-silent-1752832686.jpg', 1),
(1124, 377, N'https://cellphones.com.vn/media/catalog/product/b/a/ban-phim-co-akko-3087-v2-ds-ocean-star.png', 2),
(1125, 377, N'https://cdn2.cellphones.com.vn/x/media/catalog/product/b/a/ban-phim-co-akko-3087-silent-1.png', 3),
(1126, 378, N'https://product.hstatic.net/200000837185/product/2_cde9d36d3bd3485bafabeae71c29a179_master.png', 1),
(1127, 378, N'https://cdn.shopify.com/s/files/1/0059/0630/1017/files/V1-Max-8.jpg?v=1699337298', 2),
(1128, 378, N'https://cdn.shopify.com/s/files/1/0059/0630/1017/t/5/assets/keychronv1custommechanicalkeyboard22-1657877832593.jpg?v=1657877834', 3),
(1129, 379, N'https://img.lazcdn.com/g/p/c3f2637ee2b7e865f4c5dbd36a5b4b99.jpg_720x720q80.jpg', 1),
(1130, 379, N'https://bizweb.dktcdn.net/100/466/510/products/b-n-ph-m-c-royal-kludge-rk84-tr-ch-b-n-ph-m-c-jpg-q90-jpg-1.jpg?v=1673945368923', 2),
(1131, 379, N'https://cf.shopee.vn/file/da4c626a7a024e2402e1ff040bcd33ad', 3),
(1132, 380, N'https://tsunamigaming.vn/wp-content/uploads/2024/02/ban-phim-co-fl-esports-fl980-sam-cercis-tsunamigaming-h2.jpg', 1),
(1133, 380, N'https://cdn.shopify.com/s/files/1/0631/9590/6271/files/1_2fdf928f-fe6b-4a3c-86ff-2fcac3806399.jpg?v=1661803807', 2),
(1134, 380, N'https://gearzone.vn/wp-content/uploads/2023/02/fl-esports-fl980-v2-fl980v2-mach-xuoi-3mode-20-768x768.jpg', 3),
(1135, 381, N'https://cf.shopee.vn/file/vn-11134207-7qukw-lhifz7wy44g5dc', 1),
(1136, 381, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lp7jb3cxex5nd6', 2),
(1137, 381, N'https://www.monsgeek.com/wp-content/uploads/2024/10/M1W-V3-HE-Black-Silverpng.png', 3),
(1138, 382, N'https://manuals.plus/wp-content/uploads/2023/11/EPOMAKER-RT100-Mechanical-Gaming-Keyboard-FEA-2.png', 1),
(1139, 382, N'https://img.lazcdn.com/g/p/84c895d5e22c561b74a65fd32c516937.png_720x720q80.png', 2),
(1140, 382, N'https://m.media-amazon.com/images/I/61+Zd7jJ7AL._AC_SL1500_.jpg', 3),
(1141, 383, N'https://owlgaming.vn/wp-content/uploads/2024/01/ban-phim-co-ducky-one-3-daybreak-sf-65.jpg', 1),
(1142, 383, N'https://mechanicalkeyboards.com/cdn/shop/files/6295-RKXAU-One-3-Daybreak.jpg?v=1707350705&width=2048', 2),
(1143, 383, N'https://product.hstatic.net/1000129940/product/ban-phim-ducky-one-3-daybreak-rgb-hotswap-6_a4888e35af1c4e0a9958884eee573f31_master.jpg', 3),
(1144, 384, N'https://product.hstatic.net/1000262653/product/1_-_copy_-_copy__2__-_copy_9d255f4c2b0f4d88a9658889b7e4bb83_master.jpg', 1),
(1145, 384, N'https://phongvu.vn/cong-nghe/wp-content/uploads/2024/06/ban-phim-co-va-ban-phim-gia-co-7-1344x840.jpg', 2),
(1146, 384, N'https://photo2.tinhte.vn/data/attachment-files/2022/02/5857652_varmilova87m_2.jpg', 3),
(1147, 385, N'https://ae01.alicdn.com/kf/S7895a3515780430eae0a4cc7d06e77fdB.jpg', 1),
(1148, 385, N'https://m.media-amazon.com/images/I/71b9I85Y3lL._AC_SL1500_.jpg', 2),
(1149, 385, N'https://down-my.img.susercontent.com/file/my-11134207-7r98y-lp6rm1zz2tvc07', 3),
(1150, 386, N'https://m.media-amazon.com/images/S/aplus-media-library-service-media/23afc7a0-27ae-4702-9816-82521db15ee8.__CR0,0,970,600_PT0_SX970_V1___.png', 1),
(1151, 386, N'https://m.media-amazon.com/images/I/61oOn02s3HS._AC_SL1500_.jpg', 2),
(1152, 386, N'https://www.womiershop.com/wp-content/uploads/2022/12/womier-66-keys-gamer-keyboard-hot-swappable-gateron-switch-60-rgb-backlit-tyce-c-wired-mechanical-keyboard-for-pc-ps4-xbox-2.jpg', 3),
(1153, 387, N'https://minhancomputercdn.com/media/product/8757_chu___t_razer_basilisk_v3.jpg', 1),
(1154, 387, N'https://hanoicomputercdn.com/media/product/63915_chuot_razer_basilisk_v3_rz01_04000100_r3m1_01.JPG', 2),
(1155, 387, N'https://www.tncstore.vn/media/product/8824-razer-basilisk-v3---rz01-04000100-r3m1-4.jpg', 3),
(1156, 388, N'https://zi-jo.com/image/cache/catalog/MARVO/g304-black-original-cac-550x550h.jpg.webp', 1),
(1157, 388, N'https://cf.shopee.vn/file/sg-11134201-22110-owkn28h7w0jve8', 2),
(1158, 388, N'https://anhtienpc.com/media/product/936_san_pham_chuot_logitech_g304_lightspeed_wireless__2_.jpg', 3),
(1159, 389, N'https://cdn.store-assets.com/s/824673/i/61271910.jpeg', 1),
(1160, 389, N'https://cdn.store-assets.com/s/824673/i/69412655.jpeg', 2),
(1161, 389, N'https://cdn.iset.io/assets/00665/produtos/5330/mouse-gamer-pulsar-x2v2-medium-green-fe-edition-4k-wireless-ultralight-gaming-53g-size-2-01.png', 3),
(1162, 390, N'https://down-id.img.susercontent.com/file/sg-11134275-821dh-mhb3t7bz1szwb7', 1),
(1163, 390, N'https://img.lazcdn.com/g/p/76d8dab5358f74db5ae200e0d7c10bf9.jpg_720x720q80.jpg', 2),
(1164, 390, N'https://down-my.img.susercontent.com/file/cn-11134207-7r98o-lwjtm9ikf879f1', 3),
(1165, 391, N'https://cdn.store-assets.com/s/824673/i/62363110.jpeg', 1),
(1166, 391, N'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/102/MTA-168055184/lamzu_lamzu_atlantis_og_v2_pro_wireless_superlight_gaming_mouse_full05_tiav86d6.jpg', 2),
(1167, 391, N'https://down-my.img.susercontent.com/file/my-11134207-7qula-lgg71v4x0peybf', 3),
(1168, 392, N'https://limosa.vn/wp-content/uploads/2023/05/cac-loai-chuot-may-tinh-2.jpg', 1),
(1169, 392, N'https://khoinguonsangtao.vn/wp-content/uploads/2022/11/gaming-mouse.jpg', 2),
(1170, 392, N'https://storage.googleapis.com/teko-gae.appspot.com/media/image/2023/11/8/da022fd9-4c98-446b-b2b7-59f488b7ca87/chuot-co-day.jpg', 3),
(1171, 393, N'https://down-vn.img.susercontent.com/file/cn-11134208-7r98o-loq9to8xu10163', 1),
(1172, 393, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/466/510/products/2875711d-73c8-4009-ac97-03ba0fb9d3b7-1693989197508.jpg?v=1694080500800', 2),
(1173, 393, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lqx57i0hhgw404', 3),
(1174, 394, N'https://ag4tech.com/wp-content/uploads/2026/02/WhatsApp-Image-2026-02-05-at-09.07.58.jpeg', 1),
(1175, 394, N'https://static-01.daraz.com.np/p/9e60a398e7e0f92c6b4d09eedd813177.jpg', 2),
(1176, 394, N'https://static-01.daraz.com.bd/p/452f6fbc5a21a1b7a99100bbff87efae.jpg', 3),
(1177, 395, N'https://os-jo.com/image/cache/catalog/products/Accessories/Mouse/RIVAL-3-Wireless/a89f866daa5b7f847d234e3beb4d6582-650x400.jpg', 1),
(1178, 395, N'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/s/t/steelseries-62521-rival-3-04.jpg', 2),
(1179, 395, N'https://media.steelseriescdn.com/thumbs/filer_public/df/07/df0714c7-4727-48f2-998f-7103f171bfba/buyimg_rival3_001.jpg__1850x800_q100_crop-scale_optimize_subsampling-2.jpg', 3),
(1180, 396, N'https://nextrift.com/wp-content/uploads/2024/03/rog-harpe-ace-aim-lab-edition-review-2.jpg', 1),
(1181, 396, N'https://file.hstatic.net/200000722513/file/rog_harpe_ace_aim_lab_edition.pt01_2e89b19c5fad4918bf3cd2a00db8caab.jpg', 2),
(1182, 396, N'https://cdn.hstatic.net/products/1000262653/chuot-gaming-asus-rog-harpe-ace__4__e02ddf26b09b4380a25e210b25364a49_master.png', 3),
(1183, 397, N'https://cdn.shopify.com/s/files/1/0564/3612/9997/products/hyperx_cloud_ii_wireless_6_accessories_2048x2048.jpg?v=1655760985', 1),
(1184, 397, N'https://inkdtex.com/Image/Picture/HyperX/Tai-nghe-HyperX-Cloud-II-wireless-Red-2.jpg', 2),
(1185, 397, N'https://m.media-amazon.com/images/I/61e0+8QzVBL._AC_SL1500_.jpg', 3),
(1186, 398, N'https://cdn.hstatic.net/products/1000231532/tai_nghe_gaming_razer_blackshark_v2_x_ch_nh_h_ng_t_i_nshop_06ac9ee0b29d46818a830d94742375ce.jpg', 1),
(1187, 398, N'https://cdn.hstatic.net/products/1000231532/thi_t_k__si_u_nh__240g_v__d_m_tai_memory_foam__m__i_nshop_45e6c914ae254f748cea25162add8824_master.jpg', 2),
(1188, 398, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/tai-nghe-gaming-razer-blackshark-v2-x-9-7f274a73-3d6a-4105-88a2-5b0e06457f2a.jpg?v=1756454919110', 3),
(1189, 399, N'https://res.cloudinary.com/corsair-pwa/image/upload/f_auto,q_auto/v1/akamai/pdp/hs80/assets/images/white/HS80-carousel-image-5.jpg', 1),
(1190, 399, N'https://microless.com/cdn/products/7903c2d75ef2751bc39d8b1d24bd2c28-hi.jpg', 2),
(1191, 399, N'https://chaoscomputers.co.za/wp-content/uploads/2023/11/CA-9011236-AP1.jpg', 3),
(1192, 400, N'https://down-ph.img.susercontent.com/file/ph-11134207-7rasb-m6gmkzx8osu7d2', 1),
(1193, 400, N'https://cdn.hstatic.net/products/200000921511/bpstore-tai-nghe-logitech-g435-lightspeed-wireless-gaming__6__0d0fdaed75b94b158a87f4c5e369a235_1024x1024.png', 2),
(1194, 400, N'https://down-id.img.susercontent.com/file/id-11134207-7r98r-ltjr325d3v1ye9', 3),
(1195, 401, N'https://azaudio.vn/wp-content/uploads/2023/12/azaudio-steelseries-arctis-nova-7-wireless.jpg', 1),
(1196, 401, N'https://product.hstatic.net/200000722513/product/-steelseries-arctis-nova-7-wireless-2_9d4550b797c0427d9512b13880dc2144_304e421e19e645c3b52f97fc94d48670_master.jpg', 2),
(1197, 401, N'https://cdn.shopify.com/s/files/1/0355/8296/7943/products/arctis_nova_7_black_pdp_img_buy_04.png__1850x800_q100_crop-scale_optimize_subsampling-2_800x.jpg?v=1663759164', 3),
(1198, 402, N'https://i5.walmartimages.com/seo/EPOS-Audio-GSP-300-Closed-Acoustic-Gaming-Headset-Blue_2363a7e2-56e6-4865-a760-f03b04fa1782.b353dd1581791e17c4c700adba5d806a.jpeg', 1),
(1199, 402, N'https://htt.com.vn/datafiles/02-04-2024/thumb_17120290573591_tai-nghe-sennheiser-gsp-300.png', 2),
(1200, 402, N'https://www.tejar.pk/media/catalog/product/cache/3/image/9df78eab33525d08d6e5fb8d27136e95/s/e/sennheiser_epos_gsp_300_301_302_closed_acoustic_gaming_headset_-_tejar.jpg', 3),
(1201, 403, N'https://down-my.img.susercontent.com/file/5d5af64b5df88a315353445ce972b5b2', 1),
(1202, 403, N'https://img.lazcdn.com/g/p/4206b643fbf167cdceedd673f16ee758.png_720x720q80.png', 2),
(1203, 403, N'https://down-my.img.susercontent.com/file/d89107a647bf07e4fc14e448224ad8ae', 3),
(1204, 404, N'https://www.jbl.com/on/demandware.static/-/Sites-masterCatalog_Harman/default/dwb3336ae2/JBL_Quantum_400_Product%20Image_Hero%2002.png', 1),
(1205, 404, N'https://file.hstatic.net/1000356871/file/2_tai-nghe-chup-tai-gaming-jbl-quantum-400-tai-nghe-chup-tai-co-mic_c10b6b6d4b574c3589a9ee65d18ebf2c.jpg', 2),
(1206, 404, N'https://www.jbl.com/dw/image/v2/BFND_PRD/on/demandware.static/-/Sites-masterCatalog_Harman/default/dw6cf6878b/pdp/JBL_Quantum400_Lifestyle2.png?sw=904&sh=560', 3),
(1207, 405, N'https://philong.com.vn/media/product/29918-philong-tai-nghe-gaming-asus-rog-delta-s-wireless-1.jpg', 1),
(1208, 405, N'https://mygear.io.vn/media/product/9420-tai-nghe-gaming-overear-asus-rog-delta-s-wireless-2.jpg', 2),
(1209, 405, N'https://dlcdnwebimgs.asus.com/files/media/6A881975-EAF7-4666-BD57-CE6D402C3EC2/v2/img/kv/rog-delta-s-wireless.png', 3),
(1210, 406, N'https://www.eksa.in/cdn/shop/files/2_-10.png?v=1725616185', 1),
(1211, 406, N'https://down-ph.img.susercontent.com/file/ph-11134207-7r98o-lr3yg0tzyaf8ca', 2),
(1212, 406, N'https://ae01.alicdn.com/kf/S699b77a28c3f45c3972bf3338dbb138aN.jpg', 3),
(1213, 407, N'https://mygear.io.vn/media/product/10373-the-nho-sandisk-ultra-microsdhc-32gb-sdsqua4-032g-gn6mn--2-.jpg', 1),
(1214, 407, N'https://cf.shopee.co.th/file/1e440eeb00a10e201412365d35daacda', 2),
(1215, 407, N'https://hanoicomputercdn.com/media/product/31470_the_nho_sandisk_microsd_ultra_32gb_class_10_001.jpg', 3),
(1216, 408, N'http://giaiphapvanphong.vn/Image/Picture/SanDisk/SDSQQNR-064G-GN6IA.jpg', 1),
(1217, 408, N'https://down-ph.img.susercontent.com/file/ph-11134207-7rasg-m7c3g4398q5ue2', 2),
(1218, 408, N'https://upload.jaknot.com/2024/05/images/products/6e4fe9/original/sandisk-high-endurance-microsd-uhs-i-class-10-u3-100mbs-sdsqqnr.jpg', 3),
(1219, 409, N'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-ma2k1uyr5u9uf7', 1),
(1220, 409, N'https://giaiphapvanphong.vn/Image/Picture/SanDisk/SDSDXXU-064G-GN4IN.jpg', 2),
(1221, 409, N'https://mayanh9x.com/image/cache/catalog/san-pham/sandisk/sandisk-extreme-pro-64gb-200mb/sandisk-extreme-pro-64gb-200mb-gia-re-tan-binh-500x500.jpg', 3),
(1222, 410, N'https://bizweb.dktcdn.net/100/329/122/products/the-nho-microsdxc-samsung-evo-plus-2024-with-sd-adapter-64gb-03.jpg?v=1713867840947', 1),
(1223, 410, N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m1pa1c69bxz341', 2),
(1224, 410, N'https://bizweb.dktcdn.net/thumb/grande/100/490/762/products/29884-micro-sd-samsung-evo-plus-64gb-class-10-read-130mb-with-adapter-a6-jpg-v-1704787410667.jpg?v=1721661688340', 3),
(1225, 411, N'https://dntech.vn/uploads/images/2022/11/1667870843-single_product1-thenhosamsung128gb.jpg', 1),
(1226, 411, N'https://thuonggiado.vn/uploads/images/san_pham/the-nho-samsung-evo-plus-sdxc-128gb-2_1757659781.webp', 2),
(1227, 411, N'https://www.flashtrend.com.au/assets/full/MB-MC128GA.jpg?20221102100414', 3),
(1228, 412, N'https://product.hstatic.net/200000420363/product/tn_kt_64g_sdcs2-600x600_070b05ed11f04669b7f4c64accc7c9da_master_d9dfb419afac4f7eb7edf63fdb2c47b7_master.jpg', 1),
(1229, 412, N'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/h/the-nho-microsd-kingston-canvas-select-plus-64gb-sdcs3_3_.png', 2),
(1230, 412, N'https://http2.mlstatic.com/D_NQ_NP_836112-MLA89304656039_082025-O.webp', 3),
(1231, 413, N'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/h/the-nho-microsd-kingston-canvas-select-plus-256gb-sdcs3_2_.png', 1),
(1232, 413, N'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/h/the-nho-microsd-kingston-canvas-select-plus-256gb-sdcs3_3_.png', 2),
(1233, 413, N'https://songphuong.vn/Content/uploads/2025/09/Kingston-256GB-MicroSD-Canvas-Select-Plus-3.webp', 3),
(1234, 414, N'https://product.hstatic.net/200000863343/product/the-nho-sdxc-lexar-128gb-uhs-ii-1667x-250mb-s-scjuu_3e270e20e4ff4e72bb2df4b4c7fc1e45.jpg', 1),
(1235, 414, N'https://product.hstatic.net/200000863343/product/the-nho-sdxc-lexar-128gb-uhs-ii-1667x-250mb-s-y9ox2_1e5b8de150eb481a85ca222b37c09ccd.jpg', 2),
(1236, 414, N'https://kyma.vn/StoreData/images/Product/the-nho-sdxc-lexar-professional-1667x-uhs-ii-v60-128gb-250-120-mb-s.jpg', 3),
(1237, 415, N'https://cdn.hstatic.net/products/1000231532/6gb_lexar_cho_nintendo_switch_2_de_dang_su_dung_cam_vao_may_tu_ket_noi_cb9ec8d67f1a47318301dd643a69fff2.jpg', 1),
(1238, 415, N'https://cdn.hstatic.net/products/1000231532/256gb_lexar_cho_nintendo_switch_2_giao_nhanh_tan_nha_toan_quoc_gia_tot_aac8a232cd2b4f3c806d4c9bc2ff359e.jpg', 2),
(1239, 415, N'https://cdn.hstatic.net/products/1000231532/lexar_cho_nintendo_switch_2_giup_giam_tai_bo_nho_de_may_chay_nhanh_hon_69fa7bf5d0514124acbe1a4b310db64a.jpg', 3),
(1240, 416, N'https://cdn.hstatic.net/products/200000255977/_sony_sf-e64a_64gb_uhs-ii__d_c_270mbs__ch_nh_h_ng__l_m_ph_t_studio__2__613d24069eab41c5be59e80f8523a381_grande.jpg', 1),
(1241, 416, N'https://zshop.vn/images/detailed/115/Sony_64T2.jpg', 2),
(1242, 416, N'https://photoking.vn/upload/images/the-nho-sony-sdxc-64gb-270mbs-70-mbs-sf-m64-photoking-vn-01a.jpg', 3),
(1243, 417, N'https://product.hstatic.net/200000863343/product/the-nho-sony-128gb-sdxc-sf-m-series-tough-uhs-ii-277-150mb-s-o1xqe_e83b7a2bc0cc449f9e849480e6e53826.jpg', 1),
(1244, 417, N'https://product.hstatic.net/200000863343/product/the-nho-sony-128gb-sdxc-sf-m-series-tough-uhs-ii-277-150mb-s-ngsou_dd3c00ea697542e68c3a7921425ec1bc.jpg', 2),
(1245, 417, N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-man1fhovr53g0f', 3),
(1246, 418, N'https://musedigital.com/wp-content/uploads/micro_1000-24.jpg', 1),
(1247, 418, N'https://cdn2.cellphones.com.vn/200x/media/catalog/product/t/h/the-nho-microsd-kioxia-exceria-cl10-g2-256gb_1_.png', 2),
(1248, 418, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lvc3776ochgk8d', 3),
(1249, 419, N'https://static.onlinetrade.ru/img/users_images/315651/b/karta_pamyati_transcend_700s_64gb_sdxc_uhs_ii_u3_v90_285_180_mb_s_1601646550_1.jpg', 1),
(1250, 419, N'https://http2.mlstatic.com/D_NQ_NP_781756-MLA95650623519_102025-O.webp', 2),
(1251, 419, N'https://www.bhphotovideo.com/images/fb/transcend_ts64gsdc700s_64gb_sdxc_class3_uhs_ii_1431179.jpg', 3),
(1252, 420, N'https://images.teamgroupinc.com/products/card/microsd/high-endurance-card/msdxc/128gb_01.jpg', 1),
(1253, 420, N'https://m.media-amazon.com/images/I/81kOW5pTcfL.jpg', 2),
(1254, 420, N'https://m.media-amazon.com/images/S/aplus-media-library-service-media/fba4bf61-1244-4180-be1e-6e3523faa2c0.__CR0,0,800,600_PT0_SX800_V1___.jpg', 3),
(1255, 421, N'https://img.pchome.com.tw/cs/items/DGAG5FA900JRJLK/000001_1772012837.jpg', 1),
(1256, 421, N'https://haliti.com.vn/wp-content/uploads/2023/05/the-nho-prograde-digital-SDXC-UHS-II-V90-300R-512gb-haliti-01-600x600.jpg', 2),
(1257, 421, N'https://cdn.shopify.com/s/files/1/0672/3806/8470/files/ea27be2c-5177-4bac-bebb-842e3c66f24f.jpg?v=1709702511', 3),
(1258, 422, N'https://western.com.vn/media/product/397_o_cung_ssd_wd_my_passport_1tb_red__2_.jpg', 1),
(1259, 422, N'https://western.com.vn/media/product/250_397_o_cung_ssd_wd_my_passport_1tb_red__1_.jpg', 2),
(1260, 422, N'https://minhancomputercdn.com/media/product/11301_wd_my_passport_ssd_1tb_wdbagf0010brd_wesn_5.jpg', 3),
(1261, 423, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/wd-p50-02-42d56a0c-5309-4266-8a4a-720e3320e5e5.jpg?v=1615888619027', 1),
(1262, 423, N'https://phucanhcdn.com/media/lib/14-01-2022/westernblack500ha1.png', 2),
(1263, 423, N'https://phucanhcdn.com/media/product/45869_wd_black_p50_ha1.jpg', 3),
(1264, 424, N'https://www.maytinhphunggia.vn/media/product/29114_sua_o_cung_di_dong_hdd_wd_elements_portable_1tb_2_5_inch_usb_3_0.jpg', 1),
(1265, 424, N'https://smnet.vn/wp-content/uploads/2024/03/hdd-wd-elements-portable-1tb-wdbuzg0010bbk-wesn.png', 2),
(1266, 424, N'https://bizweb.dktcdn.net/thumb/large/100/592/668/products/da4bce1d-20cd-474d-976a-7851a9f6ebbc.png?v=1758460843700', 3),
(1267, 425, N'https://bizweb.dktcdn.net/thumb/grande/100/335/518/products/o-cu-ng-di-do-ng-hdd-wd-elements-portable-4tb-2-5.png?v=1736931018573', 1),
(1268, 425, N'https://product.hstatic.net/1000343056/product/2edb8e9049ac4704939edd9afcb9308c_115e3100bca24e088de6deebcce2f6f9_grande.jpg', 2),
(1269, 425, N'https://haiyenpc.vn/wp-content/uploads/2026/01/upload_65e4588efda8406f871d521629bddf80-1.jpg', 3),
(1270, 426, N'https://cdn2.cellphones.com.vn/x/media/catalog/product/o/-/o-cung-di-dong-ssd-samsung-t7-portable-1tb_3_.png', 1),
(1271, 426, N'https://pcngon.vn/wp-content/uploads/2025/07/O-cung-di-dong-SSD-Samsung-T7-Portable-1TB-Mau-xam.jpg', 2),
(1272, 426, N'https://hanoicomputercdn.com/media/product/54106_o_cung_gan_ngoai_ssd_samsung_t7_portable_1tb_den_11.jpg', 3),
(1273, 427, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/o-cung-di-dong-ssd-1tb-samsung-t9-2000mb-6-4fcefb57-66ff-4ee6-ac08-09300eab9ed6.jpg?v=1718353885613', 1),
(1274, 427, N'https://down-th.img.susercontent.com/file/th-11134201-7r98u-ln9h0reb7n2re5', 2),
(1275, 427, N'https://product.hstatic.net/200000722513/product/vn-portable-ssd-t9-mu-pg2t0b-ww__7__56a48d9a75464fb69f4efeaf0f7ffe2f_1024x1024.png', 3),
(1276, 428, N'https://hoanghapccdn.com/media/product/5125_sandisk_extreme_pro_portable_ha1.jpg', 1),
(1277, 428, N'https://th-test-11.slatic.net/p/606b57d5a7e6dd3e481aa6c97ff057ba.jpg', 2),
(1278, 428, N'https://hanoicomputercdn.com/media/product/58446_ssd_2tb_sandisk_extreme_portable_sdssde61_2t00_g25ss.jpg', 3),
(1279, 429, N'https://huyhoang.vn/uploads/o-cung-di-dong-hdd-seagate-one-touch-2tb-25-usb-30-den-stky2000400-2-386.jpg', 1),
(1280, 429, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lw81jc8av17f3a', 2),
(1281, 429, N'https://inkdtex.com/Image/Picture/Seagate/STKY2000400-DTEX-2.jpg', 3),
(1282, 430, N'https://vn-test-11.slatic.net/p/868515d19146955ce737b6e790eb468e.jpg', 1),
(1283, 430, N'https://huyhoang.vn/uploads/o-cung-di-dong-hdd-seagate-expansion-portable-1tb-25-usb-30-stkm1000400-3.jpg', 2),
(1284, 430, N'https://phuongtin.vn/wp-content/uploads/2025/09/o-cung-di-dong-hdd-seagate-phuong-tin-0930-4.jpg', 3),
(1285, 431, N'https://www.ocinside.de/media/uploads/crucial_x6_2tb_portable_ssd_1-600x588.jpg', 1),
(1286, 431, N'https://paksell.pk/cdn/shop/products/crucial-x6-2tb-portable-ssd-external-hard-drive-speed-upto-800mbs-382723.jpg?v=1691492290', 2),
(1287, 431, N'https://mesajil.com/wp-content/uploads/2022/10/31685-2.jpg', 3),
(1288, 432, N'https://tinhocthanhkhang.vn/media/product/2964-ssd-di-dong-2tb-crucial-x10-ct2000x10ssd9-2_15_11zon.webp', 1),
(1289, 432, N'https://bizweb.dktcdn.net/100/329/122/files/crucial-x10-pro-01.jpg?v=1690877363822', 2),
(1290, 432, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/external-ssd-crucial-x10-pro-usb-3-2-gen-2-type-c-2.jpg?v=1740452594627', 3),
(1291, 433, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/o-cung-di-dong-ssd-2tb-kingston-xs1000-1050mb-s-06.jpg?v=1741142443223', 1),
(1292, 433, N'https://cdn.24h.com.vn/upload/3-2024/images/2024-08-27/ava-1724758876-592-width740height495.jpg', 2),
(1293, 433, N'https://down-th.img.susercontent.com/file/th-11134201-7r98v-lobx39of2n768e', 3),
(1294, 434, N'https://m.media-amazon.com/images/I/71UUKDJ1wsL.jpg', 1),
(1295, 434, N'https://shipcom.vn/image/images/tan-nhiet-nuoc-aio-corsair-h100i-rgb-platinum/tan-nhiet-nuoc-aio-corsair-h100i-rgb-platium-1.png', 2),
(1296, 434, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/tan-nhiet-nuoc-aio-corsair-h100i-elite-capellix-xt-rgb-white.jpg?v=1743638381063', 3),
(1297, 435, N'https://bizweb.dktcdn.net/thumb/grande/100/329/122/products/tan-nhiet-nuoc-aio-corsair-icue-link-h100i-rgb-white-cw-9061005-ww.jpg?v=1743638717033', 1),
(1298, 435, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/tan-nhiet-nuoc-aio-corsair-icue-link-h100i-rgb-white-cw-9061005-ww-4.jpg?v=1743638717187', 2),
(1299, 435, N'https://mygear.io.vn/media/product/8502-tan-nhiet-nuoc-corsair-icue-link-h100i-rgb-white-3.png', 3),
(1300, 436, N'https://product.hstatic.net/200000680123/product/71920_kraken_240_rgb_050847ec8acf4724ab60a12671392f02_grande.jpg', 1),
(1301, 436, N'https://pcx.com.ph/cdn/shop/files/FAN-NZXT-KRAKEN-ELITE-240-RGB-BLK-W-LCD-V2-1.jpg?v=1738049864&width=600', 2),
(1302, 436, N'https://tandoanh.vn/wp-content/uploads/2025/06/NZXT-Kraken-Plus-240-V2-Black-H2.jpg', 3),
(1303, 437, N'https://phucanhcdn.com/media/product/52270_aio_nzxt_kraken_elite_360_rgb_black_2.jpg', 1),
(1304, 437, N'https://static.tandoanh.vn/wp-content/uploads/2025/06/NZXT-Kraken-Plus-360-RGB-V2-Black-H1.jpg', 2),
(1305, 437, N'https://mygear.io.vn/media/lib/04-11-2025/tan-nhiet-nuoc-nzxt-kraken-plus-360-rgb-black7.png', 3),
(1306, 438, N'https://sp-one.vn/Content/uploads/2025/01/h732__1__bcbaf3f88adf48ac90f9026ac35551cd_master.webp', 1),
(1307, 438, N'https://dlcdnwebimgs.asus.com/gain/84A3090F-05C3-4ABB-B94C-D013A64AEAB2/w1000/h732', 2),
(1308, 438, N'https://sp-one.vn/Content/uploads/2025/01/h732__6__f1824608615d43f38d9ca82e4bdc4745_master.webp', 3),
(1309, 439, N'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mimirajabguf4d', 1),
(1310, 439, N'https://laptopre.vn/upload/picture/picture-01724490241.jpg', 2),
(1311, 439, N'https://nguyencongpc.vn/media/product/25602-tan-nhiet-nuoc-aio-lc-ii-360-argb-1.jpg', 3),
(1312, 440, N'https://product.hstatic.net/1000333506/product/tan-nhiet-nuoc-deepcool-ls720-den-5_cbfb00745ece4e9298eb69f0db447bd8.jpg', 1),
(1313, 440, N'https://down-vn.img.susercontent.com/file/vn-11134201-23030-5d4x4btekpovf1', 2),
(1314, 440, N'https://wp.easypc.com.ph/wp-content/uploads/2025/02/Deepcool_LS720_SE_Black.jpg', 3),
(1315, 441, N'https://lapvip.com.vn/upload/anh-san-pham/82093-tan-nhiet-nuoc-deepcool-mystique-360-black-4-1920x.jpg', 1),
(1316, 441, N'https://bizweb.dktcdn.net/100/329/122/files/tan-nhiet-nuoc-aio-deepcool-mystique-360-06.jpg?v=1711081545226', 2),
(1317, 441, N'https://phucanhcdn.com/media/product/58551_tan_nhiet_nuoc_aio_deepcool_mystique_360_3.jpg', 3),
(1318, 442, N'https://gitec.ge/images/thumbs/0070829_tr-fw-360-b-argb.jpeg', 1),
(1319, 442, N'https://product.hstatic.net/200000420363/product/5-5__1__d7faad2c068e41a08ad3717358d1a92a_master.jpg', 2),
(1320, 442, N'http://www.kccshop.vn/media/product/250-6915-3.png', 3),
(1321, 443, N'https://gland.vn/media/product/15013_82296_tan_nhiet_nuoc_lian_li_galahad_ii_lcd_sl_inf_360_black__4_.jpg', 1),
(1322, 443, N'https://product.hstatic.net/200000522285/product/6_beaf8e647580488587c90e24588123da.png', 2),
(1323, 443, N'https://product.hstatic.net/200000522285/product/phanteks_m25_d4a6a0b55ea54eb7b96aa458dc7861f4_1024x1024.png', 3),
(1324, 444, N'https://bizweb.dktcdn.net/100/329/122/files/tan-nhiet-nuoc-msi-mag-coreliquid-c360-1-nd.png?v=1669023647952', 1),
(1325, 444, N'https://product.hstatic.net/1000037809/product/thegioigear_tannhietaio_msi_mag_coreliquid_240r-3_19aeac7403e044e6ab8bd263d9f8ab66_master.png', 2),
(1326, 444, N'https://nguyencongpc.vn/photos/17/MAG-CORELIQUID-240R-3.jpg', 3),
(1327, 445, N'https://static0.gamerantimages.com/wordpress/wp-content/uploads/2023/03/id-cooling-frostflow-x-240-snow-cpu-cooler.jpg', 1),
(1328, 445, N'https://technicstore.net/wp-content/uploads/2022/09/FROSTFLOW-X-240-SNOW-1.jpg', 2),
(1329, 445, N'https://technicstore.net/wp-content/uploads/2020/04/14030106982_1782855227.jpg', 3),
(1330, 446, N'https://media.ldlc.com/r1600/ld/products/00/05/99/31/LD0005993103.jpg', 1),
(1331, 446, N'https://product.hstatic.net/200000722513/product/h732__7__34abe7050daa4b23991080cb678d7912_master.png', 2),
(1332, 446, N'https://www.vmodtech.com/main/wp-content/uploads/2022/12/06/asus-rog-strix-geforce-rtx-4090-oc-edition-24gb-gddr6x/main-1.jpg', 3),
(1333, 447, N'https://m.media-amazon.com/images/I/81g+jlolvmL._AC_.jpg', 1),
(1334, 447, N'https://www.tncstore.vn/media/lib/30-01-2024/tnc-store-card-man-hinh-msi-geforce-rtx-4080-super-16g-gaming-x-trio7.jpg', 2),
(1335, 447, N'https://storage-asset.msi.com/global/picture/image/feature/vga/Geforce/RTX4080/GeForce-RTX-4080-Gaming-X-Trio-16G/kv-pd.png', 3),
(1336, 448, N'https://bermorzone.com.ph/wp-content/uploads/2023/06/GV-N4060EAGLE-OC-8GD.webp', 1),
(1337, 448, N'https://file.hstatic.net/200000722513/file/gearvn-card-man-hinh-gigabyte-geforce-rtx-4060-eagle-oc-8g-7_48ff16d4c4f2495ba21f326c2f64c30e_1024x1024.png', 2),
(1338, 448, N'https://khanhlinhpc.vn/hinh-anh/san-pham/geforce-rtx-4060-eagle-oc-8g-04.png', 3),
(1339, 449, N'https://pcngon.vn/wp-content/uploads/2024/05/Card-man-hinh-Gigabyte-GeForce-RTX-3050-WINDFORCE-OC-6G-3.png', 1),
(1340, 449, N'https://tatthanhcomputer.com/uploads/shops/linh_kien_may_tinh/vga/vga_30xx/48664_vga_gigabyte_rtx_3050_windforce_oc_6gb__n3050wf2oc__6gd____3_.jpg', 2),
(1341, 449, N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3650/innergigabyteimages/kf-img.png', 3),
(1342, 450, N'https://image.citycenter.jo/cache/catalog/002023/62023/DL40604-1200x1200.jpg', 1),
(1343, 450, N'https://product.hstatic.net/200000722513/product/dual-rtx4060-o8g-02_14a3d3f126094a2fba80218a4a7efb31_master.jpg', 2),
(1344, 450, N'https://m.media-amazon.com/images/I/710DxdxoAgL._AC_.jpg', 3),
(1345, 451, N'https://minhancomputercdn.com/media/product/5674_card_m__n_h__nh_zotac_gaming_geforce_rtx_3060_twin_edge_oc.jpg', 1),
(1346, 451, N'https://files.pccasegear.com/UserFiles/ZT-A30600E-10M-zotac-gaming-geforce-rtx-3060-twin-edge-12gb-product4.jpg', 2),
(1347, 451, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lrzp81nm4qf8a1', 3),
(1348, 452, N'https://www.scan.co.uk/images/infopages/amd_RX7600/Sapphire/Pulse/topimg.png', 1),
(1349, 452, N'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m9iexkt7lutgd4', 2),
(1350, 452, N'https://cdn.hstatic.net/products/200000420363/card-man-hinh-sapphire-pulse-amd_8acc5082af2b4d449ff5e19100e13a51_grande.jpg', 3),
(1351, 453, N'https://down-id.img.susercontent.com/file/id-11134207-7rbk0-m7bytcbb5pni4d', 1),
(1352, 453, N'https://pcmarket.vn/media/product/11087_vga_powercolor_fighter_radeon_rx_6600_8gb_gddr6_5.png', 2),
(1353, 453, N'https://pcmarket.vn/media/product/11087_vga_powercolor_fighter_radeon_rx_6600_8gb_gddr6_6.png', 3),
(1354, 454, N'https://www.asrock.com/Graphics-Card/photo/Radeon%20RX%207800%20XT%20Challenger%2016GB%20OC(M3).png', 1),
(1355, 454, N'https://product.hstatic.net/1000369156/product/83_90e7334d6c5146d783496695a08b1511_1024x1024.png', 2),
(1356, 454, N'https://m.media-amazon.com/images/I/81diCFiMtDL._AC_.jpg', 3),
(1357, 455, N'https://hanoicomputercdn.com/media/product/60280_card_man_hinh_colorful_gtx_1650_nb_4gd6_v_1.jpg', 1),
(1358, 455, N'https://cf.shopee.vn/file/vn-11134207-7r98o-lr41dxcb1iu135', 2),
(1359, 455, N'https://pcmarket.vn/media/lib/02-04-2024/card_man_hinh_colorful_gtx_1650_nb_4gd6_v_5.jpg', 3),
(1360, 456, N'https://m.media-amazon.com/images/I/71n-iiLwaIL._AC_.jpg', 1),
(1361, 456, N'https://img.terabyteshop.com.br/produto/g/hd-wd-purple-surveillance-2tb-sata-iii-5400rpm-256mb-wd23purz_208162.jpg', 2),
(1362, 456, N'https://linhkien24h.vn/upload/image/o-cung-hdd-2tb-wd-3-5inch.jpg', 3),
(1363, 457, N'https://kimostore.net/cdn/shop/files/western-digital-purple-4tb-3-5-inch-surveillance-internal-hard-drive-kimo-store-1_1024x.jpg?v=1715034242', 1),
(1364, 457, N'https://5.imimg.com/data5/SELLER/Default/2022/10/VC/YL/ZX/75518200/wd-4tb-wd-purple-surveillance-hard-drive-wd42purz-1000x1000.jpg', 2),
(1365, 457, N'https://mega.com.vn/upload/files/linh%20ki%E1%BB%87n%20m%C3%A1y%20t%C3%ADnh/HDD/Western%20Digital/HDWD0032/592_o_cung_hdd_western_purple_4tb_sata3_5400rpm_1.webp', 3),
(1366, 458, N'https://phucanhcdn.com/media/product/51316_o_cung_western_digital_purple_6tb_2.jpg', 1),
(1367, 458, N'https://www.startech.com.bd/image/cache/catalog/HDD/Western%20Digital/Western%20Digital%206TB%20Purple-500x500.jpg', 2),
(1368, 458, N'https://5.imimg.com/data5/SELLER/Default/2022/3/SJ/XG/FZ/20849596/6tb-hard-disk-surveillance-wd-purple-1000x1000.png', 3),
(1369, 459, N'https://sunco.com.vn/wp-content/uploads/2021/06/sgsk2tb2.jpg', 1),
(1370, 459, N'https://ddhshop.vn/wp-content/uploads/2020/09/HDD-Seagate-SkyHawk-SURVEILLANCE-2TB-3.5-inch.jpg', 2),
(1371, 459, N'https://vanservicios.com/wp-content/uploads/2024/01/41890-600x600.jpg', 3),
(1372, 460, N'https://lagihitech.vn/wp-content/uploads/2019/10/o-cung-HDD-Seagate-SkyHawk-6TB-3.5-inch-SATA-iii-ST6000VX001-2.jpg', 1),
(1373, 460, N'https://www.trac-cctv.co.uk/41-large_default/seagate-skyhawk-6tb-surveillance-hard-drive.jpg', 2),
(1374, 460, N'https://mega.com.vn/upload/files/linh%20ki%E1%BB%87n%20m%C3%A1y%20t%C3%ADnh/HDD/Seagate/HDSE0112/11087_o_cung_hdd_video_seagate_skyhawk_6tb_2.webp', 3),
(1375, 461, N'https://www.sieuthimaychu.vn/datafiles/setone/17299128542875.jpg', 1),
(1376, 461, N'https://viettuans.vn/uploads/2024/05/st8000nt001.jpg', 2),
(1377, 461, N'https://bizweb.dktcdn.net/100/494/584/products/o-cung-hdd-seagate-ironwolf-pro-8tb-st8000nt001-3-5-inch-7200rpm-sata-256mb-cache-web.png?v=1775643185280', 3),
(1378, 462, N'https://viettuans.vn/uploads/2024/05/st12000nt001.jpg', 1),
(1379, 462, N'https://img.watercoolinguk.co.uk/2025/09/seagate-ironwolf-pro-hdd-sata-6g-7200-rpm-35-inch-12tb-hdsg-115-68645-1.jpg', 2),
(1380, 462, N'https://www.sieuthimaychu.vn/datafiles/setone/15663755172039.jpg', 3),
(1381, 463, N'https://m.media-amazon.com/images/I/71IN+zCFbRL._AC_.jpg', 1),
(1382, 463, N'https://m.media-amazon.com/images/I/71H9kHbXKFL.jpg', 2),
(1383, 463, N'https://product.hstatic.net/1000129940/product/hdd-western-digital-red-pro-8tb_d96299d2f2474eabaaf2dc9d64ccfd62_master.jpg', 3),
(1384, 464, N'https://lagihitech.vn/wp-content/uploads/2020/09/o-cung-HDD-Seagate-EXOS-X16-14TB-3.5-inch-ST14000NM001G.jpg', 1),
(1385, 464, N'https://www.exbilisim.com/idea/qz/49/myassets/products/993/seagate-exos-enterprise-x16-14tb-7200r-4bba-4.jpg?revision=1781342941', 2),
(1386, 464, N'https://c1.neweggimages.com/ProductImageCompressAll1280/A994S200902wcEK6.jpg', 3),
(1387, 465, N'https://www.westerndigital.com/content/dam/store/en-us/assets/products/internal-storage/ultrastar-dc-hc550-hdd/gallery/ultrastar-dc-hc550-hdd-14tb-left.png', 1),
(1388, 465, N'https://product.hstatic.net/200000722513/product/o-cung-hdd-18tb-western-digital_17bc422fad9b4f8fb51ec439e3f63a4a.png', 2),
(1389, 465, N'https://maychunhanh.vn/upload/images/24860-1.jpg', 3),
(1390, 466, N'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lgaouo66r8fea3', 1),
(1391, 466, N'https://static-01.daraz.com.np/p/a1dd6d32d383fccf74610d9f723ace87.jpg', 2),
(1392, 466, N'https://m3.ngt.ma/20970-large_default/disque-dur-externe-toshiba-hdd-canvio-basics-1tb-usb-32-25-inch-noir-hdtb510ek3aa.jpg', 3),
(1393, 467, N'https://lagihitech.vn/wp-content/uploads/2025/10/HDD-Toshiba-AV-S300-4TB-3.5-inch-7200RPM-SATA-iii-256MB-Cache-HDWT740UZSVA-hinh-5.jpg', 1),
(1394, 467, N'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mftyxgowtukube', 2),
(1395, 467, N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m45tjuubr2z350', 3),
(1396, 468, N'https://down-vn.img.susercontent.com/file/sg-11134201-22120-uzk4xrzv8blva9', 1),
(1397, 468, N'https://lagihitech.vn/wp-content/uploads/2023/02/HDD-Laptop-WD-Blue-1TB-2.5-inch-SATA-iii-WD10SPZX.jpg', 2),
(1398, 468, N'https://www.binarylogic.com.bd/large/images/product_image/western-digital-hdd-blue-wd10ezex-1tb-sata-6gbs-desktop-7200rpm-64mb-cache-bare-drive.jpg', 3),
(1399, 469, N'https://gland.vn/media/product/13446_z4296126812697_0518190372100e51c1f6a65ab56b95e1.jpg', 1),
(1400, 469, N'https://product.hstatic.net/1000262653/product/corsair-850w_27e1d4e546884ceea395324d141732a3_master.png', 2),
(1401, 469, N'https://product.hstatic.net/200000722513/product/89689_nguon_may_tinh_corsair_rm850e_atx_001_1baa86f79fed4d9c9b209eb6cc8dac9b.jpg', 3),
(1402, 470, N'https://vietdong.com.vn/wp-content/uploads/2023/12/nguon-may-tinh-corsair-rmx_1000_80plus_viet-dong-2.png', 1),
(1403, 470, N'https://khothietbi.vn/image/product/large/nguon-pc-corsair-rm1000x-shift-1000w-80-plus-gold-fullmodular-atx-den-1752654173.jpg', 2),
(1404, 470, N'https://www.tpstech.in/cdn/shop/files/Corsair-RM1000x-Shift-Fully-Modular-ATX-Power-Supply-6.jpg?v=1744633583', 3),
(1405, 471, N'https://os-jo.com/image/cache/catalog/products/power-/cv650w/corsair-1200x1200.jpeg', 1),
(1406, 471, N'https://fullh4rd.com.ar/img/productos/26/fuente-650w-corsair-cv650-80-plus-bronze-0.jpg', 2),
(1407, 471, N'https://bizweb.dktcdn.net/thumb/grande/100/497/222/products/corsair-cv650.png?v=1697794890477', 3),
(1408, 472, N'https://image.citycenter.jo/cache/catalog/002024/32024/650bn-1200x1200.jpg', 1),
(1409, 472, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lnvn3maao58a6e', 2),
(1410, 472, N'https://product.hstatic.net/1000262653/product/mag-650w_dfb36d0a5d0b44e2b79701b9d57024aa_master.jpg', 3),
(1411, 473, N'https://bermorzone.com.ph/wp-content/uploads/2023/09/meg-ai1300p-pcie5-btz-ph-4.webp', 1),
(1412, 473, N'https://img.pccomponentes.com/articles/1063/10634341/3321-msi-meg-ai1300p-pcie5-1300w-80-plus-platinum-full-modular-mejor-precio.jpg', 2),
(1413, 473, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lzelo5he8f9pa1', 3),
(1414, 474, N'https://songphuong.vn/Content/uploads/2025/06/ROG-THOR-1000P2-2.webp', 1),
(1415, 474, N'https://dlcdnwebimgs.asus.com/gain/F40C3AEA-D458-41E6-BF27-045C0C8D5086', 2),
(1416, 474, N'https://songphuong.vn/Content/uploads/2025/06/ROG-THOR-1000P2-1.webp', 3),
(1417, 475, N'https://ttcenter.com.vn/uploads/product/odsfl7z6-2239-nguon-may-tinh-asus-tuf-gaming-650b-650w-80-plus-bronze.jpg', 1),
(1418, 475, N'https://tandoanh.vn/wp-content/uploads/2024/10/ASUS-TUF-Gaming-650W-H1.jpg', 2),
(1419, 475, N'https://down-vn.img.susercontent.com/file/vn-11134211-81ztc-mm350qyfa22sab', 3),
(1420, 476, N'https://nguyencongpc.vn/photos/17/cooler-master-elite-v3-600w-1.JPG', 1),
(1421, 476, N'https://tatthanhcomputer.com/uploads/shops/linh_kien_may_tinh/nguon/cooler_master/47084_nguon_may_tinh_cooler_master_elite_v3_600w_0001_1__4_.jpg', 2),
(1422, 476, N'https://www.civip.com.vn/media/product/1139_2507fb115a56cff02576da8b043d91a0.jpg', 3),
(1423, 477, N'https://hoanghapccdn.com/media/product/3687_deepcool_pk650_2.jpg', 1),
(1424, 477, N'https://product.hstatic.net/200000397235/product/nguon_deepcool_pk650_650w_80_plus_bronze_r-pk650d-fa0b-eu_dbbc3474d81747cb8f8216362b3dae87_1024x1024.png', 2),
(1425, 477, N'https://pcngon.vn/wp-content/uploads/2024/04/Nguon-Deepcool-650W-PK650D.jpg', 3),
(1426, 478, N'https://cdn.cclonline.com/cdn-cgi/image/width=2000/images/avante/06-PG-850G_ll.jpg', 1),
(1427, 478, N'https://kizupro.com/21361-medium_default/asrock-pg-850g-phantom-gaming-850w-80-plus-gold.jpg', 2),
(1428, 478, N'https://cdn.cclonline.com/cdn-cgi/image/width=2000/images/avante/09-PG-850G_Box.jpg', 3),
(1429, 479, N'https://c1.neweggimages.com/ProductImageCompressAll1280/11-146-347-12.png', 1),
(1430, 479, N'https://images-na.ssl-images-amazon.com/images/I/714NSc5RdiL.jpg', 2),
(1431, 479, N'https://m.media-amazon.com/images/I/61reVzOIDjL.jpg', 3),
(1432, 480, N'https://cdn.mwave.com.au/images/400/h5_flow_rgb_2024_compact_midtower_atx_case_with_rgb_fans_all_white_ac78552_69862.jpg', 1),
(1433, 480, N'https://philong.com.vn/media/product/30165-vo-case-nzxt-h5-flow-rgb-white-philong--1-.jpg', 2),
(1434, 480, N'https://m.media-amazon.com/images/I/81C4l0uogOL._AC_.jpg', 3),
(1435, 481, N'https://os-jo.com/image/cache/catalog/products/cases/O11DEXL/S2fb6d31afbee413991522c82f243b742x-ezgif.com-webp-to-jpg-converter-1200x1200.jpg', 1),
(1436, 481, N'https://hoanghapccdn.com/media/product/4513_lian_li_o11_dynamic_xl_rog_certified_ha1.jpg', 2),
(1437, 481, N'https://lian-li.com/wp-content/uploads/2023/11/O11_V_012.jpg', 3),
(1438, 482, N'https://m.media-amazon.com/images/I/71q26nT14fL._AC_.jpg', 1),
(1439, 482, N'https://laptopworld.vn/media/product/14942_75872_v____case_lian_li_lancool_216_black___rgb__5_.jpg', 2),
(1440, 482, N'https://images10.newegg.com/BizIntell/item/Case/Cases%20(Computer%20Cases%20-%20ATX%20Form)/2AM-000Z-000A9/1.jpg', 3),
(1441, 483, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6583/6583646cv11d.jpg', 1),
(1442, 483, N'https://cdn.mwave.com.au/images/400/corsair_3500x_argb_tempered_glass_midtower_case_black_ac74768_31393.jpg', 2),
(1443, 483, N'https://cdn.hstatic.net/products/200000680123/corsair-3500x-rs-r-argb-cc-9011322-ww-3_aed354a83ead41c9a920a2e6a4310545_1024x1024.jpg', 3),
(1444, 484, N'https://easetec.com.pk/wp-content/uploads/2024/04/Corsair-5000D-Core-Airflow-Tempered-Glass-Mid-Tower.jpg', 1),
(1445, 484, N'https://assets.corsair.com/image/upload/c_scale%2Cq_auto/products/Cases/base-5000d-airflow/Gallery/5000D_AF_WHITE_001.webp', 2),
(1446, 484, N'https://www.awd-it.co.uk/media/wysiwyg/5000D_RGB_WHITE_Artboard04_AA.jpg', 3),
(1447, 485, N'https://m.media-amazon.com/images/I/71UoRHNQnlL._AC_.jpg', 1),
(1448, 485, N'https://images-na.ssl-images-amazon.com/images/I/81VwGS2xgmL._AC_SL1500_.jpg', 2),
(1449, 485, N'https://images-na.ssl-images-amazon.com/images/I/816PIYVl0oL._AC_SL1500_.jpg', 3),
(1450, 486, N'https://cf.shopee.vn/file/dafaf7f040b67f1cd63c6b24302a2b70', 1),
(1451, 486, N'https://product.hstatic.net/1000262653/product/xigma_gamex_f1a23f73bcb741e0868a41d87d66705b_master.jpg', 2),
(1452, 486, N'https://cf.shopee.vn/file/e627eaf0dba80cf614381be3f525e792', 3),
(1453, 487, N'https://hanoicomputercdn.com/media/product/76272_mik_aion_white_3fa___3_.jpg', 1),
(1454, 487, N'https://api.combatgaming.vn/api-v2/image/id/6565593e78307a5dfe6b1dec', 2),
(1455, 487, N'https://philong.com.vn/media/lib/10-08-2024/vo-case-mik-aion-black-3fa-philong6.png', 3),
(1456, 488, N'http://www.sama.ltd/cdn/shop/files/Lolita-_6.jpg?v=1715842497', 1),
(1457, 488, N'https://c1.neweggimages.com/productimage/nb640/B41TS2405090J52K77B.jpg', 2),
(1458, 488, N'https://i5.walmartimages.com/seo/SAMA-3509-ATX-Mid-Tower-Gaming-Computer-Case-Tempered-Glass-w-4-x-ARGB-LED-Fans-Keyboard-3-x120mm-x-Front-l-1-x120mm-x-Rear-Black_376c92d1-9d70-46e9-944d-785e1dedf503.b71534dc981b6f1da6dbfa919bea7c52.jpeg?odnHeight=640&odnWidth=640&odnBg=FFFFFF', 3),
(1459, 489, N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m1cksxtc5dg8b5', 1),
(1460, 489, N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mde4dh6b1cfzdb', 2),
(1461, 489, N'https://hoanghapccdn.com/media/product/3197_peerless_assasin_king_120_3.jpg', 3),
(1462, 490, N'https://hoanghapccdn.com/media/product/4157_thermalright_frost_tower_120_ha5.jpg', 1),
(1463, 490, N'https://hoanghapccdn.com/media/product/4157_thermalright_frost_tower_120_ha9.jpg', 2),
(1464, 490, N'https://hoanghapccdn.com/media/product/4157_thermalright_frost_tower_120_ha2.jpg', 3),
(1465, 491, N'https://pcmarket.vn/media/product/10393_11.jpg', 1),
(1466, 491, N'https://media.ldlc.com/r1600/ld/products/00/06/05/60/LD0006056052.jpg', 2),
(1467, 491, N'https://hoanghapccdn.com/media/product/4420_ak620_digital_ha8.jpg', 3),
(1468, 492, N'https://mygear.io.vn/media/product/10052-tan-nhiet-khi-deepcool-ag400-argb-1.png', 1),
(1469, 492, N'https://product.hstatic.net/200000724631/product/68623_ag400_arb_sp__4__ee5bc5e4faa942359bc8c45032164537_master.jpg', 2),
(1470, 492, N'https://hoangkhue.vn/wp-content/uploads/2023/10/tan-nhiet-khiCPU-Deepcool-AG400-ARGB-1.jpg', 3),
(1471, 493, N'https://kccshop.vn/media/product/250-1417-efb2429ea0d85d9beb05b46102caf88d.jpg', 1),
(1472, 493, N'https://nvs.tn-cdn.net/2020/03/CPU-NOCTUA-NH-12s-7.jpg', 2),
(1473, 493, N'https://nhatphuongpc.com/wp-content/uploads/2025/03/5337-nh-u12s-chromax-black-3.jpg', 3),
(1474, 494, N'https://nvs.tn-cdn.net/2022/10/tan-nhiet-khi-cpu-noctua-nh-l9i-17xx-nguyenvu.store-2.webp', 1),
(1475, 494, N'https://pckumar.in/wp-content/uploads/2024/08/NH-L9I-17XX.jpg', 2),
(1476, 494, N'https://cdn.hstatic.net/products/200000921511/bpstore-tan-nhiet-khi-noctua-nh-l9i-17xx__8__32690c1d70274eb1833e0ab6d3952b7a_1024x1024.png', 3),
(1477, 495, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lte54m1w88exe9', 1),
(1478, 495, N'https://www.tnc.com.vn/uploads/product/gallery/tan-nhiet-khi-id-cooling-se-207-xt-black-2.jpg', 2),
(1479, 495, N'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m69ggvt2il9y4d', 3),
(1480, 496, N'https://kccshop.vn/media/product/250-10672-t---n-nhi---t-kh---id-cooling-frozn-a620-black_0.jpeg', 1),
(1481, 496, N'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mm2w7ed60feo8e', 2),
(1482, 496, N'https://plecom.imgix.net/iil-365922-662906.jpg?fit=fillmax&fill=solid&fill-color=ffffff&auto=format&w=1000&h=1000', 3),
(1483, 497, N'https://hoanghapccdn.com/media/product/2166_masterair_ma612_stealth_3_optimized.jpg', 1),
(1484, 497, N'https://product.hstatic.net/200000536009/product/4_e37133ea238b4acbb9ade6e863ebe04f_master.jpg', 2),
(1485, 497, N'https://sondat.vn/upload/data/images/TIN-TUC/tan-nhiet-khi-9.jpg', 3),
(1486, 498, N'https://vienthongquoctedongnai.vn/public/userfiles/product/Tan_nhiet_khi_CR1400_Den.png', 1),
(1487, 498, N'https://kccshop.vn/media/product/250-10421-t---n-nhi---t-kh---jonsbo-cr-1400-v2-argb-black_1.jpeg', 2),
(1488, 498, N'https://kccshop.vn/media/product/250-5000-2.jpg', 3),
(1489, 499, N'https://media.ldlc.com/r1600/ld/products/00/06/09/86/LD0006098667.jpg', 1),
(1490, 499, N'https://product.hstatic.net/200000522285/product/d__reverse_led_argb_-_ghep_noi_khong_day__pwm__fan_case_12cm_14cm__20__dad3b5de8a904f508b8fc79666db0e04.png', 2),
(1491, 499, N'https://technicstore.net/wp-content/uploads/2025/04/SL-WL-LCD-BLACK-REVERSE-3IN1-2.jpg', 3),
(1492, 500, N'https://lzd-img-global.slatic.net/g/p/f8bebe72f558a4ea36362e4c3de5b0c1.png_720x720q80.png', 1),
(1493, 500, N'https://basic-tutorials.com/wp-content/uploads/2023/05/IMG_1754.jpg', 2),
(1494, 500, N'https://c1.neweggimages.com/ProductImage/AFSTS2303215yYtC.jpg', 3),
(1495, 501, N'https://i5.walmartimages.com/asr/0bbc9208-102c-4325-9e8e-24d63e8b70ab.c0e41f31fb0c6f65eb9390e61e77f56a.jpeg', 1),
(1496, 501, N'https://m.media-amazon.com/images/I/71EkIInMOHL._AC_.jpg', 2),
(1497, 501, N'https://product.hstatic.net/1000037809/product/thegioigear_fan_case_corsair_ll120_rgb_120mm-white_4_c1cbb0678f22407fbb95bb54e151b9d4_master.jpg', 3),
(1498, 502, N'https://assets.corsair.com/image/upload/c_pad,q_auto,h_1024,w_1024,f_auto/products/Fans/base-sp-elite-config/Gallery/MIC_SP120_RGB_ELITE_WHITE_TRIPLE_01.webp', 1),
(1499, 502, N'https://elbadrgroupeg.store/image/cache/catalog/Corsair/8qlOTG0TDfkUeeMwUultf13hKH-1000x1000.png', 2),
(1500, 502, N'https://phucanhcdn.com/media/product/42846_fan_cor_co_9050109_ww_b.jpg', 3);
INSERT INTO product_images (id, product_id, image_url, display_order) VALUES
(1501, 503, N'https://hanoicomputercdn.com/media/product/75643_fan_case_t___n_nhi___t_nzxt_f120rgb_core_triple_pack_white__3_.jpg', 1),
(1502, 503, N'https://dailongpc.vn/upload/images/1689132598.jpg', 2),
(1503, 503, N'https://cdn.mwave.com.au/images/400/nzxt_f120_120mm_rgb_core_case_fan_with_rgb_controller_3_pack_white_ac61761_80772.jpg', 3),
(1504, 504, N'https://songphuong.vn/Content/uploads/2023/06/Fan-Deepcool-FC120-WHITE-3-IN-1-ARGB-songphuong.vn-02.jpg', 1),
(1505, 504, N'https://thanhlinh.vn/image/cache/catalog/FAN/DEEPCOOL-FC120-WHITE-500x500-product_popup.jpg', 2),
(1506, 504, N'https://songphuong.vn/Content/uploads/2023/06/Fan-Deepcool-FC120-WHITE-3-IN-1-ARGB-songphuong.vn-05.jpg', 3),
(1507, 505, N'https://nvs.tn-cdn.net/2024/07/Bo-3-Quat-Tan-Nhiet-Thermalright-TL-C12C-S-X3-White-6.jpg', 1),
(1508, 505, N'https://static.tandoanh.vn/wp-content/uploads/2023/04/Thermalright-TL-C12C-S-X3-Fan-H4.jpg', 2),
(1509, 505, N'https://hanoicomputercdn.com/media/product/74627_fan_case_t___n_nhi___t_thermalright_tl_c12c_s_white_pwm_argb__2_.jpg', 3),
(1510, 506, N'https://down-my.img.susercontent.com/file/cn-11134208-7r98o-lzlq1xiqglf771', 1),
(1511, 506, N'https://down-ph.img.susercontent.com/file/cn-11134207-7r98o-loxds8e5u28n9b', 2),
(1512, 506, N'https://www.thermalright.com/wp-content/uploads/2023/09/4.jpg', 3),
(1513, 507, N'https://product.hstatic.net/200000522285/product/upload_24d530229b2c4dd5b6995734c40d09f9.jpg', 1),
(1514, 507, N'https://plecom.imgix.net/iil-401528-668761.jpg?w=600&h=600', 2),
(1515, 507, N'https://nvs.tn-cdn.net/2023/04/quat-tan-nhiet-montech-rx120-pwm-argb.jpg', 3),
(1516, 508, N'https://qagaming.net/wp-content/uploads/2019/12/xf.png', 1),
(1517, 508, N'http://img.websosanh.vn/v2/users/root_product/images/quat-tan-nhiet-xigmatek-galaxy/dz2g3p3c5fzqs.jpg', 2),
(1518, 508, N'https://phucanhcdn.com/media/product/35523_8461.jpg', 3),
(1519, 509, N'https://xzone.com.vn/wp-content/uploads/2022/07/cooler-master-masterfan-mf120-halo-3-in-1.jpg', 1),
(1520, 509, N'https://nguyencongpc.vn/media/lib/11-10-2023/z4773076138688_e9b957ab019e4adc03e18ec20b70bdaa.jpg', 2),
(1521, 509, N'https://cdn.hstatic.net/products/200000921511/bpstore-quat-tan-nhiet-fsp-halo-argb-fan__5__615766eed10a45edaa77c5ca4cfcbb75_1024x1024.png', 3),
(1522, 510, N'https://down-vn.img.susercontent.com/file/e9fdd00372700ad2f4ba6850323cb2cd', 1),
(1523, 510, N'https://vitinhthanhtin.com/wp-content/uploads/2024/01/V309C-3.jpg', 2),
(1524, 510, N'https://api.combatgaming.vn/api/image/file/63ea238efd2a86352b6eb091', 3),
(1525, 511, N'https://img.lazcdn.com/g/p/49953f3cb62b53c5f0957a3e1e1ce96f.jpg_720x720q80.jpg', 1),
(1526, 511, N'https://down-my.img.susercontent.com/file/f4b8f42cf330effa3776f5549088fdf0', 2),
(1527, 511, N'https://down-id.img.susercontent.com/file/id-11134207-7r98u-lulkxh1j8l1l87', 3),
(1528, 512, N'https://azgear.vn/wp-content/uploads/2026/01/Arctic-P12-PWM-PST-Fan-Black-4.jpeg', 1),
(1529, 512, N'https://cdn.mwave.com.au/images/400/arctic_p12_pro_pst_120_mm_pwm_fan_black_ac91054_51084.jpg', 2),
(1530, 512, N'https://files.pccasegear.com/images/ACFAN00307A-thumb.jpg', 3),
(1531, 513, N'https://salt.tikicdn.com/ts/product/24/aa/7e/8ecb1dc71d3619de4a02208968da1ae5.jpg', 1),
(1532, 513, N'https://akkogear.com.vn/wp-content/uploads/2023/02/ban-phim-co-akko-5075b-plus-dragon-ball-super-goku-10-800x800.jpg', 2),
(1533, 513, N'https://salt.tikicdn.com/ts/product/67/69/45/39df54c367755c9aa7fc3bf45194c4e6.jpg', 3),
(1534, 514, N'https://product.hstatic.net/200000538213/product/o1cn01tfmr3z1parj7eezew-2210537861800-1675826820650_f8dba5dc6f4d4baa9e09fa4a5805b5fd_master.jpg', 1),
(1535, 514, N'https://gearshop.vn/upload/images/Product/Akko/Kit/MONSGEEK%20M1/KIT-MONSGEEK-M1-(5).png', 2),
(1536, 514, N'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lg2jbs1675rr3c', 3),
(1537, 515, N'https://owlgaming.vn/wp-content/uploads/2023/02/7-3.jpg', 1),
(1538, 515, N'https://owlgaming.vn/wp-content/uploads/2023/02/1-3.jpg', 2),
(1539, 515, N'https://cdn.shopify.com/s/files/1/0059/0630/1017/t/5/assets/keychronk2prowirelesscustommechanicalkeyboard-1670291563312.jpg?v=1670291565', 3),
(1540, 516, N'https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Q1-Max-7.jpg?v=1701051646', 1),
(1541, 516, N'https://bizweb.dktcdn.net/100/518/272/files/ban-phim-co-keychron-q1-max-3.jpg?v=1740078971589', 2),
(1542, 516, N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m3kyeap1h8rsdf', 3),
(1543, 517, N'https://www.tncstore.vn/media/product/13847-ban-phim-co-logitech-g-pro-x-tkl-lightspeed-tactile-switch-black-1.jpg', 1),
(1544, 517, N'https://www.m4g.com.my/image/m4g/image/cache/data/all_product_images/product-4819/cGubhECB1695016694-1384x1038.png', 2),
(1545, 517, N'https://xuepc.vn/media/product/9876-ban-phim-co-logitech-g-pro-x-tkl-lightspeed-wireless-tactile-switch--2-.jpg', 3),
(1546, 518, N'https://fullcleared.com/wp-content/uploads/2023/02/razer-blackwidow-v4-pro.jpg', 1),
(1547, 518, N'https://down-vn.img.susercontent.com/file/vn-11134208-7r98o-lq0czyma9h3m74', 2),
(1548, 518, N'https://gearshop.vn/upload/images/Product/Razer/B%C3%A0n%20ph%C3%ADm/BlackWidow%20V4%2075%25/BlackWidow-V4-75%25--(1).jpg', 3),
(1549, 519, N'https://down-vn.img.susercontent.com/file/vn-11134207-7ra0g-m8e7ad0so1msa5', 1),
(1550, 519, N'https://res.cloudinary.com/corsair-pwa/image/upload/f_auto,q_auto/akamai/pdp/keyboards/k70-rgb-pro/assets/images/k70-legend.png', 2),
(1551, 519, N'https://m.media-amazon.com/images/I/8113Zj6ES8L._AC_.jpg', 3),
(1552, 520, N'https://owlgaming.vn/wp-content/uploads/2024/06/ban-phim-co-steelseries-apex-pro-tkl-omnipoint-wireless-keyboard-us-magnetic-wrist-rest-5.jpg', 1),
(1553, 520, N'https://product.hstatic.net/1000129940/product/ban-phim-steelseries-apex-pro-tkl-wireless--omnipoint-1_459521c8dbec467ea8f23f407d9c124d_master.jpg', 2),
(1554, 520, N'https://ttgshop.vn/media/product/250_1070156563_ban_phim_steelseries_apex_pro_tkl_us_6_7cefd7b1ecbf4dcb98e9311f8248ea42.jpg', 3),
(1555, 521, N'https://hanoinew.vn/media/product/10249-asus-rog-azoth-wireless-1.jpg', 1),
(1556, 521, N'https://media.karousell.com/media/photos/products/2023/2/9/asus_rog_azoth_75_wireless_cus_1675921329_5543a448', 2),
(1557, 521, N'https://dlcdnwebimgs.asus.com/files/media/2C7F3DE4-F638-4ED3-8A25-83ABBBFF5F3F/v1/img/video/ROG-Azoth-product-video-thumbnail.jpg', 3),
(1558, 522, N'https://philong.com.vn/media/product/31842-ban-phim-co-dareu-ek87-v2-black-philong.png', 1),
(1559, 522, N'https://dareu.com.vn/wp-content/uploads/2024/09/ban-phim-co-gaming-ek87-v2-grey-black-1536x1536.jpg', 2),
(1560, 522, N'https://product.hstatic.net/200000350425/product/ban-phim-co-gaming-dareu-ek87-v2-led-rgb-02_a6868d9635d64f7798e1b1107a111379.jpg', 3),
(1561, 523, N'https://m.media-amazon.com/images/I/61r-cOXR-eL._AC_SL1500_.jpg', 1),
(1562, 523, N'https://progearcambodia.com/wp-content/uploads/2024/01/71oBEQdJOQL._AC_SL1500_.jpg', 2),
(1563, 523, N'https://i5.walmartimages.com/seo/Logitech-G-Pro-X-Superlight-2-Lightspeed-Wireless-Gaming-Mouse-Lightweight-Black_9d25ad65-1d7a-43cc-aef9-e4c97e13cf3a.502d0a94948b7b5142ae22488d59ebdd.png', 3),
(1564, 524, N'https://cf.shopee.vn/file/vn-11134207-7qukw-liqvq05531le30', 1),
(1565, 524, N'https://product.hstatic.net/1000262653/product/sp1080094_f5ea1ed1ba9d4068a9d472ebf704100c_master.png', 2),
(1566, 524, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lm5m0g1ffd27a0', 3),
(1567, 525, N'https://www.tncstore.vn/media/product/250-8340-razer-deathadder-v3-pro-ergonomic-white.jpg', 1),
(1568, 525, N'https://product.hstatic.net/1000037809/product/thegioigear_razer_deathadder_v3_pro_1_f11f9c6a22a34fd8bdc41a5d1a204514_grande.png', 2),
(1569, 525, N'https://product.hstatic.net/1000262653/product/rzblack_26b3c6ff7feb425b82f6c5119d2eb38d_master.jpg', 3),
(1570, 526, N'https://down-ph.img.susercontent.com/file/ph-11134207-7r990-lw6xtp2flqtg70', 1),
(1571, 526, N'https://www.virginmegastore.ae/medias/1002665-main.jpg?context=bWFzdGVyfHJvb3R8MzEzNzV8aW1hZ2UvanBlZ3xhRFppTDJnM01DOHhNRFV6TXpVMU9UVXdNRGd6TUM4eE1EQXlOalkxWDE5dFlXbHVMbXB3Wnd8YTFlZTVjN2M1ZTA0YjgyMDcwOGFjMDkzZjZjNzZhYzc1OTVkZDEwNzQ3ZDIwZDAyOTFiNmNkNTU3NWFjMjIxNQ', 2),
(1572, 526, N'https://down-my.img.susercontent.com/file/my-11134207-7r98u-lx2aywg8cynef9', 3),
(1573, 527, N'https://www.dateks.lv/images/pic/2400/2400/052/1201.jpg', 1),
(1574, 527, N'https://minhancomputercdn.com/media/product/10229_steelseries_aerox_3_wireless_black_3.jpg', 2),
(1575, 527, N'https://hanoicomputercdn.com/media/product/79114_chuot_gaming_co_day_steelseries_aerox_3_onyx_mau_den_2.jpg', 3),
(1576, 528, N'https://files.pccasegear.com/images/1632293357-CH-9319411-AP-thb.jpg', 1),
(1577, 528, N'https://assets.corsair.com/image/upload/v1/akamai/pdp/m65-ultra/wireless/m65_ultra_wireless_wht_icue.png', 2),
(1578, 528, N'https://www.custompc.com/wp-content/sites/custompc/2023/02/corsair-m65-rgb-ultra-wireless-review-01.jpg', 3),
(1579, 529, N'https://dlcdnwebimgs.asus.com/gain/9B783ACB-999D-41F3-AC55-7859FB30C90B', 1),
(1580, 529, N'https://product.hstatic.net/1000262653/product/sp1080911_e416c24ea3694311b2671e524bf343bd_master.png', 2),
(1581, 529, N'https://congnghesgsaigon.com/uploads/product/10_2025/thumbs/670__ASUS_ROG_Keris_4.jpg', 3),
(1582, 530, N'https://down-vn.img.susercontent.com/file/4b69f9c29485d36dc60c76a0656450f5', 1),
(1583, 530, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltypcynvc5chea', 2),
(1584, 530, N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mcxb76ugj5i484', 3),
(1585, 531, N'https://www.rapoo-eu.com/wp-content/uploads/2024/04/VT9PRO-side-top-e1713364980972.webp', 1),
(1586, 531, N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-loqrxgicq8uo4f', 2),
(1587, 531, N'https://down-my.img.susercontent.com/file/my-11134201-7rasa-m0e7hdyriiis6c', 3),
(1588, 532, N'https://down-id.img.susercontent.com/file/id-11134207-8224o-mjdz0ersk0lha2', 1),
(1589, 532, N'https://sp-ao.shortpixel.ai/client/to_webp,q_glossy,ret_img,w_1200,h_1200/https://fantech.ph/wp-content/uploads/2024/08/xd3v3-pro-s-black-1.jpg', 2),
(1590, 532, N'https://down-id.img.susercontent.com/file/sg-11134201-7rcc1-lqxawuiizioc82', 3),
(1591, 533, N'https://product.hstatic.net/200000350425/product/-11134207-7r98o-ll4gob8jbl5439_b520284b7ae942acace34f78f5ddb19a_master_8e2d26de5579407ebbe5e0e99031f31f_grande.png', 1),
(1592, 533, N'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-li5m36idv57009', 2),
(1593, 533, N'https://m.media-amazon.com/images/I/71pFeJFdJQL._AC_.jpg', 3),
(1594, 534, N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6522/6522922cv17d.jpg', 1),
(1595, 534, N'https://api.combatgaming.vn/api/image/file/6475b8db5317487ebf3353ba', 2),
(1596, 534, N'https://bizweb.dktcdn.net/100/329/122/files/tai-nghe-gaming-hyperx-cloud-stinger-2-519t1aa-nd.jpg?v=1678873325340', 3),
(1597, 535, N'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lhvrfe1ny3lte5', 1),
(1598, 535, N'https://product.hstatic.net/200000637319/product/713foooj-4l._ac_sl1500__d63184c0ce3d475eafe80c40b56c1795_master.jpg', 2),
(1599, 535, N'https://www.tnc.com.vn/uploads/product/sp2024/tai-nghe-razer-blackshark-v2-pro-black-rz04-04530100-r3m1.jpg', 3),
(1600, 536, N'https://laptopworld.vn/media/product/16641_76014_tai_nghe_gaming_razer_kraken_kitty_v2_pink___rz04_04730200_r3m1_2.jpg', 1),
(1601, 536, N'https://laptopworld.vn/media/product/16641_76014_tai_nghe_gaming_razer_kraken_kitty_v2_pink___rz04_04730200_r3m1_1.jpg', 2),
(1602, 536, N'https://m.media-amazon.com/images/I/71ROESuihoL._AC_.jpg', 3),
(1603, 537, N'https://resource.logitechg.com/d_transparent.gif/content/dam/gaming/en/products/pro-x-2-lightspeed/gallery/gallery-1-pro-x-2-lightspeed-gaming-headset-black.png', 1),
(1604, 537, N'https://www.tncstore.vn/media/product/9069-tai-nghe-logitech-g-pro-x-2-light-speed-white-1.jpg', 2),
(1605, 537, N'https://www.bhphotovideo.com/images/images1500x1500/logitech_g_981_001262_pro_x_2_wireless_1763226.jpg', 3),
(1606, 538, N'https://ttgshop.vn/media/product/250_1053296905_tai_nghe_gaming_logitech_g733_lightspeed_wireless_7_1_rgb_white_3_5e5523d21a674e24bb0fb3a2753def70.jpg', 1),
(1607, 538, N'https://cdn.ankhang.vn/media/product/21583_tai_nghe_logitech_g733_lightspeed_wireless_rgb_gaming_white_1.jpg', 2),
(1608, 538, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/440/968/products/21583-tai-nghe-logitech-g733-lightspeed-wireless-rgb-gaming-white-2.jpg?v=1741052101653', 3),
(1609, 539, N'https://sp-one.vn/Content/uploads/2023/04/68930_tai_nghe_steelseries_arctis_nova_pro_wireless_61520_4.jpg', 1),
(1610, 539, N'https://eezepc.com/wp-content/uploads/2023/01/036-EEZEPC-1-large.png', 2),
(1611, 539, N'https://media.steelseriescdn.com/thumbs/filer_public/e2/a4/e2a4f3a7-45ad-437c-b130-54d62034ff5b/imgbuy_arctis_nova_pro_wl_1_blank.png__1920x1080_crop-fit_optimize_subsampling-2.png', 3),
(1612, 540, N'https://help.corsair.com/hc/article_attachments/360072361352/VIRTUOSO_RGB_wireless_-_carbon.png', 1),
(1613, 540, N'https://product.hstatic.net/200000420363/product/tai_xuong_-_2023-11-27t134612.350_4c6ef5575693433e939732fc84802a94_master.png', 2),
(1614, 540, N'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Gaming-Headsets/CA-9011186-EU/Gallery/VIRTUOSO_WHITE_01.webp', 3),
(1615, 541, N'https://cdn.hstatic.net/products/200001100406/86965_asus_rog_delta_s_animate_01_f7b299bfafd14440aee29b5a208dd417_master.jpg', 1),
(1616, 541, N'https://philong.com.vn/media/lib/11-05-2023/phi-long-tai-nghe-gaming-asus-rog-delta-s-animate-9.jpg', 2),
(1617, 541, N'https://down-my.img.susercontent.com/file/8f1339eff741740272f65ee682e79194', 3),
(1618, 542, N'https://kccshop.vn/media/product/250-1179-1.jpg', 1),
(1619, 542, N'https://songphuong.vn/Content/uploads/2021/08/Tai-nghe-DareU-EH722X-7.1-PINK-1.jpg', 2),
(1620, 542, N'https://laptopworld.vn/media/product/8315_41852_hea_dar_eh722x_p_c.jpg', 3);
SET IDENTITY_INSERT product_images OFF;
DBCC CHECKIDENT ('product_images', RESEED, 1620);
GO



-- ----------------------------------------------------------------------------
-- 6.3 BASE VOUCHERS SEED DATA
-- ----------------------------------------------------------------------------
SET IDENTITY_INSERT vouchers ON;
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES
(2, 1, 'LXR36', '2026-06-22 10:52:53.047', N'Giảm giá 15% các mặt hàng', 'PERCENTAGE', 15, '2026-06-30 00:00:00', 50000, 10000, NULL, 100, 2, NULL),
(4, 1, 'LUX50', '2026-06-23 17:08:51.75', N'giảm giá 50', 'PERCENTAGE', 50, '2026-06-30 12:00:00', 10000000, 1000000, NULL, 10, 0, NULL),
(3, 1, 'LUX30', '2026-06-22 11:22:49.617', N'Giảm giá 30%', 'PERCENTAGE', 30, '2026-08-11 12:00:00', 5000000, 0, NULL, 0, 0, NULL),
(5, 1, 'LUX10', '2026-07-02 11:00:17.172', N'Giảm 10% cho tất cả đơn hàng', 'PERCENTAGE', 10, '2026-07-31 12:00:00', 10000000, 0, NULL, 10, 2, NULL);
SET IDENTITY_INSERT vouchers OFF;
DBCC CHECKIDENT ('vouchers', RESEED, 10);
GO


-- ----------------------------------------------------------------------------
-- 6.4 BASE FLASH SALES & ITEMS (30 SẢN PHẨM KHUYẾN MÃI)
-- ----------------------------------------------------------------------------
SET IDENTITY_INSERT flash_sales ON;
INSERT INTO flash_sales (id, active, created_at, end_time, name, start_time, description) VALUES
(1, 0, '2026-06-22 08:58:57.04', '2026-07-08 12:00:00', N'SALE7/7 (Đã kết thúc)', '2026-07-07 12:00:00', N'Chương trình Flash Sale 7/7'),
(2, 1, '2026-06-22 08:58:57.075', '2030-12-31 23:59:59', N'FLASH SALE SIÊU KHUYẾN MÃI LUXURY PC', '2026-01-01 00:00:00', N'Giảm giá cực sốc lên tới 40% cho linh kiện và phụ kiện PC chính hãng');
SET IDENTITY_INSERT flash_sales OFF;
DBCC CHECKIDENT ('flash_sales', RESEED, 5);
GO

SET IDENTITY_INSERT flash_sale_items ON;
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES
(1, 13175000, 20, 2, 2, 1),
(2, 13760000, 30, 5, 2, 2),
(3, 41250000, 50, 8, 2, 31),
(4, 22400000, 60, 10, 2, 32),
(5, 2275000, 80, 15, 2, 61),
(6, 2520000, 100, 22, 2, 62),
(7, 14025000, 20, 2, 2, 91),
(8, 3600000, 30, 5, 2, 92),
(9, 2400000, 50, 8, 2, 121),
(10, 3150000, 60, 10, 2, 122),
(11, 14625000, 80, 15, 2, 151),
(12, 8880000, 100, 22, 2, 152),
(13, 1530000, 20, 2, 2, 268),
(14, 640000, 30, 5, 2, 269),
(15, 2100000, 50, 8, 2, 276),
(16, 420000, 60, 10, 2, 277),
(17, 16250000, 80, 15, 2, 264),
(18, 21000000, 100, 22, 2, 265),
(19, 6455000, 20, 2, 2, 240),
(20, 6685000, 30, 5, 2, 241),
(21, 6077000, 50, 8, 2, 192),
(22, 2827000, 60, 10, 2, 205),
(23, 520000, 80, 15, 2, 16),
(24, 6386000, 100, 22, 2, 197),
(25, 7535000, 20, 2, 2, 191),
(26, 2824000, 30, 5, 2, 198),
(27, 2838000, 50, 8, 2, 251),
(28, 686000, 60, 10, 2, 357),
(29, 4111000, 80, 15, 2, 214),
(30, 3490000, 100, 22, 2, 219);
SET IDENTITY_INSERT flash_sale_items OFF;
DBCC CHECKIDENT ('flash_sale_items', RESEED, 30);
GO
-- ----------------------------------------------------------------------------
-- 6.5 BASE PC COMBOS & DETAILS
-- ----------------------------------------------------------------------------
SET IDENTITY_INSERT pc_combos ON;
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES
(1, 'HOT', '#ef4444', NULL, '/images/combo1.jpg', 'Combo 1: LXR Core Ultra 7 / RTX 5070Ti', 67000000),
(2, 'PREMIUM', '#eab308', NULL, '/images/combo2.jpg', 'Combo 2: LXR Core Ultra 7 / RTX 5080', 67000000),
(3, 'SALE', '#22c55e', NULL, '/images/combo3.jpg', 'Combo 3: LXR Intel i5-12400F / RTX 5060', 47000000),
(4, 'VALUE', '#3b82f6', NULL, '/images/combo4.jpg', 'Combo 4: LXR Intel i5-12400F / RTX 5060 Ti', 22000000),
(5, 'PERFORMANCE', '#f97316', NULL, '/images/combo5.jpg', 'Combo 5: LXR Intel i7-14700F / RTX 5060', 25000000),
(6, 'ULTIMATE', 'var(--gold)', NULL, '/images/combo2.jpg', 'Combo 6: LXR AMD Ryzen 9 / RTX 5090', 120000000),
(7, 'CREATOR', '#a855f7', NULL, '/images/combo1.jpg', 'Combo 7: LXR Studio / RTX 5080', 85000000);
SET IDENTITY_INSERT pc_combos OFF;
DBCC CHECKIDENT ('pc_combos', RESEED, 10);
GO

SET IDENTITY_INSERT pc_combo_details ON;
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES
(1, 'cpu', 1, 256),
(2, 'mainboard', 1, 259),
(3, 'ram', 1, 262),
(4, 'vga', 1, 264),
(5, 'storage', 1, 268),
(6, 'psu', 1, 270),
(7, 'case', 1, 274),
(8, 'cooling', 1, 276),
(9, 'cpu', 2, 256),
(10, 'mainboard', 2, 259),
(11, 'ram', 2, 262),
(12, 'vga', 2, 265),
(13, 'storage', 2, 268),
(14, 'psu', 2, 270),
(15, 'case', 2, 275),
(16, 'cooling', 2, 276),
(17, 'cpu', 3, 257),
(18, 'mainboard', 3, 260),
(19, 'ram', 3, 263),
(20, 'vga', 3, 266),
(21, 'storage', 3, 269),
(22, 'psu', 3, 271),
(23, 'case', 3, 16),
(24, 'cooling', 3, 277),
(25, 'cpu', 4, 257),
(26, 'mainboard', 4, 261),
(27, 'ram', 4, 263),
(28, 'vga', 4, 267),
(29, 'storage', 4, 269),
(30, 'psu', 4, 272),
(31, 'case', 4, 16),
(32, 'cooling', 4, 277),
(33, 'cpu', 5, 258),
(34, 'mainboard', 5, 261),
(35, 'ram', 5, 263),
(36, 'vga', 5, 266),
(37, 'storage', 5, 269),
(38, 'psu', 5, 273),
(39, 'case', 5, 274),
(40, 'cooling', 5, 276),
(41, 'cpu', 6, 1),
(42, 'mainboard', 6, 91),
(43, 'ram', 6, 67),
(44, 'vga', 6, 284),
(45, 'storage', 6, 285),
(46, 'psu', 6, 270),
(47, 'case', 6, 275),
(48, 'cooling', 6, 286),
(49, 'cpu', 7, 279),
(50, 'mainboard', 7, 102),
(51, 'ram', 7, 62),
(52, 'vga', 7, 265),
(53, 'storage', 7, 285),
(54, 'psu', 7, 270),
(55, 'case', 7, 275),
(56, 'cooling', 7, 276),
(57, 'cpu', 1, 256),
(58, 'mainboard', 1, 259),
(59, 'ram', 1, 262),
(60, 'vga', 1, 264),
(61, 'storage', 1, 268),
(62, 'psu', 1, 270),
(63, 'case', 1, 274),
(64, 'cooling', 1, 276);
SET IDENTITY_INSERT pc_combo_details OFF;
DBCC CHECKIDENT ('pc_combo_details', RESEED, 100);
GO


-- ============================================================================
-- 7. INSERT USERS & ROLES SEED DATA (CHIA RÕ TỪNG ROLE THEO THỨ TỰ)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 7.1. TÀI KHOẢN ADMIN (QUẢN TRỊ VIÊN HỆ THỐNG)
-- ----------------------------------------------------------------------------
SET IDENTITY_INSERT users ON;

INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, force_change_password, created_at) VALUES
(1, 'leecookcu@gmail.com', 'leecookcu@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bá Bá', '0936629311', NULL, 1, 'LOCAL', NULL, NULL, '/uploads/avatars/user_2_1785405662243.webp', '2006-12-12 00:00:00.000', 1, 1, 1, 1, 1, 1, 0, 0, '2026-06-12 18:47:49.406');

-- ----------------------------------------------------------------------------
-- 7.2. 20 TÀI KHOẢN NHÂN VIÊN (STAFF) - PHÂN CHIA THEO CHI NHÁNH / KHU VỰC
-- ----------------------------------------------------------------------------

-- Khu vực Hà Nội (Showroom Thái Hà, Cầu Giấy, Hai Bà Trưng)
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, force_change_password, created_at) VALUES
(2, 'phamcongthanh.8311@gmail.com', 'phamcongthanh.8311@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', N'Phạm Thanh', '0902208461', NULL, 1, 'GOOGLE', '112307932430374029161', NULL, '/uploads/avatars/user_41_1783933303213.webp', NULL, 1, 1, 1, 1, 1, 1, 0, 0, '2026-07-13 16:00:58.778');

INSERT INTO users (id, username, email, password, full_name, phone, address, avatar, birthday, gender, enabled, auth_provider, status, force_change_password, created_at) VALUES
(3, 'staff.thutrang', 'thutrang.luxury@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Thị Thu Trang', '0975234567', N'Số 45 Chùa Bộc, Phường Quang Trung, Quận Đống Đa, Hà Nội', '/uploads/avatars/user_2.webp', '1998-09-20', 0, 1, 'LOCAL', 1, 0, '2026-01-18 09:15:00'),
(4, 'staff.minhduc', 'minhduc.tech@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đỗ Minh Đức', '0912345678', N'Số 68 Cầu Giấy, Phường Quan Hoa, Quận Cầu Giấy, Hà Nội', '/uploads/avatars/user_3.webp', '1996-11-05', 1, 1, 'LOCAL', 1, 0, '2026-02-01 10:00:00'),
(5, 'staff.ngocmai', 'ngocmai.luxurypc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phạm Ngọc Mai', '0934567890', N'Số 165 Xuân Thủy, Phường Dịch Vọng Hậu, Quận Cầu Giấy, Hà Nội', '/uploads/avatars/user_4.webp', '2000-03-14', 0, 1, 'LOCAL', 1, 0, '2026-02-10 14:20:00'),
(6, 'staff.tuankiet', 'tuankiet.pc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đặng Tuấn Kiệt', '0903456781', N'Số 88 Phố Huế, Phường Hàng Bài, Quận Hoàn Kiếm, Hà Nội', '/uploads/avatars/user_5.webp', '1994-07-28', 1, 1, 'LOCAL', 1, 0, '2026-02-15 11:45:00'),
(7, 'staff.phuongthao', 'phuongthao.sales@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bùi Phương Thảo', '0945678902', N'Số 210 Xã Đàn, Phường Nam Đồng, Quận Đống Đa, Hà Nội', '/uploads/avatars/user_6.webp', '1999-12-08', 0, 1, 'LOCAL', 1, 0, '2026-02-20 08:00:00'),
(8, 'staff.quanghuy', 'quanghuy.buildpc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Nguyễn Quang Huy', '0967890123', N'Số 32 Hoàng Cầu, Phường Ô Chợ Dừa, Quận Đống Đa, Hà Nội', '/uploads/avatars/user_7.webp', '1997-05-19', 1, 1, 'LOCAL', 1, 0, '2026-03-01 13:30:00');

-- Khu vực TP. Hồ Chí Minh (Showroom Quận 1, Quận 3, Quận 10, TP. Thủ Đức)
INSERT INTO users (id, username, email, password, full_name, phone, address, avatar, birthday, gender, enabled, auth_provider, status, force_change_password, created_at) VALUES
(9, 'staff.giahuynh', 'giahuynh.luxury@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trương Gia Huỳnh', '0943210987', N'Số 182 Bùi Thị Xuân, Phường Phạm Ngũ Lão, Quận 1, TP. Hồ Chí Minh', '/uploads/avatars/user_13.webp', '1994-08-14', 1, 1, 'LOCAL', 1, 0, '2026-04-08 09:00:00'),
(10, 'staff.bichngoc', 'bichngoc.hcm@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Ngô Bích Ngọc', '0965432109', N'Số 386 Võ Văn Tần, Phường 5, Quận 3, TP. Hồ Chí Minh', '/uploads/avatars/user_14.webp', '1997-02-27', 0, 1, 'LOCAL', 1, 0, '2026-04-15 14:00:00'),
(11, 'staff.truonggiang', 'truonggiang.tech@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phan Trường Giang', '0987654321', N'Số 280 Nguyễn Đình Chiểu, Phường 6, Quận 3, TP. Hồ Chí Minh', '/uploads/avatars/user_15.webp', '1992-11-11', 1, 1, 'LOCAL', 1, 0, '2026-04-20 11:10:00'),
(12, 'staff.hoangyen', 'hoangyen.luxurypc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Dương Hoàng Yến', '0976543210', N'Số 543 Cách Mạng Tháng 8, Phường 15, Quận 10, TP. Hồ Chí Minh', '/uploads/avatars/user_16.webp', '2000-09-09', 0, 1, 'LOCAL', 1, 0, '2026-04-26 16:30:00'),
(13, 'staff.quocbao', 'quocbao.pcbuilder@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lê Quốc Bảo', '0918765432', N'Số 120 Thành Thái, Phường 12, Quận 10, TP. Hồ Chí Minh', '/uploads/avatars/user_17.webp', '1996-03-31', 1, 1, 'LOCAL', 1, 0, '2026-05-02 08:20:00'),
(14, 'staff.thuytien', 'thuytien.sales@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Vũ Thủy Tiên', '0932109876', N'Số 89 Sư Vạn Hạnh, Phường 12, Quận 10, TP. Hồ Chí Minh', '/uploads/avatars/user_18.webp', '1999-07-15', 0, 1, 'LOCAL', 1, 0, '2026-05-08 10:40:00'),
(15, 'staff.minhtri', 'minhtri.support@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Nguyễn Minh Trí', '0901234567', N'Số 175 Phan Xích Long, Phường 2, Quận Phú Nhuận, TP. Hồ Chí Minh', '/uploads/avatars/user_19.webp', '1995-10-04', 1, 1, 'LOCAL', 1, 0, '2026-05-15 13:50:00'),
(16, 'staff.kimngan', 'kimngan.hcm@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Kim Ngân', '0945678123', N'Số 420 Nguyễn Oanh, Phường 6, Quận Gò Vấp, TP. Hồ Chí Minh', '/uploads/avatars/user_20.webp', '2002-01-18', 0, 1, 'LOCAL', 1, 0, '2026-05-22 09:15:00');

-- Khu vực Đà Nẵng & Miền Trung (Showroom Hải Châu, Thanh Khê)
INSERT INTO users (id, username, email, password, full_name, phone, address, avatar, birthday, gender, enabled, auth_provider, status, force_change_password, created_at) VALUES
(17, 'staff.tanphat', 'tanphat.danang@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Võ Tấn Phát', '0982345678', N'Số 234 Nguyễn Văn Linh, Phường Thạc Gián, Quận Thanh Khê, Đà Nẵng', '/uploads/avatars/user_5.webp', '1995-03-12', 1, 1, 'LOCAL', 1, 0, '2026-06-20 09:00:00'),
(18, 'staff.myhanh', 'myhanh.luxury@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Mỹ Hạnh', '0973456789', N'Số 156 Hùng Vương, Phường Hải Châu 1, Quận Hải Châu, Đà Nẵng', '/uploads/avatars/user_6.webp', '1999-08-25', 0, 1, 'LOCAL', 1, 0, '2026-06-25 14:15:00'),
(19, 'staff.quangvinh', 'quangvinh.tech@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phan Quang Vinh', '0914567890', N'Số 89 Lê Duẩn, Phường Hải Châu 2, Quận Hải Châu, Đà Nẵng', '/uploads/avatars/user_7.webp', '1993-12-30', 1, 1, 'LOCAL', 1, 0, '2026-07-01 10:30:00'),
(20, 'staff.thanhngan', 'thanhngan.pc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lê Thanh Ngân', '0935678901', N'Số 45 Điện Biên Phủ, Phường Chính Gián, Quận Thanh Khê, Đà Nẵng', '/uploads/avatars/user_8.webp', '2001-04-18', 0, 1, 'LOCAL', 1, 0, '2026-07-08 16:45:00'),
(21, 'staff.vietanh', 'vietanh.custom@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hoàng Việt Anh', '0906789012', N'Số 78 Bạch Đằng, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng', '/uploads/avatars/user_9.webp', '1996-09-05', 1, 1, 'LOCAL', 1, 0, '2026-07-15 08:20:00');

-- ----------------------------------------------------------------------------
-- 7.3. 100 TÀI KHOẢN KHÁCH HÀNG (USER) - HỌ TÊN TIẾNG VIỆT CÓ DẤU CHUẨN XÁC
-- ----------------------------------------------------------------------------

-- Khách hàng Khu vực Miền Bắc (Hà Nội, Hải Phòng, Quảng Ninh, Bắc Ninh, Hải Dương)
INSERT INTO users (id, username, email, password, full_name, phone, address, birthday, gender, enabled, auth_provider, status, force_change_password, created_at) VALUES
(22, 'user_001', 'khachhang001@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Dương Khánh Anh', '0796568181', N'Số 135, Đường Cầu Giấy, Hoàng Mai, Hà Nội', '1987-11-21', 0, 1, 'LOCAL', 1, 0, '2024-06-08 12:59:00'),
(23, 'user_002', 'khachhang002@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Huỳnh Thu Huyền', '0335636784', N'Số 93, Đường Nguyễn Trãi, TP. Bắc Ninh, Bắc Ninh', '1986-10-13', 0, 1, 'LOCAL', 1, 0, '2024-10-06 11:20:00'),
(24, 'user_003', 'khachhang003@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Vũ Khánh Ngọc', '0969809398', N'Số 271, Đường Võ Văn Kiệt, Uông Bí, Quảng Ninh', '1996-09-28', 0, 1, 'LOCAL', 1, 0, '2025-08-13 20:13:00'),
(25, 'user_004', 'khachhang004@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đặng Hải Châu', '0883687942', N'Số 85, Đường Võ Văn Kiệt, Tây Hồ, Hà Nội', '1987-05-23', 0, 1, 'LOCAL', 1, 0, '2026-02-23 08:48:00'),
(26, 'user_005', 'khachhang005@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đặng Mỹ Lam', '0989557017', N'Số 23, Đường Hai Bà Trưng, Hồng Bàng, Hải Phòng', '1998-12-04', 0, 1, 'LOCAL', 1, 0, '2025-11-23 10:49:00'),
(27, 'user_006', 'khachhang006@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Trọng Quân', '0970703321', N'Số 329, Đường Hai Bà Trưng, Đống Đa, Hà Nội', '1988-02-09', 1, 1, 'LOCAL', 1, 0, '2024-12-24 14:12:00'),
(28, 'user_007', 'khachhang007@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Tuấn Tùng', '0797839946', N'Số 40, Đường Giải Phóng, Ngô Quyền, Hải Phòng', '1994-07-28', 1, 1, 'LOCAL', 1, 0, '2025-12-04 11:24:00'),
(29, 'user_008', 'khachhang008@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hồ Mai Linh', '0884008436', N'Số 113, Đường Nguyễn Huệ, Tây Hồ, Hà Nội', '1995-11-21', 0, 1, 'LOCAL', 1, 0, '2026-01-28 09:47:00'),
(30, 'user_009', 'khachhang009@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bùi Gia Quân', '0912109582', N'Số 164, Đường Trần Hưng Đạo, Hồng Bàng, Hải Phòng', '2002-07-06', 1, 1, 'LOCAL', 1, 0, '2025-07-24 15:22:00'),
(31, 'user_010', 'khachhang010@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Huỳnh Ánh Tú', '0394172699', N'Số 65, Đường Cách Mạng Tháng 8, TP. Hải Dương, Hải Dương', '1989-10-20', 0, 1, 'LOCAL', 1, 0, '2024-01-13 20:39:00'),
(32, 'user_011', 'khachhang011@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đỗ Xuân Nam', '0930760927', N'Số 151, Đường Nguyễn Huệ, Hoàng Mai, Hà Nội', '1989-09-19', 1, 1, 'LOCAL', 1, 0, '2024-03-25 16:47:00'),
(33, 'user_012', 'khachhang012@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Huỳnh Phương Tú', '0341751743', N'Số 8, Đường Lê Lợi, Hạ Long, Quảng Ninh', '1993-09-04', 0, 1, 'LOCAL', 1, 0, '2026-02-05 15:50:00'),
(34, 'user_013', 'khachhang013@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Phương Hiền', '0373708940', N'Số 21, Đường Lý Thường Kiệt, TP. Hải Dương, Hải Dương', '2004-12-08', 0, 1, 'LOCAL', 1, 0, '2025-12-01 09:24:00'),
(35, 'user_014', 'khachhang014@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bùi Đức Tài', '0891447935', N'Số 306, Đường Võ Văn Kiệt, Đống Đa, Hà Nội', '1990-04-23', 1, 1, 'LOCAL', 1, 0, '2025-02-03 13:48:00'),
(36, 'user_015', 'khachhang015@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bùi Mai Hà', '0781703827', N'Số 227, Đường Nam Kỳ Khởi Nghĩa, TP. Hải Dương, Hải Dương', '1997-01-03', 0, 1, 'LOCAL', 1, 0, '2025-01-14 14:19:00'),
(37, 'user_016', 'khachhang016@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Ngô Thu Huyền', '0884346645', N'Số 124, Đường Điện Biên Phủ, Hoàng Mai, Hà Nội', '2002-03-02', 0, 1, 'LOCAL', 1, 0, '2026-07-03 19:32:00'),
(38, 'user_017', 'khachhang017@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Huỳnh Quỳnh Lam', '0375383607', N'Số 256, Đường Điện Biên Phủ, Hạ Long, Quảng Ninh', '1987-02-12', 0, 1, 'LOCAL', 1, 0, '2024-11-09 20:47:00'),
(39, 'user_018', 'khachhang018@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đặng Tiến Linh', '0335222576', N'Số 256, Đường Hoàng Hoa Thám, Chí Linh, Hải Dương', '1989-09-07', 1, 1, 'LOCAL', 1, 0, '2024-02-08 09:11:00'),
(40, 'user_019', 'khachhang019@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Hữu Tùng', '0350947551', N'Số 192, Đường Lý Thường Kiệt, Chí Linh, Hải Dương', '1995-04-13', 1, 1, 'LOCAL', 1, 0, '2025-01-01 12:15:00'),
(41, 'user_020', 'khachhang020@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Võ Hải Châu', '0378480742', N'Số 315, Đường Kim Mã, Cầu Giấy, Hà Nội', '1992-09-03', 0, 1, 'LOCAL', 1, 0, '2025-10-23 10:35:00'),
(42, 'user_021', 'khachhang021@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hồ Phương Châu', '0979639175', N'Số 5, Đường Giải Phóng, Hoàn Kiếm, Hà Nội', '2000-12-20', 0, 1, 'LOCAL', 1, 0, '2025-04-26 15:41:00'),
(43, 'user_022', 'khachhang022@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Thu Huyền', '0774600619', N'Số 243, Đường Hoàng Hoa Thám, Ngô Quyền, Hải Phòng', '1991-07-10', 0, 1, 'LOCAL', 1, 0, '2025-09-28 14:34:00'),
(44, 'user_023', 'khachhang023@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Đức Khoa', '0702080086', N'Số 11, Đường Hoàng Hoa Thám, Từ Sơn, Bắc Ninh', '1989-02-08', 1, 1, 'LOCAL', 1, 0, '2026-07-09 12:43:00'),
(45, 'user_024', 'khachhang024@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Ánh Trâm', '0335564163', N'Số 278, Đường Cách Mạng Tháng 8, TP. Bắc Ninh, Bắc Ninh', '1987-11-12', 0, 1, 'LOCAL', 1, 0, '2026-08-14 12:38:00'),
(46, 'user_025', 'khachhang025@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Ánh Lam', '0334016186', N'Số 26, Đường Điện Biên Phủ, Ngô Quyền, Hải Phòng', '1987-12-03', 0, 1, 'LOCAL', 1, 0, '2026-08-26 13:11:00'),
(47, 'user_026', 'khachhang026@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phan Xuân Tài', '0323948945', N'Số 53, Đường Điện Biên Phủ, Cẩm Phả, Quảng Ninh', '1991-11-10', 1, 1, 'LOCAL', 1, 0, '2025-09-21 11:24:00'),
(48, 'user_027', 'khachhang027@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bùi Thu Ngọc', '0377265239', N'Số 249, Đường Cách Mạng Tháng 8, Lê Chân, Hải Phòng', '1995-09-21', 0, 1, 'LOCAL', 1, 0, '2026-05-19 13:11:00'),
(49, 'user_028', 'khachhang028@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hồ Tiến Thắng', '0374860862', N'Số 179, Đường Điện Biên Phủ, Uông Bí, Quảng Ninh', '1997-07-04', 1, 1, 'LOCAL', 1, 0, '2026-03-28 19:18:00'),
(50, 'user_029', 'khachhang029@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lê Khánh Hà', '0982088779', N'Số 51, Đường Trường Chinh, Hạ Long, Quảng Ninh', '1996-08-21', 0, 1, 'LOCAL', 1, 0, '2025-08-25 17:28:00'),
(51, 'user_030', 'khachhang030@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hoàng Ngọc Linh', '0369150908', N'Số 51, Đường Võ Thị Sáu, TP. Hải Dương, Hải Dương', '1988-06-26', 0, 1, 'LOCAL', 1, 0, '2025-12-18 21:16:00'),
(52, 'user_031', 'khachhang031@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Nguyễn Bảo Tùng', '0907206088', N'Số 48, Đường Kim Mã, Cẩm Phả, Quảng Ninh', '1987-12-15', 1, 1, 'LOCAL', 1, 0, '2025-10-22 21:26:00'),
(53, 'user_032', 'khachhang032@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hồ Thị Trâm', '0349014260', N'Số 341, Đường Lý Thường Kiệt, Hải An, Hải Phòng', '2004-04-10', 0, 1, 'LOCAL', 1, 0, '2024-02-05 18:42:00'),
(54, 'user_033', 'khachhang033@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bùi Quỳnh Thảo', '0709493169', N'Số 206, Đường Nguyễn Văn Cừ, Hạ Long, Quảng Ninh', '1987-11-17', 0, 1, 'LOCAL', 1, 0, '2026-06-08 19:31:00'),
(55, 'user_034', 'khachhang034@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Huỳnh Đức Khoa', '0777610058', N'Số 330, Đường Võ Thị Sáu, Uông Bí, Quảng Ninh', '2002-09-06', 1, 1, 'LOCAL', 1, 0, '2025-01-22 10:16:00'),
(56, 'user_035', 'khachhang035@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đỗ Mỹ Linh', '0898730533', N'Số 236, Đường Nguyễn Trãi, TP. Bắc Ninh, Bắc Ninh', '1987-08-27', 0, 1, 'LOCAL', 1, 0, '2024-07-15 15:54:00'),
(57, 'user_036', 'khachhang036@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Bảo Nhân', '0887145631', N'Số 267, Đường Nguyễn Huệ, TP. Hải Dương, Hải Dương', '1986-06-28', 1, 1, 'LOCAL', 1, 0, '2024-01-20 14:41:00'),
(58, 'user_037', 'khachhang037@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Võ Quỳnh Hằng', '0705110527', N'Số 143, Đường Kim Mã, Long Biên, Hà Nội', '1989-11-22', 0, 1, 'LOCAL', 1, 0, '2025-01-21 14:22:00'),
(59, 'user_038', 'khachhang038@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đặng Trúc Hà', '0761979308', N'Số 311, Đường Võ Văn Kiệt, Long Biên, Hà Nội', '1986-07-06', 0, 1, 'LOCAL', 1, 0, '2026-05-25 19:25:00'),
(60, 'user_039', 'khachhang039@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Võ Diệu Mai', '0902454947', N'Số 68, Đường Nguyễn Văn Cừ, Yên Phong, Bắc Ninh', '2002-02-08', 0, 1, 'LOCAL', 1, 0, '2026-06-14 15:51:00'),
(61, 'user_040', 'khachhang040@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Nguyễn Thu Hà', '0392103196', N'Số 145, Đường Nam Kỳ Khởi Nghĩa, Chí Linh, Hải Dương', '2001-03-21', 0, 1, 'LOCAL', 1, 0, '2025-07-17 09:50:00');

-- Khách hàng Khu vực Miền Nam (TP. Hồ Chí Minh, Bình Dương, Đồng Nai, Cần Thơ, Vũng Tàu)
INSERT INTO users (id, username, email, password, full_name, phone, address, birthday, gender, enabled, auth_provider, status, force_change_password, created_at) VALUES
(62, 'user_041', 'khachhang041@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phan Mai Châu', '0971563352', N'Số 323, Đường Võ Văn Kiệt, TP. Vũng Tàu, Vũng Tàu', '1995-03-11', 0, 1, 'LOCAL', 1, 0, '2025-08-04 15:41:00'),
(63, 'user_042', 'khachhang042@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Ngô Thành Hải', '0371536772', N'Số 279, Đường Nam Kỳ Khởi Nghĩa, TP. Vũng Tàu, Vũng Tàu', '2003-05-17', 1, 1, 'LOCAL', 1, 0, '2026-01-22 10:57:00'),
(64, 'user_043', 'khachhang043@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hoàng Thị Duyên', '0784797534', N'Số 76, Đường Điện Biên Phủ, Bà Rịa, Vũng Tàu', '2004-12-23', 0, 1, 'LOCAL', 1, 0, '2026-02-08 19:16:00'),
(65, 'user_044', 'khachhang044@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hoàng Đức Cường', '0397241440', N'Số 342, Đường Nam Kỳ Khởi Nghĩa, Thủ Dầu Một, Bình Dương', '1993-09-24', 1, 1, 'LOCAL', 1, 0, '2025-09-25 13:15:00'),
(66, 'user_045', 'khachhang045@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Vũ Tiến Linh', '0368971020', N'Số 11, Đường Hoàng Hoa Thám, Biên Hòa, Đồng Nai', '1997-04-21', 1, 1, 'LOCAL', 1, 0, '2025-02-26 08:57:00'),
(67, 'user_046', 'khachhang046@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Huỳnh Gia Quân', '0379342131', N'Số 88, Đường Cách Mạng Tháng 8, Thuận An, Bình Dương', '1993-08-06', 1, 1, 'LOCAL', 1, 0, '2024-10-03 20:16:00'),
(68, 'user_047', 'khachhang047@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Diệu Trang', '0898391307', N'Số 243, Đường Cầu Giấy, Quận 1, TP. Hồ Chí Minh', '1992-08-02', 0, 1, 'LOCAL', 1, 0, '2024-03-18 11:22:00'),
(69, 'user_048', 'khachhang048@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hoàng Đức Long', '0385765838', N'Số 338, Đường Giải Phóng, TP. Vũng Tàu, Vũng Tàu', '1998-02-24', 1, 1, 'LOCAL', 1, 0, '2026-07-11 11:13:00'),
(70, 'user_049', 'khachhang049@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Huỳnh Hữu Khải', '0980016432', N'Số 139, Đường Võ Thị Sáu, Quận 8, TP. Hồ Chí Minh', '1994-11-07', 1, 1, 'LOCAL', 1, 0, '2024-05-25 18:23:00'),
(71, 'user_050', 'khachhang050@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Dương Thị Lam', '0347084450', N'Số 239, Đường Phan Chu Trinh, Bình Thủy, Cần Thơ', '1996-05-23', 0, 1, 'LOCAL', 1, 0, '2025-09-12 08:50:00'),
(72, 'user_051', 'khachhang051@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đặng Anh Tài', '0387027574', N'Số 74, Đường Nguyễn Trãi, Bến Cát, Bình Dương', '1998-05-05', 1, 1, 'LOCAL', 1, 0, '2025-06-19 09:18:00'),
(73, 'user_052', 'khachhang052@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hoàng Tuyết Yến', '0946636303', N'Số 163, Đường Nguyễn Trãi, Biên Hòa, Đồng Nai', '2004-08-25', 0, 1, 'LOCAL', 1, 0, '2026-05-03 17:49:00'),
(74, 'user_053', 'khachhang053@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Võ Mai Trâm', '0891413000', N'Số 144, Đường Trường Chinh, Biên Hòa, Đồng Nai', '1992-10-19', 0, 1, 'LOCAL', 1, 0, '2026-01-02 20:59:00'),
(75, 'user_054', 'khachhang054@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đặng Tuyết Tú', '0397942675', N'Số 329, Đường Lê Lợi, Long Thành, Đồng Nai', '1993-02-16', 0, 1, 'LOCAL', 1, 0, '2024-06-10 09:13:00'),
(76, 'user_055', 'khachhang055@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Vũ Tuấn Tuấn', '0702646000', N'Số 114, Đường Lê Lợi, Long Thành, Đồng Nai', '2004-01-25', 1, 1, 'LOCAL', 1, 0, '2025-11-12 10:46:00'),
(77, 'user_056', 'khachhang056@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Vũ Thị Hiền', '0794999113', N'Số 254, Đường Trường Chinh, Bình Thủy, Cần Thơ', '1987-04-24', 0, 1, 'LOCAL', 1, 0, '2025-04-09 18:30:00'),
(78, 'user_057', 'khachhang057@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đỗ Mỹ Duyên', '0917675559', N'Số 332, Đường Hai Bà Trưng, Bến Cát, Bình Dương', '1995-08-26', 0, 1, 'LOCAL', 1, 0, '2025-05-23 20:12:00'),
(79, 'user_058', 'khachhang058@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đặng Thu Hằng', '0910176628', N'Số 260, Đường Phan Chu Trinh, Quận 8, TP. Hồ Chí Minh', '2004-01-06', 0, 1, 'LOCAL', 1, 0, '2026-04-14 16:38:00'),
(80, 'user_059', 'khachhang059@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Dương Thu Hương', '0788444505', N'Số 5, Đường Điện Biên Phủ, Dĩ An, Bình Dương', '1992-05-14', 0, 1, 'LOCAL', 1, 0, '2026-03-09 21:23:00'),
(81, 'user_060', 'khachhang060@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Ngô Quỳnh Nhi', '0914027898', N'Số 164, Đường Nguyễn Trãi, TP. Vũng Tàu, Vũng Tàu', '1999-03-10', 0, 1, 'LOCAL', 1, 0, '2024-09-23 19:49:00'),
(82, 'user_061', 'khachhang061@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Ngọc Nhi', '0980124165', N'Số 286, Đường Lý Thường Kiệt, Ninh Kiều, Cần Thơ', '1991-11-05', 0, 1, 'LOCAL', 1, 0, '2025-04-12 18:10:00'),
(83, 'user_062', 'khachhang062@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Tuyết Hằng', '0324694166', N'Số 153, Đường Nguyễn Trãi, Biên Hòa, Đồng Nai', '1986-03-18', 0, 1, 'LOCAL', 1, 0, '2024-09-05 21:29:00'),
(84, 'user_063', 'khachhang063@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phan Gia Nhân', '0897611949', N'Số 214, Đường Giải Phóng, Quận 7, TP. Hồ Chí Minh', '1986-11-08', 1, 1, 'LOCAL', 1, 0, '2024-06-21 21:24:00'),
(85, 'user_064', 'khachhang064@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Dương Thành Phong', '0325167896', N'Số 79, Đường Lê Lợi, Bình Tân, TP. Hồ Chí Minh', '1988-05-12', 1, 1, 'LOCAL', 1, 0, '2025-12-03 09:18:00'),
(86, 'user_065', 'khachhang065@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Tuấn Khang', '0782431498', N'Số 116, Đường Phan Chu Trinh, Quận 5, TP. Hồ Chí Minh', '2002-05-17', 1, 1, 'LOCAL', 1, 0, '2025-07-18 13:10:00'),
(87, 'user_066', 'khachhang066@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lê Bảo Khang', '0331904313', N'Số 179, Đường Nam Kỳ Khởi Nghĩa, Bến Cát, Bình Dương', '1998-02-26', 1, 1, 'LOCAL', 1, 0, '2026-08-13 09:53:00'),
(88, 'user_067', 'khachhang067@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Hữu Khang', '0335495093', N'Số 201, Đường Hai Bà Trưng, Long Thành, Đồng Nai', '1992-12-22', 1, 1, 'LOCAL', 1, 0, '2026-02-17 11:35:00'),
(89, 'user_068', 'khachhang068@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Thanh Yến', '0388122814', N'Số 54, Đường Hai Bà Trưng, Long Thành, Đồng Nai', '2003-08-24', 0, 1, 'LOCAL', 1, 0, '2024-02-01 18:39:00'),
(90, 'user_069', 'khachhang069@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Xuân Linh', '0385123967', N'Số 63, Đường Hoàng Hoa Thám, Bà Rịa, Vũng Tàu', '1999-11-13', 1, 1, 'LOCAL', 1, 0, '2026-07-12 15:12:00'),
(91, 'user_070', 'khachhang070@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phạm Trọng Tùng', '0773858790', N'Số 149, Đường Trần Hưng Đạo, Long Thành, Đồng Nai', '1996-01-18', 1, 1, 'LOCAL', 1, 0, '2024-12-02 13:25:00'),
(92, 'user_071', 'khachhang071@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phạm Thanh Châu', '0399506476', N'Số 100, Đường Nguyễn Trãi, Dĩ An, Bình Dương', '1987-11-02', 0, 1, 'LOCAL', 1, 0, '2025-09-05 14:48:00'),
(93, 'user_072', 'khachhang072@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phan Văn Tuấn', '0346610055', N'Số 204, Đường Nguyễn Văn Cừ, TP. Thủ Đức, TP. Hồ Chí Minh', '2004-03-17', 1, 1, 'LOCAL', 1, 0, '2024-10-02 09:17:00'),
(94, 'user_073', 'khachhang073@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phan Thu Vy', '0353024846', N'Số 341, Đường Võ Văn Kiệt, Tân Bình, TP. Hồ Chí Minh', '1996-04-12', 0, 1, 'LOCAL', 1, 0, '2026-07-10 12:31:00'),
(95, 'user_074', 'khachhang074@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Võ Ánh Tú', '0944495641', N'Số 316, Đường Cách Mạng Tháng 8, Bình Thủy, Cần Thơ', '1990-07-25', 0, 1, 'LOCAL', 1, 0, '2026-07-14 09:23:00'),
(96, 'user_075', 'khachhang075@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phan Minh Huy', '0935324714', N'Số 329, Đường Lê Lợi, Long Thành, Đồng Nai', '1988-03-27', 1, 1, 'LOCAL', 1, 0, '2025-05-07 20:36:00'),
(97, 'user_076', 'khachhang076@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bùi Văn Long', '0392282195', N'Số 84, Đường Lê Lợi, Gò Vấp, TP. Hồ Chí Minh', '1992-05-20', 1, 1, 'LOCAL', 1, 0, '2025-01-23 15:53:00'),
(98, 'user_077', 'khachhang077@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phạm Ánh Hà', '0767110104', N'Số 95, Đường Lê Lợi, Long Thành, Đồng Nai', '1989-11-17', 0, 1, 'LOCAL', 1, 0, '2026-03-17 16:57:00'),
(99, 'user_078', 'khachhang078@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Thu Yến', '0896567924', N'Số 201, Đường Nam Kỳ Khởi Nghĩa, Phú Nhuận, TP. Hồ Chí Minh', '2004-12-28', 0, 1, 'LOCAL', 1, 0, '2026-04-27 21:55:00'),
(100, 'user_079', 'khachhang079@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Thị Tâm', '0394698813', N'Số 342, Đường Điện Biên Phủ, Quận 7, TP. Hồ Chí Minh', '2003-09-23', 0, 1, 'LOCAL', 1, 0, '2024-04-27 10:11:00'),
(101, 'user_080', 'khachhang080@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Nguyễn Khánh Hiền', '0893177987', N'Số 37, Đường Nam Kỳ Khởi Nghĩa, Biên Hòa, Đồng Nai', '1992-10-25', 0, 1, 'LOCAL', 1, 0, '2024-04-09 21:13:00');

-- Khách hàng Khu vực Miền Trung & Tây Nguyên (Đà Nẵng, Huế, Nha Trang, Quảng Nam, Bình Định)
INSERT INTO users (id, username, email, password, full_name, phone, address, birthday, gender, enabled, auth_provider, status, force_change_password, created_at) VALUES
(102, 'user_081', 'khachhang081@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Dương Minh Sơn', '0977810640', N'Số 236, Đường Lý Thường Kiệt, Hội An, Quảng Nam', '2000-02-25', 1, 1, 'LOCAL', 1, 0, '2024-06-26 21:11:00'),
(103, 'user_082', 'khachhang082@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lê Bảo Đạt', '0918069328', N'Số 1, Đường Cầu Giấy, Hội An, Quảng Nam', '1995-01-25', 1, 1, 'LOCAL', 1, 0, '2025-06-15 21:10:00'),
(104, 'user_083', 'khachhang083@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Diệu Hương', '0325891709', N'Số 137, Đường Kim Mã, Hội An, Quảng Nam', '1999-02-04', 0, 1, 'LOCAL', 1, 0, '2026-04-17 19:11:00'),
(105, 'user_084', 'khachhang084@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bùi Tuấn Khải', '0340297323', N'Số 325, Đường Nam Kỳ Khởi Nghĩa, TP. Huế, Huế', '2003-06-18', 1, 1, 'LOCAL', 1, 0, '2024-11-14 08:49:00'),
(106, 'user_085', 'khachhang085@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Vũ Thành Hưng', '0765836119', N'Số 110, Đường Nguyễn Văn Cừ, Quy Nhơn, Bình Định', '1993-03-23', 1, 1, 'LOCAL', 1, 0, '2025-03-15 15:13:00'),
(107, 'user_086', 'khachhang086@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phan Ánh Trang', '0964472757', N'Số 134, Đường Điện Biên Phủ, Quy Nhơn, Bình Định', '1994-06-06', 0, 1, 'LOCAL', 1, 0, '2024-06-09 10:19:00'),
(108, 'user_087', 'khachhang087@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Dương Ánh Hằng', '0945397620', N'Số 65, Đường Lê Lợi, TP. Huế, Huế', '1999-07-17', 0, 1, 'LOCAL', 1, 0, '2026-06-09 14:23:00'),
(109, 'user_088', 'khachhang088@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Vũ Hữu Khải', '0866958749', N'Số 295, Đường Nguyễn Văn Cừ, Ngũ Hành Sơn, Đà Nẵng', '2004-04-22', 1, 1, 'LOCAL', 1, 0, '2026-06-20 18:12:00'),
(110, 'user_089', 'khachhang089@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Ngô Bảo Hải', '0894063447', N'Số 219, Đường Võ Văn Kiệt, Cam Ranh, Nha Trang', '1996-08-23', 1, 1, 'LOCAL', 1, 0, '2025-12-15 17:47:00'),
(111, 'user_090', 'khachhang090@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phạm Tiến Long', '0904368325', N'Số 110, Đường Kim Mã, TP. Huế, Huế', '1992-10-05', 1, 1, 'LOCAL', 1, 0, '2024-10-17 17:35:00'),
(112, 'user_091', 'khachhang091@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phạm Tuấn Cường', '0867685982', N'Số 248, Đường Cách Mạng Tháng 8, Hội An, Quảng Nam', '1999-04-25', 1, 1, 'LOCAL', 1, 0, '2026-07-13 10:44:00'),
(113, 'user_092', 'khachhang092@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phan Trọng Quân', '0323358475', N'Số 139, Đường Lý Thường Kiệt, Hải Châu, Đà Nẵng', '1995-09-08', 1, 1, 'LOCAL', 1, 0, '2026-01-02 13:40:00'),
(114, 'user_093', 'khachhang093@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phan Đức Khoa', '0783142280', N'Số 337, Đường Hoàng Hoa Thám, TP. Huế, Huế', '1997-12-09', 1, 1, 'LOCAL', 1, 0, '2026-03-18 14:11:00'),
(115, 'user_094', 'khachhang094@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Thị Tâm', '0399233423', N'Số 70, Đường Võ Văn Kiệt, TP. Nha Trang, Nha Trang', '1987-11-09', 0, 1, 'LOCAL', 1, 0, '2026-06-20 17:42:00'),
(116, 'user_095', 'khachhang095@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Gia Khang', '0709254254', N'Số 73, Đường Trần Hưng Đạo, Sơn Trà, Đà Nẵng', '1993-12-08', 1, 1, 'LOCAL', 1, 0, '2024-08-14 11:16:00'),
(117, 'user_096', 'khachhang096@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Dương Gia Tùng', '0365684010', N'Số 192, Đường Võ Văn Kiệt, Thanh Khê, Đà Nẵng', '2002-12-02', 1, 1, 'LOCAL', 1, 0, '2024-01-06 08:47:00'),
(118, 'user_097', 'khachhang097@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Vũ Xuân Long', '0974394074', N'Số 69, Đường Điện Biên Phủ, Sơn Trà, Đà Nẵng', '2002-12-04', 1, 1, 'LOCAL', 1, 0, '2025-05-11 08:50:00'),
(119, 'user_098', 'khachhang098@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Dương Gia Đạt', '0780761573', N'Số 200, Đường Võ Thị Sáu, Quy Nhơn, Bình Định', '1986-05-18', 1, 1, 'LOCAL', 1, 0, '2026-06-24 10:44:00'),
(120, 'user_099', 'khachhang099@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Ngô Bảo Hải', '0983077196', N'Số 23, Đường Điện Biên Phủ, Hội An, Quảng Nam', '1992-04-28', 1, 1, 'LOCAL', 1, 0, '2024-05-04 15:24:00'),
(121, 'user_100', 'khachhang100@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đặng Hải Anh', '0934773116', N'Số 16, Đường Hai Bà Trưng, Cẩm Lệ, Đà Nẵng', '2000-10-03', 0, 1, 'LOCAL', 1, 0, '2024-07-08 18:20:00');

SET IDENTITY_INSERT users OFF;
DBCC CHECKIDENT ('users', RESEED, 121);
GO

-- ----------------------------------------------------------------------------
-- 7.4. PHÂN QUYỀN USER_ROLES THEO TỪNG NHÓM (ADMIN -> STAFF -> USER)
-- ----------------------------------------------------------------------------
-- Nhóm 1: Tài khoản Quản trị viên (ADMIN)
INSERT INTO user_roles (user_id, role_id) VALUES (1, 1);

-- Nhóm 2: 20 Tài khoản Nhân viên (STAFF)
INSERT INTO user_roles (user_id, role_id) VALUES
(2, 3),
(3, 3),
(4, 3),
(5, 3),
(6, 3),
(7, 3),
(8, 3),
(9, 3),
(10, 3),
(11, 3),
(12, 3),
(13, 3),
(14, 3),
(15, 3),
(16, 3),
(17, 3),
(18, 3),
(19, 3),
(20, 3),
(21, 3);

-- Nhóm 3: 100 Tài khoản Khách hàng (USER)
INSERT INTO user_roles (user_id, role_id) VALUES
(22, 2),
(23, 2),
(24, 2),
(25, 2),
(26, 2),
(27, 2),
(28, 2),
(29, 2),
(30, 2),
(31, 2),
(32, 2),
(33, 2),
(34, 2),
(35, 2),
(36, 2),
(37, 2),
(38, 2),
(39, 2),
(40, 2),
(41, 2),
(42, 2),
(43, 2),
(44, 2),
(45, 2),
(46, 2),
(47, 2),
(48, 2),
(49, 2),
(50, 2),
(51, 2),
(52, 2),
(53, 2),
(54, 2),
(55, 2),
(56, 2),
(57, 2),
(58, 2),
(59, 2),
(60, 2),
(61, 2),
(62, 2),
(63, 2),
(64, 2),
(65, 2),
(66, 2),
(67, 2),
(68, 2),
(69, 2),
(70, 2),
(71, 2),
(72, 2),
(73, 2),
(74, 2),
(75, 2),
(76, 2),
(77, 2),
(78, 2),
(79, 2),
(80, 2),
(81, 2),
(82, 2),
(83, 2),
(84, 2),
(85, 2),
(86, 2),
(87, 2),
(88, 2),
(89, 2),
(90, 2),
(91, 2),
(92, 2),
(93, 2),
(94, 2),
(95, 2),
(96, 2),
(97, 2),
(98, 2),
(99, 2),
(100, 2),
(101, 2),
(102, 2),
(103, 2),
(104, 2),
(105, 2),
(106, 2),
(107, 2),
(108, 2),
(109, 2),
(110, 2),
(111, 2),
(112, 2),
(113, 2),
(114, 2),
(115, 2),
(116, 2),
(117, 2),
(118, 2),
(119, 2),
(120, 2),
(121, 2);
GO

-- ----------------------------------------------------------------------------
-- 7.5. ĐỊA CHỈ GIAO HÀNG (SHIPPING_ADDRESSES) MẪU CHO KHÁCH HÀNG
-- ----------------------------------------------------------------------------
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES
(22, N'Dương Khánh Anh', '0796568181', N'Số 135, Đường Cầu Giấy, Hoàng Mai, Hà Nội', N'Hà Nội', N'Hoàng Mai', 1),
(23, N'Huỳnh Thu Huyền', '0335636784', N'Số 93, Đường Nguyễn Trãi, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', N'TP. Bắc Ninh', 1),
(24, N'Vũ Khánh Ngọc', '0969809398', N'Số 271, Đường Võ Văn Kiệt, Uông Bí, Quảng Ninh', N'Quảng Ninh', N'Uông Bí', 1),
(25, N'Đặng Hải Châu', '0883687942', N'Số 85, Đường Võ Văn Kiệt, Tây Hồ, Hà Nội', N'Hà Nội', N'Tây Hồ', 1),
(26, N'Đặng Mỹ Lam', '0989557017', N'Số 23, Đường Hai Bà Trưng, Hồng Bàng, Hải Phòng', N'Hải Phòng', N'Hồng Bàng', 1),
(27, N'Trần Trọng Quân', '0970703321', N'Số 329, Đường Hai Bà Trưng, Đống Đa, Hà Nội', N'Hà Nội', N'Đống Đa', 1),
(28, N'Lý Tuấn Tùng', '0797839946', N'Số 40, Đường Giải Phóng, Ngô Quyền, Hải Phòng', N'Hải Phòng', N'Ngô Quyền', 1),
(29, N'Hồ Mai Linh', '0884008436', N'Số 113, Đường Nguyễn Huệ, Tây Hồ, Hà Nội', N'Hà Nội', N'Tây Hồ', 1),
(30, N'Bùi Gia Quân', '0912109582', N'Số 164, Đường Trần Hưng Đạo, Hồng Bàng, Hải Phòng', N'Hải Phòng', N'Hồng Bàng', 1),
(31, N'Huỳnh Ánh Tú', '0394172699', N'Số 65, Đường Cách Mạng Tháng 8, TP. Hải Dương, Hải Dương', N'Hải Dương', N'TP. Hải Dương', 1),
(32, N'Đỗ Xuân Nam', '0930760927', N'Số 151, Đường Nguyễn Huệ, Hoàng Mai, Hà Nội', N'Hà Nội', N'Hoàng Mai', 1),
(33, N'Huỳnh Phương Tú', '0341751743', N'Số 8, Đường Lê Lợi, Hạ Long, Quảng Ninh', N'Quảng Ninh', N'Hạ Long', 1),
(34, N'Lý Phương Hiền', '0373708940', N'Số 21, Đường Lý Thường Kiệt, TP. Hải Dương, Hải Dương', N'Hải Dương', N'TP. Hải Dương', 1),
(35, N'Bùi Đức Tài', '0891447935', N'Số 306, Đường Võ Văn Kiệt, Đống Đa, Hà Nội', N'Hà Nội', N'Đống Đa', 1),
(36, N'Bùi Mai Hà', '0781703827', N'Số 227, Đường Nam Kỳ Khởi Nghĩa, TP. Hải Dương, Hải Dương', N'Hải Dương', N'TP. Hải Dương', 1),
(37, N'Ngô Thu Huyền', '0884346645', N'Số 124, Đường Điện Biên Phủ, Hoàng Mai, Hà Nội', N'Hà Nội', N'Hoàng Mai', 1),
(38, N'Huỳnh Quỳnh Lam', '0375383607', N'Số 256, Đường Điện Biên Phủ, Hạ Long, Quảng Ninh', N'Quảng Ninh', N'Hạ Long', 1),
(39, N'Đặng Tiến Linh', '0335222576', N'Số 256, Đường Hoàng Hoa Thám, Chí Linh, Hải Dương', N'Hải Dương', N'Chí Linh', 1),
(40, N'Lý Hữu Tùng', '0350947551', N'Số 192, Đường Lý Thường Kiệt, Chí Linh, Hải Dương', N'Hải Dương', N'Chí Linh', 1),
(41, N'Võ Hải Châu', '0378480742', N'Số 315, Đường Kim Mã, Cầu Giấy, Hà Nội', N'Hà Nội', N'Cầu Giấy', 1),
(42, N'Hồ Phương Châu', '0979639175', N'Số 5, Đường Giải Phóng, Hoàn Kiếm, Hà Nội', N'Hà Nội', N'Hoàn Kiếm', 1),
(43, N'Lý Thu Huyền', '0774600619', N'Số 243, Đường Hoàng Hoa Thám, Ngô Quyền, Hải Phòng', N'Hải Phòng', N'Ngô Quyền', 1),
(44, N'Lý Đức Khoa', '0702080086', N'Số 11, Đường Hoàng Hoa Thám, Từ Sơn, Bắc Ninh', N'Bắc Ninh', N'Từ Sơn', 1),
(45, N'Lý Ánh Trâm', '0335564163', N'Số 278, Đường Cách Mạng Tháng 8, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', N'TP. Bắc Ninh', 1),
(46, N'Lý Ánh Lam', '0334016186', N'Số 26, Đường Điện Biên Phủ, Ngô Quyền, Hải Phòng', N'Hải Phòng', N'Ngô Quyền', 1),
(47, N'Phan Xuân Tài', '0323948945', N'Số 53, Đường Điện Biên Phủ, Cẩm Phả, Quảng Ninh', N'Quảng Ninh', N'Cẩm Phả', 1),
(48, N'Bùi Thu Ngọc', '0377265239', N'Số 249, Đường Cách Mạng Tháng 8, Lê Chân, Hải Phòng', N'Hải Phòng', N'Lê Chân', 1),
(49, N'Hồ Tiến Thắng', '0374860862', N'Số 179, Đường Điện Biên Phủ, Uông Bí, Quảng Ninh', N'Quảng Ninh', N'Uông Bí', 1),
(50, N'Lê Khánh Hà', '0982088779', N'Số 51, Đường Trường Chinh, Hạ Long, Quảng Ninh', N'Quảng Ninh', N'Hạ Long', 1),
(51, N'Hoàng Ngọc Linh', '0369150908', N'Số 51, Đường Võ Thị Sáu, TP. Hải Dương, Hải Dương', N'Hải Dương', N'TP. Hải Dương', 1),
(52, N'Nguyễn Bảo Tùng', '0907206088', N'Số 48, Đường Kim Mã, Cẩm Phả, Quảng Ninh', N'Quảng Ninh', N'Cẩm Phả', 1),
(53, N'Hồ Thị Trâm', '0349014260', N'Số 341, Đường Lý Thường Kiệt, Hải An, Hải Phòng', N'Hải Phòng', N'Hải An', 1),
(54, N'Bùi Quỳnh Thảo', '0709493169', N'Số 206, Đường Nguyễn Văn Cừ, Hạ Long, Quảng Ninh', N'Quảng Ninh', N'Hạ Long', 1),
(55, N'Huỳnh Đức Khoa', '0777610058', N'Số 330, Đường Võ Thị Sáu, Uông Bí, Quảng Ninh', N'Quảng Ninh', N'Uông Bí', 1),
(56, N'Đỗ Mỹ Linh', '0898730533', N'Số 236, Đường Nguyễn Trãi, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', N'TP. Bắc Ninh', 1),
(57, N'Lý Bảo Nhân', '0887145631', N'Số 267, Đường Nguyễn Huệ, TP. Hải Dương, Hải Dương', N'Hải Dương', N'TP. Hải Dương', 1),
(58, N'Võ Quỳnh Hằng', '0705110527', N'Số 143, Đường Kim Mã, Long Biên, Hà Nội', N'Hà Nội', N'Long Biên', 1),
(59, N'Đặng Trúc Hà', '0761979308', N'Số 311, Đường Võ Văn Kiệt, Long Biên, Hà Nội', N'Hà Nội', N'Long Biên', 1),
(60, N'Võ Diệu Mai', '0902454947', N'Số 68, Đường Nguyễn Văn Cừ, Yên Phong, Bắc Ninh', N'Bắc Ninh', N'Yên Phong', 1),
(61, N'Nguyễn Thu Hà', '0392103196', N'Số 145, Đường Nam Kỳ Khởi Nghĩa, Chí Linh, Hải Dương', N'Hải Dương', N'Chí Linh', 1),
(62, N'Phan Mai Châu', '0971563352', N'Số 323, Đường Võ Văn Kiệt, TP. Vũng Tàu, Vũng Tàu', N'Vũng Tàu', N'TP. Vũng Tàu', 1),
(63, N'Ngô Thành Hải', '0371536772', N'Số 279, Đường Nam Kỳ Khởi Nghĩa, TP. Vũng Tàu, Vũng Tàu', N'Vũng Tàu', N'TP. Vũng Tàu', 1),
(64, N'Hoàng Thị Duyên', '0784797534', N'Số 76, Đường Điện Biên Phủ, Bà Rịa, Vũng Tàu', N'Vũng Tàu', N'Bà Rịa', 1),
(65, N'Hoàng Đức Cường', '0397241440', N'Số 342, Đường Nam Kỳ Khởi Nghĩa, Thủ Dầu Một, Bình Dương', N'Bình Dương', N'Thủ Dầu Một', 1),
(66, N'Vũ Tiến Linh', '0368971020', N'Số 11, Đường Hoàng Hoa Thám, Biên Hòa, Đồng Nai', N'Đồng Nai', N'Biên Hòa', 1),
(67, N'Huỳnh Gia Quân', '0379342131', N'Số 88, Đường Cách Mạng Tháng 8, Thuận An, Bình Dương', N'Bình Dương', N'Thuận An', 1),
(68, N'Lý Diệu Trang', '0898391307', N'Số 243, Đường Cầu Giấy, Quận 1, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', N'Quận 1', 1),
(69, N'Hoàng Đức Long', '0385765838', N'Số 338, Đường Giải Phóng, TP. Vũng Tàu, Vũng Tàu', N'Vũng Tàu', N'TP. Vũng Tàu', 1),
(70, N'Huỳnh Hữu Khải', '0980016432', N'Số 139, Đường Võ Thị Sáu, Quận 8, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', N'Quận 8', 1),
(71, N'Dương Thị Lam', '0347084450', N'Số 239, Đường Phan Chu Trinh, Bình Thủy, Cần Thơ', N'Cần Thơ', N'Bình Thủy', 1),
(72, N'Đặng Anh Tài', '0387027574', N'Số 74, Đường Nguyễn Trãi, Bến Cát, Bình Dương', N'Bình Dương', N'Bến Cát', 1),
(73, N'Hoàng Tuyết Yến', '0946636303', N'Số 163, Đường Nguyễn Trãi, Biên Hòa, Đồng Nai', N'Đồng Nai', N'Biên Hòa', 1),
(74, N'Võ Mai Trâm', '0891413000', N'Số 144, Đường Trường Chinh, Biên Hòa, Đồng Nai', N'Đồng Nai', N'Biên Hòa', 1),
(75, N'Đặng Tuyết Tú', '0397942675', N'Số 329, Đường Lê Lợi, Long Thành, Đồng Nai', N'Đồng Nai', N'Long Thành', 1),
(76, N'Vũ Tuấn Tuấn', '0702646000', N'Số 114, Đường Lê Lợi, Long Thành, Đồng Nai', N'Đồng Nai', N'Long Thành', 1),
(77, N'Vũ Thị Hiền', '0794999113', N'Số 254, Đường Trường Chinh, Bình Thủy, Cần Thơ', N'Cần Thơ', N'Bình Thủy', 1),
(78, N'Đỗ Mỹ Duyên', '0917675559', N'Số 332, Đường Hai Bà Trưng, Bến Cát, Bình Dương', N'Bình Dương', N'Bến Cát', 1),
(79, N'Đặng Thu Hằng', '0910176628', N'Số 260, Đường Phan Chu Trinh, Quận 8, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', N'Quận 8', 1),
(80, N'Dương Thu Hương', '0788444505', N'Số 5, Đường Điện Biên Phủ, Dĩ An, Bình Dương', N'Bình Dương', N'Dĩ An', 1),
(81, N'Ngô Quỳnh Nhi', '0914027898', N'Số 164, Đường Nguyễn Trãi, TP. Vũng Tàu, Vũng Tàu', N'Vũng Tàu', N'TP. Vũng Tàu', 1);
GO

-- ============================================================================
-- 8. 200 ĐƠN HÀNG ĐA DẠNG NGÀY THÁNG (2024 -> 03/09/2026) & CÓ VOUCHER CHUẨN
-- ============================================================================

SET IDENTITY_INSERT orders ON;

INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at) VALUES
(1, 87, 'LXR2410270001', N'Lê Bảo Khang', 'khachhang066@gmail.com', '0331904313', N'Số 179, Đường Nam Kỳ Khởi Nghĩa, Bến Cát, Bình Dương', N'Bình Dương', 750000.00, 0.00, NULL, 'DELIVERED', 'INSTALLMENT', 1, 0, '2024-10-27 04:43:43'),
(2, 59, 'LXR2608230002', N'Đặng Trúc Hà', 'khachhang038@gmail.com', '0761979308', N'Số 311, Đường Võ Văn Kiệt, Long Biên, Hà Nội', N'Hà Nội', 1785000.00, 315000.00, 'LXR36', 'SHIPPING', 'COD', 1, 0, '2026-08-23 02:07:10'),
(3, 81, 'LXR2405020003', N'Ngô Quỳnh Nhi', 'khachhang060@gmail.com', '0914027898', N'Số 164, Đường Nguyễn Trãi, TP. Vũng Tàu, Vũng Tàu', N'Vũng Tàu', 13600000.00, 0.00, NULL, 'DELIVERED', 'VNPAY', 1, 0, '2024-05-02 05:55:04'),
(4, 102, 'LXR2501140004', N'Dương Minh Sơn', 'khachhang081@gmail.com', '0977810640', N'Số 236, Đường Lý Thường Kiệt, Hội An, Quảng Nam', N'Quảng Nam', 16300000.00, 2000000.00, 'LUX30', 'PAID', 'VNPAY', 1, 0, '2025-01-14 11:21:31'),
(5, 81, 'LXR2504270005', N'Ngô Quỳnh Nhi', 'khachhang060@gmail.com', '0914027898', N'Số 164, Đường Nguyễn Trãi, TP. Vũng Tàu, Vũng Tàu', N'Vũng Tàu', 32400000.00, 2000000.00, 'LUX30', 'PAID', 'COD', 1, 0, '2025-04-27 12:15:50'),
(6, 61, 'LXR2605290006', N'Nguyễn Thu Hà', 'khachhang040@gmail.com', '0392103196', N'Số 145, Đường Nam Kỳ Khởi Nghĩa, Chí Linh, Hải Dương', N'Hải Dương', 1890000.00, 210000.00, 'LUX10', 'CONFIRMED', 'MOMO', 0, 0, '2026-05-29 06:03:43'),
(7, 71, 'LXR2405270007', N'Dương Thị Lam', 'khachhang050@gmail.com', '0347084450', N'Số 239, Đường Phan Chu Trinh, Bình Thủy, Cần Thơ', N'Cần Thơ', 3360000.00, 1440000.00, 'LUX30', 'CONFIRMED', 'INSTALLMENT', 0, 0, '2024-05-27 10:18:18'),
(8, 41, 'LXR2405270008', N'Võ Hải Châu', 'khachhang020@gmail.com', '0378480742', N'Số 315, Đường Kim Mã, Cầu Giấy, Hà Nội', N'Hà Nội', 1050000.00, 1050000.00, 'LUX50', 'SHIPPING', 'BANK_TRANSFER', 1, 0, '2024-05-27 22:05:39'),
(9, 55, 'LXR2504070009', N'Huỳnh Đức Khoa', 'khachhang034@gmail.com', '0777610058', N'Số 330, Đường Võ Thị Sáu, Uông Bí, Quảng Ninh', N'Quảng Ninh', 47100000.00, 0.00, NULL, 'SHIPPING', 'BANK_TRANSFER', 1, 0, '2025-04-07 14:22:55'),
(10, 111, 'LXR2406290010', N'Phạm Tiến Long', 'khachhang090@gmail.com', '0904368325', N'Số 110, Đường Kim Mã, TP. Huế, Huế', N'Huế', 1450000.00, 0.00, NULL, 'DELIVERED', 'VNPAY', 1, 0, '2024-06-29 00:02:37'),
(11, 72, 'LXR2411060011', N'Đặng Anh Tài', 'khachhang051@gmail.com', '0387027574', N'Số 74, Đường Nguyễn Trãi, Bến Cát, Bình Dương', N'Bình Dương', 2600000.00, 0.00, NULL, 'PAID', 'VNPAY', 1, 0, '2024-11-06 15:34:48'),
(12, 102, 'LXR2602030012', N'Dương Minh Sơn', 'khachhang081@gmail.com', '0977810640', N'Số 236, Đường Lý Thường Kiệt, Hội An, Quảng Nam', N'Quảng Nam', 31400000.00, 2000000.00, 'LUX10', 'SHIPPING', 'MOMO', 1, 0, '2026-02-03 18:46:40'),
(13, 110, 'LXR2607040013', N'Ngô Bảo Hải', 'khachhang089@gmail.com', '0894063447', N'Số 219, Đường Võ Văn Kiệt, Cam Ranh, Nha Trang', N'Nha Trang', 8800000.00, 2000000.00, 'LUX50', 'PAID', 'COD', 1, 0, '2026-07-04 13:45:21'),
(14, 82, 'LXR2404300014', N'Trần Ngọc Nhi', 'khachhang061@gmail.com', '0980124165', N'Số 286, Đường Lý Thường Kiệt, Ninh Kiều, Cần Thơ', N'Cần Thơ', 68000000.00, 2000000.00, 'LXR36', 'SHIPPING', 'VNPAY', 1, 0, '2024-04-30 18:20:06'),
(15, 76, 'LXR2603250015', N'Vũ Tuấn Tuấn', 'khachhang055@gmail.com', '0702646000', N'Số 114, Đường Lê Lợi, Long Thành, Đồng Nai', N'Đồng Nai', 1700000.00, 1700000.00, 'LUX50', 'PENDING', 'INSTALLMENT', 0, 0, '2026-03-25 05:50:42'),
(16, 104, 'LXR2511110016', N'Trần Diệu Hương', 'khachhang083@gmail.com', '0325891709', N'Số 137, Đường Kim Mã, Hội An, Quảng Nam', N'Quảng Nam', 50500000.00, 0.00, NULL, 'PAID', 'COD', 1, 0, '2025-11-11 03:04:02'),
(17, 39, 'LXR2503210017', N'Đặng Tiến Linh', 'khachhang018@gmail.com', '0335222576', N'Số 256, Đường Hoàng Hoa Thám, Chí Linh, Hải Dương', N'Hải Dương', 81300000.00, 2000000.00, 'LUX10', 'PAID', 'INSTALLMENT', 1, 0, '2025-03-21 03:01:06'),
(18, 85, 'LXR2508260018', N'Dương Thành Phong', 'khachhang064@gmail.com', '0325167896', N'Số 79, Đường Lê Lợi, Bình Tân, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 52750000.00, 0.00, NULL, 'SHIPPING', 'MOMO', 1, 0, '2025-08-26 13:05:11'),
(19, 53, 'LXR2512200019', N'Hồ Thị Trâm', 'khachhang032@gmail.com', '0349014260', N'Số 341, Đường Lý Thường Kiệt, Hải An, Hải Phòng', N'Hải Phòng', 43800000.00, 2000000.00, 'LUX10', 'PAID', 'VNPAY', 1, 0, '2025-12-20 08:28:57'),
(20, 104, 'LXR2403240020', N'Trần Diệu Hương', 'khachhang083@gmail.com', '0325891709', N'Số 137, Đường Kim Mã, Hội An, Quảng Nam', N'Quảng Nam', 5900000.00, 0.00, NULL, 'PAID', 'COD', 1, 0, '2024-03-24 05:33:09'),
(21, 115, 'LXR2607030021', N'Lý Thị Tâm', 'khachhang094@gmail.com', '0399233423', N'Số 70, Đường Võ Văn Kiệt, TP. Nha Trang, Nha Trang', N'Nha Trang', 8200000.00, 0.00, NULL, 'PENDING', 'VNPAY', 0, 0, '2026-07-03 00:46:40'),
(22, 78, 'LXR2603130022', N'Đỗ Mỹ Duyên', 'khachhang057@gmail.com', '0917675559', N'Số 332, Đường Hai Bà Trưng, Bến Cát, Bình Dương', N'Bình Dương', 63500000.00, 0.00, NULL, 'PENDING', 'BANK_TRANSFER', 0, 0, '2026-03-13 10:12:40'),
(23, 46, 'LXR2409170023', N'Lý Ánh Lam', 'khachhang025@gmail.com', '0334016186', N'Số 26, Đường Điện Biên Phủ, Ngô Quyền, Hải Phòng', N'Hải Phòng', 21600000.00, 0.00, NULL, 'CONFIRMED', 'COD', 0, 0, '2024-09-17 07:47:45'),
(24, 61, 'LXR2512160024', N'Nguyễn Thu Hà', 'khachhang040@gmail.com', '0392103196', N'Số 145, Đường Nam Kỳ Khởi Nghĩa, Chí Linh, Hải Dương', N'Hải Dương', 4550000.00, 0.00, NULL, 'CONFIRMED', 'VNPAY', 0, 0, '2025-12-16 14:26:01'),
(25, 110, 'LXR2407030025', N'Ngô Bảo Hải', 'khachhang089@gmail.com', '0894063447', N'Số 219, Đường Võ Văn Kiệt, Cam Ranh, Nha Trang', N'Nha Trang', 38950000.00, 0.00, NULL, 'PAID', 'INSTALLMENT', 1, 0, '2024-07-03 22:21:27'),
(26, 104, 'LXR2502050026', N'Trần Diệu Hương', 'khachhang083@gmail.com', '0325891709', N'Số 137, Đường Kim Mã, Hội An, Quảng Nam', N'Quảng Nam', 10400000.00, 2000000.00, 'LUX30', 'SHIPPING', 'BANK_TRANSFER', 1, 0, '2025-02-05 05:37:28'),
(27, 104, 'LXR2510140027', N'Trần Diệu Hương', 'khachhang083@gmail.com', '0325891709', N'Số 137, Đường Kim Mã, Hội An, Quảng Nam', N'Quảng Nam', 9800000.00, 0.00, NULL, 'PROCESSING', 'INSTALLMENT', 1, 0, '2025-10-14 17:06:08'),
(28, 98, 'LXR2510290028', N'Phạm Ánh Hà', 'khachhang077@gmail.com', '0767110104', N'Số 95, Đường Lê Lợi, Long Thành, Đồng Nai', N'Đồng Nai', 59600000.00, 0.00, NULL, 'DELIVERED', 'MOMO', 1, 0, '2025-10-29 11:56:29'),
(29, 103, 'LXR2412280029', N'Lê Bảo Đạt', 'khachhang082@gmail.com', '0918069328', N'Số 1, Đường Cầu Giấy, Hội An, Quảng Nam', N'Quảng Nam', 7650000.00, 850000.00, 'LUX10', 'PROCESSING', 'MOMO', 1, 0, '2024-12-28 11:52:00'),
(30, 37, 'LXR2602250030', N'Ngô Thu Huyền', 'khachhang016@gmail.com', '0884346645', N'Số 124, Đường Điện Biên Phủ, Hoàng Mai, Hà Nội', N'Hà Nội', 4340000.00, 1860000.00, 'LUX30', 'PAID', 'SEPAY_QR', 1, 0, '2026-02-25 09:15:46'),
(31, 64, 'LXR2502250031', N'Hoàng Thị Duyên', 'khachhang043@gmail.com', '0784797534', N'Số 76, Đường Điện Biên Phủ, Bà Rịa, Vũng Tàu', N'Vũng Tàu', 2800000.00, 2000000.00, 'LUX50', 'SHIPPING', 'COD', 1, 0, '2025-02-25 07:45:35'),
(32, 63, 'LXR2412190032', N'Ngô Thành Hải', 'khachhang042@gmail.com', '0371536772', N'Số 279, Đường Nam Kỳ Khởi Nghĩa, TP. Vũng Tàu, Vũng Tàu', N'Vũng Tàu', 2500000.00, 2000000.00, 'LUX50', 'SHIPPING', 'VNPAY', 1, 0, '2024-12-19 20:20:46'),
(33, 82, 'LXR2508300033', N'Trần Ngọc Nhi', 'khachhang061@gmail.com', '0980124165', N'Số 286, Đường Lý Thường Kiệt, Ninh Kiều, Cần Thơ', N'Cần Thơ', 14400000.00, 2000000.00, 'LUX50', 'PROCESSING', 'COD', 1, 0, '2025-08-30 05:09:07'),
(34, 114, 'LXR2606010034', N'Phan Đức Khoa', 'khachhang093@gmail.com', '0783142280', N'Số 337, Đường Hoàng Hoa Thám, TP. Huế, Huế', N'Huế', 15500000.00, 0.00, NULL, 'SHIPPING', 'BANK_TRANSFER', 1, 0, '2026-06-01 06:18:31'),
(35, 40, 'LXR2411020035', N'Lý Hữu Tùng', 'khachhang019@gmail.com', '0350947551', N'Số 192, Đường Lý Thường Kiệt, Chí Linh, Hải Dương', N'Hải Dương', 2100000.00, 0.00, NULL, 'DELIVERED', 'BANK_TRANSFER', 1, 0, '2024-11-02 23:49:10'),
(36, 62, 'LXR2411270036', N'Phan Mai Châu', 'khachhang041@gmail.com', '0971563352', N'Số 323, Đường Võ Văn Kiệt, TP. Vũng Tàu, Vũng Tàu', N'Vũng Tàu', 18900000.00, 0.00, NULL, 'PROCESSING', 'COD', 1, 0, '2024-11-27 20:01:43'),
(37, 76, 'LXR2412110037', N'Vũ Tuấn Tuấn', 'khachhang055@gmail.com', '0702646000', N'Số 114, Đường Lê Lợi, Long Thành, Đồng Nai', N'Đồng Nai', 11500000.00, 0.00, NULL, 'DELIVERED', 'INSTALLMENT', 1, 0, '2024-12-11 21:45:38'),
(38, 112, 'LXR2404060038', N'Phạm Tuấn Cường', 'khachhang091@gmail.com', '0867685982', N'Số 248, Đường Cách Mạng Tháng 8, Hội An, Quảng Nam', N'Quảng Nam', 12600000.00, 2000000.00, 'LUX30', 'DELIVERED', 'INSTALLMENT', 1, 0, '2024-04-06 16:07:44'),
(39, 78, 'LXR2603070039', N'Đỗ Mỹ Duyên', 'khachhang057@gmail.com', '0917675559', N'Số 332, Đường Hai Bà Trưng, Bến Cát, Bình Dương', N'Bình Dương', 7950000.00, 2000000.00, 'LUX30', 'PAID', 'COD', 1, 0, '2026-03-07 23:24:20'),
(40, 53, 'LXR2409260040', N'Hồ Thị Trâm', 'khachhang032@gmail.com', '0349014260', N'Số 341, Đường Lý Thường Kiệt, Hải An, Hải Phòng', N'Hải Phòng', 72300000.00, 2000000.00, 'LUX30', 'PROCESSING', 'COD', 1, 0, '2024-09-26 19:43:56'),
(41, 87, 'LXR2504180041', N'Lê Bảo Khang', 'khachhang066@gmail.com', '0331904313', N'Số 179, Đường Nam Kỳ Khởi Nghĩa, Bến Cát, Bình Dương', N'Bình Dương', 7225000.00, 1275000.00, 'LXR36', 'PROCESSING', 'SEPAY_QR', 1, 0, '2025-04-18 13:54:06'),
(42, 96, 'LXR2601230042', N'Phan Minh Huy', 'khachhang075@gmail.com', '0935324714', N'Số 329, Đường Lê Lợi, Long Thành, Đồng Nai', N'Đồng Nai', 11500000.00, 0.00, NULL, 'PAID', 'INSTALLMENT', 1, 0, '2026-01-23 01:13:16'),
(43, 61, 'LXR2405180043', N'Nguyễn Thu Hà', 'khachhang040@gmail.com', '0392103196', N'Số 145, Đường Nam Kỳ Khởi Nghĩa, Chí Linh, Hải Dương', N'Hải Dương', 4750000.00, 0.00, NULL, 'CANCELLED', 'VNPAY', 0, 1, '2024-05-18 19:04:40'),
(44, 56, 'LXR2507050044', N'Đỗ Mỹ Linh', 'khachhang035@gmail.com', '0898730533', N'Số 236, Đường Nguyễn Trãi, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 8800000.00, 2000000.00, 'LUX50', 'PAID', 'BANK_TRANSFER', 1, 0, '2025-07-05 19:20:47'),
(45, 54, 'LXR2403220045', N'Bùi Quỳnh Thảo', 'khachhang033@gmail.com', '0709493169', N'Số 206, Đường Nguyễn Văn Cừ, Hạ Long, Quảng Ninh', N'Quảng Ninh', 57500000.00, 0.00, NULL, 'PAID', 'INSTALLMENT', 1, 0, '2024-03-22 17:39:49'),
(46, 107, 'LXR2503140046', N'Phan Ánh Trang', 'khachhang086@gmail.com', '0964472757', N'Số 134, Đường Điện Biên Phủ, Quy Nhơn, Bình Định', N'Bình Định', 2600000.00, 0.00, NULL, 'CONFIRMED', 'SEPAY_QR', 0, 0, '2025-03-14 11:50:13'),
(47, 40, 'LXR2510150047', N'Lý Hữu Tùng', 'khachhang019@gmail.com', '0350947551', N'Số 192, Đường Lý Thường Kiệt, Chí Linh, Hải Dương', N'Hải Dương', 2100000.00, 0.00, NULL, 'PAID', 'INSTALLMENT', 1, 0, '2025-10-15 18:39:11'),
(48, 41, 'LXR2607250048', N'Võ Hải Châu', 'khachhang020@gmail.com', '0378480742', N'Số 315, Đường Kim Mã, Cầu Giấy, Hà Nội', N'Hà Nội', 6950000.00, 2000000.00, 'LUX50', 'PAID', 'BANK_TRANSFER', 1, 0, '2026-07-25 17:39:46'),
(49, 90, 'LXR2408070049', N'Trần Xuân Linh', 'khachhang069@gmail.com', '0385123967', N'Số 63, Đường Hoàng Hoa Thám, Bà Rịa, Vũng Tàu', N'Vũng Tàu', 11400000.00, 0.00, NULL, 'DELIVERED', 'MOMO', 1, 0, '2024-08-07 04:29:54'),
(50, 120, 'LXR2405230050', N'Ngô Bảo Hải', 'khachhang099@gmail.com', '0983077196', N'Số 23, Đường Điện Biên Phủ, Hội An, Quảng Nam', N'Quảng Nam', 7400000.00, 0.00, NULL, 'PAID', 'MOMO', 1, 0, '2024-05-23 20:13:02'),
(51, 28, 'LXR2502160051', N'Lý Tuấn Tùng', 'khachhang007@gmail.com', '0797839946', N'Số 40, Đường Giải Phóng, Ngô Quyền, Hải Phòng', N'Hải Phòng', 11500000.00, 0.00, NULL, 'CONFIRMED', 'INSTALLMENT', 0, 0, '2025-02-16 09:08:15'),
(52, 72, 'LXR2406120052', N'Đặng Anh Tài', 'khachhang051@gmail.com', '0387027574', N'Số 74, Đường Nguyễn Trãi, Bến Cát, Bình Dương', N'Bình Dương', 60200000.00, 2000000.00, 'LUX50', 'CONFIRMED', 'MOMO', 0, 0, '2024-06-12 11:39:54'),
(53, 83, 'LXR2509060053', N'Lý Tuyết Hằng', 'khachhang062@gmail.com', '0324694166', N'Số 153, Đường Nguyễn Trãi, Biên Hòa, Đồng Nai', N'Đồng Nai', 38800000.00, 0.00, NULL, 'CANCELLED', 'SEPAY_QR', 0, 1, '2025-09-06 05:39:17'),
(54, 55, 'LXR2604120054', N'Huỳnh Đức Khoa', 'khachhang034@gmail.com', '0777610058', N'Số 330, Đường Võ Thị Sáu, Uông Bí, Quảng Ninh', N'Quảng Ninh', 62300000.00, 0.00, NULL, 'CANCELLED', 'SEPAY_QR', 0, 1, '2026-04-12 16:59:55'),
(55, 110, 'LXR2606130055', N'Ngô Bảo Hải', 'khachhang089@gmail.com', '0894063447', N'Số 219, Đường Võ Văn Kiệt, Cam Ranh, Nha Trang', N'Nha Trang', 17700000.00, 0.00, NULL, 'DELIVERED', 'BANK_TRANSFER', 1, 0, '2026-06-13 08:20:40'),
(56, 46, 'LXR2411230056', N'Lý Ánh Lam', 'khachhang025@gmail.com', '0334016186', N'Số 26, Đường Điện Biên Phủ, Ngô Quyền, Hải Phòng', N'Hải Phòng', 2100000.00, 0.00, NULL, 'CANCELLED', 'COD', 0, 1, '2024-11-23 11:48:12'),
(57, 117, 'LXR2602220057', N'Dương Gia Tùng', 'khachhang096@gmail.com', '0365684010', N'Số 192, Đường Võ Văn Kiệt, Thanh Khê, Đà Nẵng', N'Đà Nẵng', 15200000.00, 2000000.00, 'LUX30', 'CONFIRMED', 'VNPAY', 0, 0, '2026-02-22 03:46:05'),
(58, 47, 'LXR2501130058', N'Phan Xuân Tài', 'khachhang026@gmail.com', '0323948945', N'Số 53, Đường Điện Biên Phủ, Cẩm Phả, Quảng Ninh', N'Quảng Ninh', 3700000.00, 2000000.00, 'LUX50', 'SHIPPING', 'SEPAY_QR', 1, 0, '2025-01-13 13:48:50'),
(59, 39, 'LXR2512270059', N'Đặng Tiến Linh', 'khachhang018@gmail.com', '0335222576', N'Số 256, Đường Hoàng Hoa Thám, Chí Linh, Hải Dương', N'Hải Dương', 55500000.00, 2000000.00, 'LUX30', 'PROCESSING', 'SEPAY_QR', 1, 0, '2025-12-27 10:29:15'),
(60, 77, 'LXR2501130060', N'Vũ Thị Hiền', 'khachhang056@gmail.com', '0794999113', N'Số 254, Đường Trường Chinh, Bình Thủy, Cần Thơ', N'Cần Thơ', 9500000.00, 2000000.00, 'LUX50', 'PAID', 'INSTALLMENT', 1, 0, '2025-01-13 08:21:07'),
(61, 38, 'LXR2410050061', N'Huỳnh Quỳnh Lam', 'khachhang017@gmail.com', '0375383607', N'Số 256, Đường Điện Biên Phủ, Hạ Long, Quảng Ninh', N'Quảng Ninh', 2800000.00, 2000000.00, 'LUX50', 'PROCESSING', 'MOMO', 1, 0, '2024-10-05 07:46:59'),
(62, 108, 'LXR2406170062', N'Dương Ánh Hằng', 'khachhang087@gmail.com', '0945397620', N'Số 65, Đường Lê Lợi, TP. Huế, Huế', N'Huế', 3825000.00, 675000.00, 'LXR36', 'PAID', 'INSTALLMENT', 1, 0, '2024-06-17 09:25:42'),
(63, 58, 'LXR2602080063', N'Võ Quỳnh Hằng', 'khachhang037@gmail.com', '0705110527', N'Số 143, Đường Kim Mã, Long Biên, Hà Nội', N'Hà Nội', 8700000.00, 0.00, NULL, 'SHIPPING', 'MOMO', 1, 0, '2026-02-08 09:55:48'),
(64, 44, 'LXR2411280064', N'Lý Đức Khoa', 'khachhang023@gmail.com', '0702080086', N'Số 11, Đường Hoàng Hoa Thám, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 15480000.00, 1720000.00, 'LUX10', 'DELIVERED', 'MOMO', 1, 0, '2024-11-28 07:38:38'),
(65, 69, 'LXR2505210065', N'Hoàng Đức Long', 'khachhang048@gmail.com', '0385765838', N'Số 338, Đường Giải Phóng, TP. Vũng Tàu, Vũng Tàu', N'Vũng Tàu', 10800000.00, 0.00, NULL, 'PENDING', 'SEPAY_QR', 0, 0, '2025-05-21 08:38:26'),
(66, 113, 'LXR2606120066', N'Phan Trọng Quân', 'khachhang092@gmail.com', '0323358475', N'Số 139, Đường Lý Thường Kiệt, Hải Châu, Đà Nẵng', N'Đà Nẵng', 16400000.00, 0.00, NULL, 'DELIVERED', 'BANK_TRANSFER', 1, 0, '2026-06-12 16:16:03'),
(67, 69, 'LXR2505280067', N'Hoàng Đức Long', 'khachhang048@gmail.com', '0385765838', N'Số 338, Đường Giải Phóng, TP. Vũng Tàu, Vũng Tàu', N'Vũng Tàu', 1305000.00, 145000.00, 'LUX10', 'PAID', 'COD', 1, 0, '2025-05-28 17:38:34'),
(68, 52, 'LXR2507260068', N'Nguyễn Bảo Tùng', 'khachhang031@gmail.com', '0907206088', N'Số 48, Đường Kim Mã, Cẩm Phả, Quảng Ninh', N'Quảng Ninh', 1200000.00, 0.00, NULL, 'SHIPPING', 'INSTALLMENT', 1, 0, '2025-07-26 13:10:30'),
(69, 44, 'LXR2512130069', N'Lý Đức Khoa', 'khachhang023@gmail.com', '0702080086', N'Số 11, Đường Hoàng Hoa Thám, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 20000000.00, 0.00, NULL, 'CONFIRMED', 'MOMO', 0, 0, '2025-12-13 17:20:44'),
(70, 55, 'LXR2505230070', N'Huỳnh Đức Khoa', 'khachhang034@gmail.com', '0777610058', N'Số 330, Đường Võ Thị Sáu, Uông Bí, Quảng Ninh', N'Quảng Ninh', 2100000.00, 0.00, NULL, 'CONFIRMED', 'MOMO', 0, 0, '2025-05-23 04:17:58'),
(71, 46, 'LXR2601250071', N'Lý Ánh Lam', 'khachhang025@gmail.com', '0334016186', N'Số 26, Đường Điện Biên Phủ, Ngô Quyền, Hải Phòng', N'Hải Phòng', 41800000.00, 0.00, NULL, 'DELIVERED', 'BANK_TRANSFER', 1, 0, '2026-01-25 05:27:34'),
(72, 121, 'LXR2511050072', N'Đặng Hải Anh', 'khachhang100@gmail.com', '0934773116', N'Số 16, Đường Hai Bà Trưng, Cẩm Lệ, Đà Nẵng', N'Đà Nẵng', 37500000.00, 0.00, NULL, 'DELIVERED', 'SEPAY_QR', 1, 0, '2025-11-05 19:17:18'),
(73, 71, 'LXR2408140073', N'Dương Thị Lam', 'khachhang050@gmail.com', '0347084450', N'Số 239, Đường Phan Chu Trinh, Bình Thủy, Cần Thơ', N'Cần Thơ', 9775000.00, 1725000.00, 'LXR36', 'DELIVERED', 'SEPAY_QR', 1, 0, '2024-08-14 12:41:49'),
(74, 112, 'LXR2411020074', N'Phạm Tuấn Cường', 'khachhang091@gmail.com', '0867685982', N'Số 248, Đường Cách Mạng Tháng 8, Hội An, Quảng Nam', N'Quảng Nam', 17300000.00, 2000000.00, 'LUX50', 'PROCESSING', 'COD', 1, 0, '2024-11-02 06:08:26'),
(75, 30, 'LXR2511130075', N'Bùi Gia Quân', 'khachhang009@gmail.com', '0912109582', N'Số 164, Đường Trần Hưng Đạo, Hồng Bàng, Hải Phòng', N'Hải Phòng', 1900000.00, 1900000.00, 'LUX50', 'DELIVERED', 'MOMO', 1, 0, '2025-11-13 21:08:09'),
(76, 39, 'LXR2411170076', N'Đặng Tiến Linh', 'khachhang018@gmail.com', '0335222576', N'Số 256, Đường Hoàng Hoa Thám, Chí Linh, Hải Dương', N'Hải Dương', 7600000.00, 2000000.00, 'LUX30', 'DELIVERED', 'BANK_TRANSFER', 1, 0, '2024-11-17 13:30:29'),
(77, 103, 'LXR2601230077', N'Lê Bảo Đạt', 'khachhang082@gmail.com', '0918069328', N'Số 1, Đường Cầu Giấy, Hội An, Quảng Nam', N'Quảng Nam', 6480000.00, 720000.00, 'LUX10', 'SHIPPING', 'COD', 1, 0, '2026-01-23 02:57:12'),
(78, 76, 'LXR2604260078', N'Vũ Tuấn Tuấn', 'khachhang055@gmail.com', '0702646000', N'Số 114, Đường Lê Lợi, Long Thành, Đồng Nai', N'Đồng Nai', 4200000.00, 2000000.00, 'LUX50', 'PROCESSING', 'VNPAY', 1, 0, '2026-04-26 19:33:47'),
(79, 46, 'LXR2509110079', N'Lý Ánh Lam', 'khachhang025@gmail.com', '0334016186', N'Số 26, Đường Điện Biên Phủ, Ngô Quyền, Hải Phòng', N'Hải Phòng', 3060000.00, 340000.00, 'LUX10', 'CANCELLED', 'SEPAY_QR', 0, 1, '2025-09-11 16:05:38'),
(80, 92, 'LXR2508150080', N'Phạm Thanh Châu', 'khachhang071@gmail.com', '0399506476', N'Số 100, Đường Nguyễn Trãi, Dĩ An, Bình Dương', N'Bình Dương', 32400000.00, 2000000.00, 'LUX10', 'CONFIRMED', 'COD', 0, 0, '2025-08-15 05:30:01'),
(81, 71, 'LXR2510230081', N'Dương Thị Lam', 'khachhang050@gmail.com', '0347084450', N'Số 239, Đường Phan Chu Trinh, Bình Thủy, Cần Thơ', N'Cần Thơ', 50000000.00, 2000000.00, 'LUX10', 'DELIVERED', 'INSTALLMENT', 1, 0, '2025-10-23 09:08:21'),
(82, 108, 'LXR2608050082', N'Dương Ánh Hằng', 'khachhang087@gmail.com', '0945397620', N'Số 65, Đường Lê Lợi, TP. Huế, Huế', N'Huế', 24450000.00, 0.00, NULL, 'SHIPPING', 'VNPAY', 1, 0, '2026-08-05 23:51:25'),
(83, 53, 'LXR2408310083', N'Hồ Thị Trâm', 'khachhang032@gmail.com', '0349014260', N'Số 341, Đường Lý Thường Kiệt, Hải An, Hải Phòng', N'Hải Phòng', 17600000.00, 0.00, NULL, 'PAID', 'SEPAY_QR', 1, 0, '2024-08-31 04:47:03'),
(84, 67, 'LXR2509240084', N'Huỳnh Gia Quân', 'khachhang046@gmail.com', '0379342131', N'Số 88, Đường Cách Mạng Tháng 8, Thuận An, Bình Dương', N'Bình Dương', 2720000.00, 480000.00, 'LXR36', 'DELIVERED', 'SEPAY_QR', 1, 0, '2025-09-24 16:40:13'),
(85, 51, 'LXR2505220085', N'Hoàng Ngọc Linh', 'khachhang030@gmail.com', '0369150908', N'Số 51, Đường Võ Thị Sáu, TP. Hải Dương, Hải Dương', N'Hải Dương', 29900000.00, 0.00, NULL, 'PENDING', 'MOMO', 0, 0, '2025-05-22 05:14:49'),
(86, 72, 'LXR2510030086', N'Đặng Anh Tài', 'khachhang051@gmail.com', '0387027574', N'Số 74, Đường Nguyễn Trãi, Bến Cát, Bình Dương', N'Bình Dương', 29650000.00, 0.00, NULL, 'DELIVERED', 'MOMO', 1, 0, '2025-10-03 23:40:44'),
(87, 77, 'LXR2603060087', N'Vũ Thị Hiền', 'khachhang056@gmail.com', '0794999113', N'Số 254, Đường Trường Chinh, Bình Thủy, Cần Thơ', N'Cần Thơ', 13455000.00, 1495000.00, 'LUX10', 'PROCESSING', 'COD', 1, 0, '2026-03-06 19:12:04'),
(88, 37, 'LXR2507190088', N'Ngô Thu Huyền', 'khachhang016@gmail.com', '0884346645', N'Số 124, Đường Điện Biên Phủ, Hoàng Mai, Hà Nội', N'Hà Nội', 750000.00, 0.00, NULL, 'DELIVERED', 'INSTALLMENT', 1, 0, '2025-07-19 14:37:28'),
(89, 58, 'LXR2405090089', N'Võ Quỳnh Hằng', 'khachhang037@gmail.com', '0705110527', N'Số 143, Đường Kim Mã, Long Biên, Hà Nội', N'Hà Nội', 4335000.00, 765000.00, 'LXR36', 'PROCESSING', 'MOMO', 1, 0, '2024-05-09 22:37:37'),
(90, 39, 'LXR2602150090', N'Đặng Tiến Linh', 'khachhang018@gmail.com', '0335222576', N'Số 256, Đường Hoàng Hoa Thám, Chí Linh, Hải Dương', N'Hải Dương', 13500000.00, 2000000.00, 'LUX30', 'CONFIRMED', 'VNPAY', 0, 0, '2026-02-15 22:23:22'),
(91, 81, 'LXR2404090091', N'Ngô Quỳnh Nhi', 'khachhang060@gmail.com', '0914027898', N'Số 164, Đường Nguyễn Trãi, TP. Vũng Tàu, Vũng Tàu', N'Vũng Tàu', 6030000.00, 670000.00, 'LUX10', 'PAID', 'INSTALLMENT', 1, 0, '2024-04-09 18:09:55'),
(92, 44, 'LXR2504140092', N'Lý Đức Khoa', 'khachhang023@gmail.com', '0702080086', N'Số 11, Đường Hoàng Hoa Thám, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 20300000.00, 2000000.00, 'LUX30', 'PAID', 'VNPAY', 1, 0, '2025-04-14 14:29:09'),
(93, 72, 'LXR2503160093', N'Đặng Anh Tài', 'khachhang051@gmail.com', '0387027574', N'Số 74, Đường Nguyễn Trãi, Bến Cát, Bình Dương', N'Bình Dương', 2940000.00, 1260000.00, 'LUX30', 'PAID', 'VNPAY', 1, 0, '2025-03-16 22:01:21'),
(94, 40, 'LXR2503290094', N'Lý Hữu Tùng', 'khachhang019@gmail.com', '0350947551', N'Số 192, Đường Lý Thường Kiệt, Chí Linh, Hải Dương', N'Hải Dương', 19500000.00, 2000000.00, 'LUX10', 'PENDING', 'BANK_TRANSFER', 0, 0, '2025-03-29 00:41:15'),
(95, 57, 'LXR2410270095', N'Lý Bảo Nhân', 'khachhang036@gmail.com', '0887145631', N'Số 267, Đường Nguyễn Huệ, TP. Hải Dương, Hải Dương', N'Hải Dương', 13800000.00, 0.00, NULL, 'DELIVERED', 'INSTALLMENT', 1, 0, '2024-10-27 09:28:49'),
(96, 53, 'LXR2510060096', N'Hồ Thị Trâm', 'khachhang032@gmail.com', '0349014260', N'Số 341, Đường Lý Thường Kiệt, Hải An, Hải Phòng', N'Hải Phòng', 20700000.00, 0.00, NULL, 'SHIPPING', 'VNPAY', 1, 0, '2025-10-06 21:11:12'),
(97, 34, 'LXR2506120097', N'Lý Phương Hiền', 'khachhang013@gmail.com', '0373708940', N'Số 21, Đường Lý Thường Kiệt, TP. Hải Dương, Hải Dương', N'Hải Dương', 6200000.00, 0.00, NULL, 'DELIVERED', 'VNPAY', 1, 0, '2025-06-12 18:52:54'),
(98, 58, 'LXR2404300098', N'Võ Quỳnh Hằng', 'khachhang037@gmail.com', '0705110527', N'Số 143, Đường Kim Mã, Long Biên, Hà Nội', N'Hà Nội', 26600000.00, 2000000.00, 'LUX50', 'PAID', 'INSTALLMENT', 1, 0, '2024-04-30 08:35:33'),
(99, 121, 'LXR2508110099', N'Đặng Hải Anh', 'khachhang100@gmail.com', '0934773116', N'Số 16, Đường Hai Bà Trưng, Cẩm Lệ, Đà Nẵng', N'Đà Nẵng', 14100000.00, 0.00, NULL, 'DELIVERED', 'INSTALLMENT', 1, 0, '2025-08-11 17:07:18'),
(100, 68, 'LXR2604100100', N'Lý Diệu Trang', 'khachhang047@gmail.com', '0898391307', N'Số 243, Đường Cầu Giấy, Quận 1, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 1800000.00, 1800000.00, 'LUX50', 'CONFIRMED', 'SEPAY_QR', 0, 0, '2026-04-10 02:46:13'),
(101, 104, 'LXR2507280101', N'Trần Diệu Hương', 'khachhang083@gmail.com', '0325891709', N'Số 137, Đường Kim Mã, Hội An, Quảng Nam', N'Quảng Nam', 900000.00, 900000.00, 'LUX50', 'DELIVERED', 'SEPAY_QR', 1, 0, '2025-07-28 10:40:35'),
(102, 43, 'LXR2607050102', N'Lý Thu Huyền', 'khachhang022@gmail.com', '0774600619', N'Số 243, Đường Hoàng Hoa Thám, Ngô Quyền, Hải Phòng', N'Hải Phòng', 12300000.00, 2000000.00, 'LXR36', 'DELIVERED', 'INSTALLMENT', 1, 0, '2026-07-05 04:14:36'),
(103, 118, 'LXR2510150103', N'Vũ Xuân Long', 'khachhang097@gmail.com', '0974394074', N'Số 69, Đường Điện Biên Phủ, Sơn Trà, Đà Nẵng', N'Đà Nẵng', 39600000.00, 2000000.00, 'LUX50', 'PAID', 'VNPAY', 1, 0, '2025-10-15 04:27:59'),
(104, 65, 'LXR2604110104', N'Hoàng Đức Cường', 'khachhang044@gmail.com', '0397241440', N'Số 342, Đường Nam Kỳ Khởi Nghĩa, Thủ Dầu Một, Bình Dương', N'Bình Dương', 3800000.00, 0.00, NULL, 'SHIPPING', 'BANK_TRANSFER', 1, 0, '2026-04-11 13:33:24'),
(105, 61, 'LXR2405170105', N'Nguyễn Thu Hà', 'khachhang040@gmail.com', '0392103196', N'Số 145, Đường Nam Kỳ Khởi Nghĩa, Chí Linh, Hải Dương', N'Hải Dương', 3800000.00, 2000000.00, 'LUX50', 'PAID', 'INSTALLMENT', 1, 0, '2024-05-17 10:29:05'),
(106, 84, 'LXR2604120106', N'Phan Gia Nhân', 'khachhang063@gmail.com', '0897611949', N'Số 214, Đường Giải Phóng, Quận 7, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 42600000.00, 0.00, NULL, 'CANCELLED', 'INSTALLMENT', 0, 1, '2026-04-12 02:31:20'),
(107, 115, 'LXR2403190107', N'Lý Thị Tâm', 'khachhang094@gmail.com', '0399233423', N'Số 70, Đường Võ Văn Kiệt, TP. Nha Trang, Nha Trang', N'Nha Trang', 5300000.00, 0.00, NULL, 'PAID', 'MOMO', 1, 0, '2024-03-19 19:58:15'),
(108, 45, 'LXR2607130108', N'Lý Ánh Trâm', 'khachhang024@gmail.com', '0335564163', N'Số 278, Đường Cách Mạng Tháng 8, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 23300000.00, 0.00, NULL, 'PAID', 'SEPAY_QR', 1, 0, '2026-07-13 18:09:05'),
(109, 108, 'LXR2507090109', N'Dương Ánh Hằng', 'khachhang087@gmail.com', '0945397620', N'Số 65, Đường Lê Lợi, TP. Huế, Huế', N'Huế', 11600000.00, 2000000.00, 'LUX50', 'PROCESSING', 'MOMO', 1, 0, '2025-07-09 00:35:15'),
(110, 83, 'LXR2504140110', N'Lý Tuyết Hằng', 'khachhang062@gmail.com', '0324694166', N'Số 153, Đường Nguyễn Trãi, Biên Hòa, Đồng Nai', N'Đồng Nai', 21400000.00, 2000000.00, 'LUX50', 'PROCESSING', 'INSTALLMENT', 1, 0, '2025-04-14 00:42:17'),
(111, 109, 'LXR2511220111', N'Vũ Hữu Khải', 'khachhang088@gmail.com', '0866958749', N'Số 295, Đường Nguyễn Văn Cừ, Ngũ Hành Sơn, Đà Nẵng', N'Đà Nẵng', 43500000.00, 0.00, NULL, 'SHIPPING', 'BANK_TRANSFER', 1, 0, '2025-11-22 17:52:32'),
(112, 97, 'LXR2604050112', N'Bùi Văn Long', 'khachhang076@gmail.com', '0392282195', N'Số 84, Đường Lê Lợi, Gò Vấp, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 43750000.00, 2000000.00, 'LUX50', 'PAID', 'BANK_TRANSFER', 1, 0, '2026-04-05 22:23:41'),
(113, 37, 'LXR2604240113', N'Ngô Thu Huyền', 'khachhang016@gmail.com', '0884346645', N'Số 124, Đường Điện Biên Phủ, Hoàng Mai, Hà Nội', N'Hà Nội', 2100000.00, 0.00, NULL, 'SHIPPING', 'SEPAY_QR', 1, 0, '2026-04-24 16:08:03'),
(114, 78, 'LXR2604260114', N'Đỗ Mỹ Duyên', 'khachhang057@gmail.com', '0917675559', N'Số 332, Đường Hai Bà Trưng, Bến Cát, Bình Dương', N'Bình Dương', 1900000.00, 1900000.00, 'LUX50', 'PAID', 'MOMO', 1, 0, '2026-04-26 02:28:51'),
(115, 24, 'LXR2502050115', N'Vũ Khánh Ngọc', 'khachhang003@gmail.com', '0969809398', N'Số 271, Đường Võ Văn Kiệt, Uông Bí, Quảng Ninh', N'Quảng Ninh', 10900000.00, 0.00, NULL, 'PAID', 'VNPAY', 1, 0, '2025-02-05 04:55:18'),
(116, 34, 'LXR2409080116', N'Lý Phương Hiền', 'khachhang013@gmail.com', '0373708940', N'Số 21, Đường Lý Thường Kiệt, TP. Hải Dương, Hải Dương', N'Hải Dương', 16650000.00, 2000000.00, 'LUX30', 'SHIPPING', 'COD', 1, 0, '2024-09-08 03:27:15'),
(117, 95, 'LXR2510270117', N'Võ Ánh Tú', 'khachhang074@gmail.com', '0944495641', N'Số 316, Đường Cách Mạng Tháng 8, Bình Thủy, Cần Thơ', N'Cần Thơ', 9180000.00, 1620000.00, 'LXR36', 'PAID', 'BANK_TRANSFER', 1, 0, '2025-10-27 23:29:09'),
(118, 99, 'LXR2411040118', N'Lý Thu Yến', 'khachhang078@gmail.com', '0896567924', N'Số 201, Đường Nam Kỳ Khởi Nghĩa, Phú Nhuận, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 39900000.00, 0.00, NULL, 'SHIPPING', 'MOMO', 1, 0, '2024-11-04 19:55:35'),
(119, 24, 'LXR2410100119', N'Vũ Khánh Ngọc', 'khachhang003@gmail.com', '0969809398', N'Số 271, Đường Võ Văn Kiệt, Uông Bí, Quảng Ninh', N'Quảng Ninh', 7862500.00, 1387500.00, 'LXR36', 'CONFIRMED', 'INSTALLMENT', 0, 0, '2024-10-10 11:29:19'),
(120, 25, 'LXR2407240120', N'Đặng Hải Châu', 'khachhang004@gmail.com', '0883687942', N'Số 85, Đường Võ Văn Kiệt, Tây Hồ, Hà Nội', N'Hà Nội', 12200000.00, 0.00, NULL, 'PROCESSING', 'BANK_TRANSFER', 1, 0, '2024-07-24 14:11:07'),
(121, 99, 'LXR2605290121', N'Lý Thu Yến', 'khachhang078@gmail.com', '0896567924', N'Số 201, Đường Nam Kỳ Khởi Nghĩa, Phú Nhuận, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 38000000.00, 2000000.00, 'LXR36', 'SHIPPING', 'VNPAY', 1, 0, '2026-05-29 13:36:54'),
(122, 121, 'LXR2605180122', N'Đặng Hải Anh', 'khachhang100@gmail.com', '0934773116', N'Số 16, Đường Hai Bà Trưng, Cẩm Lệ, Đà Nẵng', N'Đà Nẵng', 17600000.00, 0.00, NULL, 'PAID', 'VNPAY', 1, 0, '2026-05-18 22:49:25'),
(123, 91, 'LXR2501240123', N'Phạm Trọng Tùng', 'khachhang070@gmail.com', '0773858790', N'Số 149, Đường Trần Hưng Đạo, Long Thành, Đồng Nai', N'Đồng Nai', 28900000.00, 2000000.00, 'LUX10', 'PAID', 'COD', 1, 0, '2025-01-24 02:11:56'),
(124, 57, 'LXR2404170124', N'Lý Bảo Nhân', 'khachhang036@gmail.com', '0887145631', N'Số 267, Đường Nguyễn Huệ, TP. Hải Dương, Hải Dương', N'Hải Dương', 80700000.00, 2000000.00, 'LUX30', 'SHIPPING', 'INSTALLMENT', 1, 0, '2024-04-17 14:54:19'),
(125, 104, 'LXR2602070125', N'Trần Diệu Hương', 'khachhang083@gmail.com', '0325891709', N'Số 137, Đường Kim Mã, Hội An, Quảng Nam', N'Quảng Nam', 9720000.00, 1080000.00, 'LUX10', 'SHIPPING', 'MOMO', 1, 0, '2026-02-07 10:25:01'),
(126, 58, 'LXR2603270126', N'Võ Quỳnh Hằng', 'khachhang037@gmail.com', '0705110527', N'Số 143, Đường Kim Mã, Long Biên, Hà Nội', N'Hà Nội', 52000000.00, 0.00, NULL, 'CONFIRMED', 'SEPAY_QR', 0, 0, '2026-03-27 21:36:54'),
(127, 25, 'LXR2502200127', N'Đặng Hải Châu', 'khachhang004@gmail.com', '0883687942', N'Số 85, Đường Võ Văn Kiệt, Tây Hồ, Hà Nội', N'Hà Nội', 750000.00, 0.00, NULL, 'SHIPPING', 'INSTALLMENT', 1, 0, '2025-02-20 06:36:10'),
(128, 31, 'LXR2505310128', N'Huỳnh Ánh Tú', 'khachhang010@gmail.com', '0394172699', N'Số 65, Đường Cách Mạng Tháng 8, TP. Hải Dương, Hải Dương', N'Hải Dương', 37000000.00, 0.00, NULL, 'DELIVERED', 'VNPAY', 1, 0, '2025-05-31 19:03:45'),
(129, 83, 'LXR2405290129', N'Lý Tuyết Hằng', 'khachhang062@gmail.com', '0324694166', N'Số 153, Đường Nguyễn Trãi, Biên Hòa, Đồng Nai', N'Đồng Nai', 1900000.00, 1900000.00, 'LUX50', 'PAID', 'COD', 1, 0, '2024-05-29 22:04:52'),
(130, 69, 'LXR2503260130', N'Hoàng Đức Long', 'khachhang048@gmail.com', '0385765838', N'Số 338, Đường Giải Phóng, TP. Vũng Tàu, Vũng Tàu', N'Vũng Tàu', 65300000.00, 2000000.00, 'LUX30', 'PAID', 'VNPAY', 1, 0, '2025-03-26 09:44:43'),
(131, 73, 'LXR2606010131', N'Hoàng Tuyết Yến', 'khachhang052@gmail.com', '0946636303', N'Số 163, Đường Nguyễn Trãi, Biên Hòa, Đồng Nai', N'Đồng Nai', 34200000.00, 2000000.00, 'LUX30', 'PAID', 'BANK_TRANSFER', 1, 0, '2026-06-01 02:32:07'),
(132, 32, 'LXR2601090132', N'Đỗ Xuân Nam', 'khachhang011@gmail.com', '0930760927', N'Số 151, Đường Nguyễn Huệ, Hoàng Mai, Hà Nội', N'Hà Nội', 10200000.00, 2000000.00, 'LUX30', 'PAID', 'MOMO', 1, 0, '2026-01-09 01:19:37'),
(133, 46, 'LXR2509120133', N'Lý Ánh Lam', 'khachhang025@gmail.com', '0334016186', N'Số 26, Đường Điện Biên Phủ, Ngô Quyền, Hải Phòng', N'Hải Phòng', 6200000.00, 2000000.00, 'LUX50', 'PENDING', 'BANK_TRANSFER', 0, 0, '2025-09-12 13:38:13'),
(134, 29, 'LXR2501040134', N'Hồ Mai Linh', 'khachhang008@gmail.com', '0884008436', N'Số 113, Đường Nguyễn Huệ, Tây Hồ, Hà Nội', N'Hà Nội', 13200000.00, 2000000.00, 'LUX50', 'DELIVERED', 'INSTALLMENT', 1, 0, '2025-01-04 00:40:18'),
(135, 29, 'LXR2410180135', N'Hồ Mai Linh', 'khachhang008@gmail.com', '0884008436', N'Số 113, Đường Nguyễn Huệ, Tây Hồ, Hà Nội', N'Hà Nội', 15480000.00, 1720000.00, 'LUX10', 'DELIVERED', 'SEPAY_QR', 1, 0, '2024-10-18 20:34:18'),
(136, 91, 'LXR2403180136', N'Phạm Trọng Tùng', 'khachhang070@gmail.com', '0773858790', N'Số 149, Đường Trần Hưng Đạo, Long Thành, Đồng Nai', N'Đồng Nai', 4800000.00, 0.00, NULL, 'PROCESSING', 'INSTALLMENT', 1, 0, '2024-03-18 07:47:58'),
(137, 29, 'LXR2607100137', N'Hồ Mai Linh', 'khachhang008@gmail.com', '0884008436', N'Số 113, Đường Nguyễn Huệ, Tây Hồ, Hà Nội', N'Hà Nội', 10300000.00, 0.00, NULL, 'PAID', 'MOMO', 1, 0, '2026-07-10 02:24:14'),
(138, 50, 'LXR2405080138', N'Lê Khánh Hà', 'khachhang029@gmail.com', '0982088779', N'Số 51, Đường Trường Chinh, Hạ Long, Quảng Ninh', N'Quảng Ninh', 3825000.00, 675000.00, 'LXR36', 'PAID', 'BANK_TRANSFER', 1, 0, '2024-05-08 04:40:47'),
(139, 32, 'LXR2602210139', N'Đỗ Xuân Nam', 'khachhang011@gmail.com', '0930760927', N'Số 151, Đường Nguyễn Huệ, Hoàng Mai, Hà Nội', N'Hà Nội', 31300000.00, 2000000.00, 'LUX50', 'CANCELLED', 'BANK_TRANSFER', 0, 1, '2026-02-21 12:03:30'),
(140, 85, 'LXR2604270140', N'Dương Thành Phong', 'khachhang064@gmail.com', '0325167896', N'Số 79, Đường Lê Lợi, Bình Tân, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 1785000.00, 315000.00, 'LXR36', 'DELIVERED', 'MOMO', 1, 0, '2026-04-27 02:40:26'),
(141, 90, 'LXR2408020141', N'Trần Xuân Linh', 'khachhang069@gmail.com', '0385123967', N'Số 63, Đường Hoàng Hoa Thám, Bà Rịa, Vũng Tàu', N'Vũng Tàu', 12500000.00, 0.00, NULL, 'PAID', 'INSTALLMENT', 1, 0, '2024-08-02 02:38:33'),
(142, 80, 'LXR2410090142', N'Dương Thu Hương', 'khachhang059@gmail.com', '0788444505', N'Số 5, Đường Điện Biên Phủ, Dĩ An, Bình Dương', N'Bình Dương', 3200000.00, 0.00, NULL, 'SHIPPING', 'MOMO', 1, 0, '2024-10-09 07:04:36'),
(143, 37, 'LXR2510080143', N'Ngô Thu Huyền', 'khachhang016@gmail.com', '0884346645', N'Số 124, Đường Điện Biên Phủ, Hoàng Mai, Hà Nội', N'Hà Nội', 17010000.00, 1890000.00, 'LUX10', 'PAID', 'MOMO', 1, 0, '2025-10-08 07:30:19'),
(144, 54, 'LXR2408120144', N'Bùi Quỳnh Thảo', 'khachhang033@gmail.com', '0709493169', N'Số 206, Đường Nguyễn Văn Cừ, Hạ Long, Quảng Ninh', N'Quảng Ninh', 1050000.00, 1050000.00, 'LUX50', 'DELIVERED', 'BANK_TRANSFER', 1, 0, '2024-08-12 01:52:50'),
(145, 117, 'LXR2508280145', N'Dương Gia Tùng', 'khachhang096@gmail.com', '0365684010', N'Số 192, Đường Võ Văn Kiệt, Thanh Khê, Đà Nẵng', N'Đà Nẵng', 35000000.00, 0.00, NULL, 'DELIVERED', 'SEPAY_QR', 1, 0, '2025-08-28 06:54:13'),
(146, 49, 'LXR2410020146', N'Hồ Tiến Thắng', 'khachhang028@gmail.com', '0374860862', N'Số 179, Đường Điện Biên Phủ, Uông Bí, Quảng Ninh', N'Quảng Ninh', 52000000.00, 0.00, NULL, 'SHIPPING', 'MOMO', 1, 0, '2024-10-02 22:45:08'),
(147, 111, 'LXR2508170147', N'Phạm Tiến Long', 'khachhang090@gmail.com', '0904368325', N'Số 110, Đường Kim Mã, TP. Huế, Huế', N'Huế', 22800000.00, 2000000.00, 'LUX10', 'CONFIRMED', 'SEPAY_QR', 0, 0, '2025-08-17 02:50:12'),
(148, 77, 'LXR2507160148', N'Vũ Thị Hiền', 'khachhang056@gmail.com', '0794999113', N'Số 254, Đường Trường Chinh, Bình Thủy, Cần Thơ', N'Cần Thơ', 1800000.00, 1800000.00, 'LUX50', 'CONFIRMED', 'BANK_TRANSFER', 0, 0, '2025-07-16 22:48:30'),
(149, 31, 'LXR2509150149', N'Huỳnh Ánh Tú', 'khachhang010@gmail.com', '0394172699', N'Số 65, Đường Cách Mạng Tháng 8, TP. Hải Dương, Hải Dương', N'Hải Dương', 7600000.00, 0.00, NULL, 'PROCESSING', 'MOMO', 1, 0, '2025-09-15 16:22:04'),
(150, 47, 'LXR2412300150', N'Phan Xuân Tài', 'khachhang026@gmail.com', '0323948945', N'Số 53, Đường Điện Biên Phủ, Cẩm Phả, Quảng Ninh', N'Quảng Ninh', 17010000.00, 1890000.00, 'LUX10', 'SHIPPING', 'MOMO', 1, 0, '2024-12-30 21:25:56'),
(151, 38, 'LXR2608150151', N'Huỳnh Quỳnh Lam', 'khachhang017@gmail.com', '0375383607', N'Số 256, Đường Điện Biên Phủ, Hạ Long, Quảng Ninh', N'Quảng Ninh', 1530000.00, 270000.00, 'LXR36', 'PAID', 'VNPAY', 1, 0, '2026-08-15 09:05:51'),
(152, 78, 'LXR2411220152', N'Đỗ Mỹ Duyên', 'khachhang057@gmail.com', '0917675559', N'Số 332, Đường Hai Bà Trưng, Bến Cát, Bình Dương', N'Bình Dương', 16600000.00, 2000000.00, 'LXR36', 'DELIVERED', 'INSTALLMENT', 1, 0, '2024-11-22 20:13:48'),
(153, 59, 'LXR2502170153', N'Đặng Trúc Hà', 'khachhang038@gmail.com', '0761979308', N'Số 311, Đường Võ Văn Kiệt, Long Biên, Hà Nội', N'Hà Nội', 21750000.00, 2000000.00, 'LUX10', 'SHIPPING', 'SEPAY_QR', 1, 0, '2025-02-17 15:38:19'),
(154, 95, 'LXR2403190154', N'Võ Ánh Tú', 'khachhang074@gmail.com', '0944495641', N'Số 316, Đường Cách Mạng Tháng 8, Bình Thủy, Cần Thơ', N'Cần Thơ', 15500000.00, 0.00, NULL, 'DELIVERED', 'MOMO', 1, 0, '2024-03-19 23:48:40'),
(155, 87, 'LXR2511250155', N'Lê Bảo Khang', 'khachhang066@gmail.com', '0331904313', N'Số 179, Đường Nam Kỳ Khởi Nghĩa, Bến Cát, Bình Dương', N'Bình Dương', 10370000.00, 1830000.00, 'LXR36', 'DELIVERED', 'VNPAY', 1, 0, '2025-11-25 15:06:06'),
(156, 104, 'LXR2511240156', N'Trần Diệu Hương', 'khachhang083@gmail.com', '0325891709', N'Số 137, Đường Kim Mã, Hội An, Quảng Nam', N'Quảng Nam', 17000000.00, 2000000.00, 'LUX30', 'PAID', 'SEPAY_QR', 1, 0, '2025-11-24 06:38:35'),
(157, 49, 'LXR2602080157', N'Hồ Tiến Thắng', 'khachhang028@gmail.com', '0374860862', N'Số 179, Đường Điện Biên Phủ, Uông Bí, Quảng Ninh', N'Quảng Ninh', 30300000.00, 2000000.00, 'LXR36', 'PENDING', 'INSTALLMENT', 0, 0, '2026-02-08 20:17:27'),
(158, 60, 'LXR2502180158', N'Võ Diệu Mai', 'khachhang039@gmail.com', '0902454947', N'Số 68, Đường Nguyễn Văn Cừ, Yên Phong, Bắc Ninh', N'Bắc Ninh', 1350000.00, 150000.00, 'LUX10', 'PAID', 'COD', 1, 0, '2025-02-18 22:47:10'),
(159, 90, 'LXR2408160159', N'Trần Xuân Linh', 'khachhang069@gmail.com', '0385123967', N'Số 63, Đường Hoàng Hoa Thám, Bà Rịa, Vũng Tàu', N'Vũng Tàu', 4725000.00, 525000.00, 'LUX10', 'CONFIRMED', 'VNPAY', 0, 0, '2024-08-16 13:07:13'),
(160, 49, 'LXR2405030160', N'Hồ Tiến Thắng', 'khachhang028@gmail.com', '0374860862', N'Số 179, Đường Điện Biên Phủ, Uông Bí, Quảng Ninh', N'Quảng Ninh', 10900000.00, 0.00, NULL, 'PAID', 'INSTALLMENT', 1, 0, '2024-05-03 05:46:47'),
(161, 45, 'LXR2505020161', N'Lý Ánh Trâm', 'khachhang024@gmail.com', '0335564163', N'Số 278, Đường Cách Mạng Tháng 8, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 10200000.00, 2000000.00, 'LUX50', 'PROCESSING', 'MOMO', 1, 0, '2025-05-02 20:49:40'),
(162, 119, 'LXR2404030162', N'Dương Gia Đạt', 'khachhang098@gmail.com', '0780761573', N'Số 200, Đường Võ Thị Sáu, Quy Nhơn, Bình Định', N'Bình Định', 17370000.00, 1930000.00, 'LUX10', 'SHIPPING', 'SEPAY_QR', 1, 0, '2024-04-03 09:33:05'),
(163, 92, 'LXR2411050163', N'Phạm Thanh Châu', 'khachhang071@gmail.com', '0399506476', N'Số 100, Đường Nguyễn Trãi, Dĩ An, Bình Dương', N'Bình Dương', 4150000.00, 0.00, NULL, 'CONFIRMED', 'MOMO', 0, 0, '2024-11-05 23:45:53'),
(164, 75, 'LXR2411240164', N'Đặng Tuyết Tú', 'khachhang054@gmail.com', '0397942675', N'Số 329, Đường Lê Lợi, Long Thành, Đồng Nai', N'Đồng Nai', 21300000.00, 0.00, NULL, 'PENDING', 'BANK_TRANSFER', 0, 0, '2024-11-24 08:11:31'),
(165, 94, 'LXR2606220165', N'Phan Thu Vy', 'khachhang073@gmail.com', '0353024846', N'Số 341, Đường Võ Văn Kiệt, Tân Bình, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 3780000.00, 420000.00, 'LUX10', 'DELIVERED', 'BANK_TRANSFER', 1, 0, '2026-06-22 01:54:29'),
(166, 111, 'LXR2405050166', N'Phạm Tiến Long', 'khachhang090@gmail.com', '0904368325', N'Số 110, Đường Kim Mã, TP. Huế, Huế', N'Huế', 13500000.00, 2000000.00, 'LXR36', 'DELIVERED', 'VNPAY', 1, 0, '2024-05-05 18:52:12'),
(167, 87, 'LXR2412170167', N'Lê Bảo Khang', 'khachhang066@gmail.com', '0331904313', N'Số 179, Đường Nam Kỳ Khởi Nghĩa, Bến Cát, Bình Dương', N'Bình Dương', 9950000.00, 0.00, NULL, 'CONFIRMED', 'MOMO', 0, 0, '2024-12-17 23:02:15'),
(168, 43, 'LXR2403190168', N'Lý Thu Huyền', 'khachhang022@gmail.com', '0774600619', N'Số 243, Đường Hoàng Hoa Thám, Ngô Quyền, Hải Phòng', N'Hải Phòng', 15480000.00, 1720000.00, 'LUX10', 'PAID', 'SEPAY_QR', 1, 0, '2024-03-19 21:12:05'),
(169, 82, 'LXR2510230169', N'Trần Ngọc Nhi', 'khachhang061@gmail.com', '0980124165', N'Số 286, Đường Lý Thường Kiệt, Ninh Kiều, Cần Thơ', N'Cần Thơ', 79200000.00, 2000000.00, 'LUX30', 'PAID', 'BANK_TRANSFER', 1, 0, '2025-10-23 12:14:57'),
(170, 98, 'LXR2509130170', N'Phạm Ánh Hà', 'khachhang077@gmail.com', '0767110104', N'Số 95, Đường Lê Lợi, Long Thành, Đồng Nai', N'Đồng Nai', 6000000.00, 0.00, NULL, 'CONFIRMED', 'INSTALLMENT', 0, 0, '2025-09-13 05:20:52'),
(171, 68, 'LXR2604120171', N'Lý Diệu Trang', 'khachhang047@gmail.com', '0898391307', N'Số 243, Đường Cầu Giấy, Quận 1, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 14800000.00, 2000000.00, 'LXR36', 'CONFIRMED', 'BANK_TRANSFER', 0, 0, '2026-04-12 13:52:55'),
(172, 104, 'LXR2505250172', N'Trần Diệu Hương', 'khachhang083@gmail.com', '0325891709', N'Số 137, Đường Kim Mã, Hội An, Quảng Nam', N'Quảng Nam', 74300000.00, 0.00, NULL, 'CONFIRMED', 'VNPAY', 0, 0, '2025-05-25 12:28:35'),
(173, 47, 'LXR2408180173', N'Phan Xuân Tài', 'khachhang026@gmail.com', '0323948945', N'Số 53, Đường Điện Biên Phủ, Cẩm Phả, Quảng Ninh', N'Quảng Ninh', 12200000.00, 0.00, NULL, 'PAID', 'SEPAY_QR', 1, 0, '2024-08-18 11:46:06'),
(174, 72, 'LXR2506230174', N'Đặng Anh Tài', 'khachhang051@gmail.com', '0387027574', N'Số 74, Đường Nguyễn Trãi, Bến Cát, Bình Dương', N'Bình Dương', 15500000.00, 0.00, NULL, 'PAID', 'MOMO', 1, 0, '2025-06-23 01:20:05'),
(175, 29, 'LXR2603130175', N'Hồ Mai Linh', 'khachhang008@gmail.com', '0884008436', N'Số 113, Đường Nguyễn Huệ, Tây Hồ, Hà Nội', N'Hà Nội', 8200000.00, 0.00, NULL, 'PAID', 'BANK_TRANSFER', 1, 0, '2026-03-13 00:07:13'),
(176, 74, 'LXR2506220176', N'Võ Mai Trâm', 'khachhang053@gmail.com', '0891413000', N'Số 144, Đường Trường Chinh, Biên Hòa, Đồng Nai', N'Đồng Nai', 1050000.00, 1050000.00, 'LUX50', 'PAID', 'COD', 1, 0, '2025-06-22 11:58:35'),
(177, 69, 'LXR2602170177', N'Hoàng Đức Long', 'khachhang048@gmail.com', '0385765838', N'Số 338, Đường Giải Phóng, TP. Vũng Tàu, Vũng Tàu', N'Vũng Tàu', 111600000.00, 0.00, NULL, 'DELIVERED', 'BANK_TRANSFER', 1, 0, '2026-02-17 09:56:54'),
(178, 43, 'LXR2508200178', N'Lý Thu Huyền', 'khachhang022@gmail.com', '0774600619', N'Số 243, Đường Hoàng Hoa Thám, Ngô Quyền, Hải Phòng', N'Hải Phòng', 10800000.00, 0.00, NULL, 'PAID', 'INSTALLMENT', 1, 0, '2025-08-20 21:52:36'),
(179, 93, 'LXR2503250179', N'Phan Văn Tuấn', 'khachhang072@gmail.com', '0346610055', N'Số 204, Đường Nguyễn Văn Cừ, TP. Thủ Đức, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 4770000.00, 530000.00, 'LUX10', 'SHIPPING', 'COD', 1, 0, '2025-03-25 17:35:05'),
(180, 114, 'LXR2512050180', N'Phan Đức Khoa', 'khachhang093@gmail.com', '0783142280', N'Số 337, Đường Hoàng Hoa Thám, TP. Huế, Huế', N'Huế', 24600000.00, 0.00, NULL, 'SHIPPING', 'SEPAY_QR', 1, 0, '2025-12-05 06:36:28'),
(181, 112, 'LXR2411200181', N'Phạm Tuấn Cường', 'khachhang091@gmail.com', '0867685982', N'Số 248, Đường Cách Mạng Tháng 8, Hội An, Quảng Nam', N'Quảng Nam', 8670000.00, 1530000.00, 'LXR36', 'CONFIRMED', 'VNPAY', 0, 0, '2024-11-20 05:06:14'),
(182, 95, 'LXR2405190182', N'Võ Ánh Tú', 'khachhang074@gmail.com', '0944495641', N'Số 316, Đường Cách Mạng Tháng 8, Bình Thủy, Cần Thơ', N'Cần Thơ', 13100000.00, 2000000.00, 'LXR36', 'PAID', 'SEPAY_QR', 1, 0, '2024-05-19 18:40:28'),
(183, 34, 'LXR2605030183', N'Lý Phương Hiền', 'khachhang013@gmail.com', '0373708940', N'Số 21, Đường Lý Thường Kiệt, TP. Hải Dương, Hải Dương', N'Hải Dương', 11500000.00, 0.00, NULL, 'PAID', 'COD', 1, 0, '2026-05-03 23:55:40'),
(184, 82, 'LXR2510230184', N'Trần Ngọc Nhi', 'khachhang061@gmail.com', '0980124165', N'Số 286, Đường Lý Thường Kiệt, Ninh Kiều, Cần Thơ', N'Cần Thơ', 29800000.00, 0.00, NULL, 'DELIVERED', 'VNPAY', 1, 0, '2025-10-23 16:21:12'),
(185, 42, 'LXR2510130185', N'Hồ Phương Châu', 'khachhang021@gmail.com', '0979639175', N'Số 5, Đường Giải Phóng, Hoàn Kiếm, Hà Nội', N'Hà Nội', 59800000.00, 2000000.00, 'LXR36', 'PAID', 'COD', 1, 0, '2025-10-13 19:11:48'),
(186, 61, 'LXR2503190186', N'Nguyễn Thu Hà', 'khachhang040@gmail.com', '0392103196', N'Số 145, Đường Nam Kỳ Khởi Nghĩa, Chí Linh, Hải Dương', N'Hải Dương', 8500000.00, 0.00, NULL, 'SHIPPING', 'INSTALLMENT', 1, 0, '2025-03-19 12:01:20'),
(187, 55, 'LXR2607040187', N'Huỳnh Đức Khoa', 'khachhang034@gmail.com', '0777610058', N'Số 330, Đường Võ Thị Sáu, Uông Bí, Quảng Ninh', N'Quảng Ninh', 30500000.00, 2000000.00, 'LUX50', 'PENDING', 'BANK_TRANSFER', 0, 0, '2026-07-04 15:36:58'),
(188, 105, 'LXR2506110188', N'Bùi Tuấn Khải', 'khachhang084@gmail.com', '0340297323', N'Số 325, Đường Nam Kỳ Khởi Nghĩa, TP. Huế, Huế', N'Huế', 2240000.00, 960000.00, 'LUX30', 'SHIPPING', 'SEPAY_QR', 1, 0, '2025-06-11 05:11:56'),
(189, 70, 'LXR2406010189', N'Huỳnh Hữu Khải', 'khachhang049@gmail.com', '0980016432', N'Số 139, Đường Võ Thị Sáu, Quận 8, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 17450000.00, 0.00, NULL, 'CANCELLED', 'INSTALLMENT', 0, 1, '2024-06-01 22:54:52'),
(190, 94, 'LXR2412250190', N'Phan Thu Vy', 'khachhang073@gmail.com', '0353024846', N'Số 341, Đường Võ Văn Kiệt, Tân Bình, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 41200000.00, 2000000.00, 'LUX10', 'PROCESSING', 'SEPAY_QR', 1, 0, '2024-12-25 19:52:08'),
(191, 108, 'LXR2406090191', N'Dương Ánh Hằng', 'khachhang087@gmail.com', '0945397620', N'Số 65, Đường Lê Lợi, TP. Huế, Huế', N'Huế', 4100000.00, 0.00, NULL, 'PAID', 'VNPAY', 1, 0, '2024-06-09 12:44:47'),
(192, 103, 'LXR2508270192', N'Lê Bảo Đạt', 'khachhang082@gmail.com', '0918069328', N'Số 1, Đường Cầu Giấy, Hội An, Quảng Nam', N'Quảng Nam', 28500000.00, 2000000.00, 'LUX30', 'PAID', 'COD', 1, 0, '2025-08-27 16:43:09'),
(193, 121, 'LXR2412050193', N'Đặng Hải Anh', 'khachhang100@gmail.com', '0934773116', N'Số 16, Đường Hai Bà Trưng, Cẩm Lệ, Đà Nẵng', N'Đà Nẵng', 56200000.00, 2000000.00, 'LUX50', 'PAID', 'MOMO', 1, 0, '2024-12-05 12:20:11'),
(194, 26, 'LXR2403230194', N'Đặng Mỹ Lam', 'khachhang005@gmail.com', '0989557017', N'Số 23, Đường Hai Bà Trưng, Hồng Bàng, Hải Phòng', N'Hải Phòng', 1530000.00, 270000.00, 'LXR36', 'DELIVERED', 'INSTALLMENT', 1, 0, '2024-03-23 12:17:04'),
(195, 39, 'LXR2405150195', N'Đặng Tiến Linh', 'khachhang018@gmail.com', '0335222576', N'Số 256, Đường Hoàng Hoa Thám, Chí Linh, Hải Dương', N'Hải Dương', 1700000.00, 1700000.00, 'LUX50', 'PROCESSING', 'MOMO', 1, 0, '2024-05-15 05:50:16'),
(196, 90, 'LXR2603010196', N'Trần Xuân Linh', 'khachhang069@gmail.com', '0385123967', N'Số 63, Đường Hoàng Hoa Thám, Bà Rịa, Vũng Tàu', N'Vũng Tàu', 102000000.00, 2000000.00, 'LUX10', 'DELIVERED', 'BANK_TRANSFER', 1, 0, '2026-03-01 20:21:11'),
(197, 110, 'LXR2608280197', N'Ngô Bảo Hải', 'khachhang089@gmail.com', '0894063447', N'Số 219, Đường Võ Văn Kiệt, Cam Ranh, Nha Trang', N'Nha Trang', 7830000.00, 870000.00, 'LUX10', 'SHIPPING', 'MOMO', 1, 0, '2026-08-28 17:44:31'),
(198, 102, 'LXR2605240198', N'Dương Minh Sơn', 'khachhang081@gmail.com', '0977810640', N'Số 236, Đường Lý Thường Kiệt, Hội An, Quảng Nam', N'Quảng Nam', 2720000.00, 480000.00, 'LXR36', 'CONFIRMED', 'SEPAY_QR', 0, 0, '2026-05-24 09:08:57'),
(199, 116, 'LXR2502190199', N'Lý Gia Khang', 'khachhang095@gmail.com', '0709254254', N'Số 73, Đường Trần Hưng Đạo, Sơn Trà, Đà Nẵng', N'Đà Nẵng', 50000000.00, 2000000.00, 'LXR36', 'PENDING', 'COD', 0, 0, '2025-02-19 08:17:18'),
(200, 42, 'LXR2605230200', N'Hồ Phương Châu', 'khachhang021@gmail.com', '0979639175', N'Số 5, Đường Giải Phóng, Hoàn Kiếm, Hà Nội', N'Hà Nội', 18750000.00, 2000000.00, 'LUX50', 'PENDING', 'MOMO', 0, 0, '2026-05-23 05:59:17');

SET IDENTITY_INSERT orders OFF;
DBCC CHECKIDENT ('orders', RESEED, 200);
GO

-- ----------------------------------------------------------------------------
-- 9. CHI TIẾT ĐƠN HÀNG (ORDER_ITEMS)
-- ----------------------------------------------------------------------------
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES
(1, 22, 750000.00, 1),
(2, 9, 2100000.00, 1),
(3, 4, 11500000.00, 1),
(3, 9, 2100000.00, 1),
(4, 6, 6100000.00, 1),
(4, 14, 12200000.00, 1),
(5, 2, 17200000.00, 2),
(6, 24, 2100000.00, 1),
(7, 7, 4800000.00, 1),
(8, 24, 2100000.00, 1),
(9, 9, 2100000.00, 1),
(9, 12, 22500000.00, 2),
(10, 25, 1450000.00, 1),
(11, 19, 2600000.00, 1),
(12, 15, 8500000.00, 1),
(12, 12, 22500000.00, 1),
(12, 21, 1200000.00, 2),
(13, 3, 10800000.00, 1),
(14, 11, 35000000.00, 2),
(15, 17, 3400000.00, 1),
(16, 1, 15500000.00, 1),
(16, 11, 35000000.00, 1),
(17, 20, 1800000.00, 1),
(17, 4, 11500000.00, 1),
(17, 11, 35000000.00, 2),
(18, 22, 750000.00, 1),
(18, 10, 52000000.00, 1),
(19, 11, 35000000.00, 1),
(19, 5, 8200000.00, 1),
(19, 19, 2600000.00, 1),
(20, 23, 3800000.00, 1),
(20, 9, 2100000.00, 1),
(21, 5, 8200000.00, 1),
(22, 4, 11500000.00, 1),
(22, 10, 52000000.00, 1),
(23, 3, 10800000.00, 2),
(24, 22, 750000.00, 1),
(24, 23, 3800000.00, 1),
(25, 8, 3200000.00, 1),
(25, 11, 35000000.00, 1),
(25, 22, 750000.00, 1),
(26, 16, 6200000.00, 2),
(27, 8, 3200000.00, 1),
(27, 18, 4500000.00, 1),
(27, 24, 2100000.00, 1),
(28, 23, 3800000.00, 2),
(28, 10, 52000000.00, 1),
(29, 15, 8500000.00, 1),
(30, 16, 6200000.00, 1),
(31, 7, 4800000.00, 1),
(32, 18, 4500000.00, 1),
(33, 5, 8200000.00, 2),
(34, 1, 15500000.00, 1),
(35, 24, 2100000.00, 1),
(36, 13, 16800000.00, 1),
(36, 9, 2100000.00, 1),
(37, 4, 11500000.00, 1),
(38, 15, 8500000.00, 1),
(38, 6, 6100000.00, 1),
(39, 15, 8500000.00, 1),
(39, 25, 1450000.00, 1),
(40, 1, 15500000.00, 1),
(40, 2, 17200000.00, 2),
(40, 14, 12200000.00, 2),
(41, 15, 8500000.00, 1),
(42, 4, 11500000.00, 1),
(43, 24, 2100000.00, 1),
(43, 25, 1450000.00, 1),
(43, 21, 1200000.00, 1),
(44, 3, 10800000.00, 1),
(45, 12, 22500000.00, 1),
(45, 11, 35000000.00, 1),
(46, 19, 2600000.00, 1),
(47, 9, 2100000.00, 1),
(48, 22, 750000.00, 1),
(48, 5, 8200000.00, 1),
(49, 5, 8200000.00, 1),
(49, 8, 3200000.00, 1),
(50, 21, 1200000.00, 1),
(50, 16, 6200000.00, 1),
(51, 4, 11500000.00, 1),
(52, 2, 17200000.00, 1),
(52, 12, 22500000.00, 2),
(53, 23, 3800000.00, 1),
(53, 11, 35000000.00, 1),
(54, 7, 4800000.00, 1),
(54, 11, 35000000.00, 1),
(54, 12, 22500000.00, 1),
(55, 16, 6200000.00, 1),
(55, 4, 11500000.00, 1),
(56, 9, 2100000.00, 1),
(57, 2, 17200000.00, 1),
(58, 24, 2100000.00, 1),
(58, 20, 1800000.00, 2),
(59, 12, 22500000.00, 1),
(59, 11, 35000000.00, 1),
(60, 4, 11500000.00, 1),
(61, 7, 4800000.00, 1),
(62, 18, 4500000.00, 1),
(63, 9, 2100000.00, 2),
(63, 18, 4500000.00, 1),
(64, 2, 17200000.00, 1),
(65, 3, 10800000.00, 1),
(66, 5, 8200000.00, 2),
(67, 25, 1450000.00, 1),
(68, 21, 1200000.00, 1),
(69, 8, 3200000.00, 1),
(69, 13, 16800000.00, 1),
(70, 9, 2100000.00, 1),
(71, 5, 8200000.00, 1),
(71, 13, 16800000.00, 2),
(72, 7, 4800000.00, 1),
(72, 2, 17200000.00, 1),
(72, 1, 15500000.00, 1),
(73, 4, 11500000.00, 1),
(74, 3, 10800000.00, 1),
(74, 15, 8500000.00, 1),
(75, 23, 3800000.00, 1),
(76, 7, 4800000.00, 2),
(77, 21, 1200000.00, 2),
(77, 7, 4800000.00, 1),
(78, 16, 6200000.00, 1),
(79, 17, 3400000.00, 1),
(80, 2, 17200000.00, 2),
(81, 10, 52000000.00, 1),
(82, 25, 1450000.00, 1),
(82, 4, 11500000.00, 2),
(83, 24, 2100000.00, 1),
(83, 1, 15500000.00, 1),
(84, 8, 3200000.00, 1),
(85, 4, 11500000.00, 1),
(85, 16, 6200000.00, 1),
(85, 14, 12200000.00, 1),
(86, 25, 1450000.00, 1),
(86, 23, 3800000.00, 1),
(86, 14, 12200000.00, 2),
(87, 3, 10800000.00, 1),
(87, 17, 3400000.00, 1),
(87, 22, 750000.00, 1),
(88, 22, 750000.00, 1),
(89, 21, 1200000.00, 1),
(89, 24, 2100000.00, 1),
(89, 20, 1800000.00, 1),
(90, 1, 15500000.00, 1),
(91, 25, 1450000.00, 2),
(91, 23, 3800000.00, 1),
(92, 3, 10800000.00, 1),
(92, 4, 11500000.00, 1),
(93, 21, 1200000.00, 2),
(93, 20, 1800000.00, 1),
(94, 19, 2600000.00, 1),
(94, 9, 2100000.00, 1),
(94, 13, 16800000.00, 1),
(95, 18, 4500000.00, 2),
(95, 7, 4800000.00, 1),
(96, 15, 8500000.00, 1),
(96, 6, 6100000.00, 2),
(97, 16, 6200000.00, 1),
(98, 15, 8500000.00, 2),
(98, 5, 8200000.00, 1),
(98, 17, 3400000.00, 1),
(99, 4, 11500000.00, 1),
(99, 19, 2600000.00, 1),
(100, 20, 1800000.00, 2),
(101, 20, 1800000.00, 1),
(102, 14, 12200000.00, 1),
(102, 24, 2100000.00, 1),
(103, 11, 35000000.00, 1),
(103, 24, 2100000.00, 1),
(103, 18, 4500000.00, 1),
(104, 23, 3800000.00, 1),
(105, 8, 3200000.00, 1),
(105, 19, 2600000.00, 1),
(106, 23, 3800000.00, 2),
(106, 11, 35000000.00, 1),
(107, 21, 1200000.00, 1),
(107, 22, 750000.00, 2),
(107, 19, 2600000.00, 1),
(108, 15, 8500000.00, 1),
(108, 14, 12200000.00, 1),
(108, 19, 2600000.00, 1),
(109, 9, 2100000.00, 1),
(109, 4, 11500000.00, 1),
(110, 16, 6200000.00, 1),
(110, 2, 17200000.00, 1),
(111, 15, 8500000.00, 1),
(111, 11, 35000000.00, 1),
(112, 12, 22500000.00, 2),
(112, 22, 750000.00, 1),
(113, 24, 2100000.00, 1),
(114, 23, 3800000.00, 1),
(115, 6, 6100000.00, 1),
(115, 7, 4800000.00, 1),
(116, 2, 17200000.00, 1),
(116, 25, 1450000.00, 1),
(117, 3, 10800000.00, 1),
(118, 1, 15500000.00, 1),
(118, 14, 12200000.00, 2),
(119, 22, 750000.00, 1),
(119, 15, 8500000.00, 1),
(120, 14, 12200000.00, 1),
(121, 8, 3200000.00, 2),
(121, 13, 16800000.00, 2),
(122, 1, 15500000.00, 1),
(122, 9, 2100000.00, 1),
(123, 8, 3200000.00, 1),
(123, 19, 2600000.00, 2),
(123, 12, 22500000.00, 1),
(124, 12, 22500000.00, 1),
(124, 5, 8200000.00, 1),
(124, 10, 52000000.00, 1),
(125, 3, 10800000.00, 1),
(126, 10, 52000000.00, 1),
(127, 22, 750000.00, 1),
(128, 14, 12200000.00, 1),
(128, 2, 17200000.00, 1),
(128, 23, 3800000.00, 2),
(129, 23, 3800000.00, 1),
(130, 1, 15500000.00, 1),
(130, 11, 35000000.00, 1),
(130, 13, 16800000.00, 1),
(131, 21, 1200000.00, 1),
(131, 11, 35000000.00, 1),
(132, 14, 12200000.00, 1),
(133, 5, 8200000.00, 1),
(134, 16, 6200000.00, 1),
(134, 9, 2100000.00, 2),
(134, 7, 4800000.00, 1),
(135, 2, 17200000.00, 1),
(136, 7, 4800000.00, 1),
(137, 5, 8200000.00, 1),
(137, 24, 2100000.00, 1),
(138, 18, 4500000.00, 1),
(139, 5, 8200000.00, 1),
(139, 12, 22500000.00, 1),
(139, 19, 2600000.00, 1),
(140, 9, 2100000.00, 1),
(141, 7, 4800000.00, 1),
(141, 22, 750000.00, 2),
(141, 16, 6200000.00, 1),
(142, 8, 3200000.00, 1),
(143, 9, 2100000.00, 1),
(143, 13, 16800000.00, 1),
(144, 24, 2100000.00, 1),
(145, 11, 35000000.00, 1),
(146, 10, 52000000.00, 1),
(147, 20, 1800000.00, 1),
(147, 4, 11500000.00, 2),
(148, 20, 1800000.00, 2),
(149, 23, 3800000.00, 2),
(150, 13, 16800000.00, 1),
(150, 9, 2100000.00, 1),
(151, 20, 1800000.00, 1),
(152, 20, 1800000.00, 1),
(152, 13, 16800000.00, 1),
(153, 13, 16800000.00, 1),
(153, 22, 750000.00, 1),
(153, 16, 6200000.00, 1),
(154, 1, 15500000.00, 1),
(155, 14, 12200000.00, 1),
(156, 3, 10800000.00, 1),
(156, 5, 8200000.00, 1),
(157, 1, 15500000.00, 1),
(157, 13, 16800000.00, 1),
(158, 22, 750000.00, 2),
(159, 18, 4500000.00, 1),
(159, 22, 750000.00, 1),
(160, 7, 4800000.00, 1),
(160, 6, 6100000.00, 1),
(161, 14, 12200000.00, 1),
(162, 15, 8500000.00, 1),
(162, 3, 10800000.00, 1),
(163, 17, 3400000.00, 1),
(163, 22, 750000.00, 1),
(164, 18, 4500000.00, 1),
(164, 13, 16800000.00, 1),
(165, 24, 2100000.00, 2),
(166, 1, 15500000.00, 1),
(167, 25, 1450000.00, 1),
(167, 15, 8500000.00, 1),
(168, 2, 17200000.00, 1),
(169, 7, 4800000.00, 1),
(169, 10, 52000000.00, 1),
(169, 14, 12200000.00, 2),
(170, 9, 2100000.00, 2),
(170, 20, 1800000.00, 1),
(171, 13, 16800000.00, 1),
(172, 10, 52000000.00, 1),
(172, 3, 10800000.00, 1),
(172, 4, 11500000.00, 1),
(173, 16, 6200000.00, 1),
(173, 7, 4800000.00, 1),
(173, 21, 1200000.00, 1),
(174, 1, 15500000.00, 1),
(175, 5, 8200000.00, 1),
(176, 9, 2100000.00, 1),
(177, 23, 3800000.00, 2),
(177, 10, 52000000.00, 2),
(178, 3, 10800000.00, 1),
(179, 24, 2100000.00, 1),
(179, 8, 3200000.00, 1),
(180, 12, 22500000.00, 1),
(180, 24, 2100000.00, 1),
(181, 18, 4500000.00, 2),
(181, 21, 1200000.00, 1),
(182, 18, 4500000.00, 2),
(182, 6, 6100000.00, 1),
(183, 4, 11500000.00, 1),
(184, 15, 8500000.00, 1),
(184, 18, 4500000.00, 1),
(184, 13, 16800000.00, 1),
(185, 17, 3400000.00, 1),
(185, 10, 52000000.00, 1),
(185, 8, 3200000.00, 2),
(186, 15, 8500000.00, 1),
(187, 1, 15500000.00, 1),
(187, 14, 12200000.00, 1),
(187, 7, 4800000.00, 1),
(188, 8, 3200000.00, 1),
(189, 1, 15500000.00, 1),
(189, 22, 750000.00, 1),
(189, 21, 1200000.00, 1),
(190, 11, 35000000.00, 1),
(190, 5, 8200000.00, 1),
(191, 22, 750000.00, 2),
(191, 19, 2600000.00, 1),
(192, 14, 12200000.00, 2),
(192, 6, 6100000.00, 1),
(193, 10, 52000000.00, 1),
(193, 16, 6200000.00, 1),
(194, 20, 1800000.00, 1),
(195, 17, 3400000.00, 1),
(196, 10, 52000000.00, 2),
(197, 19, 2600000.00, 1),
(197, 6, 6100000.00, 1),
(198, 8, 3200000.00, 1),
(199, 10, 52000000.00, 1),
(200, 8, 3200000.00, 1),
(200, 13, 16800000.00, 1),
(200, 22, 750000.00, 1);
GO

-- ----------------------------------------------------------------------------
-- 10. 25 BÀI VIẾT TIN TỨC CHUẨN XÁC THEO 5 DANH MỤC (5 BÀI / DANH MỤC)
-- ----------------------------------------------------------------------------
SET IDENTITY_INSERT news ON;
-- ----------------------------------------------------------------------------
-- 10. 25 BÀI VIẾT TIN TỨC CHUẨN XÁC THEO 5 DANH MỤC (5 BÀI / DANH MỤC)
-- ----------------------------------------------------------------------------

INSERT INTO news (id, title, slug, summary, content, thumbnail, author_id, category_id, status, meta_title, meta_description, meta_keywords, view_count, created_at, updated_at) VALUES
(1, N'NVIDIA chính thức ra mắt Card đồ họa GeForce RTX 50 Series kiến trúc Blackwell', 'nvidia-chinh-thuc-ra-mat-rtx-50-series-blackwell', N'NVIDIA công bố thế hệ card đồ họa RTX 5090 và RTX 5080 với bộ nhớ GDDR7 siêu tốc, kiến trúc Blackwell đột phá mang lại hiệu năng Ray Tracing và DLSS 4 vượt trội gấp 2 lần.', N'<p>Tại sự kiện công nghệ toàn cầu, CEO NVIDIA Jensen Huang đã chính thức vén màn thế hệ card đồ họa tiêu dùng cao cấp nhất: <strong>GeForce RTX 50 Series</strong> mang mã kiến trúc <em>Blackwell</em>.</p>
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
<p>Sản phẩm sẽ chính thức mở bán tại hệ thống <strong>Luxury PC</strong> với đầy đủ các phiên bản Custom cao cấp từ ASUS ROG Strix, MSI Suprim X và GIGABYTE AORUS Master.</p>', 'https://cdn-ru.bitrix24.ru/b11322588/landing/90e/90ed69e925e0a6d59b2fe8e9075775f0/RTX5090_1x.png', 1, 1, 'PUBLISHED', N'NVIDIA ra mắt GeForce RTX 50 Series Blackwell - LuxuryPC', N'NVIDIA công bố dòng card đồ họa RTX 5090, RTX 5080 kiến trúc Blackwell với bộ nhớ GDDR7 và DLSS 4 đỉnh cao.', N'RTX 5090, RTX 5080, NVIDIA Blackwell, GDDR7, DLSS 4, card đồ họa mới', 28450, '2026-01-10 09:30:00', '2026-01-10 09:30:00'),
(2, N'Intel công bố vi xử lý Core Ultra 200S Series Arrow Lake tiết kiệm 40% điện năng', 'intel-cong-bo-core-ultra-200s-series-arrow-lake', N'Kiến trúc Arrow Lake trên socket LGA 1851 giúp giảm tới 40% điện năng tiêu thụ và nhiệt độ mát hơn 15 độ C trong khi vẫn giữ nguyên hiệu năng xử lý đa nhiệm đỉnh cao.', N'<p>Intel vừa chính thức trình làng dòng vi xử lý máy tính để bàn thế hệ mới mang tên <strong>Intel Core Ultra 200S Series</strong> (tên mã Arrow Lake-S), đánh dấu sự từ bỏ thương hiệu Core i truyền thống để bước sang kỷ nguyên Core Ultra trên Socket LGA 1851.</p>
<h3>1. Thiết kế Tile Chiplet hiện đại trên tiến trình TSMC 3nm</h3>
<p>Khác biệt hoàn toàn với các thế hệ trước, Core Ultra 200S áp dụng kiến trúc đóng gói 3D Foveros kết hợp nhiều Tile: Compute Tile (sản xuất trên tiến trình TSMC N3B), Graphics Tile, SoC Tile và I/O Tile. Nhờ đó, hiệu suất năng lượng (Performance/Watt) đạt mức cải thiện ngoạn mục.</p>
<h3>2. Thông số các vi xử lý chủ lực</h3>
<ul>
<li><strong>Intel Core Ultra 9 285K:</strong> 24 nhân (8 P-Core Lion Cove + 16 E-Core Skymont), xung nhịp tối đa 5.7GHz, 36MB Intel Smart Cache, TDP 125W (Turbo 250W).</li>
<li><strong>Intel Core Ultra 7 265K:</strong> 20 nhân (8 P-Core + 12 E-Core), xung nhịp 5.5GHz.</li>
<li><strong>Intel Core Ultra 5 245K:</strong> 14 nhân (6 P-Core + 8 E-Core), xung nhịp 5.2GHz.</li>
</ul>
<p>Đặc biệt, dòng chip mới tích hợp sẵn NPU chuyên dụng xử lý các tác vụ AI cục bộ đạt 13 TOPS, mang lại trải nghiệm Copilot+ PC mượt mà ngay trên máy tính để bàn.</p>', 'https://www.techpowerup.com/review/intel-core-ultra-9-285k/images/small.png', 1, 1, 'PUBLISHED', N'Intel Core Ultra 200S Arrow Lake ra mắt - LuxuryPC', N'Intel ra mắt CPU Core Ultra 9 285K, Ultra 7 265K socket LGA 1851 tiết kiệm điện và tích hợp NPU AI.', N'Core Ultra 9 285K, Arrow Lake, Intel LGA 1851, Core Ultra 200S', 19800, '2026-01-22 14:15:00', '2026-01-22 14:15:00'),
(3, N'Thị trường RAM DDR5 bình ổn giá, chuẩn bị phổ cập chuẩn CUDIMM tốc độ 9000MT/s', 'thi-truong-ram-ddr5-pho-cap-chuan-cudimm-9000mts', N'Giá RAM DDR5 tiếp tục xu hướng bình ổn, mở đường cho thế hệ bộ nhớ CUDIMM tích hợp chip Client Clock Driver đạt mức xung nhịp kỷ lục lên tới 9200MT/s trở thành tiêu chuẩn mới.', N'<p>Sau giai đoạn biến động, giá bộ nhớ RAM DDR5 trên thị trường toàn cầu đã bước vào chu kỳ ổn định, tạo điều kiện thuận lợi cho game thủ và chuyên gia đồ họa nâng cấp cấu hình máy tính.</p>
<h3>CUDIMM là gì và tại sao lại tạo nên cuộc cách mạng tốc độ?</h3>
<p><strong>CUDIMM (Clocked Unbuffered DIMM)</strong> là chuẩn bộ nhớ DDR5 cải tiến được JEDEC chuẩn hóa. Điểm đột phá nằm ở con chip <em>CKD (Client Clock Driver)</em> được tích hợp trực tiếp trên thanh RAM, giúp tái tạo và khuếch đại xung nhịp tín hiệu bộ nhớ, loại bỏ tình trạng suy hao tín hiệu khi chạy ở bus cực cao.</p>
<p>Các hãng sản xuất hàng đầu như G.Skill (Trident Z5 CK), Corsair (Dominator Titanium CUDIMM) và Kingmax đã công bố các kit RAM có tốc độ sẵn sàng từ <strong>8400MT/s đến 9200MT/s</strong> chỉ bằng một cú nhấp chuột bật profile XMP trong BIOS.</p>', 'https://c1.neweggimages.com/ProductImageCompressAll1280/20-374-453-01.jpg', 1, 1, 'PUBLISHED', N'RAM DDR5 CUDIMM 9000MT/s chuẩn bị phổ cập - LuxuryPC', N'Tìm hiểu chuẩn RAM CUDIMM DDR5 thế hệ mới tích hợp chip Clock Driver đạt tốc độ trên 9000MT/s.', N'RAM DDR5, CUDIMM, G.Skill Trident Z5, Corsair Dominator, bus 9000MHz', 14300, '2026-02-15 10:00:00', '2026-02-15 10:00:00'),
(4, N'ASUS ROG ra mắt loạt bo mạch chủ Z890 và X870E hỗ trợ Wi-Fi 7 và PCIe 5.0 toàn diện', 'asus-rog-ra-mat-bo-mach-chu-z890-x870e-wifi-7', N'Các dòng bo mạch chủ ROG Maximus Z890 và Crosshair X870E tích hợp khe M.2 PCIe 5.0 không cần ốc vít, tính năng ép xung bằng AI và kết nối Wi-Fi 7 siêu tốc băng thông 320MHz.', N'<p>ASUS Republic of Gamers (ROG) vừa chính thức giới thiệu dải sản phẩm bo mạch chủ cao cấp thế hệ mới dành cho cả hai nền tảng Intel Core Ultra (Z890) và AMD Ryzen 9000 Series (X870E).</p>
<h3>1. Thiết kế EZ-PC: Tối giản thao tác lắp đặt</h3>
<p>ASUS tiếp tục dẫn đầu xu hướng thân thiện với người dùng thông qua hệ sinh thái <strong>ROG EZ-PC</strong>:</p>
<ul>
<li><strong>PCIe Slot Q-Release Slim:</strong> Tháo card đồ họa nặng chỉ bằng cách nghiêng nhẹ card về phía chốt, không cần dùng tay nhấn nút mở chốt.</li>
<li><strong>M.2 Q-Latch & Q-Release:</strong> Lắp đặt ổ cứng SSD NVMe và tản nhiệt giáp nhôm hoàn toàn không cần tua-vít.</li>
<li><strong>Wi-Fi Q-Antenna:</strong> Ăng-ten thu sóng Wi-Fi 7 dạng cắm trực tiếp (Plug-and-Play) tiện lợi.</li>
</ul>
<h3>2. Dàn cấp nguồn VRM khủng và AI Overclocking</h3>
<p>Flagship <strong>ROG Maximus Z890 Extreme</strong> và <strong>Hero</strong> sở hữu dàn phase nguồn 24+1+2 phase 110A, trang bị màn hình OLED Anime Matrix hiển thị thông số thời gian thực cùng hệ thống tản nhiệt I/O nhôm nguyên khối mạ niken sang trọng.</p>', 'https://dlcdnwebimgs.asus.com/gain/A3777166-EF70-4D33-915B-EC7B6814F00E/w800', 1, 1, 'PUBLISHED', N'Bo mạch chủ ASUS ROG Z890 và X870E Wi-Fi 7 - LuxuryPC', N'Khám phá loạt mainboard cao cấp ASUS ROG Z890 Hero, Extreme hỗ trợ PCIe 5.0 và tháo lắp không cần ốc vít.', N'ASUS ROG Z890, X870E, ROG Maximus, Wi-Fi 7, mainboard gaming', 16750, '2026-03-01 16:20:00', '2026-03-01 16:20:00'),
(5, N'Khai trương Showroom Luxury PC Flagship Store tại Hà Nội với loạt ưu đãi tới 50%', 'khai-truong-showroom-luxurypc-flagship-ha-noi', N'Luxury PC chính thức khai trương trung tâm trải nghiệm PC Gaming & Workstation cao cấp lớn nhất miền Bắc với chương trình giảm giá lên đến 50% cùng hàng trăm quà tặng độc quyền.', N'<p>Hôm nay, <strong>Luxury PC</strong> đã chính thức cắt băng khánh thành trung tâm trải nghiệm công nghệ cao cấp <em>Flagship Store</em> tọa lạc tại trung tâm thành phố Hà Nội.</p>
<p>Với diện tích hơn 500m2 sàn, showroom mang tới không gian trải nghiệm đẳng cấp quốc tế bao gồm:</p>
<ul>
<li>Khu vực trải nghiệm <strong>PC Gaming Siêu Cấp</strong> trang bị RTX 5090, màn hình cong OLED 49 inch 240Hz.</li>
<li>Khu vực <strong>Custom Water Cooling Studio</strong> trưng bày các tác phẩm PC tản nhiệt nước ống đồng, ống acrylic uốn nghệ thuật.</li>
<li>Khu vực <strong>Góc Làm Việc Công Thái Học (Setup Ergonomic)</strong> dành cho Designer, Coder và Streamer.</li>
</ul>
<p>Trong tuần lễ khai trương từ 15/03 đến 22/03, Luxury PC triển khai chương trình bốc thăm may mắn trúng Card đồ họa trị giá 40 triệu đồng, tặng Voucher giảm giá 2.000.000đ cho mọi đơn build PC từ 25 triệu đồng.</p>', 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=1000&q=80', 1, 1, 'PUBLISHED', N'Khai trương Showroom Luxury PC Flagship Store Hà Nội', N'Luxury PC khai trương không gian trải nghiệm PC Gaming & Custom nước hoành tráng kèm ưu đãi giảm tới 50%.', N'khai trương Luxury PC, showroom máy tính Hà Nội, ưu đãi build PC, quà tặng khai trương', 35200, '2026-03-15 08:00:00', '2026-03-15 08:00:00'),
(6, N'Hướng dẫn tự lắp ráp PC Gaming từ A-Z cho người mới bắt đầu cực kỳ chi tiết', 'huong-dan-tu-lap-rap-pc-gaming-tu-a-z-cho-nguoi-moi', N'Từng bước hướng dẫn lắp CPU, tra keo tản nhiệt, gắn RAM, lắp tản nhiệt nước AIO, cắm nguồn và đi dây cáp gọn gàng, an toàn, chuẩn kỹ thuật 100%.', N'<p>Tự tay lắp ráp một cỗ máy PC Gaming theo sở thích là trải nghiệm vô cùng thú vị. Dưới đây là quy trình 7 bước chuẩn kỹ thuật từ đội ngũ chuyên gia của <strong>Luxury PC</strong>:</p>
<h3>Bước 1: Chuẩn bị không gian và công cụ</h3>
<p>Chuẩn bị một chiếc tua-vít 4 cạnh có từ tính, dây rút nhựa, kéo và làm việc trên mặt bàn gỗ phẳng, khô ráo, tránh tĩnh điện.</p>
<h3>Bước 2: Lắp CPU, RAM và SSD lên Mainboard trước khi đưa vào Case</h3>
<p>Mở ngàm socket trên bo mạch chủ, căn chuẩn hình tam giác vàng trên góc CPU khớp với ký hiệu trên socket rồi hạ nhẹ nhàng. Lắp RAM vào các khe cắm ưu tiên (khe 2 và khe 4) để kích hoạt kênh đôi Dual Channel.</p>
<h3>Bước 3: Lắp đặt Mainboard và Tản nhiệt</h3>
<p>Bắt ốc đệm (standoff) vào thùng case, gắn chặn main (I/O Shield) rồi siết cố định bo mạch chủ. Bôi lượng keo tản nhiệt bằng hạt đậu nhỏ ở giữa bề mặt CPU trước khi siết tản nhiệt theo đường chéo cân bằng.</p>
<h3>Bước 4: Lắp Nguồn (PSU) và Cắm dây nguồn</h3>
<p>Cắm các đầu dây cấp nguồn quan trọng: 24-pin Mainboard, 8-pin CPU, dây Audio/Front Panel và dây nguồn PCIe cấp cho card đồ họa.</p>', 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?auto=format&fit=crop&w=1000&q=80', 1, 2, 'PUBLISHED', N'Hướng dẫn tự lắp ráp PC Gaming từ A-Z chi tiết nhất - LuxuryPC', N'Cẩm nang hướng dẫn tự lắp ráp PC Gaming cho người mới bắt đầu với hình ảnh và các lưu ý an toàn.', N'hướng dẫn build pc, tự lắp máy tính, cách gắn cpu, cắm dây nguồn pc', 48200, '2026-01-05 11:20:00', '2026-01-05 11:20:00'),
(7, N'Cách đi dây nguồn (Cable Management) chuyên nghiệp giúp thùng máy đẹp và thông thoáng', 'cach-di-day-nguon-cable-management-chuyen-nghiep-thong-thoang', N'Chia sẻ bí quyết giấu dây, sử dụng dây nối bọc lưới custom, bố trí quạt hút/thổi tạo áp suất dương tối ưu cho luồng khí tản nhiệt bên trong case.', N'<p>Một thùng máy có hệ thống dây cáp gọn gàng không chỉ nâng tầm tính thẩm mỹ mà còn giúp luồng không khí lưu thông tối ưu, giảm từ 3 đến 5 độ C cho các linh kiện quan trọng.</p>
<h3>Nguyên tắc vàng khi giấu dây nguồn:</h3>
<ol>
<li><strong>Phân luồng dây trước khi buộc:</strong> Tách riêng nhóm dây nguồn 24-pin, dây CPU 8-pin và dây SATA/Fan ARGB.</li>
<li><strong>Sử dụng dây nguồn bọc lưới (Sleeved Cable Extensions):</strong> Giúp tạo các đường cong mềm mại ở mặt trước kính cường lực.</li>
<li><strong>Tận dụng khoang giấu dây sau nắp lưng:</strong> Cố định dây bằng dây dán Velcro hoặc dây rút nhựa theo các đường rãnh có sẵn của vỏ case.</li>
</ol>', 'https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?auto=format&fit=crop&w=1000&q=80', 1, 2, 'PUBLISHED', N'Cách đi dây nguồn PC Cable Management đẹp mắt - LuxuryPC', N'Mẹo giấu dây nguồn máy tính chuyên nghiệp, thẩm mỹ và tăng lưu thông gió tản nhiệt.', N'cable management, đi dây pc, giấu dây nguồn case, mod dây pc đẹp', 21500, '2026-02-18 15:40:00', '2026-02-18 15:40:00'),
(8, N'Hướng dẫn lắp đặt tản nhiệt nước AIO chuẩn kỹ thuật: Đặt Radiator ở đâu tốt nhất?', 'huong-dan-lap-dat-tan-nhiet-nuoc-aio-radiator-chuan-ky-thuat', N'Phân tích ưu nhược điểm khi gắn Radiator ở nóc (Top) hay mặt trước (Front), tránh hiện tượng bọt khí lọt vào bơm gây tiếng ồn và giảm tuổi thọ tản nhiệt.', N'<p>Tản nhiệt nước All-in-One (AIO) ngày càng phổ biến nhờ hiệu năng giải nhiệt vượt trội và hiệu ứng đèn LED RGB bắt mắt. Tuy nhiên, vị trí đặt két nước (Radiator) ảnh hưởng trực tiếp đến tuổi thọ của bơm nước.</p>
<h3>1. Vị trí tối ưu nhất: Gắn Radiator ở Nóc Case (Top Exhaust)</h3>
<p>Khi gắn trên nóc, két nước nằm ở vị trí cao nhất của toàn bộ vòng tuần hoàn. Bọt khí trong dung dịch làm mát tự nhiên sẽ tích tụ tại đỉnh két nước, hoàn toàn không thể lọt vào cụm bơm (Pump) gắn trên mặt CPU. Bơm sẽ luôn được ngập hoàn toàn trong chất lỏng, vận hành êm ái và đạt tuổi thọ tối đa.</p>
<h3>2. Vị trí thứ hai: Gắn ở Mặt Trước (Front Mount)</h3>
<p>Nếu gắn mặt trước, hãy đảm bảo <strong>đầu ống dẫn nước của Radiator quay xuống phía dưới</strong> hoặc phần đỉnh của két nước phải cao hơn vị trí của Block CPU.</p>', 'https://res.cloudinary.com/corsair-pwa/image/upload/v1665096094/akamai/landing/virtuoso/assets/images/VIRTUOSO-White.png', 1, 2, 'PUBLISHED', N'Vị trí lắp Radiator tản nhiệt nước AIO tốt nhất - LuxuryPC', N'Hướng dẫn lắp tản nhiệt nước AIO đúng cách, tránh bọt khí vào bơm và tăng độ bền tản nhiệt.', N'lắp tản nhiệt nước AIO, vị trí radiator, pump cpu, tản nước corsair kraken', 28900, '2026-03-05 09:10:00', '2026-03-05 09:10:00'),
(9, N'Cách cài đặt Windows 11 chuẩn UEFI và tối ưu hóa hệ thống sau khi lắp ráp PC', 'cai-dat-windows-11-uefi-va-toi-uu-he-thong-sau-build-pc', N'Hướng dẫn tạo USB cài Windows 11, kích hoạt XMP/EXPO trong BIOS, cài đặt driver chipset, card đồ họa và thiết lập power plan tối ưu cho gaming.', N'<p>Sau khi hoàn thành phần cứng, việc cấu hình phần mềm chuẩn xác sẽ quyết định 100% độ mượt mà và ổn định của chiếc PC Gaming.</p>
<h3>1. Cấu hình BIOS chuẩn xác ngay lần đầu khởi động</h3>
<ul>
<li>Bật tính năng <strong>XMP (với Intel)</strong> hoặc <strong>EXPO (với AMD)</strong> để RAM chạy đúng tốc độ bus danh định (ví dụ 6000MHz thay vì mặc định 4800MHz).</li>
<li>Kích hoạt <strong>Resize BAR / Smart Access Memory (SAM)</strong> để CPU truy cập trực tiếp vào toàn bộ VRAM của card đồ họa.</li>
<li>Bật TPM 2.0 và Secure Boot để đáp ứng yêu cầu cài đặt Windows 11.</li>
</ul>
<h3>2. Cài đặt Driver đầy đủ theo thứ tự chuẩn</h3>
<p>Luôn cài đặt Driver Chipset bo mạch chủ trước tiên, sau đó đến Driver Card đồ họa (NVIDIA Game Ready hoặc AMD Adrenalin), Driver mạng LAN/Wi-Fi và Driver Audio.</p>', 'https://images.unsplash.com/photo-1629654297299-c8506221ca97?auto=format&fit=crop&w=1000&q=80', 1, 2, 'PUBLISHED', N'Cài đặt Windows 11 UEFI và tối ưu BIOS sau build PC - LuxuryPC', N'Hướng dẫn các bước cài đặt hệ điều hành và tối ưu hóa phần mềm sau khi tự lắp ráp máy tính.', N'cài windows 11 uefi, bật xmp bios, cài driver card màn hình, tối ưu máy tính mới', 33400, '2026-04-02 13:25:00', '2026-04-02 13:25:00'),
(10, N'Hướng dẫn nâng cấp linh kiện máy tính cũ: Thứ tự ưu tiên để đạt hiệu năng cao nhất', 'huong-dan-nang-cap-linh-kien-may-tinh-cu-toi-uu-hieu-nang', N'Nên nâng cấp SSD NVMe, RAM, Card đồ họa hay CPU trước? Đánh giá tình trạng nghẽn cổ chai (Bottleneck) để đầu tư ngân sách đúng chỗ.', N'<p>Nâng cấp máy tính cũ là phương án kinh tế giúp kéo dài tuổi thọ bộ máy mà không cần tốn quá nhiều chi phí để build mới hoàn toàn.</p>
<h3>Thứ tự ưu tiên nâng cấp mang lại hiệu quả tức thì:</h3>
<ol>
<li><strong>Ổ cứng SSD NVMe PCIe:</strong> Nếu bạn vẫn đang dùng ổ HDD hoặc SSD SATA 2.5 inch cũ, việc chuyển hệ điều hành sang ổ SSD NVMe tốc độ 3500MB/s - 7000MB/s sẽ giúp máy khởi động trong 5 giây và mở ứng dụng tức thì.</li>
<li><strong>Dung lượng RAM (Tối thiểu 16GB - 32GB):</strong> Tránh tình trạng tràn RAM gây giật lag khi vừa chơi game vừa mở hàng chục tab trình duyệt.</li>
<li><strong>Card màn hình (GPU):</strong> Yếu tố quyết định số khung hình (FPS) trong game. Hãy đảm bảo bộ nguồn (PSU) đủ công suất gánh card mới.</li>
</ol>', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=1000&q=80', 1, 2, 'PUBLISHED', N'Thứ tự ưu tiên nâng cấp linh kiện PC cũ - LuxuryPC', N'Nên nâng cấp linh kiện máy tính nào trước để đạt hiệu năng tối ưu nhất với chi phí tiết kiệm.', N'nâng cấp pc cũ, nâng ram, thay ssd nvme, nâng cấp card đồ họa, tránh nghẽn cổ chai', 18200, '2026-05-12 10:45:00', '2026-05-12 10:45:00'),
(11, N'Top cấu hình PC Gaming đáng mua nhất 2026 theo từng phân khúc từ 15 triệu đến 100 triệu', 'top-cau-hinh-pc-gaming-dang-mua-nhat-2026-cac-phan-khuc', N'Tổng hợp danh sách cấu hình PC Gaming từ phân khúc quốc dân giá rẻ (Core i5/RTX 4060) đến cỗ máy quái vật 4K Ultra Settings (Ultra 9/RTX 5090).', N'<p>Năm 2026 chứng kiến sự bùng nổ của nhiều nền tảng phần cứng mới. Luxury PC tổng hợp 3 cấu hình tiêu biểu đại diện cho các mức ngân sách:</p>
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
<p>Sự kết hợp giữa <strong>Intel Core Ultra 9 285K</strong> cùng <strong>GeForce RTX 5090 32GB</strong> trên bo mạch chủ ASUS ROG Maximus Z890 Hero.</p>', 'https://images.unsplash.com/photo-1593640408182-31c70c8268f5?auto=format&fit=crop&w=1000&q=80', 1, 3, 'PUBLISHED', N'Top cấu hình PC Gaming đáng mua nhất 2026 - LuxuryPC', N'Gợi ý các cấu hình PC chơi game tối ưu nhất theo ngân sách từ 15 triệu đến 100 triệu đồng năm 2026.', N'cấu hình pc gaming 2026, build máy tính chơi game, pc 15 triệu, pc 30 triệu, pc rtx 5090', 52100, '2026-01-18 14:00:00', '2026-01-18 14:00:00'),
(12, N'Tư vấn chọn nguồn máy tính (PSU): Công suất bao nhiêu Watt là đủ và cách đọc chuẩn 80 Plus', 'tu-van-chon-nguon-may-tinh-psu-chuan-80-plus-atx-31', N'Hướng dẫn tính toán công suất nguồn (TDP) cho toàn bộ linh kiện, giải thích các chuẩn Bronze, Gold, Platinum và cổng cấp nguồn chuẩn ATX 3.1 12V-2x6 mới nhất.', N'<p>Bộ nguồn (PSU) được ví như trái tim của dàn máy. Lựa chọn nguồn chất lượng tốt đảm bảo cấp dòng điện sạch, bảo vệ các linh kiện đắt tiền khỏi sự cố sụt áp hay chập cháy.</p>
<h3>Cách tính công suất nguồn cần thiết:</h3>
<p>Công thức cơ bản: <strong>Công suất PSU khuyên dùng = (TDP CPU + TDP GPU + 150W cho linh kiện phụ) x 1.3 (Hệ số an toàn)</strong></p>
<ul>
<li>Dàn máy i5 + RTX 4060: Khuyên dùng nguồn <strong>550W - 650W</strong> (Chuẩn Bronze).</li>
<li>Dàn máy i7/R7 + RTX 4070 Ti / 5070: Khuyên dùng nguồn <strong>750W - 850W</strong> (Chuẩn Gold).</li>
<li>Dàn máy Ultra 9/R9 + RTX 4090 / 5090: Khuyên dùng nguồn <strong>1000W - 1200W</strong> (Chuẩn ATX 3.1 Gold/Platinum).</li>
</ul>', 'https://images.unsplash.com/photo-1555680202-c86f0e12f086?auto=format&fit=crop&w=1000&q=80', 1, 3, 'PUBLISHED', N'Tư vấn chọn nguồn máy tính PSU chuẩn 80 Plus - LuxuryPC', N'Hướng dẫn tính toán công suất nguồn và chọn mua PSU máy tính an toàn, bền bỉ chuẩn ATX 3.1.', N'chọn nguồn máy tính, psu 650w, psu 850w gold, nguồn corsair rm850e, nguồn atx 3.1', 26700, '2026-02-28 09:30:00', '2026-02-28 09:30:00'),
(13, N'Nên chọn Intel Core Ultra hay AMD Ryzen 9000 cho nhu cầu đồ họa, dựng phim 4K/8K?', 'so-sanh-intel-core-ultra-vs-amd-ryzen-9000-cho-do-hoa-render', N'Đánh giá chi tiết hiệu năng Premiere Pro, After Effects, DaVinci Resolve, Blender và V-Ray giữa hai dòng vi xử lý đầu bảng từ Intel và AMD.', N'<p>Cuộc chiến giữa Intel Core Ultra 200S và AMD Ryzen 9000 Series (Granite Ridge) đang mang lại nhiều lựa chọn chất lượng cho các nhà sáng tạo nội dung chuyên nghiệp.</p>
<h3>1. Dựng phim Premiere Pro & After Effects: Lợi thế Intel QuickSync</h3>
<p>Nếu quy trình làm việc sử dụng nhiều định dạng video nén H.264/H.265 (HEVC 4:2:2 10-bit), nhân đồ họa tích hợp Intel Graphics với công nghệ <strong>QuickSync Video</strong> giúp giải mã timeline mượt mà mà không cần render proxy.</p>
<h3>2. Render 3D Blender, V-Ray & Unreal Engine: Sức mạnh đa nhân AMD</h3>
<p>Với các tác vụ render thuần CPU đa luồng, kiến trúc Zen 5 của Ryzen 9 9950X cho tốc độ xử lý nhanh hơn 8-12% và nhiệt độ vận hành ổn định trong các phiên render kéo dài liên tục hàng chục tiếng.</p>', 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=1000&q=80', 1, 3, 'PUBLISHED', N'So sánh Intel Core Ultra vs AMD Ryzen 9000 dựng phim đồ họa', N'Phân tích lựa chọn CPU Intel hay AMD tối ưu nhất cho Premiere Pro, After Effects, Blender và 3D rendering.', N'so sánh intel amd, cpu làm đồ họa, render video 4k, intel quicksync, ryzen 9 9950x', 24100, '2026-03-20 11:15:00', '2026-03-20 11:15:00'),
(14, N'Bí quyết chọn màn hình Gaming: Tần số quét cao, tấm nền IPS hay OLED mới là chân ái?', 'bi-quyet-chon-man-hinh-gaming-ips-vs-oled-tan-so-quet', N'Phân tích sự khác biệt giữa độ phân giải 2K/4K, tần số quét 144Hz - 360Hz, thời gian phản hồi GtG và độ tương phản tuyệt đối của màn hình OLED thế hệ mới.', N'<p>Màn hình là cửa sổ giao tiếp giữa game thủ và thế giới ảo. Đầu tư một chiếc màn hình đúng chuẩn sẽ thay đổi hoàn toàn cảm nhận thị giác của bạn.</p>
<h3>So sánh tấm nền IPS và QD-OLED:</h3>
<ul>
<li><strong>Tấm nền Fast-IPS:</strong> Màu sắc chuẩn xác, góc nhìn rộng, độ sáng cao, không lo hiện tượng lưu ảnh (burn-in), giá thành rất dễ tiếp cận trong tầm giá từ 4 đến 10 triệu đồng.</li>
<li><strong>Tấm nền QD-OLED / WOLED:</strong> Độ tương phản vô cực, màu đen sâu tuyệt đối, thời gian phản hồi siêu tốc 0.03ms (GtG) loại bỏ bóng mờ hoàn toàn, tần số quét lên tới 360Hz - 480Hz. Lựa chọn số 1 cho game thủ hardcore và thi đấu Esports.</li>
</ul>', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=1000&q=80', 1, 3, 'PUBLISHED', N'Bí quyết chọn màn hình Gaming IPS vs OLED - LuxuryPC', N'Hướng dẫn chọn mua màn hình chơi game 2K 4K tần số quét cao phù hợp cho Esports và game AAA.', N'màn hình gaming, màn hình oled, màn hình 240hz, màn hình ips 2k, asus rog oled', 19500, '2026-04-10 16:50:00', '2026-04-10 16:50:00'),
(15, N'Tư vấn cấu hình PC làm việc tại nhà (Workstation) cho lập trình viên, Data Science và AI', 'tu-van-cau-hinh-pc-workstation-lap-trinh-data-science-ai', N'Gợi ý phần cứng chuyên biệt chạy mô hình LLM cục bộ, train Deep Learning với dung lượng VRAM lớn và bộ nhớ RAM đa kênh dung lượng 64GB - 128GB.', N'<p>Nhu cầu chạy các mô hình ngôn ngữ lớn (LLM như Llama 3, DeepSeek, Mistral) và huấn luyện mô hình Machine Learning trực tiếp trên máy trạm cá nhân đang phát triển bùng nổ.</p>
<h3>Các tiêu chí cốt lõi khi build PC cho AI Engineer:</h3>
<ol>
<li><strong>Dung lượng VRAM Card đồ họa là số 1:</strong> Khác với gaming cần xung nhịp cao, mô hình AI yêu cầu nạp toàn bộ tham số vào bộ nhớ VRAM. Cấu hình tối thiểu khuyến nghị từ 16GB VRAM (RTX 4060 Ti 16GB, RTX 4070 Ti Super 16GB) đến 24GB - 32GB VRAM (RTX 4090, RTX 5090).</li>
<li><strong>RAM hệ thống từ 64GB trở lên:</strong> Đảm bảo dung lượng để xử lý tập dữ liệu lớn (Big Data) và chạy máy ảo Docker/Kubernetes song song.</li>
<li><strong>Ổ cứng SSD NVMe chuẩn PCIe 4.0/5.0 dung lượng 2TB - 4TB:</strong> Tốc độ đọc ghi ngẫu nhiên 4K cao giúp nạp hàng triệu tệp dữ liệu huấn luyện siêu nhanh.</li>
</ol>', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=1000&q=80', 1, 3, 'PUBLISHED', N'Tư vấn cấu hình PC Workstation cho AI và Data Science', N'Gợi ý cấu hình máy tính trạm chạy mô hình AI LLM, Deep Learning và lập trình chuyên nghiệp.', N'pc workstation ai, máy tính chạy llm, train deep learning, pc 64gb ram, rtx 4090 ai', 27300, '2026-05-02 08:40:00', '2026-05-02 08:40:00'),
(16, N'Cách bật XMP/EXPO để RAM chạy đúng tốc độ Bus cao nhất trong BIOS cực đơn giản', 'cach-bat-xmp-expo-cho-ram-chay-dung-bus-trong-bios', N'Hướng dẫn chi tiết cách vào BIOS bo mạch chủ ASUS, MSI, GIGABYTE, ASRock để bật profile ép xung bộ nhớ, giúp máy tính gia tăng 15-25% hiệu năng tức thì.', N'<p>Rất nhiều người dùng mua thanh RAM có thông số 6000MHz hoặc 6400MHz nhưng khi về cắm vào máy chỉ chạy ở tốc độ mặc định 4800MHz do chưa bật tính năng ép xung trong BIOS.</p>
<h3>Cách bật chỉ với 3 bước:</h3>
<ol>
<li>Khởi động máy tính và liên tục nhấn phím <strong>Del</strong> hoặc <strong>F2</strong> để vào giao diện BIOS.</li>
<li>Tìm mục <strong>Extreme Tweaker / Ai Tweaker (ASUS)</strong>, <strong>OC (MSI)</strong> hoặc <strong>Tweaker (GIGABYTE)</strong>.</li>
<li>Tìm dòng <strong>Memory Profile / X.M.P / EXPO</strong> và chuyển từ <em>Disabled</em> sang <strong>Profile 1</strong>.</li>
<li>Nhấn <strong>F10</strong> để lưu lại thiết lập và khởi động lại máy.</li>
</ol>
<p>Kiểm tra lại trong Task Manager mục <em>Performance -> Memory</em>, bạn sẽ thấy tốc độ bus RAM đã đạt mức tối đa!</p>', 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1000&q=80', 1, 4, 'PUBLISHED', N'Cách bật XMP EXPO RAM trong BIOS dễ hiểu nhất - LuxuryPC', N'Hướng dẫn cách bật XMP và AMD EXPO để mở khóa tốc độ bus RAM tối đa trong BIOS các hãng mainboard.', N'bật xmp bios, bật expo amd, ram không nhận đủ bus, ép xung ram xmp', 38900, '2026-01-28 10:15:00', '2026-01-28 10:15:00'),
(17, N'10 Cách hạ nhiệt độ CPU và Card đồ họa hiệu quả trong mùa hè không tốn kém', '10-cach-ha-nhiet-do-cpu-va-gpu-mua-he-hieu-qua', N'Thủ thuật Undervolt an toàn, cân chỉnh đường cong quạt (Fan Curve) tối ưu, vệ sinh bụi định kỳ và lựa chọn keo tản nhiệt gốm kim loại chất lượng cao.', N'<p>Mùa hè nắng nóng tại Việt Nam là thử thách lớn đối với các dàn PC hiệu năng cao. Áp dụng ngay các mẹo sau để giữ linh kiện luôn mát mẻ:</p>
<ul>
<li><strong>1. Tinh chỉnh Undervolt nhẹ:</strong> Giảm điện áp cấp cho CPU/GPU từ 0.05V - 0.1V giúp giảm ngay 7-10 độ C mà hiệu năng chơi game không suy giảm.</li>
<li><strong>2. Tối ưu Fan Curve trong phần mềm:</strong> Sử dụng phần mềm Fan Control hoặc BIOS để thiết lập quạt tăng tốc sớm hơn khi nhiệt độ chạm mốc 65 độ C.</li>
<li><strong>3. Tra lại keo tản nhiệt định kỳ:</strong> Thay keo tản nhiệt sau mỗi 12-18 tháng bằng các dòng keo cao cấp như Thermal Grizzly Kryonaut, Noctua NT-H2 hoặc Arctic MX-6.</li>
<li><strong>4. Đặt thùng máy ở nơi thông thoáng:</strong> Cách tường tối thiểu 15cm, tránh để case dưới gầm bàn bí bách.</li>
</ul>', 'https://images.unsplash.com/photo-1591488320449-011701bb6704?auto=format&fit=crop&w=1000&q=80', 1, 4, 'PUBLISHED', N'10 Cách hạ nhiệt độ CPU và Card đồ họa mùa hè - LuxuryPC', N'Chia sẻ kinh nghiệm làm mát thùng máy tính, undervolt và tối ưu quạt tản nhiệt trong mùa hè.', N'hạ nhiệt cpu, làm mát máy tính, undervolt gpu, keo tản nhiệt tốt, fan curve pc', 29400, '2026-02-25 14:30:00', '2026-02-25 14:30:00'),
(18, N'Thủ thuật tối ưu hóa Windows 11 tăng FPS khi chơi game Esports cực mượt mà', 'thu-thuat-toi-uu-hoa-windows-11-tang-fps-choi-game', N'Tắt Game Bar không cần thiết, bật Hardware-Accelerated GPU Scheduling (HAGS), tắt hiệu ứng chuyển động và tối ưu hóa dịch vụ chạy ngầm.', N'<p>Windows 11 có nhiều tính năng nền hữu ích cho công việc nhưng đôi khi gây trễ độ phản hồi (Input Lag) trong các tựa game bắn súng đòi hỏi phản xạ nhanh như Valorant, CS2 hay Apex Legends.</p>
<h3>Các bước tối ưu hệ điều hành cho game thủ:</h3>
<ol>
<li><strong>Bật Hardware-Accelerated GPU Scheduling (HAGS):</strong> Vào <em>Settings -> System -> Display -> Graphics -> Change default graphics settings</em> và bật tính năng này lên.</li>
<li><strong>Kích hoạt Game Mode:</strong> Đảm bảo <em>Game Mode</em> đang ở trạng thái ON để Windows ưu tiên phân bổ tài nguyên CPU/RAM cho trò chơi.</li>
<li><strong>Tắt Memory Integrity (Tính toàn vẹn bộ nhớ):</strong> Nếu máy tính chỉ dùng chơi game cá nhân, việc tắt Core Isolation có thể giúp gia tăng 5-10% khung hình trong game CPU-bound.</li>
</ol>', 'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=1000&q=80', 1, 4, 'PUBLISHED', N'Tối ưu hóa Windows 11 tăng FPS chơi game mượt - LuxuryPC', N'Các thủ thuật tinh chỉnh Windows 11 giúp tăng FPS, giảm giật lag và giảm input lag khi chơi game.', N'tối ưu windows 11, tăng fps valorant, giảm lag cs2, hags windows 11, game mode', 45600, '2026-03-12 18:20:00', '2026-03-12 18:20:00'),
(19, N'Cách khắc phục lỗi màn hình xanh (BSOD) thường gặp trên máy tính chạy Windows', 'cach-khac-phuc-loi-man-hinh-xanh-bsod-tren-may-tinh', N'Phân tích các mã lỗi phổ biến như MEMORY_MANAGEMENT, CRITICAL_PROCESS_DIED, WHEA_UNCORRECTABLE_ERROR và hướng dẫn cách test RAM, kiểm tra ổ cứng SSD.', N'<p>Lỗi màn hình xanh chết chóc (Blue Screen of Death - BSOD) là nỗi ám ảnh của người dùng máy tính. Tuy nhiên, mã lỗi hiển thị dưới đáy màn hình sẽ chỉ ra chính xác nguyên nhân gốc rễ.</p>
<h3>Các mã lỗi BSOD thông dụng và cách xử lý:</h3>
<ul>
<li><strong>MEMORY_MANAGEMENT:</strong> Lỗi liên quan đến bộ nhớ RAM. Tháo từng thanh RAM ra vệ sinh chân tiếp xúc bằng cồn 90 độ, thử đổi khe cắm hoặc chạy công cụ <em>Windows Memory Diagnostic</em>.</li>
<li><strong>WHEA_UNCORRECTABLE_ERROR:</strong> Lỗi phần cứng nghiêm trọng do CPU bị ép xung quá mức hoặc thiếu điện áp (Vcore). Hãy Reset BIOS về thiết lập mặc định (Load Optimized Defaults).</li>
<li><strong>INACCESSIBLE_BOOT_DEVICE:</strong> Ổ cứng SSD bị lỏng cáp hoặc driver AHCI/NVMe bị lỗi.</li>
</ul>', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=1000&q=80', 1, 4, 'PUBLISHED', N'Cách sửa lỗi màn hình xanh BSOD Windows - LuxuryPC', N'Hướng dẫn chẩn đoán và khắc phục triệt để các mã lỗi màn hình xanh máy tính phổ biến.', N'sửa lỗi bsod, lỗi màn hình xanh, memory management, whea uncorrectable error, test ram', 23800, '2026-04-15 11:30:00', '2026-04-15 11:30:00'),
(20, N'Hướng dẫn sử dụng DDU để gỡ sạch Driver Card màn hình cũ tránh xung đột phần mềm', 'huong-dan-su-dung-ddu-go-sach-driver-card-man-hinh', N'Cách sử dụng phần mềm Display Driver Uninstaller trong Safe Mode để cài mới driver NVIDIA hoặc AMD, giải quyết triệt để lỗi giật lag, drop FPS hoặc crash game.', N'<p>Khi đổi từ card đồ họa NVIDIA sang AMD (hoặc ngược lại), hoặc khi driver đồ họa bị lỗi gây crash game, công cụ <strong>DDU (Display Driver Uninstaller)</strong> là cứu cánh số một.</p>
<h3>Quy trình gỡ sạch Driver chuẩn kỹ thuật viên:</h3>
<ol>
<li>Tải trước bộ cài Driver mới nhất từ trang chủ NVIDIA/AMD về máy tính.</li>
<li>Tải phần mềm <strong>DDU</strong> từ Wagnardsoft và giải nén.</li>
<li>Khởi động Windows vào chế độ <strong>Safe Mode</strong> (Giữ phím Shift trong khi bấm Restart trong Start Menu).</li>
<li>Mở DDU, chọn loại thiết bị <em>GPU</em> và hãng tương ứng (NVIDIA/AMD).</li>
<li>Bấm nút <strong>Clean and restart</strong>. Sau khi máy khởi động lại vào Windows bình thường, tiến hành cài đặt bộ driver mới đã tải sẵn.</li>
</ol>', 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=1000&q=80', 1, 4, 'PUBLISHED', N'Hướng dẫn sử dụng DDU gỡ sạch driver card màn hình - LuxuryPC', N'Cách dùng Display Driver Uninstaller trong Safe Mode để dọn sạch driver GPU cũ không để lại file rác.', N'ddu gỡ driver, display driver uninstaller, cài lại driver nvidia, lỗi crash game gpu', 17900, '2026-05-18 16:00:00', '2026-05-18 16:00:00'),
(21, N'Đánh giá chi tiết Card đồ họa ASUS ROG Strix GeForce RTX 5090 24GB: Quái vật hiệu năng 4K', 'danh-gia-asus-rog-strix-geforce-rtx-5090-24gb', N'Trải nghiệm thực tế sức mạnh của GPU mạnh nhất thế giới với nhiệt độ cực mát nhờ hệ thống tản nhiệt buồng hơi Vapor Chamber và thiết kế kim loại hầm hố.', N'<p><strong>ASUS ROG Strix GeForce RTX 5090</strong> là biểu tượng đỉnh cao của làng phần cứng PC năm 2026, hội tụ sức mạnh đồ họa không đối thủ và thiết kế đậm chất tương lai.</p>
<h3>1. Thiết kế và Khả năng tản nhiệt</h3>
<p>Chiếm tới 3.5 slot PCI trên thùng máy với bộ khung hợp kim đúc nguyên khối, ROG Strix RTX 5090 sở hữu cụm 3 quạt Axial-tech thế hệ mới với vòng bi kép. Buồng hơi <em>Milled Vapor Chamber</em> tiếp xúc trực tiếp với die GPU giúp nhiệt độ khi chơi game nặng 4K chỉ dao động ở mức <strong>62 - 65 độ C</strong> với độ ồn cực kỳ êm ái.</p>
<h3>2. Hiệu năng Benchmark thực tế</h3>
<ul>
<li><strong>Cyberpunk 2077 (4K, Ray Tracing Overdrive, DLSS 4 Quality):</strong> Đạt trung bình 152 FPS.</li>
<li><strong>Black Myth: Wukong (4K, Cinematic Setting, Full Ray Tracing):</strong> Đạt trung bình 138 FPS.</li>
<li><strong>3DMark Time Spy Extreme:</strong> Đạt 26.400 điểm Graphics Score.</li>
</ul>
<p>Đây chắc chắn là linh kiện mơ ước cho mọi cỗ máy Gaming và AI Workstation tối thượng.</p>', 'https://cdn-ru.bitrix24.ru/b11322588/landing/90e/90ed69e925e0a6d59b2fe8e9075775f0/RTX5090_1x.png', 1, 5, 'PUBLISHED', N'Đánh giá ASUS ROG Strix RTX 5090 24GB - LuxuryPC', N'Review chi tiết hiệu năng và nhiệt độ card màn hình khủng nhất thế giới ASUS ROG Strix RTX 5090.', N'review rtx 5090, đánh giá asus rog strix 5090, benchmark rtx 5090, gpu mạnh nhất', 58900, '2026-01-15 08:30:00', '2026-01-15 08:30:00'),
(22, N'Review Vi xử lý Intel Core Ultra 9 285K: Bước chuyển mình kiến trúc với hiệu suất ấn tượng', 'review-vi-xu-ly-intel-core-ultra-9-285k', N'Benchmark chi tiết khả năng render Cinebench R23, Geekbench 6 và trải nghiệm chơi game thực tế so sánh với flagship thế hệ trước 14900K và Ryzen 9 7950X3D.', N'<p><strong>Intel Core Ultra 9 285K</strong> đại diện cho bước ngoặt lớn nhất của Intel trong thập kỷ qua khi chuyển hẳn sang thiết kế kiến trúc chiplet rời.</p>
<h3>1. Kết quả kiểm tra hiệu năng (Benchmark)</h3>
<p>Trong bài test dựng hình <strong>Cinebench R23 Đa nhân</strong>, Core Ultra 9 285K đạt hơn <strong>43.200 điểm</strong>, vượt trội so với i9-14900K trong khi công suất tiêu thụ điện giảm từ 330W xuống chỉ còn 250W ở mức tải tối đa.</p>
<h3>2. Nhiệt độ mát mẻ đáng kinh ngạc</h3>
<p>Nhờ tiến trình N3B tiên tiến và việc tối ưu vị trí hotspot nhiệt, khi kết hợp với tản nhiệt nước AIO 360mm, nhiệt độ tối đa khi Stress Test chỉ chạm ngưỡng <strong>78 - 82 độ C</strong>, loại bỏ hoàn toàn hiện tượng quá nhiệt thường thấy ở thế hệ 14th Gen.</p>', 'https://www.techpowerup.com/review/intel-core-ultra-9-285k/images/small.png', 1, 5, 'PUBLISHED', N'Review Intel Core Ultra 9 285K Benchmark chi tiết - LuxuryPC', N'Đánh giá hiệu năng và nhiệt độ CPU Intel Core Ultra 9 285K thế hệ Arrow Lake mới nhất.', N'review ultra 9 285k, benchmark core ultra 9, cpu arrow lake, intel core ultra 285k', 36700, '2026-02-05 13:45:00', '2026-02-05 13:45:00'),
(23, N'Đánh giá Bo mạch chủ GIGABYTE Z890 EAGLE WIFI7: Lựa chọn p/p tuyệt vời cho nền tảng LGA 1851', 'danh-gia-bo-mach-chu-gigabyte-z890-eagle-wifi7', N'Bo mạch chủ tầm trung nhưng trang bị đầy đủ dàn phase điện VRM 14+1+2 mạnh mẽ, kết nối Wi-Fi 7 thế hệ mới và tính năng EZ-Latch tháo lắp nhanh cực kỳ tiện lợi.', N'<p><strong>GIGABYTE Z890 EAGLE WIFI7</strong> là sự kết hợp hoàn hảo giữa mức giá dễ tiếp cận và những trang bị công nghệ cao cấp nhất của chipset Intel Z890.</p>
<h3>Những điểm sáng nổi bật trên sản phẩm:</h3>
<ul>
<li><strong>Dàn nguồn VRM 14+1+2 Phase:</strong> Đảm bảo cấp nguồn ổn định và khai thác tối đa sức mạnh của Core Ultra 7 265K và Ultra 9 285K.</li>
<li><strong>Wi-Fi 7 và LAN 2.5GbE:</strong> Tốc độ kết nối mạng không dây cực nhanh với độ trễ siêu thấp cho trải nghiệm gaming hoàn hảo.</li>
<li><strong>Hệ thống EZ-Latch:</strong> Tháo card đồ họa và gắn SSD NVMe hoàn toàn bằng ngàm bấm thông minh không cần ốc vít.</li>
</ul>', 'https://media.ldlc.com/r1600/ld/products/00/06/12/72/LD0006127272_1.jpg', 1, 5, 'PUBLISHED', N'Đánh giá GIGABYTE Z890 EAGLE WIFI7 - LuxuryPC', N'Review bo mạch chủ GIGABYTE Z890 Eagle WiFi7 hiệu năng cao, giá tốt cho chip Core Ultra.', N'gigabyte z890 eagle, mainboard z890, lga 1851, wifi 7 gigabyte, review mainboard', 21800, '2026-03-08 10:20:00', '2026-03-08 10:20:00'),
(24, N'Review Ổ cứng SSD Samsung 990 PRO 2TB: Chuẩn mực tốc độ NVMe PCIe 4.0 đỉnh cao', 'review-o-cung-ssd-samsung-990-pro-2tb-pcie-40', N'Tốc độ đọc ghi thực tế lên tới 7450 MB/s và 6900 MB/s, độ bền TBW cao cùng công nghệ quản lý nhiệt thông minh giúp vận hành ổn định trong thời gian dài.', N'<p><strong>Samsung 990 PRO</strong> vẫn khẳng định vị thế ông vua tốc độ trong phân khúc ổ cứng SSD NVMe chuẩn PCIe 4.0 x4.</p>
<h3>1. Hiệu năng đọc ghi ngẫu nhiên (Random Read/Write) vượt trội</h3>
<p>Nhờ vi điều khiển Samsung Pascal Controller độc quyền sản xuất trên tiến trình 8nm và chip nhớ V-NAND V7 TLC, ổ đĩa đạt thông số đọc ghi tuần tự <strong>7.450 MB/s và 6.900 MB/s</strong>, tốc độ đọc ngẫu nhiên lên tới 1.400.000 IOPS giúp load game 4K và khởi động dự án dựng phim nặng gần như lập tức.</p>
<h3>2. Phần mềm quản lý Samsung Magician</h3>
<p>Công cụ Magician cho phép người dùng dễ dàng theo dõi sức khỏe ổ đĩa, cập nhật firmware mới, kiểm tra nhiệt độ và kích hoạt chế độ Full Performance Mode để tối đa hóa hiệu năng.</p>', 'https://images.unsplash.com/photo-1597872200969-2b65d56bd16b?auto=format&fit=crop&w=1000&q=80', 1, 5, 'PUBLISHED', N'Review SSD Samsung 990 PRO 2TB - LuxuryPC', N'Đánh giá chi tiết tốc độ và độ bền của ổ cứng SSD NVMe tốt nhất hiện nay Samsung 990 PRO 2TB.', N'samsung 990 pro 2tb, review ssd samsung, ssd pcie 4.0, ổ cứng load game nhanh', 31400, '2026-04-18 15:10:00', '2026-04-18 15:10:00'),
(25, N'Đánh giá Vỏ case Corsair 3500X TG Black: Thiết kế Panoramic hồ cá view trọn vẹn góc máy', 'danh-gia-vo-case-corsair-3500x-tg-black-ho-ca', N'Mẫu case bể cá không viền cột chữ A hiện đại, hỗ trợ bo mạch chủ giấu dây BTF/Project Stealth, không gian lắp đặt tản nhiệt nước 360mm rộng rãi và thông thoáng.', N'<p><strong>Corsair 3500X TG</strong> là đại diện tiêu biểu cho xu hướng vỏ case bể cá Panoramic kính cường lực uốn cong liền mạch đang rất được ưa chuộng năm 2026.</p>
<h3>1. Tầm nhìn 270 độ không vật cản</h3>
<p>Bằng cách loại bỏ cột trụ góc chữ A phía trước, toàn bộ linh kiện bên trong dàn PC được phô diễn trọn vẹn như một tác phẩm nghệ thuật. Tấm kính cường lực dày dặn có cơ chế tháo lắp không cần ốc vít (Tool-free) tiện lợi.</p>
<h3>2. Tương thích hoàn hảo với Mainboard Giấu Dây (Reverse Connector)</h3>
<p>Khay lắp mainboard được thiết kế sẵn các lỗ khoét chuẩn xác hỗ trợ các dòng bo mạch chủ giấu dây ASUS BTF, MSI Project Zero và GIGABYTE Stealth, mang lại một khoang máy sạch bóng không một sợi dây thừa.</p>', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?auto=format&fit=crop&w=1000&q=80', 1, 5, 'PUBLISHED', N'Đánh giá Case Corsair 3500X TG Panoramic - LuxuryPC', N'Review vỏ case bể cá Corsair 3500X TG hỗ trợ mainboard giấu dây BTF và tản nhiệt nước 360mm.', N'corsair 3500x, case bể cá, case panoramic, mainboard giấu dây btf, review case pc', 27900, '2026-05-25 11:00:00', '2026-05-25 11:00:00');
SET IDENTITY_INSERT news OFF;
DBCC CHECKIDENT ('news', RESEED, 25);
GO


-- ----------------------------------------------------------------------------
-- 11. 20 MÃ GIẢM GIÁ VOUCHER ĐA DẠNG CHUẨN SHOPEE (FREESHIP, % GIẢM, GIÁ TRỊ CỐ ĐỊNH, VIP)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'user_vouchers') AND type IN ('U')) DELETE FROM user_vouchers;
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'vouchers') AND type IN ('U')) DELETE FROM vouchers;
GO
SET IDENTITY_INSERT vouchers ON;
INSERT INTO vouchers (id, code, description, discount_type, voucher_scope, discount_value, min_order_amount, max_discount_amount, usage_limit, used_count, category_id, start_date, end_date, active, created_at) VALUES

(1, 'FREESHIP50K', N'Miễn phí vận chuyển 50.000đ cho đơn hàng từ 500.000đ', 'FIXED_AMOUNT', 'FREESHIP', 50000.00, 500000.00, 50000.00, 1000, 86, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(2, 'FREESHIP100K', N'Miễn phí vận chuyển 100.000đ cho đơn hàng từ 2.000.000đ', 'FIXED_AMOUNT', 'FREESHIP', 100000.00, 2000000.00, 100000.00, 500, 42, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(3, 'FREESHIPMAX', N'Freeship Xtra toàn quốc tối đa 300.000đ cho đơn từ 10.000.000đ', 'FIXED_AMOUNT', 'FREESHIP', 300000.00, 10000000.00, 300000.00, 300, 19, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(4, 'WELCOME2026', N'Chào mừng bạn mới - Giảm 10% tối đa 500.000đ cho đơn từ 1.000.000đ', 'PERCENTAGE', 'GLOBAL', 10.00, 1000000.00, 500000.00, 2000, 315, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(5, 'NEWBIE100K', N'Quà tặng thành viên mới - Giảm ngay 100.000đ trực tiếp đơn từ 500.000đ', 'FIXED_AMOUNT', 'GLOBAL', 100000.00, 500000.00, 100000.00, 1500, 210, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(6, 'LUXURY500K', N'Giảm ngay 500.000đ cho đơn hàng linh kiện / PC từ 15.000.000đ', 'FIXED_AMOUNT', 'GLOBAL', 500000.00, 15000000.00, 500000.00, 500, 68, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(7, 'LUXURY1M', N'Giảm ngay 1.000.000đ cho đơn hàng High-End từ 30.000.000đ', 'FIXED_AMOUNT', 'GLOBAL', 1000000.00, 30000000.00, 1000000.00, 300, 45, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(8, 'LUXURY2M', N'Giảm siêu khủng 2.000.000đ cho dàn PC Flagship từ 50.000.000đ', 'FIXED_AMOUNT', 'GLOBAL', 2000000.00, 50000000.00, 2000000.00, 150, 28, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(9, 'MEGA10', N'Mega Voucher - Giảm 10% tối đa 1.500.000đ cho đơn từ 5.000.000đ', 'PERCENTAGE', 'GLOBAL', 10.00, 5000000.00, 1500000.00, 800, 142, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(10, 'MEGA15', N'Siêu Sale Giữa Tháng - Giảm 15% tối đa 2.500.000đ cho đơn từ 8.000.000đ', 'PERCENTAGE', 'GLOBAL', 15.00, 8000000.00, 2500000.00, 400, 89, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(11, 'BUILDPC500K', N'Ưu đãi Build PC Gaming - Giảm 500.000đ khi lắp trọn bộ từ 20.000.000đ', 'FIXED_AMOUNT', 'GLOBAL', 500000.00, 20000000.00, 500000.00, 600, 115, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(12, 'BUILDPC1M5', N'Ưu đãi PC Custom Watercooling - Giảm 1.500.000đ cho đơn từ 45.000.000đ', 'FIXED_AMOUNT', 'GLOBAL', 1500000.00, 45000000.00, 1500000.00, 200, 34, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(13, 'GAMINGGEAR10', N'Giảm 10% tối đa 300.000đ cho Bàn phím, Chuột, Tai nghe Gaming từ 800.000đ', 'PERCENTAGE', 'CATEGORY', 10.00, 800000.00, 300000.00, 1000, 240, 16, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(14, 'VGAFLASH200K', N'Giảm 200.000đ khi mua Card đồ họa VGA RTX 40/50 Series từ 7.000.000đ', 'FIXED_AMOUNT', 'CATEGORY', 200000.00, 7000000.00, 200000.00, 500, 92, 10, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(15, 'CPUKING150K', N'Giảm 150.000đ khi nâng cấp CPU Intel Core Ultra / Ryzen 9000 từ 4.000.000đ', 'FIXED_AMOUNT', 'CATEGORY', 150000.00, 4000000.00, 150000.00, 500, 78, 1, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(16, 'RAMSSD88K', N'Giảm 88.000đ khi mua RAM DDR5 hoặc Ổ cứng SSD NVMe từ 1.200.000đ', 'FIXED_AMOUNT', 'CATEGORY', 88000.00, 1200000.00, 88000.00, 800, 160, 3, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(17, 'FLASHSALE12H', N'Flash Sale Khung Giờ Vàng 12h - Giảm 12% tối đa 800.000đ đơn từ 2.500.000đ', 'PERCENTAGE', 'GLOBAL', 12.00, 2500000.00, 800000.00, 300, 145, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(18, 'MIDNIGHT50K', N'Cú Đêm Săn Sale (0h-2h) - Giảm ngay 50.000đ trực tiếp cho đơn từ 300.000đ', 'FIXED_AMOUNT', 'GLOBAL', 50000.00, 300000.00, 50000.00, 1000, 310, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(19, 'VIPMEMBER3M', N'Đặc quyền VIP Diamond - Giảm siêu ưu đãi 3.000.000đ cho đơn từ 60.000.000đ', 'FIXED_AMOUNT', 'GLOBAL', 3000000.00, 60000000.00, 3000000.00, 100, 18, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(20, 'LUXURYFEST20', N'Siêu Đại Tiệc Công Nghệ - Giảm 20% tối đa 5.000.000đ cho đơn từ 20.000.000đ', 'PERCENTAGE', 'GLOBAL', 20.00, 20000000.00, 500000.00, 150, 52, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00');
SET IDENTITY_INSERT vouchers OFF;
DBCC CHECKIDENT ('vouchers', RESEED, 20);
GO

-- ----------------------------------------------------------------------------
-- 11.1. LƯU VOUCHER MẪU CHO CÁC KHÁCH HÀNG (USER_VOUCHERS)
-- ----------------------------------------------------------------------------
SET IDENTITY_INSERT user_vouchers ON;
INSERT INTO user_vouchers (id, user_id, voucher_id, status, saved_at) VALUES
(1, 1, 1, 'AVAILABLE', '2026-01-01 08:00:00'),
(2, 1, 4, 'AVAILABLE', '2026-01-01 08:00:00'),
(3, 1, 6, 'AVAILABLE', '2026-01-01 08:00:00'),
(4, 1, 11, 'AVAILABLE', '2026-01-01 08:00:00'),
(5, 1, 19, 'AVAILABLE', '2026-01-01 08:00:00'),
(6, 22, 1, 'AVAILABLE', '2026-02-01 08:00:00'),
(7, 22, 4, 'AVAILABLE', '2026-02-01 08:00:00'),
(8, 22, 9, 'AVAILABLE', '2026-02-01 08:00:00'),
(9, 23, 2, 'AVAILABLE', '2026-02-05 09:00:00'),
(10, 23, 10, 'AVAILABLE', '2026-02-05 09:00:00'),
(11, 24, 3, 'AVAILABLE', '2026-02-10 10:00:00'),
(12, 24, 8, 'AVAILABLE', '2026-02-10 10:00:00'),
(13, 25, 5, 'AVAILABLE', '2026-02-15 11:00:00'),
(14, 25, 12, 'AVAILABLE', '2026-02-15 11:00:00'),
(15, 26, 1, 'AVAILABLE', '2026-03-01 12:00:00'),
(16, 26, 14, 'AVAILABLE', '2026-03-01 12:00:00'),
(17, 27, 2, 'AVAILABLE', '2026-03-05 13:00:00'),
(18, 27, 15, 'AVAILABLE', '2026-03-05 13:00:00'),
(19, 28, 3, 'AVAILABLE', '2026-03-10 14:00:00'),
(20, 28, 16, 'AVAILABLE', '2026-03-10 14:00:00');
SET IDENTITY_INSERT user_vouchers OFF;
DBCC CHECKIDENT ('user_vouchers', RESEED, 20);
GO


-- ----------------------------------------------------------------------------
-- 12. 10 TICKETS HỖ TRỢ TRÒ CHUYỆN THỰC TẾ NHƯ NGƯỜI THẬT
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'ticket_messages') AND type IN ('U')) DELETE FROM ticket_messages;
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'tickets') AND type IN ('U')) DELETE FROM tickets;
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'support_tickets') AND type IN ('U')) DELETE FROM support_tickets;
GO

SET IDENTITY_INSERT tickets ON;
INSERT INTO tickets (id, customer_name, customer_email, customer_phone, subject, category, message, assigned_admin, status, created_at) VALUES

(1, N'Nguyễn Tuấn Anh', 'tuananh.gamer@gmail.com', '0988112233', N'Tư vấn cấu hình PC Gaming 35 triệu chơi Black Myth: Wukong và GTA 6 ở độ phân giải 2K', 'BUILD_PC', N'Chào shop, mình có ngân sách khoảng 35 triệu, muốn build 1 case PC chuyên chơi game nặng như Black Myth Wukong, Cyberpunk và chuẩn bị cho GTA 6 ở màn hình 2K 165Hz. Nhờ shop tư vấn combo tối ưu nhất trong tầm giá giúp mình với ạ.', 'staff.hoanglong', 'IN_PROGRESS', '2026-08-20 09:30:00'),
(2, N'Trần Hoàng Nam', 'namth.dev@gmail.com', '0912345679', N'Nhờ hướng dẫn bật XMP và tối ưu bus RAM Corsair Dominator Titanium 6000MHz trên main ASUS Z890', 'TECHNICAL', N'Hôm qua mình vừa nhận máy bên shop gửi, kiểm tra Task Manager thấy RAM đang hiển thị 4800MHz trong khi kit mình mua là 6000MHz. Shop hướng dẫn mình cách bật lên với ạ.', 'staff.minhduc', 'RESOLVED', '2026-08-22 14:10:00'),
(3, N'Đặng Trúc Hà', 'khachhang038@gmail.com', '0761979308', N'Kiểm tra tiến độ vận chuyển đơn hàng #LXR2608230002 giao về Cầu Giấy Hà Nội', 'ORDER', N'Shop ơi mình vừa đặt mua đơn hàng LXR2608230002 hôm qua, không biết hôm nay đã đóng gói và bàn giao cho đơn vị vận chuyển chưa ạ? Khoảng mấy giờ mình nhận được máy?', 'staff.thutrang', 'IN_PROGRESS', '2026-08-24 08:45:00'),
(4, N'Lê Quốc Bảo', 'quocbao.tech@gmail.com', '0918765432', N'Card màn hình ASUS ROG RTX 4080 Super quạt không quay khi bật máy có phải lỗi không?', 'TECHNICAL', N'Shop cho mình hỏi xíu, mình đang dùng card RTX 4080 Super mới mua bên bạn, lúc bật máy lướt web xem Youtube thì thấy 3 quạt của card hoàn toàn không quay. Lúc chơi game thì quạt mới quay. Như vậy có phải card bị lỗi cảm biến nhiệt không shop?', 'staff.quanghuy', 'RESOLVED', '2026-08-25 11:20:00'),
(5, N'Phan Trường Giang', 'giang.ai@gmail.com', '0987654321', N'Tư vấn cấu hình máy trạm chạy mô hình DeepSeek LLM và render 3D Blender ngân sách 70 triệu', 'BUILD_PC', N'Xin chào Luxury PC, mình là kỹ sư AI đang cần build 1 bộ máy workstation chuyên dụng để chạy fine-tune các model LLM local (DeepSeek, Llama 3) và render mô hình 3D Blender. Ngân sách tầm 70-80 triệu, ưu tiên VRAM GPU lớn từ 24GB trở lên và RAM hệ thống tối thiểu 64GB. Nhờ shop lên cấu hình giúp.', 'staff.giahuynh', 'OPEN', '2026-08-27 15:30:00'),
(6, N'Võ Tấn Phát', 'tanphat.danang@gmail.com', '0982345678', N'Vỏ case Corsair 3500X có lắp vừa tản nhiệt nước AIO 360mm ở mặt nóc không?', 'TECHNICAL', N'Shop cho mình hỏi case Corsair 3500X TG kính cường lực mình muốn lắp tản nước AIO 360mm ở nóc case và cắm card RTX 4080 dài 34cm thì có bị cấn không shop?', 'staff.vietanh', 'RESOLVED', '2026-08-28 10:15:00'),
(7, N'Ngô Bích Ngọc', 'bichngoc.arc@gmail.com', '0965432109', N'Yêu cầu báo giá 10 bộ PC văn phòng kết hợp thiết kế đồ họa 2D Photoshop cho công ty kiến trúc', 'PRICE', N'Kính gửi bộ phận kinh doanh Luxury PC, công ty kiến trúc bên mình đang cần mua mới 10 dàn máy tính cho nhân viên thiết kế 2D AutoCad, Photoshop và Sketchup. Ngân sách khoảng 18-20 triệu/bộ (đã bao gồm màn hình 27 inch IPS). Nhờ công ty gửi bảng báo giá chính thức có hóa đơn VAT và chính sách bảo hành doanh nghiệp qua email bichngoc.arc@gmail.com giúp mình nhé.', 'staff.thuytien', 'OPEN', '2026-08-29 09:00:00'),
(8, N'Dương Thị Lam', 'khachhang050@gmail.com', '0347084450', N'Hướng dẫn thủ tục trả góp 0% qua thẻ tín dụng và SePay chuyển khoản QR', 'ORDER', N'Mình muốn mua bộ PC 25 triệu và thanh toán trả góp 0% qua thẻ tín dụng Visa Techcombank kỳ hạn 12 tháng thì thủ tục như thế nào vậy shop?', 'staff.phuongthao', 'RESOLVED', '2026-08-30 14:00:00'),
(9, N'Đỗ Minh Đức', 'minhduc.tech@gmail.com', '0912345678', N'Xin link tải phần mềm chỉnh LED RGB cho linh kiện ROG Strix và Corsair iCUE', 'TECHNICAL', N'Shop cho mình xin link chuẩn để tải phần mềm đồng bộ đèn LED cho main ASUS và RAM Corsair với ạ.', 'staff.tuankiet', 'CLOSED', '2026-08-31 16:20:00'),
(10, N'Huỳnh Đức Khoa', 'khachhang034@gmail.com', '0777610058', N'Khen ngợi bạn nhân viên kỹ thuật hỗ trợ lắp máy tại nhà rất nhiệt tình và chu đáo', 'GENERAL', N'Mình gửi ticket này để gửi lời cảm ơn đến Luxury PC và đặc biệt là bạn kỹ thuật viên Long sáng nay đã mang dàn PC đến tận nhà mình lắp đặt. Bạn làm việc rất cẩn thận, đi dây siêu đẹp và còn nhiệt tình hướng dẫn mình cách bảo quản vệ sinh máy. Dịch vụ bên bạn rất chuyên nghiệp 10/10 điểm!', 'staff.hoanglong', 'CLOSED', '2026-09-01 11:00:00');
SET IDENTITY_INSERT tickets OFF;
DBCC CHECKIDENT ('tickets', RESEED, 10);
GO

SET IDENTITY_INSERT support_tickets ON;
INSERT INTO support_tickets (id, user_id, customer_name, customer_email, customer_phone, subject, category, message, admin_reply, assigned_admin, status, created_at, updated_at) VALUES

(1, 22, N'Nguyễn Tuấn Anh', 'tuananh.gamer@gmail.com', '0988112233', N'Tư vấn cấu hình PC Gaming 35 triệu chơi Black Myth: Wukong và GTA 6 ở độ phân giải 2K', 'BUILD_PC', N'Chào shop, mình có ngân sách khoảng 35 triệu, muốn build 1 case PC chuyên chơi game nặng như Black Myth Wukong, Cyberpunk và chuẩn bị cho GTA 6 ở màn hình 2K 165Hz. Nhờ shop tư vấn combo tối ưu nhất trong tầm giá giúp mình với ạ.', N'Chào anh Tuấn Anh! Với ngân sách 35 triệu để chiến mượt 2K Ultra Settings, Luxury PC xin tư vấn anh cấu hình tối ưu nhất: CPU Intel Core i5-14600KF (14 nhân 20 luồng) + Card đồ họa RTX 4070 Super 12GB GDDR6X + 32GB RAM DDR5 Corsair 6000MHz + Nguồn 750W 80 Plus Gold + Tản nhiệt nước AIO 360mm. Cấu hình này test thực tế Wukong 2K đạt 90-110 FPS rất mượt mà anh nhé!', 'staff.hoanglong', 'IN_PROGRESS', '2026-08-20 09:30:00', '2026-08-20 09:30:00'),
(2, 23, N'Trần Hoàng Nam', 'namth.dev@gmail.com', '0912345679', N'Nhờ hướng dẫn bật XMP và tối ưu bus RAM Corsair Dominator Titanium 6000MHz trên main ASUS Z890', 'TECHNICAL', N'Hôm qua mình vừa nhận máy bên shop gửi, kiểm tra Task Manager thấy RAM đang hiển thị 4800MHz trong khi kit mình mua là 6000MHz. Shop hướng dẫn mình cách bật lên với ạ.', N'Dạ chào anh Nam, mặc định chuẩn DDR5 khi mới cắm sẽ nhận bus gốc 4800MHz để đảm bảo tương thích boot máy. Anh làm theo các bước sau giúp em nhé:
1. Khởi động lại máy, bấm liên tục phím DEL để vào BIOS.
2. Ở trang EzMode góc trái, anh tìm mục ''X.M.P'' chuyển từ Disabled sang ''XMP I'' hoặc ''Profile 1''.
3. Bấm phím F10 chọn ''Save & Exit'' là xong ạ!', 'staff.minhduc', 'RESOLVED', '2026-08-22 14:10:00', '2026-08-22 14:10:00'),
(3, 59, N'Đặng Trúc Hà', 'khachhang038@gmail.com', '0761979308', N'Kiểm tra tiến độ vận chuyển đơn hàng #LXR2608230002 giao về Cầu Giấy Hà Nội', 'ORDER', N'Shop ơi mình vừa đặt mua đơn hàng LXR2608230002 hôm qua, không biết hôm nay đã đóng gói và bàn giao cho đơn vị vận chuyển chưa ạ? Khoảng mấy giờ mình nhận được máy?', N'Chào chị Trúc Hà! Em kiểm tra hệ thống thấy đơn hàng của chị đã được đội ngũ kỹ thuật lắp ráp hoàn tất và bàn giao cho shipper chuyên biệt của Luxury PC lúc 8h30 sáng nay. Dự kiến khoảng 14h - 15h chiều nay shipper sẽ liên hệ trước khi giao tới địa chỉ số 311 Võ Văn Kiệt của chị ạ.', 'staff.thutrang', 'IN_PROGRESS', '2026-08-24 08:45:00', '2026-08-24 08:45:00'),
(4, 24, N'Lê Quốc Bảo', 'quocbao.tech@gmail.com', '0918765432', N'Card màn hình ASUS ROG RTX 4080 Super quạt không quay khi bật máy có phải lỗi không?', 'TECHNICAL', N'Shop cho mình hỏi xíu, mình đang dùng card RTX 4080 Super mới mua bên bạn, lúc bật máy lướt web xem Youtube thì thấy 3 quạt của card hoàn toàn không quay. Lúc chơi game thì quạt mới quay. Như vậy có phải card bị lỗi cảm biến nhiệt không shop?', N'Dạ chào anh Bảo, anh hoàn toàn yên tâm nhé! Các dòng card cao cấp hiện nay của ASUS đều có công nghệ ''0dB Fan Tech''. Khi nhiệt độ GPU dưới 50-55 độ C (khi lướt web, làm việc nhẹ), quạt sẽ tự động dừng hoàn toàn để giữ im lặng tuyệt đối và tăng tuổi thọ trục bi. Khi anh vào game nặng nhiệt độ tăng lên quạt sẽ tự động quay làm mát ạ!', 'staff.quanghuy', 'RESOLVED', '2026-08-25 11:20:00', '2026-08-25 11:20:00'),
(5, 25, N'Phan Trường Giang', 'giang.ai@gmail.com', '0987654321', N'Tư vấn cấu hình máy trạm chạy mô hình DeepSeek LLM và render 3D Blender ngân sách 70 triệu', 'BUILD_PC', N'Xin chào Luxury PC, mình là kỹ sư AI đang cần build 1 bộ máy workstation chuyên dụng để chạy fine-tune các model LLM local (DeepSeek, Llama 3) và render mô hình 3D Blender. Ngân sách tầm 70-80 triệu, ưu tiên VRAM GPU lớn từ 24GB trở lên và RAM hệ thống tối thiểu 64GB. Nhờ shop lên cấu hình giúp.', N'Chào anh Giang! Đối với nhu cầu train/inference LLM và Render 3D nặng, cấu hình đề xuất chuẩn trạm cho anh gồm:
- CPU: Intel Core Ultra 9 285K (24 nhân 24 luồng, đơn nhân cực mạnh)
- Mainboard: ASUS ROG STRIX Z890-F GAMING WIFI
- RAM: 64GB (2x32GB) DDR5 Corsair Dominator Titanium 6400MHz
- VGA: MSI GeForce RTX 4090 24GB GDDR6X Gaming X Trio
- SSD: 2TB Samsung 990 PRO Gen4x4 (Đọc 7450MB/s nạp tensor siêu nhanh)
- Nguồn: Corsair RM1000e 1000W 80 Plus Gold ATX 3.0
- Tản nhiệt nước: Corsair Nautilus 360 RS ARGB.
Tổng cấu hình khoảng 78.5 triệu, bên em có sẵn hàng để lắp ráp ngay cho anh ạ!', 'staff.giahuynh', 'OPEN', '2026-08-27 15:30:00', '2026-08-27 15:30:00'),
(6, 26, N'Võ Tấn Phát', 'tanphat.danang@gmail.com', '0982345678', N'Vỏ case Corsair 3500X có lắp vừa tản nhiệt nước AIO 360mm ở mặt nóc không?', 'TECHNICAL', N'Shop cho mình hỏi case Corsair 3500X TG kính cường lực mình muốn lắp tản nước AIO 360mm ở nóc case và cắm card RTX 4080 dài 34cm thì có bị cấn không shop?', N'Dạ chào anh Phát! Case Corsair 3500X được thiết kế khoang nóc rất thoáng, hỗ trợ hoàn hảo tản nước Rad 360mm dày tới 65mm (cả quạt) mà không hề cấn vào tản nhôm VRM mainboard. Chiều dài card VGA case hỗ trợ lên tới 410mm nên card RTX 4080 34cm lắp vào cực kỳ rộng rãi và đẹp mắt anh nhé!', 'staff.vietanh', 'RESOLVED', '2026-08-28 10:15:00', '2026-08-28 10:15:00'),
(7, 27, N'Ngô Bích Ngọc', 'bichngoc.arc@gmail.com', '0965432109', N'Yêu cầu báo giá 10 bộ PC văn phòng kết hợp thiết kế đồ họa 2D Photoshop cho công ty kiến trúc', 'PRICE', N'Kính gửi bộ phận kinh doanh Luxury PC, công ty kiến trúc bên mình đang cần mua mới 10 dàn máy tính cho nhân viên thiết kế 2D AutoCad, Photoshop và Sketchup. Ngân sách khoảng 18-20 triệu/bộ (đã bao gồm màn hình 27 inch IPS). Nhờ công ty gửi bảng báo giá chính thức có hóa đơn VAT và chính sách bảo hành doanh nghiệp qua email bichngoc.arc@gmail.com giúp mình nhé.', N'Kính chào chị Bích Ngọc! Em đã nhận được yêu cầu của công ty mình. Luxury PC có chính sách chiết khấu 8% cho đơn hàng doanh nghiệp từ 10 bộ, hỗ trợ xuất hóa đơn VAT điện tử đầy đủ và gói bảo hành tận nơi 24/7 trong 24 tháng. Em sẽ hoàn thiện file báo giá chi tiết và gửi vào email của chị trong vòng 30 phút tới ạ!', 'staff.thuytien', 'OPEN', '2026-08-29 09:00:00', '2026-08-29 09:00:00'),
(8, 71, N'Dương Thị Lam', 'khachhang050@gmail.com', '0347084450', N'Hướng dẫn thủ tục trả góp 0% qua thẻ tín dụng và SePay chuyển khoản QR', 'ORDER', N'Mình muốn mua bộ PC 25 triệu và thanh toán trả góp 0% qua thẻ tín dụng Visa Techcombank kỳ hạn 12 tháng thì thủ tục như thế nào vậy shop?', N'Dạ chào chị Lam! Thủ tục trả góp qua thẻ tín dụng tại Luxury PC hoàn toàn online và duyệt tự động 100% không cần giấy tờ ạ. Tại bước thanh toán (Checkout), chị chọn phương thức ''Trả góp qua thẻ tín dụng'', chọn ngân hàng Techcombank và kỳ hạn 12 tháng, sau đó nhập thông tin thẻ là hoàn tất đơn hàng trong 1 phút thôi ạ!', 'staff.phuongthao', 'RESOLVED', '2026-08-30 14:00:00', '2026-08-30 14:00:00'),
(9, 28, N'Đỗ Minh Đức', 'minhduc.tech@gmail.com', '0912345678', N'Xin link tải phần mềm chỉnh LED RGB cho linh kiện ROG Strix và Corsair iCUE', 'TECHNICAL', N'Shop cho mình xin link chuẩn để tải phần mềm đồng bộ đèn LED cho main ASUS và RAM Corsair với ạ.', N'Dạ chào anh Đức! Để chỉnh LED cho Mainboard/VGA ASUS anh tải phần mềm ''ASUS Armoury Crate'' tại trang chủ asus.com. Còn đối với RAM/Fan Corsair anh tải phần mềm ''Corsair iCUE v5''. Hai phần mềm này có thể đồng bộ với nhau qua plugin Corsair ASUS Sync anh nhé!', 'staff.tuankiet', 'CLOSED', '2026-08-31 16:20:00', '2026-08-31 16:20:00'),
(10, 55, N'Huỳnh Đức Khoa', 'khachhang034@gmail.com', '0777610058', N'Khen ngợi bạn nhân viên kỹ thuật hỗ trợ lắp máy tại nhà rất nhiệt tình và chu đáo', 'GENERAL', N'Mình gửi ticket này để gửi lời cảm ơn đến Luxury PC và đặc biệt là bạn kỹ thuật viên Long sáng nay đã mang dàn PC đến tận nhà mình lắp đặt. Bạn làm việc rất cẩn thận, đi dây siêu đẹp và còn nhiệt tình hướng dẫn mình cách bảo quản vệ sinh máy. Dịch vụ bên bạn rất chuyên nghiệp 10/10 điểm!', N'Dạ em Long đây ạ! Em thay mặt toàn thể đội ngũ Luxury PC chân thành cảm ơn anh Khoa đã tin tưởng và dành những lời khen ngợi quý báu cho em. Chúc anh có những phút giây giải trí và làm việc thật tuyệt vời bên cỗ máy mới. Luxury PC xin gửi tặng anh 1 Voucher tri ân giảm 500.000đ cho lần mua sắm tiếp theo ạ!', 'staff.hoanglong', 'CLOSED', '2026-09-01 11:00:00', '2026-09-01 11:00:00');
SET IDENTITY_INSERT support_tickets OFF;
DBCC CHECKIDENT ('support_tickets', RESEED, 10);
GO

SET IDENTITY_INSERT ticket_messages ON;
INSERT INTO ticket_messages (id, ticket_id, sender, sender_name, message, created_at) VALUES

(1, 1, 'CUSTOMER', N'Nguyễn Tuấn Anh', N'Chào shop, mình có ngân sách khoảng 35 triệu, muốn build 1 case PC chuyên chơi game nặng như Black Myth Wukong, Cyberpunk và chuẩn bị cho GTA 6 ở màn hình 2K 165Hz. Nhờ shop tư vấn combo tối ưu nhất trong tầm giá giúp mình với ạ.', '2026-08-20 09:30:00'),
(2, 1, 'ADMIN', N'Lê Hoàng Long (Kỹ thuật viên)', N'Chào anh Tuấn Anh! Với ngân sách 35 triệu để chiến mượt 2K Ultra Settings, Luxury PC xin tư vấn anh cấu hình tối ưu nhất: CPU Intel Core i5-14600KF (14 nhân 20 luồng) + Card đồ họa RTX 4070 Super 12GB GDDR6X + 32GB RAM DDR5 Corsair 6000MHz + Nguồn 750W 80 Plus Gold + Tản nhiệt nước AIO 360mm. Cấu hình này test thực tế Wukong 2K đạt 90-110 FPS rất mượt mà anh nhé!', '2026-08-20 10:05:00'),
(3, 1, 'CUSTOMER', N'Nguyễn Tuấn Anh', N'Cấu hình này nhìn ưng quá shop ơi! Cho mình hỏi nguồn 750W có dư dả để sau này mình nâng cấp card lớn hơn không ạ? Và bên shop có hỗ trợ cài sẵn Windows với game test máy trước khi giao không?', '2026-08-20 10:20:00'),
(4, 1, 'ADMIN', N'Lê Hoàng Long (Kỹ thuật viên)', N'Dạ nguồn 750W chuẩn Gold gánh i5-14600KF + RTX 4070 Super chỉ ăn khoảng 450W nên dư dả tải rất mát anh nhé. Khi anh đặt máy, Luxury PC sẽ hỗ trợ lắp đặt, đi dây giấu gọn gàng, cài sẵn Windows 11 Pro bản quyền, tối ưu BIOS XMP và stress test 2 tiếng trước khi giao tận nhà ạ!', '2026-08-20 10:35:00'),
(5, 2, 'CUSTOMER', N'Trần Hoàng Nam', N'Hôm qua mình vừa nhận máy bên shop gửi, kiểm tra Task Manager thấy RAM đang hiển thị 4800MHz trong khi kit mình mua là 6000MHz. Shop hướng dẫn mình cách bật lên với ạ.', '2026-08-22 14:10:00'),
(6, 2, 'ADMIN', N'Đỗ Minh Đức (Kỹ thuật)', N'Dạ chào anh Nam, mặc định chuẩn DDR5 khi mới cắm sẽ nhận bus gốc 4800MHz để đảm bảo tương thích boot máy. Anh làm theo các bước sau giúp em nhé:
1. Khởi động lại máy, bấm liên tục phím DEL để vào BIOS.
2. Ở trang EzMode góc trái, anh tìm mục ''X.M.P'' chuyển từ Disabled sang ''XMP I'' hoặc ''Profile 1''.
3. Bấm phím F10 chọn ''Save & Exit'' là xong ạ!', '2026-08-22 14:25:00'),
(7, 2, 'CUSTOMER', N'Trần Hoàng Nam', N'Mình vừa làm theo và đã lên đúng 6000MHz rồi, máy khởi động nhanh và mượt hơn hẳn. Cảm ơn kỹ thuật viên đã hỗ trợ nhanh chóng nhé!', '2026-08-22 14:40:00'),
(8, 2, 'ADMIN', N'Đỗ Minh Đức (Kỹ thuật)', N'Dạ không có gì ạ! Chúc anh có những trải nghiệm tuyệt vời cùng bộ máy mới. Cần hỗ trợ thêm anh cứ nhắn lại ticket này nhé!', '2026-08-22 14:45:00'),
(9, 3, 'CUSTOMER', N'Đặng Trúc Hà', N'Shop ơi mình vừa đặt mua đơn hàng LXR2608230002 hôm qua, không biết hôm nay đã đóng gói và bàn giao cho đơn vị vận chuyển chưa ạ? Khoảng mấy giờ mình nhận được máy?', '2026-08-24 08:45:00'),
(10, 3, 'ADMIN', N'Trần Thị Thu Trang (CSKH)', N'Chào chị Trúc Hà! Em kiểm tra hệ thống thấy đơn hàng của chị đã được đội ngũ kỹ thuật lắp ráp hoàn tất và bàn giao cho shipper chuyên biệt của Luxury PC lúc 8h30 sáng nay. Dự kiến khoảng 14h - 15h chiều nay shipper sẽ liên hệ trước khi giao tới địa chỉ số 311 Võ Văn Kiệt của chị ạ.', '2026-08-24 09:05:00'),
(11, 3, 'CUSTOMER', N'Đặng Trúc Hà', N'Okie shop, chiều nay mình có nhà. Nhờ shipper gọi trước cho mình 15 phút nhé.', '2026-08-24 09:12:00'),
(12, 4, 'CUSTOMER', N'Lê Quốc Bảo', N'Shop cho mình hỏi xíu, mình đang dùng card RTX 4080 Super mới mua bên bạn, lúc bật máy lướt web xem Youtube thì thấy 3 quạt của card hoàn toàn không quay. Lúc chơi game thì quạt mới quay. Như vậy có phải card bị lỗi cảm biến nhiệt không shop?', '2026-08-25 11:20:00'),
(13, 4, 'ADMIN', N'Nguyễn Quang Huy (Kỹ thuật)', N'Dạ chào anh Bảo, anh hoàn toàn yên tâm nhé! Các dòng card cao cấp hiện nay của ASUS đều có công nghệ ''0dB Fan Tech''. Khi nhiệt độ GPU dưới 50-55 độ C (khi lướt web, làm việc nhẹ), quạt sẽ tự động dừng hoàn toàn để giữ im lặng tuyệt đối và tăng tuổi thọ trục bi. Khi anh vào game nặng nhiệt độ tăng lên quạt sẽ tự động quay làm mát ạ!', '2026-08-25 11:35:00'),
(14, 4, 'CUSTOMER', N'Lê Quốc Bảo', N'À ra là tính năng thông minh vậy à, mình cứ sợ bị kẹt quạt. Cảm ơn shop đã giải thích chi tiết!', '2026-08-25 11:42:00'),
(15, 5, 'CUSTOMER', N'Phan Trường Giang', N'Xin chào Luxury PC, mình là kỹ sư AI đang cần build 1 bộ máy workstation chuyên dụng để chạy fine-tune các model LLM local (DeepSeek, Llama 3) và render mô hình 3D Blender. Ngân sách tầm 70-80 triệu, ưu tiên VRAM GPU lớn từ 24GB trở lên và RAM hệ thống tối thiểu 64GB. Nhờ shop lên cấu hình giúp.', '2026-08-27 15:30:00'),
(16, 5, 'ADMIN', N'Trương Gia Huỳnh (Workstation Specialist)', N'Chào anh Giang! Đối với nhu cầu train/inference LLM và Render 3D nặng, cấu hình đề xuất chuẩn trạm cho anh gồm:
- CPU: Intel Core Ultra 9 285K (24 nhân 24 luồng, đơn nhân cực mạnh)
- Mainboard: ASUS ROG STRIX Z890-F GAMING WIFI
- RAM: 64GB (2x32GB) DDR5 Corsair Dominator Titanium 6400MHz
- VGA: MSI GeForce RTX 4090 24GB GDDR6X Gaming X Trio
- SSD: 2TB Samsung 990 PRO Gen4x4 (Đọc 7450MB/s nạp tensor siêu nhanh)
- Nguồn: Corsair RM1000e 1000W 80 Plus Gold ATX 3.0
- Tản nhiệt nước: Corsair Nautilus 360 RS ARGB.
Tổng cấu hình khoảng 78.5 triệu, bên em có sẵn hàng để lắp ráp ngay cho anh ạ!', '2026-08-27 16:00:00'),
(17, 6, 'CUSTOMER', N'Võ Tấn Phát', N'Shop cho mình hỏi case Corsair 3500X TG kính cường lực mình muốn lắp tản nước AIO 360mm ở nóc case và cắm card RTX 4080 dài 34cm thì có bị cấn không shop?', '2026-08-28 10:15:00'),
(18, 6, 'ADMIN', N'Hoàng Việt Anh (Kỹ thuật)', N'Dạ chào anh Phát! Case Corsair 3500X được thiết kế khoang nóc rất thoáng, hỗ trợ hoàn hảo tản nước Rad 360mm dày tới 65mm (cả quạt) mà không hề cấn vào tản nhôm VRM mainboard. Chiều dài card VGA case hỗ trợ lên tới 410mm nên card RTX 4080 34cm lắp vào cực kỳ rộng rãi và đẹp mắt anh nhé!', '2026-08-28 10:30:00'),
(19, 7, 'CUSTOMER', N'Ngô Bích Ngọc', N'Kính gửi bộ phận kinh doanh Luxury PC, công ty kiến trúc bên mình đang cần mua mới 10 dàn máy tính cho nhân viên thiết kế 2D AutoCad, Photoshop và Sketchup. Ngân sách khoảng 18-20 triệu/bộ (đã bao gồm màn hình 27 inch IPS). Nhờ công ty gửi bảng báo giá chính thức có hóa đơn VAT và chính sách bảo hành doanh nghiệp qua email bichngoc.arc@gmail.com giúp mình nhé.', '2026-08-29 09:00:00'),
(20, 7, 'ADMIN', N'Vũ Thủy Tiên (Kinh doanh Doanh nghiệp)', N'Kính chào chị Bích Ngọc! Em đã nhận được yêu cầu của công ty mình. Luxury PC có chính sách chiết khấu 8% cho đơn hàng doanh nghiệp từ 10 bộ, hỗ trợ xuất hóa đơn VAT điện tử đầy đủ và gói bảo hành tận nơi 24/7 trong 24 tháng. Em sẽ hoàn thiện file báo giá chi tiết và gửi vào email của chị trong vòng 30 phút tới ạ!', '2026-08-29 09:25:00'),
(21, 8, 'CUSTOMER', N'Dương Thị Lam', N'Mình muốn mua bộ PC 25 triệu và thanh toán trả góp 0% qua thẻ tín dụng Visa Techcombank kỳ hạn 12 tháng thì thủ tục như thế nào vậy shop?', '2026-08-30 14:00:00'),
(22, 8, 'ADMIN', N'Bùi Phương Thảo (Tư vấn viên)', N'Dạ chào chị Lam! Thủ tục trả góp qua thẻ tín dụng tại Luxury PC hoàn toàn online và duyệt tự động 100% không cần giấy tờ ạ. Tại bước thanh toán (Checkout), chị chọn phương thức ''Trả góp qua thẻ tín dụng'', chọn ngân hàng Techcombank và kỳ hạn 12 tháng, sau đó nhập thông tin thẻ là hoàn tất đơn hàng trong 1 phút thôi ạ!', '2026-08-30 14:15:00'),
(23, 8, 'CUSTOMER', N'Dương Thị Lam', N'Dạ tiện lợi quá, mình vừa hoàn tất đơn hàng rồi, shop kiểm tra đơn giúp mình nhé!', '2026-08-30 14:28:00'),
(24, 9, 'CUSTOMER', N'Đỗ Minh Đức', N'Shop cho mình xin link chuẩn để tải phần mềm đồng bộ đèn LED cho main ASUS và RAM Corsair với ạ.', '2026-08-31 16:20:00'),
(25, 9, 'ADMIN', N'Đặng Tuấn Kiệt (Kỹ thuật)', N'Dạ chào anh Đức! Để chỉnh LED cho Mainboard/VGA ASUS anh tải phần mềm ''ASUS Armoury Crate'' tại trang chủ asus.com. Còn đối với RAM/Fan Corsair anh tải phần mềm ''Corsair iCUE v5''. Hai phần mềm này có thể đồng bộ với nhau qua plugin Corsair ASUS Sync anh nhé!', '2026-08-31 16:35:00'),
(26, 9, 'CUSTOMER', N'Đỗ Minh Đức', N'Cảm ơn kỹ thuật viên đã hướng dẫn tận tình, mình chỉnh xong đồng bộ màu tím cyberpunk đẹp lắm rồi!', '2026-08-31 16:50:00'),
(27, 10, 'CUSTOMER', N'Huỳnh Đức Khoa', N'Mình gửi ticket này để gửi lời cảm ơn đến Luxury PC và đặc biệt là bạn kỹ thuật viên Long sáng nay đã mang dàn PC đến tận nhà mình lắp đặt. Bạn làm việc rất cẩn thận, đi dây siêu đẹp và còn nhiệt tình hướng dẫn mình cách bảo quản vệ sinh máy. Dịch vụ bên bạn rất chuyên nghiệp 10/10 điểm!', '2026-09-01 11:00:00'),
(28, 10, 'ADMIN', N'Lê Hoàng Long (Kỹ thuật viên)', N'Dạ em Long đây ạ! Em thay mặt toàn thể đội ngũ Luxury PC chân thành cảm ơn anh Khoa đã tin tưởng và dành những lời khen ngợi quý báu cho em. Chúc anh có những phút giây giải trí và làm việc thật tuyệt vời bên cỗ máy mới. Luxury PC xin gửi tặng anh 1 Voucher tri ân giảm 500.000đ cho lần mua sắm tiếp theo ạ!', '2026-09-01 11:20:00');
SET IDENTITY_INSERT ticket_messages OFF;
DBCC CHECKIDENT ('ticket_messages', RESEED, 28);
GO