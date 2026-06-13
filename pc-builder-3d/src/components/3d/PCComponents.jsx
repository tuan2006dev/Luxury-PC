import React, { useRef } from 'react';
import { useFrame } from '@react-three/fiber';
import * as THREE from 'three';
import { getRGBColor } from '../../data/constants';
import { MonitorComponent, KeyboardComponent, MouseComponent } from './DeskAccessories';

// --- CPU Component ---
export function CPUComponent({ color }) {
  return (
    <group>
      {/* Dark green PCB Base */}
      <mesh castShadow receiveShadow>
        <boxGeometry args={[0.6, 0.6, 0.04]} />
        <meshStandardMaterial color="#0e3a1e" roughness={0.8} />
      </mesh>
      {/* Golden pins/contacts on the underside */}
      <mesh position={[0, 0, -0.025]}>
        <boxGeometry args={[0.58, 0.58, 0.01]} />
        <meshStandardMaterial color="#c9a84c" roughness={0.2} metalness={0.8} />
      </mesh>
      {/* Silver IHS Heat Spreader */}
      <mesh position={[0, 0, 0.04]} castShadow>
        <boxGeometry args={[0.48, 0.48, 0.04]} />
        <meshStandardMaterial color="#c0c0c0" roughness={0.2} metalness={0.9} />
      </mesh>
      {/* IHS inner outline decoration */}
      <mesh position={[0, 0, 0.062]}>
        <boxGeometry args={[0.35, 0.35, 0.005]} />
        <meshStandardMaterial color="#888" roughness={0.5} />
      </mesh>
    </group>
  );
}

// --- RAM Component ---
export function RAMComponent({ color, dimensions, isPoweredOn, rgbColorMode }) {
  const [w, h, d] = dimensions;
  const rgbRef = useRef(new THREE.Color('#ff0000'));
  const materialRef = useRef();

  useFrame((state) => {
    if (!isPoweredOn) {
      if (materialRef.current) materialRef.current.emissive.setHex(0x000000);
      return;
    }
    const time = state.clock.elapsedTime;
    const activeColor = getRGBColor(rgbColorMode, time);
    rgbRef.current.copy(activeColor);
    if (materialRef.current) {
      materialRef.current.emissive.copy(rgbRef.current);
    }
  });

  return (
    <group>
      {/* Metal Heatsink Body */}
      <mesh castShadow receiveShadow>
        <boxGeometry args={[w, h - 0.06, d]} />
        <meshStandardMaterial color={color} roughness={0.3} metalness={0.8} />
      </mesh>
      {/* Silver accent line */}
      <mesh position={[w/2 + 0.005, 0, 0]}>
        <boxGeometry args={[0.002, h * 0.4, d * 0.6]} />
        <meshStandardMaterial color="#ffffff" roughness={0.1} metalness={0.9} />
      </mesh>
      {/* RGB diffuser on top */}
      <mesh position={[0, h/2 - 0.03, 0]}>
        <boxGeometry args={[w + 0.01, 0.06, d + 0.01]} />
        <meshStandardMaterial 
          ref={materialRef} 
          color="#ffffff" 
          emissive={rgbRef.current} 
          emissiveIntensity={2} 
        />
      </mesh>
    </group>
  );
}

