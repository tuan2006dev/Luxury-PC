document.addEventListener('DOMContentLoaded', async () => {
    try {
        // Load Header
        const headerRes = await fetch('../../components/header/header.html');
        if (headerRes.ok) {
            const headerHtml = await headerRes.text();
            document.getElementById('header-container').innerHTML = headerHtml;
        }

        // Load Footer
        const footerRes = await fetch('../../components/footer/footer.html');
        if (footerRes.ok) {
            const footerHtml = await footerRes.text();
            document.getElementById('footer-container').innerHTML = footerHtml;
        }
    
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
    } catch (e) {
        console.error('Không thể load Header/Footer. Nếu bạn mở file trực tiếp (file://), trình duyệt sẽ chặn tải file HTML khác vì lý do bảo mật CORS. Hãy dùng Live Server để xem trước.', e);
    }
});
