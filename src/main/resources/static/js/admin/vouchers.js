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
    document.getElementById('categoryId').value = '';
    toggleMaxDiscount();
}
function closeModal() {
    document.getElementById('voucherModal').classList.remove('show');
}
function toggleMaxDiscount() {
    var type = document.getElementById('discountType').value;
    document.getElementById('maxDiscountGroup').style.display = type === 'PERCENTAGE' ? 'flex' : 'none';
    
    var discountValueInput = document.getElementById('discountValue');
    if (type === 'PERCENTAGE') {
        discountValueInput.max = "100";
    } else {
        discountValueInput.removeAttribute('max');
    }
}
// Close modal on overlay click
document.getElementById('voucherModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});
