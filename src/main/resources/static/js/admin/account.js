function toggleForm() {
    const form = document.getElementById('userForm');
    const isActive = form.classList.toggle('active');
    updateToggleButtonState(isActive);
    clearUserForm();
}

function clearUserForm() {
    document.querySelector('input[name="id"]').value = '';
    document.querySelector('input[name="username"]').value = '';
    document.querySelector('input[name="email"]').value = '';
    document.querySelector('input[name="password"]').value = '';
    document.querySelector('input[name="fullName"]').value = '';
    document.querySelector('input[name="phone"]').value = '';
    document.querySelector('input[name="address"]').value = '';
    
    const genderSelect = document.querySelector('select[name="gender"]');
    if (genderSelect) genderSelect.value = 'true';
    
    const statusSelect = document.querySelector('select[name="status"]');
    if (statusSelect) statusSelect.value = 'true';
}

function editUser(btn) {
    const id = btn.getAttribute('data-id');
    const username = btn.getAttribute('data-username');
    const email = btn.getAttribute('data-email');
    const fullname = btn.getAttribute('data-fullname');
    const phone = btn.getAttribute('data-phone');
    const address = btn.getAttribute('data-address');
    const gender = btn.getAttribute('data-gender');
    const status = btn.getAttribute('data-status');

    document.querySelector('input[name="id"]').value = id || '';
    document.querySelector('input[name="username"]').value = username || '';
    document.querySelector('input[name="email"]').value = email || '';
    document.querySelector('input[name="password"]').value = '';
    document.querySelector('input[name="fullName"]').value = fullname || '';
    document.querySelector('input[name="phone"]').value = phone || '';
    document.querySelector('input[name="address"]').value = address || '';
    
    const genderSelect = document.querySelector('select[name="gender"]');
    if (genderSelect) genderSelect.value = gender === 'true' ? 'true' : 'false';
    
    const statusSelect = document.querySelector('select[name="status"]');
    if (statusSelect) statusSelect.value = status === 'true' ? 'true' : 'false';

    const form = document.getElementById('userForm');
    if (form && !form.classList.contains('active')) {
        form.classList.add('active');
        updateToggleButtonState(true);
    }
    
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function updateToggleButtonState(isActive) {
    const btn = document.getElementById('toggleFormBtn');
    if (!btn) return;

    if (isActive) {
        btn.innerHTML = '<i class="fa-solid fa-xmark"></i> <span class="btn-text" data-translate="admin-common-cancel">Hủy</span>';
        btn.classList.remove('btn-gold');
        btn.classList.add('btn-danger');
        btn.style.padding = "0.6rem 1.2rem";
    } else {
        btn.innerHTML = '<i class="fa-solid fa-plus"></i> <span class="btn-text" data-translate="admin-account-btn-add">Thêm User Mới</span>';
        btn.classList.remove('btn-danger');
        btn.classList.add('btn-gold');
    }
}

function initUserFormState() {
    const form = document.getElementById('userForm');
    if (form && form.classList.contains('active')) {
        updateToggleButtonState(true);
    }
}

document.addEventListener('DOMContentLoaded', initUserFormState);
document.addEventListener('spa:load', initUserFormState);
