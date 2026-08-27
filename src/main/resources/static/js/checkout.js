// Checkout Page JavaScript Logic

// State
let currentShipping = 30000;
let currentShippingMethodName = 'Giao Hàng Tiêu Chuẩn';
let currentOrderDiscount = 0;
let currentFreeshipDiscount = 0;
let voucherSelectInstance;
let userLat = null;
let userLon = null;

// Number formatter
const formatter = new Intl.NumberFormat('en-US');

function updateTotal() {
    const shippingTextEl = document.getElementById('shippingFeeText');
    if (shippingTextEl) shippingTextEl.innerText = formatter.format(currentShipping) + 'đ';

    const discountTextEl = document.getElementById('discountText');
    if (discountTextEl) discountTextEl.innerText = '-' + formatter.format(currentOrderDiscount) + 'đ';

    const freeshipRow = document.getElementById('freeshipDiscountRow');
    if (freeshipRow) {
        if (currentFreeshipDiscount > 0) {
            freeshipRow.style.display = 'flex';
            const freeshipTextEl = document.getElementById('freeshipDiscountText');
            if (freeshipTextEl) freeshipTextEl.innerText = '-' + formatter.format(currentFreeshipDiscount) + 'đ';
        } else {
            freeshipRow.style.display = 'none';
        }
    }

    const baseVal = typeof baseTotal !== 'undefined' ? baseTotal : 0;
    const vipVal = typeof vipDiscountAmt !== 'undefined' ? vipDiscountAmt : 0;
    const finalShipping = Math.max(0, currentShipping - currentFreeshipDiscount);
    const finalTotal = Math.max(0, (baseVal - vipVal - currentOrderDiscount) + finalShipping);
    const finalTotalEl = document.getElementById('finalTotalText');
    if (finalTotalEl) finalTotalEl.innerText = formatter.format(finalTotal) + 'đ';
}

// Initialize Total & Address Data
document.addEventListener('DOMContentLoaded', () => {
    fetchShippingMethods('');
    loadProvinces();
});

// Voucher Modal Logic
function openVoucherModal() {
    const modal = document.getElementById('voucherModal');
    if (!modal) return;
    if (modal.parentElement !== document.body) {
        document.body.appendChild(modal);
    }
    modal.setAttribute('style',
        'display:flex !important;' +
        'position:fixed !important;' +
        'inset:0 !important;' +
        'z-index:9999 !important;' +
        'background-color:rgba(0,0,0,0.6) !important;' +
        'align-items:center !important;' +
        'justify-content:center !important;' +
        'opacity:1 !important;'
    );
    modal.classList.add('active');
}

function closeVoucherModal() {
    const modal = document.getElementById('voucherModal');
    if (modal) modal.style.display = 'none';
}

function selectVoucher(code, scope) {
    if (scope === 'FREESHIP') {
        const fsInput = document.getElementById('freeshipInput');
        if (fsInput) fsInput.value = code;
    } else {
        const vInput = document.getElementById('voucherInput');
        if (vInput) vInput.value = code;
    }

    const codeVal = document.getElementById('voucherInput') ? document.getElementById('voucherInput').value : '';
    const freeshipVal = document.getElementById('freeshipInput') ? document.getElementById('freeshipInput').value : '';
    let displayMsg = [];
    if (codeVal) displayMsg.push('Đơn hàng: ' + codeVal);
    if (freeshipVal) displayMsg.push('Freeship: ' + freeshipVal);

    const selectedTextEl = document.getElementById('selectedVoucherText');
    if (selectedTextEl) {
        selectedTextEl.innerText = displayMsg.length > 0 ? displayMsg.join(' | ') : 'Chọn hoặc nhập mã khuyến mãi';
        selectedTextEl.style.color = displayMsg.length > 0 ? 'var(--primary)' : 'var(--text-main)';
    }
    closeVoucherModal();
    applyVoucher();
}

function applyManualVoucher() {
    const manualInput = document.getElementById('manualVoucherCode');
    const code = manualInput ? manualInput.value.trim() : '';
    if (code) {
        selectVoucher(code.toUpperCase(), 'GLOBAL');
    } else {
        const targetContainer = document.getElementById('voucherModal') || document.body;
        if (typeof Swal !== 'undefined') {
            Swal.fire({
                title: 'Thông Báo',
                text: 'Vui lòng nhập mã giảm giá!',
                icon: 'warning',
                confirmButtonColor: '#0066CC',
                confirmButtonText: 'Đóng',
                target: targetContainer
            });
        } else if (typeof showAlertModal === 'function') {
            showAlertModal('Thông Báo', 'Vui lòng nhập mã giảm giá!');
        } else if (typeof showToastWarning === 'function') {
            showToastWarning('⚠️ Vui lòng nhập mã giảm giá!');
        }
    }
}

