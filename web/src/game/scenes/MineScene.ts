import Phaser from "phaser";
import { bus } from "@/shared/bus";
import { getData } from "@/shared/api";
import { audio } from "@/game/audio";
import { touchState } from "@/shared/touch";
import { spendStamina, loadSave, writeSave } from "@/shared/save";

const T = 16;
const W = 15;
const H = 11;
const MAX_LEVEL = 6;
/** levels this deep are dark — the lamp carves a circle of light */
const DARK_FROM = 4;

/** cold stone walls (mystic walls.png frame map, see InteriorScene) */
const WALL = {
  capTL: 0, capT: 1, capTR: 3,
  faceTL: 32, faceT: 33, faceTR: 35,
  faceBL: 40, faceB: 41, faceBR: 43,
  sideL: 8, sideR: 11,
  botL: 24, botT: 25, botR: 27,
};

interface Ore {
  id: string;
  kind: string;
  title: string;
  file: string;
  repo: string;
  depth: number;
}

const KIND_TINT: Record<string, number> = {
  todo: 0x9fd6ff,    // sky crystal
  hack: 0xffd27a,    // amber crystal
  fixme: 0xff9b9b,   // danger crystal
  hotspot: 0xc99bff, // violet crystal
  vein1: 0xcfd6dd,   // silver sediment
  vein2: 0xffd27a,   // gold sediment
  vein3: 0xff9bd2,   // rose sediment (the really old stuff)
};

interface OreNode {
  ore: Ore;
  sprite: Phaser.GameObjects.Image;
  hits: number;
  tx: number;
  ty: number;
  collected: boolean;
}

interface EnterData {
  level: number;
  returnTx: number;
  returnTy: number;
}

/** The tech-debt mines: each level holds ore mined from real TODO/FIXME
 * comments and git hotspots. Hit a node three times to extract the debt
 * card; deeper levels carry heavier debt. */
export class MineScene extends Phaser.Scene {
  private level = 1;
  private enterData!: EnterData;
  private player!: Phaser.GameObjects.Sprite;
  private playerShadow!: Phaser.GameObjects.Ellipse;
  private cursors!: Phaser.Types.Input.Keyboard.CursorKeys;
  private wasd!: Record<"W" | "A" | "S" | "D" | "E", Phaser.Input.Keyboard.Key>;
  private collide: boolean[][] = [];
  private nodes: OreNode[] = [];
  private ladder: { tx: number; ty: number } | null = null;
  private hint!: Phaser.GameObjects.Text;
  private moveTarget: { x: number; y: number } | null = null;
  private leaving = false;
  private oresPool: Ore[] = [];
  private uiLock = false;
  private touchInteract = false;
  private veinsPool: Ore[] = [];
  private darkness: Phaser.GameObjects.RenderTexture | null = null;
  private lampBrush: string | null = null;
  private cartTile: [number, number] | null = null;
  private chestTile: [number, number] | null = null;
  private chestSprite: Phaser.GameObjects.Image | null = null;

  constructor() {
    super("mine");
  }

  init(data: EnterData): void {
    this.enterData = data;
    this.level = data.level || 1;
    this.leaving = false;
    this.uiLock = false;
    this.nodes = [];
    this.ladder = null;
    this.moveTarget = null;
    this.darkness = null;
    this.cartTile = null;
    this.chestTile = null;
    this.chestSprite = null;
    // track the deepest descent — it unlocks the minecart
    const save = loadSave();
    if (save && this.level > (save.deepestLevel ?? 1)) {
      save.deepestLevel = this.level;
      writeSave(save);
      bus.emit("mine:depth", { level: this.level });
    }
  }

