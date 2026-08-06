// WebSocket connections for admin ticket chat
var adminWsConnections = window.adminWsConnections || {}; // ticketId -> WebSocket instance
var activeTicketId = window.activeTicketId || null;
window.adminWsConnections = adminWsConnections;
window.activeTicketId = activeTicketId;

function toggleTicket(id) {
    const detail = document.getElementById('detail-' + id);
    const icon = document.getElementById('icon-' + id);

    if (detail.style.display === 'none') {
        // Close all other open tickets first
        document.querySelectorAll('.ticket-detail').forEach(d => {
            if (d.id !== 'detail-' + id) {
                d.style.display = 'none';
                const otherId = d.id.replace('detail-', '');
                const otherIcon = document.getElementById('icon-' + otherId);
                if (otherIcon) otherIcon.style.transform = 'rotate(0deg)';
                // Disconnect previous WebSocket
                disconnectTicketWs(otherId);
            }
        });

        detail.style.display = 'block';
        icon.style.transform = 'rotate(180deg)';
        activeTicketId = id;

        // Load chat messages via REST API
        loadChatMessages(id, true);

        // Connect WebSocket for realtime updates
        connectTicketWs(id);
    } else {
        detail.style.display = 'none';
        icon.style.transform = 'rotate(0deg)';
        activeTicketId = null;

        // Disconnect WebSocket
        disconnectTicketWs(id);
    }
}

// ========== WebSocket Functions ==========

function connectTicketWs(ticketId) {
    // Disconnect previous if any
    disconnectTicketWs(ticketId);

    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const host = window.location.host;
    const wsUrl = `${protocol}//${host}/chat-socket?ticketId=${ticketId}`;

    try {
        const ws = new WebSocket(wsUrl);
        adminWsConnections[ticketId] = ws;

        ws.onopen = () => {
            console.log(`[Admin WS] Connected to ticket #${ticketId}`);
        };

        ws.onmessage = (event) => {
            try {
                const data = JSON.parse(event.data);
                
                if (data.type === 'SYSTEM' && data.event === 'USER_REQUESTED_CLOSE') {
                    const content = data.content || 'Khách hàng yêu cầu đóng cuộc trò chuyện.';
                    appendSystemConfirmClose(ticketId, content);
                    return;
                }

                // Only process CUSTOMER messages (admin messages are already shown on send)
                if (data.sender === 'CUSTOMER' || (data.senderName && data.sender !== 'ADMIN')) {
                    const content = data.content || data.message || '';
                    const senderName = data.senderName || data.sender || 'Khách';
                    const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

                    appendChatBubble(ticketId, senderName, content, time, false);
                }
            } catch (e) {
                console.error('[Admin WS] Parse error:', e);
            }
        };

        ws.onerror = (error) => {
            console.error(`[Admin WS] Error on ticket #${ticketId}:`, error);
        };

        ws.onclose = () => {
            console.log(`[Admin WS] Disconnected from ticket #${ticketId}`);
            delete adminWsConnections[ticketId];

            // Auto-reconnect if this ticket is still active
            if (activeTicketId == ticketId) {
                setTimeout(() => {
                    if (activeTicketId == ticketId) {
                        connectTicketWs(ticketId);
                    }
                }, 3000);
            }
        };
    } catch (e) {
        console.error(`[Admin WS] Failed to connect to ticket #${ticketId}:`, e);
    }
}

function disconnectTicketWs(ticketId) {
    if (adminWsConnections[ticketId]) {
        adminWsConnections[ticketId].close();
        delete adminWsConnections[ticketId];
    }
}

function appendChatBubble(ticketId, senderName, content, time, isAdmin) {
    const msgContainer = document.getElementById('chat-messages-' + ticketId);
    if (!msgContainer) return;

    const wrapperClass = isAdmin ? 'admin' : 'user';
    const bubbleClass = isAdmin ? 'admin-bubble' : 'customer-bubble';

    const html = `
        <div class="chat-bubble-wrapper ${wrapperClass}">
            <div class="chat-bubble-meta">${escapeHtml(senderName)} · ${time}</div>
            <div class="message-bubble ${bubbleClass}">${escapeHtml(content)}</div>
        </div>
    `;

    // Check for duplicate (if last message matches exactly)
    const existingBubbles = msgContainer.querySelectorAll('.chat-bubble-wrapper');
    if (existingBubbles.length > 0) {
        const lastBubble = existingBubbles[existingBubbles.length - 1];
        const lastContent = lastBubble.querySelector('.message-bubble');
        if (lastContent && lastContent.textContent.trim() === content.trim()) {
            const lastMeta = lastBubble.querySelector('.chat-bubble-meta');
            if (lastMeta && lastMeta.textContent.includes(senderName)) {
                return; // Duplicate, skip
            }
        }
    }

    msgContainer.insertAdjacentHTML('beforeend', html);

    // Auto-scroll
    const isNearBottom = msgContainer.scrollHeight - msgContainer.clientHeight - msgContainer.scrollTop < 60;
    if (isNearBottom) {
        msgContainer.scrollTop = msgContainer.scrollHeight;
    }
}

