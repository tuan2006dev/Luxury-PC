import random
from datetime import datetime, timedelta

# Hash for 123456
BCRYPT_PW = "$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G."

# Staff list: exactly 20 staff members categorized by regions
staff_members = [
    # Hà Nội (7 nhân viên)
    ("staff.hoanglong", "hoanglong.luxury@gmail.com", "Lê Hoàng Long", "0988123456", "Số 121 Thái Hà, Phường Trung Liệt, Quận Đống Đa, Hà Nội", "/uploads/avatars/user_1.webp", "1995-04-12", 1, "2026-01-15 08:30:00", "Hà Nội"),
    ("staff.thutrang", "thutrang.luxury@gmail.com", "Trần Thị Thu Trang", "0975234567", "Số 45 Chùa Bộc, Phường Quang Trung, Quận Đống Đa, Hà Nội", "/uploads/avatars/user_2.webp", "1998-09-20", 0, "2026-01-18 09:15:00", "Hà Nội"),
    ("staff.minhduc", "minhduc.tech@gmail.com", "Đỗ Minh Đức", "0912345678", "Số 68 Cầu Giấy, Phường Quan Hoa, Quận Cầu Giấy, Hà Nội", "/uploads/avatars/user_3.webp", "1996-11-05", 1, "2026-02-01 10:00:00", "Hà Nội"),
    ("staff.ngocmai", "ngocmai.luxurypc@gmail.com", "Phạm Ngọc Mai", "0934567890", "Số 165 Xuân Thủy, Phường Dịch Vọng Hậu, Quận Cầu Giấy, Hà Nội", "/uploads/avatars/user_4.webp", "2000-03-14", 0, "2026-02-10 14:20:00", "Hà Nội"),
    ("staff.tuankiet", "tuankiet.pc@gmail.com", "Đặng Tuấn Kiệt", "0903456781", "Số 88 Phố Huế, Phường Hàng Bài, Quận Hoàn Kiếm, Hà Nội", "/uploads/avatars/user_5.webp", "1994-07-28", 1, "2026-02-15 11:45:00", "Hà Nội"),
    ("staff.phuongthao", "phuongthao.sales@gmail.com", "Bùi Phương Thảo", "0945678902", "Số 210 Xã Đàn, Phường Nam Đồng, Quận Đống Đa, Hà Nội", "/uploads/avatars/user_6.webp", "1999-12-08", 0, "2026-02-20 08:00:00", "Hà Nội"),
    ("staff.quanghuy", "quanghuy.buildpc@gmail.com", "Nguyễn Quang Huy", "0967890123", "Số 32 Hoàng Cầu, Phường Ô Chợ Dừa, Quận Đống Đa, Hà Nội", "/uploads/avatars/user_7.webp", "1997-05-19", 1, "2026-03-01 13:30:00", "Hà Nội"),
    
    # TP. Hồ Chí Minh (8 nhân viên)
    ("staff.giahuynh", "giahuynh.luxury@gmail.com", "Trương Gia Huỳnh", "0943210987", "Số 182 Bùi Thị Xuân, Phường Phạm Ngũ Lão, Quận 1, TP. Hồ Chí Minh", "/uploads/avatars/user_13.webp", "1994-08-14", 1, "2026-04-08 09:00:00", "TP. Hồ Chí Minh"),
    ("staff.bichngoc", "bichngoc.hcm@gmail.com", "Ngô Bích Ngọc", "0965432109", "Số 386 Võ Văn Tần, Phường 5, Quận 3, TP. Hồ Chí Minh", "/uploads/avatars/user_14.webp", "1997-02-27", 0, "2026-04-15 14:00:00", "TP. Hồ Chí Minh"),
    ("staff.truonggiang", "truonggiang.tech@gmail.com", "Phan Trường Giang", "0987654321", "Số 280 Nguyễn Đình Chiểu, Phường 6, Quận 3, TP. Hồ Chí Minh", "/uploads/avatars/user_15.webp", "1992-11-11", 1, "2026-04-20 11:10:00", "TP. Hồ Chí Minh"),
    ("staff.hoangyen", "hoangyen.luxurypc@gmail.com", "Dương Hoàng Yến", "0976543210", "Số 543 Cách Mạng Tháng 8, Phường 15, Quận 10, TP. Hồ Chí Minh", "/uploads/avatars/user_16.webp", "2000-09-09", 0, "2026-04-26 16:30:00", "TP. Hồ Chí Minh"),
    ("staff.quocbao", "quocbao.pcbuilder@gmail.com", "Lê Quốc Bảo", "0918765432", "Số 120 Thành Thái, Phường 12, Quận 10, TP. Hồ Chí Minh", "/uploads/avatars/user_17.webp", "1996-03-31", 1, "2026-05-02 08:20:00", "TP. Hồ Chí Minh"),
    ("staff.thuytien", "thuytien.sales@gmail.com", "Vũ Thủy Tiên", "0932109876", "Số 89 Sư Vạn Hạnh, Phường 12, Quận 10, TP. Hồ Chí Minh", "/uploads/avatars/user_18.webp", "1999-07-15", 0, "2026-05-08 10:40:00", "TP. Hồ Chí Minh"),
    ("staff.minhtri", "minhtri.support@gmail.com", "Nguyễn Minh Trí", "0901234567", "Số 175 Phan Xích Long, Phường 2, Quận Phú Nhuận, TP. Hồ Chí Minh", "/uploads/avatars/user_19.webp", "1995-10-04", 1, "2026-05-15 13:50:00", "TP. Hồ Chí Minh"),
    ("staff.kimngan", "kimngan.hcm@gmail.com", "Trần Kim Ngân", "0945678123", "Số 420 Nguyễn Oanh, Phường 6, Quận Gò Vấp, TP. Hồ Chí Minh", "/uploads/avatars/user_20.webp", "2002-01-18", 0, "2026-05-22 09:15:00", "TP. Hồ Chí Minh"),
    
    # Đà Nẵng & Miền Trung (5 nhân viên)
    ("staff.tanphat", "tanphat.danang@gmail.com", "Võ Tấn Phát", "0982345678", "Số 234 Nguyễn Văn Linh, Phường Thạc Gián, Quận Thanh Khê, Đà Nẵng", "/uploads/avatars/user_5.webp", "1995-03-12", 1, "2026-06-20 09:00:00", "Đà Nẵng"),
    ("staff.myhanh", "myhanh.luxury@gmail.com", "Trần Mỹ Hạnh", "0973456789", "Số 156 Hùng Vương, Phường Hải Châu 1, Quận Hải Châu, Đà Nẵng", "/uploads/avatars/user_6.webp", "1999-08-25", 0, "2026-06-25 14:15:00", "Đà Nẵng"),
    ("staff.quangvinh", "quangvinh.tech@gmail.com", "Phan Quang Vinh", "0914567890", "Số 89 Lê Duẩn, Phường Hải Châu 2, Quận Hải Châu, Đà Nẵng", "/uploads/avatars/user_7.webp", "1993-12-30", 1, "2026-07-01 10:30:00", "Đà Nẵng"),
    ("staff.thanhngan", "thanhngan.pc@gmail.com", "Lê Thanh Ngân", "0935678901", "Số 45 Điện Biên Phủ, Phường Chính Gián, Quận Thanh Khê, Đà Nẵng", "/uploads/avatars/user_8.webp", "2001-04-18", 0, "2026-07-08 16:45:00", "Đà Nẵng"),
    ("staff.vietanh", "vietanh.custom@gmail.com", "Hoàng Việt Anh", "0906789012", "Số 78 Bạch Đằng, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng", "/uploads/avatars/user_9.webp", "1996-09-05", 1, "2026-07-15 08:20:00", "Đà Nẵng")
]

