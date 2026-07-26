const fs = require('fs');
const path = require('path');

const rootDir = __dirname;

// 1. Add responsive CSS to components/header/header.css
const headerCssPath = path.join(rootDir, 'components', 'header', 'header.css');
if (fs.existsSync(headerCssPath)) {
    let css = fs.readFileSync(headerCssPath, 'utf8');
    if (!css.includes('@media (max-width: 991px)')) {
        css += `\n
/* --- RESPONSIVE HEADER --- */
@media (max-width: 991px) {
    .topbar { display: none; } /* Hide topbar on mobile/tablet to save space */
    
    .hamburger-btn {
        display: block !important;
        font-size: 24px;
        background: none;
        border: none;
        color: var(--text-primary);
        cursor: pointer;
        padding: 5px;
        order: -1; /* Move to the left */
        margin-right: 15px;
    }

    .main-nav {
        position: fixed;
        top: 0;
        left: -100%;
        width: 280px;
        height: 100vh;
        background: #fff;
        z-index: 1000;
        box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        transition: 0.3s ease;
        padding-top: 60px;
    }

    .main-nav.active {
        left: 0;
    }

    .nav-list {
        flex-direction: column;
        align-items: flex-start;
        gap: 0;
    }

    .nav-list li {
        width: 100%;
        border-bottom: 1px solid var(--border-color);
    }

    .nav-list li a {
        display: block;
        padding: 15px 20px;
    }

    /* Mobile menu overlay */
    .menu-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.5);
        z-index: 999;
        display: none;
    }
    
    .menu-overlay.active {
        display: block;
    }
    
    .menu-close-btn {
        display: block !important;
        position: absolute;
        top: 15px;
        right: 15px;
        font-size: 24px;
        background: none;
        border: none;
        color: var(--text-primary);
        cursor: pointer;
    }
    
    .header-actions {
        gap: 15px;
    }
    
    .header-actions > a:first-child {
        display: none; /* Hide username text on mobile to save space */
    }
}
`;
        fs.writeFileSync(headerCssPath, css);
    }
}

// 2. Modify header.html to include hamburger button and close button
const headerHtmlPath = path.join(rootDir, 'components', 'header', 'header.html');
if (fs.existsSync(headerHtmlPath)) {
    let html = fs.readFileSync(headerHtmlPath, 'utf8');
    if (!html.includes('hamburger-btn')) {
        // Add hamburger before the logo
        html = html.replace('<a href="../../index.html" class="logo">', 
        '<button class="hamburger-btn" style="display: none;" id="mobile-menu-btn"><i class="fa-solid fa-bars"></i></button>\n            <a href="../../index.html" class="logo">');
        
        // Add close button and overlay to nav
        html = html.replace('<nav class="main-nav">', 
        '<div class="menu-overlay" id="mobile-menu-overlay"></div>\n            <nav class="main-nav" id="mobile-nav">\n                <button class="menu-close-btn" style="display: none;" id="mobile-menu-close"><i class="fa-solid fa-xmark"></i></button>');
        
        fs.writeFileSync(headerHtmlPath, html);
    }
}

// 3. Update global.js to handle hamburger toggle
const globalJsPath = path.join(rootDir, 'assets', 'js', 'global.js');
if (fs.existsSync(globalJsPath)) {
    let js = fs.readFileSync(globalJsPath, 'utf8');
    if (!js.includes('mobile-menu-btn')) {
        const scriptToAdd = `
        // Bind Mobile Menu Events
        setTimeout(() => {
            const btnOpen = document.getElementById('mobile-menu-btn');
            const btnClose = document.getElementById('mobile-menu-close');
            const nav = document.getElementById('mobile-nav');
            const overlay = document.getElementById('mobile-menu-overlay');
            
            if (btnOpen && nav) {
                btnOpen.addEventListener('click', () => {
                    nav.classList.add('active');
                    if (overlay) overlay.classList.add('active');
                });
                
                const closeMenu = () => {
                    nav.classList.remove('active');
                    if (overlay) overlay.classList.remove('active');
                };
                
                if (btnClose) btnClose.addEventListener('click', closeMenu);
                if (overlay) overlay.addEventListener('click', closeMenu);
            }
        }, 500); // wait for header to be injected
`;
        // Insert before the last catch block or just append inside the try block
        js = js.replace('} catch (e) {', scriptToAdd + '    } catch (e) {');
        fs.writeFileSync(globalJsPath, js);
    }
}

