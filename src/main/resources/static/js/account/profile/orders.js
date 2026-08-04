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

function handleReviewFileSelect(input) {
  const file = input.files && input.files[0];
  const nameSpan = document.getElementById('reviewFileName');
  const imgPreview = document.getElementById('reviewImagePreview');
  const videoPreview = document.getElementById('reviewVideoPreview');

  if (!file) {
    if (nameSpan) nameSpan.innerText = 'Chọn ảnh hoặc video...';
    if (imgPreview) { imgPreview.src = '/images/placeholder.png'; imgPreview.style.display = 'block'; }
    if (videoPreview) { videoPreview.pause(); videoPreview.style.display = 'none'; }
    return;
  }

  let name = file.name;
  if (name.length > 22) {
    const dotIdx = name.lastIndexOf('.');
    const ext = dotIdx !== -1 ? name.substring(dotIdx) : '';
    const base = dotIdx !== -1 ? name.substring(0, dotIdx) : name;
    name = base.substring(0, 15) + '...' + ext;
  }
  if (nameSpan) nameSpan.innerText = name;

  const url = URL.createObjectURL(file);
  if (file.type.startsWith('video/')) {
    if (imgPreview) imgPreview.style.display = 'none';
    if (videoPreview) {
      videoPreview.src = url;
      videoPreview.style.display = 'block';
    }
  } else {
    if (videoPreview) { videoPreview.pause(); videoPreview.style.display = 'none'; }
    if (imgPreview) {
      imgPreview.src = url;
      imgPreview.style.display = 'block';
    }
  }
}

function openReviewModal(productId, productName) {
  orderModalState.stars = 0;
  updateStarUI(0);
  document.getElementById('review-product-id').value = productId;
  document.getElementById('review-product-name').value = productName;
  document.getElementById('review-comment').value = '';
  const fileInput = document.getElementById('reviewMediaFile');
  if (fileInput) fileInput.value = '';
  handleReviewFileSelect(fileInput);
  document.getElementById('modal-review-product-title').textContent = window.t('profile-review-modal-product-title', 'Đánh giá sản phẩm: ') + productName;
  document.getElementById('order-modal-backdrop')?.classList.add('active');
}

function closeOrderModal() {
  document.getElementById('order-modal-backdrop')?.classList.remove('active');
}

function updateStarUI(starCount) {
  const starBtns = document.querySelectorAll('.review-stars .star-btn, .order-modal .review-stars button');
  starBtns.forEach((btn, index) => {
    btn.classList.toggle('active', index < starCount);
    btn.classList.remove('hovered');
  });
  const starDescs = [
    window.t('profile-review-star-select', 'Chọn số sao đánh giá'),
    '⭐ ' + window.t('profile-review-star-1', 'Rất Tệ'),
    '⭐⭐ ' + window.t('profile-review-star-2', 'Tệ'),
    '⭐⭐⭐ ' + window.t('profile-review-star-3', 'Bình Thường'),
    '⭐⭐⭐⭐ ' + window.t('profile-review-star-4', 'Tốt'),
    '⭐⭐⭐⭐⭐ ' + window.t('profile-review-star-5', 'Rất Tốt')
  ];
  const descEl = document.getElementById('star-desc');
  if (descEl) {
    descEl.textContent = starDescs[starCount] || window.t('profile-review-star-select', 'Chọn số sao đánh giá');
  }
}

function rate(star) {
  orderModalState.stars = star;
  updateStarUI(star);
}

function submitReview() {
  if (orderModalState.stars === 0) { toast('❗ Vui lòng chọn số sao.'); return; }
  const comment = document.getElementById('review-comment')?.value.trim() || '';
  const productId = document.getElementById('review-product-id')?.value || '';
  const productName = document.getElementById('review-product-name')?.value || '';
  const fileInput = document.getElementById('reviewMediaFile');
  const mediaFile = fileInput && fileInput.files && fileInput.files[0];

  if (!productId || orderModalState.stars < 1 || orderModalState.stars > 5) {
    toast('❗ Dữ liệu không hợp lệ.');
    return;
  }

  const formData = new FormData();
  formData.append('productId', productId);
  formData.append('rating', orderModalState.stars);
  formData.append('comment', comment);
  if (mediaFile) {
    formData.append('file', mediaFile);
  }

  fetch('/api/reviews', {
    method: 'POST',
    headers: {
      [csrfHeader]: csrfToken
    },
    body: formData
  })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        toast('✓ Đã lưu đánh giá ' + orderModalState.stars + ' sao cho ' + (productName || ''));
        closeOrderModal();
        setTimeout(() => window.location.reload(), 1000);
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
  const starBtns = document.querySelectorAll('.review-stars .star-btn, .order-modal .review-stars button');
  const starContainer = document.querySelector('.review-stars, .order-modal .review-stars');

  starBtns.forEach((btn, index) => {
    btn.addEventListener('mouseenter', () => {
      updateStarUI(index + 1);
    });
  });

  if (starContainer) {
    starContainer.addEventListener('mouseleave', () => {
      updateStarUI(orderModalState.stars);
    });
  }
});