// --- GPU Component ---
export function GPUComponent({ color, dimensions, isPoweredOn, rgbColorMode }) {
  const [w, h, d] = dimensions;
  const rgbRef = useRef(new THREE.Color('#ff0000'));
  const ledMaterialRef = useRef();
  
  const fanRef1 = useRef();
  const fanRef2 = useRef();
  const fanRef3 = useRef();

  useFrame((state) => {
    if (!isPoweredOn) {
      if (ledMaterialRef.current) ledMaterialRef.current.emissive.setHex(0x000000);
      return;
    }
    const time = state.clock.elapsedTime;
    const activeColor = getRGBColor(rgbColorMode, time);
    rgbRef.current.copy(activeColor);
    if (ledMaterialRef.current) {
      ledMaterialRef.current.emissive.copy(rgbRef.current);
    }
    
    // Spin fans
    if (fanRef1.current) fanRef1.current.rotation.z += 0.25;
    if (fanRef2.current) fanRef2.current.rotation.z += 0.25;
    if (fanRef3.current) fanRef3.current.rotation.z += 0.25;
  });

  return (
    <group>
      {/* Shroud Body */}
      <mesh castShadow receiveShadow>
        <boxGeometry args={[w, h, d - 0.05]} />
        <meshStandardMaterial color="#1a1a1a" roughness={0.5} metalness={0.6} />
      </mesh>
      {/* Metal Backplate */}
      <mesh position={[0, 0, -d/2 + 0.01]}>
        <boxGeometry args={[w - 0.02, h - 0.02, 0.02]} />
        <meshStandardMaterial color={color} roughness={0.3} metalness={0.9} />
      </mesh>
      {/* Heatsink Aluminum Fins (left & right sides) */}
      {[-w/2 + 0.02, w/2 - 0.02].map((xPos, idx) => (
        <group key={idx} position={[xPos, 0, 0]}>
          {[...Array(12)].map((_, i) => (
            <mesh key={i} position={[0, -h/2 + 0.2 + i * (h - 0.4) / 11, 0]}>
              <boxGeometry args={[0.02, 0.03, d - 0.1]} />
              <meshStandardMaterial color="#cccccc" roughness={0.2} metalness={0.8} />
            </mesh>
          ))}
        </group>
      ))}
      {/* Three vertical fans */}
      {[h * 0.28, 0, -h * 0.28].map((yOffset, fanIdx) => {
        const fRef = fanIdx === 0 ? fanRef1 : fanIdx === 1 ? fanRef2 : fanRef3;
        return (
          <group key={fanIdx} position={[0, yOffset, d/2 - 0.02]}>
            <mesh>
              <cylinderGeometry args={[w * 0.42, w * 0.42, 0.02, 16]} rotation={[Math.PI / 2, 0, 0]} />
              <meshStandardMaterial color="#0b0b0b" roughness={0.9} />
            </mesh>
            <group ref={fRef} position={[0, 0, 0.01]}>
              {[...Array(9)].map((_, i) => (
                <mesh key={i} rotation={[0, 0, (i * Math.PI) / 4.5]}>
                  <boxGeometry args={[w * 0.78, 0.06, 0.01]} />
                  <meshStandardMaterial color="#222" roughness={0.6} />
                </mesh>
              ))}
            </group>
          </group>
        );
      })}
      {/* RGB Branding logo strip */}
      <mesh position={[0, h * 0.42, d/2 - 0.01]}>
        <boxGeometry args={[w * 0.6, 0.05, 0.02]} />
        <meshStandardMaterial ref={ledMaterialRef} color="#fff" emissive={rgbRef.current} emissiveIntensity={2} />
      </mesh>
    </group>
  );
}

