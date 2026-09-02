// State Management for Uploaded Files & URL Links
let uploadedFiles = [];
let urlLinks = [];

function toggleForm() {
    const form = document.getElementById('productForm') || document.querySelector('.add-form-container');
    if (!form) return;
    const isActive = form.classList.toggle('active');
    updateToggleButtonState(isActive);

    if (!isActive) {
        // Reset form to default state
        const formEl = document.getElementById('productFormElement');
        if (formEl) formEl.reset();
        const idInput = document.getElementById('id');
        if (idInput) idInput.value = '';

        // Reset both dropzones
        clearAllUploadedFiles();
        clearAllUrls();

        const h2 = document.querySelector('.card-header h2');
        if (h2) h2.innerText = 'Thêm Sản Phẩm Mới';
    }
}

function updateToggleButtonState(isActive) {
    const btn = document.getElementById('toggleFormBtn');
    if (!btn) return;

    if (isActive) {
        btn.innerHTML = '<i class="fa-solid fa-xmark"></i> <span class="btn-text">Hủy</span>';
        btn.classList.remove('btn-gold');
        btn.classList.add('btn-danger');
    } else {
        btn.innerHTML = '<i class="fa-solid fa-plus"></i> <span class="btn-text">Thêm Sản Phẩm Mới</span>';
        btn.classList.remove('btn-danger');
        btn.classList.add('btn-gold');
    }
}

function initProductFormState() {
    const form = document.getElementById('productForm');
    if (form && form.classList.contains('active')) {
        updateToggleButtonState(true);
    }
    setupDragAndDrop();
    setupLightboxKeyboard();
}

document.addEventListener('DOMContentLoaded', () => {
    initProductFormState();
});

document.addEventListener('spa:load', () => {
    initProductFormState();
});

// ==========================================
// 1. MUTUAL EXCLUSIVITY (CHỌN 1 TRONG 2)
// ==========================================

function updateMutualExclusivityState() {
    const fileDropzone = document.getElementById('fileDropzone');
    const urlDropzone = document.getElementById('urlDropzone');

    if (!fileDropzone || !urlDropzone) return;

    // Xóa overlay cũ nếu có
    const existingFileOverlay = fileDropzone.querySelector('.dropzone-disabled-overlay');
    if (existingFileOverlay) existingFileOverlay.remove();
    const existingUrlOverlay = urlDropzone.querySelector('.dropzone-disabled-overlay');
    if (existingUrlOverlay) existingUrlOverlay.remove();

    if (uploadedFiles.length > 0) {
        // Đang chọn file -> Khóa URL
        fileDropzone.classList.remove('disabled-mode');
        urlDropzone.classList.add('disabled-mode');

        const overlay = document.createElement('div');
        overlay.className = 'dropzone-disabled-overlay';
        overlay.innerHTML = `
            <span>
                <i class="fa-solid fa-lock"></i>
                Đang chọn Tải ảnh từ máy (${uploadedFiles.length} ảnh)
                <button type="button" class="btn-switch-mode" onclick="switchToUrlMode()">
                    <i class="fa-solid fa-arrow-right-arrow-left"></i> Chuyển sang dùng Link URL
                </button>
            </span>
        `;
        urlDropzone.appendChild(overlay);

    } else if (urlLinks.length > 0) {
        // Đang dùng URL -> Khóa File upload
        urlDropzone.classList.remove('disabled-mode');
        fileDropzone.classList.add('disabled-mode');

        const overlay = document.createElement('div');
        overlay.className = 'dropzone-disabled-overlay';
        overlay.innerHTML = `
            <span>
                <i class="fa-solid fa-lock"></i>
                Đang dùng Link URL (${urlLinks.length} link)
                <button type="button" class="btn-switch-mode" onclick="switchToFileMode()">
                    <i class="fa-solid fa-arrow-right-arrow-left"></i> Chuyển sang Tải ảnh từ máy
                </button>
            </span>
        `;
        fileDropzone.appendChild(overlay);

    } else {
        // Cả 2 đều rỗng -> Mở khóa cả 2
        fileDropzone.classList.remove('disabled-mode');
        urlDropzone.classList.remove('disabled-mode');
    }
}

