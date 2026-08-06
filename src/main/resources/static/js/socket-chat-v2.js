(function() {
    // 1. GET DOM ELEMENTS (HTML is now embedded statically in footer.html)
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
    
    // Waiting UI elements
    const waitingStateDiv = document.getElementById('socketChatWaitingState');
    const waitingSubtitle = document.getElementById('socketChatWaitingSubtitle');
    const waitingTimer = document.getElementById('socketChatTimer');
    const quickRepliesDiv = document.getElementById('socketChatQuickReplies');
    const quickReplyBtns = document.querySelectorAll('.quick-reply-btn');

    let ws = null;
    let username = localStorage.getItem('socket_chat_username') || '';
    let userEmail = localStorage.getItem('socket_chat_email') || '';
    let currentTicketId = parseInt(localStorage.getItem('socket_chat_ticket_id')) || null;
    let ticketSystemAvailable = null; // null = unknown, true/false after first call
    let availableStaffs = [];

    // Fetch staffs and save to variable
    fetch('/api/tickets/staffs')
        .then(res => res.json())
        .then(data => {
            if (data && data.length > 0) {
                availableStaffs = data;
            }
        })
        .catch(err => console.log('Cannot fetch staffs', err));

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
            btn.style.display = 'flex';
            localStorage.removeItem('socket_chat_isOpen');
            document.documentElement.classList.remove('socket-chat-open');
        } else {
            win.classList.add('open');
            btn.style.display = 'none';
            localStorage.setItem('socket_chat_isOpen', 'true');
            document.documentElement.classList.add('socket-chat-open');
            if (username && currentTicketId && !ws) {
                connectWebSocket();
                loadChatHistory();
            } else if (!username || !currentTicketId) {
                nameInput.focus();
            }
        }
    });

    // Auto open if it was open before reload
    if (localStorage.getItem('socket_chat_isOpen') === 'true') {
        win.classList.add('open');
        btn.style.display = 'none';
        document.documentElement.classList.add('socket-chat-open');
        if (username && currentTicketId && !ws) {
            connectWebSocket();
            loadChatHistory();
        }
    }

    closeBtn.addEventListener('click', () => {
        win.classList.remove('open');
        btn.style.display = 'flex';
        localStorage.removeItem('socket_chat_isOpen');
        document.documentElement.classList.remove('socket-chat-open');
    });

    // Close ticket button (Customer ends conversation)
    closeTicketBtn.addEventListener('click', async () => {
        const ok = await window.showConfirm('Bạn có chắc chắn muốn đóng cuộc trò chuyện hỗ trợ này không?', 'Đóng cuộc trò chuyện');
        if (!ok) return;

        if (currentTicketId) {
            try {
                // Keep sending the request so admin knows, but don't wait for it
                fetch(`/api/tickets/${currentTicketId}/request-close`, { method: 'POST' }).catch(e => console.error(e));
                
                // Immediately close it locally for the customer
                closeChatLocally();
                if(typeof showToast === 'function') { showToast('Đã đóng cuộc trò chuyện hiện tại.'); }
            } catch (e) {
                console.error('[socket-chat] Error requesting ticket close:', e);
            }
        } else {
            closeChatLocally();
            if(typeof showToast === 'function') { showToast('Đã kết thúc và đóng cuộc trò chuyện.'); } else { alert('Đã kết thúc và đóng cuộc trò chuyện.'); }
        }
    });

    function closeChatLocally() {
        currentTicketId = null;
        localStorage.removeItem('socket_chat_ticket_id');
        messagesDiv.innerHTML = '';
        ticketBar.style.display = 'none';
        stopWaitingTimer();

        if (ws) {
            ws.close();
            ws = null;
        }

        setupDiv.style.display = 'flex';
        messagesDiv.style.display = 'none';
        inputArea.style.display = 'none';
        nameInput.value = username;
        emailInput.value = userEmail;
    }

    // New Chat button - reset ticket to start a new conversation
    newChatBtn.addEventListener('click', async () => {
        const ok = await window.showConfirm('Bạn có muốn tạo cuộc trò chuyện mới không? Lịch sử chat hiện tại sẽ vẫn được lưu lại.', 'Tạo cuộc trò chuyện mới');
        if (!ok) return;
        currentTicketId = null;
        localStorage.removeItem('socket_chat_ticket_id');
        messagesDiv.innerHTML = '';
        ticketBar.style.display = 'none';
        stopWaitingTimer();
        
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

    let waitingInterval = null;
    let waitingSeconds = 0;

    function startWaitingTimer(hideMessages = false) {
        waitingSeconds = 0;
        waitingStateDiv.classList.add('active');
        if (hideMessages) {
            messagesDiv.style.display = 'none';
        }
        
        waitingTimer.textContent = '00:00';
        
        if (waitingInterval) clearInterval(waitingInterval);
        waitingInterval = setInterval(() => {
            waitingSeconds++;
            const m = Math.floor(waitingSeconds / 60).toString().padStart(2, '0');
            const s = (waitingSeconds % 60).toString().padStart(2, '0');
            waitingTimer.textContent = `${m}:${s}`;
            
            if (waitingSeconds >= 60) {
                waitingSubtitle.innerHTML = 'Hiện tại tất cả nhân viên đang bận.<br>Chúng tôi sẽ hỗ trợ bạn sớm nhất.';
                waitingTimer.style.display = 'none';
                clearInterval(waitingInterval);
            }
        }, 1000);
    }
    
    function stopWaitingTimer() {
        if (waitingInterval) clearInterval(waitingInterval);
        waitingStateDiv.classList.remove('active');
        messagesDiv.style.display = 'flex';
    }

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
        inputArea.style.display = 'flex';
        
        if (currentTicketId && ticketSystemAvailable) {
            // Do not show waiting state initially
            messagesDiv.style.display = 'flex';
        } else {
            messagesDiv.style.display = 'flex';
        }
        
        if (currentTicketId) {
            ticketBar.style.display = 'flex';
            ticketLabel.textContent = 'Ticket #' + currentTicketId;
        }

        startBtn.disabled = false;
        startBtn.textContent = 'Bắt Đầu Chat';

        connectWebSocket();
        setTimeout(() => {
            msgInput.focus();
            if (!messagesDiv.innerHTML.includes('Trợ lý ảo Luxury PC')) {
                appendWelcomeMenu();
            }
        }, 300);
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
            if (waitingStateDiv.classList.contains('active')) {
                appendSystemMessage('Đã kết nối! Nhân viên hỗ trợ sẽ phản hồi bạn trong giây lát.');
            } else if (!messagesDiv.innerHTML.includes('Đã kết nối')) {
                appendSystemMessage('Đã kết nối thành công!');
            }
        };
        
        ws.onmessage = (event) => {
            try {
                const data = JSON.parse(event.data);
                
                // Handle system messages (e.g., ADMIN_JOINED)
                if (data.type === 'SYSTEM') {
                    if (data.event === 'ADMIN_JOINED') {
                        stopWaitingTimer();
                        appendSystemMessage(data.content || `Nhân viên ${data.adminName || 'hỗ trợ'} đã tham gia cuộc trò chuyện.`);
                    } else if (data.event === 'TICKET_CLOSED') {
                        appendSystemMessage(data.content || 'Cuộc trò chuyện đã được đóng hoàn toàn.');
                        setTimeout(() => {
                            closeChatLocally();
                            if(typeof showToast === 'function') { showToast('Đã kết thúc và đóng cuộc trò chuyện.'); } else { alert('Đã kết thúc và đóng cuộc trò chuyện.'); }
                        }, 2000);
                    } else if (data.event === 'AI_WAITING') {
                        appendSystemMessage(data.content);
                    } else if (data.content && !data.content.includes('đã tham gia')) {
                        appendSystemMessage(data.content);
                    }
                    return;
                }

                if (data.type === 'AI_REPLY') {
                    stopWaitingTimer();
                    appendMessage(data.adminName || 'AI Assistant', data.content, false);
                    return;
                }

                // Determine if this is an outgoing or incoming message
                const senderName = data.senderName || data.sender || 'Khách';
                const isOutgoing = (data.sender === 'CUSTOMER' && senderName === username) 
                                || senderName === username;
                const content = data.content || data.message || '';
                
                if (!isOutgoing) {
                    stopWaitingTimer();
                }

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
        if (elapsed < 3000) {
            const remaining = Math.ceil((3000 - elapsed) / 1000);
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
                // Don't auto-focus if window is not open to prevent stealing focus
                if (win.classList.contains('open')) {
                    msgInput.focus();
                }
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
        if (now - lastLiveChatTime < 3000) {
            return;
        }
        
        lastLiveChatTime = now;
        localStorage.setItem('lastLiveChatTime', now.toString());
        
        // Cập nhật giao diện chặn spam
        updateLiveChatCooldown();
        
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
            type: 'CHAT',
            isAiRequest: true // <--- Always trigger AI for now
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

        // Hide quick replies to prevent UI overlap
        if (quickRepliesDiv) quickRepliesDiv.style.display = 'none';

        msgInput.value = '';
        msgInput.focus();
    }
    
    function handleQuickReplyClick(text, isAiReq) {
        if (text === '🧑‍💻 Gặp nhân viên hỗ trợ') {
            appendMessage(username, text, true);
            
            document.querySelector('.socket-chat-waiting-title').textContent = '🟡 Đang tìm nhân viên...';
            document.getElementById('socketChatWaitingSubtitle').textContent = 'Vui lòng chờ trong giây lát.';
            startWaitingTimer();
            appendSystemMessage('Đã gửi yêu cầu đến nhân viên hỗ trợ. Vui lòng chờ trong giây lát...');
            return;
        }
        
        // Send as normal message
        if (!ws || ws.readyState !== WebSocket.OPEN) {
            appendSystemMessage('Đang kết nối lại...');
            connectWebSocket();
        } else {
            const msgPayload = {
                ticketId: currentTicketId,
                sender: 'CUSTOMER',
                senderName: username,
                content: text,
                type: 'CHAT',
                isAiRequest: isAiReq
            };
            ws.send(JSON.stringify(msgPayload));
            
            if (currentTicketId && ticketSystemAvailable) {
                fetch(`/api/tickets/${currentTicketId}/messages`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        sender: 'CUSTOMER',
                        senderName: username,
                        message: text
                    })
                }).catch(() => {});
            }
            
            if (!isAiReq) {
                triggerIndexChatBotReply(text);
            }
        }
    }

    function appendWelcomeMenu() {
        const msgEl = document.createElement('div');
        msgEl.className = 'socket-chat-msg system-msg';
        
        const html = `
            <div style="background:#f1f5f9; padding: 10px; border-radius: 8px; font-size: 0.9em; color:#334155; margin-bottom: 10px; text-align: left; width: 100%;">
                <div style="margin-bottom: 10px;">
                    <strong style="color:#0f172a;">Trợ lý ảo Luxury PC 🤖</strong><br/>
                    Xin chào! Để được hỗ trợ nhanh nhất, bạn vui lòng chọn một chủ đề dưới đây 👇
                </div>
                <div style="display:flex; flex-direction:column; gap:5px;">
                    <button class="welcome-menu-btn" data-ai="true" data-text="🤖 Nhờ AI Tư vấn Cấu hình" style="border: 1px solid #10b981; color: #10b981; background: transparent; padding: 6px 12px; border-radius: 20px; cursor: pointer; text-align: left;">🤖 Nhờ AI Tư vấn Cấu hình</button>
                    <button class="welcome-menu-btn" data-ai="false" data-text="Tư vấn cấu hình PC" style="border: 1px solid #cbd5e1; color: #334155; background: transparent; padding: 6px 12px; border-radius: 20px; cursor: pointer; text-align: left;">Tư vấn cấu hình PC</button>
                    <button class="welcome-menu-btn" data-ai="false" data-text="Hỏi về chính sách bảo hành" style="border: 1px solid #cbd5e1; color: #334155; background: transparent; padding: 6px 12px; border-radius: 20px; cursor: pointer; text-align: left;">Hỏi về chính sách bảo hành</button>
                    <button class="welcome-menu-btn" data-ai="false" data-text="Trợ giúp giao hàng, vận chuyển" style="border: 1px solid #cbd5e1; color: #334155; background: transparent; padding: 6px 12px; border-radius: 20px; cursor: pointer; text-align: left;">Trợ giúp giao hàng, vận chuyển</button>
                    <button class="welcome-menu-btn" data-ai="false" data-text="🧑‍💻 Gặp nhân viên hỗ trợ" style="border: 1px solid #cbd5e1; color: #334155; background: transparent; padding: 6px 12px; border-radius: 20px; cursor: pointer; text-align: left;">🧑‍💻 Gặp nhân viên hỗ trợ</button>
                </div>
            </div>
        `;
        msgEl.innerHTML = html;
        messagesDiv.appendChild(msgEl);
        scrollToBottom();

        const btns = msgEl.querySelectorAll('.welcome-menu-btn');
        btns.forEach(btn => {
            btn.addEventListener('click', () => {
                // Tạm thời disable để chống spam click
                btns.forEach(b => {
                    b.disabled = true;
                });
                
                setTimeout(() => {
                    btns.forEach(b => { b.disabled = false; });
                }, 2000);
                
                const text = btn.getAttribute('data-text');
                const isAiReq = btn.getAttribute('data-ai') === 'true';
                handleQuickReplyClick(text, isAiReq);
            });
        });
    }

    function appendMessage(sender, content, isOutgoing, timestamp) {
        const msgEl = document.createElement('div');
        msgEl.className = `socket-chat-msg ${isOutgoing ? 'outgoing' : 'incoming'}`;
        if (sender === 'AI Assistant') {
            msgEl.style.border = '1px solid #10b981';
            msgEl.style.backgroundColor = '#f0fdf4';
        }
        
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
        // Chống spam lặp lại cùng 1 thông báo hệ thống liên tục
        const lastMsg = messagesDiv.lastElementChild;
        if (lastMsg && lastMsg.className === 'socket-chat-system' && lastMsg.textContent === content) {
            return;
        }
        
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
