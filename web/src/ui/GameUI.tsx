import { useEffect, useRef, useState } from "react";
import { bus } from "@/shared/bus";
import { BUILDINGS } from "@/data/town";
import { audio } from "@/game/audio";
import { useUI } from "./store";
import { DialogueBox } from "./DialogueBox";
import { BuildingPanel } from "./BuildingPanel";
import { Hud } from "./Hud";
import "./pixel.css";

function PlantDialog() {
  const { plantCell, setPlantCell, lang } = useUI();
  const [title, setTitle] = useState("");
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (plantCell !== null) {
      setTitle("");
      setTimeout(() => inputRef.current?.focus(), 50);
    }
  }, [plantCell]);

  if (plantCell === null) return null;

  const cancel = () => {
    setPlantCell(null);
    bus.emit("panel:closed", undefined); // unlock the scene
  };
  const confirm = () => {
    const t = title.trim();
    setPlantCell(null);
    if (t) {
      bus.emit("farm:plant-confirm", { cell: plantCell, title: t });
    } else {
      bus.emit("panel:closed", undefined);
    }
  };

  return (
    <div
      className="fade-in"
      style={{
        position: "absolute", inset: 0, background: "rgba(20,14,28,0.45)",
        display: "flex", alignItems: "center", justifyContent: "center", pointerEvents: "auto",
      }}
      onClick={cancel}
    >
      <div className="wood-panel" style={{ width: "min(440px, 92vw)" }} onClick={(e) => e.stopPropagation()}>
        <div className="wood-title">🌱 {lang === "zh" ? "种下一个任务" : "Plant a task"}</div>
        <div style={{ padding: 16 }}>
          <p style={{ margin: "0 0 10px", fontSize: 13 }}>
            {lang === "zh"
              ? "给这株作物起个任务名。浇水 = 推进进度，成熟 = 可收获完成。"
              : "Name this crop after a task. Watering advances it; harvest when mature."}
          </p>
          <input
            ref={inputRef}
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") confirm();
              if (e.key === "Escape") cancel();
            }}
            placeholder={lang === "zh" ? "例如：写完 v4 发布说明" : "e.g. finish the v4 release notes"}
            style={{
              width: "100%", boxSizing: "border-box", padding: "8px 10px",
              border: "3px solid var(--wood)", borderRadius: 4, background: "var(--paper-dark)",
              fontFamily: "inherit", fontSize: 14, color: "var(--ink)", outline: "none",
            }}
          />
          <div style={{ display: "flex", gap: 8, justifyContent: "flex-end", marginTop: 12 }}>
            <button className="wood-btn" onClick={cancel}>{lang === "zh" ? "取消" : "Cancel"}</button>
            <button className="wood-btn" style={{ background: "linear-gradient(180deg,#9be564,#5cb83a)" }} onClick={confirm}>
              {lang === "zh" ? "种下 🌱" : "Plant 🌱"}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

function Toast() {
  const { toast } = useUI();
  if (!toast) return null;
  return (
    <div
      className="wood-panel fade-in"
      style={{
        position: "absolute", top: 16, left: "50%", transform: "translateX(-50%)",
        padding: "8px 18px", fontSize: 13.5, maxWidth: "80vw", pointerEvents: "none",
      }}
    >
      {toast}
    </div>
  );
}

export function GameUI() {
  const { openDialogue, openBuilding, setClock, setLive, setPlantCell, setToast } = useUI();

  useEffect(() => {
    let toastTimer: number | undefined;
    const offs = [
      bus.on("npc:talk", ({ agentId, activityZh, activityEn }) =>
        openDialogue(agentId, activityZh ? { zh: activityZh, en: activityEn ?? activityZh } : null)),
      bus.on("building:enter", ({ buildingId }) => openBuilding(buildingId)),
      bus.on("building:enter-panel", ({ panel }) => {
        const b = BUILDINGS.find((bb) => bb.panel === panel);
        if (b) openBuilding(b.id);
      }),
      bus.on("clock:tick", (c) => setClock(c)),
      bus.on("mode:detected", ({ live }) => setLive(live)),
      bus.on("farm:plant-request", ({ cell }) => {
        audio.click();
        setPlantCell(cell);
      }),
      bus.on("toast", ({ text }) => {
        setToast(text);
        window.clearTimeout(toastTimer);
        toastTimer = window.setTimeout(() => setToast(null), 2600);
      }),
    ];
    return () => {
      offs.forEach((off) => off());
      window.clearTimeout(toastTimer);
    };
  }, [openDialogue, openBuilding, setClock, setLive, setPlantCell, setToast]);

  return (
    <div className="pixel-font" style={{ position: "fixed", inset: 0, pointerEvents: "none" }}>
      <Hud />
      <Toast />
      <DialogueBox />
      <BuildingPanel />
      <PlantDialog />
    </div>
  );
}
