/** URL feature flags, resolved once at module load.
 *
 * spectate — read-only share links: forces DEMO data and hides every
 * write-looking action, so a visitor can wander the town but never
 * touch the owner's task ledger (the bridge is unreachable anyway).
 */
export const SPECTATE: boolean =
  typeof window !== "undefined" &&
  new URLSearchParams(window.location.search).has("spectate");

// surfaced for the in-page e2e harness
if (typeof window !== "undefined") {
  (window as unknown as Record<string, unknown>).__flags = { spectate: SPECTATE };
}
