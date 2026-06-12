/* Newroad Valley service worker — offline-capable PWA.
 *
 * Strategy:
 *   /assets, /demo, /audio, /icons  -> cache-first (immutable game data)
 *   everything else (html, js)      -> network-first with cache fallback
 *   localhost:8000 (live bridge)    -> never touched
 *
 * Bump VER on every release so stale caches drain.
 */
const VER = "nrv-v6.0.0";

self.addEventListener("install", () => {
  self.skipWaiting();
});

self.addEventListener("activate", (e) => {
  e.waitUntil(
    caches
      .keys()
      .then((keys) => Promise.all(keys.filter((k) => k !== VER).map((k) => caches.delete(k))))
      .then(() => self.clients.claim()),
  );
});

self.addEventListener("fetch", (e) => {
  const req = e.request;
  if (req.method !== "GET") return;
  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return; // bridge & CDNs pass through

  const cacheFirst = /^\/(assets|demo|audio|icons)\//.test(url.pathname);
  if (cacheFirst) {
    e.respondWith(
      caches.open(VER).then((c) =>
        c.match(req).then(
          (hit) =>
            hit ||
            fetch(req).then((r) => {
              if (r.ok) c.put(req, r.clone());
              return r;
            }),
        ),
      ),
    );
  } else {
    e.respondWith(
      fetch(req)
        .then((r) => {
          if (r.ok) {
            const copy = r.clone();
            caches.open(VER).then((c) => c.put(req, copy));
          }
          return r;
        })
        .catch(() => caches.open(VER).then((c) => c.match(req)).then((hit) => hit || Response.error())),
    );
  }
});