function selectShipping(el, fee, name) {
    document.querySelectorAll('input[name="shippingMethodDummy"]').forEach(r => {
        r.checked = false;
        r.closest('.radio-block').classList.remove('active');
    });
    const radio = el.querySelector('input');
    if (radio) radio.checked = true;
    el.classList.add('active');
    currentShipping = fee;
    if (name) currentShippingMethodName = name;
    updateTotal();

    const vInput = document.getElementById('voucherInput');
    const fInput = document.getElementById('freeshipInput');
    const code = vInput ? vInput.value.trim() : '';
    const freeshipCode = fInput ? fInput.value.trim() : '';
    if (code || freeshipCode) {
        applyVoucher();
    }
}

function selectPayment(el) {
    document.querySelectorAll('input[name="paymentMethod"]').forEach(r => {
        r.closest('.radio-block').classList.remove('active');
    });
    const radio = el.querySelector('input');
    if (radio) radio.checked = true;
    el.classList.add('active');
}

// Dynamic Shipping Logic
async function fetchShippingMethods(provinceCode, districtName, lat, lng) {
    const container = document.getElementById('shipping-methods-container');
    if (!container) return;

    const hasLatLon = (lat && lng) || (userLat && userLon);
    if (!provinceCode && !hasLatLon) {
        container.innerHTML = `
            <div style="padding: 20px; text-align: center; color: var(--text-muted); border: 1px dashed var(--border); border-radius: 6px;">
                <i class="fa-solid fa-map-location-dot" style="margin-right: 6px; color: var(--primary); font-size: 18px;"></i>
                Vui lòng chọn Tỉnh / Thành phố hoặc dùng nút định vị GPS ở bước 1 để tính phí vận chuyển.
            </div>
        `;
        currentShipping = 0;
        currentShippingMethodName = '';
        const feeTextEl = document.getElementById('shippingFeeText');
        if (feeTextEl) feeTextEl.innerText = 'Chưa chọn địa chỉ';
        updateTotal();
        return;
    }

    container.innerHTML = '<div style="padding: 20px; text-align: center; color: var(--primary);"><i class="fa-solid fa-spinner fa-spin"></i> Đang tính phí vận chuyển...</div>';

    let totalWeight = 0;
    document.querySelectorAll('.order-name').forEach(el => {
        let name = el.innerText.toLowerCase();
        let qtyEl = el.nextElementSibling;
        let qtyStr = qtyEl ? qtyEl.innerText.replace('x', '').trim() : "1";
        let qty = parseInt(qtyStr) || 1;

        let itemWeight = 2.5;
        if (name.includes("ram") || name.includes("cpu") || name.includes("ryzen") || name.includes("intel core") || name.includes("ssd") || name.includes("hdd") || name.includes("chuột") || name.includes("phím") || name.includes("tai nghe") || name.includes("usb") || name.includes("cáp") || name.includes("fan") || name.includes("tản nhiệt")) {
            itemWeight = 0.5;
        } else if (name.includes("màn hình") || name.includes("monitor") || name.includes("case") || name.includes("vỏ") || name.includes("ghế") || name.includes("bàn") || name.includes("tower")) {
            itemWeight = 8.0;
        } else if (name.includes("pc") || name.includes("combo") || name.includes("bộ")) {
            itemWeight = 15.0;
        }
        totalWeight += itemWeight * qty;
    });

    let url = `/api/shipping/calculate?provinceCode=${provinceCode || ''}&weight=${totalWeight}`;
    if (districtName) url += `&districtName=${encodeURIComponent(districtName)}`;
    if (lat && lng) {
        url += `&lat=${lat}&lng=${lng}`;
    } else if (userLat && userLon) {
        url += `&lat=${userLat}&lng=${userLon}`;
    }

    try {
        const res = await fetch(url);
        const methods = await res.json();

        container.innerHTML = '';
        methods.forEach((m, index) => {
            const isActive = index === 0;
            if (isActive) {
                currentShipping = m.fee;
                currentShippingMethodName = m.name;
            }

            const el = document.createElement('label');
            el.className = `radio-block ${isActive ? 'active' : ''}`;
            el.onclick = function () { selectShipping(this, m.fee, m.name); };

            el.innerHTML = `
                <div class="radio-content">
                    <input type="radio" name="shippingMethodDummy" ${isActive ? 'checked' : ''}>
                    <i class="${m.icon}"></i>
                    <div>
                        ${m.name}<br>
                        <span style="font-size:12px; color:#6b7280; font-weight:400;">${m.description}</span>
                    </div>
                </div>
                <div class="radio-price">${m.fee === 0 ? 'Miễn phí' : formatter.format(m.fee) + 'đ'}</div>
            `;
            container.appendChild(el);
        });
        updateTotal();
    } catch (e) {
        container.innerHTML = '<div style="padding: 20px; text-align: center; color: var(--danger);">Lỗi tải phương thức vận chuyển</div>';
    }
}

