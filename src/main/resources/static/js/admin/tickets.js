let activePollInterval = null;
let activeTicketId = null;

function toggleTicket(id) {
    const detail = document.getElementById('detail-' + id);
    const icon = document.getElementById('icon-' + id);

    if (detail.style.display === 'none') {
        // Close all other open tickets first to keep UI clean and prevent multiple active pollers
        document.querySelectorAll('.ticket-detail').forEach(d => {
            if (d.id !== 'detail-' + id) {
                d.style.display = 'none';
                const otherId = d.id.replace('detail-', '');
                const otherIcon = document.getElementById('icon-' + otherId);
                if (otherIcon) otherIcon.style.transform = 'rotate(0deg)';
            }
        });

        detail.style.display = 'block';
        icon.style.transform = 'rotate(180deg)';

        // Start polling chat messages
        startChatPolling(id);
    } else {
        detail.style.display = 'none';
        icon.style.transform = 'rotate(0deg)';

        // Stop polling
        stopChatPolling();
    }
}

function startChatPolling(id) {
    stopChatPolling(); // clear any previous poller
    activeTicketId = id;

    // Initial load
    loadChatMessages(id, true);

    // Poll every 2 seconds
    activePollInterval = setInterval(() => {
        loadChatMessages(id, false);
    }, 2000);
}

function stopChatPolling() {
    if (activePollInterval) {
        clearInterval(activePollInterval);
        activePollInterval = null;
    }
    activeTicketId = null;
}

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

            // Save scroll position
            const isNearBottom = msgContainer.scrollHeight - msgContainer.clientHeight - msgContainer.scrollTop < 60;

            let html = '';
            messages.forEach(msg => {
                const isCustomer = msg.sender === 'CUSTOMER';
                const wrapperClass = isCustomer ? 'user' : 'admin';
                const bubbleClass = isCustomer ? 'customer-bubble' : 'admin-bubble';
                const formattedTime = new Date(msg.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

                html += `
                    <div class="chat-bubble-wrapper ${wrapperClass}">
                        <div class="chat-bubble-meta">${msg.senderName} · ${formattedTime}</div>
                        <div class="message-bubble ${bubbleClass}">${escapeHtml(msg.message)}</div>
                    </div>
                `;
            });

            msgContainer.innerHTML = html;

            // Auto-scroll if initial load or user was near bottom
            if (shouldScroll || isNearBottom) {
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

    input.value = ''; // clear input

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
            // Instantly reload chat list
            loadChatMessages(id, true);
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
                // Update status badge of the row without reload
                const row = document.querySelector(`[data-id="${id}"]`);
                if (row) {
                    const badge = row.querySelector('.ticket-status-badge');
                    if (badge) {
                        badge.className = 'ticket-status-badge'; // reset
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

function deleteTicket(id) {
    if (!confirm('Xóa ticket #' + id + '? Hành động này không thể hoàn tác.')) return;
    fetch('/admin/tickets/delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id: id })
    }).then(r => r.json()).then(data => {
        if (data.success) {
            const row = document.querySelector('[data-id="' + id + '"]');
            row.style.opacity = '0';
            row.style.transform = 'translateX(-20px)';
            row.style.transition = '0.4s';
            setTimeout(() => row.remove(), 400);
        }
    });
}

// Auto-open first OPEN ticket
document.addEventListener('DOMContentLoaded', () => {
    const firstOpen = document.querySelector('.ticket-row');
    if (firstOpen) {
        const id = firstOpen.getAttribute('data-id');
        // toggleTicket(id); // uncomment to auto-open first
    }
});
