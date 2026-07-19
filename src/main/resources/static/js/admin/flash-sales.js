function openModal() {
    document.getElementById('flashSaleForm').reset();
    document.getElementById('fsId').value = '';
    const title = document.getElementById('modalTitle');
    if (title) title.innerText = window.t ? 'Tạo Flash Sale Mới' : 'Tạo Flash Sale Mới';
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

function deleteFlashSaleApi(id) {
    const confirmMsg = window.t ? 'Xóa chương trình Flash Sale này?' : 'Xóa chương trình Flash Sale này?';
    
    if (typeof Swal !== 'undefined') {
        Swal.fire({
            title: confirmMsg,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'OK',
            cancelButtonText: 'Cancel',
            background: '#1a1a1a',
            color: '#f5f0e8',
            confirmButtonColor: '#ef4444',
            cancelButtonColor: '#c9a84c'
        }).then((result) => {
            if (result.isConfirmed) {
                performDelete(id);
            }
        });
    } else {
        if (confirm(confirmMsg)) {
            performDelete(id);
        }
    }

    function performDelete(id) {
        fetch('/api/flash-sales/delete/' + id, {
            method: 'POST'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        title: 'Đã xóa!',
                        text: data.message || 'Xóa chương trình thành công.',
                        icon: 'success',
                        background: '#1a1a1a',
                        color: '#f5f0e8',
                        confirmButtonColor: '#c9a84c'
                    }).then(() => {
                        location.reload();
                    });
                } else {
                    alert(data.message || 'Xóa chương trình thành công.');
                    location.reload();
                }
            } else {
                alert(data.message || 'Có lỗi xảy ra.');
            }
        })
        .catch(err => {
            console.error(err);
            alert('Lỗi kết nối server.');
        });
    }
}
