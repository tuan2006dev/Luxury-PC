# ĐÁNH GIÁ TỔNG QUAN DATABASE DỰ ÁN LUXURY-PC

Là một Database Architect với hơn 20 năm kinh nghiệm, sau khi phân tích kỹ lưỡng file script `fixed.sql` của dự án, tôi có những nhận định sau:
Cơ sở dữ liệu của bạn có nền tảng tốt để bắt đầu, đã phân tách được một số domain như Users, Orders, Products, Combos. Tuy nhiên, nếu mang lên vận hành với quy mô lớn (Ecommerce chuẩn), Database này đang mắc phải nhiều **lỗi thiết kế chí mạng**, **thiếu Index trầm trọng** và **cấu trúc dư thừa** làm giảm khả năng mở rộng.

Dưới đây là phần đánh giá chi tiết theo 20 hạng mục bạn yêu cầu.

---

# Phần 1. Kiểm tra thiết kế

**Điểm số: 5.5/10**

- ✅ **Chuẩn hóa tới 3NF chưa**: Đa phần đã đạt chuẩn, tách biệt thông tin Users, Roles, Orders. Tuy nhiên, bảng lưu specs linh kiện thiết kế chưa tối ưu.
- ✅ **Có bảng dư thừa không**: **CÓ (Rất nhiều)**. Đang bị duplicate hàng loạt bảng cấu hình linh kiện: `case_specs` vs `casespec_specs`, `cpu_specs` vs `cpuspec_specs`, `cooler_specs` vs `coolerspec_specs`... hoàn toàn giống hệt nhau về cấu trúc cột. 
- ✅ **Có bảng thiếu không**: **CÓ**. Thiếu bảng `order_status_history` để lưu lịch sử trạng thái đơn hàng. Thiếu bảng `payments` độc lập (đang gộp vào sepay_transactions và orders).
- ✅ **Có cột dư không**: Cột `build_id` trong `shared_builds` đã bị drop nhưng cấu trúc ban đầu vẫn chứa nhiều ID linh kiện rời rạc. Đáng lẽ `shared_builds` chỉ cần nối với `pc_build_items`.
- ✅ **Có quan hệ sai không**: Bảng `stock_movements` không có cột `order_id` để biết xuất kho cho đơn hàng nào, khiến việc truy vết (Audit) kho bị đứt gãy. Bảng `inventory` đang quan hệ 1-1 với `products` (vì PK riêng nhưng lại FK tới product_id), có thể gộp cột `quantity` vào `products` nếu thiết kế đơn giản, hoặc dùng `product_id` làm PK của `inventory`.
- ✅ **Có bảng dễ gây lỗi dữ liệu không**: Có. `stock_movements` thiếu constraint tham chiếu với order.

## Vấn đề 1: Dư thừa bảng thông số kỹ thuật (Specs)
## Nguyên nhân
Quá trình map Object-Relational (ORM) sinh ra 2 bảng trùng lặp nhau cho cùng 1 loại linh kiện (Ví dụ `cpu_specs` và `cpuspec_specs`).
## Mức độ
Critical
## Hậu quả
Phải duy trì code cho cả 2 bảng, logic insert/update bị phân mảnh, join dữ liệu bị phức tạp. Tốn dung lượng.
## Cách sửa
Xóa toàn bộ các bảng `*spec_specs` (như `cpuspec_specs`, `casespec_specs`,...). Chỉ giữ lại `cpu_specs`, `case_specs`.
## Ví dụ SQL
```sql
DROP TABLE cpuspec_specs;
DROP TABLE casespec_specs;
-- Xóa tương tự cho các linh kiện khác
```

---

# Phần 2. Kiểm tra Naming Convention

- **Tên bảng**: Chưa thống nhất. Có bảng số nhiều (`users`, `orders`, `products`), có bảng số ít (`inventory`, `spring_session`, `game_engine_traits`). 
- **Tên cột**: Tương đối tốt (dùng `snake_case`), tuy nhiên có những cột viết rất dị như `pcie12vhpwr_required` (nhìn khó đọc).
- **Tên Index/Constraint**: Chủ yếu dùng tên mặc định tự sinh của EF/Hibernate hoặc tạo tự động (`FK_table1_table2`).

