/**
 * Quản Lý Tài Khoản Khách Hàng - Realtime Live Field Validation & UI Handler
 * Viết theo phong cách đơn giản, tuyến tính (Fresher/Junior Style) giống login.js
 */

document.addEventListener('DOMContentLoaded', function () {
    initUserFormState();
    bindValidationEvents();
});

document.addEventListener('spa:load', function () {
    initUserFormState();
    bindValidationEvents();
});

// =====================================
// 1. Bắt sự kiện Blur & Input cho các ô nhập
// =====================================
function bindValidationEvents() {
    const form = document.querySelector('form[action$="/admin/account/save"]');
    if (!form) return;

    // Ngăn chặn submit nếu có lỗi validation
    form.onsubmit = function (e) {
        const isUsernameValid = checkUsername();
        const isEmailValid = checkEmail();
        const isPasswordValid = checkPassword();
        const isFullNameValid = checkFullName();
        const isPhoneValid = checkPhone();

        if (!isUsernameValid || !isEmailValid || !isPasswordValid || !isFullNameValid || !isPhoneValid) {
            e.preventDefault();
            const firstInvalid = form.querySelector('.is-invalid');
            if (firstInvalid) firstInvalid.focus();
            return false;
        }

        clearAllFormErrors();
    };

    const usernameInput = form.querySelector('input[name="username"]');
    const emailInput = form.querySelector('input[name="email"]');
    const passwordInput = form.querySelector('input[name="password"]');
    const fullNameInput = form.querySelector('input[name="fullName"]');
    const phoneInput = form.querySelector('input[name="phone"]');

    if (usernameInput) {
        usernameInput.addEventListener('blur', function () {
            if (this.value.trim() !== '') checkUsername();
        });
        usernameInput.addEventListener('input', function () {
            if (this.classList.contains('is-invalid')) checkUsername();
            else clearError(this);
        });
    }
    if (emailInput) {
        emailInput.addEventListener('blur', function () {
            if (this.value.trim() !== '') checkEmail();
        });
        emailInput.addEventListener('input', function () {
            if (this.classList.contains('is-invalid')) checkEmail();
            else clearError(this);
        });
    }
    if (passwordInput) {
        passwordInput.addEventListener('blur', function () {
            if (this.value.trim() !== '') checkPassword();
        });
        passwordInput.addEventListener('input', function () {
            if (this.classList.contains('is-invalid')) checkPassword();
            else clearError(this);
        });
    }
    if (fullNameInput) {
        fullNameInput.addEventListener('blur', function () {
            if (this.value.trim() !== '') checkFullName();
        });
        fullNameInput.addEventListener('input', function () {
            if (this.classList.contains('is-invalid')) checkFullName();
            else clearError(this);
        });
    }
    if (phoneInput) {
        phoneInput.addEventListener('blur', function () {
            if (this.value.trim() !== '') checkPhone();
        });
        phoneInput.addEventListener('input', function () {
            if (this.classList.contains('is-invalid')) checkPhone();
            else clearError(this);
        });
    }
}

// =====================================
// 2. Hàm hiển thị & Xóa lỗi từng ô
// =====================================
function showError(input, message) {
    if (!input) return;
    input.classList.add('is-invalid');
    const group = input.closest('.input-group');
    if (group) {
        let errorSpan = group.querySelector('.error-message');
        if (!errorSpan) {
            errorSpan = document.createElement('span');
            errorSpan.className = 'error-message';
            group.appendChild(errorSpan);
        }
        errorSpan.innerText = message;
        errorSpan.style.display = 'block';
    }
}

function clearError(input) {
    if (!input) return;
    input.classList.remove('is-invalid');
    const group = input.closest('.input-group');
    if (group) {
        group.querySelectorAll('.error-message, .error-text').forEach(err => err.remove());
    }
}

function clearAllFormErrors() {
    const form = document.getElementById('userForm');
    if (!form) return;
    form.querySelectorAll('.is-invalid').forEach(input => input.classList.remove('is-invalid'));
    form.querySelectorAll('.error-message, .error-text').forEach(span => span.remove());
}

// =====================================
// 3. Các hàm kiểm tra từng ô dữ liệu
// =====================================
function checkUsername() {
    const input = document.querySelector('input[name="username"]');
    if (!input) return true;
    const isEdit = input.readOnly || (document.querySelector('input[name="id"]') && document.querySelector('input[name="id"]').value);
    if (isEdit) {
        clearError(input);
        return true;
    }
    const val = input.value.trim();
    if (!val) {
        showError(input, 'Vui lòng nhập Username!');
        return false;
    }
    if (val.length < 3) {
        showError(input, 'Username phải chứa ít nhất 3 ký tự!');
        return false;
    }
    const usernameRegex = /^[a-zA-Z0-9_.@-]+$/;
    if (!usernameRegex.test(val)) {
        showError(input, 'Username chỉ chứa chữ cái, số, dấu gạch dưới, gạch ngang, chấm hoặc @!');
        return false;
    }
    clearError(input);
    return true;
}

