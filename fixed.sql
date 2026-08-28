-- ======================================================
-- PostgreSQL Table Structures & Initial Data for LuxuryPC
-- Compatible with Render Cloud PostgreSQL & Local PostgreSQL
-- ======================================================

-- ======================================================
-- SQL Server Table Structures (CREATE TABLE)
-- Ordered Topologically
-- Date: 2026-07-19
-- ======================================================

-- --------------------------------------------------
-- DROP ALL EXISTING FOREIGN KEYS DYNAMICALLY
-- --------------------------------------------------

-- ----------------------------
-- Table structure for flyway_schema_history
-- ----------------------------
DROP TABLE IF EXISTS flyway_schema_history CASCADE;
CREATE TABLE flyway_schema_history (
  installed_rank INT NOT NULL,
  version VARCHAR(50),
  description VARCHAR(200)  NOT NULL,
  type VARCHAR(20)  NOT NULL,
  script VARCHAR(1000)  NOT NULL,
  checksum INT,
  installed_by VARCHAR(100)  NOT NULL,
  installed_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  execution_time INT NOT NULL,
  success BOOLEAN NOT NULL
);

-- ----------------------------
-- Table structure for sepay_transactions
-- ----------------------------
DROP TABLE IF EXISTS sepay_transactions CASCADE;
CREATE TABLE sepay_transactions (
  id SERIAL PRIMARY KEY,
  account_number VARCHAR(100),
  order_code VARCHAR(100),
  payment_code VARCHAR(100),
  processed_at TIMESTAMP,
  processing_status VARCHAR(100),
  raw_payload TEXT,
  received_at TIMESTAMP,
  sepay_transaction_id BIGINT,
  transfer_amount DECIMAL(18,2),
  transfer_type VARCHAR(100)
);

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS roles CASCADE;
CREATE TABLE roles (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)  NOT NULL
);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(255),
  email VARCHAR(255)  NOT NULL UNIQUE,
  password VARCHAR(255) NULL,
  full_name VARCHAR(255),
  phone VARCHAR(255),
  address TEXT,
  enabled BOOLEAN DEFAULT TRUE,
  auth_provider VARCHAR(255),
  google_id VARCHAR(255),
  facebook_id VARCHAR(255),
  avatar VARCHAR(255),
  birthday TIMESTAMP,
  gender BOOLEAN,
  status BOOLEAN,
  notify_flash_sale BOOLEAN,
  notify_new_products BOOLEAN,
  notify_order_updates BOOLEAN,
  notify_weekly_newsletter BOOLEAN,
  two_factor_enabled BOOLEAN,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS categories CASCADE;
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100)  NOT NULL,
  display TEXT,
  slug VARCHAR(255)
);

-- ----------------------------
-- Table structure for news_categories
-- ----------------------------
DROP TABLE IF EXISTS news_categories CASCADE;
CREATE TABLE news_categories (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP,
  description TEXT,
  name VARCHAR(100)  NOT NULL,
  slug VARCHAR(100)  NOT NULL,
  status VARCHAR(20)  NOT NULL,
  updated_at TIMESTAMP
);

-- ----------------------------
-- Table structure for flash_sales
-- ----------------------------
DROP TABLE IF EXISTS flash_sales CASCADE;
CREATE TABLE flash_sales (
  id SERIAL PRIMARY KEY,
  active BOOLEAN,
  created_at TIMESTAMP,
  end_time TIMESTAMP,
  name VARCHAR(255),
  start_time TIMESTAMP
);

ALTER TABLE flash_sales ADD COLUMN IF NOT EXISTS description VARCHAR(500), ADD COLUMN IF NOT EXISTS max_per_user INT;

-- ----------------------------
-- Table structure for pc_combos
-- ----------------------------
DROP TABLE IF EXISTS pc_combos CASCADE;
CREATE TABLE pc_combos (
  id BIGSERIAL PRIMARY KEY,
  badge VARCHAR(255),
  badge_color VARCHAR(255),
  description VARCHAR(255),
  image VARCHAR(255),
  name VARCHAR(255),
  price DECIMAL(18,2)
);

-- ----------------------------
-- Table structure for spring_session
-- ----------------------------
DROP TABLE IF EXISTS spring_session CASCADE;
CREATE TABLE spring_session (
  primary_id char(36) NOT NULL PRIMARY KEY,
  session_id char(36) NOT NULL,
  creation_time BIGINT NOT NULL,
  last_access_time BIGINT NOT NULL,
  max_inactive_interval INT NOT NULL,
  expiry_time BIGINT NOT NULL,
  principal_name VARCHAR(100)
);

-- ----------------------------
-- Table structure for game_engine_traits
-- ----------------------------
DROP TABLE IF EXISTS game_engine_traits CASCADE;
CREATE TABLE game_engine_traits (
  game_name VARCHAR(255) NOT NULL PRIMARY KEY,
  cpu_dependency_weight DOUBLE PRECISION
);

-- ----------------------------
-- Table structure for fps_baselines
-- ----------------------------
DROP TABLE IF EXISTS fps_baselines CASCADE;
CREATE TABLE fps_baselines (
  id SERIAL PRIMARY KEY,
  estimated_fps INT,
  preset VARCHAR(255),
  resolution VARCHAR(255)
);

-- ----------------------------
-- Table structure for component_benchmarks
-- ----------------------------
DROP TABLE IF EXISTS component_benchmarks CASCADE;
CREATE TABLE component_benchmarks (
  product_id INT NOT NULL,
  cpu_multi_core_score INT,
  gpu_rasterization_score INT
);

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
DROP TABLE IF EXISTS user_roles CASCADE;
CREATE TABLE user_roles (
  user_id INT NOT NULL,
  role_id INT NOT NULL,
  id SERIAL PRIMARY KEY
);

-- ----------------------------
-- Table structure for user_sessions
-- ----------------------------
DROP TABLE IF EXISTS user_sessions CASCADE;
CREATE TABLE user_sessions (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  session_id VARCHAR(255)  NOT NULL,
  user_agent VARCHAR(500),
  device_info VARCHAR(255),
  ip_address VARCHAR(50),
  location VARCHAR(100),
  login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_expired BOOLEAN DEFAULT FALSE
);

-- ----------------------------
-- Table structure for shipping_addresses
-- ----------------------------
DROP TABLE IF EXISTS shipping_addresses CASCADE;
CREATE TABLE shipping_addresses (
  id SERIAL PRIMARY KEY,
  address VARCHAR(500)  NOT NULL,
  city VARCHAR(120),
  is_default BOOLEAN NOT NULL,
  district VARCHAR(120),
  phone VARCHAR(255)  NOT NULL,
  recipient_name VARCHAR(255)  NOT NULL,
  user_id INT NOT NULL
);

-- ----------------------------
-- Table structure for user_addresses
-- ----------------------------
DROP TABLE IF EXISTS user_addresses CASCADE;
CREATE TABLE user_addresses (
  id SERIAL PRIMARY KEY,
  address VARCHAR(500)  NOT NULL,
  city VARCHAR(150),
  created_at TIMESTAMP,
  district VARCHAR(150),
  is_default BOOLEAN,
  phone VARCHAR(255)  NOT NULL,
  recipient_name VARCHAR(255)  NOT NULL,
  updated_at TIMESTAMP,
  user_id INT NOT NULL,
  address_line VARCHAR(1000),
  receiver_name VARCHAR(255)
);

-- ----------------------------
-- Table structure for user_notification_settings
-- ----------------------------
DROP TABLE IF EXISTS user_notification_settings CASCADE;
CREATE TABLE user_notification_settings (
  id SERIAL PRIMARY KEY,
  flash_sale BOOLEAN,
  member_points BOOLEAN,
  new_products BOOLEAN,
  order_updates BOOLEAN,
  updated_at TIMESTAMP,
  weekly_newsletter BOOLEAN,
  user_id INT NOT NULL
);

-- ----------------------------
-- Table structure for carts
-- ----------------------------
DROP TABLE IF EXISTS carts CASCADE;
CREATE TABLE carts (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------
-- Table structure for pc_builds
-- ----------------------------
DROP TABLE IF EXISTS pc_builds CASCADE;
CREATE TABLE pc_builds (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  total_price numeric(15,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------
-- Table structure for support_tickets
-- ----------------------------
DROP TABLE IF EXISTS support_tickets CASCADE;
CREATE TABLE support_tickets (
  id SERIAL PRIMARY KEY,
  admin_reply TEXT,
  assigned_admin VARCHAR(255),
  build_config TEXT,
  category VARCHAR(255),
  created_at TIMESTAMP,
  customer_email VARCHAR(255),
  customer_name VARCHAR(255),
  customer_phone VARCHAR(255),
  message TEXT,
  status VARCHAR(255),
  subject VARCHAR(1000),
  updated_at TIMESTAMP,
  user_id INT
);

-- ----------------------------
-- Table structure for tickets
-- ----------------------------
DROP TABLE IF EXISTS tickets CASCADE;
CREATE TABLE tickets (
  id SERIAL PRIMARY KEY,
  assigned_admin VARCHAR(255),
  build_config TEXT,
  category VARCHAR(255),
  created_at TIMESTAMP,
  customer_email VARCHAR(255),
  customer_name VARCHAR(255)  NOT NULL,
  customer_phone VARCHAR(255),
  message TEXT,
  status VARCHAR(255),
  subject VARCHAR(255)  NOT NULL
);

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(200)  NOT NULL,
  price DECIMAL(18,2) NOT NULL,
  description TEXT,
  image VARCHAR(255),
  category_id INT,
  stock INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  brand VARCHAR(100)
);

-- ----------------------------
-- Table structure for vouchers
-- ----------------------------
DROP TABLE IF EXISTS vouchers CASCADE;
CREATE TABLE vouchers (
  id SERIAL PRIMARY KEY,
  active BOOLEAN,
  code VARCHAR(255)  NOT NULL,
  created_at TIMESTAMP,
  description VARCHAR(255),
  discount_type VARCHAR(255),
  discount_value DECIMAL(18,2),
  end_date TIMESTAMP,
  max_discount_amount DECIMAL(18,2),
  min_order_amount DECIMAL(18,2),
  start_date TIMESTAMP,
  usage_limit INT,
  used_count INT,
  category_id INT
);

-- ----------------------------
-- Table structure for news
-- ----------------------------
DROP TABLE IF EXISTS news CASCADE;
CREATE TABLE news (
  id SERIAL PRIMARY KEY,
  content TEXT,
  created_at TIMESTAMP,
  slug VARCHAR(255)  NOT NULL,
  summary TEXT,
  thumbnail VARCHAR(255),
  title VARCHAR(255)  NOT NULL,
  updated_at TIMESTAMP,
  author_id INT NOT NULL,
  meta_description TEXT,
  meta_keywords VARCHAR(255),
  meta_title VARCHAR(255),
  view_count BIGINT DEFAULT 0,
  category_id INT,
  status VARCHAR(20)
);

-- ----------------------------
-- Table structure for spring_session_attributes
-- ----------------------------
DROP TABLE IF EXISTS spring_session_attributes CASCADE;
CREATE TABLE spring_session_attributes (
  session_primary_id char(36) NOT NULL,
  attribute_name VARCHAR(200) NOT NULL,
  attribute_bytes VARBINARY(MAX) NOT NULL,
  PRIMARY KEY (session_primary_id, attribute_name)
);

-- ----------------------------
-- Table structure for shared_builds
-- ----------------------------
DROP TABLE IF EXISTS shared_builds CASCADE;
CREATE TABLE shared_builds (
  share_code VARCHAR(15) NOT NULL PRIMARY KEY,
  build_id INT NOT NULL,
  name VARCHAR(100)  DEFAULT 'Cấu hình chia sẻ từ LuxuryPC',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  case_id VARCHAR(50),
  cooler_id VARCHAR(50),
  cpu_id VARCHAR(50),
  gpu_id VARCHAR(50),
  mainboard_id VARCHAR(50),
  psu_id VARCHAR(50),
  ram_id VARCHAR(50),
  total_price numeric(38,2),
  storage_id VARCHAR(50)
);

-- Xóa cột build_id (nếu nó đang là khóa chính thì phải DROP CONSTRAINT trước)
-- Giả sử hệ thống tự sinh tên Constraint khóa chính cũ là PK__shared_b__...
-- (Đoạn này Hibernate đã tự động đối chiếu và DROP cột dư thừa)
ALTER TABLE shared_builds DROP COLUMN IF EXISTS build_id;

-- Đặt lại Khóa chính (Primary Key) cho cột share_code
ALTER TABLE shared_builds 
ADD CONSTRAINT PK_shared_builds PRIMARY KEY (share_code);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT,
  total_price DECIMAL(18,2),
  status VARCHAR(50),
  order_code VARCHAR(255),
  full_name VARCHAR(255),
  email VARCHAR(255),
  phone VARCHAR(255),
  address TEXT,
  city VARCHAR(255),
  discount_amount DECIMAL(18,2) DEFAULT 0,
  voucher_code VARCHAR(255),
  installment_bank VARCHAR(255),
  installment_fee numeric(15,2) DEFAULT 0,
  installment_term INT,
  payment_method VARCHAR(255),
  admin_note TEXT,
  refund_previous_status VARCHAR(255),
  refund_reason TEXT,
  stock_deducted BOOLEAN,
  stock_restored BOOLEAN,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------
-- Table structure for order_items
-- ----------------------------
DROP TABLE IF EXISTS order_items CASCADE;
CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  price DECIMAL(18,2),
  quantity INT
);

-- ----------------------------
-- Table structure for cart_items
-- ----------------------------
DROP TABLE IF EXISTS cart_items CASCADE;
CREATE TABLE cart_items (
  id SERIAL PRIMARY KEY,
  cart_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT DEFAULT 1
);

-- ----------------------------
-- Table structure for reviews
-- ----------------------------
DROP TABLE IF EXISTS reviews CASCADE;
CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  content VARCHAR(255),
  created_at TIMESTAMP,
  stars INT,
  user_id INT,
  product_id INT,
  order_id INT,
  title VARCHAR(255),
  image VARCHAR(255),
  video VARCHAR(255)
);

-- ----------------------------
-- Table structure for wishlist_items
-- ----------------------------
DROP TABLE IF EXISTS wishlist_items CASCADE;
CREATE TABLE wishlist_items (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP NOT NULL,
  product_id INT NOT NULL,
  user_id INT NOT NULL
);

-- ----------------------------
-- Table structure for inventory
-- ----------------------------
DROP TABLE IF EXISTS inventory CASCADE;
CREATE TABLE inventory (
  id SERIAL PRIMARY KEY,
  product_id INT,
  quantity INT DEFAULT 0,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------
-- Table structure for stock_movements
-- ----------------------------
DROP TABLE IF EXISTS stock_movements CASCADE;
CREATE TABLE stock_movements (
  id SERIAL PRIMARY KEY,
  product_id INT,
  change_quantity INT,
  movement_type VARCHAR(255),
  note TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------
-- Table structure for flash_sale_items
-- ----------------------------
DROP TABLE IF EXISTS flash_sale_items CASCADE;
CREATE TABLE flash_sale_items (
  id SERIAL PRIMARY KEY,
  sale_price DECIMAL(18,2),
  sale_quantity INT,
  sold_count INT,
  flash_sale_id INT,
  product_id INT
);

-- ----------------------------
-- Table structure for brands
-- ----------------------------
DROP TABLE IF EXISTS brands CASCADE;
CREATE TABLE brands (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  logo VARCHAR(500) NOT NULL,
  link VARCHAR(500),
  display_order INT DEFAULT 0
);

-- ----------------------------
-- Table structure for pc_combo_details
-- ----------------------------
DROP TABLE IF EXISTS pc_combo_details CASCADE;
CREATE TABLE pc_combo_details (
  id BIGSERIAL PRIMARY KEY,
  slot_type VARCHAR(255),
  combo_id BIGINT,
  product_id INT
);

-- ----------------------------
-- Table structure for pc_build_items
-- ----------------------------
DROP TABLE IF EXISTS pc_build_items CASCADE;
CREATE TABLE pc_build_items (
  id SERIAL PRIMARY KEY,
  build_id INT NOT NULL,
  product_id INT NOT NULL
);

-- ----------------------------
-- Table structure for ticket_messages
-- ----------------------------
DROP TABLE IF EXISTS ticket_messages CASCADE;
CREATE TABLE ticket_messages (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP,
  message TEXT  NOT NULL,
  sender VARCHAR(255)  NOT NULL,
  sender_name VARCHAR(255),
  ticket_id INT NOT NULL
);

-- ----------------------------
-- Table structure for user_vouchers
-- ----------------------------
DROP TABLE IF EXISTS user_vouchers CASCADE;
CREATE TABLE user_vouchers (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  voucher_id INT NOT NULL,
  saved_at TIMESTAMP,
  used_at TIMESTAMP,
  reservation_expires_at TIMESTAMP,
  status VARCHAR(255) NOT NULL
);

-- ----------------------------
-- Table structure for chat_messages
-- ----------------------------
DROP TABLE IF EXISTS chat_messages CASCADE;
CREATE TABLE chat_messages (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP,
  message TEXT,
  sender VARCHAR(255),
  sender_name VARCHAR(255),
  ticket_id INT
);

-- ----------------------------
-- Table structure for password_resets
-- ----------------------------
DROP TABLE IF EXISTS password_resets CASCADE;
CREATE TABLE password_resets (
  id BIGSERIAL PRIMARY KEY,
  email VARCHAR(100),
  token VARCHAR(255),
  expiry TIMESTAMP
);

-- ----------------------------
-- Table structure for case_specs
-- ----------------------------
DROP TABLE IF EXISTS case_specs CASCADE;
CREATE TABLE case_specs (
  product_id INT NOT NULL PRIMARY KEY,
  max_cpu_cooler_height_mm INT,
  max_gpu_length_mm INT,
  motherboard_support VARCHAR(255)
);

-- ----------------------------
-- Table structure for casespec_specs
-- ----------------------------
DROP TABLE IF EXISTS casespec_specs CASCADE;
CREATE TABLE casespec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  max_cpu_cooler_height_mm INT,
  max_gpu_length_mm INT,
  motherboard_support VARCHAR(255)
);

-- ----------------------------
-- Table structure for cpu_specs
-- ----------------------------
DROP TABLE IF EXISTS cpu_specs CASCADE;
CREATE TABLE cpu_specs (
  product_id INT NOT NULL PRIMARY KEY,
  has_igpu BOOLEAN,
  includes_stock_cooler BOOLEAN,
  ram_type_supported VARCHAR(255),
  socket VARCHAR(255),
  tdp_max INT
);

-- ----------------------------
-- Table structure for cpuspec_specs
-- ----------------------------
DROP TABLE IF EXISTS cpuspec_specs CASCADE;
CREATE TABLE cpuspec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  has_igpu BOOLEAN,
  includes_stock_cooler BOOLEAN,
  ram_type_supported VARCHAR(255),
  socket VARCHAR(255),
  tdp_max INT
);

-- ----------------------------
-- Table structure for cooler_specs
-- ----------------------------
DROP TABLE IF EXISTS cooler_specs CASCADE;
CREATE TABLE cooler_specs (
  product_id INT NOT NULL PRIMARY KEY,
  cooler_type VARCHAR(255),
  height_mm INT,
  tdp_rating_watt INT
);

-- ----------------------------
-- Table structure for coolerspec_specs
-- ----------------------------
DROP TABLE IF EXISTS coolerspec_specs CASCADE;
CREATE TABLE coolerspec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  cooler_type VARCHAR(255),
  height_mm INT,
  tdp_rating_watt INT
);

-- ----------------------------
-- Table structure for gpu_specs
-- ----------------------------
DROP TABLE IF EXISTS gpu_specs CASCADE;
CREATE TABLE gpu_specs (
  product_id INT NOT NULL PRIMARY KEY,
  length_mm INT,
  pcie12vhpwr_required INT,
  pcie8pin_required INT,
  power_consumption_tdp INT,
  thickness_mm INT
);

-- ----------------------------
-- Table structure for gpuspec_specs
-- ----------------------------
DROP TABLE IF EXISTS gpuspec_specs CASCADE;
CREATE TABLE gpuspec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  length_mm INT,
  pcie12vhpwr_required INT,
  pcie8pin_required INT,
  power_consumption_tdp INT,
  thickness_mm INT
);

-- ----------------------------
-- Table structure for mainboard_specs
-- ----------------------------
DROP TABLE IF EXISTS mainboard_specs CASCADE;
CREATE TABLE mainboard_specs (
  product_id INT NOT NULL PRIMARY KEY,
  cpu_power_connectors INT,
  form_factor VARCHAR(255),
  ram_slots INT,
  ram_type VARCHAR(255),
  socket VARCHAR(255)
);

-- ----------------------------
-- Table structure for mainboardspec_specs
-- ----------------------------
DROP TABLE IF EXISTS mainboardspec_specs CASCADE;
CREATE TABLE mainboardspec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  cpu_power_connectors INT,
  form_factor VARCHAR(255),
  ram_slots INT,
  ram_type VARCHAR(255),
  socket VARCHAR(255)
);

-- ----------------------------
-- Table structure for psu_specs
-- ----------------------------
DROP TABLE IF EXISTS psu_specs CASCADE;
CREATE TABLE psu_specs (
  product_id INT NOT NULL PRIMARY KEY,
  cpu8pin_connectors INT,
  length_mm INT,
  pcie8pin_connectors INT,
  wattage INT
);

-- ----------------------------
-- Table structure for psuspec_specs
-- ----------------------------
DROP TABLE IF EXISTS psuspec_specs CASCADE;
CREATE TABLE psuspec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  cpu8pin_connectors INT,
  length_mm INT,
  pcie8pin_connectors INT,
  wattage INT
);

-- ----------------------------
-- Table structure for ram_specs
-- ----------------------------
DROP TABLE IF EXISTS ram_specs CASCADE;
CREATE TABLE ram_specs (
  product_id INT NOT NULL PRIMARY KEY,
  capacity_total INT,
  ddr_type VARCHAR(255),
  module_count INT
);

-- ----------------------------
-- Table structure for ramspec_specs
-- ----------------------------
DROP TABLE IF EXISTS ramspec_specs CASCADE;
CREATE TABLE ramspec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  capacity_total INT,
  ddr_type VARCHAR(255),
  module_count INT
);

-- ----------------------------
-- Table structure for storage_specs
-- ----------------------------
DROP TABLE IF EXISTS storage_specs CASCADE;
CREATE TABLE storage_specs (
  product_id INT NOT NULL PRIMARY KEY,
  form_factor VARCHAR(255),
  interface_type VARCHAR(255)
);

-- ----------------------------
-- Table structure for storagespec_specs
-- ----------------------------
DROP TABLE IF EXISTS storagespec_specs CASCADE;
CREATE TABLE storagespec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  form_factor VARCHAR(255),
  interface_type VARCHAR(255)
);

-- ----------------------------
-- RELATIONSHIPS & FOREIGN KEYS
-- ----------------------------

ALTER TABLE flash_sale_items ADD CONSTRAINT FK_flash_sale_items_flash_sales FOREIGN KEY (flash_sale_id) REFERENCES flash_sales (id);

ALTER TABLE flash_sale_items ADD CONSTRAINT FK_flash_sale_items_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE inventory ADD CONSTRAINT FK_inventory_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE news ADD CONSTRAINT FK_news_users FOREIGN KEY (author_id) REFERENCES users (id);

ALTER TABLE news ADD CONSTRAINT FK_news_news_categories FOREIGN KEY (category_id) REFERENCES news_categories (id);

ALTER TABLE order_items ADD CONSTRAINT FK_order_items_orders FOREIGN KEY (order_id) REFERENCES orders (id);

ALTER TABLE order_items ADD CONSTRAINT FK_order_items_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE orders ADD CONSTRAINT FK_orders_users FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE pc_combo_details ADD CONSTRAINT FK_pc_combo_details_pc_combos FOREIGN KEY (combo_id) REFERENCES pc_combos (id);

ALTER TABLE pc_combo_details ADD CONSTRAINT FK_pc_combo_details_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE products ADD CONSTRAINT FK_products_categories FOREIGN KEY (category_id) REFERENCES categories (id);

ALTER TABLE reviews ADD CONSTRAINT FK_reviews_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE reviews ADD CONSTRAINT FK_reviews_users FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE shipping_addresses ADD CONSTRAINT FK_shipping_addresses_users FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE stock_movements ADD CONSTRAINT FK_stock_movements_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE support_tickets ADD CONSTRAINT FK_support_tickets_users FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE ticket_messages ADD CONSTRAINT FK_ticket_messages_tickets FOREIGN KEY (ticket_id) REFERENCES tickets (id);

ALTER TABLE user_roles ADD CONSTRAINT FK_user_roles_roles FOREIGN KEY (role_id) REFERENCES roles (id);

ALTER TABLE user_roles ADD CONSTRAINT FK_user_roles_users FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE user_sessions ADD CONSTRAINT FK_user_sessions_users FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE user_vouchers ADD CONSTRAINT FK_user_vouchers_users FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE user_vouchers ADD CONSTRAINT FK_user_vouchers_vouchers FOREIGN KEY (voucher_id) REFERENCES vouchers (id);

ALTER TABLE vouchers ADD CONSTRAINT FK_vouchers_categories FOREIGN KEY (category_id) REFERENCES categories (id);

ALTER TABLE wishlist_items ADD CONSTRAINT FK_wishlist_items_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE wishlist_items ADD CONSTRAINT FK_wishlist_items_users FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE case_specs ADD CONSTRAINT FK_case_specs_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE casespec_specs ADD CONSTRAINT FK_casespec_specs_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE cpu_specs ADD CONSTRAINT FK_cpu_specs_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE cpuspec_specs ADD CONSTRAINT FK_cpuspec_specs_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE cooler_specs ADD CONSTRAINT FK_cooler_specs_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE coolerspec_specs ADD CONSTRAINT FK_coolerspec_specs_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE gpu_specs ADD CONSTRAINT FK_gpu_specs_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE gpuspec_specs ADD CONSTRAINT FK_gpuspec_specs_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE mainboard_specs ADD CONSTRAINT FK_mainboard_specs_products FOREIGN KEY (product_id) REFERENCES products (id);

ALTER TABLE mainboardspec_specs ADD CONSTRAINT FK_mainboardspec_specs_products FOREIGN KEY (product_id) REFERENCES products (id);

-- Dumping data for table roles
INSERT INTO roles (id, name) VALUES (1, 'ADMI');
INSERT INTO roles (id, name) VALUES (2, 'USER');
INSERT INTO roles (id, name) VALUES (3, 'STAFF');

-- Dumping data for table users
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (1, 'phamcongthanh.8311@gmail.com', 'phamcongthanh.8311@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phạm Thanh', '0902208461', NULL, 1, 'GOOGLE', '112307932430374029161', NULL, '/uploads/avatars/user_41_1783933303213.webp', NULL, 1, 1, 1, 1, 1, 1, 0, '2026-07-13 16:00:58.778');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (2, 'leecookcu@gmail.com', 'leecookcu@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', 'Bá Bá', '0936629311', NULL, 1, 'LOCAL', NULL, NULL, '/uploads/avatars/user_2_1785405662243.webp', '2006-12-12 00:00:00.000', 1, 1, 1, 1, 0, 1, 0, '2026-06-12 18:47:49.406');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (3, 'nguyentruongq169@gmail.com', 'nguyentruongq169@gmail.com', '$2a$10$6jnKeBpO81iMJuB6m2g0zesK.ohW0RzD1rYCdqAdzkcOQycji6VR6', 'LuxuryPC Admin', NULL, NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 1, 0, '2026-07-30 18:52:10.378');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (4, 'luxury.pc.noreply', 'luxury.pc.noreply@gmail.com', '$2a$10$t/AZM6s9xgGC91gFze0Ahuk/0YWzPHgerZLjCZgJ23XftEAHnYECG', 'PC Luxury', '0859590337', NULL, 1, 'GOOGLE', '107274161111586387548', NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, 0, '2026-08-07 15:17:07.539');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (5, 'tranthivy@gmail.com', 'tranthivy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Trần Thị Vy', '0983746152', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.100');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (6, 'leminhtuan@gmail.com', 'leminhtuan@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Lê Minh Tuấn', '0976152437', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.106');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (7, 'phamanhhung@gmail.com', 'phamanhhung@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phạm Anh Hùng', '0909283746', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.106');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (8, 'hoangducduy@gmail.com', 'hoangducduy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Hoàng Đức Duy', '0938475610', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.106');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (9, 'phanhuuson@gmail.com', 'phanhuuson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phan Hữu Sơn', '0965748392', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.106');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (10, 'vuquanghai@gmail.com', 'vuquanghai@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Vũ Quang Hải', '0947382910', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.106');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (11, 'vongoclinh@gmail.com', 'vongoclinh@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Võ Ngọc Linh', '0918273645', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.110');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (12, 'dangthanhson@gmail.com', 'dangthanhson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Đặng Thanh Sơn', '0928374615', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.110');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (13, 'buikhanhtrang@gmail.com', 'buikhanhtrang@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Bùi Khánh Trang', '0981726354', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.110');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (14, 'nguyenvanhuong@gmail.com', 'nguyenvanhuong@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Nguyễn Văn Hương', '0972345678', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.110');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (15, 'tranthinam@gmail.com', 'tranthinam@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Trần Thị Nam', '0903456789', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.110');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (16, 'leminhvy@gmail.com', 'leminhvy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Lê Minh Vy', '0934567890', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.110');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (17, 'phamanhtuan@gmail.com', 'phamanhtuan@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phạm Anh Tuấn', '0945678901', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.110');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (18, 'hoangduchung@gmail.com', 'hoangduchung@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Hoàng Đức Hùng', '0956789012', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.110');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (19, 'phanhuuduy@gmail.com', 'phanhuuduy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phan Hữu Duy', '0967890123', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.113');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (20, 'vuquanglinh@gmail.com', 'vuquanglinh@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Vũ Quang Linh', '0978901234', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.113');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (21, 'vongocson@gmail.com', 'vongocson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Võ Ngọc Sơn', '0989012345', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.113');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (22, 'dangthanhhai@gmail.com', 'dangthanhhai@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Đặng Thanh Hải', '0990123456', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.113');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (23, 'buikhanhlinh@gmail.com', 'buikhanhlinh@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Bùi Khánh Linh', '0901234567', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.113');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (24, 'nguyenthitrang@gmail.com', 'nguyenthitrang@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Nguyễn Thị Trang', '0912345001', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.113');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (25, 'tranminhnam@gmail.com', 'tranminhnam@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Trần Minh Nam', '0923456002', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.113');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (26, 'leanhvy@gmail.com', 'leanhvy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Lê Anh Vy', '0934567003', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.113');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (27, 'phamductuan@gmail.com', 'phamductuan@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phạm Đức Tuấn', '0945678004', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.116');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (28, 'hoanghuuhung@gmail.com', 'hoanghuuhung@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Hoàng Hữu Hùng', '0956789005', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.116');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (29, 'phanquangduy@gmail.com', 'phanquangduy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phan Quang Duy', '0967890006', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.116');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (30, 'vungoclinh2@gmail.com', 'vungoclinh2@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Vũ Ngọc Linh', '0978901007', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.116');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (31, 'vothanhson@gmail.com', 'vothanhson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Võ Thanh Sơn', '0989012008', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.116');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (32, 'dangkhanhhai@gmail.com', 'dangkhanhhai@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Đặng Khánh Hải', '0990123009', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.116');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (33, 'buivantrang@gmail.com', 'buivantrang@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Bùi Văn Trang', '0901234010', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.120');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (34, 'nguyenanhhuong@gmail.com', 'nguyenanhhuong@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Nguyễn Anh Hương', '0912345011', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.120');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (35, 'tranducvy@gmail.com', 'tranducvy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Trần Đức Vy', '0923456012', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.123');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (36, 'lehuutuan@gmail.com', 'lehuutuan@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Lê Hữu Tuấn', '0934567013', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.126');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (37, 'phamquanghung@gmail.com', 'phamquanghung@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phạm Quang Hùng', '0945678014', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.126');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (38, 'hoangngocduy@gmail.com', 'hoangngocduy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Hoàng Ngọc Duy', '0956789015', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.126');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (39, 'phanthanhson@gmail.com', 'phanthanhson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phan Thanh Sơn', '0967890016', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.126');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (40, 'vukhanhhai@gmail.com', 'vukhanhhai@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Vũ Khánh Hải', '0978901017', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.126');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (41, 'vovanlinh@gmail.com', 'vovanlinh@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Võ Văn Linh', '0989012018', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.126');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (42, 'dangthinam@gmail.com', 'dangthinam@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Đặng Thị Nam', '0990123019', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.126');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (43, 'buiminhvy@gmail.com', 'buiminhvy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Bùi Minh Vy', '0901234020', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.126');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (44, 'nguyenanhtuan@gmail.com', 'nguyenanhtuan@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Nguyễn Anh Tuấn', '0912345021', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.126');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (45, 'tranduchung@gmail.com', 'tranduchung@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Trần Đức Hùng', '0923456022', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.126');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (46, 'lehuuduy@gmail.com', 'lehuuduy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Lê Hữu Duy', '0934567023', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (47, 'phamquangson2@gmail.com', 'phamquangson2@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phạm Quang Sơn', '0945678024', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (48, 'hoangngochai@gmail.com', 'hoangngochai@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Hoàng Ngọc Hải', '0956789025', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (49, 'phanthanhlinh@gmail.com', 'phanthanhlinh@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phan Thanh Linh', '0967890026', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (50, 'vukhanhson@gmail.com', 'vukhanhson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Vũ Khánh Sơn', '0978901027', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (51, 'vovanhai@gmail.com', 'vovanhai@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Võ Văn Hải', '0989012028', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (52, 'dangthilinh@gmail.com', 'dangthilinh@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Đặng Thị Linh', '0990123028', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (53, 'buiminhson@gmail.com', 'buiminhson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Bùi Minh Sơn', '0901234028', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (54, 'nguyenhuunam@gmail.com', 'nguyenhuunam@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Nguyễn Hữu Nam', '0912345051', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (55, 'tranquangvy@gmail.com', 'tranquangvy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Trần Quang Vy', '0923456052', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (56, 'lengoctuan@gmail.com', 'lengoctuan@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Lê Ngọc Tuấn', '0934567053', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (57, 'phamthanhhung@gmail.com', 'phamthanhhung@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phạm Thanh Hùng', '0945678054', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (58, 'hoangkhanhduy@gmail.com', 'hoangkhanhduy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Hoàng Khánh Duy', '0956789055', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (59, 'phanvanson@gmail.com', 'phanvanson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phan Văn Sơn', '0967890056', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (60, 'vuthihai@gmail.com', 'vuthihai@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Vũ Thị Hải', '0978901057', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.130');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (61, 'vominhlinh@gmail.com', 'vominhlinh@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Võ Minh Linh', '0989012058', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.133');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (62, 'danganhson@gmail.com', 'danganhson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Đặng Anh Sơn', '0990123058', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.133');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (63, 'buiduchai@gmail.com', 'buiduchai@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Bùi Đức Hải', '0901234058', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.133');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (64, 'nguyenhuuvy@gmail.com', 'nguyenhuuvy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Nguyễn Hữu Vy', '0912345061', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.133');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (65, 'tranngocnam@gmail.com', 'tranngocnam@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Trần Ngọc Nam', '0923456062', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.133');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (66, 'lequangtuan@gmail.com', 'lequangtuan@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Lê Quang Tuấn', '0934567063', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.133');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (67, 'phamminhhung@gmail.com', 'phamminhhung@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phạm Minh Hùng', '0945678064', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.133');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (68, 'hoangthanhduy@gmail.com', 'hoangthanhduy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Hoàng Thanh Duy', '0956789065', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.133');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (69, 'phankhanhson@gmail.com', 'phankhanhson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phan Khánh Sơn', '0967890066', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.133');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (70, 'vuanhhai@gmail.com', 'vuanhhai@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Vũ Anh Hải', '0978901067', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.133');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (71, 'vongoctrang@gmail.com', 'vongoctrang@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Võ Ngọc Trang', '0989012068', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.133');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (72, 'dangduclinh@gmail.com', 'dangduclinh@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Đặng Đức Linh', '0990123068', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.133');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (73, 'buihuuson@gmail.com', 'buihuuson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Bùi Hữu Sơn', '0901234068', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.133');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (74, 'nguyenquangvy@gmail.com', 'nguyenquangvy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Nguyễn Quang Vy', '0912345071', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.133');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (75, 'tranngoctuan@gmail.com', 'tranngoctuan@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Trần Ngọc Tuấn', '0923456072', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.136');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (76, 'lehuuhung@gmail.com', 'lehuuhung@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Lê Hữu Hùng', '0934567073', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.136');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (77, 'phamminhduy@gmail.com', 'phamminhduy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phạm Minh Duy', '0945678074', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.136');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (78, 'hoangthanhhung@gmail.com', 'hoangthanhhung@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Hoàng Thanh Hùng', '0956789075', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.136');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (79, 'phankhanhduy2@gmail.com', 'phankhanhduy2@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phan Khánh Duy', '0967890076', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.136');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (80, 'vuhuuson@gmail.com', 'vuhuuson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Vũ Hữu Sơn', '0978901077', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.136');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (81, 'voanhhai@gmail.com', 'voanhhai@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Võ Anh Hải', '0989012078', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.136');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (82, 'dangquanglinh@gmail.com', 'dangquanglinh@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Đặng Quang Linh', '0990123078', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.136');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (83, 'buingocson@gmail.com', 'buingocson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Bùi Ngọc Sơn', '0901234078', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.136');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (84, 'nguyenngocnam@gmail.com', 'nguyenngocnam@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Nguyễn Ngọc Nam', '0912345081', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.136');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (85, 'tranquangnam@gmail.com', 'tranquangnam@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Trần Quang Nam', '0923456082', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.136');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (86, 'lethanhtuan@gmail.com', 'lethanhtuan@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Lê Thanh Tuấn', '0934567083', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.136');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (87, 'phamhuuhung@gmail.com', 'phamhuuhung@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phạm Hữu Hùng', '0945678084', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.136');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (88, 'hoangvanduy@gmail.com', 'hoangvanduy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Hoàng Văn Duy', '0956789085', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (89, 'phanducson@gmail.com', 'phanducson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phan Đức Sơn', '0967890086', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (90, 'vuthivy@gmail.com', 'vuthivy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Vũ Thị Vy', '0978901087', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (91, 'vohuulinh@gmail.com', 'vohuulinh@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Võ Hữu Linh', '0989012088', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (92, 'dangngochai@gmail.com', 'dangngochai@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Đặng Ngọc Hải', '0990123089', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (93, 'buiquangtrang@gmail.com', 'buiquangtrang@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Bùi Quang Trang', '0901234090', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (94, 'nguyenhuulinh@gmail.com', 'nguyenhuulinh@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Nguyễn Hữu Linh', '0912345091', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (95, 'tranminhson@gmail.com', 'tranminhson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Trần Minh Sơn', '0923456092', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (96, 'lekhanhlinh@gmail.com', 'lekhanhlinh@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Lê Khánh Linh', '0934567093', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (97, 'phamvanhai@gmail.com', 'phamvanhai@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phạm Văn Hải', '0945678094', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (98, 'hoangminhvy@gmail.com', 'hoangminhvy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Hoàng Minh Vy', '0956789095', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (99, 'phanngoctrang@gmail.com', 'phanngoctrang@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Phan Ngọc Trang', '0967890096', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (100, 'vuhuuduy@gmail.com', 'vuhuuduy@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Vũ Hữu Duy', '0978901097', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (101, 'voquanglinh@gmail.com', 'voquanglinh@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Võ Quang Linh', '0989012098', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (102, 'danghuuson@gmail.com', 'danghuuson@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Đặng Hữu Sơn', '0990123099', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (103, 'buingochai@gmail.com', 'buingochai@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', 'Bùi Ngọc Hải', '0901234100', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 0, '2026-08-09 15:03:56.140');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (104, 'balittedutphieukhang@gmail.com', 'balittedutphieukhang@gmail.com', '$2a$10$ceBXGEZmWVqVhpH48b2TZuuMNgdGPxYTq4ydS.7erOj7cpOHhaB2y', 'Nguyễn khang', '+84859590337', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '2026-03-28 15:19:21.008');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (105, 'ditmemaygogle113@gmail.com', 'ditmemaygogle113@gmail.com', '$2a$10$/XRdhZRo3KLXI0FZbAu1e.ycsE.ZyAjy3mQhZE5mJcOz/yQHo/Bbi', 'Thanh Phạm', '0936629311', NULL, 1, 'LOCAL', '102325764378749092956', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0, '2026-06-02 20:52:04.049');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (106, 'admin', 'admin@luxurypc.com', '$2a$10$F76h/W85bFv9Kp040CV4ju4N/jhKpRhXaWgWzewsDa8kDzkHtfXhS', 'Admin LuxuryPC', NULL, NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, 0, '2026-06-08 15:23:54.309');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (107, 'mazack707', 'mazack707@gmail.com', NULL, 'Zack Ma', NULL, NULL, 1, 'GOOGLE', '115229939720924175799', NULL, NULL, NULL, NULL, 1, 1, 0, 1, 1, 0, '2026-06-13 20:27:12.538');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (108, 'tuan9bledinhchinh@gmail.com', 'tuan9bledinhchinh@gmail.com', '$2a$10$3wA6X7TEsnW5ymYdePRokuIN/FLZ.eIRMD4UQBh8PIyh/3z.LLn0q', 'nguyen tuan', '+84905338411', NULL, 1, 'LOCAL', NULL, NULL, NULL, '1995-10-18 00:00:00.000', 1, 1, 1, 0, 1, 1, 0, '2026-03-28 15:59:09.715');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (109, 'djtmefacebook9@gmail.com', 'djtmefacebook9@gmail.com', '$2a$10$KAKrL.51KRhIot0lbCfGzeTyNcE.NAKLH7OFlKm7XULtfxWoqXari', 'Thanh Phạm', '0933456789', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 1, 0, '2026-06-12 21:16:32.031');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (110, 'ngochai2007nt@gmail.com', 'ngochai2007nt@gmail.com', '$2a$10$1soqIA9YDYg0ggZoYV0Cm.OHY81wkRw2GF8dlFtvIRUcU8Pa5Si0u', 'Hải Nguyễn Ngọc', '+84384333382', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, 0, '2026-06-14 19:11:56.269');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (111, 'tuannguyennasani@gmail.com', 'tuannguyennasani@gmail.com', '$2a$10$rcVvRAGy83rllwo8olMgpurZQeAGrgZsObzerd.OrxPWxIk2egiom', 'Thanh Phạm', '0923456789', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 1, 1, 0, '2026-06-12 20:33:46.571');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (112, 'system_user1', 'user1_system@luxurypc.com', NULL, 'Người Dùng Hệ Thống', NULL, NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0, NULL);

-- Dumping data for table categories
INSERT INTO categories (id, name, display, slug) VALUES (1, 'CPU', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (2, 'GPU', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (3, 'RAM', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (4, 'ROM', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (5, 'Mainboard', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (6, 'SSD', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (7, 'Màn hình', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (8, 'Storage', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (9, 'Cooling', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (10, 'VGA', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (11, 'HDD', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (12, 'PSU', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (13, 'Case', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (14, 'CPU Cooler', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (15, 'Case Fan', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (16, 'Keyboard', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (17, 'Mouse', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (18, 'Headset', NULL, NULL);

-- Dumping data for table news_categories
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (1, '2026-07-13 21:32:29.98', 'mô tả nội dung', 'Tin Tức', 'tin-tuc', 'ACTIVE', '2026-07-13 21:32:29.98');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (2, '2026-07-16 11:23:00.477', 'Các bài viết hướng dẫn chọn linh kiện, cách lắp ráp PC từ A-Z.', 'Hướng dẫn Build PC', 'huong-dan-build-pc', 'ACTIVE', '2026-07-16 11:23:00.477');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (3, '2026-07-16 11:23:20.094', 'Các bài viết so sánh (VD: "Intel Core i5-14600K vs AMD Ryzen 7 7700X"), gợi ý cấu hình theo ngân sách.', 'Tư vấn chọn mua', 'tu-van-chon-mua', 'ACTIVE', '2026-07-16 11:23:20.094');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (4, '2026-07-16 11:23:41.515', 'Cách tối ưu hóa Windows, cách ép xung (overclock), cách vệ sinh máy tính tại nhà.', 'Mẹo & Thủ thuật', 'meo-thu-thuat', 'ACTIVE', '2026-07-16 11:23:41.515');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (5, '2026-07-16 11:23:53.733', 'Giải thích các thuật ngữ (VD: "SSD NVMe là gì?", "Tại sao cần nguồn chuẩn 80 Plus?").', 'Giải đáp kỹ thuật', 'giai-dap-ky-thuat', 'ACTIVE', '2026-07-16 11:23:53.733');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (6, '2026-07-16 11:24:15.128', 'Cập nhật các dòng chip mới, card đồ họa mới ra mắt (NVIDIA/AMD/Intel).', 'Tin công nghệ', 'tin-cong-nghe', 'ACTIVE', '2026-07-16 11:24:15.128');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (7, '2026-07-16 11:24:34.085', 'Đánh giá chi tiết các linh kiện hot, trải nghiệm thực tế hiệu năng máy.', 'Review Sản phẩm', 'review-san-pham', 'ACTIVE', '2026-07-16 11:24:34.085');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (8, '2026-07-16 11:24:45.17', 'Các chương trình khuyến mãi, sự kiện công nghệ hoặc tin tức thị trường phần cứng.', 'Tin tức sự kiện', 'tin-tuc-su-kien', 'ACTIVE', '2026-07-16 11:24:45.17');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (9, '2026-07-16 11:25:14.149', 'Chia sẻ hình ảnh, ý tưởng trang trí góc máy (RGB, decor phòng).', 'Setup PC đẹp', 'setup-pc-dep', 'ACTIVE', '2026-07-16 11:25:14.149');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (10, '2026-07-16 11:25:30.497', 'Gợi ý cấu hình tối ưu cho các tựa game hot (VD: "Cấu hình chơi mượt Valorant/GTA V/Cyberpunk 2077").', 'Cấu hình chơi game', 'cau-hinh-choi-game', 'ACTIVE', '2026-07-16 11:25:30.497');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (11, '2026-07-16 11:25:44.293', 'Giới thiệu các tựa game mới hoặc các công cụ hỗ trợ công việc/giải trí.', 'Review Game & Phần mềm', 'review-game-phan-mem', 'ACTIVE', '2026-07-16 11:25:44.293');

-- Dumping data for table flash_sales
INSERT INTO flash_sales (id, active, created_at, end_time, name, start_time) VALUES (1, 0, '2026-06-22 08:58:57.04', '2026-07-08 12:00:00', 'SALE7/7', '2026-07-07 12:00:00');
INSERT INTO flash_sales (id, active, created_at, end_time, name, start_time) VALUES (2, 1, '2026-06-22 08:58:57.075', '2026-08-08 12:00:00', 'SALE8/7', '2026-07-07 12:00:00');

-- Dumping data for table pc_combos
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES (1, 'HOT', '#ef4444', NULL, '/images/combo1.jpg', 'Combo 1: LXR Core Ultra 7 / RTX 5070Ti', 67000000);
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES (2, 'PREMIUM', '#eab308', NULL, '/images/combo2.jpg', 'Combo 2: LXR Core Ultra 7 / RTX 5080', 67000000);
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES (3, 'SALE', '#22c55e', NULL, '/images/combo3.jpg', 'Combo 3: LXR Intel i5-12400F / RTX 5060', 47000000);
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES (4, 'VALUE', '#3b82f6', NULL, '/images/combo4.jpg', 'Combo 4: LXR Intel i5-12400F / RTX 5060 Ti', 22000000);
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES (5, 'PERFORMANCE', '#f97316', NULL, '/images/combo5.jpg', 'Combo 5: LXR Intel i7-14700F / RTX 5060', 25000000);
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES (6, 'ULTIMATE', 'var(--gold)', NULL, '/images/combo2.jpg', 'Combo 6: LXR AMD Ryzen 9 / RTX 5090', 120000000);
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES (7, 'CREATOR', '#a855f7', NULL, '/images/combo1.jpg', 'Combo 7: LXR Studio / RTX 5080', 85000000);

-- Dumping data for table spring_session
INSERT INTO spring_session (primary_id, session_id, creation_time, last_access_time, max_inactive_interval, expiry_time, principal_name) VALUES ('82866743-8dff-44a6-a51b-9762bc0f05ca', '0536cba6-45f0-44e5-a014-d22ba9545c5f', 1782004704449, 1782011856560, 1800, 1782013656560, 'tuan9bledinhchinh@gmail.com');

-- Dumping data for table user_roles
INSERT INTO user_roles (user_id, role_id, id) VALUES (1, 1, 1);
INSERT INTO user_roles (user_id, role_id, id) VALUES (2, 2, 2);
INSERT INTO user_roles (user_id, role_id, id) VALUES (3, 2, 3);
INSERT INTO user_roles (user_id, role_id, id) VALUES (4, 2, 4);
INSERT INTO user_roles (user_id, role_id, id) VALUES (5, 2, 5);
INSERT INTO user_roles (user_id, role_id, id) VALUES (6, 2, 6);
INSERT INTO user_roles (user_id, role_id, id) VALUES (7, 2, 7);
INSERT INTO user_roles (user_id, role_id, id) VALUES (8, 2, 8);
INSERT INTO user_roles (user_id, role_id, id) VALUES (9, 2, 9);
INSERT INTO user_roles (user_id, role_id, id) VALUES (10, 2, 10);
INSERT INTO user_roles (user_id, role_id, id) VALUES (11, 2, 11);
INSERT INTO user_roles (user_id, role_id, id) VALUES (12, 2, 12);
INSERT INTO user_roles (user_id, role_id, id) VALUES (13, 2, 13);
INSERT INTO user_roles (user_id, role_id, id) VALUES (14, 2, 14);
INSERT INTO user_roles (user_id, role_id, id) VALUES (15, 2, 15);
INSERT INTO user_roles (user_id, role_id, id) VALUES (16, 2, 16);
INSERT INTO user_roles (user_id, role_id, id) VALUES (17, 2, 17);
INSERT INTO user_roles (user_id, role_id, id) VALUES (18, 2, 18);
INSERT INTO user_roles (user_id, role_id, id) VALUES (19, 2, 19);
INSERT INTO user_roles (user_id, role_id, id) VALUES (20, 2, 20);
INSERT INTO user_roles (user_id, role_id, id) VALUES (21, 2, 21);
INSERT INTO user_roles (user_id, role_id, id) VALUES (22, 2, 22);
INSERT INTO user_roles (user_id, role_id, id) VALUES (23, 2, 23);
INSERT INTO user_roles (user_id, role_id, id) VALUES (24, 2, 24);
INSERT INTO user_roles (user_id, role_id, id) VALUES (25, 2, 25);
INSERT INTO user_roles (user_id, role_id, id) VALUES (26, 2, 26);
INSERT INTO user_roles (user_id, role_id, id) VALUES (27, 2, 27);
INSERT INTO user_roles (user_id, role_id, id) VALUES (28, 2, 28);
INSERT INTO user_roles (user_id, role_id, id) VALUES (29, 2, 29);
INSERT INTO user_roles (user_id, role_id, id) VALUES (30, 2, 30);
INSERT INTO user_roles (user_id, role_id, id) VALUES (31, 2, 31);
INSERT INTO user_roles (user_id, role_id, id) VALUES (32, 2, 32);
INSERT INTO user_roles (user_id, role_id, id) VALUES (33, 2, 33);
INSERT INTO user_roles (user_id, role_id, id) VALUES (34, 2, 34);
INSERT INTO user_roles (user_id, role_id, id) VALUES (35, 2, 35);
INSERT INTO user_roles (user_id, role_id, id) VALUES (36, 2, 36);
INSERT INTO user_roles (user_id, role_id, id) VALUES (37, 2, 37);
INSERT INTO user_roles (user_id, role_id, id) VALUES (38, 2, 38);
INSERT INTO user_roles (user_id, role_id, id) VALUES (39, 2, 39);
INSERT INTO user_roles (user_id, role_id, id) VALUES (40, 2, 40);
INSERT INTO user_roles (user_id, role_id, id) VALUES (41, 2, 41);
INSERT INTO user_roles (user_id, role_id, id) VALUES (42, 2, 42);
INSERT INTO user_roles (user_id, role_id, id) VALUES (43, 2, 43);
INSERT INTO user_roles (user_id, role_id, id) VALUES (44, 2, 44);
INSERT INTO user_roles (user_id, role_id, id) VALUES (45, 2, 45);
INSERT INTO user_roles (user_id, role_id, id) VALUES (46, 2, 46);
INSERT INTO user_roles (user_id, role_id, id) VALUES (47, 2, 47);
INSERT INTO user_roles (user_id, role_id, id) VALUES (48, 2, 48);
INSERT INTO user_roles (user_id, role_id, id) VALUES (49, 2, 49);
INSERT INTO user_roles (user_id, role_id, id) VALUES (50, 2, 50);
INSERT INTO user_roles (user_id, role_id, id) VALUES (51, 2, 51);
INSERT INTO user_roles (user_id, role_id, id) VALUES (52, 2, 52);
INSERT INTO user_roles (user_id, role_id, id) VALUES (53, 2, 53);
INSERT INTO user_roles (user_id, role_id, id) VALUES (54, 2, 54);
INSERT INTO user_roles (user_id, role_id, id) VALUES (55, 2, 55);
INSERT INTO user_roles (user_id, role_id, id) VALUES (56, 2, 56);
INSERT INTO user_roles (user_id, role_id, id) VALUES (57, 2, 57);
INSERT INTO user_roles (user_id, role_id, id) VALUES (58, 2, 58);
INSERT INTO user_roles (user_id, role_id, id) VALUES (59, 2, 59);
INSERT INTO user_roles (user_id, role_id, id) VALUES (60, 2, 60);
INSERT INTO user_roles (user_id, role_id, id) VALUES (61, 2, 61);
INSERT INTO user_roles (user_id, role_id, id) VALUES (62, 2, 62);
INSERT INTO user_roles (user_id, role_id, id) VALUES (63, 2, 63);
INSERT INTO user_roles (user_id, role_id, id) VALUES (64, 2, 64);
INSERT INTO user_roles (user_id, role_id, id) VALUES (65, 2, 65);
INSERT INTO user_roles (user_id, role_id, id) VALUES (66, 2, 66);
INSERT INTO user_roles (user_id, role_id, id) VALUES (67, 2, 67);
INSERT INTO user_roles (user_id, role_id, id) VALUES (68, 2, 68);
INSERT INTO user_roles (user_id, role_id, id) VALUES (69, 2, 69);
INSERT INTO user_roles (user_id, role_id, id) VALUES (70, 2, 70);
INSERT INTO user_roles (user_id, role_id, id) VALUES (71, 2, 71);
INSERT INTO user_roles (user_id, role_id, id) VALUES (72, 2, 72);
INSERT INTO user_roles (user_id, role_id, id) VALUES (73, 2, 73);
INSERT INTO user_roles (user_id, role_id, id) VALUES (74, 2, 74);
INSERT INTO user_roles (user_id, role_id, id) VALUES (75, 2, 75);
INSERT INTO user_roles (user_id, role_id, id) VALUES (76, 2, 76);
INSERT INTO user_roles (user_id, role_id, id) VALUES (77, 2, 77);
INSERT INTO user_roles (user_id, role_id, id) VALUES (78, 2, 78);
INSERT INTO user_roles (user_id, role_id, id) VALUES (79, 2, 79);
INSERT INTO user_roles (user_id, role_id, id) VALUES (80, 2, 80);
INSERT INTO user_roles (user_id, role_id, id) VALUES (81, 2, 81);
INSERT INTO user_roles (user_id, role_id, id) VALUES (82, 2, 82);
INSERT INTO user_roles (user_id, role_id, id) VALUES (83, 2, 83);
INSERT INTO user_roles (user_id, role_id, id) VALUES (84, 2, 84);
INSERT INTO user_roles (user_id, role_id, id) VALUES (85, 2, 85);
INSERT INTO user_roles (user_id, role_id, id) VALUES (86, 2, 86);
INSERT INTO user_roles (user_id, role_id, id) VALUES (87, 2, 87);
INSERT INTO user_roles (user_id, role_id, id) VALUES (88, 2, 88);
INSERT INTO user_roles (user_id, role_id, id) VALUES (89, 2, 89);
INSERT INTO user_roles (user_id, role_id, id) VALUES (90, 2, 90);
INSERT INTO user_roles (user_id, role_id, id) VALUES (91, 2, 91);
INSERT INTO user_roles (user_id, role_id, id) VALUES (92, 2, 92);
INSERT INTO user_roles (user_id, role_id, id) VALUES (93, 2, 93);
INSERT INTO user_roles (user_id, role_id, id) VALUES (94, 2, 94);
INSERT INTO user_roles (user_id, role_id, id) VALUES (95, 2, 95);
INSERT INTO user_roles (user_id, role_id, id) VALUES (96, 2, 96);
INSERT INTO user_roles (user_id, role_id, id) VALUES (97, 2, 97);
INSERT INTO user_roles (user_id, role_id, id) VALUES (98, 2, 98);
INSERT INTO user_roles (user_id, role_id, id) VALUES (99, 2, 99);
INSERT INTO user_roles (user_id, role_id, id) VALUES (100, 2, 100);
INSERT INTO user_roles (user_id, role_id, id) VALUES (101, 2, 101);
INSERT INTO user_roles (user_id, role_id, id) VALUES (102, 2, 102);
INSERT INTO user_roles (user_id, role_id, id) VALUES (103, 2, 103);
INSERT INTO user_roles (user_id, role_id, id) VALUES (104, 2, 104);
INSERT INTO user_roles (user_id, role_id, id) VALUES (105, 2, 105);
INSERT INTO user_roles (user_id, role_id, id) VALUES (106, 1, 106);
INSERT INTO user_roles (user_id, role_id, id) VALUES (107, 2, 107);
INSERT INTO user_roles (user_id, role_id, id) VALUES (108, 2, 108);
INSERT INTO user_roles (user_id, role_id, id) VALUES (109, 2, 109);
INSERT INTO user_roles (user_id, role_id, id) VALUES (110, 2, 110);
INSERT INTO user_roles (user_id, role_id, id) VALUES (111, 2, 111);
INSERT INTO user_roles (user_id, role_id, id) VALUES (112, 2, 112);

-- Dumping data for table user_sessions
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (3, 2, 'b4ca1a60-87bd-4024-9a65-66d06090519c', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-20 18:48:14.865', '2026-06-20 18:48:14.865', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (1, 5, '4201e3e4-129c-4f35-b5d1-825db34cda4c', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-20 18:35:07.105', '2026-06-20 18:35:07.105', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (2, 5, '2bb5f7b3-222b-4351-a18f-76778818323d', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-20 18:37:32.378', '2026-06-20 18:37:32.378', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (7, 2, '763abca3-a9fd-4366-81a5-1fbe99b7df89', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-20 21:04:44.264', '2026-06-20 21:04:44.264', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (8, 2, '0536cba6-45f0-44e5-a014-d22ba9545c5f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-21 08:20:34.015', '2026-06-21 08:20:34.015', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (6, 5, '8ee09a1a-fce0-41fb-b41e-f443d371f6d4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-20 19:36:43.203', '2026-06-20 19:36:43.203', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (5, 5, 'b4adc9ce-d1cc-486e-80ce-cbfe8a8af1c0', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-20 18:56:32.364', '2026-06-20 18:56:32.364', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (4, 5, 'c17a7c72-5c75-4728-8eba-0ccfe8c2db0b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome trên Windows', '0:0:0:0:0:0:0:1', 'TP.HCM, Việt Nam', '2026-06-20 18:51:23.4', '2026-06-20 18:51:23.4', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (9, 5, 'D16377E7C472CA5C8170BEEE95661EB2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14 09:48:52.065', '2026-07-14 09:48:52.065', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (10, 8, '7367AC769C2AA53AA11A71EB7E12E2DD', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14 10:42:04.617', '2026-07-14 10:42:04.617', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (11, 8, 'A76D8FD0B7F46C4A2731A91C9ACB0F9B', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14 10:46:31.13', '2026-07-14 10:46:31.13', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (12, 5, '5E1DD9F1ACA6E84FB699D2948E335EBF', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14 10:49:43.077', '2026-07-14 10:49:43.077', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (14, 2, '3B496EB84BA4729E402632D670F8F757', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14 11:31:29.502', '2026-07-14 11:31:29.502', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (13, 5, '52ED2D533772239DEF6DA6DD70F58817', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14 11:19:20.066', '2026-07-14 11:19:20.066', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (15, 5, '2695481ABF5A072EFF4E1F0B594A3E87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14 13:02:56.745', '2026-07-14 13:02:56.745', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (16, 2, '56B186E8711A718FD6AA1C2BBA2B4D7C', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14 16:27:18.997', '2026-07-14 16:27:18.997', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (17, 2, '852373781149679D2DE868A246A7D560', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14 16:32:30.823', '2026-07-14 16:32:30.823', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (18, 3, '2E11D4135950810EBF7A91D91AFA1B87', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14 18:42:59.725', '2026-07-14 18:42:59.725', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (19, 3, 'FD2F988760B70AD452EC3A01C36A59F3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14 20:42:31.715', '2026-07-14 20:42:31.715', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (20, 3, '410E9E0EB6C7A34861CF437D866D4DAE', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14 21:46:03.329', '2026-07-14 21:46:03.329', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (21, 3, '8082AD0E8B48DEC9541B89C0182FC1C5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-14 22:26:42.996', '2026-07-14 22:26:42.996', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (22, 5, 'E4482AE22051BB9DBCB74197256D4A74', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15 10:34:15.079', '2026-07-15 10:34:15.079', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (23, 5, '3B0FA524172ABE089075FCB2B88DF08D', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15 13:12:11.228', '2026-07-15 13:12:11.228', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (24, 5, 'A2DE4BEC2FAE246855EE22F9A4730DC4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15 14:17:32.2', '2026-07-15 14:17:32.2', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (25, 5, '9B8553915EC69AAD8308C45D7E373B06', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15 14:27:09.649', '2026-07-15 14:27:09.649', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (26, 5, '2D6C938B86698EED5D559A07FFBBA0AB', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15 14:27:27.733', '2026-07-15 14:27:27.733', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (27, 2, '27D19D0CAF46BF8046A67C8E570E3893', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15 14:39:58.786', '2026-07-15 14:39:58.786', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (28, 2, 'E9F7D20A4B858CC7FDDB4DCE265D3E79', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15 15:26:12.082', '2026-07-15 15:26:12.082', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (29, 2, '4ECA85F2EFB1A1BD13D55F8A5ADD67F8', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15 15:26:19.693', '2026-07-15 15:26:19.693', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (30, 5, 'C6D32211ACB593746B50B529C2AB9951', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15 16:18:00.101', '2026-07-15 16:18:00.101', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (31, 5, '1DF0ABB9B9A2676AC62B2663285CE740', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15 16:43:26.145', '2026-07-15 16:43:26.145', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (32, 3, '3063AE560226AA779458104DC069692C', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15 19:29:39.606', '2026-07-15 19:29:39.606', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (33, 3, '236A6BE1D162ACA85D4003B5561FC51A', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-15 20:36:12.737', '2026-07-15 20:36:12.737', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (35, 5, '5CD959984D22A221D9744775D7E02EFE', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 08:46:49.732', '2026-07-16 08:46:49.732', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (34, 2, '51967DDEDBCF3FCD2AE2F4BB8DA6FDC5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 08:45:01.788', '2026-07-16 08:45:01.788', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (36, 5, 'ED6424F860A1ECB60CE2A3BA9CC3A1A7', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 09:36:39.567', '2026-07-16 09:36:39.567', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (37, 5, 'AA460F12632EC5B51E3ADB35731DE200', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 09:43:09.29', '2026-07-16 09:43:09.29', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (38, 5, 'BA2F0C67A4877795CEC26C632A8BCAC7', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 09:43:09.947', '2026-07-16 09:43:09.947', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (39, 2, '30C3D6E00CF9F3566642B6120F41BC63', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 10:42:54.008', '2026-07-16 10:42:54.008', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (40, 5, '937D6241700D7EB60D4DC52C21F36F01', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 11:23:11.437', '2026-07-16 11:23:11.437', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (41, 2, '1135F7A24694F08736F9F4522DC30DCB', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 12:00:07.461', '2026-07-16 12:00:07.461', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (42, 2, '3D86806F4C35124970FF59791D8B03E5', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 13:31:41.576', '2026-07-16 13:31:41.576', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (43, 2, '5816B0388C50A7D81CF144C2AFD510FD', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 13:31:43.79', '2026-07-16 13:31:43.79', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (44, 2, '03E10A5B44FB78392CCB712BA5AB2F62', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 13:31:44.821', '2026-07-16 13:31:44.821', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (45, 2, 'F2B6B078E894D4599CB1E1F83F8914EA', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 13:58:13.552', '2026-07-16 13:58:13.552', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (46, 2, '81DF730DAAFD38E6449CE68D40C48E34', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 14:24:37.081', '2026-07-16 14:24:37.081', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (47, 2, '5BF8769C9BC32DB51709A2BB03AFAC32', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 15:16:46.04', '2026-07-16 15:16:46.04', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (48, 2, '66F1666EA7925D18162CEEC39BA88615', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'Chrome (Windows)', '127.0.0.1', 'Localhost', '2026-07-16 15:16:57.735', '2026-07-16 15:16:57.735', 0);

-- Dumping data for table shipping_addresses
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (2, 'd', 'Thành phố Hồ Chí Minh', 0, 'v', '0869949147', 'v', 2);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (1, 'v', 'Thành phố Hồ Chí Minh', 1, '1', '0905338411', 'v', 2);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (5, 'Q12', '02 - Thành phố Hồ Chí Minh', 0, 'Q12', '0902208461', 'Khang', 5);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (4, 'Q12', '02 - Thành phố Hồ Chí Minh', 0, 'Q12', '0902208461', 'Khang Bá', 5);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (6, 'trang nha, nha trang', 'TP.NhaTrang', 0, 'quận trang nha', '0936629311', 'Khang Khang', 5);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (3, 'Q122', '02 - Thành phố Hồ Chí Minh', 0, 'Q12', '0902208461', 'Bá Khang', 5);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (7, 'KonTum', 'KonTum', 1, 'TumKon', '0901560861', 'Bá Bá', 5);

-- Dumping data for table support_tickets
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (1, NULL, 'leecookcu@gmail.com', NULL, 'GENERAL', '2026-06-21 01:18:04.043', 'phamcongthanh.8311@gmail.com', 'thanh', '', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CLOSED', 'Chat hỗ trợ trực tuyến', '2026-06-21 13:10:11.781', 5);
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (2, NULL, 'leecookcu@gmail.com', NULL, 'GENERAL', '2026-06-23 16:34:27.632', 'phamcongthanh.8311@gmail.com', 'thanh', '', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'IN_PROGRESS', 'Chat hỗ trợ trực tuyến', '2026-06-23 17:09:43.807', 5);
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (3, NULL, 'tuan9bledinhchinh@gmail.com', NULL, 'GENERAL', '2026-07-14 09:45:54.78', 'tuan9bledinhchinh@gmail.com', '36', '', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'IN_PROGRESS', 'Chat hỗ trợ trực tuyến', '2026-07-14 09:45:59.943', 2);
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (4, NULL, 'leecookcu@gmail.com', NULL, 'GENERAL', '2026-07-14 13:29:48.231', 'phamcongthanh.8311@gmail.com', 'Thanh', '', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'IN_PROGRESS', 'Chat hỗ trợ trực tuyến', '2026-07-14 13:30:11.568', 5);
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (5, NULL, NULL, NULL, 'GENERAL', '2026-07-14 17:19:18.965', 'tuan9bledinhchinh@gmail.com', '36', '', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'OPE', N'Chat hỗ trợ trực tuyến', '2026-07-14 17:19:18.965', 2);
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (6, NULL, NULL, NULL, 'GENERAL', '2026-07-15 10:47:51.665', 'phamcongthanh.8311@gmail.com', 'Thanh', '', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'OPE', N'Chat hỗ trợ trực tuyến', '2026-07-15 10:47:51.665', 5);

-- Dumping data for table products
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (257, 'Intel Core i5 12400F / 2.5GHz Turbo 4.4GHz (TRAY) - CHÍNH HÃNG', 2500000, 'TDP: 65W', 'i9_14900k.jpg', 1, 99, '2026-06-27 12:52:50.064', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (277, 'Cooler Master Hyper 212 Spectrum V3 ARGB', 600000, 'TDP: 5W', 'corsair_rm850e.jpg', 8, 99, '2026-06-27 12:52:59.845', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (286, 'ROG Ryujin III 360 ARGB', 8500000, 'TDP: 20W', 'rog_ryujin_360.jpg', 8, 108, '2026-06-27 13:16:36.609', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (279, 'Intel Core Ultra 9 285K', 16500000, 'TDP: 125W', 'i9_14900k.jpg', 1, 49, '2026-06-27 13:16:14.752', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (256, 'Intel Core Ultra 7 265F (Tray)', 12000000, 'TDP: 125W', 'i9_14900k.jpg', 1, 97, '2026-06-27 12:52:49.647', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (260, 'GIGABYTE H610M-H V3 (DDR4)', 1800000, 'TDP: 30W', 'z790_dark_kingpin.jpg', 4, 99, '2026-06-27 12:52:51.326', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (278, 'Intel Core i9 14900K (Tray)', 14000000, 'TDP: 125W', 'i9_14900k.jpg', 1, 100, '2026-06-27 13:16:14.081', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (11, 'Intel Core i5-12400F', 3500000, 'Budget King, 6 Cores', 'i9_14900k.jpg', 1, 96, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (258, 'Intel Core i7 14700F (Tray)', 9500000, 'TDP: 65W', 'i9_14900k.jpg', 1, 100, '2026-06-27 12:52:50.462', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (280, 'ASUS ROG MAXIMUS Z790 HERO', 15000000, 'TDP: 60W', 'z790_dark_kingpin.jpg', 4, 100, '2026-06-27 13:16:16.445', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (281, 'ProArt Z790-CREATOR WIFI', 12000000, 'TDP: 55W', 'z790_dark_kingpin.jpg', 4, 100, '2026-06-27 13:16:16.974', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (282, 'Corsair Dominator Titanium 64GB', 6500000, 'TDP: 15W', 'corsair_rm850e.jpg', 3, 100, '2026-06-27 13:16:18.101', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (283, 'G.Skill Trident Z5 64GB DDR5', 5500000, 'TDP: 15W', 'galax_hof_32gb.jpg', 3, 100, '2026-06-27 13:16:18.602', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (284, 'ASUS ROG Strix RTX 5090 24GB', 65000000, 'TDP: 450W', 'asus_rog_rtx_4090.jpg', 9, 100, '2026-06-27 13:16:33.267', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (16, 'Vỏ máy tính Xigmatek QUANTUM 4AF', 800000, 'TDP: 0W', 'corsair_3500x_black.png', 12, 100, '2026-06-27 12:22:45.418', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (285, 'Samsung 990 PRO 2TB', 4500000, 'TDP: 15W', 'sabrent_rocket_4tb.jpg', 7, 100, '2026-06-27 13:16:34.196', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (24, 'AMD Ryzen 5 3600', 2100000, 'Popular AM4 CPU', 'i9_14900k.jpg', 1, 150, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (259, 'GIGABYTE Z890 EAGLE WIFI7 (DDR5)', 7500000, 'TDP: 40W', 'z790_dark_kingpin.jpg', 4, 97, '2026-06-27 12:52:50.891', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (15, 'Intel Core i9-12900K', 9500000, '16 Cores, Previous Flagship', 'i9_14900k.jpg', 1, 13, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (9, 'Intel Core i7-13700F', 8900000, '16 Cores, No Integrated Graphics', 'i9_14900k.jpg', 1, 45, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (14, 'AMD Ryzen 3 4100', 1800000, 'Budget 4 Cores, AM4', 'i9_14900k.jpg', 1, 118, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (18, 'AMD Ryzen 5 8600G', 6200000, 'AI Engine, Radeon 760M', 'i9_14900k.jpg', 1, 34, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (25, 'Intel Core i5-10400F', 2200000, 'Stable and Cheap', 'i9_14900k.jpg', 1, 110, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (26, 'AMD Ryzen 9 3900X', 7500000, '12 Cores, Workstation', 'i9_14900k.jpg', 1, 8, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (27, 'Intel Pentium G7400', 1900000, 'Office work, 2 Cores', 'i9_14900k.jpg', 1, 200, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (28, 'AMD Athlon 3000G', 1200000, 'Ultra Budget Graphics', 'i9_14900k.jpg', 1, 180, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (22, 'AMD Ryzen 5 4500', 1950000, 'Super Budget 6 Cores', 'i9_14900k.jpg', 1, 92, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (33, 'RTX 4070 Ti Super', 24500000, 'Perfect for 2K Gaming', 'asus_rog_rtx_4090.jpg', 2, 25, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (36, 'AMD RX 7800 XT', 15200000, 'Best value 2K GPU', 'asus_rog_rtx_4090.jpg', 2, 30, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (38, 'AMD RX 6600', 5500000, 'Best budget 1080p', 'asus_rog_rtx_4090.jpg', 2, 100, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (160, 'BenQ SW271C', 42000000, 'Pro Color Photo', 'corsair_3500x_black.png', 6, 3, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (4, 'AMD Ryzen 7 7800X3D', 11500000, 'Best gaming CPU, 8 Cores, 3D V-Cache', 'i9_14900k.jpg', 1, 27, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (20, 'AMD Ryzen 7 7700', 7800000, '8 Cores, Low Power 65W', 'i9_14900k.jpg', 1, 28, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (21, 'Intel Core i5-11400F', 2800000, 'Old Gen Budget King', 'i9_14900k.jpg', 1, 50, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (3, 'Intel Core i7-14700Kkk', 10800000, '20 Cores, Hybrid Architecture', 'i9_14900k.jpg', 1, 0, NULL, NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (29, 'Intel Core i7-10700K', 4800000, 'High Clock Legacy', 'i9_14900k.jpg', 1, 20, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (30, 'AMD Ryzen 7 8700G', 9200000, 'Powerful APU, Radeon 780M', 'i9_14900k.jpg', 1, 33, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (31, 'NVIDIA RTX 4090 24GB', 55000000, 'Ultimate Gaming GPU', 'asus_rog_rtx_4090.jpg', 2, 10, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (32, 'RTX 4080 Super', 32000000, 'High-end 4K Gaming', 'asus_rog_rtx_4090.jpg', 2, 15, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (34, 'AMD RX 7900 XTX', 28500000, 'AMD Flagship, 24GB', 'asus_rog_rtx_4090.jpg', 2, 12, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (261, 'GIGABYTE B760M GAMING PLUS WIFI DDR4', 3500000, 'TDP: 40W', 'z790_dark_kingpin.jpg', 4, 100, '2026-06-27 12:52:51.741', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (39, 'ASUS ROG RTX 4090', 62000000, 'Premium build cooling', 'asus_rog_rtx_4090.jpg', 2, 5, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (48, 'EVGA RTX 3080', 15000000, 'High performance legacy', 'asus_rog_rtx_4090.jpg', 2, 5, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (41, 'Gigabyte Eagle RTX 4060', 8200000, 'Triple Fan Budget', 'asus_rog_rtx_4090.jpg', 2, 60, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (42, 'RTX 4070 Super', 17800000, '12GB GDDR6X, Fast', 'asus_rog_rtx_4090.jpg', 2, 35, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (43, 'AMD RX 7600', 7900000, 'Budget RDNA 3', 'asus_rog_rtx_4090.jpg', 2, 50, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (44, 'RTX 3050 6GB', 5200000, 'Entry level RTX', 'asus_rog_rtx_4090.jpg', 2, 70, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (102, 'ProArt Z790-Creator', 13800000, 'For Creators', 'z790_dark_kingpin.jpg', 4, 10, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (45, 'Zotac RTX 4060', 7800000, 'Compact dual fan', 'asus_rog_rtx_4090.jpg', 2, 40, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (46, 'Galax RTX 4070 Pink', 16900000, 'Pink Edition RGB', 'asus_rog_rtx_4090.jpg', 2, 15, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (50, 'PowerColor RX 7800 XT', 14800000, 'Excellent cooling', 'asus_rog_rtx_4090.jpg', 2, 22, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (52, 'RX 6700 XT', 9500000, 'Great 1440p value', 'asus_rog_rtx_4090.jpg', 2, 40, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (53, 'Colorful RTX 4080', 31000000, 'LCD screen on GPU', 'asus_rog_rtx_4090.jpg', 2, 8, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (57, 'Intel Arc A750', 6500000, 'Budget King Intel', 'i9_14900k.jpg', 2, 40, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (59, 'Gigabyte RTX 4090', 59000000, 'Massive cooler', 'asus_rog_rtx_4090.jpg', 2, 4, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (63, 'Kingston Fury 16GB', 1250000, 'DDR4 3200MHz', 'sabrent_rocket_4tb.jpg', 3, 120, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (64, 'T-Force Delta 32GB', 3200000, 'DDR5 6000MHz White', 'corsair_3500x_black.png', 3, 45, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (69, 'Lexar Thor 32GB', 2100000, 'DDR4 3200MHz Budget', 'corsair_3500x_black.png', 3, 55, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (70, 'Fury Renegade 32GB', 4800000, 'DDR5 7200MHz', 'corsair_3500x_black.png', 3, 25, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (71, 'PNY XLR8 16GB', 1350000, 'DDR4 3200MHz RGB', 'corsair_3500x_black.png', 3, 60, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (72, 'Silicon Power 16GB', 950000, 'Value RAM 3200', 'corsair_3500x_black.png', 3, 150, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (74, 'Patriot Viper 16GB', 1450000, 'DDR4 4000MHz', 'corsair_3500x_black.png', 3, 40, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (76, 'Thermaltake 16GB', 2200000, 'DDR4 3600MHz RGB', 'corsair_3500x_black.png', 3, 25, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (78, 'Apacer Panther 8GB', 750000, 'Budget Gaming RAM', 'corsair_3500x_black.png', 3, 100, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (79, 'GeIL Super Luce 16GB', 1300000, 'DDR4 3200MHz', 'corsair_3500x_black.png', 3, 50, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (40, 'MSI Gaming X RTX 4070', 18500000, 'Quiet and Cool', 'asus_rog_rtx_4090.jpg', 2, 20, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (37, 'RTX 3060 12GB', 7800000, 'Popular Mid-range', 'asus_rog_rtx_4090.jpg', 2, 80, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (111, 'Z790 Dark Kingpin', 22000000, 'Limitless OC', 'z790_dark_kingpin.jpg', 4, 2, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (55, 'Radeon Pro W7800', 58000000, 'Professional Graphics', 'asus_rog_rtx_4090.jpg', 2, 3, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (62, 'G.Skill Trident Z5 32GB', 4200000, 'DDR5 6400MHz RGB', 'galax_hof_32gb.jpg', 3, 40, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (262, 'RAM Kingmax Horizon 16GB DDR5 Bus 5600Mhz', 1200000, 'TDP: 10W', 'galax_hof_32gb.jpg', 3, 97, '2026-06-27 12:52:52.239', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (84, 'Team Elite 16GB', 1600000, 'DDR5 4800 Basic', 'corsair_3500x_black.png', 3, 60, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (35, 'RTX 4060 Ti 8GB', 11500000, 'Efficient 1080p/2K', 'asus_rog_rtx_4090.jpg', 2, 43, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (5, 'Intel Core i5-13600K', 8200000, '14 Cores, Mid-range gaming', 'i9_14900k.jpg', 1, 54, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (6, 'AMD Ryzen 5 7600X', 5800000, '6 Cores, Zen 4 Architecture, AM5', 'i9_14900k.jpg', 1, 59, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (8, 'AMD Ryzen 9 7900X', 10500000, '12 Cores, 5.6GHz Boost', 'i9_14900k.jpg', 1, 18, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (1, 'Intel Core i9-14900K', 15500000, '24 Cores, up to 6.0GHz, LGA 1700', 'i9_14900k.jpg', 1, 46, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (2, 'AMD Ryzen 9 7950X3D', 17200000, '16 Cores, 128MB L3 Cache, AM5', 'i9_14900k.jpg', 1, 15, NULL, NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (10, 'AMD Ryzen 7 5800X3D', 8500000, 'Legendary AM4 gaming CPU', 'i9_14900k.jpg', 1, 25, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (17, 'Intel Core i5-14400F', 5600000, '10 Cores, Efficient Gaming', 'i9_14900k.jpg', 1, 64, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (13, 'Intel Core i3-14100', 3800000, 'Entry level 14th Gen', 'i9_14900k.jpg', 1, 37, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (19, 'Intel Core i7-12700K', 7200000, '12 Cores, LGA 1700', 'i9_14900k.jpg', 1, 34, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (47, 'ASUS TUF RTX 3070 Ti', 12000000, 'Rugged build quality', 'asus_rog_rtx_4090.jpg', 2, 10, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (49, 'Sapphire RX 7900 GRE', 16500000, 'Golden Rabbit Edition', 'asus_rog_rtx_4090.jpg', 2, 18, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (51, 'GTX 1650', 3800000, 'No external power', 'asus_rog_rtx_4090.jpg', 2, 150, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (85, 'Crucial Pro 32GB', 3300000, '6000MHz Overclock', 'sabrent_rocket_4tb.jpg', 3, 45, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (86, 'Aorus RGB 16GB', 2400000, '3733MHz w/ Demo', 'corsair_3500x_black.png', 3, 15, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (263, 'Ram KingSpec Heatsink Red 1x16GB DDR4 Bus 3200Mhz', 750000, 'TDP: 10W', 'galax_hof_32gb.jpg', 3, 100, '2026-06-27 12:52:52.718', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (101, 'Z790 Taichi', 12500000, 'Gear design, E-ATX', 'z790_dark_kingpin.jpg', 4, 8, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (120, 'Valkyrie Z790', 9500000, 'Biostar Flagship', 'z790_dark_kingpin.jpg', 4, 7, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (121, 'Samsung 990 Pro 1T', 3200000, 'NVMe Gen4 7450MB/s', 'sabrent_rocket_4tb.jpg', 5, 60, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (135, 'Sabrent Rocket 4TB', 12500000, 'Huge capacity', 'sabrent_rocket_4tb.jpg', 5, 8, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (1, 'Intel Core i9-14900K', 15500000, '24 Cores, up to 6.0GHz, LGA 1700', 'i9_14900k.jpg', 1, 46, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (150, 'Crucial T705 2TB', 10500000, 'Fastest Gen5', 'sabrent_rocket_4tb.jpg', 5, 5, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (184, 'AMD Radeon RX 7900 XT GPU', 22834600, '20GB GDDR6, 80MB, 315W', 'asus_rog_rtx_4090.jpg', 2, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (91, 'ROG Maximus Z790 Hero', 16500000, 'Flagship Intel Board', 'z790_dark_kingpin.jpg', 4, 12, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (92, 'B760M Mortar WiFi', 4500000, 'Best Mid-range Intel', 'z790_dark_kingpin.jpg', 4, 45, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (95, 'B660M Pro RS', 3200000, 'Budget Intel 12/13', 'corsair_3500x_black.png', 4, 60, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (96, 'X670E Carbon WiFi', 11500000, 'High-end AM5', 'z790_dark_kingpin.jpg', 4, 15, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (97, 'Prime H610M-K', 2100000, 'Office Intel Board', 'z790_dark_kingpin.jpg', 4, 100, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (100, 'Z790 GODLIKE', 35000000, 'Ultimate Overclock', 'z790_dark_kingpin.jpg', 4, 3, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (103, 'B650I Aorus Ultra', 7200000, 'ITX AM5 Board', 'z790_dark_kingpin.jpg', 4, 12, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (105, 'Crosshair X670E', 28000000, 'Best of AM5', 'z790_dark_kingpin.jpg', 4, 5, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (107, 'CVN B760M Frozen', 4200000, 'White Motherboard', 'z790_dark_kingpin.jpg', 4, 25, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (108, 'A520M S2H', 1650000, 'Budget AM4', 'corsair_3500x_black.png', 4, 90, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (189, 'ASUS ROG Strix GeForce RTX 4090 OC Edition', 50774600, '24GB GDDR6X, 16384, PCIe 4.0', 'asus_rog_rtx_4090.jpg', 2, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (264, 'MSI GeForce RTX 5070 Ti 16GB Shadow 3X OC', 25000000, 'TDP: 250W', 'asus_rog_rtx_4090.jpg', 9, 99, '2026-06-27 12:52:53.246', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (165, 'HP Z27k G3', 15500000, '4K Studio USB-C', 'corsair_3500x_black.png', 6, 15, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (109, 'NZXT N7 Z790', 8500000, 'Clean Aesthetic', 'z790_dark_kingpin.jpg', 4, 18, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (110, 'A620M-HDV', 2800000, 'Cheap AM5 entry', 'corsair_3500x_black.png', 4, 55, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (112, 'X570S Tomahawk', 6500000, 'Silent AM4', 'corsair_3500x_black.png', 4, 20, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (113, 'A520M-Plus', 2400000, 'Durable AM4', 'corsair_3500x_black.png', 4, 45, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (114, 'Z790 UD', 5500000, 'Basic Z790', 'z790_dark_kingpin.jpg', 4, 35, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (115, 'B550M Steel Legend', 3800000, 'Solid B550 AM4', 'corsair_3500x_black.png', 4, 40, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (116, 'MSI B650 Gaming', 4900000, 'Budget AM5 WiFi', 'z790_dark_kingpin.jpg', 4, 50, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (266, 'MSI GeForce RTX 5060 Ventus 2X OC 8GB', 8500000, 'TDP: 150W', 'asus_rog_rtx_4090.jpg', 9, 100, '2026-06-27 12:52:54.227', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (267, 'ZOTAC GeForce RTX 5060 Ti 8GB TWIN EDGE GDDR7', 11000000, 'TDP: 160W', 'asus_rog_rtx_4090.jpg', 9, 100, '2026-06-27 12:52:54.716', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (269, 'Ổ Cứng SSD KingSpec NVMe 512GB (NE-512)', 800000, 'TDP: 10W', 'sabrent_rocket_4tb.jpg', 7, 100, '2026-06-27 12:52:55.693', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (265, 'GIGABYTE GeForce RTX 5080 WINDFORCE OC SFF 16G', 35000000, 'TDP: 300W', 'asus_rog_rtx_4090.jpg', 9, 98, '2026-06-27 12:52:53.742', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (268, 'Ổ cứng SSD Kingston NV3 1TB M.2 PCIe NVMe Gen4', 1800000, 'TDP: 10W', 'sabrent_rocket_4tb.jpg', 7, 97, '2026-06-27 12:52:55.209', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (118, 'H610M S2H', 2250000, 'LGA 1700 Office', 'z790_dark_kingpin.jpg', 4, 110, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (119, 'X670E Steel Legend', 8900000, 'White AM5 High', 'z790_dark_kingpin.jpg', 4, 15, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (122, 'Samsung 980 Pro 2T', 4500000, 'NVMe Gen4 7000MB/s', 'sabrent_rocket_4tb.jpg', 5, 40, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (56, 'Intel Arc A770 16GB', 9200000, 'Intel High-end GPU', 'i9_14900k.jpg', 2, 25, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (58, 'ASUS Dual RTX 4070', 17500000, 'Clean white build', 'asus_rog_rtx_4090.jpg', 2, 15, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (60, 'PNY RTX 4060', 7500000, 'Small and efficient', 'asus_rog_rtx_4090.jpg', 2, 55, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (61, 'Corsair Vengeance 32GB', 3500000, 'DDR5 6000MHz Black', 'galax_hof_32gb.jpg', 3, 50, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (65, 'ADATA XPG 16GB', 1800000, 'DDR5 5200MHz', 'corsair_3500x_black.png', 3, 70, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (66, 'Crucial 8GB', 650000, 'Standard office RAM', 'sabrent_rocket_4tb.jpg', 3, 200, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (67, 'Dominator Titanium 64GB', 9500000, 'DDR5 7200MHz', 'corsair_3500x_black.png', 3, 10, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (68, 'Ripjaws V 16GB', 1100000, 'DDR4 3600MHz', 'corsair_3500x_black.png', 3, 90, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (73, 'Mushkin Redline 32GB', 3400000, 'DDR5 5600MHz', 'corsair_3500x_black.png', 3, 20, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (75, 'Samsung 32GB', 2800000, 'DDR5 4800MHz OEM', 'sabrent_rocket_4tb.jpg', 3, 30, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (123, 'WD SN850X 1TB', 2600000, 'Top gaming SSD', 'corsair_3500x_black.png', 5, 55, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (124, 'Crucial P3 Plus 1T', 1850000, 'Budget Gen4', 'sabrent_rocket_4tb.jpg', 5, 100, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (126, 'Samsung 870 EVO 1T', 2100000, 'Best SATA SSD', 'sabrent_rocket_4tb.jpg', 5, 80, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (127, 'P41 Platinum 2T', 5200000, 'Super Fast Gen4', 'corsair_3500x_black.png', 5, 20, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (128, 'Lexar NM790 2T', 3800000, 'Value Gen4 7400', 'corsair_3500x_black.png', 5, 45, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (129, 'Crucial T700 1TB', 5800000, 'Gen5 11700MB/s', 'sabrent_rocket_4tb.jpg', 5, 15, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (131, 'TeamGroup MP33 1T', 1400000, 'Budget NVMe', 'corsair_3500x_black.png', 5, 90, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (132, 'XPG S70 Blade 1T', 2200000, 'PS5 Gen4', 'corsair_3500x_black.png', 5, 65, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (133, 'SN580 1TB', 1700000, 'Reliable Gen4', 'corsair_3500x_black.png', 5, 75, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (134, 'FireCuda 530 2TB', 5900000, 'High endurance', 'corsair_3500x_black.png', 5, 18, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (139, 'MP600 Pro 2TB', 4800000, 'Optimized for PS5', 'corsair_3500x_black.png', 5, 22, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (143, 'Spatium M480 2TB', 4600000, 'High-end MSI SSD', 'corsair_3500x_black.png', 5, 20, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (151, 'LG 27GR95QE', 22500000, '27" OLED 240Hz', 'corsair_3500x_black.png', 6, 12, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (152, 'Dell U2723QE', 14800000, '27" 4K IPS Black', 'corsair_3500x_black.png', 6, 25, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (153, 'VG249Q', 4200000, '24" 144Hz IPS', 'corsair_3500x_black.png', 6, 60, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (156, 'AOC 24G2', 3900000, 'Popular 144Hz', 'corsair_3500x_black.png', 6, 80, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (157, 'ViewSonic VX2728', 4500000, '27" 165Hz IPS', 'corsair_3500x_black.png', 6, 50, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (161, 'Samsung M7', 8200000, '32" 4K Smart', 'sabrent_rocket_4tb.jpg', 6, 30, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (162, 'LG 24MP60G', 2900000, 'Budget 24" IPS', 'corsair_3500x_black.png', 6, 100, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (77, 'Zadak Spark 32GB', 3900000, 'DDR5 6000MHz', 'corsair_3500x_black.png', 3, 15, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (80, 'V-Color Prism 32GB', 3100000, 'DDR4 3600MHz RGB', 'corsair_3500x_black.png', 3, 40, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (81, 'Kingston Fury 64GB', 6800000, 'DDR5 5600MHz Kit', 'sabrent_rocket_4tb.jpg', 3, 20, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (82, 'Vengeance LPX 32GB', 2500000, 'DDR4 3200 Low Profile', 'galax_hof_32gb.jpg', 3, 80, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (83, 'Trident Z Neo 32GB', 3400000, 'Optimized for Ryzen', 'galax_hof_32gb.jpg', 3, 35, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (87, 'Lexar Ares 32GB', 3600000, 'DDR5 6400MHz', 'corsair_3500x_black.png', 3, 30, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (90, 'Oloy Blade 32GB', 3250000, 'DDR5 6000MHz Black', 'corsair_3500x_black.png', 3, 25, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (93, 'Z790 Aorus Elite', 7800000, 'High perf Z790', 'z790_dark_kingpin.jpg', 4, 30, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (94, 'TUF B650-Plus', 5800000, 'Standard AM5 Board', 'z790_dark_kingpin.jpg', 4, 40, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (98, 'B450M DS3H', 1850000, 'Legendary AM4 Budget', 'corsair_3500x_black.png', 4, 80, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (99, 'ROG Strix B760-I', 5900000, 'ITX Intel Board', 'z790_dark_kingpin.jpg', 4, 20, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (104, 'PRO H610M-E', 1950000, 'Cheap office build', 'z790_dark_kingpin.jpg', 4, 150, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (106, 'Biostar B760MZ', 3100000, 'Budget B760', 'z790_dark_kingpin.jpg', 4, 40, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (117, 'Prime Z790-P', 6200000, 'Mainstream Z790', 'z790_dark_kingpin.jpg', 4, 30, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (125, 'Kingston NV2 500G', 950000, 'Entry NVMe', 'sabrent_rocket_4tb.jpg', 5, 150, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (130, 'Aorus Gen5 2TB', 9500000, 'Gen5 w/ Heatsink', 'corsair_3500x_black.png', 5, 10, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (136, '970 EVO Plus 2TB', 3900000, 'Gen3 King', 'corsair_3500x_black.png', 5, 30, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (137, 'PNY CS2241 1TB', 1600000, 'Budget Gen4', 'corsair_3500x_black.png', 5, 50, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (271, 'Cooler Master MWE 650 - 80 Plus Bronze - V3 230V (650W)', 1500000, 'TDP: 0W', 'corsair_rm850e.jpg', 11, 100, '2026-06-27 12:52:56.68', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (272, 'Nguồn FSP HV PRO 650W - 80 Plus Bronze', 1400000, 'TDP: 0W', 'corsair_rm850e.jpg', 11, 100, '2026-06-27 12:52:57.17', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (273, 'Corsair CX650 - 80 Plus Bronze (650W)', 1600000, 'TDP: 0W', 'corsair_rm850e.jpg', 11, 100, '2026-06-27 12:52:57.668', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (274, 'Corsair 3500X TG Mid Tower Black', 2000000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 99, '2026-06-27 12:52:58.157', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (275, 'Corsair FRAME 4500X RS-R ARGB Panoramic Black', 3500000, 'TDP: 0W', 'galax_hof_32gb.jpg', 12, 98, '2026-06-27 12:52:58.657', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (276, 'Tản nhiệt AIO Corsair NAUTILUS 360 ARGB Black', 2800000, 'TDP: 15W', 'corsair_rm850e.jpg', 8, 97, '2026-06-27 12:52:59.35', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (270, 'Corsair RM850e ATX 3.1 - 80 Plus Gold - Full Modular (850W)', 3500000, 'TDP: 0W', 'corsair_rm850e.jpg', 11, 97, '2026-06-27 12:52:56.192', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (138, 'Silicon Power UD90 1650000', 1650000, 'Gen4 Value', 'corsair_3500x_black.png', 5, 60, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (140, 'KC3000 1TB', 2450000, 'Fast Gen4 OS', 'corsair_3500x_black.png', 5, 40, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (166, 'Nitro VG271U', 6500000, '27" 2K 144Hz', 'corsair_3500x_black.png', 6, 45, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (171, 'ProArt PA278QV', 8900000, 'Color Accurate', 'corsair_3500x_black.png', 6, 18, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (172, 'HKC ANT27TQC', 5500000, 'Budget 2K Curved', 'corsair_3500x_black.png', 6, 55, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (173, 'MSI G2412', 3500000, 'Budget 170Hz', 'corsair_3500x_black.png', 6, 90, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (180, 'Xiaomi Mi 34', 9500000, '34" 2K UltraWide', 'corsair_3500x_black.png', 6, 40, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (141, 'Crucial MX500 1TB', 1800000, 'SATA storage', 'sabrent_rocket_4tb.jpg', 5, 85, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (142, 'SN350 480GB', 850000, 'Cheap upgrade', 'corsair_3500x_black.png', 5, 120, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (144, 'Transcend 250S 1T', 2100000, 'Gen4 with Cache', 'corsair_3500x_black.png', 5, 35, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (145, 'Viper VP4300 2TB', 5400000, 'Dual heatsinks', 'corsair_3500x_black.png', 5, 12, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (146, 'Lexar NM620 512G', 900000, 'Gen3 Budget', 'corsair_3500x_black.png', 5, 100, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (147, 'Netac N7000 2TB', 3600000, 'Gen4 7000MB/s', 'corsair_3500x_black.png', 5, 40, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (149, 'Adata SU650 240G', 450000, 'Cheapest SSD', 'corsair_3500x_black.png', 5, 200, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (154, 'Odyssey Neo G8', 28000000, '32" 4K 240Hz', 'samsung_990pro.jpg', 6, 8, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (155, 'Gigabyte M27Q', 7800000, '27" 2K 170Hz', 'corsair_3500x_black.png', 6, 35, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (158, 'MAG274QRF-QD', 10500000, '2K Quantum Dot', 'corsair_3500x_black.png', 6, 20, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (159, 'AW3423DW', 32000000, '34" QD-OLED', 'samsung_990pro.jpg', 6, 5, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (163, 'Swift PG42UQ', 38000000, '42" OLED 4K', 'samsung_990pro.jpg', 6, 4, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (164, 'Gigabyte G24F 2', 4100000, '24" 180Hz OC', 'corsair_3500x_black.png', 6, 70, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (167, 'Dell S2721DGF', 9200000, 'Fast IPS 165Hz', 'corsair_3500x_black.png', 6, 22, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (168, 'LG DualUp', 16000000, 'Square 16:18', 'corsair_3500x_black.png', 6, 10, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (169, 'Odyssey G5', 7200000, '27" 2K Curved', 'samsung_990pro.jpg', 6, 40, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (170, 'Legion Y25-30', 6800000, '24.5" 240Hz', 'corsair_3500x_black.png', 6, 25, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (175, 'LG 29WP500', 5200000, '29" UltraWide', 'corsair_3500x_black.png', 6, 35, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (176, 'Philips 242E1', 3100000, 'Budget 144Hz', 'corsair_3500x_black.png', 6, 80, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (177, 'AOC CU34G2X', 12500000, '34" UW 144Hz', 'corsair_3500x_black.png', 6, 15, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (178, 'Xeneon Flex', 45000000, 'Bendable OLED', 'samsung_990pro.jpg', 6, 2, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (179, 'Zowie XL2546K', 13500000, 'Pro Esport 240Hz', 'corsair_3500x_black.png', 6, 20, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (181, 'Intel Arc A770 Limited Edition GPU', 8356600, '16GB GDDR6, 256-BOOLEAN, 2100 MHz, 225W', 'i9_14900k.jpg', 2, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (183, 'Intel Arc A580 Graphics Card', 4546600, '8GB GDDR6, 256-BOOLEAN, 1700 MHz, 185W', 'asus_rog_rtx_4090.jpg', 2, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (186, 'AMD Ryzen 5 5600X Desktop Processor', 3784600, '6, 12, AM4, 65W', 'i9_14900k.jpg', 1, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (188, 'ASUS ROG Strix X670E-E Gaming WiFi', 12674600, 'AM5, AMD X670E, PCIe 5.0, ATX', 'z790_dark_kingpin.jpg', 4, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (190, 'ASUS ROG Swift OLED PG32UCDM', 32994600, '32-inch, 3840x2160 (4K), 240Hz, QD-OLED', 'samsung_990pro.jpg', 6, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (192, 'ASUS ROG Thor 1200W Platinum II', 8102600, '1200W, 80 Plus Platinum, Full Modular, Real-time power draw', 'corsair_3500x_black.png', 11, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (193, 'MSI MEG Z790 GODLIKE MAX', 30454600, 'LGA1700, Intel Z790, 7x M.2 slots, M-Vision Dashboard', 'z790_dark_kingpin.jpg', 4, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (195, 'MSI GeForce RTX 4080 SUPER 16G GAMING X SLIM', 26644600, '16GB GDDR6X, TRI FROZR 3, 2625 MHz', 'asus_rog_rtx_4090.jpg', 2, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (196, 'MSI MPG 271QRX QD-OLED', 20294600, '27-inch, 2560x1440 (2K), 360Hz, 0.03ms (GtG)', 'asus_rog_rtx_4090.jpg', 6, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (198, 'MSI MAG CORELIQUID I360', 3530600, '360mm, ARGB Fans, Infinite Mirror IPS Style Design', 'i9_14900k.jpg', 13, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (199, 'MSI SPATIUM M570 PCIe 5.0 NVMe M.2 HS', 7594600, '2TB, Up to 12400 MB/s, Up to 11800 MB/s', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (88, 'Netac Shadow 16GB', 1100000, 'Budget RGB RAM', 'corsair_3500x_black.png', 3, 100, NULL, NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (200, 'Gigabyte Z790 AORUS XTREME X', 25374600, 'LGA1700, 24+1+2 Phases, Wi-Fi 7, PCIe 5.0 x16', 'z790_dark_kingpin.jpg', 4, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (202, 'Gigabyte M27Q Gaming Monitor', 7594600, '27-inch, Super Speed IPS, 2560x1440, 170Hz', 'samsung_990pro.jpg', 6, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (203, 'Gigabyte AORUS FO32U2P', 30454600, '32-inch, OLED (QD-OLED), 3840x2160, DP 2.1 UHBR20 supported', 'corsair_3500x_black.png', 6, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (209, 'Corsair iCUE LINK H150i LCD Liquid CPU Cooler', 7340600, '360mm, 3x QX120 RGB Fans, 2.1-inch IPS Display, iCUE LINK Ecosystem', 'i9_14900k.jpg', 13, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (210, 'Corsair 5000D AIRFLOW Tempered Glass Mid-Tower', 4165600, 'Mid-Tower, Black, RapidRoute System, Up to 10x 120mm fans', 'corsair_rm850e.jpg', 12, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (212, 'Corsair RM1000x Shift Fully Modular ATX PSU', 5308600, '1000W, 80 PLUS Gold, Side-mounted modular connections, ATX 3.0 & PCIe 5.0 ready', 'corsair_rm850e.jpg', 11, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (213, 'Corsair AX1600i Digital ATX Power Supply', 15468600, '1600W, 80 PLUS Titanium, Gallium Nitride (GaN) FETs', 'corsair_rm850e.jpg', 11, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (215, 'Corsair Darkstar Wireless MMO Gaming Mouse', 4292600, '15 programmable buttons, MARKSMAN 26K DPI Optical, SLIPSTREAM Wireless & Bluetooth', 'corsair_rm850e.jpg', 16, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (216, 'Corsair Virtuoso RGB Wireless XT Headset', 6832600, 'High-Density 50mm Neodymium, Spatial Dolby Atmos, Broadcast-grade detachable mic', 'corsair_rm850e.jpg', 17, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (217, 'Logitech G Pro X Superlight 2 Wireless GamingMouse', 4038600, '60 grams, HERO 2 Sensor (32,000 DPI), LIGHTFORCE Hybrid Switches, 4000Hz max polling', 'corsair_3500x_black.png', 16, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (219, 'Logitech G915 TKL Wireless Mechanical Keyboard', 5816600, 'Tenkeyless (TKL), Low Profile GL Tactile/Linear/Clicky, Up to 40 hours (100% brightness)', 'corsair_3500x_black.png', 15, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (220, 'Logitech G Pro X TKL LIGHTSPEED Gaming Keyboard', 5054600, 'Dual-shot PBT keycaps, LIGHTSPEED Wireless, Bluetooth, USB, Dedicated volume roller and controls', 'corsair_3500x_black.png', 15, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (221, 'Logitech G Pro X 2 LIGHTSPEED Wireless Headset', 6324600, '50mm Graphene Drivers, LIGHTSPEED, Bluetooth, 3.5mm wired, Up to 50 hours battery life', 'corsair_3500x_black.png', 17, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (223, 'Logitech MX Keys S Wireless Keyboard', 2768600, 'Spherically-dished Perfect Stroke keys, Smart illumination proximity sensor, Easy-Switch up to 3 devices', 'corsair_3500x_black.png', 15, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (224, 'Razer Viper V3 Pro Wireless Gaming Mouse', 4038600, '54 grams, Focus Pro 35K Optical Sensor Gen-2, True 8000Hz HyperPolling Wireless', 'corsair_3500x_black.png', 16, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (225, 'Razer DeathAdder V3 Pro Wireless Gaming Mouse', 3784600, '63 grams, Right-handed ergonomic design, Focus Pro 30K Optical Sensor', 'corsair_3500x_black.png', 16, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (227, 'Razer BlackWidow V4 Pro Mechanical GamingKeyboard', 5816600, 'Razer Green Clicky / Yellow Linear Switches, Per-key & 3-sided underglow RGB, 8 dedicated macro keys', 'corsair_3500x_black.png', 15, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (228, 'Razer BlackShark V2 Pro (2023 Edition) WirelessHeadset', 5054600, 'Razer HyperClear Super Wideband Mic, TriForce Titanium 50mm Drivers, Up to 70 hours', 'corsair_3500x_black.png', 17, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (232, 'Samsung Odyssey OLED G9 (G95SC) Gaming Monitor', 40614600, '49-inch Curved Ultra-wide, 5120x1440 (Dual QHD), 240Hz, 0.03ms (GtG)', 'sabrent_rocket_4tb.jpg', 6, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (233, 'Samsung Odyssey Ark Gen 2 Mini-LED Monitor', 63474600, '55-inch 1000R Curved, 3840x2160 (4K), 165Hz, Yes, rotates vertically', 'sabrent_rocket_4tb.jpg', 6, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (235, 'Kingston FURY Renegade DDR5 RGB 32GB (2x16GB) 7200MHz', 4292600, '32GB Kit, 7200 MT/s, CL38-44-44, 1.45V', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (236, 'Kingston FURY Beast DDR5 32GB (2x16GB) 6000MHz', 3022600, '32GB Kit, 6000 MT/s, AMD EXPO / Intel XMP 3.0 certified', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (237, 'Kingston KC3000 PCIe 4.0 NVMe M.2 SSD 2TB', 3911600, '2TB, Up to 7000 MB/s, Up to 7000 MB/s, Phison E18', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (238, 'Kingston NV2 PCIe 4.0 NVMe M.2 SSD 1TB', 1625600, '1TB, Up to 3500 MB/s, Up to 2100 MB/s, M.2 2280', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (240, 'WD Red Pro NAS Internal Hard Drive 12TB', 7594600, '12TB, 7200 RPM, 256MB, SATA 6 Gb/s', 'corsair_3500x_black.png', 10, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (241, 'Seagate IronWolf Pro 16TB NAS HDD', 8356600, '16TB, 550TB/year, Rotational Vibration (RV) sensors', 'sabrent_rocket_4tb.jpg', 10, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (243, 'NZXT H9 Flow Dual-Chamber Mid-Tower', 4038600, 'Wrap-around tempered glass pane, 4x F120Q Airflow fans, Up to 435mm', 'corsair_3500x_black.png', 12, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (244, 'NZXT Kraken Elite 360 RGB Liquid Cooler', 7594600, '360mm aluminum radiator, 2.36-inch wide-angle TFT-LCD display, 640x640 pixels', 'rog_ryujin_360.jpg', 13, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (246, 'BenQ ZOWIE XL2566K 360Hz Esports Gaming Monitor', 15214600, '24.5-inch TN Panel, 360Hz, DyAc+ Technology motion blur reduction', 'samsung_990pro.jpg', 6, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (205, 'Gigabyte UD1000GM PG5 (Rev 2.0)', 4038600, '1000W, PCIe Gen 5.0 (12VHPWR), 80 PLUS Gold', 'corsair_3500x_black.png', 11, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (206, 'Gigabyte AORUS C500 GLASS', 4546600, 'Mid Tower, 4mm Tempered Glass, Up to 420mm front', 'corsair_3500x_black.png', 12, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (229, 'Samsung 990 PRO PCIe 4.0 NVMe M.2 SSD 2TB', 4546600, '2TB, Up to 7450 MB/s, Up to 6900 MB/s, Samsung Pascal Controller', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (185, 'AMD Radeon RX 7800 XT GPU', 12674600, '16GB GDDR6, 64MB, 263W', 'asus_rog_rtx_4090.jpg', 2, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (187, 'ASUS ROG Maximus Z790 Dark Hero', 17754600, 'LGA1700, Intel Z790, 4x DDR5 (Up to 192GB), ATX', 'z790_dark_kingpin.jpg', 4, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (191, 'ASUS ROG Ryujin III 360 ARGB', 8864600, '360mm, Asetek 8th Gen, 3.5-inch Full Color', 'rog_ryujin_360.jpg', 13, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (148, '870 QVO 4TB', 8500000, 'Massive SATA', 'corsair_3500x_black.png', 5, 31, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (174, 'Dell E2222H', 2200000, 'Office 22"', 'corsair_3500x_black.png', 6, 150, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (230, 'Samsung 990 EVO PCIe 4.0 x4 / 5.0 x2 M.2 SSD 1TB', 2260600, '1TB, Up to 5000 MB/s, Up to 4200 MB/s', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (207, 'Corsair Dominator Titanium RGB DDR5 32GB (2x16GB)6000MHz', 4673600, '32GB, 6000 MT/s, CL30, Intel XMP 3.0 / AMD EXPO', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (194, 'MSI MAG B650 TOMAHAWK WIFI', 5562600, 'AM5, AMD B650, DDR5 7600+(OC), Realtek 2.5Gbps LA', 'z790_dark_kingpin.jpg', 4, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (197, 'MSI MEG MAESTRO 700L PZ', 10642600, 'ATX Full Tower, Curved Tempered Glass, Back-connect (Project Zero) support', 'corsair_3500x_black.png', 12, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (201, 'Gigabyte X670E AORUS MASTER', 11404600, 'AM5, AMD X670E, 4x M.2 PCIe 5.0, Intel 2.5GbE LA', 'z790_dark_kingpin.jpg', 4, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (204, 'Gigabyte AORUS Gen5 12000 SSD 2TB', 8102600, 'PCIe 5.0 x4, NVMe 2.0, 12,400 MB/s, 11,800 MB/s', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (208, 'Corsair Vengeance RGB DDR5 64GB (2x32GB)5600MHz', 5562600, '64GB, 5600 MT/s, CL40', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (211, 'Corsair iCUE LINK 6500X RGB Mid-Tower DualChamber', 5054600, 'Dual Chamber Layout, Reverse-connector support, Front & Side Tempered Glass', 'corsair_rm850e.jpg', 12, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (214, 'Corsair K100 RGB Mechanical Gaming Keyboard', 6324600, 'Corsair OPX Optical-Mechanical, AXON 4000Hz Hyper-polling, iCUE Control Wheel', 'corsair_rm850e.jpg', 15, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (218, 'Logitech G502 X LIGHTSPEED Wireless GamingMouse', 3530600, 'HERO 25K Sensor, 13 programmable controls, Dual-mode infinite scroll', 'corsair_3500x_black.png', 16, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (222, 'Logitech MX Master 3S Wireless Mouse', 2514600, '8K DPI tracking on any surface, Quiet clicks technology, MagSpeed Electromagnetic scrolling', 'corsair_3500x_black.png', 16, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (226, 'Razer Huntsman V3 Pro TKL Mechanical Keyboard', 5562600, 'Razer Analog Optical Switches Gen-2, Rapid Trigger mode with adjustable actuation (0.1- 4.0mm), Dual-purpose digital dial', 'corsair_3500x_black.png', 15, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (231, 'Samsung T7 Shield Portable SSD 2TB', 4292600, '2TB, USB 3.2 Gen 2 (10Gbps), IP65 water & dust resistant, 3-meter drop proof', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (234, 'Samsung Galaxy Buds3 Pro', 6324600, 'Hi-Fi 24-BOOLEAN Ultra High Quality Audio, Adaptive Noise Cancelling with Blade Lights, Stem style ergonomic fit', 'sabrent_rocket_4tb.jpg', 17, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (239, 'Kingston FURY Impact DDR5 SO-DIMM 32GB (2x16GB) 5600MHz', 3149600, 'Laptop Memory (SO-DIMM), 32GB Kit, 5600 MT/s', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (242, 'Noctua NH-D15 chromax.black Dual-Tower Cooler', 3022600, '2x NF-A15 HS-PWM fans, Full black design, Intel LGA1700/AM5 ready', 'rog_ryujin_360.jpg', 13, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (245, 'SteelSeries Arctis Nova Pro Wireless Headset', 8864600, 'Nova Pro Acoustic System, Active Noise Cancellation with Transparency Mode, Dual Battery Infinity System', 'corsair_3500x_black.png', 17, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (248, 'Crucial Pro DDR5 48GB (2x24GB) 5600MHz Kit', 3784600, '48GB Kit, 5600 MT/s, Low-profile aluminum black heatsink', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (249, 'Fractal Design North Charcoal Black WoodMid-Tower', 3530600, 'Real walnut wood front panel struts, Mesh or Tempered Glass available, 2x Aspect 14 PWM fans', 'corsair_3500x_black.png', 12, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (250, 'Lian Li O11 Dynamic EVO RGB Black', 4292600, 'Dual-chamber adjustable ATX case, Two L-shaped diffuse LED RGB strips, Reversible design architecture', 'corsair_3500x_black.png', 12, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (252, 'EVGA SuperNOVA 1000 G7 Gold Modular PSU', 4800600, '1000W, 80 PLUS Gold Certified, Ultra-compact 130mm chassis size', 'asus_rog_rtx_4090.jpg', 11, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (253, 'DeepCool AK620 Digital Dual-Tower Air Cooler', 2006600, 'Real-time temperature and usage status top screen, 2x FK120 fluid dynamic bearing fans, 6x 6mm copper heatpipes', 'rog_ryujin_360.jpg', 13, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (254, 'Thermalright Peerless Assassin 120 SE AirCooler', 990600, 'Dual tower heatsink design, 2x TL-C12C 120mm PWM fans, 155mm standard height', 'rog_ryujin_360.jpg', 13, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (182, 'Intel Arc A750 Graphics Card', 6324600, '8GB GDDR6, 256-BOOLEAN, 2050 MHz, 225W', 'asus_rog_rtx_4090.jpg', 2, 49, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (247, 'Sony WH-1000XM5 Wireless Noise CancelingHeadphones', 10134600, 'Integrated Processor V1 & HD Noise CancelingProcessor QN1, 8 microphones for extreme voice pick up, Up to 30 hours total life', 'corsair_3500x_black.png', 17, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (251, 'Lian Li UNI FAN TL LCD 120 Triple Pack Black', 3784600, '120mm fans, Built-in 1.6-inch LCD screen on center fan, Daisy-chain interlocking mechanism', 'rog_ryujin_360.jpg', 14, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (255, 'Be Quiet! Dark Power 13 1000W Titanium ATX 3.0PSU', 7340600, '1000W, 80 PLUS Titanium (up to 95.8%), Frameless Silent Wings fan optimization', 'corsair_rm850e.jpg', 11, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (7, 'Intel Core i9-13900KS', 18500000, 'Special Edition, 6.0GHz', 'i9_14900k.jpg', 1, 0, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (12, 'AMD Ryzen 5 5600G', 3200000, 'Integrated Vega Graphics', 'i9_14900k.jpg', 1, 71, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (23, 'Intel Core i9-11900K', 6500000, 'Legacy Flagship LGA 1200', 'i9_14900k.jpg', 1, 9, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (54, 'Quadro RTX A4000', 22000000, 'Workstation GPU', 'asus_rog_rtx_4090.jpg', 2, 0, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (89, 'Galax HOF 32GB', 5500000, '8000MHz White OC', 'galax_hof_32gb.jpg', 3, 3, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (287, 'Thẻ nhớ SanDisk Extreme Pro 128GB MicroSDXC UHS-I 200MB/s', 650000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 100, '2026-07-23 10:00:00.000', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (288, 'Thẻ nhớ Samsung PRO Plus 256GB MicroSDXC kèm Đầu đọc USB', 950000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 80, '2026-07-23 10:00:00.000', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (289, 'Thẻ nhớ Lexar Professional 1066x 512GB MicroSDXC UHS-I', 1450000, 'TDP: 3W', 'sabrent_rocket_4tb.jpg', 4, 50, '2026-07-23 10:00:00.000', 'Lexar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (290, 'Thẻ nhớ Kingston Canvas Go! Plus 128GB SDXC UHS-I', 580000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 120, '2026-07-23 10:00:00.000', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (291, 'Thẻ nhớ SanDisk Ultra SDXC 64GB 140MB/s Class 10', 280000, 'TDP: 1W', 'sabrent_rocket_4tb.jpg', 4, 150, '2026-07-23 10:00:00.000', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (292, 'Thẻ nhớ Transcend SDXC 330S 128GB High Speed 100MB/s', 520000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 90, '2026-07-23 10:00:00.000', 'Transcend');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (293, 'Thẻ nhớ ProGrade Digital SDXC UHS-II V60 256GB', 2800000, 'TDP: 3W', 'sabrent_rocket_4tb.jpg', 4, 30, '2026-07-23 10:00:00.000', 'ProGrade');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (294, 'Thẻ nhớ Sony TOUGH SF-G Series 128GB SDXC UHS-II 300MB/s', 4200000, 'TDP: 3W', 'sabrent_rocket_4tb.jpg', 4, 25, '2026-07-23 10:00:00.000', 'Sony');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (295, 'Thẻ nhớ Kioxia Exceria High Endurance 128GB MicroSD', 480000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 110, '2026-07-23 10:00:00.000', 'Kioxia');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (296, 'Thẻ nhớ TeamGroup GO Card MicroSDXC 256GB 100MB/s', 720000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 75, '2026-07-23 10:00:00.000', 'TeamGroup');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (297, 'Ổ cứng di động SSD SanDisk Extreme Portable 1TB USB 3.2 Gen 2', 2650000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 60, '2026-07-23 10:00:00.000', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (298, 'Ổ cứng di động Samsung T7 Shield 2TB Type-C Chống sốc IP65', 4850000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 45, '2026-07-23 10:00:00.000', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (299, 'Ổ cứng di động HDD WD My Passport 2TB USB 3.0 Black', 1950000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 80, '2026-07-23 10:00:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (300, 'Ổ cứng di động SSD Crucial X9 Pro 1TB 1050MB/s Vỏ nhôm', 2450000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 8, 50, '2026-07-23 10:00:00.000', 'Crucial');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (301, 'Ổ cứng gắn ngoài HDD Seagate Expansion Desktop 8TB 3.5 inch', 4900000, 'TDP: 10W', 'sabrent_rocket_4tb.jpg', 8, 30, '2026-07-23 10:00:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (302, 'Ổ cứng di động HDD Lacie Rugged Mini 2TB USB 3.0 Chống dằn xóc', 2800000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 40, '2026-07-23 10:00:00.000', 'LaCie');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (303, 'Ổ cứng di động SSD Kingston XS2000 1TB Type-C 2000MB/s Siêu nhỏ', 2950000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 35, '2026-07-23 10:00:00.000', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (304, 'Ổ cứng di động HDD Transcend StoreJet 25M3 1TB Chống sốc 3 lớp', 1650000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 70, '2026-07-23 10:00:00.000', 'Transcend');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (305, 'Ổ cứng di động SSD Corsair EX100U 2TB Type-C USB 3.2 Gen2x2', 4200000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 25, '2026-07-23 10:00:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (306, 'Ổ cứng di động SSD ADATA SE880 1TB Type-C 2000MB/s', 2550000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 8, 55, '2026-07-23 10:00:00.000', 'ADATA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (307, 'Tản nhiệt nước AIO NZXT Kraken Elite 360 RGB White LCD', 7250000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 30, '2026-07-23 10:00:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (308, 'Tản nhiệt nước AIO Corsair iCUE LINK H150i LCD White 360mm', 6800000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 25, '2026-07-23 10:00:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (309, 'Tản nhiệt nước AIO ASUS ROG Ryujin III 360 ARGB White Edition', 8900000, 'TDP: 20W', 'rog_ryujin_360.jpg', 9, 20, '2026-07-23 10:00:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (310, 'Tản nhiệt nước AIO MSI MAG CORELIQUID E360 Black', 3450000, 'TDP: 12W', 'rog_ryujin_360.jpg', 9, 50, '2026-07-23 10:00:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (311, 'Tản nhiệt nước AIO DeepCool LT720 360mm High-Performance', 3650000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 40, '2026-07-23 10:00:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (312, 'Tản nhiệt nước AIO Lian Li Galahad II Trinity SL-INF 360 White', 4950000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 35, '2026-07-23 10:00:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (313, 'Tản nhiệt nước AIO Cooler Master MasterLiquid 360 Atmos ARGB', 3850000, 'TDP: 12W', 'rog_ryujin_360.jpg', 9, 45, '2026-07-23 10:00:00.000', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (314, 'Tản nhiệt nước AIO Thermalright Frozen Prism 360 ARGB Black', 1850000, 'TDP: 10W', 'rog_ryujin_360.jpg', 9, 70, '2026-07-23 10:00:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (315, 'Tản nhiệt nước AIO Valkyrie GL360 ARGB Màn hình LCD Black', 4200000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 30, '2026-07-23 10:00:00.000', 'Valkyrie');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (316, 'Tản nhiệt nước AIO ID-COOLING DASHFLOW 360 Basic Black', 1650000, 'TDP: 10W', 'rog_ryujin_360.jpg', 9, 80, '2026-07-23 10:00:00.000', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (317, 'Card màn hình GIGABYTE GeForce RTX 4070 Ti SUPER WINDFORCE OC 16G', 23900000, 'TDP: 285W', 'asus_rog_rtx_4090.jpg', 10, 25, '2026-07-23 10:00:00.000', 'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (318, 'Card màn hình ASUS TUF Gaming GeForce RTX 4080 SUPER 16GB GDDR6X', 31500000, 'TDP: 320W', 'asus_rog_rtx_4090.jpg', 10, 20, '2026-07-23 10:00:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (319, 'Card màn hình MSI GeForce RTX 4060 Ti GAMING X SLIM 16G', 12800000, 'TDP: 165W', 'asus_rog_rtx_4090.jpg', 10, 40, '2026-07-23 10:00:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (320, 'Card màn hình ZOTAC GAMING GeForce RTX 4070 SUPER Twin Edge OC 12GB', 16900000, 'TDP: 220W', 'asus_rog_rtx_4090.jpg', 10, 35, '2026-07-23 10:00:00.000', 'ZOTAC');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (321, 'Card màn hình GALAX GeForce RTX 4070 Ti SUPER EX Gamer White 16GB', 24500000, 'TDP: 285W', 'asus_rog_rtx_4090.jpg', 10, 18, '2026-07-23 10:00:00.000', 'GALAX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (322, 'Card màn hình PowerColor Hellhound AMD Radeon RX 7900 XT 20GB', 21500000, 'TDP: 315W', 'asus_rog_rtx_4090.jpg', 10, 15, '2026-07-23 10:00:00.000', 'PowerColor');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (323, 'Card màn hình Sapphire NITRO+ AMD Radeon RX 7800 XT 16GB', 15800000, 'TDP: 263W', 'asus_rog_rtx_4090.jpg', 10, 30, '2026-07-23 10:00:00.000', 'Sapphire');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (324, 'Card màn hình XFX Speedster MERC 310 AMD Radeon RX 7900 GRE 16GB', 16950000, 'TDP: 260W', 'asus_rog_rtx_4090.jpg', 10, 22, '2026-07-23 10:00:00.000', 'XFX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (325, 'Card màn hình COLORFUL iGame GeForce RTX 4070 SUPER Ultra W OC 12GB', 17900000, 'TDP: 220W', 'asus_rog_rtx_4090.jpg', 10, 28, '2026-07-23 10:00:00.000', 'COLORFUL');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (326, 'Card màn hình ASRock Phantom Gaming Radeon RX 7700 XT 12GB OC', 12500000, 'TDP: 245W', 'asus_rog_rtx_4090.jpg', 10, 30, '2026-07-23 10:00:00.000', 'ASRock');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (327, 'Ổ cứng HDD PC Seagate Barracuda 2TB 3.5 inch SATA3 7200rpm', 1550000, 'TDP: 6W', 'sabrent_rocket_4tb.jpg', 11, 100, '2026-07-23 10:00:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (328, 'Ổ cứng HDD PC Western Digital Blue 2TB 3.5 inch 7200rpm', 1480000, 'TDP: 6W', 'sabrent_rocket_4tb.jpg', 11, 110, '2026-07-23 10:00:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (329, 'Ổ cứng HDD PC Toshiba P300 2TB 3.5 inch SATA3 7200rpm', 1390000, 'TDP: 6W', 'sabrent_rocket_4tb.jpg', 11, 90, '2026-07-23 10:00:00.000', 'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (330, 'Ổ cứng HDD Server Seagate IronWolf 4TB 3.5 inch NAS SATA3', 2950000, 'TDP: 7W', 'sabrent_rocket_4tb.jpg', 11, 60, '2026-07-23 10:00:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (331, 'Ổ cứng HDD Server Western Digital Red Plus 4TB 3.5 inch NAS', 3100000, 'TDP: 7W', 'sabrent_rocket_4tb.jpg', 11, 55, '2026-07-23 10:00:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (332, 'Ổ cứng HDD Enterprise Seagate Exos X18 16TB 3.5 inch SATA3', 8500000, 'TDP: 9W', 'sabrent_rocket_4tb.jpg', 11, 20, '2026-07-23 10:00:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (333, 'Ổ cứng HDD Enterprise Western Digital Gold 8TB 3.5 inch 7200rpm', 5900000, 'TDP: 8W', 'sabrent_rocket_4tb.jpg', 11, 30, '2026-07-23 10:00:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (334, 'Ổ cứng HDD PC Toshiba X300 4TB 7200rpm Gaming Internal', 3250000, 'TDP: 8W', 'sabrent_rocket_4tb.jpg', 11, 40, '2026-07-23 10:00:00.000', 'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (335, 'Ổ cứng HDD PC Western Digital Black 1TB 3.5 inch Performance', 1850000, 'TDP: 7W', 'sabrent_rocket_4tb.jpg', 11, 75, '2026-07-23 10:00:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (336, 'Ổ cứng HDD Camera Seagate SkyHawk 4TB 3.5 inch Surveillance', 2650000, 'TDP: 6W', 'sabrent_rocket_4tb.jpg', 11, 80, '2026-07-23 10:00:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (337, 'Nguồn Corsair RM750e ATX 3.0 80 Plus Gold Full Modular (750W)', 2850000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 60, '2026-07-23 10:00:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (338, 'Nguồn MSI MAG A750GL PCIE5 750W 80 Plus Gold Full Modular', 2650000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 70, '2026-07-23 10:00:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (339, 'Nguồn GIGABYTE UD850GM PG5 850W 80 Plus Gold PCIe 5.0', 3100000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 50, '2026-07-23 10:00:00.000', 'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (340, 'Nguồn ASUS TUF Gaming 750W 80 Plus Bronze', 2150000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 80, '2026-07-23 10:00:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (341, 'Nguồn Cooler Master MWE Gold 850 V2 Full Modular (850W)', 2950000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 65, '2026-07-23 10:00:00.000', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (342, 'Nguồn DeepCool PL750D 750W 80 Plus Bronze ATX 3.0 Native', 1750000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 90, '2026-07-23 10:00:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (343, 'Nguồn Super Flower Leadex III Gold 850W ARGB Full Modular', 3450000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 40, '2026-07-23 10:00:00.000', 'Super Flower');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (344, 'Nguồn Seasonic Focus GX-850 850W 80 Plus Gold Full Modular', 3650000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 45, '2026-07-23 10:00:00.000', 'Seasonic');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (345, 'Nguồn FSP Hydro G PRO 850W PCIe5.0 80 Plus Gold', 3350000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 50, '2026-07-23 10:00:00.000', 'FSP');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (346, 'Nguồn Thermaltake Toughpower GF A3 850W Gold ATX 3.0', 2950000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 55, '2026-07-23 10:00:00.000', 'Thermaltake');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (347, 'Vỏ case NZXT H6 Flow RGB Dual-Chamber Mid-Tower Black', 3450000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 40, '2026-07-23 10:00:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (348, 'Vỏ case Lian Li O11 Vision Tempered Glass Mid-Tower White', 3950000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 35, '2026-07-23 10:00:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (349, 'Vỏ case Corsair 4000D AIRFLOW Tempered Glass Mid-Tower Black', 2150000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 80, '2026-07-23 10:00:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (350, 'Vỏ case Montech KING 95 PRO Panoramic Curved Glass ARGB Black', 3650000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 30, '2026-07-23 10:00:00.000', 'Montech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (351, 'Vỏ case HYTE Y60 Panoramic Dual Chamber Glass Black/Red', 5450000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 20, '2026-07-23 10:00:00.000', 'HYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (352, 'Vỏ case Antec C8 Dual-Chamber Full Tower Black', 2850000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 45, '2026-07-23 10:00:00.000', 'Antec');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (353, 'Vỏ case Fractal Design Pop Air RGB TG Black', 2450000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 50, '2026-07-23 10:00:00.000', 'Fractal Design');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (354, 'Vỏ case DeepCool CH560 DIGITAL ARGB Màn hình nhiệt độ Black', 2650000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 60, '2026-07-23 10:00:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (355, 'Vỏ case Xigmatek ENDORPHIN ULTRA ARTIC White Panoramic', 1450000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 90, '2026-07-23 10:00:00.000', 'Xigmatek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (356, 'Vỏ case Phanteks NV5 Mid-Tower ARGB Black Glass', 2750000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 40, '2026-07-23 10:00:00.000', 'Phanteks');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (357, 'Tản nhiệt khí Thermalright Peerless Assassin 120 SE ARGB', 980000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 100, '2026-07-23 10:00:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (358, 'Tản nhiệt khí DeepCool AK400 Digital ARGB Màn hình LED Black', 1150000, 'TDP: 4W', 'rog_ryujin_360.jpg', 14, 80, '2026-07-23 10:00:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (359, 'Tản nhiệt khí Noctua NH-D15 chromax.black Dual-Tower Premium', 2950000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 35, '2026-07-23 10:00:00.000', 'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (360, 'Tản nhiệt khí ID-COOLING SE-224-XT ARGB V2 Black', 520000, 'TDP: 3W', 'rog_ryujin_360.jpg', 14, 120, '2026-07-23 10:00:00.000', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (361, 'Tản nhiệt khí Cooler Master Hyper 622 Halo Black ARGB Dual-Tower', 1350000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 60, '2026-07-23 10:00:00.000', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (362, 'Tản nhiệt khí Jonsbo CR-1000 EVO ARGB Black', 380000, 'TDP: 3W', 'rog_ryujin_360.jpg', 14, 150, '2026-07-23 10:00:00.000', 'Jonsbo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (363, 'Tản nhiệt khí Thermalright Phantom Spirit 120 EVO 7 Heatpipes', 1280000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 75, '2026-07-23 10:00:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (364, 'Tản nhiệt khí Be Quiet! Dark Rock Pro 5 Dual Tower', 2450000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 40, '2026-07-23 10:00:00.000', 'Be Quiet!');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (365, 'Tản nhiệt khí PCCOOLER K6 Digital Display ARGB Dual Tower', 1050000, 'TDP: 4W', 'rog_ryujin_360.jpg', 14, 65, '2026-07-23 10:00:00.000', 'PCCOOLER');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (366, 'Tản nhiệt khí Valkyrie SL125 ARGB Màn hiển thị nhiệt độ', 950000, 'TDP: 4W', 'rog_ryujin_360.jpg', 14, 70, '2026-07-23 10:00:00.000', 'Valkyrie');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (367, 'Bộ 3 Fan tản nhiệt Lian Li UNI FAN SL-Infinity 120 ARGB Triple Black', 2450000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 50, '2026-07-23 10:00:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (368, 'Bộ 3 Fan tản nhiệt Corsair iCUE LINK QX120 RGB Starter Kit White', 3650000, 'TDP: 4W', 'rog_ryujin_360.jpg', 15, 40, '2026-07-23 10:00:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (369, 'Bộ 3 Fan tản nhiệt NZXT Duo F120 RGB Triple Pack Black', 2150000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 60, '2026-07-23 10:00:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (370, 'Bộ 3 Fan tản nhiệt Thermalright TL-C12C-S ARGB Triple Pack Black', 480000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 120, '2026-07-23 10:00:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (371, 'Bộ 3 Fan tản nhiệt DeepCool FC120 3-in-1 ARGB Black', 850000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 80, '2026-07-23 10:00:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (372, 'Bộ 3 Fan tản nhiệt Phanteks D30-120 Reverse Airflow Triple Black', 2250000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 45, '2026-07-23 10:00:00.000', 'Phanteks');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (373, 'Bộ 3 Fan tản nhiệt ID-COOLING XF-12025 ARGB Trio Pack', 550000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 100, '2026-07-23 10:00:00.000', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (374, 'Bộ 3 Fan tản nhiệt Cooler Master MasterFan MF120 Halo2 ARGB White', 1350000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 70, '2026-07-23 10:00:00.000', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (375, 'Bộ 3 Fan tản nhiệt Antec Fusion 120 ARGB Triple Pack', 780000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 90, '2026-07-23 10:00:00.000', 'Antec');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (376, 'Bộ 3 Fan tản nhiệt Montech AX120 PWM ARGB Pack White', 650000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 95, '2026-07-23 10:00:00.000', 'Montech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (377, 'Bàn phím cơ AKKO 3087 v2 Silent Bluetooth 5.0 / Wireless 2.4G', 1450000, 'TDP: 1W', 'corsair_3500x_black.png', 16, 60, '2026-07-23 10:00:00.000', 'AKKO');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (378, 'Bàn phím cơ Keychron V1 Max Wireless Custom Mechanical Keyboard Hotswap', 2250000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 50, '2026-07-23 10:00:00.000', 'Keychron');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (379, 'Bàn phím cơ Royal Kludge RK84 RGB Wireless 80% Layout Hotswap', 980000, 'TDP: 1W', 'corsair_3500x_black.png', 16, 90, '2026-07-23 10:00:00.000', 'Royal Kludge');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (380, 'Bàn phím cơ FL-Esports FL980 SAM Tropical Secret Wireless', 2450000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 40, '2026-07-23 10:00:00.000', 'FL-Esports');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (381, 'Bàn phím cơ MonsGeek M1W V3 Fully Assembled Aluminum Wireless', 2150000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 45, '2026-07-23 10:00:00.000', 'MonsGeek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (382, 'Bàn phím cơ EPOMAKER RT100 Retro Mechanical Keyboard Màn hình Smart', 2650000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 35, '2026-07-23 10:00:00.000', 'EPOMAKER');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (383, 'Bàn phím cơ Ducky One 3 Daybreak Hotswap RGB Mech Keyboard', 2850000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 30, '2026-07-23 10:00:00.000', 'Ducky');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (384, 'Bàn phím cơ Varmilo VEA87 Vintage Mechanical Keyboard Cherry MX', 3150000, 'TDP: 1W', 'corsair_3500x_black.png', 16, 25, '2026-07-23 10:00:00.000', 'Varmilo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (385, 'Bàn phím cơ NuPhy Air75 V2 Low-Profile Wireless Keyboard', 2950000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 40, '2026-07-23 10:00:00.000', 'NuPhy');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (386, 'Bàn phím cơ Custom Womier K66 Gateron Switch RGB Acrylic Glass', 1250000, 'TDP: 1W', 'corsair_3500x_black.png', 16, 70, '2026-07-23 10:00:00.000', 'Womier');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (387, 'Chuột máy tính Razer Basilisk V3 Ergonomic Gaming Mouse 26k DPI', 1450000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 80, '2026-07-23 10:00:00.000', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (388, 'Chuột máy tính Logitech G304 LIGHTSPEED Wireless Black 12k DPI', 820000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 150, '2026-07-23 10:00:00.000', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (389, 'Chuột máy tính Pulsar X2 V2 Wireless Gaming Mouse Superlight 53g', 2150000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 45, '2026-07-23 10:00:00.000', 'Pulsar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (390, 'Chuột máy tính Ninjutso Sora V2 Ultra Lightweight Wireless 39g', 2450000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 40, '2026-07-23 10:00:00.000', 'Ninjutso');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (391, 'Chuột máy tính LAMZU Atlantis OG V2 Wireless Gaming Mouse 55g', 2250000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 50, '2026-07-23 10:00:00.000', 'LAMZU');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (392, 'Chuột máy tính Endgame Gear OP1WE Wireless Gaming Mouse 58g', 1950000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 60, '2026-07-23 10:00:00.000', 'Endgame Gear');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (393, 'Chuột máy tính VGN Dragonfly F1 PRO MAX Wireless Nordic MCU', 1150000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 90, '2026-07-23 10:00:00.000', 'VG');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (394, N'Chuột máy tính VXE R1 PRO MAX Ultra Light Wireless PAW3395', 980000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 110, '2026-07-23 10:00:00.000', 'VXE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (395, 'Chuột máy tính SteelSeries Rival 3 Wireless Gaming Mouse 18k DPI', 950000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 100, '2026-07-23 10:00:00.000', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (396, 'Chuột máy tính ASUS ROG Harpe Ace Aim Lab Edition 54g Wireless', 2850000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 35, '2026-07-23 10:00:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (397, 'Tai nghe gaming HyperX Cloud II Wireless Red/Black Spatial Audio', 2950000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 60, '2026-07-23 10:00:00.000', 'HyperX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (398, 'Tai nghe gaming Razer BlackShark V2 X 7.1 Surround Sound Black', 1250000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 100, '2026-07-23 10:00:00.000', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (399, 'Tai nghe gaming Corsair HS80 RGB Wireless Spatial Audio White', 3450000, 'TDP: 2W', 'corsair_3500x_black.png', 18, 45, '2026-07-23 10:00:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (400, 'Tai nghe gaming Logitech G435 LIGHTSPEED Ultra-Light Wireless Blue', 1450000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 90, '2026-07-23 10:00:00.000', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (401, 'Tai nghe gaming SteelSeries Arctis Nova 7 Wireless Multi-Platform', 4250000, 'TDP: 2W', 'corsair_3500x_black.png', 18, 35, '2026-07-23 10:00:00.000', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (402, 'Tai nghe gaming EPOS Sennheiser GSP 300 Closed Acoustic Black/Blue', 1850000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 50, '2026-07-23 10:00:00.000', 'EPOS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (403, 'Tai nghe gaming Audio-Technica ATH-GDL3 Open-Back Gaming Headset', 3250000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 30, '2026-07-23 10:00:00.000', 'Audio-Technica');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (404, 'Tai nghe gaming JBL Quantum 400 USB Wired Gaming Headset QuantumSURROUND', 1950000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 70, '2026-07-23 10:00:00.000', 'JBL');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (405, 'Tai nghe gaming ASUS ROG Delta S Wireless Gaming Headset Type-C', 4650000, 'TDP: 2W', 'corsair_3500x_black.png', 18, 25, '2026-07-23 10:00:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (406, 'Tai nghe gaming EKSA E900 Pro 7.1 Surround Sound Wired Dual Audio', 750000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 120, '2026-07-23 10:00:00.000', 'EKSA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (407, 'Thẻ nhớ MicroSD Sandisk Ultra 32GB Class 10 120MB/s', 120000, 'TDP: 1W', 'sabrent_rocket_4tb.jpg', 4, 150, '2026-07-23 11:35:00.000', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (408, 'Thẻ nhớ MicroSD Sandisk High Endurance 64GB Chuyên ghi Dashcam', 290000, 'TDP: 1W', 'sabrent_rocket_4tb.jpg', 4, 100, '2026-07-23 11:35:00.000', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (409, 'Thẻ nhớ SDXC SanDisk Extreme PRO 64GB UHS-I 200MB/s', 450000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 120, '2026-07-23 11:35:00.000', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (410, 'Thẻ nhớ MicroSD Samsung EVO Plus 64GB kèm Adapter', 210000, 'TDP: 1W', 'sabrent_rocket_4tb.jpg', 4, 180, '2026-07-23 11:35:00.000', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (411, 'Thẻ nhớ MicroSD Samsung EVO Plus 128GB UHS-I U3', 350000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 140, '2026-07-23 11:35:00.000', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (412, 'Thẻ nhớ MicroSD Kingston Canvas Select Plus 64GB', 150000, 'TDP: 1W', 'sabrent_rocket_4tb.jpg', 4, 200, '2026-07-23 11:35:00.000', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (413, 'Thẻ nhớ MicroSD Kingston Canvas Select Plus 256GB', 520000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 90, '2026-07-23 11:35:00.000', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (414, 'Thẻ nhớ SDXC Lexar Professional 1667x 128GB SDXC UHS-II 250MB/s', 1150000, 'TDP: 3W', 'sabrent_rocket_4tb.jpg', 4, 60, '2026-07-23 11:35:00.000', 'Lexar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (415, 'Thẻ nhớ MicroSD Lexar Play 256GB UHS-I cho Nintendo Switch', 680000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 80, '2026-07-23 11:35:00.000', 'Lexar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (416, 'Thẻ nhớ SDXC Sony SF-E Series 64GB UHS-II 270MB/s', 850000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 50, '2026-07-23 11:35:00.000', 'Sony');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (417, 'Thẻ nhớ SDXC Sony TOUGH M Series 128GB UHS-II 270MB/s', 2100000, 'TDP: 3W', 'sabrent_rocket_4tb.jpg', 4, 35, '2026-07-23 11:35:00.000', 'Sony');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (418, 'Thẻ nhớ MicroSD Kioxia Exceria G2 256GB NVMe Class', 620000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 75, '2026-07-23 11:35:00.000', 'Kioxia');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (419, 'Thẻ nhớ SDXC Transcend 700S 64GB SDXC UHS-II V90 285MB/s', 1850000, 'TDP: 3W', 'sabrent_rocket_4tb.jpg', 4, 40, '2026-07-23 11:35:00.000', 'Transcend');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (420, 'Thẻ nhớ MicroSD TeamGroup PRO Endurance 128GB', 390000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 85, '2026-07-23 11:35:00.000', 'TeamGroup');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (421, 'Thẻ nhớ SDXC ProGrade Digital SDXC UHS-II V90 Cobalt 128GB', 3950000, 'TDP: 3W', 'sabrent_rocket_4tb.jpg', 4, 20, '2026-07-23 11:35:00.000', 'ProGrade');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (422, 'Ổ cứng di động SSD WD My Passport SSD 1TB USB 3.2 Red', 2450000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 8, 60, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (423, 'Ổ cứng di động SSD WD Black P50 Game Drive 1TB NVMe 2000MB/s', 3850000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 40, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (424, 'Ổ cứng di động HDD WD Elements Portable 1TB 2.5 inch USB 3.0', 1390000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 100, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (425, 'Ổ cứng di động HDD WD Elements Portable 4TB 2.5 inch USB 3.0', 3150000, 'TDP: 6W', 'sabrent_rocket_4tb.jpg', 8, 50, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (426, 'Ổ cứng di động SSD Samsung T7 Portable 1TB USB 3.2 Titan Gray', 2550000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 8, 70, '2026-07-23 11:35:00.000', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (427, 'Ổ cứng di động SSD Samsung T9 Portable 2TB USB 3.2 Gen 2x2 2000MB/s', 5450000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 30, '2026-07-23 11:35:00.000', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (428, 'Ổ cứng di động SSD SanDisk Extreme PRO Portable 2TB USB 3.2 Gen 2x2', 5150000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 35, '2026-07-23 11:35:00.000', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (429, 'Ổ cứng di động HDD Seagate One Touch 2TB 2.5 inch USB 3.0 Black', 2050000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 80, '2026-07-23 11:35:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (430, 'Ổ cứng di động HDD Seagate Basic 1TB 2.5 inch USB 3.0', 1290000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 110, '2026-07-23 11:35:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (431, 'Ổ cứng di động SSD Crucial X6 Portable SSD 2TB 800MB/s', 3450000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 8, 45, '2026-07-23 11:35:00.000', 'Crucial');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (432, 'Ổ cứng di động SSD Crucial X10 Pro 2TB USB 3.2 Gen 2x2 2100MB/s', 5850000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 25, '2026-07-23 11:35:00.000', 'Crucial');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (433, 'Ổ cứng di động SSD Kingston XS1000 2TB External SSD Type-C Red', 3650000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 8, 55, '2026-07-23 11:35:00.000', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (434, 'Tản nhiệt nước AIO Corsair H100i RGB ELITE 240mm', 3250000, 'TDP: 12W', 'rog_ryujin_360.jpg', 9, 50, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (435, 'Tản nhiệt nước AIO Corsair iCUE LINK H100i RGB White 240mm', 4850000, 'TDP: 12W', 'rog_ryujin_360.jpg', 9, 35, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (436, 'Tản nhiệt nước AIO NZXT Kraken 240 RGB Black LCD', 4250000, 'TDP: 12W', 'rog_ryujin_360.jpg', 9, 40, '2026-07-23 11:35:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (437, 'Tản nhiệt nước AIO NZXT Kraken 360 RGB Black LCD', 5350000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 30, '2026-07-23 11:35:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (438, 'Tản nhiệt nước AIO ASUS ROG Strix LC III 360 ARGB', 4950000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 25, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (439, 'Tản nhiệt nước AIO ASUS TUF Gaming LC II 360 ARGB', 2950000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 45, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (440, 'Tản nhiệt nước AIO DeepCool LS720 SE 360mm ARGB Black', 2650000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 60, '2026-07-23 11:35:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (441, 'Tản nhiệt nước AIO DeepCool MYSTIQUE 360 Màn hình LCD 3.4 inch', 4150000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 30, '2026-07-23 11:35:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (442, 'Tản nhiệt nước AIO Thermalright Frozen Warframe 360 ARGB Màn LCD', 2750000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 40, '2026-07-23 11:35:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (443, 'Tản nhiệt nước AIO Lian Li Galahad II LCD 360 SL-INF Black', 6450000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 20, '2026-07-23 11:35:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (444, 'Tản nhiệt nước AIO MSI MAG CORELIQUID 240R V2', 2250000, 'TDP: 12W', 'rog_ryujin_360.jpg', 9, 55, '2026-07-23 11:35:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (445, 'Tản nhiệt nước AIO ID-COOLING FROSTFLOW X 240 Snow Edition White', 1150000, 'TDP: 10W', 'rog_ryujin_360.jpg', 9, 80, '2026-07-23 11:35:00.000', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (446, 'Card màn hình ASUS ROG Strix GeForce RTX 4090 OC Edition 24GB GDDR6X', 54900000, 'TDP: 450W', 'asus_rog_rtx_4090.jpg', 10, 10, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (447, 'Card màn hình MSI GeForce RTX 4080 SUPER 16G GAMING X TRIO', 33500000, 'TDP: 320W', 'asus_rog_rtx_4090.jpg', 10, 15, '2026-07-23 11:35:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (448, 'Card màn hình GIGABYTE GeForce RTX 4060 EAGLE OC 8G', 8450000, 'TDP: 115W', 'asus_rog_rtx_4090.jpg', 10, 60, '2026-07-23 11:35:00.000', 'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (449, 'Card màn hình GIGABYTE GeForce RTX 3050 WINDFORCE OC 6G', 4650000, 'TDP: 70W', 'asus_rog_rtx_4090.jpg', 10, 80, '2026-07-23 11:35:00.000', 'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (450, 'Card màn hình ASUS Dual GeForce RTX 4060 Ti EVO OC Edition 8GB', 11250000, 'TDP: 160W', 'asus_rog_rtx_4090.jpg', 10, 45, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (451, 'Card màn hình ZOTAC GAMING GeForce RTX 3060 Twin Edge OC 12GB', 7250000, 'TDP: 170W', 'asus_rog_rtx_4090.jpg', 10, 50, '2026-07-23 11:35:00.000', 'ZOTAC');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (452, 'Card màn hình Sapphire PULSE AMD Radeon RX 7600 8GB GDDR6', 7150000, 'TDP: 165W', 'asus_rog_rtx_4090.jpg', 10, 40, '2026-07-23 11:35:00.000', 'Sapphire');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (453, 'Card màn hình PowerColor Fighter AMD Radeon RX 6600 8GB GDDR6', 5250000, 'TDP: 132W', 'asus_rog_rtx_4090.jpg', 10, 55, '2026-07-23 11:35:00.000', 'PowerColor');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (454, 'Card màn hình ASRock Challenger Radeon RX 7800 XT 16GB OC', 14150000, 'TDP: 263W', 'asus_rog_rtx_4090.jpg', 10, 30, '2026-07-23 11:35:00.000', 'ASRock');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (455, 'Card màn hình COLORFUL GeForce GTX 1650 NB 4GD6-V', 3650000, 'TDP: 75W', 'asus_rog_rtx_4090.jpg', 10, 70, '2026-07-23 11:35:00.000', 'COLORFUL');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (456, 'Ổ cứng HDD PC Western Digital Purple 2TB 3.5 inch Surveillance', 1650000, 'TDP: 6W', 'sabrent_rocket_4tb.jpg', 11, 90, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (457, 'Ổ cứng HDD PC Western Digital Purple 4TB 3.5 inch Surveillance', 2750000, 'TDP: 7W', 'sabrent_rocket_4tb.jpg', 11, 70, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (458, 'Ổ cứng HDD PC Western Digital Purple 6TB 3.5 inch Surveillance', 4350000, 'TDP: 8W', 'sabrent_rocket_4tb.jpg', 11, 45, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (459, 'Ổ cứng HDD PC Seagate SkyHawk 2TB 3.5 inch Surveillance', 1550000, 'TDP: 6W', 'sabrent_rocket_4tb.jpg', 11, 85, '2026-07-23 11:35:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (460, 'Ổ cứng HDD PC Seagate SkyHawk 6TB 3.5 inch Surveillance', 4150000, 'TDP: 8W', 'sabrent_rocket_4tb.jpg', 11, 50, '2026-07-23 11:35:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (461, 'Ổ cứng HDD Server Seagate IronWolf Pro 8TB 3.5 inch NAS', 6150000, 'TDP: 9W', 'sabrent_rocket_4tb.jpg', 11, 30, '2026-07-23 11:35:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (462, 'Ổ cứng HDD Server Seagate IronWolf Pro 12TB 3.5 inch NAS', 8950000, 'TDP: 10W', 'sabrent_rocket_4tb.jpg', 11, 20, '2026-07-23 11:35:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (463, 'Ổ cứng HDD Server Western Digital Red Pro 8TB 3.5 inch NAS', 6450000, 'TDP: 9W', 'sabrent_rocket_4tb.jpg', 11, 25, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (464, 'Ổ cứng HDD Enterprise Seagate Exos X16 14TB 3.5 inch SATA3', 7250000, 'TDP: 10W', 'sabrent_rocket_4tb.jpg', 11, 25, '2026-07-23 11:35:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (465, 'Ổ cứng HDD Enterprise Western Digital Ultrastar DC HC550 18TB', 9450000, 'TDP: 10W', 'sabrent_rocket_4tb.jpg', 11, 15, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (466, 'Ổ cứng HDD PC Toshiba Canvio Basics 1TB 2.5 inch', 1250000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 11, 110, '2026-07-23 11:35:00.000', 'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (467, 'Ổ cứng HDD PC Toshiba Surveillance S300 4TB 3.5 inch', 2550000, 'TDP: 7W', 'sabrent_rocket_4tb.jpg', 11, 60, '2026-07-23 11:35:00.000', 'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (468, 'Ổ cứng HDD Laptop Western Digital Blue 1TB 2.5 inch SATA3', 1150000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 11, 95, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (469, 'Nguồn Corsair RM850e ATX 3.0 80 Plus Gold Full Modular (850W)', 3450000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 50, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (470, 'Nguồn Corsair RM1000x Shift 80 Plus Gold Full Modular (1000W)', 4950000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 30, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (471, 'Nguồn Corsair CV650 650W 80 Plus Bronze', 1450000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 90, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (472, 'Nguồn MSI MAG A650BN 650W 80 Plus Bronze', 1250000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 110, '2026-07-23 11:35:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (473, 'Nguồn MSI MEG Ai1300P PCIE5 1300W 80 Plus Platinum', 8950000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 15, '2026-07-23 11:35:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (474, 'Nguồn ASUS ROG Thor 1000W Platinum II OLED', 8450000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 20, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (475, 'Nguồn ASUS TUF Gaming 650B 650W 80 Plus Bronze', 1650000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 80, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (476, 'Nguồn Cooler Master Elite V3 600W 230V', 1050000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 100, '2026-07-23 11:35:00.000', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (477, 'Nguồn DeepCool PK650D 650W 80 Plus Bronze', 1350000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 85, '2026-07-23 11:35:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (478, 'Nguồn ASRock Phantom Gaming PG-850G 850W 80 Plus Gold', 2950000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 40, '2026-07-23 11:35:00.000', 'ASRock');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (479, 'Vỏ case NZXT H9 Flow Dual-Chamber ATX Mid-Tower Black', 4450000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 30, '2026-07-23 11:35:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (480, 'Vỏ case NZXT H5 Flow RGB Compact Mid-Tower White', 2650000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 50, '2026-07-23 11:35:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (481, 'Vỏ case Lian Li O11 Dynamic EVO XL Full Tower Black', 5850000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 20, '2026-07-23 11:35:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (482, 'Vỏ case Lian Li Lancool 216 ARGB Mid-Tower Black', 2350000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 60, '2026-07-23 11:35:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (483, 'Vỏ case Corsair 3500X ARGB Mid-Tower Glass Black', 2450000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 70, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (484, 'Vỏ case Corsair 5000D AIRFLOW Tempered Glass Mid-Tower White', 3850000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 35, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (485, 'Vỏ case MSI MAG FORGE 100M Mid-Tower Black', 1150000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 90, '2026-07-23 11:35:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (486, 'Vỏ case Xigmatek Gaming X 3FX 3 Fan ARGB Black', 850000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 120, '2026-07-23 11:35:00.000', 'Xigmatek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (487, 'Vỏ case Mik Aios Black Kèm 3 Fan ARGB', 950000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 100, '2026-07-23 11:35:00.000', 'Mik');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (488, 'Vỏ case SAMA 3509 Black Kèm 3 Fan RGB', 750000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 110, '2026-07-23 11:35:00.000', 'SAMA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (489, 'Tản nhiệt khí Thermalright Peerless Assassin 120 White ARGB', 1050000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 80, '2026-07-23 11:35:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (490, 'Tản nhiệt khí Thermalright Frost Tower 120 Dual Tower Black', 950000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 70, '2026-07-23 11:35:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (491, 'Tản nhiệt khí DeepCool AK620 Digital ARGB Black Dual Tower', 1850000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 50, '2026-07-23 11:35:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (492, 'Tản nhiệt khí DeepCool AG400 ARGB Single Tower', 450000, 'TDP: 3W', 'rog_ryujin_360.jpg', 14, 130, '2026-07-23 11:35:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (493, 'Tản nhiệt khí Noctua NH-U12S chromax.black Single Tower', 2150000, 'TDP: 4W', 'rog_ryujin_360.jpg', 14, 40, '2026-07-23 11:35:00.000', 'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (494, 'Tản nhiệt khí Noctua NH-L9i-17xx Low-Profile CPU Cooler', 1350000, 'TDP: 3W', 'rog_ryujin_360.jpg', 14, 60, '2026-07-23 11:35:00.000', 'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (495, 'Tản nhiệt khí ID-COOLING SE-207-XT Black Dual Tower', 950000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 75, '2026-07-23 11:35:00.000', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (496, 'Tản nhiệt khí ID-COOLING FROZN A620 Black Dual Tower', 1150000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 65, '2026-07-23 11:35:00.000', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (497, 'Tản nhiệt khí Cooler Master MasterAir MA612 Stealth Black', 1750000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 45, '2026-07-23 11:35:00.000', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (498, 'Tản nhiệt khí Jonsbo CR-1400 ARGB Black', 280000, 'TDP: 2W', 'rog_ryujin_360.jpg', 14, 160, '2026-07-23 11:35:00.000', 'Jonsbo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (499, 'Bộ 3 Fan tản nhiệt Lian Li UNI FAN TL LCD 120 Reverse Black', 3450000, 'TDP: 4W', 'rog_ryujin_360.jpg', 15, 30, '2026-07-23 11:35:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (500, 'Bộ 3 Fan tản nhiệt Lian Li UNI FAN AL120 V2 ARGB Black', 2150000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 50, '2026-07-23 11:35:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (501, 'Bộ 3 Fan tản nhiệt Corsair LL120 RGB 120mm Dual Light Loop White', 2650000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 45, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (502, 'Bộ 3 Fan tản nhiệt Corsair SP120 RGB ELITE 120mm PWM Triple Pack', 1650000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 60, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (503, 'Bộ 3 Fan tản nhiệt NZXT F120 RGB Core Triple Pack White', 1850000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 55, '2026-07-23 11:35:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (504, 'Bộ 3 Fan tản nhiệt DeepCool FC120 White 3-in-1 ARGB', 890000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 80, '2026-07-23 11:35:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (505, 'Bộ 3 Fan tản nhiệt Thermalright TL-C12C-S X3 White ARGB', 490000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 110, '2026-07-23 11:35:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (506, 'Bộ 3 Fan tản nhiệt Thermalright TL-K12 ARGB High-Performance', 650000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 90, '2026-07-23 11:35:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (507, 'Bộ 3 Fan tản nhiệt Montech RX120 PWM Reverse ARGB Pack', 690000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 85, '2026-07-23 11:35:00.000', 'Montech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (508, 'Bộ 3 Fan tản nhiệt Xigmatek Galaxy II Pro ARGB 3 Fan Pack', 450000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 120, '2026-07-23 11:35:00.000', 'Xigmatek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (509, 'Bộ 3 Fan tản nhiệt Mik Halo ARGB 3 Fan Pack Black', 380000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 130, '2026-07-23 11:35:00.000', 'Mik');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (510, 'Bộ 3 Fan tản nhiệt SAMA Halo ARGB Kit 3 Fan kèm Hub Remote', 350000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 140, '2026-07-23 11:35:00.000', 'SAMA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (511, 'Fan tản nhiệt lẻ Noctua NF-A12x25 PWM chromax.black', 850000, 'TDP: 1W', 'rog_ryujin_360.jpg', 15, 90, '2026-07-23 11:35:00.000', 'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (512, 'Fan tản nhiệt lẻ Arctic P12 PWM PST Black 120mm', 220000, 'TDP: 1W', 'rog_ryujin_360.jpg', 15, 200, '2026-07-23 11:35:00.000', 'Arctic');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (513, 'Bàn phím cơ AKKO 5075B Plus Dragon Ball Z Wireless RGB', 2350000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 40, '2026-07-23 11:35:00.000', 'AKKO');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (514, 'Bàn phím cơ AKKO MonsGeek M1 V2 Kit Nhôm CNC Hotswap', 1850000, 'TDP: 1W', 'corsair_3500x_black.png', 16, 50, '2026-07-23 11:35:00.000', 'AKKO');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (515, 'Bàn phím cơ Keychron K2 Pro Wireless Bluetooth QMK/VIA Gateron', 2150000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 60, '2026-07-23 11:35:00.000', 'Keychron');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (516, 'Bàn phím cơ Keychron Q1 Max Full Aluminum Wireless Custom', 4650000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 25, '2026-07-23 11:35:00.000', 'Keychron');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (517, 'Bàn phím cơ Logitech G Pro X TKL LIGHTSPEED Wireless Black', 4150000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 35, '2026-07-23 11:35:00.000', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (518, 'Bàn phím cơ Razer BlackWidow V4 Pro Mechanical Gaming Keyboard', 5450000, 'TDP: 3W', 'corsair_3500x_black.png', 16, 20, '2026-07-23 11:35:00.000', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (519, 'Bàn phím cơ Corsair K70 RGB PRO Mechanical Gaming Keyboard', 3650000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 45, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (520, 'Bàn phím cơ SteelSeries Apex Pro TKL Wireless', 5950000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 20, '2026-07-23 11:35:00.000', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (521, 'Bàn phím cơ ASUS ROG Azoth Wireless Custom Gaming Keyboard', 6850000, 'TDP: 3W', 'corsair_3500x_black.png', 16, 15, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (522, 'Bàn phím cơ Dareu EK87 V2 Multi-LED Tenkeyless Black', 450000, 'TDP: 1W', 'corsair_3500x_black.png', 16, 120, '2026-07-23 11:35:00.000', 'Dareu');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (523, 'Chuột máy tính Logitech G Pro X Superlight 2 Wireless Black', 3450000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 50, '2026-07-23 11:35:00.000', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (524, 'Chuột máy tính Logitech G502 X PLUS LIGHTSPEED Wireless RGB', 3650000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 40, '2026-07-23 11:35:00.000', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (525, 'Chuột máy tính Razer DeathAdder V3 Pro Wireless Ultra-Lightweight', 3250000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 45, '2026-07-23 11:35:00.000', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (526, 'Chuột máy tính Razer Viper V3 Pro Ultra-Lightweight Wireless', 3850000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 35, '2026-07-23 11:35:00.000', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (527, 'Chuột máy tính SteelSeries Aerox 3 Wireless Onyx Superlight', 1850000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 60, '2026-07-23 11:35:00.000', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (528, 'Chuột máy tính Corsair M65 RGB ULTRA Wireless Gaming Mouse', 2450000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 50, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (529, 'Chuột máy tính ASUS ROG Keris II Ace Ultra-Lightweight Wireless', 3150000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 40, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (530, 'Chuột máy tính Dareu EM901X RGB Wireless kèm Đế sạc', 590000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 100, '2026-07-23 11:35:00.000', 'Dareu');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (531, 'Chuột máy tính Rapoo VT9 PRO Dual-Mode Wireless Gaming Mouse', 790000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 90, '2026-07-23 11:35:00.000', 'Rapoo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (532, 'Chuột máy tính Fantech Helios II Pro XD3 V3 Wireless', 1250000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 70, '2026-07-23 11:35:00.000', 'Fantech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (533, 'Tai nghe gaming HyperX Cloud III Wireless Black/Red 120-Hour Battery', 3850000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 40, '2026-07-23 11:35:00.000', 'HyperX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (534, 'Tai nghe gaming HyperX Cloud Stinger 2 Core Gaming Headset', 850000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 90, '2026-07-23 11:35:00.000', 'HyperX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (535, 'Tai nghe gaming Razer BlackShark V2 Pro Wireless 2023 Edition', 4450000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 35, '2026-07-23 11:35:00.000', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (536, 'Tai nghe gaming Razer Kraken Kitty V2 Pro RGB Quartz Pink', 4250000, 'TDP: 2W', 'corsair_3500x_black.png', 18, 30, '2026-07-23 11:35:00.000', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (537, 'Tai nghe gaming Logitech G PRO X 2 LIGHTSPEED Wireless Graphene', 5650000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 25, '2026-07-23 11:35:00.000', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (538, 'Tai nghe gaming Logitech G733 LIGHTSPEED Wireless RGB White', 2950000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 50, '2026-07-23 11:35:00.000', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (539, 'Tai nghe gaming SteelSeries Arctis Nova Pro Wireless PC/PlayStation', 8950000, 'TDP: 2W', 'corsair_3500x_black.png', 18, 15, '2026-07-23 11:35:00.000', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (540, 'Tai nghe gaming Corsair VIRTUOSO RGB WIRELESS High-Fidelity', 4850000, 'TDP: 2W', 'corsair_3500x_black.png', 18, 30, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (541, 'Tai nghe gaming ASUS ROG Pugi III Delta S Animate Display', 5250000, 'TDP: 2W', 'corsair_3500x_black.png', 18, 20, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (542, 'Tai nghe gaming Dareu EH722X 7.1 Surround Sound Pink', 490000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 110, '2026-07-23 11:35:00.000', 'Dareu');

INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (1, 'Intel Core i9-14900K', 15500000, '24 Cores, up to 6.0GHz, LGA 1700', 'i9_14900k.jpg', 1, 46, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (2, 'AMD Ryzen 9 7950X3D', 17200000, '16 Cores, 128MB L3 Cache, AM5', 'i9_14900k.jpg', 1, 15, NULL, NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (3, 'Intel Core i7-14700Kkk', 10800000, '20 Cores, Hybrid Architecture', 'https://himmcom.com.np/wp-content/uploads/2024/01/1-3.jpg%20?%3E', 1, 40, NULL, NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (4, 'AMD Ryzen 7 7800X3D', 11500000, 'Best gaming CPU, 8 Cores, 3D V-Cache', 'https://www.amd.com/content/dam/amd/en/images/products/processors/ryzen/2505503-ryzen-7-7800x3d.jpg', 1, 27, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (5, 'Intel Core i5-13600K', 8200000, '14 Cores, Mid-range gaming', 'https://www.notebookcheck.net/fileadmin/Notebooks/Sonstiges/Intel/Raptor_Lake_S/Raptor_Lake_7.jpg', 1, 54, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (6, 'AMD Ryzen 5 7600X', 5800000, '6 Cores, Zen 4 Architecture, AM5', 'https://ezonelb.com/wp-content/uploads/2024/04/amd_ryzen-5-7600x_01.jpg', 1, 59, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (7, 'Intel Core i9-13900KS', 18500000, 'Special Edition, 6.0GHz', 'https://tpucdn.com/cpu-specs/images/chips/2956-front.jpg', 1, 0, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (8, 'AMD Ryzen 9 7900X', 10500000, '12 Cores, 5.6GHz Boost', 'https://www.notebookcheck.net/uploads/tx_nbc2/R9_7900_9.jpg', 1, 18, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (9, 'Intel Core i7-13700F', 8900000, '16 Cores, No Integrated Graphics', 'https://microless.com/cdn/products/08f5cf4e0f9b43cecfee68f4a554f23c-hi.jpg', 1, 45, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (10, 'AMD Ryzen 7 5800X3D', 8500000, 'Legendary AM4 gaming CPU', 'https://hothardware.com/contentimages/NewsItem/71155/content/16x9_2133x1200_highres-amd-ryzen-7-5800x3d-anniversary.jpg', 1, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (11, 'Intel Core i5-12400F', 3500000, 'Budget King, 6 Cores', 'https://atcsjo.com/public/uploads/all/PZ7Ofk2PcEE8TNoZi0QSSfpF5x5tI84fcjFIBiLt.jpg', 1, 96, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (12, 'AMD Ryzen 5 5600G', 3200000, 'Integrated Vega Graphics', 'https://networkitstore.in/wp-content/uploads/2024/01/amd-ryzen-5600g-600x600.webp', 1, 71, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (13, 'Intel Core i3-14100', 3800000, 'Entry level 14th Gen', 'https://www.techpowerup.com/review/intel-core-i3-14100/images/cpu-front.jpg', 1, 70, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (14, 'AMD Ryzen 3 4100', 1800000, 'Budget 4 Cores, AM4', 'https://www.falconcomputers.co.uk/media/products/94109/0/0/amd-ryzen-3-4100-38ghz-4-core-am4-socket-overclockable-processor-with-wraith-steath-cooler-retail-boxed.jpg.jpg', 1, 118, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (15, 'Intel Core i9-12900K', 9500000, '16 Cores, Previous Flagship', 'https://www.pcworld.com/wp-content/uploads/2021/11/12th_Gen_Core_i9_12900K_Hero_Close_Up-4.jpg?resize=1536%2C1024&quality=50&strip=all', 1, 13, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (16, 'Vỏ máy tính Xigmatek QUANTUM 4AF', 800000, 'TDP: 0W', 'http://cdn.hstatic.net/products/200000722513/gearvn-vo-may-tinh-xigmatek-quantum-4af-1_c9db476a42ef48fba6d84a9703a94945_grande.jpg', 13, 100, '6/27/2026 12:22:45 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (17, 'Intel Core i5-14400F', 5600000, '10 Cores, Efficient Gaming', 'https://microless.com/cdn/products/30c01bcc173314e1a756151858871162-hi.jpg', 1, 65, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (18, 'AMD Ryzen 5 8600G', 6200000, 'AI Engine, Radeon 760M', 'https://images.versus.io/objects/amd-ryzen-5-8600g.front.master2x.1704766286597.webp', 1, 35, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (19, 'Intel Core i7-12700K', 7200000, '12 Cores, LGA 1700', 'https://product.hstatic.net/200000680839/product/hz__25mb__12_cores_20_threads__0703223b7ae44a9ca2dd97b79516fa6f_master_de0749de4f2f4df687f7940d2cd121d9_1024x1024.jpg', 1, 34, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (20, 'AMD Ryzen 7 7700', 7800000, '8 Cores, Low Power 65W', 'https://images.versus.io/objects/amd-ryzen-7-7700.front.master2x.1704766286597.webp', 1, 28, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (21, 'Intel Core i5-11400F', 2800000, 'Old Gen Budget King', 'https://www.techpowerup.com/cpu-specs/images/chips/2407-front.jpg', 1, 50, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (22, 'AMD Ryzen 5 4500', 1950000, 'Super Budget 6 Cores', 'https://m.media-amazon.com/images/I/91OZjLdueYL._AC_SL1500_.jpg', 1, 94, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (23, 'Intel Core i9-11900K', 6500000, 'Legacy Flagship LGA 1200', 'https://www.notebookcheck.com/fileadmin/Notebooks/Sonstiges/Intel/Rocket_Lake_S/Rocket_Lake_S_6.jpg', 1, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (24, 'AMD Ryzen 5 3600', 2100000, 'Popular AM4 CPU', 'https://m.media-amazon.com/images/I/81b75EQJrgL.jpg', 1, 150, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (25, 'Intel Core i5-10400F', 2200000, 'Stable and Cheap', 'https://tpucdn.com/cpu-specs/images/chips/2270-front.jpg', 1, 110, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (26, 'AMD Ryzen 9 3900X', 7500000, '12 Cores, Workstation', 'https://m.media-amazon.com/images/I/71ZANS0SSDL.jpg', 1, 8, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (27, 'Intel Pentium G7400', 1900000, 'Office work, 2 Cores', 'https://image.made-in-china.com/2f0j00HPzqpKeCABkW/for-Original-Best-Price-Intel-Pentium-Gold-G7400-Processor-3-70GHz-CPU-Alder-Lake-SRL66-LGA-1700-Processor-for-Desktop.jpg', 1, 200, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (28, 'AMD Athlon 3000G', 1200000, 'Ultra Budget Graphics', 'https://m.media-amazon.com/images/I/51wiBVz7jaL._AC_SL1000_.jpg', 1, 180, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (29, 'Intel Core i7-10700K', 4800000, 'High Clock Legacy', 'https://cdn.mos.cms.futurecdn.net/2WTyhwkcYo5b43PuCQYkzU.jpg', 1, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (30, 'AMD Ryzen 7 8700G', 9200000, 'Powerful APU, Radeon 780M', 'https://m.media-amazon.com/images/I/61nRX0W6fhL._AC_SL1500_.jpg', 1, 33, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (31, 'NVIDIA RTX 4090 24GB', 55000000, 'Ultimate Gaming GPU', 'https://media.ldlc.com/r1600/ld/products/00/06/12/43/LD0006124357.jpg', 2, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (32, 'RTX 4080 Super', 32000000, 'High-end 4K Gaming', 'https://checkfps.io/_next/image?url=%2Fimg%2Fgpu%2Frtx-4080-super.jpg&w=3840&q=75', 2, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (33, 'RTX 4070 Ti Super', 24500000, 'Perfect for 2K Gaming', 'https://checkfps.io/_next/image?url=%2Fimg%2Fgpu%2Frtx-4070-ti-super.jpg&w=3840&q=75', 2, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (34, 'AMD RX 7900 XTX', 28500000, 'AMD Flagship, 24GB', 'https://sm.ign.com/ign_ap/photo/default/pxl-20221205-200737220-portrait-1670634086080_cwha.jpg', 2, 12, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (35, 'RTX 4060 Ti 8GB', 11500000, 'Efficient 1080p/2K', 'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6545/6545279cv12d.jpg', 2, 43, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (36, 'AMD RX 7800 XT', 15200000, 'Best value 2K GPU', 'https://images-na.ssl-images-amazon.com/images/S/mediaservice.woot.com/29d66b60-097c-43ff-9d25-cc9d5c3448f0._AC_SR882,441_.png', 2, 30, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (37, 'RTX 3060 12GB', 7800000, 'Popular Mid-range', 'https://m.media-amazon.com/images/I/81si2RRaWUS.jpg', 2, 80, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (38, 'AMD RX 6600', 5500000, 'Best budget 1080p', 'https://m.media-amazon.com/images/I/81Ts3uaZqgL._AC_.jpg', 2, 100, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (39, 'ASUS ROG RTX 4090', 62000000, 'Premium build cooling', 'https://pcdiy.com.au/wp-content/uploads/2022/10/rog-4090-review.jpg', 2, 5, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (40, 'MSI Gaming X RTX 4070', 18500000, 'Quiet and Cool', 'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6539/6539607cv17d.jpg', 2, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (41, 'Gigabyte Eagle RTX 4060', 8200000, 'Triple Fan Budget', 'https://static.gigabyte.com/StaticFile/Image/Global/ca46ef321ac872a92db97cd434c951b6/Product/39542/Png', 2, 60, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (42, 'RTX 4070 Super', 17800000, '12GB GDDR6X, Fast', 'https://checkfps.io/_next/image?url=%2Fimg%2Fgpu%2Frtx-4070-super.jpg&w=3840&q=75', 2, 35, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (43, 'AMD RX 7600', 7900000, 'Budget RDNA 3', 'https://m.media-amazon.com/images/I/81QItJufypL._AC_.jpg', 2, 50, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (44, 'RTX 3050 6GB', 5200000, 'Entry level RTX', 'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/d2e9569c-e820-41de-9d8b-c3d26b98ac87.jpg', 2, 70, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (45, 'Zotac RTX 4060', 7800000, 'Compact dual fan', 'https://m.media-amazon.com/images/I/81w-5i9+nbL.jpg', 2, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (46, 'Galax RTX 4070 Pink', 16900000, 'Pink Edition RGB', 'https://images-na.ssl-images-amazon.com/images/I/81FyWeI-qpL.jpg', 2, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (47, 'ASUS TUF RTX 3070 Ti', 12000000, 'Rugged build quality', 'https://m.media-amazon.com/images/I/81t7Ga7nyxS._AC_.jpg', 2, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (48, 'EVGA RTX 3080', 15000000, 'High performance legacy', 'https://c1.neweggimages.com/ProductImageCompressAll1280/14-487-518-01.jpg', 2, 5, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (49, 'Sapphire RX 7900 GRE', 16500000, 'Golden Rabbit Edition', 'https://cdn.wccftech.com/wp-content/uploads/2023/07/AMD-Radeon-RX-7900-GRE-16-GB-GPU-Sapphire-Nitro-_5-g-standard-scale-4_00x-g-standard-scale-4_00x-Custom-1456x772.jpeg', 2, 18, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (50, 'PowerColor RX 7800 XT', 14800000, 'Excellent cooling', 'https://media.ldlc.com/r1600/ld/products/00/06/17/51/LD0006175116.jpg', 2, 22, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (51, 'GTX 1650', 3800000, 'No external power', 'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6347/6347252_sd.jpg', 2, 150, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (52, 'RX 6700 XT', 9500000, 'Great 1440p value', 'https://media.ldlc.com/r1600/ld/products/00/05/80/29/LD0005802927_1.jpg', 2, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (53, 'Colorful RTX 4080', 31000000, 'LCD screen on GPU', 'https://product.hstatic.net/200000420363/product/card-man-hinh-vga-colorful-geforce-rtx-4080-16gb-nb-ex-v-5_b75b5c93f4eb4c5aac487e7b2bd38964_master.jpg', 2, 8, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (54, 'Quadro RTX A4000', 22000000, 'Workstation GPU', 'https://5.imimg.com/data5/SELLER/Default/2022/6/VF/ZD/YJ/3092725/nvidia-quadro-rtx4000-8gb-1-500x500.jpg', 2, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (55, 'Radeon Pro W7800', 58000000, 'Professional Graphics', 'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3773/innergigabyte/images/kft.png', 2, 3, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (56, 'Intel Arc A770 16GB', 9200000, 'Intel High-end GPU', 'https://pg.asrock.com/Graphics-Card/photo/Intel%20Arc%20A770%20Phantom%20Gaming%2016GB%20OC(L1).png', 2, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (57, 'Intel Arc A750', 6500000, 'Budget King Intel', 'https://m.media-amazon.com/images/I/71sO2CZL1UL.jpg', 2, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (58, 'ASUS Dual RTX 4070', 17500000, 'Clean white build', 'https://media.ldlc.com/r1600/ld/products/00/06/03/60/LD0006036039.jpg', 2, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (59, 'Gigabyte RTX 4090', 59000000, 'Massive cooler', 'https://www.cfd.co.jp/webpim/product/image/g/gv-n4090wf3-24gd/gv-n4090wf3-24gd/gv-n4090wf3-24gd__0100.png', 2, 4, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (60, 'PNY RTX 4060', 7500000, 'Small and efficient', 'https://i5.walmartimages.com/asr/7a16bb22-0ab5-4190-b4b4-419ccbbb8de2.7f8f100c1db40b894fbac7d7c38e995b.jpeg', 2, 55, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (61, 'Corsair Vengeance 32GB', 3500000, 'DDR5 6000MHz Black', 'https://m.media-amazon.com/images/I/81EEpt-xy0L.jpg', 3, 50, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (62, 'G.Skill Trident Z5 32GB', 4200000, 'DDR5 6400MHz RGB', 'https://m.media-amazon.com/images/I/71DiVTefKBL._AC_.jpg', 3, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (63, 'Kingston Fury 16GB', 1250000, 'DDR4 3200MHz', 'https://m.media-amazon.com/images/I/71+clMT-q-L._AC_SL1500_.jpg', 3, 120, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (64, 'T-Force Delta 32GB', 3200000, 'DDR5 6000MHz White', 'https://os-jo.com/image/cache/catalog/products/memory/FF3D532G6000HC30DC01/81XZeKnL6LL._AC_UF894,1000_QL80_-1200x1200.jpg', 3, 45, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (65, 'ADATA XPG 16GB', 1800000, 'DDR5 5200MHz', 'https://www.esocket.us/wp-content/uploads/2021/01/20210128_211718-scaled.jpg', 3, 70, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (66, 'Crucial 8GB', 650000, 'Standard office RAM', 'https://supertechwebstore.com/wp-content/uploads/2023/07/1-11.jpg', 3, 200, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (67, 'Dominator Titanium 64GB', 9500000, 'DDR5 7200MHz', 'https://m.media-amazon.com/images/I/611o1NX2HvL._AC_.jpg', 3, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (68, 'Ripjaws V 16GB', 1100000, 'DDR4 3600MHz', 'https://ryans.com/storage/products/main/gskill-ripjaws-v-16gb-ddr4-3200mhz-black-11723012156.webp', 3, 90, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (69, 'Lexar Thor 32GB', 2100000, 'DDR4 3200MHz Budget', 'https://down-ph.img.susercontent.com/file/ph-11134207-7ras8-m2lujp7y6sc27f', 3, 55, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (70, 'Fury Renegade 32GB', 4800000, 'DDR5 7200MHz', 'https://m.media-amazon.com/images/I/71GJY5+c14L._AC_SL1500_.jpg', 3, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (71, 'PNY XLR8 16GB', 1350000, 'DDR4 3200MHz RGB', 'https://basitcomputers.com/wp-content/uploads/2024/12/16GB-DDR4-RAM-3200MHz-PNY-XLR8-GAMiNG-RAM-WiTH-HEATSiNK-105.jpg', 3, 60, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (72, 'Silicon Power 16GB', 950000, 'Value RAM 3200', 'https://static1.nordic.pictures/890711-thickbox_default/silicon-power-flash-drive-16gb-marvel-m01-usb-30-blue.jpg', 3, 150, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (73, 'Mushkin Redline 32GB', 3400000, 'DDR5 5600MHz', 'https://www.singular.com.cy/images/detailed/615/Mushkin_Redline_DDR5_module_32_GB_SODIMM_MRA5S480FFFD32G-895755.jpg', 3, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (74, 'Patriot Viper 16GB', 1450000, 'DDR4 4000MHz', 'https://tanphatad.com/wp-content/uploads/tanphatad/Patriot-Memory-Viper-Venom-RGB-DDR5-600-RAM-16GB-3.jpg', 3, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (75, 'Samsung 32GB', 2800000, 'DDR5 4800MHz OEM', 'https://jumbocolombiaio.vtexassets.com/arquivos/ids/476318/8806094731989_1.jpg?v=638163096318000000', 3, 30, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (76, 'Thermaltake 16GB', 2200000, 'DDR4 3600MHz RGB', 'https://www.ucc.com.bd/image/cache/catalog/ram/dekstop-ram/thermaltake/toughram-rgb-white/16gb/3200-mhz/thermaltake-16gb-toughram-rgb-ddr4-3200-mhz-cl16-16gb-x-1-desktop-ram-white-550x550.jpg.webp', 3, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (77, 'Zadak Spark 32GB', 3900000, 'DDR5 6000MHz', 'https://img.terabyteshop.com.br/produto/g/memoria-ddr4-zadak-spark-rgb-32gb-3600mhz-2x16gb-zd4-spr36c25-32g2b2_132087.jpg', 3, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (78, 'Apacer Panther 8GB', 750000, 'Budget Gaming RAM', 'https://songphuong.vn/Content/uploads/2021/11/Ram-Apacer-OC-Panther-Golden-8GB-DDR4-3200MHz-1-songphuong.vn_.jpg', 3, 100, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (79, 'GeIL Super Luce 16GB', 1300000, 'DDR4 3200MHz', 'https://www.memoryc.com/images/products/bb/geil-16570-2_63013.jpg', 3, 50, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (80, 'V-Color Prism 32GB', 3100000, 'DDR4 3600MHz RGB', 'https://microless.com/cdn/products/f2f307222b823793c47a0da071ca69c0-hi.jpg', 3, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (81, 'Kingston Fury 64GB', 6800000, 'DDR5 5600MHz Kit', 'https://m.media-amazon.com/images/I/715QXNdKxiL._AC_.jpg', 3, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (82, 'Vengeance LPX 32GB', 2500000, 'DDR4 3200 Low Profile', 'https://res.cloudinary.com/jawa/image/upload/f_auto,ar_1:1,c_fill,w_3840,q_auto/production/listings/fxqabbdlbowyj2wl8sks', 3, 80, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (83, 'Trident Z Neo 32GB', 3400000, 'Optimized for Ryzen', 'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/2/0/20-374-105-02.jpg', 3, 35, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (84, 'Team Elite 16GB', 1600000, 'DDR5 4800 Basic', 'https://down-ph.img.susercontent.com/file/id-11134207-7rask-m5jh3ypl5hul99', 3, 60, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (85, 'Crucial Pro 32GB', 3300000, '6000MHz Overclock', 'https://m.media-amazon.com/images/I/61EUuA9HiaL._AC_.jpg', 3, 45, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (86, 'Aorus RGB 16GB', 2400000, '3733MHz w/ Demo', 'https://static.gigabyte.com/StaticFile/Image/Global/ad60477ff44e587c09b67ee56b883341/Product/19876', 3, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (87, 'Lexar Ares 32GB', 3600000, 'DDR5 6400MHz', 'https://platincdn.com/3393/pictures/JIYFEDVBRW1182024185730_Lexar-Ares-DT-32GB-RGB-DDR5-LD5EU016G-R6400GDLA-Ra.jpg', 3, 30, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (88, 'Netac Shadow 16GB', 1100000, 'Budget RGB RAM', 'https://netacbd.com/wp-content/uploads/2022/07/1080X1080-7-e1677757851813.jpg', 3, 100, NULL, NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (89, 'Galax HOF 32GB', 5500000, '8000MHz White OC', 'https://www.cowcotland.com/images/news/2025/04/big/galax-rtx5090dhoflab.jpg', 3, 5, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (90, 'Oloy Blade 32GB', 3250000, 'DDR5 6000MHz Black', 'https://i5.walmartimages.com/seo/OLOy-Blade-RGB-32GB-2-x-16GB-288-Pin-PC-RAM-DDR4-3600-PC4-28800-Desktop-Memory-Model-ND4U1636181DRKDE_e65c195a-eba5-42b3-9551-e8dfdd9cf1ce.1b1974844fb12e93389871c8ea8b08fc.jpeg', 3, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (91, 'ROG Maximus Z790 Hero', 16500000, 'Flagship Intel Board', 'https://dlcdnwebimgs.asus.com/gain/7512B84A-0D14-4798-A585-3439F4B645CB/w1000/h732', 5, 12, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (92, 'B760M Mortar WiFi', 4500000, 'Best Mid-range Intel', 'https://storage-asset.msi.com/global/picture/image/feature/mb/B760M/mag-b760m-mortar-wifi/msi-b760m-mortar-wifi-motherboard.png', 5, 45, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (93, 'Z790 Aorus Elite', 7800000, 'High perf Z790', 'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2181/innergigabyteimages/specsmall01.jpg', 5, 30, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (94, 'TUF B650-Plus', 5800000, 'Standard AM5 Board', 'https://dlcdnwebimgs.asus.com/files/media/2b278afc-50b2-452f-9fae-ec2825d27632/V1/img/kv-main.png', 5, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (95, 'B660M Pro RS', 3200000, 'Budget Intel 12/13', 'https://nguyencongpc.vn/media/product/22934-main-b660m-pro-rs-ax-4.jpeg', 5, 60, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (96, 'X670E Carbon WiFi', 11500000, 'High-end AM5', 'https://www.pcstudio.in/wp-content/uploads/2022/09/Msi-Mpg-X670E-Carbon-Wifi-Motherboard-2.jpg', 5, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (97, 'Prime H610M-K', 2100000, 'Office Intel Board', 'https://dlcdnwebimgs.asus.com/gain/eb6af592-21fd-4592-81f3-d342cf769939/', 5, 100, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (98, 'B450M DS3H', 1850000, 'Legendary AM4 Budget', 'https://rbtechngames.com/wp-content/uploads/2021/08/gigabyte_b450m_ds3h.jpg', 5, 80, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (99, 'ROG Strix B760-I', 5900000, 'ITX Intel Board', 'https://dlcdnwebimgs.asus.com/gain/6F72A739-6576-4E2E-B224-61390DFA287F/w1000/h732', 5, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (100, 'Z790 GODLIKE', 35000000, 'Ultimate Overclock', 'https://storage-asset.msi.com/global/picture/image/feature/mb/Z790/MEG-Z790-GODLIKE/m2-01.png', 5, 3, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (101, 'Z790 Taichi', 12500000, 'Gear design, E-ATX', 'https://m.media-amazon.com/images/I/81OIw3yjYeL._AC_.jpg', 5, 8, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (102, 'ProArt Z790-Creator', 13800000, 'For Creators', 'https://dlcdnwebimgs.asus.com/gain/fe64f38f-9f58-4722-b2b0-723379b316be/', 5, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (103, 'B650I Aorus Ultra', 7200000, 'ITX AM5 Board', 'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2226/innergigabyteimages/smartfan601.png', 5, 12, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (104, 'PRO H610M-E', 1950000, 'Cheap office build', 'https://m.media-amazon.com/images/I/81MY4UCX8wL._AC_SY450_.jpg', 5, 150, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (105, 'Crosshair X670E', 28000000, 'Best of AM5', 'https://files.pccasegear.com/images/ROG-CROSSHAIR-X670E-EXTREME-add5.jpg', 5, 5, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (106, 'Biostar B760MZ', 3100000, 'Budget B760', 'https://microless.com/cdn/products/a0122264cca32a3cf97401f16cb33fc2-hi.jpg', 5, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (107, 'CVN B760M Frozen', 4200000, 'White Motherboard', 'https://product.hstatic.net/200000420363/product/mainboard-colorful-cvn-b760m-plus-frozen-wifi-d5-v20_ebaf35779b3d445ba23be5e1ce43cd5c_master.png', 5, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (108, 'A520M S2H', 1650000, 'Budget AM4', 'https://media.ldlc.com/r1600/ld/products/00/05/70/93/LD0005709352_1.jpg', 5, 90, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (109, 'NZXT N7 Z790', 8500000, 'Clean Aesthetic', 'https://m.media-amazon.com/images/I/71u-dioc8vL._AC_SL1500_.jpg', 5, 18, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (110, 'A620M-HDV', 2800000, 'Cheap AM5 entry', 'https://media.ldlc.com/r1600/ld/products/00/06/03/41/LD0006034175.jpg', 5, 55, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (111, 'Z790 Dark Kingpin', 22000000, 'Limitless OC', 'https://www.thefpsreview.com/wp-content/uploads/2022/09/evga-z790-dark-kingpin-motherboard-face-transparent.png', 5, 2, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (112, 'X570S Tomahawk', 6500000, 'Silent AM4', 'https://storage-asset.msi.com/global/picture/image/feature/mb/X570/X570S-Tomahawk/x570s-tomahawk-hero-03-new.png', 5, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (113, 'A520M-Plus', 2400000, 'Durable AM4', 'https://www.cclonline.com/images/avante/5_TUF-GAMING-A520M-PLUS-WIFI_3D_AURA.jpg?width=1600&height=1600&scale=canvas', 5, 45, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (114, 'Z790 UD', 5500000, 'Basic Z790', 'https://m.media-amazon.com/images/I/71w2Kf+KK+L._AC_.jpg', 5, 35, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (115, 'B550M Steel Legend', 3800000, 'Solid B550 AM4', 'https://www.asrock.com/mb/photo/B550M%20Steel%20Legend(L1).png', 5, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (116, 'MSI B650 Gaming', 4900000, 'Budget AM5 WiFi', 'https://media.ldlc.com/r1600/ld/products/00/06/03/76/LD0006037607.jpg', 5, 50, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (117, 'Prime Z790-P', 6200000, 'Mainstream Z790', 'https://www.dateks.lv/images/pic/2400/2400/712/1307.jpg', 5, 30, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (118, 'H610M S2H', 2250000, 'LGA 1700 Office', 'https://m.media-amazon.com/images/I/81AdQh4+sHL._AC_SL1500_.jpg', 5, 110, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (119, 'X670E Steel Legend', 8900000, 'White AM5 High', 'https://media.ldlc.com/r1600/ld/products/00/05/98/02/LD0005980298.jpg', 5, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (120, 'Valkyrie Z790', 9500000, 'Biostar Flagship', 'https://cdn.mos.cms.futurecdn.net/qAs5WBF8JXptoXfeK5A9ZV.jpg', 5, 7, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (121, 'Samsung 990 Pro 1T', 3200000, 'NVMe Gen4 7450MB/s', 'https://s13emagst.akamaized.net/products/50830/50829483/images/res_a126340b9468e6ebe28dfaef136309be.jpg', 6, 60, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (122, 'Samsung 980 Pro 2T', 4500000, 'NVMe Gen4 7000MB/s', 'https://m.media-amazon.com/images/I/61JkTXrgYxS._AC_.jpg', 6, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (123, 'WD SN850X 1TB', 2600000, 'Top gaming SSD', 'https://i5.walmartimages.com/seo/WD-BLACK-SN850X-NVMe-Internal-SSD-1TB-WDBB9G0010BNC-WRSN_6d5f0ab9-719a-42e8-b247-8a4d3e4d509f.226a6322abeb936ec9e5dd42458a085d.png', 6, 55, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (124, 'Crucial P3 Plus 1T', 1850000, 'Budget Gen4', 'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6509/6509715cv12d.jpg', 6, 100, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (125, 'Kingston NV2 500G', 950000, 'Entry NVMe', 'https://images.kabum.com.br/produtos/fotos/sync_mirakl/400945/SSD-Kingston-Nv2-500GB-M-2-2280-NVME-PCIE-4-0-X4-Leitura-3500MB-s-E-Grava-o-2100MB-s-Preto-Snv2s-500g_1732199474_gg.jpg', 6, 150, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (126, 'Samsung 870 EVO 1T', 2100000, 'Best SATA SSD', 'https://www.ssd1tb.com/wp-content/uploads/samsung-870-evo-1tb.jpg', 6, 80, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (127, 'P41 Platinum 2T', 5200000, 'Super Fast Gen4', 'https://m.media-amazon.com/images/I/71RGTZJJuqL.jpg', 6, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (128, 'Lexar NM790 2T', 3800000, 'Value Gen4 7400', 'https://cdn.mwave.com.au/images/400/lexar_nm790_2tb_pcie_40_nvme_m2_ssd_lnm790x002trnnng_ac67987_77928.jpg', 6, 45, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (129, 'Crucial T700 1TB', 5800000, 'Gen5 11700MB/s', 'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6544/6544913_sd.jpg', 6, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (130, 'Aorus Gen5 2TB', 9500000, 'Gen5 w/ Heatsink', 'https://cdn.mcc-jo.com/media/G6O8nomwymYdYRvEto1xZM1OlAH5n2PoshguCK3s.webp', 6, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (131, 'TeamGroup MP33 1T', 1400000, 'Budget NVMe', 'https://images.harlander.com/artikel/1000x1000/teamgroup-mp33-1tb-ssd-pcie-nvme-m2-2280-1.jpg', 6, 90, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (132, 'XPG S70 Blade 1T', 2200000, 'PS5 Gen4', 'https://webapi3.adata.com/storage/product/s70_blade_pk_1tb.png', 6, 65, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (133, 'SN580 1TB', 1700000, 'Reliable Gen4', 'https://www.titan-ice.co.za/images/detailed/50/wd-blue-sn580-nvme-ssd-1tb-flat.png.wdthumb.1280.1280.jpg', 6, 75, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (134, 'FireCuda 530 2TB', 5900000, 'High endurance', 'https://lagihitech.vn/wp-content/uploads/2022/02/SSD-Seagate-Firecuda-530-2TB-M.2-PCIe-Gen4x4-NVMe-ZP2000GM30013-hinh-1-1024x1024.jpg', 6, 18, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (135, 'Sabrent Rocket 4TB', 12500000, 'Huge capacity', 'https://m.media-amazon.com/images/I/71g-S-3aAjL._AC_.jpg', 6, 8, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (136, '970 EVO Plus 2TB', 3900000, 'Gen3 King', 'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6347/6347286cv11d.jpg', 6, 30, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (137, 'PNY CS2241 1TB', 1600000, 'Budget Gen4', 'https://minipcreviewer.com/wp-content/uploads/2024/03/pny-cs2241-1tb-m2-nvme-gen4-x4-internal-solid-state-drive-ssd-m280cs2241-1tb-rb-1.jpg', 6, 50, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (138, 'Silicon Power UD90 1650000', 1650000, 'Gen4 Value', 'https://talospc.com/wp-content/uploads/2023/03/SILICON-POWER-UD90-1TB-700-1.jpg', 6, 60, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (139, 'MP600 Pro 2TB', 4800000, 'Optimized for PS5', 'https://os-jo.com/image/cache/catalog/products/Storage/Internal/CSSD-F2000GBMP600PRO/CSSD-F2000GBMP600PRO-1200x1200.jpg', 6, 22, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (140, 'KC3000 1TB', 2450000, 'Fast Gen4 OS', 'https://www.dateks.lv/images/pic/1200/1200/849/1083.jpg', 6, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (141, 'Crucial MX500 1TB', 1800000, 'SATA storage', 'https://down-mx.img.susercontent.com/file/sg-11134201-23020-nx5fq0gyrlnvc4', 6, 85, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (142, 'SN350 480GB', 850000, 'Cheap upgrade', 'https://static.ctonline.mx/imagenes/DDUWSD1690/DDUWSD1690_full.jpg', 6, 120, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (143, 'Spatium M480 2TB', 4600000, 'High-end MSI SSD', 'https://m.media-amazon.com/images/I/71KFqIt1KeL._AC_.jpg', 6, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (144, 'Transcend 250S 1T', 2100000, 'Gen4 with Cache', 'https://www.ucc.com.bd/image/cache/catalog/ssd/transcend/TS1TMTE250S-550x550.png.webp', 6, 35, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (145, 'Viper VP4300 2TB', 5400000, 'Dual heatsinks', 'https://gamex24.com/cdn/shop/files/718RcXesBSL.jpg?v=1765733754&width=1946', 6, 12, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (146, 'Lexar NM620 512G', 900000, 'Gen3 Budget', 'https://basitcomputers.com/wp-content/uploads/2023/01/LEXAR-NM620-512GB-2280-NVMe-M.2-SSD.jpg', 6, 100, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (147, 'Netac N7000 2TB', 3600000, 'Gen4 7000MB/s', 'https://m.media-amazon.com/images/I/71e5H77FI4L._AC_SL1500_.jpg', 6, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (148, '870 QVO 4TB', 8500000, 'Massive SATA', 'https://www.discoazul.pt/uploads/media/images/disco-duro-ssd-samsung-870-qvo-4tb-sata-3-2-5-16.jpg', 6, 31, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (149, 'Adata SU650 240G', 450000, 'Cheapest SSD', 'https://img.pchome.com.tw/cs/items/DRAH0VA900HX1I5/000001_1727978028.jpg', 6, 200, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (150, 'Crucial T705 2TB', 10500000, 'Fastest Gen5', 'https://m.media-amazon.com/images/I/61kpTnvVd-L._AC_SL1500_.jpg', 6, 5, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (151, 'LG 27GR95QE', 22500000, '27 OLED 240Hz', 'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6530/6530357_rd.jpg', 7, 12, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (152, 'Dell U2723QE', 14800000, '27 4K IPS Black', 'https://i5.walmartimages.com/seo/Dell-27-60-Hz-IPS-Black-Technology-UHD-IPS-Monitor-8-ms-gray-to-gray-normal-5-ms-gray-to-gray-fast-3840-x-2160-4K-HDMI-DisplayPort-USB-Audio-Flat-Pan_da30d5dd-66cf-4f1f-a028-4807088fa3ac.85212000719ad54459b2996f8cc0f41d.jpeg', 7, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (153, 'VG249Q', 4200000, '24 144Hz IPS', 'https://dlcdnimgs.asus.com/websites/global/products/mpppu3u01ux28nvt/images/section4-img.png', 7, 60, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (154, 'Odyssey Neo G8', 28000000, '32 4K 240Hz', 'https://helios-i.mashable.com/imagery/articles/06t51rBTizAzYJbDiAL2LBN/images-2.fill.size_2000x1125.v1640943079.jpg', 7, 8, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (155, 'Gigabyte M27Q', 7800000, '27 2K 170Hz', 'https://i5.walmartimages.com/seo/GIGABYTE-M27Q-X-27-IPS-Gaming-Monitor-QHD-2560x1440-240Hz-1ms-GTG-AMD-FreeSync-Premium-Type-C-KVM-HDMI-DP-Type-C-Height-Adjustable-Black_f3eb5f61-69ba-4e34-b036-cec12104f4ce.7073182e88b5c23aed1a2c2a254b8c81.jpeg', 7, 35, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (156, 'AOC 24G2', 3900000, 'Popular 144Hz', 'https://m.media-amazon.com/images/I/81NEMtk5qPL._AC_SL1500_.jpg', 7, 80, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (157, 'ViewSonic VX2728', 4500000, '27 165Hz IPS', 'https://wise-tech.com.pk/wp-content/uploads/2024/04/VX2728-Side-View.png', 7, 50, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (158, 'MAG274QRF-QD', 10500000, '2K Quantum Dot', 'https://asset.msi.com/resize/image/global/product/product_1698825055a998b04cad4f3a7146e1cbbd35fe08d1.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 7, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (159, 'AW3423DW', 32000000, '34 QD-OLED', 'https://m.media-amazon.com/images/I/71ufV5NQ44L.jpg', 7, 5, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (160, 'BenQ SW271C', 42000000, 'Pro Color Photo', 'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6486/6486795cv1d.jpg', 7, 3, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (161, 'Samsung M7', 8200000, '32 4K Smart', 'https://cdn.shopify.com/s/files/1/0003/7489/8743/products/475763-Product-0-I-637469188336243792_800x800_1e5000c4-7ea5-417f-b421-049ebc3f7781.jpg?v=1628488171', 7, 30, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (162, 'LG 24MP60G', 2900000, 'Budget 24 IPS', 'https://m.media-amazon.com/images/I/71Ud77qJvSL._SL1500_.jpg', 7, 100, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (163, 'Swift PG42UQ', 38000000, '42 OLED 4K', 'https://www.gaming.gen.tr/wp-content/uploads/2023/05/asus-rog-swift-pg42uq-41-5-inc-138hz-0-1ms-uhd-adaptive-sync-oled-gaming-monitor-y.jpg', 7, 4, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (164, 'Gigabyte G24F 2', 4100000, '24 180Hz OC', 'https://cdn.shopify.com/s/files/1/0355/8296/7943/products/1000_40_1600x.jpg?v=1665361714', 7, 70, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (165, 'HP Z27k G3', 15500000, '4K Studio USB-C', 'https://mitosshoppers.com/wp-content/uploads/2026/01/2-19.jpg', 7, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (166, 'Nitro VG271U', 6500000, '27 2K 144Hz', 'https://i5.walmartimages.com/seo/Acer-Nitro-VG271U-M3bmiipx-27-WQHD-2560-x-1440-IPS-Monitor-with-AMD-FreeSync-Premium-Technology_87dece16-0f5e-4d5f-9579-ae97d9169316.ab486d96a9e5254d8824bc11fb4f19a4.png', 7, 45, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (167, 'Dell S2721DGF', 9200000, 'Fast IPS 165Hz', 'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6421/6421624_sd.jpg', 7, 22, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (168, 'LG DualUp', 16000000, 'Square 16:18', 'https://www.lg.com/content/dam/channel/wcms/br/images/M02_mnt-dualup-ergo-28mq780-01-2-lg-dualup-monitor-ergo-mobile.jpg', 7, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (169, 'Odyssey G5', 7200000, '27 2K Curved', 'https://m.media-amazon.com/images/I/81GjQCXtXhL._AC_SL1500_.jpg', 7, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (170, 'Legion Y25-30', 6800000, '24.5 240Hz', 'https://techacute.com/wp-content/uploads/2022/12/Lenovo-Legion-Y25-30-Gaming-Monitor-Tested-Out-Esports-Display-Review.jpg', 7, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (171, 'ProArt PA278QV', 8900000, 'Color Accurate', 'https://dlcdnimgs.asus.com/websites/global/products/gvxnvsvumc3y1lyy/images/pic_true_beauty.png', 7, 18, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (172, 'HKC ANT27TQC', 5500000, 'Budget 2K Curved', 'https://doc-fd.zol-img.com.cn/t_s640x2000/g6/M00/0A/06/ChMkKmBZkIaIYkKIACPmpm8vrpYAAL71QN3WEcAI-a-654.png', 7, 55, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (173, 'MSI G2412', 3500000, 'Budget 170Hz', 'https://asset.msi.com/resize/image/global/product/product_16533746428fdd9ede10dbb55365e4d4267b978414.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 7, 90, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (174, 'Dell E2222H', 2200000, 'Office 22', 'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/peripherals/monitors/e-series/e2222h/media-gallery/monitors_e2222h_gallery_2.psd?fmt=png-alpha&pscan=auto&scl=1&hei=804&wid=1003&qlt=100,1&resMode=sharp2&size=1003,804&chrss=full', 7, 150, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (175, 'LG 29WP500', 5200000, '29 UltraWide', 'https://c1.neweggimages.com/ProductImageCompressAll1280/24-026-192-V04.jpg', 7, 35, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (176, 'Philips 242E1', 3100000, 'Budget 144Hz', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/107/MTA-129724838/no-brand_no-brand_full01.jpg', 7, 80, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (177, 'AOC CU34G2X', 12500000, '34 UW 144Hz', 'https://m.media-amazon.com/images/I/81GnQlNcf3L.jpg', 7, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (178, 'Xeneon Flex', 45000000, 'Bendable OLED', 'https://www.royalsblue.com/wp-content/uploads/2022/08/1661532614_Corsair-announces-the-Xeneon-Flex-the-first-OLED-gaming-monitor.jpg', 7, 2, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (179, 'Zowie XL2546K', 13500000, 'Pro Esport 240Hz', 'https://brain-images-ssl.cdn.dixons.com/4/9/10218894/u_10218894.jpg', 7, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (180, 'Xiaomi Mi 34', 9500000, '34 2K UltraWide', 'https://ph-test-11.slatic.net/p/8642c1abe8e78d3a3f37b584614461b8.jpg', 7, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (181, 'Intel Arc A770 Limited Edition GPU', 8356600, '16GB GDDR6, 256-BOOLEAN, 2100 MHz, 225W', 'https://m.media-amazon.com/images/I/71rzJRZ7lIL._AC_.jpg', 2, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (182, 'Intel Arc A750 Graphics Card', 6324600, '8GB GDDR6, 256-BOOLEAN, 2050 MHz, 225W', 'https://m.media-amazon.com/images/I/71sO2CZL1UL._AC_.jpg', 2, 49, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (183, 'Intel Arc A580 Graphics Card', 4546600, '8GB GDDR6, 256-BOOLEAN, 1700 MHz, 185W', 'https://www.notebookcheck.net/fileadmin/Notebooks/News/_nc3/Intel-Arc-A580-header.jpg', 2, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (184, 'AMD Radeon RX 7900 XT GPU', 22834600, '20GB GDDR6, 80MB, 315W', 'https://m.media-amazon.com/images/I/81ZBhhO35mL._AC_.jpg', 2, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (185, 'AMD Radeon RX 7800 XT GPU', 12674600, '16GB GDDR6, 64MB, 263W', 'https://m.media-amazon.com/images/I/71K6e37YltL._AC_.jpg', 2, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (186, 'AMD Ryzen 5 5600X Desktop Processor', 3784600, '6, 12, AM4, 65W', 'https://www.amd.com/content/dam/amd/en/images/products/processors/ryzen/2505503-ryzen-5-5600x.jpg', 1, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (187, 'ASUS ROG Maximus Z790 Dark Hero', 17754600, 'LGA1700, Intel Z790, 4x DDR5 (Up to 192GB), ATX', 'https://dlcdnwebimgs.asus.com/gain/8E88DC59-A399-4385-8BCB-C3877F4EB746/w1000/h732', 5, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (188, 'ASUS ROG Strix X670E-E Gaming WiFi', 12674600, 'AM5, AMD X670E, PCIe 5.0, ATX', 'https://m.media-amazon.com/images/I/81ohPDfik0L.jpg', 5, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (189, 'ASUS ROG Strix GeForce RTX 4090 OC Edition', 50774600, '24GB GDDR6X, 16384, PCIe 4.0', 'https://dlcdnwebimgs.asus.com/gain/2486AE38-B7C7-443A-9615-FD08D5430992/w1000/h732', 2, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (190, 'ASUS ROG Swift OLED PG32UCDM', 32994600, '32-inch, 3840x2160 (4K), 240Hz, QD-OLED', 'https://rog.asus.com/media/1692603114505.jpg', 7, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (191, 'ASUS ROG Ryujin III 360 ARGB', 8864600, '360mm, Asetek 8th Gen, 3.5-inch Full Color', 'https://static.nb.com.ar/i/nb_WATER-COOLER-ASUS-ROG-RYUJIN-III-360-ARGB-EXTREME_export_8a547ab1b93ed328764c69a3da19902e.png', 14, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (192, 'ASUS ROG Thor 1200W Platinum II', 8102600, '1200W, 80 Plus Platinum, Full Modular, Real-time power draw', 'https://files.pccasegear.com/images/ROG-THOR-1200P2-GAMING-thumb.jpg', 12, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (193, 'MSI MEG Z790 GODLIKE MAX', 30454600, 'LGA1700, Intel Z790, 7x M.2 slots, M-Vision Dashboard', 'https://storage-asset.msi.com/global/picture/image/feature/mb/Z790/meg-z790-godlike-max/images/mb-godlike-max-02.png', 5, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (194, 'MSI MAG B650 TOMAHAWK WIFI', 5562600, 'AM5, AMD B650, DDR5 7600+(OC), Realtek 2.5Gbps LAN', 'https://storage-asset.msi.com/global/picture/image/feature/mb/B650/MAG-B650-TOMAHAWK-WIFI/mag-b650-tomahawk-wifi.png', 5, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (195, 'MSI GeForce RTX 4080 SUPER 16G GAMING X SLIM', 26644600, '16GB GDDR6X, TRI FROZR 3, 2625 MHz', 'https://storage-asset.msi.com/global/picture/image/feature/vga/NVIDIA/4080-Gaming/RTX-4080-Gaming-X-Slim-16G/images/msi-4080-gaming-x-slim-16g-in-desktop-01.jpg', 2, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (196, 'MSI MPG 271QRX QD-OLED', 20294600, '27-inch, 2560x1440 (2K), 360Hz, 0.03ms (GtG)', 'https://www.bhphotovideo.com/images/images2500x2500/msi_mpg_271qrx_qd_oled_27_wqhd_oled_16_9_1808681.jpg', 7, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (197, 'MSI MEG MAESTRO 700L PZ', 10642600, 'ATX Full Tower, Curved Tempered Glass, Back-connect (Project Zero) support', 'https://storage-asset.msi.com/global/picture/image/feature/PC-Case/MEG-MAESTRO-700L-PZ/meg-maestro-700l-pz-connect-pd.png', 13, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (198, 'MSI MAG CORELIQUID I360', 3530600, '360mm, ARGB Fans, Infinite Mirror IPS Style Design', 'https://cdn.mwave.com.au/images/400/msi_mag_coreliquid_i360_360mm_argb_aio_liquid_cpu_cooler_black_ac79069_96031.jpg', 14, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (199, 'MSI SPATIUM M570 PCIe 5.0 NVMe M.2 HS', 7594600, '2TB, Up to 12400 MB/s, Up to 11800 MB/s', 'https://asset.msi.com/resize/image/global/product/product_167573935424940aba56cd1dba801846447d621bb2.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 6, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (200, 'Gigabyte Z790 AORUS XTREME X', 25374600, 'LGA1700, 24+1+2 Phases, Wi-Fi 7, PCIe 5.0 x16', 'https://static.gigabyte.com/StaticFile/Image/Global/dee0b0bef844f7dcac99c3569fdf02c8/Product/36669/Png', 5, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (201, 'Gigabyte X670E AORUS MASTER', 11404600, 'AM5, AMD X670E, 4x M.2 PCIe 5.0, Intel 2.5GbE LAN', 'https://c1.neweggimages.com/ProductImageCompressAll1280/13-145-405-01.jpg', 5, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (202, 'Gigabyte M27Q Gaming Monitor', 7594600, '27-inch, Super Speed IPS, 2560x1440, 170Hz', 'https://i5.walmartimages.com/seo/GIGABYTE-M27Q-X-27-IPS-Gaming-Monitor-QHD-2560x1440-240Hz-1ms-GTG-AMD-FreeSync-Premium-Type-C-KVM-HDMI-DP-Type-C-Height-Adjustable-Black_f3eb5f61-69ba-4e34-b036-cec12104f4ce.7073182e88b5c23aed1a2c2a254b8c81.jpeg', 7, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (203, 'Gigabyte AORUS FO32U2P', 30454600, '32-inch, OLED (QD-OLED), 3840x2160, DP 2.1 UHBR20 supported', 'https://m.media-amazon.com/images/I/71M5qy2eL0L._AC_.jpg', 7, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (204, 'Gigabyte AORUS Gen5 12000 SSD 2TB', 8102600, 'PCIe 5.0 x4, NVMe 2.0, 12,400 MB/s, 11,800 MB/s', 'https://gzhls.at/pix/0c/eb/0ceb8457e76f2dda-n.webp', 6, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (205, 'Gigabyte UD1000GM PG5 (Rev 2.0)', 4038600, '1000W, PCIe Gen 5.0 (12VHPWR), 80 PLUS Gold', 'https://cdn.cclonline.com/cdn-cgi/image/width=2000/images/shopblocks/UD1000GM%20PG5-05.png', 12, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (206, 'Gigabyte AORUS C500 GLASS', 4546600, 'Mid Tower, 4mm Tempered Glass, Up to 420mm front', 'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2156/innergigabyteimages/utility-img-1.jpg', 13, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (207, 'Corsair Dominator Titanium RGB DDR5 32GB (2x16GB)6000MHz', 4673600, '32GB, 6000 MT/s, CL30, Intel XMP 3.0 / AMD EXPO', 'https://www.gaming.gen.tr/wp-content/uploads/2023/10/corsair-dominator-titanium-rgb-32gb-2x16gb-6000mhz-cl30-ddr5-ram-cmp32gx5m2b6000z30.jpg', 3, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (208, 'Corsair Vengeance RGB DDR5 64GB (2x32GB)5600MHz', 5562600, '64GB, 5600 MT/s, CL40', 'https://nvs.tn-cdn.net/2025/07/ram-corsair-vengeance-rgb-64gb-2x32gb-ddr5-5600mhz-cmh64gx5m2b5600c40w-3.jpg', 3, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (209, 'Corsair iCUE LINK H150i LCD Liquid CPU Cooler', 7340600, '360mm, 3x QX120 RGB Fans, 2.1-inch IPS Display, iCUE LINK Ecosystem', 'https://m.media-amazon.com/images/I/71vkSfGTdXL._AC_.jpg', 14, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (210, 'Corsair 5000D AIRFLOW Tempered Glass Mid-Tower', 4165600, 'Mid-Tower, Black, RapidRoute System, Up to 10x 120mm fans', 'https://cwsmgmt.corsair.com/pdp/5000-series/images/5000d-af-clear-clean-cool.png', 13, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (211, 'Corsair iCUE LINK 6500X RGB Mid-Tower DualChamber', 5054600, 'Dual Chamber Layout, Reverse-connector support, Front & Side Tempered Glass', 'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Cases/6500/CC-9011269-WW/Gallery/6500X_RGB_BLACK_RENDER_01.webp', 13, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (212, 'Corsair RM1000x Shift Fully Modular ATX PSU', 5308600, '1000W, 80 PLUS Gold, Side-mounted modular connections, ATX 3.0 & PCIe 5.0 ready', 'https://m.media-amazon.com/images/I/81dwGXVwpgL.jpg', 12, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (213, 'Corsair AX1600i Digital ATX Power Supply', 15468600, '1600W, 80 PLUS Titanium, Gallium Nitride (GaN) FETs', 'https://www.e-weekly.co.uk/Images/JohnMac/Corsair/CSR-AX160I/Images/AX1600i_03.jpg', 12, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (214, 'Corsair K100 RGB Mechanical Gaming Keyboard', 6324600, 'Corsair OPX Optical-Mechanical, AXON 4000Hz Hyper-polling, iCUE Control Wheel', 'https://assets.corsair.com/image/upload/f_auto,q_auto/v1682360586/akamai/pdp/k100/v2/dist/app-static/assets/images/smal-pp-keyboard.jpg', 16, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (215, 'Corsair Darkstar Wireless MMO Gaming Mouse', 4292600, '15 programmable buttons, MARKSMAN 26K DPI Optical, SLIPSTREAM Wireless & Bluetooth', 'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Gaming-Mice/CH-931A011/DARKSTAR_WIRELESS_01.webp', 17, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (216, 'Corsair Virtuoso RGB Wireless XT Headset', 6832600, 'High-Density 50mm Neodymium, Spatial Dolby Atmos, Broadcast-grade detachable mic', 'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Gaming-Headsets/CA-9011188-EU/Gallery/VIRTUOSO_XT_01.webp', 18, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (217, 'Logitech G Pro X Superlight 2 Wireless GamingMouse', 4038600, '60 grams, HERO 2 Sensor (32,000 DPI), LIGHTFORCE Hybrid Switches, 4000Hz max polling', 'https://techubme.com/wp-content/uploads/2024/07/logitech_Pro_X_Super_light_2.png', 17, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (218, 'Logitech G502 X LIGHTSPEED Wireless GamingMouse', 3530600, 'HERO 25K Sensor, 13 programmable controls, Dual-mode infinite scroll', 'https://www.bhphotovideo.com/images/images1500x1500/logitech_g_910_006178_g502_x_lightspeed_wireless_1722687.jpg', 17, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (219, 'Logitech G915 TKL Wireless Mechanical Keyboard', 5816600, 'Tenkeyless (TKL), Low Profile GL Tactile/Linear/Clicky, Up to 40 hours (100% brightness)', 'https://resource.logitechg.com/d_transparent.gif/content/dam/gaming/en/products/g915-tkl/g915-tkl-gallery-1-carbon.png', 16, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (220, 'Logitech G Pro X TKL LIGHTSPEED Gaming Keyboard', 5054600, 'Dual-shot PBT keycaps, LIGHTSPEED Wireless, Bluetooth, USB, Dedicated volume roller and controls', 'https://www.enation.sg/wp-content/uploads/2025/06/251.png', 16, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (221, 'Logitech G Pro X 2 LIGHTSPEED Wireless Headset', 6324600, '50mm Graphene Drivers, LIGHTSPEED, Bluetooth, 3.5mm wired, Up to 50 hours battery life', 'https://www.bhphotovideo.com/images/images1500x1500/logitech_g_981_001262_pro_x_2_wireless_1763226.jpg', 18, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (222, 'Logitech MX Master 3S Wireless Mouse', 2514600, '8K DPI tracking on any surface, Quiet clicks technology, MagSpeed Electromagnetic scrolling', 'https://m.media-amazon.com/images/I/61+OT7FPABL._AC_SL1500_.jpg', 17, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (223, 'Logitech MX Keys S Wireless Keyboard', 2768600, 'Spherically-dished Perfect Stroke keys, Smart illumination proximity sensor, Easy-Switch up to 3 devices', 'https://www.dc3.co.za/wp-content/uploads/920-011587-1.webp', 16, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (224, 'Razer Viper V3 Pro Wireless Gaming Mouse', 4038600, '54 grams, Focus Pro 35K Optical Sensor Gen-2, True 8000Hz HyperPolling Wireless', 'https://m.media-amazon.com/images/I/619xpFKAXPL.jpg', 17, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (225, 'Razer DeathAdder V3 Pro Wireless Gaming Mouse', 3784600, '63 grams, Right-handed ergonomic design, Focus Pro 30K Optical Sensor', 'https://wise-tech.com.pk/wp-content/uploads/2023/07/Razer-DeathAdder-V3-Pro-Ergonomic-Gaming-Mouse-White.png', 17, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (226, 'Razer Huntsman V3 Pro TKL Mechanical Keyboard', 5562600, 'Razer Analog Optical Switches Gen-2, Rapid Trigger mode with adjustable actuation (0.1- 4.0mm), Dual-purpose digital dial', 'https://m.media-amazon.com/images/I/81gJ6jkk3jL._AC_.jpg', 16, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (227, 'Razer BlackWidow V4 Pro Mechanical GamingKeyboard', 5816600, 'Razer Green Clicky / Yellow Linear Switches, Per-key & 3-sided underglow RGB, 8 dedicated macro keys', 'https://m.media-amazon.com/images/I/81L4FpeS3VL._AC_SL1500_.jpg', 16, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (228, 'Razer BlackShark V2 Pro (2023 Edition) WirelessHeadset', 5054600, 'Razer HyperClear Super Wideband Mic, TriForce Titanium 50mm Drivers, Up to 70 hours', 'https://images-na.ssl-images-amazon.com/images/I/71Z9KK9-zvL.jpg', 18, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (229, 'Samsung 990 PRO PCIe 4.0 NVMe M.2 SSD 2TB', 4546600, '2TB, Up to 7450 MB/s, Up to 6900 MB/s, Samsung Pascal Controller', 'https://images.samsung.com/is/image/samsung/p6pim/ca_fr/mz-v9p2t0b-am/gallery/ca-fr-990pro-nvme-m2-ssd-mz-v9p2t0b-am-534208574?$650_519_PNG$', 6, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (230, 'Samsung 990 EVO PCIe 4.0 x4 / 5.0 x2 M.2 SSD 1TB', 2260600, '1TB, Up to 5000 MB/s, Up to 4200 MB/s', 'https://images.samsung.com/is/image/samsung/p6pim/ca/mz-v9e1t0b-am/gallery/ca-990-evo-nvme-m2-ssd-mz-v9e1t0b-am-539584186?$650_519_PNG$', 6, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (231, 'Samsung T7 Shield Portable SSD 2TB', 4292600, '2TB, USB 3.2 Gen 2 (10Gbps), IP65 water & dust resistant, 3-meter drop proof', 'https://down-ph.img.susercontent.com/file/sg-11134275-7rd6w-m7rcerx9s5nrbc', 6, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (232, 'Samsung Odyssey OLED G9 (G95SC) Gaming Monitor', 40614600, '49-inch Curved Ultra-wide, 5120x1440 (Dual QHD), 240Hz, 0.03ms (GtG)', 'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/865cf1ba-8917-48bf-b4e7-31c5e5f8427c.jpg', 7, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (233, 'Samsung Odyssey Ark Gen 2 Mini-LED Monitor', 63474600, '55-inch 1000R Curved, 3840x2160 (4K), 165Hz, Yes, rotates vertically', 'https://images-na.ssl-images-amazon.com/images/I/81nwxTmzMRL.jpg', 7, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (234, 'Samsung Galaxy Buds3 Pro', 6324600, 'Hi-Fi 24-BOOLEAN Ultra High Quality Audio, Adaptive Noise Cancelling with Blade Lights, Stem style ergonomic fit', 'https://www.pricekeeda.com/uploads/product/57686/samsung-galaxy-buds-3-pro6a6a36fbe503e.jpg', 18, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (235, 'Kingston FURY Renegade DDR5 RGB 32GB (2x16GB) 7200MHz', 4292600, '32GB Kit, 7200 MT/s, CL38-44-44, 1.45V', 'https://img.evetech.co.za/repository/ProductImages/kingston-fury-renegade-rgb-32gb-7200mhz-ddr5-black-memory-1600px-v1-01.webp', 3, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (236, 'Kingston FURY Beast DDR5 32GB (2x16GB) 6000MHz', 3022600, '32GB Kit, 6000 MT/s, AMD EXPO / Intel XMP 3.0 certified', 'https://m.media-amazon.com/images/I/717cPftxQgL._AC_.jpg', 3, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (237, 'Kingston KC3000 PCIe 4.0 NVMe M.2 SSD 2TB', 3911600, '2TB, Up to 7000 MB/s, Up to 7000 MB/s, Phison E18', 'https://www.onoff.az/storage/uploads/products/onoff-2026-01-15t231256269-32101.jpg', 6, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (238, 'Kingston NV2 PCIe 4.0 NVMe M.2 SSD 1TB', 1625600, '1TB, Up to 3500 MB/s, Up to 2100 MB/s, M.2 2280', 'https://images.kabum.com.br/produtos/fotos/sync_mirakl/400812/SSD-1TB-Kingston-Nv2-M-2-2280-PCIe-NVMe-Leitura-3500MB-s-Grava-o-2100MB-s-Snv2s-1000g_1730146919_gg.jpg', 6, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (239, 'Kingston FURY Impact DDR5 SO-DIMM 32GB (2x16GB) 5600MHz', 3149600, 'Laptop Memory (SO-DIMM), 32GB Kit, 5600 MT/s', 'http://extra.md/public/products/thumbs/205027_32gb-ddr55600mhz-sodimm-kingston-fury-impact-9857901454477.jpg', 3, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (240, 'WD Red Pro NAS Internal Hard Drive 12TB', 7594600, '12TB, 7200 RPM, 256MB, SATA 6 Gb/s', 'https://c1.neweggimages.com/ProductImage/22-234-375-01.png', 11, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (241, 'Seagate IronWolf Pro 16TB NAS HDD', 8356600, '16TB, 550TB/year, Rotational Vibration (RV) sensors', 'https://www.bhphotovideo.com/images/fb/seagate_st16000nt001_16tb_ironwolf_pro_7200_1760984.jpg', 11, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (242, 'Noctua NH-D15 chromax.black Dual-Tower Cooler', 3022600, '2x NF-A15 HS-PWM fans, Full black design, Intel LGA1700/AM5 ready', 'https://os-jo.com/image/cache/catalog/products/ANOCTUA/NH-D15-BLACK/BLACK-1200x1200.JPEG', 14, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (243, 'NZXT H9 Flow Dual-Chamber Mid-Tower', 4038600, 'Wrap-around tempered glass pane, 4x F120Q Airflow fans, Up to 435mm', 'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6529/6529623cv11d.jpg', 13, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (244, 'NZXT Kraken Elite 360 RGB Liquid Cooler', 7594600, '360mm aluminum radiator, 2.36-inch wide-angle TFT-LCD display, 640x640 pixels', 'https://img.terabyteshop.com.br/produto/g/water-cooler-nzxt-kraken-elite-360-rgb-360mm-aio-lcd-display-black-intel-amd-rl-kr36e-b1_191056.jpg', 14, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (245, 'SteelSeries Arctis Nova Pro Wireless Headset', 8864600, 'Nova Pro Acoustic System, Active Noise Cancellation with Transparency Mode, Dual Battery Infinity System', 'https://images.hometheaterreview.com/htr-stateless/2025/07/646a3e4a-steelseries-arctis-nova-pro-wireless-gaming-headset-scaled.jpg', 18, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (246, 'BenQ ZOWIE XL2566K 360Hz Esports Gaming Monitor', 15214600, '24.5-inch TN Panel, 360Hz, DyAc+ Technology motion blur reduction', 'https://i5.walmartimages.com/seo/BenQ-Zowie-XL2566K-24-5-Full-HD-LED-Gaming-LCD-Monitor-16-9-Dark-Gray-25-Class-Twisted-nematic-TN-1920-x-1080-360-Hz-Refresh-Rate-HDMI-VGA_32328961-779f-43fb-a23d-fb7b19ecd928.af62677c5cd0ab4869b62b7f1893f8ea.jpeg', 7, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (247, 'Sony WH-1000XM5 Wireless Noise CancelingHeadphones', 10134600, 'Integrated Processor V1 & HD Noise CancelingProcessor QN1, 8 microphones for extreme voice pick up, Up to 30 hours total life', 'https://d1ncau8tqf99kp.cloudfront.net/converted/103364_original_local_1200x1050_v3_converted.webp', 18, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (248, 'Crucial Pro DDR5 48GB (2x24GB) 5600MHz Kit', 3784600, '48GB Kit, 5600 MT/s, Low-profile aluminum black heatsink', 'https://a.allegroimg.com/original/116f3d/93c9c04d46c29c03260e9a12823a/SUPER-Pamiec-DDR5-Crucial-Pro-48GB-2x24GB-5600MHz-XMP-3-0-AMD-EXPO', 3, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (249, 'Fractal Design North Charcoal Black WoodMid-Tower', 3530600, 'Real walnut wood front panel struts, Mesh or Tempered Glass available, 2x Aspect 14 PWM fans', 'https://m.media-amazon.com/images/I/71MSloBQcCL._AC_.jpg', 13, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (250, 'Lian Li O11 Dynamic EVO RGB Black', 4292600, 'Dual-chamber adjustable ATX case, Two L-shaped diffuse LED RGB strips, Reversible design architecture', 'https://gitec.ge/images/thumbs/0073589_g99o11dergbx00.jpeg', 13, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (251, 'Lian Li UNI FAN TL LCD 120 Triple Pack Black', 3784600, '120mm fans, Built-in 1.6-inch LCD screen on center fan, Daisy-chain interlocking mechanism', 'https://microless.com/cdn/products/01a0bf24eea1fcdb39621ce8e43485f5-hi.jpg', 15, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (252, 'EVGA SuperNOVA 1000 G7 Gold Modular PSU', 4800600, '1000W, 80 PLUS Gold Certified, Ultra-compact 130mm chassis size', 'https://avaxos.com/wp-content/uploads/2022/12/EVGA-SuperNOVA-1000-G7-220-G7-1000-X1-1000-W-ATX12V-EPS12V-SLI-CrossFire-80-PLUS-GOLD-Certified-Full-Modular-Active-PFC-Power-Supply-main.jpg', 12, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (253, 'DeepCool AK620 Digital Dual-Tower Air Cooler', 2006600, 'Real-time temperature and usage status top screen, 2x FK120 fluid dynamic bearing fans, 6x 6mm copper heatpipes', 'https://down-my.img.susercontent.com/file/cn-11134207-7qukw-lfqke8nuk8jva1', 14, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (254, 'Thermalright Peerless Assassin 120 SE AirCooler', 990600, 'Dual tower heatsink design, 2x TL-C12C 120mm PWM fans, 155mm standard height', 'https://media.ldlc.com/r1600/ld/products/00/06/08/36/LD0006083698.jpg', 14, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (255, 'Be Quiet! Dark Power 13 1000W Titanium ATX 3.0PSU', 7340600, '1000W, 80 PLUS Titanium (up to 95.8%), Frameless Silent Wings fan optimization', 'https://hwbusters.com/wp-content/uploads/2023/05/be-quiet-Dark-Power-13-1000W.jpg', 12, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (256, 'Intel Core Ultra 7 265F (Tray)', 12000000, 'TDP: 125W', 'https://med.greatecno.com/1526371-large_default/intel-s1851-core-ultra-7-265f-tray.jpg', 1, 97, '6/27/2026 12:52:49 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (257, 'Intel Core i5 12400F / 2.5GHz Turbo 4.4GHz (TRAY) - CHÍNH HÃNG', 2500000, 'TDP: 65W', 'https://cdn.hstatic.net/products/200000837185/12400f_tray_e59465bf117e4e778e5f568c39bc32b9_grande.png', 1, 100, '6/27/2026 12:52:50 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (258, 'Intel Core i7 14700F (Tray)', 9500000, 'TDP: 65W', 'https://zicomputer.com/wp-content/uploads/2026/01/14700f-Tray-768x768.png', 1, 100, '6/27/2026 12:52:50 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (259, 'GIGABYTE Z890 EAGLE WIFI7 (DDR5)', 7500000, 'TDP: 40W', 'https://m.media-amazon.com/images/I/81G2my+RKeL._AC_.jpg', 5, 97, '6/27/2026 12:52:50 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (260, 'GIGABYTE H610M-H V3 (DDR4)', 1800000, 'TDP: 30W', 'https://media.ldlc.com/r1600/ld/products/00/06/12/72/LD0006127276.jpg', 5, 100, '6/27/2026 12:52:51 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (261, 'GIGABYTE B760M GAMING PLUS WIFI DDR4', 3500000, 'TDP: 40W', 'https://m.media-amazon.com/images/I/81pSTc-GhVL._AC_SL1500_.jpg', 5, 100, '6/27/2026 12:52:51 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (262, 'RAM Kingmax Horizon 16GB DDR5 Bus 5600Mhz', 1200000, 'TDP: 10W', 'https://cdn.hstatic.net/products/1000361104/1_9aef94b8600b4a80a74401e379b2dd4c.jpg', 3, 97, '6/27/2026 12:52:52 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (263, 'Ram KingSpec Heatsink Red 1x16GB DDR4 Bus 3200Mhz', 750000, 'TDP: 10W', 'https://cdn.hstatic.net/products/200000722513/ram-kingspec-heatsink-red-1x16gb-ddr4-bus-3200mhz-1_23edecb668f84ae783d00d77d8a23b83.jpg', 3, 100, '6/27/2026 12:52:52 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (264, 'MSI GeForce RTX 5070 Ti 16GB Shadow 3X OC', 25000000, 'TDP: 250W', 'https://m.media-amazon.com/images/I/71bmZxrahrL._AC_SL1500_.jpg', 10, 99, '6/27/2026 12:52:53 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (265, 'GIGABYTE GeForce RTX 5080 WINDFORCE OC SFF 16G', 35000000, 'TDP: 300W', 'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3886/innergigabyte/images/features-img.png', 10, 98, '6/27/2026 12:52:53 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (266, 'MSI GeForce RTX 5060 Ventus 2X OC 8GB', 8500000, 'TDP: 150W', 'https://asset.msi.com/resize/image/global/product/product_17452877802adc1ee82075afaeea7d2a2dcf366cb9.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 10, 100, '6/27/2026 12:52:54 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (267, 'ZOTAC GeForce RTX 5060 Ti 8GB TWIN EDGE GDDR7', 11000000, 'TDP: 160W', 'https://www.kccshop.vn/media/product/250-13410-vga-zotac-gaming-geforce-rtx-5060-ti-8gb-twin-edge-oc-white-edition--zt-b50610q-10m-_4_main.jpeg', 10, 100, '6/27/2026 12:52:54 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (268, 'Ổ cứng SSD Kingston NV3 1TB M.2 PCIe NVMe Gen4', 1800000, 'TDP: 10W', 'https://m.media-amazon.com/images/I/71ZnK38jZzL.jpg', 8, 97, '6/27/2026 12:52:55 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (269, 'Ổ Cứng SSD KingSpec NVMe 512GB (NE-512)', 800000, 'TDP: 10W', 'https://hmpcstore.com/admin/uploads/O-cung-SSD-KingSpec-NE-512GB-PCIe-Gen3-x4-NVMe-M2-2280-NE-512/20260225_101548_0_699e696480d03_710__ne-5122-1__1__8d84d40669de4ec497acc541f607579f_grande.jpg', 8, 100, '6/27/2026 12:52:55 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (270, 'Corsair RM850e ATX 3.1 - 80 Plus Gold - Full Modular (850W)', 3500000, 'TDP: 0W', 'https://product.hstatic.net/200000722513/product/89689_nguon_may_tinh_corsair_rm850e_atx_006_e59a3ebce3034f23aa2bde43f1d242e5_1024x1024.jpg', 12, 97, '6/27/2026 12:52:56 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (271, 'Cooler Master MWE 650 - 80 Plus Bronze - V3 230V (650W)', 1500000, 'TDP: 0W', 'https://os-jo.com/image/cache/catalog/products/power-supply/MPE-6501-ACAAW-3BUK/81TVrRqQJeL._SL1500_-1200x1200.jpg', 12, 100, '6/27/2026 12:52:56 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (272, 'Nguồn FSP HV PRO 650W - 80 Plus Bronze', 1400000, 'TDP: 0W', 'https://down-vn.img.susercontent.com/file/vn-11134211-820l4-mjf8qo64x91ha6', 12, 100, '6/27/2026 12:52:57 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (273, 'Corsair CX650 - 80 Plus Bronze (650W)', 1600000, 'TDP: 0W', 'https://www.bhphotovideo.com/images/fb/corsair_cp_9020278_na_cx_series_cx650_650w_1808744.jpg', 12, 100, '6/27/2026 12:52:57 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (274, 'Corsair 3500X TG Mid Tower Black', 2000000, 'TDP: 0W', 'https://product.hstatic.net/200000722513/product/3500x_link_blk_01_85b56174d9994a4f8db95482a0b9245f.png', 13, 99, '6/27/2026 12:52:58 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (275, 'Corsair FRAME 4500X RS-R ARGB Panoramic Black', 3500000, 'TDP: 0W', 'https://www.pcstudio.in/wp-content/uploads/2025/09/Corsair-Frame-4500X-RS-R-ARGB-Panoramic-Glass-Mid-Tower-E-ATX-Cabinet-Black-2-600x600.webp', 13, 98, '6/27/2026 12:52:58 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (276, 'Tản nhiệt AIO Corsair NAUTILUS 360 ARGB Black', 2800000, 'TDP: 15W', 'https://phucanhcdn.com/media/product/58804_tan_nhiet_nuoc_aio_corsair_nautilus_360_argb_black_cw_9060093_ww_2.jpg', 9, 97, '6/27/2026 12:52:59 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (277, 'Cooler Master Hyper 212 Spectrum V3 ARGB', 600000, 'TDP: 5W', 'https://m.media-amazon.com/images/I/71gBjYy2vfL._SL1500_.jpg', 9, 99, '6/27/2026 12:52:59 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (278, 'Intel Core i9 14900K (Tray)', 14000000, 'TDP: 125W', 'https://pcngon.vn/wp-content/uploads/2024/11/CPU-Intel-Core-i9-14900K-Tray-2.4GHz-Turbo-5.8GHz-24-nhan-32-luong-1.jpg', 1, 100, '6/27/2026 1:16:14 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (279, 'Intel Core Ultra 9 285K', 16500000, 'TDP: 125W', 'https://www.techpowerup.com/review/intel-core-ultra-9-285k/images/package.jpg', 1, 50, '6/27/2026 1:16:14 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (280, 'ASUS ROG MAXIMUS Z790 HERO', 15000000, 'TDP: 60W', 'https://dlcdnwebimgs.asus.com/gain/A3777166-EF70-4D33-915B-EC65CF77CAE5', 5, 100, '6/27/2026 1:16:16 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (281, 'ProArt Z790-CREATOR WIFI', 12000000, 'TDP: 55W', 'https://dlcdnwebimgs.asus.com/gain/fe64f38f-9f58-4722-b2b0-723379b316be/', 5, 100, '6/27/2026 1:16:16 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (282, 'Corsair Dominator Titanium 64GB', 6500000, 'TDP: 15W', 'https://m.media-amazon.com/images/I/611o1NX2HvL._AC_SL1500_.jpg', 3, 100, '6/27/2026 1:16:18 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (283, 'G.Skill Trident Z5 64GB DDR5', 5500000, 'TDP: 15W', 'https://c1.neweggimages.com/ProductImageCompressAll1280/20-374-432-07.png', 3, 100, '6/27/2026 1:16:18 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (284, 'ASUS ROG Strix RTX 5090 24GB', 65000000, 'TDP: 450W', 'https://cdn-ru.bitrix24.ru/b11322588/landing/90e/90ed69e925e824a07ca15eb1b5d9bc42/asus_rog_astral_geforce_rtx_5090_32gb_gddr7_oc_edition_16_1x.png', 10, 100, '6/27/2026 1:16:33 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (285, 'Samsung 990 PRO 2TB', 4500000, 'TDP: 15W', 'https://images.samsung.com/is/image/samsung/p6pim/ca_fr/mz-v9p2t0b-am/gallery/ca-fr-990pro-nvme-m2-ssd-mz-v9p2t0b-am-534208574?$650_519_PNG$', 8, 100, '6/27/2026 1:16:34 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (286, 'ROG Ryujin III 360 ARGB', 8500000, 'TDP: 20W', 'https://static.nb.com.ar/i/nb_WATER-COOLER-ASUS-ROG-RYUJIN-III-360-ARGB-EXTREME_export_8a547ab1b93ed328764c69a3da19902e.png', 9, 109, '6/27/2026 1:16:36 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (287, 'Thẻ nhớ SanDisk Extreme Pro 128GB MicroSDXC UHS-I 200MB/s', 650000, 'TDP: 2W', 'https://bizweb.dktcdn.net/100/533/247/products/1658758849-1692696.jpg?v=1754561963193', 4, 100, '7/23/2026 10:00:00 AM', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (288, 'Thẻ nhớ Samsung PRO Plus 256GB MicroSDXC kèm Đầu đọc USB', 950000, 'TDP: 2W', 'https://bizweb.dktcdn.net/thumb/grande/100/490/762/products/the-nho-microsdxc-samsung-pro-plus-u3-256gb-05-jpg-v-1715014985150-jpg-v-1715201603263.jpg?v=1716191494470', 4, 80, '7/23/2026 10:00:00 AM', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (289, 'Thẻ nhớ Lexar Professional 1066x 512GB MicroSDXC UHS-I', 1450000, 'TDP: 3W', 'https://bizweb.dktcdn.net/thumb/grande/100/410/941/products/76-8b907773-3ff2-4428-8d53-14023cd3a1ad.jpg?v=1747886462133', 4, 50, '7/23/2026 10:00:00 AM', 'Lexar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (290, 'Thẻ nhớ Kingston Canvas Go! Plus 128GB SDXC UHS-I', 580000, 'TDP: 2W', 'https://m.media-amazon.com/images/I/613WVdJQi4L._AC_SL1500_.jpg', 4, 120, '7/23/2026 10:00:00 AM', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (291, 'Thẻ nhớ SanDisk Ultra SDXC 64GB 140MB/s Class 10', 280000, 'TDP: 1W', 'https://bizweb.dktcdn.net/100/513/826/products/web-bia-the-sd-trang-xam-64gb.png?v=1767153744330', 4, 150, '7/23/2026 10:00:00 AM', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (292, 'Thẻ nhớ Transcend SDXC 330S 128GB High Speed 100MB/s', 520000, 'TDP: 2W', 'https://www.ryans.com/storage/products/main/transcend-330s-sdxc-128gb-uhs-i-u3v30-sd-card-11598097033.webp', 4, 90, '7/23/2026 10:00:00 AM', 'Transcend');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (293, 'Thẻ nhớ ProGrade Digital SDXC UHS-II V60 256GB', 2800000, 'TDP: 3W', 'https://haliti.com.vn/wp-content/uploads/2023/05/the-nho-prograde-digital-SDXC-UHS-II-V60-250R-256gb-haliti-01.jpg', 4, 30, '7/23/2026 10:00:00 AM', 'ProGrade');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (294, 'Thẻ nhớ Sony TOUGH SF-G Series 128GB SDXC UHS-II 300MB/s', 4200000, 'TDP: 3W', 'https://cdn.vjshop.vn/phu-kien-nhiep-anh/the-nho/the-sd/the-nho-sony-sdxc-128gb-sf-g-series-tough-uhs-ii/sony-sdxc-128gb-sf-g-series-tough-uhs-ii.jpg', 4, 25, '7/23/2026 10:00:00 AM', 'Sony');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (295, 'Thẻ nhớ Kioxia Exceria High Endurance 128GB MicroSD', 480000, 'TDP: 2W', 'https://down-vn.img.susercontent.com/file/7c27727c494736672bf44eba923860dd', 4, 110, '7/23/2026 10:00:00 AM', 'Kioxia');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (296, 'Thẻ nhớ TeamGroup GO Card MicroSDXC 256GB 100MB/s', 720000, 'TDP: 2W', 'https://images.teamgroupinc.com/products/card/microsd/go-card/msdxc/256gb_adpt_01.jpg', 4, 75, '7/23/2026 10:00:00 AM', 'TeamGroup');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (297, 'Ổ cứng di động SSD SanDisk Extreme Portable 1TB USB 3.2 Gen 2', 2650000, 'TDP: 5W', 'https://cdn.tgdd.vn/Products/Images/1902/328432/o-cung-ssd-1tb-sandisk-extreme-portable-sdssde61-thumb-1-1-600x600.jpg', 8, 60, '7/23/2026 10:00:00 AM', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (298, 'Ổ cứng di động Samsung T7 Shield 2TB Type-C Chống sốc IP65', 4850000, 'TDP: 5W', 'https://media.karousell.com/media/photos/products/2023/10/20/samsung_t7_shield_2tb_beige_co_1697782299_2da3fdf9.jpg', 8, 45, '7/23/2026 10:00:00 AM', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (299, 'Ổ cứng di động HDD WD My Passport 2TB USB 3.0 Black', 1950000, 'TDP: 5W', 'https://atechworld.vn/wp-content/uploads/2024/01/wd-my-passport-2tb-1-1.jpg', 8, 80, '7/23/2026 10:00:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (300, 'Ổ cứng di động SSD Crucial X9 Pro 1TB 1050MB/s Vỏ nhôm', 2450000, 'TDP: 4W', 'https://tuanphong.vn/pictures/full/2024/06/1717476599-965-crucial-x9pro-d.jpg', 8, 50, '7/23/2026 10:00:00 AM', 'Crucial');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (301, 'Ổ cứng gắn ngoài HDD Seagate Expansion Desktop 8TB 3.5 inch', 4900000, 'TDP: 10W', 'https://down-id.img.susercontent.com/file/id-11134207-7r992-lz4iwty51s8092', 8, 30, '7/23/2026 10:00:00 AM', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (302, 'Ổ cứng di động HDD Lacie Rugged Mini 2TB USB 3.0 Chống dằn xóc', 2800000, 'TDP: 5W', 'https://techland.com.vn/public_folder/folder_image/uploads/2020/05/lacie-rugged-mini-usb-3.0-2.jpg', 8, 40, '7/23/2026 10:00:00 AM', 'LaCie');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (303, 'Ổ cứng di động SSD Kingston XS2000 1TB Type-C 2000MB/s Siêu nhỏ', 2950000, 'TDP: 5W', 'https://lagihitech.vn/wp-content/uploads/2024/04/o-cung-di-dong-SSD-Kingston-XS2000-1TB-SXS20001000G-hinh-1.jpg', 8, 35, '7/23/2026 10:00:00 AM', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (304, 'Ổ cứng di động HDD Transcend StoreJet 25M3 1TB Chống sốc 3 lớp', 1650000, 'TDP: 5W', 'https://enhakkore.net/wp-content/uploads/2018/07/TRANSCEND-1TB.jpg', 8, 70, '7/23/2026 10:00:00 AM', 'Transcend');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (305, 'Ổ cứng di động SSD Corsair EX100U 2TB Type-C USB 3.2 Gen2x2', 4200000, 'TDP: 5W', 'https://badudeal.lk/wp-content/uploads/2024/08/Corsair-EX100U-2TB-Type-C-Portable-SSD-srilanka-badudeal.lk-1.jpg', 8, 25, '7/23/2026 10:00:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (306, 'Ổ cứng di động SSD ADATA SE880 1TB Type-C 2000MB/s', 2550000, 'TDP: 4W', 'https://down-sg.img.susercontent.com/file/sg-11134207-7rdx0-lxxvt9dyai734a', 8, 55, '7/23/2026 10:00:00 AM', 'ADATA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (307, 'Tản nhiệt nước AIO NZXT Kraken Elite 360 RGB White LCD', 7250000, 'TDP: 15W', 'https://product.hstatic.net/200000722513/product/5355_7e4c62dc59808d76fe2dd8761e5da62f_8b9ca30e5f3c42178f638746bb8d10b3_a782d54587d04d07ad4738b03d12565a_1024x1024.jpg', 9, 30, '7/23/2026 10:00:00 AM', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (308, 'Tản nhiệt nước AIO Corsair iCUE LINK H150i LCD White 360mm', 6800000, 'TDP: 15W', 'https://philong.com.vn/media/product/31944-tan-nhiet-nuoc-cpu-aio-corsair-icue-link-h150i-rgb-360mm-white-cw-9061006-ww-philong--10-.jpg', 9, 25, '7/23/2026 10:00:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (309, 'Tản nhiệt nước AIO ASUS ROG Ryujin III 360 ARGB White Edition', 8900000, 'TDP: 20W', 'https://cdn.hstatic.net/products/200000522285/71tqdctsyil._sl1500_3d133254025a4566b8a6b75de0177edc.jpg', 9, 20, '7/23/2026 10:00:00 AM', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (310, 'Tản nhiệt nước AIO MSI MAG CORELIQUID E360 Black', 3450000, 'TDP: 12W', 'https://philong.com.vn/media/product/32659-tan-nhiet-nuoc-aio-cpu-msi-mag-coreliquid-e360-black-philong--3-.png', 9, 50, '7/23/2026 10:00:00 AM', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (311, 'Tản nhiệt nước AIO DeepCool LT720 360mm High-Performance', 3650000, 'TDP: 15W', 'https://product.hstatic.net/1000333506/product/n-nuoc-aio-deepcool-lt720-7_33b321d32ef447a4b060ea862d2c3c3a_1024x1024_3d97403a18dd4741a07d41ea8b3e458c.jpg', 9, 40, '7/23/2026 10:00:00 AM', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (312, 'Tản nhiệt nước AIO Lian Li Galahad II Trinity SL-INF 360 White', 4950000, 'TDP: 15W', 'https://m.media-amazon.com/images/I/61GMvzXd7sL.jpg', 9, 35, '7/23/2026 10:00:00 AM', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (313, 'Tản nhiệt nước AIO Cooler Master MasterLiquid 360 Atmos ARGB', 3850000, 'TDP: 12W', 'https://cdn.hstatic.net/products/200000522285/smart_-_2026-01-12t100540.000_c8de32fa2af84740ae8c4a5fb963d322.png', 9, 45, '7/23/2026 10:00:00 AM', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (314, 'Tản nhiệt nước AIO Thermalright Frozen Prism 360 ARGB Black', 1850000, 'TDP: 10W', 'https://product.hstatic.net/200000420363/product/4_fc0894cf23c34545b98c502be9363f3e_master.jpg', 9, 70, '7/23/2026 10:00:00 AM', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (315, 'Tản nhiệt nước AIO Valkyrie GL360 ARGB Màn hình LCD Black', 4200000, 'TDP: 15W', 'https://gland.vn/media/product/15140_81374_t___n_nhi___t_n_____c_valkyrie_gl360___en__2_.jpg', 9, 30, '7/23/2026 10:00:00 AM', 'Valkyrie');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (316, 'Tản nhiệt nước AIO ID-COOLING DASHFLOW 360 Basic Black', 1650000, 'TDP: 10W', 'https://phucanhcdn.com/media/product/51818_tan_nhiet_nuoc_aio_id_cooling_dashflow_360_basic_black_2.jpg', 9, 80, '7/23/2026 10:00:00 AM', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (317, 'Card màn hình GIGABYTE GeForce RTX 4070 Ti SUPER WINDFORCE OC 16G', 23900000, 'TDP: 285W', 'https://static.gigabyte.com/StaticFile/Image/Global/88366f8b8e43ca0066a14728a35e5d28/Product/39125/Png', 10, 25, '7/23/2026 10:00:00 AM', 'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (318, 'Card màn hình ASUS TUF Gaming GeForce RTX 4080 SUPER 16GB GDDR6X', 31500000, 'TDP: 320W', 'https://www.tnc.com.vn/uploads/product/sp2024/card-man-hinh-asus-tuf-rtx4080s-o16g-gaming.jpg', 10, 20, '7/23/2026 10:00:00 AM', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (319, 'Card màn hình MSI GeForce RTX 4060 Ti GAMING X SLIM 16G', 12800000, 'TDP: 165W', 'https://product.hstatic.net/200000722513/product/rtx_4060_ti_gaming_x_slim_16g_a214d2ab8d5b4c72885ff81cf695918d.png', 10, 40, '7/23/2026 10:00:00 AM', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (320, 'Card màn hình ZOTAC GAMING GeForce RTX 4070 SUPER Twin Edge OC 12GB', 16900000, 'TDP: 220W', 'https://halinhcomputer.vn/uploads/images/web-halinh-new/linh-kien-le/vga/zotac/rtx-4070-twin-edge-oc-12gb-gddr6x.png', 10, 35, '7/23/2026 10:00:00 AM', 'ZOTAC');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (321, 'Card màn hình GALAX GeForce RTX 4070 Ti SUPER EX Gamer White 16GB', 24500000, 'TDP: 285W', 'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/4/0/4070-ti-super-ex-gamer-white-0.jpg', 10, 18, '7/23/2026 10:00:00 AM', 'GALAX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (322, 'Card màn hình PowerColor Hellhound AMD Radeon RX 7900 XT 20GB', 21500000, 'TDP: 315W', 'https://m.media-amazon.com/images/I/814keJHzlgL._AC_.jpg', 10, 15, '7/23/2026 10:00:00 AM', 'PowerColor');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (323, 'Card màn hình Sapphire NITRO+ AMD Radeon RX 7800 XT 16GB', 15800000, 'TDP: 263W', 'https://sicomp.vn/_next/image?url=https:%2F%2Fcdn.sicomp.vn%2Fstorage%2Fproduct%2F1323%2F1323_card-man-hinh-sapphire-nitro-amd-radeon-rx-7800-xt_1.jpg&w=2048&q=75', 10, 30, '7/23/2026 10:00:00 AM', 'Sapphire');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (324, 'Card màn hình XFX Speedster MERC 310 AMD Radeon RX 7900 GRE 16GB', 16950000, 'TDP: 260W', 'https://cdn.prod.website-files.com/5d1911406ad3cbdb9924a753/639736d43e89781c8b59f26d_03.jpg', 10, 22, '7/23/2026 10:00:00 AM', 'XFX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (325, 'Card màn hình COLORFUL iGame GeForce RTX 4070 SUPER Ultra W OC 12GB', 17900000, 'TDP: 220W', 'https://nguyencongpc.vn/media/product/26203-z5083848788059_6fd23c6d5c495549bd8c0c3277d7842e_18_11zon.jpg', 10, 28, '7/23/2026 10:00:00 AM', 'COLORFUL');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (326, 'Card màn hình ASRock Phantom Gaming Radeon RX 7700 XT 12GB OC', 12500000, 'TDP: 245W', 'https://pg.asrock.com/Graphics-Card/photo/Radeon%20RX%207700%20XT%20Phantom%20Gaming%2012GB%20OC(L1).png', 10, 30, '7/23/2026 10:00:00 AM', 'ASRock');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (327, 'Ổ cứng HDD PC Seagate Barracuda 2TB 3.5 inch SATA3 7200rpm', 1550000, 'TDP: 6W', 'https://enfield-bd.com/wp-content/uploads/2021/07/SEAGATE-BARRACUDA-2TB-3.5-inch-SATA-5400rpm-Desktop-HDD.png', 11, 100, '7/23/2026 10:00:00 AM', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (328, 'Ổ cứng HDD PC Western Digital Blue 2TB 3.5 inch 7200rpm', 1480000, 'TDP: 6W', 'https://product.hstatic.net/200000837185/product/hddpcwesterndigitalblue2tb3.5-7200rpm256mbcache-wd20ezbx-_bb80957427454f0c8218a4cdf49e4e9b_master.png', 11, 110, '7/23/2026 10:00:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (329, 'Ổ cứng HDD PC Toshiba P300 2TB 3.5 inch SATA3 7200rpm', 1390000, 'TDP: 6W', 'https://hoanghapccdn.com/media/product/5135_hdd_toshiba_p300_2tb_ha2.jpg', 11, 90, '7/23/2026 10:00:00 AM', 'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (330, 'Ổ cứng HDD Server Seagate IronWolf 4TB 3.5 inch NAS SATA3', 2950000, 'TDP: 7W', 'https://maytinhlmc.vn/wp-content/uploads/68620_o_cung_hdd_seagate_ironwolf_4tb_3_5_inch_5400rpm_sata3_256mb_cache_st4000vn006.jpg', 11, 60, '7/23/2026 10:00:00 AM', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (331, 'Ổ cứng HDD Server Western Digital Red Plus 4TB 3.5 inch NAS', 3100000, 'TDP: 7W', 'https://www.tnc.com.vn/uploads/product/sp2026/o-cung-hdd-gan-trong-western-digital-red-plus-4tb-wd40efzz.webp', 11, 55, '7/23/2026 10:00:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (332, 'Ổ cứng HDD Enterprise Seagate Exos X18 16TB 3.5 inch SATA3', 8500000, 'TDP: 9W', 'https://qnapvn.com/o-cung-hdd-seagate-enterprise-exos-35-sata-7e8-16tb-st16000nm000j-2.png', 11, 20, '7/23/2026 10:00:00 AM', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (333, 'Ổ cứng HDD Enterprise Western Digital Gold 8TB 3.5 inch 7200rpm', 5900000, 'TDP: 8W', 'https://mygear.io.vn/media/product/6102-wd-gold-3-5.jpg', 11, 30, '7/23/2026 10:00:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (334, 'Ổ cứng HDD PC Toshiba X300 4TB 7200rpm Gaming Internal', 3250000, 'TDP: 8W', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/93/MTA-9352335/toshiba_toshiba_x300_4tb_sata_3_cache_128mb_7200rpm_-_hdd_internal_pc_full03_mcg4oh8k.jpg', 11, 40, '7/23/2026 10:00:00 AM', 'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (335, 'Ổ cứng HDD PC Western Digital Black 1TB 3.5 inch Performance', 1850000, 'TDP: 7W', 'https://kccshop.vn/media/product/250-948-9192_hdd_western_caviar_black_1tb_7200rpm_sata3_6gbs_64mb_cache_01.jpg', 11, 75, '7/23/2026 10:00:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (336, 'Ổ cứng HDD Camera Seagate SkyHawk 4TB 3.5 inch Surveillance', 2650000, 'TDP: 6W', 'https://enssecurity.com/wp-content/uploads/2023/07/C-HDD4000-VX-v2.jpg', 11, 80, '7/23/2026 10:00:00 AM', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (337, 'Nguồn Corsair RM750e ATX 3.0 80 Plus Gold Full Modular (750W)', 2850000, 'TDP: 0W', 'https://product.hstatic.net/200000722513/product/earvn-nguon-may-tinh-corsair-rm750e-atx-3.0-80-plus-gold-full-modula-1_5cd29a9f71ef4d18b2dcc67481d01eb0_master.png', 12, 60, '7/23/2026 10:00:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (338, 'Nguồn MSI MAG A750GL PCIE5 750W 80 Plus Gold Full Modular', 2650000, 'TDP: 0W', 'https://m.media-amazon.com/images/I/71Bp8cXNjeL._AC_.jpg', 12, 70, '7/23/2026 10:00:00 AM', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (339, 'Nguồn GIGABYTE UD850GM PG5 850W 80 Plus Gold PCIe 5.0', 3100000, 'TDP: 0W', 'https://bermorzone.com.ph/wp-content/uploads/2022/12/GP-UD850GM-PG5-ph.webp', 12, 50, '7/23/2026 10:00:00 AM', 'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (340, 'Nguồn ASUS TUF Gaming 750W 80 Plus Bronze', 2150000, 'TDP: 0W', 'https://songphuong.vn/Content/uploads/2025/06/TUF-Gaming-750W-Bronze-1.webp', 12, 80, '7/23/2026 10:00:00 AM', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (341, 'Nguồn Cooler Master MWE Gold 850 V2 Full Modular (850W)', 2950000, 'TDP: 0W', 'https://songphuong.vn/Content/uploads/2021/08/Nguon-Cooler-Master-MWE-GOLD-850-V2-Full-Modular-850W-songphuong.vn_.jpg', 12, 65, '7/23/2026 10:00:00 AM', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (342, 'Nguồn DeepCool PL750D 750W 80 Plus Bronze ATX 3.0 Native', 1750000, 'TDP: 0W', 'https://phucanhcdn.com/media/product/61221_nguon_may_tinh_deepcool_pl750d_750w_80_plus_bronze_atx_3_0_pcie_5_5.jpg', 12, 90, '7/23/2026 10:00:00 AM', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (343, 'Nguồn Super Flower Leadex III Gold 850W ARGB Full Modular', 3450000, 'TDP: 0W', 'https://down-my.img.susercontent.com/file/27e5251ee99cf1d947ce9d44aacbb258', 12, 40, '7/23/2026 10:00:00 AM', 'Super Flower');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (344, 'Nguồn Seasonic Focus GX-850 850W 80 Plus Gold Full Modular', 3650000, 'TDP: 0W', 'https://ph-test-11.slatic.net/p/a55f2beca5e25fccaa8c429a122cbe72.jpg', 12, 45, '7/23/2026 10:00:00 AM', 'Seasonic');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (345, 'Nguồn FSP Hydro G PRO 850W PCIe5.0 80 Plus Gold', 3350000, 'TDP: 0W', 'https://smart1ech.com/wp-content/uploads/2023/10/www.fspgroupusa.com-HG2-850W-5G-36.png', 12, 50, '7/23/2026 10:00:00 AM', 'FSP');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (346, 'Nguồn Thermaltake Toughpower GF A3 850W Gold ATX 3.0', 2950000, 'TDP: 0W', 'https://maytinhlmc.vn/wp-content/uploads/81083_ngu___n_thermaltake_toughpower_gf_a3_850w__2_.jpg', 12, 55, '7/23/2026 10:00:00 AM', 'Thermaltake');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (347, 'Vỏ case NZXT H6 Flow RGB Dual-Chamber Mid-Tower Black', 3450000, 'TDP: 0W', 'https://c1.neweggimages.com/productimage/nb1280/11-146-359-05.jpg', 13, 40, '7/23/2026 10:00:00 AM', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (348, 'Vỏ case Lian Li O11 Vision Tempered Glass Mid-Tower White', 3950000, 'TDP: 0W', 'https://i5.walmartimages.com/seo/LIAN-LI-O11-Vision-White-Aluminum-Steel-Tempered-Glass-ATX-Mid-Tower-Computer-Case-O11VW_8a75551b-e1fb-4b80-8cd4-a1db5126b46a.8bf544a2a9b5dedc9213b95788327938.jpeg', 13, 35, '7/23/2026 10:00:00 AM', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (349, 'Vỏ case Corsair 4000D AIRFLOW Tempered Glass Mid-Tower Black', 2150000, 'TDP: 0W', 'https://m.media-amazon.com/images/I/81hL4tPkXZL._AC_SL1500_.jpg', 13, 80, '7/23/2026 10:00:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (350, 'Vỏ case Montech KING 95 PRO Panoramic Curved Glass ARGB Black', 3650000, 'TDP: 0W', 'https://www.scan.co.uk/images/infopages/montech/case/KING_95/PRO/Black/zenith.png', 13, 30, '7/23/2026 10:00:00 AM', 'Montech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (351, 'Vỏ case HYTE Y60 Panoramic Dual Chamber Glass Black/Red', 5450000, 'TDP: 0W', 'https://meststores.com/wp-content/uploads/2026/02/hyte-y60-dual-chamber-panoramic-mid-tower-atx-case-with-pcie-40-riser-black-red-front.webp', 13, 20, '7/23/2026 10:00:00 AM', 'HYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (352, 'Vỏ case Antec C8 Dual-Chamber Full Tower Black', 2850000, 'TDP: 0W', 'https://dynaquestpc.com/cdn/shop/files/146_95625c7a-de2e-4025-8358-3a91733300f2.png?v=1714810776&width=1214', 13, 45, '7/23/2026 10:00:00 AM', 'Antec');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (353, 'Vỏ case Fractal Design Pop Air RGB TG Black', 2450000, 'TDP: 0W', 'https://mygear.io.vn/media/product/9794-vo-case-fractal-design-pop-air-rgb-black-tg-clear-4.png', 13, 50, '7/23/2026 10:00:00 AM', 'Fractal Design');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (354, 'Vỏ case DeepCool CH560 DIGITAL ARGB Màn hình nhiệt độ Black', 2650000, 'TDP: 0W', 'https://pcx.vn/uploads/auto/2026/04/1776672416806-6a71e019-fb8c-4871-b6be-887832440afe.jpg', 13, 60, '7/23/2026 10:00:00 AM', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (355, 'Vỏ case Xigmatek ENDORPHIN ULTRA ARTIC White Panoramic', 1450000, 'TDP: 0W', 'https://nvs.tn-cdn.net/2023/08/vo-case-xigmatek-endorphin-ultra-arctic_01.jpg', 13, 90, '7/23/2026 10:00:00 AM', 'Xigmatek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (356, 'Vỏ case Phanteks NV5 Mid-Tower ARGB Black Glass', 2750000, 'TDP: 0W', 'https://images.tokopedia.net/img/cache/900/VqbcmM/2023/11/30/459f4cd1-d894-4066-a304-09372696e580.jpg', 13, 40, '7/23/2026 10:00:00 AM', 'Phanteks');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (357, 'Tản nhiệt khí Thermalright Peerless Assassin 120 SE ARGB', 980000, 'TDP: 5W', 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mde35e6fewkcc0', 14, 100, '7/23/2026 10:00:00 AM', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (358, 'Tản nhiệt khí DeepCool AK400 Digital ARGB Màn hình LED Black', 1150000, 'TDP: 4W', 'https://product.hstatic.net/200000420363/product/deepcool-ak400-digital-digital_1a29672f9455490686f5c03cc43dba45_master.png', 14, 80, '7/23/2026 10:00:00 AM', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (359, 'Tản nhiệt khí Noctua NH-D15 chromax.black Dual-Tower Premium', 2950000, 'TDP: 5W', 'https://os-jo.com/image/cache/catalog/products/ANOCTUA/NH-D15-BLACK/BLACK-1200x1200.JPEG', 14, 35, '7/23/2026 10:00:00 AM', 'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (360, 'Tản nhiệt khí ID-COOLING SE-224-XT ARGB V2 Black', 520000, 'TDP: 3W', 'https://product.hstatic.net/200000536009/product/37_b652d34513cc4cdbb4cb8273d1c4f01b_master.jpg', 14, 120, '7/23/2026 10:00:00 AM', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (361, 'Tản nhiệt khí Cooler Master Hyper 622 Halo Black ARGB Dual-Tower', 1350000, 'TDP: 5W', 'https://kccshop.vn/media/product/250-5123-1.jpg', 14, 60, '7/23/2026 10:00:00 AM', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (362, 'Tản nhiệt khí Jonsbo CR-1000 EVO ARGB Black', 380000, 'TDP: 3W', 'https://nvs.tn-cdn.net/2023/07/tan-nhiet-khi-jonsbo-cr-1000-evo-argb-6.jpg', 14, 150, '7/23/2026 10:00:00 AM', 'Jonsbo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (363, 'Tản nhiệt khí Thermalright Phantom Spirit 120 EVO 7 Heatpipes', 1280000, 'TDP: 5W', 'https://mygear.io.vn/media/product/9540-tan-nhiet-khi-thermalright-phantom-spirit-120-evo-1.jpg', 14, 75, '7/23/2026 10:00:00 AM', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (364, 'Tản nhiệt khí Be Quiet! Dark Rock Pro 5 Dual Tower', 2450000, 'TDP: 5W', 'https://basic-tutorials.de/wp-content/uploads/2023/11/20231031-IMG_5208.jpg', 14, 40, '7/23/2026 10:00:00 AM', 'Be Quiet!');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (365, 'Tản nhiệt khí PCCOOLER K6 Digital Display ARGB Dual Tower', 1050000, 'TDP: 4W', 'https://lookaside.fbsbx.com/lookaside/crawler/media/?media_id=2404382830021734', 14, 65, '7/23/2026 10:00:00 AM', 'PCCOOLER');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (366, 'Tản nhiệt khí Valkyrie SL125 ARGB Màn hiển thị nhiệt độ', 950000, 'TDP: 4W', 'https://down-vn.img.susercontent.com/file/vn-11134201-23030-bngm8wm2wjov2c', 14, 70, '7/23/2026 10:00:00 AM', 'Valkyrie');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (367, 'Bộ 3 Fan tản nhiệt Lian Li UNI FAN SL-Infinity 120 ARGB Triple Black', 2450000, 'TDP: 3W', 'https://product.hstatic.net/200000522285/product/_fan_ghep_noi_khong_day__toc_2100rpm__pwm__fan_case_sl120_tpassionvn_1_76a2eab92dd74027a0eed0c5552a6b4d.jpg', 15, 50, '7/23/2026 10:00:00 AM', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (368, 'Bộ 3 Fan tản nhiệt Corsair iCUE LINK QX120 RGB Starter Kit White', 3650000, 'TDP: 4W', 'https://www.scan.co.uk/images/infopages/corsair_fans/QX120/starterkit/topimgw.png', 15, 40, '7/23/2026 10:00:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (369, 'Bộ 3 Fan tản nhiệt NZXT Duo F120 RGB Triple Pack Black', 2150000, 'TDP: 3W', 'https://media.ldlc.com/r1600/ld/products/00/06/01/35/LD0006013533.jpg', 15, 60, '7/23/2026 10:00:00 AM', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (370, 'Bộ 3 Fan tản nhiệt Thermalright TL-C12C-S ARGB Triple Pack Black', 480000, 'TDP: 2W', 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltf6s8b4fdai9f', 15, 120, '7/23/2026 10:00:00 AM', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (371, 'Bộ 3 Fan tản nhiệt DeepCool FC120 3-in-1 ARGB Black', 850000, 'TDP: 3W', 'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mm8bqpv4eu4l83', 15, 80, '7/23/2026 10:00:00 AM', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (372, 'Bộ 3 Fan tản nhiệt Phanteks D30-120 Reverse Airflow Triple Black', 2250000, 'TDP: 3W', 'https://www.tncstore.vn/media/product/250-13877-quat-tan-nhiet-phanteks-d30-120mm-reversed-drgb-black-triple-pack-1.jpg', 15, 45, '7/23/2026 10:00:00 AM', 'Phanteks');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (373, 'Bộ 3 Fan tản nhiệt ID-COOLING XF-12025 ARGB Trio Pack', 550000, 'TDP: 2W', 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltjplsx9zeh679', 15, 100, '7/23/2026 10:00:00 AM', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (374, 'Bộ 3 Fan tản nhiệt Cooler Master MasterFan MF120 Halo2 ARGB White', 1350000, 'TDP: 3W', 'https://product.hstatic.net/200000722513/product/63609_halo3in1_white_2fe56efd09ad4358bc9bffe694dc34c0_ae18db62db9a4b17b2544370f1bf7da0_master.jpg', 15, 70, '7/23/2026 10:00:00 AM', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (375, 'Bộ 3 Fan tản nhiệt Antec Fusion 120 ARGB Triple Pack', 780000, 'TDP: 2W', 'https://pccaus.com/storage/media/vFHpsQH3nrKiKePf8QVaftKHHn8IKXI2clabBCo6.jpeg', 15, 90, '7/23/2026 10:00:00 AM', 'Antec');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (376, 'Bộ 3 Fan tản nhiệt Montech AX120 PWM ARGB Pack White', 650000, 'TDP: 2W', 'https://cdn1.centrecom.com.au/images/upload/0186713_0.jpeg', 15, 95, '7/23/2026 10:00:00 AM', 'Montech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (377, 'Bàn phím cơ AKKO 3087 v2 Silent Bluetooth 5.0 / Wireless 2.4G', 1450000, 'TDP: 1W', 'https://akko.vn/wp-content/uploads/2021/10/ban-phim-co-akko-3087-v2-steam-engine-01.jpg', 16, 60, '7/23/2026 10:00:00 AM', 'AKKO');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (378, 'Bàn phím cơ Keychron V1 Max Wireless Custom Mechanical Keyboard Hotswap', 2250000, 'TDP: 2W', 'https://product.hstatic.net/200000837185/product/1_a00c416b2b034ee39022badcfd3f6e91_grande.png', 16, 50, '7/23/2026 10:00:00 AM', 'Keychron');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (379, 'Bàn phím cơ Royal Kludge RK84 RGB Wireless 80% Layout Hotswap', 980000, 'TDP: 1W', 'https://cf.shopee.vn/file/6e1e4cbe7912a8b7473e94334e280d6d', 16, 90, '7/23/2026 10:00:00 AM', 'Royal Kludge');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (380, 'Bàn phím cơ FL-Esports FL980 SAM Tropical Secret Wireless', 2450000, 'TDP: 2W', 'https://tsunamigaming.vn/wp-content/uploads/2024/02/ban-phim-co-fl-esports-fl980-sam-cercis-tsunamigaming-h2.jpg', 16, 40, '7/23/2026 10:00:00 AM', 'FL-Esports');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (381, 'Bàn phím cơ MonsGeek M1W V3 Fully Assembled Aluminum Wireless', 2150000, 'TDP: 2W', 'https://bizweb.dktcdn.net/thumb/grande/100/466/510/articles/new-monsgeek-m1w-bluetooth-wireless-mechanical-keyboard-rgb-heat-exchange-aluminum-alloy-body-keyboard-pc-game-jpg.jpg?v=1689416873953', 16, 45, '7/23/2026 10:00:00 AM', 'MonsGeek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (382, 'Bàn phím cơ EPOMAKER RT100 Retro Mechanical Keyboard Màn hình Smart', 2650000, 'TDP: 2W', 'https://the-gadgeteer.com/wp-content/uploads/2023/10/epomaker-rt100-1-768x577.jpg', 16, 35, '7/23/2026 10:00:00 AM', 'EPOMAKER');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (383, 'Bàn phím cơ Ducky One 3 Daybreak Hotswap RGB Mech Keyboard', 2850000, 'TDP: 2W', 'https://img.lazcdn.com/g/p/55ae1abfed8b5f9068f263c2fdad5fee.png_720x720q80.png', 16, 30, '7/23/2026 10:00:00 AM', 'Ducky');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (384, 'Bàn phím cơ Varmilo VEA87 Vintage Mechanical Keyboard Cherry MX', 3150000, 'TDP: 1W', 'https://down-sg.img.susercontent.com/file/sg-11134201-23010-9jf38tbmpxlv7d', 16, 25, '7/23/2026 10:00:00 AM', 'Varmilo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (385, 'Bàn phím cơ NuPhy Air75 V2 Low-Profile Wireless Keyboard', 2950000, 'TDP: 2W', 'https://ae01.alicdn.com/kf/S7895a3515780430eae0a4cc7d06e77fdB.jpg', 16, 40, '7/23/2026 10:00:00 AM', 'NuPhy');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (386, 'Bàn phím cơ Custom Womier K66 Gateron Switch RGB Acrylic Glass', 1250000, 'TDP: 1W', 'https://m.media-amazon.com/images/S/aplus-media-library-service-media/23afc7a0-27ae-4702-9816-82521db15ee8.__CR0,0,970,600_PT0_SX970_V1___.png', 16, 70, '7/23/2026 10:00:00 AM', 'Womier');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (387, 'Chuột máy tính Razer Basilisk V3 Ergonomic Gaming Mouse 26k DPI', 1450000, 'TDP: 1W', 'https://m.media-amazon.com/images/I/61okFRY8uPL._AC_.jpg', 17, 80, '7/23/2026 10:00:00 AM', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (388, 'Chuột máy tính Logitech G304 LIGHTSPEED Wireless Black 12k DPI', 820000, 'TDP: 1W', 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mek0sd2tdmgxc0', 17, 150, '7/23/2026 10:00:00 AM', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (389, 'Chuột máy tính Pulsar X2 V2 Wireless Gaming Mouse Superlight 53g', 2150000, 'TDP: 1W', 'https://cdn.store-assets.com/s/824673/i/61271910.jpeg', 17, 45, '7/23/2026 10:00:00 AM', 'Pulsar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (390, 'Chuột máy tính Ninjutso Sora V2 Ultra Lightweight Wireless 39g', 2450000, 'TDP: 1W', 'https://down-ph.img.susercontent.com/file/sg-11134202-7ratx-may7aujrn6uu1e', 17, 40, '7/23/2026 10:00:00 AM', 'Ninjutso');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (391, 'Chuột máy tính LAMZU Atlantis OG V2 Wireless Gaming Mouse 55g', 2250000, 'TDP: 1W', 'https://cdn.store-assets.com/s/824673/i/62363110.jpeg', 17, 50, '7/23/2026 10:00:00 AM', 'LAMZU');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (392, 'Chuột máy tính Endgame Gear OP1WE Wireless Gaming Mouse 58g', 1950000, 'TDP: 1W', 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m5d24fcjbuieb0', 17, 60, '7/23/2026 10:00:00 AM', 'Endgame Gear');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (393, 'Chuột máy tính VGN Dragonfly F1 PRO MAX Wireless Nordic MCU', 1150000, 'TDP: 1W', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/466/510/products/9884aef4-733e-4f36-a587-d3bed9c441ed-1693989197508.jpg?v=1694080500800', 17, 90, '7/23/2026 10:00:00 AM', 'VGN');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (394, 'Chuột máy tính VXE R1 PRO MAX Ultra Light Wireless PAW3395', 980000, 'TDP: 1W', 'https://down-br.img.susercontent.com/file/br-11134207-7r98o-m5etuyqhic3628', 17, 110, '7/23/2026 10:00:00 AM', 'VXE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (395, 'Chuột máy tính SteelSeries Rival 3 Wireless Gaming Mouse 18k DPI', 950000, 'TDP: 1W', 'https://os-jo.com/image/cache/catalog/products/Accessories/Mouse/RIVAL-3-Wireless/a89f866daa5b7f847d234e3beb4d6582-1200x1200.jpg', 17, 100, '7/23/2026 10:00:00 AM', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (396, 'Chuột máy tính ASUS ROG Harpe Ace Aim Lab Edition 54g Wireless', 2850000, 'TDP: 1W', 'https://product.hstatic.net/1000262653/product/sp1080884_f0bb5b45cbbc4da1881a87dc14861641_master.png', 17, 35, '7/23/2026 10:00:00 AM', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (397, 'Tai nghe gaming HyperX Cloud II Wireless Red/Black Spatial Audio', 2950000, 'TDP: 1W', 'https://cdn.shopify.com/s/files/1/0564/3612/9997/products/hyperx_cloud_ii_wireless_6_accessories_2048x2048.jpg?v=1655760985', 18, 60, '7/23/2026 10:00:00 AM', 'HyperX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (398, 'Tai nghe gaming Razer BlackShark V2 X 7.1 Surround Sound Black', 1250000, 'TDP: 1W', 'https://cdn.hstatic.net/products/1000231532/mua_razer_blackshark_v2_x_b_o_h_nh_24_th_ng_uy_t_n_t_i_nshop_4e5bb68935394ba79b01c641540fa09e_master.jpg', 18, 100, '7/23/2026 10:00:00 AM', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (399, 'Tai nghe gaming Corsair HS80 RGB Wireless Spatial Audio White', 3450000, 'TDP: 2W', 'https://assets.corsair.com/image/upload/c_pad,q_auto,h_1024,w_1024,f_auto/products/Gaming-Headsets/CA-9011236-EU/Gallery/HS80_RGB_WIRELESS_WHITE_01.webp', 18, 45, '7/23/2026 10:00:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (400, 'Tai nghe gaming Logitech G435 LIGHTSPEED Ultra-Light Wireless Blue', 1450000, 'TDP: 1W', 'https://down-ph.img.susercontent.com/file/ph-11134207-7rasb-m6gmkzx8osu7d2', 18, 90, '7/23/2026 10:00:00 AM', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (401, 'Tai nghe gaming SteelSeries Arctis Nova 7 Wireless Multi-Platform', 4250000, 'TDP: 2W', 'https://azaudio.vn/wp-content/uploads/2023/12/azaudio-steelseries-arctis-nova-7-wireless-2.jpg', 18, 35, '7/23/2026 10:00:00 AM', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (402, 'Tai nghe gaming EPOS Sennheiser GSP 300 Closed Acoustic Black/Blue', 1850000, 'TDP: 1W', 'https://linkemstores.com/img/user/products/Sennheise/Sennheiser%20Gamer%20Series%20Closed%20Acoustic%20Gaming%20Headset%20GSP%20300/Black/SennheiserGamerSeriesClosedAcousticGamingHeadsetGSP300Black3-1.png', 18, 50, '7/23/2026 10:00:00 AM', 'EPOS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (403, 'Tai nghe gaming Audio-Technica ATH-GDL3 Open-Back Gaming Headset', 3250000, 'TDP: 1W', 'https://images.tokopedia.net/img/cache/500-square/VqbcmM/2022/1/28/53a4c36c-e344-4f86-83b5-62905654253a.jpg', 18, 30, '7/23/2026 10:00:00 AM', 'Audio-Technica');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (404, 'Tai nghe gaming JBL Quantum 400 USB Wired Gaming Headset QuantumSURROUND', 1950000, 'TDP: 1W', 'https://m.media-amazon.com/images/I/61XqT1iYszL._AC_SL1500_.jpg', 18, 70, '7/23/2026 10:00:00 AM', 'JBL');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (405, 'Tai nghe gaming ASUS ROG Delta S Wireless Gaming Headset Type-C', 4650000, 'TDP: 2W', 'https://mygear.io.vn/media/product/9420-tai-nghe-gaming-overear-asus-rog-delta-s-wireless-4.jpg', 18, 25, '7/23/2026 10:00:00 AM', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (406, 'Tai nghe gaming EKSA E900 Pro 7.1 Surround Sound Wired Dual Audio', 750000, 'TDP: 1W', 'https://www.eksa.in/cdn/shop/files/2_-10.png?v=1725616185', 18, 120, '7/23/2026 10:00:00 AM', 'EKSA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (407, 'Thẻ nhớ MicroSD Sandisk Ultra 32GB Class 10 120MB/s', 120000, 'TDP: 1W', 'https://maytinhtrangia.com/wp-content/uploads/SD-32G-1.jpg', 4, 150, '7/23/2026 11:35:00 AM', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (408, 'Thẻ nhớ MicroSD Sandisk High Endurance 64GB Chuyên ghi Dashcam', 290000, 'TDP: 1W', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/h/the-nho-microsd-sandisk-high-endurance-chuyen-camera-64gb_1_.png', 4, 100, '7/23/2026 11:35:00 AM', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (409, 'Thẻ nhớ SDXC SanDisk Extreme PRO 64GB UHS-I 200MB/s', 450000, 'TDP: 2W', 'https://media.foto-erhardt.de/images/product_images/popup_images/893/sandisk-64-gb-sdxc-extremepro-200mbs-v30-uhs-i-u3-class-10-speicherkarte-166124206789380304.jpg', 4, 120, '7/23/2026 11:35:00 AM', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (410, 'Thẻ nhớ MicroSD Samsung EVO Plus 64GB kèm Adapter', 210000, 'TDP: 1W', 'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lfc894uls77909', 4, 180, '7/23/2026 11:35:00 AM', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (411, 'Thẻ nhớ MicroSD Samsung EVO Plus 128GB UHS-I U3', 350000, 'TDP: 2W', 'https://www.nhatthuc.com.vn/resize-image/470x/2025/08/the-nho-micro-sd-samsung-evo-plus-128gb-1.jpg', 4, 140, '7/23/2026 11:35:00 AM', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (412, 'Thẻ nhớ MicroSD Kingston Canvas Select Plus 64GB', 150000, 'TDP: 1W', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/h/the-nho-microsd-kingston-canvas-select-plus-64gb-sdcs3_2_.png', 4, 200, '7/23/2026 11:35:00 AM', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (413, 'Thẻ nhớ MicroSD Kingston Canvas Select Plus 256GB', 520000, 'TDP: 2W', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/h/the-nho-microsd-kingston-canvas-select-plus-256gb-sdcs3_4_.png', 4, 90, '7/23/2026 11:35:00 AM', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (414, 'Thẻ nhớ SDXC Lexar Professional 1667x 128GB SDXC UHS-II 250MB/s', 1150000, 'TDP: 3W', 'https://product.hstatic.net/200000863343/product/the-nho-sdxc-lexar-128gb-uhs-ii-1667x-250mb-s-scjuu_3e270e20e4ff4e72bb2df4b4c7fc1e45.jpg', 4, 60, '7/23/2026 11:35:00 AM', 'Lexar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (415, 'Thẻ nhớ MicroSD Lexar Play 256GB UHS-I cho Nintendo Switch', 680000, 'TDP: 2W', 'https://cdn.hstatic.net/products/1000231532/ss_256gb_lexar_cho_nintendo_switch_2_chinh_hang_gia_tot_chat_luong_cao_d1dc82953bc747cbac60d5e312b47e76.jpg', 4, 80, '7/23/2026 11:35:00 AM', 'Lexar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (416, 'Thẻ nhớ SDXC Sony SF-E Series 64GB UHS-II 270MB/s', 850000, 'TDP: 2W', 'https://photoking.vn/upload/images/Ph%E1%BB%A5%20Ki%E1%BB%87n/Th%E1%BA%BB%20Nh%E1%BB%9B/the-nho-sony-sdxc-64gb-270mbs-70-mbs-sf-m64-photoking-vn-02.jpg', 4, 50, '7/23/2026 11:35:00 AM', 'Sony');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (417, 'Thẻ nhớ SDXC Sony TOUGH M Series 128GB UHS-II 270MB/s', 2100000, 'TDP: 3W', 'https://cf.shopee.co.id/file/50fab139ce6eeb1d06a77f9ef2d9577f', 4, 35, '7/23/2026 11:35:00 AM', 'Sony');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (418, 'Thẻ nhớ MicroSD Kioxia Exceria G2 256GB NVMe Class', 620000, 'TDP: 2W', 'https://www.tnc.com.vn/uploads/product/vy2023/the-nho-256gb-kioxia-microsd-sdxc-exceria-g2.png', 4, 75, '7/23/2026 11:35:00 AM', 'Kioxia');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (419, 'Thẻ nhớ SDXC Transcend 700S 64GB SDXC UHS-II V90 285MB/s', 1850000, 'TDP: 3W', 'https://d2ati23fc66y9j.cloudfront.net/ubuy/full/1/7/170920366713977IMG.jpg', 4, 40, '7/23/2026 11:35:00 AM', 'Transcend');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (420, 'Thẻ nhớ MicroSD TeamGroup PRO Endurance 128GB', 390000, 'TDP: 2W', 'https://cdn.hstatic.net/products/200001078011/the-nho-team-group-elite-128g-uhs-i-u3-v30-a1_72e4b2b6836c44dcb2acea7c924762a2_master.jpg', 4, 85, '7/23/2026 11:35:00 AM', 'TeamGroup');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (421, 'Thẻ nhớ SDXC ProGrade Digital SDXC UHS-II V90 Cobalt 128GB', 3950000, 'TDP: 3W', 'https://www.lens-camera.com/wp-content/uploads/2025/03/02/prograde_digital_555654_1_1.jpg', 4, 20, '7/23/2026 11:35:00 AM', 'ProGrade');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (422, 'Ổ cứng di động SSD WD My Passport SSD 1TB USB 3.2 Red', 2450000, 'TDP: 4W', 'https://minhancomputercdn.com/media/product/11301_wd_my_passport_ssd_1tb_wdbagf0010brd_wesn_2.jpg', 8, 60, '7/23/2026 11:35:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (423, 'Ổ cứng di động SSD WD Black P50 Game Drive 1TB NVMe 2000MB/s', 3850000, 'TDP: 5W', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/wd-p50-02-42d56a0c-5309-4266-8a4a-720e3320e5e5.jpg?v=1615888619027', 8, 40, '7/23/2026 11:35:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (424, 'Ổ cứng di động HDD WD Elements Portable 1TB 2.5 inch USB 3.0', 1390000, 'TDP: 5W', 'https://www.maytinhphunggia.vn/media/product/29114_sua_o_cung_di_dong_hdd_wd_elements_portable_1tb_2_5_inch_usb_3_0.jpg', 8, 100, '7/23/2026 11:35:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (425, 'Ổ cứng di động HDD WD Elements Portable 4TB 2.5 inch USB 3.0', 3150000, 'TDP: 6W', 'https://duyhungcomputer.vn/media/product/2529-o-cu-ng-di-do-ng-hdd-western-digital-elements-portable-4tb-2-5-usb-3-0-wdbu6y0040bbk-wesn-01.jpg', 8, 50, '7/23/2026 11:35:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (426, 'Ổ cứng di động SSD Samsung T7 Portable 1TB USB 3.2 Titan Gray', 2550000, 'TDP: 4W', 'https://cdn2.cellphones.com.vn/x/media/catalog/product/o/-/o-cung-di-dong-ssd-samsung-t7-portable_10_.png', 8, 70, '7/23/2026 11:35:00 AM', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (427, 'Ổ cứng di động SSD Samsung T9 Portable 2TB USB 3.2 Gen 2x2 2000MB/s', 5450000, 'TDP: 5W', 'https://lagihitech.vn/wp-content/uploads/2023/10/SSD-Samsung-T9-2TB-USB-3.2-Gen-2-MU-PG2T0B-hinh-8.jpg', 8, 30, '7/23/2026 11:35:00 AM', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (428, 'Ổ cứng di động SSD SanDisk Extreme PRO Portable 2TB USB 3.2 Gen 2x2', 5150000, 'TDP: 5W', 'https://down-vn.img.susercontent.com/file/sg-11134201-22120-69sq1wzfywkv7d', 8, 35, '7/23/2026 11:35:00 AM', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (429, 'Ổ cứng di động HDD Seagate One Touch 2TB 2.5 inch USB 3.0 Black', 2050000, 'TDP: 5W', 'https://huyhoang.vn/uploads/o-cung-di-dong-hdd-seagate-one-touch-2tb-25-usb-30-den-stky2000400-3.jpg', 8, 80, '7/23/2026 11:35:00 AM', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (430, 'Ổ cứng di động HDD Seagate Basic 1TB 2.5 inch USB 3.0', 1290000, 'TDP: 5W', 'https://hoanghapccdn.com/media/product/3630_1tb_touch_1_hdd_1.jpg', 8, 110, '7/23/2026 11:35:00 AM', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (431, 'Ổ cứng di động SSD Crucial X6 Portable SSD 2TB 800MB/s', 3450000, 'TDP: 4W', 'https://5sc.vn/wp-content/uploads/2022/05/Crucial-X6-Portable-SSD-2TB-Box-Front-Image.png', 8, 45, '7/23/2026 11:35:00 AM', 'Crucial');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (432, 'Ổ cứng di động SSD Crucial X10 Pro 2TB USB 3.2 Gen 2x2 2100MB/s', 5850000, 'TDP: 5W', 'https://tinhocthanhkhang.vn/media/product/2964-ssd-di-dong-2tb-crucial-x10-ct2000x10ssd9-2_15_11zon.webp', 8, 25, '7/23/2026 11:35:00 AM', 'Crucial');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (433, 'Ổ cứng di động SSD Kingston XS1000 2TB External SSD Type-C Red', 3650000, 'TDP: 4W', 'https://image.citycenter.jo/cache/catalog/002023/72023/xx2000-1200x1200.jpg', 8, 55, '7/23/2026 11:35:00 AM', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (434, 'Tản nhiệt nước AIO Corsair H100i RGB ELITE 240mm', 3250000, 'TDP: 12W', 'https://philong.com.vn/media/product/31924-tan-nhiet-nuoc-cpu-aio-corsair-icue-h100i-rgb-elite-240mm-white-cw-9060078-ww-philong--2-.jpg', 9, 50, '7/23/2026 11:35:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (435, 'Tản nhiệt nước AIO Corsair iCUE LINK H100i RGB White 240mm', 4850000, 'TDP: 12W', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/tan-nhiet-nuoc-aio-corsair-icue-link-h100i-rgb-white-cw-9061005-ww.jpg?v=1688526053120', 9, 35, '7/23/2026 11:35:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (436, 'Tản nhiệt nước AIO NZXT Kraken 240 RGB Black LCD', 4250000, 'TDP: 12W', 'https://www.pcstudio.in/wp-content/uploads/2023/05/Nzxt-Kraken-240-Rgb-240mm-Aio-Liquid-Cooler-Matte-Black-1.jpg', 9, 40, '7/23/2026 11:35:00 AM', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (437, 'Tản nhiệt nước AIO NZXT Kraken 360 RGB Black LCD', 5350000, 'TDP: 15W', 'https://hoanghapc.vn/media/product/4402_rl_kr360_b1_ha1.jpg', 9, 30, '7/23/2026 11:35:00 AM', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (438, 'Tản nhiệt nước AIO ASUS ROG Strix LC III 360 ARGB', 4950000, 'TDP: 15W', 'http://kccshop.vn/media/product/250-8116-t---n-nhi---t-n-----c-aio-asus-rog-strix-lc-iii-360-argb-white-editon-01.png', 9, 25, '7/23/2026 11:35:00 AM', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (439, 'Tản nhiệt nước AIO ASUS TUF Gaming LC II 360 ARGB', 2950000, 'TDP: 15W', 'https://hoanghapccdn.com/media/product/5001_tuf_gaming_lc_ii_360_argb_ha1.jpg', 9, 45, '7/23/2026 11:35:00 AM', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (440, 'Tản nhiệt nước AIO DeepCool LS720 SE 360mm ARGB Black', 2650000, 'TDP: 15W', 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m2whteh6qzuu1d', 9, 60, '7/23/2026 11:35:00 AM', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (441, 'Tản nhiệt nước AIO DeepCool MYSTIQUE 360 Màn hình LCD 3.4 inch', 4150000, 'TDP: 15W', 'http://cms2.deepcool.com:8080/public/ProductFile/DEEPCOOL/Cooling/CPULiquidCoolers/MYSTIQUE_360_ARGB/Gallery/4000X4000/01.png', 9, 30, '7/23/2026 11:35:00 AM', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (442, 'Tản nhiệt nước AIO Thermalright Frozen Warframe 360 ARGB Màn LCD', 2750000, 'TDP: 15W', 'https://gitec.ge/images/thumbs/0070829_tr-fw-360-b-argb.jpeg', 9, 40, '7/23/2026 11:35:00 AM', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (443, 'Tản nhiệt nước AIO Lian Li Galahad II LCD 360 SL-INF Black', 6450000, 'TDP: 15W', 'https://ttgshop.vn/media/product/1054421234_82296_tan_nhiet_nuoc_lian_li_galahad_ii_lcd_sl_inf_360_black__3__f16e36ee72964ce8a37a7384400e9d15.jpg', 9, 20, '7/23/2026 11:35:00 AM', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (444, 'Tản nhiệt nước AIO MSI MAG CORELIQUID 240R V2', 2250000, 'TDP: 12W', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/tan-nhiet-nuoc-aio-mag-coreliquid-240r-4.jpg?v=1697040027870', 9, 55, '7/23/2026 11:35:00 AM', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (445, 'Tản nhiệt nước AIO ID-COOLING FROSTFLOW X 240 Snow Edition White', 1150000, 'TDP: 10W', 'https://down-vn.img.susercontent.com/file/vn-11134201-23020-tn10ee3ldunv20', 9, 80, '7/23/2026 11:35:00 AM', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (446, 'Card màn hình ASUS ROG Strix GeForce RTX 4090 OC Edition 24GB GDDR6X', 54900000, 'TDP: 450W', 'https://dlcdnwebimgs.asus.com/gain/6346BB89-238D-40ED-91B1-D822590E4670/w1000/h732', 10, 10, '7/23/2026 11:35:00 AM', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (447, 'Card màn hình MSI GeForce RTX 4080 SUPER 16G GAMING X TRIO', 33500000, 'TDP: 320W', 'https://hanoicomputercdn.com/media/product/79168_card_man_hinh_msi_rtx_4080_super_16g_gaming_x_trio__2_.jpg', 10, 15, '7/23/2026 11:35:00 AM', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (448, 'Card màn hình GIGABYTE GeForce RTX 4060 EAGLE OC 8G', 8450000, 'TDP: 115W', 'https://m.media-amazon.com/images/I/71g2Lc8urJL._AC_.jpg', 10, 60, '7/23/2026 11:35:00 AM', 'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (449, 'Card màn hình GIGABYTE GeForce RTX 3050 WINDFORCE OC 6G', 4650000, 'TDP: 70W', 'https://product.hstatic.net/200000722513/product/geforce_rtx__3050_windforce_oc_6g-02_8e038f8bf31d4b008bc170b13dd3cff4.png', 10, 80, '7/23/2026 11:35:00 AM', 'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (450, 'Card màn hình ASUS Dual GeForce RTX 4060 Ti EVO OC Edition 8GB', 11250000, 'TDP: 160W', 'https://m.media-amazon.com/images/I/81idjlyCnSL._AC_SL1500_.jpg', 10, 45, '7/23/2026 11:35:00 AM', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (451, 'Card màn hình ZOTAC GAMING GeForce RTX 3060 Twin Edge OC 12GB', 7250000, 'TDP: 170W', 'https://res.cloudinary.com/jawa/image/upload/f_auto,c_limit,w_1280,q_auto/production/listings/pcubpf4kb1xn6xd6iklw', 10, 50, '7/23/2026 11:35:00 AM', 'ZOTAC');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (452, 'Card màn hình Sapphire PULSE AMD Radeon RX 7600 8GB GDDR6', 7150000, 'TDP: 165W', 'https://www.minandovoy.com/wp-content/uploads/2023/06/sapphire-pulse-amd-radeon-rx-7600-8gb-gddr6-1500px-v1-0001.jpg', 10, 40, '7/23/2026 11:35:00 AM', 'Sapphire');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (453, 'Card màn hình PowerColor Fighter AMD Radeon RX 6600 8GB GDDR6', 5250000, 'TDP: 132W', 'https://m.media-amazon.com/images/I/81Vtsr0wIVL._AC_.jpg', 10, 55, '7/23/2026 11:35:00 AM', 'PowerColor');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (454, 'Card màn hình ASRock Challenger Radeon RX 7800 XT 16GB OC', 14150000, 'TDP: 263W', 'https://www.asrock.com/Graphics-Card/photo/Radeon%20RX%207800%20XT%20Challenger%2016GB%20OC(M1).png', 10, 30, '7/23/2026 11:35:00 AM', 'ASRock');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (455, 'Card màn hình COLORFUL GeForce GTX 1650 NB 4GD6-V', 3650000, 'TDP: 75W', 'https://tinhungtech.com/watermark/product/1400x1500x2/upload/product/51dmzhei2olsr600315piwhitestripbottomleft035sclzzzzzzzfmpngbg255255255-4585.png', 10, 70, '7/23/2026 11:35:00 AM', 'COLORFUL');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (456, 'Ổ cứng HDD PC Western Digital Purple 2TB 3.5 inch Surveillance', 1650000, 'TDP: 6W', 'https://m.media-amazon.com/images/I/71n-iiLwaIL._AC_.jpg', 11, 90, '7/23/2026 11:35:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (457, 'Ổ cứng HDD PC Western Digital Purple 4TB 3.5 inch Surveillance', 2750000, 'TDP: 7W', 'https://kimostore.net/cdn/shop/files/western-digital-purple-4tb-3-5-inch-surveillance-internal-hard-drive-kimo-store-1_1024x.jpg?v=1715034242', 11, 70, '7/23/2026 11:35:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (458, 'Ổ cứng HDD PC Western Digital Purple 6TB 3.5 inch Surveillance', 4350000, 'TDP: 8W', 'https://m.media-amazon.com/images/I/61oyy18RjsL._AC_SL1500_.jpg', 11, 45, '7/23/2026 11:35:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (459, 'Ổ cứng HDD PC Seagate SkyHawk 2TB 3.5 inch Surveillance', 1550000, 'TDP: 6W', 'https://hanoicomputercdn.com/media/product/35130_hdd_seagate_skyhawk_surveillance_2tb5900_sata_3_64mb_cache_st2000vx008_011.jpg', 11, 85, '7/23/2026 11:35:00 AM', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (460, 'Ổ cứng HDD PC Seagate SkyHawk 6TB 3.5 inch Surveillance', 4150000, 'TDP: 8W', 'https://maytinhtrungbac.com/wp-content/uploads/2023/12/HDD9.jpg', 11, 50, '7/23/2026 11:35:00 AM', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (461, 'Ổ cứng HDD Server Seagate IronWolf Pro 8TB 3.5 inch NAS', 6150000, 'TDP: 9W', 'https://viettuans.vn/uploads/2024/05/st8000nt001.jpg', 11, 30, '7/23/2026 11:35:00 AM', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (462, 'Ổ cứng HDD Server Seagate IronWolf Pro 12TB 3.5 inch NAS', 8950000, 'TDP: 10W', 'https://www.sieuthimaychu.vn/datafiles/setone/15663755172039.jpg', 11, 20, '7/23/2026 11:35:00 AM', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (463, 'Ổ cứng HDD Server Western Digital Red Pro 8TB 3.5 inch NAS', 6450000, 'TDP: 9W', 'https://www.tnc.com.vn/uploads/product/sp2025/o-cung-hdd-western-digital-red-pro-nas-8tb-wd8005ffbx.jpg', 11, 25, '7/23/2026 11:35:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (464, 'Ổ cứng HDD Enterprise Seagate Exos X16 14TB 3.5 inch SATA3', 7250000, 'TDP: 10W', 'https://media.loveitopcdn.com/30716/o-cung-hdd-seagate-enterprise-exos-35-sata-x16-14tb-st14000nm001g-13.png', 11, 25, '7/23/2026 11:35:00 AM', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (465, 'Ổ cứng HDD Enterprise Western Digital Ultrastar DC HC550 18TB', 9450000, 'TDP: 10W', 'https://product.hstatic.net/200000722513/product/o-cung-hdd-18tb-western-digital_17bc422fad9b4f8fb51ec439e3f63a4a_grande.png', 11, 15, '7/23/2026 11:35:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (466, 'Ổ cứng HDD PC Toshiba Canvio Basics 1TB 2.5 inch', 1250000, 'TDP: 4W', 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mb3gsn7g9uwx71', 11, 110, '7/23/2026 11:35:00 AM', 'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (467, 'Ổ cứng HDD PC Toshiba Surveillance S300 4TB 3.5 inch', 2550000, 'TDP: 7W', 'https://alfathtechnology.com/wp-content/uploads/2025/07/https___static.arvutitark.ee_public_media-hub-olev_2021_10_123986_media-nkeail.jpg', 11, 60, '7/23/2026 11:35:00 AM', 'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (468, 'Ổ cứng HDD Laptop Western Digital Blue 1TB 2.5 inch SATA3', 1150000, 'TDP: 4W', 'https://product.hstatic.net/1000037809/product/thegioigear_hddwdblue1tb_a_a7ff5c32afe747f485c54dd561db1db7_master.jpg', 11, 95, '7/23/2026 11:35:00 AM', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (469, 'Nguồn Corsair RM850e ATX 3.0 80 Plus Gold Full Modular (850W)', 3450000, 'TDP: 0W', 'https://product.hstatic.net/200000722513/product/89689_nguon_may_tinh_corsair_rm850e_atx_006_e59a3ebce3034f23aa2bde43f1d242e5_1024x1024.jpg', 12, 50, '7/23/2026 11:35:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (470, 'Nguồn Corsair RM1000x Shift 80 Plus Gold Full Modular (1000W)', 4950000, 'TDP: 0W', 'https://product.hstatic.net/1000037809/product/thegioigear_corsair_rm1000x_1_1c478e5ea1ae485b91e607ee2b71eca7_master.jpg', 12, 30, '7/23/2026 11:35:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (471, 'Nguồn Corsair CV650 650W 80 Plus Bronze', 1450000, 'TDP: 0W', 'https://maytinhdalat.vn/Images/Product/maytinhdalat_nguon-may-tinh-corsair-cv650-650w-80-plus-bronzenguon-may-tinh-corsair-cv650-650w-80-plus-bronze-avt2725337_full_26002022_030016.jpg', 12, 90, '7/23/2026 11:35:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (472, 'Nguồn MSI MAG A650BN 650W 80 Plus Bronze', 1250000, 'TDP: 0W', 'https://halinhcomputer.vn/uploads/images/web-halinh-new/linh-kien-le/psu/mag-a650bn.png', 12, 110, '7/23/2026 11:35:00 AM', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (473, 'Nguồn MSI MEG Ai1300P PCIE5 1300W 80 Plus Platinum', 8950000, 'TDP: 0W', 'https://down-sg.img.susercontent.com/file/sg-11134201-22100-ms6oh974ckivaa', 12, 15, '7/23/2026 11:35:00 AM', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (474, 'Nguồn ASUS ROG Thor 1000W Platinum II OLED', 8450000, 'TDP: 0W', 'https://songphuong.vn/Content/uploads/2025/06/ROG-THOR-1000P2-2.webp', 12, 20, '7/23/2026 11:35:00 AM', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (475, 'Nguồn ASUS TUF Gaming 650B 650W 80 Plus Bronze', 1650000, 'TDP: 0W', 'https://sp-one.vn/Content/uploads/2024/12/69179_asus_tuf_gaming_650w_bronze_sp_picture__1_.jpg', 12, 80, '7/23/2026 11:35:00 AM', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (476, 'Nguồn Cooler Master Elite V3 600W 230V', 1050000, 'TDP: 0W', 'https://khoidong.vn/UploadedFiles/baner/psu/52102_cooler_master_elite_v3_230v_pc600_600w_0004_1__1_.jpg', 12, 100, '7/23/2026 11:35:00 AM', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (477, 'Nguồn DeepCool PK650D 650W 80 Plus Bronze', 1350000, 'TDP: 0W', 'https://hoanghapccdn.com/media/product/3687_deepcool_pk650_3.jpg', 12, 85, '7/23/2026 11:35:00 AM', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (478, 'Nguồn ASRock Phantom Gaming PG-850G 850W 80 Plus Gold', 2950000, 'TDP: 0W', 'https://www.varle.lt/static/uploads/products/1316/asr/asrock-maitinimo-saltinis-pg-850g-850w-80plus-2694fb366e.webp', 12, 40, '7/23/2026 11:35:00 AM', 'ASRock');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (479, 'Vỏ case NZXT H9 Flow Dual-Chamber ATX Mid-Tower Black', 4450000, 'TDP: 0W', 'https://microless.com/cdn/products/d554d168dd1e4febb71cd2cbf0698726-hi.jpg', 13, 30, '7/23/2026 11:35:00 AM', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (480, 'Vỏ case NZXT H5 Flow RGB Compact Mid-Tower White', 2650000, 'TDP: 0W', 'https://www.topmarket.co.il/images/detailed/257/OtYnNeyks2.jpg', 13, 50, '7/23/2026 11:35:00 AM', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (481, 'Vỏ case Lian Li O11 Dynamic EVO XL Full Tower Black', 5850000, 'TDP: 0W', 'https://www.idcmayoristas.com/wp-content/uploads/2024/10/lian-li-o11dexl-x-o11-dynamic-evo-xl-full-o11dexl-x-us-lal-1.png', 13, 20, '7/23/2026 11:35:00 AM', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (482, 'Vỏ case Lian Li Lancool 216 ARGB Mid-Tower Black', 2350000, 'TDP: 0W', 'https://os-jo.com/image/cache/catalog/products/cases/LANCOOL-216/My-project-1200x1200.jpg', 13, 60, '7/23/2026 11:35:00 AM', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (483, 'Vỏ case Corsair 3500X ARGB Mid-Tower Glass Black', 2450000, 'TDP: 0W', 'https://kccshop.vn/media/product/250-9689-v----case-corsair-3500x-rgb-tempered-glass-mid-tower-black--cc-9011278-ww--01.jpg', 13, 70, '7/23/2026 11:35:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (484, 'Vỏ case Corsair 5000D AIRFLOW Tempered Glass Mid-Tower White', 3850000, 'TDP: 0W', 'https://cwsmgmt.corsair.com/pdp/5000-series/images/5000d-af-clear-clean-cool.png', 13, 35, '7/23/2026 11:35:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (485, 'Vỏ case MSI MAG FORGE 100M Mid-Tower Black', 1150000, 'TDP: 0W', 'https://gitec.ge/images/thumbs/0063677_msi-mag-forge-100m.jpeg', 13, 90, '7/23/2026 11:35:00 AM', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (486, 'Vỏ case Xigmatek Gaming X 3FX 3 Fan ARGB Black', 850000, 'TDP: 0W', 'https://phucngoc.vn/Data/images/vo-case-xigmatek-master-x-3fx.jpg', 13, 120, '7/23/2026 11:35:00 AM', 'Xigmatek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (487, 'Vỏ case Mik Aios Black Kèm 3 Fan ARGB', 950000, 'TDP: 0W', 'https://tinhocanhphat.vn/media/product/37617_01.jpg', 13, 100, '7/23/2026 11:35:00 AM', 'Mik');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (488, 'Vỏ case SAMA 3509 Black Kèm 3 Fan RGB', 750000, 'TDP: 0W', 'https://m.media-amazon.com/images/I/81EZRt3KIOL._AC_SL1500_.jpg', 13, 110, '7/23/2026 11:35:00 AM', 'SAMA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (489, 'Tản nhiệt khí Thermalright Peerless Assassin 120 White ARGB', 1050000, 'TDP: 5W', 'https://maytinhlmc.vn/wp-content/uploads/72071_peerless_assasin_120_se_white_argb__4_.jpg', 14, 80, '7/23/2026 11:35:00 AM', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (490, 'Tản nhiệt khí Thermalright Frost Tower 120 Dual Tower Black', 950000, 'TDP: 5W', 'https://hoanghapccdn.com/media/product/4157_thermalright_frost_tower_120_ha8.jpg', 14, 70, '7/23/2026 11:35:00 AM', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (491, 'Tản nhiệt khí DeepCool AK620 Digital ARGB Black Dual Tower', 1850000, 'TDP: 5W', 'https://media.ldlc.com/r1600/ld/products/00/06/05/60/LD0006056050.jpg', 14, 50, '7/23/2026 11:35:00 AM', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (492, 'Tản nhiệt khí DeepCool AG400 ARGB Single Tower', 450000, 'TDP: 3W', 'https://ecommerce.datablitz.com.ph/cdn/shop/files/zdfhbsrtg_800x.jpg?v=1739759913', 14, 130, '7/23/2026 11:35:00 AM', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (493, 'Tản nhiệt khí Noctua NH-U12S chromax.black Single Tower', 2150000, 'TDP: 4W', 'https://m.media-amazon.com/images/I/81Qu6DEtTlL._SL1500_.jpg', 14, 40, '7/23/2026 11:35:00 AM', 'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (494, 'Tản nhiệt khí Noctua NH-L9i-17xx Low-Profile CPU Cooler', 1350000, 'TDP: 3W', 'https://m.media-amazon.com/images/I/81XLADINZiL.jpg', 14, 60, '7/23/2026 11:35:00 AM', 'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (495, 'Tản nhiệt khí ID-COOLING SE-207-XT Black Dual Tower', 950000, 'TDP: 5W', 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lxdjem7mcdspfe', 14, 75, '7/23/2026 11:35:00 AM', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (496, 'Tản nhiệt khí ID-COOLING FROZN A620 Black Dual Tower', 1150000, 'TDP: 5W', 'https://kccshop.vn/media/product/250-10672-t---n-nhi---t-kh---id-cooling-frozn-a620-black_3_main.jpeg', 14, 65, '7/23/2026 11:35:00 AM', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (497, 'Tản nhiệt khí Cooler Master MasterAir MA612 Stealth Black', 1750000, 'TDP: 5W', 'https://hoanghapccdn.com/media/product/2166_masterair_ma612_stealth_4_optimized.jpg', 14, 45, '7/23/2026 11:35:00 AM', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (498, 'Tản nhiệt khí Jonsbo CR-1400 ARGB Black', 280000, 'TDP: 2W', 'https://www.tncstore.vn/media/product/12900-tan-nhiet-khi-jonsbo-cr-1400-argb-black-1.jpg', 14, 160, '7/23/2026 11:35:00 AM', 'Jonsbo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (499, 'Bộ 3 Fan tản nhiệt Lian Li UNI FAN TL LCD 120 Reverse Black', 3450000, 'TDP: 4W', 'https://technicstore.net/wp-content/uploads/2024/01/TL120-LCD-REVERSE-3IN1-BLACK-2.jpg', 15, 30, '7/23/2026 11:35:00 AM', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (500, 'Bộ 3 Fan tản nhiệt Lian Li UNI FAN AL120 V2 ARGB Black', 2150000, 'TDP: 3W', 'https://images.tcdn.com.br/img/img_prod/1362985/kit_cooler_fan_lian_li_uni_fan_al120_v2_120mm_3_un_preto_argb_2000_rpm_modular_uf_al120v2_3b_1747_2_cd18221530e72d4d8e615bcff1e491dc.jpg', 15, 50, '7/23/2026 11:35:00 AM', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (501, 'Bộ 3 Fan tản nhiệt Corsair LL120 RGB 120mm Dual Light Loop White', 2650000, 'TDP: 3W', 'https://minhancomputercdn.com/media/product/8348_qu___t_t___n_nhi___t_case_corsair_ll120_rgb_white.jpg', 15, 45, '7/23/2026 11:35:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (502, 'Bộ 3 Fan tản nhiệt Corsair SP120 RGB ELITE 120mm PWM Triple Pack', 1650000, 'TDP: 3W', 'https://cellphones.com.vn/media/catalog/product/t/e/text_ng_n_16__1_10.png', 15, 60, '7/23/2026 11:35:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (503, 'Bộ 3 Fan tản nhiệt NZXT F120 RGB Core Triple Pack White', 1850000, 'TDP: 3W', 'https://hanoicomputercdn.com/media/product/75643_fan_case_t___n_nhi___t_nzxt_f120rgb_core_triple_pack_white__3_.jpg', 15, 55, '7/23/2026 11:35:00 AM', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (504, 'Bộ 3 Fan tản nhiệt DeepCool FC120 White 3-in-1 ARGB', 890000, 'TDP: 3W', 'https://nguyenvu-store-medias.tn-cdn.net/2023/07/quat-tan-nhiet-deepcool-fc120-3-in-1-trang-8.jpg', 15, 80, '7/23/2026 11:35:00 AM', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (505, 'Bộ 3 Fan tản nhiệt Thermalright TL-C12C-S X3 White ARGB', 490000, 'TDP: 2W', 'https://nvs.tn-cdn.net/2024/07/Bo-3-Quat-Tan-Nhiet-Thermalright-TL-C12C-S-X3-White-1.jpg', 15, 110, '7/23/2026 11:35:00 AM', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (506, 'Bộ 3 Fan tản nhiệt Thermalright TL-K12 ARGB High-Performance', 650000, 'TDP: 2W', 'https://www.thermalright.com/wp-content/uploads/2023/08/1-10.jpg', 15, 90, '7/23/2026 11:35:00 AM', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (507, 'Bộ 3 Fan tản nhiệt Montech RX120 PWM Reverse ARGB Pack', 690000, 'TDP: 2W', 'https://cdn0.centrecom.com.au/images/upload/0196456_0.jpeg', 15, 85, '7/23/2026 11:35:00 AM', 'Montech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (508, 'Bộ 3 Fan tản nhiệt Xigmatek Galaxy II Pro ARGB 3 Fan Pack', 450000, 'TDP: 2W', 'https://alfrensia.com/wp-content/uploads/2022/02/EN42128.jpg', 15, 120, '7/23/2026 11:35:00 AM', 'Xigmatek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (509, 'Bộ 3 Fan tản nhiệt Mik Halo ARGB 3 Fan Pack Black', 380000, 'TDP: 2W', 'https://down-vn.img.susercontent.com/file/e9fdd00372700ad2f4ba6850323cb2cd', 15, 130, '7/23/2026 11:35:00 AM', 'Mik');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (510, 'Bộ 3 Fan tản nhiệt SAMA Halo ARGB Kit 3 Fan kèm Hub Remote', 350000, 'TDP: 2W', 'https://down-br.img.susercontent.com/file/br-11134207-7r98o-lq1zxlij2scj37', 15, 140, '7/23/2026 11:35:00 AM', 'SAMA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (511, 'Fan tản nhiệt lẻ Noctua NF-A12x25 PWM chromax.black', 850000, 'TDP: 1W', 'https://img.lazcdn.com/g/p/49953f3cb62b53c5f0957a3e1e1ce96f.jpg_720x720q80.jpg', 15, 90, '7/23/2026 11:35:00 AM', 'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (512, 'Fan tản nhiệt lẻ Arctic P12 PWM PST Black 120mm', 220000, 'TDP: 1W', 'https://pcngon.vn/wp-content/uploads/2024/09/Quat-tan-nhiet-Arctic-P12-PWM-PST-Black-4.png', 15, 200, '7/23/2026 11:35:00 AM', 'Arctic');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (513, 'Bàn phím cơ AKKO 5075B Plus Dragon Ball Z Wireless RGB', 2350000, 'TDP: 2W', 'https://phucanhcdn.com/media/product/50772_ban_phim_co_akko_khong_day_5075b_plus_dragon_ball_super_goku_8.jpg', 16, 40, '7/23/2026 11:35:00 AM', 'AKKO');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (514, 'Bàn phím cơ AKKO MonsGeek M1 V2 Kit Nhôm CNC Hotswap', 1850000, 'TDP: 1W', 'https://cf.shopee.vn/file/sg-11134201-22110-noy506z680jvf2', 16, 50, '7/23/2026 11:35:00 AM', 'AKKO');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (515, 'Bàn phím cơ Keychron K2 Pro Wireless Bluetooth QMK/VIA Gateron', 2150000, 'TDP: 2W', 'https://product.hstatic.net/1000187560/product/ban-phim-co-keychron-k2-pro-qmkvia-album-svf-thinkpro.vn_a9824fcb4b79456fa624cc6cf1c834cc_large.jpg', 16, 60, '7/23/2026 11:35:00 AM', 'Keychron');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (516, 'Bàn phím cơ Keychron Q1 Max Full Aluminum Wireless Custom', 4650000, 'TDP: 2W', 'https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Q1-Max-7.jpg?v=1701051646', 16, 25, '7/23/2026 11:35:00 AM', 'Keychron');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (517, 'Bàn phím cơ Logitech G Pro X TKL LIGHTSPEED Wireless Black', 4150000, 'TDP: 2W', 'https://www.tncstore.vn/media/product/13847-ban-phim-co-logitech-g-pro-x-tkl-lightspeed-tactile-switch-black.jpg', 16, 35, '7/23/2026 11:35:00 AM', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (518, 'Bàn phím cơ Razer BlackWidow V4 Pro Mechanical Gaming Keyboard', 5450000, 'TDP: 3W', 'https://owlgaming.vn/wp-content/uploads/2024/07/Ban-phim-Razer-BlackWidow-V4-Pro-3.jpg', 16, 20, '7/23/2026 11:35:00 AM', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (519, 'Bàn phím cơ Corsair K70 RGB PRO Mechanical Gaming Keyboard', 3650000, 'TDP: 2W', 'https://assets.corsair.com/image/upload/c_pad,q_auto,h_1024,w_1024,f_auto/products/Gaming-Keyboards/CH-910941A-NA/Gallery/K70_PRO_OPX_PBT_01.webp', 16, 45, '7/23/2026 11:35:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (520, 'Bàn phím cơ SteelSeries Apex Pro TKL Wireless', 5950000, 'TDP: 2W', 'https://owlgaming.vn/wp-content/uploads/2024/10/ban-phim-steelseries-apex-pro-tkl-wireless-gen-3.jpg', 16, 20, '7/23/2026 11:35:00 AM', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (521, 'Bàn phím cơ ASUS ROG Azoth Wireless Custom Gaming Keyboard', 6850000, 'TDP: 3W', 'https://pcmarket.vn/media/product/10986_ban_phim_co_gaming_asus_rog_azoth_white_pcm_6.jpg', 16, 15, '7/23/2026 11:35:00 AM', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (522, 'Bàn phím cơ Dareu EK87 V2 Multi-LED Tenkeyless Black', 450000, 'TDP: 1W', 'https://dareu.com.vn/wp-content/uploads/2024/09/ban-phim-co-gaming-dareu-ek87-v2-white-black-01-800x800.jpg', 16, 120, '7/23/2026 11:35:00 AM', 'Dareu');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (523, 'Chuột máy tính Logitech G Pro X Superlight 2 Wireless Black', 3450000, 'TDP: 1W', 'https://www.tncstore.vn/media/product/250-9061-chuot-logitech-g-pro-x-superlight-2-wireless-12.jpg', 17, 50, '7/23/2026 11:35:00 AM', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (524, 'Chuột máy tính Logitech G502 X PLUS LIGHTSPEED Wireless RGB', 3650000, 'TDP: 1W', 'https://cf.shopee.vn/file/vn-11134207-7qukw-liqvq05531le30', 17, 40, '7/23/2026 11:35:00 AM', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (525, 'Chuột máy tính Razer DeathAdder V3 Pro Wireless Ultra-Lightweight', 3250000, 'TDP: 1W', 'https://www.tncstore.vn/media/product/250-8340-razer-deathadder-v3-pro-ergonomic-white.jpg', 17, 45, '7/23/2026 11:35:00 AM', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (526, 'Chuột máy tính Razer Viper V3 Pro Ultra-Lightweight Wireless', 3850000, 'TDP: 1W', 'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mjnkr1p25hxcb7', 17, 35, '7/23/2026 11:35:00 AM', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (527, 'Chuột máy tính SteelSeries Aerox 3 Wireless Onyx Superlight', 1850000, 'TDP: 1W', 'https://product.hstatic.net/200000722513/product/79114_chuot_gaming_co_day_steels__4__1680bb5be04b4b0bae3bfe8d3ebc5866_1024x1024.png', 17, 60, '7/23/2026 11:35:00 AM', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (528, 'Chuột máy tính Corsair M65 RGB ULTRA Wireless Gaming Mouse', 2450000, 'TDP: 1W', 'https://media.ldlc.com/r1600/ld/products/00/05/98/52/LD0005985249.jpg', 17, 50, '7/23/2026 11:35:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (529, 'Chuột máy tính ASUS ROG Keris II Ace Ultra-Lightweight Wireless', 3150000, 'TDP: 1W', 'https://dlcdnwebimgs.asus.com/gain/9B783ACB-999D-41F3-AC55-7859FB30C90B/w717/h525', 17, 40, '7/23/2026 11:35:00 AM', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (530, 'Chuột máy tính Dareu EM901X RGB Wireless kèm Đế sạc', 590000, 'TDP: 1W', 'https://down-vn.img.susercontent.com/file/4b69f9c29485d36dc60c76a0656450f5', 17, 100, '7/23/2026 11:35:00 AM', 'Dareu');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (531, 'Chuột máy tính Rapoo VT9 PRO Dual-Mode Wireless Gaming Mouse', 790000, 'TDP: 1W', 'https://rapoostore.vn/wp-content/uploads/2024/05/Chuot-gaming-rapoo-vt9prodm.jpg', 17, 90, '7/23/2026 11:35:00 AM', 'Rapoo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (532, 'Chuột máy tính Fantech Helios II Pro XD3 V3 Wireless', 1250000, 'TDP: 1W', 'https://down-id.img.susercontent.com/file/id-11134208-7r98x-lxuwkmyu8eq237', 17, 70, '7/23/2026 11:35:00 AM', 'Fantech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (533, 'Tai nghe gaming HyperX Cloud III Wireless Black/Red 120-Hour Battery', 3850000, 'TDP: 1W', 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mdodsk4dl57wd1', 18, 40, '7/23/2026 11:35:00 AM', 'HyperX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (534, 'Tai nghe gaming HyperX Cloud Stinger 2 Core Gaming Headset', 850000, 'TDP: 1W', 'https://api.combatgaming.vn/api-v2/image/id/6475b8db5317487ebf3353ba', 18, 90, '7/23/2026 11:35:00 AM', 'HyperX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (535, 'Tai nghe gaming Razer BlackShark V2 Pro Wireless 2023 Edition', 4450000, 'TDP: 1W', 'https://m.media-amazon.com/images/I/71ZTXGr2g0L._AC_SL1500_.jpg', 18, 35, '7/23/2026 11:35:00 AM', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (536, 'Tai nghe gaming Razer Kraken Kitty V2 Pro RGB Quartz Pink', 4250000, 'TDP: 2W', 'https://laptopworld.vn/media/product/16639_76012_tai_nghe_gaming_co_day_razer_kraken_kitty_v2_pro_2023_edition_rgb_pink___rz04_04510200_r3m1_1.jpg', 18, 30, '7/23/2026 11:35:00 AM', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (537, 'Tai nghe gaming Logitech G PRO X 2 LIGHTSPEED Wireless Graphene', 5650000, 'TDP: 1W', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/tai-nghe-gaming-khong-day-logitech-pro-x-2-lightspeed-04.jpg?v=1692592084127', 18, 25, '7/23/2026 11:35:00 AM', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (538, 'Tai nghe gaming Logitech G733 LIGHTSPEED Wireless RGB White', 2950000, 'TDP: 1W', 'https://cdn.hstatic.net/products/200001100406/tai_nghe_gaming_logitech_g733_lightspeed_wireless_7_1_rgb_white_0002_3_64418de1b9874a0eb7bceb6feb305dfe_master.jpg', 18, 50, '7/23/2026 11:35:00 AM', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (539, 'Tai nghe gaming SteelSeries Arctis Nova Pro Wireless PC/PlayStation', 8950000, 'TDP: 2W', 'https://product.hstatic.net/200000637319/product/va_pro_black_3_v2.png__1850x800_q100_crop-scale_optimize_subsampling-2_9a2aba505a3a4d3d8f7786bc0fc355f6_master.png', 18, 15, '7/23/2026 11:35:00 AM', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (540, 'Tai nghe gaming Corsair VIRTUOSO RGB WIRELESS High-Fidelity', 4850000, 'TDP: 2W', 'https://res.cloudinary.com/corsair-pwa/image/upload/v1665096094/akamai/landing/virtuoso/assets/images/VIRTUOSO-White.png', 18, 30, '7/23/2026 11:35:00 AM', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (541, 'Tai nghe gaming ASUS ROG Pugi III Delta S Animate Display', 5250000, 'TDP: 2W', 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbacj96f7nivf2', 18, 20, '7/23/2026 11:35:00 AM', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (542, 'Tai nghe gaming Dareu EH722X 7.1 Surround Sound Pink', 490000, 'TDP: 1W', 'https://songphuong.vn/Content/uploads/2021/08/Tai-nghe-DareU-EH722X-7.1-PINK-3.jpg', 18, 110, '7/23/2026 11:35:00 AM', 'Dareu');

-- Dumping data for table vouchers
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES (2, 1, 'LXR36', '2026-06-22 10:52:53.047', 'Giảm giá 15% các mặt hàng', 'PERCENTAGE', 15, '2026-06-30 00:00:00', 50000, 10000, NULL, 100, 2, NULL);
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES (4, 1, 'LUX50', '2026-06-23 17:08:51.75', 'giảm giá 50', 'PERCENTAGE', 50, '2026-06-30 12:00:00', 10000000, 1000000, NULL, 10, 0, NULL);
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES (3, 1, 'LUX30', '2026-06-22 11:22:49.617', 'Giảm giá 30%', 'PERCENTAGE', 30, '2026-08-11 12:00:00', 5000000, 0, NULL, 0, 0, NULL);
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES (5, 1, 'LUX10', '2026-07-02 11:00:17.172', 'Giảm 10% cho tất cả đơn hàng', 'PERCENTAGE', 10, '2026-07-31 12:00:00', 10000000, 0, NULL, 10, 2, NULL);

-- Dumping data for table spring_session_attributes
INSERT INTO spring_session_attributes (session_primary_id, attribute_name, attribute_bytes) VALUES ('8aca5fa4-1bd3-4ba6-9341-c12559c3abc2', 'cart', 0x30784143454430303035373337323030313136413631373636313245373537343639364332453438363137333638344436313730303530374441433143333136363044313033303030323436303030413643364636313634343636313633373436463732343930303039373436383732363537333638364636433634373837303346343030303030303030303030303037373038303030303030313030303030303030303738);
INSERT INTO spring_session_attributes (session_primary_id, attribute_name, attribute_bytes) VALUES ('60682f2c-75ef-4730-9c75-3b31f7434a82', 'cart', 0x30784143454430303035373337323030313136413631373636313245373537343639364332453438363137333638344436313730303530374441433143333136363044313033303030323436303030413643364636313634343636313633373436463732343930303039373436383732363537333638364636433634373837303346343030303030303030303030303037373038303030303030313030303030303030303738);
INSERT INTO spring_session_attributes (session_primary_id, attribute_name, attribute_bytes) VALUES ('2a441226-685e-453a-a778-a6eaacd64dc7', 'cart', 0x30784143454430303035373337323030313136413631373636313245373537343639364332453438363137333638344436313730303530374441433143333136363044313033303030323436303030413643364636313634343636313633373436463732343930303039373436383732363537333638364636433634373837303346343030303030303030303030303037373038303030303030313030303030303030303738);
INSERT INTO spring_session_attributes (session_primary_id, attribute_name, attribute_bytes) VALUES ('8c4158f0-f459-41bc-a226-13547714be9f', 'cart', 0x30784143454430303035373337323030313136413631373636313245373537343639364332453438363137333638344436313730303530374441433143333136363044313033303030323436303030413643364636313634343636313633373436463732343930303039373436383732363537333638364636433634373837303346343030303030303030303030303037373038303030303030313030303030303030303738);
INSERT INTO spring_session_attributes (session_primary_id, attribute_name, attribute_bytes) VALUES ('3f874edd-c07d-4d9d-bce7-24d5e3067baf', 'cart', 0x30784143454430303035373337323030313136413631373636313245373537343639364332453438363137333638344436313730303530374441433143333136363044313033303030323436303030413643364636313634343636313633373436463732343930303039373436383732363537333638364636433634373837303346343030303030303030303030303037373038303030303030313030303030303030303738);
INSERT INTO spring_session_attributes (session_primary_id, attribute_name, attribute_bytes) VALUES ('e5d6a1e8-7d77-4bbe-9ab3-7c6ca6ad73f0', 'cart', 0x30784143454430303035373337323030313136413631373636313245373537343639364332453438363137333638344436313730303530374441433143333136363044313033303030323436303030413643364636313634343636313633373436463732343930303039373436383732363537333638364636433634373837303346343030303030303030303030303037373038303030303030313030303030303030303738);
INSERT INTO spring_session_attributes (session_primary_id, attribute_name, attribute_bytes) VALUES ('caaba56e-876c-40e7-8080-ef0a2063330e', 'cart', 0x30784143454430303035373337323030313136413631373636313245373537343639364332453438363137333638344436313730303530374441433143333136363044313033303030323436303030413643364636313634343636313633373436463732343930303039373436383732363537333638364636433634373837303346343030303030303030303030303037373038303030303030313030303030303030303738);
INSERT INTO spring_session_attributes (session_primary_id, attribute_name, attribute_bytes) VALUES ('6e0c05db-60c7-4216-9db9-23bdbd847251', 'cart', 0x30784143454430303035373337323030313136413631373636313245373537343639364332453438363137333638344436313730303530374441433143333136363044313033303030323436303030413643364636313634343636313633373436463732343930303039373436383732363537333638364636433634373837303346343030303030303030303030303037373038303030303030313030303030303030303738);
INSERT INTO spring_session_attributes (session_primary_id, attribute_name, attribute_bytes) VALUES ('208a2255-0f09-481f-8bc1-232e99c2ff5d', 'cart', 0x30784143454430303035373337323030313136413631373636313245373537343639364332453438363137333638344436313730303530374441433143333136363044313033303030323436303030413643364636313634343636313633373436463732343930303039373436383732363537333638364636433634373837303346343030303030303030303030303037373038303030303030313030303030303030303738);
INSERT INTO spring_session_attributes (session_primary_id, attribute_name, attribute_bytes) VALUES ('82866743-8dff-44a6-a51b-9762bc0f05ca', 'cart', 0x30784143454430303035373337323030313136413631373636313245373537343639364332453438363137333638344436313730303530374441433143333136363044313033303030323436303030413643364636313634343636313633373436463732343930303039373436383732363537333638364636433634373837303346343030303030303030303030303037373038303030303030313030303030303030303738);

-- Thêm cột lưu phí vận chuyển của đơn hàng
ALTER TABLE orders ADD shipping_fee DOUBLE PRECISION NOT NULL DEFAULT 0;

-- Thêm cột lưu tên phương thức vận chuyển (vd: Giao hàng hỏa tốc, Tiêu chuẩn)
-- Dumping data for table orders
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (26, NULL, 31000000, 'Chờ thanh toán', 'DH26', 'md', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-07 11:21:45.734');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (2, NULL, 8500000, 'Đã hủy', 'COD-PENDING', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-18 00:12:47.414');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (10, NULL, 213800000, 'COMPLETED', 'DH10', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-20 23:44:16.695');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (17, 5, 2, 'PENDING', 'DH17', 'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', '7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-22 11:19:22.674');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (18, 5, 3550000, 'SHIPPING', 'DH18', 'Thanh Pham', 'leecookcu@gmail.com', '0902208461', 'TPHCM', NULL, 50000, 'LXR36', NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-23 17:04:56.396');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (19, 5, 10900000, 'PENDING', 'DH19', 'Thanh Pham', 'leecookcu@gmail.com', '0902208461', 'TPHCM', NULL, 500000, 'LXR500', NULL, 0.00, NULL, 'INSTALLMENT', NULL, NULL, NULL, NULL, NULL, '2026-06-23 17:52:55.979');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (20, 2, 6500000, 'PENDING', 'DH20', 'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', 'tp', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-29 21:15:31.495');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (21, 5, 90000000, 'PENDING', 'DH21', 'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', '7/134/29/9 đường liên khu 5-6', NULL, 10000000, 'LUX10', NULL, 0.00, NULL, 'INSTALLMENT', NULL, NULL, NULL, NULL, NULL, '2026-07-02 11:03:00.775');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (22, NULL, 90000000, 'PENDING', 'DH22', 'Phạm Công Thanh', NULL, '0902208461', '7/134/29/9 đường liên khu 5-6', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-02 13:03:06.903');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (23, NULL, 120000000, 'PENDING', 'DH23', 'Phạm Công Thanh', NULL, '0902208461', '7/134/29/9 đường liên khu 5-6', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-02 13:03:58.891');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (24, 2, 5600000, 'PENDING', 'DH24', 'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', 'tp', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-03 09:00:31.482');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (25, 2, 7200000, 'Chờ thanh toán', 'DH25', 'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', 'tp', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-03 09:05:44.01');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (27, NULL, 6200000, 'PENDING', 'DH27', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07 11:22:24.148');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (28, NULL, 1950000, 'PENDING', 'DH28', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07 17:24:58.208');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (29, NULL, 1950000, 'PENDING', 'DH29', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07 18:17:37.769');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (30, 7, 1950000, 'THU_HOI', 'DH30', 'tuan nguyen', 'tuannguyennasani@gmail.com', '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07 19:57:59.626');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (1, NULL, 17200000, 'Chờ thanh toán', 'VIETQR-WAITING', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-06-19 00:12:46.958');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (3, NULL, 25900000, 'Đã thanh toán', 'VIETQR-PAID', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-06-17 00:12:47.866');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (6, NULL, 12500000, 'COMPLETED', 'VOUCHER-COMPLETED', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, 500000, 'QA500K', NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-14 00:12:49.207');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (5, NULL, 6900000, 'COMPLETED', 'CANCELLED', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-15 00:12:48.753');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (4, NULL, 18600000, 'DA_HOAN_TIE', 'DH63', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', 'OK | Đã hoàn', 'Đã thanh toán', 'Khách muốn trả hàng vì sản phẩm không phù hợp', NULL, NULL, '2026-06-16 00:12:48.31');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (31, 2, 190400000, 'PAID', 'DH31', 'tuan nguyen', 'tuan9bledinhchinh@gmail.com', '0905338411', 'thon tan quang, Phường Ngô Quyền, Thành phố Bắc Giang, Tỉnh Bắc Giang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-11 16:11:46.406');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (8, NULL, 21500000, 'DA_HOAN_TIE', 'DH62', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', 'Đã hoàn tiền qua MB Bank', 'Đã thanh toán', 'Khách yêu cầu hoàn tiền', NULL, NULL, '2026-06-12 00:12:50.287');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (9, NULL, 15700000, 'THU_HOI', 'DH61', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', 'Thu hồi theo yêu cầu kiểm thử', 'Đã thanh toán', 'Khách yêu cầu trả hàng', NULL, NULL, '2026-06-11 00:12:50.817');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (7, NULL, 19900000, 'THU_HOI', 'DH60', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', 'Admin đã duyệt yêu cầu hoàn tiền', 'Đã thanh toán', 'Khách yêu cầu hoàn tiền', NULL, NULL, '2026-06-13 00:12:49.74');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (11, NULL, 150000000, 'COMPLETED', 'MAR-1', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-15 10:00:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (12, NULL, 220000000, 'COMPLETED', 'MAR-2', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-25 14:30:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (13, NULL, 185000000, 'COMPLETED', 'APR-1', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-10 09:15:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (14, NULL, 315000000, 'COMPLETED', 'APR-2', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-20 16:45:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (15, NULL, 280000000, 'COMPLETED', 'MAY-1', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-05 11:20:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (16, NULL, 195000000, 'COMPLETED', 'MAY-2', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', 'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-18 13:10:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (38, 3, 10000, 'Chờ thanh toán', 'DH38', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Nam Ka, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 19:05:37.372');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (39, 3, 10000, 'Chờ thanh toán', 'DH39', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea Ning, Huyện Cư Kuin, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 19:10:23.876');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (40, 3, 10000, 'Chờ thanh toán', 'DH40', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea Ning, Huyện Cư Kuin, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 19:53:25.074');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (41, 3, 10000, 'Chờ thanh toán', 'DH41', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea R''Bin, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 20:34:44.343');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (32, 9, 600000, 'COMPLETED', 'DH32', 'Nguyễn Trường Quân', 'truongquan577@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-13 22:22:01.34');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (33, 5, 825000000, 'COMPLETED', 'DH33', 'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', '7/134/29/9 đường liên khu 5-6, Phường Hàng Trống, Quận Hoàn Kiếm, Thành phố Hà Nội', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-14 13:43:34.142');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (34, 2, 2375000, 'PENDING', 'DH34', 'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', 'tp, Xã Yên Sơn, Huyện Yên Châu, Tỉnh Sơn La', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-14 16:50:43.95');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (35, 3, 600000, 'Chờ thanh toán', 'DH35', 'Quân Nguyễn Trường', 'nguyentruongq169@gmail.com', '0867868825', 'q, Xã Tiền Tiến, Thành phố Hải Dương, Tỉnh Hải Dương', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 17:30:01.596');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (36, 3, 8500000, 'PENDING', 'DH36', 'Quân Nguyễn Trường', 'nguyentruongq169@gmail.com', '0867868825', 'q, Xã Tiền Tiến, Thành phố Hải Dương, Tỉnh Hải Dương', NULL, 0, NULL, NULL, 0.00, NULL, 'EWALLET', NULL, NULL, NULL, NULL, NULL, '2026-07-14 17:30:49.368');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (37, 3, 8500000, 'Chờ thanh toán', 'DH37', 'Quân Nguyễn Trường', 'nguyentruongq169@gmail.com', '0867868825', 'q, Xã Tiền Tiến, Thành phố Hải Dương, Tỉnh Hải Dương', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 17:32:25.37');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (42, 3, 10000, 'Chờ thanh toán', 'DH42', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Nam Ka, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 21:46:26.074');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (43, 3, 10000, 'Chờ thanh toán', 'DH43', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Nam Ka, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 22:07:27.131');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (44, 3, 10000, 'Đã thanh toán', 'DH44', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea BHốk, Huyện Cư Kuin, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 22:10:45.309');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (45, 3, 10000, 'Đã thanh toán', 'DH45', 'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', 'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Cư Klông, Huyện Krông Năng, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 22:15:01.122');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (46, NULL, 16500000, 'PENDING', 'DH46', 'Phạm Công Thanh', NULL, '0902208461', '7/134/29/9 đường liên khu 5-6, Phường Hợp Giang, Thành phố Cao Bằng, Tỉnh Cao Bằng', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-15 13:09:04.701');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (47, 5, 1620000, 'PENDING', 'DH47', 'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', '7/134/29/9 đường liên khu 5-6, Phường Phúc Xá, Quận Ba Đình, Thành phố Hà Nội', NULL, 0, NULL, NULL, 0.00, NULL, 'INSTALLMENT', NULL, NULL, NULL, NULL, NULL, '2026-07-15 17:26:21.271');

SELECT * FROM orders;

-- Dumping data for table order_items
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (1, 1, 7, 17200000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (2, 2, 12, 8500000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (3, 3, 13, 25900000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (4, 4, 14, 18600000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (5, 5, 14, 6900000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (6, 7, 7, 19900000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (7, 8, 12, 21500000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (8, 9, 13, 15700000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (9, 10, 7, 18500000, 10);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (10, 10, 12, 3200000, 9);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (11, 17, 89, 1, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (12, 18, 14, 1800000, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (13, 19, 13, 3800000, 3);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (14, 20, 23, 6500000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (15, 21, 54, 10000000, 10);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (16, 22, 13, 3000000, 30);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (17, 23, 3, 3000000, 40);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (18, 24, 17, 5600000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (19, 25, 19, 7200000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (20, 26, 18, 6200000, 5);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (21, 27, 18, 6200000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (22, 28, 22, 1950000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (23, 29, 22, 1950000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (24, 30, 22, 1950000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (25, 31, 256, 12000000, 3);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (26, 31, 274, 2000000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (27, 31, 259, 7500000, 3);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (28, 31, 275, 3500000, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (29, 31, 276, 2800000, 3);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (30, 31, 262, 1200000, 3);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (31, 31, 264, 25000000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (32, 31, 265, 35000000, 2);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (33, 31, 268, 1800000, 3);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (34, 31, 270, 3500000, 3);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (35, 32, 277, 600000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (36, 33, 279, 16500000, 50);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (37, 34, 257, 2500000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (38, 35, 277, 600000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (39, 36, 286, 8500000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (40, 37, 286, 8500000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (41, 46, 279, 16500000, 1);
INSERT INTO order_items (id, order_id, product_id, price, quantity) VALUES (42, 47, 260, 1800000, 1);

-- Dumping data for table reviews
INSERT INTO reviews (id, content, created_at, stars, user_id, product_id, order_id, title, image, video) VALUES (1, 'Máy build từ Luxury PC chạy mượt như mơ. RTX 4090 kết hợp với i9-14900K — không có game nào kháng cự được. Đáng từng đồng bỏ ra.', '2026-06-02 19:05:41.163089', 5, 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO reviews (id, content, created_at, stars, user_id, product_id, order_id, title, image, video) VALUES (2, 'Dịch vụ tư vấn chuyên nghiệp, lắp ráp cực kỳ thẩm mỹ. Tôi rất hài lòng với chiếc Workstation mới này.', '2026-06-02 19:05:41.163089', 5, 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO reviews (id, content, created_at, stars, user_id, product_id, order_id, title, image, video) VALUES (3, 'Bảo hành nhanh chóng, nhân viên nhiệt tình hỗ trợ. Xứng đáng với danh hiệu Luxury PC.', '2026-06-02 19:05:41.163089', 4, 1, NULL, NULL, NULL, NULL, NULL);

-- Dumping data for table wishlist_items
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (1, '2026-06-29 21:14:37.8', 23, 2);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (2, '2026-07-14 11:28:57.94', 280, 5);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (3, '2026-07-14 11:29:01.571', 281, 5);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (4, '2026-07-14 11:29:04.825', 259, 5);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (5, '2026-07-14 11:48:13.712', 283, 5);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (6, '2026-07-14 12:01:09.248', 256, 5);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (7, '2026-07-14 13:44:58.85', 278, 5);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (8, '2026-07-14 14:29:47.096', 284, 5);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (9, '2026-07-16 09:09:11.326', 57, 5);

-- Dumping data for table inventory
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

-- Dumping data for table stock_movements
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (1, 1, 23, 'IMPORT', '', '2026-04-23 12:54:40.508');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (2, 148, 2, 'EXPORT', 'ok', '2026-06-12 10:45:03.715');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (3, 148, 17, 'IMPORT', '', '2026-06-12 10:45:14.706');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (4, 35, 2, 'EXPORT', 'Tru kho cho don DH71', '2026-06-12 14:53:10.375');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (5, 4, 3, 'EXPORT', 'Tru kho cho don DH74', '2026-06-12 17:18:37.969');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (6, 5, 1, 'EXPORT', 'Tru kho cho don DH75', '2026-06-12 17:21:06.3');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (7, 148, 1, 'IMPORT', '', '2026-07-14 13:48:58.514');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (8, 148, 1, 'EXPORT', '', '2026-07-14 13:49:22.926');
INSERT INTO stock_movements (id, product_id, change_quantity, movement_type, note, created_at) VALUES (9, 148, 1, 'IMPORT', '', '2026-07-14 13:54:16.531');

-- Dumping data for table flash_sale_items
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

-- Dumping data for table pc_combo_details
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (1, 'cpu', 1, 256);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (2, 'mainboard', 1, 259);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (3, 'ram', 1, 262);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (4, 'vga', 1, 264);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (5, 'storage', 1, 268);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (6, 'psu', 1, 270);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (7, 'case', 1, 274);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (8, 'cooling', 1, 276);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (9, 'cpu', 2, 256);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (10, 'mainboard', 2, 259);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (11, 'ram', 2, 262);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (12, 'vga', 2, 265);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (13, 'storage', 2, 268);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (14, 'psu', 2, 270);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (15, 'case', 2, 275);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (16, 'cooling', 2, 276);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (17, 'cpu', 3, 257);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (18, 'mainboard', 3, 260);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (19, 'ram', 3, 263);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (20, 'vga', 3, 266);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (21, 'storage', 3, 269);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (22, 'psu', 3, 271);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (23, 'case', 3, 16);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (24, 'cooling', 3, 277);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (25, 'cpu', 4, 257);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (26, 'mainboard', 4, 261);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (27, 'ram', 4, 263);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (28, 'vga', 4, 267);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (29, 'storage', 4, 269);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (30, 'psu', 4, 272);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (31, 'case', 4, 16);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (32, 'cooling', 4, 277);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (33, 'cpu', 5, 258);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (34, 'mainboard', 5, 261);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (35, 'ram', 5, 263);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (36, 'vga', 5, 266);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (37, 'storage', 5, 269);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (38, 'psu', 5, 273);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (39, 'case', 5, 274);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (40, 'cooling', 5, 276);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (41, 'cpu', 6, 1);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (42, 'mainboard', 6, 91);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (43, 'ram', 6, 67);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (44, 'vga', 6, 284);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (45, 'storage', 6, 285);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (46, 'psu', 6, 270);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (47, 'case', 6, 275);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (48, 'cooling', 6, 286);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (49, 'cpu', 7, 279);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (50, 'mainboard', 7, 102);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (51, 'ram', 7, 62);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (52, 'vga', 7, 265);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (53, 'storage', 7, 285);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (54, 'psu', 7, 270);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (55, 'case', 7, 275);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (56, 'cooling', 7, 276);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (57, 'cpu', 1, 256);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (58, 'mainboard', 1, 259);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (59, 'ram', 1, 262);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (60, 'vga', 1, 264);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (61, 'storage', 1, 268);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (62, 'psu', 1, 270);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (63, 'case', 1, 274);
INSERT INTO pc_combo_details (id, slot_type, combo_id, product_id) VALUES (64, 'cooling', 1, 276);

-- Dumping data for table user_vouchers
INSERT INTO user_vouchers (id, user_id, voucher_id, saved_at, used_at, reservation_expires_at, status) VALUES (1, 2, 1, '2026-07-18 17:47:03.908000', NULL, NULL, 'AVAILABLE');
INSERT INTO user_vouchers (id, user_id, voucher_id, saved_at, used_at, reservation_expires_at, status) VALUES (2, 2, 2, '2026-07-18 19:17:53.976000', NULL, NULL, 'AVAILABLE');

-- Dumping data for table chat_messages
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (1, '2026-07-13 19:25:31.798', 'j', 'ADMI', 'tuan9bledinhchinh@gmail.com', 7);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (2, '2026-07-14 09:45:55.056', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', '36', 8);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (3, '2026-07-14 09:45:58.208', 'cc', 'CUSTOMER', '36', 8);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (4, '2026-07-14 09:45:59.481', 'Cảm ơn bạn đã nhắn tin cho ban hỗ trợ khách hàng Luxury PC. Nhân viên tư vấn đang kiểm tra thông tin và sẽ phản hồi chi tiết tới bạn trong giây lát! Bạn vui lòng đợi 1-2 phút nhé. 💬', 'ADMI', 'tuan9bledinhchinh@gmail.com', 8);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (5, '2026-07-14 09:46:00.771', 'c', 'CUSTOMER', '36', 8);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (6, '2026-07-14 09:46:02.628', 'Cảm ơn bạn đã nhắn tin cho ban hỗ trợ khách hàng Luxury PC. Nhân viên tư vấn đang kiểm tra thông tin và sẽ phản hồi chi tiết tới bạn trong giây lát! Bạn vui lòng đợi 1-2 phút nhé. 💬', 'ADMI', 'tuan9bledinhchinh@gmail.com', 8);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (7, '2026-07-14 09:46:05.48', 'c', 'CUSTOMER', '36', 8);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (8, '2026-07-14 09:46:06.633', 'Cảm ơn bạn đã nhắn tin cho ban hỗ trợ khách hàng Luxury PC. Nhân viên tư vấn đang kiểm tra thông tin và sẽ phản hồi chi tiết tới bạn trong giây lát! Bạn vui lòng đợi 1-2 phút nhé. 💬', 'ADMI', 'tuan9bledinhchinh@gmail.com', 8);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (9, '2026-07-14 13:29:48.682', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', 'Thanh', 9);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (10, '2026-07-14 13:30:09.937', 'alo em à em', 'CUSTOMER', 'Thanh', 9);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (11, '2026-07-14 13:30:11.141', 'Cảm ơn bạn đã nhắn tin cho ban hỗ trợ khách hàng Luxury PC. Nhân viên tư vấn đang kiểm tra thông tin và sẽ phản hồi chi tiết tới bạn trong giây lát! Bạn vui lòng đợi 1-2 phút nhé. 💬', 'ADMI', 'leecookcu@gmail.com', 9);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (12, '2026-07-14 17:19:19.185', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', '36', 10);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (13, '2026-07-15 10:47:51.945', 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', 'Thanh', 11);

-- ----------------------------
-- Table structure & sample data for news_categories
-- ----------------------------
IF NOT EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID('news_categories') AND type IN ('U'))
BEGIN
    CREATE TABLE news_categories (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        slug VARCHAR(100) NOT NULL UNIQUE,
        description TEXT,
        status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
END;

INSERT INTO news_categories (id, name, slug, status) VALUES (1, 'Card Đồ Họa', 'card-do-hoa', 'ACTIVE') ON CONFLICT (id) DO NOTHING;
IF NOT EXISTS (SELECT 1 FROM news_categories WHERE id = 2) INSERT INTO news_categories (id, name, slug, status) VALUES (2, 'Bộ Vi Xử Lý (CPU)', 'bo-vi-xu-ly', 'ACTIVE');
INSERT INTO news_categories (id, name, slug, status) VALUES (3, 'Khuyến Mãi & Sự Kiện', 'khuyen-mai-su-kien', 'ACTIVE') ON CONFLICT (id) DO NOTHING;
INSERT INTO news_categories (id, name, slug, status) VALUES (4, 'Tư Vấn Cấu Hình', 'tu-van-cau-hinh', 'ACTIVE') ON CONFLICT (id) DO NOTHING;
IF NOT EXISTS (SELECT 1 FROM news_categories WHERE id = 5) INSERT INTO news_categories (id, name, slug, status) VALUES (5, 'Lưu Trữ (SSD/HDD)', 'luu-tru-ssd-hdd', 'ACTIVE');
INSERT INTO news_categories (id, name, slug, status) VALUES (6, 'Mẹo & Thủ Thuật', 'meo-thu-thuat', 'ACTIVE') ON CONFLICT (id) DO NOTHING;

-- ----------------------------
-- Table structure & sample data for news
-- ----------------------------
IF NOT EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID('news') AND type IN ('U'))
BEGIN
    CREATE TABLE news (
        id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        slug VARCHAR(255) NOT NULL UNIQUE,
        content TEXT NOT NULL,
        summary TEXT NOT NULL,
        thumbnail VARCHAR(255),
        view_count BIGINT DEFAULT 0,
        meta_title VARCHAR(255),
        meta_description TEXT,
        meta_keywords VARCHAR(255),
        status VARCHAR(20) DEFAULT 'PUBLISHED',
        category_id INT FOREIGN KEY REFERENCES news_categories(id),
        author_id INT NOT NULL FOREIGN KEY REFERENCES users(id),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
END;

INSERT INTO news (content, created_at, slug, summary, thumbnail, title, updated_at, author_id, meta_description, meta_keywords, meta_title, view_count, category_id, status)
VALUES
('<h2>RTX 5060 chính thức ra mắt</h2><p>NVIDIA đã giới thiệu RTX 5060 với kiến trúc Blackwell, hỗ trợ DLSS 4 và Ray Tracing thế hệ mới.</p><ul><li>Hiệu năng tăng khoảng 30% so với RTX 4060</li><li>Chơi game 2K mượt mà</li><li>Tiêu thụ điện thấp hơn</li></ul>',
CURRENT_TIMESTAMP, 'rtx-5060-ra-mat', 'NVIDIA RTX 5060 mang đến hiệu năng mạnh mẽ cho game thủ và người sáng tạo nội dung.', 'rtx5060.jpg', 'RTX 5060 chính thức ra mắt', CURRENT_TIMESTAMP, (SELECT id FROM users LIMIT 1), 'Đánh giá RTX 5060 mới nhất.', 'RTX5060,NVIDIA,GPU,Gaming', 'RTX 5060 chính thức ra mắt', 120, 1, 'PUBLISHED'),
('<h2>Top 5 CPU Gaming 2026</h2><p>Danh sách CPU đáng mua nhất dành cho game thủ.</p><ol><li>Ryzen 5 9600X</li><li>Ryzen 7 9800X3D</li><li>Core i5-15600K</li><li>Core i7-15700K</li><li>Ryzen 9 9950X</li></ol>',
CURRENT_TIMESTAMP, 'top-cpu-gaming-2026', 'Những bộ vi xử lý tốt nhất dành cho game thủ năm 2026.', 'cpu2026.jpg', 'Top 5 CPU Gaming đáng mua năm 2026', CURRENT_TIMESTAMP, (SELECT id FROM users LIMIT 1), 'Danh sách CPU Intel và AMD mạnh nhất.', 'CPU,Intel,AMD,Gaming', 'Top CPU Gaming 2026', 85, 2, 'PUBLISHED'),
('<h2>Flash Sale cuối tuần</h2><p>Giảm giá đến 40% cho nhiều linh kiện PC.</p><p>Áp dụng cho VGA, RAM, SSD và Mainboard.</p>',
CURRENT_TIMESTAMP, 'flash-sale-cuoi-tuan', 'Chương trình Flash Sale cuối tuần với hàng trăm ưu đãi hấp dẫn.', 'flashsale.jpg', 'Flash Sale cuối tuần giảm đến 40%', CURRENT_TIMESTAMP, (SELECT id FROM users LIMIT 1), 'Khuyến mãi lớn cuối tuần.', 'Flash Sale,Khuyến mãi,Linh kiện', 'Flash Sale linh kiện PC', 240, 3, 'PUBLISHED'),
('<h2>Build PC Gaming 25 triệu</h2><p>Cấu hình đề xuất:</p><ul><li>Ryzen 5 9600X</li><li>RTX 5060</li><li>RAM DDR5 32GB</li><li>SSD NVMe 1TB</li></ul>',
CURRENT_TIMESTAMP, 'build-pc-25-trieu', 'Tư vấn cấu hình PC Gaming tối ưu trong tầm giá 25 triệu.', 'build25.jpg', 'Hướng dẫn Build PC Gaming 25 triệu', CURRENT_TIMESTAMP, (SELECT id FROM users LIMIT 1), 'Cấu hình PC Gaming hiệu năng cao.', 'Build PC,Gaming,RTX5060', 'Build PC Gaming 25 triệu', 61, 4, 'PUBLISHED'),
('<h2>SSD PCIe Gen5 có đáng mua?</h2><p>SSD Gen5 có tốc độ lên tới 14GB/s nhưng không phải ai cũng cần nâng cấp.</p>',
CURRENT_TIMESTAMP, 'ssd-pcie-gen5', 'So sánh SSD PCIe Gen5 và Gen4 trong thực tế.', 'ssdgen5.jpg', 'SSD PCIe Gen5 có thật sự đáng nâng cấp?', CURRENT_TIMESTAMP, (SELECT id FROM users LIMIT 1), 'Đánh giá SSD PCIe Gen5.', 'SSD,NVMe,Gen5', 'SSD PCIe Gen5', 35, 5, 'PUBLISHED'),
('<h2>5 mẹo giúp máy tính chơi game mượt hơn</h2><ul><li>Cập nhật Driver.</li><li>Nâng cấp SSD.</li><li>Nâng RAM.</li><li>Bật Game Mode.</li><li>Vệ sinh máy định kỳ.</li></ul>',
CURRENT_TIMESTAMP, 'meo-toi-uu-pc-gaming', 'Hướng dẫn tối ưu hiệu năng máy tính để chơi game.', 'optimize.jpg', '5 mẹo giúp máy tính chơi game mượt hơn', CURRENT_TIMESTAMP, (SELECT id FROM users LIMIT 1), 'Mẹo tối ưu Windows và phần cứng.', 'FPS,Gaming,Windows,Tối ưu', 'Tối ưu PC Gaming', 52, 6, 'PUBLISHED');

-- ----------------------------
-- Records of brands
-- ----------------------------
INSERT INTO brands (name, logo, link, display_order)
VALUES
('Intel', '/images/ui-new/intel.svg', '/products?brand=Intel', 1),
('AMD', '/images/ui-new/amd.svg', '/products?brand=AMD', 2),
('ASUS', '/images/ui-new/asus.svg', '/products?brand=ASUS', 3),
('MSI', '/images/ui-new/msi.svg', '/products?brand=MSI', 4),
('GIGABYTE', '/images/ui-new/gigabyte.svg', '/products?brand=GIGABYTE', 5),
('Corsair', '/images/ui-new/corsair.svg', '/products?brand=Corsair', 6),
('Kingston', '/images/ui-new/kingston.svg', '/products?brand=Kingston', 7),
('Cooler Master', '/images/ui-new/coolermaster.svg', '/products?brand=Cooler Master', 8);

-- ----------------------------
-- Table structure for sepay_payment_sessions
-- ----------------------------
DROP TABLE IF EXISTS sepay_payment_sessions CASCADE;
CREATE TABLE sepay_payment_sessions (
  id BIGSERIAL PRIMARY KEY,
  order_id INT NOT NULL,
  qr_created_at TIMESTAMP NOT NULL,
  qr_expires_at TIMESTAMP NOT NULL,
  paid_at TIMESTAMP,
  expired_at TIMESTAMP,
  CONSTRAINT fk_sepay_payment_sessions_orders FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_sepay_payment_sessions_order_created ON sepay_payment_sessions (order_id, qr_created_at DESC);

-- ======================================================
-- Reset Sequences to Max ID for Auto-Increment Tables
-- ======================================================
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT c.table_name, c.column_name, pg_get_serial_sequence(c.table_name, c.column_name) AS seq
        FROM information_schema.columns c
        WHERE c.table_schema = 'public' 
          AND pg_get_serial_sequence(c.table_name, c.column_name) IS NOT NULL
    ) LOOP
        EXECUTE format('SELECT setval(%L, COALESCE((SELECT MAX(%I) FROM %I), 1))', r.seq, r.column_name, r.table_name);
    END LOOP;
END $$;
