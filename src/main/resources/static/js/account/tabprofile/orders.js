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

function cancelOrder(btn, idParam) {
    let orderId = idParam;
    if (!orderId && btn) {
        orderId = (btn.getAttribute ? btn.getAttribute('data-order-id') : null) || btn.dataset?.orderId;
    }
    if (!orderId && window.event && window.event.target) {
        const targetBtn = window.event.target.closest('[data-order-id]');
        if (targetBtn) orderId = targetBtn.getAttribute('data-order-id');
    }

    if (!orderId) {
        console.error("cancelOrder error: Missing order ID");
        return;
    }

    const doCancel = function () {
        if (btn) {
            btn.disabled = true;
            btn.textContent = 'Đang xử lý...';
        }

        const headers = { 'Content-Type': 'application/json' };
        const token = document.querySelector('meta[name="_csrf"]')?.content || document.querySelector('input[name="_csrf"]')?.value;
        const headerName = document.querySelector('meta[name="_csrf_header"]')?.content || 'X-CSRF-TOKEN';
        if (token) headers[headerName] = token;

        fetch('/api/profile/orders/' + orderId + '/cancel', {
            method: 'POST',
            headers: headers
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    if (typeof toast === 'function') toast(data.message || '✓ Đã hủy đơn hàng thành công.');
                    setTimeout(() => {
                        if (typeof reloadProfileTab === 'function') {
                            reloadProfileTab('orders');
                        } else {
                            window.location.href = '/profile?tab=orders';
                        }
                    }, 800);
                } else {
                    if (typeof toast === 'function') toast('⚠️ ' + (data.message || 'Không thể hủy đơn hàng.'));
                    if (btn) {
                        btn.disabled = false;
                        btn.textContent = '⚠️ Hủy Đơn Hàng';
                    }
                }
            })
            .catch(err => {
                console.error('Cancel order error:', err);
                if (typeof toast === 'function') toast('⚠️ Lỗi kết nối khi hủy đơn hàng.');
                if (btn) {
                    btn.disabled = false;
                    btn.textContent = '⚠️ Hủy Đơn Hàng';
                }
            });
    };

    if (typeof Swal !== 'undefined') {
        Swal.fire({
            title: 'Xác Nhận Hủy Đơn',
            text: 'Bạn có chắc chắn muốn hủy đơn hàng #' + orderId + ' không? Voucher đã dùng (nếu có) sẽ được hoàn lại vào ví của bạn.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ef4444',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Hủy đơn hàng',
            cancelButtonText: 'Bỏ qua'
        }).then(result => {
            if (result.isConfirmed) doCancel();
        });
    } else if (typeof window.showConfirm === 'function') {
        window.showConfirm('Bạn có chắc chắn muốn hủy đơn hàng #' + orderId + ' không?').then(confirmed => {
            if (confirmed) doCancel();
        });
    } else {
        if (confirm('Bạn có chắc chắn muốn hủy đơn hàng #' + orderId + ' không?')) {
            doCancel();
        }
    }
}

function openReviewModal(productId, productName) {
    const pIdInput = document.getElementById('review-product-id');
    const pNameInput = document.getElementById('review-product-name');
    const pNameDisplay = document.getElementById('review-pname-display');
    const commentInput = document.getElementById('review-comment');
    const backdrop = document.getElementById('review-modal-backdrop');

    if (pIdInput) pIdInput.value = productId;
    if (pNameInput) pNameInput.value = productName;
    if (pNameDisplay) pNameDisplay.textContent = productName;
    if (commentInput) commentInput.value = '';
    setStar(5);
    if (backdrop) backdrop.classList.add('open');
}

function closeReviewModal() {
    const backdrop = document.getElementById('review-modal-backdrop');
    if (backdrop) backdrop.classList.remove('open');
}

function setStar(num) {
    orderModalState.stars = num;
    document.querySelectorAll('.star-rating-select i').forEach(star => {
        const starNum = parseInt(star.getAttribute('data-star'));
        if (starNum <= num) {
            star.classList.remove('fa-regular');
            star.classList.add('fa-solid', 'active');
        } else {
            star.classList.remove('fa-solid', 'active');
            star.classList.add('fa-regular');
        }
    });
}

function submitReview() {
    const productId = document.getElementById('review-product-id')?.value;
    const comment = document.getElementById('review-comment')?.value;
    const rating = orderModalState.stars || 5;

    if (!productId) return;
    if (!comment || !comment.trim()) {
        if (typeof toast === 'function') toast('Vui lòng nhập nội dung đánh giá.');
        return;
    }

    const headers = { 'Content-Type': 'application/json' };
    const token = document.querySelector('meta[name="_csrf"]')?.content || document.querySelector('input[name="_csrf"]')?.value;
    const headerName = document.querySelector('meta[name="_csrf_header"]')?.content || 'X-CSRF-TOKEN';
    if (token) headers[headerName] = token;

    fetch('/api/reviews', {
        method: 'POST',
        headers: headers,
        body: JSON.stringify({
            productId: parseInt(productId),
            rating: rating,
            comment: comment.trim()
        })
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                if (typeof toast === 'function') toast('✓ Đã gửi đánh giá thành công!');
                closeReviewModal();
            } else {
                if (typeof toast === 'function') toast(data.message || 'Lỗi gửi đánh giá.');
            }
        })
        .catch(err => {
            console.error('Review submit error:', err);
            if (typeof toast === 'function') toast('Đã xảy ra lỗi mạng.');
        });
}
