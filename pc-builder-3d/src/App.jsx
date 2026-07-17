import React, { useState, useEffect } from 'react';
import { Canvas } from '@react-three/fiber';
import { OrbitControls } from '@react-three/drei';

// --- IMPORTS FOR CONSTANTS & UTILITIES ---
import { COMPONENTS_DATA, COMBO_BUILDS, CATEGORIES, getRGBColor } from './data/constants';

// --- IMPORTS FOR 3D COMPONENTS & CONTROLS ---
import { CameraController, AnnotationCallout } from './components/3d/SceneControls';
import { CaseChassis, Motherboard, AnimatedMesh } from './components/3d/PCComponents';

// --- IMPORTS FOR CHATBOT & UI MODALS ---
import { Chatbot, ConsultantModal } from './components/ui/Chatbot';

// --- HELPER TO RESOLVE WORLD TGT COORDINATES ---
const getComponentWorldPos = (category, item) => {
  if (!item) return [0, 0, 0];
  const pcOffset = [1.85, 0.55, 0];
  if (category === 'CASE') {
    return pcOffset;
  }
  if (category === 'MAINBOARD') {
    return [pcOffset[0] - 0.2, pcOffset[1] + 0.2, pcOffset[2] - 0.6];
  }
  if (category === 'MONITOR') {
    return [-1.25, 0.78, -0.75];
  }
  if (category === 'KEYBOARD') {
    return [-1.25, -2.35, 1.35];
  }
  if (category === 'MOUSE') {
    return [0.05, -2.35, 1.35];
  }
  const relativePos = item.pos || [0, 0, 0];
  return [pcOffset[0] + relativePos[0], pcOffset[1] + relativePos[1], pcOffset[2] + relativePos[2]];
};

const CORE_CATEGORIES = ['CASE', 'MAINBOARD', 'CPU', 'COOLER', 'RAM', 'GPU', 'PSU'];

