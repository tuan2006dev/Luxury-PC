// Constants
const slots = [
    { id: 'cpu', name: 'CPU', icon: 'fa-microchip', placeholderImg: '/images/ui-new/CPU.png', desc: 'Bộ vi xử lý' },
    { id: 'mainboard', name: 'MAINBOARD', icon: 'fa-chess-board', placeholderImg: '/images/ui-new/Mainboard.png', desc: 'Bo mạch chủ' },
    { id: 'ram', name: 'RAM', icon: 'fa-memory', placeholderImg: '/images/ui-new/RAM.png', desc: 'Bộ nhớ trong' },
    { id: 'vga', name: 'VGA', icon: 'fa-tv', placeholderImg: '/images/ui-new/VGA.png', desc: 'Card màn hình' },
    { id: 'storage', name: 'LƯU TRỮ', icon: 'fa-hard-drive', placeholderImg: '/images/ui-new/SSD.png', desc: 'Ổ cứng SSD/HDD' },
    { id: 'psu', name: 'NGUỒN', icon: 'fa-plug', placeholderImg: '/images/ui-new/PSU.png', desc: 'Nguồn máy tính' },
    { id: 'case', name: 'CASE', icon: 'fa-box', placeholderImg: '/images/ui-new/Case.png', desc: 'Vỏ máy tính' },
    { id: 'cooling', name: 'TẢN NHIỆT', icon: 'fa-fan', placeholderImg: '/images/ui-new/Cooling.png', desc: 'Tản nhiệt khí/AIO' }
];

let currentBuild = {};
let currentModalCategory = '';

// Formatting currency
function formatCurrency(val) {
    if (!val) return '0đ';
    return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".") + 'đ';
}

document.addEventListener('DOMContentLoaded', () => {
    initTabs();
    renderComboGrid();
    renderBuildComponents();
    calculateTotals();

    const deleteBtn = document.querySelector('.btn-action-delete');
    if (deleteBtn) {
        deleteBtn.addEventListener('click', confirmClearAll);
    }

    const addToCartBtn = document.querySelector('.btn-add-cart-large');
    if (addToCartBtn) {
        addToCartBtn.addEventListener('click', addBuildToCart);
    }

    const addMoreBtn = document.querySelector('.btn-add-more');
    if (addMoreBtn) {
        addMoreBtn.addEventListener('click', addMoreComponents);
    }
});

function addMoreComponents() {
    const unselectedSlot = slots.find(s => !currentBuild[s.id]);
    if (unselectedSlot) {
        openModal(unselectedSlot.id);
    } else {
        openModal(slots[0].id);
    }
}

function initTabs() {
    const tabs = document.querySelectorAll('.build-tab');
    const comboSection = document.querySelector('.combo-section');
    const buildSection = document.querySelector('.build-layout-3col');

    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');

            if (tab.innerText.includes('COMBO')) {
                comboSection.style.display = 'block';
                buildSection.style.display = 'none';
            } else {
                comboSection.style.display = 'none';
                buildSection.style.display = 'grid';
            }
        });
    });

    // Default state: Tự Build
    comboSection.style.display = 'none';
}

function renderComboGrid() {
    const grid = document.getElementById('combo-grid');
    if (!grid) return;

    if (!combosData || combosData.length === 0) {
        grid.innerHTML = '<p>Chưa có combo nào.</p>';
        return;
    }

    grid.innerHTML = '';
    combosData.forEach((combo, index) => {
        // Dynamic cool tags based on price
        let tag = 'Cấu Hình Tối Ưu';
        if (combo.price < 15000000) tag = 'CHIẾN BINH ESPORT';
        else if (combo.price < 25000000) tag = 'QUỐC DÂN LEO RANK';
        else if (combo.price < 40000000) tag = 'CỖ MÁY SÁNG TẠO';
        else if (combo.price < 60000000) tag = 'QUÁI VẬT HIỆU NĂNG';
        else tag = 'CHÚA TỂ ĐỒ HỌA';

        grid.innerHTML += `
            <div class="combo-card">
                <div class="combo-tag">${tag}</div>
                <h3>${combo.name}</h3>
                <div class="desc">${combo.description || 'Cấu hình tối ưu'}</div>
                <div class="combo-footer">
                    <div class="combo-price">${formatCurrency(combo.price)}</div>
                    <div class="combo-saving">Tiết kiệm ${formatCurrency(combo.saving)}</div>
                    <button class="btn-apply-combo" onclick="applyCombo(${combo.id})">CHỌN COMBO NÀY</button>
                </div>
            </div>
        `;
    });
}

function applyCombo(comboId) {
    const combo = combosData.find(c => c.id === comboId);
    if (!combo) return;

    // Clear current build
    currentBuild = {};

    // Apply details
    if (combo.details) {
        for (const [slotType, prodId] of Object.entries(combo.details)) {
            const catStr = slotType.toLowerCase();
            const prods = getProductsForCategory(catStr);
            const prod = prods.find(p => p.id === prodId);
            if (prod) {
                currentBuild[catStr] = prod;
            }
        }
    }

    // Switch to build tab
    document.querySelector('.build-tab').click(); // click Tự Build
    renderBuildComponents();
    calculateTotals();
    showToast('Đã áp dụng Combo ' + combo.name);
}