function switchToUrlMode() {
    clearAllUploadedFiles();
    const urlInp = document.getElementById('urlInputText');
    if (urlInp) urlInp.focus();
}

function switchToFileMode() {
    clearAllUrls();
    const fileInp = document.getElementById('multiFileInput');
    if (fileInp) fileInp.click();
}

// ==========================================
// 2. FILE UPLOAD DROPZONE HANDLERS
// ==========================================

function handleFilesSelected(input) {
    if (input.files && input.files.length > 0) {
        // Nếu trước đó đang có URL thì xóa để chuyển sang File
        if (urlLinks.length > 0) {
            clearAllUrls();
        }

        for (let i = 0; i < input.files.length; i++) {
            if (uploadedFiles.length < 4) {
                uploadedFiles.push(input.files[i]);
            }
        }
        renderFilePreviews();
        syncFileInput();
        updateMutualExclusivityState();
    }
}

function renderFilePreviews() {
    const emptyState = document.getElementById('fileEmptyState');
    const filledState = document.getElementById('fileFilledState');
    const grid = document.getElementById('fileCardsGrid');
    const countText = document.getElementById('fileCountText');

    if (!grid) return;

    if (uploadedFiles.length === 0) {
        if (emptyState) emptyState.style.display = 'flex';
        if (filledState) filledState.style.display = 'none';
        return;
    }

    if (emptyState) emptyState.style.display = 'none';
    if (filledState) filledState.style.display = 'flex';
    if (countText) countText.innerText = `Đã chọn ${uploadedFiles.length}/4 ảnh`;

    grid.innerHTML = '';

    uploadedFiles.forEach((file, index) => {
        const card = document.createElement('div');
        card.className = 'preview-slot-card';

        const badgeLabel = index === 0 ? 'Ảnh chính' : `Ảnh phụ ${index}`;
        const badgeClass = index === 0 ? 'badge-main' : 'badge-sub';

        const img = document.createElement('img');
        img.className = 'preview-slot-img';
        img.alt = file.name;
        img.title = 'Bấm vào để xem ảnh phóng to';

        const reader = new FileReader();
        reader.onload = (e) => {
            img.src = e.target.result;
            img.onclick = () => openImageLightbox(e.target.result, badgeLabel);
        };
        reader.readAsDataURL(file);

        card.innerHTML = `
            <button type="button" class="preview-slot-del" onclick="removeUploadedFile(${index})" title="Xóa ảnh này">✕</button>
            <span class="preview-slot-badge ${badgeClass}">${badgeLabel}</span>
        `;
        card.prepend(img);
        grid.appendChild(card);
    });

    // Thêm ô dấu + nếu còn slot (chưa đủ 4 ảnh)
    if (uploadedFiles.length < 4) {
        const addSlot = document.createElement('div');
        addSlot.className = 'preview-slot-add-btn';
        addSlot.onclick = () => document.getElementById('multiFileInput').click();
        addSlot.innerHTML = `
            <i class="fa-solid fa-plus" style="font-size: 14px;"></i>
            <span>Thêm ảnh</span>
        `;
        grid.appendChild(addSlot);
    }
}

function removeUploadedFile(index) {
    uploadedFiles.splice(index, 1);
    renderFilePreviews();
    syncFileInput();
    updateMutualExclusivityState();
}

function clearAllUploadedFiles() {
    uploadedFiles = [];
    const input = document.getElementById('multiFileInput');
    if (input) input.value = '';
    renderFilePreviews();
    syncFileInput();
    updateMutualExclusivityState();
}

function syncFileInput() {
    const input = document.getElementById('multiFileInput');
    if (!input) return;
    try {
        const dt = new DataTransfer();
        uploadedFiles.forEach(f => dt.items.add(f));
        input.files = dt.files;
    } catch (e) {
        console.warn('DataTransfer not fully supported:', e);
    }
}