// --- MAIN APP COMPONENT ---
function App() {
  const [activeCategory, setActiveCategory] = useState('CASE');
  const [activeTab, setActiveTab] = useState('builder'); // 'builder' | 'combo'
  const [build, setBuild] = useState({ CASE: null, MAINBOARD: null, CPU: null, COOLER: null, RAM: null, GPU: null, PSU: null, MONITOR: null, KEYBOARD: null, MOUSE: null });
  const [history, setHistory] = useState([{ CASE: null, MAINBOARD: null, CPU: null, COOLER: null, RAM: null, GPU: null, PSU: null, MONITOR: null, KEYBOARD: null, MOUSE: null }]);
  const [historyIndex, setHistoryIndex] = useState(0);
  const [toast, setToast] = useState('');
  const [cameraPreset, setCameraPreset] = useState('front');
  const [componentsData, setComponentsData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [showChatbot, setShowChatbot] = useState(false);
  const [showConsultant, setShowConsultant] = useState(false);
  const [isSidebarHidden, setIsSidebarHidden] = useState(false);
  const [isPoweredOn, setIsPoweredOn] = useState(true);
  const [explodedFactor, setExplodedFactor] = useState(0);
  const [isDarkRoom, setIsDarkRoom] = useState(false);
  const [rgbColorMode, setRgbColorMode] = useState('rainbow');

  // Sharing states
  const [shareCode, setShareCode] = useState(null);
  const [showShareModal, setShowShareModal] = useState(false);
  const [sharingLoading, setSharingLoading] = useState(false);
  const [inputShareCode, setInputShareCode] = useState('');
  const [activeTicket, setActiveTicket] = useState(null);

  // Phase 2 Premium Enhancements states
  const [isAutoRotating, setIsAutoRotating] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedBrand, setSelectedBrand] = useState('');

  // Reset filters when activeCategory changes
  useEffect(() => {
    setSearchQuery('');
    setSelectedBrand('');
  }, [activeCategory]);

  const triggerToast = (msg) => {
    setToast(msg);
    setTimeout(() => setToast(''), 3000);
  };

  useEffect(() => {
    const initApp = async () => {
      const enrichComponents = (components) => {
        const enriched = { ...components };
        for (const [category, items] of Object.entries(enriched)) {
          if (!Array.isArray(items)) continue;
          enriched[category] = items.map(item => {
            const normName = item.name.toLowerCase().replace(/[^a-z0-9]/g, '');
            const mockMatch = COMPONENTS_DATA[category]?.find(mock => {
              const normMock = mock.name.toLowerCase().replace(/[^a-z0-9]/g, '');
              return normName.includes(normMock) || normMock.includes(normName);
            });

            let fixedImage = item.image;
            if (fixedImage && fixedImage.startsWith('/') && import.meta.env.DEV) {
              fixedImage = `http://localhost:8080${fixedImage}`;
            }

            if (mockMatch) {
              return {
                ...item,
                image: fixedImage || mockMatch.image,
                tdp: mockMatch.tdp,
                maxGpuLength: mockMatch.maxGpuLength,
                maxCoolerHeight: mockMatch.maxCoolerHeight,
                maxRamBus: mockMatch.maxRamBus,
                height: mockMatch.height,
                bus: mockMatch.bus,
                clearance: mockMatch.clearance,
                length: mockMatch.length,
                wattage: mockMatch.wattage
              };
            } else {
              const enrichedItem = { ...item, image: fixedImage };
              if (category === 'CASE') {
                enrichedItem.maxGpuLength = 380;
                enrichedItem.maxCoolerHeight = 165;
              } else if (category === 'MAINBOARD') {
                enrichedItem.maxRamBus = 6600;
              } else if (category === 'CPU') {
                enrichedItem.tdp = item.name.toLowerCase().includes('i9') || item.name.toLowerCase().includes('i7') ? 253 : 125;
              } else if (category === 'COOLER') {
                enrichedItem.clearance = item.name.toLowerCase().includes('noctua') ? 37 : 60;
                enrichedItem.tdp = 10;
              } else if (category === 'RAM') {
                enrichedItem.height = item.name.toLowerCase().includes('dominator') ? 56 : 40;
                enrichedItem.bus = item.name.toLowerCase().includes('7200') ? 7200 : 5600;
                enrichedItem.tdp = 5;
              } else if (category === 'GPU') {
                enrichedItem.tdp = item.name.toLowerCase().includes('4090') ? 450 : (item.name.toLowerCase().includes('4080') ? 320 : 200);
                enrichedItem.length = item.name.toLowerCase().includes('strix') ? 357 : 290;
              } else if (category === 'PSU') {
                const match = item.name.match(/(\d+)\s*W/i) || item.name.match(/(\d+)/);
                let parsedWattage = 750;
                if (match) {
                  const parsedVal = parseInt(match[1]);
                  if (parsedVal >= 300 && parsedVal <= 2000) parsedWattage = parsedVal;
                }
                enrichedItem.wattage = parsedWattage;
              }
              return enrichedItem;
            }
          });
        }
        return enriched;
      };

      let allComponents = COMPONENTS_DATA;
      try {
        const url = import.meta.env.DEV ? 'http://localhost:8080/api/build/components' : '/api/build/components';
        const res = await fetch(url);
        if (res.ok) {
          const rawComponents = await res.json();
          allComponents = enrichComponents(rawComponents);
          setComponentsData(allComponents);
        } else {
          allComponents = enrichComponents(COMPONENTS_DATA);
          setComponentsData(allComponents);
        }
      } catch (err) {
        console.warn("Dùng Mock COMPONENTS_DATA làm dự phòng");
        allComponents = enrichComponents(COMPONENTS_DATA);
        setComponentsData(allComponents);
      }

      // Check URL parameters for share code
      const params = new URLSearchParams(window.location.search);
      const code = params.get('share');
      if (code) {
        triggerToast('🔄 Đang tải cấu hình chia sẻ...');
        try {
          const shareUrl = import.meta.env.DEV ? `http://localhost:8080/api/build/share/${code}` : `/api/build/share/${code}`;
          const res = await fetch(shareUrl);
          if (res.ok) {
            const sharedData = await res.json();
            const newBuild = { CASE: null, MAINBOARD: null, CPU: null, COOLER: null, RAM: null, GPU: null, PSU: null };
            
            const keysMap = {
              CASE: sharedData.caseId,
              MAINBOARD: sharedData.mainboardId,
              CPU: sharedData.cpuId,
              COOLER: sharedData.coolerId,
              RAM: sharedData.ramId,
              GPU: sharedData.gpuId,
              PSU: sharedData.psuId
            };

            for (const [category, targetId] of Object.entries(keysMap)) {
              if (targetId) {
                const item = allComponents[category]?.find(i => String(i.id) === String(targetId));
                if (item) newBuild[category] = item;
              }
            }

            setBuild(newBuild);
            setHistory([newBuild]);
            setHistoryIndex(0);
            triggerToast('🎉 Đã áp dụng cấu hình được chia sẻ thành công!');
          } else {
            triggerToast('❌ Không tìm thấy cấu hình chia sẻ');
          }
        } catch (err) {
          console.error(err);
          triggerToast('❌ Lỗi tải link chia sẻ');
        }
      }
      setLoading(false);
    };

    initApp();
  }, []);

  useEffect(() => {
    const handleKeyDown = (e) => {
      // 1. Undo: Ctrl + Z
      if (e.ctrlKey && e.key.toLowerCase() === 'z') {
        e.preventDefault();
        handleUndo();
      }
      // 2. Redo: Ctrl + Y
      if (e.ctrlKey && e.key.toLowerCase() === 'y') {
        e.preventDefault();
        handleRedo();
      }
      // 3. Space: Toggle PC power
      if (e.key === ' ' && document.activeElement.tagName !== 'INPUT' && document.activeElement.tagName !== 'TEXTAREA') {
        e.preventDefault();
        setIsPoweredOn(prev => {
          const next = !prev;
          triggerToast(`⏻ Nguồn PC: ${next ? 'BẬT' : 'TẮT'}`);
          return next;
        });
      }
      // 4. Esc: Close active modals
      if (e.key === 'Escape') {
        setShowChatbot(false);
        setShowConsultant(false);
        setShowShareModal(false);
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [historyIndex, history, isPoweredOn]);

  const handleShareBuild = async () => {
    const installedCount = Object.values(build).filter(Boolean).length;
    if (installedCount === 0) {
      triggerToast('⚠️ Hãy lắp ít nhất 1 linh kiện trước khi chia sẻ!');
      return;
    }
    
    setSharingLoading(true);
    try {
      const payload = {
        caseId: build.CASE?.id,
        mainboardId: build.MAINBOARD?.id,
        cpuId: build.CPU?.id,
        coolerId: build.COOLER?.id,
        ramId: build.RAM?.id,
        gpuId: build.GPU?.id,
        psuId: build.PSU?.id,
        totalPrice: totalPrice
      };

      const url = import.meta.env.DEV ? 'http://localhost:8080/api/build/share' : '/api/build/share';
      const res = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });

      if (res.ok) {
        const data = await res.json();
        setShareCode(data.shareCode);
        setShowShareModal(true);
        triggerToast('✓ Đã tạo liên kết chia sẻ!');
      } else {
        triggerToast('❌ Thất bại khi tạo mã chia sẻ');
      }
    } catch (err) {
      console.error(err);
      triggerToast('❌ Lỗi kết nối mạng khi chia sẻ');
    }
    setSharingLoading(false);
  };

  const handleLoadShareCode = async () => {
    if (!inputShareCode.trim()) {
      triggerToast('⚠️ Vui lòng nhập mã cấu hình!');
      return;
    }
    triggerToast('🔄 Đang tải cấu hình...');
    try {
      const shareUrl = import.meta.env.DEV 
        ? `http://localhost:8080/api/build/share/${inputShareCode.trim()}` 
        : `/api/build/share/${inputShareCode.trim()}`;
      const res = await fetch(shareUrl);
      if (res.ok) {
        const sharedData = await res.json();
        const allComponents = componentsData || COMPONENTS_DATA;
        const newBuild = { CASE: null, MAINBOARD: null, CPU: null, COOLER: null, RAM: null, GPU: null, PSU: null };
        
        const keysMap = {
          CASE: sharedData.caseId,
          MAINBOARD: sharedData.mainboardId,
          CPU: sharedData.cpuId,
          COOLER: sharedData.coolerId,
          RAM: sharedData.ramId,
          GPU: sharedData.gpuId,
          PSU: sharedData.psuId
        };

        for (const [category, targetId] of Object.entries(keysMap)) {
          if (targetId) {
            const item = allComponents[category]?.find(i => String(i.id) === String(targetId));
            if (item) newBuild[category] = item;
          }
        }

        setBuild(newBuild);
        setHistory([newBuild]);
        setHistoryIndex(0);
        triggerToast('🎉 Đã áp dụng cấu hình chia sẻ thành công!');
      } else {
        triggerToast('❌ Không tìm thấy cấu hình này');
      }
    } catch (err) {
      console.error(err);
      triggerToast('❌ Lỗi tải mã chia sẻ');
    }
  };

  const pushToHistory = (nextBuild) => {
    setHistory(prev => {
      const sliced = prev.slice(0, historyIndex + 1);
      const updated = [...sliced, nextBuild];
      setHistoryIndex(updated.length - 1);
      return updated;
    });
    setBuild(nextBuild);
  };

  const handleUndo = () => {
    if (historyIndex > 0) {
      const nextIndex = historyIndex - 1;
      setHistoryIndex(nextIndex);
      setBuild(history[nextIndex]);
      triggerToast('↩ Hoàn tác (Undo)');
    } else {
      triggerToast('⚠️ Không thể hoàn tác thêm nữa');
    }
  };

  const handleRedo = () => {
    if (historyIndex < history.length - 1) {
      const nextIndex = historyIndex + 1;
      setHistoryIndex(nextIndex);
      setBuild(history[nextIndex]);
      triggerToast('↪ Làm lại (Redo)');
    } else {
      triggerToast('⚠️ Không thể làm lại thêm nữa');
    }
  };

  const handleSelectItem = (category, item) => {
    const isMotherboardComponent = category === 'CPU' || category === 'COOLER' || category === 'RAM' || category === 'GPU';
    if (isMotherboardComponent && !build.MAINBOARD) {
      triggerToast('⚠️ Vui lòng lắp Bo mạch chủ (Mainboard) trước!');
      return;
    }
    const nextBuild = { ...build, [category]: item };
    pushToHistory(nextBuild);
    triggerToast(`✓ Đã lắp ráp: ${item.name}`);
  };

  const handleRemoveCategory = (category) => {
    let nextBuild;
    if (category === 'MAINBOARD') {
      nextBuild = { ...build, MAINBOARD: null, CPU: null, COOLER: null, RAM: null, GPU: null };
      triggerToast('✕ Đã gỡ Bo mạch chủ và các linh kiện cắm trên đó');
    } else {
      nextBuild = { ...build, [category]: null };
      triggerToast(`✕ Đã gỡ bỏ linh kiện của nhóm ${category}`);
    }
    pushToHistory(nextBuild);
  };

  const handleReset = () => {
    const nextBuild = { CASE: null, MAINBOARD: null, CPU: null, COOLER: null, RAM: null, GPU: null, PSU: null, MONITOR: null, KEYBOARD: null, MOUSE: null };
    pushToHistory(nextBuild);
    triggerToast('🔄 Đã làm trống mô hình lắp ráp');
  };

  const getComboComponent = (cat, id, allItems) => {
    let found = allItems[cat]?.find(i => String(i.id) === String(id));
    if (!found && componentsData) {
      const mockItem = COMPONENTS_DATA[cat]?.find(i => String(i.id) === String(id));
      if (mockItem) {
        const normMock = mockItem.name.toLowerCase().replace(/[^a-z0-9]/g, '');
        found = allItems[cat]?.find(i => {
          const normDb = i.name.toLowerCase().replace(/[^a-z0-9]/g, '');
          return normDb.includes(normMock) || normMock.includes(normDb);
        });
      }
    }
    return found;
  };

  const applyCombo = (combo) => {
    const allItems = componentsData || COMPONENTS_DATA;
    const newBuild = { CASE: null, MAINBOARD: null, CPU: null, COOLER: null, RAM: null, GPU: null, PSU: null, MONITOR: null, KEYBOARD: null, MOUSE: null };
    for (const [cat, id] of Object.entries(combo.ids)) {
      const found = getComboComponent(cat, id, allItems);
      if (found) newBuild[cat] = found;
    }
    pushToHistory(newBuild);
    setActiveTab('builder');
    setCameraPreset('side');
    triggerToast(`🎉 Đã áp dụng Combo: ${combo.name}`);
  };

  const handleAddToCart = async () => {
    const installedCount = Object.values(build).filter(Boolean).length;
    if (installedCount === 0) { triggerToast('⚠️ Chưa có linh kiện nào được chọn!'); return; }
    triggerToast('🛒 Đang thêm các cấu hình linh kiện đã dựng vào giỏ hàng...');
    const itemsToAdd = Object.entries(build).filter(([, item]) => item !== null).map(([, item]) => item);
    try {
      for (const item of itemsToAdd) {
        const formData = new URLSearchParams();
        formData.append('id', item.id);
        formData.append('name', item.name);
        formData.append('price', String(item.price));
        formData.append('quantity', '1');
        await fetch(import.meta.env.DEV ? 'http://localhost:8080/cart/add' : '/cart/add', {
          method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: formData, credentials: 'include',
        });
      }
      triggerToast('🛒 Đã thêm thành công tất cả linh kiện vào giỏ hàng!');
      setTimeout(() => { window.location.href = import.meta.env.DEV ? 'http://localhost:8080/cart' : '/cart'; }, 1000);
    } catch (err) {
      triggerToast('❌ Có lỗi xảy ra khi thêm vào giỏ hàng');
    }
  };

  const totalPrice = Object.values(build).reduce((acc, curr) => acc + (curr ? curr.price : 0), 0);
  const comboTotalPrice = (combo) => {
    const allItems = componentsData || COMPONENTS_DATA;
    return Object.entries(combo.ids).reduce((sum, [cat, id]) => {
      const found = getComboComponent(cat, id, allItems);
      return sum + (found ? found.price : 0);
    }, 0);
  };

  const getCompatibilityState = () => {
    let errors = [];
    let warnings = [];
    let compatible = true;

    // 1. Socket Check (Intel vs AMD)
    if (build.CPU && build.MAINBOARD) {
      const cpuName = build.CPU.name.toLowerCase();
      const mainName = build.MAINBOARD.name.toLowerCase();
      const mainSpec = (build.MAINBOARD.spec || '').toLowerCase();
      const isCpuIntel = cpuName.includes('intel') || cpuName.includes('i3') || cpuName.includes('i5') || cpuName.includes('i7') || cpuName.includes('i9');
      const isCpuAmd = cpuName.includes('amd') || cpuName.includes('ryzen');
      const isMainIntel = mainName.includes('z790') || mainName.includes('b760') || mainName.includes('h610') || mainSpec.includes('lga') || mainName.includes('intel');
      const isMainAmd = mainName.includes('x670') || mainName.includes('b650') || mainName.includes('a620') || mainSpec.includes('am5') || mainSpec.includes('am4');
      
      if (isCpuIntel && isMainAmd) {
        errors.push('CPU Intel không tương thích với Bo mạch chủ Socket AMD!');
        compatible = false;
      }
      if (isCpuAmd && isMainIntel) {
        errors.push('CPU AMD không tương thích với Bo mạch chủ Socket Intel!');
        compatible = false;
      }
    }

    // 2. GPU Length clearance in Case
    if (build.CASE && build.GPU) {
      const gpuLength = build.GPU.length || 0;
      const maxGpuLength = build.CASE.maxGpuLength || 999;
      if (gpuLength > maxGpuLength) {
        errors.push(`VGA quá dài (${gpuLength}mm) so với giới hạn vỏ case (${maxGpuLength}mm)!`);
        compatible = false;
      }
    }

    // 3. RAM-Cooler clearance
    if (build.RAM && build.COOLER) {
      const ramHeight = build.RAM.height || 0;
      const coolerClearance = build.COOLER.clearance || 999;
      if (ramHeight > coolerClearance) {
        errors.push(`RAM quá cao (${ramHeight}mm) cấn tản nhiệt khí (${coolerClearance}mm)!`);
        compatible = false;
      }
    }

    // 4. RAM Bus limits
    if (build.MAINBOARD && build.RAM) {
      const ramBus = build.RAM.bus || 0;
      const maxRamBus = build.MAINBOARD.maxRamBus || 9999;
      if (ramBus > maxRamBus) {
        warnings.push(`Bus RAM (${ramBus}MHz) vượt mức Mainboard hỗ trợ tối đa (${maxRamBus}MHz). RAM sẽ tự giảm tốc độ.`);
      }
    }

    // 5. PSU wattage check
    const cpuTdp = build.CPU?.tdp || 0;
    const gpuTdp = build.GPU?.tdp || 0;
    const ramTdp = build.RAM ? (build.RAM.tdp || 5) * 2 : 0; // Dual stick
    const coolerTdp = build.COOLER?.tdp || 0;
    const systemTdp = cpuTdp + gpuTdp + ramTdp + coolerTdp + 80; // 80W basic components
    const recommendedWattage = Math.round(systemTdp * 1.2);

    if (build.PSU) {
      const selectedPsuWattage = build.PSU.wattage || 0;
      if (selectedPsuWattage < recommendedWattage) {
        errors.push(`Nguồn PSU (${selectedPsuWattage}W) nhỏ hơn mức đề xuất tối thiểu (${recommendedWattage}W)!`);
        compatible = false;
      }
    }

    // 6. Reminders (Thermal paste, fans)
    if (build.CPU && build.COOLER) {
      warnings.push('💡 Gợi ý: Đừng quên bôi keo tản nhiệt khi lắp CPU & Tản nhiệt!');
    }
    if (build.CASE) {
      warnings.push('💡 Gợi ý: Vỏ case nên lắp thêm fan tản nhiệt để tối ưu luồng khí!');
    }

    let msg = '';
    if (errors.length > 0) {
      msg = '⚠️ Cảnh báo: ' + errors.join(' | ');
    } else if (warnings.length > 0) {
      msg = warnings.join(' | ');
    } else {
      msg = '✓ Tương thích phần cứng hoàn hảo';
    }

    return {
      compatible,
      errors,
      warnings,
      msg,
      systemTdp,
      recommendedWattage
    };
  };

  const compatibilityInfo = getCompatibilityState();
  const isCompatible = compatibilityInfo.compatible;

  if (loading) {
    return (
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', height: '100vh', background: '#040404', color: '#fff', fontFamily: "'Outfit', sans-serif" }}>
        <div style={{ width: '60px', height: '60px', border: '4px solid rgba(201, 168, 76, 0.1)', borderTop: '4px solid #c9a84c', borderRadius: '50%', animation: 'spin 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite', marginBottom: '1.5rem' }} />
        <h2 style={{ color: '#c9a84c', letterSpacing: '2px', fontSize: '1.5rem', fontWeight: 300 }}>LUXURY 3D BUILDER</h2>
        <p style={{ color: '#888', fontSize: '0.85rem', marginTop: '0.5rem' }}>Đang tải linh kiện từ cơ sở dữ liệu SQL Server...</p>
        <style>{`@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }`}</style>
      </div>
    );
  }

  return (
    <div className={`builder-layout ${isSidebarHidden ? 'sidebar-hidden' : ''} ${!isDarkRoom ? 'light-mode' : ''}`}>
      <div className={`toast-msg ${toast ? 'show' : ''}`}>{toast}</div>

      {/* Sidebar */}
      <div className="builder-sidebar">
        <div className="sidebar-header">
          <a href="/" className="back-home-link">
            <span>←</span> Về trang chủ
          </a>
          <h1>LUXURY <span>3D Builder</span></h1>
          <p>Tự build cấu hình máy tính cá nhân hóa 3D trực quan</p>
        </div>

        {/* Hộp Nhập Mã cấu hình chia sẻ */}
        <div className="sidebar-quick-grid">
        <details className="sidebar-accordion import-share-box">
          <summary><span>Mã chia sẻ</span><strong>Nhập mã</strong></summary>
          <div className="share-code-form">
            <label style={{ fontSize: '0.65rem', textTransform: 'uppercase', color: '#c9a84c', letterSpacing: '0.05em', fontWeight: 600 }}>Tải Cấu hình bằng Mã chia sẻ</label>
            <div style={{ display: 'flex', gap: '0.5rem' }}>
              <input 
                type="text" 
                placeholder="Nhập mã (ví dụ: aB9xYz)" 
                value={inputShareCode} 
                onChange={(e) => setInputShareCode(e.target.value)}
                className="share-code-input"
              />
              <button 
                onClick={handleLoadShareCode}
                className="share-code-btn"
              >
                Áp dụng
              </button>
            </div>
          </div>
        </details>

        {/* Assembly Progress Bar */}
        {(() => {
          const installedCoreCount = CORE_CATEGORIES.filter(cat => build[cat] !== null).length;
          const progressPercent = Math.round((installedCoreCount / CORE_CATEGORIES.length) * 100);
          return (
            <details className="sidebar-accordion assembly-progress-container">
              <summary><span>Tiến độ lắp ráp</span><strong>{installedCoreCount}/7</strong></summary>
              <div className="accordion-body">
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.72rem', color: '#aaa', marginBottom: '0.4rem' }}>
                <span>Tiến độ lắp ráp cốt lõi:</span>
                <span style={{ fontWeight: 600, color: '#c9a84c' }}>{installedCoreCount}/7 ({progressPercent}%)</span>
              </div>
              <div style={{ width: '100%', height: '5px', background: '#222', borderRadius: '3px', overflow: 'hidden' }}>
                <div style={{ width: `${progressPercent}%`, height: '100%', background: 'linear-gradient(90deg, #c9a84c, #e5c158)', transition: 'width 0.4s ease' }} />
              </div>
              <div style={{ display: 'flex', gap: '0.25rem', flexWrap: 'wrap', marginTop: '0.4rem' }}>
                {CORE_CATEGORIES.map(cat => {
                  const isInstalled = build[cat] !== null;
                  return (
                    <span key={cat} style={{
                      fontSize: '0.55rem',
                      padding: '0.1rem 0.3rem',
                      borderRadius: '2px',
                      background: isInstalled ? '#c9a84c22' : '#151515',
                      color: isInstalled ? '#c9a84c' : '#555',
                      border: `1px solid ${isInstalled ? '#c9a84c33' : '#222'}`,
                      transition: 'all 0.3s ease'
                    }}>
                      {isInstalled ? '✓ ' : '○ '}
                      {cat === 'MAINBOARD' ? 'MAIN' : cat}
                    </span>
                  );
                })}
              </div>
              </div>
            </details>
          );
        })()}

        {/* PSU Power Bar & Wattage Calculator */}
        {(() => {
          const cpuTdp = build.CPU?.tdp || 0;
          const gpuTdp = build.GPU?.tdp || 0;
          const ramTdp = build.RAM ? (build.RAM.tdp || 5) * 2 : 0;
          const coolerTdp = build.COOLER?.tdp || 0;
          const systemTdp = cpuTdp + gpuTdp + ramTdp + coolerTdp + 80;
          const recommendedWattage = Math.round(systemTdp * 1.2);
          const selectedPsu = build.PSU;
          const psuWattage = selectedPsu?.wattage || 0;
          
          const loadPercent = psuWattage ? Math.round((systemTdp / psuWattage) * 100) : 0;
          let barColor = '#22c55e'; // Green
          if (loadPercent > 85 || (psuWattage && psuWattage < recommendedWattage)) barColor = '#ef4444'; // Red
          else if (loadPercent > 70) barColor = '#eab308'; // Gold/Yellow

          return (
            <details className="sidebar-accordion psu-power-bar-container">
              <summary><span>Nguồn PSU</span><strong>{recommendedWattage} W</strong></summary>
              <div className="accordion-body">
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.72rem', color: '#aaa', marginBottom: '0.4rem' }}>
                <span>Công suất đỉnh tối đa:</span>
                <span style={{ fontWeight: 600, color: '#fff' }}>{systemTdp} W</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.65rem', color: '#888', marginBottom: '0.4rem' }}>
                <span>Khuyến nghị PSU tối thiểu (+20%):</span>
                <span style={{ fontWeight: 600, color: '#c9a84c' }}>{recommendedWattage} W</span>
              </div>
              {selectedPsu ? (
                <div>
                  <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.68rem', color: '#aaa', marginBottom: '0.2rem' }}>
                    <span>Tải nguồn ({selectedPsu.name.split(' ').slice(-1)[0]}):</span>
                    <span style={{ fontWeight: 600, color: barColor }}>{loadPercent}% ({systemTdp}W / {psuWattage}W)</span>
                  </div>
                  <div style={{ width: '100%', height: '6px', background: '#1a1a24', borderRadius: '3px', overflow: 'hidden', border: '1px solid rgba(255,255,255,0.05)' }}>
                    <div style={{ width: `${Math.min(loadPercent, 100)}%`, height: '100%', background: barColor, transition: 'width 0.4s ease' }} />
                  </div>
                </div>
              ) : (
                <div style={{ fontSize: '0.62rem', color: '#666', fontStyle: 'italic' }}>
                  * Chưa lắp Nguồn PSU.
                </div>
              )}
              </div>
            </details>
          );
        })()}

        </div>

        {/* Main tabs */}
        <div className="main-tabs">
          <button className={`main-tab ${activeTab === 'builder' ? 'active' : ''}`} onClick={() => setActiveTab('builder')}>
            🔧 Tùy chỉnh Build
          </button>
          <button className={`main-tab ${activeTab === 'combo' ? 'active' : ''}`} onClick={() => setActiveTab('combo')}>
            📦 Combo Build
          </button>
        </div>

        {activeTab === 'builder' && (
          <>
            <div className="builder-content-grid">
              <div className="builder-tools-column">
            {/* Categories Tab Swiper */}
            <div className="category-tabs">
              {CATEGORIES.map((cat) => (
                <button key={cat} className={`category-tab ${activeCategory === cat ? 'active' : ''}`} onClick={() => setActiveCategory(cat)}>
                  {cat}
                </button>
              ))}
            </div>

            {/* Search and Brand Filters */}
            {(() => {
              const getBrandsForCategory = (category) => {
                const items = componentsData?.[category] || COMPONENTS_DATA[category] || [];
                const brandsSet = new Set();
                items.forEach(item => {
                  const name = item.name.toLowerCase();
                  if (name.includes('asus') || name.includes('rog')) brandsSet.add('ASUS');
                  else if (name.includes('msi')) brandsSet.add('MSI');
                  else if (name.includes('gigabyte') || name.includes('aorus')) brandsSet.add('Gigabyte');
                  else if (name.includes('corsair')) brandsSet.add('Corsair');
                  else if (name.includes('nzxt')) brandsSet.add('NZXT');
                  else if (name.includes('razer')) brandsSet.add('Razer');
                  else if (name.includes('logitech') || name.includes('g pro')) brandsSet.add('Logitech');
                  else if (name.includes('g.skill')) brandsSet.add('G.Skill');
                  else if (name.includes('kingston') || name.includes('fury')) brandsSet.add('Kingston');
                  else if (name.includes('lian li')) brandsSet.add('Lian Li');
                  else if (name.includes('noctua')) brandsSet.add('Noctua');
                  else if (name.includes('arctic')) brandsSet.add('Arctic');
                  else if (name.includes('hyte')) brandsSet.add('Hyte');
                  else if (name.includes('fractal')) brandsSet.add('Fractal');
                  else if (name.includes('phanteks')) brandsSet.add('Phanteks');
                  else if (name.includes('seasonic')) brandsSet.add('Seasonic');
                  else if (name.includes('coolermaster') || name.includes('cooler master')) brandsSet.add('Cooler Master');
                  else if (name.includes('be quiet')) brandsSet.add('be quiet!');
                  else if (name.includes('sapphire')) brandsSet.add('Sapphire');
                  else if (name.includes('samsung')) brandsSet.add('Samsung');
                });
                return ['Tất cả', ...Array.from(brandsSet)];
              };
              const brands = getBrandsForCategory(activeCategory);
              return (
                <div className="filter-dock" style={{ padding: '0.6rem 1rem', background: '#0a0a0a', borderBottom: '1px solid #1a1a1a', display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                  <div style={{ position: 'relative' }}>
                    <input
                      type="text"
                      placeholder={`Tìm nhanh trong ${activeCategory}...`}
                      value={searchQuery}
                      onChange={(e) => setSearchQuery(e.target.value)}
                      style={{
                        width: '100%',
                        padding: '0.35rem 0.5rem',
                        background: '#111',
                        border: '1px solid #2a2a2a',
                        borderRadius: '3px',
                        color: '#fff',
                        fontSize: '0.75rem',
                        outline: 'none'
                      }}
                    />
                    {searchQuery && (
                      <button
                        onClick={() => setSearchQuery('')}
                        style={{ position: 'absolute', right: '6px', top: '50%', transform: 'translateY(-50%)', background: 'none', border: 'none', color: '#666', cursor: 'pointer', fontSize: '0.75rem' }}
                      >
                        ✕
                      </button>
                    )}
                  </div>
                  {brands.length > 1 && (
                    <div style={{ display: 'flex', gap: '0.25rem', overflowX: 'auto', paddingBottom: '0.1rem', whiteSpace: 'nowrap' }}>
                      {brands.map(brand => {
                        const isActive = selectedBrand === brand || (brand === 'Tất cả' && !selectedBrand);
                        return (
                          <button
                            key={brand}
                            onClick={() => setSelectedBrand(brand === 'Tất cả' ? '' : brand)}
                            style={{
                              padding: '0.15rem 0.45rem',
                              borderRadius: '10px',
                              background: isActive ? '#c9a84c' : '#151515',
                              color: isActive ? '#000' : '#888',
                              border: 'none',
                              fontSize: '0.65rem',
                              cursor: 'pointer',
                              fontWeight: isActive ? 600 : 400
                            }}
                          >
                            {brand}
                          </button>
                        );
                      })}
                    </div>
                  )}
                </div>
              );
            })()}

            {/* Selected Component Status */}
            <div style={{ padding: '0.6rem 1rem 0', background: '#0a0a0a' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.65rem', color: '#888' }}>
                <span>Đang cấu hình: <strong style={{ color: '#c9a84c' }}>{activeCategory}</strong></span>
                {build[activeCategory] && (
                  <button style={{ color: '#ef4444', background: 'none', border: 'none', cursor: 'pointer' }} onClick={() => handleRemoveCategory(activeCategory)}>
                    Gỡ bỏ ✕
                  </button>
                )}
              </div>
            </div>

            {/* Case Color Indicator */}
            {activeCategory === 'CASE' && (
              <div className="case-color-indicator">
                <span>🎨 Màu vỏ case:</span>
                <div className="case-color-swatches">
                  {(componentsData?.CASE || COMPONENTS_DATA.CASE).map(c => (
                    <div
                      key={c.id}
                      className={`color-swatch ${build.CASE?.id === c.id ? 'active' : ''}`}
                      style={{ background: c.outlineColor || c.color }}
                      title={c.name}
                      onClick={() => handleSelectItem('CASE', c)}
                    />
                  ))}
                </div>
              </div>
            )}
              </div>

            {/* Components Selector */}
              <div className="builder-items-column">
            <div className="items-list">
              {(componentsData?.[activeCategory] || [])
                .filter(item => {
                  const matchesSearch = item.name.toLowerCase().includes(searchQuery.toLowerCase()) || (item.spec || '').toLowerCase().includes(searchQuery.toLowerCase());
                  const matchesBrand = !selectedBrand || item.name.toLowerCase().includes(selectedBrand.toLowerCase()) || (selectedBrand === 'be quiet!' && item.name.toLowerCase().includes('be quiet')) || (selectedBrand === 'Cooler Master' && item.name.toLowerCase().includes('coolermaster'));
                  return matchesSearch && matchesBrand;
                })
                .map((item) => {
                  const isSelected = build[activeCategory]?.id === item.id;
                return (
                  <div key={item.id} className={`item-card ${isSelected ? 'selected' : ''}`} onClick={() => handleSelectItem(activeCategory, item)}>
                    <div className="item-icon-box">
                      {item.image ? (
                        <img 
                          src={item.image} 
                          alt={item.name} 
                          style={{
                            width: '100%',
                            height: '100%',
                            objectFit: 'contain',
                            borderRadius: '4px'
                          }} 
                        />
                      ) : (
                        <>
                          {activeCategory === 'CASE' && (
                            <div style={{
                              width: '28px', height: '36px', border: `2px solid ${item.outlineColor || item.color}`,
                              background: item.color, borderRadius: '2px', position: 'relative', boxShadow: `0 0 6px ${item.outlineColor || item.color}44`
                            }}>
                              <div style={{ position: 'absolute', top: '4px', right: '-4px', width: '6px', height: '16px', background: item.outlineColor || item.color, borderRadius: '1px', opacity: 0.5 }} />
                            </div>
                          )}
                          {activeCategory === 'MAINBOARD' && '🎛️'}
                          {activeCategory === 'CPU' && '🔳'}
                          {activeCategory === 'COOLER' && '🌀'}
                          {activeCategory === 'RAM' && '⚡'}
                          {activeCategory === 'GPU' && '🎮'}
                          {activeCategory === 'PSU' && '🔌'}
                          {activeCategory === 'MONITOR' && '📺'}
                          {activeCategory === 'KEYBOARD' && '⌨️'}
                          {activeCategory === 'MOUSE' && '🖱️'}
                        </>
                      )}
                    </div>
                    <div className="item-info">
                      <div className="item-name">{item.name}</div>
                      <div className="item-spec">{item.spec}</div>
                    </div>
                    <div className="item-price-box">
                      <div className="item-price">{item.price.toLocaleString('vi-VN')}₫</div>
                      <button className="item-btn">{isSelected ? 'Đang Lắp ✓' : 'Lắp ráp +'}</button>
                    </div>
                  </div>
                );
              })}
            </div>
              </div>
            </div>
          </>
        )}

        {activeTab === 'combo' && (
          <div className="combo-list">
            {COMBO_BUILDS.map(combo => {
              const total = comboTotalPrice(combo);
              return (
                <div key={combo.id} className="combo-card" onClick={() => applyCombo(combo)}>
                  <div className="combo-card-header">
                    <div>
                      <div className="combo-name">{combo.name}</div>
                      <span className="combo-badge" style={{ background: combo.badgeColor + '22', color: combo.badgeColor, border: `1px solid ${combo.badgeColor}55` }}>{combo.badge}</span>
                    </div>
                    <div className="combo-price">{total.toLocaleString('vi-VN')}₫</div>
                  </div>
                  <div className="combo-desc">{combo.description}</div>
                  <div className="combo-use">🎯 {combo.targetUse}</div>
                  <div className="combo-items-preview">
                    {Object.entries(combo.ids).map(([cat, id]) => {
                      const allItems = componentsData || COMPONENTS_DATA;
                      const found = getComboComponent(cat, id, allItems);
                      return found ? (
                        <span key={cat} className="combo-item-chip">{found.name.split(' ').slice(0, 3).join(' ')}</span>
                      ) : null;
                    })}
                  </div>
                  <button className="combo-apply-btn" onClick={(e) => { e.stopPropagation(); applyCombo(combo); }}>
                    ⚡ Áp dụng Combo này
                  </button>
                </div>
              );
            })}
          </div>
        )}

        {/* Footer actions */}
        <div className="sidebar-footer">
          <div className="build-summary">
            <span className="summary-label">Tổng cấu hình:</span>
            <span className="summary-total">{totalPrice.toLocaleString('vi-VN')}₫</span>
          </div>

          {/* Undo / Redo Buttons */}
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.5rem', marginBottom: '0.5rem' }}>
            <button className="btn-secondary" style={{ padding: '0.5rem', fontSize: '0.68rem', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '0.2rem' }} onClick={handleUndo} disabled={historyIndex === 0}>
              ↩ Hoàn tác (Ctrl+Z)
            </button>
            <button className="btn-secondary" style={{ padding: '0.5rem', fontSize: '0.68rem', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '0.2rem' }} onClick={handleRedo} disabled={historyIndex === history.length - 1}>
              Làm lại ↪ (Ctrl+Y)
            </button>
          </div>

          <div className="action-buttons" style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '0.5rem' }}>
            <button className="btn-secondary" onClick={handleReset}>Reset</button>
            <button className="btn-secondary" style={{ borderColor: '#c9a84c', color: '#c9a84c' }} onClick={handleShareBuild} disabled={sharingLoading}>
              {sharingLoading ? '...' : '🔗 Chia sẻ'}
            </button>
            <button className="btn-primary" onClick={handleAddToCart}>Thêm vào Giỏ</button>
          </div>

          <button className="btn-consultant" onClick={() => setShowConsultant(true)}>
            💼 Gặp nhân viên tư vấn
          </button>

          <button 
            className="btn-secondary" 
            style={{ width: '100%', marginTop: '0.5rem', borderColor: '#c9a84c', color: '#c9a84c', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '0.4rem', fontWeight: 600, fontSize: '0.72rem' }} 
            onClick={() => window.print()}
          >
            🖨️ In báo giá cấu hình
          </button>
        </div>
      </div>

      {/* Main 3D Canvas Area */}
      <div className="canvas-container">
        <button
          className="sidebar-toggle-btn"
          onClick={() => setIsSidebarHidden(prev => !prev)}
          title={isSidebarHidden ? 'Hiện menu cấu hình' : 'Ẩn menu cấu hình'}
        >
          <span>{isSidebarHidden ? '☰' : '‹'}</span>
          <strong>{isSidebarHidden ? 'Menu' : 'Ẩn'}</strong>
        </button>

        {/* HUD control bar */}
        <div className="canvas-hud">
          <div className="hud-group">
            <button className={`hud-btn ${cameraPreset === 'front' ? 'active' : ''}`} onClick={() => setCameraPreset('front')}>Trực diện Case</button>
            <button className={`hud-btn ${cameraPreset === 'side' ? 'active' : ''}`} onClick={() => setCameraPreset('side')}>Góc nhìn 3/4</button>
            <button className={`hud-btn ${cameraPreset === 'mainboard' ? 'active' : ''}`} onClick={() => setCameraPreset('mainboard')}>Cận cảnh Mainboard</button>
          </div>
          <div className="hud-info-box">
            <h3>Chi tiết cấu hình 3D</h3>
            <div className="hud-info-item"><span className="hud-info-label">Vỏ Case:</span><span className="hud-info-val">{build.CASE ? build.CASE.name.split(' ')[0] + ' ' + build.CASE.name.split(' ')[1] : 'Chưa lắp'}</span></div>
            <div className="hud-info-item"><span className="hud-info-label">Bộ xử lý (CPU):</span><span className="hud-info-val">{build.CPU ? build.CPU.name.split(' ').slice(2).join(' ') : 'Chưa lắp'}</span></div>
            <div className="hud-info-item"><span className="hud-info-label">Card Đồ Họa:</span><span className="hud-info-val">{build.GPU ? build.GPU.name.split(' ').slice(1, 3).join(' ') : 'Chưa lắp'}</span></div>
            <div className="hud-info-item"><span className="hud-info-label">Bộ nhớ RAM:</span><span className="hud-info-val">{build.RAM ? build.RAM.spec.split(' | ')[1] || 'Installed' : 'Chưa lắp'}</span></div>
          </div>
        </div>

        {/* Compatibility badge */}
        {Object.values(build).some(Boolean) && (
          <div className={`compatibility-badge ${!isCompatible ? 'warning' : ''}`}>{compatibilityInfo.msg}</div>
        )}

        {/* 3D Canvas - brighter scene */}
        <Canvas shadows camera={{ position: [0, 1.25, 8.2], fov: 44 }}>
          {/* Bright Studio Lights - adapts to isDarkRoom */}
          <ambientLight intensity={isDarkRoom ? 0.05 : 1.0} color="#ffffff" />
          <pointLight position={[10, 10, 10]} intensity={isDarkRoom ? 0.2 : 2.5} color="#ffffff" />
          <pointLight position={[-8, 8, -8]} intensity={isDarkRoom ? 0.1 : 1.2} color="#c9a84c" />
          <pointLight position={[0, -8, 8]} intensity={isDarkRoom ? 0.1 : 1.0} color="#4488ff" />
          <directionalLight position={[5, 10, 5]} intensity={isDarkRoom ? 0.1 : 2} color="#ffffff" castShadow shadow-mapSize={[2048, 2048]} />
          <directionalLight position={[-5, 5, -5]} intensity={isDarkRoom ? 0.05 : 1} color="#ffffff" />
          <hemisphereLight skyColor="#ffffff" groundColor="#888888" intensity={isDarkRoom ? 0.05 : 0.6} />

          {/* Ambient Desk Wall Backlight - glows with RGB color */}
          {isPoweredOn && (
            <pointLight 
              position={[0, 0.5, -3.5]} 
              intensity={isDarkRoom ? 5.0 : 1.8} 
              distance={10} 
              decay={1.2}
              color={getRGBColor(rgbColorMode, Date.now() * 0.001)} 
            />
          )}

          {/* Floor Grid & Shadows */}
          <gridHelper args={[40, 40, '#333333', '#222222']} position={[0, -3.5, 0]} />
          <mesh position={[0, -3.5, 0]} rotation={[-Math.PI / 2, 0, 0]} receiveShadow>
            <planeGeometry args={[40, 40]} />
            <shadowMaterial opacity={0.4} />
          </mesh>

          {/* Detailed Battlestation Desk */}
          <group position={[0, -2.55, 0]}>
            {/* Table top */}
            <mesh receiveShadow>
              <boxGeometry args={[14, 0.1, 8]} />
              <meshStandardMaterial color="#2d1f18" roughness={0.7} metalness={0.1} />
            </mesh>
            {/* 4 table legs */}
            <mesh position={[-6.5, -1.8, -3.5]} castShadow>
              <cylinderGeometry args={[0.08, 0.08, 3.6, 16]} />
              <meshStandardMaterial color="#111111" roughness={0.6} />
            </mesh>
            <mesh position={[6.5, -1.8, -3.5]} castShadow>
              <cylinderGeometry args={[0.08, 0.08, 3.6, 16]} />
              <meshStandardMaterial color="#111111" roughness={0.6} />
            </mesh>
            <mesh position={[-6.5, -1.8, 3.5]} castShadow>
              <cylinderGeometry args={[0.08, 0.08, 3.6, 16]} />
              <meshStandardMaterial color="#111111" roughness={0.6} />
            </mesh>
            <mesh position={[6.5, -1.8, 3.5]} castShadow>
              <cylinderGeometry args={[0.08, 0.08, 3.6, 16]} />
              <meshStandardMaterial color="#111111" roughness={0.6} />
            </mesh>
          </group>

          {/* Shifted PC Case Assembly */}
          <group position={[1.85, 0.55, 0]}>
            {!build.CASE && (
              <group onClick={(e) => { e.stopPropagation(); setActiveCategory('CASE'); }}>
                <mesh castShadow receiveShadow>
                  <boxGeometry args={[2.25, 4.1, 2.15]} />
                  <meshStandardMaterial
                    color="#c9a84c"
                    emissive="#7a5f20"
                    emissiveIntensity={0.12}
                    transparent
                    opacity={0.08}
                    roughness={0.65}
                    metalness={0.25}
                    wireframe
                  />
                </mesh>
                <mesh position={[0, -2.12, 0]} receiveShadow>
                  <boxGeometry args={[2.45, 0.16, 2.35]} />
                  <meshStandardMaterial color="#111111" roughness={0.8} metalness={0.4} />
                </mesh>
                <mesh position={[0, 0, 1.1]}>
                  <boxGeometry args={[1.7, 2.8, 0.02]} />
                  <meshStandardMaterial color="#c9a84c" transparent opacity={0.1} roughness={0.4} />
                </mesh>
              </group>
            )}

            {/* Case */}
            {build.CASE && (
              <group onClick={(e) => { e.stopPropagation(); setActiveCategory('CASE'); }}>
                <CaseChassis caseData={build.CASE} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} explodedFactor={explodedFactor} />
              </group>
            )}

            {/* Motherboard */}
            {build.MAINBOARD && (
              <group onClick={(e) => { e.stopPropagation(); setActiveCategory('MAINBOARD'); }}>
                <Motherboard mainboardData={build.MAINBOARD} />
              </group>
            )}

            {/* CPU */}
            <AnimatedMesh isInstalled={!!build.CPU} targetPos={build.CPU?.pos || [0,0,0]} dimensions={build.CPU?.size || [0.6,0.6,0.1]} color={build.CPU?.color || '#0071c5'} label="CPU" selectedItem={build.CPU} onClick={() => setActiveCategory('CPU')} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} explodedFactor={explodedFactor} />

            {/* Cooler */}
            <AnimatedMesh isInstalled={!!build.COOLER} targetPos={build.COOLER?.pos || [0,0,0]} dimensions={build.COOLER?.size || [0.9,0.9,0.4]} color={build.COOLER?.color || '#333333'} label="COOLER" shape="cylinder" selectedItem={build.COOLER} onClick={() => setActiveCategory('COOLER')} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} explodedFactor={explodedFactor} />

            {/* RAM */}
            <AnimatedMesh isInstalled={!!build.RAM} targetPos={build.RAM?.pos || [0,0,0]} dimensions={build.RAM?.size || [0.1,1.2,0.3]} color={build.RAM?.color || '#c9a84c'} label="RAM" selectedItem={build.RAM} onClick={() => setActiveCategory('RAM')} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} explodedFactor={explodedFactor} />
            {build.RAM && (
              <AnimatedMesh isInstalled={!!build.RAM} targetPos={[build.RAM.pos[0] + 0.2, build.RAM.pos[1], build.RAM.pos[2]]} dimensions={build.RAM.size} color={build.RAM.color} label="RAM" selectedItem={build.RAM} onClick={() => setActiveCategory('RAM')} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} explodedFactor={explodedFactor} />
            )}

            {/* GPU */}
            <AnimatedMesh isInstalled={!!build.GPU} targetPos={build.GPU?.pos || [0,0,0]} dimensions={build.GPU?.size || [0.8,2.5,0.7]} color={build.GPU?.color || '#444444'} label="GPU" selectedItem={build.GPU} onClick={() => setActiveCategory('GPU')} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} explodedFactor={explodedFactor} />

            {/* PSU */}
            <AnimatedMesh isInstalled={!!build.PSU} targetPos={build.PSU?.pos || [0,0,0]} dimensions={build.PSU?.size || [1.8,1.2,1.5]} color={build.PSU?.color || '#111111'} label="PSU" selectedItem={build.PSU} onClick={() => setActiveCategory('PSU')} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} explodedFactor={explodedFactor} />
          </group>

          {/* Desk Accessories (Monitor, Keyboard, Mouse) */}
          <AnimatedMesh isInstalled={!!build.MONITOR} targetPos={[-1.25, 0.78, -0.75]} dimensions={[5.45, 2.82, 0.36]} color={build.MONITOR?.color || '#111111'} label="MONITOR" selectedItem={build.MONITOR} onClick={() => setActiveCategory('MONITOR')} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} explodedFactor={explodedFactor} />

          <AnimatedMesh isInstalled={!!build.KEYBOARD} targetPos={[-1.25, -2.35, 1.35]} dimensions={build.KEYBOARD?.size || [1.4, 0.08, 0.55]} color={build.KEYBOARD?.color || '#1a1a1a'} label="KEYBOARD" selectedItem={build.KEYBOARD} onClick={() => setActiveCategory('KEYBOARD')} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} explodedFactor={explodedFactor} />

          <AnimatedMesh isInstalled={!!build.MOUSE} targetPos={[0.05, -2.35, 1.35]} dimensions={build.MOUSE?.size || [0.22, 0.12, 0.38]} color={build.MOUSE?.color || '#111111'} label="MOUSE" selectedItem={build.MOUSE} onClick={() => setActiveCategory('MOUSE')} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} explodedFactor={explodedFactor} />

          {/* HUD Leader line indicator */}
          {(() => {
            const activeItem = build[activeCategory];
            if (activeItem) {
              const start = getComponentWorldPos(activeCategory, activeItem);
              const isLeft = activeCategory === 'MONITOR' || activeCategory === 'KEYBOARD' || activeCategory === 'MOUSE';
              const end = isLeft
                ? [start[0] - 1.8, start[1] + 1.0, start[2] + 0.4]
                : [start[0] + 1.8, start[1] + 1.0, start[2] + 0.4];
              return (
                <AnnotationCallout 
                  startPos={start} 
                  endPos={end} 
                  label={activeCategory} 
                  item={activeItem} 
                />
              );
            }
            return null;
          })()}

          <CameraController preset={cameraPreset} />
          <OrbitControls autoRotate={isAutoRotating} autoRotateSpeed={1.2} enablePan={false} minDistance={4} maxDistance={15} makeDefault />
        </Canvas>

        {/* Floating Effects Dashboard Console */}
        <div className="canvas-hud-effects">
          {/* Power switch */}
          <div className="hud-control-item">
            <label>Nguồn PC</label>
            <button className={`power-btn ${isPoweredOn ? 'on' : 'off'}`} onClick={() => setIsPoweredOn(!isPoweredOn)}>
              <span className="power-icon">⏻</span> {isPoweredOn ? 'BẬT' : 'TẮT'}
            </button>
          </div>

          {/* Exploded slider */}
          <div className="hud-control-item">
            <label>Tách lớp 3D: <span>{Math.round(explodedFactor * 100)}%</span></label>
            <input 
              type="range" 
              min="0" 
              max="1" 
              step="0.01" 
              value={explodedFactor} 
              onChange={(e) => setExplodedFactor(parseFloat(e.target.value))} 
              className="hud-slider"
            />
          </div>

          {/* Dark room toggle */}
          <div className="hud-control-item">
            <label>Đèn phòng</label>
            <button className={`dark-btn ${isDarkRoom ? 'dark' : 'light'}`} onClick={() => setIsDarkRoom(!isDarkRoom)}>
              {isDarkRoom ? '🌙 Tối' : '☀️ Sáng'}
            </button>
          </div>

          {/* Auto rotate toggle */}
          <div className="hud-control-item">
            <label>Xoay tự động</label>
            <button className={`dark-btn ${isAutoRotating ? 'dark' : 'light'}`} onClick={() => setIsAutoRotating(!isAutoRotating)}>
              {isAutoRotating ? '🔄 BẬT' : '⏸️ TẮT'}
            </button>
          </div>

          {/* RGB color presets */}
          <div className="hud-control-item">
            <label>Màu LED</label>
            <div className="rgb-presets">
              {[
                { mode: 'rainbow', name: '🌈', color: 'linear-gradient(45deg, red, orange, yellow, green, blue, purple)' },
                { mode: 'gold', name: 'Gold', color: '#c9a84c' },
                { mode: 'cyan', name: 'Cyan', color: '#00f0ff' },
                { mode: 'red', name: 'Red', color: '#ff0055' },
                { mode: 'green', name: 'Green', color: '#00ff66' },
                { mode: 'white', name: 'White', color: '#ffffff' }
              ].map((preset) => (
                <button 
                  key={preset.mode}
                  className={`rgb-preset-btn ${rgbColorMode === preset.mode ? 'active' : ''}`}
                  style={{ background: preset.color }}
                  title={preset.mode.toUpperCase()}
                  onClick={() => setRgbColorMode(preset.mode)}
                />
              ))}
            </div>
          </div>
        </div>

        {/* Single unified FAB */}
        <button
          className={`chatbot-fab-inline ${showChatbot ? 'open' : ''}`}
          onClick={() => setShowChatbot(!showChatbot)}
          title="AI Tư vấn + Gặp nhân viên"
        >
          {showChatbot ? '✕' : '🤖'}
          {!showChatbot && <span className="chatbot-fab-label">AI Tư vấn</span>}
        </button>

        {/* Unified Chatbot + Consultant */}
        {showChatbot && (
          <Chatbot
            onClose={() => setShowChatbot(false)}
            build={build}
            totalPrice={totalPrice}
            onApplyCombo={applyCombo}
            activeTicket={activeTicket}
            setActiveTicket={setActiveTicket}
          />
        )}

        {/* Consultant Modal */}
        {showConsultant && (
          <ConsultantModal
            build={build}
            totalPrice={totalPrice}
            onClose={() => setShowConsultant(false)}
            onStartChat={(tid, name) => {
              setActiveTicket({ id: tid, customerName: name });
              setShowConsultant(false);
              setShowChatbot(true);
            }}
          />
        )}

        {/* Share Build Modal */}
        {showShareModal && (() => {
          const shareUrl = `${window.location.origin}/build-pc/index.html?share=${shareCode}`;
          const qrCodeUrl = `https://api.qrserver.com/v1/create-qr-code/?size=160x160&data=${encodeURIComponent(shareUrl)}`;
          return (
            <div className="consultant-overlay" onClick={() => setShowShareModal(false)}>
              <div className="consultant-modal" style={{ maxWidth: '480px', textAlign: 'center', padding: '2rem', display: 'flex', flexDirection: 'column', alignItems: 'center' }} onClick={e => e.stopPropagation()}>
                <div style={{ fontSize: '2.5rem', marginBottom: '0.5rem' }}>🔗</div>
                <h2 style={{ color: '#c9a84c', marginBottom: '0.5rem', fontFamily: 'Outfit, sans-serif' }}>Chia Sẻ Cấu Hình PC 3D</h2>
                <p style={{ color: '#aaa', fontSize: '0.8rem', marginBottom: '1.2rem', lineHeight: '1.4' }}>
                  Chia sẻ cấu hình của bạn qua Mã cấu hình hoặc quét mã QR dưới đây để xem trực tiếp không cần đăng nhập.
                </p>

                {/* QR Code Section */}
                <div style={{ background: '#fff', padding: '0.8rem', borderRadius: '8px', marginBottom: '0.3rem', display: 'inline-flex', boxShadow: '0 0 15px rgba(201, 168, 76, 0.2)' }}>
                  <img src={qrCodeUrl} alt="Mã QR Cấu hình" style={{ width: '160px', height: '160px', display: 'block' }} />
                </div>
                <span style={{ fontSize: '0.68rem', color: '#c9a84c', textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '1.2rem' }}>
                  Quét QR để xem ngay cấu hình này
                </span>

                {/* Share Code Section */}
                <div style={{ width: '100%', marginBottom: '1.2rem' }}>
                  <span style={{ fontSize: '0.65rem', textTransform: 'uppercase', color: '#888', letterSpacing: '0.05em', display: 'block', marginBottom: '0.4rem', textAlign: 'left' }}>
                    Mã cấu hình (Share Code)
                  </span>
                  <div style={{ display: 'flex', gap: '0.5rem', background: '#111', border: '1px solid #c9a84c', padding: '0.5rem', borderRadius: '4px' }}>
                    <div style={{ flex: 1, color: '#fff', fontSize: '1.2rem', fontWeight: 700, fontFamily: 'monospace', letterSpacing: '2px', textAlign: 'center', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                      {shareCode}
                    </div>
                    <button 
                      style={{ background: '#c9a84c', color: '#000', border: 'none', padding: '0.5rem 1rem', borderRadius: '3px', cursor: 'pointer', fontWeight: 700, fontSize: '0.75rem', textTransform: 'uppercase' }}
                      onClick={() => {
                        navigator.clipboard.writeText(shareCode);
                        triggerToast('📋 Đã sao chép mã cấu hình!');
                      }}
                    >
                      Sao chép mã
                    </button>
                  </div>
                </div>

                {/* Link Section */}
                <div style={{ width: '100%', marginBottom: '1.5rem' }}>
                  <span style={{ fontSize: '0.65rem', textTransform: 'uppercase', color: '#888', letterSpacing: '0.05em', display: 'block', marginBottom: '0.4rem', textAlign: 'left' }}>
                    Đường dẫn trực tiếp
                  </span>
                  <div style={{ display: 'flex', gap: '0.5rem', background: '#111', border: '1px solid #333', padding: '0.5rem', borderRadius: '4px' }}>
                    <input 
                      readOnly 
                      style={{ flex: 1, background: 'none', border: 'none', color: '#aaa', fontSize: '0.72rem', paddingLeft: '0.5rem', outline: 'none' }}
                      value={shareUrl} 
                    />
                    <button 
                      style={{ background: 'transparent', color: '#c9a84c', border: '1px solid #c9a84c', padding: '0.5rem 1rem', borderRadius: '3px', cursor: 'pointer', fontWeight: 600, fontSize: '0.75rem', textTransform: 'uppercase', whiteSpace: 'nowrap' }}
                      onClick={() => {
                        navigator.clipboard.writeText(shareUrl);
                        triggerToast('📋 Đã sao chép liên kết!');
                      }}
                    >
                      Sao chép link
                    </button>
                  </div>
                </div>

                <button 
                  className="consultant-submit-btn" 
                  onClick={() => setShowShareModal(false)}
                  style={{ width: '100%', background: '#333', color: '#fff', border: 'none', padding: '0.75rem', borderRadius: '4px', cursor: 'pointer', fontWeight: 600, fontSize: '0.8rem' }}
                >
                  Đóng
                </button>
              </div>
            </div>
          );
        })()}
      </div>

      {/* Print-only Invoice */}
      <div className="print-only-invoice">
        <div className="invoice-header">
          <div className="invoice-logo">
            LUXURY <span>PC</span>
          </div>
          <div className="invoice-title">BẢNG BÁO GIÁ CẤU HÌNH</div>
        </div>
        
        <div className="invoice-meta">
          <div>
            <p><strong>Khách hàng:</strong> Khách hàng quan tâm Luxury PC</p>
            <p><strong>Ngày lập báo giá:</strong> {new Date().toLocaleDateString('vi-VN')} {new Date().toLocaleTimeString('vi-VN')}</p>
          </div>
          <div style={{ textAlign: 'right' }}>
            <p><strong>Hotline:</strong> 1900 8888</p>
            <p><strong>Website:</strong> luxurypc.vn</p>
          </div>
        </div>

        <table className="invoice-table">
          <thead>
            <tr>
              <th style={{ width: '15%' }}>Linh kiện</th>
              <th style={{ width: '50%' }}>Tên sản phẩm</th>
              <th style={{ width: '20%' }}>Thông số kỹ thuật</th>
              <th style={{ width: '15%', textAlign: 'right' }}>Đơn giá</th>
            </tr>
          </thead>
          <tbody>
            {CATEGORIES.map(cat => {
              const item = build[cat];
              if (!item) return null;
              return (
                <tr key={cat}>
                  <td style={{ fontWeight: 600 }}>{cat}</td>
                  <td>{item.name}</td>
                  <td style={{ fontSize: '0.85rem', color: '#555' }}>{item.spec}</td>
                  <td style={{ textAlign: 'right', fontWeight: 600 }}>{item.price.toLocaleString('vi-VN')}₫</td>
                </tr>
              );
            })}
            {Object.values(build).every(item => item === null) && (
              <tr>
                <td colSpan="4" style={{ colSpan: 4, textAlign: 'center', fontStyle: 'italic', padding: '2rem' }}>
                  Chưa lắp linh kiện nào cho cấu hình này.
                </td>
              </tr>
            )}
          </tbody>
        </table>

        <div className="invoice-total">
          <span>Tổng giá trị cấu hình:</span>
          <span>{totalPrice.toLocaleString('vi-VN')}₫</span>
        </div>

        <div className="invoice-footer">
          <div className="signature-box">
            <p><strong>Người lập báo giá</strong></p>
            <p style={{ fontSize: '0.8rem', color: '#777', marginTop: '0.2rem' }}>(Ký và ghi rõ họ tên)</p>
            <div style={{ height: '80px' }}></div>
            <p>Luxury PC Consultant</p>
          </div>
          <div className="signature-box" style={{ textAlign: 'right' }}>
            <p><strong>Khách hàng</strong></p>
            <p style={{ fontSize: '0.8rem', color: '#777', marginTop: '0.2rem' }}>(Ký và ghi rõ họ tên)</p>
            <div style={{ height: '80px' }}></div>
            <p style={{ fontStyle: 'italic', color: '#aaa' }}>Chưa ký</p>
          </div>
        </div>
        
        <div style={{ borderTop: '1px solid #ddd', marginTop: '3rem', paddingTop: '1rem', textAlign: 'center', fontSize: '0.8rem', color: '#777' }}>
          Cảm ơn Quý khách đã tin tưởng dịch vụ lắp ráp PC 3D tại Luxury PC!
        </div>
      </div>
    </div>
  );
}

export default App;
