import Phaser from "phaser";
import { TILE, MAP_W, MAP_H, BUILDINGS, AGENTS, PLAZA, FARM, type AgentDef } from "@/data/town";
import { generateTown, type TownLayout } from "@/game/world/mapgen";
import { bus } from "@/shared/bus";

const WATER_FRAMES = 4;
const DAY_MINUTES = 24 * 60;
/** one in-game day = 12 real minutes */
const MINUTES_PER_SECOND = DAY_MINUTES / (12 * 60);

interface Npc {
  def: AgentDef;
  sprite: Phaser.Physics.Arcade.Sprite;
  label: Phaser.GameObjects.Text;
  emote: Phaser.GameObjects.Sprite;
  state: "idle" | "walk" | "talk";
  target: Phaser.Math.Vector2 | null;
  nextThink: number;
}

export class TownScene extends Phaser.Scene {
  private layout!: TownLayout;
  private collide!: boolean[][];
  private player!: Phaser.Physics.Arcade.Sprite;
  private cursors!: Phaser.Types.Input.Keyboard.CursorKeys;
  private wasd!: Record<"W" | "A" | "S" | "D" | "E" | "F", Phaser.Input.Keyboard.Key>;
  private npcs: Npc[] = [];
  private waterTiles: Phaser.Tilemaps.Tile[] = [];
  private waterFrame = 0;
  private nightOverlay!: Phaser.GameObjects.Rectangle;
  private lampGlows: Phaser.GameObjects.Arc[] = [];
  private clockMin = 8 * 60; // start 08:00
  private day = 1;
  private moveTarget: Phaser.Math.Vector2 | null = null;
  private following = true;
  private dragging = false;
  private dragStart = new Phaser.Math.Vector2();
  private camStart = new Phaser.Math.Vector2();
  private uiLock = false;
  private doorZones: { id: string; rect: Phaser.Geom.Rectangle }[] = [];
  private hintText!: Phaser.GameObjects.Text;

  constructor() {
    super("town");
  }

  create(): void {
    this.layout = generateTown();
    this.collide = this.layout.collide.map((r) => [...r]);

    this.buildGround();
    this.buildDecor();
    this.buildPlaza();
    this.buildBuildings();
    this.buildPlayer();
    this.buildNpcs();
    this.buildAnimals();
    this.buildLighting();
    this.bindInput();
    this.bindBus();

    this.cameras.main.fadeIn(750, 26, 20, 35);

    this.cameras.main.setBounds(0, 0, MAP_W * TILE, MAP_H * TILE);
    this.cameras.main.setZoom(3);
    this.cameras.main.startFollow(this.player, true, 0.12, 0.12);

    this.time.addEvent({ delay: 260, loop: true, callback: () => this.cycleWater() });
    this.time.addEvent({ delay: 1000, loop: true, callback: () => this.tickClock() });

    // dev hook for camera control from the console / preview tooling
    (window as unknown as Record<string, unknown>).__town = this;
  }

  /** dev helper: jump camera to a tile (used by preview tooling) */
  lookAt(tx: number, ty: number, zoom = 3): void {
    this.following = false;
    this.cameras.main.stopFollow();
    this.cameras.main.setZoom(zoom);
    this.cameras.main.centerOn(tx * TILE, ty * TILE);
  }

