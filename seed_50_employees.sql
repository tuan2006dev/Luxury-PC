-- ============================================================================
-- LUXURY PC - SEED DATA: 50 REALISTIC EMPLOYEES (NHÂN VIÊN - ROLE 'STAFF')
-- Database: SQL Server (luxpcc / LUXURYPC)
-- Mật khẩu mặc định cho toàn bộ nhân viên: 123456 (BCrypt encoded)
-- ============================================================================

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

-- 1. ĐẢM BẢO ROLE 'STAFF' TỒN TẠI
IF NOT EXISTS (SELECT 1 FROM roles WHERE name = 'STAFF')
BEGIN
    INSERT INTO roles (name) VALUES ('STAFF');
END
GO

-- 2. KHỞI TẠO BIẾN LẤY ID ROLE STAFF
DECLARE @StaffRoleId INT;
SELECT @StaffRoleId = id FROM roles WHERE name = 'STAFF';

-- 3. INSERT 50 NHÂN VIÊN VỚI THÔNG TIN CHUẨN THỰC TẾ
DECLARE @UsersToInsert TABLE (
    username VARCHAR(100),
    email VARCHAR(100),
    password VARCHAR(255),
    full_name NVARCHAR(100),
    phone VARCHAR(20),
    address NVARCHAR(255),
    avatar VARCHAR(255),
    birthday DATETIME,
    gender BIT,
    status BIT,
    created_at DATETIME
);

INSERT INTO @UsersToInsert (username, email, password, full_name, phone, address, avatar, birthday, gender, status, created_at) VALUES
-- Khu vực Hà Nội (Showroom Thái Hà, Cầu Giấy, Hai Bà Trưng)
('staff.hoanglong', 'hoanglong.luxury@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lê Hoàng Long', '0988123456', N'Số 121 Thái Hà, Phường Trung Liệt, Quận Đống Đa, Hà Nội', '/uploads/avatars/user_1.webp', '1995-04-12', 1, 1, '2026-01-15 08:30:00'),
('staff.thutrang', 'thutrang.luxury@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Thị Thu Trang', '0975234567', N'Số 45 Chùa Bộc, Phường Quang Trung, Quận Đống Đa, Hà Nội', '/uploads/avatars/user_2.webp', '1998-09-20', 0, 1, '2026-01-18 09:15:00'),
('staff.minhduc', 'minhduc.tech@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đỗ Minh Đức', '0912345678', N'Số 68 Cầu Giấy, Phường Quan Hoa, Quận Cầu Giấy, Hà Nội', '/uploads/avatars/user_3.webp', '1996-11-05', 1, 1, '2026-02-01 10:00:00'),
('staff.ngocmai', 'ngocmai.luxurypc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phạm Ngọc Mai', '0934567890', N'Số 165 Xuân Thủy, Phường Dịch Vọng Hậu, Quận Cầu Giấy, Hà Nội', '/uploads/avatars/user_4.webp', '2000-03-14', 0, 1, '2026-02-10 14:20:00'),
('staff.tuankiet', 'tuankiet.pc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đặng Tuấn Kiệt', '0903456781', N'Số 88 Phố Huế, Phường Hàng Bài, Quận Hoàn Kiếm, Hà Nội', '/uploads/avatars/user_5.webp', '1994-07-28', 1, 1, '2026-02-15 11:45:00'),
('staff.phuongthao', 'phuongthao.sales@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bùi Phương Thảo', '0945678902', N'Số 210 Xã Đàn, Phường Nam Đồng, Quận Đống Đa, Hà Nội', '/uploads/avatars/user_6.webp', '1999-12-08', 0, 1, '2026-02-20 08:00:00'),
('staff.quanghuy', 'quanghuy.buildpc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Nguyễn Quang Huy', '0967890123', N'Số 32 Hoàng Cầu, Phường Ô Chợ Dừa, Quận Đống Đa, Hà Nội', '/uploads/avatars/user_7.webp', '1997-05-19', 1, 1, '2026-03-01 13:30:00'),
('staff.haidang', 'haidang.support@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Vũ Hải Đăng', '0981234599', N'Số 15 Lê Văn Lương, Phường Nhân Chính, Quận Thanh Xuân, Hà Nội', '/uploads/avatars/user_8.webp', '1996-08-22', 1, 1, '2026-03-05 09:10:00'),
('staff.khanhhuyen', 'khanhhuyen.luxury@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đinh Khánh Huyền', '0978901234', N'Số 52 Trần Thái Tông, Phường Dịch Vọng Hậu, Quận Cầu Giấy, Hà Nội', '/uploads/avatars/user_9.webp', '2001-10-30', 0, 1, '2026-03-12 16:40:00'),
('staff.anhquan', 'anhquan.itpc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Võ Anh Quân', '0919876543', N'Số 79 Lạc Long Quân, Phường Nghĩa Đô, Quận Cầu Giấy, Hà Nội', '/uploads/avatars/user_10.webp', '1993-01-25', 1, 1, '2026-03-18 10:25:00'),
('staff.myduyen', 'myduyen.care@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lý Mỹ Duyên', '0938765432', N'Số 102 Bà Triệu, Phường Hàng Bài, Quận Hoàn Kiếm, Hà Nội', '/uploads/avatars/user_11.webp', '1998-06-17', 0, 1, '2026-03-25 08:45:00'),
('staff.thanhson', 'thanhson.gaming@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hoàng Thanh Sơn', '0909876543', N'Số 250 Giải Phóng, Phường Phương Liệt, Quận Thanh Xuân, Hà Nội', '/uploads/avatars/user_12.webp', '1995-12-03', 1, 1, '2026-04-02 15:15:00'),

