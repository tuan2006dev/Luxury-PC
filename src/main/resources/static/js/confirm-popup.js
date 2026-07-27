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

// =======================================================================
// 1. HÀM GỐC: window.showConfirm(msg, title)
// Tác dụng: Đây là hàm lõi sinh ra cái popup giao diện SweetAlert2.
// Nó trả về một "Promise" (lời hứa). Nếu người dùng bấm "Xác nhận", nó trả về True. Bấm Hủy trả về False.
// Các hàm bên dưới đều sẽ gọi hàm gốc này.
// =======================================================================
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

// =======================================================================
// 2. HÀM DÀNH CHO THẺ LINK (THẺ <a>) - window.confirmNavigate
// Cách dùng: Dùng cho các thẻ <a> chuyển trang, đặc biệt là nút XÓA DỮ LIỆU.
// Code mẫu trong file HTML: 
// <a href="/admin/products/delete/1" onclick="return confirmNavigate(event, 'Bạn có muốn xóa?', this.href)">Xóa</a>
// =======================================================================
window.confirmNavigate = function (event, message, url) {
    if (event) event.preventDefault(); // Chặn việc trình duyệt tự động nhảy sang link mới

    // Lấy thẻ <a> an toàn để tránh lỗi event.currentTarget = null
    const trigger = (event && event.currentTarget) ? event.currentTarget :
        (event && event.target ? event.target.closest('a') : null);

    if (trigger && trigger.style) {
        trigger.style.pointerEvents = 'none'; // Khóa nút không cho bấm 2 lần liên tục
    }

    // Gọi popup xác nhận lên
    window.showConfirm(message).then(ok => {
        if (ok) {
            // Nếu người dùng bấm Xác Nhận -> Chủ động chuyển hướng sang URL đó
            window.location.href = url;
        } else {
            // Bấm hủy thì mở khóa nút lại như cũ
            if (trigger && trigger.style) {
                trigger.style.pointerEvents = '';
            }
        }
    });
    return false; // Bắt buộc return false để an toàn chặn sự kiện mặc định
};

// =======================================================================
// 3. HÀM DÀNH CHO THẺ FORM (THẺ <form>) - window.confirmSubmit
// Cách dùng: Dùng cho các thẻ Form gửi dữ liệu POST. 
// Ví dụ: Nút Khóa tài khoản, Nút Đặt lại Mật khẩu, Nút Xóa nhân viên...
// Code mẫu trong file HTML (Viết trực tiếp vào thẻ <form>):
// <form onsubmit="return window.confirmSubmit(event, 'Bạn có chắc muốn Khóa nhân viên?');">
//    <button type="submit">Khóa</button>
// </form>
// =======================================================================
window.confirmSubmit = function (event, message) {
    if (event) event.preventDefault(); // Chặn việc Form tự động Submit (tải lại trang)

    // Lấy thẻ form một cách an toàn
    const form = (event && event.target && event.target.tagName === 'FORM') ? event.target :
        (event && event.target ? event.target.closest('form') : null);

    // Tạm thời vô hiệu hóa nút Submit bên trong form để chống spam click
    const submitBtn = form ? form.querySelector('[type="submit"]') : null;
    if (submitBtn) submitBtn.disabled = true;

    // Gọi popup xác nhận lên
    window.showConfirm(message).then(ok => {
        if (ok) {
            // Bấm Xác Nhận -> Chủ động submit form
            if (form) form.submit();
        } else if (submitBtn) {
            // Bấm Hủy -> Mở khóa nút submit ra
            submitBtn.disabled = false;
        }
    });
    return false; // Bắt buộc return false để an toàn chặn form
};
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
    let titleStr = msg;
    let successState = isSuccess;
    if (typeof msg === 'object' && msg !== null) {
        titleStr = msg.message || msg.title || msg.text || JSON.stringify(msg);
        if (msg.isSuccess !== undefined) successState = msg.isSuccess;
    }

    if (typeof Swal !== 'undefined') {
        const iconType = successState === false ? 'error' : (successState === true ? 'success' : 'info');
        Swal.fire({
            toast: true,
            position: 'top-end',
            icon: iconType,
            title: titleStr,
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true
        });
    } else {
        alert(titleStr);
    }
};