  // ------------------------------------------------------------------ ground
  private buildGround(): void {
    const map = this.make.tilemap({ tileWidth: TILE, tileHeight: TILE, width: MAP_W, height: MAP_H });
    const tsWater = map.addTilesetImage("water", "ts-water", TILE, TILE, 0, 0)!;
    const tsGrass = map.addTilesetImage("grass", "ts-grass", TILE, TILE, 0, 0)!;
    const tsDirt = map.addTilesetImage("dirt", "ts-dirt", TILE, TILE, 0, 0)!;

    const water = map.createBlankLayer("water", tsWater)!;
    const grass = map.createBlankLayer("grass", tsGrass)!;
    const path = map.createBlankLayer("path", tsDirt)!;
    water.setDepth(0);
    grass.setDepth(1);
    path.setDepth(2);

    for (let y = 0; y < MAP_H; y++) {
      for (let x = 0; x < MAP_W; x++) {
        const t = water.putTileAt(tsWater.firstgid, x, y);
        if (this.layout.isWater[y][x]) this.waterTiles.push(t);
        const g = this.layout.grass[y][x];
        if (g != null) grass.putTileAt(tsGrass.firstgid + g, x, y);
        const p = this.layout.path[y][x];
        if (p != null) path.putTileAt(tsDirt.firstgid + p, x, y);
      }
    }
    // farm soil beds stamped on the path layer (plain dirt fills)
    for (const c of this.layout.farmSoil) {
      path.putTileAt(tsDirt.firstgid + [0, 1, 2][(c.tx + c.ty) % 3], c.tx, c.ty);
    }
  }

  private cycleWater(): void {
    this.waterFrame = (this.waterFrame + 1) % WATER_FRAMES;
    for (const t of this.waterTiles) t.index = t.tileset!.firstgid + this.waterFrame;
  }

  // ------------------------------------------------------------------- decor
  private buildDecor(): void {
    for (const b of this.layout.bushes) {
      this.add.image(b.tx * TILE + 8, b.ty * TILE + 8, "decor-biom", b.frame).setDepth(b.ty * TILE + 8);
    }
    for (const f of this.layout.fences) {
      this.add.image(f.tx * TILE + 8, f.ty * TILE + 8, "ts-fences", f.frame).setDepth(f.ty * TILE + 4);
    }
    for (const t of this.layout.trees) {
      const img = t.small
        ? this.add.image(t.tx * TILE + 8, (t.ty + 1) * TILE, "decor-oak-small", 1)
        : this.add.image(t.tx * TILE + 8, (t.ty + 1) * TILE, "decor-oak");
      img.setOrigin(0.5, 1).setDepth((t.ty + 1) * TILE);
    }
    // a few crops in the farm beds (visual flavor; real task-crops come via panel)
    const plantFrames = [0, 1, 2, 3, 4, 5];
    let i = 0;
    for (const c of this.layout.farmSoil) {
      if ((c.tx + c.ty * 3) % 5 !== 0) continue;
      this.add.image(c.tx * TILE + 8, c.ty * TILE + 6, "decor-plants", plantFrames[i++ % plantFrames.length])
        .setDepth(c.ty * TILE + 6);
    }
  }

  // ------------------------------------------------------------------- plaza
  /** Dress the spawn plaza so the first thing players see matches the rest
   * of the town: notice board, lamp posts, tulip beds, logs, a shade oak. */
  private buildPlaza(): void {
    const img = (tx: number, ty: number, key: string, frame?: number, solid = true) => {
      const o = frame === undefined
        ? this.add.image(tx * TILE + 8, (ty + 1) * TILE, key)
        : this.add.image(tx * TILE + 8, (ty + 1) * TILE, key, frame);
      o.setOrigin(0.5, 1).setDepth((ty + 1) * TILE);
      if (solid) this.collide[ty][tx] = true;
      return o;
    };

    img(29, 18, "decor-sign");                       // notice board by spawn
    for (const [lx, ly] of [[27, 17], [37, 17], [27, 21], [37, 21]] as const) {
      img(lx, ly, "decor-lamp");
      // warm halo — only breathes after dusk (gated in tickClock)
      const glow = this.add.circle(lx * TILE + 8, ly * TILE - 24, 14, 0xffc966, 0)
        .setDepth(15000).setBlendMode(Phaser.BlendModes.ADD);
      this.lampGlows.push(glow);
    }
    // tulip beds (outdoor decor sheet rows 8-9)
    const tulips = [56, 57, 58, 59, 63, 64];
    const beds: [number, number][] = [
      [28, 17], [29, 17], [35, 17], [36, 17],
      [28, 21], [29, 21], [35, 21], [36, 21],
      [30, 16], [34, 16],
    ];
    beds.forEach(([fx, fy], i) => {
      this.add.image(fx * TILE + 8, fy * TILE + 12, "decor-outdoor", tulips[i % tulips.length])
        .setOrigin(0.5, 1).setDepth(fy * TILE + 12);
    });
    // log benches + a shade oak
    img(33, 21, "decor-outdoor", 49);
    img(34, 21, "decor-outdoor", 50);
    img(36, 19, "decor-oak-small", 1);
  }

