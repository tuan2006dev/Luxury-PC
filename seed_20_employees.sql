-- ============================================================================
-- LUXURY PC - SEED DATA: 20 REALISTIC EMPLOYEES (NHÂN VIÊN - ROLE 'STAFF')
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

-- 2. DỌN DẸP TOÀN BỘ CÁC TÀI KHOẢN STAFF TEST CŨ (STAFF.%)
DECLARE @StaffRoleId INT;
SELECT @StaffRoleId = id FROM roles WHERE name = 'STAFF';

DELETE FROM user_roles 
WHERE role_id = @StaffRoleId 
  AND user_id IN (SELECT id FROM users WHERE username LIKE 'staff.%');

DELETE FROM users 
WHERE username LIKE 'staff.%';
GO

DECLARE @StaffRoleId INT;
SELECT @StaffRoleId = id FROM roles WHERE name = 'STAFF';

-- 3. KHỞI TẠO BẢNG TẠM CHỨA ĐÚNG 20 NHÂN VIÊN CHẤT LƯỢNG & CHUẨN THỰC TẾ
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
-- 1. Trưởng nhóm Bán hàng - Hà Nội
('staff.hoanglong', 'hoanglong.luxury@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lê Hoàng Long', '0988123456', N'Số 121 Thái Hà, Phường Trung Liệt, Quận Đống Đa, Hà Nội', '/uploads/avatars/user_1.webp', '1995-04-12', 1, 1, '2026-01-15 08:30:00'),

-- 2. Chuyên viên Tư vấn & CSKH - Hà Nội
('staff.thutrang', 'thutrang.luxury@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Thị Thu Trang', '0975234567', N'Số 45 Chùa Bộc, Phường Quang Trung, Quận Đống Đa, Hà Nội', '/uploads/avatars/user_2.webp', '1998-09-20', 0, 1, '2026-01-18 09:15:00'),

-- 3. Kỹ thuật viên Lắp ráp Custom PC - Hà Nội
('staff.minhduc', 'minhduc.tech@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Đỗ Minh Đức', '0912345678', N'Số 68 Cầu Giấy, Phường Quan Hoa, Quận Cầu Giấy, Hà Nội', '/uploads/avatars/user_3.webp', '1996-11-05', 1, 1, '2026-02-01 10:00:00'),

-- 4. Thu ngân & Quản lý Kho - Hà Nội
('staff.ngocmai', 'ngocmai.luxurypc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phạm Ngọc Mai', '0934567890', N'Số 165 Xuân Thủy, Phường Dịch Vọng Hậu, Quận Cầu Giấy, Hà Nội', '/uploads/avatars/user_4.webp', '2000-03-14', 0, 1, '2026-02-10 14:20:00'),

-- 5. Kỹ thuật viên Tản nhiệt nước Custom Watercooling - Hà Nội
('staff.quanghuy', 'quanghuy.buildpc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Nguyễn Quang Huy', '0967890123', N'Số 32 Hoàng Cầu, Phường Ô Chợ Dừa, Quận Đống Đa, Hà Nội', '/uploads/avatars/user_5.webp', '1997-05-19', 1, 1, '2026-03-01 13:30:00'),

-- 6. Hỗ trợ Kỹ thuật & Live Chat - Hà Nội
('staff.haidang', 'haidang.support@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Vũ Hải Đăng', '0981234599', N'Số 15 Lê Văn Lương, Phường Nhân Chính, Quận Thanh Xuân, Hà Nội', '/uploads/avatars/user_6.webp', '1996-08-22', 1, 1, '2026-03-05 09:10:00'),

-- 7. Tư vấn Cấu hình Gaming & Đồ họa - Hà Nội
('staff.phuongthao', 'phuongthao.sales@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bùi Phương Thảo', '0945678902', N'Số 210 Xã Đàn, Phường Nam Đồng, Quận Đống Đa, Hà Nội', '/uploads/avatars/user_7.webp', '1999-12-08', 0, 1, '2026-03-15 08:00:00'),

-- 8. Quản lý Showroom & Bán hàng - TP. Hồ Chí Minh
('staff.giahuynh', 'giahuynh.luxury@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trương Gia Huỳnh', '0943210987', N'Số 182 Bùi Thị Xuân, Phường Phạm Ngũ Lão, Quận 1, TP. Hồ Chí Minh', '/uploads/avatars/user_8.webp', '1994-08-14', 1, 1, '2026-04-08 09:00:00'),

-- 9. Chuyên viên Tư vấn Workstation & Render - TP. Hồ Chí Minh
('staff.bichngoc', 'bichngoc.hcm@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Ngô Bích Ngọc', '0965432109', N'Số 386 Võ Văn Tần, Phường 5, Quận 3, TP. Hồ Chí Minh', '/uploads/avatars/user_9.webp', '1997-02-27', 0, 1, '2026-04-15 14:00:00'),

-- 10. Trưởng nhóm Kỹ thuật Lắp ráp - TP. Hồ Chí Minh
('staff.quocbao', 'quocbao.pcbuilder@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lê Quốc Bảo', '0918765432', N'Số 120 Thành Thái, Phường 12, Quận 10, TP. Hồ Chí Minh', '/uploads/avatars/user_10.webp', '1996-03-31', 1, 1, '2026-05-02 08:20:00'),