# 100 Customers categorized by regions
# Miền Bắc (40 users)
# Miền Nam (40 users)
# Miền Trung (20 users)

ho_list = ["Nguyễn", "Trần", "Lê", "Phạm", "Hoàng", "Huỳnh", "Phan", "Vũ", "Võ", "Đặng", "Bùi", "Đỗ", "Hồ", "Ngô", "Dương", "Lý"]
dem_nam = ["Văn", "Đức", "Thành", "Hữu", "Minh", "Quang", "Anh", "Tuấn", "Tiến", "Bảo", "Gia", "Trọng", "Đình", "Xuân"]
dem_nu = ["Thị", "Ngọc", "Thu", "Thanh", "Mai", "Phương", "Diệu", "Khánh", "Mỹ", "Ánh", "Hải", "Tuyết", "Quỳnh", "Trúc"]
ten_nam = ["Huy", "Dũng", "Nam", "Long", "Cường", "Tuấn", "Hải", "Phong", "Hưng", "Bình", "Tùng", "Sơn", "Linh", "Thắng", "Quân", "Đạt", "Khải", "Khoa", "Phúc", "Khang", "Tài", "Nhân"]
ten_nu = ["Linh", "Trang", "Hương", "Thảo", "Hà", "Anh", "Huyền", "Nhi", "Vy", "Yến", "Mai", "Hằng", "Ngọc", "Châu", "Duyên", "Tâm", "Hiền", "Trâm", "Tú", "Lam"]

