/* Profile Addresses Section Logic */

let addressCount = 0;

async function loadAddresses() {
  try {
    const res = await fetch('/api/address');
    const data = await res.json();
    const container = document.getElementById('address-list-container');
    if (!container) return;
    if (!data.success || !data.data || data.data.length === 0) {
      addressCount = 0;
      container.innerHTML = `<p class="address-empty">${window.t('profile-address-empty', 'Bạn chưa thêm địa chỉ nào. Hãy thêm địa chỉ mới.')}</p>`;
      return;
    }
    addressCount = data.data.length;
    container.innerHTML = '';

    const template = document.getElementById('address-card-template');
    data.data.forEach(addr => {
      if (!template) return;
      const card = template.content.cloneNode(true).firstElementChild;
      if (addr.isDefault) card.classList.add('default');

      const badge = card.querySelector('.address-badge');
      if (badge) {
        if (addr.isDefault) badge.classList.add('default');
        badge.textContent = addr.isDefault ? window.t('profile-address-default', '📍 Địa chỉ mặc định') : window.t('profile-address-other', '📍 Địa chỉ khác');
      }

      const recipient = card.querySelector('.address-recipient');
      if (recipient) recipient.textContent = addr.recipientName;

      const detail = card.querySelector('.addr-detail');
      if (detail) detail.textContent = addr.detailedAddress;

      const location = card.querySelector('.addr-location');
      if (location) location.textContent = (addr.district ? addr.district + ', ' : '') + addr.city;

      const phone = card.querySelector('.addr-phone');
      if (phone) phone.textContent = addr.phone;

      const btnEdit = card.querySelector('.btn-edit-action');
      if (btnEdit) {
        btnEdit.textContent = window.t('profile-address-btn-edit', 'Sửa');
        btnEdit.onclick = () => editAddress(addr.id);
      }

      const btnDelete = card.querySelector('.btn-delete-action');
      if (btnDelete) {
        btnDelete.textContent = window.t('profile-address-btn-delete', 'Xóa');
        btnDelete.onclick = () => deleteAddress(addr.id);
      }

      const btnDefault = card.querySelector('.btn-default-action');
      if (btnDefault) {
        if (!addr.isDefault) {
          btnDefault.textContent = window.t('profile-address-set-default', 'Đặt mặc định');
          btnDefault.onclick = () => setDefaultAddress(addr.id);
        } else {
          btnDefault.remove();
        }
      }

      container.appendChild(card);
    });
  } catch (err) {
    console.error('Load addresses error:', err);
    toast('Không thể tải danh sách địa chỉ.');
  }
}

window.loadAddresses = loadAddresses;
window.setDefaultAddress = setDefaultAddress;
window.openAddressForm = openAddressForm;
window.closeAddressForm = closeAddressForm;
window.editAddress = editAddress;
window.getProfileLocation = getProfileLocation;
window.saveAddress = saveAddress;
window.deleteAddress = deleteAddress;

