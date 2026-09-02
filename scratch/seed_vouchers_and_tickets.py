import subprocess

# 20 Shopee-style Vouchers
vouchers = [
    # 1. Freeship vouchers
    {
        "id": 1,
        "code": "FREESHIP50K",
        "description": "Miễn phí vận chuyển 50.000đ cho đơn hàng từ 500.000đ",
        "discount_type": "FIXED_AMOUNT",
        "voucher_scope": "FREESHIP",
        "discount_value": 50000.00,
        "min_order_amount": 500000.00,
        "max_discount_amount": 50000.00,
        "usage_limit": 1000,
        "used_count": 86,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 2,
        "code": "FREESHIP100K",
        "description": "Miễn phí vận chuyển 100.000đ cho đơn hàng từ 2.000.000đ",
        "discount_type": "FIXED_AMOUNT",
        "voucher_scope": "FREESHIP",
        "discount_value": 100000.00,
        "min_order_amount": 2000000.00,
        "max_discount_amount": 100000.00,
        "usage_limit": 500,
        "used_count": 42,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 3,
        "code": "FREESHIPMAX",
        "description": "Freeship Xtra toàn quốc tối đa 300.000đ cho đơn từ 10.000.000đ",
        "discount_type": "FIXED_AMOUNT",
        "voucher_scope": "FREESHIP",
        "discount_value": 300000.00,
        "min_order_amount": 10000000.00,
        "max_discount_amount": 300000.00,
        "usage_limit": 300,
        "used_count": 19,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },

    # 2. Welcome vouchers
    {
        "id": 4,
        "code": "WELCOME2026",
        "description": "Chào mừng bạn mới - Giảm 10% tối đa 500.000đ cho đơn từ 1.000.000đ",
        "discount_type": "PERCENTAGE",
        "voucher_scope": "GLOBAL",
        "discount_value": 10.00,
        "min_order_amount": 1000000.00,
        "max_discount_amount": 500000.00,
        "usage_limit": 2000,
        "used_count": 315,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 5,
        "code": "NEWBIE100K",
        "description": "Quà tặng thành viên mới - Giảm ngay 100.000đ trực tiếp đơn từ 500.000đ",
        "discount_type": "FIXED_AMOUNT",
        "voucher_scope": "GLOBAL",
        "discount_value": 100000.00,
        "min_order_amount": 500000.00,
        "max_discount_amount": 100000.00,
        "usage_limit": 1500,
        "used_count": 210,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },

    # 3. Global Mega Vouchers
    {
        "id": 6,
        "code": "LUXURY500K",
        "description": "Giảm ngay 500.000đ cho đơn hàng linh kiện / PC từ 15.000.000đ",
        "discount_type": "FIXED_AMOUNT",
        "voucher_scope": "GLOBAL",
        "discount_value": 500000.00,
        "min_order_amount": 15000000.00,
        "max_discount_amount": 500000.00,
        "usage_limit": 500,
        "used_count": 68,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 7,
        "code": "LUXURY1M",
        "description": "Giảm ngay 1.000.000đ cho đơn hàng High-End từ 30.000.000đ",
        "discount_type": "FIXED_AMOUNT",
        "voucher_scope": "GLOBAL",
        "discount_value": 1000000.00,
        "min_order_amount": 30000000.00,
        "max_discount_amount": 1000000.00,
        "usage_limit": 300,
        "used_count": 45,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 8,
        "code": "LUXURY2M",
        "description": "Giảm siêu khủng 2.000.000đ cho dàn PC Flagship từ 50.000.000đ",
        "discount_type": "FIXED_AMOUNT",
        "voucher_scope": "GLOBAL",
        "discount_value": 2000000.00,
        "min_order_amount": 50000000.00,
        "max_discount_amount": 2000000.00,
        "usage_limit": 150,
        "used_count": 28,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 9,
        "code": "MEGA10",
        "description": "Mega Voucher - Giảm 10% tối đa 1.500.000đ cho đơn từ 5.000.000đ",
        "discount_type": "PERCENTAGE",
        "voucher_scope": "GLOBAL",
        "discount_value": 10.00,
        "min_order_amount": 5000000.00,
        "max_discount_amount": 1500000.00,
        "usage_limit": 800,
        "used_count": 142,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 10,
        "code": "MEGA15",
        "description": "Siêu Sale Giữa Tháng - Giảm 15% tối đa 2.500.000đ cho đơn từ 8.000.000đ",
        "discount_type": "PERCENTAGE",
        "voucher_scope": "GLOBAL",
        "discount_value": 15.00,
        "min_order_amount": 8000000.00,
        "max_discount_amount": 2500000.00,
        "usage_limit": 400,
        "used_count": 89,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },

    # 4. Build PC & Category specific vouchers
    {
        "id": 11,
        "code": "BUILDPC500K",
        "description": "Ưu đãi Build PC Gaming - Giảm 500.000đ khi lắp trọn bộ từ 20.000.000đ",
        "discount_type": "FIXED_AMOUNT",
        "voucher_scope": "GLOBAL",
        "discount_value": 500000.00,
        "min_order_amount": 20000000.00,
        "max_discount_amount": 500000.00,
        "usage_limit": 600,
        "used_count": 115,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 12,
        "code": "BUILDPC1M5",
        "description": "Ưu đãi PC Custom Watercooling - Giảm 1.500.000đ cho đơn từ 45.000.000đ",
        "discount_type": "FIXED_AMOUNT",
        "voucher_scope": "GLOBAL",
        "discount_value": 1500000.00,
        "min_order_amount": 45000000.00,
        "max_discount_amount": 1500000.00,
        "usage_limit": 200,
        "used_count": 34,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 13,
        "code": "GAMINGGEAR10",
        "description": "Giảm 10% tối đa 300.000đ cho Bàn phím, Chuột, Tai nghe Gaming từ 800.000đ",
        "discount_type": "PERCENTAGE",
        "voucher_scope": "CATEGORY",
        "discount_value": 10.00,
        "min_order_amount": 800000.00,
        "max_discount_amount": 300000.00,
        "usage_limit": 1000,
        "used_count": 240,
        "category_id": "16", # Keyboard
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 14,
        "code": "VGAFLASH200K",
        "description": "Giảm 200.000đ khi mua Card đồ họa VGA RTX 40/50 Series từ 7.000.000đ",
        "discount_type": "FIXED_AMOUNT",
        "voucher_scope": "CATEGORY",
        "discount_value": 200000.00,
        "min_order_amount": 7000000.00,
        "max_discount_amount": 200000.00,
        "usage_limit": 500,
        "used_count": 92,
        "category_id": "10", # VGA
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 15,
        "code": "CPUKING150K",
        "description": "Giảm 150.000đ khi nâng cấp CPU Intel Core Ultra / Ryzen 9000 từ 4.000.000đ",
        "discount_type": "FIXED_AMOUNT",
        "voucher_scope": "CATEGORY",
        "discount_value": 150000.00,
        "min_order_amount": 4000000.00,
        "max_discount_amount": 150000.00,
        "usage_limit": 500,
        "used_count": 78,
        "category_id": "1", # CPU
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 16,
        "code": "RAMSSD88K",
        "description": "Giảm 88.000đ khi mua RAM DDR5 hoặc Ổ cứng SSD NVMe từ 1.200.000đ",
        "discount_type": "FIXED_AMOUNT",
        "voucher_scope": "CATEGORY",
        "discount_value": 88000.00,
        "min_order_amount": 1200000.00,
        "max_discount_amount": 88000.00,
        "usage_limit": 800,
        "used_count": 160,
        "category_id": "3", # RAM
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },

    # 5. Flash Sale & VIP Member
    {
        "id": 17,
        "code": "FLASHSALE12H",
        "description": "Flash Sale Khung Giờ Vàng 12h - Giảm 12% tối đa 800.000đ đơn từ 2.500.000đ",
        "discount_type": "PERCENTAGE",
        "voucher_scope": "GLOBAL",
        "discount_value": 12.00,
        "min_order_amount": 2500000.00,
        "max_discount_amount": 800000.00,
        "usage_limit": 300,
        "used_count": 145,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 18,
        "code": "MIDNIGHT50K",
        "description": "Cú Đêm Săn Sale (0h-2h) - Giảm ngay 50.000đ trực tiếp cho đơn từ 300.000đ",
        "discount_type": "FIXED_AMOUNT",
        "voucher_scope": "GLOBAL",
        "discount_value": 50000.00,
        "min_order_amount": 300000.00,
        "max_discount_amount": 50000.00,
        "usage_limit": 1000,
        "used_count": 310,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 19,
        "code": "VIPMEMBER3M",
        "description": "Đặc quyền VIP Diamond - Giảm siêu ưu đãi 3.000.000đ cho đơn từ 60.000.000đ",
        "discount_type": "FIXED_AMOUNT",
        "voucher_scope": "GLOBAL",
        "discount_value": 3000000.00,
        "min_order_amount": 60000000.00,
        "max_discount_amount": 3000000.00,
        "usage_limit": 100,
        "used_count": 18,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    },
    {
        "id": 20,
        "code": "LUXURYFEST20",
        "description": "Siêu Đại Tiệc Công Nghệ - Giảm 20% tối đa 5.000.000đ cho đơn từ 20.000.000đ",
        "discount_type": "PERCENTAGE",
        "voucher_scope": "GLOBAL",
        "discount_value": 20.00,
        "min_order_amount": 20000000.00,
        "max_discount_amount": 500000.00,
        "usage_limit": 150,
        "used_count": 52,
        "category_id": "NULL",
        "start_date": "2026-01-01 00:00:00",
        "end_date": "2026-12-31 23:59:59"
    }
]