  create(): void {
    this.collide = Array.from({ length: H }, () => Array<boolean>(W).fill(false));
    this.buildCave();
    void this.populate();

    this.playerShadow = this.add.ellipse(7 * T + 16, (H - 1) * T - 4, 16, 6, 0x000000, 0.4).setDepth(2.5);
    this.player = this.add.sprite(7 * T + 16, (H - 1) * T - 18, "char-player", 0);
    this.player.setDepth(this.player.y);

    this.cursors = this.input.keyboard!.createCursorKeys();
    this.wasd = this.input.keyboard!.addKeys("W,A,S,D,E") as MineScene["wasd"];
    // scene restarts per level — unhook on shutdown or listeners pile up
    const offTouch = bus.on("touch:interact", () => {
      if (this.scene.isActive()) this.touchInteract = true;
    });
    this.events.once(Phaser.Scenes.Events.SHUTDOWN, offTouch);

    this.hint = this.add
      .text(this.cameras.main.width / 2, this.cameras.main.height - 8, "", {
        fontFamily: "'Microsoft YaHei', sans-serif",
        fontSize: "12px", color: "#ffe9c0", stroke: "#241a12", strokeThickness: 4, resolution: 3,
      })
      .setOrigin(0.5, 1).setScrollFactor(0).setDepth(20001);

    this.add
      .text(this.cameras.main.width / 2, 10, `技术债矿洞 · 第 ${this.level} 层`, {
        fontFamily: "'Microsoft YaHei', sans-serif",
        fontSize: "13px", color: "#c9b8ff", stroke: "#241a12", strokeThickness: 4, resolution: 3,
      })
      .setOrigin(0.5, 0).setScrollFactor(0).setDepth(20001);

    const cam = this.cameras.main;
    cam.setBounds(0, 0, W * T, H * T);
    cam.setZoom(Math.max(3, Math.floor(Math.min(cam.width / (W * T), cam.height / (H * T)) * 2) / 2));
    cam.centerOn((W * T) / 2, (H * T) / 2);
    cam.fadeIn(320, 8, 6, 12);

    // lantern glow ambience
    for (const [lx, ly] of [[2, 2], [12, 2]] as const) {
      const glow = this.add.circle(lx * T + 8, ly * T + 8, 26, 0xffb45e, 0.13)
        .setDepth(15000).setBlendMode(Phaser.BlendModes.ADD);
      this.tweens.add({ targets: glow, alpha: 0.22, duration: 1400, yoyo: true, repeat: -1 });
    }

    // v12: minecart home after you've been deep once; chest on the last floor
    if (this.level >= 3) {
      this.cartTile = [2, 8];
      this.add.image(2 * T + 8, 9 * T, "prop-minecart").setOrigin(0.5, 1).setDepth(9 * T);
      this.collide[8][2] = true;
    }
    if (this.level === MAX_LEVEL && !(loadSave()?.treasureClaimed ?? false)) {
      this.chestTile = [7, 4];
      this.chestSprite = this.add.image(7 * T + 8, 5 * T, "prop-chest").setOrigin(0.5, 1).setDepth(5 * T);
      this.collide[4][7] = true;
    }
    if (this.level >= DARK_FROM) this.buildDarkness();

    this.input.on("pointerup", (p: Phaser.Input.Pointer) => {
      if (this.uiLock) return;
      const world = cam.getWorldPoint(p.x, p.y);
      this.moveTarget = { x: world.x, y: world.y };
    });

    const offs = [
      bus.on("panel:closed", () => { this.uiLock = false; }),
      bus.on("dialogue:closed", () => { this.uiLock = false; }),
    ];
    this.events.once(Phaser.Scenes.Events.SHUTDOWN, () => offs.forEach((off) => off()));
  }

  private buildCave(): void {
    // dark dirt floor: reuse wooden floor heavily darkened reads as packed earth
    for (let y = 2; y < H; y++) {
      for (let x = 0; x < W; x++) {
        this.add.image(x * T + 8, y * T + 8, "ts-floor-wooden", 0).setDepth(0).setTint(0x4a4038);
      }
    }
    const put = (frame: number, tx: number, ty: number, depth = 1) =>
      this.add.image(tx * T + 8, ty * T + 8, "ts-walls", frame).setDepth(depth).setTint(0x9a92a8);
    for (let x = 0; x < W; x++) {
      put(x === 0 ? WALL.capTL : x === W - 1 ? WALL.capTR : WALL.capT, x, 0);
      put(x === 0 ? WALL.faceTL : x === W - 1 ? WALL.faceTR : WALL.faceT, x, 1);
      put(x === 0 ? WALL.faceBL : x === W - 1 ? WALL.faceBR : WALL.faceB, x, 2);
      this.collide[0][x] = this.collide[1][x] = this.collide[2][x] = true;
    }
    for (let y = 3; y < H - 1; y++) {
      put(WALL.sideL, 0, y);
      put(WALL.sideR, W - 1, y);
      this.collide[y][0] = this.collide[y][W - 1] = true;
    }
    const gap = (x: number) => x === 7 || x === 8;
    for (let x = 0; x < W; x++) {
      if (gap(x)) continue;
      put(x === 0 ? WALL.botL : x === W - 1 ? WALL.botR : WALL.botT, x, H - 1, (H - 1) * T + 8);
      this.collide[H - 1][x] = true;
    }
  }

