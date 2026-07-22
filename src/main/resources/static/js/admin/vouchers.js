function openModal() {
    document.getElementById('voucherModal').classList.add('show');
    document.getElementById('voucherId').value = '';
    document.getElementById('voucherCode').value = '';
    document.getElementById('voucherDesc').value = '';
    document.getElementById('discountType').value = 'PERCENTAGE';
    document.getElementById('discountValue').value = '';
    document.getElementById('maxDiscountAmount').value = '';
    document.getElementById('minOrderAmount').value = '';
    document.getElementById('usageLimit').value = '';
    document.getElementById('endDate').value = '';
    document.getElementById('voucherScope').value = 'GLOBAL';
    document.getElementById('categoryId').value = '';
    toggleMaxDiscount();
    toggleCategorySelect();
}
function closeModal() {
    document.getElementById('voucherModal').classList.remove('show');
}
function toggleCategorySelect() {
    var scope = document.getElementById('voucherScope').value;
    document.getElementById('categoryGroup').style.display = scope === 'CATEGORY' ? 'block' : 'none';
}
function toggleMaxDiscount() {
    var type = document.getElementById('discountType').value;
    document.getElementById('maxDiscountGroup').style.display = type === 'PERCENTAGE' ? 'flex' : 'none';
    
    var discountValueInput = document.getElementById('discountValue');
    if (type === 'PERCENTAGE') {
        discountValueInput.max = "100";
        var val = parseFloat(discountValueInput.value);
        if (val > 100) {
            discountValueInput.value = 100;
        }
    } else {
        discountValueInput.removeAttribute('max');
    }
}
// Close modal on overlay click
document.getElementById('voucherModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});

// Real-time validation for discount value
document.getElementById('discountValue').addEventListener('input', function() {
    var type = document.getElementById('discountType').value;
    if (type === 'PERCENTAGE') {
        var val = parseFloat(this.value);
        if (val > 100) {
            this.value = 100;
        }
    }
});

function deleteVoucherApi(id) {
    const confirmMsg = 'Xóa voucher này?';
    
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
        fetch('/api/voucher/delete/' + id, {
            method: 'POST'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        title: 'Đã xóa!',
                        text: data.message || 'Xóa voucher thành công.',
                        icon: 'success',
                        background: '#1a1a1a',
                        color: '#f5f0e8',
                        confirmButtonColor: '#c9a84c'
                    }).then(() => {
                        location.reload();
                    });
                } else {
                    alert(data.message || 'Xóa voucher thành công.');
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
