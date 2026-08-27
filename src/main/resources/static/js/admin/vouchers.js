function openModal() {
    document.getElementById('voucherModal').classList.add('active');
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
    document.getElementById('voucherModal').classList.remove('active');
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
    
    window.showConfirm(confirmMsg).then((confirmed) => {
        if (confirmed) {
            performDelete(id);
        }
    });

    function performDelete(id) {
        fetch('/api/voucher/delete/' + id, {
            method: 'POST'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                if (window.showSuccessModal) {
                    window.showSuccessModal('Đã xóa!', data.message || 'Xóa voucher thành công.');
                    setTimeout(() => location.reload(), 1500);
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