def gen_name(gender):
    ho = random.choice(ho_list)
    dem = random.choice(dem_nam if gender == 1 else dem_nu)
    ten = random.choice(ten_nam if gender == 1 else ten_nu)
    return f"{ho} {dem} {ten}"

def gen_phone():
    prefixes = ["090", "091", "093", "094", "096", "097", "098", "086", "088", "089", "032", "033", "034", "035", "036", "037", "038", "039", "070", "076", "077", "078", "079"]
    return random.choice(prefixes) + "".join([str(random.randint(0, 9)) for _ in range(7)])

random.seed(100)

north_locs = [
    ("Hà Nội", ["Ba Đình", "Cầu Giấy", "Đống Đa", "Hai Bà Trưng", "Hoàn Kiếm", "Thanh Xuân", "Hà Đông", "Nam Từ Liêm", "Bắc Từ Liêm", "Long Biên", "Tây Hồ", "Hoàng Mai"]),
    ("Hải Phòng", ["Hồng Bàng", "Ngô Quyền", "Lê Chân", "Hải An"]),
    ("Quảng Ninh", ["Hạ Long", "Cẩm Phả", "Uông Bí"]),
    ("Bắc Ninh", ["TP. Bắc Ninh", "Từ Sơn", "Yên Phong"]),
    ("Hải Dương", ["TP. Hải Dương", "Chí Linh"])
]

south_locs = [
    ("TP. Hồ Chí Minh", ["Quận 1", "Quận 3", "Quận 7", "Quận 10", "Bình Thạnh", "Gò Vấp", "Tân Bình", "Phú Nhuận", "TP. Thủ Đức", "Bình Tân", "Quận 5", "Quận 8"]),
    ("Bình Dương", ["Thủ Dầu Một", "Thuận An", "Dĩ An", "Bến Cát"]),
    ("Đồng Nai", ["Biên Hòa", "Long Thành"]),
    ("Cần Thơ", ["Ninh Kiều", "Bình Thủy", "Cái Răng"]),
    ("Vũng Tàu", ["TP. Vũng Tàu", "Bà Rịa"])
]

central_locs = [
    ("Đà Nẵng", ["Hải Châu", "Thanh Khê", "Sơn Trà", "Ngũ Hành Sơn", "Liên Chiểu", "Cẩm Lệ"]),
    ("Huế", ["TP. Huế", "Hương Thủy"]),
    ("Nha Trang", ["TP. Nha Trang", "Cam Ranh"]),
    ("Quảng Nam", ["Tam Kỳ", "Hội An"]),
    ("Bình Định", ["Quy Nhơn"])
]

streets = ["Trần Hưng Đạo", "Lê Lợi", "Nguyễn Huệ", "Nguyễn Trãi", "Phan Chu Trinh", "Lý Thường Kiệt", "Hai Bà Trưng", "Hoàng Hoa Thám", "Điện Biên Phủ", "Cách Mạng Tháng 8", "Võ Văn Kiệt", "Nguyễn Văn Cừ", "Trường Chinh", "Giải Phóng", "Cầu Giấy", "Kim Mã", "Võ Thị Sáu", "Nam Kỳ Khởi Nghĩa"]

def gen_addr(loc_list):
    prov, dist_list = random.choice(loc_list)
    dist = random.choice(dist_list)
    street = random.choice(streets)
    num = random.randint(1, 350)
    return f"Số {num}, Đường {street}, {dist}, {prov}", prov, dist

