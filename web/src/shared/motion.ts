/** Reduced-motion preference: skips decorative particles (snow, rain,
 * fireworks, confetti, chimney smoke). Gameplay effects still apply —
 * rain waters crops whether or not you can see it. */

const KEY = "nrv-reduced-motion";

export function reducedMotion(): boolean {
  return localStorage.getItem(KEY) === "1";
}

export function setReducedMotion(v: boolean): void {
  localStorage.setItem(KEY, v ? "1" : "0");
}