function setDefaultAddress(id) {
  fetch('/api/address/' + id + '/default', {
    method: 'PUT',
    headers: { [csrfHeader]: csrfToken }
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

function clearAddressErrors() {
  ['address-name', 'address-phone', 'address-detail', 'address-city', 'address-district'].forEach(id => {
    const input = document.getElementById(id);
    const errDiv = document.getElementById(id + '-error');
    if (input) {
      input.style.borderColor = '';
    }
    if (errDiv) {
      errDiv.style.display = 'none';
      errDiv.textContent = '';
    }
  });
}

function showAddressFieldError(fieldId, message) {
  const input = document.getElementById(fieldId);
  const errDiv = document.getElementById(fieldId + '-error');
  if (input) {
    input.style.borderColor = '#ef4444';
  }
  if (errDiv) {
    errDiv.textContent = message;
    errDiv.style.display = 'block';
  }
}

function openAddressForm() {
  if (addressCount >= 5) {
    toast('⚠️ Bạn chỉ được lưu tối đa 5 địa chỉ giao hàng.');
    return;
  }
  clearAddressErrors();
  if (document.getElementById('address-id-edit')) document.getElementById('address-id-edit').value = '';
  if (document.getElementById('address-name')) document.getElementById('address-name').value = '';
  if (document.getElementById('address-phone')) document.getElementById('address-phone').value = '';
  if (document.getElementById('address-detail')) document.getElementById('address-detail').value = '';
  if (document.getElementById('address-city')) document.getElementById('address-city').value = '';
  if (document.getElementById('address-district')) document.getElementById('address-district').value = '';

  const formContainer = document.getElementById('address-form-container');
  const listContainer = document.getElementById('address-list-container');
  if (formContainer && listContainer) {
    listContainer.parentNode.insertBefore(formContainer, listContainer);
    formContainer.style.marginBottom = '2rem';
    formContainer.style.marginTop = '0';
  }

  const titleEl = document.getElementById('address-form-title');
  if (titleEl) {
    titleEl.textContent = 'Thêm Địa Chỉ Mới';
  }

  if (formContainer) {
    formContainer.style.display = 'block';
    document.getElementById('address-name')?.focus();
  }
}

function closeAddressForm() {
  clearAddressErrors();
  const container = document.getElementById('address-form-container');
  if (container) {
    container.style.display = 'none';
  }
}

function editAddress(id) {
  clearAddressErrors();
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

        const formContainer = document.getElementById('address-form-container');
        const listContainer = document.getElementById('address-list-container');
        if (formContainer && listContainer) {
          listContainer.parentNode.insertBefore(formContainer, listContainer.nextSibling);
          formContainer.style.marginBottom = '0';
          formContainer.style.marginTop = '2rem';
        }

        const titleEl = document.getElementById('address-form-title');
        if (titleEl) {
          titleEl.textContent = 'Chỉnh Sửa Địa Chỉ';
        }

        document.getElementById('address-form-container').style.display = 'block';
      }
    })
    .catch(err => {
      console.error('Edit address error:', err);
      toast('Không thể tải địa chỉ.');
    });
}

