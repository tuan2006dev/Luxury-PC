import React, { useState, useEffect, useRef } from 'react';
import { COMBO_BUILDS } from '../../data/constants';

// Simple AI chatbot responses based on keywords
export const CHATBOT_RESPONSES = {
  greet: ['Xin chào! Tôi là Luxe AI - trợ lý tư vấn build PC của bạn 🤖\n\nTôi có thể giúp bạn:\n• Chọn cấu hình phù hợp ngân sách\n• Kiểm tra tương thích linh kiện\n• Gợi ý combo build phù hợp\n• Giải thích thông số kỹ thuật\n\nBạn cần tư vấn gì không? 😊'],
  budget: {
    low: 'Với ngân sách dưới 15 triệu, tôi gợi ý **Combo Entry** 🎮\n\n• CPU: i5-14600K hoặc Ryzen 5 7600X\n• GPU: RTX 4060 Ti (chơi game 1080p Ultra tốt)\n• RAM: 32GB DDR5\n• Phù hợp: Game 1080p, Office, Stream nhẹ\n\nBạn có muốn xem thêm chi tiết combo này không?',
    mid: 'Ngân sách 20-40 triệu là tầm mid-range rất ngon! ⚡\n\n• CPU: Ryzen 7 7800X3D (best gaming CPU)\n• GPU: RTX 4070 Ti Super\n• RAM: 32GB DDR5 6000MHz+\n• Phù hợp: 1440p Ultra, Content Creator nhẹ\n\nGợi ý: Chọn **Combo Mid-Range Monster** để tiết kiệm thời gian!',
    high: 'Ngân sách cao - không giới hạn! 🚀 Tôi gợi ý:\n\n• CPU: i9-14900K hoặc Ryzen 9 7950X3D\n• GPU: RTX 4090 (vua 4K)\n• RAM: 64GB DDR5 7200MHz\n• Case: Phanteks/NZXT full kính đẹp\n\nXem **Combo Ultra** hoặc **AMD Beast** để build ngay!'
  },
  gaming: 'Cho mục đích **Gaming**, CPU quan trọng nhất là:\n\n🎯 **1080p Gaming**: Ryzen 5 7600X + RTX 4060 Ti (~20 triệu)\n🎯 **1440p Gaming**: Ryzen 7 7800X3D + RTX 4070 Ti (~35 triệu)\n🎯 **4K Gaming**: i9-14900K / R9 7950X3D + RTX 4090 (70+ triệu)\n\nLưu ý: 3D V-Cache (7800X3D, 7950X3D) giúp tăng 20-30% FPS gaming!',
  workstation: 'Cho **Workstation** (đồ họa, render, AI):\n\n💻 **3D Render/Video**: Ryzen 9 7950X3D + RTX 4080 Super\n🎨 **Design Adobe**: i7-14700K + RAM 64GB + RTX 4070 Ti\n🤖 **AI/ML**: i9-14900K + RTX 4090 + RAM 64GB DDR5\n\nLưu ý: RAM nhiều (64GB+) và GPU VRAM lớn (24GB) rất quan trọng!',
  cooling: 'Về **Tản nhiệt**:\n\n❄️ **AIO Liquid 360mm**: Tốt nhất cho i9/R9 (NZXT Kraken Elite, Corsair H150i)\n💨 **Air Cooler**: Noctua NH-D15 - mạnh như AIO 240, ít ồn hơn, rẻ hơn\n🌊 **AIO 240mm**: Phù hợp i5/R5, tiết kiệm ngân sách\n\nCPU gen mới chạy nóng, khuyên dùng AIO 360mm cho i7/i9 và R7/R9!',
  case: 'Về **Vỏ Case**:\n\n🏆 **Full Tower**: Phanteks 719 (cho E-ATX, nhiều fan)\n⭐ **Mid Tower**: Lian Li O11 (phổ biến nhất, kính kép đẹp)\n💙 **Kính 4 mặt**: NZXT H9 Elite (view đẹp nhất)\n🔇 **Chống ồn**: be quiet! Dark Base Pro 901\n⚡ **Compact**: Fractal Torrent (nhỏ gọn nhưng thoáng khí)\n\nTip: Chọn case phù hợp mainboard size (ATX, mATX, E-ATX)!',
  ram: 'Về **RAM DDR5**:\n\n• **32GB**: Đủ dùng cho gaming + streaming\n• **64GB**: Tốt cho workstation, video editing\n• **Tốc độ**: Chọn ít nhất 5600MHz, lý tưởng 6000-6400MHz\n\n💡 AMD Ryzen hưởng lợi nhiều từ RAM nhanh hơn Intel!\nG.Skill Trident Z5 RGB (6400MHz) là lựa chọn cao cấp đẹp nhất.',
  gpu: 'Về **GPU (Card đồ họa)**:\n\n🥇 **RTX 4090**: Vua 4K, 24GB VRAM (54.9 triệu)\n🥈 **RTX 4080 Super**: 4K High, tốt nhất tầm 36 triệu\n🥉 **RTX 4070 Ti Super**: 1440p Ultra (22.5 triệu)\n🎮 **RX 7800 XT**: AMD 1440p ngon, 16GB VRAM (14.5 triệu)\n💰 **RTX 4060 Ti**: 1080p max fps (12.8 triệu)\n\nNVIDIA mạnh về DLSS 3, AMD mạnh về giá/VRAM ratio!',
  compatible: 'Về **Tương thích**:\n\n✅ **Intel LGA1700**: Dùng mainboard Z790/B760/H610\n✅ **AMD AM5**: Dùng mainboard X670E/X670/B650/A620\n\n⚠️ Intel CPU KHÔNG dùng board AMD và ngược lại!\n\n💡 RAM DDR5 cần mainboard DDR5 (các board mới 2024+)\n💡 PSU 850W+ cho RTX 4090, 750W cho RTX 4080\n\nHệ thống tự kiểm tra tương thích khi bạn lắp ráp!',
  help: 'Tôi có thể tư vấn về:\n\n🎮 **Gaming build** - gõ "gaming"\n💼 **Workstation** - gõ "workstation"\n💰 **Ngân sách** - gõ "15 triệu" hoặc "30 triệu"\n❄️ **Tản nhiệt** - gõ "cooling" hoặc "tản nhiệt"\n📦 **Vỏ case** - gõ "case"\n🧮 **RAM** - gõ "ram"\n🎯 **GPU/Card** - gõ "gpu"\n🔗 **Tương thích** - gõ "compatible"\n\nHoặc hỏi tự nhiên - tôi sẽ cố hiểu ý bạn! 😄',
  help_short: 'Tôi có thể tư vấn về:\n\n🎮 **Gaming build** - gõ "gaming"\n💼 **Workstation** - gõ "workstation"\n💰 **Ngân sách** - gõ "15 triệu" hoặc "30 triệu"\n❄️ **Tản nhiệt** - gõ "cooling"\n📦 **Vỏ case** - gõ "case"\n🧮 **RAM** - gõ "ram"\n🎯 **GPU** - gõ "gpu"\n🔗 **Tương thích** - gõ "compatible"',
  fallback: ['Bạn có thể nói rõ hơn không? Ví dụ:\n• "Tôi muốn build gaming ~25 triệu"\n• "So sánh RTX 4080 và RTX 4090"\n• "Case nào đẹp nhất"\n\nGõ "help" để xem các chủ đề tôi tư vấn được! 🤖', 'Hmm, tôi chưa hiểu rõ câu hỏi của bạn 🤔\n\nThử hỏi theo hướng khác:\n• Build PC cho gaming 4K?\n• Ngân sách bao nhiêu?\n• Tư vấn chọn case/GPU/RAM?\n\nGõ "help" để xem danh sách chủ đề!']
};

