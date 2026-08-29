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
window.validateChangePassword = validateChangePassword;
window.open2FAModal = open2FAModal;
window.close2FAModal = close2FAModal;
window.verifyAndEnable2FA = verifyAndEnable2FA;
window.disable2FA = disable2FA;
window.openEmailDetailsModal = openEmailDetailsModal;
window.closeEmailDetailsModal = closeEmailDetailsModal;
window.openSessionsModal = openSessionsModal;
window.closeSessionsModal = closeSessionsModal;
window.revokeSession = revokeSession;
window.revokeAllOtherSessions = revokeAllOtherSessions;
window.deleteAccount = deleteAccount;

let isCurrentPwValid = true;

function verifyCurrentPasswordApi(val, input) {
  if (!val) return;
  const group = input.closest('.form-group');
  const errSpan = group ? group.querySelector('.error-message') : null;
  const formData = new URLSearchParams();
  formData.append('currentPassword', val);

  fetch('/api/profile/check-current-password', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: formData.toString()
  })
    .then(res => res.json())
    .then(data => {
      if (data && data.valid === false) {
        isCurrentPwValid = false;
        input.classList.add('is-invalid');
        if (errSpan) {
          errSpan.innerText = 'Mật khẩu hiện tại không chính xác!';
          errSpan.style.display = 'block';
        }
      } else {
        isCurrentPwValid = true;
        input.classList.remove('is-invalid');
        if (errSpan) {
          errSpan.style.display = 'none';
          errSpan.innerText = '';
        }
      }
    })
    .catch(err => console.error(err));
}

document.addEventListener('DOMContentLoaded', function () {
  const pwPanel = document.getElementById('password-change-panel');
  if (pwPanel) {
    const currentPwInput = pwPanel.querySelector('input[name="currentPassword"]');
    if (currentPwInput) {
      let checkTimer;
      currentPwInput.addEventListener('input', function () {
        clearTimeout(checkTimer);
        const val = this.value.trim();
        if (!val) return;
        checkTimer = setTimeout(() => {
          verifyCurrentPasswordApi(val, currentPwInput);
        }, 400);
      });

      currentPwInput.addEventListener('blur', function () {
        const val = this.value.trim();
        if (val) {
          verifyCurrentPasswordApi(val, currentPwInput);
        }
      });
    }

    // Dynamic removal of error state when user types into any input field
    pwPanel.querySelectorAll('input').forEach(input => {
      input.addEventListener('input', function () {
        if (this.value.trim() !== '') {
          if (this.name !== 'currentPassword' || isCurrentPwValid) {
            this.classList.remove('is-invalid');
            const group = this.closest('.form-group');
            if (group) {
              const errSpan = group.querySelector('.error-message');
              if (errSpan) {
                errSpan.style.display = 'none';
                errSpan.innerText = '';
              }
            }
          }
        }
      });
    });

    // Form submit listener to block POST when invalid
    pwPanel.addEventListener('submit', function (e) {
      if (!validateChangePassword(e)) {
        e.preventDefault();
        e.stopPropagation();
        return false;
      }
    });
  }
});

