function toggleForm() {
    const form = document.getElementById('productForm');
    const isActive = form.classList.toggle('active');
    updateToggleButtonState(isActive);
}

function updateToggleButtonState(isActive) {
    const btn = document.getElementById('toggleFormBtn');
    if (!btn) return;

    if (isActive) {
        btn.innerHTML = '<i class="fa-solid fa-xmark"></i> <span class="btn-text">Cancel</span>';
        btn.classList.remove('btn-gold');
        btn.classList.add('btn-danger');
    } else {
        btn.innerHTML = '<i class="fa-solid fa-plus"></i> <span class="btn-text">Thêm Sản Phẩm Mới</span>';
        btn.classList.remove('btn-danger');
        btn.classList.add('btn-gold');
    }
}

function initProductFormState() {
    const form = document.getElementById('productForm');
    if (form && form.classList.contains('active')) {
        updateToggleButtonState(true);
    }
}

document.addEventListener('DOMContentLoaded', () => {
    initProductFormState();

    const form = document.getElementById('productFormElement');
    if (form) {
        form.addEventListener('submit', function (e) {
            e.preventDefault();

            const name = document.querySelector('input[name="name"]').value.trim();
            if (!name) {
                showValidationError('Vui lòng nhập tên sản phẩm.');
                return;
            }

            const price = document.querySelector('input[name="price"]').value;
            if (!price || price === '') {
                showValidationError('Vui lòng nhập giá bán.');
                return;
            }

            const cat = document.querySelector('select[name="category.id"]').value;
            if (!cat) {
                showValidationError('Vui lòng chọn danh mục sản phẩm.');
                return;
            }

            form.submit();
        });
    }
});

function showValidationError(message) {
    if (typeof Swal !== 'undefined') {
        Swal.fire({
            title: 'Lỗi!',
            text: message,
            icon: 'warning',
            background: '#1a1a1a',
            color: '#f5f0e8',
            confirmButtonColor: '#c9a84c'
        });
    } else {
        alert(message);
    }
}

document.addEventListener('spa:load', () => {
    initProductFormState();

    const form = document.getElementById('productFormElement');
    if (form && !form.dataset.hasValidation) {
        form.dataset.hasValidation = 'true';
        form.addEventListener('submit', function (e) {
            e.preventDefault();

            const name = document.querySelector('input[name="name"]').value.trim();
            if (!name) {
                showValidationError('Vui lòng nhập tên sản phẩm.');
                return;
            }

            const price = document.querySelector('input[name="price"]').value;
            if (!price || price === '') {
                showValidationError('Vui lòng nhập giá bán.');
                return;
            }

            const cat = document.querySelector('select[name="category.id"]').value;
            if (!cat) {
                showValidationError('Vui lòng chọn danh mục sản phẩm.');
                return;
            }

            form.submit();
        });
    }
});

function editProduct(btn) {
    const id = btn.getAttribute('data-id');
    const name = btn.getAttribute('data-name');
    const price = btn.getAttribute('data-price');
    const cat = btn.getAttribute('data-cat');
    const brand = btn.getAttribute('data-brand');
    const desc = btn.getAttribute('data-desc');
    const stock = btn.getAttribute('data-stock');

    document.getElementById('id').value = id || '';
    document.getElementById('name').value = name || '';
    document.getElementById('price').value = price || '';

    const catSelect = document.querySelector('select[name="category.id"]');
    if (catSelect) catSelect.value = cat || '';

    const brandInput = document.getElementById('brand');
    if (brandInput) brandInput.value = brand || '';

    const descEl = document.getElementById('description');
    if (descEl) descEl.value = desc || '';
    document.getElementById('stock').value = stock || '0';

    const imageInput = document.getElementById('image');
    if (imageInput) imageInput.value = btn.getAttribute('data-image') || '';
    const imageUrlInput = document.getElementById('imageUrl');
    if (imageUrlInput) imageUrlInput.value = btn.getAttribute('data-image') || '';

    // Update header
    const h2 = document.querySelector('.card-header h2');
    if (h2) h2.innerText = 'Cập Nhật Sản Phẩm';

    // Show form
    const form = document.getElementById('productForm');
    if (form && !form.classList.contains('active')) {
        form.classList.add('active');
        updateToggleButtonState(true);
    }

    // Smooth scroll to top
    window.scrollTo({ top: 0, behavior: 'smooth' });
}
