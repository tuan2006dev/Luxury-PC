function openModal() {
    document.getElementById('flashSaleForm').reset();
    document.getElementById('fsId').value = '';
    const bannerInput = document.getElementById('fsBannerUrl');
    if (bannerInput) bannerInput.value = '';
    const fileInput = document.getElementById('fsBannerFile');
    if (fileInput) fileInput.value = '';
    const preview = document.getElementById('bannerPreviewImg');
    if (preview) preview.src = '/images/placeholder.png';
    const title = document.getElementById('modalTitle');
    if (title) title.innerText = window.t ? 'Tạo Flash Sale Mới' : 'Tạo Flash Sale Mới';
    
    const urlGroup = document.getElementById('urlInputGroup');
    const toggleLink = urlGroup ? urlGroup.nextElementSibling : null;
    if (urlGroup) urlGroup.style.display = 'none';
    if (toggleLink) toggleLink.innerText = '+ Dùng link ảnh';
    
    document.getElementById('flashSaleModal').classList.add('active');
}

function closeModal() { document.getElementById('flashSaleModal').classList.remove('active'); }

document.getElementById('flashSaleModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});

function previewBannerUrl(url) {
    const preview = document.getElementById('bannerPreviewImg');
    if (!preview) return;
    if (url && url.trim().length > 0) {
        if(url.startsWith('http')) {
            preview.src = url;
        } else {
            preview.src = '/images/flashsale/' + url;
        }
    } else {
        preview.src = '/images/placeholder.png';
    }
}

function previewBannerFile(input) {
    const preview = document.getElementById('bannerPreviewImg');
    if (!preview || !input.files || !input.files[0]) return;
    const reader = new FileReader();
    reader.onload = function(e) {
        preview.src = e.target.result;
    };
    reader.readAsDataURL(input.files[0]);
}

function editFlashSale(btn) {
    const id = btn.getAttribute('data-id');
    const name = btn.getAttribute('data-name');
    const start = btn.getAttribute('data-start');
    const end = btn.getAttribute('data-end');
    const banner = btn.getAttribute('data-banner') || '';
    
    const description = btn.getAttribute('data-description') || '';
    const maxPerUser = btn.getAttribute('data-max-per-user') || '';
    
    document.getElementById('fsId').value = id;
    document.getElementById('fsName').value = name;
    const descEl = document.getElementById('fsDescription');
    if (descEl) descEl.value = description;
    const maxEl = document.getElementById('fsMaxPerUser');
    if (maxEl) maxEl.value = maxPerUser;
    
    const bannerInput = document.getElementById('fsBannerUrl');
    const urlGroup = document.getElementById('urlInputGroup');
    const toggleLink = urlGroup ? urlGroup.nextElementSibling : null;
    
    if (bannerInput) {
        bannerInput.value = banner;
        if (banner && banner.startsWith('http')) {
            if (urlGroup) urlGroup.style.display = 'flex';
            if (toggleLink) toggleLink.innerText = '- Ẩn link ảnh';
        } else {
            if (urlGroup) urlGroup.style.display = 'none';
            if (toggleLink) toggleLink.innerText = '+ Dùng link ảnh';
        }
    }
    previewBannerUrl(banner);
    
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
    
    document.getElementById('flashSaleModal').classList.add('active');
}

function deleteFlashSaleApi(id) {
    const confirmMsg = 'Xóa chương trình Flash Sale này?';
    window.showConfirm(confirmMsg).then((confirmed) => {
        if (confirmed) {
            performDelete(id);
        }
    });

    function performDelete(id) {
        fetch('/api/flash-sales/delete/' + id, {
            method: 'POST'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                if (window.showSuccessModal) {
                    window.showSuccessModal('Đã xóa!', data.message || 'Xóa chương trình thành công.');
                    setTimeout(() => location.reload(), 1500);
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

// Admin Countdown logic
document.addEventListener('DOMContentLoaded', function() {
    const countdowns = document.querySelectorAll('.admin-countdown');
    if (countdowns.length > 0) {
        setInterval(() => {
            const now = new Date().getTime();
            countdowns.forEach(el => {
                const start = parseInt(el.getAttribute('data-start'));
                const end = parseInt(el.getAttribute('data-end'));
                
                if (start === 0 || end === 0) {
                    el.innerText = '--';
                    return;
                }
                
                if (now < start) {
                    const dist = start - now;
                    el.style.color = '#60a5fa'; // blue
                    el.innerText = 'Bắt đầu sau: ' + formatDistance(dist);
                } else if (now >= start && now <= end) {
                    const dist = end - now;
                    el.style.color = '#4ade80'; // green
                    el.innerText = 'Kết thúc trong: ' + formatDistance(dist);
                } else {
                    el.style.color = '#f87171'; // red
                    el.innerText = 'Đã kết thúc';
                }
            });
        }, 1000);
    }
    
    function formatDistance(dist) {
        const days = Math.floor(dist / (1000 * 60 * 60 * 24));
        const hours = Math.floor((dist % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((dist % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((dist % (1000 * 60)) / 1000);
        
        let str = '';
        if (days > 0) str += days + 'n ';
        str += (hours < 10 ? '0'+hours : hours) + ':';
        str += (minutes < 10 ? '0'+minutes : minutes) + ':';
        str += (seconds < 10 ? '0'+seconds : seconds);
        return str;
    }
});
