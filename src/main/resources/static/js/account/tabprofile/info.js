/* ======================================================
   LUXURY PC - Profile Info Tab Script (info.js)
   ====================================================== */

function toggleProfileEditForm(show) {
    const panel = document.getElementById('profile-edit-panel');
    const toggleBtn = document.getElementById('profile-edit-toggle');
    if (!panel) return;

    const isVisible = show !== undefined ? show : panel.style.display === 'none';
    panel.style.display = isVisible ? 'block' : 'none';
    if (toggleBtn) {
        toggleBtn.textContent = isVisible ? 'Đóng' : 'Chỉnh Sửa';
        toggleBtn.setAttribute('aria-expanded', isVisible ? 'true' : 'false');
    }
}
