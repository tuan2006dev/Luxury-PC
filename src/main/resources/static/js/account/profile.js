/* Core Profile JS - Luxury PC */

const csrfToken = document.querySelector('meta[name="_csrf"]')?.content || document.querySelector('input[name="_csrf"]')?.value || '';
const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content || 'X-CSRF-TOKEN';

document.body.classList.add('custom-cursor-enabled');

/* TRANSLATION FALLBACK LOGIC */
window.t = window.t || function (key, fallback) { return fallback; };

/* UNIFIED TOAST SYSTEM FOR PROFILE */
let toastT;
function toast(msg) {
  if (!msg) return;
  let el = document.getElementById('toast');
  if (!el) {
    el = document.createElement('div');
    el.id = 'toast';
    el.className = 'toast';
    document.body.appendChild(el);
  }
  el.textContent = msg;
  el.classList.add('show', 'active');
  clearTimeout(toastT);
  toastT = setTimeout(() => {
    el.classList.remove('show', 'active');
  }, 3500);
}

window.toast = toast;
window.showToast = toast;
window.setTab = setTab;

const tabIds = ['info', 'orders', 'vouchers', 'wishlist', 'security', 'notifications', 'address'];
function setTab(id, event) {
  if (event) event.preventDefault();

  const cfg = window.PROFILE_CONFIG || {};
  if (cfg.forcePasswordLock) {
    if (id !== 'security') {
      toast("⚠️ Bạn bắt buộc phải đặt/đổi mật khẩu mới trước khi truy cập các mục khác!");
      id = 'security';
    }
  }

  tabIds.forEach(t => {
    document.getElementById('sec-' + t)?.classList.toggle('active', t === id);
    document.getElementById('pt-' + t)?.classList.toggle('active', t === id);
    document.querySelectorAll('.sb-item').forEach(el => {
      if (el.getAttribute('onclick') && el.getAttribute('onclick').includes("'" + t + "'")) {
        el.classList.toggle('active', t === id);
      } else if (t === id && el.getAttribute('onclick')?.includes(id)) {
        el.classList.add('active');
      }
    });
  });
  document.querySelectorAll('.sb-item').forEach(el => {
    el.classList.remove('active');
    if (el.getAttribute('onclick')?.includes("'" + id + "'")) el.classList.add('active');
  });
  try {
    const url = new URL(window.location);
    url.searchParams.set('tab', id);
    window.history.replaceState({}, '', url);
  } catch (e) {
    console.error('Error updating tab url:', e);
  }
  return false;
}

document.addEventListener('DOMContentLoaded', () => {
  // Flash messages config
  const cfg = window.PROFILE_CONFIG || {};
  if (cfg.profileMessage) toast(cfg.profileMessage);
  if (cfg.addressMessage) toast(cfg.addressMessage);
  if (cfg.securityMessage) toast(cfg.securityMessage);
  if (cfg.notificationMessage) toast(cfg.notificationMessage);

  if (cfg.forcePasswordLock) {
    setTab('security');
    if (typeof togglePasswordForm === 'function') {
      togglePasswordForm(true);
    }
    // Vô hiệu hóa toàn bộ menu sidebar trừ Bảo Mật
    document.querySelectorAll('.sb-item').forEach(el => {
      if (!el.getAttribute('onclick')?.includes('security')) {
        el.style.opacity = '0.35';
        el.style.cursor = 'not-allowed';
        el.style.pointerEvents = 'none';
        el.setAttribute('title', 'Bắt buộc thiết lập mật khẩu mới');
      }
    });
    // Chặn toàn bộ các đường dẫn header, footer, breadcrumb
    document.querySelectorAll('header a, .breadcrumb a, footer a').forEach(link => {
      if (link.getAttribute('href') && !link.getAttribute('href').includes('logout')) {
        link.addEventListener('click', (e) => {
          e.preventDefault();
          toast("⚠️ Bạn bắt buộc phải thiết lập mật khẩu mới trước khi rời khỏi trang này!");
        });
      }
    });
  } else {
    if (typeof loadAddresses === 'function') {
      loadAddresses();
    }

    const params = new URLSearchParams(window.location.search);
    const tabParam = params.get('tab');
    if (tabParam) {
      setTab(tabParam);
    }

    if (params.get('openEdit') === '1' && typeof toggleProfileEditForm === 'function') {
      toggleProfileEditForm(true);
    }

    if (params.get('openPasswordForm') === '1' && typeof togglePasswordForm === 'function') {
      togglePasswordForm(true);
    }
  }

  // Cursor hover animations
  const localCursor = document.getElementById('cursor');
  const localCursorFollower = document.getElementById('cursor-follower');
  if (localCursor && localCursorFollower) {
    document.querySelectorAll('.profile-tab, input, select, textarea, .sb-item, .wl-card').forEach(el => {
      el.addEventListener('mouseenter', () => {
        localCursor.style.transform = 'translate(-50%, -50%) scale(2)';
        localCursorFollower.style.width = '60px';
        localCursorFollower.style.height = '60px';
        localCursorFollower.style.backgroundColor = 'rgba(201, 168, 76, 0.1)';
      });
      el.addEventListener('mouseleave', () => {
        localCursor.style.transform = 'translate(-50%, -50%) scale(1)';
        localCursorFollower.style.width = '36px';
        localCursorFollower.style.height = '36px';
        localCursorFollower.style.backgroundColor = 'transparent';
      });
    });
  }
});