async function getProfileLocation() {
  const btn = document.getElementById('btn-profile-gps');
  const textSpan = document.getElementById('btn-profile-gps-text');
  if (!btn || !textSpan) return;

  btn.disabled = true;
  textSpan.textContent = 'Đang định vị...';

  try {
    const pos = await new Promise((resolve, reject) => {
      navigator.geolocation.getCurrentPosition(resolve, reject, {
        enableHighAccuracy: true, timeout: 10000, maximumAge: 0
      });
    });

    const lat = pos.coords.latitude;
    const lon = pos.coords.longitude;

    const nomRes = await fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lon}&format=json&accept-language=vi`);
    const nomData = await nomRes.json();

    if (nomData && nomData.address) {
      const addr = nomData.address;

      // 1. Tỉnh / Thành phố (Ưu tiên province/state hoặc thành phố lớn)
      const candidatesCity = [addr.province, addr.state, addr.city, addr.region].filter(Boolean);
      let city = candidatesCity.find(c => /tỉnh|thành phố|tp\.|hồ chí minh|hà nội|đà nẵng|hải phòng|cần thơ/i.test(c));
      if (!city && candidatesCity.length > 0) {
        city = candidatesCity[candidatesCity.length - 1];
      }
      city = city || addr.province || addr.state || addr.city || '';

      // 2. Quận / Huyện (Khác Tỉnh/Thành phố, ưu tiên district/county/town/city_district)
      const candidatesDistrict = [addr.district, addr.county, addr.town, addr.city_district, addr.municipality, addr.suburb].filter(Boolean);
      let district = candidatesDistrict.find(d => d !== city && /quận|huyện|thị xã|thành phố/i.test(d));
      if (!district) {
        district = candidatesDistrict.find(d => d !== city);
      }
      district = district || addr.district || addr.county || addr.town || addr.city_district || '';

      const details = nomData.display_name || '';

      document.getElementById('address-city').value = city;
      document.getElementById('address-district').value = district;
      document.getElementById('address-detail').value = details;

      // Xóa lỗi viền đỏ nếu có
      ['address-city', 'address-district', 'address-detail'].forEach(id => {
        const input = document.getElementById(id);
        if (input) input.style.borderColor = '';
        const errDiv = document.getElementById(id + '-error');
        if (errDiv) { errDiv.style.display = 'none'; errDiv.textContent = ''; }
      });

      toast('✓ Đã tự động định vị vị trí thành công!');
    } else {
      toast('⚠️ Không thể tìm thấy tên đường từ tọa độ GPS.');
    }
  } catch (e) {
    console.warn('GPS failed, trying IP fallback:', e);
    try {
      const res = await fetch('https://ipapi.co/json/');
      const data = await res.json();
      if (data && data.city && data.region) {
        document.getElementById('address-city').value = data.region;
        document.getElementById('address-district').value = data.city;
        toast('✓ Đã định vị qua mạng (Độ chính xác cấp Tỉnh/Thành).');
      } else {
        toast('⚠️ Không thể xác định vị trí của bạn.');
      }
    } catch (err) {
      toast('⚠️ Lỗi kết nối định vị (Vui lòng cấp quyền hoặc thử lại sau).');
    }
  } finally {
    btn.disabled = false;
    textSpan.textContent = 'Định vị GPS';
  }
}

function saveAddress() {
  clearAddressErrors();
  const idEl = document.getElementById('address-id-edit');
  const nameEl = document.getElementById('address-name');
  const phoneEl = document.getElementById('address-phone');
  const detailEl = document.getElementById('address-detail');
  const cityEl = document.getElementById('address-city');
  const districtEl = document.getElementById('address-district');

  const id = idEl ? idEl.value : '';
  const name = nameEl ? nameEl.value.trim() : '';
  const phone = phoneEl ? phoneEl.value.trim() : '';
  const detail = detailEl ? detailEl.value.trim() : '';
  const city = cityEl ? cityEl.value.trim() : '';
  const district = districtEl ? districtEl.value.trim() : '';

  let isValid = true;
  let firstInvalid = null;

  if (!name) {
    showAddressFieldError('address-name', 'Vui lòng nhập họ và tên người nhận.');
    if (!firstInvalid) firstInvalid = nameEl;
    isValid = false;
  }

  if (!phone) {
    showAddressFieldError('address-phone', 'Vui lòng nhập số điện thoại.');
    if (!firstInvalid) firstInvalid = phoneEl;
    isValid = false;
  } else {
    const phoneRegex = /^0(3|5|7|8|9)[0-9]{8}$/;
    if (!phoneRegex.test(phone)) {
      showAddressFieldError('address-phone', 'Số điện thoại không hợp lệ (gồm 10 chữ số, đầu số 03, 05, 07, 08, 09).');
      if (!firstInvalid) firstInvalid = phoneEl;
      isValid = false;
    }
  }

  if (!detail) {
    showAddressFieldError('address-detail', 'Vui lòng nhập địa chỉ chi tiết (số nhà, đường phố).');
    if (!firstInvalid) firstInvalid = detailEl;
    isValid = false;
  }

  if (!city) {
    showAddressFieldError('address-city', 'Vui lòng nhập tỉnh / thành phố.');
    if (!firstInvalid) firstInvalid = cityEl;
    isValid = false;
  }

  if (!district) {
    showAddressFieldError('address-district', 'Vui lòng nhập quận / huyện.');
    if (!firstInvalid) firstInvalid = districtEl;
    isValid = false;
  }

  if (!isValid) {
    firstInvalid?.focus();
    toast('⚠️ Vui lòng điền đầy đủ và chính xác thông tin địa chỉ.');
    return;
  }

  const payload = { recipientName: name, phone, detailedAddress: detail, city, district };
  const method = id ? 'PUT' : 'POST';
  const url = id ? '/api/address/' + id : '/api/address';

  fetch(url, {
    method,
    headers: { 'Content-Type': 'application/json', [csrfHeader]: csrfToken },
    body: JSON.stringify(payload)
  })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        const serverMsg = (data.data && data.data.message) || (data.message !== 'Created' && data.message !== 'Updated' && data.message !== 'Success' ? data.message : null);
        toast('✓ ' + (serverMsg || (id ? 'Đã cập nhật địa chỉ.' : 'Đã thêm địa chỉ mới.')));
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
      headers: { [csrfHeader]: csrfToken }
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

document.addEventListener('DOMContentLoaded', () => {
  ['address-name', 'address-phone', 'address-detail', 'address-city', 'address-district'].forEach(id => {
    const el = document.getElementById(id);
    if (el) {
      el.addEventListener('input', function () {
        this.style.borderColor = '';
        const errDiv = document.getElementById(id + '-error');
        if (errDiv) {
          errDiv.style.display = 'none';
          errDiv.textContent = '';
        }
      });
    }
  });

  const addressPhoneInput = document.getElementById('address-phone');
  if (addressPhoneInput) {
    addressPhoneInput.addEventListener('input', function () {
      this.value = this.value.replace(/[^0-9]/g, '');
      if (this.value.length > 10) {
        this.value = this.value.slice(0, 10);
      }
    });
  }
});