  private async populate(): Promise<void> {
    // deep floors mine sediment veins (stale dependency manifests);
    // upper floors mine debt comments and hotspots
    if (this.level >= DARK_FROM) {
      if (this.veinsPool.length === 0) {
        try {
          const d = await getData<{ veins: { id: string; repo: string; file: string; ageDays: number; rarity: number }[] }>(
            "/api/town/deps", "deps.json",
          );
          this.veinsPool = (d.veins ?? []).map((v) => ({
            id: v.id,
            kind: `vein${Math.max(1, Math.min(3, v.rarity))}`,
            title: `${v.file}（${v.ageDays} 天未动）`,
            file: v.file,
            repo: v.repo,
            depth: 3,
          }));
        } catch {
          this.veinsPool = [];
        }
        if (this.veinsPool.length === 0) {
          // live answered but empty (e.g. fresh tree) — the demo pool keeps
          // the deep floors worth digging
          try {
            const demo = await (await fetch("/demo/deps.json")).json() as { veins: { id: string; repo: string; file: string; ageDays: number; rarity: number }[] };
            this.veinsPool = (demo.veins ?? []).map((v) => ({
              id: v.id,
              kind: `vein${Math.max(1, Math.min(3, v.rarity))}`,
              title: `${v.file}（${v.ageDays} 天未动）`,
              file: v.file,
              repo: v.repo,
              depth: 3,
            }));
          } catch {
            /* truly nothing to mine */
          }
        }
      }
      this.placeNodes(this.veinsPool);
      this.placeLadderAndExit();
      return;
    }
    if (this.oresPool.length === 0) {
      try {
        const d = await getData<{ ores: Ore[] }>("/api/town/debt", "debt.json");
        this.oresPool = d.ores;
      } catch {
        this.oresPool = [];
      }
    }
    // this level's ore: depth match (deeper level = heavier debt), pad with any
    const want = this.oresPool.filter((o) => o.depth === Math.min(3, this.level));
    const pool = [...want, ...this.oresPool.filter((o) => o.depth !== Math.min(3, this.level))];
    this.placeNodes(pool);
    this.placeLadderAndExit();
  }

  private placeNodes(pool: Ore[]): void {
    const spots: [number, number][] = [[3, 4], [6, 5], [10, 4], [12, 6], [4, 7], [9, 7]];
    const count = Math.min(spots.length, Math.max(3, 3 + Math.min(3, this.level)));
    for (let i = 0; i < count && i < pool.length; i++) {
      const [tx, ty] = spots[i];
      if (this.chestTile && tx === this.chestTile[0] && ty === this.chestTile[1]) continue;
      const ore = pool[(this.level * 7 + i * 3) % pool.length];
      const sprite = this.add.image(tx * T + 8, (ty + 1) * T, "prop-ore-node")
        .setOrigin(0.5, 1).setDepth((ty + 1) * T)
        .setTint(KIND_TINT[ore.kind] ?? 0x9fd6ff);
      this.collide[ty][tx] = true;
      this.nodes.push({ ore, sprite, hits: 0, tx, ty, collected: false });
    }
  }

  private placeLadderAndExit(): void {
    if (this.level < MAX_LEVEL) {
      this.ladder = { tx: 12, ty: 8 };
      this.add.image(12 * T + 8, 8 * T + 8, "prop-ladder-down").setDepth(2);
    }
  }

  /** deep-floor darkness: a render texture punched through by the lamp */
  private buildDarkness(): void {
    if (!this.lampBrush || !this.textures.exists(this.lampBrush)) {
      const size = 192;
      const cv = this.textures.createCanvas("lamp-brush", size, size);
      if (cv) {
        const ctx = cv.getContext();
        const g = ctx.createRadialGradient(size / 2, size / 2, 8, size / 2, size / 2, size / 2);
        g.addColorStop(0, "rgba(255,255,255,1)");
        g.addColorStop(0.55, "rgba(255,255,255,0.85)");
        g.addColorStop(1, "rgba(255,255,255,0)");
        ctx.fillStyle = g;
        ctx.fillRect(0, 0, size, size);
        cv.refresh();
        this.lampBrush = "lamp-brush";
      }
    }
    this.darkness = this.add.renderTexture(0, 0, W * T, H * T)
      .setOrigin(0).setDepth(18000);
  }

