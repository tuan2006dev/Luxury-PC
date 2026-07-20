function formatMoney(amount) {
    return new Intl.NumberFormat('vi-VN').format(amount) + ' ₫';
}

function updateGrandTotal() {
    let grandTotal = 0;
    let totalQty = 0;
    const rows = document.querySelectorAll('.cart-item');

    if (rows.length === 0) {
        showEmptyCart();
        const cartCountEl = document.getElementById('cart-count');
        if (cartCountEl) cartCountEl.innerText = 0;
        return;
    }

    rows.forEach(row => {
        const priceEl = row.querySelector('.item-price');
        const qtyInput = row.querySelector('.no-spinner');
        if (priceEl && qtyInput) {
            const price = parseFloat(priceEl.getAttribute('data-price'));
            const qty = parseInt(qtyInput.value);
            const itemTotal = price * qty;
            const totalEl = row.querySelector('.item-total');
            if (totalEl) {
                totalEl.innerText = formatMoney(itemTotal);
            }
            grandTotal += itemTotal;
        }
    });

    totalQty = rows.length;

    const grandTotalEl = document.getElementById('grand-total');
    const subTotalEl = document.getElementById('sub-total');
    const totalQtyEl = document.getElementById('total-qty');
    const cartCountEl = document.getElementById('cart-count');

    if (grandTotalEl) grandTotalEl.innerText = formatMoney(grandTotal);
    if (subTotalEl) subTotalEl.innerText = formatMoney(grandTotal);
    if (totalQtyEl) totalQtyEl.innerText = totalQty;
    if (cartCountEl) cartCountEl.innerText = totalQty;
}

function showEmptyCart() {
    const content = document.getElementById('cart-content');
    const ajaxEmpty = document.getElementById('ajax-empty-row');
    if (content) content.style.display = 'none';
    if (ajaxEmpty) ajaxEmpty.style.display = 'block';
}

let stockAlertTimeout;
function showStockAlert(msg) {
    const alertPanel = document.getElementById('stock-alert-panel');
    const alertMsg = document.getElementById('stock-alert-msg');
    if (alertPanel && alertMsg) {
        alertMsg.innerText = msg;
        alertPanel.style.display = 'flex';
        if (stockAlertTimeout) clearTimeout(stockAlertTimeout);
        stockAlertTimeout = setTimeout(() => {
            alertPanel.style.display = 'none';
        }, 5000);
    }
}

function closeStockAlert() {
    const alertPanel = document.getElementById('stock-alert-panel');
    if (alertPanel) {
        alertPanel.style.display = 'none';
    }
}

function syncWithServer(id, quantity, qtyInput, originalQty, row, prodName) {
    fetch(`/cart/update?id=${id}&quantity=${quantity}`, { method: 'POST' })
        .then(res => res.json())
        .then(data => {
            if (!data.success) {
                showStockAlert(data.message);
                if (data.maxStock !== undefined) {
                    qtyInput.value = data.maxStock;
                    row.setAttribute('data-stock', data.maxStock);
                    updateGrandTotal();
                } else {
                    qtyInput.value = originalQty;
                    updateGrandTotal();
                }
            } else {
                closeStockAlert();
            }
        })
        .catch(err => {
            console.error("Lỗi đồng bộ server:", err);
            qtyInput.value = originalQty;
            updateGrandTotal();
        });
}

function manualQtyChange(id, input, originalQty) {
    const row = document.getElementById('row-' + id);
    const maxStock = parseInt(row.getAttribute('data-stock') || '999');
    const prodName = row.getAttribute('data-name') || 'Sản phẩm';

    let newQty = parseInt(input.value);

    // Block negative or zero
    if (isNaN(newQty) || newQty < 1) {
        newQty = 1;
    }

    // Block exceeding stock
    if (newQty > maxStock) {
        showStockAlert(`Số lượng yêu cầu vượt quá tồn kho thực tế của "${prodName}" (chỉ còn ${maxStock} sản phẩm)!`);
        newQty = maxStock;
    }

    input.value = newQty;
    updateGrandTotal();
    syncWithServer(id, newQty, input, originalQty, row, prodName);
}

