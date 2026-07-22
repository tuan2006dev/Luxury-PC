-- ==============================================================================
-- ENTERPRISE PC HARDWARE DATA PLATFORM - SCHEMA (T-SQL / SQL Server)
-- ==============================================================================

-- 1. METADATA TABLES (Master Data)
CREATE TABLE categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    parent_id INT NULL,
    name NVARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description NVARCHAR(MAX) NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Category_Parent FOREIGN KEY (parent_id) REFERENCES categories(id)
);

CREATE TABLE manufacturers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL UNIQUE,
    website VARCHAR(255) NULL,
    created_at DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE brands (
    id INT IDENTITY(1,1) PRIMARY KEY,
    manufacturer_id INT NULL,
    name NVARCHAR(255) NOT NULL UNIQUE,
    slug VARCHAR(255) UNIQUE NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Brand_Manufacturer FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id)
);

-- 2. EAV DEFINITION TABLES
CREATE TABLE attribute_groups (
    id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NULL, -- Nếu NULL thì áp dụng cho mọi category
    name NVARCHAR(255) NOT NULL, -- e.g. "Display", "Performance", "Physical"
    sort_order INT DEFAULT 0,
    CONSTRAINT FK_AttrGroup_Category FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE attributes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    group_id INT NULL,
    name NVARCHAR(255) NOT NULL, -- e.g. "Socket", "TDP", "Memory Type"
    code VARCHAR(100) UNIQUE NOT NULL, -- e.g. "cpu_socket", "tdp_max"
    data_type VARCHAR(50) NOT NULL DEFAULT 'string', -- string, integer, decimal, boolean, json
    is_filterable BIT DEFAULT 1,
    is_comparable BIT DEFAULT 1,
    CONSTRAINT FK_Attr_Group FOREIGN KEY (group_id) REFERENCES attribute_groups(id)
);

-- 3. CORE PRODUCT TABLE
CREATE TABLE products (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL,
    brand_id INT NOT NULL,
    
    -- Basic Info
    name NVARCHAR(500) NOT NULL,
    slug VARCHAR(500) UNIQUE NOT NULL,
    description NVARCHAR(MAX) NULL,
    
    -- Identifiers
    model VARCHAR(255) NULL,
    sku VARCHAR(255) NULL UNIQUE,
    mpn VARCHAR(255) NULL,
    upc VARCHAR(50) NULL,
    ean VARCHAR(50) NULL,
    gtin VARCHAR(50) NULL,
    
    -- Sales & Market
    price DECIMAL(18,2) NULL,
    warranty_months INT NULL,
    release_date DATE NULL,
    country_of_origin NVARCHAR(100) NULL,
    
    -- JSON Cache (For super fast API responses without EAV joins)
    specs_json NVARCHAR(MAX) NULL, 
    
    -- Audit
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    status VARCHAR(50) DEFAULT 'ACTIVE', -- ACTIVE, INACTIVE, DRAFT, DISCONTINUED
    
    CONSTRAINT FK_Product_Category FOREIGN KEY (category_id) REFERENCES categories(id),
    CONSTRAINT FK_Product_Brand FOREIGN KEY (brand_id) REFERENCES brands(id)
);

-- Indexes for Fast Deduplication & Lookups
CREATE INDEX IX_Product_MPN ON products(mpn);
CREATE INDEX IX_Product_UPC ON products(upc);
CREATE INDEX IX_Product_EAN ON products(ean);

-- 4. EAV VALUE TABLE (Dynamic Specs)
CREATE TABLE product_specs (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    product_id BIGINT NOT NULL,
    attribute_id INT NOT NULL,
    value_string NVARCHAR(MAX) NULL,
    value_int INT NULL,
    value_decimal DECIMAL(18,4) NULL,
    value_boolean BIT NULL,
    unit NVARCHAR(50) NULL, -- e.g., "MHz", "W", "GB"
    CONSTRAINT FK_Spec_Product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT FK_Spec_Attribute FOREIGN KEY (attribute_id) REFERENCES attributes(id),
    CONSTRAINT UQ_Product_Attribute UNIQUE (product_id, attribute_id)
);

-- 5. TRACKING & ASSETS
CREATE TABLE product_images (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    product_id BIGINT NOT NULL,
    image_url VARCHAR(1000) NOT NULL,
    is_primary BIT DEFAULT 0,
    sort_order INT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Image_Product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE product_sources (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    product_id BIGINT NOT NULL,
    source_url VARCHAR(1000) NOT NULL,
    source_type VARCHAR(50) NOT NULL, -- LAYER_1, LAYER_2, LAYER_3
    source_domain VARCHAR(255) NOT NULL, -- e.g., "gearvn.com", "ark.intel.com"
    priority_score INT DEFAULT 50, -- Trọng số giải quyết xung đột (Intel = 100, Retailer = 50)
    last_crawled_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Source_Product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE product_versions (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    product_id BIGINT NOT NULL,
    field_changed VARCHAR(255) NOT NULL, -- 'price', 'specs', 'status'
    old_value NVARCHAR(MAX) NULL,
    new_value NVARCHAR(MAX) NULL,
    changed_at DATETIME2 DEFAULT GETDATE(),
    source_domain VARCHAR(255) NULL, -- Nguồn gây ra sự thay đổi này
    CONSTRAINT FK_Version_Product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);
