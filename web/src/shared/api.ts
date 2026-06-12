/** Dual-mode data client.
 *
 * LIVE mode  — a local FastAPI bridge (http://localhost:8000) serves real
 *              data from the owner's machine: agentmemory, wiki, research
 *              boards, skills, git projects.
 * DEMO mode  — static sanitized snapshots under /demo/*.json so the public
 *              Vercel deployment is rich without exposing private data.
 */

const LOCAL_BASE = "http://127.0.0.1:8000";

export type Mode = "live" | "demo";

let mode: Mode = "demo";
let detected = false;

export function currentMode(): Mode {
  return mode;
}

export async function detectMode(): Promise<Mode> {
  if (detected) return mode;
  // Spectate links are read-only by contract: always demo data, no probe.
  if (new URLSearchParams(window.location.search).has("spectate")) {
    mode = "demo";
    detected = true;
    return mode;
  }
  // Public deployments can never reach a loopback bridge (the browser blocks
  // private-network requests from https origins) — skip the probe entirely.
  const host = window.location.hostname;
  if (host !== "localhost" && host !== "127.0.0.1") {
    mode = "demo";
    detected = true;
    return mode;
  }
  // two attempts with a generous timeout — under heavy machine load the
  // bridge can take a beat to answer, and a false "demo" sticks for the
  // whole session
  for (let attempt = 0; attempt < 2; attempt++) {
    try {
      const ctrl = new AbortController();
      const t = setTimeout(() => ctrl.abort(), 4000);
      const r = await fetch(`${LOCAL_BASE}/api/health`, { signal: ctrl.signal });
      clearTimeout(t);
      if (r.ok) {
        mode = "live";
        break;
      }
    } catch {
      /* retry once */
    }
  }
  detected = true;
  return mode;
}

async function fetchJson<T>(url: string, timeoutMs = 8000): Promise<T> {
  const ctrl = new AbortController();
  const t = setTimeout(() => ctrl.abort(), timeoutMs);
  try {
    const r = await fetch(url, { signal: ctrl.signal });
    if (!r.ok) throw new Error(`${r.status} ${url}`);
    return (await r.json()) as T;
  } finally {
    clearTimeout(t);
  }
}

/** POST to the live bridge (no demo fallback — callers handle demo mode). */
export async function postData<T>(liveEndpoint: string, body: unknown): Promise<T | null> {
  if (mode !== "live") return null;
  try {
    const ctrl = new AbortController();
    const t = setTimeout(() => ctrl.abort(), 8000);
    const r = await fetch(`${LOCAL_BASE}${liveEndpoint}`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
      signal: ctrl.signal,
    });
    clearTimeout(t);
    if (!r.ok) return null;
    return (await r.json()) as T;
  } catch {
    return null;
  }
}

/** Fetch from the live bridge with a demo-snapshot fallback. */
export async function getData<T>(liveEndpoint: string, demoFile: string): Promise<T> {
  if (mode === "live") {
    try {
      return await fetchJson<T>(`${LOCAL_BASE}${liveEndpoint}`);
    } catch {
      // graceful degradation: live bridge hiccup -> demo snapshot
    }
  }
  return fetchJson<T>(`/demo/${demoFile}`);
}
