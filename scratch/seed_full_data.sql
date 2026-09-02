-- ============================================================================
-- 7. INSERT USERS & ROLES SEED DATA (CHIA RÕ TỪNG ROLE THEO THỨ TỰ)
-- ============================================================================

-- --------------------------------------------------
-- A. TÀI KHOẢN ADMIN QUẢN TRỊ VIÊN
-- --------------------------------------------------
SET IDENTITY_INSERT users ON;
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, status, force_change_password, created_at)
VALUES (1, 'admin', 'admin@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Quản Trị Viên Hệ Thống', '0901234567', N'Số 1 Đại Cồ Việt, Hai Bà Trưng, Hà Nội', 1, 'LOCAL', 1, 0, '2024-01-01 08:00:00');
SET IDENTITY_INSERT users OFF;
GO

-- --------------------------------------------------
-- B. 20 TÀI KHOẢN NHÂN VIÊN (STAFF) - THÔNG TIN THỰC TẾ
-- --------------------------------------------------
SET IDENTITY_INSERT users ON;
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (2, 'staff01', 'staff01@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Nguyễn Tuyết Vy', '0863218196', N'Số 112, Đường Nguyễn Huệ, Ba Đình, Hà Nội', 1, 'LOCAL', '1995-09-20', 0, 1, 0, '2024-01-18 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (3, 'staff02', 'staff02@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Ngô Thanh Duyên', '0704026542', N'Số 48, Đường Nguyễn Trãi, Lê Chân, Hải Phòng', 1, 'LOCAL', '1998-02-12', 0, 1, 0, '2024-03-20 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (4, 'staff03', 'staff03@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Trần Trọng Quân', '0391618495', N'Số 24, Đường Nguyễn Huệ, TP. Huế, Huế', 1, 'LOCAL', '2002-04-25', 1, 1, 0, '2024-03-03 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (5, 'staff04', 'staff04@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Phạm Diệu Vy', '0365255341', N'Số 274, Đường Lý Thường Kiệt, Hương Trà, Huế', 1, 'LOCAL', '1995-03-15', 0, 1, 0, '2024-04-09 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (6, 'staff05', 'staff05@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Bùi Trúc Trang', '0860564139', N'Số 203, Đường Kim Mã, Thuận An, Bình Dương', 1, 'LOCAL', '2002-08-05', 0, 1, 0, '2024-03-05 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (7, 'staff06', 'staff06@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Võ Tuyết Tú', '0359653287', N'Số 79, Đường Nguyễn Trãi, Quận 1, TP. Hồ Chí Minh', 1, 'LOCAL', '2002-03-26', 0, 1, 0, '2024-06-14 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (8, 'staff07', 'staff07@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hồ Diệu Lam', '0368480184', N'Số 223, Đường Cách Mạng Tháng 8, Thủ Dầu Một, Bình Dương', 1, 'LOCAL', '1994-08-01', 0, 1, 0, '2024-06-24 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (9, 'staff08', 'staff08@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Huỳnh Tiến Long', '0774893252', N'Số 307, Đường Trần Hưng Đạo, Yên Phong, Bắc Ninh', 1, 'LOCAL', '1997-08-01', 1, 1, 0, '2024-01-12 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (10, 'staff09', 'staff09@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Vũ Văn Phong', '0701171822', N'Số 136, Đường Lý Thường Kiệt, Uông Bí, Quảng Ninh', 1, 'LOCAL', '2000-10-14', 1, 1, 0, '2024-02-18 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (11, 'staff10', 'staff10@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đặng Diệu Hằng', '0368713315', N'Số 302, Đường Hoàng Hoa Thám, Long Biên, Hà Nội', 1, 'LOCAL', '1995-01-03', 0, 1, 0, '2024-06-21 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (12, 'staff11', 'staff11@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Vũ Ngọc Trang', '0321834738', N'Số 125, Đường Kim Mã, Cẩm Lệ, Đà Nẵng', 1, 'LOCAL', '1999-07-07', 0, 1, 0, '2024-01-04 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (13, 'staff12', 'staff12@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đỗ Anh Thắng', '0360106513', N'Số 72, Đường Cầu Giấy, Ngô Quyền, Hải Phòng', 1, 'LOCAL', '1998-03-09', 1, 1, 0, '2024-04-08 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (14, 'staff13', 'staff13@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Dương Quỳnh Trâm', '0940801326', N'Số 443, Đường Hai Bà Trưng, Cẩm Phả, Quảng Ninh', 1, 'LOCAL', '1998-01-06', 0, 1, 0, '2024-04-01 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (15, 'staff14', 'staff14@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Võ Đình Quân', '0896872343', N'Số 383, Đường Lê Lợi, Long Biên, Hà Nội', 1, 'LOCAL', '1997-01-02', 1, 1, 0, '2024-05-16 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (16, 'staff15', 'staff15@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Trần Mỹ Hương', '0971913619', N'Số 318, Đường Lê Lợi, Hải An, Hải Phòng', 1, 'LOCAL', '1993-07-22', 0, 1, 0, '2024-05-19 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (17, 'staff16', 'staff16@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Võ Hữu Nhân', '0795346247', N'Số 235, Đường Trần Hưng Đạo, Thủ Dầu Một, Bình Dương', 1, 'LOCAL', '2001-10-04', 1, 1, 0, '2024-01-18 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (18, 'staff17', 'staff17@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Võ Thu Hằng', '0933542784', N'Số 342, Đường Trần Hưng Đạo, Hương Trà, Huế', 1, 'LOCAL', '2000-05-22', 0, 1, 0, '2024-01-05 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (19, 'staff18', 'staff18@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Phạm Đức Khoa', '0964493534', N'Số 434, Đường Điện Biên Phủ, Từ Sơn, Bắc Ninh', 1, 'LOCAL', '1992-02-21', 1, 1, 0, '2024-04-27 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (20, 'staff19', 'staff19@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Trần Văn Tùng', '0964278680', N'Số 280, Đường Phan Chu Trinh, Quận 3, TP. Hồ Chí Minh', 1, 'LOCAL', '1992-06-19', 1, 1, 0, '2024-05-05 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (21, 'staff20', 'staff20@luxurypc.vn', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hoàng Văn Bình', '0330533158', N'Số 122, Đường Phan Chu Trinh, Trảng Bom, Đồng Nai', 1, 'LOCAL', '1994-03-14', 1, 1, 0, '2024-01-06 08:30:00');
SET IDENTITY_INSERT users OFF;
GO

-- --------------------------------------------------
-- C. 100 TÀI KHOẢN KHÁCH HÀNG (USER) - HỌ TÊN CÓ DẤU CHUẨN
-- --------------------------------------------------
SET IDENTITY_INSERT users ON;
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (22, 'user_001', 'khachhang001@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Ngô Đình Nhân', '0864216073', N'Số 157, Đường Nguyễn Văn Cừ, Kiến An, Hải Phòng', 1, 'LOCAL', '1992-04-01', 1, 1, 0, '2026-04-13 12:27:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (23, 'user_002', 'khachhang002@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Võ Phương Hiền', '0348501429', N'Số 306, Đường Nguyễn Trãi, Ninh Kiều, Cần Thơ', 1, 'LOCAL', '1998-06-24', 0, 1, 0, '2025-07-20 15:17:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (24, 'user_003', 'khachhang003@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Phan Minh Dũng', '0796088356', N'Số 340, Đường Võ Văn Kiệt, Gò Vấp, TP. Hồ Chí Minh', 1, 'LOCAL', '1988-12-10', 1, 1, 0, '2026-05-22 13:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (25, 'user_004', 'khachhang004@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đặng Tiến Cường', '0986629946', N'Số 147, Đường Cách Mạng Tháng 8, TP. Bắc Ninh, Bắc Ninh', 1, 'LOCAL', '1991-07-26', 1, 1, 0, '2026-06-15 14:38:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (26, 'user_005', 'khachhang005@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Lý Quỳnh Anh', '0781489513', N'Số 76, Đường Hai Bà Trưng, Bình Thủy, Cần Thơ', 1, 'LOCAL', '1985-01-08', 0, 1, 0, '2025-10-28 19:14:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (27, 'user_006', 'khachhang006@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Ngô Gia Phúc', '0986763201', N'Số 412, Đường Lý Thường Kiệt, Biên Hòa, Đồng Nai', 1, 'LOCAL', '2001-08-02', 1, 1, 0, '2026-04-28 08:39:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (28, 'user_007', 'khachhang007@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Dương Hải Hiền', '0399579868', N'Số 231, Đường Kim Mã, Hạ Long, Quảng Ninh', 1, 'LOCAL', '1993-04-27', 0, 1, 0, '2026-05-25 19:43:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (29, 'user_008', 'khachhang008@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Vũ Minh Quân', '0934345581', N'Số 197, Đường Hoàng Hoa Thám, Thanh Khê, Đà Nẵng', 1, 'LOCAL', '1989-12-07', 1, 1, 0, '2024-07-14 12:44:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (30, 'user_009', 'khachhang009@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Ngô Văn Hải', '0356909670', N'Số 437, Đường Trường Chinh, Dĩ An, Bình Dương', 1, 'LOCAL', '1998-09-24', 1, 1, 0, '2026-04-16 10:27:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (31, 'user_010', 'khachhang010@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Lý Văn Linh', '0326272980', N'Số 43, Đường Trần Hưng Đạo, Trảng Bom, Đồng Nai', 1, 'LOCAL', '2005-07-05', 1, 1, 0, '2025-03-02 11:34:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (32, 'user_011', 'khachhang011@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Phan Tuấn Tùng', '0326464170', N'Số 115, Đường Nguyễn Văn Cừ, TP. Bắc Ninh, Bắc Ninh', 1, 'LOCAL', '2005-02-25', 1, 1, 0, '2026-01-25 07:25:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (33, 'user_012', 'khachhang012@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Nguyễn Ánh Hà', '0862719374', N'Số 399, Đường Nguyễn Trãi, Thuận An, Bình Dương', 1, 'LOCAL', '1990-05-04', 0, 1, 0, '2026-01-10 16:53:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (34, 'user_013', 'khachhang013@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hồ Trọng Hải', '0939314919', N'Số 339, Đường Giải Phóng, Thanh Xuân, Hà Nội', 1, 'LOCAL', '1996-02-17', 1, 1, 0, '2026-06-01 20:36:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (35, 'user_014', 'khachhang014@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Phạm Anh Sơn', '0777262849', N'Số 224, Đường Cầu Giấy, Từ Sơn, Bắc Ninh', 1, 'LOCAL', '2003-05-11', 1, 1, 0, '2024-02-09 21:38:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (36, 'user_015', 'khachhang015@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Dương Ánh Lam', '0786507527', N'Số 175, Đường Điện Biên Phủ, Lê Chân, Hải Phòng', 1, 'LOCAL', '1993-10-23', 0, 1, 0, '2025-09-01 15:22:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (37, 'user_016', 'khachhang016@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Vũ Tuyết Châu', '0378377701', N'Số 355, Đường Trường Chinh, Bình Thủy, Cần Thơ', 1, 'LOCAL', '1992-05-22', 0, 1, 0, '2026-06-16 15:43:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (38, 'user_017', 'khachhang017@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Ngô Trọng Khoa', '0325744431', N'Số 381, Đường Nguyễn Trãi, Lê Chân, Hải Phòng', 1, 'LOCAL', '2002-12-06', 1, 1, 0, '2024-04-24 14:27:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (39, 'user_018', 'khachhang018@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Phạm Xuân Hải', '0893524082', N'Số 284, Đường Lê Lợi, Ninh Kiều, Cần Thơ', 1, 'LOCAL', '1994-12-05', 1, 1, 0, '2026-08-04 20:10:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (40, 'user_019', 'khachhang019@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Lý Tuấn Quân', '0322047116', N'Số 78, Đường Lê Lợi, Hạ Long, Quảng Ninh', 1, 'LOCAL', '1989-10-10', 1, 1, 0, '2024-04-04 15:58:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (41, 'user_020', 'khachhang020@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Vũ Đình Khải', '0347749649', N'Số 391, Đường Nguyễn Trãi, TP. Huế, Huế', 1, 'LOCAL', '1991-11-07', 1, 1, 0, '2025-11-03 09:25:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (42, 'user_021', 'khachhang021@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Lê Thu Linh', '0357974034', N'Số 352, Đường Nguyễn Huệ, Ô Môn, Cần Thơ', 1, 'LOCAL', '1992-05-26', 0, 1, 0, '2026-04-14 08:44:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (43, 'user_022', 'khachhang022@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hoàng Mai Hà', '0930249947', N'Số 359, Đường Cách Mạng Tháng 8, Phú Nhuận, TP. Hồ Chí Minh', 1, 'LOCAL', '1997-05-17', 0, 1, 0, '2026-08-15 08:48:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (44, 'user_023', 'khachhang023@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Ngô Tuyết Mai', '0764013990', N'Số 241, Đường Lý Thường Kiệt, Ninh Kiều, Cần Thơ', 1, 'LOCAL', '2001-11-15', 0, 1, 0, '2025-03-19 13:50:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (45, 'user_024', 'khachhang024@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Lê Tuấn Sơn', '0355512567', N'Số 233, Đường Lê Lợi, Ô Môn, Cần Thơ', 1, 'LOCAL', '1987-06-09', 1, 1, 0, '2025-02-25 13:42:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (46, 'user_025', 'khachhang025@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Dương Diệu Trang', '0988597703', N'Số 225, Đường Cách Mạng Tháng 8, Bình Thủy, Cần Thơ', 1, 'LOCAL', '2000-02-01', 0, 1, 0, '2026-04-23 09:29:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (47, 'user_026', 'khachhang026@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Ngô Ngọc Nhi', '0947127484', N'Số 125, Đường Kim Mã, Long Thành, Đồng Nai', 1, 'LOCAL', '1999-09-05', 0, 1, 0, '2025-04-20 15:57:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (48, 'user_027', 'khachhang027@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Lê Mai Châu', '0328404499', N'Số 276, Đường Cầu Giấy, Hạ Long, Quảng Ninh', 1, 'LOCAL', '2000-06-11', 0, 1, 0, '2026-07-15 21:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (49, 'user_028', 'khachhang028@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Vũ Ánh Ngọc', '0866057662', N'Số 258, Đường Phan Chu Trinh, Hạ Long, Quảng Ninh', 1, 'LOCAL', '2003-06-28', 0, 1, 0, '2024-08-04 15:39:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (50, 'user_029', 'khachhang029@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hoàng Diệu Hà', '0937459615', N'Số 321, Đường Võ Văn Kiệt, Từ Sơn, Bắc Ninh', 1, 'LOCAL', '2000-09-02', 0, 1, 0, '2026-02-08 17:53:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (51, 'user_030', 'khachhang030@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Vũ Trọng Nam', '0351172400', N'Số 184, Đường Cách Mạng Tháng 8, Thủ Dầu Một, Bình Dương', 1, 'LOCAL', '1996-07-05', 1, 1, 0, '2024-09-14 16:53:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (52, 'user_031', 'khachhang031@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Huỳnh Thu Hương', '0766937923', N'Số 236, Đường Điện Biên Phủ, Uông Bí, Quảng Ninh', 1, 'LOCAL', '1993-11-01', 0, 1, 0, '2025-05-22 15:20:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (53, 'user_032', 'khachhang032@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Dương Phương Tú', '0896474367', N'Số 293, Đường Trường Chinh, Quận 10, TP. Hồ Chí Minh', 1, 'LOCAL', '1996-10-10', 0, 1, 0, '2026-05-01 20:52:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (54, 'user_033', 'khachhang033@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Võ Văn Phúc', '0780974395', N'Số 348, Đường Điện Biên Phủ, Ngô Quyền, Hải Phòng', 1, 'LOCAL', '1989-11-04', 1, 1, 0, '2026-01-10 19:38:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (55, 'user_034', 'khachhang034@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đỗ Tuyết Hà', '0934562328', N'Số 132, Đường Lý Thường Kiệt, Dĩ An, Bình Dương', 1, 'LOCAL', '2000-05-24', 0, 1, 0, '2025-02-15 08:19:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (56, 'user_035', 'khachhang035@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hồ Trúc Trâm', '0331604817', N'Số 422, Đường Trường Chinh, Dĩ An, Bình Dương', 1, 'LOCAL', '2005-06-04', 0, 1, 0, '2026-04-16 07:49:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (57, 'user_036', 'khachhang036@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Vũ Gia Nam', '0777461200', N'Số 50, Đường Nguyễn Trãi, Ô Môn, Cần Thơ', 1, 'LOCAL', '1992-09-05', 1, 1, 0, '2025-08-12 17:57:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (58, 'user_037', 'khachhang037@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hoàng Anh Tài', '0947964053', N'Số 438, Đường Hoàng Hoa Thám, Cẩm Phả, Quảng Ninh', 1, 'LOCAL', '1996-02-22', 1, 1, 0, '2025-09-21 12:13:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (59, 'user_038', 'khachhang038@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Võ Hữu Long', '0361390053', N'Số 36, Đường Hai Bà Trưng, Liên Chiểu, Đà Nẵng', 1, 'LOCAL', '2002-04-19', 1, 1, 0, '2024-04-11 19:19:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (60, 'user_039', 'khachhang039@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Võ Trúc Hà', '0968421020', N'Số 9, Đường Võ Văn Kiệt, Thuận An, Bình Dương', 1, 'LOCAL', '1990-05-02', 0, 1, 0, '2024-12-14 15:17:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (61, 'user_040', 'khachhang040@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Lý Khánh Hằng', '0389178390', N'Số 330, Đường Cầu Giấy, Từ Sơn, Bắc Ninh', 1, 'LOCAL', '1985-01-16', 0, 1, 0, '2025-07-22 08:41:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (62, 'user_041', 'khachhang041@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Lê Đức Tùng', '0762124998', N'Số 233, Đường Cách Mạng Tháng 8, Bến Cát, Bình Dương', 1, 'LOCAL', '2001-10-14', 1, 1, 0, '2024-12-04 20:51:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (63, 'user_042', 'khachhang042@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Ngô Khánh Nhi', '0355766156', N'Số 79, Đường Nguyễn Văn Cừ, Dĩ An, Bình Dương', 1, 'LOCAL', '2000-02-03', 0, 1, 0, '2024-02-14 08:57:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (64, 'user_043', 'khachhang043@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hoàng Tiến Dũng', '0708851656', N'Số 181, Đường Cách Mạng Tháng 8, Hoàn Kiếm, Hà Nội', 1, 'LOCAL', '1988-10-17', 1, 1, 0, '2024-03-22 14:24:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (65, 'user_044', 'khachhang044@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đỗ Trúc Trâm', '0331493689', N'Số 312, Đường Trần Hưng Đạo, Hương Trà, Huế', 1, 'LOCAL', '1993-01-06', 0, 1, 0, '2025-12-25 11:31:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (66, 'user_045', 'khachhang045@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Nguyễn Thành Cường', '0706120183', N'Số 175, Đường Cầu Giấy, Long Thành, Đồng Nai', 1, 'LOCAL', '1990-06-10', 1, 1, 0, '2026-06-25 16:48:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (67, 'user_046', 'khachhang046@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Trần Thu Anh', '0760147679', N'Số 111, Đường Điện Biên Phủ, Cẩm Phả, Quảng Ninh', 1, 'LOCAL', '2001-02-12', 0, 1, 0, '2025-02-10 17:53:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (68, 'user_047', 'khachhang047@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đặng Văn Phong', '0349003432', N'Số 62, Đường Võ Văn Kiệt, Cái Răng, Cần Thơ', 1, 'LOCAL', '1985-08-24', 1, 1, 0, '2025-03-05 13:44:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (69, 'user_048', 'khachhang048@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đỗ Ngọc Ngọc', '0916071596', N'Số 149, Đường Giải Phóng, Hương Thủy, Huế', 1, 'LOCAL', '1988-07-01', 0, 1, 0, '2025-03-26 16:39:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (70, 'user_049', 'khachhang049@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Lê Anh Long', '0866968164', N'Số 399, Đường Võ Văn Kiệt, Thuận An, Bình Dương', 1, 'LOCAL', '1990-02-17', 1, 1, 0, '2026-02-17 15:22:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (71, 'user_050', 'khachhang050@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đỗ Trọng Tài', '0963124329', N'Số 91, Đường Nguyễn Huệ, Cẩm Lệ, Đà Nẵng', 1, 'LOCAL', '2005-08-15', 1, 1, 0, '2026-08-22 21:46:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (72, 'user_051', 'khachhang051@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Bùi Thành Quân', '0937744905', N'Số 237, Đường Cách Mạng Tháng 8, TP. Bắc Ninh, Bắc Ninh', 1, 'LOCAL', '1999-01-02', 1, 1, 0, '2025-05-03 17:15:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (73, 'user_052', 'khachhang052@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Dương Bảo Khoa', '0917935978', N'Số 53, Đường Cầu Giấy, Hải Châu, Đà Nẵng', 1, 'LOCAL', '1995-12-03', 1, 1, 0, '2026-03-02 10:55:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (74, 'user_053', 'khachhang053@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Dương Tiến Khải', '0762554665', N'Số 34, Đường Võ Văn Kiệt, TP. Huế, Huế', 1, 'LOCAL', '1995-02-18', 1, 1, 0, '2026-07-10 11:56:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (75, 'user_054', 'khachhang054@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Bùi Ngọc Tú', '0782546291', N'Số 417, Đường Võ Văn Kiệt, Ô Môn, Cần Thơ', 1, 'LOCAL', '1989-11-23', 0, 1, 0, '2026-02-21 17:37:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (76, 'user_055', 'khachhang055@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Nguyễn Quang Bình', '0973573322', N'Số 260, Đường Nguyễn Trãi, Bình Thạnh, TP. Hồ Chí Minh', 1, 'LOCAL', '2002-12-17', 1, 1, 0, '2024-11-11 21:59:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (77, 'user_056', 'khachhang056@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hồ Thu Anh', '0979270653', N'Số 386, Đường Cách Mạng Tháng 8, Uông Bí, Quảng Ninh', 1, 'LOCAL', '1999-04-18', 0, 1, 0, '2024-05-26 19:40:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (78, 'user_057', 'khachhang057@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đỗ Hải Tú', '0367468862', N'Số 447, Đường Phan Chu Trinh, Hải An, Hải Phòng', 1, 'LOCAL', '1993-01-21', 0, 1, 0, '2025-06-18 21:16:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (79, 'user_058', 'khachhang058@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đặng Ngọc Anh', '0887826137', N'Số 28, Đường Giải Phóng, Thủ Dầu Một, Bình Dương', 1, 'LOCAL', '1997-09-12', 0, 1, 0, '2024-07-03 12:24:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (80, 'user_059', 'khachhang059@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Bùi Ngọc Mai', '0962047277', N'Số 10, Đường Nguyễn Huệ, TP. Huế, Huế', 1, 'LOCAL', '1993-04-27', 0, 1, 0, '2024-09-24 16:43:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (81, 'user_060', 'khachhang060@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Phạm Đình Bình', '0864103697', N'Số 306, Đường Kim Mã, Quận 3, TP. Hồ Chí Minh', 1, 'LOCAL', '2002-01-21', 1, 1, 0, '2026-04-23 09:28:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (82, 'user_061', 'khachhang061@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Nguyễn Bảo Sơn', '0869621851', N'Số 200, Đường Trần Hưng Đạo, Yên Phong, Bắc Ninh', 1, 'LOCAL', '2000-01-21', 1, 1, 0, '2025-06-09 18:11:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (83, 'user_062', 'khachhang062@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Lê Quang Phong', '0781952058', N'Số 357, Đường Cầu Giấy, Thuận An, Bình Dương', 1, 'LOCAL', '2000-11-06', 1, 1, 0, '2024-02-23 19:39:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (84, 'user_063', 'khachhang063@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đặng Thanh Trang', '0980548687', N'Số 147, Đường Hai Bà Trưng, Ninh Kiều, Cần Thơ', 1, 'LOCAL', '1996-01-28', 0, 1, 0, '2026-06-09 08:33:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (85, 'user_064', 'khachhang064@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hồ Trọng Quân', '0345277584', N'Số 221, Đường Nguyễn Huệ, Tân Bình, TP. Hồ Chí Minh', 1, 'LOCAL', '2004-03-18', 1, 1, 0, '2025-06-04 08:30:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (86, 'user_065', 'khachhang065@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đặng Tuấn Khang', '0796275705', N'Số 328, Đường Điện Biên Phủ, Hương Thủy, Huế', 1, 'LOCAL', '1986-02-22', 1, 1, 0, '2026-07-12 15:57:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (87, 'user_066', 'khachhang066@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Nguyễn Thu Lam', '0787021355', N'Số 310, Đường Lê Lợi, Trảng Bom, Đồng Nai', 1, 'LOCAL', '1989-11-15', 0, 1, 0, '2025-06-15 19:14:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (88, 'user_067', 'khachhang067@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đỗ Diệu Mai', '0774310278', N'Số 135, Đường Nguyễn Trãi, Trảng Bom, Đồng Nai', 1, 'LOCAL', '1993-12-15', 0, 1, 0, '2024-10-10 18:41:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (89, 'user_068', 'khachhang068@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Phạm Thu Hương', '0362715518', N'Số 436, Đường Cách Mạng Tháng 8, Từ Sơn, Bắc Ninh', 1, 'LOCAL', '1990-12-23', 0, 1, 0, '2026-03-26 12:42:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (90, 'user_069', 'khachhang069@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Phạm Thanh Hà', '0867058957', N'Số 34, Đường Nguyễn Huệ, TP. Bắc Ninh, Bắc Ninh', 1, 'LOCAL', '1994-07-23', 0, 1, 0, '2026-08-17 13:59:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (91, 'user_070', 'khachhang070@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Lê Thành Tùng', '0771778528', N'Số 222, Đường Phan Chu Trinh, TP. Huế, Huế', 1, 'LOCAL', '2001-01-27', 1, 1, 0, '2024-09-05 11:20:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (92, 'user_071', 'khachhang071@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Bùi Tuyết Nhi', '0338414384', N'Số 315, Đường Cách Mạng Tháng 8, Cẩm Lệ, Đà Nẵng', 1, 'LOCAL', '2002-02-17', 0, 1, 0, '2026-03-19 16:19:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (93, 'user_072', 'khachhang072@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Bùi Trúc Tú', '0910109439', N'Số 255, Đường Trần Hưng Đạo, Trảng Bom, Đồng Nai', 1, 'LOCAL', '2005-09-10', 0, 1, 0, '2026-05-16 10:53:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (94, 'user_073', 'khachhang073@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đặng Tuấn Nam', '0790276773', N'Số 442, Đường Võ Văn Kiệt, Thuận An, Bình Dương', 1, 'LOCAL', '1995-12-28', 1, 1, 0, '2025-07-05 19:33:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (95, 'user_074', 'khachhang074@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Bùi Thanh Duyên', '0944732104', N'Số 128, Đường Giải Phóng, Trảng Bom, Đồng Nai', 1, 'LOCAL', '1990-06-19', 0, 1, 0, '2026-06-07 19:20:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (96, 'user_075', 'khachhang075@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Dương Tuấn Bình', '0370168733', N'Số 26, Đường Lê Lợi, Hương Thủy, Huế', 1, 'LOCAL', '1994-08-20', 1, 1, 0, '2026-08-10 15:10:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (97, 'user_076', 'khachhang076@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Ngô Thu Vy', '0336506098', N'Số 38, Đường Cách Mạng Tháng 8, Lê Chân, Hải Phòng', 1, 'LOCAL', '1997-09-15', 0, 1, 0, '2026-05-27 16:53:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (98, 'user_077', 'khachhang077@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hoàng Ngọc Ngọc', '0335852398', N'Số 24, Đường Lê Lợi, Trảng Bom, Đồng Nai', 1, 'LOCAL', '1986-03-23', 0, 1, 0, '2025-08-17 14:19:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (99, 'user_078', 'khachhang078@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Bùi Ánh Mai', '0976949588', N'Số 244, Đường Cách Mạng Tháng 8, Từ Sơn, Bắc Ninh', 1, 'LOCAL', '1985-06-11', 0, 1, 0, '2026-02-14 16:29:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (100, 'user_079', 'khachhang079@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Lý Mai Tú', '0703097289', N'Số 17, Đường Hoàng Hoa Thám, Biên Hòa, Đồng Nai', 1, 'LOCAL', '2003-12-04', 0, 1, 0, '2024-01-15 12:36:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (101, 'user_080', 'khachhang080@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Ngô Tuyết Huyền', '0358970283', N'Số 270, Đường Kim Mã, Từ Sơn, Bắc Ninh', 1, 'LOCAL', '1997-06-06', 0, 1, 0, '2025-09-11 15:32:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (102, 'user_081', 'khachhang081@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Lý Hữu Phong', '0888434437', N'Số 287, Đường Nguyễn Văn Cừ, Bến Cát, Bình Dương', 1, 'LOCAL', '1993-05-04', 1, 1, 0, '2026-07-13 20:32:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (103, 'user_082', 'khachhang082@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đặng Thị Yến', '0791574733', N'Số 71, Đường Điện Biên Phủ, Từ Sơn, Bắc Ninh', 1, 'LOCAL', '1988-10-24', 0, 1, 0, '2026-04-08 07:52:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (104, 'user_083', 'khachhang083@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Vũ Thị Thảo', '0355712082', N'Số 245, Đường Kim Mã, Trảng Bom, Đồng Nai', 1, 'LOCAL', '2005-04-25', 0, 1, 0, '2025-06-10 17:13:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (105, 'user_084', 'khachhang084@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Vũ Mỹ Trang', '0976206724', N'Số 291, Đường Cách Mạng Tháng 8, Ba Đình, Hà Nội', 1, 'LOCAL', '2004-02-11', 0, 1, 0, '2025-08-21 15:43:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (106, 'user_085', 'khachhang085@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hoàng Xuân Khải', '0364315274', N'Số 405, Đường Võ Văn Kiệt, Hải Châu, Đà Nẵng', 1, 'LOCAL', '1994-10-22', 1, 1, 0, '2024-03-20 20:50:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (107, 'user_086', 'khachhang086@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Ngô Tiến Tùng', '0936122753', N'Số 121, Đường Trường Chinh, Hoàn Kiếm, Hà Nội', 1, 'LOCAL', '1999-05-11', 1, 1, 0, '2025-10-24 16:10:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (108, 'user_087', 'khachhang087@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Đỗ Trọng Phong', '0911742684', N'Số 315, Đường Nguyễn Văn Cừ, Bình Thạnh, TP. Hồ Chí Minh', 1, 'LOCAL', '1992-04-05', 1, 1, 0, '2025-03-15 18:48:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (109, 'user_088', 'khachhang088@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Ngô Trọng Khoa', '0378339187', N'Số 40, Đường Nguyễn Văn Cừ, Yên Phong, Bắc Ninh', 1, 'LOCAL', '2003-02-02', 1, 1, 0, '2026-04-19 15:19:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (110, 'user_089', 'khachhang089@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Bùi Trúc Hiền', '0361397187', N'Số 263, Đường Phan Chu Trinh, Nam Từ Liêm, Hà Nội', 1, 'LOCAL', '1998-08-19', 0, 1, 0, '2024-09-15 17:29:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (111, 'user_090', 'khachhang090@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hồ Mai Linh', '0989106518', N'Số 17, Đường Kim Mã, Cầu Giấy, Hà Nội', 1, 'LOCAL', '1994-07-06', 0, 1, 0, '2024-11-24 17:36:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (112, 'user_091', 'khachhang091@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hồ Tuấn Linh', '0341825128', N'Số 373, Đường Phan Chu Trinh, Trảng Bom, Đồng Nai', 1, 'LOCAL', '1992-01-25', 1, 1, 0, '2024-05-15 17:56:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (113, 'user_092', 'khachhang092@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Hồ Xuân Phong', '0867524310', N'Số 124, Đường Trần Hưng Đạo, Trảng Bom, Đồng Nai', 1, 'LOCAL', '1991-02-04', 1, 1, 0, '2026-01-15 16:53:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (114, 'user_093', 'khachhang093@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Vũ Tuyết Trang', '0347383028', N'Số 296, Đường Võ Văn Kiệt, Bình Thủy, Cần Thơ', 1, 'LOCAL', '2004-11-27', 0, 1, 0, '2025-04-10 21:19:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (115, 'user_094', 'khachhang094@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Ngô Mai Vy', '0918926870', N'Số 357, Đường Võ Văn Kiệt, Bến Cát, Bình Dương', 1, 'LOCAL', '1998-07-05', 0, 1, 0, '2025-07-06 19:44:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (116, 'user_095', 'khachhang095@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Vũ Xuân Phong', '0892708668', N'Số 125, Đường Trường Chinh, TP. Bắc Ninh, Bắc Ninh', 1, 'LOCAL', '1993-04-11', 1, 1, 0, '2026-02-15 20:33:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (117, 'user_096', 'khachhang096@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Phan Thị Vy', '0349901398', N'Số 446, Đường Hai Bà Trưng, Kiến An, Hải Phòng', 1, 'LOCAL', '1995-05-01', 0, 1, 0, '2024-04-24 08:57:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (118, 'user_097', 'khachhang097@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Vũ Trọng Khang', '0793638546', N'Số 158, Đường Nguyễn Văn Cừ, Uông Bí, Quảng Ninh', 1, 'LOCAL', '1993-06-17', 1, 1, 0, '2025-08-04 19:56:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (119, 'user_098', 'khachhang098@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Bùi Hữu Sơn', '0326093204', N'Số 152, Đường Giải Phóng, Yên Phong, Bắc Ninh', 1, 'LOCAL', '1989-04-11', 1, 1, 0, '2024-07-19 20:25:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (120, 'user_099', 'khachhang099@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Bùi Minh Đạt', '0777725228', N'Số 269, Đường Lê Lợi, Hạ Long, Quảng Ninh', 1, 'LOCAL', '1986-02-27', 1, 1, 0, '2026-01-25 07:36:00');
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)
VALUES (121, 'user_100', 'khachhang100@gmail.com', '$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G.', N'Vũ Ngọc Hà', '0903875099', N'Số 9, Đường Kim Mã, Uông Bí, Quảng Ninh', 1, 'LOCAL', '1985-09-18', 0, 1, 0, '2025-01-01 15:56:00');
SET IDENTITY_INSERT users OFF;
DBCC CHECKIDENT ('users', RESEED, 121);
GO

-- --------------------------------------------------
-- D. PHÂN QUYỀN USER_ROLES TƯƠNG ỨNG TỪNG NHÓM
-- --------------------------------------------------
-- Quyền ADMIN cho tài khoản admin (id=1)
INSERT INTO user_roles (user_id, role_id) VALUES (1, 1);

-- Quyền STAFF cho 20 nhân viên (id=2..21)
INSERT INTO user_roles (user_id, role_id) VALUES (2, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (3, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (4, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (5, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (6, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (7, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (8, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (9, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (10, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (11, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (12, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (13, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (14, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (15, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (16, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (17, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (18, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (19, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (20, 3);
INSERT INTO user_roles (user_id, role_id) VALUES (21, 3);

-- Quyền USER cho 100 khách hàng (id=22..121)
INSERT INTO user_roles (user_id, role_id) VALUES (22, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (23, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (24, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (25, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (26, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (27, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (28, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (29, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (30, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (31, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (32, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (33, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (34, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (35, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (36, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (37, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (38, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (39, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (40, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (41, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (42, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (43, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (44, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (45, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (46, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (47, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (48, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (49, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (50, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (51, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (52, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (53, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (54, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (55, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (56, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (57, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (58, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (59, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (60, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (61, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (62, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (63, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (64, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (65, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (66, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (67, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (68, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (69, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (70, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (71, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (72, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (73, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (74, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (75, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (76, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (77, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (78, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (79, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (80, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (81, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (82, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (83, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (84, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (85, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (86, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (87, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (88, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (89, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (90, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (91, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (92, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (93, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (94, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (95, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (96, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (97, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (98, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (99, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (100, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (101, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (102, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (103, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (104, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (105, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (106, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (107, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (108, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (109, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (110, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (111, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (112, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (113, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (114, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (115, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (116, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (117, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (118, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (119, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (120, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (121, 2);
GO

-- --------------------------------------------------
-- E. ĐỊA CHỈ GIAO HÀNG (SHIPPING_ADDRESSES) MẪU CHO KHÁCH HÀNG
-- --------------------------------------------------
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (22, N'Ngô Đình Nhân', '0864216073', N'Số 157, Đường Nguyễn Văn Cừ, Kiến An, Hải Phòng', N'Hải Phòng', N'Kiến An', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (23, N'Võ Phương Hiền', '0348501429', N'Số 306, Đường Nguyễn Trãi, Ninh Kiều, Cần Thơ', N'Cần Thơ', N'Ninh Kiều', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (24, N'Phan Minh Dũng', '0796088356', N'Số 340, Đường Võ Văn Kiệt, Gò Vấp, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', N'Gò Vấp', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (25, N'Đặng Tiến Cường', '0986629946', N'Số 147, Đường Cách Mạng Tháng 8, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', N'TP. Bắc Ninh', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (26, N'Lý Quỳnh Anh', '0781489513', N'Số 76, Đường Hai Bà Trưng, Bình Thủy, Cần Thơ', N'Cần Thơ', N'Bình Thủy', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (27, N'Ngô Gia Phúc', '0986763201', N'Số 412, Đường Lý Thường Kiệt, Biên Hòa, Đồng Nai', N'Đồng Nai', N'Biên Hòa', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (28, N'Dương Hải Hiền', '0399579868', N'Số 231, Đường Kim Mã, Hạ Long, Quảng Ninh', N'Quảng Ninh', N'Hạ Long', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (29, N'Vũ Minh Quân', '0934345581', N'Số 197, Đường Hoàng Hoa Thám, Thanh Khê, Đà Nẵng', N'Đà Nẵng', N'Thanh Khê', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (30, N'Ngô Văn Hải', '0356909670', N'Số 437, Đường Trường Chinh, Dĩ An, Bình Dương', N'Bình Dương', N'Dĩ An', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (31, N'Lý Văn Linh', '0326272980', N'Số 43, Đường Trần Hưng Đạo, Trảng Bom, Đồng Nai', N'Đồng Nai', N'Trảng Bom', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (32, N'Phan Tuấn Tùng', '0326464170', N'Số 115, Đường Nguyễn Văn Cừ, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', N'TP. Bắc Ninh', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (33, N'Nguyễn Ánh Hà', '0862719374', N'Số 399, Đường Nguyễn Trãi, Thuận An, Bình Dương', N'Bình Dương', N'Thuận An', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (34, N'Hồ Trọng Hải', '0939314919', N'Số 339, Đường Giải Phóng, Thanh Xuân, Hà Nội', N'Hà Nội', N'Thanh Xuân', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (35, N'Phạm Anh Sơn', '0777262849', N'Số 224, Đường Cầu Giấy, Từ Sơn, Bắc Ninh', N'Bắc Ninh', N'Từ Sơn', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (36, N'Dương Ánh Lam', '0786507527', N'Số 175, Đường Điện Biên Phủ, Lê Chân, Hải Phòng', N'Hải Phòng', N'Lê Chân', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (37, N'Vũ Tuyết Châu', '0378377701', N'Số 355, Đường Trường Chinh, Bình Thủy, Cần Thơ', N'Cần Thơ', N'Bình Thủy', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (38, N'Ngô Trọng Khoa', '0325744431', N'Số 381, Đường Nguyễn Trãi, Lê Chân, Hải Phòng', N'Hải Phòng', N'Lê Chân', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (39, N'Phạm Xuân Hải', '0893524082', N'Số 284, Đường Lê Lợi, Ninh Kiều, Cần Thơ', N'Cần Thơ', N'Ninh Kiều', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (40, N'Lý Tuấn Quân', '0322047116', N'Số 78, Đường Lê Lợi, Hạ Long, Quảng Ninh', N'Quảng Ninh', N'Hạ Long', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (41, N'Vũ Đình Khải', '0347749649', N'Số 391, Đường Nguyễn Trãi, TP. Huế, Huế', N'Huế', N'TP. Huế', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (42, N'Lê Thu Linh', '0357974034', N'Số 352, Đường Nguyễn Huệ, Ô Môn, Cần Thơ', N'Cần Thơ', N'Ô Môn', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (43, N'Hoàng Mai Hà', '0930249947', N'Số 359, Đường Cách Mạng Tháng 8, Phú Nhuận, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', N'Phú Nhuận', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (44, N'Ngô Tuyết Mai', '0764013990', N'Số 241, Đường Lý Thường Kiệt, Ninh Kiều, Cần Thơ', N'Cần Thơ', N'Ninh Kiều', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (45, N'Lê Tuấn Sơn', '0355512567', N'Số 233, Đường Lê Lợi, Ô Môn, Cần Thơ', N'Cần Thơ', N'Ô Môn', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (46, N'Dương Diệu Trang', '0988597703', N'Số 225, Đường Cách Mạng Tháng 8, Bình Thủy, Cần Thơ', N'Cần Thơ', N'Bình Thủy', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (47, N'Ngô Ngọc Nhi', '0947127484', N'Số 125, Đường Kim Mã, Long Thành, Đồng Nai', N'Đồng Nai', N'Long Thành', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (48, N'Lê Mai Châu', '0328404499', N'Số 276, Đường Cầu Giấy, Hạ Long, Quảng Ninh', N'Quảng Ninh', N'Hạ Long', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (49, N'Vũ Ánh Ngọc', '0866057662', N'Số 258, Đường Phan Chu Trinh, Hạ Long, Quảng Ninh', N'Quảng Ninh', N'Hạ Long', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (50, N'Hoàng Diệu Hà', '0937459615', N'Số 321, Đường Võ Văn Kiệt, Từ Sơn, Bắc Ninh', N'Bắc Ninh', N'Từ Sơn', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (51, N'Vũ Trọng Nam', '0351172400', N'Số 184, Đường Cách Mạng Tháng 8, Thủ Dầu Một, Bình Dương', N'Bình Dương', N'Thủ Dầu Một', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (52, N'Huỳnh Thu Hương', '0766937923', N'Số 236, Đường Điện Biên Phủ, Uông Bí, Quảng Ninh', N'Quảng Ninh', N'Uông Bí', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (53, N'Dương Phương Tú', '0896474367', N'Số 293, Đường Trường Chinh, Quận 10, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', N'Quận 10', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (54, N'Võ Văn Phúc', '0780974395', N'Số 348, Đường Điện Biên Phủ, Ngô Quyền, Hải Phòng', N'Hải Phòng', N'Ngô Quyền', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (55, N'Đỗ Tuyết Hà', '0934562328', N'Số 132, Đường Lý Thường Kiệt, Dĩ An, Bình Dương', N'Bình Dương', N'Dĩ An', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (56, N'Hồ Trúc Trâm', '0331604817', N'Số 422, Đường Trường Chinh, Dĩ An, Bình Dương', N'Bình Dương', N'Dĩ An', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (57, N'Vũ Gia Nam', '0777461200', N'Số 50, Đường Nguyễn Trãi, Ô Môn, Cần Thơ', N'Cần Thơ', N'Ô Môn', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (58, N'Hoàng Anh Tài', '0947964053', N'Số 438, Đường Hoàng Hoa Thám, Cẩm Phả, Quảng Ninh', N'Quảng Ninh', N'Cẩm Phả', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (59, N'Võ Hữu Long', '0361390053', N'Số 36, Đường Hai Bà Trưng, Liên Chiểu, Đà Nẵng', N'Đà Nẵng', N'Liên Chiểu', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (60, N'Võ Trúc Hà', '0968421020', N'Số 9, Đường Võ Văn Kiệt, Thuận An, Bình Dương', N'Bình Dương', N'Thuận An', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (61, N'Lý Khánh Hằng', '0389178390', N'Số 330, Đường Cầu Giấy, Từ Sơn, Bắc Ninh', N'Bắc Ninh', N'Từ Sơn', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (62, N'Lê Đức Tùng', '0762124998', N'Số 233, Đường Cách Mạng Tháng 8, Bến Cát, Bình Dương', N'Bình Dương', N'Bến Cát', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (63, N'Ngô Khánh Nhi', '0355766156', N'Số 79, Đường Nguyễn Văn Cừ, Dĩ An, Bình Dương', N'Bình Dương', N'Dĩ An', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (64, N'Hoàng Tiến Dũng', '0708851656', N'Số 181, Đường Cách Mạng Tháng 8, Hoàn Kiếm, Hà Nội', N'Hà Nội', N'Hoàn Kiếm', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (65, N'Đỗ Trúc Trâm', '0331493689', N'Số 312, Đường Trần Hưng Đạo, Hương Trà, Huế', N'Huế', N'Hương Trà', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (66, N'Nguyễn Thành Cường', '0706120183', N'Số 175, Đường Cầu Giấy, Long Thành, Đồng Nai', N'Đồng Nai', N'Long Thành', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (67, N'Trần Thu Anh', '0760147679', N'Số 111, Đường Điện Biên Phủ, Cẩm Phả, Quảng Ninh', N'Quảng Ninh', N'Cẩm Phả', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (68, N'Đặng Văn Phong', '0349003432', N'Số 62, Đường Võ Văn Kiệt, Cái Răng, Cần Thơ', N'Cần Thơ', N'Cái Răng', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (69, N'Đỗ Ngọc Ngọc', '0916071596', N'Số 149, Đường Giải Phóng, Hương Thủy, Huế', N'Huế', N'Hương Thủy', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (70, N'Lê Anh Long', '0866968164', N'Số 399, Đường Võ Văn Kiệt, Thuận An, Bình Dương', N'Bình Dương', N'Thuận An', 1);
INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES (71, N'Đỗ Trọng Tài', '0963124329', N'Số 91, Đường Nguyễn Huệ, Cẩm Lệ, Đà Nẵng', N'Đà Nẵng', N'Cẩm Lệ', 1);
GO

-- ============================================================================
-- 8. 200 ĐƠN HÀNG ĐA DẠNG NGÀY THÁNG (2024 -> 03/09/2026) & CÓ VOUCHER CHUẨN
-- ============================================================================

SET IDENTITY_INSERT orders ON;
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (1, 99, 'LXR2501070001', N'Bùi Ánh Mai', 'khachhang078@gmail.com', '0976949588', N'Số 244, Đường Cách Mạng Tháng 8, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 33600000.00, 0.00, NULL, 'SHIPPING', 'COD', 1, 0, '2025-01-07 00:17:10');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (2, 116, 'LXR2604020002', N'Vũ Xuân Phong', 'khachhang095@gmail.com', '0892708668', N'Số 125, Đường Trường Chinh, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 51800000.00, 0.00, NULL, 'CONFIRMED', 'BANK_TRANSFER', 0, 0, '2026-04-02 18:04:45');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (3, 36, 'LXR2607240003', N'Dương Ánh Lam', 'khachhang015@gmail.com', '0786507527', N'Số 175, Đường Điện Biên Phủ, Lê Chân, Hải Phòng', N'Hải Phòng', 8600000.00, 2000000.00, 'LUX50', 'PAID', 'SEPAY_QR', 1, 0, '2026-07-24 21:52:14');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (4, 81, 'LXR2501200004', N'Phạm Đình Bình', 'khachhang060@gmail.com', '0864103697', N'Số 306, Đường Kim Mã, Quận 3, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 13140000.00, 1460000.00, 'LUX10', 'SHIPPING', 'COD', 1, 0, '2025-01-20 16:15:31');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (5, 108, 'LXR2604150005', N'Đỗ Trọng Phong', 'khachhang087@gmail.com', '0911742684', N'Số 315, Đường Nguyễn Văn Cừ, Bình Thạnh, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 4505000.00, 795000.00, 'LXR36', 'SHIPPING', 'SEPAY_QR', 1, 0, '2026-04-15 15:22:23');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (6, 70, 'LXR2406230006', N'Lê Anh Long', 'khachhang049@gmail.com', '0866968164', N'Số 399, Đường Võ Văn Kiệt, Thuận An, Bình Dương', N'Bình Dương', 43000000.00, 2000000.00, 'LUX10', 'DELIVERED', 'COD', 1, 0, '2024-06-23 21:37:12');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (7, 91, 'LXR2404270007', N'Lê Thành Tùng', 'khachhang070@gmail.com', '0771778528', N'Số 222, Đường Phan Chu Trinh, TP. Huế, Huế', N'Huế', 5355000.00, 945000.00, 'LXR36', 'CONFIRMED', 'MOMO', 0, 0, '2024-04-27 02:42:16');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (8, 53, 'LXR2509030008', N'Dương Phương Tú', 'khachhang032@gmail.com', '0896474367', N'Số 293, Đường Trường Chinh, Quận 10, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 35000000.00, 2000000.00, 'LUX10', 'SHIPPING', 'SEPAY_QR', 1, 0, '2025-09-03 11:41:17');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (9, 118, 'LXR2507290009', N'Vũ Trọng Khang', 'khachhang097@gmail.com', '0793638546', N'Số 158, Đường Nguyễn Văn Cừ, Uông Bí, Quảng Ninh', N'Quảng Ninh', 9500000.00, 2000000.00, 'LUX30', 'CONFIRMED', 'COD', 0, 0, '2025-07-29 02:49:15');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (10, 117, 'LXR2605150010', N'Phan Thị Vy', 'khachhang096@gmail.com', '0349901398', N'Số 446, Đường Hai Bà Trưng, Kiến An, Hải Phòng', N'Hải Phòng', 4930000.00, 870000.00, 'LXR36', 'DELIVERED', 'BANK_TRANSFER', 1, 0, '2026-05-15 22:10:57');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (11, 108, 'LXR2609010011', N'Đỗ Trọng Phong', 'khachhang087@gmail.com', '0911742684', N'Số 315, Đường Nguyễn Văn Cừ, Bình Thạnh, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 38000000.00, 0.00, NULL, 'SHIPPING', 'INSTALLMENT', 1, 0, '2026-09-01 08:13:26');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (12, 36, 'LXR2410070012', N'Dương Ánh Lam', 'khachhang015@gmail.com', '0786507527', N'Số 175, Đường Điện Biên Phủ, Lê Chân, Hải Phòng', N'Hải Phòng', 6500000.00, 2000000.00, 'LUX30', 'PAID', 'MOMO', 1, 0, '2024-10-07 02:02:00');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (13, 83, 'LXR2508240013', N'Lê Quang Phong', 'khachhang062@gmail.com', '0781952058', N'Số 357, Đường Cầu Giấy, Thuận An, Bình Dương', N'Bình Dương', 2100000.00, 0.00, NULL, 'PAID', 'COD', 1, 0, '2025-08-24 01:34:34');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (14, 30, 'LXR2506100014', N'Ngô Văn Hải', 'khachhang009@gmail.com', '0356909670', N'Số 437, Đường Trường Chinh, Dĩ An, Bình Dương', N'Bình Dương', 25000000.00, 2000000.00, 'LUX50', 'PAID', 'VNPAY', 1, 0, '2025-06-10 10:39:23');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (15, 43, 'LXR2503140015', N'Hoàng Mai Hà', 'khachhang022@gmail.com', '0930249947', N'Số 359, Đường Cách Mạng Tháng 8, Phú Nhuận, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 5490000.00, 610000.00, 'LUX10', 'CONFIRMED', 'BANK_TRANSFER', 0, 0, '2025-03-14 21:44:01');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (16, 81, 'LXR2502240016', N'Phạm Đình Bình', 'khachhang060@gmail.com', '0864103697', N'Số 306, Đường Kim Mã, Quận 3, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 5300000.00, 2000000.00, 'LUX50', 'SHIPPING', 'COD', 1, 0, '2025-02-24 04:12:04');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (17, 100, 'LXR2501010017', N'Lý Mai Tú', 'khachhang079@gmail.com', '0703097289', N'Số 17, Đường Hoàng Hoa Thám, Biên Hòa, Đồng Nai', N'Đồng Nai', 30300000.00, 2000000.00, 'LXR36', 'PROCESSING', 'COD', 1, 0, '2025-01-01 12:47:17');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (18, 112, 'LXR2406060018', N'Hồ Tuấn Linh', 'khachhang091@gmail.com', '0341825128', N'Số 373, Đường Phan Chu Trinh, Trảng Bom, Đồng Nai', N'Đồng Nai', 4500000.00, 0.00, NULL, 'SHIPPING', 'BANK_TRANSFER', 1, 0, '2024-06-06 04:32:44');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (19, 47, 'LXR2602090019', N'Ngô Ngọc Nhi', 'khachhang026@gmail.com', '0947127484', N'Số 125, Đường Kim Mã, Long Thành, Đồng Nai', N'Đồng Nai', 4200000.00, 2000000.00, 'LUX50', 'SHIPPING', 'VNPAY', 1, 0, '2026-02-09 18:42:58');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (20, 62, 'LXR2510250020', N'Lê Đức Tùng', 'khachhang041@gmail.com', '0762124998', N'Số 233, Đường Cách Mạng Tháng 8, Bến Cát, Bình Dương', N'Bình Dương', 9775000.00, 1725000.00, 'LXR36', 'PAID', 'BANK_TRANSFER', 1, 0, '2025-10-25 17:31:18');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (21, 80, 'LXR2411240021', N'Bùi Ngọc Mai', 'khachhang059@gmail.com', '0962047277', N'Số 10, Đường Nguyễn Huệ, TP. Huế, Huế', N'Huế', 53800000.00, 0.00, NULL, 'SHIPPING', 'INSTALLMENT', 1, 0, '2024-11-24 00:17:30');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (22, 37, 'LXR2503060022', N'Vũ Tuyết Châu', 'khachhang016@gmail.com', '0378377701', N'Số 355, Đường Trường Chinh, Bình Thủy, Cần Thơ', N'Cần Thơ', 20500000.00, 2000000.00, 'LUX30', 'DELIVERED', 'MOMO', 1, 0, '2025-03-06 14:38:09');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (23, 71, 'LXR2512100023', N'Đỗ Trọng Tài', 'khachhang050@gmail.com', '0963124329', N'Số 91, Đường Nguyễn Huệ, Cẩm Lệ, Đà Nẵng', N'Đà Nẵng', 15120000.00, 1680000.00, 'LUX10', 'PROCESSING', 'BANK_TRANSFER', 1, 0, '2025-12-10 17:05:02');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (24, 103, 'LXR2606130024', N'Đặng Thị Yến', 'khachhang082@gmail.com', '0791574733', N'Số 71, Đường Điện Biên Phủ, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 14800000.00, 2000000.00, 'LUX30', 'PROCESSING', 'INSTALLMENT', 1, 0, '2026-06-13 18:57:04');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (25, 28, 'LXR2509090025', N'Dương Hải Hiền', 'khachhang007@gmail.com', '0399579868', N'Số 231, Đường Kim Mã, Hạ Long, Quảng Ninh', N'Quảng Ninh', 3360000.00, 1440000.00, 'LUX30', 'DELIVERED', 'VNPAY', 1, 0, '2025-09-09 17:57:01');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (26, 86, 'LXR2604080026', N'Đặng Tuấn Khang', 'khachhang065@gmail.com', '0796275705', N'Số 328, Đường Điện Biên Phủ, Hương Thủy, Huế', N'Huế', 16000000.00, 0.00, NULL, 'PENDING', 'COD', 0, 0, '2026-04-08 21:48:48');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (27, 94, 'LXR2404170027', N'Đặng Tuấn Nam', 'khachhang073@gmail.com', '0790276773', N'Số 442, Đường Võ Văn Kiệt, Thuận An, Bình Dương', N'Bình Dương', 2100000.00, 0.00, NULL, 'PAID', 'SEPAY_QR', 1, 0, '2024-04-17 22:34:13');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (28, 43, 'LXR2602090028', N'Hoàng Mai Hà', 'khachhang022@gmail.com', '0930249947', N'Số 359, Đường Cách Mạng Tháng 8, Phú Nhuận, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 7650000.00, 0.00, NULL, 'DELIVERED', 'BANK_TRANSFER', 1, 0, '2026-02-09 10:10:37');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (29, 56, 'LXR2606220029', N'Hồ Trúc Trâm', 'khachhang035@gmail.com', '0331604817', N'Số 422, Đường Trường Chinh, Dĩ An, Bình Dương', N'Bình Dương', 18650000.00, 0.00, NULL, 'CANCELLED', 'MOMO', 0, 1, '2026-06-22 16:27:57');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (30, 76, 'LXR2408070030', N'Nguyễn Quang Bình', 'khachhang055@gmail.com', '0973573322', N'Số 260, Đường Nguyễn Trãi, Bình Thạnh, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 7065000.00, 785000.00, 'LUX10', 'CONFIRMED', 'INSTALLMENT', 0, 0, '2024-08-07 02:21:41');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (31, 55, 'LXR2508240031', N'Đỗ Tuyết Hà', 'khachhang034@gmail.com', '0934562328', N'Số 132, Đường Lý Thường Kiệt, Dĩ An, Bình Dương', N'Bình Dương', 11500000.00, 0.00, NULL, 'CANCELLED', 'VNPAY', 0, 1, '2025-08-24 11:53:29');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (32, 48, 'LXR2608310032', N'Lê Mai Châu', 'khachhang027@gmail.com', '0328404499', N'Số 276, Đường Cầu Giấy, Hạ Long, Quảng Ninh', N'Quảng Ninh', 3420000.00, 380000.00, 'LUX10', 'DELIVERED', 'INSTALLMENT', 1, 0, '2026-08-31 07:23:29');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (33, 43, 'LXR2410030033', N'Hoàng Mai Hà', 'khachhang022@gmail.com', '0930249947', N'Số 359, Đường Cách Mạng Tháng 8, Phú Nhuận, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 17800000.00, 2000000.00, 'LUX30', 'PENDING', 'SEPAY_QR', 0, 0, '2024-10-03 07:03:20');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (34, 43, 'LXR2507160034', N'Hoàng Mai Hà', 'khachhang022@gmail.com', '0930249947', N'Số 359, Đường Cách Mạng Tháng 8, Phú Nhuận, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 2210000.00, 390000.00, 'LXR36', 'SHIPPING', 'INSTALLMENT', 1, 0, '2025-07-16 18:40:52');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (35, 87, 'LXR2407260035', N'Nguyễn Thu Lam', 'khachhang066@gmail.com', '0787021355', N'Số 310, Đường Lê Lợi, Trảng Bom, Đồng Nai', N'Đồng Nai', 45800000.00, 0.00, NULL, 'SHIPPING', 'SEPAY_QR', 1, 0, '2024-07-26 22:15:05');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (36, 40, 'LXR2507140036', N'Lý Tuấn Quân', 'khachhang019@gmail.com', '0322047116', N'Số 78, Đường Lê Lợi, Hạ Long, Quảng Ninh', N'Quảng Ninh', 17550000.00, 0.00, NULL, 'CONFIRMED', 'SEPAY_QR', 0, 0, '2025-07-14 08:38:08');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (37, 102, 'LXR2512040037', N'Lý Hữu Phong', 'khachhang081@gmail.com', '0888434437', N'Số 287, Đường Nguyễn Văn Cừ, Bến Cát, Bình Dương', N'Bình Dương', 1020000.00, 180000.00, 'LXR36', 'SHIPPING', 'COD', 1, 0, '2025-12-04 11:25:50');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (38, 33, 'LXR2511160038', N'Nguyễn Ánh Hà', 'khachhang012@gmail.com', '0862719374', N'Số 399, Đường Nguyễn Trãi, Thuận An, Bình Dương', N'Bình Dương', 24300000.00, 2000000.00, 'LUX30', 'PROCESSING', 'BANK_TRANSFER', 1, 0, '2025-11-16 19:21:55');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (39, 22, 'LXR2407230039', N'Ngô Đình Nhân', 'khachhang001@gmail.com', '0864216073', N'Số 157, Đường Nguyễn Văn Cừ, Kiến An, Hải Phòng', N'Hải Phòng', 5750000.00, 0.00, NULL, 'DELIVERED', 'INSTALLMENT', 1, 0, '2024-07-23 16:34:21');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (40, 76, 'LXR2501240040', N'Nguyễn Quang Bình', 'khachhang055@gmail.com', '0973573322', N'Số 260, Đường Nguyễn Trãi, Bình Thạnh, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 50000000.00, 2000000.00, 'LUX30', 'PAID', 'COD', 1, 0, '2025-01-24 02:23:42');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (41, 38, 'LXR2607280041', N'Ngô Trọng Khoa', 'khachhang017@gmail.com', '0325744431', N'Số 381, Đường Nguyễn Trãi, Lê Chân, Hải Phòng', N'Hải Phòng', 1870000.00, 330000.00, 'LXR36', 'CONFIRMED', 'COD', 0, 0, '2026-07-28 11:18:27');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (42, 80, 'LXR2403260042', N'Bùi Ngọc Mai', 'khachhang059@gmail.com', '0962047277', N'Số 10, Đường Nguyễn Huệ, TP. Huế, Huế', N'Huế', 51700000.00, 0.00, NULL, 'PAID', 'VNPAY', 1, 0, '2024-03-26 07:00:46');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (43, 105, 'LXR2506120043', N'Vũ Mỹ Trang', 'khachhang084@gmail.com', '0976206724', N'Số 291, Đường Cách Mạng Tháng 8, Ba Đình, Hà Nội', N'Hà Nội', 12100000.00, 2000000.00, 'LUX50', 'CONFIRMED', 'SEPAY_QR', 0, 0, '2025-06-12 22:21:42');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (44, 43, 'LXR2405200044', N'Hoàng Mai Hà', 'khachhang022@gmail.com', '0930249947', N'Số 359, Đường Cách Mạng Tháng 8, Phú Nhuận, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 5900000.00, 0.00, NULL, 'PAID', 'COD', 1, 0, '2024-05-20 10:46:10');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (45, 112, 'LXR2407260045', N'Hồ Tuấn Linh', 'khachhang091@gmail.com', '0341825128', N'Số 373, Đường Phan Chu Trinh, Trảng Bom, Đồng Nai', N'Đồng Nai', 10800000.00, 0.00, NULL, 'DELIVERED', 'VNPAY', 1, 0, '2024-07-26 20:42:17');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (46, 88, 'LXR2601210046', N'Đỗ Diệu Mai', 'khachhang067@gmail.com', '0774310278', N'Số 135, Đường Nguyễn Trãi, Trảng Bom, Đồng Nai', N'Đồng Nai', 33000000.00, 2000000.00, 'LXR36', 'CONFIRMED', 'VNPAY', 0, 0, '2026-01-21 09:17:45');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (47, 76, 'LXR2409220047', N'Nguyễn Quang Bình', 'khachhang055@gmail.com', '0973573322', N'Số 260, Đường Nguyễn Trãi, Bình Thạnh, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 14800000.00, 2000000.00, 'LXR36', 'PAID', 'COD', 1, 0, '2024-09-22 07:50:48');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (48, 35, 'LXR2408080048', N'Phạm Anh Sơn', 'khachhang014@gmail.com', '0777262849', N'Số 224, Đường Cầu Giấy, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 50000000.00, 2000000.00, 'LXR36', 'DELIVERED', 'MOMO', 1, 0, '2024-08-08 07:37:55');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (49, 118, 'LXR2409230049', N'Vũ Trọng Khang', 'khachhang097@gmail.com', '0793638546', N'Số 158, Đường Nguyễn Văn Cừ, Uông Bí, Quảng Ninh', N'Quảng Ninh', 22400000.00, 0.00, NULL, 'CONFIRMED', 'INSTALLMENT', 0, 0, '2024-09-23 20:03:04');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (50, 114, 'LXR2501250050', N'Vũ Tuyết Trang', 'khachhang093@gmail.com', '0347383028', N'Số 296, Đường Võ Văn Kiệt, Bình Thủy, Cần Thơ', N'Cần Thơ', 15800000.00, 0.00, NULL, 'PROCESSING', 'INSTALLMENT', 1, 0, '2025-01-25 23:16:58');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (51, 34, 'LXR2410040051', N'Hồ Trọng Hải', 'khachhang013@gmail.com', '0939314919', N'Số 339, Đường Giải Phóng, Thanh Xuân, Hà Nội', N'Hà Nội', 56100000.00, 0.00, NULL, 'PAID', 'VNPAY', 1, 0, '2024-10-04 12:04:05');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (52, 53, 'LXR2505050052', N'Dương Phương Tú', 'khachhang032@gmail.com', '0896474367', N'Số 293, Đường Trường Chinh, Quận 10, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 2500000.00, 2000000.00, 'LUX50', 'PENDING', 'INSTALLMENT', 0, 0, '2025-05-05 06:06:09');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (53, 99, 'LXR2505170053', N'Bùi Ánh Mai', 'khachhang078@gmail.com', '0976949588', N'Số 244, Đường Cách Mạng Tháng 8, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 1500000.00, 0.00, NULL, 'DELIVERED', 'INSTALLMENT', 1, 0, '2025-05-17 14:37:03');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (54, 88, 'LXR2605010054', N'Đỗ Diệu Mai', 'khachhang067@gmail.com', '0774310278', N'Số 135, Đường Nguyễn Trãi, Trảng Bom, Đồng Nai', N'Đồng Nai', 54400000.00, 0.00, NULL, 'DELIVERED', 'SEPAY_QR', 1, 0, '2026-05-01 12:22:41');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (55, 85, 'LXR2510210055', N'Hồ Trọng Quân', 'khachhang064@gmail.com', '0345277584', N'Số 221, Đường Nguyễn Huệ, Tân Bình, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 840000.00, 360000.00, 'LUX30', 'PAID', 'VNPAY', 1, 0, '2025-10-21 10:51:25');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (56, 23, 'LXR2509120056', N'Võ Phương Hiền', 'khachhang002@gmail.com', '0348501429', N'Số 306, Đường Nguyễn Trãi, Ninh Kiều, Cần Thơ', N'Cần Thơ', 1820000.00, 780000.00, 'LUX30', 'PAID', 'MOMO', 1, 0, '2025-09-12 22:43:00');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (57, 109, 'LXR2411240057', N'Ngô Trọng Khoa', 'khachhang088@gmail.com', '0378339187', N'Số 40, Đường Nguyễn Văn Cừ, Yên Phong, Bắc Ninh', N'Bắc Ninh', 27750000.00, 0.00, NULL, 'PAID', 'COD', 1, 0, '2024-11-24 09:20:38');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (58, 72, 'LXR2604260058', N'Bùi Thành Quân', 'khachhang051@gmail.com', '0937744905', N'Số 237, Đường Cách Mạng Tháng 8, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 4850000.00, 0.00, NULL, 'SHIPPING', 'MOMO', 1, 0, '2026-04-26 23:48:44');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (59, 103, 'LXR2606120059', N'Đặng Thị Yến', 'khachhang082@gmail.com', '0791574733', N'Số 71, Đường Điện Biên Phủ, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 12900000.00, 0.00, NULL, 'PAID', 'BANK_TRANSFER', 1, 0, '2026-06-12 12:35:10');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (60, 41, 'LXR2606120060', N'Vũ Đình Khải', 'khachhang020@gmail.com', '0347749649', N'Số 391, Đường Nguyễn Trãi, TP. Huế, Huế', N'Huế', 600000.00, 600000.00, 'LUX50', 'PAID', 'MOMO', 1, 0, '2026-06-12 06:04:30');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (61, 109, 'LXR2406110061', N'Ngô Trọng Khoa', 'khachhang088@gmail.com', '0378339187', N'Số 40, Đường Nguyễn Văn Cừ, Yên Phong, Bắc Ninh', N'Bắc Ninh', 4770000.00, 530000.00, 'LUX10', 'SHIPPING', 'MOMO', 1, 0, '2024-06-11 16:56:56');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (62, 36, 'LXR2602030062', N'Dương Ánh Lam', 'khachhang015@gmail.com', '0786507527', N'Số 175, Đường Điện Biên Phủ, Lê Chân, Hải Phòng', N'Hải Phòng', 52750000.00, 0.00, NULL, 'PAID', 'BANK_TRANSFER', 1, 0, '2026-02-03 06:55:38');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (63, 23, 'LXR2409300063', N'Võ Phương Hiền', 'khachhang002@gmail.com', '0348501429', N'Số 306, Đường Nguyễn Trãi, Ninh Kiều, Cần Thơ', N'Cần Thơ', 10400000.00, 2000000.00, 'LUX30', 'PAID', 'INSTALLMENT', 1, 0, '2024-09-30 03:37:35');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (64, 88, 'LXR2504070064', N'Đỗ Diệu Mai', 'khachhang067@gmail.com', '0774310278', N'Số 135, Đường Nguyễn Trãi, Trảng Bom, Đồng Nai', N'Đồng Nai', 2100000.00, 0.00, NULL, 'DELIVERED', 'SEPAY_QR', 1, 0, '2025-04-07 17:25:38');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (65, 115, 'LXR2408310065', N'Ngô Mai Vy', 'khachhang094@gmail.com', '0918926870', N'Số 357, Đường Võ Văn Kiệt, Bến Cát, Bình Dương', N'Bình Dương', 12200000.00, 0.00, NULL, 'CONFIRMED', 'VNPAY', 0, 0, '2024-08-31 09:28:24');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (66, 55, 'LXR2608130066', N'Đỗ Tuyết Hà', 'khachhang034@gmail.com', '0934562328', N'Số 132, Đường Lý Thường Kiệt, Dĩ An, Bình Dương', N'Bình Dương', 8500000.00, 0.00, NULL, 'CANCELLED', 'INSTALLMENT', 0, 1, '2026-08-13 19:07:57');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (67, 85, 'LXR2607290067', N'Hồ Trọng Quân', 'khachhang064@gmail.com', '0345277584', N'Số 221, Đường Nguyễn Huệ, Tân Bình, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 1470000.00, 630000.00, 'LUX30', 'PAID', 'SEPAY_QR', 1, 0, '2026-07-29 15:02:48');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (68, 108, 'LXR2408270068', N'Đỗ Trọng Phong', 'khachhang087@gmail.com', '0911742684', N'Số 315, Đường Nguyễn Văn Cừ, Bình Thạnh, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 48200000.00, 0.00, NULL, 'PENDING', 'SEPAY_QR', 0, 0, '2024-08-27 03:56:54');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (69, 82, 'LXR2509170069', N'Nguyễn Bảo Sơn', 'khachhang061@gmail.com', '0869621851', N'Số 200, Đường Trần Hưng Đạo, Yên Phong, Bắc Ninh', N'Bắc Ninh', 27800000.00, 0.00, NULL, 'SHIPPING', 'COD', 1, 0, '2025-09-17 10:01:38');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (70, 63, 'LXR2503210070', N'Ngô Khánh Nhi', 'khachhang042@gmail.com', '0355766156', N'Số 79, Đường Nguyễn Văn Cừ, Dĩ An, Bình Dương', N'Bình Dương', 47900000.00, 0.00, NULL, 'DELIVERED', 'COD', 1, 0, '2025-03-21 15:55:20');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (71, 44, 'LXR2502100071', N'Ngô Tuyết Mai', 'khachhang023@gmail.com', '0764013990', N'Số 241, Đường Lý Thường Kiệt, Ninh Kiều, Cần Thơ', N'Cần Thơ', 52900000.00, 0.00, NULL, 'PAID', 'BANK_TRANSFER', 1, 0, '2025-02-10 16:56:31');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (72, 92, 'LXR2602080072', N'Bùi Tuyết Nhi', 'khachhang071@gmail.com', '0338414384', N'Số 315, Đường Cách Mạng Tháng 8, Cẩm Lệ, Đà Nẵng', N'Đà Nẵng', 52000000.00, 0.00, NULL, 'PAID', 'VNPAY', 1, 0, '2026-02-08 12:43:54');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (73, 116, 'LXR2503120073', N'Vũ Xuân Phong', 'khachhang095@gmail.com', '0892708668', N'Số 125, Đường Trường Chinh, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 10540000.00, 1860000.00, 'LXR36', 'PAID', 'COD', 1, 0, '2025-03-12 20:11:12');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (74, 47, 'LXR2606280074', N'Ngô Ngọc Nhi', 'khachhang026@gmail.com', '0947127484', N'Số 125, Đường Kim Mã, Long Thành, Đồng Nai', N'Đồng Nai', 10200000.00, 2000000.00, 'LUX30', 'CONFIRMED', 'SEPAY_QR', 0, 0, '2026-06-28 01:12:19');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (75, 66, 'LXR2403150075', N'Nguyễn Thành Cường', 'khachhang045@gmail.com', '0706120183', N'Số 175, Đường Cầu Giấy, Long Thành, Đồng Nai', N'Đồng Nai', 750000.00, 0.00, NULL, 'PAID', 'MOMO', 1, 0, '2024-03-15 21:43:14');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (76, 115, 'LXR2506210076', N'Ngô Mai Vy', 'khachhang094@gmail.com', '0918926870', N'Số 357, Đường Võ Văn Kiệt, Bến Cát, Bình Dương', N'Bình Dương', 3200000.00, 0.00, NULL, 'PAID', 'VNPAY', 1, 0, '2025-06-21 16:49:39');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (77, 40, 'LXR2505090077', N'Lý Tuấn Quân', 'khachhang019@gmail.com', '0322047116', N'Số 78, Đường Lê Lợi, Hạ Long, Quảng Ninh', N'Quảng Ninh', 4480000.00, 1920000.00, 'LUX30', 'PAID', 'VNPAY', 1, 0, '2025-05-09 16:38:32');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (78, 74, 'LXR2509300078', N'Dương Tiến Khải', 'khachhang053@gmail.com', '0762554665', N'Số 34, Đường Võ Văn Kiệt, TP. Huế, Huế', N'Huế', 22900000.00, 2000000.00, 'LUX30', 'PENDING', 'COD', 0, 0, '2025-09-30 15:30:26');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (79, 94, 'LXR2406050079', N'Đặng Tuấn Nam', 'khachhang073@gmail.com', '0790276773', N'Số 442, Đường Võ Văn Kiệt, Thuận An, Bình Dương', N'Bình Dương', 12600000.00, 2000000.00, 'LXR36', 'CONFIRMED', 'COD', 0, 0, '2024-06-05 18:04:24');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (80, 72, 'LXR2507200080', N'Bùi Thành Quân', 'khachhang051@gmail.com', '0937744905', N'Số 237, Đường Cách Mạng Tháng 8, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 3200000.00, 0.00, NULL, 'SHIPPING', 'MOMO', 1, 0, '2025-07-20 19:32:24');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (81, 39, 'LXR2608260081', N'Phạm Xuân Hải', 'khachhang018@gmail.com', '0893524082', N'Số 284, Đường Lê Lợi, Ninh Kiều, Cần Thơ', N'Cần Thơ', 6100000.00, 0.00, NULL, 'SHIPPING', 'VNPAY', 1, 0, '2026-08-26 07:29:44');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (82, 74, 'LXR2409040082', N'Dương Tiến Khải', 'khachhang053@gmail.com', '0762554665', N'Số 34, Đường Võ Văn Kiệt, TP. Huế, Huế', N'Huế', 1450000.00, 0.00, NULL, 'SHIPPING', 'BANK_TRANSFER', 1, 0, '2024-09-04 13:23:30');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (83, 81, 'LXR2504160083', N'Phạm Đình Bình', 'khachhang060@gmail.com', '0864103697', N'Số 306, Đường Kim Mã, Quận 3, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 750000.00, 0.00, NULL, 'DELIVERED', 'VNPAY', 1, 0, '2025-04-16 16:12:41');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (84, 111, 'LXR2405020084', N'Hồ Mai Linh', 'khachhang090@gmail.com', '0989106518', N'Số 17, Đường Kim Mã, Cầu Giấy, Hà Nội', N'Hà Nội', 43200000.00, 0.00, NULL, 'CONFIRMED', 'SEPAY_QR', 0, 0, '2024-05-02 15:36:15');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (85, 72, 'LXR2605070085', N'Bùi Thành Quân', 'khachhang051@gmail.com', '0937744905', N'Số 237, Đường Cách Mạng Tháng 8, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 7380000.00, 820000.00, 'LUX10', 'PAID', 'VNPAY', 1, 0, '2026-05-07 15:09:51');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (86, 93, 'LXR2607030086', N'Bùi Trúc Tú', 'khachhang072@gmail.com', '0910109439', N'Số 255, Đường Trần Hưng Đạo, Trảng Bom, Đồng Nai', N'Đồng Nai', 11500000.00, 0.00, NULL, 'PAID', 'SEPAY_QR', 1, 0, '2026-07-03 13:59:36');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (87, 37, 'LXR2403190087', N'Vũ Tuyết Châu', 'khachhang016@gmail.com', '0378377701', N'Số 355, Đường Trường Chinh, Bình Thủy, Cần Thơ', N'Cần Thơ', 9400000.00, 2000000.00, 'LUX50', 'DELIVERED', 'VNPAY', 1, 0, '2024-03-19 13:47:11');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (88, 102, 'LXR2407090088', N'Lý Hữu Phong', 'khachhang081@gmail.com', '0888434437', N'Số 287, Đường Nguyễn Văn Cừ, Bến Cát, Bình Dương', N'Bình Dương', 35100000.00, 2000000.00, 'LUX50', 'SHIPPING', 'BANK_TRANSFER', 1, 0, '2024-07-09 13:13:00');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (89, 78, 'LXR2409170089', N'Đỗ Hải Tú', 'khachhang057@gmail.com', '0367468862', N'Số 447, Đường Phan Chu Trinh, Hải An, Hải Phòng', N'Hải Phòng', 113900000.00, 2000000.00, 'LUX10', 'SHIPPING', 'VNPAY', 1, 0, '2024-09-17 01:41:49');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (90, 114, 'LXR2511040090', N'Vũ Tuyết Trang', 'khachhang093@gmail.com', '0347383028', N'Số 296, Đường Võ Văn Kiệt, Bình Thủy, Cần Thơ', N'Cần Thơ', 750000.00, 0.00, NULL, 'CANCELLED', 'COD', 0, 1, '2025-11-04 14:37:06');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (91, 49, 'LXR2412160091', N'Vũ Ánh Ngọc', 'khachhang028@gmail.com', '0866057662', N'Số 258, Đường Phan Chu Trinh, Hạ Long, Quảng Ninh', N'Quảng Ninh', 6200000.00, 2000000.00, 'LUX30', 'DELIVERED', 'MOMO', 1, 0, '2024-12-16 17:29:57');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (92, 100, 'LXR2503170092', N'Lý Mai Tú', 'khachhang079@gmail.com', '0703097289', N'Số 17, Đường Hoàng Hoa Thám, Biên Hòa, Đồng Nai', N'Đồng Nai', 22400000.00, 2000000.00, 'LUX10', 'DELIVERED', 'INSTALLMENT', 1, 0, '2025-03-17 19:31:14');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (93, 29, 'LXR2407150093', N'Vũ Minh Quân', 'khachhang008@gmail.com', '0934345581', N'Số 197, Đường Hoàng Hoa Thám, Thanh Khê, Đà Nẵng', N'Đà Nẵng', 10370000.00, 1830000.00, 'LXR36', 'PROCESSING', 'MOMO', 1, 0, '2024-07-15 06:29:47');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (94, 89, 'LXR2503230094', N'Phạm Thu Hương', 'khachhang068@gmail.com', '0362715518', N'Số 436, Đường Cách Mạng Tháng 8, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 34800000.00, 2000000.00, 'LUX10', 'SHIPPING', 'INSTALLMENT', 1, 0, '2025-03-23 00:54:05');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (95, 66, 'LXR2607270095', N'Nguyễn Thành Cường', 'khachhang045@gmail.com', '0706120183', N'Số 175, Đường Cầu Giấy, Long Thành, Đồng Nai', N'Đồng Nai', 2100000.00, 0.00, NULL, 'PAID', 'BANK_TRANSFER', 1, 0, '2026-07-27 17:00:07');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (96, 98, 'LXR2502040096', N'Hoàng Ngọc Ngọc', 'khachhang077@gmail.com', '0335852398', N'Số 24, Đường Lê Lợi, Trảng Bom, Đồng Nai', N'Đồng Nai', 18750000.00, 2000000.00, 'LUX30', 'CANCELLED', 'VNPAY', 0, 1, '2025-02-04 05:39:52');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (97, 51, 'LXR2411030097', N'Vũ Trọng Nam', 'khachhang030@gmail.com', '0351172400', N'Số 184, Đường Cách Mạng Tháng 8, Thủ Dầu Một, Bình Dương', N'Bình Dương', 2720000.00, 480000.00, 'LXR36', 'PROCESSING', 'VNPAY', 1, 0, '2024-11-03 23:14:39');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (98, 116, 'LXR2405260098', N'Vũ Xuân Phong', 'khachhang095@gmail.com', '0892708668', N'Số 125, Đường Trường Chinh, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 78600000.00, 0.00, NULL, 'SHIPPING', 'SEPAY_QR', 1, 0, '2024-05-26 20:25:32');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (99, 44, 'LXR2503030099', N'Ngô Tuyết Mai', 'khachhang023@gmail.com', '0764013990', N'Số 241, Đường Lý Thường Kiệt, Ninh Kiều, Cần Thơ', N'Cần Thơ', 1470000.00, 630000.00, 'LUX30', 'PROCESSING', 'BANK_TRANSFER', 1, 0, '2025-03-03 11:15:55');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (100, 25, 'LXR2508290100', N'Đặng Tiến Cường', 'khachhang004@gmail.com', '0986629946', N'Số 147, Đường Cách Mạng Tháng 8, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 6660000.00, 740000.00, 'LUX10', 'CANCELLED', 'BANK_TRANSFER', 0, 1, '2025-08-29 07:39:38');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (101, 91, 'LXR2506240101', N'Lê Thành Tùng', 'khachhang070@gmail.com', '0771778528', N'Số 222, Đường Phan Chu Trinh, TP. Huế, Huế', N'Huế', 8800000.00, 2000000.00, 'LUX30', 'PAID', 'SEPAY_QR', 1, 0, '2025-06-24 02:20:01');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (102, 50, 'LXR2403310102', N'Hoàng Diệu Hà', 'khachhang029@gmail.com', '0937459615', N'Số 321, Đường Võ Văn Kiệt, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 70000000.00, 0.00, NULL, 'DELIVERED', 'BANK_TRANSFER', 1, 0, '2024-03-31 22:58:09');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (103, 38, 'LXR2508120103', N'Ngô Trọng Khoa', 'khachhang017@gmail.com', '0325744431', N'Số 381, Đường Nguyễn Trãi, Lê Chân, Hải Phòng', N'Hải Phòng', 35000000.00, 0.00, NULL, 'PAID', 'INSTALLMENT', 1, 0, '2025-08-12 08:25:04');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (104, 97, 'LXR2410070104', N'Ngô Thu Vy', 'khachhang076@gmail.com', '0336506098', N'Số 38, Đường Cách Mạng Tháng 8, Lê Chân, Hải Phòng', N'Hải Phòng', 42100000.00, 2000000.00, 'LUX10', 'SHIPPING', 'VNPAY', 1, 0, '2024-10-07 01:11:38');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (105, 97, 'LXR2408040105', N'Ngô Thu Vy', 'khachhang076@gmail.com', '0336506098', N'Số 38, Đường Cách Mạng Tháng 8, Lê Chân, Hải Phòng', N'Hải Phòng', 14400000.00, 2000000.00, 'LUX50', 'SHIPPING', 'MOMO', 1, 0, '2024-08-04 22:45:08');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (106, 77, 'LXR2603270106', N'Hồ Thu Anh', 'khachhang056@gmail.com', '0979270653', N'Số 386, Đường Cách Mạng Tháng 8, Uông Bí, Quảng Ninh', N'Quảng Ninh', 5600000.00, 2000000.00, 'LUX50', 'PAID', 'INSTALLMENT', 1, 0, '2026-03-27 20:07:59');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (107, 100, 'LXR2509060107', N'Lý Mai Tú', 'khachhang079@gmail.com', '0703097289', N'Số 17, Đường Hoàng Hoa Thám, Biên Hòa, Đồng Nai', N'Đồng Nai', 22900000.00, 0.00, NULL, 'SHIPPING', 'SEPAY_QR', 1, 0, '2025-09-06 07:25:14');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (108, 44, 'LXR2403030108', N'Ngô Tuyết Mai', 'khachhang023@gmail.com', '0764013990', N'Số 241, Đường Lý Thường Kiệt, Ninh Kiều, Cần Thơ', N'Cần Thơ', 21450000.00, 2000000.00, 'LUX30', 'DELIVERED', 'INSTALLMENT', 1, 0, '2024-03-03 19:01:50');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (109, 50, 'LXR2607270109', N'Hoàng Diệu Hà', 'khachhang029@gmail.com', '0937459615', N'Số 321, Đường Võ Văn Kiệt, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 43300000.00, 2000000.00, 'LUX50', 'CONFIRMED', 'VNPAY', 0, 0, '2026-07-27 13:14:29');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (110, 33, 'LXR2508040110', N'Nguyễn Ánh Hà', 'khachhang012@gmail.com', '0862719374', N'Số 399, Đường Nguyễn Trãi, Thuận An, Bình Dương', N'Bình Dương', 4800000.00, 0.00, NULL, 'DELIVERED', 'COD', 1, 0, '2025-08-04 13:38:50');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (111, 66, 'LXR2504030111', N'Nguyễn Thành Cường', 'khachhang045@gmail.com', '0706120183', N'Số 175, Đường Cầu Giấy, Long Thành, Đồng Nai', N'Đồng Nai', 34000000.00, 0.00, NULL, 'PENDING', 'VNPAY', 0, 0, '2025-04-03 16:54:05');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (112, 74, 'LXR2604050112', N'Dương Tiến Khải', 'khachhang053@gmail.com', '0762554665', N'Số 34, Đường Võ Văn Kiệt, TP. Huế, Huế', N'Huế', 15120000.00, 1680000.00, 'LUX10', 'PAID', 'COD', 1, 0, '2026-04-05 23:25:44');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (113, 95, 'LXR2502140113', N'Bùi Thanh Duyên', 'khachhang074@gmail.com', '0944732104', N'Số 128, Đường Giải Phóng, Trảng Bom, Đồng Nai', N'Đồng Nai', 17200000.00, 0.00, NULL, 'SHIPPING', 'SEPAY_QR', 1, 0, '2025-02-14 10:20:01');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (114, 55, 'LXR2408100114', N'Đỗ Tuyết Hà', 'khachhang034@gmail.com', '0934562328', N'Số 132, Đường Lý Thường Kiệt, Dĩ An, Bình Dương', N'Bình Dương', 16800000.00, 0.00, NULL, 'PAID', 'VNPAY', 1, 0, '2024-08-10 16:25:58');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (115, 92, 'LXR2407230115', N'Bùi Tuyết Nhi', 'khachhang071@gmail.com', '0338414384', N'Số 315, Đường Cách Mạng Tháng 8, Cẩm Lệ, Đà Nẵng', N'Đà Nẵng', 6000000.00, 2000000.00, 'LUX50', 'PAID', 'MOMO', 1, 0, '2024-07-23 15:11:39');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (116, 43, 'LXR2601040116', N'Hoàng Mai Hà', 'khachhang022@gmail.com', '0930249947', N'Số 359, Đường Cách Mạng Tháng 8, Phú Nhuận, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 35000000.00, 0.00, NULL, 'PAID', 'SEPAY_QR', 1, 0, '2026-01-04 12:09:49');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (117, 74, 'LXR2607090117', N'Dương Tiến Khải', 'khachhang053@gmail.com', '0762554665', N'Số 34, Đường Võ Văn Kiệt, TP. Huế, Huế', N'Huế', 5350000.00, 2000000.00, 'LUX30', 'PAID', 'INSTALLMENT', 1, 0, '2026-07-09 18:48:31');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (118, 92, 'LXR2604020118', N'Bùi Tuyết Nhi', 'khachhang071@gmail.com', '0338414384', N'Số 315, Đường Cách Mạng Tháng 8, Cẩm Lệ, Đà Nẵng', N'Đà Nẵng', 15500000.00, 0.00, NULL, 'PAID', 'SEPAY_QR', 1, 0, '2026-04-02 15:52:42');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (119, 106, 'LXR2603170119', N'Hoàng Xuân Khải', 'khachhang085@gmail.com', '0364315274', N'Số 405, Đường Võ Văn Kiệt, Hải Châu, Đà Nẵng', N'Đà Nẵng', 4800000.00, 0.00, NULL, 'PROCESSING', 'SEPAY_QR', 1, 0, '2026-03-17 03:56:26');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (120, 32, 'LXR2603060120', N'Phan Tuấn Tùng', 'khachhang011@gmail.com', '0326464170', N'Số 115, Đường Nguyễn Văn Cừ, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 14800000.00, 2000000.00, 'LUX50', 'PENDING', 'VNPAY', 0, 0, '2026-03-06 15:59:36');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (121, 55, 'LXR2407200121', N'Đỗ Tuyết Hà', 'khachhang034@gmail.com', '0934562328', N'Số 132, Đường Lý Thường Kiệt, Dĩ An, Bình Dương', N'Bình Dương', 32700000.00, 2000000.00, 'LUX10', 'CONFIRMED', 'INSTALLMENT', 0, 0, '2024-07-20 13:49:44');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (122, 27, 'LXR2504140122', N'Ngô Gia Phúc', 'khachhang006@gmail.com', '0986763201', N'Số 412, Đường Lý Thường Kiệt, Biên Hòa, Đồng Nai', N'Đồng Nai', 2240000.00, 960000.00, 'LUX30', 'DELIVERED', 'COD', 1, 0, '2025-04-14 00:23:06');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (123, 29, 'LXR2410210123', N'Vũ Minh Quân', 'khachhang008@gmail.com', '0934345581', N'Số 197, Đường Hoàng Hoa Thám, Thanh Khê, Đà Nẵng', N'Đà Nẵng', 9817500.00, 1732500.00, 'LXR36', 'DELIVERED', 'INSTALLMENT', 1, 0, '2024-10-21 18:33:35');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (124, 97, 'LXR2502170124', N'Ngô Thu Vy', 'khachhang076@gmail.com', '0336506098', N'Số 38, Đường Cách Mạng Tháng 8, Lê Chân, Hải Phòng', N'Hải Phòng', 15120000.00, 1680000.00, 'LUX10', 'PENDING', 'BANK_TRANSFER', 0, 0, '2025-02-17 10:17:25');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (125, 90, 'LXR2603080125', N'Phạm Thanh Hà', 'khachhang069@gmail.com', '0867058957', N'Số 34, Đường Nguyễn Huệ, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 119000000.00, 2000000.00, 'LUX30', 'PAID', 'BANK_TRANSFER', 1, 0, '2026-03-08 14:44:10');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (126, 88, 'LXR2608050126', N'Đỗ Diệu Mai', 'khachhang067@gmail.com', '0774310278', N'Số 135, Đường Nguyễn Trãi, Trảng Bom, Đồng Nai', N'Đồng Nai', 32650000.00, 0.00, NULL, 'DELIVERED', 'INSTALLMENT', 1, 0, '2026-08-05 18:31:12');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (127, 46, 'LXR2409130127', N'Dương Diệu Trang', 'khachhang025@gmail.com', '0988597703', N'Số 225, Đường Cách Mạng Tháng 8, Bình Thủy, Cần Thơ', N'Cần Thơ', 750000.00, 0.00, NULL, 'PROCESSING', 'VNPAY', 1, 0, '2024-09-13 00:33:18');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (128, 102, 'LXR2410160128', N'Lý Hữu Phong', 'khachhang081@gmail.com', '0888434437', N'Số 287, Đường Nguyễn Văn Cừ, Bến Cát, Bình Dương', N'Bình Dương', 4200000.00, 0.00, NULL, 'DELIVERED', 'BANK_TRANSFER', 1, 0, '2024-10-16 17:18:02');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (129, 33, 'LXR2510240129', N'Nguyễn Ánh Hà', 'khachhang012@gmail.com', '0862719374', N'Số 399, Đường Nguyễn Trãi, Thuận An, Bình Dương', N'Bình Dương', 68000000.00, 2000000.00, 'LUX30', 'CONFIRMED', 'BANK_TRANSFER', 0, 0, '2025-10-24 21:23:06');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (130, 80, 'LXR2403200130', N'Bùi Ngọc Mai', 'khachhang059@gmail.com', '0962047277', N'Số 10, Đường Nguyễn Huệ, TP. Huế, Huế', N'Huế', 13600000.00, 2000000.00, 'LUX30', 'DELIVERED', 'INSTALLMENT', 1, 0, '2024-03-20 04:57:20');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (131, 97, 'LXR2608230131', N'Ngô Thu Vy', 'khachhang076@gmail.com', '0336506098', N'Số 38, Đường Cách Mạng Tháng 8, Lê Chân, Hải Phòng', N'Hải Phòng', 26500000.00, 2000000.00, 'LUX10', 'PENDING', 'VNPAY', 0, 0, '2026-08-23 03:46:34');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (132, 55, 'LXR2510170132', N'Đỗ Tuyết Hà', 'khachhang034@gmail.com', '0934562328', N'Số 132, Đường Lý Thường Kiệt, Dĩ An, Bình Dương', N'Bình Dương', 1800000.00, 0.00, NULL, 'PAID', 'INSTALLMENT', 1, 0, '2025-10-17 00:53:44');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (133, 57, 'LXR2511160133', N'Vũ Gia Nam', 'khachhang036@gmail.com', '0777461200', N'Số 50, Đường Nguyễn Trãi, Ô Môn, Cần Thơ', N'Cần Thơ', 4550000.00, 0.00, NULL, 'PROCESSING', 'SEPAY_QR', 1, 0, '2025-11-16 23:57:29');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (134, 110, 'LXR2503050134', N'Bùi Trúc Hiền', 'khachhang089@gmail.com', '0361397187', N'Số 263, Đường Phan Chu Trinh, Nam Từ Liêm, Hà Nội', N'Hà Nội', 24600000.00, 0.00, NULL, 'CONFIRMED', 'VNPAY', 0, 0, '2025-03-05 01:35:53');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (135, 61, 'LXR2505100135', N'Lý Khánh Hằng', 'khachhang040@gmail.com', '0389178390', N'Số 330, Đường Cầu Giấy, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 24950000.00, 2000000.00, 'LXR36', 'PROCESSING', 'COD', 1, 0, '2025-05-10 12:04:50');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (136, 63, 'LXR2504230136', N'Ngô Khánh Nhi', 'khachhang042@gmail.com', '0355766156', N'Số 79, Đường Nguyễn Văn Cừ, Dĩ An, Bình Dương', N'Bình Dương', 1080000.00, 120000.00, 'LUX10', 'PAID', 'INSTALLMENT', 1, 0, '2025-04-23 12:42:17');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (137, 49, 'LXR2511230137', N'Vũ Ánh Ngọc', 'khachhang028@gmail.com', '0866057662', N'Số 258, Đường Phan Chu Trinh, Hạ Long, Quảng Ninh', N'Quảng Ninh', 5780000.00, 1020000.00, 'LXR36', 'PAID', 'INSTALLMENT', 1, 0, '2025-11-23 12:24:40');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (138, 29, 'LXR2605100138', N'Vũ Minh Quân', 'khachhang008@gmail.com', '0934345581', N'Số 197, Đường Hoàng Hoa Thám, Thanh Khê, Đà Nẵng', N'Đà Nẵng', 3800000.00, 0.00, NULL, 'CANCELLED', 'SEPAY_QR', 0, 1, '2026-05-10 10:38:48');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (139, 121, 'LXR2605240139', N'Vũ Ngọc Hà', 'khachhang100@gmail.com', '0903875099', N'Số 9, Đường Kim Mã, Uông Bí, Quảng Ninh', N'Quảng Ninh', 9600000.00, 0.00, NULL, 'DELIVERED', 'BANK_TRANSFER', 1, 0, '2026-05-24 10:48:24');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (140, 29, 'LXR2503230140', N'Vũ Minh Quân', 'khachhang008@gmail.com', '0934345581', N'Số 197, Đường Hoàng Hoa Thám, Thanh Khê, Đà Nẵng', N'Đà Nẵng', 22500000.00, 0.00, NULL, 'PENDING', 'VNPAY', 0, 0, '2025-03-23 13:40:16');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (141, 69, 'LXR2602200141', N'Đỗ Ngọc Ngọc', 'khachhang048@gmail.com', '0916071596', N'Số 149, Đường Giải Phóng, Hương Thủy, Huế', N'Huế', 11500000.00, 0.00, NULL, 'PROCESSING', 'BANK_TRANSFER', 1, 0, '2026-02-20 03:19:07');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (142, 69, 'LXR2603300142', N'Đỗ Ngọc Ngọc', 'khachhang048@gmail.com', '0916071596', N'Số 149, Đường Giải Phóng, Hương Thủy, Huế', N'Huế', 6200000.00, 0.00, NULL, 'CONFIRMED', 'BANK_TRANSFER', 0, 0, '2026-03-30 07:17:25');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (143, 66, 'LXR2411100143', N'Nguyễn Thành Cường', 'khachhang045@gmail.com', '0706120183', N'Số 175, Đường Cầu Giấy, Long Thành, Đồng Nai', N'Đồng Nai', 14600000.00, 0.00, NULL, 'DELIVERED', 'MOMO', 1, 0, '2024-11-10 00:13:45');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (144, 95, 'LXR2501270144', N'Bùi Thanh Duyên', 'khachhang074@gmail.com', '0944732104', N'Số 128, Đường Giải Phóng, Trảng Bom, Đồng Nai', N'Đồng Nai', 5550000.00, 0.00, NULL, 'PAID', 'SEPAY_QR', 1, 0, '2025-01-27 22:22:33');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (145, 121, 'LXR2403140145', N'Vũ Ngọc Hà', 'khachhang100@gmail.com', '0903875099', N'Số 9, Đường Kim Mã, Uông Bí, Quảng Ninh', N'Quảng Ninh', 9100000.00, 0.00, NULL, 'PAID', 'COD', 1, 0, '2024-03-14 19:44:27');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (146, 113, 'LXR2505020146', N'Hồ Xuân Phong', 'khachhang092@gmail.com', '0867524310', N'Số 124, Đường Trần Hưng Đạo, Trảng Bom, Đồng Nai', N'Đồng Nai', 31100000.00, 2000000.00, 'LUX30', 'DELIVERED', 'COD', 1, 0, '2025-05-02 18:51:24');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (147, 72, 'LXR2608250147', N'Bùi Thành Quân', 'khachhang051@gmail.com', '0937744905', N'Số 237, Đường Cách Mạng Tháng 8, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 1275000.00, 225000.00, 'LXR36', 'PROCESSING', 'VNPAY', 1, 0, '2026-08-25 23:15:38');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (148, 69, 'LXR2607210148', N'Đỗ Ngọc Ngọc', 'khachhang048@gmail.com', '0916071596', N'Số 149, Đường Giải Phóng, Hương Thủy, Huế', N'Huế', 52750000.00, 0.00, NULL, 'CONFIRMED', 'INSTALLMENT', 0, 0, '2026-07-21 04:38:18');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (149, 103, 'LXR2507190149', N'Đặng Thị Yến', 'khachhang082@gmail.com', '0791574733', N'Số 71, Đường Điện Biên Phủ, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 5600000.00, 2000000.00, 'LUX50', 'PAID', 'MOMO', 1, 0, '2025-07-19 01:59:18');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (150, 60, 'LXR2412180150', N'Võ Trúc Hà', 'khachhang039@gmail.com', '0968421020', N'Số 9, Đường Võ Văn Kiệt, Thuận An, Bình Dương', N'Bình Dương', 18400000.00, 2000000.00, 'LUX30', 'PAID', 'SEPAY_QR', 1, 0, '2024-12-18 14:34:22');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (151, 73, 'LXR2507100151', N'Dương Bảo Khoa', 'khachhang052@gmail.com', '0917935978', N'Số 53, Đường Cầu Giấy, Hải Châu, Đà Nẵng', N'Đà Nẵng', 15500000.00, 0.00, NULL, 'PAID', 'INSTALLMENT', 1, 0, '2025-07-10 11:01:11');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (152, 55, 'LXR2512110152', N'Đỗ Tuyết Hà', 'khachhang034@gmail.com', '0934562328', N'Số 132, Đường Lý Thường Kiệt, Dĩ An, Bình Dương', N'Bình Dương', 15200000.00, 2000000.00, 'LUX30', 'CONFIRMED', 'COD', 0, 0, '2025-12-11 05:15:35');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (153, 46, 'LXR2508160153', N'Dương Diệu Trang', 'khachhang025@gmail.com', '0988597703', N'Số 225, Đường Cách Mạng Tháng 8, Bình Thủy, Cần Thơ', N'Cần Thơ', 3250000.00, 2000000.00, 'LUX50', 'PENDING', 'INSTALLMENT', 0, 0, '2025-08-16 02:11:41');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (154, 67, 'LXR2604280154', N'Trần Thu Anh', 'khachhang046@gmail.com', '0760147679', N'Số 111, Đường Điện Biên Phủ, Cẩm Phả, Quảng Ninh', N'Quảng Ninh', 5250000.00, 0.00, NULL, 'PROCESSING', 'MOMO', 1, 0, '2026-04-28 02:04:07');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (155, 116, 'LXR2504060155', N'Vũ Xuân Phong', 'khachhang095@gmail.com', '0892708668', N'Số 125, Đường Trường Chinh, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 13100000.00, 2000000.00, 'LUX50', 'DELIVERED', 'INSTALLMENT', 1, 0, '2025-04-06 19:14:23');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (156, 33, 'LXR2502090156', N'Nguyễn Ánh Hà', 'khachhang012@gmail.com', '0862719374', N'Số 399, Đường Nguyễn Trãi, Thuận An, Bình Dương', N'Bình Dương', 52000000.00, 0.00, NULL, 'SHIPPING', 'MOMO', 1, 0, '2025-02-09 06:12:41');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (157, 69, 'LXR2504090157', N'Đỗ Ngọc Ngọc', 'khachhang048@gmail.com', '0916071596', N'Số 149, Đường Giải Phóng, Hương Thủy, Huế', N'Huế', 9775000.00, 1725000.00, 'LXR36', 'SHIPPING', 'BANK_TRANSFER', 1, 0, '2025-04-09 18:21:08');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (158, 103, 'LXR2608240158', N'Đặng Thị Yến', 'khachhang082@gmail.com', '0791574733', N'Số 71, Đường Điện Biên Phủ, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 28000000.00, 0.00, NULL, 'PAID', 'BANK_TRANSFER', 1, 0, '2026-08-24 13:14:19');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (159, 74, 'LXR2405230159', N'Dương Tiến Khải', 'khachhang053@gmail.com', '0762554665', N'Số 34, Đường Võ Văn Kiệt, TP. Huế, Huế', N'Huế', 3360000.00, 1440000.00, 'LUX30', 'PAID', 'SEPAY_QR', 1, 0, '2024-05-23 23:34:34');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (160, 80, 'LXR2410090160', N'Bùi Ngọc Mai', 'khachhang059@gmail.com', '0962047277', N'Số 10, Đường Nguyễn Huệ, TP. Huế, Huế', N'Huế', 16350000.00, 2000000.00, 'LUX50', 'PAID', 'MOMO', 1, 0, '2024-10-09 11:47:00');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (161, 29, 'LXR2403080161', N'Vũ Minh Quân', 'khachhang008@gmail.com', '0934345581', N'Số 197, Đường Hoàng Hoa Thám, Thanh Khê, Đà Nẵng', N'Đà Nẵng', 1015000.00, 435000.00, 'LUX30', 'PAID', 'COD', 1, 0, '2024-03-08 07:43:55');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (162, 119, 'LXR2411020162', N'Bùi Hữu Sơn', 'khachhang098@gmail.com', '0326093204', N'Số 152, Đường Giải Phóng, Yên Phong, Bắc Ninh', N'Bắc Ninh', 11025000.00, 1225000.00, 'LUX10', 'SHIPPING', 'COD', 1, 0, '2024-11-02 02:53:21');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (163, 73, 'LXR2512270163', N'Dương Bảo Khoa', 'khachhang052@gmail.com', '0917935978', N'Số 53, Đường Cầu Giấy, Hải Châu, Đà Nẵng', N'Đà Nẵng', 15200000.00, 2000000.00, 'LUX50', 'CONFIRMED', 'COD', 0, 0, '2025-12-27 11:13:40');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (164, 69, 'LXR2403220164', N'Đỗ Ngọc Ngọc', 'khachhang048@gmail.com', '0916071596', N'Số 149, Đường Giải Phóng, Hương Thủy, Huế', N'Huế', 6200000.00, 2000000.00, 'LUX50', 'DELIVERED', 'MOMO', 1, 0, '2024-03-22 20:49:58');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (165, 53, 'LXR2502150165', N'Dương Phương Tú', 'khachhang032@gmail.com', '0896474367', N'Số 293, Đường Trường Chinh, Quận 10, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 69700000.00, 2000000.00, 'LXR36', 'DELIVERED', 'INSTALLMENT', 1, 0, '2025-02-15 11:47:49');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (166, 27, 'LXR2506070166', N'Ngô Gia Phúc', 'khachhang006@gmail.com', '0986763201', N'Số 412, Đường Lý Thường Kiệt, Biên Hòa, Đồng Nai', N'Đồng Nai', 3400000.00, 0.00, NULL, 'PROCESSING', 'MOMO', 1, 0, '2025-06-07 05:47:08');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (167, 77, 'LXR2409240167', N'Hồ Thu Anh', 'khachhang056@gmail.com', '0979270653', N'Số 386, Đường Cách Mạng Tháng 8, Uông Bí, Quảng Ninh', N'Quảng Ninh', 52100000.00, 2000000.00, 'LUX10', 'PAID', 'MOMO', 1, 0, '2024-09-24 20:01:53');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (168, 24, 'LXR2502180168', N'Phan Minh Dũng', 'khachhang003@gmail.com', '0796088356', N'Số 340, Đường Võ Văn Kiệt, Gò Vấp, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 13000000.00, 0.00, NULL, 'PAID', 'SEPAY_QR', 1, 0, '2025-02-18 20:03:03');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (169, 37, 'LXR2509210169', N'Vũ Tuyết Châu', 'khachhang016@gmail.com', '0378377701', N'Số 355, Đường Trường Chinh, Bình Thủy, Cần Thơ', N'Cần Thơ', 49200000.00, 2000000.00, 'LUX30', 'PROCESSING', 'INSTALLMENT', 1, 0, '2025-09-21 11:31:11');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (170, 101, 'LXR2405150170', N'Ngô Tuyết Huyền', 'khachhang080@gmail.com', '0358970283', N'Số 270, Đường Kim Mã, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 12105000.00, 1345000.00, 'LUX10', 'PROCESSING', 'BANK_TRANSFER', 1, 0, '2024-05-15 11:27:11');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (171, 70, 'LXR2409080171', N'Lê Anh Long', 'khachhang049@gmail.com', '0866968164', N'Số 399, Đường Võ Văn Kiệt, Thuận An, Bình Dương', N'Bình Dương', 1900000.00, 1900000.00, 'LUX50', 'CANCELLED', 'BANK_TRANSFER', 0, 1, '2024-09-08 23:57:28');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (172, 109, 'LXR2403150172', N'Ngô Trọng Khoa', 'khachhang088@gmail.com', '0378339187', N'Số 40, Đường Nguyễn Văn Cừ, Yên Phong, Bắc Ninh', N'Bắc Ninh', 11500000.00, 0.00, NULL, 'DELIVERED', 'MOMO', 1, 0, '2024-03-15 10:53:55');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (173, 101, 'LXR2409300173', N'Ngô Tuyết Huyền', 'khachhang080@gmail.com', '0358970283', N'Số 270, Đường Kim Mã, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 14900000.00, 0.00, NULL, 'PAID', 'COD', 1, 0, '2024-09-30 01:49:36');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (174, 35, 'LXR2604130174', N'Phạm Anh Sơn', 'khachhang014@gmail.com', '0777262849', N'Số 224, Đường Cầu Giấy, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 5650000.00, 0.00, NULL, 'DELIVERED', 'SEPAY_QR', 1, 0, '2026-04-13 05:03:26');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (175, 112, 'LXR2511270175', N'Hồ Tuấn Linh', 'khachhang091@gmail.com', '0341825128', N'Số 373, Đường Phan Chu Trinh, Trảng Bom, Đồng Nai', N'Đồng Nai', 4500000.00, 0.00, NULL, 'CONFIRMED', 'MOMO', 0, 0, '2025-11-27 12:49:10');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (176, 110, 'LXR2603170176', N'Bùi Trúc Hiền', 'khachhang089@gmail.com', '0361397187', N'Số 263, Đường Phan Chu Trinh, Nam Từ Liêm, Hà Nội', N'Hà Nội', 15500000.00, 0.00, NULL, 'SHIPPING', 'MOMO', 1, 0, '2026-03-17 16:27:02');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (177, 95, 'LXR2604070177', N'Bùi Thanh Duyên', 'khachhang074@gmail.com', '0944732104', N'Số 128, Đường Giải Phóng, Trảng Bom, Đồng Nai', N'Đồng Nai', 15650000.00, 0.00, NULL, 'SHIPPING', 'SEPAY_QR', 1, 0, '2026-04-07 13:32:00');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (178, 80, 'LXR2506030178', N'Bùi Ngọc Mai', 'khachhang059@gmail.com', '0962047277', N'Số 10, Đường Nguyễn Huệ, TP. Huế, Huế', N'Huế', 9775000.00, 1725000.00, 'LXR36', 'DELIVERED', 'MOMO', 1, 0, '2025-06-03 20:30:24');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (179, 27, 'LXR2505260179', N'Ngô Gia Phúc', 'khachhang006@gmail.com', '0986763201', N'Số 412, Đường Lý Thường Kiệt, Biên Hòa, Đồng Nai', N'Đồng Nai', 45200000.00, 2000000.00, 'LXR36', 'PAID', 'MOMO', 1, 0, '2025-05-26 09:07:46');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (180, 27, 'LXR2403160180', N'Ngô Gia Phúc', 'khachhang006@gmail.com', '0986763201', N'Số 412, Đường Lý Thường Kiệt, Biên Hòa, Đồng Nai', N'Đồng Nai', 39100000.00, 2000000.00, 'LUX30', 'SHIPPING', 'SEPAY_QR', 1, 0, '2024-03-16 00:36:37');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (181, 56, 'LXR2407230181', N'Hồ Trúc Trâm', 'khachhang035@gmail.com', '0331604817', N'Số 422, Đường Trường Chinh, Dĩ An, Bình Dương', N'Bình Dương', 29100000.00, 0.00, NULL, 'DELIVERED', 'MOMO', 1, 0, '2024-07-23 09:28:34');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (182, 71, 'LXR2603130182', N'Đỗ Trọng Tài', 'khachhang050@gmail.com', '0963124329', N'Số 91, Đường Nguyễn Huệ, Cẩm Lệ, Đà Nẵng', N'Đà Nẵng', 15600000.00, 2000000.00, 'LXR36', 'DELIVERED', 'COD', 1, 0, '2026-03-13 22:15:58');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (183, 42, 'LXR2408090183', N'Lê Thu Linh', 'khachhang021@gmail.com', '0357974034', N'Số 352, Đường Nguyễn Huệ, Ô Môn, Cần Thơ', N'Cần Thơ', 7550000.00, 2000000.00, 'LUX30', 'DELIVERED', 'COD', 1, 0, '2024-08-09 02:42:17');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (184, 25, 'LXR2409190184', N'Đặng Tiến Cường', 'khachhang004@gmail.com', '0986629946', N'Số 147, Đường Cách Mạng Tháng 8, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 30200000.00, 2000000.00, 'LUX50', 'PENDING', 'COD', 0, 0, '2024-09-19 23:11:01');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (185, 108, 'LXR2605250185', N'Đỗ Trọng Phong', 'khachhang087@gmail.com', '0911742684', N'Số 315, Đường Nguyễn Văn Cừ, Bình Thạnh, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 8400000.00, 0.00, NULL, 'CONFIRMED', 'INSTALLMENT', 0, 0, '2026-05-25 06:37:47');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (186, 88, 'LXR2605220186', N'Đỗ Diệu Mai', 'khachhang067@gmail.com', '0774310278', N'Số 135, Đường Nguyễn Trãi, Trảng Bom, Đồng Nai', N'Đồng Nai', 23700000.00, 0.00, NULL, 'PAID', 'INSTALLMENT', 1, 0, '2026-05-22 14:41:59');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (187, 106, 'LXR2510190187', N'Hoàng Xuân Khải', 'khachhang085@gmail.com', '0364315274', N'Số 405, Đường Võ Văn Kiệt, Hải Châu, Đà Nẵng', N'Đà Nẵng', 6300000.00, 0.00, NULL, 'DELIVERED', 'SEPAY_QR', 1, 0, '2025-10-19 21:14:25');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (188, 86, 'LXR2602280188', N'Đặng Tuấn Khang', 'khachhang065@gmail.com', '0796275705', N'Số 328, Đường Điện Biên Phủ, Hương Thủy, Huế', N'Huế', 16450000.00, 2000000.00, 'LUX30', 'PAID', 'COD', 1, 0, '2026-02-28 00:21:34');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (189, 50, 'LXR2607040189', N'Hoàng Diệu Hà', 'khachhang029@gmail.com', '0937459615', N'Số 321, Đường Võ Văn Kiệt, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 2880000.00, 320000.00, 'LUX10', 'SHIPPING', 'INSTALLMENT', 1, 0, '2026-07-04 03:57:44');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (190, 95, 'LXR2601260190', N'Bùi Thanh Duyên', 'khachhang074@gmail.com', '0944732104', N'Số 128, Đường Giải Phóng, Trảng Bom, Đồng Nai', N'Đồng Nai', 61500000.00, 2000000.00, 'LUX10', 'PAID', 'VNPAY', 1, 0, '2026-01-26 02:19:34');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (191, 74, 'LXR2404250191', N'Dương Tiến Khải', 'khachhang053@gmail.com', '0762554665', N'Số 34, Đường Võ Văn Kiệt, TP. Huế, Huế', N'Huế', 21400000.00, 2000000.00, 'LUX30', 'PAID', 'BANK_TRANSFER', 1, 0, '2024-04-25 15:54:40');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (192, 93, 'LXR2501160192', N'Bùi Trúc Tú', 'khachhang072@gmail.com', '0910109439', N'Số 255, Đường Trần Hưng Đạo, Trảng Bom, Đồng Nai', N'Đồng Nai', 55500000.00, 2000000.00, 'LXR36', 'PAID', 'INSTALLMENT', 1, 0, '2025-01-16 07:58:24');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (193, 80, 'LXR2507290193', N'Bùi Ngọc Mai', 'khachhang059@gmail.com', '0962047277', N'Số 10, Đường Nguyễn Huệ, TP. Huế, Huế', N'Huế', 7200000.00, 800000.00, 'LUX10', 'SHIPPING', 'BANK_TRANSFER', 1, 0, '2025-07-29 16:50:11');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (194, 36, 'LXR2407300194', N'Dương Ánh Lam', 'khachhang015@gmail.com', '0786507527', N'Số 175, Đường Điện Biên Phủ, Lê Chân, Hải Phòng', N'Hải Phòng', 33000000.00, 2000000.00, 'LUX50', 'PROCESSING', 'INSTALLMENT', 1, 0, '2024-07-30 08:42:55');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (195, 59, 'LXR2606290195', N'Võ Hữu Long', 'khachhang038@gmail.com', '0361390053', N'Số 36, Đường Hai Bà Trưng, Liên Chiểu, Đà Nẵng', N'Đà Nẵng', 11500000.00, 0.00, NULL, 'PROCESSING', 'BANK_TRANSFER', 1, 0, '2026-06-29 19:23:05');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (196, 85, 'LXR2410050196', N'Hồ Trọng Quân', 'khachhang064@gmail.com', '0345277584', N'Số 221, Đường Nguyễn Huệ, Tân Bình, TP. Hồ Chí Minh', N'TP. Hồ Chí Minh', 23700000.00, 0.00, NULL, 'SHIPPING', 'INSTALLMENT', 1, 0, '2024-10-05 04:19:30');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (197, 72, 'LXR2501290197', N'Bùi Thành Quân', 'khachhang051@gmail.com', '0937744905', N'Số 237, Đường Cách Mạng Tháng 8, TP. Bắc Ninh, Bắc Ninh', N'Bắc Ninh', 8600000.00, 0.00, NULL, 'PAID', 'COD', 1, 0, '2025-01-29 21:45:33');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (198, 103, 'LXR2609010198', N'Đặng Thị Yến', 'khachhang082@gmail.com', '0791574733', N'Số 71, Đường Điện Biên Phủ, Từ Sơn, Bắc Ninh', N'Bắc Ninh', 8325000.00, 925000.00, 'LUX10', 'DELIVERED', 'VNPAY', 1, 0, '2026-09-01 16:28:09');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (199, 22, 'LXR2606020199', N'Ngô Đình Nhân', 'khachhang001@gmail.com', '0864216073', N'Số 157, Đường Nguyễn Văn Cừ, Kiến An, Hải Phòng', N'Hải Phòng', 10980000.00, 1220000.00, 'LUX10', 'CONFIRMED', 'INSTALLMENT', 0, 0, '2026-06-02 21:24:57');
INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)
VALUES (200, 87, 'LXR2412010200', N'Nguyễn Thu Lam', 'khachhang066@gmail.com', '0787021355', N'Số 310, Đường Lê Lợi, Trảng Bom, Đồng Nai', N'Đồng Nai', 8300000.00, 2000000.00, 'LUX30', 'DELIVERED', 'INSTALLMENT', 1, 0, '2024-12-01 06:35:08');
SET IDENTITY_INSERT orders OFF;
DBCC CHECKIDENT ('orders', RESEED, 200);
GO

-- --------------------------------------------------
-- 9. CHI TIẾT ĐƠN HÀNG (ORDER_ITEMS)
-- --------------------------------------------------
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (1, 13, 16800000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (2, 11, 35000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (2, 13, 16800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (3, 18, 4500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (3, 6, 6100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (4, 23, 3800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (4, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (5, 8, 3200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (5, 9, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (6, 16, 6200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (6, 19, 2600000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (6, 13, 16800000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (7, 18, 4500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (7, 20, 1800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (8, 2, 17200000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (8, 19, 2600000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (9, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (10, 19, 2600000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (10, 8, 3200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (11, 12, 22500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (11, 1, 15500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (12, 15, 8500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (13, 24, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (14, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (14, 1, 15500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (15, 6, 6100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (16, 6, 6100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (16, 21, 1200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (17, 13, 16800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (17, 1, 15500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (18, 18, 4500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (19, 16, 6200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (20, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (21, 10, 52000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (21, 20, 1800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (22, 12, 22500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (23, 13, 16800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (24, 6, 6100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (24, 18, 4500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (24, 16, 6200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (25, 7, 4800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (26, 14, 12200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (26, 23, 3800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (27, 9, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (28, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (28, 16, 6200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (29, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (29, 2, 17200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (30, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (30, 8, 3200000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (31, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (32, 23, 3800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (33, 2, 17200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (33, 19, 2600000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (34, 19, 2600000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (35, 14, 12200000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (35, 2, 17200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (35, 9, 2100000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (36, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (36, 13, 16800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (37, 21, 1200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (38, 23, 3800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (38, 12, 22500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (39, 21, 1200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (39, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (39, 23, 3800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (40, 10, 52000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (41, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (41, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (42, 6, 6100000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (42, 15, 8500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (42, 1, 15500000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (43, 9, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (43, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (43, 21, 1200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (44, 24, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (44, 23, 3800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (45, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (46, 11, 35000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (47, 13, 16800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (48, 10, 52000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (49, 5, 8200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (49, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (49, 17, 3400000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (50, 14, 12200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (50, 20, 1800000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (51, 13, 16800000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (51, 12, 22500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (52, 18, 4500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (53, 22, 750000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (54, 10, 52000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (54, 21, 1200000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (55, 21, 1200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (56, 19, 2600000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (57, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (57, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (57, 1, 15500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (58, 17, 3400000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (58, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (59, 9, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (59, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (60, 21, 1200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (61, 24, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (61, 8, 3200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (62, 10, 52000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (62, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (63, 16, 6200000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (64, 24, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (65, 14, 12200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (66, 15, 8500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (67, 9, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (68, 1, 15500000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (68, 2, 17200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (69, 6, 6100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (69, 2, 17200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (69, 18, 4500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (70, 11, 35000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (70, 9, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (70, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (71, 13, 16800000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (71, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (71, 15, 8500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (72, 10, 52000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (73, 16, 6200000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (74, 14, 12200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (75, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (76, 8, 3200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (77, 8, 3200000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (78, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (78, 19, 2600000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (78, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (79, 5, 8200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (79, 8, 3200000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (80, 8, 3200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (81, 6, 6100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (82, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (83, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (84, 11, 35000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (84, 5, 8200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (85, 9, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (85, 6, 6100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (86, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (87, 8, 3200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (87, 5, 8200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (88, 3, 10800000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (88, 1, 15500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (89, 11, 35000000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (89, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (89, 2, 17200000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (90, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (91, 5, 8200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (92, 14, 12200000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (93, 14, 12200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (94, 18, 4500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (94, 1, 15500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (94, 13, 16800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (95, 9, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (96, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (96, 9, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (96, 2, 17200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (97, 8, 3200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (98, 13, 16800000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (98, 12, 22500000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (99, 24, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (100, 19, 2600000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (100, 7, 4800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (101, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (102, 11, 35000000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (103, 11, 35000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (104, 12, 22500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (104, 3, 10800000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (105, 5, 8200000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (106, 23, 3800000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (107, 6, 6100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (107, 13, 16800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (108, 13, 16800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (108, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (108, 19, 2600000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (109, 5, 8200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (109, 11, 35000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (109, 24, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (110, 7, 4800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (111, 2, 17200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (111, 13, 16800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (112, 13, 16800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (113, 2, 17200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (114, 13, 16800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (115, 20, 1800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (115, 16, 6200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (116, 11, 35000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (117, 18, 4500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (117, 9, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (117, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (118, 1, 15500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (119, 7, 4800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (120, 13, 16800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (121, 6, 6100000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (121, 12, 22500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (122, 8, 3200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (123, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (123, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (124, 13, 16800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (125, 16, 6200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (125, 10, 52000000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (125, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (126, 5, 8200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (126, 4, 11500000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (126, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (127, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (128, 24, 2100000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (129, 11, 35000000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (130, 17, 3400000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (130, 14, 12200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (131, 19, 2600000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (131, 25, 1450000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (131, 4, 11500000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (132, 20, 1800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (133, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (133, 23, 3800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (134, 9, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (134, 12, 22500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (135, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (135, 4, 11500000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (135, 8, 3200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (136, 21, 1200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (137, 17, 3400000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (138, 23, 3800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (139, 7, 4800000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (140, 12, 22500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (141, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (142, 16, 6200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (143, 23, 3800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (143, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (144, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (144, 7, 4800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (145, 21, 1200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (145, 6, 6100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (145, 20, 1800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (146, 12, 22500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (146, 15, 8500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (146, 9, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (147, 22, 750000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (148, 10, 52000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (148, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (149, 23, 3800000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (150, 8, 3200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (150, 2, 17200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (151, 1, 15500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (152, 2, 17200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (153, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (153, 18, 4500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (154, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (154, 18, 4500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (155, 25, 1450000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (155, 6, 6100000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (156, 10, 52000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (157, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (158, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (158, 16, 6200000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (158, 7, 4800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (159, 7, 4800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (160, 6, 6100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (160, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (160, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (161, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (162, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (162, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (163, 2, 17200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (164, 17, 3400000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (164, 7, 4800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (165, 10, 52000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (165, 5, 8200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (165, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (166, 17, 3400000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (167, 16, 6200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (167, 12, 22500000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (167, 25, 1450000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (168, 5, 8200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (168, 7, 4800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (169, 2, 17200000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (169, 13, 16800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (170, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (170, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (170, 21, 1200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (171, 23, 3800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (172, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (173, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (173, 17, 3400000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (174, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (174, 9, 2100000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (175, 18, 4500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (176, 1, 15500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (177, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (177, 17, 3400000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (177, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (178, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (179, 11, 35000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (179, 14, 12200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (180, 6, 6100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (180, 11, 35000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (181, 6, 6100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (181, 4, 11500000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (182, 6, 6100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (182, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (183, 16, 6200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (183, 19, 2600000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (183, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (184, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (184, 14, 12200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (184, 15, 8500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (185, 19, 2600000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (185, 8, 3200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (186, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (186, 14, 12200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (187, 18, 4500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (187, 20, 1800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (188, 3, 10800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (188, 25, 1450000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (188, 16, 6200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (189, 8, 3200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (190, 15, 8500000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (190, 11, 35000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (190, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (191, 3, 10800000.00, 2);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (191, 20, 1800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (192, 11, 35000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (192, 12, 22500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (193, 20, 1800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (193, 16, 6200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (194, 11, 35000000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (195, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (196, 14, 12200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (196, 4, 11500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (197, 7, 4800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (197, 23, 3800000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (198, 15, 8500000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (198, 22, 750000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (199, 14, 12200000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (200, 24, 2100000.00, 1);
INSERT INTO order_items (order_id, product_id, price, quantity) VALUES (200, 5, 8200000.00, 1);
GO
