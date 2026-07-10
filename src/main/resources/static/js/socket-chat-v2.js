(function() {
    // 1. INJECT CSS STYLES
    const css = `
        .socket-chat-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #c9a84c, #e8c97a);
            border-radius: 50%;
            box-shadow: 0 4px 20px rgba(201, 168, 76, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 99999;
            transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275), box-shadow 0.3s;
        }
        .socket-chat-btn:hover {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 6px 25px rgba(201, 168, 76, 0.6);
        }
        .socket-chat-btn svg {
            width: 28px;
            height: 28px;
            fill: #0a0a0a;
        }
        .socket-chat-badge {
            position: absolute;
            top: -2px;
            right: -2px;
            width: 18px;
            height: 18px;
            background: #ef4444;
            border-radius: 50%;
            display: none;
            align-items: center;
            justify-content: center;
            font-size: 0.65rem;
            font-weight: 700;
            color: #fff;
        }
        .socket-chat-window {
            position: fixed;
            bottom: 110px;
            right: 30px;
            width: 380px;
            height: 520px;
            background: rgba(17, 17, 17, 0.95);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(201, 168, 76, 0.25);
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.6);
            display: flex;
            flex-direction: column;
            z-index: 99999;
            overflow: hidden;
            transform: translateY(20px) scale(0.95);
            opacity: 0;
            pointer-events: none;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.1);
        }
        .socket-chat-window.open {
            transform: translateY(0) scale(1);
            opacity: 1;
            pointer-events: auto;
        }
        .socket-chat-header {
            background: rgba(10, 10, 10, 0.95);
            border-bottom: 1px solid rgba(201, 168, 76, 0.15);
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .socket-chat-title {
            font-family: 'Outfit', sans-serif;
            font-size: 1rem;
            font-weight: 500;
            color: #fff;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .socket-chat-status {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #888;
            transition: background 0.3s;
        }
        .socket-chat-status.connected {
            background: #22c55e;
            box-shadow: 0 0 8px #22c55e;
        }
        .socket-chat-title span {
            color: #c9a84c;
            font-weight: 300;
        }
        .socket-chat-close {
            background: none;
            border: none;
            color: rgba(255, 255, 255, 0.5);
            font-size: 1.2rem;
            cursor: pointer;
            transition: color 0.2s;
        }
        .socket-chat-close:hover {
            color: #ef4444;
        }
        .socket-chat-ticket-bar {
            background: rgba(201, 168, 76, 0.06);
            border-bottom: 1px solid rgba(201, 168, 76, 0.1);
            padding: 6px 20px;
            font-size: 0.7rem;
            color: #c9a84c;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .socket-chat-ticket-bar .new-chat-link {
            color: rgba(255,255,255,0.4);
            cursor: pointer;
            font-size: 0.65rem;
            text-decoration: underline;
            transition: color 0.2s;
        }
        .socket-chat-ticket-bar .new-chat-link:hover {
            color: #fff;
        }
        .socket-chat-messages {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 15px;
            background: rgba(0, 0, 0, 0.2);
            scrollbar-width: thin;
            scrollbar-color: rgba(201, 168, 76, 0.2) transparent;
        }
        .socket-chat-messages::-webkit-scrollbar {
            width: 4px;
        }
        .socket-chat-messages::-webkit-scrollbar-thumb {
            background: rgba(201, 168, 76, 0.2);
            border-radius: 2px;
        }
        .socket-chat-msg {
            max-width: 80%;
            padding: 10px 14px;
            border-radius: 8px;
            font-size: 0.85rem;
            line-height: 1.4;
            word-break: break-word;
            position: relative;
            animation: msgFadeIn 0.25s ease;
        }
        @keyframes msgFadeIn {
            from { opacity: 0; transform: translateY(6px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .socket-chat-msg.incoming {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.05);
            color: #f5f0e8;
            align-self: flex-start;
            border-top-left-radius: 2px;
        }
        .socket-chat-msg.outgoing {
            background: rgba(201, 168, 76, 0.15);
            border: 1px solid rgba(201, 168, 76, 0.25);
            color: #fff;
            align-self: flex-end;
            border-top-right-radius: 2px;
        }
        .socket-chat-sender {
            font-size: 0.7rem;
            color: #c9a84c;
            margin-bottom: 4px;
            font-weight: bold;
        }
        .socket-chat-time {
            font-size: 0.6rem;
            color: rgba(255,255,255,0.25);
            margin-top: 4px;
            text-align: right;
        }
        .socket-chat-system {
            font-size: 0.75rem;
            color: #888;
            text-align: center;
            align-self: center;
            font-style: italic;
            background: rgba(255,255,255,0.02);
            padding: 4px 10px;
            border-radius: 10px;
        }
        .socket-chat-input-area {
            padding: 15px 20px;
            background: rgba(10, 10, 10, 0.95);
            border-top: 1px solid rgba(201, 168, 76, 0.15);
            display: flex;
            gap: 10px;
        }
        .socket-chat-input {
            flex: 1;
            background: #1a1a1a;
            border: 1px solid rgba(201, 168, 76, 0.15);
            color: #fff;
            padding: 10px 14px;
            border-radius: 4px;
            outline: none;
            font-size: 0.85rem;
            transition: border-color 0.2s;
        }
        .socket-chat-input:focus {
            border-color: #c9a84c;
        }
        .socket-chat-send-btn {
            background: #c9a84c;
            color: #0a0a0a;
            border: none;
            padding: 10px 16px;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s;
        }
        .socket-chat-send-btn:hover {
            background: #e8c97a;
        }
        .socket-chat-setup {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 30px;
            text-align: center;
            gap: 12px;
        }
        .socket-chat-setup p {
            font-size: 0.85rem;
            color: #ccc;
            line-height: 1.5;
        }
        .socket-chat-setup-input {
            width: 100%;
            background: #1a1a1a;
            border: 1px solid rgba(201, 168, 76, 0.15);
            color: #fff;
            padding: 12px;
            border-radius: 4px;
            outline: none;
            text-align: center;
            font-size: 0.9rem;
        }
        .socket-chat-setup-input:focus {
            border-color: #c9a84c;
        }
        .socket-chat-setup-btn {
            width: 100%;
            background: #c9a84c;
            color: #0a0a0a;
            border: none;
            padding: 12px;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.85rem;
        }
        .socket-chat-setup-btn:hover {
            background: #e8c97a;
        }
        .socket-chat-setup-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        /* Custom cursor support: hide default cursor */
        #socketChatBtn, #socketChatWindow, #socketChatWindow * {
            cursor: none !important;
        }
        .cursor {
            z-index: 1000001 !important;
        }
        .cursor-follower {
            z-index: 1000000 !important;
        }
    `;

    const styleEl = document.createElement('style');
    styleEl.innerHTML = css;
    document.head.appendChild(styleEl);

    // 2. INJECT HTML MARKUP
    const chatHtml = `
        <div class="socket-chat-btn" id="socketChatBtn" title="Hỗ trợ trực tuyến">
            <svg viewBox="0 0 24 24">
                <path d="M20 2H4c-1.1 0-1.99.9-1.99 2L2 22l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 9h12v2H6V9zm8 5H6v-2h8v2zm4-6H6V6h12v2z"/>
            </svg>
            <div class="socket-chat-badge" id="socketChatBadge"></div>
        </div>
        <div class="socket-chat-window" id="socketChatWindow">
            <div class="socket-chat-header">
                <div class="socket-chat-title">
                    <div class="socket-chat-status" id="socketChatStatus"></div>
                    LUXURY · <span>HỖ TRỢ</span>
                </div>
                <button class="socket-chat-close" id="socketChatClose">✕</button>
            </div>
            
            <div class="socket-chat-ticket-bar" id="socketChatTicketBar" style="display:none; justify-content: space-between; align-items: center;">
                <span id="socketChatTicketLabel">Ticket #—</span>
                <div style="display: flex; gap: 12px;">
                    <span class="new-chat-link" id="socketChatCloseTicketBtn" style="color: #ef4444; font-weight: 500;">Đóng cuộc trò chuyện</span>
                    <span class="new-chat-link" id="socketChatNewBtn">Tạo mới</span>
                </div>
            </div>

            <div class="socket-chat-setup" id="socketChatSetup">
                <p>Vui lòng nhập thông tin để bắt đầu cuộc trò chuyện hỗ trợ.</p>
                <input type="text" class="socket-chat-setup-input" id="socketChatNameInput" placeholder="Họ và tên..." maxlength="30" />
                <input type="email" class="socket-chat-setup-input" id="socketChatEmailInput" placeholder="Email liên hệ (tuỳ chọn)..." maxlength="50" />
                <button class="socket-chat-setup-btn" id="socketChatStartBtn">Bắt Đầu Chat</button>
            </div>

            <div class="socket-chat-messages" id="socketChatMessages" style="display: none;">
                <!-- Messages will appear here -->
            </div>
            
            <div class="socket-chat-input-area" id="socketChatInputArea" style="display: none;">
                <input type="text" class="socket-chat-input" id="socketChatMsgInput" placeholder="Nhập tin nhắn..." autocomplete="off" />
                <button class="socket-chat-send-btn" id="socketChatSendBtn">GỬI</button>
            </div>
        </div>
    `;

    const chatContainer = document.createElement('div');
    chatContainer.innerHTML = chatHtml;
    document.body.appendChild(chatContainer);

    // 3. CODE LOGIC
    const btn = document.getElementById('socketChatBtn');
    const win = document.getElementById('socketChatWindow');
    const closeBtn = document.getElementById('socketChatClose');
    const setupDiv = document.getElementById('socketChatSetup');
    const messagesDiv = document.getElementById('socketChatMessages');
    const inputArea = document.getElementById('socketChatInputArea');
    const nameInput = document.getElementById('socketChatNameInput');
    const emailInput = document.getElementById('socketChatEmailInput');
    const startBtn = document.getElementById('socketChatStartBtn');
    const msgInput = document.getElementById('socketChatMsgInput');
    const sendBtn = document.getElementById('socketChatSendBtn');
    const statusDot = document.getElementById('socketChatStatus');
    const ticketBar = document.getElementById('socketChatTicketBar');
    const ticketLabel = document.getElementById('socketChatTicketLabel');
    const newChatBtn = document.getElementById('socketChatNewBtn');
    const closeTicketBtn = document.getElementById('socketChatCloseTicketBtn');

    let ws = null;
    let username = localStorage.getItem('socket_chat_username') || '';
    let userEmail = localStorage.getItem('socket_chat_email') || '';
    let currentTicketId = parseInt(localStorage.getItem('socket_chat_ticket_id')) || null;
    let ticketSystemAvailable = null; // null = unknown, true/false after first call

    // Custom cursor hovering for chat buttons is now handled globally by cursor.js

    // If already has username and ticketId, bypass setup screen
    if (username && currentTicketId) {
        setupDiv.style.display = 'none';
        messagesDiv.style.display = 'flex';
        inputArea.style.display = 'flex';
        ticketBar.style.display = 'flex';
        ticketLabel.textContent = 'Ticket #' + currentTicketId;
    } else if (username) {
        // Has username but no ticket – might be first time after update
        nameInput.value = username;
        emailInput.value = userEmail;
    }

    // Toggle Chat window
    btn.addEventListener('click', () => {
        const isOpen = win.classList.contains('open');
        if (isOpen) {
            win.classList.remove('open');
        } else {
            win.classList.add('open');
            if (username && currentTicketId && !ws) {
                connectWebSocket();
                loadChatHistory();
            } else if (!username || !currentTicketId) {
                nameInput.focus();
            }
        }
    });

    closeBtn.addEventListener('click', () => {
        win.classList.remove('open');
    });

    // Close ticket button (Customer ends conversation)
    closeTicketBtn.addEventListener('click', async () => {
        if (!confirm('Bạn có chắc chắn muốn đóng cuộc trò chuyện hỗ trợ này không?')) return;

        if (currentTicketId) {
            try {
                await fetch(`/api/tickets/${currentTicketId}/close`, { method: 'POST' });
            } catch (e) {
                console.error('[socket-chat] Error closing ticket:', e);
            }
        }

        currentTicketId = null;
        localStorage.removeItem('socket_chat_ticket_id');
        messagesDiv.innerHTML = '';
        ticketBar.style.display = 'none';

        if (ws) {
            ws.close();
            ws = null;
        }

        setupDiv.style.display = 'flex';
        messagesDiv.style.display = 'none';
        inputArea.style.display = 'none';
        nameInput.value = username;
        emailInput.value = userEmail;

        if(typeof showToast === 'function') { showToast('Đã kết thúc và đóng cuộc trò chuyện.'); } else { alert('Đã kết thúc và đóng cuộc trò chuyện.'); }
    });

    // New Chat button - reset ticket to start a new conversation
    newChatBtn.addEventListener('click', () => {
        if (!confirm('Bạn có muốn tạo cuộc trò chuyện mới không? Lịch sử chat hiện tại sẽ vẫn được lưu lại.')) return;
        currentTicketId = null;
        localStorage.removeItem('socket_chat_ticket_id');
        messagesDiv.innerHTML = '';
        ticketBar.style.display = 'none';
        
        // Close existing WebSocket
        if (ws) {
            ws.close();
            ws = null;
        }

        // Show setup again but with name pre-filled
        setupDiv.style.display = 'flex';
        messagesDiv.style.display = 'none';
        inputArea.style.display = 'none';
        nameInput.value = username;
        emailInput.value = userEmail;
    });

    // Start Chat
    startBtn.addEventListener('click', startChat);
    nameInput.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') emailInput.focus();
    });
    emailInput.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') startChat();
    });

    async function startChat() {
        const name = nameInput.value.trim();
        if (!name) {
            if(typeof showToast === 'function') { showToast('Vui lòng nhập tên!'); } else { alert('Vui lòng nhập tên!'); }
            nameInput.focus();
            return;
        }
        username = name;
        userEmail = emailInput.value.trim();
        localStorage.setItem('socket_chat_username', username);
        localStorage.setItem('socket_chat_email', userEmail);
        
        startBtn.disabled = true;
        startBtn.textContent = 'Đang kết nối...';

        // Try to create a ticket through the ticket API
        try {
            const ticketId = await createTicket(username, userEmail);
            if (ticketId) {
                currentTicketId = ticketId;
                localStorage.setItem('socket_chat_ticket_id', currentTicketId);
                ticketSystemAvailable = true;
            } else {
                ticketSystemAvailable = false;
            }
        } catch (e) {
            ticketSystemAvailable = false;
        }

        // Switch to chat view
        setupDiv.style.display = 'none';
        messagesDiv.style.display = 'flex';
        inputArea.style.display = 'flex';
        
        if (currentTicketId) {
            ticketBar.style.display = 'flex';
            ticketLabel.textContent = 'Ticket #' + currentTicketId;
        }

        startBtn.disabled = false;
        startBtn.textContent = 'Bắt Đầu Chat';

        connectWebSocket();
        setTimeout(() => msgInput.focus(), 200);
    }

    /**
     * Creates a support ticket through the REST API.
     * Falls back gracefully if the ticket system (Luxury404) is not merged yet.
     */
    async function createTicket(name, email) {
        try {
            const response = await fetch('/api/tickets/submit', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    name: name,
                    email: email || '',
                    subject: 'Chat hỗ trợ trực tuyến',
                    message: 'Khách hàng bắt đầu phiên chat hỗ trợ trực tuyến.',
                    category: 'GENERAL'
                })
            });

            if (response.ok) {
                const data = await response.json();
                if (data.success && data.ticketId) {
                    return data.ticketId;
                }
            }
            return null;
        } catch (e) {
            // Ticket system not available (not merged yet) - that's fine
            console.log('[socket-chat] Ticket API not available, using general chat mode.');
            return null;
        }
    }

    /**
     * Load chat history from the ticket messages API.
     * Only works when ticket system is merged.
     */
    async function loadChatHistory() {
        if (!currentTicketId) return;

        try {
            const response = await fetch(`/api/tickets/${currentTicketId}/messages`);
            if (!response.ok) return;

            const messages = await response.json();
            if (!messages || messages.length === 0) return;

            // Clear existing messages and re-render from DB
            messagesDiv.innerHTML = '';
            messages.forEach(msg => {
                const isOutgoing = msg.sender === 'CUSTOMER';
                appendMessage(
                    msg.senderName || msg.sender,
                    msg.message,
                    isOutgoing,
                    msg.createdAt
                );
            });
        } catch (e) {
            // Ticket system not available - that's fine
            console.log('[socket-chat] Could not load chat history, API not available.');
        }
    }

    // Connect WebSocket
    function connectWebSocket() {
        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const host = window.location.host;
        let wsUrl = `${protocol}//${host}/chat-socket`;
        
        // Attach ticketId as query param if available
        if (currentTicketId) {
            wsUrl += `?ticketId=${currentTicketId}`;
        }
        
        appendSystemMessage('Đang kết nối đến máy chủ hỗ trợ...');
        
        ws = new WebSocket(wsUrl);
        
        ws.onopen = () => {
            statusDot.classList.add('connected');
            appendSystemMessage('Đã kết nối! Nhân viên hỗ trợ sẽ phản hồi bạn trong giây lát.');
        };
        
        ws.onmessage = (event) => {
            try {
                const data = JSON.parse(event.data);
                
                // Skip system/join messages  
                if (data.type === 'SYSTEM') {
                    // Only show system messages that aren't join notifications
                    if (data.content && !data.content.includes('đã tham gia')) {
                        appendSystemMessage(data.content);
                    }
                    return;
                }

                // Determine if this is an outgoing or incoming message
                const senderName = data.senderName || data.sender || 'Khách';
                const isOutgoing = (data.sender === 'CUSTOMER' && senderName === username) 
                                || senderName === username;
                const content = data.content || data.message || '';

                appendMessage(senderName, content, isOutgoing);
            } catch (e) {
                // If not JSON, show raw message
                appendMessage('Hệ thống', event.data, false);
            }
        };
        
        ws.onerror = (error) => {
            console.error('WebSocket error:', error);
            appendSystemMessage('⚠️ Lỗi kết nối. Đang thử kết nối lại...');
            scheduleReconnect();
        };
        
        ws.onclose = () => {
            statusDot.classList.remove('connected');
            ws = null;
            // Don't show disconnect message if window is closed
            if (win.classList.contains('open')) {
                appendSystemMessage('Mất kết nối. Đang kết nối lại...');
                scheduleReconnect();
            }
        };
    }

    let reconnectTimeout = null;
    function scheduleReconnect() {
        if (reconnectTimeout) clearTimeout(reconnectTimeout);
        reconnectTimeout = setTimeout(() => {
            if (!ws && win.classList.contains('open') && username) {
                connectWebSocket();
            }
        }, 3000);
    }

    function triggerIndexChatBotReply(userMessage) {
        setTimeout(async () => {
            let botReply = '';
            const msg = userMessage.toLowerCase();
            
            if (msg.includes('giá') || msg.includes('bao nhiêu') || msg.includes('tiền') || msg.includes('rẻ') || msg.includes('đắt')) {
                botReply = 'Dạ chào bạn, bảng giá linh kiện đã được tối ưu tốt nhất. Bạn có nhu cầu thương lượng thêm hoặc cần chiết khấu cho đơn hàng lớn vui lòng liên hệ hotline 1900 8888 hoặc để lại SĐT nha! 💰';
            } else if (msg.includes('ship') || msg.includes('vận chuyển') || msg.includes('giao hàng') || msg.includes('ship COD')) {
                botReply = 'Dạ Luxury PC hỗ trợ miễn phí vận chuyển (Free Ship) toàn quốc cho mọi cấu hình PC build và linh kiện trên 1 triệu đồng ạ! ✈️';
            } else if (msg.includes('bảo hành') || msg.includes('hỏng') || msg.includes('sửa') || msg.includes('lỗi')) {
                botReply = 'Tất cả linh kiện tại Luxury PC đều là hàng chính hãng và được bảo hành từ 36 tháng. Lỗi 1 đổi 1 trong 30 ngày đầu tiên nếu có lỗi phần cứng từ nhà sản xuất! 🛡️';
            } else if (msg.includes('địa chỉ') || msg.includes('ở đâu') || msg.includes('cửa hàng') || msg.includes('showroom')) {
                botReply = 'Showroom chính thức của Luxury PC đặt tại: Số 12 Trịnh Văn Bô, Nam Từ Liêm, Hà Nội. Mở cửa từ 8h00 - 21h30 tất cả các ngày trong tuần. Rất hân hạnh được đón tiếp bạn! 📍';
            } else if (msg.includes('còn hàng') || msg.includes('hết hàng') || msg.includes('stock')) {
                botReply = 'Dạ hầu hết các linh kiện hiển thị trên website đều có sẵn hàng. Nhân viên sẽ check kho thực tế và liên hệ chốt đơn với bạn ngay sau khi bạn tạo yêu cầu ạ. 📦';
            } else {
                botReply = 'Cảm ơn bạn đã nhắn tin cho ban hỗ trợ khách hàng Luxury PC. Nhân viên tư vấn đang kiểm tra thông tin và sẽ phản hồi chi tiết tới bạn trong giây lát! Bạn vui lòng đợi 1-2 phút nhé. 💬';
            }

            // Append directly to the UI
            appendMessage('Luxe Support Bot 🤖', botReply, false);

            // Persist to DB if ticket is available
            if (currentTicketId && ticketSystemAvailable) {
                try {
                    await fetch(`/api/tickets/${currentTicketId}/messages`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            sender: 'ADMIN',
                            senderName: 'Luxe Support Bot 🤖',
                            message: botReply
                        })
                    });
                } catch (e) {
                    console.error('[socket-chat] Error saving bot response:', e);
                }
            }
        }, 1200); // 1.2s delay for natural response
    }

    // Send Message
    sendBtn.addEventListener('click', sendMessage);
    msgInput.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') sendMessage();
    });

    let lastLiveChatTime = parseInt(localStorage.getItem('lastLiveChatTime') || '0');

    function updateLiveChatCooldown() {
        const now = Date.now();
        const elapsed = now - lastLiveChatTime;
        if (elapsed < 30000) {
            const remaining = Math.ceil((30000 - elapsed) / 1000);
            if (msgInput) {
                msgInput.disabled = true;
                msgInput.placeholder = `Vui lòng đợi ${remaining}s...`;
            }
            if (sendBtn) sendBtn.disabled = true;
            setTimeout(updateLiveChatCooldown, 1000);
        } else {
            if (msgInput) {
                msgInput.disabled = false;
                msgInput.placeholder = "Nhập tin nhắn...";
            }
            if (sendBtn) sendBtn.disabled = false;
        }
    }
    
    // Khởi chạy khi load
    updateLiveChatCooldown();

    function sendMessage() {
        const text = msgInput.value.trim();
        if (!text) return;

        const now = Date.now();
        if (now - lastLiveChatTime < 2000) {
            return;
        }
        lastLiveChatTime = now;
        
        if (!ws || ws.readyState !== WebSocket.OPEN) {
            appendSystemMessage('Đang kết nối lại...');
            connectWebSocket();
            return;
        }

        // Send through WebSocket with ticket context
        const msgPayload = {
            ticketId: currentTicketId,
            sender: 'CUSTOMER',
            senderName: username,
            content: text,
            type: 'CHAT'
        };

        ws.send(JSON.stringify(msgPayload));

        // Also persist to DB via REST API if ticket is available
        if (currentTicketId && ticketSystemAvailable) {
            fetch(`/api/tickets/${currentTicketId}/messages`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    sender: 'CUSTOMER',
                    senderName: username,
                    message: text
                })
            }).catch(() => {
                // Silently fail - WebSocket already sent the message
            });
        }

        // Trigger bot auto-reply
        triggerIndexChatBotReply(text);

        msgInput.value = '';
        msgInput.focus();
    }

    function appendMessage(sender, content, isOutgoing, timestamp) {
        const msgEl = document.createElement('div');
        msgEl.className = `socket-chat-msg ${isOutgoing ? 'outgoing' : 'incoming'}`;
        
        let html = '';
        if (!isOutgoing) {
            html += `<div class="socket-chat-sender">${escapeHtml(sender)}</div>`;
        }
        html += `<div>${escapeHtml(content)}</div>`;
        
        // Add timestamp
        const time = timestamp ? new Date(timestamp) : new Date();
        const timeStr = time.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        html += `<div class="socket-chat-time">${timeStr}</div>`;
        
        msgEl.innerHTML = html;
        messagesDiv.appendChild(msgEl);
        scrollToBottom();
    }

    function appendSystemMessage(content) {
        const msgEl = document.createElement('div');
        msgEl.className = 'socket-chat-system';
        msgEl.textContent = content;
        messagesDiv.appendChild(msgEl);
        scrollToBottom();
    }

    function scrollToBottom() {
        messagesDiv.scrollTop = messagesDiv.scrollHeight;
    }

    function escapeHtml(str) {
        if (!str) return '';
        return str.replace(/&/g, "&amp;")
                  .replace(/</g, "&lt;")
                  .replace(/>/g, "&gt;")
                  .replace(/"/g, "&quot;")
                  .replace(/'/g, "&#039;");
    }
})();