function renderBuildComponents() {
    const list = document.getElementById('build-components-list');
    if (!list) return;

    list.innerHTML = '';

    slots.forEach(slot => {
        const selectedProd = currentBuild[slot.id];
        let actionBtn = '';
        let prodName = '';
        let prodDesc = '';
        let prodPrice = '0đ';
        let prodImg = slot.placeholderImg;

        if (selectedProd) {
            prodName = selectedProd.name;
            prodDesc = selectedProd.description || 'Đã chọn linh kiện';
            prodPrice = formatCurrency(selectedProd.price);
            prodImg = selectedProd.img;
            actionBtn = `
                <button class="btn-comp-action" onclick="openModal('${slot.id}')">Đổi</button>
                <button class="btn-comp-action" onclick="removeComponent('${slot.id}')"><i class="fa-regular fa-trash-can"></i></button>
            `;
        } else {
            prodName = `Chưa chọn ${slot.name}`;
            prodDesc = `Vui lòng chọn ${slot.desc.toLowerCase()}`;
            actionBtn = `<button class="btn-comp-action" onclick="openModal('${slot.id}')"><i class="fa-solid fa-plus"></i> Chọn</button>`;
        }

        list.innerHTML += `
            <div class="comp-row">
                <div class="comp-cat">
                    <div class="comp-cat-icon"><i class="fa-solid ${slot.icon}"></i></div>
                    ${slot.name}
                </div>
                <div class="comp-info">
                    <div class="comp-img"><img src="${prodImg}" alt="${slot.name}"></div>
                    <div class="comp-details">
                        <div class="comp-name">${prodName}</div>
                        <div class="comp-desc">${prodDesc}</div>
                    </div>
                </div>
                <div class="comp-price-action">
                    <div class="comp-price">${prodPrice}</div>
                    <div class="comp-actions">${actionBtn}</div>
                </div>
            </div>
        `;
    });
}

function removeComponent(catId) {
    delete currentBuild[catId];
    renderBuildComponents();
    calculateTotals();
};

function executeClearAll() {
    currentBuild = {};
    localStorage.removeItem('luxury_saved_build');

    renderBuildComponents();
    calculateTotals();

    closeConfirmClear();
    showToast('Đã xóa tất cả linh kiện!');
}

function clearAll() {
    if (confirm('Bạn có chắc chắn muốn xóa tất cả linh kiện đã chọn?')) {
        currentBuild = {};
        localStorage.removeItem('luxury_saved_build');
        renderBuildComponents();
        calculateTotals();
        showToast('Đã xóa tất cả linh kiện!');
    }
}

function getProductsForCategory(catId) {
    if (typeof productsData === 'undefined' || !productsData) return [];
    if (productsData[catId] && productsData[catId].length > 0) {
        return productsData[catId];
    }
    if ((catId === 'storage' || catId === 'lưu trữ') && productsData['ssd']) {
        return productsData['ssd'];
    }
    if (catId === 'ssd' && productsData['storage']) {
        return productsData['storage'];
    }
    return productsData[catId] || [];
}

function openModal(catId) {
    currentModalCategory = catId;
    const slot = slots.find(s => s.id === catId);
    document.getElementById('modalTitle').innerText = 'Chọn ' + (slot ? slot.name : 'Linh kiện');
    document.getElementById('modalSearch').value = '';

    renderModalProducts(getProductsForCategory(catId));
    document.getElementById('productModal').classList.add('active');
}

function closeModal() {
    document.getElementById('productModal').classList.remove('active');
}

function renderModalProducts(prods) {
    const list = document.getElementById('modalProductList');
    list.innerHTML = '';
    if (prods.length === 0) {
        list.innerHTML = '<p style="text-align:center; color:#999; padding:20px;">Không có sản phẩm nào trong danh mục này.</p>';
        return;
    }

    prods.forEach(p => {
        list.innerHTML += `
            <div style="display:flex; align-items:center; justify-content:space-between; padding:15px; border:1px solid #eee; border-radius:8px; cursor:pointer;" onmouseover="this.style.borderColor='var(--accent-blue)'" onmouseout="this.style.borderColor='#eee'">
                <div style="display:flex; align-items:center; gap:15px;">
                    <img src="${p.img}" alt="${p.name}" style="width:60px; height:60px; object-fit:contain; border:1px solid #eee; border-radius:4px; padding:5px;">
                    <div>
                        <div style="font-weight:700; font-size:14px; color:#000; margin-bottom:5px;">${p.name}</div>
                        <div style="font-size:12px; color:#666;">${p.description || ''}</div>
                    </div>
                </div>
                <div style="display:flex; flex-direction:column; align-items:flex-end; gap:10px;">
                    <div style="font-weight:700; color:var(--accent-blue); font-size:15px;">${formatCurrency(p.price)}</div>
                    <button style="background:var(--accent-blue); color:white; border:none; padding:6px 12px; border-radius:4px; font-weight:600; cursor:pointer;" onclick="selectProduct(${p.id})">Chọn</button>
                </div>
            </div>
        `;
    });
}

function filterModalProducts() {
    const query = document.getElementById('modalSearch').value.toLowerCase();
    let prods = getProductsForCategory(currentModalCategory);
    if (query) {
        prods = prods.filter(p => p.name.toLowerCase().includes(query));
    }
    renderModalProducts(prods);
}

function selectProduct(id) {
    const prod = getProductsForCategory(currentModalCategory).find(p => p.id === id);
    if (prod) {
        currentBuild[currentModalCategory] = prod;
        renderBuildComponents();
        calculateTotals();
        closeModal();
    }
}

function calculateTotals() {
    let total = 0;
    let count = 0;
    for (const prod of Object.values(currentBuild)) {
        if (prod) {
            total += prod.price;
            count++;
        }
    }

    // Update Overview UI
    const overviewRows = document.querySelectorAll('.overview-row .val');
    if (overviewRows.length >= 3) {
        overviewRows[0].innerText = count;
        overviewRows[1].innerText = formatCurrency(total);
        overviewRows[3].innerText = formatCurrency(total); // Total
    }

    // Update header component count
    const headerTitle = document.querySelector('.comp-list-wrapper h2');
    if (headerTitle) {
        headerTitle.innerText = `LINH KIỆN ĐÃ CHỌN (${count})`;
    }

    const btnCart = document.querySelector('.btn-add-cart-large');
    const btnBuy = document.querySelector('.btn-buy-now');

    if (count > 0) {
        if (btnCart) { btnCart.disabled = false; btnCart.style.opacity = '1'; btnCart.style.cursor = 'pointer'; }
        if (btnBuy) { btnBuy.disabled = false; btnBuy.style.opacity = '1'; btnBuy.style.cursor = 'pointer'; }
    } else {
        if (btnCart) { btnCart.disabled = true; btnCart.style.opacity = '0.5'; btnCart.style.cursor = 'not-allowed'; }
        if (btnBuy) { btnBuy.disabled = true; btnBuy.style.opacity = '0.5'; btnBuy.style.cursor = 'not-allowed'; }
    }

    checkCompatibility();
    updatePerformanceScore();
}

