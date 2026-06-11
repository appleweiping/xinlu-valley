# AI Town Project Audit - 2026-05-29

## Verdict

The repository is mid-migration. The old React/Phaser implementation remains useful as a reference for art, UI concepts, and early product intent, but the active rebuild must be the Godot client in `godot/` plus the FastAPI local bridge in `backend/`.

This audit does not authorize destructive deletion of legacy material. Legacy files should stay until the Godot version has equivalent or better functionality and assets are migrated cleanly.

## Keep

- `godot/`: active client path.
- `backend/`: active local data/API bridge.
- `frontend/public/assets/`: reusable generated art source copied into Godot.
- `art/`: art generation scripts and prompts are useful for regenerating consistent assets.
- `docs/pixel-ai-town-vision.md`: useful product north star, but safety scope must evolve from read-only visualization to confirmed real work execution.
- `design/gdd/`: useful gameplay/design reference.
- `tools/verify-smoke.ps1` and `tools/capture-visual-smoke.ps1`: current repeatable verification.
- `PLAN.md`, `STRUCTURE.md`, `MEMORY.md`, `ASSETS.md`: active rebuild docs.

## Keep As Legacy Reference

- `frontend/`: React/Phaser slice. Do not expand this path unless explicitly needed for asset/reference extraction.
- `design/architecture.md`: old Phaser/Tauri architecture. Superseded for active development by `docs/ARCHITECTURE_GODOT_REBUILD.md`.
- Root `README.md`: currently mixed legacy plus Godot update. Needs future rewrite once the Godot vertical slice is richer.

## Replace Or Refactor

- Monolithic `backend/main.py`: acceptable for current slices, but should move toward `backend/api`, `backend/adapters`, `backend/permissions`, `backend/tasks`, and `backend/config`.
- Monolithic `godot/scripts/main.gd`: acceptable for first playable slice, but should split into world, HUD, room panels, API client, quest state, and save manager.
- Hard-coded building/agent definitions in Godot and Python: should move into JSON/YAML registry files consumed by both client and backend.
- Dialogue layer: current direct DeepSeek call is useful, but needs model gateway configuration, audit logging, permissions, and fallback routing.

## Missing For Final Goal

- Dedicated scene/map switching rather than a single overlay room panel.
- Real agent runner integration with task queue, execution logs, permissions, and rollback strategy.
- Controlled terminal execution room.
- GitHub Harbor: repo/branch/commit/issue/release surfaces.
- Real software project browser with git status, tests, README/TODO/architecture extraction.
- Office/document workflow rooms.
- Calendar/planning/task persistence.
- Plugin registry for new buildings, agents, tools, and workspaces.
- API key management that never exposes secrets in logs or git.
- GitHub-ready cleanup: license, contribution guide, security policy, screenshots, and release workflow.

## Current Real Vertical Slice Evidence

- Godot opens from `godot/project.godot`.
- Player can move, select buildings/agents, enter room overlay, and run quests.
- Backend reads real local sources:
  - shared memory: `D:\research\Vipin's Knowledgebase\memory`
  - research projects: `D:\Research`
  - dev tools: `D:\devtools`
  - skills/resources: `D:\agent-resources`
- Memory Library exposes real shelves and bounded note previews.
- Research Hall exposes real project boards and bounded experiment candidates.
- Agent Hub exposes real launcher detection and creates project-local dispatch drafts.
- Smoke verification passes with `tools\verify-smoke.ps1`.
- Visual smoke artifact exists at `screenshots/visual-smoke.png`.

## Safety Boundaries Observed

- No process killing.
- No interruption of running experiments.
- No writes outside the AI Town project during work actions.
- Agent dispatch currently creates local Markdown drafts only; it does not invoke external agents.
- Folder scans are bounded to protect UI responsiveness.