function setupDragAndDrop() {
    const dropzone = document.getElementById('fileDropzone');
    if (!dropzone) return;

    ['dragenter', 'dragover'].forEach(eventName => {
        dropzone.addEventListener(eventName, (e) => {
            e.preventDefault();
            e.stopPropagation();
            if (!dropzone.classList.contains('disabled-mode')) {
                dropzone.style.borderColor = '#3b82f6';
                dropzone.style.background = '#f0f7ff';
            }
        }, false);
    });

    ['dragleave', 'drop'].forEach(eventName => {
        dropzone.addEventListener(eventName, (e) => {
            e.preventDefault();
            e.stopPropagation();
            dropzone.style.borderColor = '';
            dropzone.style.background = '';
        }, false);
    });

    dropzone.addEventListener('drop', (e) => {
        if (dropzone.classList.contains('disabled-mode')) return;
        const dt = e.dataTransfer;
        if (dt && dt.files && dt.files.length > 0) {
            if (urlLinks.length > 0) clearAllUrls();
            for (let i = 0; i < dt.files.length; i++) {
                if (uploadedFiles.length < 4 && dt.files[i].type.startsWith('image/')) {
                    uploadedFiles.push(dt.files[i]);
                }
            }
            renderFilePreviews();
            syncFileInput();
            updateMutualExclusivityState();
        }
    }, false);
}

// ==========================================
// 3. URL LINK DROPZONE HANDLERS
// ==========================================

function addUrlFromInput() {
    const input = document.getElementById('urlInputText');
    if (!input) return;
    const url = input.value.trim();

    if (!url) {
        input.focus();
        return;
    }

    if (urlLinks.length >= 4) {
        alert('Bạn chỉ có thể thêm tối đa 4 link ảnh!');
        return;
    }

    // Nếu trước đó đang có File thì xóa để chuyển sang URL
    if (uploadedFiles.length > 0) {
        clearAllUploadedFiles();
    }

    urlLinks.push(url);
    input.value = '';
    renderUrlPreviews();
    syncUrlInputs();
    updateMutualExclusivityState();
}

function renderUrlPreviews() {
    const emptyState = document.getElementById('urlEmptyState');
    const filledState = document.getElementById('urlFilledState');
    const grid = document.getElementById('urlCardsGrid');
    const countText = document.getElementById('urlCountText');

    if (!grid) return;

    if (urlLinks.length === 0) {
        if (emptyState) emptyState.style.display = 'flex';
        if (filledState) filledState.style.display = 'none';
        return;
    }

    if (emptyState) emptyState.style.display = 'none';
    if (filledState) filledState.style.display = 'flex';
    if (countText) countText.innerText = `Đã thêm ${urlLinks.length}/4 link ảnh`;

    grid.innerHTML = '';

    urlLinks.forEach((url, index) => {
        const card = document.createElement('div');
        card.className = 'preview-slot-card';

        const badgeLabel = index === 0 ? 'Ảnh chính' : `Ảnh phụ ${index}`;
        const badgeClass = index === 0 ? 'badge-main' : 'badge-sub';

        const imgSrc = (url.startsWith('http') || url.startsWith('/')) ? url : '/images/products/' + url;

        card.innerHTML = `
            <img class="preview-slot-img" src="${imgSrc}" alt="${url}" title="Bấm vào để xem ảnh phóng to" onclick="openImageLightbox('${imgSrc}', '${badgeLabel}')" onerror="this.onerror=null; this.src='https://placehold.co/80x80/f1f5f9/94a3b8?text=Error';">
            <button type="button" class="preview-slot-del" onclick="removeUrlLink(${index})" title="Xóa link này">✕</button>
            <span class="preview-slot-badge ${badgeClass}">${badgeLabel}</span>
        `;
        grid.appendChild(card);
    });

    // Thêm ô dấu + nếu còn slot
    if (urlLinks.length < 4) {
        const addSlot = document.createElement('div');
        addSlot.className = 'preview-slot-add-btn';
        addSlot.onclick = () => document.getElementById('urlInputText').focus();
        addSlot.innerHTML = `
            <i class="fa-solid fa-plus" style="font-size: 14px;"></i>
            <span>Thêm URL</span>
        `;
        grid.appendChild(addSlot);
    }
}

function removeUrlLink(index) {
    urlLinks.splice(index, 1);
    renderUrlPreviews();
    syncUrlInputs();
    updateMutualExclusivityState();
}

