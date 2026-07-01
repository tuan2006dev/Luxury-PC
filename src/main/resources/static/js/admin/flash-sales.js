function openModal() {
    document.getElementById('flashSaleForm').reset();
    document.getElementById('fsId').value = '';
    const title = document.getElementById('modalTitle');
    if (title) title.innerText = window.t ? window.t('admin-flashsales-modal-title', 'Tạo Flash Sale Mới') : 'Tạo Flash Sale Mới';
    document.getElementById('flashSaleModal').classList.add('show');
}

function closeModal() { document.getElementById('flashSaleModal').classList.remove('show'); }

document.getElementById('flashSaleModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});

function editFlashSale(btn) {
    const id = btn.getAttribute('data-id');
    const name = btn.getAttribute('data-name');
    const start = btn.getAttribute('data-start');
    const end = btn.getAttribute('data-end');
    
    document.getElementById('fsId').value = id;
    document.getElementById('fsName').value = name;
    
    // For flatpickr, we might need to set the value directly or through its instance
    const startInput = document.getElementById('fsStart');
    const endInput = document.getElementById('fsEnd');
    
    if (startInput._flatpickr) {
        startInput._flatpickr.setDate(start);
    } else {
        startInput.value = start;
    }
    
    if (endInput._flatpickr) {
        endInput._flatpickr.setDate(end);
    } else {
        endInput.value = end;
    }
    
    const title = document.getElementById('modalTitle');
    if (title) title.innerText = 'Cập Nhật Flash Sale';
    
    document.getElementById('flashSaleModal').classList.add('show');
}
