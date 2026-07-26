const fs = require('fs');
const path = require('path');

const dir = path.join(__dirname, 'pages', 'profile');

function updateFile(filename, activeText, pageTitle, pageDesc, contentHtml) {
    const filePath = path.join(dir, filename);
    if (!fs.existsSync(filePath)) return;
    let content = fs.readFileSync(filePath, 'utf8');

    // Remove active class from 'Hồ sơ cá nhân'
    content = content.replace(/<li class="active"><a href="profile.html">/g, '<li><a href="profile.html">');
    
    // Add active class to target
    const regex = new RegExp(`<li><a href="${filename}">([\\s\\S]*?${activeText})</a></li>`);
    content = content.replace(regex, `<li class="active"><a href="${filename}">$1</a></li>`);

    // Replace the main content area (from profile-page-header down)
    // The main content area in profile is from <div class="profile-content"> to <!-- Right Column (Stats & VIP) -->
    // Since it's easier, let's just replace everything inside <div class="profile-main"> ... </div>
    
    const newMainHtml = `
            <div class="profile-main" style="grid-template-columns: 1fr;">
                <div class="profile-content">
                    <div class="profile-page-header">
                        <h1 class="profile-page-title">${pageTitle}</h1>
                        <p class="profile-page-desc">${pageDesc}</p>
                    </div>
                    ${contentHtml}
                </div>
            </div>`;

    // Regex to match <div class="profile-main">...</div>
    // This is a bit tricky due to nested divs. Let's just do a string split since we know the exact structure
    const splitStart = content.indexOf('<div class="profile-main">');
    const splitEnd = content.indexOf('</div>\n        </div>\n    </main>');
    
    if (splitStart !== -1 && splitEnd !== -1) {
        content = content.substring(0, splitStart) + newMainHtml + content.substring(splitEnd);
    }
    
    fs.writeFileSync(filePath, content);
    console.log(`Updated ${filename}`);
}

// 1. Orders
const ordersHtml = `
    <div class="profile-panel">
        <div class="panel-header" style="border-bottom: 1px solid var(--border-color); padding-bottom: 15px; margin-bottom: 15px;">
            <h2 class="panel-title">Đơn hàng #PC250531001</h2>
            <span style="color: #f59e0b; font-weight: 500; font-size: 14px;">Chờ xác nhận</span>
        </div>
        <div style="display: flex; gap: 15px; margin-bottom: 15px;">
            <img src="../../assets/images/case_purple.png" style="width: 80px; height: 80px; object-fit: cover; border-radius: 8px; border: 1px solid var(--border-color);">
            <div>
                <h4 style="margin-bottom: 5px;">PC Gaming LUXURY - i5 13400F / 16GB / RTX 4060</h4>
                <p style="color: var(--text-secondary); font-size: 13px;">Phân loại: Màu đen</p>
                <p style="font-weight: 600; margin-top: 5px;">12.990.000đ <span style="font-weight: 400; color: var(--text-secondary); font-size: 13px;">x1</span></p>
            </div>
        </div>
        <div style="text-align: right; border-top: 1px solid var(--border-color); padding-top: 15px;">
            Tổng tiền: <span style="font-size: 18px; font-weight: 700; color: #ef4444;">12.990.000đ</span>
        </div>
    </div>
    
    <div class="profile-panel">
        <div class="panel-header" style="border-bottom: 1px solid var(--border-color); padding-bottom: 15px; margin-bottom: 15px;">
            <h2 class="panel-title">Đơn hàng #PC250531002</h2>
            <span style="color: #10b981; font-weight: 500; font-size: 14px;">Hoàn thành</span>
        </div>
        <div style="display: flex; gap: 15px; margin-bottom: 15px;">
            <img src="../../assets/images/case_purple.png" style="width: 80px; height: 80px; object-fit: cover; border-radius: 8px; border: 1px solid var(--border-color);">
            <div>
                <h4 style="margin-bottom: 5px;">PC Gaming PRO - i7 13700K / 32GB / RTX 4070</h4>
                <p style="color: var(--text-secondary); font-size: 13px;">Phân loại: Màu trắng</p>
                <p style="font-weight: 600; margin-top: 5px;">24.990.000đ <span style="font-weight: 400; color: var(--text-secondary); font-size: 13px;">x1</span></p>
            </div>
        </div>
        <div style="text-align: right; border-top: 1px solid var(--border-color); padding-top: 15px;">
            Tổng tiền: <span style="font-size: 18px; font-weight: 700; color: #ef4444;">24.990.000đ</span>
            <div style="margin-top: 15px;">
                <button class="btn-update" style="float: none; display: inline-block;">Mua lại</button>
            </div>
        </div>
    </div>
`;
updateFile('profile-orders.html', 'Đơn hàng của tôi', 'Đơn hàng của tôi', 'Quản lý lịch sử mua hàng và trạng thái đơn hàng', ordersHtml);