// Address API
async function loadProvinces() {
    try {
        const res = await fetch('https://provinces.open-api.vn/api/p/');
        const data = await res.json();
        const sel = document.getElementById('province');
        if (!sel) return;
        data.forEach(p => {
            const opt = document.createElement('option');
            opt.value = p.code;
            opt.text = p.name;
            sel.appendChild(opt);
        });
    } catch (e) { console.error('Error loading provinces', e); }
}

// Form Listeners Initialization
document.addEventListener('DOMContentLoaded', () => {
    const provinceEl = document.getElementById('province');
    if (provinceEl) {
        provinceEl.addEventListener('change', async function () {
            const val = this.value;
            userLat = null;
            userLon = null;

            const btnLoc = document.getElementById('btnGetLocation');
            if (btnLoc) {
                btnLoc.style.display = val ? 'none' : 'flex';
            }

            fetchShippingMethods(val);
            const distSel = document.getElementById('district');
            const wardSel = document.getElementById('ward');
            if (!distSel || !wardSel) return;
            distSel.innerHTML = '<option value="">Chọn Quận / Huyện</option>';
            wardSel.innerHTML = '<option value="">Chọn Phường / Xã</option>';

            if (!val) {
                distSel.disabled = true;
                wardSel.disabled = true;
                return;
            }

            try {
                const res = await fetch(`https://provinces.open-api.vn/api/p/${val}?depth=2`);
                const data = await res.json();
                distSel.disabled = false;
                data.districts.forEach(d => {
                    const opt = document.createElement('option');
                    opt.value = d.code;
                    opt.text = d.name;
                    distSel.appendChild(opt);
                });
            } catch (e) { console.error(e); }
        });
    }

    const districtEl = document.getElementById('district');
    if (districtEl) {
        districtEl.addEventListener('change', async function () {
            const val = this.value;
            const pSel = document.getElementById('province');
            const dName = (this.options[this.selectedIndex] && val) ? this.options[this.selectedIndex].text : '';
            fetchShippingMethods(pSel ? pSel.value : '', dName);

            const wardSel = document.getElementById('ward');
            if (!wardSel) return;
            wardSel.innerHTML = '<option value="">Chọn Phường / Xã</option>';

            if (!val) {
                wardSel.disabled = true;
                return;
            }

            try {
                const res = await fetch(`https://provinces.open-api.vn/api/d/${val}?depth=2`);
                const data = await res.json();
                wardSel.disabled = false;
                data.wards.forEach(w => {
                    const opt = document.createElement('option');
                    opt.value = w.code;
                    opt.text = w.name;
                    wardSel.appendChild(opt);
                });
            } catch (e) { console.error(e); }
        });
    }

    // Validation Listeners
    const fnInput = document.getElementById('fullName');
    const phoneInput = document.getElementById('phone');
    const addressInput = document.getElementById('addressLine');
    let addressDebounceTimer = null;

    if (fnInput) {
        fnInput.addEventListener('blur', validateFullName);
        fnInput.addEventListener('input', () => {
            if (fnInput.value.trim().split(/\s+/).filter(w => w.length > 0).length >= 2) {
                validateFullName();
            }
        });
    }

    if (phoneInput) {
        phoneInput.addEventListener('blur', validatePhone);
        phoneInput.addEventListener('input', () => {
            const clean = phoneInput.value.trim().replace(/\s+/g, '');
            if (clean.length >= 10) {
                validatePhone();
            }
        });
    }

    if (addressInput) {
        addressInput.addEventListener('input', () => {
            clearTimeout(addressDebounceTimer);
            const text = addressInput.value.trim();
            if (text.length >= 6) {
                addressDebounceTimer = setTimeout(async () => {
                    try {
                        const pSel = document.getElementById('province');
                        const dSel = document.getElementById('district');
                        const pName = (pSel && pSel.options[pSel.selectedIndex] && pSel.value) ? pSel.options[pSel.selectedIndex].text : '';
                        const dName = (dSel && dSel.options[dSel.selectedIndex] && dSel.value) ? dSel.options[dSel.selectedIndex].text : '';

                        const query = `${text}, ${dName}, ${pName}, Việt Nam`;
                        const res = await fetch(`https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(query)}&format=json&limit=1`);
                        const data = await res.json();

                        if (data && data.length > 0) {
                            userLat = parseFloat(data[0].lat);
                            userLon = parseFloat(data[0].lon);
                            fetchShippingMethods(pSel ? pSel.value : '', dName, userLat, userLon);
                        }
                    } catch (e) { }
                }, 800);
            }
        });
    }
});