-- 11. Kỹ thuật viên Bảo hành Phần cứng - TP. Hồ Chí Minh
('staff.minhtri', 'minhtri.support@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Nguyễn Minh Trí', '0901234567', N'Số 175 Phan Xích Long, Phường 2, Quận Phú Nhuận, TP. Hồ Chí Minh', '/uploads/avatars/user_11.webp', '1995-10-04', 1, 1, '2026-05-15 13:50:00'),

-- 12. Tư vấn Bán lẻ & Phụ kiện Gaming - TP. Hồ Chí Minh
('staff.thuytien', 'thuytien.sales@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Vũ Thủy Tiên', '0932109876', N'Số 89 Sư Vạn Hạnh, Phường 12, Quận 10, TP. Hồ Chí Minh', '/uploads/avatars/user_12.webp', '1999-07-15', 0, 1, '2026-05-20 10:40:00'),

-- 13. Kỹ thuật viên Modding & Overclocking - TP. Hồ Chí Minh
('staff.duynam', 'duynam.custompc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Bùi Duy Nam', '0967891234', N'Số 65 Quang Trung, Phường 10, Quận Gò Vấp, TP. Hồ Chí Minh', '/uploads/avatars/user_13.webp', '1997-04-05', 1, 1, '2026-05-28 15:25:00'),

-- 14. Quản lý Đơn hàng Online & Vận chuyển - TP. Hồ Chí Minh
('staff.khanhvy', 'khanhvy.luxury@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Hồ Khánh Vy', '0989012345', N'Số 215 Hoàng Văn Thụ, Phường 8, Quận Phú Nhuận, TP. Hồ Chí Minh', '/uploads/avatars/user_14.webp', '1998-11-21', 0, 1, '2026-06-03 08:35:00'),

-- 15. Trưởng chi nhánh Showroom - Đà Nẵng
('staff.dinhphong', 'dinhphong.danang@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Đình Phong', '0935123456', N'Số 68 Nguyễn Văn Linh, Phường Nam Dương, Quận Hải Châu, Đà Nẵng', '/uploads/avatars/user_15.webp', '1996-02-14', 1, 1, '2026-06-20 09:20:00'),

-- 16. Kỹ thuật viên & Tư vấn bán hàng - Đà Nẵng
('staff.maianh', 'maianh.danang@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Lê Mai Anh', '0905234567', N'Số 125 Lê Duẩn, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng', '/uploads/avatars/user_16.webp', '1999-08-03', 0, 1, '2026-06-25 10:50:00'),

-- 17. Quản lý Chi nhánh & Kỹ thuật - Hải Phòng
('staff.trungdung', 'trungdung.haiphong@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Phạm Trung Dũng', '0936890123', N'Số 150 Lạch Tray, Phường Lạch Tray, Quận Ngô Quyền, Hải Phòng', '/uploads/avatars/user_17.webp', '1996-05-18', 1, 1, '2026-07-20 09:40:00'),

-- 18. Quản lý Chi nhánh & Kỹ thuật - Cần Thơ
('staff.huunghia', 'huunghia.cantho@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Hữu Nghĩa', '0939012345', N'Số 75 Đường 30 Tháng 4, Phường An Lạc, Quận Ninh Kiều, Cần Thơ', '/uploads/avatars/user_18.webp', '1994-03-22', 1, 1, '2026-07-28 10:20:00'),

-- 19. Nhân viên Tạm khóa (status = 0) để Test tính năng Quản lý Admin
('staff.dangkhoa', 'dangkhoa.pc@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Nguyễn Đăng Khoa', '0938123777', N'Số 19 Đường số 9, Phường Linh Tây, TP. Thủ Đức, TP. Hồ Chí Minh', '/uploads/avatars/user_19.webp', '1995-03-15', 1, 0, '2026-06-01 09:00:00'),

-- 20. Nhân viên Tạm khóa (status = 0) để Test tính năng Quản lý Admin
('staff.thuha', 'thuha.lux@gmail.com', '$2a$10$OEwvbrxnyov9V2sOqq9CvOkvJ5QQqPehUz.w5r4r24eatIAJIRGn2', N'Trần Thu Hà', '0908234888', N'Số 57 Huỳnh Thúc Kháng, Phường Láng Hạ, Quận Đống Đa, Hà Nội', '/uploads/avatars/user_20.webp', '1997-07-20', 0, 0, '2026-06-15 14:00:00');

-- 4. INSERT VÀO BẢNG USERS
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
FROM @UsersToInsert t;

-- 5. GÁN ROLE 'STAFF' TRONG USER_ROLES CHO TOÀN BỘ 20 NHÂN VIÊN
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, @StaffRoleId
FROM users u
INNER JOIN @UsersToInsert t ON u.username = t.username;

-- 6. KIỂM TRA SỐ LƯỢNG STAFF
SELECT 
    COUNT(*) AS total_staff_count
FROM users u
JOIN user_roles ur ON u.id = ur.user_id
JOIN roles r ON ur.role_id = r.id
WHERE r.name = 'STAFF';
GO
