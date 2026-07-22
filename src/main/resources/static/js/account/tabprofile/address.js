/* ======================================================
   LUXURY PC - Profile Address Tab Script (address.js)
   ====================================================== */

let addressCount = 0;

async function loadAddresses() {
    try {
        const res = await fetch('/api/address');
        const data = await res.json();
        const container = document.getElementById('address-list-container');
        if (!container) return;
        if (!data.success || !data.data || data.data.length === 0) {
            addressCount = 0;
            container.innerHTML = `<p style="grid-column:span 2;text-align:center;color:#64748b;padding:2rem;">Bạn chưa thêm địa chỉ nào. Hãy thêm địa chỉ mới.</p>`;
            return;
        }
        addressCount = data.data.length;
        container.innerHTML = data.data.map(addr => `
            <div style="background:#f8fafc;border:1px solid ${addr.isDefault ? '#3b82f6' : '#e2e8f0'};padding:1.5rem;border-radius:8px;">
                <div style="font-size:.75rem;font-weight:600;text-transform:uppercase;color:${addr.isDefault ? '#3b82f6' : '#64748b'};margin-bottom:.8rem;">
                    ${addr.isDefault ? '📍 Địa chỉ mặc định' : '📍 Địa chỉ khác'}
                </div>
                <div style="font-size:.9rem;color:#000;margin-bottom:.3rem;font-weight:600;">${addr.recipientName}</div>
                <div style="font-size:.8rem;color:#64748b;line-height:1.7;">
                    ${addr.detailedAddress}<br>${addr.district}, ${addr.city}<br>📞 ${addr.phone}
                </div>
                <div style="display:flex;gap:.5rem;margin-top:1rem;">
                    <button class="btn-sec" onclick="editAddress(${addr.id})">Sửa</button>
                    <button class="btn-sec" onclick="deleteAddress(${addr.id})">Xóa</button>
                    ${!addr.isDefault ? `<button class="btn-sec" style="border-color:#3b82f6;color:#3b82f6;" onclick="setDefaultAddress(${addr.id})">Đặt mặc định</button>` : ''}
                </div>
            </div>
        `).join('');
    } catch (err) {
        console.error('Load addresses error:', err);
        toast('Không thể tải danh sách địa chỉ.');
    }
}

function setDefaultAddress(id) {
    fetch('/api/address/' + id + '/default', {
        method: 'PUT',
        headers: { [getCsrfHeader()]: getCsrfToken() }
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            toast('✓ Đã thay đổi địa chỉ mặc định.');
            loadAddresses();
        } else {
            toast('⚠️ ' + (data.message || 'Lỗi khi thiết lập địa chỉ mặc định.'));
        }
    })
    .catch(err => {
        console.error('Set default address error:', err);
        toast('⚠️ Không thể kết nối đến máy chủ.');
    });
}

function openAddressForm() {
    if (addressCount >= 5) {
        toast('⚠️ Bạn chỉ được lưu tối đa 5 địa chỉ giao hàng.');
        return;
    }
    document.getElementById('address-id-edit').value = '';
    document.getElementById('address-name').value = '';
    document.getElementById('address-phone').value = '';
    document.getElementById('address-detail').value = '';
    document.getElementById('address-city').value = '';
    document.getElementById('address-district').value = '';
    document.getElementById('address-postal').value = '';

    const formContainer = document.getElementById('address-form-container');
    const listContainer = document.getElementById('address-list-container');
    if (formContainer && listContainer) {
        listContainer.parentNode.insertBefore(formContainer, listContainer);
        formContainer.style.marginBottom = '2rem';
        formContainer.style.marginTop = '0';
    }

    const titleEl = document.getElementById('address-form-title');
    if (titleEl) titleEl.textContent = 'Thêm Địa Chỉ Mới';
    document.getElementById('address-form-container').style.display = 'block';
}

function closeAddressForm() {
    const form = document.getElementById('address-form-container');
    if (form) form.style.display = 'none';
}

