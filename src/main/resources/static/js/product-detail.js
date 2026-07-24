/* Product Detail JavaScript */

function changeMainImage(src, element) {
    const mainImg = document.getElementById('main-image');
    if (mainImg) mainImg.src = src;
    document.querySelectorAll('.pd-thumbnails img').forEach(img => img.classList.remove('active'));
    if (element) element.classList.add('active');
}
window.changeMainImage = changeMainImage;

function changeQty(delta) {
    const input = document.getElementById('qty');
    if (!input) return;
    let val = parseInt(input.value, 10) + delta;
    const max = parseInt(input.getAttribute('max'), 10) || 99;
    if (isNaN(val) || val < 1) val = 1;
    if (val > max) val = max;
    input.value = val;
}
window.changeQty = changeQty;

function manualQtyChange(input) {
    if (!input) return;
    let val = parseInt(input.value, 10);
    const max = parseInt(input.getAttribute('max'), 10) || 99;
    if (isNaN(val) || val < 1) val = 1;
    if (val > max) val = max;
    input.value = val;
}
window.manualQtyChange = manualQtyChange;

function submitAddToCart() {
    const qtyInput = document.getElementById('qty');
    const qty = qtyInput ? (parseInt(qtyInput.value, 10) || 1) : 1;
    const formInput = document.querySelector('#addToCartForm input[name="id"]');
    if (!formInput) return;
    const productId = String(formInput.value);

    // Nếu sản phẩm đã có trong giỏ → chỉ hiện cảnh báo, không gọi API
    if (window.cartProductIds && window.cartProductIds.has(productId)) {
        if (typeof window.showToastWarning === 'function') {
            window.showToastWarning('⚠️ Sản phẩm này đã có trong giỏ hàng của bạn!');
        }
        return;
    }

    const formData = new FormData();
    formData.append('id', productId);
    formData.append('quantity', qty);

    fetch('/api/cart/add', { method: 'POST', body: formData })
        .then(res => {
            if (res.status === 401 || res.status === 403) {
                const redirect = window.location.pathname + window.location.search;
                window.location.href = '/auth/login?redirect=' + encodeURIComponent(redirect);
                return null;
            }
            return res.json();
        })
        .then(data => {
            if (!data) return;
            if (data.requireLogin) {
                const redirect = window.location.pathname + window.location.search;
                window.location.href = '/auth/login?redirect=' + encodeURIComponent(redirect);
                return;
            }
            if (data.success) {
                if (window.cartProductIds) window.cartProductIds.add(productId);
                if (typeof window.showToast === 'function') window.showToast('✅ ' + data.message);
                const cartCountEl = document.getElementById('cart-count');
                if (cartCountEl && data.cartCount !== undefined) {
                    cartCountEl.innerText = data.cartCount;
                }
            } else {
                if (typeof window.showToast === 'function') window.showToast('⚠️ ' + data.message);
            }
        })
        .catch(err => {
            console.error('Lỗi thêm vào giỏ hàng:', err);
            if (typeof window.showToast === 'function') window.showToast('⚠️ Lỗi kết nối, vui lòng thử lại.');
        });
}
window.submitAddToCart = submitAddToCart;

function submitBuyNow() {
    const form = document.getElementById('addToCartForm');
    const qtyInput = document.getElementById('qty');
    const formQty = document.getElementById('form-qty');
    if (form && qtyInput && formQty) {
        formQty.value = qtyInput.value;
        form.action = '/cart/add';
        form.submit();
    }
}
window.submitBuyNow = submitBuyNow;

function switchTab(btn) {
    if (!btn) return;
    const target = btn.getAttribute('data-tab');
    document.querySelectorAll('.pd-tab').forEach(b => {
        b.classList.remove('active');
        b.style.color = '#666';
        b.style.borderBottomColor = 'transparent';
    });
    btn.classList.add('active');
    btn.style.color = '#000';
    btn.style.borderBottomColor = '#000';

    document.querySelectorAll('.pd-tab-content').forEach(c => {
        c.style.display = 'none';
        c.classList.remove('active');
    });
    const targetEl = document.getElementById(target);
    if (targetEl) {
        targetEl.style.display = 'block';
        targetEl.classList.add('active');
    }
}
window.switchTab = switchTab;

async function submitReview() {
    const form = document.getElementById('reviewForm');
    if (!form || !form.reportValidity()) return;

    const formData = new FormData(form);
    try {
        const response = await fetch(form.action, {
            method: 'POST',
            body: formData
        });
        const result = await response.json();
        if (result.success) {
            if (typeof showToast === 'function') { showToast('Cảm ơn bạn đã đánh giá sản phẩm!'); } else { alert('Cảm ơn bạn đã đánh giá sản phẩm!'); }
            location.reload();
        } else {
            if (typeof showToast === 'function') { showToast('Lỗi: ' + result.message); } else { alert('Lỗi: ' + result.message); }
        }
    } catch (error) {
        if (typeof showToast === 'function') { showToast('Đã xảy ra lỗi khi gửi đánh giá.'); } else { alert('Đã xảy ra lỗi khi gửi đánh giá.'); }
        console.error(error);
    }
}
window.submitReview = submitReview;

document.addEventListener('DOMContentLoaded', () => {
    // Initialize tab click listeners as backup
    const tabs = document.querySelectorAll('.pd-tab');
    tabs.forEach(tab => {
        tab.addEventListener('click', function () {
            switchTab(this);
        });
    });

    // Image thumbnail click listeners
    const mainImg = document.getElementById('main-image');
    const thumbnails = document.querySelectorAll('.pd-thumbnails img');

    thumbnails.forEach(thumb => {
        thumb.addEventListener('click', function () {
            if (mainImg) changeMainImage(this.src, this);
        });
    });
});