// --- Cooler Component ---
export function CoolerComponent({ coolerData, dimensions, isPoweredOn, rgbColorMode }) {
  const isAIO = coolerData?.id?.includes('360') || coolerData?.id?.includes('h150i') || coolerData?.id?.includes('arctic');
  const [w, h, d] = dimensions;
  const rgbRef = useRef(new THREE.Color('#ff0000'));
  const ledRef = useRef();
  
  const fanRef1 = useRef();
  const fanRef2 = useRef();
  const fanRef3 = useRef();

  useFrame((state) => {
    if (!isPoweredOn) {
      if (ledRef.current) ledRef.current.emissive.setHex(0x000000);
      return;
    }
    const time = state.clock.elapsedTime;
    const activeColor = getRGBColor(rgbColorMode, time);
    rgbRef.current.copy(activeColor);
    if (ledRef.current) {
      ledRef.current.emissive.copy(rgbRef.current);
    }
    
    const rotSpeed = 0.15;
    if (fanRef1.current) fanRef1.current.rotation.y += rotSpeed;
    if (fanRef2.current) fanRef2.current.rotation.y += rotSpeed;
    if (fanRef3.current) fanRef3.current.rotation.y += rotSpeed;
    if (!isAIO && fanRef1.current) {
      // Air cooler fan rotates around Z axis
      fanRef1.current.rotation.z += rotSpeed * 1.5;
    }
  });

  if (isAIO) {
    return (
      <group>
        {/* Pump Block sitting on CPU */}
        <group position={[0, 0, -0.3]}>
          <mesh castShadow>
            <cylinderGeometry args={[0.36, 0.36, 0.2, 32]} rotation={[Math.PI / 2, 0, 0]} />
            <meshStandardMaterial color="#1f1f1f" roughness={0.3} metalness={0.7} />
          </mesh>
          {/* LCD ring */}
          <mesh position={[0, 0, 0.105]}>
            <ringGeometry args={[0.26, 0.32, 32]} />
            <meshStandardMaterial ref={ledRef} color="#fff" emissive={rgbRef.current} emissiveIntensity={2} />
          </mesh>
          <mesh position={[0, 0, 0.101]}>
            <cylinderGeometry args={[0.25, 0.25, 0.01, 32]} rotation={[Math.PI / 2, 0, 0]} />
            <meshStandardMaterial color="#050505" roughness={0.1} />
          </mesh>
          <mesh position={[0, 0, 0.11]}>
            <boxGeometry args={[0.15, 0.08, 0.002]} />
            <meshStandardMaterial color={coolerData.color || '#fff'} emissive={coolerData.color || '#fff'} emissiveIntensity={0.5} />
          </mesh>
        </group>

        {/* Top Radiator Assembly */}
        <group position={[0, 1.8, -0.4]}>
          <mesh castShadow>
            <boxGeometry args={[2.8, 0.15, 0.9]} />
            <meshStandardMaterial color="#1a1a1a" roughness={0.6} metalness={0.8} />
          </mesh>
          {/* 3 Radiator Fans */}
          {[-0.9, 0, 0.9].map((xOffset, idx) => {
            const fRef = idx === 0 ? fanRef1 : idx === 1 ? fanRef2 : fanRef3;
            return (
              <group key={idx} position={[xOffset, -0.09, 0]}>
                <mesh>
                  <boxGeometry args={[0.8, 0.03, 0.8]} />
                  <meshStandardMaterial color="#1c1c1c" roughness={0.6} />
                </mesh>
                <group ref={fRef} position={[0, -0.01, 0]}>
                  {[...Array(7)].map((_, i) => (
                    <mesh key={i} rotation={[0, (i * Math.PI) / 3.5, 0]}>
                      <boxGeometry args={[0.04, 0.01, 0.72]} />
                      <meshStandardMaterial color="#ffffff" transparent opacity={0.6} />
                    </mesh>
                  ))}
                </group>
                <mesh position={[0, -0.021, 0]} rotation={[Math.PI / 2, 0, 0]}>
                  <ringGeometry args={[0.26, 0.32, 32]} />
                  <meshStandardMaterial color={rgbRef.current} emissive={rgbRef.current} emissiveIntensity={1.5} />
                </mesh>
              </group>
            );
          })}
        </group>

        {/* Water Hoses */}
        <group>
          <mesh position={[0.25, 0.5, -0.3]} rotation={[0.4, 0.2, 0.6]}>
            <cylinderGeometry args={[0.04, 0.04, 0.8, 8]} />
            <meshStandardMaterial color="#151515" roughness={0.8} />
          </mesh>
          <mesh position={[0.45, 1.2, -0.35]} rotation={[-0.4, 0.1, 0.3]}>
            <cylinderGeometry args={[0.04, 0.04, 0.9, 8]} />
            <meshStandardMaterial color="#151515" roughness={0.8} />
          </mesh>
          <mesh position={[0.15, 0.6, -0.3]} rotation={[0.3, 0.3, 0.5]}>
            <cylinderGeometry args={[0.04, 0.04, 0.8, 8]} />
            <meshStandardMaterial color="#151515" roughness={0.8} />
          </mesh>
          <mesh position={[0.35, 1.3, -0.35]} rotation={[-0.3, 0.2, 0.2]}>
            <cylinderGeometry args={[0.04, 0.04, 0.9, 8]} />
            <meshStandardMaterial color="#151515" roughness={0.8} />
          </mesh>
        </group>
      </group>
    );
  } else {
    // Air Cooler (Noctua nh-d15 or similar)
    return (
      <group>
        {/* Base Block */}
        <mesh position={[0, 0, -0.15]} castShadow>
          <boxGeometry args={[0.5, 0.5, 0.06]} />
          <meshStandardMaterial color="#c9a84c" roughness={0.2} metalness={0.9} />
        </mesh>
        {/* Heatpipes */}
        {[-0.2, -0.1, 0, 0.1, 0.2].map((xOffset, i) => (
          <group key={i} position={[xOffset, 0, -0.1]}>
            <mesh position={[-0.15, 0.1, 0]} rotation={[0, 0, 0.2]}>
              <cylinderGeometry args={[0.02, 0.02, 0.35, 8]} />
              <meshStandardMaterial color="#c9a84c" roughness={0.2} metalness={0.8} />
            </mesh>
            <mesh position={[0.15, 0.1, 0]} rotation={[0, 0, -0.2]}>
              <cylinderGeometry args={[0.02, 0.02, 0.35, 8]} />
              <meshStandardMaterial color="#c9a84c" roughness={0.2} metalness={0.8} />
            </mesh>
          </group>
        ))}
        {/* Dual cooling fin towers */}
        <group position={[-0.2, 0, 0.05]}>
          {[...Array(16)].map((_, i) => (
            <mesh key={i} position={[0, 0, -0.1 + i * 0.25 / 15]} castShadow>
              <boxGeometry args={[0.32, h - 0.1, 0.008]} />
              <meshStandardMaterial color="#555555" roughness={0.4} metalness={0.8} />
            </mesh>
          ))}
        </group>
        <group position={[0.2, 0, 0.05]}>
          {[...Array(16)].map((_, i) => (
            <mesh key={i} position={[0, 0, -0.1 + i * 0.25 / 15]} castShadow>
              <boxGeometry args={[0.32, h - 0.1, 0.008]} />
              <meshStandardMaterial color="#555555" roughness={0.4} metalness={0.8} />
            </mesh>
          ))}
        </group>
        {/* Center Cooling Fan */}
        <group position={[0, 0, 0.18]}>
          <mesh>
            <boxGeometry args={[w - 0.05, h - 0.05, 0.05]} />
            <meshStandardMaterial color="#2d221c" roughness={0.7} />
          </mesh>
          <group ref={fanRef1} position={[0, 0, 0.015]}>
            <mesh>
              <cylinderGeometry args={[0.15, 0.15, 0.04, 16]} rotation={[Math.PI / 2, 0, 0]} />
              <meshStandardMaterial color="#222" />
            </mesh>
            {[...Array(9)].map((_, i) => (
              <mesh key={i} rotation={[0, 0, (i * Math.PI) / 4.5]}>
                <boxGeometry args={[w - 0.1, 0.07, 0.01]} />
                <meshStandardMaterial color="#54382b" roughness={0.6} /> {/* Noctua style brown */}
              </mesh>
            ))}
          </group>
        </group>
      </group>
    );
  }
}

