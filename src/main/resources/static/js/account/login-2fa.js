/* ======================================================
   LUXURY PC - 2FA Verification Script (login-2fa.js)
   ====================================================== */

document.addEventListener('DOMContentLoaded', function () {
    // Check URL params for error
    const params = new URLSearchParams(window.location.search);
    if (params.has('error') && typeof window.showAlert === 'function') {
        window.showAlert('Mã OTP không chính xác hoặc đã hết hạn! Vui lòng kiểm tra lại.', false);
    }

    // OTP Input Navigation & Backspace Event Handling
    const otpIds = ['otp1', 'otp2', 'otp3', 'otp4', 'otp5', 'otp6'];
    const otpInputs = otpIds.map(id => document.getElementById(id));
    
    otpInputs.forEach((inp, idx) => {
        if (!inp) return;

        inp.addEventListener('input', function () {
            this.value = this.value.replace(/[^0-9]/g, '');
            if (this.value && idx < otpInputs.length - 1) {
                otpInputs[idx + 1]?.focus();
            }
            updateFinalOtp();
        });

        inp.addEventListener('keydown', function (e) {
            if (e.key === 'Backspace' && !this.value && idx > 0) {
                otpInputs[idx - 1]?.focus();
            }
            setTimeout(updateFinalOtp, 10);
        });
    });

    // Autofocus first input
    otpInputs[0]?.focus();

    // Form submit listener
    const form = document.getElementById('2fa-login-form');
    if (form) {
        form.addEventListener('submit', function (e) {
            updateFinalOtp();
            const finalVal = document.getElementById('final-otp-value')?.value || '';
            if (finalVal.length < 6) {
                e.preventDefault();
                toast('Vui lòng nhập đủ 6 chữ số OTP.');
            }
        });
    }

    // OTP Countdown Timer (5 Minutes = 300 seconds)
    let rem = 300;
    const lbl = document.getElementById('otp-timer');
    if (lbl) {
        const timerInt = setInterval(() => {
            const m = Math.floor(rem / 60).toString().padStart(2, '0');
            const s = (rem % 60).toString().padStart(2, '0');
            lbl.textContent = m + ':' + s;
            if (--rem < 0) {
                clearInterval(timerInt);
                lbl.textContent = 'Hết hạn';
                toast('Mã OTP đã hết hạn, vui lòng quay lại đăng nhập lại.');
            }
        }, 1000);
    }
});

function updateFinalOtp() {
    const val = ['otp1', 'otp2', 'otp3', 'otp4', 'otp5', 'otp6']
        .map(id => document.getElementById(id)?.value || '').join('');
    const finalInp = document.getElementById('final-otp-value');
    if (finalInp) finalInp.value = val;
}

function toast(msg) {
    if (typeof window.showAlert === 'function') {
        window.showAlert(msg);
        return;
    }
    const el = document.getElementById('toast');
    if (el) {
        el.textContent = msg;
        el.style.display = 'block';
        setTimeout(() => el.style.display = 'none', 3500);
    } else {
        alert(msg);
    }
}

function resend2faOtp() {
    const btn = document.getElementById('btn-resend-otp');
    if (btn) btn.disabled = true;
    toast('Đang gửi mã OTP mới đến email của bạn...');

    fetch('/auth/login-2fa/resend', { method: 'POST' })
        .then(r => r.text())
        .then(res => {
            toast(res || '✓ Đã gửi lại mã OTP thành công!');
        })
        .catch(e => {
            console.error('Resend 2FA error:', e);
            toast('⚠️ Có lỗi xảy ra, vui lòng thử lại.');
            if (btn) btn.disabled = false;
        });
}
