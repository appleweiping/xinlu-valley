/** In-page E2E smoke harness (?v4test=1).
 *
 * Drives a full v4 feature pass inside the running game and streams every
 * step (JSON + canvas screenshots) to the local bridge, which persists them
 * under workspace/v4-report.jsonl + workspace/v4-shots/. Verification thus
 * survives flaky browser tooling — evidence lands on disk step by step.
 * Dev/owner tool: it only ever talks to 127.0.0.1.
 */
import type Phaser from "phaser";

const BASE = "http://127.0.0.1:8000";

interface TownLike extends Phaser.Scene {
  clockMin: number;
  npcs: { def: { id: string }; state: string; insideBuilding: string | null }[];
  crops: Map<number, { cell: number; title: string; progress: number; taskId?: string }>;
  enterBuilding(id: string): void;
  plantCrop(cell: number, title: string): Promise<void>;
  waterCrop(c: unknown): Promise<void>;
  harvestCrop(c: unknown): Promise<void>;
  lookAt(tx: number, ty: number, zoom?: number): void;
}

function sleep(ms: number): Promise<void> {
  return new Promise((r) => setTimeout(r, ms));
}

async function report(step: string, data: unknown, withShot = false): Promise<void> {
  let image: string | undefined;
  if (withShot) {
    image = await shot();
  }
  try {
    await fetch(`${BASE}/api/town/test-report`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ step, data, image }),
    });
  } catch {
    /* bridge down — nothing to persist to */
  }
}

function shot(): Promise<string | undefined> {
  return new Promise((resolve) => {
    const game = (window as unknown as { __game?: Phaser.Game }).__game;
    if (!game) return resolve(undefined);
    try {
      game.renderer.snapshot((img) => {
        resolve((img as HTMLImageElement).src);
      });
    } catch {
      resolve(undefined);
    }
  });
}

function town(): TownLike | null {
  return ((window as unknown as { __town?: TownLike }).__town as TownLike) ?? null;
}

export async function maybeRunV4Test(): Promise<void> {
  if (!new URLSearchParams(window.location.search).has("v4test")) return;

  // wait for the town
  for (let i = 0; i < 60 && !town(); i++) await sleep(500);
  const t = town();
  if (!t) {
    void report("boot", { ok: false, error: "town never became ready" });
    return;
  }
  await report("boot", { ok: true, live: document.body.innerText.includes("联机") }, true);

  // --- schedules: jump to work hours, watch residents head inside ----------
  t.clockMin = 9 * 60 + 58;
  await sleep(9000);
  await report(
    "schedules",
    t.npcs.map((n) => `${n.def.id}:${n.state}${n.insideBuilding ? "@" + n.insideBuilding : ""}`),
    true,
  );

  // --- interior: enter the library, look around, leave ---------------------
  t.enterBuilding("memory-library");
  await sleep(4000);
  const interior = (window as unknown as { __game: Phaser.Game }).__game.scene.getScene("interior") as
    | (Phaser.Scene & { residents?: { id: string }[]; leave?: () => void })
    | null;
  await report(
    "interior-library",
    {
      active: !!interior?.scene.isActive(),
      residents: interior?.residents?.map((r) => r.id) ?? [],
    },
    true,
  );
  interior?.leave?.();
  await sleep(2500);
  await report("interior-exit", { townActive: t.scene.isActive() }, true);

  // --- farm: plant -> water x3 -> harvest (live mode writes the ledger) ----
  t.lookAt(12, 37, 3);
  const cell = 0;
  await (t as unknown as { plantCrop(c: number, s: string): Promise<void> }).plantCrop(cell, "v4 验收作物");
  await sleep(1200);
  await report("farm-plant", { crop: snap(t, cell) }, true);
  for (let i = 0; i < 3; i++) {
    const c = t.crops.get(cell);
    if (c) await (t as unknown as { waterCrop(c: unknown): Promise<void> }).waterCrop(c);
    await sleep(700);
  }
  await report("farm-watered", { crop: snap(t, cell) }, true);
  const mature = t.crops.get(cell);
  if (mature) await (t as unknown as { harvestCrop(c: unknown): Promise<void> }).harvestCrop(mature);
  await sleep(1200);
  await report("farm-harvest", { remaining: snap(t, cell) }, true);

  // --- dialogue bridge ------------------------------------------------------
  let reply = "";
  try {
    const r = await fetch(`${BASE}/api/town/dialogue`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ agentId: "sonnet", message: "记忆图书馆最近有什么新书？" }),
    });
    reply = String((await r.json()).reply ?? "");
  } catch (e) {
    reply = `ERR ${String(e)}`;
  }
  await report("dialogue", { reply });

  // --- audio + save ----------------------------------------------------------
  const game = (window as unknown as { __game: Phaser.Game }).__game;
  await report("audio-save", {
    bgmCached: game.cache.audio.exists("audio-bgm"),
    sfxCached: game.cache.audio.exists("audio-harvest"),
    saveExists: !!localStorage.getItem("nrv-save-v1"),
  });

  await report("done", { ok: true });
  document.title = "V4TEST-DONE";
}

function snap(t: TownLike, cell: number): unknown {
  const c = t.crops.get(cell);
  return c ? { title: c.title, progress: c.progress, taskId: c.taskId ?? null } : null;
}