// Voucher logic
function applyVoucher() {
    const vInput = document.getElementById('voucherInput');
    const fInput = document.getElementById('freeshipInput');
    const code = vInput ? vInput.value.trim() : '';
    const freeshipCode = fInput ? fInput.value.trim() : '';
    const msg = document.getElementById('voucherMessage');

    if (!code && !freeshipCode) {
        if (msg) msg.style.display = 'none';
        currentOrderDiscount = 0;
        currentFreeshipDiscount = 0;
        const vHidden = document.getElementById('voucherCodeHidden');
        const fHidden = document.getElementById('freeshipCodeHidden');
        if (vHidden) vHidden.value = '';
        if (fHidden) fHidden.value = '';
        updateTotal();
        return;
    }

    const fee = currentShipping || 0;
    const url = `/api/voucher/validate-combo?code=${encodeURIComponent(code)}&freeshipCode=${encodeURIComponent(freeshipCode)}&shippingFee=${fee}`;
    fetch(url, { method: 'POST' })
        .then(res => res.json())
        .then(data => {
            if (msg) msg.style.display = 'block';
            const isSuccess = data.success || data.valid;
            if (isSuccess) {
                msg.style.color = '#16a34a';
                msg.innerText = data.message;
                const vHidden = document.getElementById('voucherCodeHidden');
                const fHidden = document.getElementById('freeshipCodeHidden');
                if (vHidden) vHidden.value = data.voucherCode || '';
                if (fHidden) fHidden.value = data.freeshipCode || '';

                currentOrderDiscount = Number(data.orderDiscount || 0);
                currentFreeshipDiscount = Number(data.freeshipDiscount || 0);
                updateTotal();
            } else {
                msg.style.color = 'var(--danger)';
                msg.innerText = data.message || 'Mã không hợp lệ';
                const vHidden = document.getElementById('voucherCodeHidden');
                const fHidden = document.getElementById('freeshipCodeHidden');
                if (vHidden) vHidden.value = '';
                if (fHidden) fHidden.value = '';
                currentOrderDiscount = 0;
                currentFreeshipDiscount = 0;
                updateTotal();

                const codeInput = document.getElementById('manualVoucherCode');
                if (codeInput) {
                    codeInput.classList.remove('shake');
                    void codeInput.offsetWidth;
                    codeInput.classList.add('shake');
                    codeInput.addEventListener('animationend', function handler() {
                        codeInput.classList.remove('shake');
                        codeInput.removeEventListener('animationend', handler);
                    });
                }
            }
        })
        .catch(e => {
            const vHidden = document.getElementById('voucherCodeHidden');
            const fHidden = document.getElementById('freeshipCodeHidden');
            if (vHidden) vHidden.value = '';
            if (fHidden) fHidden.value = '';
            currentOrderDiscount = 0;
            currentFreeshipDiscount = 0;
            updateTotal();
            if (msg) {
                msg.style.display = 'block';
                msg.style.color = 'var(--danger)';
                msg.innerText = 'Lỗi kết nối kiểm tra mã voucher';
            }
        });
}

