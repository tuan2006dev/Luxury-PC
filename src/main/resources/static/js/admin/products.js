function toggleForm() {
    const form = document.getElementById('productForm');
    const isActive = form.classList.toggle('active');
    updateToggleButtonState(isActive);
}

function updateToggleButtonState(isActive) {
    const btn = document.getElementById('toggleFormBtn');
    if (!btn) return;

    if (isActive) {
        btn.innerHTML = '<i class="fa-solid fa-xmark"></i> <span class="btn-text" data-translate="admin-products-btn-cancel">Cancel</span>';
        btn.classList.remove('btn-gold');
        btn.classList.add('btn-danger');
    } else {
        btn.innerHTML = '<i class="fa-solid fa-plus"></i> <span class="btn-text" data-translate="admin-products-btn-add">Thêm Sản Phẩm Mới</span>';
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

document.addEventListener('DOMContentLoaded', initProductFormState);
document.addEventListener('turbo:load', initProductFormState);