// 4. Update footer.css
const footerCssPath = path.join(rootDir, 'components', 'footer', 'footer.css');
if (fs.existsSync(footerCssPath)) {
    let css = fs.readFileSync(footerCssPath, 'utf8');
    if (!css.includes('@media')) {
        css += `\n
@media (max-width: 991px) {
    .footer-inner {
        grid-template-columns: repeat(2, 1fr);
        gap: 30px;
    }
}
@media (max-width: 576px) {
    .footer-inner {
        grid-template-columns: 1fr;
    }
}
`;
        fs.writeFileSync(footerCssPath, css);
    }
}

// 5. Update global.css
const globalCssPath = path.join(rootDir, 'assets', 'css', 'global.css');
if (fs.existsSync(globalCssPath)) {
    let css = fs.readFileSync(globalCssPath, 'utf8');
    if (!css.includes('@media')) {
        css += `\n
@media (max-width: 768px) {
    .page-title { font-size: 22px; }
    .page-subtitle { font-size: 13px; }
    .product-card { padding: 15px; }
}
`;
        fs.writeFileSync(globalCssPath, css);
    }
}

// 6. Update home.css
const homeCssPath = path.join(rootDir, 'pages', 'home', 'home.css');
if (fs.existsSync(homeCssPath)) {
    let css = fs.readFileSync(homeCssPath, 'utf8');
    if (!css.includes('@media')) {
        css += `\n
@media (max-width: 991px) {
    .product-grid, .news-grid {
        grid-template-columns: repeat(3, 1fr);
    }
    .features {
        grid-template-columns: repeat(2, 1fr);
    }
}
@media (max-width: 768px) {
    .product-grid, .news-grid {
        grid-template-columns: repeat(2, 1fr);
        gap: 15px;
    }
    .categories {
        overflow-x: auto;
        padding-bottom: 10px;
        justify-content: flex-start;
    }
    .category-item {
        min-width: 120px;
    }
    .features {
        grid-template-columns: 1fr;
    }
}
@media (max-width: 480px) {
    .product-grid {
        grid-template-columns: 1fr;
    }
}
`;
        fs.writeFileSync(homeCssPath, css);
    }
}

// 7. Update products.css
const productsCssPath = path.join(rootDir, 'pages', 'products', 'products.css');
if (fs.existsSync(productsCssPath)) {
    let css = fs.readFileSync(productsCssPath, 'utf8');
    if (!css.includes('@media')) {
        css += `\n
@media (max-width: 991px) {
    .products-layout {
        display: flex;
        flex-direction: column;
    }
    .products-sidebar {
        width: 100%;
        margin-bottom: 20px;
    }
    .products-grid {
        grid-template-columns: repeat(3, 1fr);
    }
}
@media (max-width: 768px) {
    .products-grid {
        grid-template-columns: repeat(2, 1fr);
        gap: 15px;
    }
}
@media (max-width: 480px) {
    .products-grid {
        grid-template-columns: 1fr;
    }
}
`;
        fs.writeFileSync(productsCssPath, css);
    }
}

// 8. Update product-detail.css
const pdCssPath = path.join(rootDir, 'pages', 'product-detail', 'product-detail.css');
if (fs.existsSync(pdCssPath)) {
    let css = fs.readFileSync(pdCssPath, 'utf8');
    if (!css.includes('@media')) {
        css += `\n
@media (max-width: 991px) {
    .pd-layout {
        grid-template-columns: 1fr;
        gap: 30px;
    }
    .pd-gallery {
        position: relative;
        top: 0;
    }
}
`;
        fs.writeFileSync(pdCssPath, css);
    }
}

