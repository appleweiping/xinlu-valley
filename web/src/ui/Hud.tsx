import { useState } from "react";
import { audio } from "@/game/audio";
import { SPECTATE } from "@/shared/flags";
import { isTouchDevice } from "@/shared/touch";
import { useUI } from "./store";

export function Hud() {
  const { clock, live, lang, setLang, setAlmanac, setAlmanacTab, stamina } = useUI();
  const [muted, setMuted] = useState(audio.muted);
  const toggleMute = () => {
    const m = !muted;
    setMuted(m);
    audio.setMuted(m);
  };
  const hh = String(clock.hour).padStart(2, "0");
  const mm = String(Math.floor(clock.minute / 10) * 10).padStart(2, "0");
  return (
    <>
      <div
        className="wood-panel"
        style={{ position: "absolute", top: 12, right: 12, padding: "8px 14px", pointerEvents: "auto", textAlign: "center" }}
      >
        <div style={{ fontSize: 14, fontWeight: 700 }}>
          {clock.weather === "rain" ? "🌧 " : clock.weather === "fog" ? "🌫 " : "☀ "}
          {lang === "zh" ? `${clock.season} · 第 ${clock.day} 天` : `${clock.season} · Day ${clock.day}`}
        </div>
        <div style={{ fontSize: 20, fontWeight: 800, color: "var(--wood-dark)" }}>
          {hh}:{mm}
        </div>
        <div style={{ marginTop: 4 }}>
          <span
            className="pixel-chip"
            style={{ background: live ? "#d3f0c2" : "#f0e3c2", borderColor: live ? "#5cb83a" : "var(--wood)" }}
            title={live ? "已连接本地数据桥 (localhost:8000)" : "公开演示数据"}
          >
            {live ? (lang === "zh" ? "● 联机" : "● LIVE") : lang === "zh" ? "○ 演示" : "○ DEMO"}
          </span>
          {SPECTATE && (
            <span className="pixel-chip" style={{ background: "#e3d6f0", borderColor: "#8a6fb0" }}
              title={lang === "zh" ? "只读观战链接" : "read-only spectate link"}>
              👀 {lang === "zh" ? "观战" : "WATCH"}
            </span>
          )}
          <button className="wood-btn" style={{ fontSize: 11, padding: "1px 8px" }} onClick={() => setLang(lang === "zh" ? "en" : "zh")}>
            {lang === "zh" ? "EN" : "中"}
          </button>
          <button className="wood-btn" style={{ fontSize: 11, padding: "1px 8px" }} onClick={toggleMute}
            title={muted ? "开启声音" : "静音"}>
            {muted ? "🔇" : "🔊"}
          </button>
          <button className="wood-btn" style={{ fontSize: 11, padding: "1px 8px" }}
            onClick={() => { setAlmanacTab("ach"); setAlmanac(true); }} title="山谷手册">
            📖
          </button>
          <button className="wood-btn" style={{ fontSize: 11, padding: "1px 8px" }}
            onClick={() => { setAlmanacTab("bag"); setAlmanac(true); }} title="背包">
            🎒
          </button>
        </div>
        <div style={{ marginTop: 6 }} title={`体力 ${stamina}/100`}>
          <div style={{ height: 7, background: "var(--paper-dark)", border: "2px solid var(--wood)", borderRadius: 3, overflow: "hidden" }}>
            <div style={{
              width: `${stamina}%`, height: "100%",
              background: stamina > 35 ? "linear-gradient(180deg,#9be564,#5cb83a)" : "linear-gradient(180deg,#f0b860,#d88a3a)",
              transition: "width 0.3s",
            }} />
          </div>
        </div>
      </div>
      {!isTouchDevice() && (
        <div
          className="wood-panel"
          style={{ position: "absolute", bottom: 12, left: 12, padding: "6px 12px", fontSize: 12, pointerEvents: "auto", maxWidth: 280 }}
        >
          {useUI.getState().lang === "zh"
            ? "WASD/方向键移动 · 点击地面行走 · 拖拽平移 · 滚轮缩放 · E 互动 · F 回到角色"
            : "WASD/arrows move · click to walk · drag to pan · wheel to zoom · E interact · F refocus"}
        </div>
      )}
    </>
  );
}