customers_north = []
for i in range(1, 41):
    uid = 21 + i # 22 -> 61
    gender = random.choice([0, 1])
    name = gen_name(gender)
    email = f"khachhang{i:03d}@gmail.com"
    username = f"user_{i:03d}"
    phone = gen_phone()
    addr, prov, dist = gen_addr(north_locs)
    bday = f"{random.randint(1986, 2004)}-{random.randint(1,12):02d}-{random.randint(1,28):02d}"
    c_year = random.choice([2024, 2025, 2026])
    c_mon = random.randint(1, 8) if c_year == 2026 else random.randint(1, 12)
    c_dt = f"{c_year}-{c_mon:02d}-{random.randint(1,28):02d} {random.randint(8,21):02d}:{random.randint(10,59):02d}:00"
    customers_north.append((uid, username, email, name, phone, addr, prov, dist, gender, bday, c_dt))

customers_south = []
for i in range(41, 81):
    uid = 21 + i # 62 -> 101
    gender = random.choice([0, 1])
    name = gen_name(gender)
    email = f"khachhang{i:03d}@gmail.com"
    username = f"user_{i:03d}"
    phone = gen_phone()
    addr, prov, dist = gen_addr(south_locs)
    bday = f"{random.randint(1986, 2004)}-{random.randint(1,12):02d}-{random.randint(1,28):02d}"
    c_year = random.choice([2024, 2025, 2026])
    c_mon = random.randint(1, 8) if c_year == 2026 else random.randint(1, 12)
    c_dt = f"{c_year}-{c_mon:02d}-{random.randint(1,28):02d} {random.randint(8,21):02d}:{random.randint(10,59):02d}:00"
    customers_south.append((uid, username, email, name, phone, addr, prov, dist, gender, bday, c_dt))

customers_central = []
for i in range(81, 101):
    uid = 21 + i # 102 -> 121
    gender = random.choice([0, 1])
    name = gen_name(gender)
    email = f"khachhang{i:03d}@gmail.com"
    username = f"user_{i:03d}"
    phone = gen_phone()
    addr, prov, dist = gen_addr(central_locs)
    bday = f"{random.randint(1986, 2004)}-{random.randint(1,12):02d}-{random.randint(1,28):02d}"
    c_year = random.choice([2024, 2025, 2026])
    c_mon = random.randint(1, 8) if c_year == 2026 else random.randint(1, 12)
    c_dt = f"{c_year}-{c_mon:02d}-{random.randint(1,28):02d} {random.randint(8,21):02d}:{random.randint(10,59):02d}:00"
    customers_central.append((uid, username, email, name, phone, addr, prov, dist, gender, bday, c_dt))

all_cust = customers_north + customers_south + customers_central

lines = []
lines.append("-- ============================================================================")
lines.append("-- 7. INSERT USERS & ROLES SEED DATA (CHIA RÕ TỪNG ROLE THEO THỨ TỰ)")
lines.append("-- ============================================================================\n")

# 7.1 ADMIN
lines.append("-- ----------------------------------------------------------------------------")
lines.append("-- 7.1. TÀI KHOẢN ADMIN (QUẢN TRỊ VIÊN HỆ THỐNG)")
lines.append("-- ----------------------------------------------------------------------------")
lines.append("SET IDENTITY_INSERT users ON;\n")
lines.append("INSERT INTO users (id, username, email, password, full_name, phone, address, avatar, birthday, gender, enabled, auth_provider, status, force_change_password, created_at) VALUES")
lines.append(f"(1, 'admin', 'admin@luxurypc.vn', '{BCRYPT_PW}', N'Quản Trị Viên Hệ Thống', '0901234567', N'Số 1 Đại Cồ Việt, Phường Bách Khoa, Quận Hai Bà Trưng, Hà Nội', '/uploads/avatars/user_1.webp', '1990-01-01', 1, 1, 'LOCAL', 1, 0, '2024-01-01 08:00:00');\n")

# 7.2 STAFF
lines.append("-- ----------------------------------------------------------------------------")
lines.append("-- 7.2. 20 TÀI KHOẢN NHÂN VIÊN (STAFF) - PHÂN CHIA THEO CHI NHÁNH / KHU VỰC")
lines.append("-- ----------------------------------------------------------------------------\n")

