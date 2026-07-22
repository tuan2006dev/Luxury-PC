/* ======================================================
   LUXURY PC - Profile Vouchers Tab Script (vouchers.js)
   ====================================================== */

function saveVoucherCode() {
    const input = document.getElementById('input-voucher-code');
    const code = input ? input.value.trim() : '';
    if (!code) {
        toast('Vui lòng nhập mã voucher!');
        if (input) input.focus();
        return;
    }

    fetch('/api/user-voucher/save?code=' + encodeURIComponent(code), {
        method: 'POST',
        headers: { [getCsrfHeader()]: getCsrfToken() }
    })
    .then(res => res.json())
    .then(data => {
        toast(data.message || '✓ Mã voucher đã được lưu.');
        if (data.success) {
            if (input) input.value = '';
            setTimeout(() => location.reload(), 500);
        }
    })
    .catch(err => {
        console.error('Voucher error:', err);
        toast('⚠️ Không thể lưu mã voucher.');
    });
}
