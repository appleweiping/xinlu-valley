/** Shared touch-input state.
 *
 * The React joystick writes this singleton; Phaser scenes read it every
 * frame alongside the keyboard. A plain mutable object on purpose —
 * emitting a bus event per joystick frame would be pure noise.
 */
export const touchState = {
  /** normalized -1..1 movement vector from the virtual joystick */
  vx: 0,
  vy: 0,
  /** true while a finger holds the joystick */
  active: false,
};

export function isTouchDevice(): boolean {
  if (typeof window === "undefined") return false;
  if (new URLSearchParams(window.location.search).has("touch")) return true; // desktop testing
  return "ontouchstart" in window || navigator.maxTouchPoints > 0;
}
