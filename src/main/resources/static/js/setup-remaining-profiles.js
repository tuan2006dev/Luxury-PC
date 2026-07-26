const fs = require('fs');
const path = require('path');

const dir = path.join(__dirname, 'pages', 'profile');

function createProfilePage(filename, activeText, pageTitle, pageDesc, contentHtml) {
    const sourcePath = path.join(dir, 'profile.html');
    const targetPath = path.join(dir, filename);
    
    let content = fs.readFileSync(sourcePath, 'utf8');

    // Remove active class from 'Hồ sơ cá nhân'
    content = content.replace(/<li class="active"><a href="profile.html">/g, '<li><a href="profile.html">');
    
    // Add active class to target
    const regex = new RegExp(`<li><a href="${filename}">([\\s\\S]*?${activeText})</a></li>`);
    content = content.replace(regex, `<li class="active"><a href="${filename}">$1</a></li>`);

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

    const splitStart = content.indexOf('<div class="profile-main">');
    const splitEnd = content.indexOf('</div>\n        </div>\n    </main>');
    
    if (splitStart !== -1 && splitEnd !== -1) {
        content = content.substring(0, splitStart) + newMainHtml + content.substring(splitEnd);
    }
    
    fs.writeFileSync(targetPath, content);
    console.log(`Created ${filename}`);
}

const wishlistHtml = `
    <div class="profile-panel">
        <div class="panel-header">
            <h2 class="panel-title">SẢN PHẨM YÊU THÍCH</h2>
        </div>
        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
            <div style="border: 1px solid var(--border-color); border-radius: 8px; padding: 15px; position: relative;">
                <i class="fa-solid fa-heart" style="position: absolute; top: 15px; right: 15px; color: #ef4444; font-size: 18px; cursor: pointer;"></i>
                <img src="../../assets/images/case_purple.png" style="width: 100%; height: 180px; object-fit: cover; border-radius: 6px; margin-bottom: 15px;">
                <h4 style="font-size: 14px; margin-bottom: 8px; line-height: 1.4; font-weight: 500;">PC Gaming LUXURY - i5 13400F / 16GB / RTX 4060</h4>
                <div style="color: #ef4444; font-weight: 600; font-size: 16px; margin-bottom: 15px;">12.990.000đ</div>
                <button class="btn-update" style="width: 100%; float: none; text-align: center; font-size: 12px; padding: 10px;"><i class="fa-solid fa-cart-plus"></i> THÊM GIỎ HÀNG</button>
            </div>
            <div style="border: 1px solid var(--border-color); border-radius: 8px; padding: 15px; position: relative;">
                <i class="fa-solid fa-heart" style="position: absolute; top: 15px; right: 15px; color: #ef4444; font-size: 18px; cursor: pointer;"></i>
                <img src="../../assets/images/case_purple.png" style="width: 100%; height: 180px; object-fit: cover; border-radius: 6px; margin-bottom: 15px;">
                <h4 style="font-size: 14px; margin-bottom: 8px; line-height: 1.4; font-weight: 500;">Màn hình Gaming ASUS TUF 27 inch 165Hz</h4>
                <div style="color: #ef4444; font-weight: 600; font-size: 16px; margin-bottom: 15px;">4.590.000đ</div>
                <button class="btn-update" style="width: 100%; float: none; text-align: center; font-size: 12px; padding: 10px;"><i class="fa-solid fa-cart-plus"></i> THÊM GIỎ HÀNG</button>
            </div>
        </div>
    </div>
`;
createProfilePage('profile-wishlist.html', 'Sản phẩm yêu thích', 'Sản phẩm yêu thích', 'Danh sách các sản phẩm bạn đã lưu lại', wishlistHtml);

const notifHtml = `
    <div class="profile-panel">
        <div class="panel-header">
            <h2 class="panel-title">THÔNG BÁO CỦA TÔI</h2>
            <button class="btn-link-action" style="color: var(--text-secondary);"><i class="fa-solid fa-check-double"></i> Đánh dấu đã đọc tất cả</button>
        </div>
        <div class="notification-list" style="display: flex; flex-direction: column; gap: 15px;">
            <div style="display: flex; gap: 15px; padding: 15px; background: #eff6ff; border-radius: 8px; border-left: 4px solid var(--accent-blue);">
                <div style="width: 40px; height: 40px; background: #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--accent-blue); flex-shrink: 0;"><i class="fa-solid fa-box"></i></div>
                <div>
                    <h4 style="margin-bottom: 5px; font-size: 14px; color: var(--accent-blue);">Đơn hàng #PC250531001 đang được giao</h4>
                    <p style="color: var(--text-secondary); font-size: 13px; margin-bottom: 5px; line-height: 1.5;">Đơn hàng của bạn đã được bàn giao cho đơn vị vận chuyển. Dự kiến giao trong ngày mai. Vui lòng chú ý điện thoại.</p>
                    <span style="font-size: 12px; color: var(--text-muted);">2 giờ trước</span>
                </div>
            </div>
            
            <div style="display: flex; gap: 15px; padding: 15px; border: 1px solid var(--border-color); border-radius: 8px;">
                <div style="width: 40px; height: 40px; background: #f1f5f9; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--text-secondary); flex-shrink: 0;"><i class="fa-solid fa-ticket"></i></div>
                <div>
                    <h4 style="margin-bottom: 5px; font-size: 14px;">Chúc mừng bạn đã thăng hạng Thành viên</h4>
                    <p style="color: var(--text-secondary); font-size: 13px; margin-bottom: 5px; line-height: 1.5;">Tài khoản của bạn đã được nâng cấp. Bạn nhận được 1 voucher giảm 10% cho đơn hàng tiếp theo.</p>
                    <span style="font-size: 12px; color: var(--text-muted);">3 ngày trước</span>
                </div>
            </div>
        </div>
    </div>
`;
createProfilePage('profile-notifications.html', 'Thông báo', 'Thông báo', 'Cập nhật tình trạng đơn hàng và khuyến mãi mới nhất', notifHtml);