function editAddress(id) {
    fetch('/api/address/' + id)
    .then(res => res.json())
    .then(data => {
        if (data.success && data.data) {
            const addr = data.data;
            document.getElementById('address-id-edit').value = addr.id || '';
            document.getElementById('address-name').value = addr.recipientName || '';
            document.getElementById('address-phone').value = addr.phone || '';
            document.getElementById('address-detail').value = addr.detailedAddress || '';
            document.getElementById('address-city').value = addr.city || '';
            document.getElementById('address-district').value = addr.district || '';
            document.getElementById('address-postal').value = addr.postalCode || '';

            const formContainer = document.getElementById('address-form-container');
            const listContainer = document.getElementById('address-list-container');
            if (formContainer && listContainer) {
                listContainer.parentNode.insertBefore(formContainer, listContainer.nextSibling);
                formContainer.style.marginBottom = '0';
                formContainer.style.marginTop = '2rem';
            }

            const titleEl = document.getElementById('address-form-title');
            if (titleEl) titleEl.textContent = 'Chỉnh Sửa Địa Chỉ';
            document.getElementById('address-form-container').style.display = 'block';
        }
    })
    .catch(err => {
        console.error('Edit address error:', err);
        toast('Không thể tải địa chỉ.');
    });
}

function saveAddress() {
    const id = document.getElementById('address-id-edit').value;
    const name = document.getElementById('address-name').value.trim();
    const phone = document.getElementById('address-phone').value.trim();
    const detail = document.getElementById('address-detail').value.trim();
    const city = document.getElementById('address-city').value.trim();
    const district = document.getElementById('address-district').value.trim();
    const postal = document.getElementById('address-postal').value.trim();

    if (!name) { toast('Vui lòng nhập tên người nhận.'); return; }
    if (!phone) { toast('Vui lòng nhập số điện thoại.'); return; }
    const phoneRegex = /^0(3|5|7|8|9)[0-9]{8}$/;
    if (!phoneRegex.test(phone)) {
        toast('Số điện thoại không hợp lệ. Vui lòng nhập đúng 10 chữ số (đầu số 03, 05, 07, 08, 09).');
        return;
    }
    if (!detail) { toast('Vui lòng nhập địa chỉ chi tiết.'); return; }
    if (!district) { toast('Vui lòng nhập quận/huyện.'); return; }
    if (!city) { toast('Vui lòng nhập tỉnh/thành phố.'); return; }

    const payload = { recipientName: name, phone, detailedAddress: detail, city, district, postalCode: postal };
    const method = id ? 'PUT' : 'POST';
    const url = id ? '/api/address/' + id : '/api/address';

    fetch(url, {
        method,
        headers: { 'Content-Type': 'application/json', [getCsrfHeader()]: getCsrfToken() },
        body: JSON.stringify(payload)
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            toast(id ? '✓ Đã cập nhật địa chỉ.' : '✓ Đã thêm địa chỉ mới.');
            closeAddressForm();
            loadAddresses();
        } else {
            toast('⚠️ ' + (data.message || 'Lỗi khi lưu địa chỉ.'));
        }
    })
    .catch(err => {
        console.error('Save address error:', err);
        toast('Không thể lưu địa chỉ.');
    });
}

function deleteAddress(id) {
    showConfirm('Bạn chắc chắn muốn xóa địa chỉ này?').then(confirmed => {
        if (!confirmed) return;
        fetch('/api/address/' + id, {
            method: 'DELETE',
            headers: { [getCsrfHeader()]: getCsrfToken() }
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                toast('✓ Đã xóa địa chỉ.');
                loadAddresses();
            } else {
                toast('⚠️ ' + (data.message || 'Lỗi khi xóa địa chỉ.'));
            }
        })
        .catch(err => {
            console.error('Delete address error:', err);
            toast('Không thể xóa địa chỉ.');
        });
    });
}
