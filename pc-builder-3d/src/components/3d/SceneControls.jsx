import React, { useEffect, useRef } from 'react';
import { useFrame, useThree } from '@react-three/fiber';
import { Html } from '@react-three/drei';
import * as THREE from 'three';

// --- 3D CAMERA CONTROLLER ---
export function CameraController({ preset }) {
  const { camera, controls } = useThree();
  const targetPos = useRef(new THREE.Vector3(0, 1.2, 8.2));
  const lookAtTarget = useRef(new THREE.Vector3(0, -0.95, 0));

  useEffect(() => {
    if (preset === 'front') {
      targetPos.current.set(0, 1.25, 8.2);
      lookAtTarget.current.set(0, -0.95, 0);
    } else if (preset === 'side') {
      targetPos.current.set(7.2, 2.35, 6.4);
      lookAtTarget.current.set(0.65, -0.65, 0);
    } else if (preset === 'mainboard') {
      targetPos.current.set(2.55, 0.8, 5.1);
      lookAtTarget.current.set(2.15, 0.25, -0.45);
    }
  }, [preset]);

  useFrame(() => {
    camera.position.lerp(targetPos.current, 0.08);
    if (controls?.target) {
      controls.target.lerp(lookAtTarget.current, 0.08);
      controls.update();
    } else {
      camera.lookAt(lookAtTarget.current);
    }
  });
  return null;
}

// --- HUD CALLOUT ANNOTATION LINE & DETAILS ---
export function AnnotationCallout({ startPos, endPos, label, item }) {
  const points = [new THREE.Vector3(...startPos), new THREE.Vector3(...endPos)];
  const lineGeometry = new THREE.BufferGeometry().setFromPoints(points);

  return (
    <group>
      {/* Leader line */}
      <line geometry={lineGeometry}>
        <lineBasicMaterial color="#c9a84c" linewidth={2} transparent opacity={0.8} />
      </line>

      {/* Anchor dot */}
      <mesh position={startPos}>
        <sphereGeometry args={[0.06, 16, 16]} />
        <meshBasicMaterial color="#c9a84c" />
      </mesh>

      {/* Floating HTML card */}
      <Html position={endPos} distanceFactor={8} center style={{ pointerEvents: 'none' }}>
        <div className="hud-callout-card">
          <div className="hud-callout-header">{label}</div>
          <div className="hud-callout-title">{item.name}</div>
          <div className="hud-callout-price">{item.price.toLocaleString('vi-VN')}₫</div>
          <div className="hud-callout-spec">{item.spec}</div>
        </div>
      </Html>
    </group>
  );
}
