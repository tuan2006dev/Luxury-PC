# BÁO CÁO KIỂM TRA ĐỐI CHIẾU CODE JAVA SPRING BOOT & DATABASE (SQL SERVER)

Dưới đây là báo cáo đối chiếu chuyên sâu giữa Source code Spring Boot (Hibernate/JPA) và Database SQL Server (`fixed.sql`). 
Là một Database Architect & Senior Spring Boot Engineer, tôi đã phát hiện nhiều điểm bất đồng (mismatch) nghiêm trọng có thể gây lỗi Runtime.

---

## Phần 1. Kiểm tra Entity ↔ Database

### 1. Mismatch tại Entity `Order.java`
- **Mức độ**: Critical
- **File**: `Order.java`
- **Database**: Bảng `orders`
- **Mô tả**: Bảng `orders` trong SQL có các cột: `installment_bank`, `installment_fee`, `installment_term`, `stock_deducted`, `stock_restored`. Tuy nhiên Entity `Order.java` **HOÀN TOÀN KHÔNG CÓ** các field này.
- **Nguyên nhân**: Code Java chưa được cập nhật theo Schema Database mới nhất (hoặc ngược lại).
- **Ảnh hưởng**: Khi lưu Order, JPA sẽ bỏ qua các cột này (lưu giá trị NULL hoặc Default). Tính năng trả góp (Installment) sẽ bị hỏng hoàn toàn.
- **Đề xuất**: Bổ sung các field tương ứng vào `Order.java` kèm theo Annotation `@Column` chuẩn xác.

### 2. Lệch Data Type tại Entity `Order.java` và `Product.java`
- **Mức độ**: Medium
- **File**: `Product.java`, `Order.java`
- **Database**: `products` (cột `price`), `orders` (cột `total_price`)
- **Mô tả**: Entity dùng kiểu `Double` cho `price`, `totalPrice`. Tuy nhiên SQL dùng `DECIMAL(18,2)`.
- **Nguyên nhân**: Dùng `Double` (Floating point) để map với `DECIMAL`.
- **Ảnh hưởng**: `Double` trong Java có thể gây sai số làm tròn khi tính tiền (ví dụ: `0.1 + 0.2 = 0.30000000000000004`).
- **Đề xuất**: Chuyển đổi kiểu dữ liệu `Double` sang `BigDecimal` trong Entity Java để tính toán tiền tệ chính xác nhất.

### 3. Sai Length tại Entity `Order.java`
- **Mức độ**: Low
- **File**: `Order.java`
- **Database**: `orders`
- **Mô tả**: `@Column(name = "admin_note", length = 1000)` và `refund_reason` trong Java giới hạn 1000 ký tự. Nhưng trong SQL là `NVARCHAR(MAX)`.
- **Nguyên nhân**: Khai báo độ dài ở JPA và SQL không đồng nhất.
- **Ảnh hưởng**: Nếu admin nhập note 1500 ký tự, Hibernate không lỗi lúc map, nhưng có thể bị cắt chuỗi nếu có validation hoặc thư viện map. (Nếu cấu hình ddl-auto = update, Hibernate sẽ cố sửa cột).
- **Đề xuất**: Đồng bộ về độ dài (Đổi JPA thành `columnDefinition = "NVARCHAR(MAX)"`).

### 4. Thiếu cột `enabled` tại Entity `User.java`
- **Mức độ**: High
- **File**: `User.java`
- **Database**: Bảng `users`, cột `enabled`
- **Mô tả**: SQL tạo cột `enabled BIT DEFAULT 1` và `status BIT`. Entity Java chỉ có field `status` (Boolean), không hề có `enabled`. 
- **Nguyên nhân**: Lập trình viên quên map trường `enabled` (chỉ dùng `status`).
- **Ảnh hưởng**: Khi code Security cần lấy quyền (ví dụ `isEnabled()`), nếu không có trường này thì dữ liệu không nhất quán. JPA khi `save(user)` sẽ luôn để `enabled` = null (hoặc lấy default 1 của SQL nhưng không read được).
- **Đề xuất**: Bổ sung `private Boolean enabled;` vào `User.java`.

---

## Phần 2. Kiểm tra Mapping (Foreign Key)

### 1. Mapping sai `UNIQUE` Constraint
- **Mức độ**: Medium
- **File**: `Inventory.java`
- **Database**: Bảng `inventory`
- **Mô tả**: Entity định nghĩa: `@JoinColumn(name = "product_id", unique = true)`. Nhưng trong Database `fixed.sql`, bảng `inventory` KHÔNG HỀ CÓ `UNIQUE CONSTRAINT` trên cột `product_id`.
- **Nguyên nhân**: Dùng `@OneToOne` nên cố tình set `unique=true` bên Java, nhưng lúc tạo Script SQL bị bỏ quên.
- **Ảnh hưởng**: Hệ thống CSDL vật lý không cấm việc insert 2 dòng `inventory` cho cùng 1 `product_id`. Sẽ sinh ra lỗi nổ data `NonUniqueResultException` khi Hibernate truy vấn `@OneToOne` nếu lỡ có 2 dòng rác trong DB.
- **Đề xuất**: Thêm `UNIQUE` constraint cho cột `product_id` ở SQL Server.

---

## Phần 4. Kiểm tra Service & Transaction