function appendSystemConfirmClose(ticketId, content) {
    const msgContainer = document.getElementById('chat-messages-' + ticketId);
    if (!msgContainer) return;

    const html = `
        <div class="chat-bubble-wrapper system-msg" style="text-align: center; margin: 10px 0; width: 100%;">
            <div style="background:#fff3cd; color:#856404; padding: 12px; border-radius: 8px; font-size: 0.9em; border: 1px solid #ffeeba; display: inline-block; max-width: 80%;">
                <strong>⚠️ Yêu cầu từ khách hàng</strong><br/>
                ${escapeHtml(content)}<br/>
                <button onclick="confirmCloseTicket(${ticketId})" style="margin-top: 10px; background:#dc3545; color:white; border:none; padding:6px 12px; border-radius:4px; cursor:pointer; font-weight:600;">Xác nhận đóng</button>
            </div>
        </div>
    `;

    msgContainer.insertAdjacentHTML('beforeend', html);
    msgContainer.scrollTop = msgContainer.scrollHeight;
}

function confirmCloseTicket(id) {
    updateTicketStatus(id, 'CLOSED');
    
    const msgContainer = document.getElementById('chat-messages-' + id);
    if (msgContainer) {
        msgContainer.insertAdjacentHTML('beforeend', `
            <div style="text-align: center; margin: 15px 0; color: #28a745; font-size: 0.9em; font-weight: bold;">
                <i class="fa-solid fa-check-circle"></i> Đã đóng cuộc trò chuyện thành công.
            </div>
        `);
        msgContainer.scrollTop = msgContainer.scrollHeight;
    }
}

// ========== REST API Functions ==========

function loadChatMessages(id, shouldScroll) {
    fetch(`/api/tickets/${id}/messages`)
        .then(res => res.json())
        .then(messages => {
            const msgContainer = document.getElementById('chat-messages-' + id);
            if (!msgContainer) return;

            if (messages.length === 0) {
                msgContainer.innerHTML = '<div class="no-reply-note"><i class="fa-solid fa-clock"></i> Chưa có tin nhắn nào.</div>';
                return;
            }

            let html = '';
            messages.forEach(msg => {
                const isCustomer = msg.sender === 'CUSTOMER';
                const wrapperClass = isCustomer ? 'user' : 'admin';
                const bubbleClass = isCustomer ? 'customer-bubble' : 'admin-bubble';
                const formattedTime = new Date(msg.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

                html += `
                    <div class="chat-bubble-wrapper ${wrapperClass}">
                        <div class="chat-bubble-meta">${escapeHtml(msg.senderName)} · ${formattedTime}</div>
                        <div class="message-bubble ${bubbleClass}">${escapeHtml(msg.message)}</div>
                    </div>
                `;
            });

            msgContainer.innerHTML = html;

            if (shouldScroll) {
                msgContainer.scrollTop = msgContainer.scrollHeight;
            }
        })
        .catch(err => console.error("Error loading chat messages:", err));
}

function escapeHtml(text) {
    if (!text) return '';
    return text
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}

function handleChatKey(event, id) {
    if (event.key === 'Enter' && !event.shiftKey) {
        event.preventDefault();
        sendAdminMessage(id);
    }
}

function sendAdminMessage(id) {
    const input = document.getElementById('chat-input-' + id);
    if (!input) return;
    const message = input.value.trim();
    if (!message) return;

    input.value = '';

    // Save via REST API
    fetch(`/api/tickets/${id}/messages`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            sender: 'ADMIN',
            senderName: 'Admin',
            message: message
        })
    })
        .then(res => res.json())
        .then(saved => {
            // Append the admin message immediately to the UI
            const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            appendChatBubble(id, 'Admin', message, time, true);

            // Also broadcast via WebSocket so customer client sees it instantly
            const ws = adminWsConnections[id];
            if (ws && ws.readyState === WebSocket.OPEN) {
                ws.send(JSON.stringify({
                    ticketId: parseInt(id),
                    sender: 'ADMIN',
                    senderName: 'Admin',
                    content: message,
                    type: 'CHAT'
                }));
            }
        })
        .catch(err => {
            console.error("Error sending admin message:", err);
            alert("Không thể gửi tin nhắn. Vui lòng thử lại!");
        });
}