# HN
lines.append("-- Khu vực Hà Nội (Showroom Thái Hà, Cầu Giấy, Hai Bà Trưng)")
lines.append("INSERT INTO users (id, username, email, password, full_name, phone, address, avatar, birthday, gender, enabled, auth_provider, status, force_change_password, created_at) VALUES")
hn_staff = [s for s in staff_members if s[9] == "Hà Nội"]
for idx, s in enumerate(hn_staff):
    uid = 2 + idx
    comma = "," if idx < len(hn_staff) - 1 else ";"
    lines.append(f"({uid}, '{s[0]}', '{s[1]}', '{BCRYPT_PW}', N'{s[2]}', '{s[3]}', N'{s[4]}', '{s[5]}', '{s[6]}', {s[7]}, 1, 'LOCAL', 1, 0, '{s[8]}'){comma}")

# HCM
lines.append("\n-- Khu vực TP. Hồ Chí Minh (Showroom Quận 1, Quận 3, Quận 10, TP. Thủ Đức)")
lines.append("INSERT INTO users (id, username, email, password, full_name, phone, address, avatar, birthday, gender, enabled, auth_provider, status, force_change_password, created_at) VALUES")
hcm_staff = [s for s in staff_members if s[9] == "TP. Hồ Chí Minh"]
for idx, s in enumerate(hcm_staff):
    uid = 2 + len(hn_staff) + idx
    comma = "," if idx < len(hcm_staff) - 1 else ";"
    lines.append(f"({uid}, '{s[0]}', '{s[1]}', '{BCRYPT_PW}', N'{s[2]}', '{s[3]}', N'{s[4]}', '{s[5]}', '{s[6]}', {s[7]}, 1, 'LOCAL', 1, 0, '{s[8]}'){comma}")

# DN
lines.append("\n-- Khu vực Đà Nẵng & Miền Trung (Showroom Hải Châu, Thanh Khê)")
lines.append("INSERT INTO users (id, username, email, password, full_name, phone, address, avatar, birthday, gender, enabled, auth_provider, status, force_change_password, created_at) VALUES")
dn_staff = [s for s in staff_members if s[9] == "Đà Nẵng"]
for idx, s in enumerate(dn_staff):
    uid = 2 + len(hn_staff) + len(hcm_staff) + idx
    comma = "," if idx < len(dn_staff) - 1 else ";"
    lines.append(f"({uid}, '{s[0]}', '{s[1]}', '{BCRYPT_PW}', N'{s[2]}', '{s[3]}', N'{s[4]}', '{s[5]}', '{s[6]}', {s[7]}, 1, 'LOCAL', 1, 0, '{s[8]}'){comma}")

# 7.3 USERS
lines.append("\n-- ----------------------------------------------------------------------------")
lines.append("-- 7.3. 100 TÀI KHOẢN KHÁCH HÀNG (USER) - HỌ TÊN TIẾNG VIỆT CÓ DẤU CHUẨN XÁC")
lines.append("-- ----------------------------------------------------------------------------\n")

# North Customers
lines.append("-- Khách hàng Khu vực Miền Bắc (Hà Nội, Hải Phòng, Quảng Ninh, Bắc Ninh, Hải Dương)")
lines.append("INSERT INTO users (id, username, email, password, full_name, phone, address, birthday, gender, enabled, auth_provider, status, force_change_password, created_at) VALUES")
for idx, c in enumerate(customers_north):
    comma = "," if idx < len(customers_north) - 1 else ";"
    lines.append(f"({c[0]}, '{c[1]}', '{c[2]}', '{BCRYPT_PW}', N'{c[3]}', '{c[4]}', N'{c[5]}', '{c[9]}', {c[8]}, 1, 'LOCAL', 1, 0, '{c[10]}'){comma}")

# South Customers
lines.append("\n-- Khách hàng Khu vực Miền Nam (TP. Hồ Chí Minh, Bình Dương, Đồng Nai, Cần Thơ, Vũng Tàu)")
lines.append("INSERT INTO users (id, username, email, password, full_name, phone, address, birthday, gender, enabled, auth_provider, status, force_change_password, created_at) VALUES")
for idx, c in enumerate(customers_south):
    comma = "," if idx < len(customers_south) - 1 else ";"
    lines.append(f"({c[0]}, '{c[1]}', '{c[2]}', '{BCRYPT_PW}', N'{c[3]}', '{c[4]}', N'{c[5]}', '{c[9]}', {c[8]}, 1, 'LOCAL', 1, 0, '{c[10]}'){comma}")