// 9. Update cart.css
const cartCssPath = path.join(rootDir, 'pages', 'cart', 'cart.css');
if (fs.existsSync(cartCssPath)) {
    let css = fs.readFileSync(cartCssPath, 'utf8');
    if (!css.includes('@media')) {
        css += `\n
@media (max-width: 991px) {
    .cart-layout {
        grid-template-columns: 1fr;
    }
}
@media (max-width: 768px) {
    .cart-table-wrapper {
        overflow-x: auto;
    }
    .cart-table {
        min-width: 600px;
    }
}
`;
        fs.writeFileSync(cartCssPath, css);
    }
}

// 10. Update checkout.css
const checkoutCssPath = path.join(rootDir, 'pages', 'checkout', 'checkout.css');
if (fs.existsSync(checkoutCssPath)) {
    let css = fs.readFileSync(checkoutCssPath, 'utf8');
    if (!css.includes('@media')) {
        css += `\n
@media (max-width: 991px) {
    .checkout-layout {
        grid-template-columns: 1fr;
    }
}
`;
        fs.writeFileSync(checkoutCssPath, css);
    }
}

// 11. Update build-pc.css
const buildCssPath = path.join(rootDir, 'pages', 'build-pc', 'build-pc.css');
if (fs.existsSync(buildCssPath)) {
    let css = fs.readFileSync(buildCssPath, 'utf8');
    if (!css.includes('@media')) {
        css += `\n
@media (max-width: 991px) {
    .build-table-wrapper {
        overflow-x: auto;
    }
    .build-table {
        min-width: 800px;
    }
    .build-totals {
        flex-direction: column;
        align-items: flex-start;
        gap: 15px;
    }
    .build-actions {
        width: 100%;
        display: flex;
        flex-direction: column;
    }
}
`;
        fs.writeFileSync(buildCssPath, css);
    }
}

// 12. Update profile.css
const profileCssPath = path.join(rootDir, 'pages', 'profile', 'profile.css');
if (fs.existsSync(profileCssPath)) {
    let css = fs.readFileSync(profileCssPath, 'utf8');
    if (!css.includes('@media')) {
        css += `\n
@media (max-width: 991px) {
    .profile-container {
        flex-direction: column;
    }
    .profile-sidebar {
        width: 100%;
    }
    .profile-main {
        grid-template-columns: 1fr;
    }
}
@media (max-width: 768px) {
    .form-grid {
        grid-template-columns: 1fr;
    }
    .profile-menu {
        display: flex;
        overflow-x: auto;
        white-space: nowrap;
    }
    .profile-menu li {
        flex-shrink: 0;
    }
    .profile-menu li a {
        border-left: none;
        border-bottom: 3px solid transparent;
    }
    .profile-menu li.active a {
        border-left: none;
        border-bottom: 3px solid var(--accent-blue);
    }
}
`;
        fs.writeFileSync(profileCssPath, css);
    }
}

// 13. Update promotions.css
const promoCssPath = path.join(rootDir, 'pages', 'promotions', 'promotions.css');
if (fs.existsSync(promoCssPath)) {
    let css = fs.readFileSync(promoCssPath, 'utf8');
    if (!css.includes('@media')) {
        css += `\n
@media (max-width: 991px) {
    .promo-banners, .layout-2col {
        grid-template-columns: 1fr;
    }
    .flash-grid {
        grid-template-columns: repeat(3, 1fr);
    }
    .voucher-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}
@media (max-width: 768px) {
    .flash-grid {
        grid-template-columns: repeat(2, 1fr);
    }
    .voucher-grid {
        grid-template-columns: 1fr;
    }
    .banner-content h2 {
        font-size: 24px !important;
    }
    .countdown-box {
        transform: scale(0.8);
        transform-origin: left;
    }
}
@media (max-width: 480px) {
    .flash-grid {
        grid-template-columns: 1fr;
    }
}
`;
        fs.writeFileSync(promoCssPath, css);
    }
}

