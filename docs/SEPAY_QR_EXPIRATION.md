# Thời hạn thanh toán SePay/VietQR

## Quy tắc chung

Mỗi mã VietQR có hiệu lực đúng 10 phút. Backend là nguồn quyết định thời gian; frontend chỉ hiển thị dữ liệu backend trả về và không tự cộng 10 phút từ lúc mở hoặc reload trang.

Mỗi lần phát QR được lưu thành một bản ghi trong bảng `sepay_payment_sessions`. Reload dùng lại bản ghi mới nhất. Khi người dùng bấm **Tạo lại mã QR** hoặc **Thanh toán lại**, request có `renew=true`; backend tạo payment session mới rồi redirect về URL không có `renew`, vì vậy reload sau đó không tạo thêm session.

Các thời điểm mới được biểu diễn bằng `Instant` trong Java và lưu trong SQL Server `DATETIME2(3)` với quy ước UTC.

## Ý nghĩa các mốc thời gian

| Mốc | Nguồn và ý nghĩa |
| --- | --- |
| `qrCreatedAt` | Thời điểm backend tạo bản ghi `sepay_payment_sessions` khi trang QR được mở lần đầu hoặc người dùng chủ động tạo lại QR. |
| `qrExpiresAt` | `qrCreatedAt + 10 phút`, được lưu một lần trong payment session. |
| `transactionDate` | Thời điểm giao dịch ngân hàng trong payload SePay. Chuỗi không có offset được parse theo `Asia/Ho_Chi_Minh`, sau đó đổi sang `Instant`. |
| `webhookReceivedAt` | Thời điểm backend bắt đầu nhận webhook. Tái sử dụng cột `sepay_transactions.received_at`; entity có alias `getWebhookReceivedAt()`. |
| `paidAt` | Thời điểm backend xác nhận thanh toán thành công, lưu trên payment session khớp với giao dịch. Giá trị bằng `webhookReceivedAt` của lần xác nhận. |
| `expiredAt` | Thời điểm backend ghi nhận session hết hạn khi mở trang, polling, tạo lại QR hoặc xử lý giao dịch ngoài cửa sổ hợp lệ. Đây không phải là thời điểm hết hạn dự kiến; thời điểm dự kiến là `qrExpiresAt`. |

## Ranh giới 10 phút

Một giao dịch chỉ hợp lệ khi có payment session thỏa:

```text
qrCreatedAt <= effectivePaymentTime < qrExpiresAt
```

Vì vậy:

- Trước `qrExpiresAt` 1 giây: hợp lệ.
- Bằng `qrExpiresAt`: hết hạn.
- Sau `qrExpiresAt`: hết hạn.
- API trạng thái trả `expired=true` khi order chưa thanh toán và `serverTime >= expiresAt`.
- `remainingSeconds` được backend tính từ `serverTime` và `expiresAt`, làm tròn lên ở phần giây và không nhỏ hơn 0.

## Webhook đến muộn

Backend xác thực chữ ký và giữ nguyên cơ chế chống giao dịch trùng bằng `sepay_transaction_id`.

Thời điểm dùng để đối chiếu:

1. Parse được `transactionDate`: dùng thời điểm giao dịch ngân hàng.
2. Thiếu hoặc không parse được `transactionDate`: dùng `webhookReceivedAt`, ghi WARN và lưu lý do trong `processing_status`.

Webhook đến sau 10 phút vẫn được chấp nhận nếu `transactionDate` nằm trong bất kỳ payment session nào của order. Điều này hỗ trợ webhook của một QR cũ đến sau khi khách đã tạo session mới.

Nếu không có session hợp lệ, giao dịch vẫn được lưu trong `sepay_transactions` nhưng order không chuyển sang `DA_THANH_TOAN`. Backend trả HTTP 200 với `success=true` cho mọi kết quả đã lưu thành công để SePay không retry vô hạn. Payload sai JSON, sai chữ ký, quá lớn hoặc lỗi lưu DB vẫn trả lỗi HTTP tương ứng.