const paymentsHtml = `
    <div class="profile-panel">
        <div class="panel-header">
            <h2 class="panel-title">PHƯƠNG THỨC THANH TOÁN</h2>
            <button class="btn-link-action"><i class="fa-solid fa-plus"></i> THÊM THẺ MỚI</button>
        </div>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <div style="background: linear-gradient(135deg, #1e293b, #0f172a); color: #fff; border-radius: 12px; padding: 25px; position: relative; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);">
                <div style="position: absolute; right: -20px; bottom: -20px; font-size: 120px; color: rgba(255,255,255,0.03);"><i class="fa-brands fa-cc-visa"></i></div>
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                    <div style="font-size: 32px;"><i class="fa-brands fa-cc-visa"></i></div>
                    <span style="background: rgba(255,255,255,0.2); font-size: 11px; padding: 4px 10px; border-radius: 20px; font-weight: 500;">Mặc định</span>
                </div>
                <div style="font-size: 20px; letter-spacing: 3px; margin-bottom: 20px; font-family: monospace;">**** **** **** 4242</div>
                <div style="display: flex; justify-content: space-between; font-size: 12px; color: rgba(255,255,255,0.7); text-transform: uppercase;">
                    <div>
                        <div style="font-size: 10px; opacity: 0.7; margin-bottom: 3px;">Tên in trên thẻ</div>
                        <div style="font-weight: 500; font-size: 13px; color: #fff;">NGUYEN VAN A</div>
                    </div>
                    <div style="text-align: right;">
                        <div style="font-size: 10px; opacity: 0.7; margin-bottom: 3px;">Hết hạn</div>
                        <div style="font-weight: 500; font-size: 13px; color: #fff;">12/28</div>
                    </div>
                </div>
            </div>
            
            <div style="border: 2px dashed var(--border-color); border-radius: 12px; display: flex; flex-direction: column; align-items: center; justify-content: center; color: var(--text-secondary); cursor: pointer; min-height: 180px; transition: 0.2s;">
                <i class="fa-solid fa-plus" style="font-size: 24px; margin-bottom: 10px; color: var(--accent-blue);"></i>
                <span style="font-size: 14px; font-weight: 500;">Thêm thẻ tín dụng/ghi nợ</span>
            </div>
        </div>
    </div>
`;
createProfilePage('profile-payments.html', 'Phương thức thanh toán', 'Phương thức thanh toán', 'Quản lý các loại thẻ và hình thức thanh toán của bạn', paymentsHtml);

// Fix links in ALL 7 profile pages
const allFiles = fs.readdirSync(dir).filter(f => f.startsWith('profile') && f.endsWith('.html'));

allFiles.forEach(file => {
    let content = fs.readFileSync(path.join(dir, file), 'utf8');
    
    // Convert dead links back to proper links if they were replaced with # previously
    // Just to be safe, I will do a blunt replace on the entire block for all files to ensure perfect sync
    const newSidebarMenu = `
                <ul class="profile-menu">
                    <li class="${file === 'profile.html' ? 'active' : ''}"><a href="profile.html"><i class="fa-regular fa-user"></i> Hồ sơ cá nhân</a></li>
                    <li class="${file === 'profile-orders.html' ? 'active' : ''}"><a href="profile-orders.html"><i class="fa-solid fa-box"></i> Đơn hàng của tôi</a></li>
                    <li class="${file === 'profile-wishlist.html' ? 'active' : ''}"><a href="profile-wishlist.html"><i class="fa-regular fa-heart"></i> Sản phẩm yêu thích</a></li>
                    <li class="${file === 'profile-addresses.html' ? 'active' : ''}"><a href="profile-addresses.html"><i class="fa-solid fa-location-dot"></i> Địa chỉ của tôi</a></li>
                    <li class="${file === 'profile-payments.html' ? 'active' : ''}"><a href="profile-payments.html"><i class="fa-regular fa-credit-card"></i> Phương thức thanh toán</a></li>
                    <li class="${file === 'profile-notifications.html' ? 'active' : ''}"><a href="profile-notifications.html"><i class="fa-regular fa-bell"></i> Thông báo</a></li>
                    <li class="${file === 'profile-password.html' ? 'active' : ''}"><a href="profile-password.html"><i class="fa-solid fa-lock"></i> Đổi mật khẩu</a></li>
                    <li><a href="../login/login.html"><i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất</a></li>
                </ul>`;
                
    const regexMenu = /<ul class="profile-menu">[\s\S]*?<\/ul>/;
    content = content.replace(regexMenu, newSidebarMenu);
    
    fs.writeFileSync(path.join(dir, file), content);
});
console.log("All links synchronized!");