function validateChangePassword(e) {
  const form = document.getElementById('password-change-panel');
  if (!form) return true;

  let isValid = true;

  // Reset previous error states
  form.querySelectorAll('.form-input').forEach(input => input.classList.remove('is-invalid'));
  form.querySelectorAll('.error-message').forEach(span => {
    span.style.display = 'none';
    span.innerText = '';
  });

  const currentPwInput = form.querySelector('input[name="currentPassword"]');
  const newPwInput = form.querySelector('input[name="newPassword"]');
  const confirmPwInput = form.querySelector('input[name="confirmPassword"]');

  const showFieldError = (input, msg) => {
    if (!input) return;
    input.classList.add('is-invalid');
    const group = input.closest('.form-group');
    if (group) {
      const errSpan = group.querySelector('.error-message');
      if (errSpan) {
        errSpan.innerText = msg;
        errSpan.style.display = 'block';
      }
    }
    isValid = false;
  };

  // 1. Mật khẩu hiện tại
  if (!currentPwInput || !currentPwInput.value) {
    showFieldError(currentPwInput, 'Vui lòng nhập mật khẩu hiện tại!');
  } else if (!isCurrentPwValid) {
    showFieldError(currentPwInput, 'Mật khẩu hiện tại không chính xác!');
  }

  // 2. Mật khẩu mới
  if (!newPwInput || !newPwInput.value) {
    showFieldError(newPwInput, 'Vui lòng nhập mật khẩu mới!');
  } else if (newPwInput.value.length < 6) {
    showFieldError(newPwInput, 'Mật khẩu mới phải có ít nhất 6 ký tự!');
  } else if (currentPwInput && currentPwInput.value && newPwInput.value === currentPwInput.value) {
    showFieldError(newPwInput, 'Mật khẩu mới không được trùng với mật khẩu hiện tại!');
  }

  // 3. Xác nhận mật khẩu mới
  if (!confirmPwInput || !confirmPwInput.value) {
    showFieldError(confirmPwInput, 'Vui lòng nhập lại mật khẩu mới!');
  } else if (newPwInput && newPwInput.value && confirmPwInput.value !== newPwInput.value) {
    showFieldError(confirmPwInput, 'Mật khẩu xác nhận không khớp với mật khẩu mới!');
  }

  if (!isValid) {
    if (e && typeof e.preventDefault === 'function') {
      e.preventDefault();
      e.stopPropagation();
    }
    return false;
  }

  return true;
}

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
  const listContainer = document.getElementById('sessions-list-container') || document.getElementById('active-sessions-list');
  if (!listContainer) return;
  listContainer.innerHTML = '<div style="text-align:center; padding: 2rem; color: #64748b; font-size: 0.85rem;"><i class="fa-solid fa-spinner fa-spin" style="margin-right: 6px;"></i> Đang tải danh sách thiết bị...</div>';

  fetch('/api/sessions/active')
    .then(res => res.json())
    .then(data => {
      if (!data.success || !data.data) {
        listContainer.innerHTML = '<div style="text-align:center; padding: 1.5rem; color: var(--red, #ef4444); font-size: 0.85rem;">Không thể tải danh sách phiên.</div>';
        return;
      }

      let currentSession = null;
      let otherSessions = [];

      if (data.data.currentSession) {
        currentSession = data.data.currentSession;
        otherSessions = data.data.otherSessions || [];
      } else if (Array.isArray(data.data)) {
        currentSession = data.data.find(s => s.isCurrent);
        otherSessions = data.data.filter(s => !s.isCurrent);
      } else if (data.data.allSessions) {
        currentSession = data.data.allSessions.find(s => s.isCurrent);
        otherSessions = data.data.allSessions.filter(s => !s.isCurrent);
      }

      const formatTime = (ts) => {
        if (!ts) return 'Không rõ';
        const d = new Date(ts);
        return d.getDate().toString().padStart(2, '0') + '/' +
          (d.getMonth() + 1).toString().padStart(2, '0') + '/' +
          d.getFullYear() + ' ' +
          d.getHours().toString().padStart(2, '0') + ':' +
          d.getMinutes().toString().padStart(2, '0');
      };

      const getDeviceIcon = (info) => {
        const ua = (info || '').toLowerCase();
        if (ua.includes('phone') || ua.includes('android') || ua.includes('ios') || ua.includes('iphone')) return '📱';
        if (ua.includes('ipad') || ua.includes('tablet')) return '💻';
        return '🖥️';
      };

      // 1. Current Session Section
      let currentSectionHtml = '';
      if (currentSession) {
        const curIcon = getDeviceIcon(currentSession.deviceInfo);
        const curTime = formatTime(currentSession.loginTime);
        currentSectionHtml = `
          <div>
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
              <span style="font-size: 0.78rem; font-weight: 700; color: #0284c7; text-transform: uppercase; letter-spacing: 0.5px;">Thiết bị hiện tại</span>
              <span style="font-size: 0.68rem; background: #e0f2fe; color: #0284c7; border: 1px solid #bae6fd; padding: 1px 6px; border-radius: 10px; font-weight: 600;">Phiên này</span>
            </div>
            <div style="padding: 14px 16px; background: #f0f9ff; border: 1.5px solid #38bdf8; border-radius: 8px; display: flex; align-items: center; gap: 14px; box-shadow: 0 1px 3px rgba(14, 165, 233, 0.08);">
              <span style="font-size: 1.8rem; line-height: 1;">${curIcon}</span>
              <div style="flex-grow: 1; min-width: 0;">
                <div style="font-weight: 700; font-size: 0.92rem; color: #0f172a; display: flex; align-items: center; gap: 6px;">
                  <span>${currentSession.deviceInfo}</span>
                </div>
                <div style="font-size: 0.78rem; color: #475569; margin-top: 3px; display: flex; flex-wrap: wrap; gap: 4px 10px;">
                  <span><i class="fa-solid fa-network-wired" style="font-size: 0.7rem; color: #64748b;"></i> IP: <strong>${currentSession.ipAddress}</strong></span>
                  <span><i class="fa-solid fa-location-dot" style="font-size: 0.7rem; color: #64748b;"></i> ${currentSession.location || 'Vietnam'}</span>
                </div>
                <div style="font-size: 0.72rem; color: #64748b; margin-top: 4px;">
                  <i class="fa-regular fa-clock" style="font-size: 0.7rem;"></i> Đăng nhập lúc: ${curTime}
                </div>
              </div>
              <div style="flex-shrink: 0;">
                <span style="font-size: 0.72rem; color: #0369a1; background: #e0f2fe; border: 1px solid #7dd3fc; padding: 4px 8px; border-radius: 4px; font-weight: 600; display: inline-flex; align-items: center; gap: 5px;">
                  <span style="width: 7px; height: 7px; border-radius: 50%; background: #0284c7; display: inline-block;"></span> Thiết bị này
                </span>
              </div>
            </div>
          </div>
        `;
      }

      // 2. Other Sessions Section
      let otherSessionsHtml = '';
      const otherCount = otherSessions.length;
      const revokeAllBtn = otherCount > 0
        ? `<button type="button" class="btn-sec" style="border: 1px solid #f87171; color: #ef4444; background: #fff; font-size: 0.75rem; padding: 4px 10px; border-radius: 4px; font-weight: 600; cursor: pointer; transition: all 0.2s;" onmouseover="this.style.background='#fef2f2'" onmouseout="this.style.background='#fff'" onclick="revokeAllOtherSessions()">Đăng xuất tất cả (${otherCount})</button>`
        : '';

      let otherListContent = '';
      if (otherCount === 0) {
        otherListContent = `
          <div style="text-align: center; padding: 22px 16px; background: #f8fafc; border-radius: 8px; border: 1px dashed #cbd5e1;">
            <i class="fa-solid fa-shield-halved" style="font-size: 26px; color: #10b981; margin-bottom: 6px; display: block;"></i>
            <div style="font-weight: 600; color: #334155; font-size: 0.85rem;">Không có thiết bị nào khác</div>
            <div style="font-size: 0.75rem; color: #64748b; margin-top: 3px;">Tài khoản của bạn hiện chỉ đang đăng nhập duy nhất trên thiết bị này.</div>
          </div>
        `;
      } else {
        otherListContent = otherSessions.map(us => {
          const icon = getDeviceIcon(us.deviceInfo);
          const timeStr = formatTime(us.loginTime);
          return `
            <div style="display: flex; justify-content: space-between; align-items: center; padding: 12px 14px; background: #fff; border: 1px solid #e2e8f0; border-radius: 8px; gap: 12px; transition: all 0.2s;" onmouseover="this.style.borderColor='#cbd5e1'" onmouseout="this.style.borderColor='#e2e8f0'">
              <div style="display: flex; align-items: center; gap: 12px; min-width: 0;">
                <span style="font-size: 1.6rem; line-height: 1;">${icon}</span>
                <div style="text-align: left; min-width: 0;">
                  <div style="font-weight: 600; font-size: 0.88rem; color: #1e293b; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${us.deviceInfo}</div>
                  <div style="font-size: 0.76rem; color: #64748b; margin-top: 2px;">IP: ${us.ipAddress} · ${us.location || 'Vietnam'}</div>
                  <div style="font-size: 0.72rem; color: #94a3b8; margin-top: 2px;">Đăng nhập lúc: ${timeStr}</div>
                  <div style="margin-top: 5px;">
                    <span style="font-size: 0.68rem; color: #059669; background: #ecfdf5; border: 1px solid #a7f3d0; padding: 2px 6px; border-radius: 3px; font-weight: 500; display: inline-flex; align-items: center; gap: 4px;">
                      <span style="width: 5px; height: 5px; border-radius: 50%; background: #10b981; display: inline-block;"></span> Đang hoạt động
                    </span>
                  </div>
                </div>
              </div>
              <div style="flex-shrink: 0;">
                <button class="btn-sec" style="border: 1px solid #ef4444; color: #ef4444; background: #fff; font-size: 0.75rem; font-weight: 600; padding: 6px 12px; border-radius: 6px; white-space: nowrap; cursor: pointer; transition: all 0.2s;" onmouseover="this.style.background='#fef2f2'" onmouseout="this.style.background='#fff'" onclick="revokeSession('${us.sessionId}')">
                  ĐĂNG XUẤT
                </button>
              </div>
            </div>
          `;
        }).join('');
      }

      otherSessionsHtml = `
        <div>
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
            <div style="font-size: 0.78rem; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.5px; display: flex; align-items: center; gap: 6px;">
              <span>Thiết bị khác đang hoạt động</span>
              <span style="font-size: 0.68rem; background: #e2e8f0; color: #475569; padding: 1px 6px; border-radius: 10px; font-weight: 600;">${otherCount}</span>
            </div>
            ${revokeAllBtn}
          </div>
          <div style="display: flex; flex-direction: column; gap: 10px;">
            ${otherListContent}
          </div>
        </div>
      `;

      listContainer.innerHTML = `
        <div style="display: flex; flex-direction: column; gap: 1.25rem;">
          ${currentSectionHtml}
          ${otherSessionsHtml}
        </div>
      `;
    })
    .catch(err => {
      console.error('Load sessions error:', err);
      listContainer.innerHTML = '<div style="text-align:center; padding: 1.5rem; color: var(--red, #ef4444); font-size: 0.85rem;">Lỗi kết nối máy chủ khi tải danh sách phiên.</div>';
    });
}