// Validation functions
function validateFullName() {
    const fnInput = document.getElementById('fullName');
    const err = document.getElementById('fullNameError');
    if (!fnInput || !err) return true;
    const val = fnInput.value.trim();
    const words = val.split(/\s+/).filter(w => w.length > 0);

    if (val.length === 0) {
        err.style.display = 'block';
        err.innerText = 'Vui lòng nhập họ và tên.';
        fnInput.style.borderColor = 'var(--danger)';
        return false;
    } else if (words.length < 2) {
        err.style.display = 'block';
        err.innerText = 'Họ và tên phải bao gồm cả Họ và Tên (ít nhất 2 từ, ví dụ: Nguyễn Văn A).';
        fnInput.style.borderColor = 'var(--danger)';
        return false;
    } else {
        err.style.display = 'none';
        fnInput.style.borderColor = 'var(--border)';
        return true;
    }
}

function validatePhone() {
    const phoneInput = document.getElementById('phone');
    const err = document.getElementById('phoneError');
    if (!phoneInput || !err) return true;
    const val = phoneInput.value.trim().replace(/\s+/g, '');
    const phoneRegex = /^(0[3|5|7|8|9|1|2])[0-9]{8}$/;

    if (val.length === 0) {
        err.style.display = 'block';
        err.innerText = 'Vui lòng nhập số điện thoại.';
        phoneInput.style.borderColor = 'var(--danger)';
        return false;
    } else if (!phoneRegex.test(val)) {
        err.style.display = 'block';
        err.innerText = 'Số điện thoại không hợp lệ (Phải gồm 10 chữ số Việt Nam, ví dụ: 0901234567).';
        phoneInput.style.borderColor = 'var(--danger)';
        return false;
    } else {
        err.style.display = 'none';
        phoneInput.style.borderColor = 'var(--border)';
        return true;
    }
}

function onGpsSuccess() {
    const pSel = document.getElementById('province');
    const dSel = document.getElementById('district');
    const wSel = document.getElementById('ward');
    const addrInput = document.getElementById('addressLine');
    const btnClear = document.getElementById('btnClearLocation');
    const btnGet = document.getElementById('btnGetLocation');

    if (pSel) { pSel.disabled = true; pSel.removeAttribute('required'); }
    if (dSel) { dSel.disabled = true; dSel.removeAttribute('required'); }
    if (wSel) { wSel.disabled = true; wSel.removeAttribute('required'); }

    const pGrp = document.getElementById('province-group');
    const dGrp = document.getElementById('district-group');
    const wGrp = document.getElementById('ward-group');
    if (pGrp) pGrp.style.display = 'none';
    if (dGrp) dGrp.style.display = 'none';
    if (wGrp) wGrp.style.display = 'none';

    if (addrInput) {
        addrInput.readOnly = true;
        addrInput.style.backgroundColor = '#f1f5f9';
    }

    if (btnClear) btnClear.style.display = 'flex';
    if (btnGet) btnGet.style.display = 'none';
}

window.clearLocation = function () {
    userLat = null;
    userLon = null;
    const addressInput = document.getElementById('addressLine');
    if (addressInput) {
        addressInput.value = '';
        addressInput.readOnly = false;
        addressInput.style.backgroundColor = '';
    }

    const pGrp = document.getElementById('province-group');
    const dGrp = document.getElementById('district-group');
    const wGrp = document.getElementById('ward-group');
    if (pGrp) pGrp.style.display = 'block';
    if (dGrp) dGrp.style.display = 'block';
    if (wGrp) wGrp.style.display = 'block';

    const pSel = document.getElementById('province');
    const dSel = document.getElementById('district');
    const wSel = document.getElementById('ward');

    if (pSel) {
        pSel.disabled = false;
        pSel.setAttribute('required', 'required');

        if (pSel.value && dSel) {
            dSel.disabled = false;
            dSel.setAttribute('required', 'required');
            if (dSel.value && wSel) {
                wSel.disabled = false;
                wSel.setAttribute('required', 'required');
            }
        }
    }

    const btnClear = document.getElementById('btnClearLocation');
    const btnGet = document.getElementById('btnGetLocation');
    const statusMsg = document.getElementById('locationStatus');

    if (btnClear) btnClear.style.display = 'none';
    if (btnGet) btnGet.style.display = 'flex';
    if (statusMsg) statusMsg.innerText = '';
    fetchShippingMethods(pSel ? pSel.value : '');
};

