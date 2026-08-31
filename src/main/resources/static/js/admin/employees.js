/**
 * Quản Lý Nhân Viên (Staff) - Realtime Live Field Validation & UI Handler
 * Viết theo phong cách đơn giản, tuyến tính (Fresher/Junior Style) giống account.js và login.js
 */

function initEmployeePage() {
    initUserFormState();
    bindValidationEvents();
    initStaffLogSearch();
    applyStaffLogFilters(true);
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initEmployeePage);
} else {
    initEmployeePage();
}
document.addEventListener('spa:load', initEmployeePage);

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
// 5. Bộ lọc thời gian, Tìm kiếm & Phân trang cho Nhật Ký Thao Tác (Staff Audit Logs)
// =====================================
let currentLogRange = 'all';
let customStartDate = '';
let customEndDate = '';
let currentSearchKeyword = '';
let currentLogPage = 1;
const LOGS_PER_PAGE = 10;
let currentMatchingLogRows = [];

function initStaffLogSearch() {
    const searchContainer = document.getElementById('staffLogsSearchContainer') || document.querySelector('#logsTableBody')?.closest('.card');
    if (!searchContainer) return;

    const searchInput = searchContainer.querySelector('input[name="keyword"]');
    const searchForm = searchContainer.querySelector('form');

    if (searchInput) {
        searchInput.placeholder = "Tìm theo tên nhân viên, hành động...";
        // Tự động khôi phục danh sách khi người dùng xóa hết chữ trong ô nhập
        searchInput.addEventListener('input', function () {
            if (this.value.trim() === '' && currentSearchKeyword !== '') {
                currentSearchKeyword = '';
                applyStaffLogFilters(true);
            }
        });
    }

    if (searchForm) {
        searchForm.onsubmit = function (e) {
            e.preventDefault();
            e.stopPropagation();
            if (searchInput) {
                currentSearchKeyword = searchInput.value.trim().toLowerCase();
            }
            applyStaffLogFilters(true);
            return false;
        };

        const submitBtn = searchForm.querySelector('button[type="submit"]');
        if (submitBtn) {
            submitBtn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                if (searchInput) {
                    currentSearchKeyword = searchInput.value.trim().toLowerCase();
                }
                applyStaffLogFilters(true);
            });
        }
    }

    const clearBtn = searchContainer.querySelector('a');
    if (clearBtn) {
        clearBtn.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            if (searchInput) searchInput.value = '';
            currentSearchKeyword = '';
            applyStaffLogFilters(true);
        });
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
    applyStaffLogFilters(true);
}

function toggleLogCustomRange(btn) {
    const box = document.getElementById('customLogDateBox');
    if (!box) return;
    const isVisible = (box.style.display === 'flex');
    box.style.display = isVisible ? 'none' : 'flex';
}

document.addEventListener('click', function (e) {
    const box = document.getElementById('customLogDateBox');
    const btn = document.getElementById('customLogDateBtn');
    if (!box || box.style.display !== 'flex') return;
    if (!box.contains(e.target) && (!btn || !btn.contains(e.target))) {
        box.style.display = 'none';
    }
});

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
    applyStaffLogFilters(true);
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

function applyStaffLogFilters(resetPage = true) {
    const rows = Array.from(document.querySelectorAll('.log-row'));
    const now = new Date();
    const todayStr = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0') + '-' + String(now.getDate()).padStart(2, '0');

    currentMatchingLogRows = [];
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
            currentMatchingLogRows.push(row);
        } else {
            row.style.display = 'none';
        }
    });

    if (resetPage) {
        currentLogPage = 1;
    }

    renderLogPagination();
}