function checkCompatibility() {
    const cpu = currentBuild['cpu'];
    const main = currentBuild['mainboard'];
    const ram = currentBuild['ram'];
    const vga = currentBuild['vga'];
    const psu = currentBuild['psu'];
    const pcCase = currentBuild['case'];

    let issues = [];

    if (cpu && main) {
        const cpuName = cpu.name.toLowerCase();
        const mainName = main.name.toLowerCase();
        const isIntelCPU = cpuName.includes('intel') || cpuName.includes('i3') || cpuName.includes('i5') || cpuName.includes('i7') || cpuName.includes('i9');
        const isAMDCPU = cpuName.includes('amd') || cpuName.includes('ryzen');

        const isIntelMain = mainName.includes('h610') || mainName.includes('b760') || mainName.includes('z790');
        const isAMDMain = mainName.includes('b450') || mainName.includes('b650') || mainName.includes('x670');

        if (isIntelCPU && isAMDMain) issues.push("CPU Intel không cắm được trên Mainboard AMD.");
        if (isAMDCPU && isIntelMain) issues.push("CPU AMD không cắm được trên Mainboard Intel.");
    }

    const alertBox = document.querySelector('.compat-status');
    const compatList = document.querySelector('.compat-list');

    if (alertBox) {
        if (issues.length > 0) {
            alertBox.innerHTML = `
                <div class="compat-icon" style="color: #ef4444; background: #fee2e2;"><i class="fa-solid fa-triangle-exclamation"></i></div>
                <div class="compat-title" style="color: #ef4444;">Xung đột phần cứng</div>
                <div class="compat-desc">${issues.join('<br>')}</div>
            `;
            alertBox.style.borderLeft = '4px solid #ef4444';
            document.getElementById('compat-alert-text').style.display = 'none';
        } else if (cpu && main && ram) {
            alertBox.innerHTML = `
                <div class="compat-icon"><i class="fa-solid fa-check"></i></div>
                <div class="compat-title">Tương thích hoàn toàn</div>
                <div class="compat-desc">Tất cả linh kiện đã được kiểm tra và tương thích với nhau.</div>
            `;
            alertBox.style.borderLeft = 'none';
            document.getElementById('compat-alert-text').style.display = 'block';
        } else {
            alertBox.innerHTML = `
                <div class="compat-icon" style="color: #666; background: #f0f0f0;"><i class="fa-solid fa-circle-info"></i></div>
                <div class="compat-title" style="color:#666;">Chưa đủ dữ liệu</div>
                <div class="compat-desc">Vui lòng chọn CPU, Mainboard và RAM.</div>
            `;
            alertBox.style.borderLeft = '4px solid #ccc';
            document.getElementById('compat-alert-text').style.display = 'none';
        }
    }

    // Update list dynamically
    if (document.getElementById('compat-cpu-main')) {
        document.getElementById('compat-cpu-main').querySelector('.status').innerHTML = (cpu && main && issues.length === 0) ? '<span style="color: #10b981; font-weight: 600;">Tương thích</span>' : (issues.length > 0 ? '<span style="color: #ef4444; font-weight: 600;">Lỗi</span>' : '<span style="color: #666; font-weight: 400;">Chưa đủ dữ liệu</span>');
        document.getElementById('compat-ram-main').querySelector('.status').innerHTML = (ram && main) ? '<span style="color: #10b981; font-weight: 600;">Tương thích</span>' : '<span style="color: #666; font-weight: 400;">Chưa đủ dữ liệu</span>';
        document.getElementById('compat-vga-main').querySelector('.status').innerHTML = (vga && main) ? '<span style="color: #10b981; font-weight: 600;">Tương thích</span>' : '<span style="color: #666; font-weight: 400;">Chưa đủ dữ liệu</span>';
        document.getElementById('compat-psu').querySelector('.status').innerHTML = (psu) ? '<span style="color: #10b981; font-weight: 600;">Tương thích</span>' : '<span style="color: #666; font-weight: 400;">Chưa đủ dữ liệu</span>';
        document.getElementById('compat-case').querySelector('.status').innerHTML = (pcCase) ? '<span style="color: #10b981; font-weight: 600;">Tương thích</span>' : '<span style="color: #666; font-weight: 400;">Chưa đủ dữ liệu</span>';
    }
}


function updatePerformanceScore() {
    let count = 0;
    const categories = ['cpu', 'mainboard', 'ram', 'vga', 'ssd', 'psu', 'case', 'cooling'];
    categories.forEach(cat => {
        if (currentBuild[cat]) count++;
    });

    let avgScore = (count / 8) * 10;
    let scoreStr = avgScore % 1 === 0 ? avgScore.toString() : avgScore.toFixed(1);

    let container = document.getElementById('main-perf-score-container');
    if (container) container.style.display = 'flex';
    document.getElementById('main-perf-score').innerText = scoreStr;

    if (count > 0) {
        document.getElementById('main-perf-label').style.display = 'none';
    } else {
        document.getElementById('main-perf-label').style.display = 'block';
        document.getElementById('main-perf-label').innerText = 'Đang cấu hình...';
    }

    const circle = document.querySelector('.perf-circle');
    if (circle) {
        if (count === 0) {
            circle.style.background = 'conic-gradient(#e5e7eb 0% 100%)';
        } else {
            const percent = (count / 8) * 100;
            circle.style.background = `conic-gradient(#f59e0b 0% ${percent}%, #e5e7eb ${percent}% 100%)`;
        }
    }

    document.getElementById('bar-gaming').style.width = (avgScore * 10) + '%';
    document.getElementById('val-gaming').innerText = scoreStr + '/10';

    document.getElementById('bar-graphic').style.width = (avgScore * 10) + '%';
    document.getElementById('val-graphic').innerText = scoreStr + '/10';

    document.getElementById('bar-work').style.width = (avgScore * 10) + '%';
    document.getElementById('val-work').innerText = scoreStr + '/10';

    document.getElementById('bar-multi').style.width = (avgScore * 10) + '%';
    document.getElementById('val-multi').innerText = scoreStr + '/10';

    // Recalculate FPS for tracked games
    recalcAllFps();
}