  private updateDarkness(): void {
    if (!this.darkness || !this.player) return;
    this.darkness.clear();
    this.darkness.fill(0x05030a, 0.62 + Math.min(0.18, (this.level - DARK_FROM) * 0.09));
    if (this.lampBrush) {
      this.darkness.erase(this.lampBrush, this.player.x - 96, this.player.y - 96);
    }
  }

  private isBlocked(px: number, py: number): boolean {
    const tx = Math.floor(px / T);
    const ty = Math.floor(py / T);
    if (tx < 0 || ty < 0 || tx >= W || ty >= H) return true;
    return this.collide[ty][tx];
  }

  update(): void {
    if (!this.player || this.leaving) return;
    const speed = 80;
    const dt = this.game.loop.delta / 1000;
    let vx = 0;
    let vy = 0;
    if (!this.uiLock) {
      if (this.cursors.left.isDown || this.wasd.A.isDown) vx = -1;
      else if (this.cursors.right.isDown || this.wasd.D.isDown) vx = 1;
      if (this.cursors.up.isDown || this.wasd.W.isDown) vy = -1;
      else if (this.cursors.down.isDown || this.wasd.S.isDown) vy = 1;
      if (vx === 0 && vy === 0 && touchState.active) {
        vx = touchState.vx;
        vy = touchState.vy;
      }
    }
    if (vx !== 0 || vy !== 0) this.moveTarget = null;
    else if (this.moveTarget && !this.uiLock) {
      const d = Phaser.Math.Distance.Between(this.player.x, this.player.y, this.moveTarget.x, this.moveTarget.y);
      if (d < 3) this.moveTarget = null;
      else {
        vx = (this.moveTarget.x - this.player.x) / d;
        vy = (this.moveTarget.y - this.player.y) / d;
      }
    }
    const len = Math.hypot(vx, vy);
    if (len > 0) {
      vx = (vx / len) * speed * dt;
      vy = (vy / len) * speed * dt;
      const footY = this.player.y + 10;
      if (vx !== 0 && !this.isBlocked(this.player.x + vx + Math.sign(vx) * 4, footY)) this.player.x += vx;
      if (vy !== 0 && !this.isBlocked(this.player.x, footY + vy + (vy > 0 ? 2 : -2))) this.player.y += vy;
      if (this.isBlocked(this.player.x, this.player.y + 10)) {
        this.player.x -= vx;
        this.player.y -= vy;
      }
      this.player.setDepth(this.player.y);
      const dir = Math.abs(vx) > Math.abs(vy) ? (vx > 0 ? "right" : "left") : vy > 0 ? "down" : "up";
      this.player.play(`player-walk-${dir}`, true);
      audio.step();
    } else {
      const cur = this.player.anims.currentAnim?.key ?? "player-walk-down";
      this.player.play(`player-idle-${cur.split("-").pop() ?? "down"}`, true);
    }
    this.playerShadow.setPosition(this.player.x, this.player.y + 12);

    // exit through the bottom gap
    const ptx = Math.floor(this.player.x / T);
    if ((ptx === 7 || ptx === 8) && this.player.y >= (H - 1) * T - 2) {
      this.leave();
      return;
    }

    // nearest interactable
    let hint = "走到下方门口离开";
    let target: OreNode | null = null;
    for (const n of this.nodes) {
      if (n.collected) continue;
      const d = Phaser.Math.Distance.Between(this.player.x, this.player.y, n.tx * T + 8, n.ty * T + 8);
      if (d < T * 1.9) {
        target = n;
        hint = `按 E 开采 [${n.ore.kind.toUpperCase()}] ${n.ore.title.slice(0, 18)}…（${n.hits}/3）`;
        break;
      }
    }
    let onLadder = false;
    if (!target && this.ladder) {
      const d = Phaser.Math.Distance.Between(this.player.x, this.player.y, this.ladder.tx * T + 8, this.ladder.ty * T + 8);
      if (d < T * 1.6) {
        onLadder = true;
        hint = `按 E 下到第 ${this.level + 1} 层`;
      }
    }
    let onCart = false;
    if (!target && !onLadder && this.cartTile) {
      const d = Phaser.Math.Distance.Between(this.player.x, this.player.y, this.cartTile[0] * T + 8, this.cartTile[1] * T + 8);
      if (d < T * 1.7) {
        onCart = true;
        hint = "按 E 乘矿车回到地面";
      }
    }
    let onChest = false;
    if (!target && !onLadder && !onCart && this.chestTile && this.chestSprite) {
      const d = Phaser.Math.Distance.Between(this.player.x, this.player.y, this.chestTile[0] * T + 8, this.chestTile[1] * T + 8);
      if (d < T * 1.7) {
        onChest = true;
        hint = "按 E 打开矿底宝箱";
      }
    }
    this.hint.setText(this.uiLock ? "" : hint);
    this.updateDarkness();

    const touchE = this.touchInteract;
    this.touchInteract = false;
    if ((Phaser.Input.Keyboard.JustDown(this.wasd.E) || touchE) && !this.uiLock) {
      if (target) {
        this.hitNode(target);
      } else if (onLadder) {
        this.cameras.main.fadeOut(240, 8, 6, 12);
        this.time.delayedCall(280, () => {
          this.scene.restart({ level: this.level + 1, returnTx: this.enterData.returnTx, returnTy: this.enterData.returnTy });
        });
      } else if (onCart) {
        bus.emit("toast", { text: "🛤 矿车吱呀作响，载你回到了地面" });
        this.leave();
      } else if (onChest) {
        this.openChest();
      }
    }
  }