function checkEmail() {
    const input = document.querySelector('input[name="email"]');
    if (!input) return true;
    const isEdit = input.readOnly || (document.querySelector('input[name="id"]') && document.querySelector('input[name="id"]').value);
    if (isEdit) {
        clearError(input);
        return true;
    }
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

function checkPassword() {
    const input = document.querySelector('input[name="password"]');
    const idInput = document.querySelector('input[name="id"]');
    if (!input) return true;
    const val = input.value.trim();
    const isNewUser = !idInput || !idInput.value;

    if (isNewUser) {
        if (!val) {
            showError(input, 'Vui lòng nhập Mật khẩu cho tài khoản mới!');
            return false;
        }
        if (val.length < 6) {
            showError(input, 'Mật khẩu phải chứa ít nhất 6 ký tự!');
            return false;
        }
    } else {
        if (val && val.length < 6) {
            showError(input, 'Mật khẩu mới phải chứa ít nhất 6 ký tự!');
            return false;
        }
    }
    clearError(input);
    return true;
}

function checkFullName() {
    const input = document.querySelector('input[name="fullName"]');
    if (!input) return true;
    const val = input.value.trim();
    if (!val) {
        showError(input, 'Vui lòng nhập Họ và tên!');
        return false;
    }
    if (val.length < 2) {
        showError(input, 'Họ và tên quá ngắn!');
        return false;
    }
    clearError(input);
    return true;
}

function checkPhone() {
    const input = document.querySelector('input[name="phone"]');
    if (!input) return true;
    const val = input.value.trim();
    if (!val) {
        showError(input, 'Vui lòng nhập Số điện thoại!');
        return false;
    }
    const cleanPhone = val.replace(/[\s.-]/g, '');
    const phoneRegex = /^(\+?84|0)[0-9]{8,10}$/;
    if (!phoneRegex.test(cleanPhone)) {
        showError(input, 'Số điện thoại không hợp lệ (ví dụ: 0912345678)!');
        return false;
    }
    clearError(input);
    return true;
}

// =====================================
// 4. Các hàm điều khiển UI Form & Bảng
// =====================================
function toggleForm() {
    const form = document.getElementById('userForm');
    const isActive = form.classList.toggle('active');
    updateToggleButtonState(isActive);
    clearUserForm();
}

function clearUserForm() {
    document.querySelector('input[name="id"]').value = '';
    document.querySelector('input[name="username"]').value = '';
    document.querySelector('input[name="email"]').value = '';
    document.querySelector('input[name="password"]').value = '';
    document.querySelector('input[name="fullName"]').value = '';
    document.querySelector('input[name="phone"]').value = '';
    document.querySelector('input[name="address"]').value = '';

    const genderSelect = document.querySelector('select[name="gender"]');
    if (genderSelect) genderSelect.value = 'true';

    const statusSelect = document.querySelector('select[name="status"]');
    if (statusSelect) statusSelect.value = 'true';

    clearAllFormErrors();
}

function editUser(btn) {
    const id = btn.getAttribute('data-id');
    const username = btn.getAttribute('data-username');
    const email = btn.getAttribute('data-email');
    const fullname = btn.getAttribute('data-fullname');
    const phone = btn.getAttribute('data-phone');
    const address = btn.getAttribute('data-address');
    const gender = btn.getAttribute('data-gender');
    const status = btn.getAttribute('data-status');

    document.querySelector('input[name="id"]').value = id || '';
    document.querySelector('input[name="username"]').value = username || '';
    document.querySelector('input[name="email"]').value = email || '';
    document.querySelector('input[name="password"]').value = '';
    document.querySelector('input[name="fullName"]').value = fullname || '';
    document.querySelector('input[name="phone"]').value = phone || '';
    document.querySelector('input[name="address"]').value = address || '';

    const genderSelect = document.querySelector('select[name="gender"]');
    if (genderSelect) genderSelect.value = gender === 'true' ? 'true' : 'false';

    const statusSelect = document.querySelector('select[name="status"]');
    if (statusSelect) statusSelect.value = status === 'true' ? 'true' : 'false';

    clearAllFormErrors();

    const form = document.getElementById('userForm');
    if (form && !form.classList.contains('active')) {
        form.classList.add('active');
        updateToggleButtonState(true);
    }

    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function updateToggleButtonState(isActive) {
    const btn = document.getElementById('toggleFormBtn');
    if (!btn) return;

    if (isActive) {
        btn.innerHTML = '<i class="fa-solid fa-xmark"></i> <span class="btn-text">Hủy</span>';
        btn.classList.remove('btn-gold');
        btn.classList.add('btn-danger');
        btn.style.padding = "0.6rem 1.2rem";
    } else {
        btn.innerHTML = '<i class="fa-solid fa-plus"></i> <span class="btn-text">Thêm Khách Hàng Mới</span>';
        btn.classList.remove('btn-danger');
        btn.classList.add('btn-gold');
    }
}

function filterUserTable() {
    const searchInput = document.getElementById('userSearchInput');
    const statusSelect = document.getElementById('userStatusFilter');
    if (!searchInput && !statusSelect) return;

    const filterText = searchInput ? searchInput.value.toLowerCase().trim() : '';
    const filterStatus = statusSelect ? statusSelect.value : '';

    const rows = document.querySelectorAll('.table-wrapper tbody tr');
    rows.forEach(row => {
        const text = row.innerText.toLowerCase();
        const badge = row.querySelector('.badge');
        const isActive = badge && badge.classList.contains('active-badge');

        let matchesSearch = !filterText || text.includes(filterText);
        let matchesStatus = true;

        if (filterStatus === 'active') {
            matchesStatus = isActive;
        } else if (filterStatus === 'inactive') {
            matchesStatus = !isActive;
        }

        if (matchesSearch && matchesStatus) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

function initUserFormState() {
    const form = document.getElementById('userForm');
    if (form && form.classList.contains('active')) {
        updateToggleButtonState(true);
    }
}