  // --------------------------------------------------------------- buildings
  private buildBuildings(): void {
    for (const b of BUILDINGS) {
      const px = b.tx * TILE + TILE / 2;
      const py = (b.ty + 1) * TILE;
      const img = this.add.image(px, py, b.texture).setOrigin(0.5, 1).setDepth(py - 2);

      const wTiles = Math.ceil(img.width / TILE);
      const hTiles = Math.ceil(img.height / TILE);
      const x0 = b.tx - Math.floor(wTiles / 2);
      // block the building footprint except the door tile and the row below the eaves
      for (let dy = 1; dy < Math.min(hTiles, 5); dy++) {
        const y = b.ty - dy + 1;
        if (y < 0) continue;
        for (let x = x0; x < x0 + wTiles; x++) {
          if (x < 0 || x >= MAP_W) continue;
          if (dy === 1 && x === b.tx) continue; // doorway
          this.collide[y][x] = true;
        }
      }
      this.doorZones.push({
        id: b.id,
        rect: new Phaser.Geom.Rectangle((b.tx - 1) * TILE, (b.ty - 1) * TILE, TILE * 3, TILE * 2.2),
      });

      // door label
      this.add
        .text(px, py - img.height - 4, b.nameZh, {
          fontFamily: "'Microsoft YaHei', sans-serif",
          fontSize: "8px",
          color: "#fff7e6",
          stroke: "#5a3b28",
          strokeThickness: 3,
          resolution: 4,
        })
        .setOrigin(0.5, 1)
        .setDepth(10000);
    }
  }

  // ------------------------------------------------------------------ player
  private buildPlayer(): void {
    this.player = this.physics.add.sprite(PLAZA.tx * TILE + 8, PLAZA.ty * TILE + 8, "char-player", 0);
    this.player.body!.setSize(12, 10);
    (this.player.body as Phaser.Physics.Arcade.Body).setOffset(18, 30);
    this.player.setDepth(this.player.y);
  }

  // -------------------------------------------------------------------- npcs
  private buildNpcs(): void {
    for (const def of AGENTS) {
      const sprite = this.physics.add.sprite(def.tx * TILE + 8, def.ty * TILE + 8, def.texture, 0);
      sprite.body!.setSize(12, 10);
      (sprite.body as Phaser.Physics.Arcade.Body).setOffset(18, 30);
      sprite.setInteractive({ useHandCursor: true });
      const label = this.add
        .text(sprite.x, sprite.y - 26, def.nameZh, {
          fontFamily: "'Microsoft YaHei', sans-serif",
          fontSize: "7px",
          color: "#ffffff",
          stroke: "#3d2b1f",
          strokeThickness: 3,
          resolution: 4,
        })
        .setOrigin(0.5, 1)
        .setDepth(10000)
        .setAlpha(0.92);
      const emote = this.add.sprite(sprite.x, sprite.y - 34, "ui-emotes", 0).setVisible(false).setDepth(10001);
      this.npcs.push({ def, sprite, label, emote, state: "idle", target: null, nextThink: 0 });
      sprite.on("pointerdown", (p: Phaser.Input.Pointer) => {
        if (p.getDistance() < 6) this.tryTalk(def.id);
      });
    }
  }

  private buildAnimals(): void {
    const cow = this.physics.add.sprite((FARM.x + 2) * TILE, (FARM.y - 3) * TILE, "anim-cow", 0);
    cow.play("cow-idle").setDepth(cow.y);
    for (let i = 0; i < 3; i++) {
      const ch = this.physics.add.sprite((FARM.x + 5 + i * 2) * TILE, (FARM.y - 2.2) * TILE, "anim-chicken", 0);
      ch.play({ key: "chicken-peck", delay: i * 350 }).setDepth(ch.y);
    }
  }

