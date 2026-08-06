function toggleChatWindow() {
        const windowEl = document.getElementById('ai-chat-window');
        if (!windowEl) return;
        const isOpen = windowEl.style.display === 'flex' || windowEl.classList.contains('open');
        if (isOpen) {
          windowEl.classList.remove('open');
          windowEl.style.display = 'none';
        } else {
          windowEl.style.display = 'flex';
          setTimeout(() => windowEl.classList.add('open'), 10);
          const area = document.getElementById('chat-messages-area');
          if (area) area.scrollTop = area.scrollHeight;
        }
      }

      // Integrated Chat mode switcher
      function changeMode(mode) {
        const aiWin = document.getElementById('ai-chat-window');
        const socketWin = document.getElementById('socketChatWindow');
        const socketBtn = document.getElementById('socketChatBtn');
        
        if (mode === 'ai') {
          if (socketWin && socketWin.classList.contains('open')) {
            socketWin.classList.remove('open');
          }
          if (aiWin) {
            aiWin.style.display = 'flex';
            setTimeout(() => aiWin.classList.add('open'), 10);
          }
          localStorage.setItem('preferred_chat_mode', 'ai');
        } else if (mode === 'live') {
          if (aiWin) {
            aiWin.classList.remove('open');
            aiWin.style.display = 'none';
          }
          if (socketWin) {
            if (!socketWin.classList.contains('open')) {
              if (socketBtn) socketBtn.click();
            }
          }
          localStorage.setItem('preferred_chat_mode', 'live');
        }
      }

      function handleFabClick() {
        const preferredMode = localStorage.getItem('preferred_chat_mode') || 'ai';
        const aiWin = document.getElementById('ai-chat-window');
        const socketWin = document.getElementById('socketChatWindow');
        
        const isAiOpen = aiWin && (aiWin.style.display === 'flex' || aiWin.classList.contains('open'));
        const isSocketOpen = socketWin && socketWin.classList.contains('open');
        
        if (isAiOpen || isSocketOpen) {
          if (aiWin) {
            aiWin.classList.remove('open');
            aiWin.style.display = 'none';
          }
          if (socketWin) {
            socketWin.classList.remove('open');
          }
        } else {
          changeMode(preferredMode);
        }
      }

      function setupAiCursorHover(element) {
        if (!element) return;
        element.addEventListener('mouseenter', () => {
          const cursor = document.getElementById('cursor');
          const cursorFollower = document.getElementById('cursor-follower');
          if (cursor && cursorFollower) {
            cursor.style.transform = 'translate(-50%,-50%) scale(2)';
            cursorFollower.style.width = '60px';
            cursorFollower.style.height = '60px';
            cursorFollower.style.opacity = '0.3';
          }
        });
        element.addEventListener('mouseleave', () => {
          const cursor = document.getElementById('cursor');
          const cursorFollower = document.getElementById('cursor-follower');
          if (cursor && cursorFollower) {
            cursor.style.transform = 'translate(-50%,-50%) scale(1)';
            cursorFollower.style.width = '36px';
            cursorFollower.style.height = '36px';
            cursorFollower.style.opacity = '0.6';
          }
        });
      }

      function handleChatKeyPress(event) {
        if (event.key === 'Enter' && !event.shiftKey) {
          event.preventDefault();
          sendChatMessage();
        }
      }

      let lastAiChatTime = parseInt(localStorage.getItem('lastAiChatTime') || '0');

      function updateAiChatCooldown() {
          const now = Date.now();
          const elapsed = now - lastAiChatTime;
          const inputEl = document.getElementById('chat-input-field');
          const sendBtn = document.getElementById('chat-send-btn');
          const quickBtns = document.querySelectorAll('#ai-chat-window .quick-btn');
          
          if (elapsed < 30000) {
              const remaining = Math.ceil((30000 - elapsed) / 1000);
              if (inputEl) {
                  inputEl.disabled = true;
                  inputEl.placeholder = `Vui lòng đợi ${remaining}s...`;
              }
              if (sendBtn) sendBtn.disabled = true;
              quickBtns.forEach(btn => btn.disabled = true);
              
              setTimeout(updateAiChatCooldown, 1000);
          } else {
              if (inputEl) {
                  inputEl.disabled = false;
                  inputEl.placeholder = "Hỏi về linh kiện, budget, tương thích...";
              }
              if (sendBtn) sendBtn.disabled = false;
              quickBtns.forEach(btn => btn.disabled = false);
          }
      }

      // Preserve original placeholder
      document.addEventListener('DOMContentLoaded', () => {
          const aiInputEl = document.getElementById('chat-input-field');
          if (aiInputEl) {
              
          }
          updateAiChatCooldown();
      });

      function sendChatMessage() {
        const inputEl = document.getElementById('chat-input-field');
        if (!inputEl) return;
        const text = inputEl.value.trim();
        if (!text) return;

        const now = Date.now();
        if (now - lastAiChatTime < 30000) return;

        lastAiChatTime = now;
        localStorage.setItem('lastAiChatTime', now);
        updateAiChatCooldown();

        appendMessage(text, 'user');
        inputEl.value = '';

        // Hiển thị trạng thái AI đang gõ...
        const area = document.getElementById('chat-messages-area');
        const loadingMsg = document.createElement('div');
        loadingMsg.className = 'chat-bubble bot';
        loadingMsg.id = 'ai-loading-indicator';
        loadingMsg.innerHTML = '<div class="chat-bubble-icon">🤖</div><div class="chat-bubble-text chat-typing"><span></span><span></span><span></span></div>';
        area.appendChild(loadingMsg);
        area.scrollTop = area.scrollHeight;

        // Gửi request lên Backend Spring Boot
        fetch('/api/build/ai-advisor', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ message: text })
        })
        .then(response => response.json())
        .then(data => {
          // Xóa chỉ báo loading
          const indicator = document.getElementById('ai-loading-indicator');
          if (indicator) indicator.remove();

          if (data.response) {
            let formattedText = data.response
              .replace(/\n/g, '<br>')
              .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
              .replace(/\*(.*?)\*/g, '<em>$1</em>');
            
            appendMessage(formattedText, 'bot');
          } else {
            appendMessage("Có lỗi xảy ra khi xử lý phản hồi từ AI.", 'bot');
          }
        })
        .catch(error => {
          const indicator = document.getElementById('ai-loading-indicator');
          if (indicator) indicator.remove();
          console.error('Error:', error);
          appendMessage("Không thể kết nối đến máy chủ AI. Vui lòng thử lại sau.", 'bot');
        });
      }

      function appendMessage(text, sender, action = null) {
        const area = document.getElementById('chat-messages-area');
        if (!area) return;
        const msg = document.createElement('div');
        msg.className = `chat-bubble ${sender}`;
        
        let icon = sender === 'bot' ? '🤖' : '👤';
        let htmlContent = `<div class="chat-bubble-icon">${icon}</div>`;
        htmlContent += `<div style="display: flex; flex-direction: column; align-items: flex-start; max-width: 100%;">`;
        htmlContent += `<div class="chat-bubble-text">${text}</div>`;
        if (action) {
          htmlContent += `<button class="chat-action-btn" onclick="${action.func}">${action.label}</button>`;
        }
        htmlContent += `</div>`;
        msg.innerHTML = htmlContent;
        
        area.appendChild(msg);
        area.scrollTop = area.scrollHeight;
      }

      function selectPackage(pkgId) {
        // Redirect to build-pc page and pass the selected package in query parameter
        window.location.href = `/build-pc/index.html?package=${pkgId}`;
      }

      // Action from quick chatbot button to switch directly to live chat
      function triggerConsultantRedirect() {
        appendMessage("Đang kết nối bạn với nhân viên hỗ trợ trực tuyến...", 'bot');
        setTimeout(() => {
          changeMode('live');
        }, 1000);
      }

      function askAdvisorQuick(query) {
        const now = Date.now();
        if (now - lastAiChatTime < 30000) return;
        
        lastAiChatTime = now;
        localStorage.setItem('lastAiChatTime', now);
        updateAiChatCooldown();

        let actualQuery = query;
        if (query === 'gaming') actualQuery = "Tôi cần tư vấn cấu hình chiến game 4K";
        else if (query === 'graphic') actualQuery = "Tư vấn cấu hình làm đồ họa 3D render";
        else if (query === 'ai') actualQuery = "Tôi muốn build máy AI Workstation";
        else if (query === 'cool') actualQuery = "Nên chọn tản nước hay tản khí?";

        appendMessage(actualQuery, 'user');

        // Hiển thị trạng thái AI đang gõ...
        const area = document.getElementById('chat-messages-area');
        const loadingMsg = document.createElement('div');
        loadingMsg.className = 'chat-bubble bot';
        loadingMsg.id = 'ai-loading-indicator';
        loadingMsg.innerHTML = '<div class="chat-bubble-icon">🤖</div><div class="chat-bubble-text chat-typing"><span></span><span></span><span></span></div>';
        area.appendChild(loadingMsg);
        area.scrollTop = area.scrollHeight;

        fetch('/api/build/ai-advisor', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ message: actualQuery })
        })
        .then(response => response.json())
        .then(data => {
          const indicator = document.getElementById('ai-loading-indicator');
          if (indicator) indicator.remove();

          if (data.response) {
            let formattedText = data.response
              .replace(/\n/g, '<br>')
              .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
              .replace(/\*(.*?)\*/g, '<em>$1</em>');
            
            appendMessage(formattedText, 'bot');
          } else {
            appendMessage("Không nhận được phản hồi từ cố vấn AI.", 'bot');
          }
        })
        .catch(error => {
          const indicator = document.getElementById('ai-loading-indicator');
          if (indicator) indicator.remove();
          console.error('Error:', error);
          appendMessage("Lỗi kết nối AI.", 'bot');
        });
      }

      document.addEventListener('DOMContentLoaded', () => {
        // Hide default socket button ONLY if ai-chat-window exists (e.g. 3D build-pc)
        const socketBtn = document.getElementById('socketChatBtn');
        const aiWin = document.getElementById('ai-chat-window');
        if (socketBtn) {
          if (aiWin) {
            socketBtn.style.display = 'none';
          } else {
            socketBtn.style.display = 'flex';
          }
        }

        // Setup MutationObserver to mirror notification badge
        const targetBadge = document.getElementById('socketChatBadge');
        const ourBadge = document.getElementById('ai-chat-fab-badge');
        if (targetBadge && ourBadge) {
          const observer = new MutationObserver(() => {
            ourBadge.style.display = targetBadge.style.display;
            ourBadge.textContent = targetBadge.textContent;
          });
          observer.observe(targetBadge, { attributes: true, childList: true, characterData: true });
        }

        // Dynamically inject mode selector tab bar into socket chat window ONLY IF aiWin exists!
        const socketWin = document.getElementById('socketChatWindow');
        if (socketWin && aiWin) {
          const header = socketWin.querySelector('.socket-chat-header');
          if (header && !socketWin.querySelector('.chatbot-mode-bar')) {
            const modeBar = document.createElement('div');
            modeBar.className = 'chatbot-mode-bar';
            modeBar.innerHTML = `
              <div class="mode-step" id="socket-tab-ai" style="cursor: pointer;" onclick="changeMode('ai')">🤖 AI Chat</div>
              <div class="mode-arrow">›</div>
              <div class="mode-step active" id="socket-tab-live" style="cursor: pointer;" onclick="changeMode('live')">💬 Live Chat</div>
            `;
            header.parentNode.insertBefore(modeBar, header.nextSibling);
            
            // Set up cursor hover for the newly added tabs in socket-chat
            setTimeout(() => {
              setupAiCursorHover(document.getElementById('socket-tab-ai'));
              setupAiCursorHover(document.getElementById('socket-tab-live'));
            }, 100);
          }
        }

        // Set up cursor hovers for index chatbot controls
        setupAiCursorHover(document.getElementById('chatbot-fab-trigger'));
        setupAiCursorHover(document.getElementById('ai-tab-ai'));
        setupAiCursorHover(document.getElementById('ai-tab-live'));
        setupAiCursorHover(document.getElementById('chat-send-btn'));
        const closeBtn = document.querySelector('#ai-chat-window .chatbot-close');
        if (closeBtn) setupAiCursorHover(closeBtn);
        document.querySelectorAll('#ai-chat-window .quick-btn').forEach(btn => setupAiCursorHover(btn));
      });

