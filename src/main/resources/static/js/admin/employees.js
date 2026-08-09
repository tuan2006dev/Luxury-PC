/**
 * Quản Lý Nhân Viên (Staff) - Realtime Live Field Validation & UI Handler
 * Viết theo phong cách đơn giản, tuyến tính (Fresher/Junior Style) giống account.js và login.js
 */

document.addEventListener('DOMContentLoaded', function () {
    initUserFormState();
    bindValidationEvents();
    initStaffLogSearch();
});

document.addEventListener('spa:load', function () {
    initUserFormState();
    bindValidationEvents();
    initStaffLogSearch();
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
            if (firstInvalid) firstInvalid.focus({ preventScroll: true });
            return false;
        }

        clearAllFormErrors();
    };

    const usernameInput = document.getElementById('empUsername');
    const emailInput = document.getElementById('empEmail');
    const passwordInput = document.getElementById('empPassword');
    const fullNameInput = document.getElementById('empFullName');
    const phoneInput = document.getElementById('empPhone');

    if (usernameInput) {
        usernameInput.addEventListener('blur', checkUsername);
        usernameInput.addEventListener('input', function () {
            if (this.classList.contains('is-invalid')) checkUsername();
            else clearError(this);
        });
    }
    if (emailInput) {
        emailInput.addEventListener('blur', checkEmail);
        emailInput.addEventListener('input', function () {
            if (this.classList.contains('is-invalid')) checkEmail();
            else clearError(this);
        });
    }
    if (passwordInput) {
        passwordInput.addEventListener('blur', checkPassword);
        passwordInput.addEventListener('input', function () {
            if (this.classList.contains('is-invalid')) checkPassword();
            else clearError(this);
        });
    }
    if (fullNameInput) {
        fullNameInput.addEventListener('blur', checkFullName);
        fullNameInput.addEventListener('input', function () {
            if (this.classList.contains('is-invalid')) checkFullName();
            else clearError(this);
        });
    }
    if (phoneInput) {
        phoneInput.addEventListener('blur', checkPhone);
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
        const errorSpan = group.querySelector('.error-message');
        if (errorSpan) {
            errorSpan.innerText = '';
            errorSpan.style.display = 'none';
        }
    }
}

function clearAllFormErrors() {
    const form = document.getElementById('userForm');
    if (!form) return;
    form.querySelectorAll('.is-invalid').forEach(input => input.classList.remove('is-invalid'));
    form.querySelectorAll('.error-message, .error-text').forEach(span => {
        span.innerText = '';
        span.style.display = 'none';
        if (span.classList.contains('error-text')) span.remove();
    });
}