export function getChatbotResponse(input) {
  const msg = input.toLowerCase();
  if (msg.match(/xin chào|hello|hi|chào|alo/)) return CHATBOT_RESPONSES.greet[0];
  if (msg.match(/help|giúp|tư vấn|hỗ trợ/)) return CHATBOT_RESPONSES.help;
  if (msg.match(/gaming|game|chơi game|fps|esport/)) return CHATBOT_RESPONSES.gaming;
  if (msg.match(/workstation|render|3d|đồ họa|thiết kế|video|ai|machine learning/)) return CHATBOT_RESPONSES.workstation;
  if (msg.match(/cooling|tản nhiệt|fan|quạt|aio|liquid/)) return CHATBOT_RESPONSES.cooling;
  if (msg.match(/case|vỏ|thùng|tower/)) return CHATBOT_RESPONSES.case;
  if (msg.match(/ram|memory|bộ nhớ|ddr5/)) return CHATBOT_RESPONSES.ram;
  if (msg.match(/gpu|card|vga|rtx|radeon|nvidia|amd card/)) return CHATBOT_RESPONSES.gpu;
  if (msg.match(/tương thích|compatible|socket|lga|am5/)) return CHATBOT_RESPONSES.compatible;
  // Budget detection
  const budgetMatch = msg.match(/(\d+)\s*(triệu|tr|million|m)/);
  if (budgetMatch) {
    const amount = parseInt(budgetMatch[1]);
    if (amount < 20) return CHATBOT_RESPONSES.budget.low;
    if (amount < 50) return CHATBOT_RESPONSES.budget.mid;
    return CHATBOT_RESPONSES.budget.high;
  }
  const idx = Math.floor(Math.random() * CHATBOT_RESPONSES.fallback.length);
  return CHATBOT_RESPONSES.fallback[idx];
}

