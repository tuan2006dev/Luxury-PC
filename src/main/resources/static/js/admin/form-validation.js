function initFormValidation() {
    // Tắt validation mặc định của trình duyệt trên tất cả các form có class needs-validation
    const forms = document.querySelectorAll('form.needs-validation');
    forms.forEach(form => {
        if (!form.hasAttribute('novalidate')) {
            form.setAttribute('novalidate', 'novalidate');
        }
    });
}

// Chạy khi trang load lần đầu
document.addEventListener('DOMContentLoaded', initFormValidation);

// Chạy mỗi khi load trang qua SPA (Ajax)
document.addEventListener('spa:load', initFormValidation);

// Từ điển các câu thông báo lỗi chi tiết theo thuộc tính "name" của input
var errorMessagesDict = window.errorMessagesDict || {
    'name': 'Vui lòng nhập tên (Sản phẩm, Danh mục, Chương trình, ...).',
    'price': 'Vui lòng nhập giá bán hợp lệ.',
    'salePrice': 'Vui lòng nhập giá khuyến mãi.',
    'saleQuantity': 'Vui lòng nhập số lượng khuyến mãi.',
    'stock': 'Vui lòng nhập số lượng tồn kho.',
    'productId': 'Vui lòng chọn một sản phẩm.',
    'categoryId': 'Vui lòng chọn danh mục.',
    'category.id': 'Vui lòng chọn danh mục.',
    'startTime': 'Vui lòng chọn thời gian bắt đầu.',
    'endTime': 'Vui lòng chọn thời gian kết thúc.',
    'username': 'Vui lòng nhập tên đăng nhập (Username).',
    'password': 'Vui lòng nhập mật khẩu.',
    'email': 'Vui lòng nhập địa chỉ email hợp lệ.',
    'fullName': 'Vui lòng nhập họ và tên đầy đủ.',
    'phone': 'Vui lòng nhập số điện thoại liên hệ.',
    'code': 'Vui lòng nhập mã Voucher.',
    'discountValue': 'Vui lòng nhập giá trị giảm giá.',
    'minOrderAmount': 'Vui lòng nhập giá trị đơn hàng tối thiểu.',
    'usageLimit': 'Vui lòng nhập giới hạn lượt sử dụng.',
    'cpuId': 'Vui lòng chọn CPU.',
    'mainboardId': 'Vui lòng chọn Mainboard.',
    'ramId': 'Vui lòng chọn RAM.',
    'vgaId': 'Vui lòng chọn VGA.',
    'storageId': 'Vui lòng chọn Ổ cứng.',
    'psuId': 'Vui lòng chọn Nguồn (PSU).',
    'caseId': 'Vui lòng chọn Vỏ Case.',
    'address': 'Vui lòng nhập địa chỉ.',
    'description': 'Vui lòng nhập mô tả chi tiết.',
    'shortDescription': 'Vui lòng nhập mô tả nhanh.',
    'badge': 'Vui lòng nhập nhãn dán (Badge).',
    'badgeColor': 'Vui lòng chọn màu nhãn dán.',
    'maxPerUser': 'Vui lòng nhập số lượng mua tối đa mỗi người.'
};

// Sử dụng Event Delegation cho toàn bộ document thay vì gán event cho từng form
document.addEventListener('submit', function(event) {
    const form = event.target;
    if (form.tagName === 'FORM' && form.classList.contains('needs-validation')) {
        let isValid = true;
        let firstErrorElement = null;

        // Xoá các thông báo lỗi cũ
        form.querySelectorAll('.error-text').forEach(el => el.remove());
        form.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));

        // 1. Kiểm tra các thuộc tính HTML5
        const elements = form.querySelectorAll('input, select, textarea');
        for (let el of elements) {
            if (el.disabled || el.readOnly || el.type === 'hidden') continue;

            const value = el.value.trim();
            const inputName = el.getAttribute('name');
            let errorMsg = '';

            // Kiểm tra required
            if (el.hasAttribute('required') && !value) {
                // Lấy thông báo lỗi chi tiết từ từ điển, nếu không có thì dùng câu chung chung
                errorMsg = errorMessagesDict[inputName] || 'Vui lòng nhập/chọn thông tin này.';
            } else if (el.type === 'number' && value !== '') {
                const numVal = parseFloat(value);
                if (el.hasAttribute('min') && numVal < parseFloat(el.getAttribute('min'))) {
                    errorMsg = `Giá trị không được nhỏ hơn ${el.getAttribute('min')}.`;
                } else if (el.hasAttribute('max') && numVal > parseFloat(el.getAttribute('max'))) {
                    errorMsg = `Giá trị không được lớn hơn ${el.getAttribute('max')}.`;
                }
            } else if (el.type === 'email' && value !== '') {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(value)) {
                    errorMsg = `Email không đúng định dạng. VD: admin@gmail.com`;
                }
            }

            if (errorMsg) {
                isValid = false;
                showError(el, errorMsg);
                if (!firstErrorElement) firstErrorElement = el;
            }
        }

        // 2. Gọi custom validation nếu được định nghĩa ở trang cụ thể
        if (isValid && typeof window.customValidate === 'function') {
            const customResult = window.customValidate(form);
            if (customResult !== true) {
                isValid = false;
                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Thông báo',
                        text: customResult,
                        confirmButtonColor: '#c9a84c'
                    });
                } else {
                    alert(customResult);
                }
            }
        }

        // Nếu không hợp lệ, chặn submit và scroll
        if (!isValid) {
            event.preventDefault(); 
            if (firstErrorElement) {
                firstErrorElement.focus();
                firstErrorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }
    }
});

document.addEventListener('input', function(e) {
    if (e.target.classList && e.target.classList.contains('is-invalid')) {
        e.target.classList.remove('is-invalid');
        const nextEl = e.target.nextElementSibling;
        if (nextEl && nextEl.classList.contains('error-text')) {
            nextEl.remove();
        }
    }
});

document.addEventListener('change', function(e) {
    if (e.target.tagName === 'SELECT' && e.target.classList.contains('is-invalid')) {
        e.target.classList.remove('is-invalid');
        const nextEl = e.target.nextElementSibling;
        if (nextEl && nextEl.classList.contains('error-text')) {
            nextEl.remove();
        }
    }
});

function showError(el, message) {
    el.classList.add('is-invalid');
    const errorSmall = document.createElement('small');
    errorSmall.className = 'error-text';
    errorSmall.style.color = '#ef4444';
    errorSmall.style.fontSize = '12px';
    errorSmall.style.marginTop = '4px';
    errorSmall.style.display = 'block';
    errorSmall.style.fontWeight = '500';
    errorSmall.innerText = message;

    if (el.closest('.file-upload-wrapper') || el.closest('.input-group')) {
         const wrapper = el.closest('.file-upload-wrapper') || el.closest('.input-group');
         const existingError = wrapper.querySelector('.error-text');
         if (existingError) {
             existingError.innerText = message;
         } else {
             wrapper.appendChild(errorSmall);
         }
    } else {
        const nextEl = el.nextElementSibling;
        if (nextEl && nextEl.classList.contains('error-text')) {
            nextEl.innerText = message;
        } else {
            el.parentNode.insertBefore(errorSmall, el.nextSibling);
        }
    }
}
