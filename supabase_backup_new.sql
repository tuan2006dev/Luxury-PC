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
