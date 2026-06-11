import { useEffect, useMemo, useRef, useState } from "react";
import { AGENTS } from "@/data/town";
import { bus } from "@/shared/bus";
import { useUI } from "./store";

/** Stardew-style bottom dialogue: portrait + wooden frame + typewriter text. */
export function DialogueBox() {
  const { dialogueAgent, closeDialogue, lang } = useUI();
  const agent = useMemo(() => AGENTS.find((a) => a.id === dialogueAgent) ?? null, [dialogueAgent]);
  const [lineIdx, setLineIdx] = useState(0);
  const [shown, setShown] = useState(0);
  const timer = useRef<number | null>(null);

  const line = agent ? agent.lines[lineIdx % agent.lines.length][lang] : "";

  useEffect(() => {
    setLineIdx(0);
  }, [dialogueAgent]);

  useEffect(() => {
    setShown(0);
    if (!agent) return;
    timer.current = window.setInterval(() => {
      setShown((s) => {
        if (s >= line.length) {
          if (timer.current) window.clearInterval(timer.current);
          return s;
        }
        return s + 1;
      });
    }, 28);
    return () => {
      if (timer.current) window.clearInterval(timer.current);
    };
  }, [agent, line]);

  if (!agent) return null;

  const done = shown >= line.length;
  const advance = () => {
    if (!done) {
      setShown(line.length);
    } else if (lineIdx + 1 < agent.lines.length) {
      setLineIdx(lineIdx + 1);
    } else {
      closeDialogue();
      bus.emit("dialogue:closed", undefined);
    }
  };

  return (
    <div
      className="fade-in"
      style={{
        position: "absolute",
        left: "50%",
        bottom: 24,
        transform: "translateX(-50%)",
        width: "min(720px, 92vw)",
        pointerEvents: "auto",
        cursor: "pointer",
      }}
      onClick={advance}
    >
      <div className="wood-panel" style={{ display: "flex", gap: 14, padding: 14, alignItems: "flex-start" }}>
        <div
          style={{
            width: 84,
            height: 84,
            flex: "0 0 auto",
            background: "var(--paper-dark)",
            border: "3px solid var(--wood)",
            borderRadius: 6,
            overflow: "hidden",
            position: "relative",
          }}
        >
          <img
            src={`/assets/core/characters/${agent.id}.png`}
            alt={agent.nameZh}
            style={{
              position: "absolute",
              width: 672,
              height: 672,
              left: -42,
              top: -76,
              imageRendering: "pixelated",
            }}
          />
        </div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline" }}>
            <strong style={{ fontSize: 16, color: "var(--wood-dark)" }}>
              {lang === "zh" ? agent.nameZh : agent.nameEn}
              <span className="pixel-chip" style={{ marginLeft: 8, color: agent.color, borderColor: agent.color }}>
                {lang === "zh" ? agent.roleZh : agent.role}
              </span>
            </strong>
            <span style={{ fontSize: 11, opacity: 0.65 }}>
              {lineIdx + 1}/{agent.lines.length}
            </span>
          </div>
          <p className={done ? "" : "typewriter-cursor"} style={{ margin: "8px 0 0", fontSize: 15, lineHeight: 1.7, minHeight: 48 }}>
            {line.slice(0, shown)}
          </p>
          <div style={{ textAlign: "right", fontSize: 11, opacity: 0.6 }}>
            {done ? (lang === "zh" ? "点击继续 ▾" : "click to continue ▾") : ""}
          </div>
        </div>
      </div>
    </div>
  );
}
