import random
from datetime import datetime, timedelta

# Realistic Vietnamese names
ho_list = ["Nguyễn", "Trần", "Lê", "Phạm", "Hoàng", "Huỳnh", "Phan", "Vũ", "Võ", "Đặng", "Bùi", "Đỗ", "Hồ", "Ngô", "Dương", "Lý"]
dem_nam = ["Văn", "Đức", "Thành", "Hữu", "Minh", "Quang", "Anh", "Tuấn", "Tiến", "Bảo", "Gia", "Trọng", "Đình", "Xuân"]
dem_nu = ["Thị", "Ngọc", "Thu", "Thanh", "Mai", "Phương", "Diệu", "Khánh", "Mỹ", "Ánh", "Hải", "Tuyết", "Quỳnh", "Trúc"]
ten_nam = ["Huy", "Dũng", "Nam", "Long", "Cường", "Tuấn", "Hải", "Phong", "Hưng", "Bình", "Tùng", "Sơn", "Linh", "Thắng", "Quân", "Đạt", "Khải", "Khoa", "Phúc", "Khang", "Tài", "Nhân"]
ten_nu = ["Linh", "Trang", "Hương", "Thảo", "Hà", "Anh", "Huyền", "Nhi", "Vy", "Yến", "Mai", "Hằng", "Ngọc", "Châu", "Duyên", "Tâm", "Hiền", "Trâm", "Tú", "Lam"]

provinces = [
    ("Hà Nội", ["Ba Đình", "Cầu Giấy", "Đống Đa", "Hai Bà Trưng", "Hoàn Kiếm", "Thanh Xuân", "Hà Đông", "Nam Từ Liêm", "Bắc Từ Liêm", "Long Biên"]),
    ("TP. Hồ Chí Minh", ["Quận 1", "Quận 3", "Quận 7", "Quận 10", "Bình Thạnh", "Gò Vấp", "Tân Bình", "Phú Nhuận", "Thủ Đức", "Bình Tân"]),
    ("Đà Nẵng", ["Hải Châu", "Thanh Khê", "Sơn Trà", "Ngũ Hành Sơn", "Liên Chiểu", "Cẩm Lệ"]),
    ("Hải Phòng", ["Hồng Bàng", "Ngô Quyền", "Lê Chân", "Kiến An", "Hải An"]),
    ("Cần Thơ", ["Ninh Kiều", "Bình Thủy", "Cái Răng", "Ô Môn"]),
    ("Bình Dương", ["Thủ Dầu Một", "Thuận An", "Dĩ An", "Bến Cát"]),
    ("Đồng Nai", ["Biên Hòa", "Long Thành", "Trảng Bom"]),
    ("Quảng Ninh", ["Hạ Long", "Cẩm Phả", "Uông Bí"]),
    ("Bắc Ninh", ["TP. Bắc Ninh", "Từ Sơn", "Yên Phong"]),
    ("Huế", ["TP. Huế", "Hương Thủy", "Hương Trà"])
]

streets = ["Trần Hưng Đạo", "Lê Lợi", "Nguyễn Huệ", "Nguyễn Trãi", "Phan Chu Trinh", "Lý Thường Kiệt", "Hai Bà Trưng", "Hoàng Hoa Thám", "Điện Biên Phủ", "Cách Mạng Tháng 8", "Võ Văn Kiệt", "Nguyễn Văn Cừ", "Trường Chinh", "Giải Phóng", "Cầu Giấy", "Kim Mã"]

def generate_vietnamese_name(gender):
    ho = random.choice(ho_list)
    if gender == 1: # Nam
        dem = random.choice(dem_nam)
        ten = random.choice(ten_nam)
    else: # Nu
        dem = random.choice(dem_nu)
        ten = random.choice(ten_nu)
    return f"{ho} {dem} {ten}"

def generate_phone():
    prefixes = ["090", "091", "093", "094", "096", "097", "098", "086", "088", "089", "032", "033", "034", "035", "036", "037", "038", "039", "070", "076", "077", "078", "079"]
    return random.choice(prefixes) + "".join([str(random.randint(0, 9)) for _ in range(7)])

def generate_address():
    prov, dist_list = random.choice(provinces)
    dist = random.choice(dist_list)
    street = random.choice(streets)
    num = random.randint(1, 450)
    full_addr = f"Số {num}, Đường {street}, {dist}, {prov}"
    return full_addr, prov, dist

random.seed(42)

# Pass hash for '123456'
BCRYPT_PW = "$2a$10$79vW12jU9Gk2rOQ45jF78.KjU2F.rD0w20jF4G8hO.1/K/a/G.G."

