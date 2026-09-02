/**
 * Luxury PC - Admin Orders Management JS
 * Handles Order Details Modal, Webhook simulations, and UI helpers
 */

// Format currency to VND format (e.g. 1.250.000₫)
function formatCurrency(amount) {
    if (amount === null || amount === undefined || isNaN(amount)) {
        return '0₫';
    }
    return new Intl.NumberFormat('vi-VN').format(Math.round(amount)) + '₫';
}

// Escape HTML to prevent XSS
function escapeHtml(text) {
    if (!text) return '';
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return String(text).replace(/[&<>"']/g, function(m) { return map[m]; });
}

// Open Order Detail Modal
function openOrderDetailModal(orderId) {
    const modal = document.getElementById('orderDetailModal');
    if (!modal) return;

    const modalBody = document.getElementById('orderDetailModalBody');
    const modalHeaderTitle = document.getElementById('orderDetailModalTitle');
    
    if (modalHeaderTitle) {
        modalHeaderTitle.innerHTML = `<i class="fa-solid fa-file-invoice" style="color: #0066CC; margin-right: 8px;"></i> Chi Tiết Đơn Hàng #${orderId}`;
    }

    modal.style.display = 'flex';
    modal.classList.add('active');
    document.body.style.overflow = 'hidden';

    // Show loading state
    if (modalBody) {
        modalBody.innerHTML = `
            <div style="text-align: center; padding: 3rem 1rem; color: #64748b;">
                <i class="fa-solid fa-circle-notch fa-spin" style="font-size: 2.2rem; color: #0066CC; margin-bottom: 1rem;"></i>
                <div style="font-size: 0.95rem; font-weight: 500;">Đang tải thông tin đơn hàng #${orderId}...</div>
            </div>
        `;
    }

    // Fetch order details from API
    fetch(`/admin/orders/${orderId}/detail`)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(res => {
            if (res.success && res.data) {
                renderOrderDetail(res.data);
            } else {
                showModalError(res.message || 'Không thể lấy thông tin chi tiết đơn hàng.');
            }
        })
        .catch(err => {
            console.error('Error fetching order detail:', err);
            showModalError('Lỗi kết nối máy chủ khi tải chi tiết đơn hàng.');
        });
}

// Show Error in Modal
function showModalError(msg) {
    const modalBody = document.getElementById('orderDetailModalBody');
    if (modalBody) {
        modalBody.innerHTML = `
            <div style="text-align: center; padding: 2.5rem 1rem; color: #dc2626;">
                <i class="fa-solid fa-triangle-exclamation" style="font-size: 2.5rem; margin-bottom: 0.75rem;"></i>
                <div style="font-size: 1rem; font-weight: 600; margin-bottom: 0.5rem;">Không Thể Tải Dữ Liệu</div>
                <div style="font-size: 0.85rem; color: #64748b; margin-bottom: 1.25rem;">${escapeHtml(msg)}</div>
                <button type="button" class="btn btn-gold" onclick="closeOrderDetailModal()" style="padding: 0.45rem 1.25rem; font-size: 0.82rem; border-radius: 6px; cursor: pointer;">Đóng</button>
            </div>
        `;
    }
}

// Render Order Detail HTML
function renderOrderDetail(order) {
    const modalBody = document.getElementById('orderDetailModalBody');
    if (!modalBody) return;

    const modalHeaderTitle = document.getElementById('orderDetailModalTitle');
    if (modalHeaderTitle) {
        modalHeaderTitle.innerHTML = `
            <div style="display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                <i class="fa-solid fa-file-invoice" style="color: #0066CC;"></i>
                <span>Chi Tiết Đơn Hàng: <strong style="color: #0f172a;">${escapeHtml(order.orderCode)}</strong></span>
                <span class="badge ${escapeHtml(order.statusBadgeClass)}" style="font-size: 0.72rem; padding: 0.2rem 0.55rem; border-radius: 12px; margin-left: 6px;">
                    ${escapeHtml(order.statusDisplay)}
                </span>
            </div>
        `;
    }

    // Items list rows (Modern Card List layout - robust across all browsers and screen sizes)
    let itemsHtml = '';
    if (order.items && order.items.length > 0) {
        itemsHtml = order.items.map((item, index) => {
            const imgSrc = item.productImage 
                ? (item.productImage.startsWith('http') || item.productImage.startsWith('/') ? item.productImage : '/images/products/' + item.productImage)
                : '';
            
            const imgTag = imgSrc 
                ? `<img src="${escapeHtml(imgSrc)}" alt="${escapeHtml(item.productName)}" onerror="this.onerror=null; this.src='https://placehold.co/60x60/f1f5f9/94a3b8?text=LuxuryPC';" style="width: 52px; height: 52px; object-fit: contain; border-radius: 8px; background: #fff; border: 1px solid #e2e8f0; padding: 2px; flex-shrink: 0;">`
                : `<div style="width: 52px; height: 52px; border-radius: 8px; background: #f1f5f9; border: 1px solid #e2e8f0; display: flex; align-items: center; justify-content: center; font-size: 0.68rem; color: #94a3b8; text-align: center; flex-shrink: 0;">No Pic</div>`;

            return `
                <div class="order-item-card" style="display: flex; align-items: center; justify-content: space-between; padding: 10px 14px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 8px; gap: 12px;">
                    <div style="display: flex; align-items: center; gap: 12px; flex: 1; min-width: 0;">
                        <span style="color: #94a3b8; font-size: 0.78rem; font-weight: 700; width: 22px; text-align: center;">#${index + 1}</span>
                        ${imgTag}
                        <div style="min-width: 0; flex: 1;">
                            <div style="font-weight: 600; color: #0f172a; font-size: 0.88rem; line-height: 1.35; white-space: normal; word-break: break-word;">
                                ${escapeHtml(item.productName)}
                            </div>
                            <div style="font-size: 0.72rem; color: #64748b; margin-top: 3px; display: flex; gap: 8px; flex-wrap: wrap; align-items: center;">
                                ${item.brand ? `<span style="background: #f1f5f9; padding: 1px 6px; border-radius: 4px;">Hãng: <strong style="color: #334155;">${escapeHtml(item.brand)}</strong></span>` : ''}
                                ${item.categoryName ? `<span style="background: #f1f5f9; padding: 1px 6px; border-radius: 4px;">Loại: <strong style="color: #334155;">${escapeHtml(item.categoryName)}</strong></span>` : ''}
                                <span style="color: #64748b;">Đơn giá: <strong style="color: #475569;">${formatCurrency(item.price)}</strong></span>
                            </div>
                        </div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 14px; flex-shrink: 0; text-align: right;">
                        <div style="font-weight: 700; color: #0066CC; font-size: 0.85rem; background: #eff6ff; padding: 3px 8px; border-radius: 6px; border: 1px solid #bfdbfe;">
                            SL: ×${item.quantity}
                        </div>
                        <div style="font-weight: 700; color: #0066CC; font-size: 0.95rem; min-width: 95px; text-align: right;">
                            ${formatCurrency(item.itemTotal)}
                        </div>
                    </div>
                </div>
            `;
        }).join('');
    } else {
        itemsHtml = `
            <div style="text-align: center; padding: 1.5rem; color: #94a3b8; font-size: 0.85rem; background: #fff; border-radius: 8px; border: 1px dashed #e2e8f0;">
                <i class="fa-solid fa-box-open" style="font-size: 1.5rem; margin-bottom: 6px; display: block; color: #cbd5e1;"></i>
                Không có sản phẩm nào trong đơn hàng này.
            </div>
        `;
    }

    // Payment method badge styling
    let payChipClass = 'pay-chip';
    if (order.paymentMethod === 'VIETQR' || order.paymentMethod === 'SEPAY') {
        payChipClass += ' vietqr';
    } else if (order.paymentMethod === 'COD') {
        payChipClass += ' cod';
    }

    // Notes section HTML
    let notesHtml = '';
    if (order.adminNote || order.refundReason) {
        notesHtml = `
            <div class="modal-card" style="margin-top: 1rem; border-left: 4px solid #0066CC;">
                <div class="modal-card-title"><i class="fa-solid fa-clipboard-list" style="color: #0066CC;"></i> Ghi Chú & Yêu Cầu</div>
                <div style="display: grid; gap: 0.5rem; font-size: 0.82rem;">
                    ${order.refundReason ? `
                        <div style="background: #fffbeb; padding: 8px 12px; border-radius: 6px; border: 1px solid #fef3c7;">
                            <span style="font-weight: 700; color: #b45309; text-transform: uppercase; font-size: 0.7rem; margin-right: 6px;">
                                <i class="fa-solid fa-user"></i> Khách hàng:
                            </span>
                            <span style="color: #78350f;">${escapeHtml(order.refundReason)}</span>
                        </div>
                    ` : ''}
                    ${order.adminNote ? `
                        <div style="background: #f0f9ff; padding: 8px 12px; border-radius: 6px; border: 1px solid #e0f2fe;">
                            <span style="font-weight: 700; color: #0369a1; text-transform: uppercase; font-size: 0.7rem; margin-right: 6px;">
                                <i class="fa-solid fa-shield-halved"></i> Quản trị viên:
                            </span>
                            <span style="color: #0c4a6e;">${escapeHtml(order.adminNote)}</span>
                        </div>
                    ` : ''}
                </div>
            </div>
        `;
    }

    modalBody.innerHTML = `
        <div class="order-detail-layout">
            <!-- Left Column: Products List & Notes -->
            <div style="display: flex; flex-direction: column; gap: 1rem; min-width: 0;">
                <!-- Product Items Section -->
                <div class="modal-card" style="padding: 0; overflow: hidden; border: 1px solid #cbd5e1;">
                    <div style="padding: 0.85rem 1rem; background: #f8fafc; border-bottom: 1px solid #e2e8f0; font-weight: 700; font-size: 0.88rem; color: #0f172a; display: flex; justify-content: space-between; align-items: center;">
                        <span><i class="fa-solid fa-boxes-stacked" style="color: #0066CC; margin-right: 6px;"></i> Sản Phẩm Đã Đặt</span>
                        <span style="font-size: 0.78rem; font-weight: 700; color: #0066CC; background: #eff6ff; padding: 2px 10px; border-radius: 12px; border: 1px solid #bfdbfe;">
                            ${(order.items || []).length} món
                        </span>
                    </div>
                    <div class="order-items-list-container" style="max-height: 520px; overflow-y: auto; padding: 10px; display: flex; flex-direction: column; gap: 10px; background: #f8fafc;">
                        ${itemsHtml}
                    </div>
                </div>

                ${notesHtml}
            </div>

            <!-- Right Column: Customer, Shipping & Financial Summary -->
            <div style="display: flex; flex-direction: column; gap: 1rem; min-width: 0;">
                <!-- Customer & Shipping Information -->
                <div class="modal-card">
                    <div class="modal-card-title">
                        <i class="fa-solid fa-user-tag" style="color: #0066CC;"></i> Người Nhận & Địa Chỉ
                    </div>
                    <div class="info-table">
                        <div class="info-row">
                            <span class="info-label">Người nhận:</span>
                            <span class="info-val font-bold" style="color: #0f172a;">${escapeHtml(order.fullName || 'Khách vãng lai')}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Số điện thoại:</span>
                            <span class="info-val">
                                <a href="tel:${escapeHtml(order.phone || '')}" style="color: #0066CC; font-weight: 600; text-decoration: none;">
                                    <i class="fa-solid fa-phone" style="font-size: 0.72rem; margin-right: 4px;"></i>${escapeHtml(order.phone || 'Chưa cập nhật')}
                                </a>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Email:</span>
                            <span class="info-val" style="word-break: break-all;">
                                ${order.email ? `<a href="mailto:${escapeHtml(order.email)}" style="color: #475569; text-decoration: none;">${escapeHtml(order.email)}</a>` : '-'}
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Địa chỉ giao:</span>
                            <span class="info-val" style="color: #1e293b; font-weight: 500; line-height: 1.4;">
                                <i class="fa-solid fa-location-dot" style="color: #ef4444; font-size: 0.75rem; margin-right: 4px;"></i>
                                ${escapeHtml(order.address || '')}${order.city ? ', ' + escapeHtml(order.city) : ''}
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Tài khoản:</span>
                            <span class="info-val">
                                ${order.username ? `<span style="background: #f1f5f9; padding: 2px 8px; border-radius: 4px; font-weight: 600; font-size: 0.75rem; color: #334155;">@${escapeHtml(order.username)}</span>` : '<span style="color: #94a3b8; font-style: italic;">Khách vãng lai</span>'}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Payment & Order State -->
                <div class="modal-card">
                    <div class="modal-card-title">
                        <i class="fa-solid fa-receipt" style="color: #0066CC;"></i> Trạng Thái & Giao Hàng
                    </div>
                    <div class="info-table">
                        <div class="info-row">
                            <span class="info-label">Ngày đặt:</span>
                            <span class="info-val" style="font-weight: 600; color: #1e293b;">
                                <i class="fa-regular fa-calendar-check" style="color: #64748b; font-size: 0.75rem; margin-right: 4px;"></i>
                                ${escapeHtml(order.createdAtFormatted || '-')}
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Thanh toán:</span>
                            <span class="info-val">
                                <span class="${payChipClass}">${escapeHtml(order.paymentMethodDisplay || order.paymentMethod || 'COD')}</span>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Đơn vị giao:</span>
                            <span class="info-val" style="font-weight: 600; color: #334155;">
                                ${escapeHtml(order.shippingMethodName || 'Giao hàng tiêu chuẩn')}
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Mã vận đơn:</span>
                            <span class="info-val">
                                ${order.trackingCode 
                                    ? `<span style="font-family: monospace; font-weight: 700; color: #0284c7; background: #e0f2fe; padding: 2px 8px; border-radius: 4px;"><i class="fa-solid fa-truck-fast"></i> ${escapeHtml(order.trackingCode)}</span>` 
                                    : '<span style="color: #94a3b8; font-style: italic;">Chưa tạo vận đơn</span>'}
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Trạng thái:</span>
                            <span class="info-val">
                                <span class="badge ${escapeHtml(order.statusBadgeClass)}">${escapeHtml(order.statusDisplay)}</span>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Financial Summary Breakdown Card -->
                <div class="modal-card" style="background: #ffffff; border: 1px solid #cbd5e1;">
                    <div class="modal-card-title" style="margin-bottom: 0.75rem;">
                        <i class="fa-solid fa-calculator" style="color: #0066CC;"></i> Chi Tiết Thanh Toán
                    </div>
                    <div class="summary-breakdown">
                        <div class="summary-row">
                            <span class="summary-label">Tạm tính tiền hàng:</span>
                            <span class="summary-val font-semibold">${formatCurrency(order.subtotal)}</span>
                        </div>

                        ${order.voucherCode ? `
                            <div class="summary-row" style="color: #dc2626;">
                                <span class="summary-label">
                                    <i class="fa-solid fa-ticket" style="margin-right: 4px;"></i> Voucher (${escapeHtml(order.voucherCode)}):
                                </span>
                                <span class="summary-val font-bold">-${formatCurrency(order.discountAmount || 0)}</span>
                            </div>
                        ` : ''}

                        ${order.vipDiscount && order.vipDiscount > 0 ? `
                            <div class="summary-row" style="color: #d97706;">
                                <span class="summary-label">
                                    <i class="fa-solid fa-crown" style="margin-right: 4px;"></i> Ưu đãi Hạng VIP:
                                </span>
                                <span class="summary-val font-bold">-${formatCurrency(order.vipDiscount)}</span>
                            </div>
                        ` : ''}

                        <div class="summary-row">
                            <span class="summary-label">Phí vận chuyển:</span>
                            <span class="summary-val">${order.shippingFee && order.shippingFee > 0 ? formatCurrency(order.shippingFee) : '<span style="color: #16a34a; font-weight: 600;">Miễn phí</span>'}</span>
                        </div>

                        ${order.freeshipDiscount && order.freeshipDiscount > 0 ? `
                            <div class="summary-row" style="color: #16a34a;">
                                <span class="summary-label">
                                    <i class="fa-solid fa-truck" style="margin-right: 4px;"></i> Giảm ship (${escapeHtml(order.freeshipVoucherCode || 'FreeShip')}):
                                </span>
                                <span class="summary-val font-bold">-${formatCurrency(order.freeshipDiscount)}</span>
                            </div>
                        ` : ''}

                        <div class="summary-row total-row">
                            <span class="summary-label font-bold" style="font-size: 0.95rem; color: #0f172a;">TỔNG TIỀN:</span>
                            <span class="summary-val font-bold" style="font-size: 1.2rem; color: #0066CC;">
                                ${formatCurrency(order.totalPrice)}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    `;
}

// Close Order Detail Modal
function closeOrderDetailModal() {
    const modal = document.getElementById('orderDetailModal');
    if (modal) {
        modal.style.display = 'none';
        modal.classList.remove('active');
        document.body.style.overflow = '';
    }
}

// Print Order Detail
function printOrderDetail() {
    window.print();
}

// Webhook simulator handler
function sendLalamoveWebhook(btn) {
    const trackingCode = btn.getAttribute('data-tracking');
    const event = btn.getAttribute('data-event');
    btn.disabled = true;
    const originalText = btn.innerText;
    btn.innerText = 'Sending...';

    fetch('/api/webhook/lalamove', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            trackingCode: trackingCode,
            event: event
        })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            window.location.reload();
        } else {
            alert('Lỗi Webhook: ' + (data.message || 'Thao tác không thành công'));
            btn.disabled = false;
            btn.innerText = originalText;
        }
    })
    .catch(err => {
        console.error(err);
        alert('Lỗi kết nối đến Webhook!');
        btn.disabled = false;
        btn.innerText = originalText;
    });
}

