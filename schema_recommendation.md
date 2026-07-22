# SQL Schema Recommendation (Post-Audit)

Dựa trên cấu trúc dữ liệu thực tế bóc tách được từ 215 sản phẩm (GearVN Crawler), để đảm bảo tốc độ truy vấn, tối ưu hóa không gian lưu trữ và hỗ trợ chuẩn SEO, đây là bộ thiết kế Database được kiến nghị cho Phase 0 (Flyway).

## 1. Bảng Core

### Bảng `categories`
```sql
CREATE TABLE categories (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    slug VARCHAR(150) NOT NULL UNIQUE,
    parent_id INT NULL FOREIGN KEY REFERENCES categories(id),
    status BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE()
);
```
> [!NOTE]
> `slug` là bắt buộc để làm URL thân thiện (VD: `/cpu-intel`).

### Bảng `brands`
```sql
CREATE TABLE brands (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(150) NOT NULL UNIQUE,
    logo_url VARCHAR(500) NULL,
    created_at DATETIME DEFAULT GETDATE()
);
```
> [!TIP]
> Tách Brand ra bảng riêng thay vì lưu String ở bảng Products để phục vụ tính năng Lọc (Filter).

### Bảng `products`
```sql
CREATE TABLE products (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    slug VARCHAR(300) NOT NULL UNIQUE,
    sku VARCHAR(50) NULL UNIQUE, -- Không bắt buộc vì web crawler đôi khi không có SKU
    price DECIMAL(12,0) NOT NULL CHECK (price > 0),
    category_id INT NOT NULL FOREIGN KEY REFERENCES categories(id),
    brand_id INT NOT NULL FOREIGN KEY REFERENCES brands(id),
    image_url VARCHAR(500) NOT NULL,
    description NVARCHAR(MAX) NULL,
    status BIT DEFAULT 1,
    -- SEO Metadata
    meta_title NVARCHAR(255) NULL,
    meta_description NVARCHAR(500) NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);
```

### Bảng `inventory` (Tách khỏi Products theo chuẩn Enterprise)
```sql
CREATE TABLE inventory (
    product_id INT PRIMARY KEY FOREIGN KEY REFERENCES products(id),
    quantity INT NOT NULL DEFAULT 0,
    last_updated DATETIME DEFAULT GETDATE()
);
```

---

## 2. Các bảng Specs (Thông số kỹ thuật)

Tách riêng các bảng Specs với quan hệ 1-1 với `products` (Sử dụng `product_id` làm Primary Key) để tránh làm phình to bảng gốc và tối ưu truy vấn Filter.

### Bảng `cpu_specs`
```sql
CREATE TABLE cpu_specs (
    product_id INT PRIMARY KEY FOREIGN KEY REFERENCES products(id),
    socket VARCHAR(50) NULL,
    tdp_max INT NULL,
    has_igpu BIT NULL,
    includes_stock_cooler BIT NULL,
    ram_type_supported VARCHAR(50) NULL
);
```

### Bảng `gpu_specs`
```sql
CREATE TABLE gpu_specs (
    product_id INT PRIMARY KEY FOREIGN KEY REFERENCES products(id),
    length_mm INT NULL,
    thickness_mm INT NULL,
    power_consumption_tdp INT NULL,
    pcie8pin_required BIT NULL,
    pcie12vhpwr_required BIT NULL
);
```

### Bảng `mainboard_specs`
```sql
CREATE TABLE mainboard_specs (
    product_id INT PRIMARY KEY FOREIGN KEY REFERENCES products(id),
    socket VARCHAR(50) NULL,
    form_factor VARCHAR(50) NULL,
    ram_slots INT NULL,
    ram_type VARCHAR(50) NULL,
    cpu_power_connectors VARCHAR(50) NULL
);
```

*(Thiết kế tương tự cho các bảng `ram_specs`, `psu_specs`, `case_specs`, `storage_specs`... Mọi cột đều được thiết lập `NULL` để tránh lỗi Crash khi import dữ liệu do crawler quét thiếu một vài trường nhỏ).*

---

## 3. Indexing Recommendations

Để tăng tốc độ tìm kiếm và bộ lọc (Filter):
```sql
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_brand ON products(brand_id);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_slug ON products(slug);

CREATE INDEX idx_cpu_socket ON cpu_specs(socket);
CREATE INDEX idx_mainboard_socket ON mainboard_specs(socket);
CREATE INDEX idx_mainboard_form_factor ON mainboard_specs(form_factor);
```

---
> [!IMPORTANT]
> Tài liệu này được thiết kế dựa trên cấu trúc của 215 records đã quét. Toàn bộ thiết kế này đã sẵn sàng để được biên dịch thành file `V1__init.sql` ở Phase 0.