Các trạng thái đối soát chính:

- `PAID`: giao dịch đúng tài khoản, số tiền, order và thời hạn.
- `PAID_FALLBACK_MISSING_TRANSACTION_DATE`: xác nhận bằng `webhookReceivedAt` do thiếu `transactionDate`.
- `PAID_FALLBACK_INVALID_TRANSACTION_DATE`: xác nhận bằng `webhookReceivedAt` do ngày không parse được.
- `REJECTED_QR_EXPIRED`: giao dịch nằm ngoài mọi cửa sổ QR.
- `REJECTED_QR_EXPIRED_FALLBACK_MISSING_DATE`: thiếu ngày và webhook đến ngoài hạn.
- `REJECTED_QR_EXPIRED_FALLBACK_INVALID_DATE`: ngày sai và webhook đến ngoài hạn.
- `REJECTED_ACCOUNT_MISMATCH`: sai tài khoản nhận.
- `REJECTED_AMOUNT_MISMATCH`: sai số tiền.
- `REJECTED_ORDER_NOT_FOUND`: không tìm thấy order.
- `REJECTED_PAYMENT_CODE`, `REJECTED_PAYMENT_METHOD`, `REJECTED_ORDER_STATUS`: mã hoặc trạng thái không phù hợp.
- `IGNORED_ORDER_ALREADY_PAID`: order đã được thanh toán bởi giao dịch trước.
- Giao dịch trùng `sepay_transaction_id` trả kết quả idempotent `DUPLICATE` và không xử lý lần hai.

## API trạng thái và frontend

`GET /api/payments/vietqr/status` yêu cầu user sở hữu order và `X-Payment-Token` hợp lệ. Response có:

```json
{
  "orderCode": "DH39",
  "status": "CHO_XAC_NHAN_THANH_TOAN",
  "paymentStatus": "Chờ xác nhận thanh toán",
  "paid": false,
  "serverTime": "2026-07-26T12:00:00Z",
  "qrCreatedAt": "2026-07-26T12:00:00Z",
  "expiresAt": "2026-07-26T12:10:00Z",
  "remainingSeconds": 600,
  "expired": false
}
```

`payment-vietqr.js` tính độ lệch `serverTime - Date.now()` và dùng độ lệch đó khi hiển thị `MM:SS`. Script:

- Poll trạng thái mỗi 5 giây.
- Dùng guard `data-vietqr-initialized` để không tạo interval trùng.
- Đồng bộ lại API khi tab trở về `visible`.
- Ưu tiên kết quả `paid` trước khi xử lý hết hạn.
- Khi hết hạn: clear polling và countdown interval, hiển thị `00:00`, làm mờ QR, hiện thông báo/nút tạo lại và phát:

```javascript
document.dispatchEvent(new CustomEvent("vietqr:expired", {
    detail: {
        orderCode,
        expiresAt
    }
}));
```

## Các file tham gia luồng

Backend:

- `PaymentController`: kiểm tra quyền/order, lấy hoặc tạo session, xử lý tạo lại và render QR.
- `VietQrPaymentStatusController`: trả thời gian server, session hiện tại, số giây còn lại và trạng thái hết hạn.
- `SePayWebhookController`: nhận webhook, giữ xác thực hiện tại và ACK giao dịch đã lưu.
- `SePayWebhookService`: lưu giao dịch, parse `transactionDate`, đối chiếu session và cập nhật order.
- `SePayPaymentSession`: giữ token polling hiện có và quản lý vòng đời payment session trong DB.
- `VietQrPaymentSession`, `VietQrPaymentSessionRepository`: entity/repository của các lần phát QR.
- `Order`: giữ nguyên trạng thái order hiện có; không thêm trạng thái hết hạn mới.
- `SePayTransaction`: lưu `transactionDate`; `received_at` tiếp tục là `webhookReceivedAt`.

