import React, { useRef } from 'react';
import { useFrame } from '@react-three/fiber';
import * as THREE from 'three';
import { getRGBColor } from '../../data/constants';

// --- DETAILED MONITOR COMPONENT ---
export function MonitorComponent({ color, dimensions, isPoweredOn, rgbColorMode }) {
  const [w, h, d] = dimensions;
  const rgbRef = useRef(new THREE.Color('#ff0000'));
  const backLightRef = useRef();

  useFrame((state) => {
    if (!isPoweredOn) {
      if (backLightRef.current) backLightRef.current.color.setHex(0x000000);
      return;
    }
    const time = state.clock.elapsedTime;
    const activeColor = getRGBColor(rgbColorMode, time);
    rgbRef.current.copy(activeColor);
    if (backLightRef.current) {
      backLightRef.current.color.copy(rgbRef.current);
    }
  });

  return (
    <group>
      {/* Stand Base */}
      <mesh position={[0, -1.8, 0]} castShadow>
        <boxGeometry args={[1.5, 0.04, 0.8]} />
        <meshStandardMaterial color="#1f1f1f" roughness={0.5} metalness={0.7} />
      </mesh>
      {/* Stand Column */}
      <mesh position={[0, -0.9, -0.2]} castShadow>
        <cylinderGeometry args={[0.08, 0.1, 1.8, 16]} />
        <meshStandardMaterial color="#1a1a1a" roughness={0.4} metalness={0.8} />
      </mesh>
      
      {/* Curved Ultrawide Bezel Frame */}
      {/* Middle Bezel */}
      <group position={[0, 0, 0]}>
        <mesh castShadow receiveShadow>
          <boxGeometry args={[w * 0.5, h, d]} />
          <meshStandardMaterial color="#121212" roughness={0.3} metalness={0.8} />
        </mesh>
        {/* Glow Wallpaper Screen */}
        <mesh position={[0, 0, d/2 + 0.005]}>
          <boxGeometry args={[w * 0.49, h - 0.1, 0.005]} />
          <meshStandardMaterial 
            color={isPoweredOn ? "#1a0033" : "#020202"} 
            emissive={isPoweredOn ? "#330066" : "#000000"} 
            emissiveIntensity={isPoweredOn ? 0.6 : 0} 
            roughness={0.1} 
          />
        </mesh>
        {isPoweredOn && <gridHelper args={[w * 0.49, 10, '#c9a84c', '#5522aa']} position={[0, 0, d/2 + 0.01]} rotation={[Math.PI / 2, 0, 0]} />}
      </group>

      {/* Left Bezel Wing */}
      <group position={[-w * 0.25, 0, 0.1]} rotation={[0, 0.15, 0]}>
        <mesh castShadow receiveShadow>
          <boxGeometry args={[w * 0.26, h, d]} />
          <meshStandardMaterial color="#121212" roughness={0.3} metalness={0.8} />
        </mesh>
        <mesh position={[0, 0, d/2 + 0.005]}>
          <boxGeometry args={[w * 0.25, h - 0.1, 0.005]} />
          <meshStandardMaterial 
            color={isPoweredOn ? "#1a0033" : "#020202"} 
            emissive={isPoweredOn ? "#330066" : "#000000"} 
            emissiveIntensity={isPoweredOn ? 0.6 : 0} 
            roughness={0.1} 
          />
        </mesh>
      </group>

      {/* Right Bezel Wing */}
      <group position={[w * 0.25, 0, 0.1]} rotation={[0, -0.15, 0]}>
        <mesh castShadow receiveShadow>
          <boxGeometry args={[w * 0.26, h, d]} />
          <meshStandardMaterial color="#121212" roughness={0.3} metalness={0.8} />
        </mesh>
        <mesh position={[0, 0, d/2 + 0.005]}>
          <boxGeometry args={[w * 0.25, h - 0.1, 0.005]} />
          <meshStandardMaterial 
            color={isPoweredOn ? "#1a0033" : "#020202"} 
            emissive={isPoweredOn ? "#330066" : "#000000"} 
            emissiveIntensity={isPoweredOn ? 0.6 : 0} 
            roughness={0.1} 
          />
        </mesh>
      </group>

      {/* Ambient Wall Light */}
      {isPoweredOn && <pointLight ref={backLightRef} position={[0, 0, -1.0]} intensity={2.5} distance={5} decay={2.0} />}
    </group>
  );
}

