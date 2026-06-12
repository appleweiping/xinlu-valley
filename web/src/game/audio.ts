/** Tiny audio facade. All sounds are optional — missing files degrade to
 * silence (the loader tolerates 404s), so the game never hard-depends on
 * the CC0 audio set. BGM starts on the first user gesture (autoplay rules).
 */
import Phaser from "phaser";

const KEYS = {
  bgm: "audio-bgm",
  step: "audio-step",
  door: "audio-door",
  page: "audio-page",
  water: "audio-water",
  harvest: "audio-harvest",
  plant: "audio-plant",
  click: "audio-click",
} as const;

export const AUDIO_FILES: { key: string; url: string }[] = [
  { key: KEYS.bgm, url: "assets/open/audio/bgm-valley.ogg" },
  { key: KEYS.step, url: "assets/open/audio/sfx-step.ogg" },
  { key: KEYS.door, url: "assets/open/audio/sfx-door.ogg" },
  { key: KEYS.page, url: "assets/open/audio/sfx-page.ogg" },
  { key: KEYS.water, url: "assets/open/audio/sfx-water.ogg" },
  { key: KEYS.harvest, url: "assets/open/audio/sfx-harvest.ogg" },
  { key: KEYS.plant, url: "assets/open/audio/sfx-plant.ogg" },
  { key: KEYS.click, url: "assets/open/audio/sfx-click.ogg" },
];

class Audio {
  private game: Phaser.Game | null = null;
  private bgmStarted = false;
  private lastStep = 0;
  muted = localStorage.getItem("nrv-muted") === "1";
  private master = (() => {
    const v = Number(localStorage.getItem("nrv-volume"));
    return Number.isFinite(v) && localStorage.getItem("nrv-volume") !== null ? Math.max(0, Math.min(1, v)) : 1;
  })();

  attach(game: Phaser.Game): void {
    this.game = game;
    const kick = () => {
      this.startBgm();
      if (this.bgmStarted) {
        window.removeEventListener("pointerdown", kick);
        window.removeEventListener("keydown", kick);
      }
    };
    window.addEventListener("pointerdown", kick);
    window.addEventListener("keydown", kick);
  }

  private has(key: string): boolean {
    return !!this.game && this.game.cache.audio.exists(key);
  }

  private play(key: string, volume: number): void {
    if (this.muted || !this.game || !this.has(key)) return;
    try {
      this.game.sound.play(key, { volume: volume * this.master });
    } catch {
      /* locked audio context etc. — stay silent */
    }
  }

  startBgm(): void {
    if (this.bgmStarted || this.muted || !this.game || !this.has(KEYS.bgm)) return;
    try {
      this.game.sound.play(KEYS.bgm, { loop: true, volume: 0.35 * this.master });
      this.bgmStarted = true;
    } catch {
      /* retry on next gesture */
    }
  }

  setMuted(m: boolean): void {
    this.muted = m;
    localStorage.setItem("nrv-muted", m ? "1" : "0");
    if (!this.game) return;
    this.game.sound.mute = m;
    if (!m) this.startBgm();
  }

  /** master volume 0..1 (persisted; multiplies every per-clip volume) */
  get volume(): number {
    return this.master;
  }

  setVolume(v: number): void {
    this.master = Math.max(0, Math.min(1, v));
    localStorage.setItem("nrv-volume", String(this.master));
    // best-effort manager-level set too (running bgm reacts immediately)
    try {
      if (this.game) this.game.sound.volume = this.master;
    } catch {
      /* some sound managers ignore this — per-clip multiply still applies */
    }
  }

  applySavedVolume(): void {
    try {
      if (this.game) this.game.sound.volume = this.master;
    } catch {
      /* per-clip multiply still applies */
    }
  }

  step(): void {
    const now = performance.now();
    if (now - this.lastStep < 320) return;
    this.lastStep = now;
    this.play(KEYS.step, 0.25);
  }

  door(): void { this.play(KEYS.door, 0.5); }
  page(): void { this.play(KEYS.page, 0.5); }
  water(): void { this.play(KEYS.water, 0.5); }
  harvest(): void { this.play(KEYS.harvest, 0.55); }
  plant(): void { this.play(KEYS.plant, 0.5); }
  click(): void { this.play(KEYS.click, 0.4); }
}

export const audio = new Audio();