// Initialize Event Listeners
function initOrderPage() {
    // Close modal on click outside modal content
    const modal = document.getElementById('orderDetailModal');
    if (modal) {
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                closeOrderDetailModal();
            }
        });
    }

    // Close modal on Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeOrderDetailModal();
        }
    });

    // Quản lý đóng mở menu thao tác một cách mượt mà và chống tràn/đè giao diện khi cuộn
    const closeAllActionMenus = (exceptDetails = null) => {
        document.querySelectorAll('details.action-menu[open]').forEach(details => {
            if (details !== exceptDetails) {
                details.removeAttribute('open');
            }
        });
    };

    // Đóng menu khi click ra ngoài
    document.addEventListener('click', function (e) {
        const clickedDetails = e.target.closest('details.action-menu');
        closeAllActionMenus(clickedDetails);
    });

    // Tự động đóng menu khi người dùng cuộn danh sách đơn hàng hoặc cuộn trang
    const tableWrapper = document.querySelector('.table-wrapper');
    if (tableWrapper) {
        tableWrapper.addEventListener('scroll', function () {
            closeAllActionMenus();
        }, { passive: true });
    }
    window.addEventListener('scroll', function () {
        closeAllActionMenus();
    }, { passive: true });

    // Tự động tính toán vị trí hiển thị (lên hoặc xuống) khi mở menu thao tác
    document.querySelectorAll('details.action-menu').forEach(details => {
        details.addEventListener('toggle', function () {
            if (this.open) {
                closeAllActionMenus(this);
                const panel = this.querySelector('.action-panel');
                if (panel) {
                    const rect = this.getBoundingClientRect();
                    const spaceBelow = window.innerHeight - rect.bottom;
                    if (spaceBelow < 280 && rect.top > 280) {
                        panel.style.top = 'auto';
                        panel.style.bottom = '100%';
                        panel.style.marginTop = '0';
                        panel.style.marginBottom = '0.4rem';
                    } else {
                        panel.style.top = '100%';
                        panel.style.bottom = 'auto';
                        panel.style.marginTop = '0.4rem';
                        panel.style.marginBottom = '0';
                    }
                }
            }
        });
    });
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initOrderPage);
} else {
    initOrderPage();
}
document.addEventListener('spa:load', initOrderPage);