// --- DETAILED KEYBOARD COMPONENT ---
export function KeyboardComponent({ color, dimensions, isPoweredOn, rgbColorMode }) {
  const [w, h, d] = dimensions;
  const rgbRef = useRef(new THREE.Color('#ff0000'));
  const ledRef = useRef();

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
  });

  return (
    <group>
      {/* Board Base */}
      <mesh castShadow receiveShadow>
        <boxGeometry args={[w, h, d]} />
        <meshStandardMaterial color={color} roughness={0.6} metalness={0.7} />
      </mesh>
      
      {/* Keycap Recess */}
      <mesh position={[0, h/2 + 0.005, 0]}>
        <boxGeometry args={[w - 0.06, 0.01, d - 0.06]} />
        <meshStandardMaterial color="#1c1c1c" roughness={0.9} />
      </mesh>

      {/* Keycap grid representation */}
      {[-0.5, -0.3, -0.1, 0.1, 0.3, 0.5].map((xOffset) => (
        <group key={xOffset} position={[w * xOffset * 0.9, h/2 + 0.02, 0]}>
          {[-0.35, 0, 0.35].map((zOffset) => (
            <mesh key={zOffset} position={[0, 0, d * zOffset * 0.8]} castShadow>
              <boxGeometry args={[w * 0.12, 0.03, d * 0.2]} />
              <meshStandardMaterial color="#2d2d2d" roughness={0.7} />
            </mesh>
          ))}
        </group>
      ))}

      {/* RGB Underglow */}
      <mesh position={[0, -h/2 + 0.01, 0]}>
        <boxGeometry args={[w + 0.02, 0.015, d + 0.02]} />
        <meshStandardMaterial ref={ledRef} color="#fff" emissive={rgbRef.current} emissiveIntensity={2.0} />
      </mesh>
    </group>
  );
}

// --- DETAILED MOUSE COMPONENT ---
export function MouseComponent({ color, dimensions, isPoweredOn, rgbColorMode }) {
  const [w, h, d] = dimensions;
  const rgbRef = useRef(new THREE.Color('#ff0000'));
  const ledRef1 = useRef();
  const ledRef2 = useRef();

  useFrame((state) => {
    if (!isPoweredOn) {
      if (ledRef1.current) ledRef1.current.emissive.setHex(0x000000);
      if (ledRef2.current) ledRef2.current.emissive.setHex(0x000000);
      return;
    }
    const time = state.clock.elapsedTime;
    const activeColor = getRGBColor(rgbColorMode, time);
    rgbRef.current.copy(activeColor);
    if (ledRef1.current) ledRef1.current.emissive.copy(rgbRef.current);
    if (ledRef2.current) ledRef2.current.emissive.copy(rgbRef.current);
  });

  return (
    <group>
      {/* Mouse Body */}
      <mesh castShadow receiveShadow>
        <boxGeometry args={[w, h, d]} />
        <meshStandardMaterial color={color} roughness={0.4} metalness={0.5} />
      </mesh>
      
      {/* Button click seam */}
      <mesh position={[0, h/2 - 0.01, d * 0.2]}>
        <boxGeometry args={[0.01, 0.02, d * 0.4]} />
        <meshStandardMaterial color="#0b0b0b" />
      </mesh>

      {/* Scroll Wheel */}
      <mesh position={[0, h/2 + 0.01, d * 0.22]} rotation={[Math.PI / 2, 0, 0]}>
        <cylinderGeometry args={[0.04, 0.04, 0.02, 12]} />
        <meshStandardMaterial ref={ledRef1} color="#fff" emissive={rgbRef.current} emissiveIntensity={1.5} />
      </mesh>

      {/* Side LED strip */}
      <mesh position={[w/2 - 0.005, 0, -d * 0.1]}>
        <boxGeometry args={[0.01, h * 0.3, d * 0.5]} />
        <meshStandardMaterial ref={ledRef2} color="#fff" emissive={rgbRef.current} emissiveIntensity={2.0} />
      </mesh>
    </group>
  );
}
