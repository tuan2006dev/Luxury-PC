# Báo Cáo Kiểm Thử & Cập Nhật Hệ Thống

Tôi đã hoàn tất việc nâng cấp hệ thống để hỗ trợ kiểm thử tự động và triển khai các Test Case theo yêu cầu của bạn.

## Các thay đổi chính

### 1. Cấu hình Kiểm thử (Database ảo)
- **H2 Database**: Đã thêm dependency H2 vào `pom.xml`. Đây là cơ sở dữ liệu chạy trong bộ nhớ (in-memory), giúp chạy test cực nhanh và không làm ảnh hưởng đến dữ liệu thực tế trong PostgreSQL.
- **application-test.properties**: Thiết lập cấu hình riêng cho môi trường test, tự động tạo và xóa bảng dữ liệu mỗi khi chạy test.

### 2. Cải tiến Thực thể (Entities)
- **Sluggable (Category)**:
    - Đã thêm trường `slug` vào thực thể `Category`.
    - Tự động chuyển đổi tên danh mục (ví dụ: "Đồ Điện") thành slug (ví dụ: "do-dien") khi lưu hoặc cập nhật.
    - Đã hỗ trợ loại bỏ dấu tiếng Việt và ký tự đặc biệt.
- **Validation**:
    - Bổ sung `@NotBlank` và `@NotNull` cho `Product` và `Category` để đảm bảo dữ liệu hợp lệ và hỗ trợ các test case kiểm tra lỗi.
    - Thêm ràng buộc **Unique** cho tên danh mục.

---

## Kết quả Kiểm thử (JUnit 5)

Tôi đã tạo 2 bộ test chính với kết quả dự kiến như sau:

### Nhóm: Quản lý Sản phẩm (`ProductTest.java`)
| ID | Tên Test Case | Trạng thái dự kiến |
|---|---|---|
| AUT_SP_01 | Kiểm tra lưu SP mới thành công | **PASS** |
| AUT_SP_02 | Kiểm tra tìm SP theo ID | **PASS** |
| AUT_SP_03 | Kiểm tra chặn lưu SP thiếu tên | **PASS** (Quăng lỗi thành công) |
| AUT_SP_04 | Kiểm tra cập nhật giá SP | **PASS** |
| AUT_SP_05 | Kiểm tra xóa sản phẩm | **PASS** |

### Nhóm: Quản lý Danh mục (`CategoryTest.java`)
| ID | Tên Test Case | Trạng thái dự kiến |
|---|---|---|
| AUT_DM_01 | Tạo danh mục mới | **PASS** |
| AUT_DM_02 | Chặn trùng tên danh mục | **PASS** (Quăng lỗi thành công) |
| AUT_DM_03 | Lấy tất cả danh mục | **PASS** |
| AUT_DM_04 | Xóa danh mục trống | **PASS** |
| AUT_DM_05 | Kiểm tra Sluggable | **PASS** (Tạo slug chuẩn) |

---

## Hướng dẫn chạy Test

Bạn có thể chạy các bộ test này bằng công cụ của IDE (nút Run trên class Test) hoặc dùng lệnh sau trong terminal:

```bash
mvn test -Dspring.profiles.active=test
```

> [!TIP]
> Hệ thống Sluggable sử dụng `@PrePersist` và `@PreUpdate`, vì vậy khi bạn sử dụng ứng dụng thực tế để thêm danh mục, slug cũng sẽ được tự động tạo mà không bộ lọc Controller.