// ------------------------------------------------------------------
// Steam API Logic

let selectedGames = [
    {
        id: "730",
        name: "Counter-Strike 2",
        tiny_image: "https://steamcdn-a.akamaihd.net/steam/apps/730/capsule_sm_120.jpg",
        header_image: "https://steamcdn-a.akamaihd.net/steam/apps/730/header.jpg",
        req_min: "Core i5 750",
        req_rec: "Core i5 750"
    },
    {
        id: "578080",
        name: "PUBG: BATTLEGROUNDS",
        tiny_image: "https://steamcdn-a.akamaihd.net/steam/apps/578080/capsule_sm_120.jpg",
        header_image: "https://steamcdn-a.akamaihd.net/steam/apps/578080/header.jpg",
        req_min: "Core i5-4430 / GTX 960",
        req_rec: "Core i5-6600K / GTX 1060"
    },
    {
        id: "271590",
        name: "Grand Theft Auto V",
        tiny_image: "https://steamcdn-a.akamaihd.net/steam/apps/271590/capsule_sm_120.jpg",
        header_image: "https://steamcdn-a.akamaihd.net/steam/apps/271590/header.jpg",
        req_min: "Core 2 Quad Q6600 / 9800 GT",
        req_rec: "Core i5 3470 / GTX 660"
    },
    {
        id: "1091500",
        name: "Cyberpunk 2077",
        tiny_image: "https://steamcdn-a.akamaihd.net/steam/apps/1091500/capsule_sm_120.jpg",
        header_image: "https://steamcdn-a.akamaihd.net/steam/apps/1091500/header.jpg",
        req_min: "Core i7-6700 / GTX 1060",
        req_rec: "Core i7-12700 / RTX 2060"
    },
    {
        id: "1172470",
        name: "Apex Legends",
        tiny_image: "https://steamcdn-a.akamaihd.net/steam/apps/1172470/capsule_sm_120.jpg",
        header_image: "https://steamcdn-a.akamaihd.net/steam/apps/1172470/header.jpg",
        req_min: "Core i3-6300 / GT 640",
        req_rec: "Core i5-3570K / GTX 970"
    }
];
let steamSearchTimeout = null;

document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('steam-search-input');
    if (searchInput) {
        searchInput.addEventListener('input', function (e) {
            clearTimeout(steamSearchTimeout);
            const query = e.target.value.trim();
            const resultsBox = document.getElementById('steam-search-dropdown');

            if (query.length < 2) {
                resultsBox.style.display = 'none';
                return;
            }

            resultsBox.style.display = 'block';
            resultsBox.innerHTML = '<div style="padding: 10px; text-align: center; color: #666;"><i class="fa-solid fa-spinner fa-spin"></i> Đang tìm kiếm...</div>';

            steamSearchTimeout = setTimeout(() => {
                fetch(`/api/steam/search?q=${encodeURIComponent(query)}`)
                    .then(res => res.json())
                    .then(data => {
                        resultsBox.innerHTML = '';
                        if (!data.items || data.items.length === 0) {
                            resultsBox.innerHTML = '<div style="padding: 10px; color: #666; text-align: center;">Không tìm thấy game</div>';
                            return;
                        }

                        data.items.slice(0, 5).forEach(item => {
                            const div = document.createElement('div');
                            div.style.padding = '10px';
                            div.style.display = 'flex';
                            div.style.alignItems = 'center';
                            div.style.gap = '10px';
                            div.style.cursor = 'pointer';
                            div.style.borderBottom = '1px solid #eee';

                            div.onmouseover = () => div.style.backgroundColor = '#f9f9f9';
                            div.onmouseout = () => div.style.backgroundColor = 'transparent';

                            div.onclick = () => {
                                searchInput.value = '';
                                resultsBox.style.display = 'none';
                                addSteamGame(item);
                            };

                            div.innerHTML = `
                                <img src="${item.tiny_image}" alt="cover" style="width: 60px; border-radius: 4px;">
                                <div style="font-size: 14px; flex: 1; color:#000;">${item.name}</div>
                            `;
                            resultsBox.appendChild(div);
                        });
                    })
                    .catch(err => {
                        resultsBox.innerHTML = '<div style="padding: 10px; color: #ef4444; text-align: center;">Lỗi tải dữ liệu</div>';
                    });
            }, 500);
        });

        // Hide dropdown when clicking outside
        document.addEventListener('click', function (e) {
            if (e.target.id !== 'steam-search-input' && e.target.id !== 'steam-search-dropdown') {
                const resultsBox = document.getElementById('steam-search-dropdown');
                if (resultsBox) resultsBox.style.display = 'none';
            }
        });
    }

    // Render default top games
    renderFpsGames();
});

