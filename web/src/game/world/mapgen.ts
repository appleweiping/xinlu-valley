/** Procedural town layout. Pure data — no Phaser imports.
 *
 * Layers (local tile indices; the scene offsets by each tileset's firstgid):
 *  - water: animated base, frame index 0 everywhere (cycled at runtime)
 *  - grass: the walkable island with blob-autotile edges over water
 *  - path:  dirt plazas/roads stamped over grass
 *
 * Sprout Lands "Grass" blob set (10 cols):
 *   fills 0,1,2,10,11,12 (+ light decor 3,4,13,14)
 *   3x3 platform: 31 32 33 / 41 42 43 / 51 52 53  (TL T TR / L C R / BL B BR)
 *   concave cuts: 44=SE 45=SW 54=NE 55=NW   (cut corner faces the water)
 * Sprout Lands "Tilled Dirt" set (8 cols):
 *   fills 0,1,2,8,9,10
 *   3x3 platform: 33 34 35 / 41 42 43 / 49 50 51
 */

import { MAP_W, MAP_H, FARM, BUILDINGS } from "@/data/town";

export interface TownLayout {
  grass: (number | null)[][];
  path: (number | null)[][];
  collide: boolean[][];
  /** water cells that remain visible (outside the island or pond) */
  isWater: boolean[][];
  trees: { tx: number; ty: number; small: boolean }[];
  bushes: { tx: number; ty: number; frame: number }[];
  fences: { tx: number; ty: number; frame: number }[];
  farmSoil: { tx: number; ty: number }[];
}

const G_FILLS = [0, 0, 1, 1, 2, 2, 10, 10, 11, 12, 3, 13];
const G = {
  TL: 31, T: 32, TR: 33, L: 41, C: 42, R: 43, BL: 51, B: 52, BR: 53,
  SE: 44, SW: 45, NE: 54, NW: 55,
  // 1-wide strips and lone blobs
  VT: 20, VM: 30, VM2: 40, VB: 50,   // vertical column: cap top / mids / cap bottom
  HL: 60, HM: 61, HM2: 62, HR: 63,   // horizontal row: cap left / mids / cap right
  ONE: 22,
};
const D = { TL: 33, T: 34, TR: 35, L: 41, C: 42, R: 43, BL: 49, B: 50, BR: 51, FILLS: [0, 1, 2, 8, 9, 10] };

function grid<T>(fill: T): T[][] {
  return Array.from({ length: MAP_H }, () => Array<T>(MAP_W).fill(fill));
}

/** deterministic pseudo-random (stable world across reloads) */
function rng(seed: number) {
  let s = seed >>> 0;
  return () => {
    s = (s * 1664525 + 1013904223) >>> 0;
    return s / 0xffffffff;
  };
}

