# Migration & Audit Log — 2026-06-11

ai-town (Godot era) → Xinlu Valley (新路谷物语) web rebuild, relocated to `D:\Company`.

## 1. Pre-migration audit (what was reviewed)

Three parallel read-only surveys covered:

- `D:\Game_develop\ai-town` — full structure, git state, docs, backend (FastAPI,
  15.7k-line `main.py`, 180+ endpoints, 35 building adapters), Godot client
  (10.2k-line `main.gd`), art (anime-storybook style, NOT pixel), registries
  (`godot/data/*.json`), workspace runtime data.
- `D:\devtools` — agentmemory server (port 3111, data `D:\devtools\data`),
  agent launchers (`cc/claude/codex/deepseek/aris/hermes/opencode/pixelcat.cmd`),
  health/selfheal scripts, AGENT-MEMORY-PROTOCOL.md.
- `D:\AGENT_RESOURCE` (+ junction `D:\agent-resources`), `D:\AGENTIC_SCIENCE`
  (UUPF/LWWF/URWF), `D:\Research` (top-level names only — **untouched**),
  `D:\Research\WEIPING_WIKI` (~3.5 GB Obsidian-style), `D:\Company\*`
  (5 active Vercel-linked projects), keys/credentials sweep
  (**no plaintext secrets on disk** — env vars + DPAPI vault only).

## 2. Git checkpoint (recovery point)

- Commit `aff1fb9` "checkpoint: Godot-era final snapshot before Xinlu Valley web
  rebuild" on `main`, tag **`v2-godot-era`**, pushed to
  `https://github.com/appleweiping/pixel-ai-town` **before** any move.
- To restore the old era: `git checkout v2-godot-era`.

## 3. Moves

| What | From | To | Method |
| --- | --- | --- | --- |
| Whole project (incl. `.git`) | `D:\Game_develop\ai-town` | `D:\Company\xinlu-valley` | `Move-Item` (same-volume rename; nothing copied/lost) |

`D:\Game_develop` is now an **empty shell**; deletion was blocked by the
workstation protection hook, so it remains as an empty protected directory
(harmless; can be removed later via the workstation-maintenance flow).

## 4. Deletions (gitignored, rebuildable artifacts only)

| Path (under xinlu-valley) | Size | Recoverability |
| --- | --- | --- |
| `tools/godot/` | 1,635 MB | Godot 4.6.3 editor binaries — re-downloadable from godotengine.org |
| `dist/` | 115 MB | Packaged exe — re-exportable from the godot project at tag `v2-godot-era` |
| `frontend/node_modules/` | 184 MB | `npm install` regenerates |
| `_legacy/` | 285 MB | Archived a16z-fork experiments (was gitignored). Equivalent history exists on remote branches (`a16z-legacy`, `convex/deployed`, …) |
| `.vite/` | ~0 MB | Build cache |

No tracked source, no registries, no keys, no memory data, no wiki data, and no
`D:\Research` content were deleted or modified.

## 5. Path-reference fixes (old `D:\Game_develop` → new locations)

- `D:\devtools\ai-town.cmd` — launcher rewritten for
  `D:\Company\xinlu-valley\backend` + `web` (was backend + legacy frontend).
- `backend/main.py` — `FILE_VAULT_ROOTS`, `DOWNLOAD_STATION_ROOTS`,
  `PROJECT_SCAN_ROOTS`, `/api/inventory` defaults, inline workspace registry:
  `game-dev` root removed; `D:\Company` promoted (project_browser on, critical).
- `godot/data/workspaces.json` — same change, project root now
  `D:\Company\xinlu-valley`.
- `godot/data/buildings.json` — all `real_sources` entries repointed.
- `D:\AGENT_RESOURCE\skills\vipin\workstation-maintenance\SKILL.md` — root list
  updated with a retirement note for `D:\Game_develop`.

Remaining `Game_develop` mentions are only in historical docs
(`README.md`, `MEMORY.md`, `STRUCTURE.md`, `docs/ARCHITECTURE_GODOT_REBUILD.md`,
`design/architecture.md`) — kept as v2-era records; v3 docs replace them.

## 6. Preserved critical assets (verified untouched)

- agentmemory service + data: `D:\devtools\data`, server scripts, MCP package.
- Agent launchers and identities (7 NPC agents in `godot/data/agents.json`).
- All keys: environment variables + `workspace/model-key-vault` (DPAPI) — never
  on disk in plaintext, never committed (`.gitignore` covers `.env*`, vault).
- `D:\Research\**` including WEIPING_WIKI — zero writes.
- `workspace/` runtime drafts/logs/task ledger — moved intact with the project.
