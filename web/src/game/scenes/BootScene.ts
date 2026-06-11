import Phaser from "phaser";
import { detectMode } from "@/shared/api";
import { bus } from "@/shared/bus";

interface ManifestEntry {
  key: string;
  url: string;
  type: "image" | "spritesheet";
  frameWidth?: number;
  frameHeight?: number;
}

export class BootScene extends Phaser.Scene {
  constructor() {
    super("boot");
  }

  preload(): void {
    this.load.json("manifest", "assets/manifest.json");
  }

  create(): void {
    const manifest = this.cache.json.get("manifest") as ManifestEntry[];
    for (const e of manifest) {
      if (e.type === "spritesheet") {
        this.load.spritesheet(e.key, e.url, {
          frameWidth: e.frameWidth ?? 16,
          frameHeight: e.frameHeight ?? 16,
        });
      } else {
        this.load.image(e.key, e.url);
      }
    }
    this.load.once(Phaser.Loader.Events.COMPLETE, () => {
      this.createAnims();
      void detectMode().then((m) => bus.emit("mode:detected", { live: m === "live" }));
      this.scene.start("town");
    });
    this.load.start();
  }

  private createAnims(): void {
    // Character sheets: 4x4 grid of 48px frames; rows: down, up, left, right.
    const chars = ["player", "opus", "codex", "sonnet", "haiku", "deepseek", "aris", "pixelcat", "fable"];
    const dirs: [string, number][] = [["down", 0], ["up", 1], ["left", 2], ["right", 3]];
    for (const c of chars) {
      const key = `char-${c}`;
      if (!this.textures.exists(key)) continue;
      for (const [dir, row] of dirs) {
        this.anims.create({
          key: `${c}-walk-${dir}`,
          frames: this.anims.generateFrameNumbers(key, { start: row * 4, end: row * 4 + 3 }),
          frameRate: 7,
          repeat: -1,
        });
        this.anims.create({
          key: `${c}-idle-${dir}`,
          frames: [{ key, frame: row * 4 }],
          frameRate: 1,
        });
      }
    }
    if (this.textures.exists("anim-chicken")) {
      this.anims.create({
        key: "chicken-peck",
        frames: this.anims.generateFrameNumbers("anim-chicken", { start: 0, end: 3 }),
        frameRate: 5,
        repeat: -1,
      });
    }
    if (this.textures.exists("anim-cow")) {
      this.anims.create({
        key: "cow-idle",
        frames: this.anims.generateFrameNumbers("anim-cow", { start: 0, end: 2 }),
        frameRate: 3,
        repeat: -1,
      });
    }
    if (this.textures.exists("ui-emotes")) {
      this.anims.create({
        key: "emote-alert",
        frames: this.anims.generateFrameNumbers("ui-emotes", { start: 0, end: 3 }),
        frameRate: 6,
        repeat: -1,
      });
    }
  }
}