# 10 Realistic Tickets with message conversations
tickets_data = [
    {
        "id": 1,
        "user_id": 22,
        "customer_name": "Nguyễn Tuấn Anh",
        "customer_email": "tuananh.gamer@gmail.com",
        "customer_phone": "0988112233",
        "subject": "Tư vấn cấu hình PC Gaming 35 triệu chơi Black Myth: Wukong và GTA 6 ở độ phân giải 2K",
        "category": "BUILD_PC",
        "status": "IN_PROGRESS",
        "assigned_admin": "staff.hoanglong",
        "created_at": "2026-08-20 09:30:00",
        "messages": [
            ("CUSTOMER", "Nguyễn Tuấn Anh", "Chào shop, mình có ngân sách khoảng 35 triệu, muốn build 1 case PC chuyên chơi game nặng như Black Myth Wukong, Cyberpunk và chuẩn bị cho GTA 6 ở màn hình 2K 165Hz. Nhờ shop tư vấn combo tối ưu nhất trong tầm giá giúp mình với ạ.", "2026-08-20 09:30:00"),
            ("ADMIN", "Lê Hoàng Long (Kỹ thuật viên)", "Chào anh Tuấn Anh! Với ngân sách 35 triệu để chiến mượt 2K Ultra Settings, Luxury PC xin tư vấn anh cấu hình tối ưu nhất: CPU Intel Core i5-14600KF (14 nhân 20 luồng) + Card đồ họa RTX 4070 Super 12GB GDDR6X + 32GB RAM DDR5 Corsair 6000MHz + Nguồn 750W 80 Plus Gold + Tản nhiệt nước AIO 360mm. Cấu hình này test thực tế Wukong 2K đạt 90-110 FPS rất mượt mà anh nhé!", "2026-08-20 10:05:00"),
            ("CUSTOMER", "Nguyễn Tuấn Anh", "Cấu hình này nhìn ưng quá shop ơi! Cho mình hỏi nguồn 750W có dư dả để sau này mình nâng cấp card lớn hơn không ạ? Và bên shop có hỗ trợ cài sẵn Windows với game test máy trước khi giao không?", "2026-08-20 10:20:00"),
            ("ADMIN", "Lê Hoàng Long (Kỹ thuật viên)", "Dạ nguồn 750W chuẩn Gold gánh i5-14600KF + RTX 4070 Super chỉ ăn khoảng 450W nên dư dả tải rất mát anh nhé. Khi anh đặt máy, Luxury PC sẽ hỗ trợ lắp đặt, đi dây giấu gọn gàng, cài sẵn Windows 11 Pro bản quyền, tối ưu BIOS XMP và stress test 2 tiếng trước khi giao tận nhà ạ!", "2026-08-20 10:35:00")
        ]
    },
    {
        "id": 2,
        "user_id": 23,
        "customer_name": "Trần Hoàng Nam",
        "customer_email": "namth.dev@gmail.com",
        "customer_phone": "0912345679",
        "subject": "Nhờ hướng dẫn bật XMP và tối ưu bus RAM Corsair Dominator Titanium 6000MHz trên main ASUS Z890",
        "category": "TECHNICAL",
        "status": "RESOLVED",
        "assigned_admin": "staff.minhduc",
        "created_at": "2026-08-22 14:10:00",
        "messages": [
            ("CUSTOMER", "Trần Hoàng Nam", "Hôm qua mình vừa nhận máy bên shop gửi, kiểm tra Task Manager thấy RAM đang hiển thị 4800MHz trong khi kit mình mua là 6000MHz. Shop hướng dẫn mình cách bật lên với ạ.", "2026-08-22 14:10:00"),
            ("ADMIN", "Đỗ Minh Đức (Kỹ thuật)", "Dạ chào anh Nam, mặc định chuẩn DDR5 khi mới cắm sẽ nhận bus gốc 4800MHz để đảm bảo tương thích boot máy. Anh làm theo các bước sau giúp em nhé:\n1. Khởi động lại máy, bấm liên tục phím DEL để vào BIOS.\n2. Ở trang EzMode góc trái, anh tìm mục 'X.M.P' chuyển từ Disabled sang 'XMP I' hoặc 'Profile 1'.\n3. Bấm phím F10 chọn 'Save & Exit' là xong ạ!", "2026-08-22 14:25:00"),
            ("CUSTOMER", "Trần Hoàng Nam", "Mình vừa làm theo và đã lên đúng 6000MHz rồi, máy khởi động nhanh và mượt hơn hẳn. Cảm ơn kỹ thuật viên đã hỗ trợ nhanh chóng nhé!", "2026-08-22 14:40:00"),
            ("ADMIN", "Đỗ Minh Đức (Kỹ thuật)", "Dạ không có gì ạ! Chúc anh có những trải nghiệm tuyệt vời cùng bộ máy mới. Cần hỗ trợ thêm anh cứ nhắn lại ticket này nhé!", "2026-08-22 14:45:00")
        ]
    },
    {
        "id": 3,
        "user_id": 59,
        "customer_name": "Đặng Trúc Hà",
        "customer_email": "khachhang038@gmail.com",
        "customer_phone": "0761979308",
        "subject": "Kiểm tra tiến độ vận chuyển đơn hàng #LXR2608230002 giao về Cầu Giấy Hà Nội",
        "category": "ORDER",
        "status": "IN_PROGRESS",
        "assigned_admin": "staff.thutrang",
        "created_at": "2026-08-24 08:45:00",
        "messages": [
            ("CUSTOMER", "Đặng Trúc Hà", "Shop ơi mình vừa đặt mua đơn hàng LXR2608230002 hôm qua, không biết hôm nay đã đóng gói và bàn giao cho đơn vị vận chuyển chưa ạ? Khoảng mấy giờ mình nhận được máy?", "2026-08-24 08:45:00"),
            ("ADMIN", "Trần Thị Thu Trang (CSKH)", "Chào chị Trúc Hà! Em kiểm tra hệ thống thấy đơn hàng của chị đã được đội ngũ kỹ thuật lắp ráp hoàn tất và bàn giao cho shipper chuyên biệt của Luxury PC lúc 8h30 sáng nay. Dự kiến khoảng 14h - 15h chiều nay shipper sẽ liên hệ trước khi giao tới địa chỉ số 311 Võ Văn Kiệt của chị ạ.", "2026-08-24 09:05:00"),
            ("CUSTOMER", "Đặng Trúc Hà", "Okie shop, chiều nay mình có nhà. Nhờ shipper gọi trước cho mình 15 phút nhé.", "2026-08-24 09:12:00")
        ]
    },
    {
        "id": 4,
        "user_id": 24,
        "customer_name": "Lê Quốc Bảo",
        "customer_email": "quocbao.tech@gmail.com",
        "customer_phone": "0918765432",
        "subject": "Card màn hình ASUS ROG RTX 4080 Super quạt không quay khi bật máy có phải lỗi không?",
        "category": "TECHNICAL",
        "status": "RESOLVED",
        "assigned_admin": "staff.quanghuy",
        "created_at": "2026-08-25 11:20:00",
        "messages": [
            ("CUSTOMER", "Lê Quốc Bảo", "Shop cho mình hỏi xíu, mình đang dùng card RTX 4080 Super mới mua bên bạn, lúc bật máy lướt web xem Youtube thì thấy 3 quạt của card hoàn toàn không quay. Lúc chơi game thì quạt mới quay. Như vậy có phải card bị lỗi cảm biến nhiệt không shop?", "2026-08-25 11:20:00"),
            ("ADMIN", "Nguyễn Quang Huy (Kỹ thuật)", "Dạ chào anh Bảo, anh hoàn toàn yên tâm nhé! Các dòng card cao cấp hiện nay của ASUS đều có công nghệ '0dB Fan Tech'. Khi nhiệt độ GPU dưới 50-55 độ C (khi lướt web, làm việc nhẹ), quạt sẽ tự động dừng hoàn toàn để giữ im lặng tuyệt đối và tăng tuổi thọ trục bi. Khi anh vào game nặng nhiệt độ tăng lên quạt sẽ tự động quay làm mát ạ!", "2026-08-25 11:35:00"),
            ("CUSTOMER", "Lê Quốc Bảo", "À ra là tính năng thông minh vậy à, mình cứ sợ bị kẹt quạt. Cảm ơn shop đã giải thích chi tiết!", "2026-08-25 11:42:00")
        ]
    },
    {
        "id": 5,
        "user_id": 25,
        "customer_name": "Phan Trường Giang",
        "customer_email": "giang.ai@gmail.com",
        "customer_phone": "0987654321",
        "subject": "Tư vấn cấu hình máy trạm chạy mô hình DeepSeek LLM và render 3D Blender ngân sách 70 triệu",
        "category": "BUILD_PC",
        "status": "OPEN",
        "assigned_admin": "staff.giahuynh",
        "created_at": "2026-08-27 15:30:00",
        "messages": [
            ("CUSTOMER", "Phan Trường Giang", "Xin chào Luxury PC, mình là kỹ sư AI đang cần build 1 bộ máy workstation chuyên dụng để chạy fine-tune các model LLM local (DeepSeek, Llama 3) và render mô hình 3D Blender. Ngân sách tầm 70-80 triệu, ưu tiên VRAM GPU lớn từ 24GB trở lên và RAM hệ thống tối thiểu 64GB. Nhờ shop lên cấu hình giúp.", "2026-08-27 15:30:00"),
            ("ADMIN", "Trương Gia Huỳnh (Workstation Specialist)", "Chào anh Giang! Đối với nhu cầu train/inference LLM và Render 3D nặng, cấu hình đề xuất chuẩn trạm cho anh gồm:\n- CPU: Intel Core Ultra 9 285K (24 nhân 24 luồng, đơn nhân cực mạnh)\n- Mainboard: ASUS ROG STRIX Z890-F GAMING WIFI\n- RAM: 64GB (2x32GB) DDR5 Corsair Dominator Titanium 6400MHz\n- VGA: MSI GeForce RTX 4090 24GB GDDR6X Gaming X Trio\n- SSD: 2TB Samsung 990 PRO Gen4x4 (Đọc 7450MB/s nạp tensor siêu nhanh)\n- Nguồn: Corsair RM1000e 1000W 80 Plus Gold ATX 3.0\n- Tản nhiệt nước: Corsair Nautilus 360 RS ARGB.\nTổng cấu hình khoảng 78.5 triệu, bên em có sẵn hàng để lắp ráp ngay cho anh ạ!", "2026-08-27 16:00:00")
        ]
    },
    {
        "id": 6,
        "user_id": 26,
        "customer_name": "Võ Tấn Phát",
        "customer_email": "tanphat.danang@gmail.com",
        "customer_phone": "0982345678",
        "subject": "Vỏ case Corsair 3500X có lắp vừa tản nhiệt nước AIO 360mm ở mặt nóc không?",
        "category": "TECHNICAL",
        "status": "RESOLVED",
        "assigned_admin": "staff.vietanh",
        "created_at": "2026-08-28 10:15:00",
        "messages": [
            ("CUSTOMER", "Võ Tấn Phát", "Shop cho mình hỏi case Corsair 3500X TG kính cường lực mình muốn lắp tản nước AIO 360mm ở nóc case và cắm card RTX 4080 dài 34cm thì có bị cấn không shop?", "2026-08-28 10:15:00"),
            ("ADMIN", "Hoàng Việt Anh (Kỹ thuật)", "Dạ chào anh Phát! Case Corsair 3500X được thiết kế khoang nóc rất thoáng, hỗ trợ hoàn hảo tản nước Rad 360mm dày tới 65mm (cả quạt) mà không hề cấn vào tản nhôm VRM mainboard. Chiều dài card VGA case hỗ trợ lên tới 410mm nên card RTX 4080 34cm lắp vào cực kỳ rộng rãi và đẹp mắt anh nhé!", "2026-08-28 10:30:00")
        ]
    },
    {
        "id": 7,
        "user_id": 27,
        "customer_name": "Ngô Bích Ngọc",
        "customer_email": "bichngoc.arc@gmail.com",
        "customer_phone": "0965432109",
        "subject": "Yêu cầu báo giá 10 bộ PC văn phòng kết hợp thiết kế đồ họa 2D Photoshop cho công ty kiến trúc",
        "category": "PRICE",
        "status": "OPEN",
        "assigned_admin": "staff.thuytien",
        "created_at": "2026-08-29 09:00:00",
        "messages": [
            ("CUSTOMER", "Ngô Bích Ngọc", "Kính gửi bộ phận kinh doanh Luxury PC, công ty kiến trúc bên mình đang cần mua mới 10 dàn máy tính cho nhân viên thiết kế 2D AutoCad, Photoshop và Sketchup. Ngân sách khoảng 18-20 triệu/bộ (đã bao gồm màn hình 27 inch IPS). Nhờ công ty gửi bảng báo giá chính thức có hóa đơn VAT và chính sách bảo hành doanh nghiệp qua email bichngoc.arc@gmail.com giúp mình nhé.", "2026-08-29 09:00:00"),
            ("ADMIN", "Vũ Thủy Tiên (Kinh doanh Doanh nghiệp)", "Kính chào chị Bích Ngọc! Em đã nhận được yêu cầu của công ty mình. Luxury PC có chính sách chiết khấu 8% cho đơn hàng doanh nghiệp từ 10 bộ, hỗ trợ xuất hóa đơn VAT điện tử đầy đủ và gói bảo hành tận nơi 24/7 trong 24 tháng. Em sẽ hoàn thiện file báo giá chi tiết và gửi vào email của chị trong vòng 30 phút tới ạ!", "2026-08-29 09:25:00")
        ]
    },
    {
        "id": 8,
        "user_id": 71,
        "customer_name": "Dương Thị Lam",
        "customer_email": "khachhang050@gmail.com",
        "customer_phone": "0347084450",
        "subject": "Hướng dẫn thủ tục trả góp 0% qua thẻ tín dụng và SePay chuyển khoản QR",
        "category": "ORDER",
        "status": "RESOLVED",
        "assigned_admin": "staff.phuongthao",
        "created_at": "2026-08-30 14:00:00",
        "messages": [
            ("CUSTOMER", "Dương Thị Lam", "Mình muốn mua bộ PC 25 triệu và thanh toán trả góp 0% qua thẻ tín dụng Visa Techcombank kỳ hạn 12 tháng thì thủ tục như thế nào vậy shop?", "2026-08-30 14:00:00"),
            ("ADMIN", "Bùi Phương Thảo (Tư vấn viên)", "Dạ chào chị Lam! Thủ tục trả góp qua thẻ tín dụng tại Luxury PC hoàn toàn online và duyệt tự động 100% không cần giấy tờ ạ. Tại bước thanh toán (Checkout), chị chọn phương thức 'Trả góp qua thẻ tín dụng', chọn ngân hàng Techcombank và kỳ hạn 12 tháng, sau đó nhập thông tin thẻ là hoàn tất đơn hàng trong 1 phút thôi ạ!", "2026-08-30 14:15:00"),
            ("CUSTOMER", "Dương Thị Lam", "Dạ tiện lợi quá, mình vừa hoàn tất đơn hàng rồi, shop kiểm tra đơn giúp mình nhé!", "2026-08-30 14:28:00")
        ]
    },
    {
        "id": 9,
        "user_id": 28,
        "customer_name": "Đỗ Minh Đức",
        "customer_email": "minhduc.tech@gmail.com",
        "customer_phone": "0912345678",
        "subject": "Xin link tải phần mềm chỉnh LED RGB cho linh kiện ROG Strix và Corsair iCUE",
        "category": "TECHNICAL",
        "status": "CLOSED",
        "assigned_admin": "staff.tuankiet",
        "created_at": "2026-08-31 16:20:00",
        "messages": [
            ("CUSTOMER", "Đỗ Minh Đức", "Shop cho mình xin link chuẩn để tải phần mềm đồng bộ đèn LED cho main ASUS và RAM Corsair với ạ.", "2026-08-31 16:20:00"),
            ("ADMIN", "Đặng Tuấn Kiệt (Kỹ thuật)", "Dạ chào anh Đức! Để chỉnh LED cho Mainboard/VGA ASUS anh tải phần mềm 'ASUS Armoury Crate' tại trang chủ asus.com. Còn đối với RAM/Fan Corsair anh tải phần mềm 'Corsair iCUE v5'. Hai phần mềm này có thể đồng bộ với nhau qua plugin Corsair ASUS Sync anh nhé!", "2026-08-31 16:35:00"),
            ("CUSTOMER", "Đỗ Minh Đức", "Cảm ơn kỹ thuật viên đã hướng dẫn tận tình, mình chỉnh xong đồng bộ màu tím cyberpunk đẹp lắm rồi!", "2026-08-31 16:50:00")
        ]
    },
    {
        "id": 10,
        "user_id": 55,
        "customer_name": "Huỳnh Đức Khoa",
        "customer_email": "khachhang034@gmail.com",
        "customer_phone": "0777610058",
        "subject": "Khen ngợi bạn nhân viên kỹ thuật hỗ trợ lắp máy tại nhà rất nhiệt tình và chu đáo",
        "category": "GENERAL",
        "status": "CLOSED",
        "assigned_admin": "staff.hoanglong",
        "created_at": "2026-09-01 11:00:00",
        "messages": [
            ("CUSTOMER", "Huỳnh Đức Khoa", "Mình gửi ticket này để gửi lời cảm ơn đến Luxury PC và đặc biệt là bạn kỹ thuật viên Long sáng nay đã mang dàn PC đến tận nhà mình lắp đặt. Bạn làm việc rất cẩn thận, đi dây siêu đẹp và còn nhiệt tình hướng dẫn mình cách bảo quản vệ sinh máy. Dịch vụ bên bạn rất chuyên nghiệp 10/10 điểm!", "2026-09-01 11:00:00"),
            ("ADMIN", "Lê Hoàng Long (Kỹ thuật viên)", "Dạ em Long đây ạ! Em thay mặt toàn thể đội ngũ Luxury PC chân thành cảm ơn anh Khoa đã tin tưởng và dành những lời khen ngợi quý báu cho em. Chúc anh có những phút giây giải trí và làm việc thật tuyệt vời bên cỗ máy mới. Luxury PC xin gửi tặng anh 1 Voucher tri ân giảm 500.000đ cho lần mua sắm tiếp theo ạ!", "2026-09-01 11:20:00")
        ]
    }
]

