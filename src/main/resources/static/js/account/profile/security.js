/* Profile Security Section Logic */

function togglePasswordForm(force) {
  const panel = document.getElementById('password-change-panel');
  const button = document.getElementById('btn-toggle-password-form');
  if (!panel) return;
  const isHidden = panel.style.display === 'none' || panel.style.display === '';
  const shouldShow = typeof force === 'boolean' ? force : isHidden;
  panel.style.display = shouldShow ? 'block' : 'none';
  panel.classList.toggle('show', shouldShow);
  if (button) {
    button.setAttribute('aria-expanded', String(shouldShow));
    button.textContent = shouldShow ? 'Ẩn Form' : 'Đổi Mật Khẩu';
  }
  if (shouldShow) {
    panel.querySelector('input')?.focus();
  }
}

window.togglePasswordForm = togglePasswordForm;
window.open2FAModal = open2FAModal;
window.close2FAModal = close2FAModal;
window.verifyAndEnable2FA = verifyAndEnable2FA;
window.disable2FA = disable2FA;
window.openEmailDetailsModal = openEmailDetailsModal;
window.closeEmailDetailsModal = closeEmailDetailsModal;
window.openSessionsModal = openSessionsModal;
window.closeSessionsModal = closeSessionsModal;
window.revokeSession = revokeSession;
window.deleteAccount = deleteAccount;

function open2FAModal() {
  toast('✓ Đang gửi mã OTP đến email của bạn...');
  const otpInput = document.getElementById('2fa-otp-input');
  if (otpInput) otpInput.value = '';
  document.getElementById('2fa-modal-backdrop')?.classList.add('active');
  setTimeout(() => document.getElementById('2fa-otp-input')?.focus(), 200);

  fetch('/api/profile/2fa/send-otp', {
    method: 'POST',
    headers: { [csrfHeader]: csrfToken }
  })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        toast('✓ Mã OTP đã được gửi thành công!');
      } else {
        toast('⚠️ ' + (data.message || 'Lỗi khi gửi OTP.'));
      }
    })
    .catch(err => {
      console.error('2FA Send OTP error:', err);
      toast('⚠️ Lỗi kết nối khi gửi OTP.');
    });
}

function close2FAModal() {
  document.getElementById('2fa-modal-backdrop')?.classList.remove('active');
}

function verifyAndEnable2FA() {
  const otp = document.getElementById('2fa-otp-input')?.value.trim() || '';
  if (!otp || otp.length < 6) {
    toast('❗ Vui lòng nhập đủ mã OTP 6 số.');
    return;
  }

  fetch('/api/profile/2fa/enable?otp=' + encodeURIComponent(otp), {
    method: 'POST',
    headers: { [csrfHeader]: csrfToken }
  })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        toast('✓ Kích hoạt 2FA thành công.');
        close2FAModal();
        setTimeout(() => location.reload(), 800);
      } else {
        toast('⚠️ ' + (data.message || 'Xác thực OTP thất bại.'));
      }
    })
    .catch(err => {
      console.error('2FA Enable error:', err);
      toast('⚠️ Lỗi kết nối khi kích hoạt 2FA.');
    });
}

function disable2FA() {
  showConfirm('Bạn chắc chắn muốn tắt tính năng xác thực 2 lớp (2FA)? Bảo mật tài khoản của bạn sẽ bị giảm xuống.').then(confirmed => {
    if (!confirmed) return;

    fetch('/api/profile/2fa/disable', {
      method: 'POST',
      headers: { [csrfHeader]: csrfToken }
    })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          toast('✓ Đã tắt xác thực 2 lớp (2FA).');
          setTimeout(() => location.reload(), 800);
        } else {
          toast('⚠️ ' + (data.message || 'Không thể tắt 2FA lúc này.'));
        }
      })
      .catch(err => {
        console.error('2FA Disable error:', err);
        toast('⚠️ Lỗi kết nối khi tắt 2FA.');
      });
  });
}

function openEmailDetailsModal() {
  document.getElementById('email-details-modal-backdrop')?.classList.add('active');
}

function closeEmailDetailsModal() {
  document.getElementById('email-details-modal-backdrop')?.classList.remove('active');
}

function openSessionsModal() {
  document.getElementById('sessions-modal-backdrop')?.classList.add('active');
  loadSessions();
}

function closeSessionsModal() {
  document.getElementById('sessions-modal-backdrop')?.classList.remove('active');
}

