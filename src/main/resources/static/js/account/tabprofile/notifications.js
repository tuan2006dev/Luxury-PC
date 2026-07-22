/* ======================================================
   LUXURY PC - Profile Notifications Tab Script (notifications.js)
   ====================================================== */

function updateNotifSetting(type, isEnabled) {
    fetch('/api/profile/notifications', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            [getCsrfHeader()]: getCsrfToken()
        },
        body: JSON.stringify({ type, isEnabled })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            toast('✓ Đã cập nhật cài đặt thông báo.');
        } else {
            toast('⚠️ ' + (data.message || 'Lỗi khi cập nhật cài đặt thông báo.'));
        }
    })
    .catch(err => {
        console.error('Update notification setting error:', err);
        toast('⚠️ Không thể kết nối đến máy chủ.');
    });
}
