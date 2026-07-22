-- V1__init.sql

CREATE TABLE categories (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    slug VARCHAR(150) NOT NULL UNIQUE,
    parent_id INT NULL FOREIGN KEY REFERENCES categories(id),
    status BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE brands (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(150) NOT NULL UNIQUE,
    logo_url VARCHAR(500) NULL,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE products (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    slug VARCHAR(300) NOT NULL UNIQUE,
    sku VARCHAR(50) NULL UNIQUE,
    price DECIMAL(12,0) NOT NULL CHECK (price > 0),
    category_id INT NOT NULL FOREIGN KEY REFERENCES categories(id),
    brand_id INT NOT NULL FOREIGN KEY REFERENCES brands(id),
    image_url VARCHAR(500) NOT NULL,
    description NVARCHAR(MAX) NULL,
    status BIT DEFAULT 1,
    meta_title NVARCHAR(255) NULL,
    meta_description NVARCHAR(500) NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE inventory (
    product_id INT PRIMARY KEY FOREIGN KEY REFERENCES products(id),
    quantity INT NOT NULL DEFAULT 0,
    last_updated DATETIME DEFAULT GETDATE()
);

CREATE TABLE cpu_specs (
    product_id INT PRIMARY KEY FOREIGN KEY REFERENCES products(id),
    socket VARCHAR(50) NULL,
    tdp_max INT NULL,
    has_igpu BIT NULL,
    includes_stock_cooler BIT NULL,
    ram_type_supported VARCHAR(50) NULL
);

CREATE TABLE gpu_specs (
    product_id INT PRIMARY KEY FOREIGN KEY REFERENCES products(id),
    length_mm INT NULL,
    thickness_mm INT NULL,
    power_consumption_tdp INT NULL,
    pcie8pin_required BIT NULL,
    pcie12vhpwr_required BIT NULL
);

CREATE TABLE mainboard_specs (
    product_id INT PRIMARY KEY FOREIGN KEY REFERENCES products(id),
    socket VARCHAR(50) NULL,
    form_factor VARCHAR(50) NULL,
    ram_slots INT NULL,
    ram_type VARCHAR(50) NULL,
    cpu_power_connectors VARCHAR(50) NULL
);

CREATE TABLE ram_specs (
    product_id INT PRIMARY KEY FOREIGN KEY REFERENCES products(id),
    capacity_total VARCHAR(50) NULL,
    ddr_type VARCHAR(50) NULL,
    module_count INT NULL
);

CREATE TABLE psu_specs (
    product_id INT PRIMARY KEY FOREIGN KEY REFERENCES products(id),
    wattage INT NULL,
    length_mm INT NULL,
    pcie8pin_connectors INT NULL,
    cpu8pin_connectors INT NULL
);

CREATE TABLE case_specs (
    product_id INT PRIMARY KEY FOREIGN KEY REFERENCES products(id),
    max_gpu_length_mm INT NULL,
    max_cpu_cooler_height_mm INT NULL,
    motherboard_support VARCHAR(255) NULL
);

CREATE TABLE storage_specs (
    product_id INT PRIMARY KEY FOREIGN KEY REFERENCES products(id),
    form_factor VARCHAR(50) NULL,
    interface_type VARCHAR(50) NULL
);

CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_brand ON products(brand_id);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_slug ON products(slug);

CREATE INDEX idx_cpu_socket ON cpu_specs(socket);
CREATE INDEX idx_mainboard_socket ON mainboard_specs(socket);
CREATE INDEX idx_mainboard_form_factor ON mainboard_specs(form_factor);