// =====================================
// 3. Các hàm kiểm tra từng ô dữ liệu
// =====================================
function checkUsername() {
    const input = document.getElementById('empUsername');
    if (!input) return true;
    const isEdit = input.readOnly || (document.getElementById('empId') && document.getElementById('empId').value);
    if (isEdit) {
        clearError(input);
        return true;
    }
    const val = input.value.trim();
    if (!val) {
        showError(input, 'Vui lòng nhập Username cho nhân viên!');
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
    const input = document.getElementById('empEmail');
    if (!input) return true;
    const isEdit = input.readOnly || (document.getElementById('empId') && document.getElementById('empId').value);
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
    if (val.length < 2) {
        showError(input, 'Họ và tên quá ngắn!');
        return false;
    }
    clearError(input);
    return true;
}

function checkPhone() {
    const input = document.getElementById('empPhone');
    if (!input) return true;
    const val = input.value.trim();
    if (!val) {
        showError(input, 'Vui lòng nhập Số điện thoại!');
        return false;
    }
    const cleanPhone = val.replace(/[\s.-]/g, '');
    const phoneRegex = /^(\+?84|0)[0-9]{8,10}$/;
    if (!phoneRegex.test(cleanPhone)) {
        showError(input, 'Số điện thoại không hợp lệ (ví dụ: 0987654321)!');
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
    const username = btn.getAttribute('data-username') || '';
    const email = btn.getAttribute('data-email') || '';
    const fullname = btn.getAttribute('data-fullname') || '';
    const phone = btn.getAttribute('data-phone') || '';
    const address = btn.getAttribute('data-address') || '';
    const gender = btn.getAttribute('data-gender');
    const status = btn.getAttribute('data-status');

    document.getElementById('empId').value = id || '';

    const usernameInput = document.getElementById('empUsername');
    usernameInput.value = username;
    usernameInput.readOnly = true;

    const emailInput = document.getElementById('empEmail');
    emailInput.value = email;
    emailInput.readOnly = true;

    document.getElementById('empPassword').value = '';
    document.getElementById('empFullName').value = fullname;
    document.getElementById('empPhone').value = phone;
    document.getElementById('empAddress').value = address;

    if (gender !== null && gender !== undefined) {
        document.getElementById('empGender').value = (gender === 'true' || gender === true) ? 'true' : 'false';
    }
    if (status !== null && status !== undefined) {
        document.getElementById('empStatus').value = (status === 'true' || status === true) ? 'true' : 'false';
    }

    const title = document.getElementById('formTitle');
    if (title) title.innerText = 'Cập Nhật Nhân Viên: ' + username;

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
    initStaffLogSearch();
}

// =====================================
// 5. Bộ lọc thời gian & Tìm kiếm tên cho Nhật Ký Thao Tác (Staff Audit Logs)
// =====================================
let currentLogRange = 'all';
let customStartDate = '';
let customEndDate = '';
let currentSearchKeyword = '';

function initStaffLogSearch() {
    const searchContainer = document.getElementById('staffLogsSearchContainer') || document.querySelector('#logsTableBody')?.closest('.card');
    if (!searchContainer) return;

    const searchInput = searchContainer.querySelector('input[name="keyword"]');
    const searchForm = searchContainer.querySelector('form');

    if (searchInput) {
        searchInput.placeholder = "Tìm theo tên nhân viên...";
        // Tự động khôi phục khi xóa hết từ khóa trong ô nhập
        searchInput.addEventListener('input', function () {
            if (this.value.trim() === '' && currentSearchKeyword !== '') {
                currentSearchKeyword = '';
                applyStaffLogFilters();
            }
        });
    }

    if (searchForm) {
        searchForm.onsubmit = function (e) {
            e.preventDefault();
            if (searchInput) {
                currentSearchKeyword = searchInput.value.trim().toLowerCase();
            }
            applyStaffLogFilters();
            return false;
        };
    }
}

function filterStaffLogs(range, btn) {
    // Hide custom date popover if open
    const box = document.getElementById('customLogDateBox');
    if (box) box.style.display = 'none';

    document.querySelectorAll('.log-filter-btn').forEach(b => {
        b.style.background = 'transparent';
        b.style.color = '#64748b';
        b.style.fontWeight = '500';
    });
    if (btn) {
        btn.style.background = '#3b82f6';
        btn.style.color = '#ffffff';
        btn.style.fontWeight = '600';
    }

    currentLogRange = range;
    applyStaffLogFilters();
}

function toggleLogCustomRange(btn) {
    const box = document.getElementById('customLogDateBox');
    if (!box) return;
    const isVisible = (box.style.display === 'flex');
    box.style.display = isVisible ? 'none' : 'flex';
}

function applyCustomLogFilter() {
    const startVal = document.getElementById('logStartDate').value; // YYYY-MM-DD
    const endVal = document.getElementById('logEndDate').value;     // YYYY-MM-DD

    if (!startVal && !endVal) {
        alert('Vui lòng chọn Từ ngày hoặc Đến ngày!');
        return;
    }

    // Hide popover
    const box = document.getElementById('customLogDateBox');
    if (box) box.style.display = 'none';

    // Highlight custom button
    const customBtn = document.getElementById('customLogDateBtn');
    document.querySelectorAll('.log-filter-btn').forEach(b => {
        b.style.background = 'transparent';
        b.style.color = '#64748b';
        b.style.fontWeight = '500';
    });
    if (customBtn) {
        customBtn.style.background = '#3b82f6';
        customBtn.style.color = '#ffffff';
        customBtn.style.fontWeight = '600';
    }

    currentLogRange = 'custom';
    customStartDate = startVal;
    customEndDate = endVal;
    applyStaffLogFilters();
}

function removeVietnameseTones(str) {
    if (!str) return '';
    str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
    str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
    str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
    str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
    str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
    str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
    str = str.replace(/đ/g, "d");
    str = str.replace(/À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ/g, "A");
    str = str.replace(/È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ/g, "E");
    str = str.replace(/Ì|Í|Ị|Ỉ|Ĩ/g, "I");
    str = str.replace(/Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ/g, "O");
    str = str.replace(/Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ/g, "U");
    str = str.replace(/Ỳ|Ý|Ỵ|Ỷ|Ỹ/g, "Y");
    str = str.replace(/Đ/g, "D");
    return str;
}

function applyStaffLogFilters() {
    const rows = document.querySelectorAll('.log-row');
    const now = new Date();
    const todayStr = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0') + '-' + String(now.getDate()).padStart(2, '0');
    
    let matchingCount = 0;

    const normalizedKeyword = removeVietnameseTones(currentSearchKeyword);

    rows.forEach(row => {
        const rowTime = parseInt(row.getAttribute('data-timestamp') || '0');
        const rowDate = row.getAttribute('data-date') || '';
        let dateMatch = false;

        if (currentLogRange === 'all') {
            dateMatch = true;
        } else if (currentLogRange === 'today') {
            dateMatch = (rowDate === todayStr);
        } else if (currentLogRange === '7d') {
            const diffDays = (now.getTime() - rowTime) / (1000 * 3600 * 24);
            dateMatch = (diffDays <= 7);
        } else if (currentLogRange === '30d') {
            const diffDays = (now.getTime() - rowTime) / (1000 * 3600 * 24);
            dateMatch = (diffDays <= 30);
        } else if (currentLogRange === 'custom') {
            dateMatch = true;
            if (customStartDate && rowDate < customStartDate) dateMatch = false;
            if (customEndDate && rowDate > customEndDate) dateMatch = false;
        }

        let searchMatch = true;
        if (normalizedKeyword) {
            const rowText = removeVietnameseTones(row.textContent || '').toLowerCase();
            searchMatch = rowText.includes(normalizedKeyword);
        }

        if (dateMatch && searchMatch) {
            row.style.display = '';
            matchingCount++;
        } else {
            row.style.display = 'none';
        }
    });

    const noRow = document.getElementById('noFilteredLogsRow');
    if (noRow) {
        noRow.style.display = (matchingCount === 0 && rows.length > 0) ? '' : 'none';
    }

    const countBadge = document.getElementById('logCountBadge');
    if (countBadge) {
        countBadge.innerHTML = `<i class="fa-solid fa-list-check" style="margin-right: 4px;"></i> Hiển thị ${matchingCount} nhật ký`;
    }
}
