/* ======================================================
   LUXURY PC - Profile Core Script (core.js)
   ====================================================== */

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

// Confirm dialog helper (Delegate directly to global window.showConfirm)
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

    document.querySelectorAll('.sb-item').forEach(el => el.classList.remove('active'));
    if (event && event.currentTarget) {
        event.currentTarget.classList.add('active');
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

// Avatar Upload Initializer
document.addEventListener('DOMContentLoaded', function () {
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
                        setTimeout(() => window.location.reload(), 1000);
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
