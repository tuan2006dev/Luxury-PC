/* Profile Info Section Logic */

function toggleProfileEditForm(force) {
  const panel = document.getElementById('profile-edit-panel');
  const button = document.getElementById('profile-edit-toggle');
  if (!panel || !button) return;
  const isHidden = panel.style.display === 'none' || panel.style.display === '';
  const shouldShow = typeof force === 'boolean' ? force : isHidden;
  panel.style.display = shouldShow ? 'block' : 'none';
  panel.classList.toggle('show', shouldShow);
  button.setAttribute('aria-expanded', String(shouldShow));
  button.textContent = shouldShow ? 'Ẩn Form' : 'Chỉnh Sửa';
  if (shouldShow) {
    panel.querySelector('input, select, textarea')?.focus();
  }
}

document.addEventListener('DOMContentLoaded', () => {
  // Email OTP logic
  const emailInput = document.getElementById('profile-email');
  const otpGroup = document.getElementById('email-otp-group');
  const otpInput = document.getElementById('profile-email-otp');
  const btnSendOtp = document.getElementById('btn-send-email-otp');

  if (emailInput && otpGroup && btnSendOtp) {
    const originalEmail = emailInput.getAttribute('data-original-email');

    emailInput.addEventListener('input', () => {
      const currentEmail = emailInput.value.trim();
      if (currentEmail !== originalEmail && currentEmail !== '') {
        otpGroup.style.display = 'block';
        otpInput.setAttribute('required', 'required');
      } else {
        otpGroup.style.display = 'none';
        otpInput.removeAttribute('required');
        otpInput.value = '';
      }
    });

    let cooldown = 0;
    let cooldownInterval;

    btnSendOtp.addEventListener('click', () => {
      if (cooldown > 0) return;
      const email = emailInput.value.trim();
      if (!email) {
        toast('Vui lòng nhập email mới trước!');
        return;
      }

      toast('✓ Đang gửi mã OTP đến ' + email + '...');

      cooldown = 60;
      btnSendOtp.disabled = true;
      btnSendOtp.textContent = 'Gửi lại (' + cooldown + 's)';
      cooldownInterval = setInterval(() => {
        cooldown--;
        if (cooldown <= 0) {
          clearInterval(cooldownInterval);
          btnSendOtp.disabled = false;
          btnSendOtp.textContent = 'Gửi OTP';
        } else {
          btnSendOtp.textContent = 'Gửi lại (' + cooldown + 's)';
        }
      }, 1000);

      fetch('/profile/email-otp/send?email=' + encodeURIComponent(email), {
        method: 'POST',
        headers: { [csrfHeader]: csrfToken }
      })
        .then(res => res.json())
        .then(data => {
          if (data.status === 'success') {
            toast('✓ Mã OTP đã được gửi đến email mới!');
          } else {
            toast('⚠️ ' + data.message);
            clearInterval(cooldownInterval);
            cooldown = 0;
            btnSendOtp.disabled = false;
            btnSendOtp.textContent = 'Gửi OTP';
          }
        })
        .catch(err => {
          console.error('Send OTP error:', err);
          toast('⚠️ Lỗi kết nối khi gửi OTP.');
          clearInterval(cooldownInterval);
          cooldown = 0;
          btnSendOtp.disabled = false;
          btnSendOtp.textContent = 'Gửi OTP';
        });
    });
  }

  // Avatar Upload Logic
  const avatarFileInput = document.getElementById('avatar-file-input');
  if (avatarFileInput) {
    avatarFileInput.addEventListener('change', () => {
      const file = avatarFileInput.files[0];
      if (!file) return;

      if (file.size > 2 * 1024 * 1024) {
        toast('⚠️ Kích thước file tối đa là 2MB!');
        return;
      }
      if (!file.type.startsWith('image/')) {
        toast('⚠️ Chỉ chấp nhận file ảnh!');
        return;
      }

      const formData = new FormData();
      formData.append('file', file);

      fetch('/api/profile/avatar', {
        method: 'POST',
        headers: { [csrfHeader]: csrfToken },
        body: formData
      })
        .then(res => res.json())
        .then(data => {
          if (data.success) {
            toast('✓ Đã cập nhật ảnh đại diện.');
            const imgView = document.getElementById('avatar-img-view');
            const initialView = document.getElementById('avatar-initial-view');
            const innerWrap = document.querySelector('.avatar-inner');

            if (initialView) initialView.style.display = 'none';

            if (imgView) {
              imgView.src = data.avatarPath;
              imgView.style.display = 'block';
            } else if (innerWrap) {
              const newImg = document.createElement('img');
              newImg.id = 'avatar-img-view';
              newImg.src = data.avatarPath;
              newImg.alt = 'Avatar';
              newImg.style.cssText = 'width:100%; height:100%; border-radius:50%; object-fit:cover;';
              innerWrap.appendChild(newImg);
            }
          } else {
            toast('⚠️ ' + (data.message || 'Lỗi khi tải ảnh lên.'));
          }
        })
        .catch(err => {
          console.error('Avatar upload error:', err);
          toast('⚠️ Lỗi kết nối khi tải ảnh.');
        });
    });
  }
});