  private openChest(): void {
    if (!this.chestSprite || !this.chestTile) return;
    const save = loadSave();
    if (save?.treasureClaimed) return;
    audio.harvest();
    this.cameras.main.flash(400, 255, 220, 120);
    const sparkle = this.add.particles(this.chestTile[0] * T + 8, this.chestTile[1] * T, "prop-ore-node", {
      speed: { min: 20, max: 60 }, scale: { start: 0.25, end: 0 },
      tint: 0xffd27a, lifespan: 900, emitting: false,
    }).setDepth(19000);
    sparkle.explode(14, 0, 0);
    this.time.delayedCall(1200, () => sparkle.destroy());
    this.collide[this.chestTile[1]][this.chestTile[0]] = false;
    this.chestSprite.destroy();
    this.chestSprite = null;
    bus.emit("treasure:claimed", undefined);
  }

  private hitNode(n: OreNode): void {
    if (!spendStamina(3)) return;
    n.hits += 1;
    audio.plant();
    this.cameras.main.shake(70, 0.004);
    this.tweens.add({ targets: n.sprite, x: n.sprite.x + 2, duration: 45, yoyo: true, repeat: 1 });
    if (n.hits === 2) {
      n.sprite.setTexture("prop-ore-node-cracked");
      n.sprite.setTint(KIND_TINT[n.ore.kind] ?? 0x9fd6ff);
    }
    if (n.hits >= 3 && !n.collected) {
      n.collected = true;
      this.collide[n.ty][n.tx] = false;
      audio.harvest();
      const pop = this.add.image(n.sprite.x, n.sprite.y - 10, "prop-ore-node")
        .setOrigin(0.5, 1).setScale(0.7).setDepth(99999)
        .setTint(KIND_TINT[n.ore.kind] ?? 0x9fd6ff);
      this.tweens.add({
        targets: pop, y: pop.y - 16, alpha: 0, duration: 800, ease: "Cubic.easeOut",
        onComplete: () => pop.destroy(),
      });
      n.sprite.destroy();
      bus.emit("ore:collected", { title: n.ore.title, kind: n.ore.kind, repo: n.ore.repo, file: n.ore.file });
    }
  }

  private leave(): void {
    if (this.leaving) return;
    this.leaving = true;
    audio.door();
    this.cameras.main.fadeOut(260, 8, 6, 12);
    this.time.delayedCall(300, () => {
      this.scene.stop();
      this.scene.wake("town", { returnTx: this.enterData.returnTx, returnTy: this.enterData.returnTy });
    });
  }
}
