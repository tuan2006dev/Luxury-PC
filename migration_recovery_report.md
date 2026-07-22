# Migration Recovery Report

## 1. Nguyên nhân Sự cố
Lỗi `FlywayValidateException: Detected applied migration not resolved locally: 1` xảy ra do sự bất đồng bộ giữa **Lịch sử Database** và **Mã nguồn (Source Code)**.
- Khi truy vấn bảng `flyway_schema_history` trong cơ sở dữ liệu `LUXURYPC`, hệ thống ghi nhận migration `V1__remove_obsolete_news_published.sql` (Checksum: `-1979696205`) đã được thực thi thành công vào ngày `2026-07-16 06:53:59`.
- Tuy nhiên, sau khi quét toàn bộ thư mục dự án và lịch sử các nhánh trong Git (`git log`, `git reflog`), file này **hoàn toàn không tồn tại**.
- **Nguyên nhân cốt lõi**: Nhà phát triển tiền nhiệm (hoặc đồng nghiệp) đã chạy file migration này ở môi trường Local/Development, nhưng sau đó đã xóa file đi hoặc **quên commit** file này lên Git. Hậu quả là Database thì đã được cập nhật, nhưng Source code thì trống trơn, dẫn đến việc cơ chế Validate của Flyway chặn lại vì nghi ngờ tính toàn vẹn của mã nguồn.

## 2. Migration Bị Mất
- **Tên file**: `V1__remove_obsolete_news_published.sql`
- **Phiên bản (Version)**: `1`
- **Checksum**: `-1979696205`
- **Trạng thái**: Mất vĩnh viễn khỏi Git history.

## 3. Đánh giá Ảnh hưởng (Impact Analysis)
Qua việc phân tích bảng `news` bằng câu lệnh SQL trực tiếp trên SQL Server, tôi ghi nhận:
- Bảng `news` hiện đang có 15 cột (`id`, `title`, `content`, `status`, `created_at`...).
- Không còn tồn tại cột `published` (cột này có khả năng là boolean hoặc datetime đã bị rác/obsolete).
- **Mức độ ảnh hưởng**: Thấp. Database schema hiện tại vẫn ổn định và việc mất file SQL không làm hỏng dữ liệu bên trong. Ảnh hưởng duy nhất là Flyway chặn không cho chạy `V2__luxury_pc_schema.sql` (chứa schema của chúng ta) do lỗi Validation.

## 4. Cách Khôi phục An toàn (Safe Recovery)
Do chúng ta có nguyên tắc **TUYỆT ĐỐI KHÔNG** dùng `flyway clean`, **KHÔNG** tạo file giả, và **KHÔNG** can thiệp thủ công vào Database, phương án an toàn nhất và đúng chuẩn quy trình Enterprise lúc này là:

### Phương án: Bỏ qua các Migration đã mất (Ignore Missing Migrations)
Vì file `V1` đã chạy xong trên DB và không bao giờ chạy lại, chúng ta có thể hướng dẫn Flyway phớt lờ việc thiếu hụt file này ở môi trường cục bộ để tiếp tục tập trung vào `V2`.

**Cách thực hiện:**
Mở `application.properties` và bổ sung cấu hình:
```properties
spring.flyway.ignore-missing-migrations=true
```
*(Nếu đang dùng plugin Maven, có thể set `<ignoreMissingMigrations>true</ignoreMissingMigrations>`)*.

**Lý do chọn phương án này:**
- **Không xâm lấn (Non-invasive)**: Không sửa đổi/xóa bất kỳ data hay lịch sử nào trong DB.
- **An toàn tuyệt đối**: Vượt qua Validation 1 cách hợp lệ để tiếp tục deploy schema V2 (Phase 0) cho 215 sản phẩm crawler.

---
Vui lòng xem xét báo cáo. Nếu bạn đồng ý với Phương án Khôi phục trên, xin hãy ra lệnh để tôi áp dụng vào file cấu hình và tiếp tục tiến hành Validate lại!
