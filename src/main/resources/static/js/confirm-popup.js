/**
 * Luxury PC — Unified Global Confirmation & Alert System (Powered by SweetAlert2)
 * Chuẩn hóa 100% tất cả các hộp thoại xác nhận (Confirm/Alert/Modal/Toast) về SweetAlert2
 */

// Tự động tải SweetAlert2 CDN nếu trang chưa nhúng
(function () {
    if (typeof Swal === 'undefined' && !document.getElementById('sweetalert2-cdn')) {
        const script = document.createElement('script');
        script.id = 'sweetalert2-cdn';
        script.src = 'https://cdn.jsdelivr.net/npm/sweetalert2@11';
        document.head.appendChild(script);
    }
})();

// ===== 1. CHUẨN XÁC NHẬN PROMISE: window.showConfirm(msg, title) =====
window.showConfirm = function (message, title) {
    if (typeof Swal === 'undefined') {
        return Promise.resolve(window.confirm(message));
    }
    return Swal.fire({
        title: title || 'Xác Nhận',
        text: message,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#0066CC',
        cancelButtonColor: '#64748b',
        confirmButtonText: 'Xác nhận',
        cancelButtonText: 'Hủy',
        reverseButtons: false,
        customClass: {
            popup: 'luxury-swal-popup'
        }
    }).then(result => result.isConfirmed);
};

window.showConfirmPopup = window.showConfirm;

// ===== 2. CHUẨN FOOTER / GLOBAL CONFIRM MODAL: showConfirmModal(title, msg, callback) =====
window.showConfirmModal = function (title, msg, callback) {
    window.showConfirm(msg, title).then(confirmed => {
        if (confirmed && typeof callback === 'function') {
            callback();
        }
    });
};

window.showSuccessModal = function (title, msg) {
    if (typeof Swal !== 'undefined') {
        Swal.fire({
            title: title || 'Thành Công',
            text: msg,
            icon: 'success',
            confirmButtonColor: '#10b981',
            confirmButtonText: 'OK'
        });
    } else {
        alert((title ? title + "\n" : "") + msg);
    }
};

window.showAlertModal = function (title, msg) {
    if (typeof Swal !== 'undefined') {
        Swal.fire({
            title: title || 'Thông Báo',
            text: msg,
            icon: 'info',
            confirmButtonColor: '#0066CC',
            confirmButtonText: 'Đóng'
        });
    } else {
        alert((title ? title + "\n" : "") + msg);
    }
};

window.closeConfirmModal = function () {
    if (typeof Swal !== 'undefined') {
        Swal.close();
    }
};

// ===== 3. CHUẨN TOAST THÔNG BÁO NHANH: showAlert(msg, isSuccess) =====
window.showAlert = function (msg, isSuccess) {
    if (typeof Swal !== 'undefined') {
        const iconType = isSuccess === false ? 'error' : (isSuccess === true ? 'success' : 'info');
        Swal.fire({
            toast: true,
            position: 'top-end',
            icon: iconType,
            title: msg,
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true
        });
    } else {
        alert(msg);
    }
};