function addSteamGame(item) {
    if (selectedGames.find(g => g.id === item.id)) return; // Already added

    // Create loading placeholder
    const list = document.getElementById('dynamic-fps-list');
    const loadingId = 'game-loading-' + item.id;
    list.innerHTML += `
        <div class="fps-item" id="${loadingId}">
            <div class="fps-img"><img src="${item.tiny_image}" alt="loading" style="opacity:0.5;"></div>
            <div class="fps-info">
                <div class="fps-name" style="color:#000;">${item.name}</div>
                <div class="fps-setting" style="color:#666;">Đang phân tích cấu hình...</div>
            </div>
            <div class="fps-val"><i class="fa-solid fa-spinner fa-spin" style="color:#666;"></i></div>
        </div>
    `;

    fetch(`/api/steam/appdetails?appid=${item.id}`)
        .then(res => res.json())
        .then(data => {
            if (data[item.id] && data[item.id].success) {
                const appData = data[item.id].data;
                item.header_image = appData.header_image;
                item.req_min = appData.pc_requirements ? appData.pc_requirements.minimum : '';
                item.req_rec = appData.pc_requirements ? appData.pc_requirements.recommended : '';

                selectedGames.push(item);
                document.getElementById(loadingId).remove();
                renderFpsGames();
            } else {
                document.getElementById(loadingId).querySelector('.fps-setting').innerText = 'Không lấy được thông tin';
                document.getElementById(loadingId).querySelector('.fps-val').innerText = 'N/A';
            }
        })
        .catch(err => {
            document.getElementById(loadingId).querySelector('.fps-setting').innerText = 'Lỗi kết nối';
            document.getElementById(loadingId).querySelector('.fps-val').innerText = 'Lỗi';
        });
}

function renderFpsGames() {
    const list = document.getElementById('dynamic-fps-list');
    if (!list) return;
    list.innerHTML = '';

    if (selectedGames.length === 0) {
        list.innerHTML = '<div style="padding:20px; text-align:center; color:#666; background:#f9f9f9; border-radius:8px;">Hãy dùng thanh tìm kiếm để thêm Game.</div>';
        return;
    }

    selectedGames.forEach((game, index) => {
        let estFps = calculateEstFps(game);
        let color = '#000';
        if (estFps === '?') { estFps = 'Thiếu linh kiện'; color = '#666'; }
        else if (estFps < 60) { estFps = 'Dự kiến ~' + estFps + ' FPS'; color = '#ef4444'; }
        else if (estFps < 120) { estFps = 'Dự kiến ~' + estFps + ' FPS'; color = '#eab308'; }
        else { estFps = 'Dự kiến ' + estFps + '+ FPS'; color = '#10b981'; }

        let rankNum = index + 1;
        let rankColor = rankNum === 1 ? '#eab308' : (rankNum === 2 ? '#94a3b8' : (rankNum === 3 ? '#d97706' : '#94a3b8'));

        list.innerHTML += `
            <div class="fps-item" style="display: flex; align-items: center; gap: 10px;">
                <div style="font-size: 16px; font-weight: 800; color: ${rankColor}; min-width: 25px; text-align: center;">#${rankNum}</div>
                <div class="fps-img" onclick="removeGame('${game.id}')" style="cursor:pointer; position:relative;" title="Nhấn để xóa">
                    <img src="${game.header_image || game.tiny_image}" alt="${game.name}">
                    <div style="position:absolute; inset:0; background:rgba(0,0,0,0.5); display:flex; justify-content:center; align-items:center; opacity:0; transition:0.2s;" onmouseover="this.style.opacity=1" onmouseout="this.style.opacity=0"><i class="fa-solid fa-xmark" style="color:#fff; font-size:20px;"></i></div>
                </div>
                <div class="fps-info" style="flex: 1;">
                    <div class="fps-name" style="color:#000; font-weight:600;">${game.name}</div>
                    <div class="fps-setting" style="color:#666;">High Setting</div>
                </div>
                <div class="fps-val" style="color:${color}; font-weight:700;">${estFps}</div>
            </div>
        `;
    });
}

function removeGame(id) {
    selectedGames = selectedGames.filter(g => g.id != id);
    renderFpsGames();
}

function recalcAllFps() {
    renderFpsGames();
}

function calculateEstFps(game) {
    const cpu = currentBuild['cpu'];
    const vga = currentBuild['vga'];

    if (!cpu || !vga) return '?';

    let pcCpuTier = 2;
    if (cpu.name.toLowerCase().includes('i9') || cpu.name.toLowerCase().includes('ryzen 9')) pcCpuTier = 9;
    else if (cpu.name.toLowerCase().includes('i7') || cpu.name.toLowerCase().includes('ryzen 7')) pcCpuTier = 7;
    else if (cpu.name.toLowerCase().includes('i5') || cpu.name.toLowerCase().includes('ryzen 5')) pcCpuTier = 5;
    else if (cpu.name.toLowerCase().includes('i3') || cpu.name.toLowerCase().includes('ryzen 3')) pcCpuTier = 3;

    let pcVgaTier = 2;
    const vName = vga.name.toLowerCase();
    if (vName.includes('4090') || vName.includes('5090')) pcVgaTier = 10;
    else if (vName.includes('4080') || vName.includes('7900') || vName.includes('4070 ti')) pcVgaTier = 8.5;
    else if (vName.includes('4070') || vName.includes('7800')) pcVgaTier = 7;
    else if (vName.includes('4060') || vName.includes('3060') || vName.includes('7600')) pcVgaTier = 5;
    else if (vName.includes('1650') || vName.includes('1050')) pcVgaTier = 3;

    let reqMinStr = game.req_min ? game.req_min.toLowerCase() : '';
    let reqRecStr = game.req_rec ? game.req_rec.toLowerCase() : '';

    function parseTier(text) {
        if (!text) return { cpu: 1, vga: 1 };
        let gCpu = 3;
        let gVga = 2;

        if (text.includes('i9') || text.includes('ryzen 9')) gCpu = 8;
        else if (text.includes('i7') || text.includes('ryzen 7')) gCpu = 6;
        else if (text.includes('i5') || text.includes('ryzen 5')) gCpu = 4;

        if (text.includes('4090') || text.includes('4080') || text.includes('7900')) gVga = 9;
        else if (text.includes('4070') || text.includes('3080') || text.includes('6800')) gVga = 7;
        else if (text.includes('4060') || text.includes('3060') || text.includes('2070')) gVga = 5;
        else if (text.includes('1070') || text.includes('1660') || text.includes('1060') || text.includes('rx 580')) gVga = 3;

        return { cpu: gCpu, vga: gVga };
    }

    const minReq = parseTier(reqMinStr);
    const recReq = parseTier(reqRecStr);

    const targetVga = (recReq.vga > 1) ? recReq.vga : (minReq.vga > 1 ? minReq.vga + 2 : 3);
    const targetCpu = (recReq.cpu > 1) ? recReq.cpu : (minReq.cpu > 1 ? minReq.cpu + 2 : 4);

    let vgaRatio = pcVgaTier / targetVga;
    let cpuRatio = pcCpuTier / targetCpu;

    let performanceScore = (vgaRatio * 0.7) + (cpuRatio * 0.3);

    let estFps = performanceScore * 60;

    if (estFps > 144) {
        estFps = 144 + ((performanceScore - 2.4) * 50);
    }
    if (estFps > 350) estFps = 350;

    return Math.round(estFps);
}