// --- PSU Component ---
export function PSUComponent({ color, dimensions }) {
  const [w, h, d] = dimensions;
  return (
    <group>
      {/* Matte black chassis */}
      <mesh castShadow receiveShadow>
        <boxGeometry args={[w, h, d]} />
        <meshStandardMaterial color="#171717" roughness={0.8} metalness={0.4} />
      </mesh>
      {/* Badge sticker on side */}
      <mesh position={[w/2 + 0.005, 0, 0]}>
        <boxGeometry args={[0.002, h * 0.6, d * 0.7]} />
        <meshStandardMaterial color={color} roughness={0.3} metalness={0.8} />
      </mesh>
      {/* Fan grill on bottom */}
      <mesh position={[0, -h/2 - 0.005, 0]} rotation={[Math.PI / 2, 0, 0]}>
        <cylinderGeometry args={[d * 0.35, d * 0.35, 0.01, 32]} />
        <meshStandardMaterial color="#0b0b0b" roughness={0.9} />
      </mesh>
      {[0, 1, 2, 3, 4].map((i) => (
        <mesh key={i} position={[0, -h/2 - 0.006, 0]} rotation={[Math.PI / 2, 0, (i * Math.PI) / 5]}>
          <boxGeometry args={[d * 0.68, 0.02, 0.005]} />
          <meshStandardMaterial color="#333" metalness={0.8} />
        </mesh>
      ))}
      {/* Heavy Sleeved Cables out front */}
      <group position={[w * 0.25, 0, d/2]}>
        <mesh position={[0, 0, 0.25]} rotation={[0.5, 0, 0]}>
          <cylinderGeometry args={[0.05, 0.05, 0.5, 8]} />
          <meshStandardMaterial color="#111" roughness={0.9} />
        </mesh>
        <mesh position={[-0.12, -0.08, 0.25]} rotation={[0.4, 0.2, 0.15]}>
          <cylinderGeometry args={[0.04, 0.04, 0.5, 8]} />
          <meshStandardMaterial color="#111" roughness={0.9} />
        </mesh>
        <mesh position={[-0.24, 0.08, 0.25]} rotation={[0.6, -0.2, 0]}>
          <cylinderGeometry args={[0.04, 0.04, 0.5, 8]} />
          <meshStandardMaterial color="#111" roughness={0.9} />
        </mesh>
      </group>
    </group>
  );
}

