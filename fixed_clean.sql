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
  email NVARCHAR(255)  NOT NULL,
  password NVARCHAR(255)  NOT NULL,
  full_name NVARCHAR(255),
  phone NVARCHAR(255),
  address NVARCHAR(MAX),
  enabled BIT DEFAULT 1,
  auth_provider NVARCHAR(255),
  provider_id NVARCHAR(255),
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

-- Dumping data for table users
SET IDENTITY_INSERT users ON;
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, provider_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (1, 'balittedutphieukhang@gmail.com', 'balittedutphieukhang@gmail.com', '$2a$10$ceBXGEZmWVqVhpH48b2TZuuMNgdGPxYTq4ydS.7erOj7cpOHhaB2y', N'Nguyễn khang', '+84859590337', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-28 15:19:21.008');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, provider_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (4, 'admin', 'admin@luxurypc.com', '$2a$10$F76h/W85bFv9Kp040CV4ju4N/jhKpRhXaWgWzewsDa8kDzkHtfXhS', 'Admin LuxuryPC', NULL, NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '2026-06-08 15:23:54.309');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, provider_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (6, 'ngochai2007nt@gmail.com', 'ngochai2007nt@gmail.com', '$2a$10$1soqIA9YDYg0ggZoYV0Cm.OHY81wkRw2GF8dlFtvIRUcU8Pa5Si0u', N'Hải Nguyễn Ngọc', '+84384333382', NULL, 1, 'LOCAL', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '2026-06-14 19:11:56.269');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, provider_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (7, 'tuannguyennasani@gmail.com', 'tuannguyennasani@gmail.com', '$2a$10$cHz.eTkmtRsrCHdDV0jkx.ZXtRIbMkuFt3UXMpVJm5onDMbckJ8TS', 'bi mj', '0869949147', '', 1, 'LOCAL', NULL, NULL, NULL, 0, 0, 1, 0, 1, 1, 0, NULL);
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, provider_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (8, 'phamcongthanh.8311@gmail.com', 'phamcongthanh.8311@gmail.com', '$2a$10$IQoMLrNNl.onPqZoiXBeaOaYPmaFdaLn0LJhMA0gQFJB13peWyKhi', N'Phạm Thanh', '0902208461', NULL, 1, 'GOOGLE', '112307932430374029161', '/uploads/avatars/user_41_1783933303213.webp', NULL, NULL, 0, 1, 0, 1, 1, 0, '2026-07-13 16:00:58.778');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, provider_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (2, 'tuan9bledinhchinh@gmail.com', 'tuan9bledinhchinh@gmail.com', '$2a$10$3wA6X7TEsnW5ymYdePRokuIN/FLZ.eIRMD4UQBh8PIyh/3z.LLn0q', 'nguyen tuanv', '+84905338411', NULL, 1, 'LOCAL', NULL, '/uploads/avatars/user_9_1782042707831.png', '1995-10-18 00:00:00', 1, 1, 0, 0, 1, 1, NULL, '2026-03-28 15:59:09.715');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, provider_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (5, 'leecookcu@gmail.com', 'leecookcu@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bá Bá', '0936629311', NULL, 1, 'LOCAL', NULL, '/uploads/avatars/user_29_1783932198527.jpg', '2006-12-12 00:00:00', 1, 1, 1, 1, 0, 1, 0, '2026-06-12 18:47:49.406');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, provider_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (9, 'truongquan577@gmail.com', 'truongquan577@gmail.com', '$2a$10$gh0vQYsD242R1hjpFWOTc.hvPanF9tbhWlBhu/vndvToJBHEyejkG', N'Quân Nguyễn', '0867868825', NULL, 1, 'GOOGLE', '117704587837574685080', NULL, NULL, NULL, 0, 1, 0, 1, 1, 0, '2026-07-13 22:20:52.151');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, provider_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (10, 'ditmemaygogle113', 'ditmemaygogle113@gmail.com', '49b4e39e-f53f-4158-a06d-a5f995ddd21c', N'Yến Trần', NULL, NULL, 1, 'GOOGLE', '102325764378749092956', NULL, NULL, NULL, 0, 1, 1, 1, 1, 0, '2026-07-14 11:06:11.866');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, provider_id, avatar, birthday, gender, status, notify_flash_sale, notify_new_products, notify_order_updates, notify_weekly_newsletter, two_factor_enabled, created_at) VALUES (3, 'nguyentruongq169', 'nguyentruongq169@gmail.com', '$2a$10$JKkTGHPr.EWsXIr0/PPgzuq4pFp/QDiBLkQ0n0b/XSQbGouVpIlJ.', N'Quân Nguyễn Trường', NULL, NULL, 1, 'GOOGLE', '113506180708155747249', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '2026-06-08 15:14:14.918');
SET IDENTITY_INSERT users OFF;
GO