function clearAllUrls() {
    urlLinks = [];
    const input = document.getElementById('urlInputText');
    if (input) input.value = '';
    renderUrlPreviews();
    syncUrlInputs();
    updateMutualExclusivityState();
}

function syncUrlInputs() {
    const mainInput = document.getElementById('mainImageUrlInput');
    const extra1 = document.getElementById('extraUrl1Input');
    const extra2 = document.getElementById('extraUrl2Input');
    const extra3 = document.getElementById('extraUrl3Input');

    if (mainInput) mainInput.value = urlLinks[0] || '';
    if (extra1) extra1.value = urlLinks[1] || '';
    if (extra2) extra2.value = urlLinks[2] || '';
    if (extra3) extra3.value = urlLinks[3] || '';
}

// ==========================================
// 4. LIGHTBOX MODAL (XEM ẢNH PHÓNG TO)
// ==========================================

function openImageLightbox(src, label) {
    const modal = document.getElementById('imageLightboxModal');
    const img = document.getElementById('lightboxImg');
    const badge = document.getElementById('lightboxBadge');

    if (!modal || !img) return;

    img.src = src;
    if (badge) {
        badge.innerText = label || 'Ảnh sản phẩm';
        badge.className = 'preview-slot-badge ' + (label === 'Ảnh chính' ? 'badge-main' : 'badge-sub');
    }

    modal.classList.add('active');
    document.body.style.overflow = 'hidden'; // Khóa cuộn trang khi xem ảnh
}

function closeImageLightbox(event) {
    if (event && event.target && event.target.closest('.image-lightbox-content') && !event.target.closest('.image-lightbox-close')) {
        return;
    }
    const modal = document.getElementById('imageLightboxModal');
    if (modal) {
        modal.classList.remove('active');
        document.body.style.overflow = '';
    }
}

function setupLightboxKeyboard() {
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            closeImageLightbox();
        }
    });
}

// ==========================================
// 5. EDIT PRODUCT DATA BINDING
// ==========================================

function editProduct(btn) {
    const id = btn.getAttribute('data-id');
    const name = btn.getAttribute('data-name');
    const price = btn.getAttribute('data-price');
    const cat = btn.getAttribute('data-cat');
    const brand = btn.getAttribute('data-brand');
    const desc = btn.getAttribute('data-desc');
    const stock = btn.getAttribute('data-stock');
    const image = btn.getAttribute('data-image');
    const subImagesStr = btn.getAttribute('data-subimages');

    const idInput = document.getElementById('id');
    if (idInput) idInput.value = id || '';

    const nameInput = document.getElementById('name');
    if (nameInput) nameInput.value = name || '';

    const priceInput = document.getElementById('price');
    if (priceInput) priceInput.value = price || '';

    const catSelect = document.querySelector('select[name="category.id"]') || document.getElementById('category.id');
    if (catSelect) catSelect.value = cat || '';

    const brandInput = document.getElementById('brand');
    if (brandInput) brandInput.value = brand || '';

    const descEl = document.getElementById('description');
    if (descEl) descEl.value = desc || '';

    const stockInput = document.getElementById('stock');
    if (stockInput) stockInput.value = stock || '0';

    // Reset uploaded files state
    clearAllUploadedFiles();

    // Populate URL links with existing images
    urlLinks = [];
    if (image && image.trim() !== '') {
        urlLinks.push(image.trim());
    }
    if (subImagesStr && subImagesStr.trim() !== '') {
        const subImages = subImagesStr.split(',');
        subImages.forEach(sub => {
            if (sub && sub.trim() !== '' && urlLinks.length < 4) {
                urlLinks.push(sub.trim());
            }
        });
    }
    renderUrlPreviews();
    syncUrlInputs();
    updateMutualExclusivityState();

    // Update form header
    const h2 = document.querySelector('.card-header h2');
    if (h2) h2.innerText = 'Cập Nhật Sản Phẩm';

    // Show form
    const form = document.getElementById('productForm');
    if (form && !form.classList.contains('active')) {
        form.classList.add('active');
        updateToggleButtonState(true);
    }

    // Smooth scroll to top
    window.scrollTo({ top: 0, behavior: 'smooth' });
}
