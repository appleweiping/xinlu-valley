import { useEffect, useRef, useState } from "react";
import { bus } from "@/shared/bus";
import { touchState, isTouchDevice } from "@/shared/touch";
import { useUI } from "./store";

const BASE = 112; // joystick base diameter (px)
const KNOB = 48;
const RANGE = (BASE - KNOB) / 2; // knob travel radius
const DEADZONE = 0.22;

/** Virtual joystick + action buttons for touch devices.
 * The stick writes the shared touchState vector that every Phaser scene
 * merges with the keyboard; the buttons reuse the same bus events as keys. */
export function TouchControls() {
  const { lang, setAlmanac } = useUI();
  const [show] = useState(isTouchDevice);
  const [knob, setKnob] = useState({ x: 0, y: 0 });
  const baseRef = useRef<HTMLDivElement>(null);
  const pointerId = useRef<number | null>(null);

  useEffect(() => {
    if (!show) return;
    return () => {
      touchState.vx = 0;
      touchState.vy = 0;
      touchState.active = false;
    };
  }, [show]);

  if (!show) return null;

  const updateFromPointer = (e: React.PointerEvent) => {
    const el = baseRef.current;
    if (!el) return;
    const r = el.getBoundingClientRect();
    let dx = e.clientX - (r.left + r.width / 2);
    let dy = e.clientY - (r.top + r.height / 2);
    const mag = Math.hypot(dx, dy);
    if (mag > RANGE) {
      dx = (dx / mag) * RANGE;
      dy = (dy / mag) * RANGE;
    }
    setKnob({ x: dx, y: dy });
    const nx = dx / RANGE;
    const ny = dy / RANGE;
    const n = Math.hypot(nx, ny);
    touchState.active = true;
    touchState.vx = n < DEADZONE ? 0 : nx;
    touchState.vy = n < DEADZONE ? 0 : ny;
  };

  const release = () => {
    pointerId.current = null;
    setKnob({ x: 0, y: 0 });
    touchState.vx = 0;
    touchState.vy = 0;
    touchState.active = false;
  };

  const btn: React.CSSProperties = {
    width: 64, height: 64, borderRadius: "50%", border: "3px solid var(--wood-dark)",
    background: "rgba(244,225,193,0.88)", color: "var(--wood-dark)",
    fontSize: 22, fontWeight: 800, fontFamily: "inherit",
    display: "flex", alignItems: "center", justifyContent: "center",
    boxShadow: "0 3px 0 rgba(60,40,20,0.45)", userSelect: "none", touchAction: "none",
  };

  return (
    <>
      {/* joystick — bottom left */}
      <div
        ref={baseRef}
        onPointerDown={(e) => {
          pointerId.current = e.pointerId;
          (e.target as HTMLElement).setPointerCapture?.(e.pointerId);
          updateFromPointer(e);
        }}
        onPointerMove={(e) => {
          if (pointerId.current === e.pointerId) updateFromPointer(e);
        }}
        onPointerUp={release}
        onPointerCancel={release}
        style={{
          position: "absolute", left: 18, bottom: 20, width: BASE, height: BASE,
          borderRadius: "50%", border: "3px solid rgba(110,80,48,0.65)",
          background: "rgba(40,30,22,0.35)", pointerEvents: "auto", touchAction: "none",
          zIndex: 40,
        }}
      >
        <div
          style={{
            position: "absolute", left: "50%", top: "50%", width: KNOB, height: KNOB,
            borderRadius: "50%", background: "rgba(244,225,193,0.92)",
            border: "3px solid var(--wood-dark)", boxSizing: "border-box",
            transform: `translate(calc(-50% + ${knob.x}px), calc(-50% + ${knob.y}px))`,
            boxShadow: "0 2px 0 rgba(60,40,20,0.4)",
          }}
        />
      </div>

      {/* action buttons — bottom right */}
      <div style={{ position: "absolute", right: 18, bottom: 20, display: "flex", gap: 14, alignItems: "flex-end", pointerEvents: "auto", zIndex: 40 }}>
        <button
          style={{ ...btn, width: 48, height: 48, fontSize: 18 }}
          aria-label={lang === "zh" ? "图鉴" : "Almanac"}
          onPointerDown={(e) => e.stopPropagation()}
          onClick={() => setAlmanac(true)}
        >
          📖
        </button>
        <button
          style={btn}
          aria-label={lang === "zh" ? "互动" : "Interact"}
          onPointerDown={(e) => e.stopPropagation()}
          onClick={() => bus.emit("touch:interact", undefined)}
        >
          E
        </button>
      </div>
    </>
  );
}
