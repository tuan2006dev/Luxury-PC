-- ======================================================
-- SQL Server Table Structures (CREATE TABLE)
-- Ordered Topologically
-- Date: 2026-07-19
-- ======================================================

CREATE  DATABASE LUXURYPC;
GO

USE LUXURYPC;
GO

-- --------------------------------------------------
-- DROP ALL EXISTING FOREIGN KEYS DYNAMICALLY
-- --------------------------------------------------
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_NAME(parent_object_id)) + N' DROP CONSTRAINT ' + QUOTENAME(name) + N';' + CHAR(13) + CHAR(10)
FROM sys.foreign_keys;
IF @sql <> N''
    EXEC sp_executesql @sql;
GO

-- ----------------------------
-- Table structure for flyway_schema_history
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'flyway_schema_history') AND type IN ('U'))
	DROP TABLE flyway_schema_history;
GO
CREATE TABLE flyway_schema_history (
  installed_rank INT NOT NULL,
  version NVARCHAR(50),
  description NVARCHAR(200)  NOT NULL,
  type NVARCHAR(20)  NOT NULL,
  script NVARCHAR(1000)  NOT NULL,
  checksum INT,
  installed_by NVARCHAR(100)  NOT NULL,
  installed_on DATETIME2 NOT NULL DEFAULT GETDATE(),
  execution_time INT NOT NULL,
  success BIT NOT NULL
);
GO

-- ----------------------------
-- Table structure for sepay_transactions
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'sepay_transactions') AND type IN ('U'))
	DROP TABLE sepay_transactions;
GO
CREATE TABLE sepay_transactions (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  account_number NVARCHAR(100),
  order_code NVARCHAR(100),
  payment_code NVARCHAR(100),
  processed_at DATETIME2,
  processing_status NVARCHAR(100),
  raw_payload NVARCHAR(MAX),
  received_at DATETIME2,
  sepay_transaction_id BIGINT,
  transfer_amount DECIMAL(18,2),
  transfer_type NVARCHAR(100)
);
GO

-- ----------------------------
-- Table structure for roles
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'roles') AND type IN ('U'))
	DROP TABLE roles;
GO
CREATE TABLE roles (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  name NVARCHAR(255)  NOT NULL
);
GO

-- ----------------------------
-- Table structure for users
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'users') AND type IN ('U'))
	DROP TABLE users;
GO
CREATE TABLE users (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  username NVARCHAR(255),
  email NVARCHAR(255)  NOT NULL UNIQUE,
  password NVARCHAR(255) NULL,
  full_name NVARCHAR(255),
  phone NVARCHAR(255),
  address NVARCHAR(MAX),
  enabled BIT DEFAULT 1,
  auth_provider NVARCHAR(255),
  google_id NVARCHAR(255),
  facebook_id NVARCHAR(255),
  avatar NVARCHAR(255),
  birthday DATETIME2,
  gender BIT,
  status BIT,
  notify_flash_sale BIT,
  notify_new_products BIT,
  notify_order_updates BIT,
  notify_weekly_newsletter BIT,
  two_factor_enabled BIT,
  created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- ----------------------------
-- Table structure for categories
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'categories') AND type IN ('U'))
	DROP TABLE categories;
GO
CREATE TABLE categories (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  name NVARCHAR(100)  NOT NULL,
  display NVARCHAR(MAX),
  slug NVARCHAR(255)
);
GO

-- ----------------------------
-- Table structure for news_categories
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'news_categories') AND type IN ('U'))
	DROP TABLE news_categories;
GO
CREATE TABLE news_categories (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  created_at DATETIME2,
  description NVARCHAR(MAX),
  name NVARCHAR(100)  NOT NULL,
  slug NVARCHAR(100)  NOT NULL,
  status NVARCHAR(20)  NOT NULL,
  updated_at DATETIME2
);
GO

-- ----------------------------
-- Table structure for flash_sales
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'flash_sales') AND type IN ('U'))
	DROP TABLE flash_sales;
GO
CREATE TABLE flash_sales (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  active BIT,
  created_at DATETIME2,
  end_time DATETIME2,
  name NVARCHAR(255),
  start_time DATETIME2
);
GO

ALTER TABLE flash_sales
ADD description NVARCHAR(500) NULL,
    max_per_user INT NULL;

-- ----------------------------
-- Table structure for pc_combos
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'pc_combos') AND type IN ('U'))
	DROP TABLE pc_combos;
GO
CREATE TABLE pc_combos (
  id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  badge NVARCHAR(255),
  badge_color NVARCHAR(255),
  description NVARCHAR(255),
  image NVARCHAR(255),
  name NVARCHAR(255),
  price DECIMAL(18,2)
);
GO

-- ----------------------------
-- Table structure for spring_session
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'spring_session') AND type IN ('U'))
	DROP TABLE spring_session;
GO
CREATE TABLE spring_session (
  primary_id char(36) NOT NULL PRIMARY KEY,
  session_id char(36) NOT NULL,
  creation_time BIGINT NOT NULL,
  last_access_time BIGINT NOT NULL,
  max_inactive_interval INT NOT NULL,
  expiry_time BIGINT NOT NULL,
  principal_name NVARCHAR(100)
);
GO

-- ----------------------------
-- Table structure for game_engine_traits
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'game_engine_traits') AND type IN ('U'))
	DROP TABLE game_engine_traits;
GO
CREATE TABLE game_engine_traits (
  game_name NVARCHAR(255) NOT NULL PRIMARY KEY,
  cpu_dependency_weight FLOAT
);
GO





-- ----------------------------
-- Table structure for fps_baselines
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'fps_baselines') AND type IN ('U'))
	DROP TABLE fps_baselines;
GO
CREATE TABLE fps_baselines (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  estimated_fps INT,
  preset NVARCHAR(255),
  resolution NVARCHAR(255)
);
GO

-- ----------------------------
-- Table structure for component_benchmarks
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'component_benchmarks') AND type IN ('U'))
	DROP TABLE component_benchmarks;
GO
CREATE TABLE component_benchmarks (
  product_id INT NOT NULL,
  cpu_multi_core_score INT,
  gpu_rasterization_score INT
);
GO

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'user_roles') AND type IN ('U'))
	DROP TABLE user_roles;
GO
CREATE TABLE user_roles (
  user_id INT NOT NULL,
  role_id INT NOT NULL,
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
);
GO

-- ----------------------------
-- Table structure for user_sessions
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'user_sessions') AND type IN ('U'))
	DROP TABLE user_sessions;
GO
CREATE TABLE user_sessions (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  user_id INT NOT NULL,
  session_id NVARCHAR(255)  NOT NULL,
  user_agent NVARCHAR(500),
  device_info NVARCHAR(255),
  ip_address NVARCHAR(50),
  location NVARCHAR(100),
  login_time DATETIME2 DEFAULT CURRENT_TIMESTAMP,
  last_activity DATETIME2 DEFAULT CURRENT_TIMESTAMP,
  is_expired BIT DEFAULT 0
);
GO

-- ----------------------------
-- Table structure for shipping_addresses
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'shipping_addresses') AND type IN ('U'))
	DROP TABLE shipping_addresses;
GO
CREATE TABLE shipping_addresses (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  address NVARCHAR(500)  NOT NULL,
  city NVARCHAR(120),
  is_default BIT NOT NULL,
  district NVARCHAR(120),
  phone NVARCHAR(255)  NOT NULL,
  recipient_name NVARCHAR(255)  NOT NULL,
  user_id INT NOT NULL
);
GO

-- ----------------------------
-- Table structure for user_addresses
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'user_addresses') AND type IN ('U'))
	DROP TABLE user_addresses;
GO
CREATE TABLE user_addresses (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  address NVARCHAR(500)  NOT NULL,
  city NVARCHAR(150),
  created_at DATETIME2,
  district NVARCHAR(150),
  is_default BIT,
  phone NVARCHAR(255)  NOT NULL,
  recipient_name NVARCHAR(255)  NOT NULL,
  updated_at DATETIME2,
  user_id INT NOT NULL,
  address_line NVARCHAR(1000),
  receiver_name NVARCHAR(255)
);
GO

-- ----------------------------
-- Table structure for user_notification_settings
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'user_notification_settings') AND type IN ('U'))
	DROP TABLE user_notification_settings;
GO
CREATE TABLE user_notification_settings (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  flash_sale BIT,
  member_points BIT,
  new_products BIT,
  order_updates BIT,
  updated_at DATETIME2,
  weekly_newsletter BIT,
  user_id INT NOT NULL
);
GO

-- ----------------------------
-- Table structure for carts
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'carts') AND type IN ('U'))
	DROP TABLE carts;
GO
CREATE TABLE carts (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  user_id INT NOT NULL,
  created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- ----------------------------
-- Table structure for pc_builds
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'pc_builds') AND type IN ('U'))
	DROP TABLE pc_builds;
GO
CREATE TABLE pc_builds (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  user_id INT NOT NULL,
  total_price numeric(15,2) DEFAULT 0,
  created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- ----------------------------
-- Table structure for support_tickets
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'support_tickets') AND type IN ('U'))
	DROP TABLE support_tickets;
GO
CREATE TABLE support_tickets (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  admin_reply NVARCHAR(MAX),
  assigned_admin NVARCHAR(255),
  build_config NVARCHAR(MAX),
  category NVARCHAR(255),
  created_at DATETIME2,
  customer_email NVARCHAR(255),
  customer_name NVARCHAR(255),
  customer_phone NVARCHAR(255),
  message NVARCHAR(MAX),
  status NVARCHAR(255),
  subject NVARCHAR(1000),
  updated_at DATETIME2,
  user_id INT
);
GO

-- ----------------------------
-- Table structure for tickets
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'tickets') AND type IN ('U'))
	DROP TABLE tickets;
GO
CREATE TABLE tickets (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  assigned_admin NVARCHAR(255),
  build_config NVARCHAR(MAX),
  category NVARCHAR(255),
  created_at DATETIME2,
  customer_email NVARCHAR(255),
  customer_name NVARCHAR(255)  NOT NULL,
  customer_phone NVARCHAR(255),
  message NVARCHAR(MAX),
  status NVARCHAR(255),
  subject NVARCHAR(255)  NOT NULL
);
GO

-- ----------------------------
-- Table structure for products
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'products') AND type IN ('U'))
	DROP TABLE products;
GO
CREATE TABLE products (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  name NVARCHAR(200)  NOT NULL,
  price DECIMAL(18,2) NOT NULL,
  description NVARCHAR(MAX),
  image NVARCHAR(255),
  category_id INT,
  stock INT DEFAULT 0,
  created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP,
  brand NVARCHAR(100)
);
GO

-- ----------------------------
-- Table structure for vouchers
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'vouchers') AND type IN ('U'))
	DROP TABLE vouchers;
GO
CREATE TABLE vouchers (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  active BIT,
  code NVARCHAR(255)  NOT NULL,
  created_at DATETIME2,
  description NVARCHAR(255),
  discount_type NVARCHAR(255),
  discount_value DECIMAL(18,2),
  end_date DATETIME2,
  max_discount_amount DECIMAL(18,2),
  min_order_amount DECIMAL(18,2),
  start_date DATETIME2,
  usage_limit INT,
  used_count INT,
  category_id INT
);
GO

-- ----------------------------
-- Table structure for news
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'news') AND type IN ('U'))
	DROP TABLE news;
GO
CREATE TABLE news (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  content NVARCHAR(MAX),
  created_at DATETIME2,
  slug NVARCHAR(255)  NOT NULL,
  summary NVARCHAR(MAX),
  thumbnail NVARCHAR(255),
  title NVARCHAR(255)  NOT NULL,
  updated_at DATETIME2,
  author_id INT NOT NULL,
  meta_description NVARCHAR(MAX),
  meta_keywords NVARCHAR(255),
  meta_title NVARCHAR(255),
  view_count BIGINT DEFAULT 0,
  category_id INT,
  status NVARCHAR(20)
);
GO

-- ----------------------------
-- Table structure for spring_session_attributes
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'spring_session_attributes') AND type IN ('U'))
	DROP TABLE spring_session_attributes;
GO
CREATE TABLE spring_session_attributes (
  session_primary_id char(36) NOT NULL,
  attribute_name NVARCHAR(200) NOT NULL,
  attribute_bytes VARBINARY(MAX) NOT NULL,
  PRIMARY KEY (session_primary_id, attribute_name)
);
GO

-- ----------------------------
-- Table structure for shared_builds
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'shared_builds') AND type IN ('U'))
	DROP TABLE shared_builds;
GO
CREATE TABLE shared_builds (
  share_code NVARCHAR(15) NOT NULL PRIMARY KEY,
  build_id INT NOT NULL,
  name NVARCHAR(100)  DEFAULT 'Cấu hình chia sẻ từ LuxuryPC',
  created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP,
  case_id NVARCHAR(50),
  cooler_id NVARCHAR(50),
  cpu_id NVARCHAR(50),
  gpu_id NVARCHAR(50),
  mainboard_id NVARCHAR(50),
  psu_id NVARCHAR(50),
  ram_id NVARCHAR(50),
  total_price numeric(38,2),
  storage_id NVARCHAR(50)
);
GO

-- Xóa cột build_id (nếu nó đang là khóa chính thì phải DROP CONSTRAINT trước)
-- Giả sử hệ thống tự sinh tên Constraint khóa chính cũ là PK__shared_b__...
-- (Đoạn này Hibernate đã tự động đối chiếu và DROP cột dư thừa)
ALTER TABLE shared_builds 
DROP COLUMN build_id;
GO
-- Đặt lại Khóa chính (Primary Key) cho cột share_code
ALTER TABLE shared_builds 
ADD CONSTRAINT PK_shared_builds PRIMARY KEY (share_code);
GO

-- ----------------------------
-- Table structure for orders
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'orders') AND type IN ('U'))
	DROP TABLE orders;
GO
CREATE TABLE orders (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  user_id INT,
  total_price DECIMAL(18,2),
  status NVARCHAR(50),
  order_code NVARCHAR(255),
  full_name NVARCHAR(255),
  email NVARCHAR(255),
  phone NVARCHAR(255),
  address NVARCHAR(MAX),
  city NVARCHAR(255),
  discount_amount DECIMAL(18,2) DEFAULT 0,
  voucher_code NVARCHAR(255),
  installment_bank NVARCHAR(255),
  installment_fee numeric(15,2) DEFAULT 0,
  installment_term INT,
  payment_method NVARCHAR(255),
  admin_note NVARCHAR(MAX),
  refund_previous_status NVARCHAR(255),
  refund_reason NVARCHAR(MAX),
  stock_deducted BIT,
  stock_restored BIT,
  created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- ----------------------------
-- Table structure for order_items
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'order_items') AND type IN ('U'))
	DROP TABLE order_items;
GO
CREATE TABLE order_items (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  price DECIMAL(18,2),
  quantity INT
);
GO

-- ----------------------------
-- Table structure for cart_items
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'cart_items') AND type IN ('U'))
	DROP TABLE cart_items;
GO
CREATE TABLE cart_items (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  cart_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT DEFAULT 1
);
GO

-- ----------------------------
-- Table structure for reviews
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'reviews') AND type IN ('U'))
	DROP TABLE reviews;
GO
CREATE TABLE reviews (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  content NVARCHAR(255),
  created_at DATETIME2,
  stars INT,
  user_id INT,
  product_id INT,
  order_id INT,
  title NVARCHAR(255),
  image NVARCHAR(255),
  video NVARCHAR(255)
);
GO

-- ----------------------------
-- Table structure for wishlist_items
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'wishlist_items') AND type IN ('U'))
	DROP TABLE wishlist_items;
GO
CREATE TABLE wishlist_items (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  created_at DATETIME2 NOT NULL,
  product_id INT NOT NULL,
  user_id INT NOT NULL
);
GO

-- ----------------------------
-- Table structure for inventory
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'inventory') AND type IN ('U'))
	DROP TABLE inventory;
GO
CREATE TABLE inventory (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  product_id INT,
  quantity INT DEFAULT 0,
  last_update DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- ----------------------------
-- Table structure for stock_movements
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'stock_movements') AND type IN ('U'))
	DROP TABLE stock_movements;
GO
CREATE TABLE stock_movements (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  product_id INT,
  change_quantity INT,
  movement_type NVARCHAR(255),
  note NVARCHAR(MAX),
  created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
);
GO

-- ----------------------------
-- Table structure for flash_sale_items
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'flash_sale_items') AND type IN ('U'))
	DROP TABLE flash_sale_items;
GO
CREATE TABLE flash_sale_items (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  sale_price DECIMAL(18,2),
  sale_quantity INT,
  sold_count INT,
  flash_sale_id INT,
  product_id INT
);
GO

-- ----------------------------
-- Table structure for brands
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'brands') AND type IN ('U'))
	DROP TABLE brands;
GO
CREATE TABLE brands (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  name NVARCHAR(255) NOT NULL,
  logo NVARCHAR(500) NOT NULL,
  link NVARCHAR(500),
  display_order INT DEFAULT 0
);
GO

-- ----------------------------
-- Table structure for pc_combo_details
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'pc_combo_details') AND type IN ('U'))
	DROP TABLE pc_combo_details;
GO
CREATE TABLE pc_combo_details (
  id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  slot_type NVARCHAR(255),
  combo_id BIGINT,
  product_id INT
);
GO

-- ----------------------------
-- Table structure for pc_build_items
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'pc_build_items') AND type IN ('U'))
	DROP TABLE pc_build_items;
GO
CREATE TABLE pc_build_items (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  build_id INT NOT NULL,
  product_id INT NOT NULL
);
GO

-- ----------------------------
-- Table structure for ticket_messages
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'ticket_messages') AND type IN ('U'))
	DROP TABLE ticket_messages;
GO
CREATE TABLE ticket_messages (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  created_at DATETIME2,
  message NVARCHAR(MAX)  NOT NULL,
  sender NVARCHAR(255)  NOT NULL,
  sender_name NVARCHAR(255),
  ticket_id INT NOT NULL
);
GO

-- ----------------------------
-- Table structure for user_vouchers
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'user_vouchers') AND type IN ('U'))
	DROP TABLE user_vouchers;
GO
CREATE TABLE user_vouchers (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  user_id INT NOT NULL,
  voucher_id INT NOT NULL,
  saved_at DATETIME2,
  used_at DATETIME2,
  reservation_expires_at DATETIME2,
  status NVARCHAR(255) NOT NULL
);
GO

-- ----------------------------
-- Table structure for chat_messages
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'chat_messages') AND type IN ('U'))
	DROP TABLE chat_messages;
GO
CREATE TABLE chat_messages (
  id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  created_at DATETIME2,
  message NVARCHAR(MAX),
  sender NVARCHAR(255),
  sender_name NVARCHAR(255),
  ticket_id INT
);
GO

-- ----------------------------
-- Table structure for password_resets
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'password_resets') AND type IN ('U'))
	DROP TABLE password_resets;
GO
CREATE TABLE password_resets (
  id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  email NVARCHAR(100),
  token NVARCHAR(255),
  expiry DATETIME2
);
GO

-- ----------------------------
-- Table structure for case_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'case_specs') AND type IN ('U'))
	DROP TABLE case_specs;
GO
CREATE TABLE case_specs (
  product_id INT NOT NULL PRIMARY KEY,
  max_cpu_cooler_height_mm INT,
  max_gpu_length_mm INT,
  motherboard_support NVARCHAR(255)
);
GO

-- ----------------------------
-- Table structure for casespec_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'casespec_specs') AND type IN ('U'))
	DROP TABLE casespec_specs;
GO
CREATE TABLE casespec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  max_cpu_cooler_height_mm INT,
  max_gpu_length_mm INT,
  motherboard_support NVARCHAR(255)
);
GO

-- ----------------------------
-- Table structure for cpu_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'cpu_specs') AND type IN ('U'))
	DROP TABLE cpu_specs;
GO
CREATE TABLE cpu_specs (
  product_id INT NOT NULL PRIMARY KEY,
  has_igpu BIT,
  includes_stock_cooler BIT,
  ram_type_supported NVARCHAR(255),
  socket NVARCHAR(255),
  tdp_max INT
);
GO

-- ----------------------------
-- Table structure for cpuspec_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'cpuspec_specs') AND type IN ('U'))
	DROP TABLE cpuspec_specs;
GO
CREATE TABLE cpuspec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  has_igpu BIT,
  includes_stock_cooler BIT,
  ram_type_supported NVARCHAR(255),
  socket NVARCHAR(255),
  tdp_max INT
);
GO

-- ----------------------------
-- Table structure for cooler_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'cooler_specs') AND type IN ('U'))
	DROP TABLE cooler_specs;
GO
CREATE TABLE cooler_specs (
  product_id INT NOT NULL PRIMARY KEY,
  cooler_type NVARCHAR(255),
  height_mm INT,
  tdp_rating_watt INT
);
GO

-- ----------------------------
-- Table structure for coolerspec_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'coolerspec_specs') AND type IN ('U'))
	DROP TABLE coolerspec_specs;
GO
CREATE TABLE coolerspec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  cooler_type NVARCHAR(255),
  height_mm INT,
  tdp_rating_watt INT
);
GO

-- ----------------------------
-- Table structure for gpu_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'gpu_specs') AND type IN ('U'))
	DROP TABLE gpu_specs;
GO
CREATE TABLE gpu_specs (
  product_id INT NOT NULL PRIMARY KEY,
  length_mm INT,
  pcie12vhpwr_required INT,
  pcie8pin_required INT,
  power_consumption_tdp INT,
  thickness_mm INT
);
GO

-- ----------------------------
-- Table structure for gpuspec_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'gpuspec_specs') AND type IN ('U'))
	DROP TABLE gpuspec_specs;
GO
CREATE TABLE gpuspec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  length_mm INT,
  pcie12vhpwr_required INT,
  pcie8pin_required INT,
  power_consumption_tdp INT,
  thickness_mm INT
);
GO

-- ----------------------------
-- Table structure for mainboard_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'mainboard_specs') AND type IN ('U'))
	DROP TABLE mainboard_specs;
GO
CREATE TABLE mainboard_specs (
  product_id INT NOT NULL PRIMARY KEY,
  cpu_power_connectors INT,
  form_factor NVARCHAR(255),
  ram_slots INT,
  ram_type NVARCHAR(255),
  socket NVARCHAR(255)
);
GO

-- ----------------------------
-- Table structure for mainboardspec_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'mainboardspec_specs') AND type IN ('U'))
	DROP TABLE mainboardspec_specs;
GO
CREATE TABLE mainboardspec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  cpu_power_connectors INT,
  form_factor NVARCHAR(255),
  ram_slots INT,
  ram_type NVARCHAR(255),
  socket NVARCHAR(255)
);
GO

-- ----------------------------
-- Table structure for psu_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'psu_specs') AND type IN ('U'))
	DROP TABLE psu_specs;
GO
CREATE TABLE psu_specs (
  product_id INT NOT NULL PRIMARY KEY,
  cpu8pin_connectors INT,
  length_mm INT,
  pcie8pin_connectors INT,
  wattage INT
);
GO

-- ----------------------------
-- Table structure for psuspec_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'psuspec_specs') AND type IN ('U'))
	DROP TABLE psuspec_specs;
GO
CREATE TABLE psuspec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  cpu8pin_connectors INT,
  length_mm INT,
  pcie8pin_connectors INT,
  wattage INT
);
GO

-- ----------------------------
-- Table structure for ram_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'ram_specs') AND type IN ('U'))
	DROP TABLE ram_specs;
GO
CREATE TABLE ram_specs (
  product_id INT NOT NULL PRIMARY KEY,
  capacity_total INT,
  ddr_type NVARCHAR(255),
  module_count INT
);
GO

-- ----------------------------
-- Table structure for ramspec_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'ramspec_specs') AND type IN ('U'))
	DROP TABLE ramspec_specs;
GO
CREATE TABLE ramspec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  capacity_total INT,
  ddr_type NVARCHAR(255),
  module_count INT
);
GO

-- ----------------------------
-- Table structure for storage_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'storage_specs') AND type IN ('U'))
	DROP TABLE storage_specs;
GO
CREATE TABLE storage_specs (
  product_id INT NOT NULL PRIMARY KEY,
  form_factor NVARCHAR(255),
  interface_type NVARCHAR(255)
);
GO

-- ----------------------------
-- Table structure for storagespec_specs
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'storagespec_specs') AND type IN ('U'))
	DROP TABLE storagespec_specs;
GO
CREATE TABLE storagespec_specs (
  product_id INT NOT NULL PRIMARY KEY,
  form_factor NVARCHAR(255),
  interface_type NVARCHAR(255)
);
GO


-- ----------------------------
-- RELATIONSHIPS & FOREIGN KEYS
-- ----------------------------

ALTER TABLE flash_sale_items ADD CONSTRAINT FK_flash_sale_items_flash_sales FOREIGN KEY (flash_sale_id) REFERENCES flash_sales (id);
GO

ALTER TABLE flash_sale_items ADD CONSTRAINT FK_flash_sale_items_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE inventory ADD CONSTRAINT FK_inventory_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE news ADD CONSTRAINT FK_news_users FOREIGN KEY (author_id) REFERENCES users (id);
GO

ALTER TABLE news ADD CONSTRAINT FK_news_news_categories FOREIGN KEY (category_id) REFERENCES news_categories (id);
GO

ALTER TABLE order_items ADD CONSTRAINT FK_order_items_orders FOREIGN KEY (order_id) REFERENCES orders (id);
GO

ALTER TABLE order_items ADD CONSTRAINT FK_order_items_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE orders ADD CONSTRAINT FK_orders_users FOREIGN KEY (user_id) REFERENCES users (id);
GO

ALTER TABLE pc_combo_details ADD CONSTRAINT FK_pc_combo_details_pc_combos FOREIGN KEY (combo_id) REFERENCES pc_combos (id);
GO

ALTER TABLE pc_combo_details ADD CONSTRAINT FK_pc_combo_details_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE products ADD CONSTRAINT FK_products_categories FOREIGN KEY (category_id) REFERENCES categories (id);
GO

ALTER TABLE reviews ADD CONSTRAINT FK_reviews_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE reviews ADD CONSTRAINT FK_reviews_users FOREIGN KEY (user_id) REFERENCES users (id);
GO

ALTER TABLE shipping_addresses ADD CONSTRAINT FK_shipping_addresses_users FOREIGN KEY (user_id) REFERENCES users (id);
GO

ALTER TABLE stock_movements ADD CONSTRAINT FK_stock_movements_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE support_tickets ADD CONSTRAINT FK_support_tickets_users FOREIGN KEY (user_id) REFERENCES users (id);
GO

ALTER TABLE ticket_messages ADD CONSTRAINT FK_ticket_messages_tickets FOREIGN KEY (ticket_id) REFERENCES tickets (id);
GO

ALTER TABLE user_roles ADD CONSTRAINT FK_user_roles_roles FOREIGN KEY (role_id) REFERENCES roles (id);
GO

ALTER TABLE user_roles ADD CONSTRAINT FK_user_roles_users FOREIGN KEY (user_id) REFERENCES users (id);
GO

ALTER TABLE user_sessions ADD CONSTRAINT FK_user_sessions_users FOREIGN KEY (user_id) REFERENCES users (id);
GO

ALTER TABLE user_vouchers ADD CONSTRAINT FK_user_vouchers_users FOREIGN KEY (user_id) REFERENCES users (id);
GO

ALTER TABLE user_vouchers ADD CONSTRAINT FK_user_vouchers_vouchers FOREIGN KEY (voucher_id) REFERENCES vouchers (id);
GO

ALTER TABLE vouchers ADD CONSTRAINT FK_vouchers_categories FOREIGN KEY (category_id) REFERENCES categories (id);
GO

ALTER TABLE wishlist_items ADD CONSTRAINT FK_wishlist_items_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE wishlist_items ADD CONSTRAINT FK_wishlist_items_users FOREIGN KEY (user_id) REFERENCES users (id);
GO

ALTER TABLE case_specs ADD CONSTRAINT FK_case_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE casespec_specs ADD CONSTRAINT FK_casespec_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE cpu_specs ADD CONSTRAINT FK_cpu_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE cpuspec_specs ADD CONSTRAINT FK_cpuspec_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE cooler_specs ADD CONSTRAINT FK_cooler_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE coolerspec_specs ADD CONSTRAINT FK_coolerspec_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE gpu_specs ADD CONSTRAINT FK_gpu_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE gpuspec_specs ADD CONSTRAINT FK_gpuspec_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE mainboard_specs ADD CONSTRAINT FK_mainboard_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE mainboardspec_specs ADD CONSTRAINT FK_mainboardspec_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE psu_specs ADD CONSTRAINT FK_psu_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE psuspec_specs ADD CONSTRAINT FK_psuspec_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE ram_specs ADD CONSTRAINT FK_ram_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE ramspec_specs ADD CONSTRAINT FK_ramspec_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE storage_specs ADD CONSTRAINT FK_storage_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO

ALTER TABLE storagespec_specs ADD CONSTRAINT FK_storagespec_specs_products FOREIGN KEY (product_id) REFERENCES products (id);
GO


-- ======================================================
-- SQL Server Seed Data (INSERT INTO)
-- Ordered Topologically
-- Date: 2026-07-19
-- --------------------------------------------------
-- CLEAN EXISTING DATA BEFORE INSERTING TO AVOID PK VIOLATION
-- --------------------------------------------------
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO
EXEC sp_MSforeachtable 'DELETE FROM ?';
GO
EXEC sp_MSforeachtable 'IF OBJECTPROPERTY(OBJECT_ID(''?''), ''TableHasIdentity'') = 1 DBCC CHECKIDENT (''?'', RESEED, 0)';
GO
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
GO

-- --------------------------------------------------
-- CLEAN EXISTING DATA BEFORE INSERTING TO AVOID PK VIOLATION
-- --------------------------------------------------
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO
EXEC sp_MSforeachtable 'DELETE FROM ?';
GO
EXEC sp_MSforeachtable 'IF OBJECTPROPERTY(OBJECT_ID(''?''), ''TableHasIdentity'') = 1 DBCC CHECKIDENT (''?'', RESEED, 0)';
GO
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
GO

-- --------------------------------------------------
-- CLEAN EXISTING DATA BEFORE INSERTING TO AVOID PK VIOLATION
-- --------------------------------------------------
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO
EXEC sp_MSforeachtable 'DELETE FROM ?';
GO
EXEC sp_MSforeachtable 'IF OBJECTPROPERTY(OBJECT_ID(''?''), ''TableHasIdentity'') = 1 DBCC CHECKIDENT (''?'', RESEED, 0)';
GO
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
GO

-- ======================================================

-- Dumping data for table flyway_schema_history
INSERT INTO flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) VALUES (1, '0', '<< Flyway Baseline >>', 'BASELINE', '<< Flyway Baseline >>', NULL, 'postgres', '2026-07-16 06:53:57.288009', 0, 1);
INSERT INTO flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) VALUES (2, '1', 'remove obsolete news published', 'SQL', 'V1__remove_obsolete_news_published.sql', -1979696205, 'postgres', '2026-07-16 06:53:59.541866', 880, 1);
GO


-- Dumping data for table sepay_transactions
SET IDENTITY_INSERT sepay_transactions ON;
INSERT INTO sepay_transactions (id, account_number, order_code, payment_code, processed_at, processing_status, raw_payload, received_at, sepay_transaction_id, transfer_amount, transfer_type) VALUES (1, '104887314781', 'DH44', 'DH44', '2026-07-14 15:10:59.510244', 'PAID', '{"gateway":"VietinBank","transactionDate":"2026-07-14 22:10:56","accountNumber":"104887314781","subAccount":null,"code":null,"content":"ZP7D3OQQSLSG SEVQR DH44","transferType":"in","description":"BankAPINotify ZP7D3OQQSLSG SEVQR DH44","transferAmount":10000,"referenceCode":"1CFPa-8Ab3YRI1i","accumulated":40000,id:68246082}', '2026-07-14 15:10:59.028077', 68246082, 10000, 'in');
INSERT INTO sepay_transactions (id, account_number, order_code, payment_code, processed_at, processing_status, raw_payload, received_at, sepay_transaction_id, transfer_amount, transfer_type) VALUES (2, '104887314781', 'DH45', 'DH45', '2026-07-14 15:15:21.42561', 'PAID', '{"gateway":"VietinBank","transactionDate":"2026-07-14 22:15:19","accountNumber":"104887314781","subAccount":null,"code":null,"content":"CT DEN:948T2670NEMHZAZR SEVQR DH45","transferType":"in","description":"BankAPINotify CT DEN:948T2670NEMHZAZR SEVQR DH45","transferAmount":10000,"referenceCode":"948T2670NEMHZAZR","accumulated":10000,id:68246628}', '2026-07-14 15:15:21.138344', 68246628, 10000, 'in');
SET IDENTITY_INSERT sepay_transactions OFF;
GO

-- Dumping data for table roles
SET IDENTITY_INSERT roles ON;
INSERT INTO roles (id, name) VALUES (1, 'ADMIN');
INSERT INTO roles (id, name) VALUES (2, 'USER');
INSERT INTO roles (id, name) VALUES (3, 'STAFF');
SET IDENTITY_INSERT roles OFF;
GO

SELECT * FROM users;
GO

DELETE FROM users;
GO

-- Dumping data for table users
SET IDENTITY_INSERT users ON;
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (1, 'phamcongthanh.8311@gmail.com', 'phamcongthanh.8311@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', N'Phạm Thanh', '0902208461', NULL, 1, 'GOOGLE', '112307932430374029161', NULL, '/uploads/avatars/user_41_1783933303213.webp', NULL, NULL, 0, 1, 0, 1, 1, 0, '2026-07-13 16:00:58.778');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (2, 'leecookcu@gmail.com', 'leecookcu@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bá Bá', '0936629311', NULL, 1, 'LOCAL', NULL, NULL, '/uploads/avatars/user_29_1783932198527.jpg', '2006-12-12 00:00:00', 1, 1, 1, 1, 0, 1, 0, '2026-06-12 18:47:49.406');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, google_id, facebook_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (3, 'ditmemaygogle113', 'ditmemaygogle113@gmail.com', '$2a$10$ceBXGEZmWVqVhpH48b2TZuuMNgdGPxYTq4ydS.7erOj7cpOHhaB2y', N'Yến Trần', NULL, NULL, 1, 'LOCAL', '102325764378749092956', NULL, NULL, NULL, NULL, 0, 1, 1, 1, 1, 0, '2026-07-14 11:06:11.866');
SET IDENTITY_INSERT users OFF;
GO

