/* ======================================================
   LUXURY PC - Profile Orders Tab Script (orders.js)
   ====================================================== */

const orderModalState = { stars: 0 };

function toggleOrder(orderId) {
    const pane = document.getElementById(orderId);
    if (!pane) return;

    if (pane.classList.contains('active')) {
        pane.classList.remove('active');
    } else {
        document.querySelectorAll('.order-details-pane').forEach(el => el.classList.remove('active'));
        pane.classList.add('active');
    }
}

function cancelOrder(btn) {
    const orderId = btn.getAttribute('data-order-id');
    if (!orderId) return;

    showConfirm('Bạn có chắc chắn muốn hủy đơn hàng #' + orderId + ' không?').then(confirmed => {
        if (!confirmed) return;

        btn.disabled = true;
        btn.textContent = 'Đang xử lý...';

        fetch('/api/orders/' + orderId + '/cancel', {
            method: 'POST',
            headers: { [getCsrfHeader()]: getCsrfToken() }
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                toast('✓ Đã hủy đơn hàng thành công.');
                setTimeout(() => location.reload(), 800);
            } else {
                toast('⚠️ ' + (data.message || 'Không thể hủy đơn hàng.'));
                btn.disabled = false;
                btn.textContent = '⚠️ Hủy Đơn Hàng';
            }
        })
        .catch(err => {
            console.error('Cancel order error:', err);
            toast('⚠️ Lỗi kết nối khi hủy đơn hàng.');
            btn.disabled = false;
            btn.textContent = '⚠️ Hủy Đơn Hàng';
        });
    });
}

function openReviewModal(productId, productName) {
    document.getElementById('review-product-id').value = productId;
    document.getElementById('review-product-name').value = productName;
    document.getElementById('review-pname-display').textContent = productName;
    document.getElementById('review-comment').value = '';
    setStar(5);
    document.getElementById('review-modal-backdrop').classList.add('open');
}

function closeOrderModal() {
    document.getElementById('review-modal-backdrop').classList.remove('open');
}

function setStar(star) {
    orderModalState.stars = star;
    const starDescs = ['', '⭐ Rất Tệ', '⭐⭐ Tạm Được', '⭐⭐⭐ Bình Thường', '⭐⭐⭐⭐ Hài Lòng', '⭐⭐⭐⭐⭐ Rất Tốt'];
    document.querySelectorAll('.star-btn').forEach((btn, index) => {
        btn.classList.toggle('active', index < star);
    });
    const descEl = document.getElementById('star-desc');
    if (descEl) descEl.textContent = starDescs[star] || 'Chọn số sao đánh giá';
}

function submitReview() {
    if (orderModalState.stars === 0) { toast('❗ Vui lòng chọn số sao.'); return; }
    const comment = document.getElementById('review-comment')?.value.trim() || '';
    const productId = document.getElementById('review-product-id')?.value || '';
    const productName = document.getElementById('review-product-name')?.value || '';

    if (!productId || orderModalState.stars < 1 || orderModalState.stars > 5) {
        toast('❗ Dữ liệu không hợp lệ.');
        return;
    }

    fetch('/api/reviews', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            [getCsrfHeader()]: getCsrfToken()
        },
        body: JSON.stringify({
            productId: parseInt(productId),
            rating: orderModalState.stars,
            comment: comment
        })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            toast(`✓ Đã lưu đánh giá ${orderModalState.stars} sao cho ${productName}`);
            closeOrderModal();
        } else {
            toast('⚠️ ' + (data.message || 'Không thể lưu đánh giá.'));
        }
    })
    .catch(err => {
        console.error('Review error:', err);
        toast('⚠️ Không thể lưu đánh giá.');
    });
}