# Generate SQL script
sql_lines = []
sql_lines.append("SET QUOTED_IDENTIFIER ON;")
sql_lines.append("SET ANSI_NULLS ON;")
sql_lines.append("GO")
sql_lines.append("USE LUXURYPC;")
sql_lines.append("GO")

# 1. Truncate & Seed Vouchers
sql_lines.append("""
-- ----------------------------------------------------------------------------
-- 11. 20 MÃ GIẢM GIÁ VOUCHER ĐA DẠNG CHUẨN SHOPEE (FREESHIP, % GIẢM, GIÁ TRỊ CỐ ĐỊNH, VIP)
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'user_vouchers') AND type IN ('U')) DELETE FROM user_vouchers;
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'vouchers') AND type IN ('U')) DELETE FROM vouchers;
GO
SET IDENTITY_INSERT vouchers ON;
INSERT INTO vouchers (id, code, description, discount_type, voucher_scope, discount_value, min_order_amount, max_discount_amount, usage_limit, used_count, category_id, start_date, end_date, active, created_at) VALUES
""")

v_rows = []
for v in vouchers:
    desc = v["description"].replace("'", "''")
    max_d = f"{v['max_discount_amount']:.2f}" if v['max_discount_amount'] is not None else "NULL"
    row = f"({v['id']}, '{v['code']}', N'{desc}', '{v['discount_type']}', '{v['voucher_scope']}', {v['discount_value']:.2f}, {v['min_order_amount']:.2f}, {max_d}, {v['usage_limit']}, {v['used_count']}, {v['category_id']}, '{v['start_date']}', '{v['end_date']}', 1, '{v['start_date']}')"
    v_rows.append(row)

