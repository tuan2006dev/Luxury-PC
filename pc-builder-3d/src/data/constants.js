import * as THREE from 'three';

// --- DATASET: LUXURY COMPONENTS ---
export const COMPONENTS_DATA = {
  CASE: [
    { id: 'case_lianli', name: 'Lian Li O11 Dynamic EVO', price: 4500000, spec: 'Mid Tower | Kính cường lực kép', color: '#2a2a2a', outlineColor: '#c9a84c', size: [4, 5, 4.5], image: 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=200', maxGpuLength: 420, maxCoolerHeight: 167 },
    { id: 'case_corsair_white', name: 'Corsair 5000D Airflow White', price: 3900000, spec: 'Mid Tower | Mặt thép thông thoáng', color: '#e8e8e8', outlineColor: '#aaaaaa', size: [4, 5.2, 4.8], image: 'https://images.unsplash.com/photo-1624705002806-5d72df19c3ad?q=80&w=200', maxGpuLength: 400, maxCoolerHeight: 170 },
    { id: 'case_hyte_red', name: 'Hyte Y70 Touch Red', price: 8900000, spec: 'Dual Chamber | Màn hình LCD 4K', color: '#cc2222', outlineColor: '#ff4444', size: [4.2, 5.4, 4.4], image: 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=200', maxGpuLength: 422, maxCoolerHeight: 180 },
    { id: 'case_fractal_black', name: 'Fractal Torrent Compact', price: 3200000, spec: 'Compact ATX | Mesh mặt trước', color: '#1a1a1a', outlineColor: '#666666', size: [3.8, 4.8, 4.2], image: 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=200', maxGpuLength: 330, maxCoolerHeight: 174 },
    { id: 'case_phanteks_white', name: 'Phanteks Enthoo 719 White', price: 5800000, spec: 'Full Tower | EATX | 9 Fan slots', color: '#f0f0f0', outlineColor: '#c9a84c', size: [4.6, 6, 5], image: 'https://images.unsplash.com/photo-1624705002806-5d72df19c3ad?q=80&w=200', maxGpuLength: 500, maxCoolerHeight: 195 },
    { id: 'case_nzxt_blue', name: 'NZXT H9 Elite Blue', price: 7200000, spec: 'Mid Tower | Full kính 4 mặt', color: '#1a3a6e', outlineColor: '#4488ff', size: [4.1, 5.3, 4.6], image: 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=200', maxGpuLength: 435, maxCoolerHeight: 165 },
    { id: 'case_coolermaster', name: 'Cooler Master HAF 700 EVO', price: 9500000, spec: 'Full Tower | Argb 200mm fans', color: '#222222', outlineColor: '#888888', size: [4.8, 6.2, 5.2], image: 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=200', maxGpuLength: 490, maxCoolerHeight: 166 },
    { id: 'case_be_quiet', name: 'be quiet! Dark Base Pro 901', price: 7800000, spec: 'Full Tower | Silent Wings | Modular', color: '#111111', outlineColor: '#c9a84c', size: [4.5, 5.8, 4.9], image: 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?q=80&w=200', maxGpuLength: 494, maxCoolerHeight: 190 },
  ],
  MAINBOARD: [
    { id: 'main_asus_z790', name: 'ASUS ROG Maximus Z790 Hero', price: 18500000, spec: 'LGA 1700 | DDR5 | PCIe 5.0', color: '#1c1e24', size: [2.5, 3.2, 0.15], image: 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?q=80&w=200', maxRamBus: 7800 },
    { id: 'main_msi_z790', name: 'MSI MEG Z790 ACE Gold', price: 16900000, spec: 'LGA 1700 | DDR5 | E-ATX', color: '#2a2415', size: [2.8, 3.2, 0.15], image: 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?q=80&w=200', maxRamBus: 7800 },
    { id: 'main_gigabyte_x670', name: 'Gigabyte X670E AORUS Master', price: 15500000, spec: 'AM5 | DDR5 | PCIe 5.0 | WiFi 6E', color: '#0a1428', size: [2.6, 3.2, 0.15], image: 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?q=80&w=200', maxRamBus: 6600 },
    { id: 'main_asus_x670', name: 'ASUS ROG Crosshair X670E Hero', price: 17800000, spec: 'AM5 | DDR5 | PCIe 5.0', color: '#1c1e24', size: [2.5, 3.2, 0.15], image: 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?q=80&w=200', maxRamBus: 6400 },
    { id: 'main_msi_b650', name: 'MSI MAG B650 Tomahawk WiFi', price: 6500000, spec: 'AM5 | DDR5 | Budget Gaming', color: '#181818', size: [2.4, 3.0, 0.15], image: 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?q=80&w=200', maxRamBus: 6600 },
    { id: 'main_asrock_b760', name: 'ASRock B760M Steel Legend', price: 4200000, spec: 'LGA 1700 | DDR5 | mATX Budget', color: '#1e242a', size: [2.2, 2.8, 0.15], image: 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?q=80&w=200', maxRamBus: 7200 },
  ],
  CPU: [
    { id: 'cpu_i9_14900k', name: 'Intel Core i9-14900K', price: 14500000, spec: '24 Cores | 32 Threads | Up to 6.0GHz', color: '#0071c5', size: [0.6, 0.6, 0.1], pos: [-0.2, 0.5, 0.1], image: 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=200', tdp: 253 },
    { id: 'cpu_r9_7950x3d', name: 'AMD Ryzen 9 7950X3D', price: 15200000, spec: '16 Cores | 32 Threads | 3D V-Cache', color: '#f35c00', size: [0.6, 0.6, 0.1], pos: [-0.2, 0.5, 0.1], image: 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=200', tdp: 120 },
    { id: 'cpu_i7_14700k', name: 'Intel Core i7-14700K', price: 10200000, spec: '20 Cores | 28 Threads | Up to 5.6GHz', color: '#0071c5', size: [0.6, 0.6, 0.1], pos: [-0.2, 0.5, 0.1], image: 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=200', tdp: 253 },
    { id: 'cpu_r7_7800x3d', name: 'AMD Ryzen 7 7800X3D', price: 10800000, spec: '8 Cores | 16 Threads | 3D V-Cache Gaming', color: '#f35c00', size: [0.6, 0.6, 0.1], pos: [-0.2, 0.5, 0.1], image: 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=200', tdp: 120 },
    { id: 'cpu_i5_14600k', name: 'Intel Core i5-14600K', price: 7200000, spec: '14 Cores | 20 Threads | Up to 5.3GHz', color: '#0071c5', size: [0.6, 0.6, 0.1], pos: [-0.2, 0.5, 0.1], image: 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=200', tdp: 181 },
    { id: 'cpu_r5_7600x', name: 'AMD Ryzen 5 7600X', price: 5400000, spec: '6 Cores | 12 Threads | 5.3GHz | AM5', color: '#f35c00', size: [0.6, 0.6, 0.1], pos: [-0.2, 0.5, 0.1], image: 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=200', tdp: 105 },
  ],
  COOLER: [
    { id: 'cooler_nzxt_360', name: 'NZXT Kraken Elite 360 RGB', price: 7800000, spec: 'AIO Liquid 360mm | Màn hình LCD 2.36"', color: '#333333', size: [0.9, 0.9, 0.4], pos: [-0.2, 0.5, 0.45], image: 'https://images.unsplash.com/photo-1616348436168-de43ad0db179?q=80&w=200', clearance: 60, tdp: 15 },
    { id: 'cooler_corsair_h150i', name: 'Corsair iCUE H150i Elite LCD', price: 8200000, spec: 'AIO Liquid 360mm | Quạt AF120 RGB', color: '#151515', size: [0.95, 0.95, 0.35], pos: [-0.2, 0.5, 0.42], image: 'https://images.unsplash.com/photo-1616348436168-de43ad0db179?q=80&w=200', clearance: 60, tdp: 15 },
    { id: 'cooler_arctic_360', name: 'Arctic Liquid Freezer II 360', price: 3200000, spec: 'AIO Liquid 360mm | VRM Fan | Giá tốt', color: '#444444', size: [0.9, 0.9, 0.38], pos: [-0.2, 0.5, 0.44], image: 'https://images.unsplash.com/photo-1616348436168-de43ad0db179?q=80&w=200', clearance: 60, tdp: 15 },
    { id: 'cooler_noctua_nh', name: 'Noctua NH-D15 Chromax Black', price: 2800000, spec: 'Air Cooler Dual Tower | 2x NF-A15 fans', color: '#2a2a2a', size: [0.85, 0.85, 0.5], pos: [-0.2, 0.5, 0.48], image: 'https://images.unsplash.com/photo-1616348436168-de43ad0db179?q=80&w=200', clearance: 37, tdp: 10 },
  ],
  RAM: [
    { id: 'ram_gskill_32gb', name: 'G.Skill Trident Z5 RGB 32GB', price: 3800000, spec: 'DDR5 6400MHz | 2x16GB', color: '#c9a84c', size: [0.1, 1.2, 0.3], pos: [0.4, 0.5, 0.2], image: 'https://images.unsplash.com/photo-1562976540-1502c2145186?q=80&w=200', height: 44, bus: 6400, tdp: 5 },
    { id: 'ram_corsair_64gb', name: 'Corsair Dominator Titanium 64GB', price: 7900000, spec: 'DDR5 7200MHz | 2x32GB', color: '#ffffff', size: [0.12, 1.2, 0.35], pos: [0.4, 0.5, 0.2], image: 'https://images.unsplash.com/photo-1562976540-1502c2145186?q=80&w=200', height: 56, bus: 7200, tdp: 8 },
    { id: 'ram_kingston_32gb', name: 'Kingston Fury Beast 32GB', price: 2200000, spec: 'DDR5 5200MHz | 2x16GB | Budget', color: '#333333', size: [0.1, 1.1, 0.28], pos: [0.4, 0.5, 0.2], image: 'https://images.unsplash.com/photo-1562976540-1502c2145186?q=80&w=200', height: 35, bus: 5200, tdp: 5 },
    { id: 'ram_teamgroup_32gb', name: 'TeamGroup T-Force Delta RGB 32GB', price: 2900000, spec: 'DDR5 6000MHz | 2x16GB | Full RGB', color: '#ff3300', size: [0.1, 1.2, 0.3], pos: [0.4, 0.5, 0.2], image: 'https://images.unsplash.com/photo-1562976540-1502c2145186?q=80&w=200', height: 46, bus: 6000, tdp: 6 },
  ],
  GPU: [
    { id: 'gpu_4090', name: 'NVIDIA RTX 4090 Founders Edition', price: 54900000, spec: '24GB GDDR6X | DLSS 3.0 | 4K Ultra', color: '#444444', size: [0.8, 2.5, 0.7], pos: [0.1, -0.6, 0.6], image: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?q=80&w=200', tdp: 450, length: 304 },
    { id: 'gpu_4080s', name: 'ASUS ROG Strix RTX 4080 Super', price: 36500000, spec: '16GB GDDR6X | RGB Sync | OC', color: '#0c0d12', size: [0.9, 2.8, 0.8], pos: [0.1, -0.6, 0.6], image: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?q=80&w=200', tdp: 320, length: 357 },
    { id: 'gpu_7900xtx', name: 'AMD Radeon RX 7900 XTX', price: 28500000, spec: '24GB GDDR6 | 4K AMD Gaming King', color: '#880000', size: [0.85, 2.6, 0.75], pos: [0.1, -0.6, 0.6], image: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?q=80&w=200', tdp: 355, length: 287 },
    { id: 'gpu_4070ti', name: 'MSI RTX 4070 Ti Super Gaming X Slim', price: 22500000, spec: '16GB GDDR6X | 1440p Esports | DLSS 3', color: '#222222', size: [0.75, 2.4, 0.65], pos: [0.1, -0.6, 0.6], image: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?q=80&w=200', tdp: 220, length: 307 },
    { id: 'gpu_7800xt', name: 'Sapphire Pulse RX 7800 XT', price: 14500000, spec: '16GB GDDR6 | 1440p Performance', color: '#990000', size: [0.8, 2.3, 0.6], pos: [0.1, -0.6, 0.6], image: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?q=80&w=200', tdp: 263, length: 280 },
    { id: 'gpu_4060ti', name: 'Gigabyte RTX 4060 Ti Windforce OC', price: 12800000, spec: '8GB GDDR6 | 1080p Ultra Max FPS', color: '#333344', size: [0.7, 2.2, 0.6], pos: [0.1, -0.6, 0.6], image: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?q=80&w=200', tdp: 160, length: 272 },
  ],
  PSU: [
    { id: 'psu_seasonic_1300', name: 'Seasonic Prime TX-1300W', price: 9500000, spec: '1300W | 80 Plus Titanium', color: '#111111', size: [1.8, 1.2, 1.5], pos: [0, -2.1, -1.2], image: 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=200', wattage: 1300 },
    { id: 'psu_rog_1200', name: 'ASUS ROG Thor 1200W Platinum II', price: 8900000, spec: '1200W | Màn hình OLED | 80+ Platinum', color: '#222222', size: [1.8, 1.2, 1.5], pos: [0, -2.1, -1.2], image: 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=200', wattage: 1200 },
    { id: 'psu_corsair_1000', name: 'Corsair HX1000i ATX 3.0', price: 6200000, spec: '1000W | 80+ Platinum | Fully Modular', color: '#1a1a1a', size: [1.8, 1.2, 1.5], pos: [0, -2.1, -1.2], image: 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=200', wattage: 1000 },
    { id: 'psu_evga_850', name: 'EVGA SuperNOVA 850 G7', price: 3800000, spec: '850W | 80+ Gold | Semi Modular', color: '#111111', size: [1.8, 1.2, 1.5], pos: [0, -2.1, -1.2], image: 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=200', wattage: 850 },
    { id: 'psu_msi_750', name: 'MSI MAG A750GL PCIE 5', price: 2200000, spec: '750W | 80+ Gold | Budget Build', color: '#181818', size: [1.7, 1.1, 1.4], pos: [0, -2.1, -1.2], image: 'https://images.unsplash.com/photo-1591488320449-011701bb6704?q=80&w=200', wattage: 750 },
  ],
  MONITOR: [
    { id: 'mon_asus_rog_49', name: 'ASUS ROG Swift OLED PG49WCD', price: 38900000, spec: '49" Curved | DQHD 144Hz | 0.03ms OLED', color: '#111111', size: [6.2, 3.2, 0.4], pos: [-2.0, 0.6, -0.4], image: 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=200' },
    { id: 'mon_samsung_g9', name: 'Samsung Odyssey Neo G9', price: 42500000, spec: '49" Mini-LED | Dual QHD 240Hz | Curved', color: '#f0f0f0', size: [6.2, 3.2, 0.5], pos: [-2.0, 0.6, -0.4], image: 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=200' },
  ],
  KEYBOARD: [
    { id: 'kb_corsair_k100', name: 'Corsair K100 RGB Optical-Mechanical', price: 6200000, spec: 'Fullsize | OPX switches | PBT Keycaps', color: '#1a1a1a', size: [1.4, 0.08, 0.55], pos: [-2.0, -2.75, 1.8], image: 'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?q=80&w=200' },
    { id: 'kb_asus_azoth', name: 'ASUS ROG Azoth OLED Wireless', price: 5900000, spec: '75% Gasket mount | Hot-swappable | OLED', color: '#2e2e2e', size: [1.4, 0.08, 0.55], pos: [-2.0, -2.75, 1.8], image: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?q=80&w=200' },
  ],
  MOUSE: [
    { id: 'mouse_gpro_superlight', name: 'Logitech G Pro X Superlight 2', price: 3800000, spec: 'Wireless | 60g Lightweight | Hero 2 Sensor', color: '#111111', size: [0.22, 0.12, 0.38], pos: [-0.6, -2.75, 1.8], image: 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?q=80&w=200' },
    { id: 'mouse_razer_basilisk', name: 'Razer Basilisk V3 Pro White', price: 4200000, spec: 'Wireless | Focus Pro 30K | Chroma RGB', color: '#e8e8e8', size: [0.24, 0.14, 0.4], pos: [-0.6, -2.75, 1.8], image: 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?q=80&w=200' },
  ]
};

// Helper to get RGB color based on mode and time
export const getRGBColor = (rgbColorMode, time, offset = 0) => {
  if (rgbColorMode === 'gold') return new THREE.Color('#c9a84c');
  if (rgbColorMode === 'cyan') return new THREE.Color('#00f0ff');
  if (rgbColorMode === 'red') return new THREE.Color('#ff0055');
  if (rgbColorMode === 'green') return new THREE.Color('#00ff66');
  if (rgbColorMode === 'white') return new THREE.Color('#ffffff');
  // rainbow mode (default)
  const hue = (time * 0.2 + offset) % 1.0;
  return new THREE.Color().setHSL(hue, 1, 0.5);
};

// Combo build packages - organized from Basic to Advanced
export const COMBO_BUILDS = [
  {
    id: 'combo_entry',
    name: '🎮 Chiến Game Entry',
    badge: 'Cơ bản',
    badgeColor: '#22c55e',
    description: 'Cấu hình tối ưu chi phí cho game 1080p, văn phòng chuyên nghiệp',
    targetUse: 'Game 1080p, Office Pro, Live Stream nhẹ',
    ids: {
      CASE: 'case_fractal_black',
      MAINBOARD: 'main_asrock_b760',
      CPU: 'cpu_i5_14600k',
      COOLER: 'cooler_noctua_nh',
      RAM: 'ram_kingston_32gb',
      GPU: 'gpu_4060ti',
      PSU: 'psu_msi_750'
    }
  },
  {
    id: 'combo_midrange',
    name: '⚡ Mid-Range Monster',
    badge: 'Trung cấp',
    badgeColor: '#3b82f6',
    description: 'Cân bằng hoàn hảo giữa giá thành và hiệu năng chơi game 2K',
    targetUse: 'Game 2K Ultra, Thiết kế đồ họa, Render 3D',
    ids: {
      CASE: 'case_lianli',
      MAINBOARD: 'main_msi_b650',
      CPU: 'cpu_r7_7800x3d',
      COOLER: 'cooler_arctic_360',
      RAM: 'ram_gskill_32gb',
      GPU: 'gpu_4070ti',
      PSU: 'psu_evga_850'
    }
  },
  {
    id: 'combo_amd_beast',
    name: '🔥 AMD Beast Workstation',
    badge: 'Cận cao cấp',
    badgeColor: '#f97316',
    description: 'Chiến binh thuần AMD mạnh mẽ, xử lý tác vụ đồ họa và game 4K',
    targetUse: 'Game 4K, 3D Render, AI Workload',
    ids: {
      CASE: 'case_be_quiet',
      MAINBOARD: 'main_gigabyte_x670',
      CPU: 'cpu_r9_7950x3d',
      COOLER: 'cooler_corsair_h150i',
      RAM: 'ram_corsair_64gb',
      GPU: 'gpu_7900xtx',
      PSU: 'psu_rog_1200'
    }
  },
  {
    id: 'combo_gaming_king',
    name: '👑 Gaming King Extreme',
    badge: 'Cao cấp',
    badgeColor: '#eab308',
    description: 'Cấu hình đẳng cấp cho game thủ chuyên nghiệp và Streamer 4K',
    targetUse: 'Game 4K Max Settings, Content Creator Pro',
    ids: {
      CASE: 'case_nzxt_blue',
      MAINBOARD: 'main_asus_x670',
      CPU: 'cpu_r9_7950x3d',
      COOLER: 'cooler_nzxt_360',
      RAM: 'ram_corsair_64gb',
      GPU: 'gpu_4080s',
      PSU: 'psu_corsair_1000'
    }
  },
  {
    id: 'combo_ultra',
    name: '🚀 No Compromise Ultimate',
    badge: 'Siêu cấp',
    badgeColor: '#ef4444',
    description: 'Cỗ máy tối thượng, trang bị linh kiện xa xỉ và hiệu năng đỉnh chóp',
    targetUse: '4K 240fps, AI Rendering, Flagship Experience',
    ids: {
      CASE: 'case_phanteks_white',
      MAINBOARD: 'main_asus_z790',
      CPU: 'cpu_i9_14900k',
      COOLER: 'cooler_corsair_h150i',
      RAM: 'ram_corsair_64gb',
      GPU: 'gpu_4090',
      PSU: 'psu_seasonic_1300'
    }
  }
];

export const CATEGORIES = ['CASE', 'MAINBOARD', 'CPU', 'COOLER', 'RAM', 'GPU', 'PSU', 'MONITOR', 'KEYBOARD', 'MOUSE'];
