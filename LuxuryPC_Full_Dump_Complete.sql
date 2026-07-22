-- =====================================================
-- Supabase Database Backup & Integrated User SQL Script
-- =====================================================

SET session_replication_role = 'replica';

-- Drop existing tables
DROP TABLE IF EXISTS user_sessions CASCADE;
DROP TABLE IF EXISTS wishlist_items CASCADE;
DROP TABLE IF EXISTS vouchers CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS user_vouchers CASCADE;
DROP TABLE IF EXISTS user_roles CASCADE;
DROP TABLE IF EXISTS user_notification_settings CASCADE;
DROP TABLE IF EXISTS user_addresses CASCADE;
DROP TABLE IF EXISTS tickets CASCADE;
DROP TABLE IF EXISTS ticket_messages CASCADE;
DROP TABLE IF EXISTS support_tickets CASCADE;
DROP TABLE IF EXISTS stock_movements CASCADE;
DROP TABLE IF EXISTS spring_session_attributes CASCADE;
DROP TABLE IF EXISTS spring_session CASCADE;
DROP TABLE IF EXISTS shipping_addresses CASCADE;
DROP TABLE IF EXISTS shared_builds CASCADE;
DROP TABLE IF EXISTS roles CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS pc_builds CASCADE;
DROP TABLE IF EXISTS pc_build_items CASCADE;
DROP TABLE IF EXISTS password_resets CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS login_logs CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS flash_sales CASCADE;
DROP TABLE IF EXISTS flash_sale_items CASCADE;
DROP TABLE IF EXISTS chat_messages CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS carts CASCADE;
DROP TABLE IF EXISTS cart_items CASCADE;

-- Create tables
-- Table structure for table: users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    phone VARCHAR(255),
    address TEXT,
    enabled BOOLEAN DEFAULT TRUE,
    auth_provider VARCHAR(255),
    provider_id VARCHAR(255),
    avatar VARCHAR(255),
    birthday TIMESTAMP WITHOUT TIME ZONE,
    gender BOOLEAN,
    status BOOLEAN,
    notify_flash_sale BOOLEAN,
    notify_new_products BOOLEAN,
    notify_order_updates BOOLEAN,
    notify_weekly_newsletter BOOLEAN,
    two_factor_enabled BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table structure for table: user_sessions
CREATE TABLE user_sessions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    session_id VARCHAR(255) NOT NULL UNIQUE,
    user_agent VARCHAR(500),
    device_info VARCHAR(255),
    ip_address VARCHAR(50),
    location VARCHAR(100),
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_expired BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table structure for table: roles
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);

-- Table structure for table: user_roles
CREATE TABLE user_roles (
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    id SERIAL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- Table structure for table: password_resets
CREATE TABLE password_resets (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100),
    token VARCHAR(255),
    expiry TIMESTAMP
);

-- Table structure for table: login_logs
CREATE TABLE login_logs (
    id SERIAL PRIMARY KEY,
    user_id INT,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Table structure for table: categories
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    display TEXT,
    slug VARCHAR(255)
);

-- Table structure for table: products
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    description TEXT,
    image VARCHAR(255),
    category_id INT,
    stock INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Table structure for table: inventory
CREATE TABLE inventory (
    id SERIAL PRIMARY KEY,
    product_id INT UNIQUE,
    quantity INT DEFAULT 0,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Table structure for table: stock_movements
CREATE TABLE stock_movements (
    id SERIAL PRIMARY KEY,
    product_id INT,
    change_quantity INT,
    movement_type VARCHAR(255),
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Table structure for table: carts
CREATE TABLE carts (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table structure for table: cart_items
CREATE TABLE cart_items (
    id SERIAL PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Table structure for table: orders
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT,
    total_price DECIMAL(15,2),
    status VARCHAR(50),
    order_code VARCHAR(255) UNIQUE,
    full_name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    address TEXT,
    city VARCHAR(255),
    discount_amount DECIMAL(15,2) DEFAULT 0,
    voucher_code VARCHAR(255),
    installment_bank VARCHAR(255),
    installment_fee DECIMAL(15,2) DEFAULT 0,
    installment_term INT,
    payment_method VARCHAR(255),
    admin_note TEXT,
    refund_previous_status VARCHAR(255),
    refund_reason TEXT,
    stock_deducted BOOLEAN,
    stock_restored BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Table structure for table: order_items
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    price DECIMAL(15,2),
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Table structure for table: pc_builds
CREATE TABLE pc_builds (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    total_price DECIMAL(15,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table structure for table: pc_build_items
CREATE TABLE pc_build_items (
    id SERIAL PRIMARY KEY,
    build_id INT NOT NULL,
    product_id INT NOT NULL,
    FOREIGN KEY (build_id) REFERENCES pc_builds(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Table structure for table: shared_builds
CREATE TABLE shared_builds (
    share_code VARCHAR(15) PRIMARY KEY,
    build_id INT NOT NULL,
    name VARCHAR(100) DEFAULT 'Cấu hình chia sẻ từ LuxuryPC',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (build_id) REFERENCES pc_builds(id) ON DELETE CASCADE
);

-- Table structure for table: chat_messages
CREATE TABLE chat_messages (
    id INTEGER NOT NULL DEFAULT nextval('chat_messages_id_seq'::regclass),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    message TEXT,
    sender CHARACTER VARYING(255),
    sender_name CHARACTER VARYING(255),
    ticket_id INTEGER,
    PRIMARY KEY (id)
);


-- Table structure for table: flash_sale_items
CREATE TABLE flash_sale_items (
    id INTEGER NOT NULL DEFAULT nextval('flash_sale_items_id_seq'::regclass),
    sale_price DOUBLE PRECISION,
    sale_quantity INTEGER,
    sold_count INTEGER,
    flash_sale_id INTEGER,
    product_id INTEGER,
    PRIMARY KEY (id)
);


-- Table structure for table: flash_sales
CREATE TABLE flash_sales (
    id INTEGER NOT NULL DEFAULT nextval('flash_sales_id_seq'::regclass),
    active BOOLEAN,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    end_time TIMESTAMP WITHOUT TIME ZONE,
    name CHARACTER VARYING(255),
    start_time TIMESTAMP WITHOUT TIME ZONE,
    PRIMARY KEY (id)
);


-- Table structure for table: reviews
CREATE TABLE reviews (
    id INTEGER NOT NULL,
    content CHARACTER VARYING(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    stars INTEGER,
    user_id INTEGER,
    product_id INTEGER,
    order_id INTEGER,
    title CHARACTER VARYING(255),
    image CHARACTER VARYING(255),
    PRIMARY KEY (id)
);


-- Table structure for table: shipping_addresses
CREATE TABLE shipping_addresses (
    id INTEGER NOT NULL DEFAULT nextval('shipping_addresses_id_seq'::regclass),
    address CHARACTER VARYING(500) NOT NULL,
    city CHARACTER VARYING(120),
    is_default BOOLEAN NOT NULL,
    district CHARACTER VARYING(120),
    phone CHARACTER VARYING(255) NOT NULL,
    recipient_name CHARACTER VARYING(255) NOT NULL,
    user_id INTEGER NOT NULL,
    PRIMARY KEY (id)
);


-- Table structure for table: spring_session
CREATE TABLE spring_session (
    primary_id CHARACTER(36) NOT NULL,
    session_id CHARACTER(36) NOT NULL,
    creation_time BIGINT NOT NULL,
    last_access_time BIGINT NOT NULL,
    max_inactive_interval INTEGER NOT NULL,
    expiry_time BIGINT NOT NULL,
    principal_name CHARACTER VARYING(100),
    PRIMARY KEY (primary_id)
);


-- Table structure for table: spring_session_attributes
CREATE TABLE spring_session_attributes (
    session_primary_id CHARACTER(36) NOT NULL,
    attribute_name CHARACTER VARYING(200) NOT NULL,
    attribute_bytes BYTEA NOT NULL,
    PRIMARY KEY (session_primary_id, attribute_name)
);


-- Table structure for table: support_tickets
CREATE TABLE support_tickets (
    id INTEGER NOT NULL DEFAULT nextval('support_tickets_id_seq'::regclass),
    admin_reply TEXT,
    assigned_admin CHARACTER VARYING(255),
    build_config TEXT,
    category CHARACTER VARYING(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    customer_email CHARACTER VARYING(255),
    customer_name CHARACTER VARYING(255),
    customer_phone CHARACTER VARYING(255),
    message TEXT,
    status CHARACTER VARYING(255),
    subject CHARACTER VARYING(1000),
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    user_id INTEGER,
    PRIMARY KEY (id)
);


-- Table structure for table: ticket_messages
CREATE TABLE ticket_messages (
    id INTEGER NOT NULL DEFAULT nextval('ticket_messages_id_seq'::regclass),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    message TEXT NOT NULL,
    sender CHARACTER VARYING(255) NOT NULL,
    sender_name CHARACTER VARYING(255),
    ticket_id INTEGER NOT NULL,
    PRIMARY KEY (id)
);


-- Table structure for table: tickets
CREATE TABLE tickets (
    id INTEGER NOT NULL DEFAULT nextval('tickets_id_seq'::regclass),
    assigned_admin CHARACTER VARYING(255),
    build_config TEXT,
    category CHARACTER VARYING(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    customer_email CHARACTER VARYING(255),
    customer_name CHARACTER VARYING(255) NOT NULL,
    customer_phone CHARACTER VARYING(255),
    message TEXT,
    status CHARACTER VARYING(255),
    subject CHARACTER VARYING(255) NOT NULL,
    PRIMARY KEY (id)
);


-- Table structure for table: user_addresses
CREATE TABLE user_addresses (
    id INTEGER NOT NULL DEFAULT nextval('user_addresses_id_seq'::regclass),
    address CHARACTER VARYING(500) NOT NULL,
    city CHARACTER VARYING(150),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    district CHARACTER VARYING(150),
    is_default BOOLEAN,
    phone CHARACTER VARYING(255) NOT NULL,
    recipient_name CHARACTER VARYING(255) NOT NULL,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    user_id INTEGER NOT NULL,
    address_line CHARACTER VARYING(1000),
    receiver_name CHARACTER VARYING(255),
    PRIMARY KEY (id)
);


-- Table structure for table: user_notification_settings
CREATE TABLE user_notification_settings (
    id INTEGER NOT NULL DEFAULT nextval('user_notification_settings_id_seq'::regclass),
    flash_sale BOOLEAN,
    member_points BOOLEAN,
    new_products BOOLEAN,
    order_updates BOOLEAN,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    weekly_newsletter BOOLEAN,
    user_id INTEGER NOT NULL,
    PRIMARY KEY (id)
);


-- Table structure for table: user_vouchers
CREATE TABLE user_vouchers (
    id INTEGER NOT NULL DEFAULT nextval('user_vouchers_id_seq'::regclass),
    is_used BOOLEAN NOT NULL,
    saved_at TIMESTAMP WITHOUT TIME ZONE,
    used_at TIMESTAMP WITHOUT TIME ZONE,
    user_id INTEGER NOT NULL,
    voucher_id INTEGER NOT NULL,
    PRIMARY KEY (id)
);


-- Table structure for table: vouchers
CREATE TABLE vouchers (
    id INTEGER NOT NULL DEFAULT nextval('vouchers_id_seq'::regclass),
    active BOOLEAN,
    code CHARACTER VARYING(255) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    description CHARACTER VARYING(255),
    discount_type CHARACTER VARYING(255),
    discount_value DOUBLE PRECISION,
    end_date TIMESTAMP WITHOUT TIME ZONE,
    max_discount_amount DOUBLE PRECISION,
    min_order_amount DOUBLE PRECISION,
    start_date TIMESTAMP WITHOUT TIME ZONE,
    usage_limit INTEGER,
    used_count INTEGER,
    category_id INTEGER,
    PRIMARY KEY (id)
);


-- Table structure for table: wishlist_items
CREATE TABLE wishlist_items (
    id INTEGER NOT NULL DEFAULT nextval('wishlist_items_id_seq'::regclass),
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    product_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    PRIMARY KEY (id)
);


-- Dumping data
-- Dumping data for table: users
INSERT INTO users (id, address, auth_provider, created_at, email, full_name, password, phone, provider_id, username, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled) VALUES (7, NULL, 'LOCAL', '2026-03-28 15:19:21.008000', 'balittedutphieukhang@gmail.com', 'Nguyễn khang', '$2a$10$ceBXGEZmWVqVhpH48b2TZuuMNgdGPxYTq4ydS.7erOj7cpOHhaB2y', '+84859590337', NULL, 'balittedutphieukhang@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, address, auth_provider, created_at, email, full_name, password, phone, provider_id, username, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled) VALUES (23, NULL, 'LOCAL', '2026-06-02 19:06:27.115000', 'phamcongthanh.8311@gmail.com', 'Thanh Phạm', '$2a$10$K/JwYrKJtJx2PQFJZ9tPJ..HY0dfEZA3h4zxXH4VJLNsCyGzVGWkG', '0902208461', NULL, 'phamcongthanh.8311@gmail.com', NULL, NULL, NULL, True, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, address, auth_provider, created_at, email, full_name, password, phone, provider_id, username, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled) VALUES (24, NULL, 'LOCAL', '2026-06-02 20:52:04.049000', 'ditmemaygogle113@gmail.com', 'Thanh Phạm', '$2a$10$/XRdhZRo3KLXI0FZbAu1e.ycsE.ZyAjy3mQhZE5mJcOz/yQHo/Bbi', '0936629311', NULL, 'ditmemaygogle113@gmail.com', NULL, NULL, NULL, True, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, address, auth_provider, created_at, email, full_name, password, phone, provider_id, username, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled) VALUES (26, NULL, 'LOCAL', '2026-06-08 15:23:54.309000', 'admin@luxurypc.com', 'Admin LuxuryPC', '$2a$10$F76h/W85bFv9Kp040CV4ju4N/jhKpRhXaWgWzewsDa8kDzkHtfXhS', NULL, NULL, 'admin', NULL, NULL, NULL, True, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, address, auth_provider, created_at, email, full_name, password, phone, provider_id, username, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled) VALUES (25, NULL, 'GOOGLE', '2026-06-08 15:14:14.918000', 'nguyentruongq169@gmail.com', 'Quân Nguyễn Trường', '$2a$10$JKkTGHPr.EWsXIr0/PPgzuq4pFp/QDiBLkQ0n0b/XSQbGouVpIlJ.', NULL, '113506180708155747249', 'nguyentruongq169', NULL, NULL, NULL, True, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, address, auth_provider, created_at, email, full_name, password, phone, provider_id, username, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled) VALUES (32, NULL, 'GOOGLE', '2026-06-13 20:27:12.538000', 'mazack707@gmail.com', 'Zack Ma', NULL, NULL, '115229939720924175799', 'mazack707', NULL, NULL, NULL, True, True, False, True, True, False);
INSERT INTO users (id, address, auth_provider, created_at, email, full_name, password, phone, provider_id, username, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled) VALUES (9, NULL, 'LOCAL', '2026-03-28 15:59:09.715000', 'tuan9bledinhchinh@gmail.com', 'nguyen tuan', '$2a$10$3wA6X7TEsnW5ymYdePRokuIN/FLZ.eIRMD4UQBh8PIyh/3z.LLn0q', '+84905338411', NULL, 'tuan9bledinhchinh@gmail.com', NULL, '1995-10-18 00:00:00', True, True, True, False, True, True, NULL);
INSERT INTO users (id, address, auth_provider, created_at, email, full_name, password, phone, provider_id, username, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled) VALUES (31, NULL, 'LOCAL', '2026-06-12 21:16:32.031000', 'djtmefacebook9@gmail.com', 'Thanh Phạm', '$2a$10$KAKrL.51KRhIot0lbCfGzeTyNcE.NAKLH7OFlKm7XULtfxWoqXari', '0933456789', NULL, 'djtmefacebook9@gmail.com', NULL, NULL, NULL, False, True, False, True, True, NULL);
INSERT INTO users (id, address, auth_provider, created_at, email, full_name, password, phone, provider_id, username, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled) VALUES (29, NULL, 'LOCAL', '2026-06-12 18:47:49.406000', 'leecookcu@gmail.com', 'Thanh Phạmm', '$2a$10$gEGST5TNSwFEkZU/t3k0nutrVNuHGrwBzL19cePuf.BWmRb7UYMc.', '0952525252', NULL, 'leecookcu@gmail.com', '/uploads/avatars/user_29_1781273025577.jpg', NULL, True, True, False, False, True, True, False);
INSERT INTO users (id, address, auth_provider, created_at, email, full_name, password, phone, provider_id, username, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled) VALUES (33, NULL, 'LOCAL', '2026-06-14 19:11:56.269000', 'ngochai2007nt@gmail.com', 'Hải Nguyễn Ngọc', '$2a$10$1soqIA9YDYg0ggZoYV0Cm.OHY81wkRw2GF8dlFtvIRUcU8Pa5Si0u', '+84384333382', NULL, 'ngochai2007nt@gmail.com', NULL, NULL, NULL, True, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, address, auth_provider, created_at, email, full_name, password, phone, provider_id, username, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled) VALUES (30, NULL, 'LOCAL', '2026-06-12 20:33:46.571000', 'tuannguyennasani@gmail.com', 'Thanh Phạm', '$2a$10$rcVvRAGy83rllwo8olMgpurZQeAGrgZsObzerd.OrxPWxIk2egiom', '0923456789', NULL, 'tuannguyennasani@gmail.com', NULL, NULL, NULL, True, True, False, True, True, NULL);
INSERT INTO users (id, address, auth_provider, created_at, email, full_name, password, phone, provider_id, username, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled) VALUES (1, NULL, 'LOCAL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, False, NULL, NULL, NULL, NULL, NULL);

-- Dumping data for table: roles
INSERT INTO roles (id, name) VALUES (1, 'ADMIN');
INSERT INTO roles (id, name) VALUES (2, 'USER');
INSERT INTO roles (id, name) VALUES (3, 'STAFF');

-- Dumping data for table: user_roles
INSERT INTO user_roles (user_id, role_id, id) VALUES (23, 1, 21);
INSERT INTO user_roles (user_id, role_id, id) VALUES (24, 1, 22);
INSERT INTO user_roles (user_id, role_id, id) VALUES (9, 1, 23);
INSERT INTO user_roles (user_id, role_id, id) VALUES (25, 2, 24);
INSERT INTO user_roles (user_id, role_id, id) VALUES (26, 1, 25);
INSERT INTO user_roles (user_id, role_id, id) VALUES (25, 1, 26);
INSERT INTO user_roles (user_id, role_id, id) VALUES (29, 1, 28);
INSERT INTO user_roles (user_id, role_id, id) VALUES (30, 1, 29);
INSERT INTO user_roles (user_id, role_id, id) VALUES (31, 1, 30);
INSERT INTO user_roles (user_id, role_id, id) VALUES (32, 2, 31);
INSERT INTO user_roles (user_id, role_id, id) VALUES (33, 1, 32);

-- Dumping data for table: password_resets
INSERT INTO password_resets (id, email, token, expiry) VALUES (6, 'tuan9bledinhchinh@gmail.com', '660514', '2026-06-12 21:50:08.369262');

-- (No data found for table: login_logs)

-- Dumping data for table: categories
INSERT INTO categories (id, name, Display, slug) VALUES (1, 'CPU', NULL, NULL);
INSERT INTO categories (id, name, Display, slug) VALUES (2, 'GPU', NULL, NULL);
INSERT INTO categories (id, name, Display, slug) VALUES (3, 'RAM', NULL, NULL);
INSERT INTO categories (id, name, Display, slug) VALUES (4, 'Mainboard', NULL, NULL);
INSERT INTO categories (id, name, Display, slug) VALUES (5, 'SSD', NULL, NULL);
INSERT INTO categories (id, name, Display, slug) VALUES (6, 'Màn hình', NULL, NULL);
INSERT INTO categories (id, name, Display, slug) VALUES (84, 'HDD', NULL, NULL);
INSERT INTO categories (id, name, Display, slug) VALUES (85, 'PSU', NULL, NULL);
INSERT INTO categories (id, name, Display, slug) VALUES (86, 'Case', NULL, NULL);
INSERT INTO categories (id, name, Display, slug) VALUES (87, 'CPU Cooler', NULL, NULL);
INSERT INTO categories (id, name, Display, slug) VALUES (88, 'Case Fan', NULL, NULL);
INSERT INTO categories (id, name, Display, slug) VALUES (89, 'Keyboard', NULL, NULL);
INSERT INTO categories (id, name, Display, slug) VALUES (90, 'Mouse', NULL, NULL);
INSERT INTO categories (id, name, Display, slug) VALUES (91, 'Headset', NULL, NULL);

-- Dumping data for table: products
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (7, 'Intel Core i9-13900KS', 18500000.0, 'Special Edition, 6.0GHz', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNTOeUWo3eiFKa-X68ObTEr1u76TTHJg2a6Q&s', 1, 10, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (12, 'AMD Ryzen 5 5600G', 3200000.0, 'Integrated Vega Graphics', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjjlTc1Ws8iGAOKvzza3wk2OJCZeZ16E2PCA&s', 1, 80, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (13, 'Intel Core i3-14100', 3800000.0, 'Entry level 14th Gen', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1S7WFBKIkUSuAQ9fiUiSmLq2RlvfEXHzGow&s', 1, 70, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (14, 'AMD Ryzen 3 4100', 1800000.0, 'Budget 4 Cores, AM4', 'https://cdn.hstatic.net/products/200000420363/r32_bf1d9af6e6804d3083bb565b51b2__1__51d6caf6f179485794d99e272aaa1bd3_master.png', 1, 120, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (16, 'AMD Ryzen 9 5950X', 11000000.0, '16 Cores, Workstation AM4', 'https://product.hstatic.net/1000129940/product/ryzen-9-5950x_35e39fe54f2d4a4281a5a1e310b82c35_master.jpg', 1, 12, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (17, 'Intel Core i5-14400F', 5600000.0, '10 Cores, Efficient Gaming', 'https://bizweb.dktcdn.net/thumb/grande/100/329/122/products/cpu-intel-core-i5-14400f-up-to-4-7ghz-10-cores-16-threads-20mb.jpg?v=1734109255247', 1, 65, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (18, 'AMD Ryzen 5 8600G', 6200000.0, 'AI Engine, Radeon 760M', 'https://product.hstatic.net/200000722513/product/gearvn-bo-vi-xu-ly-amd-ryzen-5-8600g-1_8d200390a2de4022b8b0d3131730a762_master.png', 1, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (19, 'Intel Core i7-12700K', 7200000.0, '12 Cores, LGA 1700', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzVSYhB5PBFRGIZkd-L6FugM2uYPwhcyz4JQ&s', 1, 35, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (20, 'AMD Ryzen 7 7700', 7800000.0, '8 Cores, Low Power 65W', 'https://gearvn.com/products/amd-ryzen-7-7700?srsltid=AfmBOor_s1BdZYqRs1_JVyJnMjFg4RKXr4P2Ftlo0WwjDYJge5HDsUX_1', 1, 28, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (21, 'Intel Core i5-11400F', 2800000.0, 'Old Gen Budget King', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJI1Qlnp-0Q1hANQNbLbQLiEMyYlZaUVs1XA&s', 1, 50, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (22, 'AMD Ryzen 5 4500', 1950000.0, 'Super Budget 6 Cores', 'https://product.hstatic.net/200000722513/product/amd1_8bb5a6a47c154c4f92f45770ba53eeb5_269ec8149b994f77abad19bc0e46b08a_master.jpg', 1, 95, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (23, 'Intel Core i9-11900K', 6500000.0, 'Legacy Flagship LGA 1200', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5DCT89rDmRZ6l4dtpGM-LC8tvZt35ypbczw&s', 1, 10, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (24, 'AMD Ryzen 5 3600', 2100000.0, 'Popular AM4 CPU', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBGOh0FEb3lQEuK6tPm04RkK_q120GnQeS-w&s', 1, 150, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (25, 'Intel Core i5-10400F', 2200000.0, 'Stable and Cheap', 'https://product.hstatic.net/200000420363/product/_2023_-khung-sp-_1__cdffe0496fbb41cc84c1ba03dc38c180_master.jpg', 1, 110, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (26, 'AMD Ryzen 9 3900X', 7500000.0, '12 Cores, Workstation', 'https://product.hstatic.net/200000722513/product/ryzen_9_gen3_gearvn_e5d4fc47094e44d7af5a6bed5e2e8fe8_048d97db994e44eab5d183121f15a626_master.jpg', 1, 8, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (27, 'Intel Pentium G7400', 1900000.0, 'Office work, 2 Cores', 'https://product.hstatic.net/1000333506/product/64780_cpu_intel_pentium_gold_g7400_8f39d0dc61ca4ca18deed1fe7c570bf4_1024x1024.png', 1, 200, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (28, 'AMD Athlon 3000G', 1200000.0, 'Ultra Budget Graphics', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/_/t_i_xu_ng_-_2023-01-02t232149.435.png', 1, 180, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (29, 'Intel Core i7-10700K', 4800000.0, 'High Clock Legacy', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBP9MEIU-o1OSI8rwfITkhdM2w-jDwzdHLmQ&s', 1, 20, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (30, 'AMD Ryzen 7 8700G', 9200000.0, 'Powerful APU, Radeon 780M', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRN8bTprWZAUTD5Q6PyGKLA8tFldAglOhORw&s', 1, 33, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (31, 'NVIDIA RTX 4090 24GB', 55000000.0, 'Ultimate Gaming GPU', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-ZR2Lj82i1vmxh1glbRmBOTOtBtpP3MFTcQ&s', 2, 10, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (32, 'RTX 4080 Super', 32000000.0, 'High-end 4K Gaming', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0WXKBLWS5jzk0pN4X_y2mCIEglX5HwverPQ&s', 2, 15, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (33, 'RTX 4070 Ti Super', 24500000.0, 'Perfect for 2K Gaming', 'https://anphat.com.vn/media/product/47596_vga_msi_rtx_4070_ti_super_16gb_gaming_x_slim__2_.jpg', 2, 25, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (34, 'AMD RX 7900 XTX', 28500000.0, 'AMD Flagship, 24GB', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI00RPWF05bb4QXDY4ejaKQUjlMj1Nnh4XFw&s', 2, 12, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (36, 'AMD RX 7800 XT', 15200000.0, 'Best value 2K GPU', 'https://product.hstatic.net/1000333506/product/gigabyte-rx-7800-xt-gaming-oc-16g-2_ccfbd3c45c5f451ba7cc9bc102c4ccad.jpg', 2, 30, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (37, 'RTX 3060 12GB', 7800000.0, 'Popular Mid-range', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT28R1aLdxWEqfKBX429I1K4qVRJsTbnLfYjA&s', 2, 80, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (38, 'AMD RX 6600', 5500000.0, 'Best budget 1080p', 'https://product.hstatic.net/200000320233/product/ard-man-hinh-asus-dual-radeon-rx_2d5cd0c0ade14aab87293c31e6b91322_1024x1024.png', 2, 100, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (160, 'BenQ SW271C', 42000000.0, 'Pro Color Photo', 'https://m.media-amazon.com/images/I/5154q1lfAmL._AC_UF1000,1000_QL80_.jpg', 6, 3, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (3, 'Intel Core i7-14700Kkk', 10800000.0, '20 Cores, Hybrid Architecture', 'https://product.hstatic.net/200000320233/product/i7_01bbf06595c041489008499b74309cd5_1024x1024.jpg', 1, 40, NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (35, 'RTX 4060 Ti 8GB', 11500000.0, 'Efficient 1080p/2K', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGDNXSlME_AwShZEtCVVkxQv_tliDp9J_hqw&s', 2, 43, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (4, 'AMD Ryzen 7 7800X3D', 11500000.0, 'Best gaming CPU, 8 Cores, 3D V-Cache', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/c/p/cpu-amd-ryzen-7-7800x3d_2__3.png', 1, 27, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (5, 'Intel Core i5-13600K', 8200000.0, '14 Cores, Mid-range gaming', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_GqKybMrN4lvBKWHO1nwrrCMSP3zmISV-bA&s', 1, 54, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (6, 'AMD Ryzen 5 7600X', 5800000.0, '6 Cores, Zen 4 Architecture, AM5', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQE2ZChV8gJTrHnxTZJbSky0qzv8-dRvLqr_w&s', 1, 59, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (8, 'AMD Ryzen 9 7900X', 10500000.0, '12 Cores, 5.6GHz Boost', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9zAZ6GbCmGCvRG_GnshV96_8OjJqt6ztgjQ&s', 1, 18, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (2, 'AMD Ryzen 9 7950X3D', 17200000.0, '16 Cores, 128MB L3 Cache, AM5', 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=400&auto=format&fit=crop', 1, 15, NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (15, 'Intel Core i9-12900K', 9500000.0, '16 Cores, Previous Flagship', 'https://nguyencongpc.vn/media/product/21239-intel-core-i9-12900k-2.jpg', 1, 13, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (10, 'AMD Ryzen 7 5800X3D', 8500000.0, 'Legendary AM4 gaming CPU', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR90etQo199jMkqkqyxT3N-Nz6qaeKG9w913Q&s', 1, 25, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (11, 'Intel Core i5-12400F', 3500000.0, 'Budget King, 6 Cores', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/c/p/cpu-intel-core-i5-12400f.jpg', 1, 96, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (9, 'Intel Core i7-13700F', 8900000.0, '16 Cores, No Integrated Graphics', 'https://product.hstatic.net/200000837185/product/13700f-copy-compressed-400x400_55edfa0c1c90408180d182cc8e261efc.jpg', 1, 45, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (39, 'ASUS ROG RTX 4090', 62000000.0, 'Premium build cooling', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxc6SsgcZgMwfxEbJjGtoaUusldFpgjGfDRw&s', 2, 5, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (40, 'MSI Gaming X RTX 4070', 18500000.0, 'Quiet and Cool', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR5w_hnXOfi3bi5JZTrzZXqtRP7g0k8xBGVCg&s', 2, 20, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (41, 'Gigabyte Eagle RTX 4060', 8200000.0, 'Triple Fan Budget', 'https://nguyencongpc.vn/media/product/25062-geforce-rtx----4060-ti-eagle-oc-8g-01.png', 2, 60, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (42, 'RTX 4070 Super', 17800000.0, '12GB GDDR6X, Fast', 'https://product.hstatic.net/200000320233/product/94_vga_gigabyte_rtx_4070_windforce_oc_12gb__n4070wf3_oc_12gd__anphat88_123e5c53c26c4fc8a60591163fb68295_1024x1024.jpg', 2, 35, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (43, 'AMD RX 7600', 7900000.0, 'Budget RDNA 3', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/v/g/vga-sapphire-radeon-rx-7600-gaming-oc-8gb-gddr6_1_.png', 2, 50, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (44, 'RTX 3050 6GB', 5200000.0, 'Entry level RTX', 'https://hoanglongcomputer.vn/media/product/250-3904-dual-rtx3050-o6g-9-510x510.png', 2, 70, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (45, 'Zotac RTX 4060', 7800000.0, 'Compact dual fan', 'https://s4.quan.pro.vn/files/421/zotac-4060ti-16gb-1-6772223a36eb4.jpg', 2, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (46, 'Galax RTX 4070 Pink', 16900000.0, 'Pink Edition RGB', 'https://product.hstatic.net/200000420363/product/1_bb3aa1bdb24b451db1692606b0196477_master.jpg', 2, 15, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (47, 'ASUS TUF RTX 3070 Ti', 12000000.0, 'Rugged build quality', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLfx8dtv_7IYp5hDyLh3PtCWMQIVN1WAARpg&s', 2, 10, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (48, 'EVGA RTX 3080', 15000000.0, 'High performance legacy', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVN-TDorwtNszMTZS-G4RWU3xYcQBTGJaieQ&s', 2, 5, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (49, 'Sapphire RX 7900 GRE', 16500000.0, 'Golden Rabbit Edition', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToLJs-XKcvVpSOF6WWwYiI7Qc0MosYzazHqg&s', 2, 18, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (50, 'PowerColor RX 7800 XT', 14800000.0, 'Excellent cooling', 'https://images-na.ssl-images-amazon.com/images/I/71xBR512Z-L.jpg', 2, 22, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (51, 'GTX 1650', 3800000.0, 'No external power', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7I7gaaKRjAHrC0wq0sUmNJb_tzs58cZf0Zg&s', 2, 150, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (52, 'RX 6700 XT', 9500000.0, 'Great 1440p value', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/1/6/16_2_144.jpg', 2, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (53, 'Colorful RTX 4080', 31000000.0, 'LCD screen on GPU', 'https://nguyencongpc.vn/media/product/23870-geforce-rtx-4080-16gb-nb-ex-vgeforce-rtx-4080-16gb-nb-ex-vv.jpg', 2, 8, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (54, 'Quadro RTX A4000', 22000000.0, 'Workstation GPU', 'https://product.hstatic.net/200000320233/product/13876_013ef03013014b1782450a58ba5bc0b9_grande.jpeg', 2, 10, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (55, 'Radeon Pro W7800', 58000000.0, 'Professional Graphics', 'https://bizweb.dktcdn.net/100/410/941/products/bpstore-gigabyte-pro-w7800-ai-top-32gb-11.png?v=1723281572970', 2, 3, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (56, 'Intel Arc A770 16GB', 9200000.0, 'Intel High-end GPU', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT30BU7KxqcuR-qNVKIMNYpKVUHQRB0RR96UA&s', 2, 25, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (57, 'Intel Arc A750', 6500000.0, 'Budget King Intel', 'https://nguyencongpc.vn/media/product/24605-vg0000111vg0000111.jpg', 2, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (58, 'ASUS Dual RTX 4070', 17500000.0, 'Clean white build', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgvmB_rvND0_sToNSqABZ_aUp13fJd_koO3g&s', 2, 15, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (59, 'Gigabyte RTX 4090', 59000000.0, 'Massive cooler', 'https://hanoicomputercdn.com/media/product/78825_card_man_hinh_gigabyte_rtx_4090_windforce_v2_24gb__2_.jpg', 2, 4, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (60, 'PNY RTX 4060', 7500000.0, 'Small and efficient', 'https://bizweb.dktcdn.net/thumb/grande/100/329/122/products/vga-pny-geforce-rtx-4060-8gb-xlr8-gaming-verto-overclocked-dual-fan-09.jpg?v=1743639638557', 2, 55, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (61, 'Corsair Vengeance 32GB', 3500000.0, 'DDR5 6000MHz Black', 'https://nguyencongpc.vn/media/product/17942-corsair-vengeance-pro-rgb-32gb-1.JPG', 3, 50, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (62, 'G.Skill Trident Z5 32GB', 4200000.0, 'DDR5 6400MHz RGB', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJwLYJdUIdWN9y75zXqP4T9lzHDvfmnTNTug&s', 3, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (63, 'Kingston Fury 16GB', 1250000.0, 'DDR4 3200MHz', 'https://product.hstatic.net/200000320233/product/54727_ram_kingston_fury_beast_16gb_2_6d214b308f954f85aa6ea0e2b96ef966_grande.jpg', 3, 120, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (64, 'T-Force Delta 32GB', 3200000.0, 'DDR5 6000MHz White', 'https://product.hstatic.net/200000420363/product/ram-ddr5-teamgroup-32g_6000-den_10347fc7c3704fe7957ec5b6e3f5eb53_master.jpg', 3, 45, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (65, 'ADATA XPG 16GB', 1800000.0, 'DDR5 5200MHz', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI8T_G9mxTBfXWzjPuGV0rSuP5_rB99ByCmA&s', 3, 70, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (66, 'Crucial 8GB', 650000.0, 'Standard office RAM', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvk-K7WWJ13SqS-4t3iHkEEnweJPLnTLBP3A&s', 3, 200, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (67, 'Dominator Titanium 64GB', 9500000.0, 'DDR5 7200MHz', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6d9DrkMieLZJec_hhRq3LALlcNODtcoIbqw&s', 3, 10, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (68, 'Ripjaws V 16GB', 1100000.0, 'DDR4 3600MHz', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQC7T4dDTqtsn-nQ0O7rYnFdgOur8nqyHKUOw&s', 3, 90, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (69, 'Lexar Thor 32GB', 2100000.0, 'DDR4 3200MHz Budget', 'https://nguyencongpc.vn/media/product/27370-ram-lexar-thor-rgb-32gb-2-16gb-ddr5-6000mhz-2.jpg', 3, 55, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (70, 'Fury Renegade 32GB', 4800000.0, 'DDR5 7200MHz', 'https://product.hstatic.net/1000129940/product/ram-kingston-fury-renegade-rgb-32gb-2x16gb-bus-3200-cl16-1_f7a2e6587f344f208329dec49f9ba2b2_master.jpg', 3, 25, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (71, 'PNY XLR8 16GB', 1350000.0, 'DDR4 3200MHz RGB', 'https://hoanglongcomputer.vn/media/product/3407-ram-pc-pny-xlr8-gaming-ddr4-3200mhz-2.jpg', 3, 60, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (72, 'Silicon Power 16GB', 950000.0, 'Value RAM 3200', 'https://media.vitinhnguyenkim.vn/uploads/product/linh-kien/Silicon-Power-DDR4-2666MHz-Desktop-RAM-4GB-8GB-16GB-DDR4-UDIMM-compatible-with-DDR4-2400-2133_1.jpg', 3, 150, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (73, 'Mushkin Redline 32GB', 3400000.0, 'DDR5 5600MHz', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQMxpfLpVartaLXSRcCe4RuF7DayKlumGzzw&s', 3, 20, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (74, 'Patriot Viper 16GB', 1450000.0, 'DDR4 4000MHz', 'https://nguyencongpc.vn/media/product/250-28198-ram-pc-patriot-viper-steel-rgb-16gb-01.jpg', 3, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (75, 'Samsung 32GB', 2800000.0, 'DDR5 4800MHz OEM', 'https://ictsaigon.com.vn/storage/products/samsung-32gb-ddr4-2400m-feature-img.webp', 3, 30, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (76, 'Thermaltake 16GB', 2200000.0, 'DDR4 3600MHz RGB', 'https://product.hstatic.net/200000420363/product/_2023_-khung-sp-_1__29355c55ae9741c78a2839264b0118b1_master.jpg', 3, 25, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (77, 'Zadak Spark 32GB', 3900000.0, 'DDR5 6000MHz', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmAkq4EYiWbqg3TdNKVZ3Bz6GnH1aVrDdE3g&s', 3, 15, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (78, 'Apacer Panther 8GB', 750000.0, 'Budget Gaming RAM', 'https://www.tncstore.vn/media/product/6898-63927_ram_desktop_apacer_oc_panther_golden_ah4u08g32c28y7gaa_1_8gb_1x8gb_ddr4_3200mhz.jpg', 3, 100, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (79, 'GeIL Super Luce 16GB', 1300000.0, 'DDR4 3200MHz', 'https://product.hstatic.net/200000420363/product/_new_-anh-sp-web_8d9a32876494486e823935e646a2d741_master.jpg', 3, 50, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (80, 'V-Color Prism 32GB', 3100000.0, 'DDR4 3600MHz RGB', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRx0jib_fBc7P7vr9NQ6V7j0lnOaZYYRoWncA&s', 3, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (81, 'Kingston Fury 64GB', 6800000.0, 'DDR5 5600MHz Kit', 'https://bizweb.dktcdn.net/100/329/122/products/ram-pc-kingston-fury-beast-rgb-ddr5-ec071597-0992-4e42-b680-18023a91784d.jpg?v=1673082941170', 3, 20, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (82, 'Vengeance LPX 32GB', 2500000.0, 'DDR4 3200 Low Profile', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/corsair-ddr4-2400-bl-01-9c7efed5-6edc-4f1d-a226-aafee2a6b745-7f43f33a-1297-4a8d-aa9a-02a63cc29507-1cd7c6ce-7ebc-44f6-8db3-14b34b235174-1fb04a2e-a2dc-4a93-a59e-c2525b12aeb1.jpg?v=1598607202777', 3, 80, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (83, 'Trident Z Neo 32GB', 3400000.0, 'Optimized for Ryzen', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/trident-z-neo-03-262449fd-18a0-4f7c-ab41-5c3b36f9d969.jpg?v=1758522514737', 3, 35, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (84, 'Team Elite 16GB', 1600000.0, 'DDR5 4800 Basic', 'https://anphat.com.vn/media/product/40235_untitled_1.jpg', 3, 60, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (85, 'Crucial Pro 32GB', 3300000.0, '6000MHz Overclock', 'https://nguyencongpc.vn/media/product/26296-image.png', 3, 45, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (86, 'Aorus RGB 16GB', 2400000.0, '3733MHz w/ Demo', 'https://nguyencongpc.vn/media/product/20017-aorus-rgb-memory-16gb-3600mhz-4.jpg', 3, 15, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (87, 'Lexar Ares 32GB', 3600000.0, 'DDR5 6400MHz', 'https://bizweb.dktcdn.net/100/329/122/products/ram-pc-lexar-ares-rgb-32gb-3600mhz-ddr4-2x16gb-ld4bu016g-r3600gdla.jpg?v=1719680806457', 3, 30, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (89, 'Galax HOF 32GB', 5500000.0, '8000MHz White OC', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4JfmNC-41bDN4E_CvEcTvNvejKiMJ3_CCxw&s', 3, 5, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (90, 'Oloy Blade 32GB', 3250000.0, 'DDR5 6000MHz Black', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQg2RPvXHw6X0eeCl4dfffK0IO7gAmahpIDPA&s', 3, 25, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (91, 'ROG Maximus Z790 Hero', 16500000.0, 'Flagship Intel Board', 'https://product.hstatic.net/1000333506/product/s-rog-maximus-z790-hero-ddr5-4_239304ae40a4445d85dee5684c96dd03_grande_3ccebd17fac0403dbed13039cbca7560.jpg', 4, 12, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (92, 'B760M Mortar WiFi', 4500000.0, 'Best Mid-range Intel', 'https://product.hstatic.net/1000333506/product/1024__4__e3f6adffeeed4bac872ba08f2b595442.png', 4, 45, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (93, 'Z790 Aorus Elite', 7800000.0, 'High perf Z790', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6H-MmbojLRtHKO5v0Nd05JNGZS-qUDj4trA&s', 4, 30, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (94, 'TUF B650-Plus', 5800000.0, 'Standard AM5 Board', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI0gSe1fWEPHfaWJVMfmDf9EG1EATSNLV1uQ&s', 4, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (95, 'B660M Pro RS', 3200000.0, 'Budget Intel 12/13', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/_/t_i_xu_ng_-_2022-12-02t232209.063_1.png', 4, 60, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (96, 'X670E Carbon WiFi', 11500000.0, 'High-end AM5', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/_/t_i_xu_ng_-_2022-12-02t232209.063_1.png', 4, 15, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (97, 'Prime H610M-K', 2100000.0, 'Office Intel Board', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/2/_/2_68_39.jpg', 4, 100, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (98, 'B450M DS3H', 1850000.0, 'Legendary AM4 Budget', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSl60_PsEqOLMm_B2_chiGKTnCjbk1o_HsMkg&s', 4, 80, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (99, 'ROG Strix B760-I', 5900000.0, 'ITX Intel Board', 'https://bizweb.dktcdn.net/100/329/122/products/mainboard-pc-asus-rog-strix-b760-i-gaming-wifi-1.jpg?v=1743638555293', 4, 20, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (100, 'Z790 GODLIKE', 35000000.0, 'Ultimate Overclock', 'https://storage-asset.msi.com/global/picture/image/feature/mb/Z790/MEG-Z790-GODLIKE/z790-kv-mb.png', 4, 3, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (101, 'Z790 Taichi', 12500000.0, 'Gear design, E-ATX', 'https://nguyencongpc.vn/media/lib/12-10-2022/mainboardasrockz790taichiddr51.jpeg', 4, 8, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (102, 'ProArt Z790-Creator', 13800000.0, 'For Creators', 'https://azaudio.vn/wp-content/uploads/2024/01/asus-proart-z790-creator-wifi-3.jpg', 4, 10, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (103, 'B650I Aorus Ultra', 7200000.0, 'ITX AM5 Board', 'https://cdn.hstatic.net/products/200000320233/z7373043784851_ddb7312f77552c0987e7b754a2b644cc_04fcaef8520f42c28bc077c1589d8bc9_1024x1024.jpg', 4, 12, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (104, 'PRO H610M-E', 1950000.0, 'Cheap office build', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/mainboard-pc-msi-pro-h610m-e-ddr4-2.jpg?v=1743637393137', 4, 150, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (105, 'Crosshair X670E', 28000000.0, 'Best of AM5', 'https://dlcdnwebimgs.asus.com/files/media/0CBC145C-59B8-4B51-BF1A-DA0749FA1522/v1/img/kv/pd.png', 4, 5, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (106, 'Biostar B760MZ', 3100000.0, 'Budget B760', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2EsoB2oT4uD6Ake876a30S_w_NeXdrFMLTg&s', 4, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (107, 'CVN B760M Frozen', 4200000.0, 'White Motherboard', 'https://colorful.vn/wp-content/uploads/2023/03/CVN-B760M-FROZEN-WIFI-D5-V20-2.jpg', 4, 25, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (108, 'A520M S2H', 1650000.0, 'Budget AM4', 'https://hanoicomputercdn.com/media/product/55501_mainboard_gigabyte_a520m_s2h.png', 4, 90, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (109, 'NZXT N7 Z790', 8500000.0, 'Clean Aesthetic', 'https://www.tncstore.vn/media/product/10685-bo-mach-chu-nzxt-n7-z790-white-intel-n7-z79xt-w1--3-.png', 4, 18, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (110, 'A620M-HDV', 2800000.0, 'Cheap AM5 entry', 'https://hoangkhue.vn/wp-content/uploads/2024/06/A620M-HDVM.2L1.png', 4, 55, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (111, 'Z790 Dark Kingpin', 22000000.0, 'Limitless OC', 'https://cdn.mos.cms.futurecdn.net/oW2nMQStCQoUg7nKLivTwb.jpg', 4, 2, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (112, 'X570S Tomahawk', 6500000.0, 'Silent AM4', 'https://nguyencongpc.vn/media/product/20574-mag-x570s-tomahawk-max-wifi-4.jpg', 4, 20, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (113, 'A520M-Plus', 2400000.0, 'Durable AM4', 'https://dlcdnwebimgs.asus.com/files/media/907a4c65-59c3-42b2-b2a1-03b622ad1766/img/fan.png', 4, 45, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (114, 'Z790 UD', 5500000.0, 'Basic Z790', 'https://product.hstatic.net/200000320233/product/upload_5d9f36fb29514bc7b90f7095a80eb280_grande.jpg', 4, 35, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (115, 'B550M Steel Legend', 3800000.0, 'Solid B550 AM4', 'https://tandoanh.vn/wp-content/uploads/2020/06/B550M-Steel-Legend-01.jpg', 4, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (116, 'MSI B650 Gaming', 4900000.0, 'Budget AM5 WiFi', 'https://cdn.hstatic.net/products/200000320233/002_07b6012e1bbe44fb9078b0345703d925_1024x1024.png', 4, 50, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (117, 'Prime Z790-P', 6200000.0, 'Mainstream Z790', 'https://dlcdnwebimgs.asus.com/gain/37bbb2b4-b916-4170-9644-ff2aa0e0a253/430', 4, 30, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (118, 'H610M S2H', 2250000.0, 'LGA 1700 Office', 'https://product.hstatic.net/200000420363/product/_new_-anh-sp-web_7e8bbc5c6f094fc3b6533c7cac8ec7ca.png', 4, 110, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (119, 'X670E Steel Legend', 8900000.0, 'White AM5 High', 'https://cdn.hstatic.net/products/200000320233/001_01b90a74fedf4454a153d7f4cf8f37d3_1024x1024.png', 4, 15, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (120, 'Valkyrie Z790', 9500000.0, 'Biostar Flagship', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSySFKllziWXHiyre7btDXibtsBlAGTr8MWtg&s', 4, 7, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (121, 'Samsung 990 Pro 1T', 3200000.0, 'NVMe Gen4 7450MB/s', 'https://bizweb.dktcdn.net/100/329/122/products/ssd-samsung-990-pro-pcie-gen-4-0-x4-nvme-v-nand-m-2-2280-1tb-mz-v9p1t0bw-2.jpg?v=1751994033067', 5, 60, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (122, 'Samsung 980 Pro 2T', 4500000.0, 'NVMe Gen4 7000MB/s', 'https://minhancomputer.com/media/product/7283_samsung_980_pro_2tb_2.jpg', 5, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (123, 'WD SN850X 1TB', 2600000.0, 'Top gaming SSD', 'https://product.hstatic.net/1000333506/product/ssd-wd-sn850x-black-1tb2_763ef1e53e5e471f93bcf209fcff78b4.jpg', 5, 55, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (124, 'Crucial P3 Plus 1T', 1850000.0, 'Budget Gen4', 'https://lagihitech.vn/wp-content/uploads/2022/10/SSD-Crucial-P3-Plus-1TB-PCIe-4.0-3D-NAND-CT1000P3PSSD8-hinh-1.jpg', 5, 100, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (125, 'Kingston NV2 500G', 950000.0, 'Entry NVMe', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/ssd-kingston-nv2-m-2-pcie-gen4-x4-nvme-500g-02.jpg?v=1739504614017', 5, 150, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (126, 'Samsung 870 EVO 1T', 2100000.0, 'Best SATA SSD', 'https://product.hstatic.net/200000320233/product/18616-samsung-870-evo-250gb_6dc030e23d5247dab13bc31b74f5e2bf_1024x1024.jpg', 5, 80, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (127, 'P41 Platinum 2T', 5200000.0, 'Super Fast Gen4', 'https://lagihitech.vn/wp-content/uploads/2024/06/SSD-SK-Hynix-Platinum-P41-2TB-M2-PCIe-Gen-4.0-hinh-1.jpg', 5, 20, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (128, 'Lexar NM790 2T', 3800000.0, 'Value Gen4 7400', 'https://product.hstatic.net/200000536009/product/nm790ssd_slider_4tb_2_dcfd832c29cb4d10bd13d22c0f1c9bd7_master_dcdb6febbf6e49408e46b1bfc78fffea.png', 5, 45, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (129, 'Crucial T700 1TB', 5800000.0, 'Gen5 11700MB/s', 'https://lagihitech.vn/wp-content/uploads/2023/08/SSD-Crucial-T700-1TB-M2-PCIe-Gen-5.0-CT1000T700SSD3-hinh-1.jpg', 5, 15, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (130, 'Aorus Gen5 2TB', 9500000.0, 'Gen5 w/ Heatsink', 'https://nguyencongpc.vn/media/lib/08-03-2023/cngssdgigabyteaorusgen5100002tb1.jpeg', 5, 10, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (131, 'TeamGroup MP33 1T', 1400000.0, 'Budget NVMe', 'https://product.hstatic.net/200000420363/product/o-cung-ssd-teamgroup-mp33-1tb-pcie-gen3x4-_tm8fp6001t0c101__3f8e2fa9db9a452e918a5ad1520882ee.jpg', 5, 90, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (132, 'XPG S70 Blade 1T', 2200000.0, 'PS5 Gen4', 'https://product.hstatic.net/200000420363/product/ss.1t.adt.gm.s70.blade_491e8539cb0145e89b6352d0fddb983f_master.jpg', 5, 65, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (133, 'SN580 1TB', 1700000.0, 'Reliable Gen4', 'https://product.hstatic.net/200000420363/product/ss.1t.adt.gm.s70.blade_491e8539cb0145e89b6352d0fddb983f_master.jpg', 5, 75, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (134, 'FireCuda 530 2TB', 5900000.0, 'High endurance', 'https://lagihitech.vn/wp-content/uploads/2022/02/SSD-Seagate-Firecuda-530-2TB-M.2-PCIe-Gen4x4-NVMe-ZP2000GM30013-hinh-1.jpg', 5, 18, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (135, 'Sabrent Rocket 4TB', 12500000.0, 'Huge capacity', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZNwnM0COBi_2Ur-6y1i-MK8M-ZNrMHhNddA&s', 5, 8, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (136, '970 EVO Plus 2TB', 3900000.0, 'Gen3 King', 'https://songphuong.vn/Content/uploads/2020/05/SSD-Samsung-970-Evo-Plus-2Tb-MZ-V7S2T0BW-songphuong.vn_-e1601869576118.jpg.webp', 5, 30, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (137, 'PNY CS2241 1TB', 1600000.0, 'Budget Gen4', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6pp-Z1LEmFBOJcAABUhht9LZwFg_3KPTSoA&s', 5, 50, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (138, 'Silicon Power UD90 1650000', 1650000.0, 'Gen4 Value', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_elTNr0-xqf3OgQB6pbmUby89Cpeu5Ls7GQ&s', 5, 60, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (139, 'MP600 Pro 2TB', 4800000.0, 'Optimized for PS5', 'https://product.hstatic.net/200000420363/product/f2000gbmp600pro_9a7c5779d8d24dc885808967046e5b7e_master.jpg', 5, 22, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (140, 'KC3000 1TB', 2450000.0, 'Fast Gen4 OS', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/ssd-kingston-kc3000-m-2-pcie-gen4-x4-nvme-1tb-skc3000s-1024g.png?v=1741142416457', 5, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (141, 'Crucial MX500 1TB', 1800000.0, 'SATA storage', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2K43NfxE9J08yUJki0Xry0rjpF05HswX4Mg&s', 5, 85, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (142, 'SN350 480GB', 850000.0, 'Cheap upgrade', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/ssd-western-digital-green-sn350-pcie-gen3-x4-nvme-m-2-480gb-wds480g2g0c-1.png?v=1641894576417', 5, 120, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (143, 'Spatium M480 2TB', 4600000.0, 'High-end MSI SSD', 'https://product.hstatic.net/1000333506/product/maianhpc.vn_014_b93beb1d327d44cf8e6d31d161b85794_grande.png', 5, 20, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (144, 'Transcend 250S 1T', 2100000.0, 'Gen4 with Cache', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbiMYgSqmeqmoC52iCCeT1WmDDhTHF5Hs-kQ&s', 5, 35, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (145, 'Viper VP4300 2TB', 5400000.0, 'Dual heatsinks', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbiMYgSqmeqmoC52iCCeT1WmDDhTHF5Hs-kQ&s', 5, 12, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (146, 'Lexar NM620 512G', 900000.0, 'Gen3 Budget', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyKSJkLBvAnh7iFJBUXTiIsjXUNu8Ga_p7Uw&s', 5, 100, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (147, 'Netac N7000 2TB', 3600000.0, 'Gen4 7000MB/s', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQF-MWTOZ3HZOCUc4xhY8UX8Ju0A5zXSJLVg&s', 5, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (149, 'Adata SU650 240G', 450000.0, 'Cheapest SSD', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfnq4UwNEYJMUSEI5EVSFQLP3rNFd4Pq-gfg&s', 5, 200, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (150, 'Crucial T705 2TB', 10500000.0, 'Fastest Gen5', 'https://bizweb.dktcdn.net/100/329/122/products/ssd-crucial-t705-2tb-m2-pcie-gen5-x4-nvme-01.jpg?v=1714980741023', 5, 5, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (151, 'LG 27GR95QE', 22500000.0, '27" OLED 240Hz', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/m/a/man-hinh-lg-ultragear-oled-27gr95qe-b-27-inch-1.png', 6, 12, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (152, 'Dell U2723QE', 14800000.0, '27" 4K IPS Black', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/5/4/54_1_20.jpg', 6, 25, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (153, 'VG249Q', 4200000.0, '24" 144Hz IPS', 'https://cdn.tgdd.vn/Products/Images/5697/219440/asus-tuf-gaming-full-hd-238-inch-144hz-vg249q-11-600x600.jpg', 6, 60, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (154, 'Odyssey Neo G8', 28000000.0, '32" 4K 240Hz', 'https://images.samsung.com/is/image/samsung/p6pim/us/ls32bg852nnxgo/gallery/us--ls32bg852nnxgo-550300211?$product-details-jpg$', 6, 8, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (155, 'Gigabyte M27Q', 7800000.0, '27" 2K 170Hz', 'https://bizweb.dktcdn.net/100/410/941/products/bg1-m.png?v=1690418101810', 6, 35, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (156, 'AOC 24G2', 3900000.0, 'Popular 144Hz', 'https://product.hstatic.net/200000350425/product/2_234086bd4aaa43b0884706ab148087fc_9827427ad12044d5940bb503b5c449ac.png', 6, 80, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (157, 'ViewSonic VX2728', 4500000.0, '27" 165Hz IPS', 'https://product.hstatic.net/200000889805/product/man-hinh-gaming-27-inch-viewsonic-vx2728-2k-ips-165hz-0-5ms-r338q_07066d3f62ad434aa5a0bd76e1112768_master.jpg', 6, 50, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (158, 'MAG274QRF-QD', 10500000.0, '2K Quantum Dot', 'https://bizweb.dktcdn.net/thumb/grande/100/329/122/products/man-hinh-2k-msi-optix-mag274qrf.jpg?v=1688355985323', 6, 20, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (159, 'AW3423DW', 32000000.0, '34" QD-OLED', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZfKCvt0xcGMPg-jBWXeoD12lLGNhs-dkBEg&s', 6, 5, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (161, 'Samsung M7', 8200000.0, '32" 4K Smart', 'https://product.hstatic.net/200000320233/product/anh_chup_man_hinh_2024-08-06_luc_14.22.33_eb405df2409e44e3916c11aff2c3f094_1024x1024.png', 6, 30, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (162, 'LG 24MP60G', 2900000.0, 'Budget 24" IPS', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/m/a/man-hinh-gaming-lg-24mp60g-24-inch-04.jpg', 6, 100, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (163, 'Swift PG42UQ', 38000000.0, '42" OLED 4K', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZmc3pHXU3KQ9BxEaqHHaxm2jC6lTi1_rGxA&s', 6, 4, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (164, 'Gigabyte G24F 2', 4100000.0, '24" 180Hz OC', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/man-hinh-gigabyte-24-inch-ips-165hz-g24f-2-1.jpg?v=1705057015323', 6, 70, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (165, 'HP Z27k G3', 15500000.0, '4K Studio USB-C', 'https://product.hstatic.net/200000226945/product/hp_z27k_g3_6_890a2955ac5c452b93769c539230d8e6_master.jpg', 6, 15, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (166, 'Nitro VG271U', 6500000.0, '27" 2K 144Hz', 'https://www.acervietnam.com.vn/wp-content/uploads/2024/03/Acer-Nitro-VG271U-M3.png', 6, 45, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (167, 'Dell S2721DGF', 9200000.0, 'Fast IPS 165Hz', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT30-kj43mc2ia4CNq51L5u65Hk_yl_8yO2ew&s', 6, 22, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (168, 'LG DualUp', 16000000.0, 'Square 16:18', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/man-hinh-2k-lg-dualup-28-inch-ips-60hz-28mq780-b-atv-1.jpg?v=1681874970677', 6, 10, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (169, 'Odyssey G5', 7200000.0, '27" 2K Curved', 'https://images.samsung.com/is/image/samsung/p6pim/vn/ls27cg552eexxv/gallery/vn-odyssey-g5-g55c-ls27cg552eexxv-538902440?$Q90_1248_936_F_PNG$', 6, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (170, 'Legion Y25-30', 6800000.0, '24.5" 240Hz', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbW4Q31UPv4pQGyyFFuTOJMBjlWc_uWWS7SQ&s', 6, 25, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (171, 'ProArt PA278QV', 8900000.0, 'Color Accurate', 'https://cdn.tgdd.vn/Products/Images/5697/319480/asus-proart-pa278qv-27-inch-2k-1-750x500.jpg', 6, 18, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (172, 'HKC ANT27TQC', 5500000.0, 'Budget 2K Curved', 'https://khanhhungpc.vn/wp-content/uploads/2024/11/HKC-23.8-inch-MB24V9-U-KHANH-HUNG-PC-1-247x247.jpg', 6, 55, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (173, 'MSI G2412', 3500000.0, 'Budget 170Hz', 'https://hanoicomputercdn.com/media/product/70738_man_hinh_msi_g2412_850x850_1.jpg', 6, 90, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (174, 'Dell E2222H', 2200000.0, 'Office 22"', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRN0Fg73WE0L_vq6zEOql3bjlXmT-Vlgh6I8w&s', 6, 150, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (175, 'LG 29WP500', 5200000.0, '29" UltraWide', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSR1fhAeHZ_RM3FP1pey_e4u_zgaz8vmNubwA&s', 6, 35, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (176, 'Philips 242E1', 3100000.0, 'Budget 144Hz', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSR1fhAeHZ_RM3FP1pey_e4u_zgaz8vmNubwA&s', 6, 80, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (177, 'AOC CU34G2X', 12500000.0, '34" UW 144Hz', 'https://bizweb.dktcdn.net/thumb/grande/100/524/252/products/cu34g2x-74-5.jpg?v=1727432435350', 6, 15, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (178, 'Xeneon Flex', 45000000.0, 'Bendable OLED', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrZ3t5xTWQy79jPigv6ErAP3qLgx6WPwGR-g&s', 6, 2, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (179, 'Zowie XL2546K', 13500000.0, 'Pro Esport 240Hz', 'https://image.benq.com/is/image/benqco/xl2546k?$ResponsivePreset$&fmt=png-alpha', 6, 20, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (180, 'Xiaomi Mi 34', 9500000.0, '34" 2K UltraWide', 'https://gearshop.vn/upload/products/Xiaomi/Mi%20Surface%2034/gearshop_xiaomi_display_surface_34_2k_1.jpg', 6, 40, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (181, 'Intel Arc A770 Limited Edition GPU', 8356600.0, '16GB GDDR6, 256-bit, 2100 MHz, 225W', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 2, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (1, 'Intel Core i9-14900K', 15500000.0, '24 Cores, up to 6.0GHz, LGA 1700', 'https://product.hstatic.net/200000722513/product/n22360_png_36691178908b435494f526d804c4b249.png', 1, 46, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (183, 'Intel Arc A580 Graphics Card', 4546600.0, '8GB GDDR6, 256-bit, 1700 MHz, 185W', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 2, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (184, 'AMD Radeon RX 7900 XT GPU', 22834600.0, '20GB GDDR6, 80MB, 315W', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 2, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (186, 'AMD Ryzen 5 5600X Desktop Processor', 3784600.0, '6, 12, AM4, 65W', 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=400&auto=format&fit=crop', 1, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (188, 'ASUS ROG Strix X670E-E Gaming WiFi', 12674600.0, 'AM5, AMD X670E, PCIe 5.0, ATX', 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?q=80&w=400&auto=format&fit=crop', 4, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (189, 'ASUS ROG Strix GeForce RTX 4090 OC Edition', 50774600.0, '24GB GDDR6X, 16384, PCIe 4.0', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 2, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (190, 'ASUS ROG Swift OLED PG32UCDM', 32994600.0, '32-inch, 3840x2160 (4K), 240Hz, QD-OLED', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=400&auto=format&fit=crop', 6, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (192, 'ASUS ROG Thor 1200W Platinum II', 8102600.0, '1200W, 80 Plus Platinum, Full Modular, Real-time power draw', 'https://images.unsplash.com/photo-1516245834210-c4c142787335?q=80&w=400&auto=format&fit=crop', 85, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (193, 'MSI MEG Z790 GODLIKE MAX', 30454600.0, 'LGA1700, Intel Z790, 7x M.2 slots, M-Vision Dashboard', 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?q=80&w=400&auto=format&fit=crop', 4, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (195, 'MSI GeForce RTX 4080 SUPER 16G GAMING X SLIM', 26644600.0, '16GB GDDR6X, TRI FROZR 3, 2625 MHz', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 2, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (196, 'MSI MPG 271QRX QD-OLED', 20294600.0, '27-inch, 2560x1440 (2K), 360Hz, 0.03ms (GtG)', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=400&auto=format&fit=crop', 6, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (198, 'MSI MAG CORELIQUID I360', 3530600.0, '360mm, ARGB Fans, Infinite Mirror IPS Style Design', 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=400&auto=format&fit=crop', 87, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (199, 'MSI SPATIUM M570 PCIe 5.0 NVMe M.2 HS', 7594600.0, '2TB, Up to 12400 MB/s, Up to 11800 MB/s', 'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?q=80&w=400&auto=format&fit=crop', 5, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (200, 'Gigabyte Z790 AORUS XTREME X', 25374600.0, 'LGA1700, 24+1+2 Phases, Wi-Fi 7, PCIe 5.0 x16', 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?q=80&w=400&auto=format&fit=crop', 4, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (202, 'Gigabyte M27Q Gaming Monitor', 7594600.0, '27-inch, Super Speed IPS, 2560x1440, 170Hz', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=400&auto=format&fit=crop', 6, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (203, 'Gigabyte AORUS FO32U2P', 30454600.0, '32-inch, OLED (QD-OLED), 3840x2160, DP 2.1 UHBR20 supported', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=400&auto=format&fit=crop', 6, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (209, 'Corsair iCUE LINK H150i LCD Liquid CPU Cooler', 7340600.0, '360mm, 3x QX120 RGB Fans, 2.1-inch IPS Display, iCUE LINK Ecosystem', 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=400&auto=format&fit=crop', 87, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (210, 'Corsair 5000D AIRFLOW Tempered Glass Mid-Tower', 4165600.0, 'Mid-Tower, Black, RapidRoute System, Up to 10x 120mm fans', 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=400&auto=format&fit=crop', 86, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (212, 'Corsair RM1000x Shift Fully Modular ATX PSU', 5308600.0, '1000W, 80 PLUS Gold, Side-mounted modular connections, ATX 3.0 & PCIe 5.0 ready', 'https://images.unsplash.com/photo-1516245834210-c4c142787335?q=80&w=400&auto=format&fit=crop', 85, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (213, 'Corsair AX1600i Digital ATX Power Supply', 15468600.0, '1600W, 80 PLUS Titanium, Gallium Nitride (GaN) FETs', 'https://images.unsplash.com/photo-1516245834210-c4c142787335?q=80&w=400&auto=format&fit=crop', 85, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (215, 'Corsair Darkstar Wireless MMO Gaming Mouse', 4292600.0, '15 programmable buttons, MARKSMAN 26K DPI Optical, SLIPSTREAM Wireless & Bluetooth', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 90, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (216, 'Corsair Virtuoso RGB Wireless XT Headset', 6832600.0, 'High-Density 50mm Neodymium, Spatial Dolby Atmos, Broadcast-grade detachable mic', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 91, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (217, 'Logitech G Pro X Superlight 2 Wireless GamingMouse', 4038600.0, '60 grams, HERO 2 Sensor (32,000 DPI), LIGHTFORCE Hybrid Switches, 4000Hz max polling', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 90, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (219, 'Logitech G915 TKL Wireless Mechanical Keyboard', 5816600.0, 'Tenkeyless (TKL), Low Profile GL Tactile/Linear/Clicky, Up to 40 hours (100% brightness)', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 89, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (220, 'Logitech G Pro X TKL LIGHTSPEED Gaming Keyboard', 5054600.0, 'Dual-shot PBT keycaps, LIGHTSPEED Wireless, Bluetooth, USB, Dedicated volume roller and controls', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 89, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (221, 'Logitech G Pro X 2 LIGHTSPEED Wireless Headset', 6324600.0, '50mm Graphene Drivers, LIGHTSPEED, Bluetooth, 3.5mm wired, Up to 50 hours battery life', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 91, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (223, 'Logitech MX Keys S Wireless Keyboard', 2768600.0, 'Spherically-dished Perfect Stroke keys, Smart illumination proximity sensor, Easy-Switch up to 3 devices', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 89, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (224, 'Razer Viper V3 Pro Wireless Gaming Mouse', 4038600.0, '54 grams, Focus Pro 35K Optical Sensor Gen-2, True 8000Hz HyperPolling Wireless', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 90, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (225, 'Razer DeathAdder V3 Pro Wireless Gaming Mouse', 3784600.0, '63 grams, Right-handed ergonomic design, Focus Pro 30K Optical Sensor', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 90, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (227, 'Razer BlackWidow V4 Pro Mechanical GamingKeyboard', 5816600.0, 'Razer Green Clicky / Yellow Linear Switches, Per-key & 3-sided underglow RGB, 8 dedicated macro keys', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 89, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (228, 'Razer BlackShark V2 Pro (2023 Edition) WirelessHeadset', 5054600.0, 'Razer HyperClear Super Wideband Mic, TriForce Titanium 50mm Drivers, Up to 70 hours', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 91, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (229, 'Samsung 990 PRO PCIe 4.0 NVMe M.2 SSD 2TB', 4546600.0, '2TB, Up to 7450 MB/s, Up to 6900 MB/s, Samsung Pascal Controller', 'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?q=80&w=400&auto=format&fit=crop', 5, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (230, 'Samsung 990 EVO PCIe 4.0 x4 / 5.0 x2 M.2 SSD 1TB', 2260600.0, '1TB, Up to 5000 MB/s, Up to 4200 MB/s', 'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?q=80&w=400&auto=format&fit=crop', 5, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (232, 'Samsung Odyssey OLED G9 (G95SC) Gaming Monitor', 40614600.0, '49-inch Curved Ultra-wide, 5120x1440 (Dual QHD), 240Hz, 0.03ms (GtG)', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=400&auto=format&fit=crop', 6, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (233, 'Samsung Odyssey Ark Gen 2 Mini-LED Monitor', 63474600.0, '55-inch 1000R Curved, 3840x2160 (4K), 165Hz, Yes, rotates vertically', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=400&auto=format&fit=crop', 6, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (235, 'Kingston FURY Renegade DDR5 RGB 32GB (2x16GB) 7200MHz', 4292600.0, '32GB Kit, 7200 MT/s, CL38-44-44, 1.45V', 'https://images.unsplash.com/photo-1562976540-1502c2145186?q=80&w=400&auto=format&fit=crop', 3, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (236, 'Kingston FURY Beast DDR5 32GB (2x16GB) 6000MHz', 3022600.0, '32GB Kit, 6000 MT/s, AMD EXPO / Intel XMP 3.0 certified', 'https://images.unsplash.com/photo-1562976540-1502c2145186?q=80&w=400&auto=format&fit=crop', 3, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (237, 'Kingston KC3000 PCIe 4.0 NVMe M.2 SSD 2TB', 3911600.0, '2TB, Up to 7000 MB/s, Up to 7000 MB/s, Phison E18', 'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?q=80&w=400&auto=format&fit=crop', 5, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (238, 'Kingston NV2 PCIe 4.0 NVMe M.2 SSD 1TB', 1625600.0, '1TB, Up to 3500 MB/s, Up to 2100 MB/s, M.2 2280', 'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?q=80&w=400&auto=format&fit=crop', 5, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (240, 'WD Red Pro NAS Internal Hard Drive 12TB', 7594600.0, '12TB, 7200 RPM, 256MB, SATA 6 Gb/s', 'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?q=80&w=400&auto=format&fit=crop', 84, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (241, 'Seagate IronWolf Pro 16TB NAS HDD', 8356600.0, '16TB, 550TB/year, Rotational Vibration (RV) sensors', 'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?q=80&w=400&auto=format&fit=crop', 84, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (243, 'NZXT H9 Flow Dual-Chamber Mid-Tower', 4038600.0, 'Wrap-around tempered glass pane, 4x F120Q Airflow fans, Up to 435mm', 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=400&auto=format&fit=crop', 86, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (244, 'NZXT Kraken Elite 360 RGB Liquid Cooler', 7594600.0, '360mm aluminum radiator, 2.36-inch wide-angle TFT-LCD display, 640x640 pixels', 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=400&auto=format&fit=crop', 87, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (246, 'BenQ ZOWIE XL2566K 360Hz Esports Gaming Monitor', 15214600.0, '24.5-inch TN Panel, 360Hz, DyAc+ Technology motion blur reduction', 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=400&auto=format&fit=crop', 6, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (88, 'Netac Shadow 16GB', 1100000.0, 'Budget RGB RAM', 'https://product.hstatic.net/200000420363/product/shadow-ii-ddr4-black_f23e2dc2081d41e1a3ab5c16bb61c39a_master.png', 3, 100, NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (148, '870 QVO 4TB', 8500000.0, 'Massive SATA', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/o/-/o-cung-ssd-samsung-870-qvo-2-5-sata-iii-4tb_3_.png', 5, 30, '2026-04-06 13:46:29.076393');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (205, 'Gigabyte UD1000GM PG5 (Rev 2.0)', 4038600.0, '1000W, PCIe Gen 5.0 (12VHPWR), 80 PLUS Gold', 'https://images.unsplash.com/photo-1516245834210-c4c142787335?q=80&w=400&auto=format&fit=crop', 85, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (206, 'Gigabyte AORUS C500 GLASS', 4546600.0, 'Mid Tower, 4mm Tempered Glass, Up to 420mm front', 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=400&auto=format&fit=crop', 86, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (185, 'AMD Radeon RX 7800 XT GPU', 12674600.0, '16GB GDDR6, 64MB, 263W', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 2, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (187, 'ASUS ROG Maximus Z790 Dark Hero', 17754600.0, 'LGA1700, Intel Z790, 4x DDR5 (Up to 192GB), ATX', 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?q=80&w=400&auto=format&fit=crop', 4, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (191, 'ASUS ROG Ryujin III 360 ARGB', 8864600.0, '360mm, Asetek 8th Gen, 3.5-inch Full Color', 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=400&auto=format&fit=crop', 87, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (194, 'MSI MAG B650 TOMAHAWK WIFI', 5562600.0, 'AM5, AMD B650, DDR5 7600+(OC), Realtek 2.5Gbps LAN', 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?q=80&w=400&auto=format&fit=crop', 4, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (197, 'MSI MEG MAESTRO 700L PZ', 10642600.0, 'ATX Full Tower, Curved Tempered Glass, Back-connect (Project Zero) support', 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=400&auto=format&fit=crop', 86, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (201, 'Gigabyte X670E AORUS MASTER', 11404600.0, 'AM5, AMD X670E, 4x M.2 PCIe 5.0, Intel 2.5GbE LAN', 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?q=80&w=400&auto=format&fit=crop', 4, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (204, 'Gigabyte AORUS Gen5 12000 SSD 2TB', 8102600.0, 'PCIe 5.0 x4, NVMe 2.0, 12,400 MB/s, 11,800 MB/s', 'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?q=80&w=400&auto=format&fit=crop', 5, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (207, 'Corsair Dominator Titanium RGB DDR5 32GB (2x16GB)6000MHz', 4673600.0, '32GB, 6000 MT/s, CL30, Intel XMP 3.0 / AMD EXPO', 'https://images.unsplash.com/photo-1562976540-1502c2145186?q=80&w=400&auto=format&fit=crop', 3, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (208, 'Corsair Vengeance RGB DDR5 64GB (2x32GB)5600MHz', 5562600.0, '64GB, 5600 MT/s, CL40', 'https://images.unsplash.com/photo-1562976540-1502c2145186?q=80&w=400&auto=format&fit=crop', 3, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (211, 'Corsair iCUE LINK 6500X RGB Mid-Tower DualChamber', 5054600.0, 'Dual Chamber Layout, Reverse-connector support, Front & Side Tempered Glass', 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=400&auto=format&fit=crop', 86, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (214, 'Corsair K100 RGB Mechanical Gaming Keyboard', 6324600.0, 'Corsair OPX Optical-Mechanical, AXON 4000Hz Hyper-polling, iCUE Control Wheel', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 89, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (218, 'Logitech G502 X LIGHTSPEED Wireless GamingMouse', 3530600.0, 'HERO 25K Sensor, 13 programmable controls, Dual-mode infinite scroll', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 90, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (222, 'Logitech MX Master 3S Wireless Mouse', 2514600.0, '8K DPI tracking on any surface, Quiet clicks technology, MagSpeed Electromagnetic scrolling', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 90, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (226, 'Razer Huntsman V3 Pro TKL Mechanical Keyboard', 5562600.0, 'Razer Analog Optical Switches Gen-2, Rapid Trigger mode with adjustable actuation (0.1- 4.0mm), Dual-purpose digital dial', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 89, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (231, 'Samsung T7 Shield Portable SSD 2TB', 4292600.0, '2TB, USB 3.2 Gen 2 (10Gbps), IP65 water & dust resistant, 3-meter drop proof', 'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?q=80&w=400&auto=format&fit=crop', 5, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (234, 'Samsung Galaxy Buds3 Pro', 6324600.0, 'Hi-Fi 24-bit Ultra High Quality Audio, Adaptive Noise Cancelling with Blade Lights, Stem style ergonomic fit', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 91, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (239, 'Kingston FURY Impact DDR5 SO-DIMM 32GB (2x16GB) 5600MHz', 3149600.0, 'Laptop Memory (SO-DIMM), 32GB Kit, 5600 MT/s', 'https://images.unsplash.com/photo-1562976540-1502c2145186?q=80&w=400&auto=format&fit=crop', 3, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (242, 'Noctua NH-D15 chromax.black Dual-Tower Cooler', 3022600.0, '2x NF-A15 HS-PWM fans, Full black design, Intel LGA1700/AM5 ready', 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=400&auto=format&fit=crop', 87, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (245, 'SteelSeries Arctis Nova Pro Wireless Headset', 8864600.0, 'Nova Pro Acoustic System, Active Noise Cancellation with Transparency Mode, Dual Battery Infinity System', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 91, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (248, 'Crucial Pro DDR5 48GB (2x24GB) 5600MHz Kit', 3784600.0, '48GB Kit, 5600 MT/s, Low-profile aluminum black heatsink', 'https://images.unsplash.com/photo-1562976540-1502c2145186?q=80&w=400&auto=format&fit=crop', 3, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (249, 'Fractal Design North Charcoal Black WoodMid-Tower', 3530600.0, 'Real walnut wood front panel struts, Mesh or Tempered Glass available, 2x Aspect 14 PWM fans', 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=400&auto=format&fit=crop', 86, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (250, 'Lian Li O11 Dynamic EVO RGB Black', 4292600.0, 'Dual-chamber adjustable ATX case, Two L-shaped diffuse LED RGB strips, Reversible design architecture', 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=400&auto=format&fit=crop', 86, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (252, 'EVGA SuperNOVA 1000 G7 Gold Modular PSU', 4800600.0, '1000W, 80 PLUS Gold Certified, Ultra-compact 130mm chassis size', 'https://images.unsplash.com/photo-1516245834210-c4c142787335?q=80&w=400&auto=format&fit=crop', 85, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (253, 'DeepCool AK620 Digital Dual-Tower Air Cooler', 2006600.0, 'Real-time temperature and usage status top screen, 2x FK120 fluid dynamic bearing fans, 6x 6mm copper heatpipes', 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=400&auto=format&fit=crop', 87, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (254, 'Thermalright Peerless Assassin 120 SE AirCooler', 990600.0, 'Dual tower heatsink design, 2x TL-C12C 120mm PWM fans, 155mm standard height', 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=400&auto=format&fit=crop', 87, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (182, 'Intel Arc A750 Graphics Card', 6324600.0, '8GB GDDR6, 256-bit, 2050 MHz, 225W', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 2, 49, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (247, 'Sony WH-1000XM5 Wireless Noise CancelingHeadphones', 10134600.0, 'Integrated Processor V1 & HD Noise CancelingProcessor QN1, 8 microphones for extreme voice pick up, Up to 30 hours total life', 'https://images.unsplash.com/photo-1587202372634-32705e3bf49c?q=80&w=400&auto=format&fit=crop', 91, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (251, 'Lian Li UNI FAN TL LCD 120 Triple Pack Black', 3784600.0, '120mm fans, Built-in 1.6-inch LCD screen on center fan, Daisy-chain interlocking mechanism', 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=400&auto=format&fit=crop', 88, 50, '2026-06-05 10:05:55.522526');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at) VALUES (255, 'Be Quiet! Dark Power 13 1000W Titanium ATX 3.0PSU', 7340600.0, '1000W, 80 PLUS Titanium (up to 95.8%), Frameless Silent Wings fan optimization', 'https://images.unsplash.com/photo-1516245834210-c4c142787335?q=80&w=400&auto=format&fit=crop', 85, 50, '2026-06-05 10:05:55.522526');

-- Dumping data for table: inventory
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (2, 2, 15, '2026-04-06 20:51:03.317000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (3, 3, 40, '2026-04-06 20:51:03.617000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (6, 6, 60, '2026-04-06 20:51:04.539000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (7, 7, 10, '2026-04-06 20:51:04.847000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (8, 8, 20, '2026-04-06 20:51:05.193000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (9, 9, 45, '2026-04-06 20:51:05.635000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (10, 10, 25, '2026-04-06 20:51:05.963000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (11, 11, 100, '2026-04-06 20:51:06.291000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (12, 12, 80, '2026-04-06 20:51:06.607000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (13, 13, 70, '2026-04-06 20:51:06.913000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (14, 14, 120, '2026-04-06 20:51:07.220000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (15, 15, 15, '2026-04-06 20:51:07.522000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (16, 16, 12, '2026-04-06 20:51:07.831000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (17, 17, 65, '2026-04-06 20:51:08.129000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (18, 18, 40, '2026-04-06 20:51:08.430000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (19, 19, 35, '2026-04-06 20:51:08.732000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (20, 20, 28, '2026-04-06 20:51:09.051000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (21, 21, 50, '2026-04-06 20:51:09.403000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (22, 22, 95, '2026-04-06 20:51:09.712000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (23, 23, 10, '2026-04-06 20:51:10.029000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (24, 24, 150, '2026-04-06 20:51:10.335000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (25, 25, 110, '2026-04-06 20:51:10.649000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (26, 26, 8, '2026-04-06 20:51:10.955000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (27, 27, 200, '2026-04-06 20:51:11.268000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (28, 28, 180, '2026-04-06 20:51:11.577000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (29, 29, 20, '2026-04-06 20:51:11.877000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (30, 30, 33, '2026-04-06 20:51:12.182000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (31, 31, 10, '2026-04-06 20:51:12.493000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (32, 32, 15, '2026-04-06 20:51:12.796000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (33, 33, 25, '2026-04-06 20:51:13.125000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (34, 34, 12, '2026-04-06 20:51:13.430000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (36, 36, 30, '2026-04-06 20:51:14.041000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (37, 37, 80, '2026-04-06 20:51:14.385000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (38, 38, 100, '2026-04-06 20:51:14.684000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (39, 160, 3, '2026-04-06 20:51:14.986000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (40, 39, 5, '2026-04-06 20:51:15.320000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (41, 40, 20, '2026-04-06 20:51:15.634000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (42, 41, 60, '2026-04-06 20:51:15.933000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (43, 42, 35, '2026-04-06 20:51:16.249000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (44, 43, 50, '2026-04-06 20:51:16.549000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (45, 44, 70, '2026-04-06 20:51:16.880000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (46, 45, 40, '2026-04-06 20:51:17.233000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (47, 46, 15, '2026-04-06 20:51:17.538000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (48, 47, 10, '2026-04-06 20:51:17.836000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (49, 48, 5, '2026-04-06 20:51:18.143000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (50, 49, 18, '2026-04-06 20:51:18.454000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (51, 50, 22, '2026-04-06 20:51:18.761000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (52, 51, 150, '2026-04-06 20:51:19.075000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (53, 52, 40, '2026-04-06 20:51:19.427000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (54, 53, 8, '2026-04-06 20:51:19.744000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (55, 54, 10, '2026-04-06 20:51:20.055000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (56, 55, 3, '2026-04-06 20:51:20.362000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (57, 56, 25, '2026-04-06 20:51:20.666000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (58, 57, 40, '2026-04-06 20:51:20.965000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (59, 58, 15, '2026-04-06 20:51:21.265000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (60, 59, 4, '2026-04-06 20:51:21.562000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (61, 60, 55, '2026-04-06 20:51:21.862000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (62, 61, 50, '2026-04-06 20:51:22.163000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (63, 62, 40, '2026-04-06 20:51:22.465000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (64, 63, 120, '2026-04-06 20:51:22.765000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (65, 64, 45, '2026-04-06 20:51:23.069000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (66, 65, 70, '2026-04-06 20:51:23.373000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (67, 66, 200, '2026-04-06 20:51:23.699000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (68, 67, 10, '2026-04-06 20:51:23.997000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (69, 68, 90, '2026-04-06 20:51:24.304000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (70, 69, 55, '2026-04-06 20:51:24.616000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (71, 70, 25, '2026-04-06 20:51:24.917000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (72, 71, 60, '2026-04-06 20:51:25.221000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (73, 72, 150, '2026-04-06 20:51:25.520000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (74, 73, 20, '2026-04-06 20:51:25.819000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (75, 74, 40, '2026-04-06 20:51:26.122000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (76, 75, 30, '2026-04-06 20:51:26.434000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (77, 76, 25, '2026-04-06 20:51:26.745000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (78, 77, 15, '2026-04-06 20:51:27.046000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (79, 78, 100, '2026-04-06 20:51:27.350000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (80, 79, 50, '2026-04-06 20:51:27.651000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (81, 80, 40, '2026-04-06 20:51:27.977000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (82, 81, 20, '2026-04-06 20:51:28.280000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (83, 82, 80, '2026-04-06 20:51:28.584000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (84, 83, 35, '2026-04-06 20:51:28.884000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (85, 84, 60, '2026-04-06 20:51:29.233000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (86, 85, 45, '2026-04-06 20:51:29.531000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (87, 86, 15, '2026-04-06 20:51:29.829000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (88, 87, 30, '2026-04-06 20:51:30.153000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (89, 88, 100, '2026-04-06 20:51:30.483000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (90, 89, 5, '2026-04-06 20:51:30.834000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (91, 90, 25, '2026-04-06 20:51:31.156000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (92, 91, 12, '2026-04-06 20:51:31.477000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (93, 92, 45, '2026-04-06 20:51:31.788000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (94, 93, 30, '2026-04-06 20:51:32.085000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (95, 94, 40, '2026-04-06 20:51:32.390000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (96, 95, 60, '2026-04-06 20:51:32.691000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (97, 96, 15, '2026-04-06 20:51:33.020000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (98, 97, 100, '2026-04-06 20:51:33.318000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (99, 98, 80, '2026-04-06 20:51:33.624000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (100, 99, 20, '2026-04-06 20:51:33.926000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (101, 100, 3, '2026-04-06 20:51:34.266000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (102, 101, 8, '2026-04-06 20:51:34.613000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (103, 102, 10, '2026-04-06 20:51:34.925000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (104, 103, 12, '2026-04-06 20:51:35.226000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (105, 104, 150, '2026-04-06 20:51:35.555000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (106, 105, 5, '2026-04-06 20:51:35.856000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (107, 106, 40, '2026-04-06 20:51:36.151000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (108, 107, 25, '2026-04-06 20:51:36.464000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (109, 108, 90, '2026-04-06 20:51:36.774000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (110, 109, 18, '2026-04-06 20:51:37.078000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (111, 110, 55, '2026-04-06 20:51:37.395000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (112, 111, 2, '2026-04-06 20:51:37.710000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (113, 112, 20, '2026-04-06 20:51:38.015000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (114, 113, 45, '2026-04-06 20:51:38.344000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (115, 114, 35, '2026-04-06 20:51:38.643000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (116, 115, 40, '2026-04-06 20:51:38.977000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (117, 116, 50, '2026-04-06 20:51:39.294000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (118, 117, 30, '2026-04-06 20:51:39.594000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (119, 118, 110, '2026-04-06 20:51:39.890000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (120, 119, 15, '2026-04-06 20:51:40.208000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (121, 120, 7, '2026-04-06 20:51:40.516000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (122, 121, 60, '2026-04-06 20:51:41.214000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (123, 122, 40, '2026-04-06 20:51:41.513000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (124, 123, 55, '2026-04-06 20:51:41.817000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (125, 124, 100, '2026-04-06 20:51:42.117000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (126, 125, 150, '2026-04-06 20:51:42.414000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (127, 126, 80, '2026-04-06 20:51:42.727000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (128, 127, 20, '2026-04-06 20:51:43.034000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (129, 128, 45, '2026-04-06 20:51:43.332000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (130, 129, 15, '2026-04-06 20:51:43.637000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (131, 130, 10, '2026-04-06 20:51:43.937000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (132, 131, 90, '2026-04-06 20:51:44.258000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (133, 132, 65, '2026-04-06 20:51:44.562000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (134, 133, 75, '2026-04-06 20:51:44.865000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (135, 134, 18, '2026-04-06 20:51:45.169000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (136, 135, 8, '2026-04-06 20:51:45.481000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (137, 136, 30, '2026-04-06 20:51:45.777000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (138, 137, 50, '2026-04-06 20:51:46.077000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (139, 138, 60, '2026-04-06 20:51:46.394000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (140, 139, 22, '2026-04-06 20:51:46.695000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (141, 140, 40, '2026-04-06 20:51:47.001000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (142, 141, 85, '2026-04-06 20:51:47.295000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (143, 142, 120, '2026-04-06 20:51:47.661000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (144, 143, 20, '2026-04-06 20:51:47.957000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (145, 144, 35, '2026-04-06 20:51:48.257000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (146, 145, 12, '2026-04-06 20:51:48.556000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (147, 146, 100, '2026-04-06 20:51:48.859000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (148, 147, 40, '2026-04-06 20:51:49.165000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (150, 149, 200, '2026-04-06 20:51:49.769000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (151, 150, 5, '2026-04-06 20:51:50.066000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (152, 151, 12, '2026-04-06 20:51:50.361000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (153, 152, 25, '2026-04-06 20:51:50.658000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (154, 153, 60, '2026-04-06 20:51:50.959000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (155, 154, 8, '2026-04-06 20:51:51.259000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (156, 155, 35, '2026-04-06 20:51:51.556000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (157, 156, 80, '2026-04-06 20:51:51.856000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (35, 35, 43, '2026-06-12 14:53:10.583000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (4, 4, 27, '2026-06-12 17:18:38.169000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (5, 5, 54, '2026-06-12 17:21:06.490000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (158, 157, 50, '2026-04-06 20:51:52.151000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (159, 158, 20, '2026-04-06 20:51:52.451000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (160, 159, 5, '2026-04-06 20:51:52.750000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (161, 161, 30, '2026-04-06 20:51:53.047000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (162, 162, 100, '2026-04-06 20:51:53.342000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (163, 163, 4, '2026-04-06 20:51:53.654000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (164, 164, 70, '2026-04-06 20:51:53.964000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (165, 165, 15, '2026-04-06 20:51:54.269000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (166, 166, 45, '2026-04-06 20:51:54.594000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (167, 167, 22, '2026-04-06 20:51:54.935000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (168, 168, 10, '2026-04-06 20:51:55.234000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (169, 169, 40, '2026-04-06 20:51:55.649000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (170, 170, 25, '2026-04-06 20:51:56.017000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (171, 171, 18, '2026-04-06 20:51:56.334000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (172, 172, 55, '2026-04-06 20:51:56.650000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (173, 173, 90, '2026-04-06 20:51:56.964000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (174, 174, 150, '2026-04-06 20:51:57.268000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (175, 175, 35, '2026-04-06 20:51:57.569000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (176, 176, 80, '2026-04-06 20:51:57.866000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (177, 177, 15, '2026-04-06 20:51:58.176000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (178, 178, 2, '2026-04-06 20:51:58.474000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (179, 179, 20, '2026-04-06 20:51:58.779000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (180, 180, 40, '2026-04-06 20:51:59.082000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (1, 1, 48, '2026-04-23 12:54:40.683000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (181, 205, 50, '2026-06-06 09:48:11.978000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (182, 206, 50, '2026-06-06 09:48:27.877000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (183, 181, 50, '2026-06-06 09:48:50.163000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (184, 182, 50, '2026-06-06 09:48:50.697000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (185, 183, 50, '2026-06-06 09:48:51.225000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (186, 184, 50, '2026-06-06 09:48:51.777000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (187, 185, 50, '2026-06-06 09:48:52.308000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (188, 186, 50, '2026-06-06 09:48:52.806000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (189, 187, 50, '2026-06-06 09:48:53.413000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (190, 188, 50, '2026-06-06 09:48:53.977000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (191, 189, 50, '2026-06-06 09:48:54.537000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (192, 190, 50, '2026-06-06 09:48:55.069000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (193, 191, 50, '2026-06-06 09:48:55.578000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (194, 192, 50, '2026-06-06 09:48:56.149000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (195, 193, 50, '2026-06-06 09:48:56.660000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (196, 194, 50, '2026-06-06 09:48:57.166000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (197, 195, 50, '2026-06-06 09:48:57.674000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (198, 196, 50, '2026-06-06 09:48:58.173000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (199, 197, 50, '2026-06-06 09:48:58.701000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (200, 198, 50, '2026-06-06 09:48:59.215000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (201, 199, 50, '2026-06-06 09:48:59.734000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (202, 200, 50, '2026-06-06 09:49:00.275000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (203, 201, 50, '2026-06-06 09:49:00.835000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (204, 202, 50, '2026-06-06 09:49:01.425000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (205, 203, 50, '2026-06-06 09:49:01.936000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (206, 204, 50, '2026-06-06 09:49:02.596000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (207, 207, 50, '2026-06-06 09:49:03.158000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (208, 208, 50, '2026-06-06 09:49:03.700000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (209, 209, 50, '2026-06-06 09:49:04.209000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (210, 210, 50, '2026-06-06 09:49:04.713000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (211, 211, 50, '2026-06-06 09:49:05.249000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (212, 212, 50, '2026-06-06 09:49:05.778000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (213, 213, 50, '2026-06-06 09:49:06.316000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (214, 214, 50, '2026-06-06 09:49:06.831000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (215, 215, 50, '2026-06-06 09:49:07.385000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (216, 216, 50, '2026-06-06 09:49:07.917000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (217, 217, 50, '2026-06-06 09:49:08.514000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (218, 218, 50, '2026-06-06 09:49:09.101000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (219, 219, 50, '2026-06-06 09:49:09.647000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (220, 220, 50, '2026-06-06 09:49:10.163000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (221, 221, 50, '2026-06-06 09:49:10.664000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (222, 222, 50, '2026-06-06 09:49:11.176000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (223, 223, 50, '2026-06-06 09:49:11.705000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (224, 224, 50, '2026-06-06 09:49:12.215000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (225, 225, 50, '2026-06-06 09:49:13.047000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (226, 226, 50, '2026-06-06 09:49:13.615000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (227, 227, 50, '2026-06-06 09:49:14.194000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (228, 228, 50, '2026-06-06 09:49:14.733000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (229, 229, 50, '2026-06-06 09:49:15.275000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (230, 230, 50, '2026-06-06 09:49:15.799000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (231, 231, 50, '2026-06-06 09:49:16.357000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (232, 232, 50, '2026-06-06 09:49:16.912000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (233, 233, 50, '2026-06-06 09:49:17.453000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (234, 234, 50, '2026-06-06 09:49:17.987000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (235, 235, 50, '2026-06-06 09:49:18.561000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (236, 236, 50, '2026-06-06 09:49:19.064000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (237, 237, 50, '2026-06-06 09:49:19.576000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (238, 238, 50, '2026-06-06 09:49:20.081000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (239, 239, 50, '2026-06-06 09:49:20.626000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (240, 240, 50, '2026-06-06 09:49:21.145000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (241, 241, 50, '2026-06-06 09:49:21.737000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (242, 242, 50, '2026-06-06 09:49:22.352000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (243, 243, 50, '2026-06-06 09:49:22.887000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (244, 244, 50, '2026-06-06 09:49:23.407000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (245, 245, 50, '2026-06-06 09:49:24.077000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (246, 246, 50, '2026-06-06 09:49:24.652000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (247, 247, 50, '2026-06-06 09:49:25.187000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (248, 248, 50, '2026-06-06 09:49:25.717000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (249, 249, 50, '2026-06-06 09:49:26.238000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (250, 250, 50, '2026-06-06 09:49:26.773000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (251, 251, 50, '2026-06-06 09:49:27.358000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (252, 252, 50, '2026-06-06 09:49:27.892000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (253, 253, 50, '2026-06-06 09:49:28.403000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (254, 254, 50, '2026-06-06 09:49:28.927000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (255, 255, 50, '2026-06-06 09:49:29.435000');
INSERT INTO inventory (id, product_id, quantity, last_update) VALUES (149, 148, 30, '2026-06-12 10:45:14.801000');

-- Dumping data for table: stock_movements
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (1, 1, 23, 'IMPORT', '', '2026-04-23 12:54:40.508000');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (2, 148, 2, 'EXPORT', 'ok', '2026-06-12 10:45:03.715000');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (3, 148, 17, 'IMPORT', '', '2026-06-12 10:45:14.706000');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (4, 35, 2, 'EXPORT', 'Tru kho cho don DH71', '2026-06-12 14:53:10.375000');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (5, 4, 3, 'EXPORT', 'Tru kho cho don DH74', '2026-06-12 17:18:37.969000');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (6, 5, 1, 'EXPORT', 'Tru kho cho don DH75', '2026-06-12 17:21:06.300000');

-- Dumping data for table: carts
INSERT INTO carts (id, user_id, created_at) VALUES (1, 1, '2026-03-18 15:04:15.069603');
INSERT INTO carts (id, user_id, created_at) VALUES (2, 2, '2026-03-18 15:04:15.069603');
INSERT INTO carts (id, user_id, created_at) VALUES (3, 3, '2026-03-18 15:04:15.069603');
INSERT INTO carts (id, user_id, created_at) VALUES (4, 4, '2026-03-18 15:04:15.069603');
INSERT INTO carts (id, user_id, created_at) VALUES (5, 5, '2026-03-18 15:04:15.069603');

-- (No data found for table: cart_items)

-- Dumping data for table: orders
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (48, 'thon tan quang', NULL, '2026-06-08 11:03:41.823000', 'tuan9bledinhchinh@gmail.com', 'tuan nguyen', '0905338411', 'PENDING', 63005800.0, 9, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (37, NULL, NULL, '2026-06-06 11:10:49.737000', 'balittedutphieukhang@gmail.com', 'Nguyễn khang', '+84859590337', 'COMPLETED', 17200000.0, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (38, NULL, NULL, '2026-06-06 11:10:50.265000', 'balittedutphieukhang@gmail.com', 'Nguyễn khang', '+84859590337', 'PENDING', 21600000.0, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (49, 'thon tan quang', NULL, '2026-06-08 11:03:44.464000', 'tuan9bledinhchinh@gmail.com', 'tuan nguyen', '0905338411', 'PENDING', 63005800.0, 9, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (39, NULL, NULL, '2026-06-06 11:10:50.704000', 'balittedutphieukhang@gmail.com', 'Nguyễn khang', '+84859590337', 'SHIPPING', 11500000.0, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (50, 'thon tan quang', NULL, '2026-06-08 11:03:47.225000', 'tuan9bledinhchinh@gmail.com', 'tuan nguyen', '0905338411', 'PENDING', 63005800.0, 9, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (40, '7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, '2026-06-07 14:16:59.912000', 'phamcongthanh.8311@gmail.com', 'Phạm Công Thanh', '0902208461', 'PENDING', 34400000.0, 23, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (51, 'thon tan quang', NULL, '2026-06-08 11:03:49.883000', 'tuan9bledinhchinh@gmail.com', 'tuan nguyen', '0905338411', 'PENDING', 63005800.0, 9, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (41, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-07 19:55:43.103000', NULL, 'Nguyễn Trường Quân', '0867868825', 'PENDING', 17200000.0, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (42, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-07 19:59:32.165000', NULL, 'Nguyễn Trường Quân', '0867868825', 'PENDING', 17200000.0, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (43, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-07 20:01:22.683000', NULL, 'Nguyễn Trường Quân', '0867868825', 'PENDING', 2.0, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (44, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-07 20:02:53.682000', NULL, 'Nguyễn Trường Quân', '0867868825', 'PENDING', 10800000.0, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (45, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-07 20:03:38.852000', NULL, 'Nguyễn Trường Quân', '0867868825', 'PENDING', 5800000.0, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (46, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-07 20:04:11.355000', NULL, 'Nguyễn Trường Quân', '0867868825', 'PENDING', 11600000.0, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (47, '7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, '2026-06-07 22:40:06.417000', 'phamcongthanh.8311@gmail.com', 'Phạm Công Thanh', '0902208461', 'PENDING', 17200000.0, 23, 0.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (54, 'Địa chỉ kiểm thử', NULL, '2026-06-07 15:43:19.089000', 'nguyentruongq169@gmail.com', 'Quân Nguyễn Trường', '0900000000', 'CHO_XAC_NHAN_THANH_TOAN', 17200000.0, 25, NULL, NULL, NULL, NULL, NULL, 'VIETQR', 'DEMO-VIETQR-WAITING', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (55, 'Địa chỉ kiểm thử', NULL, '2026-06-06 15:43:19.687000', 'nguyentruongq169@gmail.com', 'Quân Nguyễn Trường', '0900000000', 'PENDING', 8500000.0, 25, NULL, NULL, NULL, NULL, NULL, 'COD', 'DEMO-COD-PENDING', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (58, 'Địa chỉ kiểm thử', NULL, '2026-06-04 16:08:47.799000', 'nguyentruongq169@gmail.com', 'Quân Nguyễn Trường', '0900000000', 'CANCELLED', 6900000.0, 25, NULL, NULL, NULL, NULL, NULL, 'COD', 'DEMO-CANCELLED', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (59, 'Địa chỉ kiểm thử', NULL, '2026-06-03 16:08:48.287000', 'nguyentruongq169@gmail.com', 'Quân Nguyễn Trường', '0900000000', 'COMPLETED', 12500000.0, 25, 500000.0, 'QA500K', NULL, NULL, NULL, 'COD', 'DEMO-VOUCHER-COMPLETED', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (65, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-08 23:47:30.081000', 'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0867868825', 'DA_THANH_TOAN', 16340000.0, 25, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH65', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (60, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-08 23:10:10.374000', NULL, 'Nguyễn Trường Quân', '0867868825', 'DA_THANH_TOAN', 2.0, NULL, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH60', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (56, 'Địa chỉ kiểm thử', NULL, '2026-06-05 15:43:20.174000', 'nguyentruongq169@gmail.com', 'Quân Nguyễn Trường', '0900000000', 'DA_THANH_TOAN', 25900000.0, 25, NULL, NULL, NULL, NULL, NULL, 'VIETQR', 'DEMO-VIETQR-PAID', 'QA từ chối để hoàn nguyên đơn test', NULL, 'QA khách gửi yêu cầu hoàn trả', NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (53, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-08 15:16:57.210000', 'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0867868825', 'COMPLETED', 5800000.0, 25, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH53', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (64, 'Địa chỉ kiểm thử', NULL, '2026-06-04 23:33:18.240000', 'nguyentruongq169@gmail.com', 'Quân Nguyễn Trường', '0900000000', 'YEU_CAU_HOAN_TIEN', 18600000.0, 25, NULL, NULL, NULL, NULL, NULL, 'VIETQR', 'DEMO-VIETQR-REFUND-REQUESTED', NULL, 'DA_THANH_TOAN', 'Khách muốn trả hàng vì sản phẩm không phù hợp', NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (61, 'Địa chỉ kiểm thử', NULL, '2026-06-02 23:18:01.014000', 'nguyentruongq169@gmail.com', 'Quân Nguyễn Trường', '0900000000', 'CHO_HOAN_TIEN', 19900000.0, 25, NULL, NULL, NULL, NULL, NULL, 'VIETQR', 'DEMO-VIETQR-REFUND-WAITING', 'Khách yêu cầu hoàn tiền', 'DA_THANH_TOAN', 'Khách yêu cầu hoàn tiền', NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (62, 'Địa chỉ kiểm thử', NULL, '2026-06-01 23:18:01.503000', 'nguyentruongq169@gmail.com', 'Quân Nguyễn Trường', '0900000000', 'DA_HOAN_TIEN', 21500000.0, 25, NULL, NULL, NULL, NULL, NULL, 'VIETQR', 'DEMO-VIETQR-REFUNDED', 'Đã hoàn tiền qua MB Bank', 'DA_THANH_TOAN', 'Khách yêu cầu hoàn tiền', NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (63, 'Địa chỉ kiểm thử', NULL, '2026-05-31 23:18:01.977000', 'nguyentruongq169@gmail.com', 'Quân Nguyễn Trường', '0900000000', 'THU_HOI', 15700000.0, 25, NULL, NULL, NULL, NULL, NULL, 'VIETQR', 'DEMO-VIETQR-RECALLED', 'Thu hồi theo yêu cầu kiểm thử', 'DA_THANH_TOAN', 'Khách yêu cầu trả hàng', NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (57, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-08 15:46:58.594000', 'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0867868825', 'DA_HOAN_TIEN', 16856000.0, 25, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH57', NULL, 'DA_THANH_TOAN', 'ko thích', NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (52, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-08 15:15:15.811000', 'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0867868825', 'COMPLETED', 17200000.0, 25, 0.0, NULL, NULL, NULL, NULL, 'COD', 'DH52', 'ko', NULL, 'ok', NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (66, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-09 20:28:19.138000', 'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0867868825', 'DA_THANH_TOAN', 1.9, 25, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH66', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (68, '7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, '2026-06-12 10:57:41.812000', 'tuan9bledinhchinh@gmail.com', 'Phạm Công Thanh', '0902208461', 'CHO_XAC_NHAN_THANH_TOAN', 32444600.0, 9, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH68', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (67, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-11 16:48:40.557000', 'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0867868825', 'DA_HOAN_TIEN', 1.9, 25, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH67', 'ok', 'COMPLETED', 'hàng lỗi', NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (69, '7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, '2026-06-12 11:08:55.462000', 'tuan9bledinhchinh@gmail.com', 'Phạm Công Thanh', '0902208461', 'PENDING', 8200000.0, 9, 0.0, NULL, NULL, NULL, NULL, 'COD', 'DH69', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (70, '7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, '2026-06-12 11:09:16.766000', 'tuan9bledinhchinh@gmail.com', 'Phạm Công Thanh', '0902208461', 'PAID', 5800000.0, 9, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH70', 'a', NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (71, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-12 14:53:09.436000', 'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0867868825', 'DA_THANH_TOAN', 1.9, 25, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH71', NULL, NULL, NULL, True, False);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (72, 'thon tan quang', NULL, '2026-06-12 15:00:23.616000', 'tuan9bledinhchinh@gmail.com', 'tuan nguyen', '0905338411', 'CHO_XAC_NHAN_THANH_TOAN', 8200001.0, 9, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH72', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (73, 'thon tan quang', NULL, '2026-06-12 15:41:15.560000', 'tuan9bledinhchinh@gmail.com', 'tuan nguyen', '0905338411', 'PENDING', 6324600.0, 9, 0.0, NULL, NULL, NULL, NULL, 'COD', 'DH73', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (84, 'thon tan quang', NULL, '2026-06-13 00:40:32.427000', NULL, 'tuan nguyen', '0905338411', 'CHO_XAC_NHAN_THANH_TOAN', 19000000.0, NULL, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH84', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (74, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-12 17:18:37.043000', 'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0867868825', 'DA_THANH_TOAN', 32775000.0, 25, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH74', NULL, NULL, NULL, True, False);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (81, '7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, '2026-06-12 19:56:48.799000', 'leecookcu@gmail.com', 'Phạm Công Thanh', '0902208461', 'PAID', 8500000.0, 29, 0.0, NULL, NULL, NULL, NULL, 'COD', 'DH81', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (75, 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, '2026-06-12 17:21:05.531000', 'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0867868825', 'CHO_XAC_NHAN_THANH_TOAN', 7790000.0, 25, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH75', NULL, NULL, NULL, True, False);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (76, '7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, '2026-06-12 18:33:05.785000', NULL, 'Phạm Công Thanh', '0902208461', 'PENDING', 15500000.0, NULL, 0.0, NULL, NULL, NULL, NULL, 'COD', 'DH76', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (80, '7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, '2026-06-12 19:56:26.768000', 'leecookcu@gmail.com', 'Phạm Công Thanh', '0902208461', 'PAID', 8900000.0, 29, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH80', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (77, '7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, '2026-06-12 18:40:11.544000', 'tuan9bledinhchinh@gmail.com', 'Phạm Công Thanh', '0902208461', 'PAID', 15500000.0, 9, 0.0, NULL, NULL, NULL, NULL, 'COD', 'DH77', 'a', NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (78, '7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, '2026-06-12 19:54:13.439000', 'leecookcu@gmail.com', 'Phạm Công Thanh', '0902208461', 'COMPLETED', 5800000.0, 29, 0.0, NULL, NULL, NULL, NULL, 'COD', 'DH78', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (79, '7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, '2026-06-12 19:55:59.468000', 'leecookcu@gmail.com', 'Phạm Công Thanh', '0902208461', 'SHIPPING', 2.0, 29, 0.0, NULL, NULL, NULL, NULL, 'INSTALLMENT', 'DH79', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (82, 'thon tan quang', NULL, '2026-06-13 00:39:26.895000', NULL, 'tuan nguyen', '0905338411', 'CHO_XAC_NHAN_THANH_TOAN', 7000000.0, NULL, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH82', NULL, NULL, NULL, NULL, NULL);
INSERT INTO orders (id, address, city, created_at, email, full_name, phone, status, total_price, user_id, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, order_code, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored) VALUES (83, 'thon tan quang', NULL, '2026-06-13 00:39:28.168000', NULL, 'tuan nguyen', '0905338411', 'CHO_XAC_NHAN_THANH_TOAN', 7000000.0, NULL, 0.0, NULL, NULL, NULL, NULL, 'VIETQR', 'DH83', NULL, NULL, NULL, NULL, NULL);

-- Dumping data for table: order_items
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (57, 37, 2, 17200000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (58, 38, 3, 10800000.0, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (59, 39, 4, 11500000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (60, 40, 2, 17200000.0, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (61, 41, 2, 17200000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (62, 42, 2, 17200000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (63, 43, 2, 1.0, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (64, 44, 3, 10800000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (65, 45, 6, 5800000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (66, 46, 6, 5800000.0, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (67, 47, 2, 17200000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (68, 48, 160, 42000000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (69, 48, 197, 10642600.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (70, 48, 214, 6324600.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (71, 49, 160, 42000000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (72, 48, 217, 4038600.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (73, 49, 197, 10642600.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (74, 49, 214, 6324600.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (75, 50, 160, 42000000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (76, 49, 217, 4038600.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (77, 50, 197, 10642600.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (78, 50, 214, 6324600.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (79, 51, 160, 42000000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (80, 50, 217, 4038600.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (81, 51, 197, 10642600.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (82, 51, 214, 6324600.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (83, 51, 217, 4038600.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (84, 52, 2, 17200000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (85, 53, 6, 5800000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (86, 54, 2, 17200000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (87, 55, 3, 8500000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (88, 56, 4, 25900000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (89, 57, 2, 17200000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (90, 58, 5, 6900000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (91, 59, 6, 12500000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (92, 60, 2, 1.0, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (93, 61, 2, 19900000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (94, 62, 3, 21500000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (95, 63, 4, 15700000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (96, 64, 5, 18600000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (97, 65, 2, 17200000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (98, 66, 2, 1.0, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (99, 67, 2, 1.0, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (100, 68, 195, 26644600.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (101, 68, 6, 5800000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (102, 69, 5, 8200000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (103, 70, 6, 5800000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (104, 71, 35, 1.0, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (105, 72, 5, 8200000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (106, 72, 7, 1.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (107, 73, 182, 6324600.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (108, 74, 4, 11500000.0, 3);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (109, 75, 5, 8200000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (110, 76, 1, 15500000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (111, 77, 1, 15500000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (112, 78, 6, 5800000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (113, 79, 8, 1.0, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (114, 80, 9, 8900000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (115, 81, 10, 8500000.0, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (116, 82, 11, 3500000.0, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (117, 83, 11, 3500000.0, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (118, 84, 15, 9500000.0, 2);

-- Dumping data for table: pc_builds
INSERT INTO pc_builds (id, user_id, total_price, created_at) VALUES (1, 3, '70000000.00', '2026-03-18 15:04:15.069603');
INSERT INTO pc_builds (id, user_id, total_price, created_at) VALUES (2, 4, '68000000.00', '2026-03-18 15:04:15.069603');
INSERT INTO pc_builds (id, user_id, total_price, created_at) VALUES (3, 5, '71000000.00', '2026-03-18 15:04:15.069603');
INSERT INTO pc_builds (id, user_id, total_price, created_at) VALUES (4, 2, '69000000.00', '2026-03-18 15:04:15.069603');
INSERT INTO pc_builds (id, user_id, total_price, created_at) VALUES (5, 1, '72000000.00', '2026-03-18 15:04:15.069603');

-- Dumping data for table: shared_builds
INSERT INTO pc_builds (id, user_id, total_price, created_at) VALUES (1000, 9, '6324600.00', '2026-06-08 08:57:00.861000');
INSERT INTO shared_builds (share_code, build_id, name, created_at) VALUES ('SgH8BPfKi', 1000, 'Cấu hình chia sẻ từ LuxuryPC', '2026-06-08 08:57:00.861000');
INSERT INTO pc_builds (id, user_id, total_price, created_at) VALUES (1001, 9, '43846600.00', '2026-06-08 09:16:38.064000');
INSERT INTO shared_builds (share_code, build_id, name, created_at) VALUES ('YjuDDZBmF', 1001, 'Cấu hình chia sẻ từ LuxuryPC', '2026-06-08 09:16:38.064000');
INSERT INTO pc_builds (id, user_id, total_price, created_at) VALUES (1002, 9, '16500000.00', '2026-06-08 11:00:53.226000');
INSERT INTO shared_builds (share_code, build_id, name, created_at) VALUES ('GkzUSXbnb', 1002, 'Cấu hình chia sẻ từ LuxuryPC', '2026-06-08 11:00:53.226000');
INSERT INTO pc_builds (id, user_id, total_price, created_at) VALUES (1003, 9, '4038600.00', '2026-06-12 21:36:53.070000');
INSERT INTO shared_builds (share_code, build_id, name, created_at) VALUES ('vhcCYAcwQ', 1003, 'Cấu hình chia sẻ từ LuxuryPC', '2026-06-12 21:36:53.070000');
INSERT INTO pc_builds (id, user_id, total_price, created_at) VALUES (1004, 9, '4038600.00', '2026-06-12 21:37:12.758000');
INSERT INTO shared_builds (share_code, build_id, name, created_at) VALUES ('PD2VKKQMI', 1004, 'Cấu hình chia sẻ từ LuxuryPC', '2026-06-12 21:37:12.758000');
INSERT INTO pc_builds (id, user_id, total_price, created_at) VALUES (1005, 9, '16500000.00', '2026-06-12 23:20:41.723000');
INSERT INTO shared_builds (share_code, build_id, name, created_at) VALUES ('4AV2z0htw', 1005, 'Cấu hình chia sẻ từ LuxuryPC', '2026-06-12 23:20:41.723000');
INSERT INTO pc_builds (id, user_id, total_price, created_at) VALUES (1006, 9, '35000000.00', '2026-06-12 23:32:30.564000');
INSERT INTO shared_builds (share_code, build_id, name, created_at) VALUES ('LRulzT5P9', 1006, 'Cấu hình chia sẻ từ LuxuryPC', '2026-06-12 23:32:30.564000');
INSERT INTO pc_builds (id, user_id, total_price, created_at) VALUES (1007, 9, '35000000.00', '2026-06-12 23:38:14.695000');
INSERT INTO shared_builds (share_code, build_id, name, created_at) VALUES ('OePjnf2vB', 1007, 'Cấu hình chia sẻ từ LuxuryPC', '2026-06-12 23:38:14.695000');

-- Dumping data for table: chat_messages
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (1, '2026-06-08 09:33:44.067000', '36', 'CUSTOMER', 'Khang', 2);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (2, '2026-06-08 09:34:20.797000', 'hi', 'ADMIN', 'tuan9bledinhchinh@gmail.com', 2);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (3, '2026-06-08 09:34:29.192000', '36 ne', 'CUSTOMER', 'Khang', 2);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (4, '2026-06-08 09:34:32.609000', 'cai conca', 'ADMIN', 'tuan9bledinhchinh@gmail.com', 2);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (5, '2026-06-15 09:14:14.667000', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', '36', 3);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (6, '2026-06-15 09:52:40.029000', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', '36', 4);

-- (No data found for table: flash_sale_items)

-- Dumping data for table: flash_sales
INSERT INTO flash_sales (id, active, created_at, end_time, name, start_time) VALUES (1, True, '2026-06-08 15:41:33.316000', '2026-10-06 12:00:00', 'vocher test', '2026-08-06 12:00:00');

-- Dumping data for table: reviews
INSERT INTO reviews (id, content, created_at, stars, user_id, product_id, order_id, title, image) VALUES (37, 'Máy build từ Luxury PC chạy mượt như mơ. RTX 4090 kết hợp với i9-14900K — không có game nào kháng cự được. Đáng từng đồng bỏ ra.', '2026-06-02 19:05:41.163089', 5, 7, NULL, NULL, NULL, NULL);
INSERT INTO reviews (id, content, created_at, stars, user_id, product_id, order_id, title, image) VALUES (38, 'Dịch vụ tư vấn chuyên nghiệp, lắp ráp cực kỳ thẩm mỹ. Tôi rất hài lòng với chiếc Workstation mới này.', '2026-06-02 19:05:41.163089', 5, 7, NULL, NULL, NULL, NULL);
INSERT INTO reviews (id, content, created_at, stars, user_id, product_id, order_id, title, image) VALUES (39, 'Bảo hành nhanh chóng, nhân viên nhiệt tình hỗ trợ. Xứng đáng với danh hiệu Luxury PC.', '2026-06-02 19:05:41.163089', 4, 7, NULL, NULL, NULL, NULL);
INSERT INTO reviews (id, content, created_at, stars, user_id, product_id, order_id, title, image) VALUES (40, 'h', '2026-06-04 12:14:27.925631', 5, 9, 3, NULL, NULL, NULL);
INSERT INTO reviews (id, content, created_at, stars, user_id, product_id, order_id, title, image) VALUES (41, 'a', '2026-06-12 18:25:44.505092', 3, 9, 7, NULL, NULL, NULL);
INSERT INTO reviews (id, content, created_at, stars, user_id, product_id, order_id, title, image) VALUES (46, 'sdf d sf', '2026-06-13 20:37:07.787499', 4, 29, 7, NULL, NULL, '/uploads/reviews/review_7_29_1781357884015.png');

-- Dumping data for table: shipping_addresses
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (2, 'a', 'a', False, 'a', 'a', 'a', 9);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (1, 'ư', 'ư', True, 'ư', 'ư', 'ư', 9);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (5, 'A', 'A', False, 'A', 'A', 'A', 29);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (6, 'S', 'S', True, 'S', 'S', 'S', 29);

-- Dumping data for table: spring_session
INSERT INTO spring_session (primary_id, session_id, creation_time, last_access_time, max_inactive_interval, expiry_time, principal_name) VALUES ('3f78fb97-2fd3-4020-bb7d-764d669fc6e1', 'ff80acf4-3cb1-4bc7-a160-2538af7cbb22', 1781496877196, 1781496899586, 1800, 1781498699586, NULL);

-- Dumping data for table: spring_session_attributes
INSERT INTO spring_session_attributes (session_primary_id, attribute_name, attribute_bytes) VALUES ('3f78fb97-2fd3-4020-bb7d-764d669fc6e1', 'cart', '<memory at 0x00000211CF5D9F00>');

-- Dumping data for table: support_tickets
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (1, '36', 'tuan9bledinhchinh@gmail.com', '', 'PRICE', '2026-06-05 14:44:01.007000', 'tuan9bledinhchinh@gmail.com', 'nn', '0905338411', 'concho', 'CLOSED', 'Tư vấn Build PC 3D', '2026-06-08 09:07:04.861000', NULL);
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (2, NULL, 'tuan9bledinhchinh@gmail.com', '', 'TECHNICAL', '2026-06-08 09:33:43.600000', 'tuan9bledinhchinh@gmail.com', 'Khang', '0905338411', '36', 'CLOSED', 'Tư vấn Build PC 3D', '2026-06-08 09:36:52.083000', 9);
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (3, NULL, NULL, NULL, 'GENERAL', '2026-06-15 09:14:14.302000', 'tonghai1209.jp@gmail.com', '36', '', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'OPEN', 'Chat hỗ trợ trực tuyến', '2026-06-15 09:14:14.302000', NULL);
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (4, NULL, NULL, NULL, 'GENERAL', '2026-06-15 09:52:39.573000', 'tonghai1209.jp@gmail.com', '36', '', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'OPEN', 'Chat hỗ trợ trực tuyến', '2026-06-15 09:52:39.573000', NULL);

-- Dumping data for table: ticket_messages
INSERT INTO ticket_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (7, '2026-06-10 19:07:19.395000', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', '36', 2);
INSERT INTO ticket_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (8, '2026-06-10 19:07:24.231000', 'Khách hàng đã kết thúc cuộc trò chuyện.', 'SYSTEM', 'Hệ thống', 2);
INSERT INTO ticket_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (9, '2026-06-12 21:21:33.864000', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', '36', 3);
INSERT INTO ticket_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (10, '2026-06-12 21:28:45.010000', 'Khách hàng đã kết thúc cuộc trò chuyện.', 'SYSTEM', 'Hệ thống', 3);
INSERT INTO ticket_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (11, '2026-06-12 21:29:29.279000', '36', 'ADMIN', 'Admin', 2);
INSERT INTO ticket_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (12, '2026-06-13 21:18:23.557000', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', '36', 4);
INSERT INTO ticket_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (13, '2026-06-13 21:18:32.876000', 'cac thanh', 'CUSTOMER', '36', 4);
INSERT INTO ticket_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (14, '2026-06-13 21:18:48.297000', 'cac thanh cac thanh', 'ADMIN', 'Admin', 4);
INSERT INTO ticket_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (15, '2026-06-13 21:19:06.806000', 'Khách hàng đã kết thúc cuộc trò chuyện.', 'SYSTEM', 'Hệ thống', 4);

-- Dumping data for table: tickets
INSERT INTO tickets (id, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject) VALUES (3, NULL, NULL, 'GENERAL', '2026-06-12 21:21:33.575000', 'tonghai1209.jp@gmail.com', '36', NULL, 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CLOSED', 'Chat hỗ trợ trực tuyến');
INSERT INTO tickets (id, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject) VALUES (2, 'tuan9bledinhchinh@gmail.com', NULL, 'GENERAL', '2026-06-10 19:07:19.176000', 'tonghai1209.jp@gmail.com', '36', NULL, 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CLOSED', 'Chat hỗ trợ trực tuyến');
INSERT INTO tickets (id, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject) VALUES (4, 'tuan9bledinhchinh@gmail.com', NULL, 'GENERAL', '2026-06-13 21:18:23.281000', 'tonghai1209.jp@gmail.com', '36', NULL, 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CLOSED', 'Chat hỗ trợ trực tuyến');

-- (No data found for table: user_addresses)

-- Dumping data for table: user_notification_settings
INSERT INTO user_notification_settings (id, flash_sale, member_points, new_products, order_updates, updated_at, weekly_newsletter, user_id) VALUES (1, True, NULL, False, True, '2026-04-08 21:51:31.757000', True, 9);

-- Dumping data for table: user_vouchers
INSERT INTO user_vouchers (id, is_used, saved_at, used_at, user_id, voucher_id) VALUES (1, False, '2026-06-13 08:43:03.508000', NULL, 29, 3);
INSERT INTO user_vouchers (id, is_used, saved_at, used_at, user_id, voucher_id) VALUES (2, False, '2026-06-13 21:33:19.910000', NULL, 29, 5);

-- Dumping data for table: vouchers
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES (3, True, '123', '2026-06-13 08:42:52.438000', '2', 'PERCENTAGE', 2.0, '2026-06-28 00:12:00', 222222222222222.0, 111111111.0, '2026-02-16 11:11:00', NULL, 0, NULL);
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES (4, True, 'CACTHANH1014', '2026-06-13 21:30:24.320000', '10% giảm giá con cá', 'PERCENTAGE', 10.0, '2026-02-09 10:00:00', 1000000.0, 10.0, '2026-10-07 10:00:00', 1, 0, 86);
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES (5, True, 'CACTHANH10141', '2026-06-13 21:32:41.420000', 'màn hình', 'PERCENTAGE', 30.0, '9999-10-06 12:00:00', 1000000.0, 10.0, '2026-06-13 10:00:00', 10, 0, NULL);

-- Dumping data for table: wishlist_items
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (6, '2026-04-08 00:02:35.249000', 2, 1);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (8, '2026-04-08 00:15:00.043000', 5, 1);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (9, '2026-04-08 00:17:30.258000', 4, 1);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (10, '2026-04-08 00:17:38.760000', 1, 1);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (39, '2026-06-10 08:48:32.989000', 5, 7);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (40, '2026-06-10 08:48:35.589000', 2, 7);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (42, '2026-06-10 15:33:51.374000', 3, 9);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (47, '2026-06-14 22:33:52.570000', 7, 29);

-- Dumping data for table: pc_build_items
INSERT INTO pc_build_items (build_id, product_id) VALUES (1, 1);
INSERT INTO pc_build_items (build_id, product_id) VALUES (1, 3);
INSERT INTO pc_build_items (build_id, product_id) VALUES (1, 4);
INSERT INTO pc_build_items (build_id, product_id) VALUES (1, 4);
INSERT INTO pc_build_items (build_id, product_id) VALUES (1, 5);
INSERT INTO pc_build_items (build_id, product_id) VALUES (2, 2);
INSERT INTO pc_build_items (build_id, product_id) VALUES (2, 3);
INSERT INTO pc_build_items (build_id, product_id) VALUES (2, 4);
INSERT INTO pc_build_items (build_id, product_id) VALUES (2, 4);
INSERT INTO pc_build_items (build_id, product_id) VALUES (2, 5);
INSERT INTO pc_build_items (build_id, product_id) VALUES (3, 1);
INSERT INTO pc_build_items (build_id, product_id) VALUES (3, 3);
INSERT INTO pc_build_items (build_id, product_id) VALUES (3, 4);
INSERT INTO pc_build_items (build_id, product_id) VALUES (3, 4);
INSERT INTO pc_build_items (build_id, product_id) VALUES (3, 5);
INSERT INTO pc_build_items (build_id, product_id) VALUES (4, 2);
INSERT INTO pc_build_items (build_id, product_id) VALUES (4, 3);
INSERT INTO pc_build_items (build_id, product_id) VALUES (4, 4);
INSERT INTO pc_build_items (build_id, product_id) VALUES (4, 4);
INSERT INTO pc_build_items (build_id, product_id) VALUES (4, 5);
INSERT INTO pc_build_items (build_id, product_id) VALUES (5, 1);
INSERT INTO pc_build_items (build_id, product_id) VALUES (5, 3);
INSERT INTO pc_build_items (build_id, product_id) VALUES (5, 4);
INSERT INTO pc_build_items (build_id, product_id) VALUES (5, 4);
INSERT INTO pc_build_items (build_id, product_id) VALUES (5, 5);
INSERT INTO pc_build_items (build_id, product_id) VALUES (1001, 206);
INSERT INTO pc_build_items (build_id, product_id) VALUES (1001, 3);
INSERT INTO pc_build_items (build_id, product_id) VALUES (1001, 91);
INSERT INTO pc_build_items (build_id, product_id) VALUES (1001, 62);
INSERT INTO pc_build_items (build_id, product_id) VALUES (1002, 91);
INSERT INTO pc_build_items (build_id, product_id) VALUES (1003, 243);
INSERT INTO pc_build_items (build_id, product_id) VALUES (1004, 243);
INSERT INTO pc_build_items (build_id, product_id) VALUES (1005, 91);
INSERT INTO pc_build_items (build_id, product_id) VALUES (1006, 100);
INSERT INTO pc_build_items (build_id, product_id) VALUES (1007, 100);

-- =========================
-- INDEX
-- =========================
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_orders_user ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_cart_user ON carts(user_id);
CREATE INDEX IF NOT EXISTS idx_build_user ON pc_builds(user_id);
CREATE INDEX IF NOT EXISTS idx_build_item_build ON pc_build_items(build_id);
CREATE INDEX IF NOT EXISTS idx_build_item_product ON pc_build_items(product_id);

-- ==========================================
-- SCRIPT DATA TEST & SETUP ROLE (Integrated)
-- ==========================================
-- 1. Nếu chưa có role ADMIN thì thêm
INSERT INTO roles (name)
SELECT 'ADMIN'
WHERE NOT EXISTS (
    SELECT 1 FROM roles WHERE LOWER(name) = 'admin'
);

-- 2. Gán quyền admin cho user
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id
FROM users u
JOIN roles r ON LOWER(r.name) = 'admin'
WHERE u.email = 'email_admin_can_tao@gmail.com'
AND NOT EXISTS (
    SELECT 1
    FROM user_roles ur
    WHERE ur.user_id = u.id
    AND ur.role_id = r.id
);

-- 3. Tạo các đơn hàng test (VietQR, COD, Refund...)
DO $$
DECLARE
    v_user_id INT;
    v_product_id INT;
    v_order_id INT;
BEGIN
    -- Tìm user mẫu
    SELECT id INTO v_user_id
    FROM users
    WHERE email = 'nguyentruongq169@gmail.com'
    LIMIT 1;

    IF v_user_id IS NULL THEN
        SELECT id INTO v_user_id
        FROM users
        ORDER BY id DESC
        LIMIT 1;
    END IF;

    -- Tìm product mẫu
    SELECT id INTO v_product_id
    FROM products
    WHERE name ILIKE '%AMD Ryzen 9 7950X3D%'
    LIMIT 1;

    IF v_product_id IS NULL THEN
        SELECT id INTO v_product_id
        FROM products
        ORDER BY id
        LIMIT 1;
    END IF;

    -- Nếu database trống trơn (chưa có users / products) thì bỏ qua phần seed order này.
    IF v_user_id IS NULL OR v_product_id IS NULL THEN
        RAISE NOTICE 'Không tìm thấy user hoặc product để seed dữ liệu test order. Hãy tạo user và product trước khi chạy DO block này.';
        RETURN;
    END IF;

    -- VietQR chờ xác nhận
    IF NOT EXISTS (SELECT 1 FROM orders WHERE order_code = 'QA-VIETQR-WAITING') THEN
        INSERT INTO orders (
            address, city, created_at, email, full_name, phone,
            status, total_price, user_id, discount_amount, voucher_code,
            installment_bank, installment_fee, installment_term,
            payment_method, order_code, admin_note,
            refund_previous_status, refund_reason
        )
        VALUES (
            'Địa chỉ test LuxuryPC', 'Hồ Chí Minh', NOW(),
            'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0900000000',
            'CHO_XAC_NHAN_THANH_TOAN', 17200000, v_user_id, 0, NULL,
            NULL, 0, NULL,
            'VietQR', 'QA-VIETQR-WAITING',
            'Đơn VietQR chờ admin xác nhận thanh toán',
            NULL, NULL
        )
        RETURNING id INTO v_order_id;

        INSERT INTO order_items (order_id, product_id, price, quantity)
        VALUES (v_order_id, v_product_id, 17200000, 1);
    END IF;

    -- VietQR đã thanh toán
    IF NOT EXISTS (SELECT 1 FROM orders WHERE order_code = 'QA-VIETQR-PAID') THEN
        INSERT INTO orders (
            address, city, created_at, email, full_name, phone,
            status, total_price, user_id, discount_amount, voucher_code,
            installment_bank, installment_fee, installment_term,
            payment_method, order_code, admin_note,
            refund_previous_status, refund_reason
        )
        VALUES (
            'Địa chỉ test LuxuryPC', 'Hồ Chí Minh', NOW(),
            'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0900000000',
            'DA_THANH_TOAN', 17200000, v_user_id, 0, NULL,
            NULL, 0, NULL,
            'VietQR', 'QA-VIETQR-PAID',
            'Admin đã xác nhận thanh toán VietQR',
            NULL, NULL
        )
        RETURNING id INTO v_order_id;

        INSERT INTO order_items (order_id, product_id, price, quantity)
        VALUES (v_order_id, v_product_id, 17200000, 1);
    END IF;

    -- COD hoàn thành
    IF NOT EXISTS (SELECT 1 FROM orders WHERE order_code = 'QA-COD-COMPLETED') THEN
        INSERT INTO orders (
            address, city, created_at, email, full_name, phone,
            status, total_price, user_id, discount_amount, voucher_code,
            installment_bank, installment_fee, installment_term,
            payment_method, order_code, admin_note,
            refund_previous_status, refund_reason
        )
        VALUES (
            'Địa chỉ test LuxuryPC', 'Hồ Chí Minh', NOW(),
            'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0900000000',
            'COMPLETED', 17200000, v_user_id, 0, NULL,
            NULL, 0, NULL,
            'Thanh toán khi nhận hàng (COD)', 'QA-COD-COMPLETED',
            'Đơn COD đã hoàn thành',
            NULL, NULL
        )
        RETURNING id INTO v_order_id;

        INSERT INTO order_items (order_id, product_id, price, quantity)
        VALUES (v_order_id, v_product_id, 17200000, 1);
    END IF;

    -- Yêu cầu hoàn tiền
    IF NOT EXISTS (SELECT 1 FROM orders WHERE order_code = 'QA-REFUND-REQUEST') THEN
        INSERT INTO orders (
            address, city, created_at, email, full_name, phone,
            status, total_price, user_id, discount_amount, voucher_code,
            installment_bank, installment_fee, installment_term,
            payment_method, order_code, admin_note,
            refund_previous_status, refund_reason
        )
        VALUES (
            'Địa chỉ test LuxuryPC', 'Hồ Chí Minh', NOW(),
            'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0900000000',
            'YEU_CAU_HOAN_TIEN', 17200000, v_user_id, 0, NULL,
            NULL, 0, NULL,
            'VietQR', 'QA-REFUND-REQUEST',
            'Khách đã gửi yêu cầu hoàn tiền',
            'DA_THANH_TOAN',
            'Sản phẩm lỗi, khách yêu cầu hoàn trả'
        )
        RETURNING id INTO v_order_id;

        INSERT INTO order_items (order_id, product_id, price, quantity)
        VALUES (v_order_id, v_product_id, 17200000, 1);
    END IF;

    -- Chờ hoàn tiền
    IF NOT EXISTS (SELECT 1 FROM orders WHERE order_code = 'QA-REFUND-WAITING') THEN
        INSERT INTO orders (
            address, city, created_at, email, full_name, phone,
            status, total_price, user_id, discount_amount, voucher_code,
            installment_bank, installment_fee, installment_term,
            payment_method, order_code, admin_note,
            refund_previous_status, refund_reason
        )
        VALUES (
            'Địa chỉ test LuxuryPC', 'Hồ Chí Minh', NOW(),
            'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0900000000',
            'CHO_HOAN_TIEN', 17200000, v_user_id, 0, NULL,
            NULL, 0, NULL,
            'VietQR', 'QA-REFUND-WAITING',
            'Admin đã duyệt yêu cầu, đang chờ hoàn tiền',
            'DA_THANH_TOAN',
            'Hoàn tiền do sản phẩm lỗi'
        )
        RETURNING id INTO v_order_id;

        INSERT INTO order_items (order_id, product_id, price, quantity)
        VALUES (v_order_id, v_product_id, 17200000, 1);
    END IF;

    -- Đã hoàn tiền
    IF NOT EXISTS (SELECT 1 FROM orders WHERE order_code = 'QA-REFUND-DONE') THEN
        INSERT INTO orders (
            address, city, created_at, email, full_name, phone,
            status, total_price, user_id, discount_amount, voucher_code,
            installment_bank, installment_fee, installment_term,
            payment_method, order_code, admin_note,
            refund_previous_status, refund_reason
        )
        VALUES (
            'Địa chỉ test LuxuryPC', 'Hồ Chí Minh', NOW(),
            'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0900000000',
            'DA_HOAN_TIEN', 17200000, v_user_id, 0, NULL,
            NULL, 0, NULL,
            'VietQR', 'QA-REFUND-DONE',
            'Admin đã xác nhận hoàn tiền',
            'DA_THANH_TOAN',
            'Đã hoàn tiền cho khách'
        )
        RETURNING id INTO v_order_id;

        INSERT INTO order_items (order_id, product_id, price, quantity)
        VALUES (v_order_id, v_product_id, 17200000, 1);
    END IF;

    -- Đã thu hồi
    IF NOT EXISTS (SELECT 1 FROM orders WHERE order_code = 'QA-RECALL') THEN
        INSERT INTO orders (
            address, city, created_at, email, full_name, phone,
            status, total_price, user_id, discount_amount, voucher_code,
            installment_bank, installment_fee, installment_term,
            payment_method, order_code, admin_note,
            refund_previous_status, refund_reason
        )
        VALUES (
            'Địa chỉ test LuxuryPC', 'Hồ Chí Minh', NOW(),
            'nguyentruongq169@gmail.com', 'Nguyễn Trường Quân', '0900000000',
            'THU_HOI', 17200000, v_user_id, 0, NULL,
            NULL, 0, NULL,
            'VietQR', 'QA-RECALL',
            'Admin thu hồi đơn do lỗi xử lý',
            'DA_THANH_TOAN',
            'Thu hồi đơn test'
        )
        RETURNING id INTO v_order_id;

        INSERT INTO order_items (order_id, product_id, price, quantity)
        VALUES (v_order_id, v_product_id, 17200000, 1);
    END IF;

END $$;

-- ==========================================
-- SCRIPT TRUY VẤN KIỂM TRA DỮ LIỆU
-- ==========================================
SELECT 
    id,
    order_code,
    full_name,
    email,
    payment_method,
    status,
    total_price,
    refund_previous_status,
    refund_reason,
    admin_note,
    created_at
FROM orders
WHERE order_code LIKE 'QA-%'
ORDER BY id DESC;

SELECT 
    o.order_code,
    o.status,
    o.payment_method,
    oi.product_id,
    p.name AS product_name,
    oi.price,
    oi.quantity
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
LEFT JOIN products p ON p.id = oi.product_id
WHERE o.order_code LIKE 'QA-%'
ORDER BY o.id DESC;

SET session_replication_role = 'origin';
-- Dumped Data from Supabase

-- Data for Name: pc_combo_details;
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('2', 'cpu', '2', 256);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('3', 'mainboard', '2', 259);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('4', 'ram', '2', 262);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('5', 'vga', '2', 264);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('6', 'storage', '2', 268);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('7', 'psu', '2', 270);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('8', 'case', '2', 274);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('9', 'cooling', '2', 276);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('10', 'cpu', '3', 256);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('11', 'mainboard', '3', 259);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('12', 'ram', '3', 262);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('13', 'vga', '3', 265);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('14', 'storage', '3', 268);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('15', 'psu', '3', 270);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('16', 'case', '3', 275);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('17', 'cooling', '3', 276);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('18', 'cpu', '4', 257);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('19', 'mainboard', '4', 260);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('20', 'ram', '4', 263);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('21', 'vga', '4', 266);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('22', 'storage', '4', 269);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('23', 'psu', '4', 271);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('24', 'case', '4', 16);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('25', 'cooling', '4', 277);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('26', 'cpu', '5', 257);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('27', 'mainboard', '5', 261);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('28', 'ram', '5', 263);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('29', 'vga', '5', 267);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('30', 'storage', '5', 269);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('31', 'psu', '5', 272);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('32', 'case', '5', 16);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('33', 'cooling', '5', 277);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('34', 'cpu', '6', 258);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('35', 'mainboard', '6', 261);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('36', 'ram', '6', 263);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('37', 'vga', '6', 266);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('38', 'storage', '6', 269);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('39', 'psu', '6', 273);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('40', 'case', '6', 274);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('41', 'cooling', '6', 276);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('42', 'cpu', '7', 1);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('43', 'mainboard', '7', 91);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('44', 'ram', '7', 67);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('45', 'vga', '7', 284);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('46', 'storage', '7', 285);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('47', 'psu', '7', 270);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('48', 'case', '7', 275);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('49', 'cooling', '7', 286);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('50', 'cpu', '8', 279);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('51', 'mainboard', '8', 102);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('52', 'ram', '8', 62);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('53', 'vga', '8', 265);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('54', 'storage', '8', 285);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('55', 'psu', '8', 270);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('56', 'case', '8', 275);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('57', 'cooling', '8', 276);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('58', 'cpu', '2', 256);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('59', 'mainboard', '2', 259);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('60', 'ram', '2', 262);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('61', 'vga', '2', 264);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('62', 'storage', '2', 268);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('63', 'psu', '2', 270);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('64', 'case', '2', 274);
INSERT INTO public."pc_combo_details" ("id", "slot_type", "combo_id", "product_id") VALUES ('65', 'cooling', '2', 276);

-- Data for Name: pc_combos;
INSERT INTO public."pc_combos" ("id", "badge", "badge_color", "description", "image", "name", "price") VALUES ('2', 'HOT', '#ef4444', NULL, '/images/combo1.jpg', 'Combo 1: LXR Core Ultra 7 / RTX 5070Ti', 67000000);
INSERT INTO public."pc_combos" ("id", "badge", "badge_color", "description", "image", "name", "price") VALUES ('3', 'PREMIUM', '#eab308', NULL, '/images/combo2.jpg', 'Combo 2: LXR Core Ultra 7 / RTX 5080', 67000000);
INSERT INTO public."pc_combos" ("id", "badge", "badge_color", "description", "image", "name", "price") VALUES ('4', 'SALE', '#22c55e', NULL, '/images/combo3.jpg', 'Combo 3: LXR Intel i5-12400F / RTX 5060', 47000000);
INSERT INTO public."pc_combos" ("id", "badge", "badge_color", "description", "image", "name", "price") VALUES ('5', 'VALUE', '#3b82f6', NULL, '/images/combo4.jpg', 'Combo 4: LXR Intel i5-12400F / RTX 5060 Ti', 22000000);
INSERT INTO public."pc_combos" ("id", "badge", "badge_color", "description", "image", "name", "price") VALUES ('6', 'PERFORMANCE', '#f97316', NULL, '/images/combo5.jpg', 'Combo 5: LXR Intel i7-14700F / RTX 5060', 25000000);
INSERT INTO public."pc_combos" ("id", "badge", "badge_color", "description", "image", "name", "price") VALUES ('7', 'ULTIMATE', 'var(--gold)', NULL, '/images/combo2.jpg', 'Combo 6: LXR AMD Ryzen 9 / RTX 5090', 120000000);
INSERT INTO public."pc_combos" ("id", "badge", "badge_color", "description", "image", "name", "price") VALUES ('8', 'CREATOR', '#a855f7', NULL, '/images/combo1.jpg', 'Combo 7: LXR Studio / RTX 5080', 85000000);

-- Data for Name: translations;
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (1, 'admin-sidebar-dashboard', 'vi', 'Dashboard');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (2, 'admin-sidebar-products', 'vi', 'Sản phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (3, 'admin-sidebar-categories', 'vi', 'Danh mục');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (4, 'admin-sidebar-flashsales', 'vi', 'Flash Sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (5, 'admin-sidebar-manage-products', 'vi', 'Quản Lý Sản Phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (6, 'admin-sidebar-dashboard', 'en', 'Dashboard');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (7, 'admin-sidebar-products', 'en', 'Product');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (8, 'admin-sidebar-categories', 'en', 'Cat.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (9, 'admin-sidebar-flashsales', 'en', 'Flash sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (10, 'admin-sidebar-manage-products', 'en', 'Manage product');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (11, 'admin-sidebar-manage-inventory', 'vi', 'Quản Lý Kho');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (12, 'admin-sidebar-manage-inventory', 'en', 'Inventory Management');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (13, 'admin-sidebar-orders', 'vi', 'Đơn hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (14, 'admin-sidebar-orders', 'en', 'Orders');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (15, 'admin-sidebar-inventory', 'vi', 'Kho hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (16, 'admin-sidebar-users', 'vi', 'Người dùng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (17, 'admin-sidebar-manage-users', 'vi', 'Người Dùng & Hỗ Trợ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (18, 'admin-sidebar-vouchers', 'vi', 'Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (19, 'admin-sidebar-inventory', 'en', 'Assign Stocks');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (20, 'admin-sidebar-users', 'en', 'Users');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (21, 'admin-sidebar-manage-users', 'en', 'Support-User');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (22, 'admin-sidebar-vouchers', 'en', 'Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (23, 'admin-sidebar-tickets', 'vi', 'Hỗ Trợ (Tickets)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (24, 'admin-sidebar-tickets', 'en', 'Support (Tickets)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (25, 'admin-sidebar-logout', 'vi', 'Đăng Xuất');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (26, 'admin-sidebar-logout', 'en', 'Log out');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (27, 'admin-dashboard-title', 'vi', 'Bảng Điều Khiển');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (28, 'admin-dashboard-revenue-label', 'vi', 'Doanh Thu Tháng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (29, 'admin-dashboard-new-orders-label', 'vi', 'Đơn Hàng Mới');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (30, 'admin-dashboard-title', 'en', 'Panel');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (31, 'admin-dashboard-subtitle', 'vi', 'Tổng quan tình hình kinh doanh tháng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (32, 'admin-dashboard-revenue-label', 'en', 'Monthly revenue');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (33, 'admin-dashboard-new-orders-label', 'en', 'New order');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (34, 'admin-dashboard-low-stock-label', 'vi', 'Cảnh Báo Kho');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (35, 'admin-dashboard-subtitle', 'en', 'Overview of monthly business situation');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (36, 'admin-dashboard-low-stock-label', 'en', 'Warehouse Warnings');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (37, 'admin-dashboard-customers-label', 'vi', 'Tổng Khách Hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (38, 'admin-dashboard-customers-label', 'en', 'Total customer');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (39, 'admin-dashboard-chart-title', 'vi', 'Biểu Đồ Doanh Thu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (40, 'admin-dashboard-best-sellers-title', 'vi', 'Sản Phẩm Bán Chạy Nhất');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (41, 'admin-dashboard-col-product', 'vi', 'Tên Linh Kiện');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (42, 'admin-dashboard-chart-title', 'en', 'Revenue Charts');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (43, 'admin-dashboard-col-sold', 'vi', 'Đã Bán');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (44, 'admin-dashboard-best-sellers-title', 'en', 'Best Selling Product');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (45, 'admin-dashboard-col-product', 'en', 'Component name');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (46, 'admin-dashboard-stock-alerts-title', 'vi', 'Cảnh Báo Kho Hàng (Sắp Hết)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (47, 'admin-dashboard-col-sold', 'en', 'sold');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (48, 'admin-dashboard-col-alert-product', 'vi', 'Tên Sản Phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (49, 'admin-dashboard-stock-alerts-title', 'en', 'Warehouse Alert (Running Out)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (50, 'admin-dashboard-col-alert-product', 'en', 'Product Name');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (51, 'admin-dashboard-badge-low', 'vi', 'Chỉ còn ít');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (52, 'admin-dashboard-col-status', 'vi', 'Trạng Thái');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (53, 'admin-dashboard-col-stock', 'vi', 'Tồn Kho');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (54, 'admin-dashboard-badge-low', 'en', 'Only a few left');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (55, 'admin-dashboard-col-status', 'en', 'Status');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (56, 'admin-dashboard-col-stock', 'en', 'INVENTORY');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (58, 'admin-products-th-category', 'vi', 'Danh Mục');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (57, 'admin-products-label-stock', 'vi', 'Số lượng kho');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (61, 'admin-products-title-text', 'vi', 'Quản Lý Sản Phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (63, 'admin-products-title-text', 'en', 'Manage product');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (65, 'admin-products-file-choose', 'vi', 'Chọn ảnh tải lên...');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (67, 'admin-products-file-choose', 'en', 'Select Image to Upload');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (68, 'admin-categories-label-name', 'vi', 'Tên Danh Mục *');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (69, 'admin-products-btn-add', 'vi', 'Thêm Sản Phẩm Mới');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (71, 'admin-products-th-stock', 'vi', 'Kho');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (72, 'admin-products-btn-add', 'en', 'Add New Product');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (77, 'admin-products-label-desc', 'vi', 'Mô Tả Nhanh');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (78, 'admin-products-label-desc', 'en', 'Quick Description');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (80, 'admin-products-label-category', 'vi', 'Danh Mục');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (82, 'admin-products-label-category', 'en', 'Category');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (87, 'admin-categories-label-name', 'en', 'Category Name');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (88, 'admin-products-th-stock', 'en', 'warehouse');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (89, 'admin-categories-form-add', 'vi', 'Thêm Danh Mục');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (90, 'admin-categories-form-add', 'en', 'Add Category');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (91, 'admin-categories-th-name', 'vi', 'Tên Danh Mục');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (93, 'admin-categories-th-id', 'vi', 'ID');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (92, 'admin-categories-btn-add', 'vi', 'Thêm Danh Mục Mới');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (94, 'admin-categories-btn-cancel', 'vi', 'Hủy / Làm mới');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (95, 'admin-categories-btn-save', 'vi', 'Lưu Danh Mục');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (96, 'admin-categories-title', 'vi', 'Quản Lý Danh Mục');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (97, 'admin-categories-th-id', 'en', 'ID');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (98, 'admin-categories-btn-cancel', 'en', 'Cancel / Refresh');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (99, 'admin-categories-th-name', 'en', 'Category Name');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (101, 'admin-categories-title', 'en', 'Portfolio management');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (463, 'admin-flashitems-text-sold', 'en', 'sold');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (100, 'admin-categories-btn-add', 'en', 'Add New Category');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (102, 'admin-categories-btn-save', 'en', 'Save category');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (103, 'admin-categories-th-actions', 'vi', 'Thao Tác');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (104, 'admin-categories-th-actions', 'en', 'Operator');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (105, 'admin-categories-page-title', 'vi', 'Quản Lý Danh Mục — Luxury PC');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (106, 'admin-categories-page-title', 'en', 'Category Management — Luxury PC');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (107, 'admin-products-title-add', 'vi', 'Thêm Sản Phẩm Mới');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (110, 'admin-products-label-name', 'vi', 'Tên Sản Phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (109, 'admin-products-option-select-cat', 'vi', '-- Chọn danh mục --');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (108, 'admin-products-label-image', 'vi', 'Tải Ảnh Lên');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (111, 'admin-products-label-price', 'vi', 'Giá Bán (VNĐ)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (112, 'admin-products-title-add', 'en', 'Add New Product');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (113, 'admin-products-label-name', 'en', 'Product Name');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (114, 'admin-products-label-image', 'en', 'Upload Picture');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (115, 'admin-products-option-select-cat', 'en', '-- Select Category --');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (116, 'admin-products-label-price', 'en', 'Selling price (VND)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (117, 'admin-products-btn-save', 'vi', 'Lưu Sản Phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (118, 'admin-products-btn-save', 'en', 'Save Product');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (119, 'admin-products-th-actions', 'vi', 'Thao Tác');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (120, 'admin-products-th-actions', 'en', 'Operator');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (121, 'admin-products-th-price', 'vi', 'Giá Bán');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (122, 'admin-products-th-product', 'vi', 'Sản Phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (123, 'admin-products-th-price', 'en', 'Sale Price');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (124, 'admin-products-btn-cancel', 'vi', 'Hủy / Làm mới');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (125, 'admin-products-th-product', 'en', 'Products');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (126, 'admin-products-btn-cancel', 'en', 'Cancel / Refresh');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (127, 'admin-voucher-title', 'vi', 'Quản Lý Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (128, 'admin-voucher-list', 'vi', 'Danh Sách Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (129, 'admin-voucher-sub', 'vi', 'Tạo và quản lý mã khuyến mãi cho khách hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (130, 'admin-voucher-th-code', 'vi', 'Mã');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (131, 'admin-voucher-title', 'en', 'Manage Vouchers');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (132, 'admin-voucher-list', 'en', 'Voucher List');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (133, 'admin-voucher-sub', 'en', 'Create and manage promo codes for customers');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (134, 'admin-common-description', 'vi', 'Mô Tả');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (135, 'admin-voucher-th-code', 'en', 'Code');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (136, 'admin-voucher-btn-create', 'vi', 'Tạo Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (137, 'admin-common-description', 'en', 'Description ....');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (138, 'admin-voucher-btn-create', 'en', 'Generate Coupon');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (139, 'admin-voucher-th-type', 'vi', 'Loại');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (140, 'admin-voucher-th-minorder', 'vi', 'Đơn Tối Thiểu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (141, 'admin-voucher-th-type', 'en', 'Type');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (142, 'admin-voucher-th-minorder', 'en', 'Minimum order');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (143, 'admin-voucher-th-usage', 'vi', 'Sử Dụng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (144, 'admin-voucher-th-expiry', 'vi', 'Thời Hạn');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (145, 'admin-voucher-th-value', 'vi', 'Giá Trị');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (146, 'admin-voucher-th-usage', 'en', 'Usage');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (147, 'admin-voucher-th-expiry', 'en', 'TERM');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (148, 'admin-voucher-th-value', 'en', 'Value');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (149, 'admin-common-status', 'vi', 'Trạng Thái');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (150, 'admin-common-status', 'en', 'Status');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (151, 'admin-common-action', 'vi', 'Hành Động');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (152, 'admin-common-action', 'en', 'Action');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (153, 'admin-voucher-type-percent', 'vi', 'Phần trăm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (154, 'admin-voucher-modal-create', 'vi', 'Tạo Voucher Mới');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (155, 'admin-voucher-type-percent', 'en', 'Percent');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (156, 'admin-voucher-modal-create', 'en', 'Create New Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (157, 'admin-common-active', 'vi', 'Hoạt động');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (158, 'admin-voucher-btn-toggle-off', 'vi', 'Tắt');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (159, 'admin-common-active', 'en', 'Activity');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (160, 'admin-voucher-label-code', 'vi', 'Mã Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (161, 'admin-voucher-btn-toggle-off', 'en', 'Off');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (162, 'admin-voucher-label-code', 'en', 'Voucher Code');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (163, 'admin-voucher-label-type', 'vi', 'Loại Giảm Giá');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (164, 'admin-voucher-opt-percent', 'vi', 'Phần trăm (%)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (165, 'admin-voucher-label-type', 'en', 'Sale Type');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (166, 'admin-voucher-opt-percent', 'en', 'Percent (%)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (167, 'admin-voucher-opt-fixed', 'vi', 'Số tiền cố định (₫)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (168, 'admin-voucher-opt-fixed', 'en', 'Fixed Amount');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (169, 'admin-voucher-label-value', 'vi', 'Giá Trị Giảm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (170, 'admin-voucher-label-max', 'vi', 'Giảm Tối Đa (₫)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (171, 'admin-voucher-label-minorder', 'vi', 'Đơn Tối Thiểu (₫)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (172, 'admin-voucher-label-value', 'en', 'Discount value');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (173, 'admin-voucher-label-max', 'en', 'Off type % (max)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (174, 'admin-voucher-label-minorder', 'en', 'Minimum Application (₫)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (175, 'admin-voucher-label-limit', 'vi', 'Giới Hạn Lượt Dùng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (176, 'admin-voucher-label-limit', 'en', 'Usage Limits');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (177, 'admin-voucher-label-end', 'vi', 'Kết Thúc');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (178, 'admin-voucher-label-category', 'vi', 'Áp Dụng Cho Danh Mục (để trống = tất
                        cả)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (179, 'admin-voucher-label-end', 'en', 'End');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (180, 'admin-voucher-opt-all-products', 'vi', 'Tất cả sản phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (181, 'admin-voucher-label-category', 'en', 'Apply to Category (leave blank = all
                        both)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (182, 'admin-voucher-opt-all-products', 'en', 'All products');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (183, 'admin-common-cancel', 'vi', 'Hủy');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (184, 'admin-common-cancel', 'en', 'Cancel');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (185, 'admin-voucher-btn-save', 'vi', 'Lưu Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (186, 'admin-voucher-btn-save', 'en', 'Save Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (187, 'admin-flashsales-list-title', 'vi', 'Danh Sách Chương Trình');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (188, 'admin-flashsales-btn-create', 'vi', 'Tạo Flash Sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (189, 'admin-flashsales-th-name', 'vi', 'Tên Chương Trình');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (190, 'admin-flashsales-th-id', 'vi', 'ID');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (191, 'admin-flashsales-title', 'vi', 'Quản Lý Flash Sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (192, 'admin-flashsales-subtitle', 'vi', 'Tạo chương trình Flash Sale với giá sốc, thời gian giới hạn');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (193, 'admin-flashsales-list-title', 'en', 'Program List');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (194, 'admin-flashsales-th-name', 'en', 'Program Name');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (195, 'admin-flashsales-btn-create', 'en', 'Flash sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (196, 'admin-flashsales-th-id', 'en', 'ID');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (197, 'admin-flashsales-title', 'en', 'Manage Flash Sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (198, 'admin-flashsales-subtitle', 'en', 'Create a Flash Sale for a shock price, limited time');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (199, 'admin-flashsales-th-start', 'vi', 'Bắt Đầu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (200, 'admin-flashsales-th-actions', 'vi', 'Hành Động');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (201, 'admin-flashsales-th-status', 'vi', 'Trạng Thái');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (202, 'admin-flashsales-th-start', 'en', 'Getting Started');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (203, 'admin-flashsales-th-actions', 'en', 'Action');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (204, 'admin-flashsales-th-end', 'vi', 'Kết Thúc');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (205, 'admin-flashsales-th-status', 'en', 'Status');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (206, 'admin-flashsales-th-end', 'en', 'End');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (207, 'admin-flashsales-status-disabled', 'vi', 'Đã tắt');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (210, 'admin-flashsales-btn-products', 'en', 'Products');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (212, 'admin-flashsales-label-name', 'vi', 'Tên Chương Trình');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (213, 'admin-flashsales-modal-title', 'en', 'Create New Flash Sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (215, 'admin-flashsales-label-start', 'vi', 'Bắt Đầu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (216, 'admin-flashsales-btn-cancel', 'vi', 'Hủy');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (218, 'admin-flashsales-label-end', 'vi', 'Kết Thúc');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (208, 'admin-flashsales-btn-products', 'vi', 'Sản Phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (209, 'admin-flashsales-status-disabled', 'en', 'Disabled');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (220, 'admin-flashsales-btn-submit', 'vi', 'Tạo Chương Trình');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (221, 'admin-flashsales-label-end', 'en', 'End');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (211, 'admin-flashsales-modal-title', 'vi', 'Tạo Flash Sale Mới');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (214, 'admin-flashsales-label-name', 'en', 'Program Name');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (217, 'admin-flashsales-label-start', 'en', 'Getting Started');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (219, 'admin-flashsales-btn-cancel', 'en', 'Cancel');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (222, 'admin-flashsales-btn-submit', 'en', 'curriculum construction');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (223, 'admin-flashsales-status-ended', 'vi', 'Đã kết thúc');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (224, 'admin-flashsales-status-ended', 'en', 'Ended');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (225, 'admin-inventory-th-product', 'vi', 'Sản Phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (226, 'admin-inventory-title', 'vi', 'Quản Lý Kho Hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (227, 'admin-inventory-th-last-update', 'vi', 'Cập Nhật Cuối');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (228, 'admin-inventory-text-products', 'vi', 'sản phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (229, 'admin-inventory-th-category', 'vi', 'Danh Mục');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (230, 'admin-inventory-th-product', 'en', 'Products');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (231, 'admin-inventory-title', 'en', 'Manage Stores Stock');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (232, 'admin-inventory-th-last-update', 'en', 'Last update');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (233, 'admin-inventory-text-products', 'en', 'products left');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (234, 'admin-inventory-th-category', 'en', 'Category');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (235, 'admin-inventory-th-stock', 'vi', 'Tồn Kho');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (236, 'admin-inventory-th-stock', 'en', 'INVENTORY');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (237, 'admin-inventory-th-adjust', 'vi', 'Điều Chỉnh Kho');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (238, 'admin-inventory-th-adjust', 'en', 'Inventory adjustments');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (239, 'admin-inventory-option-export', 'vi', 'Xuất Kho');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (240, 'admin-inventory-option-import', 'vi', 'Nhập Kho');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (241, 'admin-inventory-btn-submit', 'vi', 'Xác Nhận');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (242, 'admin-inventory-option-export', 'en', 'manufacturer-caused defects');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (243, 'admin-inventory-option-import', 'en', 'Warehousing');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (244, 'admin-inventory-badge-low', 'vi', 'Sắp hết');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (245, 'admin-inventory-btn-submit', 'en', 'Confirm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (246, 'admin-inventory-badge-low', 'en', 'Running out');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (247, 'admin-orders-th-code', 'vi', 'Mã Đơn');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (248, 'admin-orders-th-total', 'vi', 'Tổng Tiền');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (249, 'admin-orders-title', 'vi', 'Quản Lý Đơn Hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (250, 'admin-orders-th-customer', 'vi', 'Khách Hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (251, 'admin-orders-text-orders', 'vi', 'đơn hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (252, 'admin-orders-th-code', 'en', 'Order ID');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (253, 'admin-orders-th-date', 'vi', 'Ngày Đặt');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (254, 'admin-orders-th-total', 'en', 'Total amount');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (255, 'admin-orders-title', 'en', 'Order Mgmt');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (256, 'admin-orders-th-customer', 'en', 'Customer');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (257, 'admin-orders-text-orders', 'en', 'Items');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (258, 'admin-orders-th-date', 'en', 'Date order');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (259, 'admin-orders-th-payment', 'vi', 'Thanh Toán');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (260, 'admin-orders-th-voucher', 'vi', 'Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (261, 'admin-orders-th-actions', 'vi', 'Hành Động');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (262, 'admin-orders-th-note', 'vi', 'Ghi Chú');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (263, 'admin-orders-th-payment', 'en', 'PAYMENT');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (264, 'admin-orders-th-voucher', 'en', 'Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (265, 'admin-orders-th-status', 'vi', 'Trạng Thái');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (266, 'admin-orders-th-actions', 'en', 'Action');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (267, 'admin-orders-th-note', 'en', 'Note :');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (268, 'admin-orders-status-thu_hoi', 'vi', 'Đã thu hồi');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (269, 'admin-orders-th-status', 'en', 'Status');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (270, 'admin-orders-status-thu_hoi', 'en', 'Recalled —!');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (271, 'admin-orders-summary-actions', 'vi', 'Thao tác');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (272, 'admin-orders-status-pending', 'vi', 'Chờ xử lý');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (273, 'admin-orders-status-paid', 'vi', 'Đã thanh toán');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (274, 'admin-orders-summary-actions', 'en', 'Action');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (275, 'admin-orders-closed', 'vi', 'Đơn đã kết thúc xử lý.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (276, 'admin-orders-status-pending', 'en', 'Pending');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (277, 'admin-orders-status-paid', 'en', 'Billed');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (278, 'admin-orders-closed', 'en', 'Application has finished processing.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (279, 'admin-orders-status-completed', 'vi', 'Hoàn thành');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (280, 'admin-orders-status-shipping', 'vi', 'Đang giao');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (281, 'admin-orders-status-completed', 'en', 'Completed');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (282, 'admin-orders-status-shipping', 'en', 'Delivering');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (283, 'admin-orders-btn-update-status', 'vi', 'Cập Nhật Trạng Thái');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (284, 'admin-orders-status-da_huy', 'vi', 'Đã hủy');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (285, 'admin-orders-status-cho_xac_nhan_thanh_toan', 'vi', 'Chờ xác nhận thanh toán');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (286, 'admin-orders-btn-confirm-payment', 'vi', 'Xác Nhận Thanh Toán');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (287, 'admin-orders-btn-update-status', 'en', 'Update Status');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (288, 'admin-orders-status-da_huy', 'en', 'Canceled');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (289, 'admin-orders-status-cho_xac_nhan_thanh_toan', 'en', 'Pending payment');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (290, 'admin-orders-btn-confirm-payment', 'en', 'Payment Validation');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (291, 'admin-orders-status-da_thanh_toan', 'vi', 'Đã thanh toán');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (292, 'admin-orders-btn-recall', 'vi', 'Thu Hồi Đơn');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (293, 'admin-orders-status-da_thanh_toan', 'en', 'Billed');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (294, 'admin-orders-btn-recall', 'en', 'Revoke Application');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (295, 'admin-orders-btn-approve-refund', 'vi', 'Duyệt Yêu Cầu Hoàn Tiền');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (296, 'admin-orders-btn-create-refund', 'vi', 'Tạo Yêu Cầu Hoàn Tiền');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (297, 'admin-orders-note-customer', 'vi', 'Lý do khách');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (298, 'admin-orders-status-yeu_cau_hoan_tien', 'vi', 'Đã yêu cầu hoàn trả');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (299, 'admin-orders-btn-approve-refund', 'en', 'Approve Refund Request');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (300, 'admin-orders-btn-create-refund', 'en', 'Create Refund Request');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (301, 'admin-orders-note-customer', 'en', 'Why guests');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (302, 'admin-orders-status-yeu_cau_hoan_tien', 'en', 'Return Request');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (303, 'admin-orders-btn-reject-refund', 'vi', 'Từ Chối Yêu Cầu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (304, 'admin-orders-btn-reject-refund', 'en', 'Turn down the request');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (305, 'admin-orders-note-admin', 'vi', 'Ghi chú admin');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (306, 'admin-orders-note-admin', 'en', 'Admin Notes');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (307, 'admin-orders-status-da_hoan_tien', 'vi', 'Đã hoàn tiền');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (308, 'admin-orders-status-da_hoan_tien', 'en', 'Refunded');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (309, 'admin-account-btn-add', 'vi', 'Thêm
                    Staff Mới');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (310, 'admin-account-form-title', 'vi', 'Thêm / Cập nhật Staff');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (311, 'admin-account-btn-add', 'en', 'Add
                    New Staff');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (312, 'admin-account-form-title', 'en', 'Add / Update Staff');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (313, 'admin-account-label-username', 'vi', 'Username');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (314, 'admin-account-label-username', 'en', 'Username');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (315, 'admin-account-label-email', 'vi', 'Email');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (316, 'admin-account-label-email', 'en', 'Email');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (317, 'admin-account-label-password', 'vi', 'Password');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (318, 'admin-account-label-phone', 'vi', 'Số điện thoại');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (320, 'admin-account-label-fullname', 'vi', 'Họ tên');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (327, 'admin-account-label-gender', 'en', 'Gender');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (334, 'admin-account-status-locked', 'vi', 'Khóa');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (335, 'admin-account-status-active', 'en', 'Activity');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (337, 'admin-account-btn-save', 'vi', 'Lưu Staff');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (340, 'admin-account-list-title', 'en', 'Staff List');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (343, 'admin-account-th-username', 'vi', 'Username');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (346, 'admin-account-th-email', 'en', 'Email');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (347, 'admin-account-th-fullname', 'vi', 'Họ tên');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (348, 'admin-account-th-fullname', 'en', 'Họ tên');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (349, 'admin-account-th-status', 'vi', 'Trạng thái');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (350, 'admin-account-th-status', 'en', 'Status');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (354, 'admin-account-btn-edit', 'vi', 'Sửa');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (355, 'admin-account-th-actions', 'en', 'Actions');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (360, 'admin-account-status-locked-badge', 'vi', 'Đã khoá');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (361, 'admin-account-btn-delete', 'en', 'Delete');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (363, 'admin-account-btn-unlock', 'vi', 'Mở
                                    khoá');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (364, 'admin-account-btn-unlock', 'en', 'Open
                                    lock');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (319, 'admin-account-label-password', 'en', 'Password');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (321, 'admin-account-label-phone', 'en', 'Telephone');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (322, 'admin-account-label-fullname', 'en', 'Họ tên');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (323, 'admin-account-label-address', 'vi', 'Địa chỉ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (324, 'admin-account-label-address', 'en', 'Address');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (325, 'admin-account-label-gender', 'vi', 'Giới tính');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (326, 'admin-account-gender-male', 'vi', 'Nam');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (328, 'admin-account-gender-male', 'en', 'Male');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (329, 'admin-account-gender-female', 'vi', 'Nữ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (330, 'admin-account-gender-female', 'en', 'Female');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (331, 'admin-account-label-status', 'vi', 'Trạng thái');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (332, 'admin-account-label-status', 'en', 'Status');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (333, 'admin-account-status-active', 'vi', 'Hoạt động');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (336, 'admin-account-status-locked', 'en', 'Khóa /Locks');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (344, 'admin-account-th-email', 'vi', 'Email');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (345, 'admin-account-th-username', 'en', 'Username');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (351, 'admin-account-th-phone', 'vi', 'SĐT');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (352, 'admin-account-th-phone', 'en', 'Tel.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (353, 'admin-account-th-actions', 'vi', 'Hành động');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (356, 'admin-account-btn-edit', 'en', 'Edit');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (357, 'admin-account-btn-lock', 'vi', 'Khoá');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (358, 'admin-account-btn-lock', 'en', 'L_ock');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (359, 'admin-account-btn-delete', 'vi', 'Xoá');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (362, 'admin-account-status-locked-badge', 'en', 'Locked');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (338, 'admin-account-list-title', 'vi', 'Danh sách Staff');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (339, 'admin-account-btn-save', 'en', 'Save Staff');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (341, 'admin-account-th-id', 'vi', 'ID');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (342, 'admin-account-th-id', 'en', 'ID');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (365, 'admin-tickets-stat-inprogress', 'vi', 'Đang xử lý');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (366, 'admin-tickets-stat-inprogress', 'en', 'Processing');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (367, 'admin-tickets-title', 'vi', 'Quản Lý Hỗ Trợ Khách Hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (368, 'admin-tickets-subtitle', 'vi', 'Xem và phản hồi các yêu cầu tư vấn, hỗ trợ từ khách hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (369, 'admin-tickets-title', 'en', 'Customer Support Management');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (370, 'admin-tickets-subtitle', 'en', 'View and respond to customer requests for advice and support');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (371, 'admin-tickets-stat-open', 'vi', 'Chờ xử lý');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (372, 'admin-tickets-stat-open', 'en', 'Pending');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (373, 'admin-tickets-filter-progress', 'vi', 'Đang xử lý');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (374, 'admin-tickets-filter-all', 'vi', 'Tất cả');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (375, 'admin-tickets-stat-total', 'vi', 'Tổng ticket');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (376, 'admin-tickets-filter-progress', 'en', 'Processing');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (377, 'admin-tickets-filter-open', 'vi', 'Mới / Chờ xử lý');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (378, 'admin-tickets-filter-all', 'en', 'All');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (379, 'admin-tickets-stat-total', 'en', 'Total Tickets');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (380, 'admin-tickets-filter-resolved', 'vi', 'Đã giải quyết');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (381, 'admin-tickets-filter-open', 'en', 'New / Pending');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (382, 'admin-tickets-filter-resolved', 'en', 'Resolved?');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (383, 'admin-tickets-filter-closed', 'vi', 'Đóng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (384, 'admin-tickets-status-in_progress', 'vi', 'Đang xử lý');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (385, 'admin-tickets-filter-closed', 'en', 'CLOSE');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (386, 'admin-tickets-sec-cust-info', 'vi', 'Thông tin khách hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (387, 'admin-tickets-status-in_progress', 'en', 'Processing');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (388, 'admin-tickets-label-name', 'vi', 'Họ tên:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (389, 'admin-tickets-cat-general', 'vi', '💬 Chung');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (390, 'admin-tickets-sec-cust-info', 'en', 'Customer information');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (391, 'admin-tickets-label-name', 'en', 'Full name:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (392, 'admin-tickets-cat-general', 'en', 'Joint');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (393, 'admin-tickets-label-email', 'vi', 'Email:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (394, 'admin-tickets-label-phone', 'vi', 'SĐT:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (395, 'admin-tickets-label-email', 'en', 'Email:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (396, 'admin-tickets-label-assignee', 'vi', 'Phụ trách:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (397, 'admin-tickets-label-phone', 'en', 'Tel.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (398, 'admin-tickets-label-assignee', 'en', 'Person-in-charge');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (399, 'admin-tickets-sec-req-content', 'vi', 'Nội dung yêu cầu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (400, 'admin-tickets-btn-assign', 'vi', 'Nhận hỗ trợ ticket này');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (401, 'admin-tickets-sec-req-content', 'en', 'Content of requirements');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (402, 'admin-tickets-btn-assign', 'en', 'Get this ticket support');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (403, 'admin-tickets-sec-chat', 'vi', 'Trò chuyện trực tuyến');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (404, 'admin-tickets-chat-loading', 'vi', 'Đang tải tin nhắn...');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (405, 'admin-tickets-sec-chat', 'en', 'Online chat');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (406, 'admin-tickets-chat-loading', 'en', 'Loading messages.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (407, 'admin-tickets-label-status-chat', 'vi', 'Trạng thái:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (408, 'admin-tickets-label-status-chat', 'en', 'Status:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (409, 'admin-tickets-opt-progress', 'vi', 'Đang xử lý');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (410, 'admin-tickets-opt-progress', 'en', 'Processing');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (411, 'admin-tickets-opt-resolved', 'vi', 'Đã giải quyết');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (412, 'admin-tickets-opt-open', 'vi', 'Mới (Open)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (413, 'admin-tickets-opt-closed', 'vi', 'Đóng ticket');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (414, 'admin-tickets-opt-resolved', 'en', 'Resolved?');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (415, 'admin-tickets-opt-open', 'en', 'New (Open)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (416, 'admin-tickets-opt-closed', 'en', 'Close Ticket');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (417, 'admin-tickets-btn-send', 'vi', 'Gửi');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (418, 'admin-tickets-btn-send', 'en', 'Send');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (419, 'admin-tickets-btn-delete', 'vi', 'Xóa ticket');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (420, 'admin-tickets-btn-delete', 'en', 'Delete Ticket');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (421, 'admin-tickets-status-closed', 'vi', 'Đã đóng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (422, 'admin-tickets-status-closed', 'en', 'Closed');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (423, 'admin-flashsales-status-upcoming', 'vi', 'Sắp diễn ra');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (424, 'admin-flashsales-status-upcoming', 'en', 'Upcoming');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (425, 'admin-flashitems-title', 'vi', 'Sản Phẩm Flash Sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (426, 'admin-flashitems-title', 'en', 'Flash Sale Products');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (427, 'admin-flashitems-back', 'vi', 'Quay lại danh sách Flash Sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (428, 'admin-flashitems-back', 'en', 'Back to Flash Sale list');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (429, 'admin-flashitems-form-title', 'vi', 'Thêm Sản Phẩm Vào Flash Sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (430, 'admin-flashitems-form-title', 'en', 'Add Products to Flash Sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (431, 'admin-flashitems-label-product', 'vi', 'Sản Phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (432, 'admin-flashitems-label-product', 'en', 'Products');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (433, 'admin-flashitems-program', 'vi', 'Chương trình');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (434, 'admin-flashitems-to', 'vi', 'đến');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (435, 'admin-flashitems-option-select-product', 'vi', '-- Chọn sản phẩm --');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (436, 'admin-flashitems-program', 'en', 'Agenda');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (437, 'admin-flashitems-to', 'en', 'Tet comes spring');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (438, 'admin-flashitems-option-select-product', 'en', 'Select Products');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (439, 'admin-flashitems-label-qty', 'vi', 'Số Lượng Sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (440, 'admin-flashitems-label-price', 'vi', 'Giá Sale (₫)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (441, 'admin-flashitems-label-qty', 'en', 'QUANTITY');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (442, 'admin-flashitems-label-price', 'en', 'Price for sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (443, 'admin-flashitems-btn-add', 'vi', 'Thêm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (444, 'admin-flashitems-empty', 'vi', 'Chưa có sản phẩm nào trong chương trình này. Thêm sản phẩm ở form bên trên.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (445, 'admin-flashitems-list-title', 'vi', 'Sản Phẩm Trong Chương Trình');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (446, 'admin-flashitems-btn-add', 'en', 'More');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (447, 'admin-flashitems-empty', 'en', 'There are no products in this program yet. Add the product in the form above.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (448, 'admin-flashitems-list-title', 'en', 'In-Program Products');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (449, 'admin-flashitems-th-product', 'vi', 'Sản Phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (450, 'admin-flashitems-th-sold', 'vi', 'Đã Bán');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (451, 'admin-flashitems-th-discount', 'vi', 'Giảm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (452, 'admin-flashitems-th-product', 'en', 'Products');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (453, 'admin-flashitems-th-sold', 'en', 'sold');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (454, 'admin-flashitems-th-sale-price', 'vi', 'Giá Sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (455, 'admin-flashitems-th-original-price', 'vi', 'Giá Gốc');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (456, 'admin-flashitems-th-discount', 'en', 'Decrease');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (457, 'admin-flashitems-th-sale-price', 'en', 'Price for sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (458, 'admin-flashitems-th-original-price', 'en', 'Base Price');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (459, 'admin-flashitems-text-sold', 'vi', 'đã bán');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (460, 'admin-flashitems-th-progress', 'vi', 'Tiến Trình');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (461, 'admin-flashitems-th-actions', 'vi', 'Hành Động');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (462, 'admin-flashitems-th-progress', 'en', 'Progress');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (464, 'admin-flashitems-btn-delete', 'vi', 'Xóa');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (465, 'admin-flashitems-th-actions', 'en', 'Action');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (466, 'admin-flashitems-btn-delete', 'en', '[Delete]');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (467, 'admin-voucher-btn-toggle-on', 'vi', 'Bật');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (468, 'admin-common-inactive', 'vi', 'Tắt');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (469, 'admin-voucher-btn-toggle-on', 'en', 'Enable');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (470, 'admin-common-inactive', 'en', 'Off');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (471, 'admin-tickets-empty', 'vi', 'Chưa có ticket nào');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (472, 'admin-tickets-empty-desc', 'vi', 'Các yêu cầu tư vấn từ khách hàng sẽ xuất hiện ở đây');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (473, 'admin-tickets-empty', 'en', 'No tickets yet');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (474, 'admin-tickets-empty-desc', 'en', 'Client requests for advice will appear here');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (475, 'nav-news', 'vi', 'Tin Tức');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (476, 'nav-contact', 'vi', 'Liên Hệ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (477, 'nav-news', 'en', 'News');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (478, 'nav-contact', 'en', 'Contact Us');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (479, 'nav-products', 'vi', 'Sản Phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (480, 'nav-products', 'en', 'Products');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (481, 'nav-promo', 'vi', 'Khuyến
                    Mãi');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (482, 'nav-promo', 'en', 'Online Sales');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (483, 'nav-build', 'vi', 'Build PC Basic');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (484, 'nav-build', 'en', 'Build PC basic');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (485, 'nav-login', 'vi', 'ĐĂNG NHẬP');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (486, 'nav-login', 'en', 'LOGIN');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (487, 'search-quick', 'vi', 'Tìm nhanh:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (488, 'search-quick', 'en', 'Quick Search');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (489, 'hero-title-1', 'vi', 'Được Tạo Ra');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (490, 'search-hint', 'vi', 'Nhập từ khóa để tìm kiếm sản phẩm tại Luxury PC.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (491, 'hero-title-1', 'en', 'Created on');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (492, 'search-hint', 'en', 'Enter keywords to search for products at Luxury PC.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (493, 'hero-title-2', 'vi', 'Để Thống Trị');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (494, 'hero-subtitle', 'vi', 'Linh kiện máy tính được tuyển chọn dành cho những
                người không chấp nhận điều tầm thường.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (495, 'hero-title-2', 'en', 'To Dominate');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (496, 'hero-subtitle', 'en', 'Computer components selected for these
                who disapproves of mediocrity.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (497, 'hero-build', 'vi', 'Build PC Basic');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (498, 'hero-explore', 'vi', 'Khám Phá Ngay');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (499, 'hero-build', 'en', 'Build PC basic');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (500, 'hero-explore', 'en', 'Discover Now');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (501, 'flash-hot-deal', 'vi', '🔥 HOT DEAL');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (502, 'flash-hot-deal', 'en', '🔥 HOT DEAL');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (503, 'flash-today', 'vi', 'Hôm Nay');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (504, 'flash-today', 'en', 'Today');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (505, 'flash-sub', 'vi', 'Ưu đãi cực sốc — số lượng có hạn!');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (506, 'flash-sub', 'en', 'Shocking deal — limited availability!');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (507, 'promo-hour', 'vi', 'Giờ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (508, 'promo-hour', 'en', 'Hour(s)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (509, 'promo-minute', 'vi', 'Phút');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (510, 'promo-second', 'vi', 'Giây');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (511, 'promo-minute', 'en', 'Min');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (512, 'promo-second', 'en', 'Second:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (513, 'cat-desc-vga', 'vi', 'Card màn hình');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (514, 'cat-desc-cpu', 'vi', 'Bộ vi xử lý');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (515, 'cat-desc-vga', 'en', 'Video Card');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (516, 'cat-desc-cpu', 'en', 'process');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (517, 'statement-text', 'vi', '"Chúng tôi không bán linh kiện. Chúng tôi bán trải nghiệm hiệu năng vượt mọi giới hạn."');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (518, 'cat-section-label', 'vi', 'Danh Mục');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (519, 'statement-text', 'en', '"We don''t sell components. We sell a performance experience that pushes the boundaries.”');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (520, 'cat-section-label', 'en', 'Category');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (521, 'cat-desc-main', 'vi', 'Bo mạch chủ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (522, 'cat-desc-main', 'en', 'motherboard');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (523, 'promo-filter-all', 'vi', 'Tất Cả');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (524, 'promo-filter-all', 'en', 'All');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (525, 'voucher-section-label', 'vi', 'Ưu Đãi');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (526, 'build-feat-1-title', 'vi', 'Tư Vấn Miễn Phí');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (527, 'voucher-section-label', 'en', 'Online Sales');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (528, 'build-feat-1-title', 'en', 'Free Advising');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (529, 'footer-gaming', 'vi', 'PC Gaming Cao Cấp');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (530, 'build-section-title-em', 'vi', 'Theo Yêu Cầu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (531, 'footer-gaming', 'en', 'PC Gaming Premium');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (532, 'build-section-title-em', 'en', 'As required');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (533, 'auth-page-title', 'vi', 'Luxury PC — Đăng Nhập / Đăng Ký');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (534, 'newsletter-section-sub', 'vi', 'Đăng ký để nhận thông báo giảm giá, sản
                phẩm mới nhất và lời khuyên build PC từ chuyên gia.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (535, 'auth-page-title', 'en', 'Luxury PC — Login / Register');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (536, 'newsletter-section-sub', 'en', 'Sign up to receive discount alerts, product
                latest products and PC build tips from experts.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (537, 'auth-visual-tag', 'vi', 'Thành Viên Luxury PC');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (538, 'auth-visual-tag', 'en', 'Luxury PC Membership');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (539, 'auth-visual-title-join', 'vi', 'Gia Nhập');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (540, 'auth-visual-title-join', 'en', 'Sign Up');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (541, 'auth-visual-title-elite', 'vi', 'Đẳng Cấp');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (542, 'auth-visual-title-elite', 'en', 'LEVELS');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (543, 'auth-visual-sub', 'vi', 'Tạo tài khoản để nhận ưu đãi độc quyền, theo dõi đơn hàng và trải nghiệm dịch vụ hội viên cao
        cấp.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (544, 'auth-visual-sub', 'en', 'Create an account to receive exclusive offers, track orders, and get a high membership experience
        level.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (545, 'auth-perk-1', 'vi', 'Ưu đãi thành viên lên đến 20%');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (546, 'auth-perk-1', 'en', 'Membership deals up to 20% off');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (547, 'auth-perk-2', 'vi', 'Theo dõi đơn hàng thời gian thực');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (548, 'auth-perk-2', 'en', 'Sign Up for Real-time Tracking');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (549, 'auth-perk-3', 'vi', 'Tư vấn build PC ưu tiên 24/7');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (550, 'auth-perk-3', 'en', '24/7 Priority PC Build Advice');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (551, 'auth-perk-4', 'vi', 'Danh sách yêu thích cá nhân hóa');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (552, 'auth-perk-4', 'en', 'Wishlist Private');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (553, 'auth-tab-login', 'vi', 'Đăng Nhập');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (554, 'auth-tab-login', 'en', 'Sign In');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (555, 'auth-tab-register', 'vi', 'Đăng Ký');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (556, 'auth-tab-register', 'en', 'Sign Up');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (557, 'auth-login-title', 'vi', 'Chào mừng trở lại');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (558, 'auth-login-title', 'en', 'Welcome Back');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (559, 'auth-login-sub', 'vi', 'Đăng nhập để tiếp tục trải nghiệm Luxury PC.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (560, 'auth-login-sub', 'en', 'Log in to continue the Luxury PC experience.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (561, 'auth-label-username', 'vi', 'Email hoặc Tên đăng nhập');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (562, 'auth-label-username', 'en', 'Email hoặc Tên đăng nhập');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (563, 'auth-error-username', 'vi', 'Vui lòng nhập thông tin đăng nhập.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (565, 'auth-label-password', 'vi', 'Mật khẩu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (564, 'auth-error-username', 'en', 'Please enter your credentials.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (566, 'auth-error-password', 'vi', 'Vui lòng nhập mật khẩu.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (568, 'auth-error-password', 'en', 'Please enter your password');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (569, 'auth-forgot-password', 'vi', 'Quên mật khẩu?');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (571, 'auth-forgot-password', 'en', 'Forgot your password?');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (573, 'auth-btn-login', 'vi', 'Đăng Nhập');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (574, 'auth-btn-login', 'en', 'Sign In');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (576, 'auth-register-title', 'vi', 'Tạo tài khoản');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (578, 'auth-register-title', 'en', 'Create Account');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (581, 'auth-label-lastname', 'vi', 'Họ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (582, 'auth-label-lastname', 'en', 'Last Name');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (585, 'auth-label-firstname', 'vi', 'Tên');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (586, 'auth-label-firstname', 'en', 'Name');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (589, 'auth-label-email', 'vi', 'Email');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (590, 'auth-label-email', 'en', 'Email');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (593, 'auth-label-phone', 'vi', 'Số điện thoại');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (594, 'auth-label-phone', 'en', 'Telephone');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (597, 'auth-error-reg-password', 'vi', 'Mật khẩu tối thiểu 8 ký tự.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (599, 'auth-error-reg-password', 'en', 'Passwords are required to be a minimum of 8 characters.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (601, 'auth-error-reg-password-confirm', 'vi', 'Mật khẩu không khớp.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (602, 'auth-error-reg-password-confirm', 'en', 'Passwords do not match.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (605, 'auth-label-otp', 'vi', 'Mã xác nhận (OTP)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (606, 'auth-label-otp', 'en', 'Confirmation code (OTP)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (609, 'auth-terms-text', 'vi', 'Tôi đồng ý với');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (610, 'auth-terms-text', 'en', 'I agree to');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (614, 'auth-terms-and', 'vi', 'và');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (616, 'auth-terms-and', 'en', 'and');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (617, 'auth-btn-register', 'vi', 'Tạo Tài Khoản');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (619, 'auth-btn-register', 'en', 'Create Account');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (621, 'auth-or', 'vi', 'hoặc');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (622, 'auth-or', 'en', 'or');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (567, 'auth-label-password', 'en', 'Password');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (570, 'auth-remember-me', 'vi', 'Ghi nhớ đăng nhập trong 30 ngày');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (572, 'auth-remember-me', 'en', 'Remember to log in for 30 days');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (575, 'auth-divider', 'vi', 'hoặc');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (577, 'auth-divider', 'en', 'or');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (579, 'auth-register-sub', 'vi', 'Điền thông tin để gia nhập cộng đồng Luxury PC.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (580, 'auth-register-sub', 'en', 'Fill out the information to join the Luxury PC community.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (583, 'auth-error-lastname', 'vi', 'Vui lòng nhập họ.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (584, 'auth-error-lastname', 'en', 'Please enter a last name.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (587, 'auth-error-firstname', 'vi', 'Vui lòng nhập tên.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (588, 'auth-error-firstname', 'en', 'Please enter a first name.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (591, 'auth-error-email', 'vi', 'Vui lòng nhập email hợp lệ.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (592, 'auth-error-email', 'en', 'Please enter a valid email.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (595, 'auth-pw-strength-default', 'vi', 'Nhập mật khẩu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (596, 'auth-pw-strength-default', 'en', 'Enter password');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (598, 'auth-label-reg-password-confirm', 'vi', 'Xác nhận mật khẩu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (600, 'auth-label-reg-password-confirm', 'en', 'Confirm Password');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (603, 'auth-label-invite', 'vi', 'Mã giới thiệu (Nếu có)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (604, 'auth-label-invite', 'en', 'Referral Code (If applicable)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (607, 'auth-btn-send-otp', 'vi', 'Gửi Mã');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (608, 'auth-btn-send-otp', 'en', 'Send Code');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (611, 'auth-terms-link', 'vi', 'Điều khoản dịch vụ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (612, 'auth-terms-link', 'en', 'Terms of Service');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (613, 'auth-privacy-link', 'vi', 'Chính sách bảo mật');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (615, 'auth-privacy-link', 'en', 'Security policy');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (618, 'auth-terms-of', 'vi', 'của Luxury PC');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (620, 'auth-terms-of', 'en', 'by Luxury PC');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (624, 'cat-section-title', 'vi', 'Chọn Dòng Linh Kiện');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (623, 'cat-desc-ram', 'vi', 'Bộ nhớ trong');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (625, 'cat-desc-ram', 'en', 'Internal storage Port');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (626, 'cat-section-title', 'en', 'Select Component Line');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (627, 'cat-desc-ssd', 'vi', 'Lưu trữ cao tốc');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (628, 'cat-desc-ssd', 'en', 'Express Storage');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (629, 'cat-desc-monitor', 'vi', 'Display premium');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (630, 'cat-desc-monitor', 'en', 'Display premium');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (631, 'featured-section-label', 'vi', 'Tuyển Chọn');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (632, 'featured-section-label', 'en', 'selection of them');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (633, 'featured-section-title', 'vi', 'Linh Kiện Nổi Bật');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (634, 'featured-section-title', 'en', 'Featured Components');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (635, 'products-filter-category', 'vi', 'Danh Mục');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (636, 'products-filter-category', 'en', 'Category');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (637, 'cat-monitor', 'vi', 'Màn
                        Hình');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (638, 'cat-monitor', 'en', 'Display');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (639, 'filter-sort-label', 'vi', 'Sắp Xếp');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (640, 'filter-sort-label', 'en', 'Prepare books');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (641, 'sort-default', 'vi', 'Mặc Định');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (642, 'sort-default', 'en', 'DEFLT.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (643, 'sort-price-asc', 'vi', 'Giá: Thấp → Cao');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (644, 'sort-price-asc', 'en', 'Price (Lo-Hi)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (645, 'sort-price-desc', 'vi', 'Giá: Cao → Thấp');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (646, 'sort-price-desc', 'en', 'Price (Hi-Lo)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (647, 'sort-popular', 'vi', 'Mua Nhiều Nhất');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (648, 'sort-popular', 'en', 'Best Sellers');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (649, 'sort-newest', 'vi', 'Mới Nhất');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (650, 'sort-newest', 'en', 'Newest');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (651, 'result-count-label', 'vi', 'sản phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (652, 'result-count-label', 'en', 'products left');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (653, 'btn-add-cart-text', 'vi', 'Thêm Vào
                                Giỏ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (654, 'btn-add-cart-text', 'en', 'Add To Cart');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (655, 'badge-featured-gold', 'vi', 'Đỉnh Cao');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (656, 'badge-featured-gold', 'en', 'Pinnacle');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (657, 'voucher-section-title', 'vi', 'Mã Khuyến Mãi');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (658, 'voucher-section-title', 'en', 'Promo Codes');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (659, 'voucher-section-sub', 'vi', 'Nhấn vào voucher để xem chi tiết điều
                kiện và cách sử dụng.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (660, 'voucher-section-sub', 'en', 'Tap the voucher to see the details
                package and usage.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (661, 'Giảm Giá', 'vi', 'Giảm Giá');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (662, 'Giảm Giá', 'en', 'On Sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (663, 'Mainboard', 'vi', 'Mainboard');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (664, 'build-section-label', 'vi', 'Dịch Vụ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (665, 'Mainboard', 'en', 'Mainboard');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (666, 'build-section-label', 'en', 'Service');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (667, 'build-section-desc', 'vi', 'Đội ngũ chuyên gia của Luxury PC sẽ tư vấn và lắp ráp hệ thống hoàn hảo nhất dành riêng cho bạn — từ
                workstation đồ họa đến chiến mã gaming không đối thủ.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (668, 'build-feat-1-desc', 'vi', 'Chuyên gia phân tích nhu cầu của bạn');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (669, 'build-section-desc', 'en', 'Luxury PC''s team of experts will advise and assemble the most perfect system just for you — from
                graphical workstation to unrivaled gaming steeds.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (670, 'build-feat-1-desc', 'en', 'Your Needs Analyst');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (671, 'build-feat-2-title', 'vi', 'Lắp Ráp Chuyên Nghiệp');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (672, 'build-feat-2-desc', 'vi', 'Lắp ráp trong phòng sạch, kiểm tra 100%');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (673, 'build-feat-2-title', 'en', 'Professional Assembly');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (674, 'build-feat-2-desc', 'en', 'Cleanroom assembly, 100% inspection');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (675, 'build-feat-3-title', 'vi', 'Bảo Hành 3 Năm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (676, 'build-feat-3-desc', 'vi', 'Cam kết chất lượng đẳng cấp hàng đầu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (677, 'build-feat-3-title', 'en', '3 Years Warranty');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (678, 'build-feat-3-desc', 'en', 'Commitment to top-class quality');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (679, 'build-section-cta', 'vi', 'Bắt Đầu Build Ngay');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (680, 'build-section-cta', 'en', 'Start Build Now');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (681, 'stat-customers', 'vi', 'Khách Hàng Tin Tưởng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (682, 'stat-customers', 'en', 'Customers Trust');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (683, 'stat-components', 'vi', 'Linh Kiện Chính Hãng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (684, 'stat-experience', 'vi', 'Năm Kinh Nghiệm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (685, 'stat-components', 'en', 'Genuine Components');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (686, 'stat-experience', 'en', 'Years of experience:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (687, 'stat-satisfaction', 'vi', '% Khách Hàng Hài Lòng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (688, 'stat-satisfaction', 'en', 'Satisfied Customers');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (689, 'review-section-label', 'vi', 'Đánh Giá');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (690, 'review-section-label', 'en', 'User Reviews');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (691, 'review-section-title', 'vi', 'Khách Hàng Nói Gì');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (692, 'newsletter-section-title', 'vi', 'Nhận Ưu Đãi Độc Quyền');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (693, 'review-section-title', 'en', 'Client''s Testimonials');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (694, 'newsletter-section-title', 'en', 'Exclusive Offer');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (695, 'newsletter-submit-btn', 'vi', 'Đăng Ký');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (697, 'newsletter-submit-btn', 'en', 'Sign Up');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (701, 'footer-h-components', 'vi', 'Linh Kiện');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (702, 'footer-h-components', 'en', 'Spare Parts');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (705, 'footer-main', 'vi', 'Mainboard');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (706, 'footer-main', 'en', 'Mainboard');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (709, 'footer-ssd', 'vi', 'SSD & Lưu Trữ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (710, 'footer-ssd', 'en', 'SSD & Storage');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (712, 'footer-build', 'vi', 'Build PC Theo Yêu Cầu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (714, 'footer-build', 'en', 'Build PC On Demand');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (717, 'footer-warranty', 'vi', 'Bảo Hành & Sửa Chữa');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (718, 'footer-warranty', 'en', 'FOR WARRANTY RECORD');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (721, 'footer-h-contact', 'vi', 'Liên Hệ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (722, 'footer-h-contact', 'en', 'Contact Us');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (725, 'cart-title', 'vi', 'Giỏ Hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (726, 'cart-title', 'en', 'Shopping Cart');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (730, 'cart-total-label', 'vi', 'Tổng cộng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (732, 'cart-total-label', 'en', 'Total');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (733, 'voucher-benefit', 'vi', 'Ưu đãi');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (735, 'voucher-benefit', 'en', 'Promotion');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (737, 'voucher-apply', 'vi', 'Áp dụng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (738, 'voucher-apply', 'en', 'Applied to');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (741, 'voucher-usage', 'vi', 'Lượt dùng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (743, 'voucher-usage', 'en', 'Uses');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (745, 'voucher-note', 'vi', 'Nhập mã tại bước thanh toán để áp dụng ưu đãi.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (746, 'voucher-note', 'en', 'Enter the code at checkout to apply the offer.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (696, 'footer-desc', 'vi', 'Nơi công nghệ gặp gỡ sự xa xỉ. Linh kiện cao cấp, tư vấn chuyên nghiệp, dịch vụ hoàn hảo.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (698, 'footer-desc', 'en', 'Where technology meets luxury. High-class components, professional advice, perfect service.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (699, 'footer-cpu', 'vi', 'CPU & Bộ Xử Lý');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (700, 'footer-cpu', 'en', 'CPU & Processor');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (703, 'footer-vga', 'vi', 'VGA & Card Đồ Họa');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (704, 'footer-vga', 'en', 'VGA & Graphic Cards');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (707, 'footer-ram', 'vi', 'RAM & Bộ Nhớ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (708, 'footer-ram', 'en', 'RAM(Memory)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (711, 'footer-h-services', 'vi', 'Dịch Vụ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (713, 'footer-h-services', 'en', 'Service');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (715, 'footer-advice', 'vi', 'Tư Vấn Cấu Hình');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (716, 'footer-advice', 'en', 'Configuration Consulting');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (719, 'footer-upgrade', 'vi', 'Nâng Cấp Hệ Thống');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (720, 'footer-upgrade', 'en', 'System Upgrade');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (723, 'footer-rights', 'vi', '© 2025 Luxury PC. Tất cả quyền được bảo lưu. Bản quyền thuộc Luxury Technology JSC.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (724, 'footer-rights', 'en', '© 2025 Luxury PC. All rights reserved. Copyright by Luxury Technology JSC.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (727, 'cart-empty', 'vi', 'Giỏ hàng của bạn đang trống.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (728, 'cart-empty', 'en', 'Your cart is currently empty.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (729, 'cart-checkout', 'vi', 'Thanh Toán Ngay');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (731, 'cart-checkout', 'en', 'Pay Full Amount');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (734, 'voucher-code-label', 'vi', 'Mã Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (736, 'voucher-code-label', 'en', 'Voucher Code');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (739, 'voucher-expiry', 'vi', 'Thời hạn');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (740, 'voucher-expiry', 'en', 'Term');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (742, 'voucher-copy', 'vi', 'Sao Chép Mã Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (744, 'voucher-copy', 'en', 'Copy Voucher Code');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (747, 'footer-chatbot-label', 'vi', 'Hỗ trợ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (748, 'footer-chatbot-label', 'en', 'Support');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (749, 'nav-profile', 'vi', 'HỒ SƠ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (750, 'nav-profile', 'en', 'Profile');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (751, 'profile-title-page', 'vi', 'Luxury PC — Hồ Sơ Cá Nhân');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (752, 'profile-rank-new', 'vi', 'Thành viên mới');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (753, 'profile-title-page', 'en', 'Luxury PC — Personal Profile');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (754, 'profile-rank-new', 'en', 'New users');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (755, 'profile-menu-info', 'vi', 'Thông Tin Cá Nhân');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (756, 'profile-menu-info', 'en', 'Personal Information');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (757, 'profile-menu-account-section', 'vi', 'Tài khoản');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (758, 'profile-menu-account-section', 'en', 'Account');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (759, 'profile-menu-orders', 'vi', 'Đơn Hàng Của Tôi');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (760, 'profile-menu-orders', 'en', 'My Orders');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (761, 'profile-menu-vouchers', 'vi', 'Ví Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (762, 'profile-menu-vouchers', 'en', 'Voucher Wallet');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (763, 'profile-menu-wishlist', 'vi', 'Danh Sách Yêu Thích');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (764, 'profile-menu-wishlist', 'en', 'Wishlist');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (765, 'profile-menu-settings-section', 'vi', 'Cài đặt');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (766, 'profile-menu-settings-section', 'en', 'Installation');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (767, 'profile-menu-security', 'vi', 'Bảo Mật');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (768, 'profile-menu-security', 'en', 'CONFIDENTIALITY');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (769, 'profile-menu-address', 'vi', 'Địa Chỉ Giao Hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (770, 'profile-menu-notifications', 'vi', 'Thông Báo');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (771, 'profile-menu-address', 'en', 'Billing Address');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (772, 'profile-menu-notifications', 'en', 'Notice');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (773, 'profile-btn-logout', 'vi', 'Đăng Xuất');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (774, 'profile-btn-logout', 'en', 'Log out');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (775, 'profile-tab-info', 'vi', 'Thông Tin');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (776, 'profile-tab-orders', 'vi', 'Đơn Hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (777, 'profile-tab-info', 'en', 'Thông Tin');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (778, 'profile-tab-orders', 'en', 'Orders');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (779, 'profile-tab-vouchers', 'vi', 'Ví Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (780, 'profile-tab-vouchers', 'en', 'Voucher Wallet');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (781, 'profile-tab-wishlist', 'vi', 'Yêu Thích');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (782, 'profile-tab-wishlist', 'en', 'Wishlist');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (783, 'profile-tab-security', 'vi', 'Bảo Mật');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (784, 'profile-tab-security', 'en', 'CONFIDENTIALITY');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (785, 'profile-tab-address', 'vi', 'Địa Chỉ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (786, 'profile-tab-address', 'en', 'Source of Address');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (787, 'profile-info-stat-spent', 'vi', 'Tổng chi tiêu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (788, 'profile-info-stat-spent', 'en', 'Total expenditures');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (789, 'profile-btn-edit', 'vi', 'Chỉnh Sửa');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (790, 'profile-btn-edit', 'en', 'Corrections');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (791, 'profile-info-stat-rank', 'vi', 'Hạng thành viên');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (792, 'profile-info-stat-rank', 'en', 'Member Ranking');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (793, 'profile-notif-order-sub', 'vi', 'Nhận thông báo khi trạng thái đơn hàng thay đổi');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (794, 'profile-notif-order-sub', 'en', 'Get notified when order status changes');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (795, 'profile-notif-order-title', 'vi', 'Cập nhật đơn hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (796, 'profile-notif-order-title', 'en', 'Update Cart');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (797, 'profile-form-header', 'vi', 'Cập Nhật Thông Tin');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (798, 'profile-form-header', 'en', 'Update Information');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (799, 'profile-info-rank-sub', 'vi', 'Dựa trên tổng mức chi tiêu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (800, 'profile-info-rank-sub', 'en', 'Based on total spend');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (801, 'promo-hero-title-1', 'vi', 'Ưu Đãi Bùng Nổ');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (802, 'promo-page-title', 'vi', 'Khuyến Mãi & Voucher | Luxury PC');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (803, 'promo-hero-title-1', 'en', 'Explosion Incentives');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (804, 'promo-page-title', 'en', 'Promotions & Vouchers | Luxury PC');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (805, 'promo-hero-title-2', 'vi', 'Giảm Đến 50%');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (806, 'promo-hero-badge', 'vi', '🔥 Siêu Sale Tháng 6');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (807, 'promo-hero-title-2', 'en', 'up to 50% off');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (808, 'promo-hero-badge', 'en', 'June 🔥 Super Sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (809, 'promo-hero-cta', 'vi', 'Săn Voucher Ngay');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (810, 'promo-hero-sub', 'vi', 'Săn voucher, chớp deal sốc — hàng trăm linh kiện cao cấp đang chờ bạn với giá không tưởng. Chỉ có tại Luxury PC!');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (811, 'promo-hero-cta', 'en', 'Hunt Vouchers Now');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (812, 'promo-hero-sub', 'en', 'Voucher hunting, shock deals — hundreds of high-end components are waiting for you at unbelievable prices. Only at Luxury PC!');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (813, 'promo-deal-vga', 'vi', 'VGA & CPU Giảm 25%');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (814, 'promo-tag-gaming', 'vi', '🎮 Gaming Week');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (815, 'promo-deal-vga', 'en', 'VGA & CPU 25% off');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (816, 'promo-tag-gaming', 'en', '🎮 Gaming Week');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (817, 'promo-tag-freeship', 'vi', '🚚 Free Ship');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (818, 'promo-cta-view', 'vi', 'Xem Ngay →');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (819, 'promo-tag-freeship', 'en', 'tàu của nước trung lập (trong chiến tranh)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (820, 'promo-cta-view', 'en', 'Go Live With');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (821, 'promo-cta-apply', 'vi', 'Áp Dụng →');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (822, 'promo-deal-freeship', 'vi', 'Miễn Phí Vận Chuyển Toàn Quốc');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (824, 'promo-deal-freeship', 'en', '- Free shipping nationwide');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (827, 'promo-deal-vip', 'vi', 'Ưu Đãi Độc Quyền Thành Viên');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (828, 'promo-deal-vip', 'en', 'Exclusive Membership Offer');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (831, 'promo-cat-title', 'vi', 'Danh Mục Khuyến Mãi');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (832, 'promo-cat-title', 'en', 'Promotion Categories');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (835, 'promo-deal-upto', 'vi', 'Giảm đến');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (837, 'promo-deal-upto', 'en', 'Discount Rate');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (839, 'promo-voucher-today', 'vi', 'Mã Giảm Giá Hôm Nay');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (841, 'promo-voucher-today', 'en', 'Today''s Discount Codes');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (845, 'promo-filter-freeship', 'vi', 'Free Ship');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (846, 'promo-filter-freeship', 'en', 'tàu của nước trung lập (trong chiến tranh)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (849, 'promo-usage-text', 'vi', 'Đã dùng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (851, 'promo-usage-text', 'en', 'Occupied');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (853, 'promo-my-vouchers', 'vi', '💰 Ví Voucher Của Tôi');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (855, 'promo-my-vouchers', 'en', '💰 My Voucher Wallet');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (857, 'promo-vouchers-empty', 'vi', 'Bạn chưa lưu voucher nào. Hãy chọn "Lưu" ở các voucher bên trên!');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (858, 'promo-vouchers-empty', 'en', 'You haven''t saved any vouchers yet. Please select "Save" in the vouchers above!');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (861, 'promo-guide-title', 'vi', 'Cách Sử Dụng Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (863, 'promo-guide-title', 'en', 'How to Use Vouchers');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (865, 'promo-guide-step1-desc', 'vi', 'Chọn voucher phù hợp và nhấn "Lưu" để thêm vào ví voucher của bạn.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (867, 'promo-guide-step1-desc', 'en', 'Select the appropriate voucher and press "Save" to add it to your voucher wallet.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (875, 'promo-guide-step4-title', 'vi', 'Bước 4: Nhận Hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (877, 'promo-guide-step4-title', 'en', 'Step 4: Receive Goods');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (879, 'newsletter-title-part1', 'vi', 'Nhận Ưu Đãi');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (880, 'newsletter-title-part1', 'en', 'Newsletter');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (883, 'promo-newsletter-sub', 'vi', 'Đăng ký để nhận thông báo giảm giá, voucher mới nhất và deal sốc từ Luxury PC.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (884, 'promo-newsletter-sub', 'en', 'Sign up to receive discount alerts, the latest vouchers, and shocking deals from Luxury PC.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (887, 'all-products-page-title', 'vi', 'Luxury PC | Tất Cả Sản Phẩm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (888, 'all-products-page-title', 'en', 'Luxury PC | All Products');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (889, 'products-filter-all-cats', 'vi', 'Tất Cả Danh Mục');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (891, 'products-filter-all-cats', 'en', 'All Categories');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (894, 'products-filter-price', 'vi', 'Khoảng Giá');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (896, 'products-filter-price', 'en', 'Price Range:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (898, 'products-btn-reset', 'vi', 'Xóa Lọc');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (900, 'products-btn-reset', 'en', 'Clear');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (903, 'product-badge-premium', 'vi', 'Premium');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (904, 'product-badge-premium', 'en', 'Premium');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (907, 'checkout-success-title', 'vi', 'ĐẶT HÀNG THÀNH CÔNG');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (909, 'checkout-success-title', 'en', 'Order Complete');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (912, 'checkout-success-desc', 'vi', 'Cảm ơn bạn đã lựa chọn
      Luxury PC. Mã đơn hàng đã được ghi nhận!');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (914, 'checkout-success-desc', 'en', 'Thank you for choosing
      Luxury PC. Order number is recorded!');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (916, 'checkout-step-2', 'vi', 'Thông tin');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (918, 'checkout-step-2', 'en', 'Communication');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (919, 'checkout-info-step', 'vi', 'Bước 2');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (921, 'checkout-info-step', 'en', 'Step 2.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (923, 'checkout-label-fullname', 'vi', 'Họ và Tên');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (925, 'checkout-label-fullname', 'en', 'Fullname');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (927, 'checkout-label-phone', 'vi', 'Số điện thoại');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (929, 'checkout-label-phone', 'en', 'Telephone');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (932, 'checkout-label-voucher', 'vi', 'Ví Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (934, 'checkout-label-voucher', 'en', 'Voucher Wallet');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (936, 'checkout-pay-step', 'vi', 'Bước 3');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (938, 'checkout-pay-step', 'en', 'Step 3.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (941, 'checkout-pay-cod-title', 'vi', 'Thanh toán khi nhận hàng (COD)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (942, 'checkout-pay-cod-title', 'en', 'Cash on Delivery (COD)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (944, 'checkout-pay-inst-title', 'vi', 'Thanh toán trả góp (0%)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (946, 'checkout-pay-inst-title', 'en', 'Installment payment;');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (948, 'checkout-pay-inst-bank-label', 'vi', 'Chọn ngân hàng
              liên kết');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (950, 'checkout-pay-inst-bank-label', 'en', 'Select a bank
              link');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (953, 'checkout-pay-inst-monthly-label', 'vi', 'Góp mỗi tháng:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (954, 'checkout-pay-inst-monthly-label', 'en', 'Contributions per month:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (956, 'checkout-pay-vietqr-title', 'vi', 'Chuyển khoản ngân hàng qua
                VietQR');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (958, 'checkout-pay-vietqr-title', 'en', 'Bank transfer via
                VietQR');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (961, 'checkout-btn-back', 'vi', 'Quay lại');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (962, 'checkout-btn-back', 'en', 'Revert');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (963, 'checkout-btn-confirm-order', 'vi', '🔒 Xác Nhận Đặt
              Hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (964, 'checkout-btn-confirm-order', 'en', 'Review Your Order');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (965, 'checkout-summary-qty', 'vi', 'Số lượng:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (967, 'checkout-summary-qty', 'en', 'Quantity:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (969, 'checkout-summary-subtotal', 'vi', 'Tạm
            tính');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (971, 'checkout-summary-subtotal', 'en', 'Estimated');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (973, 'checkout-summary-shipping-val', 'vi', 'Miễn phí');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (974, 'checkout-summary-shipping-val', 'en', 'Free');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (823, 'promo-cta-apply', 'en', 'Apply');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (825, 'promo-tag-vip', 'vi', '👑 VIP Member');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (826, 'promo-tag-vip', 'en', '👑 VIP Member');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (829, 'promo-cta-register', 'vi', 'Đăng Ký →');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (830, 'promo-cta-register', 'en', 'Sign Up');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (833, 'promo-cat-sub', 'vi', 'Ưu Đãi Theo Danh Mục');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (834, 'promo-cat-sub', 'en', 'Category Deals');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (836, 'promo-voucher-center', 'vi', '🎟️ Kho Voucher');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (838, 'promo-voucher-center', 'en', 'Voucher 🎟️ Warehouse');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (840, 'promo-filter-discount', 'vi', 'Giảm Giá');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (842, 'promo-filter-discount', 'en', 'On Sale');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (843, 'promo-filter-category', 'vi', 'Theo Danh Mục');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (844, 'promo-filter-category', 'en', 'By Category');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (847, 'profile-vouchers-expiry', 'vi', 'HSD:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (848, 'profile-vouchers-expiry', 'en', 'EXP:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (850, 'promo-save-btn', 'vi', 'Lưu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (852, 'promo-save-btn', 'en', 'Save');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (854, 'promo-vouchers-saved', 'vi', 'Voucher Đã Lưu');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (856, 'promo-vouchers-saved', 'en', 'Saved Vouchers');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (859, 'promo-guide-label', 'vi', 'Hướng Dẫn');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (860, 'promo-guide-label', 'en', 'Instructions');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (862, 'promo-guide-step1-title', 'vi', 'Bước 1: Lưu Mã');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (864, 'promo-guide-step1-title', 'en', 'Step 1: Save Code');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (866, 'promo-guide-step2-title', 'vi', 'Bước 2: Mua Sắm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (868, 'promo-guide-step2-title', 'en', 'Step 2: Shopping');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (869, 'promo-guide-step2-desc', 'vi', 'Chọn sản phẩm yêu thích và thêm vào giỏ hàng. Đảm bảo đạt điều kiện đơn hàng tối thiểu.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (870, 'promo-guide-step2-desc', 'en', 'Select your favorite products and add them to your cart. Ensure minimum order eligibility.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (871, 'promo-guide-step3-title', 'vi', 'Bước 3: Áp Dụng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (872, 'promo-guide-step3-title', 'en', 'Step 3: Apply');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (873, 'promo-guide-step3-desc', 'vi', 'Tại bước thanh toán, chọn voucher từ ví hoặc nhập mã để áp dụng giảm giá.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (874, 'promo-guide-step3-desc', 'en', 'At checkout, select a voucher from your wallet or enter a code to apply the discount.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (876, 'promo-guide-step4-desc', 'vi', 'Hoàn tất thanh toán và chờ nhận hàng. Tận hưởng linh kiện cao cấp với giá ưu đãi!');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (878, 'promo-guide-step4-desc', 'en', 'Complete payment and wait for pickup. Enjoy premium components at a discounted price!');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (881, 'newsletter-title-part2', 'vi', 'Độc Quyền');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (882, 'newsletter-title-part2', 'en', 'AMBIDEXTERITY');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (885, 'products-header-title', 'vi', 'Tất Cả Linh Kiện');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (886, 'products-header-title', 'en', 'All Components');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (890, 'products-header-label', 'vi', 'Luxury Collection');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (892, 'products-header-label', 'en', 'Luxury Collection');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (893, 'products-filter-search', 'vi', 'Tìm Kiếm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (895, 'products-filter-search', 'en', 'Search');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (897, 'products-btn-filter', 'vi', 'Áp Dụng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (899, 'products-btn-filter', 'en', 'Apply');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (901, 'product-btn-buy-now', 'vi', 'Mua Ngay');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (902, 'product-btn-buy-now', 'en', 'Buy Now');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (905, 'product-badge-outofstock', 'vi', 'Hết Hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (906, 'product-badge-outofstock', 'en', 'Exhausted Stock');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (908, 'checkout-page-title', 'vi', 'Luxury PC — Thanh Toán Đơn Hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (910, 'checkout-page-title', 'en', 'Luxury PC — Order Payment');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (911, 'checkout-btn-continue', 'vi', 'Tiếp tục mua sắm');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (913, 'checkout-btn-continue', 'en', 'Return to shop');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (915, 'checkout-step-1', 'vi', 'Giỏ hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (917, 'checkout-step-1', 'en', 'Cart');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (920, 'checkout-step-3', 'vi', 'Thanh toán');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (922, 'checkout-step-3', 'en', 'Payment terms');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (924, 'checkout-info-header', 'vi', 'Thông Tin Khách Hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (926, 'checkout-info-header', 'en', 'Customer information');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (928, 'checkout-label-address', 'vi', 'Địa
              chỉ nhận hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (930, 'checkout-label-address', 'en', 'Shipping Address');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (931, 'checkout-btn-apply-voucher', 'vi', 'Áp dụng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (933, 'checkout-btn-apply-voucher', 'en', 'Applied to');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (935, 'checkout-btn-next-payment', 'vi', 'Tiếp Theo: Thanh Toán →');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (937, 'checkout-btn-next-payment', 'en', 'Next: Payment →');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (939, 'checkout-pay-header', 'vi', 'Phương Thức Thanh Toán');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (940, 'checkout-pay-header', 'en', 'Withdrawal Method');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (943, 'checkout-pay-cod-desc', 'vi', 'Thanh toán
                bằng tiền mặt khi shipper giao hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (945, 'checkout-pay-cod-desc', 'en', 'Payment
                in cash on shipper delivery');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (947, 'checkout-pay-inst-desc', 'vi', 'Hỗ trợ thẻ
                tín dụng của hơn 20 ngân hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (949, 'checkout-pay-inst-desc', 'en', 'Tag Support
                credit of more than 20 banks');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (951, 'checkout-pay-inst-term-label', 'vi', 'Chọn kỳ hạn');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (952, 'checkout-pay-inst-term-label', 'en', 'Select Period');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (955, 'checkout-pay-inst-fee-label', 'vi', 'Chênh lệch phí:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (957, 'checkout-pay-inst-fee-label', 'en', 'Difference:');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (959, 'checkout-pay-vietqr-desc', 'vi', 'Quét mã QR
                để chuyển khoản đúng số tiền và mã đơn hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (960, 'checkout-pay-vietqr-desc', 'en', 'Scan QR code
                to transfer the correct amount and order number');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (966, 'checkout-summary-header', 'vi', 'Đơn Hàng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (968, 'checkout-summary-header', 'en', 'Orders');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (970, 'checkout-summary-shipping', 'vi', 'Vận
            chuyển');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (972, 'checkout-summary-shipping', 'en', 'Transportation');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (975, 'checkout-summary-total-label', 'vi', 'Tổng cộng');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (976, 'checkout-summary-total-label', 'en', 'Total');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (977, 'admin-tickets-delete-warning', 'vi', 'Hành động này không thể hoàn tác. Toàn bộ nội dung trò chuyện sẽ bị mất.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (978, 'admin-tickets-btn-delete-confirm', 'vi', 'Xóa ngay');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (979, 'admin-tickets-btn-cancel', 'vi', 'Hủy');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (980, 'admin-tickets-btn-delete-confirm', 'en', 'Use this spray paint.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (981, 'admin-tickets-delete-warning', 'en', 'This action cannot be undone. All chat content will be lost.');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (982, 'admin-tickets-btn-cancel', 'en', 'Cancel');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (983, 'admin-orders-status-cho_hoan_tien', 'vi', 'Chờ hoàn tiền');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (984, 'admin-orders-status-cho_hoan_tien', 'en', 'Wait for refund');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (985, 'admin-orders-btn-confirm-refunded', 'vi', 'Xác Nhận Đã Hoàn Tiền');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (986, 'admin-orders-btn-confirm-refunded', 'en', 'Xác Nhận Đã Hoàn Tiền (EN)');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (987, 'admin-tickets-status-open', 'vi', 'Mới');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (988, 'admin-tickets-btn-process', 'vi', 'Xử lý');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (989, 'admin-tickets-status-open', 'en', 'New');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (990, 'admin-tickets-btn-process', 'en', 'Processing');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (991, 'admin-flashsales-status-running', 'vi', 'Đang diễn ra');
INSERT INTO public."translations" ("id", "key", "lang", "value") VALUES (992, 'admin-flashsales-status-running', 'en', 'going');

-- Data for Name: news;
INSERT INTO public."news" ("id", "content", "created_at", "slug", "summary", "thumbnail", "title", "updated_at", "author_id", "meta_description", "meta_keywords", "meta_title", "view_count", "category_id", "status") VALUES (2, '<p>L&agrave;m việc nh&oacute;m tr&ecirc;n bảng t&iacute;nh trực tuyến thường gặp rủi ro bị ghi đ&egrave;, x&oacute;a nhầm dữ liệu hoặc sai số kh&ocirc;ng r&otilde; nguy&ecirc;n nh&acirc;n. T&igrave;nh trạng n&agrave;y khiến nhiều nh&acirc;n vi&ecirc;n văn ph&ograve;ng v&agrave; sinh vi&ecirc;n phải loay hoay t&igrave;m c&aacute;ch cứu file. B&agrave;i viết n&agrave;y sẽ hướng dẫn xem lịch sử chỉnh sửa tr&ecirc;n Google Sheet chi v&agrave; c&aacute;ch kh&ocirc;i phục dữ liệu đ&atilde; x&oacute;a tr&ecirc;n Google Sheets an to&agrave;n.</p>
<blockquote>
<div class="zone_sp_h2">&nbsp;</div>
<h2 data-index="1"><strong>Những điểm ch&iacute;nh</strong></h2>
<ul>
<li>Google Sheets cho ph&eacute;p xem lịch sử phi&ecirc;n bản to&agrave;n bộ trang t&iacute;nh v&agrave; lịch sử chỉnh sửa từng &ocirc; để theo d&otilde;i thay đổi ch&iacute;nh x&aacute;c.</li>
<li>Người d&ugrave;ng cần quyền chỉnh sửa để truy cập nhật k&yacute; phi&ecirc;n bản, đồng thời c&oacute; thể mở nhanh bằng ph&iacute;m tắt tr&ecirc;n Windows hoặc macOS.</li>
<li>Khi l&agrave;m việc với bảng t&iacute;nh lớn, n&ecirc;n sử dụng&nbsp;<a href="https://gearvn.com/collections/laptop" target="_blank" rel="noopener">laptop</a>&nbsp;c&oacute; RAM từ 16GB, CPU đa nh&acirc;n v&agrave; SSD để hạn chế giật lag, treo tr&igrave;nh duyệt.</li>
<li>Trước khi kh&ocirc;i phục dữ liệu, h&atilde;y tạo bản sao của tệp để đảm bảo an to&agrave;n v&agrave; tr&aacute;nh ảnh hưởng đến c&ocirc;ng việc của c&aacute;c th&agrave;nh vi&ecirc;n kh&aacute;c.</li>
</ul>
</blockquote>
<div class="zone_sp_h2">&nbsp;</div>
<h2 data-index="2"><strong>1. Hướng dẫn xem lại lịch sử phi&ecirc;n bản to&agrave;n trang t&iacute;nh</strong></h2>
<h3><strong>1.1. Xem lịch sử phi&ecirc;n bản Google Sheets bằng menu Tệp</strong></h3>
<p>Để xem được to&agrave;n bộ lịch sử chỉnh sửa, người d&ugrave;ng bắt buộc phải c&oacute; quyền chỉnh sửa đối với file đ&oacute;. T&iacute;nh năng n&agrave;y gi&uacute;p bạn kiểm so&aacute;t chi tiết ai đ&atilde; thao t&aacute;c v&agrave; v&agrave;o khoảng thời gian n&agrave;o.</p>
<ul>
<li><strong>Bước 1:</strong>&nbsp;Mở file<strong>&nbsp;Google Sheets</strong>&nbsp;cần kiểm tra.&nbsp;Tr&ecirc;n thanh c&ocirc;ng cụ, nhấn v&agrave;o mục&nbsp;<strong>Tệp</strong>, chọn&nbsp;<strong>Nhật k&yacute; phi&ecirc;n bản&nbsp;</strong>rồi v&agrave;o<strong>&nbsp;Xem nhật k&yacute; phi&ecirc;n bản</strong>.</li>
</ul>
<div>
<p><img src="https://cdn.hstatic.net/files/200000722513/file/ich-su-chinh-sua-tren-google-sheets-1_cd342bd0df78458592464b3d0bd8ca66_1024x1024.png" alt="V&agrave;o mục Tệp, chọn Nhật k&yacute; phi&ecirc;n bản"></p>
<em>V&agrave;o mục Tệp, chọn Nhật k&yacute; phi&ecirc;n bản</em></div>
<ul>
<li><strong>Bước 2:</strong>&nbsp;Ngay lập tức, giao diện sẽ hiển thị danh s&aacute;ch lịch sử chỉnh sửa nội dung Google Sheets. Trong đ&oacute; bao gồm cả những th&ocirc;ng tin chi tiết về những lần chỉnh sửa, thời gian v&agrave; người thay đổi nội dung.</li>
</ul>
<div>
<p><img src="https://cdn.hstatic.net/files/200000722513/file/ich-su-chinh-sua-tren-google-sheets-2_67fe8120566a4f6db80a0e37847de225_1024x1024.png" alt="Ngay lập tức, giao diện sẽ hiển thị danh s&aacute;ch lịch sử chỉnh sửa"></p>
<em>Ngay lập tức, giao diện sẽ hiển thị danh s&aacute;ch lịch sử chỉnh sửa</em></div>
<h3><strong>1.2. Xem lịch sử phi&ecirc;n bản Google Sheets bằng ph&iacute;m tắt</strong></h3>
<p>Thay v&igrave; d&ugrave;ng chuột, bạn c&oacute; thể d&ugrave;ng ph&iacute;m tắt xem lịch sử phi&ecirc;n bản Google Sheets để mở nhanh bảng điều khiển:</p>
<ul>
<li><strong>Tr&ecirc;n Windows:&nbsp;</strong>Nhấn tổ hợp ph&iacute;m Ctrl + Alt + Shift + H.</li>
<li><strong>Tr&ecirc;n Mac OS:&nbsp;</strong>Nhấn tổ hợp ph&iacute;m Cmd + Alt + Shift + H.</li>
</ul>
<div>
<p><img src="https://cdn.hstatic.net/files/200000722513/file/ich-su-chinh-sua-tren-google-sheets-3_7527043f8a804fdcaef043857a8a64ce_1024x1024.jpg" alt="Nhấn tổ hợp ph&iacute;m Cmd + Alt + Shift + H tr&ecirc;n MacOS"></p>
<em>Nhấn tổ hợp ph&iacute;m Cmd + Alt + Shift + H tr&ecirc;n MacOS</em></div>
<div class="zone_sp_h2">&nbsp;</div>
<h2 data-index="3"><strong>2. C&aacute;ch xem lịch sử chỉnh sửa của một &ocirc; dữ liệu cụ thể</strong></h2>
<p>Xem lịch sử &ocirc; l&agrave; t&iacute;nh năng cho ph&eacute;p kiểm tra nhanh theo thời gian thực để biết ch&iacute;nh x&aacute;c ai đ&atilde; thay đổi dữ liệu tại một vị tr&iacute; duy nhất. C&aacute;ch xem ai đ&atilde; chỉnh sửa &ocirc; trong Google Sheets n&agrave;y gi&uacute;p bạn kh&ocirc;ng phải d&ograve; t&igrave;m to&agrave;n bộ file khi chỉ c&oacute; một v&agrave;i con số bị sai lệch.</p>
<ul>
<li><strong>Bước 1:&nbsp;</strong>Tại file Excel tr&ecirc;n Google Sheets, bạn h&atilde;y nhấn chọn v&agrave;o &ocirc; dữ liệu m&agrave; m&igrave;nh muốn xem lịch sử chỉnh sửa trước đ&oacute;.</li>
</ul>
<div>
<p><img src="https://cdn.hstatic.net/files/200000722513/file/ich-su-chinh-sua-tren-google-sheets-4_0f906ee09f604576803f2b1c9660346a_1024x1024.png" alt="H&atilde;y nhấn chọn v&agrave;o &ocirc; dữ liệu m&agrave; m&igrave;nh muốn xem lịch sử"></p>
<em>H&atilde;y nhấn chọn v&agrave;o &ocirc; dữ liệu m&agrave; m&igrave;nh muốn xem lịch sử</em></div>
<ul>
<li><strong>Bước 2:&nbsp;</strong>Click v&agrave;o&nbsp;<strong>chuột phải</strong>&nbsp;v&agrave; nhấn chọn mục&nbsp;<strong>Hiển thị lịch sử chỉnh sửa</strong>.</li>
</ul>
<div>
<p><img src="https://cdn.hstatic.net/files/200000722513/file/ich-su-chinh-sua-tren-google-sheets-5_db8be55c96e84ca79d610450f3626f3d_1024x1024.png" alt="Chọn mục Hiển thị lịch sử chỉnh sửa"></p>
<em>Chọn mục Hiển thị lịch sử chỉnh sửa</em></div>
<ul>
<li><strong>Bước 3:&nbsp;</strong>Ngay lập tức, lịch sử chỉnh sửa của &ocirc; dữ liệu đ&atilde; được hiển thị.</li>
</ul>
<div>
<p><img src="https://cdn.hstatic.net/files/200000722513/file/ich-su-chinh-sua-tren-google-sheets-6_76a87156d7b14120883ed8ca41a1d665_1024x1024.png" alt="Lịch sử chỉnh sửa của &ocirc; dữ liệu đ&atilde; được hiển thị"></p>
<em>Lịch sử chỉnh sửa của &ocirc; dữ liệu đ&atilde; được hiển thị​​​​​​​</em></div>
<div>
<div class="zone_sp_h2">&nbsp;</div>
<h2 data-index="4"><strong>3. Mẹo xử l&yacute; khi file Google Sheets bị treo, giật lag</strong></h2>
<p>File dữ liệu chứa h&agrave;ng ng&agrave;n thao t&aacute;c lịch sử l&agrave; ứng dụng web rất nặng. Khi mở nhật k&yacute; phi&ecirc;n bản, tr&igrave;nh duyệt sẽ ngốn lượng RAM khổng lồ để tải dữ liệu. Thiếu RAM sẽ g&acirc;y crash tr&igrave;nh duyệt, treo m&aacute;y v&agrave; mất dữ liệu chưa đồng bộ. Để xử l&yacute; mượt m&agrave; c&aacute;c bảng t&iacute;nh nặng, cấu h&igrave;nh m&aacute;y t&iacute;nh cần đảm bảo:</p>
<ul>
<li>Cần trang bị bộ nhớ RAM từ 16GB trở l&ecirc;n để tr&igrave;nh duyệt web c&oacute; kh&ocirc;ng gian lưu trữ bộ nhớ đệm.</li>
<li>Ưu ti&ecirc;n&nbsp;<a href="https://gearvn.com/blogs/thu-thuat-giai-dap/cpu-la-gi" target="_blank" rel="noopener">CPU</a>&nbsp;đa nh&acirc;n đa luồng để ph&acirc;n bổ tốt c&aacute;c t&aacute;c vụ xử l&yacute; đồ họa của tr&igrave;nh duyệt.</li>
<li>Sử dụng ổ cứng SSD chuẩn&nbsp;<a href="https://gearvn.com/blogs/thu-thuat-giai-dap/pcie-la-gi" target="_blank" rel="noopener">PCIe</a>&nbsp;gi&uacute;p hệ thống truy xuất file tạm thời nhanh ch&oacute;ng hơn.</li>
</ul>
<p><img src="https://cdn.hstatic.net/files/200000722513/file/ich-su-chinh-sua-tren-google-sheets-7_5779211cc4284fc499f7134d0565f286_1024x1024.jpg" alt="Khi l&agrave;m việc với bảng t&iacute;nh lớn, n&ecirc;n sử dụng laptop c&oacute; RAM từ 16GB"></p>
<p><em>Khi l&agrave;m việc với bảng t&iacute;nh lớn, n&ecirc;n sử dụng laptop c&oacute; RAM từ 16GB</em></p>
</div>
<div class="zone_sp_h2">&nbsp;</div>
<h2 data-index="5"><strong>4. GearVN - Nơi mua sắm PC, laptop, gaming gear uy t&iacute;n, chất lượng</strong></h2>
<div>
<p>GEARVN chuy&ecirc;n cung cấp c&aacute;c sản phẩm Hi-End PC, laptop,&nbsp;<a href="https://gearvn.com/pages/pc-gvn" target="_blank" rel="noopener">PC</a>, linh kiện m&aacute;y t&iacute;nh v&agrave; thiết bị gaming (<a href="https://gearvn.com/pages/man-hinh" target="_blank" rel="noopener">m&agrave;n h&igrave;nh m&aacute;y t&iacute;nh</a>,&nbsp;<a href="https://gearvn.com/collections/tai-nghe-may-tinh" target="_blank" rel="noopener">tai nghe</a>, b&agrave;n ph&iacute;m, chuột,...) đ&aacute;p ứng mọi nhu cầu của game thủ v&agrave; người d&ugrave;ng c&ocirc;ng nghệ. Đặc biệt, GEARVN c&ograve;n nổi bật với c&aacute;c điểm như:</p>
<ul>
<li><strong>Đa dạng sản phẩm v&agrave; cấu h&igrave;nh tối ưu</strong>: GEARVN mang đến nhiều lựa chọn từ c&aacute;c thương hiệu lớn như Acer, Gigabyte, Lenovo,... C&aacute;c sản phẩm đều được tuyển chọn kỹ lưỡng.</li>
<li><strong>Gi&aacute; cả cạnh tranh v&agrave; nhiều ưu đ&atilde;i:</strong>&nbsp;GEARVN thường xuy&ecirc;n triển khai c&aacute;c chương tr&igrave;nh khuyến m&atilde;i, giảm gi&aacute; hấp dẫn v&agrave;o c&aacute;c dịp đặc biệt. Bạn c&oacute; thể dễ d&agrave;ng sở hữu laptop ưng &yacute; với mức gi&aacute; tốt nhất, đi k&egrave;m qu&agrave; tặng hấp dẫn hay ch&iacute;nh s&aacute;ch trả g&oacute;p linh hoạt.</li>
<li><strong>Ch&iacute;nh s&aacute;ch bảo h&agrave;nh v&agrave; hậu m&atilde;i uy t&iacute;n:&nbsp;</strong>Mua sắm tại GEARVN, bạn sẽ ho&agrave;n to&agrave;n y&ecirc;n t&acirc;m với ch&iacute;nh s&aacute;ch bảo h&agrave;nh r&otilde; r&agrave;ng v&agrave; đội ngũ hỗ trợ kỹ thuật tận t&igrave;nh. C&aacute;c chuy&ecirc;n vi&ecirc;n gi&agrave;u kinh nghiệm lu&ocirc;n sẵn s&agrave;ng tư vấn gi&uacute;p bạn chọn đ&uacute;ng sản phẩm v&agrave; giải đ&aacute;p mọi thắc mắc trong qu&aacute; tr&igrave;nh sử dụng.</li>
<li><strong>Trải nghiệm mua sắm tiện lợi:</strong>&nbsp;D&ugrave; bạn muốn trải nghiệm trực tiếp tại&nbsp;<a href="https://gearvn.com/pages/he-thong-cua-hang-gearvn" target="_blank" rel="noopener">c&aacute;c showroom</a>&nbsp;hay mua sắm online qua website với dịch vụ giao h&agrave;ng nhanh ch&oacute;ng, GEARVN đều mang đến sự tiện lợi tối đa.</li>
</ul>
<blockquote>
<p><strong>Th&ocirc;ng tin li&ecirc;n hệ GearVN</strong></p>
<ul>
<li><strong>Hotline:&nbsp;</strong><a href="tel:19005301">1900.5301</a></li>
<li><strong>Website:&nbsp;</strong><a href="https://gearvn.com/" target="_blank" rel="noopener">gearvn.com</a></li>
</ul>
</blockquote>
</div>
<p><img src="https://cdn.hstatic.net/files/200000722513/file/ich-su-chinh-sua-tren-google-sheets-8_94fccc069c15432aa950d1f8bc3fd518_1024x1024.jpg" alt="GearVN - Nơi mua sắm PC, laptop, gaming gear uy t&iacute;n, chất lượng"></p>
<p><em>GearVN - Nơi mua sắm PC, laptop, gaming gear uy t&iacute;n, chất lượng</em></p>
<div class="zone_sp_h2">&nbsp;</div>
<h2 data-index="6"><strong>5. C&acirc;u hỏi thường gặp</strong></h2>
<h3><strong>5.1. Xem lịch sử chỉnh sửa tr&ecirc;n Google Sheet c&oacute; mất ph&iacute; kh&ocirc;ng?</strong></h3>
<p>Kh&ocirc;ng. T&iacute;nh năng xem lịch sử phi&ecirc;n bản v&agrave; kh&ocirc;i phục dữ liệu l&agrave; c&ocirc;ng cụ miễn ph&iacute; được Google t&iacute;ch hợp sẵn cho tất cả người d&ugrave;ng Google Workspace v&agrave; t&agrave;i khoản c&aacute; nh&acirc;n c&oacute; quyền chỉnh sửa tệp tin.</p>
<h3><strong>5.2. Tại sao t&ocirc;i kh&ocirc;ng thấy t&ugrave;y chọn Nhật k&yacute; phi&ecirc;n bản?</strong></h3>
<p>Nếu kh&ocirc;ng thấy t&ugrave;y chọn n&agrave;y, c&oacute; thể bạn chỉ được cấp quyền<strong>&nbsp;Người xem&nbsp;</strong>hoặc&nbsp;<strong>Người nhận x&eacute;t</strong>. Bạn cần li&ecirc;n hệ chủ sở hữu tệp để được cấp quyền&nbsp;<strong>Người chỉnh sửa&nbsp;</strong>mới c&oacute; thể truy cập lịch sử thay đổi.</p>
<h3><strong>5.3. C&oacute; c&aacute;ch n&agrave;o x&oacute;a vĩnh viễn lịch sử chỉnh sửa tr&ecirc;n Google Sheet kh&ocirc;ng?</strong></h3>
<p>Kh&ocirc;ng thể x&oacute;a lịch sử trực tiếp tr&ecirc;n tệp gốc do cơ chế bảo mật của Google. Để loại bỏ lịch sử, bạn h&atilde;y chọn<strong>&nbsp;Tệp&nbsp;</strong>&gt; V&agrave;o&nbsp;<strong>Tạo bản sao</strong>, tệp mới sẽ ho&agrave;n to&agrave;n sạch dữ liệu chỉnh sửa cũ.</p>
<blockquote>
<p><strong>Xem th&ecirc;m:</strong></p>
<ul>
<li><a href="https://gearvn.com/blogs/thu-thuat-giai-dap/cach-doi-ten-facebook" target="_blank" rel="noopener">C&aacute;ch đổi t&ecirc;n Facebook tr&ecirc;n điện thoại, m&aacute;y t&iacute;nh mới nhất</a></li>
<li><a href="https://gearvn.com/blogs/thu-thuat-giai-dap/cach-doi-ngon-ngu-tren-may-tinh-cuc-don-gian" target="_blank" rel="noopener">C&aacute;ch đổi ng&ocirc;n ngữ tr&ecirc;n laptop Windows sang tiếng Việt</a></li>
<li><a href="https://gearvn.com/blogs/thu-thuat-giai-dap/cach-tai-ch-play-ve-may-tinh-va-laptop-cuc-don-gian" target="_blank" rel="noopener">C&aacute;ch tải CH Play cho laptop an to&agrave;n v&agrave; nhanh ch&oacute;ng</a></li>
</ul>
</blockquote>
<p><em>Việc xem lịch sử chỉnh sửa tr&ecirc;n Google Sheets gi&uacute;p bạn dễ d&agrave;ng theo d&otilde;i c&aacute;c thay đổi, kh&ocirc;i phục dữ liệu khi cần v&agrave; quản l&yacute; qu&aacute; tr&igrave;nh cộng t&aacute;c hiệu quả hơn. Hy vọng hướng dẫn tr&ecirc;n sẽ gi&uacute;p bạn sử dụng Google Sheets thuận tiện v&agrave; an to&agrave;n hơn trong c&ocirc;ng việc cũng như học tập. Theo d&otilde;i Blog GearVN để xem th&ecirc;m những b&agrave;i viết hữu &iacute;ch kh&aacute;c.</em></p>', '2026-07-13T08:06:15.954Z', 'cach-xem-lich-su-chinh-sua-tren-google-sheets-nhanh-don-gian', 'Làm việc nhóm trên bảng tính trực tuyến thường gặp rủi ro bị ghi đè, xóa nhầm dữ liệu hoặc sai số không rõ nguyên nhân. Tình trạng này khiến nhiều nhân viên văn phòng và sinh viên phải loay hoay tìm cách cứu file. Bài viết này sẽ hướng dẫn xem lịch sử chỉnh sửa trên Google Sheet chi và cách khôi phục dữ liệu đã xóa trên Google Sheets an toàn.

Những điểm chính
Google Sheets cho phép xem lịch sử phiên bản toàn bộ trang tính và lịch sử chỉnh sửa từng ô để theo dõi thay đổi chính xác.
Người dùng cần quyền chỉnh sửa để truy cập nhật ký phiên bản, đồng thời có thể mở nhanh bằng phím tắt trên Windows hoặc macOS.
Khi làm việc với bảng tính lớn, nên sử dụng laptop có RAM từ 16GB, CPU đa nhân và SSD để hạn chế giật lag, treo trình duyệt.
Trước khi khôi phục dữ liệu, hãy tạo bản sao của tệp để đảm bảo an toàn và tránh ảnh hưởng đến công việc của các thành viên khác.
1. Hướng dẫn xem lại lịch sử phiên bản toàn trang tính
1.1. Xem lịch sử phiên bản Google Sheets bằng menu Tệp
Để xem được toàn bộ lịch sử chỉnh sửa, người dùng bắt buộc phải có quyền chỉnh sửa đối với file đó. Tính năng này giúp bạn kiểm soát chi tiết ai đã thao tác và vào khoảng thời gian nào.

Bước 1: Mở file Google Sheets cần kiểm tra. Trên thanh công cụ, nhấn vào mục Tệp, chọn Nhật ký phiên bản rồi vào Xem nhật ký phiên bản.
Vào mục Tệp, chọn Nhật ký phiên bản

Vào mục Tệp, chọn Nhật ký phiên bản
Bước 2: Ngay lập tức, giao diện sẽ hiển thị danh sách lịch sử chỉnh sửa nội dung Google Sheets. Trong đó bao gồm cả những thông tin chi tiết về những lần chỉnh sửa, thời gian và người thay đổi nội dung.
Ngay lập tức, giao diện sẽ hiển thị danh sách lịch sử chỉnh sửa

Ngay lập tức, giao diện sẽ hiển thị danh sách lịch sử chỉnh sửa
1.2. Xem lịch sử phiên bản Google Sheets bằng phím tắt
Thay vì dùng chuột, bạn có thể dùng phím tắt xem lịch sử phiên bản Google Sheets để mở nhanh bảng điều khiển:

Trên Windows: Nhấn tổ hợp phím Ctrl + Alt + Shift + H.
Trên Mac OS: Nhấn tổ hợp phím Cmd + Alt + Shift + H.
Nhấn tổ hợp phím Cmd + Alt + Shift + H trên MacOS

Nhấn tổ hợp phím Cmd + Alt + Shift + H trên MacOS
2. Cách xem lịch sử chỉnh sửa của một ô dữ liệu cụ thể
Xem lịch sử ô là tính năng cho phép kiểm tra nhanh theo thời gian thực để biết chính xác ai đã thay đổi dữ liệu tại một vị trí duy nhất. Cách xem ai đã chỉnh sửa ô trong Google Sheets này giúp bạn không phải dò tìm toàn bộ file khi chỉ có một vài con số bị sai lệch.

Bước 1: Tại file Excel trên Google Sheets, bạn hãy nhấn chọn vào ô dữ liệu mà mình muốn xem lịch sử chỉnh sửa trước đó.
Hãy nhấn chọn vào ô dữ liệu mà mình muốn xem lịch sử

Hãy nhấn chọn vào ô dữ liệu mà mình muốn xem lịch sử
Bước 2: Click vào chuột phải và nhấn chọn mục Hiển thị lịch sử chỉnh sửa.
Chọn mục Hiển thị lịch sử chỉnh sửa

Chọn mục Hiển thị lịch sử chỉnh sửa
Bước 3: Ngay lập tức, lịch sử chỉnh sửa của ô dữ liệu đã được hiển thị.
Lịch sử chỉnh sửa của ô dữ liệu đã được hiển thị

Lịch sử chỉnh sửa của ô dữ liệu đã được hiển thị​​​​​​​
3. Mẹo xử lý khi file Google Sheets bị treo, giật lag
File dữ liệu chứa hàng ngàn thao tác lịch sử là ứng dụng web rất nặng. Khi mở nhật ký phiên bản, trình duyệt sẽ ngốn lượng RAM khổng lồ để tải dữ liệu. Thiếu RAM sẽ gây crash trình duyệt, treo máy và mất dữ liệu chưa đồng bộ. Để xử lý mượt mà các bảng tính nặng, cấu hình máy tính cần đảm bảo:

Cần trang bị bộ nhớ RAM từ 16GB trở lên để trình duyệt web có không gian lưu trữ bộ nhớ đệm.
Ưu tiên CPU đa nhân đa luồng để phân bổ tốt các tác vụ xử lý đồ họa của trình duyệt.
Sử dụng ổ cứng SSD chuẩn PCIe giúp hệ thống truy xuất file tạm thời nhanh chóng hơn.
Khi làm việc với bảng tính lớn, nên sử dụng laptop có RAM từ 16GB

Khi làm việc với bảng tính lớn, nên sử dụng laptop có RAM từ 16GB

4. GearVN - Nơi mua sắm PC, laptop, gaming gear uy tín, chất lượng
GEARVN chuyên cung cấp các sản phẩm Hi-End PC, laptop, PC, linh kiện máy tính và thiết bị gaming (màn hình máy tính, tai nghe, bàn phím, chuột,...) đáp ứng mọi nhu cầu của game thủ và người dùng công nghệ. Đặc biệt, GEARVN còn nổi bật với các điểm như:

Đa dạng sản phẩm và cấu hình tối ưu: GEARVN mang đến nhiều lựa chọn từ các thương hiệu lớn như Acer, Gigabyte, Lenovo,... Các sản phẩm đều được tuyển chọn kỹ lưỡng.
Giá cả cạnh tranh và nhiều ưu đãi: GEARVN thường xuyên triển khai các chương trình khuyến mãi, giảm giá hấp dẫn vào các dịp đặc biệt. Bạn có thể dễ dàng sở hữu laptop ưng ý với mức giá tốt nhất, đi kèm quà tặng hấp dẫn hay chính sách trả góp linh hoạt.
Chính sách bảo hành và hậu mãi uy tín: Mua sắm tại GEARVN, bạn sẽ hoàn toàn yên tâm với chính sách bảo hành rõ ràng và đội ngũ hỗ trợ kỹ thuật tận tình. Các chuyên viên giàu kinh nghiệm luôn sẵn sàng tư vấn giúp bạn chọn đúng sản phẩm và giải đáp mọi thắc mắc trong quá trình sử dụng.
Trải nghiệm mua sắm tiện lợi: Dù bạn muốn trải nghiệm trực tiếp tại các showroom hay mua sắm online qua website với dịch vụ giao hàng nhanh chóng, GEARVN đều mang đến sự tiện lợi tối đa.
Thông tin liên hệ GearVN

Hotline: 1900.5301
Website: gearvn.com
GearVN - Nơi mua sắm PC, laptop, gaming gear uy tín, chất lượng

GearVN - Nơi mua sắm PC, laptop, gaming gear uy tín, chất lượng

5. Câu hỏi thường gặp
5.1. Xem lịch sử chỉnh sửa trên Google Sheet có mất phí không?
Không. Tính năng xem lịch sử phiên bản và khôi phục dữ liệu là công cụ miễn phí được Google tích hợp sẵn cho tất cả người dùng Google Workspace và tài khoản cá nhân có quyền chỉnh sửa tệp tin.

5.2. Tại sao tôi không thấy tùy chọn Nhật ký phiên bản?
Nếu không thấy tùy chọn này, có thể bạn chỉ được cấp quyền Người xem hoặc Người nhận xét. Bạn cần liên hệ chủ sở hữu tệp để được cấp quyền Người chỉnh sửa mới có thể truy cập lịch sử thay đổi.

5.3. Có cách nào xóa vĩnh viễn lịch sử chỉnh sửa trên Google Sheet không?
Không thể xóa lịch sử trực tiếp trên tệp gốc do cơ chế bảo mật của Google. Để loại bỏ lịch sử, bạn hãy chọn Tệp > Vào Tạo bản sao, tệp mới sẽ hoàn toàn sạch dữ liệu chỉnh sửa cũ.

Xem thêm:

Cách đổi tên Facebook trên điện thoại, máy tính mới nhất
Cách đổi ngôn ngữ trên laptop Windows sang tiếng Việt
Cách tải CH Play cho laptop an toàn và nhanh chóng
Việc xem lịch sử chỉnh sửa trên Google Sheets giúp bạn dễ dàng theo dõi các thay đổi, khôi phục dữ liệu khi cần và quản lý quá trình cộng tác hiệu quả hơn. Hy vọng hướng dẫn trên sẽ giúp bạn sử dụng Google Sheets thuận tiện và an toàn hơn trong công việc cũng như học tập. Theo dõi Blog GearVN để xem thêm những bài viết hữu ích khác.', '5238f208-1bf9-492a-8e2b-3126325e1a45_744661791_4190335671259853_6550830613132226952_n.jpg', 'Cách xem lịch sử chỉnh sửa trên Google Sheets nhanh, đơn giản', '2026-07-16T06:33:05.228Z', 29, '', '', '', '8', 1, 'PUBLISHED');

-- Data for Name: news_categories;
INSERT INTO public."news_categories" ("id", "created_at", "description", "name", "slug", "status", "updated_at") VALUES (1, '2026-07-13T14:32:29.980Z', 'mô tả nội dung', 'Tin Tức', 'tin-tuc', 'ACTIVE', '2026-07-13T14:32:29.980Z');
INSERT INTO public."news_categories" ("id", "created_at", "description", "name", "slug", "status", "updated_at") VALUES (2, '2026-07-15T09:25:01.614Z', 'Chấn động Mini PC "hộp cơm" của AMD: RAM lớn gấp 8 lần NVIDIA RTX 5080, lần đầu đưa mô hình AI 235 tỷ tham số vào tay người dùng
', 'Tin tức nổi bật', 'tin-tuc-noi-bat', 'ACTIVE', '2026-07-15T09:26:26.969Z');
INSERT INTO public."news_categories" ("id", "created_at", "description", "name", "slug", "status", "updated_at") VALUES (6, '2026-07-16T04:23:00.477Z', 'Các bài viết hướng dẫn chọn linh kiện, cách lắp ráp PC từ A-Z.', 'Hướng dẫn Build PC', 'huong-dan-build-pc', 'ACTIVE', '2026-07-16T04:23:00.477Z');
INSERT INTO public."news_categories" ("id", "created_at", "description", "name", "slug", "status", "updated_at") VALUES (7, '2026-07-16T04:23:20.094Z', 'Các bài viết so sánh (VD: "Intel Core i5-14600K vs AMD Ryzen 7 7700X"), gợi ý cấu hình theo ngân sách.', 'Tư vấn chọn mua', 'tu-van-chon-mua', 'ACTIVE', '2026-07-16T04:23:20.094Z');
INSERT INTO public."news_categories" ("id", "created_at", "description", "name", "slug", "status", "updated_at") VALUES (8, '2026-07-16T04:23:41.515Z', 'Cách tối ưu hóa Windows, cách ép xung (overclock), cách vệ sinh máy tính tại nhà.', 'Mẹo & Thủ thuật', 'meo-thu-thuat', 'ACTIVE', '2026-07-16T04:23:41.515Z');
INSERT INTO public."news_categories" ("id", "created_at", "description", "name", "slug", "status", "updated_at") VALUES (9, '2026-07-16T04:23:53.733Z', 'Giải thích các thuật ngữ (VD: "SSD NVMe là gì?", "Tại sao cần nguồn chuẩn 80 Plus?").', 'Giải đáp kỹ thuật', 'giai-dap-ky-thuat', 'ACTIVE', '2026-07-16T04:23:53.733Z');
INSERT INTO public."news_categories" ("id", "created_at", "description", "name", "slug", "status", "updated_at") VALUES (10, '2026-07-16T04:24:15.128Z', 'Cập nhật các dòng chip mới, card đồ họa mới ra mắt (NVIDIA/AMD/Intel).', 'Tin công nghệ', 'tin-cong-nghe', 'ACTIVE', '2026-07-16T04:24:15.128Z');
INSERT INTO public."news_categories" ("id", "created_at", "description", "name", "slug", "status", "updated_at") VALUES (11, '2026-07-16T04:24:34.085Z', 'Đánh giá chi tiết các linh kiện hot, trải nghiệm thực tế hiệu năng máy.', 'Review Sản phẩm', 'review-san-pham', 'ACTIVE', '2026-07-16T04:24:34.085Z');
INSERT INTO public."news_categories" ("id", "created_at", "description", "name", "slug", "status", "updated_at") VALUES (12, '2026-07-16T04:24:45.170Z', 'Các chương trình khuyến mãi, sự kiện công nghệ hoặc tin tức thị trường phần cứng.', 'Tin tức sự kiện', 'tin-tuc-su-kien', 'ACTIVE', '2026-07-16T04:24:45.170Z');
INSERT INTO public."news_categories" ("id", "created_at", "description", "name", "slug", "status", "updated_at") VALUES (13, '2026-07-16T04:25:14.149Z', 'Chia sẻ hình ảnh, ý tưởng trang trí góc máy (RGB, decor phòng).', 'Setup PC đẹp', 'setup-pc-dep', 'ACTIVE', '2026-07-16T04:25:14.149Z');
INSERT INTO public."news_categories" ("id", "created_at", "description", "name", "slug", "status", "updated_at") VALUES (14, '2026-07-16T04:25:30.497Z', 'Gợi ý cấu hình tối ưu cho các tựa game hot (VD: "Cấu hình chơi mượt Valorant/GTA V/Cyberpunk 2077").', 'Cấu hình chơi game', 'cau-hinh-choi-game', 'ACTIVE', '2026-07-16T04:25:30.497Z');
INSERT INTO public."news_categories" ("id", "created_at", "description", "name", "slug", "status", "updated_at") VALUES (15, '2026-07-16T04:25:44.293Z', 'Giới thiệu các tựa game mới hoặc các công cụ hỗ trợ công việc/giải trí.', 'Review Game & Phần mềm', 'review-game-phan-mem', 'ACTIVE', '2026-07-16T04:25:44.293Z');

-- Data for Name: sepay_transactions;
INSERT INTO public."sepay_transactions" ("id", "account_number", "order_code", "payment_code", "processed_at", "processing_status", "raw_payload", "received_at", "sepay_transaction_id", "transfer_amount", "transfer_type") VALUES ('1', '104887314781', 'DH44', 'DH44', '2026-07-14T15:10:59.510Z', 'PAID', '{"gateway":"VietinBank","transactionDate":"2026-07-14 22:10:56","accountNumber":"104887314781","subAccount":null,"code":null,"content":"ZP7D3OQQSLSG SEVQR DH44","transferType":"in","description":"BankAPINotify ZP7D3OQQSLSG SEVQR DH44","transferAmount":10000,"referenceCode":"1CFPa-8Ab3YRI1i","accumulated":40000,"id":68246082}', '2026-07-14T15:10:59.028Z', '68246082', '10000', 'in');
INSERT INTO public."sepay_transactions" ("id", "account_number", "order_code", "payment_code", "processed_at", "processing_status", "raw_payload", "received_at", "sepay_transaction_id", "transfer_amount", "transfer_type") VALUES ('2', '104887314781', 'DH45', 'DH45', '2026-07-14T15:15:21.425Z', 'PAID', '{"gateway":"VietinBank","transactionDate":"2026-07-14 22:15:19","accountNumber":"104887314781","subAccount":null,"code":null,"content":"CT DEN:948T2670NEMHZAZR SEVQR DH45","transferType":"in","description":"BankAPINotify CT DEN:948T2670NEMHZAZR SEVQR DH45","transferAmount":10000,"referenceCode":"948T2670NEMHZAZR","accumulated":10000,"id":68246628}', '2026-07-14T15:15:21.138Z', '68246628', '10000', 'in');

-- Data for Name: users;
INSERT INTO public."users" ("id", "username", "email", "password", "full_name", "phone", "address", "enabled", "auth_provider", "provider_id", "avatar", "birthday", "gender", "status", "notify_flash_sale", "notify_new_products", "notify_order_updates", "notify_weekly_newsletter", "two_factor_enabled", "created_at") VALUES (7, 'balittedutphieukhang@gmail.com', 'balittedutphieukhang@gmail.com', '$2a$10$ceBXGEZmWVqVhpH48b2TZuuMNgdGPxYTq4ydS.7erOj7cpOHhaB2y', 'Nguyễn khang', '+84859590337', NULL, true, 'LOCAL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-28T08:19:21.008Z');
INSERT INTO public."users" ("id", "username", "email", "password", "full_name", "phone", "address", "enabled", "auth_provider", "provider_id", "avatar", "birthday", "gender", "status", "notify_flash_sale", "notify_new_products", "notify_order_updates", "notify_weekly_newsletter", "two_factor_enabled", "created_at") VALUES (26, 'admin', 'admin@luxurypc.com', '$2a$10$F76h/W85bFv9Kp040CV4ju4N/jhKpRhXaWgWzewsDa8kDzkHtfXhS', 'Admin LuxuryPC', NULL, NULL, true, 'LOCAL', NULL, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, '2026-06-08T08:23:54.309Z');
INSERT INTO public."users" ("id", "username", "email", "password", "full_name", "phone", "address", "enabled", "auth_provider", "provider_id", "avatar", "birthday", "gender", "status", "notify_flash_sale", "notify_new_products", "notify_order_updates", "notify_weekly_newsletter", "two_factor_enabled", "created_at") VALUES (33, 'ngochai2007nt@gmail.com', 'ngochai2007nt@gmail.com', '$2a$10$1soqIA9YDYg0ggZoYV0Cm.OHY81wkRw2GF8dlFtvIRUcU8Pa5Si0u', 'Hải Nguyễn Ngọc', '+84384333382', NULL, true, 'LOCAL', NULL, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, '2026-06-14T12:11:56.269Z');
INSERT INTO public."users" ("id", "username", "email", "password", "full_name", "phone", "address", "enabled", "auth_provider", "provider_id", "avatar", "birthday", "gender", "status", "notify_flash_sale", "notify_new_products", "notify_order_updates", "notify_weekly_newsletter", "two_factor_enabled", "created_at") VALUES (38, 'tuannguyennasani@gmail.com', 'tuannguyennasani@gmail.com', '$2a$10$cHz.eTkmtRsrCHdDV0jkx.ZXtRIbMkuFt3UXMpVJm5onDMbckJ8TS', 'bi mj', '0869949147', '', true, 'LOCAL', NULL, NULL, NULL, false, false, true, false, true, true, false, NULL);
INSERT INTO public."users" ("id", "username", "email", "password", "full_name", "phone", "address", "enabled", "auth_provider", "provider_id", "avatar", "birthday", "gender", "status", "notify_flash_sale", "notify_new_products", "notify_order_updates", "notify_weekly_newsletter", "two_factor_enabled", "created_at") VALUES (41, 'phamcongthanh.8311@gmail.com', 'phamcongthanh.8311@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phạm Thanh', '0902208461', NULL, true, 'GOOGLE', '112307932430374029161', '/uploads/avatars/user_41_1783933303213.webp', NULL, NULL, false, true, false, true, true, false, '2026-07-13T09:00:58.778Z');
INSERT INTO public."users" ("id", "username", "email", "password", "full_name", "phone", "address", "enabled", "auth_provider", "provider_id", "avatar", "birthday", "gender", "status", "notify_flash_sale", "notify_new_products", "notify_order_updates", "notify_weekly_newsletter", "two_factor_enabled", "created_at") VALUES (9, 'tuan9bledinhchinh@gmail.com', 'tuan9bledinhchinh@gmail.com', '$2a$10$3wA6X7TEsnW5ymYdePRokuIN/FLZ.eIRMD4UQBh8PIyh/3z.LLn0q', 'nguyen tuanv', '+84905338411', NULL, true, 'LOCAL', NULL, '/uploads/avatars/user_9_1782042707831.png', '1995-10-17T17:00:00.000Z', true, true, false, false, true, true, NULL, '2026-03-28T08:59:09.715Z');
INSERT INTO public."users" ("id", "username", "email", "password", "full_name", "phone", "address", "enabled", "auth_provider", "provider_id", "avatar", "birthday", "gender", "status", "notify_flash_sale", "notify_new_products", "notify_order_updates", "notify_weekly_newsletter", "two_factor_enabled", "created_at") VALUES (29, 'leecookcu@gmail.com', 'leecookcu@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', 'Bá Bá', '0936629311', NULL, true, 'LOCAL', NULL, '/uploads/avatars/user_29_1783932198527.jpg', '2006-12-11T17:00:00.000Z', true, true, true, true, false, true, false, '2026-06-12T11:47:49.406Z');
INSERT INTO public."users" ("id", "username", "email", "password", "full_name", "phone", "address", "enabled", "auth_provider", "provider_id", "avatar", "birthday", "gender", "status", "notify_flash_sale", "notify_new_products", "notify_order_updates", "notify_weekly_newsletter", "two_factor_enabled", "created_at") VALUES (43, 'truongquan577@gmail.com', 'truongquan577@gmail.com', '$2a$10$gh0vQYsD242R1hjpFWOTc.hvPanF9tbhWlBhu/vndvToJBHEyejkG', 'Quân Nguyễn', '0867868825', NULL, true, 'GOOGLE', '117704587837574685080', NULL, NULL, NULL, false, true, false, true, true, false, '2026-07-13T15:20:52.151Z');
INSERT INTO public."users" ("id", "username", "email", "password", "full_name", "phone", "address", "enabled", "auth_provider", "provider_id", "avatar", "birthday", "gender", "status", "notify_flash_sale", "notify_new_products", "notify_order_updates", "notify_weekly_newsletter", "two_factor_enabled", "created_at") VALUES (47, 'ditmemaygogle113', 'ditmemaygogle113@gmail.com', '49b4e39e-f53f-4158-a06d-a5f995ddd21c', 'Yến Trần', NULL, NULL, true, 'GOOGLE', '102325764378749092956', NULL, NULL, NULL, false, true, true, true, true, false, '2026-07-14T04:06:11.866Z');
INSERT INTO public."users" ("id", "username", "email", "password", "full_name", "phone", "address", "enabled", "auth_provider", "provider_id", "avatar", "birthday", "gender", "status", "notify_flash_sale", "notify_new_products", "notify_order_updates", "notify_weekly_newsletter", "two_factor_enabled", "created_at") VALUES (25, 'nguyentruongq169', 'nguyentruongq169@gmail.com', '$2a$10$JKkTGHPr.EWsXIr0/PPgzuq4pFp/QDiBLkQ0n0b/XSQbGouVpIlJ.', 'Quân Nguyễn Trường', NULL, NULL, true, 'GOOGLE', '113506180708155747249', NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, '2026-06-08T08:14:14.918Z');

-- Data for Name: user_sessions;
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (3, 9, 'b4ca1a60-87bd-4024-9a65-66d06090519c', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-20T11:48:14.865Z', '2026-06-20T11:48:14.865Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (1, 29, '4201e3e4-129c-4f35-b5d1-825db34cda4c', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-20T11:35:07.105Z', '2026-06-20T11:35:07.105Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (2, 29, '2bb5f7b3-222b-4351-a18f-76778818323d', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-20T11:37:32.378Z', '2026-06-20T11:37:32.378Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (9, 9, '763abca3-a9fd-4366-81a5-1fbe99b7df89', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-20T14:04:44.264Z', '2026-06-20T14:04:44.264Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (10, 9, '0536cba6-45f0-44e5-a014-d22ba9545c5f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-21T01:20:34.015Z', '2026-06-21T01:20:34.015Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (6, 29, '8ee09a1a-fce0-41fb-b41e-f443d371f6d4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-20T12:36:43.203Z', '2026-06-20T12:36:43.203Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (5, 29, 'b4adc9ce-d1cc-486e-80ce-cbfe8a8af1c0', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-20T11:56:32.364Z', '2026-06-20T11:56:32.364Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (4, 29, 'c17a7c72-5c75-4728-8eba-0ccfe8c2db0b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-20T11:51:23.400Z', '2026-06-20T11:51:23.400Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (11, 29, 'D16377E7C472CA5C8170BEEE95661EB2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14T02:48:52.065Z', '2026-07-14T02:48:52.065Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (12, 41, '7367AC769C2AA53AA11A71EB7E12E2DD', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14T03:42:04.617Z', '2026-07-14T03:42:04.617Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (13, 41, 'A76D8FD0B7F46C4A2731A91C9ACB0F9B', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14T03:46:31.130Z', '2026-07-14T03:46:31.130Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (14, 29, '5E1DD9F1ACA6E84FB699D2948E335EBF', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14T03:49:43.077Z', '2026-07-14T03:49:43.077Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (16, 9, '3B496EB84BA4729E402632D670F8F757', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14T04:31:29.502Z', '2026-07-14T04:31:29.502Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (15, 29, '52ED2D533772239DEF6DA6DD70F58817', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14T04:19:20.066Z', '2026-07-14T04:19:20.066Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (17, 29, '2695481ABF5A072EFF4E1F0B594A3E87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14T06:02:56.745Z', '2026-07-14T06:02:56.745Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (18, 9, '56B186E8711A718FD6AA1C2BBA2B4D7C', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14T09:27:18.997Z', '2026-07-14T09:27:18.997Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (19, 9, '852373781149679D2DE868A246A7D560', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14T09:32:30.823Z', '2026-07-14T09:32:30.823Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (20, 25, '2E11D4135950810EBF7A91D91AFA1B87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14T11:42:59.725Z', '2026-07-14T11:42:59.725Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (21, 25, 'FD2F988760B70AD452EC3A01C36A59F3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14T13:42:31.715Z', '2026-07-14T13:42:31.715Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (22, 25, '410E9E0EB6C7A34861CF437D866D4DAE', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14T14:46:03.329Z', '2026-07-14T14:46:03.329Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (23, 25, '8082AD0E8B48DEC9541B89C0182FC1C5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14T15:26:42.996Z', '2026-07-14T15:26:42.996Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (24, 29, 'E4482AE22051BB9DBCB74197256D4A74', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15T03:34:15.079Z', '2026-07-15T03:34:15.079Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (25, 29, '3B0FA524172ABE089075FCB2B88DF08D', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15T06:12:11.228Z', '2026-07-15T06:12:11.228Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (26, 29, 'A2DE4BEC2FAE246855EE22F9A4730DC4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15T07:17:32.200Z', '2026-07-15T07:17:32.200Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (27, 29, '9B8553915EC69AAD8308C45D7E373B06', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15T07:27:09.649Z', '2026-07-15T07:27:09.649Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (28, 29, '2D6C938B86698EED5D559A07FFBBA0AB', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15T07:27:27.733Z', '2026-07-15T07:27:27.733Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (29, 9, '27D19D0CAF46BF8046A67C8E570E3893', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15T07:39:58.786Z', '2026-07-15T07:39:58.786Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (30, 9, 'E9F7D20A4B858CC7FDDB4DCE265D3E79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15T08:26:12.082Z', '2026-07-15T08:26:12.082Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (32, 9, '4ECA85F2EFB1A1BD13D55F8A5ADD67F8', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15T08:26:19.693Z', '2026-07-15T08:26:19.693Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (33, 29, 'C6D32211ACB593746B50B529C2AB9951', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15T09:18:00.101Z', '2026-07-15T09:18:00.101Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (34, 29, '1DF0ABB9B9A2676AC62B2663285CE740', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15T09:43:26.145Z', '2026-07-15T09:43:26.145Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (35, 25, '3063AE560226AA779458104DC069692C', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15T12:29:39.606Z', '2026-07-15T12:29:39.606Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (36, 25, '236A6BE1D162ACA85D4003B5561FC51A', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15T13:36:12.737Z', '2026-07-15T13:36:12.737Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (38, 29, '5CD959984D22A221D9744775D7E02EFE', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T01:46:49.732Z', '2026-07-16T01:46:49.732Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (37, 9, '51967DDEDBCF3FCD2AE2F4BB8DA6FDC5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T01:45:01.788Z', '2026-07-16T01:45:01.788Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (39, 29, 'ED6424F860A1ECB60CE2A3BA9CC3A1A7', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T02:36:39.567Z', '2026-07-16T02:36:39.567Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (40, 29, 'AA460F12632EC5B51E3ADB35731DE200', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T02:43:09.290Z', '2026-07-16T02:43:09.290Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (41, 29, 'BA2F0C67A4877795CEC26C632A8BCAC7', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T02:43:09.947Z', '2026-07-16T02:43:09.947Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (42, 9, '30C3D6E00CF9F3566642B6120F41BC63', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T03:42:54.008Z', '2026-07-16T03:42:54.008Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (43, 29, '937D6241700D7EB60D4DC52C21F36F01', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T04:23:11.437Z', '2026-07-16T04:23:11.437Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (44, 9, '1135F7A24694F08736F9F4522DC30DCB', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T05:00:07.461Z', '2026-07-16T05:00:07.461Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (45, 9, '3D86806F4C35124970FF59791D8B03E5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T06:31:41.576Z', '2026-07-16T06:31:41.576Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (46, 9, '5816B0388C50A7D81CF144C2AFD510FD', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T06:31:43.790Z', '2026-07-16T06:31:43.790Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (47, 9, '03E10A5B44FB78392CCB712BA5AB2F62', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T06:31:44.821Z', '2026-07-16T06:31:44.821Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (48, 9, 'F2B6B078E894D4599CB1E1F83F8914EA', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T06:58:13.552Z', '2026-07-16T06:58:13.552Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (49, 9, '81DF730DAAFD38E6449CE68D40C48E34', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T07:24:37.081Z', '2026-07-16T07:24:37.081Z', true);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (50, 9, '5BF8769C9BC32DB51709A2BB03AFAC32', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T08:16:46.040Z', '2026-07-16T08:16:46.040Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (52, 9, '66F1666EA7925D18162CEEC39BA88615', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T08:16:57.735Z', '2026-07-16T08:16:57.735Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (53, 25, 'F1979516B55F37B70B39F5DEF3C1271A', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T15:25:40.849Z', '2026-07-16T15:25:40.849Z', false);
INSERT INTO public."user_sessions" ("id", "user_id", "session_id", "user_agent", "device_info", "ip_address", "location", "login_time", "last_activity", "is_expired") VALUES (54, 9, '8C9D657B433558B08E8FC3986BB8077D', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16T15:29:16.504Z', '2026-07-16T15:29:16.504Z', false);

-- Data for Name: roles;
INSERT INTO public."roles" ("id", "name") VALUES (1, 'ADMIN');
INSERT INTO public."roles" ("id", "name") VALUES (2, 'USER');
INSERT INTO public."roles" ("id", "name") VALUES (3, 'STAFF');

-- Data for Name: user_roles;
INSERT INTO public."user_roles" ("user_id", "role_id", "id") VALUES (9, 1, 23);
INSERT INTO public."user_roles" ("user_id", "role_id", "id") VALUES (25, 2, 24);
INSERT INTO public."user_roles" ("user_id", "role_id", "id") VALUES (26, 1, 25);
INSERT INTO public."user_roles" ("user_id", "role_id", "id") VALUES (25, 1, 26);
INSERT INTO public."user_roles" ("user_id", "role_id", "id") VALUES (33, 1, 32);
INSERT INTO public."user_roles" ("user_id", "role_id", "id") VALUES (38, 3, 36);
INSERT INTO public."user_roles" ("user_id", "role_id", "id") VALUES (29, 1, 28);
INSERT INTO public."user_roles" ("user_id", "role_id", "id") VALUES (43, 2, 40);
INSERT INTO public."user_roles" ("user_id", "role_id", "id") VALUES (41, 3, 39);
INSERT INTO public."user_roles" ("user_id", "role_id", "id") VALUES (47, 2, 41);

-- Data for Name: categories;
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (1, 'CPU', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (2, 'GPU', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (3, 'RAM', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (4, 'Mainboard', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (5, 'SSD', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (6, 'Màn hình', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (84, 'HDD', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (85, 'PSU', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (86, 'Case', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (87, 'CPU Cooler', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (88, 'Case Fan', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (89, 'Keyboard', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (90, 'Mouse', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (91, 'Headset', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (7, 'Storage', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (8, 'Cooling', NULL, NULL);
INSERT INTO public."categories" ("id", "name", "display", "slug") VALUES (9, 'VGA', NULL, NULL);

-- Data for Name: inventory;
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (2, 2, 15, '2026-04-06T13:51:03.317Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (3, 3, 40, '2026-04-06T13:51:03.617Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (6, 6, 60, '2026-04-06T13:51:04.539Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (7, 7, 10, '2026-04-06T13:51:04.847Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (8, 8, 20, '2026-04-06T13:51:05.193Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (9, 9, 45, '2026-04-06T13:51:05.635Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (10, 10, 25, '2026-04-06T13:51:05.963Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (11, 11, 100, '2026-04-06T13:51:06.291Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (12, 12, 80, '2026-04-06T13:51:06.607Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (13, 13, 70, '2026-04-06T13:51:06.913Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (14, 14, 120, '2026-04-06T13:51:07.220Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (15, 15, 15, '2026-04-06T13:51:07.522Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (17, 17, 65, '2026-04-06T13:51:08.129Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (18, 18, 40, '2026-04-06T13:51:08.430Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (19, 19, 35, '2026-04-06T13:51:08.732Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (20, 20, 28, '2026-04-06T13:51:09.051Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (21, 21, 50, '2026-04-06T13:51:09.403Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (22, 22, 95, '2026-04-06T13:51:09.712Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (23, 23, 10, '2026-04-06T13:51:10.029Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (24, 24, 150, '2026-04-06T13:51:10.335Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (25, 25, 110, '2026-04-06T13:51:10.649Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (26, 26, 8, '2026-04-06T13:51:10.955Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (27, 27, 200, '2026-04-06T13:51:11.268Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (28, 28, 180, '2026-04-06T13:51:11.577Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (29, 29, 20, '2026-04-06T13:51:11.877Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (30, 30, 33, '2026-04-06T13:51:12.182Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (31, 31, 10, '2026-04-06T13:51:12.493Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (32, 32, 15, '2026-04-06T13:51:12.796Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (33, 33, 25, '2026-04-06T13:51:13.125Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (34, 34, 12, '2026-04-06T13:51:13.430Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (36, 36, 30, '2026-04-06T13:51:14.041Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (37, 37, 80, '2026-04-06T13:51:14.385Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (38, 38, 100, '2026-04-06T13:51:14.684Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (39, 160, 3, '2026-04-06T13:51:14.986Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (40, 39, 5, '2026-04-06T13:51:15.320Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (41, 40, 20, '2026-04-06T13:51:15.634Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (42, 41, 60, '2026-04-06T13:51:15.933Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (43, 42, 35, '2026-04-06T13:51:16.249Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (44, 43, 50, '2026-04-06T13:51:16.549Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (45, 44, 70, '2026-04-06T13:51:16.880Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (46, 45, 40, '2026-04-06T13:51:17.233Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (47, 46, 15, '2026-04-06T13:51:17.538Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (48, 47, 10, '2026-04-06T13:51:17.836Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (49, 48, 5, '2026-04-06T13:51:18.143Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (50, 49, 18, '2026-04-06T13:51:18.454Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (51, 50, 22, '2026-04-06T13:51:18.761Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (52, 51, 150, '2026-04-06T13:51:19.075Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (53, 52, 40, '2026-04-06T13:51:19.427Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (54, 53, 8, '2026-04-06T13:51:19.744Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (55, 54, 10, '2026-04-06T13:51:20.055Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (56, 55, 3, '2026-04-06T13:51:20.362Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (57, 56, 25, '2026-04-06T13:51:20.666Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (58, 57, 40, '2026-04-06T13:51:20.965Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (59, 58, 15, '2026-04-06T13:51:21.265Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (60, 59, 4, '2026-04-06T13:51:21.562Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (61, 60, 55, '2026-04-06T13:51:21.862Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (62, 61, 50, '2026-04-06T13:51:22.163Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (63, 62, 40, '2026-04-06T13:51:22.465Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (64, 63, 120, '2026-04-06T13:51:22.765Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (65, 64, 45, '2026-04-06T13:51:23.069Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (66, 65, 70, '2026-04-06T13:51:23.373Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (67, 66, 200, '2026-04-06T13:51:23.699Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (68, 67, 10, '2026-04-06T13:51:23.997Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (69, 68, 90, '2026-04-06T13:51:24.304Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (70, 69, 55, '2026-04-06T13:51:24.616Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (71, 70, 25, '2026-04-06T13:51:24.917Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (72, 71, 60, '2026-04-06T13:51:25.221Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (73, 72, 150, '2026-04-06T13:51:25.520Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (74, 73, 20, '2026-04-06T13:51:25.819Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (75, 74, 40, '2026-04-06T13:51:26.122Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (76, 75, 30, '2026-04-06T13:51:26.434Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (77, 76, 25, '2026-04-06T13:51:26.745Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (78, 77, 15, '2026-04-06T13:51:27.046Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (79, 78, 100, '2026-04-06T13:51:27.350Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (80, 79, 50, '2026-04-06T13:51:27.651Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (81, 80, 40, '2026-04-06T13:51:27.977Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (82, 81, 20, '2026-04-06T13:51:28.280Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (83, 82, 80, '2026-04-06T13:51:28.584Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (84, 83, 35, '2026-04-06T13:51:28.884Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (85, 84, 60, '2026-04-06T13:51:29.233Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (86, 85, 45, '2026-04-06T13:51:29.531Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (87, 86, 15, '2026-04-06T13:51:29.829Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (88, 87, 30, '2026-04-06T13:51:30.153Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (89, 88, 100, '2026-04-06T13:51:30.483Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (90, 89, 5, '2026-04-06T13:51:30.834Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (91, 90, 25, '2026-04-06T13:51:31.156Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (92, 91, 12, '2026-04-06T13:51:31.477Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (93, 92, 45, '2026-04-06T13:51:31.788Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (94, 93, 30, '2026-04-06T13:51:32.085Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (95, 94, 40, '2026-04-06T13:51:32.390Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (96, 95, 60, '2026-04-06T13:51:32.691Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (97, 96, 15, '2026-04-06T13:51:33.020Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (98, 97, 100, '2026-04-06T13:51:33.318Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (99, 98, 80, '2026-04-06T13:51:33.624Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (100, 99, 20, '2026-04-06T13:51:33.926Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (101, 100, 3, '2026-04-06T13:51:34.266Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (102, 101, 8, '2026-04-06T13:51:34.613Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (103, 102, 10, '2026-04-06T13:51:34.925Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (104, 103, 12, '2026-04-06T13:51:35.226Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (105, 104, 150, '2026-04-06T13:51:35.555Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (106, 105, 5, '2026-04-06T13:51:35.856Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (107, 106, 40, '2026-04-06T13:51:36.151Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (108, 107, 25, '2026-04-06T13:51:36.464Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (109, 108, 90, '2026-04-06T13:51:36.774Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (110, 109, 18, '2026-04-06T13:51:37.078Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (111, 110, 55, '2026-04-06T13:51:37.395Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (112, 111, 2, '2026-04-06T13:51:37.710Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (113, 112, 20, '2026-04-06T13:51:38.015Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (114, 113, 45, '2026-04-06T13:51:38.344Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (115, 114, 35, '2026-04-06T13:51:38.643Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (116, 115, 40, '2026-04-06T13:51:38.977Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (117, 116, 50, '2026-04-06T13:51:39.294Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (118, 117, 30, '2026-04-06T13:51:39.594Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (119, 118, 110, '2026-04-06T13:51:39.890Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (120, 119, 15, '2026-04-06T13:51:40.208Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (121, 120, 7, '2026-04-06T13:51:40.516Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (122, 121, 60, '2026-04-06T13:51:41.214Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (123, 122, 40, '2026-04-06T13:51:41.513Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (124, 123, 55, '2026-04-06T13:51:41.817Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (125, 124, 100, '2026-04-06T13:51:42.117Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (126, 125, 150, '2026-04-06T13:51:42.414Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (127, 126, 80, '2026-04-06T13:51:42.727Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (128, 127, 20, '2026-04-06T13:51:43.034Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (129, 128, 45, '2026-04-06T13:51:43.332Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (130, 129, 15, '2026-04-06T13:51:43.637Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (131, 130, 10, '2026-04-06T13:51:43.937Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (132, 131, 90, '2026-04-06T13:51:44.258Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (133, 132, 65, '2026-04-06T13:51:44.562Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (134, 133, 75, '2026-04-06T13:51:44.865Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (135, 134, 18, '2026-04-06T13:51:45.169Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (136, 135, 8, '2026-04-06T13:51:45.481Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (137, 136, 30, '2026-04-06T13:51:45.777Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (138, 137, 50, '2026-04-06T13:51:46.077Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (139, 138, 60, '2026-04-06T13:51:46.394Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (140, 139, 22, '2026-04-06T13:51:46.695Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (141, 140, 40, '2026-04-06T13:51:47.001Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (142, 141, 85, '2026-04-06T13:51:47.295Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (143, 142, 120, '2026-04-06T13:51:47.661Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (144, 143, 20, '2026-04-06T13:51:47.957Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (145, 144, 35, '2026-04-06T13:51:48.257Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (146, 145, 12, '2026-04-06T13:51:48.556Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (147, 146, 100, '2026-04-06T13:51:48.859Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (148, 147, 40, '2026-04-06T13:51:49.165Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (150, 149, 200, '2026-04-06T13:51:49.769Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (151, 150, 5, '2026-04-06T13:51:50.066Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (152, 151, 12, '2026-04-06T13:51:50.361Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (153, 152, 25, '2026-04-06T13:51:50.658Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (154, 153, 60, '2026-04-06T13:51:50.959Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (155, 154, 8, '2026-04-06T13:51:51.259Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (156, 155, 35, '2026-04-06T13:51:51.556Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (157, 156, 80, '2026-04-06T13:51:51.856Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (35, 35, 43, '2026-06-12T07:53:10.583Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (4, 4, 27, '2026-06-12T10:18:38.169Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (5, 5, 54, '2026-06-12T10:21:06.490Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (158, 157, 50, '2026-04-06T13:51:52.151Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (159, 158, 20, '2026-04-06T13:51:52.451Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (160, 159, 5, '2026-04-06T13:51:52.750Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (161, 161, 30, '2026-04-06T13:51:53.047Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (162, 162, 100, '2026-04-06T13:51:53.342Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (163, 163, 4, '2026-04-06T13:51:53.654Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (164, 164, 70, '2026-04-06T13:51:53.964Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (165, 165, 15, '2026-04-06T13:51:54.269Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (166, 166, 45, '2026-04-06T13:51:54.594Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (167, 167, 22, '2026-04-06T13:51:54.935Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (168, 168, 10, '2026-04-06T13:51:55.234Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (169, 169, 40, '2026-04-06T13:51:55.649Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (170, 170, 25, '2026-04-06T13:51:56.017Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (171, 171, 18, '2026-04-06T13:51:56.334Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (172, 172, 55, '2026-04-06T13:51:56.650Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (173, 173, 90, '2026-04-06T13:51:56.964Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (174, 174, 150, '2026-04-06T13:51:57.268Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (175, 175, 35, '2026-04-06T13:51:57.569Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (176, 176, 80, '2026-04-06T13:51:57.866Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (177, 177, 15, '2026-04-06T13:51:58.176Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (178, 178, 2, '2026-04-06T13:51:58.474Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (179, 179, 20, '2026-04-06T13:51:58.779Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (180, 180, 40, '2026-04-06T13:51:59.082Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (1, 1, 48, '2026-04-23T05:54:40.683Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (181, 205, 50, '2026-06-06T02:48:11.978Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (182, 206, 50, '2026-06-06T02:48:27.877Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (183, 181, 50, '2026-06-06T02:48:50.163Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (184, 182, 50, '2026-06-06T02:48:50.697Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (185, 183, 50, '2026-06-06T02:48:51.225Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (186, 184, 50, '2026-06-06T02:48:51.777Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (187, 185, 50, '2026-06-06T02:48:52.308Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (188, 186, 50, '2026-06-06T02:48:52.806Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (189, 187, 50, '2026-06-06T02:48:53.413Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (190, 188, 50, '2026-06-06T02:48:53.977Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (191, 189, 50, '2026-06-06T02:48:54.537Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (192, 190, 50, '2026-06-06T02:48:55.069Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (193, 191, 50, '2026-06-06T02:48:55.578Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (194, 192, 50, '2026-06-06T02:48:56.149Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (195, 193, 50, '2026-06-06T02:48:56.660Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (196, 194, 50, '2026-06-06T02:48:57.166Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (197, 195, 50, '2026-06-06T02:48:57.674Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (198, 196, 50, '2026-06-06T02:48:58.173Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (199, 197, 50, '2026-06-06T02:48:58.701Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (200, 198, 50, '2026-06-06T02:48:59.215Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (201, 199, 50, '2026-06-06T02:48:59.734Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (202, 200, 50, '2026-06-06T02:49:00.275Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (203, 201, 50, '2026-06-06T02:49:00.835Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (204, 202, 50, '2026-06-06T02:49:01.425Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (205, 203, 50, '2026-06-06T02:49:01.936Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (206, 204, 50, '2026-06-06T02:49:02.596Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (207, 207, 50, '2026-06-06T02:49:03.158Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (208, 208, 50, '2026-06-06T02:49:03.700Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (209, 209, 50, '2026-06-06T02:49:04.209Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (210, 210, 50, '2026-06-06T02:49:04.713Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (211, 211, 50, '2026-06-06T02:49:05.249Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (212, 212, 50, '2026-06-06T02:49:05.778Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (213, 213, 50, '2026-06-06T02:49:06.316Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (214, 214, 50, '2026-06-06T02:49:06.831Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (215, 215, 50, '2026-06-06T02:49:07.385Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (216, 216, 50, '2026-06-06T02:49:07.917Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (217, 217, 50, '2026-06-06T02:49:08.514Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (218, 218, 50, '2026-06-06T02:49:09.101Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (219, 219, 50, '2026-06-06T02:49:09.647Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (220, 220, 50, '2026-06-06T02:49:10.163Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (221, 221, 50, '2026-06-06T02:49:10.664Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (222, 222, 50, '2026-06-06T02:49:11.176Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (223, 223, 50, '2026-06-06T02:49:11.705Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (224, 224, 50, '2026-06-06T02:49:12.215Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (225, 225, 50, '2026-06-06T02:49:13.047Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (226, 226, 50, '2026-06-06T02:49:13.615Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (227, 227, 50, '2026-06-06T02:49:14.194Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (228, 228, 50, '2026-06-06T02:49:14.733Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (229, 229, 50, '2026-06-06T02:49:15.275Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (230, 230, 50, '2026-06-06T02:49:15.799Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (231, 231, 50, '2026-06-06T02:49:16.357Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (232, 232, 50, '2026-06-06T02:49:16.912Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (233, 233, 50, '2026-06-06T02:49:17.453Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (234, 234, 50, '2026-06-06T02:49:17.987Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (235, 235, 50, '2026-06-06T02:49:18.561Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (236, 236, 50, '2026-06-06T02:49:19.064Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (237, 237, 50, '2026-06-06T02:49:19.576Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (238, 238, 50, '2026-06-06T02:49:20.081Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (239, 239, 50, '2026-06-06T02:49:20.626Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (240, 240, 50, '2026-06-06T02:49:21.145Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (241, 241, 50, '2026-06-06T02:49:21.737Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (242, 242, 50, '2026-06-06T02:49:22.352Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (243, 243, 50, '2026-06-06T02:49:22.887Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (244, 244, 50, '2026-06-06T02:49:23.407Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (245, 245, 50, '2026-06-06T02:49:24.077Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (246, 246, 50, '2026-06-06T02:49:24.652Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (247, 247, 50, '2026-06-06T02:49:25.187Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (248, 248, 50, '2026-06-06T02:49:25.717Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (249, 249, 50, '2026-06-06T02:49:26.238Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (250, 250, 50, '2026-06-06T02:49:26.773Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (251, 251, 50, '2026-06-06T02:49:27.358Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (252, 252, 50, '2026-06-06T02:49:27.892Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (253, 253, 50, '2026-06-06T02:49:28.403Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (254, 254, 50, '2026-06-06T02:49:28.927Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (255, 255, 50, '2026-06-06T02:49:29.435Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (256, 256, 100, '2026-06-27T05:54:28.148Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (257, 257, 100, '2026-06-27T05:54:28.446Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (258, 258, 100, '2026-06-27T05:54:28.735Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (259, 259, 100, '2026-06-27T05:54:35.988Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (260, 260, 100, '2026-06-27T05:54:36.271Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (261, 261, 100, '2026-06-27T05:54:49.887Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (262, 262, 100, '2026-06-27T05:54:51.815Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (263, 263, 100, '2026-06-27T05:55:05.917Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (264, 264, 100, '2026-06-27T05:55:13.318Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (265, 265, 100, '2026-06-27T05:55:24.726Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (266, 266, 100, '2026-06-27T05:55:25.041Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (267, 267, 100, '2026-06-27T05:55:25.329Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (268, 268, 100, '2026-06-27T05:55:25.630Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (269, 269, 100, '2026-06-27T05:55:25.921Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (270, 270, 100, '2026-06-27T05:55:26.603Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (271, 271, 100, '2026-06-27T05:55:27.068Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (272, 272, 100, '2026-06-27T05:55:27.369Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (273, 273, 100, '2026-06-27T05:55:27.660Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (274, 274, 100, '2026-06-27T05:55:27.944Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (275, 275, 100, '2026-06-27T05:55:28.237Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (276, 276, 100, '2026-06-27T05:55:28.533Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (277, 277, 100, '2026-06-27T05:55:28.822Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (278, 16, 100, '2026-06-27T05:55:29.106Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (279, 278, 100, '2026-06-27T06:17:32.011Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (280, 279, 100, '2026-06-27T06:17:32.333Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (281, 280, 100, '2026-06-27T06:17:32.629Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (282, 281, 100, '2026-06-27T06:17:32.912Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (283, 282, 100, '2026-06-27T06:17:33.213Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (284, 283, 100, '2026-06-27T06:17:33.517Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (285, 284, 100, '2026-06-27T06:17:33.814Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (286, 285, 100, '2026-06-27T06:17:34.303Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (287, 286, 100, '2026-06-27T06:17:34.596Z');
INSERT INTO public."inventory" ("id", "product_id", "quantity", "last_update") VALUES (149, 148, 31, '2026-07-14T06:54:16.700Z');

-- Data for Name: stock_movements;
INSERT INTO public."stock_movements" ("id", "product_id", "change_quantity", "movement_type", "note", "created_at") VALUES (1, 1, 23, 'IMPORT', '', '2026-04-23T05:54:40.508Z');
INSERT INTO public."stock_movements" ("id", "product_id", "change_quantity", "movement_type", "note", "created_at") VALUES (2, 148, 2, 'EXPORT', 'ok', '2026-06-12T03:45:03.715Z');
INSERT INTO public."stock_movements" ("id", "product_id", "change_quantity", "movement_type", "note", "created_at") VALUES (3, 148, 17, 'IMPORT', '', '2026-06-12T03:45:14.706Z');
INSERT INTO public."stock_movements" ("id", "product_id", "change_quantity", "movement_type", "note", "created_at") VALUES (4, 35, 2, 'EXPORT', 'Tru kho cho don DH71', '2026-06-12T07:53:10.375Z');
INSERT INTO public."stock_movements" ("id", "product_id", "change_quantity", "movement_type", "note", "created_at") VALUES (5, 4, 3, 'EXPORT', 'Tru kho cho don DH74', '2026-06-12T10:18:37.969Z');
INSERT INTO public."stock_movements" ("id", "product_id", "change_quantity", "movement_type", "note", "created_at") VALUES (6, 5, 1, 'EXPORT', 'Tru kho cho don DH75', '2026-06-12T10:21:06.300Z');
INSERT INTO public."stock_movements" ("id", "product_id", "change_quantity", "movement_type", "note", "created_at") VALUES (7, 148, 1, 'IMPORT', '', '2026-07-14T06:48:58.514Z');
INSERT INTO public."stock_movements" ("id", "product_id", "change_quantity", "movement_type", "note", "created_at") VALUES (8, 148, 1, 'EXPORT', '', '2026-07-14T06:49:22.926Z');
INSERT INTO public."stock_movements" ("id", "product_id", "change_quantity", "movement_type", "note", "created_at") VALUES (9, 148, 1, 'IMPORT', '', '2026-07-14T06:54:16.531Z');

-- Data for Name: products;
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (257, 'Intel Core i5 12400F / 2.5GHz Turbo 4.4GHz (TRAY) - CHÍNH HÃNG', 2500000, 'TDP: 65W', 'i9_14900k.jpg', 1, 99, '2026-06-27T05:52:50.064Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (277, 'Cooler Master Hyper 212 Spectrum V3 ARGB', 600000, 'TDP: 5W', 'corsair_rm850e.jpg', 8, 99, '2026-06-27T05:52:59.845Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (286, 'ROG Ryujin III 360 ARGB', 8500000, 'TDP: 20W', 'rog_ryujin_360.jpg', 8, 108, '2026-06-27T06:16:36.609Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (279, 'Intel Core Ultra 9 285K', 16500000, 'TDP: 125W', 'i9_14900k.jpg', 1, 49, '2026-06-27T06:16:14.752Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (256, 'Intel Core Ultra 7 265F (Tray)', 12000000, 'TDP: 125W', 'i9_14900k.jpg', 1, 97, '2026-06-27T05:52:49.647Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (260, 'GIGABYTE H610M-H V3 (DDR4)', 1800000, 'TDP: 30W', 'z790_dark_kingpin.jpg', 4, 99, '2026-06-27T05:52:51.326Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (278, 'Intel Core i9 14900K (Tray)', 14000000, 'TDP: 125W', 'i9_14900k.jpg', 1, 100, '2026-06-27T06:16:14.081Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (287, 'test', 10000, 'dddd', '', 1, 99, '2026-07-16T15:27:24.032Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (11, 'Intel Core i5-12400F', 3500000, 'Budget King, 6 Cores', 'i9_14900k.jpg', 1, 96, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (258, 'Intel Core i7 14700F (Tray)', 9500000, 'TDP: 65W', 'i9_14900k.jpg', 1, 100, '2026-06-27T05:52:50.462Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (280, 'ASUS ROG MAXIMUS Z790 HERO', 15000000, 'TDP: 60W', 'z790_dark_kingpin.jpg', 4, 100, '2026-06-27T06:16:16.445Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (281, 'ProArt Z790-CREATOR WIFI', 12000000, 'TDP: 55W', 'z790_dark_kingpin.jpg', 4, 100, '2026-06-27T06:16:16.974Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (282, 'Corsair Dominator Titanium 64GB', 6500000, 'TDP: 15W', 'corsair_rm850e.jpg', 3, 100, '2026-06-27T06:16:18.101Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (283, 'G.Skill Trident Z5 64GB DDR5', 5500000, 'TDP: 15W', 'galax_hof_32gb.jpg', 3, 100, '2026-06-27T06:16:18.602Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (284, 'ASUS ROG Strix RTX 5090 24GB', 65000000, 'TDP: 450W', 'asus_rog_rtx_4090.jpg', 9, 100, '2026-06-27T06:16:33.267Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (16, 'Vỏ máy tính Xigmatek QUANTUM 4AF', 800000, 'TDP: 0W', 'corsair_3500x_black.png', 86, 100, '2026-06-27T05:22:45.418Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (285, 'Samsung 990 PRO 2TB', 4500000, 'TDP: 15W', 'sabrent_rocket_4tb.jpg', 7, 100, '2026-06-27T06:16:34.196Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (24, 'AMD Ryzen 5 3600', 2100000, 'Popular AM4 CPU', 'i9_14900k.jpg', 1, 150, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (259, 'GIGABYTE Z890 EAGLE WIFI7 (DDR5)', 7500000, 'TDP: 40W', 'z790_dark_kingpin.jpg', 4, 97, '2026-06-27T05:52:50.891Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (15, 'Intel Core i9-12900K', 9500000, '16 Cores, Previous Flagship', 'i9_14900k.jpg', 1, 13, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (9, 'Intel Core i7-13700F', 8900000, '16 Cores, No Integrated Graphics', 'i9_14900k.jpg', 1, 45, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (14, 'AMD Ryzen 3 4100', 1800000, 'Budget 4 Cores, AM4', 'i9_14900k.jpg', 1, 118, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (18, 'AMD Ryzen 5 8600G', 6200000, 'AI Engine, Radeon 760M', 'i9_14900k.jpg', 1, 34, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (56, 'Intel Arc A770 16GB', 9200000, 'Intel High-end GPU', 'i9_14900k.jpg', 2, 25, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (58, 'ASUS Dual RTX 4070', 17500000, 'Clean white build', 'asus_rog_rtx_4090.jpg', 2, 15, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (60, 'PNY RTX 4060', 7500000, 'Small and efficient', 'asus_rog_rtx_4090.jpg', 2, 55, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (61, 'Corsair Vengeance 32GB', 3500000, 'DDR5 6000MHz Black', 'galax_hof_32gb.jpg', 3, 50, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (65, 'ADATA XPG 16GB', 1800000, 'DDR5 5200MHz', 'corsair_3500x_black.png', 3, 70, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (66, 'Crucial 8GB', 650000, 'Standard office RAM', 'sabrent_rocket_4tb.jpg', 3, 200, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (67, 'Dominator Titanium 64GB', 9500000, 'DDR5 7200MHz', 'corsair_3500x_black.png', 3, 10, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (68, 'Ripjaws V 16GB', 1100000, 'DDR4 3600MHz', 'corsair_3500x_black.png', 3, 90, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (73, 'Mushkin Redline 32GB', 3400000, 'DDR5 5600MHz', 'corsair_3500x_black.png', 3, 20, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (75, 'Samsung 32GB', 2800000, 'DDR5 4800MHz OEM', 'sabrent_rocket_4tb.jpg', 3, 30, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (123, 'WD SN850X 1TB', 2600000, 'Top gaming SSD', 'corsair_3500x_black.png', 5, 55, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (124, 'Crucial P3 Plus 1T', 1850000, 'Budget Gen4', 'sabrent_rocket_4tb.jpg', 5, 100, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (126, 'Samsung 870 EVO 1T', 2100000, 'Best SATA SSD', 'sabrent_rocket_4tb.jpg', 5, 80, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (127, 'P41 Platinum 2T', 5200000, 'Super Fast Gen4', 'corsair_3500x_black.png', 5, 20, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (128, 'Lexar NM790 2T', 3800000, 'Value Gen4 7400', 'corsair_3500x_black.png', 5, 45, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (129, 'Crucial T700 1TB', 5800000, 'Gen5 11700MB/s', 'sabrent_rocket_4tb.jpg', 5, 15, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (131, 'TeamGroup MP33 1T', 1400000, 'Budget NVMe', 'corsair_3500x_black.png', 5, 90, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (132, 'XPG S70 Blade 1T', 2200000, 'PS5 Gen4', 'corsair_3500x_black.png', 5, 65, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (133, 'SN580 1TB', 1700000, 'Reliable Gen4', 'corsair_3500x_black.png', 5, 75, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (25, 'Intel Core i5-10400F', 2200000, 'Stable and Cheap', 'i9_14900k.jpg', 1, 110, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (26, 'AMD Ryzen 9 3900X', 7500000, '12 Cores, Workstation', 'i9_14900k.jpg', 1, 8, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (27, 'Intel Pentium G7400', 1900000, 'Office work, 2 Cores', 'i9_14900k.jpg', 1, 200, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (28, 'AMD Athlon 3000G', 1200000, 'Ultra Budget Graphics', 'i9_14900k.jpg', 1, 180, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (22, 'AMD Ryzen 5 4500', 1950000, 'Super Budget 6 Cores', 'i9_14900k.jpg', 1, 92, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (33, 'RTX 4070 Ti Super', 24500000, 'Perfect for 2K Gaming', 'asus_rog_rtx_4090.jpg', 2, 25, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (36, 'AMD RX 7800 XT', 15200000, 'Best value 2K GPU', 'asus_rog_rtx_4090.jpg', 2, 30, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (38, 'AMD RX 6600', 5500000, 'Best budget 1080p', 'asus_rog_rtx_4090.jpg', 2, 100, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (160, 'BenQ SW271C', 42000000, 'Pro Color Photo', 'corsair_3500x_black.png', 6, 3, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (4, 'AMD Ryzen 7 7800X3D', 11500000, 'Best gaming CPU, 8 Cores, 3D V-Cache', 'i9_14900k.jpg', 1, 27, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (20, 'AMD Ryzen 7 7700', 7800000, '8 Cores, Low Power 65W', 'i9_14900k.jpg', 1, 28, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (21, 'Intel Core i5-11400F', 2800000, 'Old Gen Budget King', 'i9_14900k.jpg', 1, 50, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (3, 'Intel Core i7-14700Kkk', 10800000, '20 Cores, Hybrid Architecture', 'i9_14900k.jpg', 1, 0, NULL, NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (29, 'Intel Core i7-10700K', 4800000, 'High Clock Legacy', 'i9_14900k.jpg', 1, 20, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (30, 'AMD Ryzen 7 8700G', 9200000, 'Powerful APU, Radeon 780M', 'i9_14900k.jpg', 1, 33, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (31, 'NVIDIA RTX 4090 24GB', 55000000, 'Ultimate Gaming GPU', 'asus_rog_rtx_4090.jpg', 2, 10, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (32, 'RTX 4080 Super', 32000000, 'High-end 4K Gaming', 'asus_rog_rtx_4090.jpg', 2, 15, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (34, 'AMD RX 7900 XTX', 28500000, 'AMD Flagship, 24GB', 'asus_rog_rtx_4090.jpg', 2, 12, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (261, 'GIGABYTE B760M GAMING PLUS WIFI DDR4', 3500000, 'TDP: 40W', 'z790_dark_kingpin.jpg', 4, 100, '2026-06-27T05:52:51.741Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (39, 'ASUS ROG RTX 4090', 62000000, 'Premium build cooling', 'asus_rog_rtx_4090.jpg', 2, 5, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (48, 'EVGA RTX 3080', 15000000, 'High performance legacy', 'asus_rog_rtx_4090.jpg', 2, 5, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (41, 'Gigabyte Eagle RTX 4060', 8200000, 'Triple Fan Budget', 'asus_rog_rtx_4090.jpg', 2, 60, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (42, 'RTX 4070 Super', 17800000, '12GB GDDR6X, Fast', 'asus_rog_rtx_4090.jpg', 2, 35, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (43, 'AMD RX 7600', 7900000, 'Budget RDNA 3', 'asus_rog_rtx_4090.jpg', 2, 50, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (44, 'RTX 3050 6GB', 5200000, 'Entry level RTX', 'asus_rog_rtx_4090.jpg', 2, 70, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (134, 'FireCuda 530 2TB', 5900000, 'High endurance', 'corsair_3500x_black.png', 5, 18, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (139, 'MP600 Pro 2TB', 4800000, 'Optimized for PS5', 'corsair_3500x_black.png', 5, 22, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (143, 'Spatium M480 2TB', 4600000, 'High-end MSI SSD', 'corsair_3500x_black.png', 5, 20, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (151, 'LG 27GR95QE', 22500000, '27" OLED 240Hz', 'corsair_3500x_black.png', 6, 12, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (152, 'Dell U2723QE', 14800000, '27" 4K IPS Black', 'corsair_3500x_black.png', 6, 25, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (153, 'VG249Q', 4200000, '24" 144Hz IPS', 'corsair_3500x_black.png', 6, 60, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (156, 'AOC 24G2', 3900000, 'Popular 144Hz', 'corsair_3500x_black.png', 6, 80, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (157, 'ViewSonic VX2728', 4500000, '27" 165Hz IPS', 'corsair_3500x_black.png', 6, 50, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (161, 'Samsung M7', 8200000, '32" 4K Smart', 'sabrent_rocket_4tb.jpg', 6, 30, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (162, 'LG 24MP60G', 2900000, 'Budget 24" IPS', 'corsair_3500x_black.png', 6, 100, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (77, 'Zadak Spark 32GB', 3900000, 'DDR5 6000MHz', 'corsair_3500x_black.png', 3, 15, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (80, 'V-Color Prism 32GB', 3100000, 'DDR4 3600MHz RGB', 'corsair_3500x_black.png', 3, 40, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (81, 'Kingston Fury 64GB', 6800000, 'DDR5 5600MHz Kit', 'sabrent_rocket_4tb.jpg', 3, 20, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (102, 'ProArt Z790-Creator', 13800000, 'For Creators', 'z790_dark_kingpin.jpg', 4, 10, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (45, 'Zotac RTX 4060', 7800000, 'Compact dual fan', 'asus_rog_rtx_4090.jpg', 2, 40, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (46, 'Galax RTX 4070 Pink', 16900000, 'Pink Edition RGB', 'asus_rog_rtx_4090.jpg', 2, 15, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (50, 'PowerColor RX 7800 XT', 14800000, 'Excellent cooling', 'asus_rog_rtx_4090.jpg', 2, 22, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (52, 'RX 6700 XT', 9500000, 'Great 1440p value', 'asus_rog_rtx_4090.jpg', 2, 40, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (53, 'Colorful RTX 4080', 31000000, 'LCD screen on GPU', 'asus_rog_rtx_4090.jpg', 2, 8, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (57, 'Intel Arc A750', 6500000, 'Budget King Intel', 'i9_14900k.jpg', 2, 40, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (59, 'Gigabyte RTX 4090', 59000000, 'Massive cooler', 'asus_rog_rtx_4090.jpg', 2, 4, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (63, 'Kingston Fury 16GB', 1250000, 'DDR4 3200MHz', 'sabrent_rocket_4tb.jpg', 3, 120, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (64, 'T-Force Delta 32GB', 3200000, 'DDR5 6000MHz White', 'corsair_3500x_black.png', 3, 45, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (69, 'Lexar Thor 32GB', 2100000, 'DDR4 3200MHz Budget', 'corsair_3500x_black.png', 3, 55, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (70, 'Fury Renegade 32GB', 4800000, 'DDR5 7200MHz', 'corsair_3500x_black.png', 3, 25, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (71, 'PNY XLR8 16GB', 1350000, 'DDR4 3200MHz RGB', 'corsair_3500x_black.png', 3, 60, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (72, 'Silicon Power 16GB', 950000, 'Value RAM 3200', 'corsair_3500x_black.png', 3, 150, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (74, 'Patriot Viper 16GB', 1450000, 'DDR4 4000MHz', 'corsair_3500x_black.png', 3, 40, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (76, 'Thermaltake 16GB', 2200000, 'DDR4 3600MHz RGB', 'corsair_3500x_black.png', 3, 25, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (78, 'Apacer Panther 8GB', 750000, 'Budget Gaming RAM', 'corsair_3500x_black.png', 3, 100, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (79, 'GeIL Super Luce 16GB', 1300000, 'DDR4 3200MHz', 'corsair_3500x_black.png', 3, 50, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (40, 'MSI Gaming X RTX 4070', 18500000, 'Quiet and Cool', 'asus_rog_rtx_4090.jpg', 2, 20, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (37, 'RTX 3060 12GB', 7800000, 'Popular Mid-range', 'asus_rog_rtx_4090.jpg', 2, 80, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (111, 'Z790 Dark Kingpin', 22000000, 'Limitless OC', 'z790_dark_kingpin.jpg', 4, 2, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (55, 'Radeon Pro W7800', 58000000, 'Professional Graphics', 'asus_rog_rtx_4090.jpg', 2, 3, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (62, 'G.Skill Trident Z5 32GB', 4200000, 'DDR5 6400MHz RGB', 'galax_hof_32gb.jpg', 3, 40, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (262, 'RAM Kingmax Horizon 16GB DDR5 Bus 5600Mhz', 1200000, 'TDP: 10W', 'galax_hof_32gb.jpg', 3, 97, '2026-06-27T05:52:52.239Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (84, 'Team Elite 16GB', 1600000, 'DDR5 4800 Basic', 'corsair_3500x_black.png', 3, 60, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (82, 'Vengeance LPX 32GB', 2500000, 'DDR4 3200 Low Profile', 'galax_hof_32gb.jpg', 3, 80, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (83, 'Trident Z Neo 32GB', 3400000, 'Optimized for Ryzen', 'galax_hof_32gb.jpg', 3, 35, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (87, 'Lexar Ares 32GB', 3600000, 'DDR5 6400MHz', 'corsair_3500x_black.png', 3, 30, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (90, 'Oloy Blade 32GB', 3250000, 'DDR5 6000MHz Black', 'corsair_3500x_black.png', 3, 25, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (93, 'Z790 Aorus Elite', 7800000, 'High perf Z790', 'z790_dark_kingpin.jpg', 4, 30, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (94, 'TUF B650-Plus', 5800000, 'Standard AM5 Board', 'z790_dark_kingpin.jpg', 4, 40, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (98, 'B450M DS3H', 1850000, 'Legendary AM4 Budget', 'corsair_3500x_black.png', 4, 80, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (99, 'ROG Strix B760-I', 5900000, 'ITX Intel Board', 'z790_dark_kingpin.jpg', 4, 20, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (104, 'PRO H610M-E', 1950000, 'Cheap office build', 'z790_dark_kingpin.jpg', 4, 150, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (106, 'Biostar B760MZ', 3100000, 'Budget B760', 'z790_dark_kingpin.jpg', 4, 40, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (117, 'Prime Z790-P', 6200000, 'Mainstream Z790', 'z790_dark_kingpin.jpg', 4, 30, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (125, 'Kingston NV2 500G', 950000, 'Entry NVMe', 'sabrent_rocket_4tb.jpg', 5, 150, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (130, 'Aorus Gen5 2TB', 9500000, 'Gen5 w/ Heatsink', 'corsair_3500x_black.png', 5, 10, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (35, 'RTX 4060 Ti 8GB', 11500000, 'Efficient 1080p/2K', 'asus_rog_rtx_4090.jpg', 2, 43, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (5, 'Intel Core i5-13600K', 8200000, '14 Cores, Mid-range gaming', 'i9_14900k.jpg', 1, 54, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (6, 'AMD Ryzen 5 7600X', 5800000, '6 Cores, Zen 4 Architecture, AM5', 'i9_14900k.jpg', 1, 59, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (8, 'AMD Ryzen 9 7900X', 10500000, '12 Cores, 5.6GHz Boost', 'i9_14900k.jpg', 1, 18, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (2, 'AMD Ryzen 9 7950X3D', 17200000, '16 Cores, 128MB L3 Cache, AM5', 'i9_14900k.jpg', 1, 15, NULL, NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (10, 'AMD Ryzen 7 5800X3D', 8500000, 'Legendary AM4 gaming CPU', 'i9_14900k.jpg', 1, 25, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (17, 'Intel Core i5-14400F', 5600000, '10 Cores, Efficient Gaming', 'i9_14900k.jpg', 1, 64, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (13, 'Intel Core i3-14100', 3800000, 'Entry level 14th Gen', 'i9_14900k.jpg', 1, 37, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (19, 'Intel Core i7-12700K', 7200000, '12 Cores, LGA 1700', 'i9_14900k.jpg', 1, 34, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (47, 'ASUS TUF RTX 3070 Ti', 12000000, 'Rugged build quality', 'asus_rog_rtx_4090.jpg', 2, 10, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (49, 'Sapphire RX 7900 GRE', 16500000, 'Golden Rabbit Edition', 'asus_rog_rtx_4090.jpg', 2, 18, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (51, 'GTX 1650', 3800000, 'No external power', 'asus_rog_rtx_4090.jpg', 2, 150, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (85, 'Crucial Pro 32GB', 3300000, '6000MHz Overclock', 'sabrent_rocket_4tb.jpg', 3, 45, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (86, 'Aorus RGB 16GB', 2400000, '3733MHz w/ Demo', 'corsair_3500x_black.png', 3, 15, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (263, 'Ram KingSpec Heatsink Red 1x16GB DDR4 Bus 3200Mhz', 750000, 'TDP: 10W', 'galax_hof_32gb.jpg', 3, 100, '2026-06-27T05:52:52.718Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (101, 'Z790 Taichi', 12500000, 'Gear design, E-ATX', 'z790_dark_kingpin.jpg', 4, 8, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (120, 'Valkyrie Z790', 9500000, 'Biostar Flagship', 'z790_dark_kingpin.jpg', 4, 7, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (121, 'Samsung 990 Pro 1T', 3200000, 'NVMe Gen4 7450MB/s', 'sabrent_rocket_4tb.jpg', 5, 60, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (135, 'Sabrent Rocket 4TB', 12500000, 'Huge capacity', 'sabrent_rocket_4tb.jpg', 5, 8, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (136, '970 EVO Plus 2TB', 3900000, 'Gen3 King', 'corsair_3500x_black.png', 5, 30, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (137, 'PNY CS2241 1TB', 1600000, 'Budget Gen4', 'corsair_3500x_black.png', 5, 50, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (173, 'MSI G2412', 3500000, 'Budget 170Hz', 'corsair_3500x_black.png', 6, 90, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (180, 'Xiaomi Mi 34', 9500000, '34" 2K UltraWide', 'corsair_3500x_black.png', 6, 40, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (141, 'Crucial MX500 1TB', 1800000, 'SATA storage', 'sabrent_rocket_4tb.jpg', 5, 85, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (142, 'SN350 480GB', 850000, 'Cheap upgrade', 'corsair_3500x_black.png', 5, 120, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (144, 'Transcend 250S 1T', 2100000, 'Gen4 with Cache', 'corsair_3500x_black.png', 5, 35, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (145, 'Viper VP4300 2TB', 5400000, 'Dual heatsinks', 'corsair_3500x_black.png', 5, 12, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (146, 'Lexar NM620 512G', 900000, 'Gen3 Budget', 'corsair_3500x_black.png', 5, 100, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (147, 'Netac N7000 2TB', 3600000, 'Gen4 7000MB/s', 'corsair_3500x_black.png', 5, 40, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (149, 'Adata SU650 240G', 450000, 'Cheapest SSD', 'corsair_3500x_black.png', 5, 200, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (154, 'Odyssey Neo G8', 28000000, '32" 4K 240Hz', 'samsung_990pro.jpg', 6, 8, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (155, 'Gigabyte M27Q', 7800000, '27" 2K 170Hz', 'corsair_3500x_black.png', 6, 35, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (158, 'MAG274QRF-QD', 10500000, '2K Quantum Dot', 'corsair_3500x_black.png', 6, 20, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (159, 'AW3423DW', 32000000, '34" QD-OLED', 'samsung_990pro.jpg', 6, 5, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (163, 'Swift PG42UQ', 38000000, '42" OLED 4K', 'samsung_990pro.jpg', 6, 4, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (164, 'Gigabyte G24F 2', 4100000, '24" 180Hz OC', 'corsair_3500x_black.png', 6, 70, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (167, 'Dell S2721DGF', 9200000, 'Fast IPS 165Hz', 'corsair_3500x_black.png', 6, 22, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (168, 'LG DualUp', 16000000, 'Square 16:18', 'corsair_3500x_black.png', 6, 10, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (169, 'Odyssey G5', 7200000, '27" 2K Curved', 'samsung_990pro.jpg', 6, 40, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (170, 'Legion Y25-30', 6800000, '24.5" 240Hz', 'corsair_3500x_black.png', 6, 25, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (175, 'LG 29WP500', 5200000, '29" UltraWide', 'corsair_3500x_black.png', 6, 35, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (176, 'Philips 242E1', 3100000, 'Budget 144Hz', 'corsair_3500x_black.png', 6, 80, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (177, 'AOC CU34G2X', 12500000, '34" UW 144Hz', 'corsair_3500x_black.png', 6, 15, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (178, 'Xeneon Flex', 45000000, 'Bendable OLED', 'samsung_990pro.jpg', 6, 2, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (1, 'Intel Core i9-14900K', 15500000, '24 Cores, up to 6.0GHz, LGA 1700', 'i9_14900k.jpg', 1, 46, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (150, 'Crucial T705 2TB', 10500000, 'Fastest Gen5', 'sabrent_rocket_4tb.jpg', 5, 5, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (184, 'AMD Radeon RX 7900 XT GPU', 22834600, '20GB GDDR6, 80MB, 315W', 'asus_rog_rtx_4090.jpg', 2, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (91, 'ROG Maximus Z790 Hero', 16500000, 'Flagship Intel Board', 'z790_dark_kingpin.jpg', 4, 12, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (92, 'B760M Mortar WiFi', 4500000, 'Best Mid-range Intel', 'z790_dark_kingpin.jpg', 4, 45, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (95, 'B660M Pro RS', 3200000, 'Budget Intel 12/13', 'corsair_3500x_black.png', 4, 60, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (96, 'X670E Carbon WiFi', 11500000, 'High-end AM5', 'z790_dark_kingpin.jpg', 4, 15, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (97, 'Prime H610M-K', 2100000, 'Office Intel Board', 'z790_dark_kingpin.jpg', 4, 100, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (100, 'Z790 GODLIKE', 35000000, 'Ultimate Overclock', 'z790_dark_kingpin.jpg', 4, 3, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (103, 'B650I Aorus Ultra', 7200000, 'ITX AM5 Board', 'z790_dark_kingpin.jpg', 4, 12, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (105, 'Crosshair X670E', 28000000, 'Best of AM5', 'z790_dark_kingpin.jpg', 4, 5, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (107, 'CVN B760M Frozen', 4200000, 'White Motherboard', 'z790_dark_kingpin.jpg', 4, 25, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (108, 'A520M S2H', 1650000, 'Budget AM4', 'corsair_3500x_black.png', 4, 90, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (189, 'ASUS ROG Strix GeForce RTX 4090 OC Edition', 50774600, '24GB GDDR6X, 16384, PCIe 4.0', 'asus_rog_rtx_4090.jpg', 2, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (264, 'MSI GeForce RTX 5070 Ti 16GB Shadow 3X OC', 25000000, 'TDP: 250W', 'asus_rog_rtx_4090.jpg', 9, 99, '2026-06-27T05:52:53.246Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (165, 'HP Z27k G3', 15500000, '4K Studio USB-C', 'corsair_3500x_black.png', 6, 15, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (179, 'Zowie XL2546K', 13500000, 'Pro Esport 240Hz', 'corsair_3500x_black.png', 6, 20, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (181, 'Intel Arc A770 Limited Edition GPU', 8356600, '16GB GDDR6, 256-bit, 2100 MHz, 225W', 'i9_14900k.jpg', 2, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (183, 'Intel Arc A580 Graphics Card', 4546600, '8GB GDDR6, 256-bit, 1700 MHz, 185W', 'asus_rog_rtx_4090.jpg', 2, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (186, 'AMD Ryzen 5 5600X Desktop Processor', 3784600, '6, 12, AM4, 65W', 'i9_14900k.jpg', 1, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (188, 'ASUS ROG Strix X670E-E Gaming WiFi', 12674600, 'AM5, AMD X670E, PCIe 5.0, ATX', 'z790_dark_kingpin.jpg', 4, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (190, 'ASUS ROG Swift OLED PG32UCDM', 32994600, '32-inch, 3840x2160 (4K), 240Hz, QD-OLED', 'samsung_990pro.jpg', 6, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (192, 'ASUS ROG Thor 1200W Platinum II', 8102600, '1200W, 80 Plus Platinum, Full Modular, Real-time power draw', 'corsair_3500x_black.png', 85, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (193, 'MSI MEG Z790 GODLIKE MAX', 30454600, 'LGA1700, Intel Z790, 7x M.2 slots, M-Vision Dashboard', 'z790_dark_kingpin.jpg', 4, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (195, 'MSI GeForce RTX 4080 SUPER 16G GAMING X SLIM', 26644600, '16GB GDDR6X, TRI FROZR 3, 2625 MHz', 'asus_rog_rtx_4090.jpg', 2, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (196, 'MSI MPG 271QRX QD-OLED', 20294600, '27-inch, 2560x1440 (2K), 360Hz, 0.03ms (GtG)', 'asus_rog_rtx_4090.jpg', 6, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (198, 'MSI MAG CORELIQUID I360', 3530600, '360mm, ARGB Fans, Infinite Mirror IPS Style Design', 'i9_14900k.jpg', 87, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (199, 'MSI SPATIUM M570 PCIe 5.0 NVMe M.2 HS', 7594600, '2TB, Up to 12400 MB/s, Up to 11800 MB/s', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (88, 'Netac Shadow 16GB', 1100000, 'Budget RGB RAM', 'corsair_3500x_black.png', 3, 100, NULL, NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (212, 'Corsair RM1000x Shift Fully Modular ATX PSU', 5308600, '1000W, 80 PLUS Gold, Side-mounted modular connections, ATX 3.0 & PCIe 5.0 ready', 'corsair_rm850e.jpg', 85, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (213, 'Corsair AX1600i Digital ATX Power Supply', 15468600, '1600W, 80 PLUS Titanium, Gallium Nitride (GaN) FETs', 'corsair_rm850e.jpg', 85, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (215, 'Corsair Darkstar Wireless MMO Gaming Mouse', 4292600, '15 programmable buttons, MARKSMAN 26K DPI Optical, SLIPSTREAM Wireless & Bluetooth', 'corsair_rm850e.jpg', 90, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (216, 'Corsair Virtuoso RGB Wireless XT Headset', 6832600, 'High-Density 50mm Neodymium, Spatial Dolby Atmos, Broadcast-grade detachable mic', 'corsair_rm850e.jpg', 91, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (217, 'Logitech G Pro X Superlight 2 Wireless GamingMouse', 4038600, '60 grams, HERO 2 Sensor (32,000 DPI), LIGHTFORCE Hybrid Switches, 4000Hz max polling', 'corsair_3500x_black.png', 90, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (219, 'Logitech G915 TKL Wireless Mechanical Keyboard', 5816600, 'Tenkeyless (TKL), Low Profile GL Tactile/Linear/Clicky, Up to 40 hours (100% brightness)', 'corsair_3500x_black.png', 89, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (220, 'Logitech G Pro X TKL LIGHTSPEED Gaming Keyboard', 5054600, 'Dual-shot PBT keycaps, LIGHTSPEED Wireless, Bluetooth, USB, Dedicated volume roller and controls', 'corsair_3500x_black.png', 89, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (221, 'Logitech G Pro X 2 LIGHTSPEED Wireless Headset', 6324600, '50mm Graphene Drivers, LIGHTSPEED, Bluetooth, 3.5mm wired, Up to 50 hours battery life', 'corsair_3500x_black.png', 91, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (109, 'NZXT N7 Z790', 8500000, 'Clean Aesthetic', 'z790_dark_kingpin.jpg', 4, 18, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (110, 'A620M-HDV', 2800000, 'Cheap AM5 entry', 'corsair_3500x_black.png', 4, 55, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (112, 'X570S Tomahawk', 6500000, 'Silent AM4', 'corsair_3500x_black.png', 4, 20, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (113, 'A520M-Plus', 2400000, 'Durable AM4', 'corsair_3500x_black.png', 4, 45, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (114, 'Z790 UD', 5500000, 'Basic Z790', 'z790_dark_kingpin.jpg', 4, 35, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (115, 'B550M Steel Legend', 3800000, 'Solid B550 AM4', 'corsair_3500x_black.png', 4, 40, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (116, 'MSI B650 Gaming', 4900000, 'Budget AM5 WiFi', 'z790_dark_kingpin.jpg', 4, 50, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (223, 'Logitech MX Keys S Wireless Keyboard', 2768600, 'Spherically-dished Perfect Stroke keys, Smart illumination proximity sensor, Easy-Switch up to 3 devices', 'corsair_3500x_black.png', 89, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (224, 'Razer Viper V3 Pro Wireless Gaming Mouse', 4038600, '54 grams, Focus Pro 35K Optical Sensor Gen-2, True 8000Hz HyperPolling Wireless', 'corsair_3500x_black.png', 90, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (225, 'Razer DeathAdder V3 Pro Wireless Gaming Mouse', 3784600, '63 grams, Right-handed ergonomic design, Focus Pro 30K Optical Sensor', 'corsair_3500x_black.png', 90, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (227, 'Razer BlackWidow V4 Pro Mechanical GamingKeyboard', 5816600, 'Razer Green Clicky / Yellow Linear Switches, Per-key & 3-sided underglow RGB, 8 dedicated macro keys', 'corsair_3500x_black.png', 89, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (228, 'Razer BlackShark V2 Pro (2023 Edition) WirelessHeadset', 5054600, 'Razer HyperClear Super Wideband Mic, TriForce Titanium 50mm Drivers, Up to 70 hours', 'corsair_3500x_black.png', 91, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (232, 'Samsung Odyssey OLED G9 (G95SC) Gaming Monitor', 40614600, '49-inch Curved Ultra-wide, 5120x1440 (Dual QHD), 240Hz, 0.03ms (GtG)', 'sabrent_rocket_4tb.jpg', 6, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (233, 'Samsung Odyssey Ark Gen 2 Mini-LED Monitor', 63474600, '55-inch 1000R Curved, 3840x2160 (4K), 165Hz, Yes, rotates vertically', 'sabrent_rocket_4tb.jpg', 6, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (235, 'Kingston FURY Renegade DDR5 RGB 32GB (2x16GB) 7200MHz', 4292600, '32GB Kit, 7200 MT/s, CL38-44-44, 1.45V', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (236, 'Kingston FURY Beast DDR5 32GB (2x16GB) 6000MHz', 3022600, '32GB Kit, 6000 MT/s, AMD EXPO / Intel XMP 3.0 certified', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (237, 'Kingston KC3000 PCIe 4.0 NVMe M.2 SSD 2TB', 3911600, '2TB, Up to 7000 MB/s, Up to 7000 MB/s, Phison E18', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (238, 'Kingston NV2 PCIe 4.0 NVMe M.2 SSD 1TB', 1625600, '1TB, Up to 3500 MB/s, Up to 2100 MB/s, M.2 2280', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (240, 'WD Red Pro NAS Internal Hard Drive 12TB', 7594600, '12TB, 7200 RPM, 256MB, SATA 6 Gb/s', 'corsair_3500x_black.png', 84, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (241, 'Seagate IronWolf Pro 16TB NAS HDD', 8356600, '16TB, 550TB/year, Rotational Vibration (RV) sensors', 'sabrent_rocket_4tb.jpg', 84, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (243, 'NZXT H9 Flow Dual-Chamber Mid-Tower', 4038600, 'Wrap-around tempered glass pane, 4x F120Q Airflow fans, Up to 435mm', 'corsair_3500x_black.png', 86, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (244, 'NZXT Kraken Elite 360 RGB Liquid Cooler', 7594600, '360mm aluminum radiator, 2.36-inch wide-angle TFT-LCD display, 640x640 pixels', 'rog_ryujin_360.jpg', 87, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (246, 'BenQ ZOWIE XL2566K 360Hz Esports Gaming Monitor', 15214600, '24.5-inch TN Panel, 360Hz, DyAc+ Technology motion blur reduction', 'samsung_990pro.jpg', 6, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (205, 'Gigabyte UD1000GM PG5 (Rev 2.0)', 4038600, '1000W, PCIe Gen 5.0 (12VHPWR), 80 PLUS Gold', 'corsair_3500x_black.png', 85, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (206, 'Gigabyte AORUS C500 GLASS', 4546600, 'Mid Tower, 4mm Tempered Glass, Up to 420mm front', 'corsair_3500x_black.png', 86, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (229, 'Samsung 990 PRO PCIe 4.0 NVMe M.2 SSD 2TB', 4546600, '2TB, Up to 7450 MB/s, Up to 6900 MB/s, Samsung Pascal Controller', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (187, 'ASUS ROG Maximus Z790 Dark Hero', 17754600, 'LGA1700, Intel Z790, 4x DDR5 (Up to 192GB), ATX', 'z790_dark_kingpin.jpg', 4, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (191, 'ASUS ROG Ryujin III 360 ARGB', 8864600, '360mm, Asetek 8th Gen, 3.5-inch Full Color', 'rog_ryujin_360.jpg', 87, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (148, '870 QVO 4TB', 8500000, 'Massive SATA', 'corsair_3500x_black.png', 5, 31, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (266, 'MSI GeForce RTX 5060 Ventus 2X OC 8GB', 8500000, 'TDP: 150W', 'asus_rog_rtx_4090.jpg', 9, 100, '2026-06-27T05:52:54.227Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (267, 'ZOTAC GeForce RTX 5060 Ti 8GB TWIN EDGE GDDR7', 11000000, 'TDP: 160W', 'asus_rog_rtx_4090.jpg', 9, 100, '2026-06-27T05:52:54.716Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (269, 'Ổ Cứng SSD KingSpec NVMe 512GB (NE-512)', 800000, 'TDP: 10W', 'sabrent_rocket_4tb.jpg', 7, 100, '2026-06-27T05:52:55.693Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (265, 'GIGABYTE GeForce RTX 5080 WINDFORCE OC SFF 16G', 35000000, 'TDP: 300W', 'asus_rog_rtx_4090.jpg', 9, 98, '2026-06-27T05:52:53.742Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (268, 'Ổ cứng SSD Kingston NV3 1TB M.2 PCIe NVMe Gen4', 1800000, 'TDP: 10W', 'sabrent_rocket_4tb.jpg', 7, 97, '2026-06-27T05:52:55.209Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (118, 'H610M S2H', 2250000, 'LGA 1700 Office', 'z790_dark_kingpin.jpg', 4, 110, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (119, 'X670E Steel Legend', 8900000, 'White AM5 High', 'z790_dark_kingpin.jpg', 4, 15, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (122, 'Samsung 980 Pro 2T', 4500000, 'NVMe Gen4 7000MB/s', 'sabrent_rocket_4tb.jpg', 5, 40, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (271, 'Cooler Master MWE 650 - 80 Plus Bronze - V3 230V (650W)', 1500000, 'TDP: 0W', 'corsair_rm850e.jpg', 85, 100, '2026-06-27T05:52:56.680Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (272, 'Nguồn FSP HV PRO 650W - 80 Plus Bronze', 1400000, 'TDP: 0W', 'corsair_rm850e.jpg', 85, 100, '2026-06-27T05:52:57.170Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (273, 'Corsair CX650 - 80 Plus Bronze (650W)', 1600000, 'TDP: 0W', 'corsair_rm850e.jpg', 85, 100, '2026-06-27T05:52:57.668Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (274, 'Corsair 3500X TG Mid Tower Black', 2000000, 'TDP: 0W', 'corsair_rm850e.jpg', 86, 99, '2026-06-27T05:52:58.157Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (275, 'Corsair FRAME 4500X RS-R ARGB Panoramic Black', 3500000, 'TDP: 0W', 'galax_hof_32gb.jpg', 86, 98, '2026-06-27T05:52:58.657Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (276, 'Tản nhiệt AIO Corsair NAUTILUS 360 ARGB Black', 2800000, 'TDP: 15W', 'corsair_rm850e.jpg', 8, 97, '2026-06-27T05:52:59.350Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (270, 'Corsair RM850e ATX 3.1 - 80 Plus Gold - Full Modular (850W)', 3500000, 'TDP: 0W', 'corsair_rm850e.jpg', 85, 97, '2026-06-27T05:52:56.192Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (138, 'Silicon Power UD90 1650000', 1650000, 'Gen4 Value', 'corsair_3500x_black.png', 5, 60, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (140, 'KC3000 1TB', 2450000, 'Fast Gen4 OS', 'corsair_3500x_black.png', 5, 40, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (166, 'Nitro VG271U', 6500000, '27" 2K 144Hz', 'corsair_3500x_black.png', 6, 45, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (171, 'ProArt PA278QV', 8900000, 'Color Accurate', 'corsair_3500x_black.png', 6, 18, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (172, 'HKC ANT27TQC', 5500000, 'Budget 2K Curved', 'corsair_3500x_black.png', 6, 55, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (200, 'Gigabyte Z790 AORUS XTREME X', 25374600, 'LGA1700, 24+1+2 Phases, Wi-Fi 7, PCIe 5.0 x16', 'z790_dark_kingpin.jpg', 4, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (202, 'Gigabyte M27Q Gaming Monitor', 7594600, '27-inch, Super Speed IPS, 2560x1440, 170Hz', 'samsung_990pro.jpg', 6, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (203, 'Gigabyte AORUS FO32U2P', 30454600, '32-inch, OLED (QD-OLED), 3840x2160, DP 2.1 UHBR20 supported', 'corsair_3500x_black.png', 6, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (209, 'Corsair iCUE LINK H150i LCD Liquid CPU Cooler', 7340600, '360mm, 3x QX120 RGB Fans, 2.1-inch IPS Display, iCUE LINK Ecosystem', 'i9_14900k.jpg', 87, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (210, 'Corsair 5000D AIRFLOW Tempered Glass Mid-Tower', 4165600, 'Mid-Tower, Black, RapidRoute System, Up to 10x 120mm fans', 'corsair_rm850e.jpg', 86, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (185, 'AMD Radeon RX 7800 XT GPU', 12674600, '16GB GDDR6, 64MB, 263W', 'asus_rog_rtx_4090.jpg', 2, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (174, 'Dell E2222H', 2200000, 'Office 22"', 'corsair_3500x_black.png', 6, 150, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (230, 'Samsung 990 EVO PCIe 4.0 x4 / 5.0 x2 M.2 SSD 1TB', 2260600, '1TB, Up to 5000 MB/s, Up to 4200 MB/s', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (207, 'Corsair Dominator Titanium RGB DDR5 32GB (2x16GB)6000MHz', 4673600, '32GB, 6000 MT/s, CL30, Intel XMP 3.0 / AMD EXPO', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (194, 'MSI MAG B650 TOMAHAWK WIFI', 5562600, 'AM5, AMD B650, DDR5 7600+(OC), Realtek 2.5Gbps LAN', 'z790_dark_kingpin.jpg', 4, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (197, 'MSI MEG MAESTRO 700L PZ', 10642600, 'ATX Full Tower, Curved Tempered Glass, Back-connect (Project Zero) support', 'corsair_3500x_black.png', 86, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (201, 'Gigabyte X670E AORUS MASTER', 11404600, 'AM5, AMD X670E, 4x M.2 PCIe 5.0, Intel 2.5GbE LAN', 'z790_dark_kingpin.jpg', 4, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (204, 'Gigabyte AORUS Gen5 12000 SSD 2TB', 8102600, 'PCIe 5.0 x4, NVMe 2.0, 12,400 MB/s, 11,800 MB/s', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (208, 'Corsair Vengeance RGB DDR5 64GB (2x32GB)5600MHz', 5562600, '64GB, 5600 MT/s, CL40', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (211, 'Corsair iCUE LINK 6500X RGB Mid-Tower DualChamber', 5054600, 'Dual Chamber Layout, Reverse-connector support, Front & Side Tempered Glass', 'corsair_rm850e.jpg', 86, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (214, 'Corsair K100 RGB Mechanical Gaming Keyboard', 6324600, 'Corsair OPX Optical-Mechanical, AXON 4000Hz Hyper-polling, iCUE Control Wheel', 'corsair_rm850e.jpg', 89, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (218, 'Logitech G502 X LIGHTSPEED Wireless GamingMouse', 3530600, 'HERO 25K Sensor, 13 programmable controls, Dual-mode infinite scroll', 'corsair_3500x_black.png', 90, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (222, 'Logitech MX Master 3S Wireless Mouse', 2514600, '8K DPI tracking on any surface, Quiet clicks technology, MagSpeed Electromagnetic scrolling', 'corsair_3500x_black.png', 90, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (226, 'Razer Huntsman V3 Pro TKL Mechanical Keyboard', 5562600, 'Razer Analog Optical Switches Gen-2, Rapid Trigger mode with adjustable actuation (0.1- 4.0mm), Dual-purpose digital dial', 'corsair_3500x_black.png', 89, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (231, 'Samsung T7 Shield Portable SSD 2TB', 4292600, '2TB, USB 3.2 Gen 2 (10Gbps), IP65 water & dust resistant, 3-meter drop proof', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (234, 'Samsung Galaxy Buds3 Pro', 6324600, 'Hi-Fi 24-bit Ultra High Quality Audio, Adaptive Noise Cancelling with Blade Lights, Stem style ergonomic fit', 'sabrent_rocket_4tb.jpg', 91, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (239, 'Kingston FURY Impact DDR5 SO-DIMM 32GB (2x16GB) 5600MHz', 3149600, 'Laptop Memory (SO-DIMM), 32GB Kit, 5600 MT/s', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (242, 'Noctua NH-D15 chromax.black Dual-Tower Cooler', 3022600, '2x NF-A15 HS-PWM fans, Full black design, Intel LGA1700/AM5 ready', 'rog_ryujin_360.jpg', 87, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (245, 'SteelSeries Arctis Nova Pro Wireless Headset', 8864600, 'Nova Pro Acoustic System, Active Noise Cancellation with Transparency Mode, Dual Battery Infinity System', 'corsair_3500x_black.png', 91, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (248, 'Crucial Pro DDR5 48GB (2x24GB) 5600MHz Kit', 3784600, '48GB Kit, 5600 MT/s, Low-profile aluminum black heatsink', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (249, 'Fractal Design North Charcoal Black WoodMid-Tower', 3530600, 'Real walnut wood front panel struts, Mesh or Tempered Glass available, 2x Aspect 14 PWM fans', 'corsair_3500x_black.png', 86, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (250, 'Lian Li O11 Dynamic EVO RGB Black', 4292600, 'Dual-chamber adjustable ATX case, Two L-shaped diffuse LED RGB strips, Reversible design architecture', 'corsair_3500x_black.png', 86, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (252, 'EVGA SuperNOVA 1000 G7 Gold Modular PSU', 4800600, '1000W, 80 PLUS Gold Certified, Ultra-compact 130mm chassis size', 'asus_rog_rtx_4090.jpg', 85, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (253, 'DeepCool AK620 Digital Dual-Tower Air Cooler', 2006600, 'Real-time temperature and usage status top screen, 2x FK120 fluid dynamic bearing fans, 6x 6mm copper heatpipes', 'rog_ryujin_360.jpg', 87, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (254, 'Thermalright Peerless Assassin 120 SE AirCooler', 990600, 'Dual tower heatsink design, 2x TL-C12C 120mm PWM fans, 155mm standard height', 'rog_ryujin_360.jpg', 87, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (182, 'Intel Arc A750 Graphics Card', 6324600, '8GB GDDR6, 256-bit, 2050 MHz, 225W', 'asus_rog_rtx_4090.jpg', 2, 49, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (247, 'Sony WH-1000XM5 Wireless Noise CancelingHeadphones', 10134600, 'Integrated Processor V1 & HD Noise CancelingProcessor QN1, 8 microphones for extreme voice pick up, Up to 30 hours total life', 'corsair_3500x_black.png', 91, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (251, 'Lian Li UNI FAN TL LCD 120 Triple Pack Black', 3784600, '120mm fans, Built-in 1.6-inch LCD screen on center fan, Daisy-chain interlocking mechanism', 'rog_ryujin_360.jpg', 88, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (255, 'Be Quiet! Dark Power 13 1000W Titanium ATX 3.0PSU', 7340600, '1000W, 80 PLUS Titanium (up to 95.8%), Frameless Silent Wings fan optimization', 'corsair_rm850e.jpg', 85, 50, '2026-06-05T03:05:55.522Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (7, 'Intel Core i9-13900KS', 18500000, 'Special Edition, 6.0GHz', 'i9_14900k.jpg', 1, 0, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (12, 'AMD Ryzen 5 5600G', 3200000, 'Integrated Vega Graphics', 'i9_14900k.jpg', 1, 71, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (23, 'Intel Core i9-11900K', 6500000, 'Legacy Flagship LGA 1200', 'i9_14900k.jpg', 1, 9, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (54, 'Quadro RTX A4000', 22000000, 'Workstation GPU', 'asus_rog_rtx_4090.jpg', 2, 0, '2026-04-06T06:46:29.076Z', NULL);
INSERT INTO public."products" ("id", "name", "price", "description", "image", "category_id", "stock", "created_at", "brand") VALUES (89, 'Galax HOF 32GB', 5500000, '8000MHz White OC', 'galax_hof_32gb.jpg', 3, 3, '2026-04-06T06:46:29.076Z', NULL);

-- Data for Name: chat_messages;
INSERT INTO public."chat_messages" ("id", "created_at", "message", "sender", "sender_name", "ticket_id") VALUES (52, '2026-07-13T12:25:31.798Z', 'j', 'ADMIN', 'tuan9bledinhchinh@gmail.com', 7);
INSERT INTO public."chat_messages" ("id", "created_at", "message", "sender", "sender_name", "ticket_id") VALUES (53, '2026-07-14T02:45:55.056Z', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', '36', 8);
INSERT INTO public."chat_messages" ("id", "created_at", "message", "sender", "sender_name", "ticket_id") VALUES (54, '2026-07-14T02:45:58.208Z', 'cc', 'CUSTOMER', '36', 8);
INSERT INTO public."chat_messages" ("id", "created_at", "message", "sender", "sender_name", "ticket_id") VALUES (55, '2026-07-14T02:45:59.481Z', 'Cảm ơn bạn đã nhắn tin cho ban hỗ trợ khách hàng Luxury PC. Nhân viên tư vấn đang kiểm tra thông tin và sẽ phản hồi chi tiết tới bạn trong giây lát! Bạn vui lòng đợi 1-2 phút nhé. 💬', 'ADMIN', 'tuan9bledinhchinh@gmail.com', 8);
INSERT INTO public."chat_messages" ("id", "created_at", "message", "sender", "sender_name", "ticket_id") VALUES (56, '2026-07-14T02:46:00.771Z', 'c', 'CUSTOMER', '36', 8);
INSERT INTO public."chat_messages" ("id", "created_at", "message", "sender", "sender_name", "ticket_id") VALUES (57, '2026-07-14T02:46:02.628Z', 'Cảm ơn bạn đã nhắn tin cho ban hỗ trợ khách hàng Luxury PC. Nhân viên tư vấn đang kiểm tra thông tin và sẽ phản hồi chi tiết tới bạn trong giây lát! Bạn vui lòng đợi 1-2 phút nhé. 💬', 'ADMIN', 'tuan9bledinhchinh@gmail.com', 8);
INSERT INTO public."chat_messages" ("id", "created_at", "message", "sender", "sender_name", "ticket_id") VALUES (58, '2026-07-14T02:46:05.480Z', 'c', 'CUSTOMER', '36', 8);
INSERT INTO public."chat_messages" ("id", "created_at", "message", "sender", "sender_name", "ticket_id") VALUES (59, '2026-07-14T02:46:06.633Z', 'Cảm ơn bạn đã nhắn tin cho ban hỗ trợ khách hàng Luxury PC. Nhân viên tư vấn đang kiểm tra thông tin và sẽ phản hồi chi tiết tới bạn trong giây lát! Bạn vui lòng đợi 1-2 phút nhé. 💬', 'ADMIN', 'tuan9bledinhchinh@gmail.com', 8);
INSERT INTO public."chat_messages" ("id", "created_at", "message", "sender", "sender_name", "ticket_id") VALUES (60, '2026-07-14T06:29:48.682Z', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', 'Thanh', 9);
INSERT INTO public."chat_messages" ("id", "created_at", "message", "sender", "sender_name", "ticket_id") VALUES (61, '2026-07-14T06:30:09.937Z', 'alo em à em', 'CUSTOMER', 'Thanh', 9);
INSERT INTO public."chat_messages" ("id", "created_at", "message", "sender", "sender_name", "ticket_id") VALUES (62, '2026-07-14T06:30:11.141Z', 'Cảm ơn bạn đã nhắn tin cho ban hỗ trợ khách hàng Luxury PC. Nhân viên tư vấn đang kiểm tra thông tin và sẽ phản hồi chi tiết tới bạn trong giây lát! Bạn vui lòng đợi 1-2 phút nhé. 💬', 'ADMIN', 'leecookcu@gmail.com', 9);
INSERT INTO public."chat_messages" ("id", "created_at", "message", "sender", "sender_name", "ticket_id") VALUES (63, '2026-07-14T10:19:19.185Z', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', '36', 10);
INSERT INTO public."chat_messages" ("id", "created_at", "message", "sender", "sender_name", "ticket_id") VALUES (64, '2026-07-15T03:47:51.945Z', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', 'Thanh', 11);

-- Data for Name: flash_sale_items;
INSERT INTO public."flash_sale_items" ("id", "sale_price", "sale_quantity", "sold_count", "flash_sale_id", "product_id") VALUES (4, 10000000, 50, 10, 5, 54);
INSERT INTO public."flash_sale_items" ("id", "sale_price", "sale_quantity", "sold_count", "flash_sale_id", "product_id") VALUES (3, 3000000, 30, 30, 5, 13);
INSERT INTO public."flash_sale_items" ("id", "sale_price", "sale_quantity", "sold_count", "flash_sale_id", "product_id") VALUES (5, 3000000, 50, 40, 5, 3);
INSERT INTO public."flash_sale_items" ("id", "sale_price", "sale_quantity", "sold_count", "flash_sale_id", "product_id") VALUES (7, 400000, 50, 0, 5, 277);
INSERT INTO public."flash_sale_items" ("id", "sale_price", "sale_quantity", "sold_count", "flash_sale_id", "product_id") VALUES (8, 2000000, 20, 0, 5, 257);
INSERT INTO public."flash_sale_items" ("id", "sale_price", "sale_quantity", "sold_count", "flash_sale_id", "product_id") VALUES (9, 2000000, 50, 0, 6, 257);
INSERT INTO public."flash_sale_items" ("id", "sale_price", "sale_quantity", "sold_count", "flash_sale_id", "product_id") VALUES (10, 499000, 99, 0, 6, 277);
INSERT INTO public."flash_sale_items" ("id", "sale_price", "sale_quantity", "sold_count", "flash_sale_id", "product_id") VALUES (11, 8399000, 100, 0, 6, 286);
INSERT INTO public."flash_sale_items" ("id", "sale_price", "sale_quantity", "sold_count", "flash_sale_id", "product_id") VALUES (12, 13999999, 49, 0, 6, 279);
INSERT INTO public."flash_sale_items" ("id", "sale_price", "sale_quantity", "sold_count", "flash_sale_id", "product_id") VALUES (13, 10000000, 97, 0, 6, 256);
INSERT INTO public."flash_sale_items" ("id", "sale_price", "sale_quantity", "sold_count", "flash_sale_id", "product_id") VALUES (15, 699000, 100, 0, 6, 16);
INSERT INTO public."flash_sale_items" ("id", "sale_price", "sale_quantity", "sold_count", "flash_sale_id", "product_id") VALUES (16, 1100000, 10, 0, 6, 24);
INSERT INTO public."flash_sale_items" ("id", "sale_price", "sale_quantity", "sold_count", "flash_sale_id", "product_id") VALUES (17, 9999999, 20, 0, 6, 35);
INSERT INTO public."flash_sale_items" ("id", "sale_price", "sale_quantity", "sold_count", "flash_sale_id", "product_id") VALUES (18, 1300000, 15, 0, 6, 84);

-- Data for Name: flash_sales;
INSERT INTO public."flash_sales" ("id", "active", "created_at", "end_time", "name", "start_time") VALUES (5, false, '2026-06-22T01:58:57.040Z', '2026-07-08T05:00:00.000Z', 'SALE7/7', '2026-07-07T05:00:00.000Z');
INSERT INTO public."flash_sales" ("id", "active", "created_at", "end_time", "name", "start_time") VALUES (6, true, '2026-06-22T01:58:57.075Z', '2026-08-08T05:00:00.000Z', 'SALE8/7', '2026-07-07T05:00:00.000Z');

-- Data for Name: reviews;
INSERT INTO public."reviews" ("id", "content", "created_at", "stars", "user_id", "product_id", "order_id", "title", "image", "video") VALUES (37, 'Máy build từ Luxury PC chạy mượt như mơ. RTX 4090 kết hợp với i9-14900K — không có game nào kháng cự được. Đáng từng đồng bỏ ra.', '2026-06-02T12:05:41.163Z', 5, 7, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public."reviews" ("id", "content", "created_at", "stars", "user_id", "product_id", "order_id", "title", "image", "video") VALUES (38, 'Dịch vụ tư vấn chuyên nghiệp, lắp ráp cực kỳ thẩm mỹ. Tôi rất hài lòng với chiếc Workstation mới này.', '2026-06-02T12:05:41.163Z', 5, 7, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public."reviews" ("id", "content", "created_at", "stars", "user_id", "product_id", "order_id", "title", "image", "video") VALUES (39, 'Bảo hành nhanh chóng, nhân viên nhiệt tình hỗ trợ. Xứng đáng với danh hiệu Luxury PC.', '2026-06-02T12:05:41.163Z', 4, 7, NULL, NULL, NULL, NULL, NULL);

-- Data for Name: shipping_addresses;
INSERT INTO public."shipping_addresses" ("id", "address", "city", "is_default", "district", "phone", "recipient_name", "user_id") VALUES (14, 'd', 'Thành phố Hồ Chí Minh', false, 'v', '0869949147', 'v', 9);
INSERT INTO public."shipping_addresses" ("id", "address", "city", "is_default", "district", "phone", "recipient_name", "user_id") VALUES (13, 'v', 'Thành phố Hồ Chí Minh', true, '1', '0905338411', 'v', 9);
INSERT INTO public."shipping_addresses" ("id", "address", "city", "is_default", "district", "phone", "recipient_name", "user_id") VALUES (17, 'Q12', '02 - Thành phố Hồ Chí Minh', false, 'Q12', '0902208461', 'Khang', 29);
INSERT INTO public."shipping_addresses" ("id", "address", "city", "is_default", "district", "phone", "recipient_name", "user_id") VALUES (16, 'Q12', '02 - Thành phố Hồ Chí Minh', false, 'Q12', '0902208461', 'Khang Bá', 29);
INSERT INTO public."shipping_addresses" ("id", "address", "city", "is_default", "district", "phone", "recipient_name", "user_id") VALUES (18, 'trang nha, nha trang', 'TP.NhaTrang', false, 'quận trang nha', '0936629311', 'Khang Khang', 29);
INSERT INTO public."shipping_addresses" ("id", "address", "city", "is_default", "district", "phone", "recipient_name", "user_id") VALUES (15, 'Q122', '02 - Thành phố Hồ Chí Minh', false, 'Q12', '0902208461', 'Bá Khang', 29);
INSERT INTO public."shipping_addresses" ("id", "address", "city", "is_default", "district", "phone", "recipient_name", "user_id") VALUES (19, 'KonTum', 'KonTum', true, 'TumKon', '0901560861', 'Bá Bá', 29);

-- Data for Name: spring_session;
INSERT INTO public."spring_session" ("primary_id", "session_id", "creation_time", "last_access_time", "max_inactive_interval", "expiry_time", "principal_name") VALUES ('82866743-8dff-44a6-a51b-9762bc0f05ca', '0536cba6-45f0-44e5-a014-d22ba9545c5f', '1782004704449', '1782011856560', 1800, '1782013656560', 'tuan9bledinhchinh@gmail.com');

-- Data for Name: spring_session_attributes;
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('8aca5fa4-1bd3-4ba6-9341-c12559c3abc2', 'cart', '{"type":"Buffer","data":[172,237,0,5,115,114,0,17,106,97,118,97,46,117,116,105,108,46,72,97,115,104,77,97,112,5,7,218,193,195,22,96,209,3,0,2,70,0,10,108,111,97,100,70,97,99,116,111,114,73,0,9,116,104,114,101,115,104,111,108,100,120,112,63,64,0,0,0,0,0,0,119,8,0,0,0,16,0,0,0,0,120]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('8aca5fa4-1bd3-4ba6-9341-c12559c3abc2', 'SPRING_SECURITY_LAST_EXCEPTION', '{"type":"Buffer","data":[172,237,0,5,115,114,0,70,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,111,97,117,116,104,50,46,99,111,114,101,46,79,65,117,116,104,50,65,117,116,104,101,110,116,105,99,97,116,105,111,110,69,120,99,101,112,116,105,111,110,147,78,174,114,251,69,95,130,2,0,1,76,0,5,101,114,114,111,114,116,0,54,76,111,114,103,47,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,47,115,101,99,117,114,105,116,121,47,111,97,117,116,104,50,47,99,111,114,101,47,79,65,117,116,104,50,69,114,114,111,114,59,120,114,0,57,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,65,117,116,104,101,110,116,105,99,97,116,105,111,110,69,120,99,101,112,116,105,111,110,28,4,81,48,226,11,103,84,2,0,0,120,114,0,26,106,97,118,97,46,108,97,110,103,46,82,117,110,116,105,109,101,69,120,99,101,112,116,105,111,110,158,95,6,71,10,52,131,229,2,0,0,120,114,0,19,106,97,118,97,46,108,97,110,103,46,69,120,99,101,112,116,105,111,110,208,253,31,62,26,59,28,196,2,0,0,120,114,0,19,106,97,118,97,46,108,97,110,103,46,84,104,114,111,119,97,98,108,101,213,198,53,39,57,119,184,203,3,0,4,76,0,5,99,97,117,115,101,116,0,21,76,106,97,118,97,47,108,97,110,103,47,84,104,114,111,119,97,98,108,101,59,76,0,13,100,101,116,97,105,108,77,101,115,115,97,103,101,116,0,18,76,106,97,118,97,47,108,97,110,103,47,83,116,114,105,110,103,59,91,0,10,115,116,97,99,107,84,114,97,99,101,116,0,30,91,76,106,97,118,97,47,108,97,110,103,47,83,116,97,99,107,84,114,97,99,101,69,108,101,109,101,110,116,59,76,0,20,115,117,112,112,114,101,115,115,101,100,69,120,99,101,112,116,105,111,110,115,116,0,16,76,106,97,118,97,47,117,116,105,108,47,76,105,115,116,59,120,112,112,116,0,34,91,97,117,116,104,111,114,105,122,97,116,105,111,110,95,114,101,113,117,101,115,116,95,110,111,116,95,102,111,117,110,100,93,32,117,114,0,30,91,76,106,97,118,97,46,108,97,110,103,46,83,116,97,99,107,84,114,97,99,101,69,108,101,109,101,110,116,59,2,70,42,60,60,253,34,57,2,0,0,120,112,0,0,0,92,115,114,0,27,106,97,118,97,46,108,97,110,103,46,83,116,97,99,107,84,114,97,99,101,69,108,101,109,101,110,116,97,9,197,154,38,54,221,133,2,0,8,66,0,6,102,111,114,109,97,116,73,0,10,108,105,110,101,78,117,109,98,101,114,76,0,15,99,108,97,115,115,76,111,97,100,101,114,78,97,109,101,113,0,126,0,7,76,0,14,100,101,99,108,97,114,105,110,103,67,108,97,115,115,113,0,126,0,7,76,0,8,102,105,108,101,78,97,109,101,113,0,126,0,7,76,0,10,109,101,116,104,111,100,78,97,109,101,113,0,126,0,7,76,0,10,109,111,100,117,108,101,78,97,109,101,113,0,126,0,7,76,0,13,109,111,100,117,108,101,86,101,114,115,105,111,110,113,0,126,0,7,120,112,1,0,0,0,173,116,0,3,97,112,112,116,0,78,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,111,97,117,116,104,50,46,99,108,105,101,110,116,46,119,101,98,46,79,65,117,116,104,50,76,111,103,105,110,65,117,116,104,101,110,116,105,99,97,116,105,111,110,70,105,108,116,101,114,116,0,36,79,65,117,116,104,50,76,111,103,105,110,65,117,116,104,101,110,116,105,99,97,116,105,111,110,70,105,108,116,101,114,46,106,97,118,97,116,0,21,97,116,116,101,109,112,116,65,117,116,104,101,110,116,105,99,97,116,105,111,110,112,112,115,113,0,126,0,14,1,0,0,0,231,113,0,126,0,16,116,0,86,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,65,98,115,116,114,97,99,116,65,117,116,104,101,110,116,105,99,97,116,105,111,110,80,114,111,99,101,115,115,105,110,103,70,105,108,116,101,114,116,0,43,65,98,115,116,114,97,99,116,65,117,116,104,101,110,116,105,99,97,116,105,111,110,80,114,111,99,101,115,115,105,110,103,70,105,108,116,101,114,46,106,97,118,97,116,0,8,100,111,70,105,108,116,101,114,112,112,115,113,0,126,0,14,1,0,0,0,221,113,0,126,0,16,113,0,126,0,21,113,0,126,0,22,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,240,113,0,126,0,16,116,0,82,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,79,98,115,101,114,118,97,116,105,111,110,70,105,108,116,101,114,67,104,97,105,110,68,101,99,111,114,97,116,111,114,36,79,98,115,101,114,118,97,116,105,111,110,70,105,108,116,101,114,116,0,36,79,98,115,101,114,118,97,116,105,111,110,70,105,108,116,101,114,67,104,97,105,110,68,101,99,111,114,97,116,111,114,46,106,97,118,97,116,0,10,119,114,97,112,70,105,108,116,101,114,112,112,115,113,0,126,0,14,1,0,0,0,227,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,137,113,0,126,0,16,116,0,83,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,79,98,115,101,114,118,97,116,105,111,110,70,105,108,116,101,114,67,104,97,105,110,68,101,99,111,114,97,116,111,114,36,86,105,114,116,117,97,108,70,105,108,116,101,114,67,104,97,105,110,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,181,113,0,126,0,16,116,0,87,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,111,97,117,116,104,50,46,99,108,105,101,110,116,46,119,101,98,46,79,65,117,116,104,50,65,117,116,104,111,114,105,122,97,116,105,111,110,82,101,113,117,101,115,116,82,101,100,105,114,101,99,116,70,105,108,116,101,114,116,0,45,79,65,117,116,104,50,65,117,116,104,111,114,105,122,97,116,105,111,110,82,101,113,117,101,115,116,82,101,100,105,114,101,99,116,70,105,108,116,101,114,46,106,97,118,97,116,0,16,100,111,70,105,108,116,101,114,73,110,116,101,114,110,97,108,112,112,115,113,0,126,0,14,1,0,0,0,116,113,0,126,0,16,116,0,51,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,119,101,98,46,102,105,108,116,101,114,46,79,110,99,101,80,101,114,82,101,113,117,101,115,116,70,105,108,116,101,114,116,0,25,79,110,99,101,80,101,114,82,101,113,117,101,115,116,70,105,108,116,101,114,46,106,97,118,97,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,240,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,28,112,112,115,113,0,126,0,14,1,0,0,0,227,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,137,113,0,126,0,16,113,0,126,0,31,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,107,113,0,126,0,16,116,0,67,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,108,111,103,111,117,116,46,76,111,103,111,117,116,70,105,108,116,101,114,116,0,17,76,111,103,111,117,116,70,105,108,116,101,114,46,106,97,118,97,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,93,113,0,126,0,16,113,0,126,0,43,113,0,126,0,44,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,240,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,28,112,112,115,113,0,126,0,14,1,0,0,0,227,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,137,113,0,126,0,16,113,0,126,0,31,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,91,113,0,126,0,16,116,0,41,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,119,101,98,46,102,105,108,116,101,114,46,67,111,114,115,70,105,108,116,101,114,116,0,15,67,111,114,115,70,105,108,116,101,114,46,106,97,118,97,113,0,126,0,35,112,112,115,113,0,126,0,14,1,0,0,0,116,113,0,126,0,16,113,0,126,0,37,113,0,126,0,38,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,240,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,28,112,112,115,113,0,126,0,14,1,0,0,0,227,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,137,113,0,126,0,16,113,0,126,0,31,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,90,113,0,126,0,16,116,0,58,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,104,101,97,100,101,114,46,72,101,97,100,101,114,87,114,105,116,101,114,70,105,108,116,101,114,116,0,23,72,101,97,100,101,114,87,114,105,116,101,114,70,105,108,116,101,114,46,106,97,118,97,116,0,14,100,111,72,101,97,100,101,114,115,65,102,116,101,114,112,112,115,113,0,126,0,14,1,0,0,0,75,113,0,126,0,16,113,0,126,0,57,113,0,126,0,58,113,0,126,0,35,112,112,115,113,0,126,0,14,1,0,0,0,116,113,0,126,0,16,113,0,126,0,37,113,0,126,0,38,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,240,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,28,112,112,115,113,0,126,0,14,1,0,0,0,227,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,137,113,0,126,0,16,113,0,126,0,31,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,82,113,0,126,0,16,116,0,68,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,99,111,110,116,101,120,116,46,83,101,99,117,114,105,116,121,67,111,110,116,101,120,116,72,111,108,100,101,114,70,105,108,116,101,114,116,0,32,83,101,99,117,114,105,116,121,67,111,110,116,101,120,116,72,111,108,100,101,114,70,105,108,116,101,114,46,106,97,118,97,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,69,113,0,126,0,16,113,0,126,0,66,113,0,126,0,67,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,240,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,28,112,112,115,113,0,126,0,14,1,0,0,0,227,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,137,113,0,126,0,16,113,0,126,0,31,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,62,113,0,126,0,16,116,0,87,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,99,111,110,116,101,120,116,46,114,101,113,117,101,115,116,46,97,115,121,110,99,46,87,101,98,65,115,121,110,99,77,97,110,97,103,101,114,73,110,116,101,103,114,97,116,105,111,110,70,105,108,116,101,114,116,0,37,87,101,98,65,115,121,110,99,77,97,110,97,103,101,114,73,110,116,101,103,114,97,116,105,111,110,70,105,108,116,101,114,46,106,97,118,97,113,0,126,0,35,112,112,115,113,0,126,0,14,1,0,0,0,116,113,0,126,0,16,113,0,126,0,37,113,0,126,0,38,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,240,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,28,112,112,115,113,0,126,0,14,1,0,0,0,227,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,137,113,0,126,0,16,113,0,126,0,31,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,42,113,0,126,0,16,116,0,63,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,115,101,115,115,105,111,110,46,68,105,115,97,98,108,101,69,110,99,111,100,101,85,114,108,70,105,108,116,101,114,116,0,27,68,105,115,97,98,108,101,69,110,99,111,100,101,85,114,108,70,105,108,116,101,114,46,106,97,118,97,113,0,126,0,35,112,112,115,113,0,126,0,14,1,0,0,0,116,113,0,126,0,16,113,0,126,0,37,113,0,126,0,38,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,240,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,28,112,112,115,113,0,126,0,14,1,0,0,1,67,113,0,126,0,16,116,0,118,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,79,98,115,101,114,118,97,116,105,111,110,70,105,108,116,101,114,67,104,97,105,110,68,101,99,111,114,97,116,111,114,36,65,114,111,117,110,100,70,105,108,116,101,114,79,98,115,101,114,118,97,116,105,111,110,36,83,105,109,112,108,101,65,114,111,117,110,100,70,105,108,116,101,114,79,98,115,101,114,118,97,116,105,111,110,113,0,126,0,27,116,0,13,108,97,109,98,100,97,36,119,114,97,112,36,48,112,112,115,113,0,126,0,14,1,0,0,0,224,113,0,126,0,16,113,0,126,0,26,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,137,113,0,126,0,16,113,0,126,0,31,113,0,126,0,27,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,233,113,0,126,0,16,116,0,49,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,70,105,108,116,101,114,67,104,97,105,110,80,114,111,120,121,116,0,21,70,105,108,116,101,114,67,104,97,105,110,80,114,111,120,121,46,106,97,118,97,113,0,126,0,35,112,112,115,113,0,126,0,14,1,0,0,0,191,113,0,126,0,16,113,0,126,0,90,113,0,126,0,91,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,113,113,0,126,0,16,116,0,65,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,119,101,98,46,102,105,108,116,101,114,46,67,111,109,112,111,115,105,116,101,70,105,108,116,101,114,36,86,105,114,116,117,97,108,70,105,108,116,101,114,67,104,97,105,110,116,0,20,67,111,109,112,111,115,105,116,101,70,105,108,116,101,114,46,106,97,118,97,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,195,113,0,126,0,16,116,0,66,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,119,101,98,46,115,101,114,118,108,101,116,46,104,97,110,100,108,101,114,46,72,97,110,100,108,101,114,77,97,112,112,105,110,103,73,110,116,114,111,115,112,101,99,116,111,114,116,0,31,72,97,110,100,108,101,114,77,97,112,112,105,110,103,73,110,116,114,111,115,112,101,99,116,111,114,46,106,97,118,97,116,0,26,108,97,109,98,100,97,36,99,114,101,97,116,101,67,97,99,104,101,70,105,108,116,101,114,36,51,112,112,115,113,0,126,0,14,1,0,0,0,113,113,0,126,0,16,113,0,126,0,94,113,0,126,0,95,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,74,113,0,126,0,16,116,0,46,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,119,101,98,46,102,105,108,116,101,114,46,67,111,109,112,111,115,105,116,101,70,105,108,116,101,114,113,0,126,0,95,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,230,113,0,126,0,16,116,0,118,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,110,102,105,103,46,97,110,110,111,116,97,116,105,111,110,46,119,101,98,46,99,111,110,102,105,103,117,114,97,116,105,111,110,46,87,101,98,77,118,99,83,101,99,117,114,105,116,121,67,111,110,102,105,103,117,114,97,116,105,111,110,36,67,111,109,112,111,115,105,116,101,70,105,108,116,101,114,67,104,97,105,110,80,114,111,120,121,116,0,32,87,101,98,77,118,99,83,101,99,117,114,105,116,121,67,111,110,102,105,103,117,114,97,116,105,111,110,46,106,97,118,97,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,1,96,113,0,126,0,16,116,0,52,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,119,101,98,46,102,105,108,116,101,114,46,68,101,108,101,103,97,116,105,110,103,70,105,108,116,101,114,80,114,111,120,121,116,0,26,68,101,108,101,103,97,116,105,110,103,70,105,108,116,101,114,80,114,111,120,121,46,106,97,118,97,116,0,14,105,110,118,111,107,101,68,101,108,101,103,97,116,101,112,112,115,113,0,126,0,14,1,0,0,1,12,113,0,126,0,16,113,0,126,0,107,113,0,126,0,108,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,174,113,0,126,0,16,116,0,47,111,114,103,46,97,112,97,99,104,101,46,99,97,116,97,108,105,110,97,46,99,111,114,101,46,65,112,112,108,105,99,97,116,105,111,110,70,105,108,116,101,114,67,104,97,105,110,116,0,27,65,112,112,108,105,99,97,116,105,111,110,70,105,108,116,101,114,67,104,97,105,110,46,106,97,118,97,116,0,16,105,110,116,101,114,110,97,108,68,111,70,105,108,116,101,114,112,112,115,113,0,126,0,14,1,0,0,0,149,113,0,126,0,16,113,0,126,0,112,113,0,126,0,113,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,100,113,0,126,0,16,116,0,51,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,119,101,98,46,102,105,108,116,101,114,46,82,101,113,117,101,115,116,67,111,110,116,101,120,116,70,105,108,116,101,114,116,0,25,82,101,113,117,101,115,116,67,111,110,116,101,120,116,70,105,108,116,101,114,46,106,97,118,97,113,0,126,0,35,112,112,115,113,0,126,0,14,1,0,0,0,116,113,0,126,0,16,113,0,126,0,37,113,0,126,0,38,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,174,113,0,126,0,16,113,0,126,0,112,113,0,126,0,113,113,0,126,0,114,112,112,115,113,0,126,0,14,1,0,0,0,149,113,0,126,0,16,113,0,126,0,112,113,0,126,0,113,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,93,113,0,126,0,16,116,0,48,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,119,101,98,46,102,105,108,116,101,114,46,70,111,114,109,67,111,110,116,101,110,116,70,105,108,116,101,114,116,0,22,70,111,114,109,67,111,110,116,101,110,116,70,105,108,116,101,114,46,106,97,118,97,113,0,126,0,35,112,112,115,113,0,126,0,14,1,0,0,0,116,113,0,126,0,16,113,0,126,0,37,113,0,126,0,38,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,174,113,0,126,0,16,113,0,126,0,112,113,0,126,0,113,113,0,126,0,114,112,112,115,113,0,126,0,14,1,0,0,0,149,113,0,126,0,16,113,0,126,0,112,113,0,126,0,113,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,142,113,0,126,0,16,116,0,60,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,115,115,105,111,110,46,119,101,98,46,104,116,116,112,46,83,101,115,115,105,111,110,82,101,112,111,115,105,116,111,114,121,70,105,108,116,101,114,116,0,28,83,101,115,115,105,111,110,82,101,112,111,115,105,116,111,114,121,70,105,108,116,101,114,46,106,97,118,97,113,0,126,0,35,112,112,115,113,0,126,0,14,1,0,0,0,82,113,0,126,0,16,116,0,57,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,115,115,105,111,110,46,119,101,98,46,104,116,116,112,46,79,110,99,101,80,101,114,82,101,113,117,101,115,116,70,105,108,116,101,114,113,0,126,0,38,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,1,96,113,0,126,0,16,113,0,126,0,107,113,0,126,0,108,113,0,126,0,109,112,112,115,113,0,126,0,14,1,0,0,1,12,113,0,126,0,16,113,0,126,0,107,113,0,126,0,108,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,174,113,0,126,0,16,113,0,126,0,112,113,0,126,0,113,113,0,126,0,114,112,112,115,113,0,126,0,14,1,0,0,0,149,113,0,126,0,16,113,0,126,0,112,113,0,126,0,113,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,109,113,0,126,0,16,116,0,58,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,119,101,98,46,102,105,108,116,101,114,46,83,101,114,118,101,114,72,116,116,112,79,98,115,101,114,118,97,116,105,111,110,70,105,108,116,101,114,116,0,32,83,101,114,118,101,114,72,116,116,112,79,98,115,101,114,118,97,116,105,111,110,70,105,108,116,101,114,46,106,97,118,97,113,0,126,0,35,112,112,115,113,0,126,0,14,1,0,0,0,116,113,0,126,0,16,113,0,126,0,37,113,0,126,0,38,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,174,113,0,126,0,16,113,0,126,0,112,113,0,126,0,113,113,0,126,0,114,112,112,115,113,0,126,0,14,1,0,0,0,149,113,0,126,0,16,113,0,126,0,112,113,0,126,0,113,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,201,113,0,126,0,16,116,0,54,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,119,101,98,46,102,105,108,116,101,114,46,67,104,97,114,97,99,116,101,114,69,110,99,111,100,105,110,103,70,105,108,116,101,114,116,0,28,67,104,97,114,97,99,116,101,114,69,110,99,111,100,105,110,103,70,105,108,116,101,114,46,106,97,118,97,113,0,126,0,35,112,112,115,113,0,126,0,14,1,0,0,0,116,113,0,126,0,16,113,0,126,0,37,113,0,126,0,38,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,174,113,0,126,0,16,113,0,126,0,112,113,0,126,0,113,113,0,126,0,114,112,112,115,113,0,126,0,14,1,0,0,0,149,113,0,126,0,16,113,0,126,0,112,113,0,126,0,113,113,0,126,0,23,112,112,115,113,0,126,0,14,1,0,0,0,167,113,0,126,0,16,116,0,45,111,114,103,46,97,112,97,99,104,101,46,99,97,116,97,108,105,110,97,46,99,111,114,101,46,83,116,97,110,100,97,114,100,87,114,97,112,112,101,114,86,97,108,118,101,116,0,25,83,116,97,110,100,97,114,100,87,114,97,112,112,101,114,86,97,108,118,101,46,106,97,118,97,116,0,6,105,110,118,111,107,101,112,112,115,113,0,126,0,14,1,0,0,0,90,113,0,126,0,16,116,0,45,111,114,103,46,97,112,97,99,104,101,46,99,97,116,97,108,105,110,97,46,99,111,114,101,46,83,116,97,110,100,97,114,100,67,111,110,116,101,120,116,86,97,108,118,101,116,0,25,83,116,97,110,100,97,114,100,67,111,110,116,101,120,116,86,97,108,118,101,46,106,97,118,97,113,0,126,0,152,112,112,115,113,0,126,0,14,1,0,0,1,226,113,0,126,0,16,116,0,51,111,114,103,46,97,112,97,99,104,101,46,99,97,116,97,108,105,110,97,46,97,117,116,104,101,110,116,105,99,97,116,111,114,46,65,117,116,104,101,110,116,105,99,97,116,111,114,66,97,115,101,116,0,22,65,117,116,104,101,110,116,105,99,97,116,111,114,66,97,115,101,46,106,97,118,97,113,0,126,0,152,112,112,115,113,0,126,0,14,1,0,0,0,115,113,0,126,0,16,116,0,42,111,114,103,46,97,112,97,99,104,101,46,99,97,116,97,108,105,110,97,46,99,111,114,101,46,83,116,97,110,100,97,114,100,72,111,115,116,86,97,108,118,101,116,0,22,83,116,97,110,100,97,114,100,72,111,115,116,86,97,108,118,101,46,106,97,118,97,113,0,126,0,152,112,112,115,113,0,126,0,14,1,0,0,0,93,113,0,126,0,16,116,0,43,111,114,103,46,97,112,97,99,104,101,46,99,97,116,97,108,105,110,97,46,118,97,108,118,101,115,46,69,114,114,111,114,82,101,112,111,114,116,86,97,108,118,101,116,0,21,69,114,114,111,114,82,101,112,111,114,116,86,97,108,118,101,46,106,97,118,97,113,0,126,0,152,112,112,115,113,0,126,0,14,1,0,0,0,74,113,0,126,0,16,116,0,44,111,114,103,46,97,112,97,99,104,101,46,99,97,116,97,108,105,110,97,46,99,111,114,101,46,83,116,97,110,100,97,114,100,69,110,103,105,110,101,86,97,108,118,101,116,0,24,83,116,97,110,100,97,114,100,69,110,103,105,110,101,86,97,108,118,101,46,106,97,118,97,113,0,126,0,152,112,112,115,113,0,126,0,14,1,0,0,1,88,113,0,126,0,16,116,0,43,111,114,103,46,97,112,97,99,104,101,46,99,97,116,97,108,105,110,97,46,99,111,110,110,101,99,116,111,114,46,67,111,121,111,116,101,65,100,97,112,116,101,114,116,0,18,67,111,121,111,116,101,65,100,97,112,116,101,114,46,106,97,118,97,116,0,7,115,101,114,118,105,99,101,112,112,115,113,0,126,0,14,1,0,0,1,135,113,0,126,0,16,116,0,40,111,114,103,46,97,112,97,99,104,101,46,99,111,121,111,116,101,46,104,116,116,112,49,49,46,72,116,116,112,49,49,80,114,111,99,101,115,115,111,114,116,0,20,72,116,116,112,49,49,80,114,111,99,101,115,115,111,114,46,106,97,118,97,113,0,126,0,171,112,112,115,113,0,126,0,14,1,0,0,0,63,113,0,126,0,16,116,0,40,111,114,103,46,97,112,97,99,104,101,46,99,111,121,111,116,101,46,65,98,115,116,114,97,99,116,80,114,111,99,101,115,115,111,114,76,105,103,104,116,116,0,27,65,98,115,116,114,97,99,116,80,114,111,99,101,115,115,111,114,76,105,103,104,116,46,106,97,118,97,116,0,7,112,114,111,99,101,115,115,112,112,115,113,0,126,0,14,1,0,0,3,128,113,0,126,0,16,116,0,52,111,114,103,46,97,112,97,99,104,101,46,99,111,121,111,116,101,46,65,98,115,116,114,97,99,116,80,114,111,116,111,99,111,108,36,67,111,110,110,101,99,116,105,111,110,72,97,110,100,108,101,114,116,0,21,65,98,115,116,114,97,99,116,80,114,111,116,111,99,111,108,46,106,97,118,97,113,0,126,0,178,112,112,115,113,0,126,0,14,1,0,0,6,208,113,0,126,0,16,116,0,54,111,114,103,46,97,112,97,99,104,101,46,116,111,109,99,97,116,46,117,116,105,108,46,110,101,116,46,78,105,111,69,110,100,112,111,105,110,116,36,83,111,99,107,101,116,80,114,111,99,101,115,115,111,114,116,0,16,78,105,111,69,110,100,112,111,105,110,116,46,106,97,118,97,116,0,5,100,111,82,117,110,112,112,115,113,0,126,0,14,1,0,0,0,52,113,0,126,0,16,116,0,46,111,114,103,46,97,112,97,99,104,101,46,116,111,109,99,97,116,46,117,116,105,108,46,110,101,116,46,83,111,99,107,101,116,80,114,111,99,101,115,115,111,114,66,97,115,101,116,0,24,83,111,99,107,101,116,80,114,111,99,101,115,115,111,114,66,97,115,101,46,106,97,118,97,116,0,3,114,117,110,112,112,115,113,0,126,0,14,1,0,0,4,167,113,0,126,0,16,116,0,49,111,114,103,46,97,112,97,99,104,101,46,116,111,109,99,97,116,46,117,116,105,108,46,116,104,114,101,97,100,115,46,84,104,114,101,97,100,80,111,111,108,69,120,101,99,117,116,111,114,116,0,23,84,104,114,101,97,100,80,111,111,108,69,120,101,99,117,116,111,114,46,106,97,118,97,116,0,9,114,117,110,87,111,114,107,101,114,112,112,115,113,0,126,0,14,1,0,0,2,147,113,0,126,0,16,116,0,56,111,114,103,46,97,112,97,99,104,101,46,116,111,109,99,97,116,46,117,116,105,108,46,116,104,114,101,97,100,115,46,84,104,114,101,97,100,80,111,111,108,69,120,101,99,117,116,111,114,36,87,111,114,107,101,114,113,0,126,0,192,113,0,126,0,189,112,112,115,113,0,126,0,14,1,0,0,0,63,113,0,126,0,16,116,0,58,111,114,103,46,97,112,97,99,104,101,46,116,111,109,99,97,116,46,117,116,105,108,46,116,104,114,101,97,100,115,46,84,97,115,107,84,104,114,101,97,100,36,87,114,97,112,112,105,110,103,82,117,110,110,97,98,108,101,116,0,15,84,97,115,107,84,104,114,101,97,100,46,106,97,118,97,113,0,126,0,189,112,112,115,113,0,126,0,14,2,0,0,3,72,112,116,0,16,106,97,118,97,46,108,97,110,103,46,84,104,114,101,97,100,116,0,11,84,104,114,101,97,100,46,106,97,118,97,113,0,126,0,189,116,0,9,106,97,118,97,46,98,97,115,101,116,0,7,49,55,46,48,46,49,56,115,114,0,31,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,69,109,112,116,121,76,105,115,116,122,184,23,180,60,167,158,222,2,0,0,120,112,120,115,114,0,52,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,111,97,117,116,104,50,46,99,111,114,101,46,79,65,117,116,104,50,69,114,114,111,114,0,0,0,0,0,0,2,108,2,0,3,76,0,11,100,101,115,99,114,105,112,116,105,111,110,113,0,126,0,7,76,0,9,101,114,114,111,114,67,111,100,101,113,0,126,0,7,76,0,3,117,114,105,113,0,126,0,7,120,112,112,116,0,31,97,117,116,104,111,114,105,122,97,116,105,111,110,95,114,101,113,117,101,115,116,95,110,111,116,95,102,111,117,110,100,112]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('8aca5fa4-1bd3-4ba6-9341-c12559c3abc2', 'SPRING_SECURITY_CONTEXT', '{"type":"Buffer","data":[172,237,0,5,115,114,0,61,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,99,111,110,116,101,120,116,46,83,101,99,117,114,105,116,121,67,111,110,116,101,120,116,73,109,112,108,0,0,0,0,0,0,2,108,2,0,1,76,0,14,97,117,116,104,101,110,116,105,99,97,116,105,111,110,116,0,50,76,111,114,103,47,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,47,115,101,99,117,114,105,116,121,47,99,111,114,101,47,65,117,116,104,101,110,116,105,99,97,116,105,111,110,59,120,112,115,114,0,79,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,85,115,101,114,110,97,109,101,80,97,115,115,119,111,114,100,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,0,0,0,0,0,0,2,108,2,0,2,76,0,11,99,114,101,100,101,110,116,105,97,108,115,116,0,18,76,106,97,118,97,47,108,97,110,103,47,79,98,106,101,99,116,59,76,0,9,112,114,105,110,99,105,112,97,108,113,0,126,0,4,120,114,0,71,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,65,98,115,116,114,97,99,116,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,211,170,40,126,110,71,100,14,2,0,3,90,0,13,97,117,116,104,101,110,116,105,99,97,116,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,22,76,106,97,118,97,47,117,116,105,108,47,67,111,108,108,101,99,116,105,111,110,59,76,0,7,100,101,116,97,105,108,115,113,0,126,0,4,120,112,1,115,114,0,38,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,76,105,115,116,252,15,37,49,181,236,142,16,2,0,1,76,0,4,108,105,115,116,116,0,16,76,106,97,118,97,47,117,116,105,108,47,76,105,115,116,59,120,114,0,44,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,67,111,108,108,101,99,116,105,111,110,25,66,0,128,203,94,247,30,2,0,1,76,0,1,99,113,0,126,0,6,120,112,115,114,0,19,106,97,118,97,46,117,116,105,108,46,65,114,114,97,121,76,105,115,116,120,129,210,29,153,199,97,157,3,0,1,73,0,4,115,105,122,101,120,112,0,0,0,1,119,4,0,0,0,1,115,114,0,66,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,97,117,116,104,111,114,105,116,121,46,83,105,109,112,108,101,71,114,97,110,116,101,100,65,117,116,104,111,114,105,116,121,0,0,0,0,0,0,2,108,2,0,1,76,0,4,114,111,108,101,116,0,18,76,106,97,118,97,47,108,97,110,103,47,83,116,114,105,110,103,59,120,112,116,0,10,82,79,76,69,95,65,68,77,73,78,120,113,0,126,0,13,115,114,0,72,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,87,101,98,65,117,116,104,101,110,116,105,99,97,116,105,111,110,68,101,116,97,105,108,115,0,0,0,0,0,0,2,108,2,0,2,76,0,13,114,101,109,111,116,101,65,100,100,114,101,115,115,113,0,126,0,15,76,0,9,115,101,115,115,105,111,110,73,100,113,0,126,0,15,120,112,116,0,15,48,58,48,58,48,58,48,58,48,58,48,58,48,58,49,116,0,36,97,99,56,57,53,100,52,49,45,54,102,100,53,45,52,54,52,53,45,98,52,57,102,45,57,100,49,52,98,101,54,49,99,99,56,48,112,115,114,0,50,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,0,0,0,0,0,0,2,108,2,0,7,90,0,17,97,99,99,111,117,110,116,78,111,110,69,120,112,105,114,101,100,90,0,16,97,99,99,111,117,110,116,78,111,110,76,111,99,107,101,100,90,0,21,99,114,101,100,101,110,116,105,97,108,115,78,111,110,69,120,112,105,114,101,100,90,0,7,101,110,97,98,108,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,15,76,106,97,118,97,47,117,116,105,108,47,83,101,116,59,76,0,8,112,97,115,115,119,111,114,100,113,0,126,0,15,76,0,8,117,115,101,114,110,97,109,101,113,0,126,0,15,120,112,1,1,1,1,115,114,0,37,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,83,101,116,128,29,146,209,143,155,128,85,2,0,0,120,113,0,126,0,10,115,114,0,17,106,97,118,97,46,117,116,105,108,46,84,114,101,101,83,101,116,221,152,80,147,149,237,135,91,3,0,0,120,112,115,114,0,70,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,36,65,117,116,104,111,114,105,116,121,67,111,109,112,97,114,97,116,111,114,0,0,0,0,0,0,2,108,2,0,0,120,112,119,4,0,0,0,1,113,0,126,0,16,120,112,116,0,19,108,101,101,99,111,111,107,99,117,64,103,109,97,105,108,46,99,111,109]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('60682f2c-75ef-4730-9c75-3b31f7434a82', 'SPRING_SECURITY_CONTEXT', '{"type":"Buffer","data":[172,237,0,5,115,114,0,61,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,99,111,110,116,101,120,116,46,83,101,99,117,114,105,116,121,67,111,110,116,101,120,116,73,109,112,108,0,0,0,0,0,0,2,108,2,0,1,76,0,14,97,117,116,104,101,110,116,105,99,97,116,105,111,110,116,0,50,76,111,114,103,47,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,47,115,101,99,117,114,105,116,121,47,99,111,114,101,47,65,117,116,104,101,110,116,105,99,97,116,105,111,110,59,120,112,115,114,0,79,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,85,115,101,114,110,97,109,101,80,97,115,115,119,111,114,100,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,0,0,0,0,0,0,2,108,2,0,2,76,0,11,99,114,101,100,101,110,116,105,97,108,115,116,0,18,76,106,97,118,97,47,108,97,110,103,47,79,98,106,101,99,116,59,76,0,9,112,114,105,110,99,105,112,97,108,113,0,126,0,4,120,114,0,71,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,65,98,115,116,114,97,99,116,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,211,170,40,126,110,71,100,14,2,0,3,90,0,13,97,117,116,104,101,110,116,105,99,97,116,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,22,76,106,97,118,97,47,117,116,105,108,47,67,111,108,108,101,99,116,105,111,110,59,76,0,7,100,101,116,97,105,108,115,113,0,126,0,4,120,112,1,115,114,0,38,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,76,105,115,116,252,15,37,49,181,236,142,16,2,0,1,76,0,4,108,105,115,116,116,0,16,76,106,97,118,97,47,117,116,105,108,47,76,105,115,116,59,120,114,0,44,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,67,111,108,108,101,99,116,105,111,110,25,66,0,128,203,94,247,30,2,0,1,76,0,1,99,113,0,126,0,6,120,112,115,114,0,19,106,97,118,97,46,117,116,105,108,46,65,114,114,97,121,76,105,115,116,120,129,210,29,153,199,97,157,3,0,1,73,0,4,115,105,122,101,120,112,0,0,0,1,119,4,0,0,0,1,115,114,0,66,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,97,117,116,104,111,114,105,116,121,46,83,105,109,112,108,101,71,114,97,110,116,101,100,65,117,116,104,111,114,105,116,121,0,0,0,0,0,0,2,108,2,0,1,76,0,4,114,111,108,101,116,0,18,76,106,97,118,97,47,108,97,110,103,47,83,116,114,105,110,103,59,120,112,116,0,10,82,79,76,69,95,65,68,77,73,78,120,113,0,126,0,13,112,112,115,114,0,50,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,0,0,0,0,0,0,2,108,2,0,7,90,0,17,97,99,99,111,117,110,116,78,111,110,69,120,112,105,114,101,100,90,0,16,97,99,99,111,117,110,116,78,111,110,76,111,99,107,101,100,90,0,21,99,114,101,100,101,110,116,105,97,108,115,78,111,110,69,120,112,105,114,101,100,90,0,7,101,110,97,98,108,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,15,76,106,97,118,97,47,117,116,105,108,47,83,101,116,59,76,0,8,112,97,115,115,119,111,114,100,113,0,126,0,15,76,0,8,117,115,101,114,110,97,109,101,113,0,126,0,15,120,112,1,1,1,1,115,114,0,37,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,83,101,116,128,29,146,209,143,155,128,85,2,0,0,120,113,0,126,0,10,115,114,0,17,106,97,118,97,46,117,116,105,108,46,84,114,101,101,83,101,116,221,152,80,147,149,237,135,91,3,0,0,120,112,115,114,0,70,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,36,65,117,116,104,111,114,105,116,121,67,111,109,112,97,114,97,116,111,114,0,0,0,0,0,0,2,108,2,0,0,120,112,119,4,0,0,0,1,113,0,126,0,16,120,116,0,60,36,50,97,36,49,48,36,103,69,71,83,84,53,84,78,83,119,70,69,107,90,85,47,116,51,107,48,110,117,116,114,86,78,117,72,71,114,119,66,122,76,49,57,99,101,80,117,102,46,66,87,109,82,98,55,85,89,77,99,46,116,0,19,108,101,101,99,111,111,107,99,117,64,103,109,97,105,108,46,99,111,109]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('60682f2c-75ef-4730-9c75-3b31f7434a82', 'cart', '{"type":"Buffer","data":[172,237,0,5,115,114,0,17,106,97,118,97,46,117,116,105,108,46,72,97,115,104,77,97,112,5,7,218,193,195,22,96,209,3,0,2,70,0,10,108,111,97,100,70,97,99,116,111,114,73,0,9,116,104,114,101,115,104,111,108,100,120,112,63,64,0,0,0,0,0,0,119,8,0,0,0,16,0,0,0,0,120]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('2a441226-685e-453a-a778-a6eaacd64dc7', 'SPRING_SECURITY_SAVED_REQUEST', '{"type":"Buffer","data":[172,237,0,5,115,114,0,65,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,115,97,118,101,100,114,101,113,117,101,115,116,46,68,101,102,97,117,108,116,83,97,118,101,100,82,101,113,117,101,115,116,0,0,0,0,0,0,2,108,2,0,15,73,0,10,115,101,114,118,101,114,80,111,114,116,76,0,11,99,111,110,116,101,120,116,80,97,116,104,116,0,18,76,106,97,118,97,47,108,97,110,103,47,83,116,114,105,110,103,59,76,0,7,99,111,111,107,105,101,115,116,0,21,76,106,97,118,97,47,117,116,105,108,47,65,114,114,97,121,76,105,115,116,59,76,0,7,104,101,97,100,101,114,115,116,0,15,76,106,97,118,97,47,117,116,105,108,47,77,97,112,59,76,0,7,108,111,99,97,108,101,115,113,0,126,0,2,76,0,28,109,97,116,99,104,105,110,103,82,101,113,117,101,115,116,80,97,114,97,109,101,116,101,114,78,97,109,101,113,0,126,0,1,76,0,6,109,101,116,104,111,100,113,0,126,0,1,76,0,10,112,97,114,97,109,101,116,101,114,115,113,0,126,0,3,76,0,8,112,97,116,104,73,110,102,111,113,0,126,0,1,76,0,11,113,117,101,114,121,83,116,114,105,110,103,113,0,126,0,1,76,0,10,114,101,113,117,101,115,116,85,82,73,113,0,126,0,1,76,0,10,114,101,113,117,101,115,116,85,82,76,113,0,126,0,1,76,0,6,115,99,104,101,109,101,113,0,126,0,1,76,0,10,115,101,114,118,101,114,78,97,109,101,113,0,126,0,1,76,0,11,115,101,114,118,108,101,116,80,97,116,104,113,0,126,0,1,120,112,0,0,31,144,116,0,0,115,114,0,19,106,97,118,97,46,117,116,105,108,46,65,114,114,97,121,76,105,115,116,120,129,210,29,153,199,97,157,3,0,1,73,0,4,115,105,122,101,120,112,0,0,0,1,119,4,0,0,0,1,115,114,0,57,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,115,97,118,101,100,114,101,113,117,101,115,116,46,83,97,118,101,100,67,111,111,107,105,101,0,0,0,0,0,0,2,108,2,0,8,73,0,6,109,97,120,65,103,101,90,0,6,115,101,99,117,114,101,73,0,7,118,101,114,115,105,111,110,76,0,7,99,111,109,109,101,110,116,113,0,126,0,1,76,0,6,100,111,109,97,105,110,113,0,126,0,1,76,0,4,110,97,109,101,113,0,126,0,1,76,0,4,112,97,116,104,113,0,126,0,1,76,0,5,118,97,108,117,101,113,0,126,0,1,120,112,255,255,255,255,0,0,0,0,0,112,112,116,0,7,83,69,83,83,73,79,78,112,116,0,48,78,122,69,119,77,84,81,121,79,68,69,116,79,84,107,49,77,83,48,48,77,84,81,119,76,84,103,52,90,87,77,116,78,109,82,107,77,71,69,51,77,122,69,122,78,68,99,48,120,115,114,0,17,106,97,118,97,46,117,116,105,108,46,84,114,101,101,77,97,112,12,193,246,62,45,37,106,230,3,0,1,76,0,10,99,111,109,112,97,114,97,116,111,114,116,0,22,76,106,97,118,97,47,117,116,105,108,47,67,111,109,112,97,114,97,116,111,114,59,120,112,115,114,0,42,106,97,118,97,46,108,97,110,103,46,83,116,114,105,110,103,36,67,97,115,101,73,110,115,101,110,115,105,116,105,118,101,67,111,109,112,97,114,97,116,111,114,119,3,92,125,92,80,229,206,2,0,0,120,112,119,4,0,0,0,15,116,0,6,97,99,99,101,112,116,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,135,116,101,120,116,47,104,116,109,108,44,97,112,112,108,105,99,97,116,105,111,110,47,120,104,116,109,108,43,120,109,108,44,97,112,112,108,105,99,97,116,105,111,110,47,120,109,108,59,113,61,48,46,57,44,105,109,97,103,101,47,97,118,105,102,44,105,109,97,103,101,47,119,101,98,112,44,105,109,97,103,101,47,97,112,110,103,44,42,47,42,59,113,61,48,46,56,44,97,112,112,108,105,99,97,116,105,111,110,47,115,105,103,110,101,100,45,101,120,99,104,97,110,103,101,59,118,61,98,51,59,113,61,48,46,55,120,116,0,15,97,99,99,101,112,116,45,101,110,99,111,100,105,110,103,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,23,103,122,105,112,44,32,100,101,102,108,97,116,101,44,32,98,114,44,32,122,115,116,100,120,116,0,15,97,99,99,101,112,116,45,108,97,110,103,117,97,103,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,83,118,105,44,102,114,45,70,82,59,113,61,48,46,57,44,102,114,59,113,61,48,46,56,44,101,110,45,85,83,59,113,61,48,46,55,44,101,110,59,113,61,48,46,54,44,114,117,59,113,61,48,46,53,44,106,97,59,113,61,48,46,52,44,122,104,45,67,78,59,113,61,48,46,51,44,122,104,59,113,61,48,46,50,120,116,0,10,99,111,110,110,101,99,116,105,111,110,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,10,107,101,101,112,45,97,108,105,118,101,120,116,0,6,99,111,111,107,105,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,56,83,69,83,83,73,79,78,61,78,122,69,119,77,84,81,121,79,68,69,116,79,84,107,49,77,83,48,48,77,84,81,119,76,84,103,52,90,87,77,116,78,109,82,107,77,71,69,51,77,122,69,122,78,68,99,48,120,116,0,4,104,111,115,116,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,14,108,111,99,97,108,104,111,115,116,58,56,48,56,48,120,116,0,9,115,101,99,45,99,104,45,117,97,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,65,34,67,104,114,111,109,105,117,109,34,59,118,61,34,49,52,56,34,44,32,34,71,111,111,103,108,101,32,67,104,114,111,109,101,34,59,118,61,34,49,52,56,34,44,32,34,78,111,116,47,65,41,66,114,97,110,100,34,59,118,61,34,57,57,34,120,116,0,16,115,101,99,45,99,104,45,117,97,45,109,111,98,105,108,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,2,63,48,120,116,0,18,115,101,99,45,99,104,45,117,97,45,112,108,97,116,102,111,114,109,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,9,34,87,105,110,100,111,119,115,34,120,116,0,14,115,101,99,45,102,101,116,99,104,45,100,101,115,116,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,8,100,111,99,117,109,101,110,116,120,116,0,14,115,101,99,45,102,101,116,99,104,45,109,111,100,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,8,110,97,118,105,103,97,116,101,120,116,0,14,115,101,99,45,102,101,116,99,104,45,115,105,116,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,4,110,111,110,101,120,116,0,14,115,101,99,45,102,101,116,99,104,45,117,115,101,114,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,2,63,49,120,116,0,25,117,112,103,114,97,100,101,45,105,110,115,101,99,117,114,101,45,114,101,113,117,101,115,116,115,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,1,49,120,116,0,10,117,115,101,114,45,97,103,101,110,116,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,111,77,111,122,105,108,108,97,47,53,46,48,32,40,87,105,110,100,111,119,115,32,78,84,32,49,48,46,48,59,32,87,105,110,54,52,59,32,120,54,52,41,32,65,112,112,108,101,87,101,98,75,105,116,47,53,51,55,46,51,54,32,40,75,72,84,77,76,44,32,108,105,107,101,32,71,101,99,107,111,41,32,67,104,114,111,109,101,47,49,52,56,46,48,46,48,46,48,32,83,97,102,97,114,105,47,53,51,55,46,51,54,120,120,115,113,0,126,0,6,0,0,0,9,119,4,0,0,0,9,115,114,0,16,106,97,118,97,46,117,116,105,108,46,76,111,99,97,108,101,126,248,17,96,156,48,249,236,3,0,6,73,0,8,104,97,115,104,99,111,100,101,76,0,7,99,111,117,110,116,114,121,113,0,126,0,1,76,0,10,101,120,116,101,110,115,105,111,110,115,113,0,126,0,1,76,0,8,108,97,110,103,117,97,103,101,113,0,126,0,1,76,0,6,115,99,114,105,112,116,113,0,126,0,1,76,0,7,118,97,114,105,97,110,116,113,0,126,0,1,120,112,255,255,255,255,113,0,126,0,5,113,0,126,0,5,116,0,2,118,105,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,116,0,2,70,82,113,0,126,0,5,116,0,2,102,114,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,113,0,126,0,5,113,0,126,0,5,113,0,126,0,68,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,116,0,2,85,83,113,0,126,0,5,116,0,2,101,110,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,113,0,126,0,5,113,0,126,0,5,113,0,126,0,72,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,113,0,126,0,5,113,0,126,0,5,116,0,2,114,117,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,113,0,126,0,5,113,0,126,0,5,116,0,2,106,97,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,116,0,2,67,78,113,0,126,0,5,116,0,2,122,104,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,113,0,126,0,5,113,0,126,0,5,113,0,126,0,80,113,0,126,0,5,113,0,126,0,5,120,120,116,0,8,99,111,110,116,105,110,117,101,116,0,3,71,69,84,115,113,0,126,0,12,112,119,4,0,0,0,0,120,112,112,116,0,14,47,97,100,109,105,110,47,97,99,99,111,117,110,116,116,0,35,104,116,116,112,58,47,47,108,111,99,97,108,104,111,115,116,58,56,48,56,48,47,97,100,109,105,110,47,97,99,99,111,117,110,116,116,0,4,104,116,116,112,116,0,9,108,111,99,97,108,104,111,115,116,116,0,14,47,97,100,109,105,110,47,97,99,99,111,117,110,116]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('2a441226-685e-453a-a778-a6eaacd64dc7', 'SPRING_SECURITY_CONTEXT', '{"type":"Buffer","data":[172,237,0,5,115,114,0,61,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,99,111,110,116,101,120,116,46,83,101,99,117,114,105,116,121,67,111,110,116,101,120,116,73,109,112,108,0,0,0,0,0,0,2,108,2,0,1,76,0,14,97,117,116,104,101,110,116,105,99,97,116,105,111,110,116,0,50,76,111,114,103,47,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,47,115,101,99,117,114,105,116,121,47,99,111,114,101,47,65,117,116,104,101,110,116,105,99,97,116,105,111,110,59,120,112,115,114,0,79,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,85,115,101,114,110,97,109,101,80,97,115,115,119,111,114,100,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,0,0,0,0,0,0,2,108,2,0,2,76,0,11,99,114,101,100,101,110,116,105,97,108,115,116,0,18,76,106,97,118,97,47,108,97,110,103,47,79,98,106,101,99,116,59,76,0,9,112,114,105,110,99,105,112,97,108,113,0,126,0,4,120,114,0,71,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,65,98,115,116,114,97,99,116,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,211,170,40,126,110,71,100,14,2,0,3,90,0,13,97,117,116,104,101,110,116,105,99,97,116,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,22,76,106,97,118,97,47,117,116,105,108,47,67,111,108,108,101,99,116,105,111,110,59,76,0,7,100,101,116,97,105,108,115,113,0,126,0,4,120,112,1,115,114,0,38,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,76,105,115,116,252,15,37,49,181,236,142,16,2,0,1,76,0,4,108,105,115,116,116,0,16,76,106,97,118,97,47,117,116,105,108,47,76,105,115,116,59,120,114,0,44,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,67,111,108,108,101,99,116,105,111,110,25,66,0,128,203,94,247,30,2,0,1,76,0,1,99,113,0,126,0,6,120,112,115,114,0,19,106,97,118,97,46,117,116,105,108,46,65,114,114,97,121,76,105,115,116,120,129,210,29,153,199,97,157,3,0,1,73,0,4,115,105,122,101,120,112,0,0,0,1,119,4,0,0,0,1,115,114,0,66,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,97,117,116,104,111,114,105,116,121,46,83,105,109,112,108,101,71,114,97,110,116,101,100,65,117,116,104,111,114,105,116,121,0,0,0,0,0,0,2,108,2,0,1,76,0,4,114,111,108,101,116,0,18,76,106,97,118,97,47,108,97,110,103,47,83,116,114,105,110,103,59,120,112,116,0,10,82,79,76,69,95,65,68,77,73,78,120,113,0,126,0,13,115,114,0,72,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,87,101,98,65,117,116,104,101,110,116,105,99,97,116,105,111,110,68,101,116,97,105,108,115,0,0,0,0,0,0,2,108,2,0,2,76,0,13,114,101,109,111,116,101,65,100,100,114,101,115,115,113,0,126,0,15,76,0,9,115,101,115,115,105,111,110,73,100,113,0,126,0,15,120,112,116,0,15,48,58,48,58,48,58,48,58,48,58,48,58,48,58,49,116,0,36,55,49,48,49,52,50,56,49,45,57,57,53,49,45,52,49,52,48,45,56,56,101,99,45,54,100,100,48,97,55,51,49,51,52,55,52,112,115,114,0,50,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,0,0,0,0,0,0,2,108,2,0,7,90,0,17,97,99,99,111,117,110,116,78,111,110,69,120,112,105,114,101,100,90,0,16,97,99,99,111,117,110,116,78,111,110,76,111,99,107,101,100,90,0,21,99,114,101,100,101,110,116,105,97,108,115,78,111,110,69,120,112,105,114,101,100,90,0,7,101,110,97,98,108,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,15,76,106,97,118,97,47,117,116,105,108,47,83,101,116,59,76,0,8,112,97,115,115,119,111,114,100,113,0,126,0,15,76,0,8,117,115,101,114,110,97,109,101,113,0,126,0,15,120,112,1,1,1,1,115,114,0,37,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,83,101,116,128,29,146,209,143,155,128,85,2,0,0,120,113,0,126,0,10,115,114,0,17,106,97,118,97,46,117,116,105,108,46,84,114,101,101,83,101,116,221,152,80,147,149,237,135,91,3,0,0,120,112,115,114,0,70,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,36,65,117,116,104,111,114,105,116,121,67,111,109,112,97,114,97,116,111,114,0,0,0,0,0,0,2,108,2,0,0,120,112,119,4,0,0,0,1,113,0,126,0,16,120,112,116,0,27,116,117,97,110,57,98,108,101,100,105,110,104,99,104,105,110,104,64,103,109,97,105,108,46,99,111,109]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('2a441226-685e-453a-a778-a6eaacd64dc7', 'cart', '{"type":"Buffer","data":[172,237,0,5,115,114,0,17,106,97,118,97,46,117,116,105,108,46,72,97,115,104,77,97,112,5,7,218,193,195,22,96,209,3,0,2,70,0,10,108,111,97,100,70,97,99,116,111,114,73,0,9,116,104,114,101,115,104,111,108,100,120,112,63,64,0,0,0,0,0,0,119,8,0,0,0,16,0,0,0,0,120]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('8c4158f0-f459-41bc-a226-13547714be9f', 'SPRING_SECURITY_CONTEXT', '{"type":"Buffer","data":[172,237,0,5,115,114,0,61,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,99,111,110,116,101,120,116,46,83,101,99,117,114,105,116,121,67,111,110,116,101,120,116,73,109,112,108,0,0,0,0,0,0,2,108,2,0,1,76,0,14,97,117,116,104,101,110,116,105,99,97,116,105,111,110,116,0,50,76,111,114,103,47,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,47,115,101,99,117,114,105,116,121,47,99,111,114,101,47,65,117,116,104,101,110,116,105,99,97,116,105,111,110,59,120,112,115,114,0,79,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,85,115,101,114,110,97,109,101,80,97,115,115,119,111,114,100,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,0,0,0,0,0,0,2,108,2,0,2,76,0,11,99,114,101,100,101,110,116,105,97,108,115,116,0,18,76,106,97,118,97,47,108,97,110,103,47,79,98,106,101,99,116,59,76,0,9,112,114,105,110,99,105,112,97,108,113,0,126,0,4,120,114,0,71,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,65,98,115,116,114,97,99,116,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,211,170,40,126,110,71,100,14,2,0,3,90,0,13,97,117,116,104,101,110,116,105,99,97,116,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,22,76,106,97,118,97,47,117,116,105,108,47,67,111,108,108,101,99,116,105,111,110,59,76,0,7,100,101,116,97,105,108,115,113,0,126,0,4,120,112,1,115,114,0,38,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,76,105,115,116,252,15,37,49,181,236,142,16,2,0,1,76,0,4,108,105,115,116,116,0,16,76,106,97,118,97,47,117,116,105,108,47,76,105,115,116,59,120,114,0,44,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,67,111,108,108,101,99,116,105,111,110,25,66,0,128,203,94,247,30,2,0,1,76,0,1,99,113,0,126,0,6,120,112,115,114,0,19,106,97,118,97,46,117,116,105,108,46,65,114,114,97,121,76,105,115,116,120,129,210,29,153,199,97,157,3,0,1,73,0,4,115,105,122,101,120,112,0,0,0,1,119,4,0,0,0,1,115,114,0,66,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,97,117,116,104,111,114,105,116,121,46,83,105,109,112,108,101,71,114,97,110,116,101,100,65,117,116,104,111,114,105,116,121,0,0,0,0,0,0,2,108,2,0,1,76,0,4,114,111,108,101,116,0,18,76,106,97,118,97,47,108,97,110,103,47,83,116,114,105,110,103,59,120,112,116,0,10,82,79,76,69,95,65,68,77,73,78,120,113,0,126,0,13,112,112,115,114,0,50,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,0,0,0,0,0,0,2,108,2,0,7,90,0,17,97,99,99,111,117,110,116,78,111,110,69,120,112,105,114,101,100,90,0,16,97,99,99,111,117,110,116,78,111,110,76,111,99,107,101,100,90,0,21,99,114,101,100,101,110,116,105,97,108,115,78,111,110,69,120,112,105,114,101,100,90,0,7,101,110,97,98,108,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,15,76,106,97,118,97,47,117,116,105,108,47,83,101,116,59,76,0,8,112,97,115,115,119,111,114,100,113,0,126,0,15,76,0,8,117,115,101,114,110,97,109,101,113,0,126,0,15,120,112,1,1,1,1,115,114,0,37,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,83,101,116,128,29,146,209,143,155,128,85,2,0,0,120,113,0,126,0,10,115,114,0,17,106,97,118,97,46,117,116,105,108,46,84,114,101,101,83,101,116,221,152,80,147,149,237,135,91,3,0,0,120,112,115,114,0,70,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,36,65,117,116,104,111,114,105,116,121,67,111,109,112,97,114,97,116,111,114,0,0,0,0,0,0,2,108,2,0,0,120,112,119,4,0,0,0,1,113,0,126,0,16,120,116,0,60,36,50,97,36,49,48,36,103,69,71,83,84,53,84,78,83,119,70,69,107,90,85,47,116,51,107,48,110,117,116,114,86,78,117,72,71,114,119,66,122,76,49,57,99,101,80,117,102,46,66,87,109,82,98,55,85,89,77,99,46,116,0,19,108,101,101,99,111,111,107,99,117,64,103,109,97,105,108,46,99,111,109]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('8c4158f0-f459-41bc-a226-13547714be9f', 'cart', '{"type":"Buffer","data":[172,237,0,5,115,114,0,17,106,97,118,97,46,117,116,105,108,46,72,97,115,104,77,97,112,5,7,218,193,195,22,96,209,3,0,2,70,0,10,108,111,97,100,70,97,99,116,111,114,73,0,9,116,104,114,101,115,104,111,108,100,120,112,63,64,0,0,0,0,0,0,119,8,0,0,0,16,0,0,0,0,120]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('3f874edd-c07d-4d9d-bce7-24d5e3067baf', 'cart', '{"type":"Buffer","data":[172,237,0,5,115,114,0,17,106,97,118,97,46,117,116,105,108,46,72,97,115,104,77,97,112,5,7,218,193,195,22,96,209,3,0,2,70,0,10,108,111,97,100,70,97,99,116,111,114,73,0,9,116,104,114,101,115,104,111,108,100,120,112,63,64,0,0,0,0,0,0,119,8,0,0,0,16,0,0,0,0,120]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('3f874edd-c07d-4d9d-bce7-24d5e3067baf', 'SPRING_SECURITY_CONTEXT', '{"type":"Buffer","data":[172,237,0,5,115,114,0,61,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,99,111,110,116,101,120,116,46,83,101,99,117,114,105,116,121,67,111,110,116,101,120,116,73,109,112,108,0,0,0,0,0,0,2,108,2,0,1,76,0,14,97,117,116,104,101,110,116,105,99,97,116,105,111,110,116,0,50,76,111,114,103,47,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,47,115,101,99,117,114,105,116,121,47,99,111,114,101,47,65,117,116,104,101,110,116,105,99,97,116,105,111,110,59,120,112,115,114,0,79,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,85,115,101,114,110,97,109,101,80,97,115,115,119,111,114,100,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,0,0,0,0,0,0,2,108,2,0,2,76,0,11,99,114,101,100,101,110,116,105,97,108,115,116,0,18,76,106,97,118,97,47,108,97,110,103,47,79,98,106,101,99,116,59,76,0,9,112,114,105,110,99,105,112,97,108,113,0,126,0,4,120,114,0,71,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,65,98,115,116,114,97,99,116,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,211,170,40,126,110,71,100,14,2,0,3,90,0,13,97,117,116,104,101,110,116,105,99,97,116,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,22,76,106,97,118,97,47,117,116,105,108,47,67,111,108,108,101,99,116,105,111,110,59,76,0,7,100,101,116,97,105,108,115,113,0,126,0,4,120,112,1,115,114,0,38,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,76,105,115,116,252,15,37,49,181,236,142,16,2,0,1,76,0,4,108,105,115,116,116,0,16,76,106,97,118,97,47,117,116,105,108,47,76,105,115,116,59,120,114,0,44,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,67,111,108,108,101,99,116,105,111,110,25,66,0,128,203,94,247,30,2,0,1,76,0,1,99,113,0,126,0,6,120,112,115,114,0,19,106,97,118,97,46,117,116,105,108,46,65,114,114,97,121,76,105,115,116,120,129,210,29,153,199,97,157,3,0,1,73,0,4,115,105,122,101,120,112,0,0,0,1,119,4,0,0,0,1,115,114,0,66,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,97,117,116,104,111,114,105,116,121,46,83,105,109,112,108,101,71,114,97,110,116,101,100,65,117,116,104,111,114,105,116,121,0,0,0,0,0,0,2,108,2,0,1,76,0,4,114,111,108,101,116,0,18,76,106,97,118,97,47,108,97,110,103,47,83,116,114,105,110,103,59,120,112,116,0,10,82,79,76,69,95,65,68,77,73,78,120,113,0,126,0,13,115,114,0,72,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,87,101,98,65,117,116,104,101,110,116,105,99,97,116,105,111,110,68,101,116,97,105,108,115,0,0,0,0,0,0,2,108,2,0,2,76,0,13,114,101,109,111,116,101,65,100,100,114,101,115,115,113,0,126,0,15,76,0,9,115,101,115,115,105,111,110,73,100,113,0,126,0,15,120,112,116,0,15,48,58,48,58,48,58,48,58,48,58,48,58,48,58,49,116,0,36,100,100,97,55,51,57,49,48,45,57,53,48,102,45,52,56,52,54,45,97,99,98,98,45,97,54,102,98,98,97,97,97,99,56,99,55,112,115,114,0,50,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,0,0,0,0,0,0,2,108,2,0,7,90,0,17,97,99,99,111,117,110,116,78,111,110,69,120,112,105,114,101,100,90,0,16,97,99,99,111,117,110,116,78,111,110,76,111,99,107,101,100,90,0,21,99,114,101,100,101,110,116,105,97,108,115,78,111,110,69,120,112,105,114,101,100,90,0,7,101,110,97,98,108,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,15,76,106,97,118,97,47,117,116,105,108,47,83,101,116,59,76,0,8,112,97,115,115,119,111,114,100,113,0,126,0,15,76,0,8,117,115,101,114,110,97,109,101,113,0,126,0,15,120,112,1,1,1,1,115,114,0,37,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,83,101,116,128,29,146,209,143,155,128,85,2,0,0,120,113,0,126,0,10,115,114,0,17,106,97,118,97,46,117,116,105,108,46,84,114,101,101,83,101,116,221,152,80,147,149,237,135,91,3,0,0,120,112,115,114,0,70,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,36,65,117,116,104,111,114,105,116,121,67,111,109,112,97,114,97,116,111,114,0,0,0,0,0,0,2,108,2,0,0,120,112,119,4,0,0,0,1,113,0,126,0,16,120,112,116,0,19,108,101,101,99,111,111,107,99,117,64,103,109,97,105,108,46,99,111,109]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('e5d6a1e8-7d77-4bbe-9ab3-7c6ca6ad73f0', 'cart', '{"type":"Buffer","data":[172,237,0,5,115,114,0,17,106,97,118,97,46,117,116,105,108,46,72,97,115,104,77,97,112,5,7,218,193,195,22,96,209,3,0,2,70,0,10,108,111,97,100,70,97,99,116,111,114,73,0,9,116,104,114,101,115,104,111,108,100,120,112,63,64,0,0,0,0,0,0,119,8,0,0,0,16,0,0,0,0,120]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('e5d6a1e8-7d77-4bbe-9ab3-7c6ca6ad73f0', 'SPRING_SECURITY_SAVED_REQUEST', '{"type":"Buffer","data":[172,237,0,5,115,114,0,65,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,115,97,118,101,100,114,101,113,117,101,115,116,46,68,101,102,97,117,108,116,83,97,118,101,100,82,101,113,117,101,115,116,0,0,0,0,0,0,2,108,2,0,15,73,0,10,115,101,114,118,101,114,80,111,114,116,76,0,11,99,111,110,116,101,120,116,80,97,116,104,116,0,18,76,106,97,118,97,47,108,97,110,103,47,83,116,114,105,110,103,59,76,0,7,99,111,111,107,105,101,115,116,0,21,76,106,97,118,97,47,117,116,105,108,47,65,114,114,97,121,76,105,115,116,59,76,0,7,104,101,97,100,101,114,115,116,0,15,76,106,97,118,97,47,117,116,105,108,47,77,97,112,59,76,0,7,108,111,99,97,108,101,115,113,0,126,0,2,76,0,28,109,97,116,99,104,105,110,103,82,101,113,117,101,115,116,80,97,114,97,109,101,116,101,114,78,97,109,101,113,0,126,0,1,76,0,6,109,101,116,104,111,100,113,0,126,0,1,76,0,10,112,97,114,97,109,101,116,101,114,115,113,0,126,0,3,76,0,8,112,97,116,104,73,110,102,111,113,0,126,0,1,76,0,11,113,117,101,114,121,83,116,114,105,110,103,113,0,126,0,1,76,0,10,114,101,113,117,101,115,116,85,82,73,113,0,126,0,1,76,0,10,114,101,113,117,101,115,116,85,82,76,113,0,126,0,1,76,0,6,115,99,104,101,109,101,113,0,126,0,1,76,0,10,115,101,114,118,101,114,78,97,109,101,113,0,126,0,1,76,0,11,115,101,114,118,108,101,116,80,97,116,104,113,0,126,0,1,120,112,0,0,31,144,116,0,0,115,114,0,19,106,97,118,97,46,117,116,105,108,46,65,114,114,97,121,76,105,115,116,120,129,210,29,153,199,97,157,3,0,1,73,0,4,115,105,122,101,120,112,0,0,0,1,119,4,0,0,0,1,115,114,0,57,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,115,97,118,101,100,114,101,113,117,101,115,116,46,83,97,118,101,100,67,111,111,107,105,101,0,0,0,0,0,0,2,108,2,0,8,73,0,6,109,97,120,65,103,101,90,0,6,115,101,99,117,114,101,73,0,7,118,101,114,115,105,111,110,76,0,7,99,111,109,109,101,110,116,113,0,126,0,1,76,0,6,100,111,109,97,105,110,113,0,126,0,1,76,0,4,110,97,109,101,113,0,126,0,1,76,0,4,112,97,116,104,113,0,126,0,1,76,0,5,118,97,108,117,101,113,0,126,0,1,120,112,255,255,255,255,0,0,0,0,0,112,112,116,0,7,83,69,83,83,73,79,78,112,116,0,48,78,71,69,120,89,84,108,104,89,87,81,116,77,122,89,51,90,105,48,48,89,122,104,106,76,84,107,50,89,87,89,116,90,84,99,119,90,87,86,107,90,71,81,48,79,84,107,50,120,115,114,0,17,106,97,118,97,46,117,116,105,108,46,84,114,101,101,77,97,112,12,193,246,62,45,37,106,230,3,0,1,76,0,10,99,111,109,112,97,114,97,116,111,114,116,0,22,76,106,97,118,97,47,117,116,105,108,47,67,111,109,112,97,114,97,116,111,114,59,120,112,115,114,0,42,106,97,118,97,46,108,97,110,103,46,83,116,114,105,110,103,36,67,97,115,101,73,110,115,101,110,115,105,116,105,118,101,67,111,109,112,97,114,97,116,111,114,119,3,92,125,92,80,229,206,2,0,0,120,112,119,4,0,0,0,16,116,0,6,97,99,99,101,112,116,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,3,42,47,42,120,116,0,15,97,99,99,101,112,116,45,101,110,99,111,100,105,110,103,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,23,103,122,105,112,44,32,100,101,102,108,97,116,101,44,32,98,114,44,32,122,115,116,100,120,116,0,15,97,99,99,101,112,116,45,108,97,110,103,117,97,103,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,83,118,105,44,102,114,45,70,82,59,113,61,48,46,57,44,102,114,59,113,61,48,46,56,44,101,110,45,85,83,59,113,61,48,46,55,44,101,110,59,113,61,48,46,54,44,114,117,59,113,61,48,46,53,44,106,97,59,113,61,48,46,52,44,122,104,45,67,78,59,113,61,48,46,51,44,122,104,59,113,61,48,46,50,120,116,0,10,99,111,110,110,101,99,116,105,111,110,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,10,107,101,101,112,45,97,108,105,118,101,120,116,0,14,99,111,110,116,101,110,116,45,108,101,110,103,116,104,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,1,48,120,116,0,6,99,111,111,107,105,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,56,83,69,83,83,73,79,78,61,78,71,69,120,89,84,108,104,89,87,81,116,77,122,89,51,90,105,48,48,89,122,104,106,76,84,107,50,89,87,89,116,90,84,99,119,90,87,86,107,90,71,81,48,79,84,107,50,120,116,0,4,104,111,115,116,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,14,108,111,99,97,108,104,111,115,116,58,56,48,56,48,120,116,0,6,111,114,105,103,105,110,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,21,104,116,116,112,58,47,47,108,111,99,97,108,104,111,115,116,58,56,48,56,48,120,116,0,7,114,101,102,101,114,101,114,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,45,104,116,116,112,58,47,47,108,111,99,97,108,104,111,115,116,58,56,48,56,48,47,97,117,116,104,47,108,111,103,105,110,63,100,101,108,101,116,101,100,61,116,114,117,101,120,116,0,9,115,101,99,45,99,104,45,117,97,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,65,34,67,104,114,111,109,105,117,109,34,59,118,61,34,49,52,56,34,44,32,34,71,111,111,103,108,101,32,67,104,114,111,109,101,34,59,118,61,34,49,52,56,34,44,32,34,78,111,116,47,65,41,66,114,97,110,100,34,59,118,61,34,57,57,34,120,116,0,16,115,101,99,45,99,104,45,117,97,45,109,111,98,105,108,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,2,63,48,120,116,0,18,115,101,99,45,99,104,45,117,97,45,112,108,97,116,102,111,114,109,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,9,34,87,105,110,100,111,119,115,34,120,116,0,14,115,101,99,45,102,101,116,99,104,45,100,101,115,116,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,5,101,109,112,116,121,120,116,0,14,115,101,99,45,102,101,116,99,104,45,109,111,100,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,4,99,111,114,115,120,116,0,14,115,101,99,45,102,101,116,99,104,45,115,105,116,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,11,115,97,109,101,45,111,114,105,103,105,110,120,116,0,10,117,115,101,114,45,97,103,101,110,116,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,111,77,111,122,105,108,108,97,47,53,46,48,32,40,87,105,110,100,111,119,115,32,78,84,32,49,48,46,48,59,32,87,105,110,54,52,59,32,120,54,52,41,32,65,112,112,108,101,87,101,98,75,105,116,47,53,51,55,46,51,54,32,40,75,72,84,77,76,44,32,108,105,107,101,32,71,101,99,107,111,41,32,67,104,114,111,109,101,47,49,52,56,46,48,46,48,46,48,32,83,97,102,97,114,105,47,53,51,55,46,51,54,120,120,115,113,0,126,0,6,0,0,0,9,119,4,0,0,0,9,115,114,0,16,106,97,118,97,46,117,116,105,108,46,76,111,99,97,108,101,126,248,17,96,156,48,249,236,3,0,6,73,0,8,104,97,115,104,99,111,100,101,76,0,7,99,111,117,110,116,114,121,113,0,126,0,1,76,0,10,101,120,116,101,110,115,105,111,110,115,113,0,126,0,1,76,0,8,108,97,110,103,117,97,103,101,113,0,126,0,1,76,0,6,115,99,114,105,112,116,113,0,126,0,1,76,0,7,118,97,114,105,97,110,116,113,0,126,0,1,120,112,255,255,255,255,113,0,126,0,5,113,0,126,0,5,116,0,2,118,105,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,66,255,255,255,255,116,0,2,70,82,113,0,126,0,5,116,0,2,102,114,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,66,255,255,255,255,113,0,126,0,5,113,0,126,0,5,113,0,126,0,71,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,66,255,255,255,255,116,0,2,85,83,113,0,126,0,5,116,0,2,101,110,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,66,255,255,255,255,113,0,126,0,5,113,0,126,0,5,113,0,126,0,75,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,66,255,255,255,255,113,0,126,0,5,113,0,126,0,5,116,0,2,114,117,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,66,255,255,255,255,113,0,126,0,5,113,0,126,0,5,116,0,2,106,97,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,66,255,255,255,255,116,0,2,67,78,113,0,126,0,5,116,0,2,122,104,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,66,255,255,255,255,113,0,126,0,5,113,0,126,0,5,113,0,126,0,83,113,0,126,0,5,113,0,126,0,5,120,120,116,0,8,99,111,110,116,105,110,117,101,116,0,4,80,79,83,84,115,113,0,126,0,12,112,119,4,0,0,0,2,116,0,5,101,109,97,105,108,117,114,0,19,91,76,106,97,118,97,46,108,97,110,103,46,83,116,114,105,110,103,59,173,210,86,231,233,29,123,71,2,0,0,120,112,0,0,0,1,116,0,22,107,97,115,110,103,117,121,101,110,53,48,55,64,103,109,97,105,108,46,99,111,109,116,0,3,111,116,112,117,113,0,126,0,89,0,0,0,1,116,0,6,55,51,51,53,53,50,120,112,116,0,41,101,109,97,105,108,61,107,97,115,110,103,117,121,101,110,53,48,55,37,52,48,103,109,97,105,108,46,99,111,109,38,111,116,112,61,55,51,51,53,53,50,116,0,15,47,97,112,105,47,118,101,114,105,102,121,45,111,116,112,116,0,36,104,116,116,112,58,47,47,108,111,99,97,108,104,111,115,116,58,56,48,56,48,47,97,112,105,47,118,101,114,105,102,121,45,111,116,112,116,0,4,104,116,116,112,116,0,9,108,111,99,97,108,104,111,115,116,116,0,15,47,97,112,105,47,118,101,114,105,102,121,45,111,116,112]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('caaba56e-876c-40e7-8080-ef0a2063330e', 'SPRING_SECURITY_SAVED_REQUEST', '{"type":"Buffer","data":[172,237,0,5,115,114,0,65,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,115,97,118,101,100,114,101,113,117,101,115,116,46,68,101,102,97,117,108,116,83,97,118,101,100,82,101,113,117,101,115,116,0,0,0,0,0,0,2,108,2,0,15,73,0,10,115,101,114,118,101,114,80,111,114,116,76,0,11,99,111,110,116,101,120,116,80,97,116,104,116,0,18,76,106,97,118,97,47,108,97,110,103,47,83,116,114,105,110,103,59,76,0,7,99,111,111,107,105,101,115,116,0,21,76,106,97,118,97,47,117,116,105,108,47,65,114,114,97,121,76,105,115,116,59,76,0,7,104,101,97,100,101,114,115,116,0,15,76,106,97,118,97,47,117,116,105,108,47,77,97,112,59,76,0,7,108,111,99,97,108,101,115,113,0,126,0,2,76,0,28,109,97,116,99,104,105,110,103,82,101,113,117,101,115,116,80,97,114,97,109,101,116,101,114,78,97,109,101,113,0,126,0,1,76,0,6,109,101,116,104,111,100,113,0,126,0,1,76,0,10,112,97,114,97,109,101,116,101,114,115,113,0,126,0,3,76,0,8,112,97,116,104,73,110,102,111,113,0,126,0,1,76,0,11,113,117,101,114,121,83,116,114,105,110,103,113,0,126,0,1,76,0,10,114,101,113,117,101,115,116,85,82,73,113,0,126,0,1,76,0,10,114,101,113,117,101,115,116,85,82,76,113,0,126,0,1,76,0,6,115,99,104,101,109,101,113,0,126,0,1,76,0,10,115,101,114,118,101,114,78,97,109,101,113,0,126,0,1,76,0,11,115,101,114,118,108,101,116,80,97,116,104,113,0,126,0,1,120,112,0,0,31,144,116,0,0,115,114,0,19,106,97,118,97,46,117,116,105,108,46,65,114,114,97,121,76,105,115,116,120,129,210,29,153,199,97,157,3,0,1,73,0,4,115,105,122,101,120,112,0,0,0,1,119,4,0,0,0,1,115,114,0,57,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,115,97,118,101,100,114,101,113,117,101,115,116,46,83,97,118,101,100,67,111,111,107,105,101,0,0,0,0,0,0,2,108,2,0,8,73,0,6,109,97,120,65,103,101,90,0,6,115,101,99,117,114,101,73,0,7,118,101,114,115,105,111,110,76,0,7,99,111,109,109,101,110,116,113,0,126,0,1,76,0,6,100,111,109,97,105,110,113,0,126,0,1,76,0,4,110,97,109,101,113,0,126,0,1,76,0,4,112,97,116,104,113,0,126,0,1,76,0,5,118,97,108,117,101,113,0,126,0,1,120,112,255,255,255,255,0,0,0,0,0,112,112,116,0,7,83,69,83,83,73,79,78,112,116,0,48,78,106,85,52,89,50,90,104,89,106,89,116,77,71,73,121,90,105,48,48,78,122,70,105,76,84,108,108,90,84,73,116,78,84,100,108,77,87,82,107,90,106,65,120,79,84,77,52,120,115,114,0,17,106,97,118,97,46,117,116,105,108,46,84,114,101,101,77,97,112,12,193,246,62,45,37,106,230,3,0,1,76,0,10,99,111,109,112,97,114,97,116,111,114,116,0,22,76,106,97,118,97,47,117,116,105,108,47,67,111,109,112,97,114,97,116,111,114,59,120,112,115,114,0,42,106,97,118,97,46,108,97,110,103,46,83,116,114,105,110,103,36,67,97,115,101,73,110,115,101,110,115,105,116,105,118,101,67,111,109,112,97,114,97,116,111,114,119,3,92,125,92,80,229,206,2,0,0,120,112,119,4,0,0,0,15,116,0,6,97,99,99,101,112,116,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,135,116,101,120,116,47,104,116,109,108,44,97,112,112,108,105,99,97,116,105,111,110,47,120,104,116,109,108,43,120,109,108,44,97,112,112,108,105,99,97,116,105,111,110,47,120,109,108,59,113,61,48,46,57,44,105,109,97,103,101,47,97,118,105,102,44,105,109,97,103,101,47,119,101,98,112,44,105,109,97,103,101,47,97,112,110,103,44,42,47,42,59,113,61,48,46,56,44,97,112,112,108,105,99,97,116,105,111,110,47,115,105,103,110,101,100,45,101,120,99,104,97,110,103,101,59,118,61,98,51,59,113,61,48,46,55,120,116,0,15,97,99,99,101,112,116,45,101,110,99,111,100,105,110,103,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,23,103,122,105,112,44,32,100,101,102,108,97,116,101,44,32,98,114,44,32,122,115,116,100,120,116,0,15,97,99,99,101,112,116,45,108,97,110,103,117,97,103,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,83,118,105,44,102,114,45,70,82,59,113,61,48,46,57,44,102,114,59,113,61,48,46,56,44,101,110,45,85,83,59,113,61,48,46,55,44,101,110,59,113,61,48,46,54,44,114,117,59,113,61,48,46,53,44,106,97,59,113,61,48,46,52,44,122,104,45,67,78,59,113,61,48,46,51,44,122,104,59,113,61,48,46,50,120,116,0,10,99,111,110,110,101,99,116,105,111,110,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,10,107,101,101,112,45,97,108,105,118,101,120,116,0,6,99,111,111,107,105,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,56,83,69,83,83,73,79,78,61,78,106,85,52,89,50,90,104,89,106,89,116,77,71,73,121,90,105,48,48,78,122,70,105,76,84,108,108,90,84,73,116,78,84,100,108,77,87,82,107,90,106,65,120,79,84,77,52,120,116,0,4,104,111,115,116,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,14,108,111,99,97,108,104,111,115,116,58,56,48,56,48,120,116,0,9,115,101,99,45,99,104,45,117,97,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,65,34,67,104,114,111,109,105,117,109,34,59,118,61,34,49,52,56,34,44,32,34,71,111,111,103,108,101,32,67,104,114,111,109,101,34,59,118,61,34,49,52,56,34,44,32,34,78,111,116,47,65,41,66,114,97,110,100,34,59,118,61,34,57,57,34,120,116,0,16,115,101,99,45,99,104,45,117,97,45,109,111,98,105,108,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,2,63,48,120,116,0,18,115,101,99,45,99,104,45,117,97,45,112,108,97,116,102,111,114,109,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,9,34,87,105,110,100,111,119,115,34,120,116,0,14,115,101,99,45,102,101,116,99,104,45,100,101,115,116,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,8,100,111,99,117,109,101,110,116,120,116,0,14,115,101,99,45,102,101,116,99,104,45,109,111,100,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,8,110,97,118,105,103,97,116,101,120,116,0,14,115,101,99,45,102,101,116,99,104,45,115,105,116,101,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,4,110,111,110,101,120,116,0,14,115,101,99,45,102,101,116,99,104,45,117,115,101,114,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,2,63,49,120,116,0,25,117,112,103,114,97,100,101,45,105,110,115,101,99,117,114,101,45,114,101,113,117,101,115,116,115,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,1,49,120,116,0,10,117,115,101,114,45,97,103,101,110,116,115,113,0,126,0,6,0,0,0,1,119,4,0,0,0,1,116,0,111,77,111,122,105,108,108,97,47,53,46,48,32,40,87,105,110,100,111,119,115,32,78,84,32,49,48,46,48,59,32,87,105,110,54,52,59,32,120,54,52,41,32,65,112,112,108,101,87,101,98,75,105,116,47,53,51,55,46,51,54,32,40,75,72,84,77,76,44,32,108,105,107,101,32,71,101,99,107,111,41,32,67,104,114,111,109,101,47,49,52,56,46,48,46,48,46,48,32,83,97,102,97,114,105,47,53,51,55,46,51,54,120,120,115,113,0,126,0,6,0,0,0,9,119,4,0,0,0,9,115,114,0,16,106,97,118,97,46,117,116,105,108,46,76,111,99,97,108,101,126,248,17,96,156,48,249,236,3,0,6,73,0,8,104,97,115,104,99,111,100,101,76,0,7,99,111,117,110,116,114,121,113,0,126,0,1,76,0,10,101,120,116,101,110,115,105,111,110,115,113,0,126,0,1,76,0,8,108,97,110,103,117,97,103,101,113,0,126,0,1,76,0,6,115,99,114,105,112,116,113,0,126,0,1,76,0,7,118,97,114,105,97,110,116,113,0,126,0,1,120,112,255,255,255,255,113,0,126,0,5,113,0,126,0,5,116,0,2,118,105,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,116,0,2,70,82,113,0,126,0,5,116,0,2,102,114,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,113,0,126,0,5,113,0,126,0,5,113,0,126,0,68,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,116,0,2,85,83,113,0,126,0,5,116,0,2,101,110,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,113,0,126,0,5,113,0,126,0,5,113,0,126,0,72,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,113,0,126,0,5,113,0,126,0,5,116,0,2,114,117,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,113,0,126,0,5,113,0,126,0,5,116,0,2,106,97,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,116,0,2,67,78,113,0,126,0,5,116,0,2,122,104,113,0,126,0,5,113,0,126,0,5,120,115,113,0,126,0,63,255,255,255,255,113,0,126,0,5,113,0,126,0,5,113,0,126,0,80,113,0,126,0,5,113,0,126,0,5,120,120,116,0,8,99,111,110,116,105,110,117,101,116,0,3,71,69,84,115,113,0,126,0,12,112,119,4,0,0,0,0,120,112,112,116,0,11,47,97,117,116,104,47,108,111,103,105,110,116,0,32,104,116,116,112,58,47,47,108,111,99,97,108,104,111,115,116,58,56,48,56,48,47,97,117,116,104,47,108,111,103,105,110,116,0,4,104,116,116,112,116,0,9,108,111,99,97,108,104,111,115,116,116,0,11,47,97,117,116,104,47,108,111,103,105,110]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('caaba56e-876c-40e7-8080-ef0a2063330e', 'SPRING_SECURITY_CONTEXT', '{"type":"Buffer","data":[172,237,0,5,115,114,0,61,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,99,111,110,116,101,120,116,46,83,101,99,117,114,105,116,121,67,111,110,116,101,120,116,73,109,112,108,0,0,0,0,0,0,2,108,2,0,1,76,0,14,97,117,116,104,101,110,116,105,99,97,116,105,111,110,116,0,50,76,111,114,103,47,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,47,115,101,99,117,114,105,116,121,47,99,111,114,101,47,65,117,116,104,101,110,116,105,99,97,116,105,111,110,59,120,112,115,114,0,79,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,85,115,101,114,110,97,109,101,80,97,115,115,119,111,114,100,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,0,0,0,0,0,0,2,108,2,0,2,76,0,11,99,114,101,100,101,110,116,105,97,108,115,116,0,18,76,106,97,118,97,47,108,97,110,103,47,79,98,106,101,99,116,59,76,0,9,112,114,105,110,99,105,112,97,108,113,0,126,0,4,120,114,0,71,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,65,98,115,116,114,97,99,116,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,211,170,40,126,110,71,100,14,2,0,3,90,0,13,97,117,116,104,101,110,116,105,99,97,116,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,22,76,106,97,118,97,47,117,116,105,108,47,67,111,108,108,101,99,116,105,111,110,59,76,0,7,100,101,116,97,105,108,115,113,0,126,0,4,120,112,1,115,114,0,38,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,76,105,115,116,252,15,37,49,181,236,142,16,2,0,1,76,0,4,108,105,115,116,116,0,16,76,106,97,118,97,47,117,116,105,108,47,76,105,115,116,59,120,114,0,44,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,67,111,108,108,101,99,116,105,111,110,25,66,0,128,203,94,247,30,2,0,1,76,0,1,99,113,0,126,0,6,120,112,115,114,0,19,106,97,118,97,46,117,116,105,108,46,65,114,114,97,121,76,105,115,116,120,129,210,29,153,199,97,157,3,0,1,73,0,4,115,105,122,101,120,112,0,0,0,1,119,4,0,0,0,1,115,114,0,66,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,97,117,116,104,111,114,105,116,121,46,83,105,109,112,108,101,71,114,97,110,116,101,100,65,117,116,104,111,114,105,116,121,0,0,0,0,0,0,2,108,2,0,1,76,0,4,114,111,108,101,116,0,18,76,106,97,118,97,47,108,97,110,103,47,83,116,114,105,110,103,59,120,112,116,0,10,82,79,76,69,95,65,68,77,73,78,120,113,0,126,0,13,115,114,0,72,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,87,101,98,65,117,116,104,101,110,116,105,99,97,116,105,111,110,68,101,116,97,105,108,115,0,0,0,0,0,0,2,108,2,0,2,76,0,13,114,101,109,111,116,101,65,100,100,114,101,115,115,113,0,126,0,15,76,0,9,115,101,115,115,105,111,110,73,100,113,0,126,0,15,120,112,116,0,15,48,58,48,58,48,58,48,58,48,58,48,58,48,58,49,116,0,36,54,53,56,99,102,97,98,54,45,48,98,50,102,45,52,55,49,98,45,57,101,101,50,45,53,55,101,49,100,100,102,48,49,57,51,56,112,115,114,0,50,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,0,0,0,0,0,0,2,108,2,0,7,90,0,17,97,99,99,111,117,110,116,78,111,110,69,120,112,105,114,101,100,90,0,16,97,99,99,111,117,110,116,78,111,110,76,111,99,107,101,100,90,0,21,99,114,101,100,101,110,116,105,97,108,115,78,111,110,69,120,112,105,114,101,100,90,0,7,101,110,97,98,108,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,15,76,106,97,118,97,47,117,116,105,108,47,83,101,116,59,76,0,8,112,97,115,115,119,111,114,100,113,0,126,0,15,76,0,8,117,115,101,114,110,97,109,101,113,0,126,0,15,120,112,1,1,1,1,115,114,0,37,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,83,101,116,128,29,146,209,143,155,128,85,2,0,0,120,113,0,126,0,10,115,114,0,17,106,97,118,97,46,117,116,105,108,46,84,114,101,101,83,101,116,221,152,80,147,149,237,135,91,3,0,0,120,112,115,114,0,70,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,36,65,117,116,104,111,114,105,116,121,67,111,109,112,97,114,97,116,111,114,0,0,0,0,0,0,2,108,2,0,0,120,112,119,4,0,0,0,1,113,0,126,0,16,120,112,116,0,19,108,101,101,99,111,111,107,99,117,64,103,109,97,105,108,46,99,111,109]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('caaba56e-876c-40e7-8080-ef0a2063330e', 'cart', '{"type":"Buffer","data":[172,237,0,5,115,114,0,17,106,97,118,97,46,117,116,105,108,46,72,97,115,104,77,97,112,5,7,218,193,195,22,96,209,3,0,2,70,0,10,108,111,97,100,70,97,99,116,111,114,73,0,9,116,104,114,101,115,104,111,108,100,120,112,63,64,0,0,0,0,0,0,119,8,0,0,0,16,0,0,0,0,120]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('6e0c05db-60c7-4216-9db9-23bdbd847251', 'cart', '{"type":"Buffer","data":[172,237,0,5,115,114,0,17,106,97,118,97,46,117,116,105,108,46,72,97,115,104,77,97,112,5,7,218,193,195,22,96,209,3,0,2,70,0,10,108,111,97,100,70,97,99,116,111,114,73,0,9,116,104,114,101,115,104,111,108,100,120,112,63,64,0,0,0,0,0,0,119,8,0,0,0,16,0,0,0,0,120]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('6e0c05db-60c7-4216-9db9-23bdbd847251', 'SPRING_SECURITY_CONTEXT', '{"type":"Buffer","data":[172,237,0,5,115,114,0,61,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,99,111,110,116,101,120,116,46,83,101,99,117,114,105,116,121,67,111,110,116,101,120,116,73,109,112,108,0,0,0,0,0,0,2,108,2,0,1,76,0,14,97,117,116,104,101,110,116,105,99,97,116,105,111,110,116,0,50,76,111,114,103,47,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,47,115,101,99,117,114,105,116,121,47,99,111,114,101,47,65,117,116,104,101,110,116,105,99,97,116,105,111,110,59,120,112,115,114,0,83,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,111,97,117,116,104,50,46,99,108,105,101,110,116,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,79,65,117,116,104,50,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,0,0,0,0,0,0,2,108,2,0,2,76,0,30,97,117,116,104,111,114,105,122,101,100,67,108,105,101,110,116,82,101,103,105,115,116,114,97,116,105,111,110,73,100,116,0,18,76,106,97,118,97,47,108,97,110,103,47,83,116,114,105,110,103,59,76,0,9,112,114,105,110,99,105,112,97,108,116,0,58,76,111,114,103,47,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,47,115,101,99,117,114,105,116,121,47,111,97,117,116,104,50,47,99,111,114,101,47,117,115,101,114,47,79,65,117,116,104,50,85,115,101,114,59,120,114,0,71,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,65,98,115,116,114,97,99,116,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,211,170,40,126,110,71,100,14,2,0,3,90,0,13,97,117,116,104,101,110,116,105,99,97,116,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,22,76,106,97,118,97,47,117,116,105,108,47,67,111,108,108,101,99,116,105,111,110,59,76,0,7,100,101,116,97,105,108,115,116,0,18,76,106,97,118,97,47,108,97,110,103,47,79,98,106,101,99,116,59,120,112,1,115,114,0,38,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,76,105,115,116,252,15,37,49,181,236,142,16,2,0,1,76,0,4,108,105,115,116,116,0,16,76,106,97,118,97,47,117,116,105,108,47,76,105,115,116,59,120,114,0,44,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,67,111,108,108,101,99,116,105,111,110,25,66,0,128,203,94,247,30,2,0,1,76,0,1,99,113,0,126,0,7,120,112,115,114,0,19,106,97,118,97,46,117,116,105,108,46,65,114,114,97,121,76,105,115,116,120,129,210,29,153,199,97,157,3,0,1,73,0,4,115,105,122,101,120,112,0,0,0,4,119,4,0,0,0,4,115,114,0,65,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,111,97,117,116,104,50,46,99,111,114,101,46,117,115,101,114,46,79,65,117,116,104,50,85,115,101,114,65,117,116,104,111,114,105,116,121,0,0,0,0,0,0,2,108,2,0,2,76,0,10,97,116,116,114,105,98,117,116,101,115,116,0,15,76,106,97,118,97,47,117,116,105,108,47,77,97,112,59,76,0,9,97,117,116,104,111,114,105,116,121,113,0,126,0,4,120,112,115,114,0,37,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,77,97,112,241,165,168,254,116,245,7,66,2,0,1,76,0,1,109,113,0,126,0,17,120,112,115,114,0,23,106,97,118,97,46,117,116,105,108,46,76,105,110,107,101,100,72,97,115,104,77,97,112,52,192,78,92,16,108,192,251,2,0,1,90,0,11,97,99,99,101,115,115,79,114,100,101,114,120,114,0,17,106,97,118,97,46,117,116,105,108,46,72,97,115,104,77,97,112,5,7,218,193,195,22,96,209,3,0,2,70,0,10,108,111,97,100,70,97,99,116,111,114,73,0,9,116,104,114,101,115,104,111,108,100,120,112,63,64,0,0,0,0,0,12,119,8,0,0,0,16,0,0,0,7,116,0,3,115,117,98,116,0,21,49,48,53,52,57,48,53,55,54,56,54,55,54,56,53,53,57,55,54,48,55,116,0,4,110,97,109,101,116,0,12,75,97,115,32,78,103,117,121,225,187,133,110,116,0,10,103,105,118,101,110,95,110,97,109,101,116,0,3,75,97,115,116,0,11,102,97,109,105,108,121,95,110,97,109,101,116,0,8,78,103,117,121,225,187,133,110,116,0,7,112,105,99,116,117,114,101,116,0,97,104,116,116,112,115,58,47,47,108,104,51,46,103,111,111,103,108,101,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,97,47,65,67,103,56,111,99,73,50,89,122,98,117,102,103,79,53,88,115,86,105,105,87,67,95,108,75,116,70,88,50,66,90,85,84,111,82,88,73,122,113,107,78,85,83,115,98,108,54,119,77,99,117,69,110,103,61,115,57,54,45,99,116,0,5,101,109,97,105,108,116,0,22,107,97,115,110,103,117,121,101,110,53,48,55,64,103,109,97,105,108,46,99,111,109,116,0,14,101,109,97,105,108,95,118,101,114,105,102,105,101,100,115,114,0,17,106,97,118,97,46,108,97,110,103,46,66,111,111,108,101,97,110,205,32,114,128,213,156,250,238,2,0,1,90,0,5,118,97,108,117,101,120,112,1,120,0,116,0,11,79,65,85,84,72,50,95,85,83,69,82,115,114,0,66,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,97,117,116,104,111,114,105,116,121,46,83,105,109,112,108,101,71,114,97,110,116,101,100,65,117,116,104,111,114,105,116,121,0,0,0,0,0,0,2,108,2,0,1,76,0,4,114,111,108,101,113,0,126,0,4,120,112,116,0,52,83,67,79,80,69,95,104,116,116,112,115,58,47,47,119,119,119,46,103,111,111,103,108,101,97,112,105,115,46,99,111,109,47,97,117,116,104,47,117,115,101,114,105,110,102,111,46,101,109,97,105,108,115,113,0,126,0,40,116,0,54,83,67,79,80,69,95,104,116,116,112,115,58,47,47,119,119,119,46,103,111,111,103,108,101,97,112,105,115,46,99,111,109,47,97,117,116,104,47,117,115,101,114,105,110,102,111,46,112,114,111,102,105,108,101,115,113,0,126,0,40,116,0,12,83,67,79,80,69,95,111,112,101,110,105,100,120,113,0,126,0,15,115,114,0,72,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,87,101,98,65,117,116,104,101,110,116,105,99,97,116,105,111,110,68,101,116,97,105,108,115,0,0,0,0,0,0,2,108,2,0,2,76,0,13,114,101,109,111,116,101,65,100,100,114,101,115,115,113,0,126,0,4,76,0,9,115,101,115,115,105,111,110,73,100,113,0,126,0,4,120,112,116,0,15,48,58,48,58,48,58,48,58,48,58,48,58,48,58,49,116,0,36,50,52,49,52,97,57,54,52,45,97,53,51,98,45,52,50,56,102,45,56,49,99,52,45,101,100,99,98,55,53,100,54,54,48,101,101,116,0,6,103,111,111,103,108,101,115,114,0,34,112,111,108,121,46,101,100,117,46,115,101,99,117,114,105,116,121,46,67,117,115,116,111,109,79,65,117,116,104,50,85,115,101,114,0,0,0,0,0,0,0,1,2,0,2,76,0,10,99,108,105,101,110,116,78,97,109,101,113,0,126,0,4,76,0,10,111,97,117,116,104,50,85,115,101,114,113,0,126,0,5,120,112,116,0,6,71,111,111,103,108,101,115,114,0,63,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,111,97,117,116,104,50,46,99,111,114,101,46,117,115,101,114,46,68,101,102,97,117,108,116,79,65,117,116,104,50,85,115,101,114,0,0,0,0,0,0,2,108,2,0,3,76,0,10,97,116,116,114,105,98,117,116,101,115,113,0,126,0,17,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,15,76,106,97,118,97,47,117,116,105,108,47,83,101,116,59,76,0,16,110,97,109,101,65,116,116,114,105,98,117,116,101,75,101,121,113,0,126,0,4,120,112,115,113,0,126,0,19,115,113,0,126,0,21,63,64,0,0,0,0,0,12,119,8,0,0,0,16,0,0,0,7,113,0,126,0,24,113,0,126,0,25,113,0,126,0,26,113,0,126,0,27,113,0,126,0,28,113,0,126,0,29,113,0,126,0,30,113,0,126,0,31,113,0,126,0,32,113,0,126,0,33,113,0,126,0,34,113,0,126,0,35,113,0,126,0,36,113,0,126,0,38,120,0,115,114,0,37,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,83,101,116,128,29,146,209,143,155,128,85,2,0,0,120,113,0,126,0,12,115,114,0,23,106,97,118,97,46,117,116,105,108,46,76,105,110,107,101,100,72,97,115,104,83,101,116,216,108,215,90,149,221,42,30,2,0,0,120,114,0,17,106,97,118,97,46,117,116,105,108,46,72,97,115,104,83,101,116,186,68,133,149,150,184,183,52,3,0,0,120,112,119,12,0,0,0,16,63,64,0,0,0,0,0,4,113,0,126,0,18,113,0,126,0,41,113,0,126,0,43,113,0,126,0,45,120,113,0,126,0,24]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('e5d6a1e8-7d77-4bbe-9ab3-7c6ca6ad73f0', 'SPRING_SECURITY_CONTEXT', '{"type":"Buffer","data":[172,237,0,5,115,114,0,61,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,99,111,110,116,101,120,116,46,83,101,99,117,114,105,116,121,67,111,110,116,101,120,116,73,109,112,108,0,0,0,0,0,0,2,108,2,0,1,76,0,14,97,117,116,104,101,110,116,105,99,97,116,105,111,110,116,0,50,76,111,114,103,47,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,47,115,101,99,117,114,105,116,121,47,99,111,114,101,47,65,117,116,104,101,110,116,105,99,97,116,105,111,110,59,120,112,115,114,0,79,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,85,115,101,114,110,97,109,101,80,97,115,115,119,111,114,100,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,0,0,0,0,0,0,2,108,2,0,2,76,0,11,99,114,101,100,101,110,116,105,97,108,115,116,0,18,76,106,97,118,97,47,108,97,110,103,47,79,98,106,101,99,116,59,76,0,9,112,114,105,110,99,105,112,97,108,113,0,126,0,4,120,114,0,71,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,65,98,115,116,114,97,99,116,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,211,170,40,126,110,71,100,14,2,0,3,90,0,13,97,117,116,104,101,110,116,105,99,97,116,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,22,76,106,97,118,97,47,117,116,105,108,47,67,111,108,108,101,99,116,105,111,110,59,76,0,7,100,101,116,97,105,108,115,113,0,126,0,4,120,112,1,115,114,0,38,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,76,105,115,116,252,15,37,49,181,236,142,16,2,0,1,76,0,4,108,105,115,116,116,0,16,76,106,97,118,97,47,117,116,105,108,47,76,105,115,116,59,120,114,0,44,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,67,111,108,108,101,99,116,105,111,110,25,66,0,128,203,94,247,30,2,0,1,76,0,1,99,113,0,126,0,6,120,112,115,114,0,19,106,97,118,97,46,117,116,105,108,46,65,114,114,97,121,76,105,115,116,120,129,210,29,153,199,97,157,3,0,1,73,0,4,115,105,122,101,120,112,0,0,0,1,119,4,0,0,0,1,115,114,0,66,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,97,117,116,104,111,114,105,116,121,46,83,105,109,112,108,101,71,114,97,110,116,101,100,65,117,116,104,111,114,105,116,121,0,0,0,0,0,0,2,108,2,0,1,76,0,4,114,111,108,101,116,0,18,76,106,97,118,97,47,108,97,110,103,47,83,116,114,105,110,103,59,120,112,116,0,9,82,79,76,69,95,85,83,69,82,120,113,0,126,0,13,115,114,0,72,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,87,101,98,65,117,116,104,101,110,116,105,99,97,116,105,111,110,68,101,116,97,105,108,115,0,0,0,0,0,0,2,108,2,0,2,76,0,13,114,101,109,111,116,101,65,100,100,114,101,115,115,113,0,126,0,15,76,0,9,115,101,115,115,105,111,110,73,100,113,0,126,0,15,120,112,116,0,15,48,58,48,58,48,58,48,58,48,58,48,58,48,58,49,116,0,36,52,97,49,97,57,97,97,100,45,51,54,55,102,45,52,99,56,99,45,57,54,97,102,45,101,55,48,101,101,100,100,100,52,57,57,54,112,115,114,0,50,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,0,0,0,0,0,0,2,108,2,0,7,90,0,17,97,99,99,111,117,110,116,78,111,110,69,120,112,105,114,101,100,90,0,16,97,99,99,111,117,110,116,78,111,110,76,111,99,107,101,100,90,0,21,99,114,101,100,101,110,116,105,97,108,115,78,111,110,69,120,112,105,114,101,100,90,0,7,101,110,97,98,108,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,15,76,106,97,118,97,47,117,116,105,108,47,83,101,116,59,76,0,8,112,97,115,115,119,111,114,100,113,0,126,0,15,76,0,8,117,115,101,114,110,97,109,101,113,0,126,0,15,120,112,1,1,1,1,115,114,0,37,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,83,101,116,128,29,146,209,143,155,128,85,2,0,0,120,113,0,126,0,10,115,114,0,17,106,97,118,97,46,117,116,105,108,46,84,114,101,101,83,101,116,221,152,80,147,149,237,135,91,3,0,0,120,112,115,114,0,70,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,36,65,117,116,104,111,114,105,116,121,67,111,109,112,97,114,97,116,111,114,0,0,0,0,0,0,2,108,2,0,0,120,112,119,4,0,0,0,1,113,0,126,0,16,120,112,116,0,22,107,97,115,110,103,117,121,101,110,53,48,55,64,103,109,97,105,108,46,99,111,109]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('208a2255-0f09-481f-8bc1-232e99c2ff5d', 'SPRING_SECURITY_CONTEXT', '{"type":"Buffer","data":[172,237,0,5,115,114,0,61,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,99,111,110,116,101,120,116,46,83,101,99,117,114,105,116,121,67,111,110,116,101,120,116,73,109,112,108,0,0,0,0,0,0,2,108,2,0,1,76,0,14,97,117,116,104,101,110,116,105,99,97,116,105,111,110,116,0,50,76,111,114,103,47,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,47,115,101,99,117,114,105,116,121,47,99,111,114,101,47,65,117,116,104,101,110,116,105,99,97,116,105,111,110,59,120,112,115,114,0,79,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,85,115,101,114,110,97,109,101,80,97,115,115,119,111,114,100,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,0,0,0,0,0,0,2,108,2,0,2,76,0,11,99,114,101,100,101,110,116,105,97,108,115,116,0,18,76,106,97,118,97,47,108,97,110,103,47,79,98,106,101,99,116,59,76,0,9,112,114,105,110,99,105,112,97,108,113,0,126,0,4,120,114,0,71,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,65,98,115,116,114,97,99,116,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,211,170,40,126,110,71,100,14,2,0,3,90,0,13,97,117,116,104,101,110,116,105,99,97,116,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,22,76,106,97,118,97,47,117,116,105,108,47,67,111,108,108,101,99,116,105,111,110,59,76,0,7,100,101,116,97,105,108,115,113,0,126,0,4,120,112,1,115,114,0,38,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,76,105,115,116,252,15,37,49,181,236,142,16,2,0,1,76,0,4,108,105,115,116,116,0,16,76,106,97,118,97,47,117,116,105,108,47,76,105,115,116,59,120,114,0,44,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,67,111,108,108,101,99,116,105,111,110,25,66,0,128,203,94,247,30,2,0,1,76,0,1,99,113,0,126,0,6,120,112,115,114,0,19,106,97,118,97,46,117,116,105,108,46,65,114,114,97,121,76,105,115,116,120,129,210,29,153,199,97,157,3,0,1,73,0,4,115,105,122,101,120,112,0,0,0,1,119,4,0,0,0,1,115,114,0,66,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,97,117,116,104,111,114,105,116,121,46,83,105,109,112,108,101,71,114,97,110,116,101,100,65,117,116,104,111,114,105,116,121,0,0,0,0,0,0,2,108,2,0,1,76,0,4,114,111,108,101,116,0,18,76,106,97,118,97,47,108,97,110,103,47,83,116,114,105,110,103,59,120,112,116,0,10,82,79,76,69,95,65,68,77,73,78,120,113,0,126,0,13,115,114,0,72,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,87,101,98,65,117,116,104,101,110,116,105,99,97,116,105,111,110,68,101,116,97,105,108,115,0,0,0,0,0,0,2,108,2,0,2,76,0,13,114,101,109,111,116,101,65,100,100,114,101,115,115,113,0,126,0,15,76,0,9,115,101,115,115,105,111,110,73,100,113,0,126,0,15,120,112,116,0,15,48,58,48,58,48,58,48,58,48,58,48,58,48,58,49,116,0,36,99,54,51,98,52,98,98,52,45,57,99,98,100,45,52,102,102,55,45,98,98,100,97,45,97,100,101,99,55,48,56,102,55,48,53,101,112,115,114,0,50,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,0,0,0,0,0,0,2,108,2,0,7,90,0,17,97,99,99,111,117,110,116,78,111,110,69,120,112,105,114,101,100,90,0,16,97,99,99,111,117,110,116,78,111,110,76,111,99,107,101,100,90,0,21,99,114,101,100,101,110,116,105,97,108,115,78,111,110,69,120,112,105,114,101,100,90,0,7,101,110,97,98,108,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,15,76,106,97,118,97,47,117,116,105,108,47,83,101,116,59,76,0,8,112,97,115,115,119,111,114,100,113,0,126,0,15,76,0,8,117,115,101,114,110,97,109,101,113,0,126,0,15,120,112,1,1,1,1,115,114,0,37,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,83,101,116,128,29,146,209,143,155,128,85,2,0,0,120,113,0,126,0,10,115,114,0,17,106,97,118,97,46,117,116,105,108,46,84,114,101,101,83,101,116,221,152,80,147,149,237,135,91,3,0,0,120,112,115,114,0,70,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,36,65,117,116,104,111,114,105,116,121,67,111,109,112,97,114,97,116,111,114,0,0,0,0,0,0,2,108,2,0,0,120,112,119,4,0,0,0,1,113,0,126,0,16,120,112,116,0,27,116,117,97,110,57,98,108,101,100,105,110,104,99,104,105,110,104,64,103,109,97,105,108,46,99,111,109]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('208a2255-0f09-481f-8bc1-232e99c2ff5d', 'cart', '{"type":"Buffer","data":[172,237,0,5,115,114,0,17,106,97,118,97,46,117,116,105,108,46,72,97,115,104,77,97,112,5,7,218,193,195,22,96,209,3,0,2,70,0,10,108,111,97,100,70,97,99,116,111,114,73,0,9,116,104,114,101,115,104,111,108,100,120,112,63,64,0,0,0,0,0,0,119,8,0,0,0,16,0,0,0,0,120]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('82866743-8dff-44a6-a51b-9762bc0f05ca', 'cart', '{"type":"Buffer","data":[172,237,0,5,115,114,0,17,106,97,118,97,46,117,116,105,108,46,72,97,115,104,77,97,112,5,7,218,193,195,22,96,209,3,0,2,70,0,10,108,111,97,100,70,97,99,116,111,114,73,0,9,116,104,114,101,115,104,111,108,100,120,112,63,64,0,0,0,0,0,0,119,8,0,0,0,16,0,0,0,0,120]}');
INSERT INTO public."spring_session_attributes" ("session_primary_id", "attribute_name", "attribute_bytes") VALUES ('82866743-8dff-44a6-a51b-9762bc0f05ca', 'SPRING_SECURITY_CONTEXT', '{"type":"Buffer","data":[172,237,0,5,115,114,0,61,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,99,111,110,116,101,120,116,46,83,101,99,117,114,105,116,121,67,111,110,116,101,120,116,73,109,112,108,0,0,0,0,0,0,2,108,2,0,1,76,0,14,97,117,116,104,101,110,116,105,99,97,116,105,111,110,116,0,50,76,111,114,103,47,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,47,115,101,99,117,114,105,116,121,47,99,111,114,101,47,65,117,116,104,101,110,116,105,99,97,116,105,111,110,59,120,112,115,114,0,79,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,85,115,101,114,110,97,109,101,80,97,115,115,119,111,114,100,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,0,0,0,0,0,0,2,108,2,0,2,76,0,11,99,114,101,100,101,110,116,105,97,108,115,116,0,18,76,106,97,118,97,47,108,97,110,103,47,79,98,106,101,99,116,59,76,0,9,112,114,105,110,99,105,112,97,108,113,0,126,0,4,120,114,0,71,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,65,98,115,116,114,97,99,116,65,117,116,104,101,110,116,105,99,97,116,105,111,110,84,111,107,101,110,211,170,40,126,110,71,100,14,2,0,3,90,0,13,97,117,116,104,101,110,116,105,99,97,116,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,22,76,106,97,118,97,47,117,116,105,108,47,67,111,108,108,101,99,116,105,111,110,59,76,0,7,100,101,116,97,105,108,115,113,0,126,0,4,120,112,1,115,114,0,38,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,76,105,115,116,252,15,37,49,181,236,142,16,2,0,1,76,0,4,108,105,115,116,116,0,16,76,106,97,118,97,47,117,116,105,108,47,76,105,115,116,59,120,114,0,44,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,67,111,108,108,101,99,116,105,111,110,25,66,0,128,203,94,247,30,2,0,1,76,0,1,99,113,0,126,0,6,120,112,115,114,0,19,106,97,118,97,46,117,116,105,108,46,65,114,114,97,121,76,105,115,116,120,129,210,29,153,199,97,157,3,0,1,73,0,4,115,105,122,101,120,112,0,0,0,1,119,4,0,0,0,1,115,114,0,66,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,97,117,116,104,111,114,105,116,121,46,83,105,109,112,108,101,71,114,97,110,116,101,100,65,117,116,104,111,114,105,116,121,0,0,0,0,0,0,2,108,2,0,1,76,0,4,114,111,108,101,116,0,18,76,106,97,118,97,47,108,97,110,103,47,83,116,114,105,110,103,59,120,112,116,0,10,82,79,76,69,95,65,68,77,73,78,120,113,0,126,0,13,115,114,0,72,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,119,101,98,46,97,117,116,104,101,110,116,105,99,97,116,105,111,110,46,87,101,98,65,117,116,104,101,110,116,105,99,97,116,105,111,110,68,101,116,97,105,108,115,0,0,0,0,0,0,2,108,2,0,2,76,0,13,114,101,109,111,116,101,65,100,100,114,101,115,115,113,0,126,0,15,76,0,9,115,101,115,115,105,111,110,73,100,113,0,126,0,15,120,112,116,0,15,48,58,48,58,48,58,48,58,48,58,48,58,48,58,49,116,0,36,53,55,54,50,49,48,99,101,45,99,51,57,53,45,52,56,49,100,45,97,55,52,53,45,54,52,97,52,52,98,50,57,97,56,99,49,112,115,114,0,50,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,0,0,0,0,0,0,2,108,2,0,7,90,0,17,97,99,99,111,117,110,116,78,111,110,69,120,112,105,114,101,100,90,0,16,97,99,99,111,117,110,116,78,111,110,76,111,99,107,101,100,90,0,21,99,114,101,100,101,110,116,105,97,108,115,78,111,110,69,120,112,105,114,101,100,90,0,7,101,110,97,98,108,101,100,76,0,11,97,117,116,104,111,114,105,116,105,101,115,116,0,15,76,106,97,118,97,47,117,116,105,108,47,83,101,116,59,76,0,8,112,97,115,115,119,111,114,100,113,0,126,0,15,76,0,8,117,115,101,114,110,97,109,101,113,0,126,0,15,120,112,1,1,1,1,115,114,0,37,106,97,118,97,46,117,116,105,108,46,67,111,108,108,101,99,116,105,111,110,115,36,85,110,109,111,100,105,102,105,97,98,108,101,83,101,116,128,29,146,209,143,155,128,85,2,0,0,120,113,0,126,0,10,115,114,0,17,106,97,118,97,46,117,116,105,108,46,84,114,101,101,83,101,116,221,152,80,147,149,237,135,91,3,0,0,120,112,115,114,0,70,111,114,103,46,115,112,114,105,110,103,102,114,97,109,101,119,111,114,107,46,115,101,99,117,114,105,116,121,46,99,111,114,101,46,117,115,101,114,100,101,116,97,105,108,115,46,85,115,101,114,36,65,117,116,104,111,114,105,116,121,67,111,109,112,97,114,97,116,111,114,0,0,0,0,0,0,2,108,2,0,0,120,112,119,4,0,0,0,1,113,0,126,0,16,120,112,116,0,27,116,117,97,110,57,98,108,101,100,105,110,104,99,104,105,110,104,64,103,109,97,105,108,46,99,111,109]}');

-- Data for Name: support_tickets;
INSERT INTO public."support_tickets" ("id", "admin_reply", "assigned_admin", "build_config", "category", "created_at", "customer_email", "customer_name", "customer_phone", "message", "status", "subject", "updated_at", "user_id") VALUES (6, NULL, 'leecookcu@gmail.com', NULL, 'GENERAL', '2026-06-20T18:18:04.043Z', 'phamcongthanh.8311@gmail.com', 'thanh', '', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CLOSED', 'Chat hỗ trợ trực tuyến', '2026-06-21T06:10:11.781Z', 29);
INSERT INTO public."support_tickets" ("id", "admin_reply", "assigned_admin", "build_config", "category", "created_at", "customer_email", "customer_name", "customer_phone", "message", "status", "subject", "updated_at", "user_id") VALUES (7, NULL, 'leecookcu@gmail.com', NULL, 'GENERAL', '2026-06-23T09:34:27.632Z', 'phamcongthanh.8311@gmail.com', 'thanh', '', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'IN_PROGRESS', 'Chat hỗ trợ trực tuyến', '2026-06-23T10:09:43.807Z', 29);
INSERT INTO public."support_tickets" ("id", "admin_reply", "assigned_admin", "build_config", "category", "created_at", "customer_email", "customer_name", "customer_phone", "message", "status", "subject", "updated_at", "user_id") VALUES (8, NULL, 'tuan9bledinhchinh@gmail.com', NULL, 'GENERAL', '2026-07-14T02:45:54.780Z', 'tuan9bledinhchinh@gmail.com', '36', '', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'IN_PROGRESS', 'Chat hỗ trợ trực tuyến', '2026-07-14T02:45:59.943Z', 9);
INSERT INTO public."support_tickets" ("id", "admin_reply", "assigned_admin", "build_config", "category", "created_at", "customer_email", "customer_name", "customer_phone", "message", "status", "subject", "updated_at", "user_id") VALUES (9, NULL, 'leecookcu@gmail.com', NULL, 'GENERAL', '2026-07-14T06:29:48.231Z', 'phamcongthanh.8311@gmail.com', 'Thanh', '', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'IN_PROGRESS', 'Chat hỗ trợ trực tuyến', '2026-07-14T06:30:11.568Z', 29);
INSERT INTO public."support_tickets" ("id", "admin_reply", "assigned_admin", "build_config", "category", "created_at", "customer_email", "customer_name", "customer_phone", "message", "status", "subject", "updated_at", "user_id") VALUES (10, NULL, NULL, NULL, 'GENERAL', '2026-07-14T10:19:18.965Z', 'tuan9bledinhchinh@gmail.com', '36', '', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'OPEN', 'Chat hỗ trợ trực tuyến', '2026-07-14T10:19:18.965Z', 9);
INSERT INTO public."support_tickets" ("id", "admin_reply", "assigned_admin", "build_config", "category", "created_at", "customer_email", "customer_name", "customer_phone", "message", "status", "subject", "updated_at", "user_id") VALUES (11, NULL, NULL, NULL, 'GENERAL', '2026-07-15T03:47:51.665Z', 'phamcongthanh.8311@gmail.com', 'Thanh', '', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'OPEN', 'Chat hỗ trợ trực tuyến', '2026-07-15T03:47:51.665Z', 29);

-- Data for Name: user_vouchers;
INSERT INTO public."user_vouchers" ("id", "is_used", "saved_at", "used_at", "user_id", "voucher_id") VALUES (5, true, '2026-06-22T04:17:50.136Z', '2026-06-23T10:04:55.862Z', 29, 10);
INSERT INTO public."user_vouchers" ("id", "is_used", "saved_at", "used_at", "user_id", "voucher_id") VALUES (4, true, '2026-06-22T01:52:21.587Z', '2026-06-23T10:52:55.648Z', 29, 9);
INSERT INTO public."user_vouchers" ("id", "is_used", "saved_at", "used_at", "user_id", "voucher_id") VALUES (6, true, '2026-07-02T04:01:44.810Z', '2026-07-02T04:03:00.417Z', 29, 15);
INSERT INTO public."user_vouchers" ("id", "is_used", "saved_at", "used_at", "user_id", "voucher_id") VALUES (7, false, '2026-07-03T02:06:24.278Z', NULL, 9, 15);
INSERT INTO public."user_vouchers" ("id", "is_used", "saved_at", "used_at", "user_id", "voucher_id") VALUES (8, false, '2026-07-03T02:06:36.215Z', NULL, 9, 9);

-- Data for Name: vouchers;
INSERT INTO public."vouchers" ("id", "active", "code", "created_at", "description", "discount_type", "discount_value", "end_date", "max_discount_amount", "min_order_amount", "start_date", "usage_limit", "used_count", "category_id") VALUES (10, true, 'LXR36', '2026-06-22T03:52:53.047Z', 'Giảm giá 15% các mặt hàng', 'PERCENTAGE', 15, '2026-06-29T17:00:00.000Z', 50000, 10000, NULL, 100, 2, NULL);
INSERT INTO public."vouchers" ("id", "active", "code", "created_at", "description", "discount_type", "discount_value", "end_date", "max_discount_amount", "min_order_amount", "start_date", "usage_limit", "used_count", "category_id") VALUES (14, true, 'LUX50', '2026-06-23T10:08:51.750Z', 'giảm giá 50', 'PERCENTAGE', 50, '2026-06-30T05:00:00.000Z', 10000000, 1000000, NULL, 10, 0, NULL);
INSERT INTO public."vouchers" ("id", "active", "code", "created_at", "description", "discount_type", "discount_value", "end_date", "max_discount_amount", "min_order_amount", "start_date", "usage_limit", "used_count", "category_id") VALUES (9, true, 'LXR500', '2026-06-21T11:32:38.194Z', '20', 'PERCENTAGE', 1000, '2028-06-09T03:10:00.000Z', 500000, 5000, NULL, 99, 2, 4);
INSERT INTO public."vouchers" ("id", "active", "code", "created_at", "description", "discount_type", "discount_value", "end_date", "max_discount_amount", "min_order_amount", "start_date", "usage_limit", "used_count", "category_id") VALUES (11, true, 'LUX30', '2026-06-22T04:22:49.617Z', 'Giảm giá 30%', 'PERCENTAGE', 30, '2026-08-11T05:00:00.000Z', 5000000, 0, NULL, 0, 0, NULL);
INSERT INTO public."vouchers" ("id", "active", "code", "created_at", "description", "discount_type", "discount_value", "end_date", "max_discount_amount", "min_order_amount", "start_date", "usage_limit", "used_count", "category_id") VALUES (15, true, 'LUX10', '2026-07-02T04:00:17.172Z', 'Giảm 10% cho tất cả đơn hàng', 'PERCENTAGE', 10, '2026-07-31T05:00:00.000Z', 10000000, 0, NULL, 10, 2, NULL);

-- Data for Name: wishlist_items;
INSERT INTO public."wishlist_items" ("id", "created_at", "product_id", "user_id") VALUES (53, '2026-06-29T14:14:37.800Z', 23, 9);
INSERT INTO public."wishlist_items" ("id", "created_at", "product_id", "user_id") VALUES (61, '2026-07-14T04:28:57.940Z', 280, 29);
INSERT INTO public."wishlist_items" ("id", "created_at", "product_id", "user_id") VALUES (62, '2026-07-14T04:29:01.571Z', 281, 29);
INSERT INTO public."wishlist_items" ("id", "created_at", "product_id", "user_id") VALUES (63, '2026-07-14T04:29:04.825Z', 259, 29);
INSERT INTO public."wishlist_items" ("id", "created_at", "product_id", "user_id") VALUES (64, '2026-07-14T04:48:13.712Z', 283, 29);
INSERT INTO public."wishlist_items" ("id", "created_at", "product_id", "user_id") VALUES (65, '2026-07-14T05:01:09.248Z', 256, 29);
INSERT INTO public."wishlist_items" ("id", "created_at", "product_id", "user_id") VALUES (70, '2026-07-14T06:44:58.850Z', 278, 29);
INSERT INTO public."wishlist_items" ("id", "created_at", "product_id", "user_id") VALUES (71, '2026-07-14T07:29:47.096Z', 284, 29);
INSERT INTO public."wishlist_items" ("id", "created_at", "product_id", "user_id") VALUES (74, '2026-07-16T02:09:11.326Z', 57, 29);

-- Data for Name: order_items;
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (1, 1, 7, 17200000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (2, 2, 12, 8500000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (3, 3, 13, 25900000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (4, 4, 14, 18600000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (5, 5, 14, 6900000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (7, 7, 7, 19900000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (8, 8, 12, 21500000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (9, 9, 13, 15700000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (10, 10, 7, 18500000, 10);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (11, 10, 12, 3200000, 9);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (12, 17, 89, 1, 2);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (13, 18, 14, 1800000, 2);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (14, 19, 13, 3800000, 3);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (15, 20, 23, 6500000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (16, 21, 54, 10000000, 10);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (17, 22, 13, 3000000, 30);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (18, 23, 3, 3000000, 40);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (19, 24, 17, 5600000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (20, 25, 19, 7200000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (21, 26, 18, 6200000, 5);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (22, 27, 18, 6200000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (23, 28, 22, 1950000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (24, 29, 22, 1950000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (25, 30, 22, 1950000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (26, 31, 256, 12000000, 3);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (27, 31, 274, 2000000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (28, 31, 259, 7500000, 3);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (29, 31, 275, 3500000, 2);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (30, 31, 276, 2800000, 3);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (31, 31, 262, 1200000, 3);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (32, 31, 264, 25000000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (33, 31, 265, 35000000, 2);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (34, 31, 268, 1800000, 3);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (35, 31, 270, 3500000, 3);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (36, 32, 277, 600000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (37, 33, 279, 16500000, 50);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (38, 34, 257, 2500000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (39, 35, 277, 600000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (40, 36, 286, 8500000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (41, 37, 286, 8500000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (50, 46, 279, 16500000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (51, 47, 260, 1800000, 1);
INSERT INTO public."order_items" ("id", "order_id", "product_id", "price", "quantity") VALUES (52, 48, 287, 10000, 1);

-- Data for Name: orders;
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (26, NULL, 31000000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH26', 'md', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-07T04:21:45.734Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (2, NULL, 8500000, 'DA_HUY', 'DEMO-COD-PENDING', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-17T17:12:47.414Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (10, NULL, 213800000, 'COMPLETED', 'DH10', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-20T16:44:16.695Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (17, 29, 2, 'PENDING', 'DH17', 'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', '7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, 0, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-22T04:19:22.674Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (18, 29, 3550000, 'SHIPPING', 'DH18', 'Thanh Pham', 'leecookcu@gmail.com', '0902208461', 'TPHCM', NULL, 50000, 'LXR36', NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-23T10:04:56.396Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (19, 29, 10900000, 'PENDING', 'DH19', 'Thanh Pham', 'leecookcu@gmail.com', '0902208461', 'TPHCM', NULL, 500000, 'LXR500', NULL, '0.00', NULL, 'INSTALLMENT', NULL, NULL, NULL, NULL, NULL, '2026-06-23T10:52:55.979Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (20, 9, 6500000, 'PENDING', 'DH20', 'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', 'tp', NULL, 0, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-29T14:15:31.495Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (21, 29, 90000000, 'PENDING', 'DH21', 'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', '7/134/29/9 đường liên khu 5-6', NULL, 10000000, 'LUX10', NULL, '0.00', NULL, 'INSTALLMENT', NULL, NULL, NULL, NULL, NULL, '2026-07-02T04:03:00.775Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (22, NULL, 90000000, 'PENDING', 'DH22', 'Phạm Công Thanh', NULL, '0902208461', '7/134/29/9 đường liên khu 5-6', NULL, 0, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-02T06:03:06.903Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (23, NULL, 120000000, 'PENDING', 'DH23', 'Phạm Công Thanh', NULL, '0902208461', '7/134/29/9 đường liên khu 5-6', NULL, 0, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-02T06:03:58.891Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (24, 9, 5600000, 'PENDING', 'DH24', 'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', 'tp', NULL, 0, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-03T02:00:31.482Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (25, 9, 7200000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH25', 'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', 'tp', NULL, 0, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-03T02:05:44.010Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (27, NULL, 6200000, 'PENDING', 'DH27', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07T04:22:24.148Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (28, NULL, 1950000, 'PENDING', 'DH28', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07T10:24:58.208Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (29, NULL, 1950000, 'PENDING', 'DH29', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07T11:17:37.769Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (30, 38, 1950000, 'THU_HOI', 'DH30', 'tuan nguyen', 'tuannguyennasani@gmail.com', '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07T12:57:59.626Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (1, NULL, 17200000, 'CHO_XAC_NHAN_THANH_TOAN', 'DEMO-VIETQR-WAITING', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-06-18T17:12:46.958Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (3, NULL, 25900000, 'DA_THANH_TOAN', 'DEMO-VIETQR-PAID', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-06-16T17:12:47.866Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (6, NULL, 12500000, 'COMPLETED', 'DEMO-VOUCHER-COMPLETED', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, 500000, 'QA500K', NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-13T17:12:49.207Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (5, NULL, 6900000, 'COMPLETED', 'DEMO-CANCELLED', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-14T17:12:48.753Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (4, NULL, 18600000, 'DA_HOAN_TIEN', 'DEMO-VIETQR-REFUND-REQUESTED', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, '0.00', NULL, 'VIETQR', 'OK | Đã hoàn', 'DA_THANH_TOAN', 'Khách muốn trả hàng vì sản phẩm không phù hợp', NULL, NULL, '2026-06-15T17:12:48.310Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (31, 9, 190400000, 'PAID', 'DH31', 'tuan nguyen', 'tuan9bledinhchinh@gmail.com', '0905338411', 'thon tan quang, Phường Ngô Quyền, Thành phố Bắc Giang, Tỉnh Bắc Giang', NULL, 0, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-11T09:11:46.406Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (8, NULL, 21500000, 'DA_HOAN_TIEN', 'DEMO-VIETQR-REFUNDED', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, '0.00', NULL, 'VIETQR', 'Đã hoàn tiền qua MB Bank', 'DA_THANH_TOAN', 'Khách yêu cầu hoàn tiền', NULL, NULL, '2026-06-11T17:12:50.287Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (9, NULL, 15700000, 'THU_HOI', 'DEMO-VIETQR-RECALLED', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, '0.00', NULL, 'VIETQR', 'Thu hồi theo yêu cầu kiểm thử', 'DA_THANH_TOAN', 'Khách yêu cầu trả hàng', NULL, NULL, '2026-06-10T17:12:50.817Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (7, NULL, 19900000, 'THU_HOI', 'DEMO-VIETQR-REFUND-WAITING', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, '0.00', NULL, 'VIETQR', 'Admin đã duyệt yêu cầu hoàn tiền', 'DA_THANH_TOAN', 'Khách yêu cầu hoàn tiền', NULL, NULL, '2026-06-12T17:12:49.740Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (11, NULL, 150000000, 'COMPLETED', 'DEMO-MAR-1', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, '0.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-15T03:00:00.000Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (12, NULL, 220000000, 'COMPLETED', 'DEMO-MAR-2', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, '0.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-25T07:30:00.000Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (13, NULL, 185000000, 'COMPLETED', 'DEMO-APR-1', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, '0.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-10T02:15:00.000Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (14, NULL, 315000000, 'COMPLETED', 'DEMO-APR-2', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, '0.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-20T09:45:00.000Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (15, NULL, 280000000, 'COMPLETED', 'DEMO-MAY-1', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, '0.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-05T04:20:00.000Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (16, NULL, 195000000, 'COMPLETED', 'DEMO-MAY-2', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, '0.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-18T06:10:00.000Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (38, 25, 10000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH38', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Nam Ka, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14T12:05:37.372Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (39, 25, 10000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH39', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea Ning, Huyện Cư Kuin, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14T12:10:23.876Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (40, 25, 10000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH40', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea Ning, Huyện Cư Kuin, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14T12:53:25.074Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (41, 25, 10000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH41', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea R''Bin, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14T13:34:44.343Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (32, 43, 600000, 'COMPLETED', 'DH32', 'Nguyễn Trường Quân', 'truongquan577@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, 0, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-13T15:22:01.340Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (33, 29, 825000000, 'COMPLETED', 'DH33', 'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', '7/134/29/9 đường liên khu 5-6, Phường Hàng Trống, Quận Hoàn Kiếm, Thành phố Hà Nội', NULL, 0, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-14T06:43:34.142Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (34, 9, 2375000, 'PENDING', 'DH34', 'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', 'tp, Xã Yên Sơn, Huyện Yên Châu, Tỉnh Sơn La', NULL, 0, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-14T09:50:43.950Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (35, 25, 600000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH35', 'Quân Nguyễn Trường', 'nguyentruongq169@gmail.com', '0867868825', 'q, Xã Tiền Tiến, Thành phố Hải Dương, Tỉnh Hải Dương', NULL, 0, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14T10:30:01.596Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (36, 25, 8500000, 'PENDING', 'DH36', 'Quân Nguyễn Trường', 'nguyentruongq169@gmail.com', '0867868825', 'q, Xã Tiền Tiến, Thành phố Hải Dương, Tỉnh Hải Dương', NULL, 0, NULL, NULL, '0.00', NULL, 'EWALLET', NULL, NULL, NULL, NULL, NULL, '2026-07-14T10:30:49.368Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (37, 25, 8500000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH37', 'Quân Nguyễn Trường', 'nguyentruongq169@gmail.com', '0867868825', 'q, Xã Tiền Tiến, Thành phố Hải Dương, Tỉnh Hải Dương', NULL, 0, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14T10:32:25.370Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (42, 25, 10000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH42', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Nam Ka, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14T14:46:26.074Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (43, 25, 10000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH43', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Nam Ka, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14T15:07:27.131Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (44, 25, 10000, 'DA_THANH_TOAN', 'DH44', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea BHốk, Huyện Cư Kuin, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14T15:10:45.309Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (45, 25, 10000, 'DA_THANH_TOAN', 'DH45', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Cư Klông, Huyện Krông Năng, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14T15:15:01.122Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (46, NULL, 16500000, 'PENDING', 'DH46', 'Phạm Công Thanh', NULL, '0902208461', '7/134/29/9 đường liên khu 5-6, Phường Hợp Giang, Thành phố Cao Bằng, Tỉnh Cao Bằng', NULL, 0, NULL, NULL, '0.00', NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-15T06:09:04.701Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (47, 29, 1620000, 'PENDING', 'DH47', 'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', '7/134/29/9 đường liên khu 5-6, Phường Phúc Xá, Quận Ba Đình, Thành phố Hà Nội', NULL, 0, NULL, NULL, '0.00', NULL, 'INSTALLMENT', NULL, NULL, NULL, NULL, NULL, '2026-07-15T10:26:21.271Z');
INSERT INTO public."orders" ("id", "user_id", "total_price", "status", "order_code", "full_name", "email", "phone", "address", "city", "discount_amount", "voucher_code", "installment_bank", "installment_fee", "installment_term", "payment_method", "admin_note", "refund_previous_status", "refund_reason", "stock_deducted", "stock_restored", "created_at") VALUES (48, 25, 10000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH48', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Nam Ka, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, '0.00', NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-16T15:29:05.493Z');

-- Data for Name: flyway_schema_history;
INSERT INTO public."flyway_schema_history" ("installed_rank", "version", "description", "type", "script", "checksum", "installed_by", "installed_on", "execution_time", "success") VALUES (1, '0', '<< Flyway Baseline >>', 'BASELINE', '<< Flyway Baseline >>', NULL, 'postgres', '2026-07-15T23:53:57.288Z', 0, true);
INSERT INTO public."flyway_schema_history" ("installed_rank", "version", "description", "type", "script", "checksum", "installed_by", "installed_on", "execution_time", "success") VALUES (2, '1', 'remove obsolete news published', 'SQL', 'V1__remove_obsolete_news_published.sql', -1979696205, 'postgres', '2026-07-15T23:53:59.541Z', 880, true);