sql_lines.append(",\n".join(v_rows) + ";")
sql_lines.append("SET IDENTITY_INSERT vouchers OFF;")
sql_lines.append("DBCC CHECKIDENT ('vouchers', RESEED, 20);")
sql_lines.append("GO")

# 2. Seed User Vouchers (Give top users available saved vouchers)
sql_lines.append("""
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
""")

# 3. Truncate & Seed Tickets, Ticket Messages, Support Tickets
sql_lines.append("""
-- ----------------------------------------------------------------------------
-- 12. 10 TICKETS HỖ TRỢ TRÒ CHUYỆN THỰC TẾ NHƯ NGƯỜI THẬT
-- ----------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'ticket_messages') AND type IN ('U')) DELETE FROM ticket_messages;
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'tickets') AND type IN ('U')) DELETE FROM tickets;
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'support_tickets') AND type IN ('U')) DELETE FROM support_tickets;
GO

SET IDENTITY_INSERT tickets ON;
INSERT INTO tickets (id, customer_name, customer_email, customer_phone, subject, category, message, assigned_admin, status, created_at) VALUES
""")

t_rows = []
for t in tickets_data:
    name = t["customer_name"].replace("'", "''")
    subj = t["subject"].replace("'", "''")
    first_msg = t["messages"][0][2].replace("'", "''")
    row = f"({t['id']}, N'{name}', '{t['customer_email']}', '{t['customer_phone']}', N'{subj}', '{t['category']}', N'{first_msg}', '{t['assigned_admin']}', '{t['status']}', '{t['created_at']}')"
    t_rows.append(row)