export function generateTown(): TownLayout {
  const rand = rng(20260611);
  const island = grid(false);
  const isWater = grid(true);

  // --- island shape: big rounded landmass with a south-east pond and an
  // east river strip left as water -----------------------------------------
  const inIsland = (x: number, y: number): boolean => {
    if (x < 2 || y < 2 || x > MAP_W - 3 || y > MAP_H - 3) return false;
    if (x >= 55) return false; // east river
    // south-east pond (rounded rect 44..52 x 33..39; corner cells stay grass)
    if (x >= 44 && x <= 52 && y >= 33 && y <= 39) {
      const corner = (x === 44 || x === 52) && (y === 33 || y === 39);
      if (!corner) return false;
    }
    // soften island corners
    const dx = Math.min(x - 2, MAP_W - 3 - 55 + (55 - x), 54 - x);
    const dy = Math.min(y - 2, MAP_H - 3 - y);
    if (dx + dy < 2) return false;
    return true;
  };

  for (let y = 0; y < MAP_H; y++) {
    for (let x = 0; x < MAP_W; x++) {
      island[y][x] = inIsland(x, y);
      if (island[y][x]) isWater[y][x] = false;
    }
  }

  // --- grass layer with blob autotile edges --------------------------------
  const grass = grid<number | null>(null);
  const at = (x: number, y: number) => (x >= 0 && y >= 0 && x < MAP_W && y < MAP_H ? island[y][x] : false);
  for (let y = 0; y < MAP_H; y++) {
    for (let x = 0; x < MAP_W; x++) {
      if (!island[y][x]) continue;
      const n = at(x, y - 1), s = at(x, y + 1), w = at(x - 1, y), e = at(x + 1, y);
      const nw = at(x - 1, y - 1), ne = at(x + 1, y - 1), sw = at(x - 1, y + 1), se = at(x + 1, y + 1);
      let t: number;
      if (!n && !s && !w && !e) t = G.ONE;
      else if (!w && !e) t = !n ? G.VT : !s ? G.VB : (x + y) % 2 ? G.VM : G.VM2; // 1-wide column
      else if (!n && !s) t = !w ? G.HL : !e ? G.HR : (x + y) % 2 ? G.HM : G.HM2; // 1-wide row
      else if (!n && !w) t = G.TL;
      else if (!n && !e) t = G.TR;
      else if (!s && !w) t = G.BL;
      else if (!s && !e) t = G.BR;
      else if (!n) t = G.T;
      else if (!s) t = G.B;
      else if (!w) t = G.L;
      else if (!e) t = G.R;
      else if (!nw) t = G.NW;
      else if (!ne) t = G.NE;
      else if (!sw) t = G.SW;
      else if (!se) t = G.SE;
      else t = G_FILLS[Math.floor(rand() * G_FILLS.length)];
      grass[y][x] = t;
    }
  }

  // --- dirt paths -----------------------------------------------------------
  const path = grid<number | null>(null);

  const stampRect = (x0: number, y0: number, x1: number, y1: number) => {
    for (let y = y0; y <= y1; y++) {
      for (let x = x0; x <= x1; x++) {
        let t: number;
        if (y === y0 && x === x0) t = D.TL;
        else if (y === y0 && x === x1) t = D.TR;
        else if (y === y1 && x === x0) t = D.BL;
        else if (y === y1 && x === x1) t = D.BR;
        else if (y === y0) t = D.T;
        else if (y === y1) t = D.B;
        else if (x === x0) t = D.L;
        else if (x === x1) t = D.R;
        else t = D.FILLS[Math.floor(rand() * D.FILLS.length)];
        path[y][x] = t;
      }
    }
  };

  /** 3-wide road; vertical or horizontal, with bordered edges */
  const road = (x0: number, y0: number, x1: number, y1: number) => {
    if (x0 === x1) {
      const [a, b] = y0 < y1 ? [y0, y1] : [y1, y0];
      for (let y = a; y <= b; y++) {
        path[y][x0 - 1] = path[y][x0 - 1] ?? D.L;
        path[y][x0] = D.FILLS[Math.floor(rand() * D.FILLS.length)];
        path[y][x0 + 1] = path[y][x0 + 1] ?? D.R;
      }
    } else {
      const [a, b] = x0 < x1 ? [x0, x1] : [x1, x0];
      for (let x = a; x <= b; x++) {
        path[y0 - 1][x] = path[y0 - 1][x] ?? D.T;
        path[y0][x] = D.FILLS[Math.floor(rand() * D.FILLS.length)];
        path[y0 + 1][x] = path[y0 + 1][x] ?? D.B;
      }
    }
  };

  // plaza + roads to each building door
  stampRect(26, 16, 38, 22);
  road(32, 16, 32, 11);          // plaza -> town hall
  road(32, 22, 32, 27);          // plaza -> market/south
  road(26, 19, 19, 19);          // plaza -> west (library row)
  road(19, 19, 19, 13);          // up to library door
  road(24, 16, 24, 9);           // up to agent inn
  road(38, 19, 47, 19);          // east road -> research hall
  road(47, 19, 47, 17);
  road(52, 19, 52, 10);          // spur up to knowledge tower
  road(38, 19, 52, 19);          // continue east
  road(40, 22, 40, 25);          // south-east to code workshop
  road(15, 19, 15, 23);          // west-south to skill workshop
  road(26, 22, 12, 22);          // long west road
  road(12, 22, 12, 30);          // down to farm/house
  road(12, 30, 10, 30);
  road(17, 30, 17, 34);          // to greenhouse

  // --- farm soil ------------------------------------------------------------
  const farmSoil: { tx: number; ty: number }[] = [];
  for (let y = FARM.y; y < FARM.y + FARM.h; y++) {
    for (let x = FARM.x; x < FARM.x + FARM.w; x++) {
      if ((x - FARM.x) % 4 === 3) continue; // walking gaps between beds
      farmSoil.push({ tx: x, ty: y });
    }
  }

  // --- fences around the farm (frame guesses verified visually) -------------
  const fences: { tx: number; ty: number; frame: number }[] = [];
  const fx0 = FARM.x - 1, fy0 = FARM.y - 1, fx1 = FARM.x + FARM.w, fy1 = FARM.y + FARM.h;
  for (let x = fx0; x <= fx1; x++) {
    if (x !== FARM.x + 1 && x !== FARM.x + 2) fences.push({ tx: x, ty: fy0, frame: 1 }); // gate gap on top
    fences.push({ tx: x, ty: fy1, frame: 1 });
  }
  for (let y = fy0 + 1; y < fy1; y++) {
    fences.push({ tx: fx0, ty: y, frame: 4 });
    fences.push({ tx: fx1, ty: y, frame: 4 });
  }

  // --- trees & bushes --------------------------------------------------------
  const trees: { tx: number; ty: number; small: boolean }[] = [];
  const bushes: { tx: number; ty: number; frame: number }[] = [];
  const occupied = grid(false);
  const blockNear = (tx: number, ty: number, r: number) => {
    for (const b of BUILDINGS) {
      if (Math.abs(b.tx - tx) <= r + 4 && Math.abs(b.ty - ty) <= r + 3) return true;
    }
    return false;
  };
  for (let i = 0; i < 240; i++) {
    const x = 3 + Math.floor(rand() * (MAP_W - 10));
    const y = 3 + Math.floor(rand() * (MAP_H - 6));
    if (!island[y][x] || path[y][x] != null || occupied[y][x]) continue;
    if (x >= FARM.x - 2 && x <= FARM.x + FARM.w + 1 && y >= FARM.y - 2 && y <= FARM.y + FARM.h + 1) continue;
    if (blockNear(x, y, 1)) continue;
    const edgeBias = x < 7 || y < 7 || x > 48 || y > MAP_H - 8;
    if (!edgeBias && rand() > 0.25) continue;
    if (rand() < 0.62) {
      const small = rand() < 0.35;
      trees.push({ tx: x, ty: y, small });
      occupied[y][x] = true;
      if (!small) {
        if (x > 0) occupied[y][x - 1] = true;
        if (x + 1 < MAP_W) occupied[y][x + 1] = true;
      }
    } else {
      bushes.push({ tx: x, ty: y, frame: Math.floor(rand() * 12) });
      occupied[y][x] = true;
    }
  }

  // --- collision -------------------------------------------------------------
  const collide = grid(false);
  for (let y = 0; y < MAP_H; y++) {
    for (let x = 0; x < MAP_W; x++) {
      if (!island[y][x]) collide[y][x] = true; // water
    }
  }
  for (const t of trees) {
    collide[t.ty][t.tx] = true;
    if (!t.small && t.tx > 0) collide[t.ty][t.tx - 1] = true;
  }
  for (const f of fences) collide[f.ty][f.tx] = true;

  return { grass, path, collide, isWater, trees, bushes, fences, farmSoil };
}
