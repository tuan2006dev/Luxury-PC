# Activity Diagrams

## 1. Quản lý Sản phẩm
```mermaid
flowchart TD
    A[Admin mở trang quản lý sản phẩm] --> B[Hệ thống hiển thị danh sách sản phẩm và danh mục]
    B --> C{Admin chọn hành động}
    C -->|Thêm sản phẩm mới| D[Admin nhập thông tin sản phẩm]
    C -->|Sửa sản phẩm| E[Admin chọn sản phẩm và sửa thông tin]
    C -->|Xóa sản phẩm| F[Admin xác nhận xóa]
    D --> G[Upload ảnh nếu có]
    E --> H[Giữ ảnh cũ nếu không chọn ảnh mới]
    G --> I[Cập nhật thông tin ảnh vào đối tượng Product]
    H --> I
    I --> J[Lưu Product vào DB]
    J --> K[Chuyển hướng về /admin/products]
    F --> J
```

## 2. Quản lý Danh mục
```mermaid
flowchart TD
    A[Admin mở trang quản lý danh mục] --> B[Hệ thống hiển thị danh sách danh mục]
    B --> C{Admin chọn hành động}
    C -->|Thêm danh mục mới| D[Admin nhập tên danh mục]
    C -->|Sửa danh mục| E[Admin chọn danh mục và sửa tên]
    C -->|Xóa danh mục| F[Admin xác nhận xóa]
    D --> G[Lưu Category vào DB]
    E --> G
    F --> G
    G --> H[Chuyển hướng về /admin/categories]
```

## 3. Quản lý Nhân Viên
```mermaid
flowchart TD
    A[Admin mở trang quản lý nhân viên] --> B[Hiển thị danh sách nhân viên (Người dùng không phải admin)]
    B --> C{Admin chọn hành động}
    C -->|Thêm nhân viên| D[Nhập thông tin nhân viên mới]
    C -->|Sửa nhân viên| E[Chọn nhân viên và chỉnh sửa]
    C -->|Khóa tài khoản| F[Đặt status = false]
    C -->|Mở khóa tài khoản| G[Đặt status = true]
    C -->|Xóa nhân viên| H[Xóa user khỏi DB]
    D --> I[Lưu User vào DB]
    E --> I
    F --> I
    G --> I
    H --> I
    I --> J[Chuyển hướng về /admin/account]
```

## 4. Quản lý Người dùng
```mermaid
flowchart TD
    A[Admin mở trang quản lý người dùng] --> B[Hiển thị danh sách người dùng]
    B --> C{Admin chọn hành động}
    C -->|Thêm người dùng| D[Nhập thông tin người dùng]
    C -->|Sửa người dùng| E[Chọn người dùng và chỉnh sửa]
    C -->|Khóa tài khoản| F[Đặt status = false]
    C -->|Mở khóa tài khoản| G[Đặt status = true]
    C -->|Xóa người dùng| H[Xóa user khỏi DB]
    D --> I[Lưu User vào DB]
    E --> I
    F --> I
    G --> I
    H --> I
    I --> J[Chuyển hướng về /admin/account]
```

## 5. Xem sản phẩm theo loại
```mermaid
flowchart TD
    A[Người dùng mở trang sản phẩm] --> B[Hệ thống hiển thị bộ lọc danh mục, giá, từ khóa]
    B --> C[Người dùng chọn loại sản phẩm (cid)]
    C --> D[Hệ thống gọi productService.searchProducts(cid, min, max, kw)]
    D --> E[Trả về danh sách sản phẩm tương ứng loại]
    E --> F[Hiển thị kết quả trên trang /products]
```

## 6. Giỏ hàng
```mermaid
flowchart TD
    A[Người dùng trên trang sản phẩm] --> B[Click "Thêm vào giỏ hàng"]
    B --> C[Kiểm tra session cart hiện tại]
    C --> D{Sản phẩm đã có trong giỏ?}
    D -->|Có| E[Tăng số lượng tới tối đa 99]
    D -->|Chưa| F[Thêm sản phẩm mới vào giỏ]
    E --> G[Cập nhật session cart]
    F --> G
    G --> H[Chuyển hướng về /cart]

    H --> I[Người dùng xem giỏ hàng]
    I --> J[Hiển thị các mục giỏ, tổng tiền, giảm giá VIP]
    I --> K{Người dùng cập nhật / xóa mục}
    K -->|Cập nhật số lượng| L[Cập nhật quantity trong session cart]
    K -->|Xóa mục| M[Xóa sản phẩm khỏi session cart]
    L --> J
    M --> J
```

## 7. Đặt hàng
```mermaid
flowchart TD
    A[Người dùng mở trang checkout] --> B[Hệ thống kiểm tra giỏ hàng]
    B -->|Giỏ trống| C[Chuyển hướng về /cart]
    B -->|Không trống| D[Tính tổng tiền và giảm giá VIP]
    D --> E[Hiển thị checkout form và voucher]
    E --> F[Người dùng gửi thông tin giao hàng]
    F --> G[Kiểm tra voucher nếu có và người dùng đăng nhập]
    G --> H[Áp dụng giảm giá voucher hợp lệ]
    H --> I[Tạo Order với trạng thái PENDING]
    I --> J[Tạo OrderItem cho từng sản phẩm trong giỏ]
    J --> K[Cập nhật số lượng flash sale nếu cần]
    K --> L[Xóa session cart]
    L --> M[Chuyển hướng về /checkout?success]
```