sql_lines.append(",\n".join(t_rows) + ";")
sql_lines.append("SET IDENTITY_INSERT tickets OFF;")
sql_lines.append("DBCC CHECKIDENT ('tickets', RESEED, 10);")
sql_lines.append("GO")

# Seed Support Tickets (Synchronized Table)
sql_lines.append("""
SET IDENTITY_INSERT support_tickets ON;
INSERT INTO support_tickets (id, user_id, customer_name, customer_email, customer_phone, subject, category, message, admin_reply, assigned_admin, status, created_at, updated_at) VALUES
""")

st_rows = []
for t in tickets_data:
    name = t["customer_name"].replace("'", "''")
    subj = t["subject"].replace("'", "''")
    first_msg = t["messages"][0][2].replace("'", "''")
    admin_reply = t["messages"][1][2].replace("'", "''") if len(t["messages"]) > 1 else ""
    row = f"({t['id']}, {t['user_id']}, N'{name}', '{t['customer_email']}', '{t['customer_phone']}', N'{subj}', '{t['category']}', N'{first_msg}', N'{admin_reply}', '{t['assigned_admin']}', '{t['status']}', '{t['created_at']}', '{t['created_at']}')"
    st_rows.append(row)

sql_lines.append(",\n".join(st_rows) + ";")
sql_lines.append("SET IDENTITY_INSERT support_tickets OFF;")
sql_lines.append("DBCC CHECKIDENT ('support_tickets', RESEED, 10);")
sql_lines.append("GO")