-- Dumping data for table categories
SET IDENTITY_INSERT categories ON;
INSERT INTO categories (id, name, display, slug) VALUES (1, 'CPU', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (2, 'GPU', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (3, 'RAM', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (4, 'Mainboard', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (5, 'SSD', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (6, N'Màn hình', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (10, 'HDD', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (11, 'PSU', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (12, 'Case', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (13, 'CPU Cooler', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (14, 'Case Fan', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (15, 'Keyboard', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (16, 'Mouse', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (17, 'Headset', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (7, 'Storage', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (8, 'Cooling', NULL, NULL);
INSERT INTO categories (id, name, display, slug) VALUES (9, 'VGA', NULL, NULL);
SET IDENTITY_INSERT categories OFF;
GO

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
INSERT INTO user_roles (user_id, role_id, id) VALUES (2, 1, 1);
INSERT INTO user_roles (user_id, role_id, id) VALUES (3, 2, 2);
INSERT INTO user_roles (user_id, role_id, id) VALUES (4, 1, 3);
INSERT INTO user_roles (user_id, role_id, id) VALUES (3, 1, 4);
INSERT INTO user_roles (user_id, role_id, id) VALUES (6, 1, 6);
INSERT INTO user_roles (user_id, role_id, id) VALUES (7, 3, 7);
INSERT INTO user_roles (user_id, role_id, id) VALUES (5, 1, 5);
INSERT INTO user_roles (user_id, role_id, id) VALUES (9, 2, 9);
INSERT INTO user_roles (user_id, role_id, id) VALUES (8, 3, 8);
INSERT INTO user_roles (user_id, role_id, id) VALUES (10, 2, 10);
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

-- Dumping data for table products
SET IDENTITY_INSERT products ON;
SET IDENTITY_INSERT products OFF;
GO

-- Dumping data for table vouchers
SET IDENTITY_INSERT vouchers ON;
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES (2, 1, 'LXR36', '2026-06-22 10:52:53.047', N'Giảm giá 15% các mặt hàng', 'PERCENTAGE', 15, '2026-06-30 00:00:00', 50000, 10000, NULL, 100, 2, NULL);
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES (4, 1, 'LUX50', '2026-06-23 17:08:51.75', N'giảm giá 50', 'PERCENTAGE', 50, '2026-06-30 12:00:00', 10000000, 1000000, NULL, 10, 0, NULL);
INSERT INTO vouchers (id, active, code, created_at, description, discount_type, discount_value, end_date, max_discount_amount, min_order_amount, start_date, usage_limit, used_count, category_id) VALUES (1, 1, 'LXR500', '2026-06-21 18:32:38.194', '20', 'PERCENTAGE', 1000, '2028-06-09 10:10:00', 500000, 5000, NULL, 99, 2, 4);
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

-- Dumping data for table orders
SET IDENTITY_INSERT orders ON;
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (26, NULL, 31000000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH26', 'md', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-07 11:21:45.734');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (2, NULL, 8500000, 'DA_HUY', 'DEMO-COD-PENDING', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-18 00:12:47.414');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (10, NULL, 213800000, 'COMPLETED', 'DH10', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-20 23:44:16.695');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (17, 5, 2, 'PENDING', 'DH17', N'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', N'7/134/29/9 đường liên khu 5-6 phường Bình Hưng Hòa B quận Bình Tân', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-22 11:19:22.674');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (18, 5, 3550000, 'SHIPPING', 'DH18', 'Thanh Pham', 'leecookcu@gmail.com', '0902208461', 'TPHCM', NULL, 50000, 'LXR36', NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-23 17:04:56.396');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (19, 5, 10900000, 'PENDING', 'DH19', 'Thanh Pham', 'leecookcu@gmail.com', '0902208461', 'TPHCM', NULL, 500000, 'LXR500', NULL, 0.00, NULL, 'INSTALLMENT', NULL, NULL, NULL, NULL, NULL, '2026-06-23 17:52:55.979');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (20, 2, 6500000, 'PENDING', 'DH20', N'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', 'tp', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-29 21:15:31.495');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (21, 5, 90000000, 'PENDING', 'DH21', N'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', N'7/134/29/9 đường liên khu 5-6', NULL, 10000000, 'LUX10', NULL, 0.00, NULL, 'INSTALLMENT', NULL, NULL, NULL, NULL, NULL, '2026-07-02 11:03:00.775');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (22, NULL, 90000000, 'PENDING', 'DH22', N'Phạm Công Thanh', NULL, '0902208461', N'7/134/29/9 đường liên khu 5-6', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-02 13:03:06.903');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (23, NULL, 120000000, 'PENDING', 'DH23', N'Phạm Công Thanh', NULL, '0902208461', N'7/134/29/9 đường liên khu 5-6', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-02 13:03:58.891');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (24, 2, 5600000, 'PENDING', 'DH24', N'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', 'tp', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-03 09:00:31.482');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (25, 2, 7200000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH25', N'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', 'tp', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-03 09:05:44.01');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (27, NULL, 6200000, 'PENDING', 'DH27', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07 11:22:24.148');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (28, NULL, 1950000, 'PENDING', 'DH28', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07 17:24:58.208');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (29, NULL, 1950000, 'PENDING', 'DH29', 'tuan nguyen', NULL, '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07 18:17:37.769');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (30, 7, 1950000, 'THU_HOI', 'DH30', 'tuan nguyen', 'tuannguyennasani@gmail.com', '0905338411', 'thon tan quang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-07 19:57:59.626');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (1, NULL, 17200000, 'CHO_XAC_NHAN_THANH_TOAN', 'DEMO-VIETQR-WAITING', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-06-19 00:12:46.958');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (3, NULL, 25900000, 'DA_THANH_TOAN', 'DEMO-VIETQR-PAID', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-06-17 00:12:47.866');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (6, NULL, 12500000, 'COMPLETED', 'DEMO-VOUCHER-COMPLETED', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, 500000, 'QA500K', NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-14 00:12:49.207');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (5, NULL, 6900000, 'COMPLETED', 'DEMO-CANCELLED', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-06-15 00:12:48.753');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (4, NULL, 18600000, 'DA_HOAN_TIEN', 'DEMO-VIETQR-REFUND-REQUESTED', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', N'OK | Đã hoàn', 'DA_THANH_TOAN', N'Khách muốn trả hàng vì sản phẩm không phù hợp', NULL, NULL, '2026-06-16 00:12:48.31');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (31, 2, 190400000, 'PAID', 'DH31', 'tuan nguyen', 'tuan9bledinhchinh@gmail.com', '0905338411', N'thon tan quang, Phường Ngô Quyền, Thành phố Bắc Giang, Tỉnh Bắc Giang', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-11 16:11:46.406');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (8, NULL, 21500000, 'DA_HOAN_TIEN', 'DEMO-VIETQR-REFUNDED', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', N'Đã hoàn tiền qua MB Bank', 'DA_THANH_TOAN', N'Khách yêu cầu hoàn tiền', NULL, NULL, '2026-06-12 00:12:50.287');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (9, NULL, 15700000, 'THU_HOI', 'DEMO-VIETQR-RECALLED', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', N'Thu hồi theo yêu cầu kiểm thử', 'DA_THANH_TOAN', N'Khách yêu cầu trả hàng', NULL, NULL, '2026-06-11 00:12:50.817');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (7, NULL, 19900000, 'THU_HOI', 'DEMO-VIETQR-REFUND-WAITING', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, NULL, NULL, NULL, 0.00, NULL, 'VIETQR', N'Admin đã duyệt yêu cầu hoàn tiền', 'DA_THANH_TOAN', N'Khách yêu cầu hoàn tiền', NULL, NULL, '2026-06-13 00:12:49.74');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (11, NULL, 150000000, 'COMPLETED', 'DEMO-MAR-1', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-15 10:00:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (12, NULL, 220000000, 'COMPLETED', 'DEMO-MAR-2', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-25 14:30:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (13, NULL, 185000000, 'COMPLETED', 'DEMO-APR-1', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-10 09:15:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (14, NULL, 315000000, 'COMPLETED', 'DEMO-APR-2', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-20 16:45:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (15, NULL, 280000000, 'COMPLETED', 'DEMO-MAY-1', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-05 11:20:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (16, NULL, 195000000, 'COMPLETED', 'DEMO-MAY-2', 'LuxuryPC Admin', 'nguyentruongq169@gmail.com', '0900000000', N'Địa chỉ kiểm thử', NULL, 0, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-18 13:10:00');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (38, 3, 10000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH38', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Nam Ka, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 19:05:37.372');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (39, 3, 10000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH39', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea Ning, Huyện Cư Kuin, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 19:10:23.876');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (40, 3, 10000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH40', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea Ning, Huyện Cư Kuin, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 19:53:25.074');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (41, 3, 10000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH41', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea R''Bin, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 20:34:44.343');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (32, 9, 600000, 'COMPLETED', 'DH32', N'Nguyễn Trường Quân', 'truongquan577@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-13 22:22:01.34');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (33, 5, 825000000, 'COMPLETED', 'DH33', N'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', N'7/134/29/9 đường liên khu 5-6, Phường Hàng Trống, Quận Hoàn Kiếm, Thành phố Hà Nội', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-14 13:43:34.142');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (34, 2, 2375000, 'PENDING', 'DH34', N'khang Nguyễn', 'tuan9bledinhchinh@gmail.com', '0000000000', N'tp, Xã Yên Sơn, Huyện Yên Châu, Tỉnh Sơn La', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-14 16:50:43.95');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (35, 3, 600000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH35', N'Quân Nguyễn Trường', 'nguyentruongq169@gmail.com', '0867868825', N'q, Xã Tiền Tiến, Thành phố Hải Dương, Tỉnh Hải Dương', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 17:30:01.596');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (36, 3, 8500000, 'PENDING', 'DH36', N'Quân Nguyễn Trường', 'nguyentruongq169@gmail.com', '0867868825', N'q, Xã Tiền Tiến, Thành phố Hải Dương, Tỉnh Hải Dương', NULL, 0, NULL, NULL, 0.00, NULL, 'EWALLET', NULL, NULL, NULL, NULL, NULL, '2026-07-14 17:30:49.368');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (37, 3, 8500000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH37', N'Quân Nguyễn Trường', 'nguyentruongq169@gmail.com', '0867868825', N'q, Xã Tiền Tiến, Thành phố Hải Dương, Tỉnh Hải Dương', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 17:32:25.37');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (42, 3, 10000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH42', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Nam Ka, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 21:46:26.074');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (43, 3, 10000, 'CHO_XAC_NHAN_THANH_TOAN', 'DH43', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Nam Ka, Huyện Lắk, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 22:07:27.131');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (44, 3, 10000, 'DA_THANH_TOAN', 'DH44', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Ea BHốk, Huyện Cư Kuin, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 22:10:45.309');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (45, 3, 10000, 'DA_THANH_TOAN', 'DH45', N'Nguyễn Trường Quân', 'nguyentruongq169@gmail.com', '0867868825', N'Nhà 06, Thôn 13, Xã Vụ Bổn, Huyện Krông Pắk, Xã Cư Klông, Huyện Krông Năng, Tỉnh Đắk Lắk', NULL, 0, NULL, NULL, 0.00, NULL, 'VIETQR', NULL, NULL, NULL, NULL, NULL, '2026-07-14 22:15:01.122');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (46, NULL, 16500000, 'PENDING', 'DH46', N'Phạm Công Thanh', NULL, '0902208461', N'7/134/29/9 đường liên khu 5-6, Phường Hợp Giang, Thành phố Cao Bằng, Tỉnh Cao Bằng', NULL, 0, NULL, NULL, 0.00, NULL, 'COD', NULL, NULL, NULL, NULL, NULL, '2026-07-15 13:09:04.701');
INSERT INTO orders (id, user_id, total_price, status, order_code, full_name, email, phone, address, city, discount_amount, voucher_code, installment_bank, installment_fee, installment_term, payment_method, admin_note, refund_previous_status, refund_reason, stock_deducted, stock_restored, created_at) VALUES (47, 5, 1620000, 'PENDING', 'DH47', N'Phạm Công Thanh', 'leecookcu@gmail.com', '0902208461', N'7/134/29/9 đường liên khu 5-6, Phường Phúc Xá, Quận Ba Đình, Thành phố Hà Nội', NULL, 0, NULL, NULL, 0.00, NULL, 'INSTALLMENT', NULL, NULL, NULL, NULL, NULL, '2026-07-15 17:26:21.271');
SET IDENTITY_INSERT orders OFF;
GO

-- Dumping data for table order_items
SET IDENTITY_INSERT order_items ON;
SET IDENTITY_INSERT order_items OFF;
GO

-- Dumping data for table reviews
SET IDENTITY_INSERT reviews ON;
SET IDENTITY_INSERT reviews OFF;
GO

-- Dumping data for table wishlist_items
SET IDENTITY_INSERT wishlist_items ON;
SET IDENTITY_INSERT wishlist_items OFF;
GO

-- Dumping data for table inventory
SET IDENTITY_INSERT inventory ON;
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
SET IDENTITY_INSERT flash_sale_items OFF;
GO

-- Dumping data for table pc_combo_details
SET IDENTITY_INSERT pc_combo_details ON;
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

-- ======================================================
-- BATCH IMPORT FOR GEARVN DATA (Generated)
-- ======================================================
DECLARE @current_pid INT;

-- Product: Bộ vi xử lý AMD Ryzen 5 5600X / 3.7GHz Boost 4.6GHz / 6 nhân 12 luồng / 32MB / AM4
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 5 5600X / 3.7GHz Boost 4.6GHz / 6 nhân 12 luồng / 32MB / AM4', 4690000, N'', N'https://product.hstatic.net/200000722513/product/3-7ghz-boost-4-6ghz-6-nhan-12-luong-1_064ea02033974b0fae49158951cc74dd_b68071833a2a4ca797c7c330d6cf8412_master.png', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'AM4', 65);

-- Product: Bộ vi xử lý AMD Ryzen 5 5500 / 3.6GHz Boost 4.2GHz / 6 nhân 12 luồng / 16MB / AM4
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 5 5500 / 3.6GHz Boost 4.2GHz / 6 nhân 12 luồng / 16MB / AM4', 2690000, N'', N'https://product.hstatic.net/200000722513/product/20619238-a_ryzen5_sr1_3dpib_right_row_a5c9aa7c8c6642208ef8225f07fc38e0_fb65fa52e903447a9edf1a41eff5de10_master.png', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'AM4', 65);

-- Product: Bộ vi xử lý AMD Ryzen 7 9800X3D / 4.7GHz Boost 5.2GHz / 8 nhân 16 luồng / 104MB / AM5
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 7 9800X3D / 4.7GHz Boost 5.2GHz / 8 nhân 16 luồng / 104MB / AM5', 15690000, N'', N'https://product.hstatic.net/200000722513/product/242872903-d_ryzen_7_9800x3d_3dpib_fl_2b5b9679b1b14fd2a89511a1dfd4511b_master.png', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'AM4', 120);

-- Product: Bộ vi xử lý Intel Core Ultra 9 285K / Turbo up to 5.7GHz / 24 Nhân 24 Luồng / 36MB / LGA 1851
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core Ultra 9 285K / Turbo up to 5.7GHz / 24 Nhân 24 Luồng / 36MB / LGA 1851', 17990000, N'', N'https://product.hstatic.net/200000722513/product/n36733-001-arl-i9k-univ_b4cd53ec34294ed9bea8be6f28991d91_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1851', 250);

-- Product: Bộ vi xử lý Intel Core Ultra 7 265K / Turbo up to 5.5GHz / 20 Nhân 20 Luồng / 30MB / LGA 1851
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core Ultra 7 265K / Turbo up to 5.5GHz / 20 Nhân 20 Luồng / 30MB / LGA 1851', 10490000, N'', N'https://product.hstatic.net/200000722513/product/n43449-001-arl-7k-univ_4a4d7889cc5546f1912e6ab4ba40265e_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1851', 250);

-- Product: Bộ vi xử lý Intel Core Ultra 7 265KF / Turbo up to 5.5GHz / 20 Nhân 20 Luồng / 30MB / LGA 1851
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core Ultra 7 265KF / Turbo up to 5.5GHz / 20 Nhân 20 Luồng / 30MB / LGA 1851', 9690000, N'', N'https://product.hstatic.net/200000722513/product/n43457-001-arl-7kf-univ_a83f5476627045c6bdfc7916fe50cc26_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1851', 250);

-- Product: Bộ vi xử lý Intel Core Ultra 5 245K / Turbo up to 5.2GHz / 14 Nhân 14 Luồng / 24MB / LGA 1851
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core Ultra 5 245K / Turbo up to 5.2GHz / 14 Nhân 14 Luồng / 24MB / LGA 1851', 6690000, N'', N'https://product.hstatic.net/200000722513/product/n43480-001-arl-5k-univ_26e6a0a4e9864d60a05b322f56ac0102_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1851', 159);

-- Product: Bộ vi xử lý Intel Core Ultra 5 245KF / Turbo up to 5.2GHz / 14 Nhân 14 Luồng / 24MB / LGA 1851
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core Ultra 5 245KF / Turbo up to 5.2GHz / 14 Nhân 14 Luồng / 24MB / LGA 1851', 6290000, N'', N'https://product.hstatic.net/200000722513/product/n43532-001-arl-5kf-univ_e25bf3b60e52436c8213c5368f5efbc8_master.jpg', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1851', 159);

-- Product: Bộ vi xử lý AMD Ryzen 5 8400F / 4.2GHz Boost 4.7GHz / 6 nhân 12 luồng / 22MB / AM5
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 5 8400F / 4.2GHz Boost 4.7GHz / 6 nhân 12 luồng / 22MB / AM5', 4490000, N'', N'https://product.hstatic.net/200000722513/product/100-100001591box-1_42bbe74b631c4722b63db81c9914a7e4_master.png', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1851', 65);

-- Product: Bộ vi xử lý Intel Core i5 12400F / 2.5GHz Turbo 4.4GHz / 6 Nhân 12 Luồng / 18MB / LGA 1700 (TRAY)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i5 12400F / 2.5GHz Turbo 4.4GHz / 6 Nhân 12 Luồng / 18MB / LGA 1700 (TRAY)', 3890000, N'', N'https://product.hstatic.net/200000722513/product/thumb_linhkien_9067fd110a6346198bb56d6673942477_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 117);

-- Product: Bộ vi xử lý AMD Ryzen 5 5500GT / 3.6GHz Boost 4.4GHz / 6 nhân 12 luồng / 19MB / AM4
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 5 5500GT / 3.6GHz Boost 4.4GHz / 6 nhân 12 luồng / 19MB / AM4', 3990000, N'', N'https://product.hstatic.net/200000722513/product/a_amdryzen5_wgraphics_3dpib_righ_c2564b6e8ec647b1827237adaf34ba4d_master.png', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1851', 65);

-- Product: Bộ vi xử lý AMD Ryzen 5 5600GT / 3.6GHz Boost 4.6GHz / 6 nhân 12 luồng / 19MB / AM4
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 5 5600GT / 3.6GHz Boost 4.6GHz / 6 nhân 12 luồng / 19MB / AM4', 4490000, N'', N'https://product.hstatic.net/200000722513/product/u-ly-amd-ryzen-5-5600gt-3-6ghz-boost-4-6ghz-6-nhan-12-luong-19mb-am4-1_a3b93f80457b41dcaceba9e11e1dc21e_master.jpg', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1851', 65);

-- Product: Bộ vi xử lý AMD Ryzen 5 8600G / 4.3GHz Boost 5.0GHz / 6 nhân 12 luồng / 22MB / AM5
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 5 8600G / 4.3GHz Boost 5.0GHz / 6 nhân 12 luồng / 22MB / AM5', 6990000, N'', N'https://product.hstatic.net/200000722513/product/gearvn-bo-vi-xu-ly-amd-ryzen-5-8600g-1_8d200390a2de4022b8b0d3131730a762_master.png', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1851', 65);

-- Product: Bộ vi xử lý AMD Ryzen 7 8700G / 4.2GHz Boost 5.1GHz / 8 nhân 16 luồng / 24MB / AM5
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 7 8700G / 4.2GHz Boost 5.1GHz / 8 nhân 16 luồng / 24MB / AM5', 9490000, N'', N'https://product.hstatic.net/200000722513/product/gearvn-bo-vi-xu-ly-amd-ryzen-7-8700g-1_8dc602aee46e43a89d055cce370bf51f_master.png', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1851', 65);

-- Product: Bộ vi xử lý Intel Core i3 14100 / Turbo up to 4.7GHz / 4 Nhân 8 Luồng / 12MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i3 14100 / Turbo up to 4.7GHz / 4 Nhân 8 Luồng / 12MB / LGA 1700', 3890000, N'', N'https://product.hstatic.net/200000722513/product/n22751-001-rpl-i3-fhs-dva-bc-univ_png_2345817de4254e87a385f40bd0dbb480_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 110);

-- Product: Bộ vi xử lý Intel Core i5 14400F / Turbo up to 4.7GHz / 10 Nhân 16 Luồng / 20MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i5 14400F / Turbo up to 4.7GHz / 10 Nhân 16 Luồng / 20MB / LGA 1700', 5690000, N'', N'https://product.hstatic.net/200000722513/product/n22561-001-i5f-_univ_2e1135c9919d46ce97e95d2e19cb74f3_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 148);

-- Product: Bộ vi xử lý Intel Core i5 14400 / Turbo up to 4.7GHz / 10 Nhân 16 Luồng / 20MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i5 14400 / Turbo up to 4.7GHz / 10 Nhân 16 Luồng / 20MB / LGA 1700', 7690000, N'', N'https://product.hstatic.net/200000722513/product/n22635-001-rpl-i5-fhs-dva-bc-univ_png_75fcc375fc9541b2b86458c8890a4dba_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 148);

-- Product: Bộ vi xử lý Intel Core i5 14500 / Turbo up to 5.0GHz / 14 Nhân 20 Luồng / 24MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i5 14500 / Turbo up to 5.0GHz / 14 Nhân 20 Luồng / 24MB / LGA 1700', 6690000, N'', N'https://product.hstatic.net/200000722513/product/n22635-001-rpl-i5-fhs-dva-bc-univ_png_413dec9963c14344a48ec62451a1edb3_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 154);

-- Product: Bộ vi xử lý Intel Core i7 14700F / Turbo up to 5.4GHz / 20 Nhân 28 Luồng / 33MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i7 14700F / Turbo up to 5.4GHz / 20 Nhân 28 Luồng / 33MB / LGA 1700', 11290000, N'', N'https://product.hstatic.net/200000722513/product/n22459-001-rpl-i7f-fhs-dva-bc-univ_png_21fc4faaaca646ae9804e8bcc729ae57_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 219);

-- Product: Bộ vi xử lý Intel Core i7 14700 / Turbo up to 5.4GHz / 20 Nhân 28 Luồng / 33MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i7 14700 / Turbo up to 5.4GHz / 20 Nhân 28 Luồng / 33MB / LGA 1700', 11990000, N'', N'https://product.hstatic.net/200000722513/product/n22488-001_db9abfdfc85b4585955cd1bf15aced2d_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 219);

-- Product: Bộ vi xử lý Intel Core i3 14100F / Turbo up to 4.7GHz / 4 Nhân 8 Luồng / 12MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i3 14100F / Turbo up to 4.7GHz / 4 Nhân 8 Luồng / 12MB / LGA 1700', 3190000, N'', N'https://product.hstatic.net/200000722513/product/n22746-001-rpl-i3f-fhs-dva-bc-univ_png_b7e80ee4a06f4662b2aa7f3d6ec97364_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 110);

-- Product: Bộ vi xử lý Intel Core i5 14600KF / Turbo up to 5.3GHz / 14 Nhân 20 Luồng / 24MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i5 14600KF / Turbo up to 5.3GHz / 14 Nhân 20 Luồng / 24MB / LGA 1700', 6190000, N'', N'https://product.hstatic.net/200000722513/product/n22498_png_5e7a710b9b4a40bf8c1b7d0edd860c66_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 181);

-- Product: Bộ vi xử lý Intel Core i5 14600K / Turbo up to 5.3GHz / 14 Nhân 20 Luồng / 24MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i5 14600K / Turbo up to 5.3GHz / 14 Nhân 20 Luồng / 24MB / LGA 1700', 6690000, N'', N'https://product.hstatic.net/200000722513/product/n22490-001-rpl-i5k-univ_png_dd9c15cdc33d45e5963d0a5f73f47f1d_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 181);

-- Product: Bộ vi xử lý Intel Core i7 14700KF / Turbo up to 5.6GHz / 20 Nhân 28 Luồng / 33MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i7 14700KF / Turbo up to 5.6GHz / 20 Nhân 28 Luồng / 33MB / LGA 1700', 11490000, N'', N'https://product.hstatic.net/200000722513/product/i7kf_3120825e0dbf418a939c18cdac94253b_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 253);

-- Product: Bộ vi xử lý Intel Core i7 14700K / Turbo up to 5.6GHz / 20 Nhân 28 Luồng / 33MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i7 14700K / Turbo up to 5.6GHz / 20 Nhân 28 Luồng / 33MB / LGA 1700', 13990000, N'', N'https://product.hstatic.net/200000722513/product/i7k_a1416a616a0a45358557b5348014b46b_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 253);

-- Product: Bộ vi xử lý Intel Core i9 14900KF / Turbo up to 6.0GHz / 24 Nhân 32 Luồng / 36MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i9 14900KF / Turbo up to 6.0GHz / 24 Nhân 32 Luồng / 36MB / LGA 1700', 16490000, N'', N'https://product.hstatic.net/200000722513/product/i9kf_0d8eca19326140198fc327f9ff699fb1_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 253);

-- Product: Bộ vi xử lý Intel Core i9 14900K / Turbo up to 6.0GHz / 24 Nhân 32 Luồng / 36MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i9 14900K / Turbo up to 6.0GHz / 24 Nhân 32 Luồng / 36MB / LGA 1700', 15990000, N'', N'https://product.hstatic.net/200000722513/product/i9k_379efd950af74727a83b02c13817a3a7_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 253);

-- Product: Bộ vi xử lý Intel Core i5 13400F / 2.5GHz Turbo 4.6GHz / 10 Nhân 16 Luồng / 20MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i5 13400F / 2.5GHz Turbo 4.6GHz / 10 Nhân 16 Luồng / 20MB / LGA 1700', 3690000, N'', N'https://product.hstatic.net/200000722513/product/13400f_4988446fd3b649d48605ab2a6586b28b_477f77739aa94fee90c99c709e47fcf4_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 148);

-- Product: Bộ vi xử lý Intel Core i5 13400 / 2.5GHz Turbo 4.6GHz / 10 Nhân 16 Luồng / 20MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i5 13400 / 2.5GHz Turbo 4.6GHz / 10 Nhân 16 Luồng / 20MB / LGA 1700', 6690000, N'', N'https://product.hstatic.net/200000722513/product/13400_ce4e7f52df5045a7b0a4f2c689136488_493622b9e0ca41ce8f6cc0cf51cee012_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 148);

-- Product: Bộ vi xử lý Intel Core i5 12400F / 2.5GHz Turbo 4.4GHz / 6 Nhân 12 Luồng / 18MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i5 12400F / 2.5GHz Turbo 4.4GHz / 6 Nhân 12 Luồng / 18MB / LGA 1700', 4790000, N'', N'https://product.hstatic.net/200000722513/product/12400f_cadecfed12d84fcf836b65ae7179a9e0_abe30b4a782c4e5899a6f9e6eda7e797_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 117);

-- Product: Bộ vi xử lý Intel Core i5 12400 / 2.5GHz Turbo 4.4GHz / 6 Nhân 12 Luồng / 18MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i5 12400 / 2.5GHz Turbo 4.4GHz / 6 Nhân 12 Luồng / 18MB / LGA 1700', 5690000, N'', N'https://product.hstatic.net/200000722513/product/12400_7150a7594d524982ba859a04ed952903_938a2a0ca05546eb940547a6d50e7bda_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 117);

-- Product: Bộ vi xử lý Intel Core i3 13100F / 3.4GHz Turbo 4.5GHz / 4 Nhân 8 Luồng / 12MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i3 13100F / 3.4GHz Turbo 4.5GHz / 4 Nhân 8 Luồng / 12MB / LGA 1700', 3290000, N'', N'https://product.hstatic.net/200000722513/product/13100f_b27fcb29892e4ec29981a79190289db0_3647022852e94b4c8303d3572b81ba41_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 110);

-- Product: Bộ vi xử lý Intel Core i3 12100F / 3.3GHz Turbo 4.3GHz / 4 Nhân 8 Luồng / 12MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i3 12100F / 3.3GHz Turbo 4.3GHz / 4 Nhân 8 Luồng / 12MB / LGA 1700', 3190000, N'', N'https://product.hstatic.net/200000722513/product/12100f_d81914f75c254dba985d80033b522662_c3458e8ae6a24c8881b4ae103f0b6a6d_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 89);

-- Product: Bộ vi xử lý Intel Core i3 12100 / 3.3GHz Turbo 4.3GHz / 4 Nhân 8 Luồng / 12MB / LGA 1700
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core i3 12100 / 3.3GHz Turbo 4.3GHz / 4 Nhân 8 Luồng / 12MB / LGA 1700', 3390000, N'', N'https://product.hstatic.net/200000722513/product/i3_gen12_ed05d8beb7ac4245be9cd60ba2ef5570_b80e235ecd314f78b739113a85f5f1e6_master.png', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 89);

-- Product: Bộ vi xử lý AMD Ryzen 9 7900X / 4.7GHz Boost 5.6GHz / 12 nhân 24 luồng / 76MB / AM5
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 9 7900X / 4.7GHz Boost 5.6GHz / 12 nhân 24 luồng / 76MB / AM5', 12290000, N'', N'https://product.hstatic.net/200000722513/product/ryzen_9_-_1_5157911128a742f3bde4732cf4abdfb2_806c446fab4b42b6b6c71b298e08f563_master.jpg', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 170);

-- Product: Bộ vi xử lý AMD Ryzen 7 7800X3D / 4.2GHz Boost 5.0GHz / 8 nhân 16 luồng / 104MB / AM5
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 7 7800X3D / 4.2GHz Boost 5.0GHz / 8 nhân 16 luồng / 104MB / AM5', 11990000, N'', N'https://product.hstatic.net/200000722513/product/ryzen-7-7800x3d-600x600_30d6f05d43524a6c950830a366e4f4eb_2fb2daf9ef7d4faf92f0b1ed1612b1a0_master.png', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 120);

-- Product: Bộ vi xử lý AMD Ryzen 7 7700X / 4.5GHz Boost 5.4GHz / 8 nhân 16 luồng / 40MB / AM5
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 7 7700X / 4.5GHz Boost 5.4GHz / 8 nhân 16 luồng / 40MB / AM5', 10990000, N'', N'https://product.hstatic.net/200000722513/product/ryzen_7_-_1_00957bbe7b8542308c897a90d439b1fd_e1c9a16c537d47bb9768828dddb332d0_master.jpg', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 105);

-- Product: Bộ vi xử lý AMD Ryzen 5 7600X / 4.7GHz Boost 5.3GHz / 6 nhân 12 luồng / 38MB / AM5
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 5 7600X / 4.7GHz Boost 5.3GHz / 6 nhân 12 luồng / 38MB / AM5', 6490000, N'', N'https://product.hstatic.net/200000722513/product/ryzen_5_-_1_be51e69b02cf4ed78a758a6337e56a27_ae6fad038dff4fa985e2e4b86abc8d85_master.jpg', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 105);

-- Product: Bộ vi xử lý AMD Ryzen 5 7600 / 3.8GHz Boost 5.1GHz / 6 nhân 12 luồng / 38MB / AM5
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 5 7600 / 3.8GHz Boost 5.1GHz / 6 nhân 12 luồng / 38MB / AM5', 5790000, N'', N'https://product.hstatic.net/200000722513/product/gearvn-amd-ryzen-5-7600-1_fea6e6c8d31a452fb221d1d78261bc47_3169b43038fd4de98a0d0e32feca33a0_master.png', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 65);

-- Product: Bộ vi xử lý AMD Ryzen 3 4300G / 3.8GHz Boost 4.0GHz / 4 nhân 8 luồng / 6MB / AM4
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 3 4300G / 3.8GHz Boost 4.0GHz / 4 nhân 8 luồng / 6MB / AM4', 2490000, N'', N'https://product.hstatic.net/200000722513/product/-4300g-processor-with-radeon-graphics_f334518704cc40e19a7198cee54d14f7_781e7f3301cd49a9b6180ae3d1bf0a97_master.png', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 65);

-- Product: Bộ vi xử lý AMD Ryzen 3 3200G / 3.6GHz Boost 4.0GHz / 4 nhân 4 luồng / 4MB / AM4
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 3 3200G / 3.6GHz Boost 4.0GHz / 4 nhân 4 luồng / 4MB / AM4', 1990000, N'', N'https://product.hstatic.net/200000722513/product/ryzen_5_3200g_gearvn_e799782ec0cd4d46b675a04c2a399a45_e18d2021b0a844239691ebc57beb1c2a_master.jpg', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 65);

-- Product: Bộ vi xử lý AMD Athlon 3000G / 3.5GHz / 2 nhân 4 luồng / 5MB / AM4
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Athlon 3000G / 3.5GHz / 2 nhân 4 luồng / 5MB / AM4', 1390000, N'', N'https://product.hstatic.net/200000722513/product/gearvn-amd-athlon-3000g_9a96ebfbbf3f43c7a61cdba59b00e5b5_fc7e2a8f09b24c55b154d39cf9ce96a7_master.jpg', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 35);

-- Product: Bộ vi xử lý AMD Ryzen 7 9850X3D / 4.7GHz Boost 5.6GHz / 8 nhân 16 luồng / 104MB / AM5
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 7 9850X3D / 4.7GHz Boost 5.6GHz / 8 nhân 16 luồng / 104MB / AM5', 15990000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-bo-vi-xu-ly-amd-ryzen9-9850x3d-1_517a4efa6cbd4aa5830e9e2387c4bf97_master.png', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 120);

-- Product: Bộ vi xử lý AMD Ryzen 5 7500F / 3.7GHz Boost 5.0GHz / 6 nhân 12 luồng / 38MB / AM5 (Tray)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 5 7500F / 3.7GHz Boost 5.0GHz / 6 nhân 12 luồng / 38MB / AM5 (Tray)', 4790000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-bo-vi-xu-ly-amd-ryzen-5-7500f-tray-1_3fb95c47b67a41dfa1a5b291fc008df1_master.png', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 0, 0, N'LGA 1700', 65);

-- Product: Bộ vi xử lý AMD Ryzen 7 9800X3D / 4.7GHz Boost 5.2GHz / 8 nhân 16 luồng / 104MB / AM5 (Tray)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý AMD Ryzen 7 9800X3D / 4.7GHz Boost 5.2GHz / 8 nhân 16 luồng / 104MB / AM5 (Tray)', 14790000, N'', N'https://cdn.hstatic.net/products/200000722513/bo-vi-xu-ly-amd-ryzen-7-9800x3d-tray-1_691bda07cba94f7fa8b50f9d594b554b_master.png', 1, 10, N'AMD', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 0, 0, N'LGA 1700', 120);

-- Product: Bộ vi xử lý Intel Core Ultra 5 225F / Turbo up to 4.9 GHz / 10 Nhân 10 Luồng / 20MB / LGA 1851
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core Ultra 5 225F / Turbo up to 4.9 GHz / 10 Nhân 10 Luồng / 20MB / LGA 1851', 6990000, N'', N'https://product.hstatic.net/200000722513/product/24game_intel_coreultra_nonk_box_image_5_67eafaaec7ea44f4af561f3ed43efa51_master.jpg', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 121);

-- Product: Bộ vi xử lý Intel Core Ultra 5 225 / Turbo up to 4.9 GHz / 10 Nhân 10 Luồng / 20MB / LGA 1851
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core Ultra 5 225 / Turbo up to 4.9 GHz / 10 Nhân 10 Luồng / 20MB / LGA 1851', 7490000, N'', N'https://product.hstatic.net/200000722513/product/24game_intel_coreultra_nonk_box_image_5_0ad275ed9f814c58b3bd64bd153341de_master.jpg', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1700', 121);

-- Product: Bộ vi xử lý Intel Core Ultra 5 235 / Turbo up to 5.0 GHz / 14 Nhân 14 Luồng / 24MB / LGA 1851
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core Ultra 5 235 / Turbo up to 5.0 GHz / 14 Nhân 14 Luồng / 24MB / LGA 1851', 7990000, N'', N'https://product.hstatic.net/200000722513/product/24game_intel_coreultra_nonk_box_image_5_4d7affe9976c4fa480f756f12885aa37_master.jpg', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1851', 121);

-- Product: Bộ vi xử lý Intel Core Ultra 7 265F / Turbo up to 5.3GHz / 20 Nhân 20 Luồng / 30MB / LGA 1851
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core Ultra 7 265F / Turbo up to 5.3GHz / 20 Nhân 20 Luồng / 30MB / LGA 1851', 10490000, N'', N'https://product.hstatic.net/200000722513/product/24game_intel_coreultra_nonk_box_image_7_493896b8ff7f4c07aeddba47fe08b8b9_master.jpg', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1851', 182);

-- Product: Bộ vi xử lý Intel Core Ultra 7 265 / Turbo up to 5.3GHz / 20 Nhân 20 Luồng / 30MB / LGA 1851
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Bộ vi xử lý Intel Core Ultra 7 265 / Turbo up to 5.3GHz / 20 Nhân 20 Luồng / 30MB / LGA 1851', 10990000, N'', N'https://product.hstatic.net/200000722513/product/24game_intel_coreultra_nonk_box_image_7_e0e526ece38e4191a0a67de6b1ea7056_master.jpg', 1, 10, N'Intel', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 1, 0, N'LGA 1851', 182);

-- Product: Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Máy bộ Acer Altos P130F7 (I5/RAM 8GB/SSD 512GB)', 11990000, N'', N'https://cdn.hstatic.net/products/200000722513/9_66f2dbd32b434349bde87279735d6f7c_master.jpg', 1, 10, N'ACER', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket) VALUES (@current_pid, 0, 0, N'LGA 1851');

-- Product: PC GVN Homework Athlon
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'PC GVN Homework Athlon', 7190000, N'', N'https://product.hstatic.net/200000722513/product/_gvn7295_0583998cf254405d847193c7cb07c1e8_7bdd8243700a436eaee81719c239c218_master.jpg', 1, 10, N'GEARVN', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 0, 0, N'LGA 1851', 350);

-- Product: PC GVN Homework R3
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'PC GVN Homework R3', 7630000, N'', N'https://product.hstatic.net/200000722513/product/_gvn7410_ec6ca353fcd24dcb9e0c6e3f428c0c0a_4ed5c8f2b7554c76894433077a66ac43_master.jpg', 1, 10, N'GEARVN', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 0, 0, N'LGA 1851', 350);

-- Product: PC GVN Homework R5
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'PC GVN Homework R5', 10390000, N'', N'https://product.hstatic.net/200000722513/product/_gvn7295_d3fbea4fe4204126a2d67689baaf043a_master.jpg', 1, 10, N'GEARVN', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 0, 0, N'LGA 1851', 350);

-- Product: PC GVN Homework i5
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'PC GVN Homework i5', 12990000, N'', N'https://cdn.hstatic.net/products/200000722513/homework2_15f1c6db7eb04ef7b6b889ee26aee130_master.jpg', 1, 10, N'GEARVN', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 0, 0, N'LGA 1700', 350);

-- Product: Phần mềm Windows 11 Home Online DwnLd NR KW9-00664
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Phần mềm Windows 11 Home Online DwnLd NR KW9-00664', 3490000, N'', N'https://product.hstatic.net/200000722513/product/home_online_dwnld_nr_kw9-00664_gearvn_1af7af131f934c3f9b0b98de4cbea282_6ed5acc9d8bd4266806a53d43ba2863a_master.jpg', 1, 10, N'MICROSOFT', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket) VALUES (@current_pid, 0, 0, N'LGA 1851');

-- Product: Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Phần mềm Windows 11 Pro Online DwnLd NR FQC-10572', 5150000, N'', N'https://product.hstatic.net/200000722513/product/_pro_online_dwnld_nr_fqc-10572_gearvn_dc5a004e0330424c816d20c0a5a31870_6f1e5c53e966459181ef80ade54457aa_master.jpg', 1, 10, N'KHÁC', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket) VALUES (@current_pid, 0, 0, N'LGA 1851');

-- Product: Máy chơi game MSI Claw A1M
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Máy chơi game MSI Claw A1M', 14990000, N'', N'https://product.hstatic.net/200000722513/product/may-choi-game-msi-claw-a1m-049vn_9e71b95c111446598e8ff8090302a175_39f190f469d248d585024b6203d40112_master.png', 1, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 0, 0, N'LGA 1851', 2);

-- Product: Máy chơi Game cầm tay Lenovo Legion GO
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Máy chơi Game cầm tay Lenovo Legion GO', 22990000, N'', N'https://product.hstatic.net/200000722513/product/ame-lenovo-legion-go-8apu1-83e1004kvn_f1762ad226cf419695059a68d0b3e2f7_5dff1a71b14448019b7f55a506e103de_master.png', 1, 10, N'LENOVO', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO cpu_specs (product_id, has_igpu, includes_stock_cooler, socket, tdp_max) VALUES (@current_pid, 0, 0, N'LGA 1851', 30);

-- Product: Card màn hình Zotac GEFORCE RTX 3050 TWIN EDGE OC 6GB GDDR6
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Zotac GEFORCE RTX 3050 TWIN EDGE OC 6GB GDDR6', 5990000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-card-man-hinh-zotac-geforce-rtx-3050-twin-edge-oc-6gb-gddr6-1_e9794c36546f467fad0798e2fa17619a_master.png', 2, 10, N'ZOTAC', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 70, 0, 0);

-- Product: Card màn hình Gigabyte GeForce RTX 5050 Gaming OC 8GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Gigabyte GeForce RTX 5050 Gaming OC 8GB', 8890000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-card-man-hinh-gigabyte-geforce-rtx-5050-gaming-oc-8gbs-__1__eb529ef60a1c4765991945f93c8a49a7_master.png', 2, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 40, 0, 0);

-- Product: Card màn hình ZOTAC GAMING GeForce RTX 5070 SOLID OC (ZT-B50700J-10P)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình ZOTAC GAMING GeForce RTX 5070 SOLID OC (ZT-B50700J-10P)', 19990000, N'', N'https://cdn.hstatic.net/products/200000722513/card-man-hinh-zotac-gaming-geforce-rtx-5070-solid-oc-1_6d0aee3bfa19460a9bf2649cc47c3c92_master.jpg', 2, 10, N'ZOTAC', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 0);

-- Product: Card màn hình MSI GeForce RTX 5090 LIGHTNING Z 32GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 5090 LIGHTNING Z 32GB', 199990000, N'', N'https://cdn.hstatic.net/products/200000722513/card-man-hinh-msi-geforce-rtx-5090-lightning-z-32gb-1_5ec0c602c4754a249a0754748f4739cf_master.jpg', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 360, 1, 0);

-- Product: Card màn hình Zotac GeForce RTX 5060 Ti 8GB Moon White OC
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Zotac GeForce RTX 5060 Ti 8GB Moon White OC', 13890000, N'', N'https://cdn.hstatic.net/products/200000722513/card-man-hinh-zotac-geforce-rtx-5060-ti-8gb-moon-white-oc-4_a9be9d0c165c45d4a6cf4384cfae2f49_master.jpg', 2, 10, N'ZOTAC', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 0);

-- Product: Card màn hình SPARKLE Intel Arc B580 TWINSTAR OC 12GB GDDR6
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình SPARKLE Intel Arc B580 TWINSTAR OC 12GB GDDR6', 9690000, N'', N'https://cdn.hstatic.net/products/200000722513/card-man-hinh-sparkle-intel-arc-b580-twinstar-oc-12gb-gddr6-1_acd5165b13394983b3a4ed918d4f5485_master.jpg', 2, 10, N'SPARKLE', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 0);

-- Product: Card màn hình Zotac GeForce RTX 5060 Ti 16GB Twin Edge OC
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Zotac GeForce RTX 5060 Ti 16GB Twin Edge OC', 17990000, N'', N'https://cdn.hstatic.net/products/200000722513/card-man-hinh-zotac-geforce-rtx-5060-ti-16gb-twin-edge-oc-1_dac94c44dd544e3294304c03379aa29a_master.jpg', 2, 10, N'ZOTAC', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 1);

-- Product: Card màn hình MSI GeForce RTX 5060 Ventus 2X OC V1 8GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 5060 Ventus 2X OC V1 8GB', 10990000, N'', N'https://cdn.hstatic.net/products/200000722513/card-man-hinh-msi-geforce-rtx-5060-ventus-2x-oc-v1-8gb-1_6c4e1e1337c54b82a76a7aac5ede144d_master.jpg', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 0);

-- Product: Card màn hình Zotac GeForce RTX 5070Ti Solid Core OC 16GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Zotac GeForce RTX 5070Ti Solid Core OC 16GB', 28990000, N'', N'https://cdn.hstatic.net/products/200000722513/card-man-hinh-zotac-geforce-rtx-5070ti-solid-core-oc-16gb-1_65d4babb42794bdf9848ce2ed8e2fb44_master.jpg', 2, 10, N'ZOTAC', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 0);

-- Product: Card màn hình Zotac GeForce RTX 5080 Solid Core OC 16GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Zotac GeForce RTX 5080 Solid Core OC 16GB', 37990000, N'', N'https://cdn.hstatic.net/products/200000722513/card-man-hinh-zotac-geforce-rtx-5080-solid-core-oc-16gb-1_a40a16bb137e4cdfb14adcb651f410e3_master.jpg', 2, 10, N'ZOTAC', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 0);

-- Product: Card màn hình Gigabyte GeForce RTX 5060 Windforce Max OC 8GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Gigabyte GeForce RTX 5060 Windforce Max OC 8GB', 10990000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-card-man-hinh-gigabyte-geforce-rtx-5060-windforce-max-oc-8gb-2_5b2a90610a9d45dcb488a85d9e718967_master.png', 2, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 40, 0, 1);

-- Product: Card màn hình Zotac GEFORCE RTX 5060 Ti 8GB TWIN EDGE GDDR7
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Zotac GEFORCE RTX 5060 Ti 8GB TWIN EDGE GDDR7', 12490000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-card-man-hinh-zotac-geforce-rtx-5060-ti-8gb-twin-edge-gddr7-1_b24e7357a2d54145abde72422070d176_master.png', 2, 10, N'ZOTAC', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 5, 0, 1);

-- Product: Card màn hình Gigabyte GeForce RTX 5060 Eagle Ice OC 8GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Gigabyte GeForce RTX 5060 Eagle Ice OC 8GB', 9990000, N'', N'https://product.hstatic.net/200000722513/product/geforce_rtx__5060_eagle_oc_ice_8g-01_32d5abc5e32d461e9b8afba671e2b21a_master.png', 2, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 0);

-- Product: Card màn hình GIGABYTE GeForce RTX 4070 SUPER WINDFORCE OC 12G (GV-N407SWF3OC-12GD)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình GIGABYTE GeForce RTX 4070 SUPER WINDFORCE OC 12G (GV-N407SWF3OC-12GD)', 19490000, N'', N'https://product.hstatic.net/200000722513/product/geforce_rtx__4070_super_windforce_oc_12g-02_cb8fbfeb315e480b8cf8698fee120280_master.png', 2, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 50, 0, 0);

-- Product: Card màn hình MSI GeForce RTX 5090 32G VENTUS 3X OC
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 5090 32G VENTUS 3X OC', 124990000, N'', N'https://product.hstatic.net/200000722513/product/1024__1__1c871c9775d54ee98cf82ff7ad2fc2fc_master.png', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 0);

-- Product: Card màn hình GIGABYTE GeForce RTX 3060 WINDFORCE OC 12G V2 (GV-N3060WF2OC-12GD)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình GIGABYTE GeForce RTX 3060 WINDFORCE OC 12G V2 (GV-N3060WF2OC-12GD)', 9990000, N'', N'https://product.hstatic.net/200000722513/product/geforce_rtx__3060_windforce_oc_12g-07_6869382166b043c5be19ae59ce49e61a_master.png', 2, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 39, 0, 0);

-- Product: Card màn hình ASUS Dual Radeon RX 6500 XT V2 OC Edition 4GB GDDR6 (DUAL-RX6500XT-O4G-V2)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình ASUS Dual Radeon RX 6500 XT V2 OC Edition 4GB GDDR6 (DUAL-RX6500XT-O4G-V2)', 3790000, N'', N'https://product.hstatic.net/200000722513/product/fwebp__12__615ffd30b3194e8384bb79f423cb7f41_master.png', 2, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 40, 0, 0);

-- Product: Card màn hình ASUS Dual GeForce RTX 4060 V2 OC Edition 8GB GDDR6 (DUAL-RTX4060-O8G-V2)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình ASUS Dual GeForce RTX 4060 V2 OC Edition 8GB GDDR6 (DUAL-RTX4060-O8G-V2)', 8490000, N'', N'https://product.hstatic.net/200000722513/product/fwebp_f763561886254dc9838eb6d71feaecf3_master.png', 2, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 1, 0, 1);

-- Product: Card màn hình ASUS Dual Radeon RX 7600 V2 OC Edition 8GB GDDR6 (DUAL-RX7600-O8G-V2)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình ASUS Dual Radeon RX 7600 V2 OC Edition 8GB GDDR6 (DUAL-RX7600-O8G-V2)', 7790000, N'', N'https://product.hstatic.net/200000722513/product/fwebp__6__cfffcef0dbca441ea89fe16191bf7368_master.png', 2, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 49, 0, 1);

-- Product: Card màn hình GIGABYTE AORUS GeForce RTX 4080 SUPER XTREME ICE 16G (GV-N408SAORUSX ICE-16GD)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình GIGABYTE AORUS GeForce RTX 4080 SUPER XTREME ICE 16G (GV-N408SAORUSX ICE-16GD)', 39990000, N'', N'https://product.hstatic.net/200000722513/product/aorus_geforce_rtx__4080_super_xtreme_ice_16g-02_73657b76adc1478f829ef65d5c50d996_master.png', 2, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 75, 0, 0);

-- Product: Card màn hình ASUS Dual GeForce RTX 3050 6GB GDDR6 (DUAl-RTX3050-6G)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình ASUS Dual GeForce RTX 3050 6GB GDDR6 (DUAl-RTX3050-6G)', 4690000, N'', N'https://product.hstatic.net/200000722513/product/fwebp__6__1cce2c81d3374da0ae9116a36cc27d69_master.png', 2, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 37, 0, 0);

-- Product: Card màn hình ASUS Dual GeForce RTX 3050 OC Edition 6GB (DUAl-RTX3050-O6G)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình ASUS Dual GeForce RTX 3050 OC Edition 6GB (DUAl-RTX3050-O6G)', 4790000, N'', N'https://product.hstatic.net/200000722513/product/-man-hinh-asus-dual-geforce-rtx-3050-oc-edition-6gb-dual-rtx3050-o6g-5_32785b8f85e2429a84fcc27a80f82c1b_master.png', 2, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 37, 0, 0);

-- Product: Card màn hình MSI GeForce RTX 3050 VENTUS 2X 6G OC
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 3050 VENTUS 2X 6G OC', 4990000, N'', N'https://product.hstatic.net/200000722513/product/gearvn-card-man-hinh-msi-geforce-rtx-3050-ventus-2x-6g-oc-1_0a3f8d13c887450cac4c18ca4bc85e26_master.png', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 42, 0, 0);

-- Product: Card màn hình ASUS Dual GeForce GTX 1650 OC Edition 4GB GDDR6 EVO (DUAL-GTX1650-O4GD6-P-EVO)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình ASUS Dual GeForce GTX 1650 OC Edition 4GB GDDR6 EVO (DUAL-GTX1650-O4GD6-P-EVO)', 3690000, N'', N'https://product.hstatic.net/200000722513/product/l-geforce-gtx-1650-oc-edition-4gb-gddr6-evo-dual-gtx1650-o4gd6-p-evo-1_e3dd9060476046649389fada52aa1327_master.jpg', 2, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 0);

-- Product: Card màn hình MSI GeForce RTX 4060 VENTUS 2X WHITE 8G OC
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 4060 VENTUS 2X WHITE 8G OC', 8990000, N'', N'https://product.hstatic.net/200000722513/product/1024_fd1082e7b88a433fba74748967ff14ee_master.png', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 41, 0, 0);

-- Product: Card màn hình MSI GeForce RTX 3050 VENTUS 2X XS 8G OC
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 3050 VENTUS 2X XS 8G OC', 5990000, N'', N'https://product.hstatic.net/200000722513/product/1024__1__ef5bef961ca247dfbbabf177dc43b783_master.png', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 42, 0, 0);

-- Product: Card màn hình MSI GeForce RTX 4060 VENTUS 2X BLACK 8G OC
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 4060 VENTUS 2X BLACK 8G OC', 8490000, N'', N'https://product.hstatic.net/200000722513/product/rtx_4060_ventus_2x_black_8g_oc_c34ea8c824fb4afb9f1241cec761e799_master.png', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 41, 0, 1);

-- Product: Card màn hình MSI GeForce RTX 3060 Ventus 2X OC 12G
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 3060 Ventus 2X OC 12G', 9990000, N'', N'https://product.hstatic.net/200000722513/product/1024_8cf8d2e8bf3b46eb9a15cb1d790b0130_master.png', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 42, 0, 1);

-- Product: Card màn hình ASUS Dual GeForce RTX 3060 OC Edition 12GB V2 (DUAL-RTX3060-O12G-V2)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình ASUS Dual GeForce RTX 3060 OC Edition 12GB V2 (DUAL-RTX3060-O12G-V2)', 7890000, N'', N'https://product.hstatic.net/200000722513/product/dual-rtx3060-o12g-01_303eda4235a448c1b6993819a6009141_4ef40d3eba3444b09070dccc38fd681d_master.jpg', 2, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 1);

-- Product: MSI GeForce GTX 1650 SUPER GAMING X 4GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'MSI GeForce GTX 1650 SUPER GAMING X 4GB', 8590000, N'', N'https://product.hstatic.net/200000722513/product/msi-gtx-1650-super-gaming-x-4gb-1_7259676890764aed9abf256b4b9c9af2_5947378c42ab4dbd8bf2e234e7b6762d_master.png', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 44, 0, 0);

-- Product: Card màn hình Leadtek NVIDIA RTX PRO 4000 Blackwell 24GB GDDR7
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Leadtek NVIDIA RTX PRO 4000 Blackwell 24GB GDDR7', 59990000, N'', N'https://cdn.hstatic.net/products/200000722513/card-man-hinh-leadtek-nvidia-rtx-pro-4000-blackwell-24gb-gddr7-4_5f78b4bc1888417e8135c36832cba943_master.jpg', 2, 10, N'NVIDIA', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 0);

-- Product: Card màn hình MSI GeForce RTX 5060 Ti Shadow 2X OC Plus 8GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 5060 Ti Shadow 2X OC Plus 8GB', 12990000, N'', N'https://cdn.hstatic.net/products/200000722513/card-man-hinh-msi-geforce-rtx-5060-ti-shadow-2x-oc-plus-8gb-1_7e43a2d2371949d0a0167953c3bba6ae_master.jpg', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 41, 0, 1);

-- Product: Card màn hình Leadtek NVIDIA RTX PRO 5000 Blackwell 48GB GDDR7
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Leadtek NVIDIA RTX PRO 5000 Blackwell 48GB GDDR7', 216990000, N'', N'https://cdn.hstatic.net/products/200000722513/card-man-hinh-leadtek-nvidia-rtx-pro-5000-blackwell-48gb-gddr7-2_9eaa0910b0fc4deeab8a2d233a2b8217_master.jpg', 2, 10, N'LEADTEK', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 0);

-- Product: Card màn hình ASUS ROG Astral EDITION 20 GeForce RTX 5090 32GB GDDR7
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình ASUS ROG Astral EDITION 20 GeForce RTX 5090 32GB GDDR7', 199990000, N'', N'https://cdn.hstatic.net/products/200000722513/card-man-hinh-asus-rog-astral-edition-20-geforce-rtx-5090-32gb-gddr7-1_21f97caf493248a382efcfa72715413d_master.jpg', 2, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 0);

-- Product: Card màn hình SPARKLE Intel Arc B580 TITAN Nox OC 12GB GDDR6
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình SPARKLE Intel Arc B580 TITAN Nox OC 12GB GDDR6', 9690000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-card-man-hinh-sparkle-intel-arc-b580-titan-nox-oc-12gb-gddr6-1_d06a21d85a46445f85652d657036c70b_master.png', 2, 10, N'SPARKLE', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 315, 0, 1);

-- Product: Card màn hình SPARKLE Intel Arc B580 TITAN OC 12GB GDDR6
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình SPARKLE Intel Arc B580 TITAN OC 12GB GDDR6', 9690000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-card-man-hinh-sparkle-intel-arc-b580-titan-oc-12gb-gddr6-1_843826008dae4aefa1eb0aec3103fa11_master.png', 2, 10, N'SPARKLE', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 44, 0, 1);

-- Product: Card màn hình Zotac GeForce RTX 5060 Ti 16GB Twin Edge
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Zotac GeForce RTX 5060 Ti 16GB Twin Edge', 14990000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-card-man-hinh-zotac-geforce-rtx-5060-ti-16gb-twin-edge-1_870d103b4f164bd9b476631e6f8ef82b_master.png', 2, 10, N'ZOTAC', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 6, 0, 0);

-- Product: Card màn hình Zotac GEFORCE RTX 5050 TWIN EDGE OC 8GB GDDR6
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Zotac GEFORCE RTX 5050 TWIN EDGE OC 8GB GDDR6', 8990000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-card-man-hinh-zotac-geforce-rtx-5050-twin-edge-oc-8gb-gddr6-1_2ee100bc3e28421db69856a4f3d85e12_master.png', 2, 10, N'ZOTAC', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 5, 0, 1);

-- Product: Card màn hình ZOTAC GAMING GeForce RTX 5070 AMP White Edition (ZT-B50700FQ-10P)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình ZOTAC GAMING GeForce RTX 5070 AMP White Edition (ZT-B50700FQ-10P)', 18990000, N'', N'https://cdn.hstatic.net/products/200000722513/card-man-hinh-zotac-gaming-geforce-rtx-5070-amp-white-edition-1_2bd6477cf68d4096b047224db713b7a1_master.png', 2, 10, N'ZOTAC', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 4, 1, 1);

-- Product: Card màn hình GIGABYTE GeForce RTX 3050 WINDFORCE OC V2 8G (GV-N3050WF2OCV2-8GD)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình GIGABYTE GeForce RTX 3050 WINDFORCE OC V2 8G (GV-N3050WF2OCV2-8GD)', 8390000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-card-man-hinh-gigabyte-geforce-rtx-3050-windforce-oc-v2-8g-1_46f8826f266842bbb624e976c8d5b854_master.png', 2, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 39, 0, 1);

-- Product: Card màn hình Gigabyte GeForce RTX 5060 Eagle OC 8GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Gigabyte GeForce RTX 5060 Eagle OC 8GB', 10890000, N'', N'https://product.hstatic.net/200000722513/product/geforce_rtx__5060_eagle_oc_8g-01_4cbdb294b6d84395a3466822f8068e0a_master.png', 2, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 0, 0);

-- Product: Card màn hình MSI GeForce RTX 5060 Ti Ventus 2X Plus 8GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 5060 Ti Ventus 2X Plus 8GB', 12990000, N'', N'https://product.hstatic.net/200000722513/product/card_m_n_h_nh_msi_geforce_rtx_5060_ti_ventus_2x_plus_8gb-1_a3c693757a04401183bd4bf4b621eef8_master.jpeg', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 240, 0, 0);

-- Product: Card màn hình MSI GeForce RTX 5060 Gaming Trio OC White 8GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 5060 Gaming Trio OC White 8GB', 12990000, N'', N'https://product.hstatic.net/200000722513/product/card_m_n_h_nh_msi_geforce_rtx_5060_gaming_trio_oc_white_8gb-1_48341e2ebdba476091826341f50397d6_master.png', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 240, 0, 1);

-- Product: Card màn hình MSI GeForce RTX 5060 Gaming Trio OC 8GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 5060 Gaming Trio OC 8GB', 12990000, N'', N'https://product.hstatic.net/200000722513/product/card_m_n_h_nh_msi_geforce_rtx_5060_gaming_trio_oc_8gb_07709bbb798d477b88704c694865676f_master.png', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 240, 0, 0);

-- Product: Card màn hình ASUS ROG Astral GeForce RTX 5080 16GB GDDR7 OC Edition (ROG-ASTRAL-RTX5080-O16G-GAMING) White Edition
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình ASUS ROG Astral GeForce RTX 5080 16GB GDDR7 OC Edition (ROG-ASTRAL-RTX5080-O16G-GAMING) White Edition', 53990000, N'', N'https://product.hstatic.net/200000722513/product/asus_rog_astral_geforce_rtx_5080_16gb_gddr7_oc_edition_-_01_5fb1fbd701fb469d8c8826ab3ea17a96_master.png', 2, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 240, 1, 0);

-- Product: Card màn hình MSI GeForce RTX 5060 Ventus 2X OC White 8GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 5060 Ventus 2X OC White 8GB', 11490000, N'', N'https://product.hstatic.net/200000722513/product/card_m_n_h_nh_msi_geforce_rtx_5060_ventus_2x_oc_white_8gb_-_1_bfad2f9b1f304709a5cdd7f0946064a6_master.jpg', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 240, 0, 0);

-- Product: Card màn hình ASUS Dual GeForce RTX 5070 12GB GDDR7 OC Edition
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình ASUS Dual GeForce RTX 5070 12GB GDDR7 OC Edition', 19990000, N'', N'https://product.hstatic.net/200000722513/product/card_m_n_h_nh_asus_dual_geforce_rtx_5070_12gb_gddr7_oc_edition_-_1_10106113efc04c55ae65e9f833eb6805_master.png', 2, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 240, 0, 0);

-- Product: Card màn hình Zotac GeForce RTX 5060 Twin Edge OC 8GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình Zotac GeForce RTX 5060 Twin Edge OC 8GB', 9690000, N'', N'https://product.hstatic.net/200000722513/product/card_m_n_h_nh_zotac_geforce_rtx_5060_twin_edge_oc_8gb_-1_9a171dd9625e467b814fdb1e35b44445_master.jpg', 2, 10, N'ZOTAC', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 240, 0, 0);

-- Product: Card màn hình MSI GeForce RTX 5060 Shadow 2X OC 8GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 5060 Shadow 2X OC 8GB', 9890000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-card-man-hinh-msi-geforce-rtx-5060-shadow-2x-oc-8gb-1_3010534854914240b88e2d38363a58ac_master.png', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 240, 0, 1);

-- Product: Card màn hình MSI GeForce RTX 5060 Ventus 2X OC 8GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Card màn hình MSI GeForce RTX 5060 Ventus 2X OC 8GB', 10990000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-card-man-hinh-msi-geforce-rtx-5060-ventus-2x-oc-8gb-1_e9b39ab2208346618f66951c5bab8bf0_master.png', 2, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());
INSERT INTO gpu_specs (product_id, length_mm, pcie12vhpwr_required, pcie8pin_required) VALUES (@current_pid, 240, 0, 1);

-- Product: Ram Kingmax Blade X 1x16GB DDR4 Bus 3200Mhz
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram Kingmax Blade X 1x16GB DDR4 Bus 3200Mhz', 2990000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-ram-kingmax-blade-x-1x16gb-ddr4-bus-3200mhz-1_41d9d047789d401cb325830846101c93_master.png', 3, 10, N'KINGMAX', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram Corsair Vengeance RGB White 32GB (2x16GB) 6000 DDR5 (CMH32GX5M2E6000C36W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram Corsair Vengeance RGB White 32GB (2x16GB) 6000 DDR5 (CMH32GX5M2E6000C36W)', 13990000, N'', N'https://product.hstatic.net/200000722513/product/32657-ram-ddr5-corsair-32gb-2x16_b2bb353c8b7b4c3a8b5e99a362f85e1a_master.png', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram Laptop Adata Premier DDR4 8GB Bus 3200
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram Laptop Adata Premier DDR4 8GB Bus 3200', 2190000, N'', N'https://cdn.hstatic.net/products/200000722513/ram-laptop-adata-premier-ddr4-8gb-bus-3200-1_a53db542a9cc48798f4921b37526e928_master.jpg', 3, 10, N'ADATA', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram Laptop Crucial DDR4 16GB Bus 3200
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram Laptop Crucial DDR4 16GB Bus 3200', 3390000, N'', N'https://cdn.hstatic.net/products/200000722513/ram-laptop-crucial-ddr4-16gb-bus-3200-1_01c99e238833424b845bcd4e94630a7b_master.jpg', 3, 10, N'CRUCIAL', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: RAM Corsair Dominator Titanium Black 96GB (2x48GB) RGB 6600 DDR5 (CMP96GX5M2B6600C32)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'RAM Corsair Dominator Titanium Black 96GB (2x48GB) RGB 6600 DDR5 (CMP96GX5M2B6600C32)', 39990000, N'', N'https://product.hstatic.net/200000722513/product/dominator_titanium_rgb_ddr5_blac_5a09a45f1f3446e6bfc52e29f82a8a7a_master.png', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram Corsair Vengeance RGB 96GB (2x48GB) 5600 DDR5 Black (CMH96GX5M2B5600C40)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram Corsair Vengeance RGB 96GB (2x48GB) 5600 DDR5 Black (CMH96GX5M2B5600C40)', 33990000, N'', N'https://product.hstatic.net/200000722513/product/vengeance_-rgb-96gb-_2x48gb_-ddr_a3f02accb53a485f9a0cd2d06a974f89_master.png', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: RAM Corsair Dominator Titanium White 64GB (2x32GB) RGB 6000 DDR5 (CMP64GX5M2B6000C30W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'RAM Corsair Dominator Titanium White 64GB (2x32GB) RGB 6000 DDR5 (CMP64GX5M2B6000C30W)', 21490000, N'', N'https://product.hstatic.net/200000722513/product/ram-pc-corsair-dominator-titaniu_c6edcc99228941b28575bd98c9d25a27_master.png', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: RAM Corsair Dominator Titanium Black 64GB (2x32GB) RGB 6000 DDR5 (CMP64GX5M2B6000C30)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'RAM Corsair Dominator Titanium Black 64GB (2x32GB) RGB 6000 DDR5 (CMP64GX5M2B6000C30)', 20490000, N'', N'https://product.hstatic.net/200000722513/product/dominator_titanium_rgb_ddr5_blac_fa0f0c02819e4313b6a595ecb2e029b0_master.png', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: RAM Corsair Dominator Titanium Black 64GB (2x32GB) RGB 6600 DDR5 (CMP64GX5M2X6600C32)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'RAM Corsair Dominator Titanium Black 64GB (2x32GB) RGB 6600 DDR5 (CMP64GX5M2X6600C32)', 27490000, N'', N'https://product.hstatic.net/200000722513/product/dominator_titanium_rgb_ddr5_blac_41dfe569b59a48deb0e1d6c5bd83056e_master.png', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: RAM Corsair Dominator Titanium White 64GB (2x32GB) RGB 6600 DDR5 (CMP64GX5M2X6600C32W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'RAM Corsair Dominator Titanium White 64GB (2x32GB) RGB 6600 DDR5 (CMP64GX5M2X6600C32W)', 20490000, N'', N'https://product.hstatic.net/200000722513/product/dominator_titanium_rgb_ddr5_whit_ada5b98eea53441486b7bbecf785b4ce_master.png', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram T-Group T-Force Delta 1x8GB 3600 RGB Black
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram T-Group T-Force Delta 1x8GB 3600 RGB Black', 1990000, N'', N'https://product.hstatic.net/200000722513/product/gearvn-ram-t-group-t-force-delta-1x8gb-3600-rgb-black-2_9ca9681b38f648f5b19f2a3554da861b_master.jpg', 3, 10, N'TEAM GROUP', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram T-Group T-Force Delta 1x16GB 3600 RGB Black
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram T-Group T-Force Delta 1x16GB 3600 RGB Black', 3490000, N'', N'https://product.hstatic.net/200000722513/product/eamgroup-t-force-delta-black-rgb_a85b8197156b4de59371cde1710933c4_master.png', 3, 10, N'TEAM GROUP', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram Corsair Vengeance RGB 32GB (2x16GB) 5600 DDR5 (CMH32GX5M2B5600C40K)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram Corsair Vengeance RGB 32GB (2x16GB) 5600 DDR5 (CMH32GX5M2B5600C40K)', 13890000, N'', N'https://product.hstatic.net/200000722513/product/gearvn-corsair-vengeance-rgb-ddr-5600-ddr5-6_e6d7b18ac5ef482c9459e38f10add37f_master.png', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram Corsair Vengeance LPX 8GB (1x8GB) 3200 (CMK8GX4M1E3200C16)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram Corsair Vengeance LPX 8GB (1x8GB) 3200 (CMK8GX4M1E3200C16)', 1690000, N'', N'https://product.hstatic.net/200000722513/product/gx4m1e3200c16-gallery-veng-lpx-blk-02_db321d7ece8f45659518b1217764a815_62d1f7fb318149a4bdff5aef8cf856ad_master.png', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: RAM Corsair Dominator Titanium Black 32GB (2x16GB) RGB 6000 DDR5 (CMP32GX5M2B6000C30)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'RAM Corsair Dominator Titanium Black 32GB (2x16GB) RGB 6000 DDR5 (CMP32GX5M2B6000C30)', 10990000, N'', N'https://product.hstatic.net/200000722513/product/dominator_titanium_rgb_black_render_04_e157efaf73884f1e83289408f1a1c27d_master.png', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: RAM Corsair Dominator Platinum 64GB (2x32GB) RGB 5600 DDR5 (CMT64GX5M2B5600C40)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'RAM Corsair Dominator Platinum 64GB (2x32GB) RGB 5600 DDR5 (CMT64GX5M2B5600C40)', 20990000, N'', N'https://product.hstatic.net/200000722513/product/-dominator-rgb-platinum-black-ddr5-01_8f962c81064143c68d9313ed53279f53_14dde4582eb34e9cb0505a1abcddc2f8_master.png', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram Corsair Vengeance RGB 16GB (1x16GB) 6000 DDR5 (CMH16GX5M1E6000Z36) EXPO,XMP
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram Corsair Vengeance RGB 16GB (1x16GB) 6000 DDR5 (CMH16GX5M1E6000Z36) EXPO,XMP', 7890000, N'', N'https://cdn.hstatic.net/products/200000722513/sair-vengeance-rgb-16gb-1x16gb-6000-ddr5-cmh16gx5m1e6000z36-expo-xmp-1_5ccd10088ed54d25a4fd96f0ed567765_master.jpg', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram Laptop SSTC 8GB DDR4 3200MHz SODIMM S3200A-C22
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram Laptop SSTC 8GB DDR4 3200MHz SODIMM S3200A-C22', 2490000, N'', N'https://cdn.hstatic.net/products/200000722513/ram-laptop-sstc-8gb-ddr4-3200mhz-sodimm-s3200a-c22-1_9e887a5a71c6468298daad60403256ed_master.jpg', 3, 10, N'SSTC', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram Kingmax Horizon 16GB DDR5 Bus 5600Mhz
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram Kingmax Horizon 16GB DDR5 Bus 5600Mhz', 5990000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-ram-kingmax-horizon-16gb-ddr5-bus-5600mhz-1_36cdc6a352144e399a494df3e04dca9c_master.png', 3, 10, N'KINGMAX', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: RAM Corsair Dominator Titanium White 96GB (2x48GB) RGB 6600 DDR5 (CMP96GX5M2B6600C32W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'RAM Corsair Dominator Titanium White 96GB (2x48GB) RGB 6600 DDR5 (CMP96GX5M2B6600C32W)', 38990000, N'', N'https://product.hstatic.net/200000722513/product/dominator_titanium_rgb_ddr5_whit__1__bc3e901d313b4e15a7619c368d8e216e_master.png', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram T-Group T-Force Delta 1x16GB 3600 RGB White
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram T-Group T-Force Delta 1x16GB 3600 RGB White', 3490000, N'', N'https://product.hstatic.net/200000722513/product/gearvn-ram-t-group-t-force-delta-1x16gb-3600-rgb-white-4_3c93ce9bc46c4a29abfbac15c7ff6957_master.png', 3, 10, N'TEAM GROUP', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram Kingston Fury 1x8GB 3200 Beast
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram Kingston Fury 1x8GB 3200 Beast', 490000, N'', N'https://product.hstatic.net/200000722513/product/bease_non_rgb_1_a549750be9cc4e96bd52344f002d98e8_a38774fc6d1e43aebbf8a5c9442af9ad_master.png', 3, 10, N'Kingston', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram T-Group T-Force Delta 1x8GB 3200 RGB White
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram T-Group T-Force Delta 1x8GB 3200 RGB White', 2390000, N'', N'https://product.hstatic.net/200000722513/product/f748_de239228b8934ef7bbab782a6bb7771d_0ee010bf31a14b4e87e3c0f8a00f4555_4b0711df043645b2891db2806a28f29e_master.jpg', 3, 10, N'TEAM GROUP', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram T-Group T-Force Delta 1x8GB 3200 RGB Black
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram T-Group T-Force Delta 1x8GB 3200 RGB Black', 990000, N'', N'https://product.hstatic.net/200000722513/product/f1b8_9a41f0b66e26430580accff8ad7706ea_811b8f21341a4872969f36c91953dbf3_af10916a1f874197be61af4740918227_master.jpg', 3, 10, N'TEAM GROUP', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram Patriot SLP 8GB (1x8GB) 3200 (PSP48G320081H1)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram Patriot SLP 8GB (1x8GB) 3200 (PSP48G320081H1)', 1190000, N'', N'https://product.hstatic.net/200000722513/product/sl_a_web_76dc477ef8d943dea36226386acfbedb_fd8c2078c8684d9dbcc64ae7090492fa_master.jpg', 3, 10, N'PATRIOT', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram Corsair Vengeance Pro RGB 16GB (2x8GB) 3200 White (CMW16GX4M2E3200C16W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram Corsair Vengeance Pro RGB 16GB (2x8GB) 3200 White (CMW16GX4M2E3200C16W)', 1790000, N'', N'https://product.hstatic.net/200000722513/product/te-3_bd3e4fde39c84f13929cc874f3503ef0_33e700e3a1d6478aa3e52b409b22dfa6_815d9540cee74310b57566b750ab0ca0_master.png', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram G.Skill Trident Z 1x16GB RGB 3000 (F4-3000C16D-32GTZR)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram G.Skill Trident Z 1x16GB RGB 3000 (F4-3000C16D-32GTZR)', 2290000, N'', N'https://product.hstatic.net/200000722513/product/gtzr_6bba2a2a4f5e48b89a60db4d8ab8edde_ab1826f1cfc04b1bbb042a6f560935dd_ac62e83d19d14bf2a32c76641093976b_master.jpg', 3, 10, N'G.SKILL', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ram Corsair Dominator 32GB (2x16GB) RGB 3200 White (CMT32GX4M2E3200C16W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ram Corsair Dominator 32GB (2x16GB) RGB 3200 White (CMT32GX4M2E3200C16W)', 3590000, N'', N'https://product.hstatic.net/200000722513/product/te-1_ad8ce4513c9d4425afb929da1cf0c710_e87c46eae9584c8c860a53b8442e0dae_0a3fd71be6934fd8b1b777bd4cb4b22d_master.png', 3, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ cứng SSD Kingston NV3 500GB M.2 PCIe NVMe Gen4
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ cứng SSD Kingston NV3 500GB M.2 PCIe NVMe Gen4', 3890000, N'', N'https://product.hstatic.net/200000722513/product/snv3s_500gb_pkg-lg_989b947a38a043e58b87ae7a31a6528a_master.png', 5, 10, N'Kingston', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ cứng SSD Kingston NV3 1TB M.2 PCIe NVMe Gen4
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ cứng SSD Kingston NV3 1TB M.2 PCIe NVMe Gen4', 5790000, N'', N'https://product.hstatic.net/200000722513/product/snv3s_1000gb_pkg-lg_c8006de4edc5418ba1016953a9a041bf_master.png', 5, 10, N'Kingston', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ cứng SSD Kingston NV3 2TB M.2 PCIe NVMe Gen4
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ cứng SSD Kingston NV3 2TB M.2 PCIe NVMe Gen4', 10990000, N'', N'https://product.hstatic.net/200000722513/product/snv3s_2000gb_pkg-lg_a603785fc04542c5be21481462584107_master.png', 5, 10, N'Kingston', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ Cứng SSD Samsung 990 PRO 4TB M.2 PCIe Gen4 NVMe (MZ-V9P4T0BW)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ Cứng SSD Samsung 990 PRO 4TB M.2 PCIe Gen4 NVMe (MZ-V9P4T0BW)', 21990000, N'', N'https://product.hstatic.net/200000722513/product/vn-990pro-nvme-m2-ssd-mz-v9p4t0b__3__6be2da12adb145f0901041df2b0d723f_master.png', 5, 10, N'SAMSUNG', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ cứng SSD MSI SPATIUM M480 PRO PCIe 4.0 NVMe M.2 1TB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ cứng SSD MSI SPATIUM M480 PRO PCIe 4.0 NVMe M.2 1TB', 4990000, N'', N'https://product.hstatic.net/200000722513/product/71lv1cwfxpl._ac_uf1000_1000_ql80__f00d11081cf845a9be9b0936faf8fc27_master.jpg', 5, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ cứng PNY SSD CS1031 M.2 2280 NVMe 500GB (M280CS1031-500-CL)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ cứng PNY SSD CS1031 M.2 2280 NVMe 500GB (M280CS1031-500-CL)', 2190000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-o-cung-pny-ssd-cs1031-m-2-2280-nvme-500gb-1_ba002c1c03b140c881f0286453efb18d_master.png', 5, 10, N'PNY', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ cứng SSD Samsung 9100 PRO NVMe M.2 1TB Gen5
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ cứng SSD Samsung 9100 PRO NVMe M.2 1TB Gen5', 6990000, N'', N'https://product.hstatic.net/200000722513/product/vn-9100-pro-nvme-m2-ssd-mz-vap1t0bw-545216273_15c52dd5f45a465a81f99f0bf75577e2_master.png', 5, 10, N'SAMSUNG', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ cứng Addlink S68 M.2 2280 NVMe Gen 3 256GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ cứng Addlink S68 M.2 2280 NVMe Gen 3 256GB', 690000, N'', N'https://product.hstatic.net/200000722513/product/gvn_addlink_s68_1_54089af0c6d845c9a6cde56b573eb06b_master.png', 5, 10, N'KHÔNG THƯƠNG HIỆU', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ Cứng SSD GIGABYTE AORUS Gen4 5000E SSD 500GB (AG450E500G-G)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ Cứng SSD GIGABYTE AORUS Gen4 5000E SSD 500GB (AG450E500G-G)', 1690000, N'', N'https://product.hstatic.net/200000722513/product/aorus_gen4_5000e_ssd_500gb-01_6ef637a2a06e4d0cb8cd545c868aaf50_master.png', 5, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ cứng SSD Corsair MP600 CORE XT 1TB PCIe 4.0 Gen4 (CSSD-F1000GBMP600CXT)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ cứng SSD Corsair MP600 CORE XT 1TB PCIe 4.0 Gen4 (CSSD-F1000GBMP600CXT)', 2990000, N'', N'https://product.hstatic.net/200000722513/product/mp600_core_xt_21_b185c78c017944cfa72685e3898fc03e_master.png', 5, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ cứng SSD Corsair MP600 CORE XT 2TB PCIe 4.0 Gen4 (CSSD-F2000GBMP600CXT)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ cứng SSD Corsair MP600 CORE XT 2TB PCIe 4.0 Gen4 (CSSD-F2000GBMP600CXT)', 4990000, N'', N'https://product.hstatic.net/200000722513/product/20-236-988-01_7c79ecf51d3f4cee80a8cb4a081e6287_master.jpg', 5, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ cứng SSD MSI Spatium S270 960GB SATA3
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ cứng SSD MSI Spatium S270 960GB SATA3', 1190000, N'', N'https://product.hstatic.net/200000722513/product/1024__1__6bb4982da3284a85a388a00b58d3bc32_master.png', 5, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ cứng SSD TeamGroup CX2 2.5 inch SATA III 256GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ cứng SSD TeamGroup CX2 2.5 inch SATA III 256GB', 590000, N'', N'https://product.hstatic.net/200000722513/product/-ssd-teamgroup-cx2-256gb-2-5-sata-3-1_24f2ade29f3b47518618b4f02dabd99c_9c07344d76f644dba2a489eec759ee01_master.png', 5, 10, N'TEAM GROUP', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ Cứng SSD KLEVV CRAS C710 256GB Gen3 (K256GM2SP0-C71)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ Cứng SSD KLEVV CRAS C710 256GB Gen3 (K256GM2SP0-C71)', 490000, N'', N'https://product.hstatic.net/200000722513/product/e-gen3-x4-nvme-256gb-k256gm2sp0-c71-1_f4daea5320204244b944784401c11505_391984556d1744ed804ca42ef6fa0eae_master.png', 5, 10, N'KLEVV', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ Cứng SSD Gigabyte M.2 PCIe 256GB (GP-GSM2NE3256GNTD)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ Cứng SSD Gigabyte M.2 PCIe 256GB (GP-GSM2NE3256GNTD)', 790000, N'', N'https://product.hstatic.net/200000722513/product/3_2269d7b856544966897f2b2b65683270_73af0e9a6082465da59b76283fac67a8_master.png', 5, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ Cứng SSD Kingston A400 M.2 Sata3 240Gb
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ Cứng SSD Kingston A400 M.2 Sata3 240Gb', 390000, N'', N'https://product.hstatic.net/200000722513/product/ssd-kingston-a400-240gb-m-2-sata-3-1_76b4e03be344463986e9b5e89d08e0ed_2e97ae87b1f4476ea3942821a50dc677_master.jpg', 5, 10, N'Kingston', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Gigabyte SSD AORUS RGB M.2 NVMe 512GB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Gigabyte SSD AORUS RGB M.2 NVMe 512GB', 1190000, N'', N'https://product.hstatic.net/200000722513/product/aorus_rgb_ssd_gearvn01_3e4f777d02cf4a129f98e2533e4bda22_0c8fcc18dc8642b7b80f9b2888057af0_master.png', 5, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ cứng SSD Kingston KC2500 250GB PCIe Gen 3.0
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ cứng SSD Kingston KC2500 250GB PCIe Gen 3.0', 1290000, N'', N'https://product.hstatic.net/200000722513/product/gearvn-o-cung-ssd-kingston-kc2500-1_a26054868aac4bf3b336230725abe7f3_bc31639fe6b447b798a4bec3d9a75f5f_master.jpg', 5, 10, N'Kingston', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ Cứng SSD Samsung 970 Evo Plus 250Gb PCIe NVMe M.2
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ Cứng SSD Samsung 970 Evo Plus 250Gb PCIe NVMe M.2', 1590000, N'', N'https://product.hstatic.net/200000722513/product/70-evo-plus-250gb-ssd-m.2-nvme-gearvn_ebf82e635e2e4ec685b5b1401bdcd2e3_46e1f62edef94e69a007175b0ef1fe38_master.jpg', 5, 10, N'SAMSUNG', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ cứng SSD Kingston KC2500 500GB PCIe Gen 3.0
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ cứng SSD Kingston KC2500 500GB PCIe Gen 3.0', 1890000, N'', N'https://product.hstatic.net/200000722513/product/gearvn-o-cung-ssd-kingston-kc2500-2_dc5c2428864d415c903ad80a7a8125a5_e7a8f552b2e341f5ac5932343cc461bd_master.jpg', 5, 10, N'Kingston', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ Cứng SSD Samsung 970 Evo Plus 500Gb PCIe NVMe M.2
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ Cứng SSD Samsung 970 Evo Plus 500Gb PCIe NVMe M.2', 2190000, N'', N'https://product.hstatic.net/200000722513/product/970evo_500gb_plus_gearvn_ba48ea227ab34e799b731eedec5884ba_master.png', 5, 10, N'SAMSUNG', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: SSD GIGABYTE AORUS 500GB M.2 PCIe NVMe gen 4 (Bản không heatsink)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'SSD GIGABYTE AORUS 500GB M.2 PCIe NVMe gen 4 (Bản không heatsink)', 3690000, N'', N'https://product.hstatic.net/200000722513/product/aorus-m2-500gb_gigabyte_a4f1a17ae5834a77b9e70425f4b9ef5f_33f6c6772cf64c18b72d58bb260ceecb_master.jpg', 5, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ cứng SSD MSI SPATIUM M480 PCIe 4.0 NVMe M.2 1TB PLAY
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ cứng SSD MSI SPATIUM M480 PCIe 4.0 NVMe M.2 1TB PLAY', 4190000, N'', N'https://product.hstatic.net/200000722513/product/new_project__21__a550dd52eb014210a7463b222f710d38_3bee314e1bd54a48a8e90fea1cb512ea_master.png', 5, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: SSD GIGABYTE AORUS 1TB M.2 PCIe NVMe gen 4 (Bản không heatsink)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'SSD GIGABYTE AORUS 1TB M.2 PCIe NVMe gen 4 (Bản không heatsink)', 4890000, N'', N'https://product.hstatic.net/200000722513/product/igabyte-aorus-1tb-m-2-pcie-nvme-gen-4_6bd585814a7048c1a6d78c4b1831b9b1_f08ca6cc93654429931e9e1fecfcf0e6_master.jpg', 5, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ Cứng SSD Samsung 990 PRO 2TB M.2 PCIe Gen4 NVMe (MZ-V9P2T0BW)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ Cứng SSD Samsung 990 PRO 2TB M.2 PCIe Gen4 NVMe (MZ-V9P2T0BW)', 6490000, N'', N'https://product.hstatic.net/200000722513/product/-am_001_front_black-gallery-1600x1200_d5430da92de74a7c9d7b35a7ae9b3587_b2e724a266834268bead0b9ab068d99c_master.png', 5, 10, N'SAMSUNG', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ Cứng SSD Samsung 870 QVO 4TB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ Cứng SSD Samsung 870 QVO 4TB', 10990000, N'', N'https://product.hstatic.net/200000722513/product/om-products-ssd-samsung-860-qvo-4tb_3_d420e6ef97f046398599c649863a8e19_51fb14d9ddae4f2fae0e1727dd8cee98_master.jpg', 5, 10, N'SAMSUNG', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ Cứng SSD Gigabyte Aorus Gen5 10000 2TB (AG510K2TB)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ Cứng SSD Gigabyte Aorus Gen5 10000 2TB (AG510K2TB)', 11990000, N'', N'https://product.hstatic.net/200000722513/product/6917_e5cda722eb8165b304cc8c0ba03547e6_b2fd63d47aaf494daed95c4437cc004b_e952a45ad3474b7e80d1c132f385338c_master.jpg', 5, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Ổ Cứng SSD Samsung 870 QVO 8TB
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Ổ Cứng SSD Samsung 870 QVO 8TB', 20490000, N'', N'https://product.hstatic.net/200000722513/product/870_qvo_35b0cdd4216e4423ae5c59b69b113a64_ad3e1fe1e72948bbbb06470fc25cc3e3_master.jpg', 5, 10, N'SAMSUNG', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Corsair CX650 - 80 Plus Bronze (650W) CP-9020278-NA
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Corsair CX650 - 80 Plus Bronze (650W) CP-9020278-NA', 1390000, N'', N'https://product.hstatic.net/200000722513/product/gearvn-nguon-may-tinh-corsair-cx650-80-plus-bronze-650w-1_5e2807b23e75486f9e93efc31604dcbc_master.png', 11, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Cooler Master MWE GOLD 1050W V2 ATX3.1 - 80 Plus Gold - Full Modular
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Cooler Master MWE GOLD 1050W V2 ATX3.1 - 80 Plus Gold - Full Modular', 4490000, N'', N'https://product.hstatic.net/200000722513/product/pw-cm-mwe-1050-v2-gold-3-1_1_dd009afe855b415fb7605684c7272b33_master.jpg', 11, 10, N'COOLER MASTER', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn ASUS ROG THOR 1600T3 ATX 3.1, PCIe 5.0, 80 Plus Titanium, Full Modular (1600W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn ASUS ROG THOR 1600T3 ATX 3.1, PCIe 5.0, 80 Plus Titanium, Full Modular (1600W)', 24490000, N'', N'https://product.hstatic.net/200000722513/product/51350_0028_6205a2bf86d34a4284e37b71ed1ce725_master.jpg', 11, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn Máy Tính ASUS ROG THOR 1200 P3 1200W PLATINUM III ( PCIe Gen 5.0)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn Máy Tính ASUS ROG THOR 1200 P3 1200W PLATINUM III ( PCIe Gen 5.0)', 13990000, N'', N'https://cdn.hstatic.net/products/200000722513/nguon-may-tinh-asus-rog-thor-1200-p3-1200w-platinum-iii-pcie-gen-5-0-1_fc071ebf74f546a59bcb499be93f7a4e_master.jpg', 11, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Cooler Master V Platinum 1600 V2 - 1600W - 80 Plus Platinum - Full Modular
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Cooler Master V Platinum 1600 V2 - 1600W - 80 Plus Platinum - Full Modular', 7890000, N'', N'https://cdn.hstatic.net/products/200000722513/-coolermaster-v-platinum-1600-v2-1600w-80-plus-platinum-full-modular-1_b282385dec434843831bc0da47fa0555_master.png', 11, 10, N'COOLER MASTER', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Cooler Master MWE GOLD 1250W V2 ATX3.1 - 80 Plus Gold - Full Modular
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Cooler Master MWE GOLD 1250W V2 ATX3.1 - 80 Plus Gold - Full Modular', 5490000, N'', N'https://product.hstatic.net/200000722513/product/38463_mwe_gold_1250_v2_atx3_gallery_04_image_b04b28bb8fcd4891a622c093a5566d25_master.png', 11, 10, N'COOLER MASTER', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Cooler Master MWE 650 - 80 Plus Bronze - V3 230V (650W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Cooler Master MWE 650 - 80 Plus Bronze - V3 230V (650W)', 1390000, N'', N'https://product.hstatic.net/200000722513/product/smart_14ca4a1af49c40789c3caeb7939fe21c_master.png', 11, 10, N'COOLER MASTER', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Cooler Master MWE 750 - 80 Plus Bronze - V3 230V (750W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Cooler Master MWE 750 - 80 Plus Bronze - V3 230V (750W)', 1690000, N'', N'https://product.hstatic.net/200000722513/product/smart__1__14f9dfb8a0f94884826522f2ecd0b52b_master.png', 11, 10, N'COOLER MASTER', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Lian Li EDGE 1300W White L-Shape - 80 Plus Platinum - Full Modular
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Lian Li EDGE 1300W White L-Shape - 80 Plus Platinum - Full Modular', 5990000, N'', N'https://product.hstatic.net/200000722513/product/edge_002_a238d070593347c0b463372abe808467_master.jpg', 11, 10, N'LIAN LI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Lian Li EDGE 1300W Black L-Shape - 80 Plus Platinum - Full Modular
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Lian Li EDGE 1300W Black L-Shape - 80 Plus Platinum - Full Modular', 5490000, N'', N'https://product.hstatic.net/200000722513/product/edge_001_74f0ed8bfa0d4535b6c675cb21cce7cc_master.jpg', 11, 10, N'LIAN LI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính MSI MAG A1250GL PCIE5 - 80 Plus Gold - Full Modular (1250W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính MSI MAG A1250GL PCIE5 - 80 Plus Gold - Full Modular (1250W)', 5490000, N'', N'https://product.hstatic.net/200000722513/product/1024__5__10dc755f12ec4edea59e4aaedc53b52e_master.png', 11, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Corsair CX750 - 80 Plus Bronze (750W) CP-9020279-NA
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Corsair CX750 - 80 Plus Bronze (750W) CP-9020279-NA', 1690000, N'', N'https://product.hstatic.net/200000722513/product/gearvn-nguon-may-tinh-corsair-cx750-80-plus-bronze-750w-1_63db1ac7931148b38da7aa600f5cf52c_master.png', 11, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính FSP HV PRO 550W - 80 Plus Bronze (550W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính FSP HV PRO 550W - 80 Plus Bronze (550W)', 990000, N'', N'https://product.hstatic.net/200000722513/product/nguon_fsp_hv_pro_550w_-_10_e6bde4a463d241788c2580e22b496368_55fc9eed7ea141498c1947e136e85640_master.jpg', 11, 10, N'FSP', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Deepcool PF550 - 80 Plus (550W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Deepcool PF550 - 80 Plus (550W)', 990000, N'', N'https://product.hstatic.net/200000722513/product/09_9405bf20153a459bb28c8456998c979b_master.jpg', 11, 10, N'DEEPCOOL', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính MSI MAG A750BN PCIE5 - 80 Plus Bronze (750W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính MSI MAG A750BN PCIE5 - 80 Plus Bronze (750W)', 1690000, N'', N'https://product.hstatic.net/200000722513/product/468295cf2cd594cc57b1ceb5ab5d63_238e14b37a084966b8d461d6f5e06a36_grande_81c9081d27934bfab233a6775a92b6c9_master.png', 11, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính MSI MAG A850GL PCIE5 - 80 Plus Gold - Full Modular (850W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính MSI MAG A850GL PCIE5 - 80 Plus Gold - Full Modular (850W)', 2990000, N'', N'https://product.hstatic.net/200000722513/product/1024_0920b4ad0bce4347aec42163de5ee9d6_master.png', 11, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Corsair RM850e ATX 3.0 - 80 Plus Gold - Full Modular (850W) (CP-9020263-NA)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Corsair RM850e ATX 3.0 - 80 Plus Gold - Full Modular (850W) (CP-9020263-NA)', 3290000, N'', N'https://product.hstatic.net/200000722513/product/thiet_ke_chua_co_ten_5e29bb919cf649ebbd6498a0867046d2_c76be5919a434100b9999bb05ea3207b_master.png', 11, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính FSP HV PRO 650W - 80 Plus Bronze (650W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính FSP HV PRO 650W - 80 Plus Bronze (650W)', 1190000, N'', N'https://product.hstatic.net/200000722513/product/nguon_fsp_hv_pro_650w_-_9_c83eecc17d7247cbb2a882ebaaf9041c_8ab94aaa9c25486cb3ebfe1c8476d5ef_master.png', 11, 10, N'FSP', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Jetek Elite 350W V2 (350W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Jetek Elite 350W V2 (350W)', 450000, N'', N'https://product.hstatic.net/200000722513/product/500-elite9-500x500_37e4605e6229461fb4e952dbabead0a4_6ff479d64f094efe8ef83e47208c8b61_master.jpeg', 11, 10, N'JETEK', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Jetek J400 (400W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Jetek J400 (400W)', 590000, N'', N'https://product.hstatic.net/200000722513/product/3455_abf653d5dea3e3c357057cf334f76333_1793945aeb614299a6f8b92833a221cf_8d5a416765a742efbd6dc8717fb1c2ec_master.jpg', 11, 10, N'JETEK', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính MSI MAG A650BN - 80 Plus Bronze (650W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính MSI MAG A650BN - 80 Plus Bronze (650W)', 1190000, N'', N'https://product.hstatic.net/200000722513/product/1_af69a1451abb4e0e90ef054fae764f35_5339e9f699bd4933b97a1079bc656e3d_master.jpg', 11, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Cooler Master V Platinum 1300 V2 - 1600W - 80 Plus Platinum - Full Modular
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Cooler Master V Platinum 1300 V2 - 1600W - 80 Plus Platinum - Full Modular', 6790000, N'', N'https://cdn.hstatic.net/products/200000722513/gearvn-nguon-may-tinh-cooler-master-v-platinum-1300-v2-1600w-1_0dabd6f51ac84182b2e1d052ee18b20d_master.png', 11, 10, N'COOLER MASTER', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính MSI MEG AI1600T PCIE5 - 80 Plus Titanium (1600W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính MSI MEG AI1600T PCIE5 - 80 Plus Titanium (1600W)', 13990000, N'', N'https://product.hstatic.net/200000722513/product/1024__13__1c85060d3858404088281432885050ed_master.png', 11, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Corsair RM1200x SHIFT White ATX 3.1 - 80 Plus Gold - Full Modular (1200W) (CP-9020276-NA)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Corsair RM1200x SHIFT White ATX 3.1 - 80 Plus Gold - Full Modular (1200W) (CP-9020276-NA)', 6150000, N'', N'https://product.hstatic.net/200000722513/product/cp-9020276_08_f82ddefd8e004e9ab71051c3944b46bb_master.png', 11, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Cooler Master MWE GOLD 850W V2 ATX3.1 - 80 Plus Gold - Full Modular
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Cooler Master MWE GOLD 850W V2 ATX3.1 - 80 Plus Gold - Full Modular', 2990000, N'', N'https://product.hstatic.net/200000722513/product/smart__9__8cd55ba33679495abe84766b08a9b1ec_master.png', 11, 10, N'COOLER MASTER', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính MSI MAG A500N-H - Active PFC (500W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính MSI MAG A500N-H - Active PFC (500W)', 790000, N'', N'https://product.hstatic.net/200000722513/product/1024_8a2e537b989a42b8a9795ba6cb3be1da_master.png', 11, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính ASUS ROG Thor 1000P2 - 80 Plus Platinum - Full Modular (1000W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính ASUS ROG Thor 1000P2 - 80 Plus Platinum - Full Modular (1000W)', 8990000, N'', N'https://product.hstatic.net/200000722513/product/rog-thor-1000-p2-01_3621e432053b47b2933407ed2b0502f5_master.png', 11, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính ASUS ROG Thor 1600T GAMING- 80 Plus Titanium - Full Modular (1600W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính ASUS ROG Thor 1600T GAMING- 80 Plus Titanium - Full Modular (1600W)', 16990000, N'', N'https://product.hstatic.net/200000722513/product/rog-thor-1600t-01_f960ba6fff2c49bea4b9077156fbfa2b_master.png', 11, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Lian Li EDGE 1000W Black L-Shape - 80 Plus Platinum - Full Modular
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Lian Li EDGE 1000W Black L-Shape - 80 Plus Platinum - Full Modular', 4690000, N'', N'https://product.hstatic.net/200000722513/product/edge_007_9792d5a7a4214961b9757ceb1140e25a_master.jpg', 11, 10, N'LIAN LI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Lian Li EDGE 1000W White L-Shape - 80 Plus Platinum - Full Modular
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Lian Li EDGE 1000W White L-Shape - 80 Plus Platinum - Full Modular', 4990000, N'', N'https://product.hstatic.net/200000722513/product/edge_008_9aff82f275fc4739a66ecbb9a6076f1f_master.jpg', 11, 10, N'LIAN LI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Thermaltake TOUGHPOWER GT 850W SNOW - 80 Plus Gold - Full Modular (850W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Thermaltake TOUGHPOWER GT 850W SNOW - 80 Plus Gold - Full Modular (850W)', 2790000, N'', N'https://product.hstatic.net/200000722513/product/ps-tpt-0850fnfag-w_01_e41c904e4d9344169c8741a933512d55_master.png', 11, 10, N'THERMALTAKE', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Thermaltake TOUGHPOWER GT 850W - 80 Plus Gold - Full Modular (850W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Thermaltake TOUGHPOWER GT 850W - 80 Plus Gold - Full Modular (850W)', 2690000, N'', N'https://product.hstatic.net/200000722513/product/z5919110742405_dc7c9309ec55edfbb_e9dfb56fc1d24ea8823d4a18a49061f3_master.png', 11, 10, N'THERMALTAKE', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính GIGABYTE AORUS ELITE P1000W PCIe 5.0 - 80 Plus Platinum - Full Modular (1000W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính GIGABYTE AORUS ELITE P1000W PCIe 5.0 - 80 Plus Platinum - Full Modular (1000W)', 6490000, N'', N'https://product.hstatic.net/200000722513/product/aorus_elite_p1000w_80__platinum_modular_pcie_5.0-07_0ec8124d51f943d9a84e29232be026b7_master.png', 11, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính GIGABYTE P650SS ICE - 80 Plus Silver ( 650W )
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính GIGABYTE P650SS ICE - 80 Plus Silver ( 650W )', 1290000, N'', N'https://product.hstatic.net/200000722513/product/p650ss_ice-06_0a181d4033c2451c9ef00725bad28ae7_master.png', 11, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính GIGABYTE P550SS - 80 Plus Silver ( 550W )
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính GIGABYTE P550SS - 80 Plus Silver ( 550W )', 990000, N'', N'https://product.hstatic.net/200000722513/product/p550ss-07_c6a8b9b2cfcf482dbfcc4c69e80d4080_master.png', 11, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính GIGABYTE AORUS ELITE P1000W PCIe 5.0 ICE - 80 Plus Platinum - Full Modular (1000W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính GIGABYTE AORUS ELITE P1000W PCIe 5.0 ICE - 80 Plus Platinum - Full Modular (1000W)', 6590000, N'', N'https://product.hstatic.net/200000722513/product/aorus_elite_p1000w_80__platinum_modular_pcie_5.0_ice-07_402be92080d34a9da7740805043642b0_master.png', 11, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Deepcool PN850M - 80 Plus Gold - ATX 3.1 - Full Modular (850W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Deepcool PN850M - 80 Plus Gold - ATX 3.1 - Full Modular (850W)', 2890000, N'', N'https://product.hstatic.net/200000722513/product/06_b5ea2f53caa441ff84157adcabbd2a64_master.png', 11, 10, N'DEEPCOOL', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính ASUS Prime 850W - 80 Plus Gold - Full Modular ( 850W )
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính ASUS Prime 850W - 80 Plus Gold - Full Modular ( 850W )', 3490000, N'', N'https://product.hstatic.net/200000722513/product/ap-850g-01_ce1fbc32a4384e64bdd5badd98f851c3_master.jpg', 11, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Corsair HX1200i - 80 Plus Platinum - Full Modular (1200W) (CP-9020281-NA)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Corsair HX1200i - 80 Plus Platinum - Full Modular (1200W) (CP-9020281-NA)', 7590000, N'', N'https://product.hstatic.net/200000722513/product/n-nguon-may-tinh-corsair-hx1200i-80-plus-platinum-full-modular-1200w-3_facfdc8637dc42cf95e1752afa180a75_master.png', 11, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính GIGABYTE UD850GM PG5 - 80 Plus Gold - Full Modular (850W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính GIGABYTE UD850GM PG5 - 80 Plus Gold - Full Modular (850W)', 2990000, N'', N'https://product.hstatic.net/200000722513/product/ud850gm_pg5-07_0adb9528a06f4b94b0fa2e2ea07f5351_master.png', 11, 10, N'Gigabyte', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính ASUS ROG Strix 1000W AURA White Edition - 80 Plus Gold - Full Modular (1000W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính ASUS ROG Strix 1000W AURA White Edition - 80 Plus Gold - Full Modular (1000W)', 6990000, N'', N'https://product.hstatic.net/200000722513/product/rog-strix-1000g-aura-gaming-white-edition-01_7408b041dc474168b94ae120e333e427_master.jpg', 11, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Thermaltake TOUGHPOWER GF A3 750W - 80 Plus Gold - Full Modular (750W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Thermaltake TOUGHPOWER GF A3 750W - 80 Plus Gold - Full Modular (750W)', 2690000, N'', N'https://product.hstatic.net/200000722513/product/gearvn-nguon-may-tinh-thermaltake-toughpower-gf-a3-750w-4_c715c7d1eb2a49e7ada73d51484ec777_master.jpg', 11, 10, N'THERMALTAKE', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Corsair HX1500i - 80 Plus Platinum - Full Modular (1500W) (CP-9020261-NA)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Corsair HX1500i - 80 Plus Platinum - Full Modular (1500W) (CP-9020261-NA)', 9490000, N'', N'https://product.hstatic.net/200000722513/product/gearvn-nguon-corsair-hx1500i-full-modular-80-plus-platinum-5_941b6db02f2a4848ac2503a49d00472f_master.png', 11, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Corsair HX1000i - 80 Plus Platinum - Full Modular (1000W) (CP-9020259-NA)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Corsair HX1000i - 80 Plus Platinum - Full Modular (1000W) (CP-9020259-NA)', 6490000, N'', N'https://product.hstatic.net/200000722513/product/hx1000i_powerful_f7743adb8226404ea57640df8b5f3d51_master.png', 11, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính ASUS ROG Thor 1200P2 - 80 Plus Platinum - Full Modular (1200W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính ASUS ROG Thor 1200P2 - 80 Plus Platinum - Full Modular (1200W)', 9490000, N'', N'https://product.hstatic.net/200000722513/product/rog-thor-1200-p2-01_411ea85d61274fa78ec0b79f36577a48_master.png', 11, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính ASUS ROG Strix 1000W AURA Edition - 80 Plus Gold - Full Modular (1000W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính ASUS ROG Strix 1000W AURA Edition - 80 Plus Gold - Full Modular (1000W)', 5990000, N'', N'https://product.hstatic.net/200000722513/product/rog-strix-1000g-01_7aeb6a2c38714ec09a821131fa0e805c_master.jpg', 11, 10, N'ASUS', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Corsair RM1000e ATX 3.0 - 80 Plus Gold - Full Modular (1000W) (CP-9020264-NA)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Corsair RM1000e ATX 3.0 - 80 Plus Gold - Full Modular (1000W) (CP-9020264-NA)', 4590000, N'', N'https://product.hstatic.net/200000722513/product/thiet_ke_chua_co_ten_a532c354608f43eab3313b54626b3c70_5a71147440ae46bfad22d894f423d857_master.png', 11, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính Corsair RM750e ATX 3.0 - 80 Plus Gold - Full Modular (750W) (CP-9020262-NA)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính Corsair RM750e ATX 3.0 - 80 Plus Gold - Full Modular (750W) (CP-9020262-NA)', 2890000, N'', N'https://product.hstatic.net/200000722513/product/earvn-nguon-may-tinh-corsair-rm750e-atx-3.0-80-plus-gold-full-modula-1_5cd29a9f71ef4d18b2dcc67481d01eb0_master.png', 11, 10, N'Corsair', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính MSI MAG A850GL PCIE5 WHITE - 80 Plus Gold - Full Modular (850W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính MSI MAG A850GL PCIE5 WHITE - 80 Plus Gold - Full Modular (850W)', 3290000, N'', N'https://product.hstatic.net/200000722513/product/1024_3fe25bf198084414bc5e042cf110a07d_master.png', 11, 10, N'MSI', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

-- Product: Nguồn máy tính NZXT C750W - 80 Plus Bronze - Non Modular (750W)
INSERT INTO products (name, price, description, image, category_id, stock, brand, created_at)
VALUES (N'Nguồn máy tính NZXT C750W - 80 Plus Bronze - Non Modular (750W)', 1390000, N'', N'https://product.hstatic.net/200000722513/product/1693598157-c750w-bronze-psu-top_8ad3c808b8fc4a85b6d6dfebaf3b349d_master.png', 11, 10, N'NZXT', GETDATE());
SET @current_pid = SCOPE_IDENTITY();
INSERT INTO inventory (product_id, quantity, last_update)
VALUES (@current_pid, 10, GETDATE());

GO