document.addEventListener('DOMContentLoaded', function() {
      const forms = document.querySelectorAll('form[action="/cart/add"]');
      if(forms.length > 0) {
        forms.forEach(form => {
          form.addEventListener('submit', function(e) {
            const actionUrl = (e.submitter && e.submitter.getAttribute('formaction')) || this.action || this.getAttribute('action');
            if (this.classList.contains('is-buy-now') || (actionUrl && actionUrl.includes('buy-now'))) {
              return;
            }
            e.preventDefault();
            const formData = new FormData(this);
            fetch(this.action, {
              method: 'POST',
              body: formData,
              redirect: 'follow'
            }).then(res => {
               document.getElementById('cart-popup').style.display = 'block';
               let currentCount = parseInt(document.getElementById('cart-count')?.textContent || '0');
               let addedQty = parseInt(this.querySelector('input[name="qty"]')?.value || '1');
               if(document.getElementById('cart-count')) {
                   document.getElementById('cart-count').textContent = currentCount + addedQty;
               }
            });
          });
        });
      }
    });
// --- FOOTER MODALS (Build PC Guide, Share, Confirm Clear) ---
function showBuildGuide() { const el = document.getElementById('guideModal'); if (el) el.classList.add('active'); }
function closeBuildGuide() { const el = document.getElementById('guideModal'); if (el) el.classList.remove('active'); }
function openShareModal() { const el = document.getElementById('shareModal'); if (el) el.classList.add('active'); }
function closeShareModal() { const el = document.getElementById('shareModal'); if (el) el.classList.remove('active'); }
function copyShareUrl() { const copyText = document.getElementById('shareUrlInput'); if (!copyText) return; copyText.select(); document.execCommand('copy'); if (typeof showToast === 'function') showToast('Ðã copy link vào Clipboard!'); else alert('Ðã copy link vào Clipboard!'); }
function openShareUrl() { const input = document.getElementById('shareUrlInput'); if (input && input.value) window.open(input.value, '_blank'); }
function confirmClearAll() { const el = document.getElementById('confirmClearModal'); if (el) el.classList.add('active'); }
function closeConfirmClear() { const el = document.getElementById('confirmClearModal'); if (el) el.classList.remove('active'); }
function downloadQR() { const qrImg = document.querySelector('#qrCodeContainer img'); const qrCanvas = document.querySelector('#qrCodeContainer canvas'); if (!qrImg && !qrCanvas) { if (typeof showToast === 'function') showToast('Không tìm th?y mã QR!'); else alert('Không tìm th?y mã QR!'); return; } let url; if (qrCanvas) url = qrCanvas.toDataURL('image/png'); else if (qrImg) url = qrImg.src; const a = document.createElement('a'); a.href = url; a.download = 'build-pc-qr.png'; document.body.appendChild(a); a.click(); document.body.removeChild(a); }