  // ---------------------------------------------------------------- lighting
  private buildLighting(): void {
    const cam = this.cameras.main;
    this.nightOverlay = this.add
      .rectangle(0, 0, cam.width, cam.height, 0x0b1030, 0)
      .setOrigin(0)
      .setScrollFactor(0)
      .setDepth(20000);
    this.hintText = this.add
      .text(cam.width / 2, cam.height - 8, "", {
        fontFamily: "'Microsoft YaHei', sans-serif",
        fontSize: "12px",
        color: "#fff7e6",
        stroke: "#5a3b28",
        strokeThickness: 4,
        resolution: 3,
      })
      .setOrigin(0.5, 1)
      .setScrollFactor(0)
      .setDepth(20001);
  }

  private tickClock(): void {
    this.clockMin += MINUTES_PER_SECOND;
    if (this.clockMin >= DAY_MINUTES) {
      this.clockMin -= DAY_MINUTES;
      this.day += 1;
    }
    const hour = Math.floor(this.clockMin / 60);
    const minute = Math.floor(this.clockMin % 60);
    const season = ["春", "夏", "秋", "冬"][Math.floor(((this.day - 1) % 28) / 7)];
    bus.emit("clock:tick", { day: this.day, hour, minute, season });

    // night tint: dusk 18-20, night 20-5, dawn 5-7
    const h = this.clockMin / 60;
    let a = 0;
    if (h >= 18 && h < 20) a = ((h - 18) / 2) * 0.55;
    else if (h >= 20 || h < 5) a = 0.55;
    else if (h >= 5 && h < 7) a = (1 - (h - 5) / 2) * 0.55;
    this.nightOverlay.fillAlpha = a;
    const lampOn = a > 0.18;
    for (const g of this.lampGlows) {
      g.setAlpha(lampOn ? 0.16 + (Math.sin(this.time.now / 600) + 1) * 0.07 : 0);
    }
  }

  // ------------------------------------------------------------------- input
  private bindInput(): void {
    this.cursors = this.input.keyboard!.createCursorKeys();
    this.wasd = this.input.keyboard!.addKeys("W,A,S,D,E,F") as TownScene["wasd"];

    this.input.on("wheel", (_p: unknown, _o: unknown, _dx: number, dy: number) => {
      const cam = this.cameras.main;
      const z = Phaser.Math.Clamp(cam.zoom - Math.sign(dy) * 0.25, 1.5, 5);
      cam.setZoom(z);
    });

    this.input.on("pointerdown", (p: Phaser.Input.Pointer) => {
      this.dragging = false;
      this.dragStart.set(p.x, p.y);
      this.camStart.set(this.cameras.main.scrollX, this.cameras.main.scrollY);
    });
    this.input.on("pointermove", (p: Phaser.Input.Pointer) => {
      if (!p.isDown) return;
      const dist = Phaser.Math.Distance.Between(p.x, p.y, this.dragStart.x, this.dragStart.y);
      if (dist > 8) {
        this.dragging = true;
        this.following = false;
        this.cameras.main.stopFollow();
        const cam = this.cameras.main;
        cam.setScroll(
          this.camStart.x - (p.x - this.dragStart.x) / cam.zoom,
          this.camStart.y - (p.y - this.dragStart.y) / cam.zoom,
        );
      }
    });
    this.input.on("pointerup", (p: Phaser.Input.Pointer) => {
      if (this.dragging || this.uiLock) return;
      const world = this.cameras.main.getWorldPoint(p.x, p.y);
      // building door click?
      for (const z of this.doorZones) {
        if (z.rect.contains(world.x, world.y)) {
          this.enterBuilding(z.id);
          return;
        }
      }
      this.moveTarget = new Phaser.Math.Vector2(world.x, world.y);
    });
  }

  private bindBus(): void {
    bus.on("dialogue:closed", () => {
      this.uiLock = false;
      for (const n of this.npcs) if (n.state === "talk") n.state = "idle";
    });
    bus.on("panel:closed", () => {
      this.uiLock = false;
    });
  }