-- Dumping data for table categories
SET IDENTITY_INSERT categories ON;
INSERT INTO categories (id, name, display, slug) VALUES (1, 'CPU', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (2, 'GPU', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (3, 'RAM', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (4, 'ROM', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (5, 'Mainboard', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (6, 'SSD', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (7, N'Màn hình', NULL, NULL);
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

SET IDENTITY_INSERT categories OFF;
GO
DELETE FROM categories;
GO
DELETE FROM user_vouchers;
GO
DELETE FROM vouchers;
GO
DELETE FROM cart_items;
DELETE FROM wishlist_items;

DELETE FROM case_specs;
DELETE FROM casespec_specs;

DELETE FROM cpu_specs;
DELETE FROM cpuspec_specs;

DELETE FROM cooler_specs;
DELETE FROM coolerspec_specs;

DELETE FROM gpu_specs;
DELETE FROM gpuspec_specs;

DELETE FROM mainboard_specs;
DELETE FROM mainboardspec_specs;

DELETE FROM psu_specs;
DELETE FROM psuspec_specs;

DELETE FROM ram_specs;
DELETE FROM ramspec_specs;

DELETE FROM storage_specs;
DELETE FROM storagespec_specs;

DELETE FROM products;
DELETE FROM reviews;
GO
DELETE FROM categories;
-- Dumping data for table news_categories
SET IDENTITY_INSERT news_categories ON;
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (1, '2026-07-13 21:32:29.98', N'mô tả nội dung', N'Tin Tức', 'tin-tuc', 'ACTIVE', '2026-07-13 21:32:29.98');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (2, '2026-07-16 11:23:00.477', N'Các bài viết hướng dẫn chọn linh kiện, cách lắp ráp PC từ A-Z.', N'Hướng dẫn Build PC', 'huong-dan-build-pc', 'ACTIVE', '2026-07-16 11:23:00.477');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (3, '2026-07-16 11:23:20.094', N'Các bài viết so sánh (VD: "Intel Core i5-14600K vs AMD Ryzen 7 7700X"), gợi ý cấu hình theo ngân sách.', N'Tư vấn chọn mua', 'tu-van-chon-mua', 'ACTIVE', '2026-07-16 11:23:20.094');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (4, '2026-07-16 11:23:41.515', N'Cách tối ưu hóa Windows, cách ép xung (overclock), cách vệ sinh máy tính tại nhà.', N'Mẹo & Thủ thuật', 'meo-thu-thuat', 'ACTIVE', '2026-07-16 11:23:41.515');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (5, '2026-07-16 11:23:53.733', N'Giải thích các thuật ngữ (VD: "SSD NVMe là gì?", "Tại sao cần nguồn chuẩn 80 Plus?").', N'Giải đáp kỹ thuật', 'giai-dap-ky-thuat', 'ACTIVE', '2026-07-16 11:23:53.733');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (6, '2026-07-16 11:24:15.128', N'Cập nhật các dòng chip mới, card đồ họa mới ra mắt (NVIDIA/AMD/Intel).', N'Tin công nghệ', 'tin-cong-nghe', 'ACTIVE', '2026-07-16 11:24:15.128');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (7, '2026-07-16 11:24:34.085', N'Đánh giá chi tiết các linh kiện hot, trải nghiệm thực tế hiệu năng máy.', N'Review Sản phẩm', 'review-san-pham', 'ACTIVE', '2026-07-16 11:24:34.085');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (8, '2026-07-16 11:24:45.17', N'Các chương trình khuyến mãi, sự kiện công nghệ hoặc tin tức thị trường phần cứng.', N'Tin tức sự kiện', 'tin-tuc-su-kien', 'ACTIVE', '2026-07-16 11:24:45.17');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (9, '2026-07-16 11:25:14.149', N'Chia sẻ hình ảnh, ý tưởng trang trí góc máy (RGB, decor phòng).', N'Setup PC đẹp', 'setup-pc-dep', 'ACTIVE', '2026-07-16 11:25:14.149');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (10, '2026-07-16 11:25:30.497', N'Gợi ý cấu hình tối ưu cho các tựa game hot (VD: "Cấu hình chơi mượt Valorant/GTA V/Cyberpunk 2077").', N'Cấu hình chơi game', 'cau-hinh-choi-game', 'ACTIVE', '2026-07-16 11:25:30.497');
INSERT INTO news_categories (id, created_at, description, name, slug, status, updated_at) VALUES (11, '2026-07-16 11:25:44.293', N'Giới thiệu các tựa game mới hoặc các công cụ hỗ trợ công việc/giải trí.', N'Review Game & Phần mềm', 'review-game-phan-mem', 'ACTIVE', '2026-07-16 11:25:44.293');
SET IDENTITY_INSERT news_categories OFF;
GO

-- Dumping data for table flash_sales
SET IDENTITY_INSERT flash_sales ON;
INSERT INTO flash_sales (id, active, created_at, end_time, name, start_time) VALUES (1, 0, '2026-06-22 08:58:57.04', '2026-07-08 12:00:00', 'SALE7/7', '2026-07-07 12:00:00');
INSERT INTO flash_sales (id, active, created_at, end_time, name, start_time) VALUES (2, 1, '2026-06-22 08:58:57.075', '2026-08-08 12:00:00', 'SALE8/7', '2026-07-07 12:00:00');
SET IDENTITY_INSERT flash_sales OFF;
GO

-- Dumping data for table pc_combos
SET IDENTITY_INSERT pc_combos ON;
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES (1, 'HOT', '#ef4444', NULL, '/images/combo1.jpg', 'Combo 1: LXR Core Ultra 7 / RTX 5070Ti', 67000000);
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES (2, 'PREMIUM', '#eab308', NULL, '/images/combo2.jpg', 'Combo 2: LXR Core Ultra 7 / RTX 5080', 67000000);
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES (3, 'SALE', '#22c55e', NULL, '/images/combo3.jpg', 'Combo 3: LXR Intel i5-12400F / RTX 5060', 47000000);
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES (4, 'VALUE', '#3b82f6', NULL, '/images/combo4.jpg', 'Combo 4: LXR Intel i5-12400F / RTX 5060 Ti', 22000000);
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES (5, 'PERFORMANCE', '#f97316', NULL, '/images/combo5.jpg', 'Combo 5: LXR Intel i7-14700F / RTX 5060', 25000000);
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES (6, 'ULTIMATE', 'var(--gold)', NULL, '/images/combo2.jpg', 'Combo 6: LXR AMD Ryzen 9 / RTX 5090', 120000000);
INSERT INTO pc_combos (id, badge, badge_color, description, image, name, price) VALUES (7, 'CREATOR', '#a855f7', NULL, '/images/combo1.jpg', 'Combo 7: LXR Studio / RTX 5080', 85000000);
SET IDENTITY_INSERT pc_combos OFF;
GO

-- Dumping data for table spring_session
INSERT INTO spring_session (primary_id, session_id, creation_time, last_access_time, max_inactive_interval, expiry_time, principal_name) VALUES ('82866743-8dff-44a6-a51b-9762bc0f05ca', '0536cba6-45f0-44e5-a014-d22ba9545c5f', 1782004704449, 1782011856560, 1800, 1782013656560, 'tuan9bledinhchinh@gmail.com');
GO

-- Dumping data for table user_roles
SET IDENTITY_INSERT user_roles ON;
INSERT INTO user_roles (user_id, role_id, id) VALUES (1, 2, 1);
INSERT INTO user_roles (user_id, role_id, id) VALUES (2, 1, 2);
INSERT INTO user_roles (user_id, role_id, id) VALUES (3, 2, 3);
SET IDENTITY_INSERT user_roles OFF;
GO

-- Dumping data for table user_sessions
SET IDENTITY_INSERT user_sessions ON;
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (3, 2, 'b4ca1a60-87bd-4024-9a65-66d06090519c', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', N'Chrome trên Windows', '0:0:0:0:0:0:0:1', N'TP.HCM, Việt Nam', '2026-06-20 18:48:14.865', '2026-06-20 18:48:14.865', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (1, 5, '4201e3e4-129c-4f35-b5d1-825db34cda4c', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', N'Chrome trên Windows', '0:0:0:0:0:0:0:1', N'TP.HCM, Việt Nam', '2026-06-20 18:35:07.105', '2026-06-20 18:35:07.105', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (2, 5, '2bb5f7b3-222b-4351-a18f-76778818323d', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', N'Chrome trên Windows', '0:0:0:0:0:0:0:1', N'TP.HCM, Việt Nam', '2026-06-20 18:37:32.378', '2026-06-20 18:37:32.378', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (7, 2, '763abca3-a9fd-4366-81a5-1fbe99b7df89', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', N'Chrome trên Windows', '0:0:0:0:0:0:0:1', N'TP.HCM, Việt Nam', '2026-06-20 21:04:44.264', '2026-06-20 21:04:44.264', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (8, 2, '0536cba6-45f0-44e5-a014-d22ba9545c5f', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', N'Chrome trên Windows', '0:0:0:0:0:0:0:1', N'TP.HCM, Việt Nam', '2026-06-21 08:20:34.015', '2026-06-21 08:20:34.015', 0);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (6, 5, '8ee09a1a-fce0-41fb-b41e-f443d371f6d4', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', N'Chrome trên Windows', '0:0:0:0:0:0:0:1', N'TP.HCM, Việt Nam', '2026-06-20 19:36:43.203', '2026-06-20 19:36:43.203', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (5, 5, 'b4adc9ce-d1cc-486e-80ce-cbfe8a8af1c0', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', N'Chrome trên Windows', '0:0:0:0:0:0:0:1', N'TP.HCM, Việt Nam', '2026-06-20 18:56:32.364', '2026-06-20 18:56:32.364', 1);
INSERT INTO user_sessions (id, user_id, session_id, user_agent, device_info, ip_address, location, login_time, last_activity, is_expired) VALUES (4, 5, 'c17a7c72-5c75-4728-8eba-0ccfe8c2db0b', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', N'Chrome trên Windows', '0:0:0:0:0:0:0:1', N'TP.HCM, Việt Nam', '2026-06-20 18:51:23.4', '2026-06-20 18:51:23.4', 1);
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
SET IDENTITY_INSERT user_sessions OFF;
GO

-- Dumping data for table shipping_addresses
SET IDENTITY_INSERT shipping_addresses ON;
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (2, 'd', N'Thành phố Hồ Chí Minh', 0, 'v', '0869949147', 'v', 2);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (1, 'v', N'Thành phố Hồ Chí Minh', 1, '1', '0905338411', 'v', 2);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (5, 'Q12', N'02 - Thành phố Hồ Chí Minh', 0, 'Q12', '0902208461', 'Khang', 5);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (4, 'Q12', N'02 - Thành phố Hồ Chí Minh', 0, 'Q12', '0902208461', N'Khang Bá', 5);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (6, 'trang nha, nha trang', 'TP.NhaTrang', 0, N'quận trang nha', '0936629311', 'Khang Khang', 5);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (3, 'Q122', N'02 - Thành phố Hồ Chí Minh', 0, 'Q12', '0902208461', N'Bá Khang', 5);
INSERT INTO shipping_addresses (id, address, city, is_default, district, phone, recipient_name, user_id) VALUES (7, 'KonTum', 'KonTum', 1, 'TumKon', '0901560861', N'Bá Bá', 5);
SET IDENTITY_INSERT shipping_addresses OFF;
GO

-- Dumping data for table support_tickets
SET IDENTITY_INSERT support_tickets ON;
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (1, NULL, 'leecookcu@gmail.com', NULL, 'GENERAL', '2026-06-21 01:18:04.043', 'phamcongthanh.8311@gmail.com', 'thanh', '', N'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CLOSED', N'Chat hỗ trợ trực tuyến', '2026-06-21 13:10:11.781', 5);
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (2, NULL, 'leecookcu@gmail.com', NULL, 'GENERAL', '2026-06-23 16:34:27.632', 'phamcongthanh.8311@gmail.com', 'thanh', '', N'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'IN_PROGRESS', N'Chat hỗ trợ trực tuyến', '2026-06-23 17:09:43.807', 5);
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (3, NULL, 'tuan9bledinhchinh@gmail.com', NULL, 'GENERAL', '2026-07-14 09:45:54.78', 'tuan9bledinhchinh@gmail.com', '36', '', N'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'IN_PROGRESS', N'Chat hỗ trợ trực tuyến', '2026-07-14 09:45:59.943', 2);
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (4, NULL, 'leecookcu@gmail.com', NULL, 'GENERAL', '2026-07-14 13:29:48.231', 'phamcongthanh.8311@gmail.com', 'Thanh', '', N'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'IN_PROGRESS', N'Chat hỗ trợ trực tuyến', '2026-07-14 13:30:11.568', 5);
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (5, NULL, NULL, NULL, 'GENERAL', '2026-07-14 17:19:18.965', 'tuan9bledinhchinh@gmail.com', '36', '', N'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'OPEN', N'Chat hỗ trợ trực tuyến', '2026-07-14 17:19:18.965', 2);
INSERT INTO support_tickets (id, admin_reply, assigned_admin, build_config, category, created_at, customer_email, customer_name, customer_phone, message, status, subject, updated_at, user_id) VALUES (6, NULL, NULL, NULL, 'GENERAL', '2026-07-15 10:47:51.665', 'phamcongthanh.8311@gmail.com', 'Thanh', '', N'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'OPEN', N'Chat hỗ trợ trực tuyến', '2026-07-15 10:47:51.665', 5);
SET IDENTITY_INSERT support_tickets OFF;
GO
DELETE FROM products;
DELETE FROM inventory;
DELETE FROM order_items;
DELETE FROM pc_combo_details;
DELETE FROM stock_movements;
DELETE FROM flash_sale_items;
DELETE FROM wishlist_items;
DELETE FROM cart_items;

-- Dumping data for table products
SET IDENTITY_INSERT products ON;
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (257, N'Intel Core i5 12400F / 2.5GHz Turbo 4.4GHz (TRAY) - CHÍNH HÃNG', 2500000, 'TDP: 65W', 'i9_14900k.jpg', 1, 99, '2026-06-27 12:52:50.064', NULL);
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
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (16, N'Vỏ máy tính Xigmatek QUANTUM 4AF', 800000, 'TDP: 0W', 'corsair_3500x_black.png', 12, 100, '2026-06-27 12:22:45.418', NULL);
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
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (269, N'Ổ Cứng SSD KingSpec NVMe 512GB (NE-512)', 800000, 'TDP: 10W', 'sabrent_rocket_4tb.jpg', 7, 100, '2026-06-27 12:52:55.693', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (265, 'GIGABYTE GeForce RTX 5080 WINDFORCE OC SFF 16G', 35000000, 'TDP: 300W', 'asus_rog_rtx_4090.jpg', 9, 98, '2026-06-27 12:52:53.742', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (268, N'Ổ cứng SSD Kingston NV3 1TB M.2 PCIe NVMe Gen4', 1800000, 'TDP: 10W', 'sabrent_rocket_4tb.jpg', 7, 97, '2026-06-27 12:52:55.209', NULL);
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
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (272, N'Nguồn FSP HV PRO 650W - 80 Plus Bronze', 1400000, 'TDP: 0W', 'corsair_rm850e.jpg', 11, 100, '2026-06-27 12:52:57.17', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (273, 'Corsair CX650 - 80 Plus Bronze (650W)', 1600000, 'TDP: 0W', 'corsair_rm850e.jpg', 11, 100, '2026-06-27 12:52:57.668', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (274, 'Corsair 3500X TG Mid Tower Black', 2000000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 99, '2026-06-27 12:52:58.157', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (275, 'Corsair FRAME 4500X RS-R ARGB Panoramic Black', 3500000, 'TDP: 0W', 'galax_hof_32gb.jpg', 12, 98, '2026-06-27 12:52:58.657', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (276, N'Tản nhiệt AIO Corsair NAUTILUS 360 ARGB Black', 2800000, 'TDP: 15W', 'corsair_rm850e.jpg', 8, 97, '2026-06-27 12:52:59.35', NULL);
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
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (181, 'Intel Arc A770 Limited Edition GPU', 8356600, '16GB GDDR6, 256-bit, 2100 MHz, 225W', 'i9_14900k.jpg', 2, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (183, 'Intel Arc A580 Graphics Card', 4546600, '8GB GDDR6, 256-bit, 1700 MHz, 185W', 'asus_rog_rtx_4090.jpg', 2, 50, '2026-06-05 10:05:55.522526', NULL);
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
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (194, 'MSI MAG B650 TOMAHAWK WIFI', 5562600, 'AM5, AMD B650, DDR5 7600+(OC), Realtek 2.5Gbps LAN', 'z790_dark_kingpin.jpg', 4, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (197, 'MSI MEG MAESTRO 700L PZ', 10642600, 'ATX Full Tower, Curved Tempered Glass, Back-connect (Project Zero) support', 'corsair_3500x_black.png', 12, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (201, 'Gigabyte X670E AORUS MASTER', 11404600, 'AM5, AMD X670E, 4x M.2 PCIe 5.0, Intel 2.5GbE LAN', 'z790_dark_kingpin.jpg', 4, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (204, 'Gigabyte AORUS Gen5 12000 SSD 2TB', 8102600, 'PCIe 5.0 x4, NVMe 2.0, 12,400 MB/s, 11,800 MB/s', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (208, 'Corsair Vengeance RGB DDR5 64GB (2x32GB)5600MHz', 5562600, '64GB, 5600 MT/s, CL40', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (211, 'Corsair iCUE LINK 6500X RGB Mid-Tower DualChamber', 5054600, 'Dual Chamber Layout, Reverse-connector support, Front & Side Tempered Glass', 'corsair_rm850e.jpg', 12, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (214, 'Corsair K100 RGB Mechanical Gaming Keyboard', 6324600, 'Corsair OPX Optical-Mechanical, AXON 4000Hz Hyper-polling, iCUE Control Wheel', 'corsair_rm850e.jpg', 15, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (218, 'Logitech G502 X LIGHTSPEED Wireless GamingMouse', 3530600, 'HERO 25K Sensor, 13 programmable controls, Dual-mode infinite scroll', 'corsair_3500x_black.png', 16, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (222, 'Logitech MX Master 3S Wireless Mouse', 2514600, '8K DPI tracking on any surface, Quiet clicks technology, MagSpeed Electromagnetic scrolling', 'corsair_3500x_black.png', 16, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (226, 'Razer Huntsman V3 Pro TKL Mechanical Keyboard', 5562600, 'Razer Analog Optical Switches Gen-2, Rapid Trigger mode with adjustable actuation (0.1- 4.0mm), Dual-purpose digital dial', 'corsair_3500x_black.png', 15, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (231, 'Samsung T7 Shield Portable SSD 2TB', 4292600, '2TB, USB 3.2 Gen 2 (10Gbps), IP65 water & dust resistant, 3-meter drop proof', 'sabrent_rocket_4tb.jpg', 5, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (234, 'Samsung Galaxy Buds3 Pro', 6324600, 'Hi-Fi 24-bit Ultra High Quality Audio, Adaptive Noise Cancelling with Blade Lights, Stem style ergonomic fit', 'sabrent_rocket_4tb.jpg', 17, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (239, 'Kingston FURY Impact DDR5 SO-DIMM 32GB (2x16GB) 5600MHz', 3149600, 'Laptop Memory (SO-DIMM), 32GB Kit, 5600 MT/s', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (242, 'Noctua NH-D15 chromax.black Dual-Tower Cooler', 3022600, '2x NF-A15 HS-PWM fans, Full black design, Intel LGA1700/AM5 ready', 'rog_ryujin_360.jpg', 13, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (245, 'SteelSeries Arctis Nova Pro Wireless Headset', 8864600, 'Nova Pro Acoustic System, Active Noise Cancellation with Transparency Mode, Dual Battery Infinity System', 'corsair_3500x_black.png', 17, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (248, 'Crucial Pro DDR5 48GB (2x24GB) 5600MHz Kit', 3784600, '48GB Kit, 5600 MT/s, Low-profile aluminum black heatsink', 'galax_hof_32gb.jpg', 3, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (249, 'Fractal Design North Charcoal Black WoodMid-Tower', 3530600, 'Real walnut wood front panel struts, Mesh or Tempered Glass available, 2x Aspect 14 PWM fans', 'corsair_3500x_black.png', 12, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (250, 'Lian Li O11 Dynamic EVO RGB Black', 4292600, 'Dual-chamber adjustable ATX case, Two L-shaped diffuse LED RGB strips, Reversible design architecture', 'corsair_3500x_black.png', 12, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (252, 'EVGA SuperNOVA 1000 G7 Gold Modular PSU', 4800600, '1000W, 80 PLUS Gold Certified, Ultra-compact 130mm chassis size', 'asus_rog_rtx_4090.jpg', 11, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (253, 'DeepCool AK620 Digital Dual-Tower Air Cooler', 2006600, 'Real-time temperature and usage status top screen, 2x FK120 fluid dynamic bearing fans, 6x 6mm copper heatpipes', 'rog_ryujin_360.jpg', 13, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (254, 'Thermalright Peerless Assassin 120 SE AirCooler', 990600, 'Dual tower heatsink design, 2x TL-C12C 120mm PWM fans, 155mm standard height', 'rog_ryujin_360.jpg', 13, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (182, 'Intel Arc A750 Graphics Card', 6324600, '8GB GDDR6, 256-bit, 2050 MHz, 225W', 'asus_rog_rtx_4090.jpg', 2, 49, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (247, 'Sony WH-1000XM5 Wireless Noise CancelingHeadphones', 10134600, 'Integrated Processor V1 & HD Noise CancelingProcessor QN1, 8 microphones for extreme voice pick up, Up to 30 hours total life', 'corsair_3500x_black.png', 17, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (251, 'Lian Li UNI FAN TL LCD 120 Triple Pack Black', 3784600, '120mm fans, Built-in 1.6-inch LCD screen on center fan, Daisy-chain interlocking mechanism', 'rog_ryujin_360.jpg', 14, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (255, 'Be Quiet! Dark Power 13 1000W Titanium ATX 3.0PSU', 7340600, '1000W, 80 PLUS Titanium (up to 95.8%), Frameless Silent Wings fan optimization', 'corsair_rm850e.jpg', 11, 50, '2026-06-05 10:05:55.522526', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (7, 'Intel Core i9-13900KS', 18500000, 'Special Edition, 6.0GHz', 'i9_14900k.jpg', 1, 0, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (12, 'AMD Ryzen 5 5600G', 3200000, 'Integrated Vega Graphics', 'i9_14900k.jpg', 1, 71, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (23, 'Intel Core i9-11900K', 6500000, 'Legacy Flagship LGA 1200', 'i9_14900k.jpg', 1, 9, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (54, 'Quadro RTX A4000', 22000000, 'Workstation GPU', 'asus_rog_rtx_4090.jpg', 2, 0, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (89, 'Galax HOF 32GB', 5500000, '8000MHz White OC', 'galax_hof_32gb.jpg', 3, 3, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (287, N'Thẻ nhớ SanDisk Extreme Pro 128GB MicroSDXC UHS-I 200MB/s', 650000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 100, '2026-07-23 10:00:00.000', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (288, N'Thẻ nhớ Samsung PRO Plus 256GB MicroSDXC kèm Đầu đọc USB', 950000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 80, '2026-07-23 10:00:00.000', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (289, N'Thẻ nhớ Lexar Professional 1066x 512GB MicroSDXC UHS-I', 1450000, 'TDP: 3W', 'sabrent_rocket_4tb.jpg', 4, 50, '2026-07-23 10:00:00.000', 'Lexar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (290, N'Thẻ nhớ Kingston Canvas Go! Plus 128GB SDXC UHS-I', 580000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 120, '2026-07-23 10:00:00.000', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (291, N'Thẻ nhớ SanDisk Ultra SDXC 64GB 140MB/s Class 10', 280000, 'TDP: 1W', 'sabrent_rocket_4tb.jpg', 4, 150, '2026-07-23 10:00:00.000', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (292, N'Thẻ nhớ Transcend SDXC 330S 128GB High Speed 100MB/s', 520000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 90, '2026-07-23 10:00:00.000', 'Transcend');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (293, N'Thẻ nhớ ProGrade Digital SDXC UHS-II V60 256GB', 2800000, 'TDP: 3W', 'sabrent_rocket_4tb.jpg', 4, 30, '2026-07-23 10:00:00.000', 'ProGrade');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (294, N'Thẻ nhớ Sony TOUGH SF-G Series 128GB SDXC UHS-II 300MB/s', 4200000, 'TDP: 3W', 'sabrent_rocket_4tb.jpg', 4, 25, '2026-07-23 10:00:00.000', 'Sony');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (295, N'Thẻ nhớ Kioxia Exceria High Endurance 128GB MicroSD', 480000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 110, '2026-07-23 10:00:00.000', 'Kioxia');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (296, N'Thẻ nhớ TeamGroup GO Card MicroSDXC 256GB 100MB/s', 720000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 75, '2026-07-23 10:00:00.000', 'TeamGroup');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (297, N'Ổ cứng di động SSD SanDisk Extreme Portable 1TB USB 3.2 Gen 2', 2650000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 60, '2026-07-23 10:00:00.000', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (298, N'Ổ cứng di động Samsung T7 Shield 2TB Type-C Chống sốc IP65', 4850000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 45, '2026-07-23 10:00:00.000', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (299, N'Ổ cứng di động HDD WD My Passport 2TB USB 3.0 Black', 1950000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 80, '2026-07-23 10:00:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (300, N'Ổ cứng di động SSD Crucial X9 Pro 1TB 1050MB/s Vỏ nhôm', 2450000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 8, 50, '2026-07-23 10:00:00.000', 'Crucial');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (301, N'Ổ cứng gắn ngoài HDD Seagate Expansion Desktop 8TB 3.5 inch', 4900000, 'TDP: 10W', 'sabrent_rocket_4tb.jpg', 8, 30, '2026-07-23 10:00:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (302, N'Ổ cứng di động HDD Lacie Rugged Mini 2TB USB 3.0 Chống dằn xóc', 2800000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 40, '2026-07-23 10:00:00.000', 'LaCie');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (303, N'Ổ cứng di động SSD Kingston XS2000 1TB Type-C 2000MB/s Siêu nhỏ', 2950000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 35, '2026-07-23 10:00:00.000', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (304, N'Ổ cứng di động HDD Transcend StoreJet 25M3 1TB Chống sốc 3 lớp', 1650000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 70, '2026-07-23 10:00:00.000', 'Transcend');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (305, N'Ổ cứng di động SSD Corsair EX100U 2TB Type-C USB 3.2 Gen2x2', 4200000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 25, '2026-07-23 10:00:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (306, N'Ổ cứng di động SSD ADATA SE880 1TB Type-C 2000MB/s', 2550000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 8, 55, '2026-07-23 10:00:00.000', 'ADATA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (307, N'Tản nhiệt nước AIO NZXT Kraken Elite 360 RGB White LCD', 7250000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 30, '2026-07-23 10:00:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (308, N'Tản nhiệt nước AIO Corsair iCUE LINK H150i LCD White 360mm', 6800000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 25, '2026-07-23 10:00:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (309, N'Tản nhiệt nước AIO ASUS ROG Ryujin III 360 ARGB White Edition', 8900000, 'TDP: 20W', 'rog_ryujin_360.jpg', 9, 20, '2026-07-23 10:00:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (310, N'Tản nhiệt nước AIO MSI MAG CORELIQUID E360 Black', 3450000, 'TDP: 12W', 'rog_ryujin_360.jpg', 9, 50, '2026-07-23 10:00:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (311, N'Tản nhiệt nước AIO DeepCool LT720 360mm High-Performance', 3650000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 40, '2026-07-23 10:00:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (312, N'Tản nhiệt nước AIO Lian Li Galahad II Trinity SL-INF 360 White', 4950000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 35, '2026-07-23 10:00:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (313, N'Tản nhiệt nước AIO Cooler Master MasterLiquid 360 Atmos ARGB', 3850000, 'TDP: 12W', 'rog_ryujin_360.jpg', 9, 45, '2026-07-23 10:00:00.000', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (314, N'Tản nhiệt nước AIO Thermalright Frozen Prism 360 ARGB Black', 1850000, 'TDP: 10W', 'rog_ryujin_360.jpg', 9, 70, '2026-07-23 10:00:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (315, N'Tản nhiệt nước AIO Valkyrie GL360 ARGB Màn hình LCD Black', 4200000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 30, '2026-07-23 10:00:00.000', 'Valkyrie');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (316, N'Tản nhiệt nước AIO ID-COOLING DASHFLOW 360 Basic Black', 1650000, 'TDP: 10W', 'rog_ryujin_360.jpg', 9, 80, '2026-07-23 10:00:00.000', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (317, N'Card màn hình GIGABYTE GeForce RTX 4070 Ti SUPER WINDFORCE OC 16G', 23900000, 'TDP: 285W', 'asus_rog_rtx_4090.jpg', 10, 25, '2026-07-23 10:00:00.000', 'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (318, N'Card màn hình ASUS TUF Gaming GeForce RTX 4080 SUPER 16GB GDDR6X', 31500000, 'TDP: 320W', 'asus_rog_rtx_4090.jpg', 10, 20, '2026-07-23 10:00:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (319, N'Card màn hình MSI GeForce RTX 4060 Ti GAMING X SLIM 16G', 12800000, 'TDP: 165W', 'asus_rog_rtx_4090.jpg', 10, 40, '2026-07-23 10:00:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (320, N'Card màn hình ZOTAC GAMING GeForce RTX 4070 SUPER Twin Edge OC 12GB', 16900000, 'TDP: 220W', 'asus_rog_rtx_4090.jpg', 10, 35, '2026-07-23 10:00:00.000', 'ZOTAC');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (321, N'Card màn hình GALAX GeForce RTX 4070 Ti SUPER EX Gamer White 16GB', 24500000, 'TDP: 285W', 'asus_rog_rtx_4090.jpg', 10, 18, '2026-07-23 10:00:00.000', 'GALAX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (322, N'Card màn hình PowerColor Hellhound AMD Radeon RX 7900 XT 20GB', 21500000, 'TDP: 315W', 'asus_rog_rtx_4090.jpg', 10, 15, '2026-07-23 10:00:00.000', 'PowerColor');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (323, N'Card màn hình Sapphire NITRO+ AMD Radeon RX 7800 XT 16GB', 15800000, 'TDP: 263W', 'asus_rog_rtx_4090.jpg', 10, 30, '2026-07-23 10:00:00.000', 'Sapphire');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (324, N'Card màn hình XFX Speedster MERC 310 AMD Radeon RX 7900 GRE 16GB', 16950000, 'TDP: 260W', 'asus_rog_rtx_4090.jpg', 10, 22, '2026-07-23 10:00:00.000', 'XFX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (325, N'Card màn hình COLORFUL iGame GeForce RTX 4070 SUPER Ultra W OC 12GB', 17900000, 'TDP: 220W', 'asus_rog_rtx_4090.jpg', 10, 28, '2026-07-23 10:00:00.000', 'COLORFUL');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (326, N'Card màn hình ASRock Phantom Gaming Radeon RX 7700 XT 12GB OC', 12500000, 'TDP: 245W', 'asus_rog_rtx_4090.jpg', 10, 30, '2026-07-23 10:00:00.000', 'ASRock');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (327, N'Ổ cứng HDD PC Seagate Barracuda 2TB 3.5 inch SATA3 7200rpm', 1550000, 'TDP: 6W', 'sabrent_rocket_4tb.jpg', 11, 100, '2026-07-23 10:00:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (328, N'Ổ cứng HDD PC Western Digital Blue 2TB 3.5 inch 7200rpm', 1480000, 'TDP: 6W', 'sabrent_rocket_4tb.jpg', 11, 110, '2026-07-23 10:00:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (329, N'Ổ cứng HDD PC Toshiba P300 2TB 3.5 inch SATA3 7200rpm', 1390000, 'TDP: 6W', 'sabrent_rocket_4tb.jpg', 11, 90, '2026-07-23 10:00:00.000', 'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (330, N'Ổ cứng HDD Server Seagate IronWolf 4TB 3.5 inch NAS SATA3', 2950000, 'TDP: 7W', 'sabrent_rocket_4tb.jpg', 11, 60, '2026-07-23 10:00:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (331, N'Ổ cứng HDD Server Western Digital Red Plus 4TB 3.5 inch NAS', 3100000, 'TDP: 7W', 'sabrent_rocket_4tb.jpg', 11, 55, '2026-07-23 10:00:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (332, N'Ổ cứng HDD Enterprise Seagate Exos X18 16TB 3.5 inch SATA3', 8500000, 'TDP: 9W', 'sabrent_rocket_4tb.jpg', 11, 20, '2026-07-23 10:00:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (333, N'Ổ cứng HDD Enterprise Western Digital Gold 8TB 3.5 inch 7200rpm', 5900000, 'TDP: 8W', 'sabrent_rocket_4tb.jpg', 11, 30, '2026-07-23 10:00:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (334, N'Ổ cứng HDD PC Toshiba X300 4TB 7200rpm Gaming Internal', 3250000, 'TDP: 8W', 'sabrent_rocket_4tb.jpg', 11, 40, '2026-07-23 10:00:00.000', 'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (335, N'Ổ cứng HDD PC Western Digital Black 1TB 3.5 inch Performance', 1850000, 'TDP: 7W', 'sabrent_rocket_4tb.jpg', 11, 75, '2026-07-23 10:00:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (336, N'Ổ cứng HDD Camera Seagate SkyHawk 4TB 3.5 inch Surveillance', 2650000, 'TDP: 6W', 'sabrent_rocket_4tb.jpg', 11, 80, '2026-07-23 10:00:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (337, N'Nguồn Corsair RM750e ATX 3.0 80 Plus Gold Full Modular (750W)', 2850000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 60, '2026-07-23 10:00:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (338, N'Nguồn MSI MAG A750GL PCIE5 750W 80 Plus Gold Full Modular', 2650000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 70, '2026-07-23 10:00:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (339, N'Nguồn GIGABYTE UD850GM PG5 850W 80 Plus Gold PCIe 5.0', 3100000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 50, '2026-07-23 10:00:00.000', 'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (340, N'Nguồn ASUS TUF Gaming 750W 80 Plus Bronze', 2150000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 80, '2026-07-23 10:00:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (341, N'Nguồn Cooler Master MWE Gold 850 V2 Full Modular (850W)', 2950000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 65, '2026-07-23 10:00:00.000', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (342, N'Nguồn DeepCool PL750D 750W 80 Plus Bronze ATX 3.0 Native', 1750000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 90, '2026-07-23 10:00:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (343, N'Nguồn Super Flower Leadex III Gold 850W ARGB Full Modular', 3450000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 40, '2026-07-23 10:00:00.000', 'Super Flower');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (344, N'Nguồn Seasonic Focus GX-850 850W 80 Plus Gold Full Modular', 3650000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 45, '2026-07-23 10:00:00.000', 'Seasonic');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (345, N'Nguồn FSP Hydro G PRO 850W PCIe5.0 80 Plus Gold', 3350000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 50, '2026-07-23 10:00:00.000', 'FSP');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (346, N'Nguồn Thermaltake Toughpower GF A3 850W Gold ATX 3.0', 2950000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 55, '2026-07-23 10:00:00.000', 'Thermaltake');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (347, N'Vỏ case NZXT H6 Flow RGB Dual-Chamber Mid-Tower Black', 3450000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 40, '2026-07-23 10:00:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (348, N'Vỏ case Lian Li O11 Vision Tempered Glass Mid-Tower White', 3950000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 35, '2026-07-23 10:00:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (349, N'Vỏ case Corsair 4000D AIRFLOW Tempered Glass Mid-Tower Black', 2150000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 80, '2026-07-23 10:00:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (350, N'Vỏ case Montech KING 95 PRO Panoramic Curved Glass ARGB Black', 3650000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 30, '2026-07-23 10:00:00.000', 'Montech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (351, N'Vỏ case HYTE Y60 Panoramic Dual Chamber Glass Black/Red', 5450000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 20, '2026-07-23 10:00:00.000', 'HYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (352, N'Vỏ case Antec C8 Dual-Chamber Full Tower Black', 2850000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 45, '2026-07-23 10:00:00.000', 'Antec');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (353, N'Vỏ case Fractal Design Pop Air RGB TG Black', 2450000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 50, '2026-07-23 10:00:00.000', 'Fractal Design');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (354, N'Vỏ case DeepCool CH560 DIGITAL ARGB Màn hình nhiệt độ Black', 2650000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 60, '2026-07-23 10:00:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (355, N'Vỏ case Xigmatek ENDORPHIN ULTRA ARTIC White Panoramic', 1450000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 90, '2026-07-23 10:00:00.000', 'Xigmatek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (356, N'Vỏ case Phanteks NV5 Mid-Tower ARGB Black Glass', 2750000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 40, '2026-07-23 10:00:00.000', 'Phanteks');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (357, N'Tản nhiệt khí Thermalright Peerless Assassin 120 SE ARGB', 980000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 100, '2026-07-23 10:00:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (358, N'Tản nhiệt khí DeepCool AK400 Digital ARGB Màn hình LED Black', 1150000, 'TDP: 4W', 'rog_ryujin_360.jpg', 14, 80, '2026-07-23 10:00:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (359, N'Tản nhiệt khí Noctua NH-D15 chromax.black Dual-Tower Premium', 2950000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 35, '2026-07-23 10:00:00.000', 'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (360, N'Tản nhiệt khí ID-COOLING SE-224-XT ARGB V2 Black', 520000, 'TDP: 3W', 'rog_ryujin_360.jpg', 14, 120, '2026-07-23 10:00:00.000', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (361, N'Tản nhiệt khí Cooler Master Hyper 622 Halo Black ARGB Dual-Tower', 1350000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 60, '2026-07-23 10:00:00.000', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (362, N'Tản nhiệt khí Jonsbo CR-1000 EVO ARGB Black', 380000, 'TDP: 3W', 'rog_ryujin_360.jpg', 14, 150, '2026-07-23 10:00:00.000', 'Jonsbo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (363, N'Tản nhiệt khí Thermalright Phantom Spirit 120 EVO 7 Heatpipes', 1280000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 75, '2026-07-23 10:00:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (364, N'Tản nhiệt khí Be Quiet! Dark Rock Pro 5 Dual Tower', 2450000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 40, '2026-07-23 10:00:00.000', 'Be Quiet!');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (365, N'Tản nhiệt khí PCCOOLER K6 Digital Display ARGB Dual Tower', 1050000, 'TDP: 4W', 'rog_ryujin_360.jpg', 14, 65, '2026-07-23 10:00:00.000', 'PCCOOLER');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (366, N'Tản nhiệt khí Valkyrie SL125 ARGB Màn hiển thị nhiệt độ', 950000, 'TDP: 4W', 'rog_ryujin_360.jpg', 14, 70, '2026-07-23 10:00:00.000', 'Valkyrie');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (367, N'Bộ 3 Fan tản nhiệt Lian Li UNI FAN SL-Infinity 120 ARGB Triple Black', 2450000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 50, '2026-07-23 10:00:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (368, N'Bộ 3 Fan tản nhiệt Corsair iCUE LINK QX120 RGB Starter Kit White', 3650000, 'TDP: 4W', 'rog_ryujin_360.jpg', 15, 40, '2026-07-23 10:00:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (369, N'Bộ 3 Fan tản nhiệt NZXT Duo F120 RGB Triple Pack Black', 2150000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 60, '2026-07-23 10:00:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (370, N'Bộ 3 Fan tản nhiệt Thermalright TL-C12C-S ARGB Triple Pack Black', 480000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 120, '2026-07-23 10:00:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (371, N'Bộ 3 Fan tản nhiệt DeepCool FC120 3-in-1 ARGB Black', 850000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 80, '2026-07-23 10:00:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (372, N'Bộ 3 Fan tản nhiệt Phanteks D30-120 Reverse Airflow Triple Black', 2250000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 45, '2026-07-23 10:00:00.000', 'Phanteks');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (373, N'Bộ 3 Fan tản nhiệt ID-COOLING XF-12025 ARGB Trio Pack', 550000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 100, '2026-07-23 10:00:00.000', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (374, N'Bộ 3 Fan tản nhiệt Cooler Master MasterFan MF120 Halo2 ARGB White', 1350000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 70, '2026-07-23 10:00:00.000', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (375, N'Bộ 3 Fan tản nhiệt Antec Fusion 120 ARGB Triple Pack', 780000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 90, '2026-07-23 10:00:00.000', 'Antec');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (376, N'Bộ 3 Fan tản nhiệt Montech AX120 PWM ARGB Pack White', 650000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 95, '2026-07-23 10:00:00.000', 'Montech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (377, N'Bàn phím cơ AKKO 3087 v2 Silent Bluetooth 5.0 / Wireless 2.4G', 1450000, 'TDP: 1W', 'corsair_3500x_black.png', 16, 60, '2026-07-23 10:00:00.000', 'AKKO');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (378, N'Bàn phím cơ Keychron V1 Max Wireless Custom Mechanical Keyboard Hotswap', 2250000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 50, '2026-07-23 10:00:00.000', 'Keychron');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (379, N'Bàn phím cơ Royal Kludge RK84 RGB Wireless 80% Layout Hotswap', 980000, 'TDP: 1W', 'corsair_3500x_black.png', 16, 90, '2026-07-23 10:00:00.000', 'Royal Kludge');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (380, N'Bàn phím cơ FL-Esports FL980 SAM Tropical Secret Wireless', 2450000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 40, '2026-07-23 10:00:00.000', 'FL-Esports');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (381, N'Bàn phím cơ MonsGeek M1W V3 Fully Assembled Aluminum Wireless', 2150000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 45, '2026-07-23 10:00:00.000', 'MonsGeek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (382, N'Bàn phím cơ EPOMAKER RT100 Retro Mechanical Keyboard Màn hình Smart', 2650000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 35, '2026-07-23 10:00:00.000', 'EPOMAKER');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (383, N'Bàn phím cơ Ducky One 3 Daybreak Hotswap RGB Mech Keyboard', 2850000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 30, '2026-07-23 10:00:00.000', 'Ducky');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (384, N'Bàn phím cơ Varmilo VEA87 Vintage Mechanical Keyboard Cherry MX', 3150000, 'TDP: 1W', 'corsair_3500x_black.png', 16, 25, '2026-07-23 10:00:00.000', 'Varmilo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (385, N'Bàn phím cơ NuPhy Air75 V2 Low-Profile Wireless Keyboard', 2950000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 40, '2026-07-23 10:00:00.000', 'NuPhy');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (386, N'Bàn phím cơ Custom Womier K66 Gateron Switch RGB Acrylic Glass', 1250000, 'TDP: 1W', 'corsair_3500x_black.png', 16, 70, '2026-07-23 10:00:00.000', 'Womier');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (387, N'Chuột máy tính Razer Basilisk V3 Ergonomic Gaming Mouse 26k DPI', 1450000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 80, '2026-07-23 10:00:00.000', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (388, N'Chuột máy tính Logitech G304 LIGHTSPEED Wireless Black 12k DPI', 820000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 150, '2026-07-23 10:00:00.000', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (389, N'Chuột máy tính Pulsar X2 V2 Wireless Gaming Mouse Superlight 53g', 2150000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 45, '2026-07-23 10:00:00.000', 'Pulsar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (390, N'Chuột máy tính Ninjutso Sora V2 Ultra Lightweight Wireless 39g', 2450000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 40, '2026-07-23 10:00:00.000', 'Ninjutso');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (391, N'Chuột máy tính LAMZU Atlantis OG V2 Wireless Gaming Mouse 55g', 2250000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 50, '2026-07-23 10:00:00.000', 'LAMZU');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (392, N'Chuột máy tính Endgame Gear OP1WE Wireless Gaming Mouse 58g', 1950000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 60, '2026-07-23 10:00:00.000', 'Endgame Gear');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (393, N'Chuột máy tính VGN Dragonfly F1 PRO MAX Wireless Nordic MCU', 1150000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 90, '2026-07-23 10:00:00.000', 'VGN');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (394, N'Chuột máy tính VXE R1 PRO MAX Ultra Light Wireless PAW3395', 980000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 110, '2026-07-23 10:00:00.000', 'VXE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (395, N'Chuột máy tính SteelSeries Rival 3 Wireless Gaming Mouse 18k DPI', 950000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 100, '2026-07-23 10:00:00.000', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (396, N'Chuột máy tính ASUS ROG Harpe Ace Aim Lab Edition 54g Wireless', 2850000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 35, '2026-07-23 10:00:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (397, N'Tai nghe gaming HyperX Cloud II Wireless Red/Black Spatial Audio', 2950000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 60, '2026-07-23 10:00:00.000', 'HyperX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (398, N'Tai nghe gaming Razer BlackShark V2 X 7.1 Surround Sound Black', 1250000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 100, '2026-07-23 10:00:00.000', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (399, N'Tai nghe gaming Corsair HS80 RGB Wireless Spatial Audio White', 3450000, 'TDP: 2W', 'corsair_3500x_black.png', 18, 45, '2026-07-23 10:00:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (400, N'Tai nghe gaming Logitech G435 LIGHTSPEED Ultra-Light Wireless Blue', 1450000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 90, '2026-07-23 10:00:00.000', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (401, N'Tai nghe gaming SteelSeries Arctis Nova 7 Wireless Multi-Platform', 4250000, 'TDP: 2W', 'corsair_3500x_black.png', 18, 35, '2026-07-23 10:00:00.000', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (402, N'Tai nghe gaming EPOS Sennheiser GSP 300 Closed Acoustic Black/Blue', 1850000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 50, '2026-07-23 10:00:00.000', 'EPOS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (403, N'Tai nghe gaming Audio-Technica ATH-GDL3 Open-Back Gaming Headset', 3250000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 30, '2026-07-23 10:00:00.000', 'Audio-Technica');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (404, N'Tai nghe gaming JBL Quantum 400 USB Wired Gaming Headset QuantumSURROUND', 1950000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 70, '2026-07-23 10:00:00.000', 'JBL');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (405, N'Tai nghe gaming ASUS ROG Delta S Wireless Gaming Headset Type-C', 4650000, 'TDP: 2W', 'corsair_3500x_black.png', 18, 25, '2026-07-23 10:00:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (406, N'Tai nghe gaming EKSA E900 Pro 7.1 Surround Sound Wired Dual Audio', 750000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 120, '2026-07-23 10:00:00.000', 'EKSA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (407, N'Thẻ nhớ MicroSD Sandisk Ultra 32GB Class 10 120MB/s', 120000, 'TDP: 1W', 'sabrent_rocket_4tb.jpg', 4, 150, '2026-07-23 11:35:00.000', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (408, N'Thẻ nhớ MicroSD Sandisk High Endurance 64GB Chuyên ghi Dashcam', 290000, 'TDP: 1W', 'sabrent_rocket_4tb.jpg', 4, 100, '2026-07-23 11:35:00.000', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (409, N'Thẻ nhớ SDXC SanDisk Extreme PRO 64GB UHS-I 200MB/s', 450000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 120, '2026-07-23 11:35:00.000', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (410, N'Thẻ nhớ MicroSD Samsung EVO Plus 64GB kèm Adapter', 210000, 'TDP: 1W', 'sabrent_rocket_4tb.jpg', 4, 180, '2026-07-23 11:35:00.000', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (411, N'Thẻ nhớ MicroSD Samsung EVO Plus 128GB UHS-I U3', 350000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 140, '2026-07-23 11:35:00.000', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (412, N'Thẻ nhớ MicroSD Kingston Canvas Select Plus 64GB', 150000, 'TDP: 1W', 'sabrent_rocket_4tb.jpg', 4, 200, '2026-07-23 11:35:00.000', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (413, N'Thẻ nhớ MicroSD Kingston Canvas Select Plus 256GB', 520000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 90, '2026-07-23 11:35:00.000', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (414, N'Thẻ nhớ SDXC Lexar Professional 1667x 128GB SDXC UHS-II 250MB/s', 1150000, 'TDP: 3W', 'sabrent_rocket_4tb.jpg', 4, 60, '2026-07-23 11:35:00.000', 'Lexar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (415, N'Thẻ nhớ MicroSD Lexar Play 256GB UHS-I cho Nintendo Switch', 680000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 80, '2026-07-23 11:35:00.000', 'Lexar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (416, N'Thẻ nhớ SDXC Sony SF-E Series 64GB UHS-II 270MB/s', 850000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 50, '2026-07-23 11:35:00.000', 'Sony');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (417, N'Thẻ nhớ SDXC Sony TOUGH M Series 128GB UHS-II 270MB/s', 2100000, 'TDP: 3W', 'sabrent_rocket_4tb.jpg', 4, 35, '2026-07-23 11:35:00.000', 'Sony');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (418, N'Thẻ nhớ MicroSD Kioxia Exceria G2 256GB NVMe Class', 620000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 75, '2026-07-23 11:35:00.000', 'Kioxia');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (419, N'Thẻ nhớ SDXC Transcend 700S 64GB SDXC UHS-II V90 285MB/s', 1850000, 'TDP: 3W', 'sabrent_rocket_4tb.jpg', 4, 40, '2026-07-23 11:35:00.000', 'Transcend');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (420, N'Thẻ nhớ MicroSD TeamGroup PRO Endurance 128GB', 390000, 'TDP: 2W', 'sabrent_rocket_4tb.jpg', 4, 85, '2026-07-23 11:35:00.000', 'TeamGroup');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (421, N'Thẻ nhớ SDXC ProGrade Digital SDXC UHS-II V90 Cobalt 128GB', 3950000, 'TDP: 3W', 'sabrent_rocket_4tb.jpg', 4, 20, '2026-07-23 11:35:00.000', 'ProGrade');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (422, N'Ổ cứng di động SSD WD My Passport SSD 1TB USB 3.2 Red', 2450000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 8, 60, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (423, N'Ổ cứng di động SSD WD Black P50 Game Drive 1TB NVMe 2000MB/s', 3850000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 40, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (424, N'Ổ cứng di động HDD WD Elements Portable 1TB 2.5 inch USB 3.0', 1390000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 100, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (425, N'Ổ cứng di động HDD WD Elements Portable 4TB 2.5 inch USB 3.0', 3150000, 'TDP: 6W', 'sabrent_rocket_4tb.jpg', 8, 50, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (426, N'Ổ cứng di động SSD Samsung T7 Portable 1TB USB 3.2 Titan Gray', 2550000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 8, 70, '2026-07-23 11:35:00.000', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (427, N'Ổ cứng di động SSD Samsung T9 Portable 2TB USB 3.2 Gen 2x2 2000MB/s', 5450000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 30, '2026-07-23 11:35:00.000', 'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (428, N'Ổ cứng di động SSD SanDisk Extreme PRO Portable 2TB USB 3.2 Gen 2x2', 5150000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 35, '2026-07-23 11:35:00.000', 'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (429, N'Ổ cứng di động HDD Seagate One Touch 2TB 2.5 inch USB 3.0 Black', 2050000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 80, '2026-07-23 11:35:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (430, N'Ổ cứng di động HDD Seagate Basic 1TB 2.5 inch USB 3.0', 1290000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 110, '2026-07-23 11:35:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (431, N'Ổ cứng di động SSD Crucial X6 Portable SSD 2TB 800MB/s', 3450000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 8, 45, '2026-07-23 11:35:00.000', 'Crucial');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (432, N'Ổ cứng di động SSD Crucial X10 Pro 2TB USB 3.2 Gen 2x2 2100MB/s', 5850000, 'TDP: 5W', 'sabrent_rocket_4tb.jpg', 8, 25, '2026-07-23 11:35:00.000', 'Crucial');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (433, N'Ổ cứng di động SSD Kingston XS1000 2TB External SSD Type-C Red', 3650000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 8, 55, '2026-07-23 11:35:00.000', 'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (434, N'Tản nhiệt nước AIO Corsair H100i RGB ELITE 240mm', 3250000, 'TDP: 12W', 'rog_ryujin_360.jpg', 9, 50, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (435, N'Tản nhiệt nước AIO Corsair iCUE LINK H100i RGB White 240mm', 4850000, 'TDP: 12W', 'rog_ryujin_360.jpg', 9, 35, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (436, N'Tản nhiệt nước AIO NZXT Kraken 240 RGB Black LCD', 4250000, 'TDP: 12W', 'rog_ryujin_360.jpg', 9, 40, '2026-07-23 11:35:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (437, N'Tản nhiệt nước AIO NZXT Kraken 360 RGB Black LCD', 5350000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 30, '2026-07-23 11:35:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (438, N'Tản nhiệt nước AIO ASUS ROG Strix LC III 360 ARGB', 4950000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 25, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (439, N'Tản nhiệt nước AIO ASUS TUF Gaming LC II 360 ARGB', 2950000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 45, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (440, N'Tản nhiệt nước AIO DeepCool LS720 SE 360mm ARGB Black', 2650000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 60, '2026-07-23 11:35:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (441, N'Tản nhiệt nước AIO DeepCool MYSTIQUE 360 Màn hình LCD 3.4 inch', 4150000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 30, '2026-07-23 11:35:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (442, N'Tản nhiệt nước AIO Thermalright Frozen Warframe 360 ARGB Màn LCD', 2750000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 40, '2026-07-23 11:35:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (443, N'Tản nhiệt nước AIO Lian Li Galahad II LCD 360 SL-INF Black', 6450000, 'TDP: 15W', 'rog_ryujin_360.jpg', 9, 20, '2026-07-23 11:35:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (444, N'Tản nhiệt nước AIO MSI MAG CORELIQUID 240R V2', 2250000, 'TDP: 12W', 'rog_ryujin_360.jpg', 9, 55, '2026-07-23 11:35:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (445, N'Tản nhiệt nước AIO ID-COOLING FROSTFLOW X 240 Snow Edition White', 1150000, 'TDP: 10W', 'rog_ryujin_360.jpg', 9, 80, '2026-07-23 11:35:00.000', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (446, N'Card màn hình ASUS ROG Strix GeForce RTX 4090 OC Edition 24GB GDDR6X', 54900000, 'TDP: 450W', 'asus_rog_rtx_4090.jpg', 10, 10, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (447, N'Card màn hình MSI GeForce RTX 4080 SUPER 16G GAMING X TRIO', 33500000, 'TDP: 320W', 'asus_rog_rtx_4090.jpg', 10, 15, '2026-07-23 11:35:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (448, N'Card màn hình GIGABYTE GeForce RTX 4060 EAGLE OC 8G', 8450000, 'TDP: 115W', 'asus_rog_rtx_4090.jpg', 10, 60, '2026-07-23 11:35:00.000', 'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (449, N'Card màn hình GIGABYTE GeForce RTX 3050 WINDFORCE OC 6G', 4650000, 'TDP: 70W', 'asus_rog_rtx_4090.jpg', 10, 80, '2026-07-23 11:35:00.000', 'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (450, N'Card màn hình ASUS Dual GeForce RTX 4060 Ti EVO OC Edition 8GB', 11250000, 'TDP: 160W', 'asus_rog_rtx_4090.jpg', 10, 45, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (451, N'Card màn hình ZOTAC GAMING GeForce RTX 3060 Twin Edge OC 12GB', 7250000, 'TDP: 170W', 'asus_rog_rtx_4090.jpg', 10, 50, '2026-07-23 11:35:00.000', 'ZOTAC');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (452, N'Card màn hình Sapphire PULSE AMD Radeon RX 7600 8GB GDDR6', 7150000, 'TDP: 165W', 'asus_rog_rtx_4090.jpg', 10, 40, '2026-07-23 11:35:00.000', 'Sapphire');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (453, N'Card màn hình PowerColor Fighter AMD Radeon RX 6600 8GB GDDR6', 5250000, 'TDP: 132W', 'asus_rog_rtx_4090.jpg', 10, 55, '2026-07-23 11:35:00.000', 'PowerColor');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (454, N'Card màn hình ASRock Challenger Radeon RX 7800 XT 16GB OC', 14150000, 'TDP: 263W', 'asus_rog_rtx_4090.jpg', 10, 30, '2026-07-23 11:35:00.000', 'ASRock');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (455, N'Card màn hình COLORFUL GeForce GTX 1650 NB 4GD6-V', 3650000, 'TDP: 75W', 'asus_rog_rtx_4090.jpg', 10, 70, '2026-07-23 11:35:00.000', 'COLORFUL');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (456, N'Ổ cứng HDD PC Western Digital Purple 2TB 3.5 inch Surveillance', 1650000, 'TDP: 6W', 'sabrent_rocket_4tb.jpg', 11, 90, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (457, N'Ổ cứng HDD PC Western Digital Purple 4TB 3.5 inch Surveillance', 2750000, 'TDP: 7W', 'sabrent_rocket_4tb.jpg', 11, 70, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (458, N'Ổ cứng HDD PC Western Digital Purple 6TB 3.5 inch Surveillance', 4350000, 'TDP: 8W', 'sabrent_rocket_4tb.jpg', 11, 45, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (459, N'Ổ cứng HDD PC Seagate SkyHawk 2TB 3.5 inch Surveillance', 1550000, 'TDP: 6W', 'sabrent_rocket_4tb.jpg', 11, 85, '2026-07-23 11:35:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (460, N'Ổ cứng HDD PC Seagate SkyHawk 6TB 3.5 inch Surveillance', 4150000, 'TDP: 8W', 'sabrent_rocket_4tb.jpg', 11, 50, '2026-07-23 11:35:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (461, N'Ổ cứng HDD Server Seagate IronWolf Pro 8TB 3.5 inch NAS', 6150000, 'TDP: 9W', 'sabrent_rocket_4tb.jpg', 11, 30, '2026-07-23 11:35:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (462, N'Ổ cứng HDD Server Seagate IronWolf Pro 12TB 3.5 inch NAS', 8950000, 'TDP: 10W', 'sabrent_rocket_4tb.jpg', 11, 20, '2026-07-23 11:35:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (463, N'Ổ cứng HDD Server Western Digital Red Pro 8TB 3.5 inch NAS', 6450000, 'TDP: 9W', 'sabrent_rocket_4tb.jpg', 11, 25, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (464, N'Ổ cứng HDD Enterprise Seagate Exos X16 14TB 3.5 inch SATA3', 7250000, 'TDP: 10W', 'sabrent_rocket_4tb.jpg', 11, 25, '2026-07-23 11:35:00.000', 'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (465, N'Ổ cứng HDD Enterprise Western Digital Ultrastar DC HC550 18TB', 9450000, 'TDP: 10W', 'sabrent_rocket_4tb.jpg', 11, 15, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (466, N'Ổ cứng HDD PC Toshiba Canvio Basics 1TB 2.5 inch', 1250000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 11, 110, '2026-07-23 11:35:00.000', 'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (467, N'Ổ cứng HDD PC Toshiba Surveillance S300 4TB 3.5 inch', 2550000, 'TDP: 7W', 'sabrent_rocket_4tb.jpg', 11, 60, '2026-07-23 11:35:00.000', 'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (468, N'Ổ cứng HDD Laptop Western Digital Blue 1TB 2.5 inch SATA3', 1150000, 'TDP: 4W', 'sabrent_rocket_4tb.jpg', 11, 95, '2026-07-23 11:35:00.000', 'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (469, N'Nguồn Corsair RM850e ATX 3.0 80 Plus Gold Full Modular (850W)', 3450000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 50, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (470, N'Nguồn Corsair RM1000x Shift 80 Plus Gold Full Modular (1000W)', 4950000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 30, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (471, N'Nguồn Corsair CV650 650W 80 Plus Bronze', 1450000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 90, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (472, N'Nguồn MSI MAG A650BN 650W 80 Plus Bronze', 1250000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 110, '2026-07-23 11:35:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (473, N'Nguồn MSI MEG Ai1300P PCIE5 1300W 80 Plus Platinum', 8950000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 15, '2026-07-23 11:35:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (474, N'Nguồn ASUS ROG Thor 1000W Platinum II OLED', 8450000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 20, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (475, N'Nguồn ASUS TUF Gaming 650B 650W 80 Plus Bronze', 1650000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 80, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (476, N'Nguồn Cooler Master Elite V3 600W 230V', 1050000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 100, '2026-07-23 11:35:00.000', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (477, N'Nguồn DeepCool PK650D 650W 80 Plus Bronze', 1350000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 85, '2026-07-23 11:35:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (478, N'Nguồn ASRock Phantom Gaming PG-850G 850W 80 Plus Gold', 2950000, 'TDP: 0W', 'corsair_rm850e.jpg', 12, 40, '2026-07-23 11:35:00.000', 'ASRock');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (479, N'Vỏ case NZXT H9 Flow Dual-Chamber ATX Mid-Tower Black', 4450000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 30, '2026-07-23 11:35:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (480, N'Vỏ case NZXT H5 Flow RGB Compact Mid-Tower White', 2650000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 50, '2026-07-23 11:35:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (481, N'Vỏ case Lian Li O11 Dynamic EVO XL Full Tower Black', 5850000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 20, '2026-07-23 11:35:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (482, N'Vỏ case Lian Li Lancool 216 ARGB Mid-Tower Black', 2350000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 60, '2026-07-23 11:35:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (483, N'Vỏ case Corsair 3500X ARGB Mid-Tower Glass Black', 2450000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 70, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (484, N'Vỏ case Corsair 5000D AIRFLOW Tempered Glass Mid-Tower White', 3850000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 35, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (485, N'Vỏ case MSI MAG FORGE 100M Mid-Tower Black', 1150000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 90, '2026-07-23 11:35:00.000', 'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (486, N'Vỏ case Xigmatek Gaming X 3FX 3 Fan ARGB Black', 850000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 120, '2026-07-23 11:35:00.000', 'Xigmatek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (487, N'Vỏ case Mik Aios Black Kèm 3 Fan ARGB', 950000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 100, '2026-07-23 11:35:00.000', 'Mik');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (488, N'Vỏ case SAMA 3509 Black Kèm 3 Fan RGB', 750000, 'TDP: 0W', 'corsair_3500x_black.png', 13, 110, '2026-07-23 11:35:00.000', 'SAMA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (489, N'Tản nhiệt khí Thermalright Peerless Assassin 120 White ARGB', 1050000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 80, '2026-07-23 11:35:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (490, N'Tản nhiệt khí Thermalright Frost Tower 120 Dual Tower Black', 950000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 70, '2026-07-23 11:35:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (491, N'Tản nhiệt khí DeepCool AK620 Digital ARGB Black Dual Tower', 1850000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 50, '2026-07-23 11:35:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (492, N'Tản nhiệt khí DeepCool AG400 ARGB Single Tower', 450000, 'TDP: 3W', 'rog_ryujin_360.jpg', 14, 130, '2026-07-23 11:35:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (493, N'Tản nhiệt khí Noctua NH-U12S chromax.black Single Tower', 2150000, 'TDP: 4W', 'rog_ryujin_360.jpg', 14, 40, '2026-07-23 11:35:00.000', 'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (494, N'Tản nhiệt khí Noctua NH-L9i-17xx Low-Profile CPU Cooler', 1350000, 'TDP: 3W', 'rog_ryujin_360.jpg', 14, 60, '2026-07-23 11:35:00.000', 'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (495, N'Tản nhiệt khí ID-COOLING SE-207-XT Black Dual Tower', 950000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 75, '2026-07-23 11:35:00.000', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (496, N'Tản nhiệt khí ID-COOLING FROZN A620 Black Dual Tower', 1150000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 65, '2026-07-23 11:35:00.000', 'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (497, N'Tản nhiệt khí Cooler Master MasterAir MA612 Stealth Black', 1750000, 'TDP: 5W', 'rog_ryujin_360.jpg', 14, 45, '2026-07-23 11:35:00.000', 'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (498, N'Tản nhiệt khí Jonsbo CR-1400 ARGB Black', 280000, 'TDP: 2W', 'rog_ryujin_360.jpg', 14, 160, '2026-07-23 11:35:00.000', 'Jonsbo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (499, N'Bộ 3 Fan tản nhiệt Lian Li UNI FAN TL LCD 120 Reverse Black', 3450000, 'TDP: 4W', 'rog_ryujin_360.jpg', 15, 30, '2026-07-23 11:35:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (500, N'Bộ 3 Fan tản nhiệt Lian Li UNI FAN AL120 V2 ARGB Black', 2150000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 50, '2026-07-23 11:35:00.000', 'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (501, N'Bộ 3 Fan tản nhiệt Corsair LL120 RGB 120mm Dual Light Loop White', 2650000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 45, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (502, N'Bộ 3 Fan tản nhiệt Corsair SP120 RGB ELITE 120mm PWM Triple Pack', 1650000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 60, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (503, N'Bộ 3 Fan tản nhiệt NZXT F120 RGB Core Triple Pack White', 1850000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 55, '2026-07-23 11:35:00.000', 'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (504, N'Bộ 3 Fan tản nhiệt DeepCool FC120 White 3-in-1 ARGB', 890000, 'TDP: 3W', 'rog_ryujin_360.jpg', 15, 80, '2026-07-23 11:35:00.000', 'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (505, N'Bộ 3 Fan tản nhiệt Thermalright TL-C12C-S X3 White ARGB', 490000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 110, '2026-07-23 11:35:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (506, N'Bộ 3 Fan tản nhiệt Thermalright TL-K12 ARGB High-Performance', 650000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 90, '2026-07-23 11:35:00.000', 'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (507, N'Bộ 3 Fan tản nhiệt Montech RX120 PWM Reverse ARGB Pack', 690000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 85, '2026-07-23 11:35:00.000', 'Montech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (508, N'Bộ 3 Fan tản nhiệt Xigmatek Galaxy II Pro ARGB 3 Fan Pack', 450000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 120, '2026-07-23 11:35:00.000', 'Xigmatek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (509, N'Bộ 3 Fan tản nhiệt Mik Halo ARGB 3 Fan Pack Black', 380000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 130, '2026-07-23 11:35:00.000', 'Mik');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (510, N'Bộ 3 Fan tản nhiệt SAMA Halo ARGB Kit 3 Fan kèm Hub Remote', 350000, 'TDP: 2W', 'rog_ryujin_360.jpg', 15, 140, '2026-07-23 11:35:00.000', 'SAMA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (511, N'Fan tản nhiệt lẻ Noctua NF-A12x25 PWM chromax.black', 850000, 'TDP: 1W', 'rog_ryujin_360.jpg', 15, 90, '2026-07-23 11:35:00.000', 'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (512, N'Fan tản nhiệt lẻ Arctic P12 PWM PST Black 120mm', 220000, 'TDP: 1W', 'rog_ryujin_360.jpg', 15, 200, '2026-07-23 11:35:00.000', 'Arctic');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (513, N'Bàn phím cơ AKKO 5075B Plus Dragon Ball Z Wireless RGB', 2350000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 40, '2026-07-23 11:35:00.000', 'AKKO');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (514, N'Bàn phím cơ AKKO MonsGeek M1 V2 Kit Nhôm CNC Hotswap', 1850000, 'TDP: 1W', 'corsair_3500x_black.png', 16, 50, '2026-07-23 11:35:00.000', 'AKKO');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (515, N'Bàn phím cơ Keychron K2 Pro Wireless Bluetooth QMK/VIA Gateron', 2150000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 60, '2026-07-23 11:35:00.000', 'Keychron');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (516, N'Bàn phím cơ Keychron Q1 Max Full Aluminum Wireless Custom', 4650000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 25, '2026-07-23 11:35:00.000', 'Keychron');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (517, N'Bàn phím cơ Logitech G Pro X TKL LIGHTSPEED Wireless Black', 4150000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 35, '2026-07-23 11:35:00.000', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (518, N'Bàn phím cơ Razer BlackWidow V4 Pro Mechanical Gaming Keyboard', 5450000, 'TDP: 3W', 'corsair_3500x_black.png', 16, 20, '2026-07-23 11:35:00.000', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (519, N'Bàn phím cơ Corsair K70 RGB PRO Mechanical Gaming Keyboard', 3650000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 45, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (520, N'Bàn phím cơ SteelSeries Apex Pro TKL Wireless', 5950000, 'TDP: 2W', 'corsair_3500x_black.png', 16, 20, '2026-07-23 11:35:00.000', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (521, N'Bàn phím cơ ASUS ROG Azoth Wireless Custom Gaming Keyboard', 6850000, 'TDP: 3W', 'corsair_3500x_black.png', 16, 15, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (522, N'Bàn phím cơ Dareu EK87 V2 Multi-LED Tenkeyless Black', 450000, 'TDP: 1W', 'corsair_3500x_black.png', 16, 120, '2026-07-23 11:35:00.000', 'Dareu');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (523, N'Chuột máy tính Logitech G Pro X Superlight 2 Wireless Black', 3450000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 50, '2026-07-23 11:35:00.000', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (524, N'Chuột máy tính Logitech G502 X PLUS LIGHTSPEED Wireless RGB', 3650000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 40, '2026-07-23 11:35:00.000', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (525, N'Chuột máy tính Razer DeathAdder V3 Pro Wireless Ultra-Lightweight', 3250000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 45, '2026-07-23 11:35:00.000', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (526, N'Chuột máy tính Razer Viper V3 Pro Ultra-Lightweight Wireless', 3850000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 35, '2026-07-23 11:35:00.000', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (527, N'Chuột máy tính SteelSeries Aerox 3 Wireless Onyx Superlight', 1850000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 60, '2026-07-23 11:35:00.000', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (528, N'Chuột máy tính Corsair M65 RGB ULTRA Wireless Gaming Mouse', 2450000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 50, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (529, N'Chuột máy tính ASUS ROG Keris II Ace Ultra-Lightweight Wireless', 3150000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 40, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (530, N'Chuột máy tính Dareu EM901X RGB Wireless kèm Đế sạc', 590000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 100, '2026-07-23 11:35:00.000', 'Dareu');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (531, N'Chuột máy tính Rapoo VT9 PRO Dual-Mode Wireless Gaming Mouse', 790000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 90, '2026-07-23 11:35:00.000', 'Rapoo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (532, N'Chuột máy tính Fantech Helios II Pro XD3 V3 Wireless', 1250000, 'TDP: 1W', 'corsair_3500x_black.png', 17, 70, '2026-07-23 11:35:00.000', 'Fantech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (533, N'Tai nghe gaming HyperX Cloud III Wireless Black/Red 120-Hour Battery', 3850000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 40, '2026-07-23 11:35:00.000', 'HyperX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (534, N'Tai nghe gaming HyperX Cloud Stinger 2 Core Gaming Headset', 850000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 90, '2026-07-23 11:35:00.000', 'HyperX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (535, N'Tai nghe gaming Razer BlackShark V2 Pro Wireless 2023 Edition', 4450000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 35, '2026-07-23 11:35:00.000', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (536, N'Tai nghe gaming Razer Kraken Kitty V2 Pro RGB Quartz Pink', 4250000, 'TDP: 2W', 'corsair_3500x_black.png', 18, 30, '2026-07-23 11:35:00.000', 'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (537, N'Tai nghe gaming Logitech G PRO X 2 LIGHTSPEED Wireless Graphene', 5650000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 25, '2026-07-23 11:35:00.000', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (538, N'Tai nghe gaming Logitech G733 LIGHTSPEED Wireless RGB White', 2950000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 50, '2026-07-23 11:35:00.000', 'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (539, N'Tai nghe gaming SteelSeries Arctis Nova Pro Wireless PC/PlayStation', 8950000, 'TDP: 2W', 'corsair_3500x_black.png', 18, 15, '2026-07-23 11:35:00.000', 'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (540, N'Tai nghe gaming Corsair VIRTUOSO RGB WIRELESS High-Fidelity', 4850000, 'TDP: 2W', 'corsair_3500x_black.png', 18, 30, '2026-07-23 11:35:00.000', 'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (541, N'Tai nghe gaming ASUS ROG Pugi III Delta S Animate Display', 5250000, 'TDP: 2W', 'corsair_3500x_black.png', 18, 20, '2026-07-23 11:35:00.000', 'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (542, N'Tai nghe gaming Dareu EH722X 7.1 Surround Sound Pink', 490000, 'TDP: 1W', 'corsair_3500x_black.png', 18, 110, '2026-07-23 11:35:00.000', 'Dareu');
SET IDENTITY_INSERT products OFF;
GO

SET IDENTITY_INSERT products ON;
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (1, 'Intel Core i9-14900K', 15500000, '24 Cores, up to 6.0GHz, LGA 1700', 'i9_14900k.jpg', 1, 46, '2026-04-06 13:46:29.076393', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (2, 'AMD Ryzen 9 7950X3D', 17200000, '16 Cores, 128MB L3 Cache, AM5', 'i9_14900k.jpg', 1, 15, NULL, NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (3, N'Intel Core i7-14700Kkk', 10800000, N'20 Cores, Hybrid Architecture', N'https://himmcom.com.np/wp-content/uploads/2024/01/1-3.jpg%20?%3E', 1, 40, NULL, NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (4, N'AMD Ryzen 7 7800X3D', 11500000, N'Best gaming CPU, 8 Cores, 3D V-Cache', N'https://www.amd.com/content/dam/amd/en/images/products/processors/ryzen/2505503-ryzen-7-7800x3d.jpg', 1, 27, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (5, N'Intel Core i5-13600K', 8200000, N'14 Cores, Mid-range gaming', N'https://www.notebookcheck.net/fileadmin/Notebooks/Sonstiges/Intel/Raptor_Lake_S/Raptor_Lake_7.jpg', 1, 54, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (6, N'AMD Ryzen 5 7600X', 5800000, N'6 Cores, Zen 4 Architecture, AM5', N'https://ezonelb.com/wp-content/uploads/2024/04/amd_ryzen-5-7600x_01.jpg', 1, 59, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (7, N'Intel Core i9-13900KS', 18500000, N'Special Edition, 6.0GHz', N'https://tpucdn.com/cpu-specs/images/chips/2956-front.jpg', 1, 0, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (8, N'AMD Ryzen 9 7900X', 10500000, N'12 Cores, 5.6GHz Boost', N'https://www.notebookcheck.net/uploads/tx_nbc2/R9_7900_9.jpg', 1, 18, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (9, N'Intel Core i7-13700F', 8900000, N'16 Cores, No Integrated Graphics', N'https://microless.com/cdn/products/08f5cf4e0f9b43cecfee68f4a554f23c-hi.jpg', 1, 45, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (10, N'AMD Ryzen 7 5800X3D', 8500000, N'Legendary AM4 gaming CPU', N'https://hothardware.com/contentimages/NewsItem/71155/content/16x9_2133x1200_highres-amd-ryzen-7-5800x3d-anniversary.jpg', 1, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (11, N'Intel Core i5-12400F', 3500000, N'Budget King, 6 Cores', N'https://atcsjo.com/public/uploads/all/PZ7Ofk2PcEE8TNoZi0QSSfpF5x5tI84fcjFIBiLt.jpg', 1, 96, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (12, N'AMD Ryzen 5 5600G', 3200000, N'Integrated Vega Graphics', N'https://networkitstore.in/wp-content/uploads/2024/01/amd-ryzen-5600g-600x600.webp', 1, 71, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (13, N'Intel Core i3-14100', 3800000, N'Entry level 14th Gen', N'https://www.techpowerup.com/review/intel-core-i3-14100/images/cpu-front.jpg', 1, 70, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (14, N'AMD Ryzen 3 4100', 1800000, N'Budget 4 Cores, AM4', N'https://www.falconcomputers.co.uk/media/products/94109/0/0/amd-ryzen-3-4100-38ghz-4-core-am4-socket-overclockable-processor-with-wraith-steath-cooler-retail-boxed.jpg.jpg', 1, 118, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (15, N'Intel Core i9-12900K', 9500000, N'16 Cores, Previous Flagship', N'https://www.pcworld.com/wp-content/uploads/2021/11/12th_Gen_Core_i9_12900K_Hero_Close_Up-4.jpg?resize=1536%2C1024&quality=50&strip=all', 1, 13, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (16, N'Vỏ máy tính Xigmatek QUANTUM 4AF', 800000, N'TDP: 0W', N'http://cdn.hstatic.net/products/200000722513/gearvn-vo-may-tinh-xigmatek-quantum-4af-1_c9db476a42ef48fba6d84a9703a94945_grande.jpg', 13, 100, '6/27/2026 12:22:45 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (17, N'Intel Core i5-14400F', 5600000, N'10 Cores, Efficient Gaming', N'https://microless.com/cdn/products/30c01bcc173314e1a756151858871162-hi.jpg', 1, 65, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (18, N'AMD Ryzen 5 8600G', 6200000, N'AI Engine, Radeon 760M', N'https://images.versus.io/objects/amd-ryzen-5-8600g.front.master2x.1704766286597.webp', 1, 35, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (19, N'Intel Core i7-12700K', 7200000, N'12 Cores, LGA 1700', N'https://product.hstatic.net/200000680839/product/hz__25mb__12_cores_20_threads__0703223b7ae44a9ca2dd97b79516fa6f_master_de0749de4f2f4df687f7940d2cd121d9_1024x1024.jpg', 1, 34, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (20, N'AMD Ryzen 7 7700', 7800000, N'8 Cores, Low Power 65W', N'https://www.ryans.com/storage/products/main/amd-ryzen-7-7700-38ghz-53ghz-8-core-40mb-cache-11696328242.webp', 1, 28, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (21, N'Intel Core i5-11400F', 2800000, N'Old Gen Budget King', N'https://www.techpowerup.com/cpu-specs/images/chips/2407-front.jpg', 1, 50, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (22, N'AMD Ryzen 5 4500', 1950000, N'Super Budget 6 Cores', N'https://m.media-amazon.com/images/I/91OZjLdueYL._AC_SL1500_.jpg', 1, 94, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (23, N'Intel Core i9-11900K', 6500000, N'Legacy Flagship LGA 1200', N'https://www.notebookcheck.com/fileadmin/Notebooks/Sonstiges/Intel/Rocket_Lake_S/Rocket_Lake_S_6.jpg', 1, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (24, N'AMD Ryzen 5 3600', 2100000, N'Popular AM4 CPU', N'https://m.media-amazon.com/images/I/81b75EQJrgL.jpg', 1, 150, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (25, N'Intel Core i5-10400F', 2200000, N'Stable and Cheap', N'https://tpucdn.com/cpu-specs/images/chips/2270-front.jpg', 1, 110, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (26, N'AMD Ryzen 9 3900X', 7500000, N'12 Cores, Workstation', N'https://m.media-amazon.com/images/I/71ZANS0SSDL.jpg', 1, 8, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (27, N'Intel Pentium G7400', 1900000, N'Office work, 2 Cores', N'https://image.made-in-china.com/2f0j00HPzqpKeCABkW/for-Original-Best-Price-Intel-Pentium-Gold-G7400-Processor-3-70GHz-CPU-Alder-Lake-SRL66-LGA-1700-Processor-for-Desktop.jpg', 1, 200, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (28, N'AMD Athlon 3000G', 1200000, N'Ultra Budget Graphics', N'https://m.media-amazon.com/images/I/51wiBVz7jaL._AC_SL1000_.jpg', 1, 180, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (29, N'Intel Core i7-10700K', 4800000, N'High Clock Legacy', N'https://cdn.mos.cms.futurecdn.net/2WTyhwkcYo5b43PuCQYkzU.jpg', 1, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (30, N'AMD Ryzen 7 8700G', 9200000, N'Powerful APU, Radeon 780M', N'https://m.media-amazon.com/images/I/61nRX0W6fhL._AC_SL1500_.jpg', 1, 33, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (31, N'NVIDIA RTX 4090 24GB', 55000000, N'Ultimate Gaming GPU', N'https://media.ldlc.com/r1600/ld/products/00/06/12/43/LD0006124357.jpg', 2, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (32, N'RTX 4080 Super', 32000000, N'High-end 4K Gaming', N'https://checkfps.io/_next/image?url=%2Fimg%2Fgpu%2Frtx-4080-super.jpg&w=3840&q=75', 2, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (33, N'RTX 4070 Ti Super', 24500000, N'Perfect for 2K Gaming', N'https://checkfps.io/_next/image?url=%2Fimg%2Fgpu%2Frtx-4070-ti-super.jpg&w=3840&q=75', 2, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (34, N'AMD RX 7900 XTX', 28500000, N'AMD Flagship, 24GB', N'https://sm.ign.com/ign_ap/photo/default/pxl-20221205-200737220-portrait-1670634086080_cwha.jpg', 2, 12, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (35, N'RTX 4060 Ti 8GB', 11500000, N'Efficient 1080p/2K', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6545/6545279cv12d.jpg', 2, 43, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (36, N'AMD RX 7800 XT', 15200000, N'Best value 2K GPU', N'https://images-na.ssl-images-amazon.com/images/S/mediaservice.woot.com/29d66b60-097c-43ff-9d25-cc9d5c3448f0._AC_SR882,441_.png', 2, 30, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (37, N'RTX 3060 12GB', 7800000, N'Popular Mid-range', N'https://m.media-amazon.com/images/I/81si2RRaWUS.jpg', 2, 80, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (38, N'AMD RX 6600', 5500000, N'Best budget 1080p', N'https://m.media-amazon.com/images/I/81Ts3uaZqgL._AC_.jpg', 2, 100, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (39, N'ASUS ROG RTX 4090', 62000000, N'Premium build cooling', N'https://pcdiy.com.au/wp-content/uploads/2022/10/rog-4090-review.jpg', 2, 5, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (40, N'MSI Gaming X RTX 4070', 18500000, N'Quiet and Cool', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6539/6539607cv17d.jpg', 2, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (41, N'Gigabyte Eagle RTX 4060', 8200000, N'Triple Fan Budget', N'https://static.gigabyte.com/StaticFile/Image/Global/ca46ef321ac872a92db97cd434c951b6/Product/39542/Png', 2, 60, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (42, N'RTX 4070 Super', 17800000, N'12GB GDDR6X, Fast', N'https://checkfps.io/_next/image?url=%2Fimg%2Fgpu%2Frtx-4070-super.jpg&w=3840&q=75', 2, 35, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (43, N'AMD RX 7600', 7900000, N'Budget RDNA 3', N'https://m.media-amazon.com/images/I/81QItJufypL._AC_.jpg', 2, 50, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (44, N'RTX 3050 6GB', 5200000, N'Entry level RTX', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/d2e9569c-e820-41de-9d8b-c3d26b98ac87.jpg', 2, 70, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (45, N'Zotac RTX 4060', 7800000, N'Compact dual fan', N'https://m.media-amazon.com/images/I/81w-5i9+nbL.jpg', 2, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (46, N'Galax RTX 4070 Pink', 16900000, N'Pink Edition RGB', N'https://images-na.ssl-images-amazon.com/images/I/81FyWeI-qpL.jpg', 2, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (47, N'ASUS TUF RTX 3070 Ti', 12000000, N'Rugged build quality', N'https://m.media-amazon.com/images/I/81t7Ga7nyxS._AC_.jpg', 2, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (48, N'EVGA RTX 3080', 15000000, N'High performance legacy', N'https://c1.neweggimages.com/ProductImageCompressAll1280/14-487-518-01.jpg', 2, 5, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (49, N'Sapphire RX 7900 GRE', 16500000, N'Golden Rabbit Edition', N'https://cdn.wccftech.com/wp-content/uploads/2023/07/AMD-Radeon-RX-7900-GRE-16-GB-GPU-Sapphire-Nitro-_5-g-standard-scale-4_00x-g-standard-scale-4_00x-Custom-1456x772.jpeg', 2, 18, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (50, N'PowerColor RX 7800 XT', 14800000, N'Excellent cooling', N'https://media.ldlc.com/r1600/ld/products/00/06/17/51/LD0006175116.jpg', 2, 22, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (51, N'GTX 1650', 3800000, N'No external power', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6347/6347252_sd.jpg', 2, 150, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (52, N'RX 6700 XT', 9500000, N'Great 1440p value', N'https://media.ldlc.com/r1600/ld/products/00/05/80/29/LD0005802927_1.jpg', 2, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (53, N'Colorful RTX 4080', 31000000, N'LCD screen on GPU', N'https://product.hstatic.net/200000420363/product/card-man-hinh-vga-colorful-geforce-rtx-4080-16gb-nb-ex-v-5_b75b5c93f4eb4c5aac487e7b2bd38964_master.jpg', 2, 8, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (54, N'Quadro RTX A4000', 22000000, N'Workstation GPU', N'https://5.imimg.com/data5/SELLER/Default/2022/6/VF/ZD/YJ/3092725/nvidia-quadro-rtx4000-8gb-1-500x500.jpg', 2, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (55, N'Radeon Pro W7800', 58000000, N'Professional Graphics', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3773/innergigabyte/images/kft.png', 2, 3, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (56, N'Intel Arc A770 16GB', 9200000, N'Intel High-end GPU', N'https://pg.asrock.com/Graphics-Card/photo/Intel%20Arc%20A770%20Phantom%20Gaming%2016GB%20OC(L1).png', 2, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (57, N'Intel Arc A750', 6500000, N'Budget King Intel', N'https://m.media-amazon.com/images/I/71sO2CZL1UL.jpg', 2, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (58, N'ASUS Dual RTX 4070', 17500000, N'Clean white build', N'https://media.ldlc.com/r1600/ld/products/00/06/03/60/LD0006036039.jpg', 2, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (59, N'Gigabyte RTX 4090', 59000000, N'Massive cooler', N'https://www.cfd.co.jp/webpim/product/image/g/gv-n4090wf3-24gd/gv-n4090wf3-24gd/gv-n4090wf3-24gd__0100.png', 2, 4, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (60, N'PNY RTX 4060', 7500000, N'Small and efficient', N'https://i5.walmartimages.com/asr/7a16bb22-0ab5-4190-b4b4-419ccbbb8de2.7f8f100c1db40b894fbac7d7c38e995b.jpeg', 2, 55, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (61, N'Corsair Vengeance 32GB', 3500000, N'DDR5 6000MHz Black', N'https://m.media-amazon.com/images/I/81EEpt-xy0L.jpg', 3, 50, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (62, N'G.Skill Trident Z5 32GB', 4200000, N'DDR5 6400MHz RGB', N'https://m.media-amazon.com/images/I/71DiVTefKBL._AC_.jpg', 3, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (63, N'Kingston Fury 16GB', 1250000, N'DDR4 3200MHz', N'https://m.media-amazon.com/images/I/71+clMT-q-L._AC_SL1500_.jpg', 3, 120, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (64, N'T-Force Delta 32GB', 3200000, N'DDR5 6000MHz White', N'https://os-jo.com/image/cache/catalog/products/memory/FF3D532G6000HC30DC01/81XZeKnL6LL._AC_UF894,1000_QL80_-1200x1200.jpg', 3, 45, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (65, N'ADATA XPG 16GB', 1800000, N'DDR5 5200MHz', N'https://www.esocket.us/wp-content/uploads/2021/01/20210128_211718-scaled.jpg', 3, 70, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (66, N'Crucial 8GB', 650000, N'Standard office RAM', N'https://supertechwebstore.com/wp-content/uploads/2023/07/1-11.jpg', 3, 200, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (67, N'Dominator Titanium 64GB', 9500000, N'DDR5 7200MHz', N'https://m.media-amazon.com/images/I/611o1NX2HvL._AC_.jpg', 3, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (68, N'Ripjaws V 16GB', 1100000, N'DDR4 3600MHz', N'https://ryans.com/storage/products/main/gskill-ripjaws-v-16gb-ddr4-3200mhz-black-11723012156.webp', 3, 90, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (69, N'Lexar Thor 32GB', 2100000, N'DDR4 3200MHz Budget', N'https://down-ph.img.susercontent.com/file/ph-11134207-7ras8-m2lujp7y6sc27f', 3, 55, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (70, N'Fury Renegade 32GB', 4800000, N'DDR5 7200MHz', N'https://m.media-amazon.com/images/I/71GJY5+c14L._AC_SL1500_.jpg', 3, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (71, N'PNY XLR8 16GB', 1350000, N'DDR4 3200MHz RGB', N'https://basitcomputers.com/wp-content/uploads/2024/12/16GB-DDR4-RAM-3200MHz-PNY-XLR8-GAMiNG-RAM-WiTH-HEATSiNK-105.jpg', 3, 60, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (72, N'Silicon Power 16GB', 950000, N'Value RAM 3200', N'https://static1.nordic.pictures/890711-thickbox_default/silicon-power-flash-drive-16gb-marvel-m01-usb-30-blue.jpg', 3, 150, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (73, N'Mushkin Redline 32GB', 3400000, N'DDR5 5600MHz', N'https://www.singular.com.cy/images/detailed/615/Mushkin_Redline_DDR5_module_32_GB_SODIMM_MRA5S480FFFD32G-895755.jpg', 3, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (74, N'Patriot Viper 16GB', 1450000, N'DDR4 4000MHz', N'https://tanphatad.com/wp-content/uploads/tanphatad/Patriot-Memory-Viper-Venom-RGB-DDR5-600-RAM-16GB-3.jpg', 3, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (75, N'Samsung 32GB', 2800000, N'DDR5 4800MHz OEM', N'https://jumbocolombiaio.vtexassets.com/arquivos/ids/476318/8806094731989_1.jpg?v=638163096318000000', 3, 30, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (76, N'Thermaltake 16GB', 2200000, N'DDR4 3600MHz RGB', N'https://www.ucc.com.bd/image/cache/catalog/ram/dekstop-ram/thermaltake/toughram-rgb-white/16gb/3200-mhz/thermaltake-16gb-toughram-rgb-ddr4-3200-mhz-cl16-16gb-x-1-desktop-ram-white-550x550.jpg.webp', 3, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (77, N'Zadak Spark 32GB', 3900000, N'DDR5 6000MHz', N'https://img.terabyteshop.com.br/produto/g/memoria-ddr4-zadak-spark-rgb-32gb-3600mhz-2x16gb-zd4-spr36c25-32g2b2_132087.jpg', 3, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (78, N'Apacer Panther 8GB', 750000, N'Budget Gaming RAM', N'https://songphuong.vn/Content/uploads/2021/11/Ram-Apacer-OC-Panther-Golden-8GB-DDR4-3200MHz-1-songphuong.vn_.jpg', 3, 100, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (79, N'GeIL Super Luce 16GB', 1300000, N'DDR4 3200MHz', N'https://www.memoryc.com/images/products/bb/geil-16570-2_63013.jpg', 3, 50, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (80, N'V-Color Prism 32GB', 3100000, N'DDR4 3600MHz RGB', N'https://microless.com/cdn/products/f2f307222b823793c47a0da071ca69c0-hi.jpg', 3, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (81, N'Kingston Fury 64GB', 6800000, N'DDR5 5600MHz Kit', N'https://m.media-amazon.com/images/I/715QXNdKxiL._AC_.jpg', 3, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (82, N'Vengeance LPX 32GB', 2500000, N'DDR4 3200 Low Profile', N'https://res.cloudinary.com/jawa/image/upload/f_auto,ar_1:1,c_fill,w_3840,q_auto/production/listings/fxqabbdlbowyj2wl8sks', 3, 80, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (83, N'Trident Z Neo 32GB', 3400000, N'Optimized for Ryzen', N'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/2/0/20-374-105-02.jpg', 3, 35, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (84, N'Team Elite 16GB', 1600000, N'DDR5 4800 Basic', N'https://down-ph.img.susercontent.com/file/id-11134207-7rask-m5jh3ypl5hul99', 3, 60, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (85, N'Crucial Pro 32GB', 3300000, N'6000MHz Overclock', N'https://m.media-amazon.com/images/I/61EUuA9HiaL._AC_.jpg', 3, 45, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (86, N'Aorus RGB 16GB', 2400000, N'3733MHz w/ Demo', N'https://static.gigabyte.com/StaticFile/Image/Global/ad60477ff44e587c09b67ee56b883341/Product/19876', 3, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (87, N'Lexar Ares 32GB', 3600000, N'DDR5 6400MHz', N'https://platincdn.com/3393/pictures/JIYFEDVBRW1182024185730_Lexar-Ares-DT-32GB-RGB-DDR5-LD5EU016G-R6400GDLA-Ra.jpg', 3, 30, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (88, N'Netac Shadow 16GB', 1100000, N'Budget RGB RAM', N'https://netacbd.com/wp-content/uploads/2022/07/1080X1080-7-e1677757851813.jpg', 3, 100, NULL, NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (89, N'Galax HOF 32GB', 5500000, N'8000MHz White OC', N'https://www.cowcotland.com/images/news/2025/04/big/galax-rtx5090dhoflab.jpg', 3, 5, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (90, N'Oloy Blade 32GB', 3250000, N'DDR5 6000MHz Black', N'https://i5.walmartimages.com/seo/OLOy-Blade-RGB-32GB-2-x-16GB-288-Pin-PC-RAM-DDR4-3600-PC4-28800-Desktop-Memory-Model-ND4U1636181DRKDE_e65c195a-eba5-42b3-9551-e8dfdd9cf1ce.1b1974844fb12e93389871c8ea8b08fc.jpeg', 3, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (91, N'ROG Maximus Z790 Hero', 16500000, N'Flagship Intel Board', N'https://dlcdnwebimgs.asus.com/gain/7512B84A-0D14-4798-A585-3439F4B645CB/w1000/h732', 5, 12, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (92, N'B760M Mortar WiFi', 4500000, N'Best Mid-range Intel', N'https://storage-asset.msi.com/global/picture/image/feature/mb/B760M/mag-b760m-mortar-wifi/msi-b760m-mortar-wifi-motherboard.png', 5, 45, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (93, N'Z790 Aorus Elite', 7800000, N'High perf Z790', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2181/innergigabyteimages/specsmall01.jpg', 5, 30, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (94, N'TUF B650-Plus', 5800000, N'Standard AM5 Board', N'https://dlcdnwebimgs.asus.com/files/media/2b278afc-50b2-452f-9fae-ec2825d27632/V1/img/kv-main.png', 5, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (95, N'B660M Pro RS', 3200000, N'Budget Intel 12/13', N'https://nguyencongpc.vn/media/product/22934-main-b660m-pro-rs-ax-4.jpeg', 5, 60, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (96, N'X670E Carbon WiFi', 11500000, N'High-end AM5', N'https://www.pcstudio.in/wp-content/uploads/2022/09/Msi-Mpg-X670E-Carbon-Wifi-Motherboard-2.jpg', 5, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (97, N'Prime H610M-K', 2100000, N'Office Intel Board', N'https://dlcdnwebimgs.asus.com/gain/eb6af592-21fd-4592-81f3-d342cf769939/', 5, 100, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (98, N'B450M DS3H', 1850000, N'Legendary AM4 Budget', N'https://rbtechngames.com/wp-content/uploads/2021/08/gigabyte_b450m_ds3h.jpg', 5, 80, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (99, N'ROG Strix B760-I', 5900000, N'ITX Intel Board', N'https://dlcdnwebimgs.asus.com/gain/6F72A739-6576-4E2E-B224-61390DFA287F/w1000/h732', 5, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (100, N'Z790 GODLIKE', 35000000, N'Ultimate Overclock', N'https://storage-asset.msi.com/global/picture/image/feature/mb/Z790/MEG-Z790-GODLIKE/m2-01.png', 5, 3, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (101, N'Z790 Taichi', 12500000, N'Gear design, E-ATX', N'https://m.media-amazon.com/images/I/81OIw3yjYeL._AC_.jpg', 5, 8, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (102, N'ProArt Z790-Creator', 13800000, N'For Creators', N'https://dlcdnwebimgs.asus.com/gain/fe64f38f-9f58-4722-b2b0-723379b316be/', 5, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (103, N'B650I Aorus Ultra', 7200000, N'ITX AM5 Board', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2226/innergigabyteimages/smartfan601.png', 5, 12, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (104, N'PRO H610M-E', 1950000, N'Cheap office build', N'https://m.media-amazon.com/images/I/81MY4UCX8wL._AC_SY450_.jpg', 5, 150, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (105, N'Crosshair X670E', 28000000, N'Best of AM5', N'https://files.pccasegear.com/images/ROG-CROSSHAIR-X670E-EXTREME-add5.jpg', 5, 5, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (106, N'Biostar B760MZ', 3100000, N'Budget B760', N'https://microless.com/cdn/products/a0122264cca32a3cf97401f16cb33fc2-hi.jpg', 5, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (107, N'CVN B760M Frozen', 4200000, N'White Motherboard', N'https://product.hstatic.net/200000420363/product/mainboard-colorful-cvn-b760m-plus-frozen-wifi-d5-v20_ebaf35779b3d445ba23be5e1ce43cd5c_master.png', 5, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (108, N'A520M S2H', 1650000, N'Budget AM4', N'https://media.ldlc.com/r1600/ld/products/00/05/70/93/LD0005709352_1.jpg', 5, 90, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (109, N'NZXT N7 Z790', 8500000, N'Clean Aesthetic', N'https://m.media-amazon.com/images/I/71u-dioc8vL._AC_SL1500_.jpg', 5, 18, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (110, N'A620M-HDV', 2800000, N'Cheap AM5 entry', N'https://media.ldlc.com/r1600/ld/products/00/06/03/41/LD0006034175.jpg', 5, 55, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (111, N'Z790 Dark Kingpin', 22000000, N'Limitless OC', N'https://www.thefpsreview.com/wp-content/uploads/2022/09/evga-z790-dark-kingpin-motherboard-face-transparent.png', 5, 2, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (112, N'X570S Tomahawk', 6500000, N'Silent AM4', N'https://storage-asset.msi.com/global/picture/image/feature/mb/X570/X570S-Tomahawk/x570s-tomahawk-hero-03-new.png', 5, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (113, N'A520M-Plus', 2400000, N'Durable AM4', N'https://www.cclonline.com/images/avante/5_TUF-GAMING-A520M-PLUS-WIFI_3D_AURA.jpg?width=1600&height=1600&scale=canvas', 5, 45, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (114, N'Z790 UD', 5500000, N'Basic Z790', N'https://m.media-amazon.com/images/I/71w2Kf+KK+L._AC_.jpg', 5, 35, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (115, N'B550M Steel Legend', 3800000, N'Solid B550 AM4', N'https://www.asrock.com/mb/photo/B550M%20Steel%20Legend(L1).png', 5, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (116, N'MSI B650 Gaming', 4900000, N'Budget AM5 WiFi', N'https://media.ldlc.com/r1600/ld/products/00/06/03/76/LD0006037607.jpg', 5, 50, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (117, N'Prime Z790-P', 6200000, N'Mainstream Z790', N'https://www.dateks.lv/images/pic/2400/2400/712/1307.jpg', 5, 30, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (118, N'H610M S2H', 2250000, N'LGA 1700 Office', N'https://m.media-amazon.com/images/I/81AdQh4+sHL._AC_SL1500_.jpg', 5, 110, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (119, N'X670E Steel Legend', 8900000, N'White AM5 High', N'https://media.ldlc.com/r1600/ld/products/00/05/98/02/LD0005980298.jpg', 5, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (120, N'Valkyrie Z790', 9500000, N'Biostar Flagship', N'https://cdn.mos.cms.futurecdn.net/qAs5WBF8JXptoXfeK5A9ZV.jpg', 5, 7, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (121, N'Samsung 990 Pro 1T', 3200000, N'NVMe Gen4 7450MB/s', N'https://s13emagst.akamaized.net/products/50830/50829483/images/res_a126340b9468e6ebe28dfaef136309be.jpg', 6, 60, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (122, N'Samsung 980 Pro 2T', 4500000, N'NVMe Gen4 7000MB/s', N'https://m.media-amazon.com/images/I/61JkTXrgYxS._AC_.jpg', 6, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (123, N'WD SN850X 1TB', 2600000, N'Top gaming SSD', N'https://i5.walmartimages.com/seo/WD-BLACK-SN850X-NVMe-Internal-SSD-1TB-WDBB9G0010BNC-WRSN_6d5f0ab9-719a-42e8-b247-8a4d3e4d509f.226a6322abeb936ec9e5dd42458a085d.png', 6, 55, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (124, N'Crucial P3 Plus 1T', 1850000, N'Budget Gen4', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6509/6509715cv12d.jpg', 6, 100, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (125, N'Kingston NV2 500G', 950000, N'Entry NVMe', N'https://images.kabum.com.br/produtos/fotos/sync_mirakl/400945/SSD-Kingston-Nv2-500GB-M-2-2280-NVME-PCIE-4-0-X4-Leitura-3500MB-s-E-Grava-o-2100MB-s-Preto-Snv2s-500g_1732199474_gg.jpg', 6, 150, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (126, N'Samsung 870 EVO 1T', 2100000, N'Best SATA SSD', N'https://www.ssd1tb.com/wp-content/uploads/samsung-870-evo-1tb.jpg', 6, 80, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (127, N'P41 Platinum 2T', 5200000, N'Super Fast Gen4', N'https://m.media-amazon.com/images/I/71RGTZJJuqL.jpg', 6, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (128, N'Lexar NM790 2T', 3800000, N'Value Gen4 7400', N'https://cdn.mwave.com.au/images/400/lexar_nm790_2tb_pcie_40_nvme_m2_ssd_lnm790x002trnnng_ac67987_77928.jpg', 6, 45, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (129, N'Crucial T700 1TB', 5800000, N'Gen5 11700MB/s', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6544/6544913_sd.jpg', 6, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (130, N'Aorus Gen5 2TB', 9500000, N'Gen5 w/ Heatsink', N'https://cdn.mcc-jo.com/media/G6O8nomwymYdYRvEto1xZM1OlAH5n2PoshguCK3s.webp', 6, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (131, N'TeamGroup MP33 1T', 1400000, N'Budget NVMe', N'https://images.harlander.com/artikel/1000x1000/teamgroup-mp33-1tb-ssd-pcie-nvme-m2-2280-1.jpg', 6, 90, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (132, N'XPG S70 Blade 1T', 2200000, N'PS5 Gen4', N'https://webapi3.adata.com/storage/product/s70_blade_pk_1tb.png', 6, 65, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (133, N'SN580 1TB', 1700000, N'Reliable Gen4', N'https://www.titan-ice.co.za/images/detailed/50/wd-blue-sn580-nvme-ssd-1tb-flat.png.wdthumb.1280.1280.jpg', 6, 75, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (134, N'FireCuda 530 2TB', 5900000, N'High endurance', N'https://lagihitech.vn/wp-content/uploads/2022/02/SSD-Seagate-Firecuda-530-2TB-M.2-PCIe-Gen4x4-NVMe-ZP2000GM30013-hinh-1-1024x1024.jpg', 6, 18, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (135, N'Sabrent Rocket 4TB', 12500000, N'Huge capacity', N'https://m.media-amazon.com/images/I/71g-S-3aAjL._AC_.jpg', 6, 8, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (136, N'970 EVO Plus 2TB', 3900000, N'Gen3 King', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6347/6347286cv11d.jpg', 6, 30, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (137, N'PNY CS2241 1TB', 1600000, N'Budget Gen4', N'https://minipcreviewer.com/wp-content/uploads/2024/03/pny-cs2241-1tb-m2-nvme-gen4-x4-internal-solid-state-drive-ssd-m280cs2241-1tb-rb-1.jpg', 6, 50, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (138, N'Silicon Power UD90 1650000', 1650000, N'Gen4 Value', N'https://talospc.com/wp-content/uploads/2023/03/SILICON-POWER-UD90-1TB-700-1.jpg', 6, 60, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (139, N'MP600 Pro 2TB', 4800000, N'Optimized for PS5', N'https://os-jo.com/image/cache/catalog/products/Storage/Internal/CSSD-F2000GBMP600PRO/CSSD-F2000GBMP600PRO-1200x1200.jpg', 6, 22, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (140, N'KC3000 1TB', 2450000, N'Fast Gen4 OS', N'https://www.dateks.lv/images/pic/1200/1200/849/1083.jpg', 6, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (141, N'Crucial MX500 1TB', 1800000, N'SATA storage', N'https://down-mx.img.susercontent.com/file/sg-11134201-23020-nx5fq0gyrlnvc4', 6, 85, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (142, N'SN350 480GB', 850000, N'Cheap upgrade', N'https://static.ctonline.mx/imagenes/DDUWSD1690/DDUWSD1690_full.jpg', 6, 120, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (143, N'Spatium M480 2TB', 4600000, N'High-end MSI SSD', N'https://m.media-amazon.com/images/I/71KFqIt1KeL._AC_.jpg', 6, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (144, N'Transcend 250S 1T', 2100000, N'Gen4 with Cache', N'https://www.ucc.com.bd/image/cache/catalog/ssd/transcend/TS1TMTE250S-550x550.png.webp', 6, 35, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (145, N'Viper VP4300 2TB', 5400000, N'Dual heatsinks', N'https://gamex24.com/cdn/shop/files/718RcXesBSL.jpg?v=1765733754&width=1946', 6, 12, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (146, N'Lexar NM620 512G', 900000, N'Gen3 Budget', N'https://basitcomputers.com/wp-content/uploads/2023/01/LEXAR-NM620-512GB-2280-NVMe-M.2-SSD.jpg', 6, 100, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (147, N'Netac N7000 2TB', 3600000, N'Gen4 7000MB/s', N'https://m.media-amazon.com/images/I/71e5H77FI4L._AC_SL1500_.jpg', 6, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (148, N'870 QVO 4TB', 8500000, N'Massive SATA', N'https://www.discoazul.pt/uploads/media/images/disco-duro-ssd-samsung-870-qvo-4tb-sata-3-2-5-16.jpg', 6, 31, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (149, N'Adata SU650 240G', 450000, N'Cheapest SSD', N'https://img.pchome.com.tw/cs/items/DRAH0VA900HX1I5/000001_1727978028.jpg', 6, 200, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (150, N'Crucial T705 2TB', 10500000, N'Fastest Gen5', N'https://m.media-amazon.com/images/I/61kpTnvVd-L._AC_SL1500_.jpg', 6, 5, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (151, N'LG 27GR95QE', 22500000, N'27 OLED 240Hz', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6530/6530357_rd.jpg', 7, 12, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (152, N'Dell U2723QE', 14800000, N'27 4K IPS Black', N'https://i5.walmartimages.com/seo/Dell-27-60-Hz-IPS-Black-Technology-UHD-IPS-Monitor-8-ms-gray-to-gray-normal-5-ms-gray-to-gray-fast-3840-x-2160-4K-HDMI-DisplayPort-USB-Audio-Flat-Pan_da30d5dd-66cf-4f1f-a028-4807088fa3ac.85212000719ad54459b2996f8cc0f41d.jpeg', 7, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (153, N'VG249Q', 4200000, N'24 144Hz IPS', N'https://dlcdnimgs.asus.com/websites/global/products/mpppu3u01ux28nvt/images/section4-img.png', 7, 60, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (154, N'Odyssey Neo G8', 28000000, N'32 4K 240Hz', N'https://helios-i.mashable.com/imagery/articles/06t51rBTizAzYJbDiAL2LBN/images-2.fill.size_2000x1125.v1640943079.jpg', 7, 8, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (155, N'Gigabyte M27Q', 7800000, N'27 2K 170Hz', N'https://i5.walmartimages.com/seo/GIGABYTE-M27Q-X-27-IPS-Gaming-Monitor-QHD-2560x1440-240Hz-1ms-GTG-AMD-FreeSync-Premium-Type-C-KVM-HDMI-DP-Type-C-Height-Adjustable-Black_f3eb5f61-69ba-4e34-b036-cec12104f4ce.7073182e88b5c23aed1a2c2a254b8c81.jpeg', 7, 35, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (156, N'AOC 24G2', 3900000, N'Popular 144Hz', N'https://m.media-amazon.com/images/I/81NEMtk5qPL._AC_SL1500_.jpg', 7, 80, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (157, N'ViewSonic VX2728', 4500000, N'27 165Hz IPS', N'https://wise-tech.com.pk/wp-content/uploads/2024/04/VX2728-Side-View.png', 7, 50, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (158, N'MAG274QRF-QD', 10500000, N'2K Quantum Dot', N'https://asset.msi.com/resize/image/global/product/product_1698825055a998b04cad4f3a7146e1cbbd35fe08d1.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 7, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (159, N'AW3423DW', 32000000, N'34 QD-OLED', N'https://m.media-amazon.com/images/I/71ufV5NQ44L.jpg', 7, 5, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (160, N'BenQ SW271C', 42000000, N'Pro Color Photo', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6486/6486795cv1d.jpg', 7, 3, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (161, N'Samsung M7', 8200000, N'32 4K Smart', N'https://cdn.shopify.com/s/files/1/0003/7489/8743/products/475763-Product-0-I-637469188336243792_800x800_1e5000c4-7ea5-417f-b421-049ebc3f7781.jpg?v=1628488171', 7, 30, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (162, N'LG 24MP60G', 2900000, N'Budget 24 IPS', N'https://m.media-amazon.com/images/I/71Ud77qJvSL._SL1500_.jpg', 7, 100, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (163, N'Swift PG42UQ', 38000000, N'42 OLED 4K', N'https://www.gaming.gen.tr/wp-content/uploads/2023/05/asus-rog-swift-pg42uq-41-5-inc-138hz-0-1ms-uhd-adaptive-sync-oled-gaming-monitor-y.jpg', 7, 4, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (164, N'Gigabyte G24F 2', 4100000, N'24 180Hz OC', N'https://cdn.shopify.com/s/files/1/0355/8296/7943/products/1000_40_1600x.jpg?v=1665361714', 7, 70, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (165, N'HP Z27k G3', 15500000, N'4K Studio USB-C', N'https://mitosshoppers.com/wp-content/uploads/2026/01/2-19.jpg', 7, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (166, N'Nitro VG271U', 6500000, N'27 2K 144Hz', N'https://i5.walmartimages.com/seo/Acer-Nitro-VG271U-M3bmiipx-27-WQHD-2560-x-1440-IPS-Monitor-with-AMD-FreeSync-Premium-Technology_87dece16-0f5e-4d5f-9579-ae97d9169316.ab486d96a9e5254d8824bc11fb4f19a4.png', 7, 45, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (167, N'Dell S2721DGF', 9200000, N'Fast IPS 165Hz', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6421/6421624_sd.jpg', 7, 22, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (168, N'LG DualUp', 16000000, N'Square 16:18', N'https://www.lg.com/content/dam/channel/wcms/br/images/M02_mnt-dualup-ergo-28mq780-01-2-lg-dualup-monitor-ergo-mobile.jpg', 7, 10, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (169, N'Odyssey G5', 7200000, N'27 2K Curved', N'https://m.media-amazon.com/images/I/81GjQCXtXhL._AC_SL1500_.jpg', 7, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (170, N'Legion Y25-30', 6800000, N'24.5 240Hz', N'https://techacute.com/wp-content/uploads/2022/12/Lenovo-Legion-Y25-30-Gaming-Monitor-Tested-Out-Esports-Display-Review.jpg', 7, 25, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (171, N'ProArt PA278QV', 8900000, N'Color Accurate', N'https://dlcdnimgs.asus.com/websites/global/products/gvxnvsvumc3y1lyy/images/pic_true_beauty.png', 7, 18, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (172, N'HKC ANT27TQC', 5500000, N'Budget 2K Curved', N'https://doc-fd.zol-img.com.cn/t_s640x2000/g6/M00/0A/06/ChMkKmBZkIaIYkKIACPmpm8vrpYAAL71QN3WEcAI-a-654.png', 7, 55, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (173, N'MSI G2412', 3500000, N'Budget 170Hz', N'https://asset.msi.com/resize/image/global/product/product_16533746428fdd9ede10dbb55365e4d4267b978414.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 7, 90, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (174, N'Dell E2222H', 2200000, N'Office 22', N'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/peripherals/monitors/e-series/e2222h/media-gallery/monitors_e2222h_gallery_2.psd?fmt=png-alpha&pscan=auto&scl=1&hei=804&wid=1003&qlt=100,1&resMode=sharp2&size=1003,804&chrss=full', 7, 150, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (175, N'LG 29WP500', 5200000, N'29 UltraWide', N'https://c1.neweggimages.com/ProductImageCompressAll1280/24-026-192-V04.jpg', 7, 35, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (176, N'Philips 242E1', 3100000, N'Budget 144Hz', N'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/107/MTA-129724838/no-brand_no-brand_full01.jpg', 7, 80, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (177, N'AOC CU34G2X', 12500000, N'34 UW 144Hz', N'https://m.media-amazon.com/images/I/81GnQlNcf3L.jpg', 7, 15, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (178, N'Xeneon Flex', 45000000, N'Bendable OLED', N'https://www.royalsblue.com/wp-content/uploads/2022/08/1661532614_Corsair-announces-the-Xeneon-Flex-the-first-OLED-gaming-monitor.jpg', 7, 2, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (179, N'Zowie XL2546K', 13500000, N'Pro Esport 240Hz', N'https://brain-images-ssl.cdn.dixons.com/4/9/10218894/u_10218894.jpg', 7, 20, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (180, N'Xiaomi Mi 34', 9500000, N'34 2K UltraWide', N'https://ph-test-11.slatic.net/p/8642c1abe8e78d3a3f37b584614461b8.jpg', 7, 40, '4/6/2026 1:46:29 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (181, N'Intel Arc A770 Limited Edition GPU', 8356600, N'16GB GDDR6, 256-bit, 2100 MHz, 225W', N'https://m.media-amazon.com/images/I/71rzJRZ7lIL._AC_.jpg', 2, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (182, N'Intel Arc A750 Graphics Card', 6324600, N'8GB GDDR6, 256-bit, 2050 MHz, 225W', N'https://m.media-amazon.com/images/I/71sO2CZL1UL._AC_.jpg', 2, 49, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (183, N'Intel Arc A580 Graphics Card', 4546600, N'8GB GDDR6, 256-bit, 1700 MHz, 185W', N'https://www.notebookcheck.net/fileadmin/Notebooks/News/_nc3/Intel-Arc-A580-header.jpg', 2, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (184, N'AMD Radeon RX 7900 XT GPU', 22834600, N'20GB GDDR6, 80MB, 315W', N'https://m.media-amazon.com/images/I/81ZBhhO35mL._AC_.jpg', 2, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (185, N'AMD Radeon RX 7800 XT GPU', 12674600, N'16GB GDDR6, 64MB, 263W', N'https://m.media-amazon.com/images/I/71K6e37YltL._AC_.jpg', 2, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (186, N'AMD Ryzen 5 5600X Desktop Processor', 3784600, N'6, 12, AM4, 65W', N'https://www.amd.com/content/dam/amd/en/images/products/processors/ryzen/2505503-ryzen-5-5600x.jpg', 1, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (187, N'ASUS ROG Maximus Z790 Dark Hero', 17754600, N'LGA1700, Intel Z790, 4x DDR5 (Up to 192GB), ATX', N'https://dlcdnwebimgs.asus.com/gain/8E88DC59-A399-4385-8BCB-C3877F4EB746/w1000/h732', 5, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (188, N'ASUS ROG Strix X670E-E Gaming WiFi', 12674600, N'AM5, AMD X670E, PCIe 5.0, ATX', N'https://m.media-amazon.com/images/I/81ohPDfik0L.jpg', 5, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (189, N'ASUS ROG Strix GeForce RTX 4090 OC Edition', 50774600, N'24GB GDDR6X, 16384, PCIe 4.0', N'https://dlcdnwebimgs.asus.com/gain/2486AE38-B7C7-443A-9615-FD08D5430992/w1000/h732', 2, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (190, N'ASUS ROG Swift OLED PG32UCDM', 32994600, N'32-inch, 3840x2160 (4K), 240Hz, QD-OLED', N'https://rog.asus.com/media/1692603114505.jpg', 7, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (191, N'ASUS ROG Ryujin III 360 ARGB', 8864600, N'360mm, Asetek 8th Gen, 3.5-inch Full Color', N'https://static.nb.com.ar/i/nb_WATER-COOLER-ASUS-ROG-RYUJIN-III-360-ARGB-EXTREME_export_8a547ab1b93ed328764c69a3da19902e.png', 14, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (192, N'ASUS ROG Thor 1200W Platinum II', 8102600, N'1200W, 80 Plus Platinum, Full Modular, Real-time power draw', N'https://files.pccasegear.com/images/ROG-THOR-1200P2-GAMING-thumb.jpg', 12, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (193, N'MSI MEG Z790 GODLIKE MAX', 30454600, N'LGA1700, Intel Z790, 7x M.2 slots, M-Vision Dashboard', N'https://storage-asset.msi.com/global/picture/image/feature/mb/Z790/meg-z790-godlike-max/images/mb-godlike-max-02.png', 5, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (194, N'MSI MAG B650 TOMAHAWK WIFI', 5562600, N'AM5, AMD B650, DDR5 7600+(OC), Realtek 2.5Gbps LAN', N'https://storage-asset.msi.com/global/picture/image/feature/mb/B650/MAG-B650-TOMAHAWK-WIFI/mag-b650-tomahawk-wifi.png', 5, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (195, N'MSI GeForce RTX 4080 SUPER 16G GAMING X SLIM', 26644600, N'16GB GDDR6X, TRI FROZR 3, 2625 MHz', N'https://storage-asset.msi.com/global/picture/image/feature/vga/NVIDIA/4080-Gaming/RTX-4080-Gaming-X-Slim-16G/images/msi-4080-gaming-x-slim-16g-in-desktop-01.jpg', 2, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (196, N'MSI MPG 271QRX QD-OLED', 20294600, N'27-inch, 2560x1440 (2K), 360Hz, 0.03ms (GtG)', N'https://www.bhphotovideo.com/images/images2500x2500/msi_mpg_271qrx_qd_oled_27_wqhd_oled_16_9_1808681.jpg', 7, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (197, N'MSI MEG MAESTRO 700L PZ', 10642600, N'ATX Full Tower, Curved Tempered Glass, Back-connect (Project Zero) support', N'https://storage-asset.msi.com/global/picture/image/feature/PC-Case/MEG-MAESTRO-700L-PZ/meg-maestro-700l-pz-connect-pd.png', 13, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (198, N'MSI MAG CORELIQUID I360', 3530600, N'360mm, ARGB Fans, Infinite Mirror IPS Style Design', N'https://cdn.mwave.com.au/images/400/msi_mag_coreliquid_i360_360mm_argb_aio_liquid_cpu_cooler_black_ac79069_96031.jpg', 14, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (199, N'MSI SPATIUM M570 PCIe 5.0 NVMe M.2 HS', 7594600, N'2TB, Up to 12400 MB/s, Up to 11800 MB/s', N'https://asset.msi.com/resize/image/global/product/product_167573935424940aba56cd1dba801846447d621bb2.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 6, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (200, N'Gigabyte Z790 AORUS XTREME X', 25374600, N'LGA1700, 24+1+2 Phases, Wi-Fi 7, PCIe 5.0 x16', N'https://static.gigabyte.com/StaticFile/Image/Global/dee0b0bef844f7dcac99c3569fdf02c8/Product/36669/Png', 5, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (201, N'Gigabyte X670E AORUS MASTER', 11404600, N'AM5, AMD X670E, 4x M.2 PCIe 5.0, Intel 2.5GbE LAN', N'https://c1.neweggimages.com/ProductImageCompressAll1280/13-145-405-01.jpg', 5, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (202, N'Gigabyte M27Q Gaming Monitor', 7594600, N'27-inch, Super Speed IPS, 2560x1440, 170Hz', N'https://i5.walmartimages.com/seo/GIGABYTE-M27Q-X-27-IPS-Gaming-Monitor-QHD-2560x1440-240Hz-1ms-GTG-AMD-FreeSync-Premium-Type-C-KVM-HDMI-DP-Type-C-Height-Adjustable-Black_f3eb5f61-69ba-4e34-b036-cec12104f4ce.7073182e88b5c23aed1a2c2a254b8c81.jpeg', 7, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (203, N'Gigabyte AORUS FO32U2P', 30454600, N'32-inch, OLED (QD-OLED), 3840x2160, DP 2.1 UHBR20 supported', N'https://m.media-amazon.com/images/I/71M5qy2eL0L._AC_.jpg', 7, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (204, N'Gigabyte AORUS Gen5 12000 SSD 2TB', 8102600, N'PCIe 5.0 x4, NVMe 2.0, 12,400 MB/s, 11,800 MB/s', N'https://gzhls.at/pix/0c/eb/0ceb8457e76f2dda-n.webp', 6, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (205, N'Gigabyte UD1000GM PG5 (Rev 2.0)', 4038600, N'1000W, PCIe Gen 5.0 (12VHPWR), 80 PLUS Gold', N'https://cdn.cclonline.com/cdn-cgi/image/width=2000/images/shopblocks/UD1000GM%20PG5-05.png', 12, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (206, N'Gigabyte AORUS C500 GLASS', 4546600, N'Mid Tower, 4mm Tempered Glass, Up to 420mm front', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/2156/innergigabyteimages/utility-img-1.jpg', 13, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (207, N'Corsair Dominator Titanium RGB DDR5 32GB (2x16GB)6000MHz', 4673600, N'32GB, 6000 MT/s, CL30, Intel XMP 3.0 / AMD EXPO', N'https://www.gaming.gen.tr/wp-content/uploads/2023/10/corsair-dominator-titanium-rgb-32gb-2x16gb-6000mhz-cl30-ddr5-ram-cmp32gx5m2b6000z30.jpg', 3, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (208, N'Corsair Vengeance RGB DDR5 64GB (2x32GB)5600MHz', 5562600, N'64GB, 5600 MT/s, CL40', N'https://nvs.tn-cdn.net/2025/07/ram-corsair-vengeance-rgb-64gb-2x32gb-ddr5-5600mhz-cmh64gx5m2b5600c40w-3.jpg', 3, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (209, N'Corsair iCUE LINK H150i LCD Liquid CPU Cooler', 7340600, N'360mm, 3x QX120 RGB Fans, 2.1-inch IPS Display, iCUE LINK Ecosystem', N'https://m.media-amazon.com/images/I/71vkSfGTdXL._AC_.jpg', 14, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (210, N'Corsair 5000D AIRFLOW Tempered Glass Mid-Tower', 4165600, N'Mid-Tower, Black, RapidRoute System, Up to 10x 120mm fans', N'https://cwsmgmt.corsair.com/pdp/5000-series/images/5000d-af-clear-clean-cool.png', 13, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (211, N'Corsair iCUE LINK 6500X RGB Mid-Tower DualChamber', 5054600, N'Dual Chamber Layout, Reverse-connector support, Front & Side Tempered Glass', N'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Cases/6500/CC-9011269-WW/Gallery/6500X_RGB_BLACK_RENDER_01.webp', 13, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (212, N'Corsair RM1000x Shift Fully Modular ATX PSU', 5308600, N'1000W, 80 PLUS Gold, Side-mounted modular connections, ATX 3.0 & PCIe 5.0 ready', N'https://m.media-amazon.com/images/I/81dwGXVwpgL.jpg', 12, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (213, N'Corsair AX1600i Digital ATX Power Supply', 15468600, N'1600W, 80 PLUS Titanium, Gallium Nitride (GaN) FETs', N'https://www.e-weekly.co.uk/Images/JohnMac/Corsair/CSR-AX160I/Images/AX1600i_03.jpg', 12, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (214, N'Corsair K100 RGB Mechanical Gaming Keyboard', 6324600, N'Corsair OPX Optical-Mechanical, AXON 4000Hz Hyper-polling, iCUE Control Wheel', N'https://assets.corsair.com/image/upload/f_auto,q_auto/v1682360586/akamai/pdp/k100/v2/dist/app-static/assets/images/smal-pp-keyboard.jpg', 16, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (215, N'Corsair Darkstar Wireless MMO Gaming Mouse', 4292600, N'15 programmable buttons, MARKSMAN 26K DPI Optical, SLIPSTREAM Wireless & Bluetooth', N'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Gaming-Mice/CH-931A011/DARKSTAR_WIRELESS_01.webp', 17, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (216, N'Corsair Virtuoso RGB Wireless XT Headset', 6832600, N'High-Density 50mm Neodymium, Spatial Dolby Atmos, Broadcast-grade detachable mic', N'https://assets.corsair.com/image/upload/c_pad,q_85,h_1100,w_1100,f_auto/products/Gaming-Headsets/CA-9011188-EU/Gallery/VIRTUOSO_XT_01.webp', 18, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (217, N'Logitech G Pro X Superlight 2 Wireless GamingMouse', 4038600, N'60 grams, HERO 2 Sensor (32,000 DPI), LIGHTFORCE Hybrid Switches, 4000Hz max polling', N'https://techubme.com/wp-content/uploads/2024/07/logitech_Pro_X_Super_light_2.png', 17, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (218, N'Logitech G502 X LIGHTSPEED Wireless GamingMouse', 3530600, N'HERO 25K Sensor, 13 programmable controls, Dual-mode infinite scroll', N'https://www.bhphotovideo.com/images/images1500x1500/logitech_g_910_006178_g502_x_lightspeed_wireless_1722687.jpg', 17, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (219, N'Logitech G915 TKL Wireless Mechanical Keyboard', 5816600, N'Tenkeyless (TKL), Low Profile GL Tactile/Linear/Clicky, Up to 40 hours (100% brightness)', N'https://resource.logitechg.com/d_transparent.gif/content/dam/gaming/en/products/g915-tkl/g915-tkl-gallery-1-carbon.png', 16, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (220, N'Logitech G Pro X TKL LIGHTSPEED Gaming Keyboard', 5054600, N'Dual-shot PBT keycaps, LIGHTSPEED Wireless, Bluetooth, USB, Dedicated volume roller and controls', N'https://www.enation.sg/wp-content/uploads/2025/06/251.png', 16, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (221, N'Logitech G Pro X 2 LIGHTSPEED Wireless Headset', 6324600, N'50mm Graphene Drivers, LIGHTSPEED, Bluetooth, 3.5mm wired, Up to 50 hours battery life', N'https://www.bhphotovideo.com/images/images1500x1500/logitech_g_981_001262_pro_x_2_wireless_1763226.jpg', 18, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (222, N'Logitech MX Master 3S Wireless Mouse', 2514600, N'8K DPI tracking on any surface, Quiet clicks technology, MagSpeed Electromagnetic scrolling', N'https://m.media-amazon.com/images/I/61+OT7FPABL._AC_SL1500_.jpg', 17, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (223, N'Logitech MX Keys S Wireless Keyboard', 2768600, N'Spherically-dished Perfect Stroke keys, Smart illumination proximity sensor, Easy-Switch up to 3 devices', N'https://www.dc3.co.za/wp-content/uploads/920-011587-1.webp', 16, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (224, N'Razer Viper V3 Pro Wireless Gaming Mouse', 4038600, N'54 grams, Focus Pro 35K Optical Sensor Gen-2, True 8000Hz HyperPolling Wireless', N'https://m.media-amazon.com/images/I/619xpFKAXPL.jpg', 17, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (225, N'Razer DeathAdder V3 Pro Wireless Gaming Mouse', 3784600, N'63 grams, Right-handed ergonomic design, Focus Pro 30K Optical Sensor', N'https://wise-tech.com.pk/wp-content/uploads/2023/07/Razer-DeathAdder-V3-Pro-Ergonomic-Gaming-Mouse-White.png', 17, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (226, N'Razer Huntsman V3 Pro TKL Mechanical Keyboard', 5562600, N'Razer Analog Optical Switches Gen-2, Rapid Trigger mode with adjustable actuation (0.1- 4.0mm), Dual-purpose digital dial', N'https://m.media-amazon.com/images/I/81gJ6jkk3jL._AC_.jpg', 16, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (227, N'Razer BlackWidow V4 Pro Mechanical GamingKeyboard', 5816600, N'Razer Green Clicky / Yellow Linear Switches, Per-key & 3-sided underglow RGB, 8 dedicated macro keys', N'https://m.media-amazon.com/images/I/81L4FpeS3VL._AC_SL1500_.jpg', 16, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (228, N'Razer BlackShark V2 Pro (2023 Edition) WirelessHeadset', 5054600, N'Razer HyperClear Super Wideband Mic, TriForce Titanium 50mm Drivers, Up to 70 hours', N'https://images-na.ssl-images-amazon.com/images/I/71Z9KK9-zvL.jpg', 18, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (229, N'Samsung 990 PRO PCIe 4.0 NVMe M.2 SSD 2TB', 4546600, N'2TB, Up to 7450 MB/s, Up to 6900 MB/s, Samsung Pascal Controller', N'https://images.samsung.com/is/image/samsung/p6pim/ca_fr/mz-v9p2t0b-am/gallery/ca-fr-990pro-nvme-m2-ssd-mz-v9p2t0b-am-534208574?$650_519_PNG$', 6, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (230, N'Samsung 990 EVO PCIe 4.0 x4 / 5.0 x2 M.2 SSD 1TB', 2260600, N'1TB, Up to 5000 MB/s, Up to 4200 MB/s', N'https://images.samsung.com/is/image/samsung/p6pim/ca/mz-v9e1t0b-am/gallery/ca-990-evo-nvme-m2-ssd-mz-v9e1t0b-am-539584186?$650_519_PNG$', 6, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (231, N'Samsung T7 Shield Portable SSD 2TB', 4292600, N'2TB, USB 3.2 Gen 2 (10Gbps), IP65 water & dust resistant, 3-meter drop proof', N'https://down-ph.img.susercontent.com/file/sg-11134275-7rd6w-m7rcerx9s5nrbc', 6, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (232, N'Samsung Odyssey OLED G9 (G95SC) Gaming Monitor', 40614600, N'49-inch Curved Ultra-wide, 5120x1440 (Dual QHD), 240Hz, 0.03ms (GtG)', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/865cf1ba-8917-48bf-b4e7-31c5e5f8427c.jpg', 7, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (233, N'Samsung Odyssey Ark Gen 2 Mini-LED Monitor', 63474600, N'55-inch 1000R Curved, 3840x2160 (4K), 165Hz, Yes, rotates vertically', N'https://images-na.ssl-images-amazon.com/images/I/81nwxTmzMRL.jpg', 7, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (234, N'Samsung Galaxy Buds3 Pro', 6324600, N'Hi-Fi 24-bit Ultra High Quality Audio, Adaptive Noise Cancelling with Blade Lights, Stem style ergonomic fit', N'https://www.pricekeeda.com/uploads/product/57686/samsung-galaxy-buds-3-pro6a6a36fbe503e.jpg', 18, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (235, N'Kingston FURY Renegade DDR5 RGB 32GB (2x16GB) 7200MHz', 4292600, N'32GB Kit, 7200 MT/s, CL38-44-44, 1.45V', N'https://img.evetech.co.za/repository/ProductImages/kingston-fury-renegade-rgb-32gb-7200mhz-ddr5-black-memory-1600px-v1-01.webp', 3, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (236, N'Kingston FURY Beast DDR5 32GB (2x16GB) 6000MHz', 3022600, N'32GB Kit, 6000 MT/s, AMD EXPO / Intel XMP 3.0 certified', N'https://m.media-amazon.com/images/I/717cPftxQgL._AC_.jpg', 3, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (237, N'Kingston KC3000 PCIe 4.0 NVMe M.2 SSD 2TB', 3911600, N'2TB, Up to 7000 MB/s, Up to 7000 MB/s, Phison E18', N'https://www.onoff.az/storage/uploads/products/onoff-2026-01-15t231256269-32101.jpg', 6, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (238, N'Kingston NV2 PCIe 4.0 NVMe M.2 SSD 1TB', 1625600, N'1TB, Up to 3500 MB/s, Up to 2100 MB/s, M.2 2280', N'https://images.kabum.com.br/produtos/fotos/sync_mirakl/400812/SSD-1TB-Kingston-Nv2-M-2-2280-PCIe-NVMe-Leitura-3500MB-s-Grava-o-2100MB-s-Snv2s-1000g_1730146919_gg.jpg', 6, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (239, N'Kingston FURY Impact DDR5 SO-DIMM 32GB (2x16GB) 5600MHz', 3149600, N'Laptop Memory (SO-DIMM), 32GB Kit, 5600 MT/s', N'http://extra.md/public/products/thumbs/205027_32gb-ddr55600mhz-sodimm-kingston-fury-impact-9857901454477.jpg', 3, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (240, N'WD Red Pro NAS Internal Hard Drive 12TB', 7594600, N'12TB, 7200 RPM, 256MB, SATA 6 Gb/s', N'https://c1.neweggimages.com/ProductImage/22-234-375-01.png', 11, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (241, N'Seagate IronWolf Pro 16TB NAS HDD', 8356600, N'16TB, 550TB/year, Rotational Vibration (RV) sensors', N'https://www.bhphotovideo.com/images/fb/seagate_st16000nt001_16tb_ironwolf_pro_7200_1760984.jpg', 11, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (242, N'Noctua NH-D15 chromax.black Dual-Tower Cooler', 3022600, N'2x NF-A15 HS-PWM fans, Full black design, Intel LGA1700/AM5 ready', N'https://os-jo.com/image/cache/catalog/products/ANOCTUA/NH-D15-BLACK/BLACK-1200x1200.JPEG', 14, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (243, N'NZXT H9 Flow Dual-Chamber Mid-Tower', 4038600, N'Wrap-around tempered glass pane, 4x F120Q Airflow fans, Up to 435mm', N'https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6529/6529623cv11d.jpg', 13, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (244, N'NZXT Kraken Elite 360 RGB Liquid Cooler', 7594600, N'360mm aluminum radiator, 2.36-inch wide-angle TFT-LCD display, 640x640 pixels', N'https://img.terabyteshop.com.br/produto/g/water-cooler-nzxt-kraken-elite-360-rgb-360mm-aio-lcd-display-black-intel-amd-rl-kr36e-b1_191056.jpg', 14, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (245, N'SteelSeries Arctis Nova Pro Wireless Headset', 8864600, N'Nova Pro Acoustic System, Active Noise Cancellation with Transparency Mode, Dual Battery Infinity System', N'https://images.hometheaterreview.com/htr-stateless/2025/07/646a3e4a-steelseries-arctis-nova-pro-wireless-gaming-headset-scaled.jpg', 18, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (246, N'BenQ ZOWIE XL2566K 360Hz Esports Gaming Monitor', 15214600, N'24.5-inch TN Panel, 360Hz, DyAc+ Technology motion blur reduction', N'https://i5.walmartimages.com/seo/BenQ-Zowie-XL2566K-24-5-Full-HD-LED-Gaming-LCD-Monitor-16-9-Dark-Gray-25-Class-Twisted-nematic-TN-1920-x-1080-360-Hz-Refresh-Rate-HDMI-VGA_32328961-779f-43fb-a23d-fb7b19ecd928.af62677c5cd0ab4869b62b7f1893f8ea.jpeg', 7, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (247, N'Sony WH-1000XM5 Wireless Noise CancelingHeadphones', 10134600, N'Integrated Processor V1 & HD Noise CancelingProcessor QN1, 8 microphones for extreme voice pick up, Up to 30 hours total life', N'https://d1ncau8tqf99kp.cloudfront.net/converted/103364_original_local_1200x1050_v3_converted.webp', 18, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (248, N'Crucial Pro DDR5 48GB (2x24GB) 5600MHz Kit', 3784600, N'48GB Kit, 5600 MT/s, Low-profile aluminum black heatsink', N'https://a.allegroimg.com/original/116f3d/93c9c04d46c29c03260e9a12823a/SUPER-Pamiec-DDR5-Crucial-Pro-48GB-2x24GB-5600MHz-XMP-3-0-AMD-EXPO', 3, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (249, N'Fractal Design North Charcoal Black WoodMid-Tower', 3530600, N'Real walnut wood front panel struts, Mesh or Tempered Glass available, 2x Aspect 14 PWM fans', N'https://m.media-amazon.com/images/I/71MSloBQcCL._AC_.jpg', 13, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (250, N'Lian Li O11 Dynamic EVO RGB Black', 4292600, N'Dual-chamber adjustable ATX case, Two L-shaped diffuse LED RGB strips, Reversible design architecture', N'https://gitec.ge/images/thumbs/0073589_g99o11dergbx00.jpeg', 13, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (251, N'Lian Li UNI FAN TL LCD 120 Triple Pack Black', 3784600, N'120mm fans, Built-in 1.6-inch LCD screen on center fan, Daisy-chain interlocking mechanism', N'https://microless.com/cdn/products/01a0bf24eea1fcdb39621ce8e43485f5-hi.jpg', 15, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (252, N'EVGA SuperNOVA 1000 G7 Gold Modular PSU', 4800600, N'1000W, 80 PLUS Gold Certified, Ultra-compact 130mm chassis size', N'https://avaxos.com/wp-content/uploads/2022/12/EVGA-SuperNOVA-1000-G7-220-G7-1000-X1-1000-W-ATX12V-EPS12V-SLI-CrossFire-80-PLUS-GOLD-Certified-Full-Modular-Active-PFC-Power-Supply-main.jpg', 12, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (253, N'DeepCool AK620 Digital Dual-Tower Air Cooler', 2006600, N'Real-time temperature and usage status top screen, 2x FK120 fluid dynamic bearing fans, 6x 6mm copper heatpipes', N'https://down-my.img.susercontent.com/file/cn-11134207-7qukw-lfqke8nuk8jva1', 14, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (254, N'Thermalright Peerless Assassin 120 SE AirCooler', 990600, N'Dual tower heatsink design, 2x TL-C12C 120mm PWM fans, 155mm standard height', N'https://media.ldlc.com/r1600/ld/products/00/06/08/36/LD0006083698.jpg', 14, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (255, N'Be Quiet! Dark Power 13 1000W Titanium ATX 3.0PSU', 7340600, N'1000W, 80 PLUS Titanium (up to 95.8%), Frameless Silent Wings fan optimization', N'https://hwbusters.com/wp-content/uploads/2023/05/be-quiet-Dark-Power-13-1000W.jpg', 12, 50, '6/5/2026 10:05:55 AM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (256, N'Intel Core Ultra 7 265F (Tray)', 12000000, N'TDP: 125W', N'https://med.greatecno.com/1526371-large_default/intel-s1851-core-ultra-7-265f-tray.jpg', 1, 97, '6/27/2026 12:52:49 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (257, N'Intel Core i5 12400F / 2.5GHz Turbo 4.4GHz (TRAY) - CHÍNH HÃNG', 2500000, N'TDP: 65W', N'https://cdn.hstatic.net/products/200000837185/12400f_tray_e59465bf117e4e778e5f568c39bc32b9_grande.png', 1, 100, '6/27/2026 12:52:50 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (258, N'Intel Core i7 14700F (Tray)', 9500000, N'TDP: 65W', N'https://zicomputer.com/wp-content/uploads/2026/01/14700f-Tray-768x768.png', 1, 100, '6/27/2026 12:52:50 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (259, N'GIGABYTE Z890 EAGLE WIFI7 (DDR5)', 7500000, N'TDP: 40W', N'https://m.media-amazon.com/images/I/81G2my+RKeL._AC_.jpg', 5, 97, '6/27/2026 12:52:50 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (260, N'GIGABYTE H610M-H V3 (DDR4)', 1800000, N'TDP: 30W', N'https://media.ldlc.com/r1600/ld/products/00/06/12/72/LD0006127276.jpg', 5, 100, '6/27/2026 12:52:51 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (261, N'GIGABYTE B760M GAMING PLUS WIFI DDR4', 3500000, N'TDP: 40W', N'https://m.media-amazon.com/images/I/81pSTc-GhVL._AC_SL1500_.jpg', 5, 100, '6/27/2026 12:52:51 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (262, N'RAM Kingmax Horizon 16GB DDR5 Bus 5600Mhz', 1200000, N'TDP: 10W', N'https://cdn.hstatic.net/products/1000361104/1_9aef94b8600b4a80a74401e379b2dd4c.jpg', 3, 97, '6/27/2026 12:52:52 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (263, N'Ram KingSpec Heatsink Red 1x16GB DDR4 Bus 3200Mhz', 750000, N'TDP: 10W', N'https://cdn.hstatic.net/products/200000722513/ram-kingspec-heatsink-red-1x16gb-ddr4-bus-3200mhz-1_23edecb668f84ae783d00d77d8a23b83.jpg', 3, 100, '6/27/2026 12:52:52 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (264, N'MSI GeForce RTX 5070 Ti 16GB Shadow 3X OC', 25000000, N'TDP: 250W', N'https://m.media-amazon.com/images/I/71bmZxrahrL._AC_SL1500_.jpg', 10, 99, '6/27/2026 12:52:53 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (265, N'GIGABYTE GeForce RTX 5080 WINDFORCE OC SFF 16G', 35000000, N'TDP: 300W', N'https://www.gigabyte.com/FileUpload/Global/KeyFeature/3886/innergigabyte/images/features-img.png', 10, 98, '6/27/2026 12:52:53 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (266, N'MSI GeForce RTX 5060 Ventus 2X OC 8GB', 8500000, N'TDP: 150W', N'https://asset.msi.com/resize/image/global/product/product_17452877802adc1ee82075afaeea7d2a2dcf366cb9.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 10, 100, '6/27/2026 12:52:54 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (267, N'ZOTAC GeForce RTX 5060 Ti 8GB TWIN EDGE GDDR7', 11000000, N'TDP: 160W', N'https://www.kccshop.vn/media/product/250-13410-vga-zotac-gaming-geforce-rtx-5060-ti-8gb-twin-edge-oc-white-edition--zt-b50610q-10m-_4_main.jpeg', 10, 100, '6/27/2026 12:52:54 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (268, N'Ổ cứng SSD Kingston NV3 1TB M.2 PCIe NVMe Gen4', 1800000, N'TDP: 10W', N'https://m.media-amazon.com/images/I/71ZnK38jZzL.jpg', 8, 97, '6/27/2026 12:52:55 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (269, N'Ổ Cứng SSD KingSpec NVMe 512GB (NE-512)', 800000, N'TDP: 10W', N'https://hmpcstore.com/admin/uploads/O-cung-SSD-KingSpec-NE-512GB-PCIe-Gen3-x4-NVMe-M2-2280-NE-512/20260225_101548_0_699e696480d03_710__ne-5122-1__1__8d84d40669de4ec497acc541f607579f_grande.jpg', 8, 100, '6/27/2026 12:52:55 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (270, N'Corsair RM850e ATX 3.1 - 80 Plus Gold - Full Modular (850W)', 3500000, N'TDP: 0W', N'https://product.hstatic.net/200000722513/product/89689_nguon_may_tinh_corsair_rm850e_atx_006_e59a3ebce3034f23aa2bde43f1d242e5_1024x1024.jpg', 12, 97, '6/27/2026 12:52:56 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (271, N'Cooler Master MWE 650 - 80 Plus Bronze - V3 230V (650W)', 1500000, N'TDP: 0W', N'https://os-jo.com/image/cache/catalog/products/power-supply/MPE-6501-ACAAW-3BUK/81TVrRqQJeL._SL1500_-1200x1200.jpg', 12, 100, '6/27/2026 12:52:56 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (272, N'Nguồn FSP HV PRO 650W - 80 Plus Bronze', 1400000, N'TDP: 0W', N'https://down-vn.img.susercontent.com/file/vn-11134211-820l4-mjf8qo64x91ha6', 12, 100, '6/27/2026 12:52:57 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (273, N'Corsair CX650 - 80 Plus Bronze (650W)', 1600000, N'TDP: 0W', N'https://www.bhphotovideo.com/images/fb/corsair_cp_9020278_na_cx_series_cx650_650w_1808744.jpg', 12, 100, '6/27/2026 12:52:57 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (274, N'Corsair 3500X TG Mid Tower Black', 2000000, N'TDP: 0W', N'https://product.hstatic.net/200000722513/product/3500x_link_blk_01_85b56174d9994a4f8db95482a0b9245f.png', 13, 99, '6/27/2026 12:52:58 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (275, N'Corsair FRAME 4500X RS-R ARGB Panoramic Black', 3500000, N'TDP: 0W', N'https://www.pcstudio.in/wp-content/uploads/2025/09/Corsair-Frame-4500X-RS-R-ARGB-Panoramic-Glass-Mid-Tower-E-ATX-Cabinet-Black-2-600x600.webp', 13, 98, '6/27/2026 12:52:58 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (276, N'Tản nhiệt AIO Corsair NAUTILUS 360 ARGB Black', 2800000, N'TDP: 15W', N'https://phucanhcdn.com/media/product/58804_tan_nhiet_nuoc_aio_corsair_nautilus_360_argb_black_cw_9060093_ww_2.jpg', 9, 97, '6/27/2026 12:52:59 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (277, N'Cooler Master Hyper 212 Spectrum V3 ARGB', 600000, N'TDP: 5W', N'https://m.media-amazon.com/images/I/71gBjYy2vfL._SL1500_.jpg', 9, 99, '6/27/2026 12:52:59 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (278, N'Intel Core i9 14900K (Tray)', 14000000, N'TDP: 125W', N'https://pcngon.vn/wp-content/uploads/2024/11/CPU-Intel-Core-i9-14900K-Tray-2.4GHz-Turbo-5.8GHz-24-nhan-32-luong-1.jpg', 1, 100, '6/27/2026 1:16:14 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (279, N'Intel Core Ultra 9 285K', 16500000, N'TDP: 125W', N'https://www.techpowerup.com/review/intel-core-ultra-9-285k/images/package.jpg', 1, 50, '6/27/2026 1:16:14 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (280, N'ASUS ROG MAXIMUS Z790 HERO', 15000000, N'TDP: 60W', N'https://dlcdnwebimgs.asus.com/gain/A3777166-EF70-4D33-915B-EC65CF77CAE5', 5, 100, '6/27/2026 1:16:16 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (281, N'ProArt Z790-CREATOR WIFI', 12000000, N'TDP: 55W', N'https://dlcdnwebimgs.asus.com/gain/fe64f38f-9f58-4722-b2b0-723379b316be/', 5, 100, '6/27/2026 1:16:16 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (282, N'Corsair Dominator Titanium 64GB', 6500000, N'TDP: 15W', N'https://m.media-amazon.com/images/I/611o1NX2HvL._AC_SL1500_.jpg', 3, 100, '6/27/2026 1:16:18 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (283, N'G.Skill Trident Z5 64GB DDR5', 5500000, N'TDP: 15W', N'https://c1.neweggimages.com/ProductImageCompressAll1280/20-374-432-07.png', 3, 100, '6/27/2026 1:16:18 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (284, N'ASUS ROG Strix RTX 5090 24GB', 65000000, N'TDP: 450W', N'https://cdn-ru.bitrix24.ru/b11322588/landing/90e/90ed69e925e824a07ca15eb1b5d9bc42/asus_rog_astral_geforce_rtx_5090_32gb_gddr7_oc_edition_16_1x.png', 10, 100, '6/27/2026 1:16:33 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (285, N'Samsung 990 PRO 2TB', 4500000, N'TDP: 15W', N'https://images.samsung.com/is/image/samsung/p6pim/ca_fr/mz-v9p2t0b-am/gallery/ca-fr-990pro-nvme-m2-ssd-mz-v9p2t0b-am-534208574?$650_519_PNG$', 8, 100, '6/27/2026 1:16:34 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (286, N'ROG Ryujin III 360 ARGB', 8500000, N'TDP: 20W', N'https://static.nb.com.ar/i/nb_WATER-COOLER-ASUS-ROG-RYUJIN-III-360-ARGB-EXTREME_export_8a547ab1b93ed328764c69a3da19902e.png', 9, 109, '6/27/2026 1:16:36 PM', NULL);
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (287, N'Thẻ nhớ SanDisk Extreme Pro 128GB MicroSDXC UHS-I 200MB/s', 650000, N'TDP: 2W', N'https://bizweb.dktcdn.net/100/533/247/products/1658758849-1692696.jpg?v=1754561963193', 4, 100, '7/23/2026 10:00:00 AM', N'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (288, N'Thẻ nhớ Samsung PRO Plus 256GB MicroSDXC kèm Đầu đọc USB', 950000, N'TDP: 2W', N'https://bizweb.dktcdn.net/thumb/grande/100/490/762/products/the-nho-microsdxc-samsung-pro-plus-u3-256gb-05-jpg-v-1715014985150-jpg-v-1715201603263.jpg?v=1716191494470', 4, 80, '7/23/2026 10:00:00 AM', N'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (289, N'Thẻ nhớ Lexar Professional 1066x 512GB MicroSDXC UHS-I', 1450000, N'TDP: 3W', N'https://bizweb.dktcdn.net/thumb/grande/100/410/941/products/76-8b907773-3ff2-4428-8d53-14023cd3a1ad.jpg?v=1747886462133', 4, 50, '7/23/2026 10:00:00 AM', N'Lexar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (290, N'Thẻ nhớ Kingston Canvas Go! Plus 128GB SDXC UHS-I', 580000, N'TDP: 2W', N'https://m.media-amazon.com/images/I/613WVdJQi4L._AC_SL1500_.jpg', 4, 120, '7/23/2026 10:00:00 AM', N'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (291, N'Thẻ nhớ SanDisk Ultra SDXC 64GB 140MB/s Class 10', 280000, N'TDP: 1W', N'https://bizweb.dktcdn.net/100/513/826/products/web-bia-the-sd-trang-xam-64gb.png?v=1767153744330', 4, 150, '7/23/2026 10:00:00 AM', N'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (292, N'Thẻ nhớ Transcend SDXC 330S 128GB High Speed 100MB/s', 520000, N'TDP: 2W', N'https://www.ryans.com/storage/products/main/transcend-330s-sdxc-128gb-uhs-i-u3v30-sd-card-11598097033.webp', 4, 90, '7/23/2026 10:00:00 AM', N'Transcend');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (293, N'Thẻ nhớ ProGrade Digital SDXC UHS-II V60 256GB', 2800000, N'TDP: 3W', N'https://haliti.com.vn/wp-content/uploads/2023/05/the-nho-prograde-digital-SDXC-UHS-II-V60-250R-256gb-haliti-01.jpg', 4, 30, '7/23/2026 10:00:00 AM', N'ProGrade');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (294, N'Thẻ nhớ Sony TOUGH SF-G Series 128GB SDXC UHS-II 300MB/s', 4200000, N'TDP: 3W', N'https://cdn.vjshop.vn/phu-kien-nhiep-anh/the-nho/the-sd/the-nho-sony-sdxc-128gb-sf-g-series-tough-uhs-ii/sony-sdxc-128gb-sf-g-series-tough-uhs-ii.jpg', 4, 25, '7/23/2026 10:00:00 AM', N'Sony');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (295, N'Thẻ nhớ Kioxia Exceria High Endurance 128GB MicroSD', 480000, N'TDP: 2W', N'https://down-vn.img.susercontent.com/file/7c27727c494736672bf44eba923860dd', 4, 110, '7/23/2026 10:00:00 AM', N'Kioxia');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (296, N'Thẻ nhớ TeamGroup GO Card MicroSDXC 256GB 100MB/s', 720000, N'TDP: 2W', N'https://images.teamgroupinc.com/products/card/microsd/go-card/msdxc/256gb_adpt_01.jpg', 4, 75, '7/23/2026 10:00:00 AM', N'TeamGroup');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (297, N'Ổ cứng di động SSD SanDisk Extreme Portable 1TB USB 3.2 Gen 2', 2650000, N'TDP: 5W', N'https://cdn.tgdd.vn/Products/Images/1902/328432/o-cung-ssd-1tb-sandisk-extreme-portable-sdssde61-thumb-1-1-600x600.jpg', 8, 60, '7/23/2026 10:00:00 AM', N'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (298, N'Ổ cứng di động Samsung T7 Shield 2TB Type-C Chống sốc IP65', 4850000, N'TDP: 5W', N'https://media.karousell.com/media/photos/products/2023/10/20/samsung_t7_shield_2tb_beige_co_1697782299_2da3fdf9.jpg', 8, 45, '7/23/2026 10:00:00 AM', N'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (299, N'Ổ cứng di động HDD WD My Passport 2TB USB 3.0 Black', 1950000, N'TDP: 5W', N'https://atechworld.vn/wp-content/uploads/2024/01/wd-my-passport-2tb-1-1.jpg', 8, 80, '7/23/2026 10:00:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (300, N'Ổ cứng di động SSD Crucial X9 Pro 1TB 1050MB/s Vỏ nhôm', 2450000, N'TDP: 4W', N'https://tuanphong.vn/pictures/full/2024/06/1717476599-965-crucial-x9pro-d.jpg', 8, 50, '7/23/2026 10:00:00 AM', N'Crucial');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (301, N'Ổ cứng gắn ngoài HDD Seagate Expansion Desktop 8TB 3.5 inch', 4900000, N'TDP: 10W', N'https://down-id.img.susercontent.com/file/id-11134207-7r992-lz4iwty51s8092', 8, 30, '7/23/2026 10:00:00 AM', N'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (302, N'Ổ cứng di động HDD Lacie Rugged Mini 2TB USB 3.0 Chống dằn xóc', 2800000, N'TDP: 5W', N'https://techland.com.vn/public_folder/folder_image/uploads/2020/05/lacie-rugged-mini-usb-3.0-2.jpg', 8, 40, '7/23/2026 10:00:00 AM', N'LaCie');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (303, N'Ổ cứng di động SSD Kingston XS2000 1TB Type-C 2000MB/s Siêu nhỏ', 2950000, N'TDP: 5W', N'https://lagihitech.vn/wp-content/uploads/2024/04/o-cung-di-dong-SSD-Kingston-XS2000-1TB-SXS20001000G-hinh-1.jpg', 8, 35, '7/23/2026 10:00:00 AM', N'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (304, N'Ổ cứng di động HDD Transcend StoreJet 25M3 1TB Chống sốc 3 lớp', 1650000, N'TDP: 5W', N'https://enhakkore.net/wp-content/uploads/2018/07/TRANSCEND-1TB.jpg', 8, 70, '7/23/2026 10:00:00 AM', N'Transcend');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (305, N'Ổ cứng di động SSD Corsair EX100U 2TB Type-C USB 3.2 Gen2x2', 4200000, N'TDP: 5W', N'https://badudeal.lk/wp-content/uploads/2024/08/Corsair-EX100U-2TB-Type-C-Portable-SSD-srilanka-badudeal.lk-1.jpg', 8, 25, '7/23/2026 10:00:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (306, N'Ổ cứng di động SSD ADATA SE880 1TB Type-C 2000MB/s', 2550000, N'TDP: 4W', N'https://down-sg.img.susercontent.com/file/sg-11134207-7rdx0-lxxvt9dyai734a', 8, 55, '7/23/2026 10:00:00 AM', N'ADATA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (307, N'Tản nhiệt nước AIO NZXT Kraken Elite 360 RGB White LCD', 7250000, N'TDP: 15W', N'https://product.hstatic.net/200000722513/product/5355_7e4c62dc59808d76fe2dd8761e5da62f_8b9ca30e5f3c42178f638746bb8d10b3_a782d54587d04d07ad4738b03d12565a_1024x1024.jpg', 9, 30, '7/23/2026 10:00:00 AM', N'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (308, N'Tản nhiệt nước AIO Corsair iCUE LINK H150i LCD White 360mm', 6800000, N'TDP: 15W', N'https://philong.com.vn/media/product/31944-tan-nhiet-nuoc-cpu-aio-corsair-icue-link-h150i-rgb-360mm-white-cw-9061006-ww-philong--10-.jpg', 9, 25, '7/23/2026 10:00:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (309, N'Tản nhiệt nước AIO ASUS ROG Ryujin III 360 ARGB White Edition', 8900000, N'TDP: 20W', N'https://cdn.hstatic.net/products/200000522285/71tqdctsyil._sl1500_3d133254025a4566b8a6b75de0177edc.jpg', 9, 20, '7/23/2026 10:00:00 AM', N'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (310, N'Tản nhiệt nước AIO MSI MAG CORELIQUID E360 Black', 3450000, N'TDP: 12W', N'https://philong.com.vn/media/product/32659-tan-nhiet-nuoc-aio-cpu-msi-mag-coreliquid-e360-black-philong--3-.png', 9, 50, '7/23/2026 10:00:00 AM', N'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (311, N'Tản nhiệt nước AIO DeepCool LT720 360mm High-Performance', 3650000, N'TDP: 15W', N'https://product.hstatic.net/1000333506/product/n-nuoc-aio-deepcool-lt720-7_33b321d32ef447a4b060ea862d2c3c3a_1024x1024_3d97403a18dd4741a07d41ea8b3e458c.jpg', 9, 40, '7/23/2026 10:00:00 AM', N'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (312, N'Tản nhiệt nước AIO Lian Li Galahad II Trinity SL-INF 360 White', 4950000, N'TDP: 15W', N'https://m.media-amazon.com/images/I/61GMvzXd7sL.jpg', 9, 35, '7/23/2026 10:00:00 AM', N'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (313, N'Tản nhiệt nước AIO Cooler Master MasterLiquid 360 Atmos ARGB', 3850000, N'TDP: 12W', N'https://cdn.hstatic.net/products/200000522285/smart_-_2026-01-12t100540.000_c8de32fa2af84740ae8c4a5fb963d322.png', 9, 45, '7/23/2026 10:00:00 AM', N'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (314, N'Tản nhiệt nước AIO Thermalright Frozen Prism 360 ARGB Black', 1850000, N'TDP: 10W', N'https://product.hstatic.net/200000420363/product/4_fc0894cf23c34545b98c502be9363f3e_master.jpg', 9, 70, '7/23/2026 10:00:00 AM', N'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (315, N'Tản nhiệt nước AIO Valkyrie GL360 ARGB Màn hình LCD Black', 4200000, N'TDP: 15W', N'https://gland.vn/media/product/15140_81374_t___n_nhi___t_n_____c_valkyrie_gl360___en__2_.jpg', 9, 30, '7/23/2026 10:00:00 AM', N'Valkyrie');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (316, N'Tản nhiệt nước AIO ID-COOLING DASHFLOW 360 Basic Black', 1650000, N'TDP: 10W', N'https://phucanhcdn.com/media/product/51818_tan_nhiet_nuoc_aio_id_cooling_dashflow_360_basic_black_2.jpg', 9, 80, '7/23/2026 10:00:00 AM', N'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (317, N'Card màn hình GIGABYTE GeForce RTX 4070 Ti SUPER WINDFORCE OC 16G', 23900000, N'TDP: 285W', N'https://static.gigabyte.com/StaticFile/Image/Global/88366f8b8e43ca0066a14728a35e5d28/Product/39125/Png', 10, 25, '7/23/2026 10:00:00 AM', N'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (318, N'Card màn hình ASUS TUF Gaming GeForce RTX 4080 SUPER 16GB GDDR6X', 31500000, N'TDP: 320W', N'https://www.tnc.com.vn/uploads/product/sp2024/card-man-hinh-asus-tuf-rtx4080s-o16g-gaming.jpg', 10, 20, '7/23/2026 10:00:00 AM', N'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (319, N'Card màn hình MSI GeForce RTX 4060 Ti GAMING X SLIM 16G', 12800000, N'TDP: 165W', N'https://product.hstatic.net/200000722513/product/rtx_4060_ti_gaming_x_slim_16g_a214d2ab8d5b4c72885ff81cf695918d.png', 10, 40, '7/23/2026 10:00:00 AM', N'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (320, N'Card màn hình ZOTAC GAMING GeForce RTX 4070 SUPER Twin Edge OC 12GB', 16900000, N'TDP: 220W', N'https://halinhcomputer.vn/uploads/images/web-halinh-new/linh-kien-le/vga/zotac/rtx-4070-twin-edge-oc-12gb-gddr6x.png', 10, 35, '7/23/2026 10:00:00 AM', N'ZOTAC');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (321, N'Card màn hình GALAX GeForce RTX 4070 Ti SUPER EX Gamer White 16GB', 24500000, N'TDP: 285W', N'https://www.wootware.co.za/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/4/0/4070-ti-super-ex-gamer-white-0.jpg', 10, 18, '7/23/2026 10:00:00 AM', N'GALAX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (322, N'Card màn hình PowerColor Hellhound AMD Radeon RX 7900 XT 20GB', 21500000, N'TDP: 315W', N'https://m.media-amazon.com/images/I/814keJHzlgL._AC_.jpg', 10, 15, '7/23/2026 10:00:00 AM', N'PowerColor');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (323, N'Card màn hình Sapphire NITRO+ AMD Radeon RX 7800 XT 16GB', 15800000, N'TDP: 263W', N'https://sicomp.vn/_next/image?url=https:%2F%2Fcdn.sicomp.vn%2Fstorage%2Fproduct%2F1323%2F1323_card-man-hinh-sapphire-nitro-amd-radeon-rx-7800-xt_1.jpg&w=2048&q=75', 10, 30, '7/23/2026 10:00:00 AM', N'Sapphire');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (324, N'Card màn hình XFX Speedster MERC 310 AMD Radeon RX 7900 GRE 16GB', 16950000, N'TDP: 260W', N'https://cdn.prod.website-files.com/5d1911406ad3cbdb9924a753/639736d43e89781c8b59f26d_03.jpg', 10, 22, '7/23/2026 10:00:00 AM', N'XFX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (325, N'Card màn hình COLORFUL iGame GeForce RTX 4070 SUPER Ultra W OC 12GB', 17900000, N'TDP: 220W', N'https://nguyencongpc.vn/media/product/26203-z5083848788059_6fd23c6d5c495549bd8c0c3277d7842e_18_11zon.jpg', 10, 28, '7/23/2026 10:00:00 AM', N'COLORFUL');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (326, N'Card màn hình ASRock Phantom Gaming Radeon RX 7700 XT 12GB OC', 12500000, N'TDP: 245W', N'https://pg.asrock.com/Graphics-Card/photo/Radeon%20RX%207700%20XT%20Phantom%20Gaming%2012GB%20OC(L1).png', 10, 30, '7/23/2026 10:00:00 AM', N'ASRock');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (327, N'Ổ cứng HDD PC Seagate Barracuda 2TB 3.5 inch SATA3 7200rpm', 1550000, N'TDP: 6W', N'https://enfield-bd.com/wp-content/uploads/2021/07/SEAGATE-BARRACUDA-2TB-3.5-inch-SATA-5400rpm-Desktop-HDD.png', 11, 100, '7/23/2026 10:00:00 AM', N'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (328, N'Ổ cứng HDD PC Western Digital Blue 2TB 3.5 inch 7200rpm', 1480000, N'TDP: 6W', N'https://product.hstatic.net/200000837185/product/hddpcwesterndigitalblue2tb3.5-7200rpm256mbcache-wd20ezbx-_bb80957427454f0c8218a4cdf49e4e9b_master.png', 11, 110, '7/23/2026 10:00:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (329, N'Ổ cứng HDD PC Toshiba P300 2TB 3.5 inch SATA3 7200rpm', 1390000, N'TDP: 6W', N'https://hoanghapccdn.com/media/product/5135_hdd_toshiba_p300_2tb_ha2.jpg', 11, 90, '7/23/2026 10:00:00 AM', N'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (330, N'Ổ cứng HDD Server Seagate IronWolf 4TB 3.5 inch NAS SATA3', 2950000, N'TDP: 7W', N'https://maytinhlmc.vn/wp-content/uploads/68620_o_cung_hdd_seagate_ironwolf_4tb_3_5_inch_5400rpm_sata3_256mb_cache_st4000vn006.jpg', 11, 60, '7/23/2026 10:00:00 AM', N'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (331, N'Ổ cứng HDD Server Western Digital Red Plus 4TB 3.5 inch NAS', 3100000, N'TDP: 7W', N'https://www.tnc.com.vn/uploads/product/sp2026/o-cung-hdd-gan-trong-western-digital-red-plus-4tb-wd40efzz.webp', 11, 55, '7/23/2026 10:00:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (332, N'Ổ cứng HDD Enterprise Seagate Exos X18 16TB 3.5 inch SATA3', 8500000, N'TDP: 9W', N'https://qnapvn.com/o-cung-hdd-seagate-enterprise-exos-35-sata-7e8-16tb-st16000nm000j-2.png', 11, 20, '7/23/2026 10:00:00 AM', N'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (333, N'Ổ cứng HDD Enterprise Western Digital Gold 8TB 3.5 inch 7200rpm', 5900000, N'TDP: 8W', N'https://mygear.io.vn/media/product/6102-wd-gold-3-5.jpg', 11, 30, '7/23/2026 10:00:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (334, N'Ổ cứng HDD PC Toshiba X300 4TB 7200rpm Gaming Internal', 3250000, N'TDP: 8W', N'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/93/MTA-9352335/toshiba_toshiba_x300_4tb_sata_3_cache_128mb_7200rpm_-_hdd_internal_pc_full03_mcg4oh8k.jpg', 11, 40, '7/23/2026 10:00:00 AM', N'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (335, N'Ổ cứng HDD PC Western Digital Black 1TB 3.5 inch Performance', 1850000, N'TDP: 7W', N'https://kccshop.vn/media/product/250-948-9192_hdd_western_caviar_black_1tb_7200rpm_sata3_6gbs_64mb_cache_01.jpg', 11, 75, '7/23/2026 10:00:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (336, N'Ổ cứng HDD Camera Seagate SkyHawk 4TB 3.5 inch Surveillance', 2650000, N'TDP: 6W', N'https://enssecurity.com/wp-content/uploads/2023/07/C-HDD4000-VX-v2.jpg', 11, 80, '7/23/2026 10:00:00 AM', N'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (337, N'Nguồn Corsair RM750e ATX 3.0 80 Plus Gold Full Modular (750W)', 2850000, N'TDP: 0W', N'https://product.hstatic.net/200000722513/product/earvn-nguon-may-tinh-corsair-rm750e-atx-3.0-80-plus-gold-full-modula-1_5cd29a9f71ef4d18b2dcc67481d01eb0_master.png', 12, 60, '7/23/2026 10:00:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (338, N'Nguồn MSI MAG A750GL PCIE5 750W 80 Plus Gold Full Modular', 2650000, N'TDP: 0W', N'https://m.media-amazon.com/images/I/71Bp8cXNjeL._AC_.jpg', 12, 70, '7/23/2026 10:00:00 AM', N'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (339, N'Nguồn GIGABYTE UD850GM PG5 850W 80 Plus Gold PCIe 5.0', 3100000, N'TDP: 0W', N'https://bermorzone.com.ph/wp-content/uploads/2022/12/GP-UD850GM-PG5-ph.webp', 12, 50, '7/23/2026 10:00:00 AM', N'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (340, N'Nguồn ASUS TUF Gaming 750W 80 Plus Bronze', 2150000, N'TDP: 0W', N'https://songphuong.vn/Content/uploads/2025/06/TUF-Gaming-750W-Bronze-1.webp', 12, 80, '7/23/2026 10:00:00 AM', N'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (341, N'Nguồn Cooler Master MWE Gold 850 V2 Full Modular (850W)', 2950000, N'TDP: 0W', N'https://songphuong.vn/Content/uploads/2021/08/Nguon-Cooler-Master-MWE-GOLD-850-V2-Full-Modular-850W-songphuong.vn_.jpg', 12, 65, '7/23/2026 10:00:00 AM', N'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (342, N'Nguồn DeepCool PL750D 750W 80 Plus Bronze ATX 3.0 Native', 1750000, N'TDP: 0W', N'https://phucanhcdn.com/media/product/61221_nguon_may_tinh_deepcool_pl750d_750w_80_plus_bronze_atx_3_0_pcie_5_5.jpg', 12, 90, '7/23/2026 10:00:00 AM', N'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (343, N'Nguồn Super Flower Leadex III Gold 850W ARGB Full Modular', 3450000, N'TDP: 0W', N'https://down-my.img.susercontent.com/file/27e5251ee99cf1d947ce9d44aacbb258', 12, 40, '7/23/2026 10:00:00 AM', N'Super Flower');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (344, N'Nguồn Seasonic Focus GX-850 850W 80 Plus Gold Full Modular', 3650000, N'TDP: 0W', N'https://ph-test-11.slatic.net/p/a55f2beca5e25fccaa8c429a122cbe72.jpg', 12, 45, '7/23/2026 10:00:00 AM', N'Seasonic');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (345, N'Nguồn FSP Hydro G PRO 850W PCIe5.0 80 Plus Gold', 3350000, N'TDP: 0W', N'https://smart1ech.com/wp-content/uploads/2023/10/www.fspgroupusa.com-HG2-850W-5G-36.png', 12, 50, '7/23/2026 10:00:00 AM', N'FSP');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (346, N'Nguồn Thermaltake Toughpower GF A3 850W Gold ATX 3.0', 2950000, N'TDP: 0W', N'https://maytinhlmc.vn/wp-content/uploads/81083_ngu___n_thermaltake_toughpower_gf_a3_850w__2_.jpg', 12, 55, '7/23/2026 10:00:00 AM', N'Thermaltake');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (347, N'Vỏ case NZXT H6 Flow RGB Dual-Chamber Mid-Tower Black', 3450000, N'TDP: 0W', N'https://c1.neweggimages.com/productimage/nb1280/11-146-359-05.jpg', 13, 40, '7/23/2026 10:00:00 AM', N'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (348, N'Vỏ case Lian Li O11 Vision Tempered Glass Mid-Tower White', 3950000, N'TDP: 0W', N'https://i5.walmartimages.com/seo/LIAN-LI-O11-Vision-White-Aluminum-Steel-Tempered-Glass-ATX-Mid-Tower-Computer-Case-O11VW_8a75551b-e1fb-4b80-8cd4-a1db5126b46a.8bf544a2a9b5dedc9213b95788327938.jpeg', 13, 35, '7/23/2026 10:00:00 AM', N'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (349, N'Vỏ case Corsair 4000D AIRFLOW Tempered Glass Mid-Tower Black', 2150000, N'TDP: 0W', N'https://m.media-amazon.com/images/I/81hL4tPkXZL._AC_SL1500_.jpg', 13, 80, '7/23/2026 10:00:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (350, N'Vỏ case Montech KING 95 PRO Panoramic Curved Glass ARGB Black', 3650000, N'TDP: 0W', N'https://www.scan.co.uk/images/infopages/montech/case/KING_95/PRO/Black/zenith.png', 13, 30, '7/23/2026 10:00:00 AM', N'Montech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (351, N'Vỏ case HYTE Y60 Panoramic Dual Chamber Glass Black/Red', 5450000, N'TDP: 0W', N'https://meststores.com/wp-content/uploads/2026/02/hyte-y60-dual-chamber-panoramic-mid-tower-atx-case-with-pcie-40-riser-black-red-front.webp', 13, 20, '7/23/2026 10:00:00 AM', N'HYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (352, N'Vỏ case Antec C8 Dual-Chamber Full Tower Black', 2850000, N'TDP: 0W', N'https://dynaquestpc.com/cdn/shop/files/146_95625c7a-de2e-4025-8358-3a91733300f2.png?v=1714810776&width=1214', 13, 45, '7/23/2026 10:00:00 AM', N'Antec');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (353, N'Vỏ case Fractal Design Pop Air RGB TG Black', 2450000, N'TDP: 0W', N'https://mygear.io.vn/media/product/9794-vo-case-fractal-design-pop-air-rgb-black-tg-clear-4.png', 13, 50, '7/23/2026 10:00:00 AM', N'Fractal Design');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (354, N'Vỏ case DeepCool CH560 DIGITAL ARGB Màn hình nhiệt độ Black', 2650000, N'TDP: 0W', N'https://pcx.vn/uploads/auto/2026/04/1776672416806-6a71e019-fb8c-4871-b6be-887832440afe.jpg', 13, 60, '7/23/2026 10:00:00 AM', N'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (355, N'Vỏ case Xigmatek ENDORPHIN ULTRA ARTIC White Panoramic', 1450000, N'TDP: 0W', N'https://nvs.tn-cdn.net/2023/08/vo-case-xigmatek-endorphin-ultra-arctic_01.jpg', 13, 90, '7/23/2026 10:00:00 AM', N'Xigmatek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (356, N'Vỏ case Phanteks NV5 Mid-Tower ARGB Black Glass', 2750000, N'TDP: 0W', N'https://images.tokopedia.net/img/cache/900/VqbcmM/2023/11/30/459f4cd1-d894-4066-a304-09372696e580.jpg', 13, 40, '7/23/2026 10:00:00 AM', N'Phanteks');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (357, N'Tản nhiệt khí Thermalright Peerless Assassin 120 SE ARGB', 980000, N'TDP: 5W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mde35e6fewkcc0', 14, 100, '7/23/2026 10:00:00 AM', N'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (358, N'Tản nhiệt khí DeepCool AK400 Digital ARGB Màn hình LED Black', 1150000, N'TDP: 4W', N'https://product.hstatic.net/200000420363/product/deepcool-ak400-digital-digital_1a29672f9455490686f5c03cc43dba45_master.png', 14, 80, '7/23/2026 10:00:00 AM', N'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (359, N'Tản nhiệt khí Noctua NH-D15 chromax.black Dual-Tower Premium', 2950000, N'TDP: 5W', N'https://os-jo.com/image/cache/catalog/products/ANOCTUA/NH-D15-BLACK/BLACK-1200x1200.JPEG', 14, 35, '7/23/2026 10:00:00 AM', N'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (360, N'Tản nhiệt khí ID-COOLING SE-224-XT ARGB V2 Black', 520000, N'TDP: 3W', N'https://product.hstatic.net/200000536009/product/37_b652d34513cc4cdbb4cb8273d1c4f01b_master.jpg', 14, 120, '7/23/2026 10:00:00 AM', N'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (361, N'Tản nhiệt khí Cooler Master Hyper 622 Halo Black ARGB Dual-Tower', 1350000, N'TDP: 5W', N'https://kccshop.vn/media/product/250-5123-1.jpg', 14, 60, '7/23/2026 10:00:00 AM', N'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (362, N'Tản nhiệt khí Jonsbo CR-1000 EVO ARGB Black', 380000, N'TDP: 3W', N'https://nvs.tn-cdn.net/2023/07/tan-nhiet-khi-jonsbo-cr-1000-evo-argb-6.jpg', 14, 150, '7/23/2026 10:00:00 AM', N'Jonsbo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (363, N'Tản nhiệt khí Thermalright Phantom Spirit 120 EVO 7 Heatpipes', 1280000, N'TDP: 5W', N'https://mygear.io.vn/media/product/9540-tan-nhiet-khi-thermalright-phantom-spirit-120-evo-1.jpg', 14, 75, '7/23/2026 10:00:00 AM', N'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (364, N'Tản nhiệt khí Be Quiet! Dark Rock Pro 5 Dual Tower', 2450000, N'TDP: 5W', N'https://basic-tutorials.de/wp-content/uploads/2023/11/20231031-IMG_5208.jpg', 14, 40, '7/23/2026 10:00:00 AM', N'Be Quiet!');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (365, N'Tản nhiệt khí PCCOOLER K6 Digital Display ARGB Dual Tower', 1050000, N'TDP: 4W', N'https://lookaside.fbsbx.com/lookaside/crawler/media/?media_id=2404382830021734', 14, 65, '7/23/2026 10:00:00 AM', N'PCCOOLER');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (366, N'Tản nhiệt khí Valkyrie SL125 ARGB Màn hiển thị nhiệt độ', 950000, N'TDP: 4W', N'https://down-vn.img.susercontent.com/file/vn-11134201-23030-bngm8wm2wjov2c', 14, 70, '7/23/2026 10:00:00 AM', N'Valkyrie');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (367, N'Bộ 3 Fan tản nhiệt Lian Li UNI FAN SL-Infinity 120 ARGB Triple Black', 2450000, N'TDP: 3W', N'https://product.hstatic.net/200000522285/product/_fan_ghep_noi_khong_day__toc_2100rpm__pwm__fan_case_sl120_tpassionvn_1_76a2eab92dd74027a0eed0c5552a6b4d.jpg', 15, 50, '7/23/2026 10:00:00 AM', N'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (368, N'Bộ 3 Fan tản nhiệt Corsair iCUE LINK QX120 RGB Starter Kit White', 3650000, N'TDP: 4W', N'https://www.scan.co.uk/images/infopages/corsair_fans/QX120/starterkit/topimgw.png', 15, 40, '7/23/2026 10:00:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (369, N'Bộ 3 Fan tản nhiệt NZXT Duo F120 RGB Triple Pack Black', 2150000, N'TDP: 3W', N'https://media.ldlc.com/r1600/ld/products/00/06/01/35/LD0006013533.jpg', 15, 60, '7/23/2026 10:00:00 AM', N'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (370, N'Bộ 3 Fan tản nhiệt Thermalright TL-C12C-S ARGB Triple Pack Black', 480000, N'TDP: 2W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltf6s8b4fdai9f', 15, 120, '7/23/2026 10:00:00 AM', N'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (371, N'Bộ 3 Fan tản nhiệt DeepCool FC120 3-in-1 ARGB Black', 850000, N'TDP: 3W', N'https://down-vn.img.susercontent.com/file/vn-11134207-81ztc-mm8bqpv4eu4l83', 15, 80, '7/23/2026 10:00:00 AM', N'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (372, N'Bộ 3 Fan tản nhiệt Phanteks D30-120 Reverse Airflow Triple Black', 2250000, N'TDP: 3W', N'https://www.tncstore.vn/media/product/250-13877-quat-tan-nhiet-phanteks-d30-120mm-reversed-drgb-black-triple-pack-1.jpg', 15, 45, '7/23/2026 10:00:00 AM', N'Phanteks');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (373, N'Bộ 3 Fan tản nhiệt ID-COOLING XF-12025 ARGB Trio Pack', 550000, N'TDP: 2W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ltjplsx9zeh679', 15, 100, '7/23/2026 10:00:00 AM', N'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (374, N'Bộ 3 Fan tản nhiệt Cooler Master MasterFan MF120 Halo2 ARGB White', 1350000, N'TDP: 3W', N'https://product.hstatic.net/200000722513/product/63609_halo3in1_white_2fe56efd09ad4358bc9bffe694dc34c0_ae18db62db9a4b17b2544370f1bf7da0_master.jpg', 15, 70, '7/23/2026 10:00:00 AM', N'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (375, N'Bộ 3 Fan tản nhiệt Antec Fusion 120 ARGB Triple Pack', 780000, N'TDP: 2W', N'https://pccaus.com/storage/media/vFHpsQH3nrKiKePf8QVaftKHHn8IKXI2clabBCo6.jpeg', 15, 90, '7/23/2026 10:00:00 AM', N'Antec');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (376, N'Bộ 3 Fan tản nhiệt Montech AX120 PWM ARGB Pack White', 650000, N'TDP: 2W', N'https://cdn1.centrecom.com.au/images/upload/0186713_0.jpeg', 15, 95, '7/23/2026 10:00:00 AM', N'Montech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (377, N'Bàn phím cơ AKKO 3087 v2 Silent Bluetooth 5.0 / Wireless 2.4G', 1450000, N'TDP: 1W', N'https://akko.vn/wp-content/uploads/2021/10/ban-phim-co-akko-3087-v2-steam-engine-01.jpg', 16, 60, '7/23/2026 10:00:00 AM', N'AKKO');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (378, N'Bàn phím cơ Keychron V1 Max Wireless Custom Mechanical Keyboard Hotswap', 2250000, N'TDP: 2W', N'https://product.hstatic.net/200000837185/product/1_a00c416b2b034ee39022badcfd3f6e91_grande.png', 16, 50, '7/23/2026 10:00:00 AM', N'Keychron');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (379, N'Bàn phím cơ Royal Kludge RK84 RGB Wireless 80% Layout Hotswap', 980000, N'TDP: 1W', N'https://cf.shopee.vn/file/6e1e4cbe7912a8b7473e94334e280d6d', 16, 90, '7/23/2026 10:00:00 AM', N'Royal Kludge');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (380, N'Bàn phím cơ FL-Esports FL980 SAM Tropical Secret Wireless', 2450000, N'TDP: 2W', N'https://tsunamigaming.vn/wp-content/uploads/2024/02/ban-phim-co-fl-esports-fl980-sam-cercis-tsunamigaming-h2.jpg', 16, 40, '7/23/2026 10:00:00 AM', N'FL-Esports');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (381, N'Bàn phím cơ MonsGeek M1W V3 Fully Assembled Aluminum Wireless', 2150000, N'TDP: 2W', N'https://bizweb.dktcdn.net/thumb/grande/100/466/510/articles/new-monsgeek-m1w-bluetooth-wireless-mechanical-keyboard-rgb-heat-exchange-aluminum-alloy-body-keyboard-pc-game-jpg.jpg?v=1689416873953', 16, 45, '7/23/2026 10:00:00 AM', N'MonsGeek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (382, N'Bàn phím cơ EPOMAKER RT100 Retro Mechanical Keyboard Màn hình Smart', 2650000, N'TDP: 2W', N'https://the-gadgeteer.com/wp-content/uploads/2023/10/epomaker-rt100-1-768x577.jpg', 16, 35, '7/23/2026 10:00:00 AM', N'EPOMAKER');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (383, N'Bàn phím cơ Ducky One 3 Daybreak Hotswap RGB Mech Keyboard', 2850000, N'TDP: 2W', N'https://img.lazcdn.com/g/p/55ae1abfed8b5f9068f263c2fdad5fee.png_720x720q80.png', 16, 30, '7/23/2026 10:00:00 AM', N'Ducky');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (384, N'Bàn phím cơ Varmilo VEA87 Vintage Mechanical Keyboard Cherry MX', 3150000, N'TDP: 1W', N'https://down-sg.img.susercontent.com/file/sg-11134201-23010-9jf38tbmpxlv7d', 16, 25, '7/23/2026 10:00:00 AM', N'Varmilo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (385, N'Bàn phím cơ NuPhy Air75 V2 Low-Profile Wireless Keyboard', 2950000, N'TDP: 2W', N'https://ae01.alicdn.com/kf/S7895a3515780430eae0a4cc7d06e77fdB.jpg', 16, 40, '7/23/2026 10:00:00 AM', N'NuPhy');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (386, N'Bàn phím cơ Custom Womier K66 Gateron Switch RGB Acrylic Glass', 1250000, N'TDP: 1W', N'https://m.media-amazon.com/images/S/aplus-media-library-service-media/23afc7a0-27ae-4702-9816-82521db15ee8.__CR0,0,970,600_PT0_SX970_V1___.png', 16, 70, '7/23/2026 10:00:00 AM', N'Womier');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (387, N'Chuột máy tính Razer Basilisk V3 Ergonomic Gaming Mouse 26k DPI', 1450000, N'TDP: 1W', N'https://m.media-amazon.com/images/I/61okFRY8uPL._AC_.jpg', 17, 80, '7/23/2026 10:00:00 AM', N'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (388, N'Chuột máy tính Logitech G304 LIGHTSPEED Wireless Black 12k DPI', 820000, N'TDP: 1W', N'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mek0sd2tdmgxc0', 17, 150, '7/23/2026 10:00:00 AM', N'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (389, N'Chuột máy tính Pulsar X2 V2 Wireless Gaming Mouse Superlight 53g', 2150000, N'TDP: 1W', N'https://cdn.store-assets.com/s/824673/i/61271910.jpeg', 17, 45, '7/23/2026 10:00:00 AM', N'Pulsar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (390, N'Chuột máy tính Ninjutso Sora V2 Ultra Lightweight Wireless 39g', 2450000, N'TDP: 1W', N'https://down-ph.img.susercontent.com/file/sg-11134202-7ratx-may7aujrn6uu1e', 17, 40, '7/23/2026 10:00:00 AM', N'Ninjutso');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (391, N'Chuột máy tính LAMZU Atlantis OG V2 Wireless Gaming Mouse 55g', 2250000, N'TDP: 1W', N'https://cdn.store-assets.com/s/824673/i/62363110.jpeg', 17, 50, '7/23/2026 10:00:00 AM', N'LAMZU');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (392, N'Chuột máy tính Endgame Gear OP1WE Wireless Gaming Mouse 58g', 1950000, N'TDP: 1W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m5d24fcjbuieb0', 17, 60, '7/23/2026 10:00:00 AM', N'Endgame Gear');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (393, N'Chuột máy tính VGN Dragonfly F1 PRO MAX Wireless Nordic MCU', 1150000, N'TDP: 1W', N'https://bizweb.dktcdn.net/thumb/1024x1024/100/466/510/products/9884aef4-733e-4f36-a587-d3bed9c441ed-1693989197508.jpg?v=1694080500800', 17, 90, '7/23/2026 10:00:00 AM', N'VGN');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (394, N'Chuột máy tính VXE R1 PRO MAX Ultra Light Wireless PAW3395', 980000, N'TDP: 1W', N'https://down-br.img.susercontent.com/file/br-11134207-7r98o-m5etuyqhic3628', 17, 110, '7/23/2026 10:00:00 AM', N'VXE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (395, N'Chuột máy tính SteelSeries Rival 3 Wireless Gaming Mouse 18k DPI', 950000, N'TDP: 1W', N'https://os-jo.com/image/cache/catalog/products/Accessories/Mouse/RIVAL-3-Wireless/a89f866daa5b7f847d234e3beb4d6582-1200x1200.jpg', 17, 100, '7/23/2026 10:00:00 AM', N'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (396, N'Chuột máy tính ASUS ROG Harpe Ace Aim Lab Edition 54g Wireless', 2850000, N'TDP: 1W', N'https://product.hstatic.net/1000262653/product/sp1080884_f0bb5b45cbbc4da1881a87dc14861641_master.png', 17, 35, '7/23/2026 10:00:00 AM', N'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (397, N'Tai nghe gaming HyperX Cloud II Wireless Red/Black Spatial Audio', 2950000, N'TDP: 1W', N'https://cdn.shopify.com/s/files/1/0564/3612/9997/products/hyperx_cloud_ii_wireless_6_accessories_2048x2048.jpg?v=1655760985', 18, 60, '7/23/2026 10:00:00 AM', N'HyperX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (398, N'Tai nghe gaming Razer BlackShark V2 X 7.1 Surround Sound Black', 1250000, N'TDP: 1W', N'https://cdn.hstatic.net/products/1000231532/mua_razer_blackshark_v2_x_b_o_h_nh_24_th_ng_uy_t_n_t_i_nshop_4e5bb68935394ba79b01c641540fa09e_master.jpg', 18, 100, '7/23/2026 10:00:00 AM', N'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (399, N'Tai nghe gaming Corsair HS80 RGB Wireless Spatial Audio White', 3450000, N'TDP: 2W', N'https://assets.corsair.com/image/upload/c_pad,q_auto,h_1024,w_1024,f_auto/products/Gaming-Headsets/CA-9011236-EU/Gallery/HS80_RGB_WIRELESS_WHITE_01.webp', 18, 45, '7/23/2026 10:00:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (400, N'Tai nghe gaming Logitech G435 LIGHTSPEED Ultra-Light Wireless Blue', 1450000, N'TDP: 1W', N'https://down-ph.img.susercontent.com/file/ph-11134207-7rasb-m6gmkzx8osu7d2', 18, 90, '7/23/2026 10:00:00 AM', N'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (401, N'Tai nghe gaming SteelSeries Arctis Nova 7 Wireless Multi-Platform', 4250000, N'TDP: 2W', N'https://azaudio.vn/wp-content/uploads/2023/12/azaudio-steelseries-arctis-nova-7-wireless-2.jpg', 18, 35, '7/23/2026 10:00:00 AM', N'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (402, N'Tai nghe gaming EPOS Sennheiser GSP 300 Closed Acoustic Black/Blue', 1850000, N'TDP: 1W', N'https://linkemstores.com/img/user/products/Sennheise/Sennheiser%20Gamer%20Series%20Closed%20Acoustic%20Gaming%20Headset%20GSP%20300/Black/SennheiserGamerSeriesClosedAcousticGamingHeadsetGSP300Black3-1.png', 18, 50, '7/23/2026 10:00:00 AM', N'EPOS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (403, N'Tai nghe gaming Audio-Technica ATH-GDL3 Open-Back Gaming Headset', 3250000, N'TDP: 1W', N'https://images.tokopedia.net/img/cache/500-square/VqbcmM/2022/1/28/53a4c36c-e344-4f86-83b5-62905654253a.jpg', 18, 30, '7/23/2026 10:00:00 AM', N'Audio-Technica');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (404, N'Tai nghe gaming JBL Quantum 400 USB Wired Gaming Headset QuantumSURROUND', 1950000, N'TDP: 1W', N'https://m.media-amazon.com/images/I/61XqT1iYszL._AC_SL1500_.jpg', 18, 70, '7/23/2026 10:00:00 AM', N'JBL');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (405, N'Tai nghe gaming ASUS ROG Delta S Wireless Gaming Headset Type-C', 4650000, N'TDP: 2W', N'https://mygear.io.vn/media/product/9420-tai-nghe-gaming-overear-asus-rog-delta-s-wireless-4.jpg', 18, 25, '7/23/2026 10:00:00 AM', N'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (406, N'Tai nghe gaming EKSA E900 Pro 7.1 Surround Sound Wired Dual Audio', 750000, N'TDP: 1W', N'https://www.eksa.in/cdn/shop/files/2_-10.png?v=1725616185', 18, 120, '7/23/2026 10:00:00 AM', N'EKSA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (407, N'Thẻ nhớ MicroSD Sandisk Ultra 32GB Class 10 120MB/s', 120000, N'TDP: 1W', N'https://maytinhtrangia.com/wp-content/uploads/SD-32G-1.jpg', 4, 150, '7/23/2026 11:35:00 AM', N'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (408, N'Thẻ nhớ MicroSD Sandisk High Endurance 64GB Chuyên ghi Dashcam', 290000, N'TDP: 1W', N'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/h/the-nho-microsd-sandisk-high-endurance-chuyen-camera-64gb_1_.png', 4, 100, '7/23/2026 11:35:00 AM', N'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (409, N'Thẻ nhớ SDXC SanDisk Extreme PRO 64GB UHS-I 200MB/s', 450000, N'TDP: 2W', N'https://media.foto-erhardt.de/images/product_images/popup_images/893/sandisk-64-gb-sdxc-extremepro-200mbs-v30-uhs-i-u3-class-10-speicherkarte-166124206789380304.jpg', 4, 120, '7/23/2026 11:35:00 AM', N'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (410, N'Thẻ nhớ MicroSD Samsung EVO Plus 64GB kèm Adapter', 210000, N'TDP: 1W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lfc894uls77909', 4, 180, '7/23/2026 11:35:00 AM', N'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (411, N'Thẻ nhớ MicroSD Samsung EVO Plus 128GB UHS-I U3', 350000, N'TDP: 2W', N'https://www.nhatthuc.com.vn/resize-image/470x/2025/08/the-nho-micro-sd-samsung-evo-plus-128gb-1.jpg', 4, 140, '7/23/2026 11:35:00 AM', N'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (412, N'Thẻ nhớ MicroSD Kingston Canvas Select Plus 64GB', 150000, N'TDP: 1W', N'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/h/the-nho-microsd-kingston-canvas-select-plus-64gb-sdcs3_2_.png', 4, 200, '7/23/2026 11:35:00 AM', N'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (413, N'Thẻ nhớ MicroSD Kingston Canvas Select Plus 256GB', 520000, N'TDP: 2W', N'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/h/the-nho-microsd-kingston-canvas-select-plus-256gb-sdcs3_4_.png', 4, 90, '7/23/2026 11:35:00 AM', N'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (414, N'Thẻ nhớ SDXC Lexar Professional 1667x 128GB SDXC UHS-II 250MB/s', 1150000, N'TDP: 3W', N'https://product.hstatic.net/200000863343/product/the-nho-sdxc-lexar-128gb-uhs-ii-1667x-250mb-s-scjuu_3e270e20e4ff4e72bb2df4b4c7fc1e45.jpg', 4, 60, '7/23/2026 11:35:00 AM', N'Lexar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (415, N'Thẻ nhớ MicroSD Lexar Play 256GB UHS-I cho Nintendo Switch', 680000, N'TDP: 2W', N'https://cdn.hstatic.net/products/1000231532/ss_256gb_lexar_cho_nintendo_switch_2_chinh_hang_gia_tot_chat_luong_cao_d1dc82953bc747cbac60d5e312b47e76.jpg', 4, 80, '7/23/2026 11:35:00 AM', N'Lexar');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (416, N'Thẻ nhớ SDXC Sony SF-E Series 64GB UHS-II 270MB/s', 850000, N'TDP: 2W', N'https://photoking.vn/upload/images/Ph%E1%BB%A5%20Ki%E1%BB%87n/Th%E1%BA%BB%20Nh%E1%BB%9B/the-nho-sony-sdxc-64gb-270mbs-70-mbs-sf-m64-photoking-vn-02.jpg', 4, 50, '7/23/2026 11:35:00 AM', N'Sony');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (417, N'Thẻ nhớ SDXC Sony TOUGH M Series 128GB UHS-II 270MB/s', 2100000, N'TDP: 3W', N'https://cf.shopee.co.id/file/50fab139ce6eeb1d06a77f9ef2d9577f', 4, 35, '7/23/2026 11:35:00 AM', N'Sony');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (418, N'Thẻ nhớ MicroSD Kioxia Exceria G2 256GB NVMe Class', 620000, N'TDP: 2W', N'https://www.tnc.com.vn/uploads/product/vy2023/the-nho-256gb-kioxia-microsd-sdxc-exceria-g2.png', 4, 75, '7/23/2026 11:35:00 AM', N'Kioxia');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (419, N'Thẻ nhớ SDXC Transcend 700S 64GB SDXC UHS-II V90 285MB/s', 1850000, N'TDP: 3W', N'https://d2ati23fc66y9j.cloudfront.net/ubuy/full/1/7/170920366713977IMG.jpg', 4, 40, '7/23/2026 11:35:00 AM', N'Transcend');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (420, N'Thẻ nhớ MicroSD TeamGroup PRO Endurance 128GB', 390000, N'TDP: 2W', N'https://cdn.hstatic.net/products/200001078011/the-nho-team-group-elite-128g-uhs-i-u3-v30-a1_72e4b2b6836c44dcb2acea7c924762a2_master.jpg', 4, 85, '7/23/2026 11:35:00 AM', N'TeamGroup');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (421, N'Thẻ nhớ SDXC ProGrade Digital SDXC UHS-II V90 Cobalt 128GB', 3950000, N'TDP: 3W', N'https://www.lens-camera.com/wp-content/uploads/2025/03/02/prograde_digital_555654_1_1.jpg', 4, 20, '7/23/2026 11:35:00 AM', N'ProGrade');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (422, N'Ổ cứng di động SSD WD My Passport SSD 1TB USB 3.2 Red', 2450000, N'TDP: 4W', N'https://minhancomputercdn.com/media/product/11301_wd_my_passport_ssd_1tb_wdbagf0010brd_wesn_2.jpg', 8, 60, '7/23/2026 11:35:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (423, N'Ổ cứng di động SSD WD Black P50 Game Drive 1TB NVMe 2000MB/s', 3850000, N'TDP: 5W', N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/wd-p50-02-42d56a0c-5309-4266-8a4a-720e3320e5e5.jpg?v=1615888619027', 8, 40, '7/23/2026 11:35:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (424, N'Ổ cứng di động HDD WD Elements Portable 1TB 2.5 inch USB 3.0', 1390000, N'TDP: 5W', N'https://www.maytinhphunggia.vn/media/product/29114_sua_o_cung_di_dong_hdd_wd_elements_portable_1tb_2_5_inch_usb_3_0.jpg', 8, 100, '7/23/2026 11:35:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (425, N'Ổ cứng di động HDD WD Elements Portable 4TB 2.5 inch USB 3.0', 3150000, N'TDP: 6W', N'https://duyhungcomputer.vn/media/product/2529-o-cu-ng-di-do-ng-hdd-western-digital-elements-portable-4tb-2-5-usb-3-0-wdbu6y0040bbk-wesn-01.jpg', 8, 50, '7/23/2026 11:35:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (426, N'Ổ cứng di động SSD Samsung T7 Portable 1TB USB 3.2 Titan Gray', 2550000, N'TDP: 4W', N'https://cdn2.cellphones.com.vn/x/media/catalog/product/o/-/o-cung-di-dong-ssd-samsung-t7-portable_10_.png', 8, 70, '7/23/2026 11:35:00 AM', N'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (427, N'Ổ cứng di động SSD Samsung T9 Portable 2TB USB 3.2 Gen 2x2 2000MB/s', 5450000, N'TDP: 5W', N'https://lagihitech.vn/wp-content/uploads/2023/10/SSD-Samsung-T9-2TB-USB-3.2-Gen-2-MU-PG2T0B-hinh-8.jpg', 8, 30, '7/23/2026 11:35:00 AM', N'Samsung');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (428, N'Ổ cứng di động SSD SanDisk Extreme PRO Portable 2TB USB 3.2 Gen 2x2', 5150000, N'TDP: 5W', N'https://down-vn.img.susercontent.com/file/sg-11134201-22120-69sq1wzfywkv7d', 8, 35, '7/23/2026 11:35:00 AM', N'SanDisk');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (429, N'Ổ cứng di động HDD Seagate One Touch 2TB 2.5 inch USB 3.0 Black', 2050000, N'TDP: 5W', N'https://huyhoang.vn/uploads/o-cung-di-dong-hdd-seagate-one-touch-2tb-25-usb-30-den-stky2000400-3.jpg', 8, 80, '7/23/2026 11:35:00 AM', N'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (430, N'Ổ cứng di động HDD Seagate Basic 1TB 2.5 inch USB 3.0', 1290000, N'TDP: 5W', N'https://hoanghapccdn.com/media/product/3630_1tb_touch_1_hdd_1.jpg', 8, 110, '7/23/2026 11:35:00 AM', N'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (431, N'Ổ cứng di động SSD Crucial X6 Portable SSD 2TB 800MB/s', 3450000, N'TDP: 4W', N'https://5sc.vn/wp-content/uploads/2022/05/Crucial-X6-Portable-SSD-2TB-Box-Front-Image.png', 8, 45, '7/23/2026 11:35:00 AM', N'Crucial');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (432, N'Ổ cứng di động SSD Crucial X10 Pro 2TB USB 3.2 Gen 2x2 2100MB/s', 5850000, N'TDP: 5W', N'https://tinhocthanhkhang.vn/media/product/2964-ssd-di-dong-2tb-crucial-x10-ct2000x10ssd9-2_15_11zon.webp', 8, 25, '7/23/2026 11:35:00 AM', N'Crucial');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (433, N'Ổ cứng di động SSD Kingston XS1000 2TB External SSD Type-C Red', 3650000, N'TDP: 4W', N'https://image.citycenter.jo/cache/catalog/002023/72023/xx2000-1200x1200.jpg', 8, 55, '7/23/2026 11:35:00 AM', N'Kingston');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (434, N'Tản nhiệt nước AIO Corsair H100i RGB ELITE 240mm', 3250000, N'TDP: 12W', N'https://philong.com.vn/media/product/31924-tan-nhiet-nuoc-cpu-aio-corsair-icue-h100i-rgb-elite-240mm-white-cw-9060078-ww-philong--2-.jpg', 9, 50, '7/23/2026 11:35:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (435, N'Tản nhiệt nước AIO Corsair iCUE LINK H100i RGB White 240mm', 4850000, N'TDP: 12W', N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/tan-nhiet-nuoc-aio-corsair-icue-link-h100i-rgb-white-cw-9061005-ww.jpg?v=1688526053120', 9, 35, '7/23/2026 11:35:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (436, N'Tản nhiệt nước AIO NZXT Kraken 240 RGB Black LCD', 4250000, N'TDP: 12W', N'https://www.pcstudio.in/wp-content/uploads/2023/05/Nzxt-Kraken-240-Rgb-240mm-Aio-Liquid-Cooler-Matte-Black-1.jpg', 9, 40, '7/23/2026 11:35:00 AM', N'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (437, N'Tản nhiệt nước AIO NZXT Kraken 360 RGB Black LCD', 5350000, N'TDP: 15W', N'https://hoanghapc.vn/media/product/4402_rl_kr360_b1_ha1.jpg', 9, 30, '7/23/2026 11:35:00 AM', N'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (438, N'Tản nhiệt nước AIO ASUS ROG Strix LC III 360 ARGB', 4950000, N'TDP: 15W', N'http://kccshop.vn/media/product/250-8116-t---n-nhi---t-n-----c-aio-asus-rog-strix-lc-iii-360-argb-white-editon-01.png', 9, 25, '7/23/2026 11:35:00 AM', N'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (439, N'Tản nhiệt nước AIO ASUS TUF Gaming LC II 360 ARGB', 2950000, N'TDP: 15W', N'https://hoanghapccdn.com/media/product/5001_tuf_gaming_lc_ii_360_argb_ha1.jpg', 9, 45, '7/23/2026 11:35:00 AM', N'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (440, N'Tản nhiệt nước AIO DeepCool LS720 SE 360mm ARGB Black', 2650000, N'TDP: 15W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m2whteh6qzuu1d', 9, 60, '7/23/2026 11:35:00 AM', N'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (441, N'Tản nhiệt nước AIO DeepCool MYSTIQUE 360 Màn hình LCD 3.4 inch', 4150000, N'TDP: 15W', N'http://cms2.deepcool.com:8080/public/ProductFile/DEEPCOOL/Cooling/CPULiquidCoolers/MYSTIQUE_360_ARGB/Gallery/4000X4000/01.png', 9, 30, '7/23/2026 11:35:00 AM', N'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (442, N'Tản nhiệt nước AIO Thermalright Frozen Warframe 360 ARGB Màn LCD', 2750000, N'TDP: 15W', N'https://gitec.ge/images/thumbs/0070829_tr-fw-360-b-argb.jpeg', 9, 40, '7/23/2026 11:35:00 AM', N'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (443, N'Tản nhiệt nước AIO Lian Li Galahad II LCD 360 SL-INF Black', 6450000, N'TDP: 15W', N'https://ttgshop.vn/media/product/1054421234_82296_tan_nhiet_nuoc_lian_li_galahad_ii_lcd_sl_inf_360_black__3__f16e36ee72964ce8a37a7384400e9d15.jpg', 9, 20, '7/23/2026 11:35:00 AM', N'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (444, N'Tản nhiệt nước AIO MSI MAG CORELIQUID 240R V2', 2250000, N'TDP: 12W', N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/tan-nhiet-nuoc-aio-mag-coreliquid-240r-4.jpg?v=1697040027870', 9, 55, '7/23/2026 11:35:00 AM', N'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (445, N'Tản nhiệt nước AIO ID-COOLING FROSTFLOW X 240 Snow Edition White', 1150000, N'TDP: 10W', N'https://down-vn.img.susercontent.com/file/vn-11134201-23020-tn10ee3ldunv20', 9, 80, '7/23/2026 11:35:00 AM', N'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (446, N'Card màn hình ASUS ROG Strix GeForce RTX 4090 OC Edition 24GB GDDR6X', 54900000, N'TDP: 450W', N'https://dlcdnwebimgs.asus.com/gain/6346BB89-238D-40ED-91B1-D822590E4670/w1000/h732', 10, 10, '7/23/2026 11:35:00 AM', N'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (447, N'Card màn hình MSI GeForce RTX 4080 SUPER 16G GAMING X TRIO', 33500000, N'TDP: 320W', N'https://hanoicomputercdn.com/media/product/79168_card_man_hinh_msi_rtx_4080_super_16g_gaming_x_trio__2_.jpg', 10, 15, '7/23/2026 11:35:00 AM', N'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (448, N'Card màn hình GIGABYTE GeForce RTX 4060 EAGLE OC 8G', 8450000, N'TDP: 115W', N'https://m.media-amazon.com/images/I/71g2Lc8urJL._AC_.jpg', 10, 60, '7/23/2026 11:35:00 AM', N'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (449, N'Card màn hình GIGABYTE GeForce RTX 3050 WINDFORCE OC 6G', 4650000, N'TDP: 70W', N'https://product.hstatic.net/200000722513/product/geforce_rtx__3050_windforce_oc_6g-02_8e038f8bf31d4b008bc170b13dd3cff4.png', 10, 80, '7/23/2026 11:35:00 AM', N'GIGABYTE');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (450, N'Card màn hình ASUS Dual GeForce RTX 4060 Ti EVO OC Edition 8GB', 11250000, N'TDP: 160W', N'https://m.media-amazon.com/images/I/81idjlyCnSL._AC_SL1500_.jpg', 10, 45, '7/23/2026 11:35:00 AM', N'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (451, N'Card màn hình ZOTAC GAMING GeForce RTX 3060 Twin Edge OC 12GB', 7250000, N'TDP: 170W', N'https://res.cloudinary.com/jawa/image/upload/f_auto,c_limit,w_1280,q_auto/production/listings/pcubpf4kb1xn6xd6iklw', 10, 50, '7/23/2026 11:35:00 AM', N'ZOTAC');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (452, N'Card màn hình Sapphire PULSE AMD Radeon RX 7600 8GB GDDR6', 7150000, N'TDP: 165W', N'https://www.minandovoy.com/wp-content/uploads/2023/06/sapphire-pulse-amd-radeon-rx-7600-8gb-gddr6-1500px-v1-0001.jpg', 10, 40, '7/23/2026 11:35:00 AM', N'Sapphire');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (453, N'Card màn hình PowerColor Fighter AMD Radeon RX 6600 8GB GDDR6', 5250000, N'TDP: 132W', N'https://m.media-amazon.com/images/I/81Vtsr0wIVL._AC_.jpg', 10, 55, '7/23/2026 11:35:00 AM', N'PowerColor');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (454, N'Card màn hình ASRock Challenger Radeon RX 7800 XT 16GB OC', 14150000, N'TDP: 263W', N'https://www.asrock.com/Graphics-Card/photo/Radeon%20RX%207800%20XT%20Challenger%2016GB%20OC(M1).png', 10, 30, '7/23/2026 11:35:00 AM', N'ASRock');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (455, N'Card màn hình COLORFUL GeForce GTX 1650 NB 4GD6-V', 3650000, N'TDP: 75W', N'https://tinhungtech.com/watermark/product/1400x1500x2/upload/product/51dmzhei2olsr600315piwhitestripbottomleft035sclzzzzzzzfmpngbg255255255-4585.png', 10, 70, '7/23/2026 11:35:00 AM', N'COLORFUL');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (456, N'Ổ cứng HDD PC Western Digital Purple 2TB 3.5 inch Surveillance', 1650000, N'TDP: 6W', N'https://m.media-amazon.com/images/I/71n-iiLwaIL._AC_.jpg', 11, 90, '7/23/2026 11:35:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (457, N'Ổ cứng HDD PC Western Digital Purple 4TB 3.5 inch Surveillance', 2750000, N'TDP: 7W', N'https://kimostore.net/cdn/shop/files/western-digital-purple-4tb-3-5-inch-surveillance-internal-hard-drive-kimo-store-1_1024x.jpg?v=1715034242', 11, 70, '7/23/2026 11:35:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (458, N'Ổ cứng HDD PC Western Digital Purple 6TB 3.5 inch Surveillance', 4350000, N'TDP: 8W', N'https://m.media-amazon.com/images/I/61oyy18RjsL._AC_SL1500_.jpg', 11, 45, '7/23/2026 11:35:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (459, N'Ổ cứng HDD PC Seagate SkyHawk 2TB 3.5 inch Surveillance', 1550000, N'TDP: 6W', N'https://hanoicomputercdn.com/media/product/35130_hdd_seagate_skyhawk_surveillance_2tb5900_sata_3_64mb_cache_st2000vx008_011.jpg', 11, 85, '7/23/2026 11:35:00 AM', N'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (460, N'Ổ cứng HDD PC Seagate SkyHawk 6TB 3.5 inch Surveillance', 4150000, N'TDP: 8W', N'https://maytinhtrungbac.com/wp-content/uploads/2023/12/HDD9.jpg', 11, 50, '7/23/2026 11:35:00 AM', N'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (461, N'Ổ cứng HDD Server Seagate IronWolf Pro 8TB 3.5 inch NAS', 6150000, N'TDP: 9W', N'https://viettuans.vn/uploads/2024/05/st8000nt001.jpg', 11, 30, '7/23/2026 11:35:00 AM', N'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (462, N'Ổ cứng HDD Server Seagate IronWolf Pro 12TB 3.5 inch NAS', 8950000, N'TDP: 10W', N'https://www.sieuthimaychu.vn/datafiles/setone/15663755172039.jpg', 11, 20, '7/23/2026 11:35:00 AM', N'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (463, N'Ổ cứng HDD Server Western Digital Red Pro 8TB 3.5 inch NAS', 6450000, N'TDP: 9W', N'https://www.tnc.com.vn/uploads/product/sp2025/o-cung-hdd-western-digital-red-pro-nas-8tb-wd8005ffbx.jpg', 11, 25, '7/23/2026 11:35:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (464, N'Ổ cứng HDD Enterprise Seagate Exos X16 14TB 3.5 inch SATA3', 7250000, N'TDP: 10W', N'https://media.loveitopcdn.com/30716/o-cung-hdd-seagate-enterprise-exos-35-sata-x16-14tb-st14000nm001g-13.png', 11, 25, '7/23/2026 11:35:00 AM', N'Seagate');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (465, N'Ổ cứng HDD Enterprise Western Digital Ultrastar DC HC550 18TB', 9450000, N'TDP: 10W', N'https://product.hstatic.net/200000722513/product/o-cung-hdd-18tb-western-digital_17bc422fad9b4f8fb51ec439e3f63a4a_grande.png', 11, 15, '7/23/2026 11:35:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (466, N'Ổ cứng HDD PC Toshiba Canvio Basics 1TB 2.5 inch', 1250000, N'TDP: 4W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mb3gsn7g9uwx71', 11, 110, '7/23/2026 11:35:00 AM', N'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (467, N'Ổ cứng HDD PC Toshiba Surveillance S300 4TB 3.5 inch', 2550000, N'TDP: 7W', N'https://alfathtechnology.com/wp-content/uploads/2025/07/https___static.arvutitark.ee_public_media-hub-olev_2021_10_123986_media-nkeail.jpg', 11, 60, '7/23/2026 11:35:00 AM', N'Toshiba');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (468, N'Ổ cứng HDD Laptop Western Digital Blue 1TB 2.5 inch SATA3', 1150000, N'TDP: 4W', N'https://product.hstatic.net/1000037809/product/thegioigear_hddwdblue1tb_a_a7ff5c32afe747f485c54dd561db1db7_master.jpg', 11, 95, '7/23/2026 11:35:00 AM', N'WD');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (469, N'Nguồn Corsair RM850e ATX 3.0 80 Plus Gold Full Modular (850W)', 3450000, N'TDP: 0W', N'https://product.hstatic.net/200000722513/product/89689_nguon_may_tinh_corsair_rm850e_atx_006_e59a3ebce3034f23aa2bde43f1d242e5_1024x1024.jpg', 12, 50, '7/23/2026 11:35:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (470, N'Nguồn Corsair RM1000x Shift 80 Plus Gold Full Modular (1000W)', 4950000, N'TDP: 0W', N'https://product.hstatic.net/1000037809/product/thegioigear_corsair_rm1000x_1_1c478e5ea1ae485b91e607ee2b71eca7_master.jpg', 12, 30, '7/23/2026 11:35:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (471, N'Nguồn Corsair CV650 650W 80 Plus Bronze', 1450000, N'TDP: 0W', N'https://maytinhdalat.vn/Images/Product/maytinhdalat_nguon-may-tinh-corsair-cv650-650w-80-plus-bronzenguon-may-tinh-corsair-cv650-650w-80-plus-bronze-avt2725337_full_26002022_030016.jpg', 12, 90, '7/23/2026 11:35:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (472, N'Nguồn MSI MAG A650BN 650W 80 Plus Bronze', 1250000, N'TDP: 0W', N'https://halinhcomputer.vn/uploads/images/web-halinh-new/linh-kien-le/psu/mag-a650bn.png', 12, 110, '7/23/2026 11:35:00 AM', N'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (473, N'Nguồn MSI MEG Ai1300P PCIE5 1300W 80 Plus Platinum', 8950000, N'TDP: 0W', N'https://down-sg.img.susercontent.com/file/sg-11134201-22100-ms6oh974ckivaa', 12, 15, '7/23/2026 11:35:00 AM', N'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (474, N'Nguồn ASUS ROG Thor 1000W Platinum II OLED', 8450000, N'TDP: 0W', N'https://songphuong.vn/Content/uploads/2025/06/ROG-THOR-1000P2-2.webp', 12, 20, '7/23/2026 11:35:00 AM', N'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (475, N'Nguồn ASUS TUF Gaming 650B 650W 80 Plus Bronze', 1650000, N'TDP: 0W', N'https://sp-one.vn/Content/uploads/2024/12/69179_asus_tuf_gaming_650w_bronze_sp_picture__1_.jpg', 12, 80, '7/23/2026 11:35:00 AM', N'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (476, N'Nguồn Cooler Master Elite V3 600W 230V', 1050000, N'TDP: 0W', N'https://khoidong.vn/UploadedFiles/baner/psu/52102_cooler_master_elite_v3_230v_pc600_600w_0004_1__1_.jpg', 12, 100, '7/23/2026 11:35:00 AM', N'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (477, N'Nguồn DeepCool PK650D 650W 80 Plus Bronze', 1350000, N'TDP: 0W', N'https://hoanghapccdn.com/media/product/3687_deepcool_pk650_3.jpg', 12, 85, '7/23/2026 11:35:00 AM', N'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (478, N'Nguồn ASRock Phantom Gaming PG-850G 850W 80 Plus Gold', 2950000, N'TDP: 0W', N'https://www.varle.lt/static/uploads/products/1316/asr/asrock-maitinimo-saltinis-pg-850g-850w-80plus-2694fb366e.webp', 12, 40, '7/23/2026 11:35:00 AM', N'ASRock');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (479, N'Vỏ case NZXT H9 Flow Dual-Chamber ATX Mid-Tower Black', 4450000, N'TDP: 0W', N'https://microless.com/cdn/products/d554d168dd1e4febb71cd2cbf0698726-hi.jpg', 13, 30, '7/23/2026 11:35:00 AM', N'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (480, N'Vỏ case NZXT H5 Flow RGB Compact Mid-Tower White', 2650000, N'TDP: 0W', N'https://www.topmarket.co.il/images/detailed/257/OtYnNeyks2.jpg', 13, 50, '7/23/2026 11:35:00 AM', N'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (481, N'Vỏ case Lian Li O11 Dynamic EVO XL Full Tower Black', 5850000, N'TDP: 0W', N'https://www.idcmayoristas.com/wp-content/uploads/2024/10/lian-li-o11dexl-x-o11-dynamic-evo-xl-full-o11dexl-x-us-lal-1.png', 13, 20, '7/23/2026 11:35:00 AM', N'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (482, N'Vỏ case Lian Li Lancool 216 ARGB Mid-Tower Black', 2350000, N'TDP: 0W', N'https://os-jo.com/image/cache/catalog/products/cases/LANCOOL-216/My-project-1200x1200.jpg', 13, 60, '7/23/2026 11:35:00 AM', N'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (483, N'Vỏ case Corsair 3500X ARGB Mid-Tower Glass Black', 2450000, N'TDP: 0W', N'https://kccshop.vn/media/product/250-9689-v----case-corsair-3500x-rgb-tempered-glass-mid-tower-black--cc-9011278-ww--01.jpg', 13, 70, '7/23/2026 11:35:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (484, N'Vỏ case Corsair 5000D AIRFLOW Tempered Glass Mid-Tower White', 3850000, N'TDP: 0W', N'https://cwsmgmt.corsair.com/pdp/5000-series/images/5000d-af-clear-clean-cool.png', 13, 35, '7/23/2026 11:35:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (485, N'Vỏ case MSI MAG FORGE 100M Mid-Tower Black', 1150000, N'TDP: 0W', N'https://gitec.ge/images/thumbs/0063677_msi-mag-forge-100m.jpeg', 13, 90, '7/23/2026 11:35:00 AM', N'MSI');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (486, N'Vỏ case Xigmatek Gaming X 3FX 3 Fan ARGB Black', 850000, N'TDP: 0W', N'https://phucngoc.vn/Data/images/vo-case-xigmatek-master-x-3fx.jpg', 13, 120, '7/23/2026 11:35:00 AM', N'Xigmatek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (487, N'Vỏ case Mik Aios Black Kèm 3 Fan ARGB', 950000, N'TDP: 0W', N'https://tinhocanhphat.vn/media/product/37617_01.jpg', 13, 100, '7/23/2026 11:35:00 AM', N'Mik');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (488, N'Vỏ case SAMA 3509 Black Kèm 3 Fan RGB', 750000, N'TDP: 0W', N'https://m.media-amazon.com/images/I/81EZRt3KIOL._AC_SL1500_.jpg', 13, 110, '7/23/2026 11:35:00 AM', N'SAMA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (489, N'Tản nhiệt khí Thermalright Peerless Assassin 120 White ARGB', 1050000, N'TDP: 5W', N'https://maytinhlmc.vn/wp-content/uploads/72071_peerless_assasin_120_se_white_argb__4_.jpg', 14, 80, '7/23/2026 11:35:00 AM', N'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (490, N'Tản nhiệt khí Thermalright Frost Tower 120 Dual Tower Black', 950000, N'TDP: 5W', N'https://hoanghapccdn.com/media/product/4157_thermalright_frost_tower_120_ha8.jpg', 14, 70, '7/23/2026 11:35:00 AM', N'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (491, N'Tản nhiệt khí DeepCool AK620 Digital ARGB Black Dual Tower', 1850000, N'TDP: 5W', N'https://media.ldlc.com/r1600/ld/products/00/06/05/60/LD0006056050.jpg', 14, 50, '7/23/2026 11:35:00 AM', N'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (492, N'Tản nhiệt khí DeepCool AG400 ARGB Single Tower', 450000, N'TDP: 3W', N'https://ecommerce.datablitz.com.ph/cdn/shop/files/zdfhbsrtg_800x.jpg?v=1739759913', 14, 130, '7/23/2026 11:35:00 AM', N'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (493, N'Tản nhiệt khí Noctua NH-U12S chromax.black Single Tower', 2150000, N'TDP: 4W', N'https://m.media-amazon.com/images/I/81Qu6DEtTlL._SL1500_.jpg', 14, 40, '7/23/2026 11:35:00 AM', N'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (494, N'Tản nhiệt khí Noctua NH-L9i-17xx Low-Profile CPU Cooler', 1350000, N'TDP: 3W', N'https://m.media-amazon.com/images/I/81XLADINZiL.jpg', 14, 60, '7/23/2026 11:35:00 AM', N'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (495, N'Tản nhiệt khí ID-COOLING SE-207-XT Black Dual Tower', 950000, N'TDP: 5W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lxdjem7mcdspfe', 14, 75, '7/23/2026 11:35:00 AM', N'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (496, N'Tản nhiệt khí ID-COOLING FROZN A620 Black Dual Tower', 1150000, N'TDP: 5W', N'https://kccshop.vn/media/product/250-10672-t---n-nhi---t-kh---id-cooling-frozn-a620-black_3_main.jpeg', 14, 65, '7/23/2026 11:35:00 AM', N'ID-COOLING');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (497, N'Tản nhiệt khí Cooler Master MasterAir MA612 Stealth Black', 1750000, N'TDP: 5W', N'https://hoanghapccdn.com/media/product/2166_masterair_ma612_stealth_4_optimized.jpg', 14, 45, '7/23/2026 11:35:00 AM', N'Cooler Master');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (498, N'Tản nhiệt khí Jonsbo CR-1400 ARGB Black', 280000, N'TDP: 2W', N'https://www.tncstore.vn/media/product/12900-tan-nhiet-khi-jonsbo-cr-1400-argb-black-1.jpg', 14, 160, '7/23/2026 11:35:00 AM', N'Jonsbo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (499, N'Bộ 3 Fan tản nhiệt Lian Li UNI FAN TL LCD 120 Reverse Black', 3450000, N'TDP: 4W', N'https://technicstore.net/wp-content/uploads/2024/01/TL120-LCD-REVERSE-3IN1-BLACK-2.jpg', 15, 30, '7/23/2026 11:35:00 AM', N'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (500, N'Bộ 3 Fan tản nhiệt Lian Li UNI FAN AL120 V2 ARGB Black', 2150000, N'TDP: 3W', N'https://images.tcdn.com.br/img/img_prod/1362985/kit_cooler_fan_lian_li_uni_fan_al120_v2_120mm_3_un_preto_argb_2000_rpm_modular_uf_al120v2_3b_1747_2_cd18221530e72d4d8e615bcff1e491dc.jpg', 15, 50, '7/23/2026 11:35:00 AM', N'Lian Li');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (501, N'Bộ 3 Fan tản nhiệt Corsair LL120 RGB 120mm Dual Light Loop White', 2650000, N'TDP: 3W', N'https://minhancomputercdn.com/media/product/8348_qu___t_t___n_nhi___t_case_corsair_ll120_rgb_white.jpg', 15, 45, '7/23/2026 11:35:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (502, N'Bộ 3 Fan tản nhiệt Corsair SP120 RGB ELITE 120mm PWM Triple Pack', 1650000, N'TDP: 3W', N'https://cellphones.com.vn/media/catalog/product/t/e/text_ng_n_16__1_10.png', 15, 60, '7/23/2026 11:35:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (503, N'Bộ 3 Fan tản nhiệt NZXT F120 RGB Core Triple Pack White', 1850000, N'TDP: 3W', N'https://hanoicomputercdn.com/media/product/75643_fan_case_t___n_nhi___t_nzxt_f120rgb_core_triple_pack_white__3_.jpg', 15, 55, '7/23/2026 11:35:00 AM', N'NZXT');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (504, N'Bộ 3 Fan tản nhiệt DeepCool FC120 White 3-in-1 ARGB', 890000, N'TDP: 3W', N'https://nguyenvu-store-medias.tn-cdn.net/2023/07/quat-tan-nhiet-deepcool-fc120-3-in-1-trang-8.jpg', 15, 80, '7/23/2026 11:35:00 AM', N'DeepCool');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (505, N'Bộ 3 Fan tản nhiệt Thermalright TL-C12C-S X3 White ARGB', 490000, N'TDP: 2W', N'https://nvs.tn-cdn.net/2024/07/Bo-3-Quat-Tan-Nhiet-Thermalright-TL-C12C-S-X3-White-1.jpg', 15, 110, '7/23/2026 11:35:00 AM', N'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (506, N'Bộ 3 Fan tản nhiệt Thermalright TL-K12 ARGB High-Performance', 650000, N'TDP: 2W', N'https://www.thermalright.com/wp-content/uploads/2023/08/1-10.jpg', 15, 90, '7/23/2026 11:35:00 AM', N'Thermalright');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (507, N'Bộ 3 Fan tản nhiệt Montech RX120 PWM Reverse ARGB Pack', 690000, N'TDP: 2W', N'https://cdn0.centrecom.com.au/images/upload/0196456_0.jpeg', 15, 85, '7/23/2026 11:35:00 AM', N'Montech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (508, N'Bộ 3 Fan tản nhiệt Xigmatek Galaxy II Pro ARGB 3 Fan Pack', 450000, N'TDP: 2W', N'https://alfrensia.com/wp-content/uploads/2022/02/EN42128.jpg', 15, 120, '7/23/2026 11:35:00 AM', N'Xigmatek');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (509, N'Bộ 3 Fan tản nhiệt Mik Halo ARGB 3 Fan Pack Black', 380000, N'TDP: 2W', N'https://down-vn.img.susercontent.com/file/e9fdd00372700ad2f4ba6850323cb2cd', 15, 130, '7/23/2026 11:35:00 AM', N'Mik');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (510, N'Bộ 3 Fan tản nhiệt SAMA Halo ARGB Kit 3 Fan kèm Hub Remote', 350000, N'TDP: 2W', N'https://down-br.img.susercontent.com/file/br-11134207-7r98o-lq1zxlij2scj37', 15, 140, '7/23/2026 11:35:00 AM', N'SAMA');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (511, N'Fan tản nhiệt lẻ Noctua NF-A12x25 PWM chromax.black', 850000, N'TDP: 1W', N'https://img.lazcdn.com/g/p/49953f3cb62b53c5f0957a3e1e1ce96f.jpg_720x720q80.jpg', 15, 90, '7/23/2026 11:35:00 AM', N'Noctua');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (512, N'Fan tản nhiệt lẻ Arctic P12 PWM PST Black 120mm', 220000, N'TDP: 1W', N'https://pcngon.vn/wp-content/uploads/2024/09/Quat-tan-nhiet-Arctic-P12-PWM-PST-Black-4.png', 15, 200, '7/23/2026 11:35:00 AM', N'Arctic');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (513, N'Bàn phím cơ AKKO 5075B Plus Dragon Ball Z Wireless RGB', 2350000, N'TDP: 2W', N'https://phucanhcdn.com/media/product/50772_ban_phim_co_akko_khong_day_5075b_plus_dragon_ball_super_goku_8.jpg', 16, 40, '7/23/2026 11:35:00 AM', N'AKKO');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (514, N'Bàn phím cơ AKKO MonsGeek M1 V2 Kit Nhôm CNC Hotswap', 1850000, N'TDP: 1W', N'https://cf.shopee.vn/file/sg-11134201-22110-noy506z680jvf2', 16, 50, '7/23/2026 11:35:00 AM', N'AKKO');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (515, N'Bàn phím cơ Keychron K2 Pro Wireless Bluetooth QMK/VIA Gateron', 2150000, N'TDP: 2W', N'https://product.hstatic.net/1000187560/product/ban-phim-co-keychron-k2-pro-qmkvia-album-svf-thinkpro.vn_a9824fcb4b79456fa624cc6cf1c834cc_large.jpg', 16, 60, '7/23/2026 11:35:00 AM', N'Keychron');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (516, N'Bàn phím cơ Keychron Q1 Max Full Aluminum Wireless Custom', 4650000, N'TDP: 2W', N'https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Q1-Max-7.jpg?v=1701051646', 16, 25, '7/23/2026 11:35:00 AM', N'Keychron');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (517, N'Bàn phím cơ Logitech G Pro X TKL LIGHTSPEED Wireless Black', 4150000, N'TDP: 2W', N'https://www.tncstore.vn/media/product/13847-ban-phim-co-logitech-g-pro-x-tkl-lightspeed-tactile-switch-black.jpg', 16, 35, '7/23/2026 11:35:00 AM', N'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (518, N'Bàn phím cơ Razer BlackWidow V4 Pro Mechanical Gaming Keyboard', 5450000, N'TDP: 3W', N'https://owlgaming.vn/wp-content/uploads/2024/07/Ban-phim-Razer-BlackWidow-V4-Pro-3.jpg', 16, 20, '7/23/2026 11:35:00 AM', N'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (519, N'Bàn phím cơ Corsair K70 RGB PRO Mechanical Gaming Keyboard', 3650000, N'TDP: 2W', N'https://assets.corsair.com/image/upload/c_pad,q_auto,h_1024,w_1024,f_auto/products/Gaming-Keyboards/CH-910941A-NA/Gallery/K70_PRO_OPX_PBT_01.webp', 16, 45, '7/23/2026 11:35:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (520, N'Bàn phím cơ SteelSeries Apex Pro TKL Wireless', 5950000, N'TDP: 2W', N'https://owlgaming.vn/wp-content/uploads/2024/10/ban-phim-steelseries-apex-pro-tkl-wireless-gen-3.jpg', 16, 20, '7/23/2026 11:35:00 AM', N'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (521, N'Bàn phím cơ ASUS ROG Azoth Wireless Custom Gaming Keyboard', 6850000, N'TDP: 3W', N'https://pcmarket.vn/media/product/10986_ban_phim_co_gaming_asus_rog_azoth_white_pcm_6.jpg', 16, 15, '7/23/2026 11:35:00 AM', N'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (522, N'Bàn phím cơ Dareu EK87 V2 Multi-LED Tenkeyless Black', 450000, N'TDP: 1W', N'https://dareu.com.vn/wp-content/uploads/2024/09/ban-phim-co-gaming-dareu-ek87-v2-white-black-01-800x800.jpg', 16, 120, '7/23/2026 11:35:00 AM', N'Dareu');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (523, N'Chuột máy tính Logitech G Pro X Superlight 2 Wireless Black', 3450000, N'TDP: 1W', N'https://www.tncstore.vn/media/product/250-9061-chuot-logitech-g-pro-x-superlight-2-wireless-12.jpg', 17, 50, '7/23/2026 11:35:00 AM', N'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (524, N'Chuột máy tính Logitech G502 X PLUS LIGHTSPEED Wireless RGB', 3650000, N'TDP: 1W', N'https://cf.shopee.vn/file/vn-11134207-7qukw-liqvq05531le30', 17, 40, '7/23/2026 11:35:00 AM', N'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (525, N'Chuột máy tính Razer DeathAdder V3 Pro Wireless Ultra-Lightweight', 3250000, N'TDP: 1W', N'https://www.tncstore.vn/media/product/250-8340-razer-deathadder-v3-pro-ergonomic-white.jpg', 17, 45, '7/23/2026 11:35:00 AM', N'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (526, N'Chuột máy tính Razer Viper V3 Pro Ultra-Lightweight Wireless', 3850000, N'TDP: 1W', N'https://down-vn.img.susercontent.com/file/vn-11134207-820l4-mjnkr1p25hxcb7', 17, 35, '7/23/2026 11:35:00 AM', N'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (527, N'Chuột máy tính SteelSeries Aerox 3 Wireless Onyx Superlight', 1850000, N'TDP: 1W', N'https://product.hstatic.net/200000722513/product/79114_chuot_gaming_co_day_steels__4__1680bb5be04b4b0bae3bfe8d3ebc5866_1024x1024.png', 17, 60, '7/23/2026 11:35:00 AM', N'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (528, N'Chuột máy tính Corsair M65 RGB ULTRA Wireless Gaming Mouse', 2450000, N'TDP: 1W', N'https://media.ldlc.com/r1600/ld/products/00/05/98/52/LD0005985249.jpg', 17, 50, '7/23/2026 11:35:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (529, N'Chuột máy tính ASUS ROG Keris II Ace Ultra-Lightweight Wireless', 3150000, N'TDP: 1W', N'https://dlcdnwebimgs.asus.com/gain/9B783ACB-999D-41F3-AC55-7859FB30C90B/w717/h525', 17, 40, '7/23/2026 11:35:00 AM', N'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (530, N'Chuột máy tính Dareu EM901X RGB Wireless kèm Đế sạc', 590000, N'TDP: 1W', N'https://down-vn.img.susercontent.com/file/4b69f9c29485d36dc60c76a0656450f5', 17, 100, '7/23/2026 11:35:00 AM', N'Dareu');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (531, N'Chuột máy tính Rapoo VT9 PRO Dual-Mode Wireless Gaming Mouse', 790000, N'TDP: 1W', N'https://rapoostore.vn/wp-content/uploads/2024/05/Chuot-gaming-rapoo-vt9prodm.jpg', 17, 90, '7/23/2026 11:35:00 AM', N'Rapoo');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (532, N'Chuột máy tính Fantech Helios II Pro XD3 V3 Wireless', 1250000, N'TDP: 1W', N'https://down-id.img.susercontent.com/file/id-11134208-7r98x-lxuwkmyu8eq237', 17, 70, '7/23/2026 11:35:00 AM', N'Fantech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (533, N'Tai nghe gaming HyperX Cloud III Wireless Black/Red 120-Hour Battery', 3850000, N'TDP: 1W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mdodsk4dl57wd1', 18, 40, '7/23/2026 11:35:00 AM', N'HyperX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (534, N'Tai nghe gaming HyperX Cloud Stinger 2 Core Gaming Headset', 850000, N'TDP: 1W', N'https://api.combatgaming.vn/api-v2/image/id/6475b8db5317487ebf3353ba', 18, 90, '7/23/2026 11:35:00 AM', N'HyperX');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (535, N'Tai nghe gaming Razer BlackShark V2 Pro Wireless 2023 Edition', 4450000, N'TDP: 1W', N'https://m.media-amazon.com/images/I/71ZTXGr2g0L._AC_SL1500_.jpg', 18, 35, '7/23/2026 11:35:00 AM', N'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (536, N'Tai nghe gaming Razer Kraken Kitty V2 Pro RGB Quartz Pink', 4250000, N'TDP: 2W', N'https://laptopworld.vn/media/product/16639_76012_tai_nghe_gaming_co_day_razer_kraken_kitty_v2_pro_2023_edition_rgb_pink___rz04_04510200_r3m1_1.jpg', 18, 30, '7/23/2026 11:35:00 AM', N'Razer');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (537, N'Tai nghe gaming Logitech G PRO X 2 LIGHTSPEED Wireless Graphene', 5650000, N'TDP: 1W', N'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/tai-nghe-gaming-khong-day-logitech-pro-x-2-lightspeed-04.jpg?v=1692592084127', 18, 25, '7/23/2026 11:35:00 AM', N'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (538, N'Tai nghe gaming Logitech G733 LIGHTSPEED Wireless RGB White', 2950000, N'TDP: 1W', N'https://cdn.hstatic.net/products/200001100406/tai_nghe_gaming_logitech_g733_lightspeed_wireless_7_1_rgb_white_0002_3_64418de1b9874a0eb7bceb6feb305dfe_master.jpg', 18, 50, '7/23/2026 11:35:00 AM', N'Logitech');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (539, N'Tai nghe gaming SteelSeries Arctis Nova Pro Wireless PC/PlayStation', 8950000, N'TDP: 2W', N'https://product.hstatic.net/200000637319/product/va_pro_black_3_v2.png__1850x800_q100_crop-scale_optimize_subsampling-2_9a2aba505a3a4d3d8f7786bc0fc355f6_master.png', 18, 15, '7/23/2026 11:35:00 AM', N'SteelSeries');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (540, N'Tai nghe gaming Corsair VIRTUOSO RGB WIRELESS High-Fidelity', 4850000, N'TDP: 2W', N'https://res.cloudinary.com/corsair-pwa/image/upload/v1665096094/akamai/landing/virtuoso/assets/images/VIRTUOSO-White.png', 18, 30, '7/23/2026 11:35:00 AM', N'Corsair');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (541, N'Tai nghe gaming ASUS ROG Pugi III Delta S Animate Display', 5250000, N'TDP: 2W', N'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-mbacj96f7nivf2', 18, 20, '7/23/2026 11:35:00 AM', N'ASUS');
INSERT INTO products (id, name, price, description, image, category_id, stock, created_at, brand) VALUES (542, N'Tai nghe gaming Dareu EH722X 7.1 Surround Sound Pink', 490000, N'TDP: 1W', N'https://songphuong.vn/Content/uploads/2021/08/Tai-nghe-DareU-EH722X-7.1-PINK-3.jpg', 18, 110, '7/23/2026 11:35:00 AM', N'Dareu');

SET IDENTITY_INSERT products OFF;


-- Dumping data for table vouchers
SET IDENTITY_INSERT vouchers ON;
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES (2, 1, 'LXR36', '2026-06-22 10:52:53.047', N'Giảm giá 15% các mặt hàng', 'PERCENTAGE', 15, '2026-06-30 00:00:00', 50000, 10000, NULL, 100, 2, NULL);
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES (4, 1, 'LUX50', '2026-06-23 17:08:51.75', N'giảm giá 50', 'PERCENTAGE', 50, '2026-06-30 12:00:00', 10000000, 1000000, NULL, 10, 0, NULL);
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES (3, 1, 'LUX30', '2026-06-22 11:22:49.617', N'Giảm giá 30%', 'PERCENTAGE', 30, '2026-08-11 12:00:00', 5000000, 0, NULL, 0, 0, NULL);
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES (5, 1, 'LUX10', '2026-07-02 11:00:17.172', N'Giảm 10% cho tất cả đơn hàng', 'PERCENTAGE', 10, '2026-07-31 12:00:00', 10000000, 0, NULL, 10, 2, NULL);
SET IDENTITY_INSERT vouchers OFF;
GO

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
GO

-- Thêm cột lưu phí vận chuyển của đơn hàng
ALTER TABLE orders ADD shipping_fee FLOAT NOT NULL DEFAULT 0;

-- Thêm cột lưu tên phương thức vận chuyển (vd: Giao hàng hỏa tốc, Tiêu chuẩn)
ALTER TABLE orders ADD shipping_method_name NVARCHAR(255);

SELECT * FROM orders;
GO

DELETE FROM orders;
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM vouchers;
DELETE FROM user_vouchers;
DBCC CHECKIDENT ('order_items', RESEED, 0);
DBCC CHECKIDENT ('orders', RESEED, 0);

DELETE FROM orders;
GO

SELECT
    fk.name AS ForeignKey,
    OBJECT_NAME(fkc.parent_object_id) AS ChildTable,
    c.name AS ChildColumn
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc
    ON fk.object_id = fkc.constraint_object_id
JOIN sys.columns c
    ON c.object_id = fkc.parent_object_id
   AND c.column_id = fkc.parent_column_id
WHERE OBJECT_NAME(fkc.referenced_object_id) = 'orders';

BEGIN TRANSACTION;

DELETE FROM sepay_payment_sessions;

DELETE FROM order_items;

DELETE FROM orders;

COMMIT;

-- Dumping data for table orders
SET IDENTITY_INSERT orders ON;
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (26, NULL, 31000000, 'Chờ thanh toán', 'DH26', 'md', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-07 11:21:45.734');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (2, NULL, 8500000, 'Đã hủy', 'COD-PENDING', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-18 00:12:47.414');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (10, NULL, 213800000, 'COMPLETED', 'DH10', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-20 23:44:16.695');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (17, 5, 2, 'PENDING', 'DH17', N'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', N'7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-22 11:19:22.674');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (18, 5, 3550000, 'SHIPPING', 'DH18', 'Thanh Pham', 'leecookcu@gmail.com', '0902208461', 'TPHCM', NULL, 50000, 'LXR36', NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-23 17:04:56.396');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (19, 5, 10900000, 'PENDING', 'DH19', 'Thanh Pham', 'leecookcu@gmail.com', '0902208461', 'TPHCM', NULL, 500000, 'LXR500', NULL, 0.00, NULL, 'INSTALLMENT', NULL, NULL, NULL, NULL, NULL, '2026-06-23 17:52:55.979');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (20, 2, 6500000, 'PENDING', 'DH20', N'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', 'tp', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-29 21:15:31.495');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (21, 5, 90000000, 'PENDING', 'DH21', N'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', N'7/134/29/9 đường liên khu 5-6', NULL, 10000000, 'LUX10', NULL, 0.00, NULL, 'INSTALLMENT', NULL, NULL, NULL, NULL, NULL, '2026-07-02 11:03:00.775');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (22, NULL, 90000000, 'PENDING', 'DH22', N'Phạm Công Thanh', NULL, '0902208461', N'7/134/29/9 đường liên khu 5-6', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-02 13:03:06.903');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (23, NULL, 120000000, 'PENDING', 'DH23', N'Phạm Công Thanh', NULL, '0902208461', N'7/134/29/9 đường liên khu 5-6', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-02 13:03:58.891');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (24, 2, 5600000, 'PENDING', 'DH24', N'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', 'tp', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-03 09:00:31.482');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (25, 2, 7200000, 'Chờ thanh toán', 'DH25', N'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', 'tp', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-03 09:05:44.01');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (27, NULL, 6200000, 'PENDING', 'DH27', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07 11:22:24.148');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (28, NULL, 1950000, 'PENDING', 'DH28', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07 17:24:58.208');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (29, NULL, 1950000, 'PENDING', 'DH29', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07 18:17:37.769');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (30, 7, 1950000, 'THU_HOI', 'DH30', 'tuan nguyen', 'tuannguyennasani@gmail.com', '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07 19:57:59.626');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (1, NULL, 17200000, 'Chờ thanh toán', 'VIETQR-WAITING', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-06-19 00:12:46.958');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (3, NULL, 25900000, 'Đã thanh toán', 'VIETQR-PAID', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-06-17 00:12:47.866');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (6, NULL, 12500000, 'COMPLETED', 'VOUCHER-COMPLETED', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, 500000, 'QA500K', NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-14 00:12:49.207');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (5, NULL, 6900000, 'COMPLETED', 'CANCELLED', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-15 00:12:48.753');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (4, NULL, 18600000, 'DA_HOAN_TIEN', 'DH63', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', N'OK | Đã hoàn', 'Đã thanh toán', N'Khách muốn trả hàng vì sản phẩm không phù hợp', NULL, NULL, '2026-06-16 00:12:48.31');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (31, 2, 190400000, 'PAID', 'DH31', 'tuan nguyen', 'tuan9bledinhchinh@gmail.com', '0905338411', N'thon tan quang, Phường Ngô Quyền, Thành phố Bắc Giang, Tỉnh Bắc Giang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-11 16:11:46.406');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (8, NULL, 21500000, 'DA_HOAN_TIEN', 'DH62', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', N'Đã hoàn tiền qua MB Bank', 'Đã thanh toán', N'Khách yêu cầu hoàn tiền', NULL, NULL, '2026-06-12 00:12:50.287');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (9, NULL, 15700000, 'THU_HOI', 'DH61', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', N'Thu hồi theo yêu cầu kiểm thử', 'Đã thanh toán', N'Khách yêu cầu trả hàng', NULL, NULL, '2026-06-11 00:12:50.817');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (7, NULL, 19900000, 'THU_HOI', 'DH60', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', N'Admin đã duyệt yêu cầu hoàn tiền', 'Đã thanh toán', N'Khách yêu cầu hoàn tiền', NULL, NULL, '2026-06-13 00:12:49.74');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (11, NULL, 150000000, 'COMPLETED', 'MAR-1', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-15 10:00:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (12, NULL, 220000000, 'COMPLETED', 'MAR-2', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-25 14:30:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (13, NULL, 185000000, 'COMPLETED', 'APR-1', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-10 09:15:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (14, NULL, 315000000, 'COMPLETED', 'APR-2', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-20 16:45:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (15, NULL, 280000000, 'COMPLETED', 'MAY-1', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-05 11:20:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (16, NULL, 195000000, 'COMPLETED', 'MAY-2', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-18 13:10:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (38, 3, 10000, 'Chờ thanh toán', 'DH38', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Nam Ka, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 19:05:37.372');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (39, 3, 10000, 'Chờ thanh toán', 'DH39', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea Ning, Huyện Cư Kuin, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 19:10:23.876');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (40, 3, 10000, 'Chờ thanh toán', 'DH40', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea Ning, Huyện Cư Kuin, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 19:53:25.074');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (41, 3, 10000, 'Chờ thanh toán', 'DH41', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea R''Bin, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 20:34:44.343');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (32, 9, 600000, 'COMPLETED', 'DH32', N'Nguyễn Trường Quân', 'truongquan577@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-13 22:22:01.34');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (33, 5, 825000000, 'COMPLETED', 'DH33', N'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', N'7/134/29/9 đường liên khu 5-6, Phường Hàng Trống, Quận Hoàn Kiếm, Thành phố Hà Nội', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-14 13:43:34.142');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (34, 2, 2375000, 'PENDING', 'DH34', N'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', N'tp, Xã Yên Sơn, Huyện Yên Châu, Tỉnh Sơn La', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-14 16:50:43.95');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (35, 3, 600000, 'Chờ thanh toán', 'DH35', N'Quân Nguyễn Trường', 'nguyentruongq169@gmail.com', '0867868825', N'q, Xã Tiền Tiến, Thành phố Hải Dương, Tỉnh Hải Dương', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 17:30:01.596');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (36, 3, 8500000, 'PENDING', 'DH36', N'Quân Nguyễn Trường', 'nguyentruongq169@gmail.com', '0867868825', N'q, Xã Tiền Tiến, Thành phố Hải Dương, Tỉnh Hải Dương', NULL, 0, NULL, NULL, 0.00, NULL, 'EWALLET', NULL, NULL, NULL, NULL, NULL, '2026-07-14 17:30:49.368');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (37, 3, 8500000, 'Chờ thanh toán', 'DH37', N'Quân Nguyễn Trường', 'nguyentruongq169@gmail.com', '0867868825', N'q, Xã Tiền Tiến, Thành phố Hải Dương, Tỉnh Hải Dương', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 17:32:25.37');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (42, 3, 10000, 'Chờ thanh toán', 'DH42', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Nam Ka, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 21:46:26.074');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (43, 3, 10000, 'Chờ thanh toán', 'DH43', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Nam Ka, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 22:07:27.131');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (44, 3, 10000, 'Đã thanh toán', 'DH44', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea BHốk, Huyện Cư Kuin, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 22:10:45.309');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (45, 3, 10000, 'Đã thanh toán', 'DH45', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Cư Klông, Huyện Krông Năng, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 22:15:01.122');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (46, NULL, 16500000, 'PENDING', 'DH46', N'Phạm Công Thanh', NULL, '0902208461', N'7/134/29/9 đường liên khu 5-6, Phường Hợp Giang, Thành phố Cao Bằng, Tỉnh Cao Bằng', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-15 13:09:04.701');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (47, 5, 1620000, 'PENDING', 'DH47', N'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', N'7/134/29/9 đường liên khu 5-6, Phường Phúc Xá, Quận Ba Đình, Thành phố Hà Nội', NULL, 0, NULL, NULL, 0.00, NULL, 'INSTALLMENT', NULL, NULL, NULL, NULL, NULL, '2026-07-15 17:26:21.271');
SET IDENTITY_INSERT orders OFF;
GO

SELECT * FROM orders;
GO

-- Dumping data for table order_items
SET IDENTITY_INSERT order_items ON;
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
SET IDENTITY_INSERT order_items OFF;
GO

-- Dumping data for table reviews
SET IDENTITY_INSERT reviews ON;
INSERT INTO reviews (id, content, created_at, stars, user_id, product_id, order_id, title, image, video) VALUES (1, N'Máy build từ Luxury PC chạy mượt như mơ. RTX 4090 kết hợp với i9-14900K — không có game nào kháng cự được. Đáng từng đồng bỏ ra.', '2026-06-02 19:05:41.163089', 5, 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO reviews (id, content, created_at, stars, user_id, product_id, order_id, title, image, video) VALUES (2, N'Dịch vụ tư vấn chuyên nghiệp, lắp ráp cực kỳ thẩm mỹ. Tôi rất hài lòng với chiếc Workstation mới này.', '2026-06-02 19:05:41.163089', 5, 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO reviews (id, content, created_at, stars, user_id, product_id, order_id, title, image, video) VALUES (3, N'Bảo hành nhanh chóng, nhân viên nhiệt tình hỗ trợ. Xứng đáng với danh hiệu Luxury PC.', '2026-06-02 19:05:41.163089', 4, 1, NULL, NULL, NULL, NULL, NULL);
SET IDENTITY_INSERT reviews OFF;
GO

-- Dumping data for table wishlist_items
SET IDENTITY_INSERT wishlist_items ON;
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (1, '2026-06-29 21:14:37.8', 23, 2);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (2, '2026-07-14 11:28:57.94', 280, 5);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (3, '2026-07-14 11:29:01.571', 281, 5);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (4, '2026-07-14 11:29:04.825', 259, 5);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (5, '2026-07-14 11:48:13.712', 283, 5);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (6, '2026-07-14 12:01:09.248', 256, 5);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (7, '2026-07-14 13:44:58.85', 278, 5);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (8, '2026-07-14 14:29:47.096', 284, 5);
INSERT INTO wishlist_items (id, created_at, product_id, user_id) VALUES (9, '2026-07-16 09:09:11.326', 57, 5);
SET IDENTITY_INSERT wishlist_items OFF;
GO

-- Dumping data for table inventory
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

-- Dumping data for table stock_movements
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

-- Dumping data for table flash_sale_items
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

-- Dumping data for table pc_combo_details
SET IDENTITY_INSERT pc_combo_details ON;
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
SET IDENTITY_INSERT pc_combo_details OFF;
GO

-- Dumping data for table user_vouchers
SET IDENTITY_INSERT user_vouchers ON;
INSERT INTO user_vouchers (id, user_id, voucher_id, saved_at, used_at, reservation_expires_at, status) VALUES (1, 2, 1, '2026-07-18 17:47:03.908000', NULL, NULL, N'AVAILABLE');
INSERT INTO user_vouchers (id, user_id, voucher_id, saved_at, used_at, reservation_expires_at, status) VALUES (2, 2, 2, '2026-07-18 19:17:53.976000', NULL, NULL, N'AVAILABLE');
SET IDENTITY_INSERT user_vouchers OFF;
GO

-- Dumping data for table chat_messages
SET IDENTITY_INSERT chat_messages ON;
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (1, '2026-07-13 19:25:31.798', 'j', 'ADMIN', 'tuan9bledinhchinh@gmail.com', 7);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (2, '2026-07-14 09:45:55.056', N'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', '36', 8);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (3, '2026-07-14 09:45:58.208', 'cc', 'CUSTOMER', '36', 8);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (4, '2026-07-14 09:45:59.481', N'Cảm ơn bạn đã nhắn tin cho ban hỗ trợ khách hàng Luxury PC. Nhân viên tư vấn đang kiểm tra thông tin và sẽ phản hồi chi tiết tới bạn trong giây lát! Bạn vui lòng đợi 1-2 phút nhé. 💬', 'ADMIN', 'tuan9bledinhchinh@gmail.com', 8);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (5, '2026-07-14 09:46:00.771', 'c', 'CUSTOMER', '36', 8);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (6, '2026-07-14 09:46:02.628', N'Cảm ơn bạn đã nhắn tin cho ban hỗ trợ khách hàng Luxury PC. Nhân viên tư vấn đang kiểm tra thông tin và sẽ phản hồi chi tiết tới bạn trong giây lát! Bạn vui lòng đợi 1-2 phút nhé. 💬', 'ADMIN', 'tuan9bledinhchinh@gmail.com', 8);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (7, '2026-07-14 09:46:05.48', 'c', 'CUSTOMER', '36', 8);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (8, '2026-07-14 09:46:06.633', N'Cảm ơn bạn đã nhắn tin cho ban hỗ trợ khách hàng Luxury PC. Nhân viên tư vấn đang kiểm tra thông tin và sẽ phản hồi chi tiết tới bạn trong giây lát! Bạn vui lòng đợi 1-2 phút nhé. 💬', 'ADMIN', 'tuan9bledinhchinh@gmail.com', 8);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (9, '2026-07-14 13:29:48.682', N'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', 'Thanh', 9);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (10, '2026-07-14 13:30:09.937', N'alo em à em', 'CUSTOMER', 'Thanh', 9);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (11, '2026-07-14 13:30:11.141', N'Cảm ơn bạn đã nhắn tin cho ban hỗ trợ khách hàng Luxury PC. Nhân viên tư vấn đang kiểm tra thông tin và sẽ phản hồi chi tiết tới bạn trong giây lát! Bạn vui lòng đợi 1-2 phút nhé. 💬', 'ADMIN', 'leecookcu@gmail.com', 9);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (12, '2026-07-14 17:19:19.185', N'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', '36', 10);
INSERT INTO chat_messages (id, created_at, message, sender, sender_name, ticket_id) VALUES (13, '2026-07-15 10:47:51.945', N'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.', 'CUSTOMER', 'Thanh', 11);
SET IDENTITY_INSERT chat_messages OFF;
GO

-- ----------------------------
-- Table structure & sample data for news_categories
-- ----------------------------
IF NOT EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'news_categories') AND type IN ('U'))
BEGIN
    CREATE TABLE news_categories (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(100) NOT NULL,
        slug NVARCHAR(100) NOT NULL UNIQUE,
        description NVARCHAR(MAX),
        status NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
        created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
    );
END;
GO

SET IDENTITY_INSERT news_categories ON;
IF NOT EXISTS (SELECT 1 FROM news_categories WHERE id = 1) INSERT INTO news_categories (id, name, slug, status) VALUES (1, N'Card Đồ Họa', 'card-do-hoa', 'ACTIVE');
IF NOT EXISTS (SELECT 1 FROM news_categories WHERE id = 2) INSERT INTO news_categories (id, name, slug, status) VALUES (2, N'Bộ Vi Xử Lý (CPU)', 'bo-vi-xu-ly', 'ACTIVE');
IF NOT EXISTS (SELECT 1 FROM news_categories WHERE id = 3) INSERT INTO news_categories (id, name, slug, status) VALUES (3, N'Khuyến Mãi & Sự Kiện', 'khuyen-mai-su-kien', 'ACTIVE');
IF NOT EXISTS (SELECT 1 FROM news_categories WHERE id = 4) INSERT INTO news_categories (id, name, slug, status) VALUES (4, N'Tư Vấn Cấu Hình', 'tu-van-cau-hinh', 'ACTIVE');
IF NOT EXISTS (SELECT 1 FROM news_categories WHERE id = 5) INSERT INTO news_categories (id, name, slug, status) VALUES (5, N'Lưu Trữ (SSD/HDD)', 'luu-tru-ssd-hdd', 'ACTIVE');
IF NOT EXISTS (SELECT 1 FROM news_categories WHERE id = 6) INSERT INTO news_categories (id, name, slug, status) VALUES (6, N'Mẹo & Thủ Thuật', 'meo-thu-thuat', 'ACTIVE');
SET IDENTITY_INSERT news_categories OFF;
GO

-- ----------------------------
-- Table structure & sample data for news
-- ----------------------------
IF NOT EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'news') AND type IN ('U'))
BEGIN
    CREATE TABLE news (
        id INT IDENTITY(1,1) PRIMARY KEY,
        title NVARCHAR(255) NOT NULL,
        slug NVARCHAR(255) NOT NULL UNIQUE,
        content NVARCHAR(MAX) NOT NULL,
        summary NVARCHAR(MAX) NOT NULL,
        thumbnail NVARCHAR(255),
        view_count BIGINT DEFAULT 0,
        meta_title NVARCHAR(255),
        meta_description NVARCHAR(MAX),
        meta_keywords NVARCHAR(255),
        status NVARCHAR(20) DEFAULT 'PUBLISHED',
        category_id INT FOREIGN KEY REFERENCES news_categories(id),
        author_id INT NOT NULL FOREIGN KEY REFERENCES users(id),
        created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME2 DEFAULT CURRENT_TIMESTAMP
    );
END;
GO

INSERT INTO news (content, created_at, slug, summary, thumbnail, title, updated_at, author_id, meta_description, meta_keywords, meta_title, view_count, category_id, status)
VALUES
(N'<h2>RTX 5060 chính thức ra mắt</h2><p>NVIDIA đã giới thiệu RTX 5060 với kiến trúc Blackwell, hỗ trợ DLSS 4 và Ray Tracing thế hệ mới.</p><ul><li>Hiệu năng tăng khoảng 30% so với RTX 4060</li><li>Chơi game 2K mượt mà</li><li>Tiêu thụ điện thấp hơn</li></ul>',
GETDATE(), 'rtx-5060-ra-mat', N'NVIDIA RTX 5060 mang đến hiệu năng mạnh mẽ cho game thủ và người sáng tạo nội dung.', 'rtx5060.jpg', N'RTX 5060 chính thức ra mắt', GETDATE(), (SELECT TOP 1 id FROM users), N'Đánh giá RTX 5060 mới nhất.', 'RTX5060,NVIDIA,GPU,Gaming', N'RTX 5060 chính thức ra mắt', 120, 1, 'PUBLISHED'),
(N'<h2>Top 5 CPU Gaming 2026</h2><p>Danh sách CPU đáng mua nhất dành cho game thủ.</p><ol><li>Ryzen 5 9600X</li><li>Ryzen 7 9800X3D</li><li>Core i5-15600K</li><li>Core i7-15700K</li><li>Ryzen 9 9950X</li></ol>',
GETDATE(), 'top-cpu-gaming-2026', N'Những bộ vi xử lý tốt nhất dành cho game thủ năm 2026.', 'cpu2026.jpg', N'Top 5 CPU Gaming đáng mua năm 2026', GETDATE(), (SELECT TOP 1 id FROM users), N'Danh sách CPU Intel và AMD mạnh nhất.', 'CPU,Intel,AMD,Gaming', N'Top CPU Gaming 2026', 85, 2, 'PUBLISHED'),
(N'<h2>Flash Sale cuối tuần</h2><p>Giảm giá đến 40% cho nhiều linh kiện PC.</p><p>Áp dụng cho VGA, RAM, SSD và Mainboard.</p>',
GETDATE(), 'flash-sale-cuoi-tuan', N'Chương trình Flash Sale cuối tuần với hàng trăm ưu đãi hấp dẫn.', 'flashsale.jpg', N'Flash Sale cuối tuần giảm đến 40%', GETDATE(), (SELECT TOP 1 id FROM users), N'Khuyến mãi lớn cuối tuần.', 'Flash Sale,Khuyến mãi,Linh kiện', N'Flash Sale linh kiện PC', 240, 3, 'PUBLISHED'),
(N'<h2>Build PC Gaming 25 triệu</h2><p>Cấu hình đề xuất:</p><ul><li>Ryzen 5 9600X</li><li>RTX 5060</li><li>RAM DDR5 32GB</li><li>SSD NVMe 1TB</li></ul>',
GETDATE(), 'build-pc-25-trieu', N'Tư vấn cấu hình PC Gaming tối ưu trong tầm giá 25 triệu.', 'build25.jpg', N'Hướng dẫn Build PC Gaming 25 triệu', GETDATE(), (SELECT TOP 1 id FROM users), N'Cấu hình PC Gaming hiệu năng cao.', 'Build PC,Gaming,RTX5060', N'Build PC Gaming 25 triệu', 61, 4, 'PUBLISHED'),
(N'<h2>SSD PCIe Gen5 có đáng mua?</h2><p>SSD Gen5 có tốc độ lên tới 14GB/s nhưng không phải ai cũng cần nâng cấp.</p>',
GETDATE(), 'ssd-pcie-gen5', N'So sánh SSD PCIe Gen5 và Gen4 trong thực tế.', 'ssdgen5.jpg', N'SSD PCIe Gen5 có thật sự đáng nâng cấp?', GETDATE(), (SELECT TOP 1 id FROM users), N'Đánh giá SSD PCIe Gen5.', 'SSD,NVMe,Gen5', N'SSD PCIe Gen5', 35, 5, 'PUBLISHED'),
(N'<h2>5 mẹo giúp máy tính chơi game mượt hơn</h2><ul><li>Cập nhật Driver.</li><li>Nâng cấp SSD.</li><li>Nâng RAM.</li><li>Bật Game Mode.</li><li>Vệ sinh máy định kỳ.</li></ul>',
GETDATE(), 'meo-toi-uu-pc-gaming', N'Hướng dẫn tối ưu hiệu năng máy tính để chơi game.', 'optimize.jpg', N'5 mẹo giúp máy tính chơi game mượt hơn', GETDATE(), (SELECT TOP 1 id FROM users), N'Mẹo tối ưu Windows và phần cứng.', 'FPS,Gaming,Windows,Tối ưu', N'Tối ưu PC Gaming', 52, 6, 'PUBLISHED');
GO
-- ----------------------------
-- Records of brands
-- ----------------------------
INSERT INTO brands (name, logo, link, display_order)
VALUES
(N'Intel', N'/images/ui-new/intel.svg', N'/products?brand=Intel', 1),
(N'AMD', N'/images/ui-new/amd.svg', N'/products?brand=AMD', 2),
(N'ASUS', N'/images/ui-new/asus.svg', N'/products?brand=ASUS', 3),
(N'MSI', N'/images/ui-new/msi.svg', N'/products?brand=MSI', 4),
(N'GIGABYTE', N'/images/ui-new/gigabyte.svg', N'/products?brand=GIGABYTE', 5),
(N'Corsair', N'/images/ui-new/corsair.svg', N'/products?brand=Corsair', 6),
(N'Kingston', N'/images/ui-new/kingston.svg', N'/products?brand=Kingston', 7),
(N'Cooler Master', N'/images/ui-new/coolermaster.svg', N'/products?brand=Cooler Master', 8);
GO
DELETE FROM brands;
GO

-- Manual SQL Server migration for the ten-minute VietQR payment-session lifecycle.
-- The target and data type of order_id are derived from the live dbo.orders.id metadata.
-- Timestamps are stored in DATETIME2(3) with UTC semantics. Safe to rerun.

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @initial_transaction_count INT = @@TRANCOUNT;
DECLARE @started_transaction BIT = 0;

BEGIN TRY
    IF @initial_transaction_count = 0
    BEGIN
        BEGIN TRANSACTION;
        SET @started_transaction = 1;
    END
    ELSE
    BEGIN
        SAVE TRANSACTION v2_add_vietqr_payment_sessions;
    END;

    DECLARE @orders_object_id INT = OBJECT_ID(N'dbo.orders', N'U');

    IF @orders_object_id IS NULL
        THROW 51000, N'dbo.orders does not exist.', 1;

    DECLARE @orders_id_user_type_id INT;
    DECLARE @orders_id_max_length SMALLINT;
    DECLARE @orders_id_precision TINYINT;
    DECLARE @orders_id_scale TINYINT;
    DECLARE @orders_id_collation SYSNAME;
    DECLARE @orders_id_type_definition NVARCHAR(512);

    SELECT
        @orders_id_user_type_id = c.user_type_id,
        @orders_id_max_length = c.max_length,
        @orders_id_precision = c.precision,
        @orders_id_scale = c.scale,
        @orders_id_collation = c.collation_name,
        @orders_id_type_definition =
            CASE
                WHEN t.is_user_defined = 1
                    THEN QUOTENAME(SCHEMA_NAME(t.schema_id))
                         + N'.' + QUOTENAME(t.name)
                WHEN t.name IN (N'char', N'varchar', N'binary', N'varbinary')
                    THEN QUOTENAME(t.name)
                         + N'('
                         + CASE
                               WHEN c.max_length = -1 THEN N'MAX'
                               ELSE CONVERT(NVARCHAR(10), c.max_length)
                           END
                         + N')'
                WHEN t.name IN (N'nchar', N'nvarchar')
                    THEN QUOTENAME(t.name)
                         + N'('
                         + CASE
                               WHEN c.max_length = -1 THEN N'MAX'
                               ELSE CONVERT(NVARCHAR(10), c.max_length / 2)
                           END
                         + N')'
                WHEN t.name IN (N'decimal', N'numeric')
                    THEN QUOTENAME(t.name)
                         + N'(' + CONVERT(NVARCHAR(10), c.precision)
                         + N',' + CONVERT(NVARCHAR(10), c.scale) + N')'
                WHEN t.name IN (N'datetime2', N'datetimeoffset', N'time')
                    THEN QUOTENAME(t.name)
                         + N'(' + CONVERT(NVARCHAR(10), c.scale) + N')'
                WHEN t.name = N'float'
                    THEN QUOTENAME(t.name)
                         + N'(' + CONVERT(NVARCHAR(10), c.precision) + N')'
                ELSE QUOTENAME(t.name)
            END
            + CASE
                  WHEN c.collation_name IS NOT NULL
                      THEN N' COLLATE ' + QUOTENAME(c.collation_name)
                  ELSE N''
              END
    FROM sys.columns c
    JOIN sys.types t
      ON t.user_type_id = c.user_type_id
    WHERE c.object_id = @orders_object_id
      AND c.name = N'id';

    IF @orders_id_user_type_id IS NULL
        THROW 51001, N'dbo.orders.id does not exist.', 1;

    IF NULLIF(LTRIM(RTRIM(@orders_id_type_definition)), N'') IS NULL
        THROW 51005, N'Could not derive the SQL data type of dbo.orders.id.', 1;

    -- A foreign key may target a PRIMARY KEY or an unfiltered UNIQUE candidate
    -- key. The primary key may be composite; only a separate candidate key on
    -- dbo.orders.id itself matters here.
    IF NOT EXISTS (
        SELECT 1
        FROM sys.indexes i
        JOIN sys.index_columns first_key
          ON first_key.object_id = i.object_id
         AND first_key.index_id = i.index_id
         AND first_key.key_ordinal = 1
        JOIN sys.columns first_column
          ON first_column.object_id = first_key.object_id
         AND first_column.column_id = first_key.column_id
        WHERE i.object_id = @orders_object_id
          AND i.is_unique = 1
          AND i.is_disabled = 0
          AND i.is_hypothetical = 0
          AND i.has_filter = 0
          AND first_column.name = N'id'
          AND NOT EXISTS (
              SELECT 1
              FROM sys.index_columns additional_key
              WHERE additional_key.object_id = i.object_id
                AND additional_key.index_id = i.index_id
                AND additional_key.key_ordinal > 1
          )
    )
    BEGIN
        THROW 51002, N'dbo.orders.id is not a PRIMARY KEY or UNIQUE candidate key. Run REPAIR__orders_id_candidate_key.sql separately after reviewing its safety checks.', 1;
    END;

    IF OBJECT_ID(N'dbo.sepay_transactions', N'U') IS NULL
        THROW 51003, N'dbo.sepay_transactions does not exist.', 1;

    IF COL_LENGTH(N'dbo.sepay_transactions', N'transaction_date') IS NULL
    BEGIN
        EXEC sys.sp_executesql
            N'ALTER TABLE dbo.sepay_transactions
              ADD transaction_date DATETIME2(3) NULL;';
    END;

    DECLARE @payment_sessions_object_id INT =
        OBJECT_ID(N'dbo.sepay_payment_sessions', N'U');
    DECLARE @payment_sessions_schema_is_valid BIT = 0;

    IF @payment_sessions_object_id IS NOT NULL
       AND EXISTS (
           SELECT 1
           FROM sys.columns c
           JOIN sys.types t ON t.user_type_id = c.user_type_id
           WHERE c.object_id = @payment_sessions_object_id
             AND c.name = N'id'
             AND t.name = N'bigint'
             AND c.is_identity = 1
             AND c.is_nullable = 0
       )
       AND EXISTS (
           SELECT 1
           FROM sys.columns c
           WHERE c.object_id = @payment_sessions_object_id
             AND c.name = N'order_id'
             AND c.user_type_id = @orders_id_user_type_id
             AND c.max_length = @orders_id_max_length
             AND c.precision = @orders_id_precision
             AND c.scale = @orders_id_scale
             AND ISNULL(c.collation_name, N'') =
                 ISNULL(@orders_id_collation, N'')
             AND c.is_nullable = 0
       )
       AND EXISTS (
           SELECT 1
           FROM sys.columns c
           JOIN sys.types t ON t.user_type_id = c.user_type_id
           WHERE c.object_id = @payment_sessions_object_id
             AND c.name = N'qr_created_at'
             AND t.name = N'datetime2'
             AND c.scale = 3
             AND c.is_nullable = 0
       )
       AND EXISTS (
           SELECT 1
           FROM sys.columns c
           JOIN sys.types t ON t.user_type_id = c.user_type_id
           WHERE c.object_id = @payment_sessions_object_id
             AND c.name = N'qr_expires_at'
             AND t.name = N'datetime2'
             AND c.scale = 3
             AND c.is_nullable = 0
       )
       AND EXISTS (
           SELECT 1
           FROM sys.columns c
           JOIN sys.types t ON t.user_type_id = c.user_type_id
           WHERE c.object_id = @payment_sessions_object_id
             AND c.name = N'paid_at'
             AND t.name = N'datetime2'
             AND c.scale = 3
             AND c.is_nullable = 1
       )
       AND EXISTS (
           SELECT 1
           FROM sys.columns c
           JOIN sys.types t ON t.user_type_id = c.user_type_id
           WHERE c.object_id = @payment_sessions_object_id
             AND c.name = N'expired_at'
             AND t.name = N'datetime2'
             AND c.scale = 3
             AND c.is_nullable = 1
       )
       AND EXISTS (
           SELECT 1
           FROM sys.key_constraints kc
           JOIN sys.index_columns first_key
             ON first_key.object_id = kc.parent_object_id
            AND first_key.index_id = kc.unique_index_id
            AND first_key.key_ordinal = 1
           JOIN sys.columns first_column
             ON first_column.object_id = first_key.object_id
            AND first_column.column_id = first_key.column_id
           WHERE kc.parent_object_id = @payment_sessions_object_id
             AND kc.type = N'PK'
             AND first_column.name = N'id'
             AND NOT EXISTS (
                 SELECT 1
                 FROM sys.index_columns additional_key
                 WHERE additional_key.object_id = kc.parent_object_id
                   AND additional_key.index_id = kc.unique_index_id
                   AND additional_key.key_ordinal > 1
             )
       )
    BEGIN
        SET @payment_sessions_schema_is_valid = 1;
    END;

    IF @payment_sessions_object_id IS NOT NULL
       AND @payment_sessions_schema_is_valid = 0
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.sepay_payment_sessions)
            THROW 51004, N'dbo.sepay_payment_sessions has an incompatible schema and contains data; refusing to drop it.', 1;

        DROP TABLE dbo.sepay_payment_sessions;
        SET @payment_sessions_object_id = NULL;
    END;

    IF OBJECT_ID(N'dbo.sepay_payment_sessions', N'U') IS NULL
    BEGIN
        DECLARE @create_payment_sessions_sql NVARCHAR(MAX) =
            N'CREATE TABLE dbo.sepay_payment_sessions (
                id BIGINT IDENTITY(1,1) NOT NULL
                    CONSTRAINT pk_sepay_payment_sessions PRIMARY KEY,
                order_id ' + @orders_id_type_definition + N' NOT NULL,
                qr_created_at DATETIME2(3) NOT NULL,
                qr_expires_at DATETIME2(3) NOT NULL,
                paid_at DATETIME2(3) NULL,
                expired_at DATETIME2(3) NULL
            );';

        EXEC sys.sp_executesql @create_payment_sessions_sql;
    END;

    SET @payment_sessions_object_id =
        OBJECT_ID(N'dbo.sepay_payment_sessions', N'U');

    IF @payment_sessions_object_id IS NULL
        THROW 51006, N'CREATE TABLE completed without creating dbo.sepay_payment_sessions.', 1;

    IF NOT EXISTS (
        SELECT 1
        FROM sys.foreign_keys fk
        JOIN sys.foreign_key_columns fkc
          ON fkc.constraint_object_id = fk.object_id
        JOIN sys.columns parent_column
          ON parent_column.object_id = fkc.parent_object_id
         AND parent_column.column_id = fkc.parent_column_id
        JOIN sys.columns referenced_column
          ON referenced_column.object_id = fkc.referenced_object_id
         AND referenced_column.column_id = fkc.referenced_column_id
        WHERE fk.parent_object_id = @payment_sessions_object_id
          AND fkc.referenced_object_id = @orders_object_id
          AND parent_column.name = N'order_id'
          AND referenced_column.name = N'id'
    )
    BEGIN
        ALTER TABLE dbo.sepay_payment_sessions WITH CHECK
            ADD CONSTRAINT fk_sepay_payment_sessions_order
            FOREIGN KEY (order_id) REFERENCES dbo.orders(id);
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM sys.indexes
        WHERE name = N'idx_sepay_payment_sessions_order_created'
          AND object_id = @payment_sessions_object_id
    )
    BEGIN
        CREATE INDEX idx_sepay_payment_sessions_order_created
            ON dbo.sepay_payment_sessions (order_id, qr_created_at DESC);
    END;

    -- Backfill one deterministic session for existing VietQR orders without inventing a fresh ten-minute window.
    INSERT INTO dbo.sepay_payment_sessions (
        order_id,
        qr_created_at,
        qr_expires_at,
        paid_at,
        expired_at
    )
    SELECT
        o.id,
        CAST(o.created_at AS DATETIME2(3)),
        DATEADD(MINUTE, 10, CAST(o.created_at AS DATETIME2(3))),
        NULL,
        CASE
            WHEN o.status = N'CHO_XAC_NHAN_THANH_TOAN'
                 AND SYSUTCDATETIME() >= DATEADD(MINUTE, 10, CAST(o.created_at AS DATETIME2(3)))
                THEN SYSUTCDATETIME()
            ELSE NULL
        END
    FROM dbo.orders o
    WHERE o.payment_method = N'VIETQR'
      AND o.created_at IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.sepay_payment_sessions s
          WHERE s.order_id = o.id
      );

    IF OBJECT_ID(N'dbo.sepay_payment_sessions', N'U') IS NULL
        THROW 51007, N'Migration postcondition failed: dbo.sepay_payment_sessions does not exist.', 1;

    IF NOT EXISTS (
        SELECT 1
        FROM sys.foreign_keys fk
        JOIN sys.foreign_key_columns fkc
          ON fkc.constraint_object_id = fk.object_id
        JOIN sys.columns parent_column
          ON parent_column.object_id = fkc.parent_object_id
         AND parent_column.column_id = fkc.parent_column_id
        JOIN sys.columns referenced_column
          ON referenced_column.object_id = fkc.referenced_object_id
         AND referenced_column.column_id = fkc.referenced_column_id
        WHERE fk.parent_object_id =
              OBJECT_ID(N'dbo.sepay_payment_sessions', N'U')
          AND fkc.referenced_object_id = @orders_object_id
          AND parent_column.name = N'order_id'
          AND referenced_column.name = N'id'
    )
        THROW 51008, N'Migration postcondition failed: order_id does not reference dbo.orders.id.', 1;

    IF @started_transaction = 1
        COMMIT TRANSACTION;

    SELECT
        OBJECT_ID(N'dbo.sepay_payment_sessions', N'U')
            AS payment_sessions_object_id,
        COL_LENGTH(N'dbo.sepay_transactions', N'transaction_date')
            AS transaction_date_length,
        @@TRANCOUNT AS transaction_count_after_migration;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
    BEGIN
        IF @started_transaction = 1
            ROLLBACK TRANSACTION;
        ELSE IF XACT_STATE() = 1
            ROLLBACK TRANSACTION v2_add_vietqr_payment_sessions;
    END;

    THROW;
END CATCH;