// --- DETAILED PC CASE CHASSIS ---
export function CaseChassis({ caseData, isPoweredOn, rgbColorMode, explodedFactor }) {
  const [w, h, d] = caseData.size;
  const frameThickness = 0.08;
  const caseColor = caseData.color || '#2a2a2a';

  const rgbRef = useRef(new THREE.Color('#ff0000'));
  const lightRef = useRef();

  useFrame((state) => {
    if (!isPoweredOn) {
      if (lightRef.current) lightRef.current.intensity = 0;
      return;
    }
    const time = state.clock.elapsedTime;
    const activeColor = getRGBColor(rgbColorMode, time);
    rgbRef.current.copy(activeColor);
    if (lightRef.current) {
      lightRef.current.color.copy(rgbRef.current);
      lightRef.current.intensity = 1.5;
    }
  });

  return (
    <group>
      {/* 1. Metal Frame Pillars (12 pieces) */}
      {/* 4 Vertical corner pillars */}
      <mesh position={[-w/2 + frameThickness/2, 0, -d/2 + frameThickness/2]} castShadow receiveShadow>
        <boxGeometry args={[frameThickness, h, frameThickness]} />
        <meshStandardMaterial color={caseColor} roughness={0.4} metalness={0.8} />
      </mesh>
      <mesh position={[w/2 - frameThickness/2, 0, -d/2 + frameThickness/2]} castShadow receiveShadow>
        <boxGeometry args={[frameThickness, h, frameThickness]} />
        <meshStandardMaterial color={caseColor} roughness={0.4} metalness={0.8} />
      </mesh>
      <mesh position={[-w/2 + frameThickness/2, 0, d/2 - frameThickness/2]} castShadow receiveShadow>
        <boxGeometry args={[frameThickness, h, frameThickness]} />
        <meshStandardMaterial color={caseColor} roughness={0.4} metalness={0.8} />
      </mesh>
      <mesh position={[w/2 - frameThickness/2, 0, d/2 - frameThickness/2]} castShadow receiveShadow>
        <boxGeometry args={[frameThickness, h, frameThickness]} />
        <meshStandardMaterial color={caseColor} roughness={0.4} metalness={0.8} />
      </mesh>

      {/* 4 Horizontal width pillars (along X) */}
      <mesh position={[0, -h/2 + frameThickness/2, -d/2 + frameThickness/2]} castShadow receiveShadow>
        <boxGeometry args={[w - frameThickness * 2, frameThickness, frameThickness]} />
        <meshStandardMaterial color={caseColor} roughness={0.4} metalness={0.8} />
      </mesh>
      <mesh position={[0, h/2 - frameThickness/2, -d/2 + frameThickness/2]} castShadow receiveShadow>
        <boxGeometry args={[w - frameThickness * 2, frameThickness, frameThickness]} />
        <meshStandardMaterial color={caseColor} roughness={0.4} metalness={0.8} />
      </mesh>
      <mesh position={[0, -h/2 + frameThickness/2, d/2 - frameThickness/2]} castShadow receiveShadow>
        <boxGeometry args={[w - frameThickness * 2, frameThickness, frameThickness]} />
        <meshStandardMaterial color={caseColor} roughness={0.4} metalness={0.8} />
      </mesh>
      <mesh position={[0, h/2 - frameThickness/2, d/2 - frameThickness/2]} castShadow receiveShadow>
        <boxGeometry args={[w - frameThickness * 2, frameThickness, frameThickness]} />
        <meshStandardMaterial color={caseColor} roughness={0.4} metalness={0.8} />
      </mesh>

      {/* 4 Horizontal depth pillars (along Z) */}
      <mesh position={[-w/2 + frameThickness/2, -h/2 + frameThickness/2, 0]} castShadow receiveShadow>
        <boxGeometry args={[frameThickness, frameThickness, d - frameThickness * 2]} />
        <meshStandardMaterial color={caseColor} roughness={0.4} metalness={0.8} />
      </mesh>
      <mesh position={[w/2 - frameThickness/2, -h/2 + frameThickness/2, 0]} castShadow receiveShadow>
        <boxGeometry args={[frameThickness, frameThickness, d - frameThickness * 2]} />
        <meshStandardMaterial color={caseColor} roughness={0.4} metalness={0.8} />
      </mesh>
      <mesh position={[-w/2 + frameThickness/2, h/2 - frameThickness/2, 0]} castShadow receiveShadow>
        <boxGeometry args={[frameThickness, frameThickness, d - frameThickness * 2]} />
        <meshStandardMaterial color={caseColor} roughness={0.4} metalness={0.8} />
      </mesh>
      <mesh position={[w/2 - frameThickness/2, h/2 - frameThickness/2, 0]} castShadow receiveShadow>
        <boxGeometry args={[frameThickness, frameThickness, d - frameThickness * 2]} />
        <meshStandardMaterial color={caseColor} roughness={0.4} metalness={0.8} />
      </mesh>

      {/* 2. Panels */}
      {/* Bottom Panel (Floor) */}
      <mesh position={[0, -h/2 + 0.02, 0]} receiveShadow>
        <boxGeometry args={[w - 0.02, 0.04, d - 0.02]} />
        <meshStandardMaterial color="#141414" roughness={0.8} metalness={0.4} />
      </mesh>

      {/* Top Panel (Ceiling with mesh pattern) */}
      <mesh position={[0, h/2 - 0.02, 0]} castShadow>
        <boxGeometry args={[w - 0.02, 0.04, d - 0.02]} />
        <meshStandardMaterial color="#1a1a1a" roughness={0.7} metalness={0.5} />
      </mesh>

      {/* Back Solid Wall */}
      <mesh position={[0, 0, -d/2 + 0.02]} castShadow receiveShadow>
        <boxGeometry args={[w - 0.02, h - 0.02, 0.04]} />
        <meshStandardMaterial color={caseColor} roughness={0.5} metalness={0.7} />
      </mesh>

      {/* Right Solid Side Wall */}
      <mesh position={[-w/2 + 0.02, 0, 0]} castShadow receiveShadow>
        <boxGeometry args={[0.04, h - 0.02, d - 0.02]} />
        <meshStandardMaterial color={caseColor} roughness={0.5} metalness={0.7} />
      </mesh>

      {/* Left Tempered Glass Panel - slides out on explode */}
      <mesh position={[w/2 - 0.01 + explodedFactor * 1.5, 0, 0]}>
        <boxGeometry args={[0.02, h - 0.1, d - 0.1]} />
        <meshPhysicalMaterial
          transmission={0.9}
          roughness={0.05}
          metalness={0.1}
          transparent
          opacity={0.25}
          ior={1.5}
          thickness={0.04}
          side={THREE.DoubleSide}
        />
      </mesh>

      {/* Front Tempered Glass Panel - slides out on explode */}
      <mesh position={[0, 0, d/2 - 0.01 + explodedFactor * 1.5]}>
        <boxGeometry args={[w - 0.1, h - 0.1, 0.02]} />
        <meshPhysicalMaterial
          transmission={0.9}
          roughness={0.05}
          metalness={0.1}
          transparent
          opacity={0.2}
          ior={1.5}
          thickness={0.04}
          side={THREE.DoubleSide}
        />
      </mesh>

      {/* 3. Case Feet (4 pieces) */}
      <mesh position={[-w/2 + 0.4, -h/2 - 0.1, -d/2 + 0.4]} castShadow>
        <cylinderGeometry args={[0.15, 0.15, 0.2, 16]} />
        <meshStandardMaterial color="#111" roughness={0.9} metalness={0.1} />
      </mesh>
      <mesh position={[w/2 - 0.4, -h/2 - 0.1, -d/2 + 0.4]} castShadow>
        <cylinderGeometry args={[0.15, 0.15, 0.2, 16]} />
        <meshStandardMaterial color="#111" roughness={0.9} metalness={0.1} />
      </mesh>
      <mesh position={[-w/2 + 0.4, -h/2 - 0.1, d/2 - 0.4]} castShadow>
        <cylinderGeometry args={[0.15, 0.15, 0.2, 16]} />
        <meshStandardMaterial color="#111" roughness={0.9} metalness={0.1} />
      </mesh>
      <mesh position={[w/2 - 0.4, -h/2 - 0.1, d/2 - 0.4]} castShadow>
        <cylinderGeometry args={[0.15, 0.15, 0.2, 16]} />
        <meshStandardMaterial color="#111" roughness={0.9} metalness={0.1} />
      </mesh>

      {/* 4. Internal LED Strip */}
      <mesh position={[0, h/2 - 0.15, d/2 - 0.15]}>
        <boxGeometry args={[w - 0.4, 0.03, 0.03]} />
        <meshStandardMaterial 
          emissive={isPoweredOn ? rgbRef.current : '#000000'} 
          emissiveIntensity={isPoweredOn ? 2 : 0} 
          color="#fff" 
        />
      </mesh>
      {isPoweredOn && <pointLight ref={lightRef} position={[0, h/2 - 0.3, 0]} intensity={1.5} distance={6} decay={1.5} castShadow />}
    </group>
  );
}

