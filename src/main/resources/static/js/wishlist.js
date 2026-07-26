/**
 * Wishlist toggle — dùng chung trang chủ, /products, /product/{id}
 */
(function () {
  function notify(msg) {
    if (typeof showToast === 'function') {
      showToast(msg);
    } else if (typeof toast === 'function') {
      toast(msg);
    }
  }

  function isWished(btn) {
    return btn.dataset.wished === '1' || btn.classList.contains('is-active');
  }

  function setWished(btn, wished) {
    btn.dataset.wished = wished ? '1' : '0';
    btn.classList.toggle('is-active', wished);
    btn.setAttribute('aria-pressed', String(wished));

    if (btn.classList.contains('btn-outline-lg')) {
      btn.textContent = wished ? '♥ Đã Lưu Yêu Thích' : '♡ Thêm Vào Yêu Thích';
      return;
    }

    btn.textContent = wished ? '♥' : '♡';
    if (btn.classList.contains('wishlist-chip')) {
      btn.style.color = '';
    } else {
      btn.style.color = wished ? '#c9a84c' : '';
    }
  }

  async function toggleWishlist(btn) {
    const productId = btn.dataset.productId;
    if (!productId) {
      return;
    }

    try {
      const res = await fetch('/api/wishlist/toggle/' + encodeURIComponent(productId), {
        method: 'POST',
        headers: { Accept: 'application/json' },
      });
      const data = await res.json().catch(() => ({}));

      if (res.status === 401 || data.loginRequired) {
        const redirect = window.location.pathname + window.location.search;
        window.location.href = '/auth/login?redirect=' + encodeURIComponent(redirect);
        return;
      }

      if (data.success) {
        setWished(btn, !!data.wished);
        notify(data.message || (data.wished ? '♥ Đã thêm vào danh sách yêu thích' : 'Đã xóa khỏi danh sách yêu thích'));
        document.querySelectorAll('[data-product-id="' + productId + '"].product-wishlist, [data-product-id="' + productId + '"].wishlist-chip')
          .forEach(other => {
            if (other !== btn) {
              setWished(other, !!data.wished);
            }
          });
      } else {
        notify(data.message || 'Không thể cập nhật danh sách yêu thích.');
      }
    } catch (err) {
      notify('Không thể kết nối máy chủ. Vui lòng thử lại.');
    }
  }

  function bindWishlistButton(btn) {
    if (!btn || btn.dataset.wishlistBound === '1') {
      return;
    }
    btn.dataset.wishlistBound = '1';
    btn.type = btn.type || 'button';
    setWished(btn, isWished(btn));
    btn.addEventListener('click', function (e) {
      e.preventDefault();
      e.stopPropagation();
      toggleWishlist(btn);
    });
  }

  function initWishlistButtons(root) {
    const scope = root || document;
    scope.querySelectorAll('.product-wishlist[data-product-id], .wishlist-chip[data-product-id]').forEach(bindWishlistButton);
  }

  document.addEventListener('DOMContentLoaded', function () {
    initWishlistButtons();
  });

  window.initWishlistButtons = initWishlistButtons;
})();
