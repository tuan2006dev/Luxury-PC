-- ==============================================================================
-- FLYWAY V1: ENTERPRISE PC HARDWARE DATA PLATFORM - INITIAL SCHEMA
-- ==============================================================================

-- 1. METADATA TABLES (Master Data)
CREATE TABLE categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    parent_id INT NULL,
    name NVARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description NVARCHAR(MAX) NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    deleted_at DATETIME2 NULL,
    CONSTRAINT FK_Category_Parent FOREIGN KEY (parent_id) REFERENCES categories(id)
);

CREATE TABLE manufacturers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL UNIQUE,
    website VARCHAR(255) NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    deleted_at DATETIME2 NULL
);

CREATE TABLE brands (
    id INT IDENTITY(1,1) PRIMARY KEY,
    manufacturer_id INT NULL,
    name NVARCHAR(255) NOT NULL UNIQUE,
    slug VARCHAR(255) UNIQUE NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    deleted_at DATETIME2 NULL,
    CONSTRAINT FK_Brand_Manufacturer FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id)
);

-- 2. EAV DEFINITION TABLES
CREATE TABLE attribute_groups (
    id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NULL,
    name NVARCHAR(255) NOT NULL,
    sort_order INT DEFAULT 0
);

CREATE TABLE attributes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    group_id INT NULL,
    name NVARCHAR(255) NOT NULL,
    code VARCHAR(100) UNIQUE NOT NULL,
    data_type VARCHAR(50) NOT NULL DEFAULT 'string',
    is_filterable BIT DEFAULT 1,
    is_comparable BIT DEFAULT 1,
    CONSTRAINT FK_Attr_Group FOREIGN KEY (group_id) REFERENCES attribute_groups(id)
);

-- 3. CORE PRODUCT TABLE
CREATE TABLE products (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL,
    brand_id INT NOT NULL,
    name NVARCHAR(500) NOT NULL,
    slug VARCHAR(500) UNIQUE NOT NULL,
    model VARCHAR(255) NULL,
    sku VARCHAR(255) NULL UNIQUE,
    mpn VARCHAR(255) NULL,
    upc VARCHAR(50) NULL,
    ean VARCHAR(50) NULL,
    gtin VARCHAR(50) NULL,
    specs_json NVARCHAR(MAX) NULL, 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    deleted_at DATETIME2 NULL,
    status VARCHAR(50) DEFAULT 'ACTIVE',
    CONSTRAINT FK_Product_Category FOREIGN KEY (category_id) REFERENCES categories(id),
    CONSTRAINT FK_Product_Brand FOREIGN KEY (brand_id) REFERENCES brands(id)
);

CREATE INDEX IX_Product_MPN ON products(mpn);
CREATE INDEX IX_Product_UPC ON products(upc);
CREATE INDEX IX_Product_EAN ON products(ean);

-- 4. EAV VALUE TABLE & TRACKING
CREATE TABLE product_specs (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    product_id BIGINT NOT NULL,
    attribute_id INT NOT NULL,
    value_string NVARCHAR(MAX) NULL,
    value_int INT NULL,
    value_decimal DECIMAL(18,4) NULL,
    value_boolean BIT NULL,
    unit NVARCHAR(50) NULL,
    CONSTRAINT FK_Spec_Product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT FK_Spec_Attribute FOREIGN KEY (attribute_id) REFERENCES attributes(id),
    CONSTRAINT UQ_Product_Attribute UNIQUE (product_id, attribute_id)
);

CREATE TABLE product_sources (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    product_id BIGINT NOT NULL,
    source_url VARCHAR(1000) NOT NULL,
    source_type VARCHAR(50) NOT NULL,
    source_domain VARCHAR(255) NOT NULL,
    priority_score INT DEFAULT 50,
    last_crawled_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Source_Product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE product_versions (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    product_id BIGINT NOT NULL,
    field_changed VARCHAR(255) NOT NULL,
    old_value NVARCHAR(MAX) NULL,
    new_value NVARCHAR(MAX) NULL,
    changed_at DATETIME2 DEFAULT GETDATE(),
    source_domain VARCHAR(255) NULL,
    CONSTRAINT FK_Version_Product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE inventory (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    product_id BIGINT NOT NULL,
    source_domain VARCHAR(255) NOT NULL,
    quantity INT DEFAULT 0,
    price DECIMAL(18,2) NULL,
    last_update DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Inventory_Product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

GO

-- ==============================================================================
-- FLYWAY V2: VIEWS AND FUNCTIONS
-- ==============================================================================
CREATE VIEW vw_active_products AS
SELECT p.id, p.name, b.name AS brand, c.name AS category, p.specs_json, i.price, i.quantity
FROM products p
JOIN brands b ON p.brand_id = b.id
JOIN categories c ON p.category_id = c.id
LEFT JOIN inventory i ON p.id = i.product_id
WHERE p.deleted_at IS NULL AND p.status = 'ACTIVE';
GO

CREATE FUNCTION fn_get_priority_source (@productId BIGINT)
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @domain VARCHAR(255);
    SELECT TOP 1 @domain = source_domain
    FROM product_sources
    WHERE product_id = @productId
    ORDER BY priority_score DESC, last_crawled_at DESC;
    RETURN @domain;
END;
GO

-- ==============================================================================
-- FLYWAY V3: TRIGGERS AND STORED PROCEDURES
-- ==============================================================================
CREATE TRIGGER trg_update_product_timestamp
ON products
AFTER UPDATE
AS
BEGIN
    UPDATE products
    SET updated_at = GETDATE()
    FROM products p
    INNER JOIN inserted i ON p.id = i.id;
END;
GO

CREATE PROCEDURE sp_merge_product_inventory
    @ProductId BIGINT,
    @SourceDomain VARCHAR(255),
    @Quantity INT,
    @Price DECIMAL(18,2)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inventory WHERE product_id = @ProductId AND source_domain = @SourceDomain)
    BEGIN
        UPDATE inventory
        SET quantity = @Quantity, price = @Price, last_update = GETDATE()
        WHERE product_id = @ProductId AND source_domain = @SourceDomain;
    END
    ELSE
    BEGIN
        INSERT INTO inventory (product_id, source_domain, quantity, price)
        VALUES (@ProductId, @SourceDomain, @Quantity, @Price);
    END
END;
GO

-- ==============================================================================
-- FLYWAY V4: SEED DATA
-- ==============================================================================
INSERT INTO categories (name, slug) VALUES 
('CPU', 'cpu'), ('Graphics Card', 'vga'), ('Motherboard', 'mainboard');

INSERT INTO manufacturers (name) VALUES 
('Intel'), ('AMD'), ('NVIDIA'), ('ASUS');

INSERT INTO brands (manufacturer_id, name, slug) VALUES 
(1, 'Intel', 'intel'), (2, 'AMD', 'amd'), (4, 'ASUS ROG', 'asus-rog');
GO