# Seed Ticket Messages (Conversations)
sql_lines.append("""
SET IDENTITY_INSERT ticket_messages ON;
INSERT INTO ticket_messages (id, ticket_id, sender, sender_name, message, created_at) VALUES
""")

tm_rows = []
msg_id = 1
for t in tickets_data:
    for sender, s_name, msg_text, m_date in t["messages"]:
        s_name_esc = s_name.replace("'", "''")
        msg_esc = msg_text.replace("'", "''")
        row = f"({msg_id}, {t['id']}, '{sender}', N'{s_name_esc}', N'{msg_esc}', '{m_date}')"
        tm_rows.append(row)
        msg_id += 1

sql_lines.append(",\n".join(tm_rows) + ";")
sql_lines.append("SET IDENTITY_INSERT ticket_messages OFF;")
sql_lines.append(f"DBCC CHECKIDENT ('ticket_messages', RESEED, {msg_id - 1});")
sql_lines.append("GO")

full_sql = "\n".join(sql_lines)

with open('scratch/seed_vouchers_and_tickets.sql', 'w', encoding='utf-8') as f:
    f.write(full_sql)

print(f"Generated seed script for {len(vouchers)} vouchers and {len(tickets_data)} tickets with {msg_id-1} messages!")

# Execute SQL in database
cmd = ['sqlcmd', '-S', 'localhost', '-U', 'tuan2006', '-P', '24112004', '-C', '-f', '65001', '-i', 'scratch/seed_vouchers_and_tickets.sql']
res = subprocess.run(cmd, capture_output=True, text=True)
print("Execution Result:")
print(res.stdout)
if res.stderr:
    print("Stderr:", res.stderr)
