/* Profile Vouchers Section Logic */

function saveVoucherCode() {
  const code = document.getElementById('input-voucher-code')?.value.trim();
  if (!code) { toast('Vui lòng nhập mã!'); return; }
  fetch('/api/user-voucher/save?code=' + encodeURIComponent(code), {
    method: 'POST',
    headers: { [csrfHeader]: csrfToken }
  })
    .then(res => res.json())
    .then(data => {
      toast(data.message || '✓ Mã voucher đã được lưu.');
      if (data.success) {
        document.getElementById('input-voucher-code').value = '';
        setTimeout(() => location.reload(), 500);
      }
    })
    .catch(err => {
      console.error('Voucher error:', err);
      toast('⚠️ Không thể lưu mã voucher.');
    });
}

window.saveVoucherCode = saveVoucherCode;