  private tryTalk(agentId: string): void {
    if (this.uiLock) return;
    const npc = this.npcs.find((n) => n.def.id === agentId);
    if (!npc) return;
    const d = Phaser.Math.Distance.Between(this.player.x, this.player.y, npc.sprite.x, npc.sprite.y);
    if (d > TILE * 3.2) {
      this.moveTarget = new Phaser.Math.Vector2(npc.sprite.x, npc.sprite.y + 8);
      return;
    }
    npc.state = "talk";
    npc.sprite.setVelocity(0, 0);
    const dir = npc.sprite.x > this.player.x ? "left" : "right";
    npc.sprite.play(`${npc.def.id}-idle-${dir}`, true);
    this.uiLock = true;
    bus.emit("npc:talk", { agentId });
  }

  private enterBuilding(id: string): void {
    if (this.uiLock) return;
    this.uiLock = true;
    bus.emit("building:enter", { buildingId: id });
  }

  // ------------------------------------------------------------------ update
  update(time: number): void {
    this.updatePlayer();
    this.updateNpcs(time);
    this.updateHint();
  }

  private isBlocked(px: number, py: number): boolean {
    const tx = Math.floor(px / TILE);
    const ty = Math.floor(py / TILE);
    if (tx < 0 || ty < 0 || tx >= MAP_W || ty >= MAP_H) return true;
    return this.collide[ty][tx];
  }

  /** axis-separated grid collision movement */
  private moveWithCollision(sprite: Phaser.Physics.Arcade.Sprite, vx: number, vy: number, dt: number): void {
    const nx = sprite.x + vx * dt;
    const ny = sprite.y + vy * dt;
    const footY = sprite.y + 12;
    if (vx !== 0 && !this.isBlocked(nx + Math.sign(vx) * 5, footY)) sprite.x = nx;
    const footNY = ny + 12;
    if (vy !== 0 && !this.isBlocked(sprite.x, footNY + (vy > 0 ? 2 : -2))) sprite.y = ny;
    sprite.setDepth(sprite.y);
  }

  private updatePlayer(): void {
    const speed = 85;
    const dt = this.game.loop.delta / 1000;
    let vx = 0;
    let vy = 0;
    if (!this.uiLock) {
      if (this.cursors.left.isDown || this.wasd.A.isDown) vx = -1;
      else if (this.cursors.right.isDown || this.wasd.D.isDown) vx = 1;
      if (this.cursors.up.isDown || this.wasd.W.isDown) vy = -1;
      else if (this.cursors.down.isDown || this.wasd.S.isDown) vy = 1;
    }
    if (vx !== 0 || vy !== 0) {
      this.moveTarget = null;
      this.following = true;
      this.cameras.main.startFollow(this.player, true, 0.12, 0.12);
    } else if (this.moveTarget && !this.uiLock) {
      const d = Phaser.Math.Distance.Between(this.player.x, this.player.y, this.moveTarget.x, this.moveTarget.y);
      if (d < 4) this.moveTarget = null;
      else {
        vx = (this.moveTarget.x - this.player.x) / d;
        vy = (this.moveTarget.y - this.player.y) / d;
      }
    }
    const len = Math.hypot(vx, vy);
    if (len > 0) {
      vx = (vx / len) * speed;
      vy = (vy / len) * speed;
      this.moveWithCollision(this.player, vx, vy, dt);
      const dir = Math.abs(vx) > Math.abs(vy) ? (vx > 0 ? "right" : "left") : vy > 0 ? "down" : "up";
      this.player.play(`player-walk-${dir}`, true);
      bus.emit("player:moved", { tx: Math.floor(this.player.x / TILE), ty: Math.floor(this.player.y / TILE) });
    } else {
      const cur = this.player.anims.currentAnim?.key ?? "player-walk-down";
      const dir = cur.split("-").pop() ?? "down";
      this.player.play(`player-idle-${dir}`, true);
    }
    if (this.wasd.F.isDown && !this.following) {
      this.following = true;
      this.cameras.main.startFollow(this.player, true, 0.12, 0.12);
    }
    if (Phaser.Input.Keyboard.JustDown(this.wasd.E) && !this.uiLock) {
      // nearest npc within reach, else nearest door
      let best: Npc | null = null;
      let bestD = TILE * 2.6;
      for (const n of this.npcs) {
        const d = Phaser.Math.Distance.Between(this.player.x, this.player.y, n.sprite.x, n.sprite.y);
        if (d < bestD) {
          bestD = d;
          best = n;
        }
      }
      if (best) {
        this.tryTalk(best.def.id);
        return;
      }
      for (const z of this.doorZones) {
        if (z.rect.contains(this.player.x, this.player.y)) {
          this.enterBuilding(z.id);
          return;
        }
      }
    }
  }