// 14. Update login.css
const loginCssPath = path.join(rootDir, 'pages', 'login', 'login.css');
if (fs.existsSync(loginCssPath)) {
    let css = fs.readFileSync(loginCssPath, 'utf8');
    if (!css.includes('@media')) {
        css += `\n
@media (max-width: 768px) {
    .login-container {
        grid-template-columns: 1fr;
    }
    .login-image {
        display: none;
    }
    .login-form-wrapper {
        padding: 40px 20px;
    }
}
`;
        fs.writeFileSync(loginCssPath, css);
    }
}

// 15. Update admin.css and admin-table.css
const adminCssPath = path.join(rootDir, 'admin', 'admin.css');
if (fs.existsSync(adminCssPath)) {
    let css = fs.readFileSync(adminCssPath, 'utf8');
    if (!css.includes('@media')) {
        css += `\n
@media (max-width: 991px) {
    .admin-layout {
        display: block;
    }
    .admin-sidebar {
        position: fixed;
        left: -100%;
        top: 0;
        z-index: 1000;
        transition: 0.3s ease;
    }
    .admin-sidebar.active {
        left: 0;
    }
    .admin-main {
        width: 100%;
        padding-top: 60px; /* space for mobile topbar */
    }
    .admin-topbar {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        z-index: 999;
    }
    .dashboard-grid {
        grid-template-columns: repeat(2, 1fr);
    }
    /* Need hamburger for admin */
    .admin-hamburger {
        display: block !important;
        background: none;
        border: none;
        font-size: 24px;
        color: var(--text-main);
        cursor: pointer;
        margin-right: 15px;
    }
    .admin-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.5);
        z-index: 998;
        display: none;
    }
    .admin-overlay.active {
        display: block;
    }
}
@media (max-width: 576px) {
    .dashboard-grid {
        grid-template-columns: 1fr;
    }
}
`;
        fs.writeFileSync(adminCssPath, css);
    }
}

const adminTableCssPath = path.join(rootDir, 'admin', 'admin-table.css');
if (fs.existsSync(adminTableCssPath)) {
    let css = fs.readFileSync(adminTableCssPath, 'utf8');
    if (!css.includes('@media')) {
        css += `\n
@media (max-width: 991px) {
    .table-container {
        overflow-x: auto;
    }
    .admin-table {
        min-width: 800px;
    }
}
`;
        fs.writeFileSync(adminTableCssPath, css);
    }
}

// 16. Update admin HTMLs to include hamburger
const adminDir = path.join(rootDir, 'admin');
if (fs.existsSync(adminDir)) {
    const adminFiles = fs.readdirSync(adminDir).filter(f => f.endsWith('.html'));
    adminFiles.forEach(file => {
        let html = fs.readFileSync(path.join(adminDir, file), 'utf8');
        let modified = false;
        
        if (!html.includes('admin-hamburger')) {
            html = html.replace('<div class="topbar-search">', '<button class="admin-hamburger" style="display: none;" onclick="document.querySelector(\'.admin-sidebar\').classList.add(\'active\'); document.getElementById(\'admin-overlay\').classList.add(\'active\')"><i class="fa-solid fa-bars"></i></button>\n                <div class="topbar-search">');
            modified = true;
        }
        
        if (!html.includes('admin-overlay')) {
            html = html.replace('</body>', '<div class="admin-overlay" id="admin-overlay" onclick="document.querySelector(\'.admin-sidebar\').classList.remove(\'active\'); this.classList.remove(\'active\');"></div>\n</body>');
            modified = true;
        }
        
        if (modified) fs.writeFileSync(path.join(adminDir, file), html);
    });
}

console.log("Responsive CSS added successfully to all files.");