# Central Customers
lines.append("\n-- Khách hàng Khu vực Miền Trung & Tây Nguyên (Đà Nẵng, Huế, Nha Trang, Quảng Nam, Bình Định)")
lines.append("INSERT INTO users (id, username, email, password, full_name, phone, address, birthday, gender, enabled, auth_provider, status, force_change_password, created_at) VALUES")
for idx, c in enumerate(customers_central):
    comma = "," if idx < len(customers_central) - 1 else ";"
    lines.append(f"({c[0]}, '{c[1]}', '{c[2]}', '{BCRYPT_PW}', N'{c[3]}', '{c[4]}', N'{c[5]}', '{c[9]}', {c[8]}, 1, 'LOCAL', 1, 0, '{c[10]}'){comma}")

lines.append("\nSET IDENTITY_INSERT users OFF;")
lines.append("DBCC CHECKIDENT ('users', RESEED, 121);\nGO\n")

# 7.4 USER ROLES
lines.append("-- ----------------------------------------------------------------------------")
lines.append("-- 7.4. PHÂN QUYỀN USER_ROLES THEO TỪNG NHÓM (ADMIN -> STAFF -> USER)")
lines.append("-- ----------------------------------------------------------------------------")
lines.append("-- Nhóm 1: Tài khoản Quản trị viên (ADMIN)")
lines.append("INSERT INTO user_roles (user_id, role_id) VALUES (1, 1);\n")

lines.append("-- Nhóm 2: 20 Tài khoản Nhân viên (STAFF)")
lines.append("INSERT INTO user_roles (user_id, role_id) VALUES")
staff_ids = [2 + i for i in range(20)]
for idx, sid in enumerate(staff_ids):
    comma = "," if idx < len(staff_ids) - 1 else ";"
    lines.append(f"({sid}, 3){comma}")

lines.append("\n-- Nhóm 3: 100 Tài khoản Khách hàng (USER)")
lines.append("INSERT INTO user_roles (user_id, role_id) VALUES")
cust_ids = [c[0] for c in all_cust]
for idx, cid in enumerate(cust_ids):
    comma = "," if idx < len(cust_ids) - 1 else ";"
    lines.append(f"({cid}, 2){comma}")

lines.append("GO\n")

# 7.5 SHIPPING ADDRESSES
lines.append("-- ----------------------------------------------------------------------------")
lines.append("-- 7.5. ĐỊA CHỈ GIAO HÀNG (SHIPPING_ADDRESSES) MẪU CHO KHÁCH HÀNG")
lines.append("-- ----------------------------------------------------------------------------")
lines.append("INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES")
for idx, c in enumerate(all_cust[:60]):
    comma = "," if idx < 59 else ";"
    lines.append(f"({c[0]}, N'{c[3]}', '{c[4]}', N'{c[5]}', N'{c[6]}', N'{c[7]}', 1){comma}")
lines.append("GO\n")

# 8. ORDERS & ORDER ITEMS
lines.append("-- ============================================================================")
lines.append("-- 8. 200 ĐƠN HÀNG ĐA DẠNG NGÀY THÁNG (2024 -> 03/09/2026) & CÓ VOUCHER CHUẨN")
lines.append("-- ============================================================================\n")

statuses = [
    ("PAID", 60),
    ("DELIVERED", 40),
    ("SHIPPING", 35),
    ("CONFIRMED", 25),
    ("PROCESSING", 20),
    ("PENDING", 12),
    ("CANCELLED", 8)
]
status_pool = []
for st, cnt in statuses:
    status_pool.extend([st] * cnt)
random.shuffle(status_pool)

payment_methods = ["VNPAY", "SEPAY_QR", "MOMO", "COD", "BANK_TRANSFER", "INSTALLMENT"]
vouchers_list = [
    (None, 0),
    (None, 0),
    (None, 0),
    ("LUX10", 0.10),
    ("LUX30", 0.30),
    ("LUX50", 0.50),
    ("LXR36", 0.15)
]

