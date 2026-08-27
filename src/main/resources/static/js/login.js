document.addEventListener('DOMContentLoaded', function () {
    const params = new URLSearchParams(window.location.search);

    // 1. Lấy các phần tử Input trên trang
    const firstNameInput = document.querySelector('input[name="firstName"]');
    const lastNameInput = document.querySelector('input[name="lastName"]');
    const emailInput = document.querySelector('input[name="email"]');
    const phoneInput = document.querySelector('input[name="phone"]');
    const pwInput = document.getElementById('reg-pw');
    const pwConfirmInput = document.getElementById('reg-pw-confirm');
    const otpInput = document.querySelector('input[name="otp"]');

    // 2. Phục hồi dữ liệu đã nhập từ sessionStorage khi load lại trang
    if (firstNameInput && !firstNameInput.value && sessionStorage.getItem('reg_firstName')) {
        firstNameInput.value = sessionStorage.getItem('reg_firstName');
    }
    if (lastNameInput && !lastNameInput.value && sessionStorage.getItem('reg_lastName')) {
        lastNameInput.value = sessionStorage.getItem('reg_lastName');
    }
    if (emailInput && !emailInput.value && sessionStorage.getItem('reg_email')) {
        emailInput.value = sessionStorage.getItem('reg_email');
    }
    if (phoneInput && !phoneInput.value && sessionStorage.getItem('reg_phone')) {
        phoneInput.value = sessionStorage.getItem('reg_phone');
    }

    // 3. Hiển thị lỗi từ Backend (URL Query Params) nếu có
    if (params.has('exist')) {
        showError(emailInput, 'Email này đã được đăng ký trong hệ thống!');
    } else if (params.has('invalidEmail')) {
        showError(emailInput, 'Định dạng email không hợp lệ!');
    } else if (params.has('phoneExist')) {
        showError(phoneInput, 'Số điện thoại này đã được đăng ký cho tài khoản khác!');
    } else if (params.has('mismatch')) {
        showError(pwConfirmInput, 'Mật khẩu xác nhận không khớp!');
    } else if (params.has('invalidOtp')) {
        showError(otpInput, 'Mã OTP không chính xác hoặc đã hết hạn!');
    } else if (params.has('error') && typeof window.showAlert === 'function') {
        window.showAlert('Đã xảy ra lỗi hệ thống. Vui lòng thử lại!', false);
    }

    // 4. Bắt sự kiện nhập xong (blur) để validate ngay lập tức
    if (firstNameInput) {
        firstNameInput.addEventListener('blur', function () { checkFirstName(); });
        firstNameInput.addEventListener('input', function () { clearError(this); });
    }
    if (lastNameInput) {
        lastNameInput.addEventListener('blur', function () { checkLastName(); });
        lastNameInput.addEventListener('input', function () { clearError(this); });
    }
    if (emailInput) {
        emailInput.addEventListener('blur', function () { checkEmail(); });
        emailInput.addEventListener('input', function () { clearError(this); });
    }
    if (phoneInput) {
        phoneInput.addEventListener('blur', function () { checkPhone(); });
        phoneInput.addEventListener('input', function () { clearError(this); });
    }
    if (pwInput) {
        pwInput.addEventListener('blur', function () { checkPassword(); });
        pwInput.addEventListener('input', function () { clearError(this); });
    }
    if (pwConfirmInput) {
        pwConfirmInput.addEventListener('blur', function () { checkConfirmPassword(); });
        pwConfirmInput.addEventListener('input', function () { clearError(this); });
    }
    if (otpInput) {
        otpInput.addEventListener('blur', function () { checkOtp(); });
        otpInput.addEventListener('input', function () { clearError(this); });
    }
});

// Hàm hiển thị lỗi dưới ô input
function showError(input, message) {
    if (!input) return;
    input.classList.add('is-invalid');
    const group = input.closest('.form-group') || input.closest('.floating-group');
    if (group) {
        const errorSpan = group.querySelector('.error-message');
        if (errorSpan) {
            errorSpan.innerText = message;
            errorSpan.style.display = 'block';
        }
    }
}

// Hàm xóa lỗi khi người dùng gõ
function clearError(input) {
    if (!input) return;
    input.classList.remove('is-invalid');
    const group = input.closest('.form-group') || input.closest('.floating-group');
    if (group) {
        const errorSpan = group.querySelector('.error-message');
        if (errorSpan) {
            errorSpan.innerText = '';
            errorSpan.style.display = 'none';
        }
    }
}

// Các hàm kiểm tra từng ô đơn giản
function checkFirstName() {
    const input = document.querySelector('input[name="firstName"]');
    if (!input || !input.value.trim()) {
        showError(input, 'Vui lòng nhập Họ!');
        return false;
    }
    clearError(input);
    return true;
}

function checkLastName() {
    const input = document.querySelector('input[name="lastName"]');
    if (!input || !input.value.trim()) {
        showError(input, 'Vui lòng nhập Tên!');
        return false;
    }
    clearError(input);
    return true;
}

function checkEmail() {
    const input = document.querySelector('input[name="email"]');
    if (!input) return false;
    const val = input.value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!val) {
        showError(input, 'Vui lòng nhập Email!');
        return false;
    }
    if (!emailRegex.test(val)) {
        showError(input, 'Email không đúng định dạng (ví dụ: example@gmail.com)!');
        return false;
    }
    clearError(input);
    return true;
}

