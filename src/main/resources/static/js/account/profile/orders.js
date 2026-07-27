/* Profile Orders Section Logic */

function toggleOrder(orderId) {
  const pane = document.getElementById(orderId);
  if (!pane) return;
  if (pane.classList.contains('active')) {
    pane.classList.remove('active');
  } else {
    pane.classList.add('active');
  }
}

window.toggleOrder = toggleOrder;
window.cancelOrder = cancelOrder;
window.openReviewModal = openReviewModal;
window.closeOrderModal = closeOrderModal;
window.rate = rate;
window.submitReview = submitReview;

function cancelOrder(btn) {
  const orderId = btn?.dataset?.orderId;
  if (!orderId) return;
  showConfirm('Bạn chắc chắn muốn hủy đơn hàng này? Thao tác này không thể hoàn tác.').then(confirmed => {
    if (!confirmed) return;

    btn.disabled = true;
    btn.textContent = 'Đang xử lý...';

    fetch('/api/profile/orders/' + orderId + '/cancel', {
      method: 'POST',
      headers: { [csrfHeader]: csrfToken }
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

let orderModalState = { currentOrder: null, stars: 0 };

function openReviewModal(productId, productName) {
  orderModalState.stars = 0;
  document.querySelectorAll('.order-modal .review-stars button').forEach(btn => {
    btn.classList.remove('active');
  });
  document.getElementById('star-desc').textContent = window.t('profile-review-star-select', 'Chọn số sao đánh giá');
  document.getElementById('review-product-id').value = productId;
  document.getElementById('review-product-name').value = productName;
  document.getElementById('review-comment').value = '';
  document.getElementById('modal-review-product-title').textContent = window.t('profile-review-modal-product-title', 'Đánh giá sản phẩm: ') + productName;
  document.getElementById('order-modal-backdrop')?.classList.add('active');
}

function closeOrderModal() {
  document.getElementById('order-modal-backdrop')?.classList.remove('active');
}

function rate(star) {
  orderModalState.stars = star;
  document.querySelectorAll('.order-modal .review-stars button').forEach((btn, index) => {
    btn.classList.toggle('active', index < star);
  });
  const starDescs = [
    window.t('profile-review-star-select', 'Chọn số sao đánh giá'),
    '⭐ ' + window.t('profile-review-star-1', 'Rất Tệ'),
    '⭐⭐ ' + window.t('profile-review-star-2', 'Tệ'),
    '⭐⭐⭐ ' + window.t('profile-review-star-3', 'Bình Thường'),
    '⭐⭐⭐⭐ ' + window.t('profile-review-star-4', 'Tốt'),
    '⭐⭐⭐⭐⭐ ' + window.t('profile-review-star-5', 'Rất Tốt')
  ];
  document.getElementById('star-desc').textContent = starDescs[star] || window.t('profile-review-star-select', 'Chọn số sao đánh giá');
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
      [csrfHeader]: csrfToken
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
        toast('✓ Đã lưu đánh giá ' + orderModalState.stars + ' sao cho ' + (productName || ''));
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

document.addEventListener('DOMContentLoaded', () => {
  const starBtns = document.querySelectorAll('.order-modal .review-stars button, .review-stars .star-btn');
  const starContainer = document.querySelector('.order-modal .review-stars, .review-stars');

  starBtns.forEach((btn, index) => {
    btn.addEventListener('mouseenter', () => {
      starBtns.forEach((b, i) => {
        b.classList.toggle('hovered', i <= index);
      });
    });
  });

  if (starContainer) {
    starContainer.addEventListener('mouseleave', () => {
      starBtns.forEach(b => b.classList.remove('hovered'));
    });
  }
});