// --- DETAILED MOTHERBOARD ---
export function Motherboard({ mainboardData }) {
  const [w, h, d] = mainboardData.size;
  const boardColor = mainboardData.color || '#1c1e24';
  
  return (
    <group position={[-0.2, 0.2, -0.6]}>
      {/* Main PCB Board */}
      <mesh castShadow receiveShadow>
        <boxGeometry args={[w, h, d]} />
        <meshStandardMaterial color={boardColor} roughness={0.7} metalness={0.3} />
      </mesh>

      {/* CPU Socket Bracket */}
      <mesh position={[-0.2, 0.5, 0.09]}>
        <boxGeometry args={[0.7, 0.7, 0.03]} />
        <meshStandardMaterial color="#333333" roughness={0.5} metalness={0.8} />
      </mesh>
      <mesh position={[-0.2, 0.5, 0.11]}>
        <boxGeometry args={[0.5, 0.5, 0.01]} />
        <meshStandardMaterial color="#888888" roughness={0.3} metalness={0.9} />
      </mesh>

      {/* VRM Heatsinks */}
      <mesh position={[-0.2, 1.0, 0.15]} castShadow>
        <boxGeometry args={[0.9, 0.2, 0.15]} />
        <meshStandardMaterial color="#111111" roughness={0.3} metalness={0.9} />
      </mesh>
      <mesh position={[-0.7, 0.5, 0.15]} castShadow>
        <boxGeometry args={[0.2, 0.8, 0.15]} />
        <meshStandardMaterial color="#111111" roughness={0.3} metalness={0.9} />
      </mesh>

      {/* RAM Slots (4 slots) */}
      {[0, 1, 2, 3].map((i) => (
        <mesh key={i} position={[0.3 + i * 0.08, 0.5, 0.09]}>
          <boxGeometry args={[0.03, 1.3, 0.08]} />
          <meshStandardMaterial color={i % 2 === 0 ? '#111' : '#222'} roughness={0.6} />
        </mesh>
      ))}

      {/* PCIe Slots */}
      <mesh position={[0.1, -0.3, 0.09]} castShadow>
        <boxGeometry args={[1.6, 0.06, 0.08]} />
        <meshStandardMaterial color="#151515" roughness={0.5} metalness={0.8} />
      </mesh>
      <mesh position={[0.1, -0.3, 0.13]}>
        <boxGeometry args={[1.5, 0.02, 0.01]} />
        <meshStandardMaterial color="#c9a84c" />
      </mesh>

      <mesh position={[0.1, -0.9, 0.09]}>
        <boxGeometry args={[1.6, 0.06, 0.08]} />
        <meshStandardMaterial color="#111" roughness={0.6} />
      </mesh>

      {/* M.2 Heatsink Shield */}
      <mesh position={[0.1, -0.6, 0.11]} castShadow>
        <boxGeometry args={[1.2, 0.15, 0.06]} />
        <meshStandardMaterial color="#222" roughness={0.3} metalness={0.8} />
      </mesh>

      {/* Chipset Heatsink */}
      <mesh position={[0.7, -0.8, 0.12]} castShadow>
        <boxGeometry args={[0.6, 0.6, 0.1]} />
        <meshStandardMaterial color="#1e1e1e" roughness={0.3} metalness={0.9} />
      </mesh>
      <mesh position={[0.7, -0.8, 0.175]}>
        <boxGeometry args={[0.5, 0.3, 0.01]} />
        <meshStandardMaterial color="#c9a84c" roughness={0.1} metalness={0.9} />
      </mesh>
    </group>
  );
}

