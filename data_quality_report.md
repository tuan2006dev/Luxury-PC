# Data Quality Report (Post-Scraping Audit)

## 1. Tổng quan chiến dịch Crawler (Phase A)
- **Tổng số Link tìm thấy**: 284
- **Số lượng Link đã xử lý (Processed)**: 284
- **Số lượng Record Sạch (Success)**: 215
- **Số lượng Bỏ qua (Skipped/Lỗi/Duplicate Web)**: 69
- Báo cáo `import_report.json` đã được **Audit và chuẩn hóa lại** (Fix lỗi bất đồng bộ số lượng khi load Checkpoint).

## 2. Kết quả Audit Dữ liệu (Phase B, C, D)
Tập dữ liệu 215 sản phẩm đã được quét qua kịch bản kiểm tra nghiêm ngặt:

| Tiêu chí | Trạng thái | Ghi chú |
| :--- | :--- | :--- |
| **Tên sản phẩm rỗng** | `0` (Sạch) | Pass |
| **Giá âm / bằng 0** | `0` (Sạch) | Pass |
| **Giá bất thường** | `1` (Cảnh báo) | Có 1 sản phẩm có giá bất thường (Nằm ngoài ngưỡng 100k - 200 triệu). Đã đánh cờ cảnh báo `Data Score: 4`. |
| **Thiếu Hình ảnh (Missing Image)**| `0` (Sạch) | Mọi sản phẩm đều có URL ảnh bắt đầu bằng `https://`. URL dạng `//` của Haravan đã được tự động convert. |
| **Thiếu Brand / Category** | `0` (Sạch) | Pass |
| **Duplicate Data** | `0` (Sạch) | Dataset tinh khiết. Không phát hiện trùng lặp URL hoặc Tên sản phẩm trong tập dữ liệu Master. |
| **Thiếu Thông số Socket (CPU)** | `0` (Sạch) | 100% CPU đều bóc tách được `AM4`, `AM5`, `LGA 1700`, v.v. |

## 3. Data Normalization (Phase E)
Các bước chuẩn hóa đã tự động áp dụng để sinh ra file `gearvn_full_data_cleaned.json`:
- **Tên**: Cắt khoảng trắng thừa (Trim & Regex replace).
- **Thương hiệu**: Đưa về chuẩn Canonical (Ví dụ: `INTEL` -> `Intel`, `GIGABYTE` -> `Gigabyte`).
- **Hình ảnh**: Ép kiểu `https://`.

## 4. Phân loại Data Quality Score (Phase F)
- **★★★★★ (Perfect)**: `214` sản phẩm.
- **★★★★☆ (Good - Warning)**: `1` sản phẩm (Cảnh báo giá bất thường).
- **★★★☆☆ / ★★☆☆☆ / ★☆☆☆☆**: `0` sản phẩm.
- **Reject (Invalid)**: `0` sản phẩm (Đã lọc từ trước).

## 5. Kết luận
Dữ liệu đã đạt độ chuẩn xác **99.5%**, hoàn toàn tinh khiết, không còn duplicate nghiêm trọng và các trường bắt buộc đều đã được bảo vệ.

=> **TRẠNG THÁI: READY FOR PHASE 0 (FLYWAY)**
