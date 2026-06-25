function registerCursorEvents() {}

  // TOAST
  let toastT;
  function toast(m){const el=document.getElementById('toast');el.textContent=m;el.classList.add('show');clearTimeout(toastT);toastT=setTimeout(()=>el.classList.remove('show'),3000);}
  function showToast(m){toast(m);}

  // MOCK DATABASE
  const MOCK_DB = {
    cpu: {
      title: "Bộ Xử Lý (CPU)",
      icon: "⚙️",
      items: [
        { id: "cpu-i9", name: "Intel Core i9-14900K", price: 18990000, tdp: 125, socket: "LGA1700", coolerType: "liquid", desc: "24 Cores · 32 Threads · 6.0 GHz · Socket LGA1700" },
        { id: "cpu-i7", name: "Intel Core i7-14700K", price: 11475000, tdp: 125, socket: "LGA1700", coolerType: "air", desc: "20 Cores · 28 Threads · 5.6 GHz · Socket LGA1700" },
        { id: "cpu-r9", name: "AMD Ryzen 9 7950X", price: 16500000, tdp: 170, socket: "AM5", coolerType: "liquid", desc: "16 Cores · 32 Threads · 5.7 GHz · Socket AM5" }
      ]
    },
    mb: {
      title: "Bo Mạch Chủ (Mainboard)",
      icon: "🔌",
      items: [
        { id: "mb-apex", name: "ASUS ROG Maximus Z790 Apex", price: 12490000, tdp: 50, socket: "LGA1700", color: 0x111116, desc: "LGA1700 · DDR5 · PCIe 5.0 · WiFi 6E" },
        { id: "mb-ace", name: "MSI MEG Z790 ACE", price: 9800000, tdp: 50, socket: "LGA1700", color: 0x1c1a24, desc: "LGA1700 · DDR5 · PCIe 5.0 · WiFi 6E" },
        { id: "mb-master", name: "Gigabyte Z790 AORUS Master", price: 8200000, tdp: 45, socket: "LGA1700", color: 0x152215, desc: "LGA1700 · DDR5 · PCIe 4.0 · WiFi 6" }
      ]
    },
    gpu: {
      title: "Card Đồ Họa (GPU)",
      icon: "🎮",
      items: [
        { id: "gpu-4090", name: "RTX 4090 Titan Edition", price: 42990000, tdp: 450, length: 3.2, thickness: 1.2, desc: "24GB GDDR6X · 16384 CUDA · Cần 850W PSU" },
        { id: "gpu-4080s", name: "NVIDIA RTX 4080 Super", price: 24500000, tdp: 320, length: 2.8, thickness: 0.9, desc: "16GB GDDR6X · 10240 CUDA · Cần 750W PSU" },
        { id: "gpu-7900xtx", name: "AMD Radeon RX 7900 XTX", price: 18900000, tdp: 355, length: 2.9, thickness: 1.0, desc: "24GB GDDR6 · 6144 SP · Cần 800W PSU" }
      ]
    },
    ram: {
      title: "Bộ Nhớ RAM",
      icon: "💾",
      items: [
        { id: "ram-corsair", name: "Corsair Dominator Platinum DDR5", price: 6490000, tdp: 15, sticks: 2, desc: "32GB (2×16) · DDR5-6000 · CL36" },
        { id: "ram-gskill", name: "G.Skill Trident Z5 RGB 64GB", price: 9800000, tdp: 20, sticks: 4, desc: "64GB (2×32) · DDR5-6400 · CL32" }
      ]
    },
    ssd: {
      title: "Ổ Cứng SSD",
      icon: "💿",
      items: [
        { id: "ssd-990", name: "Samsung 990 Pro 2TB", price: 3360000, tdp: 8, desc: "NVMe PCIe 4.0 · 7,450 MB/s read · M.2" },
        { id: "ssd-sn850x", name: "WD Black SN850X 1TB", price: 2100000, tdp: 7, desc: "NVMe PCIe 4.0 · 7,300 MB/s read · M.2" }
      ]
    },
    psu: {
      title: "Nguồn Điện (PSU)",
      icon: "⚡",
      items: [
        { id: "psu-focus", name: "Seasonic Focus GX-1000W", price: 3850000, wattage: 1000, desc: "1000W · 80+ Gold · Full Modular" },
        { id: "psu-hx1200", name: "Corsair HX1200 Platinum", price: 5200000, wattage: 1200, desc: "1200W · 80+ Platinum · Full Modular" }
      ]
    },
    cool: {
      title: "Tản Nhiệt CPU",
      icon: "🌬️",
      items: [
        { id: "cool-noctua", name: "Noctua NH-D15 Chromax Black", price: 1890000, tdp: 0, coolerType: "air", desc: "Air Cooler · 165W TDP · Dual Fan" },
        { id: "cool-ryujin", name: "ASUS ROG Ryujin III 360", price: 4200000, tdp: 15, coolerType: "liquid", desc: "AIO 360mm · LCD Screen · ARGB" }
      ]
    }
  };

  // MOCK PACKAGES
  const MOCK_PACKAGES = [
    {
      id: "pkg-gaming-beast",
      name: "Gaming Beast Preset",
      price: 89990000,
      desc: "Tối ưu cho gaming 4K/144Hz. Bộ đôi RTX 4090 + i9-14900K không đối thủ.",
      rgbMode: "CYBERPUNK",
      parts: {
        cpu: "cpu-i9",
        mb: "mb-apex",
        gpu: "gpu-4090",
        ram: "ram-corsair",
        ssd: "ssd-990",
        psu: "psu-hx1200",
        cool: "cool-ryujin"
      }
    },
    {
      id: "pkg-creator-pro",
      name: "Creator Pro Preset",
      price: 92990000,
      desc: "Chuyên dụng cho đồ họa 3D render 8K, kiến trúc AI Workstation chuyên nghiệp.",
      rgbMode: "RAINBOW",
      parts: {
        cpu: "cpu-i9",
        mb: "mb-apex",
        gpu: "gpu-4090",
        ram: "ram-gskill",
        ssd: "ssd-990",
        psu: "psu-hx1200",
        cool: "cool-ryujin"
      }
    },
    {
      id: "pkg-performance",
      name: "Performance Preset",
      price: 55990000,
      desc: "Tối ưu chi phí và hiệu năng. Chiến mượt game 2K và xử lý đa nhiệm mượt mà.",
      rgbMode: "GOLDEN",
      parts: {
        cpu: "cpu-i7",
        mb: "mb-master",
        gpu: "gpu-4080s",
        ram: "ram-corsair",
        ssd: "ssd-sn850x",
        psu: "psu-focus",
        cool: "cool-noctua"
      }
    }
  ];

  // Current State
  let buildState = { cpu: null, mb: null, gpu: null, ram: null, ssd: null, psu: null, cool: null };
  let powerOn = true;
  let rgbModes = ["RAINBOW", "CYBERPUNK", "GOLDEN", "OFF"];
  let rgbModeIndex = 0;
  let activeTab = 'custom';
  let currentSelectedPackageId = null;
  let threeJsReady = false;

  // THREE.JS variables
  let scene, camera, renderer, controls;
  let caseMesh, motherboardMesh, gpuMesh, ramMeshes = [], liquidCoolerMesh, airCoolerMesh, fanMeshes = [], rgbLights = [];
  let rgbColorTimer = 0;

  // 2. INITIATE THREE.JS 3D SCENE
  function init3D() {
    const container = document.getElementById('three-canvas-container');
    if (!container) return;

    if (typeof THREE === 'undefined') {
      container.innerHTML = `
        <div style="position: absolute; inset: 0; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 2rem; text-align: center; background: #0a0a0f; border: 1px solid rgba(201, 168, 76, 0.15); border-radius: 8px; color: var(--cream); z-index: 10;">
          <div style="font-size: 2.5rem; margin-bottom: 1rem;">🌐</div>
          <h4 style="font-family: var(--sans); font-size: 1.1rem; color: var(--gold); margin-bottom: 0.5rem;">Không tải được thư viện 3D</h4>
          <p style="font-size: 0.75rem; color: var(--muted); max-width: 320px; line-height: 1.4;">Vui lòng kết nối mạng Internet hoặc kiểm tra xem trình duyệt có chặn các liên kết từ thư viện CDN (Three.js) hay không.</p>
        </div>
      `;
      return;
    }

    try {
      const width = container.clientWidth;
      const height = container.clientHeight || 500;

      scene = new THREE.Scene();
      scene.background = new THREE.Color(0x030305);
      scene.fog = new THREE.FogExp2(0x030305, 0.05);

      camera = new THREE.PerspectiveCamera(40, width / height, 0.1, 100);
      camera.position.set(4, 3, 5);

      renderer = new THREE.WebGLRenderer({ antialias: true });
      renderer.setSize(width, height);
      renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
      renderer.shadowMap.enabled = true;
      renderer.shadowMap.type = THREE.PCFSoftShadowMap;
      container.appendChild(renderer.domElement);

      controls = new THREE.OrbitControls(camera, renderer.domElement);
      controls.enableDamping = true;
      controls.dampingFactor = 0.05;
      controls.maxPolarAngle = Math.PI / 2 + 0.1;
      controls.minDistance = 2.5;
      controls.maxDistance = 10;

      // Lights
      const ambientLight = new THREE.AmbientLight(0xffffff, 0.4);
      scene.add(ambientLight);

      const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
      directionalLight.position.set(5, 10, 7);
      directionalLight.castShadow = true;
      directionalLight.shadow.mapSize.width = 1024;
      directionalLight.shadow.mapSize.height = 1024;
      scene.add(directionalLight);

      const caseSpotLight = new THREE.SpotLight(0xffffff, 1.5, 8, Math.PI/3, 0.5, 1);
      caseSpotLight.position.set(0, 1.5, 0);
      scene.add(caseSpotLight);

      // Create base procedural parts
      buildProceduralCase();
      buildProceduralMotherboard();
      buildProceduralRAM();
      buildProceduralCoolers();
      buildProceduralGPU();

      window.addEventListener('resize', onWindowResize);

      threeJsReady = true;
    } catch (err) {
      console.error("Three.js WebGL Init Error:", err);
      container.innerHTML = `
        <div style="position: absolute; inset: 0; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 2rem; text-align: center; background: #0a0a0f; border: 1px solid rgba(201, 168, 76, 0.15); border-radius: 8px; color: var(--cream); z-index: 10;">
          <div style="font-size: 2.5rem; margin-bottom: 1rem;">⚠️</div>
          <h4 style="font-family: var(--sans); font-size: 1.1rem; color: var(--gold); margin-bottom: 0.5rem;">Trình duyệt không hỗ trợ WebGL 3D</h4>
          <p style="font-size: 0.75rem; color: var(--muted); max-width: 320px; line-height: 1.4;">WebGL bị vô hiệu hóa hoặc không khả dụng trên thiết bị này. Vui lòng bật gia tốc phần cứng trong cài đặt trình duyệt hoặc đổi sang trình duyệt khác.</p>
        </div>
      `;
    }
  }

  function onWindowResize() {
    const container = document.getElementById('three-canvas-container');
    const width = container.clientWidth;
    const height = container.clientHeight;
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
    renderer.setSize(width, height);
  }

  // 3. BUILD PROCEDURAL 3D MESHES
  function buildProceduralCase() {
    // PSU Shroud / Case bottom base
    const shroudGeo = new THREE.BoxGeometry(3.2, 0.5, 1.6);
    const shroudMat = new THREE.MeshStandardMaterial({ color: 0x111116, roughness: 0.7, metalness: 0.8 });
    const shroud = new THREE.Mesh(shroudGeo, shroudMat);
    shroud.position.y = -0.75;
    scene.add(shroud);

    // Backplate plate
    const backGeo = new THREE.BoxGeometry(0.1, 1.8, 1.6);
    const backMat = new THREE.MeshStandardMaterial({ color: 0x0c0c10, roughness: 0.8, metalness: 0.8 });
    const back = new THREE.Mesh(backGeo, backMat);
    back.position.set(-1.55, 0.4, 0);
    scene.add(back);

    // Front fans panels (Case front)
    const frontFrameGeo = new THREE.BoxGeometry(0.2, 1.8, 0.1);
    const frontFrame = new THREE.Mesh(frontFrameGeo, backMat);
    frontFrame.position.set(1.55, 0.4, 0.75);
    scene.add(frontFrame);

    // Glass side panel
    const glassGeo = new THREE.BoxGeometry(3.1, 1.8, 0.05);
    const glassMat = new THREE.MeshPhysicalMaterial({
      color: 0x7dd3fc,
      transparent: true,
      opacity: 0.18,
      roughness: 0.05,
      transmission: 0.9,
      ior: 1.5,
      thickness: 0.2
    });
    const glass = new THREE.Mesh(glassGeo, glassMat);
    glass.position.set(0, 0.4, 0.8);
    scene.add(glass);

    buildCaseFans();
  }

  function buildCaseFans() {
    const positions = [
      new THREE.Vector3(1.5, 0.9, 0),
      new THREE.Vector3(1.5, 0.3, 0),
      new THREE.Vector3(1.5, -0.3, 0),
      new THREE.Vector3(-1.4, 0.6, 0)
    ];

    positions.forEach((pos, idx) => {
      const fanGroup = new THREE.Group();
      fanGroup.position.copy(pos);
      if (idx < 3) {
        fanGroup.rotation.y = Math.PI / 2;
      }

      const frameGeo = new THREE.BoxGeometry(0.1, 0.5, 0.5);
      const frameMat = new THREE.MeshStandardMaterial({ color: 0x111116, roughness: 0.9 });
      const frame = new THREE.Mesh(frameGeo, frameMat);
      fanGroup.add(frame);

      const bladesGroup = new THREE.Group();
      bladesGroup.name = "blades";
      
      const hubGeo = new THREE.CylinderGeometry(0.08, 0.08, 0.06, 8);
      const rgbMat = new THREE.MeshStandardMaterial({
        color: 0xffffff,
        emissive: 0x00ffff,
        emissiveIntensity: 0.8,
        roughness: 0.1
      });
      const hub = new THREE.Mesh(hubGeo, rgbMat);
      hub.rotation.z = Math.PI / 2;
      bladesGroup.add(hub);
      
      const fanLight = new THREE.PointLight(0x00ffff, 0.6, 1.5);
      fanLight.name = "rgb-light";
      fanGroup.add(fanLight);
      rgbLights.push(fanLight);

      for (let i = 0; i < 5; i++) {
        const bladeGeo = new THREE.BoxGeometry(0.02, 0.18, 0.08);
        const bladeMat = new THREE.MeshStandardMaterial({ color: 0xffffff, transparent: true, opacity: 0.65 });
        const blade = new THREE.Mesh(bladeGeo, bladeMat);
        blade.position.y = 0.12;
        
        const wrapper = new THREE.Group();
        wrapper.rotation.x = (i * Math.PI * 2) / 5;
        wrapper.add(blade);
        bladesGroup.add(wrapper);
      }

      fanGroup.add(bladesGroup);
      scene.add(fanGroup);
      fanMeshes.push(fanGroup);
    });
  }

  function buildProceduralMotherboard() {
    const pcbGeo = new THREE.BoxGeometry(0.05, 1.4, 1.2);
    const pcbMat = new THREE.MeshStandardMaterial({ color: 0x111116, roughness: 0.8, metalness: 0.2 });
    motherboardMesh = new THREE.Mesh(pcbGeo, pcbMat);
    motherboardMesh.position.set(-1.45, 0.4, 0);
    scene.add(motherboardMesh);

    const ioGeo = new THREE.BoxGeometry(0.12, 0.6, 0.25);
    const ioMat = new THREE.MeshStandardMaterial({ color: 0x22222a, roughness: 0.4, metalness: 0.9 });
    const io = new THREE.Mesh(ioGeo, ioMat);
    io.position.set(0.05, 0.35, -0.45);
    motherboardMesh.add(io);

    const socketGeo = new THREE.BoxGeometry(0.05, 0.25, 0.25);
    const socketMat = new THREE.MeshStandardMaterial({ color: 0x33333b, metalness: 0.9 });
    const socket = new THREE.Mesh(socketGeo, socketMat);
    socket.position.set(0.03, 0.25, 0);
    motherboardMesh.add(socket);
  }

  function buildProceduralRAM() {
    const zPositions = [-0.15, -0.19, -0.23, -0.27];
    zPositions.forEach((zOffset, idx) => {
      const slotGeo = new THREE.BoxGeometry(0.08, 0.3, 0.02);
      const slotMat = new THREE.MeshStandardMaterial({ color: 0x050505, roughness: 0.9 });
      const slot = new THREE.Mesh(slotGeo, slotMat);
      slot.position.set(-1.38, 0.65, zOffset);
      scene.add(slot);

      const diffGeo = new THREE.BoxGeometry(0.06, 0.28, 0.01);
      const diffMat = new THREE.MeshStandardMaterial({
        color: 0xffffff,
        emissive: 0xff00ff,
        emissiveIntensity: 1.0,
        roughness: 0.2
      });
      const diffuser = new THREE.Mesh(diffGeo, diffMat);
      diffuser.position.x = 0.02;
      slot.add(diffuser);
      ramMeshes.push(diffuser);
    });
  }

  function buildProceduralCoolers() {
    // 1. AIO LIQUID PUMP
    liquidCoolerMesh = new THREE.Group();
    liquidCoolerMesh.position.set(-1.38, 0.65, 0);

    const pumpGeo = new THREE.CylinderGeometry(0.13, 0.13, 0.08, 16);
    const pumpMat = new THREE.MeshStandardMaterial({ color: 0x1a1a24, roughness: 0.3, metalness: 0.9 });
    const pumpBody = new THREE.Mesh(pumpGeo, pumpMat);
    pumpBody.rotation.z = Math.PI / 2;
    liquidCoolerMesh.add(pumpBody);

    const ringGeo = new THREE.TorusGeometry(0.09, 0.015, 8, 24);
    const ringMat = new THREE.MeshStandardMaterial({
      color: 0xffffff,
      emissive: 0x00ffff,
      emissiveIntensity: 1.2,
      roughness: 0.1
    });
    const ring = new THREE.Mesh(ringGeo, ringMat);
    ring.position.x = 0.045;
    ring.rotation.y = Math.PI / 2;
    liquidCoolerMesh.add(ring);
    
    const pumpLight = new THREE.PointLight(0x00ffff, 0.8, 1.2);
    pumpLight.name = "rgb-light";
    pumpLight.position.x = 0.05;
    liquidCoolerMesh.add(pumpLight);
    rgbLights.push(pumpLight);

    const tubeCurve1 = new THREE.CatmullRomCurve3([
      new THREE.Vector3(0, 0, 0.05),
      new THREE.Vector3(0.3, 0.3, 0.1),
      new THREE.Vector3(0.5, 0.8, 0.1),
      new THREE.Vector3(0.2, 1.0, 0.05)
    ]);
    const tubeGeo1 = new THREE.TubeGeometry(tubeCurve1, 16, 0.025, 8, false);
    const tubeMat = new THREE.MeshStandardMaterial({ color: 0x08080a, roughness: 0.9 });
    const tube1 = new THREE.Mesh(tubeGeo1, tubeMat);
    liquidCoolerMesh.add(tube1);

    const tubeCurve2 = new THREE.CatmullRomCurve3([
      new THREE.Vector3(0, 0, -0.05),
      new THREE.Vector3(0.3, 0.3, -0.1),
      new THREE.Vector3(0.5, 0.8, -0.1),
      new THREE.Vector3(0.2, 1.0, -0.05)
    ]);
    const tubeGeo2 = new THREE.TubeGeometry(tubeCurve2, 16, 0.025, 8, false);
    const tube2 = new THREE.Mesh(tubeGeo2, tubeMat);
    liquidCoolerMesh.add(tube2);

    scene.add(liquidCoolerMesh);

    // 2. AIR DUAL TOWER COOLER
    airCoolerMesh = new THREE.Group();
    airCoolerMesh.position.set(-1.38, 0.65, 0);

    const towerGeo1 = new THREE.BoxGeometry(0.25, 0.45, 0.4);
    const towerMat = new THREE.MeshStandardMaterial({ color: 0xd4af37, metalness: 0.9, roughness: 0.1 });
    const tower1 = new THREE.Mesh(towerGeo1, towerMat);
    tower1.position.set(0.15, 0, 0.12);
    airCoolerMesh.add(tower1);

    const tower2 = new THREE.Mesh(towerGeo1, towerMat);
    tower2.position.set(0.15, 0, -0.12);
    airCoolerMesh.add(tower2);

    const airFanGeo = new THREE.BoxGeometry(0.1, 0.4, 0.4);
    const airFanMat = new THREE.MeshStandardMaterial({ color: 0x42281a, roughness: 0.7 });
    const airFan = new THREE.Mesh(airFanGeo, airFanMat);
    airFan.position.set(0.15, 0, 0);
    airCoolerMesh.add(airFan);

    scene.add(airCoolerMesh);

    liquidCoolerMesh.visible = false;
    airCoolerMesh.visible = false;
  }

  function buildProceduralGPU() {
    gpuMesh = new THREE.Group();
    gpuMesh.position.set(-0.9, 0.3, 0);

    const cardGeo = new THREE.BoxGeometry(0.9, 0.28, 2.5);
    const cardMat = new THREE.MeshStandardMaterial({ color: 0x121218, roughness: 0.4, metalness: 0.8 });
    const body = new THREE.Mesh(cardGeo, cardMat);
    gpuMesh.add(body);

    const backplateGeo = new THREE.BoxGeometry(0.9, 0.02, 2.45);
    const backplateMat = new THREE.MeshStandardMaterial({ color: 0x050505, roughness: 0.2, metalness: 0.9 });
    const backplate = new THREE.Mesh(backplateGeo, backplateMat);
    backplate.position.y = 0.15;
    gpuMesh.add(backplate);

    const stripGeo = new THREE.BoxGeometry(0.02, 0.1, 2.2);
    const stripMat = new THREE.MeshStandardMaterial({
      color: 0xffffff,
      emissive: 0x00ffff,
      emissiveIntensity: 1.2,
      roughness: 0.1
    });
    const rgbStrip = new THREE.Mesh(stripGeo, stripMat);
    rgbStrip.position.set(0.46, 0.02, 0);
    gpuMesh.add(rgbStrip);
    ramMeshes.push(rgbStrip);

    for (let i = -1; i <= 1; i++) {
      const fanRimGeo = new THREE.CylinderGeometry(0.3, 0.3, 0.02, 16);
      const fanRimMat = new THREE.MeshStandardMaterial({ color: 0x08080a });
      const rim = new THREE.Mesh(fanRimGeo, fanRimMat);
      rim.position.set(0, -0.15, i * 0.7);
      rim.rotation.x = Math.PI / 2;
      gpuMesh.add(rim);
    }

    scene.add(gpuMesh);
    gpuMesh.visible = false;
  }

  // 4. ANIMATION FRAME LOOP
  function animate() {
    requestAnimationFrame(animate);
    if (!threeJsReady) return;

    if (powerOn) {
      fanMeshes.forEach(fan => {
        const blades = fan.getObjectByName("blades");
        if (blades) {
          blades.rotation.x += 0.22;
        }
      });
    }

    if (powerOn) {
      rgbColorTimer += 0.015;
      
      let r = 0, g = 0, b = 0;
      const currentMode = rgbModes[rgbModeIndex];

      if (currentMode === "RAINBOW") {
        r = Math.sin(rgbColorTimer) * 0.5 + 0.5;
        g = Math.sin(rgbColorTimer + Math.PI*2/3) * 0.5 + 0.5;
        b = Math.sin(rgbColorTimer + Math.PI*4/3) * 0.5 + 0.5;
      } else if (currentMode === "CYBERPUNK") {
        if (Math.sin(rgbColorTimer * 2) > 0) {
          r = 1.0; g = 0.0; b = 0.6;
        } else {
          r = 0.0; g = 0.8; b = 1.0;
        }
      } else if (currentMode === "GOLDEN") {
        r = 0.85 + Math.sin(rgbColorTimer * 3) * 0.15;
        g = 0.65 + Math.sin(rgbColorTimer * 3) * 0.1;
        b = 0.2;
      }

      const colorObj = new THREE.Color(r, g, b);

      ramMeshes.forEach(mesh => {
        mesh.material.emissive.copy(colorObj);
        mesh.material.emissiveIntensity = 1.2;
      });

      rgbLights.forEach(light => {
        light.color.copy(colorObj);
        light.intensity = 1.2;
      });

      if (liquidCoolerMesh.visible) {
        const ring = liquidCoolerMesh.children[1];
        if (ring) ring.rotation.z += 0.01;
      }
    } else {
      const blackColor = new THREE.Color(0, 0, 0);
      ramMeshes.forEach(mesh => {
        mesh.material.emissive.copy(blackColor);
        mesh.material.emissiveIntensity = 0.0;
      });
      rgbLights.forEach(light => {
        light.intensity = 0.0;
      });
    }

    controls.update();
    renderer.render(scene, camera);
  }

  // 5. INTERACT & SYNC COMPONENT SELECTIONS TO 3D MODEL
  function selectComp(slotKey, el, name, priceStr, priceNum, msg, compat) {
    const slotData = MOCK_DB[slotKey];
    const item = slotData.items.find(i => i.name === name);
    if (!item) return;

    buildState[slotKey] = item;

    // Update UI elements
    const slot = document.getElementById('slot-'+slotKey);
    if (slot) {
      slot.querySelectorAll('.picker-item').forEach(p=>p.classList.remove('selected'));
      el.classList.add('selected');
      document.getElementById('sel-'+slotKey+'-name').textContent=name;
      document.getElementById('sel-'+slotKey+'-name').style.color='var(--white)';
      document.getElementById('sel-'+slotKey+'-name').style.fontStyle='normal';
      document.getElementById('sel-'+slotKey+'-price').textContent=priceStr;
      document.getElementById('sel-'+slotKey+'-price').style.color='var(--gold)';
      slot.classList.add('has-item');
    }

    if (compat==='warn') {
      slot.classList.add('compat-error');
    } else {
      slot.classList.remove('compat-error');
    }

    // 3D Model Sync
    if (threeJsReady) {
      if (slotKey === 'cool') {
        if (item.coolerType === 'liquid') {
          liquidCoolerMesh.visible = true;
          airCoolerMesh.visible = false;
        } else {
          liquidCoolerMesh.visible = false;
          airCoolerMesh.visible = true;
        }
      }
      else if (slotKey === 'mb') {
        motherboardMesh.material.color.setHex(item.color);
      }
      else if (slotKey === 'gpu') {
        gpuMesh.visible = true;
        gpuMesh.scale.set(1, item.thickness, item.length);
      }
      else if (slotKey === 'ram') {
        for (let i = 0; i < ramMeshes.length; i++) {
          ramMeshes[i].parent.visible = (i < item.sticks);
        }
      }
    }

    setTimeout(() => {
      if (slot && slot.classList.contains('open')) {
        slot.classList.remove('open');
      }
    }, 300);

    recalculateStats();
    toast('✓ Đã lắp linh kiện: ' + name);
  }

  // --- TAB SWITCHING & PACKAGES ---
  function switchTab(tabId) {
    activeTab = tabId;
    
    document.getElementById('tab-custom').classList.toggle('active', tabId === 'custom');
    document.getElementById('tab-packages').classList.toggle('active', tabId === 'packages');

    document.getElementById('custom-builder-view').style.display = tabId === 'custom' ? 'block' : 'none';
    document.getElementById('packages-builder-view').style.display = tabId === 'packages' ? 'flex' : 'none';

    showToast(tabId === 'custom' ? "🔧 Chuyển sang chỉnh sửa linh kiện tự chọn" : "📦 Chọn các cấu hình PC đồng bộ sẵn");
  }

  function renderPackages() {
    const container = document.getElementById('packages-builder-view');
    container.innerHTML = '';

    MOCK_PACKAGES.forEach(pkg => {
      const isSelected = currentSelectedPackageId === pkg.id;
      
      const cpuItem = MOCK_DB.cpu.items.find(i => i.id === pkg.parts.cpu);
      const gpuItem = MOCK_DB.gpu.items.find(i => i.id === pkg.parts.gpu);
      const ramItem = MOCK_DB.ram.items.find(i => i.id === pkg.parts.ram);

      const cpuName = cpuItem ? cpuItem.name.split(' ')[0] + ' ' + cpuItem.name.split(' ').slice(-1) : '';
      const gpuName = gpuItem ? gpuItem.name.replace('NVIDIA ', '').replace(' Edition', '') : '';
      const ramName = ramItem ? ramItem.name.split(' ')[0] + ' ' + (ramItem.sticks * 16) + 'GB' : '';

      let rawSum = 0;
      for (let slot in pkg.parts) {
        const itemId = pkg.parts[slot];
        const item = MOCK_DB[slot].items.find(i => i.id === itemId);
        if (item) rawSum += item.price;
      }
      const savings = rawSum - pkg.price;

      const card = document.createElement('div');
      card.className = `package-card ${isSelected ? 'selected' : ''}`;
      card.id = `pkg-card-${pkg.id}`;
      card.onclick = () => selectPackage(pkg.id);

      card.innerHTML = `
        <div class="pkg-title">${pkg.name}</div>
        <div class="pkg-desc">${pkg.desc}</div>
        
        <div class="pkg-specs-preview">
          <span class="pkg-spec-badge">⚙️ ${cpuName}</span>
          <span class="pkg-spec-badge">🎮 ${gpuName}</span>
          <span class="pkg-spec-badge">💾 ${ramName}</span>
        </div>

        <div class="pkg-price-row">
          <div>
            <span class="pkg-price">${pkg.price.toLocaleString('vi-VN')}₫</span>
          </div>
          ${savings > 0 ? `<span class="pkg-savings">Tiết kiệm ${(savings/1000000).toFixed(1)}Tr₫</span>` : ''}
        </div>
      `;
      container.appendChild(card);
    });
    registerCursorEvents();
  }

  function checkPackageMatch() {
    for (let pkg of MOCK_PACKAGES) {
      let match = true;
      for (let slot in pkg.parts) {
        if (!buildState[slot] || buildState[slot].id !== pkg.parts[slot]) {
          match = false;
          break;
        }
      }
      if (match) return pkg;
    }
    return null;
  }

  function selectPackage(pkgId) {
    const pkg = MOCK_PACKAGES.find(p => p.id === pkgId);
    if (!pkg) return;

    currentSelectedPackageId = pkg.id;

    // Update state
    for (let slotKey in pkg.parts) {
      const itemId = pkg.parts[slotKey];
      const item = MOCK_DB[slotKey].items.find(i => i.id === itemId);
      buildState[slotKey] = item;
    }

    // Sync selected items highlights in slots picker
    for (let slotKey in MOCK_DB) {
      const slotEl = document.getElementById('slot-'+slotKey);
      if (slotEl) {
        const item = buildState[slotKey];
        if (item) {
          slotEl.classList.add('has-item');
          document.getElementById('sel-'+slotKey+'-name').textContent=item.name;
          document.getElementById('sel-'+slotKey+'-name').style.color='var(--white)';
          document.getElementById('sel-'+slotKey+'-name').style.fontStyle='normal';
          document.getElementById('sel-'+slotKey+'-price').textContent=item.price.toLocaleString('vi-VN')+'₫';
          document.getElementById('sel-'+slotKey+'-price').style.color='var(--gold)';
          
          slotEl.querySelectorAll('.picker-item').forEach(pi => {
            const piName = pi.querySelector('.pi-name').textContent;
            pi.classList.toggle('selected', piName === item.name);
          });
        }
      }
    }

    // Sync 3D Parts
    if (threeJsReady) {
      // Cooler
      const coolItem = buildState.cool;
      if (coolItem) {
        if (coolItem.coolerType === 'liquid') {
          liquidCoolerMesh.visible = true;
          airCoolerMesh.visible = false;
        } else {
          liquidCoolerMesh.visible = false;
          airCoolerMesh.visible = true;
        }
      }

      // MB
      if (buildState.mb) motherboardMesh.material.color.setHex(buildState.mb.color);

      // GPU
      if (buildState.gpu) {
        gpuMesh.visible = true;
        gpuMesh.scale.set(1, buildState.gpu.thickness, buildState.gpu.length);
      }

      // RAM
      if (buildState.ram) {
        for (let i = 0; i < ramMeshes.length; i++) {
          ramMeshes[i].parent.visible = (i < buildState.ram.sticks);
        }
      }

      // RGB mode theme
      const modeIdx = rgbModes.indexOf(pkg.rgbMode);
      if (modeIdx !== -1) {
        rgbModeIndex = modeIdx;
        const rgbBtn = document.getElementById('btn-rgb');
        if (rgbBtn) rgbBtn.innerText = `RGB: ${pkg.rgbMode}`;
      }
      powerOn = true;
      const powerBtn = document.getElementById('btn-power');
      if (powerBtn) {
        powerBtn.innerText = "Khởi Động: Bật";
        powerBtn.classList.add('active');
      }

      animateCameraTransition();
    }

    // Sync Preset cards highlights
    document.querySelectorAll('.preset-card').forEach(c=>c.classList.remove('active'));
    if (pkgId === 'pkg-gaming-beast') document.getElementById('preset-gaming').classList.add('active');
    else if (pkgId === 'pkg-creator-pro') document.getElementById('preset-creator').classList.add('active');
    else if (pkgId === 'pkg-performance') document.getElementById('preset-budget').classList.add('active');

    renderPackages();
    recalculateStats();

    showToast(`📦 Đã áp dụng Gói: ${pkg.name}`);
  }

  function animateCameraTransition() {
    if (!threeJsReady) return;
    const startRadius = 6;
    let angle = 0;
    const duration = 80;
    let frame = 0;

    function step() {
      if (frame < duration) {
        angle = (frame / duration) * Math.PI * 2 + Math.PI/4;
        camera.position.x = Math.cos(angle) * startRadius * 0.8;
        camera.position.z = Math.sin(angle) * startRadius * 0.8;
        camera.position.y = 2 + Math.sin(frame / 10) * 0.5;
        frame++;
        controls.update();
        requestAnimationFrame(step);
      } else {
        camera.position.set(4, 3, 5);
        controls.update();
      }
    }
    step();
  }

  // 6. TOGGLE POWER & CAM RESET
  function togglePower() {
    powerOn = !powerOn;
    const btn = document.getElementById('btn-power');
    if (btn) {
      btn.innerText = powerOn ? "Khởi Động: Bật" : "Khởi Động: Tắt";
      btn.classList.toggle('active', powerOn);
    }
    showToast(powerOn ? "⚡ Bật nguồn: Hệ thống 3D sáng quạt quay!" : "🔌 Tắt nguồn: Dừng toàn bộ hệ thống.");
  }

  function cycleRgbMode() {
    if (!powerOn) return;
    rgbModeIndex = (rgbModeIndex + 1) % rgbModes.length;
    const currentMode = rgbModes[rgbModeIndex];
    const btn = document.getElementById('btn-rgb');
    if (btn) btn.innerText = `RGB: ${currentMode}`;
    showToast(`Chế độ RGB: ${currentMode}`);
  }

  function resetCamera() {
    if (!threeJsReady) return;
    const targetAngle = camera.position.x > 0 ? -4 : 4;
    let count = 0;
    function pan() {
      if (count < 30) {
        camera.position.x += (targetAngle - camera.position.x) * 0.1;
        camera.position.z += (3 - camera.position.z) * 0.1;
        count++;
        controls.update();
        requestAnimationFrame(pan);
      }
    }
    pan();
  }

  // 7. RENDER SLOTS LIST
  function renderSlots() {
    const container = document.getElementById('slots-container');
    container.innerHTML = '';

    for (let slotKey in MOCK_DB) {
      const slotData = MOCK_DB[slotKey];
      const selectedItem = buildState[slotKey];

      const card = document.createElement('div');
      card.id = `slot-card-${slotKey}`;
      card.className = `comp-slot ${selectedItem ? 'has-item' : ''}`;

      let itemsHtml = '';
      slotData.items.forEach(item => {
        const isSelected = selectedItem && selectedItem.name === item.name;
        itemsHtml += `
          <div class="picker-item ${isSelected ? 'selected' : ''}" onclick="selectCompWrapper('${slotKey}', this, '${item.name}', '${item.price.toLocaleString('vi-VN')}₫', ${item.price})">
            <span class="pi-icon">${slotData.icon}</span>
            <div class="pi-info">
              <div class="pi-name">${item.name}</div>
              <div class="pi-spec">${item.desc}</div>
            </div>
            <span class="compat-badge badge-ok">✓ ${window.t('build-pc-badge-ok', 'Ok')}</span>
            <div class="pi-price">${item.price.toLocaleString('vi-VN')}₫</div>
            <div class="pi-check">✓</div>
          </div>
        `;
      });

      card.innerHTML = `
        <div class="slot-header" onclick="toggleSlot('${slotKey}')">
          <div class="slot-icon">${slotData.icon}</div>
          <div class="slot-info">
            <div class="slot-type">${window.t('build-pc-slot-' + slotKey, slotData.title)}</div>
            <div class="slot-name ${!selectedItem ? 'sum-empty' : ''}" id="sel-${slotKey}-name" style="${!selectedItem ? 'color:var(--muted);font-style:italic;' : ''}">
              ${selectedItem ? selectedItem.name : window.t('build-pc-not-selected', 'Chưa chọn')}
            </div>
          </div>
          <div class="slot-price" id="sel-${slotKey}-price" style="${!selectedItem ? 'color:var(--muted);' : ''}">
            ${selectedItem ? selectedItem.price.toLocaleString('vi-VN') + '₫' : '+'}
          </div>
          <div class="slot-toggle">▾</div>
        </div>
        <div class="comp-picker">
          <div class="picker-label">${window.t('build-pc-select-part', 'Chọn linh kiện')}</div>
          <div class="picker-list" id="parts-list-${slotKey}">
            ${itemsHtml}
          </div>
        </div>
      `;
      container.appendChild(card);
    }
    registerCursorEvents();
  }

  function selectCompWrapper(slotKey, el, name, priceStr, priceNum) {
    selectComp(slotKey, el, name, priceStr, priceNum, '', 'ok');
  }

  function toggleSlot(id) {
    const slot = document.getElementById('slot-card-'+id);
    const isOpen = slot.classList.contains('open');
    document.querySelectorAll('.comp-slot').forEach(s => s.classList.remove('open'));
    if (!isOpen) {
      slot.classList.add('open');
    }
  }

  // 8. ESTIMATE AND BENCHMARK CALCULATIONS
  function recalculateStats() {
    let totalPrice = 0;
    let totalTdp = 0;
    let psuWattage = 0;
    let count = 0;

    const listContainer = document.getElementById('sum-list');
    listContainer.innerHTML = '';

    for (let slotKey in MOCK_DB) {
      const item = buildState[slotKey];
      if (item) {
        totalPrice += item.price;
        if (item.tdp) totalTdp += item.tdp;
        if (slotKey === 'psu' && item.wattage) psuWattage = item.wattage;
        count++;

        // Add to summary list
        const shortName = item.name.length > 22 ? item.name.substring(0, 22) + '…' : item.name;
        listContainer.innerHTML += `
          <div class="sum-item">
            <div>
              <div class="sum-type">${window.t('build-pc-slot-' + slotKey, MOCK_DB[slotKey].title)}</div>
              <div class="sum-name">${shortName}</div>
            </div>
            <div class="sum-price">${item.price.toLocaleString('vi-VN')}₫</div>
          </div>
        `;
      } else {
        listContainer.innerHTML += `
          <div class="sum-item">
            <div>
              <div class="sum-type">${window.t('build-pc-slot-' + slotKey, MOCK_DB[slotKey].title)}</div>
              <div class="sum-name sum-empty">${window.t('build-pc-not-selected', 'Chưa chọn')}</div>
            </div>
            <div class="sum-price" style="color:var(--muted);">—</div>
          </div>
        `;
      }
    }

    const matchedPkg = checkPackageMatch();
    const pkgBadge = document.getElementById('pkg-active-badge');
    if (matchedPkg) {
      currentSelectedPackageId = matchedPkg.id;
      totalPrice = matchedPkg.price;
      if (pkgBadge) {
        pkgBadge.style.display = 'flex';
        document.getElementById('pkg-active-name').textContent = matchedPkg.name;
      }
    } else {
      currentSelectedPackageId = null;
      if (pkgBadge) {
        pkgBadge.style.display = 'none';
      }
    }

    document.getElementById('grand-total').textContent = totalPrice.toLocaleString('vi-VN') + '₫';
    document.getElementById('part-count').innerHTML = `${count} <span data-translate="build-pc-sum-parts-selected">${window.t('build-pc-sum-parts-selected', 'linh kiện đã chọn')}</span>`;

    // Socket matching alert
    const cpu = buildState.cpu;
    const mb = buildState.mb;
    const compatAlert = document.getElementById('compat-alert');
    const compatMsg = document.getElementById('compat-msg');

    if (cpu && mb && cpu.socket !== mb.socket) {
      compatAlert.className = 'compat-alert warn';
      compatAlert.style.display = 'block';
      compatMsg.innerHTML = `${window.t('build-pc-compat-socket-error', 'Lỗi Socket:')} CPU ${cpu.name} (${cpu.socket}) ${window.t('build-pc-compat-mismatch', 'không khớp với Mainboard')} ${mb.name} (${mb.socket})!`;
      if (document.getElementById('slot-card-cpu')) document.getElementById('slot-card-cpu').classList.add('compat-error');
      if (document.getElementById('slot-card-mb')) document.getElementById('slot-card-mb').classList.add('compat-error');
    } else {
      compatAlert.className = 'compat-alert ok';
      compatAlert.style.display = 'flex';
      compatMsg.textContent = window.t('build-pc-compat-ok', 'Tất cả linh kiện tương thích hoàn toàn');
      if (cpu && document.getElementById('slot-card-cpu')) document.getElementById('slot-card-cpu').classList.remove('compat-error');
      if (mb && document.getElementById('slot-card-mb')) document.getElementById('slot-card-mb').classList.remove('compat-error');
    }

    calculateBenchmarks();
  }

  function calculateBenchmarks() {
    const cpu = buildState.cpu;
    const gpu = buildState.gpu;
    const ram = buildState.ram;

    let gamingScore = 0;
    let renderScore = 0;
    let aiScore = 0;
    let multiScore = 0;

    if (gpu) {
      if (gpu.id === 'gpu-4090') gamingScore += 65;
      else if (gpu.id === 'gpu-4080s') gamingScore += 48;
      else gamingScore += 38;
    }
    if (cpu) {
      if (cpu.id === 'cpu-i9') { gamingScore += 30; renderScore += 55; aiScore += 35; multiScore += 50; }
      else if (cpu.id === 'cpu-r9') { gamingScore += 27; renderScore += 58; aiScore += 32; multiScore += 52; }
      else { gamingScore += 22; renderScore += 40; aiScore += 24; multiScore += 38; }
    }
    if (gpu) {
      if (gpu.id === 'gpu-4090') { renderScore += 38; aiScore += 60; multiScore += 38; }
      else if (gpu.id === 'gpu-4080s') { renderScore += 28; aiScore += 42; multiScore += 28; }
      else { renderScore += 20; aiScore += 32; multiScore += 20; }
    }
    if (ram) {
      if (ram.id === 'ram-gskill') { gamingScore += 4; renderScore += 6; aiScore += 3; multiScore += 8; }
      else { gamingScore += 2; renderScore += 3; aiScore += 1; multiScore += 4; }
    }

    gamingScore = Math.min(99, gamingScore);
    renderScore = Math.min(99, renderScore);
    aiScore = Math.min(99, aiScore);
    multiScore = Math.min(99, multiScore);

    document.getElementById('perf-gaming-v').textContent = `${gamingScore}%`;
    document.getElementById('perf-gaming').style.width = `${gamingScore}%`;

    document.getElementById('perf-render-v').textContent = `${renderScore}%`;
    document.getElementById('perf-render').style.width = `${renderScore}%`;

    document.getElementById('perf-ai-v').textContent = `${aiScore}%`;
    document.getElementById('perf-ai').style.width = `${aiScore}%`;

    document.getElementById('perf-multi-v').textContent = `${multiScore}%`;
    document.getElementById('perf-multi').style.width = `${multiScore}%`;
  }

  // PRESET CARDS HOVER LOADS
  function loadPreset(type, card) {
    if (type === 'gaming') selectPackage('pkg-gaming-beast');
    else if (type === 'creator') selectPackage('pkg-creator-pro');
    else if (type === 'budget') selectPackage('pkg-performance');
  }

  function resetBuild() {
    buildState = { cpu: null, mb: null, gpu: null, ram: null, ssd: null, psu: null, cool: null };
    
    // Clear picker selections visual classes
    document.querySelectorAll('.picker-item').forEach(pi => pi.classList.remove('selected'));
    document.querySelectorAll('.comp-slot').forEach(s => {
      s.classList.remove('has-item');
      s.classList.remove('compat-error');
    });

    if (threeJsReady) {
      liquidCoolerMesh.visible = false;
      airCoolerMesh.visible = false;
      gpuMesh.visible = false;
    }

    renderSlots();
    recalculateStats();
    toast('↺ ' + window.t('build-pc-toast-reset', 'Đã reset cấu hình. Bắt đầu lại từ đầu.'));
  }

  function addBuildToCart() {
    const count = Object.values(buildState).filter(v=>v).length;
    if (count < 4) {
      toast('⚠️ ' + window.t('build-pc-toast-min-parts', 'Vui lòng chọn ít nhất: CPU, Mainboard, GPU và RAM.'));
      return;
    }
    toast('✓ ' + window.t('build-pc-toast-add-cart', 'Đã thêm toàn bộ cấu hình vào giỏ hàng!'));
    setTimeout(()=>location.href='/checkout',1000);
  }

  function saveBuild() {
    toast('💾 ' + window.t('build-pc-toast-save-build', 'Đã lưu cấu hình PC 3D vào tài khoản của bạn!'));
  }

  function shareBuild() {
    navigator.clipboard?.writeText(window.location.href).catch(()=>{});
    toast('🔗 ' + window.t('build-pc-toast-share-build', 'Đã sao chép liên kết cấu hình!'));
  }

  // --- AI ADVISOR CHATBOT ENGINE ---
  function toggleChatWindow() {
    const windowEl = document.getElementById('ai-chat-window');
    if (!windowEl) return;
    const isOpen = windowEl.classList.contains('open');
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

  function handleChatKeyPress(event) {
    if (event.key === 'Enter') {
      sendChatMessage();
    }
  }

  function sendChatMessage() {
    const inputEl = document.getElementById('chat-input-field');
    if (!inputEl) return;
    const text = inputEl.value.trim();
    if (!text) return;

    appendMessage(text, 'user');
    inputEl.value = '';

    // Hiển thị trạng thái AI đang gõ...
    const area = document.getElementById('chat-messages-area');
    const loadingMsg = document.createElement('div');
    loadingMsg.className = 'chat-msg bot';
    loadingMsg.id = 'ai-loading-indicator';
    loadingMsg.innerHTML = '<span>AI đang suy nghĩ...</span>';
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
        // Định dạng Markdown đơn giản (Xuống dòng và in đậm)
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
    msg.className = `chat-msg ${sender}`;
    
    let htmlContent = `<span>${text}</span>`;
    if (action) {
      htmlContent += `<br><button class="chat-action-btn" onclick="${action.func}">${action.label}</button>`;
    }
    msg.innerHTML = htmlContent;
    
    area.appendChild(msg);
    area.scrollTop = area.scrollHeight;
  }

  function askAdvisorQuick(type) {
    let query = "";
    if (type === 'game') query = "Tôi cần tư vấn cấu hình chiến game 4K";
    else if (type === 'graphic') query = "Tư vấn cấu hình làm đồ họa 3D render";
    else if (type === 'ai') query = "Tôi muốn build máy AI Workstation";
    else if (type === 'cool') query = "Nên chọn tản nước hay tản khí?";

    appendMessage(query, 'user');

    // Hiển thị trạng thái AI đang gõ...
    const area = document.getElementById('chat-messages-area');
    const loadingMsg = document.createElement('div');
    loadingMsg.className = 'chat-msg bot';
    loadingMsg.id = 'ai-loading-indicator';
    loadingMsg.innerHTML = '<span>AI đang phân tích cấu hình...</span>';
    area.appendChild(loadingMsg);
    area.scrollTop = area.scrollHeight;

    fetch('/api/build/ai-advisor', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ message: query })
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


  function generateAdvisorResponse(input) {
    const query = input.toLowerCase();

    if (query.includes('game') || query.includes('chơi game') || query.includes('gaming')) {
      return {
        text: "Để chơi mượt game AAA 4K (Ray Tracing cực đỉnh), gói <strong>Gaming Beast</strong> với Core i9-14900K, RTX 4090, RAM 32GB Corsair Dominator và tản AIO ROG Ryujin III là vô địch.",
        action: {
          label: "🔧 Lắp Ráp Gói Gaming Beast",
          func: "selectPackage('pkg-gaming-beast'); toggleChatWindow();"
        }
      };
    }

    if (query.includes('đồ họa') || query.includes('render') || query.includes('thiết kế') || query.includes('photoshop') || query.includes('3d')) {
      return {
        text: "Cho thiết kế và render 3D hạng nặng, gói <strong>Creator Pro</strong> trang bị cấu hình khủng nhất với i9-14900K, RTX 4090 và RAM lên tới 64GB G.Skill Trident Z5 RGB là lựa chọn đỉnh cao.",
        action: {
          label: "🔧 Lắp Ráp Gói Creator Pro",
          func: "selectPackage('pkg-creator-pro'); toggleChatWindow();"
        }
      };
    }

    if (query.includes('ai') || query.includes('workstation') || query.includes('deep learning') || query.includes('train')) {
      return {
        text: "Nếu muốn chuyên làm AI/deep learning local, tôi khuyên bạn sử dụng cấu hình Ryzen 9 7950X, RTX 4090 trong gói <strong>Creator Pro</strong> hoặc tự cấu hình nâng cấp RAM 64GB để xử lý tập dữ liệu tối ưu.",
        action: {
          label: "🔧 Lắp Ráp Gói Creator Pro",
          func: "selectPackage('pkg-creator-pro'); toggleChatWindow();"
        }
      };
    }

    if (query.includes('tản nhiệt') || query.includes('tản khí') || query.includes('tản nước') || query.includes('nhiệt') || query.includes('nóng')) {
      return {
        text: "• <strong>Tản khí Noctua NH-D15</strong>: Cực kỳ bền, không sợ rò rỉ nước, làm mát rất tốt.<br>• <strong>Tản AIO ASUS Ryujin III 360</strong>: Có màn hình LCD hiển thị nhiệt độ, LED ARGB rực rỡ và hiệu năng làm mát tối đa cho CPU sinh nhiệt lớn."
      };
    }

    if (query.includes('màu') || query.includes('led') || query.includes('rgb') || query.includes('sáng')) {
      return {
        text: "Bạn có thể chỉnh đèn LED RGB trực tiếp bằng nút <strong>[RGB: Rainbow]</strong> dưới màn hình 3D để đổi qua các màu: Rainbow cầu vồng, Cyberpunk neon hồng/xanh và Golden quý tộc."
      };
    }

    return {
      text: "Xin chào! Tôi có thể tư vấn các gói cấu hình máy tính Luxury phù hợp nhất cho bạn. Bạn muốn build máy chuyên chơi game, dựng hình đồ họa render hay chạy mô hình AI?"
    };
  }

  // 9. WINDOW ONLOAD INITIALIZER
  window.onload = function() {
    init3D();
    renderPackages();
    renderSlots();
    
    const urlParams = new URLSearchParams(window.location.search);
    const pkgParam = urlParams.get('package');
    if (pkgParam && MOCK_PACKAGES.some(p => p.id === pkgParam)) {
      selectPackage(pkgParam);
    } else {
      selectPackage('pkg-gaming-beast');
    }
    
    animate();
  };

  // Register hook for page-specific re-renders when language changes
  window.onLanguageChange = function(lang) {
      if (threeJsReady) {
          renderPackages();
          renderSlots();
          recalculateStats();
      }
  };