// --- 3D ANIMATED COMPONENT MESH ---
export function AnimatedMesh({ isInstalled, targetPos, dimensions, color, label, shape = 'box', selectedItem, onClick, isPoweredOn, rgbColorMode, explodedFactor }) {
  const meshRef = useRef();
  const currentPos = useRef(new THREE.Vector3(0, 10, 5));

  useFrame((state) => {
    if (isInstalled) {
      let offset = [0, 0, 0];
      if (explodedFactor > 0) {
        if (label === 'CPU') offset = [0, 0, explodedFactor * 0.7];
        else if (label === 'COOLER') offset = [0, 0, explodedFactor * 1.6];
        else if (label === 'RAM') offset = [explodedFactor * -0.5, 0, 0];
        else if (label === 'GPU') offset = [0, explodedFactor * -0.6, explodedFactor * 0.7];
        else if (label === 'PSU') offset = [0, explodedFactor * -0.7, 0];
        else if (label === 'MONITOR') offset = [0, 0, explodedFactor * -1.2];
        else if (label === 'KEYBOARD') offset = [0, 0, explodedFactor * 1.0];
        else if (label === 'MOUSE') offset = [explodedFactor * 0.6, 0, explodedFactor * 1.0];
      }
      const dest = new THREE.Vector3(targetPos[0] + offset[0], targetPos[1] + offset[1], targetPos[2] + offset[2]);
      currentPos.current.lerp(dest, 0.08);
    } else {
      currentPos.current.set(0, 10, 5);
    }
    if (meshRef.current) {
      meshRef.current.position.copy(currentPos.current);
    }
  });

  if (!isInstalled) return null;
  return (
    <group 
      ref={meshRef}
      onClick={(e) => {
        e.stopPropagation();
        if (onClick) onClick();
      }}
    >
      {label === 'CPU' ? (
        <CPUComponent color={color} />
      ) : label === 'COOLER' ? (
        <CoolerComponent coolerData={selectedItem} dimensions={dimensions} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} />
      ) : label === 'RAM' ? (
        <RAMComponent color={color} dimensions={dimensions} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} />
      ) : label === 'GPU' ? (
        <GPUComponent color={color} dimensions={dimensions} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} />
      ) : label === 'PSU' ? (
        <PSUComponent color={color} dimensions={dimensions} />
      ) : label === 'MONITOR' ? (
        <MonitorComponent color={color} dimensions={dimensions} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} />
      ) : label === 'KEYBOARD' ? (
        <KeyboardComponent color={color} dimensions={dimensions} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} />
      ) : label === 'MOUSE' ? (
        <MouseComponent color={color} dimensions={dimensions} isPoweredOn={isPoweredOn} rgbColorMode={rgbColorMode} />
      ) : shape === 'box' ? (
        <mesh castShadow receiveShadow>
          <boxGeometry args={dimensions} />
          <meshStandardMaterial color={color} roughness={0.2} metalness={0.8} />
        </mesh>
      ) : shape === 'cylinder' ? (
        <mesh castShadow rotation={[Math.PI / 2, 0, 0]}>
          <cylinderGeometry args={[dimensions[0], dimensions[1], dimensions[2], 32]} />
          <meshStandardMaterial color={color} roughness={0.4} metalness={0.6} />
        </mesh>
      ) : null}
      {(label === 'GPU' || label === 'COOLER' || label === 'RAM') && isPoweredOn && (
        <pointLight color={getRGBColor(rgbColorMode, 0)} intensity={0.6} distance={2} />
      )}
    </group>
  );
}