// --- MAIN CHATBOT COMPONENT ---
export function Chatbot({ onClose, build, totalPrice, onApplyCombo, activeTicket, setActiveTicket }) {
  const [mode, setMode] = useState('chat'); // 'chat' | 'consultant-form' | 'consultant-success' | 'live-chat'
  const [messages, setMessages] = useState([
    { role: 'bot', text: 'Xin chào! Tôi là **Luxe AI** 🤖\n\nTôi có thể giúp bạn tư vấn build PC, hoặc kết nối bạn với **nhân viên thật** khi cần!\n\nGõ "help" để xem danh sách, hoặc hỏi thẳng nhé 😊' }
  ]);
  const [input, setInput] = useState('');
  const [typing, setTyping] = useState(false);
  const [form, setForm] = useState({
    name: '', email: '', phone: '',
    category: 'BUILD_PC',
    subject: 'Tư vấn Build PC 3D',
    message: ''
  });
  const [formLoading, setFormLoading] = useState(false);
  const [ticketId, setTicketId] = useState(null);
  const [chatMessages, setChatMessages] = useState([]);
  const [liveChatInput, setLiveChatInput] = useState('');
  const chatEndRef = useRef(null);

  // Sync with activeTicket passed from parent
  useEffect(() => {
    if (activeTicket && activeTicket.id) {
      setTicketId(activeTicket.id);
      setMode('live-chat');
    }
  }, [activeTicket]);

  // Polling chat messages
  useEffect(() => {
    if (mode !== 'live-chat' || !ticketId) return;

    const fetchMessages = async () => {
      try {
        const baseUrl = import.meta.env.DEV ? 'http://localhost:8080' : '';
        const res = await fetch(`${baseUrl}/api/tickets/${ticketId}/messages`);
        if (res.ok) {
          const data = await res.json();
          setChatMessages(data);
        }
      } catch (err) {
        console.error("Error polling chat messages:", err);
      }
    };

    fetchMessages(); // Initial fetch
    const interval = setInterval(fetchMessages, 1500); // Poll every 1.5 seconds
    return () => clearInterval(interval);
  }, [mode, ticketId]);

  // Send message in live chat
  const sendLiveChatMessage = async () => {
    if (!liveChatInput.trim() || !ticketId) return;
    const currentInput = liveChatInput.trim();
    setLiveChatInput('');

    // Optimistically add to message list
    const senderName = form.name || (activeTicket && activeTicket.customerName) || 'Khách hàng';
    const tempMsg = {
      id: Date.now(),
      ticketId: ticketId,
      sender: 'CUSTOMER',
      senderName: senderName,
      message: currentInput,
      createdAt: new Date().toISOString()
    };
    setChatMessages(prev => [...prev, tempMsg]);

    try {
      const baseUrl = import.meta.env.DEV ? 'http://localhost:8080' : '';
      const res = await fetch(`${baseUrl}/api/tickets/${ticketId}/messages`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          sender: 'CUSTOMER',
          senderName: senderName,
          message: currentInput
        })
      });
      if (res.ok) {
        const saved = await res.json();
        setChatMessages(prev => prev.map(m => m.id === tempMsg.id ? saved : m));
      }
    } catch (err) {
      console.error("Error sending message:", err);
    }
  };

  // Auto-scroll
  useEffect(() => {
    chatEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, typing, mode, chatMessages]);

  // Build config snapshot to attach
  const installedParts = Object.entries(build)
    .filter(([, v]) => v)
    .map(([cat, item]) => `${cat}: ${item.name} (${item.price.toLocaleString('vi-VN')}₫)`)
    .join('\n');
  const buildConfigSnapshot = installedParts
    ? `=== Cấu hình Build PC ===\n${installedParts}\n\nTổng: ${totalPrice.toLocaleString('vi-VN')}₫`
    : '';

  // Trigger consultant mode from chat
  const triggerConsultant = () => {
    setMessages(prev => [...prev,
      { role: 'bot', text: '👨‍💻 **Kết nối nhân viên tư vấn thật!**\n\nVui lòng điền thông tin bên dưới. Nhân viên sẽ liên hệ trong **30 phút**.' }
    ]);
    setTimeout(() => setMode('consultant-form'), 600);
  };

  // Detect consultant keywords in chatbot response
  const CONSULTANT_TRIGGERS = /gặp nhân viên|tư vấn trực tiếp|nhân viên thật|gặp người thật|liên hệ nhân viên|book tư vấn|đặt lịch|speak to (human|staff|agent)/i;

  const send = () => {
    if (!input.trim()) return;
    const userMsg = input.trim();
    setInput('');
    setMessages(prev => [...prev, { role: 'user', text: userMsg }]);

    // Check if user wants human consultant
    if (CONSULTANT_TRIGGERS.test(userMsg)) {
      setTyping(true);
      setTimeout(() => {
        setTyping(false);
        triggerConsultant();
      }, 700);
      return;
    }

    setTyping(true);
    setTimeout(() => {
      const response = getChatbotResponse(userMsg);
      setMessages(prev => [...prev, { role: 'bot', text: response }]);
      setTyping(false);
    }, 800 + Math.random() * 600);
  };

  const handleKey = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); send(); }
  };

  const handleSubmitTicket = async (e) => {
    e.preventDefault();
    if (!form.name || !form.email) return;
    setFormLoading(true);
    try {
      const payload = {
        ...form,
        message: form.message + (buildConfigSnapshot ? '\n\n' + buildConfigSnapshot : ''),
        buildConfig: buildConfigSnapshot
      };
      const baseUrl = import.meta.env.DEV ? 'http://localhost:8080' : '';
      const res = await fetch(`${baseUrl}/api/tickets/submit`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
      const data = await res.json();
      if (data.success) {
        setTicketId(data.ticketId);
        if (setActiveTicket) {
          setActiveTicket({ id: data.ticketId, customerName: form.name });
        }
        setMode('live-chat');
      }
    } catch (err) {
      console.error(err);
      setMessages(prev => [...prev, { role: 'bot', text: '❌ Có lỗi xảy ra khi gửi yêu cầu. Vui lòng thử lại sau.' }]);
    }
    setFormLoading(false);
  };

  const formatText = (text) => {
    if (!text) return '';
    return text.split('\n').map((line, i) => (
      <span key={i}>
        {line.split(/\*\*(.+?)\*\*/).map((part, j) =>
          j % 2 === 1 ? <strong key={j} style={{ color: '#c9a84c' }}>{part}</strong> : part
        )}
        {i < text.split('\n').length - 1 && <br />}
      </span>
    ));
  };

  // Header label changes by mode
  const headerMeta = {
    chat: { avatar: '🤖', title: 'Luxe AI Assistant', sub: 'Tư vấn build PC thông minh' },
    'consultant-form': { avatar: '👨‍💻', title: 'Kết nối nhân viên', sub: 'Điền thông tin để được tư vấn 1:1' },
    'consultant-success': { avatar: '✅', title: 'Yêu cầu đã gửi!', sub: `Ticket #${ticketId} · Phản hồi trong 30 phút` },
    'live-chat': { avatar: '👨‍💻', title: 'Nhân viên hỗ trợ', sub: `Ticket #${ticketId} · Trực tuyến 🟢` }
  };
  const hm = headerMeta[mode] || headerMeta.chat;

  return (
    <div className="chatbot-window">
      {/* Header */}
      <div className="chatbot-header">
        <div className="chatbot-avatar">{hm.avatar}</div>
        <div>
          <div className="chatbot-title">{hm.title}</div>
          <div className="chatbot-subtitle">{hm.sub}</div>
        </div>
        <button className="chatbot-close" onClick={onClose}>✕</button>
      </div>

      {/* Mode indicator bar */}
      <div className="chatbot-mode-bar">
        <div className={`mode-step ${mode === 'chat' || mode === 'consultant-form' || mode === 'live-chat' ? 'done' : ''}`}>
          🤖 AI Chat
        </div>
        <div className="mode-arrow">›</div>
        <div className={`mode-step ${mode === 'consultant-form' || mode === 'live-chat' ? 'active' : ''}`}>
          👨‍💻 Nhân viên
        </div>
        <div className="mode-arrow">›</div>
        <div className={`mode-step ${mode === 'live-chat' ? 'active' : ''}`}>
          💬 Live Chat
        </div>
      </div>

      {/* Messages (always visible) */}
      <div className="chatbot-messages">
        {mode === 'live-chat' ? (
          chatMessages.map((msg, i) => {
            const isCustomer = msg.sender === 'CUSTOMER';
            return (
              <div key={msg.id || i} className={`chat-bubble ${isCustomer ? 'user' : 'bot'}`}>
                {isCustomer ? (
                  <div className="chat-bubble-icon">👤</div>
                ) : (
                  <div className="chat-bubble-icon">👨‍💻</div>
                )}
                <div style={{ display: 'flex', flexDirection: 'column', width: '100%', alignItems: isCustomer ? 'flex-end' : 'flex-start' }}>
                  <div style={{ fontSize: '0.6rem', color: '#888', marginBottom: '0.2rem', padding: '0 0.2rem' }}>
                    {msg.senderName} · {new Date(msg.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                  </div>
                  <div className="chat-bubble-text">
                    {formatText(msg.message)}
                  </div>
                </div>
              </div>
            );
          })
        ) : (
          messages.map((msg, i) => {
            const combos = [];
            if (msg.role === 'bot') {
              const lower = msg.text.toLowerCase();
              if (lower.includes('combo entry') || lower.includes('chiến game entry')) combos.push({ id: 'combo_entry', name: '🎮 Entry' });
              if (lower.includes('mid-range monster') || lower.includes('combo trung cấp') || lower.includes('monster')) combos.push({ id: 'combo_midrange', name: '⚡ Mid-Range' });
              if (lower.includes('gaming king') || lower.includes('vua gaming')) combos.push({ id: 'combo_gaming_king', name: '👑 Gaming King' });
              if (lower.includes('combo ultra') || lower.includes('không giới hạn')) combos.push({ id: 'combo_ultra', name: '🚀 Ultra' });
              if (lower.includes('amd beast') || lower.includes('quái thú amd')) combos.push({ id: 'combo_amd_beast', name: '🔥 AMD Beast' });
            }
            return (
              <div key={i} className={`chat-bubble ${msg.role}`}>
                {msg.role === 'bot' && <div className="chat-bubble-icon">{mode !== 'chat' && i === messages.length - 1 ? '👨‍💻' : '🤖'}</div>}
                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-start' }}>
                  <div className="chat-bubble-text">{formatText(msg.text)}</div>
                  {combos.map(combo => (
                    <button
                      key={combo.id}
                      onClick={() => {
                        if (onApplyCombo) {
                          const found = COMBO_BUILDS.find(c => c.id === combo.id);
                          if (found) {
                            onApplyCombo(found);
                            onClose();
                          }
                        }
                      }}
                      style={{
                        marginTop: '0.4rem',
                        background: '#c9a84c',
                        color: '#000',
                        border: 'none',
                        padding: '0.25rem 0.5rem',
                        borderRadius: '3px',
                        fontSize: '0.68rem',
                        fontWeight: 'bold',
                        cursor: 'pointer',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '0.2rem'
                      }}
                    >
                      🔧 Lắp cấu hình: {combo.name}
                    </button>
                  ))}
                </div>
              </div>
            );
          })
        )}
        {typing && (
          <div className="chat-bubble bot">
            <div className="chat-bubble-icon">🤖</div>
            <div className="chat-bubble-text chat-typing">
              <span></span><span></span><span></span>
            </div>
          </div>
        )}

        {/* INLINE CONSULTANT FORM CARD */}
        {mode === 'consultant-form' && (
          <div className="consultant-inline-card">
            <div className="consultant-inline-agents">
              {[{ n: 'Minh Tuấn', r: 'Senior Builder', a: '👨‍💻' }, { n: 'Hà Linh', r: 'Gaming Spec', a: '👩‍💻' }, { n: 'Đức Khoa', r: 'Workstation', a: '🧑‍🔧' }].map((c, i) => (
                <div key={i} className="inline-agent">
                  <span className="inline-agent-avatar">{c.a}</span>
                  <div>
                    <div className="inline-agent-name">{c.n}</div>
                    <div className="inline-agent-role">{c.r}</div>
                    <div className="inline-agent-online">🟢 online</div>
                  </div>
                </div>
              ))}
            </div>

            {buildConfigSnapshot && (
              <div className="inline-build-note">
                🔧 <strong>{Object.values(build).filter(Boolean).length} linh kiện</strong> sẽ được đính kèm tự động · {totalPrice.toLocaleString('vi-VN')}₫
              </div>
            )}

            <form className="inline-consultant-form" onSubmit={handleSubmitTicket}>
              <div className="inline-form-row">
                <input required placeholder="Họ tên *" value={form.name}
                  onChange={e => setForm(p => ({ ...p, name: e.target.value }))} />
                <input required type="email" placeholder="Email *" value={form.email}
                  onChange={e => setForm(p => ({ ...p, email: e.target.value }))} />
              </div>
              <div className="inline-form-row">
                <input placeholder="SĐT" value={form.phone}
                  onChange={e => setForm(p => ({ ...p, phone: e.target.value }))} />
                <select value={form.category} onChange={e => setForm(p => ({ ...p, category: e.target.value }))}>
                  <option value="BUILD_PC">🔧 Tư vấn Build PC</option>
                  <option value="PRICE">💰 Hỏi giá / Thương lượng</option>
                  <option value="TECHNICAL">⚙️ Hỗ trợ kỹ thuật</option>
                  <option value="ORDER">📦 Đơn hàng</option>
                  <option value="GENERAL">💬 Tư vấn chung</option>
                </select>
              </div>
              <textarea placeholder="Bạn cần tư vấn gì? Budget? Mục đích?..." rows={3}
                value={form.message}
                onChange={e => setForm(p => ({ ...p, message: e.target.value }))}></textarea>
              <div className="inline-form-actions">
                <button type="button" className="inline-cancel-btn"
                  onClick={() => { setMode('chat'); }}>
                  ← Quay lại AI
                </button>
                <button type="submit" className="inline-submit-btn" disabled={formLoading}>
                  {formLoading ? '⏳ Đang gửi...' : '📨 Gửi yêu cầu'}
                </button>
              </div>
            </form>
          </div>
        )}

        <div ref={chatEndRef} />
      </div>

      {/* Quick buttons */}
      {mode === 'chat' && (
        <div className="chatbot-quick-btns">
          {['gaming', 'ngân sách 25 triệu', 'case đẹp', 'help'].map(q => (
            <button key={q} className="quick-btn" onClick={() => setInput(q)}>{q}</button>
          ))}
          <button className="quick-btn quick-btn-consultant" onClick={triggerConsultant}>
            👨‍💻 Gặp nhân viên
          </button>
        </div>
      )}

      {mode === 'live-chat' && (
        <div className="chatbot-quick-btns">
          <button className="quick-btn" onClick={() => { setMode('chat'); }}>
            🤖 Trở lại AI Chat
          </button>
        </div>
      )}

      {/* Input */}
      {(mode === 'chat' || mode === 'consultant-success' || mode === 'live-chat') && (
        <div className="chatbot-input-row">
          <textarea
            className="chatbot-input"
            placeholder={
              mode === 'live-chat'
                ? 'Nhập tin nhắn chat với nhân viên...'
                : mode === 'consultant-success'
                ? 'Tiếp tục hỏi AI trong khi chờ...'
                : 'Hỏi về linh kiện, budget, tương thích...'
            }
            value={mode === 'live-chat' ? liveChatInput : input}
            onChange={e => {
              if (mode === 'live-chat') {
                setLiveChatInput(e.target.value);
              } else {
                setInput(e.target.value);
              }
            }}
            onKeyDown={(e) => {
              if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                if (mode === 'live-chat') {
                  sendLiveChatMessage();
                } else {
                  send();
                }
              }
            }}
            rows={1}
          />
          <button
            className="chatbot-send"
            onClick={mode === 'live-chat' ? sendLiveChatMessage : send}
            disabled={mode === 'live-chat' ? !liveChatInput.trim() : !input.trim()}
          >
            ➤
          </button>
        </div>
      )}
    </div>
  );
}

// --- STANDALONE CONSULTANT POPUP MODAL ---
export function ConsultantModal({ build, totalPrice, onClose, onStartChat }) {
  const [step, setStep] = useState(1); // 1=form, 2=success
  const [loading, setLoading] = useState(false);
  const [ticketId, setTicketId] = useState(null);
  const [form, setForm] = useState({
    name: '', email: '', phone: '',
    category: 'BUILD_PC',
    subject: 'Tư vấn Build PC 3D',
    message: ''
  });

  const installedParts = Object.entries(build)
    .filter(([, v]) => v)
    .map(([cat, item]) => `${cat}: ${item.name} (${item.price.toLocaleString('vi-VN')}₫)`)
    .join('\n');

  const buildConfigSnapshot = installedParts
    ? `=== Cấu hình Build PC ===\n${installedParts}\n\nTổng: ${totalPrice.toLocaleString('vi-VN')}₫`
    : '';

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.name || !form.email) return;
    setLoading(true);
    try {
      const payload = {
        ...form,
        message: form.message + (buildConfigSnapshot ? '\n\n' + buildConfigSnapshot : ''),
        buildConfig: buildConfigSnapshot
      };
      const baseUrl = import.meta.env.DEV ? 'http://localhost:8080' : '';
      const res = await fetch(`${baseUrl}/api/tickets/submit`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
      const data = await res.json();
      if (data.success) {
        setTicketId(data.ticketId);
        setStep(2);
      }
    } catch (err) {
      console.error(err);
    }
    setLoading(false);
  };

  const consultants = [
    { name: 'Minh Tuấn', role: 'Senior PC Builder', avatar: '👨‍💻', rating: '4.9', reviews: '312' },
    { name: 'Hà Linh', role: 'Gaming Specialist', avatar: '👩‍💻', rating: '4.8', reviews: '245' },
    { name: 'Đức Khoa', role: 'Workstation Expert', avatar: '🧑‍🔧', rating: '4.9', reviews: '189' },
  ];

  return (
    <div className="consultant-overlay" onClick={(e) => e.target === e.currentTarget && onClose()}>
      <div className="consultant-modal">
        {/* Modal Header */}
        <div className="consultant-modal-header">
          <div>
            <div className="consultant-modal-title">
              <i style={{ marginRight: '0.5rem' }}>💼</i> Gặp Nhân Viên Tư Vấn
            </div>
            <div className="consultant-modal-sub">Chuyên gia build PC sẽ hỗ trợ bạn trong 30 phút</div>
          </div>
          <button className="consultant-close" onClick={onClose}>✕</button>
        </div>

        {step === 1 && (
          <div className="consultant-body">
            {/* Consultants row */}
            <div className="consultants-row">
              {consultants.map((c, i) => (
                <div key={i} className="consultant-card">
                  <div className="consultant-avatar">{c.avatar}</div>
                  <div className="consultant-name">{c.name}</div>
                  <div className="consultant-role">{c.role}</div>
                  <div className="consultant-rating">⭐ {c.rating} <span>({c.reviews})</span></div>
                  <div className="consultant-status">🟢 Đang online</div>
                </div>
              ))}
            </div>

            {/* Build summary if has parts */}
            {installedParts && (
              <div className="build-attached-note">
                <i>🔧</i>
                <div>
                  <div style={{ fontWeight: 600, marginBottom: '0.2rem', fontSize: '0.78rem' }}>
                    Cấu hình Build PC sẽ được đính kèm tự động
                  </div>
                  <div style={{ fontSize: '0.68rem', color: '#888' }}>
                    {Object.values(build).filter(Boolean).length} linh kiện · Tổng {totalPrice.toLocaleString('vi-VN')}₫
                  </div>
                </div>
              </div>
            )}

            {/* Contact form */}
            <form className="consultant-form" onSubmit={handleSubmit}>
              <div className="form-row-2">
                <div className="form-group">
                  <label>Họ tên *</label>
                  <input required placeholder="Nguyễn Văn A" value={form.name}
                    onChange={e => setForm(p => ({ ...p, name: e.target.value }))} />
                </div>
                <div className="form-group">
                  <label>Email *</label>
                  <input required type="email" placeholder="email@gmail.com" value={form.email}
                    onChange={e => setForm(p => ({ ...p, email: e.target.value }))} />
                </div>
              </div>
              <div className="form-row-2">
                <div className="form-group">
                  <label>Số điện thoại</label>
                  <input placeholder="0901 234 567" value={form.phone}
                    onChange={e => setForm(p => ({ ...p, phone: e.target.value }))} />
                </div>
                <div className="form-group">
                  <label>Loại yêu cầu</label>
                  <select value={form.category} onChange={e => setForm(p => ({ ...p, category: e.target.value }))}>
                    <option value="BUILD_PC">🔧 Tư vấn Build PC</option>
                    <option value="PRICE">💰 Hỏi giá / Thương lượng</option>
                    <option value="TECHNICAL">⚙️ Hỗ trợ kỹ thuật</option>
                    <option value="ORDER">📦 Vấn đề đơn hàng</option>
                    <option value="GENERAL">💬 Tư vấn chung</option>
                  </select>
                </div>
              </div>
              <div className="form-group">
                <label>Tiêu đề</label>
                <input placeholder="Mô tả ngắn yêu cầu của bạn" value={form.subject}
                  onChange={e => setForm(p => ({ ...p, subject: e.target.value }))} />
              </div>
              <div className="form-group">
                <label>Nội dung chi tiết</label>
                <textarea rows={4} placeholder="Bạn cần tư vấn gì? Budget bao nhiêu? Mục đích sử dụng?..."
                  value={form.message}
                  onChange={e => setForm(p => ({ ...p, message: e.target.value }))}></textarea>
              </div>
              <button type="submit" className="consultant-submit-btn" disabled={loading}>
                {loading ? '⏳ Đang gửi...' : '📨 Gửi yêu cầu tư vấn'}
              </button>
            </form>
          </div>
        )}

        {step === 2 && (
          <div className="consultant-success">
            <div className="success-icon">✅</div>
            <h2>Yêu cầu đã được gửi!</h2>
            <p>Ticket <strong style={{ color: '#c9a84c' }}>#{ticketId}</strong> đã được tạo thành công.</p>
            <p>Nhân viên tư vấn sẽ liên hệ với bạn qua email trong vòng <strong>30 phút</strong>.</p>
            <div className="success-tips">
              <div>💡 <strong>Tip:</strong> Bạn có thể theo dõi trạng thái ticket bằng email đã đăng ký</div>
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', marginTop: '1.5rem', width: '100%' }}>
              {onStartChat && (
                <button
                  className="consultant-submit-btn"
                  style={{ background: '#c9a84c', color: '#000' }}
                  onClick={() => onStartChat(ticketId, form.name)}
                >
                  💬 Trò chuyện Trực tiếp Ngay
                </button>
              )}
              <button className="consultant-submit-btn" style={{ background: '#333' }} onClick={onClose}>
                Đóng
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