function updateQty(id, delta) {
    const row = document.getElementById('row-' + id);
    const maxStock = parseInt(row.getAttribute('data-stock') || '999');
    const prodName = row.getAttribute('data-name') || 'Sản phẩm';
    const qtyInput = document.getElementById('qty-' + id);
    let currentQty = parseInt(qtyInput.value);
    let newQty = currentQty + delta;

    if (newQty > maxStock && delta > 0) {
        showStockAlert(`Số lượng yêu cầu vượt quá tồn kho thực tế của "${prodName}" (chỉ còn ${maxStock} sản phẩm)!`);
        return;
    }

    if (newQty > 0) {
        qtyInput.value = newQty;
        updateGrandTotal();
        syncWithServer(id, newQty, qtyInput, currentQty, row, prodName);
    } else {
        removeItem(id);
    }
}

async function loadTranslations() {
    const savedLang = localStorage.getItem('lang') || 'vi';
    const cachedData = localStorage.getItem('translations_cache');
    if (cachedData) {
        try {
            translations = JSON.parse(cachedData);
            setLanguage(savedLang);
        } catch (e) {
            console.error(e);
        }
    }

    try {
        const response = await fetch('/api/translations');
        translations = await response.json();
        localStorage.setItem('translations_cache', JSON.stringify(translations));
        setLanguage(savedLang);
    } catch (error) {
        console.error(error);
    }
}

function removeItem(id) {
    const msg = "Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?";

    const confirmPromise = typeof window.showConfirm === 'function'
        ? window.showConfirm(msg)
        : Promise.resolve(confirm(msg));

    confirmPromise.then(confirmed => {
        if (confirmed) {
            fetch(`/cart/remove?id=${id}`, { method: 'POST' })
                .then(response => {
                    if (response.ok) {
                        const row = document.getElementById('row-' + id);
                        if (row) {
                            row.style.transform = 'translateX(-20px)';
                            row.style.opacity = '0';
                            setTimeout(() => {
                                row.remove();
                                updateGrandTotal();
                                const successMsg = "Đã xóa sản phẩm khỏi giỏ hàng thành công!";
                                if (typeof window.showAlert === 'function') {
                                    window.showAlert({ message: successMsg, isSuccess: true });
                                }
                            }, 300);
                        } else {
                            updateGrandTotal();
                        }
                    }
                });
        }
    });
}

document.addEventListener('DOMContentLoaded', () => {
    const urlParams = new URLSearchParams(window.location.search);
    const errorMsg = urlParams.get('error');
    if (errorMsg) {
        showStockAlert(errorMsg);
    }
    if (document.getElementById('cart-item-list')) {
        updateGrandTotal();
    }
});

// Custom Cursor
(function () {
    const cur = document.getElementById('cursor');
    const fol = document.getElementById('cursor-follower');
    if (!cur || !fol) return;
    let mx = 0, my = 0, fx = 0, fy = 0;
    document.addEventListener('mousemove', e => {
        mx = e.clientX; my = e.clientY;
        cur.style.left = mx + 'px'; cur.style.top = my + 'px';
    });
    (function loop() {
        fx += (mx - fx) * 0.12; fy += (my - fy) * 0.12;
        fol.style.left = fx + 'px'; fol.style.top = fy + 'px';
        requestAnimationFrame(loop);
    })();
    document.querySelectorAll('a, button, .cart-item').forEach(el => {
        el.addEventListener('mouseenter', () => {
            cur.style.transform = 'translate(-50%,-50%) scale(2)';
            fol.style.width = '56px'; fol.style.height = '56px'; fol.style.opacity = '0.2';
        });
        el.addEventListener('mouseleave', () => {
            cur.style.transform = 'translate(-50%,-50%) scale(1)';
            fol.style.width = '36px'; fol.style.height = '36px'; fol.style.opacity = '0.45';
        });
    });
})();