-- Khu vực TP. Hồ Chí Minh (Showroom Quận 1, Quận 10, TP. Thủ Đức)
('staff.giahuynh', 'giahuynh.luxury@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trương Gia Huỳnh', '0943210987', N'Số 182 Bùi Thị Xuân, Phường Phạm Ngũ Lão, Quận 1, TP. Hồ Chí Minh', '/uploads/avatars/user_13.webp', '1994-08-14', 1, 1, '2026-04-08 09:00:00'),
('staff.bichngoc', 'bichngoc.hcm@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Ngô Bích Ngọc', '0965432109', N'Số 386 Võ Văn Tần, Phường 5, Quận 3, TP. Hồ Chí Minh', '/uploads/avatars/user_14.webp', '1997-02-27', 0, 1, '2026-04-15 14:00:00'),
('staff.truonggiang', 'truonggiang.tech@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phan Trường Giang', '0987654321', N'Số 280 Nguyễn Đình Chiểu, Phường 6, Quận 3, TP. Hồ Chí Minh', '/uploads/avatars/user_15.webp', '1992-11-11', 1, 1, '2026-04-20 11:10:00'),
('staff.hoangyen', 'hoangyen.luxurypc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Dương Hoàng Yến', '0976543210', N'Số 543 Cách Mạng Tháng 8, Phường 15, Quận 10, TP. Hồ Chí Minh', '/uploads/avatars/user_16.webp', '2000-09-09', 0, 1, '2026-04-26 16:30:00'),
('staff.quocbao', 'quocbao.pcbuilder@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lê Quốc Bảo', '0918765432', N'Số 120 Thành Thái, Phường 12, Quận 10, TP. Hồ Chí Minh', '/uploads/avatars/user_17.webp', '1996-03-31', 1, 1, '2026-05-02 08:20:00'),
('staff.thuytien', 'thuytien.sales@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Vũ Thủy Tiên', '0932109876', N'Số 89 Sư Vạn Hạnh, Phường 12, Quận 10, TP. Hồ Chí Minh', '/uploads/avatars/user_18.webp', '1999-07-15', 0, 1, '2026-05-08 10:40:00'),
('staff.minhtri', 'minhtri.support@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Nguyễn Minh Trí', '0901234567', N'Số 175 Phan Xích Long, Phường 2, Quận Phú Nhuận, TP. Hồ Chí Minh', '/uploads/avatars/user_19.webp', '1995-10-04', 1, 1, '2026-05-15 13:50:00'),
('staff.kimngan', 'kimngan.hcm@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Kim Ngân', '0945678123', N'Số 420 Nguyễn Oanh, Phường 6, Quận Gò Vấp, TP. Hồ Chí Minh', '/uploads/avatars/user_20.webp', '2002-01-18', 0, 1, '2026-05-22 09:15:00'),
('staff.duynam', 'duynam.custompc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bùi Duy Nam', '0967891234', N'Số 65 Quang Trung, Phường 10, Quận Gò Vấp, TP. Hồ Chí Minh', '/uploads/avatars/user_1.webp', '1997-04-05', 1, 1, '2026-05-28 15:25:00'),
('staff.khanhvy', 'khanhvy.luxury@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hồ Khánh Vy', '0989012345', N'Số 215 Hoàng Văn Thụ, Phường 8, Quận Phú Nhuận, TP. Hồ Chí Minh', '/uploads/avatars/user_2.webp', '1998-11-21', 0, 1, '2026-06-03 08:35:00'),
('staff.hoangphat', 'hoangphat.work@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đặng Hoàng Phát', '0970123456', N'Số 12 Võ Văn Ngân, Phường Linh Chiểu, TP. Thủ Đức, TP. Hồ Chí Minh', '/uploads/avatars/user_3.webp', '1993-06-19', 1, 1, '2026-06-10 11:05:00'),
('staff.thanhhuyen', 'thanhhuyen.nv@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phạm Thanh Huyền', '0910987654', N'Tòa Landmark 2, Vinhomes Central Park, Phường 22, Quận Bình Thạnh, TP. Hồ Chí Minh', '/uploads/avatars/user_4.webp', '2001-05-12', 0, 1, '2026-06-16 14:45:00'),

