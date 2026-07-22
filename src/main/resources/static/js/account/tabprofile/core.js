/* ======================================================
   LUXURY PC - Profile Core Script (core.js)
   ====================================================== */

window.currentActiveTab = 'info';

// CSRF Helpers
function getCsrfToken() {
    return document.querySelector('meta[name="_csrf"]')?.content ||
        document.querySelector('input[name="_csrf"]')?.value || '';
}

function getCsrfHeader() {
    return document.querySelector('meta[name="_csrf_header"]')?.content || 'X-CSRF-TOKEN';
}

// Toast helper fallback
function toast(msg) {
    if (typeof window.showAlert === 'function') {
        window.showAlert(msg);
    } else if (typeof Swal !== 'undefined') {
        Swal.fire({
            toast: true,
            position: 'top-end',
            icon: 'info',
            title: msg,
            showConfirmButton: false,
            timer: 3000
        });
    } else {
        alert(msg);
    }
}

// Confirm dialog helper
function showConfirm(msg) {
    if (typeof window.showConfirm === 'function') {
        return window.showConfirm(msg);
    }
    if (typeof Swal !== 'undefined') {
        return Swal.fire({
            title: 'Xác Nhận',
            text: msg,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#0066CC',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Xác nhận',
            cancelButtonText: 'Hủy'
        }).then(result => result.isConfirmed);
    }
    return Promise.resolve(window.confirm(msg));
}

// Tab Switcher
function setTab(tabName, event) {
    if (event) event.preventDefault();
    if (!tabName) tabName = 'info';

    window.currentActiveTab = tabName;
    try {
        localStorage.setItem('profile_active_tab', tabName);
    } catch (e) {}

    // Synchronize URL query param without full reload
    try {
        const url = new URL(window.location);
        url.searchParams.set('tab', tabName);
        window.history.replaceState({}, '', url);
    } catch (e) {}

    document.querySelectorAll('.sb-item').forEach(el => el.classList.remove('active'));
    const activeSb = document.querySelector(`.sb-item[data-tab="${tabName}"]`) ||
                     document.querySelector(`.sb-item[onclick*="'${tabName}'"]`);
    if (activeSb) {
        activeSb.classList.add('active');
    }

    document.querySelectorAll('.profile-section').forEach(el => el.classList.remove('active'));
    const activeSec = document.getElementById('sec-' + tabName);
    if (activeSec) {
        activeSec.classList.add('active');
    }

    if (tabName === 'address' && typeof loadAddresses === 'function') {
        loadAddresses();
    }
}

// Helper to reload page while staying on current active tab
function reloadProfileTab(tabName) {
    const targetTab = tabName || window.currentActiveTab || 'info';
    try {
        localStorage.setItem('profile_active_tab', targetTab);
    } catch (e) {}
    window.location.href = '/profile?tab=' + targetTab;
}

// Initialize active tab on page load
document.addEventListener('DOMContentLoaded', function () {
    const urlParams = new URLSearchParams(window.location.search);
    const tabParam = urlParams.get('tab');
    const hashParam = window.location.hash ? window.location.hash.replace('#', '') : null;
    let savedTab = null;
    try {
        savedTab = localStorage.getItem('profile_active_tab');
    } catch (e) {}

    const initialTab = tabParam || hashParam || savedTab || 'info';
    setTab(initialTab);

    // Avatar Upload Initializer
    const avatarInput = document.getElementById('avatar-file-input');
    if (avatarInput) {
        avatarInput.addEventListener('change', async function () {
            if (this.files && this.files[0]) {
                const file = this.files[0];
                const formData = new FormData();
                formData.append('file', file);

                const headers = {};
                const token = getCsrfToken();
                if (token) {
                    headers[getCsrfHeader()] = token;
                }

                try {
                    const response = await fetch('/api/profile/avatar', {
                        method: 'POST',
                        headers: headers,
                        body: formData
                    });

                    const result = await response.json();
                    if (result.success) {
                        toast("Đã cập nhật ảnh đại diện!");
                        setTimeout(() => reloadProfileTab('info'), 800);
                    } else {
                        toast(result.message || "Lỗi cập nhật ảnh đại diện.");
                    }
                } catch (error) {
                    console.error("Error uploading avatar:", error);
                    toast("Đã xảy ra lỗi mạng. Vui lòng thử lại.");
                }
            }
        });
    }
});
