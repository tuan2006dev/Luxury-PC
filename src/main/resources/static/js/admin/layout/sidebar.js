function toggleSidebarCollapse() {
    const isCollapsed = document.body.classList.toggle('sidebar-collapsed');
    localStorage.setItem('sidebar-collapsed', isCollapsed ? 'true' : 'false');
}

if (localStorage.getItem('sidebar-collapsed') === 'true') {
    document.body.classList.add('sidebar-collapsed');
}

function toggleSidebarMenu(menuId, titleEl) {
    const menu = document.getElementById(menuId);
    const isShowing = menu.classList.contains('show');

    if (isShowing) {
        menu.classList.remove('show');
        titleEl.classList.remove('active');
    } else {
        menu.classList.add('show');
        titleEl.classList.add('active');
    }
}

document.addEventListener('DOMContentLoaded', () => {
    if (window.__spaInitialized) return;
    window.__spaInitialized = true;

    function updateSidebarActiveStatus(path) {
        document.querySelectorAll('.sub-menu a, .nav-link, .menu-title').forEach(el => el.classList.remove('active'));

        const linkMap = {
            '/admin/dashboard': 'nav-dashboard',
            '/admin/products': 'nav-products',
            '/admin/categories': 'nav-categories',
            '/admin/combos': 'nav-combos',
            '/admin/flash-sale-items': 'nav-flash-sales',
            '/admin/flash-sales': 'nav-flash-sales',
            '/admin/inventory': 'nav-inventory',
            '/admin/orders': 'nav-orders',
            '/admin/employees': 'nav-employees',
            '/admin/account': 'nav-account',
            '/admin/vouchers': 'nav-vouchers',
            '/admin/tickets': 'nav-tickets',
            '/admin/reviews': 'nav-reviews',
            '/admin/news-categories': 'nav-news-categories',
            '/admin/news': 'nav-news'
        };

        let activeId = null;
        // Ưu tiên khớp chính xác hoặc đường dẫn dài hơn trước để tránh /admin/news ghi đè /admin/news-categories
        const sortedKeys = Object.keys(linkMap).sort((a, b) => b.length - a.length);
        for (let key of sortedKeys) {
            if (path === key || path.startsWith(key + '/') || path.startsWith(key + '?')) {
                activeId = linkMap[key];
                break;
            }
        }

        if (activeId) {
            const activeEl = document.getElementById(activeId);
            if (activeEl) {
                activeEl.classList.add('active');
                const parentMenu = activeEl.closest('.sub-menu');
                if (parentMenu) {
                    parentMenu.classList.add('show');
                    const titleEl = parentMenu.previousElementSibling;
                    if (titleEl && titleEl.classList.contains('menu-title')) {
                        titleEl.classList.add('active');
                    }
                }
            }
        }
    }

    // Init active status on load
    updateSidebarActiveStatus(window.location.pathname);
});

document.addEventListener("DOMContentLoaded", function () {
    function initFlatpickr() {
        if (typeof flatpickr !== 'undefined') {
            document.querySelectorAll("input[type='datetime-local']").forEach(input => {
                if (input.classList.contains('flatpickr-input')) return;

                let fpInstance = flatpickr(input, {
                    enableTime: true,
                    dateFormat: "Y-m-d\\TH:i",
                    altInput: true,
                    altFormat: "d/m/Y H:i",
                    time_24hr: true,
                    plugins: [new confirmDatePlugin({
                        confirmIcon: "<i class='fa-solid fa-check'></i> ",
                        confirmText: "Xác nhận",
                        showAlways: true,
                        theme: "light"
                    })]
                });

                let altInput = fpInstance.altInput;
                let existingWrapper = altInput.closest('.datetime-wrapper');
                if (!existingWrapper) {
                    let wrapper = document.createElement('div');
                    wrapper.className = 'datetime-wrapper';
                    altInput.parentNode.insertBefore(wrapper, altInput);
                    wrapper.appendChild(altInput);

                    let icon = document.createElement('i');
                    icon.className = 'fa-solid fa-calendar-days';
                    icon.onclick = function () { fpInstance.open(); };
                    wrapper.appendChild(icon);
                } else {
                    let icon = existingWrapper.querySelector('.fa-calendar-days');
                    if (icon) {
                        icon.style.cursor = 'pointer';
                        icon.onclick = function () { fpInstance.open(); };
                    }
                }
            });
        }
    }
    initFlatpickr();
    document.addEventListener('spa:load', initFlatpickr);
});

// Global translation fallback
if (typeof window.t === 'undefined') {
    window.t = function (key, defaultText) {
        return defaultText || key;
    };
}

// Global Delete Confirmation using Custom Popup
window.confirmDelete = function (formElement, message) {
    if (typeof window.showConfirm !== 'undefined') {
        window.showConfirm(message || 'Bạn có chắc chắn muốn xóa?').then((confirmed) => {
            if (confirmed) {
                formElement.submit();
            }
        });
    } else {
        if (confirm(message || 'Bạn có chắc chắn muốn xóa?')) {
            formElement.submit();
        }
    }
    return false;
};

// Global validation to prevent negative numbers in all number inputs
function initNumberValidation() {
    document.querySelectorAll('input[type="number"]').forEach(input => {
        input.removeEventListener('keydown', preventNegativeInput);
        input.removeEventListener('paste', preventNegativePaste);
        input.removeEventListener('input', enforcePositiveValue);

        input.addEventListener('keydown', preventNegativeInput);
        input.addEventListener('paste', preventNegativePaste);
        input.addEventListener('input', enforcePositiveValue);
    });
}

function preventNegativeInput(e) {
    if (e.key === '-' || e.key === '+' || e.key === 'e' || e.key === 'E') {
        e.preventDefault();
    }
}

function preventNegativePaste(e) {
    const pastedData = e.clipboardData.getData('text');
    if (pastedData.includes('-') || pastedData.includes('+') || pastedData.includes('e') || pastedData.includes('E')) {
        e.preventDefault();
    }
}

function enforcePositiveValue(e) {
    if (this.value < 0) {
        this.value = Math.abs(this.value);
    }
}

document.addEventListener('DOMContentLoaded', initNumberValidation);
document.addEventListener('spa:load', initNumberValidation);

// Prevent negative numbers and scientific notation globally on number inputs
document.addEventListener('keydown', function (e) {
    if (e.target && e.target.type === 'number') {
        if (e.key === '-' || e.key === 'e' || e.key === 'E' || e.key === '+') {
            e.preventDefault();
        }
    }
});

document.addEventListener('input', function (e) {
    if (e.target && e.target.type === 'number') {
        if (e.target.value < 0) {
            e.target.value = '';
        }
    }
});