sql_lines = []

sql_lines.append("-- ============================================================================")
sql_lines.append("-- 7. INSERT USERS & ROLES SEED DATA (CHIA RÕ TỪNG ROLE THEO THỨ TỰ)")
sql_lines.append("-- ============================================================================\n")

# A. ADMIN
sql_lines.append("-- --------------------------------------------------")
sql_lines.append("-- A. TÀI KHOẢN ADMIN QUẢN TRỊ VIÊN")
sql_lines.append("-- --------------------------------------------------")
sql_lines.append("""SET IDENTITY_INSERT users ON;
INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, status, force_change_password, created_at)
VALUES (1, 'admin', 'admin@luxurypc.vn', '""" + BCRYPT_PW + """', N'Quản Trị Viên Hệ Thống', '0901234567', N'Số 1 Đại Cồ Việt, Hai Bà Trưng, Hà Nội', 1, 'LOCAL', 1, 0, '2024-01-01 08:00:00');
SET IDENTITY_INSERT users OFF;
GO
""")

# B. STAFF (20 Nhân viên)
sql_lines.append("-- --------------------------------------------------")
sql_lines.append("-- B. 20 TÀI KHOẢN NHÂN VIÊN (STAFF) - THÔNG TIN THỰC TẾ")
sql_lines.append("-- --------------------------------------------------")
sql_lines.append("SET IDENTITY_INSERT users ON;")

staff_users = []
for i in range(1, 21):
    uid = 1 + i # id: 2 -> 21
    gender = random.choice([0, 1])
    name = generate_vietnamese_name(gender)
    email = f"staff{i:02d}@luxurypc.vn"
    username = f"staff{i:02d}"
    phone = generate_phone()
    addr, prov, dist = generate_address()
    bday_year = random.randint(1992, 2002)
    bday_month = random.randint(1, 12)
    bday_day = random.randint(1, 28)
    bday = f"{bday_year}-{bday_month:02d}-{bday_day:02d}"
    created_dt = f"2024-{random.randint(1,6):02d}-{random.randint(1,28):02d} 08:30:00"
    staff_users.append((uid, username, email, name, phone, addr, gender, bday, created_dt))
    
    sql_lines.append(f"INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)")
    sql_lines.append(f"VALUES ({uid}, '{username}', '{email}', '{BCRYPT_PW}', N'{name}', '{phone}', N'{addr}', 1, 'LOCAL', '{bday}', {gender}, 1, 0, '{created_dt}');")

sql_lines.append("SET IDENTITY_INSERT users OFF;\nGO\n")

# C. CUSTOMERS (100 Khách hàng)
sql_lines.append("-- --------------------------------------------------")
sql_lines.append("-- C. 100 TÀI KHOẢN KHÁCH HÀNG (USER) - HỌ TÊN CÓ DẤU CHUẨN")
sql_lines.append("-- --------------------------------------------------")
sql_lines.append("SET IDENTITY_INSERT users ON;")

cust_users = []
for i in range(1, 101):
    uid = 21 + i # id: 22 -> 121
    gender = random.choice([0, 1])
    name = generate_vietnamese_name(gender)
    # email slug
    name_clean = "".join([c for c in name.lower() if c.isalnum()])
    email = f"khachhang{i:03d}@gmail.com"
    username = f"user_{i:03d}"
    phone = generate_phone()
    addr, prov, dist = generate_address()
    bday_year = random.randint(1985, 2005)
    bday_month = random.randint(1, 12)
    bday_day = random.randint(1, 28)
    bday = f"{bday_year}-{bday_month:02d}-{bday_day:02d}"
    created_year = random.choice([2024, 2025, 2026])
    if created_year == 2026:
        created_month = random.randint(1, 8)
    else:
        created_month = random.randint(1, 12)
    created_day = random.randint(1, 28)
    created_dt = f"{created_year}-{created_month:02d}-{created_day:02d} {random.randint(7,21):02d}:{random.randint(10,59):02d}:00"
    cust_users.append((uid, username, email, name, phone, addr, prov, dist, gender, bday, created_dt))
    
    sql_lines.append(f"INSERT INTO users (id, username, email, password, full_name, phone, address, enabled, auth_provider, birthday, gender, status, force_change_password, created_at)")
    sql_lines.append(f"VALUES ({uid}, '{username}', '{email}', '{BCRYPT_PW}', N'{name}', '{phone}', N'{addr}', 1, 'LOCAL', '{bday}', {gender}, 1, 0, '{created_dt}');")