-- Khu vực Đà Nẵng & Miền Trung
('staff.dinhphong', 'dinhphong.danang@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Đình Phong', '0935123456', N'Số 68 Nguyễn Văn Linh, Phường Nam Dương, Quận Hải Châu, Đà Nẵng', '/uploads/avatars/user_5.webp', '1996-02-14', 1, 1, '2026-06-20 09:20:00'),
('staff.maianh', 'maianh.danang@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lê Mai Anh', '0905234567', N'Số 125 Lê Duẩn, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng', '/uploads/avatars/user_6.webp', '1999-08-03', 0, 1, '2026-06-25 10:50:00'),
('staff.vankhai', 'vankhai.tech@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Nguyễn Văn Khải', '0914345678', N'Số 234 Điện Biên Phủ, Phường Chính Gián, Quận Thanh Khê, Đà Nẵng', '/uploads/avatars/user_7.webp', '1994-12-25', 1, 1, '2026-07-01 13:10:00'),
('staff.nhuquynh', 'nhuquynh.lux@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hoàng Như Quỳnh', '0947567890', N'Số 56 Bạch Đằng, Phường Hải Châu 1, Quận Hải Châu, Đà Nẵng', '/uploads/avatars/user_8.webp', '2000-04-16', 0, 1, '2026-07-05 08:00:00'),
('staff.congthanh', 'congthanh.dng@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Võ Công Thành', '0968678901', N'Số 89 Hàm Nghi, Phường Vĩnh Trung, Quận Thanh Khê, Đà Nẵng', '/uploads/avatars/user_9.webp', '1995-07-07', 1, 1, '2026-07-10 16:15:00'),
('staff.hongnhung', 'hongnhung.sales@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đỗ Hồng Nhung', '0983789012', N'Số 112 Hùng Vương, Phường Hải Châu 2, Quận Hải Châu, Đà Nẵng', '/uploads/avatars/user_10.webp', '1997-09-29', 0, 1, '2026-07-15 11:30:00'),