Frontend:

- `templates/payment-vietqr.html`
- `static/js/payment-vietqr.js`
- `templates/account/profile/orders.html`

Không phục hồi hoặc sử dụng `fragments/profile/_orders.html`.

## Migration SQL Server

Không dùng Hibernate để sửa schema production và không thay đổi `spring.jpa.hibernate.ddl-auto`.

Điều kiện triển khai:

1. Xác nhận SQL Server đã có bảng `dbo.sepay_transactions` của luồng SePay hiện tại.
2. Chạy `src/main/resources/db/manual/V2__add_vietqr_payment_sessions.sql`.

V1 là script PostgreSQL cũ của luồng SePay và được giữ nguyên; không chạy V1 trên SQL Server.

V2 thực hiện:

```sql
ALTER TABLE dbo.sepay_transactions
    ADD transaction_date DATETIME2(3) NULL;

CREATE TABLE dbo.sepay_payment_sessions (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    qr_created_at DATETIME2(3) NOT NULL,
    qr_expires_at DATETIME2(3) NOT NULL,
    paid_at DATETIME2(3) NULL,
    expired_at DATETIME2(3) NULL,
    FOREIGN KEY (order_id) REFERENCES dbo.orders(id)
);
```

Script thật có kiểm tra `IF` để chạy lại an toàn, tạo index `(order_id, qr_created_at DESC)` và backfill một session cho order VietQR cũ bằng `created_at`/`created_at + 10 phút`. Backfill không cấp thêm 10 phút cho dữ liệu cũ. `paid_at` của đơn lịch sử để `NULL` vì không có nguồn dữ liệu đáng tin để suy diễn.

Lưu ý tương thích: `orders.created_at` cũ được giữ theo quy ước thời gian hiện tại của dự án. Nếu dữ liệu lịch sử được nhập bằng giờ địa phương thay vì UTC, cần đối chiếu thủ công các order cũ quanh thời điểm triển khai.

## Test tay

1. Checkout bằng VietQR, mở trang QR và xác nhận đồng hồ bắt đầu gần `10:00`.
2. Chờ một phút, reload trang; thời gian phải tiếp tục, không trở lại `10:00`.
3. Chuyển tab ít nhất 20 giây rồi quay lại; trạng thái và đồng hồ phải đồng bộ với server.
4. Để tới `00:00`; polling dừng, QR mờ, xuất hiện “Mã QR đã hết hạn” và nút **Tạo lại mã QR**.
5. Bắt event trong DevTools:

   ```javascript
   document.addEventListener("vietqr:expired", event => console.log(event.detail));
   ```

6. Bấm tạo lại; URL cuối không còn `renew=true`, session mới có đủ 10 phút và reload không tạo session khác.
7. Gửi webhook test có `transactionDate` trước hạn nhưng webhook đến sau hạn; order phải được thanh toán.
8. Gửi webhook có `transactionDate` bằng/sau hạn; order giữ `CHO_XAC_NHAN_THANH_TOAN`, giao dịch có `REJECTED_QR_EXPIRED`.
9. Gửi lại cùng `sepay_transaction_id`; số bản ghi không tăng và order không xử lý lần hai.
10. Kiểm tra sai tiền, sai tài khoản và order không tồn tại: giao dịch được lưu với trạng thái từ chối, HTTP 200 ACK.
11. Checkout COD và INSTALLMENT; trạng thái/redirect phải giữ nguyên.

## Đối soát giao dịch sau hạn

Admin tra `sepay_transactions` theo `sepay_transaction_id`, `order_code`, `payment_code`, `transaction_date`, `received_at` và `processing_status`. Không tự chuyển order sang đã thanh toán đối với giao dịch hết hạn. Tùy nghiệp vụ, admin có thể hoàn tiền hoặc liên hệ khách; không dùng endpoint xác nhận VietQR thủ công hiện có để bỏ qua webhook.