## Vấn đề
Thiếu tính nhất quán trong cách đặt tên bảng.
## Nguyên nhân
Thiết kế kết hợp giữa entity tự code và entity sinh ra bởi thư viện (như `spring_session`).
## Mức độ
Low
## Hậu quả
Khó nhớ, code bị lộn xộn.
## Cách sửa
Đồng nhất 1 chuẩn (VD: Tất cả bảng do mình định nghĩa đều dùng dạng số nhiều snake_case). Đổi `inventory` -> `inventories`.

---

# Phần 3. Kiểm tra Primary Key

- **PK đúng chưa**: Đa số dùng `INT IDENTITY(1,1)` là đúng cho các bảng nhỏ.
- **Vấn đề**: Các bảng giao dịch trọng yếu như `orders`, `order_items`, `products`, `users` dùng `INT`.
## Vấn đề
Dùng `INT` cho `orders`, `users`, `products`.
## Nguyên nhân
Thói quen thiết kế mặc định hoặc sinh tự động.
## Mức độ
High
## Hậu quả
Kiểu `INT` trong SQL Server có giới hạn ~2.1 tỷ. Với 1 sàn TMĐT, bảng `order_items` hoặc `stock_movements` có thể phình to rất nhanh. Nếu hết dung lượng sẽ gây crash toàn bộ hệ thống.
## Cách sửa
Chuyển PK của các bảng có tính chất "sinh ra liên tục" (Transactions, Logs, History) sang `BIGINT`.
## Ví dụ SQL
```sql
-- Khi tạo bảng nên dùng:
CREATE TABLE orders (
  id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  -- ...
);
```

---

# Phần 4. Kiểm tra Foreign Key

- **Thiếu FK**: Cột `order_id` thiếu trong `stock_movements`.
- **Cascade Delete/Update**: Đang để mặc định (NO ACTION). Tốt cho TMĐT (không được xóa nhầm Đơn hàng khi xóa User).
- **Index trên FK**: **Toàn bộ FK đang KHÔNG có Index**. Đây là lỗi rất nặng.

## Vấn đề
Không đánh Index trên các cột Foreign Key.
## Nguyên nhân
Quên tạo Index khi thiết kế ERD/Database.
## Mức độ
Critical
## Hậu quả
Mỗi khi JOIN bảng hoặc dùng lệnh DELETE bảng cha (VD: Xóa 1 category), SQL Server phải Table Scan toàn bộ bảng `products` để kiểm tra có ràng buộc hay không -> Gây Deadlock và cực kỳ chậm.
## Cách sửa
Tạo Non-Clustered Index cho tất cả các cột có đuôi `_id`.
## Ví dụ SQL
```sql
CREATE NONCLUSTERED INDEX IX_products_category_id ON products(category_id);
CREATE NONCLUSTERED INDEX IX_orders_user_id ON orders(user_id);
CREATE NONCLUSTERED INDEX IX_order_items_order_id ON order_items(order_id);
```

---

# Phần 5. Kiểm tra Data Type

- **Chuỗi**: Dùng `NVARCHAR` là chuẩn.
- **Boolean**: Dùng `BIT` là chuẩn.
- **Ngày tháng**: Dùng `DATETIME2` là chuẩn, độ chính xác cao hơn `DATETIME`.
- **Tiền tệ**:

## Vấn đề
Dùng `DECIMAL(18,2)` hoặc `numeric(15,2)` cho Tiền Tệ (VND).
## Nguyên nhân
Sử dụng chuẩn của nước ngoài (như USD có cents).
## Mức độ
Medium
## Hậu quả
VND không có số thập phân lẻ (không ai bán 15.000,50 VNĐ). Việc dùng `.2` làm tốn dung lượng, khi tính toán dễ bị sai số làm tròn.
## Cách sửa
Nên dùng `BIGINT` lưu mệnh giá VND hoặc `DECIMAL(18,0)`.
## Ví dụ SQL
```sql
ALTER TABLE products ALTER COLUMN price DECIMAL(18,0) NOT NULL;
ALTER TABLE orders ALTER COLUMN total_price DECIMAL(18,0);
```

---

# Phần 6. Kiểm tra Index