-- Khu vực Hải Phòng, Quảng Ninh, Cần Thơ, Bình Dương & Các tỉnh thành
('staff.trungdung', 'trungdung.haiphong@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phạm Trung Dũng', '0936890123', N'Số 150 Lạch Tray, Phường Lạch Tray, Quận Ngô Quyền, Hải Phòng', '/uploads/avatars/user_11.webp', '1996-05-18', 1, 1, '2026-07-20 09:40:00'),
('staff.camtu', 'camtu.hp@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bùi Cẩm Tú', '0904901234', N'Số 88 Lê Lợi, Phường Máy Tơ, Quận Ngô Quyền, Hải Phòng', '/uploads/avatars/user_12.webp', '2001-08-11', 0, 1, '2026-07-25 14:10:00'),
('staff.huunghia', 'huunghia.cantho@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Hữu Nghĩa', '0939012345', N'Số 75 Đường 30 Tháng 4, Phường An Lạc, Quận Ninh Kiều, Cần Thơ', '/uploads/avatars/user_13.webp', '1994-03-22', 1, 1, '2026-07-28 10:20:00'),
('staff.nguyenha', 'nguyenha.ct@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lê Thị Nguyên Hà', '0979123456', N'Số 42 Đại Lộ Hòa Bình, Phường Tân An, Quận Ninh Kiều, Cần Thơ', '/uploads/avatars/user_14.webp', '1999-11-19', 0, 1, '2026-08-01 08:50:00'),
('staff.quangvinh', 'quangvinh.binhduong@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Vũ Quang Vinh', '0913234567', N'Số 230 Đại Lộ Bình Dương, Phường Phú Hòa, TP. Thủ Dầu Một, Bình Dương', '/uploads/avatars/user_15.webp', '1995-10-10', 1, 1, '2026-08-05 15:00:00'),
('staff.minhanh', 'minhanh.bd@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đặng Minh Ánh', '0942345678', N'Số 56 Yersin, Phường Hiệp Thành, TP. Thủ Dầu Một, Bình Dương', '/uploads/avatars/user_16.webp', '2002-07-04', 0, 1, '2026-08-08 13:40:00'),

-- Kỹ thuật viên Lắp ráp & Bảo hành Phần cứng (Hardware & Custom Watercooling Specialists)
('staff.tuanvu', 'tuanvu.watercooling@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Nguyễn Tuấn Vũ', '0962456789', N'Số 18 Ngõ 198 Thái Hà, Phường Trung Liệt, Quận Đống Đa, Hà Nội', '/uploads/avatars/user_17.webp', '1993-02-17', 1, 1, '2026-08-10 09:30:00'),
('staff.xuanhai', 'xuanhai.pcmod@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phan Xuân Hải', '0984567890', N'Số 49 Nguyễn Khang, Phường Yên Hòa, Quận Cầu Giấy, Hà Nội', '/uploads/avatars/user_18.webp', '1996-09-13', 1, 1, '2026-08-12 11:20:00'),
('staff.minhphuong', 'minhphuong.warranty@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trịnh Minh Phương', '0973678901', N'Số 310 Đường 3/2, Phường 12, Quận 10, TP. Hồ Chí Minh', '/uploads/avatars/user_19.webp', '1998-04-24', 0, 1, '2026-08-15 14:15:00'),
('staff.duchoang', 'duchoang.hardware@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lê Đức Hoàng', '0915789012', N'Số 86 Nguyễn Trãi, Phường Bến Thành, Quận 1, TP. Hồ Chí Minh', '/uploads/avatars/user_20.webp', '1992-06-30', 1, 1, '2026-08-18 10:05:00'),
('staff.baochau', 'baochau.qa@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hồ Bảo Châu', '0933890123', N'Số 72 Trần Nhân Tông, Phường Nguyễn Du, Quận Hai Bà Trưng, Hà Nội', '/uploads/avatars/user_1.webp', '2000-01-09', 0, 1, '2026-08-20 16:00:00'),
('staff.theanh', 'theanh.network@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đinh Thế Anh', '0902901234', N'Số 144 Nam Kỳ Khởi Nghĩa, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh', '/uploads/avatars/user_2.webp', '1994-11-28', 1, 1, '2026-08-22 08:40:00'),
('staff.kimthoa', 'kimthoa.luxurypc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bùi Kim Thoa', '0946012345', N'Số 390 Lê Văn Sỹ, Phường 14, Quận 3, TP. Hồ Chí Minh', '/uploads/avatars/user_3.webp', '1997-03-08', 0, 1, '2026-08-25 13:25:00'),
('staff.quangkhai', 'quangkhai.oc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Nguyễn Quang Khải', '0968123456', N'Số 220 Lạc Trung, Phường Vĩnh Tuy, Quận Hai Bà Trưng, Hà Nội', '/uploads/avatars/user_4.webp', '1995-08-16', 1, 1, '2026-08-26 15:45:00'),
('staff.ngoctram', 'ngoctram.service@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Ngọc Trâm', '0981234888', N'Số 98 Hoàng Văn Thụ, Phường 9, Quận Phú Nhuận, TP. Hồ Chí Minh', '/uploads/avatars/user_5.webp', '2001-12-14', 0, 1, '2026-08-28 09:10:00'),
('staff.vietthang', 'vietthang.gaming@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phạm Việt Thắng', '0972345999', N'Số 114 Lê Thanh Nghị, Phường Bách Khoa, Quận Hai Bà Trưng, Hà Nội', '/uploads/avatars/user_6.webp', '1996-01-22', 1, 1, '2026-08-29 10:35:00'),
('staff.lanhuong', 'lanhuong.advisor@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Vũ Lan Hương', '0913456111', N'Số 63 Trần Hưng Đạo, Phường Phan Chu Trinh, Quận Hoàn Kiếm, Hà Nội', '/uploads/avatars/user_7.webp', '1999-05-06', 0, 1, '2026-08-30 11:50:00'),

