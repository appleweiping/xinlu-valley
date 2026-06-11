import Phaser from "phaser";
import { createRoot } from "react-dom/client";
import { createElement } from "react";
import { BootScene } from "./scenes/BootScene";
import { TownScene } from "./scenes/TownScene";
import { GameUI } from "@/ui/GameUI";

new Phaser.Game({
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

createRoot(document.getElementById("ui-root")!).render(createElement(GameUI));
