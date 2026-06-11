import { useEffect } from "react";
import { bus } from "@/shared/bus";
import { useUI } from "./store";
import { DialogueBox } from "./DialogueBox";
import { BuildingPanel } from "./BuildingPanel";
import { Hud } from "./Hud";
import "./pixel.css";

export function GameUI() {
  const { openDialogue, openBuilding, setClock, setLive } = useUI();

  useEffect(() => {
    const offs = [
      bus.on("npc:talk", ({ agentId }) => openDialogue(agentId)),
      bus.on("building:enter", ({ buildingId }) => openBuilding(buildingId)),
      bus.on("clock:tick", (c) => setClock(c)),
      bus.on("mode:detected", ({ live }) => setLive(live)),
    ];
    return () => offs.forEach((off) => off());
  }, [openDialogue, openBuilding, setClock, setLive]);

  return (
    <div className="pixel-font" style={{ position: "fixed", inset: 0, pointerEvents: "none" }}>
      <Hud />
      <DialogueBox />
      <BuildingPanel />
    </div>
  );
}
