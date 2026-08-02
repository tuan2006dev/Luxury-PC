/**
 * Quản Lý Nhân Viên (Staff) - Realtime Live Field Validation & UI Handler
 * Viết theo phong cách đơn giản, tuyến tính (Fresher/Junior Style) giống account.js và login.js
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
    const form = document.querySelector('form[action$="/admin/employees/save"]');
    if (!form) return;

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
    };

    const usernameInput = document.getElementById('empUsername');
    const emailInput = document.getElementById('empEmail');
    const passwordInput = document.getElementById('empPassword');
    const fullNameInput = document.getElementById('empFullName');
    const phoneInput = document.getElementById('empPhone');

    if (usernameInput) {
        usernameInput.addEventListener('blur', checkUsername);
        usernameInput.addEventListener('input', function () { clearError(this); });
    }
    if (emailInput) {
        emailInput.addEventListener('blur', checkEmail);
        emailInput.addEventListener('input', function () { clearError(this); });
    }
    if (passwordInput) {
        passwordInput.addEventListener('blur', checkPassword);
        passwordInput.addEventListener('input', function () { clearError(this); });
    }
    if (fullNameInput) {
        fullNameInput.addEventListener('blur', checkFullName);
        fullNameInput.addEventListener('input', function () { clearError(this); });
    }
    if (phoneInput) {
        phoneInput.addEventListener('blur', checkPhone);
        phoneInput.addEventListener('input', function () { clearError(this); });
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
        const errorSpan = group.querySelector('.error-message');
        if (errorSpan) {
            errorSpan.innerText = '';
            errorSpan.style.display = 'none';
        }
    }
}

function clearAllFormErrors() {
    const inputs = document.querySelectorAll('#userForm input');
    inputs.forEach(input => clearError(input));
}

// =====================================
// 3. Các hàm kiểm tra từng ô dữ liệu
// =====================================
function checkUsername() {
    const input = document.getElementById('empUsername');
    if (!input) return true;
    const val = input.value.trim();
    if (!val) {
        showError(input, 'Vui lòng nhập Username cho nhân viên!');
        return false;
    }
    if (val.length < 3) {
        showError(input, 'Username phải chứa ít nhất 3 ký tự!');
        return false;
    }
    const usernameRegex = /^[a-zA-Z0-9_]+$/;
    if (!usernameRegex.test(val)) {
        showError(input, 'Username chỉ chứa chữ cái, số và dấu gạch dưới!');
        return false;
    }
    clearError(input);
    return true;
}

function checkEmail() {
    const input = document.getElementById('empEmail');
    if (!input) return true;
    const val = input.value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!val) {
        showError(input, 'Vui lòng nhập Email!');
        return false;
    }
    if (!emailRegex.test(val)) {
        showError(input, 'Email không đúng định dạng (ví dụ: nhanvien@luxury-pc.com)!');
        return false;
    }
    clearError(input);
    return true;
}

function checkPassword() {
    const input = document.getElementById('empPassword');
    if (!input) return true;
    const val = input.value.trim();
    // Mật khẩu nhân viên có thể để trống (tự sinh ngẫu nhiên ở backend), nhưng nếu nhập thì phải >= 6 ký tự
    if (val && val.length < 6) {
        showError(input, 'Mật khẩu phải chứa ít nhất 6 ký tự!');
        return false;
    }
    clearError(input);
    return true;
}

function checkFullName() {
    const input = document.getElementById('empFullName');
    if (!input) return true;
    const val = input.value.trim();
    if (!val) {
        showError(input, 'Vui lòng nhập Họ và tên nhân viên!');
        return false;
    }
    if (val.split(/\s+/).length < 2) {
        showError(input, 'Vui lòng nhập đầy đủ cả Họ và Tên (ít nhất 2 từ, ví dụ: Nguyễn Văn A)!');
        return false;
    }
    clearError(input);
    return true;
}

function checkPhone() {
    const input = document.getElementById('empPhone');
    if (!input) return true;
    const val = input.value.trim();
    const phoneRegex = /^(\+?84|0)[3578912][0-9]{8}$/;
    if (!val) {
        showError(input, 'Vui lòng nhập Số điện thoại!');
        return false;
    }
    if (!phoneRegex.test(val)) {
        showError(input, 'Số điện thoại không hợp lệ (đủ 10 chữ số, ví dụ: 0987654321)!');
        return false;
    }
    clearError(input);
    return true;
}

// =====================================
// 4. Các hàm điều khiển UI Form & Reset
// =====================================
function toggleForm() {
    const form = document.getElementById('userForm');
    if (!form) return;
    const isActive = form.classList.toggle('active');
    updateToggleButtonState(isActive);

    if (!isActive) {
        resetFormFields();
    }
}

function resetFormFields() {
    document.getElementById('empId').value = '';
    document.getElementById('empUsername').value = '';
    document.getElementById('empUsername').readOnly = false;
    document.getElementById('empEmail').value = '';
    document.getElementById('empEmail').readOnly = false;
    document.getElementById('empPassword').value = '';
    document.getElementById('empFullName').value = '';
    document.getElementById('empPhone').value = '';
    document.getElementById('empAddress').value = '';

    const genderSelect = document.getElementById('empGender');
    if (genderSelect) genderSelect.value = 'true';

    const statusSelect = document.getElementById('empStatus');
    if (statusSelect) statusSelect.value = 'true';

    const title = document.getElementById('formTitle');
    if (title) title.innerText = 'Thêm Nhân Viên Mới';

    clearAllFormErrors();
}

function editEmployee(btn) {
    const id = btn.getAttribute('data-id');
    const username = btn.getAttribute('data-username');
    const email = btn.getAttribute('data-email');
    const fullname = btn.getAttribute('data-fullname');
    const phone = btn.getAttribute('data-phone');
    const address = btn.getAttribute('data-address');
    const gender = btn.getAttribute('data-gender');
    const status = btn.getAttribute('data-status');

    document.getElementById('empId').value = id || '';

    const usernameInput = document.getElementById('empUsername');
    usernameInput.value = username || '';
    usernameInput.readOnly = true;

    const emailInput = document.getElementById('empEmail');
    emailInput.value = email || '';
    emailInput.readOnly = true;

    document.getElementById('empPassword').value = '';
    document.getElementById('empFullName').value = fullname || '';
    document.getElementById('empPhone').value = phone || '';
    document.getElementById('empAddress').value = address || '';

    if (gender !== null && gender !== undefined) {
        document.getElementById('empGender').value = (gender === 'true' || gender === true) ? 'true' : 'false';
    }
    if (status !== null && status !== undefined) {
        document.getElementById('empStatus').value = (status === 'true' || status === true) ? 'true' : 'false';
    }

    const title = document.getElementById('formTitle');
    if (title) title.innerText = 'Cập Nhật Nhân Viên: ' + (username || '');

    clearAllFormErrors();

    const form = document.getElementById('userForm');
    if (form) {
        form.classList.add('active');
        updateToggleButtonState(true);
        form.scrollIntoView({ behavior: 'smooth' });
    }
}

function updateToggleButtonState(isActive) {
    const btn = document.getElementById('toggleFormBtn');
    if (!btn) return;

    if (isActive) {
        btn.innerHTML = '<i class="fa-solid fa-xmark" style="margin-right: 6px;"></i> <span>Hủy</span>';
        btn.style.background = "#dc2626";
    } else {
        btn.innerHTML = '<i class="fa-solid fa-user-plus" style="margin-right: 6px;"></i> <span>Thêm Nhân Viên Mới</span>';
        btn.style.background = "#0066CC";
    }
}

function initUserFormState() {
    const form = document.getElementById('userForm');
    if (form && form.classList.contains('active')) {
        updateToggleButtonState(true);
    }
}
