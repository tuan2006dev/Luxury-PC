/**
 * Custom Luxury Confirm Popup Integration
 * Luxury PC — Nơi công nghệ gặp gỡ sự xa xỉ
 */
(function() {
    // 1. Tự động chèn CSS stylesheet vào head nếu chưa có
    if (!document.getElementById('confirm-popup-style')) {
        const link = document.createElement('link');
        link.id = 'confirm-popup-style';
        link.rel = 'stylesheet';
        link.href = '/css/confirm-popup.css';
        document.head.appendChild(link);
    }

    // 2. Chèn cấu trúc HTML của popup vào body sau khi DOM sẵn sàng
    function injectHTML() {
        if (document.getElementById('confirm-overlay')) return;

        const overlay = document.createElement('div');
        overlay.id = 'confirm-overlay';
        overlay.className = 'confirm-overlay';
        overlay.style.display = 'none'; /* Ẩn mặc định để tránh chớp unstyled html khi chưa tải xong CSS */
        overlay.innerHTML = `
            <div class="confirm-box">
                <div class="confirm-icon">⚠️</div>
                <div class="confirm-msg" id="confirm-msg">Bạn có chắc chắn muốn thực hiện thao tác này?</div>
                <div class="confirm-buttons">
                    <button type="button" class="confirm-btn confirm-btn-no" id="confirm-btn-no">Hủy</button>
                    <button type="button" class="confirm-btn confirm-btn-yes" id="confirm-btn-yes">Xác nhận</button>
                </div>
            </div>
        `;
        document.body.appendChild(overlay);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', injectHTML);
    } else {
        injectHTML();
    }

    // 3. Hàm hiển thị popup trả về Promise
    window.showConfirm = function(message) {
        return new Promise((resolve) => {
            // Đảm bảo HTML đã được inject
            injectHTML();

            const overlay = document.getElementById('confirm-overlay');
            const msgEl = document.getElementById('confirm-msg');
            const yesBtn = document.getElementById('confirm-btn-yes');
            const noBtn = document.getElementById('confirm-btn-no');

            if (!overlay || !msgEl || !yesBtn || !noBtn) {
                // Fallback nếu có lỗi xảy ra
                resolve(window.confirm(message));
                return;
            }

            msgEl.textContent = message;
            overlay.style.display = 'flex';
            overlay.offsetHeight; /* Trigger reflow */
            overlay.classList.add('show');
            yesBtn.focus(); // Focus vào nút xác nhận mặc định

            // Cursor hover is handled globally by cursor.js for buttons

            // Hàm đóng và dọn dẹp
            function closeConfirm(result) {
                overlay.classList.remove('show');
                yesBtn.removeEventListener('click', onYes);
                noBtn.removeEventListener('click', onNo);
                document.removeEventListener('keydown', onKeyDown);
                overlay.removeEventListener('click', onOverlayClick);
                
                // Trả cursor về trạng thái bình thường và gỡ bỏ event hover

                // Ẩn hẳn display: none sau khi kết thúc transition (250ms)
                setTimeout(() => {
                    if (!overlay.classList.contains('show')) {
                        overlay.style.display = 'none';
                    }
                }, 250);

                resolve(result);
            }

            function onYes() { closeConfirm(true); }
            function onNo() { closeConfirm(false); }

            function onKeyDown(e) {
                if (e.key === 'Escape') {
                    e.preventDefault();
                    closeConfirm(false);
                } else if (e.key === 'Enter') {
                    e.preventDefault();
                    closeConfirm(true);
                }
            }

            function onOverlayClick(e) {
                if (e.target === overlay) {
                    closeConfirm(false);
                }
            }

    // Gắn sự kiện
            yesBtn.addEventListener('click', onYes);
            noBtn.addEventListener('click', onNo);
            document.addEventListener('keydown', onKeyDown);
            overlay.addEventListener('click', onOverlayClick);
        });
    };

    // Hàm hiển thị Alert popup
    window.showAlert = function(message, isSuccess = true) {
        return new Promise((resolve) => {
            injectHTML();

            const overlay = document.getElementById('confirm-overlay');
            const msgEl = document.getElementById('confirm-msg');
            const yesBtn = document.getElementById('confirm-btn-yes');
            const noBtn = document.getElementById('confirm-btn-no');

            if (!overlay || !msgEl || !yesBtn || !noBtn) {
                alert(message);
                resolve();
                return;
            }

            msgEl.innerHTML = message;
            
            // Tùy chỉnh icon
            const iconEl = overlay.querySelector('.confirm-icon');
            if (iconEl) {
                if (isSuccess) {
                    iconEl.textContent = '✅';
                    iconEl.style.color = '#10b981';
                } else {
                    iconEl.textContent = '❌';
                    iconEl.style.color = '#ef4444';
                }
            }

            noBtn.style.display = 'none'; // Ẩn nút hủy
            yesBtn.textContent = 'Đóng';
            yesBtn.style.background = isSuccess ? '#10b981' : '#000';
            yesBtn.style.color = '#fff';

            overlay.style.display = 'flex';
            overlay.offsetHeight; 
            overlay.classList.add('show');
            yesBtn.focus();

            function closeAlert() {
                overlay.classList.remove('show');
                yesBtn.removeEventListener('click', onYes);
                document.removeEventListener('keydown', onKeyDown);
                overlay.removeEventListener('click', onOverlayClick);
                
                setTimeout(() => {
                    if (!overlay.classList.contains('show')) {
                        overlay.style.display = 'none';
                        // Khôi phục style cũ để dùng cho confirm
                        noBtn.style.display = '';
                        yesBtn.textContent = 'Xác nhận';
                        yesBtn.style.background = '';
                        yesBtn.style.color = '';
                        if (iconEl) {
                            iconEl.textContent = '⚠️';
                            iconEl.style.color = '';
                        }
                    }
                }, 250);

                resolve();
            }

            function onYes() { closeAlert(); }
            function onKeyDown(e) {
                if (e.key === 'Escape' || e.key === 'Enter') {
                    e.preventDefault();
                    closeAlert();
                }
            }
            function onOverlayClick(e) {
                if (e.target === overlay) closeAlert();
            }

            yesBtn.addEventListener('click', onYes);
            document.addEventListener('keydown', onKeyDown);
            overlay.addEventListener('click', onOverlayClick);
        });
    };

    // 4. Đánh chặn (Intercept) toàn cục các thuộc tính inline onclick="return confirm('...')" và onsubmit="return confirm('...')"
    // Sử dụng capture phase (tham số thứ 3 là true) để bắt sự kiện trước khi inline attribute thực thi.
    
    // Đánh chặn Click
    document.addEventListener('click', function(e) {
        const target = e.target.closest('a[onclick*="confirm"], button[onclick*="confirm"], input[onclick*="confirm"]');
        if (target) {
            const onclickAttr = target.getAttribute('onclick');
            if (onclickAttr && onclickAttr.includes('confirm(')) {
                // Chặn hành vi mặc định và ngăn không cho inline click chạy ngay lập tức
                e.preventDefault();
                e.stopImmediatePropagation();

                // Lấy nội dung câu hỏi confirm
                const match = onclickAttr.match(/confirm\(['"](.*?)['"]\)/);
                const msg = match ? match[1].replace(/\\n/g, '\n') : 'Bạn có chắc chắn muốn thực hiện thao tác này?';

                window.showConfirm(msg).then(confirmed => {
                    if (confirmed) {
                        // Tạm thời gỡ bỏ onclick để tránh lặp vô hạn
                        target.removeAttribute('onclick');

                        // Nếu là thẻ liên kết có href, chuyển hướng
                        if (target.tagName === 'A' && target.href && !target.href.startsWith('javascript:')) {
                            window.location.href = target.href;
                        } else {
                            // Click lại để chạy các xử lý khác
                            target.click();
                        }

                        // Khôi phục lại attribute onclick sau đó
                        setTimeout(() => {
                            target.setAttribute('onclick', onclickAttr);
                        }, 500);
                    }
                });
            }
        }
    }, true);

    // Đánh chặn Form Submit
    document.addEventListener('submit', function(e) {
        const form = e.target;
        const onsubmitAttr = form.getAttribute('onsubmit');
        if (onsubmitAttr && onsubmitAttr.includes('confirm(')) {
            // Chặn submit form mặc định
            e.preventDefault();
            e.stopImmediatePropagation();

            // Lấy nội dung câu hỏi confirm
            const match = onsubmitAttr.match(/confirm\(['"](.*?)['"]\)/);
            const msg = match ? match[1].replace(/\\n/g, '\n') : 'Bạn có chắc chắn muốn thực hiện thao tác này?';

            window.showConfirm(msg).then(confirmed => {
                if (confirmed) {
                    // Tạm thời gỡ bỏ onsubmit để submit trực tiếp không bị chặn
                    form.removeAttribute('onsubmit');
                    form.submit();

                    // Khôi phục lại attribute onsubmit sau đó
                    setTimeout(() => {
                        form.setAttribute('onsubmit', onsubmitAttr);
                    }, 500);
                }
            });
        }
    }, true);
})();