-- 3 Nhân viên trạng thái TẠM KHÓA (status = 0) để phục vụ test tính năng Khóa / Mở khóa tài khoản nhân viên
('staff.dangkhoa', 'dangkhoa.pc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Nguyễn Đăng Khoa', '0938123777', N'Số 19 Đường số 9, Phường Linh Tây, TP. Thủ Đức, TP. Hồ Chí Minh', '/uploads/avatars/user_8.webp', '1995-03-15', 1, 0, '2026-06-01 09:00:00'),
('staff.thuha', 'thuha.lux@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Thu Hà', '0908234888', N'Số 57 Huỳnh Thúc Kháng, Phường Láng Hạ, Quận Đống Đa, Hà Nội', '/uploads/avatars/user_9.webp', '1997-07-20', 0, 0, '2026-06-15 14:00:00'),
('staff.thanhdat', 'thanhdat.hardware@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lê Thành Đạt', '0949345999', N'Số 142 Nguyễn Trãi, Phường 3, Quận 5, TP. Hồ Chí Minh', '/uploads/avatars/user_10.webp', '1998-10-10', 1, 0, '2026-07-01 10:30:00');

-- 4. INSERT VÀO BẢNG USERS (NẾU CHƯA TỒN TẠI USERNAME/EMAIL)
INSERT INTO users (
    username, 
    email, 
    password, 
    full_name, 
    phone, 
    address, 
    avatar, 
    birthday, 
    gender, 
    status, 
    created_at,
    auth_provider,
    notify_flash_sale,
    notify_new_products,
    notify_order_updates,
    notify_weekly_newsletter,
    two_factor_enabled,
    force_change_password
)
SELECT 
    t.username, 
    t.email, 
    t.password, 
    t.full_name, 
    t.phone, 
    t.address, 
    t.avatar, 
    t.birthday, 
    t.gender, 
    t.status, 
    t.created_at,
    'LOCAL',
    1,
    1,
    1,
    1,
    0,
    0
FROM @UsersToInsert t
WHERE NOT EXISTS (
    SELECT 1 FROM users u WHERE u.username = t.username OR u.email = t.email
);

-- 5. GÁN QUYỀN (ROLE 'STAFF') VÀO BẢNG USER_ROLES CHO TOÀN BỘ 50 NHÂN VIÊN VỪA TẠO
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, @StaffRoleId
FROM users u
INNER JOIN @UsersToInsert t ON u.username = t.username
WHERE NOT EXISTS (
    SELECT 1 FROM user_roles ur WHERE ur.user_id = u.id AND ur.role_id = @StaffRoleId
);

-- 6. KIỂM TRA LẠI KẾT QUẢ
SELECT 
    u.id, 
    u.username, 
    u.full_name, 
    u.email, 
    u.phone, 
    u.gender, 
    u.status, 
    r.name AS role_name, 
    u.created_at
FROM users u
JOIN user_roles ur ON u.id = ur.user_id
JOIN roles r ON ur.role_id = r.id
WHERE r.name = 'STAFF'
ORDER BY u.id ASC;
GO
