SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
USE LUXURYPC;
GO

-- ----------------------------------------------------------------------------
-- 11. 20 MÃ GIẢM GIÁ VOUCHER ĐA DẠNG CHUẨN SHOPEE (FREESHIP, % GIẢM, GIÁ TRỊ CỐ ĐỊNH, VIP)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'user_vouchers') AND type IN ('U')) DELETE FROM user_vouchers;
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'vouchers') AND type IN ('U')) DELETE FROM vouchers;
GO
SET IDENTITY_INSERT vouchers ON;
INSERT INTO vouchers (id, code, description, discount_type, voucher_scope, discount_value, min_order_amount, max_discount_amount, usage_limit, used_count, category_id, start_date, end_date, active, created_at) VALUES

(1, 'FREESHIP50K', N'Miễn phí vận chuyển 50.000đ cho đơn hàng từ 500.000đ', 'FIXED_AMOUNT', 'FREESHIP', 50000.00, 500000.00, 50000.00, 1000, 86, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(2, 'FREESHIP100K', N'Miễn phí vận chuyển 100.000đ cho đơn hàng từ 2.000.000đ', 'FIXED_AMOUNT', 'FREESHIP', 100000.00, 2000000.00, 100000.00, 500, 42, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(3, 'FREESHIPMAX', N'Freeship Xtra toàn quốc tối đa 300.000đ cho đơn từ 10.000.000đ', 'FIXED_AMOUNT', 'FREESHIP', 300000.00, 10000000.00, 300000.00, 300, 19, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(4, 'WELCOME2026', N'Chào mừng bạn mới - Giảm 10% tối đa 500.000đ cho đơn từ 1.000.000đ', 'PERCENTAGE', 'GLOBAL', 10.00, 1000000.00, 500000.00, 2000, 315, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(5, 'NEWBIE100K', N'Quà tặng thành viên mới - Giảm ngay 100.000đ trực tiếp đơn từ 500.000đ', 'FIXED_AMOUNT', 'GLOBAL', 100000.00, 500000.00, 100000.00, 1500, 210, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(6, 'LUXURY500K', N'Giảm ngay 500.000đ cho đơn hàng linh kiện / PC từ 15.000.000đ', 'FIXED_AMOUNT', 'GLOBAL', 500000.00, 15000000.00, 500000.00, 500, 68, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(7, 'LUXURY1M', N'Giảm ngay 1.000.000đ cho đơn hàng High-End từ 30.000.000đ', 'FIXED_AMOUNT', 'GLOBAL', 1000000.00, 30000000.00, 1000000.00, 300, 45, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(8, 'LUXURY2M', N'Giảm siêu khủng 2.000.000đ cho dàn PC Flagship từ 50.000.000đ', 'FIXED_AMOUNT', 'GLOBAL', 2000000.00, 50000000.00, 2000000.00, 150, 28, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(9, 'MEGA10', N'Mega Voucher - Giảm 10% tối đa 1.500.000đ cho đơn từ 5.000.000đ', 'PERCENTAGE', 'GLOBAL', 10.00, 5000000.00, 1500000.00, 800, 142, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(10, 'MEGA15', N'Siêu Sale Giữa Tháng - Giảm 15% tối đa 2.500.000đ cho đơn từ 8.000.000đ', 'PERCENTAGE', 'GLOBAL', 15.00, 8000000.00, 2500000.00, 400, 89, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(11, 'BUILDPC500K', N'Ưu đãi Build PC Gaming - Giảm 500.000đ khi lắp trọn bộ từ 20.000.000đ', 'FIXED_AMOUNT', 'GLOBAL', 500000.00, 20000000.00, 500000.00, 600, 115, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(12, 'BUILDPC1M5', N'Ưu đãi PC Custom Watercooling - Giảm 1.500.000đ cho đơn từ 45.000.000đ', 'FIXED_AMOUNT', 'GLOBAL', 1500000.00, 45000000.00, 1500000.00, 200, 34, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(13, 'GAMINGGEAR10', N'Giảm 10% tối đa 300.000đ cho Bàn phím, Chuột, Tai nghe Gaming từ 800.000đ', 'PERCENTAGE', 'CATEGORY', 10.00, 800000.00, 300000.00, 1000, 240, 16, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(14, 'VGAFLASH200K', N'Giảm 200.000đ khi mua Card đồ họa VGA RTX 40/50 Series từ 7.000.000đ', 'FIXED_AMOUNT', 'CATEGORY', 200000.00, 7000000.00, 200000.00, 500, 92, 10, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(15, 'CPUKING150K', N'Giảm 150.000đ khi nâng cấp CPU Intel Core Ultra / Ryzen 9000 từ 4.000.000đ', 'FIXED_AMOUNT', 'CATEGORY', 150000.00, 4000000.00, 150000.00, 500, 78, 1, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(16, 'RAMSSD88K', N'Giảm 88.000đ khi mua RAM DDR5 hoặc Ổ cứng SSD NVMe từ 1.200.000đ', 'FIXED_AMOUNT', 'CATEGORY', 88000.00, 1200000.00, 88000.00, 800, 160, 3, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(17, 'FLASHSALE12H', N'Flash Sale Khung Giờ Vàng 12h - Giảm 12% tối đa 800.000đ đơn từ 2.500.000đ', 'PERCENTAGE', 'GLOBAL', 12.00, 2500000.00, 800000.00, 300, 145, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(18, 'MIDNIGHT50K', N'Cú Đêm Săn Sale (0h-2h) - Giảm ngay 50.000đ trực tiếp cho đơn từ 300.000đ', 'FIXED_AMOUNT', 'GLOBAL', 50000.00, 300000.00, 50000.00, 1000, 310, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(19, 'VIPMEMBER3M', N'Đặc quyền VIP Diamond - Giảm siêu ưu đãi 3.000.000đ cho đơn từ 60.000.000đ', 'FIXED_AMOUNT', 'GLOBAL', 3000000.00, 60000000.00, 3000000.00, 100, 18, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00'),
(20, 'LUXURYFEST20', N'Siêu Đại Tiệc Công Nghệ - Giảm 20% tối đa 5.000.000đ cho đơn từ 20.000.000đ', 'PERCENTAGE', 'GLOBAL', 20.00, 20000000.00, 500000.00, 150, 52, NULL, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, '2026-01-01 00:00:00');
SET IDENTITY_INSERT vouchers OFF;
DBCC CHECKIDENT ('vouchers', RESEED, 20);
GO

-- ----------------------------------------------------------------------------
-- 11.1. LƯU VOUCHER MẪU CHO CÁC KHÁCH HÀNG (USER_VOUCHERS)
-- ----------------------------------------------------------------------------
SET IDENTITY_INSERT user_vouchers ON;
INSERT INTO user_vouchers (id, user_id, voucher_id, status, saved_at) VALUES
(1, 1, 1, 'AVAILABLE', '2026-01-01 08:00:00'),
(2, 1, 4, 'AVAILABLE', '2026-01-01 08:00:00'),
(3, 1, 6, 'AVAILABLE', '2026-01-01 08:00:00'),
(4, 1, 11, 'AVAILABLE', '2026-01-01 08:00:00'),
(5, 1, 19, 'AVAILABLE', '2026-01-01 08:00:00'),
(6, 22, 1, 'AVAILABLE', '2026-02-01 08:00:00'),
(7, 22, 4, 'AVAILABLE', '2026-02-01 08:00:00'),
(8, 22, 9, 'AVAILABLE', '2026-02-01 08:00:00'),
(9, 23, 2, 'AVAILABLE', '2026-02-05 09:00:00'),
(10, 23, 10, 'AVAILABLE', '2026-02-05 09:00:00'),
(11, 24, 3, 'AVAILABLE', '2026-02-10 10:00:00'),
(12, 24, 8, 'AVAILABLE', '2026-02-10 10:00:00'),
(13, 25, 5, 'AVAILABLE', '2026-02-15 11:00:00'),
(14, 25, 12, 'AVAILABLE', '2026-02-15 11:00:00'),
(15, 26, 1, 'AVAILABLE', '2026-03-01 12:00:00'),
(16, 26, 14, 'AVAILABLE', '2026-03-01 12:00:00'),
(17, 27, 2, 'AVAILABLE', '2026-03-05 13:00:00'),
(18, 27, 15, 'AVAILABLE', '2026-03-05 13:00:00'),
(19, 28, 3, 'AVAILABLE', '2026-03-10 14:00:00'),
(20, 28, 16, 'AVAILABLE', '2026-03-10 14:00:00');
SET IDENTITY_INSERT user_vouchers OFF;
DBCC CHECKIDENT ('user_vouchers', RESEED, 20);
GO


-- ----------------------------------------------------------------------------
-- 12. 10 TICKETS HỖ TRỢ TRÒ CHUYỆN THỰC TẾ NHƯ NGƯỜI THẬT
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'ticket_messages') AND type IN ('U')) DELETE FROM ticket_messages;
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'tickets') AND type IN ('U')) DELETE FROM tickets;
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'support_tickets') AND type IN ('U')) DELETE FROM support_tickets;
GO

SET IDENTITY_INSERT tickets ON;
INSERT INTO tickets (id, customer_name, customer_email, customer_phone, subject, category, message, assigned_admin, status, created_at) VALUES

(1, N'Nguyễn Tuấn Anh', 'tuananh.gamer@gmail.com', '0988112233', N'Tư vấn cấu hình PC Gaming 35 triệu chơi Black Myth: Wukong và GTA 6 ở độ phân giải 2K', 'BUILD_PC', N'Chào shop, mình có ngân sách khoảng 35 triệu, muốn build 1 case PC chuyên chơi game nặng như Black Myth Wukong, Cyberpunk và chuẩn bị cho GTA 6 ở màn hình 2K 165Hz. Nhờ shop tư vấn combo tối ưu nhất trong tầm giá giúp mình với ạ.', 'staff.hoanglong', 'IN_PROGRESS', '2026-08-20 09:30:00'),
(2, N'Trần Hoàng Nam', 'namth.dev@gmail.com', '0912345679', N'Nhờ hướng dẫn bật XMP và tối ưu bus RAM Corsair Dominator Titanium 6000MHz trên main ASUS Z890', 'TECHNICAL', N'Hôm qua mình vừa nhận máy bên shop gửi, kiểm tra Task Manager thấy RAM đang hiển thị 4800MHz trong khi kit mình mua là 6000MHz. Shop hướng dẫn mình cách bật lên với ạ.', 'staff.minhduc', 'RESOLVED', '2026-08-22 14:10:00'),
(3, N'Đặng Trúc Hà', 'khachhang038@gmail.com', '0761979308', N'Kiểm tra tiến độ vận chuyển đơn hàng #LXR2608230002 giao về Cầu Giấy Hà Nội', 'ORDER', N'Shop ơi mình vừa đặt mua đơn hàng LXR2608230002 hôm qua, không biết hôm nay đã đóng gói và bàn giao cho đơn vị vận chuyển chưa ạ? Khoảng mấy giờ mình nhận được máy?', 'staff.thutrang', 'IN_PROGRESS', '2026-08-24 08:45:00'),
(4, N'Lê Quốc Bảo', 'quocbao.tech@gmail.com', '0918765432', N'Card màn hình ASUS ROG RTX 4080 Super quạt không quay khi bật máy có phải lỗi không?', 'TECHNICAL', N'Shop cho mình hỏi xíu, mình đang dùng card RTX 4080 Super mới mua bên bạn, lúc bật máy lướt web xem Youtube thì thấy 3 quạt của card hoàn toàn không quay. Lúc chơi game thì quạt mới quay. Như vậy có phải card bị lỗi cảm biến nhiệt không shop?', 'staff.quanghuy', 'RESOLVED', '2026-08-25 11:20:00'),
(5, N'Phan Trường Giang', 'giang.ai@gmail.com', '0987654321', N'Tư vấn cấu hình máy trạm chạy mô hình DeepSeek LLM và render 3D Blender ngân sách 70 triệu', 'BUILD_PC', N'Xin chào Luxury PC, mình là kỹ sư AI đang cần build 1 bộ máy workstation chuyên dụng để chạy fine-tune các model LLM local (DeepSeek, Llama 3) và render mô hình 3D Blender. Ngân sách tầm 70-80 triệu, ưu tiên VRAM GPU lớn từ 24GB trở lên và RAM hệ thống tối thiểu 64GB. Nhờ shop lên cấu hình giúp.', 'staff.giahuynh', 'OPEN', '2026-08-27 15:30:00'),
(6, N'Võ Tấn Phát', 'tanphat.danang@gmail.com', '0982345678', N'Vỏ case Corsair 3500X có lắp vừa tản nhiệt nước AIO 360mm ở mặt nóc không?', 'TECHNICAL', N'Shop cho mình hỏi case Corsair 3500X TG kính cường lực mình muốn lắp tản nước AIO 360mm ở nóc case và cắm card RTX 4080 dài 34cm thì có bị cấn không shop?', 'staff.vietanh', 'RESOLVED', '2026-08-28 10:15:00'),
(7, N'Ngô Bích Ngọc', 'bichngoc.arc@gmail.com', '0965432109', N'Yêu cầu báo giá 10 bộ PC văn phòng kết hợp thiết kế đồ họa 2D Photoshop cho công ty kiến trúc', 'PRICE', N'Kính gửi bộ phận kinh doanh Luxury PC, công ty kiến trúc bên mình đang cần mua mới 10 dàn máy tính cho nhân viên thiết kế 2D AutoCad, Photoshop và Sketchup. Ngân sách khoảng 18-20 triệu/bộ (đã bao gồm màn hình 27 inch IPS). Nhờ công ty gửi bảng báo giá chính thức có hóa đơn VAT và chính sách bảo hành doanh nghiệp qua email bichngoc.arc@gmail.com giúp mình nhé.', 'staff.thuytien', 'OPEN', '2026-08-29 09:00:00'),
(8, N'Dương Thị Lam', 'khachhang050@gmail.com', '0347084450', N'Hướng dẫn thủ tục trả góp 0% qua thẻ tín dụng và SePay chuyển khoản QR', 'ORDER', N'Mình muốn mua bộ PC 25 triệu và thanh toán trả góp 0% qua thẻ tín dụng Visa Techcombank kỳ hạn 12 tháng thì thủ tục như thế nào vậy shop?', 'staff.phuongthao', 'RESOLVED', '2026-08-30 14:00:00'),
(9, N'Đỗ Minh Đức', 'minhduc.tech@gmail.com', '0912345678', N'Xin link tải phần mềm chỉnh LED RGB cho linh kiện ROG Strix và Corsair iCUE', 'TECHNICAL', N'Shop cho mình xin link chuẩn để tải phần mềm đồng bộ đèn LED cho main ASUS và RAM Corsair với ạ.', 'staff.tuankiet', 'CLOSED', '2026-08-31 16:20:00'),
(10, N'Huỳnh Đức Khoa', 'khachhang034@gmail.com', '0777610058', N'Khen ngợi bạn nhân viên kỹ thuật hỗ trợ lắp máy tại nhà rất nhiệt tình và chu đáo', 'GENERAL', N'Mình gửi ticket này để gửi lời cảm ơn đến Luxury PC và đặc biệt là bạn kỹ thuật viên Long sáng nay đã mang dàn PC đến tận nhà mình lắp đặt. Bạn làm việc rất cẩn thận, đi dây siêu đẹp và còn nhiệt tình hướng dẫn mình cách bảo quản vệ sinh máy. Dịch vụ bên bạn rất chuyên nghiệp 10/10 điểm!', 'staff.hoanglong', 'CLOSED', '2026-09-01 11:00:00');
SET IDENTITY_INSERT tickets OFF;
DBCC CHECKIDENT ('tickets', RESEED, 10);
GO

SET IDENTITY_INSERT support_tickets ON;
INSERT INTO support_tickets (id, user_id, customer_name, customer_email, customer_phone, subject, category, message, admin_reply, assigned_admin, status, created_at, updated_at) VALUES

(1, 22, N'Nguyễn Tuấn Anh', 'tuananh.gamer@gmail.com', '0988112233', N'Tư vấn cấu hình PC Gaming 35 triệu chơi Black Myth: Wukong và GTA 6 ở độ phân giải 2K', 'BUILD_PC', N'Chào shop, mình có ngân sách khoảng 35 triệu, muốn build 1 case PC chuyên chơi game nặng như Black Myth Wukong, Cyberpunk và chuẩn bị cho GTA 6 ở màn hình 2K 165Hz. Nhờ shop tư vấn combo tối ưu nhất trong tầm giá giúp mình với ạ.', N'Chào anh Tuấn Anh! Với ngân sách 35 triệu để chiến mượt 2K Ultra Settings, Luxury PC xin tư vấn anh cấu hình tối ưu nhất: CPU Intel Core i5-14600KF (14 nhân 20 luồng) + Card đồ họa RTX 4070 Super 12GB GDDR6X + 32GB RAM DDR5 Corsair 6000MHz + Nguồn 750W 80 Plus Gold + Tản nhiệt nước AIO 360mm. Cấu hình này test thực tế Wukong 2K đạt 90-110 FPS rất mượt mà anh nhé!', 'staff.hoanglong', 'IN_PROGRESS', '2026-08-20 09:30:00', '2026-08-20 09:30:00'),
(2, 23, N'Trần Hoàng Nam', 'namth.dev@gmail.com', '0912345679', N'Nhờ hướng dẫn bật XMP và tối ưu bus RAM Corsair Dominator Titanium 6000MHz trên main ASUS Z890', 'TECHNICAL', N'Hôm qua mình vừa nhận máy bên shop gửi, kiểm tra Task Manager thấy RAM đang hiển thị 4800MHz trong khi kit mình mua là 6000MHz. Shop hướng dẫn mình cách bật lên với ạ.', N'Dạ chào anh Nam, mặc định chuẩn DDR5 khi mới cắm sẽ nhận bus gốc 4800MHz để đảm bảo tương thích boot máy. Anh làm theo các bước sau giúp em nhé:
1. Khởi động lại máy, bấm liên tục phím DEL để vào BIOS.
2. Ở trang EzMode góc trái, anh tìm mục ''X.M.P'' chuyển từ Disabled sang ''XMP I'' hoặc ''Profile 1''.
3. Bấm phím F10 chọn ''Save & Exit'' là xong ạ!', 'staff.minhduc', 'RESOLVED', '2026-08-22 14:10:00', '2026-08-22 14:10:00'),
(3, 59, N'Đặng Trúc Hà', 'khachhang038@gmail.com', '0761979308', N'Kiểm tra tiến độ vận chuyển đơn hàng #LXR2608230002 giao về Cầu Giấy Hà Nội', 'ORDER', N'Shop ơi mình vừa đặt mua đơn hàng LXR2608230002 hôm qua, không biết hôm nay đã đóng gói và bàn giao cho đơn vị vận chuyển chưa ạ? Khoảng mấy giờ mình nhận được máy?', N'Chào chị Trúc Hà! Em kiểm tra hệ thống thấy đơn hàng của chị đã được đội ngũ kỹ thuật lắp ráp hoàn tất và bàn giao cho shipper chuyên biệt của Luxury PC lúc 8h30 sáng nay. Dự kiến khoảng 14h - 15h chiều nay shipper sẽ liên hệ trước khi giao tới địa chỉ số 311 Võ Văn Kiệt của chị ạ.', 'staff.thutrang', 'IN_PROGRESS', '2026-08-24 08:45:00', '2026-08-24 08:45:00'),
(4, 24, N'Lê Quốc Bảo', 'quocbao.tech@gmail.com', '0918765432', N'Card màn hình ASUS ROG RTX 4080 Super quạt không quay khi bật máy có phải lỗi không?', 'TECHNICAL', N'Shop cho mình hỏi xíu, mình đang dùng card RTX 4080 Super mới mua bên bạn, lúc bật máy lướt web xem Youtube thì thấy 3 quạt của card hoàn toàn không quay. Lúc chơi game thì quạt mới quay. Như vậy có phải card bị lỗi cảm biến nhiệt không shop?', N'Dạ chào anh Bảo, anh hoàn toàn yên tâm nhé! Các dòng card cao cấp hiện nay của ASUS đều có công nghệ ''0dB Fan Tech''. Khi nhiệt độ GPU dưới 50-55 độ C (khi lướt web, làm việc nhẹ), quạt sẽ tự động dừng hoàn toàn để giữ im lặng tuyệt đối và tăng tuổi thọ trục bi. Khi anh vào game nặng nhiệt độ tăng lên quạt sẽ tự động quay làm mát ạ!', 'staff.quanghuy', 'RESOLVED', '2026-08-25 11:20:00', '2026-08-25 11:20:00'),
(5, 25, N'Phan Trường Giang', 'giang.ai@gmail.com', '0987654321', N'Tư vấn cấu hình máy trạm chạy mô hình DeepSeek LLM và render 3D Blender ngân sách 70 triệu', 'BUILD_PC', N'Xin chào Luxury PC, mình là kỹ sư AI đang cần build 1 bộ máy workstation chuyên dụng để chạy fine-tune các model LLM local (DeepSeek, Llama 3) và render mô hình 3D Blender. Ngân sách tầm 70-80 triệu, ưu tiên VRAM GPU lớn từ 24GB trở lên và RAM hệ thống tối thiểu 64GB. Nhờ shop lên cấu hình giúp.', N'Chào anh Giang! Đối với nhu cầu train/inference LLM và Render 3D nặng, cấu hình đề xuất chuẩn trạm cho anh gồm:
- CPU: Intel Core Ultra 9 285K (24 nhân 24 luồng, đơn nhân cực mạnh)
- Mainboard: ASUS ROG STRIX Z890-F GAMING WIFI
- RAM: 64GB (2x32GB) DDR5 Corsair Dominator Titanium 6400MHz
- VGA: MSI GeForce RTX 4090 24GB GDDR6X Gaming X Trio
- SSD: 2TB Samsung 990 PRO Gen4x4 (Đọc 7450MB/s nạp tensor siêu nhanh)
- Nguồn: Corsair RM1000e 1000W 80 Plus Gold ATX 3.0
- Tản nhiệt nước: Corsair Nautilus 360 RS ARGB.
Tổng cấu hình khoảng 78.5 triệu, bên em có sẵn hàng để lắp ráp ngay cho anh ạ!', 'staff.giahuynh', 'OPEN', '2026-08-27 15:30:00', '2026-08-27 15:30:00'),
(6, 26, N'Võ Tấn Phát', 'tanphat.danang@gmail.com', '0982345678', N'Vỏ case Corsair 3500X có lắp vừa tản nhiệt nước AIO 360mm ở mặt nóc không?', 'TECHNICAL', N'Shop cho mình hỏi case Corsair 3500X TG kính cường lực mình muốn lắp tản nước AIO 360mm ở nóc case và cắm card RTX 4080 dài 34cm thì có bị cấn không shop?', N'Dạ chào anh Phát! Case Corsair 3500X được thiết kế khoang nóc rất thoáng, hỗ trợ hoàn hảo tản nước Rad 360mm dày tới 65mm (cả quạt) mà không hề cấn vào tản nhôm VRM mainboard. Chiều dài card VGA case hỗ trợ lên tới 410mm nên card RTX 4080 34cm lắp vào cực kỳ rộng rãi và đẹp mắt anh nhé!', 'staff.vietanh', 'RESOLVED', '2026-08-28 10:15:00', '2026-08-28 10:15:00'),
(7, 27, N'Ngô Bích Ngọc', 'bichngoc.arc@gmail.com', '0965432109', N'Yêu cầu báo giá 10 bộ PC văn phòng kết hợp thiết kế đồ họa 2D Photoshop cho công ty kiến trúc', 'PRICE', N'Kính gửi bộ phận kinh doanh Luxury PC, công ty kiến trúc bên mình đang cần mua mới 10 dàn máy tính cho nhân viên thiết kế 2D AutoCad, Photoshop và Sketchup. Ngân sách khoảng 18-20 triệu/bộ (đã bao gồm màn hình 27 inch IPS). Nhờ công ty gửi bảng báo giá chính thức có hóa đơn VAT và chính sách bảo hành doanh nghiệp qua email bichngoc.arc@gmail.com giúp mình nhé.', N'Kính chào chị Bích Ngọc! Em đã nhận được yêu cầu của công ty mình. Luxury PC có chính sách chiết khấu 8% cho đơn hàng doanh nghiệp từ 10 bộ, hỗ trợ xuất hóa đơn VAT điện tử đầy đủ và gói bảo hành tận nơi 24/7 trong 24 tháng. Em sẽ hoàn thiện file báo giá chi tiết và gửi vào email của chị trong vòng 30 phút tới ạ!', 'staff.thuytien', 'OPEN', '2026-08-29 09:00:00', '2026-08-29 09:00:00'),
(8, 71, N'Dương Thị Lam', 'khachhang050@gmail.com', '0347084450', N'Hướng dẫn thủ tục trả góp 0% qua thẻ tín dụng và SePay chuyển khoản QR', 'ORDER', N'Mình muốn mua bộ PC 25 triệu và thanh toán trả góp 0% qua thẻ tín dụng Visa Techcombank kỳ hạn 12 tháng thì thủ tục như thế nào vậy shop?', N'Dạ chào chị Lam! Thủ tục trả góp qua thẻ tín dụng tại Luxury PC hoàn toàn online và duyệt tự động 100% không cần giấy tờ ạ. Tại bước thanh toán (Checkout), chị chọn phương thức ''Trả góp qua thẻ tín dụng'', chọn ngân hàng Techcombank và kỳ hạn 12 tháng, sau đó nhập thông tin thẻ là hoàn tất đơn hàng trong 1 phút thôi ạ!', 'staff.phuongthao', 'RESOLVED', '2026-08-30 14:00:00', '2026-08-30 14:00:00'),
(9, 28, N'Đỗ Minh Đức', 'minhduc.tech@gmail.com', '0912345678', N'Xin link tải phần mềm chỉnh LED RGB cho linh kiện ROG Strix và Corsair iCUE', 'TECHNICAL', N'Shop cho mình xin link chuẩn để tải phần mềm đồng bộ đèn LED cho main ASUS và RAM Corsair với ạ.', N'Dạ chào anh Đức! Để chỉnh LED cho Mainboard/VGA ASUS anh tải phần mềm ''ASUS Armoury Crate'' tại trang chủ asus.com. Còn đối với RAM/Fan Corsair anh tải phần mềm ''Corsair iCUE v5''. Hai phần mềm này có thể đồng bộ với nhau qua plugin Corsair ASUS Sync anh nhé!', 'staff.tuankiet', 'CLOSED', '2026-08-31 16:20:00', '2026-08-31 16:20:00'),
(10, 55, N'Huỳnh Đức Khoa', 'khachhang034@gmail.com', '0777610058', N'Khen ngợi bạn nhân viên kỹ thuật hỗ trợ lắp máy tại nhà rất nhiệt tình và chu đáo', 'GENERAL', N'Mình gửi ticket này để gửi lời cảm ơn đến Luxury PC và đặc biệt là bạn kỹ thuật viên Long sáng nay đã mang dàn PC đến tận nhà mình lắp đặt. Bạn làm việc rất cẩn thận, đi dây siêu đẹp và còn nhiệt tình hướng dẫn mình cách bảo quản vệ sinh máy. Dịch vụ bên bạn rất chuyên nghiệp 10/10 điểm!', N'Dạ em Long đây ạ! Em thay mặt toàn thể đội ngũ Luxury PC chân thành cảm ơn anh Khoa đã tin tưởng và dành những lời khen ngợi quý báu cho em. Chúc anh có những phút giây giải trí và làm việc thật tuyệt vời bên cỗ máy mới. Luxury PC xin gửi tặng anh 1 Voucher tri ân giảm 500.000đ cho lần mua sắm tiếp theo ạ!', 'staff.hoanglong', 'CLOSED', '2026-09-01 11:00:00', '2026-09-01 11:00:00');
SET IDENTITY_INSERT support_tickets OFF;
DBCC CHECKIDENT ('support_tickets', RESEED, 10);
GO

SET IDENTITY_INSERT ticket_messages ON;
INSERT INTO ticket_messages (id, ticket_id, sender, sender_name, message, created_at) VALUES

(1, 1, 'CUSTOMER', N'Nguyễn Tuấn Anh', N'Chào shop, mình có ngân sách khoảng 35 triệu, muốn build 1 case PC chuyên chơi game nặng như Black Myth Wukong, Cyberpunk và chuẩn bị cho GTA 6 ở màn hình 2K 165Hz. Nhờ shop tư vấn combo tối ưu nhất trong tầm giá giúp mình với ạ.', '2026-08-20 09:30:00'),
(2, 1, 'ADMIN', N'Lê Hoàng Long (Kỹ thuật viên)', N'Chào anh Tuấn Anh! Với ngân sách 35 triệu để chiến mượt 2K Ultra Settings, Luxury PC xin tư vấn anh cấu hình tối ưu nhất: CPU Intel Core i5-14600KF (14 nhân 20 luồng) + Card đồ họa RTX 4070 Super 12GB GDDR6X + 32GB RAM DDR5 Corsair 6000MHz + Nguồn 750W 80 Plus Gold + Tản nhiệt nước AIO 360mm. Cấu hình này test thực tế Wukong 2K đạt 90-110 FPS rất mượt mà anh nhé!', '2026-08-20 10:05:00'),
(3, 1, 'CUSTOMER', N'Nguyễn Tuấn Anh', N'Cấu hình này nhìn ưng quá shop ơi! Cho mình hỏi nguồn 750W có dư dả để sau này mình nâng cấp card lớn hơn không ạ? Và bên shop có hỗ trợ cài sẵn Windows với game test máy trước khi giao không?', '2026-08-20 10:20:00'),
(4, 1, 'ADMIN', N'Lê Hoàng Long (Kỹ thuật viên)', N'Dạ nguồn 750W chuẩn Gold gánh i5-14600KF + RTX 4070 Super chỉ ăn khoảng 450W nên dư dả tải rất mát anh nhé. Khi anh đặt máy, Luxury PC sẽ hỗ trợ lắp đặt, đi dây giấu gọn gàng, cài sẵn Windows 11 Pro bản quyền, tối ưu BIOS XMP và stress test 2 tiếng trước khi giao tận nhà ạ!', '2026-08-20 10:35:00'),
(5, 2, 'CUSTOMER', N'Trần Hoàng Nam', N'Hôm qua mình vừa nhận máy bên shop gửi, kiểm tra Task Manager thấy RAM đang hiển thị 4800MHz trong khi kit mình mua là 6000MHz. Shop hướng dẫn mình cách bật lên với ạ.', '2026-08-22 14:10:00'),
(6, 2, 'ADMIN', N'Đỗ Minh Đức (Kỹ thuật)', N'Dạ chào anh Nam, mặc định chuẩn DDR5 khi mới cắm sẽ nhận bus gốc 4800MHz để đảm bảo tương thích boot máy. Anh làm theo các bước sau giúp em nhé:
1. Khởi động lại máy, bấm liên tục phím DEL để vào BIOS.
2. Ở trang EzMode góc trái, anh tìm mục ''X.M.P'' chuyển từ Disabled sang ''XMP I'' hoặc ''Profile 1''.
3. Bấm phím F10 chọn ''Save & Exit'' là xong ạ!', '2026-08-22 14:25:00'),
(7, 2, 'CUSTOMER', N'Trần Hoàng Nam', N'Mình vừa làm theo và đã lên đúng 6000MHz rồi, máy khởi động nhanh và mượt hơn hẳn. Cảm ơn kỹ thuật viên đã hỗ trợ nhanh chóng nhé!', '2026-08-22 14:40:00'),
(8, 2, 'ADMIN', N'Đỗ Minh Đức (Kỹ thuật)', N'Dạ không có gì ạ! Chúc anh có những trải nghiệm tuyệt vời cùng bộ máy mới. Cần hỗ trợ thêm anh cứ nhắn lại ticket này nhé!', '2026-08-22 14:45:00'),
(9, 3, 'CUSTOMER', N'Đặng Trúc Hà', N'Shop ơi mình vừa đặt mua đơn hàng LXR2608230002 hôm qua, không biết hôm nay đã đóng gói và bàn giao cho đơn vị vận chuyển chưa ạ? Khoảng mấy giờ mình nhận được máy?', '2026-08-24 08:45:00'),
(10, 3, 'ADMIN', N'Trần Thị Thu Trang (CSKH)', N'Chào chị Trúc Hà! Em kiểm tra hệ thống thấy đơn hàng của chị đã được đội ngũ kỹ thuật lắp ráp hoàn tất và bàn giao cho shipper chuyên biệt của Luxury PC lúc 8h30 sáng nay. Dự kiến khoảng 14h - 15h chiều nay shipper sẽ liên hệ trước khi giao tới địa chỉ số 311 Võ Văn Kiệt của chị ạ.', '2026-08-24 09:05:00'),
(11, 3, 'CUSTOMER', N'Đặng Trúc Hà', N'Okie shop, chiều nay mình có nhà. Nhờ shipper gọi trước cho mình 15 phút nhé.', '2026-08-24 09:12:00'),
(12, 4, 'CUSTOMER', N'Lê Quốc Bảo', N'Shop cho mình hỏi xíu, mình đang dùng card RTX 4080 Super mới mua bên bạn, lúc bật máy lướt web xem Youtube thì thấy 3 quạt của card hoàn toàn không quay. Lúc chơi game thì quạt mới quay. Như vậy có phải card bị lỗi cảm biến nhiệt không shop?', '2026-08-25 11:20:00'),
(13, 4, 'ADMIN', N'Nguyễn Quang Huy (Kỹ thuật)', N'Dạ chào anh Bảo, anh hoàn toàn yên tâm nhé! Các dòng card cao cấp hiện nay của ASUS đều có công nghệ ''0dB Fan Tech''. Khi nhiệt độ GPU dưới 50-55 độ C (khi lướt web, làm việc nhẹ), quạt sẽ tự động dừng hoàn toàn để giữ im lặng tuyệt đối và tăng tuổi thọ trục bi. Khi anh vào game nặng nhiệt độ tăng lên quạt sẽ tự động quay làm mát ạ!', '2026-08-25 11:35:00'),
(14, 4, 'CUSTOMER', N'Lê Quốc Bảo', N'À ra là tính năng thông minh vậy à, mình cứ sợ bị kẹt quạt. Cảm ơn shop đã giải thích chi tiết!', '2026-08-25 11:42:00'),
(15, 5, 'CUSTOMER', N'Phan Trường Giang', N'Xin chào Luxury PC, mình là kỹ sư AI đang cần build 1 bộ máy workstation chuyên dụng để chạy fine-tune các model LLM local (DeepSeek, Llama 3) và render mô hình 3D Blender. Ngân sách tầm 70-80 triệu, ưu tiên VRAM GPU lớn từ 24GB trở lên và RAM hệ thống tối thiểu 64GB. Nhờ shop lên cấu hình giúp.', '2026-08-27 15:30:00'),
(16, 5, 'ADMIN', N'Trương Gia Huỳnh (Workstation Specialist)', N'Chào anh Giang! Đối với nhu cầu train/inference LLM và Render 3D nặng, cấu hình đề xuất chuẩn trạm cho anh gồm:
- CPU: Intel Core Ultra 9 285K (24 nhân 24 luồng, đơn nhân cực mạnh)
- Mainboard: ASUS ROG STRIX Z890-F GAMING WIFI
- RAM: 64GB (2x32GB) DDR5 Corsair Dominator Titanium 6400MHz
- VGA: MSI GeForce RTX 4090 24GB GDDR6X Gaming X Trio
- SSD: 2TB Samsung 990 PRO Gen4x4 (Đọc 7450MB/s nạp tensor siêu nhanh)
- Nguồn: Corsair RM1000e 1000W 80 Plus Gold ATX 3.0
- Tản nhiệt nước: Corsair Nautilus 360 RS ARGB.
Tổng cấu hình khoảng 78.5 triệu, bên em có sẵn hàng để lắp ráp ngay cho anh ạ!', '2026-08-27 16:00:00'),
(17, 6, 'CUSTOMER', N'Võ Tấn Phát', N'Shop cho mình hỏi case Corsair 3500X TG kính cường lực mình muốn lắp tản nước AIO 360mm ở nóc case và cắm card RTX 4080 dài 34cm thì có bị cấn không shop?', '2026-08-28 10:15:00'),
(18, 6, 'ADMIN', N'Hoàng Việt Anh (Kỹ thuật)', N'Dạ chào anh Phát! Case Corsair 3500X được thiết kế khoang nóc rất thoáng, hỗ trợ hoàn hảo tản nước Rad 360mm dày tới 65mm (cả quạt) mà không hề cấn vào tản nhôm VRM mainboard. Chiều dài card VGA case hỗ trợ lên tới 410mm nên card RTX 4080 34cm lắp vào cực kỳ rộng rãi và đẹp mắt anh nhé!', '2026-08-28 10:30:00'),
(19, 7, 'CUSTOMER', N'Ngô Bích Ngọc', N'Kính gửi bộ phận kinh doanh Luxury PC, công ty kiến trúc bên mình đang cần mua mới 10 dàn máy tính cho nhân viên thiết kế 2D AutoCad, Photoshop và Sketchup. Ngân sách khoảng 18-20 triệu/bộ (đã bao gồm màn hình 27 inch IPS). Nhờ công ty gửi bảng báo giá chính thức có hóa đơn VAT và chính sách bảo hành doanh nghiệp qua email bichngoc.arc@gmail.com giúp mình nhé.', '2026-08-29 09:00:00'),
(20, 7, 'ADMIN', N'Vũ Thủy Tiên (Kinh doanh Doanh nghiệp)', N'Kính chào chị Bích Ngọc! Em đã nhận được yêu cầu của công ty mình. Luxury PC có chính sách chiết khấu 8% cho đơn hàng doanh nghiệp từ 10 bộ, hỗ trợ xuất hóa đơn VAT điện tử đầy đủ và gói bảo hành tận nơi 24/7 trong 24 tháng. Em sẽ hoàn thiện file báo giá chi tiết và gửi vào email của chị trong vòng 30 phút tới ạ!', '2026-08-29 09:25:00'),
(21, 8, 'CUSTOMER', N'Dương Thị Lam', N'Mình muốn mua bộ PC 25 triệu và thanh toán trả góp 0% qua thẻ tín dụng Visa Techcombank kỳ hạn 12 tháng thì thủ tục như thế nào vậy shop?', '2026-08-30 14:00:00'),
(22, 8, 'ADMIN', N'Bùi Phương Thảo (Tư vấn viên)', N'Dạ chào chị Lam! Thủ tục trả góp qua thẻ tín dụng tại Luxury PC hoàn toàn online và duyệt tự động 100% không cần giấy tờ ạ. Tại bước thanh toán (Checkout), chị chọn phương thức ''Trả góp qua thẻ tín dụng'', chọn ngân hàng Techcombank và kỳ hạn 12 tháng, sau đó nhập thông tin thẻ là hoàn tất đơn hàng trong 1 phút thôi ạ!', '2026-08-30 14:15:00'),
(23, 8, 'CUSTOMER', N'Dương Thị Lam', N'Dạ tiện lợi quá, mình vừa hoàn tất đơn hàng rồi, shop kiểm tra đơn giúp mình nhé!', '2026-08-30 14:28:00'),
(24, 9, 'CUSTOMER', N'Đỗ Minh Đức', N'Shop cho mình xin link chuẩn để tải phần mềm đồng bộ đèn LED cho main ASUS và RAM Corsair với ạ.', '2026-08-31 16:20:00'),
(25, 9, 'ADMIN', N'Đặng Tuấn Kiệt (Kỹ thuật)', N'Dạ chào anh Đức! Để chỉnh LED cho Mainboard/VGA ASUS anh tải phần mềm ''ASUS Armoury Crate'' tại trang chủ asus.com. Còn đối với RAM/Fan Corsair anh tải phần mềm ''Corsair iCUE v5''. Hai phần mềm này có thể đồng bộ với nhau qua plugin Corsair ASUS Sync anh nhé!', '2026-08-31 16:35:00'),
(26, 9, 'CUSTOMER', N'Đỗ Minh Đức', N'Cảm ơn kỹ thuật viên đã hướng dẫn tận tình, mình chỉnh xong đồng bộ màu tím cyberpunk đẹp lắm rồi!', '2026-08-31 16:50:00'),
(27, 10, 'CUSTOMER', N'Huỳnh Đức Khoa', N'Mình gửi ticket này để gửi lời cảm ơn đến Luxury PC và đặc biệt là bạn kỹ thuật viên Long sáng nay đã mang dàn PC đến tận nhà mình lắp đặt. Bạn làm việc rất cẩn thận, đi dây siêu đẹp và còn nhiệt tình hướng dẫn mình cách bảo quản vệ sinh máy. Dịch vụ bên bạn rất chuyên nghiệp 10/10 điểm!', '2026-09-01 11:00:00'),
(28, 10, 'ADMIN', N'Lê Hoàng Long (Kỹ thuật viên)', N'Dạ em Long đây ạ! Em thay mặt toàn thể đội ngũ Luxury PC chân thành cảm ơn anh Khoa đã tin tưởng và dành những lời khen ngợi quý báu cho em. Chúc anh có những phút giây giải trí và làm việc thật tuyệt vời bên cỗ máy mới. Luxury PC xin gửi tặng anh 1 Voucher tri ân giảm 500.000đ cho lần mua sắm tiếp theo ạ!', '2026-09-01 11:20:00');
SET IDENTITY_INSERT ticket_messages OFF;
DBCC CHECKIDENT ('ticket_messages', RESEED, 28);
GO