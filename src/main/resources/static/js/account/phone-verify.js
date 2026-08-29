/* ======================================================
   LUXURY PC - Phone Verification Module (Server-side OTP)
   OTP được sinh trên server và gửi qua email của tài khoản
   ====================================================== */

// Mở modal xác thực SĐT
window.openPhoneModal = function () {
    const modal = document.getElementById('phone-verify-modal-backdrop');
    if (modal) {
        // Reset lại trạng thái modal
        showPhoneStep(1);
        const otpInput = document.getElementById('pv-otp-input');
        if (otpInput) otpInput.value = '';
        modal.classList.add('active');
    }
};

// Đóng modal
window.closePhoneModal = function () {
    const modal = document.getElementById('phone-verify-modal-backdrop');
    if (modal) modal.classList.remove('active');
};

function showPhoneStep(step) {
    const step1 = document.getElementById('pv-step-1');
    const step2 = document.getElementById('pv-step-2');
    if (step1) step1.style.display = step === 1 ? 'block' : 'none';
    if (step2) step2.style.display = step === 2 ? 'block' : 'none';
}

// Gửi OTP về email
window.handleSendPhoneOtp = function () {
    const phoneInput = document.getElementById('pv-phone-input');
    const phone = phoneInput ? phoneInput.value.trim() : '';

    if (!phone || !/^0(3|5|7|8|9)[0-9]{8}$/.test(phone)) {
        if (typeof Swal !== 'undefined') {
            Swal.fire('Lỗi định dạng', 'Số điện thoại không đúng định dạng Việt Nam (VD: 0912345678)!', 'error');
        } else {
            alert('Số điện thoại không đúng định dạng!');
        }
        return;
    }

    const btn = document.getElementById('btn-send-phone-otp');
    if (btn) { btn.disabled = true; btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang gửi...'; }

    const formData = new URLSearchParams();
    formData.append('phone', phone);

    fetch('/api/profile/send-phone-otp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData.toString()
    })
        .then(res => res.json())
        .then(data => {
            if (btn) { btn.disabled = false; btn.innerHTML = '<i class="fa-solid fa-paper-plane"></i> Gửi Lại Mã OTP'; }
            if (data && data.success) {
                const maskedEmail = data.maskedEmail || 'email của bạn';
                // Cập nhật thông báo bước 2
                const emailHint = document.getElementById('pv-email-hint');
                if (emailHint) emailHint.textContent = maskedEmail;
                showPhoneStep(2);
            } else {
                const errMsg = (data && data.message) ? data.message : 'Không thể gửi mã OTP!';
                if (typeof Swal !== 'undefined') {
                    Swal.fire('Thất bại', errMsg, 'error');
                } else {
                    alert(errMsg);
                }
            }
        })
        .catch(() => {
            if (btn) { btn.disabled = false; btn.innerHTML = '<i class="fa-solid fa-paper-plane"></i> Gửi Mã OTP'; }
            if (typeof Swal !== 'undefined') {
                Swal.fire('Lỗi kết nối', 'Không thể kết nối tới máy chủ. Vui lòng thử lại!', 'error');
            }
        });
};

// Xác nhận OTP
window.handleConfirmPhoneOtp = function () {
    const phoneInput = document.getElementById('pv-phone-input');
    const otpInput = document.getElementById('pv-otp-input');
    const phone = phoneInput ? phoneInput.value.trim() : '';
    const otp = otpInput ? otpInput.value.trim() : '';

    if (!otp || otp.length < 6) {
        if (typeof Swal !== 'undefined') {
            Swal.fire('Lỗi OTP', 'Vui lòng nhập đủ 6 chữ số OTP!', 'warning');
        }
        return;
    }

    const btn = document.getElementById('btn-confirm-phone-otp');
    if (btn) { btn.disabled = true; btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang xác nhận...'; }

    const formData = new URLSearchParams();
    formData.append('phone', phone);
    formData.append('otp', otp);

    fetch('/api/profile/verify-phone', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData.toString()
    })
        .then(res => res.json())
        .then(data => {
            if (btn) { btn.disabled = false; btn.innerHTML = '<i class="fa-solid fa-check-double"></i> Xác Nhận Mã OTP'; }
            if (data && data.success) {
                closePhoneModal();
                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        icon: 'success',
                        title: 'Xác Thực Thành Công! 🎉',
                        text: data.message || 'Số điện thoại đã được xác thực và cập nhật thành công.',
                        confirmButtonColor: '#10b981'
                    }).then(() => {
                        window.location.reload();
                    });
                } else {
                    alert('Xác thực thành công!');
                    window.location.reload();
                }
            } else {
                const errMsg = (data && data.message) ? data.message : 'Mã OTP không đúng hoặc đã hết hạn!';
                if (typeof Swal !== 'undefined') {
                    Swal.fire('Lỗi xác thực', errMsg, 'error');
                } else {
                    alert(errMsg);
                }
            }
        })
        .catch(() => {
            if (btn) { btn.disabled = false; btn.innerHTML = '<i class="fa-solid fa-check-double"></i> Xác Nhận Mã OTP'; }
            if (typeof Swal !== 'undefined') {
                Swal.fire('Lỗi kết nối', 'Không thể kết nối tới máy chủ. Vui lòng thử lại!', 'error');
            }
        });
};