sample_prods = [
    (1, 15500000.0), (2, 17200000.0), (3, 10800000.0), (4, 11500000.0), (5, 8200000.0),
    (6, 6100000.0), (7, 4800000.0), (8, 3200000.0), (9, 2100000.0), (10, 52000000.0),
    (11, 35000000.0), (12, 22500000.0), (13, 16800000.0), (14, 12200000.0), (15, 8500000.0),
    (16, 6200000.0), (17, 3400000.0), (18, 4500000.0), (19, 2600000.0), (20, 1800000.0),
    (21, 1200000.0), (22, 750000.0), (23, 3800000.0), (24, 2100000.0), (25, 1450000.0)
]

start_date = datetime(2024, 3, 1)
end_date = datetime(2026, 9, 3, 14, 30, 0)
total_seconds = int((end_date - start_date).total_seconds())

order_rows = []
order_items_rows = []

for order_id in range(1, 201):
    cust = random.choice(all_cust)
    user_id = cust[0]
    full_name = cust[3]
    email = cust[2]
    phone = cust[4]
    address = cust[5]
    city = cust[6]
    
    rand_sec = random.randint(0, total_seconds)
    ord_dt = start_date + timedelta(seconds=rand_sec)
    ord_dt_str = ord_dt.strftime("%Y-%m-%d %H:%M:%S")
    
    order_code = f"LXR{ord_dt.strftime('%y%m%d')}{order_id:04d}"
    status = status_pool[order_id - 1]
    pay_method = random.choice(payment_methods)
    
    num_items = random.choices([1, 2, 3], weights=[50, 35, 15])[0]
    chosen_prods = random.sample(sample_prods, num_items)
    
    subtotal = 0
    items_for_this_order = []
    for p in chosen_prods:
        pid = p[0]
        price = p[1]
        qty = random.choices([1, 2], weights=[85, 15])[0]
        subtotal += price * qty
        items_for_this_order.append((order_id, pid, price, qty))
    
    v_code, v_rate = random.choice(vouchers_list)
    discount = 0.0
    if v_code and subtotal >= 1000000:
        discount = subtotal * v_rate
        if discount > 2000000:
            discount = 2000000
    else:
        v_code = None
        
    total_price = max(0.0, subtotal - discount)
    v_code_sql = f"'{v_code}'" if v_code else "NULL"
    
    stock_deducted = 1 if status in ["PAID", "DELIVERED", "SHIPPING", "PROCESSING"] else 0
    stock_restored = 1 if status in ["CANCELLED"] else 0
    
    order_rows.append(f"({order_id}, {user_id}, '{order_code}', N'{full_name}', '{email}', '{phone}', N'{address}', N'{city}', {total_price:.2f}, {discount:.2f}, {v_code_sql}, '{status}', '{pay_method}', {stock_deducted}, {stock_restored}, '{ord_dt_str}')")
    
    for it in items_for_this_order:
        order_items_rows.append(f"({it[0]}, {it[1]}, {it[2]:.2f}, {it[3]})")

lines.append("SET IDENTITY_INSERT orders ON;\n")
lines.append("INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at) VALUES")
for idx, r in enumerate(order_rows):
    comma = "," if idx < len(order_rows) - 1 else ";"
    lines.append(f"{r}{comma}")

lines.append("\nSET IDENTITY_INSERT orders OFF;")
lines.append("DBCC CHECKIDENT ('orders', RESEED, 200);\nGO\n")

lines.append("-- ----------------------------------------------------------------------------")
lines.append("-- 9. CHI TIẾT ĐƠN HÀNG (ORDER_ITEMS)")
lines.append("-- ----------------------------------------------------------------------------")
lines.append("INSERT INTO order_items (order_id, product_id, price, quantity) VALUES")
for idx, r in enumerate(order_items_rows):
    comma = "," if idx < len(order_items_rows) - 1 else ";"
    lines.append(f"{r}{comma}")
lines.append("GO\n")

with open(r"d:\Luxury-PC-main\scratch\seed_full_data_formatted.sql", "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

print(f"Generated formatted seed successfully: {len(lines)} lines.")