## Vấn đề
Hoàn toàn không có Index (ngoài các PK). Bị Missing Index nghiêm trọng.
## Nguyên nhân
Chưa tối ưu ở mức Database Engineer.
## Mức độ
Critical
## Hậu quả
Khi đạt 10.000 user, trang web sẽ sập vì các câu lệnh tìm kiếm sản phẩm (`WHERE name LIKE '%...'`), lọc theo giá, lọc theo Category, đăng nhập (`WHERE email = ...`) sẽ dẫn tới Table Scan 100%. CPU của SQL Server sẽ chạm 100%.
## Cách sửa
Bổ sung Index. Đặc biệt là Covering Index và Filter Index.
## Ví dụ SQL
```sql
-- Tìm kiếm theo email lúc login
CREATE UNIQUE NONCLUSTERED INDEX UQ_users_email ON users(email);

-- Tìm kiếm OrderCode
CREATE UNIQUE NONCLUSTERED INDEX UQ_orders_ordercode ON orders(order_code);

-- Lọc sản phẩm theo danh mục và giá
CREATE NONCLUSTERED INDEX IX_products_category_stock ON products(category_id, stock) INCLUDE (name, price);
```

---

# Phần 7. Kiểm tra Constraint

## Vấn đề
Thiếu UNIQUE và CHECK constraint. Rất nhiều trường không cho phép NULL nhưng chưa set NOT NULL ở db.
## Nguyên nhân
Giao phó toàn bộ logic validate cho Backend.
## Mức độ
High
## Hậu quả
Bug backend hoặc request đồng thời (Race Condition) sẽ tạo ra 2 user cùng 1 email, hoặc giá trị số lượng kho bị âm (`quantity = -5`), hoặc giá đơn hàng âm (`total_price < 0`).
## Cách sửa
Bổ sung Constraint ở tầng Database để bảo vệ dữ liệu cuối cùng.
## Ví dụ SQL
```sql
ALTER TABLE products ADD CONSTRAINT CHK_products_price CHECK (price >= 0);
ALTER TABLE inventory ADD CONSTRAINT CHK_inventory_quantity CHECK (quantity >= 0);
ALTER TABLE users ADD CONSTRAINT UQ_users_email UNIQUE (email);
ALTER TABLE orders ADD CONSTRAINT UQ_orders_code UNIQUE (order_code);
```

---

# Phần 8. Kiểm tra Transaction & Race Condition

## Vấn đề
Thiếu cơ chế Concurrency Token (RowVersion) ở bảng `inventory` và `products`.
## Nguyên nhân
Chưa thiết kế Database cho hệ thống phân tán chịu tải cao.
## Mức độ
Critical
## Hậu quả
Khi 10 người cùng mua món hàng Flash Sale chỉ còn 1 cái trong kho, nếu không có cơ chế khoá transaction an toàn thì kho bị âm -> Giao hàng hụt.
## Cách sửa
Thêm cột `RowVersion` cho bảng `inventory` (Optimistic Concurrency) hoặc dùng Serializable Transaction isolation ở backend code.
## Ví dụ SQL
```sql
ALTER TABLE inventory ADD row_version TIMESTAMP;
```

---

# Phần 9. Kiểm tra Performance

- **1000 users**: Sẽ chạy bình thường nhờ RAM/Cache bù đắp.
- **10000 users**: Bắt đầu xảy ra tình trạng Timeout khi query trang chủ, catalog.
- **100000 users**: SQL Server sẽ gặp Deadlock khi vừa có người đặt hàng vừa có người đọc danh sách sản phẩm (Do table bị scan và lock diện rộng vì thiếu Index).

---

# Phần 10. Kiểm tra Query Tối ưu

- **Paging / Search / Filter**: Do không có Index, các câu query chứa `ORDER BY created_at DESC OFFSET ... FETCH NEXT...` sẽ lấy toàn bộ dữ liệu lên để sort.
- Bổ sung ngay Index cho cột `created_at` ở các bảng cần Paging như `news`, `products`, `orders`.

---

# Phần 11. Kiểm tra khóa nghiệp vụ

- SKU chưa thấy trong bảng `products`. Một web bán linh kiện máy tính chuyên nghiệp bắt buộc phải có mã **SKU** và **Barcode** để quản lý kho bảo hành.
- Mã voucher, order_code cũng cần là UNIQUE.

---

# Phần 12. Kiểm tra Build PC

