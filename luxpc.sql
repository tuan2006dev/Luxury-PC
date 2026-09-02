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
(3, 'Intel Core i7-14700Kkk', 10800000, N'TDP: 125W | 20 Cores, Hybrid Architecture', '/images/image/001_Intel_Core_i7-14700Kkk_main.jpg', 1, 0, NULL, N'Intel'),
(4, 'AMD Ryzen 7 7800X3D', 11500000, N'TDP: 120W | Best gaming CPU, 8 Cores, 3D V-Cache', '/images/image/002_AMD_Ryzen_7_7800X3D_main.jpg', 1, 27, '2026-04-06 13:46:29.076393', N'AMD'),
(5, 'Intel Core i5-13600K', 8200000, N'TDP: 125W | 14 Cores, Mid-range gaming', '/images/image/003_Intel_Core_i5-13600K_main.jpg', 1, 54, '2026-04-06 13:46:29.076393', N'Intel'),
(6, 'AMD Ryzen 5 7600X', 5800000, N'TDP: 65W | 6 Cores, Zen 4 Architecture, AM5', '/images/image/004_AMD_Ryzen_5_7600X_main.jpeg', 1, 59, '2026-04-06 13:46:29.076393', N'AMD'),
(7, 'Intel Core i9-13900KS', 18500000, N'TDP: 125W | Special Edition, 6.0GHz', '/images/image/005_Intel_Core_i9-13900KS_main.jpg', 1, 0, '2026-04-06 13:46:29.076393', N'Intel'),
(8, 'AMD Ryzen 9 7900X', 10500000, N'TDP: 170W | 12 Cores, 5.6GHz Boost', '/images/image/006_AMD_Ryzen_9_7900X_main.jpg', 1, 18, '2026-04-06 13:46:29.076393', N'AMD'),
(9, 'Intel Core i7-13700F', 8900000, N'TDP: 65W | 16 Cores, No Integrated Graphics', N'https://microless.com/cdn/products/08f5cf4e0f9b43cecfee68f4a554f23c-hi.jpg', 1, 45, '2026-04-06 13:46:29.076393', N'Intel'),
(10, 'AMD Ryzen 7 5800X3D', 8500000, N'TDP: 120W | Legendary AM4 gaming CPU', '/images/image/008_AMD_Ryzen_7_5800X3D_main.jpg', 1, 25, '2026-04-06 13:46:29.076393', N'AMD'),
(11, 'Intel Core i5-12400F', 3500000, N'TDP: 65W | Budget King, 6 Cores', '/images/image/009_Intel_Core_i5-12400F_main.jpg', 1, 96, '2026-04-06 13:46:29.076393', N'Intel'),
(12, 'AMD Ryzen 5 5600G', 3200000, N'TDP: 65W | Integrated Vega Graphics', N'https://networkitstore.in/wp-content/uploads/2024/01/amd-ryzen-5600g-600x600.webp', 1, 71, '2026-04-06 13:46:29.076393', N'AMD'),
(13, 'Intel Core i3-14100', 3800000, N'TDP: 65W | Entry level 14th Gen', '/images/image/011_Intel_Core_i3-14100_main.webp', 1, 37, '2026-04-06 13:46:29.076393', N'Intel'),
(14, 'AMD Ryzen 3 4100', 1800000, N'TDP: 65W | Budget 4 Cores, AM4', '/images/image/012_AMD_Ryzen_3_4100_main.jpg', 1, 118, '2026-04-06 13:46:29.076393', N'AMD'),
(15, 'Intel Core i9-12900K', 9500000, N'TDP: 125W | 16 Cores, Previous Flagship', '/images/image/013_Intel_Core_i9-12900K_main.jpg', 1, 13, '2026-04-06 13:46:29.076393', N'Intel'),
(16, N'Vỏ máy tính Xigmatek QUANTUM 4AF', 800000, N'TDP: 0W', N'http://cdn.hstatic.net/products/200000722513/gearvn-vo-may-tinh-xigmatek-quantum-4af-1_c9db476a42ef48fba6d84a9703a94945_grande.jpg', 12, 100, '2026-06-27 12:22:45.418', N'Xigmatek'),
(17, 'Intel Core i5-14400F', 5600000, N'TDP: 65W | 10 Cores, Efficient Gaming', N'https://microless.com/cdn/products/30c01bcc173314e1a756151858871162-hi.jpg', 1, 64, '2026-04-06 13:46:29.076393', N'Intel'),
(18, 'AMD Ryzen 5 8600G', 6200000, N'TDP: 65W | AI Engine, Radeon 760M', '/images/image/016_AMD_Ryzen_5_8600G_main.jpg', 1, 34, '2026-04-06 13:46:29.076393', N'AMD'),
(19, 'Intel Core i7-12700K', 7200000, N'TDP: 125W | 12 Cores, LGA 1700', '/images/image/017_Intel_Core_i7-12700K_main.jpg', 1, 34, '2026-04-06 13:46:29.076393', N'Intel'),
(20, 'AMD Ryzen 7 7700', 7800000, N'TDP: 65W | 8 Cores, Low Power 65W', N'https://www.ryans.com/storage/products/main/amd-ryzen-7-7700-38ghz-53ghz-8-core-40mb-cache-11696328242.webp', 1, 28, '2026-04-06 13:46:29.076393', N'AMD'),
(21, 'Intel Core i5-11400F', 2800000, N'TDP: 65W | Old Gen Budget King', '/images/image/019_Intel_Core_i5-11400F_main.jpg', 1, 50, '2026-04-06 13:46:29.076393', N'Intel'),
(22, 'AMD Ryzen 5 4500', 1950000, N'TDP: 65W | Super Budget 6 Cores', '/images/image/020_AMD_Ryzen_5_4500_main.jpg', 1, 92, '2026-04-06 13:46:29.076393', N'AMD'),
(23, 'Intel Core i9-11900K', 6500000, N'TDP: 125W | Legacy Flagship LGA 1200', '/images/image/021_Intel_Core_i9-11900K_main.jpg', 1, 9, '2026-04-06 13:46:29.076393', N'Intel'),
(24, 'AMD Ryzen 5 3600', 2100000, N'TDP: 65W | Popular AM4 CPU', N'https://www.techspot.com/images/products/2019/processors/amd/org/2019-07-25-product-6.jpg', 1, 150, '2026-04-06 13:46:29.076393', N'AMD'),
(25, 'Intel Core i5-10400F', 2200000, N'TDP: 65W | Stable and Cheap', '/images/image/023_Intel_Core_i5-10400F_main.jpg', 1, 110, '2026-04-06 13:46:29.076393', N'Intel'),
(26, 'AMD Ryzen 9 3900X', 7500000, N'TDP: 105W | 12 Cores, Workstation', N'https://res.cloudinary.com/jawa/image/upload/f_auto,ar_1:1,c_fill,w_3840,q_auto/production/listings/gdo47zchozcdcelniqzd', 1, 8, '2026-04-06 13:46:29.076393', N'AMD'),
(27, 'Intel Pentium G7400', 1900000, N'TDP: 65W | Office work, 2 Cores', '/images/image/025_Intel_Pentium_G7400_main.jpg', 1, 200, '2026-04-06 13:46:29.076393', N'Intel'),
(28, 'AMD Athlon 3000G', 1200000, N'TDP: 65W | Ultra Budget Graphics', '/images/image/026_AMD_Athlon_3000G_main.jpg', 1, 180, '2026-04-06 13:46:29.076393', N'AMD'),
(29, 'Intel Core i7-10700K', 4800000, N'TDP: 65W | High Clock Legacy', '/images/image/027_Intel_Core_i7-10700K_main.jpg', 1, 20, '2026-04-06 13:46:29.076393', N'Intel'),
(30, 'AMD Ryzen 7 8700G', 9200000, N'TDP: 65W | Powerful APU, Radeon 780M', '/images/image/028_AMD_Ryzen_7_8700G_main.jpg', 1, 33, '2026-04-06 13:46:29.076393', N'AMD'),
(31, 'NVIDIA RTX 4090 24GB', 55000000, N'TDP: 450W | Ultimate Gaming GPU', '/images/image/029_NVIDIA_RTX_4090_24GB_main.jpg', 2, 10, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(32, 'RTX 4080 Super', 32000000, N'TDP: 320W | High-end 4K Gaming', '/images/image/030_RTX_4080_Super_main.webp', 2, 15, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(33, 'RTX 4070 Ti Super', 24500000, N'TDP: 285W | Perfect for 2K Gaming', '/images/image/031_RTX_4070_Ti_Super_main.jpg', 2, 25, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(34, 'AMD RX 7900 XTX', 28500000, N'TDP: 320W | AMD Flagship, 24GB', '/images/image/032_AMD_RX_7900_XTX_main.jpg', 2, 12, '2026-04-06 13:46:29.076393', N'AMD'),
(35, 'RTX 4060 Ti 8GB', 11500000, N'TDP: 160W | Efficient 1080p/2K', '/images/image/033_RTX_4060_Ti_8GB_main.jpg', 2, 43, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(36, 'AMD RX 7800 XT', 15200000, N'TDP: 220W | Best value 2K GPU', N'https://fpsbench.com/static/images/game_images/16_9/fortnite.webp', 2, 30, '2026-04-06 13:46:29.076393', N'AMD'),
(37, 'RTX 3060 12GB', 7800000, N'TDP: 115W | Popular Mid-range', '/images/image/035_RTX_3060_12GB_main.jpg', 2, 80, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(38, 'AMD RX 6600', 5500000, N'TDP: 75W | Best budget 1080p', '/images/image/036_AMD_RX_6600_main.jpg', 2, 100, '2026-04-06 13:46:29.076393', N'AMD'),
(39, 'ASUS ROG RTX 4090', 62000000, N'TDP: 450W | Premium build cooling', '/images/image/037_ASUS_ROG_RTX_4090_main.jpg', 2, 5, '2026-04-06 13:46:29.076393', N'ASUS'),
(40, 'MSI Gaming X RTX 4070', 18500000, N'TDP: 200W | Quiet and Cool', '/images/image/038_MSI_Gaming_X_RTX_4070_main.jpg', 2, 20, '2026-04-06 13:46:29.076393', N'MSI'),
(41, 'Gigabyte Eagle RTX 4060', 8200000, N'TDP: 115W | Triple Fan Budget', '/images/image/039_Gigabyte_Eagle_RTX_4060_main.jpg', 2, 60, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(42, 'RTX 4070 Super', 17800000, N'TDP: 220W | 12GB GDDR6X, Fast', '/images/image/040_RTX_4070_Super_main.jpg', 2, 35, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(43, 'AMD RX 7600', 7900000, N'TDP: 65W | Budget RDNA 3', '/images/image/041_AMD_RX_7600_main.jpg', 2, 50, '2026-04-06 13:46:29.076393', N'AMD'),
(44, 'RTX 3050 6GB', 5200000, N'TDP: 75W | Entry level RTX', '/images/image/042_RTX_3050_6GB_main.jpg', 2, 70, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(45, 'Zotac RTX 4060', 7800000, N'TDP: 115W | Compact dual fan', '/images/image/043_Zotac_RTX_4060_main.jpg', 2, 40, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(46, 'Galax RTX 4070 Pink', 16900000, N'TDP: 200W | Pink Edition RGB', '/images/image/044_Galax_RTX_4070_Pink_main.jpg', 2, 15, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(47, 'ASUS TUF RTX 3070 Ti', 12000000, N'TDP: 285W | Rugged build quality', '/images/image/045_ASUS_TUF_RTX_3070_Ti_main.jpg', 2, 10, '2026-04-06 13:46:29.076393', N'ASUS'),
(48, 'EVGA RTX 3080', 15000000, N'TDP: 320W | High performance legacy', '/images/image/046_EVGA_RTX_3080_main.jpg', 2, 5, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(49, 'Sapphire RX 7900 GRE', 16500000, N'TDP: 220W | Golden Rabbit Edition', '/images/image/047_Sapphire_RX_7900_GRE_main.jpeg', 2, 18, '2026-04-06 13:46:29.076393', N'Sapphire'),
(50, 'PowerColor RX 7800 XT', 14800000, N'TDP: 220W | Excellent cooling', '/images/image/048_PowerColor_RX_7800_XT_main.jpg', 2, 22, '2026-04-06 13:46:29.076393', N'PowerColor'),
(51, 'GTX 1650', 3800000, N'TDP: 75W | No external power', '/images/image/049_GTX_1650_main.jpg', 2, 150, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(52, 'RX 6700 XT', 9500000, N'TDP: 115W | Great 1440p value', '/images/image/050_RX_6700_XT_main.jpg', 2, 40, '2026-04-06 13:46:29.076393', N'AMD'),
(53, 'Colorful RTX 4080', 31000000, N'TDP: 320W | LCD screen on GPU', '/images/image/051_Colorful_RTX_4080_main.png', 2, 8, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(54, 'Quadro RTX A4000', 22000000, N'TDP: 140W | Workstation GPU', '/images/image/052_Quadro_RTX_A4000_main.jpg', 2, 0, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(55, 'Radeon Pro W7800', 58000000, N'TDP: 140W | Professional Graphics', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3773/innergigabyte/images/kft.png', 2, 3, '2026-04-06 13:46:29.076393', N'AMD'),
(56, 'Intel Arc A770 16GB', 9200000, N'TDP: 225W | Intel High-end GPU', N'https://pg.asrock.com/Graphics-Card/photo/Intel%20Arc%20A770%20Phantom%20Gaming%2016GB%20OC(L1).png', 2, 25, '2026-04-06 13:46:29.076393', N'Intel'),
(57, 'Intel Arc A750', 6500000, N'TDP: 225W | Budget King Intel', '/images/image/055_Intel_Arc_A750_main.jpg', 2, 40, '2026-04-06 13:46:29.076393', N'Intel'),
(58, 'ASUS Dual RTX 4070', 17500000, N'TDP: 200W | Clean white build', '/images/image/056_ASUS_Dual_RTX_4070_main.jpg', 2, 15, '2026-04-06 13:46:29.076393', N'ASUS'),
(59, 'Gigabyte RTX 4090', 59000000, N'TDP: 450W | Massive cooler', '/images/image/057_Gigabyte_RTX_4090_main.jpg', 2, 4, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(60, 'PNY RTX 4060', 7500000, N'TDP: 115W | Small and efficient', '/images/image/058_PNY_RTX_4060_main.jpeg', 2, 55, '2026-04-06 13:46:29.076393', N'NVIDIA'),
(61, 'Corsair Vengeance 32GB', 3500000, N'TDP: 10W | DDR5 6000MHz Black', '/images/image/059_Corsair_Vengeance_32GB_main.jpg', 3, 50, '2026-04-06 13:46:29.076393', N'Corsair'),
(62, 'G.Skill Trident Z5 32GB', 4200000, N'TDP: 15W | DDR5 6400MHz RGB', '/images/image/060_G.Skill_Trident_Z5_32GB_main.jpg', 3, 40, '2026-04-06 13:46:29.076393', N'G.Skill'),
(63, 'Kingston Fury 16GB', 1250000, N'TDP: 5W | DDR4 3200MHz', '/images/image/061_Kingston_Fury_16GB_main.jpg', 3, 120, '2026-04-06 13:46:29.076393', N'Kingston'),
(64, 'T-Force Delta 32GB', 3200000, N'TDP: 5W | DDR5 6000MHz White', '/images/image/062_T-Force_Delta_32GB_main.jpg', 3, 45, '2026-04-06 13:46:29.076393', N'TeamGroup'),
(65, 'ADATA XPG 16GB', 1800000, N'TDP: 5W | DDR5 5200MHz', '/images/image/063_ADATA_XPG_16GB_main.webp', 3, 70, '2026-04-06 13:46:29.076393', N'ADATA'),
(66, 'Crucial 8GB', 650000, N'TDP: 5W | Standard office RAM', '/images/image/064_Crucial_8GB_main.jpg', 3, 200, '2026-04-06 13:46:29.076393', N'Crucial'),
(67, 'Dominator Titanium 64GB', 9500000, N'TDP: 15W | DDR5 7200MHz', '/images/image/065_Dominator_Titanium_64GB_main.jpg', 3, 10, '2026-04-06 13:46:29.076393', N'Corsair'),
(68, 'Ripjaws V 16GB', 1100000, N'TDP: 10W | DDR4 3600MHz', '/images/image/066_Ripjaws_V_16GB_main.jpg', 3, 90, '2026-04-06 13:46:29.076393', N'G.Skill'),
(69, 'Lexar Thor 32GB', 2100000, N'TDP: 0W | DDR4 3200MHz Budget', '/images/image/067_Lexar_Thor_32GB_main.jpg', 3, 55, '2026-04-06 13:46:29.076393', N'Lexar'),
(70, 'Fury Renegade 32GB', 4800000, N'TDP: 15W | DDR5 7200MHz', '/images/image/068_Fury_Renegade_32GB_main.jpg', 3, 25, '2026-04-06 13:46:29.076393', N'Kingston'),
(71, 'PNY XLR8 16GB', 1350000, N'TDP: 5W | DDR4 3200MHz RGB', '/images/image/069_PNY_XLR8_16GB_main.jpg', 3, 60, '2026-04-06 13:46:29.076393', N'PNY'),
(72, 'Silicon Power 16GB', 950000, N'TDP: 5W | Value RAM 3200', '/images/image/070_Silicon_Power_16GB_main.jpg', 3, 150, '2026-04-06 13:46:29.076393', N'Silicon Power'),
(73, 'Mushkin Redline 32GB', 3400000, N'TDP: 5W | DDR5 5600MHz', N'https://www.singular.com.cy/images/detailed/615/Mushkin_Redline_DDR5_module_32_GB_SODIMM_MRA5S480FFFD32G-895755.jpg', 3, 20, '2026-04-06 13:46:29.076393', N'Mushkin'),
(74, 'Patriot Viper 16GB', 1450000, N'TDP: 5W | DDR4 4000MHz', '/images/image/072_Patriot_Viper_16GB_main.jpg', 3, 40, '2026-04-06 13:46:29.076393', N'Razer'),
(75, 'Samsung 32GB', 2800000, N'TDP: 5W | DDR5 4800MHz OEM', N'https://shopdigiwireless.com/wp-content/uploads/2023/08/DW-Website-Phones_A04e-1.png', 3, 30, '2026-04-06 13:46:29.076393', N'Samsung'),
(76, 'Thermaltake 16GB', 2200000, N'TDP: 5W | DDR4 3600MHz RGB', '/images/image/074_Thermaltake_16GB_main.jpg', 3, 25, '2026-04-06 13:46:29.076393', N'Thermaltake'),
(77, 'Zadak Spark 32GB', 3900000, N'TDP: 5W | DDR5 6000MHz', '/images/image/075_Zadak_Spark_32GB_main.jpg', 3, 15, '2026-04-06 13:46:29.076393', N'Zadak'),
(78, 'Apacer Panther 8GB', 750000, N'TDP: 5W | Budget Gaming RAM', '/images/image/076_Apacer_Panther_8GB_main.jpg', 3, 100, '2026-04-06 13:46:29.076393', N'Acer'),
(79, 'GeIL Super Luce 16GB', 1300000, N'TDP: 5W | DDR4 3200MHz', N'https://www.memoryc.com/images/products/bb/geil-16567-1_61986.jpg', 3, 50, '2026-04-06 13:46:29.076393', N'GeIL'),
(80, 'V-Color Prism 32GB', 3100000, N'TDP: 5W | DDR4 3600MHz RGB', N'https://microless.com/cdn/products/f2f307222b823793c47a0da071ca69c0-hi.jpg', 3, 40, '2026-04-06 13:46:29.076393', N'V-Color'),
(81, 'Kingston Fury 64GB', 6800000, N'TDP: 5W | DDR5 5600MHz Kit', '/images/image/079_Kingston_Fury_64GB_main.jpg', 3, 20, '2026-04-06 13:46:29.076393', N'Kingston'),
(82, 'Vengeance LPX 32GB', 2500000, N'TDP: 10W | DDR4 3200 Low Profile', N'https://res.cloudinary.com/jawa/image/upload/f_auto,ar_1:1,c_fill,w_3840,q_auto/production/listings/fxqabbdlbowyj2wl8sks', 3, 80, '2026-04-06 13:46:29.076393', N'Corsair'),
(83, 'Trident Z Neo 32GB', 3400000, N'TDP: 5W | Optimized for Ryzen', N'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/2/0/20-374-105-02.jpg', 3, 35, '2026-04-06 13:46:29.076393', N'G.Skill'),
(84, 'Team Elite 16GB', 1600000, N'TDP: 5W | DDR5 4800 Basic', '/images/image/082_Team_Elite_16GB_main.jpg', 3, 60, '2026-04-06 13:46:29.076393', N'TeamGroup'),
(85, 'Crucial Pro 32GB', 3300000, N'TDP: 5W | 6000MHz Overclock', '/images/image/083_Crucial_Pro_32GB_main.jpg', 3, 45, '2026-04-06 13:46:29.076393', N'Crucial'),
(86, 'Aorus RGB 16GB', 2400000, N'TDP: 5W | 3733MHz w/ Demo', '/images/image/084_Aorus_RGB_16GB_main.png', 3, 15, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(87, 'Lexar Ares 32GB', 3600000, N'TDP: 5W | DDR5 6400MHz', '/images/image/085_Lexar_Ares_32GB_main.jpg', 3, 30, '2026-04-06 13:46:29.076393', N'Lexar'),
(88, 'Netac Shadow 16GB', 1100000, N'TDP: 5W | Budget RGB RAM', '/images/image/086_Netac_Shadow_16GB_main.jpg', 3, 100, NULL, N'Netac'),
(89, 'Galax HOF 32GB', 5500000, N'TDP: 5W | 8000MHz White OC', '/images/image/087_Galax_HOF_32GB_main.jpg', 3, 3, '2026-04-06 13:46:29.076393', N'GALAX'),
(90, 'Oloy Blade 32GB', 3250000, N'TDP: 5W | DDR5 6000MHz Black', '/images/image/088_Oloy_Blade_32GB_main.jpeg', 3, 25, '2026-04-06 13:46:29.076393', N'OLOy'),
(91, 'ROG Maximus Z790 Hero', 16500000, N'TDP: 50W | Flagship Intel Board', '/images/image/089_ROG_Maximus_Z790_Hero_main.jpg', 4, 12, '2026-04-06 13:46:29.076393', N'ASUS'),
(92, 'B760M Mortar WiFi', 4500000, N'TDP: 40W | Best Mid-range Intel', '/images/image/090_B760M_Mortar_WiFi_main.png', 4, 45, '2026-04-06 13:46:29.076393', N'MSI'),
(93, 'Z790 Aorus Elite', 7800000, N'TDP: 50W | High perf Z790', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2181/innergigabyteimages/specsmall01.jpg', 4, 30, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(94, 'TUF B650-Plus', 5800000, N'TDP: 40W | Standard AM5 Board', '/images/image/092_TUF_B650-Plus_main.png', 4, 40, '2026-04-06 13:46:29.076393', N'ASUS'),
(95, 'B660M Pro RS', 3200000, N'TDP: 5W | Budget Intel 12/13', '/images/image/093_B660M_Pro_RS_main.jpeg', 4, 60, '2026-04-06 13:46:29.076393', N'ASRock'),
(96, 'X670E Carbon WiFi', 11500000, N'TDP: 50W | High-end AM5', N'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/p/mpg_x670e_carbon_wifi_4_2x.jpg', 4, 15, '2026-04-06 13:46:29.076393', N'MSI'),
(97, 'Prime H610M-K', 2100000, N'TDP: 0W | Office Intel Board', '/images/image/095_Prime_H610M-K_main.jpg', 4, 100, '2026-04-06 13:46:29.076393', N'ASUS'),
(98, 'B450M DS3H', 1850000, N'TDP: 30W | Legendary AM4 Budget', '/images/image/096_B450M_DS3H_main.jpg', 4, 80, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(99, 'ROG Strix B760-I', 5900000, N'TDP: 40W | ITX Intel Board', N'https://microless.com/cdn/products/e990c5abc3a758b3a68f88b2e8460039-hi.jpg', 4, 20, '2026-04-06 13:46:29.076393', N'ASUS'),
(100, 'Z790 GODLIKE', 35000000, N'TDP: 50W | Ultimate Overclock', '/images/image/098_Z790_GODLIKE_main.png', 4, 3, '2026-04-06 13:46:29.076393', N'MSI'),
(101, 'Z790 Taichi', 12500000, N'TDP: 50W | Gear design, E-ATX', '/images/image/099_Z790_Taichi_main.png', 4, 8, '2026-04-06 13:46:29.076393', N'ASRock'),
(102, 'ProArt Z790-Creator', 13800000, N'TDP: 50W | For Creators', '/images/image/100_ProArt_Z790-Creator_main.jpg', 4, 10, '2026-04-06 13:46:29.076393', N'ASUS'),
(103, 'B650I Aorus Ultra', 7200000, N'TDP: 40W | ITX AM5 Board', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2226/innergigabyteimages/smartfan601.png', 4, 12, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(104, 'PRO H610M-E', 1950000, N'TDP: 0W | Cheap office build', '/images/image/102_PRO_H610M-E_main.jpg', 4, 150, '2026-04-06 13:46:29.076393', N'MSI'),
(105, 'Crosshair X670E', 28000000, N'TDP: 50W | Best of AM5', '/images/image/103_Crosshair_X670E_main.jpg', 4, 5, '2026-04-06 13:46:29.076393', N'ASUS'),
(106, 'Biostar B760MZ', 3100000, N'TDP: 40W | Budget B760', N'https://microless.com/cdn/products/a0122264cca32a3cf97401f16cb33fc2-hi.jpg', 4, 40, '2026-04-06 13:46:29.076393', N'Biostar'),
(107, 'CVN B760M Frozen', 4200000, N'TDP: 40W | White Motherboard', '/images/image/105_CVN_B760M_Frozen_main.jpg', 4, 25, '2026-04-06 13:46:29.076393', N'COLORFUL'),
(108, 'A520M S2H', 1650000, N'TDP: 30W | Budget AM4', '/images/image/106_A520M_S2H_main.jpg', 4, 90, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(109, 'NZXT N7 Z790', 8500000, N'TDP: 50W | Clean Aesthetic', '/images/image/107_NZXT_N7_Z790_main.jpg', 4, 18, '2026-04-06 13:46:29.076393', N'NZXT'),
(110, 'A620M-HDV', 2800000, N'TDP: 30W | Cheap AM5 entry', '/images/image/108_A620M-HDV_main.jpg', 4, 55, '2026-04-06 13:46:29.076393', N'ASRock'),
(111, 'Z790 Dark Kingpin', 22000000, N'TDP: 50W | Limitless OC', '/images/image/109_Z790_Dark_Kingpin_main.jpg', 4, 2, '2026-04-06 13:46:29.076393', N'EVGA'),
(112, 'X570S Tomahawk', 6500000, N'TDP: 40W | Silent AM4', N'https://images.novatech.co.uk/msi-mag_x570_tomahawk_wifi_extra3.jpg', 4, 20, '2026-04-06 13:46:29.076393', N'MSI'),
(113, 'A520M-Plus', 2400000, N'TDP: 30W | Durable AM4', '/images/image/111_A520M-Plus_main.jpg', 4, 45, '2026-04-06 13:46:29.076393', N'ASUS'),
(114, 'Z790 UD', 5500000, N'TDP: 50W | Basic Z790', '/images/image/112_Z790_UD_main.jpg', 4, 35, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(115, 'B550M Steel Legend', 3800000, N'TDP: 40W | Solid B550 AM4', '/images/image/113_B550M_Steel_Legend_main.png', 4, 40, '2026-04-06 13:46:29.076393', N'ASRock'),
(116, 'MSI B650 Gaming', 4900000, N'TDP: 40W | Budget AM5 WiFi', '/images/image/114_MSI_B650_Gaming_main.jpg', 4, 50, '2026-04-06 13:46:29.076393', N'MSI'),
(117, 'Prime Z790-P', 6200000, N'TDP: 50W | Mainstream Z790', '/images/image/115_Prime_Z790-P_main.jpg', 4, 30, '2026-04-06 13:46:29.076393', N'ASUS'),
(118, 'H610M S2H', 2250000, N'TDP: 0W | LGA 1700 Office', '/images/image/116_H610M_S2H_main.jpg', 4, 110, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(119, 'X670E Steel Legend', 8900000, N'TDP: 50W | White AM5 High', '/images/image/117_X670E_Steel_Legend_main.jpg', 4, 15, '2026-04-06 13:46:29.076393', N'ASRock'),
(120, 'Valkyrie Z790', 9500000, N'TDP: 50W | Biostar Flagship', '/images/image/118_Valkyrie_Z790_main.png', 4, 7, '2026-04-06 13:46:29.076393', N'Valkyrie'),
(121, 'Samsung 990 Pro 1T', 3200000, N'TDP: 9W | NVMe Gen4 7450MB/s', '/images/image/119_Samsung_990_Pro_1T_main.jpg', 5, 60, '2026-04-06 13:46:29.076393', N'Samsung'),
(122, 'Samsung 980 Pro 2T', 4500000, N'TDP: 9W | NVMe Gen4 7000MB/s', '/images/image/120_Samsung_980_Pro_2T_main.jpg', 5, 40, '2026-04-06 13:46:29.076393', N'Samsung'),
(123, 'WD SN850X 1TB', 2600000, N'TDP: 9W | Top gaming SSD', '/images/image/121_WD_SN850X_1TB_main.jpg', 5, 55, '2026-04-06 13:46:29.076393', N'WD'),
(124, 'Crucial P3 Plus 1T', 1850000, N'TDP: 5W | Budget Gen4', '/images/image/122_Crucial_P3_Plus_1T_main.jpg', 5, 100, '2026-04-06 13:46:29.076393', N'Crucial'),
(125, 'Kingston NV2 500G', 950000, N'TDP: 5W | Entry NVMe', '/images/image/123_Kingston_NV2_500G_main.jpg', 5, 150, '2026-04-06 13:46:29.076393', N'Kingston'),
(126, 'Samsung 870 EVO 1T', 2100000, N'TDP: 5W | Best SATA SSD', '/images/image/124_Samsung_870_EVO_1T_main.jpg', 5, 80, '2026-04-06 13:46:29.076393', N'Samsung'),
(127, 'P41 Platinum 2T', 5200000, N'TDP: 5W | Super Fast Gen4', '/images/image/125_P41_Platinum_2T_main.jpg', 5, 20, '2026-04-06 13:46:29.076393', N'SK hynix'),
(128, 'Lexar NM790 2T', 3800000, N'TDP: 5W | Value Gen4 7400', '/images/image/126_Lexar_NM790_2T_main.jpg', 5, 45, '2026-04-06 13:46:29.076393', N'Lexar'),
(129, 'Crucial T700 1TB', 5800000, N'TDP: 14W | Gen5 11700MB/s', '/images/image/127_Crucial_T700_1TB_main.jpg', 5, 15, '2026-04-06 13:46:29.076393', N'Crucial'),
(130, 'Aorus Gen5 2TB', 9500000, N'TDP: 14W | Gen5 w/ Heatsink', '/images/image/128_Aorus_Gen5_2TB_main.webp', 5, 10, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(131, 'TeamGroup MP33 1T', 1400000, N'TDP: 5W | Budget NVMe', '/images/image/129_TeamGroup_MP33_1T_main.jpg', 5, 90, '2026-04-06 13:46:29.076393', N'TeamGroup'),
(132, 'XPG S70 Blade 1T', 2200000, N'TDP: 5W | PS5 Gen4', '/images/image/130_XPG_S70_Blade_1T_main.png', 5, 65, '2026-04-06 13:46:29.076393', N'ADATA'),
(133, 'SN580 1TB', 1700000, N'TDP: 5W | Reliable Gen4', '/images/image/131_SN580_1TB_main.jpeg', 5, 75, '2026-04-06 13:46:29.076393', N'WD'),
(134, 'FireCuda 530 2TB', 5900000, N'TDP: 5W | High endurance', '/images/image/132_FireCuda_530_2TB_main.jpg', 5, 18, '2026-04-06 13:46:29.076393', N'Seagate'),
(135, 'Sabrent Rocket 4TB', 12500000, N'TDP: 5W | Huge capacity', '/images/image/133_Sabrent_Rocket_4TB_main.jpg', 5, 8, '2026-04-06 13:46:29.076393', N'Sabrent'),
(136, '970 EVO Plus 2TB', 3900000, N'TDP: 5W | Gen3 King', '/images/image/134_970_EVO_Plus_2TB_main.jpg', 5, 30, '2026-04-06 13:46:29.076393', N'Samsung'),
(137, 'PNY CS2241 1TB', 1600000, N'TDP: 5W | Budget Gen4', '/images/image/135_PNY_CS2241_1TB_main.jpg', 5, 50, '2026-04-06 13:46:29.076393', N'PNY'),
(138, 'Silicon Power UD90 1650000', 1650000, N'TDP: 75W | Gen4 Value', N'https://talospc.com/wp-content/uploads/2023/03/SILICON-POWER-UD90-1TB-700-1.jpg', 5, 60, '2026-04-06 13:46:29.076393', N'Silicon Power'),
(139, 'MP600 Pro 2TB', 4800000, N'TDP: 5W | Optimized for PS5', N'https://microless.com/cdn/products/d78642f6f74ff365958f933b707cc544-hi.jpg', 5, 22, '2026-04-06 13:46:29.076393', N'Corsair'),
(140, 'KC3000 1TB', 2450000, N'TDP: 9W | Fast Gen4 OS', '/images/image/138_KC3000_1TB_main.jpg', 5, 40, '2026-04-06 13:46:29.076393', N'Kingston'),
(141, 'Crucial MX500 1TB', 1800000, N'TDP: 5W | SATA storage', '/images/image/139_Crucial_MX500_1TB_main.jpg', 5, 85, '2026-04-06 13:46:29.076393', N'Crucial'),
(142, 'SN350 480GB', 850000, N'TDP: 5W | Cheap upgrade', '/images/image/140_SN350_480GB_main.jpg', 5, 120, '2026-04-06 13:46:29.076393', N'WD'),
(143, 'Spatium M480 2TB', 4600000, N'TDP: 5W | High-end MSI SSD', '/images/image/141_Spatium_M480_2TB_main.jpg', 5, 20, '2026-04-06 13:46:29.076393', N'MSI'),
(144, 'Transcend 250S 1T', 2100000, N'TDP: 5W | Gen4 with Cache', N'https://www.ucc.com.bd/image/cache/catalog/ssd/transcend/TS1TMTE250S-550x550.png.webp', 5, 35, '2026-04-06 13:46:29.076393', N'Transcend'),
(145, 'Viper VP4300 2TB', 5400000, N'TDP: 5W | Dual heatsinks', '/images/image/143_Viper_VP4300_2TB_main.jpeg', 5, 12, '2026-04-06 13:46:29.076393', N'Razer'),
(146, 'Lexar NM620 512G', 900000, N'TDP: 5W | Gen3 Budget', '/images/image/144_Lexar_NM620_512G_main.png', 5, 100, '2026-04-06 13:46:29.076393', N'Lexar'),
(147, 'Netac N7000 2TB', 3600000, N'TDP: 5W | Gen4 7000MB/s', '/images/image/145_Netac_N7000_2TB_main.jpg', 5, 40, '2026-04-06 13:46:29.076393', N'Netac'),
(148, '870 QVO 4TB', 8500000, N'TDP: 5W | Massive SATA', N'https://www.discoazul.pt/uploads/media/images/disco-duro-ssd-samsung-870-qvo-4tb-sata-3-2-5-16.jpg', 5, 31, '2026-04-06 13:46:29.076393', N'Samsung'),
(149, 'Adata SU650 240G', 450000, N'TDP: 12W | Cheapest SSD', '/images/image/147_Adata_SU650_240G_main.jpg', 5, 200, '2026-04-06 13:46:29.076393', N'ADATA'),
(150, 'Crucial T705 2TB', 10500000, N'TDP: 14W | Fastest Gen5', '/images/image/148_Crucial_T705_2TB_main.jpg', 5, 5, '2026-04-06 13:46:29.076393', N'Crucial'),
(151, 'LG 27GR95QE', 22500000, N'TDP: 5W | 27 OLED 240Hz', '/images/image/149_LG_27GR95QE_main.jpg', 6, 12, '2026-04-06 13:46:29.076393', N'LG'),
(152, 'Dell U2723QE', 14800000, N'TDP: 5W | 27" 4K IPS Black', '/images/image/150_Dell_U2723QE_main.jpg', 6, 25, '2026-04-06 13:46:29.076393', N'Dell'),
(153, 'VG249Q', 4200000, N'TDP: 5W | 24 144Hz IPS', '/images/image/151_VG249Q_main.png', 6, 60, '2026-04-06 13:46:29.076393', N'ASUS'),
(154, 'Odyssey Neo G8', 28000000, N'TDP: 5W | 32 4K 240Hz', '/images/image/152_Odyssey_Neo_G8_main.jpg', 6, 8, '2026-04-06 13:46:29.076393', N'Samsung'),
(155, 'Gigabyte M27Q', 7800000, N'TDP: 5W | 27 2K 170Hz', '/images/image/153_Gigabyte_M27Q_main.jpg', 6, 35, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(156, 'AOC 24G2', 3900000, N'TDP: 5W | Popular 144Hz', '/images/image/154_AOC_24G2_main.jpg', 6, 80, '2026-04-06 13:46:29.076393', N'AOC'),
(157, 'ViewSonic VX2728', 4500000, N'TDP: 5W | 27 165Hz IPS', '/images/image/155_ViewSonic_VX2728_main.png', 6, 50, '2026-04-06 13:46:29.076393', N'ViewSonic'),
(158, 'MAG274QRF-QD', 10500000, N'TDP: 5W | 2K Quantum Dot', '/images/image/156_MAG274QRF-QD_main.png', 6, 20, '2026-04-06 13:46:29.076393', N'MSI'),
(159, 'AW3423DW', 32000000, N'TDP: 5W | 34 QD-OLED', '/images/image/157_AW3423DW_main.jpg', 6, 5, '2026-04-06 13:46:29.076393', N'Dell'),
(160, 'BenQ SW271C', 42000000, N'TDP: 5W | Pro Color Photo', '/images/image/158_BenQ_SW271C_main.jpg', 6, 3, '2026-04-06 13:46:29.076393', N'BenQ'),
(161, 'Samsung M7', 8200000, N'TDP: 5W | 32 4K Smart', '/images/image/159_Samsung_M7_main.jpeg', 6, 30, '2026-04-06 13:46:29.076393', N'Samsung'),
(162, 'LG 24MP60G', 2900000, N'TDP: 5W | Budget 24 IPS', '/images/image/160_LG_24MP60G_main.jpg', 6, 100, '2026-04-06 13:46:29.076393', N'LG'),
(163, 'Swift PG42UQ', 38000000, N'TDP: 5W | 42 OLED 4K', '/images/image/161_Swift_PG42UQ_main.jpg', 6, 4, '2026-04-06 13:46:29.076393', N'ASUS'),
(164, 'Gigabyte G24F 2', 4100000, N'TDP: 5W | 24 180Hz OC', '/images/image/162_Gigabyte_G24F_2_main.jpg', 6, 70, '2026-04-06 13:46:29.076393', N'GIGABYTE'),
(165, 'HP Z27k G3', 15500000, N'TDP: 5W | 4K Studio USB-C', '/images/image/163_HP_Z27k_G3_main.jpg', 6, 15, '2026-04-06 13:46:29.076393', N'HP'),
(166, 'Nitro VG271U', 6500000, N'TDP: 5W | 27 2K 144Hz', '/images/image/164_Nitro_VG271U_main.png', 6, 45, '2026-04-06 13:46:29.076393', N'Acer'),
(167, 'Dell S2721DGF', 9200000, N'TDP: 5W | Fast IPS 165Hz', '/images/image/165_Dell_S2721DGF_main.jpg', 6, 22, '2026-04-06 13:46:29.076393', N'Dell'),
(168, 'LG DualUp', 16000000, N'TDP: 5W | Square 16:18', '/images/image/166_LG_DualUp_main.jpg', 6, 10, '2026-04-06 13:46:29.076393', N'LG'),
(169, 'Odyssey G5', 7200000, N'TDP: 5W | 27 2K Curved', '/images/image/167_Odyssey_G5_main.jpg', 6, 40, '2026-04-06 13:46:29.076393', N'Samsung'),
(170, 'Legion Y25-30', 6800000, N'TDP: 5W | 24.5 240Hz', '/images/image/168_Legion_Y25-30_main.jpg', 6, 25, '2026-04-06 13:46:29.076393', N'Lenovo'),
(171, 'ProArt PA278QV', 8900000, N'TDP: 5W | Color Accurate', '/images/image/169_ProArt_PA278QV_main.png', 6, 18, '2026-04-06 13:46:29.076393', N'ASUS'),
(172, 'HKC ANT27TQC', 5500000, N'TDP: 5W | Budget 2K Curved', '/images/image/170_HKC_ANT27TQC_main.png', 6, 55, '2026-04-06 13:46:29.076393', N'HKC'),
(173, 'MSI G2412', 3500000, N'TDP: 5W | Budget 170Hz', '/images/image/171_MSI_G2412_main.png', 6, 90, '2026-04-06 13:46:29.076393', N'MSI'),
(174, 'Dell E2222H', 2200000, N'TDP: 5W | Office 22"', N'https://www.e-retail.com/wp-content/uploads/2022/02/monitors_e2222h_gallery_2.jpg', 6, 150, '2026-04-06 13:46:29.076393', N'Dell'),
(175, 'LG 29WP500', 5200000, N'TDP: 5W | 29 UltraWide', '/images/image/173_LG_29WP500_main.jpg', 6, 35, '2026-04-06 13:46:29.076393', N'LG'),
(176, 'Philips 242E1', 3100000, N'TDP: 0W | Budget 144Hz', '/images/image/174_Philips_242E1_main.jpg', 6, 80, '2026-04-06 13:46:29.076393', N'Philips'),
(177, 'AOC CU34G2X', 12500000, N'TDP: 5W | 34 UW 144Hz', '/images/image/175_AOC_CU34G2X_main.jpg', 6, 15, '2026-04-06 13:46:29.076393', N'AOC'),
(178, 'Xeneon Flex', 45000000, N'TDP: 5W | Bendable OLED', '/images/image/176_Xeneon_Flex_main.jpg', 6, 2, '2026-04-06 13:46:29.076393', N'Corsair'),
(179, 'Zowie XL2546K', 13500000, N'TDP: 5W | Pro Esport 240Hz', N'https://brain-images-ssl.cdn.dixons.com/4/9/10218894/u_10218894.jpg', 6, 20, '2026-04-06 13:46:29.076393', N'BenQ'),
(180, 'Xiaomi Mi 34', 9500000, N'TDP: 5W | 34 2K UltraWide', '/images/image/178_Xiaomi_Mi_34_main.jpg', 6, 40, '2026-04-06 13:46:29.076393', N'Xiaomi'),
(181, 'Intel Arc A770 Limited Edition GPU', 8356600, N'TDP: 225W | 16GB GDDR6, 256-bit, 2100 MHz, 225W', '/images/image/179_Intel_Arc_A770_Limited_Edition_GPU_main.jpg', 2, 50, '2026-06-05 10:05:55.522526', N'Intel'),
(182, 'Intel Arc A750 Graphics Card', 6324600, N'TDP: 225W | 8GB GDDR6, 256-bit, 2050 MHz, 225W', '/images/image/180_Intel_Arc_A750_Graphics_Card_main.jpg', 2, 49, '2026-06-05 10:05:55.522526', N'Intel'),
(183, 'Intel Arc A580 Graphics Card', 4546600, N'TDP: 185W | 8GB GDDR6, 256-bit, 1700 MHz, 185W', '/images/image/181_Intel_Arc_A580_Graphics_Card_main.jpg', 2, 50, '2026-06-05 10:05:55.522526', N'Intel'),
(184, 'AMD Radeon RX 7900 XT GPU', 22834600, N'TDP: 285W | 20GB GDDR6, 80MB, 315W', '/images/image/182_AMD_Radeon_RX_7900_XT_GPU_main.jpg', 2, 50, '2026-06-05 10:05:55.522526', N'AMD'),
(185, 'AMD Radeon RX 7800 XT GPU', 12674600, N'TDP: 220W | 16GB GDDR6, 64MB, 263W', '/images/image/183_AMD_Radeon_RX_7800_XT_GPU_main.jpg', 2, 50, '2026-06-05 10:05:55.522526', N'AMD'),
(186, 'AMD Ryzen 5 5600X Desktop Processor', 3784600, N'TDP: 65W | 6 Cores, 12 Threads, 35MB Cache, Up to 4.6GHz, Socket AM4', '/images/image/184_AMD_Ryzen_5_5600X_Desktop_Processor_main.jpg', 1, 50, '2026-06-05 10:05:55.522526', N'AMD'),
(187, 'ASUS ROG Maximus Z790 Dark Hero', 17754600, N'TDP: 50W | LGA1700, Intel Z790, 4x DDR5 (Up to 192GB), ATX', '/images/image/185_ASUS_ROG_Maximus_Z790_Dark_Hero_main.jpg', 4, 50, '2026-06-05 10:05:55.522526', N'ASUS'),
(188, 'ASUS ROG Strix X670E-E Gaming WiFi', 12674600, N'TDP: 50W | AM5, AMD X670E, PCIe 5.0, ATX', '/images/image/186_ASUS_ROG_Strix_X670E-E_Gaming_WiFi_main.jpg', 4, 50, '2026-06-05 10:05:55.522526', N'ASUS'),
(189, 'ASUS ROG Strix GeForce RTX 4090 OC Edition', 50774600, N'TDP: 450W | 24GB GDDR6X, 16384, PCIe 4.0', '/images/image/187_ASUS_ROG_Strix_GeForce_RTX_4090_OC_Edition_main.jpg', 2, 50, '2026-06-05 10:05:55.522526', N'ASUS'),
(190, 'ASUS ROG Swift OLED PG32UCDM', 32994600, N'TDP: 0W | 32-inch, 3840x2160 (4K), 240Hz, QD-OLED', '/images/image/188_ASUS_ROG_Swift_OLED_PG32UCDM_main.jpg', 6, 50, '2026-06-05 10:05:55.522526', N'ASUS'),
(191, 'ASUS ROG Ryujin III 360 ARGB', 8864600, N'TDP: 15W | 360mm, Asetek 8th Gen, 3.5-inch Full Color', '/images/image/189_ASUS_ROG_Ryujin_III_360_ARGB_main.jpg', 13, 50, '2026-06-05 10:05:55.522526', N'ASUS'),
(192, 'ASUS ROG Thor 1200W Platinum II', 8102600, N'TDP: 0W | 1200W, 80 Plus Platinum, Full Modular, Real-time power draw', N'https://pcboost.co.uk/wp-content/uploads/2022/11/ROG-THOR-1200W-Platinum-II-Fully-Modular-Power-Supply-From-ASUS.jpg', 11, 50, '2026-06-05 10:05:55.522526', N'ASUS'),
(193, 'MSI MEG Z790 GODLIKE MAX', 30454600, N'TDP: 50W | LGA1700, Intel Z790, 7x M.2 slots, M-Vision Dashboard', '/images/image/191_MSI_MEG_Z790_GODLIKE_MAX_main.png', 4, 50, '2026-06-05 10:05:55.522526', N'MSI'),
(194, 'MSI MAG B650 TOMAHAWK WIFI', 5562600, N'TDP: 40W | AM5, AMD B650, DDR5 7600+(OC), Realtek 2.5Gbps LAN', '/images/image/192_MSI_MAG_B650_TOMAHAWK_WIFI_main.webp', 4, 50, '2026-06-05 10:05:55.522526', N'MSI'),
(195, 'MSI GeForce RTX 4080 SUPER 16G GAMING X SLIM', 26644600, N'TDP: 320W | 16GB GDDR6X, TRI FROZR 3, 2625 MHz', '/images/image/193_MSI_GeForce_RTX_4080_SUPER_16G_GAMING_X_SLIM_main.jpg', 2, 50, '2026-06-05 10:05:55.522526', N'MSI'),
(196, 'MSI MPG 271QRX QD-OLED', 20294600, N'TDP: 0W | 27-inch, 2560x1440 (2K), 360Hz, 0.03ms (GtG)', '/images/image/194_MSI_MPG_271QRX_QD-OLED_main.webp', 6, 50, '2026-06-05 10:05:55.522526', N'MSI'),
(197, 'MSI MEG MAESTRO 700L PZ', 10642600, N'TDP: 5W | ATX Full Tower, Curved Tempered Glass, Back-connect (Project Zero) support', '/images/image/195_MSI_MEG_MAESTRO_700L_PZ_main.png', 12, 50, '2026-06-05 10:05:55.522526', N'MSI'),
(198, 'MSI MAG CORELIQUID I360', 3530600, N'TDP: 15W | 360mm, ARGB Fans, Infinite Mirror IPS Style Design', '/images/image/196_MSI_MAG_CORELIQUID_I360_main.jpg', 13, 50, '2026-06-05 10:05:55.522526', N'MSI'),
(199, 'MSI SPATIUM M570 PCIe 5.0 NVMe M.2 HS', 7594600, N'TDP: 14W | 2TB, Up to 12400 MB/s, Up to 11800 MB/s', '/images/image/197_MSI_SPATIUM_M570_PCIe_5.0_NVMe_M.2_HS_main.png', 5, 50, '2026-06-05 10:05:55.522526', N'MSI'),
(200, 'Gigabyte Z790 AORUS XTREME X', 25374600, N'TDP: 50W | LGA1700, 24+1+2 Phases, Wi-Fi 7, PCIe 5.0 x16', '/images/image/198_Gigabyte_Z790_AORUS_XTREME_X_main.jpg', 4, 50, '2026-06-05 10:05:55.522526', N'GIGABYTE'),
(201, 'Gigabyte X670E AORUS MASTER', 11404600, N'TDP: 50W | AM5, AMD X670E, 4x M.2 PCIe 5.0, Intel 2.5GbE LAN', '/images/image/199_Gigabyte_X670E_AORUS_MASTER_main.jpg', 4, 50, '2026-06-05 10:05:55.522526', N'GIGABYTE'),
(202, 'Gigabyte M27Q Gaming Monitor', 7594600, N'TDP: 0W | 27-inch, Super Speed IPS, 2560x1440, 170Hz', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/1554/innergigabyteimages/bg1.png', 6, 50, '2026-06-05 10:05:55.522526', N'GIGABYTE'),
(203, 'Gigabyte AORUS FO32U2P', 30454600, N'TDP: 5W | 32-inch, OLED (QD-OLED), 3840x2160, DP 2.1 UHBR20 supported', '/images/image/201_Gigabyte_AORUS_FO32U2P_main.jpg', 6, 50, '2026-06-05 10:05:55.522526', N'GIGABYTE'),
(204, 'Gigabyte AORUS Gen5 12000 SSD 2TB', 8102600, N'TDP: 14W | PCIe 5.0 x4, NVMe 2.0, 12,400 MB/s, 11,800 MB/s', N'https://elbadrgroupeg.store/image/cache/catalog/Gigabyte/fRt20PFj2jAFDEFVYh7wtd8LXj-1000x1000.png', 5, 50, '2026-06-05 10:05:55.522526', N'GIGABYTE'),
(205, 'Gigabyte UD1000GM PG5 (Rev 2.0)', 4038600, N'TDP: 0W | 1000W, PCIe Gen 5.0 (12VHPWR), 80 PLUS Gold', '/images/image/203_Gigabyte_UD1000GM_PG5_(Rev_2.0)_main.png', 11, 50, '2026-06-05 10:05:55.522526', N'GIGABYTE'),
(206, 'Gigabyte AORUS C500 GLASS', 4546600, N'TDP: 0W | Mid Tower, 4mm Tempered Glass, Up to 420mm front', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2156/innergigabyteimages/utility-img-1.jpg', 12, 50, '2026-06-05 10:05:55.522526', N'GIGABYTE'),
(207, 'Corsair Dominator Titanium RGB DDR5 32GB (2x16GB)6000MHz', 4673600, N'TDP: 15W | 32GB, 6000 MT/s, CL30, Intel XMP 3.0 / AMD EXPO', '/images/image/205_Corsair_Dominator_Titanium_RGB_DDR5_32GB_(2x16GB)6_main.jpg', 3, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(208, 'Corsair Vengeance RGB DDR5 64GB (2x32GB)5600MHz', 5562600, N'TDP: 65W | 64GB, 5600 MT/s, CL40', '/images/image/206_Corsair_Vengeance_RGB_DDR5_64GB_(2x32GB)5600MHz_main.jpg', 3, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(209, 'Corsair iCUE LINK H150i LCD Liquid CPU Cooler', 7340600, N'TDP: 5W | 360mm, 3x QX120 RGB Fans, 2.1-inch IPS Display, iCUE LINK Ecosystem', N'https://microless.com/cdn/products/f8d91556e68aba4803a42b07377221bc-hi.jpg', 13, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(210, 'Corsair 5000D AIRFLOW Tempered Glass Mid-Tower', 4165600, N'TDP: 0W | Mid-Tower, Black, RapidRoute System, Up to 10x 120mm fans', '/images/image/208_Corsair_5000D_AIRFLOW_Tempered_Glass_Mid-Tower_main.png', 12, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(211, 'Corsair iCUE LINK 6500X RGB Mid-Tower DualChamber', 5054600, N'TDP: 0W | Dual Chamber Layout, Reverse-connector support, Front & Side Tempered Glass', '/images/image/209_Corsair_iCUE_LINK_6500X_RGB_Mid-Tower_DualChamber_main.webp', 12, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(212, 'Corsair RM1000x Shift Fully Modular ATX PSU', 5308600, N'TDP: 0W | 1000W, 80 PLUS Gold, Side-mounted modular connections, ATX 3.0 & PCIe 5.0 ready', '/images/image/210_Corsair_RM1000x_Shift_Fully_Modular_ATX_PSU_main.jpg', 11, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(213, 'Corsair AX1600i Digital ATX Power Supply', 15468600, N'TDP: 0W | 1600W, 80 PLUS Titanium, Gallium Nitride (GaN) FETs', '/images/image/211_Corsair_AX1600i_Digital_ATX_Power_Supply_main.jpg', 11, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(214, 'Corsair K100 RGB Mechanical Gaming Keyboard', 6324600, N'TDP: 2W | Corsair OPX Optical-Mechanical, AXON 4000Hz Hyper-polling, iCUE Control Wheel', N'https://eezepc.com/wp-content/uploads/2021/03/Corsair-K100-RGB-Mechanical-Gaming-Keyboard-EEZEPC-1.jpg', 15, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(215, 'Corsair Darkstar Wireless MMO Gaming Mouse', 4292600, N'TDP: 1W | 15 programmable buttons, MARKSMAN 26K DPI Optical, SLIPSTREAM Wireless & Bluetooth', '/images/image/213_Corsair_Darkstar_Wireless_MMO_Gaming_Mouse_main.webp', 16, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(216, 'Corsair Virtuoso RGB Wireless XT Headset', 6832600, N'TDP: 1W | High-Density 50mm Neodymium, Spatial Dolby Atmos, Broadcast-grade detachable mic', '/images/image/214_Corsair_Virtuoso_RGB_Wireless_XT_Headset_main.webp', 17, 50, '2026-06-05 10:05:55.522526', N'Corsair'),
(217, 'Logitech G Pro X Superlight 2 Wireless GamingMouse', 4038600, N'TDP: 1W | 60 grams, HERO 2 Sensor (32,000 DPI), LIGHTFORCE Hybrid Switches, 4000Hz max polling', '/images/image/215_Logitech_G_Pro_X_Superlight_2_Wireless_GamingMouse_main.png', 16, 50, '2026-06-05 10:05:55.522526', N'Logitech'),
(218, 'Logitech G502 X LIGHTSPEED Wireless GamingMouse', 3530600, N'TDP: 1W | HERO 25K Sensor, 13 programmable controls, Dual-mode infinite scroll', '/images/image/216_Logitech_G502_X_LIGHTSPEED_Wireless_GamingMouse_main.jpg', 16, 50, '2026-06-05 10:05:55.522526', N'Logitech'),
(219, 'Logitech G915 TKL Wireless Mechanical Keyboard', 5816600, N'TDP: 2W | Tenkeyless (TKL), Low Profile GL Tactile/Linear/Clicky, Up to 40 hours (100% brightness)', '/images/image/217_Logitech_G915_TKL_Wireless_Mechanical_Keyboard_main.png', 15, 50, '2026-06-05 10:05:55.522526', N'Logitech'),
(220, 'Logitech G Pro X TKL LIGHTSPEED Gaming Keyboard', 5054600, N'TDP: 2W | Dual-shot PBT keycaps, LIGHTSPEED Wireless, Bluetooth, USB, Dedicated volume roller and controls', '/images/image/218_Logitech_G_Pro_X_TKL_LIGHTSPEED_Gaming_Keyboard_main.png', 15, 50, '2026-06-05 10:05:55.522526', N'Logitech'),
(221, 'Logitech G Pro X 2 LIGHTSPEED Wireless Headset', 6324600, N'TDP: 1W | 50mm Graphene Drivers, LIGHTSPEED, Bluetooth, 3.5mm wired, Up to 50 hours battery life', '/images/image/219_Logitech_G_Pro_X_2_LIGHTSPEED_Wireless_Headset_main.jpg', 17, 50, '2026-06-05 10:05:55.522526', N'Logitech'),
(222, 'Logitech MX Master 3S Wireless Mouse', 2514600, N'TDP: 1W | 8K DPI tracking on any surface, Quiet clicks technology, MagSpeed Electromagnetic scrolling', '/images/image/220_Logitech_MX_Master_3S_Wireless_Mouse_main.jpg', 16, 50, '2026-06-05 10:05:55.522526', N'Logitech'),
(223, 'Logitech MX Keys S Wireless Keyboard', 2768600, N'TDP: 2W | Spherically-dished Perfect Stroke keys, Smart illumination proximity sensor, Easy-Switch up to 3 devices', '/images/image/221_Logitech_MX_Keys_S_Wireless_Keyboard_main.png', 15, 50, '2026-06-05 10:05:55.522526', N'Logitech'),
(224, 'Razer Viper V3 Pro Wireless Gaming Mouse', 4038600, N'TDP: 1W | 54 grams, Focus Pro 35K Optical Sensor Gen-2, True 8000Hz HyperPolling Wireless', '/images/image/222_Razer_Viper_V3_Pro_Wireless_Gaming_Mouse_main.jpg', 16, 50, '2026-06-05 10:05:55.522526', N'Razer'),
(225, 'Razer DeathAdder V3 Pro Wireless Gaming Mouse', 3784600, N'TDP: 1W | 63 grams, Right-handed ergonomic design, Focus Pro 30K Optical Sensor', '/images/image/223_Razer_DeathAdder_V3_Pro_Wireless_Gaming_Mouse_main.png', 16, 50, '2026-06-05 10:05:55.522526', N'Razer'),
(226, 'Razer Huntsman V3 Pro TKL Mechanical Keyboard', 5562600, N'TDP: 2W | Razer Analog Optical Switches Gen-2, Rapid Trigger mode with adjustable actuation (0.1- 4.0mm), Dual-purpose digital dial', '/images/image/224_Razer_Huntsman_V3_Pro_TKL_Mechanical_Keyboard_main.jpg', 15, 50, '2026-06-05 10:05:55.522526', N'Razer'),
(227, 'Razer BlackWidow V4 Pro Mechanical GamingKeyboard', 5816600, N'TDP: 2W | Razer Green Clicky / Yellow Linear Switches, Per-key & 3-sided underglow RGB, 8 dedicated macro keys', '/images/image/225_Razer_BlackWidow_V4_Pro_Mechanical_GamingKeyboard_main.jpg', 15, 50, '2026-06-05 10:05:55.522526', N'Razer'),
(228, 'Razer BlackShark V2 Pro (2023 Edition) WirelessHeadset', 5054600, N'TDP: 1W | Razer HyperClear Super Wideband Mic, TriForce Titanium 50mm Drivers, Up to 70 hours', '/images/image/226_Razer_BlackShark_V2_Pro_(2023_Edition)_WirelessHea_main.jpg', 17, 50, '2026-06-05 10:05:55.522526', N'Razer'),
(229, 'Samsung 990 PRO PCIe 4.0 NVMe M.2 SSD 2TB', 4546600, N'TDP: 9W | 2TB, Up to 7450 MB/s, Up to 6900 MB/s, Samsung Pascal Controller', '/images/image/227_Samsung_990_PRO_PCIe_4.0_NVMe_M.2_SSD_2TB_main.jpg', 5, 50, '2026-06-05 10:05:55.522526', N'Samsung'),
(230, 'Samsung 990 EVO PCIe 4.0 x4 / 5.0 x2 M.2 SSD 1TB', 2260600, N'TDP: 9W | 1TB, Up to 5000 MB/s, Up to 4200 MB/s', '/images/image/228_Samsung_990_EVO_PCIe_4.0_x4_5.0_x2_M.2_SSD_1TB_main.jpg', 5, 50, '2026-06-05 10:05:55.522526', N'Samsung'),
(231, 'Samsung T7 Shield Portable SSD 2TB', 4292600, N'TDP: 9W | 2TB, USB 3.2 Gen 2 (10Gbps), IP65 water & dust resistant, 3-meter drop proof', '/images/image/229_Samsung_T7_Shield_Portable_SSD_2TB_main.jpg', 5, 50, '2026-06-05 10:05:55.522526', N'Samsung'),
(232, 'Samsung Odyssey OLED G9 (G95SC) Gaming Monitor', 40614600, N'TDP: 0W | 49-inch Curved Ultra-wide, 5120x1440 (Dual QHD), 240Hz, 0.03ms (GtG)', '/images/image/230_Samsung_Odyssey_OLED_G9_(G95SC)_Gaming_Monitor_main.jpg', 6, 50, '2026-06-05 10:05:55.522526', N'Samsung'),
(233, 'Samsung Odyssey Ark Gen 2 Mini-LED Monitor', 63474600, N'TDP: 0W | 55-inch 1000R Curved, 3840x2160 (4K), 165Hz, Yes, rotates vertically', '/images/image/231_Samsung_Odyssey_Ark_Gen_2_Mini-LED_Monitor_main.jpg', 6, 50, '2026-06-05 10:05:55.522526', N'Samsung'),
(234, 'Samsung Galaxy Buds3 Pro', 6324600, N'TDP: 5W | Hi-Fi 24-bit Ultra High Quality Audio, Adaptive Noise Cancelling with Blade Lights, Stem style ergonomic fit', '/images/image/232_Samsung_Galaxy_Buds3_Pro_main.jpg', 17, 50, '2026-06-05 10:05:55.522526', N'Samsung'),
(235, 'Kingston FURY Renegade DDR5 RGB 32GB (2x16GB) 7200MHz', 4292600, N'TDP: 15W | 32GB Kit, 7200 MT/s, CL38-44-44, 1.45V', '/images/image/233_Kingston_FURY_Renegade_DDR5_RGB_32GB_(2x16GB)_7200_main.webp', 3, 50, '2026-06-05 10:05:55.522526', N'Kingston'),
(236, 'Kingston FURY Beast DDR5 32GB (2x16GB) 6000MHz', 3022600, N'TDP: 15W | 32GB Kit, 6000 MT/s, AMD EXPO / Intel XMP 3.0 certified', '/images/image/234_Kingston_FURY_Beast_DDR5_32GB_(2x16GB)_6000MHz_main.jpg', 3, 50, '2026-06-05 10:05:55.522526', N'Kingston'),
(237, 'Kingston KC3000 PCIe 4.0 NVMe M.2 SSD 2TB', 3911600, N'TDP: 9W | 2TB, Up to 7000 MB/s, Up to 7000 MB/s, Phison E18', '/images/image/235_Kingston_KC3000_PCIe_4.0_NVMe_M.2_SSD_2TB_main.jpg', 5, 50, '2026-06-05 10:05:55.522526', N'Kingston'),
(238, 'Kingston NV2 PCIe 4.0 NVMe M.2 SSD 1TB', 1625600, N'TDP: 9W | 1TB, Up to 3500 MB/s, Up to 2100 MB/s, M.2 2280', '/images/image/236_Kingston_NV2_PCIe_4.0_NVMe_M.2_SSD_1TB_main.jpg', 5, 50, '2026-06-05 10:05:55.522526', N'Kingston'),
(239, 'Kingston FURY Impact DDR5 SO-DIMM 32GB (2x16GB) 5600MHz', 3149600, N'TDP: 65W | Laptop Memory (SO-DIMM), 32GB Kit, 5600 MT/s', '/images/image/237_Kingston_FURY_Impact_DDR5_SO-DIMM_32GB_(2x16GB)_56_main.jpg', 3, 50, '2026-06-05 10:05:55.522526', N'Kingston'),
(240, 'WD Red Pro NAS Internal Hard Drive 12TB', 7594600, N'TDP: 5W | 12TB, 7200 RPM, 256MB, SATA 6 Gb/s', '/images/image/238_WD_Red_Pro_NAS_Internal_Hard_Drive_12TB_main.jpg', 10, 50, '2026-06-05 10:05:55.522526', N'WD'),
(241, 'Seagate IronWolf Pro 16TB NAS HDD', 8356600, N'TDP: 7W | 16TB, 550TB/year, Rotational Vibration (RV) sensors', '/images/image/239_Seagate_IronWolf_Pro_16TB_NAS_HDD_main.jpeg', 10, 50, '2026-06-05 10:05:55.522526', N'Seagate'),
(242, 'Noctua NH-D15 chromax.black Dual-Tower Cooler', 3022600, N'TDP: 5W | 2x NF-A15 HS-PWM fans, Full black design, Intel LGA1700/AM5 ready', '/images/image/240_Noctua_NH-D15_chromax.black_Dual-Tower_Cooler_main.jpeg', 13, 50, '2026-06-05 10:05:55.522526', N'Noctua'),
(243, 'NZXT H9 Flow Dual-Chamber Mid-Tower', 4038600, N'TDP: 0W | Wrap-around tempered glass pane, 4x F120Q Airflow fans, Up to 435mm', '/images/image/241_NZXT_H9_Flow_Dual-Chamber_Mid-Tower_main.jpg', 12, 50, '2026-06-05 10:05:55.522526', N'NZXT'),
(244, 'NZXT Kraken Elite 360 RGB Liquid Cooler', 7594600, N'TDP: 15W | 360mm aluminum radiator, 2.36-inch wide-angle TFT-LCD display, 640x640 pixels', '/images/image/242_NZXT_Kraken_Elite_360_RGB_Liquid_Cooler_main.jpg', 13, 50, '2026-06-05 10:05:55.522526', N'NZXT'),
(245, 'SteelSeries Arctis Nova Pro Wireless Headset', 8864600, N'TDP: 1W | Nova Pro Acoustic System, Active Noise Cancellation with Transparency Mode, Dual Battery Infinity System', '/images/image/243_SteelSeries_Arctis_Nova_Pro_Wireless_Headset_main.jpg', 17, 50, '2026-06-05 10:05:55.522526', N'SteelSeries'),
(246, 'BenQ ZOWIE XL2566K 360Hz Esports Gaming Monitor', 15214600, N'TDP: 15W | 24.5-inch TN Panel, 360Hz, DyAc+ Technology motion blur reduction', '/images/image/244_BenQ_ZOWIE_XL2566K_360Hz_Esports_Gaming_Monitor_main.jpg', 6, 50, '2026-06-05 10:05:55.522526', N'BenQ'),
(247, 'Sony WH-1000XM5 Wireless Noise CancelingHeadphones', 10134600, N'TDP: 1W | Integrated Processor V1 & HD Noise CancelingProcessor QN1, 8 microphones for extreme voice pick up, Up to 30 hours total life', '/images/image/245_Sony_WH-1000XM5_Wireless_Noise_CancelingHeadphones_main.webp', 17, 50, '2026-06-05 10:05:55.522526', N'Sony'),
(248, 'Crucial Pro DDR5 48GB (2x24GB) 5600MHz Kit', 3784600, N'TDP: 65W | 48GB Kit, 5600 MT/s, Low-profile aluminum black heatsink', '/images/image/246_Crucial_Pro_DDR5_48GB_(2x24GB)_5600MHz_Kit_main.jpg', 3, 50, '2026-06-05 10:05:55.522526', N'Crucial'),
(249, 'Fractal Design North Charcoal Black WoodMid-Tower', 3530600, N'TDP: 5W | Real walnut wood front panel struts, Mesh or Tempered Glass available, 2x Aspect 14 PWM fans', '/images/image/247_Fractal_Design_North_Charcoal_Black_WoodMid-Tower_main.jpg', 12, 50, '2026-06-05 10:05:55.522526', N'Fractal Design'),
(250, 'Lian Li O11 Dynamic EVO RGB Black', 4292600, N'TDP: 0W | Dual-chamber adjustable ATX case, Two L-shaped diffuse LED RGB strips, Reversible design architecture', '/images/image/248_Lian_Li_O11_Dynamic_EVO_RGB_Black_main.jpeg', 12, 50, '2026-06-05 10:05:55.522526', N'Lian Li'),
(251, 'Lian Li UNI FAN TL LCD 120 Triple Pack Black', 3784600, N'TDP: 4W | 120mm fans, Built-in 1.6-inch LCD screen on center fan, Daisy-chain interlocking mechanism', N'https://microless.com/cdn/products/01a0bf24eea1fcdb39621ce8e43485f5-hi.jpg', 14, 50, '2026-06-05 10:05:55.522526', N'Lian Li'),
(252, 'EVGA SuperNOVA 1000 G7 Gold Modular PSU', 4800600, N'TDP: 0W | 1000W, 80 PLUS Gold Certified, Ultra-compact 130mm chassis size', N'https://www.cyberpuerta.mx/img/product/XL/CP-EVGA-220-G7-1000-X1-87d9b7.jpg', 11, 50, '2026-06-05 10:05:55.522526', N'EVGA'),
(253, 'DeepCool AK620 Digital Dual-Tower Air Cooler', 2006600, N'TDP: 5W | Real-time temperature and usage status top screen, 2x FK120 fluid dynamic bearing fans, 6x 6mm copper heatpipes', '/images/image/251_DeepCool_AK620_Digital_Dual-Tower_Air_Cooler_main.jpg', 13, 50, '2026-06-05 10:05:55.522526', N'DeepCool'),
(254, 'Thermalright Peerless Assassin 120 SE AirCooler', 990600, N'TDP: 5W | Dual tower heatsink design, 2x TL-C12C 120mm PWM fans, 155mm standard height', '/images/image/252_Thermalright_Peerless_Assassin_120_SE_AirCooler_main.jpg', 13, 50, '2026-06-05 10:05:55.522526', N'Thermalright'),
(255, 'Be Quiet! Dark Power 13 1000W Titanium ATX 3.0PSU', 7340600, N'TDP: 65W', '/images/image/253_Be_Quiet!_Dark_Power_13_1000W_Titanium_ATX_3.0PSU_main.jpg', 11, 50, '2026-06-05 10:05:55.522526', N'Intel'),
(256, 'Intel Core Ultra 7 265F (Tray)', 12000000, N'TDP: 125W', N'https://med.greatecno.com/1526371-large_default/intel-s1851-core-ultra-7-265f-tray.jpg', 1, 97, '2026-06-27 12:52:49.647', N'Intel'),
(257, N'Intel Core i5 12400F / 2.5GHz Turbo 4.4GHz (TRAY) - CHÍNH HÃNG', 2500000, N'TDP: 65W', N'https://cdn.hstatic.net/products/200000837185/12400f_tray_e59465bf117e4e778e5f568c39bc32b9_grande.png', 1, 99, '2026-06-27 12:52:50.064', N'Intel'),
(258, 'Intel Core i7 14700F (Tray)', 9500000, N'TDP: 65W', '/images/image/256_Intel_Core_i7_14700F_(Tray)_main.jpg', 1, 100, '2026-06-27 12:52:50.462', N'Intel'),
(259, 'GIGABYTE Z890 EAGLE WIFI7 (DDR5)', 7500000, N'TDP: 40W', '/images/image/257_GIGABYTE_Z890_EAGLE_WIFI7_(DDR5)_main.jpg', 4, 97, '2026-06-27 12:52:50.891', N'GIGABYTE'),
(260, 'GIGABYTE H610M-H V3 (DDR4)', 1800000, N'TDP: 30W', '/images/image/258_GIGABYTE_H610M-H_V3_(DDR4)_main.jpg', 4, 99, '2026-06-27 12:52:51.326', N'GIGABYTE'),
(261, 'GIGABYTE B760M GAMING PLUS WIFI DDR4', 3500000, N'TDP: 40W', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3701/innergigabyteimages/kf-img.png', 4, 100, '2026-06-27 12:52:51.741', N'GIGABYTE'),
(262, 'RAM Kingmax Horizon 16GB DDR5 Bus 5600Mhz', 1200000, N'TDP: 10W', '/images/image/260_RAM_Kingmax_Horizon_16GB_DDR5_Bus_5600Mhz_main.jpg', 3, 97, '2026-06-27 12:52:52.239', N'Kingmax'),
(263, 'Ram KingSpec Heatsink Red 1x16GB DDR4 Bus 3200Mhz', 750000, N'TDP: 10W', '/images/image/261_Ram_KingSpec_Heatsink_Red_1x16GB_DDR4_Bus_3200Mhz_main.jpg', 3, 100, '2026-06-27 12:52:52.718', N'KingSpec'),
(264, 'MSI GeForce RTX 5070 Ti 16GB Shadow 3X OC', 25000000, N'TDP: 250W', '/images/image/262_MSI_GeForce_RTX_5070_Ti_16GB_Shadow_3X_OC_main.png', 9, 99, '2026-06-27 12:52:53.246', N'MSI'),
(265, 'GIGABYTE GeForce RTX 5080 WINDFORCE OC SFF 16G', 35000000, N'TDP: 300W', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3886/innergigabyte/images/features-img.png', 9, 98, '2026-06-27 12:52:53.742', N'GIGABYTE'),
(266, 'MSI GeForce RTX 5060 Ventus 2X OC 8GB', 8500000, N'TDP: 150W', '/images/image/264_MSI_GeForce_RTX_5060_Ventus_2X_OC_8GB_main.png', 9, 100, '2026-06-27 12:52:54.227', N'MSI'),
(267, 'ZOTAC GeForce RTX 5060 Ti 8GB TWIN EDGE GDDR7', 11000000, N'TDP: 160W', '/images/image/265_ZOTAC_GeForce_RTX_5060_Ti_8GB_TWIN_EDGE_GDDR7_main.jpeg', 9, 100, '2026-06-27 12:52:54.716', N'NVIDIA'),
(268, N'Ổ cứng SSD Kingston NV3 1TB M.2 PCIe NVMe Gen4', 1800000, N'TDP: 10W', N'https://down-ph.img.susercontent.com/file/sg-11134201-7rdw7-lzr1u0ea362c97', 7, 97, '2026-06-27 12:52:55.209', N'Kingston'),
(269, N'Ổ Cứng SSD KingSpec NVMe 512GB (NE-512)', 800000, N'TDP: 10W', N'https://hmpcstore.com/admin/uploads/O-cung-SSD-KingSpec-NE-512GB-PCIe-Gen3-x4-NVMe-M2-2280-NE-512/20260225_101548_0_699e696480d03_710__ne-5122-1__1__8d84d40669de4ec497acc541f607579f_grande.jpg', 7, 100, '2026-06-27 12:52:55.693', N'KingSpec'),
(270, 'Corsair RM850e ATX 3.1 - 80 Plus Gold - Full Modular (850W)', 3500000, N'TDP: 0W', '/images/image/268_Corsair_RM850e_ATX_3.1_-_80_Plus_Gold_-_Full_Modul_main.jpg', 11, 97, '2026-06-27 12:52:56.192', N'Corsair'),
(271, 'Cooler Master MWE 650 - 80 Plus Bronze - V3 230V (650W)', 1500000, N'TDP: 0W', '/images/image/269_Cooler_Master_MWE_650_-_80_Plus_Bronze_-_V3_230V_(_main.jpg', 11, 100, '2026-06-27 12:52:56.68', N'Cooler Master'),
(272, N'Nguồn FSP HV PRO 650W - 80 Plus Bronze', 1400000, N'TDP: 0W', N'https://down-vn.img.susercontent.com/file/vn-11134211-820l4-mjf8qo64x91ha6', 11, 100, '2026-06-27 12:52:57.17', N'FSP'),
(273, 'Corsair CX650 - 80 Plus Bronze (650W)', 1600000, N'TDP: 0W', '/images/image/271_Corsair_CX650_-_80_Plus_Bronze_(650W)_main.jpg', 11, 100, '2026-06-27 12:52:57.668', N'Corsair'),
(274, 'Corsair 3500X TG Mid Tower Black', 2000000, N'TDP: 0W', '/images/image/272_Corsair_3500X_TG_Mid_Tower_Black_main.png', 12, 99, '2026-06-27 12:52:58.157', N'Corsair'),
(275, 'Corsair FRAME 4500X RS-R ARGB Panoramic Black', 3500000, N'TDP: 0W', '/images/image/273_Corsair_FRAME_4500X_RS-R_ARGB_Panoramic_Black_main.webp', 12, 98, '2026-06-27 12:52:58.657', N'Corsair'),
(276, N'Tản nhiệt AIO Corsair NAUTILUS 360 ARGB Black', 2800000, N'TDP: 15W', N'https://phucanhcdn.com/media/product/58804_tan_nhiet_nuoc_aio_corsair_nautilus_360_argb_black_cw_9060093_ww_2.jpg', 8, 97, '2026-06-27 12:52:59.35', N'Corsair'),
(277, 'Cooler Master Hyper 212 Spectrum V3 ARGB', 600000, N'TDP: 5W', '/images/image/275_Cooler_Master_Hyper_212_Spectrum_V3_ARGB_main.jpg', 8, 99, '2026-06-27 12:52:59.845', N'Cooler Master'),
(278, 'Intel Core i9 14900K (Tray)', 14000000, N'TDP: 125W', '/images/image/276_Intel_Core_i9_14900K_(Tray)_main.jpg', 1, 100, '2026-06-27 13:16:14.081', N'Intel'),
(279, 'Intel Core Ultra 9 285K', 16500000, N'TDP: 125W', '/images/image/277_Intel_Core_Ultra_9_285K_main.jpg', 1, 49, '2026-06-27 13:16:14.752', N'Intel'),
(280, 'ASUS ROG MAXIMUS Z790 HERO', 15000000, N'TDP: 60W', '/images/image/278_ASUS_ROG_MAXIMUS_Z790_HERO_main.jpg', 4, 100, '2026-06-27 13:16:16.445', N'ASUS'),
(281, 'ProArt Z790-CREATOR WIFI', 12000000, N'TDP: 55W', '/images/image/279_ProArt_Z790-CREATOR_WIFI_main.jpg', 4, 100, '2026-06-27 13:16:16.974', N'ASUS'),
(282, 'Corsair Dominator Titanium 64GB', 6500000, N'TDP: 15W', '/images/image/280_Corsair_Dominator_Titanium_64GB_main.jpg', 3, 100, '2026-06-27 13:16:18.101', N'Corsair'),
(283, 'G.Skill Trident Z5 64GB DDR5', 5500000, N'TDP: 15W', '/images/image/281_G.Skill_Trident_Z5_64GB_DDR5_main.png', 3, 100, '2026-06-27 13:16:18.602', N'G.Skill'),
(284, 'ASUS ROG Strix RTX 5090 24GB', 65000000, N'TDP: 450W', '/images/image/282_ASUS_ROG_Strix_RTX_5090_24GB_main.png', 9, 100, '2026-06-27 13:16:33.267', N'ASUS'),
(285, 'Samsung 990 PRO 2TB', 4500000, N'TDP: 15W', '/images/image/283_Samsung_990_PRO_2TB_main.jpg', 7, 100, '2026-06-27 13:16:34.196', N'Samsung'),
(286, 'ROG Ryujin III 360 ARGB', 8500000, N'TDP: 125W', '/images/image/284_ROG_Ryujin_III_360_ARGB_main.jpg', 8, 108, '2026-06-27 13:16:36.609', N'Intel'),
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
(1, 1, N'/images/products/i9_14900k.jpg', 1),
(2, 1, N'/images/products/ultra9_285k.jpg', 2),
(3, 2, N'/images/products/i9_14900k.jpg', 1),
(4, 3, N'/images/image/001_Intel_Core_i7-14700Kkk_sub1.jpg', 1),
(5, 3, N'/images/image/001_Intel_Core_i7-14700Kkk_sub2.png', 2),
(6, 3, N'/images/image/001_Intel_Core_i7-14700Kkk_sub3.jpg', 3),
(7, 4, N'/images/image/002_AMD_Ryzen_7_7800X3D_sub1.jpg', 1),
(8, 4, N'/images/image/002_AMD_Ryzen_7_7800X3D_sub2.png', 2),
(9, 4, N'/images/image/002_AMD_Ryzen_7_7800X3D_sub3.png', 3),
(10, 5, N'/images/image/003_Intel_Core_i5-13600K_sub1.jpg', 1),
(11, 5, N'/images/image/003_Intel_Core_i5-13600K_sub2.jpg', 2),
(12, 5, N'/images/image/003_Intel_Core_i5-13600K_sub3.jpg', 3),
(13, 6, N'/images/image/004_AMD_Ryzen_5_7600X_sub1.webp', 1),
(14, 6, N'/images/image/004_AMD_Ryzen_5_7600X_sub2.jpg', 2),
(15, 6, N'/images/image/004_AMD_Ryzen_5_7600X_sub3.jpg', 3),
(16, 7, N'/images/image/005_Intel_Core_i9-13900KS_sub1.jpeg', 1),
(17, 8, N'/images/image/006_AMD_Ryzen_9_7900X_sub1.jpg', 1),
(18, 8, N'/images/image/006_AMD_Ryzen_9_7900X_sub2.jpg', 2),
(19, 8, N'/images/image/006_AMD_Ryzen_9_7900X_sub3.jpg', 3),
(20, 9, N'/images/image/007_Intel_Core_i7-13700F_sub1.jpg', 1),
(21, 9, N'/images/image/007_Intel_Core_i7-13700F_sub2.png', 2),
(22, 9, N'/images/image/007_Intel_Core_i7-13700F_sub3.jpg', 3),
(23, 10, N'/images/image/008_AMD_Ryzen_7_5800X3D_sub1.jpg', 1),
(24, 10, N'/images/image/008_AMD_Ryzen_7_5800X3D_sub3.png', 3),
(25, 11, N'/images/image/009_Intel_Core_i5-12400F_sub1.jpg', 1),
(26, 11, N'/images/image/009_Intel_Core_i5-12400F_sub2.jpg', 2),
(27, 11, N'/images/image/009_Intel_Core_i5-12400F_sub3.jpg', 3),
(28, 12, N'/images/image/010_AMD_Ryzen_5_5600G_sub1.jpg', 1),
(29, 12, N'/images/image/010_AMD_Ryzen_5_5600G_sub2.jpg', 2),
(30, 12, N'/images/image/010_AMD_Ryzen_5_5600G_sub3.jpg', 3),
(31, 13, N'/images/image/011_Intel_Core_i3-14100_sub1.png', 1),
(32, 13, N'/images/image/011_Intel_Core_i3-14100_sub2.jpeg', 2),
(33, 13, N'/images/image/011_Intel_Core_i3-14100_sub3.jpg', 3),
(34, 14, N'/images/image/012_AMD_Ryzen_3_4100_sub1.jpg', 1),
(35, 14, N'/images/image/012_AMD_Ryzen_3_4100_sub2.jpg', 2),
(36, 14, N'/images/image/012_AMD_Ryzen_3_4100_sub3.jpg', 3),
(37, 15, N'/images/image/013_Intel_Core_i9-12900K_sub1.jpg', 1),
(38, 15, N'/images/image/013_Intel_Core_i9-12900K_sub2.jpg', 2),
(39, 15, N'/images/image/013_Intel_Core_i9-12900K_sub3.jpg', 3),
(40, 16, N'/images/image/014_Vỏ_máy_tính_Xigmatek_QUANTUM_4AF_sub1.png', 1),
(41, 16, N'/images/image/014_Vỏ_máy_tính_Xigmatek_QUANTUM_4AF_sub2.png', 2),
(42, 16, N'/images/image/014_Vỏ_máy_tính_Xigmatek_QUANTUM_4AF_sub3.jpg', 3),
(43, 17, N'/images/image/015_Intel_Core_i5-14400F_sub1.jpg', 1),
(44, 17, N'/images/image/015_Intel_Core_i5-14400F_sub2.jpg', 2),
(45, 17, N'/images/image/015_Intel_Core_i5-14400F_sub3.jpg', 3),
(46, 18, N'/images/image/016_AMD_Ryzen_5_8600G_sub1.jpg', 1),
(47, 18, N'/images/image/016_AMD_Ryzen_5_8600G_sub2.jpg', 2),
(48, 18, N'/images/image/016_AMD_Ryzen_5_8600G_sub3.jpg', 3),
(49, 19, N'/images/image/017_Intel_Core_i7-12700K_sub1.jpg', 1),
(50, 19, N'/images/image/017_Intel_Core_i7-12700K_sub2.jpg', 2),
(51, 19, N'/images/image/017_Intel_Core_i7-12700K_sub3.jpg', 3),
(52, 20, N'/images/image/018_AMD_Ryzen_7_7700_sub1.jpg', 1),
(53, 20, N'/images/image/018_AMD_Ryzen_7_7700_sub2.jpg', 2),
(54, 20, N'/images/image/018_AMD_Ryzen_7_7700_sub3.jpg', 3),
(55, 21, N'/images/image/019_Intel_Core_i5-11400F_sub1.jpg', 1),
(56, 21, N'/images/image/019_Intel_Core_i5-11400F_sub2.jpg', 2),
(57, 22, N'/images/image/020_AMD_Ryzen_5_4500_sub1.jpg', 1),
(58, 22, N'/images/image/020_AMD_Ryzen_5_4500_sub2.jpg', 2),
(59, 22, N'/images/image/020_AMD_Ryzen_5_4500_sub3.webp', 3),
(60, 23, N'/images/image/021_Intel_Core_i9-11900K_sub1.jpg', 1),
(61, 23, N'/images/image/021_Intel_Core_i9-11900K_sub2.jpg', 2),
(62, 23, N'/images/image/021_Intel_Core_i9-11900K_sub3.jpg', 3),
(63, 24, N'/images/image/022_AMD_Ryzen_5_3600_sub1.jpg', 1),
(64, 24, N'/images/image/022_AMD_Ryzen_5_3600_sub3.jpg', 3),
(65, 25, N'/images/image/023_Intel_Core_i5-10400F_sub1.jpg', 1),
(66, 25, N'/images/image/023_Intel_Core_i5-10400F_sub2.jpg', 2),
(67, 25, N'/images/image/023_Intel_Core_i5-10400F_sub3.jpg', 3),
(68, 26, N'/images/image/024_AMD_Ryzen_9_3900X_sub1.jpg', 1),
(69, 26, N'/images/image/024_AMD_Ryzen_9_3900X_sub2.jpg', 2),
(70, 26, N'/images/image/024_AMD_Ryzen_9_3900X_sub3.jpg', 3),
(71, 27, N'/images/image/025_Intel_Pentium_G7400_sub1.jpg', 1),
(72, 27, N'/images/image/025_Intel_Pentium_G7400_sub2.jpg', 2),
(73, 27, N'/images/image/025_Intel_Pentium_G7400_sub3.jpg', 3),
(74, 28, N'/images/image/026_AMD_Athlon_3000G_sub1.jpg', 1),
(75, 28, N'/images/image/026_AMD_Athlon_3000G_sub2.jpg', 2),
(76, 28, N'/images/image/026_AMD_Athlon_3000G_sub3.jpg', 3),
(77, 29, N'/images/image/027_Intel_Core_i7-10700K_sub1.jpg', 1),
(78, 29, N'/images/image/027_Intel_Core_i7-10700K_sub2.jpg', 2),
(79, 29, N'/images/image/027_Intel_Core_i7-10700K_sub3.jpg', 3),
(80, 30, N'/images/image/028_AMD_Ryzen_7_8700G_sub1.jpg', 1),
(81, 30, N'/images/image/028_AMD_Ryzen_7_8700G_sub3.jpg', 3),
(82, 31, N'/images/image/029_NVIDIA_RTX_4090_24GB_sub1.jpg', 1),
(83, 31, N'/images/image/029_NVIDIA_RTX_4090_24GB_sub2.jpg', 2),
(84, 31, N'/images/image/029_NVIDIA_RTX_4090_24GB_sub3.jpg', 3),
(85, 32, N'/images/image/030_RTX_4080_Super_sub1.webp', 1),
(86, 32, N'/images/image/030_RTX_4080_Super_sub2.jpg', 2),
(87, 32, N'/images/image/030_RTX_4080_Super_sub3.jpg', 3),
(88, 33, N'/images/image/031_RTX_4070_Ti_Super_sub2.jpg', 2),
(89, 33, N'/images/image/031_RTX_4070_Ti_Super_sub3.png', 3),
(90, 34, N'/images/image/032_AMD_RX_7900_XTX_sub1.jpg', 1),
(91, 34, N'/images/image/032_AMD_RX_7900_XTX_sub2.jpg', 2),
(92, 34, N'/images/image/032_AMD_RX_7900_XTX_sub3.jpg', 3),
(93, 35, N'/images/image/033_RTX_4060_Ti_8GB_sub1.jpg', 1),
(94, 35, N'/images/image/033_RTX_4060_Ti_8GB_sub2.jpg', 2),
(95, 35, N'/images/image/033_RTX_4060_Ti_8GB_sub3.jpg', 3),
(96, 36, N'/images/image/034_AMD_RX_7800_XT_sub1.jpg', 1),
(97, 36, N'/images/image/034_AMD_RX_7800_XT_sub3.jpg', 3),
(98, 37, N'/images/image/035_RTX_3060_12GB_sub1.jpg', 1),
(99, 37, N'/images/image/035_RTX_3060_12GB_sub2.jpg', 2),
(100, 37, N'/images/image/035_RTX_3060_12GB_sub3.jpg', 3),
(101, 38, N'/images/image/036_AMD_RX_6600_sub1.jpg', 1),
(102, 38, N'/images/image/036_AMD_RX_6600_sub2.jpg', 2),
(103, 38, N'/images/image/036_AMD_RX_6600_sub3.jpg', 3),
(104, 39, N'/images/image/037_ASUS_ROG_RTX_4090_sub1.png', 1),
(105, 39, N'/images/image/037_ASUS_ROG_RTX_4090_sub2.jpg', 2),
(106, 39, N'/images/image/037_ASUS_ROG_RTX_4090_sub3.jpg', 3),
(107, 40, N'/images/image/038_MSI_Gaming_X_RTX_4070_sub1.jpg', 1),
(108, 40, N'/images/image/038_MSI_Gaming_X_RTX_4070_sub2.jpg', 2),
(109, 40, N'/images/image/038_MSI_Gaming_X_RTX_4070_sub3.png', 3),
(110, 41, N'/images/image/039_Gigabyte_Eagle_RTX_4060_sub1.jpg', 1),
(111, 41, N'/images/image/039_Gigabyte_Eagle_RTX_4060_sub2.jpg', 2),
(112, 41, N'/images/image/039_Gigabyte_Eagle_RTX_4060_sub3.jpg', 3),
(113, 42, N'/images/image/040_RTX_4070_Super_sub1.jpg', 1),
(114, 42, N'/images/image/040_RTX_4070_Super_sub3.jpg', 3),
(115, 43, N'/images/image/041_AMD_RX_7600_sub1.jpg', 1),
(116, 43, N'/images/image/041_AMD_RX_7600_sub2.jpg', 2),
(117, 43, N'/images/image/041_AMD_RX_7600_sub3.jpg', 3),
(118, 44, N'/images/image/042_RTX_3050_6GB_sub2.jpg', 2),
(119, 44, N'/images/image/042_RTX_3050_6GB_sub3.jpg', 3),
(120, 45, N'/images/image/043_Zotac_RTX_4060_sub1.jpg', 1),
(121, 45, N'/images/image/043_Zotac_RTX_4060_sub2.jpg', 2),
(122, 46, N'/images/image/044_Galax_RTX_4070_Pink_sub3.jpg', 3),
(123, 47, N'/images/image/045_ASUS_TUF_RTX_3070_Ti_sub1.jpg', 1),
(124, 47, N'/images/image/045_ASUS_TUF_RTX_3070_Ti_sub2.jpg', 2),
(125, 47, N'/images/image/045_ASUS_TUF_RTX_3070_Ti_sub3.jpg', 3),
(126, 48, N'/images/image/046_EVGA_RTX_3080_sub1.jpg', 1),
(127, 48, N'/images/image/046_EVGA_RTX_3080_sub2.jpg', 2),
(128, 48, N'/images/image/046_EVGA_RTX_3080_sub3.jpeg', 3),
(129, 49, N'/images/image/047_Sapphire_RX_7900_GRE_sub1.jpg', 1),
(130, 49, N'/images/image/047_Sapphire_RX_7900_GRE_sub2.jpg', 2),
(131, 49, N'/images/image/047_Sapphire_RX_7900_GRE_sub3.jpg', 3),
(132, 50, N'/images/image/048_PowerColor_RX_7800_XT_sub1.jpg', 1),
(133, 50, N'/images/image/048_PowerColor_RX_7800_XT_sub2.jpg', 2),
(134, 50, N'/images/image/048_PowerColor_RX_7800_XT_sub3.jpg', 3),
(135, 51, N'/images/image/049_GTX_1650_sub1.jpg', 1),
(136, 51, N'/images/image/049_GTX_1650_sub2.jpg', 2),
(137, 51, N'/images/image/049_GTX_1650_sub3.jpg', 3),
(138, 52, N'/images/image/050_RX_6700_XT_sub1.jpg', 1),
(139, 52, N'/images/image/050_RX_6700_XT_sub2.jpg', 2),
(140, 53, N'/images/image/051_Colorful_RTX_4080_sub1.jpeg', 1),
(141, 53, N'/images/image/051_Colorful_RTX_4080_sub2.jpg', 2),
(142, 53, N'/images/image/051_Colorful_RTX_4080_sub3.jpg', 3),
(143, 54, N'/images/image/052_Quadro_RTX_A4000_sub1.jpg', 1),
(144, 54, N'/images/image/052_Quadro_RTX_A4000_sub2.webp', 2),
(145, 54, N'/images/image/052_Quadro_RTX_A4000_sub3.png', 3),
(146, 55, N'/images/image/053_Radeon_Pro_W7800_sub1.jpg', 1),
(147, 55, N'/images/image/053_Radeon_Pro_W7800_sub2.jpg', 2),
(148, 55, N'/images/image/053_Radeon_Pro_W7800_sub3.jpg', 3),
(149, 56, N'/images/image/054_Intel_Arc_A770_16GB_sub1.jpg', 1),
(150, 56, N'/images/image/054_Intel_Arc_A770_16GB_sub2.jpg', 2),
(151, 56, N'/images/image/054_Intel_Arc_A770_16GB_sub3.png', 3),
(152, 57, N'/images/image/055_Intel_Arc_A750_sub1.jpg', 1),
(153, 57, N'/images/image/055_Intel_Arc_A750_sub2.jpg', 2),
(154, 57, N'/images/image/055_Intel_Arc_A750_sub3.jpg', 3),
(155, 58, N'/images/image/056_ASUS_Dual_RTX_4070_sub2.jpg', 2),
(156, 58, N'/images/image/056_ASUS_Dual_RTX_4070_sub3.jpg', 3),
(157, 59, N'/images/image/057_Gigabyte_RTX_4090_sub1.jpg', 1),
(158, 60, N'/images/image/058_PNY_RTX_4060_sub1.png', 1),
(159, 60, N'/images/image/058_PNY_RTX_4060_sub2.jpg', 2),
(160, 60, N'/images/image/058_PNY_RTX_4060_sub3.jpg', 3),
(161, 61, N'/images/image/059_Corsair_Vengeance_32GB_sub1.jpg', 1),
(162, 61, N'/images/image/059_Corsair_Vengeance_32GB_sub2.jpg', 2),
(163, 61, N'/images/image/059_Corsair_Vengeance_32GB_sub3.jpg', 3),
(164, 62, N'/images/image/060_G.Skill_Trident_Z5_32GB_sub1.jpg', 1),
(165, 62, N'/images/image/060_G.Skill_Trident_Z5_32GB_sub2.jpg', 2),
(166, 62, N'/images/image/060_G.Skill_Trident_Z5_32GB_sub3.jpg', 3),
(167, 63, N'/images/image/061_Kingston_Fury_16GB_sub1.jpg', 1),
(168, 63, N'/images/image/061_Kingston_Fury_16GB_sub2.jpg', 2),
(169, 63, N'/images/image/061_Kingston_Fury_16GB_sub3.jpg', 3),
(170, 64, N'/images/image/062_T-Force_Delta_32GB_sub1.jpg', 1),
(171, 64, N'/images/image/062_T-Force_Delta_32GB_sub2.jpg', 2),
(172, 64, N'/images/image/062_T-Force_Delta_32GB_sub3.jpg', 3),
(173, 65, N'/images/image/063_ADATA_XPG_16GB_sub1.jpg', 1),
(174, 66, N'/images/image/064_Crucial_8GB_sub1.jpg', 1),
(175, 66, N'/images/image/064_Crucial_8GB_sub2.webp', 2),
(176, 66, N'/images/image/064_Crucial_8GB_sub3.jpg', 3),
(177, 67, N'/images/image/065_Dominator_Titanium_64GB_sub1.jpg', 1),
(178, 67, N'/images/image/065_Dominator_Titanium_64GB_sub2.jpg', 2),
(179, 67, N'/images/image/065_Dominator_Titanium_64GB_sub3.jpg', 3),
(180, 68, N'/images/image/066_Ripjaws_V_16GB_sub2.jpg', 2),
(181, 68, N'/images/image/066_Ripjaws_V_16GB_sub3.jpg', 3),
(182, 69, N'/images/image/067_Lexar_Thor_32GB_sub1.jpg', 1),
(183, 69, N'/images/image/067_Lexar_Thor_32GB_sub2.webp', 2),
(184, 69, N'/images/image/067_Lexar_Thor_32GB_sub3.jpg', 3),
(185, 70, N'/images/image/068_Fury_Renegade_32GB_sub1.jpg', 1),
(186, 70, N'/images/image/068_Fury_Renegade_32GB_sub2.jpg', 2),
(187, 70, N'/images/image/068_Fury_Renegade_32GB_sub3.webp', 3),
(188, 71, N'/images/image/069_PNY_XLR8_16GB_sub1.jpg', 1),
(189, 71, N'/images/image/069_PNY_XLR8_16GB_sub3.jpg', 3),
(190, 72, N'/images/image/070_Silicon_Power_16GB_sub1.jpg', 1),
(191, 72, N'/images/image/070_Silicon_Power_16GB_sub2.jpg', 2),
(192, 72, N'/images/image/070_Silicon_Power_16GB_sub3.jpg', 3),
(193, 73, N'/images/image/071_Mushkin_Redline_32GB_sub1.jpg', 1),
(194, 73, N'/images/image/071_Mushkin_Redline_32GB_sub2.jpg', 2),
(195, 74, N'/images/image/072_Patriot_Viper_16GB_sub1.jpg', 1),
(196, 74, N'/images/image/072_Patriot_Viper_16GB_sub2.jpeg', 2),
(197, 74, N'/images/image/072_Patriot_Viper_16GB_sub3.png', 3),
(198, 75, N'/images/image/073_Samsung_32GB_sub1.jpg', 1),
(199, 75, N'/images/image/073_Samsung_32GB_sub2.jpg', 2),
(200, 75, N'/images/image/073_Samsung_32GB_sub3.jpg', 3),
(201, 76, N'/images/image/074_Thermaltake_16GB_sub1.jpg', 1),
(202, 76, N'/images/image/074_Thermaltake_16GB_sub2.jpg', 2),
(203, 77, N'/images/image/075_Zadak_Spark_32GB_sub1.jpg', 1),
(204, 77, N'/images/image/075_Zadak_Spark_32GB_sub2.jpg', 2),
(205, 77, N'/images/image/075_Zadak_Spark_32GB_sub3.jpg', 3),
(206, 78, N'/images/image/076_Apacer_Panther_8GB_sub1.jpg', 1),
(207, 78, N'/images/image/076_Apacer_Panther_8GB_sub2.png', 2),
(208, 78, N'/images/image/076_Apacer_Panther_8GB_sub3.jpg', 3),
(209, 79, N'/images/image/077_GeIL_Super_Luce_16GB_sub2.jpg', 2),
(210, 79, N'/images/image/077_GeIL_Super_Luce_16GB_sub3.jpg', 3),
(211, 80, N'/images/image/078_V-Color_Prism_32GB_sub1.jpg', 1),
(212, 80, N'/images/image/078_V-Color_Prism_32GB_sub3.jpg', 3),
(213, 81, N'/images/image/079_Kingston_Fury_64GB_sub1.jpg', 1),
(214, 81, N'/images/image/079_Kingston_Fury_64GB_sub2.jpg', 2),
(215, 81, N'/images/image/079_Kingston_Fury_64GB_sub3.webp', 3),
(216, 82, N'/images/image/080_Vengeance_LPX_32GB_sub1.jpg', 1),
(217, 82, N'/images/image/080_Vengeance_LPX_32GB_sub2.webp', 2),
(218, 82, N'/images/image/080_Vengeance_LPX_32GB_sub3.jpg', 3),
(219, 83, N'/images/image/081_Trident_Z_Neo_32GB_sub1.png', 1),
(220, 83, N'/images/image/081_Trident_Z_Neo_32GB_sub2.jpg', 2),
(221, 83, N'/images/image/081_Trident_Z_Neo_32GB_sub3.jpg', 3),
(222, 84, N'/images/image/082_Team_Elite_16GB_sub1.jpg', 1),
(223, 84, N'/images/image/082_Team_Elite_16GB_sub2.jpg', 2),
(224, 84, N'/images/image/082_Team_Elite_16GB_sub3.jpg', 3),
(225, 85, N'/images/image/083_Crucial_Pro_32GB_sub1.png', 1),
(226, 85, N'/images/image/083_Crucial_Pro_32GB_sub2.webp', 2),
(227, 86, N'/images/image/084_Aorus_RGB_16GB_sub1.jpg', 1),
(228, 86, N'/images/image/084_Aorus_RGB_16GB_sub2.jpg', 2),
(229, 86, N'/images/image/084_Aorus_RGB_16GB_sub3.jpg', 3),
(230, 87, N'/images/image/085_Lexar_Ares_32GB_sub1.jpg', 1),
(231, 87, N'/images/image/085_Lexar_Ares_32GB_sub2.jpg', 2),
(232, 87, N'/images/image/085_Lexar_Ares_32GB_sub3.jpg', 3),
(233, 88, N'/images/image/086_Netac_Shadow_16GB_sub1.jpg', 1),
(234, 88, N'/images/image/086_Netac_Shadow_16GB_sub2.jpg', 2),
(235, 88, N'/images/image/086_Netac_Shadow_16GB_sub3.jpeg', 3),
(236, 89, N'/images/image/087_Galax_HOF_32GB_sub1.jpg', 1),
(237, 89, N'/images/image/087_Galax_HOF_32GB_sub2.jpeg', 2),
(238, 90, N'/images/image/088_Oloy_Blade_32GB_sub1.jpg', 1),
(239, 90, N'/images/image/088_Oloy_Blade_32GB_sub2.jpg', 2),
(240, 90, N'/images/image/088_Oloy_Blade_32GB_sub3.jpeg', 3),
(241, 91, N'/images/image/089_ROG_Maximus_Z790_Hero_sub1.png', 1),
(242, 91, N'/images/image/089_ROG_Maximus_Z790_Hero_sub2.jpg', 2),
(243, 91, N'/images/image/089_ROG_Maximus_Z790_Hero_sub3.jpg', 3),
(244, 92, N'/images/image/090_B760M_Mortar_WiFi_sub1.png', 1),
(245, 92, N'/images/image/090_B760M_Mortar_WiFi_sub2.png', 2),
(246, 93, N'/images/image/091_Z790_Aorus_Elite_sub2.jpg', 2),
(247, 93, N'/images/image/091_Z790_Aorus_Elite_sub3.jpg', 3),
(248, 94, N'/images/image/092_TUF_B650-Plus_sub1.jpg', 1),
(249, 94, N'/images/image/092_TUF_B650-Plus_sub2.png', 2),
(250, 94, N'/images/image/092_TUF_B650-Plus_sub3.jpg', 3),
(251, 95, N'/images/image/093_B660M_Pro_RS_sub1.png', 1),
(252, 95, N'/images/image/093_B660M_Pro_RS_sub2.jpg', 2),
(253, 95, N'/images/image/093_B660M_Pro_RS_sub3.png', 3),
(254, 96, N'/images/image/094_X670E_Carbon_WiFi_sub1.jpg', 1),
(255, 96, N'/images/image/094_X670E_Carbon_WiFi_sub3.jpg', 3),
(256, 97, N'/images/image/095_Prime_H610M-K_sub1.jpg', 1),
(257, 97, N'/images/image/095_Prime_H610M-K_sub2.jpg', 2),
(258, 98, N'/images/image/096_B450M_DS3H_sub1.jpg', 1),
(259, 98, N'/images/image/096_B450M_DS3H_sub2.jpg', 2),
(260, 98, N'/images/image/096_B450M_DS3H_sub3.jpg', 3),
(261, 99, N'/images/image/097_ROG_Strix_B760-I_sub1.jpg', 1),
(262, 99, N'/images/image/097_ROG_Strix_B760-I_sub2.png', 2),
(263, 99, N'/images/image/097_ROG_Strix_B760-I_sub3.png', 3),
(264, 100, N'/images/image/098_Z790_GODLIKE_sub1.png', 1),
(265, 100, N'/images/image/098_Z790_GODLIKE_sub2.png', 2),
(266, 100, N'/images/image/098_Z790_GODLIKE_sub3.png', 3),
(267, 101, N'/images/image/099_Z790_Taichi_sub1.jpg', 1),
(268, 101, N'/images/image/099_Z790_Taichi_sub2.jpg', 2),
(269, 101, N'/images/image/099_Z790_Taichi_sub3.jpg', 3),
(270, 102, N'/images/image/100_ProArt_Z790-Creator_sub1.png', 1),
(271, 102, N'/images/image/100_ProArt_Z790-Creator_sub2.png', 2),
(272, 102, N'/images/image/100_ProArt_Z790-Creator_sub3.png', 3),
(273, 104, N'/images/image/102_PRO_H610M-E_sub1.png', 1),
(274, 104, N'/images/image/102_PRO_H610M-E_sub3.png', 3),
(275, 105, N'/images/image/103_Crosshair_X670E_sub1.jpg', 1),
(276, 105, N'/images/image/103_Crosshair_X670E_sub2.png', 2),
(277, 105, N'/images/image/103_Crosshair_X670E_sub3.jpg', 3),
(278, 106, N'/images/image/104_Biostar_B760MZ_sub1.webp', 1),
(279, 106, N'/images/image/104_Biostar_B760MZ_sub3.jpg', 3),
(280, 107, N'/images/image/105_CVN_B760M_Frozen_sub1.webp', 1),
(281, 107, N'/images/image/105_CVN_B760M_Frozen_sub2.jpg', 2),
(282, 107, N'/images/image/105_CVN_B760M_Frozen_sub3.png', 3),
(283, 108, N'/images/image/106_A520M_S2H_sub1.jpg', 1),
(284, 108, N'/images/image/106_A520M_S2H_sub2.jpg', 2),
(285, 108, N'/images/image/106_A520M_S2H_sub3.jpg', 3),
(286, 109, N'/images/image/107_NZXT_N7_Z790_sub1.jpg', 1),
(287, 109, N'/images/image/107_NZXT_N7_Z790_sub2.png', 2),
(288, 109, N'/images/image/107_NZXT_N7_Z790_sub3.png', 3),
(289, 110, N'/images/image/108_A620M-HDV_sub1.jpg', 1),
(290, 110, N'/images/image/108_A620M-HDV_sub2.jpg', 2),
(291, 110, N'/images/image/108_A620M-HDV_sub3.jpg', 3),
(292, 111, N'/images/image/109_Z790_Dark_Kingpin_sub1.png', 1),
(293, 111, N'/images/image/109_Z790_Dark_Kingpin_sub2.jpg', 2),
(294, 111, N'/images/image/109_Z790_Dark_Kingpin_sub3.jpg', 3),
(295, 112, N'/images/image/110_X570S_Tomahawk_sub1.png', 1),
(296, 112, N'/images/image/110_X570S_Tomahawk_sub2.jpg', 2),
(297, 112, N'/images/image/110_X570S_Tomahawk_sub3.jpg', 3),
(298, 113, N'/images/image/111_A520M-Plus_sub1.png', 1),
(299, 113, N'/images/image/111_A520M-Plus_sub2.jpg', 2),
(300, 113, N'/images/image/111_A520M-Plus_sub3.jpg', 3),
(301, 114, N'/images/image/112_Z790_UD_sub1.jpg', 1),
(302, 114, N'/images/image/112_Z790_UD_sub2.jpg', 2),
(303, 114, N'/images/image/112_Z790_UD_sub3.jpg', 3),
(304, 115, N'/images/image/113_B550M_Steel_Legend_sub1.png', 1),
(305, 115, N'/images/image/113_B550M_Steel_Legend_sub2.png', 2),
(306, 115, N'/images/image/113_B550M_Steel_Legend_sub3.png', 3),
(307, 116, N'/images/image/114_MSI_B650_Gaming_sub1.png', 1),
(308, 116, N'/images/image/114_MSI_B650_Gaming_sub2.png', 2),
(309, 116, N'/images/image/114_MSI_B650_Gaming_sub3.jpg', 3),
(310, 117, N'/images/image/115_Prime_Z790-P_sub1.png', 1),
(311, 117, N'/images/image/115_Prime_Z790-P_sub2.jpg', 2),
(312, 117, N'/images/image/115_Prime_Z790-P_sub3.jpg', 3),
(313, 118, N'/images/image/116_H610M_S2H_sub2.jpg', 2),
(314, 118, N'/images/image/116_H610M_S2H_sub3.jpg', 3),
(315, 119, N'/images/image/117_X670E_Steel_Legend_sub1.jpg', 1),
(316, 119, N'/images/image/117_X670E_Steel_Legend_sub2.png', 2),
(317, 120, N'/images/image/118_Valkyrie_Z790_sub1.jpg', 1),
(318, 120, N'/images/image/118_Valkyrie_Z790_sub2.jpg', 2),
(319, 120, N'/images/image/118_Valkyrie_Z790_sub3.jpg', 3),
(320, 121, N'/images/image/119_Samsung_990_Pro_1T_sub1.jpg', 1),
(321, 121, N'/images/image/119_Samsung_990_Pro_1T_sub3.jpg', 3),
(322, 122, N'/images/image/120_Samsung_980_Pro_2T_sub1.jpg', 1),
(323, 122, N'/images/image/120_Samsung_980_Pro_2T_sub2.jpg', 2),
(324, 122, N'/images/image/120_Samsung_980_Pro_2T_sub3.jpg', 3),
(325, 123, N'/images/image/121_WD_SN850X_1TB_sub1.png', 1),
(326, 123, N'/images/image/121_WD_SN850X_1TB_sub2.jpg', 2),
(327, 123, N'/images/image/121_WD_SN850X_1TB_sub3.jpg', 3),
(328, 124, N'/images/image/122_Crucial_P3_Plus_1T_sub1.jpg', 1),
(329, 124, N'/images/image/122_Crucial_P3_Plus_1T_sub2.jpg', 2),
(330, 124, N'/images/image/122_Crucial_P3_Plus_1T_sub3.jpg', 3),
(331, 125, N'/images/image/123_Kingston_NV2_500G_sub1.jpg', 1),
(332, 125, N'/images/image/123_Kingston_NV2_500G_sub2.png', 2),
(333, 126, N'/images/image/124_Samsung_870_EVO_1T_sub1.jpg', 1),
(334, 126, N'/images/image/124_Samsung_870_EVO_1T_sub2.jpg', 2),
(335, 126, N'/images/image/124_Samsung_870_EVO_1T_sub3.jpg', 3),
(336, 127, N'/images/image/125_P41_Platinum_2T_sub1.jpg', 1),
(337, 127, N'/images/image/125_P41_Platinum_2T_sub2.jpg', 2),
(338, 127, N'/images/image/125_P41_Platinum_2T_sub3.jpg', 3),
(339, 128, N'/images/image/126_Lexar_NM790_2T_sub1.jpg', 1),
(340, 128, N'/images/image/126_Lexar_NM790_2T_sub2.png', 2),
(341, 128, N'/images/image/126_Lexar_NM790_2T_sub3.jpg', 3),
(342, 129, N'/images/image/127_Crucial_T700_1TB_sub1.jpg', 1),
(343, 129, N'/images/image/127_Crucial_T700_1TB_sub2.jpeg', 2),
(344, 130, N'/images/image/128_Aorus_Gen5_2TB_sub1.jpg', 1),
(345, 130, N'/images/image/128_Aorus_Gen5_2TB_sub3.jpg', 3),
(346, 131, N'/images/image/129_TeamGroup_MP33_1T_sub1.jpg', 1),
(347, 131, N'/images/image/129_TeamGroup_MP33_1T_sub3.jpg', 3),
(348, 132, N'/images/image/130_XPG_S70_Blade_1T_sub1.jpg', 1),
(349, 132, N'/images/image/130_XPG_S70_Blade_1T_sub2.jpg', 2),
(350, 132, N'/images/image/130_XPG_S70_Blade_1T_sub3.jpg', 3),
(351, 133, N'/images/image/131_SN580_1TB_sub1.jpg', 1),
(352, 133, N'/images/image/131_SN580_1TB_sub3.jpg', 3),
(353, 134, N'/images/image/132_FireCuda_530_2TB_sub1.jpg', 1),
(354, 134, N'/images/image/132_FireCuda_530_2TB_sub3.jpg', 3),
(355, 135, N'/images/image/133_Sabrent_Rocket_4TB_sub2.jpg', 2),
(356, 135, N'/images/image/133_Sabrent_Rocket_4TB_sub3.jpg', 3),
(357, 136, N'/images/image/134_970_EVO_Plus_2TB_sub1.jpg', 1),
(358, 136, N'/images/image/134_970_EVO_Plus_2TB_sub2.jpg', 2),
(359, 136, N'/images/image/134_970_EVO_Plus_2TB_sub3.png', 3),
(360, 137, N'/images/image/135_PNY_CS2241_1TB_sub1.png', 1),
(361, 137, N'/images/image/135_PNY_CS2241_1TB_sub2.jpg', 2),
(362, 137, N'/images/image/135_PNY_CS2241_1TB_sub3.jpeg', 3),
(363, 138, N'/images/image/136_Silicon_Power_UD90_1650000_sub1.jpg', 1),
(364, 138, N'/images/image/136_Silicon_Power_UD90_1650000_sub2.jpg', 2),
(365, 138, N'/images/image/136_Silicon_Power_UD90_1650000_sub3.jpg', 3),
(366, 139, N'/images/image/137_MP600_Pro_2TB_sub1.jpg', 1),
(367, 139, N'/images/image/137_MP600_Pro_2TB_sub2.jpg', 2),
(368, 139, N'/images/image/137_MP600_Pro_2TB_sub3.jpg', 3),
(369, 140, N'/images/image/138_KC3000_1TB_sub1.jpg', 1),
(370, 140, N'/images/image/138_KC3000_1TB_sub2.jpg', 2),
(371, 141, N'/images/image/139_Crucial_MX500_1TB_sub1.jpg', 1),
(372, 141, N'/images/image/139_Crucial_MX500_1TB_sub2.jpg', 2),
(373, 141, N'/images/image/139_Crucial_MX500_1TB_sub3.jpg', 3),
(374, 142, N'/images/image/140_SN350_480GB_sub1.webp', 1),
(375, 142, N'/images/image/140_SN350_480GB_sub2.jpg', 2),
(376, 143, N'/images/image/141_Spatium_M480_2TB_sub1.jpg', 1),
(377, 143, N'/images/image/141_Spatium_M480_2TB_sub2.jpg', 2),
(378, 143, N'/images/image/141_Spatium_M480_2TB_sub3.jpg', 3),
(379, 144, N'/images/image/142_Transcend_250S_1T_sub2.jpg', 2),
(380, 144, N'/images/image/142_Transcend_250S_1T_sub3.jpeg', 3),
(381, 145, N'/images/image/143_Viper_VP4300_2TB_sub1.jpg', 1),
(382, 145, N'/images/image/143_Viper_VP4300_2TB_sub2.jpg', 2),
(383, 145, N'/images/image/143_Viper_VP4300_2TB_sub3.jpg', 3),
(384, 146, N'/images/image/144_Lexar_NM620_512G_sub1.jpg', 1),
(385, 146, N'/images/image/144_Lexar_NM620_512G_sub2.jpg', 2),
(386, 146, N'/images/image/144_Lexar_NM620_512G_sub3.jpg', 3),
(387, 147, N'/images/image/145_Netac_N7000_2TB_sub1.jpg', 1),
(388, 147, N'/images/image/145_Netac_N7000_2TB_sub2.jpg', 2),
(389, 147, N'/images/image/145_Netac_N7000_2TB_sub3.jpg', 3),
(390, 148, N'/images/image/146_870_QVO_4TB_sub1.jpg', 1),
(391, 148, N'/images/image/146_870_QVO_4TB_sub2.jpg', 2),
(392, 148, N'/images/image/146_870_QVO_4TB_sub3.jpg', 3),
(393, 149, N'/images/image/147_Adata_SU650_240G_sub1.jpg', 1),
(394, 149, N'/images/image/147_Adata_SU650_240G_sub2.jpg', 2),
(395, 149, N'/images/image/147_Adata_SU650_240G_sub3.jpg', 3),
(396, 150, N'/images/image/148_Crucial_T705_2TB_sub1.jpg', 1),
(397, 150, N'/images/image/148_Crucial_T705_2TB_sub2.jpg', 2),
(398, 150, N'/images/image/148_Crucial_T705_2TB_sub3.jpg', 3),
(399, 151, N'/images/image/149_LG_27GR95QE_sub1.jpg', 1),
(400, 151, N'/images/image/149_LG_27GR95QE_sub2.jpg', 2),
(401, 151, N'/images/image/149_LG_27GR95QE_sub3.jpg', 3),
(402, 152, N'/images/image/150_Dell_U2723QE_sub1.webp', 1),
(403, 152, N'/images/image/150_Dell_U2723QE_sub2.webp', 2),
(404, 152, N'/images/image/150_Dell_U2723QE_sub3.webp', 3),
(405, 153, N'/images/image/151_VG249Q_sub1.jpg', 1),
(406, 153, N'/images/image/151_VG249Q_sub2.jpg', 2),
(407, 153, N'/images/image/151_VG249Q_sub3.jpg', 3),
(408, 154, N'/images/image/152_Odyssey_Neo_G8_sub1.jpg', 1),
(409, 154, N'/images/image/152_Odyssey_Neo_G8_sub2.jpg', 2),
(410, 154, N'/images/image/152_Odyssey_Neo_G8_sub3.jpg', 3),
(411, 155, N'/images/image/153_Gigabyte_M27Q_sub1.jpeg', 1),
(412, 155, N'/images/image/153_Gigabyte_M27Q_sub3.jpg', 3),
(413, 156, N'/images/image/154_AOC_24G2_sub1.jpg', 1),
(414, 156, N'/images/image/154_AOC_24G2_sub2.jpg', 2),
(415, 156, N'/images/image/154_AOC_24G2_sub3.jpg', 3),
(416, 157, N'/images/image/155_ViewSonic_VX2728_sub1.png', 1),
(417, 157, N'/images/image/155_ViewSonic_VX2728_sub2.jpg', 2),
(418, 157, N'/images/image/155_ViewSonic_VX2728_sub3.jpg', 3),
(419, 158, N'/images/image/156_MAG274QRF-QD_sub1.png', 1),
(420, 158, N'/images/image/156_MAG274QRF-QD_sub2.jpg', 2),
(421, 158, N'/images/image/156_MAG274QRF-QD_sub3.jpg', 3),
(422, 159, N'/images/image/157_AW3423DW_sub1.jpg', 1),
(423, 159, N'/images/image/157_AW3423DW_sub2.jpg', 2),
(424, 160, N'/images/image/158_BenQ_SW271C_sub1.jpg', 1),
(425, 160, N'/images/image/158_BenQ_SW271C_sub2.jpg', 2),
(426, 160, N'/images/image/158_BenQ_SW271C_sub3.jpg', 3),
(427, 161, N'/images/image/159_Samsung_M7_sub1.jpg', 1),
(428, 161, N'/images/image/159_Samsung_M7_sub2.jpg', 2),
(429, 161, N'/images/image/159_Samsung_M7_sub3.jpg', 3),
(430, 162, N'/images/image/160_LG_24MP60G_sub2.png', 2),
(431, 162, N'/images/image/160_LG_24MP60G_sub3.jpg', 3),
(432, 163, N'/images/image/161_Swift_PG42UQ_sub2.jpg', 2),
(433, 163, N'/images/image/161_Swift_PG42UQ_sub3.jpg', 3),
(434, 164, N'/images/image/162_Gigabyte_G24F_2_sub1.jpg', 1),
(435, 164, N'/images/image/162_Gigabyte_G24F_2_sub2.jpg', 2),
(436, 165, N'/images/image/163_HP_Z27k_G3_sub1.jpg', 1),
(437, 165, N'/images/image/163_HP_Z27k_G3_sub2.jpg', 2),
(438, 165, N'/images/image/163_HP_Z27k_G3_sub3.jpg', 3),
(439, 166, N'/images/image/164_Nitro_VG271U_sub1.jpg', 1),
(440, 166, N'/images/image/164_Nitro_VG271U_sub2.jpg', 2),
(441, 167, N'/images/image/165_Dell_S2721DGF_sub1.jpg', 1),
(442, 167, N'/images/image/165_Dell_S2721DGF_sub2.jpg', 2),
(443, 167, N'/images/image/165_Dell_S2721DGF_sub3.jpg', 3),
(444, 168, N'/images/image/166_LG_DualUp_sub1.jpg', 1),
(445, 168, N'/images/image/166_LG_DualUp_sub2.jpg', 2),
(446, 168, N'/images/image/166_LG_DualUp_sub3.jpg', 3),
(447, 169, N'/images/image/167_Odyssey_G5_sub1.jpg', 1),
(448, 169, N'/images/image/167_Odyssey_G5_sub2.jpg', 2),
(449, 169, N'/images/image/167_Odyssey_G5_sub3.jpg', 3),
(450, 170, N'/images/image/168_Legion_Y25-30_sub1.png', 1),
(451, 170, N'/images/image/168_Legion_Y25-30_sub2.png', 2),
(452, 170, N'/images/image/168_Legion_Y25-30_sub3.jpg', 3),
(453, 171, N'/images/image/169_ProArt_PA278QV_sub1.jpg', 1),
(454, 171, N'/images/image/169_ProArt_PA278QV_sub2.jpg', 2),
(455, 172, N'/images/image/170_HKC_ANT27TQC_sub1.jpg', 1),
(456, 172, N'/images/image/170_HKC_ANT27TQC_sub2.jpg', 2),
(457, 172, N'/images/image/170_HKC_ANT27TQC_sub3.jpg', 3),
(458, 173, N'/images/image/171_MSI_G2412_sub2.png', 2),
(459, 173, N'/images/image/171_MSI_G2412_sub3.jpg', 3),
(460, 174, N'/images/image/172_Dell_E2222H_sub1.jpg', 1),
(461, 174, N'/images/image/172_Dell_E2222H_sub2.png', 2),
(462, 174, N'/images/image/172_Dell_E2222H_sub3.png', 3),
(463, 175, N'/images/image/173_LG_29WP500_sub1.jpg', 1),
(464, 175, N'/images/image/173_LG_29WP500_sub2.jpg', 2),
(465, 175, N'/images/image/173_LG_29WP500_sub3.jpg', 3),
(466, 176, N'/images/image/174_Philips_242E1_sub1.jpg', 1),
(467, 176, N'/images/image/174_Philips_242E1_sub3.jpg', 3),
(468, 177, N'/images/image/175_AOC_CU34G2X_sub1.png', 1),
(469, 177, N'/images/image/175_AOC_CU34G2X_sub2.jpg', 2),
(470, 177, N'/images/image/175_AOC_CU34G2X_sub3.jpg', 3),
(471, 178, N'/images/image/176_Xeneon_Flex_sub2.jpg', 2),
(472, 178, N'/images/image/176_Xeneon_Flex_sub3.webp', 3),
(473, 179, N'/images/image/177_Zowie_XL2546K_sub1.png', 1),
(474, 179, N'/images/image/177_Zowie_XL2546K_sub2.jpg', 2),
(475, 179, N'/images/image/177_Zowie_XL2546K_sub3.jpg', 3),
(476, 180, N'/images/image/178_Xiaomi_Mi_34_sub1.jpg', 1),
(477, 180, N'/images/image/178_Xiaomi_Mi_34_sub2.jpg', 2),
(478, 180, N'/images/image/178_Xiaomi_Mi_34_sub3.jpg', 3),
(479, 181, N'/images/image/179_Intel_Arc_A770_Limited_Edition_GPU_sub1.png', 1),
(480, 181, N'/images/image/179_Intel_Arc_A770_Limited_Edition_GPU_sub2.jpg', 2),
(481, 181, N'/images/image/179_Intel_Arc_A770_Limited_Edition_GPU_sub3.jpg', 3),
(482, 182, N'/images/image/180_Intel_Arc_A750_Graphics_Card_sub1.jpg', 1),
(483, 182, N'/images/image/180_Intel_Arc_A750_Graphics_Card_sub2.png', 2),
(484, 182, N'/images/image/180_Intel_Arc_A750_Graphics_Card_sub3.png', 3),
(485, 183, N'/images/image/181_Intel_Arc_A580_Graphics_Card_sub1.jpg', 1),
(486, 183, N'/images/image/181_Intel_Arc_A580_Graphics_Card_sub2.jpg', 2),
(487, 184, N'/images/image/182_AMD_Radeon_RX_7900_XT_GPU_sub1.png', 1),
(488, 184, N'/images/image/182_AMD_Radeon_RX_7900_XT_GPU_sub2.jpg', 2),
(489, 184, N'/images/image/182_AMD_Radeon_RX_7900_XT_GPU_sub3.png', 3),
(490, 185, N'/images/image/183_AMD_Radeon_RX_7800_XT_GPU_sub1.jpg', 1),
(491, 185, N'/images/image/183_AMD_Radeon_RX_7800_XT_GPU_sub2.png', 2),
(492, 185, N'/images/image/183_AMD_Radeon_RX_7800_XT_GPU_sub3.jpg', 3),
(493, 186, N'/images/image/184_AMD_Ryzen_5_5600X_Desktop_Processor_sub1.jpg', 1),
(494, 186, N'/images/image/184_AMD_Ryzen_5_5600X_Desktop_Processor_sub2.png', 2),
(495, 186, N'/images/image/184_AMD_Ryzen_5_5600X_Desktop_Processor_sub3.png', 3),
(496, 187, N'/images/image/185_ASUS_ROG_Maximus_Z790_Dark_Hero_sub1.png', 1),
(497, 187, N'/images/image/185_ASUS_ROG_Maximus_Z790_Dark_Hero_sub2.jpg', 2),
(498, 187, N'/images/image/185_ASUS_ROG_Maximus_Z790_Dark_Hero_sub3.jpg', 3),
(499, 188, N'/images/image/186_ASUS_ROG_Strix_X670E-E_Gaming_WiFi_sub1.png', 1),
(500, 188, N'/images/image/186_ASUS_ROG_Strix_X670E-E_Gaming_WiFi_sub2.png', 2),
(501, 188, N'/images/image/186_ASUS_ROG_Strix_X670E-E_Gaming_WiFi_sub3.png', 3),
(502, 189, N'/images/image/187_ASUS_ROG_Strix_GeForce_RTX_4090_OC_Edition_sub1.jpg', 1),
(503, 189, N'/images/image/187_ASUS_ROG_Strix_GeForce_RTX_4090_OC_Edition_sub2.jpg', 2),
(504, 189, N'/images/image/187_ASUS_ROG_Strix_GeForce_RTX_4090_OC_Edition_sub3.png', 3),
(505, 190, N'/images/image/188_ASUS_ROG_Swift_OLED_PG32UCDM_sub1.jpg', 1),
(506, 190, N'/images/image/188_ASUS_ROG_Swift_OLED_PG32UCDM_sub2.png', 2),
(507, 190, N'/images/image/188_ASUS_ROG_Swift_OLED_PG32UCDM_sub3.jpg', 3),
(508, 191, N'/images/image/189_ASUS_ROG_Ryujin_III_360_ARGB_sub1.jpg', 1),
(509, 191, N'/images/image/189_ASUS_ROG_Ryujin_III_360_ARGB_sub2.jpg', 2),
(510, 192, N'/images/image/190_ASUS_ROG_Thor_1200W_Platinum_II_sub1.jpg', 1),
(511, 192, N'/images/image/190_ASUS_ROG_Thor_1200W_Platinum_II_sub2.jpg', 2),
(512, 192, N'/images/image/190_ASUS_ROG_Thor_1200W_Platinum_II_sub3.jpeg', 3),
(513, 193, N'/images/image/191_MSI_MEG_Z790_GODLIKE_MAX_sub1.jpg', 1),
(514, 193, N'/images/image/191_MSI_MEG_Z790_GODLIKE_MAX_sub2.jpg', 2),
(515, 193, N'/images/image/191_MSI_MEG_Z790_GODLIKE_MAX_sub3.jpg', 3),
(516, 194, N'/images/image/192_MSI_MAG_B650_TOMAHAWK_WIFI_sub1.webp', 1),
(517, 194, N'/images/image/192_MSI_MAG_B650_TOMAHAWK_WIFI_sub2.webp', 2),
(518, 194, N'/images/image/192_MSI_MAG_B650_TOMAHAWK_WIFI_sub3.webp', 3),
(519, 195, N'/images/image/193_MSI_GeForce_RTX_4080_SUPER_16G_GAMING_X_SLIM_sub1.jpg', 1),
(520, 195, N'/images/image/193_MSI_GeForce_RTX_4080_SUPER_16G_GAMING_X_SLIM_sub2.png', 2),
(521, 196, N'/images/image/194_MSI_MPG_271QRX_QD-OLED_sub1.jpg', 1),
(522, 196, N'/images/image/194_MSI_MPG_271QRX_QD-OLED_sub2.webp', 2),
(523, 196, N'/images/image/194_MSI_MPG_271QRX_QD-OLED_sub3.jpg', 3),
(524, 197, N'/images/image/195_MSI_MEG_MAESTRO_700L_PZ_sub1.png', 1),
(525, 197, N'/images/image/195_MSI_MEG_MAESTRO_700L_PZ_sub2.png', 2),
(526, 197, N'/images/image/195_MSI_MEG_MAESTRO_700L_PZ_sub3.jpg', 3),
(527, 198, N'/images/image/196_MSI_MAG_CORELIQUID_I360_sub1.jpg', 1),
(528, 198, N'/images/image/196_MSI_MAG_CORELIQUID_I360_sub2.jpg', 2),
(529, 198, N'/images/image/196_MSI_MAG_CORELIQUID_I360_sub3.jpg', 3),
(530, 199, N'/images/image/197_MSI_SPATIUM_M570_PCIe_5.0_NVMe_M.2_HS_sub1.webp', 1),
(531, 199, N'/images/image/197_MSI_SPATIUM_M570_PCIe_5.0_NVMe_M.2_HS_sub2.jpg', 2),
(532, 199, N'/images/image/197_MSI_SPATIUM_M570_PCIe_5.0_NVMe_M.2_HS_sub3.jpg', 3),
(533, 201, N'/images/image/199_Gigabyte_X670E_AORUS_MASTER_sub2.jpg', 2),
(534, 201, N'/images/image/199_Gigabyte_X670E_AORUS_MASTER_sub3.jpg', 3),
(535, 202, N'/images/image/200_Gigabyte_M27Q_Gaming_Monitor_sub1.jpeg', 1),
(536, 202, N'/images/image/200_Gigabyte_M27Q_Gaming_Monitor_sub2.jpg', 2),
(537, 203, N'/images/image/201_Gigabyte_AORUS_FO32U2P_sub1.jpg', 1),
(538, 203, N'/images/image/201_Gigabyte_AORUS_FO32U2P_sub2.jpg', 2),
(539, 203, N'/images/image/201_Gigabyte_AORUS_FO32U2P_sub3.jpg', 3),
(540, 204, N'/images/image/202_Gigabyte_AORUS_Gen5_12000_SSD_2TB_sub2.jpg', 2),
(541, 204, N'/images/image/202_Gigabyte_AORUS_Gen5_12000_SSD_2TB_sub3.webp', 3),
(542, 205, N'/images/image/203_Gigabyte_UD1000GM_PG5_(Rev_2.0)_sub1.png', 1),
(543, 205, N'/images/image/203_Gigabyte_UD1000GM_PG5_(Rev_2.0)_sub2.png', 2),
(544, 206, N'/images/image/204_Gigabyte_AORUS_C500_GLASS_sub3.png', 3),
(545, 207, N'/images/image/205_Corsair_Dominator_Titanium_RGB_DDR5_32GB_(2x16GB)6_sub1.jpg', 1),
(546, 207, N'/images/image/205_Corsair_Dominator_Titanium_RGB_DDR5_32GB_(2x16GB)6_sub2.jpg', 2),
(547, 207, N'/images/image/205_Corsair_Dominator_Titanium_RGB_DDR5_32GB_(2x16GB)6_sub3.jpg', 3),
(548, 208, N'/images/image/206_Corsair_Vengeance_RGB_DDR5_64GB_(2x32GB)5600MHz_sub1.jpg', 1),
(549, 208, N'/images/image/206_Corsair_Vengeance_RGB_DDR5_64GB_(2x32GB)5600MHz_sub2.jpg', 2),
(550, 208, N'/images/image/206_Corsair_Vengeance_RGB_DDR5_64GB_(2x32GB)5600MHz_sub3.jpg', 3),
(551, 209, N'/images/image/207_Corsair_iCUE_LINK_H150i_LCD_Liquid_CPU_Cooler_sub2.webp', 2),
(552, 209, N'/images/image/207_Corsair_iCUE_LINK_H150i_LCD_Liquid_CPU_Cooler_sub3.webp', 3),
(553, 210, N'/images/image/208_Corsair_5000D_AIRFLOW_Tempered_Glass_Mid-Tower_sub1.webp', 1),
(554, 210, N'/images/image/208_Corsair_5000D_AIRFLOW_Tempered_Glass_Mid-Tower_sub2.jpg', 2),
(555, 211, N'/images/image/209_Corsair_iCUE_LINK_6500X_RGB_Mid-Tower_DualChamber_sub1.webp', 1),
(556, 211, N'/images/image/209_Corsair_iCUE_LINK_6500X_RGB_Mid-Tower_DualChamber_sub2.jpg', 2),
(557, 211, N'/images/image/209_Corsair_iCUE_LINK_6500X_RGB_Mid-Tower_DualChamber_sub3.jpg', 3),
(558, 212, N'/images/image/210_Corsair_RM1000x_Shift_Fully_Modular_ATX_PSU_sub1.jpg', 1),
(559, 212, N'/images/image/210_Corsair_RM1000x_Shift_Fully_Modular_ATX_PSU_sub2.jpg', 2),
(560, 212, N'/images/image/210_Corsair_RM1000x_Shift_Fully_Modular_ATX_PSU_sub3.jpg', 3),
(561, 213, N'/images/image/211_Corsair_AX1600i_Digital_ATX_Power_Supply_sub1.jpg', 1),
(562, 213, N'/images/image/211_Corsair_AX1600i_Digital_ATX_Power_Supply_sub2.webp', 2),
(563, 213, N'/images/image/211_Corsair_AX1600i_Digital_ATX_Power_Supply_sub3.jpg', 3),
(564, 214, N'/images/image/212_Corsair_K100_RGB_Mechanical_Gaming_Keyboard_sub1.jpg', 1),
(565, 214, N'/images/image/212_Corsair_K100_RGB_Mechanical_Gaming_Keyboard_sub2.jpg', 2),
(566, 214, N'/images/image/212_Corsair_K100_RGB_Mechanical_Gaming_Keyboard_sub3.jpg', 3),
(567, 215, N'/images/image/213_Corsair_Darkstar_Wireless_MMO_Gaming_Mouse_sub1.png', 1),
(568, 215, N'/images/image/213_Corsair_Darkstar_Wireless_MMO_Gaming_Mouse_sub2.webp', 2),
(569, 215, N'/images/image/213_Corsair_Darkstar_Wireless_MMO_Gaming_Mouse_sub3.webp', 3),
(570, 216, N'/images/image/214_Corsair_Virtuoso_RGB_Wireless_XT_Headset_sub1.jpeg', 1),
(571, 216, N'/images/image/214_Corsair_Virtuoso_RGB_Wireless_XT_Headset_sub2.jpg', 2),
(572, 216, N'/images/image/214_Corsair_Virtuoso_RGB_Wireless_XT_Headset_sub3.jpg', 3),
(573, 217, N'/images/image/215_Logitech_G_Pro_X_Superlight_2_Wireless_GamingMouse_sub1.png', 1),
(574, 217, N'/images/image/215_Logitech_G_Pro_X_Superlight_2_Wireless_GamingMouse_sub2.png', 2),
(575, 217, N'/images/image/215_Logitech_G_Pro_X_Superlight_2_Wireless_GamingMouse_sub3.png', 3),
(576, 218, N'/images/image/216_Logitech_G502_X_LIGHTSPEED_Wireless_GamingMouse_sub1.jpg', 1),
(577, 218, N'/images/image/216_Logitech_G502_X_LIGHTSPEED_Wireless_GamingMouse_sub2.jpg', 2),
(578, 218, N'/images/image/216_Logitech_G502_X_LIGHTSPEED_Wireless_GamingMouse_sub3.jpg', 3),
(579, 219, N'/images/image/217_Logitech_G915_TKL_Wireless_Mechanical_Keyboard_sub1.jpg', 1),
(580, 219, N'/images/image/217_Logitech_G915_TKL_Wireless_Mechanical_Keyboard_sub2.png', 2),
(581, 219, N'/images/image/217_Logitech_G915_TKL_Wireless_Mechanical_Keyboard_sub3.jpg', 3),
(582, 220, N'/images/image/218_Logitech_G_Pro_X_TKL_LIGHTSPEED_Gaming_Keyboard_sub1.jpg', 1),
(583, 220, N'/images/image/218_Logitech_G_Pro_X_TKL_LIGHTSPEED_Gaming_Keyboard_sub2.png', 2),
(584, 220, N'/images/image/218_Logitech_G_Pro_X_TKL_LIGHTSPEED_Gaming_Keyboard_sub3.png', 3),
(585, 221, N'/images/image/219_Logitech_G_Pro_X_2_LIGHTSPEED_Wireless_Headset_sub1.jpg', 1),
(586, 221, N'/images/image/219_Logitech_G_Pro_X_2_LIGHTSPEED_Wireless_Headset_sub2.jpg', 2),
(587, 221, N'/images/image/219_Logitech_G_Pro_X_2_LIGHTSPEED_Wireless_Headset_sub3.jpg', 3),
(588, 222, N'/images/image/220_Logitech_MX_Master_3S_Wireless_Mouse_sub2.jpg', 2),
(589, 222, N'/images/image/220_Logitech_MX_Master_3S_Wireless_Mouse_sub3.jpg', 3),
(590, 223, N'/images/image/221_Logitech_MX_Keys_S_Wireless_Keyboard_sub1.jpg', 1),
(591, 223, N'/images/image/221_Logitech_MX_Keys_S_Wireless_Keyboard_sub2.jpg', 2),
(592, 223, N'/images/image/221_Logitech_MX_Keys_S_Wireless_Keyboard_sub3.jpg', 3),
(593, 224, N'/images/image/222_Razer_Viper_V3_Pro_Wireless_Gaming_Mouse_sub1.jpg', 1),
(594, 224, N'/images/image/222_Razer_Viper_V3_Pro_Wireless_Gaming_Mouse_sub2.jpg', 2),
(595, 224, N'/images/image/222_Razer_Viper_V3_Pro_Wireless_Gaming_Mouse_sub3.jpg', 3),
(596, 225, N'/images/image/223_Razer_DeathAdder_V3_Pro_Wireless_Gaming_Mouse_sub1.png', 1),
(597, 225, N'/images/image/223_Razer_DeathAdder_V3_Pro_Wireless_Gaming_Mouse_sub2.jpg', 2),
(598, 225, N'/images/image/223_Razer_DeathAdder_V3_Pro_Wireless_Gaming_Mouse_sub3.png', 3),
(599, 226, N'/images/image/224_Razer_Huntsman_V3_Pro_TKL_Mechanical_Keyboard_sub1.jpg', 1),
(600, 226, N'/images/image/224_Razer_Huntsman_V3_Pro_TKL_Mechanical_Keyboard_sub2.jpg', 2),
(601, 226, N'/images/image/224_Razer_Huntsman_V3_Pro_TKL_Mechanical_Keyboard_sub3.jpg', 3),
(602, 227, N'/images/image/225_Razer_BlackWidow_V4_Pro_Mechanical_GamingKeyboard_sub1.jpg', 1),
(603, 227, N'/images/image/225_Razer_BlackWidow_V4_Pro_Mechanical_GamingKeyboard_sub3.jpg', 3),
(604, 228, N'/images/image/226_Razer_BlackShark_V2_Pro_(2023_Edition)_WirelessHea_sub1.jpg', 1),
(605, 228, N'/images/image/226_Razer_BlackShark_V2_Pro_(2023_Edition)_WirelessHea_sub3.jpg', 3),
(606, 229, N'/images/image/227_Samsung_990_PRO_PCIe_4.0_NVMe_M.2_SSD_2TB_sub1.jpg', 1),
(607, 229, N'/images/image/227_Samsung_990_PRO_PCIe_4.0_NVMe_M.2_SSD_2TB_sub2.jpg', 2),
(608, 229, N'/images/image/227_Samsung_990_PRO_PCIe_4.0_NVMe_M.2_SSD_2TB_sub3.jpg', 3),
(609, 230, N'/images/image/228_Samsung_990_EVO_PCIe_4.0_x4_5.0_x2_M.2_SSD_1TB_sub1.jpg', 1),
(610, 230, N'/images/image/228_Samsung_990_EVO_PCIe_4.0_x4_5.0_x2_M.2_SSD_1TB_sub2.jpg', 2),
(611, 230, N'/images/image/228_Samsung_990_EVO_PCIe_4.0_x4_5.0_x2_M.2_SSD_1TB_sub3.jpg', 3),
(612, 231, N'/images/image/229_Samsung_T7_Shield_Portable_SSD_2TB_sub1.jpg', 1),
(613, 231, N'/images/image/229_Samsung_T7_Shield_Portable_SSD_2TB_sub2.webp', 2),
(614, 231, N'/images/image/229_Samsung_T7_Shield_Portable_SSD_2TB_sub3.jpg', 3),
(615, 232, N'/images/image/230_Samsung_Odyssey_OLED_G9_(G95SC)_Gaming_Monitor_sub1.jpg', 1),
(616, 232, N'/images/image/230_Samsung_Odyssey_OLED_G9_(G95SC)_Gaming_Monitor_sub2.jpg', 2),
(617, 232, N'/images/image/230_Samsung_Odyssey_OLED_G9_(G95SC)_Gaming_Monitor_sub3.jpg', 3),
(618, 233, N'/images/image/231_Samsung_Odyssey_Ark_Gen_2_Mini-LED_Monitor_sub1.jpg', 1),
(619, 233, N'/images/image/231_Samsung_Odyssey_Ark_Gen_2_Mini-LED_Monitor_sub2.jpg', 2),
(620, 233, N'/images/image/231_Samsung_Odyssey_Ark_Gen_2_Mini-LED_Monitor_sub3.webp', 3),
(621, 234, N'/images/image/232_Samsung_Galaxy_Buds3_Pro_sub1.jpg', 1),
(622, 234, N'/images/image/232_Samsung_Galaxy_Buds3_Pro_sub2.jpg', 2),
(623, 234, N'/images/image/232_Samsung_Galaxy_Buds3_Pro_sub3.jpg', 3),
(624, 235, N'/images/image/233_Kingston_FURY_Renegade_DDR5_RGB_32GB_(2x16GB)_7200_sub1.jpg', 1),
(625, 235, N'/images/image/233_Kingston_FURY_Renegade_DDR5_RGB_32GB_(2x16GB)_7200_sub2.jpg', 2),
(626, 235, N'/images/image/233_Kingston_FURY_Renegade_DDR5_RGB_32GB_(2x16GB)_7200_sub3.jpg', 3),
(627, 236, N'/images/image/234_Kingston_FURY_Beast_DDR5_32GB_(2x16GB)_6000MHz_sub1.jpg', 1),
(628, 236, N'/images/image/234_Kingston_FURY_Beast_DDR5_32GB_(2x16GB)_6000MHz_sub2.png', 2),
(629, 236, N'/images/image/234_Kingston_FURY_Beast_DDR5_32GB_(2x16GB)_6000MHz_sub3.jpg', 3),
(630, 237, N'/images/image/235_Kingston_KC3000_PCIe_4.0_NVMe_M.2_SSD_2TB_sub1.jpg', 1),
(631, 237, N'/images/image/235_Kingston_KC3000_PCIe_4.0_NVMe_M.2_SSD_2TB_sub3.jpg', 3),
(632, 238, N'/images/image/236_Kingston_NV2_PCIe_4.0_NVMe_M.2_SSD_1TB_sub2.jpg', 2),
(633, 238, N'/images/image/236_Kingston_NV2_PCIe_4.0_NVMe_M.2_SSD_1TB_sub3.jpg', 3),
(634, 239, N'/images/image/237_Kingston_FURY_Impact_DDR5_SO-DIMM_32GB_(2x16GB)_56_sub2.jpg', 2),
(635, 239, N'/images/image/237_Kingston_FURY_Impact_DDR5_SO-DIMM_32GB_(2x16GB)_56_sub3.jpg', 3),
(636, 240, N'/images/image/238_WD_Red_Pro_NAS_Internal_Hard_Drive_12TB_sub1.jpg', 1),
(637, 240, N'/images/image/238_WD_Red_Pro_NAS_Internal_Hard_Drive_12TB_sub2.jpg', 2),
(638, 240, N'/images/image/238_WD_Red_Pro_NAS_Internal_Hard_Drive_12TB_sub3.jpg', 3),
(639, 241, N'/images/image/239_Seagate_IronWolf_Pro_16TB_NAS_HDD_sub3.jpg', 3),
(640, 242, N'/images/image/240_Noctua_NH-D15_chromax.black_Dual-Tower_Cooler_sub1.jpg', 1),
(641, 242, N'/images/image/240_Noctua_NH-D15_chromax.black_Dual-Tower_Cooler_sub2.jpeg', 2),
(642, 243, N'/images/image/241_NZXT_H9_Flow_Dual-Chamber_Mid-Tower_sub1.jpg', 1),
(643, 243, N'/images/image/241_NZXT_H9_Flow_Dual-Chamber_Mid-Tower_sub2.jpg', 2),
(644, 243, N'/images/image/241_NZXT_H9_Flow_Dual-Chamber_Mid-Tower_sub3.jpg', 3),
(645, 244, N'/images/image/242_NZXT_Kraken_Elite_360_RGB_Liquid_Cooler_sub1.jpg', 1),
(646, 244, N'/images/image/242_NZXT_Kraken_Elite_360_RGB_Liquid_Cooler_sub2.jpg', 2),
(647, 244, N'/images/image/242_NZXT_Kraken_Elite_360_RGB_Liquid_Cooler_sub3.jpg', 3),
(648, 245, N'/images/image/243_SteelSeries_Arctis_Nova_Pro_Wireless_Headset_sub1.png', 1),
(649, 245, N'/images/image/243_SteelSeries_Arctis_Nova_Pro_Wireless_Headset_sub2.jpg', 2),
(650, 245, N'/images/image/243_SteelSeries_Arctis_Nova_Pro_Wireless_Headset_sub3.jpg', 3),
(651, 246, N'/images/image/244_BenQ_ZOWIE_XL2566K_360Hz_Esports_Gaming_Monitor_sub1.jpeg', 1),
(652, 246, N'/images/image/244_BenQ_ZOWIE_XL2566K_360Hz_Esports_Gaming_Monitor_sub2.jpg', 2),
(653, 246, N'/images/image/244_BenQ_ZOWIE_XL2566K_360Hz_Esports_Gaming_Monitor_sub3.jpg', 3),
(654, 247, N'/images/image/245_Sony_WH-1000XM5_Wireless_Noise_CancelingHeadphones_sub1.jpg', 1),
(655, 247, N'/images/image/245_Sony_WH-1000XM5_Wireless_Noise_CancelingHeadphones_sub2.webp', 2),
(656, 247, N'/images/image/245_Sony_WH-1000XM5_Wireless_Noise_CancelingHeadphones_sub3.jpeg', 3),
(657, 248, N'/images/image/246_Crucial_Pro_DDR5_48GB_(2x24GB)_5600MHz_Kit_sub2.jpg', 2),
(658, 248, N'/images/image/246_Crucial_Pro_DDR5_48GB_(2x24GB)_5600MHz_Kit_sub3.png', 3),
(659, 249, N'/images/image/247_Fractal_Design_North_Charcoal_Black_WoodMid-Tower_sub1.jpg', 1),
(660, 249, N'/images/image/247_Fractal_Design_North_Charcoal_Black_WoodMid-Tower_sub2.jpg', 2),
(661, 249, N'/images/image/247_Fractal_Design_North_Charcoal_Black_WoodMid-Tower_sub3.jpg', 3),
(662, 250, N'/images/image/248_Lian_Li_O11_Dynamic_EVO_RGB_Black_sub1.jpg', 1),
(663, 250, N'/images/image/248_Lian_Li_O11_Dynamic_EVO_RGB_Black_sub2.webp', 2),
(664, 250, N'/images/image/248_Lian_Li_O11_Dynamic_EVO_RGB_Black_sub3.jpg', 3),
(665, 251, N'/images/image/249_Lian_Li_UNI_FAN_TL_LCD_120_Triple_Pack_Black_sub2.jpg', 2),
(666, 251, N'/images/image/249_Lian_Li_UNI_FAN_TL_LCD_120_Triple_Pack_Black_sub3.jpg', 3),
(667, 252, N'/images/image/250_EVGA_SuperNOVA_1000_G7_Gold_Modular_PSU_sub1.jpg', 1),
(668, 252, N'/images/image/250_EVGA_SuperNOVA_1000_G7_Gold_Modular_PSU_sub2.jpg', 2),
(669, 252, N'/images/image/250_EVGA_SuperNOVA_1000_G7_Gold_Modular_PSU_sub3.jpg', 3),
(670, 253, N'/images/image/251_DeepCool_AK620_Digital_Dual-Tower_Air_Cooler_sub1.jpg', 1),
(671, 253, N'/images/image/251_DeepCool_AK620_Digital_Dual-Tower_Air_Cooler_sub2.jpg', 2),
(672, 254, N'/images/image/252_Thermalright_Peerless_Assassin_120_SE_AirCooler_sub1.jpg', 1),
(673, 254, N'/images/image/252_Thermalright_Peerless_Assassin_120_SE_AirCooler_sub2.jpg', 2),
(674, 254, N'/images/image/252_Thermalright_Peerless_Assassin_120_SE_AirCooler_sub3.png', 3),
(675, 255, N'/images/image/253_Be_Quiet!_Dark_Power_13_1000W_Titanium_ATX_3.0PSU_sub1.jpg', 1),
(676, 255, N'/images/image/253_Be_Quiet!_Dark_Power_13_1000W_Titanium_ATX_3.0PSU_sub3.jpg', 3),
(677, 256, N'/images/image/254_Intel_Core_Ultra_7_265F_(Tray)_sub1.png', 1),
(678, 256, N'/images/image/254_Intel_Core_Ultra_7_265F_(Tray)_sub2.jpg', 2),
(679, 256, N'/images/image/254_Intel_Core_Ultra_7_265F_(Tray)_sub3.png', 3),
(680, 257, N'/images/image/255_Intel_Core_i5_12400F_2.5GHz_Turbo_4.4GHz_(TRAY)_-__sub1.png', 1),
(681, 257, N'/images/image/255_Intel_Core_i5_12400F_2.5GHz_Turbo_4.4GHz_(TRAY)_-__sub2.jpg', 2),
(682, 257, N'/images/image/255_Intel_Core_i5_12400F_2.5GHz_Turbo_4.4GHz_(TRAY)_-__sub3.jpg', 3),
(683, 258, N'/images/image/256_Intel_Core_i7_14700F_(Tray)_sub1.png', 1),
(684, 258, N'/images/image/256_Intel_Core_i7_14700F_(Tray)_sub2.png', 2),
(685, 258, N'/images/image/256_Intel_Core_i7_14700F_(Tray)_sub3.jpg', 3),
(686, 259, N'/images/image/257_GIGABYTE_Z890_EAGLE_WIFI7_(DDR5)_sub2.jpg', 2),
(687, 259, N'/images/image/257_GIGABYTE_Z890_EAGLE_WIFI7_(DDR5)_sub3.jpg', 3),
(688, 260, N'/images/image/258_GIGABYTE_H610M-H_V3_(DDR4)_sub1.jpg', 1),
(689, 260, N'/images/image/258_GIGABYTE_H610M-H_V3_(DDR4)_sub2.jpg', 2),
(690, 261, N'/images/image/259_GIGABYTE_B760M_GAMING_PLUS_WIFI_DDR4_sub1.jpg', 1),
(691, 261, N'/images/image/259_GIGABYTE_B760M_GAMING_PLUS_WIFI_DDR4_sub2.jpg', 2),
(692, 261, N'/images/image/259_GIGABYTE_B760M_GAMING_PLUS_WIFI_DDR4_sub3.jpg', 3),
(693, 262, N'/images/image/260_RAM_Kingmax_Horizon_16GB_DDR5_Bus_5600Mhz_sub1.jpg', 1),
(694, 262, N'/images/image/260_RAM_Kingmax_Horizon_16GB_DDR5_Bus_5600Mhz_sub2.jpg', 2),
(695, 262, N'/images/image/260_RAM_Kingmax_Horizon_16GB_DDR5_Bus_5600Mhz_sub3.webp', 3),
(696, 263, N'/images/image/261_Ram_KingSpec_Heatsink_Red_1x16GB_DDR4_Bus_3200Mhz_sub1.jpg', 1),
(697, 263, N'/images/image/261_Ram_KingSpec_Heatsink_Red_1x16GB_DDR4_Bus_3200Mhz_sub3.jpg', 3),
(698, 264, N'/images/image/262_MSI_GeForce_RTX_5070_Ti_16GB_Shadow_3X_OC_sub1.jpg', 1),
(699, 264, N'/images/image/262_MSI_GeForce_RTX_5070_Ti_16GB_Shadow_3X_OC_sub2.png', 2),
(700, 264, N'/images/image/262_MSI_GeForce_RTX_5070_Ti_16GB_Shadow_3X_OC_sub3.jpg', 3),
(701, 265, N'/images/image/263_GIGABYTE_GeForce_RTX_5080_WINDFORCE_OC_SFF_16G_sub2.jpg', 2),
(702, 265, N'/images/image/263_GIGABYTE_GeForce_RTX_5080_WINDFORCE_OC_SFF_16G_sub3.jpg', 3),
(703, 266, N'/images/image/264_MSI_GeForce_RTX_5060_Ventus_2X_OC_8GB_sub1.jpg', 1),
(704, 266, N'/images/image/264_MSI_GeForce_RTX_5060_Ventus_2X_OC_8GB_sub2.jpg', 2),
(705, 266, N'/images/image/264_MSI_GeForce_RTX_5060_Ventus_2X_OC_8GB_sub3.jpg', 3),
(706, 268, N'/images/image/266_Ổ_cứng_SSD_Kingston_NV3_1TB_M.2_PCIe_NVMe_Gen4_sub1.jpg', 1),
(707, 268, N'/images/image/266_Ổ_cứng_SSD_Kingston_NV3_1TB_M.2_PCIe_NVMe_Gen4_sub2.webp', 2),
(708, 268, N'/images/image/266_Ổ_cứng_SSD_Kingston_NV3_1TB_M.2_PCIe_NVMe_Gen4_sub3.webp', 3),
(709, 269, N'/images/image/267_Ổ_Cứng_SSD_KingSpec_NVMe_512GB_(NE-512)_sub1.jpeg', 1),
(710, 269, N'/images/image/267_Ổ_Cứng_SSD_KingSpec_NVMe_512GB_(NE-512)_sub2.png', 2),
(711, 269, N'/images/image/267_Ổ_Cứng_SSD_KingSpec_NVMe_512GB_(NE-512)_sub3.jpg', 3),
(712, 270, N'/images/image/268_Corsair_RM850e_ATX_3.1_-_80_Plus_Gold_-_Full_Modul_sub1.jpg', 1),
(713, 270, N'/images/image/268_Corsair_RM850e_ATX_3.1_-_80_Plus_Gold_-_Full_Modul_sub2.jpg', 2),
(714, 270, N'/images/image/268_Corsair_RM850e_ATX_3.1_-_80_Plus_Gold_-_Full_Modul_sub3.webp', 3),
(715, 271, N'/images/image/269_Cooler_Master_MWE_650_-_80_Plus_Bronze_-_V3_230V_(_sub1.png', 1),
(716, 271, N'/images/image/269_Cooler_Master_MWE_650_-_80_Plus_Bronze_-_V3_230V_(_sub2.png', 2),
(717, 271, N'/images/image/269_Cooler_Master_MWE_650_-_80_Plus_Bronze_-_V3_230V_(_sub3.png', 3),
(718, 272, N'/images/image/270_Nguồn_FSP_HV_PRO_650W_-_80_Plus_Bronze_sub1.jpg', 1),
(719, 272, N'/images/image/270_Nguồn_FSP_HV_PRO_650W_-_80_Plus_Bronze_sub2.jpg', 2),
(720, 272, N'/images/image/270_Nguồn_FSP_HV_PRO_650W_-_80_Plus_Bronze_sub3.jpeg', 3),
(721, 273, N'/images/image/271_Corsair_CX650_-_80_Plus_Bronze_(650W)_sub1.webp', 1),
(722, 273, N'/images/image/271_Corsair_CX650_-_80_Plus_Bronze_(650W)_sub2.jpg', 2),
(723, 273, N'/images/image/271_Corsair_CX650_-_80_Plus_Bronze_(650W)_sub3.jpg', 3),
(724, 274, N'/images/image/272_Corsair_3500X_TG_Mid_Tower_Black_sub2.jpg', 2),
(725, 274, N'/images/image/272_Corsair_3500X_TG_Mid_Tower_Black_sub3.png', 3),
(726, 275, N'/images/image/273_Corsair_FRAME_4500X_RS-R_ARGB_Panoramic_Black_sub1.jpg', 1),
(727, 275, N'/images/image/273_Corsair_FRAME_4500X_RS-R_ARGB_Panoramic_Black_sub2.png', 2),
(728, 275, N'/images/image/273_Corsair_FRAME_4500X_RS-R_ARGB_Panoramic_Black_sub3.webp', 3),
(729, 276, N'/images/image/274_Tản_nhiệt_AIO_Corsair_NAUTILUS_360_ARGB_Black_sub1.png', 1),
(730, 276, N'/images/image/274_Tản_nhiệt_AIO_Corsair_NAUTILUS_360_ARGB_Black_sub2.jpg', 2),
(731, 276, N'/images/image/274_Tản_nhiệt_AIO_Corsair_NAUTILUS_360_ARGB_Black_sub3.jpg', 3),
(732, 277, N'/images/image/275_Cooler_Master_Hyper_212_Spectrum_V3_ARGB_sub3.jpg', 3),
(733, 278, N'/images/image/276_Intel_Core_i9_14900K_(Tray)_sub1.webp', 1),
(734, 278, N'/images/image/276_Intel_Core_i9_14900K_(Tray)_sub2.jpg', 2),
(735, 278, N'/images/image/276_Intel_Core_i9_14900K_(Tray)_sub3.webp', 3),
(736, 279, N'/images/image/277_Intel_Core_Ultra_9_285K_sub1.jpg', 1),
(737, 279, N'/images/image/277_Intel_Core_Ultra_9_285K_sub2.jpg', 2),
(738, 279, N'/images/image/277_Intel_Core_Ultra_9_285K_sub3.jpg', 3),
(739, 280, N'/images/image/278_ASUS_ROG_MAXIMUS_Z790_HERO_sub1.jpg', 1),
(740, 280, N'/images/image/278_ASUS_ROG_MAXIMUS_Z790_HERO_sub2.jpg', 2),
(741, 280, N'/images/image/278_ASUS_ROG_MAXIMUS_Z790_HERO_sub3.png', 3),
(742, 281, N'/images/image/279_ProArt_Z790-CREATOR_WIFI_sub1.png', 1),
(743, 281, N'/images/image/279_ProArt_Z790-CREATOR_WIFI_sub2.png', 2),
(744, 281, N'/images/image/279_ProArt_Z790-CREATOR_WIFI_sub3.jpg', 3),
(745, 282, N'/images/image/280_Corsair_Dominator_Titanium_64GB_sub1.jpg', 1),
(746, 282, N'/images/image/280_Corsair_Dominator_Titanium_64GB_sub2.jpg', 2),
(747, 283, N'/images/image/281_G.Skill_Trident_Z5_64GB_DDR5_sub1.png', 1),
(748, 283, N'/images/image/281_G.Skill_Trident_Z5_64GB_DDR5_sub2.jpg', 2),
(749, 283, N'/images/image/281_G.Skill_Trident_Z5_64GB_DDR5_sub3.jpg', 3),
(750, 284, N'/images/image/282_ASUS_ROG_Strix_RTX_5090_24GB_sub1.png', 1),
(751, 284, N'/images/image/282_ASUS_ROG_Strix_RTX_5090_24GB_sub2.jpg', 2),
(752, 285, N'/images/image/283_Samsung_990_PRO_2TB_sub1.jpg', 1),
(753, 285, N'/images/image/283_Samsung_990_PRO_2TB_sub2.jpg', 2),
(754, 285, N'/images/image/283_Samsung_990_PRO_2TB_sub3.jpg', 3),
(755, 286, N'/images/image/284_ROG_Ryujin_III_360_ARGB_sub2.jpg', 2),
(756, 286, N'/images/image/284_ROG_Ryujin_III_360_ARGB_sub3.jpg', 3),
(757, 287, N'/images/image/285_Thẻ_nhớ_SanDisk_Extreme_Pro_128GB_MicroSDXC_UHS-I__sub1.jpg', 1),
(758, 287, N'/images/image/285_Thẻ_nhớ_SanDisk_Extreme_Pro_128GB_MicroSDXC_UHS-I__sub2.jpg', 2),
(759, 287, N'/images/image/285_Thẻ_nhớ_SanDisk_Extreme_Pro_128GB_MicroSDXC_UHS-I__sub3.jpg', 3),
(760, 288, N'/images/image/286_Thẻ_nhớ_Samsung_PRO_Plus_256GB_MicroSDXC_kèm_Đầu_đ_sub1.jpg', 1),
(761, 288, N'/images/image/286_Thẻ_nhớ_Samsung_PRO_Plus_256GB_MicroSDXC_kèm_Đầu_đ_sub2.jpg', 2),
(762, 288, N'/images/image/286_Thẻ_nhớ_Samsung_PRO_Plus_256GB_MicroSDXC_kèm_Đầu_đ_sub3.jpg', 3),
(763, 289, N'/images/image/287_Thẻ_nhớ_Lexar_Professional_1066x_512GB_MicroSDXC_U_sub1.jpg', 1),
(764, 289, N'/images/image/287_Thẻ_nhớ_Lexar_Professional_1066x_512GB_MicroSDXC_U_sub2.jpg', 2),
(765, 289, N'/images/image/287_Thẻ_nhớ_Lexar_Professional_1066x_512GB_MicroSDXC_U_sub3.png', 3),
(766, 290, N'/images/image/288_Thẻ_nhớ_Kingston_Canvas_Go!_Plus_128GB_SDXC_UHS-I_sub1.jpg', 1),
(767, 290, N'/images/image/288_Thẻ_nhớ_Kingston_Canvas_Go!_Plus_128GB_SDXC_UHS-I_sub2.jpg', 2),
(768, 290, N'/images/image/288_Thẻ_nhớ_Kingston_Canvas_Go!_Plus_128GB_SDXC_UHS-I_sub3.jpeg', 3),
(769, 291, N'/images/image/289_Thẻ_nhớ_SanDisk_Ultra_SDXC_64GB_140MB_s_Class_10_sub1.jpg', 1),
(770, 291, N'/images/image/289_Thẻ_nhớ_SanDisk_Ultra_SDXC_64GB_140MB_s_Class_10_sub2.jpg', 2),
(771, 291, N'/images/image/289_Thẻ_nhớ_SanDisk_Ultra_SDXC_64GB_140MB_s_Class_10_sub3.jpg', 3),
(772, 292, N'/images/image/290_Thẻ_nhớ_Transcend_SDXC_330S_128GB_High_Speed_100MB_sub2.webp', 2),
(773, 292, N'/images/image/290_Thẻ_nhớ_Transcend_SDXC_330S_128GB_High_Speed_100MB_sub3.jpg', 3),
(774, 293, N'/images/image/291_Thẻ_nhớ_ProGrade_Digital_SDXC_UHS-II_V60_256GB_sub1.jpg', 1),
(775, 293, N'/images/image/291_Thẻ_nhớ_ProGrade_Digital_SDXC_UHS-II_V60_256GB_sub2.jpg', 2),
(776, 293, N'/images/image/291_Thẻ_nhớ_ProGrade_Digital_SDXC_UHS-II_V60_256GB_sub3.jpg', 3),
(777, 294, N'/images/image/292_Thẻ_nhớ_Sony_TOUGH_SF-G_Series_128GB_SDXC_UHS-II_3_sub1.jpg', 1),
(778, 294, N'/images/image/292_Thẻ_nhớ_Sony_TOUGH_SF-G_Series_128GB_SDXC_UHS-II_3_sub2.jpg', 2),
(779, 294, N'/images/image/292_Thẻ_nhớ_Sony_TOUGH_SF-G_Series_128GB_SDXC_UHS-II_3_sub3.jpg', 3),
(780, 295, N'/images/image/293_Thẻ_nhớ_Kioxia_Exceria_High_Endurance_128GB_MicroS_sub1.jpg', 1),
(781, 295, N'/images/image/293_Thẻ_nhớ_Kioxia_Exceria_High_Endurance_128GB_MicroS_sub2.jpg', 2),
(782, 295, N'/images/image/293_Thẻ_nhớ_Kioxia_Exceria_High_Endurance_128GB_MicroS_sub3.jpeg', 3),
(783, 296, N'/images/image/294_Thẻ_nhớ_TeamGroup_GO_Card_MicroSDXC_256GB_100MB_s_sub1.jpeg', 1),
(784, 296, N'/images/image/294_Thẻ_nhớ_TeamGroup_GO_Card_MicroSDXC_256GB_100MB_s_sub2.jpg', 2),
(785, 296, N'/images/image/294_Thẻ_nhớ_TeamGroup_GO_Card_MicroSDXC_256GB_100MB_s_sub3.jpg', 3),
(786, 297, N'/images/image/295_Ổ_cứng_di_động_SSD_SanDisk_Extreme_Portable_1TB_US_sub1.jpg', 1),
(787, 297, N'/images/image/295_Ổ_cứng_di_động_SSD_SanDisk_Extreme_Portable_1TB_US_sub2.jpg', 2),
(788, 297, N'/images/image/295_Ổ_cứng_di_động_SSD_SanDisk_Extreme_Portable_1TB_US_sub3.jpg', 3),
(789, 298, N'/images/image/296_Ổ_cứng_di_động_Samsung_T7_Shield_2TB_Type-C_Chống__sub1.jpg', 1),
(790, 298, N'/images/image/296_Ổ_cứng_di_động_Samsung_T7_Shield_2TB_Type-C_Chống__sub2.jpg', 2),
(791, 298, N'/images/image/296_Ổ_cứng_di_động_Samsung_T7_Shield_2TB_Type-C_Chống__sub3.png', 3),
(792, 299, N'/images/image/297_Ổ_cứng_di_động_HDD_WD_My_Passport_2TB_USB_3.0_Blac_sub1.jpg', 1),
(793, 299, N'/images/image/297_Ổ_cứng_di_động_HDD_WD_My_Passport_2TB_USB_3.0_Blac_sub2.jpg', 2),
(794, 299, N'/images/image/297_Ổ_cứng_di_động_HDD_WD_My_Passport_2TB_USB_3.0_Blac_sub3.jpg', 3),
(795, 300, N'/images/image/298_Ổ_cứng_di_động_SSD_Crucial_X9_Pro_1TB_1050MB_s_Vỏ__sub1.jpg', 1),
(796, 300, N'/images/image/298_Ổ_cứng_di_động_SSD_Crucial_X9_Pro_1TB_1050MB_s_Vỏ__sub2.jpg', 2),
(797, 300, N'/images/image/298_Ổ_cứng_di_động_SSD_Crucial_X9_Pro_1TB_1050MB_s_Vỏ__sub3.jpg', 3),
(798, 301, N'/images/image/299_Ổ_cứng_gắn_ngoài_HDD_Seagate_Expansion_Desktop_8TB_sub1.jpg', 1),
(799, 301, N'/images/image/299_Ổ_cứng_gắn_ngoài_HDD_Seagate_Expansion_Desktop_8TB_sub2.webp', 2),
(800, 301, N'/images/image/299_Ổ_cứng_gắn_ngoài_HDD_Seagate_Expansion_Desktop_8TB_sub3.jpg', 3),
(801, 302, N'/images/image/300_Ổ_cứng_di_động_HDD_Lacie_Rugged_Mini_2TB_USB_3.0_C_sub1.jpg', 1),
(802, 302, N'/images/image/300_Ổ_cứng_di_động_HDD_Lacie_Rugged_Mini_2TB_USB_3.0_C_sub2.jpg', 2),
(803, 302, N'/images/image/300_Ổ_cứng_di_động_HDD_Lacie_Rugged_Mini_2TB_USB_3.0_C_sub3.jpg', 3),
(804, 303, N'/images/image/301_Ổ_cứng_di_động_SSD_Kingston_XS2000_1TB_Type-C_2000_sub1.jpg', 1),
(805, 303, N'/images/image/301_Ổ_cứng_di_động_SSD_Kingston_XS2000_1TB_Type-C_2000_sub2.jpg', 2),
(806, 303, N'/images/image/301_Ổ_cứng_di_động_SSD_Kingston_XS2000_1TB_Type-C_2000_sub3.png', 3),
(807, 304, N'/images/image/302_Ổ_cứng_di_động_HDD_Transcend_StoreJet_25M3_1TB_Chố_sub1.jpg', 1),
(808, 304, N'/images/image/302_Ổ_cứng_di_động_HDD_Transcend_StoreJet_25M3_1TB_Chố_sub2.jpg', 2),
(809, 304, N'/images/image/302_Ổ_cứng_di_động_HDD_Transcend_StoreJet_25M3_1TB_Chố_sub3.png', 3),
(810, 305, N'/images/image/303_Ổ_cứng_di_động_SSD_Corsair_EX100U_2TB_Type-C_USB_3_sub2.jpg', 2),
(811, 305, N'/images/image/303_Ổ_cứng_di_động_SSD_Corsair_EX100U_2TB_Type-C_USB_3_sub3.jpg', 3),
(812, 306, N'/images/image/304_Ổ_cứng_di_động_SSD_ADATA_SE880_1TB_Type-C_2000MB_s_sub1.jpg', 1),
(813, 306, N'/images/image/304_Ổ_cứng_di_động_SSD_ADATA_SE880_1TB_Type-C_2000MB_s_sub2.jpg', 2),
(814, 306, N'/images/image/304_Ổ_cứng_di_động_SSD_ADATA_SE880_1TB_Type-C_2000MB_s_sub3.jpg', 3),
(815, 307, N'/images/image/305_Tản_nhiệt_nước_AIO_NZXT_Kraken_Elite_360_RGB_White_sub1.jpg', 1),
(816, 308, N'/images/image/306_Tản_nhiệt_nước_AIO_Corsair_iCUE_LINK_H150i_LCD_Whi_sub1.jpg', 1),
(817, 308, N'/images/image/306_Tản_nhiệt_nước_AIO_Corsair_iCUE_LINK_H150i_LCD_Whi_sub2.jpg', 2),
(818, 308, N'/images/image/306_Tản_nhiệt_nước_AIO_Corsair_iCUE_LINK_H150i_LCD_Whi_sub3.jpg', 3),
(819, 309, N'/images/image/307_Tản_nhiệt_nước_AIO_ASUS_ROG_Ryujin_III_360_ARGB_Wh_sub1.png', 1),
(820, 309, N'/images/image/307_Tản_nhiệt_nước_AIO_ASUS_ROG_Ryujin_III_360_ARGB_Wh_sub2.jpg', 2),
(821, 309, N'/images/image/307_Tản_nhiệt_nước_AIO_ASUS_ROG_Ryujin_III_360_ARGB_Wh_sub3.jpg', 3),
(822, 310, N'/images/image/308_Tản_nhiệt_nước_AIO_MSI_MAG_CORELIQUID_E360_Black_sub1.png', 1),
(823, 310, N'/images/image/308_Tản_nhiệt_nước_AIO_MSI_MAG_CORELIQUID_E360_Black_sub2.png', 2),
(824, 310, N'/images/image/308_Tản_nhiệt_nước_AIO_MSI_MAG_CORELIQUID_E360_Black_sub3.png', 3),
(825, 311, N'/images/image/309_Tản_nhiệt_nước_AIO_DeepCool_LT720_360mm_High-Perfo_sub1.jpg', 1),
(826, 311, N'/images/image/309_Tản_nhiệt_nước_AIO_DeepCool_LT720_360mm_High-Perfo_sub2.jpg', 2),
(827, 311, N'/images/image/309_Tản_nhiệt_nước_AIO_DeepCool_LT720_360mm_High-Perfo_sub3.jpg', 3),
(828, 312, N'/images/image/310_Tản_nhiệt_nước_AIO_Lian_Li_Galahad_II_Trinity_SL-I_sub1.jpg', 1),
(829, 312, N'/images/image/310_Tản_nhiệt_nước_AIO_Lian_Li_Galahad_II_Trinity_SL-I_sub2.jpg', 2),
(830, 312, N'/images/image/310_Tản_nhiệt_nước_AIO_Lian_Li_Galahad_II_Trinity_SL-I_sub3.jpg', 3),
(831, 313, N'/images/image/311_Tản_nhiệt_nước_AIO_Cooler_Master_MasterLiquid_360__sub2.jpg', 2),
(832, 313, N'/images/image/311_Tản_nhiệt_nước_AIO_Cooler_Master_MasterLiquid_360__sub3.jpg', 3),
(833, 314, N'/images/image/312_Tản_nhiệt_nước_AIO_Thermalright_Frozen_Prism_360_A_sub1.jpg', 1),
(834, 314, N'/images/image/312_Tản_nhiệt_nước_AIO_Thermalright_Frozen_Prism_360_A_sub2.jpg', 2),
(835, 314, N'/images/image/312_Tản_nhiệt_nước_AIO_Thermalright_Frozen_Prism_360_A_sub3.jpg', 3),
(836, 315, N'/images/image/313_Tản_nhiệt_nước_AIO_Valkyrie_GL360_ARGB_Màn_hình_LC_sub1.jpg', 1),
(837, 315, N'/images/image/313_Tản_nhiệt_nước_AIO_Valkyrie_GL360_ARGB_Màn_hình_LC_sub2.jpg', 2),
(838, 315, N'/images/image/313_Tản_nhiệt_nước_AIO_Valkyrie_GL360_ARGB_Màn_hình_LC_sub3.jpg', 3),
(839, 316, N'/images/image/314_Tản_nhiệt_nước_AIO_ID-COOLING_DASHFLOW_360_Basic_B_sub1.jpg', 1),
(840, 316, N'/images/image/314_Tản_nhiệt_nước_AIO_ID-COOLING_DASHFLOW_360_Basic_B_sub2.png', 2),
(841, 316, N'/images/image/314_Tản_nhiệt_nước_AIO_ID-COOLING_DASHFLOW_360_Basic_B_sub3.jpg', 3),
(842, 317, N'/images/image/315_Card_màn_hình_GIGABYTE_GeForce_RTX_4070_Ti_SUPER_W_sub1.png', 1),
(843, 317, N'/images/image/315_Card_màn_hình_GIGABYTE_GeForce_RTX_4070_Ti_SUPER_W_sub2.png', 2),
(844, 317, N'/images/image/315_Card_màn_hình_GIGABYTE_GeForce_RTX_4070_Ti_SUPER_W_sub3.jpg', 3),
(845, 318, N'/images/image/316_Card_màn_hình_ASUS_TUF_Gaming_GeForce_RTX_4080_SUP_sub1.webp', 1),
(846, 318, N'/images/image/316_Card_màn_hình_ASUS_TUF_Gaming_GeForce_RTX_4080_SUP_sub2.jpg', 2),
(847, 318, N'/images/image/316_Card_màn_hình_ASUS_TUF_Gaming_GeForce_RTX_4080_SUP_sub3.png', 3),
(848, 319, N'/images/image/317_Card_màn_hình_MSI_GeForce_RTX_4060_Ti_GAMING_X_SLI_sub2.png', 2),
(849, 319, N'/images/image/317_Card_màn_hình_MSI_GeForce_RTX_4060_Ti_GAMING_X_SLI_sub3.jpg', 3),
(850, 320, N'/images/image/318_Card_màn_hình_ZOTAC_GAMING_GeForce_RTX_4070_SUPER__sub1.jpg', 1),
(851, 320, N'/images/image/318_Card_màn_hình_ZOTAC_GAMING_GeForce_RTX_4070_SUPER__sub2.jpg', 2),
(852, 321, N'/images/image/319_Card_màn_hình_GALAX_GeForce_RTX_4070_Ti_SUPER_EX_G_sub1.jpg', 1),
(853, 321, N'/images/image/319_Card_màn_hình_GALAX_GeForce_RTX_4070_Ti_SUPER_EX_G_sub2.png', 2),
(854, 321, N'/images/image/319_Card_màn_hình_GALAX_GeForce_RTX_4070_Ti_SUPER_EX_G_sub3.png', 3),
(855, 322, N'/images/image/320_Card_màn_hình_PowerColor_Hellhound_AMD_Radeon_RX_7_sub1.webp', 1),
(856, 322, N'/images/image/320_Card_màn_hình_PowerColor_Hellhound_AMD_Radeon_RX_7_sub2.jpg', 2),
(857, 322, N'/images/image/320_Card_màn_hình_PowerColor_Hellhound_AMD_Radeon_RX_7_sub3.jpg', 3),
(858, 323, N'/images/image/321_Card_màn_hình_Sapphire_NITRO+_AMD_Radeon_RX_7800_X_sub1.webp', 1),
(859, 323, N'/images/image/321_Card_màn_hình_Sapphire_NITRO+_AMD_Radeon_RX_7800_X_sub2.jpg', 2),
(860, 323, N'/images/image/321_Card_màn_hình_Sapphire_NITRO+_AMD_Radeon_RX_7800_X_sub3.jpg', 3),
(861, 324, N'/images/image/322_Card_màn_hình_XFX_Speedster_MERC_310_AMD_Radeon_RX_sub1.jpg', 1),
(862, 324, N'/images/image/322_Card_màn_hình_XFX_Speedster_MERC_310_AMD_Radeon_RX_sub2.jpg', 2),
(863, 324, N'/images/image/322_Card_màn_hình_XFX_Speedster_MERC_310_AMD_Radeon_RX_sub3.jpg', 3),
(864, 325, N'/images/image/323_Card_màn_hình_COLORFUL_iGame_GeForce_RTX_4070_SUPE_sub1.jpg', 1),
(865, 325, N'/images/image/323_Card_màn_hình_COLORFUL_iGame_GeForce_RTX_4070_SUPE_sub3.jpg', 3),
(866, 326, N'/images/image/324_Card_màn_hình_ASRock_Phantom_Gaming_Radeon_RX_7700_sub2.jpg', 2),
(867, 327, N'/images/image/325_Ổ_cứng_HDD_PC_Seagate_Barracuda_2TB_3.5_inch_SATA3_sub1.jpg', 1),
(868, 327, N'/images/image/325_Ổ_cứng_HDD_PC_Seagate_Barracuda_2TB_3.5_inch_SATA3_sub2.jpg', 2),
(869, 327, N'/images/image/325_Ổ_cứng_HDD_PC_Seagate_Barracuda_2TB_3.5_inch_SATA3_sub3.jpg', 3),
(870, 328, N'/images/image/326_Ổ_cứng_HDD_PC_Western_Digital_Blue_2TB_3.5_inch_72_sub1.png', 1),
(871, 328, N'/images/image/326_Ổ_cứng_HDD_PC_Western_Digital_Blue_2TB_3.5_inch_72_sub2.jpg', 2),
(872, 328, N'/images/image/326_Ổ_cứng_HDD_PC_Western_Digital_Blue_2TB_3.5_inch_72_sub3.png', 3),
(873, 329, N'/images/image/327_Ổ_cứng_HDD_PC_Toshiba_P300_2TB_3.5_inch_SATA3_7200_sub2.webp', 2),
(874, 329, N'/images/image/327_Ổ_cứng_HDD_PC_Toshiba_P300_2TB_3.5_inch_SATA3_7200_sub3.jpg', 3),
(875, 330, N'/images/image/328_Ổ_cứng_HDD_Server_Seagate_IronWolf_4TB_3.5_inch_NA_sub1.jpg', 1),
(876, 330, N'/images/image/328_Ổ_cứng_HDD_Server_Seagate_IronWolf_4TB_3.5_inch_NA_sub2.webp', 2),
(877, 330, N'/images/image/328_Ổ_cứng_HDD_Server_Seagate_IronWolf_4TB_3.5_inch_NA_sub3.jpg', 3),
(878, 331, N'/images/image/329_Ổ_cứng_HDD_Server_Western_Digital_Red_Plus_4TB_3.5_sub1.jpg', 1),
(879, 331, N'/images/image/329_Ổ_cứng_HDD_Server_Western_Digital_Red_Plus_4TB_3.5_sub2.jpg', 2),
(880, 331, N'/images/image/329_Ổ_cứng_HDD_Server_Western_Digital_Red_Plus_4TB_3.5_sub3.jpg', 3),
(881, 332, N'/images/image/330_Ổ_cứng_HDD_Enterprise_Seagate_Exos_X18_16TB_3.5_in_sub1.jpg', 1),
(882, 332, N'/images/image/330_Ổ_cứng_HDD_Enterprise_Seagate_Exos_X18_16TB_3.5_in_sub3.jpg', 3),
(883, 333, N'/images/image/331_Ổ_cứng_HDD_Enterprise_Western_Digital_Gold_8TB_3.5_sub1.jpg', 1),
(884, 333, N'/images/image/331_Ổ_cứng_HDD_Enterprise_Western_Digital_Gold_8TB_3.5_sub2.jpg', 2),
(885, 333, N'/images/image/331_Ổ_cứng_HDD_Enterprise_Western_Digital_Gold_8TB_3.5_sub3.jpg', 3),
(886, 334, N'/images/image/332_Ổ_cứng_HDD_PC_Toshiba_X300_4TB_7200rpm_Gaming_Inte_sub1.jpg', 1),
(887, 334, N'/images/image/332_Ổ_cứng_HDD_PC_Toshiba_X300_4TB_7200rpm_Gaming_Inte_sub2.jpg', 2),
(888, 334, N'/images/image/332_Ổ_cứng_HDD_PC_Toshiba_X300_4TB_7200rpm_Gaming_Inte_sub3.jpg', 3),
(889, 335, N'/images/image/333_Ổ_cứng_HDD_PC_Western_Digital_Black_1TB_3.5_inch_P_sub1.jpg', 1),
(890, 335, N'/images/image/333_Ổ_cứng_HDD_PC_Western_Digital_Black_1TB_3.5_inch_P_sub2.jpg', 2),
(891, 335, N'/images/image/333_Ổ_cứng_HDD_PC_Western_Digital_Black_1TB_3.5_inch_P_sub3.jpg', 3),
(892, 336, N'/images/image/334_Ổ_cứng_HDD_Camera_Seagate_SkyHawk_4TB_3.5_inch_Sur_sub1.jpg', 1),
(893, 336, N'/images/image/334_Ổ_cứng_HDD_Camera_Seagate_SkyHawk_4TB_3.5_inch_Sur_sub2.jpg', 2),
(894, 336, N'/images/image/334_Ổ_cứng_HDD_Camera_Seagate_SkyHawk_4TB_3.5_inch_Sur_sub3.jpg', 3),
(895, 337, N'/images/image/335_Nguồn_Corsair_RM750e_ATX_3.0_80_Plus_Gold_Full_Mod_sub1.jpg', 1),
(896, 337, N'/images/image/335_Nguồn_Corsair_RM750e_ATX_3.0_80_Plus_Gold_Full_Mod_sub2.png', 2),
(897, 337, N'/images/image/335_Nguồn_Corsair_RM750e_ATX_3.0_80_Plus_Gold_Full_Mod_sub3.jpg', 3),
(898, 338, N'/images/image/336_Nguồn_MSI_MAG_A750GL_PCIE5_750W_80_Plus_Gold_Full__sub1.jpg', 1),
(899, 338, N'/images/image/336_Nguồn_MSI_MAG_A750GL_PCIE5_750W_80_Plus_Gold_Full__sub2.jpeg', 2),
(900, 338, N'/images/image/336_Nguồn_MSI_MAG_A750GL_PCIE5_750W_80_Plus_Gold_Full__sub3.jpg', 3),
(901, 339, N'/images/image/337_Nguồn_GIGABYTE_UD850GM_PG5_850W_80_Plus_Gold_PCIe__sub2.jpg', 2),
(902, 339, N'/images/image/337_Nguồn_GIGABYTE_UD850GM_PG5_850W_80_Plus_Gold_PCIe__sub3.jpg', 3),
(903, 340, N'/images/image/338_Nguồn_ASUS_TUF_Gaming_750W_80_Plus_Bronze_sub1.jpg', 1),
(904, 340, N'/images/image/338_Nguồn_ASUS_TUF_Gaming_750W_80_Plus_Bronze_sub2.jpg', 2),
(905, 340, N'/images/image/338_Nguồn_ASUS_TUF_Gaming_750W_80_Plus_Bronze_sub3.png', 3),
(906, 341, N'/images/image/339_Nguồn_Cooler_Master_MWE_Gold_850_V2_Full_Modular_(_sub1.jpg', 1),
(907, 341, N'/images/image/339_Nguồn_Cooler_Master_MWE_Gold_850_V2_Full_Modular_(_sub2.jpg', 2),
(908, 341, N'/images/image/339_Nguồn_Cooler_Master_MWE_Gold_850_V2_Full_Modular_(_sub3.jpg', 3),
(909, 342, N'/images/image/340_Nguồn_DeepCool_PL750D_750W_80_Plus_Bronze_ATX_3.0__sub1.webp', 1),
(910, 342, N'/images/image/340_Nguồn_DeepCool_PL750D_750W_80_Plus_Bronze_ATX_3.0__sub2.jpg', 2),
(911, 342, N'/images/image/340_Nguồn_DeepCool_PL750D_750W_80_Plus_Bronze_ATX_3.0__sub3.jpg', 3),
(912, 343, N'/images/image/341_Nguồn_Super_Flower_Leadex_III_Gold_850W_ARGB_Full__sub1.jpg', 1),
(913, 343, N'/images/image/341_Nguồn_Super_Flower_Leadex_III_Gold_850W_ARGB_Full__sub2.jpg', 2),
(914, 343, N'/images/image/341_Nguồn_Super_Flower_Leadex_III_Gold_850W_ARGB_Full__sub3.jpg', 3),
(915, 344, N'/images/image/342_Nguồn_Seasonic_Focus_GX-850_850W_80_Plus_Gold_Full_sub1.jpg', 1),
(916, 345, N'/images/image/343_Nguồn_FSP_Hydro_G_PRO_850W_PCIe5.0_80_Plus_Gold_sub1.jpg', 1),
(917, 345, N'/images/image/343_Nguồn_FSP_Hydro_G_PRO_850W_PCIe5.0_80_Plus_Gold_sub2.jpg', 2),
(918, 345, N'/images/image/343_Nguồn_FSP_Hydro_G_PRO_850W_PCIe5.0_80_Plus_Gold_sub3.jpg', 3),
(919, 346, N'/images/image/344_Nguồn_Thermaltake_Toughpower_GF_A3_850W_Gold_ATX_3_sub2.jpg', 2),
(920, 347, N'/images/image/345_Vỏ_case_NZXT_H6_Flow_RGB_Dual-Chamber_Mid-Tower_Bl_sub1.jpeg', 1),
(921, 347, N'/images/image/345_Vỏ_case_NZXT_H6_Flow_RGB_Dual-Chamber_Mid-Tower_Bl_sub2.jpg', 2),
(922, 347, N'/images/image/345_Vỏ_case_NZXT_H6_Flow_RGB_Dual-Chamber_Mid-Tower_Bl_sub3.jpg', 3),
(923, 348, N'/images/image/346_Vỏ_case_Lian_Li_O11_Vision_Tempered_Glass_Mid-Towe_sub2.jpg', 2),
(924, 348, N'/images/image/346_Vỏ_case_Lian_Li_O11_Vision_Tempered_Glass_Mid-Towe_sub3.webp', 3),
(925, 349, N'/images/image/347_Vỏ_case_Corsair_4000D_AIRFLOW_Tempered_Glass_Mid-T_sub1.webp', 1),
(926, 349, N'/images/image/347_Vỏ_case_Corsair_4000D_AIRFLOW_Tempered_Glass_Mid-T_sub2.jpg', 2),
(927, 349, N'/images/image/347_Vỏ_case_Corsair_4000D_AIRFLOW_Tempered_Glass_Mid-T_sub3.jpg', 3),
(928, 350, N'/images/image/348_Vỏ_case_Montech_KING_95_PRO_Panoramic_Curved_Glass_sub1.png', 1),
(929, 350, N'/images/image/348_Vỏ_case_Montech_KING_95_PRO_Panoramic_Curved_Glass_sub3.jpeg', 3),
(930, 351, N'/images/image/349_Vỏ_case_HYTE_Y60_Panoramic_Dual_Chamber_Glass_Blac_sub1.jpg', 1),
(931, 351, N'/images/image/349_Vỏ_case_HYTE_Y60_Panoramic_Dual_Chamber_Glass_Blac_sub2.jpg', 2),
(932, 351, N'/images/image/349_Vỏ_case_HYTE_Y60_Panoramic_Dual_Chamber_Glass_Blac_sub3.jpg', 3),
(933, 352, N'/images/image/350_Vỏ_case_Antec_C8_Dual-Chamber_Full_Tower_Black_sub1.jpeg', 1),
(934, 352, N'/images/image/350_Vỏ_case_Antec_C8_Dual-Chamber_Full_Tower_Black_sub3.jpg', 3),
(935, 353, N'/images/image/351_Vỏ_case_Fractal_Design_Pop_Air_RGB_TG_Black_sub1.png', 1),
(936, 353, N'/images/image/351_Vỏ_case_Fractal_Design_Pop_Air_RGB_TG_Black_sub2.png', 2),
(937, 353, N'/images/image/351_Vỏ_case_Fractal_Design_Pop_Air_RGB_TG_Black_sub3.png', 3),
(938, 354, N'/images/image/352_Vỏ_case_DeepCool_CH560_DIGITAL_ARGB_Màn_hình_nhiệt_sub1.jpg', 1),
(939, 354, N'/images/image/352_Vỏ_case_DeepCool_CH560_DIGITAL_ARGB_Màn_hình_nhiệt_sub2.jpg', 2),
(940, 355, N'/images/image/353_Vỏ_case_Xigmatek_ENDORPHIN_ULTRA_ARTIC_White_Panor_sub1.jpg', 1),
(941, 355, N'/images/image/353_Vỏ_case_Xigmatek_ENDORPHIN_ULTRA_ARTIC_White_Panor_sub2.jpg', 2),
(942, 355, N'/images/image/353_Vỏ_case_Xigmatek_ENDORPHIN_ULTRA_ARTIC_White_Panor_sub3.jpg', 3),
(943, 356, N'/images/image/354_Vỏ_case_Phanteks_NV5_Mid-Tower_ARGB_Black_Glass_sub1.webp', 1),
(944, 356, N'/images/image/354_Vỏ_case_Phanteks_NV5_Mid-Tower_ARGB_Black_Glass_sub2.jpg', 2),
(945, 356, N'/images/image/354_Vỏ_case_Phanteks_NV5_Mid-Tower_ARGB_Black_Glass_sub3.jpg', 3),
(946, 357, N'/images/image/355_Tản_nhiệt_khí_Thermalright_Peerless_Assassin_120_S_sub1.jpg', 1),
(947, 357, N'/images/image/355_Tản_nhiệt_khí_Thermalright_Peerless_Assassin_120_S_sub2.jpg', 2),
(948, 357, N'/images/image/355_Tản_nhiệt_khí_Thermalright_Peerless_Assassin_120_S_sub3.jpg', 3),
(949, 358, N'/images/image/356_Tản_nhiệt_khí_DeepCool_AK400_Digital_ARGB_Màn_hình_sub1.png', 1),
(950, 358, N'/images/image/356_Tản_nhiệt_khí_DeepCool_AK400_Digital_ARGB_Màn_hình_sub2.png', 2),
(951, 358, N'/images/image/356_Tản_nhiệt_khí_DeepCool_AK400_Digital_ARGB_Màn_hình_sub3.jpg', 3),
(952, 359, N'/images/image/357_Tản_nhiệt_khí_Noctua_NH-D15_chromax.black_Dual-Tow_sub1.png', 1),
(953, 359, N'/images/image/357_Tản_nhiệt_khí_Noctua_NH-D15_chromax.black_Dual-Tow_sub2.jpg', 2),
(954, 359, N'/images/image/357_Tản_nhiệt_khí_Noctua_NH-D15_chromax.black_Dual-Tow_sub3.jpg', 3),
(955, 360, N'/images/image/358_Tản_nhiệt_khí_ID-COOLING_SE-224-XT_ARGB_V2_Black_sub1.jpg', 1),
(956, 360, N'/images/image/358_Tản_nhiệt_khí_ID-COOLING_SE-224-XT_ARGB_V2_Black_sub2.jpg', 2),
(957, 360, N'/images/image/358_Tản_nhiệt_khí_ID-COOLING_SE-224-XT_ARGB_V2_Black_sub3.jpg', 3),
(958, 361, N'/images/image/359_Tản_nhiệt_khí_Cooler_Master_Hyper_622_Halo_Black_A_sub1.jpg', 1),
(959, 361, N'/images/image/359_Tản_nhiệt_khí_Cooler_Master_Hyper_622_Halo_Black_A_sub2.jpg', 2),
(960, 361, N'/images/image/359_Tản_nhiệt_khí_Cooler_Master_Hyper_622_Halo_Black_A_sub3.jpg', 3),
(961, 362, N'/images/image/360_Tản_nhiệt_khí_Jonsbo_CR-1000_EVO_ARGB_Black_sub1.jpg', 1),
(962, 362, N'/images/image/360_Tản_nhiệt_khí_Jonsbo_CR-1000_EVO_ARGB_Black_sub2.png', 2),
(963, 362, N'/images/image/360_Tản_nhiệt_khí_Jonsbo_CR-1000_EVO_ARGB_Black_sub3.jpg', 3),
(964, 363, N'/images/image/361_Tản_nhiệt_khí_Thermalright_Phantom_Spirit_120_EVO__sub1.webp', 1),
(965, 363, N'/images/image/361_Tản_nhiệt_khí_Thermalright_Phantom_Spirit_120_EVO__sub2.webp', 2),
(966, 363, N'/images/image/361_Tản_nhiệt_khí_Thermalright_Phantom_Spirit_120_EVO__sub3.png', 3),
(967, 364, N'/images/image/362_Tản_nhiệt_khí_Be_Quiet!_Dark_Rock_Pro_5_Dual_Tower_sub1.jpg', 1),
(968, 365, N'/images/image/363_Tản_nhiệt_khí_PCCOOLER_K6_Digital_Display_ARGB_Dua_sub1.jpg', 1),
(969, 365, N'/images/image/363_Tản_nhiệt_khí_PCCOOLER_K6_Digital_Display_ARGB_Dua_sub2.jpeg', 2),
(970, 365, N'/images/image/363_Tản_nhiệt_khí_PCCOOLER_K6_Digital_Display_ARGB_Dua_sub3.jpg', 3),
(971, 366, N'/images/image/364_Tản_nhiệt_khí_Valkyrie_SL125_ARGB_Màn_hiển_thị_nhi_sub1.jpg', 1),
(972, 366, N'/images/image/364_Tản_nhiệt_khí_Valkyrie_SL125_ARGB_Màn_hiển_thị_nhi_sub2.png', 2),
(973, 366, N'/images/image/364_Tản_nhiệt_khí_Valkyrie_SL125_ARGB_Màn_hiển_thị_nhi_sub3.png', 3),
(974, 367, N'/images/image/365_Bộ_3_Fan_tản_nhiệt_Lian_Li_UNI_FAN_SL-Infinity_120_sub2.jpg', 2),
(975, 367, N'/images/image/365_Bộ_3_Fan_tản_nhiệt_Lian_Li_UNI_FAN_SL-Infinity_120_sub3.jpg', 3),
(976, 368, N'/images/image/366_Bộ_3_Fan_tản_nhiệt_Corsair_iCUE_LINK_QX120_RGB_Sta_sub1.jpg', 1),
(977, 368, N'/images/image/366_Bộ_3_Fan_tản_nhiệt_Corsair_iCUE_LINK_QX120_RGB_Sta_sub2.png', 2),
(978, 368, N'/images/image/366_Bộ_3_Fan_tản_nhiệt_Corsair_iCUE_LINK_QX120_RGB_Sta_sub3.jpg', 3),
(979, 369, N'/images/image/367_Bộ_3_Fan_tản_nhiệt_NZXT_Duo_F120_RGB_Triple_Pack_B_sub1.jpg', 1),
(980, 369, N'/images/image/367_Bộ_3_Fan_tản_nhiệt_NZXT_Duo_F120_RGB_Triple_Pack_B_sub2.webp', 2),
(981, 369, N'/images/image/367_Bộ_3_Fan_tản_nhiệt_NZXT_Duo_F120_RGB_Triple_Pack_B_sub3.png', 3),
(982, 370, N'/images/image/368_Bộ_3_Fan_tản_nhiệt_Thermalright_TL-C12C-S_ARGB_Tri_sub1.jpg', 1),
(983, 370, N'/images/image/368_Bộ_3_Fan_tản_nhiệt_Thermalright_TL-C12C-S_ARGB_Tri_sub2.jpg', 2),
(984, 370, N'/images/image/368_Bộ_3_Fan_tản_nhiệt_Thermalright_TL-C12C-S_ARGB_Tri_sub3.jpg', 3),
(985, 371, N'/images/image/369_Bộ_3_Fan_tản_nhiệt_DeepCool_FC120_3-in-1_ARGB_Blac_sub1.webp', 1),
(986, 371, N'/images/image/369_Bộ_3_Fan_tản_nhiệt_DeepCool_FC120_3-in-1_ARGB_Blac_sub2.jpg', 2),
(987, 371, N'/images/image/369_Bộ_3_Fan_tản_nhiệt_DeepCool_FC120_3-in-1_ARGB_Blac_sub3.jpg', 3),
(988, 372, N'/images/image/370_Bộ_3_Fan_tản_nhiệt_Phanteks_D30-120_Reverse_Airflo_sub1.jpg', 1),
(989, 372, N'/images/image/370_Bộ_3_Fan_tản_nhiệt_Phanteks_D30-120_Reverse_Airflo_sub2.jpg', 2),
(990, 372, N'/images/image/370_Bộ_3_Fan_tản_nhiệt_Phanteks_D30-120_Reverse_Airflo_sub3.jpg', 3),
(991, 373, N'/images/image/371_Bộ_3_Fan_tản_nhiệt_ID-COOLING_XF-12025_ARGB_Trio_P_sub1.jpg', 1),
(992, 373, N'/images/image/371_Bộ_3_Fan_tản_nhiệt_ID-COOLING_XF-12025_ARGB_Trio_P_sub2.jpg', 2),
(993, 373, N'/images/image/371_Bộ_3_Fan_tản_nhiệt_ID-COOLING_XF-12025_ARGB_Trio_P_sub3.jpg', 3),
(994, 374, N'/images/image/372_Bộ_3_Fan_tản_nhiệt_Cooler_Master_MasterFan_MF120_H_sub1.jpg', 1),
(995, 374, N'/images/image/372_Bộ_3_Fan_tản_nhiệt_Cooler_Master_MasterFan_MF120_H_sub3.jpeg', 3),
(996, 375, N'/images/image/373_Bộ_3_Fan_tản_nhiệt_Antec_Fusion_120_ARGB_Triple_Pa_sub1.jpg', 1),
(997, 375, N'/images/image/373_Bộ_3_Fan_tản_nhiệt_Antec_Fusion_120_ARGB_Triple_Pa_sub2.jpg', 2),
(998, 375, N'/images/image/373_Bộ_3_Fan_tản_nhiệt_Antec_Fusion_120_ARGB_Triple_Pa_sub3.jpg', 3),
(999, 376, N'/images/image/374_Bộ_3_Fan_tản_nhiệt_Montech_AX120_PWM_ARGB_Pack_Whi_sub1.jpg', 1),
(1000, 376, N'/images/image/374_Bộ_3_Fan_tản_nhiệt_Montech_AX120_PWM_ARGB_Pack_Whi_sub2.jpg', 2),
(1001, 377, N'/images/image/375_Bàn_phím_cơ_AKKO_3087_v2_Silent_Bluetooth_5.0_Wire_sub1.jpg', 1),
(1002, 377, N'/images/image/375_Bàn_phím_cơ_AKKO_3087_v2_Silent_Bluetooth_5.0_Wire_sub2.png', 2),
(1003, 377, N'/images/image/375_Bàn_phím_cơ_AKKO_3087_v2_Silent_Bluetooth_5.0_Wire_sub3.png', 3),
(1004, 378, N'/images/image/376_Bàn_phím_cơ_Keychron_V1_Max_Wireless_Custom_Mechan_sub1.jpg', 1),
(1005, 378, N'/images/image/376_Bàn_phím_cơ_Keychron_V1_Max_Wireless_Custom_Mechan_sub2.jpg', 2),
(1006, 378, N'/images/image/376_Bàn_phím_cơ_Keychron_V1_Max_Wireless_Custom_Mechan_sub3.jpg', 3),
(1007, 379, N'/images/image/377_Bàn_phím_cơ_Royal_Kludge_RK84_RGB_Wireless_80%_Lay_sub1.jpg', 1),
(1008, 379, N'/images/image/377_Bàn_phím_cơ_Royal_Kludge_RK84_RGB_Wireless_80%_Lay_sub2.jpg', 2),
(1009, 379, N'/images/image/377_Bàn_phím_cơ_Royal_Kludge_RK84_RGB_Wireless_80%_Lay_sub3.jpg', 3),
(1010, 380, N'/images/image/378_Bàn_phím_cơ_FL-Esports_FL980_SAM_Tropical_Secret_W_sub1.jpg', 1),
(1011, 380, N'/images/image/378_Bàn_phím_cơ_FL-Esports_FL980_SAM_Tropical_Secret_W_sub2.jpg', 2),
(1012, 380, N'/images/image/378_Bàn_phím_cơ_FL-Esports_FL980_SAM_Tropical_Secret_W_sub3.jpg', 3),
(1013, 381, N'/images/image/379_Bàn_phím_cơ_MonsGeek_M1W_V3_Fully_Assembled_Alumin_sub1.jpg', 1),
(1014, 381, N'/images/image/379_Bàn_phím_cơ_MonsGeek_M1W_V3_Fully_Assembled_Alumin_sub2.jpg', 2),
(1015, 381, N'/images/image/379_Bàn_phím_cơ_MonsGeek_M1W_V3_Fully_Assembled_Alumin_sub3.jpg', 3),
(1016, 382, N'/images/image/380_Bàn_phím_cơ_EPOMAKER_RT100_Retro_Mechanical_Keyboa_sub1.jpg', 1),
(1017, 382, N'/images/image/380_Bàn_phím_cơ_EPOMAKER_RT100_Retro_Mechanical_Keyboa_sub2.jpg', 2),
(1018, 382, N'/images/image/380_Bàn_phím_cơ_EPOMAKER_RT100_Retro_Mechanical_Keyboa_sub3.jpg', 3),
(1019, 383, N'/images/image/381_Bàn_phím_cơ_Ducky_One_3_Daybreak_Hotswap_RGB_Mech__sub1.jpg', 1),
(1020, 383, N'/images/image/381_Bàn_phím_cơ_Ducky_One_3_Daybreak_Hotswap_RGB_Mech__sub2.jpg', 2),
(1021, 383, N'/images/image/381_Bàn_phím_cơ_Ducky_One_3_Daybreak_Hotswap_RGB_Mech__sub3.jpg', 3),
(1022, 384, N'/images/image/382_Bàn_phím_cơ_Varmilo_VEA87_Vintage_Mechanical_Keybo_sub1.jpg', 1),
(1023, 384, N'/images/image/382_Bàn_phím_cơ_Varmilo_VEA87_Vintage_Mechanical_Keybo_sub2.jpg', 2),
(1024, 384, N'/images/image/382_Bàn_phím_cơ_Varmilo_VEA87_Vintage_Mechanical_Keybo_sub3.jpg', 3),
(1025, 385, N'/images/image/383_Bàn_phím_cơ_NuPhy_Air75_V2_Low-Profile_Wireless_Ke_sub1.jpg', 1),
(1026, 385, N'/images/image/383_Bàn_phím_cơ_NuPhy_Air75_V2_Low-Profile_Wireless_Ke_sub2.jpg', 2),
(1027, 385, N'/images/image/383_Bàn_phím_cơ_NuPhy_Air75_V2_Low-Profile_Wireless_Ke_sub3.jpg', 3),
(1028, 386, N'/images/image/384_Bàn_phím_cơ_Custom_Womier_K66_Gateron_Switch_RGB_A_sub1.jpg', 1),
(1029, 386, N'/images/image/384_Bàn_phím_cơ_Custom_Womier_K66_Gateron_Switch_RGB_A_sub2.jpg', 2),
(1030, 386, N'/images/image/384_Bàn_phím_cơ_Custom_Womier_K66_Gateron_Switch_RGB_A_sub3.jpg', 3),
(1031, 387, N'/images/image/385_Chuột_máy_tính_Razer_Basilisk_V3_Ergonomic_Gaming__sub1.jpg', 1),
(1032, 387, N'/images/image/385_Chuột_máy_tính_Razer_Basilisk_V3_Ergonomic_Gaming__sub2.jpg', 2),
(1033, 387, N'/images/image/385_Chuột_máy_tính_Razer_Basilisk_V3_Ergonomic_Gaming__sub3.jpg', 3),
(1034, 388, N'/images/image/386_Chuột_máy_tính_Logitech_G304_LIGHTSPEED_Wireless_B_sub1.png', 1),
(1035, 388, N'/images/image/386_Chuột_máy_tính_Logitech_G304_LIGHTSPEED_Wireless_B_sub2.jpg', 2),
(1036, 388, N'/images/image/386_Chuột_máy_tính_Logitech_G304_LIGHTSPEED_Wireless_B_sub3.jpg', 3),
(1037, 389, N'/images/image/387_Chuột_máy_tính_Pulsar_X2_V2_Wireless_Gaming_Mouse__sub1.jpg', 1),
(1038, 389, N'/images/image/387_Chuột_máy_tính_Pulsar_X2_V2_Wireless_Gaming_Mouse__sub2.jpg', 2),
(1039, 389, N'/images/image/387_Chuột_máy_tính_Pulsar_X2_V2_Wireless_Gaming_Mouse__sub3.png', 3),
(1040, 390, N'/images/image/388_Chuột_máy_tính_Ninjutso_Sora_V2_Ultra_Lightweight__sub1.jpg', 1),
(1041, 390, N'/images/image/388_Chuột_máy_tính_Ninjutso_Sora_V2_Ultra_Lightweight__sub2.jpg', 2),
(1042, 390, N'/images/image/388_Chuột_máy_tính_Ninjutso_Sora_V2_Ultra_Lightweight__sub3.jpg', 3),
(1043, 391, N'/images/image/389_Chuột_máy_tính_LAMZU_Atlantis_OG_V2_Wireless_Gamin_sub1.jpg', 1),
(1044, 391, N'/images/image/389_Chuột_máy_tính_LAMZU_Atlantis_OG_V2_Wireless_Gamin_sub2.jpg', 2),
(1045, 391, N'/images/image/389_Chuột_máy_tính_LAMZU_Atlantis_OG_V2_Wireless_Gamin_sub3.jpeg', 3),
(1046, 392, N'/images/image/390_Chuột_máy_tính_Endgame_Gear_OP1WE_Wireless_Gaming__sub1.png', 1),
(1047, 392, N'/images/image/390_Chuột_máy_tính_Endgame_Gear_OP1WE_Wireless_Gaming__sub2.jpg', 2),
(1048, 392, N'/images/image/390_Chuột_máy_tính_Endgame_Gear_OP1WE_Wireless_Gaming__sub3.jpg', 3),
(1049, 393, N'/images/image/391_Chuột_máy_tính_VGN_Dragonfly_F1_PRO_MAX_Wireless_N_sub1.jpg', 1),
(1050, 393, N'/images/image/391_Chuột_máy_tính_VGN_Dragonfly_F1_PRO_MAX_Wireless_N_sub2.jpg', 2),
(1051, 393, N'/images/image/391_Chuột_máy_tính_VGN_Dragonfly_F1_PRO_MAX_Wireless_N_sub3.jpg', 3),
(1052, 394, N'/images/image/392_Chuột_máy_tính_VXE_R1_PRO_MAX_Ultra_Light_Wireless_sub1.jpeg', 1),
(1053, 394, N'/images/image/392_Chuột_máy_tính_VXE_R1_PRO_MAX_Ultra_Light_Wireless_sub2.jpg', 2),
(1054, 394, N'/images/image/392_Chuột_máy_tính_VXE_R1_PRO_MAX_Ultra_Light_Wireless_sub3.jpg', 3),
(1055, 395, N'/images/image/393_Chuột_máy_tính_SteelSeries_Rival_3_Wireless_Gaming_sub1.jpg', 1),
(1056, 395, N'/images/image/393_Chuột_máy_tính_SteelSeries_Rival_3_Wireless_Gaming_sub3.jpg', 3),
(1057, 396, N'/images/image/394_Chuột_máy_tính_ASUS_ROG_Harpe_Ace_Aim_Lab_Edition__sub1.jpg', 1),
(1058, 396, N'/images/image/394_Chuột_máy_tính_ASUS_ROG_Harpe_Ace_Aim_Lab_Edition__sub2.jpg', 2),
(1059, 396, N'/images/image/394_Chuột_máy_tính_ASUS_ROG_Harpe_Ace_Aim_Lab_Edition__sub3.png', 3),
(1060, 397, N'/images/image/395_Tai_nghe_gaming_HyperX_Cloud_II_Wireless_Red_Black_sub1.jpg', 1),
(1061, 397, N'/images/image/395_Tai_nghe_gaming_HyperX_Cloud_II_Wireless_Red_Black_sub2.jpg', 2),
(1062, 397, N'/images/image/395_Tai_nghe_gaming_HyperX_Cloud_II_Wireless_Red_Black_sub3.jpg', 3),
(1063, 398, N'/images/image/396_Tai_nghe_gaming_Razer_BlackShark_V2_X_7.1_Surround_sub1.jpg', 1),
(1064, 398, N'/images/image/396_Tai_nghe_gaming_Razer_BlackShark_V2_X_7.1_Surround_sub2.jpg', 2),
(1065, 398, N'/images/image/396_Tai_nghe_gaming_Razer_BlackShark_V2_X_7.1_Surround_sub3.jpg', 3),
(1066, 399, N'/images/image/397_Tai_nghe_gaming_Corsair_HS80_RGB_Wireless_Spatial__sub1.jpg', 1),
(1067, 399, N'/images/image/397_Tai_nghe_gaming_Corsair_HS80_RGB_Wireless_Spatial__sub3.jpg', 3),
(1068, 400, N'/images/image/398_Tai_nghe_gaming_Logitech_G435_LIGHTSPEED_Ultra-Lig_sub1.jpg', 1),
(1069, 400, N'/images/image/398_Tai_nghe_gaming_Logitech_G435_LIGHTSPEED_Ultra-Lig_sub2.png', 2),
(1070, 400, N'/images/image/398_Tai_nghe_gaming_Logitech_G435_LIGHTSPEED_Ultra-Lig_sub3.jpg', 3),
(1071, 401, N'/images/image/399_Tai_nghe_gaming_SteelSeries_Arctis_Nova_7_Wireless_sub1.jpg', 1),
(1072, 401, N'/images/image/399_Tai_nghe_gaming_SteelSeries_Arctis_Nova_7_Wireless_sub2.jpg', 2),
(1073, 401, N'/images/image/399_Tai_nghe_gaming_SteelSeries_Arctis_Nova_7_Wireless_sub3.jpg', 3),
(1074, 402, N'/images/image/400_Tai_nghe_gaming_EPOS_Sennheiser_GSP_300_Closed_Aco_sub1.jpeg', 1),
(1075, 402, N'/images/image/400_Tai_nghe_gaming_EPOS_Sennheiser_GSP_300_Closed_Aco_sub2.png', 2),
(1076, 403, N'/images/image/401_Tai_nghe_gaming_Audio-Technica_ATH-GDL3_Open-Back__sub1.jpg', 1),
(1077, 403, N'/images/image/401_Tai_nghe_gaming_Audio-Technica_ATH-GDL3_Open-Back__sub2.png', 2),
(1078, 403, N'/images/image/401_Tai_nghe_gaming_Audio-Technica_ATH-GDL3_Open-Back__sub3.jpg', 3),
(1079, 404, N'/images/image/402_Tai_nghe_gaming_JBL_Quantum_400_USB_Wired_Gaming_H_sub1.png', 1),
(1080, 404, N'/images/image/402_Tai_nghe_gaming_JBL_Quantum_400_USB_Wired_Gaming_H_sub2.jpg', 2),
(1081, 404, N'/images/image/402_Tai_nghe_gaming_JBL_Quantum_400_USB_Wired_Gaming_H_sub3.png', 3),
(1082, 405, N'/images/image/403_Tai_nghe_gaming_ASUS_ROG_Delta_S_Wireless_Gaming_H_sub1.jpg', 1),
(1083, 405, N'/images/image/403_Tai_nghe_gaming_ASUS_ROG_Delta_S_Wireless_Gaming_H_sub2.jpg', 2),
(1084, 405, N'/images/image/403_Tai_nghe_gaming_ASUS_ROG_Delta_S_Wireless_Gaming_H_sub3.png', 3),
(1085, 406, N'/images/image/404_Tai_nghe_gaming_EKSA_E900_Pro_7.1_Surround_Sound_W_sub1.png', 1),
(1086, 406, N'/images/image/404_Tai_nghe_gaming_EKSA_E900_Pro_7.1_Surround_Sound_W_sub2.jpg', 2),
(1087, 406, N'/images/image/404_Tai_nghe_gaming_EKSA_E900_Pro_7.1_Surround_Sound_W_sub3.jpg', 3),
(1088, 407, N'/images/image/405_Thẻ_nhớ_MicroSD_Sandisk_Ultra_32GB_Class_10_120MB__sub1.jpg', 1),
(1089, 407, N'/images/image/405_Thẻ_nhớ_MicroSD_Sandisk_Ultra_32GB_Class_10_120MB__sub2.jpg', 2),
(1090, 407, N'/images/image/405_Thẻ_nhớ_MicroSD_Sandisk_Ultra_32GB_Class_10_120MB__sub3.jpg', 3),
(1091, 408, N'/images/image/406_Thẻ_nhớ_MicroSD_Sandisk_High_Endurance_64GB_Chuyên_sub1.jpg', 1),
(1092, 408, N'/images/image/406_Thẻ_nhớ_MicroSD_Sandisk_High_Endurance_64GB_Chuyên_sub2.jpg', 2),
(1093, 408, N'/images/image/406_Thẻ_nhớ_MicroSD_Sandisk_High_Endurance_64GB_Chuyên_sub3.jpg', 3),
(1094, 409, N'/images/image/407_Thẻ_nhớ_SDXC_SanDisk_Extreme_PRO_64GB_UHS-I_200MB__sub1.jpg', 1),
(1095, 409, N'/images/image/407_Thẻ_nhớ_SDXC_SanDisk_Extreme_PRO_64GB_UHS-I_200MB__sub2.jpg', 2),
(1096, 409, N'/images/image/407_Thẻ_nhớ_SDXC_SanDisk_Extreme_PRO_64GB_UHS-I_200MB__sub3.jpg', 3),
(1097, 410, N'/images/image/408_Thẻ_nhớ_MicroSD_Samsung_EVO_Plus_64GB_kèm_Adapter_sub1.jpg', 1),
(1098, 410, N'/images/image/408_Thẻ_nhớ_MicroSD_Samsung_EVO_Plus_64GB_kèm_Adapter_sub2.jpg', 2),
(1099, 410, N'/images/image/408_Thẻ_nhớ_MicroSD_Samsung_EVO_Plus_64GB_kèm_Adapter_sub3.jpg', 3),
(1100, 411, N'/images/image/409_Thẻ_nhớ_MicroSD_Samsung_EVO_Plus_128GB_UHS-I_U3_sub1.jpg', 1),
(1101, 411, N'/images/image/409_Thẻ_nhớ_MicroSD_Samsung_EVO_Plus_128GB_UHS-I_U3_sub2.webp', 2),
(1102, 412, N'/images/image/410_Thẻ_nhớ_MicroSD_Kingston_Canvas_Select_Plus_64GB_sub1.jpg', 1),
(1103, 412, N'/images/image/410_Thẻ_nhớ_MicroSD_Kingston_Canvas_Select_Plus_64GB_sub2.png', 2),
(1104, 412, N'/images/image/410_Thẻ_nhớ_MicroSD_Kingston_Canvas_Select_Plus_64GB_sub3.webp', 3),
(1105, 413, N'/images/image/411_Thẻ_nhớ_MicroSD_Kingston_Canvas_Select_Plus_256GB_sub1.png', 1),
(1106, 413, N'/images/image/411_Thẻ_nhớ_MicroSD_Kingston_Canvas_Select_Plus_256GB_sub2.png', 2),
(1107, 413, N'/images/image/411_Thẻ_nhớ_MicroSD_Kingston_Canvas_Select_Plus_256GB_sub3.webp', 3),
(1108, 414, N'/images/image/412_Thẻ_nhớ_SDXC_Lexar_Professional_1667x_128GB_SDXC_U_sub1.jpg', 1),
(1109, 414, N'/images/image/412_Thẻ_nhớ_SDXC_Lexar_Professional_1667x_128GB_SDXC_U_sub2.jpg', 2),
(1110, 414, N'/images/image/412_Thẻ_nhớ_SDXC_Lexar_Professional_1667x_128GB_SDXC_U_sub3.jpg', 3),
(1111, 415, N'/images/image/413_Thẻ_nhớ_MicroSD_Lexar_Play_256GB_UHS-I_cho_Nintend_sub1.jpg', 1),
(1112, 415, N'/images/image/413_Thẻ_nhớ_MicroSD_Lexar_Play_256GB_UHS-I_cho_Nintend_sub2.jpg', 2),
(1113, 415, N'/images/image/413_Thẻ_nhớ_MicroSD_Lexar_Play_256GB_UHS-I_cho_Nintend_sub3.jpg', 3),
(1114, 416, N'/images/image/414_Thẻ_nhớ_SDXC_Sony_SF-E_Series_64GB_UHS-II_270MB_s_sub1.jpg', 1),
(1115, 416, N'/images/image/414_Thẻ_nhớ_SDXC_Sony_SF-E_Series_64GB_UHS-II_270MB_s_sub2.jpg', 2),
(1116, 416, N'/images/image/414_Thẻ_nhớ_SDXC_Sony_SF-E_Series_64GB_UHS-II_270MB_s_sub3.jpg', 3),
(1117, 417, N'/images/image/415_Thẻ_nhớ_SDXC_Sony_TOUGH_M_Series_128GB_UHS-II_270M_sub1.jpg', 1),
(1118, 417, N'/images/image/415_Thẻ_nhớ_SDXC_Sony_TOUGH_M_Series_128GB_UHS-II_270M_sub2.jpg', 2),
(1119, 417, N'/images/image/415_Thẻ_nhớ_SDXC_Sony_TOUGH_M_Series_128GB_UHS-II_270M_sub3.jpg', 3),
(1120, 418, N'/images/image/416_Thẻ_nhớ_MicroSD_Kioxia_Exceria_G2_256GB_NVMe_Class_sub2.png', 2),
(1121, 418, N'/images/image/416_Thẻ_nhớ_MicroSD_Kioxia_Exceria_G2_256GB_NVMe_Class_sub3.jpg', 3),
(1122, 419, N'/images/image/417_Thẻ_nhớ_SDXC_Transcend_700S_64GB_SDXC_UHS-II_V90_2_sub1.jpg', 1),
(1123, 419, N'/images/image/417_Thẻ_nhớ_SDXC_Transcend_700S_64GB_SDXC_UHS-II_V90_2_sub2.webp', 2),
(1124, 419, N'/images/image/417_Thẻ_nhớ_SDXC_Transcend_700S_64GB_SDXC_UHS-II_V90_2_sub3.jpg', 3),
(1125, 420, N'/images/image/418_Thẻ_nhớ_MicroSD_TeamGroup_PRO_Endurance_128GB_sub1.jpg', 1),
(1126, 420, N'/images/image/418_Thẻ_nhớ_MicroSD_TeamGroup_PRO_Endurance_128GB_sub2.jpg', 2),
(1127, 420, N'/images/image/418_Thẻ_nhớ_MicroSD_TeamGroup_PRO_Endurance_128GB_sub3.jpg', 3),
(1128, 421, N'/images/image/419_Thẻ_nhớ_SDXC_ProGrade_Digital_SDXC_UHS-II_V90_Coba_sub1.jpg', 1),
(1129, 421, N'/images/image/419_Thẻ_nhớ_SDXC_ProGrade_Digital_SDXC_UHS-II_V90_Coba_sub2.jpg', 2),
(1130, 421, N'/images/image/419_Thẻ_nhớ_SDXC_ProGrade_Digital_SDXC_UHS-II_V90_Coba_sub3.jpg', 3),
(1131, 422, N'/images/image/420_Ổ_cứng_di_động_SSD_WD_My_Passport_SSD_1TB_USB_3.2__sub1.jpg', 1),
(1132, 422, N'/images/image/420_Ổ_cứng_di_động_SSD_WD_My_Passport_SSD_1TB_USB_3.2__sub2.jpg', 2),
(1133, 422, N'/images/image/420_Ổ_cứng_di_động_SSD_WD_My_Passport_SSD_1TB_USB_3.2__sub3.jpg', 3),
(1134, 423, N'/images/image/421_Ổ_cứng_di_động_SSD_WD_Black_P50_Game_Drive_1TB_NVM_sub1.jpg', 1),
(1135, 423, N'/images/image/421_Ổ_cứng_di_động_SSD_WD_Black_P50_Game_Drive_1TB_NVM_sub2.png', 2),
(1136, 423, N'/images/image/421_Ổ_cứng_di_động_SSD_WD_Black_P50_Game_Drive_1TB_NVM_sub3.jpg', 3),
(1137, 424, N'/images/image/422_Ổ_cứng_di_động_HDD_WD_Elements_Portable_1TB_2.5_in_sub1.jpg', 1),
(1138, 424, N'/images/image/422_Ổ_cứng_di_động_HDD_WD_Elements_Portable_1TB_2.5_in_sub2.png', 2),
(1139, 424, N'/images/image/422_Ổ_cứng_di_động_HDD_WD_Elements_Portable_1TB_2.5_in_sub3.png', 3),
(1140, 425, N'/images/image/423_Ổ_cứng_di_động_HDD_WD_Elements_Portable_4TB_2.5_in_sub1.png', 1),
(1141, 425, N'/images/image/423_Ổ_cứng_di_động_HDD_WD_Elements_Portable_4TB_2.5_in_sub2.jpg', 2),
(1142, 426, N'/images/image/424_Ổ_cứng_di_động_SSD_Samsung_T7_Portable_1TB_USB_3.2_sub1.png', 1),
(1143, 426, N'/images/image/424_Ổ_cứng_di_động_SSD_Samsung_T7_Portable_1TB_USB_3.2_sub2.jpg', 2),
(1144, 426, N'/images/image/424_Ổ_cứng_di_động_SSD_Samsung_T7_Portable_1TB_USB_3.2_sub3.jpg', 3),
(1145, 427, N'/images/image/425_Ổ_cứng_di_động_SSD_Samsung_T9_Portable_2TB_USB_3.2_sub1.jpg', 1),
(1146, 427, N'/images/image/425_Ổ_cứng_di_động_SSD_Samsung_T9_Portable_2TB_USB_3.2_sub2.jpg', 2),
(1147, 427, N'/images/image/425_Ổ_cứng_di_động_SSD_Samsung_T9_Portable_2TB_USB_3.2_sub3.png', 3),
(1148, 428, N'/images/image/426_Ổ_cứng_di_động_SSD_SanDisk_Extreme_PRO_Portable_2T_sub2.jpg', 2),
(1149, 428, N'/images/image/426_Ổ_cứng_di_động_SSD_SanDisk_Extreme_PRO_Portable_2T_sub3.jpg', 3),
(1150, 429, N'/images/image/427_Ổ_cứng_di_động_HDD_Seagate_One_Touch_2TB_2.5_inch__sub1.jpg', 1),
(1151, 429, N'/images/image/427_Ổ_cứng_di_động_HDD_Seagate_One_Touch_2TB_2.5_inch__sub2.jpg', 2),
(1152, 429, N'/images/image/427_Ổ_cứng_di_động_HDD_Seagate_One_Touch_2TB_2.5_inch__sub3.jpg', 3),
(1153, 430, N'/images/image/428_Ổ_cứng_di_động_HDD_Seagate_Basic_1TB_2.5_inch_USB__sub1.jpg', 1),
(1154, 430, N'/images/image/428_Ổ_cứng_di_động_HDD_Seagate_Basic_1TB_2.5_inch_USB__sub2.jpg', 2),
(1155, 430, N'/images/image/428_Ổ_cứng_di_động_HDD_Seagate_Basic_1TB_2.5_inch_USB__sub3.jpg', 3),
(1156, 431, N'/images/image/429_Ổ_cứng_di_động_SSD_Crucial_X6_Portable_SSD_2TB_800_sub1.jpg', 1),
(1157, 431, N'/images/image/429_Ổ_cứng_di_động_SSD_Crucial_X6_Portable_SSD_2TB_800_sub2.jpg', 2),
(1158, 431, N'/images/image/429_Ổ_cứng_di_động_SSD_Crucial_X6_Portable_SSD_2TB_800_sub3.jpg', 3),
(1159, 432, N'/images/image/430_Ổ_cứng_di_động_SSD_Crucial_X10_Pro_2TB_USB_3.2_Gen_sub1.webp', 1),
(1160, 432, N'/images/image/430_Ổ_cứng_di_động_SSD_Crucial_X10_Pro_2TB_USB_3.2_Gen_sub2.jpg', 2),
(1161, 432, N'/images/image/430_Ổ_cứng_di_động_SSD_Crucial_X10_Pro_2TB_USB_3.2_Gen_sub3.jpg', 3),
(1162, 433, N'/images/image/431_Ổ_cứng_di_động_SSD_Kingston_XS1000_2TB_External_SS_sub1.jpg', 1),
(1163, 433, N'/images/image/431_Ổ_cứng_di_động_SSD_Kingston_XS1000_2TB_External_SS_sub2.jpg', 2),
(1164, 433, N'/images/image/431_Ổ_cứng_di_động_SSD_Kingston_XS1000_2TB_External_SS_sub3.jpg', 3),
(1165, 434, N'/images/image/432_Tản_nhiệt_nước_AIO_Corsair_H100i_RGB_ELITE_240mm_sub1.jpg', 1),
(1166, 434, N'/images/image/432_Tản_nhiệt_nước_AIO_Corsair_H100i_RGB_ELITE_240mm_sub2.png', 2),
(1167, 434, N'/images/image/432_Tản_nhiệt_nước_AIO_Corsair_H100i_RGB_ELITE_240mm_sub3.jpg', 3),
(1168, 435, N'/images/image/433_Tản_nhiệt_nước_AIO_Corsair_iCUE_LINK_H100i_RGB_Whi_sub1.jpg', 1),
(1169, 435, N'/images/image/433_Tản_nhiệt_nước_AIO_Corsair_iCUE_LINK_H100i_RGB_Whi_sub2.jpg', 2),
(1170, 435, N'/images/image/433_Tản_nhiệt_nước_AIO_Corsair_iCUE_LINK_H100i_RGB_Whi_sub3.png', 3),
(1171, 436, N'/images/image/434_Tản_nhiệt_nước_AIO_NZXT_Kraken_240_RGB_Black_LCD_sub1.jpg', 1),
(1172, 436, N'/images/image/434_Tản_nhiệt_nước_AIO_NZXT_Kraken_240_RGB_Black_LCD_sub2.jpg', 2),
(1173, 436, N'/images/image/434_Tản_nhiệt_nước_AIO_NZXT_Kraken_240_RGB_Black_LCD_sub3.jpg', 3),
(1174, 437, N'/images/image/435_Tản_nhiệt_nước_AIO_NZXT_Kraken_360_RGB_Black_LCD_sub1.jpg', 1),
(1175, 437, N'/images/image/435_Tản_nhiệt_nước_AIO_NZXT_Kraken_360_RGB_Black_LCD_sub2.jpg', 2),
(1176, 437, N'/images/image/435_Tản_nhiệt_nước_AIO_NZXT_Kraken_360_RGB_Black_LCD_sub3.png', 3),
(1177, 438, N'/images/image/436_Tản_nhiệt_nước_AIO_ASUS_ROG_Strix_LC_III_360_ARGB_sub1.webp', 1),
(1178, 438, N'/images/image/436_Tản_nhiệt_nước_AIO_ASUS_ROG_Strix_LC_III_360_ARGB_sub2.jpg', 2),
(1179, 438, N'/images/image/436_Tản_nhiệt_nước_AIO_ASUS_ROG_Strix_LC_III_360_ARGB_sub3.webp', 3),
(1180, 439, N'/images/image/437_Tản_nhiệt_nước_AIO_ASUS_TUF_Gaming_LC_II_360_ARGB_sub1.jpg', 1),
(1181, 439, N'/images/image/437_Tản_nhiệt_nước_AIO_ASUS_TUF_Gaming_LC_II_360_ARGB_sub2.jpg', 2),
(1182, 439, N'/images/image/437_Tản_nhiệt_nước_AIO_ASUS_TUF_Gaming_LC_II_360_ARGB_sub3.jpg', 3),
(1183, 440, N'/images/image/438_Tản_nhiệt_nước_AIO_DeepCool_LS720_SE_360mm_ARGB_Bl_sub1.jpg', 1),
(1184, 440, N'/images/image/438_Tản_nhiệt_nước_AIO_DeepCool_LS720_SE_360mm_ARGB_Bl_sub2.jpg', 2),
(1185, 441, N'/images/image/439_Tản_nhiệt_nước_AIO_DeepCool_MYSTIQUE_360_Màn_hình__sub1.jpg', 1),
(1186, 441, N'/images/image/439_Tản_nhiệt_nước_AIO_DeepCool_MYSTIQUE_360_Màn_hình__sub2.jpg', 2),
(1187, 441, N'/images/image/439_Tản_nhiệt_nước_AIO_DeepCool_MYSTIQUE_360_Màn_hình__sub3.jpg', 3),
(1188, 442, N'/images/image/440_Tản_nhiệt_nước_AIO_Thermalright_Frozen_Warframe_36_sub1.jpeg', 1),
(1189, 442, N'/images/image/440_Tản_nhiệt_nước_AIO_Thermalright_Frozen_Warframe_36_sub2.jpg', 2),
(1190, 442, N'/images/image/440_Tản_nhiệt_nước_AIO_Thermalright_Frozen_Warframe_36_sub3.png', 3),
(1191, 443, N'/images/image/441_Tản_nhiệt_nước_AIO_Lian_Li_Galahad_II_LCD_360_SL-I_sub1.jpg', 1),
(1192, 443, N'/images/image/441_Tản_nhiệt_nước_AIO_Lian_Li_Galahad_II_LCD_360_SL-I_sub2.png', 2),
(1193, 443, N'/images/image/441_Tản_nhiệt_nước_AIO_Lian_Li_Galahad_II_LCD_360_SL-I_sub3.png', 3),
(1194, 444, N'/images/image/442_Tản_nhiệt_nước_AIO_MSI_MAG_CORELIQUID_240R_V2_sub1.png', 1),
(1195, 444, N'/images/image/442_Tản_nhiệt_nước_AIO_MSI_MAG_CORELIQUID_240R_V2_sub2.png', 2),
(1196, 444, N'/images/image/442_Tản_nhiệt_nước_AIO_MSI_MAG_CORELIQUID_240R_V2_sub3.jpg', 3),
(1197, 445, N'/images/image/443_Tản_nhiệt_nước_AIO_ID-COOLING_FROSTFLOW_X_240_Snow_sub1.jpg', 1),
(1198, 445, N'/images/image/443_Tản_nhiệt_nước_AIO_ID-COOLING_FROSTFLOW_X_240_Snow_sub2.jpg', 2),
(1199, 445, N'/images/image/443_Tản_nhiệt_nước_AIO_ID-COOLING_FROSTFLOW_X_240_Snow_sub3.jpg', 3),
(1200, 446, N'/images/image/444_Card_màn_hình_ASUS_ROG_Strix_GeForce_RTX_4090_OC_E_sub1.jpg', 1),
(1201, 446, N'/images/image/444_Card_màn_hình_ASUS_ROG_Strix_GeForce_RTX_4090_OC_E_sub2.png', 2),
(1202, 446, N'/images/image/444_Card_màn_hình_ASUS_ROG_Strix_GeForce_RTX_4090_OC_E_sub3.jpg', 3),
(1203, 447, N'/images/image/445_Card_màn_hình_MSI_GeForce_RTX_4080_SUPER_16G_GAMIN_sub1.jpg', 1),
(1204, 447, N'/images/image/445_Card_màn_hình_MSI_GeForce_RTX_4080_SUPER_16G_GAMIN_sub2.jpg', 2),
(1205, 447, N'/images/image/445_Card_màn_hình_MSI_GeForce_RTX_4080_SUPER_16G_GAMIN_sub3.png', 3),
(1206, 448, N'/images/image/446_Card_màn_hình_GIGABYTE_GeForce_RTX_4060_EAGLE_OC_8_sub1.webp', 1),
(1207, 448, N'/images/image/446_Card_màn_hình_GIGABYTE_GeForce_RTX_4060_EAGLE_OC_8_sub2.png', 2),
(1208, 448, N'/images/image/446_Card_màn_hình_GIGABYTE_GeForce_RTX_4060_EAGLE_OC_8_sub3.png', 3),
(1209, 449, N'/images/image/447_Card_màn_hình_GIGABYTE_GeForce_RTX_3050_WINDFORCE__sub1.png', 1),
(1210, 449, N'/images/image/447_Card_màn_hình_GIGABYTE_GeForce_RTX_3050_WINDFORCE__sub2.jpg', 2),
(1211, 450, N'/images/image/448_Card_màn_hình_ASUS_Dual_GeForce_RTX_4060_Ti_EVO_OC_sub1.jpg', 1),
(1212, 450, N'/images/image/448_Card_màn_hình_ASUS_Dual_GeForce_RTX_4060_Ti_EVO_OC_sub2.jpg', 2),
(1213, 450, N'/images/image/448_Card_màn_hình_ASUS_Dual_GeForce_RTX_4060_Ti_EVO_OC_sub3.jpg', 3),
(1214, 451, N'/images/image/449_Card_màn_hình_ZOTAC_GAMING_GeForce_RTX_3060_Twin_E_sub1.jpg', 1),
(1215, 451, N'/images/image/449_Card_màn_hình_ZOTAC_GAMING_GeForce_RTX_3060_Twin_E_sub2.jpg', 2),
(1216, 451, N'/images/image/449_Card_màn_hình_ZOTAC_GAMING_GeForce_RTX_3060_Twin_E_sub3.jpg', 3),
(1217, 452, N'/images/image/450_Card_màn_hình_Sapphire_PULSE_AMD_Radeon_RX_7600_8G_sub2.jpg', 2),
(1218, 452, N'/images/image/450_Card_màn_hình_Sapphire_PULSE_AMD_Radeon_RX_7600_8G_sub3.jpg', 3),
(1219, 453, N'/images/image/451_Card_màn_hình_PowerColor_Fighter_AMD_Radeon_RX_660_sub1.jpg', 1),
(1220, 453, N'/images/image/451_Card_màn_hình_PowerColor_Fighter_AMD_Radeon_RX_660_sub2.png', 2),
(1221, 453, N'/images/image/451_Card_màn_hình_PowerColor_Fighter_AMD_Radeon_RX_660_sub3.png', 3),
(1222, 454, N'/images/image/452_Card_màn_hình_ASRock_Challenger_Radeon_RX_7800_XT__sub1.png', 1),
(1223, 454, N'/images/image/452_Card_màn_hình_ASRock_Challenger_Radeon_RX_7800_XT__sub2.jpg', 2),
(1224, 454, N'/images/image/452_Card_màn_hình_ASRock_Challenger_Radeon_RX_7800_XT__sub3.png', 3),
(1225, 455, N'/images/image/453_Card_màn_hình_COLORFUL_GeForce_GTX_1650_NB_4GD6-V_sub1.jpg', 1),
(1226, 455, N'/images/image/453_Card_màn_hình_COLORFUL_GeForce_GTX_1650_NB_4GD6-V_sub2.jpg', 2),
(1227, 455, N'/images/image/453_Card_màn_hình_COLORFUL_GeForce_GTX_1650_NB_4GD6-V_sub3.jpg', 3),
(1228, 456, N'/images/image/454_Ổ_cứng_HDD_PC_Western_Digital_Purple_2TB_3.5_inch__sub1.jpg', 1),
(1229, 456, N'/images/image/454_Ổ_cứng_HDD_PC_Western_Digital_Purple_2TB_3.5_inch__sub2.jpg', 2),
(1230, 456, N'/images/image/454_Ổ_cứng_HDD_PC_Western_Digital_Purple_2TB_3.5_inch__sub3.jpg', 3),
(1231, 457, N'/images/image/455_Ổ_cứng_HDD_PC_Western_Digital_Purple_4TB_3.5_inch__sub1.jpg', 1),
(1232, 457, N'/images/image/455_Ổ_cứng_HDD_PC_Western_Digital_Purple_4TB_3.5_inch__sub2.jpg', 2),
(1233, 457, N'/images/image/455_Ổ_cứng_HDD_PC_Western_Digital_Purple_4TB_3.5_inch__sub3.webp', 3),
(1234, 458, N'/images/image/456_Ổ_cứng_HDD_PC_Western_Digital_Purple_6TB_3.5_inch__sub1.jpg', 1),
(1235, 458, N'/images/image/456_Ổ_cứng_HDD_PC_Western_Digital_Purple_6TB_3.5_inch__sub3.png', 3),
(1236, 459, N'/images/image/457_Ổ_cứng_HDD_PC_Seagate_SkyHawk_2TB_3.5_inch_Surveil_sub1.jpg', 1),
(1237, 459, N'/images/image/457_Ổ_cứng_HDD_PC_Seagate_SkyHawk_2TB_3.5_inch_Surveil_sub2.jpg', 2),
(1238, 459, N'/images/image/457_Ổ_cứng_HDD_PC_Seagate_SkyHawk_2TB_3.5_inch_Surveil_sub3.jpg', 3),
(1239, 460, N'/images/image/458_Ổ_cứng_HDD_PC_Seagate_SkyHawk_6TB_3.5_inch_Surveil_sub1.jpg', 1),
(1240, 460, N'/images/image/458_Ổ_cứng_HDD_PC_Seagate_SkyHawk_6TB_3.5_inch_Surveil_sub2.webp', 2),
(1241, 461, N'/images/image/459_Ổ_cứng_HDD_Server_Seagate_IronWolf_Pro_8TB_3.5_inc_sub1.jpg', 1),
(1242, 461, N'/images/image/459_Ổ_cứng_HDD_Server_Seagate_IronWolf_Pro_8TB_3.5_inc_sub2.jpg', 2),
(1243, 461, N'/images/image/459_Ổ_cứng_HDD_Server_Seagate_IronWolf_Pro_8TB_3.5_inc_sub3.png', 3),
(1244, 462, N'/images/image/460_Ổ_cứng_HDD_Server_Seagate_IronWolf_Pro_12TB_3.5_in_sub1.jpg', 1),
(1245, 462, N'/images/image/460_Ổ_cứng_HDD_Server_Seagate_IronWolf_Pro_12TB_3.5_in_sub3.jpg', 3),
(1246, 463, N'/images/image/461_Ổ_cứng_HDD_Server_Western_Digital_Red_Pro_8TB_3.5__sub1.jpg', 1),
(1247, 463, N'/images/image/461_Ổ_cứng_HDD_Server_Western_Digital_Red_Pro_8TB_3.5__sub2.jpg', 2),
(1248, 463, N'/images/image/461_Ổ_cứng_HDD_Server_Western_Digital_Red_Pro_8TB_3.5__sub3.jpg', 3),
(1249, 464, N'/images/image/462_Ổ_cứng_HDD_Enterprise_Seagate_Exos_X16_14TB_3.5_in_sub1.jpg', 1),
(1250, 464, N'/images/image/462_Ổ_cứng_HDD_Enterprise_Seagate_Exos_X16_14TB_3.5_in_sub2.jpg', 2),
(1251, 464, N'/images/image/462_Ổ_cứng_HDD_Enterprise_Seagate_Exos_X16_14TB_3.5_in_sub3.jpg', 3),
(1252, 465, N'/images/image/463_Ổ_cứng_HDD_Enterprise_Western_Digital_Ultrastar_DC_sub1.png', 1),
(1253, 465, N'/images/image/463_Ổ_cứng_HDD_Enterprise_Western_Digital_Ultrastar_DC_sub2.png', 2),
(1254, 465, N'/images/image/463_Ổ_cứng_HDD_Enterprise_Western_Digital_Ultrastar_DC_sub3.jpg', 3),
(1255, 466, N'/images/image/464_Ổ_cứng_HDD_PC_Toshiba_Canvio_Basics_1TB_2.5_inch_sub1.jpg', 1),
(1256, 466, N'/images/image/464_Ổ_cứng_HDD_PC_Toshiba_Canvio_Basics_1TB_2.5_inch_sub2.jpg', 2),
(1257, 466, N'/images/image/464_Ổ_cứng_HDD_PC_Toshiba_Canvio_Basics_1TB_2.5_inch_sub3.jpg', 3),
(1258, 467, N'/images/image/465_Ổ_cứng_HDD_PC_Toshiba_Surveillance_S300_4TB_3.5_in_sub1.jpg', 1),
(1259, 467, N'/images/image/465_Ổ_cứng_HDD_PC_Toshiba_Surveillance_S300_4TB_3.5_in_sub2.jpg', 2),
(1260, 467, N'/images/image/465_Ổ_cứng_HDD_PC_Toshiba_Surveillance_S300_4TB_3.5_in_sub3.jpg', 3),
(1261, 468, N'/images/image/466_Ổ_cứng_HDD_Laptop_Western_Digital_Blue_1TB_2.5_inc_sub1.jpg', 1),
(1262, 468, N'/images/image/466_Ổ_cứng_HDD_Laptop_Western_Digital_Blue_1TB_2.5_inc_sub2.jpg', 2),
(1263, 468, N'/images/image/466_Ổ_cứng_HDD_Laptop_Western_Digital_Blue_1TB_2.5_inc_sub3.jpg', 3),
(1264, 469, N'/images/image/467_Nguồn_Corsair_RM850e_ATX_3.0_80_Plus_Gold_Full_Mod_sub1.jpg', 1),
(1265, 469, N'/images/image/467_Nguồn_Corsair_RM850e_ATX_3.0_80_Plus_Gold_Full_Mod_sub2.png', 2),
(1266, 469, N'/images/image/467_Nguồn_Corsair_RM850e_ATX_3.0_80_Plus_Gold_Full_Mod_sub3.jpg', 3),
(1267, 470, N'/images/image/468_Nguồn_Corsair_RM1000x_Shift_80_Plus_Gold_Full_Modu_sub2.jpg', 2),
(1268, 470, N'/images/image/468_Nguồn_Corsair_RM1000x_Shift_80_Plus_Gold_Full_Modu_sub3.jpg', 3),
(1269, 471, N'/images/image/469_Nguồn_Corsair_CV650_650W_80_Plus_Bronze_sub1.jpeg', 1),
(1270, 471, N'/images/image/469_Nguồn_Corsair_CV650_650W_80_Plus_Bronze_sub2.jpg', 2),
(1271, 471, N'/images/image/469_Nguồn_Corsair_CV650_650W_80_Plus_Bronze_sub3.png', 3),
(1272, 472, N'/images/image/470_Nguồn_MSI_MAG_A650BN_650W_80_Plus_Bronze_sub1.jpg', 1),
(1273, 472, N'/images/image/470_Nguồn_MSI_MAG_A650BN_650W_80_Plus_Bronze_sub2.jpg', 2),
(1274, 472, N'/images/image/470_Nguồn_MSI_MAG_A650BN_650W_80_Plus_Bronze_sub3.jpg', 3),
(1275, 473, N'/images/image/471_Nguồn_MSI_MEG_Ai1300P_PCIE5_1300W_80_Plus_Platinum_sub1.webp', 1),
(1276, 473, N'/images/image/471_Nguồn_MSI_MEG_Ai1300P_PCIE5_1300W_80_Plus_Platinum_sub3.jpg', 3),
(1277, 474, N'/images/image/472_Nguồn_ASUS_ROG_Thor_1000W_Platinum_II_OLED_sub1.webp', 1),
(1278, 474, N'/images/image/472_Nguồn_ASUS_ROG_Thor_1000W_Platinum_II_OLED_sub2.jpg', 2),
(1279, 474, N'/images/image/472_Nguồn_ASUS_ROG_Thor_1000W_Platinum_II_OLED_sub3.webp', 3),
(1280, 475, N'/images/image/473_Nguồn_ASUS_TUF_Gaming_650B_650W_80_Plus_Bronze_sub1.jpg', 1),
(1281, 475, N'/images/image/473_Nguồn_ASUS_TUF_Gaming_650B_650W_80_Plus_Bronze_sub2.jpg', 2),
(1282, 475, N'/images/image/473_Nguồn_ASUS_TUF_Gaming_650B_650W_80_Plus_Bronze_sub3.jpg', 3),
(1283, 476, N'/images/image/474_Nguồn_Cooler_Master_Elite_V3_600W_230V_sub1.jpg', 1),
(1284, 476, N'/images/image/474_Nguồn_Cooler_Master_Elite_V3_600W_230V_sub2.jpg', 2),
(1285, 476, N'/images/image/474_Nguồn_Cooler_Master_Elite_V3_600W_230V_sub3.jpg', 3),
(1286, 477, N'/images/image/475_Nguồn_DeepCool_PK650D_650W_80_Plus_Bronze_sub2.png', 2),
(1287, 477, N'/images/image/475_Nguồn_DeepCool_PK650D_650W_80_Plus_Bronze_sub3.jpg', 3),
(1288, 478, N'/images/image/476_Nguồn_ASRock_Phantom_Gaming_PG-850G_850W_80_Plus_G_sub1.jpg', 1),
(1289, 478, N'/images/image/476_Nguồn_ASRock_Phantom_Gaming_PG-850G_850W_80_Plus_G_sub3.jpg', 3),
(1290, 479, N'/images/image/477_Vỏ_case_NZXT_H9_Flow_Dual-Chamber_ATX_Mid-Tower_Bl_sub1.png', 1),
(1291, 479, N'/images/image/477_Vỏ_case_NZXT_H9_Flow_Dual-Chamber_ATX_Mid-Tower_Bl_sub2.jpg', 2),
(1292, 479, N'/images/image/477_Vỏ_case_NZXT_H9_Flow_Dual-Chamber_ATX_Mid-Tower_Bl_sub3.jpg', 3),
(1293, 480, N'/images/image/478_Vỏ_case_NZXT_H5_Flow_RGB_Compact_Mid-Tower_White_sub1.jpg', 1),
(1294, 480, N'/images/image/478_Vỏ_case_NZXT_H5_Flow_RGB_Compact_Mid-Tower_White_sub2.jpg', 2),
(1295, 480, N'/images/image/478_Vỏ_case_NZXT_H5_Flow_RGB_Compact_Mid-Tower_White_sub3.jpg', 3),
(1296, 481, N'/images/image/479_Vỏ_case_Lian_Li_O11_Dynamic_EVO_XL_Full_Tower_Blac_sub1.jpg', 1),
(1297, 481, N'/images/image/479_Vỏ_case_Lian_Li_O11_Dynamic_EVO_XL_Full_Tower_Blac_sub3.jpg', 3),
(1298, 482, N'/images/image/480_Vỏ_case_Lian_Li_Lancool_216_ARGB_Mid-Tower_Black_sub1.jpg', 1),
(1299, 482, N'/images/image/480_Vỏ_case_Lian_Li_Lancool_216_ARGB_Mid-Tower_Black_sub2.jpg', 2),
(1300, 482, N'/images/image/480_Vỏ_case_Lian_Li_Lancool_216_ARGB_Mid-Tower_Black_sub3.jpg', 3),
(1301, 483, N'/images/image/481_Vỏ_case_Corsair_3500X_ARGB_Mid-Tower_Glass_Black_sub1.jpg', 1),
(1302, 483, N'/images/image/481_Vỏ_case_Corsair_3500X_ARGB_Mid-Tower_Glass_Black_sub2.jpg', 2),
(1303, 483, N'/images/image/481_Vỏ_case_Corsair_3500X_ARGB_Mid-Tower_Glass_Black_sub3.jpg', 3),
(1304, 484, N'/images/image/482_Vỏ_case_Corsair_5000D_AIRFLOW_Tempered_Glass_Mid-T_sub1.jpg', 1),
(1305, 484, N'/images/image/482_Vỏ_case_Corsair_5000D_AIRFLOW_Tempered_Glass_Mid-T_sub2.webp', 2),
(1306, 485, N'/images/image/483_Vỏ_case_MSI_MAG_FORGE_100M_Mid-Tower_Black_sub1.jpg', 1),
(1307, 485, N'/images/image/483_Vỏ_case_MSI_MAG_FORGE_100M_Mid-Tower_Black_sub2.jpg', 2),
(1308, 485, N'/images/image/483_Vỏ_case_MSI_MAG_FORGE_100M_Mid-Tower_Black_sub3.jpg', 3),
(1309, 486, N'/images/image/484_Vỏ_case_Xigmatek_Gaming_X_3FX_3_Fan_ARGB_Black_sub1.jpg', 1),
(1310, 486, N'/images/image/484_Vỏ_case_Xigmatek_Gaming_X_3FX_3_Fan_ARGB_Black_sub2.jpg', 2),
(1311, 486, N'/images/image/484_Vỏ_case_Xigmatek_Gaming_X_3FX_3_Fan_ARGB_Black_sub3.jpg', 3),
(1312, 487, N'/images/image/485_Vỏ_case_Mik_Aios_Black_Kèm_3_Fan_ARGB_sub1.jpg', 1),
(1313, 487, N'/images/image/485_Vỏ_case_Mik_Aios_Black_Kèm_3_Fan_ARGB_sub2.jpg', 2),
(1314, 487, N'/images/image/485_Vỏ_case_Mik_Aios_Black_Kèm_3_Fan_ARGB_sub3.png', 3),
(1315, 488, N'/images/image/486_Vỏ_case_SAMA_3509_Black_Kèm_3_Fan_RGB_sub1.jpg', 1),
(1316, 488, N'/images/image/486_Vỏ_case_SAMA_3509_Black_Kèm_3_Fan_RGB_sub2.jpg', 2),
(1317, 488, N'/images/image/486_Vỏ_case_SAMA_3509_Black_Kèm_3_Fan_RGB_sub3.jpeg', 3),
(1318, 489, N'/images/image/487_Tản_nhiệt_khí_Thermalright_Peerless_Assassin_120_W_sub1.jpg', 1),
(1319, 489, N'/images/image/487_Tản_nhiệt_khí_Thermalright_Peerless_Assassin_120_W_sub2.jpg', 2),
(1320, 491, N'/images/image/489_Tản_nhiệt_khí_DeepCool_AK620_Digital_ARGB_Black_Du_sub1.jpg', 1),
(1321, 491, N'/images/image/489_Tản_nhiệt_khí_DeepCool_AK620_Digital_ARGB_Black_Du_sub2.jpg', 2),
(1322, 492, N'/images/image/490_Tản_nhiệt_khí_DeepCool_AG400_ARGB_Single_Tower_sub1.png', 1),
(1323, 492, N'/images/image/490_Tản_nhiệt_khí_DeepCool_AG400_ARGB_Single_Tower_sub2.jpg', 2),
(1324, 493, N'/images/image/491_Tản_nhiệt_khí_Noctua_NH-U12S_chromax.black_Single__sub1.jpg', 1),
(1325, 493, N'/images/image/491_Tản_nhiệt_khí_Noctua_NH-U12S_chromax.black_Single__sub2.jpg', 2),
(1326, 493, N'/images/image/491_Tản_nhiệt_khí_Noctua_NH-U12S_chromax.black_Single__sub3.jpg', 3),
(1327, 494, N'/images/image/492_Tản_nhiệt_khí_Noctua_NH-L9i-17xx_Low-Profile_CPU_C_sub1.webp', 1),
(1328, 494, N'/images/image/492_Tản_nhiệt_khí_Noctua_NH-L9i-17xx_Low-Profile_CPU_C_sub3.png', 3),
(1329, 495, N'/images/image/493_Tản_nhiệt_khí_ID-COOLING_SE-207-XT_Black_Dual_Towe_sub1.jpg', 1),
(1330, 495, N'/images/image/493_Tản_nhiệt_khí_ID-COOLING_SE-207-XT_Black_Dual_Towe_sub2.jpg', 2),
(1331, 495, N'/images/image/493_Tản_nhiệt_khí_ID-COOLING_SE-207-XT_Black_Dual_Towe_sub3.jpg', 3),
(1332, 496, N'/images/image/494_Tản_nhiệt_khí_ID-COOLING_FROZN_A620_Black_Dual_Tow_sub1.jpeg', 1),
(1333, 496, N'/images/image/494_Tản_nhiệt_khí_ID-COOLING_FROZN_A620_Black_Dual_Tow_sub2.jpg', 2),
(1334, 496, N'/images/image/494_Tản_nhiệt_khí_ID-COOLING_FROZN_A620_Black_Dual_Tow_sub3.jpg', 3),
(1335, 497, N'/images/image/495_Tản_nhiệt_khí_Cooler_Master_MasterAir_MA612_Stealt_sub2.jpg', 2),
(1336, 497, N'/images/image/495_Tản_nhiệt_khí_Cooler_Master_MasterAir_MA612_Stealt_sub3.jpg', 3),
(1337, 498, N'/images/image/496_Tản_nhiệt_khí_Jonsbo_CR-1400_ARGB_Black_sub1.png', 1),
(1338, 498, N'/images/image/496_Tản_nhiệt_khí_Jonsbo_CR-1400_ARGB_Black_sub2.jpeg', 2),
(1339, 498, N'/images/image/496_Tản_nhiệt_khí_Jonsbo_CR-1400_ARGB_Black_sub3.jpg', 3),
(1340, 499, N'/images/image/497_Bộ_3_Fan_tản_nhiệt_Lian_Li_UNI_FAN_TL_LCD_120_Reve_sub1.jpg', 1),
(1341, 499, N'/images/image/497_Bộ_3_Fan_tản_nhiệt_Lian_Li_UNI_FAN_TL_LCD_120_Reve_sub2.png', 2),
(1342, 499, N'/images/image/497_Bộ_3_Fan_tản_nhiệt_Lian_Li_UNI_FAN_TL_LCD_120_Reve_sub3.jpg', 3),
(1343, 500, N'/images/image/498_Bộ_3_Fan_tản_nhiệt_Lian_Li_UNI_FAN_AL120_V2_ARGB_B_sub1.png', 1),
(1344, 500, N'/images/image/498_Bộ_3_Fan_tản_nhiệt_Lian_Li_UNI_FAN_AL120_V2_ARGB_B_sub2.jpg', 2),
(1345, 500, N'/images/image/498_Bộ_3_Fan_tản_nhiệt_Lian_Li_UNI_FAN_AL120_V2_ARGB_B_sub3.jpg', 3),
(1346, 501, N'/images/image/499_Bộ_3_Fan_tản_nhiệt_Corsair_LL120_RGB_120mm_Dual_Li_sub1.jpeg', 1),
(1347, 501, N'/images/image/499_Bộ_3_Fan_tản_nhiệt_Corsair_LL120_RGB_120mm_Dual_Li_sub2.jpg', 2),
(1348, 501, N'/images/image/499_Bộ_3_Fan_tản_nhiệt_Corsair_LL120_RGB_120mm_Dual_Li_sub3.jpg', 3),
(1349, 502, N'/images/image/500_Bộ_3_Fan_tản_nhiệt_Corsair_SP120_RGB_ELITE_120mm_P_sub1.webp', 1),
(1350, 502, N'/images/image/500_Bộ_3_Fan_tản_nhiệt_Corsair_SP120_RGB_ELITE_120mm_P_sub3.jpg', 3),
(1351, 503, N'/images/image/501_Bộ_3_Fan_tản_nhiệt_NZXT_F120_RGB_Core_Triple_Pack__sub1.jpg', 1),
(1352, 503, N'/images/image/501_Bộ_3_Fan_tản_nhiệt_NZXT_F120_RGB_Core_Triple_Pack__sub2.jpg', 2),
(1353, 503, N'/images/image/501_Bộ_3_Fan_tản_nhiệt_NZXT_F120_RGB_Core_Triple_Pack__sub3.jpg', 3),
(1354, 504, N'/images/image/502_Bộ_3_Fan_tản_nhiệt_DeepCool_FC120_White_3-in-1_ARG_sub1.jpg', 1),
(1355, 504, N'/images/image/502_Bộ_3_Fan_tản_nhiệt_DeepCool_FC120_White_3-in-1_ARG_sub3.jpg', 3),
(1356, 505, N'/images/image/503_Bộ_3_Fan_tản_nhiệt_Thermalright_TL-C12C-S_X3_White_sub1.jpg', 1),
(1357, 505, N'/images/image/503_Bộ_3_Fan_tản_nhiệt_Thermalright_TL-C12C-S_X3_White_sub2.jpg', 2),
(1358, 505, N'/images/image/503_Bộ_3_Fan_tản_nhiệt_Thermalright_TL-C12C-S_X3_White_sub3.jpg', 3),
(1359, 506, N'/images/image/504_Bộ_3_Fan_tản_nhiệt_Thermalright_TL-K12_ARGB_High-P_sub1.jpg', 1),
(1360, 506, N'/images/image/504_Bộ_3_Fan_tản_nhiệt_Thermalright_TL-K12_ARGB_High-P_sub2.jpg', 2),
(1361, 506, N'/images/image/504_Bộ_3_Fan_tản_nhiệt_Thermalright_TL-K12_ARGB_High-P_sub3.jpg', 3),
(1362, 507, N'/images/image/505_Bộ_3_Fan_tản_nhiệt_Montech_RX120_PWM_Reverse_ARGB__sub1.jpg', 1),
(1363, 507, N'/images/image/505_Bộ_3_Fan_tản_nhiệt_Montech_RX120_PWM_Reverse_ARGB__sub2.jpg', 2),
(1364, 507, N'/images/image/505_Bộ_3_Fan_tản_nhiệt_Montech_RX120_PWM_Reverse_ARGB__sub3.jpg', 3),
(1365, 508, N'/images/image/506_Bộ_3_Fan_tản_nhiệt_Xigmatek_Galaxy_II_Pro_ARGB_3_F_sub1.png', 1),
(1366, 508, N'/images/image/506_Bộ_3_Fan_tản_nhiệt_Xigmatek_Galaxy_II_Pro_ARGB_3_F_sub2.jpg', 2),
(1367, 508, N'/images/image/506_Bộ_3_Fan_tản_nhiệt_Xigmatek_Galaxy_II_Pro_ARGB_3_F_sub3.jpg', 3),
(1368, 509, N'/images/image/507_Bộ_3_Fan_tản_nhiệt_Mik_Halo_ARGB_3_Fan_Pack_Black_sub1.jpg', 1),
(1369, 509, N'/images/image/507_Bộ_3_Fan_tản_nhiệt_Mik_Halo_ARGB_3_Fan_Pack_Black_sub2.jpg', 2),
(1370, 509, N'/images/image/507_Bộ_3_Fan_tản_nhiệt_Mik_Halo_ARGB_3_Fan_Pack_Black_sub3.png', 3),
(1371, 510, N'/images/image/508_Bộ_3_Fan_tản_nhiệt_SAMA_Halo_ARGB_Kit_3_Fan_kèm_Hu_sub1.jpg', 1),
(1372, 510, N'/images/image/508_Bộ_3_Fan_tản_nhiệt_SAMA_Halo_ARGB_Kit_3_Fan_kèm_Hu_sub2.jpg', 2),
(1373, 510, N'/images/image/508_Bộ_3_Fan_tản_nhiệt_SAMA_Halo_ARGB_Kit_3_Fan_kèm_Hu_sub3.jpg', 3),
(1374, 511, N'/images/image/509_Fan_tản_nhiệt_lẻ_Noctua_NF-A12x25_PWM_chromax.blac_sub1.jpg', 1),
(1375, 511, N'/images/image/509_Fan_tản_nhiệt_lẻ_Noctua_NF-A12x25_PWM_chromax.blac_sub2.jpg', 2),
(1376, 511, N'/images/image/509_Fan_tản_nhiệt_lẻ_Noctua_NF-A12x25_PWM_chromax.blac_sub3.jpg', 3),
(1377, 512, N'/images/image/510_Fan_tản_nhiệt_lẻ_Arctic_P12_PWM_PST_Black_120mm_sub1.jpeg', 1),
(1378, 512, N'/images/image/510_Fan_tản_nhiệt_lẻ_Arctic_P12_PWM_PST_Black_120mm_sub2.jpg', 2),
(1379, 512, N'/images/image/510_Fan_tản_nhiệt_lẻ_Arctic_P12_PWM_PST_Black_120mm_sub3.jpg', 3),
(1380, 513, N'/images/image/511_Bàn_phím_cơ_AKKO_5075B_Plus_Dragon_Ball_Z_Wireless_sub1.jpg', 1),
(1381, 513, N'/images/image/511_Bàn_phím_cơ_AKKO_5075B_Plus_Dragon_Ball_Z_Wireless_sub2.jpg', 2),
(1382, 513, N'/images/image/511_Bàn_phím_cơ_AKKO_5075B_Plus_Dragon_Ball_Z_Wireless_sub3.jpg', 3),
(1383, 514, N'/images/image/512_Bàn_phím_cơ_AKKO_MonsGeek_M1_V2_Kit_Nhôm_CNC_Hotsw_sub1.jpg', 1),
(1384, 514, N'/images/image/512_Bàn_phím_cơ_AKKO_MonsGeek_M1_V2_Kit_Nhôm_CNC_Hotsw_sub3.jpg', 3),
(1385, 515, N'/images/image/513_Bàn_phím_cơ_Keychron_K2_Pro_Wireless_Bluetooth_QMK_sub1.jpg', 1),
(1386, 515, N'/images/image/513_Bàn_phím_cơ_Keychron_K2_Pro_Wireless_Bluetooth_QMK_sub2.jpg', 2),
(1387, 515, N'/images/image/513_Bàn_phím_cơ_Keychron_K2_Pro_Wireless_Bluetooth_QMK_sub3.jpg', 3),
(1388, 516, N'/images/image/514_Bàn_phím_cơ_Keychron_Q1_Max_Full_Aluminum_Wireless_sub1.jpg', 1),
(1389, 516, N'/images/image/514_Bàn_phím_cơ_Keychron_Q1_Max_Full_Aluminum_Wireless_sub2.jpg', 2),
(1390, 516, N'/images/image/514_Bàn_phím_cơ_Keychron_Q1_Max_Full_Aluminum_Wireless_sub3.jpg', 3),
(1391, 517, N'/images/image/515_Bàn_phím_cơ_Logitech_G_Pro_X_TKL_LIGHTSPEED_Wirele_sub1.jpg', 1),
(1392, 517, N'/images/image/515_Bàn_phím_cơ_Logitech_G_Pro_X_TKL_LIGHTSPEED_Wirele_sub2.png', 2),
(1393, 517, N'/images/image/515_Bàn_phím_cơ_Logitech_G_Pro_X_TKL_LIGHTSPEED_Wirele_sub3.jpg', 3),
(1394, 518, N'/images/image/516_Bàn_phím_cơ_Razer_BlackWidow_V4_Pro_Mechanical_Gam_sub1.jpg', 1),
(1395, 518, N'/images/image/516_Bàn_phím_cơ_Razer_BlackWidow_V4_Pro_Mechanical_Gam_sub2.jpg', 2),
(1396, 519, N'/images/image/517_Bàn_phím_cơ_Corsair_K70_RGB_PRO_Mechanical_Gaming__sub1.jpg', 1),
(1397, 519, N'/images/image/517_Bàn_phím_cơ_Corsair_K70_RGB_PRO_Mechanical_Gaming__sub2.png', 2),
(1398, 519, N'/images/image/517_Bàn_phím_cơ_Corsair_K70_RGB_PRO_Mechanical_Gaming__sub3.jpg', 3),
(1399, 520, N'/images/image/518_Bàn_phím_cơ_SteelSeries_Apex_Pro_TKL_Wireless_sub1.jpg', 1),
(1400, 520, N'/images/image/518_Bàn_phím_cơ_SteelSeries_Apex_Pro_TKL_Wireless_sub2.jpg', 2),
(1401, 520, N'/images/image/518_Bàn_phím_cơ_SteelSeries_Apex_Pro_TKL_Wireless_sub3.jpg', 3),
(1402, 521, N'/images/image/519_Bàn_phím_cơ_ASUS_ROG_Azoth_Wireless_Custom_Gaming__sub1.jpg', 1),
(1403, 521, N'/images/image/519_Bàn_phím_cơ_ASUS_ROG_Azoth_Wireless_Custom_Gaming__sub2.jpg', 2),
(1404, 521, N'/images/image/519_Bàn_phím_cơ_ASUS_ROG_Azoth_Wireless_Custom_Gaming__sub3.jpg', 3),
(1405, 522, N'/images/image/520_Bàn_phím_cơ_Dareu_EK87_V2_Multi-LED_Tenkeyless_Bla_sub1.png', 1),
(1406, 522, N'/images/image/520_Bàn_phím_cơ_Dareu_EK87_V2_Multi-LED_Tenkeyless_Bla_sub2.jpg', 2),
(1407, 522, N'/images/image/520_Bàn_phím_cơ_Dareu_EK87_V2_Multi-LED_Tenkeyless_Bla_sub3.jpg', 3),
(1408, 523, N'/images/image/521_Chuột_máy_tính_Logitech_G_Pro_X_Superlight_2_Wirel_sub1.jpg', 1),
(1409, 523, N'/images/image/521_Chuột_máy_tính_Logitech_G_Pro_X_Superlight_2_Wirel_sub2.jpg', 2),
(1410, 523, N'/images/image/521_Chuột_máy_tính_Logitech_G_Pro_X_Superlight_2_Wirel_sub3.png', 3),
(1411, 524, N'/images/image/522_Chuột_máy_tính_Logitech_G502_X_PLUS_LIGHTSPEED_Wir_sub1.jpg', 1),
(1412, 524, N'/images/image/522_Chuột_máy_tính_Logitech_G502_X_PLUS_LIGHTSPEED_Wir_sub2.png', 2),
(1413, 524, N'/images/image/522_Chuột_máy_tính_Logitech_G502_X_PLUS_LIGHTSPEED_Wir_sub3.jpg', 3),
(1414, 525, N'/images/image/523_Chuột_máy_tính_Razer_DeathAdder_V3_Pro_Wireless_Ul_sub1.jpg', 1),
(1415, 525, N'/images/image/523_Chuột_máy_tính_Razer_DeathAdder_V3_Pro_Wireless_Ul_sub2.png', 2),
(1416, 525, N'/images/image/523_Chuột_máy_tính_Razer_DeathAdder_V3_Pro_Wireless_Ul_sub3.jpg', 3),
(1417, 526, N'/images/image/524_Chuột_máy_tính_Razer_Viper_V3_Pro_Ultra-Lightweigh_sub1.jpg', 1),
(1418, 526, N'/images/image/524_Chuột_máy_tính_Razer_Viper_V3_Pro_Ultra-Lightweigh_sub3.jpg', 3),
(1419, 527, N'/images/image/525_Chuột_máy_tính_SteelSeries_Aerox_3_Wireless_Onyx_S_sub1.jpg', 1),
(1420, 527, N'/images/image/525_Chuột_máy_tính_SteelSeries_Aerox_3_Wireless_Onyx_S_sub2.jpg', 2),
(1421, 527, N'/images/image/525_Chuột_máy_tính_SteelSeries_Aerox_3_Wireless_Onyx_S_sub3.jpg', 3),
(1422, 528, N'/images/image/526_Chuột_máy_tính_Corsair_M65_RGB_ULTRA_Wireless_Gami_sub1.jpg', 1),
(1423, 528, N'/images/image/526_Chuột_máy_tính_Corsair_M65_RGB_ULTRA_Wireless_Gami_sub2.png', 2),
(1424, 528, N'/images/image/526_Chuột_máy_tính_Corsair_M65_RGB_ULTRA_Wireless_Gami_sub3.jpg', 3),
(1425, 529, N'/images/image/527_Chuột_máy_tính_ASUS_ROG_Keris_II_Ace_Ultra-Lightwe_sub1.jpg', 1),
(1426, 529, N'/images/image/527_Chuột_máy_tính_ASUS_ROG_Keris_II_Ace_Ultra-Lightwe_sub2.png', 2),
(1427, 529, N'/images/image/527_Chuột_máy_tính_ASUS_ROG_Keris_II_Ace_Ultra-Lightwe_sub3.jpg', 3),
(1428, 530, N'/images/image/528_Chuột_máy_tính_Dareu_EM901X_RGB_Wireless_kèm_Đế_sạ_sub1.jpg', 1),
(1429, 530, N'/images/image/528_Chuột_máy_tính_Dareu_EM901X_RGB_Wireless_kèm_Đế_sạ_sub2.jpg', 2),
(1430, 530, N'/images/image/528_Chuột_máy_tính_Dareu_EM901X_RGB_Wireless_kèm_Đế_sạ_sub3.jpg', 3),
(1431, 531, N'/images/image/529_Chuột_máy_tính_Rapoo_VT9_PRO_Dual-Mode_Wireless_Ga_sub1.webp', 1),
(1432, 531, N'/images/image/529_Chuột_máy_tính_Rapoo_VT9_PRO_Dual-Mode_Wireless_Ga_sub2.jpg', 2),
(1433, 531, N'/images/image/529_Chuột_máy_tính_Rapoo_VT9_PRO_Dual-Mode_Wireless_Ga_sub3.jpg', 3),
(1434, 532, N'/images/image/530_Chuột_máy_tính_Fantech_Helios_II_Pro_XD3_V3_Wirele_sub1.jpg', 1),
(1435, 532, N'/images/image/530_Chuột_máy_tính_Fantech_Helios_II_Pro_XD3_V3_Wirele_sub2.jpg', 2),
(1436, 532, N'/images/image/530_Chuột_máy_tính_Fantech_Helios_II_Pro_XD3_V3_Wirele_sub3.jpg', 3),
(1437, 533, N'/images/image/531_Tai_nghe_gaming_HyperX_Cloud_III_Wireless_Black_Re_sub1.png', 1),
(1438, 533, N'/images/image/531_Tai_nghe_gaming_HyperX_Cloud_III_Wireless_Black_Re_sub2.jpg', 2),
(1439, 533, N'/images/image/531_Tai_nghe_gaming_HyperX_Cloud_III_Wireless_Black_Re_sub3.jpg', 3),
(1440, 534, N'/images/image/532_Tai_nghe_gaming_HyperX_Cloud_Stinger_2_Core_Gaming_sub1.jpg', 1),
(1441, 534, N'/images/image/532_Tai_nghe_gaming_HyperX_Cloud_Stinger_2_Core_Gaming_sub2.jpg', 2),
(1442, 534, N'/images/image/532_Tai_nghe_gaming_HyperX_Cloud_Stinger_2_Core_Gaming_sub3.jpg', 3),
(1443, 535, N'/images/image/533_Tai_nghe_gaming_Razer_BlackShark_V2_Pro_Wireless_2_sub1.jpg', 1),
(1444, 535, N'/images/image/533_Tai_nghe_gaming_Razer_BlackShark_V2_Pro_Wireless_2_sub2.jpg', 2),
(1445, 535, N'/images/image/533_Tai_nghe_gaming_Razer_BlackShark_V2_Pro_Wireless_2_sub3.jpg', 3),
(1446, 536, N'/images/image/534_Tai_nghe_gaming_Razer_Kraken_Kitty_V2_Pro_RGB_Quar_sub1.jpg', 1),
(1447, 536, N'/images/image/534_Tai_nghe_gaming_Razer_Kraken_Kitty_V2_Pro_RGB_Quar_sub2.jpg', 2),
(1448, 536, N'/images/image/534_Tai_nghe_gaming_Razer_Kraken_Kitty_V2_Pro_RGB_Quar_sub3.jpg', 3),
(1449, 537, N'/images/image/535_Tai_nghe_gaming_Logitech_G_PRO_X_2_LIGHTSPEED_Wire_sub1.png', 1),
(1450, 537, N'/images/image/535_Tai_nghe_gaming_Logitech_G_PRO_X_2_LIGHTSPEED_Wire_sub2.jpg', 2),
(1451, 537, N'/images/image/535_Tai_nghe_gaming_Logitech_G_PRO_X_2_LIGHTSPEED_Wire_sub3.jpg', 3),
(1452, 538, N'/images/image/536_Tai_nghe_gaming_Logitech_G733_LIGHTSPEED_Wireless__sub1.jpg', 1),
(1453, 538, N'/images/image/536_Tai_nghe_gaming_Logitech_G733_LIGHTSPEED_Wireless__sub2.jpg', 2),
(1454, 538, N'/images/image/536_Tai_nghe_gaming_Logitech_G733_LIGHTSPEED_Wireless__sub3.jpg', 3),
(1455, 539, N'/images/image/537_Tai_nghe_gaming_SteelSeries_Arctis_Nova_Pro_Wirele_sub1.jpg', 1),
(1456, 539, N'/images/image/537_Tai_nghe_gaming_SteelSeries_Arctis_Nova_Pro_Wirele_sub3.png', 3),
(1457, 540, N'/images/image/538_Tai_nghe_gaming_Corsair_VIRTUOSO_RGB_WIRELESS_High_sub1.png', 1),
(1458, 540, N'/images/image/538_Tai_nghe_gaming_Corsair_VIRTUOSO_RGB_WIRELESS_High_sub2.png', 2),
(1459, 540, N'/images/image/538_Tai_nghe_gaming_Corsair_VIRTUOSO_RGB_WIRELESS_High_sub3.webp', 3),
(1460, 541, N'/images/image/539_Tai_nghe_gaming_ASUS_ROG_Pugi_III_Delta_S_Animate__sub1.jpg', 1),
(1461, 541, N'/images/image/539_Tai_nghe_gaming_ASUS_ROG_Pugi_III_Delta_S_Animate__sub2.jpg', 2),
(1462, 541, N'/images/image/539_Tai_nghe_gaming_ASUS_ROG_Pugi_III_Delta_S_Animate__sub3.jpg', 3),
(1463, 542, N'/images/image/540_Tai_nghe_gaming_Dareu_EH722X_7.1_Surround_Sound_Pi_sub1.jpg', 1),
(1464, 542, N'/images/image/540_Tai_nghe_gaming_Dareu_EH722X_7.1_Surround_Sound_Pi_sub2.jpg', 2),
(1465, 542, N'/images/image/540_Tai_nghe_gaming_Dareu_EH722X_7.1_Surround_Sound_Pi_sub3.jpg', 3);
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


-- ----------------------------------------------------------------------------
-- INVENTORY & STOCK SEED DATA
-- ----------------------------------------------------------------------------
SET IDENTITY_INSERT inventory ON;
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (2, 2, 15, '2026-04-06 20:51:03.317');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (3, 3, 40, '2026-04-06 20:51:03.617');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (6, 6, 60, '2026-04-06 20:51:04.539');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (7, 7, 10, '2026-04-06 20:51:04.847');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (8, 8, 20, '2026-04-06 20:51:05.193');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (9, 9, 45, '2026-04-06 20:51:05.635');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (10, 10, 25, '2026-04-06 20:51:05.963');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (11, 11, 100, '2026-04-06 20:51:06.291');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (12, 12, 80, '2026-04-06 20:51:06.607');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (13, 13, 70, '2026-04-06 20:51:06.913');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (14, 14, 120, '2026-04-06 20:51:07.22');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (15, 15, 15, '2026-04-06 20:51:07.522');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (16, 17, 65, '2026-04-06 20:51:08.129');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (17, 18, 40, '2026-04-06 20:51:08.43');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (18, 19, 35, '2026-04-06 20:51:08.732');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (19, 20, 28, '2026-04-06 20:51:09.051');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (20, 21, 50, '2026-04-06 20:51:09.403');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (21, 22, 95, '2026-04-06 20:51:09.712');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (22, 23, 10, '2026-04-06 20:51:10.029');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (23, 24, 150, '2026-04-06 20:51:10.335');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (24, 25, 110, '2026-04-06 20:51:10.649');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (25, 26, 8, '2026-04-06 20:51:10.955');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (26, 27, 200, '2026-04-06 20:51:11.268');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (27, 28, 180, '2026-04-06 20:51:11.577');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (28, 29, 20, '2026-04-06 20:51:11.877');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (29, 30, 33, '2026-04-06 20:51:12.182');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (30, 31, 10, '2026-04-06 20:51:12.493');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (31, 32, 15, '2026-04-06 20:51:12.796');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (32, 33, 25, '2026-04-06 20:51:13.125');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (33, 34, 12, '2026-04-06 20:51:13.43');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (35, 36, 30, '2026-04-06 20:51:14.041');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (36, 37, 80, '2026-04-06 20:51:14.385');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (37, 38, 100, '2026-04-06 20:51:14.684');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (38, 160, 3, '2026-04-06 20:51:14.986');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (39, 39, 5, '2026-04-06 20:51:15.32');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (40, 40, 20, '2026-04-06 20:51:15.634');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (41, 41, 60, '2026-04-06 20:51:15.933');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (42, 42, 35, '2026-04-06 20:51:16.249');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (43, 43, 50, '2026-04-06 20:51:16.549');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (44, 44, 70, '2026-04-06 20:51:16.88');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (45, 45, 40, '2026-04-06 20:51:17.233');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (46, 46, 15, '2026-04-06 20:51:17.538');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (47, 47, 10, '2026-04-06 20:51:17.836');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (48, 48, 5, '2026-04-06 20:51:18.143');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (49, 49, 18, '2026-04-06 20:51:18.454');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (50, 50, 22, '2026-04-06 20:51:18.761');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (51, 51, 150, '2026-04-06 20:51:19.075');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (52, 52, 40, '2026-04-06 20:51:19.427');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (53, 53, 8, '2026-04-06 20:51:19.744');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (54, 54, 10, '2026-04-06 20:51:20.055');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (55, 55, 3, '2026-04-06 20:51:20.362');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (56, 56, 25, '2026-04-06 20:51:20.666');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (57, 57, 40, '2026-04-06 20:51:20.965');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (58, 58, 15, '2026-04-06 20:51:21.265');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (59, 59, 4, '2026-04-06 20:51:21.562');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (60, 60, 55, '2026-04-06 20:51:21.862');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (61, 61, 50, '2026-04-06 20:51:22.163');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (62, 62, 40, '2026-04-06 20:51:22.465');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (63, 63, 120, '2026-04-06 20:51:22.765');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (64, 64, 45, '2026-04-06 20:51:23.069');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (65, 65, 70, '2026-04-06 20:51:23.373');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (66, 66, 200, '2026-04-06 20:51:23.699');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (67, 67, 10, '2026-04-06 20:51:23.997');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (68, 68, 90, '2026-04-06 20:51:24.304');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (69, 69, 55, '2026-04-06 20:51:24.616');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (70, 70, 25, '2026-04-06 20:51:24.917');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (71, 71, 60, '2026-04-06 20:51:25.221');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (72, 72, 150, '2026-04-06 20:51:25.52');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (73, 73, 20, '2026-04-06 20:51:25.819');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (74, 74, 40, '2026-04-06 20:51:26.122');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (75, 75, 30, '2026-04-06 20:51:26.434');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (76, 76, 25, '2026-04-06 20:51:26.745');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (77, 77, 15, '2026-04-06 20:51:27.046');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (78, 78, 100, '2026-04-06 20:51:27.35');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (79, 79, 50, '2026-04-06 20:51:27.651');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (80, 80, 40, '2026-04-06 20:51:27.977');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (81, 81, 20, '2026-04-06 20:51:28.28');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (82, 82, 80, '2026-04-06 20:51:28.584');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (83, 83, 35, '2026-04-06 20:51:28.884');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (84, 84, 60, '2026-04-06 20:51:29.233');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (85, 85, 45, '2026-04-06 20:51:29.531');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (86, 86, 15, '2026-04-06 20:51:29.829');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (87, 87, 30, '2026-04-06 20:51:30.153');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (88, 88, 100, '2026-04-06 20:51:30.483');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (89, 89, 5, '2026-04-06 20:51:30.834');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (90, 90, 25, '2026-04-06 20:51:31.156');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (91, 91, 12, '2026-04-06 20:51:31.477');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (92, 92, 45, '2026-04-06 20:51:31.788');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (93, 93, 30, '2026-04-06 20:51:32.085');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (94, 94, 40, '2026-04-06 20:51:32.39');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (95, 95, 60, '2026-04-06 20:51:32.691');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (96, 96, 15, '2026-04-06 20:51:33.02');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (97, 97, 100, '2026-04-06 20:51:33.318');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (98, 98, 80, '2026-04-06 20:51:33.624');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (99, 99, 20, '2026-04-06 20:51:33.926');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (100, 100, 3, '2026-04-06 20:51:34.266');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (101, 101, 8, '2026-04-06 20:51:34.613');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (102, 102, 10, '2026-04-06 20:51:34.925');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (103, 103, 12, '2026-04-06 20:51:35.226');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (104, 104, 150, '2026-04-06 20:51:35.555');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (105, 105, 5, '2026-04-06 20:51:35.856');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (106, 106, 40, '2026-04-06 20:51:36.151');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (107, 107, 25, '2026-04-06 20:51:36.464');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (108, 108, 90, '2026-04-06 20:51:36.774');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (109, 109, 18, '2026-04-06 20:51:37.078');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (110, 110, 55, '2026-04-06 20:51:37.395');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (111, 111, 2, '2026-04-06 20:51:37.71');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (112, 112, 20, '2026-04-06 20:51:38.015');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (113, 113, 45, '2026-04-06 20:51:38.344');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (114, 114, 35, '2026-04-06 20:51:38.643');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (115, 115, 40, '2026-04-06 20:51:38.977');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (116, 116, 50, '2026-04-06 20:51:39.294');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (117, 117, 30, '2026-04-06 20:51:39.594');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (118, 118, 110, '2026-04-06 20:51:39.89');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (119, 119, 15, '2026-04-06 20:51:40.208');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (120, 120, 7, '2026-04-06 20:51:40.516');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (121, 121, 60, '2026-04-06 20:51:41.214');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (122, 122, 40, '2026-04-06 20:51:41.513');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (123, 123, 55, '2026-04-06 20:51:41.817');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (124, 124, 100, '2026-04-06 20:51:42.117');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (125, 125, 150, '2026-04-06 20:51:42.414');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (126, 126, 80, '2026-04-06 20:51:42.727');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (127, 127, 20, '2026-04-06 20:51:43.034');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (128, 128, 45, '2026-04-06 20:51:43.332');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (129, 129, 15, '2026-04-06 20:51:43.637');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (130, 130, 10, '2026-04-06 20:51:43.937');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (131, 131, 90, '2026-04-06 20:51:44.258');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (132, 132, 65, '2026-04-06 20:51:44.562');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (133, 133, 75, '2026-04-06 20:51:44.865');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (134, 134, 18, '2026-04-06 20:51:45.169');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (135, 135, 8, '2026-04-06 20:51:45.481');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (136, 136, 30, '2026-04-06 20:51:45.777');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (137, 137, 50, '2026-04-06 20:51:46.077');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (138, 138, 60, '2026-04-06 20:51:46.394');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (139, 139, 22, '2026-04-06 20:51:46.695');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (140, 140, 40, '2026-04-06 20:51:47.001');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (141, 141, 85, '2026-04-06 20:51:47.295');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (142, 142, 120, '2026-04-06 20:51:47.661');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (143, 143, 20, '2026-04-06 20:51:47.957');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (144, 144, 35, '2026-04-06 20:51:48.257');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (145, 145, 12, '2026-04-06 20:51:48.556');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (146, 146, 100, '2026-04-06 20:51:48.859');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (147, 147, 40, '2026-04-06 20:51:49.165');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (149, 149, 200, '2026-04-06 20:51:49.769');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (150, 150, 5, '2026-04-06 20:51:50.066');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (151, 151, 12, '2026-04-06 20:51:50.361');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (152, 152, 25, '2026-04-06 20:51:50.658');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (153, 153, 60, '2026-04-06 20:51:50.959');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (154, 154, 8, '2026-04-06 20:51:51.259');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (155, 155, 35, '2026-04-06 20:51:51.556');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (156, 156, 80, '2026-04-06 20:51:51.856');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (34, 35, 43, '2026-06-12 14:53:10.583');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (4, 4, 27, '2026-06-12 17:18:38.169');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (5, 5, 54, '2026-06-12 17:21:06.49');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (157, 157, 50, '2026-04-06 20:51:52.151');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (158, 158, 20, '2026-04-06 20:51:52.451');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (159, 159, 5, '2026-04-06 20:51:52.75');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (160, 161, 30, '2026-04-06 20:51:53.047');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (161, 162, 100, '2026-04-06 20:51:53.342');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (162, 163, 4, '2026-04-06 20:51:53.654');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (163, 164, 70, '2026-04-06 20:51:53.964');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (164, 165, 15, '2026-04-06 20:51:54.269');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (165, 166, 45, '2026-04-06 20:51:54.594');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (166, 167, 22, '2026-04-06 20:51:54.935');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (167, 168, 10, '2026-04-06 20:51:55.234');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (168, 169, 40, '2026-04-06 20:51:55.649');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (169, 170, 25, '2026-04-06 20:51:56.017');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (170, 171, 18, '2026-04-06 20:51:56.334');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (171, 172, 55, '2026-04-06 20:51:56.65');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (172, 173, 90, '2026-04-06 20:51:56.964');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (173, 174, 150, '2026-04-06 20:51:57.268');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (174, 175, 35, '2026-04-06 20:51:57.569');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (175, 176, 80, '2026-04-06 20:51:57.866');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (176, 177, 15, '2026-04-06 20:51:58.176');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (177, 178, 2, '2026-04-06 20:51:58.474');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (178, 179, 20, '2026-04-06 20:51:58.779');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (179, 180, 40, '2026-04-06 20:51:59.082');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (1, 1, 48, '2026-04-23 12:54:40.683');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (180, 205, 50, '2026-06-06 09:48:11.978');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (181, 206, 50, '2026-06-06 09:48:27.877');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (182, 181, 50, '2026-06-06 09:48:50.163');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (183, 182, 50, '2026-06-06 09:48:50.697');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (184, 183, 50, '2026-06-06 09:48:51.225');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (185, 184, 50, '2026-06-06 09:48:51.777');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (186, 185, 50, '2026-06-06 09:48:52.308');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (187, 186, 50, '2026-06-06 09:48:52.806');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (188, 187, 50, '2026-06-06 09:48:53.413');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (189, 188, 50, '2026-06-06 09:48:53.977');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (190, 189, 50, '2026-06-06 09:48:54.537');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (191, 190, 50, '2026-06-06 09:48:55.069');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (192, 191, 50, '2026-06-06 09:48:55.578');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (193, 192, 50, '2026-06-06 09:48:56.149');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (194, 193, 50, '2026-06-06 09:48:56.66');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (195, 194, 50, '2026-06-06 09:48:57.166');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (196, 195, 50, '2026-06-06 09:48:57.674');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (197, 196, 50, '2026-06-06 09:48:58.173');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (198, 197, 50, '2026-06-06 09:48:58.701');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (199, 198, 50, '2026-06-06 09:48:59.215');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (200, 199, 50, '2026-06-06 09:48:59.734');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (201, 200, 50, '2026-06-06 09:49:00.275');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (202, 201, 50, '2026-06-06 09:49:00.835');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (203, 202, 50, '2026-06-06 09:49:01.425');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (204, 203, 50, '2026-06-06 09:49:01.936');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (205, 204, 50, '2026-06-06 09:49:02.596');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (206, 207, 50, '2026-06-06 09:49:03.158');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (207, 208, 50, '2026-06-06 09:49:03.7');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (208, 209, 50, '2026-06-06 09:49:04.209');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (209, 210, 50, '2026-06-06 09:49:04.713');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (210, 211, 50, '2026-06-06 09:49:05.249');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (211, 212, 50, '2026-06-06 09:49:05.778');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (212, 213, 50, '2026-06-06 09:49:06.316');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (213, 214, 50, '2026-06-06 09:49:06.831');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (214, 215, 50, '2026-06-06 09:49:07.385');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (215, 216, 50, '2026-06-06 09:49:07.917');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (216, 217, 50, '2026-06-06 09:49:08.514');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (217, 218, 50, '2026-06-06 09:49:09.101');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (218, 219, 50, '2026-06-06 09:49:09.647');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (219, 220, 50, '2026-06-06 09:49:10.163');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (220, 221, 50, '2026-06-06 09:49:10.664');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (221, 222, 50, '2026-06-06 09:49:11.176');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (222, 223, 50, '2026-06-06 09:49:11.705');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (223, 224, 50, '2026-06-06 09:49:12.215');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (224, 225, 50, '2026-06-06 09:49:13.047');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (225, 226, 50, '2026-06-06 09:49:13.615');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (226, 227, 50, '2026-06-06 09:49:14.194');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (227, 228, 50, '2026-06-06 09:49:14.733');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (228, 229, 50, '2026-06-06 09:49:15.275');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (229, 230, 50, '2026-06-06 09:49:15.799');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (230, 231, 50, '2026-06-06 09:49:16.357');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (231, 232, 50, '2026-06-06 09:49:16.912');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (232, 233, 50, '2026-06-06 09:49:17.453');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (233, 234, 50, '2026-06-06 09:49:17.987');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (234, 235, 50, '2026-06-06 09:49:18.561');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (235, 236, 50, '2026-06-06 09:49:19.064');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (236, 237, 50, '2026-06-06 09:49:19.576');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (237, 238, 50, '2026-06-06 09:49:20.081');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (238, 239, 50, '2026-06-06 09:49:20.626');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (239, 240, 50, '2026-06-06 09:49:21.145');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (240, 241, 50, '2026-06-06 09:49:21.737');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (241, 242, 50, '2026-06-06 09:49:22.352');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (242, 243, 50, '2026-06-06 09:49:22.887');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (243, 244, 50, '2026-06-06 09:49:23.407');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (244, 245, 50, '2026-06-06 09:49:24.077');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (245, 246, 50, '2026-06-06 09:49:24.652');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (246, 247, 50, '2026-06-06 09:49:25.187');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (247, 248, 50, '2026-06-06 09:49:25.717');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (248, 249, 50, '2026-06-06 09:49:26.238');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (249, 250, 50, '2026-06-06 09:49:26.773');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (250, 251, 50, '2026-06-06 09:49:27.358');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (251, 252, 50, '2026-06-06 09:49:27.892');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (252, 253, 50, '2026-06-06 09:49:28.403');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (253, 254, 50, '2026-06-06 09:49:28.927');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (254, 255, 50, '2026-06-06 09:49:29.435');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (255, 256, 100, '2026-06-27 12:54:28.148');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (256, 257, 100, '2026-06-27 12:54:28.446');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (257, 258, 100, '2026-06-27 12:54:28.735');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (258, 259, 100, '2026-06-27 12:54:35.988');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (259, 260, 100, '2026-06-27 12:54:36.271');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (260, 261, 100, '2026-06-27 12:54:49.887');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (261, 262, 100, '2026-06-27 12:54:51.815');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (262, 263, 100, '2026-06-27 12:55:05.917');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (263, 264, 100, '2026-06-27 12:55:13.318');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (264, 265, 100, '2026-06-27 12:55:24.726');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (265, 266, 100, '2026-06-27 12:55:25.041');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (266, 267, 100, '2026-06-27 12:55:25.329');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (267, 268, 100, '2026-06-27 12:55:25.63');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (268, 269, 100, '2026-06-27 12:55:25.921');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (269, 270, 100, '2026-06-27 12:55:26.603');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (270, 271, 100, '2026-06-27 12:55:27.068');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (271, 272, 100, '2026-06-27 12:55:27.369');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (272, 273, 100, '2026-06-27 12:55:27.66');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (273, 274, 100, '2026-06-27 12:55:27.944');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (274, 275, 100, '2026-06-27 12:55:28.237');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (275, 276, 100, '2026-06-27 12:55:28.533');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (276, 277, 100, '2026-06-27 12:55:28.822');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (277, 16, 100, '2026-06-27 12:55:29.106');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (278, 278, 100, '2026-06-27 13:17:32.011');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (279, 279, 100, '2026-06-27 13:17:32.333');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (280, 280, 100, '2026-06-27 13:17:32.629');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (281, 281, 100, '2026-06-27 13:17:32.912');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (282, 282, 100, '2026-06-27 13:17:33.213');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (283, 283, 100, '2026-06-27 13:17:33.517');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (284, 284, 100, '2026-06-27 13:17:33.814');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (285, 285, 100, '2026-06-27 13:17:34.303');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (286, 286, 100, '2026-06-27 13:17:34.596');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (148, 148, 31, '2026-07-14 13:54:16.7');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (287, 287, 100, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (288, 288, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (289, 289, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (290, 290, 120, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (291, 291, 150, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (292, 292, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (293, 293, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (294, 294, 25, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (295, 295, 110, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (296, 296, 75, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (297, 297, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (298, 298, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (299, 299, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (300, 300, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (301, 301, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (302, 302, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (303, 303, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (304, 304, 70, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (305, 305, 25, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (306, 306, 55, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (307, 307, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (308, 308, 25, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (309, 309, 20, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (310, 310, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (311, 311, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (312, 312, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (313, 313, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (314, 314, 70, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (315, 315, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (316, 316, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (317, 317, 25, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (318, 318, 20, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (319, 319, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (320, 320, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (321, 321, 18, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (322, 322, 15, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (323, 323, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (324, 324, 22, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (325, 325, 28, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (326, 326, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (327, 327, 100, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (328, 328, 110, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (329, 329, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (330, 330, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (331, 331, 55, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (332, 332, 20, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (333, 333, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (334, 334, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (335, 335, 75, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (336, 336, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (337, 337, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (338, 338, 70, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (339, 339, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (340, 340, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (341, 341, 65, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (342, 342, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (343, 343, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (344, 344, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (345, 345, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (346, 346, 55, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (347, 347, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (348, 348, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (349, 349, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (350, 350, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (351, 351, 20, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (352, 352, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (353, 353, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (354, 354, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (355, 355, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (356, 356, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (357, 357, 100, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (358, 358, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (359, 359, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (360, 360, 120, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (361, 361, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (362, 362, 150, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (363, 363, 75, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (364, 364, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (365, 365, 65, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (366, 366, 70, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (367, 367, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (368, 368, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (369, 369, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (370, 370, 120, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (371, 371, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (372, 372, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (373, 373, 100, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (374, 374, 70, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (375, 375, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (376, 376, 95, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (377, 377, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (378, 378, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (379, 379, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (380, 380, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (381, 381, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (382, 382, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (383, 383, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (384, 384, 25, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (385, 385, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (386, 386, 70, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (387, 387, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (388, 388, 150, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (389, 389, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (390, 390, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (391, 391, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (392, 392, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (393, 393, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (394, 394, 110, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (395, 395, 100, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (396, 396, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (397, 397, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (398, 398, 100, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (399, 399, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (400, 400, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (401, 401, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (402, 402, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (403, 403, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (404, 404, 70, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (405, 405, 25, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (406, 406, 120, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (407, 407, 150, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (408, 408, 100, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (409, 409, 120, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (410, 410, 180, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (411, 411, 140, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (412, 412, 200, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (413, 413, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (414, 414, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (415, 415, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (416, 416, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (417, 417, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (418, 418, 75, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (419, 419, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (420, 420, 85, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (421, 421, 20, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (422, 422, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (423, 423, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (424, 424, 100, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (425, 425, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (426, 426, 70, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (427, 427, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (428, 428, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (429, 429, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (430, 430, 110, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (431, 431, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (432, 432, 25, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (433, 433, 55, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (434, 434, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (435, 435, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (436, 436, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (437, 437, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (438, 438, 25, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (439, 439, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (440, 440, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (441, 441, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (442, 442, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (443, 443, 20, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (444, 444, 55, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (445, 445, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (446, 446, 10, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (447, 447, 15, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (448, 448, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (449, 449, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (450, 450, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (451, 451, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (452, 452, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (453, 453, 55, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (454, 454, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (455, 455, 70, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (456, 456, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (457, 457, 70, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (458, 458, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (459, 459, 85, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (460, 460, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (461, 461, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (462, 462, 20, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (463, 463, 25, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (464, 464, 25, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (465, 465, 15, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (466, 466, 110, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (467, 467, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (468, 468, 95, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (469, 469, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (470, 470, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (471, 471, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (472, 472, 110, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (473, 473, 15, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (474, 474, 20, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (475, 475, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (476, 476, 100, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (477, 477, 85, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (478, 478, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (479, 479, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (480, 480, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (481, 481, 20, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (482, 482, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (483, 483, 70, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (484, 484, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (485, 485, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (486, 486, 120, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (487, 487, 100, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (488, 488, 110, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (489, 489, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (490, 490, 70, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (491, 491, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (492, 492, 130, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (493, 493, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (494, 494, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (495, 495, 75, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (496, 496, 65, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (497, 497, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (498, 498, 160, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (499, 499, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (500, 500, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (501, 501, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (502, 502, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (503, 503, 55, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (504, 504, 80, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (505, 505, 110, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (506, 506, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (507, 507, 85, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (508, 508, 120, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (509, 509, 130, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (510, 510, 140, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (511, 511, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (512, 512, 200, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (513, 513, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (514, 514, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (515, 515, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (516, 516, 25, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (517, 517, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (518, 518, 20, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (519, 519, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (520, 520, 20, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (521, 521, 15, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (522, 522, 120, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (523, 523, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (524, 524, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (525, 525, 45, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (526, 526, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (527, 527, 60, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (528, 528, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (529, 529, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (530, 530, 100, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (531, 531, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (532, 532, 70, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (533, 533, 40, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (534, 534, 90, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (535, 535, 35, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (536, 536, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (537, 537, 25, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (538, 538, 50, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (539, 539, 15, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (540, 540, 30, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (541, 541, 20, '2026-07-23 11:35:00.000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (542, 542, 110, '2026-07-23 11:35:00.000');
SET IDENTITY_INSERT inventory OFF;
GO

SET IDENTITY_INSERT stock_movements ON;
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (1, 1, 23, 'IMPORT', '', '2026-04-23 12:54:40.508');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (2, 148, 2, 'EXPORT', 'ok', '2026-06-12 10:45:03.715');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (3, 148, 17, 'IMPORT', '', '2026-06-12 10:45:14.706');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (4, 35, 2, 'EXPORT', 'Tru kho cho don DH71', '2026-06-12 14:53:10.375');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (5, 4, 3, 'EXPORT', 'Tru kho cho don DH74', '2026-06-12 17:18:37.969');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (6, 5, 1, 'EXPORT', 'Tru kho cho don DH75', '2026-06-12 17:21:06.3');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (7, 148, 1, 'IMPORT', '', '2026-07-14 13:48:58.514');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (8, 148, 1, 'EXPORT', '', '2026-07-14 13:49:22.926');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (9, 148, 1, 'IMPORT', '', '2026-07-14 13:54:16.531');
SET IDENTITY_INSERT stock_movements OFF;
GO

SET IDENTITY_INSERT flash_sale_items ON;
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES (2, 10000000, 50, 10, 1, 54);
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES (1, 3000000, 30, 30, 1, 13);
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES (3, 3000000, 50, 40, 1, 3);
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES (4, 400000, 50, 0, 1, 277);
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES (5, 2000000, 20, 0, 1, 257);
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES (6, 2000000, 50, 0, 2, 257);
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES (7, 499000, 99, 0, 2, 277);
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES (8, 8399000, 100, 0, 2, 286);
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES (9, 13999999, 49, 0, 2, 279);
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES (10, 10000000, 97, 0, 2, 256);
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES (11, 699000, 100, 0, 2, 16);
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES (12, 1100000, 10, 0, 2, 24);
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES (13, 9999999, 20, 0, 2, 35);
INSERT INTO flash_sale_items (id, sale_price, sale_quantity, sold_count, flash_sale_id, product_id) VALUES (14, 1300000, 15, 0, 2, 84);
SET IDENTITY_INSERT flash_sale_items OFF;
GO