  private updateNpcs(time: number): void {
    const dt = this.game.loop.delta / 1000;
    for (const n of this.npcs) {
      n.label.setPosition(n.sprite.x, n.sprite.y - 24);
      n.emote.setPosition(n.sprite.x, n.sprite.y - 34);
      const near = Phaser.Math.Distance.Between(this.player.x, this.player.y, n.sprite.x, n.sprite.y) < TILE * 3.2;
      if (near && n.state !== "talk") {
        if (!n.emote.visible) {
          n.emote.setVisible(true);
          n.emote.play("emote-alert");
        }
      } else if (n.emote.visible) {
        n.emote.setVisible(false);
        n.emote.stop();
      }
      if (n.state === "talk") continue;
      if (time > n.nextThink) {
        n.nextThink = time + 2200 + Math.random() * 3800;
        if (n.state === "idle" && Math.random() < 0.65) {
          // wander within 4 tiles of anchor
          const ax = n.def.tx * TILE + 8;
          const ay = n.def.ty * TILE + 8;
          for (let tries = 0; tries < 6; tries++) {
            const tx = ax + (Math.random() * 8 - 4) * TILE;
            const ty = ay + (Math.random() * 6 - 3) * TILE;
            if (!this.isBlocked(tx, ty + 12)) {
              n.target = new Phaser.Math.Vector2(tx, ty);
              n.state = "walk";
              break;
            }
          }
        } else {
          n.state = "idle";
          n.target = null;
        }
      }
      if (n.state === "walk" && n.target) {
        const d = Phaser.Math.Distance.Between(n.sprite.x, n.sprite.y, n.target.x, n.target.y);
        if (d < 3) {
          n.state = "idle";
          n.target = null;
          const cur = n.sprite.anims.currentAnim?.key ?? `${n.def.id}-walk-down`;
          n.sprite.play(`${n.def.id}-idle-${cur.split("-").pop() ?? "down"}`, true);
        } else {
          const sp = 38;
          const vx = ((n.target.x - n.sprite.x) / d) * sp;
          const vy = ((n.target.y - n.sprite.y) / d) * sp;
          this.moveWithCollision(n.sprite, vx, vy, dt);
          const dir = Math.abs(vx) > Math.abs(vy) ? (vx > 0 ? "right" : "left") : vy > 0 ? "down" : "up";
          n.sprite.play(`${n.def.id}-walk-${dir}`, true);
        }
      } else {
        const cur = n.sprite.anims.currentAnim?.key ?? `${n.def.id}-walk-down`;
        const dir = cur.split("-").pop() ?? "down";
        n.sprite.play(`${n.def.id}-idle-${dir}`, true);
      }
    }
  }

  private updateHint(): void {
    let hint = "";
    if (!this.uiLock) {
      for (const n of this.npcs) {
        if (Phaser.Math.Distance.Between(this.player.x, this.player.y, n.sprite.x, n.sprite.y) < TILE * 3.2) {
          hint = `按 E 与 ${n.def.nameZh} 对话`;
          break;
        }
      }
      if (!hint) {
        for (const z of this.doorZones) {
          if (z.rect.contains(this.player.x, this.player.y)) {
            const b = BUILDINGS.find((bb) => bb.id === z.id)!;
            hint = `按 E 进入 ${b.nameZh}`;
            break;
          }
        }
      }
    }
    this.hintText.setText(hint);
  }
}
