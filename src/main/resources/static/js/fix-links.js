const fs = require('fs');
const path = require('path');

const dir = path.join(__dirname, 'admin');
const files = fs.readdirSync(dir).filter(f => f.endsWith('.html'));

files.forEach(file => {
    let content = fs.readFileSync(path.join(dir, file), 'utf8');
    
    content = content.replace(/href="#" class="menu-link">\s*<i class="fa-solid fa-box"><\/i> Đơn hàng/g, 'href="orders.html" class="menu-link">\n                    <i class="fa-solid fa-box"></i> Đơn hàng');
    
    content = content.replace(/href="#" class="menu-link">\s*<i class="fa-solid fa-users"><\/i> Người dùng/g, 'href="users.html" class="menu-link">\n                    <i class="fa-solid fa-users"></i> Người dùng');
    
    content = content.replace(/href="#" class="menu-link">\s*<i class="fa-solid fa-ticket"><\/i> Voucher/g, 'href="vouchers.html" class="menu-link">\n                    <i class="fa-solid fa-ticket"></i> Voucher');
    
    content = content.replace(/href="#" class="menu-link">\s*<i class="fa-solid fa-bolt"><\/i> Flash Sale/g, 'href="flash-sale.html" class="menu-link">\n                    <i class="fa-solid fa-bolt"></i> Flash Sale');
    
    content = content.replace(/href="#" class="menu-link">\s*<i class="fa-solid fa-list"><\/i> Danh mục/g, 'href="categories.html" class="menu-link">\n                    <i class="fa-solid fa-list"></i> Danh mục');
    
    fs.writeFileSync(path.join(dir, file), content);
});
console.log("Updated links in all HTML files.");
