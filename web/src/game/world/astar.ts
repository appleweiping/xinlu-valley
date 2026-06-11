/** Minimal A* over the town collision grid (64x44 — tiny, no heap needed). */

export function findPath(
  collide: boolean[][],
  sx: number,
  sy: number,
  tx: number,
  ty: number,
  maxIter = 4000,
): { x: number; y: number }[] | null {
  const H = collide.length;
  const W = collide[0].length;
  const inb = (x: number, y: number) => x >= 0 && y >= 0 && x < W && y < H;
  if (!inb(sx, sy) || !inb(tx, ty)) return null;
  if (collide[ty][tx]) {
    // target blocked (e.g. a door tile next to a wall) — try neighbours
    const alt = [[0, 1], [0, -1], [1, 0], [-1, 0]].find(([dx, dy]) =>
      inb(tx + dx, ty + dy) && !collide[ty + dy][tx + dx]);
    if (!alt) return null;
    tx += alt[0];
    ty += alt[1];
  }

  const key = (x: number, y: number) => y * W + x;
  const open = new Map<number, { x: number; y: number; g: number; f: number }>();
  const came = new Map<number, number>();
  const gScore = new Map<number, number>();
  const h = (x: number, y: number) => Math.abs(x - tx) + Math.abs(y - ty);
  const sk = key(sx, sy);
  open.set(sk, { x: sx, y: sy, g: 0, f: h(sx, sy) });
  gScore.set(sk, 0);

  let iter = 0;
  while (open.size > 0 && iter++ < maxIter) {
    let bestK = -1;
    let best: { x: number; y: number; g: number; f: number } | null = null;
    for (const [k, n] of open) {
      if (!best || n.f < best.f) {
        best = n;
        bestK = k;
      }
    }
    if (!best) break;
    open.delete(bestK);
    if (best.x === tx && best.y === ty) {
      const path: { x: number; y: number }[] = [];
      let cur = bestK;
      while (came.has(cur)) {
        path.push({ x: cur % W, y: Math.floor(cur / W) });
        cur = came.get(cur)!;
      }
      return path.reverse();
    }
    for (const [dx, dy] of [[0, 1], [0, -1], [1, 0], [-1, 0]] as const) {
      const nx = best.x + dx;
      const ny = best.y + dy;
      if (!inb(nx, ny) || collide[ny][nx]) continue;
      const nk = key(nx, ny);
      const ng = best.g + 1;
      if (ng < (gScore.get(nk) ?? Infinity)) {
        gScore.set(nk, ng);
        came.set(nk, bestK);
        open.set(nk, { x: nx, y: ny, g: ng, f: ng + h(nx, ny) });
      }
    }
  }
  return null;
}