### 1. Dư thừa logic đồng bộ tồn kho (Stock)
- **Mức độ**: Medium
- **File**: `OrderServiceImpl.java` (Logic trừ kho)
- **Database**: `products` và `inventory`
- **Mô tả**: Mã nguồn đang lưu tồn kho ở 2 nơi: `Product.stock` VÀ `Inventory.quantity`. Khi khách mua hàng, code gọi:
  ```java
  product.setStock(product.getStock() - qty); // update bảng product
  inv.setQuantity(product.getStock()); // update bảng inventory
  ```
- **Nguyên nhân**: Thiết kế database dư thừa, dùng bảng Product lưu thông tin mà bảng Inventory cũng lưu.
- **Ảnh hưởng**: Có nguy cơ bất đồng bộ (Inconsistency) giữa 2 bảng nếu server nổ ngang lúc update 1 trong 2 bảng (dù có Transaction). 
- **Đề xuất**: Dùng chuẩn 1 bảng để quản lý số tồn duy nhất. Khuyến nghị bỏ field `stock` trong `Product`, chỉ dùng `Inventory`.
- **Điểm Sáng**: Code Service ĐÃ CÓ Pessimistic Locking (`@Lock(LockModeType.PESSIMISTIC_WRITE)` trong `ProductDAO`) để chống Race Condition lúc mua hàng (rất tốt).

---

## Phần 8. Kiểm tra Validation

### 1. Thiếu Annotation Validation ở `User.java`
- **Mức độ**: High
- **File**: `User.java`
- **Database**: `users`
- **Mô tả**: Các field `email`, `password` trong bảng `users` được gán constraint `NOT NULL`. Tuy nhiên, trong Java Entity không hề có annotation `@NotNull` hay `@NotBlank`.
- **Nguyên nhân**: Quên sử dụng `jakarta.validation` ở Entity.
- **Ảnh hưởng**: Controller truyền object rỗng xuống, Hibernate sẽ không chặn lại, bắn thẳng query xuống DB -> Nổ lỗi `DataIntegrityViolationException` (Lỗi 500 Runtime) thay vì lỗi Validation 400 Bad Request gọn gàng.
- **Đề xuất**: Gắn `@NotBlank` cho `email` và `password`.

---

## Phần 16 & 17. Kiểm tra Dead Code & DB Dư Thừa

### 1. Database sinh dư bảng Specs
- **Mức độ**: Low
- **Database**: Hàng loạt bảng `casespec_specs`, `cpuspec_specs`, `coolerspec_specs`...
- **Mô tả**: Database có tạo ra các bảng này, nhưng qua kiểm tra hệ thống Entity, hoàn toàn **KHÔNG TỒN TẠI** các Entity như `CpuSpecSpecs.java`. 
- **Nguyên nhân**: Có thể là rác sinh ra từ 1 version Flyway cũ hoặc do lỗi setup ddl-auto.
- **Đề xuất**: Xóa hoàn toàn các bảng rác này trong Database vì source code không hề đọc / ghi vào.

### 2. Ghi Log thiếu liên kết bảng (Foreign Key đứt gãy)
- **Mức độ**: High
- **File**: `OrderServiceImpl.java`
- **Database**: `stock_movements`
- **Mô tả**: Khi ghi log xuất kho, code lưu `movement.setNote("Khách mua hàng - Đơn hàng #" + savedOrder.getId());`. 
  Cột `order_id` không tồn tại trong Entity `StockMovement` lẫn Database.
- **Ảnh hưởng**: Khi thống kê "Đơn hàng này đã trừ những kho nào", phải parse chuỗi text trong cột `note` bằng LIKE '%...' -> Hiệu năng cực tệ và thiếu chuyên nghiệp.
- **Đề xuất**: Thêm cột `order_id` (FK) vào `stock_movements` và map `@ManyToOne Order order` ở Entity.

---

## Phần 18. Kiểm tra Bug Runtime có thể xảy ra

1. **`DataIntegrityViolationException`**: Có thể nổ khi tạo/cập nhật `User` bị thiếu `email` do không có `@NotNull` validator.
2. **`NonUniqueResultException`**: Nổ ra nếu admin vô tình insert thủ công 2 dòng vào bảng `inventory` cùng 1 `product_id` (do SQL chưa chặn UNIQUE, dù JPA yêu cầu `@OneToOne`).
3. **`NullPointerException`**: Tại `CartItem.java` hàm `getAmount()` kiểm tra null nhưng nếu logic Controller set null sẽ gây crash lúc deserialize.
4. **Mất dữ liệu**: Bất kỳ đơn hàng nào có trả góp sẽ bị mất thông tin ngân hàng trả góp do `Order.java` không map 3 cột trả góp dưới Database.

---

## Phần 19. Chấm điểm tổng kết Code vs Database

- **Mapping (Entity vs DB)**: 6/10 (Mất điểm vì Order thiếu cột, User thiếu cột).
- **Validation**: 5/10 (Để lọt Validation xuống tầng DB quá nhiều).
- **Transaction & Lock**: 9/10 (Biết dùng Pessimistic Lock để chống Overselling khi thanh toán).
- **Query / Repository**: 8/10 (Dùng Native Query đúng chỗ, có Paging chuẩn).
- **Maintainability**: 6/10 (Lưu Stock ở 2 nơi gây đau đầu bảo trì).

**Tổng điểm đối chiếu: 68/100.** Code Backend khá ổn nhưng cần đồng bộ Entity với các cập nhật mới của Database ngay lập tức (đặc biệt là tính năng trả góp).
