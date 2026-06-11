import Phaser from "phaser";
import { createRoot } from "react-dom/client";
import { createElement } from "react";
import { BootScene } from "./scenes/BootScene";
import { TownScene } from "./scenes/TownScene";
import { GameUI } from "@/ui/GameUI";

window.addEventListener("error", (e) => {
  (window as unknown as Record<string, unknown>).__lastError = `${e.message} @ ${e.filename}:${e.lineno}`;
});

const game = new Phaser.Game({
  type: Phaser.AUTO,
  parent: "game-root",
  backgroundColor: "#2a3f54",
  pixelArt: true,
  roundPixels: true,
  scale: {
    mode: Phaser.Scale.RESIZE,
    autoCenter: Phaser.Scale.CENTER_BOTH,
  },
  physics: { default: "arcade" },
  scene: [BootScene, TownScene],
});

(window as unknown as Record<string, unknown>).__game = game;

createRoot(document.getElementById("ui-root")!).render(createElement(GameUI));