// Robust GPS & IP Geolocation
async function getCurrentLocation() {
    const btn = document.getElementById('btnGetLocation');
    const statusMsg = document.getElementById('locationStatus');
    const addressInput = document.getElementById('addressLine');

    if (btn) {
        btn.disabled = true;
        btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> <span>Đang định vị...</span>';
    }
    if (statusMsg) {
        statusMsg.style.display = 'block';
        statusMsg.style.color = '#0284c7';
        statusMsg.innerText = 'Đang xin quyền vị trí và tra cứu bản đồ...';
    }

    async function reverseGeocode(lat, lon) {
        userLat = lat;
        userLon = lon;

        try {
            const nomRes = await fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lon}&format=json&accept-language=vi`);
            const nomData = await nomRes.json();
            if (nomData && nomData.display_name) {
                if (addressInput) addressInput.value = nomData.display_name;
                if (statusMsg) {
                    statusMsg.style.color = 'var(--success)';
                    statusMsg.innerHTML = '<i class="fa-solid fa-circle-check"></i> Đã tự động định vị vị trí thành công!';
                }
                fetchShippingMethods('', '', userLat, userLon);
                onGpsSuccess();
                return true;
            }
        } catch (e) {
            console.warn('Nominatim reverse geocode failed:', e);
        }

        try {
            const bdcRes = await fetch(`https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${lat}&longitude=${lon}&localityLanguage=vi`);
            const bdcData = await bdcRes.json();
            if (bdcData && (bdcData.locality || bdcData.city || bdcData.principalSubdivision)) {
                const parts = [bdcData.locality, bdcData.city, bdcData.principalSubdivision].filter(Boolean);
                if (addressInput) addressInput.value = parts.join(', ');

                if (statusMsg) {
                    statusMsg.style.color = 'var(--success)';
                    statusMsg.innerHTML = '<i class="fa-solid fa-circle-check"></i> Đã tự động định vị vị trí thành công (Cấp độ Thành phố)!';
                }
                fetchShippingMethods('', '', userLat, userLon);
                onGpsSuccess();
                return true;
            }
        } catch (e) {
            console.warn('BigDataCloud reverse geocode failed:', e);
        }

        if (statusMsg) {
            statusMsg.style.color = 'var(--danger)';
            statusMsg.innerText = 'Không thể chuyển đổi tọa độ vị trí thành địa chỉ.';
        }
        return false;
    }

    async function fallbackIpLocation() {
        if (statusMsg) statusMsg.innerText = 'Đang tự động xác định vị trí qua IP mạng...';
        try {
            const res = await fetch('https://ipapi.co/json/');
            const data = await res.json();
            if (data && data.latitude && data.longitude) {
                return await reverseGeocode(data.latitude, data.longitude);
            }
        } catch (e) {
            try {
                const res2 = await fetch('https://freeipapi.com/api/json');
                const data2 = await res2.json();
                if (data2 && data2.latitude && data2.longitude) {
                    return await reverseGeocode(data2.latitude, data2.longitude);
                }
            } catch (e2) { }
        }
        return false;
    }

    const isSecure = location.protocol === 'https:' || location.hostname === 'localhost' || location.hostname === '127.0.0.1';
    if (navigator.geolocation && isSecure) {
        navigator.geolocation.getCurrentPosition(
            async (pos) => {
                await reverseGeocode(pos.coords.latitude, pos.coords.longitude);
                if (btn) {
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fa-solid fa-location-dot"></i> <span>Tự động định vị địa chỉ (GPS/Bản đồ)</span>';
                }
            },
            async (err) => {
                console.warn('Browser GPS position error:', err);
                const ok = await fallbackIpLocation();
                if (!ok && statusMsg) {
                    statusMsg.style.color = 'var(--danger)';
                    statusMsg.innerText = 'Không thể lấy được vị trí. Vui lòng chọn Tỉnh/Thành phố bên dưới.';
                }
                if (btn) {
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fa-solid fa-location-dot"></i> <span>Tự động định vị địa chỉ (GPS/Bản đồ)</span>';
                }
            },
            { enableHighAccuracy: true, timeout: 8000, maximumAge: 0 }
        );
    } else {
        const ok = await fallbackIpLocation();
        if (!ok && statusMsg) {
            statusMsg.style.color = 'var(--danger)';
            statusMsg.innerText = 'Trình duyệt chặn GPS trên kết nối HTTP. Vui lòng chọn Tỉnh/Thành phố thủ công.';
        }
        if (btn) {
            btn.disabled = false;
            btn.innerHTML = '<i class="fa-solid fa-location-dot"></i> <span>Tự động định vị địa chỉ (GPS/Bản đồ)</span>';
        }
    }
}

// Address Book Modal Logic
function openAddressBookModal() {
    const modal = document.getElementById('addressBookModal');
    if (modal) modal.style.display = 'flex';
    const listContainer = document.getElementById('addressBookList');
    if (!listContainer) return;
    listContainer.innerHTML = '<div style="text-align:center; padding: 20px; color:#64748b;"><i class="fa-solid fa-spinner fa-spin"></i> Đang tải danh sách địa chỉ...</div>';

    fetch('/api/address')
        .then(res => res.json())
        .then(data => {
            if (data.success && data.data && data.data.length > 0) {
                listContainer.innerHTML = data.data.map(addr => `
                    <div style="border: 1px solid var(--border); padding: 15px; border-radius: 6px; display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <div style="font-weight: 600; font-size: 14px; margin-bottom: 4px;">${addr.recipientName} <span style="font-weight: normal; color: #64748b;">| ${addr.phone}</span></div>
                            <div style="font-size: 13px; color: #475569;">${addr.detailedAddress}</div>
                            <div style="font-size: 13px; color: #475569;">${addr.district ? addr.district + ', ' : ''}${addr.city}</div>
                        </div>
                        <button type="button" onclick="selectAddressFromBook('${encodeURIComponent(JSON.stringify(addr))}')" style="background: var(--primary); color: white; border: none; padding: 6px 16px; border-radius: 4px; cursor: pointer; font-weight: 500;">Chọn</button>
                    </div>
                `).join('');
            } else {
                listContainer.innerHTML = '<div style="text-align:center; padding: 20px; color:#64748b;">Bạn chưa lưu địa chỉ nào trong sổ địa chỉ.</div>';
            }
        })
        .catch(err => {
            listContainer.innerHTML = '<div style="text-align:center; padding: 20px; color:var(--danger);">Lỗi tải danh sách địa chỉ.</div>';
        });
}

function closeAddressBookModal() {
    const addrModal = document.getElementById('addressBookModal');
    if (addrModal) addrModal.style.display = 'none';
}

function selectAddressFromBook(addrJsonEnc) {
    const addr = JSON.parse(decodeURIComponent(addrJsonEnc));
    const fnInput = document.getElementById('fullName');
    const pInput = document.getElementById('phone');
    if (fnInput) fnInput.value = addr.recipientName || '';
    if (pInput) pInput.value = addr.phone || '';

    closeAddressBookModal();

    const pSelCheck = document.getElementById('province');
    if (document.getElementById('btnGetLocation').style.display === 'none' && (!pSelCheck || !pSelCheck.value)) {
        if (typeof window.clearLocation === 'function') {
            window.clearLocation();
        }
    }

    let fullAddress = addr.detailedAddress || '';
    if (addr.district && !fullAddress.includes(addr.district)) {
        fullAddress += ', ' + addr.district;
    }
    if (addr.city && !fullAddress.includes(addr.city)) {
        fullAddress += ', ' + addr.city;
    }
    const addrLine = document.getElementById('addressLine');
    if (addrLine) addrLine.value = fullAddress;

    if (typeof onGpsSuccess === 'function') {
        onGpsSuccess();
    } else {
        const pGrp = document.getElementById('province-group');
        const dGrp = document.getElementById('district-group');
        const wGrp = document.getElementById('ward-group');
        if (pGrp) pGrp.style.display = 'none';
        if (dGrp) dGrp.style.display = 'none';
        if (wGrp) wGrp.style.display = 'none';
        if (addrLine) {
            addrLine.readOnly = true;
            addrLine.style.backgroundColor = '#f1f5f9';
        }
        const btnClear = document.getElementById('btnClearLocation');
        const btnGet = document.getElementById('btnGetLocation');
        if (btnClear) btnClear.style.display = 'flex';
        if (btnGet) btnGet.style.display = 'none';

        const pSel = document.getElementById('province');
        const dSel = document.getElementById('district');
        const wSel = document.getElementById('ward');
        if (pSel) { pSel.disabled = true; pSel.removeAttribute('required'); }
        if (dSel) { dSel.disabled = true; dSel.removeAttribute('required'); }
        if (wSel) { wSel.disabled = true; wSel.removeAttribute('required'); }
    }

    const normalize = (str) => {
        if (!str) return '';
        return str.toLowerCase()
            .replace(/tỉnh|thành phố|tp\.?|quận|huyện|thị xã|phường|xã/gi, '')
            .replace(/\s+/g, ' ')
            .trim();
    };

    const pSel = document.getElementById('province');
    if (!pSel) return;

    let targetCity = normalize(addr.city);
    let targetDist = normalize(addr.district);

    if (targetCity.includes('thủ đức')) {
        targetCity = 'hồ chí minh';
        targetDist = 'thủ đức';
    }

    let matchedProvince = false;
    for (let i = 0; i < pSel.options.length; i++) {
        const optText = normalize(pSel.options[i].text);
        if (targetCity && optText && (optText === targetCity || optText.includes(targetCity) || targetCity.includes(optText))) {
            pSel.selectedIndex = i;
            matchedProvince = true;
            pSel.dispatchEvent(new Event('change'));

            setTimeout(() => {
                const dSel = document.getElementById('district');
                if (!dSel) return;
                for (let j = 0; j < dSel.options.length; j++) {
                    const dOptText = normalize(dSel.options[j].text);
                    if (targetDist && dOptText && (dOptText === targetDist || dOptText.includes(targetDist) || targetDist.includes(dOptText))) {
                        dSel.selectedIndex = j;
                        dSel.dispatchEvent(new Event('change'));
                        break;
                    }
                }
            }, 800);
            break;
        }
    }

    if (!matchedProvince && targetDist) {
        for (let i = 0; i < pSel.options.length; i++) {
            const optText = normalize(pSel.options[i].text);
            if (optText && (optText === targetDist || optText.includes(targetDist) || targetDist.includes(optText))) {
                pSel.selectedIndex = i;
                matchedProvince = true;
                pSel.dispatchEvent(new Event('change'));
                break;
            }
        }
    }

    if (!matchedProvince && (addr.city || addr.district)) {
        const warnMsg = 'Đã tải thông tin, nhưng hệ thống không nhận dạng được Tỉnh/Thành phố (Do tên không khớp). Vui lòng chọn thủ công.';
        if (typeof showAlertModal === 'function') {
            showAlertModal('Thông Báo', warnMsg);
        } else if (typeof Swal !== 'undefined') {
            Swal.fire({
                title: 'Thông Báo',
                text: warnMsg,
                icon: 'warning',
                confirmButtonColor: '#0066CC',
                confirmButtonText: 'Đóng'
            });
        } else if (typeof showToastWarning === 'function') {
            showToastWarning('⚠️ ' + warnMsg);
        }
    }
}

// Prepare submit
function prepareSubmit(e) {
    const form = document.getElementById('checkoutForm');
    if (!form) return;

    const isNameValid = validateFullName();
    const isPhoneValid = validatePhone();

    if (!isNameValid || !isPhoneValid) {
        e.preventDefault();
        if (!isNameValid) {
            const fnInput = document.getElementById('fullName');
            if (fnInput) fnInput.focus();
        } else if (!isPhoneValid) {
            const phoneInput = document.getElementById('phone');
            if (phoneInput) phoneInput.focus();
        }
        return false;
    }

    if (!form.checkValidity()) {
        return;
    }

    const line = document.getElementById('addressLine') ? document.getElementById('addressLine').value : '';
    const pSel = document.getElementById('province');
    const dSel = document.getElementById('district');
    const wSel = document.getElementById('ward');

    const pName = (pSel && pSel.options[pSel.selectedIndex] && pSel.value) ? pSel.options[pSel.selectedIndex].text : '';
    const dName = (dSel && dSel.options[dSel.selectedIndex] && dSel.value) ? dSel.options[dSel.selectedIndex].text : '';
    const wName = (wSel && wSel.options[wSel.selectedIndex] && wSel.value) ? wSel.options[wSel.selectedIndex].text : '';

    let fullAddress = line;
    if (wName) fullAddress += `, ${wName}`;
    if (dName) fullAddress += `, ${dName}`;
    if (pName) fullAddress += `, ${pName}`;

    const vCodeEl = document.getElementById('voucherCodeHidden');
    if (vCodeEl) {
        const val = (vCodeEl.value || '').trim();
        if (!val || val === 'null' || val === 'undefined') {
            vCodeEl.value = '';
        }
    }
    const fCodeEl = document.getElementById('freeshipCodeHidden');
    if (fCodeEl) {
        const val = (fCodeEl.value || '').trim();
        if (!val || val === 'null' || val === 'undefined') {
            fCodeEl.value = '';
        }
    }

    const hAddr = document.getElementById('hiddenAddress');
    const hFee = document.getElementById('hiddenShippingFee');
    const hName = document.getElementById('hiddenShippingMethodName');

    if (hAddr) hAddr.value = fullAddress;
    if (hFee) hFee.value = currentShipping;
    if (hName) hName.value = currentShippingMethodName;
}
