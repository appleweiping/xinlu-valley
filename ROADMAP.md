# AI Town Roadmap

This roadmap tracks the move from a rough inherited project to a Godot-first open-source local work game.

## Phase 1: Godot Vertical Slice

- Godot project opens from `godot/project.godot`.
- Player movement, camera, building hotspots, room overlay, NPC/agent selection, dialogue, quests, and badge persistence work.
- FastAPI exposes real local adapters.
- One-click local launch scripts work.
- Smoke and visual capture scripts exist.

Status: in progress, playable foundation exists.

## Phase 2: Real Workflow Buildings

Implemented or underway:

- File Vault
- Memory Library
- Research Hall
- Agent Hub
- Code Workshop
- GitHub Harbor
- Terminal Control
- System Monitor
- Model Market/API Gateway
- Task Board
- Writing Studio
- Automation Factory
- Permission Hall
- Settings Center
- Testing Arena
- Bug Clinic
- Project Management Hall
- Download Station
- Asset Resource Gallery
- Local Office Center
- Schedule and Plan Center
- Learning Training Grounds
- Language Learning Area
- Research Data Center
- Paper Reading Room
- Version Release Plaza
- Backup Station
- Long-Term Goal Tower
- Inspiration Collection Station
- Temporary Draft Box

Next:

- Research log workbench with ARIS audit routing.
- Richer code-task drafting and patch review.
- GitHub issue/PR/release views behind safe gates.
- Plugin registry for new local workspaces and agents.

## Phase 3: Architecture Hardening

- Split monolithic `backend/main.py` into API modules, adapters, permissions, jobs, config, and logs.
- Split monolithic `godot/scripts/main.gd` into API client, world, UI, quests, rooms, and data modules.
- Move quests and workflow definitions into registries.
- Add schema validation for registries. Initial read-only registry health now validates nine Godot JSON registries through `/api/config/registry-health`; richer typed schemas and CI integration remain future work.
- Add persistent job log storage, pause/resume, cancellation, and rollback metadata. Initial backend job lifecycle logs now persist under `workspace/backend-job-logs`, and cancellation metadata plus rollback notes exist; true cooperative runner cancellation remains future hardening.
- Add stronger tests for path allowlists, previews, and confirmation gates.

## Phase 4: Game Feel and Art Pass

- Replace overlay-only rooms with dedicated Godot room scenes. All thirty-five current core workflow buildings now have data-driven interiors and station hotspots; future work should deepen room-specific interactions and art polish rather than merely adding coverage.
- Add richer map regions, portals, building interiors, NPC routines, and room-specific interactions.
- Improve Q-character animation, feedback, tooltips, and collection progression.
- Use `docs\VISUAL_BASELINE.md` as the long-term art contract.
- Expand visual regression artifacts beyond the first smoke screenshot.

## Phase 5: Real Agent Operations

- Connect agent runners through queued, observable jobs.
- Add model routing, tool-call logs, context memory, and failure recovery.
- Add agent task states, streaming logs, retries, and user confirmation gates.
- Keep destructive or external writes separate from ordinary read/draft workflows.

## Phase 6: Open-Source Release

- Keep README, LICENSE, CONTRIBUTING, SECURITY, ROADMAP, architecture docs, and screenshots current.
- Add a clean release checklist and changelog flow.
- Prepare GitHub Actions or local CI once the repo is modular enough.
- Stage, commit, push, and publish only after explicit user approval.