// Ensure first render is empty
document.addEventListener('DOMContentLoaded', () => {
    setTimeout(renderFpsGames, 500);
});

function showToast(msg) {
    let toastContainer = document.getElementById('toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toast-container';
        toastContainer.style.position = 'fixed';
        toastContainer.style.bottom = '30px';
        toastContainer.style.right = '30px';
        toastContainer.style.zIndex = '10000';
        toastContainer.style.display = 'flex';
        toastContainer.style.flexDirection = 'column';
        toastContainer.style.gap = '10px';
        document.body.appendChild(toastContainer);
    }

    const toast = document.createElement('div');
    toast.style.background = '#ffffff';
    toast.style.color = '#333';
    toast.style.padding = '14px 24px';
    toast.style.borderRadius = '8px';
    toast.style.boxShadow = '0 10px 30px rgba(0,0,0,0.3)';
    toast.style.transform = 'translateX(120%)';
    toast.style.opacity = '0';
    toast.style.transition = 'all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55)';
    toast.style.fontWeight = '600';
    toast.style.fontSize = '15px';
    toast.style.display = 'flex';
    toast.style.alignItems = 'center';
    toast.style.gap = '12px';
    toast.style.borderLeft = '5px solid #0056b3';

    toast.innerHTML = `<i class="fa-solid fa-circle-check" style="color:#10b981; font-size: 18px;"></i> <span>${msg}</span>`;

    toastContainer.appendChild(toast);

    // Trigger animation
    setTimeout(() => {
        toast.style.transform = 'translateX(0)';
        toast.style.opacity = '1';
    }, 10);

    // Remove after 3.5s
    setTimeout(() => {
        toast.style.transform = 'translateX(120%)';
        toast.style.opacity = '0';
        setTimeout(() => {
            toast.remove();
        }, 500);
    }, 3500);
}

function addBuildToCart() {
    let items = [];
    for (const prod of Object.values(currentBuild)) {
        items.push(prod.id);
    }

    if (items.length === 0) return;

    fetch('/api/cart/add-build', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(items)
    })
        .then(res => {
            if (res.ok) {
                window.location.href = '/cart';
            } else if (res.status === 401) {
                window.location.href = '/auth/login';
            } else {
                showToast('Lỗi khi thêm vào giỏ hàng');
            }
        })
        .catch(err => {
            showToast('Lỗi kết nối');
        });
}

// ==========================================
// ACTION BUTTONS (Guide, Save, Share, Clear)
// ==========================================

function clearBuild() {
    Swal.fire({
        title: 'Bạn chắc chắn muốn xóa?',
        text: "Toàn bộ linh kiện đã chọn sẽ bị xóa khỏi cấu hình!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#6b7280',
        confirmButtonText: 'Xóa tất cả',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            Object.keys(currentBuild).forEach(key => currentBuild[key] = null);
            ['cpu', 'mainboard', 'ram', 'vga', 'ssd', 'psu', 'case', 'cooling'].forEach(cat => updateUI(cat));
            updateTotalPrice();
            checkCompatibility();
            Swal.fire('Đã xóa!', 'Cấu hình đã được làm mới.', 'success');
        }
    });
}

function showBuildGuide() {
    Swal.fire({
        title: '<strong style="color:#0056b3">Hướng Dẫn Build PC Cơ Bản</strong>',
        html: `
            <div style="text-align: left; font-size: 14px; line-height: 1.6;">
                <p><b>Bước 1: Chọn CPU (Vi xử lý)</b><br>Là bộ não của máy, quyết định hiệu năng tổng thể.</p>
                <p><b>Bước 2: Chọn Mainboard (Bo mạch chủ)</b><br>Cần chú ý Socket phải tương thích với CPU.</p>
                <p><b>Bước 3: Chọn RAM (Bộ nhớ trong)</b><br>Tối thiểu 8GB cho văn phòng, 16GB trở lên để chơi Game.</p>
                <p><b>Bước 4: Chọn VGA (Card màn hình)</b><br>Rất quan trọng nếu bạn muốn chơi game nặng hoặc làm đồ họa.</p>
                <p><b>Bước 5: Chọn Ổ Cứng (SSD/HDD)</b><br>Nên có ít nhất 1 ổ SSD để máy khởi động và chạy ứng dụng nhanh.</p>
                <p><b>Bước 6: Chọn PSU (Nguồn)</b><br>Công suất cần đủ gánh CPU và VGA (thường từ 450W - 750W).</p>
                <p><b>Bước 7: Vỏ Case & Tản nhiệt</b><br>Đảm bảo Case gắn vừa Mainboard và Tản nhiệt mát mẻ.</p>
                <hr>
                <i>Hệ thống tự động kiểm tra tương thích của chúng tôi sẽ giúp bạn an tâm tuyệt đối!</i>
            </div>
        `,
        icon: 'info',
        confirmButtonText: 'Đã hiểu!',
        confirmButtonColor: '#0056b3',
        width: 600
    });
}