async function handleNewsletterSubscribe(event) {
    if (event) event.preventDefault();
    const input = document.getElementById('newsletterEmail');
    if (!input) return;
    const email = input.value ? input.value.trim() : '';

    if (!email) {
        if (typeof showToast === 'function') showToast('⚠️ Vui lòng nhập địa chỉ Email của bạn!');
        else alert('Vui lòng nhập địa chỉ Email!');
        return;
    }

    const btn = document.querySelector('.newsletter .btn-subscribe');
    const originalText = btn ? btn.innerText : 'Đăng ký';
    if (btn) {
        btn.disabled = true;
        btn.innerText = 'Đang gửi...';
    }

    try {
        const formData = new FormData();
        formData.append('email', email);

        const response = await fetch('/api/newsletter/subscribe', {
            method: 'POST',
            body: formData
        });

        const data = await response.json();

        if (data.success) {
            if (typeof showToast === 'function') {
                showToast(data.message || '🎉 Đăng ký nhận tin thành công!');
            } else {
                alert(data.message || 'Đăng ký nhận tin thành công!');
            }
            if (!data.alreadySubscribed) {
                input.value = '';
            }
        } else {
            if (typeof showToast === 'function') {
                showToast('⚠️ ' + (data.message || 'Đăng ký thất bại!'));
            } else {
                alert(data.message || 'Đăng ký thất bại!');
            }
        }
    } catch (err) {
        console.error('Newsletter subscribe error:', err);
        if (typeof showToast === 'function') showToast('⚠️ Có lỗi xảy ra. Vui lòng thử lại!');
        else alert('Có lỗi xảy ra. Vui lòng thử lại!');
    } finally {
        if (btn) {
            btn.disabled = false;
            btn.innerText = originalText;
        }
    }
}