- Đã có các cột hỗ trợ test tương thích như `socket`, `ram_type`, `wattage`, `max_gpu_length`.
- **Nhược điểm**: Tổ chức 1 bảng cho mỗi linh kiện. Tuy tốt về logic 3NF nhưng query khá dài. Thiết kế này có thể dùng được nhưng phải dọn dẹp các bảng duplicate (đã nêu ở Phần 1).

---

# Phần 13. Kiểm tra Kho (Inventory)

## Vấn đề
Chỉ có 1 cột Quantity trong Inventory.
## Mức độ
High
## Cách sửa
Trong TMĐT chuẩn, Kho phải có ít nhất 3 tham số:
1. `stock_total`: Tổng tồn vật lý.
2. `stock_reserved`: Đang bị giữ lại (do khách đặt đơn nhưng chưa giao).
3. `stock_available`: Tồn thực tế có thể bán (= total - reserved).

---

# Phần 14. Kiểm tra Đơn hàng (Orders)

## Vấn đề
Thiếu bảng `order_status_history`.
## Hậu quả
Không biết ai đã đổi đơn hàng từ "Chờ xử lý" sang "Đang giao", đổi vào lúc nào, lý do là gì.
## Cách sửa
Tạo bảng `order_status_history` (id, order_id, previous_status, new_status, note, created_by, created_at).

---

# Phần 15 & 16. Bảo mật và Audit

- Đã có mã hóa mật khẩu.
- Thiếu cột Audit (`created_by`, `updated_by`) ở hầu hết các bảng quan trọng (`products`, `orders`).
- Không có Soft Delete (ví dụ cột `is_deleted BIT`). Web bán PC không bao giờ `DELETE` cứng dòng đơn hàng hay sản phẩm vì nó dính tới thống kê kế toán.

---

# Phần 17 & 18. Khả năng mở rộng & Chuẩn Ecommerce

- **Mở rộng kho**: Database hiện tại không hỗ trợ nhiều kho chi nhánh vì `inventory` không có `warehouse_id`.
- **Mở rộng biến thể**: Không hỗ trợ tốt Product Variants (Màu sắc, Dung lượng). Đang thiết kế sản phẩm phẳng (1 dòng 1 sản phẩm fix cứng).
- So sánh chuẩn: Cơ sở dữ liệu này hoạt động được ở mức Đồ Án, nhưng để đạt chuẩn thương mại điện tử chuyên nghiệp (như GearVN, Phong Vũ) thì cần khắc phục các lỗi nghiêm trọng đã liệt kê ở trên.

---

# Phần 19. Chấm điểm tổng quan

| Tiêu chí | Điểm (100) | Đánh giá |
| :--- | :---: | :--- |
| **Thiết kế** | 60 | Tạm ổn, rõ ràng nhưng dư thừa bảng specs. |
| **Hiệu năng** | 30 | Cực thấp do **0 có Index**. |
| **Khả năng mở rộng** | 50 | Khó mở rộng thêm nhiều kho bãi hoặc biến thể sản phẩm. |
| **Bảo trì** | 55 | Đặt tên còn lộn xộn, thiếu comment database. |
| **An toàn dữ liệu** | 40 | Rủi ro trừ kho âm, thiếu UNIQUE/CHECK constraint. |
| **Phát triển lâu dài**| 45 | Cần đợt refactor thêm (đánh Index, thêm khóa constraint). |
| **ĐIỂM TRUNG BÌNH** | **46.6/100** | Cần nâng cấp kiến trúc ngay lập tức. |

---

# Phần 20. Đề xuất cải tiến cấp tốc (Actionable Items)

1. **Các bảng nên BỎ**: `casespec_specs`, `cpuspec_specs`, `coolerspec_specs`, `gpuspec_specs`, `mainboardspec_specs`, `psuspec_specs`, `ramspec_specs`, `storagespec_specs`.
2. **Các bảng nên THÊM**: `order_status_history`, `payments`.
3. **Các cột nên THÊM**: 
   - `SKU` vào `products` (UNIQUE).
   - `order_id` vào `stock_movements`.
   - `is_deleted` vào `products`.
   - Thêm Audit data (`created_by`, `updated_by`).
4. **Các Index nên THÊM**: Index toàn bộ FK, và filter Index cho các truy vấn nặng.
5. **Các Constraint nên THÊM**: ADD CHECK `price >= 0` và `quantity >= 0`. UNIQUE `email`, `order_code`.
