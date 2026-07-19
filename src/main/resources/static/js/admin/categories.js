function toggleForm() {
    const form = document.getElementById('categoryForm');
    const isActive = form.classList.toggle('active');
    updateToggleButtonState(isActive);
}

function updateToggleButtonState(isActive) {
    const btn = document.getElementById('toggleFormBtn');
    if (!btn) return;

    if (isActive) {
        btn.innerHTML = '<i class="fa-solid fa-xmark"></i> <span class="btn-text">Hủy</span>';
        btn.classList.remove('btn-gold');
        btn.classList.add('btn-danger');
    } else {
        btn.innerHTML = '<i class="fa-solid fa-plus"></i> <span class="btn-text">Thêm Danh Mục Mới</span>';
        btn.classList.remove('btn-danger');
        btn.classList.add('btn-gold');
    }
}

function initCategoryFormState() {
    const form = document.getElementById('categoryForm');
    if (form && form.classList.contains('active')) {
        updateToggleButtonState(true);
    }
}

document.addEventListener('DOMContentLoaded', initCategoryFormState);
document.addEventListener('spa:load', initCategoryFormState);

function editCategory(btn) {
    const id = btn.getAttribute('data-id');
    const name = btn.getAttribute('data-name');
    
    document.getElementById('id').value = id;
    document.getElementById('name').value = name;
    
    const h2 = document.querySelector('.card-header h2');
    if (h2) h2.innerText = 'Sửa Danh Mục';
    
    const form = document.getElementById('categoryForm');
    if (!form.classList.contains('active')) {
        form.classList.add('active');
        updateToggleButtonState(true);
    }
    
    window.scrollTo({ top: 0, behavior: 'smooth' });
}