function updateTicketStatus(id, status) {
    fetch('/admin/tickets/status', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id: id, status: status })
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                const row = document.querySelector(`[data-id="${id}"]`);
                if (row) {
                    const badge = row.querySelector('.ticket-status-badge');
                    if (badge) {
                        badge.className = 'ticket-status-badge';
                        let label = 'Mới';
                        if (status === 'OPEN') {
                            badge.classList.add('st-open');
                            label = 'Mới';
                        } else if (status === 'IN_PROGRESS') {
                            badge.classList.add('st-progress');
                            label = 'Đang xử lý';
                        } else if (status === 'RESOLVED') {
                            badge.classList.add('st-resolved');
                            label = 'Đã xong';
                        } else if (status === 'CLOSED') {
                            badge.classList.add('st-closed');
                            label = 'Đã đóng';
                        }
                        badge.innerText = label;
                    }
                }
            }
        })
        .catch(err => console.error("Error updating status:", err));
}



function assignTicket(id) {
    return fetch('/admin/tickets/assign', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id: id })
    })
    .then(res => {
        if (!res.ok && res.status !== 409) {
            throw new Error('Network response was not ok');
        }
        return res.json();
    })
    .then(data => {
        if (data.success) {
            // Update assigned admin name
            const adminLabel = document.getElementById('assigned-admin-' + id);
            if (adminLabel) adminLabel.textContent = data.assignedAdmin;
            
            // Show assigned admin row, hide assign button row
            const assignedRow = document.getElementById('assigned-row-' + id);
            if (assignedRow) assignedRow.style.display = '';
            
            const assignBtnRow = document.getElementById('assign-btn-row-' + id);
            if (assignBtnRow) assignBtnRow.style.display = 'none';

            // Remove/hide "Xử lý" button from list
            const procBtn = document.getElementById('btn-process-header-' + id);
            if (procBtn) procBtn.remove();

            // Update status select element
            const statusSelect = document.getElementById('chat-status-' + id);
            if (statusSelect && statusSelect.value === 'OPEN') {
                statusSelect.value = 'IN_PROGRESS';
            }

            // Update status badge on row
            const row = document.querySelector(`[data-id="${id}"]`);
            if (row) {
                const badge = row.querySelector('.ticket-status-badge');
                if (badge) {
                    badge.className = 'ticket-status-badge st-progress';
                    badge.innerText = 'Đang xử lý';
                }
            }
            return data;
        } else {
            // Check for HTTP 409 error message
            if (typeof showToast === 'function') {
                showToast(data.message || 'Lỗi khi nhận ticket.', 'error');
            } else {
                alert(data.message || 'Lỗi khi nhận ticket.');
            }
            // Reload page to reflect that someone else took the ticket
            setTimeout(() => {
                if (typeof handleLinkClick === 'function') {
                    handleLinkClick(new MouseEvent('click'), '/admin/tickets');
                } else {
                    window.location.reload();
                }
            }, 1500);
            return Promise.reject(new Error(data.message));
        }
    })
    .catch(err => {
        console.error("Error assigning ticket:", err);
        throw err;
    });
}

function processTicket(id) {
    assignTicket(id).then(() => {
        // Open details panel if not already open
        const detail = document.getElementById('detail-' + id);
        if (detail && detail.style.display === 'none') {
            toggleTicket(id);
        }
        // Focus input area
        setTimeout(() => {
            const input = document.getElementById('chat-input-' + id);
            if (input) input.focus();
        }, 400);
    });
}

// Cleanup WebSocket connections when leaving page or navigating via SPA
function cleanupTicketsWs() {
    if (typeof adminWsConnections !== 'undefined' && adminWsConnections) {
        Object.keys(adminWsConnections).forEach(id => {
            disconnectTicketWs(id);
        });
    }
}

window.addEventListener('beforeunload', cleanupTicketsWs);
document.addEventListener('spa:load', function() {
    if (!window.location.pathname.startsWith('/admin/tickets')) {
        cleanupTicketsWs();
    }
});

// Prevent reloading data when clicking an already active filter tab
document.addEventListener('click', function(e) {
    const tab = e.target.closest('.filter-tab');
    if (tab && tab.classList.contains('active')) {
        e.preventDefault();
        e.stopPropagation();
    }
}, true);