function loadSessions() {
  const listContainer = document.getElementById('active-sessions-list');
  if (!listContainer) return;
  listContainer.innerHTML = '<div style="text-align:center; padding: 1.5rem; color: #64748b; font-size: 0.85rem;">Đang tải danh sách thiết bị...</div>';

  fetch('/api/sessions/active')
    .then(res => res.json())
    .then(data => {
      if (data.success && data.data) {
        if (data.data.length === 0) {
          listContainer.innerHTML = '<div style="text-align:center; padding: 1.5rem; color: #64748b; font-size: 0.85rem;">Không có phiên đăng nhập nào.</div>';
          return;
        }

        listContainer.innerHTML = data.data.map(us => {
          const uaLower = us.deviceInfo.toLowerCase();
          const deviceIcon = uaLower.includes("phone") || uaLower.includes("android") || uaLower.includes("ios") || uaLower.includes("iphone") || uaLower.includes("ipad") ? "📱" : "🖥️";
          const currentBadge = us.isCurrent
            ? '<span style="font-size: 0.7rem; color: #3b82f6; border: 1px solid #3b82f6; padding: 2px 6px; border-radius: 3px; font-weight: 500;">Thiết bị hiện tại</span>'
            : '<span style="font-size: 0.7rem; color: var(--green); border: 1px solid var(--green); padding: 2px 6px; border-radius: 3px; font-weight: 500;">Đang hoạt động</span>';

          const actionBtn = us.isCurrent
            ? ''
            : `<button class="btn-sec" style="border-color:var(--red); color:var(--red); font-size:0.75rem; padding:4px 10px; white-space:nowrap;" onclick="revokeSession('${us.sessionId}')">Đăng xuất</button>`;

          const loginDate = new Date(us.loginTime);
          const loginStr = loginDate.getDate().toString().padStart(2, '0') + '/' +
            (loginDate.getMonth() + 1).toString().padStart(2, '0') + '/' +
            loginDate.getFullYear() + ' ' +
            loginDate.getHours().toString().padStart(2, '0') + ':' +
            loginDate.getMinutes().toString().padStart(2, '0');

          return `
          <div style="display: flex; justify-content: space-between; align-items: center; padding: 12px; background: rgba(255,255,255,0.02); border: 1px solid rgba(201,168,76,0.15); border-radius: 6px; gap: 10px;">
            <div style="display: flex; align-items: center; gap: 12px;">
              <span style="font-size: 1.5rem;">${deviceIcon}</span>
              <div style="text-align: left;">
                <div style="font-weight: 600; font-size: 0.85rem; color: #000;">${us.deviceInfo}</div>
                <div style="font-size: 0.75rem; color: #64748b; margin-top: 2px;">IP: ${us.ipAddress} · ${us.location}</div>
                <div style="font-size: 0.72rem; color: #64748b; margin-top: 2px;">Đăng nhập lúc: ${loginStr}</div>
                <div style="margin-top: 6px; display: inline-block;">${currentBadge}</div>
              </div>
            </div>
            <div>
              ${actionBtn}
            </div>
          </div>
        `;
        }).join('');
      } else {
        listContainer.innerHTML = '<div style="text-align:center; padding: 1.5rem; color: var(--red); font-size: 0.85rem;">Không thể tải danh sách phiên.</div>';
      }
    })
    .catch(err => {
      console.error('Load sessions error:', err);
      listContainer.innerHTML = '<div style="text-align:center; padding: 1.5rem; color: var(--red); font-size: 0.85rem;">Lỗi kết nối máy chủ.</div>';
    });
}

function revokeSession(sessionId) {
  showConfirm('Bạn có chắc chắn muốn đăng xuất tài khoản khỏi thiết bị này từ xa?').then(confirmed => {
    if (!confirmed) return;

    fetch('/api/sessions/revoke?sessionId=' + encodeURIComponent(sessionId), {
      method: 'POST',
      headers: { [csrfHeader]: csrfToken }
    })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          toast('✓ Đăng xuất thiết bị thành công.');
          loadSessions();
        } else {
          toast('⚠️ ' + (data.message || 'Lỗi khi đăng xuất thiết bị.'));
        }
      })
      .catch(err => {
        console.error('Revoke session error:', err);
        toast('⚠️ Lỗi kết nối đến máy chủ.');
      });
  });
}

function deleteAccount() {
  showConfirm('⚠️ CẢNH BÁO: Bạn chắc chắn muốn xóa tài khoản này?\nThao tác này sẽ khóa tài khoản của bạn và đăng xuất khỏi hệ thống!').then(confirmed => {
    if (!confirmed) return;

    const btn = document.querySelector('.btn-danger');
    if (btn) {
      btn.disabled = true;
      btn.textContent = 'Đang xử lý...';
    }

    fetch('/api/profile/delete-account', {
      method: 'POST',
      headers: { [csrfHeader]: csrfToken }
    })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          toast('✓ ' + data.message);
          setTimeout(() => {
            window.location.href = '/auth/login?deleted=true';
          }, 1000);
        } else {
          toast('⚠️ ' + (data.message || 'Không thể xóa tài khoản lúc này.'));
          if (btn) {
            btn.disabled = false;
            btn.textContent = 'Xóa Tài Khoản';
          }
        }
      })
      .catch(err => {
        console.error('Delete account error:', err);
        toast('⚠️ Lỗi kết nối khi thực hiện xóa tài khoản.');
        if (btn) {
          btn.disabled = false;
          btn.textContent = 'Xóa Tài Khoản';
        }
      });
  });
}
