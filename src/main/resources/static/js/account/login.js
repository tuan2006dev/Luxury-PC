/* ======================================================
   LUXURY PC - Login Page Script (login.js)
   ====================================================== */

document.addEventListener('DOMContentLoaded', function () {
    const params = new URLSearchParams(window.location.search);

    if (params.has('error')) {
        const errorVal = params.get('error') || '';
        const isDisabled = (errorVal === 'disabled' || errorVal === 'account_locked' || errorVal === 'locked');

        if (isDisabled) {
            if (typeof Swal !== 'undefined') {
                Swal.fire({
                    icon: 'error',
                    title: 'Tài Khoản Đã Bị Vô Hiệu Hóa 🔒',
                    text: 'Tài khoản của bạn đã bị khóa bởi Quản trị viên. Vui lòng liên hệ bộ phận hỗ trợ khách hàng để biết thêm chi tiết!',
                    confirmButtonText: 'Đã hiểu',
                    confirmButtonColor: '#ef4444'
                });
            } else if (typeof window.showAlert === 'function') {
                window.showAlert('Tài khoản của bạn đã bị KHÓA bởi Quản trị viên!', false);
            } else {
                alert('Tài khoản của bạn đã bị KHÓA bởi Quản trị viên!');
            }
        } else {
            if (typeof Swal !== 'undefined') {
                Swal.fire({
                    icon: 'warning',
                    title: 'Đăng Nhập Thất Bại',
                    text: 'Tên đăng nhập / Email hoặc mật khẩu không chính xác!',
                    confirmButtonText: 'Thử lại',
                    confirmButtonColor: '#0066CC'
                });
            } else if (typeof window.showAlert === 'function') {
                window.showAlert('Đăng nhập thất bại! Email hoặc mật khẩu không chính xác.', false);
            } else {
                alert('Đăng nhập thất bại!');
            }
        }
    } else if (params.has('passwordChanged')) {
        if (typeof Swal !== 'undefined') {
            Swal.fire({
                icon: 'success',
                title: 'Thành Công',
                text: 'Đổi mật khẩu thành công. Vui lòng đăng nhập lại.',
                confirmButtonText: 'OK',
                confirmButtonColor: '#10b981'
            });
        } else if (typeof window.showAlert === 'function') {
            window.showAlert('Đổi mật khẩu thành công. Vui lòng đăng nhập lại.', true);
        } else {
            alert('Đổi mật khẩu thành công. Vui lòng đăng nhập lại.');
        }
    }

    // Dynamic removal of error state when user types into any input field
    document.querySelectorAll('.reset-form input').forEach(input => {
        input.addEventListener('input', function () {
            if (this.value.trim() !== '') {
                this.classList.remove('is-invalid');
                const errSpan = this.closest('.form-group')?.querySelector('.error-message')
                    || this.closest('.floating-group')?.querySelector('.error-message');
                if (errSpan) {
                    errSpan.style.display = 'none';
                    errSpan.innerText = '';
                }
            }
        });
    });
});

function validateLogin(e) {
    document.querySelectorAll('.error-message').forEach(el => {
        el.style.display = 'none';
        el.innerText = '';
    });
    document.querySelectorAll('.reset-form input').forEach(el => {
        el.classList.remove('is-invalid');
    });

    const usernameInput = document.querySelector('input[name="username"]');
    const pwInput = document.querySelector('input[name="password"]');
    let isValid = true;

    if (!usernameInput || !usernameInput.value.trim()) {
        if (usernameInput) {
            usernameInput.classList.add('is-invalid');
            const errSpan = usernameInput.closest('.form-group')?.querySelector('.error-message');
            if (errSpan) {
                errSpan.innerText = 'Vui lòng nhập Email hoặc Tên đăng nhập!';
                errSpan.style.display = 'block';
            }
        }
        isValid = false;
    }

    if (!pwInput || !pwInput.value) {
        if (pwInput) {
            pwInput.classList.add('is-invalid');
            const errSpan = pwInput.closest('.form-group')?.querySelector('.error-message');
            if (errSpan) {
                errSpan.innerText = 'Vui lòng nhập Mật khẩu!';
                errSpan.style.display = 'block';
            }
        }
        isValid = false;
    }

    if (!isValid) {
        if (e && typeof e.preventDefault === 'function') e.preventDefault();
        return false;
    }
    return true;
}