async function saveBuild() {
    const buildData = {};
    Object.keys(currentBuild).forEach(key => {
        if (currentBuild[key]) {
            buildData[key] = currentBuild[key].id;
        }
    });

    if (Object.keys(buildData).length === 0) {
        showToast('Lỗi: Cấu hình của bạn đang trống!');
        return;
    }

    let savedBuilds = JSON.parse(localStorage.getItem('luxury_saved_builds') || '[]');

    const { value: buildName } = await Swal.fire({
        title: 'Nhập tên cấu hình',
        input: 'text',
        inputLabel: 'Tên cấu hình (VD: PC Văn Phòng, PC Gaming...)',
        inputPlaceholder: 'Nhập tên...',
        showCancelButton: true,
        inputValidator: (value) => {
            if (!value) {
                return 'Bạn cần nhập tên cấu hình!'
            }
        }
    });

    if (!buildName) return; // User cancelled

    const newBuild = {
        name: buildName,
        date: new Date().toLocaleDateString('vi-VN'),
        data: buildData
    };

    if (savedBuilds.length >= 3) {
        // Ask to replace
        const inputOptions = {};
        savedBuilds.forEach((b, index) => {
            inputOptions[index] = `${b.name} (${b.date})`;
        });

        const { value: indexToReplace } = await Swal.fire({
            title: 'Danh sách cấu hình đã đầy',
            text: 'Bạn chỉ được lưu tối đa 3 cấu hình. Vui lòng chọn 1 cấu hình cũ để ghi đè:',
            input: 'radio',
            inputOptions: inputOptions,
            inputValidator: (value) => {
                if (!value && value !== 0 && value !== '0') {
                    return 'Bạn phải chọn 1 cấu hình để ghi đè!'
                }
            },
            showCancelButton: true
        });

        if (indexToReplace !== undefined && indexToReplace !== null) {
            savedBuilds[indexToReplace] = newBuild;
            localStorage.setItem('luxury_saved_builds', JSON.stringify(savedBuilds));
            showToast('Đã ghi đè cấu hình thành công!');
        }
    } else {
        savedBuilds.push(newBuild);
        localStorage.setItem('luxury_saved_builds', JSON.stringify(savedBuilds));
        showToast('Đã lưu cấu hình thành công!');
    }
}

async function manualLoadBuild() {
    let savedBuilds = JSON.parse(localStorage.getItem('luxury_saved_builds') || '[]');

    if (savedBuilds.length === 0) {
        // Fallback for old single save format migration
        const oldSave = localStorage.getItem('luxury_saved_build');
        if (oldSave) {
            savedBuilds.push({
                name: 'Cấu hình cũ',
                date: new Date().toLocaleDateString('vi-VN'),
                data: JSON.parse(oldSave)
            });
            localStorage.setItem('luxury_saved_builds', JSON.stringify(savedBuilds));
            localStorage.removeItem('luxury_saved_build');
        } else {
            Swal.fire('Thông báo', 'Bạn chưa lưu cấu hình nào!', 'info');
            return;
        }
    }

    let htmlContent = '<div style="display:flex; flex-direction:column; gap:10px; text-align:left;">';
    savedBuilds.forEach((b, index) => {
        htmlContent += `
            <div style="padding:15px; border:1px solid #ddd; border-radius:8px; display:flex; justify-content:space-between; align-items:center;">
                <div>
                    <strong style="font-size:16px;">${b.name}</strong><br>
                    <small style="color:#666;">Lưu ngày: ${b.date}</small>
                </div>
                <div style="display:flex; gap:10px; flex-shrink: 0; align-items: center;">
                    <button class="btn btn-primary btn-sm" style="padding:5px 15px; white-space:nowrap;" onclick="Swal.close(); window.loadSelectedBuild(${index})">Tải</button>
                    <button class="btn btn-danger btn-sm" style="padding:5px 15px;" onclick="Swal.close(); window.deleteSelectedBuild(${index})"><i class="fa-regular fa-trash-can"></i></button>
                </div>
            </div>
        `;
    });
    htmlContent += '</div>';

    Swal.fire({
        title: 'Danh sách cấu hình đã lưu',
        html: htmlContent,
        showConfirmButton: false,
        showCancelButton: true,
        cancelButtonText: 'Đóng'
    });
}

window.loadSelectedBuild = function (index) {
    let savedBuilds = JSON.parse(localStorage.getItem('luxury_saved_builds') || '[]');
    if (savedBuilds[index]) {
        loadBuildFromIds(savedBuilds[index].data);
        showToast(`Đã khôi phục: ${savedBuilds[index].name}`);
    }
};

window.deleteSelectedBuild = function (index) {
    let savedBuilds = JSON.parse(localStorage.getItem('luxury_saved_builds') || '[]');
    if (savedBuilds[index]) {
        Swal.fire({
            title: 'Xác nhận xóa',
            text: `Bạn có chắc muốn xóa cấu hình "${savedBuilds[index].name}"?`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Xóa',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                savedBuilds.splice(index, 1);
                localStorage.setItem('luxury_saved_builds', JSON.stringify(savedBuilds));
                showToast('Đã xóa cấu hình!');
                setTimeout(() => manualLoadBuild(), 300); // Reopen the modal
            }
        });
    }
};

