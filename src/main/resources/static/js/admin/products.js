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
        const imgWrapper = document.getElementById('currentImageWrapper');
        if (imgWrapper) imgWrapper.style.display = 'none';
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
}

document.addEventListener('DOMContentLoaded', () => {
    initProductFormState();
});

document.addEventListener('spa:load', () => {
    initProductFormState();
});

function editProduct(btn) {
    const id = btn.getAttribute('data-id');
    const name = btn.getAttribute('data-name');
    const price = btn.getAttribute('data-price');
    const cat = btn.getAttribute('data-cat');
    const brand = btn.getAttribute('data-brand');
    const desc = btn.getAttribute('data-desc');
    const stock = btn.getAttribute('data-stock');
    const image = btn.getAttribute('data-image');

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

    const imageInput = document.getElementById('image');
    if (imageInput) imageInput.value = image || '';

    const imageUrlInput = document.getElementById('imageUrl');
    if (imageUrlInput) imageUrlInput.value = image || '';

    // Update Image Preview
    const imgWrapper = document.getElementById('currentImageWrapper');
    const imgPreview = document.getElementById('currentImagePreview');
    const imgName = document.getElementById('currentImageName');
    if (imgWrapper && imgPreview) {
        if (image && image.trim() !== '') {
            const imgSrc = (image.startsWith('http') || image.startsWith('/')) ? image : '/images/products/' + image;
            imgPreview.src = imgSrc;
            if (imgName) imgName.innerText = image;
            imgWrapper.style.display = '';
        } else {
            imgWrapper.style.display = 'none';
        }
    }

    // Reset file upload label
    const fileNameSpan = document.querySelector('#productForm .file-name');
    if (fileNameSpan) fileNameSpan.innerText = 'Chọn ảnh tải lên...';

    const fileLabel = document.querySelector('#productForm .file-upload-label');
    if (fileLabel) fileLabel.classList.remove('has-file');

    const fileInput = document.querySelector('#productForm input[type="file"]');
    if (fileInput) fileInput.value = '';

    // Update header
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
