# 新路谷物语 Newroad Valley — v3 (Stardew-style web rebuild)

A Stardew-style pixel town over the owner's real local work system
(agentmemory, wiki, research metadata, skills, git). Relocated from
`D:\Game_develop\ai-town` on 2026-06-11 (see docs/MIGRATION-2026-06-11.md).
The v2 Godot era is preserved at git tag `v2-godot-era`.

## Stack & layout

- `web/` — Vite + TS. Phaser 3 renders the world (`src/game/`), React renders
  panels/dialogue (`src/ui/`), landing page in `src/landing/`. Path alias `@ = src`.
- `backend/` — FastAPI local bridge on :8000. `main.py` is the large v2
  monolith (kept; hardened job queue). New v3 endpoints live in
  `backend/town_api.py` under `/api/town/*` — add panel data there, not in main.py.
- `data/` — canonical JSON registries (agents, buildings, model profiles…).
- `tools/build-assets.py` — regenerates `web/public/assets/core/` from
  `art/packs/`. Run after changing recolors/buildings: `python tools/build-assets.py`.

## Commands

- web dev: `cd web && npm run dev` (5173) · build: `npm run build` (tsc + vite)
- backend: `cd backend && python -m uvicorn main:app --port 8000 --reload`
- both: `D:\devtools\ai-town.cmd`

## Hard rules

- **Never commit**: `art/packs/`, `web/public/assets/core/` (licensed-pack
  derived; free tiers forbid redistribution), `.env*`, `workspace/`,
  screenshots. Check `git status` before `git add -A` — background processes
  may drop files into the tree.
- **Never read `D:\Research` file contents** from game/bridge code — directory
  names and mtimes only.
- **Demo snapshots** (`web/public/demo/*.json`) are public: no real research
  titles, no private paths, no key names with values. Live data flows only
  through localhost.
- Memory writes follow `D:\devtools\AGENT-MEMORY-PROTOCOL.md`
  (project: `newroad-valley`, concepts must include `agent:cc`).

## Game data model

- World: 64×44 tiles of 16px, procedural in `web/src/game/world/mapgen.ts`
  (deterministic seed). Buildings/NPCs defined in `web/src/data/town.ts`.
- Dual data mode: `web/src/shared/api.ts` probes `127.0.0.1:8000/api/health`
  (1.5s) → LIVE, else DEMO snapshots. Panels share shapes with the bridge
  (`web/src/shared/types.ts` ⇆ `backend/town_api.py`).
- Sprout Lands grass autotile indices are documented in `mapgen.ts` header;
  verify any tile-index change visually (run dev + screenshot) before commit.

## Verification

- `cd web && npx tsc --noEmit` must pass.
- `python -m py_compile backend/main.py backend/town_api.py` must pass.
- Visual check: load /play.html, confirm no console errors, world renders,
  a building panel opens with data.