sql_lines.append("SET IDENTITY_INSERT users OFF;")
sql_lines.append("DBCC CHECKIDENT ('users', RESEED, 121);\nGO\n")

# D. USER_ROLES SEED DATA
sql_lines.append("-- --------------------------------------------------")
sql_lines.append("-- D. PHÂN QUYỀN USER_ROLES TƯƠNG ỨNG TỪNG NHÓM")
sql_lines.append("-- --------------------------------------------------")
# Admin role
sql_lines.append("-- Quyền ADMIN cho tài khoản admin (id=1)")
sql_lines.append("INSERT INTO user_roles (user_id, role_id) VALUES (1, 1);")

# Staff roles
sql_lines.append("\n-- Quyền STAFF cho 20 nhân viên (id=2..21)")
for u in staff_users:
    sql_lines.append(f"INSERT INTO user_roles (user_id, role_id) VALUES ({u[0]}, 3);")

# User roles
sql_lines.append("\n-- Quyền USER cho 100 khách hàng (id=22..121)")
for u in cust_users:
    sql_lines.append(f"INSERT INTO user_roles (user_id, role_id) VALUES ({u[0]}, 2);")

sql_lines.append("GO\n")

# E. SHIPPING ADDRESSES
sql_lines.append("-- --------------------------------------------------")
sql_lines.append("-- E. ĐỊA CHỈ GIAO HÀNG (SHIPPING_ADDRESSES) MẪU CHO KHÁCH HÀNG")
sql_lines.append("-- --------------------------------------------------")
for u in cust_users[:50]: # First 50 customers get default shipping address
    sql_lines.append(f"INSERT INTO shipping_addresses (user_id, recipient_name, phone, address, city, district, is_default) VALUES ({u[0]}, N'{u[3]}', '{u[4]}', N'{u[5]}', N'{u[6]}', N'{u[7]}', 1);")
sql_lines.append("GO\n")

# F. 200 ORDERS & ORDER_ITEMS
sql_lines.append("-- ============================================================================")
sql_lines.append("-- 8. 200 ĐƠN HÀNG ĐA DẠNG NGÀY THÁNG (2024 -> 03/09/2026) & CÓ VOUCHER CHUẨN")
sql_lines.append("-- ============================================================================\n")

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

# Sample products for order items (id, price)
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

sql_lines.append("SET IDENTITY_INSERT orders ON;")

order_items_sql = []

for order_id in range(1, 201):
    cust = random.choice(cust_users)
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
    
    # Pick 1-3 items
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
    
    # Apply voucher
    v_code, v_rate = random.choice(vouchers_list)
    discount = 0.0
    if v_code and subtotal >= 1000000:
        discount = subtotal * v_rate
        if discount > 2000000: # cap discount max 2M
            discount = 2000000
    else:
        v_code = None
        
    total_price = max(0.0, subtotal - discount)
    v_code_sql = f"'{v_code}'" if v_code else "NULL"
    
    stock_deducted = 1 if status in ["PAID", "DELIVERED", "SHIPPING", "PROCESSING"] else 0
    stock_restored = 1 if status in ["CANCELLED"] else 0
    
    sql_lines.append(f"INSERT INTO orders (id, user_id, order_code, full_name, email, phone, address, city, total_price, discount_amount, voucher_code, status, payment_method, stock_deducted, stock_restored, created_at)")
    sql_lines.append(f"VALUES ({order_id}, {user_id}, '{order_code}', N'{full_name}', '{email}', '{phone}', N'{address}', N'{city}', {total_price:.2f}, {discount:.2f}, {v_code_sql}, '{status}', '{pay_method}', {stock_deducted}, {stock_restored}, '{ord_dt_str}');")
    
    for it in items_for_this_order:
        order_items_sql.append(f"INSERT INTO order_items (order_id, product_id, price, quantity) VALUES ({it[0]}, {it[1]}, {it[2]:.2f}, {it[3]});")

sql_lines.append("SET IDENTITY_INSERT orders OFF;")
sql_lines.append("DBCC CHECKIDENT ('orders', RESEED, 200);\nGO\n")

sql_lines.append("-- --------------------------------------------------")
sql_lines.append("-- 9. CHI TIẾT ĐƠN HÀNG (ORDER_ITEMS)")
sql_lines.append("-- --------------------------------------------------")
sql_lines.extend(order_items_sql)
sql_lines.append("GO\n")

with open(r"d:\Luxury-PC-main\scratch\seed_full_data.sql", "w", encoding="utf-8") as f:
    f.write("\n".join(sql_lines))

print(f"Generated successfully: {len(sql_lines)} lines.")