function checkPhone() {
    const input = document.querySelector('input[name="phone"]');
    if (!input) return false;
    const val = input.value.trim();
    const phoneRegex = /^(\+?84|0)[35789][0-9]{8,9}$/;
    if (!val) {
        showError(input, 'Vui lòng nhập Số điện thoại!');
        return false;
    }
    if (!phoneRegex.test(val)) {
        showError(input, 'Số điện thoại không hợp lệ (ví dụ: 0912345678)!');
        return false;
    }
    clearError(input);
    return true;
}

function checkPassword() {
    const input = document.getElementById('reg-pw');
    if (!input) return false;
    if (!input.value) {
        showError(input, 'Vui lòng nhập Mật khẩu!');
        return false;
    }
    if (input.value.length < 6) {
        showError(input, 'Mật khẩu phải có ít nhất 6 ký tự!');
        return false;
    }
    clearError(input);
    return true;
}

function checkConfirmPassword() {
    const pwInput = document.getElementById('reg-pw');
    const input = document.getElementById('reg-pw-confirm');
    if (!input) return false;
    if (!input.value) {
        showError(input, 'Vui lòng nhập lại Mật khẩu!');
        return false;
    }
    if (pwInput && input.value !== pwInput.value) {
        showError(input, 'Mật khẩu nhập lại không khớp!');
        return false;
    }
    clearError(input);
    return true;
}

function checkOtp() {
    const input = document.querySelector('input[name="otp"]');
    if (!input) return false;
    const val = input.value.trim();
    if (!val) {
        showError(input, 'Vui lòng nhập mã xác nhận (OTP)!');
        return false;
    }
    if (!/^\d{6}$/.test(val)) {
        showError(input, 'Mã OTP phải gồm đúng 6 chữ số!');
        return false;
    }
    clearError(input);
    return true;
}

// Gửi mã OTP
function sendOTP() {
    const emailInput = document.querySelector('input[name="email"]');
    if (!checkEmail()) {
        if (emailInput) emailInput.focus();
        return;
    }

    const btn = document.querySelector('.btn-otp');
    if (btn) {
        btn.innerText = 'ĐANG GỬI...';
        btn.disabled = true;
    }

    const formData = new URLSearchParams();
    formData.append('email', emailInput.value.trim());

    fetch('/api/send-otp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData
    })
        .then(res => res.text())
        .then(data => {
            if (data === 'success') {
                if (typeof window.showAlert === 'function') {
                    window.showAlert({
                        message: 'Đã gửi mã xác nhận (OTP)',
                        subMessage: 'Vui lòng kiểm tra email của bạn.',
                        isSuccess: true
                    });
                }
                let timeLeft = 60;
                if (btn) btn.innerText = `CHỜ ${timeLeft}S`;
                const timer = setInterval(() => {
                    timeLeft--;
                    if (timeLeft <= 0) {
                        clearInterval(timer);
                        if (btn) { btn.innerText = 'GỬI LẠI MÃ'; btn.disabled = false; }
                    } else {
                        if (btn) btn.innerText = `CHỜ ${timeLeft}S`;
                    }
                }, 1000);
            } else if (data === 'error_exist') {
                showError(emailInput, 'Email này đã được đăng ký tài khoản!');
                if (btn) { btn.innerText = 'GỬI MÃ'; btn.disabled = false; }
            } else {
                if (typeof window.showAlert === 'function') window.showAlert('Không thể gửi OTP. Vui lòng thử lại sau.', false);
                if (btn) { btn.innerText = 'GỬI MÃ'; btn.disabled = false; }
            }
        })
        .catch(err => {
            console.error(err);
            if (typeof window.showAlert === 'function') window.showAlert('Đã xảy ra lỗi mạng. Vui lòng thử lại.', false);
            if (btn) { btn.innerText = 'GỬI MÃ'; btn.disabled = false; }
        });
}

// Xử lý khi nhấn nút Đăng ký
function submitRegister(e) {
    e.preventDefault();

    const firstNameInput = document.querySelector('input[name="firstName"]');
    const lastNameInput = document.querySelector('input[name="lastName"]');
    const emailInput = document.querySelector('input[name="email"]');
    const phoneInput = document.querySelector('input[name="phone"]');

    // Lưu lại dữ liệu đã nhập
    if (firstNameInput) sessionStorage.setItem('reg_firstName', firstNameInput.value);
    if (lastNameInput) sessionStorage.setItem('reg_lastName', lastNameInput.value);
    if (emailInput) sessionStorage.setItem('reg_email', emailInput.value);
    if (phoneInput) sessionStorage.setItem('reg_phone', phoneInput.value);

    // Kiểm tra tất cả các ô
    const isFirstNameValid = checkFirstName();
    const isLastNameValid = checkLastName();
    const isEmailValid = checkEmail();
    const isPhoneValid = checkPhone();
    const isPasswordValid = checkPassword();
    const isConfirmPasswordValid = checkConfirmPassword();
    const isOtpValid = checkOtp();

    const termsCheckbox = document.querySelector('.terms input[type="checkbox"]');
    const isValid = isFirstNameValid && isLastNameValid && isEmailValid && isPhoneValid && isPasswordValid && isConfirmPasswordValid && isOtpValid;

    if (isValid && termsCheckbox && !termsCheckbox.checked) {
        if (typeof window.showAlert === 'function') {
            window.showAlert('Bạn cần đồng ý với Điều khoản dịch vụ và Chính sách bảo mật!', false);
        }
        return false;
    }

    if (!isValid) return false; 

    document.getElementById('form-register').submit();
}