async function shareBuild() {
    let hasItems = false;
    const payload = { totalPrice: 0 };

    const mapping = {
        'cpu': 'cpuId',
        'mainboard': 'mainboardId',
        'ram': 'ramId',
        'vga': 'gpuId',
        'ssd': 'storageId',
        'psu': 'psuId',
        'case': 'caseId',
        'cooling': 'coolerId'
    };

    Object.keys(currentBuild).forEach(key => {
        if (currentBuild[key]) {
            hasItems = true;
            payload[mapping[key]] = String(currentBuild[key].id);
            payload.totalPrice += currentBuild[key].price;
        }
    });

    if (!hasItems) {
        showToast('Lỗi: Cấu hình của bạn đang trống!');
        return;
    }

    Swal.fire({ title: 'Đang tạo link...', allowOutsideClick: false, didOpen: () => Swal.showLoading() });

    try {
        const res = await fetch('/api/build/share', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });
        const data = await res.json();
        if (data.success) {
            Swal.close();
            const shareUrl = window.location.origin + '/build-pc?share=' + data.shareCode;
            document.getElementById('shareUrlInput').value = shareUrl;

            // Generate QR
            const qrContainer = document.getElementById('qrCodeContainer');
            qrContainer.innerHTML = '';
            new QRCode(qrContainer, {
                text: shareUrl,
                width: 150,
                height: 150,
                colorDark: "#000000",
                colorLight: "#ffffff",
                correctLevel: QRCode.CorrectLevel.H
            });

            document.getElementById('shareModal').classList.add('active');
        } else {
            Swal.fire('Lỗi', 'Không thể tạo link chia sẻ.', 'error');
        }
    } catch (error) {
        console.error(error);
        Swal.fire('Lỗi', 'Có lỗi kết nối xảy ra.', 'error');
    }
}

// Function to load build from IDs (used for both LocalStorage and Shared link)
async function loadBuildFromIds(idsMap) {
    Swal.fire({ title: 'Đang tải cấu hình...', allowOutsideClick: false, didOpen: () => Swal.showLoading() });

    try {
        let loadedCount = 0;

        currentBuild = {
            cpu: null,
            mainboard: null,
            ram: null,
            vga: null,
            ssd: null,
            psu: null,
            case: null,
            cooling: null
        };

        Object.keys(idsMap).forEach(category => {
            const id = parseInt(idsMap[category]);
            if (id && productsData[category]) {
                const prod = productsData[category].find(p => p.id === id);
                if (prod) {
                    currentBuild[category] = prod;
                    loadedCount++;
                } else {
                    console.error("Không tìm thấy sản phẩm có id", id, "trong danh mục", category);
                }
            }
        });

        // Cập nhật lại giao diện
        renderBuildComponents();
        calculateTotals();
        renderFpsGames();

        if (loadedCount > 0) {
            Swal.close();
            setTimeout(() => {
                Swal.fire({
                    title: 'Thành công!',
                    text: 'Cấu hình đã được tải hoàn tất.',
                    icon: 'success',
                    showConfirmButton: true,
                    confirmButtonText: 'OK'
                });
            }, 300);
        } else {
            Swal.close();
            setTimeout(() => {
                Swal.fire({
                    title: 'Thông báo',
                    text: 'Không tìm thấy linh kiện nào trong cấu hình này.',
                    icon: 'info',
                    showConfirmButton: true,
                    confirmButtonText: 'OK'
                });
            }, 300);
        }
    } catch (e) {
        console.error(e);
        Swal.fire('Lỗi', 'Có lỗi khi tải cấu hình.', 'error');
    }
}

async function loadSharedBuild(shareCode) {
    Swal.fire({ title: 'Đang tìm cấu hình được chia sẻ...', allowOutsideClick: false, didOpen: () => Swal.showLoading() });
    try {
        const res = await fetch(`/api/build/share/${shareCode}`);
        if (!res.ok) {
            Swal.fire('Rất tiếc', 'Link chia sẻ không tồn tại hoặc đã hết hạn!', 'error');
            return;
        }
        const build = await res.json();

        const idsMap = {
            'cpu': build.cpuId,
            'mainboard': build.mainboardId,
            'ram': build.ramId,
            'vga': build.gpuId,
            'ssd': build.storageId,
            'psu': build.psuId,
            'case': build.caseId,
            'cooling': build.coolerId
        };

        // Remove history so URL is clean
        window.history.replaceState({}, document.title, "/build-pc");

        loadBuildFromIds(idsMap);

    } catch (e) {
        Swal.fire('Lỗi', 'Không thể kết nối để lấy dữ liệu.', 'error');
    }
}

// Check URL and LocalStorage on Startup
document.addEventListener("DOMContentLoaded", () => {
    // Delay slightly to let products load if needed
    setTimeout(() => {
        const urlParams = new URLSearchParams(window.location.search);
        const shareCode = urlParams.get('share');
        if (shareCode) {
            loadSharedBuild(shareCode);
        }
    }, 1000);
});

// Consultation Support Handler - Opens Socket Chatbox according to permissions & predefined structure
function openConsultationSupport() {
    let initialMsg = '';
    if (typeof currentBuild !== 'undefined' && currentBuild && Object.keys(currentBuild).length > 0) {
        const compList = [];
        for (const [slotId, prod] of Object.entries(currentBuild)) {
            if (prod && prod.name) {
                compList.push(`${slotId.toUpperCase()}: ${prod.name}`);
            }
        }
        if (compList.length > 0) {
            initialMsg = 'Tôi cần hỗ trợ tư vấn cấu hình PC đang chọn: ' + compList.join(', ');
        }
    }

    if (typeof window.openSocketChatWindow === 'function') {
        window.openSocketChatWindow(initialMsg);
    } else {
        const socketChatBtn = document.getElementById('socketChatBtn');
        if (socketChatBtn) {
            socketChatBtn.click();
            if (initialMsg) {
                const msgInput = document.getElementById('socketChatMsgInput');
                if (msgInput) msgInput.value = initialMsg;
            }
        } else {
            if (typeof showToast === 'function') {
                showToast('Tài khoản Quản trị/Nhân viên quản lý tư vấn tại trang Quản Lý Tickets Admin.');
            } else {
                alert('Tài khoản Quản trị/Nhân viên quản lý tư vấn tại trang Quản Lý Tickets Admin.');
            }
        }
    }
}