function renderLogPagination() {
    const totalItems = currentMatchingLogRows.length;
    const totalPages = Math.ceil(totalItems / LOGS_PER_PAGE) || 1;

    if (currentLogPage < 1) currentLogPage = 1;
    if (currentLogPage > totalPages) currentLogPage = totalPages;

    const startIndex = (currentLogPage - 1) * LOGS_PER_PAGE;
    const endIndex = Math.min(startIndex + LOGS_PER_PAGE, totalItems);

    currentMatchingLogRows.forEach((row, idx) => {
        if (idx >= startIndex && idx < endIndex) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });

    const noRow = document.getElementById('noFilteredLogsRow');
    if (noRow) {
        noRow.style.display = (totalItems === 0 && document.querySelectorAll('.log-row').length > 0) ? '' : 'none';
    }

    const countBadge = document.getElementById('logCountBadge');
    if (countBadge) {
        countBadge.innerHTML = `<i class="fa-solid fa-list-check" style="margin-right: 4px;"></i> Hiển thị ${totalItems} nhật ký`;
    }

    const paginationWrapper = document.getElementById('staffLogsPagination');
    if (!paginationWrapper) return;

    if (totalItems === 0) {
        paginationWrapper.style.display = 'none';
        return;
    }

    paginationWrapper.style.display = 'flex';

    const startSpan = document.getElementById('logStartItem');
    const endSpan = document.getElementById('logEndItem');
    const totalSpan = document.getElementById('logTotalItems');
    const badgeSpan = document.getElementById('logPageBadge');

    if (startSpan) startSpan.innerText = startIndex + 1;
    if (endSpan) endSpan.innerText = endIndex;
    if (totalSpan) totalSpan.innerText = totalItems;
    if (badgeSpan) badgeSpan.innerText = `(Trang ${currentLogPage} / ${totalPages})`;

    const btnsContainer = document.getElementById('logPaginationBtns');
    if (!btnsContainer) return;

    if (totalPages <= 1) {
        btnsContainer.innerHTML = '';
        return;
    }

    let btnsHtml = '';

    // Nút Trang đầu
    btnsHtml += `
        <button type="button" class="page-btn nav-btn ${currentLogPage === 1 ? 'disabled' : ''}" 
            ${currentLogPage === 1 ? 'disabled' : ''} onclick="goToLogPage(1)" title="Trang đầu">
            <i class="fa-solid fa-angles-left"></i>
        </button>
    `;

    // Nút Trang trước
    // btnsHtml += `
    //     <button type="button" class="page-btn nav-btn ${currentLogPage === 1 ? 'disabled' : ''}" 
    //         ${currentLogPage === 1 ? 'disabled' : ''} onclick="goToLogPage(${currentLogPage - 1})" title="Trang trước">
    //         <i class="fa-solid fa-angle-left"></i>
    //     </button>
    // `;

    // Các số trang (window +/- 2)
    const startPage = Math.max(1, currentLogPage - 2);
    const endPage = Math.min(totalPages, currentLogPage + 2);

    // if (startPage > 1) {
    //     btnsHtml += `<button type="button" class="page-btn num-btn" onclick="goToLogPage(1)">1</button>`;
    //     if (startPage > 2) {
    //         btnsHtml += `<span style="padding: 0 4px; color: #94a3b8; font-size: 12px;">...</span>`;
    //     }
    // }

    for (let i = startPage; i <= endPage; i++) {
        btnsHtml += `
            <button type="button" class="page-btn num-btn ${i === currentLogPage ? 'active' : ''}" 
                onclick="goToLogPage(${i})">${i}</button>
        `;
    }

    // if (endPage < totalPages) {
    //     if (endPage < totalPages - 1) {
    //         btnsHtml += `<span style="padding: 0 4px; color: #94a3b8; font-size: 12px;">...</span>`;
    //     }
    //     btnsHtml += `<button type="button" class="page-btn num-btn" onclick="goToLogPage(${totalPages})">${totalPages}</button>`;
    // }

    // Nút Trang sau
    // btnsHtml += `
    //     <button type="button" class="page-btn nav-btn ${currentLogPage === totalPages ? 'disabled' : ''}" 
    //         ${currentLogPage === totalPages ? 'disabled' : ''} onclick="goToLogPage(${currentLogPage + 1})" title="Trang kế tiếp">
    //         <i class="fa-solid fa-angle-right"></i>
    //     </button>
    // `;

    // Nút Trang cuối
    btnsHtml += `
        <button type="button" class="page-btn nav-btn ${currentLogPage === totalPages ? 'disabled' : ''}" 
            ${currentLogPage === totalPages ? 'disabled' : ''} onclick="goToLogPage(${totalPages})" title="Trang cuối">
            <i class="fa-solid fa-angles-right"></i>
        </button>
    `;

    btnsContainer.innerHTML = btnsHtml;
}

function goToLogPage(page) {
    currentLogPage = page;
    renderLogPagination();
    const wrapper = document.getElementById('staffLogsWrapper');
    if (wrapper) {
        wrapper.scrollTo({ top: 0, behavior: 'smooth' });
    }
}

window.goToLogPage = goToLogPage;