// 2. Addresses
const addressesHtml = `
    <div class="profile-panel">
        <div class="panel-header">
            <h2 class="panel-title">ĐỊA CHỈ CỦA TÔI</h2>
            <button class="btn-link-action"><i class="fa-solid fa-plus"></i> THÊM ĐỊA CHỈ MỚI</button>
        </div>

        <div class="address-list">
            <!-- Address 1 -->
            <div class="address-item" style="align-items: center;">
                <div class="address-info">
                    <div class="address-title">
                        Nguyễn Văn A | 0901 234 567
                    </div>
                    <div class="address-desc">123 Đường ABC, Phường 1, Quận 1, TP. Hồ Chí Minh</div>
                    <div class="badge-default" style="display: inline-block; margin-top: 5px; color: var(--accent-blue); background: #eff6ff;">Mặc định</div>
                </div>
                <div class="address-actions">
                    <button class="btn-action btn-edit"><i class="fa-solid fa-pen"></i> CẬP NHẬT</button>
                </div>
            </div>

            <!-- Address 2 -->
            <div class="address-item" style="align-items: center;">
                <div class="address-info">
                    <div class="address-title">
                        Nguyễn Văn A | 0901 234 567
                    </div>
                    <div class="address-desc">456 Đường XYZ, Phường 2, Quận 3, TP. Hồ Chí Minh</div>
                </div>
                <div class="address-actions">
                    <button class="btn-action btn-edit"><i class="fa-solid fa-pen"></i> CẬP NHẬT</button>
                    <button class="btn-action btn-delete"><i class="fa-regular fa-trash-can"></i> XÓA</button>
                </div>
            </div>
        </div>
    </div>
`;
updateFile('profile-addresses.html', 'Địa chỉ của tôi', 'Địa chỉ của tôi', 'Quản lý thông tin địa chỉ giao hàng', addressesHtml);

// 3. Password
const passwordHtml = `
    <div class="profile-panel">
        <div class="panel-header">
            <h2 class="panel-title">ĐỔI MẬT KHẨU</h2>
        </div>
        
        <div style="max-width: 500px; padding: 20px 0;">
            <div class="form-group" style="margin-bottom: 20px;">
                <label class="form-label">Mật khẩu hiện tại</label>
                <input type="password" class="form-control" placeholder="Nhập mật khẩu hiện tại">
            </div>
            <div class="form-group" style="margin-bottom: 20px;">
                <label class="form-label">Mật khẩu mới</label>
                <input type="password" class="form-control" placeholder="Nhập mật khẩu mới (tối thiểu 8 ký tự)">
            </div>
            <div class="form-group" style="margin-bottom: 30px;">
                <label class="form-label">Xác nhận mật khẩu mới</label>
                <input type="password" class="form-control" placeholder="Nhập lại mật khẩu mới">
            </div>

            <div class="clearfix">
                <button class="btn-update" style="float: left;">LƯU MẬT KHẨU</button>
            </div>
        </div>
    </div>
`;
updateFile('profile-password.html', 'Đổi mật khẩu', 'Đổi mật khẩu', 'Bảo mật tài khoản của bạn', passwordHtml);

// Fix links in all profile pages to connect them
const allFiles = ['profile.html', 'profile-orders.html', 'profile-addresses.html', 'profile-password.html'];
allFiles.forEach(file => {
    let content = fs.readFileSync(path.join(dir, file), 'utf8');
    
    // Convert dead links to placeholder # if they don't have pages
    content = content.replace(/href="#"([^>]*)>([^<]*?)Sản phẩm yêu thích/g, 'href="#"$1>$2Sản phẩm yêu thích');
    content = content.replace(/href="#"([^>]*)>([^<]*?)Phương thức thanh toán/g, 'href="#"$1>$2Phương thức thanh toán');
    content = content.replace(/href="#"([^>]*)>([^<]*?)Thông báo/g, 'href="#"$1>$2Thông báo');
    
    fs.writeFileSync(path.join(dir, file), content);
});