function revokeSession(sessionId) {
  showConfirm('Bạn có chắc chắn muốn đăng xuất tài khoản khỏi thiết bị này từ xa?').then(confirmed => {
    if (!confirmed) return;

    const token = typeof csrfToken !== 'undefined' ? csrfToken : (document.querySelector('meta[name="_csrf"]')?.content || '');
    const header = typeof csrfHeader !== 'undefined' ? csrfHeader : (document.querySelector('meta[name="_csrf_header"]')?.content || 'X-CSRF-TOKEN');
    const headers = token ? { [header]: token } : {};

    fetch('/api/sessions/revoke?sessionId=' + encodeURIComponent(sessionId), {
      method: 'POST',
      headers: headers
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

function revokeAllOtherSessions() {
  showConfirm('Bạn có chắc chắn muốn đăng xuất tài khoản khỏi TẤT CẢ các thiết bị khác từ xa?').then(confirmed => {
    if (!confirmed) return;

    const token = typeof csrfToken !== 'undefined' ? csrfToken : (document.querySelector('meta[name="_csrf"]')?.content || '');
    const header = typeof csrfHeader !== 'undefined' ? csrfHeader : (document.querySelector('meta[name="_csrf_header"]')?.content || 'X-CSRF-TOKEN');
    const headers = token ? { [header]: token } : {};

    fetch('/api/sessions/revoke-all', {
      method: 'POST',
      headers: headers
    })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          toast('✓ ' + (data.data?.message || 'Đã đăng xuất các thiết bị khác thành công.'));
          loadSessions();
        } else {
          toast('⚠️ ' + (data.message || 'Lỗi khi đăng xuất các thiết bị khác.'));
        }
      })
      .catch(err => {
        console.error('Revoke all sessions error:', err);
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
